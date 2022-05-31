> * 原文地址：[What Replaces JavaScript](https://medium.com/young-coder/what-replaces-javascript-a6493b4e2d6e)
> * 原文作者：[Matthew MacDonald](https://medium.com/@prosetech)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-replaces-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-replaces-javascript.md)
> * 译者：[cyz980908](https://github.com/cyz980908)
> * 校对者：[江五渣](https://github.com/JalanJiang),[Chorer](https://github.com/Chorer)

# 什么将会替代 JavaScript 呢？

> JavaScript 正在蓬勃发展。但由于 WebAssembly 的出现，它的衰落可能只是一个时间问题。

![隧道的尽头 / [[Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=20180)]](https://cdn-images-1.medium.com/max/2560/1*KYJN2ynQlUSsGuhdpau0_A.jpeg)

有些编程语言很受欢迎。而有些只是被开发人员被迫接受。对于许多程序员来说，JavaScript 就是后者中的一个例子，每个前端开发人员都需要学习和理解这种语言，但是却没有人喜欢它。

十年前，JavaScript 还没有统治世界的迹象。其他的平台，像 Java，Flash 和 Silverlight 也依然在被我们使用。以上三个平台都需要运行在一个浏览器插件中，且三者都用一种不同的用户界面替换了 HTML。这种方法使它们在功能特性方面远远领先于 JavaScript —— 例如，早在 `\<video>` 元素、CSS 动画或 HTML canvas 之前，我们就能使用它们添加视频、动画和绘图。但这也意味着它们的衰落。当移动浏览爆炸式增长，HTML 转向拥抱移动浏览器时，这些平台也已过时。

讽刺的是，就在 JavaScript 征服世界的同时，一颗小小的种子被播下。它将在未来的某个时候，宣告 JavaScript 的终结。这颗种子就是一种叫 asm.js 的实验技术。

但是介绍它之前，我们还是退一步来审视当下的形势。

## 转码：目前的做法

自从我们有了 JavaScript，开发人员就一直试图避开它。一种早期的方法是使用插件将代码从浏览器中取出。（该方法失败。）另一种想法是开发可以转换代码的开发工具，将用另一种更受欢迎的语言编写的代码**转换**成 JavaScript。这样，开发人员就可以如愿地让代码到处运行，同时又能避免弄脏双手。

把一种语言转换成另一种语言的过程叫做**转码**，但这个过程并非一帆风顺。高级语言有不同的特性、语法和习惯用法，你不能单纯直接地映射到另一个等价的结构上。就算你可以，这也是有潜在危险的。如果社区停止开发你最喜欢的转码器怎么办？或者如果转码器引入了自己的 bug 怎么办？如果要插入 Angular，React 或 Vue 这样的 JavaScript 框架怎么办？如果你在团队中不使用相同的语言开发，你又将如何与团队合作呢？

如同许多开发案例一样，一个工具的好坏取决于它背后的社区。

![](https://cdn-images-1.medium.com/max/2000/1*APeN4y8dugBc7C56ldFT9A.png)

如今，转码器已经是再常见不过了，但它们的用途往往只有一种 —— 处理向后兼容性。

开发人员都是尽可能使用最新的 JavaScript 版本，然后使用类似 [Babel](https://babeljs.io/) 之类的转码器将他们的代码转换成同等的（但不那么优雅的）旧版本 JavaScript 代码，这样代码就可以兼容所有的运行环境。或者更好的是，他们使用 TypeScript（一种添加了强类型、泛型和不可为空类型等特性的现代化 JavaScript）并将 **TypeScript** 转换成 JavaScript。无论哪种方式，你都是在 JavaScript 这片小花园里打转。

## Asm.js：一块垫脚石

一种新的可能性的曙光来自于 2013 年，Mozilla 的开发人员做的一个独特实验 —— asm.js。他们那时正在寻找一种在浏览器中运行高性能代码的方法。但与插件不同的是，asm.js 并没有试图与浏览器为邻。相反，它的目标是**直达** JavaScript 虚拟机。

从本质上讲，asm.js 是一种简洁、优化的 JavaScript 语法。它比普通的 JavaScript 运行得更快，因为它避开了语言中缓慢的动态部分。但是，意识到这一点的 web 浏览器也可以应用其他方法优化，从而大大提高性能。换句话说，asm.js 遵循了黄金法则 —— **不要破坏** web，同时还提供了未来改进的方法。Firefox 团队借助 asm.js 和一款叫做 [Emscripten](https://en.wikipedia.org/wiki/Emscripten) 的转换工具，把用 C++ 构建的实时 3D 游戏放到了 web 浏览器中，只需要 JavaScript 和一颗初心便可畅玩。

![运行在 asm.js 上的虚幻引擎](https://cdn-images-1.medium.com/max/2000/1*fJ0vTYKZy2na-qFu11d4nQ.png)

asm.js 最重要的部分是它迫使开发人员重新思考 JavaScript 的作用。Asm.js 代码**是** JavaScript 代码，但这不意味着程序员应该手动编写和操作 asm.js 代码。相反，asm.js 代码应该由自动化过程（一个转码器）构建，并直接提供给浏览器。JavaScript 是中间的媒介，而不是最终传递的信息。

## WebAssembly：一项新的技术

尽管 asm.js 实验产生了一些耀眼的演示，但它在很大程度上被工作的开发人员忽略了。对他们来说，这只是另一项有趣的新兴技术。但随着 WebAssembly 的诞生，这一切都改变了。

WebAssembly 既是 asm.js 的接班人，同时又是一项截然不同的技术。它是一种紧凑的二进制代码格式。与 asm.js 一样，WebAssembly 代码也被输入到 JavaScript 执行环境中。它们俩具有相同的沙箱和相同的运行时环境。与 asm.js 一样，WebAssembly 的编译方式使得更进一步的效率提升成为可能。但是现在的效率就已经[比以前快多了](https://hacks.mozilla.org/2017/02/what-makes-webassembly-fast/)了，浏览器可以完全跳过 JavaScript 解析阶段。对于一个普通的逻辑位来说（例如，耗时的计算），WebAssembly 的速度远远快于常规的 JavaScript，几乎与本机编译的代码一样快。

![简化版的 WebAssembly 处理过程管道](https://cdn-images-1.medium.com/max/2000/1*IKpcysxZoB5yYyLV5JmQaQ.png)

如果你想知道 WASM 写起来是什么样的，那么你可以想象一下你有这样一个 C 函数：

```c
int factorial(int n) {
  if (n == 0)
    return 1;
  else
    return n * factorial(n-1);
}
```

它将被编译成如下所示的 WASM 代码：

```WebAssembly
get_local 0
i64.eqz
if (result i64)
    i64.const 1
else
    get_local 0
    get_local 0
    i64.const 1
    i64.sub
    call 0
    i64.mul
end
```

当通过网络发送时，WASM 代码被进一步压缩成二进制编码。

WebAssembly 的定位是编译器。你永远不会手写它。（但是，如果你想进行[深入的探索](https://blog.scottlogic.com/2018/04/26/webassembly-by-hand.html)，你当然**可以去做**。）

WebAssembly 首次出现在 2015 年。今天，桌面和移动设备上的四大浏览器完全支持它（Chrome，Edge，Safari 和 Firefox）。它在 Internet Explorer 中不受支持，尽管将 WebAssembly 代码转换为 asm.js 可以实现向后兼容。（性能将会受到影响，拜托请让 IE [消失](https://death-to-ie11.netlify.com/)吧！）

## WebAssembly 和网站开发的未来

WebAssembly 开箱即用，为开发人员提供了一种通常使用 C++ 编写优化代码例程的方法。这是个强大的功能，但是使用范围有限。如果你需要提高复杂计算的性能，这将很有用。（例如，fastq.bio 使用 WebAssembly [加快](https://www.smashingmagazine.com/2019/04/webassembly-speed-web-app/)了他们的 DNA 测序计算。）如果你需要移植高性能游戏或编写在浏览器中运行的[模拟器](https://win95.ajf.me/) ，那么 WebAssembly 你值得拥有。如果这就是 WebAssembly 的全部功能，那就太没意思了 —— 它也将不会有取代 JavaScript 的希望。WebAssembly 还为其他框架开发人员提供了一条小路，使得框架开发人员可以将其平台压缩到 JavaScript 环境中。

事情在这里发生了有趣的转变。WebAssembly 不能是脱离 JavaScript 的，因为它被锁定在 JavaScript 运行环境中。实际上，WebAssembly 至少需要与**一些**普通的 JavaScript 代码一起运行，因为它无法直接访问页面。这意味着，如果不经过 JavaScript 层，它就无法操纵 DOM 或接收事件。

这听起来像是一个要突破原则的限制。但是，聪明的开发人员已经找到了在 WebAssembly 中偷偷搬运运行环境的方法。例如，Microsoft 的 [Blazor](https://dotnet.microsoft.com/apps/aspnet/web-apps/blazor) 框架，下载一个小型 .NET 的运行环境作为编译后的 WASM 文件。这个运行环境处理 JavaScript 的互操作，并提供基本服务（如垃圾收集）和更高级的功能（布局、路由和用户界面小部件）。换句话说，Blazor 使用了一个存在于另一个虚拟机中的虚拟机。这既可以说是一个令人费解的悖论，也可以说是一种创建在浏览器中运行的非 JavaScript 应用程序框架的聪明方法。

Blazor 并不是唯一一个由 WebAssembly 支持的实验。以 [Pyodide](https://hacks.mozilla.org/2019/04/pyodide-bringing-the-scientific-python-stack-to-the-browser/) 为例，它的目标是将 Python 放到浏览器中，并提供用于数据分析的高级数学工具包。

**这**就是未来。WebAssembly 一开始只是为了满足 C++、Rust 的需求，但很快就被用于创建一些更有野心的实验。不久后，它将会带来那些非 JavaScript 框架与基于 JavaScript 的标准框架（如 Angular、React 和 Vue）同台竞技的机会。

而且 WebAssembly 仍在迅速发展。它目前的实现是一个**最小可行性的产品** —— 仅能够在一些重要的场景中发挥作用，而不是在 web 上开发的通用方法。随着 WebAssembly 的逐步普及，这个现象将得到改善。例如，如果像 Blazor 这样的平台流行起来，WebAssembly 可能会支持直接访问 DOM。现在，浏览器制造商们已经在计划添加垃圾回收和多线程的机制，有了 WebAssembly，运行环境这些细节他们也不需要自己实现。

如果你认为这条 WebAssembly 的发展之路看起来漫长而且令人怀疑，那么想想 JavaScript 的例子吧。首先，我们看到，如果有些事情 JavaScript 可以做到，那么它就会被完成。然后，我们了解到，如果浏览器频繁做某件事，那么浏览器会让它工作得更高效更好，等等。所以说，如果 WebAssembly 流行了，它将进入一个良性循环的发展过程，并且很容易超越 JavaScript 的固有优势。

人们常说，WebAssembly 不是用来替代 JavaScript 的。但这适用于之前的每一个发生革命性改变的平台。JavaScript 不是用来取代浏览器嵌入 Java 的。Web 应用程序也不是为了取代桌面应用程序而设计的。但一旦它们可以，它们就会替代。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
