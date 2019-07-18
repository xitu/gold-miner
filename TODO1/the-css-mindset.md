> * 原文地址：[The CSS Mindset](https://mxb.dev/blog/the-css-mindset/)
> * 原文作者：[Max Böck](https://mxb.dev/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-css-mindset.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-css-mindset.md)
> * 译者：[MarchYuanx](https://github.com/MarchYuanx)
> * 校对者：[solerji](https://github.com/solerji), [Chorer](https://github.com/Chorer)

# CSS 思维模式

啊，是的，CSS。它几乎每个星期都是网络上热议的话题。它太难了。它太简单了。它无法预测。它过时了。此处应该有一张 Peter Griffin 折腾百叶窗的恶搞图。

我不知道为什么 CSS 会在开发者中激发出如此多的不同情绪，但我有一种直觉，为什么有时候它看起来不合逻辑或令人沮丧：你需要一种特定的**思维模式**才能写出好的 CSS。

现在，您可能需要一个编码的思维模式，但 CSS 的声明性使其特别难以掌握，尤其是当您用“传统”编程语言的思维来思考它的时候。

其他编程语言通常在受控的环境中工作，例如服务器。它们希望某些条件始终为真，从而作为程序应该如何执行的具体指令。

另一方面，CSS 在一个永远无法完全可控的地方工作，所以默认情况下它必须是灵活的。它不仅仅用于“编写外观”，还用于将设计转换为一组传达其背后意图的规则。留出足够的空间，浏览器将为您完成繁重的工作。

对于大多数专业编写 CSS 的人来说，他的思维模式在一段时间后自然而然地形成了。在事情终于有成效的时候，许多开发者都有那样一个“啊哈！”的时刻。这不仅仅是了解所有技术细节，更多的是关于语言背后的思想的一种感觉。

我试着在这里列出一些思维模式。

### 全都是矩形

这看起来很明显，因为盒子模型可能是人们学习 CSS 的时候接触到的第一个东西。但是将每个 DOM 元素描绘成一个盒子对于理解事物布局方式至关重要。它是内联的还是块级的？它是弹性的吗？它将如何在不同的环境中拉伸/收缩/包裹？

打开你的开发者工具并将鼠标悬停在元素上，观察它们绘制的盒子。或使用像 `outline: 2px dotted hotpink` 这样的显式样式来显示其隐藏的边框。

### 级联是你的朋友

级联 —— 一个可怕的概念，我懂。在镜子前说三次“级联”，在某个地方，一些不相关的样式会失效。

虽然有合理的理由避免级联，但这并不意味着它的一切都是不好的。事实上，如果使用得当，它可以让您的生活更轻松。

重要的是要知道哪些样式属于全局作用域，哪些样式更适合于组件。它还有助于了解传递的默认值，避免声明不必要的样式规则。

### 尽可能必要，尽可能少

旨在编写实现设计所需的最少量的代码。较少的属性意味着更少的继承、更少的限制和更少的覆盖带来的麻烦。想想你的选择器应该做什么，然后尝试就那样表达它。在已经是块级别的元素上声明 `width: 100%` 是没有意义的。如果您不需要新的堆叠上下文，则无需设置 `position: relative`。

避免不必要的样式，你就避免了意外后果。

### 简写有很大的影响

一些 CSS 属性可以用“简写”方式书写，这使得一起声明一组相关属性成为可能。虽然这很方便，请注意，使用简写还将为未显式设置的每个属性声明默认值。写上 `background: white;` 将有效地导致所有这些属性被设置：

```css
background-color: white;
background-image: none;
background-position: 0% 0%;
background-size: auto auto;
background-repeat: repeat;
background-origin: padding-box;
background-clip: border-box;
background-attachment: scroll;
```

样式最好是明确的。 如果要更改背景颜色，请使用 `background-color`。

### 永远要灵活

CSS 处理大量未知的变量：屏幕大小、动态内容、设备功能 —— 这个列表还在继续。如果你的样式过于狭隘或受限，那么这些因素中的某一个很可能会让你栽跟头。这就是为什么写好 CSS 的一个关键方面就是接受它的灵活性

你的目标是编写一套足够全面的指令来描述你想要实现的页面，但足够灵活，让浏览器自己理解清楚**怎么做**。这就是为什么通常最好避免 **“神奇数字”**。

神奇数字是随机的固定值。比如：

```css
.thing {    width: 218px; /* why? */}
```

每当你自己在开发工具中点击箭头键并调整一个像素值使之适合的时候 —— 都可能会有一个神奇数字。它们很少能解决 CSS 问题，因为它们将样式限制在特定的使用案例中。如果约束发生变化，那么该数字将会失效。

相反，想想在那种情况下你真正想要实现什么。对齐？宽高比？分配等量的空间？所有这些都有灵活的解决方案。在大多数情况下，最好为目的定义一个规则，而不是采用硬编码的计算方案。

### 语境是关键

对于许多布局概念，必须了解元素与其容器之间的关系。大多数组件是父节点和子节点的集合。应用于父级的样式会影响子孙级，这可能会使它们忽略其他规则。弹性盒子，栅格布局和 `position: absolute` 是此类错误的常见来源。

当疑惑某个特定元素的表现与您期望的不同时，请查看它所在的上下文。可能是它祖先级的某些因素影响了它。

### 内容会改变

始终要注意，您所看到的只是在大范围中的一种 UI 状态。不要在屏幕上设置样式，而是尝试构建组件的“蓝图”。然后确保不论你把它放在什么场景，都不会使你的样式失效。

字符串可能比预期长或包含特殊字符，图像可能缺失或具有奇怪的尺寸。显示的样子可能非常窄或非常宽。这些都是您需要预测的状态。

设计师和开发者犯的第一个错误就是假设事情总是像它们在静态模型中那样。我可以向你保证，它们不会。

### 发现模式并复用它们

当您打算将设计模型实现为代码时，首先盘点出所包含的不同模式通常很有帮助。分析每个屏幕的场景，注意任何出现一次以上的概念。它可能是一些小的东西，比如排版样式，或者大的东西，比如某种布局模式。

什么可以抽象？什么是特有的？将设计中的各个部分视为独立的东西使它们更易于理解，并有助于划分组件之间的界限。

### 使用一致的命名

总的来说，相当多的一部分程序有不错的命名。在 CSS 中，它有助于遵守约定。像 [BEM](http://getbem.com) 或 [SMACSS](http://smacss.com/) 这样的命名方案非常有用；但即使你不使用它们，也要坚持使用一致的词汇。

---

👉 **免责声明**  
所有这些对我来说都是很重要的，但是基于你的个人经历，什么最重要可能是不同的。你有没有你的“啊哈”时刻让你更好地理解 CSS？告诉我！

## 延伸阅读

* [How to learn CSS](https://www.smashingmagazine.com/2019/01/how-to-learn-css/) by Rachel Andrews
* [The Secret Weapon to learning CSS](https://css-tricks.com/the-secret-weapon-to-learning-css/) by Robin Rendle
* [CSS doesn’t suck](https://andy-bell.design/wrote/css-doesnt-suck/) by Andy Bell

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
