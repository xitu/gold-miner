> * 原文地址：[Creating a Custom Element from Scratch](https://css-tricks.com/creating-a-custom-element-from-scratch/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
> * 译者：[ANFOUNNYSOUL](https://github.com/yzw7489757)
> * 校对者：[portandbridge](https://github.com/portandbridge), [wznonstop](https://github.com/wznonstop)

# 从 0 创建自定义元素

在[上一篇文章](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)，我们在文档中创建了 HTML 模板，希望它们在需要时才呈现，这让我们开始接触 Web 组件。

接下来，我们将继续创建对话框组件的自定义元素版本，该自定义元素版本目前仅使用 `HTMLTemplateElement`。

请在 [CodePen](https://codepen.io) 上查看由 Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) 创建的[带有脚本的模板对话框](https://codepen.io/calebdwilliams/pen/JzjLyQ/) Demo。

因此，下一步我们将创建一个自定义元素，该元素实时使用我们的 `template#dialog-template` 元素。

#### 系列文章：

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [编写可复用的 HTML 模板](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [从 0 开始创建自定义元素（**本文**）](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web 组件的高阶工具](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

* * *

### 添加一个自定义元素

Web 组件的基础元素是**自定义元素**。该 `customElements` 的 API 为我们提供了创建自定义 HTML 标签的途径，这些标签可以在包含定义类的任何文档中使用。

可以把它想象成 React 或 Angular 组件（例如 `<MyCard />`），但实际上它不依赖于 React 或 Angular。原生自定义组件是这样的：`<my-card></my-card>`。更重要的是，将它视为一个标准元素，可以在你的 React、Angular、Vue、[insert-framework-you’re-interested-in-this-week] 应用中使用，而不必大惊小怪。

从本质上讲，一个自定义元素分为两个部分组成：一个**标签名称**和一个 **Class** 类扩展内置 `HTMLElement` 类。我们自定义元素的简易 demo 版本如下所示：

```
class OneDialog extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `<h1>Hello, World!</h1>`;
  }
}

customElements.define('one-dialog', OneDialog);
```

注意：在整个自定义元素中，this 值是对自身自定义元素实例的引用。

在上面的示例中，我们定义了一个符合标准的新 HTML 元素，`<one-dialog></one-dialog>`。它现在暂时还做不了什么...，在任何 HTML 文档中使用 `<one-dialog>` 标签将会创建一个带着 `<h1>` 标签显示 “Hello, World!” 的新元素。

我们肯定想把它做的更 NB，很幸运。在[上一篇文章中](https://css-tricks.com/crafting-reusable-html-templates)，我们为弹出框创建模板，并且能够拿到模板，让我们在自定义元素中使用它。我们在该示例中添加了一个 script 标签来执行一些对话框魔术。我们暂时删除它，因为我们将把逻辑从 HTML 模板移到自定义元素类中。

```
class OneDialog extends HTMLElement {
  connectedCallback() {
    const template = document.getElementById('one-dialog');
    const node = document.importNode(template.content, true);
    this.appendChild(node);
  }
}
```

现在，定义了自定义元素（`<one-dialog>`）并指示浏览器呈现包含在调用自定义元素的 HTML 模板中的内容。

下一步是将我们的逻辑转移到组件类中。

### 自定义元素生命周期方法
 
与 React 或 Angular 一样，自定义元素具有**生命周期方法**。笔者已经向各位介绍过 `connectedCallback`，当我们的元素被添加到 DOM 的时候调用它。

`connectedCallback` 与元素的 `constructor` 是分开的。函数用于设置元素的基本骨架，而 `connectedCallback` 通常用于向元素添加内容、设置事件监听器或以其他方式初始化组件。

实际上，构造函数不能用于设计或修改或操作元素的属性，如果我们要使用对话框创建新实例，`document.createElement` 则会调用构造函数。元素的使用者需要一个没有插入属性或内容的简单节点。

该 createElement 函数没有可以用于配置将返回的元素的选项。这是符合情理的，那么话说回来了，既然这个函数没有选项可以配置会返回的元素，那我们唯一的选择就是 `connectedCallback`。

在标准内置元素中，元素的状态通常通过元素上存在的属性和这些属性的值来反映。对于我们的示例，我们将仅查看一个属性：`[open]`。为此，我们需要观察该属性的更改，我们需要 `attributeChangedCallback` 来做到这一点。只要其中一个元素构造函数 `observedAttributes` 之一的属性发生变化就会触发第二个生命周期方法。

这可能听起来难以实现，但语法非常简单：

```
class OneDialog extends HTMLElement {
  static get observedAttributes() {
    return ['open'];
  }
  
  attributeChangedCallback(attrName, oldValue, newValue) {
    if (newValue !== oldValue) {
      this[attrName] = this.hasAttribute(attrName);
    }
  }
  
  connectedCallback() {
    const template = document.getElementById('one-dialog');
    const node = document.importNode(template.content, true);
    this.appendChild(node);
  }
}
```

在上面的例子中，我们只关心属性是否设置，我们不关心具体的值（这类似于 HTML5 input 输入框上的 `required` 属性）。更新此属性时，我们更新元素的 `open` 属性。属性（property）存在于 JavaScript 对象上，HTML Elements 也具有属性（attribute）；这个生命周期方法可以帮助我们让两种属性保持同步。

我们将 updater 包含在 `attributeChangedCallback` 内部的条件检查中，以查看新值和旧值是否相等。我们这样做是为了防止程序中出现无限循环，因为稍后我们将创建一个 getter 和 setter 属性，它将通过在元素的属性（property）更新时设置元素的属性（attribute）来保持属性（attribute）和属性（property）的同步。`attributeChangedCallback` 反向执行：当属性更改时更新属性。

现在，开发者可以使用我们的组件，并且利用 `open` 属性决定对话框是否默认打开。为了使它更具动态性，我们可以在元素的 `open` 属性中添加自定义 getter 和 setter：

```
class OneDialog extends HTMLElement {
  static get boundAttributes() {
    return ['open'];
  }
  
  attributeChangedCallback(attrName, oldValue, newValue) {
    this[attrName] = this.hasAttribute(attrName);
  }
  
  connectedCallback() {
    const template = document.getElementById('one-dialog');
    const node = document.importNode(template.content, true);
    this.appendChild(node);
  }
  
  get open() {
    return this.hasAttribute('open');
  }
  
  set open(isOpen) {
    if (isOpen) {
      this.setAttribute('open', true);
    } else {
      this.removeAttribute('open');
    }
  }
}
```

getter 和 setter 将保证（HTML 元素节点上）的 `open` 特性和属性（在 DOM 对象上）的值同步。添加 `open` 特性会将 `element.open` 设置为 `true`，同理，将 `element.open` 设置为 `true` 会添加 `open` 属性。我们这样做是为了确保元素的状态由其属性反映出来。虽然在技术层面上不一定需要，但被认为是创建自定义元素的最优办法。

虽然这难免引入一些样板文件，但是通过循环观察到的属性列表并使用 `Object.defineProperty` 创建一个保持这些属性同步的抽象类是一项相当简单的任务。

```
class AbstractClass extends HTMLElement {
  constructor() {
    super();
    // 检查观察到的属性是否已定义并具有长度
    if (this.constructor.observedAttributes && this.constructor.observedAttributes.length) {
      // 通过观察到的属性进行循环
      this.constructor.observedAttributes.forEach(attribute => {
        // 动态定义 getter/setter 原型
        Object.defineProperty(this, attribute, {
          get() { return this.getAttribute(attribute); },
          set(attrValue) {
            if (attrValue) {
              this.setAttribute(attribute, attrValue);
            } else {
              this.removeAttribute(attribute);
            }
          }
        }
      });
    }
  }
}

// 我们可以扩展抽象类，而不是直接扩展 HTMLElement
class SomeElement extends AbstractClass { /** 省略 **/ }

customElements.define('some-element', SomeElement);
```

上面的例子并不完美，它没有考虑实现像 `open` 这样的属性的可能性，这些属性没有被赋值，而仅仅依赖于属性的存在。做一个完美的版本将超出本文的范围。

现在我们已经知道我们的对话框是否打开了，让我们添加一些逻辑来实际地进行显示和隐藏：

```
class OneDialog extends HTMLElement {  
  /** 省略 */
  constructor() {
    super();
    this.close = this.close.bind(this);
  }
  
  set open(isOpen) {
    this.querySelector('.wrapper').classList.toggle('open', isOpen);
    this.querySelector('.wrapper').setAttribute('aria-hidden', !isOpen);
    if (isOpen) {
      this._wasFocused = document.activeElement;
      this.setAttribute('open', '');
      document.addEventListener('keydown', this._watchEscape);
      this.focus();
      this.querySelector('button').focus();
    } else {
      this._wasFocused && this._wasFocused.focus && this._wasFocused.focus();
      this.removeAttribute('open');
      document.removeEventListener('keydown', this._watchEscape);
      this.close();
    }
  }
  
  close() {
    if (this.open !== false) {
      this.open = false;
    }
    const closeEvent = new CustomEvent('dialog-closed');
    this.dispatchEvent(closeEvent);
  }
  
  _watchEscape(event) {
    if (event.key === 'Escape') {
        this.close();   
    }
  }
}
```

这里发生了很多事情，让我们来梳理一下。我们要做的第一件事就是获取我们的容器，在 `isOpen` 的基础上切换 `.open` 类。为了使我们的元素可以访问，我们还需要切换 `aria-hidden` 属性。

如果对话框已经打开了，那么我们希望保存对先前聚焦元素的引用。这是为了考虑可访问性标准。我们还将一个 keydown 监听器添加到名为 `WatEscape` 的文档中，该文档在构造函数中绑定元素的 `this`，其模式类似于 React 处理类组件中的方法调用的方式。

我们这样做不仅是为了确保正确绑定 `this.close`，还因为 `Function.prototype.bind` 返回带绑定调用栈的函数的实例。通过在构造函数中保存对新绑定方法的引用，我们可以在对话框断开时删除事件（稍后将详细介绍）。最后，我们将注意力集中在元素上，并将焦点设置在 shadow root 中的适当元素上。

我们还创建了一个很好的小实用工具方法来关闭我们的对话框，它分派一个自定义事件来通知某个监听器对话框已经关闭。

如果元素是关闭的（即 `!open`），我们检查以确保 `this._wasFocused` 属性已定义并具有 `focus` 方法并调用该方法以将用户的焦点返回到常规 DOM。然后我们删除我们的事件监听器以避免任何内存泄漏。

说到为自己的代码做好清理善后，就自然也要说下我们采用了另一种生命周期方法：`disconnectedCallback`。`disconnectedCallback` 与 `connectedCallback` 相反，因为一旦从 DOM 中删除了元素，该方法就会被调用，它允许我们清理附加到元素的任何事件监听器或 `MutationObservers`。

碰巧的是，我们还有几个事件侦听器要连接起来：

```
class OneDialog extends HTMLElement {
  /** Omitted */
  
  connectedCallback() {    
    this.querySelector('button').addEventListener('click', this.close);
    this.querySelector('.overlay').addEventListener('click', this.close);
  }
  
  disconnectedCallback() {
    this.querySelector('button').removeEventListener('click', this.close);
    this.querySelector('.overlay').removeEventListener('click', this.close);
  }  
}
```

现在我们有一个运行良好，大部分可访问的对话框元素。我们可以做一些修饰，比如将焦点集中在元素上，但这超出了我们在本文学习的范围。

还有一个生命周期方法 `adoptedCallback`。它不适用于我们的元素，其作用是元素被采用（插入）到 DOM 的另一部分时触发。

在下面的示例中，您将看到我们的模板元素正被一个标准元素 `<one-dialog>` 所使用。

请在 [CodePen](https://codepen.io) 上查看由 Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) 创建的[对话框组件使用模板](https://codepen.io/calebdwilliams/pen/vbVXqv/) Demo。

### 另一个概念：非演示组件

到目前为止，我们创建的 `<one-template>` 是一个典型的自定义元素，它包含了当元素包含在文档中时被插入到文档中的标记和行为。然而，并不是所有的元素都需要直观地呈现。在 React 生态系统中，组件通常用于管理应用程序状态或其他一些主要功能，像[react-redux](https://redux.js.org/basics/usage-with-react) 里的 `<Provider />`。

让我们想象一下，我们的组件是工作流中一系列对话框的一部分。当一个对话框关闭时，下一个对话框应该打开。我们可以创建一个容器组件来监听我们的 `dialog-closed` 事件并在整个工作流程中进行：

```
class DialogWorkflow extends HTMLElement {
  connectedCallback() {
    this._onDialogClosed = this._onDialogClosed.bind(this);
    this.addEventListener('dialog-closed', this._onDialogClosed);
  }

  get dialogs() {
    return Array.from(this.querySelectorAll('one-dialog'));
  }

  _onDialogClosed(event) {
    const dialogClosed = event.target;
    const nextIndex = this.dialogs.indexOf(dialogClosed);
    if (nextIndex !== -1) {
      this.dialogs[nextIndex].open = true;
    }
  }
}
```

这个元素没有任何表示逻辑，但它充当了应用程序状态的控制器。只需稍加努力，我们就可以重新创建类似 Redux 的状态管理系统，只使用一个自定义元素，可以在 React 的 Redux 容器组件所在的同一个应用程序中管理整个应用程序的状态。

### 这是对自定义元素的深入了解

现在我们对自定义元素有了很好的理解，我们的对话框开始融合在一起。但它仍然存在一些问题。

请注意，我们必须添加一些 CSS 来重新设置对话框按钮，因为元素的样式会干扰页面的其余部分。虽然我们可以利用命名策略（如 BEM）来确保我们的样式不会与其他组件产生冲突，但是有一种更友好的方式来隔离样式。那就是 shadow DOM。本文系列 Web Components 专题的下一篇文章就会谈到它。

**我们需要做的另一件事是为每个组件定义一个新模板，或者为我们的对话框找到一些切换模板的方法。就目前而言，每页只能有一个对话框类型，因为它使用的模板必须始终存在。因此，我们要么需要注入动态内容的方法，要么需要替换模板的方法。**

在下一篇文章中，我们将研究如何通过使用 shadow DOM 合并样式和内容封装来提高我们刚刚创建的 `<one-dialog>` 元素的可用性。

#### 系列文章：

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [编写可重复使用的 HTML 模板](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [从 0 开始创建自定义元素（**本文**）](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web 组件的高阶工具](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
