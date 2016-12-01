> * 原文地址：[Webhooks do’s and dont’s: what we learned after integrating +100 APIs](https://restful.io/webhooks-dos-and-dont-s-what-we-learned-after-integrating-100-apis-d567405a3671)
* 原文作者：[Giuliano Iacobelli](Giuliano Iacobelli)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[steinliber](https://github.com/steinliber)
* 校对者：[xekri](https://github.com/xekri) , [DeadLion](https://github.com/DeadLion)

# Webhook 该做和不该做的: 我们在整合超过 100 个 API 中所学到的


当现在的应用变的越来越像 API 的集合而且无服务架构获得越来越多的关注时，作为一个 API 的提供者，不应该再只是暴露传统的 REST 接口。

传统 REST API 的设计是用来让你可以程序化的获取或提交内容，但在你只是想如果某些信息改变，API 再通知应用程序的情况下，传统 API 还远不够好，这还远远不是最佳的实践。如果是要实现这个的话,就需要定期轮询，而且这样还会失去扩展性。


![](https://cdn-images-1.medium.com/max/800/1*dEmrcTajSG5A4Z_JjrGqfw.png)

Picture credits [Lorna Mitchell](https://medium.com/u/e6dd3fdb7c2d)



为了获取一小段信息，轮询 API 通常是一种既浪费又复杂的方式。一些事件或许在一段时间内只发生一次，所以你必须推断出轮询的频率。然而即使这样你也可能错过它。

> Don’t call us, we’ll call you!

好的，webhook 就是这个问题的答案.  **webhook 就是 Web 服务使用 HTTP POST 请求为其他服务提供近实时信息的一种方式。**



![](https://cdn-images-1.medium.com/max/800/1*8t-MNjY-6rJ79rsDnZt0rA.png)

Picture credits [Lorna Mitchell](https://medium.com/u/e6dd3fdb7c2d)



一个 webhook 会在它调用时就传递数据到其它的应用，这表明你可以立即得到数据。这让使用了 webhook 的生产者和消费者都变的更有效率，如果你的 API 还不支持这些，你真应该做一些关于这方面的事。
(关注 [Salesforce](https://medium.com/u/f4fb2a348280) 了吗?).

当涉及到 webhooks 的设计，现在并没有类似标准的 HTTP API 这样的规范。每个服务实现不同的 webhook， 从而导致许多不同的 webhooks 实现风格。

我们在集成了来自 100 多个不同服务 API 后，可以说对外提供 webhook 的服务是个大“杀器”。当我们需要集成一个暴露 webhook 的服务时，这里有些建议能够帮助到我们。


#### 自我解释和一致性

一个好的 webhook 服务应该要尽可能多的提供被通知事件的信息，以及客户端执行该事件的其他信息。

客户端在创建 POST 请求的时候应该包含一个 `timestamp` 和 `webhook_id` 字段。如果你提供的是不同类型的 webhooks，不管它们是否被发送到单个端点都应该包含一个 `type` 属性。




![](https://cdn-images-1.medium.com/max/600/1*Yi85OX2kNJw-bbn8O0VVQQ.png)

Github webhook 携带数据的示例



[GitHub](https://medium.com/u/d18563e4f2b9) 非常完美的实现了以上这点。 请不要像 Instagram 或 Eventbrite 那样，只发送一个 ID 然后使用另一个 API 来解析。


如果你认为你的在一次请求中发送的有效数据太多，请给我机会让它变的更轻量。

[Stripe](https://medium.com/u/3ecae35d6d66)’s [event types](https://stripe.com/docs/api) 就是一个很好的例子。

#### 允许消费者定义多个 URLs

当你构建你的 webhooks ，你应该考虑到在另一端的人必须去接收你的数据。如果只给予他们在一个网址下订阅活动的机会，那肯定不是你所可以提供的最好的开发者体验。如果我需要在不同的系统上监听相同的事件就会遇到麻烦，然后我就需要把类似 Reflector.io 的库来在系统间管理数据。[Clearbit](https://medium.com/u/ce5450a7b906) 请开发这样的好的 API, 并相应加快你的 webhook 开发进程。


[Intercom](https://medium.com/u/7ca8972daf76) 在这方面做的非常好，让你可以添加多个 URLs，并为其中的每一个都定义想监听的事件。



![](https://cdn-images-1.medium.com/max/800/1*lGfFqT7G4x3swfm1qkxjfA.png)

Intercom 的 webhook 管理面板



#### 基于 UI 的订阅与基于 API 的订阅

一旦整合完成，我们应该如何处理实际订阅的创建？一些服务选择了使用 UI 来引导你完成订阅的设置，其他服务则为此提供了 API。



![](https://cdn-images-1.medium.com/max/600/1*lQ5VTo4IF50IjaimPq-F4Q.png)



[Slack](https://medium.com/u/26d90a99f605) 两种都支持。

它提供了一个精巧的UI，这使创建订阅很容易，并且它也提供了一个稳定的事件 API（仍然没有提供尽可能多的事件，比如说他们的实时消息传递 API ，但我相信他们的工作）

在选择是否为 Webhooks 提供 API 时，需要记住的一件重要的事情是，订阅将以什么规模和粒度提供，以及谁将会配置它们。

我发现让人感到好奇的是像 [MailChimp](https://medium.com/u/772bf2413f17) 这样的工具会迫使非技术的群体混淆 webhooks 配置。这些工具通过 API 提供 webhooks ，任何具有 Mailchimp 集成的第三方服务（例如 Stamplay，Zapier 或 IFTTT）都可以通过程序化的方式来实现，从而提供更好的用户体验。



![](https://cdn-images-1.medium.com/max/600/1*EEMaCdPa63smJ3oOSpQ60w.png)



要通过 API 创建新的 webhooks 订阅，你就应该像 HTTP API 中的任何其他资源一样来处理 __订阅__ 。

最近我们在工作中发现非常好的例子是由 Box 团队在今年[夏天](https://blog.box.com/blog/box-webhooks/)更新的 webhook 实现。

#### webhooks 安全

一旦有人配置他的服务从你的 webhook 接收有效信息，它将会监听任何发送到端点的有效信息。

如果消费者的应用程序会暴露敏感信息，那么它可以（可选）验证请求是否由你的服务生成的，而不是第三方假装是你。这种验证不是必需的，但为消息传输提供了一个额外的验证层。

现在有很多方法可以实现安全性，如果你想把安全性处理放在消费者一方，你可以选择给他一个白名单来接受指定IP地址的请求，但更容易的方法是设置一个秘密令牌并验证相关信息。

这方面可以从不同程度的复杂性开始做，比如说就像 Slack 或 Facebook 做的那样，在一开始使用一个纯文本共享的秘钥。



![](https://cdn-images-1.medium.com/max/800/1*qyzDKFf4CfPwJEozGIah0w.png)


至于更复杂的实现。比如说 Mandrill 对 webhook 请求进行签名，webhook POST 请求的 HTTP 头部包含了附加的`X-Mandrill-Signature` ，这个头中将包含请求的签名。要验证 Webhook 请求，就要使用 Mandrill 相同的密钥生成签名，并将这个签名与 `X-Mandrill-Signature` 头里的值进行比较。


#### 具有过期日期的订阅

现在对外提供整合了过期时间的订阅服务可能性不是很高，但可以我们可以看到这可以作为一个更常见的功能。 Microsoft Graph API 就是一个例子。除非你进行续订，否则通过 API 执行的任何订阅都将在 72 小时后过期。

从数据提供商的角度来看，这是有道理的。你不想继续向可能不再运行或对你数据感兴趣的服务发送 POST 请求，但对所有真正对此感兴趣的用户来说，这是一个令人不快的体验。你是微软：如果你做不了应该做的繁重工作那又应该谁去做呢？

#### 总结

webhook 领域的设计仍然是分散的，但是常见的模式终究会显露出来。

在 [**Stamplay**](https://stamplay.com/) API 集成是一个问题。我们每天都面临着集成的挑战，像 Swagger ，RAML 或 API Blueprint 这样的 OpenAPI 规范并不能有所帮助，因为它们都不支持webhook 场景。

所以如果你正在考虑实现 webhooks ，我邀请你想想他们的使用说明，看看例子
[GitHub](https://medium.com/u/d18563e4f2b9), [Stripe](https://medium.com/u/3ecae35d6d66), [Intercom](https://medium.com/u/7ca8972daf76) 和 [Slack API](https://medium.com/u/272cd95a3742).

PS. [Medium](https://medium.com/u/504c7870fdb6) 任何关于 webhooks 的想法？拜托，RSS 是老一套的做法啦。

**更新**: Medium 实际上提供了一种通过 [http://medium.superfeedr.com/](http://medium.superfeedr.com/) 实时通知的方式👌

