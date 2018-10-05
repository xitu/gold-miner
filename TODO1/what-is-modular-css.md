> * 原文地址：[What is Modular CSS?](https://spaceninja.com/2018/09/17/what-is-modular-css/?utm_source=CSS-Weekly&utm_campaign=Issue-332&utm_medium=email)
> * 原文作者：[Scott Vandehey](https://spaceninja.com/author/scott/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-modular-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-modular-css.md)
> * 译者：[ssshooter](https://github.com/ssshooter)
> * 校对者：[Hopsken](https://github.com/Hopsken) [Park-ma](https://github.com/Park-ma)

# 什么是模块化 CSS？

![](https://i.loli.net/2018/09/29/5baf804a63637.png)

模块化 CSS 是一组编写代码的原则，基于这个原则编写的代码具有高性能和可维护性。它起源于雅虎和 Yandex 的开发人员，目的是迎接维护大型代码库带来的挑战。有些规则在提出之初稍有争议，但后来被认为是最佳实践。

**目录：**

1.  [大规模 CSS 的处理难点](#c1)
2.  [什么是模块化](#什么是模块化)
3.  [模块化框架](#模块化框架)
    1.  [OOCSS](#oocss)
    2.  [BEM](#bem)
    3.  [SMACSS](#smacss)
4.  [共享模块化原则](#共享模块化原则)
5.  [FAQ](#faq)
6.  [总结，模块化 CSS 太美妙啦](#c6)

**（偷偷告诉你：如果你对这篇文章的篇幅感到不知所措，[观看视频](https://www.youtube.com/watch?v=Ty5jtMZXbmk)可能更适合你，这篇文章来源于此演讲。）**

<h2 name="c1">大规模 CSS 的处理难点</h2>

模块化 CSS 使用的主要场景是棘手的大规模 CSS。正如 [Nicholas Gallagher](https://twitter.com/necolas) [所说的](https://twitter.com/necolas/status/360170108028600320)：

![“Replace ‘can you build this?’ with ‘can you maintain this without losing your minds?’” —Nicolas Gallagher](https://spaceninja.ghost.io/content/images/2016/11/necolas-1.jpg)

来源：[Nicholas Gallagher](https://twitter.com/necolas/status/360170108028600320)，图：[dotCSS](https://www.youtube.com/watch?v=L8w3v9m6G04)

这句话直指大规模 CSS 问题的核心。写代码并不难，难的是在不让你的代码随着时间的推移成为拖累你的“技术债”。

### 难以理解

以下是 [CSS Guidelines](https://cssguidelin.es/#naming-conventions-in-html) 中的一个示例，这个示例展示了一个问题：除了写这段代码的人，没有人知道这段代码是干什么的。

```
<div class="box profile pro-user">
  <img class="avatar image" />
  <p class="bio">...</p>
</div>
```

> `box` 和 `profile` 有什么关系？`profile` 和 `avatar` 有什么关系？或者他们之间真的有关系吗？你应该在 `bio` 旁边添加 `pro-user` 吗？`image` 和 `profile` 写在同一部分 CSS 吗？可以在其他地方使用 `avatar` 吗？

光看代码无法回答这些问题，你必须在 CSS 代码中推理他们的作用。

### 难以复用

复用代码会非常棘手。假设你要在另一个页面上复用某个页面上的样式，但你想这么做的时候，会发现那个样式是专为第一个页面而写的。代码的作者认为它只用在某个特定元素中，或者它是从页面继承某些类，在其他环境中根本不起作用。你不想修改原来的内容，然后直接复制了代码。

现在你有两个问题：一份原始代码，一份重复代码，你的维护负担直接增加了一倍。

### 难以维护

大规模的 CSS 也难以维护。你改变了一个标签，样式就会像纸牌屋一样崩溃。你想更新一个页面上的样式，却破坏了另一个页面的样式。你试图覆盖其他页面，但又深陷于优先度问题。

它让我想起了我最喜欢的 CSS 笑话之一：

![](https://i.loli.net/2018/09/29/5baf80a3771fb.png)

## 什么是模块化

那么我们如何解决这些问题呢？答案在于**模块化**这个概念，但这是什么呢？我们先看看 [Harry Roberts](https://twitter.com/csswizardry) 对[关注点分离](https://cssguidelin.es/#the-separation-of-concerns)的见解：

![“Code which adheres to the separation of concerns can be much more confidently modified, edited, extended, and maintained because we know how far its responsibilities reach. We know that modifying layout, for example, will only ever modify layout—nothing else.” —Harry Roberts](https://spaceninja.ghost.io/content/images/2016/11/csswizardry.jpg)

来源：[Harry Roberts](https://cssguidelin.es/#the-separation-of-concerns)，图：[CSSwizardry.com](https://csswizardry.com/)

这是一个常见编程习惯，但是许多 CSS 开发者不太熟悉。这个思想是确保你所写的东西不会比你想要做的更多。

举个例子，说明我在学习模块化 CSS 之前的工作方式。设计师给我这样的草图：

![Illustration of a design comp for a bookstore website](https://spaceninja.ghost.io/content/images/2018/09/bookstore-comp.gif)

图：[Yandex](https://github.com/bem-site/bem-method/blob/bem-info-data/articles/yandex-frontend-dev/yandex-frontend-dev.en.md)

我会觉得：“好吧，这是一个书店页面，侧边栏中有一些小部件，右侧列出了大概是书籍封面的清单，一个精选书评，下面还有其他的评论。”

我当时认为一个页面是一个完整的单元，页面里的较小部分从属于页面。这是一种自上而下的思考方法，这导致大量只服务于单个页面的一次性代码，不利于编写可复用代码。

![Illustration of a design comp for a bookstore with the components highlighted](https://spaceninja.ghost.io/content/images/2016/11/components.jpg)

图：[Yandex](https://github.com/bem-site/bem-method/blob/bem-info-data/articles/yandex-frontend-dev/yandex-frontend-dev.en.md)

模块化 CSS 需要你换一个角度看问题，不从页面级别考虑，而是关注组成页面的小块。这不是一个页面而是一个组件的集合。

你会发现页面里包含的是 logo，搜索栏，导航，照片列表，辅助导航，标签框，视频播放器等。这些是可以网站的任何位置都可以独立使用的内容。它们只是碰巧在这个特定页面以这种方式组合。

模块化 CSS 是自下而上的思维，需要从构建整个站点的可复用构建模块开始。

![Image of workers building with Lego bricks](https://spaceninja.ghost.io/content/images/2016/11/legos.png)

图：[BEM Method](https://github.com/bem-site/bem-method/blob/bem-info-data/articles/19-bem-principles/19-bem-principles.ru.md)

这会让你想起乐高？应该的！几乎所有撰写有关模块化 CSS 的人都使用乐高进行类比。使用标准化，易于理解，并且不依赖上下文的块来构建 UI 的是一个很好的思路。

这样的“块”最著名的例子之一是由 [Nicole Sullivan](https://twitter.com/stubbornella) 定义的“媒体对象”，她认为这种对象是你将在任何网站上找到的最小的组件之一。

![An example of the media object](https://spaceninja.ghost.io/content/images/2016/11/media-blocks.jpg)

它将固定宽度的图像组合到灵活宽度的容器的一侧，现在到处都可以看到这个模式。她撰写了一篇名为 [The Media Object Saves Hundreds of Lines of Code](http://www.stubbornella.org/content/2010/06/25/the-media-object-saves-hundreds-of-lines-of-code/) 的案例研究，谈到将此模式应用于大型网站，最大的例子之一便是 Facebook：

![The media object highlighted in red on the facebook homepage](https://spaceninja.ghost.io/content/images/2016/11/facebook-image-block.png)

图：[Nicole Sullivan](http://www.stubbornella.org/content/2010/06/25/the-media-object-saves-hundreds-of-lines-of-code/)

这里高亮显示了 Facebook 流中的所有媒体对象。左上角个人信息，右侧导航元素，订阅的每个帖子，甚至是广告都是媒体对象。有时它们彼此嵌套。虽然使用目的不同，但它们都共享相同的基础模式：固定宽度的图像，弹性宽度的文本。

她的观点是，以 Facebook 的规模运营时，媒体对象就不止几十个，这样的页面上有数百上千个。因此，可以想象如果为复用样式作优化，可以节省大量代码，这可以带来真正的高性能和低成本。

## 模块化框架

那么，既然我们已经明确了**模块化**的概念，那么让我们看看这些年来推崇这一概念的三大框架：

### OOCSS

面向对象的 CSS（Object-Oriented CSS）/ [OOCSS](https://github.com/stubbornella/oocss/wiki) 是模块化 CSS 的起源，由 [Nicole Sullivan](https://twitter.com/stubbornella) 于 2009 年提出，这基于她在雅虎的工作。这个框架的核心思想是 —— 对象是**可重用的模式（pattern）**，其视觉外观不由上下文决定。

* 有人质疑雅虎的能力，雅虎的前端团队当时研发的 [YUI library](https://yuilibrary.com/) 是非常前沿的技术。在 2009 年，雅虎不是一家没有前途的科技公司。

![“a CSS ‘object’ is a repeating visual pattern, that can be abstracted into an independent snippet of HTML, CSS, and possibly JavaScript. That object can then be reused throughout a site.” —Nicole Sullivan](https://spaceninja.ghost.io/content/images/2016/11/stubbornella.jpg)

来源：[Nicole Sullivan](https://github.com/stubbornella/oocss/wiki)，图：[John Morrison](https://www.flickr.com/photos/localcelebrity/6025913421/)

正如她在 2009 年所定义的那样，这就是模块化 CSS 的起源。除此之外，OOCSS 可归结为几个核心原则：

#### 上下文无关

首先，无论你把它放在哪里，一个对象都应该**看起来无差别**，不应根据对象的上下文设置对象的样式。

例如，不是将侧边栏中的所有按钮都设置为橙色，将主区域中的所有按钮设置为蓝色，而是应该创建一个蓝色的按钮类，以及一个橙色的 modifier。这样做橙色按钮可以在任何地方使用，它们没有被绑定在侧边栏上，它们只是你的按钮样式之一。

#### 皮肤（主题）

她谈到的另一个概念，是如何从**正在应用的皮肤**中抽象出**对象的结构**。

我们可以回到媒体对象的例子。它的样式与标签结构无关。有一个容器，一个固定宽度的图像和内容。你可以应用不同的样式，但是无论样式如何改变，标签结构都是一样的。

她建议的其他方法是为常见的视觉模式创建可复用的类。她给出了一个例子，在 2009 年的亚马逊网站几乎所有的东西都有阴影，但因为它们由不同设计师创作，所以相似却不相同。通过标准化这些元素阴影，可以优化代码并使网站更高效。

#### 使用 Class

当时她提出了一个非常具有争议性的规则，但后来被广为接受：使用 class 来命名对象及其子元素，这样可以在不影响样式的情况下修改 HTML 标签。

她不希望 CSS 由 HTML 标签来确定，这样的话如果将标题从“h1”更改为“h4”，则不必更新 CSS。无论选择哪个标签，该标题应该有一个固有的 class。例如，你的导航应该类似于 `.site-nav` **而不是** `#header ul`。

#### 不使用 ID

既然建议“总是使用 class”，那么自然禁止使用 ID 选择器。这与当时使用 ID 作为命名空间的常见实践相违背，直接引用嵌套在其中的元素。

ID 会扰乱 CSS 优先度，这是其次，对象必须是可复用的。根据定义，ID 是唯一的。因此，如果在对象上设置 ID，则无法在同一页面上重复使用它，缺少了模块化对象的要点。

### BEM

接下来介绍下一个弘扬模块化 CSS 精神的框架。[BEM](https://en.bem.info/methodology/)，三个字母分别代表 Block、Element、Modifier，BEM 也是在 2009 年提出，起源于 Yandex（可以说是俄语版的 Google），除搜索业务外还运营网络邮件程序，因此在编程上他们也需要解决与雅虎相同规模的难题。

他们提出了一套非常类似的代码原则。他们的核心概念是 —— **块（block）**（Nicole 称之为“物体（object）”）由子**元素（element）**构成，并且可以**修改（modified）**（或“主题化”）。

以下是其中一位负责 BEM 的开发者 [Varya Stepanova](https://twitter.com/varya_en) 对 BEM 的描述：

![“BEM is a way to modularize development of web pages. By breaking your web interface into components… you can have your interface divided into independent parts, each one with its own development cycle.” —Varya Stepanova](https://spaceninja.ghost.io/content/images/2016/11/varya.jpg)

来源：[Varya Stepanova](https://www.youtube.com/watch?v=ya7QsFUfn3U)，图：[ScotlandJS](https://www.youtube.com/watch?v=gWzYMJjtx-Y)

BEM 由 3 部分组成：

#### 块（Block）

块是网页逻辑和功能的独立组件。BEM 的发起人对其提出了更详尽的定义：

首先，块是**可嵌套的**。它们应该能被包含在另一个块中，而不会破坏任何样式。例如，可能在侧栏中有一个标签界面小部件的块，该块可能包含按钮，这些按钮也是一种单独的块。按钮的样式和选项卡式元素的样式不会相互影响，一个嵌套在另一个中，仅此而已。

其次，块是**可重复的**。界面应该能够包含同一块的多个实例。就像 Nicole 所说的媒体对象一样，复用块可以节省大量代码。

#### 元素（Element）

元素是块的组成部分，它不能在块之外使用。一个不错的例子：一个导航菜单，它包含的项目在菜单的上下文之外没有意义。你不会为菜单项定义块，菜单本身应定义为块，而菜单项是其子元素。

#### 修饰符（Modifier）

修饰符定义块的外观和行为。例如，菜单块的外观的垂直或水平，取决于所使用的修饰符。

#### 命名约定

BEM 所做的另一件事是定义了非常严格的命名约定：

`.block-name__element--modifier`

这看起来有点复杂，我来分解一下：

*   名称以小写字母书写
*   名称中的单词用连字符（`-`）分隔
*   元素由双下划线（`__`）分隔
*   修饰符由双连字符（`--`）分隔

这么说也有点抽象，举一个例子：

![Example of .minifig to indicate a lego minifig](https://spaceninja.ghost.io/content/images/2016/11/minifig-1.png)

现在我们有一个标准的乐高 minifig。他是一个蓝色的宇航员。我们将使用 `.minifig` 类来区分他。

![Example of .minifig module with child elements such as .minifig__head and .minifig__legs](https://spaceninja.ghost.io/content/images/2016/11/minifig-2.png)

可以看到 `.minifig` 块由较小的元素组成，例如 `.minifig__head` 和 `.minifig__legs`。现在我们添加一个修饰符：

![Example of .minifig--red module modifier, turning the minifig red](https://spaceninja.ghost.io/content/images/2016/11/minifig-3.png)

通过添加 `.minifig--red` 修饰符，我们创建了标准蓝色宇航员的红色版本。

![Example of a .minifig--yellow-new module modifier, turning the minifig yellow](https://spaceninja.ghost.io/content/images/2016/11/minifig-4.png)

或者，我们可以使用 `.minifig--yellow-new` 修饰符将我们的宇航员改为新式黄制服版。

![Example of a .minifig--batman module modifier making a drastic change in the appearance of the minifig](https://spaceninja.ghost.io/content/images/2016/11/minifig-5.png)

你可以使用同样的方式进行更夸张的修改。通过使用 `.minifig--batman` 修饰符，我们只用一个类就改变了 minifig 的每个部分的外观。

这是实践中的 BEM 语法例子：

```
<button class="btn btn--big btn--orange">
  <span class="btn__price">$9.99</span>
  <span class="btn__text">Subscribe</span>
</button>
```

即使不看样式代码，你也可以一眼就看出这段代码会创建一个既大又橙的价格按钮。无论你是否喜欢带有连字符和下划线的这种风格，拥有严格的命名约定是模块化 CSS 向前迈出的一大步，这让代码带有自文档的效果！

#### 不嵌套 CSS

就像 OOCSS 建议使用 class 而不使用 ID 一样，BEM 也为代码风格作了一些限制。最值得注意的是，他们认为不应该嵌套 CSS 选择器。嵌套选择器扰乱了优先度，使得重用代码变得更加困难。例如，只需使用 `.btn__price` **而不是** `.btn .btn__price`。

**注意：这里的嵌套指实践中在 Sass 或 Less 嵌套选择器的做法，但即使你没有使用预处理器也适用，因为这关乎选择器优先度问题。**

这个原则不出问题是因为严格的命名约定。我们曾经使用嵌套选择器将它们隔离在命名空间的上下文中。而 BEM 的命名约定本身就提供了命名空间，因此我们不再需要嵌套。即使 CSS 的根级别的所有内容都是单个类，但这些名称的具体程度足以避免冲突。

一般来说，选择器可以在没有嵌套的情况下生效，就不要嵌套它。 BEM 允许此规则的唯一例外是基于块状态或其修饰符的样式元素。例如，可以使用 `.btn__text` 然后用 `.btn--orange .btn__text` 来覆盖应用了修饰符按钮的文本颜色。

### SMACSS

我们最后要讨论的框架是 [SMACSS](https://smacss.com/)，含义是 CSS 的可扩展性和模块化架构（Scalable & Modular Architecture）。[Jonathan Snook](https://twitter.com/snookca) 于 2011 年提出了 SMACSS，当时他在雅虎工作，为 Yahoo Mail 编写 CSS。

![“At the very core of SMACSS is categorization. By categorizing CSS rules, we begin to see patterns and can define better practices around each of these patterns.” —Jonathan Snook](https://spaceninja.ghost.io/content/images/2016/11/snookca.jpg)

来源：[Jonathan Snook](https://smacss.com/book/categorizing)，图：[Elida Arrizza](https://www.flickr.com/photos/elidr/10864268273/)

他在 OOCSS 和 BEM 的基础上添加的关键概念是，不同**类别**的组件需要以不同的方式处理。

#### 类别（Categories）

以下是他为 CSS 系统可能包含的规则定义的类别：

1.  **基础（Base）** 规则是HTML元素的默认样式，如链接，段落和标题。
2.  **布局（Layout）** 规则将页面分成几个部分，并将一个或多个模块组合在一起。它们只定义布局，而不管颜色或排版。
3.  **模块（Module）**（又名“对象”或“块”）是可重用的，设计中的一个模块。例如，按钮，媒体对象，产品列表等。
4.  **状态（State）** 规则描述了模块或布局在特定状态下的外观。通常使用 JavaScript 应用或删除。例如，隐藏，扩展，激活等。
5.  **主题（Theme）** 规则描述了模块或布局在主题应用时的外观，例如，在 Yahoo Mail 中，可以使用用户主题，这会影响页面上的每个模块。（这非常适用于像雅虎这样的应用程序，但大多数网站都不会使用此类别。）

#### 命名约定前缀

下一个原则是使用前缀来区分类别，他喜欢 BEM 明确的命名约定，但他还希望能够一目了然地看出模块的类型。

*   `l-` 用作布局规则的前缀：`l-inline`
*   `m-` 用作模块规则的前缀：`m-callout`
*   `is-` 用作状态规则的前缀：`is-collapsed`

（基础规则没有前缀，因为它们直接应用于 HTML 元素而不使用类。）

## 共享模块化原则

这些框架的相同之处远胜于其不同之处。我看到从 OOCSS 到 BEM 再到 SMACSS 的明确发展。它们的发展代表了我们行业在性能和大规模 CSS 领域不断增长的经验。

你不必选择其中一个框架，相反，我们可以尝试定义模块化 CSS 的通用规则。让我们看看这些框架共用和保留的最佳部分。

### 模块化元素

模块化系统由以下元素组成：

*   **模块（Module）：**（又名对象，块或组件）一种可复用且自成一体的模式。如媒体对象，导航和页眉。
*   **子元素（Child Element）：** 一个不能独立存在的小块，属于模块的一部分。如媒体对象中的图像，导航选项卡和页眉 logo。
*   **模块修改器（Module Modifier）：**（又名皮肤或主题）改变模块的视觉外观。如左/右对齐的媒体对象，垂直/水平导航。

### 模块化类别

模块化系统中的样式可以分为以下几类：

*   **基础（Base）** 规则是 HTML 元素的默认样式，如：`a`、`li` 和 `h1`
*   **布局（Layout）** 规则控制模块的布局方式，但不控制视觉外观，如：`.l-centered`、`.l-grid` 和 `.l-fixed-top`
*   **模块（Modules）** 是可复用的，独立的 UI 组件视觉样式，如：`.m-profile`、`.m-card` 和 `.m-modal`
*   **状态（State）** 规则由 JavaScript 添加，如：`.is-hidden`、`.is-collapsed` 和 `.is-active`
*   **助手（Helper）**（又名功能）规则适用范围小，独立于模块，如：`.h-uppercase`、`.h-nowrap` 和 `.h-muted`

### 模块化规则

在模块化系统中编写样式时，请遵循以下规则：

*   不要使用 ID
*   CSS 嵌套不要超过一层
*   为子元素添加类名
*   遵循命名约定
*   为类名添加前缀

## FAQ

### 这么做 HTML 不会有很多类吗？

模块化 CSS 最常见的反对意见就是，它会在 HTML 中产生许多类。我认为这是因为长期以来 CSS 的最佳实践都认为应该避免大量 class 使用。早在 2011 年，Nicole Sullivan 就写了一篇很棒的博文 [Our (CSS) Best Practices are Killing Us](http://www.stubbornella.org/content/2011/04/28/our-best-practices-are-killing-us/)，明确驳斥了这个想法。

我看到一些开发人员提倡使用预处理器的 `extend` 函数将多个样式连接成一个类名。我建议不要这样做，因为它会使你的代码不那么灵活。他们不能让其他开发者以新的方式组合你的乐高积木，而是固定了你定义的几种组合。

#### BEM 的类名又长又丑！

不要因为类名太长而害怕，他们是自文档的！当我看到 BEM 风格的类名（或任何其他模块化命名约定）时，我会觉得很愉悦，因为只要看一眼就能知道这些类的含义。你可以在 HTML 中清晰理解它们。

### 孙元素的命名如何约定？

长话短说：没这回事。

模块化 CSS 初学者可以快速掌握子元素的概念：`minifig__arm` 是 `minifig` 的一部分。然而，有时候他们处理 CSS 中的 DOM 结构时，会疑问如何作深层嵌套，比如 `minifig__arm__hand`。

没有必要这样做。请记住，这个思路是要将样式与标记分离。无论 `hand` 是 `minifig` 的直接子元素还是嵌套了多少层，都无关紧要。CSS 关心的只有 `hand` 是 `minifig` 的孩子。

```
.minifig {}
  .minifig__arm {}
      .minifig__arm__hand {} /* don't do this */
  .minifig__hand {} /* do this instead */
```

### 模块冲突怎么办？

模块化 CSS 初学者比较关注的另一件事是模块之间的冲突。例如，如果我将 `l-card` 模块和 `m-author-profile` 模块同时应用于同一个元素，是否会导致问题？

答案是：理想情况下，模块不应该重叠太多。在这个例子中，`l-card` 模块关注布局，而 `m-author-profile` 模块关注样式，你可能会看到 `l-card` 设置宽度和边距，而 `m-author-profile` 设置背景颜色和字体。

![](https://i.loli.net/2018/09/29/5baf81580aa8a.png)

测试模块是否冲突的一种方法是以随机顺序加载它们。你可以将项目构建配置中设定为在构建时随机交换样式位置。如果看到bug，就证明你的 CSS 需要以特定顺序加载。

如果你发现需要将两个模块应用于同一个元素并且它们存在冲突，请考虑它们是否真的是两个独立的模块。也许它们可以用一个修饰符组合成一个模块？

该规则的最后一个例外是“helper”或“utility”类可能会发生冲突，在这些情况下，你可以安全地考虑使用 `!important`。我知道，你曾被告知 `!important` 不是什么好东西，永远不应该被使用，但我们的做法有细微的差别：主动使用它来确保 helper 类总是优先还是不错的。 （[Harry Roberts has more to say on this topic in the CSS Guidelines](https://cssguidelin.es/#important)。）

<h2 name="c6">总结，模块化 CSS 太美妙啦</h2>

我们来简要回顾一下，还记得这段代码吗？

```
<div class="box profile pro-user">
  <img class="avatar image" />
  <p class="bio">...</p>
</div>
```

> `box` 和 `profile` 有什么关系？`profile` 和 `avatar` 有什么关系？或者他们之间有关系吗？你应该在 `bio` 旁边添加 `pro-user` 吗？`image` 和 `profile` 写在同一部分 CSS 吗？可以在其他地方使用 `avatar` 吗？

现在我们知道如何解决这些问题了。通过编写模块化 CSS 并使用适当的命名约定，我们可以编写自文档的代码：

```
<div class="l-box m-profile m-profile--is-pro-user">
  <img class="m-avatar m-profile__image" />
  <p class="m-profile__bio">...</p>
</div>
```

我们可以看到哪些类彼此相关，哪些类彼此不相关，以及如何相关。我们知道在这个组件的范围之外我们不能使用哪些类，当然，我们还知道哪些类可以在其他地方复用。

模块化 CSS 简化了代码并推进了重构，产出自文档的代码，这样的代码不影响外部作用域且可复用。

或者换句话说，**模块化 CSS 是可预测的，可维护的并且是高性能的。**

现在我们可以重温那个老笑话，结局发生了变化：

![Two CSS properties walk into a bar. Everything is fine, thanks to modular code and proper namespacing.](https://spaceninja.ghost.io/content/images/2016/11/updated-tweet.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

