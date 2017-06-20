> * 原文地址：[Node.js Streams: Everything you need to know](https://medium.freecodecamp.com/node-js-streams-everything-you-need-to-know-c9141306be93)
> * 原文作者：本文已获原作者 [Samer Buna](https://medium.freecodecamp.com/@samerbuna) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[loveky](https://github.com/loveky)
> * 校对者：[zaraguo](https://github.com/zaraguo) [Aladdin-ADD](https://github.com/Aladdin-ADD)

# Node.js 流: 你需要知道的一切 #

![](https://img30.360buyimg.com/uba/jfs/t6076/25/1691927562/1083199/d5be5c18/59357a9dNffac5f58.jpg)

[图片来源](https://commons.wikimedia.org/wiki/File:Urban_stream_in_park.jpg)

Node.js 中的流有着难以使用，更难以理解的名声。现在我有一个好消息告诉你：事情已经不再是这样了。

很长时间以来，开发人员创造了许许多多的软件包为的就是可以更简单的使用流。但是在本文中，我会把重点放在原生的 [Node.js 流 API](https://nodejs.org/api/stream.html)上。

> “流是 Node 中最棒的，同时也是最被人误解的想法。”

> — Dominic Tarr

### 流到底是什么呢？ ###

流是数据的集合 —— 就像数组或字符串一样。区别在于流中的数据可能不会立刻就全部可用，并且你无需一次性地把这些数据全部放入内存。这使得流在操作大量数据或是数据从外部来源逐**段**发送过来的时候变得非常有用。

然而，流的作用并不仅限于操作大量数据。它还带给我们组合代码的能力。就像我们可以通过管道连接几个简单的 Linux 命令以组合出强大的功能一样，我们可以利用流在 Node 中做同样的事。

![](https://img13.360buyimg.com/uba/jfs/t5605/188/2846141474/21851/33e5d376/59357acdN88421e7c.png)

Linux 命令的组合性

```bash
const grep = ... // 一个 grep 命令输出的 stream
const wc = ... // 一个 wc 命令输入的 stream

grep.pipe(wc)
```

Node 中许多内建的模块都实现了流接口：

![](https://img20.360buyimg.com/uba/jfs/t5737/26/2964786637/95062/83389b23/59357af3N88fa9f2d.png)

截屏来自于我的 Pluralsight 课程 —— 高级 Node.js

上边的列表中有一些 Node.js 原生的对象，这些对象也是可以读写的流。这些对象中的一部分是既可读、又可写的流，例如 TCP sockets，zlib 以及 crypto。

需要注意的是这些对象是紧密关联的。虽然一个 HTTP 响应在客户端是一个可读流，但在服务器端它却是一个可写流。这是因为在 HTTP 的情况中，我们基本上是从一个对象（`http.IncomingMessage`）读取数据，向另一个对象（`http.ServerResponse`）写入数据。

还需要注意的是 `stdio` 流（`stdin`，`stdout`，`stderr`）在子进程中有着与父进程中相反的类型。这使得在子进程中从父进程的 `stdio` 流中读取或写入数据变得非常简单。

### 一个流的真实例子 ###

理论是伟大的，当往往没有 100% 的说服力。下面让我们通过一个例子来看看流在节省内存消耗方面可以起到的作用。

首先让我们创建一个大文件：

```js
const fs = require('fs');
const file = fs.createWriteStream('./big.file');

for(let i=0; i<= 1e6; i++) {
  file.write('Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n');
}

file.end();
```

看看在创建这个大文件时我用到了什么。一个可写流！

通过 `fs` 模块你可以使用一个流接口读取或写入文件。在上面的例子中，我们通过一个可写流向 `big.file` 写入了 100 万行数据。

执行这段脚本会生成一个约 400MB 大小的文件。

以下是一个用来发送 `big.file` 文件的 Node web 服务器：

```js
const fs = require('fs');
const server = require('http').createServer();

server.on('request', (req, res) => {
  fs.readFile('./big.file', (err, data) => {
    if (err) throw err;

    res.end(data);
  });
});

server.listen(8000);
```

当服务器收到请求时，它会通过异步方法 `fs.readFile` 读取文件内容发送给客户端。看起来我们并没有阻塞事件循环。一切看起来还不错，是吧？是吗？

让我们来看看真实的情况吧。我们启动服务器，发起连接，并监控内存的使用情况。

当我启动服务器的时候，它占用了一个正常大小的内存空间，8.7MB：

![](https://img11.360buyimg.com/uba/jfs/t5623/215/2967958024/56361/da4fbfad/59357b1bNeb053c07.png)

当我连接到服务器的时候。请注意内存消耗的变化：

![](https://img13.360buyimg.com/uba/jfs/t5683/37/2987262957/2500112/2678603c/59357b56N5fb2b483.gif)

哇 —— 内存消耗暴增到 434.8MB。

在我们将其写入响应对象之前，我们基本上把 `big.file` 的全部内容都载入到内存中了。这是非常低效的。

HTTP 响应对象也是一个可写流。这意味着如果我们有一个代表了 `big.file` 内容的可读流，我们就可以通过将两个流连接起来以实现相同的功能而不必消耗约 400MB 的内存。

Node `fs` 模块中的 `createReadStream` 方法可以针对任何文件给我们返回一个可读流。我们可以把它和响应对象连接起来：

```js
const fs = require('fs');
const server = require('http').createServer();

server.on('request', (req, res) => {
  const src = fs.createReadStream('./big.file');
  src.pipe(res);
});

server.listen(8000);
```

现在，当你再次连接到服务器时，神奇的事情发生了（请注意内存消耗）：

![](https://cloud.githubusercontent.com/assets/1198651/26791059/85afb648-4a48-11e7-917c-48415d8737ee.gif)

**发生了什么？**

当客户端请求这个大文件时，我们通过流逐块的发送数据。这意味着我们不需要把文件的全部内容缓存到内存中。内存消耗只增长了大约 25MB。

你可以把这个例子推向极端。重新生成一个 500 万行而不是 100 万行的 `big.file` 文件。它大概有 2GB 那么大。这已经超过了 Node 中默认的缓冲区大小的上限。

如果你尝试通过 `fs.readFile` 读取那个文件，默认情况下会失败（当然你可以修改缓冲区大小上限）。但是通过使用 `fs.createReadStream`，向客户端发送一个 2GB 的文件就没有任何问题。更棒的是，进程的内存消耗并不会因文件增大而增长。

准备好学习流了吗？

> 这篇文章是[我的 Pluralsight 课堂上 Node.js 课程](https://www.pluralsight.com/courses/nodejs-advanced)中的一部分。你可以通过这个链接找到这部分内容的视频版。

### 流快速入门 ###

在 Node.js 中有四种基本类型的流：可读流，可写流，双向流以及变换流。

- 可读流是对一个可以读取数据的源的抽象。`fs.createReadStream` 方法是一个可读流的例子。
- 可写流是对一个可以写入数据的目标的抽象。`fs.createWriteStream` 方法是一个可写流的例子。
- 双向流既是可读的，又是可写的。TCP socket 就属于这种。
- 变换流是一种特殊的双向流，它会基于写入的数据生成可供读取的数据。例如使用 `zlib.createGzip` 来压缩数据。你可以把一个变换流想象成一个函数，这个函数的输入部分对应可写流，输出部分对应可读流。你也可能听说过变换流有时被称为 “**thought streams**”。

所有的流都是 `EventEmitter` 的实例。它们发出可用于读取或写入数据的事件。然而，我们可以利用 `pipe` 方法以一种更简单的方式使用流中的数据。

#### pipe 方法 ####

以下这行代码就是你要记住的魔法：

```js
readableSrc.pipe(writableDest)
```

在这行简单的代码中，我们以管道的方式把一个可读流的输出连接到了一个可写流的输入。管道的上游（source）必须是一个可读流，下游（destination）必须是一个可写流。当然，它们也可以是双向流/变换流。事实上，如果我们使用管道连接的是双向流，我们就可以像 Linux 系统里那样连接多个流：

```js
readableSrc
  .pipe(transformStream1)
  .pipe(transformStream2)
  .pipe(finalWrtitableDest)
```

`pipe` 方法会返回最后一个流，这使得我们可以串联多个流。对于流 `a` （可读），`b` 和 `c` （双向），以及 `d`（可写）。我们可以这样：

```js
a.pipe(b).pipe(c).pipe(d)

# 等价于:
a.pipe(b)
b.pipe(c)
c.pipe(d)

# 在 Linux 中，等价于：
$ a | b | c | d
```

`pipe` 方法是使用流最简单的方式。通常的建议是要么使用 `pipe` 方法、要么使用事件来读取流，要避免混合使用两者。一般情况下使用 `pipe` 方法时你就不必再使用事件了。但如果你想以一种更加自定义的方式使用流，就要用到事件了。

#### 流事件 ####

除了从可读流中读取数据写入可写流以外，`pipe` 方法还自动帮你处理了一些其他情况。例如，错误处理，文件结尾，以及两个流读取/写入速度不一致的情况。

然而，流也可以直接通过事件读取。以下是一段简化的使用事件来模拟 `pipe` 读取、写入数据的代码：

```js
# readable.pipe(writable)

readable.on('data', (chunk) => {
  writable.write(chunk);
});

readable.on('end', () => {
  writable.end();
});
```

以下是一些使用可读流或可写流时用到的事件和方法：

![](https://img12.360buyimg.com/uba/jfs/t5761/104/2911588509/94847/ca85cce7/59357be5Nfc521b48.png)

截屏来自于我的 Pluralsight 课程 - 高级 Node.js

这些事件和函数是相关的，因为我们总是把它们组合在一起使用。

一个可读流上最重要的两个事件是：

- `data` 事件，任何时候当可读流发送数据给它的消费者时，会触发此事件
- `end` 事件，当可读流没有更多的数据要发送给消费者时，会触发此事件

一个可写流上最重要的两个事件是：

- `drain` 事件，这是一个表示可写流可以接受更多数据的信号.
- `finish` 事件，当所有数据都被写入底层系统后会触发此事件。

事件和函数可以组合起来使用，以更加定制，优化的方式使用流。对于可读流，我们可以使用 `pipe`/`unpipe` 方法，或是 `read`，`unshift`，`resume`方法。对于可写流，我们可以把它设置为 `pipe`/`unpipe` 方法的下游，亦或是使用 `write` 方法写入数据并在写入完成后调用 `end` 方法。

#### 可读流的暂停和流动模式 ####

可读流有两种主要的模式，影响我们使用它的方式：

- 它要么处于**暂停**模式
- 要么就是处于**流动**模式

这些模式有时也被成为拉取和推送模式。

所有的可读流默认都处于暂停模式。但它们可以按需在流动模式和暂停模式间切换。这种切换有时会自动发生。

当一个可读流处于暂停模式时，我们可以使用 `read()` 方法按需的读取数据。而对于一个处于流动模式的可读流，数据会源源不断的流动，我们需要通过事件监听来处理数据。

在流动模式中，如果没有消费者监听事件那么数据就会丢失。这就是为何在处理流动模式的可读流时我们需要一个 `data` 事件回调函数。事实上，通过增加一个 `data` 事件回调就可以把处于暂停模式的流切换到流动模式；同样的，移除 `data` 事件回调会把流切回到暂停模式。这么做的一部分原因是为了和旧的 Node 流接口兼容。

要手动在这两个模式间切换，你可以使用 `resume()` 和 `pause()` 方法。

![](https://img10.360buyimg.com/uba/jfs/t5713/301/2899078962/40099/a3c38f7d/59357c0dN8df8e18c.png)

截屏来自于我的 Pluralsight 课程 - 高级 Node.js

当使用 `pipe` 方法时，它会自动帮你处理好这些模式之间的切换，因此你无须关心这些细节。

### 实现流接口 ###

当我们讨论 Node.js 中的流时，主要是讨论两项任务：

- 一个是**实现**流。
- 一个是**使用**流。

到目前为止，我们只讨论了如何使用流。接下来让我们看看如何实现它！

流的实现者通常都会 `require` `stream` 模块。

#### 实现一个可写流 ####

要实现一个可写流，我们需要使用来自 stream 模块的 `Writable` 类。

```js
const { Writable } = require('streams');
```

实现一个可写流有很多种方法。例如，我们可以继承 `Writable` 类：

```js
class myWritableStream extends Writable {
}
```

然而，我倾向于更简单的构造方法。我们可以直接给 `Writable` 构造函数传入配置项来创建一个对象。唯一必须的配置项是一个 `write` 函数，它用于暴露一个写入数据的接口。

```js
const { Writable } = require('stream');
const outStream = new Writable({
  write(chunk, encoding, callback) {
    console.log(chunk.toString());
    callback();
  }
});

process.stdin.pipe(outStream);
```

write 方法接受三个参数。

- **chunk** 通常是一个 buffer，除非我们对流进行了特殊配置。
- **encoding** 通常可以忽略。除非 chunk 被配置为不是 buffer。
- **callback** 方法是一个在我们完成数据处理后要执行的回调函数。它用来表示数据是否成功写入。若是写入失败，在执行该回调函数时需要传入一个错误对象。

在 `outStream` 中，我们只是单纯的把收到的数据当做字符串 `console.log` 出来，并通过执行 `callback` 时不传入错误对象以表示写入成功。这是一个非常简单且没什么用处的**回传**流。它会回传任何收到的数据。

要使用这个流，我们可以把它和可读流 `process.stdin` 配合使用。只需把 `process.stdin` 通过管道连接到 `outStream`。

当我们运行上面的代码时，任何输入到 `process.stdin` 中的字符都会被 `outStream` 中的 `console.log` 输出回来。

这不是一个非常实用的流实现，因为 Node 已经内置了它的实现。它几乎等同于 `process.stdout`。通过把 `stdin` 和 `stdout` 连接起来，我们就可以通过一行代码得到完全相同的回传效果：

```js
process.stdin.pipe(process.stdout);
```

#### 实现一个可读流 ####

要实现可读流，我们需要引入 `Readable` 接口并通过它创建对象：

```js
const { Readable } = require('stream');

const inStream = new Readable({});
```

这是一个非常简单的可读流实现。我们可以通过 `push` 方法向下游推送数据。

```js
const { Readable } = require('stream');  

const inStream = new Readable();

inStream.push('ABCDEFGHIJKLM');
inStream.push('NOPQRSTUVWXYZ');

inStream.push(null); // 没有更多数据了

inStream.pipe(process.stdout);
```

当我们 `push` 一个 `null` 值，这表示该流后续不会再有任何数据了。

要使用这个可读流，我们可以把它连接到可写流 `process.stdout`。

当我们执行以上代码时，所有读取自 `inStream` 的数据都会被显示到标准输出上。非常简单，但并不高效。

在把该流连接到 `process.stdout` 之前，我们就已经推送了所有数据。更好的方式是只在使用者要求时**按需**推送数据。我们可以通过在可读流配置中实现 `read()` 方法来达成这一目的：

```js
const inStream = new Readable({
  read(size) {
    // 某人想要读取数据
  }
});
```

当可读流上的 read 方法被调用时，流实现可以向队列中推送部分数据。例如，我们可以从字符编码 65（表示字母 A） 开始，一次推送一个字母，每次都把字符编码加 1：

```js
const inStream = new Readable({
  read(size) {
    this.push(String.fromCharCode(this.currentCharCode++));
    if (this.currentCharCode > 90) {
      this.push(null);
    }
  }
});

inStream.currentCharCode = 65

inStream.pipe(process.stdout);
```



当使用者读取该可读流时，`read` 方法会持续被触发，我们不断推送字母。我们需要在某处停止该循环，这就是为何我们放置了一个 if 语句以便在 currentCharCode 大于 90（代表 Z） 时推送一个 null 值。

这段代码等价于之前的我们开始时编写的那段简单代码，但我们已改为在使用者需要时推送数据。你始终应该这样做。

#### 实现双向/变换流 ####

对于双向流，我们要在同一个对象上同时现实可读流和可写流。就好像是我们继承了两个接口。

以下的例子实现了一个综合了前面提到的可读流与可写流功能的双向流：

```js
const { Duplex } = require('stream');

const inoutStream = new Duplex({
  write(chunk, encoding, callback) {
    console.log(chunk.toString());
    callback();
  },

  read(size) {
    this.push(String.fromCharCode(this.currentCharCode++));
    if (this.currentCharCode > 90) {
      this.push(null);
    }
  }
});

inoutStream.currentCharCode = 65;

process.stdin.pipe(inoutStream).pipe(process.stdout);
```

通过组合这些方法，我们可以通过该双向流读取从 A 到 Z 的字母还可以利用它的回传特性。我们把可读的 `stdin` 流接入这个双向流以利用它的回传特性同时又把它接入可写的 `stdout` 流以查看字母 A 到 Z。

理解双向流的读取和写入部分是完全独立的这一点非常重要。它只不过是把两种特性在同一个对象上实现罢了。

变换流是一种更有趣的双向流，因为它的输出是基于输入运算得到的。

对于一个变换流，我们不需要实现 `read` 或 `write` 方法，而是只需要实现一个 `transform` 方法即可，它结合了二者的功能。它的函数签名和 `write` 方法一致，我们也可以通过它 `push` 数据。

以下是一个把你输入的任何内容转换为大写字母的变换流：

```js
const { Transform } = require('stream');

const upperCaseTr = new Transform({
  transform(chunk, encoding, callback) {
    this.push(chunk.toString().toUpperCase());
    callback();
  }
});

process.stdin.pipe(upperCaseTr).pipe(process.stdout);
```

在这个变换流中，我们只实现了 `transform()` 方法，却达到了前面双向流例子的效果。在该方法中，我们把 `chunk` 转换为大写然后通过 `push` 方法传递给下游。

#### 流对象模式 ####

默认情况下，流接收的参数类型为 Buffer/String。我们可以通过设置 `objectMode` 参数使得流可以接受任何 JavaScript 对象。

以下是一个简单的演示。以下变换流的组合用于把一个逗号分割的字符串转变成为一个 JavaScript 对象。传入 "a,b,c,d" 就变成了 `{a: b, c: d}`。

```js
const { Transform } = require('stream');
const commaSplitter = new Transform({
  readableObjectMode: true,
  transform(chunk, encoding, callback) {
    this.push(chunk.toString().trim().split(','));
    callback();
  }
});
const arrayToObject = new Transform({
  readableObjectMode: true,
  writableObjectMode: true,
  transform(chunk, encoding, callback) {
    const obj = {};
    for(let i=0; i < chunk.length; i+=2) {
      obj[chunk[i]] = chunk[i+1];
    }
    this.push(obj);
    callback();
  }
});
const objectToString = new Transform({
  writableObjectMode: true,
  transform(chunk, encoding, callback) {
    this.push(JSON.stringify(chunk) + '\n');
    callback();
  }
});
process.stdin
  .pipe(commaSplitter)
  .pipe(arrayToObject)
  .pipe(objectToString)
  .pipe(process.stdout)
```

我们给 `commaSplitter` 传入一个字符串（假设是 `"a,b,c,d"`），它会输出一个数组作为可读数据（`[“a”, “b”, “c”, “d”]`）。在该流上增加 `readableObjectMode` 标记是必须的，因为我们在给下游推送一个对象，而不是字符串。

我们接着把 `commaSplitter` 输出的数组传递给了 `arrayToObject` 流。我们需要设置 `writableObjectModel` 以便让该流可以接收一个对象。它还会往下游推送一个对象（输入的数据被转换成对象），这就是为什么我们还需要配置 `readableObjectMode` 标志位。最后的 `objectToString` 流接收一个对象但却输出一个字符串，因此我们只需配置 `writableObjectMode` 即可。传递给下游的只是一个普通字符串。

![](https://img11.360buyimg.com/uba/jfs/t5704/241/2983971686/10498/24064b45/59357c3aN4d192424.png)

以上实例代码的使用方法

#### Node 内置的变换流 ####

Node 内置了一些非常有用的变换流。这就是 zlib 和 crypto 流。

下面是一个组合了 `zlib.createGzip()` 和 `fs` 可读/可写流来压缩文件的脚本：

```js
const fs = require('fs');
const zlib = require('zlib');
const file = process.argv[2];

fs.createReadStream(file)
  .pipe(zlib.createGzip())
  .pipe(fs.createWriteStream(file + '.gz'));
```

你可以通过该脚本给任何参数中传入的文件进行 gzip 压缩。我们通过可读流读取文件内容传递给 zlib 内置的变换流，然后通过一个可写流来写入新文件。很简单吧。

使用管道很棒的一点在于，如果有必要，我们可以把它和事件组合使用。例如，我希望在脚本执行过程中给用户一些进度提示，在脚本执行完成后显示一条完成消息。既然 `pipe` 方法会返回下游流，我们就可以把注册事件回调的操作级联在一起：

```js
const fs = require('fs');
const zlib = require('zlib');
const file = process.argv[2];

fs.createReadStream(file)
  .pipe(zlib.createGzip())
  .on('data', () => process.stdout.write('.'))
  .pipe(fs.createWriteStream(file + '.zz'))
  .on('finish', () => console.log('Done'));
```

所以使用 `pipe` 方法，我们可以很简单的使用流。当需要时，我们还可以通过事件来进一步定制和流的交互。

`pipe` 方法的好处在于，我们可以用一种更加可读的方式通过若干片段**组合**我们的程序。例如，我们可以通过创建一个变换流来显示进度，而不是直接监听 `data` 事件。把 `.on()` 调用换成另一个 `.pipe()` 调用：

```js
const fs = require('fs');
const zlib = require('zlib');
const file = process.argv[2];

const { Transform } = require('stream');

const reportProgress = new Transform({
  transform(chunk, encoding, callback) {
    process.stdout.write('.');
    callback(null, chunk);
  }
});

fs.createReadStream(file)
  .pipe(zlib.createGzip())
  .pipe(reportProgress)
  .pipe(fs.createWriteStream(file + '.zz'))
  .on('finish', () => console.log('Done'));
```

这个 `reportProgress` 流是一个简单的直通流，但同时报告了进度信息。请注意我是如何在 `transform()` 方法中利用 `callback()` 的第二个参数传递数据的。它等价于使用 push 方法推送数据。

组合流的应用是无止境的。例如，假设我们需要在压缩文件之前或之后加密它，我们要做的只不过是在正确的位置引入一个新的变换流。我们可以使用 Node 内置的 `crypto` 模块：

```
**const crypto = require('crypto');
**// ...
```

```js
const crypto = require('crypto');
// ...
fs.createReadStream(file)
  .pipe(zlib.createGzip())
  .pipe(crypto.createCipher('aes192', 'a_secret'))
  .pipe(reportProgress)
  .pipe(fs.createWriteStream(file + '.zz'))
  .on('finish', () => console.log('Done'));

```

以上的脚本对给定的文件先压缩再加密，只有知道秘钥的人才能利用生成的文件。我们不能利用普通的解压工具解压该文件，因为它被加密了。

要能真正的解压任何使用以上脚本压缩过的文件，我们需要以相反的顺序利用 crypto 和 zlib：

```js
fs.createReadStream(file)
  .pipe(crypto.createDecipher('aes192', 'a_secret'))
  .pipe(zlib.createGunzip())
  .pipe(reportProgress)
  .pipe(fs.createWriteStream(file.slice(0, -3)))
  .on('finish', () => console.log('Done'));
```

假设传入的文件是压缩后的版本，以上的脚本会创建一个针对该文件的读取流，连接到一个 crypto 模块的 `createDecipher()` 流（使用相同的密钥），之后将输出传递给一个 zlib 模块的 `createGunzip()` 流，最后将得到的数据写入一个没有压缩文件扩展名的文件。

以上就是我关于本主题要讨论的全部内容了。感谢阅读！下次再见！

**如果你认为这篇文件对你有帮助，请点击下方的💚。关注我以获取更多关于 Node.js 和 JavaScript 的文章。**

我为 [Pluralsight](https://www.pluralsight.com/search?q=samer+buna&amp;categories=course) 和 [Lynda](https://www.lynda.com/Samer-Buna/7060467-1.html) 制作在线课程。我最近的课程是 [React.js 入门](https://www.pluralsight.com/courses/react-js-getting-started), [高级 Node.js](https://www.pluralsight.com/courses/nodejs-advanced), 和[学习全栈 JavaScript](https://www.lynda.com/Express-js-tutorials/Learning-Full-Stack-JavaScript-Development-MongoDB-Node-React/533304-2.html)。

我还进行**线上与现场培训**，内容涵盖 JavaScript，Node.js，React.js 和 GraphQL 从初级到高级的全部范围。如果你在寻找一名讲师，[请联系我](mailto:samer@jscomplete.com)。我将在今年七月份的 Foward.js 上进行 6 场现场讲习班，其中一场是 [Node.js 进阶](https://forwardjs.com/#node-js-deep-dive)

如果关于本文或任何我的其他文章有疑问，你可以通过[这个 **slack** 账号](https://slack.jscomplete.com/)找到我并在 #questions 房间里提问。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
