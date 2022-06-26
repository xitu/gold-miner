> * 原文地址：[PyScript — unleash the power of Python in your browser](https://towardsdatascience.com/pyscript-unleash-the-power-of-python-in-your-browser-6e0123c6dc3f)
> * 原文作者：[Eryk Lewinson](https://medium.com/@eryk-lewinson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/pyscript-unleash-the-power-of-python-in-your-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2022/pyscript-unleash-the-power-of-python-in-your-browser.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[Chorer](https://github.com/Chorer)、[Baddyo](https://github.com/Baddyo)

# PyScript —— 在浏览器中释放 Python 的力量

![来源：[pyscript.net](https://pyscript.net/)](https://cdn-images-1.medium.com/max/2904/1*WNbl_1riOiUbZvMTMrsEHA.png)

## 一窥如何在 HTML 中运行 Python

在 PyCon US 2022 的主题演讲中，Anaconda 的首席执行官 Peter Wang 公布了一个出人意料的项目 —— [PyScript](https://pyscript.net/)。PyScript 是一个 JavaScript 框架，它能让开发者混合使用 Python 和 HTML 来创建 Python 应用。该项目的最终目标是让更广的受众（如前端开发人员）获益于 Python 及其各种库（统计、机器学习、深度学习等）的强大功能。

## PyScript 的几个关键点

* 我们能在浏览器中使用 Python 及其庞大的生态系统，包括 `numpy`、`pandas` 和 `scikit-learn`。
* 通过使用环境管理，我们可以决定在运行页面代码时所包含的包和文件。
* 我们可以直接使用一些精美的 UI 组件，如按钮、容器、文本框等。
* 我们不必担心网页的部署，因为 PyScript 的一切都将在浏览器中发生。作为数据科学家，我们可以与甲方共享包含仪表板和/或模型的 HTML 文件；他们将能在自己的浏览器中运行这些文件，并不需要任何复杂的设置。

## PyScript 是怎么运作的？

PyScript 建立于 [Pyodide](https://pyodide.org/en/stable/) 之上。我希望我不是那一小部分不懂 **Pyodide** 实际上是什么的数据科学家。Pyodide 是基于 WebAssembly 和 Node.js 的 Python 发行版，对接 Cpython 与 WebAssembly。这就引出了下一个问题：什么是 WebAssembly？

**WebAssembly** 这项技术让在网页中编写 Python 成为可能。它所使用的是可读的 `.wat` 文本格式语言，接着再将其转换为浏览器可以运行的二进制 `.wasm` 格式。多亏了这一点，我们可以用任何语言编写代码，并将其编译为 WebAssembly，然后在 Web 浏览器中运行。

下图展现了 PyScript 的技术栈，我们可以看到 [**Emscripten**](https://emscripten.org/) 库。这是一个开源编译工具链，它能让你将任何可移植的 C/C++ 代码库编译成 WebAssembly。

值得庆幸的是，作为终端用户，我们不必了解其底层原理。然而，出于安全考量等，这些内容绝对是非常重要的。

![来源：[https://anaconda.cloud/pyscript-python-in-the-browser](https://anaconda.cloud/pyscript-python-in-the-browser)](https://cdn-images-1.medium.com/max/2600/1*UCcZYRB6nqayqIfB_110Qg.png)

就现在来说，PyScript 已支持在浏览器中编写和运行 Python 代码。其未来的目标是提供对其他语言的支持。

PyScript 也将带来一个潜在限制 —— 目前，我们只能使用 Pyodide 支持的库。你可以在[这里](https://github.com/pyodide/pyodide/tree/main/packages)找到完整的列表。

## 上手试用

PyScript 现仍在 alpha 阶段，但大家已经可以试用并在 [GitHub 仓库](https://github.com/pyscript/pyscript)提出改善建议。我们可以直接从 [PyScript 官网](https://pyscript.net/)下载包含所有代码和资源的压缩包。

PyScript 官网中提供的最基本的示例如下：

```html
<html>
  <head>
    <link rel="stylesheet" href="https://pyscript.net/alpha/pyscript.css" />
    <script defer src="https://pyscript.net/alpha/pyscript.js"></script>
  </head>
  <body>
    <py-script>
      print('你好世界！')
    </py-script>
  </body>
</html>
```

我们可以看到，Python 代码嵌入在 `<py-script>` 块中。接着，在浏览器中打开文件（或使用 VS Code 的 Life Saver 插件），实际结果如下：

![图片由作者提供](https://cdn-images-1.medium.com/max/2772/1*t6LKreo694VqHUfvoopEuA.png)

让我们更进一步。我们将使用 NumPy 生成标准正态分布，并使用 Matplotlib 绘图。代码如下：

```HTML
<html>
  <head>
    <link rel="stylesheet" href="https://pyscript.net/alpha/pyscript.css"/>
    <script defer src="https://pyscript.net/alpha/pyscript.js"></script>
    <py-env>
      - numpy
      - matplotlib
    </py-env>
  </head>
  <body>
    <h1>绘制标准正态分布的直方图</h1>
    <div id="plot"></div>
    <py-script output="plot">
      import matplotlib.pyplot as plt
      import numpy as np
  
      np.random.seed(42)
  
      rv = np.random.standard_normal(1000)
  
      fig, ax = plt.subplots()
      ax.hist(rv, bins=30)
      fig
    </py-script>
  </body>
</html>
```

在这个例子中，我们做了以下几件事：

* 我们在 `<py-env>` 块中列出了想要在 Python 环境中使用的库；
* 我们在 `<py-script>` 块中指定了输出为一个图：`<py-script output="plot">`。

![图片由作者提供](https://cdn-images-1.medium.com/max/3180/1*EmAbw6whRSYRxbBC7JtVdQ.png)

随着我们的代码库变得越来越大，我们不可能将所有代码嵌入到 HTML 文件中。我们可以使用以下的标签来导入任何的 `.py` 脚本。

```html
<py-script src="/our_script.py"></py-script>
```

你可以在[这里](https://pyscript.net/examples/)（演示）和[这里](https://github.com/pyscript/pyscript/tree/main/pyscriptjs/examples)（代码）找到许多 PyScript 的示例。

## 总结

* 有了 PyScript，我们能在浏览器中直接运行 Python 代码（或许在未来不仅仅只是 Python 代码）；
* 项目由 Anaconda 开发；
* 项目仍在 alpha 阶段，但我们已经可以试用部分由 Pyodide 支持的库。

就我来说，我不确定目前对 PyScript 有什么看法。这项目看起来很有潜力，但它也可能引发更多新的安全问题。我们可以看到，即使是运行一些简单的脚本，PyScript 在执行时间方面已经产生了很大的开销。因此，我不太确定使用它来运行更大的代码块会不会是一个符合实际的方式。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
