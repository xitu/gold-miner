> * 原文地址：[V8 Gets a Non-Optimizing Compiler Stage to Improve Performance](https://www.infoq.com/news/2021/06/v8-sparkplug-compiler/)
> * 原文作者：[Sergio De Simone](https://www.infoq.com/profile/Sergio-De-Simone/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/v8-sparkplug-compiler.md](https://github.com/xitu/gold-miner/blob/master/article/2021/v8-sparkplug-compiler.md)
> * 译者：[CarlosChenN](https://github.com/CarlosChenN)
> * 校对者：

# V8 有个非优化的编译阶段去提高性能


最新版本的 JavaScript V8 引擎， V8 9.1 ，引用一个过渡编译阶段，叫[火花塞](https://v8.dev/blog/sparkplug) ，据 V8 开发者[Leszek Swirski](https://twitter.com/leszekswirski) 称，它能在现实基准中提升 5-15% 的性能。它会在即将发布的 Chrome 91 中支持。

旧的 V8 架构中包括了两个阶段：点火装置（一个 JavaScript 解释器），和涡扇（一个高度优化的编译器），点火装置使用 JavaScript 抽象语法树去生成 V8 字节码，而涡扇使用这些字节码生成机器码。引用火花塞的原因，在 [火花塞设计](https://docs.google.com/document/d/1NeOsqjPPAcDWbuHxW5MobzVQgj9qZd6NqKUnz0h-fOw/edit) 的概述中有详细的解释。

> 点火装置和涡扇之间有一个巨大的性能差异；长时间呆在解释器中，意味着我们无法在优化上占到便宜，而且太早调用涡扇也许意味着，我们在不紧急的函数优化上浪费时间，甚至更糟，它意味着，我们在做些不必要的事。我们可以用一个简单的，快速的未优化的编译器去缩小这个差距，这样可以通过线性遍历字节码并吐出机器码，快速的，低成本地从解释器中分层。我们叫这个编译器为火花塞。

在引进点火装置和涡扇之前， V8 曾经使用一个快速即时编译器，叫 Full-CodeGen (FCG) 。正如 Leszek [在黑客新闻中解释](https://news.ycombinator.com/item?id=27307862) 到，它在支持新解释器体系结构中被抛弃了，也就是点火装置，它不包含 FCG 。

> 一个大的不同是，火花塞是从字节码中编译的，而不是源码，因此，字节码才是程序的真实来源。回到 FCG 时代，做优化的编译器必须重解释源码成抽象语法树，然后从那里编译，甚至更糟，能反优化退化至 FCG ，它不得不有点像重复 FCG 编译去纠正错选的栈帧。

Leszek [提到](https://news.ycombinator.com/item?id=27312037) FCG 被抛弃而不是改进的原因是它巨大的技术负担，特别是与火花塞编译器和 FCG 不得不从源码编译，然后把输出提供给涡扇有关，因为这导致了各种各样的复杂情况。这同样也[让他更难跟上 JavaScript 的新特性](https://v8project.blogspot.com/2017/05/launching-ignition-and-turbofan.html) 。

Swirski 说火花塞的速度来源于两个因素。首先，它依赖于涡扇生成的字节码，这意味着大量的工作已经完成了，包括变量解析，判断圆括号是否是箭头函数，解析语句等等。此外，火花塞并不生成任何中间产物，而是输出机器码在一个单一的线性通道中。这种方式意味着火花塞不能做任何基于中间产物的高级优化，它必须挖煤全面移植到每个新的平台上。

在性能方面，火花塞改进了[速度计](https://browserbench.org/Speedometer2.0) 以及V8团队使用的一组现实的基准测试。根据测试机器和网站的不同，改进范围在 5 - 15% 之间。谷歌还没官方发布各种管道组件性能的低级基准。不过 Leszek [在这解释过](https://news.ycombinator.com/item?id=27308038) 。

> 编译时间和点火装置编译器大致相同（因为只是抽象语法树到字节码，不包括解析），大概比涡扇快二到三个量级。相对于解释器的性能，正如器注释指出，失控的变化是由于工作负荷，对于不完全由属性加载器控制来说，大概 4x 可能是个不错的近似值。

据 V8 的设计者说，除了性能，另一个火花塞的关键好处是减少CPU的使用，它可以改进移动设备对于电池的使用，还可以减少按周期付费服务器的费用。

正如提及到的，火花塞会在 [Chrome 91 中推出](https://developer.chrome.com/blog/new-in-chrome-91/) 所以，你很快就能自己试一试。如果你对火花塞内核的本质详情和它如何与点火装置和涡扇联系感兴趣。不要错过 Swirski 的文章。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
