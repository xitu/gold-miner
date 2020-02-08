> * 原文地址：[WebAssembly: Easy explanation with code example](https://medium.com/front-end-weekly/webassembly-why-and-how-to-use-it-2a4f95c8148f)
> * 原文作者：[Vaibhav Kumar](https://medium.com/@vaibhav_kumar)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/webassembly-why-and-how-to-use-it.md](https://github.com/xitu/gold-miner/blob/master/TODO1/webassembly-why-and-how-to-use-it.md)
> * 译者：
> * 校对者：

# WebAssembly: Easy explanation with code example

![](https://cdn-images-1.medium.com/max/2000/1*nXtCVLlUslu2_LjSAcOWbA.png)

## Why WebAssembly?

#### Background: Web and JavaScript

Undoubtedly, web is highly portable and machine-agnostic, making it a truly universal platform.

> Web is the only one true universal platform. ☝️

JavaScript (JS) is the default language of web-development. It has native support of many web APIs like DOM, Fetch, Web-sockets, Storage etc., and as browsers are becoming more powerful, we are writing more complex clients using JavaScript (or languages that transpile to JS).

However JavaScript has some limitations when it comes to running big complex applications on browser.

#### Limitations of JavaScript

* Not good for CPU-intensive tasks
* JS is text based and not binary-based, more download bytes and hence more startup time.
* JS interpretation and JIT-optimization consumes CPU and thus battery life

![JavaScript execution pipeline](https://cdn-images-1.medium.com/max/4350/1*76S11i2-OTBF34xG8ohwng@2x.png)

* Need to rewrite already existing non-JS libraries, modules and apps in JS

Web development community is trying to overcome these limitations and opening up web to other programming languages by bringing a new entrant in web-development called **WebAssembly**.

> On 5th Dec. 2019, WebAssembly became the fourth language standard along with [HTML](https://en.wikipedia.org/wiki/HTML), [CSS](https://en.wikipedia.org/wiki/CSS), and [JavaScript](https://en.wikipedia.org/wiki/JavaScript) to run natively in browsers.

## Web Assembly (WASM)

> WebAssembly is a type of binary-code that can be run in modern web browsers, it enables us to write code in multiple languages and run it at near-native speed on the web.

#### Features of WASM

* WASM is a low-level language not to be written by humans but compilation target for other languages like C/C++, Rust, AssemblyScript etc.
* WASM is binary-format and thus less download bytes (there is an equivalent text-format for humans too, called [**WAT**](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format)).
* Unlike JS, WASM binary is decoded and compiled to machine code without need of any optimization, as it is already optimized during generation of WASM binary

![WebAssembly execution pipeline](https://cdn-images-1.medium.com/max/3712/1*5KOcPw-Jm0b2T66XepU3TQ@2x.png)

## When to use WebAssembly?

* CPU intensive tasks like maths in Games or other graphic apps, Image and Video manipulation etc.
* Running old C/C++ libraries and apps on web providing portability and eliminating need to re-write C/C++ code into JS.
* To eliminate the need of making native apps and various compilation targets as single WASM compilation would enable it to run on different processors through web browsers.

> WASM is here not to replace JS but work alongside it. **JavaScript has already good collection of Native web APIs, WASM is here to assist with the heavy lifting.**

> **Note:
**Modern JavaScript engines are very fast and highly optimize our JS code, so WASM bundle size and execution time might not be very advantageous for simple tasks.
I am not doing any benchmarking in this article but would refer to resources at the bottom of this article for benchmarking links.

## How to use WASM (deep-dive 🤿)

![Overview of generating and consuming WASM](https://cdn-images-1.medium.com/max/4128/1*tjXrX4_S_MM8AhA4NIZgfw@2x.png)

Let’s follow above steps to create a function in **C** to calculate factorial of a number and consume it in JS as WASM.

![C code for calculating factorial](https://cdn-images-1.medium.com/max/2000/1*FxtyDbFijWofWEOcRtyJrQ.png)

We can compile above C function into WASM using [Emscripten](https://emscripten.org/):

```
emcc factorial.c -s WASM=1 -o factorial.html
```

It will generate `**factorial.wasm**`** **binary file along with** html-js **glue code. A list of output targets is referenced [here](https://emscripten.org/docs/tools_reference/emcc.html#emcc-o-target).

Its equivalent human readable textual format [**WAT**](https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format) is shown below.

![factorial.wasm’s equivalent textual format: **factorial.wat**](https://cdn-images-1.medium.com/max/2384/1*odknwrBvAfktggSvpF2YEQ.png)

There are various ways one can send the binary data of WASM to web-client and we can use javascript’s `**WebAssembly**` API to compile the binary data to create **WASM Module** and later instantiate this **Module** to access exported functions.

The most efficient, optimized way to load WASM code is to use **WebAssembly.instantiateStreaming()** function that compiles and instantiates a WebAssembly module directly from a streamed underlying source.

Following is the example code of using `**instantiateStreaming**` for consuming previously generated **`factorial.wasm`** file, which can be served by our server and can be called by our web-client on demand. We can then instantiate received WASM module using following JS code and can access the exported **`factorial` function**.

![JS glue code for consuming WASM files](https://cdn-images-1.medium.com/max/2524/1*To4yagUwccxkP4TXZE4P8g.png)

> To get a quick feel of the explained steps without the pain-staking setups, [WASM fiddle](https://wasdk.github.io/WasmFiddle) can be used.

## Browser support

All modern browsers (Chrome, Firefox, Safari, Edge) support it. [Click here to see the latest support stats](https://caniuse.com/#search=wasm).

> IE does not support WASM. If there is a need to use C/C++ code in IE, we can compile it to [**asm.js**](http://asmjs.org/)** (a subset of JS) using Emscripten.**

## Future

Support for **thread management** and **garbage collection** is being implemented. This will make WebAssembly more suitable as a compilation target for languages ​​like **Java**, **C#, Go**.

## Resources

* [https://webassembly.org/](https://webassembly.org/)
* [WASM Explorer](https://mbebenita.github.io/WasmExplorer/)
* [Online WASM IDE](https://webassembly.studio/)
* [WASM Fiddle](https://wasdk.github.io/WasmFiddle/)
* [Google code-labs tutorial](https://codelabs.developers.google.com/codelabs/web-assembly-intro/index.html)
* [Benchmarking reference](https://medium.com/@torch2424/webassembly-is-fast-a-real-world-benchmark-of-webassembly-vs-es6-d85a23f8e193)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
