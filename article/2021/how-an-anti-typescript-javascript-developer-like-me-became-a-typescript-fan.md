> * 原文地址：[How an Anti-TypeScript “JavaScript developer” like me became a TypeScript fan](https://chiragswadia.medium.com/how-an-anti-typescript-javascript-developer-like-me-became-a-typescript-fan-a4e043151ad7)
> * 原文作者：[chiragswadia](https://chiragswadia.medium.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-an-anti-typescript-javascript-developer-like-me-became-a-typescript-fan.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-an-anti-typescript-javascript-developer-like-me-became-a-typescript-fan.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 一个像我一样是 TypeScript 的黑粉的 “JavaScript 开发者” 是怎样黑转粉的？

在这篇博客文章中，我将会讲述我是如何从一名 TypeScript 黑粉的开发者转变到如今不想回到原生 JavaScript 世界的开发者的旅程 🚀，也许我的想法可以帮助和我几年前一样境遇的人们。

# **为什么我曾经是 TypeScript 的黑粉？**

我一直觉得给函数和变量设定类型，满足 TypeScript 编译器的各种检查是一种过度的设计，并且没有任何意义上的好处。而且这个设计也让我编写程序的速度很慢，也是因为我经常会遇到一些作为一名新人所难以理解的编译错误。我挠头三千尺，白发飘落，试图去找出问题所在，也同时增生了一丝惆怅与挫败。我开始讨厌 TypeScript 这门语言了。

另一个原因是诸如 [Generics](https://www.typescriptlang.org/docs/handbook/generics.html) 之类的拓展的 TypeScript 概念在一开始我很难去理解。我开始觉得自己又深陷 **Java** 世界那般的泥潭，似乎每句代码的输入都是强类型并且令我极度厌烦的。当我开始学习 TypeScript 时，即使像下面这样的简单代码也足以让我感到恐惧。

![TypeScript 泛型示例](https://miro.medium.com/max/1544/1*ccNIwcBOISh4ZJ7kAuaY4A.png)

由于上述的原因，即使我通过观看一些在线的教程或是尝试去阅读书籍来学习 TypeScript，我也从未主导或参与过任何使用 TypeScript 编写的企业应用程序的开发之中。实际上，我过去常常选择 JavaScript 而不是 TypeScript（如果可以选择）去完成家庭作业这一公司面试过程的一部分 🙈。

但是，当我转任现职时，我失去了使用 JavaScript 的权利！因为我将要处理的所有应用程序都是用 TypeScript 编写的（JavaScript 部分都是些旧代码）。我，对 TypeScript 的仇恨，与日俱增！但在几个月后，我终于明白了为什么会有人更喜欢 TypeScript，而不是喜欢 JavaScript 的原因，明白了使用 TypeScript 的好处和一些激励我去尝试使用的的理由。这些内容我将在下面的部分中列出：

## **我成为 TypeScript 粉丝的三大原因**

### **避免无效状态的出现 & 拥有详尽的检查**

这就是我喜欢 TypeScript 的主要原因。如果你想进一步了解这个概念，建议你去观看一下下面的视频 —— 虽说它说的是 Elm 语言，但该概念也适用于 TypeScript 语言。

![Making Impossible State Impossible](https://youtu.be/IcgmSRJHu_8)

如果你想查看一些有关如何在 React 应用程序中利用 TypeScript 来避免程序出现无效状态的示例，我建议你去阅读一下下面的博客文章：

1. [交通信号灯系统是如何处理无效状态的现实示例 🚦](https://zohaib.me/leverage-union-types-in-typescript-to-avoid-invalid-state/)
2. [带有加载中、已加载和加载错误状态的 React 组件 ⚛️](https://dev.to/housinganywhere/matching-your-way-consistent-states-1oag)

### **及早发现错误**

在使用 JavaScript 时，我在多个实例中都遇到了某些极端情况而在生产环境中产生的错误，而这些是前端环境中是没有类型检查所导致的。这些错误本可以避免，并且可以在 TypeScript 编译器的编译时捕获，以节省了 DEV 🔁 QA 周期的时间。

使用 TypeScript，一切都保持最初定义的方式。如果将变量声明为布尔型，则它将始终是布尔型，并且不会变成数字。这增加了代码按照最初预期的方式工作的可能性。简而言之，代码是可预测的！

### **丰富的 IDE 支持 & 易于重构**

集成开发环境（IDE）让有关类型的信息更加有用 —— 我们可以在 IDE 中使用上代码导航和自动完成等功能，并借助这些准确的建议修复错误。我们还可以在键入时获得反馈：编辑器会标记错误，包括与类型相关的错误。所有这些都可以帮助您编写可维护的代码，并大大提高工作效率 🚀。

如果我们谈论重构，例如引入新状态或摆脱应用程序中正在使用的不必要状态，那么 TypeScript 编译器会在你忘记更新某些引用时候提醒你，也能让你对重构充满信心 —— 因为应用程序将与重构前的工作方式相同。

## **结论**

总而言之，使用 TypeScript 有许多的好处（如果你还没有这样做的话），而以上的几点就是我的主要动力，也是因为这些动力，我对 TypeScript 黑转粉了。

如果你是 TypeScript 的初学者或想提高你的知识，那么我可以推荐一些书：

1. [TypeScript 50课](https://amzn.to/37YslR2)（是个会员链接）
2. [使用 TypeScript](https://exploringjs.com/tackling-ts/)

干杯! 🙂

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
