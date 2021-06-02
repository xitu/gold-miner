> * 原文地址：[Implementing and shipping TC39 proposals](https://github.com/tc39/how-we-work/blob/master/implement.md)
> * 原文作者：[Ecma TC39](https://github.com/tc39/how-we-work)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Implementing-and-shipping-TC39-proposals.md](https://github.com/xitu/gold-miner/blob/master/article/ECMA-TC39/Implementing-and-shipping-TC39-proposals.md)
> * 译者：[Zz招锦](https://github.com/zenblo)
> * 校对者：[Kim Yang](https://github.com/KimYangOfCat)、[PassionPenguin](https://github.com/PassionPenguin)

# 简述 TC39 提案的实现和交付

除了规范文本和一致性测试之外，还需要实现新的 JavaScript 特性，也就是 JS 引擎、转码器、工具、polyfills 等的代码，让开发者可以使用这些功能。实施者最终会从不同视角分析提案的每一个细节，这有助于验证 TC39 提案。

## 阶段性流程的互动

实施方案越早起草越好，不同的阶段表明了不同的稳定性和具体程度。许多实现使用运行时或编译时标志来打开或关闭 TC39 建议。这可能被用来管理不完整的实现，以及避免交付还处于早期阶段的开发者设计方案。

在第 4 阶段，一个规范已经完成，并被确定会包含到 ECMAScript 规范草案中。除非在特殊情况下，否则该提案是完整的、稳定的，并可随时发布。通常各个实现默认开启第 4 阶段的特性，没有任何特殊的标志。不去实现和交付第 4 阶段的特性，就有可能使该实现与其他实现不同步。

在第 3 阶段，委员会正在全力考察一项功能，并已就具体细节达成一致。但实施过程仍然可能导致语义上的变化，甚至一些第 3 阶段的功能已经被完全放弃。追求稳定性的项目如果想完全交付这些功能，在交付第 3 阶段的功能之前，通常会使用一定程度的个例测试。

在第 0、1 和 2 阶段，语义细节尚无定论。委员会还没有就该提案的所有具体细节达成共识。在这个阶段的实现应该被认为是实验性和推测性的。这个阶段的实现对于程序员的实验是非常有价值的，它可以帮助完善语言的设计。实现往往通过特殊的标志来暴露这个阶段的特征，这些标志在默认情况下是不启用的。

## 转译器的实现

早期的语言特性可以在所谓的转译器中得到原型。在旧的 JavaScript 环境中支持较新的语言特性的 JavaScript-to-JavaScript 转译器。新的语言特性的转译器实现可以帮助收集反馈并推动渐进式采用。

[Babel](https://babeljs.io/) 是一个流行的转译器，用于原型开发早期的 JavaScript 特性。对于创建新语法的特性，Babel 的解析器需要修改，你可以在 fork 和 PR 中进行修改。在某些情况下，当可以使用现有的语法结构时，一个 Babel 转换插件可能就足够了（但请注意，由于网络兼容性问题，在非错误情况下很难改变其对现有特性的语义定义）。

## 依赖库的实现

如果提议是一个标准的库功能，并且有可能在 JavaScript 中实现这个功能，那么把这个功能拿出来给开发人员试用是很有帮助的，这样他们就可以给出反馈。当它作为一个标准出现时，在一些引擎中得到支持，而在另一些引擎中则不被支持，将这个实现作为一个备份仍然是有用的，通常被称为 polyfill 或 shim。为了鼓励使用，在流行的软件包管理器（例如 [npm](https://www.npmjs.com/)）中将这些实现作为模块公开是有帮助的。

对于早期的依赖库提议（第 3 阶段前，第 3 阶段是边界，如上所述）的实现，最好的做法是将其作为一个模块，而不是现有对象的全局或属性来公开。这对于标准的演进很重要，所以人们不会意外地依赖早期版本是最终版本。详见 [Polyfills 和网络的发展](https://www.w3.org/2001/tag/doc/polyfills/)。

## TC39 提案测试

TC39 在一个名为 [test262](https://github.com/tc39/test262/) 的项目中维护一致性测试，以验证 JavaScript 的实现是否符合规范。要贡献给 test262，请查看 [CONTRIBUTING.md](https://github.com/tc39/test262/blob/master/CONTRIBUTING.md)。如果你开发了针对某个特定实现的测试，我们非常鼓励你把它们提交到 test262。

test262 包括所有第 4 阶段提案和一些第 3 阶段提案的测试。早期的第 2 阶段提案可能会把测试提交为[拉取请求](https://github.com/tc39/test262/pulls) 中发布了测试。

## 给予提案者反馈

TC39 非常感谢提案者！除了向 JS 开发者提供功能外，实现的过程还能让人详细了解该功能在整个语言中的情况以及它的各种相互作用，从而获得关于设计的重要见解。

我们感谢提案者的各种反馈，无论是关于动机、顶层设计、与其他各种系统的整合、实现的复杂性，还是特殊案例的语义。提供反馈的最好方式是在 GitHub 仓库中提交错误。也可以针对建议的语义变化对提案规范草案进行 PR。

如果你在提案实施过程中遇到问题，例如在理解建议方面有困难，或者希望在一个特殊案例方面得到帮助，请与项目组联系，可以在 GitHub issue 中归档你的问题，给他们写邮件，或者打电话来讨论。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
