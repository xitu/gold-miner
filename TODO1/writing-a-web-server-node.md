> * 原文地址：[Node.js Fundamentals: Web Server Without Dependencies](https://blog.bloomca.me/2018/12/22/writing-a-web-server-node.html)
> * 原文作者：[Seva Zaikov](https://blog.bloomca.me)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-web-server-node.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-web-server-node.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[kasheemlew](https://github.com/kasheemlew)，[Endone](https://github.com/Endone)

# Node.js 基础知识：没有依赖关系的 Web 服务器

Node.js 是构建 web 应用服务端的一种非常流行的技术选择，并且有许多成熟的网络框架，比如 [express](https://expressjs.com/), [koa](https://koajs.com/), [hapijs](https://hapijs.com/)。尽管如此，在这篇教程中我们不用任何依赖，仅仅使用 Node 核心的 [http](https://nodejs.org/api/http.html) 包搭建服务端，并一点点地探索所有的重要细节。这不是你能经常看到的一种状况，它可以帮助你更好地理解上面提及的所有框架--现有的许多库不仅在底层使用这个包，而且经常会将原始对象暴露出来，使得你可以在某些特殊任务中应用他们。

## 目录表

  - [Hello, World](#hello-world)
  - [响应细节](#%E5%93%8D%E5%BA%94%E7%BB%86%E8%8A%82)
  - [HTTP 报文](#http-%E6%8A%A5%E6%96%87)
  - [HTTP 报文头](#http-headers-%E6%8A%A5%E6%96%87%E5%A4%B4)
  - [HTTP 状态码](#http-status-codes-%E7%8A%B6%E6%80%81%E7%A0%81)
  - [路由](#%E8%B7%AF%E7%94%B1)
  - [HTTP 方法](#http-%E6%96%B9%E6%B3%95)
  - [Cookies 缓存](#cookies-%E7%BC%93%E5%AD%98)
  - [查询参数](#%E6%9F%A5%E8%AF%A2%E5%8F%82%E6%95%B0)
  - [请求体内容](#%E8%AF%B7%E6%B1%82%E4%BD%93%E5%86%85%E5%AE%B9)
  - [结尾](#%E7%BB%93%E5%B0%BE)

## Hello, world

首先，让我们开始一个最简单的程序--返回那句经典的响应『hello,world』。为了用 Node.js 构建一个服务程序，我们需要使用 [http](https://nodejs.org/api/http.html) 内建模模块，尤其是 [createServer](https://nodejs.org/api/http.html#http_http_createserver_options_requestlistener) 函数。

```
const { createServer } = require("http");

// 这是一种好的实现
// 允许运行在不同的端口
const PORT = process.env.PORT || 8080;

const server = createServer();

server.on("request", (request, response) => {
  response.end("Hello, world!");
});

server.listen(PORT, () => {
  console.log(`starting server at port ${PORT}`);
});
```

让我们列出这个简短示例的所有内容：

1.  使用 createServer 函数创建一个服务对象实例。
2.  为我们的服务程序中 `request` 事件添加一个事件监听器
3.  在环境变量指定的端口运行我们的服务程序，缺省时使用 8080 端口。

我们创建的服务程序是 [http.Server](https://nodejs.org/api/http.html#http_class_http_server) 类的一个实例，继承自对象 [net.Server](https://nodejs.org/api/net.html#net_class_net_server)，而它又继承自类 [EventEmitter](https://nodejs.org/api/events.html#events_class_eventemitter)。有许多我们可以监听的事件，但最重要的事件是 [request](https://nodejs.org/api/http.html#http_event_request)，并且在创建服务时提供它的监听，常见的实现方式如下：

```
const { createServer } = require("http");

// 这样等同于 `server.on('request', fn);`
createServer((request, response) => {
  response.end("Hello, world!");
}).listen(8080);
```

最后一步是启动我们的服务。我通过调用 [server.listen](https://nodejs.org/api/http.html#http_server_listen) 方法来启动，并且你可以指定端口和启动后执行内容。有一点要注意的是：服务并不会立即开始，它接入来访的请求时必须先和一个端口绑定，然而在实践中这点并不是非常重要，因为这个过程几乎是瞬间完成。你也可以通过 [listening](https://nodejs.org/api/net.html#net_event_listening) 事件方法来单独监听这个特殊事件。

## 响应细节

现在，在我们学会了如何实例化一个新服务应用后，让我们看看如何实际回复用户的请求。在我们唯一的事件处理器中，我们使用 [response.end](https://nodejs.org/api/http.html#http_response_end_data_encoding_callback) 方法以常规经典响应 [Hello, world!](https://en.wikipedia.org/wiki/%22Hello,_World!%22_program) 来回复。你可以看出这个签名与可写流方法 [writable.end](https://nodejs.org/api/stream.html#stream_writable_end_chunk_encoding_callback) 非常相似，这是因为请求和响应对象都是流对象 [streams](/2018/06/21/nodejs-guide-for-frontend-developers.html#streams)，同时请求只是可读流，而且响应只是可写流。为什么它们必须是流对象呢？为什么我们不能发送整个回复？

答案是在回复前我们不是非得做完所有的事。想象这种情景，当我们从文件系统中读取一个文件时，而这个文件比较大。因此我们可以通过 [fs.createReadStream](https://nodejs.org/api/fs.html#fs_fs_createreadstream_path_options) 方法打开了一个文件流，这样我们就可以立即写入响应。此外我们还可以直接将输入通过管道连接到输出！

现在因为它是流对象，我们可以做下面的事：

```
const { createServer } = require("http");

createServer((request, response) => {
  response.write("Hello");
  response.write(", ");
  response.write("World!");
  response.end();
}).listen(8080);
```

因此我们可以直接多次写入我们流对象。在任何形式的循环中这么做时要小心，因为你必须自己处理背压问题，另外最好直接管道连接到流对象。同样的，请注意在结尾时使用 `response.end()` 方法。这是强制的，如果没有这个调用，Node 将保持此连接处于打开状态，造成内存泄漏和客户端处于等待状态。

最后，让我们演示一下流的管道方法是如何为响应对象和其他流起作用的。为了这么做，我们使用 [__filename](/2018/06/21/nodejs-guide-for-frontend-developers.html#module-system) 变量来读取源文件：

```
const { createReadStream } = require("fs");
const { createServer } = require("http");

createServer((request, response) => {
  createReadStream(__filename).pipe(response);
}).listen(8080);
```

我们不一定要手动调用 `res.end` 方法，因为在原始流结束时，它也会自动地关闭管道传输的流。

## HTTP 报文

我们的服务程序实现了 [HTTP 协议](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol)，它是一种文本集的规则，允许客户端以自己首选格式请求特定信息，也允许服务程序以数据和附加信息来回复，例如格式、连接状态、缓存信息等等。

让我们看一个对 web 页面的典型请求：

```
GET / HTTP/1.1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/537.36 (KHTML, like Gecko)
Host: blog.bloomca.me
Accept-Language: en-us
Accept-Encoding: gzip, deflate
Connection: Keep-Alive
```

这是当你请求页面时，我们浏览器发送的内容，除了上面这些它还发送更多的 headers，传输 cookies（也是一种 header），还有其他信息。对我们来说重要的是要理解：所有的请求有方法、路径（路由）以及 headers 列表，这些都是键值对（如果你想了解 cookies，它们只是一种具有特殊含义的 header）。HTTP 是一种文本协议，正如你所看到的，你自己可以读懂它。虽然它只是一组协议，实现此协议的浏览器和服务程序都试图遵守这个协议规定，这就是整个互联网的运转方式。并非所有规则都被遵守，但主要规则 - HTTP 操作、路由、cookie 都足够可靠，您应该始终追求可预测的行为。

## HTTP Headers 报文头

我可以通过 [request.headers](https://nodejs.org/api/http.html#http_message_headers) 属性来访问客户端发送的所有 header。例如为了识别客户端选择的语言类型，我们可以像下面这样做：

```
const { createServer } = require("http");

createServer((request, response) => {  
  // 这个对象中所有的 header 都是小写  
  const languages = request.headers["accept-language"];

  response.end(languages);  
}).listen(8080);
```

> 我个人对语言的选择，使用『en-US,en;q=0.9,ru;q=0.8,de;q=0.7』，也就是说我首选英语，其次俄语，最后是德语。一般情况下浏览器使用你的操作系统语言，但是它会被替换，不是最好的依赖，因为用户不能直接控制它（并且不同浏览器对这行代码有不同的选择）。

为了写一个 header，你需要理解 HTTP 是一种协议，这个协议规定首先是元数据，然后在一个分隔符（两个换行符）之后才是真正的报文体。这意味着一旦你开始发送内容，你就不能变更你的报文头！如果这么做会在 Node 中抛出错误以及实际会中止你的程序。

有两种设置 header 的方法： [response.setHeader](https://nodejs.org/api/http.html#http_response_setheader_name_value) 方法和 [response.writeHead](https://nodejs.org/api/http.html#http_response_writehead_statuscode_statusmessage_headers) 方法。 两者的区别是前者更特殊，并且如果两者都被使用的情况下，所有的 header 会被合并，且以 _writeHead_ 方式设置的 header 取值具有更高的优先级。_writeHead_ 和 _write_ 方法的作用相同，也就是说你不可以在后续修改 header。

```
const { createServer } = require("http");

createServer((req, res) => {
  res.setHeader("content-type", "application/json");

  // 我们需要发送 Buffer 或者 String 类型数据，我们不能直接传递一个对象  
  res.end(JSON.stringify({ a: 2 }));
}).listen(8080);
```

## HTTP Status Codes 状态码

HTTP 定义了每个响应都必须要有的状态码，[列表](https://en.wikipedia.org/wiki/List_of_HTTP_status_codes) 中定义了各个状态码的含义。同样，并非所有人都严格遵守这个列表

让我们列出最重要的状态码：

2xx – 成功码:

*   200：最常见的状态码，在 Node.js 中默认表示『OK』。
*   201：新实体被创建。
*   204：成功码，但是没有响应返回。例如，在移除一个实体后的状态码。

3xx – 重定向码

*   301：永久迁移，返回信息中有新的 URL。
*   302：临时迁移，但是有另一个新 URL。成功向重定向页发起 POST 请求后，新建的实体页可访问。

> 注意 301/302 状态码。浏览器倾向于记住 301，如果你偶然地把一些 URL 标记上 301 状态码，浏览器在收到新响应后也许仍然会这么做（它们甚至都不检查）。

4xx - 客户端错误码

*   400：错误请求，比如传递参数错误，或者缺少一些参数
*   401：未授权，用户未被认证，因此无法访问。
*   403：禁止访问，用户通常已被认证，但是这项操作未被授权，同样，在某些服务端可能会与 401 状态码混淆。
*   404：未找到，提供的 URL 找不到指定页面或数据。

5xx – 服务器错误码

*   500：服务器内部错误，例如数据库连接错误。

这些错误码是最常见的类型，并且足够让你为请求匹配正确的状态码。在 Node.js 中，我们既可以使用 [response.statusCode](https://nodejs.org/api/http.html#http_response_statuscode) 方法，也可以使用 [response.writeHead](https://nodejs.org/api/http.html#http_response_writehead_statuscode_statusmessage_headers) 方法。这次就让我们使用 _writeHead_ 方法来设置一个自定义 HTTP 消息：

```
const { createServer } = require("http");

createServer((req, res) => {
  // 表明没有内容
  res.writeHead(204, "My Custom Message");
  res.end();
}).listen(8080);
```

如果你尝试在浏览器中打开这些代码，并且在『网络』标签中浏览 HTML 请求，你将会看到『状态码：204 我的自定义消息』。

## 路由

在 Node.js 服务程序中，所有的请求都由单个请求处理程序处理。我们可以通过运行我们的任何服务来测试这点，或者通过请求不同的 URL 地址，例如地址 [http://localhost:8080/home](http://localhost:8080/home) 和 [http://localhost:8080/about](http://localhost:8080/about)。你可以看到测试将返回同样的响应。然而，在请求对象中我们有一个属性 [request.url](https://nodejs.org/api/http.html#http_message_url)，我们可以使用它构建一个简单的路由功能：

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

有很多警告（尝试在 `/about/` 页面添加一个尾部斜杠），但是你有办法。在所有的框架中，有一个主处理程序，它将所有请求导向已注册的处理程序。

## HTTP 方法

你可能熟悉 [HTTP methods/verbs](https://en.wikipedia.org/wiki/Hypertext_Transfer_Protocol#Request_methods)，例如 _GET_ 和 _POST_。它们是 HTTP 协议本身的一部分，且含义很明显。然而，它们也有许多我不想深挖的微妙细节，为了简洁起见，我想说 _GET_ 是为了获取数据，而 _POST_ 是为了创建新的实体对象。没人不让你拿它们另做他用，但是标准和惯例建议你不要这么做。

上面已经说到，在 Node.js 中服务程序有 [request.method](https://nodejs.org/api/http.html#http_message_method) 属性，可以用于我们内部逻辑处理。同样，Node.js 本身没有任何内容可供我们使用，对不同方法抽象出处理方法。我们需要自己构建抽象处理方法：

```
const { createServer } = require("http");

createServer((req, res) => {
  if (req.method === "GET") {
    return res.end("List of data");
  } else if (req.method === "POST") {
    // 创建新实体
    return res.end("success");
  } else {
    res.statusCode(400);
    return res.end("Unsupported method");
  }
}).listen(8080);
```

## Cookies 缓存

 Cookies 值得单独开一个文章来介绍，所以请随时阅读更多关于它们的内容 [MDN guide](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies)。

两个关键词，cookie 用于在请求过程中保留一些数据，因为 HTTP 是一种无状态协议，从技术上讲，如果没有 cookies（或者本地存储），我们必须在每次需要身份验证的操作之前都得执行登录操作。我们在客户端保留 cookie（通常在浏览器中），这样浏览器可以给我们发送一个名为 _Cookie_ 且包含所有 cookie 对象的 header，我们可以通过一个 `Set-Cookie` header 来响应请求，告诉客户端设置哪个 cookie（例如访问 token）；客户端保存它之后，就会在每次后续请求中将它发回服务端。

让我们运行下面的代码：

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

你第一次刷新浏览器时，可能会看到一些旧缓存 cookie，但是你看不到 _myCookie_ 或者 _mySecondCookie_。然而，如果你再刷新浏览器，你将会看到两者的值！这个情况的原因是在响应**后**客户端会在 cookies 中设置它们的值，正是这个响应渲染了我们页面。因此我们只会在**下一次**请求发生后才会从客户端接收到这些返回的缓存 cookies。

现在，如果我们想在代码中使用 cookie 值该怎么办呢？Cookie 在 HTTP 中只是一个 header，因此它是一个有着自己规则的字符串--cookie 使用 `key=value` 的模式来编写，包含参数，以 `;` 符号分割。你可以编写自己的解析器（类似这篇文章这样[this SO answer](https://stackoverflow.com/questions/3393854/get-and-set-a-single-cookie-with-node-js-http-server/3409200#3409200)），但是我建议你使用与你的框架或库兼容的其他外部库作选择就行了。

同样地，请注意你不能删除 cookie，因为它属于客户端，但是你可以通过设置它为一个空值或一个过去的失效日期这种方式，使它变得[无效](https://stackoverflow.com/questions/5285940/correct-way-to-delete-cookies-server-side)。 

## 查询参数

给特殊处理器设置参数很常见：例如，你希望显示所有图片，我们可以指定一个页面，这通过可以通过查询参数来实现。它们被添加到 URL，通过符号 `?` 与路径分隔开：`http://localhost:8080/pictures?page=2`，你可以看出，我们请求了图片库的第二个页面。或者我们可以只需要把它嵌入到 URL 链接本身，但是这里的问题是：如果有不止一个参数，URL 会很快变得混乱。查询参数并不固定，因此我们可以添加任意数量的内容，也可以在将来删除/添加新内容。

为了在我们的服务程序中获取到它，我们使用 [request.url](https://nodejs.org/api/http.html#http_message_url) 属性，在 [路由](#routing) 小节中我们已经用到过。现在，我们需要将我们的 URL 与查询参数分开，虽然我们可以手动这么做，但是没有必要，因为它已经在 Node.js 中实现了：

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

现在，如果你添加查询参数来请求任何页面，你将会在响应中看到效果，例如这个 [http://localhost:8080/about?name=Seva](http://localhost:8080/about?name=Seva) 的请求将会返回带有我们标识名的字符串：

```
 你的请求参数名带有值 Seva
``` 

## 请求体内容

 我们最后要看的是请求体内容。之前我们已知道，你可以从 URL 本身获取所有信息（路由和查询参数），但是我们如何从客户端获取到真实数据？你不用直接访问它，但我们可以直接通过读取流来获得传递的数据，这也是为什么请求对象是流对象的一个原因。让我们写一个简单的服务程序，这个程序期望从 POST 请求中获取一个 JSON 对象，并且当获取的并非有效 JSON 时将返回 _400_ 状态码。

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

最简单的测试它的方法是使用 [curl](https://curl.haxx.se/)。首先，使用一个 _GET_ 方法来查询： 

```
> curl http://localhost:8080
Unsupported method, please POST a JSON object
```

现在，使用一个随机字符串作为我们的数据来发起一个 _POST_ 请求

```
> curl -X POST -d "some random string" http://localhost:8080
Invalid JSON
```

最后，产生一个正确的响应并查看结果：

```
> curl -X POST -d '{"property": true}' http://localhost:8080
{"property":true,"ourMessage":"success"}
```

## 结尾 
你可以看出，有在仅使用内建模块来处理每个请求时有许多繁琐工作 - 比如记住每次都要关闭响应流，或者每次你发送对象时都要以字符串化的 JSON 来设置一个 `Content-Type: application/json` 类型的 header，或者分析查询参数，或者编写你自己的路由系统.....所有这些都被完成，只需要记住在框架引擎下，它使用这些核心方法，你不用担心它的内部实际如何运行。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
