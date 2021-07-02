> * 原文地址：[My Favorite Interservice Communication Patterns for Microservices](https://blog.bitsrc.io/my-favorite-interservice-communication-patterns-for-microservices-d746a6e1d7de)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/my-favorite-interservice-communication-patterns-for-microservices.md](https://github.com/xitu/gold-miner/blob/master/article/2021/my-favorite-interservice-communication-patterns-for-microservices.md)
> * 译者：
> * 校对者：

# My Favorite Interservice Communication Patterns for Microservices

![](https://cdn-images-1.medium.com/max/10240/1*1aQ46doYRmM-Opgs2mWaHg.png)

Microservices are fun, they allow for the creation of very scalable and efficient architectures. All major platforms take advantage of them because of this. There is no way to have a Netflix or Facebook or Instagram without the help of Microservices.

However, splitting your business logic into smaller units and deploying them in a distributed manner is just step 1. You then have to understand what’s the best way to make them talk to each other. That’s right, Microservices aren’t only meant to be outwards-facing — or in other words, to serve external clients — sometimes they can act as clients to other services within the same architecture.

So how do you make two services talk to each other? The easy answer is to keep using the same API that is presented to the public. For example, if my public-facing API is a REST HTTP API, then by all means, all services will interact with each other through it.

And that is a very valid scenario, but let’s take a look at other ways we can improve on that.

## HTTP Apis

Let’s start with the basics, because it’s a very valid use case after all. An HTTP API essentially means having your services send information back and forth like you would through the browser or through a desktop client like [Postman](https://www.postman.com/).

It uses a client-server approach, which means the communication can only be started by the client. It is also a synchronous type of communication, meaning that once the communication has been initiated by the client, it won’t end until the server sends back the response.

![Classic Client-Server microservice communication](https://cdn-images-1.medium.com/max/2000/1*c_FfYp3-81j3JcfLpg-g4w.png)

This approach is very popular because it’s the way we browse the internet. You can think of HTTP as the backbone of internet, thus all programming languages have some way of providing HTTP capabilities, making it a very popular approach.

But it’s not perfect either, so let’s analyze it.

**Pros**

* **Easy to implement.** The HTTP protocol is not hard to implement and given all major programming languages already have native support for it, developers hardly need to worry about how it works internally. Its complexity is hidden and abstracted away by the libraries they use.
* **It can be quite standard.** If on top of HTTP you add something like REST (properly implemented that is), then you’ve created a standard API that allows for any client to quickly learn how to communicate with your business logic.
* **Technology agnostic**. Since HTTP acts as the data-transfer channel between client and server, the technology used to create either of them is irrelevant. You can code your server in Node.js and have the client (or the other services) coded in JAVA or C# for all they care. As long as they follow the same HTTP protocol they’ll be able to communicate with each other.

**Cons**

* **The channel adds a delay to the business logic.** HTTP it very reliable, but that’s because as part of the protocol, there are a few steps that make sure data is correctly sent through the channel. However, this protocol also adds latency to the communication (extra steps mean extra time). So consider a scenario where 3 or more microservices need to send data between each other until the last one finishes. In other words, having A send data to B so it can send data to C, to only then start sending the responses back. On top of each service’s time, you have to add the latency added by the 3 client-server channels opened between them.
* **Timeouts**. Although you can configure the timeout time in most scenarios, HTTP by default will cause the client to close the connection if the server is taking too long. How long is “too long”? That depends on the configuration and the service you’re using, however it’ll be there. This adds an extra constraint to your logic: it needs to be fast, otherwise it will fail.
* **Failures aren’t easy to solve**. It’s not impossible to work around a server failure, but you need to have extra infrastructure in place to solve it. By default the client-server paradigm will not notify the client if the server is down. The client will realize that too late: when they try to reach the server. As I said, there are ways to mitigate this, for example, by using load balancers or API gateways, but that’s extra work that needs to go on top of the client-server communication to make it reliable.

So an HTTP API is a great solution when you have a fast and reliable business logic that needs to be consumed by many different clients. This is especially helpful because when multiple groups are working on different clients they can work with a channel of communication that they’re familiar with and that is pretty standard.

Do not use an HTTP API if you want multiple services to interact with each other or if the business logic inside some of them requires a lot of time to complete.

## Asynchronous Messaging

This pattern consists of having a message broker between the producer of the message and the receiving end.

This is definitely one of my favorite ways of communicating multiple services with each other, especially when there is a real need to horizontally scale the processing power of the platform.

![Asynchronous communication between microservices](https://cdn-images-1.medium.com/max/2000/1*jHO2JfEHmEw6zZeSvdOzeA.png)

This pattern usually requires a message broker to be added into the mix, thus bringing a bit of extra complexity to the table. However, the benefits gained more than makeup for that.

**Pros**

* **Easy to scale**. One of the major problems of direct communication between client and server is that for the client to be able to send messages the server needs to have free processing power. But that’s limited by the amount of parallel processing a single service can perform. If the client requires more data to be sent then the service needs to grow and have more processing power. This sometimes is solved by scaling the infrastructure where the service is deployed, giving it a better processor or more memory, however this also has a limitation, since there is so much you can pay for before it becomes unreasonable. Instead, you can keep using lower specs infra and have multiples copies working in parallel. The message broker can distribute the received messages to more than one target service. Thus your copies can either all receive the same data or different messages depending on your particular needs.
* **Easy to add new services**. Hooking up new services to this workflow is as simple as creating a new service and subscribing to the type of message you’d like to receive. The producer doesn’t need to be aware of it, it just needs to understand what kind of message it needs to send. That’s all.
* **Easier retry mechanics**. When the message broker allows for it, if the delivery of the message fails due to the server worker being down, the broker can keep trying automatically without us having to write special logic.
* **Event-driven**. This pattern allows you to create event-driven architectures, which can be some of the most efficient ways of having microservices interact with each other. Instead of having a single service blocked because it’s waiting for a synchronous response, or even worse, having it constantly poll a storage medium waiting for its response, you can code your services so that they get notified once their data is ready. While that happens, they can be working on something else (like the next incoming request). This architecture allows for faster data processing, more efficient use of resources and overall better communication experience.

**Cons**

* **Debugging gets a bit harder**. Since there is no clear data flow now and messages get processed as soon as they can, debugging the data flow and the path your payload takes can become a nightmare. This is why it’s usually a good idea to generate a unique ID when the message is received, so that you can track the path it takes inside your internal architecture through the logs.
* **There is no clear direct response.** Given the asynchronous nature of this pattern, once a request is received from a client, the only potential response is “OK, received, I’ll let you know once it’s ready”. You could also validate the schema of the request sending a 400 error (if it’s an invalid request). The point being, the output returned by the logic you’re executing is not directly accessible to the client, instead it needs to be requested separately. As an alternative, the client can also subscribe to the message broker waiting for response-type messages. This way it gets notified immediately once the response message arrives.
* **The broker becomes a single point of failure**. If you don’t configure the message broker properly, it can become a problem for your architecture. Instead of suffering from unstable services that you wrote, you’re forced to maintain a message broker you barely know how to use.

This is definitely an interesting pattern and one that provides a great deal of flexibility. If you’re hoping to have one end producing a considerable amount of messages then having a buffer-like structure between the producers and consumers will increase the stability of your system.

Granted, the processing can turn out to be slow, but scaling it will become a lot easier with the buffer in place.

## Direct socket connection

Going on a completely different route, instead of relying on the good old HTTP to send and receive messages, we can also go with something a bit faster, albeit with less structure: sockets.

![Open channels with sockets for microservice communication](https://cdn-images-1.medium.com/max/2000/1*qpA4fBT_77oXD2xlXrw92w.png)

At a first glance, the socket-based communication looks a lot like the client-server pattern implemented in HTTP, however, if you look closely there are some differences:

* For starters, the protocol is a lot simpler, which means a lot faster as well. Granted, if you want it to be reliable you need to code a lot more on your part to make it so, however, the inherent latency added by HTTP is gone here.
* The communication can be started by any actor, not only the client. Through sockets, once you have your channel open, it’ll stay that way until you close it. Think about it as an ongoing phone call, anyone can start the conversation, not only the caller.

With that being said, let’s take a quick look at the pros and cons of this approach:

**Cons**

* **No real standards in place**. When compared with HTTP, the socket-based communication seems a bit messy because there aren’t any structured standards such as SOAP & REST for HTTP. So it’s really up for the implementing party to define how that structure looks like. This in turn makes it a bit harder for new clients to be created and implemented. However, if you’re doing this so that only your own services can interact with each other, you’re essentially implementing the protocol you defined.
* **Easy to overload the receiving end.** If one of the services starts producing too many messages for the other to process, you might end up overwhelming the second process and crashing it. This is what the previous pattern solved, by the way. Here you have a very small delay between sending and receiving the message, which means the throughput can be higher, but that also means the receiving service will have to process everything fast enough.

**Pros**

* **It’s very lightweight**. Implementing basic socket communication requires very little effort and setup. This, of course, depends on the language you’re using, but some of them, such as Node.js with [Socket.io ](https://socket.io/)allow you to communicate 2 services with but a few lines of code.
* **Allows for a very optimized communication process**. Since you have a constant open channel between the two services, they’re both able to react to incoming messages the moment they arrive. It’s not like you’re pooling a database asking for new messages, this is a reactive approach, which means you can’t really get faster than this.

Socket-based communication is a very efficient way of having your services talk to each other. For instance, Redis uses this method when deployed in a cluster configuration to automatically detect failing nodes and remove them from the cluster. This can be done because the communication is fast and cheap (meaning there is barely any extra latency involved and uses very little network resources).

Go with this approach if you’re able to control the amount of information exchanged between services and you don’t mind defining your own standard protocol.

## Lightweight events

This pattern mixes the first two on this list. On one side, it provides a way of having multiple services communicate with each other through a message bus, thus allowing for asynchronous communication. And on the other side, since it only sends very lightweight payloads through that channel, it requires services to hydrate that payload with extra information through a REST call to the corresponding service.

![Lightweight events & hydration during microservice communication](https://cdn-images-1.medium.com/max/2000/1*drW47mfHvCmISZdLRBSXNg.png)

This communication pattern can come very handy when you’re aiming to have the network traffic kept under control as much as possible, or when the message queue has packet-size limitations. In those cases, it’s best to keep things as simple as possible and then request the extra information only when required.

**Pros**

* **The best of both worlds**. This approach provides benefits of the asynchronous communication pattern by having 80–90% of the data being sent through the buffer-like structure. And only requiring a small portion of the network traffic to be done through a less efficient, yet standard, API-based approach.
* **Focused on optimizing the most common scenario**. If you know most of the time your services won’t need to hydrate the event with extra information, keeping it to a bare minimum will help optimize the network traffic and keep the requirements of the message broker very low.
* **Basic buffer**. Through this approach, the extra details of each event are kept secret and away from the buffer. This in turn breaks the coupling you could have in situations where a schema (for example) needs to be defined for these messages. Keeping the buffer “dumb” makes it a lot easier to exchange with another option given the case of a migration or a scaling requirement (i.e like going from RabbitMQ to AWS SQS).

**Cons**

* **You might end up with too many API requests**. If you’re not careful and implement this pattern for a use case that doesn’t fit, you’ll end up with an overhead of API requests that will only add extra latency to your service’s response times. Not to mention the extra network traffic added by all the HTTP requests sent between services. If this is your scenario, think about switching to a fully async-based communication model.
* **Double communication interface**. Your services will have to provide two different ways of communicating with each other. On one side they’ll implement the asynchronous model required for the message queue, but on the other, they’ll have to have an API-like interface as well. This can become hard to maintain given how different both approaches use-are.

This is a very interesting hybrid pattern, one that takes a bit of effort to code (given how you need to have two approaches mixed together).

It can be a very good network optimization technique, you have to make sure that for your use case, the hydration of the payloads only happens around 10 to 20% of the time, otherwise, the benefit will not be worth the extra effort required to code it.

---

The best way to communicate two microservices is the one that gives you what you’re looking for. If that’s performance, reliability, security, that’ll be something you know and the information you’ll have to use to pick the best pattern.

There is no “one pattern to rule them all” even if you, like me, like one more than the rest, realistically speaking, you’ll have to adapt to your context.

That being said, which one is your favorite, and why? Leave a comment and let’s nerd out about ways to get microservices to interact with each other!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
