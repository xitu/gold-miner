> * 原文地址：[Which Should You Use: Asynchronous Programming or Multi-Threading?](https://medium.com/better-programming/which-should-you-use-asynchronous-programming-or-multi-threading-7435ec9adc8e)
> * 原文作者：[Patrick Collins](https://medium.com/@patrick.collins_58673)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/which-should-you-use-asynchronous-programming-or-multi-threading.md](https://github.com/xitu/gold-miner/blob/master/article/2020/which-should-you-use-asynchronous-programming-or-multi-threading.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[QinRoc](https://github.com/QinRoc)、[PingHGao](https://github.com/PingHGao)

# 异步编程和多线程，我该选择哪个方案？

![Image source: Author](https://cdn-images-1.medium.com/max/4608/1*G-JcOwcbJfFe70evn2FoNA.png)

在软件工程中，这两个概念经常容易搞混。它们都是实现[并发](https://en.wikipedia.org/wiki/Concurrency_(computer_science))的方案，但它们是不同的技术，而且使用方式和应用场景也不同。

关于它们之间区别的简单解释是[线程是相对于具体实现而言的；异步编程是针对于具体任务而言的](https://stackoverflow.com/questions/34680985/what-is-the-difference-between-asynchronous-programming-and-multithreading)。下面我们来深入探讨一下。

假设现在要做一份鸡蛋吐司的早餐。我们该如何下手？

## 同步的方案

最简单的方法是依次执行：

1.取出鸡蛋，面包和锅，然后打开炉子。
2.弄碎鸡蛋并将其倒入锅中。
3.等待鸡蛋煎好。
4.取出鸡蛋并加入调味料。
5.将面包放入烤面包机。
6.等待烤面包机烤完。
7.拿出烤面包。

制作早餐的总时间：15 分钟。

很简单吧？如果我们以这种烹饪方式来类比程序执行，它就是用一种[同步的方式](https://stackoverflow.com/questions/748175/asynchronous-vs-synchronous-execution-what-does-it-really-mean)来做早餐。

我们用一个人（[串行](https://en.wikipedia.org/wiki/Serialism)）地完成一系列任务。我们按顺序执行每个步骤，如果没有完成正在执行的任务，就无法继续进行下一步。从技术上来说，更严格的定义是，每个任务在执行前都会被上一个任务挂起，所有的任务都只由一个工作单元完成。不完成上一个任务，我们就无法前进。在此示例中，我们是计算机的 [CPU](https://en.wikipedia.org/wiki/Central_processing_unit)。每个任务都由一个人（一个 CPU）完成。

![Single-threaded synchronous way to cook breakfast](https://cdn-images-1.medium.com/max/4608/1*tqb0_sHBGF4TlSWPDY7j7w.png)

好了，我们已经煎好鸡蛋了。但是，如果我们想让早晨的效率更高，该怎么办呢？您可能会说：“我不用等我的鸡蛋煎完才去烤面包。”

您现在已经像工程师一样思考了。让我们再来做一次早餐，但是这次，我们要同时煎鸡蛋和烤面包。

## 异步的方案

我们仍然可以让一个人做所有事情，但是在等待一个任务完成时，我们可以开始执行另一个任务。步骤如下：

1. 取出鸡蛋，面包和锅，然后打开炉子。
2. 弄碎鸡蛋并将其倒入锅中。
3. 等待鸡蛋煎好。
4. 将面包放入烤面包机。
5. 等待烤面包机烤完。
6. **鸡蛋煎熟**后，取出鸡蛋，然后添加调味料。
7. **面包烤熟**后，取出烤面包。

制作早餐的总时间：8 分钟。

看起来所有步骤都没变，是吧？但是其中有一个步骤做了重大调整。在等待鸡蛋煎好的过程中，我们就开始烤面包，而不是得等鸡蛋煎好后才烤面包。我们仍然只需一名工人来完成所有任务，但是现在任务是异步进行的。可能只让两个任务异步执行效果没那么明显，想象一下，如果有几千个鸡蛋和面包以及几千个煎锅和几千台烤面包机，同一时间只执行一个任务是多么低效！

这是[异步](https://en.wikipedia.org/wiki/Asynchrony_(computer_programming))编程的最大优势之一。很多时候，我们不得不去等待一个无法控制的动作完成。在本例中，等待的是煎好鸡蛋和烤熟面包。我们可以有世界上最高效，最好的厨师，但是在大多数情况下，我们还是要坐等蛋煎好。等待这些东西烹饪的过程类似于等待[输入/输出 (I/O)](https://en.wikipedia.org/wiki/Input/output)操作，如果我们在执行任务时需要等待大量 I/O 操作，那么使用异步编程确实是一个好的方案。

如果我们调用一个必须从用户那里获得输入的 API ，无论我们拥有多少处理器或者多快的计算机，我们都必须等待。我们必须等待 API 调用完成，等待用户输入完信息。这个过程我们无法控制的，它不会因为处理器越来越快或分配专用资源而发生改变。

![Single-threaded asynchronous way to cook breakfast](https://cdn-images-1.medium.com/max/4608/1*WXtQa9WJYl96TjkCB2Fu9w.png)

现在我们已经有两种制作鸡蛋的方法。但是，假如我们的室友凯文（Kevin）想帮忙做鸡蛋。这次我们采用什么方案呢？

## 多线程的方案

1.取出鸡蛋，面包和锅，然后打开炉子。
2.弄碎鸡蛋并将其倒入锅中。 **1. 凯文将面包放进烤面包机。**
3.等待鸡蛋煎好。 **2. 凯文等待面包烤完。**
4.取出鸡蛋并加入调味料。 **3. 凯文拿出面包。**

制作早餐的总时间：8 分钟。

我们有两个人做早餐，每个人分配一个任务序列。这是[多线程](https://en.wikipedia.org/wiki/Multithreading_(computer_architecture))同步的示例，因为您和 Kevin 都不会在同一时刻执行多个任务（包括等待）。

在计算机科学中，一个进程可以有一个或多个线程。在本例中，我们有两个线程（人员）。您可以在[这里](https://www.computerhope.com/jargon/t/thread.htm)进一步了解什么是线程。

您可能会说：“好吧，如果周围有两个人，我就只能和两个人一起做早餐。”计算机也一样。只有当计算机有足够的资源时，您才能使用多线程。它通常是完成某些复杂度高的、需要更多资源的任务。

![Multi-threaded synchronous way to cook breakfast](https://cdn-images-1.medium.com/max/4608/1*qQOr-cdzcg2S3bqQLMjcvg.png)

[哪种方案更好](https://www.quora.com/What-is-the-difference-between-asynchronous-programming-and-multi-threading)，多线程还是异步？这取决于很多因素，如果您了解它们的工作原理，就应该知道使用哪种方案。[如果有很多 I/O，也许应该用异步。如果有密集计算，也许应该用多线程。](https://stackify.com/when-to-use-asynchronous-programming/) 编写多线程程序要比编写异步程序要容易得多，但你要记住，编写难度取决于编程语言。我们可以实现一个[多线程异步系统](https://codewala.net/2015/07/29/concurrency-vs-multi-threading-vs-asynchronous-programming-explained/)吗？当然可以！这两者可以联合使用。

## Python 示例

我们来看看上面的三个示例（单线程同步，单线程异步和多线程同步）如何在 Python 中实现。

我们用不同的方法从 [Alpha Vantage](https://www.alphavantage.co/) API 获取股票数据。你可以使用 Python 包装器 `pip install alpha_vantage` 来安装。

#### 同步

我们将获取四种代号为 'AAPL'，'GOOG'，'TSLA'，'MSFT' 的股票的当前价格，并且在获取全部数据时打印出来。最简单的方法是使用 `for` 循环。

```Python
from alpha_vantage.timeseries import TimeSeries
key = 'API_KEY'
symbols = ['AAPL', 'GOOG', 'TSLA', 'MSFT']
results = []
for symbol in symbols:
    ts = TimeSeries(key = key)
    results.append(ts.get_quote_endpoint(symbol))
print(results)
```

这是最暴力的方式。当我们调用 API 获得一个值（在 `ts.get_quote_endpoint（symbol)` 中完成）时，就将其打印出来，然后开始获取下一个股票数据。

但是在学习了异步和多线程之后，我们知道可以在等待返回值的同时启动另一个 API 调用。

#### 异步

```Python
import asyncio
from alpha_vantage.async_support.timeseries import TimeSeries
symbols = ['AAPL', 'GOOG', 'TSLA', 'MSFT']
async def get_data(symbol):
    ts = TimeSeries()
    data, _ = await ts.get_quote_endpoint(symbol)
    await ts.close()
    return data
loop = asyncio.get_event_loop()
tasks = [get_data(symbol) for symbol in symbols]
group1 = asyncio.gather(*tasks)
results = loop.run_until_complete(group1)
print(results)
```

在 Python 中，我们有关键字 `await` 和 `async`，它们为我们提供了异步编程的新功能。这些是自 Python 3.5 以来的新功能，如果您仍在使用 Python 2，则需要进行更新，因为很多 Python 2 的功能都过时了。

这里代码的调用可能有些混乱，我们来分解一下。`loop` 是处理器在等待任务和执行其他任务之间不断循环的地方。这是为了持续检查任务（例如我们的 API 调用）是否完成。

tasks 变量是方法调用的列表。我们将这些任务放在收集异步任务的列表中，称为 `group1`，然后在 `loop.run_until_complete` 中运行它们。这比我们之前的同步版本快得多，因为我们可以进行多个 API 调用，而无需等待每个 API 完成。

注意：Python 文档对 Asyncio 的说明有很多奇怪的地方，[这里有更多详情](https://stackoverflow.com/questions/47518874/how-do-i-run-python-asyncio-code-in-a-jupyter-notebook)。

#### 多线程

我已经写过一些有关多线程的文章，如果您想学习更多并查看 Python 示例，请[点击此链接](https://medium.com/alpha-vantage/data-is-taking-to-long-to-get-back-d48e3bf8f59b)！

---

我们还有更多的知识需要学习，例如什么是并行性，每个应用程序之间通信的底层原理是什么，如何同步线程，通道以及如何用不同的编程语言来实现它们。

如果您觉得我讲漏了或者有什么不懂的，您可以在下面留下问题，评论或见解！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
