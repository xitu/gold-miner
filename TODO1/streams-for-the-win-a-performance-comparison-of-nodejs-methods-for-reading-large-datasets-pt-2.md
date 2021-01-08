> * 原文地址：[Streams For the Win: A Performance Comparison of NodeJS Methods for Reading Large Datasets (Pt 2)](https://itnext.io/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2-bcfa732fa40e)
> * 原文作者：[Paige Niedringhaus](https://medium.com/@paigen11)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/streams-for-the-win-a-performance-comparison-of-nodejs-methods-for-reading-large-datasets-pt-2.md)
> * 译者：[lucasleliane](https://github.com/LucaslEliane)
> * 校对者：[Ultrasteve](https://github.com/Ultrasteve)，[xilihuasi](https://github.com/xilihuasi)

# 胜者是 Stream：NodeJS 读取大数据集合几种方法的性能比较

## readFile()、createReadStream() 以及事件流如何相互比较

![](https://cdn-images-1.medium.com/max/2000/1*fsseXIPGEhwmg6kfgXyIjA.jpeg)

如果你一直在关注我的文章，你应该会看到我几周前发布的一篇[博客](https://juejin.im/post/5d4b99eb5188257bc15d299f)，这篇博客讨论了使用 Node.js 来读取大型数据集的各种方法。

令我惊讶的是，这篇博客受到了很多读者的喜爱 - 这个主题（对于我来说）似乎在很多其他的帖子、博客或者论坛上已经讨论过了，但是无论如何，它都吸引了很多人的关注。所以，感谢所有花时间来阅读这篇博客的读者！对此，我真的非常感激。

一位特别敏锐的读者（[Martin Kock](undefined)）甚至问到了解析文件到底需要多长时间。看起来他已经读懂了我的想法，因为这个系列文章的第二部分就和这个问题有关。

> 在这里，我将评估 Node.js 读取文件的三种不同方法，来确定哪一种方法性能最佳。

### 上一篇文章中的挑战

我不会详细介绍上一篇博客中的挑战和解决方案，因为你可以去阅读我的第一篇文章，在[这里](https://juejin.im/post/5d4b99eb5188257bc15d299f)可以了解所有细节，但是我会给你进行一下简单的介绍。

这个挑战是来自于 Slack 频道的人发布的一个编码挑战，要求读取一个非常大的数据集（总共大小超过 2.5 GB），解析数据并且提取各种信息。

这个挑战让程序员们打印出：

* 文件总行数，
* 第 432 和第 43243 行的中的名字，
* 每月捐款总数，
* 以及文件中最常见的名字和它出现的频率的计数。

这里是数据链接：​[https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip](https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip)

#### 三种小数据集场景下的解决方案

当我努力去实现处理大型数据集这个目标的过程中，我在 Node.js 中想到了三个解决方案。

**解决方案 1：[`fs.readFile()`](https://nodejs.org/api/fs.html#fs_fs_readfile_path_options_callback)**

第一个解决方案涉及到 Node.js 的 `fs.readFile()` 原生方法，包括读取整个文件，将其保存在内存中并且对整个文件执行操作，然后返回结果。至少对于较小的文件，这个方法是没问题的，但是当我使用最大的文件的时候，我的服务器崩溃了，并且抛出了一个 `heap out of memory` 错误。

**解决方案 2：[`fs.createReadStream()`](https://nodejs.org/api/fs.html#fs_fs_createreadstream_path_options) 以及 [`rl.readLine()`](https://nodejs.org/api/readline.html#readline_event_line)**

我的第二个解决方案还涉及了 Node.js 的另外几个方法：`fs.createReadStream()` 和 `rl.readLine()`。在这个方案中，文件可以通过 Node.js 的 `input` 流，进行流式传输，我们能够对每一行进行单独操作，然后在 `output` 流中将所有的结果拼在一起。同样，这种方案在较小的文件上能够很好地完成工作，但是一旦输入最大的文件，就会发生和方案 1 同样的错误。虽然 Node.js 正在对输入和输出进行流式传输，但是 Node.js 在执行操作的时候，仍然会试图将整个文件保存在内存中（并且无法一次处理整个文件）。

**解决方案 3：[`event-stream`](https://www.npmjs.com/package/event-stream)**

最后，我想到了在 Node.js 中唯一能够处理完整的 2.55 GB 的文件的解决方案。

> 有趣的是：Node.js 在任何时候，都只能够在内存中容纳 1.67 GB，之后就会抛出 JavaScript 的 `heap out of memory` 错误。

我的解决方案涉及到一个流行的名为 [event-stream](https://www.npmjs.com/package/event-stream) 的 NPM 包，这个包允许我对数据的整个**吞吐流**执行操作，而不仅仅是原生 Node.js 提供的输入和输出流操作。

你可以在 Github 中的[这里](https://github.com/paigen11/file-read-challenge)找到我的三个解决方案。

我完成了我最初的目标，解决了这个问题，但是这个问题还是让我陷入了思考：我的解决方案真的是三个方案中最高效的吗？

### 比较，并且找到最优的解决方案

现在，我有了一个新的目标：确定哪种解决方案是最好的。

由于我没有办法使用原生 Node.js 的方案来处理完整的 2.55 GB 大小的文件，因此我选择使用一个较小的文件，这些文件大约有 400 MB 的数据，我在实现解决方案的时候，使用这个数据集来进行测试。

对于 Node.js 性能测试，我发现了两种跟踪文件和函数处理时间的方法，我决定将两者结合起来看看这两种方法之间的差异有多大（并且确保我测试出来的时间不会完全偏离事实）。

**[`console.time()`](https://nodejs.org/api/console.html#console_console_time_label) 和 [`console.timeEnd()`](https://nodejs.org/api/console.html#console_console_timeend_label)**

Node.js 有一些方便的内置方法，可以用于定时和性能测试，分别是 `console.time()` 和 `console.timeEnd()`。要使用这些方法，我只需要为 `time()` 和 `timeEnd()` 传递相同的 label 参数，就像下面这样，Node 就会在函数执行完成之后，输出两者之间的时间差。

```js
// 定时器启动
console.time('label1');

// 执行自定义函数
doSomething();

// 定时器结束，会打印出来定时器启动和结束之间的时间差
console.timeEnd('label1');

// 输出的结果类似于这样: label1 0.002ms
```

这是我用来计算处理数据集所需时间的一种方法。

[**`performance-now`**](https://www.npmjs.com/package/performance-now)

另外，我还发现了一个久经考验并且广受欢迎的 Node.js 性能测试模块，这个模块是 [`performance-now`](https://www.npmjs.com/package/performance-now)，它被托管在 NPM 上面。

这个模块在 NPM 上面每周都有着 700 多万的下载量，不会错的，对吧？

将 `performance-now` 模块引入到我的文件中，几乎和原生 Node.js 方法一样简单。导入模块，设置方法执行开始和执行结束的结果设置变量，并且计算两者之间的时间差。

```js
// 在文件开头导入 performance-now 模块
const now = require('performance-now');

// 为定时器的起始状态设置变量
const start = now();

// 执行自定义函数
doSomething();

// 为定时器的结束状态设置变量
const end = now();

// 计算定时器起始和结束的时间差
console.log('Performance for timing for label:' + (end — start).toFixed(3) + 'ms';

// 打印出的结果类似于这样: Performance for timing label: 0.002ms
```

我想同时使用 Node 的 `console.time()` 和 `performance-now`，我可以规避差异并且获得关于文件解析函数真正的执行时间的准确值。

下面是我在每个脚本中接入 `console.time()` 以及 `performance-now` 的代码片段。这些代码只是每个函数的片段 - 如果你想看全部代码，你可以在[这里](https://github.com/paigen11/file-read-challenge)查看我的代码仓库。

**fs.readFile() 代码实现示例**

![](https://cdn-images-1.medium.com/max/2568/1*n48UZ77lvktwjN6IDR0x1g.png)

由于这个脚本使用 `fs.readFile()` 实现，整个文件都会在执行函数之前被读取到内存中，这看起来很像同步代码。但是它实际上不是同步的，同步地读取文件在 Node 中有一个专用的方法，叫做 `fs.readFileSync()`，两者看起来很相似。

但是，我们很容易看到文件的总行数以及两个计时器方法，来确定执行行计数到底花费了多长时间。

**fs.createReadStream() 代码实现示例**

**输入流（按行读取）：**

![](https://cdn-images-1.medium.com/max/2568/1*XwIXtNCMSmCJBu7DX4zxGA.png)

**输出流（输入时一次性读取完整文件）：**

![](https://cdn-images-1.medium.com/max/2568/1*rhhHpFIS5b-UdluXYgLaIg.png)

由于第二个解决方案使用了 `fs.createReadStream()`，其涉及到了为文件创建输入输出流，所以我将代码片段分成了两个独立的截图，第一个是输入流（逐行进行文件读取）以及第二个输出流（计算所有的结果数据）。

**事件流代码示例**

**输入流（同样是逐行）**

![](https://cdn-images-1.medium.com/max/2568/1*UzzXjaStCYMgUHHE_qBiqw.png)

**流结束：**

![](https://cdn-images-1.medium.com/max/2568/1*rgZQKTXROxXn6T9Gmqc0oA.png)

`event-stream` 的解决方案看起来和 `fs.createReadStream()` 非常相似，除了**输入流**，在这个解决方案中，数据通过**吞吐流**来进行处理。然后，一旦整个文件被读取并且所有计算都已经完成，则表示流程结束，并且打印出所需要的信息。

### 结果

现在，来看看我们一直期待的：结果。

我针对相同的 400 MB 大小的数据集运行了全部三种解决方案，其中包含了需要解析的将近 200 万条记录。

![Streams for the win!](https://cdn-images-1.medium.com/max/4056/1*K3fMjpvkyTMccexwsa3gjw.png)

从表中可以看出，`fs.createReadStream()` 和 `event-stream` 都表现很好，但是总的来说，`event-stream` 是我心目中的大赢家，因为相比起 `fs.readFile()` 或者 `fs.createReadStream()` 来说，它可以处理的文件大小要大得多。

提升的百分比也在表格最后展示出来了。

`fs.readFile()` 被竞争对手们完全击败了。通过流来传输数据，文件的处理时间提高了至少 78% - 有时接近 100%，这让人印象非常深刻。

以下是执行每个解决方案的终端截图。

**解决方案 1： [`fs.readFile()`](https://nodejs.org/api/fs.html#fs_fs_readfile_path_options_callback)**

![仅使用 fs.readFile()](https://cdn-images-1.medium.com/max/2000/1*luMWmrPikShHXtu6yScO9g.png)

**解决方案 2： [fs.createReadStream()](https://nodejs.org/api/fs.html#fs_fs_createreadstream_path_options) & [rl.readLine()](https://nodejs.org/api/readline.html#readline_event_line)**

![使用 fs.createReadStream() 和 rl.readLine()](https://cdn-images-1.medium.com/max/2000/1*rhF6hIxI7aE3VsMubmVUOQ.png)

**解决方案 3： [`event-stream`](https://www.npmjs.com/package/event-stream)**

![使用 event-stream](https://cdn-images-1.medium.com/max/2000/1*WzQIXZKNvGfrZzXtEP_31g.png)

**另外**

这里是我的 `event-stream` 解决方案的屏幕截图，同时也是在遍历 2.55 GB 的超大文件。这里是解析 400 MB 文件和 2.55 GB 文件之间的时间差。

![看看这超快的速度，即使文件大小增加了近 6 倍](https://cdn-images-1.medium.com/max/2548/1*Zxbn3FCHM59DrDvY7P6bXg.png)

**解决方案 3： [`event-stream`](https://www.npmjs.com/package/event-stream)（处理 2.55 GB 文件）**

![](https://cdn-images-1.medium.com/max/2000/1*v-7OzvyTjFTjrxnO0rXYiA.png)

#### 结论

最后，流式处理，不论是 Node.js 原生的亦或是非原生的，在处理大型数据集的时候都会更加有效。

感谢你继续阅读了本系列文章的第二部分。如果你想要再次阅读第一篇文章，可以看[这里](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33)。

我将在几周后回到新的 JavaScript 主题 - 可能是 Node 中的代码调试或者是使用 Puppeteer 和 Chrome 来进行端到端测试，所以请关注我来获取更多内容。

感谢你的阅读，我希望这篇文章能够让你了解如何有效地处理 Node.js 的大型数据集并且对你的方案进行性能测试。非常感谢你的关注和点赞。

**如果你喜欢这篇文章，你也许也会喜欢我的其他博客：**

* [使用 Node.js 读取超大的数据集和文件（第一部分）](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33)
* [Sequelize：Node.js 的数据库 ORM 工具](https://medium.com/@paigen11/sequelize-the-orm-for-sql-databases-with-nodejs-daa7c6d5aca3)
* [为什么 Spring Cloud Config Server 是一个好的 CI/CD 流的关键以及如何去进行配置（第一部分）](https://medium.com/@paigen11/why-a-cloud-config-server-is-crucial-to-a-good-ci-cd-pipeline-and-how-to-set-it-up-pt-1-fa628a125776)

---

**引用及继续阅读：**

* Github, Read File Repo: [https://github.com/paigen11/file-read-challenge](https://github.com/paigen11/file-read-challenge)
* Node.js Documentation, File System: [https://nodejs.org/api/fs.html](https://nodejs.org/api/fs.html)
* Node.js Documentation, Console.Time: [https://nodejs.org/api/console.html#console_console_time_label](https://nodejs.org/api/console.html#console_console_time_label)
* NPM, Performance Now: [https://www.npmjs.com/package/performance-now](https://www.npmjs.com/package/performance-now)
* NPM, EventSream: [https://www.npmjs.com/package/event-stream](https://www.npmjs.com/package/event-stream)
* Link to the FEC data: [https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip](https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
