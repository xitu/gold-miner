>* 原文链接 : [How we use BEM to modularise our CSS](https://m.alphasights.com/how-we-use-bem-to-modularise-our-css-82a0c39463b0#.qjqyfixfr)
* 原文作者 : [Andrei Popa](https://medium.com/@deioo)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [杨龙龙](https://github.com/yllziv)
* 校对者: [L9m](https://github.com/L9m), [JasinYip](https://github.com/JasinYip)

# 使用 BEM 来模块化你的 CSS 代码 

如果你对 BEM 不熟悉，它是通过一种严格方式来将 CSS 类划分成独立构成要素的一种命名方法。它表示为 _Block Element Modifier_，一个常见的 BEM 看起来就像这样：

    .block {}
    .block__element {}
    .block--modifier {}
    .block__element--modifier {}

BEM 的原则很简单：一个 **Block** 代表一个对象_（一个人、一个登录表单、一个菜单）_；一个 **Element** 是一个块中作为特定功能的组件_（一个帮助按钮、一个登录按钮、一个菜单项）_；一个 **Modifier** 是我们如何表示块或元素的不同变化_（一个女人、一个带有隐藏标签的迷你登录框、 footer 中一个不同的菜单）_。

这里有足够的在线资源来说明 BEM 方法的更多细节（[https://css-tricks.com/bem-101/](https://css-tricks.com/bem-101/)，[http://getbem.com/naming/](http://getbem.com/naming/)）。在这篇文章中，我们将聚焦如何应对在项目中应用 BEM 所遇到的挑战。

![](https://cdn-images-1.medium.com/max/2000/1*SKT3ZS6CRReXfuYORkr53g.jpeg)

在我们决定使用 BEM 方法转换样式之前，我们做了一些调研。环顾四周，我们发现有不少文章、研究、文档以及其他一些内容看起来回答了所有可能的问题。显然我们找到了我们的新死党。

但是一旦你在某一个方向深入一下，你就会产生一些困惑。你越是努力的想让它变好，它就变得越糟——除非你对它视而不见，并且把它当作你的朋友来对待。我们的故事开始于几个月前，那个时候我们遇见了 BEM。我们出去并自我介绍，然后被BEM诱惑到了，我们在的一些玩具项目中使用了 BEM。我们关系很密切，这就产生了一个决定：我们喜欢它，并想进一步发展我们之前的友谊到一个新的高度。

接下来的过程是相当的简单和自然。我们实验了一些_命名规范_和_手动创建样式类_。在决定了_一套准则_后，我们创建的基本的 mixins 来_生成类名_，这样我们在添加一个新的修饰符或者元素的时候，就不需要每次都是用一个块名。

所以我们的旅程就像下面这样开始了：

![](http://ww1.sinaimg.cn/large/005SiNxygw1f3djsb5400j30je06odfx.jpg)

然后我们使用了一系列自定义的 mixins 来转换上面的代码：

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3dju9380fj30je04xq3a.jpg)

慢慢地，当越来越多的边缘 case 涌现出来的时候，我们通过增加 mixins 而不同改变已存在的代码。相当的简洁！

所以如果我们想定义 full-size 修饰符下的 list 元素，我们需要这样做：

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3djvc8f5rj30jd08ewf6.jpg)

### 在程序中如何使用 BEM 

我们并没有一下子把所有东西都转换成遵循这些方法，而是平滑地慢慢地把一个一个小块转换过去。

与任意规则类似，我们必须理解双方的关系才能更好的相处。毫无疑问，我们遵循的一个指导原则是 BEM 方法的一部分，其中有一些规则是我们在后来增加的。

**基本原则**是我们**绝不在块中嵌套块、在元素中嵌套元素**。这是我们绝对不能打破的一条原则。

下面这样是一个块中非常深的嵌套：

![](http://ww4.sinaimg.cn/large/005SiNxygw1f3djwmz8w8j30je03xwei.jpg)
如果需要更多的嵌套，这意味着会更加复杂，这时应该把元素分解到小块中。

另一个规则是转换元素为块。遵循规则1，我们**将任何事情划分为更小的部分**。

让我们来聊聊一个相关组件的结构：

![](http://ww4.sinaimg.cn/large/005SiNxygw1f3djwmz8w8j30je03xwei.jpg)

首先我们创建较高级别的块对应的结构：

![](http://ww3.sinaimg.cn/large/005SiNxygw1f3djzbvfl8j30jj02wjrg.jpg)

然后我们成重复较小的内部结构：

![](http://ww3.sinaimg.cn/large/005SiNxyjw1f3dk19r5m5j30jg03fdg4.jpg)

如果名称变得更加复杂，我们只需要把它提取到另一个较小的块中：

![](http://ww4.sinaimg.cn/large/005SiNxygw1f3dk2w9mdej30jf03cdg4.jpg)

然后增加一些复杂的东西——我们想增加一些鼠标悬浮的效果：

![](http://ww1.sinaimg.cn/large/005SiNxyjw1f3dk3szxamj30jf079t9b.jpg)

所有的这些做完之后，如果我们将代码放到样式表中，它看起来结构会很好：

![](http://ww2.sinaimg.cn/large/005SiNxyjw1f3dk4eqsjaj30jg053js2.jpg)

没有什么能够阻止我们去清除一些不必要的语义。因为我们这部分代码明显是列表的一部分，并且在相关的环境中没有其他项，所以我们把它重命名为 **_correspondence-item_**：

![](http://ww4.sinaimg.cn/large/005SiNxygw1f3dk6qvkodj30jf02wmxf.jpg)

这是另外一条规则：我们使用**简化的命名方式**来命名嵌套组件的 BEM 块，从而使其与其它块不会冲突。

_例如，我们不会对 item-title 简化，因为我们在主要的块或者预览的标题中有一个 correspondence-title。这太常见了。_


### Mixins

我们使用的 mixins 是一个内部样式库 Paint 的一部分。

你可以在这里找到它：[  
https://github.com/alphasights/paint/blob/develop/globals/functions/_bem.scss](https://github.com/alphasights/paint/blob/develop/globals/functions/_bem.scss)

_Paint 是一个可用的 bower/NPM 包，并且它正在经历一个核心的重构。BEM mixins 仍然是可用并且定期维护的。_d

#### 为什么我首先需要 mixins ？

我们的目标是使 CSS 类生成系统变得非常简单，因为我们知道前端和后端工程师不需要花费大量的时间来构建样式表。所以我们尽可能的自动化这一过程。

同时我们开发了一系列辅助组件来做与模版类似的事情——提供一个定义块、元素和修饰符的方式，然后就像我们在 CSS 中一样自动生成标签类_。_

#### 如何工作

我们有一个 **__bem-selector-to-string_** 函数来简单的处理选择器，将它转换为字符串。Sass _(rails)_ 和 LibSass _(node)_ 在处理选择器字符串的时候似乎是不通的。有时类名中的点被添加到了字符串，所以我们要确保在近一步处理之前，要除去这些东西来作为预防措施。

我们用来检查一个选择器是否有一个修饰符的函数是 **__bem-selector-has-modifier_**。如果存在修饰符或者有伪类 _(:hover, :first-child etc.)_ 存在，它将返回 _true_。

最后一个函数用来从一个包含修饰符或者伪类的字符串中提取块的名字。如果**_对应的块名_**全部通过的话，**__bem-get-block-name_** 将返回 **_对应的块名_**。当我们使用内部修饰的元素的时候，我们需要使用块名，否则我们将很难生成一个类名。

**_bem-block_** mixin 生成一个带有类名和相关属性的基本块名。

**_bem-modifier_** mixin 生成一个 **_.块名 — 修饰符_** 类名。

**_bem-element_** mixin 做了更多事。它检查是否父级选择器是否是一个修饰符 _(或者是一个伪类选择器)_。如果是的话，它将生成一个嵌套的结构包括 **_块名 — 修饰符_** 的块名，并且在内部包括 **_块名 - 元素名_**。如果不是的话，我们将直接创建一个 **_块名__元素名_**。

_对于元素和修饰符，我们目前使用_ **@each <script type="math/tex" id="MathJax-Element-2">element in</script> elements** _但是我们在下一个版本中优化了它，从而允许共享相同的属性来取代在每个元素中复制属性。_

### BEM 给我们带来了什么享受

#### 模块化

在一个组件中添加了太多的逻辑是非常难重构的。通过使用 BEM 而没有了太多的选择，在在大多数时候也是一件好事。

#### 清晰

当我们看 DOM 的时候，会很容易的找到块所在的位置，元素的含义以及修饰符如何使用。类似的，当我们看一个组件样式表的时候，你会很容易的找到需要改变或者增加一些复杂度的地方。

![](https://cdn-images-1.medium.com/max/800/1*rF5RDVUI-gNxZVdmkzZ-uA.png)

一个具有交互组件的块结构：

![](http://ww1.sinaimg.cn/large/005SiNxygw1f3dko8pufuj30m80i0tbh.jpg)

一个带有元素和修饰符的块结构。

#### 团队协作

在同样的样式表上一起工作，很难避免样式的冲突。但是通过使用 BEM，每个人可以在他们自己的块-元素中工作，所以不会影响到其他人。

#### 原则

当写 CSS 的时候，我们喜欢遵循一系列的原则／规则。BEM 默认遵循下面的规则，从而使的书写代码更加容易。

**1\. 关注度分离**


BEM 强制我们划分样式为更小的部分，从而使的包括元素和修饰符的块更易维护。如果逻辑变得太复杂，这时候应该将它划分到为更小的部分。规则 #2。

**2\. 单一职责原则**

每一个块有单一的职责来封装组件中的内容。

对于初始示例，相应的部分应该负责建立列表和预览元素的网格。我们不共享内部与外部的职责。

遵循这个方法，如果网格发生变化， 我们只需要改变相应部分的内容。其他的部分仍然可以很好的工作。

**3\. DRY（不要重复自己）**

每次我们偶然发现代码复制了，我们就会将它提取到占位符和 mixins 中。如果我们需要在当前作用于中 _(上下文中重要的组件)_  重复，那就用这个模式——使用下划线定义 mixins 和伪类。

记住不要在在用过就丢弃的代码以及独立偶尔有不同属性的两份重复代码中浪费功夫。

**4\. 开闭原则**

当使用 BEM 的时候，这个原则是很难打破的。它指出，一切事情都应该对扩展开放，对修改关闭。我们避免直接在其他块的环境中改变块的属性。相反我们创建修饰符来达到这个目的。

* * *

BEM 是一个强大的方法，但是我认为这个秘密你是自己的。如果有时候它不起作用，那就找出怎么才可以起作用，并且可以破坏规则。只要它能带来结构和提高生产力，那么实现它就绝对具有价值。

* * *

我们很乐于听到你使用 BEM 来解决你所面临大挑战。

