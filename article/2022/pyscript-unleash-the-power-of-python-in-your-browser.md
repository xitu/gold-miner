> * 原文地址：[PyScript — unleash the power of Python in your browser](https://towardsdatascience.com/pyscript-unleash-the-power-of-python-in-your-browser-6e0123c6dc3f)
> * 原文作者：[Eryk Lewinson](https://medium.com/@eryk-lewinson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/pyscript-unleash-the-power-of-python-in-your-browser.md](https://github.com/xitu/gold-miner/blob/master/article/2022/pyscript-unleash-the-power-of-python-in-your-browser.md)
> * 译者：
> * 校对者：

# PyScript — unleash the power of Python in your browser

![Source: [source: pyscript.net](https://pyscript.net/)](https://cdn-images-1.medium.com/max/2904/1*WNbl_1riOiUbZvMTMrsEHA.png)

## A sneak peek at how to run Python from HTML code

During a keynote speech at PyCon US 2022, Anaconda’s CEO Peter Wang unveiled quite a surprising project — [PyScript](https://pyscript.net/). It is a JavaScript framework that allows users to create Python applications in the browser using a mix of Python and standard HTML. The project’s ultimate goal is to allow a much wider audience (for example, front-end developers) to benefit from the power of Python and its various libraries (statistical, ML/DL, etc.).

## The key things to know about PyScript

* Allows us to use Python and its vast ecosystem of libraries (including `numpy`, `pandas`, `scikit-learn`) from within the browser.
* By using environment management ****users can decide which packages and files are available when running the page’s code.
* We can use some of the curated UI components out-of-the-box, for example: buttons, containers, text boxes, etc.
* We do not have to worry about deployment as with PyScript everything will happen in our web browsers. As data scientists, we could share HTML files containing dashboards and/or models with our stakeholders, who will be able to run those in their browsers without any complicated setup.

## How does it work?

PyScript is built on [Pyodide](https://pyodide.org/en/stable/). I hope I am not in the vast minority of data scientists who were not really familiar with what **Pyodide** actually is. So it is a Python distribution (port of CPython) for the browser and Node.js based on WebAssembly. Which brings the next question: what is WebAssembly?

**WebAssembly** is the technology that makes it possible to write websites in Python. It uses a human readable `.wat` text format language, which then gets converted to a binary `.wasm` format that browsers can run. Thanks to this, we can write code in any language, compile it to WebAssembly, and then run in a web browser.

In the following image presenting the tech stack, we can also see [**Emscripten**](https://emscripten.org/), which is an open-source compiler toolchain. It allows any portable C/C++ codebase to be compiled into WebAssembly.

Thankfully, as end users we do not have to fully understand what is happening under the hood. However, it is definitely important, for example, for security reasons.

![Source: [https://anaconda.cloud/pyscript-python-in-the-browser](https://anaconda.cloud/pyscript-python-in-the-browser)](https://cdn-images-1.medium.com/max/2600/1*UCcZYRB6nqayqIfB_110Qg.png)

For the time being, PyScript supports writing and running Python code in a browser. The goal for the future is that it will also provide support for other languages.

This is also where a potential limitation comes into play. Currently, when using PyScript we can only use the libraries that are supported by Pyodide. You can find the entire list [here](https://github.com/pyodide/pyodide/tree/main/packages).

## Taking it for a spin

PyScript it currently in the alpha stage, but we can already give it a go and potentially suggest any improvements on its [GitHub repo](https://github.com/pyscript/pyscript). We can download a zipped folder containing all the code and assets directly from [PyScript’s website](http://Taking it for a spin).

The most basic example provided on PyScript’s website is the following:

```HTML
<html>
  <head>
    <link rel="stylesheet" href="https://pyscript.net/alpha/pyscript.css" />
    <script defer src="https://pyscript.net/alpha/pyscript.js"></script>
  </head>
  <body> <py-script> print('Hello, World!') </py-script> </body>
</html>
```

As we can see, Python code is embedded in the `\<py-script>` block. Opening the file in the browser (or using VS Code’s Life Saver extension) results in the following output:

![Image by author](https://cdn-images-1.medium.com/max/2772/1*t6LKreo694VqHUfvoopEuA.png)

In the second example, we will do a bit more. We will use `numpy` to generate numbers coming from Standard Normal distribution and then plot them using `matplotlib`. We do so using the following code:

```HTML
<html>
    <head>
      <link rel="stylesheet" href="https://pyscript.net/alpha/pyscript.css" />
      <script defer src="https://pyscript.net/alpha/pyscript.js"></script>
      <py-env>
        - numpy
        - matplotlib
      </py-env>
    </head>

  <body>
    <h1>Plotting a histogram of Standard Normal distribution</h1>
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

This time, we also did the following:

* we defined the libraries we wanted to use in our Python environment by listing them in the `\<py-env>` block,
* we indicated that we will be outputting a plot by specifying it in the `\<py-script>` block: `\<py-script output=”plot”>`.

![Image by author](https://cdn-images-1.medium.com/max/3180/1*EmAbw6whRSYRxbBC7JtVdQ.png)

Naturally, as our codebase grows bigger, we do not have to embed it entirely in the HTML file. We can use the following block structure to load any `.py` script:

```html
<py-script src="/our_script.py"> </py-script>
```

You can find quite a lot of examples of using PyScript [here](https://pyscript.net/examples/) (already running in the browser) and [here](https://github.com/pyscript/pyscript/tree/main/pyscriptjs/examples) (code on GitHub).

## Wrapping up

* with PyScript we will be able to run Python (and not only) code straight from our browsers,
* the project is developed by Anaconda,
* the project is still in the alpha stage, but we can already play around with a selection of libraries supported by Pyodide.

Personally, I am not sure what to think about PyScript at this point in time. It seems promising, but it can potentially open quite a lot of new security issues. And at this time, we can also see that even running some simple scripts already generates a significant overhead in terms of execution time. So I am not sure how practical it will be to run larger chunks of code from within the browser.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
