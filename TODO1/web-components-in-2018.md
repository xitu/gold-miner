> * 原文地址：[Web Components in 2018](https://www.sitepen.com/blog/2018/07/06/web-components-in-2018/)
> * 原文作者：[James Milner](https://www.sitepen.com/blog/author/jmilner/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/web-components-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/web-components-in-2018.md)
> * 译者：
> * 校对者：

# Web Components in 2018

![](https://www.sitepen.com/blog/wp-content/uploads/2018/06/blog-1024x538.png)

For many front-end developers, components have become a central concept in their development workflow. Components provide a robust model for architecting and scaling complex applications, allowing for composition from smaller and simpler encapsulated parts. The concept of the component has existed on the web for some time, with frameworks like the Dojo Toolkit championing them in its Dijit widget system early on in the JavaScript ecosystem.

Modern frameworks like React, Angular, Vue, and Dojo have further put components at the forefront of development, keeping them as core primitives in their architecture. However, even though component architectures have become more common, arguably the diversity of frameworks and libraries has led to a siloed and fragmented components market. This fragmentation has often kept teams locked into a specific framework, even as times and technologies change.

The desire to tackle this fragmentation, and standardise the web component model has been an ongoing endeavor. Its beginnings sit in the genesis of the ‘Web Components’ specifications [circa 2011](https://github.com/w3c/webcomponents/commits/gh-pages?after=0625cf4c42785aa1202a9d0daed182e12466aa29+1889) and were first presented to the world by Alex Russell at [Fronteers Conference](https://fronteers.nl/congres/2011) the same year. The web components specifications grew out of the desire to provide a canonical way of creating components that browsers can understand. This effort is still very much ongoing but is closer than ever before to having cross-browser implementations. In theory, these specifications and implementations are paving the way for interoperability and composition of components from different vendors. Here we examine the building blocks of Web Components.

## The Building Blocks

Web Components are not a single technology. Instead, they are series of browser standards defined by the [W3C](https://www.w3.org/) allowing developers to build components in a way the browser can natively understand. These standards include:

*   **HTML Templates and Slots** – Reusable HTML markup with entry points for user-specific markup
*   **Shadow DOM** – DOM encapsulation for markup and styles
*   **Custom Elements** – Defining named custom HTML elements with specific behaviour

There is another Web Components specification, **HTML Imports**, for importing HTML and intentionally Web Components into a web page; however, the [Firefox team did not believe this was the best approach](https://hacks.mozilla.org/2015/06/the-state-of-web-components/), citing crossover with the [ES Module](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) specification, and it has since lost most of its traction.

There has been some iteration on the Shadow DOM and Custom Elements specifications, and both are now in their second version (v1). In February 2016, there was a push to make the standalone Custom Elements and Shadow DOM specifications obsolete and respectively, [pushing them upstream into the DOM Standard](https://github.com/w3c/webcomponents/).

## HTML Template and Slot Elements

The most widely supported and arguably straightforward portion of the Web Component specifications is HTML Templates which allow developers to declare a section of inert markup without directly having it render until it gets duplicated for use. As a simple example you could describe a template like this in HTML:

```
<template id="custom-template>
     <h1>HTML Templates are rad</h1>
</template>
```

Once this template gets declared in the DOM, it is then possible to reference this template in JavaScript:

```
const template = document.getElementById("custom-template");
const templateContent = template.content;
const container = document.getElementById("container");
const templateInstance = templateContent.cloneNode(true);
container.appendChild(templateInstance);
```

Using this method, it is possible to reuse the template using the `cloneNode` function. Alongside the `<template>` tag is the `<slot>` tag. Slots allow developers to dynamically place custom HTML content within the template at specified points. The `name` attribute is used to create a unique identifier to slot into:

```
<template id="custom-template">
    <p><slot name="custom-text">We can put whatever we want here!</slot></p>
</template>
```

Slots are most useful in conjunction with [Custom Elements](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements). They allow developers to write markup inside a declared Custom Element. When used with the `slot` attribute, the markup from the corresponding Custom Element gets placed inside the corresponding `<slot>` tag in the template.

## Shadow DOM

Accessing elements in a page is an essential part of web development. CSS Selectors are useful not just for styling elements, but also querying a collection of DOM nodes. Generally, this occurs via selecting known identifiers, for example using `document.querySelectorAll` returns an array of elements matching a given selector in the entire DOM tree. However, what if the application in question is very large, with many elements with matching class names? At this point, it may get confusing to determine which elements get targeted and bugs could get introduced. Wouldn’t it be nice if it was possible to abstract and isolate parts of the DOM, hiding them away from being selected by DOM selectors? Shadow DOM allows developers to do this, closing off DOM away in a separate subtree. Ultimately this provides robust encapsulation and isolation from other elements in the page, a core benefit of Web Components.

In a similar vein, we have a comparable issue with CSS classes and IDs for styling as they are global. Clashing identifiers overwrite each other’s styling rules. Similar to selecting nodes within the DOM tree, what if it was possible to scope CSS to a specific subtree of DOM, avoiding global styling clashes? Popular styling technologies like [CSS Modules](https://github.com/css-modules/css-modules), or [Styled Components](https://www.styled-components.com/), attempt to solve this problem as part of their core concerns. For example, CSS Modules provide unique identifiers to each CSS class to prevent clashes by hashing the class and module names. The difference with Shadow DOM is that it allows this as a **native feature** without any class name mangling. The Shadow DOM fences off parts of the DOM to prevent unwanted behaviours in our sites and applications.

So how does it work at the code level? It is possible to attach a Shadow DOM onto an element:

```
element.attachShadow({mode: 'open'});
```

Here the `attachShadow` takes an object argument with a property of `mode`. Shadow DOMs can either be `open` or `closed`. `open` allows access the subtree DOM using `element.shadowRoot` whereas `closed` makes this property return `null`. Creating a Shadow DOM, in turn, creates a shadow boundary, which alongside encapsulating elements, also encapsulates styles. All styling inside an element is scoped to that shadow tree by default, which can make styling selectors much shorter. The Shadow DOM can get used in conjunction with HTML templates:

```
const shadowRoot = element.attachShadow({mode: 'open'});
shadowRoot.appendChild(templateContent.cloneNode(true));
```

Now the `element` has a shadow tree who’s content is a copy of the template. Here the Shadow DOM, `<template>` and `<slot>` are used in unison to create the reusability and encapsulation needed for a component.

## Bringing it Together with Custom Elements

HTML Templates and Slots provide reusability and flexibility, and the Shadow DOM provides encapsulation. Custom Elements allow this to be taken a step further, wrapping together these features into its own named reusable element, which can get used as a regular HTML element.

#### Defining a Custom Element

Defining Custom Elements is done using JavaScript. Custom Elements rely on ES2015+ Classes as their mode of declaration and always extend an `HTMLElement` or subclass. Here’s an example of creating a counter Custom Element using ES2015+ syntax:

```
// We define an ES6 class that extends HTMLElement
class CounterElement extends HTMLElement {
    constructor() {
        super();
 
        // Initialise the counter value
        this.counter = 0;
 
        // We attach an open shadow root to the custom element
        const shadowRoot= this.attachShadow({mode: 'open'});
 
        // We define some inline styles using a template string
        const styles=`
            :host {
                position: relative;
                font-family: sans-serif;
            }
 
            #counter-increment, #counter-decrement {
                width: 60px;
                height: 30px;
                margin: 20px;
                background: none;
                border: 1px solid black;
            }
 
            #counter-value {
                font-weight: bold;
            }
        `;
 
        // We provide the shadow root with some HTML
        shadowRoot.innerHTML = `
            <style>${styles}</style>
            <h3>Counter</h3>
            <slot name='counter-content'>Button</slot>
            <button id='counter-increment'> - </button>
            <span id='counter-value'>; 0 </span>;
            <button id='counter-decrement'> + </button>
        `;
 
        // We can query the shadow root for internal elements
        // in this case the button
        this.incrementButton = this.shadowRoot.querySelector('#counter-increment');
        this.decrementButton = this.shadowRoot.querySelector('#counter-decrement');
        this.counterValue = this.shadowRoot.querySelector('#counter-value');
 
        // We can bind an event which references one of the class methods
        this.incrementButton.addEventListener("click", this.decrement.bind(this));
        this.decrementButton.addEventListener("click", this.increment.bind(this));
 
    }
 
    increment() {
        this.counter++
        this.invalidate();
    }
 
    decrement() {
        this.counter--
        this.invalidate();
    }
 
    // Call when the counter changes value
    invalidate() {
        this.counterValue.innerHTML = this.counter;
    }
}
 
// This is where the actual element is defined for use in the DOM
customElements.define('counter-element', CounterElement);
```

Notice the critical last line, which registers the Custom Element for use in the DOM.

#### Types of Custom Element

The code above shows the extension of the `HTMLElement` interface, but it is also possible to extend from more specific elements, for example, `HTMLButtonElement`. The web component specification provides a [complete list of interfaces that can get extended](https://html.spec.whatwg.org/multipage/indices.html#element-interfaces).

Custom Elements come in two major flavours: **Autonomous custom elements** and **Customized built-in elements**. Autonomous custom elements are like those already described and don’t extend a specific interface. Once registered in the page, an autonomous custom element can get used like regular HTML elements. For example, with the counter element defined above, it is possible to declare it via `<counter-element></counter-element>` in HTML, or `document.createElement('counter-element')` in JavaScript.

Customized built-in elements have a slightly different usage, where the `is` attribute is passed when declaring the element in HTML (e.g. `<button is='special-button'>`) used on the standard element, or passing the `is` property to the `document.createElement` function options (e.g. `document.createElement("button", { is: "special-button" }`).

#### Custom Element Lifecycle

Custom Elements also have a series of lifecycle events for managing the attachment of the component to and from the DOM:

*   `connectedCallback`: connection to the DOM
*   `disconnectedCallback`: disconnection from the DOM
*   `adoptedCallback`: movements across documents

A common mistake is to use `connectedCallback` as a one-off initialisation event, but this gets called every time you connect this element to the DOM. Instead, for one time initialisation, `constructor` is the more appropriate API call.

There is also `attributeChangedCallback` which can be used to monitor changes to element attributes and have them update internal state. However, for this to get used, it is necessary to first define an `observedAttributes` getter in the element Class:

```
constructor() {
    super();
    // ...
    this.observedAttributes();
}
 
get observedAttributes() {return ['someAttribute']; } 
// Other methods
```

From here it is possible to handle changes to the element’s attributes via `attributeChangedCallback` :

```
attributeChangedCallback(attributeName, oldValue, newValue) {
    if (attributeName==="someAttribute") {
        console.log(oldValue, newValue)
        // do something based on attribute changes
    }
}
```

## What About Support?

As of June 2018, Shadow DOM v1 and Custom Elements v1 support exist in Chrome, Safari, Samsung Internet and also [under a feature flag on Firefox](https://bugzilla.mozilla.org/show_bug.cgi?id=889230) which is promising. Both are still [under consideration in Edge](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/customelements/). Until that point, there is a set of polyfills from the [webcomponents GitHub repo](https://github.com/webcomponents/webcomponentsjs). These polyfills allow you to run Web Components in all evergreen browser and also IE11. The webcomponentsjs library contains multiple flavours, including a script with all necessary polyfills (_webcomponents-bundle.js_) and also a version that does feature detection to load in only the necessary polyfills (_webcomponents-loader.js_). If you use the loader, you must host the various polyfill bundles also so that the loader can fetch them.

For those shipping ES5 bundles in code, it is necessary to also the ship the _custom-elements-es5-adapter.js_ file, which must load first and not be bundled in with component code. This adapter is needed as Custom Elements **must** extend HTMLElement’s which requires an ES2015 call to `super()` in the constructor (this can be confusing as the file has `es5` in it!). On IE11 this will throw an error due to lack of ES2015 class support, [but this can be ignored](https://github.com/webcomponents/webcomponentsjs/issues/900).

## Web Components and Frameworks

Historically one of the biggest champions of Web Components is the Polymer library. Polymer adds syntactic sugar around the Web Component APIs to make it easier to author and ship components. In the latest version, [Polymer](https://www.polymer-project.org/) 3, it has moved towards using ES2015 Modules and using npm as the standard package manager, keeping it inline with other modern frameworks. Another recent flavour of Web Component authoring tools are those that act more like compilers than a framework. Two such frameworks are [Stencil](https://stenciljs.com/docs/introduction/) and [Svelte](https://svelte.technology/guide). Here components are written using the respective tools API and then compile down to native Web Components. Frameworks such as [Dojo 2,](https://dojo.io/) take the approach of allowing developers to write framework specific components, but also allow compilation down to native Web Components. In Dojo 2’s case this is achieved using [@dojo/cli tools](https://github.com/dojo/cli-build-widget).

One of the ideals of having native Web Components is the ability to use them across projects and teams, even if they potentially use different frameworks. Different frameworks currently have differing relations with Web Components, with some being more on board than others. There are explanations of how to use native Web Components in frameworks such as [React](https://www.sitepen.com/blog/2017/08/08/wrapping-web-components-with-react/) and [Angular](https://www.sitepen.com/blog/2017/09/14/using-web-components-with-angular/), but both have caveats around their idiosyncrasies. One of the best resources for understanding this relationship is Rob Dodson’s [Custom Elements Everywhere](https://custom-elements-everywhere.com), which has tests to see how well different frameworks integrate with Custom Elements (the core element of Web Components).

## Final Thoughts

Adoption and hype around Web Components have been extended and undulating. That said, as the Web Component specifications gain better adoption, the need for polyfills should gradually dissolve, keeping them leaner and faster for users. The Shadow DOM allows developers to write simple, scoped CSS which is arguably easier to manage and generally better for performance. Custom Elements give a unified methodology for defining components that can (in theory) get used across codebases and teams. At the moment there are additional specification proposals that developers may be able to leverage along the base specifications:

*   [**Custom Element Registries**](https://github.com/w3c/webcomponents/issues/716) – Scoped element registration, preventing element name clashing
*   [**Shadow CSS Parts**](https://tabatkins.github.io/specs/css-shadow-parts/) – Native theming of components
*   [**Template Instantiation**](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Template-Instantiation.md) – Fast dynamic templating using JavaScript variables

Additions such as these could add even more power to the native web platform, increasing the potential for developers with less need for abstractions.

The base specifications are an undeniably powerful set of tools, but ultimately it is up to frameworks, developers, and teams to adopt them to reach their full potential. With frameworks like React, Vue, and Angular holding large chunks of developer mindshare, will that start to be eroded by native aligned technologies and tools? Only time will tell.

* * *

## Next steps

Are you looking to leverage web components in your next project or framework? [Contact us](https://www.sitepen.com/site/contact.html) to discuss how we can help!

Get help from [SitePen On-Demand Development](https://www.sitepen.com/support/index.html), our fast and efficient solutions to JavaScript and TypeScript development problems of any size.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
