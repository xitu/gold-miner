> * 原文地址：[Encapsulating Style and Structure with Shadow DOM](https://css-tricks.com/encapsulating-style-and-structure-with-shadow-dom/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
> * 译者：
> * 校对者：

# Encapsulating Style and Structure with Shadow DOM

This is part four of a five-part series discussing the Web Components specifications. In [part one](https://juejin.im/post/5c9a3cce5188252d9b3771ad), we took a 10,000-foot view of the specifications and what they do. In [part two](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md), we set out to build a custom modal dialog and created the HTML template for what would evolve into our very own custom HTML element in [part three](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md).

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [Crafting Reusable HTML Templates](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [Creating a Custom Element from Scratch](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [Encapsulating Style and Structure with Shadow DOM (_This post_)](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Advanced Tooling for Web Components](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

* * *

If you haven’t read those articles, you would be advised to do so now before proceeding in this article as this will continue to build upon the work we’ve done there.

When we last looked at our dialog component, it had a specific shape, structure and behaviors, however it relied heavily on the outside DOM and required that the consumers of our element would need to understand it’s general shape and structure, not to mention authoring all of their own styles (which would eventually modify the document’s global styles). And because our dialog relied on the contents of a template element with an id of "one-dialog", each document could only have one instance of our modal.

The current limitations of our dialog component aren’t necessarily bad. Consumers who have an intimate knowledge of the dialog’s inner workings can easily consume and use the dialog by creating their own `<template>` element and defining the content and styles they wish to use (even relying on global styles defined elsewhere). However, we might want to provide more specific design and structural constraints on our element to accommodate best practices, so in this article, we will be incorporating the shadow DOM to our element.

### What is the shadow DOM?

In our [introduction article](https://juejin.im/post/5c9a3cce5188252d9b3771ad), we said that the shadow DOM was "capable of isolating CSS and JavaScript, almost like an `<iframe>`." Like an `<iframe>`, selectors and styles inside of a shadow DOM node don’t leak outside of the shadow root and styles from outside the shadow root don’t leak in. There are a few exceptions that inherit from the parent document, like font family and document font sizes (e.g. `rem`) that can be overridden internally.

Unlike an `<iframe>`, however, all shadow roots still exist in the same document so that all code can be written inside a given context but not worry about conflicts with other styles or selectors.

### Adding the shadow DOM to our dialog

To add a shadow root (the base node/document fragment of the shadow tree), we need to call our element’s `attachShadow` method:

```
class OneDialog extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
    this.close = this.close.bind(this);
  }
}
```

By calling `attachShadow` with `mode:` `'open'`, we are telling our element to save a reference to the shadow root on the `element.shadowRoot` property. `attachShadow` always returns a reference to the shadow root, but here we don’t need to do anything with that.

If we had called the method with `mode: 'closed'`, no reference would have been stored on the element and we would have to create our own means of storage and retrieval using a `WeakMap` or `Object`, setting the node itself as the key and the shadow root as the value.

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

We could also save a reference to the shadow root on our element itself, using a `Symbol` or other key to try to make the shadow root private.

In general, the closed mode for shadow roots exists for native elements that use the shadow DOM in their implementation (like `<audio>` or `<video>`). Further, for unit testing our elements, we might not have access to the `shadowRoots` object, making it unable for us to target changes inside our element depending on how our library is architected.

**There might be some legitimate use cases for user-land closed shadow roots, but they are few and far between**, so we’ll stick with the open shadow root for our dialog.

After implementing the new open shadow root, you might notice now that our element is completely broken when we try to run it:

See the Pen [Dialog example using template with shadow root](https://codepen.io/calebdwilliams/pen/WPLwzv/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

This is because all of the content we had before was added to and manipulated in the traditional DOM (what we’ll call the [light DOM](https://stackoverflow.com/questions/42093610/difference-between-light-dom-and-shadow-dom)). Now that our element has a shadow DOM attached, there is no outlet for the light DOM to render. Let’s start fixing these issues by moving our content to the shadow DOM:

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

The major changes to our dialog so far are actually relatively minimal, but they carry a lot of impact. For starters, all our selectors (including our style definitions) are internally scoped. For example, our dialog template only has one button internally, so our CSS only targets `button { ... }`, and those styles don’t bleed out to the light DOM.

We are, however, still reliant on the template that is external to our element. Let’s change that by removing the markup from our template and dropping it into our shadow root’s `innerHTML`.

See the Pen [Dialog example using only shadow root](https://codepen.io/calebdwilliams/pen/GzPqvo/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

### Including content from the light DOM

The [shadow DOM specification](https://www.w3.org/TR/shadow-dom/) includes a means for allowing content from outside the shadow root to be rendered inside of our custom element. For those of you who remember AngularJS, this is a similar concept to `ng-transclude` or using `props.children` in React. With Web Components, this is done using the `<slot>` element.

A simple example would look like this:

```
<div>
  <span>world <!-- this would be inserted into the slot element below --></span>
  <#shadow-root><!-- pseudo code -->
    <p>Hello <slot></slot></p>
  </#shadow-root>
</div>
```

A given shadow root can have any number of slot elements, which can be distinguished with a `name` attribute. The first slot inside of the shadow root without a name, will be the default slot and all content not otherwise assigned will flow inside that node. Our dialog really needs two slots: a heading and some content (which we’ll make default).

See the Pen [Dialog example using shadow root and slots](https://codepen.io/calebdwilliams/pen/dawXJb/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

Go ahead and change the HTML portion of our dialog and see the result. Any content inside of the light DOM is inserted into the slot to which it is assigned. Slotted content remains inside the light DOM although it is rendered as if it were inside the shadow DOM. This means that these elements are still fully style-able by a consumer who might want to control the look and feel of their content.

A shadow root’s author _can_ style content inside the light DOM to a limited extent using the CSS `::slotted()` pseudo-selector; however, the DOM tree inside slotted is collapsed, so only simple selectors will work. In other words, we wouldn't be able to style a `<strong>` element inside a `<p>` element within the flattened DOM tree in our previous example.

### The best of both worlds

Our dialog is in a good state now: it has encapsulated, semantic markup, styles and behavior; however, some consumers of our dialog might still want to define their own template. Fortunately, by combining two techniques we’ve already learned, we can allow authors to optionally define an external template.

To do this, we will allow each instance of our component to reference an optional template ID. To start, we need to define a getter and setter for our component’s `template`.

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

Here we’re doing much the same thing that we did with our `open` property by tying it directly to its corresponding attribute. But at the bottom, we’re introducing a new method to our component: `render`. We are going to use our render method to insert our shadow DOM’s content and remove that behavior from the `connectedCallback`; instead, we will call render when our element is connected:

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

Our dialog now has some really basic default stylings, but also gives consumers the ability to define a new template for each instance. If we wanted, we could even use `attributeChangedCallback` to make this component update based on the template it’s currently pointing to:

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

See the Pen [Dialog example using shadow root, slots and template](https://codepen.io/calebdwilliams/pen/rROadR/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

In the demo above, changing the template attribute on our `<one-dialog>` element will alter which design is being used when the element is rendered.

### Strategies for styling the shadow DOM

Currently, the only reliable way to style a shadow DOM node is by adding a `<style>` element to the shadow root’s inner HTML. This works fine in almost every case as browsers will de-duplicate stylesheets across these components, where possible. This _does_ tend to add a bit of memory overhead, but generally not enough to notice.

Inside of these style tags, we can use [CSS custom properties](https://css-tricks.com/guides/css-custom-properties/) to provide an API for styling our components. Custom properties can pierce the shadow boundary and effect content inside a shadow node.

“Can we use a `<link>` element inside of a shadow root?” you might ask. And, in fact, we can. The trouble comes when trying to reuse this component across multiple applications as the CSS file might not be saved in a consistent location throughout all apps. However, if we are certain as to the element’s stylesheet location, then using `<link>` is an option. The same holds true for including an `@import` rule in a style tag.

It is also worth mentioning that not all components need the kind of styling we're using here. Using the CSS `:host` and `:host-context` selectors, we can simply define more primitive components as block-level elements and allow consumers to provide classes to style things like background colors, font settings, and more.

Our dialog, on the other hand, is fairly complex. Something like a listbox (comprised of a label and an checkbox input) is not and can be just merely as a surface for native element composition. That is equally as valid a styling strategy as is being more explicit about styles (say for design systems purposes where all checkboxes might look a certain way). It largely depends on your use case.

#### CSS custom properties

One of the benefits of using [CSS custom properties](https://css-tricks.com/tag/custom-properties/) — also called CSS variables — is that they bleed through the shadow DOM. This is by design, giving component authors a surface for allowing theming and styling of their components from the outside. It is important to note, however, that since CSS cascades, changes to custom properties made inside a shadow root do not bleed back up.

See the Pen [CSS custom properties and shadow DOM](https://codepen.io/calebdwilliams/pen/eXJZza/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

Go ahead and comment out or remove the variables set in the CSS panel of the demo above and see how this impacts the rendered content. Afterward, you can take a look at the styles in the shadow DOM’s `innerHTML`, you’ll see how the shadow DOM can define its own property that won’t affect the light DOM.

#### Constructible stylesheets

At the time of this writing, there is a proposed web feature that will allow for more modular styling of shadow DOM and light DOM elements using [constructible stylesheets](https://github.com/WICG/construct-stylesheets/blob/gh-pages/explainer.md) that has already landed in Chrome 73 and received positive signaling from Mozilla.

This feature would allow authors to define stylesheets in their JavaScript files similar to how they would write normal CSS and share those styles across multiple nodes. So, a single stylesheet could be appended to multiple shadow roots and potentially the document as well.

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

In the above example, the `everythingTomato` stylesheet would be simultaneously applied to the shadow root and to the document’s body. This feature would be very useful for teams creating design systems and components that are intended to be shared across multiple applications and frameworks.

In the next demo, we can see a really basic example of how this can be utilized and the power that constructble stylesheets offer.

See the Pen [Construct style sheets demo](https://codepen.io/calebdwilliams/pen/aPgbMb/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

In this demo, we construct two stylesheets and append them to the document and to the custom element. After three seconds, we remove one stylesheet from our shadow root. For those three seconds, however, the document and the shadow DOM share the same stylesheet. Using the polyfill included in that demo, there are actually two style elements present, but Chrome runs this natively.

That demo also includes a form for showing how a sheet’s rules can easily and effectively changed asynchronously as needed. This addition to the web platform can be a powerful ally for those creating design systems that span multiple frameworks or site authors who want to provide themes for their websites.

There is also a proposal for [CSS Modules](https://github.com/w3c/webcomponents/issues/759) that could eventually be used with the `adoptedStyleSheets` feature. If implemented in its current form, this proposal would allow importing CSS as a module much like ECMAScript modules:

```
import styles './styles.css';

class SomeCompoent extends HTMLElement {
  constructor() {
    super();
    this.adoptedStyleSheets = [styles];
  }
}
```

#### Part and theme

Another feature that is in the works for styling Web Components are the `::part()` and `::theme()` pseudo-selectors. The `::part()` specification will allow authors to define parts of their custom elements that have a surface for styling:

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

In our global CSS, we could target any element that has a part called `description` by invoking the CSS `::part()` selector.

```
other-component::part(description) {
  color: tomato;
}
```

In the above example, the primary message of the `<h1>` tag would be in a different color than the description part, giving custom element authors the ability to expose styling APIs for their components and maintain control over the pieces they want to maintain control over.

The difference between `::part()` and `::theme()` is that `::part()` must be specifically selected whereas `::theme()` can be nested at any level. The following would have the same effect as the above CSS, but would also work for any other element that included a `part="description"` in the entire document tree.

```
:root::theme(description) {
  color: tomato;
}
```

Like constructible stylesheets, `::part()` has landed in Chrome 73.

### Wrapping up

Our dialog component is now complete, more-or-less. It includes its own markup, styles (without any outside dependencies) and behaviors. This component can now be included in projects that use any current or future frameworks because they are built against the browser specifications instead of third-party APIs.

Some of the core controls are a _little_ verbose and do rely on at least a moderate knowledge of how the DOM works. In our final article, we will discuss higher-level tooling and how to incorporate with popular frameworks.

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [Crafting Reusable HTML Templates](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [Creating a Custom Element from Scratch](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [Encapsulating Style and Structure with Shadow DOM (_This post_)](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Advanced Tooling for Web Components](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
