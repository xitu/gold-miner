> * 原文地址：[Will Node.js forever be the sluggish Golang?](https://levelup.gitconnected.com/will-node-js-forever-be-the-sluggish-golang-f632130e5c7a)
> * 原文作者：[Alex Hultman](https://medium.com/@alexhultman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/will-node-js-forever-be-the-sluggish-golang.md](https://github.com/xitu/gold-miner/blob/master/TODO1/will-node-js-forever-be-the-sluggish-golang.md)
> * 译者：
> * 校对者：

# Will Node.js forever be the sluggish Golang?

### Presenting new Node.js addons which drastically scramble the conditions

It seems you cannot go a week without hearing about the next, allegedly faster, so called “web framework” for Node.js. Yes we all know Express is slow, but can yet another “web framework” really **improve** I/O performance? Beyond evading the overhead of Express, no, it cannot. To reach further you need to dig deep and redesign, not just slap a new layer on top.

Express is one of the oldest, so called “web framework” for Node.js. It builds on the out-of-box features Node.js provide, adding a nice App-centered programming interface to manage URL routes, parameters, methods and the like.

It is productive and elegant, sure, but lacks in performance. Emerging are projects like Fastify, and hundreds alike. They all aim to provide what Express does, at a lower performance penalty. But that’s exactly what they are; a **penalty**. Not an improvement. They’re still strictly limited to what Node.js can provide, and that’s not much as compared to the competition:

![](https://cdn-images-1.medium.com/max/2000/1*1MrkEKoWL7MnDYuY3dk8aA.png)

No so called “web framework” for Node.js, whether Fastify or not, can surpass the red line. This is a pretty low **upper limit** as compared to trending alternatives like Golang.

Luckily Node.js supports C++ addons, Google V8 bindings that link JavaScript to C++ and allows your JavaScript to invoke any behavior, even behavior that’s not provided by Node.js itself.

This makes it possible to extend and redefine what’s possible to do with JavaScript. It opens up for JavaScript that performs to the full extent made possible by Google V8, not limited to what the Node.js “core programmers” have decided is good enough.

### Releasing the new µWebSockets.js

I’m releasing brand new code, µWebSockets.js, available on GitHub today:
[https://github.com/uNetworking/uWebSockets.js](https://github.com/uNetworking/uWebSockets.js)

* Install for Node.js using NPM (although hosted on GitHub):
npm install uNetworking/uWebSockets.js#v15.0.0 , see NPM install docs.

* No compiler needed; Linux, macOS and Windows. We start at version 15.0.0 and increment according to SemVer.

It’s an alternative web server for JavaScript backends, written in ~6 thousand lines of C and C++, surpassing in performance the best of Golang by a large margin. Bitfinex.com already ported both of their trading APIs (REST & WebSocket) and are currently gradually putting it in production.
> Paolo Ardoino from Bitfinex wanted to interject that “it’s a damn pretty cool project”.
> # This work is made possible solely thanks to sponsors; BitMEX, Bitfinex and Coinbase have made this work possible. Thanks to them, we now have a new release!

### Please explain, what’s this all about?

This is a new project, new code licensed Apache 2.0, successor to what’s known as “uws”. It’s an entire stack, from OS kernel to Google V8, a complete bypass that brings stable, secure, standards-compliant, fast and lightweight I/O for Node.js:

![](https://cdn-images-1.medium.com/max/2462/1*s3YLN_-95DbHflLKOOahoQ.png)

In this layered software design, where every layer depend only on the previous one, it becomes very easy to track and fix issues and/or extend with new support.

µSockets itself even has three sub layers, going from **eventing** to **networking** to **crypto**, each sub layer only aware of the previous one. This makes it possible to swap out parts, fix bugs, add alternative implementations all without changing any high level code.

Feeling tired of OpenSSL? Fine, swap it out by replacing ssl.c and its 600 lines of code. No other layer even knows what SSL is, so bugs are easy to locate.

![Internal sub layers of µSockets](https://cdn-images-1.medium.com/max/2000/0*KYceR1fpeHeUZE2E.png)

This differs greatly from how Node.js is implemented, with its “all-and-everything-in-one” design. In one source file of Node.js you can find libuv calls, syscalls, OpenSSL calls, V8 calls. It’s all mixed up in a big mess with no sense of isolated purpose. This makes it hard to make any real change.

### Coding for µWebSockets.js, in a nutshell

Following is an oversimplification, many concepts left out for brevity, but should give you an idea of what µWebSockets.js is all about:

![](https://cdn-images-1.medium.com/max/2000/1*I6jsm23tYBFIJGxZKB07bg.png)

It is possible to outperform, in some regards, Golang’s Gorilla WebSockets on an SSL vs. non-SSL basis. That is, your JS code on SSL can message faster than Golang can without SSL (in some regards). I think that’s pretty cool.

### Fast pub/sub support

Socket.IO is in many ways the “real-time” equivalent of Express. Both are old, elegant and popular, but also **very** undefinedslow:

![](https://cdn-images-1.medium.com/max/2098/1*dY6cHErkXrqFiyJS7IrR1g.png)

Most of what Socket.IO helps you with boils down to pub/sub, the feature to emit messages to a room of multiple recipients, and to receive likewise.
> Fallbacks are completely pointless today as every browser supports, and has supported for ages, WebSockets. SSL traffic cannot be interpreted by corporate proxies, and will pass through just like any Http traffic would, so WebSockets over SSL is definitely not going to be blocked. You can still have fallbacks, but they are pointless and incur unnecessary complexity.

One goal with µWebSockets.js is to provide features similar to those found in Socket.IO to make it somewhat simple to swap away completely, without any wrapper on top. This while not enforcing any particular non-standard protocol.

Many companies, most of them, struggle with some kind of pub/sub problem when it comes to WebSockets. Sadly, efficient pub/sub did not make the deadline for this release, but is coming shortly. Very high priority. It’s going to be really fast (benchmarks already put it faster than Redis). Keep an eye out!

### What happens now?

Polishing, adding features and correcting mistakes. There’s going to be a period of introduction where things will maybe not fit in completely from the start. Keep in mind, it’s a large project consisting of many thousands of lines of C++ and C in three different repositories:

* [https://github.com/uNetworking/uWebSockets.js](https://github.com/uNetworking/uWebSockets.js) (JavaScript wrapper)

* [https://github.com/uNetworking/uWebSockets](https://github.com/uNetworking/uWebSockets) (C++ web server)

* [https://github.com/uNetworking/uSockets](https://github.com/uNetworking/uSockets) (C foundation library)

This project is used by companies with huge stress on I/O. Stability and security is (naturally & obviously) of **highest** undefinedpriority to the project. Make sure to report stability issues in early point-releases now that this code is a major and big release with tons of changes.

If you as a company think this project makes sense, and is of economic interest, make sure to get in contact. I do consulting and the like, in all kinds of ways. Contact: [https://github.com/alexhultman](https://github.com/alexhultman)

Thanks!

![](https://cdn-images-1.medium.com/max/2800/1*E6CoI_MRyZ1JInNPsBSHtA.png)

***
[**Learn Node.js - Best Node.js Tutorials (2019) | gitconnected**
**The top 32 Node.js tutorials - learn Node.js for free. Courses are submitted and voted on by developers, enabling you…**gitconnected.com](https://gitconnected.com/learn/node-js)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
