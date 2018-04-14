> * 原文地址：[Node.js can HTTP/2 push!](https://medium.com/the-node-js-collection/node-js-can-http-2-push-b491894e1bb1)
> * 原文作者：[Node.js Foundation](https://medium.com/@nodejs?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/node-js-can-http-2-push.md](https://github.com/xitu/gold-miner/blob/master/TODO1/node-js-can-http-2-push.md)
> * 译者：
> * 校对者：

# Node.js can HTTP/2 push!

This article was co-written by [Matteo Collina](https://twitter.com/matteocollina), a Technical Steering Committee member of Node.js and Principal Architect [@nearForm](https://twitter.com/nearForm), and [Jinwoo Lee](https://github.com/jinwoo), a Software Engineer at Google.

Since introducing HTTP/2 into Node.js 8 in [July of 2017](https://medium.com/the-node-js-collection/say-hello-to-http-2-for-node-js-core-261ba493846e), the implementation has undergone several rounds of improvements. Now we’re almost ready to lift the “experimental” flag. It’s best to try out HTTP/2 support with Node.js version 9, which has all the latest fixes and improvements.

The easiest way to get started is by using the compatibility layer provided as part of the new http2 core module:

```
const http2 = require('http2');
const options = {
 key: getKeySomehow(),
 cert: getCertSomehow()
};

// https is necessary otherwise browsers will not
// be able to connect
const server = http2.createSecureServer(options, (req, res) => {
 res.end('Hello World!');
});
server.listen(3000);
```

The compatibility layer provides the same high-level API (a request listener with the familiar request and response objects) that require(‘http’) provides, which allows for a smooth initial migration path to HTTP/2.

The compatibility layer also provides an easy upgrade path for web framework authors, so far both [Restify](https://www.npmjs.com/package/restify) and [Fastify](https://www.npmjs.com/package/fastify) already support HTTP/2 using the Node.js HTTP/2 compatibility layer.

[Fastify](https://www.npmjs.com/package/fastify) is a [new web framework](https://thenewstack.io/introducing-fastify-speedy-node-js-web-framework/) which focuses on performance without sacrificing developer productivity and a rich plugin ecosystem that recently [graduated to 1.0.0](https://medium.com/@fastifyjs/fastify-goes-lts-with-1-0-0-911112c64752).

Using HTTP/2 with fastify is straightforward:

```
const Fastify = require('fastify');

// https is necessary otherwise browsers will not
// be able to connect
const fastify = Fastify({
 http2: true
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

While being able to run the same application code on top of both HTTP/1.1 and HTTP/2 is important for protocol adoption, the compatibility layer alone does not expose some of the more powerful capabilities available with HTTP/2\. The core http2 module exposes these additional capabilities through a new core API ([Http2Stream](https://nodejs.org/api/http2.html#http2_class_http2stream)) which can be accessed via a “stream” listener:

```
const http2 = require('http2');
const options = {
 key: getKeySomehow(),
 cert: getCertSomehow()
};

// https is necessary otherwise browsers will not
// be able to connect
const server = http2.createSecureServer(options);
server.on('stream', (stream, headers) => {
 // stream is a Duplex
 // headers is an object containing the request headers

 // respond will send the headers to the client
 // meta headers starts with a colon (:)
 stream.respond({ ':status': 200 });

 // there is also stream.respondWithFile()
 // and stream.pushStream()

 stream.end('Hello World!');
});

server.listen(3000);
```

In Fastify, the Http2Stream can be accessed via the request.raw.stream API, like so:

```
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

### HTTP/2 Push — Opportunities and Challenges

HTTP/2 gives huge performance improvements over HTTP/1 in many ways, and [_server push_](http://httpwg.org/specs/rfc7540.html#PushResources) is one of its features for performance.

A typical (and simplified) HTTP request/response flow is like this (The screenshot below is for connecting to Hacker News):

![](https://cdn-images-1.medium.com/max/800/1*YvOWVbP5yd5nmJ55nKuKRA.png)

1.  The browser requests an HTML document.
2.  The server processes the request and generates/sends the HTML document.
3.  The browser receives the response and parses the HTML document.
4.  It identifies more resources that are needed to render the HTML document, such as stylesheets, images, JavaScript files, etc. It sends more requests for those resources.
5.  The server responds to each request with the corresponding resource.
6.  The browser renders the page using the HTML document and associated resources.

This means that there usually are multiple round-trips of requests/responses to render one HTML document because there are additional resources that are associated with it, and the browser needs them to render the document correctly. It would be great if all those associated resources could be sent to the browser together with the original HTML document without the browser requesting them. And that is what HTTP/2 server push is for.

In HTTP/2, the server can proactively _push_ additional resources together with the response to the original request that it thinks the browser will request later. Later, if the browser really needs them, it just uses the already-pushed resources instead of sending additional requests for them.

For example, let’s suppose this /index.html file is being served

```
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

The server will respond by sending that file. But it knows that /index.html needs /static/awesome.css and /static/unicorn.png for it to be rendered correctly. So the server pushes those files together with /index.html

```
for (const asset of ['/static/awesome.css', '/static/unicorn.png']) {
  // stream is a ServerHttp2Stream.
  stream.pushStream({':path': asset}, (err, pushStream) => {
    if (err) throw err;
    pushStream.respondWithFile(asset);
  });
}
```

On the client side, once the browser parses /index.html, it figures that /static/awesome.css and /static/unicorn.png are needed, but it also figures that they have already been pushed and stored in the browser cache! So it doesn’t have to send two additional requests but uses the already-pushed resources instead.

This sounds good so far. But there are some challenges. First, it is not simple for a server to know which additional resources can be pushed for an original request. We can move that decision up to the application layer and have the developer decide. But it is not simple either for a developer to figure that out. One way to do so is to manually parse the HTML and figure out a list of additional resources that are needed, but it is tedious and error-prone to maintain that list as the application changes and the HTML files are updated.

Another challenge comes from the fact that browsers internally cache resources that have been previously retrieved. Using the example files above, if the browser loaded /index.html yesterday, it would have also loaded /static/unicorn.png and the file is usually cached in the browser. When the browser loads /index.html and in turn tries to load /static/unicorn.png, it knows that the latter is already cached and just uses it instead of requesting it again. In this case, it’ll be a waste of the network bandwidth if the server pushes /static/unicorn.png. The server should have some way to tell whether a resource is already cached in the browser.

There are other kinds of challenges as well, and [_Rules of Thumb for HTTP/2 Push_](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit?usp=sharing) documents well those challenges.

### HTTP/2 Auto-Push

To make it easy for Node.js developers to support the server push feature, Google published an npm package for automating it: [h2-auto-push](https://www.npmjs.com/package/h2-auto-push). Its design goal is to deal with many challenges that are mentioned in the section above and in the [_Rules of Thumb for HTTP/2 Push_](https://docs.google.com/document/d/1K0NykTXBbbbTlv60t5MyJvXjqKGsCVNYHyLEXIxYMv0/edit?usp=sharing) document.

It monitors the patterns of requests coming from browsers and figures out what additional resources are associated with the originally requested resource. And later if that original resource is requested, the associated resources are automatically pushed to the browser. It also estimates whether the browser is likely to have a certain resource already cached, and skips pushing if it so determines.

h2-auto-push was designed to be used by middlewares for various web frameworks. The middlewares are assumed to be a static-file-serving middleware, and it is pretty easy to develop an auto-push middleware using this NPM package. For example, see [fastify-auto-push](https://www.npmjs.com/package/fastify-auto-push). It is a [fastify](https://www.fastify.io/) plugin for supporting HTTP/2 auto-push and uses the [h2-auto-push](https://www.npmjs.com/package/fastify-auto-push) package.

Using this middleware from an application is pretty easy too

```
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
  // Browsers support only https for HTTP/2.
  const app = fastify({https: {key, cert}, http2: true});

  // Create and register AutoPush plugin. It should be registered as the first
  // in the middleware chain.
  app.register(fastifyAutoPush.staticServe, {root: STATIC_DIR});

  await app.listen(PORT);
  console.log(`Listening on port ${PORT}`);
}

main().catch((err) => {
  console.error(err);
});
```

Pretty easy, huh?

Our performance test shows that h2-auto-push gives ~12% performance improvement over HTTP/2 without push and ~135% improvement over HTTP/1\. We hope that this article gives you a better understanding of HTTP2 and the benefits that it can bring to your application, including HTTP2 push.

A special thank you to [James Snel](https://twitter.com/jasnell)l and [David Mark Clements](https://twitter.com/davidmarkclem) of nearForm, and [Ali Sheikh](https://twitter.com/ofrobots) and [Kelvin Jin](https://github.com/kjin) of Google for helping edit this blog post. And a big thank you to [Matt Loring](https://github.com/matthewloring) of Google for his initial work on auto-push.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
