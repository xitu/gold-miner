> * 原文地址：[19 things I learnt reading the NodeJS docs](https://hackernoon.com/19-things-i-learnt-reading-the-nodejs-docs-8a2dcc7f307f#.8iaiz8xls)
* 原文作者：[David Gilbertson](https://hackernoon.com/@david.gilbertson)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：jacksonke20120711@gmail.com
* 校对者：[mortyu](https://github.com/mortyu), [rottenpen](https://github.com/rottenpen)

# 阅读 NodeJS 文档，我学到了这 19 件事情


我相信我对 Node 了若指掌。我这 3 年来写的网站都是用 Node 来开发的。但实际上，我从没有详细查看 Node 文档。

长期的订阅者应该知道，我正处在书写每一个接口(interface)，属性(prop)，方法(method)，函数(function)，数据类型(data type)等等关于 Web 开发的漫漫长途中，这样可以填补我的知识面的空缺。在完成了 HTML，DOM, WebApi, CSS, SVG 和 EcmaScript 之后, Node 文档会是我的最后一站。

对我来说，这里面有很多宝贵的知识，所以我想简短地列举，并且分享它们。我会按吸引力从高到低列举它们，好比我见新朋友时的衣服顺序，（最吸引人的放外面 ^_^）

### 把 querystring 当作通用解析器

假设你从一些古怪的数据库中获取到的数据是一些键值对数组，格式像`name:Sophie;shape:fox;condition:new`。很自然的，你会将它当成一个 JavaScript 对象。你会将所取得的数据以`;`为分隔符切分成数组，然后遍历数组，用`:`分割，第一项作为属性，第二项作为该属性对应的值。

这样对吧？

不用这般麻烦的，你可以使用 `querystring`

    const weirdoString = `name:Sophie;shape:fox;condition:new`;
    const result = querystring.parse(weirdoString, `;`, `:`);

    // result:
    // {
    //   name: `Sophie`,
    //   shape: `fox`,
    //   condition: `new`,
    // };

[**Query String | Node.js v7.0.0 Documentation**  
_By default, percent-encoded characters within the query string will be assumed to use UTF-8 encoding. If an alternative…_nodejs.org](https://nodejs.org/api/querystring.html#querystring_querystring_parse_str_sep_eq_options "https://nodejs.org/api/querystring.html#querystring_querystring_parse_str_sep_eq_options")

### V8 Inspector

运行 node，加上`--inspect`选项，会给出一个 URL 地址。粘贴该 URL 到 Chrome。哈哈，这就能用 Chrome DevTools 调试 Node，这多方便，多轻松。这篇文章有介绍如何使用[ how-to by Paul Irish over here ](https://medium.com/@paul_irish/debugging-node-js-nightlies-with-chrome-devtools-7c4a1b95ae27#.evhku718w).

虽然它现在还处于“试验”阶段，但是现在已经极大地解决了我的困挠。

[**Debugger | Node.js v7.0.0 Documentation**  
_Node.js includes a full-featured out-of-process debugging utility accessible via a simple TCP-based protocol and built…_nodejs.org](https://nodejs.org/api/debugger.html#debugger_v8_inspector_integration_for_node_js "https://nodejs.org/api/debugger.html#debugger_v8_inspector_integration_for_node_js")

### nextTick 和 setImmediate 的不同点

和多数情况一样，如果能给它们起个更贴切的名字，就很容易记住两者的不同了。

`process.nextTick()` 是 `process.sendThisToTheStartOfTheQueue()`.(译者注：放入队列的第一个位置)

`setImmediate()` 应该被叫做 `sendThisToTheEndOfTheQueue()`.(译者注：放入队列的尾部，最后一个处理的)

(题外话：React 中，我通常将`props`当成`stuffThatShouldStayTheSameIfTheUserRefreshes`，而将`state`当成`stuffThatShouldBeForgottenIfTheUserRefreshes`.这两者长度一致也是个意外，哈哈哈。)

[**Node.js v7.0.0 Documentation**  
_Stability: 3 — Locked The timer module exposes a global API for scheduling functions to be called at some future period…_nodejs.org](https://nodejs.org/api/timers.html#timers_setimmediate_callback_args "https://nodejs.org/api/timers.html#timers_setimmediate_callback_args")

[**process | Node.js v7.0.0 Documentation**  
_A process warning is similar to an error in that it describes exceptional conditions that are being brought to the user…_nodejs.org](https://nodejs.org/api/process.html#process_process_nexttick_callback_args "https://nodejs.org/api/process.html#process_process_nexttick_callback_args")

[**Node v0.10.0 (Stable)**  
_I am pleased to announce a new stable version of Node. This branch brings significant improvements to many areas, with…_nodejs.org](https://nodejs.org/en/blog/release/v0.10.0/#faster-process-nexttick "https://nodejs.org/en/blog/release/v0.10.0/#faster-process-nexttick")

### Server.listen 只带一个参数对象

对于参数传递，我倾向于只使用一个参数 `options` ，而不是传 5 个没命名且必须按照特定顺序的参数。这可以在服务端监听连接时使用。

    require(`http`)
      .createServer()
      .listen({
        port: 8080,
        host: `localhost`,
      })
      .on(`request`, (req, res) => {
        res.end(`Hello World!`);
      });

这个文档比较隐蔽，它并不在`http.Server`的方法列表里，而是在`net.Server`中（`http.Server`继承`net.Server`）

[**net | Node.js v7.0.0 Documentation**  
_Stops the server from accepting new connections and keeps existing connections. This function is asynchronous, the…_nodejs.org](https://nodejs.org/api/net.html#net_net_createserver_options_connectionlistener "https://nodejs.org/api/net.html#net_net_createserver_options_connectionlistener")

### 相对路径

传入`fs`模块方法的路径可以是相对路径。这是相对于`process.cwd()`。这可能多数人都知道了，但我以前一直以为要传入绝对路径。

    const fs = require(`fs`);
    const path = require(`path`);

    // why have I always done this...
    fs.readFile(path.join(__dirname, `myFile.txt`), (err, data) => {
      // do something
    });

    // when I could just do this?
    fs.readFile(`./path/to/myFile.txt`, (err, data) => {
      // do something
    });

[**File System | Node.js v7.0.0 Documentation**  
_birthtime “Birth Time” — Time of file creation. Set once when the file is created. On filesystems where birthtime is…_nodejs.org](https://nodejs.org/api/fs.html#fs_file_system "https://nodejs.org/api/fs.html#fs_file_system")

### 路径解析

以前我会显摆的技术之一就是使用正则表达式从路径字符串中获取文件名和拓展名，这其实根本没有必要，需要做的仅仅是调用接口：

    myFilePath = `/someDir/someFile.json`;
    path.parse(myFilePath).base === `someFile.json`; // true
    path.parse(myFilePath).name === `someFile`; // true
    path.parse(myFilePath).ext === `.json`; // true

[**Node.js v7.0.0 Documentation**  
_Stability: 2 — Stable The path module provides utilities for working with file and directory paths. It can be accessed…_nodejs.org](https://nodejs.org/api/path.html#path_path_parse_path "https://nodejs.org/api/path.html#path_path_parse_path")

### 使用不同颜色来记录日志

使用`console.dir(obj, {colors: true})`可以使用预先设置好的配色方案打印日志，这样更易于阅读。

[**Console | Node.js v7.0.0 Documentation**  
_The console functions are usually asynchronous unless the destination is a file. Disks are fast and operating systems…_nodejs.org](https://nodejs.org/api/console.html#console_console_dir_obj_options "https://nodejs.org/api/console.html#console_console_dir_obj_options")

### 让 setInterval() 不去影响应用的效率

假设你使用`setInterval()`来执行数据库清理操作，一天一次。默认情况下，只要`setInterval()`的请求还在， Node  的事件循环是不会停止的。如果你想让 Node 休息（我也不知道这样做的好处），你可以这么做：

    const dailyCleanup = setInterval(() => {
      cleanup();
    }, 1000 * 60 * 60 * 24);

    dailyCleanup.unref();

需要注意的是，如果你的队列中没有其它的请求（比如 http 服务监听），Node 会退出的。

[**Node.js v7.0.0 Documentation**  
_Stability: 3 — Locked The timer module exposes a global API for scheduling functions to be called at some future period…_nodejs.org](https://nodejs.org/api/timers.html#timers_timeout_unref "https://nodejs.org/api/timers.html#timers_timeout_unref")

### 使用 Signal 常量

可能你以前会这样处理 kill：

    process.kill(process.pid, `SIGTERM`);

如果计算机编程的历史不存在由错字引发的错误，这样做没什么错的。但是实际上这是发生过的。第二个参数可以是带上'string'**或者**对应的 int ，你可以使用下面更健壮的方式

    process.kill(process.pid, os.constants.signals.SIGTERM);

### IP 地址有效性验证

Node 已经有内置的 IP 地址校验器。我以前不止一次自己写正则表达式去做这个。好蠢（┬＿┬）

`require(`net`).isIP(`10.0.0.1`)` will return `4`.

`require(`net`).isIP(`cats`)` will return `0`.

因为`cats`并不是一个IP地址

如果你没注意到，我正经历着这么个阶段，字符串使用反引号包起来， 它在我身上越来越多，但我知道它看起来很奇怪，所以我特意提到它。。。（作者的唠叨）

[**net | Node.js v7.0.0 Documentation**  
_Stops the server from accepting new connections and keeps existing connections. This function is asynchronous, the…_nodejs.org](https://nodejs.org/api/net.html#net_net_isip_input "https://nodejs.org/api/net.html#net_net_isip_input")

### os.EOL

你曾经对行结束符硬编码吗？

我的天！

`os.EOL`是专门为你准备的，它在 Windows 操作系统上为`\r\n`，在其它系统上是`\n`。[使用 os.EOL ](https://github.com/sasstools/sass-lint/pull/92/files) 能让你的代码在不同的操作系统上表现一致。

    const fs = require(`fs`);

    // bad
    fs.readFile(`./myFile.txt`, `utf8`, (err, data) => {
      data.split(`\r\n`).forEach(line => {
        // do something
      });
    });

    // good
    const os = require(`os`);
    fs.readFile(`./myFile.txt`, `utf8`, (err, data) => {
      data.split(os.EOL).forEach(line => {
        // do something
      });
    });

[**OS | Node.js v7.0.0 Documentation**  
_{ model: ‘Intel(R) Core(TM) i7 CPU 860 @ 2.80GHz’, speed: 2926, times: { user: 252020, nice: 0, sys: 30340, idle…_nodejs.org](https://nodejs.org/api/os.html#os_os_eol "https://nodejs.org/api/os.html#os_os_eol")

### 状态码查询

HTTP 状态码及其对应的易读性的名字是可以查询的。`http.STATUS_CODES`正是我这里想说的，它的键是个状态码，值对应其状态的简短描述。









![](https://d262ilb51hltx0.cloudfront.net/max/1600/1*68Kp8_XfEM3gUoS__WGx9Q.png)





所以你可以这么做：

    someResponse.code === 301; // true
    require(`http`).STATUS_CODES[someResponse.code] === `Moved Permanently`; // true

[**HTTP | Node.js v7.0.0 Documentation**  
_The HTTP interfaces in Node.js are designed to support many features of the protocol which have been traditionally…_nodejs.org](https://nodejs.org/api/http.html#http_http_status_codes "https://nodejs.org/api/http.html#http_http_status_codes")

### 预防崩溃

我一直认为下面的这种错误导致的服务崩溃是非常荒谬的：

    const jsonData = getDataFromSomeApi(); // But oh no, bad data!
    const data = JSON.parse(jsonData); // Loud crashing noise.

预防这种可笑的错误，你可以在你 app 的中使用`process.on(`uncaughtException`, console.error);`

当然，我不是傻瓜，在付费的项目中，我会使用[ PM2 ](http://pm2.keymetrics.io/)，同时把所有的东西都装到`try...catch`语句中。但是，私人免费项目就另说 o_o ....

警告，这个[并非最好的练习](https://nodejs.org/api/process.html#process_warning_using_uncaughtexception_correctly),在大点复杂点的 app  中，这甚至可能是个坏主意。这需要你来决定是否要信任一个家伙的博客文章或官方文档。

[**process | Node.js v7.0.0 Documentation**  
_A process warning is similar to an error in that it describes exceptional conditions that are being brought to the user…_nodejs.org](https://nodejs.org/api/process.html#process_event_uncaughtexception "https://nodejs.org/api/process.html#process_event_uncaughtexception")

### Just this once()

对所有的事件发送者(EventEmitters)，除了`on()`方法之外，还有`once()`，我很确认我是地球上最后一个学到这点的人 (T_T) 

    server.once(`request`, (req, res) => res.end(`No more from me.`));

[**Events | Node.js v7.0.0 Documentation**  
_Much of the Node.js core API is built around an idiomatic asynchronous event-driven architecture in which certain kinds…_nodejs.org](https://nodejs.org/api/events.html#events_emitter_once_eventname_listener "https://nodejs.org/api/events.html#events_emitter_once_eventname_listener")

### 定制控制台

你可以使用 `new console.Console(standardOut, errorOut)` 创建你自己的控制台，传入你自己的输出流。

为什么要定制控制台? 我也不知道。或许想要将一些内容输出到文件，套接字，或者其他东西的时候，会考虑定制控制台。

[**Console | Node.js v7.0.0 Documentation**  
_The console functions are usually asynchronous unless the destination is a file. Disks are fast and operating systems…_nodejs.org](https://nodejs.org/api/console.html#console_new_console_stdout_stderr "https://nodejs.org/api/console.html#console_new_console_stdout_stderr")

### DNS查询结果

Node [不缓存 DNS 返回的结果](https://github.com/nodejs/node/issues/5893).所以当你一次又一次地查询同一个 URL 的时候，其实已经浪费了很多宝贵的时间。这种情况下，你完全可以自己调用`dns.lookup()`并缓存结果的。或者可以[这么](https://www.npmjs.com/package/dnscache)做，这个是先前有人实现的。

    dns.lookup(`www.myApi.com`, 4, (err, address) => {
      cacheThisForLater(address);
    });

[**DNS | Node.js v7.0.0 Documentation**  
_2) Functions that connect to an actual DNS server to perform name resolution, and that always use the network to…_nodejs.org](https://nodejs.org/api/dns.html#dns_dns_lookup_hostname_options_callback "https://nodejs.org/api/dns.html#dns_dns_lookup_hostname_options_callback")

### `fs`模块是多操作系统兼容性的雷区

如果你写代码的风格和我一样--阅读最少的知识，微调程序，直到它可以运行。那么，你很有可能也会触到`fs`模块的雷区。虽然 Node 为多操作系统的兼容性做了很多，但毕竟也只能做到那么多。许多 OS 的不同特性就像代码海洋中突起的珊瑚瞧，每个瞧石都隐藏着风险。而你，仅仅是小船。

不幸的是，这些不同点不仅仅是存在于 Windows 和其它操作系统之间，所以，你不能简单的自我安慰“哇，太好了，没人使用  Windows”。（我写过一大篇反对使用 Windows 来进行 Web 开发的文章，但我自己把它删了，因为那些说教，连我自己看了都翻白眼）。

下面这些是你在使用`fs`模块时，可能碰到的坑

*   `fs.stats()`返回的`mode`属性在 Windows 和其它操作系统上是不同的（在 Windows 上没有匹配一些文件模式常量，比如 `fs.constants.S_IRWXU`）
*   `fs.lchmod()`只能在 macOS 中使用
*   `fs.symlink()` 的`type`参数只可能在 Windows 上使用
*   `fs.watch()` 选项`recursive`只能在 macOS 和 Windows 中使用。
*   `fs.watch()` 在 Windows 和 Linux 上，回调只会接受一个文件名
*   `fs.open()` 打开一个文件夹，在 FreeBSD 和 Windows 上使用`a+`属性是可以的，但是在 macOS 和 Linux 上是不行的。
*   `fs.write()` 在linux上，当文件是以append的方式打开的，参数`position`是会被直接忽视掉的，直接在文件末尾添加。

(我还算挺赶时髦的，我已经改用`macOS`了，`OS X`只用了 49 天)

[**File System | Node.js v7.0.0 Documentation**  
_birthtime “Birth Time” – Time of file creation. Set once when the file is created. On filesystems where birthtime is…_nodejs.org](https://nodejs.org/api/fs.html "https://nodejs.org/api/fs.html")

### net 模块是 http 模块速度的两倍

阅读文档，我学到了`net`模块是个事儿。它支撑着`http`模块。这会让我思索，假如我只想做服务器间的通讯 (server-to-server communication )，我是不是只需要使用`net`模块？

网上的人或许很难相信我不能凭直觉获得答案。作为一个 Web 开发者，我一开始就扎进了服务端的世界里，我知道 http 但是其他方面并不是很多。所有的  TCP, 套接字，流之类的对我来说就像[日本摇滚](https://www.youtube.com/watch?v=FQgH4G3qypI).我真的不是很明白，但是我很好奇。

为了比较验证我的想法，我建立了多个服务端程序，（我相信这时你肯定在听日本摇滚了）,并且发送了多个请求。结论是 `http.Server`每秒中处理了大约3,400个请求，`net.Server`每秒钟处理5,500个。

它其实也很简单。

如果你感兴趣的话，可以查看我的代码。如果不感兴趣，那不好意思，需要你滚动页面了。

    // This makes two connections, one to a tcp server, one to an http server (both in server.js)
    // It fires off a bunch of connections and times the response

    // Both send strings.

    const net = require(`net`);
    const http = require(`http`);

    function parseIncomingMessage(res) {
      return new Promise((resolve) => {
        let data = ``;

        res.on(`data`, (chunk) => {
          data += chunk;
        });

        res.on(`end`, () => resolve(data));
      });
    }

    const testLimit = 5000;

    /*  ------------------  */
    /*  --  NET client  --  */
    /*  ------------------  */
    function testNetClient() {
      const netTest = {
        startTime: process.hrtime(),
        responseCount: 0,
        testCount: 0,
        payloadData: {
          type: `millipede`,
          feet: 100,
          test: 0,
        },
      };

      function handleSocketConnect() {
        netTest.payloadData.test++;
        netTest.payloadData.feet++;

        const payload = JSON.stringify(netTest.payloadData);

        this.end(payload, `utf8`);
      }

      function handleSocketData() {
        netTest.responseCount++;

        if (netTest.responseCount === testLimit) {
          const hrDiff = process.hrtime(netTest.startTime);
          const elapsedTime = hrDiff[0] * 1e3 + hrDiff[1] / 1e6;
          const requestsPerSecond = (testLimit / (elapsedTime / 1000)).toLocaleString();

          console.info(`net.Server handled an average of ${requestsPerSecond} requests per second.`);
        }
      }

      while (netTest.testCount  {
          httpTest.responseCount++;

          if (httpTest.responseCount === testLimit) {
            const hrDiff = process.hrtime(httpTest.startTime);
            const elapsedTime = hrDiff[0] * 1e3 + hrDiff[1] / 1e6;
            const requestsPerSecond = (testLimit / (elapsedTime / 1000)).toLocaleString();

            console.info(`http.Server handled an average of ${requestsPerSecond} requests per second.`);
          }
        });
      }

      while (httpTest.testCount  {
      console.info(`Starting testNetClient()`);
      testNetClient();
    }, 50);

    setTimeout(() => {
      console.info(`Starting testHttpClient()`);
      testHttpClient();
    }, 2000);

    // This sets up two servers. A TCP and an HTTP one.
    // For each response, it parses the received string as JSON, converts that object and returns a string
    const net = require(`net`);
    const http = require(`http`);

    function renderAnimalString(jsonString) {
      const data = JSON.parse(jsonString);
      return `${data.test}: your are a ${data.type} and you have ${data.feet} feet.`;
    }

    /*  ------------------  */
    /*  --  NET server  --  */
    /*  ------------------  */

    net
      .createServer((socket) => {
        socket.on(`data`, (jsonString) => {
          socket.end(renderAnimalString(jsonString));
        });
      })
      .listen(8888);

    /*  -------------------  */
    /*  --  HTTP server  --  */
    /*  -------------------  */

    function parseIncomingMessage(res) {
      return new Promise((resolve) => {
        let data = ``;

        res.on(`data`, (chunk) => {
          data += chunk;
        });

        res.on(`end`, () => resolve(data));
      });
    }

    http
      .createServer()
      .listen(8080)
      .on(`request`, (req, res) => {
        parseIncomingMessage(req).then((jsonString) => {
          res.end(renderAnimalString(jsonString));
        });
      });

[**net | Node.js v7.0.0 Documentation**  
_Stops the server from accepting new connections and keeps existing connections. This function is asynchronous, the…_nodejs.org](https://nodejs.org/api/net.html "https://nodejs.org/api/net.html")

### REPL技巧

1.  当你处于 REPL（那是你在控制台敲入`node`，并按了回车键的情形），你可以敲入`.load someFile.js`，这时，它会将这个文件的内容加载进来。（比如，你可以加载一个包含大量常量的文件）。
2.  当你设置环境变量`NODE_REPL_HISTORY=""`，这样可以禁止 repl 的历史写入文件中。同时我也学到（至少是被提醒了）REPL 的历史默认是写到`~/.node_repl_history`中，当你想回忆起之前的 REPL 历史时，可以上这儿查。
3.  `_` 这个变量，保存着上一次的计算结果. 相当方便!
4.  当你进入 REPL 模式中时，模块都已经为你加载好了。所以了，比如说，你可以直接敲入`os.arch()`查看操作系统体系结构。你不需要先敲入`require(`os`).arch();` (注: 确的说，是按需加载的模块.)
