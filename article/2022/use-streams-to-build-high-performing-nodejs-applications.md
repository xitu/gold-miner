> * 原文地址：[Use Streams to Build High-Performing Node.js Applications](https://blog.appsignal.com/2022/02/02/use-streams-to-build-high-performing-nodejs-applications.html)
> * 原文作者：[Deepal Jayasekara](https://blog.appsignal.com/authors/deepal-jayasekara)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/use-streams-to-build-high-performing-nodejs-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2022/use-streams-to-build-high-performing-nodejs-applications.md)
> * 译者：[tong-h](https://github.com/Tong-H)
> * 校对者：[CarlosChen](https://github.com/CarlosChenN) [zaviertang](https://github.com/zaviertang)

# 使用 Stream 构建高性能的 Node.js 应用

当你在键盘上输入字符，从磁盘读取文件或在网上下载文件时，一股信息流（bits）在流经不同的设备和应用。

如果你学会处理这些字节流，你将能构建高性能且有价值的应用。例如，试想一下当你在 YouTube 观看视频时，你不需要一直等待直到完整的视频下载完。一旦有一个小缓冲，视频就会开始播放，而剩下的会在你观看时继续下载。

Node.js 包含一个内置模块 `stream` 可以让我们处理流数据。在这篇文章中，我们将通过几个简单的示例来讲解 `stream` 的用法，我们也会描述在面对复杂案例构建高性能应用时，应该如何构建管道去合并不同的流。

在我们深入理解应用构建前，理解 Node.js `stream` 模块提供的特性很重要。

让我们开始吧！

## Node.js 流的类型

Node.js `stream` 提供了四种类型的流

* 可读流（Readable Streams）
* 可写流（Writable Streams）
* 双工流（Duplex Streams）
* 转换流（Transform Streams）

[更多详情请查看 Node.js 官方文档](https://nodejs.org/api/stream.html#stream_types_of_streams)

让我们在高层面来看看每一种流类型吧。

### 可读流

可读流可以从一个特定的数据源中读取数据，最常见的是从一个文件系统中读取。Node.js 应用中其他常见的可读流用法有：

* `process.stdin` -通过 `stdin`  在终端应用中读取用户输入。
* `http.IncomingMessage` - 在 HTTP 服务中读取传入的请求内容或者在 HTTP 客户端中读取服务器的 HTTP 响应。

### 可写流

你可以使用可写流将来自应用的数据写入到特定的地方，比如一个文件。

`process.stdout`  可以用来将数据写成标准输出且被 `console.log` 内部使用。

接下来是双工流和转换流，可以被定义为基于可读流和可写流的混合流类型。

## 双工流

双工流是可读流和可写流的结合，它既可以将数据写入到特定的地方也可以从数据源读取数据。最常见的双工流案例是 `net.Socket`，它被用来从 socket 读写数据。

有一点很重要，双工流中的可读端和可写端的操作是相互独立的，数据不会从一端流向另一端。

### 转换流

转换流与双工流略有相似，但在转换流中，可读端和可写端是相关联的。

`crypto.Cipher` 类是一个很好的例子，它实现了加密流。通过 `crypto.Cipher` 流，应用可以往流的可写端写入纯文本数据并从流的可读端读取加密后的密文。之所以将这种类型的流称之为转换流就是因为其转换性质。

**附注**：另一个转换流是 `stream.PassThrough`。`stream.PassThrough` 从可写端传递数据到可读端，没有任何转换。这听起来可能有点多余，但 Passthrough 流对构建自定义流以及流管道非常有帮助。（比如创建一个流的数据的多个副本）

## 从可读的 Node.js 流读取数据

一旦可读流连接到生产数据的源头，比如一个文件，就可以用几种方法通过该流读取数据。

首先，先创建一个名为 `myfile`  的简单的 text 文件，85 字节大小，包含以下字符串：

``` text
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur nec mauris turpis.
```

现在，我们看下从可读流读取数据的两种不同方式。

### 1. 监听 `data` 事件

从可读流读取数据的最常见方式是监听流发出的 `data` 事件。以下代码演示了这种方式：

```js
const fs = require('fs')
const readable = fs.createReadStream('./myfile', { highWaterMark: 20 });

readable.on('data', (chunk) => {
    console.log(`Read ${chunk.length} bytes\n"${chunk.toString()}"\n`);
})
```

`highWaterMark` 属性作为一个选项传递给 `fs.createReadStream`，用于决定该流中有多少数据缓冲。然后数据被冲到读取机制（在这个案例中，是我们的 `data` 处理程序）。默认情况下，可读 `fs` 流的 `highWaterMark` 值是 64kb。我们刻意重写该值为 20 字节用于触发多个 `data` 事件。

如果你运行上述程序，它会在五个迭代内从 `myfile` 中读取 85 个字节。你会在 console 看到以下输出：

```text
Read 20 bytes
"Lorem ipsum dolor si"

Read 20 bytes
"t amet, consectetur "

Read 20 bytes
"adipiscing elit. Cur"

Read 20 bytes
"abitur nec mauris tu"

Read 5 bytes
"rpis."
```

### 2. 使用异步迭代器

从可读流中读取数据的另一种方法是使用异步迭代器：

```js
const fs = require('fs')
const readable = fs.createReadStream('./myfile', { highWaterMark: 20 });

(async () => {
    for await (const chunk of readable) {
        console.log(`Read ${chunk.length} bytes\n"${chunk.toString()}"\n`);
    }
})()
```

如果你运行这个程序，你会得到和前面例子一样的输出。

## 可读 Node.js 流的状态

当一个监听器监听到可读流的 `data` 事件时，流的状态会切换成”流动”状态（除非该流被显式的暂停了）。你可以通过流对象的 `readableFlowing`  属性检查流的”流动”状态

我们可以稍微修改下前面的例子，通过 `data` 处理器来示范：

```js
const fs = require('fs')
const readable = fs.createReadStream('./myfile', { highWaterMark: 20 });

let bytesRead = 0

console.log(`before attaching 'data' handler. is flowing: ${readable.readableFlowing}`);
readable.on('data', (chunk) => {
    console.log(`Read ${chunk.length} bytes`);
    bytesRead += chunk.length

    // 在从可读流中读取 60 个字节后停止阅读
    if (bytesRead === 60) {
        readable.pause()
        console.log(`after pause() call. is flowing: ${readable.readableFlowing}`);

        // 在等待 1 秒后继续读取
        setTimeout(() => {
            readable.resume()
            console.log(`after resume() call. is flowing: ${readable.readableFlowing}`);
        }, 1000)
    }
})
console.log(`after attaching 'data' handler. is flowing: ${readable.readableFlowing}`);
```

在这个例子中，我们从一个可读流中读取  `myfile`，但在读取 60 个字节后，我们临时暂停了数据流 1 秒。我们也在不同的时间打印了 `readableFlowing` 属性的值去理解他是如何变化的。

如果你运行上述程序，你会得到以下输出：

``` text
before attaching 'data' handler. is flowing: null
after attaching 'data' handler. is flowing: true
Read 20 bytes
Read 20 bytes
Read 20 bytes
after pause() call. is flowing: false
after resume() call. is flowing: true
Read 20 bytes
Read 5 bytes
```

我们可以用以下来解释输出：

1. 当我们的程序开始时，`readableFlowing` 的值是 `null`，因为我们没有提供任何消耗流的机制。
2. 在连接到 `data` 处理器后，可读流变为“流动”模式，`readableFlowing` 变为 `true`。
3. 一旦读取 60 个字节，通过调用 `pause()`来暂停流，`readableFlowing` 也转变为 `false`。
4. 在等待 1 秒后，通过调用 `resume()`，流再次切换为“流动”模式，`readableFlowing` 改为 `true'。然后剩下的文件内容在流中流动。

## 通过 Node.js 流处理大量数据

因为有流，应用不需要在内存中保留大型的二进制对象：小型的数据块可以接收到就进行处理。

在这部分，让我们组合不同的流来构建一个可以处理大量数据的真实应用。我们会使用一个小型的工具程序来生成一个给定文件的 SHA-256。

但首先，我们需要创建一个大型的 4GB 的假文件来测试。你可以通过一个简单的 shell 命令来完成：

* On macOS: `mkfile -n 4g 4gb_file`
* On Linux: `xfs_mkfile 4096m 4gb_file`

在我们创建了假文件 `4gb_file` 后，让我们在不使用 `stream` 模块的情况下来生成来文件的 SHA-256 hash。

```js
const fs = require("fs");
const crypto = require("crypto");

fs.readFile("./4gb_file", (readErr, data) => {
  if (readErr) return console.log(readErr)
  const hash = crypto.createHash("sha256").update(data).digest("base64");
  fs.writeFile("./checksum.txt", hash, (writeErr) => {
    writeErr && console.error(err)
  });
});
```

如果你运行以上代码，你可能会得到以下错误：

``` text
RangeError [ERR_FS_FILE_TOO_LARGE]: File size (4294967296) is greater than 2 GB
    at FSReqCallback.readFileAfterStat [as oncomplete] (fs.js:294:11) {
  code: 'ERR_FS_FILE_TOO_LARGE'
}
```

以上报错之所以发生是因为 JavaScript 运行时无法处理随机的大型缓冲。运行时可以处理的最大尺寸的缓冲取决于你的操作系统结构。你可以通过使用内建的 `buffer` 模块里的 [`buffer.constants.MAX_LENGTH`](https://nodejs.org/api/buffer.html#bufferconstantsmax_length) 变量来查看你操作系统缓存的最大尺寸。

即使上述报错没有发生，在内存中保留大型文件也是有问题的。我们所拥有的可用的物理内存会限制我们应用能使用的内存量。高内存使用率也会造成应用在 CPU 使用方面性能低下，因为垃圾回收会变得昂贵。

## 使用  `pipeline()` 减少 APP 的内存占用

现在，让我们看看如何修改应用去使用流且避免遇到这个报错：

```js
const fs = require("fs");
const crypto = require("crypto");
const { pipeline } = require("stream");

const hashStream = crypto.createHash("sha256");
hashStream.setEncoding('base64')

const inputStream = fs.createReadStream("./4gb_file");
const outputStream = fs.createWriteStream("./checksum.txt");

pipeline(
    inputStream,
    hashStream,
    outputStream,
    (err) => {
        err && console.error(err)
    }
)
```

在这个例子中，我们使用 `crypto.createHash` 函数提供的流式方法。它返回一个“转换”流对象 `hashStream`，为随机的大型文件生成 hash。

为了将文件内容传输到这个转换流中，我们使用 `fs.createReadStream` 为 `4gb_file` 创建了一个可读流 `inputStream`。我们将 `hashStream`  转换流的输出传递到可写流 `outputStream` 中，而 `checksum.txt` 通过 `fs.createWriteStream` 创建的。

如果你运行以上程序，你将看见在 `checksum.txt` 文件中看见 4GB 文件的 SHA-256 hash。

### 对流使用 `pipeline()` 和 `pipe()` 的对比

在前面的案例中，我们使用 `pipeline` 函数来连接多个流。另一种常见的方法是使用 `.pipe()` 函数，如下所示：

```js
inputStream
  .pipe(hashStream)
  .pipe(outputStream)
```

但这里有几个原因，所以并不推荐在生产应用中使用 `.pipe()`。如果其中一个流被关闭或者出现报错，`pipe()` 不会自动销毁连接的流，这会导致应用内存泄露。同样的，`pipe()` 不会自动跨流转发错误到一个地方处理。

因为这些问题，所以就有了 `pipeline()`，所以推荐你使用 `pipeline()` 而不是 `pipe()` 来连接不同的流。 我们可以重写上述的 `pipe()` 例子来使用  `pipeline()` 函数，如下：

```js
pipeline(
    inputStream,
    hashStream,
    outputStream,
    (err) => {
        err && console.error(err)
    }
)
```

`pipeline()` 接受一个回调函数作为最后一个参数。任何来自被连接的流的报错都将触发该回调函数，所以可以很轻松的在一个地方处理报错。

## 总结：使用 Node.js 流降低内存并提高性能

在 Node.js 中使用流有助于我们构建可以处理大型数据的高性能应用。

在这篇文章中，我们覆盖了：

* 四种类型的 Node.js 流（可读流、可写流、双工流以及转换流）。
* 如何通过监听 `data` 事件或者使用异步迭代器来从可读流中读取数据。
* 通过使用 `pipeline` 连接多个流来减少内存占用。

**一个简短的警告**：你很可能不会遇到太多必须使用流的场景，而基于流的方案会提高你的应用的复杂性。务必确保使用流的好处胜于它所带来的复杂性。

我推荐你去 [阅读 Node.js `stream` 的官方文档](https://nodejs.org/api/stream.html#stream) 学习和探索更多关于流更高级的用例。

快乐的编码吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
