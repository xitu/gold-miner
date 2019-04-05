> * 原文地址：[Creating a Custom Element from Scratch](https://css-tricks.com/creating-a-custom-element-from-scratch/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
> * 译者：ANFOUNNYSOUL
> * 校对者：

# 从头创建自定义元素

在 [上一篇文章](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md), 我们通过创建文档中的HTML模板，但是我们想进行按需渲染，导致污染了Web组件。

接下来,  我们将继续创建一个下面自定义元素版本的弹窗组件，目前仅使用`HTMLTemplateElement` ：

See the Pen [Dialog with template with script](https://codepen.io/calebdwilliams/pen/JzjLyQ/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

因此，我们下一步创建一个自定义元素，该元素实时使用我们的`template#dialog-template`元素

#### 文章系列:

1.  [Web 组件简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [制作可复用的HTML模板](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [从头开始创建自定义元素 (_本文_)](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用 Shadow DOM 封装样式和结构](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web 组件的高级工具](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

* * *

### 添加一个自定义元素

 bread 和 butter 都是 Web Components 的 **自定义元素**. 该`customElements` API 为我们提供了定义自定义HTML标签的路径，这些标签可以在包含定义类的任何文档中使用

可以把它想象成React 或 Angular 组件 (例如 `<MyCard />`), 但没有React或Angular的依赖. 原生自定义组件是这样的: `<my-card></my-card>`. 更重要的是, 将它视为一个标准元素，可以在你的React，Angular，Vue, [insert-framework-you’re-interested-in-this-week] 应用中去使用，而不必大惊小怪。

从本质上讲, 一个自定义元素分为两个部分组成: 一个 **标签名称** 和一个 **Class** 类扩展内置  `HTMLElement` 类. 我们自定义元素的简易demo版本如下所示:

```
class OneDialog extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `<h1>Hello, World!</h1>`;
  }
}

customElements.define('one-dialog', OneDialog);
```

注意: 在整个自定义元素中, this值是对自身自定义元素实例的引用.

在上面的示例中, 我们定义了一个符合标准的新HTML元素, `<one-dialog></one-dialog>`. 它还做不了什么...暂时来说, 在任何 HTML文档中使用 `<one-dialog>` 标签将会创建一个带着 `<h1>` 标签显示“Hello, World!” 的新元素

我们肯定想把它做的更NB, 很幸运. 在 [上一篇文章中](https://css-tricks.com/crafting-reusable-html-templates), 我们为弹出框创建模板， 并且有权拿到模板 ，让我们在自定义元素中使用它。 我们在该示例中添加了一个script标签来执行一些对话框魔术。 我们暂时删除它，因为我们将把逻辑从HTML模板移到自定义元素类中。

```
class OneDialog extends HTMLElement {
  connectedCallback() {
    const template = document.getElementById('one-dialog');
    const node = document.importNode(template.content, true);
    this.appendChild(node);
  }
}
```

现在，定义了自定义元素 (`<one-dialog>`) 并指示浏览器呈现包含在调用自定义元素的HTML模板中的内容。

下一步是将我们的逻辑转移到组件类中。

### 自定义元素生命周期方法
 
与React或Angular一样，自定义元素具有 **生命周期方法**.  笔者已经向各位介绍过 `connectedCallback` , 当我们的元素被添加到DOM的时候调用它.

 `connectedCallback` 与元素的 `constructor` 是分开的.函数用于设置元素的基本骨架, 而 `connectedCallback` 通常用于向元素添加内容、设置事件监听器或以其他方式初始化组件。

实际上, 构造函数不能用于设计或修改或操作元素的属性如果我们要使用创建对话框的新实例， `document.createElement`则会调用构造函数. 元素的使用者需要一个没有插入属性或内容的简单节点

该 createElement 函数没有可以用于配置将返回的元素的选项. 这是符合情理的, 那么话说回来了, 既然这个函数没有选项可以配置会返回的元素，那我们唯一的选择就是 `connectedCallback` .

在标准内置元素中, 元素的状态通常通过元素上存在的属性和这些属性的值来反映。 对于我们的示例，我们将仅查看一个属性: `[open]`. 。为此，我们需要关注该属性的更改，我们需要`attributeChangedCallback` 要做到这一点. 只要其中一个元素构造函数调用第二个生命周期方法 `observedAttributes` 更新.

这可能听起来难以实现，但语法非常简单:··

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

在上面的例子中，我们只关心属性是否设置,我们不关心值(这类似于 HTML5 input输入框上的 `required` 属性 ). 更新此属性时, 我们更新元素的 `open` 属性.属性存在于JavaScript对象上，而属性存在于HTMLElement上, 这个生命周期方法可以帮助我们保持两者同步.

我们将updater包含在 `attributeChangedCallback` 内部的条件检查中，以查看新值和旧值是否相等. 我们这样做是为了防止程序中出现无限循环，因为稍后我们将创建一个getter和setter属性，它将通过在元素的属性更新时设置元素的属性来保持属性和属性的同步。 `attributeChangedCallback` 反向执行: 当属性更改时更新属性.

现在，作者可以使用我们的组件，并且利用`open`属性决定对话框是否默认打开。 为了使它更具动态性，我们可以在元素的`open`属性中添加自定义getter和setter：

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

getter和setter将保持`open`属性（在HTML元素上）和属性（在DOM对象上）的值同步。 添加`open`属性会将`element.open`设置为`true`并将`element.open`设置为`true`将添加`open`属性。 我们这样做是为了确保元素的状态由其属性反映出来。 这在技术上不是必需的，但被认为是创建自定义元素的最好办法。

这会不可避免地导致一些样板，但是通过循环观察到的属性列表并使用 `Object.defineProperty` 创建一个保持这些属性同步的抽象类是一项相当简单的任务 .

```
class AbstractClass extends HTMLElement {
  constructor() {
    super();
    // Check to see if observedAttributes are defined and has length
    if (this.constructor.observedAttributes && this.constructor.observedAttributes.length) {
      // Loop through the observed attributes
      this.constructor.observedAttributes.forEach(attribute => {
        // Dynamically define the property getter/setter
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

// Instead of extending HTMLElement directly, we can now extend our AbstractClass
class SomeElement extends AbstractClass { /** Omitted */ }

customElements.define('some-element', SomeElement);
```

上面的例子并不完美，它没有考虑像‘open’这样的属性的可能性，这些属性没有被分配给它们的值，而仅仅依赖于属性的存在。做一个完美的版本将超出本文的范围。

现在我们已经知道我们的对话框是否打开了，让我们添加一些逻辑来实际地进行显示和隐藏：

```
class OneDialog extends HTMLElement {  
  /** Omitted */
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

这里有很多事情，但让我们来看看。我们要做的第一件事就是获取我们的容器，在`isOpen`的基础上切换`.open`类。为了使我们的元素可访问，我们还需要切换`aria-hidden`属性

如果对话框已经打开了，那么我们希望保存对先前聚焦元素的引用。这是为了考虑可访问性标准。 我们还将一个keydown监听器添加到名为`WatEscape`的文档中，该文档在构造函数中绑定元素的“this”，其模式类似于React处理类组件中的方法调用的方式。

我们这样做不仅是为了确保正确绑定 `this.close`，还因为 `Function.prototype.bind` 返回带绑定调用栈的函数的实例. 通过在构造函数中保存对新绑定方法的引用，我们可以在对话框断开时删除事件(稍后将详细介绍)。最后，我们将注意力集中在元素上，并将焦点设置在shadow root中的适当元素上

我们还创建了一个很好的小实用工具方法来关闭我们的对话框，该对话框调度一个自定义事件，警告某些监听器已关闭对话框。

如果元素是关闭的 (即 `!open`),我们检查以确保 `this._wasFocused` 属性已定义并具有 `focus` 方法并调用该方法以将用户的焦点返回到常规DOM。然后我们删除我们的事件监听器以避免任何内存泄漏。

说到清理自己，我们采用了另一种生命周期方法: `disconnectedCallback`. `disconnectedCallback` 与 `connectedCallback` 相反 ，因为一旦元素从DOM中删除，就调用该方法，并允许我们清理绑定到元素的任何事件监听器或`MutationObserver`。

碰巧的是，我们还有几个事件侦听器要连接起来:

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

现在我们有一个运行良好，大部分可访问的对话框元素。 我们可以做一些修饰，比如将焦点集中在元素上，但这超出了我们在这里学习的范围。

还有一个生命周期方法不适用于我们的元素, the `adoptedCallback`,元素被采用（插入）到DOM的另一部分时触发。

在下面的示例中，您将看到我们的模板元素正被一个标准`<one-dialog>`元素所使用

See the Pen [Dialog example using template](https://codepen.io/calebdwilliams/pen/vbVXqv/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

### 另一件事：非演示组件

到目前为止，我们创建的 `<one-template>` 是一个典型的自定义元素，它包含了当元素包含在文档中时被插入到文档中的标记和行为。然而，并不是所有的元素都需要直观地呈现。在React生态系统中，组件通常用于管理应用程序状态或其他一些主要功能, 像  [react-redux](https://redux.js.org/basics/usage-with-react) 里的 `<Provider />` .

让我们想象一下，我们的组件是工作流中一系列对话框的一部分。当一个对话框关闭时，下一个对话框应该打开。我们可以创建一个容器组件来监听我们的`dialog-closed`事件并在整个工作流程中进行

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

这个元素没有任何表示逻辑，但充当应用程序状态的控制器。只需稍加努力，我们就可以重新创建类似Redux的状态管理系统，只使用一个自定义元素，可以在React的Redux容器组件所在的同一个应用程序中管理整个应用程序的状态。

### 这是对自定义元素的深入了解

现在我们对自定义元素有了很好的理解，我们的对话框开始融合在一起。但它仍然存在一些问题。

请注意，我们必须添加一些CSS来重新设置对话框按钮，因为元素的样式会干扰页面的其余部分。虽然我们可以利用命名策略（如BEM）来确保我们的样式不会与其他组件产生冲突，但是有一种更友好的方式来隔离样式。这是影子DOM，这就是本系列的下一部分关于Web组件的内容。

我们需要做的另一件事是为每个组件定义一个新模板，或者为我们的对话框找到一些切换模板的方法。就目前而言，每页只能有一个对话框类型，因为它使用的模板必须始终存在。因此，我们要么需要注入动态内容的方法，要么需要交换模板的方法。

在下一篇文章中，我们将研究如何 `<one-dialog>`通过使用shadow DOM合并样式和内容封装来提高我们刚刚创建的元素的可用性。

#### 文章系列：

1.  [Web 组件 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [制作可重复使用的HTML模板](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [从头开始创建自定义元素（本文）](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [使用Shadow DOM封装样式和结构](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Web组件的高级工具](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
