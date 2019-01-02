* 原文[Writing Cloud Functions](https://cloud.google.com/functions/writing)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo)
* 校对者: [shenxn](https://github.com/shenxn) [CoderBOBO](https://github.com/CoderBOBO) [edvarHua](https://github.com/edvardHua)


##编写 Cloud Functions

Google Cloud Functions 是由 JavaScript 编写并在 node.js 运行环境中执行。当创建 Cloud Functions 时，你的函数源码必须导出为 Node.js 的[模块](https://nodejs.org/api/modules.html)

导出函数最简单的形式：

```js
exports.helloworld = function (context, data) {
  context.success('Hello World!');
};
```

或者你也可以通过函数名字和函数体作为键值对的方式导出：

```js
module.exports = {
  helloworld: function (context, data) {
    context.success('Hello World!');
  }
};
```

你的模块可以导出任意多的函数，但它们必须是分开部署

##函数参数

你定义的 Cloud Functions 必须收俩个参数：context 以及 data。

###Context参数

context 函数包含执行环境的信息并且包括一个回调函数来标示你的函数运行完成

| Function       | Aruments           | Description  |
| ------------- |:-------------:| -----:|
|context.success([message])|message (string)|当你函数成功完成时调用。可以给它传一个可选的 message 参数给 success 用于当函数同步执行结束时返回|
|context.failure([message])|message (string)|当函数运行失败是调用。可以给它传一个可选的 message 参数给 failure 用于当函数同步执行结束时返回|
|context.done([message])|message (string)|短路函数，当没有提供 message 参数时表现和 success 一样当提供 message 参数时表现和 failure 一样。|

>注意: 当你的函数完成时一定要调用 success(),failure(),或者 done() 中的一个。否则你的函数可能继续运行直到被系统强制结束。

例子：

```js
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

###Data 参数

Data 参数持有事件相关的数据，这里的事件是指引起触发器执行函数的事件。data 对象的上下文依赖于函数注册的触发器(比如，[Cloud Pub/Sub topic](https://cloud.google.com/pubsub/docs) 或者 [Google Cloud Storage bucket](https://cloud.google.com/storage/docs/))。在自触发的函数中(比如手动给 Cloud Pub/Sub 发布事件) data 参数包含你发布的信息

##函数依赖

Cloud Function 允许使用其它 Node.js 模块，以及其它的本地数据。在 Node.js 中依赖是由 [npm](https://docs.npmjs.com/) 管理的，在 package.json 中添加。你可以直接将全部依赖打包在你的函数包中，也可以在 package.json 中简单的声明一下，Cloud Function 会在你需要用到的时候自动下载它们。参考[npm 文档](https://docs.npmjs.com/files/package.json)了解更多关于 package.json 内容。

在这个例子中依赖是列举在 `package.json` 文件中的:

```js
"dependencies": {
  "node-uuid": "^1.4.7"
}
```
在 Cloud Function 中使用依赖:

```js
var uuid = require('node-uuid');

exports.uuid = function (context, data) {
  context.success(uuid.v4());
};
```

##记录和查看日志

你可以使用 console.log 或者 console.error 来从 Cloud Function 中输出日志

比如：

```js
exports.helloworld = function (context, data) {
  console.log('I am a log entry!');
  context.success();
};
```

* console.log() 给出 INFO 类型的日志
* console.error() 给出 ERROR 类型的日志
* 内部系统消息是 DBUG 日志类别

Cloud Function 的日志可以通过 Cloud Logging 界面查看，或者通过命令行工具 gcloud 查看。

在命令行界面使用 get-logs 命令查看日志：

> $ gcloud alpha functions get-logs

把函数名作为参数来查看特定函数的日志:


> $ gcloud alpha functions get-logs <FUNCTION_NAME>

你甚至可以查看某次执行的日:

> $ gcloud alpha functions get-logs <FUNCTION_NAME> --execution-id d3w-fPZQp9KC-0

通过 get-logs 的帮助信息来了解查看日志的所有选项:

> $ gcloud alpha functions get-logs -h

另外，你也可在从云平台的命令行查看 [Cloud Function](https://console.cloud.google.com/project/_/logs?service=cloudfunctions.googleapis.com&_ga=1.6185779.1008720489.1449201561) 的日志
