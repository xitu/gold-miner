> * 原文地址：[V8 Gets a Non-Optimizing Compiler Stage to Improve Performance](https://www.infoq.com/news/2021/06/v8-sparkplug-compiler/)
> * 原文作者：[Sergio De Simone](https://www.infoq.com/profile/Sergio-De-Simone/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/v8-sparkplug-compiler.md](https://github.com/xitu/gold-miner/blob/master/article/2021/v8-sparkplug-compiler.md)
> * 译者：[CarlosChenN](https://github.com/CarlosChenN)
> * 校对者：[Chorer](https://github.com/Chorer)，[PassionPenguin](https://github.com/PassionPenguin)

# V8 引入了新的非优化编译器以提高性能

最新版本的 JavaScript V8 引擎，V8 9.1 ，引入一个过渡编译阶段，叫 [Sparkplug ](https://v8.dev/blog/sparkplug) 。据 V8 开发者 [Leszek Swirski](https://twitter.com/leszekswirski) 介绍，它能在现实基准中提升 5~15% 的性能。它会在即将发布的 Chrome 91 中正式使用。

旧的 V8 架构中包括了两个阶段： Ignition （一个 JavaScript 解释器），和 TurboFan （一个高度优化的编译器），Ignition 使用 JavaScript 抽象语法树去生成 V8 字节码，而 TurboFan 使用这些字节码生成机器码。引入 Sparkplug 的原因，在  [Sparkplug 设计](https://docs.google.com/document/d/1NeOsqjPPAcDWbuHxW5MobzVQgj9qZd6NqKUnz0h-fOw/edit) 的概述中有详细的解释。

> 在 Ignition 和 TurboFan 之间有一个巨大的性能差异；长时间驻留在解释器中，意味着我们无法获得优化的好处，但是太早调用 TurboFan 又意味着，我们在优化那些不属于热点代码的函数，甚至更糟，它意味着我们在做些不必要的事。我们可以用一个简单且快速的非优化编译器去缩小这个差距，这样可以通过线性遍历字节码并吐出机器码，快速地、低成本地从解释器中分层。我们叫这个编译器为 Sparkplug 。

在引入 Ignition 和 TurboFan 之前，V8 曾经使用一个快速即时编译器，叫 Full-CodeGen（FCG）。正如 Leszek [在黑客新闻中解释](https://news.ycombinator.com/item?id=27307862) 到，新的解释器架构 Ignition 抛弃了这种编译器，不再包含 FCG 。

> 一个大的不同是，Sparkplug 是从字节码中编译的，而不是源码，因此，字节码才是程序的真实来源。回到 FCG 时代，做优化的编译器必须重解释源码成抽象语法树，然后从那里编译，甚至更糟，能反优化退化至 FCG ，它不得不有点像重复 FCG 编译去纠正错选的栈帧。

Leszek [提到](https://news.ycombinator.com/item?id=27312037) FCG 被抛弃而不是改进的原因是它巨大的技术负担，特别是与 Sparkplug 编译器和 FCG 不得不从源码编译，然后把输出提供给 TurboFan 有关，因为这导致了各种各样的复杂情况。这同样也[让 FCG 更难跟上 JavaScript 的新特性](https://v8project.blogspot.com/2017/05/launching-ignition-and-turbofan.html) 。

Swirski 称，Sparkplug 的速度来源于两个因素。首先，它依赖于 TurboFan 生成的字节码，这意味着大量的工作已经完成了，包括变量解析、判断圆括号是否是箭头函数、为解构声明语句进行脱糖等等。此外，Sparkplug 并不生成任何中间产物，而是在一个单一的线性通道中输出机器码。这种方式意味着 Sparkplug 不能做任何基于中间产物的高级优化，它必须全面移植到每个新的平台上。

在性能方面，Sparkplug 改进了 [Speedometer](https://browserbench.org/Speedometer2.0) 以及 V8 团队使用的一组现实的基准测试。根据测试机器和网站的不同，性能的提高范围在 5~15% 之间。谷歌尚未发布各种管道组件性能的官方低级基准。不过 Leszek [在这解释过](https://news.ycombinator.com/item?id=27308038) ：

> 编译时间和 Ignition 编译器大致相同（因为只是抽象语法树到字节码，不包括解析），大概比 TurboFan 快二到三个量级。正如评论里所指出的，解释器的相对性能会由于工作量的不同而产生很大的差别，在不完全由属性负荷来控制的情况下，大概 4 倍就算是个不错的近似值了。

据 V8 的设计者说，除了性能，Sparkplug 带来的另一个关键收益是减少 CPU 的占用，而这可以减少移动设备的电量消耗，还可以减少按周期付费服务器的费用。

正如提及到的，Sparkplug 会在 [Chrome 91 中推出](https://developer.chrome.com/blog/new-in-chrome-91/) 所以，你很快就能自己体验一下。如果你对 Sparkplug 的内核细节，以及它与 Ignition 和 TurboFan 的联系感兴趣。那么千万不要错过 Swirski 的文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
