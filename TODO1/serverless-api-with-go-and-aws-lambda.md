> * 原文地址：[How to build a Serverless API with Go and AWS Lambda](http://www.alexedwards.net/blog/serverless-api-with-go-and-aws-lambda)
> * 原文作者：[Alex Edwards](http://www.alexedwards.net)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/serverless-api-with-go-and-aws-lambda.md](https://github.com/xitu/gold-miner/blob/master/TODO1/serverless-api-with-go-and-aws-lambda.md)
> * 译者：
> * 校对者：

# How to build a Serverless API with Go and AWS Lambda

Earlier this year AWS announced that their [Lambda](https://aws.amazon.com/lambda/) service would now be providing first-class support for the Go language, which is a great step forward for any gophers (like myself) who fancy experimenting with serverless technology.

So in this post I'm going to talk through how to create a HTTPS API backed by AWS Lambda, building it up step-by-step. I found there to be quite a few gotchas in the process — especially if you're not familiar the AWS permissions system — and some rough edges in the way that Lamdba interfaces with the other AWS services. But once you get your head around these it works pretty well.

There's a lot of content to cover in this tutorial, so I've broken it down into the following seven steps:

1.  [Setting up the AWS CLI](#setup-and-the-aws-cli)
2.  [Creating and deploying an Lambda function](#creating-and-deploying-an-lambda-function)
3.  [Hooking it up to DynamoDB](#hooking-it-up-to-dynamodb)
4.  [Setting up the HTTPS API](#setting-up-the-https-api)
5.  [Working with events](#working-with-events)
6.  [Deploying the API](#deploying-the-api)
7.  [Supporting multiple actions](#supporting-multiple-actions)

Throughout this post we'll work towards building an API with two actions:

| Method | Path | Action |
| ------ | ---- | ------ |
| GET | /books?isbn=xxx | Display information about a book with a specific ISBN |
| POST | /books | Create a new book |

Where a book is a basic JSON record which looks like this:

```
{"isbn":"978-1420931693","title":"The Republic","author":"Plato"}
```

I'm keeping the API deliberately simple to avoid getting bogged-down in application-specific code, but once you've grasped the basics it's fairly clear how to extend the API to support additional routes and actions.

## Setting up the AWS CLI

1.  Throughout this tutorial we'll use the AWS CLI (command line interface) to configure our lambda functions and other AWS services. Installation and basic usage instructions can be [found here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html), but if you’re using a Debian-based system like Ubuntu you can install the CLI with `apt` and run it using the `aws` command:

    ```
    $ sudo apt install awscli
    $ aws --version
    aws-cli/1.11.139 Python/3.6.3 Linux/4.13.0-37-generic botocore/1.6.6
    ```

2.  Next we need to set up an AWS IAM user with _programmatic access_ permission for the CLI to use. A guide on how to do this can be [found here](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html). For testing purposes you can attach the all-powerful `AdministratorAccess` managed policy to this user, but in practice I would recommend using a more restrictive policy. At the end of setting up the user you'll be given a access key ID and secret access key. Make a note of these — you’ll need them in the next step.

3.  Configure the CLI to use the credentials of the IAM user you've just created using the `configure` command. You’ll also need to specify the [default region](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html) and [output format](https://docs.aws.amazon.com/cli/latest/userguide/controlling-output.html) you want the CLI to use.

    ```
    $ aws configure
    AWS Access Key ID [None]: access-key-ID
    AWS Secret Access Key [None]: secret-access-key
    Default region name [None]: us-east-1
    Default output format [None]: json
    ```

    (Throughout this tutorial I'll assume you're using the `us-east-1` region — you'll need to change the code snippets accordingly if you're using a different region.)

## Creating and deploying an Lambda function

1.  Now for the exciting part: making a lambda function. If you're following along, go to your `$GOPATH/src` folder and create a `books` repository containing a `main.go` file.

    ```
    $ cd ~/go/src
    $ mkdir books && cd books
    $ touch main.go
    ```

2.  Next you'll need to install the [](https://github.com/aws/aws-lambda-go)`github.com/aws-lambda-go/lambda` package. This provides the essential libraries and types we need for creating a lambda function in Go.

    ```
    $ go get github.com/aws/aws-lambda-go/lambda
    ```

3.  Then open up the `main.go` file and add the following code:

    File: books/main.go

    ```
    package main

    import (
        "github.com/aws/aws-lambda-go/lambda"
    )

    type book struct {
        ISBN   string `json:"isbn"`
        Title  string `json:"title"`
        Author string `json:"author"`
    }

    func show() (*book, error) {
        bk := &book{
            ISBN:   "978-1420931693",
            Title:  "The Republic",
            Author: "Plato",
        }

        return bk, nil
    }

    func main() {
        lambda.Start(show)
    }
    ```

    In the `main()` function we call `lambda.Start()` and pass in the `show` function as the lambda _handler_. In this case the handler simply initializes and returns a new `book` object.

    Lamdba handlers can take a variety of different signatures and reflection is used to determine exactly which signature you're using. The full list of supported forms is…

    ```
    func()
    func() error
    func(TIn) error
    func() (TOut, error)
    func(TIn) (TOut, error)
    func(context.Context) error
    func(context.Context, TIn) error
    func(context.Context) (TOut, error)
    func(context.Context, TIn) (TOut, error)
    ```

    … where the `TIn` and `TOut` parameters are objects that can be marshaled (and unmarshalled) by Go's `encoding/json` package.

4.  The next step is to build an executable from the `books` package using `go build`. In the code snippet below I'm using the `-o` flag to save the executable to `/tmp/main` but you can save it to any location (and name it whatever) you wish.

    ```
    $ env GOOS=linux GOARCH=amd64 go build -o /tmp/main books
    ```

    Important: as part of this command we're using `env` to temporarily set two environment variables for the duration for the command (`GOOS=linux` and `GOARCH=amd64`). These instruct the Go compiler to create an executable suitable for use with a linux OS and amd64 architecture — which is what it will be running on when we deploy it to AWS.

5.  AWS requires us to upload our lambda functions in a zip file, so let's make a `main.zip` zip file containing the executable we just made:

    ```
    $ zip -j /tmp/main.zip /tmp/main
    ```

    Note that the executable must be _in the root_ of the zip file — not in a folder within the zip file. To ensure this I've used the `-j` flag in the snippet above to junk directory names.

6.  The next step is a bit awkward, but critical to getting our lambda function working properly. We need to set up an IAM role which defines the permission that our _lambda function will have when it is running_.

    For now let's set up a `lambda-books-executor` role and attach the `AWSLambdaBasicExecutionRole` managed policy to it. This will give our lambda function the basic permissions it need to run and log to the AWS cloudwatch service.

    First we have to create a _trust policy_ JSON file. This will essentially instruct AWS to allow lambda services to assume the `lambda-books-executor` role:

    File: /tmp/trust-policy.json

    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
    ```

    Then use the `aws iam create-role` command to create the role with this trust policy:

    ```
    $ aws iam create-role --role-name lambda-books-executor \
    --assume-role-policy-document file:///tmp/trust-policy.json
    {
        "Role": {
            "Path": "/",
            "RoleName": "lambda-books-executor",
            "RoleId": "AROAIWSQS2RVEWIMIHOR2",
            "Arn": "arn:aws:iam::account-id:role/lambda-books-executor",
            "CreateDate": "2018-04-05T10:22:32.567Z",
            "AssumeRolePolicyDocument": {
                "Version": "2012-10-17",
                "Statement": [
                    {
                        "Effect": "Allow",
                        "Principal": {
                            "Service": "lambda.amazonaws.com"
                        },
                        "Action": "sts:AssumeRole"
                    }
                ]
            }
        }
    }
    ```

    Make a note of the returned ARN (Amazon Resource Name) — you'll need this in the next step.

    Now the `lambda-books-executor` role has been created we need to specify the permissions that the role has. The easiest way to do this it to use the `aws iam attach-role-policy` command, passing in the ARN of `AWSLambdaBasicExecutionRole` permission policy like so:

    ```
    $ aws iam attach-role-policy --role-name lambda-books-executor \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
    ```

    Note: you can find a list of other permission policies that might be useful [here](https://docs.aws.amazon.com/lambda/latest/dg/intro-permission-model.html#lambda-intro-execution-role).

7.  Now we're ready to actually deploy the lambda function to AWS, which we can do using the `aws lambda create-function` command. This takes the following flags and can take a minute or two to run.

    |     |     |
    | --- | --- |
    | `--function-name` | Thethat name your lambda function will be called within AWS |
    | `--runtime` | The runtime environment for the lambda function (in our case `"go1.x"`) |
    | `--role` | The ARN of the role you want the lambda function to assume when it is running (from step 6 above) |
    | `--handler` | The name of the executable in the root of the zip file |
    | `--zip-file` | Path to the zip file |

    Go ahead and try deploying it:

    ```
    $ aws lambda create-function --function-name books --runtime go1.x \
    --role arn:aws:iam::account-id:role/lambda-books-executor \
    --handler main --zip-file fileb:///tmp/main.zip
    {
        "FunctionName": "books",
        "FunctionArn": "arn:aws:lambda:us-east-1:account-id:function:books",
        "Runtime": "go1.x",
        "Role": "arn:aws:iam::account-id:role/lambda-books-executor",
        "Handler": "main",
        "CodeSize": 2791699,
        "Description": "",
        "Timeout": 3,
        "MemorySize": 128,
        "LastModified": "2018-04-05T10:25:05.343+0000",
        "CodeSha256": "O20RZcdJTVcpEiJiEwGL2bX1PtJ/GcdkusIEyeO9l+8=",
        "Version": "$LATEST",
        "TracingConfig": {
            "Mode": "PassThrough"
        }
    }
    ```

8.  So there it is. Our lambda function has been deployed and is now ready to use. You can try it out by using the `aws lambda invoke` command (which requires you to specify an output file for the response — I've used `/tmp/output.json` in the snippet below).

    ```
    $ aws lambda invoke --function-name books /tmp/output.json
    {
        "StatusCode": 200
    }
    $ cat /tmp/output.json
    {"isbn":"978-1420931693","title":"The Republic","author":"Plato"}
    ```

    If you're following along hopefully you've got the same response. Notice how the `book` object we initialized in our Go code has been automatically marshaled to JSON?

## Hooking it up to DynamoDB

1.  In this section we're going to add a persistence layer for our data which can be accessed by our lambda function. For this I'll use Amazon DynamoDB (it integrates nicely with AWS lambda and has a generous free-usage tier). If you're not familiar with DynamoDB, there's a decent run down of [the basics here](https://www.tutorialspoint.com/dynamodb/dynamodb_overview.htm).

    The first thing we need to do is create a `Books` table to hold the book records. DynanmoDB is schema-less, but we do need to define the partion key (a bit like a primary key) on the ISBN field. We can do this in one command like so:

    ```
    $ aws dynamodb create-table --table-name Books \
    --attribute-definitions AttributeName=ISBN,AttributeType=S \
    --key-schema AttributeName=ISBN,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
    {
        "TableDescription": {
            "AttributeDefinitions": [
                {
                    "AttributeName": "ISBN",
                    "AttributeType": "S"
                }
            ],
            "TableName": "Books",
            "KeySchema": [
                {
                    "AttributeName": "ISBN",
                    "KeyType": "HASH"
                }
            ],
            "TableStatus": "CREATING",
            "CreationDateTime": 1522924177.507,
            "ProvisionedThroughput": {
                "NumberOfDecreasesToday": 0,
                "ReadCapacityUnits": 5,
                "WriteCapacityUnits": 5
            },
            "TableSizeBytes": 0,
            "ItemCount": 0,
            "TableArn": "arn:aws:dynamodb:us-east-1:account-id:table/Books"
        }
    }
    ```

2.  Then lets add a couple of items using the `put-item` command, which we'll use in the next steps.

    ```
    $ aws dynamodb put-item --table-name Books --item '{"ISBN": {"S": "978-1420931693"}, "Title": {"S": "The Republic"}, "Author":  {"S": "Plato"}}'
    $ aws dynamodb put-item --table-name Books --item '{"ISBN": {"S": "978-0486298238"}, "Title": {"S": "Meditations"},  "Author":  {"S": "Marcus Aurelius"}}'
    ```

3.  The next thing to do is update our Go code so that our lambda handler can connect to and use the DynamoDB layer. For this you'll need to install the `github.com/aws/aws-sdk-go` package which provides libraries for working with DynamoDB (and other AWS services).

    ```
    $ go get github.com/aws/aws-sdk-go
    ```

4.  Now for the code. To keep a bit of separation create a new `db.go` file in your `books` repository:

    ```
    $ touch ~/go/src/books/db.go
    ```

    And add the following code:

    File: books/db.go

    ```
    package main

    import (
        "github.com/aws/aws-sdk-go/aws"
        "github.com/aws/aws-sdk-go/aws/session"
        "github.com/aws/aws-sdk-go/service/dynamodb"
        "github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
    )

    // Declare a new DynamoDB instance. Note that this is safe for concurrent
    // use.
    var db = dynamodb.New(session.New(), aws.NewConfig().WithRegion("us-east-1"))

    func getItem(isbn string) (*book, error) {
        // Prepare the input for the query.
        input := &dynamodb.GetItemInput{
            TableName: aws.String("Books"),
            Key: map[string]*dynamodb.AttributeValue{
                "ISBN": {
                    S: aws.String(isbn),
                },
            },
        }

        // Retrieve the item from DynamoDB. If no matching item is found
        // return nil.
        result, err := db.GetItem(input)
        if err != nil {
            return nil, err
        }
        if result.Item == nil {
            return nil, nil
        }

        // The result.Item object returned has the underlying type
        // map[string]*AttributeValue. We can use the UnmarshalMap helper
        // to parse this straight into the fields of a struct. Note:
        // UnmarshalListOfMaps also exists if you are working with multiple
        // items.
        bk := new(book)
        err = dynamodbattribute.UnmarshalMap(result.Item, bk)
        if err != nil {
            return nil, err
        }

        return bk, nil
    }
    ```

    And then update the `main.go` to use this new code:

    File: books/main.go

    ```
    package main

    import (
        "github.com/aws/aws-lambda-go/lambda"
    )

    type book struct {
        ISBN   string `json:"isbn"`
        Title  string `json:"title"`
        Author string `json:"author"`
    }

    func show() (*book, error) {
        // Fetch a specific book record from the DynamoDB database. We'll
        // make this more dynamic in the next section.
        bk, err := getItem("978-0486298238")
        if err != nil {
            return nil, err
        }

        return bk, nil
    }

    func main() {
        lambda.Start(show)
    }
    ```

5.  Save the files, then rebuild and zip up the lambda function so it's ready to deploy:

    ```
    $ env GOOS=linux GOARCH=amd64 go build -o /tmp/main books
    $ zip -j /tmp/main.zip /tmp/main
    ```

6.  Re-deploying a lambda function is easier than creating it for the first time — we can use the `aws lambda update-function-code` command like so:

    ```
    $ aws lambda update-function-code --function-name books \
    --zip-file fileb:///tmp/main.zip
    ```

7.  Let's try executing the lambda function now:

    ```
    $ aws lambda invoke --function-name books /tmp/output.json
    {
        "StatusCode": 200,
        "FunctionError": "Unhandled"
    }
    $ cat /tmp/output.json
    {"errorMessage":"AccessDeniedException: User: arn:aws:sts::account-id:assumed-role/lambda-books-executor/books is not authorized to perform: dynamodb:GetItem on resource: arn:aws:dynamodb:us-east-1:account-id:table/Books\n\tstatus code: 400, request id: 2QSB5UUST6F0R3UDSVVVODTES3VV4KQNSO5AEMVJF66Q9ASUAAJG","errorType":"requestError"}
    ```

    Ah. There's a slight problem. We can see from the output message that our lambda function (specifically, the `lambda-books-executor` role) doesn't have the necessary permissions to run `GetItem` on a DynamoDB instance. Let's fix that now.

8.  Create a privilege policy file that gives `GetItem` and `PutItem` privileges on DynamoDB like so:

    File: /tmp/privilege-policy.json

    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "dynamodb:PutItem",
                    "dynamodb:GetItem",
                ],
                "Resource": "*"
            }
        ]
    }
    ```

    And then attach it to the `lambda-books-executor` role using the `aws iam put-role-policy` command:

    ```
    $ aws iam put-role-policy --role-name lambda-books-executor \
    --policy-name dynamodb-item-crud-role \
    --policy-document file:///tmp/privilege-policy.json
    ```

    As a side note, AWS has some managed policies called `AWSLambdaDynamoDBExecutionRole` and `AWSLambdaInvocation-DynamoDB` which sound like they would do the trick. But neither of them actually provide `GetItem` or `PutItem` privileges. Hence the need to roll our own policy.

9.  Let's try executing the lambda function again. It should work smoothly this time and return information about the book with ISBN `978-0486298238`.

    ```
    $ aws lambda invoke --function-name books /tmp/output.json
    {
        "StatusCode": 200
    }
    $ cat /tmp/output.json
    {"isbn":"978-0486298238","title":"Meditations","author":"Marcus Aurelius"}
    ```

## Setting up the HTTPS API

1.  So our lambda function is now working nicely and communicating with DynamoDB. The next thing to do is set up a way to access the lamdba function over HTTPS, which we can do using the AWS API Gateway service.

    But before we go any further, it's worth taking a moment to think about the structure of our project. Let's say we have grand plans for our lamdba function to be part of a bigger `bookstore` API which deals with information about books, customers, recommendations and other things.

    There's three basic options for structuring this using AWS Lambda:

    *   **Microservice style** — Each lambda function is responsible for one action only. For example, there are 3 separate lambda functions for showing, creating and deleting a book.
    *   **Service style** — Each lambda function is responsible for a group of related actions. For example, one lambda function handles all book-related actions, but customer-related actions are kept in a separate lambda function.
    *   **Monolith style** — One lambda function manages all the bookstore actions.

    Each of these options is valid, and theres some good discussion of the pros and cons [here](https://serverless.com/blog/serverless-architecture-code-patterns/).

    For this tutorial we'll opt for a service style, and have one `books` lambda function handle the different book-related actions. This means that we'll need to implement some form of routing _within_ our lambda function, which I'll cover later in the post. But for now…

2.  Go ahead and create a `bookstore` API using the `aws apigateway create-rest-api` command like so:

    ```
    $ aws apigateway create-rest-api --name bookstore
    {
        "id": "rest-api-id",
        "name": "bookstore",
        "createdDate": 1522926250
    }
    ```

    Note down the `rest-api-id` value that this returns, we'll be using it a lot in the next few steps.

3.  Next we need to get the id of the root API resource (`"/"`). We can retrieve this using the `aws apigateway get-resources` command like so:

    ```
    $ aws apigateway get-resources --rest-api-id rest-api-id
    {
        "items": [
            {
                "id": "root-path-id",
                "path": "/"
            }
        ]
    }
    ```

    Again, keep a note of the `root-path-id` value this returns.

4.  Now we need to create a new resource _under the root path_ — specifically a resource for the URL path `/books`. We can do this by using the `aws apigateway create-resource` command with the `--path-part` parameter like so:

    ```
    $ aws apigateway create-resource --rest-api-id rest-api-id \
    --parent-id root-path-id --path-part books
    {
        "id": "resource-id",
        "parentId": "root-path-id",
        "pathPart": "books",
        "path": "/books"
    }
    ```

    Again, note the `resource-id` this returns, we'll need it in the next step.

    Note that it's possible to include placeholders within your path by wrapping part of the path in curly braces. For example, a `--path-part` parameter of `books/{id}` would match requests to `/books/foo` and `/books/bar`, and the value of `id` would be made available to your lambda function via an events object (which we'll cover later in the post). You can also make a placeholder greedy by postfixing it with a `+`. A common idiom is to use the parameter `--path-part {proxy+}` if you want to match all requests regardless of their path.

5.  But we're not doing either of those things. Let's get back to our `/books` resource and use the `aws apigateway put-method` command to register the HTTP method of `ANY`. This will mean that our `/books` resource will respond to all requests regardless of their HTTP method.

    ```
    $ aws apigateway put-method --rest-api-id rest-api-id \
    --resource-id resource-id --http-method ANY \
    --authorization-type NONE
    {
        "httpMethod": "ANY",
        "authorizationType": "NONE",
        "apiKeyRequired": false
    }
    ```

6.  Now we're all set to integrate the resource with our lambda function, which we can do using the `aws apigateway put-integration` command. This command has a few parameters that need a quick explanation:

    *   The `--type` parameter should be `AWS_PROXY`. When this is used the AWS API Gateway will send information about the HTTP request as an 'event' to the lambda function. It will also automatically transform the output from the lambda function to a HTTP response.
    *   The `--integration-http-method` parameter must be `POST`. Don't confuse this with what HTTP methods your API resource responds to.
    *   The `--uri` parameter needs to take the format:

        ```
        arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/your-lambda-function-arn/invocations
        ```

    With those things in mind, your command should look a bit like this:

    ```
    $ aws apigateway put-integration --rest-api-id rest-api-id \
    --resource-id resource-id --http-method ANY --type AWS_PROXY \
    --integration-http-method POST \
    --uri arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:account-id:function:books/invocations
    {
        "type": "AWS_PROXY",
        "httpMethod": "POST",
        "uri": "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:account-id:function:books/invocations",
        "passthroughBehavior": "WHEN_NO_MATCH",
        "cacheNamespace": "qtdn5h",
        "cacheKeyParameters": []
    }
    ```

7.  Alright, let's give this a whirl. We can send a test request to the resource we just made using the `aws apigateway test-invoke-method` command like so:

    ```
    $ aws apigateway test-invoke-method --rest-api-id rest-api-id --resource-id resource-id --http-method "GET"
    {
        "status": 500,
        "body": "{\"message\": \"Internal server error\"}",
        "headers": {},
        "log": "Execution log for request test-request\nThu Apr 05 11:07:54 UTC 2018 : Starting execution for request: test-invoke-request\nThu Apr 05 11:07:54 UTC 2018 : HTTP Method: GET, Resource Path: /books\nThu Apr 05 11:07:54 UTC 2018 : Method request path: {}[TRUNCATED]Thu Apr 05 11:07:54 UTC 2018 : Sending request to https://lambda.us-east-1.amazonaws.com/2015-03-31/functions/arn:aws:lambda:us-east-1:account-id:function:books/invocations\nThu Apr 05 11:07:54 UTC 2018 : Execution failed due to configuration error: Invalid permissions on Lambda function\nThu Apr 05 11:07:54 UTC 2018 : Method completed with status: 500\n",
        "latency": 39
    }
    ```

    Ah. So that hasn't quite worked. If you take a look through the outputted log information you should see that the problem appears to be:

    `Execution failed due to configuration error: Invalid permissions on Lambda function`

    This is happening because our `bookstore` API gateway _doesn't have permissions to execute our lambda function._

8.  The easiest way to fix that is to use the `aws lambda add-permission` command to give our API permissions to invoke it, like so:

    ```
    $ aws lambda add-permission --function-name books --statement-id a-GUID \
    --action lambda:InvokeFunction --principal apigateway.amazonaws.com \
    --source-arn arn:aws:execute-api:us-east-1:account-id:rest-api-id/*/*/*
    {
        "Statement": "{\"Sid\":\"6d658ce7-3899-4de2-bfd4-fefb939f731\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"apigateway.amazonaws.com\"},\"Action\":\"lambda:InvokeFunction\",\"Resource\":\"arn:aws:lambda:us-east-1:account-id:function:books\",\"Condition\":{\"ArnLike\":{\"AWS:SourceArn\":\"arn:aws:execute-api:us-east-1:account-id:rest-api-id/*/*/*\"}}}"
    }
    ```

    Note that the `--statement-id` parameter needs to be a globally unique identifier. This could be a [random ID](https://www.guidgenerator.com/) or something more descriptive.

9.  Alright, let's try again:

    ```
    $ aws apigateway test-invoke-method --rest-api-id rest-api-id --resource-id resource-id --http-method "GET"
    {
        "status": 502,
        "body": "{\"message\": \"Internal server error\"}",
        "headers": {},
        "log": "Execution log for request test-request\nThu Apr 05 11:12:53 UTC 2018 : Starting execution for request: test-invoke-request\nThu Apr 05 11:12:53 UTC 2018 : HTTP Method: GET, Resource Path: /books\nThu Apr 05 11:12:53 UTC 2018 : Method request path: {}\nThu Apr 05 11:12:53 UTC 2018 : Method request query string: {}\nThu Apr 05 11:12:53 UTC 2018 : Method request headers: {}\nThu Apr 05 11:12:53 UTC 2018 : Endpoint response body before transformations: {\"isbn\":\"978-0486298238\",\"title\":\"Meditations\",\"author\":\"Marcus Aurelius\"}\nThu Apr 05 11:12:53 UTC 2018 : Endpoint response headers: {X-Amz-Executed-Version=$LATEST, x-amzn-Remapped-Content-Length=0, Connection=keep-alive, x-amzn-RequestId=48d29098-38c2-11e8-ae15-f13b670c5483, Content-Length=74, Date=Thu, 05 Apr 2018 11:12:53 GMT, X-Amzn-Trace-Id=root=1-5ac604b5-cf29dd70cd08358f89853b96;sampled=0, Content-Type=application/json}\nThu Apr 05 11:12:53 UTC 2018 : Execution failed due to configuration error: Malformed Lambda proxy response\nThu Apr 05 11:12:53 UTC 2018 : Method completed with status: 502\n",
        "latency": 211
    }
    ```

    So unfortunately there's still an error, but the message has now changed:

    `Execution failed due to configuration error: Malformed Lambda proxy response`

    And if you look closely at the output you'll see the information:

    `Endpoint response body before transformations: {\"isbn\":\"978-0486298238\",\"title\":\"Meditations\",\"author\":\"Marcus Aurelius\"}`

    So there's some definite progress here. Our API is talking to our lambda function and is receiving the correct response (a `book` object marshalled to JSON). It's just that the AWS API Gateway considers the response to be in the wrong format.

    This is because, when you're using the API Gateway's lambda proxy integration, the return value from the lambda function **must** be in the following JSON format:

    ```
    {
        "isBase64Encoded": true|false,
        "statusCode": httpStatusCode,
        "headers": { "headerName": "headerValue", ... },
        "body": "..."
    }
    ```

    So to fix this it's time to head back to our Go code and make some alterations.

## Working with events

1.  The easiest way to provide the responses that the AWS API Gateway needs is to install the `github.com/aws/aws-lambda-go/events` package:

    ```
    go get github.com/aws/aws-lambda-go/events
    ```

    This provides a couple of useful types (`APIGatewayProxyRequest` and `APIGatewayProxyResponse`) which contain information about incoming HTTP requests and allow us to construct responses that the API Gateway understands.

    ```
    type APIGatewayProxyRequest struct {
        Resource              string                        `json:"resource"` // The resource path defined in API Gateway
        Path                  string                        `json:"path"`     // The url path for the caller
        HTTPMethod            string                        `json:"httpMethod"`
        Headers               map[string]string             `json:"headers"`
        QueryStringParameters map[string]string             `json:"queryStringParameters"`
        PathParameters        map[string]string             `json:"pathParameters"`
        StageVariables        map[string]string             `json:"stageVariables"`
        RequestContext        APIGatewayProxyRequestContext `json:"requestContext"`
        Body                  string                        `json:"body"`
        IsBase64Encoded       bool                          `json:"isBase64Encoded,omitempty"`
    }
    ```

    ```
    type APIGatewayProxyResponse struct {
        StatusCode      int               `json:"statusCode"`
        Headers         map[string]string `json:"headers"`
        Body            string            `json:"body"`
        IsBase64Encoded bool              `json:"isBase64Encoded,omitempty"`
    }
    ```

2.  Let's go back to our `main.go` file and update our lambda handler so that it uses the signature:

    ```
    func(events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error)
    ```

    Essentially, the handler will accept a `APIGatewayProxyRequest` object which contains a bunch of information about the HTTP request, and return a `APIGatewayProxyResponse` object (which is marshalable into a JSON response suitable for the AWS API Gateway).

    File: books/main.go

    ```
    package main

    import (
        "encoding/json"
        "fmt"
        "log"
        "net/http"
        "os"
        "regexp"

        "github.com/aws/aws-lambda-go/events"
        "github.com/aws/aws-lambda-go/lambda"
    )

    var isbnRegexp = regexp.MustCompile(`[0-9]{3}\-[0-9]{10}`)
    var errorLogger = log.New(os.Stderr, "ERROR ", log.Llongfile)

    type book struct {
        ISBN   string `json:"isbn"`
        Title  string `json:"title"`
        Author string `json:"author"`
    }

    func show(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
        // Get the `isbn` query string parameter from the request and
        // validate it.
        isbn := req.QueryStringParameters["isbn"]
        if !isbnRegexp.MatchString(isbn) {
            return clientError(http.StatusBadRequest)
        }

        // Fetch the book record from the database based on the isbn value.
        bk, err := getItem(isbn)
        if err != nil {
            return serverError(err)
        }
        if bk == nil {
            return clientError(http.StatusNotFound)
        }

        // The APIGatewayProxyResponse.Body field needs to be a string, so
        // we marshal the book record into JSON.
        js, err := json.Marshal(bk)
        if err != nil {
            return serverError(err)
        }

        // Return a response with a 200 OK status and the JSON book record
        // as the body.
        return events.APIGatewayProxyResponse{
            StatusCode: http.StatusOK,
            Body:       string(js),
        }, nil
    }

    // Add a helper for handling errors. This logs any error to os.Stderr
    // and returns a 500 Internal Server Error response that the AWS API
    // Gateway understands.
    func serverError(err error) (events.APIGatewayProxyResponse, error) {
        errorLogger.Println(err.Error())

        return events.APIGatewayProxyResponse{
            StatusCode: http.StatusInternalServerError,
            Body:       http.StatusText(http.StatusInternalServerError),
        }, nil
    }

    // Similarly add a helper for send responses relating to client errors.
    func clientError(status int) (events.APIGatewayProxyResponse, error) {
        return events.APIGatewayProxyResponse{
            StatusCode: status,
            Body:       http.StatusText(status),
        }, nil
    }

    func main() {
        lambda.Start(show)
    }
    ```

    Notice how in all cases the `error` value returned from our lambda handler is now `nil`? We have to do this because the API Gateway doesn't accept `error` objects when you're using it in conjunction with a lambda proxy integration (they would result in a 'malformed response' errors again). So we need to manage errors fully within our lambda function and return the appropriate HTTP response. In essence, this means that the return parameter of `error` is superfluous, but we still need to include it to have a valid signature for the lambda function.

3.  Anyway, save the file and rebuild and redeploy the lambda function:

    ```
    $ env GOOS=linux GOARCH=amd64 go build -o /tmp/main books
    $ zip -j /tmp/main.zip /tmp/main
    $ aws lambda update-function-code --function-name books \
    --zip-file fileb:///tmp/main.zip
    ```

4.  And if you test it again now it should work as expected. Give it a try with different `isbn` values in the query string:

    ```
    $ aws apigateway test-invoke-method --rest-api-id rest-api-id \
    --resource-id resource-id --http-method "GET" \
    --path-with-query-string "/books?isbn=978-1420931693"
    {
        "status": 200,
        "body": "{\"isbn\":\"978-1420931693\",\"title\":\"The Republic\",\"author\":\"Plato\"}",
        "headers": {
            "X-Amzn-Trace-Id": "sampled=0;root=1-5ac60df0-0ea7a560337129d1fde588cd"
        },
        "log": [TRUNCATED],
        "latency": 1232
    }
    $ aws apigateway test-invoke-method --rest-api-id rest-api-id \
    --resource-id resource-id --http-method "GET" \
    --path-with-query-string "/books?isbn=foobar"
    {
        "status": 400,
        "body": "Bad Request",
        "headers": {
            "X-Amzn-Trace-Id": "sampled=0;root=1-5ac60e1c-72fad7cfa302fd32b0a6c702"
        },
        "log": [TRUNCATED],
        "latency": 25
    }
    ```

5.  As a side note, anything sent to `os.Stderr` will be logged to the AWS Cloudwatch service. So if you've set up an error logger like we have in the code above, you can query Cloudwatch for errors like so:

    ```
    $ aws logs filter-log-events --log-group-name /aws/lambda/books \
    --filter-pattern "ERROR"
    ```

## Deploying the API

1.  Now that the API Gateway is working properly it's time to make it live. We can do this with the `aws apigateway create-deployment` command like so:

    ```
    $ aws apigateway create-deployment --rest-api-id rest-api-id \
    --stage-name staging
    {
        "id": "4pdblq",
        "createdDate": 1522929303
    }
    ```

    In the code above I've given the deployed API using the name `staging`, but you can call it anything that you wish.

2.  Once deployed your API should be accessible at the URL:

    ```
    https://rest-api-id.execute-api.us-east-1.amazonaws.com/staging
    ```

    Go ahead and give it a try using curl. It should work as you expect:

    ```
    $ curl https://rest-api-id.execute-api.us-east-1.amazonaws.com/staging/books?isbn=978-1420931693
    {"isbn":"978-1420931693","title":"The Republic","author":"Plato"}
    $ curl https://rest-api-id.execute-api.us-east-1.amazonaws.com/staging/books?isbn=foobar
    Bad Request
    ```

## Supporting multiple actions

1.  Let's add support for a `POST /books` action. We want this to read and validate a new book record (from a JSON HTTP request body) and then add it to the DynamoDB table.

    Now that the different AWS services are hooked up, extending our lambda function to support additional actions is perhaps the most straightforward part of this tutorial, as it can be managed purely within our Go code.

    First update the `db.go` file to include a new `putItem` function like so:

    File: books/db.go

    ```
    package main

    import (
        "github.com/aws/aws-sdk-go/aws"
        "github.com/aws/aws-sdk-go/aws/session"
        "github.com/aws/aws-sdk-go/service/dynamodb"
        "github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
    )

    var db = dynamodb.New(session.New(), aws.NewConfig().WithRegion("us-east-1"))

    func getItem(isbn string) (*book, error) {
        input := &dynamodb.GetItemInput{
            TableName: aws.String("Books"),
            Key: map[string]*dynamodb.AttributeValue{
                "ISBN": {
                    S: aws.String(isbn),
                },
            },
        }

        result, err := db.GetItem(input)
        if err != nil {
            return nil, err
        }
        if result.Item == nil {
            return nil, nil
        }

        bk := new(book)
        err = dynamodbattribute.UnmarshalMap(result.Item, bk)
        if err != nil {
            return nil, err
        }

        return bk, nil
    }

    // Add a book record to DynamoDB.
    func putItem(bk *book) error {
        input := &dynamodb.PutItemInput{
            TableName: aws.String("Books"),
            Item: map[string]*dynamodb.AttributeValue{
                "ISBN": {
                    S: aws.String(bk.ISBN),
                },
                "Title": {
                    S: aws.String(bk.Title),
                },
                "Author": {
                    S: aws.String(bk.Author),
                },
            },
        }

        _, err := db.PutItem(input)
        return err
    }
    ```

    And then update the `main.go` function so that the `lambda.Start()` method calls a new `router` function, which does a switch on the HTTP request method to determine which action to take. Like so:

    File: books/main.go

    ```
    package main

    import (
        "encoding/json"
        "fmt"
        "log"
        "net/http"
        "os"
        "regexp"

        "github.com/aws/aws-lambda-go/events"
        "github.com/aws/aws-lambda-go/lambda"
    )

    var isbnRegexp = regexp.MustCompile(`[0-9]{3}\-[0-9]{10}`)
    var errorLogger = log.New(os.Stderr, "ERROR ", log.Llongfile)

    type book struct {
        ISBN   string `json:"isbn"`
        Title  string `json:"title"`
        Author string `json:"author"`
    }

    func router(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
        switch req.HTTPMethod {
        case "GET":
            return show(req)
        case "POST":
            return create(req)
        default:
            return clientError(http.StatusMethodNotAllowed)
        }
    }

    func show(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
        isbn := req.QueryStringParameters["isbn"]
        if !isbnRegexp.MatchString(isbn) {
            return clientError(http.StatusBadRequest)
        }

        bk, err := getItem(isbn)
        if err != nil {
            return serverError(err)
        }
        if bk == nil {
            return clientError(http.StatusNotFound)
        }

        js, err := json.Marshal(bk)
        if err != nil {
            return serverError(err)
        }

        return events.APIGatewayProxyResponse{
            StatusCode: http.StatusOK,
            Body:       string(js),
        }, nil
    }

    func create(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
        if req.Headers["Content-Type"] != "application/json" {
            return clientError(http.StatusNotAcceptable)
        }

        bk := new(book)
        err := json.Unmarshal([]byte(req.Body), bk)
        if err != nil {
            return clientError(http.StatusUnprocessableEntity)
        }

        if !isbnRegexp.MatchString(bk.ISBN) {
            return clientError(http.StatusBadRequest)
        }
        if bk.Title == "" || bk.Author == "" {
            return clientError(http.StatusBadRequest)
        }

        err = putItem(bk)
        if err != nil {
            return serverError(err)
        }

        return events.APIGatewayProxyResponse{
            StatusCode: 201,
            Headers:    map[string]string{"Location": fmt.Sprintf("/books?isbn=%s", bk.ISBN)},
        }, nil
    }

    func serverError(err error) (events.APIGatewayProxyResponse, error) {
        errorLogger.Println(err.Error())

        return events.APIGatewayProxyResponse{
            StatusCode: http.StatusInternalServerError,
            Body:       http.StatusText(http.StatusInternalServerError),
        }, nil
    }

    func clientError(status int) (events.APIGatewayProxyResponse, error) {
        return events.APIGatewayProxyResponse{
            StatusCode: status,
            Body:       http.StatusText(status),
        }, nil
    }

    func main() {
        lambda.Start(router)
    }
    ```

2.  Rebuild and zip up the lambda function, then deploy it as normal:

    ```
    $ env GOOS=linux GOARCH=amd64 go build -o /tmp/main books
    $ zip -j /tmp/main.zip /tmp/main
    $ aws lambda update-function-code --function-name books \
    --zip-file fileb:///tmp/main.zip
    ```

3.  And now when you hit the API using different HTTP methods it should call the appropriate action:

    ```
    $ curl -i -H "Content-Type: application/json" -X POST \
    -d '{"isbn":"978-0141439587", "title":"Emma", "author": "Jane Austen"}' \
    https://rest-api-id.execeast-1.amazonaws.com/staging/books
    HTTP/1.1 201 Created
    Content-Type: application/json
    Content-Length: 7
    Connection: keep-alive
    Date: Thu, 05 Apr 2018 14:55:34 GMT
    x-amzn-RequestId: 64262aa3-38e1-11e8-825c-d7cfe4d1e7d0
    x-amz-apigw-id: E33T1E3eIAMF9dw=
    Location: /books?isbn=978-0141439587
    X-Amzn-Trace-Id: sampled=0;root=1-5ac638e5-e806a84761839bc24e234c37
    X-Cache: Miss from cloudfront
    Via: 1.1 a22ee9ab15c998bce94f1f4d2a7792ee.cloudfront.net (CloudFront)
    X-Amz-Cf-Id: wSef_GJ70YB2-0VSwhUTS9x-ATB1Yq8anWuzV_PRN98k9-DkD7FOAA==

    $ curl https://rest-api-id.execute-api.us-east-1.amazonaws.com/staging/books?isbn=978-0141439587
    {"isbn":"978-0141439587","title":"Emma","author":"Jane Austen"}
    ```


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
