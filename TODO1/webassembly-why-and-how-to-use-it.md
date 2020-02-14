> * 原文地址：[WebAssembly: Easy explanation with code example](https://medium.com/front-end-weekly/webassembly-why-and-how-to-use-it-2a4f95c8148f)
> * 原文作者：[Vaibhav Kumar](https://medium.com/@vaibhav_kumar)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/webassembly-why-and-how-to-use-it.md](https://github.com/xitu/gold-miner/blob/master/TODO1/webassembly-why-and-how-to-use-it.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[钱俊颖](https://github.com/Baddyo)

# WebAssembly: 带有代码示例的简单介绍

![](https://cdn-images-1.medium.com/max/2000/1*nXtCVLlUslu2_LjSAcOWbA.png)

## 为什么要用 WebAssembly？

#### 背景：Web 和 JavaScript

毫无疑问，web 具有高度移植性并且与机器无关，这使其能成为一个真正通用的平台。

> Web 是唯一真正的通用平台。☝️

JavaScript（JS）是 Web 开发的默认语言。它有许多原生的 Web API 例如（DOM、Fetch、Web-sockets、Storage 等等），并且随着浏览器功能越来越强大，我们正在使用 JavaScript（或者其它能转译成 JS 的语言）来编写更复杂的客户端程序。

但是在浏览器上运行一些大型的应用程序时，JavaScript 存在一些限制。

#### JavaScript 的限制

* 不利于 CPU 密集型任务
* JS 基于文本而非二进制，因此需要下载更多的字节，启动时间也更长
* JS 解释和 JIT 优化会消耗 CPU 和电池寿命

![JavaScript 执行管道](https://cdn-images-1.medium.com/max/4350/1*76S11i2-OTBF34xG8ohwng@2x.png)

* 需要用 JS 重写已经存在的非 JS 库、模块和应用程序

Web 开发社区正在尝试克服这些限制，并通过引入 Web 开发新成员 **WebAssembly** 来向其它编程语言开放 Web。

> 在 2019 年 12 月 5 日，WebAssembly 和 [HTML](https://en.wikipedia.org/wiki/HTML)、[CSS](https://en.wikipedia.org/wiki/CSS)、[JavaScript](https://en.wikipedia.org/wiki/JavaScript) 一样，成为了第四个 Web 语言标准，能在浏览器上运行。

## Web Assembly (WASM)

> WebAssembly 是一种能在现代 Web 浏览器中运行的二进制代码，它使得我们能用多种语言编写代码并以接近本地运行的速度在 Web 上运行。

#### WASM 的功能

* WASM 是一种不能由开发者编写的底层语言，而是由其它语言例如 C/C++、Rust、AssemblyScript 编译而来
* WASM 是二进制格式，因此只用下载更少的字节（开发者也有等效的文本格式，称为 [**WAT**](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format)）
* 与 JS 不同，WASM 二进制文件无需任何优化就可以解码和编译成机器代码，因为在生成 WASM 二进制文件时就已经对其进行了优化

![WebAssembly 执行管道](https://cdn-images-1.medium.com/max/3712/1*5KOcPw-Jm0b2T66XepU3TQ@2x.png)

## 什么时候使用 WebAssembly。

* CPU 密集型任务，例如游戏或其它图形应用中的数学、图像和视频处理等
* 在 Web 上运行旧的 C/C++ 库和应用程序，提供了可移植性，并且避免了将 C/C++ 代码用 JS 重写的需求
* 消除将原生应用程序和各种编译目标作为单个 WASM 编译的需求，可以使其通过 Web 浏览器在不同的处理器上运行

> WASM 在这里并不是要取代 JS，而是要与之一起工作。**JavaScript 本身已经具有不错的原生 Web API 集合，WASM 在这里可以协助完成繁重的工作。**

> **注意：**
现代 JavaScript 引擎非常快速并且可以高度优化我们的 JS 代码，因此 WASM 软件包的大小和执行时间对于简单任务可能不是很有利。
在本文中，我不做任何基准测试，但请参考本文底部的参考资料，可以获取基准测试链接。

## 怎么使用 WASM（加深学习 🤿）

![生成和使用 WASM 概述](https://cdn-images-1.medium.com/max/4128/1*tjXrX4_S_MM8AhA4NIZgfw@2x.png)

让我们参照上述步骤在 **C** 中创建一个程序，用来计算数字的阶乘并将其作为 WASM 在 JS 中使用。

![C 编写的计算阶乘代码](https://cdn-images-1.medium.com/max/2000/1*FxtyDbFijWofWEOcRtyJrQ.png)

我们可以使用 [Emscripten](https://emscripten.org/) 将上面 C 函数编译成 WASM：

```
emcc factorial.c -s WASM=1 -o factorial.html
```

它会生成 `**factorial.wasm**` 二进制文件以及 **html-js** 粘合代码。[这里](https://emscripten.org/docs/tools_reference/emcc.html#emcc-o-target)引用了输出目标的列表。

有效的可读文本格式 [**WAT**](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format) 如下所示。

![factorial.wasm 的等效文本格式： **factorial.wat**](https://cdn-images-1.medium.com/max/2384/1*odknwrBvAfktggSvpF2YEQ.png)

可以通过多种方式将 WASM 的二进制数据发送到 Web 客户端，我们可以使用 javascript 的 `**WebAssembly**` API 编译二进制数据来创建 **WASM 模块**然后实例化这个**模块**来访问导出的功能。

加载 WASM 代码最有效、最优化的方法是使用 **WebAssembly.instantiateStreaming()** 这个直接从流式基础源编译和实例化 WebAssembly 模块的函数。

以下是使用 `**instantiateStreaming**` 来调用之前生成的 **`factorial.wasm`** 文件的示例代码，该文件可以由我们的服务器提供，也可以被我们的 Web 客户端按需调用。然后，我们可以使用以下 JS 代码实例化接收到的 WASM 模块，并可以访问导出的 **`factorial` function**。

![调用 WASM 文件的 JS 代码](https://cdn-images-1.medium.com/max/2524/1*To4yagUwccxkP4TXZE4P8g.png)

> 想快速理解所说明的步骤而无需进行繁琐的设置，可以使用 [WASM fiddle](https://wasdk.github.io/WasmFiddle)。

## 浏览器支持

所有的现代浏览器（Chrome、Firefox、Safari、Edge）都支持 WebAssembly。[点击此处以查看最新的支持统计信息](https://caniuse.com/#search=wasm)。

> IE 不支持 WASM。如果需要在 IE 中使用 C/C++ 代码，我们可以使用 Emscripten 将其编译为 [**asm.js**](http://asmjs.org/)（JS 的一个子集）。

## 未来

正在实现对**线程管理**和**垃圾收集**的支持。这会让 WebAssembly 更适合作为 **Java**、**C#**、**Go** 之类的语言的编译目标。

## 参考资料

* [https://webassembly.org/](https://webassembly.org/)
* [WASM Explorer](https://mbebenita.github.io/WasmExplorer/)
* [Online WASM IDE](https://webassembly.studio/)
* [WASM Fiddle](https://wasdk.github.io/WasmFiddle/)
* [Google code-labs tutorial](https://codelabs.developers.google.com/codelabs/web-assembly-intro/index.html)
* [Benchmarking reference](https://medium.com/@torch2424/webassembly-is-fast-a-real-world-benchmark-of-webassembly-vs-es6-d85a23f8e193)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
