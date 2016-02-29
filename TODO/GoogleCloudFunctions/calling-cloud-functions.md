* 原文[Calling Cloud Functions](https://cloud.google.com/functions/calling)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [huanglizhuo](https://github.com/huanglizhuo)
* 校对者: [shenxn](https://github.com/shenxn) [CoderBOBO](https://github.com/CoderBOBO) [edvarHua](https://github.com/edvardHua)

##调用 Cloud Functions

Google Cloud Functions 可以和一个指定的触发器联系起来。触发器的类型决定了你的函数执行方式和执行时间。当前版本的 Cloud Functions 支持以下原生触发机制：

* [Goocle Cloud Pub/Sub](https://cloud.google.com/functions/calling#google_cloud_pubsub)
* [Goocle Cloud Storage](https://cloud.google.com/functions/calling#google_cloud_storage)
* [HTTP Invocation](https://cloud.google.com/functions/calling#http_invocation)
* [Debug/Direct Invocation](https://cloud.google.com/functions/calling#debugdirect_invocation)

你也可以把 Cloud Functions 和其它支持 Cloud Pub/Sub 的 Google 服务整合在一起，也可以和任何支持 HTTP 回调(webhooks) 的服务整合。这部分的更多细节在[其它触发器](https://cloud.google.com/functions/calling#other)中。

##Google Cloud Pub/Sub

Cloud Functions 可以通过 [Cloud Pub/Sub topic](https://cloud.google.com/pubsub/docs) 主题异步触发。Cloud Pub/Sub 全球性的分布式消息总线，可以根据你的需求弹性扩展与收缩，为你构建强健的，全球化的服务提供良好的基础。

例子：

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-topic hello_world

参数|描述
----|----
--trigger-topic|函数要订阅的Cloud Pub/Sub 主题名

由 Cloud Pub/Sub 触发器调用的 Cloud Functions 会接收到一个发布到 Pub/Sub 主题的 message，message必须是 JSON 格式。

##Google Cloud Storege

Cloud Functions 可以对 Google Cloud Storage 发出的对象修改通知做出回应。这些通知是由对象添加(创建)，更新(修改)，或者删除触发的。

例子：

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-gs-uri my-bucket

参数|描述
----|----
--trigger-gs-uri| 函数要监听变更的 Cloud Storage bucket 名字

由 Cloud Storage 触发器触发的 Cloud Functions 会接收到对象增加，更新，或者删除事件发出的预定义好的 JSON 结构，像这个[文档](https://cloud.google.com/storage/docs/object-change-notification#_Type_AddUpdateDel)中这样。

##HTTP 触发

Cloud Functions 可以由 HTTP POST 方法同步的触发。为你的函数添加一个 HTTP 端点，你得在部署函数时通过 --trigger-http 指明触发器类型。HTTP 调用是同步触发的，也就意味着函数的结果会在 HTTP 响应的 body 中返回。

例子：

> $ gcloud alpha functions deploy helloworld --bucket cloud-functions --trigger-http

```
注意：现在只支持 HTTP POST 方法。其它任何方法(比如 GET 或者 PUT)都会引发 405(方法不支持) 错误。

部署带有 HTTP 触发的 Cloud Functions 可以通过简单的 curl 命令触发：

> $ curl -X POST <HTTP_URL> --data '{"message":"Hello World!"}'
```

<HTTP_URL> 会在函数部署后返回，也可使用 gcloud 的 describe 查看

##Debug/Direct 调用

为了支持快速迭代和调试，Cloud Functions  命令行工具提供了 call 命令，并且在 UI 中提供了一个测试函数。这样你就可以手动调用函数并确保它的正确性。这种调用方式会同步触发函数的执行，即使部署时它的触发器是异步的，比如 Cloud Pub/Sub 触发器。

例子：

> $ gcloud alpha functions call helloworld --data '{"message":"Hello World!"}'


##其它触发器 

由于 Cloud Functions 可以由 Cloud Pub/Sub 主题消息触发，因此你可以把它和任何其它支持 Cloud Pub/Sub 作为事件总线的的 Google 服务整合起来。 借助于 HTTP 触发方式，你可以把任何其它提供 HTTP 回调(webhooks) 的服务整合起来。

###Cloud 日志

Google Cloud Logging 事件可以输出到任何可以被 Cloud Functions 消费的 Cloud Pub/Sub 主题。在[这里](https://cloud.google.com/logging/docs/export/configure_export)参看更多关于 Cloud Logging 的文档。

###GMail

使用 [GMail推送通知 API](https://developers.google.com/gmail/api/guides/push) 你可以把 GMail 事件发送给 loud Pub/Sub 主题并交给 Cloud Functions 处理。
