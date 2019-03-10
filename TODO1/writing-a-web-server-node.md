> * 原文地址：[Node.js Fundamentals: Web Server Without Dependencies](https://blog.bloomca.me/2018/12/22/writing-a-web-server-node.html)
> * 原文作者：[Seva Zaikov](https://blog.bloomca.me)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-web-server-node.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-web-server-node.md)
> * 译者：
> * 校对者：

# Node.js Fundamentals: Web Server Without Dependencies

Node.js is a pretty popular choice to build web servers, and has plenty of mature web frameworks, such as [express](https://expressjs.com/), [koa](https://koajs.com/), [hapijs](https://hapijs.com/). In this tutorial, though, we’ll build a working server without any dependencies, using only core Node’s [http](https://nodejs.org/api/http.html) package, exploring all important details one by one. While this is not something you see every day, it can help to understand all these frameworks better – not only existing libraries use this package under the hood, but also often expose raw objects, and you might need to use them for some very specific tasks.

## Table of Contents

*   [Hello, World](#hello-world)
*   [Response in Details](#response-in-details)
*   [HTTP Information](#http-information)
*   [HTTP Headers](#http-headers)
*   [HTTP Status Codes](#http-status-codes)
*   [Routing](#routing)
*   [HTTP Methods](#http-methods)
*   [Cookies](#cookies)
*   [Query Parameters](#query-parameters)
*   [Body Content](#body-content)
*   [Conclusion](#conclusion)

## Hello, world

First, let’s start with the simplest thing possible – returning the famous “hello, world” response. In order to create a server in Node.js, we need to use [http](https://nodejs.org/api/http.html) built-in module, specifically [createServer](https://nodejs.org/api/http.html#http_http_createserver_options_requestlistener) function.

```
const { createServer } = require("http");

// it is a good practice to always allow to
// run on a different port
const PORT = process.env.PORT || 8080;

const server = createServer();

server.on("request", (request, response) => {
  response.end("Hello, world!");
});

server.listen(PORT, () => {
  console.log(`starting server at port ${PORT}`);
});
```

Let’s list everything we did in this short example:

1.  Created a new server instance calling `createServer` function
2.  Added an event listener on `request` event to our server
3.  Ran our server using port specified in environment variables with fallback on _8080_

Our created server is an instance of [http.Server](https://nodejs.org/api/http.html#http_class_http_server) class, which inherits from [net.Server](https://nodejs.org/api/net.html#net_class_net_server), which inherits from [EventEmitter](https://nodejs.org/api/events.html#events_class_eventemitter). There are several events we can listen for, but the most important event for us is [request](https://nodejs.org/api/http.html#http_event_request), and it is so common that you can provide its listener when creating a server:

```
const { createServer } = require("http");

// this is equivalent to `server.on('request', fn);`
createServer((request, response) => {
  response.end("Hello, world!");
}).listen(8080);
```

The last part, is starting our server. We start it by calling [server.listen](https://nodejs.org/api/http.html#http_server_listen) method, and you can specify port and what to execute after it started. One thing to note – server does not start to work immediately, it has to bind a port first for incoming requests, however, on practice it is not very important, since it is almost instant; you still can listen for this specific event separately using [listening](https://nodejs.org/api/net.html#net_event_listening) event.

## Response in Details

Now, after we learned how to instantiate a new server, let’s look how to actually reply to a user’s request. In our single handler we reply with canonic [Hello, world!](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program) response, using [response.end](https://nodejs.org/api/http.html#http_response_end_data_encoding_callback) method. You can see that the signature is very similar to writable stream method [writable.end](https://nodejs.org/api/stream.html#stream_writable_end_chunk_encoding_callback), and it is because both request and response objects are [streams](/2018/06/21/nodejs-guide-for-frontend-developers.html#streams), and logically request is only readable stream, while response is only writable stream. Why do they have to be streams, though? Why can’t we always send the whole reply?

The answer is that we don’t have to have everything before replying. Imagine a situation, when we read a file from a file system and it is too big – so we open a filestream using [fs.createReadStream](https://nodejs.org/api/fs.html#fs_fs_createreadstream_path_options), and we can immediately write to response. Moreover, we can just pipe!

Now, because it is a stream, we can do the following:

```
const { createServer } = require("http");

createServer((request, response) => {
  response.write("Hello");
  response.write(", ");
  response.write("World!");
  response.end();
}).listen(8080);
```

So we can write in our stream several times directly. Be careful doing it in any form of loop, since you have to handle backpressuring by yourself, and prefer to pipe streams directly. Also, please note `response.end()` at the end. This is mandatory, and without this call Node will keep this connection open, creating both a memory leak and a waiting client on the other side.

In the end, let’s demonstrate how stream piping works for response object and other streams. To do that, we’ll read the source file using [__filename](/2018/06/21/nodejs-guide-for-frontend-developers.html#module-system) variable:

```
const { createReadStream } = require("fs");
const { createServer } = require("http");

createServer((request, response) => {
  createReadStream(__filename).pipe(response);
}).listen(8080);
```

We don’t have to call `res.end` manually, since after original stream ends, it automatically ends a piped stream as well.

## HTTP Information

Our server implements [HTTP protocol](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol), which is a based-text set of rules which allows client to request specific information in their preferred format, and allows servers to reply with data and additional information – which format, connection status, cache information, etc.

Let’s look at a typical request to request a web page:

```
GET / HTTP/1.1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko)
Host: blog.bloomca.me
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive
```

This is what our browser sends when you want to request a page, except that it sends more headers, passes cookies (which is just a header), and other information. What is important for us, is to understand that every request has method, path (route), and list of headers, which are just key-value pairs (if you wonder about cookies, they are just a single header with special meaning). HTTP is a text protocol, and as you can see, you can read it by yourself. While it is just a set of rules, browsers and servers implementing this protocol try to follow the specification, and that’s how the whole internet. Not all rules are respected, but the main ones – HTTP verb, route, cookies are reliable enough, and you should always strive for predictable behaviour.

## HTTP Headers

We can access all headers which client sent in request, via [request.headers](https://nodejs.org/api/http.html#http_message_headers) property. For example to read which language client prefers, we can do the following:

```
const { createServer } = require("http");

createServer((request, response) => {
  // all headers are lower-cased in this object
  const languages = request.headers["accept-language"];

  response.end(languages);
}).listen(8080);
```

> In my case I got “en-US,en;q=0.9,ru;q=0.8,de;q=0.7”, which means that I prefer English first, Russian second, and German the last. Typically browser just uses your OS language, but it can be overriden and not the best thing to depend on, since the user can’t control it directly (and different browsers can have different opinions how they should form this line).

To write a header, you have to understand that HTTP is a protocol where metadata comes first, and then, after a separator (2 newline characters) actual body begins. It means that as soon as you started to send your content, you can’t change your headers! Doing so will throw an error in Node and actually terminate your program.

There are two methods for setting headers: [response.setHeader](https://nodejs.org/api/http.html#http_response_setheader_name_value) and [response.writeHead](https://nodejs.org/api/http.html#http_response_writehead_statuscode_statusmessage_headers). The difference is that the first one is more specific, and if both were used, all set headers will be merged and new headers in _writeHead_ will have higher priority. _writeHead_ works the same way as _write_, so you can’t change headers after.

```
const { createServer } = require("http");

createServer((req, res) => {
  res.setHeader("content-type", "application/json");

  // we have to send buffers or strings, we can't just pass an object
  res.end(JSON.stringify({ a: 2 }));
}).listen(8080);
```

## HTTP Status Codes

HTTP defines codes which should come with every response, with a quite [extensive list](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes). Again, they are not followed religiously, and expect to see some minor (or not so) differences between different servers behaviour.

Let’s list the most important status codes:

2xx – success codes:

*   200: the most common one, the default one in Node.js, “OK”.
*   201: new entity created
*   204: success, but nothing to return. For example, after removing an entity

3xx – redirect codes

*   301: Moved permanently, just new URL
*   302: Found, but needs another URL. Can be used after successfull POST to redirect to the newly created entity’s page

> Be careful about 301/302. Browsers like to remember 301, so if you accidentally mark some URL as moved with 301 status code, browsers might continue to do so after new response (they won’t even check it)

4xx - client errors

*   400: Bad request, like wrong passed parameters, or some missed parameter
*   401: Unauthorized. User is not authorized, and therefore has no access. Might be mixed with 403 at some servers.
*   403: Forbidden. User is usually authenticated, but not authorized for this action. Again, might be mixed with 401 at some servers.
*   404: Not Found, no specific page/data for provided URL

5xx – server errors

*   500: Internal server error, like database connection error

These codes are the most common ones, and should be enough to mark your responses with correct status codes. In Node.js, we can either set [response.statusCode](https://nodejs.org/api/http.html#http_response_statuscode) or use [response.writeHead](https://nodejs.org/api/http.html#http_response_writehead_statuscode_statusmessage_headers) method. Let’s use this time _writeHead_ method, also setting a custom HTTP message:

```
const { createServer } = require("http");

createServer((req, res) => {
  // indicate that there is no content
  res.writeHead(204, "My Custom Message");
  res.end();
}).listen(8080);
```

If you try to open this code in your browser and explore HTML request in “Network” tab, you will see “Status Code: 204 My Custom Message”.

## Routing

In Node.js server, all requests are handled by a single request handler. We can test it by running any of our webservers, and request different URLs, like [http://localhost:8080/home](http://localhost:8080/home) and [http://localhost:8080/about](http://localhost:8080/about). You will see that it returns the same response. However, we have a property [request.url](https://nodejs.org/api/http.html#http_message_url) in a request object, which we can use to build a simple routing function:

```
const { createServer } = require("http");

createServer((req, res) => {
  switch (req.url) {
    case "/":
      res.end("You are on the main page!");
      break;
    case "/about":
      res.end("You are on about page!");
      break;
    default:
      res.statusCode = 404;
      res.end("Page not found!");
  }
}).listen(8080);
```

There are a lot of caveats (try to add a trailing slash to `/about/` page), but you get an idea. In all frameworks, under the hood, there is a main handler, which routes all requests into registered handlers.

## HTTP Methods

You are probably familiar with [HTTP methods/verbs](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods), like _GET_ and _POST_. They are part of HTTP protocol itself, and they are pretty self-explanatory. However, there are a lot of very subtle details, in which I don’t want to dive, and for the sake of brevity, I’ll mention that _GET_ is used to retrieve data, and _POST_ is used to create new entities. Nothing prevents you from using them for something else, but the standard and conventions suggest to not to.

That being said, in Node.js servers we have a [request.method](https://nodejs.org/api/http.html#http_message_method) property, which we can use for our internal logic. Again, there is nothing from the Node.js itself for us to abstract handlers for different methods, we have to build all of it by ourselves:

```
const { createServer } = require("http");

createServer((req, res) => {
  if (req.method === "GET") {
    return res.end("List of data");
  } else if (req.method === "POST") {
    // create new entity
    return res.end("success");
  } else {
    res.statusCode(400);
    return res.end("Unsupported method");
  }
}).listen(8080);
```

## Cookies

Cookies deserve it’s own article, so feel free to read more about them on [MDN guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies).

In two words, cookies are used to persist some data across requests, because HTTP is a stateless protocol, so technically, without cookies (or local storage) we’d have to login before every action which requires authentication. We persist cookies on the client (usually in the browser), so browsers send us a header named _Cookie_ with all cookies, and we can reply with a `Set-Cookie` header, telling the client which cookies to set (e.g. access token); after saving it, client will send it back with every subsequent request.

Let’s run the following code:

```
const { createServer } = require("http");

createServer((req, res) => {
  res.setHeader(
    "Set-Cookie",
    ["myCookie=myValue"],
    ["mySecondCookie=mySecondValue"]
  );
  res.end(`Your cookies are: ${req.headers.cookie}`);
}).listen(8080);
```

The first time you refresh your browser, you might see some older cookies, but you won’t see _myCookie_ or _mySecondCookie_. However, if your refresh your browser, you will see both of these values! The reason for that is that the client sets these values in cookies _after_ the response, the same response which renders our page. So we’ll receive these values from the client only on the _next_ request.

Now, what if we want to use cookie values in our code? Cookie is just a header in HTTP, so it is a string with it’s own rules – cookies are written using `key=value` schema, with parameters, and separated by `;` sign. You can write your own parser (like in [this SO answer](https://stackoverflow.com/questions/3393854/get-and-set-a-single-cookie-with-node-js-http-server/3409200#3409200)), but I’d recommend to just use any external library compatible with your framework/library of choice.

Also, please note that you can’t delete cookies, since it is owned by the client, but you can [invalidate](https://stackoverflow.com/questions/5285940/correct-way-to-delete-cookies-server-side) it by setting it to an empty value and put expiration date in the past.

## Query parameters

It is common to allow parameters for a specific handler: for example, if we want to show all pictures, we can allow to specify a page, and usually it is done via query parameters. They are simply added to the URL, separated from the route by `?` sign: `http://localhost:8080/pictures?page=2`. As you can see, we requested the second page of pictures. Alternatively, we can just embed it into the URL itself: `http://localhost:8080/pictures/page/2`, but the problem here is that if there is more than 1 parameter, URLs will quickly become confusing. Query parameters are not positioned, so we can add as many as we want, as well as remove/add new in the future.

To get it in our server, we use [request.url](https://nodejs.org/api/http.html#http_message_url) property, which we already used in the [routing](#routing) section. Now, though, we need to separate our URL part from query parameters, and while we can do it manually, it is unnecessary, since it is already implemented in Node.js:

```
const { createServer } = require("http");

createServer((req, res) => {
  const { query } = require("url").parse(req.url, true);
  if (query.name) {
    res.end(`You requested parameter name with value ${query.name}`);
  } else {
    res.end("Hello!");
  }
}).listen(8080);
```

Now, if you request any page with query parameter name, you’ll see it in the response, e.g. querying [http://localhost:8080/about?name=Seva](http://localhost:8080/about?name=Seva) will return us a string with our name:

```
1You requested parameter name with value Seva
``` 

## Body Content

The last thing we’ll look at is body content. We saw that you can get all information (route and query parameters) from the URL itself, but how can we get actual data sent from the client? You don’t have direct access to it, but it is a reason why request object is also a stream, we can get the passed data reading from this stream. Let’s write a simple server which will expect a JSON object on a POST request, and return _400_ status code if it is not a valid JSON:

```
const { createServer } = require("http");

createServer((req, res) => {
  if (req.method === "POST") {
    let data = "";
    req.on("data", chunk => {
      data += chunk;
    });

    req.on("end", () => {
      try {
        const requestData = JSON.parse(data);
        requestData.ourMessage = "success";
        res.setHeader("Content-Type", "application/json");
        res.end(JSON.stringify(requestData));
      } catch (e) {
        res.statusCode = 400;
        res.end("Invalid JSON");
      }
    });
  } else {
    res.statusCode = 400;
    res.end("Unsupported method, please POST a JSON object");
  }
}).listen(8080);
```

The easiest way to test it is to use [curl](https://curl.haxx.se/). At first, let query with a _GET_ method:

```
> curl http://localhost:8080
Unsupported method, please POST a JSON object
```

Now, let’s make a _POST request with random string as our data:

```
> curl -X POST -d "some random string" http://localhost:8080
Invalid JSON
```

Finally, let’s make a correct response and see at as a result:

```
> curl -X POST -d '{"property": true}' http://localhost:8080
{"property":true,"ourMessage":"success"}
```

## Conclusion

As you can see, there is a lot of tedious work in handling every request using only built-in modules – like remembering to close the response stream every time, or setting a `Content-Type: application/json` header with stringifying JSON every time you send an object, or parsing query parameters, or writing your own routing system… All of this was already done, just remember that under the hood it uses these core methods, and don’t be afraid to look inside how it actually works.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
