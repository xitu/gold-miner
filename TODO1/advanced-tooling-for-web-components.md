> * 原文地址：[Advanced Tooling for Web Components](https://css-tricks.com/advanced-tooling-for-web-components/)
> * 原文作者：[Caleb Williams](https://css-tricks.com/author/calebdwilliams/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components.md)
> * 译者：
> * 校对者：

# Advanced Tooling for Web Components

Over the course of the last four articles in this five-part series, we’ve taken a [broad look](https://juejin.im/post/5c9a3cce5188252d9b3771ad) at the technologies that make up the Web Components standards. First, we looked at [how to create HTML templates](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.mds) that could be consumed at a later time. Second, we dove into [creating our own custom element](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md). After that, [we encapsulated our element’s styles and selectors into the shadow DOM](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md), so that our element is entirely self-contained.

We’ve explored how powerful these tools can be by creating our own custom modal dialog, an element that can be used in most modern application contexts regardless of the underlying framework or library. In this article, we will look at how to consume our element in the various frameworks and look at some advanced tooling to really ramp up your Web Component skills.

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [Crafting Reusable HTML Templates](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [Creating a Custom Element from Scratch](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [Encapsulating Style and Structure with Shadow DOM](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Advanced Tooling for Web Components (_This post_)](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

### Framework agnostic

Our dialog component works great in almost any framework or even without one. (Granted, if JavaScript is disabled, the whole thing is for naught.) Angular and Vue treat Web Components as first-class citizens: the frameworks have been designed with web standards in mind. React is slightly more opinionated, but not impossible to integrate.

#### Angular

First, let’s take a look at how Angular handles custom elements. By default, Angular will throw a template error whenever it encounters an element it doesn’t recognize (i.e. the default browser elements or any of the components defined by Angular). This behavior can be changed by including the `CUSTOM_ELEMENTS_SCHEMA`.

> ...allows an NgModule to contain the following:
> 
> *   Non-Angular elements named with dash case (`-`).
> *   Element properties named with dash case (`-`). Dash case is the naming convention for custom elements.
> 
> — [Angular Documentation](https://angular.io/api/core/CUSTOM_ELEMENTS_SCHEMA)

Consuming this schema is as simple as adding it to a module:

```
import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';

@NgModule({
  /** Omitted */
  schemas: [ CUSTOM_ELEMENTS_SCHEMA ]
})
export class MyModuleAllowsCustomElements {}
```

That’s it. After this, Angular will allow us to use our custom element wherever we want with the standard property and event bindings:

```
<one-dialog [open]="isDialogOpen" (dialog-closed)="dialogClosed($event)">
  <span slot="heading">Heading text</span>
  <div>
    <p>Body copy</p>
  </div>
</one-dialog>
```

#### Vue

Vue’s compatibility with Web Components is even better than Angular’s as it doesn’t require any special configuration. Once an element is registered, it can be used with Vue’s default templating syntax:

```
<one-dialog v-bind:open="isDialogOpen" v-on:dialog-closed="dialogClosed">
  <span slot="heading">Heading text</span>
  <div>
    <p>Body copy</p>
  </div>
</one-dialog>
```

One caveat with Angular and Vue, however, is their default form controls. If we wish to use something like reactive forms or `[(ng-model)]` in Angular or `v-model` in Vue on a custom element with a form control, we will need to set up that plumbing for which is beyond the scope of this article.

#### React

React is slightly more complicated than Angular. [React’s virtual DOM](https://reactjs.org/docs/faq-internals.html) effectively takes a JSX tree and renders it as a large object. So, instead of directly modifying attributes on HTML elements like Angular or Vue, React uses an object syntax to track changes that need to be made to the DOM and updates them in bulk. This works just fine in most cases. Our dialog’s open attribute is bound to its property and will respond perfectly well to changing props.

The catch comes when we start to look at the `CustomEvent` dispatched when our dialog closes. React implements a series of native event listeners for us with their [synthetic event system](https://reactjs.org/docs/events.html). Unfortunately, that means that controls like `onDialogClosed` won’t actually attach event listeners to our component, so we have to find some other way.

The most obvious means of adding custom event listeners in React is by using [DOM refs](https://reactjs.org/docs/refs-and-the-dom.html). In this model, we can reference our HTML node directly. The syntax is a bit verbose, but works great:

```
import React, { Component, createRef } from 'react';

export default class MyComponent extends Component {
  constructor(props) {
    super(props);
    // Create the ref
    this.dialog = createRef();
    // Bind our method to the instance
    this.onDialogClosed = this.onDialogClosed.bind(this);

    this.state = {
      open: false
    };
  }

  componentDidMount() {
    // Once the component mounds, add the event listener
    this.dialog.current.addEventListener('dialog-closed', this.onDialogClosed);
  }

  componentWillUnmount() {
    // When the component unmounts, remove the listener
    this.dialog.current.removeEventListener('dialog-closed', this.onDialogClosed);
  }

  onDialogClosed(event) { /** Omitted **/ }

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

Or, we can use stateless functional components and hooks:

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

That’s not bad, but you can see how reusing this component could quickly become cumbersome. Luckily, we can export a default React component that wraps our custom element using the same tools.

```
import React, { Component, createRef } from 'react';
import PropTypes from 'prop-types';

export default class OneDialog extends Component {
  constructor(props) {
    super(props);
    // Create the ref
    this.dialog = createRef();
    // Bind our method to the instance
    this.onDialogClosed = this.onDialogClosed.bind(this);
  }

  componentDidMount() {
    // Once the component mounds, add the event listener
    this.dialog.current.addEventListener('dialog-closed', this.onDialogClosed);
  }

  componentWillUnmount() {
    // When the component unmounts, remove the listener
    this.dialog.current.removeEventListener('dialog-closed', this.onDialogClosed);
  }

  onDialogClosed(event) {
    // Check to make sure the prop is present before calling it
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

...or again as a stateless, functional component:

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

Now we can use our dialog natively in React, but still keep the same API across all our applications (and still drop classes, if that’s your thing).

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

### Advanced tooling

There are a number of great tools for authoring your own custom elements. [Searching through npm](https://www.npmjs.com/search?q=keywords:customElements) reveals a multitude of tools for creating highly-reactive custom elements (including my own pet project), but the most popular today by far is [lit-html](https://github.com/Polymer/lit-html) from the Polymer team and, more specifically for Web Components, [LitElement](https://lit-element.polymer-project.org/).

LitElement is a custom elements base class that provides a series of APIs for doing all of the things we’ve walked through so far. It can be run in a browser without a build step, but if you enjoy using future-facing tools like decorators, there are utilities for that as well.

Before diving into how to use lit or LitElement, take a minute to familiarize yourself with [tagged template literals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals), which are a special kind of function called on template literal strings in JavaScript. These functions take in an array of strings and a collection of interpolated values and can return anything you might want.

```
function tag(strings, ...values) {
  console.log({ strings, values });
  return true;
}
const who = 'world';

tag`hello ${who}`; 
/** would log out { strings: ['hello ', ''], values: ['world'] } and return true **/
```

What LitElement gives us is live, dynamic updating of anything passed to that values array, so as a property updates, the element’s render function would be called and the resulting DOM would be re-rendered

```
import { LitElement, html } from 'lit-element';

class SomeComponent {
  static get properties() {
    return { 
      now: { type: String }
    };
  }

  connectedCallback() {
    // Be sure to call the super
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

See the Pen [LitElement now example](https://codepen.io/calebdwilliams/pen/omrXJx/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

What you will notice is that we have to define any property we want LitElement to watch using the `static properties` getter. Using that API tells the base class to call render whenever a change is made to the component’s properties. `render`, in turn, will update only the nodes that need to change.

So, for our dialog example, it would look like this using LitElement:

See the Pen [Dialog example using LitElement](https://codepen.io/calebdwilliams/pen/OdeJdq/) by Caleb Williams ([@calebdwilliams](https://codepen.io/calebdwilliams)) on [CodePen](https://codepen.io).

There are several variants of lit-html available, including [Haunted](https://github.com/matthewp/haunted), a React hooks-style library for Web Components that can also make use of virtual components using lit-html as a base.

At the end of the day, most of the modern Web Components tools are various flavors of what `LitElement` is: a base class that abstracts common logic away from our components. Among the other flavors are [Stencil](https://stenciljs.com/), [SkateJS](https://github.com/skatejs/skatejs), [Angular Elements](https://angular.io/guide/elements) and [Polymer](https://www.polymer-project.org/).

### What’s next

Web Components standards are continuing to evolve and new features are being discussed and added to browsers on an ongoing basis. Soon, Web Component authors will have APIs for interacting with web forms at a high level (including other element internals that are beyond the scope of these introductory articles), like native HTML and CSS module imports, native template instantiation and updating controls, and many more which can be tracked on the [W3C/web components issues board on GitHub](https://github.com/w3c/webcomponents/issues).

These standards are ready to adopt into our projects today with the appropriate polyfills for legacy browsers and Edge. And while they may not replace your framework of choice, they can be used alongside them to augment you and your organization’s workflows.

#### Article Series:

1.  [Web Components 简介](https://juejin.im/post/5c9a3cce5188252d9b3771ad)
2.  [Crafting Reusable HTML Templates](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-reusable-html-templates.md)
3.  [Creating a Custom Element from Scratch](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-a-custom-element-from-scratch.md)
4.  [Encapsulating Style and Structure with Shadow DOM](https://github.com/xitu/gold-miner/blob/master/TODO1/encapsulating-style-and-structure-with-shadow-dom.md)
5.  [Advanced Tooling for Web Components (_This post_)](https://github.com/xitu/gold-miner/blob/master/TODO1/advanced-tooling-for-web-components/.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
