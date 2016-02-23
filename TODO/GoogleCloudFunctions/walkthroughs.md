# Walkthroughs

## Hello World with Cloud Pub/Sub

This section shows a basic "Hello World" example. The example uses the following components:

*   Google Cloud Functions: create a Hello World function.
*   Google Cloud Pub/Sub: send a message to the function.
*   Google Cloud Logging: view the "hello world" message.

### Step 1 - Create the function

Choose a location on your local file system to contain the project:

Linux/Mac

> $ mkdir ~/gcf_hello_world
> $ cd ~/gcf_hello_world

Windows

> $ mkdir %HOMEPATH%\gcf_hello_world
> $ cd %HOMEPATH%\gcf_hello_world

Create a file called `index.js` and paste in the following code (note that if you want to name the file differently, then it must be defined in a `package.json` file as main property):

index.js

> exports.helloworld = function (context, data) {
>   console.log('My GCF Function: ' + data.message);
>   context.success();
> };

### Step 2 - Deploy your function

Deploy the function with a Pub/Sub topic called `hello_world`:

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-topic hello_world

The `--trigger-topic` argument represents the Cloud Pub/Sub topic that will be used or created and on which you can publish events.

**Note:** The first time you deploy a function it may take several minutes as we need to provision the underlying infrastructure to support your functions. Subsequent deployments will be much faster.

You can verify the status of a function at any time using the `describe` command:

> $ gcloud alpha functions describe helloworld

Once the function is deployed, you should see a status of READY reported, along with the path to the Cloud Pub/Sub topic created:

> status: READY
> triggers:
> - pubsubTopic: projects/<PROJECT_ID>/topics/hello_world</pre>

### Step 3 - Test your Function with the "call" command

You can test the function from the command line by using the call command:

> $ gcloud alpha functions call helloworld --data '{"message":"Hello World!"}'

### Step 4 - View the logs

The above code doesn't return a value, so you'll need to check the logs to see the "Hello World!" string:

> $ gcloud alpha functions get-logs helloworld

### Step 5 - Send a Message using Pub/Sub

This example uses Cloud Pub/Sub as a trigger, so you can also cause the function to execute by publishing to the Pub/Sub topic:

> $ gcloud alpha pubsub topics publish hello_world '{"message":"Hello World!"}'

## HTTP Invocation

This example creates a simple function that can be invoked via an HTTP request.

### Step 1 - Create the function

Choose a location on your local file system to contain the project:

Linux/Mac

> $ mkdir ~/gcf_hello_http
> $ cd ~/gcf_hello_http

Windows

> $ mkdir %HOMEPATH%\gcf_hello_http
> $ cd %HOMEPATH%\gcf_hello_http

Create a file called `index.js` and paste in the following code (note that if you want to name the file differently, then it must be defined in a `package.json` file as main property):

index.js

> exports.hellohttp = function (context, data) {
>   // Use the success argument to send data back to the caller
>   context.success('My GCF Function: ' + data.message);
> };

### Step 2 - Deploy your function

Deploy the function with an http trigger:

> $ gcloud alpha functions deploy hellohttp --bucket cloud-functions --trigger-http

> **Note:** The first time you deploy a function it may take several minutes as we need to provision the underlying infrastructure to support your functions. Subsequent deployments will be much faster.

Once the function is deployed, you should see a status of READY reported, along with the HTTP url.

> status: READY
> triggers:
> - webTrigger:
>   url: https://<REGION>.<PROJECT_ID>.cloudfunctions.net/hellohttp

The `<REGION>` shows the deployment region of your function, and the `<PROJECT_ID>` is your project. For example:

> https://us-central1.my-project.cloudfunctions.net/hellohttp

### Step 3 - Invoke your Function

You can test the function from the command line using the `curl` command:

> $ curl -X POST https://<REGION>.<PROJECT_ID>.cloudfunctions.net/hellohttp \
>   --data '{"message":"Hello World!"}'

Make sure you use an HTTP POST as Cloud Functions do not currently support other HTTP methods.
