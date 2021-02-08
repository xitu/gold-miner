> * 原文地址：[Should You Compile Your JavaScript Code?](https://blog.bitsrc.io/should-you-compile-your-javascript-code-a857ad2e3032)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/should-you-compile-your-javascript-code.md](https://github.com/xitu/gold-miner/blob/master/article/2021/should-you-compile-your-javascript-code.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[zenblo](https://github.com/zenblo)、[Ashira97](https://github.com/Ashira97)

# 你应该编译你的 JavaScript 代码吗？

![Image by [seznandy](https://pixabay.com/users/seznandy-15803435/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=5093898) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=5093898)](https://cdn-images-1.medium.com/max/3840/1*_7N-LnDFVgKcgEgzczZVmg.jpeg)

我们都会也都喜爱 JavaScript，并且我们都通过编写代码和在我们最爱的运行环境（通常是浏览器，Node.js 和 Deno）中来执行 JavaScript 代码。但你是否曾经尝试过去编译你的 JavaScript 代码呢？

不对，等一下，我们都知道 JavaScript 是一门动态语言啊！其实它同样也会被解析，但是与常见的运行时大不相同，它是会在运行时被一个 [JIT 编译器](https://blog.bitsrc.io/the-jit-in-javascript-just-in-time-compiler-798b66e44143)优化的。

这可是事实！

但它能够被编译吗？这两个问题可不搭边呢！在运行之前编译一款动态语言（或称为 AOT，运行前编译）是可能的，这是当然的。但我们真的值得去这样做吗？

## AOT vs JIT

**首先让我们再走进 AOT 和 JIT（要不然这文章也太短太水了。当然其实还有别的相关的能够帮助你的内容可能会被你所找到）**

AOT 和 JIT 最主要的区别是它们所作用的时间。AOT 是在你的代码的执行之前运行的，而 JIT 是与你的代码的执行同时进行的。还有什么不同吗？

几乎全都不同啊！

AOT 通常是为那些静态语言所使用的，因为对于他们而言，没有什么需要在运行时判断和决定的动态行为。所有的规则都已经摆在代码中了，编译器可以很简单地阅读这些内容，明白其中的数据流并且有针对性的对其进行优化，并同时将这些代码转译为原生的解析语言（也叫做机器指令）.

JIT 呢，则是与之相对，一般用于动态语言，因为它会侦测代码的执行并且基于它所控制的数据的类型，会对其优化并创造一个更好的机器指令。

如果让我们来就这些实时优化来考虑编译代码的进行优化的时间吧，AOT 会在一开始就为你提供一份最优化的代码，而你会直接执行这一份最优化的代码。但对于 JIT 而言，他会在代码运行过程中先耗费一段时间去计算分析这段代码，但会在潜在地在代码的后续执行中能够因为[这个原因](https://blog.bitsrc.io/the-jit-in-javascript-just-in-time-compiler-798b66e44143)更多地节省和优化。它有更多去优化的角度，而不仅仅只是针对于类型定义上（例如函数的调用就只能在运行时优化）。

对于每一种方案当然都有它们的优劣，但如果你想要概述并决定其中之一，我大概会说：

* 如果你的代码只需要运行短时间，那就用 AOT 吧。
* 如果你的代码会运行地比较长时间，那么就用 JIT 吧，这样可以让你的代码在一些运行时分析后获得更好的优化。

## 那么对于编译你的 JavaScript ？

同样的，为什么 JavaScript 是被解析并且 JIT 并不能直接去编译 JavaScript 为机器代码的原因：JavaScript 的动态功能让它在实时编译中更占优势。

但需要注意的是，我并没有提及 [WebAssembly](https://blog.bitsrc.io/whats-wrong-with-web-assembly-3b9abb671ec2) 。事实上在哪些情况下，WASM 将所有代码（C、C++ 或别的什么语言的代码）编译为一个 JavaScript 运行时兼容的原生代码。这与编译 JavaScript 可不是一个东西。

事实上，并没有那么多项目正在尝试去编译 JavaScript 代码为机器指令，因为我可以确定这是个很大的挑战 —— 我指的是，例如让我们编译下面的代码：

```js
let result = null;
if (my_complex_function()) {
    result = 10;
} else {
    result = "something else";
}
console.log("The result is " + result);
```

你真的在运行之前能够判定 `result` 变量的类型吗？你可能需要先在心中思考一下所有可能的类型，并且同时将不同的情况判断一遍。即便你解决了这个问题，你依旧添加了不少的逻辑到你的思考与判断之中。这听起来可并不那么好啊！

事实上，有一个专门解决这个问题的项目，尽管不一定是最佳的（至少在纸面上）：[NectarJS](https://github.com/NectarJS/nectarjs)

## 通过使用 NectarJS 进行编译

该项目旨在将 JavaScript 代码编译为机器指令，以便让我们可以在任何兼容的平台上运行它。现在，兼容的名单包括了 Windows、Linux、Arduino、[STM32 Nucleo](https://www.st.comenevaluation-toolsstm32-nucleo-boards.html)、Android、Web（[WASM](https://www.st.com/en/evaluation-tools/stm32-nucleo-boards.html), Android, Web ([WASM](https://blog.bitsrc.io/whats-wrong-with-web-assembly-3b9abb671ec2)）、macOS 和 SunOS。

虽说实际上上述所有的平台基本上都有对应的，用于运行你的 JavaScript 代码的解析器，这个项目能够让最终的编译输出一个比当前可用编译器输出的更优化的一个输出。

针对它们输出的结果而言，它们早已对 Windows 上 Node.js 的 v12 有了一些优化。在某些情况下并不是提升速度，而是内存的使用甚至是输出文件的大小。

![NectarJS’ 网站上的一份表格](https://cdn-images-1.medium.com/max/3036/1*HyX7ShDvXey6u9mo9_3ezg.png)

当然，该项目仍然有其局限性，特别是到目前为止，该项目仅支持大约 80％ 的 ES3 标准，这意味着您可以编写的 JavaScript 代码是非常有限且不符合当今的标准的。

但是，对于你的某些项目而言你并不一定要编写兼容 ES6 的代码。而且能够去编译这些代码，并原生地在你的 Arduino 开发板上面运行这些代码，可能真的会是非常好用的

但是话又说回来，对于特定项目而言，你可能并不需要在其中编写兼容 ES6 的代码，并且在对其进行编译并在 Arduino 板上本地运行这段代码的情况下它可能会派上用场。

#### 安装并测试 NectarJS

这个项目可以直接以一个 NPM 模块的形式被安装到你的计算机，所以你所需要做的仅仅是运行下面这行代码（这里默认了你已经安装了 Node 环境）：

```

$ npm install nectarjs -g

```

在安装并同时设置或导入了[必要的依赖](https://github.com/NectarJS/nectarjs/blob/master/docs/ADVANCED_USAGE.md#requirements-and-compilation)以后，你就可以简单的编写一段 HelloWorld 代码并编译这段代码：

```JavaScript
console.log("Hello 编译过的 world！")
```

要去编译这段代码，简简单单的使用这段指令即可：

```
$ nectar your-file.js
```

这就是我在我的 macOS 系统上能够获得的输出：

![](https://cdn-images-1.medium.com/max/2028/1*7i_ihlwJ8Kx49n7v3wrePw.png)

需要注意的是，被创建的文件并没有一个拓展名 —— 它是一个二进制文件。如果你给予它执行的权限，你就能够执行这段代码。这很简单，并且它能够正常工作。

---

## 这就是 JavaScript 的未来吗？

就我个人而言我不会为之打赌。这个项目本身也还在初期，拥有着不完善的文档，并且只有对旧语言的部分支持。但是，它目前正处于活跃的开发状态并且这些可以在快速地变化。

对于编译 JavaScript 做法的推广，我并不认为会是一个很大的趋势，毕竟事实证明了，现有的运行时已经足以满足最常见的使用情况。对于希望拥有原生性能并且不愿意切换到其他技术的朋友来说，编译 JavaScript 真的有用吗？这当然有用，但这只是 JavaScript 广泛用途的其中一种情况。

你会考虑编译你的 JavaScript 代码吗？发表一下你的看法吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
