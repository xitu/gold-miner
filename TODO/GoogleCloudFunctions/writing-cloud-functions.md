# Writing Cloud Functions

Google Cloud Functions are written in JavaScript, and execute in a [Node.js](https://nodejs.org/en/) runtime. When creating Cloud Functions, your function's source code must be exported in a Node.js [module](https://nodejs.org/api/modules.html).

The simplest form is to _export_ the function:

```
exports.helloworld = function (context, data) {
  context.success('Hello World!');
};
```

Or you can export an object whose keys and values are function names and functions:

```
module.exports = {
  helloworld: function (context, data) {
    context.success('Hello World!');
  }
};
```

Your module can export any number of functions, but they each must be deployed separately.

## Function Parameters

The Cloud Functions you define must accept two parameters: _context_ and _data_.

### Context Parameter

The _context_ parameter contains information about the execution environment and includes a callback function to signal completion of your function:

Function|Arguments|Description
--------|---------|-----------
context.success([message])|message (string)|Called when your function completes successfully. An optional message argument may be passed to success that will be returned when the function is executed synchronously.
context.failure([message])|message (string)|Called when your function completes unsuccessfully. An optional message argument may be passed to failure that will be returned when the function is executed synchronously.
context.done([message])|message (string)|Short-circuit function that behaves like success when no message argument is provided, and behaves like failure when a message argument is provided.

> **Note:** You should always call one of `success()`, `failure()`, or `done()` when your function has completed. Otherwise your function may continue to run and be forcibly terminated by the system.

Example:

```
module.exports = {
  helloworld: function (context, data) {
    if (data.message !== undefined) {
      // Everything is ok
      console.log(data.message);
      context.success();
    } else {
      // This is an error case
      context.failure('No message defined!');
    }
  }
};
```

### Data Parameter

The `data` parameter holds the data associated with the event that triggered the execution of the function. The contents of the `data` object depend on the trigger for which the function was registered (for example, the [Cloud Pub/Sub topic](https://cloud.google.com/pubsub/docs) or [Google Cloud Storage bucket](https://cloud.google.com/storage/docs/)). In the case of self-triggered functions (e.g. manually publishing an event to Cloud Pub/Sub), the `data` parameter will contain the message you published.

## Function Dependencies

A Cloud Function is allowed to use other Node.js modules as well as other local data. Dependencies in Node.js are managed with [npm](https://docs.npmjs.com/) and expressed in a metadata file called `package.json` shipped alongside your function. You can either pre-package fully materialized dependencies within your function package, or simply declare them in the `package.json` file and Cloud Functions will download them for you when you deploy. You can learn more about the `package.json` file from the [npm docs](https://docs.npmjs.com/files/package.json).

In this example a dependency is listed in the `package.json` file:

```
"dependencies": {
  "node-uuid": "^1.4.7"
}
```

And the dependency is used in the Cloud Function:

```
var uuid = require('node-uuid');

exports.uuid = function (context, data) {
  context.success(uuid.v4());
};
```

## Writing and Viewing Logs

To emit a log line from your Cloud Function, use either `console.log`, or `console.error`.

Example:

```
exports.helloworld = function (context, data) {
  console.log('I am a log entry!');
  context.success();
};
```

*   `console.log()` commands are given the **INFO** log level.
*   `console.error()` commands are given the **ERROR** log level.
*   Internal system messages are written with the **DEBUG** log level.

Logs for Cloud Functions are viewable either in the Cloud Logging UI, or via the `gcloud` CLI.

To view logs in with the CLI, use the `get-logs` command:

> $ gcloud alpha functions get-logs

To view the logs for a specific function, provide the function name as an argument:

> $ gcloud alpha functions get-logs <FUNCTION_NAME>

You can even view the logs for a specific execution:

> $ gcloud alpha functions get-logs <FUNCTION_NAME> --execution-id d3w-fPZQp9KC-0

For the full range of log viewing options, view the help for `get-logs`:

> $ gcloud alpha functions get-logs -h

Alternatively, you can [view logs for Cloud Functions](https://console.cloud.google.com/project/_/logs?service=cloudfunctions.googleapis.com) from the Cloud Platform Console.
