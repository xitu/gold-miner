> * 原文地址：[Creating a Custom Element from Scratch](https://css-tricks.com/creating-a-custom-element-from-scratch/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
> * 译者：
> * 校对者：

# Creating a Custom Element from Scratch

In the [last article](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md), we got our hands dirty with Web Components by creating an HTML template that is in the document but not rendered until we need it.

Next up, we’re going to continue our quest to create a custom element version of the dialog component below which currently only uses `HTMLTemplateElement`:

See the Pen [Dialog with template with script](https://codepen.io/calebdwilliams/pen/JzjLyQ/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

So let’s push ahead by creating a custom element that consumes our `template#dialog-template` element in real-time.

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [Crafting Reusable HTML Templates](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [Creating a Custom Element from Scratch (_This post_)](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [Encapsulating Style and Structure with Shadow DOM](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Advanced Tooling for Web Components](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

* * *

### Creating a custom element

The bread and butter of Web Components are **custom elements**. The `customElements` API gives us a path to define custom HTML tags that can be used in any document that contains the defining class.

Think of it like a React or Angular component (e.g. `<MyCard />`), but without the React or Angular dependency. Native custom elements look like this: `<my-card></my-card>`. More importantly, think of it as a standard element that can be used in your React, Angular, Vue, [insert-framework-you’re-interested-in-this-week] applications without much fuss.

Essentially, a custom element consists of two pieces: a **tag name** and a **class** that extends the built-in `HTMLElement` class. The most basic version of our custom element would look like this:

```
class OneDialog extends HTMLElement {
  connectedCallback() {
    this.innerHTML = `<h1>Hello, World!</h1>`;
  }
}

customElements.define('one-dialog', OneDialog);
```

Note: throughout a custom element, the `this` value is a reference to the custom element instance.

In the example above, we defined a new standards-compliant HTML element, `<one-dialog></one-dialog>`. It doesn’t do much… yet. For now, using the `<one-dialog>` tag in any HTML document will create a new element with an `<h1>` tag reading “Hello, World!”

We are definitely going to want something more robust, and we’re in luck. In the [last article](https://css-tricks.com/crafting-reusable-html-templates), we looked at creating a template for our dialog and, since we will have access to that template, let’s utilize it in our custom element. We added a script tag in that example to do some dialog magic. let’s remove that for now since we’ll be moving our logic from the HTML template to inside the custom element class.

```
class OneDialog extends HTMLElement {
  connectedCallback() {
    const template = document.getElementById('one-dialog');
    const node = document.importNode(template.content, true);
    this.appendChild(node);
  }
}
```

Now, our custom element (`<one-dialog>`) is defined and the browser is instructed to render the content contained in the HTML template where the custom element is called.

Our next step is to move our logic into our component class.

### Custom element lifecycle methods

Like React or Angular, custom elements have **lifecycle methods**. You’ve already been passively introduced to `connectedCallback`, which is called when our element gets added to the DOM.

The `connectedCallback` is separate from the element’s `constructor`. Whereas the constructor is used to set up the bare bones of the element, the `connectedCallback` is typically used for adding content to the element, setting up event listeners or otherwise initializing the component.

In fact, the constructor can’t be used to modify or manipulate the element’s attributes by design. If we were to create a new instance of our dialog using `document.createElement`, the constructor would be called. A consumer of the element would expect a simple node with no attributes or content inserted.

The `createElement` function has no options for configuring the element that will be returned. It stands to reason, then, that the constructor shouldn't have the ability to modify the element that it creates. That leaves us with the `connectedCallback` as the place to modify our element.

With standard built-in elements, the element’s state is typically reflected by what attributes are present on the element and the values of those attributes. For our example, we’re going to look at exactly one attribute: `[open]`. In order to do this, we’ll need to watch for changes to that attribute and we’ll need `attributeChangedCallback` to do that. This second lifecycle method is called whenever one of the element constructor’s `observedAttributes` are updated.

That might sound intimidating, but the syntax is pretty simple:

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

In our case above, we only care if the attribute is set or not, we don’t care about a value (this is similar to the HTML5 `required` attribute on inputs). When this attribute is updated, we update the element’s `open` property. A property exists on a JavaScript object whereas an attribute exists on an HTMLElement, this lifecycle method helps us keep the two in sync.

We wrap the updater inside the `attributeChangedCallback` inside a conditional checking to see if the new value and old value are equal. We do this to prevent an infinite loop inside our program because later we are going to create a property getter and setter that will keep the property and attributes in sync by setting the element’s attribute when the element’s property gets updated. The `attributeChangedCallback` does the inverse: updates the property when the attribute changes.

Now, an author can consume our component and the presence of the `open` attribute will dictate whether or not the dialog will be open by default. To make that a bit more dynamic, we can add custom getters and setters to our element’s open property:

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

Our getter and setter will keep the `open` attribute (on the HTML element) and property (on the DOM object) values in sync. Adding the `open` attribute will set `element.open` to `true` and setting `element.open` to `true` will add the `open` attribute. We do this to make sure that our element’s state is reflected by its properties. This isn’t technically required, but is considered a best practice for authoring custom elements.

This _does_ inevitably lead to a bit of boilerplate, but creating an abstract class that keeps these in sync is a fairly trivial task by looping over the observed attribute list and using `Object.defineProperty`.

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

The above example isn't perfect, it doesn't take into account the possibility of attributes like `open` which don't have a value assigned to them but rely only on the presence of the attribute. Making a perfect version of this would be beyond the scope of this article.

Now that we know whether or not our dialog is open, let’s add some logic to actually do the showing and hiding:

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

There’s a lot going on here, but let’s walk through it. The first thing we do is grab our wrapper and toggle the `.open` class based on `isOpen`. To keep our element accessible, we need to toggle the `aria-hidden` attribute as well.

If the dialog is open, then we want to save a reference to the previously-focused element. This is to account for accessibility standards. We also add a keydown listener to the document called `watchEscape` that we have bound to the element’s `this` in the constructor in a pattern similar to how React handles method calls in class components.

We do this not only to ensure the proper binding for `this.close`, but also because `Function.prototype.bind` returns an instance of the function with the bound call site. By saving a reference to the newly-bound method in the constructor, we’re able to then remove the event when the dialog is disconnected (more on that in a moment). We finish up by focusing on our element and setting the focus on the proper element in our shadow root.

We also create a nice little utility method for closing our dialog that dispatches a custom event alerting some listener that the dialog has been closed.

If the element is closed (i.e. `!open`), we check to make sure the `this._wasFocused` property is defined and has a `focus` method and call that to return the user’s focus back to the regular DOM. Then we remove our event listener to avoid any memory leaks.

Speaking of cleaning up after ourselves, that takes us to yet another lifecycle method: `disconnectedCallback`. The `disconnectedCallback` is the inverse of the `connectedCallback` in that the method is called once the element is removed from the DOM and allows us to clean up any event listeners or `MutationObservers` attached to our element.

It just so happens we have a few more event listeners to wire up:

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

Now we have a well-functioning, mostly accessible dialog element. There are a few bits of polish we can do, like capturing focus on the element, but that’s outside the scope of what we’re trying to learn here.

There is one more lifecycle method that doesn’t apply to our element, the `adoptedCallback`, which fires when the element is adopted into another part of the DOM.

In the following example, you will now see that our template element is being consumed by a standard `<one-dialog>` element.

See the Pen [Dialog example using template](https://codepen.io/calebdwilliams/pen/vbVXqv/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

### Another thing: non-presentational components

The `<one-template>` we have created so far is a typical custom element in that it includes markup and behavior that gets inserted into the document when the element is included. However, not all elements need to render visually. In the React ecosystem, components are often used to manage application state or some other major functionality, like `<Provider />` in [react-redux](https://redux.js.org/basics/usage-with-react).

Let’s imagine for a moment that our component is part of a series of dialogs in a workflow. As one dialog is closed, the next one should open. We could make a wrapper component that listens for our `dialog-closed` event and progresses through the workflow.

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

This element doesn’t have any presentational logic, but serves as a controller for application state. With a little effort, we could recreate a Redux-like state management system using nothing but a custom element that could manage an entire application’s state in the same one that React’s Redux wrapper does.

### That’s a deeper look at custom elements

Now we have a pretty good understanding of custom elements and our dialog is starting to come together. But it still has some problems.

Notice that we’ve had to add some CSS to restyle the dialog button because our element’s styles are interfering with the rest of the page. While we could utilize naming strategies (like BEM) to ensure our styles won’t create conflicts with other components, there is a more friendly way of isolating styles. Spoiler! It’s shadow DOM and that’s what we’re going to look at in the next part of this series on Web Components.

Another thing we need to do is define a new template for _every_ component or find some way to switch templates for our dialog. As it stands, there can only be one dialog type per page because the template that it uses must always be present. So either we need some way to inject dynamic content or a way to swap templates.

In the next article, we will look at ways to increase the usability of the `<one-dialog>` element we just created by incorporating style and content encapsulation using the shadow DOM.

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [Crafting Reusable HTML Templates](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [Creating a Custom Element from Scratch (_This post_)](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [Encapsulating Style and Structure with Shadow DOM](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Advanced Tooling for Web Components](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
