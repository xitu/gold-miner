> * 原文地址：[APIs vs. WebSockets vs. WebHooks: What to Choose?](https://blog.bitsrc.io/apis-vs-websockets-vs-webhooks-what-to-choose-5942b73aeb9b)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/apis-vs-websockets-vs-webhooks-what-to-choose.md](https://github.com/xitu/gold-miner/blob/master/article/2021/apis-vs-websockets-vs-webhooks-what-to-choose.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# API、WebSocket 和 WebHooks：究竟应该选谁

![](https://cdn-images-1.medium.com/max/5760/1*k3Etz0QztOVwxIMYg1Tatw.jpeg)

如果我们使用些什么应用程序，大多数情况下我们需要一种可靠的方法来在其组成部分之间进行通信。

例如，在 Web 应用程序中，我们需要在浏览器和服务器之间进行通信；有时，服务器需要将消息发送回浏览器；此外，在某些情况下，后端还可能依赖于另一个需要很长时间才能完成的服务。

> **这就是 API、WebSocket 和 WebHooks 发挥作用的地方。这些方法提供了一种完美的解决思路，让我们可以在应用程序的不同部分之间进行数据通信和同步。

尽管这三种方法主要都是为了通信，它们之间还是有一些明显的区别。在本文中，我将讨论这三种方法如何工作以及如何根据用例选择最合适的方法。

## API —— 为用户提供接口和协议。

> **API 或应用程序接口是用户与服务提供商之间的合同，并且 API 都通常在 HTTP 环境下被暴露出来。**

这对于从 Web、移动设备甚至是服务到服务集成的基本 CRUD 操作等场景都非常有效。大多数情况下，API 通信使用 JSON 或 XML 作为传输的数据的格式。

让我们作一个假设 —— 用户在电子商务网站上搜索产品。一旦用户使用搜索查询请求了自己想要查找的商品，他就会在几秒钟内得到响应。API 的使用真的非常简单。

![API 调用在 Web 应用程序中的工作方式](https://cdn-images-1.medium.com/max/2000/1*2P5Wwur2TEno1WY0lZHP3w.png)

> **正如我最初提到的，API 请求是用户发起的，因此它们非常适合诸如持久状态或执行快速操作以接收来自后端操作的立即响应的应用程序。

但是，如果服务器需要与浏览器进行通讯，则无法直接使用 API，除非浏览器定期发送请求获取是否有更新。

举个例子，诸如报告生成之类的任务可能会花费更多的时间和资源，而这通常需要在后台完成。用户请求服务提供商去生成报告后，服务器并没有直接的方法来通知用户完成的情况，我们的浏览器可能需要持续轮询 API。

**但是轮询效率不高，我们有更好的方法（如 WebSockets）来解决此类问题。**

## WebSockets —— 当你需要实时通信

> ** WebSocket，通过允许使用者和服务提供商之间进行持久的双向通信来解决这一挑战。

双向通信通道使服务提供商可以随时与用户端取得联系，因为所有现代浏览器都支持 WebSocket，因此它是实时 Web 应用程序的最佳解决方案。

![WebSocket的工作方式](https://cdn-images-1.medium.com/max/2690/1*6pyJqsMadK3ItpzWa3qdSA.png)

> **但是，始终保持连接打开会增加资源消耗和影响功耗（移动设备），并且难以扩展。**

例如，如果我们采用相同的报告生成方案，则使用 WebSockets 可能是 Web 上的一个不错的选择，但是，它可能不适用于移动设备，因为我们可能需要研究诸如推送通知之类的技术。依赖于外部服务来生成报告，WebSockets 并不是后端与外部服务通信的最佳选择。

**这就是我们需要 WebHooks 之类的机制的地方。**

![如何使用WebSockets和WebHooks连接使用者，后端和外部服务。](Https://cdn-images-1.medium.com/max/2006/1*vhbQNBBr2Lmzz2QBa5KYkQ.png)

## WebHooks —— 完美的后端回调解决方案

WebHooks 通过提供一种断开机制来接收来自服务提供者的响应，从而为 WebSockets 中的过大杀手问题提供了解决方案。

如果从技术方面来看，消费者将 WebHook（回调 URL）注册到服务提供商中，并且该 URL 将充当从 WebHook 接收数据的位置。

> **在大多数情况下，此 URL 属于另一台服务器，并且 WebHooks 通常用于在服务器或后端进程之间进行通信。

如果深入研究该过程，我们可以将该过程分为四个部分。

![WebHook的工作方式](https://cdn-images-1.medium.com/max/3000/1*2BYW_05KftDQ4U3XVrXQOA.png)

* **事件触发器**：这是您指定运行 WebHook 的事件，每次事件发生时，WebHook 都会执行其工作
* **WebHook 提供程序创建 WebHook 并发送POST请求：** WebHook 提供程序负责监视事件并制作 WebHook，一旦事件被触发，WebHook 提供程序将 POST HTTP 请求发送给第三方应用程序。
* **第三方应用程序接收数据**：第三方应用程序将在注册时将数据接收到 URL 或您提供给 WebHook 提供程序的侦听器。

* **第三方应用程序中指定的操作**：一旦应用程序收到POST请求，开发人员就可以将数据用于他们想要的任何东西。

> **从表面上看，您会觉得这与API流程完全相反，因此，大多数人将WebHooks称为反向API。

---

## 结论

正如我最初提到的，WebHooks，WebSockets 和 API 促进了通信；它们具有各种用例。

对于仅需要基本 CRUD 操作和同步响应的应用程序，API 是最佳选择，而且，API 可以轻松地与 Web 和移动应用程序以及服务集成一起使用。

但是，如果您的 Web 应用程序需要与后端进行实时通信，则应该选择 WebSockets，它允许您在浏览器和后端之间建立双向通信通道。

但是，WebHooks 与 API 和 WebSockets 稍有不同，后者更像是反向 API。一旦使用者在服务提供商中注册了 WebHook URL，后者就可以在需要时调用 WebHook。

我认为现在您了解了这些通信方法的不同用例，如果您有什么需要分享的内容，请在评论部分中分享。

谢谢您的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
