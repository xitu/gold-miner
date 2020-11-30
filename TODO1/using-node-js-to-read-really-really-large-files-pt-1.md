> * 原文地址：[Using Node.js to Read Really, Really Large Files (Pt 1)](https://itnext.io/using-node-js-to-read-really-really-large-files-pt-1-d2057fe76b33)
> * 原文作者：[Paige Niedringhaus](https://medium.com/@paigen11)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-node-js-to-read-really-really-large-files-pt-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-node-js-to-read-really-really-large-files-pt-1.md)
> * 译者：[lucasleliane](https://github.com/lucasleliane)
> * 校对者：[sunui](https://github.com/sunui)，[Jane Liao](https://github.com/JaneLdq)

# 使用 Node.js 读取超大的文件（第一部分）

![](https://cdn-images-1.medium.com/max/3686/1*-Nq1fQSPq9aeoWxn4WFbhg.png)

这篇博文有一个非常有趣的启发点。上周，某个人在我的 Slack 频道上发布了一个编码挑战，这个挑战是他在申请一家保险技术公司的开发岗位时收到的。

这个挑战激起了我的兴趣，这个挑战要求读取联邦选举委员会的大量数据文件，并且展示这些文件中的某些特定数据。由于我没有做过什么和原始数据相关的工作，并且我总是乐于接受新的挑战，所以我决定用 Node.js 来解决这个问题，看看我是否能够完成这个挑战，并且从中找到乐趣。

下面是提出的四个问题，以及这个程序需要解析的数据集的链接。

* 实现一个可以打印出文件总行数的程序。
* 注意，第八列包含了人的名字。编写一个程序来加载这些数据，并且创建一个数组，将所有的名字字符串保存进去。打印出第 432 个以及第 43243 个名字。
* 注意，第五列包含了格式化的时间。计算每个月的捐赠数，并且打印出结果。
* 注意，第八列包含了人的名字。创建一个数组来保存每个 first name。标记出数据中最常使用的 first name，以及其出现的次数。

数据的链接：[https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip](https://www.fec.gov/files/bulk-downloads/2018/indiv18.zip)

当你解压完这个文件夹，你可以看到一个大小为 2.55 GB 的 `.txt` 主文件，以及一个包含了主文件部分数据的文件夹（这个是我在跑主文件之前，用来测试我的解决方案的）。

不是非常可怕，对吧？似乎是可行的。所以让我们看看我是怎么实现的。

#### 我想出来的两个原生 Node.js 解决方案

处理大型文件对于 JavaScript 来说并不是什么新鲜事了，实际上，在 Node.js 的核心功能当中，有很多标准的解决方案可以进行文件的读写。

其中，最直接的就是 [`fs.readFile()`](https://nodejs.org/api/fs.html#fs_fs_readfile_path_options_callback)，这个方法会将整个文件读入到内存当中，然后在 Node 读取完成后立即执行操作，第二个选择是 [`fs.createReadStream()`](https://nodejs.org/api/fs.html#fs_fs_createreadstream_path_options)，这个方法以数据流的形式处理数据的输入输出，类似于 Python 或者是 Java。

#### 我使用的解决方案以及我为什么要使用它

由于我的解决方案涉及到计算行的总数以及解析每一行的数据来获取捐赠名和日期，所以我选择第二个方法：`fs.createReadStream()`。然后在遍历文件的时候，我可以使用 [`rl.on('line',...)`](https://nodejs.org/api/readline.html#readline_event_line) 函数来从文件的每一行中获取必要的数据。

对我来说，这比将整个文件读入到内存中，然后再逐行读取更加简单。

#### Node.js CreateReadStream() 和 ReadFile() 代码实现

下面是我用 Node.js 的 `fs.createReadStream()` 函数实现的代码。我会在下面将其分解。

![](https://cdn-images-1.medium.com/max/2704/1*szFus-f7Xllx17AuSc_TQw.png)

我所要做的第一件事就是从 Node.js 中导入需要的函数：`fs`（文件系统），`readline`，以及 `stream`。导入这些内容后，我就可以创建一个 `instream` 和 `outstream` 然后调用 `readLine.createInterface()`，它们让我可以逐行读取流，并且从中打印出数据。

我还添加了一些变量（和注释）来保存各种数据：一个 `lineCount`、`names` 数组、`donation` 数组和对象，以及 `firstNames` 数组和 `dupeNames` 对象。你可以稍后看到它们发挥作用。

在 `rl.on('line',...)`函数里面，我可以完成数据的逐行分析。在这里，我为数据流的每一行都进行了 `lineCount` 的递增。我用 JavaScript 的 `split()` 方法来解析每一个名字，并且将其添加到 `names` 数组当中。我会进一步将每个名字都缩减为 first name，同时在 JavaScript 的 `trim()`，`includes()` 以及 `split()` 方法的帮助下，计算 middle name 的首字母，以及名字出现的次数等信息。然后我将时间列的年份和时间进行分割，将其格式化为更加易读的 `YYYY-MM` 格式，并且添加到 `dateDonationCount` 数组当中。

在 `rl.on('close',...)` 函数中，我对我收集到数组中的数据进行了转换，并且在 `console.log` 的帮助下将我的所有数据展示给用户。

找到第 432 个以及第 43243 个下标处的 `lineCount` 和 `names` 不需要进一步的操作了。而找到最常出现的名字和每个月的捐款数量比较棘手。

对于最常见的名字，我首先需要创建一个键值对对象用于存储每个名字（作为 key）和这个名字出现的次数（作为 value），然后我用 ES6 的函数 `Object.entries()` 来将其转换为数组。之后再对这个数组进行排序并且打印出最大值，就是一件非常简单的事情了。

获取捐赠数量也需要一个类似的键值对对象，我们创建一个 `logDateElements()` 函数，我们可以使用 ES6 的字符串插值来展示每个月捐赠数量的键值。然后，创建一个 `new Map()` 将 `dateDonations` 对象转换为嵌套数组，并且对于每个数组元素调用 `logDateElements()` 函数。呼！并不像我开始想的那么简单。

至少对于我测试用的 400 MB 大小的文件是奏效的……

在用 `fs.createReadStream()` 方法完成后，我回过头来尝试使用 `fs.readFile()` 来实现我的解决方案，看看有什么不同。下面是这个方法的代码，但是我不会在这里详细介绍所有细节。这段代码和第一个代码片十分相似，只是看起来更加同步（除非你使用 `fs.readFileSync()` 方法，但是不用担心，JavaScript 会和运行其他异步代码一样执行这段代码）。

![](https://cdn-images-1.medium.com/max/2704/1*mLYx43qMKJBpbZ8TUp_qrA.png)

如果你想要看我的代码的完整版，可以在[这里](https://github.com/paigen11/file-read-challenge)找到。

#### Node.js 的初始结果

使用我的解决方案，我将传入到 `readFileStream.js` 的文件路径替换成了那个 2.55 GB 的怪物文件，并且看着我的 Node 服务器因为 `JavaScript heap out of memory` 错误而崩溃。

![Fail. Whomp whomp…](https://cdn-images-1.medium.com/max/5572/1*S26hQHQCuzlPDHMnDR_s3g.png)

事实证明，虽然 Node.js 采用流来进行文件的读写，但是其仍然会尝试将整个文件内容保存在内存中，而这对于这个文件的大小来说是无法做到的。Node 可以一次容纳最大 1.5 GB 的内容，但是不能够再大了。

因此，我目前的解决方案都不能够完成这整个挑战。

我需要一个新的解决方案。一个基于 Node 的，能够处理更大的数据集的解决方案。

#### 新的数据流解决方案

[`EventStream`](https://www.npmjs.com/package/event-stream) 是一个目前很流行的 NPM 模块，它每周有超过 200 万的下载量，号称能够“让流的创建和使用更加简单”。

在 EventStream 文档的帮助下，我再次弄清楚了如何逐行读取代码，并且以更加 CPU 友好的方式来实现。

#### EventStream 代码实现

这个是我使用 EventStream NPM 模块实现的新代码。

![](https://cdn-images-1.medium.com/max/2704/1*iZFzB0v46FoAaMTR0ANrCQ.png)

最大的变化是以文件开头的管道命令 —— 所有这些语法，都是 EventStream 文档所建议的方法，通过 `.txt` 文件每一行末尾的 `\n` 字符来进行流的分解。

我唯一改变的内容是修改了 `names` 的结果。我不得不实话实说，因为我尝试将 1300 万个名字放到数组里面，结果还是发生了内存不足的问题。我绕过了这个问题，只收集了第 432 个和第 43243 个名字，并且将它们加入到了它们自己的数组当中。并不是因为其他什么原因，我只是想有点自己的创意。

#### Node.js 和 EventStream 的实现成果：第二回合

好了，新的解决方案实现好了，又一次，我使用 2.55 GB 的文件启动了 Node.js，同时双手合十起到这次能够成功。来让我们看看结果。

![Woo hoo!](https://cdn-images-1.medium.com/max/2000/1*HJBlTYxNUCPXCDeKI9RTMg.png)

成功了！

#### 结论

最后，Node.js 的纯文件和大数据处理功能与我需要的能力还有些差距，但是只要使用一个额外的 NPM 模块，比如 EventStream，我就能够解析巨大的数据而不会造成 Node 服务器的崩溃。

请继续关注本系列的[第二部分](https://bit.ly/2JdcO2g)，我对在 Node.js 中读取数据的三种方式的性能进行了测试和比较，看看哪一种方式的性能能够优于其他方式。结果变得非常瞩目 —— 特别是随着数据量的变大……

感谢你的阅读，我希望本文能够帮助你了解如何使用 Node.js 来处理大量数据。感谢你的点赞和关注！

**如果您喜欢阅读本文，你可能还会喜欢我的其他一些博客：**

* [Postman vs. Insomnia：API 测试工具的比较](https://medium.com/@paigen11/postman-vs-insomnia-comparing-the-api-testing-tools-4f12099275c1)
* [如何使用 Netflix 的 Eureka 和 Spring Cloud 来进行服务注册](https://medium.com/@paigen11/how-to-use-netflixs-eureka-and-spring-cloud-for-service-registry-8b43c8acdf4e)
* [Jib：在不了解 Docker 的情况下得到专家级的 Docker 成果](https://medium.com/@paigen11/jib-getting-expert-docker-results-without-any-knowledge-of-docker-ef5cba294e05)

---

**引用和继续阅读资源：**

* Node.js 文档，文件系统：[https://nodejs.org/api/fs.html](https://nodejs.org/api/fs.html)
* Node.js 文档，Readline：[https://nodejs.org/api/readline.html#readline_event_line](https://nodejs.org/api/readline.html#readline_event_line)
* Github, Read File Repo：[https://github.com/paigen11/file-read-challenge](https://github.com/paigen11/file-read-challenge)
* NPM, EventSream：[https://www.npmjs.com/package/event-stream](https://www.npmjs.com/package/event-stream)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
