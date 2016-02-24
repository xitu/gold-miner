# Calling Cloud Functions

Google Cloud Functions can be associated with a specific trigger. The trigger type determines how and when your function will execute. The current version of Cloud Functions supports the following native trigger mechanisms:

*   [Google Cloud Pub/Sub](#google_cloud_pubsub)
*   [Google Cloud Storage](#google_cloud_storage)
*   [HTTP Invocation](#http_invocation)
*   [Debug/Direct Invocation](#debugdirect_invocation)

You can also integrate Cloud Functions with any other Google service that supports Cloud Pub/Sub, or any service that provides HTTP callbacks (webhooks). This is described in more detail in [Additional Triggers](#other).

## Google Cloud Pub/Sub

Cloud Functions can be triggered asynchronously via a [Cloud Pub/Sub topic](https://cloud.google.com/pubsub/docs). Cloud Pub/Sub is a globally distributed message bus that automatically scales as you need it and provides a foundation for building your own robust, global services.

Example:

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-topic hello_world

Argument|Description
--------|-----------
--trigger-topic|The name of the Cloud Pub/Sub topic to which the function will be subscribed.

Cloud Functions invoked from Cloud Pub/Sub triggers will be invoked with the data contained in the message that was published to the Pub/Sub topic. This must be a JSON document.

## Google Cloud Storage

Cloud Functions can respond to Object Change Notifications emerging from [Google Cloud Storage](https://cloud.google.com/storage/docs). These change notifications are triggered in response to object addition (create), update (modify), or deletion.

Example:

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-gs-uri my-bucket


Argument|Description
--------|-----------
--trigger-gs-uri|The name of the Cloud Storage bucket the function will watch for changes.

Cloud Functions invoked from Cloud Storage triggers will be invoked with an Object Addition, Update, or Deletion event which has a predefined JSON structure, as [documented here](https://cloud.google.com/storage/docs/object-change-notification#_Type_AddUpdateDel).

## HTTP Invocation

Cloud Functions can be invoked synchronously via an HTTP POST. To create an HTTP endpoint for your function, you specify `--trigger-http` as the trigger type when deploying your function. HTTP invocations are synchronous, which means that the result of your function execution will be returned as the HTTP response body.

Example:

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-http

> **Note:** HTTP invocation currently only supports the HTTP POST method. Any other invocation method (such as GET or PUT) causes a 405 (Method Not Supported) result.

A Cloud Function deployed with an HTTP trigger can then be invoked with a simple `curl` command:

> $ curl -X POST <HTTP_URL> --data '{"message":"Hello World!"}'

The `<HTTP_URL>` associated with a Cloud Function can be seen after the function is deployed, or queried at any time via the `describe` command in gcloud.

## Debug/Direct Invocation

To support quick iteration and debugging, Cloud Functions provides a _call_ command in the CLI and a test function in the UI. This allows you to manually invoke a function to ensure it is behaving as expected. This causes the function to execute synchronously even though it may have been deployed with an asynchronous trigger type like Cloud Pub/Sub.

Example:

> $ gcloud alpha functions call helloworld --data '{"message":"Hello World!"}'

## Additional Triggers

Because Cloud Functions can be invoked by messages on a Cloud Pub/Sub topic, you can easily integrate Cloud Functions with any other Google service that supports Cloud Pub/Sub as an event bus. In addition by leveraging HTTP invocation you can also integrate with any service that provides HTTP callbacks (webhooks).

### Cloud Logging

Google Cloud Logging events can be exported to a Cloud Pub/Sub topic from which they can then be consumed by a Cloud Functions. See the Cloud Logging documentation on [exporting logs](https://cloud.google.com/logging/docs/export/configure_export) for more information.

### GMail

Using the [GMail Push Notification API](https://developers.google.com/gmail/api/guides/push) you can send GMail events to a Cloud Pub/Sub topic and consume them with a Cloud Function.
