> * 原文地址：[Exploring SMACSS: Scalable and Modular Architecture for CSS](https://www.toptal.com/css/smacss-scalable-modular-architecture-css)
> * 原文作者：[SLOBODAN GAJIC](https://www.toptal.com/resume/slobodan-gajic)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/smacss-scalable-modular-architecture-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/smacss-scalable-modular-architecture-css.md)
> * 译者：[park-ma](https://github.com/Park-ma)
> * 校对者：

# 探索SMACSS：可扩展的模块化 CSS 框架

当我们在从事大项目或团队开发工作时，我们经常会发现我们写的代码，凌乱、难以阅读并且难以扩展。 在经过一段时间后尤其是这样，我们回头再看我们的代码时 — 我们必须尝试进入与我们写代码时相同的状态。

因此，人们创建了许多 [CSS](https://www.toptal.com/css) 框架，以帮助对其代码进行样式化，使 CSS 代码变得更具可读性。**SMACSS** 即 **Scalable（可扩展）**和**Modular Architecture（模块化）**的**CSS** 就旨在实现这一点。这是我采用的 Jonathan Snook 的CSS 框架指南。

SMACSS 的架构方法与 Bootstrap 或 Foundation 等 CSS 框架略有不同。相反，它是一组规则，更是一套模板或指南。因此，这让我们深入探究一些 CSS 设计模式，以便让我们的代码写的更好更[整洁](https://www.toptal.com/front-end/frontend-clean-code-guide)更易读，更具有模块化。

每个 SMACSS 项目结构分为 5 种规则：

1.  Base（基础）
2.  Layout（布局）
3.  Modules（模块）
4.  State（状态）
5.  Theme（主题）

## Base（基础规则）

在 SMACSS 里，基础规则是用来定义元素在网页的任何地方的默认样式的。如果你在使用重置样式，这确保你在不同的浏览器的显示样式是相同的，尽管它们内部的 CSS 默认代码略有不同。

在基础规则中，你应该只包含基本元素选择器或者那些伪类选择器，不包含类选择器或者 ID 选择器。（您应该有充分的理由将类或ID放入其中，可能只有在您设计第三方插件的元素时才需要覆盖该特定元素的默认样式。）

这是一个基础规则的文件单元的例子：

```css
html {
    margin: 0;
    font-family: sans-serif;
}

a {
    color: #000;
}

button {
    color: #ababab;
    border: 1px solid #f2f2f2;
}
```

它应该包含计划在整个网站上使用的默认的大小、边距、颜色、边框和其他默认值。你的排版和表单元素应该在每个页面上具有统一的样式，并给人一种它们是相同设计和主题的感觉和外观。

信不信由你，我强烈建议在 SMACSS 中尽量避免使用 `!important`,也不要使用深嵌套，关于为什么我会在这篇帖子的后面进行深入讨论。 此外，如果你正在练习使用重置 CSS，那么你应该包含它（我更喜欢使用 Sass，这样我就可以把它们只包含在文件的顶部，而不需要将其复制或者在每个页面的 `<header>` 元素单独引用。）。

**相关资源：** [Theming with Sass: An SCSS Tutorial](https://www.toptal.com/sass/theming-scss-tutorial)

## Layout（布局规则）

布局将会把页面分成几个主要部分 — 不是导航或折叠面板等部分，而是真正的顶级划分。

![Example SMACSS layout styles: header, sidebar, content/main, and footer](https://uploads.toptal.io/blog/image/126678/toptal-blog-image-1532005221485-9d465e68a1d43f1f2c19d0cdc8e3b389.png)

SMACSS 布局规则包括标题、侧边栏、正文、页脚等主要部分。

这些布局包括多个 CSS 模块例如 boxes ,cards ,unordered lists ,galleries 等，但我们会在下一节讨论跟多关于这些模块。让我们通过一个网页例子来考虑布规则是如何工作的：

![An example web page that can be organized into header, main, and footer layout styles using SMACSS](https://uploads.toptal.io/blog/image/126676/toptal-blog-image-1532003633585-029d918ef1d38dd3573bb593bb87cdda.png)

这我们有标题、正文和页脚。这些布局在例如标题的链接和 logo，正文的盒子结构和文章，页脚的链接和版权上都有模块。我们通常为布局规则提供 ID 选择器，因为它们在网页里不可重复并且是唯一的。

你还应该使用字母 `l` 为布局规则添加前缀，以区分其他的模块样式。通常你可以设置特定于布局的东西，比如边框，对齐，边距等。同时页面的背景也很有意思，即使它看起来不像特定的布局。

这是一个布局规则的例子：

```css
#header {  
    background: #fcfcfc;
}

#header .l-right {
    float: right;
}

#header .l-align-center {
    text-align: center;
}
```

你还可以为对齐添加帮助，这样你可以使用帮助来更容易的通过为子项添加合适的类的方式来定位元素或者对齐文本。

另一个例子，你可以在布局框中使用一些默认的页边距，例如 `.l-margin` 有 `20px` 的页边距。然后，无论您想要填充某个 container ,element,card,或者 box ，只需将 `l-margin` 类添加到其中即可。但是你可以想要可重用的东西：

```css
.l-full-width {
    width: 100%;
}
```

不是想这样内部耦合的东西：

```css
.l-width-25 {
    width: 25px;
}
```

* * *

我想花点时间谈谈 SMACSS 中的命名规则。如果您从未在 CSS 中听说过命名空间的概念，那它基本上就是将名称添加到另一个元素的开头，以帮助区分它与其他任何元素。但为什么我们需要它呢？

我不知道你是否遇到过下面的问题。你正在编写 CSS 代码而且你有标签去标记 — 你喜欢的任何样式，并命名了 `.lable` 类。但是之后你又遇到另一个元素，你还想命名为 `.label` 但样式不同。所以两个不同的东西有一个相同的名称 — 命名冲突。

命名空间可帮助您解决此问题。最终，它们在同一级别上被称为相同的东西，但它们具有不同的命名空间 — 不同的前缀 — 因此可以表示两种不同的样式：

```css
.box--label {
    color: blue;
}

.card--label {
    color: red;
}
```

## Module（模块规则）

正如我之前提到的，SMACSS 模块是页面上可重用的更小的代码，是布局的一部分.这些是我们想要存储在单独文件夹的 CSS 文件的一部分，因为我们在一个网页会有很多这样的模块代码。并且随着项目的增长，我们可以通过文件夹结构来拆分，即通过模块/页面：

![An example file/folder hierarchy using SMACSS and Sass](https://uploads.toptal.io/blog/image/126677/toptal-blog-image-1532004385659-636d848a5fbaad6340f79d6ad89ac1d8.png)

所以在前面的例子里，我们有一篇文章，它可以是一个独立的模块。如何在这里构建 CSS 呢？我们应该有一个 `.article` 的类里面有 `title` 和 `text` 的子元素。因此，为了让它们保存在同一模块，我们需要在子元素上使用前缀：

```css
.article {
    background: #f32;
}

.article--title {
    font-size: 16px;
}

.article--text {
    font-size: 12px;
}
```

你一定注意到我们在模块前缀后面使用两个连字符。这是因为有时模块名称有两个单词或者它们的前缀类似  `big-article`。我们需要两个连字符来描述子元素的位置例如比较 `big-article-title` 、 `big-article--title` 和 `big-article--text`。

此外，如果特定模块占用了大部分页面，您可以将模块嵌套在模块中：

```HTML
<div class="box">
    <div class="box--label">This is box label</div>
    <ul class="box--list list">
        <li class="list--li">Box list element</li>
    </ul>
</div>
```

在这个简单的例子中，你可以看到 `box` 是一个模块 `list` 是在它里面的另一个模块。使用 `list--li` 是 `list` 模块的子项而不是 `box` 的。这里的关键概念是每个 CSS 规则最多有两个选择器，但在大多数情况下只有一个带前缀的选择器。

这样，我们可以避免重复规则，并且在具有相同名称的子元素上具有额外的选择器，从而提高速度。它也有助于我们避免使用不需要的 `!important` 规则，这些规则是结构不合理的 CSS 项目的标志。

好的例子（注意单选择器）：

```css
.red--box {
    background: #fafcfe;
}

.red-box--list {
    color: #000;
}
```

不好的例子（注意选择器内的重复和重叠）：

```css
.red .box {
    background: #fafcfe;
}

.red .box .list {
    color: #000;
}

.box ul {
    color: #fafafa;
}
```

## State（状态规则）

在 SMACSS 中状态规则是描述我们的模块在不同状态下显示外观的一种方式。所以说这一部分是关于交互性的：我们需要有不同的行为去描述元素的隐藏、扩展或修改。例如，jQuery 折叠面板控件将会帮助定义某个元素内容何时可见何时不可见。它有助于我们在特定时刻定义元素的样式。

如果状态规则与布局规则应用于同一元素时，这时我们添加了一个额外的规则，那么该规则将覆盖以前的规则（如果有的话）。状态规则优先，因为它是规则链中的最后一个规则。

与布局规则一样，我们建议在状态规则使用前缀。这有助于我们识别它们并给予它们优先权。 这里我们使用 `is` 前缀，如 `is-hidden` 或 `is-selected`.

```HTML
<header id="header">
    <ul class="nav">
        <li class="nav--item is-selected">Contact</li>
        <li class="nav--item">About</li>
    </ul>
</header>
```

```css
.nav--item.is-selected {
    color: #fff;
}
```

在这里，`!important` 是可以使用的，因为状态规则经常被用于 JavaScript 的修改而不是渲染时。Here, `!important` may be used, as state is often used as a JavaScript modification and not at render time.例如，你需要一个元素在网页加载时是隐藏的，当点击按钮的，你希望显示它，但是默认类像下面这样：

```css
.box .element {
    display: none;
}
```

因此如果你添加了下面的代码：

```css
.is-shown {
    display: block;
}
```

即使你通过 JavaScript 添加了 `.is-shown` 之后它还是隐藏的，这是因为第一条规则是二级深度的并将它覆盖。

因此你可以改为这样定义状态类：

```css
.is-shown {
    display: block !important;
}
```

这就是我们如何区分状态规则和布局规则，它们仅适用于页面的初始加载。这将在保持最小选择器的同时发挥作用。

## Theme（主题规则）

这个应该是最显而易见的规则，因为它定义了颜色、形状、边框、阴影还有其他等等。这些大多数都是在网站上重复使用的元素。我们不必在每次使用它们的时候都重新定义它们一下，相反，我们希望定义一个独特的类然后使用时只需添加上即可。

```css
.button-large {
    width: 60px;
    height: 60px;
}
```

```html
<button class="button-large">Like</button>
```

不要将 SMACSS 主题规则和基础规则混淆，基础规则定义了默认外观，类似于重置为默认浏览器设置，而主题规则定义了一组最终外观的样式，唯一的颜色方案。

主题规则也可以非常有用当网站具有多个样式或者可能在不同状态中使用几个主题时，因为这样主题规则可以在页面上的某些事件容易地改变或交换，例如，带有主题切换按钮。 至少，他们将所有主题风格保存在一个地方，以便你可以轻松地更改它们并使它们保持良好的组织结构。

## CSS 组织方法

我已将介绍了这个 CSS 架构思想的关键概念。如果你想了解更多关于，请访问 [SMACSS 的官方网站](https://smacss.com/)并进行深入的了解。

你也可以使用更高级的方法例如 [OOCSS 和 BEM](https://medium.com/@Intelygenz/how-to-organize-your-css-with-oocss-bem-smacss-a2317fa083a7)。后者几乎包含了关于所有前端工作流程和技术。但是一些人会觉得 BEM 的选择器太长，使用起来太复杂。如果你需要更简单易懂，并容易将其纳入你的工作流程 — 以及为你和你的团队定义基本规则的东西 — SMACSS 非常适合。

这不仅让团队新成员很容易的理解以前开发者的工作，还帮助他们快速上手项目，并没有任何代码风格上的差异。 SMACSS 只是一个 CSS 框架，它完成了它所描述的工作，不多也不少。

## 了解基础知识

### CSS 有几种不同的类型？

有三种不同的类型。内联 CSS 直接放在 HTML 元素的样式属性上。内部 CSS 位于 HTML `header`  内部 `style` 标签内。外部 CSS 是由 HTML 文件提供的单独的文件，避免网站在不同网页内编写重复的代码。

### ”CSS 模板“是什么意思？

CSS 模板通常是用来定义特定的布局以便我们可以在多个网页甚至整个网站上使用它们。但是除了布局，它们有时也用来为特定元素例如模态框和按钮甚至它们的组合而定义的一组规则。其他一些则用来定义 HTML 元素的默认值。

### 为什么 CSS 如此重要？

CSS 在现代网页中绝对是必须的。没有它，网页只是纯文本和空白背景上的图片。 它不仅给网页提供样式，还组织布局和提供动画效果 — 因此它对互交性也很重要。

### 使用 CSS 有什么优点？

一个主要的优点是将所有的样式放在一起而不是让它们分散在整个网站的每一个元素上。它为我们提供了更多的格式选项，有助于优化页面加载时间和增加代码的重用性。

### 为什么可扩展性如此重要？

一般来说，可扩展性对于在项目增长时的可伸缩性和可维护性非常重要。特别是在CSS中，如果我们编写的代码不具备可扩展性和模块化，它会迅速失去控制，变得难以理解和工作，特别是对于新手而言。 因此我们需要 SMACSS。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
