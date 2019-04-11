> * 原文地址：[Advanced Tooling for Web Components](https://css-tricks.com/advanced-tooling-for-web-components/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[Long Xiong](https://github.com/xionglong58), [Ziyin Feng](https://github.com/Fengziyin1234)

# Web Components 的高级工具

该系列由 5 篇文章构成，我们在前 4 篇文章中对构成 Web Components 标准的技术进行了[全面的介绍](https://juejin.im/post/5c9a3cce5188252d9b3771ad)。首先，我们研究了[如何创建 HTML 模板](https://juejin.im/post/5ca5b858e51d4524a918560f)，为接下来的工作做了铺垫。其次，我们深入了解了[自定义元素的创建](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)。接着，[我们将元素的样式和选择器封装到 shadow DOM 中](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)，这样我们的元素就完全独立了。

我们通过创建自己的自定义模态对话框来探索这些工具的强大功能，该对话框可以忽略底层框架或库，在大多数现代应用程序上下文中使用。在本文中，我们将介绍如何在各种框架中使用我们的元素，并介绍一些高级工具用来真正提高 Web Component 的技能。

#### 系列文章：

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [编写可以复用的 HTML 模板](https://juejin.im/post/5ca5b858e51d4524a918560f)
3.  [从 0 开始创建自定义元素](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web Components 的高级工具（**本文**）](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components.md)

### 框架兼容

我们的对话框组件几乎在任何框架中都可以很好地运行。（当然，如果 JavaScript 被禁用，那么整个事情都是徒劳的。）Angular 和 Vue 将 Web Components 视为一等公民：框架的设计考虑了 Web 标准。React 稍微有点自以为是，但并非不可以整合。

#### Angular

首先，我们来看看 Angular 如何处理自定义元素。默认情况下，每当 Angular 遇到无法识别的元素（即默认浏览器元素或任何 Angular 定义的组件），它就会抛出模板错误。可以通过包含 `CUSTOM_ELEMENTS_SCHEMA` 来更改这个行为。

> ...允许 NgModule 包含以下内容：
> 
> *   Non-Angular 元素用破折号（`-`）命名。
> *   元素属性用破折号（`-`）命名。破折号是自定义元素的命名约定。
> 
> — [Angular 文档](https://angular.io/api/core/CUSTOM_ELEMENTS_SCHEMA)

使用此架构就像在模块中添加它一样简单：

```
import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';

@NgModule({
  /** 省略 */
  schemas: [ CUSTOM_ELEMENTS_SCHEMA ]
})
export class MyModuleAllowsCustomElements {}
```

就像上面这样。之后，Angular 将允许我们在任何使用标准属性和绑定事件的地方使用我们的自定义元素：

```
<one-dialog [open]="isDialogOpen" (dialog-closed)="dialogClosed($event)">
  <span slot="heading">Heading text</span>
  <div>
    <p>Body copy</p>
  </div>
</one-dialog>
```

#### Vue

Vue 对 Web Components 的兼容性甚至比 Angular 更好，因为它不需要任何特殊配置。注册元素后，它可以与 Vue 的默认模板语法一起使用：

```
<one-dialog v-bind:open="isDialogOpen" v-on:dialog-closed="dialogClosed">
  <span slot="heading">Heading text</span>
  <div>
    <p>Body copy</p>
  </div>
</one-dialog>
```

然而，Angular 和 Vue 都需要注意的是它们的默认表单控件。如果我们希望使用一个类似于可响应的表单或者 Angular 的 `[(ng-model)]` 或者 Vue 中的 `v-model` 的东西，我们需要建立管道，这个超出了本篇文章的讨论范围。

#### React

React 比 Angular 稍微复杂一点。[React 的虚拟 DOM](https://reactjs.org/docs/faq-internals.html) 有效地获取了一个 JSX 树并将其渲染为一个大对象。因此，React 不是像 Angular 或 Vue 一样，直接修改 HTML 元素上的属性，而是使用对象语法来跟踪需要对 DOM 进行的更改并批量更新它们。在大多数情况下这很好用。我们将对话框的 open 属性绑定到对象的属性上，在改变属性时响应非常好。

当我们关闭对话框，开始调度 `CustomEvent` 时，会出现问题。React 使用[合成事件系统](https://reactjs.org/docs/events.html)为我们实现了一系列原生事件监听器。不幸的是，这意味着像 `onDialogClosed` 这样的控制方法实际上不会将事件监听器附加到我们的组件上，因此我们必须找到其他方法。

在 React 中添加自定义事件监听器的最著名的方法是使用 [DOM refs](https://reactjs.org/docs/refs-and-the-dom.html)。在这个模型中，我们可以直接引用我们的 HTML 节点。语法有点冗长，但效果很好：

```
import React, { Component, createRef } from 'react';

export default class MyComponent extends Component {
  constructor(props) {
    super(props);
    // 创建引用
    this.dialog = createRef();
    // 在实例上绑定我们的方法
    this.onDialogClosed = this.onDialogClosed.bind(this);

    this.state = {
      open: false
    };
  }

  componentDidMount() {
    // 组件构建完成后，添加事件监听器
    this.dialog.current.addEventListener('dialog-closed', this.onDialogClosed);
  }

  componentWillUnmount() {
    // 卸载组件时，删除监听器
    this.dialog.current.removeEventListener('dialog-closed', this.onDialogClosed);
  }

  onDialogClosed(event) { /** 省略 **/ }

  render() {
    return <div>
      <one-dialog open={this.state.open} ref={this.dialog}>
        <span slot="heading">Heading text</span>
        <div>
          <p>Body copy</p>
        </div>
      </one-dialog>
    </div>
  }
}
```

或者，我们可以使用无状态函数组件和钩子：

```
import React, { useState, useEffect, useRef } from 'react';

export default function MyComponent(props) {
  const [ dialogOpen, setDialogOpen ] = useState(false);
  const oneDialog = useRef(null);
  const onDialogClosed = event => console.log(event);

  useEffect(() => {
    oneDialog.current.addEventListener('dialog-closed', onDialogClosed);
    return () => oneDialog.current.removeEventListener('dialog-closed', onDialogClosed)
  });

  return <div>
      <button onClick={() => setDialogOpen(true)}>Open dialog</button>
      <one-dialog ref={oneDialog} open={dialogOpen}>
        <span slot="heading">Heading text</span>
        <div>
          <p>Body copy</p>
        </div>
      </one-dialog>
    </div>
}
```

这个还不错，但你可以看到重用这个组件很快会变得很麻烦。幸运的是，我们可以导出一个默认的 React 组件，它使用相同的工具包裹我们的自定义元素。

```
import React, { Component, createRef } from 'react';
import PropTypes from 'prop-types';

export default class OneDialog extends Component {
  constructor(props) {
    super(props);
    // 创建引用
    this.dialog = createRef();
    // 在实例上绑定我们的方法
    this.onDialogClosed = this.onDialogClosed.bind(this);
  }

  componentDidMount() {
    // 组件构建完成后，添加事件监听器
    this.dialog.current.addEventListener('dialog-closed', this.onDialogClosed);
  }

  componentWillUnmount() {
    // 卸载组件时，删除监听器
    this.dialog.current.removeEventListener('dialog-closed', this.onDialogClosed);
  }

  onDialogClosed(event) {
    // 在调用属性之前进行检查以确保它是存在的
    if (this.props.onDialogClosed) {
      this.props.onDialogClosed(event);
    }
  }

  render() {
    const { children, onDialogClosed, ...props } = this.props;
    return <one-dialog {...props} ref={this.dialog}>
      {children}
    </one-dialog>
  }
}

OneDialog.propTypes = {
  children: children: PropTypes.oneOfType([
      PropTypes.arrayOf(PropTypes.node),
      PropTypes.node
  ]).isRequired,
  onDialogClosed: PropTypes.func
};
```

...或者，再次使用无状态函数组件和钩子：

```
import React, { useRef, useEffect } from 'react';
import PropTypes from 'prop-types';

export default function OneDialog(props) {
  const { children, onDialogClosed, ...restProps } = props;
  const oneDialog = useRef(null);
  
  useEffect(() => {
    onDialogClosed ? oneDialog.current.addEventListener('dialog-closed', onDialogClosed) : null;
    return () => {
      onDialogClosed ? oneDialog.current.removeEventListener('dialog-closed', onDialogClosed) : null;  
    };
  });

  return <one-dialog ref={oneDialog} {...restProps}>{children}</one-dialog>
}
```

现在我们可以在 React 中使用我们的对话框，而且可以在我们所有的应用程序中保持相同的 API（如果你喜欢的话，还可以不使用类）。

```
import React, { useState } from 'react';
import OneDialog from './OneDialog';

export default function MyComponent(props) {
  const [open, setOpen] = useState(false);
  return <div>
    <button onClick={() => setOpen(true)}>Open dialog</button>
    <OneDialog open={open} onDialogClosed={() => setOpen(false)}>
      <span slot="heading">Heading text</span>
      <div>
        <p>Body copy</p>
      </div>
    </OneDialog>
  </div>
}
```

### 高级工具

有很多非常棒的工具可以用来编写你的自定义元素。[在 npm 上进行搜索](https://www.npmjs.com/search?q=keywords:customElements)，你能找到许多用于创建高响应性自定义元素的工具（包括我自己的宠物项目），但到目前为止最流行的是来自 Polymer 团队的 [lit-html](https://github.com/Polymer/lit-html)，对 Web Components 来说更具体的是指，[LitElement](https://lit-element.polymer-project.org/)。

LitElement 是一个自定义元素基类，它提供了一系列 API，可以用于完成我们迄今为止所做的所有事情。不用构建它也可以在浏览器中运行，但如果你喜欢使用更前沿的工具，如装饰器，那么也可以使用它。

在深入了解如何使用 lit 或 LitElement 之前，请花一点时间熟悉 [带标签的模板字符串（tagged template literals）](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)，这是一种特殊的函数，可以在 JavaScript 中调用模板字符串。这些函数接受一个字符串数组和一组内插值，并可以返回你可能想要的任何内容。

```
function tag(strings, ...values) {
  console.log({ strings, values });
  return true;
}
const who = 'world';

tag`hello ${who}`; 
/** 会打印出 { strings: ['hello ', ''], values: ['world'] }，并且返回 true **/
```

LitElement 为我们提供的是对传递给该值数组的任何内容的实时动态更新，因此当属性更新时，将调用元素的 render 函数并重新渲染呈现 DOM。

```
import { LitElement, html } from 'lit-element';

class SomeComponent {
  static get properties() {
    return { 
      now: { type: String }
    };
  }

  connectedCallback() {
    // 一定要调用 super
    super.connectedCallback();
    this.interval = window.setInterval(() => {
      this.now = Date.now();
    });
  }

  disconnectedCallback() {
    super.disconnectedCallback();
    window.clearInterval(this.interval);
  }

  render() {
    return html`<h1>It is ${this.now}</h1>`;
  }
}

customElements.define('some-component', SomeComponent);
```

在 [CodePen](https://codepen.io) 查看 [LitElement 示例](https://codepen.io/calebdwilliams/pen/omrXJx/)。

你会注意到我们必须使用 `static properties` getter 定义任何我们想要 LitElement 监视的属性。使用该 API 会告诉基类每当对组件的属性进行更改时都要调用 `render` 函数。反过来，`render` 将仅更新需要更改的节点。

因此，对于我们的对话框示例，它使用 LitElement 时看起来像这样：

在 [CodePen](https://codepen.io) 查看 [使用 LitElement 的对话框示例](https://codepen.io/calebdwilliams/pen/OdeJdq/)。

有几种可用的 lit-html 的变体，包括 [Haunted](https://github.com/matthewp/haunted)，一个用于 Web Components 的 React 钩子库，也可以使用 lit-html 作为基础来使用虚拟组件。

目前，大多数现代 Web Components 工具都是 `LitElement` 的风格：一个从我们的组件中抽象出通用逻辑的基类。其他类型的有 [Stencil](https://stenciljs.com/)、[SkateJS](https://github.com/skatejs/skatejs)、[Angular Elements](https://angular.io/guide/elements) 和 [Polymer](https://www.polymer-project.org/)。

### 下一步

Web Components 标准不断发展，越来越多的新功能经过讨论并被添加到浏览器中。很快，Web Components 的使用者将拥有用于与 Web 表单进行高级交互的 API（包括超出这些介绍性文章范围的其他元素内部），例如原生 HTML 和 CSS 模块导入，原生模板实例化和更新控件，更多的可以在 GitHub 上的 [W3C/web components issues board on GitHub](https://github.com/w3c/webcomponents/issues) 进行跟踪。

这些标准已经准备好应用到我们今天的项目中，并为旧版浏览器和 Edge 提供适当的 polyfill。虽然它们可能无法取代你选择的框架，但它们可以一起使用，以增强你和你的团队的工作流程。

#### 系列文章：

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [编写可以复用的 HTML 模板](https://juejin.im/post/5ca5b858e51d4524a918560f)
3.  [从 0 开始创建自定义元素](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web Components 的高级工具（**本文**）](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
