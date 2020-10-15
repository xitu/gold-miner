> * 原文地址：[Tutorial on Python Logging](https://levelup.gitconnected.com/tutorial-on-python-logging-ac5f21e0a00)
> * 原文作者：[Anuradha Wickramarachchi](https://medium.com/@anuradhawick)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/tutorial-on-python-logging.md](https://github.com/xitu/gold-miner/blob/master/article/2020/tutorial-on-python-logging.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[wangqinggang](https://github.com/wangqinggang)

# Python Logging 使用指南

![Photo by [Chris Ried](https://unsplash.com/@cdr6934?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/codes?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/12032/1*1X0-98EiQNkwBJj2vnTTqQ.jpeg)

对程序员来说，Logging 是一种非常重要的功能。无论调试程序还是程序运行时的信息显示，Logging 都很有用。在本文中，我会演示为什么要使用以及如何使用 Python 中的 Logging 模块。

## 为什么要使用 Logging 而不使用 print()

print 语句跟 Logging 输出存在本质上的不同。一般地，print 语句用于向 stdout（标准输出）写入有用的信息或程序需要输出的信息。然而 Logging 将这些信息写入 stderr（标准错误输出）。

```py
import logging

logging.basicConfig(level=logging.INFO) #We'll talk about this soon!

logging.warning('Something bad could happen!')
logging.info('You are running the program')
logging.error('Aw snap! Everything failed.')

print("This is the program output")
```

如果我运行这段程序，可以看到命令行输出了如下信息。

```
$ python log_test.py
WARNING:root:Something bad could happen!
INFO:root:You are running the program
ERROR:root:Aw snap! Everything failed.
This is the program output
```

然而对于普通用户来说，信息太多了。虽然这些都在命令行显示，但数据却被分开了。所以用户应当这样运行程序。

```
$ python log_test.py > program_output.txt
WARNING:root:Something bad could happen!
INFO:root:You are running the program
ERROR:root:Aw snap! Everything failed.

$ cat program_output.txt
This is the program output
```

在这里，需要输出的信息通过重定向符 > 写入到一个文件。所以我们能看到终端的运行情况，也可以方便地从文件中得到输出信息。现在我们来了解日志等级！

## Logging 和日志等级

需要使用 Logging 的原因各有不同。这些原因可以根据严重性的不同分为如下几类。

* **DEBUG**: 开发者调试信息，包括经计算得到的值、参数估值、URL、API 调用信息等。
* **INFO**: 一般性的信息。
* **WARNING**: 关于输入、参数等的警告。
* **ERROR**: 报告由于用户操作不当或程序运行时发生的错误。
* **CRITICAL**: 最高等级的日志输出，通常用于某些关键问题（取决于具体情况）。

最常用的日志类型有：**DEBUG**、**INFO** 和 **ERROR**。然而，经常会出现因 Python 版本不匹配抛出警告的情况。

## 配置 Logger 和日志处理程序

Logger 可以配置不同的参数，可以配置特定日志等级、日志文件名、文件模式和日志打印的输出格式。

#### 配置 Logger 的参数

Logger 可采用如下配置。

```py
import logging

logging.basicConfig(filename='program.log', filemode='w', level=logging.DEBUG)
logging.warning('You are given a warning!')
```

上面的代码向 program.log 文件输出日志。filemode='w' 用于设置文件读写模式。filemode='w' 表示需要打开一个新文件并覆盖原来的内容。该参数默认设置为 'a'，此时会打开相应文件，并追加日志内容，因为有时需要获取历史日志。表示等级的参数 level 用于确定日志的最低等级。例如，当设置 level 为 **INFO**，程序就不会输出 **DEBUG** 级别的日志。你可能知道，需要设置 'verbose=debug' 才能获取一些参数。日志等级默认为 **INFO**。

#### 创建日志处理器

虽然上述方法直接明了，满足了一个简单的应用程序的需求，但对于一个软件产品或服务来说，需要全面的日志处理流程。因为很难在数以百万计的 **DEBUG** 级日志中找到某个 **ERROR** 级日志。此外，在整个程序和模块中，我们应当使用单一的 Logger。这样我们就可以正确地把日志添加到同一文件中。所以我们可以使用具有不同配置的 Handler 来处理这种任务。

```py
import logging

logger = logging.getLogger("My Logger")
logger.setLevel(logging.DEBUG)

console_handler = logging.StreamHandler()
file_handler = logging.FileHandler('file.log', mode='w')
console_handler.setLevel(logging.INFO)
file_handler.setLevel(logging.DEBUG)

logger.addHandler(console_handler)
logger.addHandler(file_handler)
```

可以看出，我们首先通过名称获取到一个 Logger。以此可以在程序的其他任意地方使用同一个 Logger。我们把全局的 Logging 等级设为最低的 **DEBUG**，这样我们就可以在其他日志处理器中设置任意日志等级。

接着，我们创建两个日志处理器，分别用于 **console** 和 **file** 形式的输出，并设置各自的日志等级。这可以减少控制台输出的开销，转而在文件中输出。这方便了以后的调试。

## 对输出日志进行格式化

Logging 不是只用来打印我们自己的信息的。有时候我们需要打印其他信息，例如时间、日志等级、进程 ID。因此我们需要对日志进行格式化。我们来看下面的代码。

```py
console_format = logging.Formatter('%(name)s - %(levelname)s - %(message)s')
file_format = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')

console_handler.setFormatter(console_format)
file_handler.setFormatter(file_format)
```

添加 Handler 之前，我们可以像上面的代码那样设置日志输出的格式。可以用于设置日志格式的参数远不止这些，你可以访问(https://docs.python.org/3/library/logging.html#logrecord-attributes)获取详细资料。

## 可重用的代码

下面是我在许多应用程序中都用到的代码段。它可能会对你有所帮助。

```Python
import logging

logger = logging.getLogger('Program Name-Version')
logger.setLevel(logging.DEBUG)

formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')

consoleHeader = logging.StreamHandler()
consoleHeader.setFormatter(formatter)
consoleHeader.setLevel(logging.INFO)

fileHandler = logging.FileHandler(f"{output}/metabcc-lr.log")
fileHandler.setLevel(logging.DEBUG)
fileHandler.setFormatter(formatter)

logger.addHandler(fileHandler)
logger.addHandler(consoleHeader)
```

#### Logging 与多线程有关的特征

记住，Logging 模块是线程安全的。所以除了极少数例外情况（不在本文讨论范围内）使用 Logging 不需要为多线程编写额外的处理逻辑。

本文虽然短小、简单，但我也希望它对初级程序员有所帮助。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
