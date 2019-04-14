> * 原文地址：[Millions of active WebSockets with Node.js](https://medium.com/@alexhultman/millions-of-active-websockets-with-node-js-7dc575746a01)
> * 原文作者：[Alex Hultman](https://medium.com/@alexhultman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/millions-of-active-websockets-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/millions-of-active-websockets-with-node-js.md)
> * 译者：
> * 校对者：

# Millions of active WebSockets with Node.js

> Serving a metric buttload of WebSockets using no more than a consumer grade laptop and a bit of Wifi

With the newly released TypeScript web server project [uWebSockets.js](https://github.com/uNetworking/uWebSockets.js), we saw not only improved performance but improved memory usage as well. Especially so for Node.js users, and for the sake of demonstration I therefore wanted to set up a large scale test in a real world environment.

We are going to use my 6-year-old laptop which has a total of 8GB RAM and a “72Mbit” Wifi network adapter (that’s the link speed). It also has a 1Gbit Ethernet network adapter which we will play with later on. Everything is consumer grade, nothing has been upgraded since acquisition in 2013. This laptop will run Node.js with uWebSockets.js v15.1.0 installed.

![The server hardware](https://cdn-images-1.medium.com/max/2000/1*rXwVs5rZXES07sHY29xrKw.jpeg)

We first need to configure the Linux system a bit — mainly we need to raise the allowed file limit by editing /etc/security/limits.conf (your system may vary, this is Ubuntu 18.04). Add the following lines:

```
* soft nofile 1024000
* hard nofile 1024000
```

We then need to set some other variables (again, your mileage may vary):

```bash
sudo sysctl net.ipv4.tcp_tw_reuse=1
sudo sysctl fs.file-max=1024000
```

You then need to set up about 50-or-so IP addresses in a range. For my Wifi adapter I ran this line:

```bash
for i in {135..185}; do sudo ip addr add 192.168.0.$i/24 dev wlp3s0; done
```

The theoretical limit is 65k connections per IP address but the actual limit is often more like 20k, so we use multiple addresses to connect 20k to each (50 * 20k = 1 mil).

I then run the web server as root by typing **sudo -i** followed by **ulimit -n 1024000** and then **node examples/WebSocket.js** (in the uWebSockets.js folder).

That’s about it, really. The client side has similar settings but does not need to set up multiple IP addresses, obviously. The client computer runs a single threaded C client written using [uSockets](https://github.com/uNetworking/uSockets). Source code for this test is all open source and the client is the “scale_test.c” located in uWebSockets/benchmarks folder. You may need to make some smaller edits for your run.

Reaching 1 million WebSockets takes a few minutes, it could be improved if we wanted to, by having a bigger connect batch and by using multiple threads client side (and whatnot) but this is not relevant to the server side which is what we are interested in. The server side runs on one single thread and never sees any real CPU usage during the connection phase or afterwards:

![](https://cdn-images-1.medium.com/max/3840/1*-gdCkfDWjOxShtjPP8H8ng.png)

First off, let’s talk about the 5k closed connections. uWebSockets.js has been configured to drop and kill every WebSocket that is idle for more than 60 seconds. The “idleTimeout” setting is used. This means we need to actively have one WebSocket message sent and received for every one million WebSockets each 60 seconds.

You can see the traffic spikes relating to ping messages in the above network graph. A minimum of 16.7k WebSocket messages need to reach the server every second — everything less and we start dropping connections.

Obviously we are not properly meeting this criteria over the Wifi network. We are dropping a few connections. Still — 995k alive WebSockets over a nothing-fancy Wifi network is kind of cool!

![](https://cdn-images-1.medium.com/max/3840/1*Os3oBCZSt_nHOLrORmHp9g.png)

CPU usage of the server side is steadily at 0–2% and user space memory usage is about 500 MB while the overall system wide memory usage is about 4.7 GB. CPU usage or memory usage never spiked server side, it was completely stable throughout.

Okay! So let’s bring out the big gun; Ethernet. We hook up server and client to a 1Gbit consumer grade router and re-run the test:

![](https://cdn-images-1.medium.com/max/3840/1*1v2fewfRAR21nryDIj_I6w.png)

Stable without any connection loss, the Wifi network was not enough but Ethernet is. To make sure that everything really was stable I let the client and server stand for an hour and there was no single connection loss afterwards, some 120 million WebSocket messages later (16.7k * 60 * 60 * 2):

![](https://cdn-images-1.medium.com/max/3840/1*jp2Nm_t67771fNdo4eeRYQ.png)

Everything stable and well. In fact, I’m writing this article on the server laptop while running and it’s still at zero closed sockets and the system is very responsive. I could probably fire up a simple game and continue.

So we have achieved a pretty cool proof-of-concept scenario here. This is partly due to the stable Ethernet connection but of course also depend a lot on the server software. This feat could not be achieved with any other Node.js software stack — none of them are lightweight and performant enough to fit and maintain this many WebSockets on a laptop like this. You’ll just end up swapping until the system gets unresponsive and stop getting pings like seen here:

![Not going very well if we use another server software stack, here “websockets/ws” crash and burn trying](https://cdn-images-1.medium.com/max/3840/1*wXez3KLeKPCEhodP5UvcGQ.png)

With uWebSockets.js we could probably pull off a few hundreds of thousand more WebSockets on this laptop, but going beyond one million often times requires recompiling the Linux kernel with different limits, and that’s where we draw the line here.

We are not going to go in to low level embedded C development here and I think that’s a sane decision. Just start a new instance, a new laptop that is, and continue scaling your problem that way.

If you’re interested in this software stack and have I/O scalability problems or want to avoid falling in the many common pitfalls, make sure to get in contact and we can talk about things, company to company.

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
