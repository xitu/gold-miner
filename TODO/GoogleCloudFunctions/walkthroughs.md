* 原文[Walkthroughs](https://cloud.google.com/functions/walkthroughs)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo)
* 校对者: [shenxn](https://github.com/shenxn) [CoderBOBO](https://github.com/CoderBOBO) [edvarHua](https://github.com/edvardHua)


##演练

###Cloud 发布/订阅 版 Hello World

这节将会演示一个基本的 "Hello World" 例子。这个例子主要用了以下组件：

* Google Cloud Functions: 创建 Hello World 函数。
* Google Cloud Pub/Sub: 给函数发送消息。
* Google Cloud Logging: 查看 "hello world" 的消息。

###第一步：创建函数

在你的本地文件系统中创建一个项目的位置:

Linux/Mac

>$ mkdir ~/gcf_hello_world

>$ cd ~/gcf_hello_world

Windows

>$ mkdir %HOMEPATH%\gcf_hello_world

>$ cd %HOMEPATH%\gcf_hello_world

新建一个 index.js 的文件(注意，如果你想用另一个名字来命名，记得在 package.json 中把它定义成主属性)，并把下面的代码复制进去:

index.js

```js
exports.helloworld = function (context, data) {
  console.log('My GCF Function: ' + data.message);
  context.success();
};
```

###第二步：部署你的函数

使用一个名为 hello_world 的 Pub/Sub topic 部署函数

>$ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-topic hello_world

--trigger-topic 参数表示要创建或使用 Cloud Pub/Sub 主题，在这个主题下你可以发布事件。

```
注意：首次部署函数时可能要花费几分钟，因为我们需要为你的函数提供底层支持。随后的部署就会很快了
```

使用 describe 命令可以随时产看函数的状态：

>$ gcloud alpha functions describe helloworld

一旦函数部署成功，你将会看到状态变为 READY ，同时会有 Cloud Pub/Sub 主题的路径显示出来：

```
status: READY
triggers:
- pubsubTopic: projects/<PROJECT_ID>/topics/hello_world</pre>
```

###第三步：使用 call 命令测试你的函数

通过 call 命令可以在命令行下测试你的函数：

> $ gcloud alpha functions call helloworld --data '{"message":"Hello World!"}'

###第四步：查看日志

上面的命令是没有返回值的，你需要查看日志才能看到 "Hello World!" 字符串：

>$ gcloud alpha functions get-logs helloworld

###第五步：使用 Pub/Sub 发布一条消息

这个例子使用 Cloud Pub/Sub 作为触发器，因此你也可以通过发布 Pub/Sub 消息来触发函数：

>$ gcloud alpha pubsub topics publish hello_world '{"message":"Hello World!"}'

##HTTP 调用

下面这个例子创建了一个可以通过 HTTP 请求触发的简单函数。

###第一步：创建函数

在你本地系统创建工程：

Linux/Mac

>$ mkdir ~/gcf_hello_http

>$ cd ~/gcf_hello_http

Windows

>$ mkdir %HOMEPATH%\gcf_hello_http

>$ cd %HOMEPATH%\gcf_hello_http

新建一个 index.js 的文件(注意：如果你想用另一个名字来命名，记得在 package.json 中把它定义成主属性)，并把下面的代码复制进去:

index.js


```js
rts.hellohttp = function (context, data) {
  // Use the success argument to send data back to the caller
  context.success('My GCF Function: ' + data.message);
};
```

###第二步：部署你的函数

部署一个拥有 http 触发器的函数

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-topic hello_world

```
注意：首次部署函数时可能要花费几分钟，因为我们需要为你的函数提供底层支持。随后的部署就会很快了
```

使用 describe 命令可以随时产看函数的状态：

>$ gcloud alpha functions describe helloworld

一旦函数部署成功，你将会看到状态变为 READY ，同时会有一个 HTTP url：

```
status: READY
triggers:
- webTrigger:
  url: https://<REGION>.<PROJECT_ID>.cloudfunctions.net/hellohttp
```

<REGION> 表示你部署函数的地区，<PROJECT_ID> 是你项目的 ID 。比如：

>https://us-central1.my-project.cloudfunctions.net/hellohttp

###第三步：触发你的函数

可以用 crul 命令行工具测试你的函数：

> $ curl -X POST https://<REGION>.<PROJECT_ID>.cloudfunctions.net/hellohttp \
  --data '{"message":"Hello World!"}'

确保你的使用的是 HTTP POST 方法，因为 Cloud Functions 现在还不支持其它的 HTTP 方法。

