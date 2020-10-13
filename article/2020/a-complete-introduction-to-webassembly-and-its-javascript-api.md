> * 原文地址：[A Complete Introduction to WebAssembly and It’s JavaScript API](https://blog.bitsrc.io/a-complete-introduction-to-webassembly-and-its-javascript-api-3474a9845206)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/a-complete-introduction-to-webassembly-and-its-javascript-api.md](https://github.com/xitu/gold-miner/blob/master/article/2020/a-complete-introduction-to-webassembly-and-its-javascript-api.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)
> * 校对者：

# WebAssembly 及其 JavaScript API 的完整介绍

![[Louis Hansel @shotsoflouis](https://unsplash.com/@louishansel?utm_source=medium&utm_medium=referral) 发布于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*HV8EPAnwvRa8_4JH)

自计算机诞生以来，原生应用程序的性能有了很大的提高。相比之下，由于 JavaScript 最初不是为了运行速度而创造的，因此 web 应用程序非常慢。但是，由于浏览器之间的激烈竞争以及诸如 V8 之类的 JavaScript 引擎的快速发展，使 JavaScript 能够在计算机上快速运行。但是它仍然无法超越原生应用程序的性能。这主要是由于 JavaScript 代码必须经过多个过程才能生成机器代码这一事实。

![JS 引擎各阶段平均耗时统计 — 来自于: [Lin Clark](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/fd3c55e9-3dda-473b-a76b-0ba4d0e039ad/08-diagram-now01-large-opt.png)](https://cdn-images-1.medium.com/max/2400/0*bGwF1hjg50k_o2C0.png)

随着 WebAssembly 的到来，我们所知道的作为现代网络的一切都有望发生革命性的变化。这项技术运行速度非常快。让我们看一下什么是 WebAssembly，以及如何与 JavaScript 集成以构建运行速度惊人的应用程序。

## 什么是 WebAssembly?

**在理解 WebAssembly 之前，让我们先看看什么是汇编（Assembly）。**

汇编语言是一种低级编程语言，与底层的机器指令有非常密切的联系。换句话说， 汇编就是将这种语言转换为机器可理解的代码 (称为机器码) 的一个过程。

**WebAssembly** 可以简单地理解是在 web 使用的汇编语言。它是一种低级的类似汇编的语言，具有紧凑的二进制格式，使您能够以接近原生的速度运行 web 应用程序。它还为诸如 C、C + + 和 Rust 之类的语言提供了编译目标，从而使客户端应用程序能够以近乎原生的性能在 web 上运行。

此外，WebAssembly 旨在与 JavaScript 一起运行，而不是替换它。使用 WebAssembly JavaScript api，您可以交替地来回运行来自任一语言的代码，而不会出现任何问题。这为您提供了利用 WebAssembly 的功能和性能以及 JavaScript 的多功能性和适应性的应用程序。这开启了一个全新的 web 应用程序世界，该应用程序可以运行最初不打算用于 web 的代码和功能。

## WebAssembly 有何不同

[Lin Clark](https://www.smashingmagazine.com/author/linclark/) 预测在2017年引入 WebAssembly 可能会在 web 开发的生命中引发一个新的拐点。这一事件发生在现代浏览器中引入 JIT 编译导致的拐点之后，这种拐点将 JavaScript 的速度提高了近10倍。

![JavaScript 性能统计 — 来自于: [Lin Clark](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f5961531-2863-4e2a-afac-a3fafd927aa2/03-perf-graph10-large-opt.png)](https://cdn-images-1.medium.com/max/2400/0*Py-XN25Ym7msk12v.png)

如果仔细比较 JavaScript 与 WebAssembly 代码编译为机器码过程，可以明显看到在 WebAssembly 的编译过程中有多个过程被剥离了出来，同时还有几个过程被去掉了。下面是两个编译过程的对比。

![JS 代码编译与 WebAssembly 代码编译过程大致对比 — 来自于: [Lin Clark](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/01483767-04a0-4438-be58-f7e6512f1b39/10-diagram-future01-large-opt.png)](https://cdn-images-1.medium.com/max/2400/0*A4PPwrXlDXzU4rpL.png)

如果仔细比较以上两个过程，您会注意到 WebAssembly 中的重新优化部分已被完全剥离。这主要是因为编译器不需要对WebAssembly代码做出任何假设，因为代码中明确提到了诸如数据类型之类的事情。

但是 JavaScript 并非如此，因为 JIT 应该做出假设来运行代码，如果假设失败，它应该重新优化其代码。

## 如何获取 WebAssembly 代码

接下来的才是开发者要面临的最重要的问题。WebAssembly 是一项非常伟大的技术，那开发者应该如何充分使用它的能力呢？

有如下几种使用方法。

* 从头开始编写 WebAssembly 代码-除非您非常了解基础知识，否则不建议这样做。
* 从 C 编译到 WebAssembly
* 从 C++ 编译到 WebAssembly
* 从 Rust 编译到 WebAssembly
* 使用 [AssemblyScript](https://github.com/AssemblyScript/assemblyscript) 将严格变体版的 Typescript 编译到 WebAssembly。对于不熟悉 C/C++ 或 Rust 的 web 开发人员来说，这是一个很不错的选择。
* 同时还支持更多的语言编译可供选择，下面将会讲到。

此外，还有一些工具，例如 [Emscripten](https://emscripten.org/) 和 [WebAssembly Studio](https://webassembly.studio/) 可以帮助完成上述代码编译的过程。

## JavaScript 的 WebAssembly API

为了充分利用 WebAssembly 的特性，我们必须将其与 JavaScript 代码集成。这可以借助 JavaScript WebAssembly API 来实现。

#### 模块编译和实例化

WebAssembly 代码位于后缀名为 `.wasm` 的文件中，这个文件需要在客户端被编译至应用运行时所在系统对应的机器码。可以通过 `WebAssembly.compile` 方法来编译 WebAssembly 模块。接收到编译好的 WebAssembly 模块后可以使用 `WebAssembly.instantiate` 方法来将其实例化。或者，也可以通过将获取到的 `.wasm` 文件内容转换为 ArrayBuffer 传递至 `WebAssembly.instantiate` 的方式来进行实例化。

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

还有另外一种方法，使用 `WebAssembly.compileStreaming` 和 `WebAssembly.instantiateStreaming` 方法来实现上面编译、实例化的功能，这种方式的优点是能够直接访问字节码，而无需先将文件内容转换为 `ArrayBuffer`

```js
let exports;

WebAssembly.instantiateStreaming(fetch('sample.wasm'))
.then(obj => {
  exports = obj.instance.exports;
})
```

值得注意的是上述两种实例化 WebAssembly 模块的方法都会返回编译好的模块实例对象，以便加速模块实例的唤起。

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

导入对象可以理解为是想模块实例上附加的一系列用于实现特定功能的辅助工具方法，如果未提供导入对象，编译器将会分配默认值。

####  全局变量（Globals）

WebAssembly 可以创建可从 JavaScript 和 WebAssembly 模块访问的全局变量，并且可以导入、导出这些变量，同时可以在一个或多个 WebAssembly 模块实例中使用它们。

可以使用构造函数 `WebAssembly.Global()` 来创建全局变量实例。

```js
const global = new WebAssembly.Global({
    value: 'i64',
    mutable: true
}, 20);
```

该构造函数接收两个参数，分别如下：

* 第一个参数是一个对象，其 value 属性表示表示值的类型，其 mutable 属性表示值是否可以修改，允许的值类型有：`i32`、`i64`、`f32` 和 `f64`；
* 第二个参数是变量的值，并值的类型必须与第一个参数中指定的类型一致，例如：如果参数一中类型是 `i32`，则值的类型必须是 32 位整数，如果参数一中类型是 `f64`，则值的类型必须是 64 位浮点型。

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

####  内存（Memory）

At the point of instantiation, the WebAssembly module would need a memory object allocated. This memory object should be passed with the `importObject`. If you fail to do so, the JIT compiler would create and attach a memory object to the instance automatically with the default values.

The memory object attached to the module instance would simply be an `ArrayBuffer`. This enables for easy memory access by simply using index values. Furthermore, because of being a simple `ArrayBuffer` , values can simply be passed and shared between JavaScript and WebAssembly.

#### 表（Table）

A WebAssembly Table is a resizable array that lives outside of the WebAssembly’s memory. The values of the table are function references. Although this sounds similar to the WebAssembly Memory, the major difference between them is that Memory array is of raw bytes while the Table array is of references.

The main reason for the introduction of Table is improved security.

You can use the methods `set()` , `grow()` , and `get()` to manipulate your table.

## 一个示例

For my demonstration, I will be using the WebAssembly Studio application to compile my C file into `.wasm` . You can have a look at the demo over [here](https://webassembly.studio/?f=wne209a6cxq).

I have created a function to calculate the power of a number in the `wasm` file. I am passing the necessary values to the function and receiving the output in JavaScript.

Similarly, I am doing some string manipulation in `wasm` . You must note that `wasm` does not have a type for strings. Hence it will work with the ASCII values. The value returned to the JavaScript would be pointing the memory location where the output is stored. Since the memory object is an ArrayBuffer, I am iterating until I receive all of the characters in the string.

**JavaScript file**

```js
let exports;
let buffer;
(async() => {
  let response = await fetch('../out/main.wasm');
  let results = await WebAssembly.instantiate(await response.arrayBuffer());
  //or
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

**C file**

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

## Use Cases

The introduction of WebAssembly opened up a world of opportunities.

* **Ability to use existing libraries/code written in languages such as C/C++ in the web environment.**

For example, if you were unable to find a library for JavaScript that implements a certain functionality, you would have to write the library from scratch and implement it. But if you can find a library that implements the same functionality, but written in a different language, you can use the power of WebAssembly to run it in your web app. This is a major breakthrough as it would save lots of time from the developers perspective.

The [Squoosh](https://squoosh.app/) app uses WebAssembly to fulfil its QR and image detection functionality. This allowed them to support these, even on older browsers, with native-like speeds. Furthermore, [eBay](https://tech.ebayinc.com/engineering/webassembly-at-ebay-a-real-world-use-case/) was able to implement barcode scanning functionality to their web application by compiling the C++ library used it it’s native applications, into WebAssembly.

* **Run fully native applications written in languages like C, C++, Rust to run on the web, with little modifications to the code. The performance also would be near-native.**

Applications like [AutoCAD](https://www.autodesk.com/products/autocad-web-app/overview?linkId=68719474), [QT](https://www.qt.io/qt-examples-for-webassembly), and even [Google Earth](https://medium.com/google-earth/earth-on-web-the-road-to-cross-browser-7338e0f46278) were able to run their applications with near-native performance with little modifications to their codebase. This was only possible due to the power of WebAssembly.

* **Use libraries written in languages such as C, C++ or Rust, even if you have similar libraries in JavaScript as the WebAssembly code can run very fast, and can offer better quality.**

Team Google was able to compile different encoders from languages such as C and C++ into their [Squoosh](https://squoosh.app/) app and replace regular codecs such as JPEG with MozJPEG. These new replacements offered smaller file sizes without sacrificing the visual quality of the images.

#### Languages supported

WebAssembly support is not limited only to C, C++ and Rust. Many developers are trying hard to include support for other languages too. Here is a list of languages supported currently.

* C/C++
* [Rust](https://developer.mozilla.org/en-US/docs/WebAssembly/Rust_to_wasm)
* [AssemblyScript (a TypeScript-like syntax)](https://docs.assemblyscript.org/)
* [C#](https://docs.microsoft.com/en-us/aspnet/core/blazor/get-started?view=aspnetcore-3.1&tabs=visual-studio)
* [F#](https://fsbolero.io/docs/)
* [Go](https://golangbot.com/webassembly-using-go/)
* [Kotlin](https://kotlinlang.org/docs/reference/native-overview.html)
* [Swift](https://swiftwasm.org/)
* [D](https://wiki.dlang.org/Generating_WebAssembly_with_LDC)
* [Pascal](https://wiki.freepascal.org/WebAssembly/Compiler)
* [Zig](https://ziglang.org/documentation/master/#WebAssembly)

---

## Criticisms

The introduction of WebAssembly that allowed execution in compiled binary, raised a lot of questions amongst the security aspects. The [vulnerabilities can be exploited](https://www.virusbulletin.com/virusbulletin/2018/10/dark-side-webassembly/) without even a trace and that can be really hard to detect. Although WebAssembly is equipped with its own security features, I personally believe they need to be further improved. With the newer features, older traditional protection such as antivirus tools and URL filtering are not able to cope at all. This would mean that regular browsers will be even less secure in the future.

You can read more about these issues below.

- [The dark side of WebAssembly](https://www.virusbulletin.com/virusbulletin/2018/10/dark-side-webassembly/)
- [Research: More Worries with Wasm - Security Boulevard](https://securityboulevard.com/2020/01/research-more-worries-with-wasm-3/)
- [Security](https://webassembly.org/docs/security/)

## Conclusion

There is speculation that WebAssembly would replace JavaScript. But it quite false I must say. WebAssembly was created to co-exist with JavaScript, not to replace it. Furthermore, debugging JavaScript is easier than WebAssembly and the expressive freedom of JavaScript cannot be employed in Wasm.

With everyone's high expectations, it is safe to say that you will be amazed by the genre of applications WebAssembly can pave the way to.

> “No one can say for sure what kinds of applications these performance improvements could enable. But if the past is any indication, we can expect to be surprised“ — Lin Clark

## Resources

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
