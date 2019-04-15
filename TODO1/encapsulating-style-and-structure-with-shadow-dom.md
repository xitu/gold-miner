> * 原文地址：[Encapsulating Style and Structure with Shadow DOM](https://css-tricks.com/encapsulating-style-and-structure-with-shadow-dom/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[邪无神](https://github.com/undead25)、[Ziyin Feng](https://github.com/Fengziyin1234)

# 使用 Shadow DOM 封装样式和结构

该系列由 5 篇文章构成，对 Web Components 规范进行了讨论，这是其中的第四部分。在[第一部分](https://juejin.im/post/5c9a3cce5188252d9b3771ad)中，我们对于 Web Components 的规范和具体做的事情进行了全面的介绍。在[第二部分](https://juejin.im/post/5ca5b858e51d4524a918560f)中我们开始构建一个自定义的模态框，并且创建了 HTML 模版，这在[第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)中将演变为我们的自定义 HTML 元素。

#### 系列文章：

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [编写可以复用的 HTML 模板](https://juejin.im/post/5ca5b858e51d4524a918560f)
3.  [从 0 开始创建自定义元素](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构（**本文**）](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web Components 的高级工具](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

* * *

在开始阅读本文之前，我们建议你先阅读该系列文章中的前三篇，因为本文的工作是以它们为基础构建的。

我们在上文中实现的对话框组件具有特定的外形，结构和行为，但是它在很大程度上依赖于外层的 DOM，它要求使用者必须理解它的基本外形和结构，更不用说允许使用者编写他们自己的样式（最终将修改文档的全局样式）。因为我们的对话框依赖于 id 为 “one-dialog” 的模板元素的内容，所以每个文档只能有一个模态框的实例。

目前对于我们的对话框组件的限制不一定是坏的。熟悉对话框内部工作原理的使用者可以通过创建自己的 `<template>` 元素，并定义他们希望使用的内容和样式（甚至依赖于其他地方定义的全局样式）来轻松地使用对话框。但是，我们希望在元素上提供更具体的设计和结构约束以适应最佳实践，因此在本文中，我们将在元素中使用 shadow DOM。

### 什么是 shadow DOM ？

在[介绍文章](https://juejin.im/post/5c9a3cce5188252d9b3771ad)中我们说到，shadow DOM ”能够隔离 CSS 和 JavaScript，和 `<iframe>` 非常相似“。在 shadow DOM 中选择器和样式不会作用于 shadow root 以外，shadow root 以外的样式也不会影响 shadow DOM 内部。不过有一些特例，像是 font family 或者 font sizes（例如：`rem`）可以在内部重写覆盖。

但是不同于 `<iframe>`，所有的 shadow root 仍然存在于同一份文件当中，因此所有的代码都可以在指定的上下文中编写，而不必担心和其他样式或者选择器冲突。

### 在我们的对话框中添加 shadow DOM

为了添加一个 shadow root（shadow 树的基本节点/文档片段），我们需要调用元素的 `attachShadow` 方法：

```
class OneDialog extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
    this.close = this.close.bind(this);
  }
}
```

通过调用 `attachShadow` 方法并设置参数 `mode: 'open'`，我们在元素的 `element.shadowRoot` 属性中保存一份对 shadow root 的引用。`attachShadow` 方法将始终返回一个 shadow root 的引用，但是在这里我们不会用到它。

如果我们调用 `attachShadow` 方法并设置参数 `mode: 'closed'`，元素上将不会存储任何引用，我们必须通过使用 `WeakMap` 或者 `Object` 来实现存储和检索，将节点自身设置为键，shadow root 设置为值。

```
const shadowRoots = new WeakMap();

class ClosedRoot extends HTMLElement {
  constructor() {
    super();
    const shadowRoot = this.attachShadow({ mode: 'closed' });
    shadowRoots.set(this, shadowRoot);
  }

  connectedCallback() {
    const shadowRoot = shadowRoots.get(this);
    shadowRoot.innerHTML = `<h1>Hello from a closed shadow root!</h1>`;
  }
}
```

我们还可以在元素自身上保存对 shadow root 的引用，通过使用 `Symbol` 或者其他的键来设置 shadow root 为私有属性。

通常，有一些原生元素（例如：`<audio>` 或者 `<video>`），它们会在自身的实现中使用 shadow DOM，shadow root 的关闭模式就是为了这些元素而存在的。此外，基于库的架构方式，在元素的单元测试中，我们可能无法获取 `shadowRoots` 对象，导致我们无法定位到元素内部的更改。

**对于用户主动使用关闭模式下的 shadow root 可能存在一些合理的用例，但是数量很少而且目的各不相同**，所以我们将在我们的对话框中坚持使用 shadow root 的打开模式。

在实现新的打开模式下的 shadow root 之后，你可能注意到现在当我们尝试运行时，我们的元素已经完全无法使用了：

在 [CodePen](https://codepen.io) 中查看[对话框示例：使用模板以及 shadow root](https://codepen.io/calebdwilliams/pen/WPLwzv/)。

这是因为我们之前拥有的所有内容都被添加在传统 DOM（我们称之为[light DOM](https://stackoverflow.com/questions/42093610/difference-between-light-dom-and-shadow-dom)）中，并在其中被操作。既然现在我们的元素上绑定了一个 shadow DOM，那么就没有一个 light DOM 可以渲染的出口。我们可以通过将内容放到 shadow DOM 中来解决这个问题：

```
class OneDialog extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
    this.close = this.close.bind(this);
  }
  
  connectedCallback() {
    const { shadowRoot } = this;
    const template = document.getElementById('one-dialog');
    const node = document.importNode(template.content, true);
    shadowRoot.appendChild(node);
    
    shadowRoot.querySelector('button').addEventListener('click', this.close);
    shadowRoot.querySelector('.overlay').addEventListener('click', this.close);
    this.open = this.open;
  }

  disconnectedCallback() {
    this.shadowRoot.querySelector('button').removeEventListener('click', this.close);
    this.shadowRoot.querySelector('.overlay').removeEventListener('click', this.close);
  }
  
  set open(isOpen) {
    const { shadowRoot } = this;
    shadowRoot.querySelector('.wrapper').classList.toggle('open', isOpen);
    shadowRoot.querySelector('.wrapper').setAttribute('aria-hidden', !isOpen);
    if (isOpen) {
      this._wasFocused = document.activeElement;
      this.setAttribute('open', '');
      document.addEventListener('keydown', this._watchEscape);
      this.focus();
      shadowRoot.querySelector('button').focus();
    } else {
      this._wasFocused && this._wasFocused.focus && this._wasFocused.focus();
      this.removeAttribute('open');
      document.removeEventListener('keydown', this._watchEscape);
    }
  }
  
  close() {
    this.open = false;
  }
  
  _watchEscape(event) {
    if (event.key === 'Escape') {
        this.close();   
    }
  }
}

customElements.define('one-dialog', OneDialog);
```

到目前为止，我们对话框的主要变化实际上相对较小，但它们带来了很大的影响。首先，我们所有的选择器（包括我们的样式定义）都在内部作用域内。例如，我们的对话框模板内部只有一个按钮，因此我们的 CSS 只针对 `button {...}`，而且这些样式不会影响到 light DOM。

但是，我们仍然依赖于元素外部的模板。让我们通过从模板中删除这些标记并将它们放入 shadow root 的 `innerHTML` 中来改变它。

在 [CodePen](https://codepen.io) 中查看[对话框示例：仅使用 shadow root](https://codepen.io/calebdwilliams/pen/GzPqvo/)。

### 渲染来自 light DOM 的内容

[shadow DOM 规范](https://www.w3.org/TR/shadow-dom/)包括了一种允许在我们的自定义元素内，渲染 shadow root 外部的内容的方法。它和 AngularJS 中的 `ng-transclude` 概念以及在 React 中使用 `props.children` 都很相似。在 Web Components 中，我们可以通过使用 `<slot>` 元素实现。

这里有一个简单的例子：

```
<div>
  <span>world <!-- this would be inserted into the slot element below --></span>
  <#shadow-root><!-- pseudo code -->
    <p>Hello <slot></slot></p>
  </#shadow-root>
</div>
```

一个给定的 shadow root 可以拥有任意数量的 slot 元素，可以用 `name` 属性来区分。Shadow root 中没有名称的第一个 slot 将是默认 slot，未分配的所有内容将在该节点内按文档流（从左到右，从上到下）显示。我们的对话框确实需要两个 slot：标题和一些内容（我们将设置为默认 slot）。

在 [CodePen](https://codepen.io) 中查看[对话框示例：使用 shadow root 以及 slot](https://codepen.io/calebdwilliams/pen/dawXJb/)。

继续更改对话框的 HTML 部分并查看结果。Light DOM 内部的任何内容都被放入到分配给它的 slot 中。被插入的内容依旧保留在 light DOM 中，尽管它被渲染的好像在 shadow DOM 中一样。这意味着这些元素的内容和样式都可以由使用者定义。

Shadow root 的使用者通过 CSS `::slotted()` 伪选择器，可以有限度地定义 light DOM 中内容的样式；然而，slot 中的 DOM 树是折叠的，所以只有简单的选择器可以工作。换句话说，在前面示例的扁平的 DOM 树中，我们无法设置在 `<p>` 元素内部的 `<strong>` 元素的样式。

### 两全其美的方法

我们的对话框目前状态良好：它具有封装、语义标记、样式和行为；然而，一些使用者仍然想要定义他们自己的模板。幸运的是，通过结合两种我们所学的技术，我们可以允许使用者有选择地定义外部模板。

为此，我们将允许组件的每个实例引用一个可选的模板 ID。首先，我们需要为组件的 `template` 定义一个 getter 和 setter。

```
get template() {
  return this.getAttribute('template');
}

set template(template) {
  if (template) {
    this.setAttribute('template', template);
  } else {
    this.removeAttribute('template');
  }
  this.render();
}
```

在这里，通过将它直接绑定到相应的属性上，我们完成了和使用 `open` 属性时非常类似的事情。但是在底部，我们为我们的组件引入了一个新的方法：`render`。现在我们可以使用 `render` 方法插入 shadow DOM 的内容，并从 `connectedCallback` 中移除行为；相反，我们将在连接元素时调用 `render` 方法：

```
connectedCallback() {
  this.render();
}

render() {
  const { shadowRoot, template } = this;
  const templateNode = document.getElementById(template);
  shadowRoot.innerHTML = '';
  if (templateNode) {
    const content = document.importNode(templateNode.content, true);
    shadowRoot.appendChild(content);
  } else {
    shadowRoot.innerHTML = `<!-- template text -->`;
  }
  shadowRoot.querySelector('button').addEventListener('click', this.close);
  shadowRoot.querySelector('.overlay').addEventListener('click', this.close);
  this.open = this.open;
}
```

现在我们的对话框不仅拥有了一些非常基本的样式，而且可以允许使用者为每个实例定义一个新模板。我们甚至可以基于它当前指向的模板使用 `attributeChangedCallback` 更新此组件：

```
static get observedAttributes() { return ['open', 'template']; }

attributeChangedCallback(attrName, oldValue, newValue) {
  if (newValue !== oldValue) {
    switch (attrName) {
      /** Boolean attributes */
      case 'open':
        this[attrName] = this.hasAttribute(attrName);
        break;
      /** Value attributes */
      case 'template':
        this[attrName] = newValue;
        break;
    }
  }
}
```

在 [CodePen](https://codepen.io) 中查看[对话框示例：使用 shadow root、插槽以及模板](https://codepen.io/calebdwilliams/pen/rROadR/)。

在上面的示例中，改变 `<one-dialog>` 元素的 `template` 属性将改变元素渲染时使用的设计。

### Shadow DOM 样式策略

目前，定义一个 shadow DOM 节点样式的唯一方法就是在 shadow root 的内部 HTML 中添加一个 `<style>` 元素。这种方法几乎在所有情况下都能正常工作，因为浏览器会在可能的情况下对这些组件中的样式表进行重写。这个**确实**会增加一些内存开销，但通常不足以引起关注。

在这些样式标签内部，我们可以使用 [CSS 自定义属性](https://css-tricks.com/guides/css-custom-properties/)为定义组件样式提供 API。自定义属性可以穿透 shadow 的边界并影响 shadow 节点内的内容。

你可能会问：“我们可以在 shadow root 内部使用 `<link>` 元素吗”？事实上，我们确实可以。但是当尝试在多个应用之间重用这个组件时可能会出现问题，因为在所有应用中 CSS 文件可能无法保存在同一个位置。但是，如果我们确定了元素样式表的位置，那么我们就可以使用 `<link>` 元素。在样式标签中包含 `@import` 规则也是如此。

值得一提的是，不是所有的组件都需要像这样定义样式。使用 CSS 的 `:host` 和 `:host-context` 选择器，我们可以简单地定义更多初级的组件为块级元素，并且允许用户以提供类名的方式定义样式，如背景色，字体设置等。

另一方面，不同于只可以作为原生元素组合来展示的列表框（由标签和复选框组成），我们的对话框相当复杂。这与样式策略一样有效，因为样式更明确（比如设计系统的目的，其中所有复选框可能看起来都是一样的）。这在很大程度上取决于你的使用场景。

#### CSS 自定义属性

使用 [CSS 自定义属性](https://css-tricks.com/guides/css-custom-properties/)（也被称为 CSS 变量）的一个好处是它们可以传入 shadow DOM 内。在设计上，为组件使用者提供了一个接口，允许他们从外部定义组件的主题和样式。然而，值得注意的是，因为 CSS 级联的缘故，在 shadow root 内部对于自定义样式的更改不会回流。

在 [CodePen](https://codepen.io) 中查看[CSS 自定义样式以及 shadow DOM](https://codepen.io/calebdwilliams/pen/eXJZza/)。

继续注释或删除上面示例中的 CSS 面板里设置的变量，看看它是如何影响渲染内容的。你可以看一下 shadow DOM 的 `innerHTML` 中的样式，不管 shadow DOM 如何定义它自己的属性，都不会影响到 light DOM。

#### 可构造的样式表

在撰写本文的时候，有一项提议的 web 功能，它允许使用[可构造的样式表](https://github.com/WICG/construct-stylesheets/blob/gh-pages/explainer.md)对 shadow DOM 和 light DOM 的样式进行更多地模块化定义。这个功能已经登陆 Chrome 73，并且从 Mozilla 得到了很多积极的消息。

此功能允许使用者在其 JavaScript 文件中定义样式表，类似于编写普通 CSS 并在多个节点之间共享这些样式的方式。因此，单个样式表可以添加到多个 shadow root 内，也可以添加到文档内。

```
const everythingTomato = new CSSStyleSheet();
everythingTomato.replace('* { color: tomato; }');

document.adoptedStyleSheets = [everythingTomato];

class SomeCompoent extends HTMLElement {
  constructor() {
    super();
    this.adoptedStyleSheets = [everythingTomato];
  }
  
  connectedCallback() {
    this.shadowRoot.innerHTML = `<h1>CSS colors are fun</h1>`;
  }
}
```

在上面的示例中，`everythingTomato` 样式表可以同时应用到 shadow root 以及文档的 body 内。对于那些想要创建可以被多个应用和框架共享的设计系统和组件的团队来说非常有用。

在下一个示例中，我们可以看到一个非常基础的例子，展示了可构造样式表的使用方法以及它提供的强大功能。

在 [CodePen](https://codepen.io) 中查看[可构造的样式表示例](https://codepen.io/calebdwilliams/pen/aPgbMb/)。

在这个示例中，我们构造了两个样式表，并将它们添加到文档和自定义元素上。三秒钟后，我们从 shadow root 中删除一个样式表。但是，对于这三秒钟，文档和 shadow DOM 共享相同的样式表。使用该示例中包含的 polyfill，实际上存在两个样式元素，但 Chrome 运行的很自然。

该示例还包括一个表单，用于显示如何根据需要异步有效地更改工作表的规则。对于那些想要为他们的网站提供主题的使用者，或者那些想要创建跨越多个框架或网址的设计系统的使用者来说，Web 平台的这一新增功能可以成为一个强大的盟友。

这里还有一个关于 [CSS 模块](https://github.com/w3c/webcomponents/issues/759)的提议，最终可以和 `adoptStyleSheets` 功能一起使用。如果以当前形式实现，该提议将允许把 CSS 作为模块导入，就像 ECMAScript 模块一样：

```
import styles './styles.css';

class SomeCompoent extends HTMLElement {
  constructor() {
    super();
    this.adoptedStyleSheets = [styles];
  }
}
```

#### 部分和主题

用于样式化 Web 组件的另一个特性是 `::part()` 和 `::theme()` 伪选择器。`::part()` 规范允许使用者可以定义他们的部分自定义元素，提供了下面的样式定义接口：

```
class SomeOtherComponent extends HTMLElement {
  connectedCallback() {
    this.attachShadow({ mode: 'open' });
    this.shadowRoot.innerHTML = `
      <style>h1 { color: rebeccapurple; }</style>
      <h1>Web components are <span part="description">AWESOME</span></h1>
    `;
  }
}
    
customElements.define('other-component', SomeOtherComponent);
```

在我们的全局 CSS 中，我们可以通过调用 CSS 的 `::part()` 选择器来定位任何 part 属性值为 `description` 的元素。

```
other-component::part(description) {
  color: tomato;
}
```

在上面的示例中，`<h1>` 标签的主要消息与描述部分的颜色不同，对于那些自定义元素的使用者，让他们可以暴露自己组件的样式 API，并保持对他们想要保持控制的部分的控制。

`::part()` 和 `::theme()` 的区别在于 `::part()` 必须作用于特定的选择器上，`::theme()` 可以嵌套在任何层级上。下面的示例和上面 CSS 代码有着相同的效果，但也适用于在整个文档树中包含 `part="description"` 的任何其他元素。

```
:root::theme(description) {
  color: tomato;
}
```

和可构造的样式表一样，`::part()` 已经可以在 Chrome 73 中使用。

### 总结

我们的对话框组件现在已经完成。它具有自己的标记，样式（没有任何外部依赖）和行为。此组件现在可以被包含在使用任何当前或未来框架的项目中，因为它们是根据浏览器规范而不是第三方 API 构建的。

一些核心控件**有点**冗长，并且或多或少依赖于对 DOM 工作原理一些知识。在我们的最后一篇文章中，我们将讨论更高级别的工具以及如何与流行的框架结合使用。

#### 系列文章：

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [编写可以复用的 HTML 模板](https://juejin.im/post/5ca5b858e51d4524a918560f)
3.  [从 0 开始创建自定义元素](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构（**本文**）](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web Components 的高级工具](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
