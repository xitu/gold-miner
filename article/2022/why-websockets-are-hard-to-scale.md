> * 原文地址：[hy Websockets are Hard To Scale？](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267)
> * 原文作者：[nooptoday](https://dev.to/nooptoday)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/why-websockets-are-hard-to-scale.md](hhttps://github.com/xitu/gold-miner/blob/master/article/2022/why-websockets-are-hard-to-scale.md)
> * 译者：
> * 校对者：

![Cover image for Why Websockets are Hard To Scale?](https://res.cloudinary.com/practicaldev/image/fetch/s--MeJ0-6T_--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/c44dw0f0iguuiho1sn5c.jpeg)

## Why Websockets are Hard To Scale?

Cover photo by [fabio](https://unsplash.com/@fabioha)

Websockets provide an important feature: bidirectional communication. Which allows servers to **push** events to clients, without the need of a client request.

The **bidirectional** nature of websockets is both a grace and a curse! Even though it provides a great ton of use case for websockets, it makes implementing a scalable websocket server a lot harder compared to HTTP servers.

> _Shameless self promotion:_ I think websockets are an important part of the web, and they need more recognition among software development world. I am planning to publish more posts about the websockets, if you don't want to miss out you can check out [https://nooptoday.com/](https://nooptoday.com/) and subscribe to my mailing list!

___

## [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#what-makes-websockets-unique)What Makes Websockets Unique?

Websocket is an application layer protocol, just like HTTP which is another application layer protocol. Both protocols are implemented over TCP connection. But they have different characteristics and they represent two different countries in the communications world - \*if that makes sense :) \*

HTTP carries the flag for request-response based communication model,  and Websocket carries the flag for bidirectional communication model.

> Side Note: In an attempt to draw a clearer picture of Websocket, you will see a HTTP vs Websocket comparison throughout the post. But that doesn't mean they are competing protocols, instead they both have their use cases.

**Characteristics of Websocket:**

-   Bidirectional communication
-   Long lived TCP connection
-   Stateful protocol

**Characteristics of HTTP:**

-   Request response based communication
-   Short lived TCP connection
-   Stateless protocol

### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#stateful-vs-stateless-protocols)Stateful vs. Stateless Protocols

I'm sure you've seen some of the posts about creating _stateless, and endlessly scalable backend servers._ They tell you to use JWT tokens for stateless authentication, and use lambda functions in your stateless application etc.

-   What is this **state** they are talking about and why it is so important when it comes to scaling server applications?

**State** is all the information your application has to _remember_ to function correctly. For example, your application should remember logged in users. 99% of the applications do this ( _source: trust me_ ), and it is called session management.

-   Okay, then state is a great thing! Why do people hate it, and always try to make **stateless applications?**

You need to store your state in somewhere, and that _somewhere_ is typically the memory of server. But memory of your application server is not reachable from other servers, and the problem begins.

Imagine a scenario:

-   **User A** makes a request to **Server 1**. **Server 1** authenticates **User A**, and saves its **Session A**, to the memory.
-   **User A** makes second request to **Server 2**. **Server 2** searches saved sessions but it can't find **Session A**, because it is stored inside **Server 1**.

In order for your server to become scalable you need to manage the state outside of your application. For example you can save sessions to a Redis instance. This makes application state available to all the servers via Redis, and **Server 2** can read **Session A** from the Redis.

___

**Stateful Websocket:** Opening a Websocket connection is like a wedding between the client and the server: the connection stays open until one of the parties close it ( _or cheat on it, due to network conditions of course_ ).

**Stateless HTTP:** On the other hand, HTTP is a heartbreaker, it wants to end everything as fast as possible. Once a HTTP connection is opened, client sends a request and as soon as server responds, the connection is closed.

Okay, I will stop with the jokes now, but remember Websocket connections are _typically_ long lived, whereas HTTP connections are meant to end asap. The moment you introduce Websockets into your application, it becomes **stateful.**

#### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#in-case-you-wonder)In Case You Wonder

Even though both HTTP and Websocket are built on top of TCP, one can be stateles, while the other one is stateful. For simplicity, I didn't want to confuse you with details about TCP. But keep in mind, even in HTTP, underlying TCP connection can be long lived. This is out of scope for this post, but you can learn more about it [here](https://en.wikipedia.org/wiki/HTTP_persistent_connection)

### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#cant-i-just-use-a-redis-instance-to-store-sockets)Can't I Just Use a Redis Instance to Store Sockets?

In the previous example with sessions, the solution was simple. Use an external service to store sessions, so every other server can read sessions from there ( Redis Instance ).

Websockets are a different case, because your state is not only the data about socket, inevitably you are storing **connections** in your server. Every websocket connection is bound to a single server, and there is no way for other servers to send data to that connection.

Now, comes the second problem, you must have a way for other servers to send message to that websocket connection. For that, you need to have a way to send messages between servers. Luckily, that is already a thing called **message broker**. You can even use Redis pub / sub mechanism to send messages between your servers.

Let's summarize what have we discussed so far:

-   Websocket connections are stateful
-   A websocket server automatically becomes a stateful application
-   In order for stateful applications to scale, you need to have an external state storage ( example: Redis )
-   Websocket connections are bound to a single server
-   Servers need to connect to a message broker to send message to websockets in other servers

_Is that it? Adding a Redis instance to my stack solves all the scaling problems with Websockets?_

Unfortunately, no. Well, there is another issue with scalable websocket architectures: **Load Balancing**

### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#load-balancing-websockets)Load Balancing Websockets

Load balancing is a technique to ensure, all of your servers share somewhat equal amount of load. In a plain HTTP server, this can be implemented with simple algorithms like Round Robin. But that is not ideal for a Websocket server.

Imagine you have an auto scaling server group. That means, as the load increases new instances are deployed and as the load decreases some instances are closed.

Since HTTP requests are short lived, the load balances somewhat evenly across all instances even though servers are added / removed.

Websocket connections are long lived ( persistent ), which means new servers will not take the load off from old servers. Because, old servers are still persisting their websocket connections. As an example, say **Server 1**, has 1000 open websocket connections. Ideally, when a new server **Server 2** is added, you want to move 500 websocket connections from **Server 1**, to **Server 2**. But that is not possible with traditional load balancers.

You can drop all websocket connections, and expect clients to reconnect. Then you can have 500 / 500 websocket connection distribution on your servers, but that is a bad solution because:

1.  Servers will be bombarded with reconnection requests, and server load will fluctuate greatly
2.  If servers are scaled frequently, clients will reconnect frequently and it can have a negative effect on user experience
3.  It is not an elegant solution - _I know you guys care about this!_

The most elegant solution for this problem is called: **Consistent Hashing**

## [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#load-balancing-algorithm-consistent-hashing)Load Balancing Algorithm: Consistent Hashing

There are various load balancing algorithms out there, but consistent hashing is just from another world.  
[![meme about consistent hashing](https://res.cloudinary.com/practicaldev/image/fetch/s--5P8luiyt--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://nooptoday.com/content/images/2022/12/image-1.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--5P8luiyt--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://nooptoday.com/content/images/2022/12/image-1.png)  
The basic idea behind load balancing with consistent hashing is that:

-   Hash the incoming connection with some property, lets say **userId => hashValue**
-   You can then use **hashValue** to determine which server this user should connect to

This assumes that your hash function evenly distributes **userId** to **hashValue**.

BUT, there is always a but, isn't there... Now you still have the problem when you add / remove servers. And the solution is to drop connections when new servers are added or removed.

_Wait, what! You just said that was a bad idea? How is that a solution, now?_

The beauty of this solution is that, with consistent hashing you don't have to drop _all the connections_, but you should just drop only some of the connections. Actually, you drop exactly how many connections you need to drop. Let me explain with a scenario:

-   Initially, **Server 1** has 1000 connections
-   **Server 2** is added
-   As soon as **Server 2** is added, **Server 1** runs a rebalancing algorithm
-   Rebalance algorithm detects which websocket connections are needed to drop, and if our hash function detects roughly 500 connections that need to go to **Server 2**
-   **Server 1**, emits a reconnect message to those 500 clients, and they connect to **Server 2**

[Here is a great video by ByteByteGo](https://www.youtube.com/watch?v=UF9Iqmg94tk) that explains the concept visually.

### [](https://dev.to/nooptoday/why-websockets-are-hard-to-scale-1267#a-much-simpler-and-efficient-solution)A Much Simpler And Efficient Solution

Discord manages a lot of Websocket connections. How did they solve the problem with load balancing?

If you investigate the [developer docs](https://discord.com/developers/docs/topics/gateway#get-gateway) about how to establish a websocket connection, here is how they do it:

-   Send a HTTP GET request to `/gateway` endpoint, receive available Websocket server urls.
-   Connect to Websocket server.

The magic behind this solution is, you can control which server new clients should connect. If you add new server, you can direct all the new connections to new server. If you want to move 500 connections from **Server 1** to **Server 2**, simply drop 500 connections from **Server 1**, and supply **Server 2** address from `/gateway` endpoint.

`/gateway` endpoint needs to know load distributions of all the servers, and make decisions based on that. It can simply return url of the server with minimum load.

This solution works and much simpler compared to consistent hashing. But, consistent hashing method doesn't need to know about load distribution of all the servers, and it doesn't require a HTTP request before hand. Therefore, clients can connect faster but that is generally not an important consideration. Also, implementing a consistent hashing algorithm can be tricky. That is why, I am planning to create a follow up post about Implementing Consistent Hashing for Load Balancing Websockets.

I hope you learned something new from this post, please let me know what you think in the comments. You can subscribe to mailing list if you don't want to miss out on new posts!



> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。