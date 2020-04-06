> * 原文地址：[The Dao of Immutability](https://medium.com/javascript-scene/the-dao-of-immutability-9f91a70c88cd)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-dao-of-immutability.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-dao-of-immutability.md)
> * 译者：[niayyy](https://github.com/niayyy-S)
> * 校对者：[S_Shi-Hua](https://github.com/IAMSHENSH)、[Roc](https://github.com/QinRoc)

# 不变性之道

> 函数式程序设计方法

## 前言

我徘徊在一个旧图书馆档案室，发现了一条通往计算机教室的黑暗隧道。在那里，我发现了一个似乎被遗落在地上的卷轴。

卷轴被装在满是灰尘的铁筒中，上面贴着这样的标签：“**Lambda（匿名函数）教堂**的档案。”

它被包裹在一张纸里，上面写道：

---

**一位高级程序员和他的徒弟陷入图灵沉思中，思考着 Lambda（匿名函数）。徒弟看着师傅，问道：“师傅，你告诉我要简单化，但是程序是复杂的。框架可以通过消除困难的选择来简化创建的工作。那么类库和框架哪个更好呢？”**

**高级程序员看着他的徒弟反问道：“难道你没读过智者 Carmack 的学说吗？”，并引用道…**

> “有时，优雅的实现仅仅是一个函数。不是一个方法。不是一个类库。也不是一个框架。仅仅是函数”

**徒弟又开始说到：“但是，师傅，” —— 但是师傅打断了他的话，问道：**

**“‘not functional（无功能）’这个词不就是 ‘dysfunctional（功能障碍）’吗？”**

**然后徒弟明白了。**

---

在这张纸的背面是一个索引，似乎引用了计算机行业的许多书籍。我偷偷看了一眼这些书籍的名称，但是里面充满着我不能理解的词汇，因此我略过它们，继续阅读卷轴。我注意到索引旁边的空白页面被写满了简短的评论，我将在这忠实地抄录这些评论以及卷轴里面的文字：

---

> **不变性：** 唯一的不变就是改变。变异隐藏变化。而被隐藏的变化会带来混乱。因此，智者拥抱历史。

如果你有一美元，而我又给你了一美元，前一刻你仅有一美元，现在你拥有了两美元，这一事实并没有改变。事态的变异会尝试抹除历史记录，但是历史记录无法真正被删除。如果不保存过去，它将表现为程序中的 bug，再次困扰你。

> **分离：** 逻辑就是思考，效果就是行动。因此，智者三思而后行。

如果你尝试同时执行效果和逻辑，你可能创建导致逻辑错误的副作用。尽可能保存函数功能的单一。一次只做一件事并做好。

> **组合：** 自然界中万物和谐相处。没有水，树木无法生长。没有空气，鸟儿不能飞翔。因此，智者把原料混合在一起，让汤尝起来更美味。

规划组合的方式。设计函数时确保最终编写的函数的输出结果可以作为许多其他函数的输入参数。让函数标识尽可能的简单。

> **节约：** 时间是宝贵的，而努力需要时间。因此，智者尽可能地重用他们的工具。愚蠢的人会为每个新的东西创造特殊的工具。

特定类型的函数不能用于其它类型的数据。明智的程序员通过 lift 函数来处理多种数据类型，或者把数据包装为函数所需要的格式。列表和列表项构成了很好的通用抽象。

> **流动：** 流水不腐，户枢不蠹。智者之所以成功，是因为他们让事务顺其流动。

**[编者注：卷轴上唯一的插画在这节经文的上方，画面上有一排看起来不同的鸭子在顺流而下。我没有复制插画，因为我不相信我可以做到这一点。奇怪的是，他的标题是：]**

---

> 列表像是一条随着时间推移而变化的水流。

---

**[相应的说明如下：]**

共享对象和数据配件（data fixtures）可能导致函数相互干扰。竞争相同资源的多个线程会互相阻碍。只有当数据通过纯函数自由流动时，才能对程序进行推演并预测结果。

**[编者注：卷轴以最后一节经文结尾，没有注释：]**

> **智慧：** 明智的程序员在走上这条路之前，会先了解透彻这条路的走法。因此，明智的程序员是有价值的，而不明智的程序员会迷失在[丛林](https://medium.com/javascript-scene/the-two-pillars-of-javascript-ee6f3281e7f3)中。

> **注意：** 这是“组合软件”系列[**（丛书）**](https://leanpub.com/composingsoftware)中的从头学习 JavaScript ES6+ 中的函数式编程和组合软件技术。后续还有更多文章！敬请关注。

本系列目录：

* [简介](https://medium.com/javascript-scene/composing-software-an-introduction-27b72500d6ea)
* [不变性之道](https://medium.com/javascript-scene/the-dao-of-immutability-9f91a70c88cd)
* [跌宕起伏的函数式编程](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c)
* [为什么用 JavaScript 学习函数式编程？](https://medium.com/javascript-scene/why-learn-functional-programming-in-javascript-composing-software-ea13afc7a257)
* [纯函数](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-a-pure-function-d1c076bec976)
* [什么是函数式编程？](https://medium.com/javascript-scene/master-the-javascript-interview-what-is-functional-programming-7f218c68b3a0)
* [函数式程序员的 JavaScript 简介](https://medium.com/javascript-scene/a-functional-programmers-introduction-to-javascript-composing-software-d670d14ede30)
* [高阶函数](https://medium.com/javascript-scene/higher-order-functions-composing-software-5365cf2cbe99)
* [柯里化与函数组合](https://medium.com/javascript-scene/curry-and-function-composition-2c208d774983)
* [抽象与组合](https://medium.com/javascript-scene/abstraction-composition-cb2849d5bdd6)
* [Functor 与 Category](https://medium.com/javascript-scene/functors-categories-61e031bac53f)
* [JavaScript 让 Monad 更简单](https://medium.com/javascript-scene/javascript-monads-made-simple-7856be57bfe8)
* [被遗忘的面向对象编程史](https://medium.com/javascript-scene/the-forgotten-history-of-oop-88d71b9b2d9f)
* [对象组合中的宝藏](https://medium.com/javascript-scene/the-hidden-treasures-of-object-composition-60cd89480381)
* [ES6+ 中的 JavaScript 工厂函数](https://medium.com/javascript-scene/javascript-factory-functions-with-es6-4d224591a8b1)
* [函数式 Mixin](https://medium.com/javascript-scene/functional-mixins-composing-software-ffb66d5e731c)
* [为什么类中使用组合很难](https://medium.com/javascript-scene/why-composition-is-harder-with-classes-c3e627dcd0aa)
* [可自定义数据类型](https://medium.com/javascript-scene/composable-datatypes-with-functions-aec72db3b093)
* [Lenses：可组合函数式编程的 Getter 和 Setter](https://medium.com/javascript-scene/lenses-b85976cb0534)
* [Transducers：JavaScript 中高效的数据处理 Pipeline](https://medium.com/javascript-scene/transducers-efficient-data-processing-pipelines-in-javascript-7985330fe73d)
* [JavaScript 样式元素](https://medium.com/javascript-scene/elements-of-javascript-style-caa8821cb99f)
* [模拟是一种代码异味](https://medium.com/javascript-scene/mocking-is-a-code-smell-944a70c90a6a)

---

**埃里克·埃利奥特（Eric Elliott）** 是一名分布式系统专家，并且是[《Composing Software》](https://leanpub.com/composingsoftware)和[《Programming JavaScript Applications》](https://ericelliottjs.com/product/programming-javascript-applications-ebook/)这两本书的作者。作为 [DevAnywhere.io](https://devanywhere.io/) 的联合创始人，他教开发人员远程工作和实现工作 / 生活平衡所需的技能。他为加密项目组建开发团队并提供咨询，并为 **Adobe 公司、Zumba Fitness、《华尔街日报》、ESPN、BBC** 和包括 **Usher、Frank Ocean、Metallica** 在内的顶级唱片艺术家的软件体验做出了贡献。

**他与世界上最美丽的女人一起享受着远程办公的生活方式。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
