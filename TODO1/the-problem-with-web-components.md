> * 原文地址：[The problem with web components](https://adamsilver.io/articles/the-problem-with-web-components/)
> * 原文作者：[Adam Silver](https://adamsilver.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-problem-with-web-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-problem-with-web-components.md)
> * 译者：[stevens1995](https://github.com/Stevens1995)
> * 校对者：[Baddyo](https://github.com/Baddyo), [Moonliujk](https://github.com/Moonliujk)

# Web 组件的问题

[Web 组件](https://www.webcomponents.org/introduction)在 Web 社区中变得越来越受欢迎。它们提供了一种在没有框架的情况下标准化和封装 JavaScript 增强组件的方法。

然而，Web 组件有一些缺点。例如，他们有一些技术限制，很容易被误用，导致用户流失。

有可能 —— 当然也是我的希望 —— Web 组件会随着时间的推移而改进，这些问题将得到解决。但是现在，我还是暂时搁置这些。

在本文中，我将解释为什么会这样。同时建议使用开发组件的一种替代方法。

## 它们是有限制的

Michael Haufe 在他的[对 Web 组件的批评](https://thenewobjective.com/a-criticism-of-web-components/)中解释到：

* 自定义的 CSS 伪选择器不能与 Web 组件一起使用
* 它们无法与原生元素及其相关的 API 无缝协作
* 例如，如果我们想创建一个自定义的按钮，我们不能直接继承 [HTMLButtonElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLButtonElement)，而不得不继承 [HTMLElement](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement)

此外，Web 组件必须通过 ES2015 中的类来定义，这意味着它们无法被转换从而为更多人提供更好的体验。

因此，直接使用 Web 组件时，有许多技术限制需要解决。

## 它们没有被广泛地支持

目前，Web 组件的跨浏览器支持相对较差。所以增强的用户体验不是对每个人都有效。

![Web 组件在 caniuse.com 上面的支持情况](https://adamsilver.io/assets/images/web-component-can-i-use.png)

这并不表示我们不可以使用它们，只是意味着我们需要[提供一个对每个人都有效的基本的用户体验](https://adamsilver.io/articles/thinking-differently-about-progressive-enhancement/)。这是一个渐进式的增强。

但我们应该认真考虑使用 Web 组件是否是最具包容性的选择。如果我们不使用 Web 组件，我们可以为更广泛的人群提供同样丰富的体验。我稍后会作解释。

Polyfill 提供了一种提供更广泛支持的方法。但当使用它来使 Web 组件有效范围更广时，他们通常[缓慢、不可靠且难以工作](https://adamsilver.io/articles/the-disadvantages-of-javascript-polyfills/)，并且有一些[特定的限制](https://www.webcomponents.org/polyfills#known-limitations)。

所以虽然我们作为编码人员更喜欢使用基于标准的技术，但是这对于用户来说并不一定是有益的 —— 这应该是我们的首要任务。

## 它们很容易被误解和误用

Jeff Atwood 说过任何可以使用 JavaScript 编写的应用，最终都会用 JavaScript 来编写。

但是仅仅因为我们能用 JavaScript 来做一些事情，并不意味着我们应该使用它。甚至还有一个 W3 原则说我们应该使用[最不强大的工具](https://www.w3.org/2001/tag/doc/leastPower.html)。

Web 组件由 JavaScript API 组成，这意味着我们只应该在需要 JavaScript 时使用它们。但是像 Jeff Atwood 预测的那样，人们有时会在不需要时用到 Web 组件。

当我们使用了 JavaScript 作为依赖但没有提供任何回退方案时，用户会得到很糟糕的体验。[当 JavaScript 不可用时](https://kryogenix.org/code/browser/everyonehasjs.html)，甚至连 [webcomponents.org](http://webcomponents.org)（用 Web 组件构建）都显示了一个空白页。

![当 JavaScript 不可用时，webcomponents.org 上完全破碎的用户体验](https://adamsilver.io/assets/images/web-components-org-no-js.png)

出于同样的原因，鼓励人们制作使用 AJAX 请求数据并自我渲染的组件，就像小的 iframes 一样。

这种方法会造成一些可以避免的问题，我将通过一个例子来解释。

想象一下我们想要加载一张表格来展示我们网站产品的销售数据，如下所示：

```html
<sales-figures></sales-figures>
```

首先，这只是一张表。没有列的排序，因此不需要 JavaScript。浏览器为此提供了 `<table>` 表格，它可以在任何地方使用。

其次，像上面提到的那样，当浏览器不支持 Web 组件，或者 JavaScript 运行失败时，用户将什么都看不到。

为了让我们的表格在这些情况下工作，我们需要把 `<table>` 放到 `<sales-figures>` 中。这被称为优雅降级。

```html
<sales-figures>
  <table>...</table>
</sales-figures>
```

如果组件在页面加载时已经有一个填充好的表格，用 `<sales-figures>` 包裹它会导致我们和用户什么都得不到。

最后，使用 AJAX 会引入一些可用性和可访问性的问题。

1. [AJAX 通常比页面刷新更慢](https://jakearchibald.com/2016/fun-hacks-faster-content/)，而并非更快。
2. 我们需要创建自定义的加载指示器，与浏览器的加载指示器不同，这些指示器对用户来说通常是不准确且不熟悉的。
3. 我们需要[让 AJAX 可跨域工作](https://zinoui.com/blog/cross-domain-ajax-request)，这不是直接了当的。
4. 当组件加载时页面将会抖动，从而导致[视觉故障](https://twitter.com/chriscoyier/status/1057303249902952448)，并可能让用户点击错误的东西。你可能听到过 [skeleton 接口](https://medium.com/@rohit971/boost-your-ux-with-skeleton-pattern-b8721929239f)是解决这个问题的一种方法。它们是放置在组件加载后最终显示位置的占位符。但是虽然它们有所帮助，却没有完全解决问题，因为它们无法一直预测将要加载的内容的确切大小。
5. 第 4 点同样会影响使用屏幕阅读器的用户，因为他们不知道组件是否已经加载、加载失败或者正在加载的过程当中。ARIA 实时区域提供了一种将这些状态传达给屏幕阅读器的方法。但当多个组件加载时，用户将被通告轰炸。

当这些扩展到一个屏幕上的多个 Web 组件时，我们可能会给用户带来非常不愉快、独特和缓慢的体验。

依赖于请求服务器的 AJAX 的组件不再是框架感知不到的，因此可以相互操作。由于互相操作性和技术上的不可知性是他们旨在提供的 2 个主要优点，这在某种程度上违背了使用 Web 组件的目标。

重要的是，这些问题都不是 Web 组件本身的错误。没有 Web 组件的话，我们可以很轻松的开发出这样的组件。但是，正如展示的那样，这很容易误解 Web 组件，并且在不知情的情况下以伤害用户和代码作者的方式使用它们。

## 它们很难组织

假设我们有 2 个 Web 组件。一个用于可排序表，另一个用于可扩展行。

```html
<sortable-table>
  <table>...</table>
</sortable-table>

<expandable-rows>
  <table>...</table>
</expandable-rows>
```

但是如果我们想要一个有可扩展行的可排序表，我们需要向这样嵌套组件：

```html
<expandable-rows>
  <sortable-table>
    <table>...</table>
  </sortable-table>
</expandable-rows>
```

`<expandable-rows>` 和 `<table>` 之间的关系是不明确的。比如，很难判断 `<expandable-rows>` 是操作在 `<table>` 上或者 `<sortable-table>` 上。

顺序也同样重要。如果每个组件都增强了表，则可能会造成冲突。此外，也不清楚是外部还是内部的组件先初始化了表。

**（注意：你可能听过 `is` 属性是一种解决方法，但 Jeremy Keith 解释说浏览器不会在[可扩展的 Web 组件]https://medium.com/@adactio/extensible-web-components-e794559b8c2e)实现这一点。）**

## 它们不可以直接在应用中使用

Web 组件的一个预期的好处是我们可以将每个组件的一个脚本放在页面上，它们就会工作 —— 不用关心应用的技术栈。

但与标准元素不同，我们可能需要添加额外的代码来使它们正常工作。在某些方面，这有点像添加一个框架或者库。

这方面的一个实例就是我前面提到的 polyfill。如果你选择使用 polyfill 来提供更广泛地支持，那么你需要在网页中准备好相应的代码。

另一个实例是当你需要阻止 JavaScript 增强的组件[在初始化时造成页面抖动](https://twitter.com/adambsilver/status/1119123828884434945)。

这通常通过在文档的 `<head>` 里面添加一个 script 标签以[提供 CSS 钩子](https://css-tricks.com/snippets/javascript/css-for-when-javascript-is-enabled/)来解决。这反过来可以用来通过可用的 JavaScript 来调整组件的样式，并避免页面抖动。

这可能总体上没什么影响，但它确实否定了使用 Web 组件可能带来的好处之一。

## 不使用 Web 组件和框架的组件

你可能已经听过[使用 Web 组件作为框架的替代方案](https://medium.com/@oneeezy/frameworks-vs-web-components-9a7bd89da9d4)。

虽然我赞成在没有客户端框架的情况下创建接口，但出于一些原因，这可能会产生误导。

首先，除了增强界面部分之外，客户端框架通常会提供额外的功能。

其次，Web 组件可以和框架一起使用。

最后，很长一段时间以来，我们已经可以在没有框架和 Web 组件的情况下创建 JavaScript 增强的组件。

通过这种方式来创建组件，我们可以避免我在文章中描述的缺点。

我们使用前面相同的可排序表和行扩展器来演示一下。

首先，我们需要为每个组件创建一个 JavaScript 文件，就像我们使用 Web 组件时一样。我们可以在其中定义 `SortableTable` 和 `RowExpander` 类。

```js
SortableTable.js // 定义 SortableTable 类及相关行为
RowExpander.js // 定义 RowExpander 类及相关行为
```

完成后，我们可以像这样初始化组件：

```js
// 获取表
var table = document.querySelector('table');

// 初始化可排序表
var sortable = new SortableTable(table);

// 初始化行扩展器
var expander = new RowExpander(table);
```

我们可以使这些组件像 Web 组件一样触发事件。类似这样：

```js
sortable.addEventListener(‘sort’, fn);
expander.addEventListener(‘expand’, fn);
```

通过这种方式使用常规的 JavaScript，我们不仅可以写出干净的代码，不受技术的限制，更可以让代码作用于更广泛的用户。

## 总结

Web 组件很有前景，因为它们为开发者提供了一种基于标准创建可互相操作组件的方法。

因此，我们能够更容易理解其他人的代码并创建可以跨项目重用的组件。

但就算我们专门为支持它们的前沿浏览器做加强，仍然存在一些我们需要解决的限制和问题。

我希望 Web 组件能够在将来变得更好。但在那之前，我还是坚持使用常规的 JavaScript 来避免当前的技术限制，为用户提供最合理的体验。

**非常感谢 [Amy Hupe](https://amyhupe.co.uk/)，她不仅从头到尾编辑了这版文章，还尽可能使其变得简单和直观。这对于一篇关于讲述了 Web 组件全部事情的文章来说并不容易。** 🙌

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
