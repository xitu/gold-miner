> * 原文地址：[How to build a Serverless API with Go and AWS Lambda](http://www.alexedwards.net/blog/serverless-api-with-go-and-aws-lambda)
> * 原文作者：[Alex Edwards](http://www.alexedwards.net)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/serverless-api-with-go-and-aws-lambda.md](https://github.com/xitu/gold-miner/blob/master/TODO1/serverless-api-with-go-and-aws-lambda.md)
> * 译者：[sisibeloved](https://github.com/sisibeloved)
> * 校对者：[luochen1992](https://github.com/luochen1992)

# 使用 Go 和 AWS Lambda 构建无服务 API

早些时候 AWS 宣布了他们的 [Lambda](https://aws.amazon.com/lambda/) 服务将会为 Go 语言提供首要支持，这对于想要体验无服务技术的 GO 语言程序员（比如我自己）来说前进了一大步。

所以在这篇文章中我将讨论如何一步一步创建一个依赖 AWS Lambda 的 HTTPS API。我发现在这个过程中会有很多坑 — 特别是你对 AWS 的权限系统不熟悉的话 — 而且 Lamdba 接口和其它 AWS 服务对接时有很多磕磕碰碰的地方。但是一旦你弄懂了，这些工具都会非常好使。

这篇教程涵盖了许多方面的内容，所以我将它分成以下七个步骤：

1.  [构建 AWS CLI](#构建-aws-cli)
2.  [创建并部署一个 Lambda 函数](#创建并部署一个-lambda-函数)
3.  [链接到 DynamoDB](#链接到-dynamodb)
4.  [构建 HTTPS API](#构建-https-api)
5.  [处理事件](#处理事件)
6.  [部署 API](#部署-api)
7.  [支持多种行为](#支持多种行为)

通过这篇文章我们将努力构建一个具有两个功能的 API：

| 方法 | 路径 | 行为 |
| ------ | ---- | ------ |
| GET | /books?isbn=xxx | 展示带有指定 ISBN 的 book 对象的信息 |
| POST | /books | 创建一个 book 对象 |

一个 book 对象是一条像这样的原生 JSON 记录：

```
{"isbn":"978-1420931693","title":"The Republic","author":"Plato"}
```

我会保持 API 的简单易懂，避免在特定功能的代码中陷入困境，但是当你掌握了基础知识之后，怎样扩展 API 来支持附加的路由和行为就变得轻而易举了。

## 构建 AWS CLI

1.  整个教程中我们会使用 AWS CLI（命令行接口）来设置我们的 lambda 函数和其它 AWS 服务。安装和基本使用指南可以[在这儿找到](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)，不过如果你使用了一个基于 Debian 的系统，比如 Ubuntu，你可以通过 `apt` 安装 CLI 并使用 `aws` 命令来运行它：

    ```
    $ sudo apt install awscli
    $ aws --version
    aws-cli/1.11.139 Python/3.6.3 Linux/4.13.0-37-generic botocore/1.6.6
    ```

2.  接下来我们需要创建一个带有**允许程序访问**权限的 AWS IAM 以供 CLI 使用。如何操作的指南可以[在这儿找到](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html)。出于测试的目的，你可以为这个用户附加拥有所有权限的 `AdministratorAccess` 托管策略，但在实际生产中我建议你使用更严格的策略。创建完用户后你将获得一个访问密钥 ID 和访问私钥。留意一下这些 —— 你将在下一步使用它们。

3.  使用你刚创建的 IAM 用户的凭证，通过 `configure` 命令来配置你的 CLI。你需要指定[默认地区](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)和你想要 CLI 使用的[输出格式](https://docs.aws.amazon.com/cli/latest/userguide/controlling-output.html) 。

    ```
    $ aws configure
    AWS Access Key ID [None]: access-key-ID
    AWS Secret Access Key [None]: secret-access-key
    Default region name [None]: us-east-1
    Default output format [None]: json
    ```

    （假定你使用的是 `us-east-1` 地区 —— 如果你正在使用一个不同的地区，你需要相应地修改这个代码片段。）

## 创建并部署一个 Lambda 函数

1.  接下来就是激动人心的时刻：创建一个 lambda 函数。如果你正在照着做，进入你的 `$GOPATH/src` 文件夹，创建一个含有一个 `main.go` 文件的 `books` 仓库。

    ```
    $ cd ~/go/src
    $ mkdir books && cd books
    $ touch main.go
    ```

2.  接着你需要安装 [`github.com/aws-lambda-go/lambda`](https://github.com/aws/aws-lambda-go) 包。这个包提供了创建 lambda 函数必需的 Go 语言库和类型。

    ```
    $ go get github.com/aws/aws-lambda-go/lambda
    ```

3.  然后打开 `main.go` 文件，输入以下代码：

    文件：books/main.go

    ```go
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

    在 `main()` 函数中我们调用 `lambda.Start()` 并传入了 `show` 函数作为 lambda **处理程序**。在这个示例中处理函数仅简单地初始化并返回了一个新的 `book` 对象。

    Lamdba 处理程序能够接收一系列不同的 Go 函数签名，并通过反射来确定哪个是你正在用的。它所支持的完整列表是……

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

    …… 其中的 `TIn` 和 `TOut` 参数是可以通过 Go 的 `encoding/json` 包构建（和解析）的对象。

4.  下一步是使用 `go build` 从 `books` 包构建一个可执行程序。在下面的代码片段中我使用 `-o` 标识来把可执行程序存到 `/tmp/main` ，当然，你也可以把它存到你想存的任意位置（同样地可以命名为任意名称）。

    ```
    $ env GOOS=linux GOARCH=amd64 go build -o /tmp/main books
    ```

    重要：作为这个命令的一部分，我们使用 `env` 来设置两个命令运行期间的临时的环境变量（`GOOS=linux` 和 `GOARCH=amd64`）。这会指示 Go 编译器创建一个适用于 amd64 架构的 linux 系统的可执行程序 —— 就是当我们部署到 AWS 上时将会运行的环境。

5.  AWS 要求我们以 zip 格式上传 lambda 函数，所以创建一个包含我们刚才创建的可执行程序的 `main.zip` 文件：

    ```
    $ zip -j /tmp/main.zip /tmp/main
    ```

    需要注意的是可执行程序必须在 zip 文件的**根目录下** —— 不是在 zip 文件的某个文件夹中。为了确保这一点，我在上面的代码片段中用了 `-j` 标识来丢弃目录名称。

6.  下一步有点麻烦，但是对于让我们的 lambda 正确运行至关重要。我们需要建立一个 IAM 角色，它定义了 **lambda 函数运行时需要的**权限。

    现在让我们来建立一个 `lambda-books-executor` 角色，并给它附加 `AWSLambdaBasicExecutionRole` 托管政策。这会给我们的 lambda 函数运行和输出日志到 AWS 云监控服务所需的最基本的权限。

    首先我们需要创建一个**信任策略** JSON 文件。这会从根本上指示 AWS 允许 lambda 服务扮演 `lambda-books-executor` 角色：

    文件：/tmp/trust-policy.json

    ```json
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

    然后使用 `aws iam create-role` 命令来创建带有这个信任策略的用户：

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

    关注一下返回的 ARN（亚马逊资源名）—— 在下一步中你需要用到它。

    现在这个 `lambda-books-executor` 已经被创建，我们需要指定这个角色拥有的权限。最简单的方法是用 `aws iam attach-role-policy` 命令，像这样传入 `AWSLambdaBasicExecutionRole` 的 ARN 和许可政策：

    ```
    $ aws iam attach-role-policy --role-name lambda-books-executor \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
    ```

    提示：你可以在[这里](https://docs.aws.amazon.com/lambda/latest/dg/intro-permission-model.html#lambda-intro-execution-role)找到一系列其他的许可政策，或许能对你有所帮助。

7.  现在我们可以真正地把 lambda 函数部署到 AWS 上了。我们可以使用 `aws lambda create-function` 命令。这个命令接收以下标识，并且需要运行一到两分钟。

    |     |     |
    | --- | --- |
    | `--function-name` | 将在 AWS 中被调用的 lambda 函数名 |
    | `--runtime` | lambda 函数的运行环境（在我们的例子里用 `"go1.x"`） |
    | `--role` | 你想要 lambda 函数在运行时扮演的角色的 ARN（见上面的步骤 6） |
    | `--handler` | zip 文件根目录下的可执行文件的名称 |
    | `--zip-file` | zip 文件的路径 |

    接下去尝试部署：

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

8.  大功告成！我们的 lambda 函数已经被部署上去并可以用了。你可以使用 `aws lambda invoke` 命令来试验一下（你需要为响应指定一个输出文件 —— 我在下面的代码片段中用了 `/tmp/output.json`）。

    ```
    $ aws lambda invoke --function-name books /tmp/output.json
    {
        "StatusCode": 200
    }
    $ cat /tmp/output.json
    {"isbn":"978-1420931693","title":"The Republic","author":"Plato"}
    ```

    如果你一路照着做，你很有可能得到一个相同的响应。注意到了我们在 Go 代码中初始化的 `book` 对象是怎样被自动解析成 JSON 的吗？

## 链接到 DynamoDB

1.  在这一章中要为 lambda 函数存取的数据添加持久层。我将会使用 Amazon DynamoDB（它跟 AWS lambda 结合得很出色，并且免费用量也不小）。如果你对 DynamoDB 不熟悉，[这儿](https://www.tutorialspoint.com/dynamodb/dynamodb_overview.htm)有一个不错的基本纲要。

    首先要创建一张 `Books` 表来保存 book 记录。DynanmoDB 是没有 schema 的，但我们需要在 ISBN 字段上定义分区键（有点像主键）。我们只需用以下这个命令：

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

2.  然后用 `put-item` 命令添加一些数据，这些数据在接下来几步中会用得到。

    ```
    $ aws dynamodb put-item --table-name Books --item '{"ISBN": {"S": "978-1420931693"}, "Title": {"S": "The Republic"}, "Author":  {"S": "Plato"}}'
    $ aws dynamodb put-item --table-name Books --item '{"ISBN": {"S": "978-0486298238"}, "Title": {"S": "Meditations"},  "Author":  {"S": "Marcus Aurelius"}}'
    ```

3.  接下来更新我们的 Go 代码，这样我们的 lambda 处理程序可以连接并使用 DynamoDB 层。你需要安装 `github.com/aws/aws-sdk-go` 包，它提供了使用 DynamoDB（和其它 AWS 服务）的相关库。

    ```
    $ go get github.com/aws/aws-sdk-go
    ```

4.  接着是敲代码环节。为了保持代码分离，在 `books` 仓库中创建一个新的 `db.go` 文件：

    ```
    $ touch ~/go/src/books/db.go
    ```

    并添加以下代码：

    文件：books/db.go

    ```go
    package main

    import (
        "github.com/aws/aws-sdk-go/aws"
        "github.com/aws/aws-sdk-go/aws/session"
        "github.com/aws/aws-sdk-go/service/dynamodb"
        "github.com/aws/aws-sdk-go/service/dynamodb/dynamodbattribute"
    )

    // 声明一个新的 DynamoDB 实例。注意它在并发调用时是
    // 安全的。
    var db = dynamodb.New(session.New(), aws.NewConfig().WithRegion("us-east-1"))

    func getItem(isbn string) (*book, error) {
        // 准备查询的输入
        input := &dynamodb.GetItemInput{
            TableName: aws.String("Books"),
            Key: map[string]*dynamodb.AttributeValue{
                "ISBN": {
                    S: aws.String(isbn),
                },
            },
        }

        // 从 DynamoDB 检索数据。如果没有符合的数据
        // 返回 nil。
        result, err := db.GetItem(input)
        if err != nil {
            return nil, err
        }
        if result.Item == nil {
            return nil, nil
        }

        // 返回的 result.Item 对象具有隐含的
        // map[string]*AttributeValue 类型。我们可以使用 UnmarshalMap helper
        // 解析成对应的数据结构。注意：
        // 当你需要处理多条数据时，可以使用
        // UnmarshalListOfMaps。
        bk := new(book)
        err = dynamodbattribute.UnmarshalMap(result.Item, bk)
        if err != nil {
            return nil, err
        }

        return bk, nil
    }
    ```

    然后用新的代码更新 `main.go`：

    文件：books/main.go

    ```go
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
        // 从 DynamoDB 数据库获取特定的 book 记录。在下一章中，
        // 我们可以让这个行为更加动态。
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

5.  保存文件、重新编译并打包压缩 lambda 函数，这样就做好了部署前的准备：

    ```
    $ env GOOS=linux GOARCH=amd64 go build -o /tmp/main books
    $ zip -j /tmp/main.zip /tmp/main
    ```

6.  重新部署一个 lambda 函数比第一次创建轻松多了 —— 我们可以像这样使用 `aws lambda update-function-code` 命令：

    ```
    $ aws lambda update-function-code --function-name books \
    --zip-file fileb:///tmp/main.zip
    ```

7.  试着执行 lambda 函数看看：

    ```
    $ aws lambda invoke --function-name books /tmp/output.json
    {
        "StatusCode": 200,
        "FunctionError": "Unhandled"
    }
    $ cat /tmp/output.json
    {"errorMessage":"AccessDeniedException: User: arn:aws:sts::account-id:assumed-role/lambda-books-executor/books is not authorized to perform: dynamodb:GetItem on resource: arn:aws:dynamodb:us-east-1:account-id:table/Books\n\tstatus code: 400, request id: 2QSB5UUST6F0R3UDSVVVODTES3VV4KQNSO5AEMVJF66Q9ASUAAJG","errorType":"requestError"}
    ```

    啊，有点小问题。我们可以从输出信息中看到，我们的 lambda 函数（注意了，用的 `lambda-books-executor` 角色）缺少在 DynamoDB 实例上运行 `GetItem` 的权限。我们现在就把它改过来。

8.  创建一个权限策略文件，给予 `GetItem` 和 `PutItem` DynamoDB 相关的权限：

    文件：/tmp/privilege-policy.json

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

    然后使用 `aws iam put-role-policy` 命令把它附加到 `lambda-books-executor` 用户：

    ```
    $ aws iam put-role-policy --role-name lambda-books-executor \
    --policy-name dynamodb-item-crud-role \
    --policy-document file:///tmp/privilege-policy.json
    ```

    讲句题外话，AWS 有叫做 `AWSLambdaDynamoDBExecutionRole` 和 `AWSLambdaInvocation-DynamoDB` 的托管策略，听起来挺管用的，但是它们都不提供 `GetItem` 或 `PutItem` 的权限。所以才需要组建自己的策略。

9.  再执行一次 lambda 函数看看。这一次应该顺利执行了并返回 ISBN 为 `978-0486298238` 的书本的信息：

    ```
    $ aws lambda invoke --function-name books /tmp/output.json
    {
        "StatusCode": 200
    }
    $ cat /tmp/output.json
    {"isbn":"978-0486298238","title":"Meditations","author":"Marcus Aurelius"}
    ```

## 构建 HTTPS API

1.  到现在为止，我们的 lambda 已经能够运行并与 DynamoDB 交互。接下来就是建立一个通过 HTTPS 获取 lamdba 函数的途径，我们可以通过 AWS API 网关服务来实现。

    但是在我们继续之前，考虑一下项目的架构还是很有必要的。假设我们有一个宏伟的计划，我们的 lamdba 函数将是一个更大的 `bookstore` API 的一部分，这个API 将会处理书本、客户、推荐和其它各种各样的信息。

    AWS Lambda 提供了三种架构的基本选项：

    *   **微服务式** —— 每个 lambda 函数只响应一个行为。举个例子，展示、创建和删除一本书会对应 3 个独立的 lambda 函数。
    *   **服务式** —— 每个 lambda 函数响应一组相关的行为。举个例子， 用一个 lambda 来处理所有跟书相关的行为，但是用户相关行为会被放到另一个独立的 lambda 函数中。
    *   **整体式** —— 一个 lambda 函数管理书店的所有行为。

    每个选项都是有效的，[这里](https://serverless.com/blog/serverless-architecture-code-patterns/)有一些关于每个选项优缺点的不错的讨论。

    在这篇教程中我们会用服务式进行操作，并用一个 `books` lambda 函数处理不同的书本相关行为。这意味着我们需要在我们的 lambda 函数**内部**实现某种形式的路由，这一点我会在下文提到。不过现在……

2.  我们继续，使用 `aws apigateway create-rest-api` 创建一个 `bookstore` API：

    ```
    $ aws apigateway create-rest-api --name bookstore
    {
        "id": "rest-api-id",
        "name": "bookstore",
        "createdDate": 1522926250
    }
    ```

    记录下返回的 `rest-api-id` 值，我们在接下来几步中会多次用到它。

3.  接下来我们需要获取 API 根目录（`"/"`）的 id。我们可以使用 `aws apigateway get-resources` 命令来取得：

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

    同样地，记录返回的 `root-path-id` 值。

4.  现在我们需要**在根目录下**创建一个新的资源 —— 就是 URL 路径 `/books` 对应的资源。我们可以使用带有 `--path-part` 参数的 `aws apigateway create-resource` 命令：

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

    同样地，记录返回的 `resource-id`，下一步要用到。

    值得一提的是，可以使用大括号将部分路径包裹起来来在路径中包含占位符。举个例子，`books/{id}` 的 `--path-part` 参数将会匹配 `/books/foo` 和 `/books/bar` 的请求，并且 `id` 的值可以通过一个事件对象（下文会提到）在你的 lambda 函数中获取。你也可以在占位符后加上后缀 `+`，使它变得贪婪。如果你想匹配任意路径的请求，一种常见的做法是使用参数 `--path-part {proxy+}`。

5.  不过我们不用这么做。我们回到 `/books` 资源，使用 `aws apigateway put-method` 命令来注册 `ANY` 的 HTTP 方法。这意味着我们的 `/books` 将会响应所有请求，不论什么 HTTP 方法。

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

6.  现在万事俱备，就差把资源整合到我们的 lambda 函数中了，这一步我们使用 `aws apigateway put-integration` 命令。关于这个命令的一些参数需要简短地解释一下：

    *   The `--type` 参数应该为 `AWS_PROXY`。当使用这个值时，AWS API 网关会以 『事件』的形式将 HTTP 请求的信息发送到 lambda 函数。这也会自动将 lambda 函数的输出转化成 HTTP 响应。
    *   `--integration-http-method` 参数必须为 `POST`。不要把这个和你的  API 资源响应的 HTTP 方法混淆了。
    *   `--uri` 参数需要遵守这样的格式：

        ```
        arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/your-lambda-function-arn/invocations
        ```

    记住了这些以后，你的命令看起来应该是这样的：

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

7.  好了，我们来试一试。我们可以使用 `aws apigateway test-invoke-method` 命令来向我们刚才建立的资源发送一个测试请求：

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

    啊，没有成功。如果你浏览了输出的日志，你应该可以看出问题出在这儿：

    `Execution failed due to configuration error: Invalid permissions on Lambda function`

    这是因为我们的 `bookstore` API 网关**没有执行 lambda 函数的权限**。

8.  最简单的修复问题的方法是使用 `aws lambda add-permission` 命令来给 API 调用的权限，像这样：

    ```
    $ aws lambda add-permission --function-name books --statement-id a-GUID \
    --action lambda:InvokeFunction --principal apigateway.amazonaws.com \
    --source-arn arn:aws:execute-api:us-east-1:account-id:rest-api-id/*/*/*
    {
        "Statement": "{\"Sid\":\"6d658ce7-3899-4de2-bfd4-fefb939f731\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"apigateway.amazonaws.com\"},\"Action\":\"lambda:InvokeFunction\",\"Resource\":\"arn:aws:lambda:us-east-1:account-id:function:books\",\"Condition\":{\"ArnLike\":{\"AWS:SourceArn\":\"arn:aws:execute-api:us-east-1:account-id:rest-api-id/*/*/*\"}}}"
    }
    ```

    注意，`--statement-id` 参数必须是一个全局唯一的标识符。它可以是一个 [random ID](https://www.guidgenerator.com/) 或其它更加容易说明的值。

9.  好了，再试一次：

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

    还是报错，不过消息已经变了：

    `Execution failed due to configuration error: Malformed Lambda proxy response`

    如果你仔细看输出你会看到下列信息：

    `Endpoint response body before transformations: {\"isbn\":\"978-0486298238\",\"title\":\"Meditations\",\"author\":\"Marcus Aurelius\"}`

    这里有明确的过程。API 和 lambda 函数交互并收到了正确的响应（一个解析成 JSON 的 `book` 对象）。只是 AWS API 网关将响应当成了错误的格式。

    这是因为，当你使用 API 网关的 lambda 代理集成，lambda 函数的返回值 **必须** 是这样的 JSON 格式：

    ```
    {
        "isBase64Encoded": true|false,
        "statusCode": httpStatusCode,
        "headers": { "headerName": "headerValue", ... },
        "body": "..."
    }
    ```

    是时候回头看看 Go 代码，然后做些转换了。

## 处理事件

1.  提供 AWS API 网关需要的响应最简单的方法是安装 `github.com/aws/aws-lambda-go/events` 包：

    ```
    go get github.com/aws/aws-lambda-go/events
    ```

    这个包提供了许多有用的类型（`APIGatewayProxyRequest` 和 `APIGatewayProxyResponse`），包含了输入的 HTTP 请求的信息并允许我们构建 API 网关能够理解的响应.

    ```go
    type APIGatewayProxyRequest struct {
        Resource              string                        `json:"resource"` // API 网关中定义的资源路径
        Path                  string                        `json:"path"`     // 调用者的 url 路径
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

    ```go
    type APIGatewayProxyResponse struct {
        StatusCode      int               `json:"statusCode"`
        Headers         map[string]string `json:"headers"`
        Body            string            `json:"body"`
        IsBase64Encoded bool              `json:"isBase64Encoded,omitempty"`
    }
    ```

2.  回到 `main.go` 文件，更新 lambda 处理程序，让它使用这样的函数签名：

    ```
    func(events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error)
    ```

    总的来讲，处理程序会接收一个包含了一串 HTTP 请求信息的 `APIGatewayProxyRequest` 对象，然后返回一个 `APIGatewayProxyResponse` 对象（可以被解析成适合 AWS API 网关的 JSON 响应）。

    文件：books/main.go

    ```go
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
        // 从请求中获取查询 `isbn` 的字符串参数
        // 并校验。
        isbn := req.QueryStringParameters["isbn"]
        if !isbnRegexp.MatchString(isbn) {
            return clientError(http.StatusBadRequest)
        }

        // 根据 isbn 值从数据库中取出 book 记录
        bk, err := getItem(isbn)
        if err != nil {
            return serverError(err)
        }
        if bk == nil {
            return clientError(http.StatusNotFound)
        }

        // APIGatewayProxyResponse.Body 域是个字符串，所以
        // 我们将 book 记录解析成 JSON。
        js, err := json.Marshal(bk)
        if err != nil {
            return serverError(err)
        }

        // 返回一个响应，带有代表成功的 200 状态码和 JSON 格式的 book 记录
        // 响应体。
        return events.APIGatewayProxyResponse{
            StatusCode: http.StatusOK,
            Body:       string(js),
        }, nil
    }

    // 添加一个用来处理错误的帮助函数。它会打印错误日志到 os.Stderr
    // 并返回一个 AWS API 网关能够理解的 500 服务器内部错误
    // 的响应。
    func serverError(err error) (events.APIGatewayProxyResponse, error) {
        errorLogger.Println(err.Error())

        return events.APIGatewayProxyResponse{
            StatusCode: http.StatusInternalServerError,
            Body:       http.StatusText(http.StatusInternalServerError),
        }, nil
    }

    // 加一个简单的帮助函数，用来发送和客户端错误相关的响应。
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

    注意到为什么我们的 lambda 处理程序返回的所有 `error` 值变成了 `nil`？我们不得不这么做，因为 API 网关在和 lambda 代理集成插件结合使用时不接收 `error` 对象 （这些错误会再一次引起『响应残缺』错误）。所以我们需要在 lambda 函数里自己管理错误，并返回合适的 HTTP 响应。其实 `error` 这个返回参数是多余的，但是为了保持正确的函数签名，我们还是要在 lambda 函数里包含它。

3. 保存文件，重新编译并重新部署 lambda 函数：

    ```
    $ env GOOS=linux GOARCH=amd64 go build -o /tmp/main books
    $ zip -j /tmp/main.zip /tmp/main
    $ aws lambda update-function-code --function-name books \
    --zip-file fileb:///tmp/main.zip
    ```

4.  再试一次，结果应该符合预期了。试试在查询字符串中输入不同的 `isbn` 值：

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

5.  插句题外话，所有发送到 `os.Stderr` 的信息会被打印到 AWS 云监控服务。所以如果你像上面的代码一样建立了一个错误日志器，你可以像这样在云监控上查询错误：

    ```
    $ aws logs filter-log-events --log-group-name /aws/lambda/books \
    --filter-pattern "ERROR"
    ```

## 部署 API

1.  既然 API 能够正常工作了，是时候将它上线了。我们可以执行这个 `aws apigateway create-deployment` 命令：

    ```
    $ aws apigateway create-deployment --rest-api-id rest-api-id \
    --stage-name staging
    {
        "id": "4pdblq",
        "createdDate": 1522929303
    }
    ```

    在上面的代码中我给 API 命名为 `staging`，你也可以按你的喜好来给它起名。

2.  部署以后你的 API 可以通过 URL 被访问：

    ```
    https://rest-api-id.execute-api.us-east-1.amazonaws.com/staging
    ```

    用 curl 来试一试。它的结果应该跟预想中一样：

    ```
    $ curl https://rest-api-id.execute-api.us-east-1.amazonaws.com/staging/books?isbn=978-1420931693
    {"isbn":"978-1420931693","title":"The Republic","author":"Plato"}
    $ curl https://rest-api-id.execute-api.us-east-1.amazonaws.com/staging/books?isbn=foobar
    Bad Request
    ```

## 支持多种行为

1.  我们来为 `POST /books` 行为添加支持。我们希望它能读取并校验一条新的 book 记录（从 JSON 格式的 HTTP 请求体中），然后把它添加到 DynamoDB 表中。

    既然不同的 AWS 服务已经联通，扩展我们的 lambda 函数来支持附加的行为可能是这个教程最简单的部分了，因为这可以仅通过 Go 代码实现。

    首先更新 `db.go` 文件，添加一个 `putItem` 函数：

    文件：books/db.go

    ```go
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

    // 添加一条 book 记录到 DynamoDB。
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

    然后修改 `main.go` 函数，这样 `lambda.Start()` 方法会调用一个新的 `router` 函数，根据 HTTP 请求的方法决定哪个行为被调用：

    文件：books/main.go

    ```go
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

2.  重新编译、打包 lambda 函数，然后像平常一样部署它：

    ```
    $ env GOOS=linux GOARCH=amd64 go build -o /tmp/main books
    $ zip -j /tmp/main.zip /tmp/main
    $ aws lambda update-function-code --function-name books \
    --zip-file fileb:///tmp/main.zip
    ```

3.  现在当你用不同的 HTTP 方法访问 API 时，它应该调用合适的方法：

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
