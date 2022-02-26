> * 原文地址：[Speed Up Your Python Code With 100% Thread Utilization Using This Library](https://betterprogramming.pub/speed-up-your-python-code-with-100-thread-utilization-using-this-library-31378a45f0ec)
> * 原文作者：[Haseeb Kamal](https://medium.com/@haseebkamal98)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/speed-up-your-python-code.md](https://github.com/xitu/gold-miner/blob/master/article/2022/speed-up-your-python-code.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[samyu2000](https://github.com/samyu2000)、[jjCatherine](https://github.com/xyj1020)

# 使用 FastAPI 提升 Python 代码的运行性能

![](https://miro.medium.com/max/1400/0*oZRuzTJK7hDpZ_-E)

Python 有很多 web 框架，最流行的是 Django 和 Flask。我最熟悉的是Flask，我经常使用它来做一些业余项目，同时提升编码技能。

然而，随着技术的发展，新的框架也不断涌现。作为一个程序员，有必要了解最先进的技术，跟上时代发展的步伐。

[FastAPI](https://fastapi.tiangolo.com/) 是一个 Python Web 框架，在很多方面和简易的 Flask 类似。FastAPI 的不同之处在于，它可以在 ASGI 网络服务器（如 uvicorn）上运行，而 Flask 只能在 WSGI 网络服务器上运行。这种差异会导致两者的性能相差甚远。

使用 ASGI 是大势所趋，你很有必要了解它。使用 FastAPI 和 ASGI，能够非常容易地开发高性能的 Python 应用程序。本文将教你基于 FastAPI 框架开发一个简单的 API，然后将把它与 Flask 进行比较，看下 FastAPI 到底有多快。

让我们开始吧！

首先，简单介绍一下 WSGI 与 ASGI。

## WSGI 与 ASGI

WSGI 是 Web Server Gateway Interface 的缩写。简单地说，WSGI 位于 web 服务器（如 nginx）和 Python 的 web 框架（如 Flask）之间。它指定了 web 服务器应该如何将请求转发给 web 框架。WSGI 于 2003 年首次发布，你可以想象它有多老。WSGI 本质上是同步的，这可能会导致执行缓慢。

ASGI 是 Asynchronous Server Gateway Interface 的缩写。如今的发展趋势是 ASGI 将取代 WSGI。这两者之间的关键区别在于，ASGI 支持具有异步代码的 web 框架。也就是说，它本身就是异步的。如果你的代码是异步执行的（例如使用 `async await`），执行速度也会加快。

感到困惑吗？不用担心。我来说明一下同步和异步执行之间的区别，如图所示：

![](https://miro.medium.com/max/1400/0*s2OdGt1kp2_3FNVR.png)

> 同步与异步的运行方式对比。请注意，异步执行可以节省大量时间。

可以看到，在同步执行模式（WSGI）中，一个线程一次只能处理一个请求。因此，如果执行当前请求的过程中发生阻塞，需要等待一些执行结果，就会浪费很多时间（如上图中的等待块）。只有当整个任务 A 完成后，线程才能开始执行任务 B。

另一方面，在异步执行模式（ASGI）中，一个线程可以处理多个请求。当执行任务 A 时，线程可以跳到任务 B 上，在任务 A 等待的时间内完成任务 B，然后线程再跳回任务 A 并完成它。从上图中，我们可以看到，通过这种异步执行的方式，可以节省大量的时间。更重要的是，通过异步执行，我们充分的利用了线程，这意味着等待时间的减少，从而可以执行更多的任务。这极大提升了应用程序的性能。

简而言之：通过异步代码，线程可以在相同的时间内做更多的工作。应用程序在单位时间内完成更多工作，性能提升就来源于此。

## 对比分析

从理论上来说确实可行，但是能有一个说明性能差异的真实示例会更有趣。

首先安装 FastAPI 库：

```
pip3 install fastapi[all]
```

基于 FastAPI，编写以下代码：

```python
import os
from fastapi import FastAPI
import time
import pandas as pd
import pickle
import os
import asyncio
from concurrent.futures import ThreadPoolExecutor
import asyncio
import threading

app = FastAPI()

# @app.on_event("startup")
# async def startup_event():
#     loop = asyncio.get_running_loop()
#     loop.set_default_executor(ThreadPoolExecutor(max_workers=1))

@app.get("/dummy")
async def dummy():
    print(threading.active_count())
    return {"message": "async power"}

@app.get("/")
async def func():
    await helper()
    return {"message": "done"}

async def helper():
    await asyncio.sleep(20)
    # time.sleep(20)
    return heavy_func()

def heavy_func():
    # do stuff
    return "ok"
```

我们有两个端点（endpoint）：root 端点 `/` 和一个备用端点 `dummy`。根端点做一些繁重的工作，我们通过设置一个 20 秒定时器来模拟。

我们将端点本身定义为异步，并使用 `async` 关键字来表示线程可以在这个调用完成返回时去做其他工作。我们还使用了 `asyncio` 的 sleep 函数，因为它支持 `async` 和 `await`。这个 `dummy` 端点只是返回一个消息。

正如你所看到的，在 FastAPI 中定义一个 API 是非常简单的。我们只需要初始化一个 FastAPI 应用程序，并用 `@app` 函数修饰符来定义端点。

以下是用于 Flask 的代码：

```python
import os
from fastapi import FastAPI
import time
import pandas as pd
import pickle
import os
import asyncio
from concurrent.futures import ThreadPoolExecutor
import asyncio
import threading

app = FastAPI()

# @app.on_event("startup")
# async def startup_event():
#     loop = asyncio.get_running_loop()
#     loop.set_default_executor(ThreadPoolExecutor(max_workers=1))

@app.get("/dummy")
async def dummy():
    print(threading.active_count())
    return {"message": "async power"}

@app.get("/")
async def func():
    await helper()
    return {"message": "done"}

async def helper():
    await asyncio.sleep(20)
    # time.sleep(20)
    return heavy_func()

def heavy_func():
    # do stuff
    return "ok"
```

该代码与 FastAPI 的代码相同。

我们的想法是，调用 root 端点，在它等待 20 秒时，我们调用 `dummy` 端点。

关键点是：如果接口是异步的（ASGI），对 `dummy` 的调用应该立即返回相应的结果。

> 注意：我们将 Flask 中的线程（`threaded`）标志设置为 false，因为我们只想测试单线程的性能来学习。对于多线程应用程序来说，关键的要点应该还是一样的。

用以下方法启动 FastAPI 服务：

```bash
uvicorn tfastapi:app --reload
```

你可以在控制台中检查它是在哪个端口上运行的，默认是 8000 端口。

接下来，打开两个终端窗口。(我在 Windows 上使用 PowerShell，你也可以使用 Git Bash、Linux 或 macOS 终端)

在第一个终端执行以下 curl 命令：

```bash
curl http://localhost:8000/
```

在第二个终端，执行以下 curl 命令生成 `dummy` 端点：

```bash
curl http://localhost:8000/dummy
```

在第一个窗口按 `Enter` 回车，然后在第二个窗口按 `Enter` 回车。你应该注意到，对 `dummy` 的请求几乎可以立即得到返回结果。

![](https://miro.medium.com/max/1400/0*dn-fLnKEE6QKBmEG.png)

> 在 FastAPI 中请求异步端点，即刻得到响应。

如果你等待 20 秒，对 root 的调用应该会返回。

这里发生了什么？线程首先处理对 root 的调用。当执行到 sleep 函数，就处于等待状态，此时有一个对 `dummy` 端点的请求。于是线程转而执行 `dummy` 函数。一旦它被处理了，线程就返回来处理对 root 的请求。

现在让我们看下 Flask 的情况会怎样。

你可以用以下方式运行 Flask 服务器：

```bash
py tflask.py
```

它应该运行在 `5000` 端口。

接下来，像以前一样，复制并粘贴 curl 请求到 root，然后再复制 curl 请求到 `dummy`。先运行 root 请求，然后再运行另一个。

你会注意到，对 `dummy` 的调用并没有立即返回! 两个请求都需要 20 秒才能返回。这里发生了什么？

尽管代码是异步的，但 Flask 使用了 server-framework 接口的 WSGI 实现。这意味着 Flask 中的端点并不是真正的异步。我们向 root 发出一个请求，它就会等待。当我们向线程发出第二个请求时，线程不会跳转来处理这个请求。程序将暂停 20 秒，然后继续执行 root 请求中其余的代码。换句话说，执行其他请求前，程序暂停了 20 秒。在这段时间里，线程除了等待之外，没有做任何工作！这是很低效的。效率太低了！

## 本文总结

在这篇文章中，我们学习了同步与异步代码对比，还了解了 WSGI 和 ASGI 接口的实现。

我们知道了 FastAPI 如何帮助实现完全的线程利用率，并极大地加快代码的执行速度。

使用 FastAPI 时所需要做的就是在每个端点前面使用 `async`，同时确保代码是异步的。实际上，我想对最后一点进行扩展，并做一些总结。

- ASGI 是新技术，所以可能它的相关资料较难找到。与 WSGI 相比，针对它的测评也较少。
- 如果想获得性能提升，需要使用异步代码，现在还不是所有的库都支持这个。例如，某些 Python 的数据库依赖只有同步实现。在这种情况下，你可能不会得到太多的性能提升。
- 最后，FastAPI 支持类型提示，并且与 Pydantic 整合得相当好。你可以在[这里](https://betterprogramming.pub/writing-robust-and-error-free-python-code-using-pydantic-151a135a9ff0)查看我的帖子，了解更多这方面的信息。

感谢您的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
