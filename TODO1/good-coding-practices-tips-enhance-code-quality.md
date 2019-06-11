> * 原文地址：[Good Coding Practices – Five Tips to Enhance Code Quality](https://www.thecodingdelight.com/good-coding-practices-tips-enhance-code-quality/)
> * 原文作者：[Jay](https://www.thecodingdelight.com/author/ljay189/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/good-coding-practices-tips-enhance-code-quality.md](https://github.com/xitu/gold-miner/blob/master/TODO1/good-coding-practices-tips-enhance-code-quality.md)
> * 译者：[NeoyeElf](https://github.com/NeoyeElf)
> * 校对者：[dandyxu](https://github.com/dandyxu)，[allenlongbaobao](https://github.com/allenlongbaobao)

# 良好的编码习惯 —— 5 个提高代码质量的技巧

良好的编码习惯像黑夜中的一盏明灯，指引着迷路的开发者安全靠岸。良好的代码是可预测的，是易于调试、扩展和测试的。

良好的编码习惯能够提高你同事的工作效率，同时让你的代码库从整体上给人一种愉快的阅读体验。

接下来我要和你们分享的是 5 个通用的良好编码习惯，它们能提高你代码的可读性，可扩展性和整体质量。越快理解和运用这些准则，你的收益就越大。

让我们开始吧。

## 为什么要有良好的编码习惯？

学习和运用良好的编码习惯就像投资那些你知道一定会成倍增长的股票。换句话说，你只要现在做一次性的投资，在接下来的几年甚至几个月的收益和回报，将会远远超过你现在的投入。

处于职业生涯任何阶段的开发者都会受益于应用和学习良好的编码习惯。就像我上面所说，你越早开始使用它们，你的收益便越大。现在便是最好的时机来学习和将良好的编码习惯应用于你现在的项目。

我提出这些观点，旨在它们能够互相支撑，且无论是作为单独的建议还是组合起来都是合理的。

## 1. 简洁地给方法和变量命名

当给类、变量和方法命名时，我们很容易冲动地按照自己的方式给它们命名。特别是当你觉得这一切都很合理时。试着几个月之后再回头看看那些代码，看看它们是否依旧合理。如果是，那么很有可能是你当时明智地命名了你的变量和方法。

[![良好的编码习惯 —— 方法名类似文章中的标题和句子](https://personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2017/07/good-coding-practices-method-names-are-like-heading-sentences.jpg)](https://personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2017/07/good-coding-practices-method-names-are-like-heading-sentences.jpg)

方法名类似文章中的标题和句子。

因此，当给方法命名时，要能够准确概括方法的内容。如果方法名变得太长或模糊，那么表示该方法做了太多的事情。

方法中的内容组成了方法名。

当你阅读一篇文章时，你觉得最突出的是什么？通常，最突出的是标题。在程序中，**关键方法就像标题**。当你为高中或大学散文写投稿文章时，你是否只是随便瞎写几句，然后不假思索地写完标题？

> 一个简单直观的方法名胜过千言万语。

当然，句子中单词的选择以及如何将它们组合在一起也很重要。这就是为什么我们也需要特意地给我们的变量命名。大多数情况下，在查看代码逻辑之前，人们会试图通过阅读每一行中的变量名来对代码实现细节的有一个整体把握。

确保方法和变量名称都是清晰明了的，且准确地描述了正在发生的事情。想象一下，如果你指引给一个游客错误的方向，他/她会多么生气和困惑。你正在为下一个前来阅读你代码的程序员指引道路。

## 2. 尽可能减少使用全局变量

不管使用哪种语言，你可能在编程中经常听到这种说法。人们只会说使用全局变量不好，而不去解释为什么不好。那么让我来告诉你为什么应该尽可能地减少和避免全局变量。

> 全局变量会造成困惑，因为程序中的任何地方都可以访问到它们。

如果全局变量同时也是可变的，则会增加人们的困惑。如果你声明了一个变量，那么很可能你只是想在自己的代码中去使用它。你猜猜接下来会发生什么？

这里是一个用 JavaScript 语言编写的基础示例，但无论你使用的是哪种编程语言，下面这段代码都应该很容易理解。

```
var GLOBAL_NUMBER = 5;
function add(num1) {
return num1 + GLOBAL_NUMBER;
}
```

对于这个函数，即使我们传入 num1 = 3，我们也无法确定该方法是否会返回 8，因为该程序的其他部分也许已经修改了 GLOBAL_NUMBER 的值。

这增加了程序产生副作用的可能性，特别是当我们使用多线程编程时。更糟糕的是，程序的复杂性与代码量的大小成正比。

在 100 行的代码中使用单个全局变量是可管理的。但是想象一下，如果这个项目后来演变成一个拥有 10000 行代码的项目。那么项目中有很多地方都可以修改这个变量。而且，到目前为止，代码中可能还添加了其他的全局变量。

现在维护代码简直就是一个噩梦。

如果可能的话，找到消除全局变量的方法。全局变量增加了每个开发人员的工作难度。

## 3. 编写可预测的代码

如果你关注我的博客，你可能会发现我喜欢纯函数。特别地，如果你是初学者，我恳请你尝试编写干净的代码。让我来告诉你编写代码中 4 个需要遵守的点。

**避免状态共享**（emm...全局变量）。**保持函数干净**。换句话说，函数、类、子程序都应该只有单一的职责。

如果你的工作是煮米饭，那就煮米饭，不要做其他的事情，以免让你的同事感到困惑。不要做不该你做的事情。

具有可预测结果的代码就像一台自动售货机。你把钱放进去，按下可乐的按钮。你知道你的钱可以换一罐可乐。对于编码，这条规则也适用。使编码结果可预测。一个良好的编码习惯是编写**可预测结果**的代码。

想象一下，如果你将钱放入自动售货机，按下可乐按钮，但相反，自动售货机给你了芬达。除非你喜欢惊喜，或者你不在乎喝什么，否则你是肯定不会感到快乐的。

无一例外，开发人员并不喜欢由糟糕代码的副作用带来的惊喜。 

让我们来看一个很简单的示例。

```
function add(num1, num2) {
return num1 + num2;
}
```

上面这个简单的 add 函数是纯粹的。它产生可预测的结果。无论你在什么环境使用它，无论任何全局变量，如果你输入 1 和 2，你总是会得到 3。

```
// This will never equal a value 
// other than three
add(1, 2);
```

## 4. 编写可重用的代码

我尝试模块化编码，这样一来我就可以简单地导入该模块，而不必重写它。这比重新发明轮子要好，如果你可以保持模块简洁，这样一来便会减少 bugs 和副作用。

最重要的是，我想让你明白为什么我们喜欢坚持这些原则。

[当可以将代码移植到另一个开发环境并无缝集成到 Tweet 时，代码便是可重用的。](https://twitter.com/share?text=Code+is+reusable+when+it+can+be+ported+to+another+development+environment+and+integrated+seamlessly&url=https://www.thecodingdelight.com/good-coding-practices-tips-enhance-code-quality/%3Futm_source%3Dtwitter%26utm_medium%3Dsocial%26utm_campaign%3DSocialWarfare&via=JayLee189)

请记住，你并不是(或者至少不应该是)唯一编写和维护该代码库的人。基于第一、第二和第三点，可以使我们做到第四点，即编写可重用的代码。换句话说，步骤 1-3 帮助我们编写可重用的代码。让我们回顾复习一下为什么步骤 1-3 能帮助开发人员编写可重用代码。

*   简单明了的方法和变量名使代码更容易被其他开发人员所接受。
*   可重用的代码不应该依赖于全局状态。使用了依赖库的代码通常被归类为难以重用的代码。
*   可重用的代码应该产生不依赖于可变状态的一致结果。

当写代码时，尝试问自己：“我能否（或我是否想要）在其他项目中重用这块代码？”。这会帮助你写出可重用的代码，即更加有价值的代码。

## 5. 写单元测试

你可能已经听过很多次了，这是因为单元测试使代码更加成熟和健壮。由于项目时间限制，单元测试成为了不受欢迎的良好编码习惯之一。项目经理和客户希望立刻得到结果。

> 拥有单元测试的代码就像一棵[中国竹子](http://www.mattmorris.com/how-success-is-like-a-chinese-bamboo-tree/)。在开始的时候成效并不明显，但只要你有耐心，在某个适当的时候，收益是显而易见且十分值得的！

在最初的四年里，中国竹子生长受限。和任何其他植物一样，它需要培养。在第五年，它在仅仅 6 周内就长了 80 英尺。

[![拥有单元测试的代码就像竹子](https://personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2017/07/code-written-with-unit-tests-are-like-bamboo-trees.jpg)](https://personalzone-hulgokm2zfcmm9u.netdna-ssl.com/wp-content/uploads/2017/07/code-written-with-unit-tests-are-like-bamboo-trees.jpg)

虽然单元测试能带来的收益并不需要花那么长的时间，但是通常情况下，你和你项目经理的耐心都将受到考验。当然，如果你们愿意花时间去编写这些单元测试并关注代码质量，代码的质量和健壮性都会得到巨大改进。所有这些努力最终都将转化为更好的用户体验和拥有最小副作用的更容易扩展的代码。

如果你不被允许在你的工作代码中编写单元测试，那么尝试养成在你的个人项目中编写单元测试的习惯。许多公司看到了编写单元测试的价值，这是一项非常有用的技能。

比这项技能更重要的是，单元测试能够扩宽开发者的视野，从全局考虑问题，检查所有可能的情况。

考虑这些情况的可能性，从而权衡利弊，添加适当数量的有效检查用例。做各种假设，然后重新设计编码。

所有的这些心血、汗水和眼泪最终将汇聚成优美的、经过测试的纯粹健壮的代码。它可重用，可预测，并可能会很好地服务于你未来的工作。

阅读本文所获取的知识至少可以帮助你成为一名成熟的程序员。

## 完善清单

如果你有其他更好的编码习惯想让我加入这份清单中，或者你觉得清单中遗漏了一个重要的点，请在下方评论留言。我会尽快将您的意见加入这份清单中。

感想您的阅读，happy coding!

### 关于作者 [Jay](https://www.thecodingdelight.com/author/ljay189/)

我是一个程序员，目前住在韩国首尔。我创建这个博客是为了将我已掌握和正在学习的知识用写文章的形式表达出来，以作知识积累，同时也希望能够帮助构建更广大的社区。我热衷于数据结构和算法，专精于后端和数据库。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

