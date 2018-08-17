> * 原文地址：[Web Components in 2018](https://www.sitepen.com/blog/2018/07/06/web-components-in-2018/)
> * 原文作者：[James Milner](https://www.sitepen.com/blog/author/jmilner/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/web-components-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/web-components-in-2018.md)
> * 译者：[老教授](https://juejin.im/user/58ff449a61ff4b00667a745c/posts)
> * 校对者：[xutaogit](https://github.com/xutaogit)、[zyziyun](https://github.com/zyziyun)

# 2018 来谈谈 Web Component

![](https://www.sitepen.com/blog/wp-content/uploads/2018/06/blog-1024x538.png)

对很多人来说，组件已经成为他们开发工作中的核心概念。组件提供了一种健壮的模型，允许我们用一个个更小的更简单的封装好的部件来搭建出复杂的应用程序。组件的概念在 Web 上已经存在一段时间了，比如在 JavaScript 生态的早期，Dojo Toolkit 已经在它的 Dijit 插件系统里面应用了组件这个概念。

现代框架比如说 React、Angular、Vue 和 Dojo 进一步把组件放在开发的前列，并作为核心要素用在它们自己的框架结构上。然而，虽说组件结构变得越来越普遍，但是各种各样的框架和库也衍生出一个纷繁复杂、四分五裂的组件生态。这种分裂常常将一些团队钉死在某个特定的框架上，哪怕时间、技术的更迭也不会轻易地改变。

解决这种割裂的形势，让 Web 组件模型统一化，这项工作已经在努力推进中。最早的努力当数 “Web Component” 规范说明 [circa 2011](https://github.com/w3c/webcomponents/commits/gh-pages?after=0625cf4c42785aa1202a9d0daed182e12466aa29+1889) 的出现，并在同年的 [Fronteers Conference](https://fronteers.nl/congres/2011) 大会上由 Alex Russell 将之宣之于众。该 Web Component 规范的产生和发展，旨在提供一种权威的、浏览器能理解的方式来创建组件。在做出跨浏览器支持的组件方案这件事上我们还有很多事情要做，但已经比以往任何时候更接近目标了。理论上讲，这些规范和实践铺平了组件间相互作用相互结合的道路，即使这些组件出自不同的供应方(比如 React，比如 Vue)。下面我们开始探索 Web Component 规范的组成。

## 组成部分

Web Component 并非单一的技术，而是由一系列 [W3C](https://www.w3.org/) 定义的浏览器标准组成，使得开发者可以构建出浏览器原生支持的组件。这些标准包括：

*   **HTML Templates（译者注：模板）and Slots（译者注：插槽）** – 可复用的 HTML 标签，提供了和用户自定义标签相结合的接口
*   **Shadow DOM（译者注：影子节点）** – 对标签和样式的一层 DOM 包装
*   **Custom Elements（译者注：自定义元素）** – 带有特定行为且用户自命名的 HTML 元素

这里还有另一个 Web Component 规范，**HTML Imports**，用于将 HTML 代码及 Web Component 导入到网页中。然而，在交叉参考 [ES Module](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import) 规范后，[Firefox 团队认为这不是一种最佳实践](https://hacks.mozilla.org/2015/06/the-state-of-web-components/)，该规范也就没多少人在推动了。

Shadow DOM 和 Custom Element 规范经历了一些迭代，现在都已经是第二个版本（v1）。在 2016 年 2 月，有人推动将 Shadow DOM 和 Custom Element [并入 DOM 标准规范里面](https://github.com/w3c/webcomponents/)，而不再作为独立的规范存在。

## template 标签和 slot 标签

HTML 模板是支持度最高的特性，可以说是 Web Component 规范最直观的体现。它允许开发者定义一个直到被复制使用时才会进行渲染的 HTML 标签块。你可以参考下面的简单示例来定义一个模板：

```
<template id="custom-template>
     <h1>HTML Templates are rad</h1>
</template>
```

一旦 DOM 里面定义了这样的一个模板，就可以在 JavaScript 里面引用了：

```
const template = document.getElementById("custom-template");
const templateContent = template.content;
const container = document.getElementById("container");
const templateInstance = templateContent.cloneNode(true);
container.appendChild(templateInstance);
```

像上面那样写，就可以借助 `cloneNode` 函数来复用这个模板。提到 `<template>` 标签就不得不提 `<slot>` 标签。slot 标签允许开发者通过特定接入点来动态替换模板中的 HTML 内容。它用 `name` 属性来作为唯一识别标志（译者注，就类似普通 DOM 节点的 id 属性）：

```
<template id="custom-template">
    <p><slot name="custom-text">We can put whatever we want here!</slot></p>
</template>
```

slot 标签在 [Custom Element](https://developer.mozilla.org/en-US/docs/Web/Web_Components/Using_custom_elements) 的注入中非常有用。它允许开发者在写好的 Custom Element 里面设置标记。当 Custom Element 里面的节点用到了 `slot` 属性作为标记，那这个节点就会替换掉模板里面对应的 slot 标签。

## Shadow DOM

在页面上定位具体的节点这是 web 开发的一个基本能力。CSS 选择器不仅可以用来给节点加样式，还可以用来查询特定的 DOM 集合。这通常发生在根据一个标识符选择特定节点，比方说使用 `document.querySelectorAll` 就可以找到整个 DOM 树中匹配指定选择器的节点数组。然而，如果应用程序非常庞大，有很多节点有冲突的 class 属性，那又该怎么办？此时，程序就不知道哪个节点是想被选中的，bug 也就随之产生。如果可能的话，将部分 DOM 节点抽象出来，隔离开来，让它们不会被 DOM 选择器选择到，那岂不是很好？Shadow DOM 就能做到，它允许开发者将一些节点放到独立的子树上来实现隔离。根本上说 Shadow DOM 提供了一种健壮的封装方式来做到页面节点的隔离，这也是 Web Component 的核心优势。

与此相似，CSS 的类和 ID 应用于全局样式时也会出现类似的问题。冲突的命名标示会导致样式的相互覆盖。那参考上面 DOM 树选择节点的思路，如果能将 CSS 样式限制在某个 DOM 的子树上，不就可以避免全局样式冲突，解决问题？比较有名的样式设置技术比如 [CSS Modules](https://github.com/css-modules/css-modules) 或者 [Styled Components](https://www.styled-components.com/)，它们的核心出发点之一就是为了解决这个问题。举个例子，CSS 模块技术通过对类名和模块名进行哈希处理，赋予每个 CSS 样式唯一的标识符从而避免冲突。Shadow DOM 跟它们不同之处在于它并不对类名做处理，而是直接就把这个作为**原生特性**来支持。它将部分 DOM 节点隔离开来使得我们的网站和程序少了不可预知的变化，更加稳定。

那在代码层面上该怎么操作？可以这样将 Shadow DOM 附加到一个节点上：

```
element.attachShadow({mode: 'open'});
```

这里 `attachShadow` 函数接受一个含 `mode` 属性的对象作为参数。Shadow DOM 可以`打开`或`关闭`。`打开`时使用 `element.shadowRoot` 就可以拿到 DOM 子树，反之如果`关闭`了则会拿到 `null`。接着创建一个 Shadow DOM 就会创建一个阴影的边界，在封装节点的同时封装样式。默认情况下该节点内部的所有样式会被限制仅在这个影子树里生效，于是样式选择器写起来就短得多了。Shadow DOM 通常可以和 HTML 模板结合使用：

```
const shadowRoot = element.attachShadow({mode: 'open'});
shadowRoot.appendChild(templateContent.cloneNode(true));
```

现在这个 `element` 就有一个影子树，影子树的内容是模板的一个复制。Shadow DOM、 `<template>` 标签、`<slot>` 标签在这里和谐地应用在一起，构造出了可复用、封装良好的组件。

## 通过 Custom Element 进一步封装

HTML 的 template 和 slot 标签提供了复用性和灵活性，Shadow DOM 提供了封装方法。而 Custom Element 再进一步，将所有这些特性打包在一起成为有自己名字的可反复使用的节点，让它可以像常规 HTML 节点一样用起来。

#### 定义一个 Custom Element

定义 Custom Element 要用到 JavaScript。Custom Element 依赖 ES2015+ 的 Class 特性，用 Class 作为其声明模式，通常是从 `HTMLElement` 或它的子类继承而来。这里有一个 Custom Element 的例子，使用 ES2015+ 语法创建，用于计数：

```
// 我们定义一个 ES6 的类，拓展于 HTMLElement
class CounterElement extends HTMLElement {
    constructor() {
        super();
 
        // 初始化计数器的值
        this.counter = 0;
 
        // 我们在当前 custom element 上附加上一个打开的影子根节点
        const shadowRoot= this.attachShadow({mode: 'open'});
 
        // 我们使用模板字符串来定义一些内嵌样式
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
 
        // 我们给影子根节点提供一些 HTML
        shadowRoot.innerHTML = `
            <style>${styles}</style>
            <h3>Counter</h3>
            <slot name='counter-content'>Button</slot>
            <button id='counter-increment'> - </button>
            <span id='counter-value'>; 0 </span>;
            <button id='counter-decrement'> + </button>
        `;
 
        // 我们可以通过影子根节点查询内部节点
        // 就比如这里的按钮
        this.incrementButton = this.shadowRoot.querySelector('#counter-increment');
        this.decrementButton = this.shadowRoot.querySelector('#counter-decrement');
        this.counterValue = this.shadowRoot.querySelector('#counter-value');
 
        // 我们可以绑定事件，用类方法来响应
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
 
    // 当计数器的值发生变化时调用
    invalidate() {
        this.counterValue.innerHTML = this.counter;
    }
}
 
// 这里定义了可以在 DOM 树上直接使用的真实节点
customElements.define('counter-element', CounterElement);
```

特别注意最后一行，那里注册了可以用在 DOM 里面的 Custom Element。

#### Custom Element 的种类

上面代码展示了如何从 `HTMLElement` 接口做拓展，然而我们还可以从更具体的节点上拓展，比如 `HTMLButtonElement`。Web Component 规范提供了一个[完整的可供继承的接口列表](https://html.spec.whatwg.org/multipage/indices.html#element-interfaces)。

Custom Element 可分为两种主要类型：**独立自定义元素（Autonomous custom elements）** 和 **内置自定义元素（Customized built-in elements）**。独立自定义元素和那些早已定义且不继承自特定接口的节点类似（译者注：就是我们平常使用的 DOM 节点）。一个独立自定义元素只要在页面一定义上，就可以像常规 HTML 节点那样使用。举个例子，上面定义的计数节点，既可以在 HTML 中通过 `<counter-element></counter-element>` 定义，也可以在 JavaScript 中用 `document.createElement('counter-element')` 来创建。

内置自定义元素在使用上略有不同，当 HTML 定义节点时可以传一个 `is` 属性到标准节点上（比如 `<button is='special-button'>`），又或者使用 `document.createElement` 时传一个 `is` 属性作为参数（比如 `document.createElement("button", { is: "special-button" }`）。

#### Custom Element 的生命周期

Custom Element 也有一系列的生命周期事件，用于管理组件连接和脱离 DOM ：

*   `connectedCallback`：连接到 DOM
*   `disconnectedCallback`： 从 DOM 上脱离
*   `adoptedCallback`： 跨文档移动

一种常见错误是将 `connectedCallback` 用做一次性的初始化事件，然而实际上你每次将节点连接到 DOM 时都会被调用。取而代之的，在 `constructor` 这个 API 接口调用时做一次性初始化工作会更加合适。

此处还有一个 `attributeChangedCallback` 事件可以用来监听节点（译者注：使用 Custom Element 定义的节点）属性的变化，然后通过这个变化来更新内部状态。不过，要想用上这个能力，必须先在节点类里面定义一个名为 `observedAttributes` 的 getter：

```
constructor() {
    super();
    // ...
    this.observedAttributes();
}
 
get observedAttributes() {return ['someAttribute']; } 
// 其他方法
```

从这里起就可以通过 `attributeChangedCallback` 来处理节点属性的变化：

```
attributeChangedCallback(attributeName, oldValue, newValue) {
    if (attributeName==="someAttribute") {
        console.log(oldValue, newValue)
        // 根据属性变化做一些事情
    }
}
```

## 支持度如何？

截至 2018 年 6 月，Shadow DOM 第二版和 Custom Element 第二版在 Chrome、Safari、三星浏览器上已经支持，还[被 Firefox 列为要支持的特性](https://bugzilla.mozilla.org/show_bug.cgi?id=889230)，希望很大。而 [Edge 依然在考虑是否支持](https://developer.microsoft.com/en-us/microsoft-edge/platform/status/customelements/)。在这个时间点，[Github 仓库 webcomponents](https://github.com/webcomponents/webcomponentsjs) 上已经有了一系列的 polyfill。这些 polyfill 使得包括 IE11 在内的所有当下活跃的浏览器上都能运转 Web Component。该 webcomponents 库包含多种形态，既提供了一个包含所有必要 polyfill 的脚本（_webcomponents-bundle.js_），也提供了一个通过特性检测来只加载必要 polyfill 的版本（_webcomponents-loader.js_）。如果使用第二种，你还是必须将各个 polyfill 文件都放到服务器上来保证加载器可以加载到。

对于那些代码中只能用 ES5 的情况，还必须加载一个 _custom-elements-es5-adapter.js_ 文件，而且它必须首先加载，不能跟组件代码打包在一起。之所以需要这个适配文件是因为 Custom Element **必须** 继承自 HTMLElement 类，且构造函数中必须以 ES2015 的方式调用 `super()`（这在 ES5 代码里看起来会很困惑！）。在 IE11 中还是会由于不支持 ES2015 的类特性而抛出错误，[不过可以忽略之](https://github.com/webcomponents/webcomponentsjs/issues/900)。

## Web Component 和框架

历史上，Web Component 最大的支持者之一是 Polymer 库。Polymer 针对 Web Component API 添加了一些语法糖使得定义和传递组件变得更加容易。在最新版本 [Polymer](https://www.polymer-project.org/)3 中，它与时俱进用上了 ES2015 的模块特性并且使用 npm 作为标准的包管理工具，跟上了其他的现代框架。Web Component 编码工具的另一种形态则更像是编译器而非框架。[Stencil](https://stenciljs.com/docs/introduction/) 和 [Svelte](https://svelte.technology/guide) 这两个框架就是这样。它们使用各自的工具 API 来书写组件，然后编译成原生的 Web Component。一些框架比如 [Dojo 2,](https://dojo.io/) 则选择允许开发者编写特定框架的组件，不过也允许编译成原生 Web Component 就是了。在 Dojo2 中这是用 [@dojo/cli tools](https://github.com/dojo/cli-build-widget) 来实现的。

努力实现原生的 Web Component 的一个愿景，是希望跨越不同团队不同项目来共用组件，即使它们用的是不同的框架。当下不同的框架和 Web Component 规范有不同的关系，有些更贴近规范有些则不然。已经有一些指引告诉我们怎么在诸如 [React](https://www.sitepen.com/blog/2017/08/08/wrapping-web-components-with-react/) 和 [Angular](https://www.sitepen.com/blog/2017/09/14/using-web-components-with-angular/) 这样的框架中用上原生的 Web Component ，但它们的实现上还是带着浓浓的框架特色。有一个很好的资源可以帮你理解这些关系，那就是 Rod Dodson 的 [Custom Elements Everywhere](https://custom-elements-everywhere.com)，它通过测试用例测出不同框架想和 Custom Element（Web组件规范的核心） 结合的难易程度。

## 最后的想法

围绕 Web Component 的使用和炒作不断持续此起彼伏。这意味着，随着 Web Component 得到越来越好的支持，polyfill 将逐渐淡出我们的视野，组件书写将更加简洁和快速。Shadow DOM 允许开发者写一些简单的限定区域有效的 CSS，这无疑更加容易管理，通常性能也会更好。Custom Element 提供了一种统一的方法来定义组件，这些组件可以（理论上）跨代码库和团队来使用。目前有一些额外的规范建议，开发者可以根据基本规范加以利用：

*   [**Custom Element Registries**](https://github.com/w3c/webcomponents/issues/716) – 限制节点注册，避免节点命名冲突；
*   [**Shadow CSS Parts**](https://tabatkins.github.io/specs/css-shadow-parts/) – 组件的原生主题；
*   [**Template Instantiation**](https://github.com/w3c/webcomponents/blob/gh-pages/proposals/Template-Instantiation.md) – 使用 JavaScript 变量来快速动态应用模板；

这些补充规范可以为原生 web 平台增加更多功能，让开发者不用再去理解那么多抽象概念，释放更多的潜力。

该基本规范毫无疑问是一套强大的工具，但最终它是否能发挥最大的效用还是要取决于用到它的框架、开发者和团队。目前如 React、Vue、Angular 这样的框架已经大大占据了开发者的大脑，它们会因为这些原生态的技术和工具而逐渐败下阵来吗？只能让时间来见证了。

* * *

## 下一步

你是否希望在你的下一个项目或框架中用上 Web Component？[联系我们](https://www.sitepen.com/site/contact.html)，探讨下我们可以怎么帮到你！

在 [SitePen On-Demand Development](https://www.sitepen.com/support/index.html) 可以获取帮助，它有我们对 JavaScript 和 TypeScript 大大小小问题的快速有效解决方案。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
