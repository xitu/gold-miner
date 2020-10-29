> * 原文地址：[A Complete Introduction to WebAssembly and It’s JavaScript API](https://blog.bitsrc.io/a-complete-introduction-to-webassembly-and-its-javascript-api-3474a9845206)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/a-complete-introduction-to-webassembly-and-its-javascript-api.md](https://github.com/xitu/gold-miner/blob/master/article/2020/a-complete-introduction-to-webassembly-and-its-javascript-api.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)
> * 校对者：[samyu2000](https://github.com/samyu2000)、[plusmultiply0](https://github.com/plusmultiply0)

# WebAssembly 及其 JavaScript API 的完整介绍

![[Louis Hansel @shotsoflouis](https://unsplash.com/@louishansel?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*HV8EPAnwvRa8_4JH)

自计算机诞生以来，原生应用程序的性能有了很大的提高。相比之下，由于 JavaScript 不是为了提高运行速度而发明的，因此 web 应用程序非常慢。但是，由于浏览器之间的激烈竞争以及诸如 V8 之类的 JavaScript 引擎的快速发展，使 JavaScript 能够在计算机上快速运行。但是它仍然无法超越原生应用程序的性能。其中的主要原因在于，JavaScript 代码需要经过多次编译才能生成机器代码。

![JS 引擎各阶段平均耗时统计 — 来自于: [Lin Clark](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/fd3c55e9-3dda-473b-a76b-0ba4d0e039ad/08-diagram-now01-large-opt.png)](https://cdn-images-1.medium.com/max/2400/0*bGwF1hjg50k_o2C0.png)

随着 WebAssembly 的诞生，我们所熟悉的 Web 应用程序有望发生革命性的变化。它能使 Web 应用程序运行加快。让我们看一下什么是 WebAssembly，以及如何与 JavaScript 集成以构建运行速度惊人的应用程序。

## 什么是 WebAssembly?

**在理解 WebAssembly 之前，让我们先看看什么是汇编（Assembly）。**

汇编语言是一种底层的编程语言，与底层的机器指令有非常密切的联系。换句话说， 汇编就是将这种语言转换为机器可理解的代码 (称为机器码) 的一个过程。

**WebAssembly** 可以通俗地理解为在 web 应用程序中使用的汇编语言。它是一种低级的类似汇编的语言，具有紧凑的二进制格式，使您能够以接近原生的速度运行 web 应用程序。它还为诸如 C、C++ 和 Rust 之类的语言提供了编译目标，从而使客户端应用程序能够以近乎原生的性能在 web 上运行。

此外，WebAssembly 的初衷是与 JavaScript 协同运行，而不是替换它。使用 WebAssembly JavaScript API，你的应用程序既可凭借 WebAssembly 获得优良性能，又可使用 JavaScript 实现多功能、多兼容性。这开启了 web 应用程序的全新篇章，一些原来不能用于 Web 系统的代码和功能如今也可以运行在 Web 系统上。

## WebAssembly 有何不同

[Lin Clark](https://www.smashingmagazine.com/author/linclark/) 预测，于 2017 年推出的 WebAssembly 可能会使 Web 开发进入一个拐点。它是在现代浏览器引入 JIT 编译器之后发生的，由于 JIT 将 JavaScript 的速度提高了近10倍，JIT 的引入也是一个拐点。

![JavaScript 性能统计 — 来自于: [Lin Clark](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f5961531-2863-4e2a-afac-a3fafd927aa2/03-perf-graph10-large-opt.png)](https://cdn-images-1.medium.com/max/2400/0*Py-XN25Ym7msk12v.png)

如果仔细比较 JavaScript 与 WebAssembly 代码编译的过程，你应该可以注意到 WebAssembly 的编译过程中有几个过步骤被剥离了出来，同时还有几个步骤被去掉了。下面是两个编译过程的对比。

![JS 代码编译与 WebAssembly 代码编译过程大致对比 — 来自于: [Lin Clark](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/01483767-04a0-4438-be58-f7e6512f1b39/10-diagram-future01-large-opt.png)](https://cdn-images-1.medium.com/max/2400/0*A4PPwrXlDXzU4rpL.png)

如果仔细比较以上两个过程，您会注意到 WebAssembly 中的重新优化部分已被完全剥离。这主要是因为编译器不需要对 WebAssembly 代码做出任何假设，因为代码中诸如数据类型等需要明确定义的东西已经明确定义了。

但是 JavaScript 并非如此，因为 JIT 应该做出假设来运行代码，如果假设失败，它应该重新优化其代码。

## 如何获取 WebAssembly 代码

接下来的才是开发者要面临的最重要的问题。WebAssembly 是一项非常伟大的技术，那开发者应该如何充分使用它的能力呢？

有如下几种使用方法。

* 从头开始编写 WebAssembly 代码——除非您非常了解基础知识，否则不建议这样做。
* 从 C 编译到 WebAssembly
* 从 C++ 编译到 WebAssembly
* 从 Rust 编译到 WebAssembly
* 使用 [AssemblyScript](https://github.com/AssemblyScript/assemblyscript) 将严格变体版的 Typescript 编译到 WebAssembly。对于不熟悉 C/C++ 或 Rust 的 web 开发人员来说，这是一个很不错的选择。
* 同时还支持更多的语言编译可供选择，下面将会讲到。

此外，还有一些工具，例如 [Emscripten](https://emscripten.org/) 和 [WebAssembly Studio](https://webassembly.studio/) 可以帮助完成上述代码编译的过程。

## JavaScript 的 WebAssembly API

为了充分利用 WebAssembly 的特性，我们必须将其与 JavaScript 代码集成。这可以借助 JavaScript WebAssembly API 来实现。

#### 模块编译和实例化

WebAssembly 代码位于后缀名为 `.wasm` 的文件中，这个文件需要在客户端被编译至相应系统对应的机器码。可以通过 `WebAssembly.compile` 方法来编译 WebAssembly 模块。接收到编译好的 WebAssembly 模块后可以使用 `WebAssembly.instantiate` 方法来将其实例化。或者，也可以通过将获取到的 `.wasm` 文件内容转换为 ArrayBuffer 并传递至 `WebAssembly.instantiate` 的方式来进行实例化。

```js
let exports;

fetch('sample.wasm').then(response =>
  response.arrayBuffer();
).then(bytes =>
  WebAssembly.instantiate(bytes);
).then(results => {
  exports = results.instance.exports;
});
```

上述方法有一个缺点是：因 `WebAssembly.instantiate` 方法不能直接访问字节码，因此需要将获取的模块文件内容转换为 `ArrayBuffer` 再进行编译、实例化操作。

还有另外一种方法，使用 `WebAssembly.compileStreaming` 和 `WebAssembly.instantiateStreaming` 方法来实现上面编译、实例化的功能，这种方式的优点是能够直接访问字节码，而无需先将文件内容转换为 `ArrayBuffer`。

```js
let exports;

WebAssembly.instantiateStreaming(fetch('sample.wasm'))
.then(obj => {
  exports = obj.instance.exports;
})
```

值得注意的是，上述两种实例化 WebAssembly 模块的方法都会返回编译好的模块实例对象，以便快速启动模块实例。

```js
let exports;
let compiledModule;

WebAssembly.instantiateStreaming(fetch('sample.wasm'))
.then(obj => {
  exports = obj.instance.exports;
  //access compiled module
  compiledModule = obj.module;
})
```

#### 导入对象（Import Object）

完成 WebAssembly 模块实例化后，可以向模块实例传入一个导入对象（Import Object），这个导入对象的属性值可以是以下 4 种类型。

* 全局变量（Globals）
* 函数（Function）
* 内存（Memory）
* 表（Table）

导入对象可以理解为是向模块实例上附加的一系列用于实现特定功能的辅助工具方法，如果未提供导入对象，编译器将会分配默认值。

#### 全局变量（Globals）

使用 WebAssembly 可以创建全局变量，这些全局变量可以在 JavaScript 和 WebAssembly 模块中访问。并且可以导入、导出这些变量，同时可以在一个或多个 WebAssembly 模块实例中使用它们。

可以使用构造函数 `WebAssembly.Global()` 来创建全局变量实例。

```js
const global = new WebAssembly.Global({
    value: 'i64',
    mutable: true
}, 20);
```

该构造函数接收两个参数，分别是：

* 第一个参数是一个对象，其 value 属性表示表示值的类型，其 mutable 属性表示值是否可以修改，允许的值类型有：`i32`、`i64`、`f32` 和 `f64`；
* 第二个参数是变量的值，其值的类型必须与第一个参数中指定的类型一致，例如：如果参数一中类型是 `i32`，则值的类型必须是 32 位整型，如果参数一中类型是 `f64`，则值的类型必须是 64 位浮点型。

```js
const global = new WebAssembly.Global({
    value: 'i64',
    mutable: true
}, 20);

let importObject = {
    js: {
        global
    }
};

WebAssembly.instantiateStreaming(fetch('global.wasm'), importObject)
```

**上面创建的全局对象实例必须通过 `WebAssembly.instantiateStreaming` 或 `WebAssembly.instantiate` 方法传入到 WebAssembly 实例对象的导入对象上，才能确保 WebAssembly 实例对象可以正确访问。**

#### 内存（Memory）

WebAssembly 模块对象在实例化过程时需要通过导入对象传递一个已经分配好内存空间的对象。如果不传递这么一个对象，JIT 在编译时将会自动传入默认内存对象。

传入的内存对象也可以是 `ArrayBuffer`，这样就可以通过索引值轻松访问存储的内存值。因此，通过内存对象传递的数据值可以在 JavaScript 和 WebAssembly 之间共享。

#### 表（Table）

表是位于 WebAssembly 内存之外的一种可变长度的数组型数据，表存储的值是对数据的引用（指针）。看起来与内存对象（Memory）很相似，两者最大的区别在于内存对象存储的数据是原始字节，而表存储的内存数据的指针。

表（Table）这种 WebAssembly 数据结构的引入是为了提高运行时的安全性。

可以使用 `set()`、`grow()` 和 `get()` 方法来操作表。

## 一个示例

下面我将使用 WebAssembly Studio 创建的一个应用编译为 `.wasm` 文件，来演示如何使用 WebAssembly，你也可以在线查看这个 [demo](https://webassembly.studio/?f=wne209a6cxq)。

这里创建了对数字进行幂运算的函数，这个函数需要先传入一个值，然后在 JavaScript 程序中接收输出结果。

在 wasm（译者注：此处 wasm 指的是上文 WebAssembly 的实例，下同）中对字符串进行操作时需要额外注意了。wasm 里面不存在字符串（string）这一数据类型，字符串在 wasm 里面采用 ASCII 码来处理。传递给 JavaScript 的是存储计算结果的内存地址。另外，由于内存对象是 `ArrayBuffer`，因此需要对齐其进行遍历来转换为字符串。

**JavaScript 文件**

```js
let exports;
let buffer;
(async() => {
  let response = await fetch('../out/main.wasm');
  let results = await WebAssembly.instantiate(await response.arrayBuffer());
  // 或者
  // let results = await WebAssembly.instantiateStreaming(fetch('../out/main.wasm'));
  let instance = results.instance;
  exports = instance.exports;
  buffer = new Uint8Array(exports.memory.buffer);

  findPower(5,3);
  
  printHelloWorld();
  
})();

const findPower = (base = 0, power = 0) => {
  console.log(exports.power(base,power));
}

const printHelloWorld = () => {
  let pointer = exports.helloWorld();
  let str = "";
  for(let i = pointer;buffer[i];i++){
    str += String.fromCharCode(buffer[i]);
  }
  console.log(str);
}
```

**C 文件**

```c
#define WASM_EXPORT __attribute__((visibility("default")))
#include <math.h>


WASM_EXPORT
double power(double number,double power_value) {
  return pow(number,power_value);
}

WASM_EXPORT
char* helloWorld(){
  return "hello world";
}
```

## 使用场景

WebAssembly 的诞生打开了另一个充满各种可能性的世界。

* **赋给了 web 环境使用 c、C++ 等语言开发的现成库或者项目的能力**

比如，如果找不到某个功能的 JavaScript 版本实现，以前没有 WebAssembly，你需要从头开始变成，使用 JavaScript 来实现这个功能。而现在，如果能找到别的语言实现这一功能的库，则可以借助 WebAssembly 的能力直接复用这个库。从技术开发的角度来看，这会大幅度节省开发时间，带来巨大的突破。

[Squoosh](https://squoosh.app/) 应用采用 WebAssembly 实现了二维码和图片识别功能，应用程序因此也能在低版本浏览器中以接近原生的速度运行。另外，[eBay](https://tech.ebayinc.com/engineering/webassembly-at-ebay-a-real-world-use-case/) 也通过编译原有的 C++ 库至 WebAssembly 从而实现了条码扫描功能。

* **对现有的 C、C++ 项目稍作修改就可以让其运行在 web 环境，并且同时拥有接近原生的速度**

像 [AutoCAD](https://www.autodesk.com/products/autocad-web-app/overview?linkId=68719474)、[QT](https://www.qt.io/qt-examples-for-webassembly) 以及 [Google Earth](https://medium.com/google-earth/earth-on-web-the-road-to-cross-browser-7338e0f46278) 这些应用简单修改现有代码库就可以凭借接近原生的性能运行在 web 端，这些最终都要归功于 WebAssembly 的能力。

* **由 C、C++ 或 Rust 等语言开发的库可以借助 WebAssembly 来编译至 web 端可运行的库，即使相应的库可能已有 JavaScript 版本的实现，但是通过编译至 WebAssembly 来运行，应用的运行速度将加快并且可以具有更好的性能**

谷歌团队曾在 [Squoosh](https://squoosh.app/) 应用中将类似 C 或 C++ 开发的 JPEG、MozJPEG 等解码器编译成了 WebAssembly 版本，替换了之前的解码器。编译之后的解码器在不牺牲图片质量的情况下，进一步缩减了图片文件的体积。

#### 支持的编程语言

不仅仅只有 C、C++ 或 Rust 语言支持编译至 WebAssembly，许多其他语言正在积极努力地争取支持 WebAssembly 编译。以下是当前支持编译 WebAssembly 的编程语言列表。

* C/C++
* [Rust](https://developer.mozilla.org/en-US/docs/WebAssembly/Rust_to_wasm)
* [AssemblyScript (类似 TypeScript 语法)](https://docs.assemblyscript.org/)
* [C#](https://docs.microsoft.com/en-us/aspnet/core/blazor/get-started?view=aspnetcore-3.1&tabs=visual-studio)
* [F#](https://fsbolero.io/docs/)
* [Go](https://golangbot.com/webassembly-using-go/)
* [Kotlin](https://kotlinlang.org/docs/reference/native-overview.html)
* [Swift](https://swiftwasm.org/)
* [D](https://wiki.dlang.org/Generating_WebAssembly_with_LDC)
* [Pascal](https://wiki.freepascal.org/WebAssembly/Compiler)
* [Zig](https://ziglang.org/documentation/master/#WebAssembly)

---

## 不足之处

WebAssembly 使得程序可以直接执行编译好的二进制文件，这同时也引入了很多安全性的问题。例如，这个例子——[漏洞可以被利用](vulnerabilities can be exploited](vulnerabilities can be exploited](https://www.virusbulletin.com/virusbulletin/2018/10/dark-side-webassembly/)的问题就很难被发现，甚至都无法通过栈进行跟踪。尽管 WebAssembly 本身已经做了部分安全性功能，但我个人认为这个功能都还不够，还需要进一步改进。使用这些新的功能将导致传统的防护层（如防病毒和 URL 过滤等）失效。如果不能解决这些问题，意味着在未来这些普通浏览器的安全性将大大降低。

你可以阅读下面的文章了解更多关于 WebAssembly 安全性的问题。

- [WebAssembly 黑暗的一面](https://www.virusbulletin.com/virusbulletin/2018/10/dark-side-webassembly/)
- [wasm 安全性的担忧](https://securityboulevard.com/2020/01/research-more-worries-with-wasm-3/)
- [官方的完全性说明](https://webassembly.org/docs/security/)

## 总结一下

虽然网上有炒作说 WebAssembly 即将替代 JavaScript，但是我不赞成 JavaScript 将被替代的这种说法。WebAssembly 的诞生是为了同 JavaScript 一同协作的，而非替代 JavaScript。此外，调试 JavaScript 代码比调试 WebAssembly 代码容易得多，并且 JavaScript 的那些自由灵活的语法在 WebAssembly 中是不支持的。

众望所归，可以毫不保留地说 WebAssembly 的出现将会给更多类型的 web 应用开发铺平道路。

> “虽然无法预测这些性能上的提升能促使哪些新应用诞生，但是只要现在或过去稍有一丝迹象，未来一定会令我们惊喜。” —— Lin Clark

## 参考文章

- [An Abridged Cartoon Introduction To WebAssembly by Lin Clark](https://www.smashingmagazine.com/2017/05/abridged-cartoon-introduction-webassembly/)
- [Creating a WebAssembly module instance with JavaScript by Lin Clark](https://hacks.mozilla.org/2017/07/creating-a-webassembly-module-instance-with-javascript/)
- [Memory in WebAssembly by Lin Clark](https://hacks.mozilla.org/2017/07/memory-in-webassembly-and-why-its-safer-than-you-think/)
- [WebAssembly table imports… what are they? by Lin Clark](https://hacks.mozilla.org/2017/07/webassembly-table-imports-what-are-they/)
- [WebAssembly Official Website](https://webassembly.org/)
- [Google IO 2019 — WebAssembly for Web Developers](https://www.youtube.com/watch?v=njt-Qzw0mVY)
- [MDN Docs — WebAssembly](https://developer.mozilla.org/en-US/docs/WebAssembly)
- [MDN Docs — WebAssembly JavaScript API](https://developer.mozilla.org/en-US/docs/WebAssembly/Using_the_JavaScript_API)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
