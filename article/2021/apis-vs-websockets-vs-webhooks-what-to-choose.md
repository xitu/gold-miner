> * 原文地址：[APIs vs. WebSockets vs. WebHooks: What to Choose?](https://blog.bitsrc.io/apis-vs-websockets-vs-webhooks-what-to-choose-5942b73aeb9b)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/apis-vs-websockets-vs-webhooks-what-to-choose.md](https://github.com/xitu/gold-miner/blob/master/article/2021/apis-vs-websockets-vs-webhooks-what-to-choose.md)
> * 译者：
> * 校对者：

# APIs vs. WebSockets vs. WebHooks: What to Choose?

![](https://cdn-images-1.medium.com/max/5760/1*k3Etz0QztOVwxIMYg1Tatw.jpeg)

If we take any application, we need a reliable mechanism to communicate between its components.

For example, in web applications, we need to communicate between browser and server. Sometimes, the server needs to send back messages to the browser. Besides, there are instances where the backend depends on another service that takes a long time to complete.

> **That’s where APIs, WebSockets, and WebHooks come into play. These methods provide a flawless mechanism to communicate and sync data across different parts of an application.**

Although these three methods primarily facilitate communication, there are some significant differences between them. So in this article, I will discuss how these three approaches work and how we can choose the most suitable method depending on the use case.

## APIs - Provides an interface and a contract for consumers.

> **API or Application Programming Interface is a contract between a consumer and the service provider who exposes the API typically over HTTP.**

This works exceptionally well for scenarios like basic CRUD operations from the web, mobile, or even for service to service integrations. Mostly the communications happen using JSON or XML as the data transfer format.

Let’s take a scenario where users search for products on an e-commerce website. Once the user requests what he wants using a search query, he will get a response within few seconds. The process of an API is simple as that.

![How API Call Works in a Web Application](https://cdn-images-1.medium.com/max/2000/1*2P5Wwur2TEno1WY0lZHP3w.png)

> **As I mentioned initially, API requests are originated from the consumer. So, they are well suited for applications like persisting state or perform a quick action to receive an immediate response from the back-end operation.**

However, if the server needs to communicate back to the browser, there is no direct method when using APIs unless the browser periodically checks for any updates.

For example, tasks like report generation could take more time and resources where it is typically done in the background. Therefore once the consumer tells the service provider to generate a report, there is no direct method to notify the completion. The browser might need to poll the API continuously.

**But polling is not efficient and we have better methods like WebSockets to address such challenges.**

## WebSockets - When you need real-time communication

> **WebSockets, address this challenge by allowing a persistent and bidirectional communication between the consumer and service provider.**

Having a full-duplex communications channel allows service providers to send messages at any time. Since all the modern browsers support WebSockets, it is the best solution for real-time web applications.

![How WebSocket Works](https://cdn-images-1.medium.com/max/2690/1*6pyJqsMadK3ItpzWa3qdSA.png)

> **However, keeping the connection open all the time increases resource consumption, power usage (mobile devices), and makes it difficult to scale.**

For example, if we take the same report generation scenario, using WebSockets might be a great option for the web. However, it might not work best for mobile, where we might need to look at technologies like push notifications. Besides, if our backend depends on an external service for generating the report, WebSockets isn’t the best option for the backend to external service communication.

**That’s where we need a mechanism like WebHooks.**

![How to connect consumer, backend, and external services using WebSockets and WebHooks.](https://cdn-images-1.medium.com/max/2006/1*vhbQNBBr2Lmzz2QBa5KYkQ.png)

## WebHooks - Perfect solution for Backend Callbacks

WebHooks provides a solution for the overkilling issue in WebSockets by providing a disconnected mechanism to receive a response originate from the service provider.

If we look at the technical side, the consumer registers the WebHook (callback URL) into the service provider, and that URL will act as the place to receive data from WebHook.

> **In most cases, this URL belongs to another server, and WebHooks are mostly used to communicate between servers or backend-processes.**

If we dig deep into the process, we can break this process into four parts.

![How WebHook Works](https://cdn-images-1.medium.com/max/3000/1*2BYW_05KftDQ4U3XVrXQOA.png)

* **Event Trigger**: This is the event you specified to run the WebHook. Each time the event occurs, WebHook will do its job
* **WebHook provider creates the WebHook and sends POST request:** WebHook provider is responsible for monitoring the event and making the WebHook. Once the event is triggered, the WebHook provider will send the POST HTTP request to the third-party application.
* **The third-party application receives data**: The third-party application will receive data to the URL or the listener you provide to the WebHook provider when registering.
* **The action specified in the third-party application**: Once the application receives the POST request, developers can use the data for anything they want.

> **On the surface level, you will feel that it is completely the opposite of the APIs process, and due to that reason, most people refer to WebHooks as Reverse APIs.**

---

## Conclusion

As I have mentioned initially, WebHooks, WebSockets, and APIs facilitate communication; they have various use cases.

APIs are the best option for applications where you just need basic CRUD operations and synchronous responses. Also, APIs can be used with both web and mobile applications and service integrations with ease.

But, if your web application requires real-time communication with the backend, you should choose WebSockets. It allows you to establish a 2-way communication channel between your browser and the backend.

However, WebHooks are slightly different from APIs and WebSockets, which is more like a reverse API. Once the Consumer registers the WebHook URL in the service provider, the latter can call the WebHook when required.

I think now you understand the different use cases of these communication methods and if you have anything to share, please share in the comments section.

Thank you for Reading !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
