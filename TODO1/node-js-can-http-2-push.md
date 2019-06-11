> * 原文地址：[Node.js can HTTP/2 push!](https://medium.com/the-node-js-collection/node-js-can-http-2-push-b491894e1bb1)
> * 原文作者：[Node.js Foundation](https://medium.com/@nodejs?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/node-js-can-http-2-push.md](https://github.com/xitu/gold-miner/blob/master/TODO1/node-js-can-http-2-push.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：[Starriers](https://github.com/Starriers)、[FateZeros](https://github.com/FateZeros)

# Node.js 能进行 HTTP/2 推送啦！

本文由来自 [@nearForm](https://twitter.com/nearForm) 的首席架构师、Node.js 技术指导委员会成员 [Matteo Collina](https://twitter.com/matteocollina) 以及谷歌软件工程师 [Jinwoo Lee](https://github.com/jinwoo) 共同撰写。

自从 [2017 年 7 月](https://medium.com/the-node-js-collection/say-hello-to-http-2-for-node-js-core-261ba493846e) Node.js 中引入 HTTP/2 以来，该实践经历了好几轮的改进。现在我们基本已经准备好去掉“实验性”标志。当然最好使用 Node.js 版本 9 来尝试 HTTP/2 支持，因为这个版本有着最新的修复和改进的内容。

最简单的入门方法是使用新版 http2 核心模块部分提供的的[兼容层](https://zh.wikipedia.org/wiki/%E5%85%BC%E5%AE%B9%E5%B1%82)：

```js
const http2 = require('http2');
const options = {
 key: getKeySomehow(),
 cert: getCertSomehow()
};

// 必须使用 https
// 不然浏览器无法连接
const server = http2.createSecureServer(options, (req, res) => {
 res.end('Hello World!');
});
server.listen(3000);
```
兼容层提供了和 `require('http')` 相同的高级 API（具有请求和响应对象相同的请求侦听器），这样就可以平滑的迁移到 HTTP/2。

兼容层的也为 web 框架作者提供了一个简单的升级途径，到目前为止，[Restify](https://www.npmjs.com/package/restify) 和[Fastify](https://www.npmjs.com/package/fastify) 都基于 Node.js HTTP/2 兼容层实现了对 HTTP/2 的支持。

[Fastify](https://www.npmjs.com/package/fastify) 是一个[新的 web 框架](https://thenewstack.io/introducing-fastify-speedy-node-js-web-framework/)，它专注于性能而不牺牲开发者的生产力，也不抛弃最近[升级到 1.0.0 版本](https://medium.com/@fastifyjs/fastify-goes-lts-with-1-0-0-911112c64752)的丰富的插件生态系统。

在 fastify 中使用 HTTP/2 非常简单：

```js
const Fastify = require('fastify');

// 必须使用 https
// 不然浏览器无法连接
const fastify = Fastify({
 http2: true,         // 译者注：原文作者这里少了逗号
 https: {
   key: getKeySomehow(),
   cert: getCertSomehow()
 }
});

fastify.get('/fastify', async (request, reply) => {
 return 'Hello World!';
});

server.listen(3000);
```
尽管能在 HTTP/1.1 和 HTTP/2 上运行相同的应用代码对于协议的选择非常重要，但单独的兼容层并没有提供 HTTP/2 支持的一些更强大的功能。http2 核心模块可以通过”流“侦听器来实现对新的核心 API（[Http2Stream](https://nodejs.org/api/http2.html#http2_class_http2stream)）来使用这些额外的功能：

```js
const http2 = require('http2');
const options = {
 key: getKeySomehow(),
 cert: getCertSomehow()
};

// 必须使用 https
// 不然浏览器无法连接
const server = http2.createSecureServer(options);
server.on('stream', (stream, headers) => {
 // 流是双工的
 // headers 是一个包含请求头的对象

 // 响应将把 headers 发到客户端
 // meta headers 用冒号（:）开头
 stream.respond({ ':status': 200 });

 // 这是 stream.respondWithFile()
 // 和 stream.pushStream()

 stream.end('Hello World!');
});

server.listen(3000);
```

在 Fastify 中, 可以通过 request.raw.stream API 访问 Http2Stream 如下所示：

```js
fastify.get('/fastify', async (request, reply) => {
 request.raw.stream.pushStream({
  ':path': '/a/resource'
 }, function (err, stream) {
  if (err) {
    request.log.warn(err);
    return
  }
  stream.respond({ ':status': 200 });
  stream.end('content');
 });

 return 'Hello World!';
});
```

### HTTP/2 推送 —— 机遇与挑战

HTTP/2 在 HTTP/1 的基础上对性能进行了相当大的提升，[**服务端推送**](http://httpwg.org/specs/rfc7540.html#PushResources)是其一大成果。

典型的（或者说是简化的）HTTP 请求和响应的流程应该像是这样（下面屏幕截图是和 Hack News 的连接）：

![和黑客新闻的连接](https://cdn-images-1.medium.com/max/800/1*YvOWVbP5yd5nmJ55nKuKRA.png)

1. 浏览器请求 HTML 文档。
2. 服务器处理请求并生成以及发回 HTML 文档。
3. 浏览器收到响应并对 HTML 文档进行解析。
4. 浏览器会为 HTML 文档渲染过程中需要的更多资源，比如样式表、图像、 JavaScript 文件等发送更多请求（来获取这些资源）。
5. 服务器响应对每个资源的请求。
6. 浏览器使用 HTML 文档和相关的资源来渲染出页面。

这意味着渲染一个 HTML 文档通常会需要多次请求和响应，因为浏览器需要额外与其关联的资源来完成对文档的正确渲染。如果这些相关的资源能在不需要浏览器请求的情况下随原始 HTML 文档一起发送给浏览器，那就太棒了。这也正是 HTTP/2 服务端推送的目的。

在 HTTP/2 中，服务器可以主动将它认为浏览器稍候会请求的额外资源和原来的请求响应一起**推送**。如果稍后浏览器真的需要这些额外资源，它只是会使用已经推送的资源，而不去发送额外的请求。
例如，假设服务器正在发送这个 /index.html 文件

```html
<!DOCTYPE html>
<html>
<head>
  <title>Awesome Unicorn!</title>
  <link rel="stylesheet" type="text/css" href="/static/awesome.css">
</head>
<body>
  This is an awesome Unicorn! <img src="/static/unicorn.png">
</body>
</html>
```

服务器将通过发回这个文件来响应请求。但它知道 /index.html 需要 /static/awesome.css 和 /static/unicorn.png 才能正确渲染。因此，服务器将这些文件和 /index.html 一起推送

```js
for (const asset of ['/static/awesome.css', '/static/unicorn.png']) {
  // stream 是 ServerHttp2Stream。
  stream.pushStream({':path': asset}, (err, pushStream) => {
    if (err) throw err;
    pushStream.respondWithFile(asset);
  });
}
```

在客户端，一但浏览器解析 /index.html，它会指出需要  /static/awesome.css 和 /static/unicorn.png，但是浏览器得知他们已经被推动并存储到了缓存中！所有他并不需要发送两个额外的请求，而是使用已经推送的资源。

这听起来蛮不错。但是有一些挑战（难点）。首先，服务器要想知道为原始请求推送哪些附加资源并不是那么容易。虽然我们可以把这个决定权放到应用程序层，但是让开发人员做出决定也同样不简单。一种方法是手动解析 HTML，找出其所需要的资源列表。但是随着应用程序的迭代和 HTML 文件的更新，维护该列表的工作将非常繁琐而且容易出错。

另一个挑战来自浏览器内部缓存先前检索到的资源。使用上面的例子，如果浏览器昨天加载了 /index.html，它也会加载 /static/unicorn.png，并且该文件通常会缓存在浏览器中。当浏览器加载 /index.html，然后尝试加载 /static/unicorn.png 时，它知道后者已经被缓存，并且只会使用它而不是去再次请求。这种情况下，如果服务器推送 /static/unicorn.png 就会浪费带宽。所以服务器应该有一些方法来判断资源是否已经缓存到了浏览器中。

还会有其他类型的挑战，以及[针对 HTTP/2 推送文档的经验法则](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit?usp=sharing)等这些。

### HTTP/2 自动推送

为了方便 Node.js 开发者支持服务端推送功能，Google 发布了一个 npm 包来实现自动化：[h2-auto-push](https://www.npmjs.com/package/h2-auto-push)。其设计目的是处理上面和 [针对 HTTP/2 推送文档的经验法则](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit?usp=sharing) 中提到的诸多挑战。

它会监视来自浏览器的请求的模式，并且确定与最初请求资源相关联的附加资源。之后如果请求原始资源，相关的资源会自动推送到浏览器。它还将估计浏览器是否可能已经缓存了某个资源，如果确定了就会跳过推送。

h2-auto-push 被设计为供各种 web 框架使用的中间件。作为一个静态文件服务中间件，使用这个 npm 包开发一个自动推送中间件非常容易。比如说请参阅 [fastify-auto-push](https://www.npmjs.com/package/fastify-auto-push)。这是一个支持 HTTP/2 自动推送并使用 [h2-auto-push](https://www.npmjs.com/package/fastify-auto-push) 包的 [fastify](https://www.fastify.io/) 插件。

在应用程序中使用这个中间件也非常容易

```js
const fastify = require('fastify');
const fastifyAutoPush = require('fastify-auto-push');
const fs = require('fs');
const path = require('path');
const {promisify} = require('util');

const fsReadFile = promisify(fs.readFile);

const STATIC_DIR = path.join(__dirname, 'static');
const CERTS_DIR = path.join(__dirname, 'certs');
const PORT = 8080;

async function createServerOptions() {
  const readCertFile = (filename) => {
    return fsReadFile(path.join(CERTS_DIR, filename));
  };
  const [key, cert] = await Promise.all(
      [readCertFile('server.key'), readCertFile('server.crt')]);
  return {key, cert};
}

async function main() {
  const {key, cert} = await createServerOptions();
  // 浏览器只支持 https 使用 HTTP/2。
  const app = fastify({https: {key, cert}, http2: true});

  // 新建并注册自动推送插件
  // 它应该注册在中间件链的一开始。
  app.register(fastifyAutoPush.staticServe, {root: STATIC_DIR});

  await app.listen(PORT);
  console.log(`Listening on port ${PORT}`);
}

main().catch((err) => {
  console.error(err);
});
```

很简单，是吧？

我们的测试表明，h2-auto-push 比 HTTP/2 的性能提高了 12%，比 HTTP/1 提高了大概 135%。我们希望本文能让您更好地理解 HTTP2 以及其可以为您应用带来的好处，包括 HTTP2 推送。

特别感谢 nearForm 的 [James Snel](https://twitter.com/jasnell)l 和 [David Mark Clements](https://twitter.com/davidmarkclem) 以及 Google 的 [Ali Sheikh](https://twitter.com/ofrobots) 和 [Kelvin Jin](https://github.com/kjin) 能帮忙编辑这篇博文。非常感谢 Google 的 [Matt Loring](https://github.com/matthewloring) 在自动推送方面的最初的努力。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
