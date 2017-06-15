> * 原文地址：[A Unified Styling Language](https://medium.com/seek-blog/a-unified-styling-language-d0c208de2660)
> * 原文作者：[Mark Dalgleish](https://medium.com/@markdalgleish)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# A Unified Styling Language

在过去几年中，我们见证了  [CSS-in-JS](https://github.com/MicheleBertoli/css-in-js) 的兴起，尤其是在 [React](https://facebook.github.io/react) 社区。当然，它也饱含争议。很多人，尤其是哪些已经对 CSS 非常熟悉的人都表示难以置信

> "为什么有人要在 JS 中写 CSS？

> 这简直是一个可怕的想法！

> 除非他们没学过 CSS"

如果这就是你的反应，那么请继续读下去。我们来看看为什么在 JavaScript 中编写样式不是一个可怕的想法，以及为什么我认为你应该关注这个快速发展的领域。

![](https://cdn-images-1.medium.com/max/2000/1*Ipu5Grtzr21suPiTfvGXaw.png)

### 对社区的误解

React 社区经常被 CSS 社区误解，反之亦然。对我来说这很有趣，因为我经常被卷入这两个世界的纷争。

我从九十年代后期开始学习 HTML，并且从基于表格布局的黑暗时代以来就一直使用 CSS。受 [CSS Zen Garden](http://www.csszengarden.com) 启发，我是最早一批将现有代码向 [语义化标签](https://en.wikipedia.org/wiki/Semantic_HTML) 和级联样式表迁移的人。不久之后，我开始专注于前后端分离，使用[非侵入式 JavaScript](https://www.w3.org/wiki/The_principles_of_unobtrusive_JavaScript) 和客户端的交互来装饰服务端渲染的 HTML。围绕这些做法有一个小型且充满活力的社区，并且我们成为第一代尝试给浏览器平台应有尊重的前端开发者。

伴随这样的背景，你可能会认为我会强烈反对 React 的 [_HTML-in-JS_](https://facebook.github.io/react/docs/jsx-in-depth.html) 模式，它似乎违背了我们所坚持的原则，但实际上恰恰相反。根据我的经验，React 的组件模型加上服务端渲染的能力，最终给我们提供了一种构建大规模复杂单页应用的方式，从而使我们能够将快速，可访问，逐渐增强的应用推送给我们的用户。我们甚至在 [SEEK](https://www.seek.com.au) 上利用这种能力，这是我们的旗舰产品，它是单页 React 应用程序，当 JavaScript 被禁用时我们的核心搜索流程依然可用，因为我们通过在服务器端运行相同的 JavaScript 代码来正常降级到传统的网站。

所以，也请考虑一下这个从一个社区到另一个社区的橄榄枝。让我们一起尝试理解这个转变。它可能不完美，它可能不是你计划在产品中使用的东西，它可能对你不是很有说服力，但是至少值得你尝试思考一下。

### 为什么使用 CSS-in-JS?

如果你熟悉我最近做的与 React 以及 [CSS 模块](https://github.com/css-modules/css-modules)相关的工作，当看到我维护 CSS-in-JS 时你可能会很惊讶。

![](https://cdn-images-1.medium.com/max/1600/1*RtAMWbxdwW2ujyrurU9plw.png)

毕竟，通常是那些希望有局部样式但是又不希望在 JS 中写 CSS 的开发者会选择使用 CSS 模块。事实上，甚至我自己在工作中也还没用到 CSS-in-JS。

尽管如此，我任然对 CSS-in-JS 社区保持浓厚的兴趣，密切关注他们不断提出的创意。不仅如此，**我认为更广泛的 CSS 社区对它也应该很感兴趣**

原因是什么呢?

为了更清楚地了解为什么人们选择在 JavaScript 中编写他们的样式，我们将重点关注采用这种方式时带来的实际好处。

我把它分为五个方面:

1.  局部样式
2.  Critical CSS
3.  Smarter optimisations
4.  打包管理
5.  Non-browser styling

Let’s break this down further and have a closer look at what CSS-in-JS brings to the table for each of these points.
让我们进一步的细分并且仔细看看 CSS-in-JS

### 1.

#### **局部样式**

在大规模项目中想要高效的构建 CSS 是非常困难的。当加入一个现有的长期运行的项目时，通常我们会发现 CSS 是系统中最复杂的部分。

为了解决这个问题，CSS 社区已经投入了巨大的努力，通过 [Nicole Sullivan](https://twitter.com/stubbornella) 的 [OOCSS](https://github.com/stubbornella/oocss/wiki) 和 [Jonathan Snook](https://twitter.com/snookca) 的 [SMACSS](https://smacss.com/) 都可以使我们的样式更好维护，但是[Yandex](https://github.com/yandex) 开发的 [BEM](http://getbem.com) 更流行一些。

Ultimately, BEM (when applied purely to CSS) is just a naming convention, opting to limit styles to classes following a `.Block__element--modifier` pattern. In any given BEM-styled codebase, developers have to remember to follow BEM’s rules at all times. When strictly followed, BEM works really well, but why is something as fundamental as scoping left up to pure _convention?_
根本上来说，BEM （纯粹用于 CSS）只是一个命名约定，它要求样式的类名要遵守 `.Block__element--modifier` 的模式。在任何给定 BEM 风格的代码库中，开发人员必须始终遵守 BEM 的规则。当严格遵守时，BEM 的效果很好，但是为什么这些基础的功能只是用单纯的**命名约定**来限制呢？

无论是否有明确表示，大多数 CSS-in-JS 类库都遵循 BEM 的思路，它们尝试将样式定位到单个 UI 组件，只不过用了完全不同的实现方式。


那么在实际编写代码时时什么样的呢？当使用 [Sunil Pai](https://twitter.com/threepointone) 开发的 [glamor](https://github.com/threepointone/glamor) 时，代码看起来像下面这样：

```
import { css } from 'glamor'
const title = css({
  fontSize: '1.8em',
  fontFamily: 'Comic Sans MS',
  color: 'blue'
})
console.log(title)
// → 'css-1pyvz'
```

你可能会注意到**代码中没有 CSS 的类名**。因为它不再是对系统中其他位置定义的 class 的硬编码引用，而是由我们的库自动生成的。我们不必再担心全局作用域内的选择器冲突，这也意味着我们不再需要替他们添加前缀了。

The scoping of this selector matches the scoping rules of the surrounding code. If you want to make this rule available to the rest of your application, you’ll need to turn it into a JavaScript module and import it wherever it’s used. In terms of keeping our codebases maintainable over time, this is incredibly powerful, _making sure that the source of any given style can be easily traced like any other code._
这个选择器的作用域与周围代码的作用域一致。如果你希望在你应用的其他地方使用这个规则，你就需要将它改写成一个 JavaScript 模块并且在需要使用的地方引用它。就保持代码库的可维护性而言，它是非常强大的，**它确保了任何给定的样式都可以像其他代码一样容易追踪来源**。

**通过从仅仅是命名约定到默认强制局部样式的转变，我们已经提高了我们样式的基本质量。BEM is baked in, not opt-in。**

—

在继续之前，我要说明至关重要的一点。

**它生成的是真正的 CSS，而不是内联样式**

大多数早期的 CSS-in-JS 库都是将样式直接添加到每个元素上，但是这个模式有个严重的缺点，'styles' 属性并不能做到 CSS 可以做到的每件事。大多数新的库不再关注于**动态样式表**，而是在运行时从全局样式中插入和删除规则。

举个例子，让我们看看 [Oleg Slobodskoi](https://twitter.com/oleg008) 开发的 [JSS](https://github.com/cssinjs/jss)，这是最早的 CSS-in-JS 库之一，并且它生成的是**真实的 CSS**。

![](https://cdn-images-1.medium.com/max/1600/1*ltBvwbyvBt8OMdGZQOdMDA.png)


当使用 JSS 时，你可以使用标准的 CSS 特性，比如 hover 和媒体查询，它们会映射到相应的 CSS 规则。

```
const styles = {
  button: {
    padding: '10px',
    '&:hover': {
      background: 'blue'
    }
  },
  '@media (min-width: 1024px)': {
    button: {
      padding: '20px'
    }
  }
}
```

一旦你将这些样式插入到文档中，你就可以使用哪些自动生成的类名。

```
const { classes } = jss.createStyleSheet(styles).attach()
```

无论你是使用一个完整的框架，还是简单的使用 **innerHTML**，你都可以在 JavaScript 中使用这些生成的 class，而不是硬编码的 class 字符串。

```
document.body.innerHTML = `
  <h1 class="${classes.heading}">Hello World!</h1>
`
```

单独使用这种方式管理样式并没有多大的优势，它通常和一些组件库搭配使用。因此，通常可以找到用于最流行库的绑定方案。例如，JSS 可以通过 [react-jss](https://github.com/cssinjs/react-jss) 的帮助轻松地绑定到 React 组件上，在管理全局生命周期的同时，它可以帮你给每个组件插入一小段样式。

```
import injectSheet from 'react-jss'
const Button = ({ classes, children }) => (
  <button className={classes.button}>
    <span className={classes.label}>
      {children}
    </span>
  </button>
)
export default injectSheet(styles)(Button)
```

通过将我们的样式集中到组件上，可以将他们更紧密得集成到代码层面上，we’re effectively taking BEM to its logical conclusion。所以 CSS-in-JS 社区的很多人觉得在所有的样式绑定样板中，提取、命名和复用组件都是不存在的。

随着 [Glen Maddern](https://twitter.com/glenmaddern) 和 [Max Stoiber](https://twitter.com/mxstbr) 提出了 [styled-components](https://github.com/styled-components/styled-components) 的概念，出现了一个新的思考这个问题的方式。

![](https://cdn-images-1.medium.com/max/1600/1*l4nfMFKxfT4yNTWUK2Vsdg.png)


我们直接创建组件，而不是创建样式然后手动地将他们绑定到组件上。

```
import styled from 'styled-components'

const Title = styled.h1`
  font-family: Comic Sans MS;
  color: blue;
`
```

应用这些样式时，我们不会将 class 添加到存在的元素上，而是简单地渲染生成的组件。

```
<Title>Hello World!</Title>
```

虽然 styled-components 通过模板文字的语法使用了传统的 CSS 语法，但是有人更喜欢使用数据结构。来自 [PayPal](https://github.com/paypal) 的 [Kent C. Dodds](https://twitter.com/kentcdodds) 开发的 [Glamorous](https://github.com/paypal/glamorous) 是一个值得关注的替代方案

![](https://cdn-images-1.medium.com/max/1600/1*Ere9GQTIJeNac2ONfZlfdw.png)

Glamorous 和 styled-components 一样提供了组件优先的 API，但是选择了**对象**而不是**字符串**，这样就无需在库中引入一个 CSS 解析器，这样可以降低库的大小并提高性能。

```
import glamorous from 'glamorous'

const Title = glamorous.h1({
  fontFamily: 'Comic Sans MS',
  color: 'blue'
})
```

无论你使用什么语法描述你的样式，他们不再仅仅是组件的**一部分**，他们和组件已经无法分离。当使用一个像 React 的库时，组件是基本构建块，并且现在我们的样式构建了这个架构的核心部分。**如果我们将我们应用程序中的所有内容都描述为组件，那么为什么我们的样式不行呢？**

—

考虑到我们之前介绍的对系统做出改变的意义，对于那些有丰富的 BEM 经验的开发人员来说，这一切看起来似乎是一个很小的提升。事实上，CSS 模块让你在不用放弃 CSS 工具生态系统的同时获得了这些提升。很多项目坚持使用 CSS 模块还有一个原因，他们发现 CSS 模块充分解决了编写大规模 CSS 的问题，并且可以保持编写常规 CSS 时的习惯。

然而，当我们开始在这些基本概念上构建时，事情开始变得更有趣。

### 2.

#### 关键 CSS

在文档头部内联关键样式已经成为一种比较新的最佳实践，通过仅提供当前页面所需的样式可以提高首屏时间。这与我们常用的样式加载方式形成鲜明对比，我们常常强制浏览器在渲染之前为应用下载所有可能的视觉风格。

虽然有工具可以用于提取和内联关键 CSS，比如 [Addy Osmani](https://twitter.com/addyosmani) 的 [critical](https://github.com/addyosmani/critical)，但是他们不能从根本上改变关键 CSS 难以维护和自动化的事实。这是一个棘手的，非必选的性能优化，所以大部分项目似乎放弃了这一步。

CSS-in-JS 是一个完全不同的故事。

当使用服务端渲染的应用时，提取关键 CSS 不仅仅是一个优化，从根本上来说，服务器端的 CSS-in-JS 是**使用**关键 CSS 的首要工作。

举个例子，当使用 [Khan Academy](https://github.com/Khan) 开发的 [Aphrodite](https://github.com/Khan/aphrodite) 时，一旦给元素添加 class，就可以内联调用它的 `css` 函数来跟踪在单个渲染过程中使用的样式。

```
import { StyleSheet, css } from 'aphrodite'
const styles = StyleSheet.create({
  title: { ... }
})
const Heading = ({ children }) => (
  <h1 className={css(styles.heading)}>{ children }</h1>
)
```

即便你所有的样式都是在 JavaScript 中定义的，你也可以很轻松的从当前页面中提取所有的样式并生成一个 CSS 字符串，当执行服务端渲染时将它们插入文档的头部。

```
import { StyleSheetServer } from 'aphrodite';

const { html, css } = StyleSheetServer.renderStatic(() => {
  return ReactDOMServer.renderToString(<App/>);
});
```

你可以像这样渲染你的关键 CSS：

```
const criticalCSS = `
  <style data-aphrodite>
    ${css.content}
  </style>
`;
```

如果你看过 React 的服务端渲染模型，你可能会发现这是一个非常熟悉的模式。在 React 中，你的组件在 JavaScript 中定义他们的标记，但可以在服务器端渲染成常规的 HTML 字符串。

**尽管是完全用 JavaScript 编写，如果你要以渐进增强的方式构建你的应用程序，那么就没必要在客户端一次性加载全部的 JavaScript**

Either way, the client-side JavaScript bundle includes the code needed to boot up your single-page app, suddenly bringing it to life, rendering in the browser from that point forward.
无论哪种方式，客户端 JavaScript 代码块都要包含启动单页应用程序所需的代码，

由于在服务器上渲染 HTML 和 CSS 是同时进行的，就像前面的例子所示， Aphrodite 这样的库通常会以一个函数调用的方式帮助我们流式生成关键 CSS 和服务端渲染的 HTML。现在，我们可以用类似的方式将我们的 React 组件渲染成静态 HTML。

```
const appHtml = `
  <div id="root">
    ${html}
  </div>
`
```

通过在服务器端使用 CSS-in-JS，我们的单页应用不仅可以脱离 JavaScript 工作，**它甚至可以加载的更快**。

**_As with the scoping of our selectors, the best practice of rendering critical CSS is now baked in, not opt-in._**

### 3.

#### 更智能的优化

我们最近看到了构建 CSS 的新方式的兴起，比如 [Yahoo](https://github.com/yahoo) 的 [Atomic CSS](https://acss.io/) 和 [Adam Morse](https://twitter.com/mrmrs_) 的 [Tachyons](http://tachyons.io/)，它们通过使用精简的，单一用途的类名而避免了语义化类名。举个例子，当使用 Atomic CSS 时，你使用类似于函数的语法提供类名，并且它会生成一个合适的样式表。

```
<div class="Bgc(#0280ae.5) C(#fff) P(20px)">
  Atomic CSS
</div>
```

The goal is to keep your CSS bundle as lean as possible by maximising the re-usability of classes, effectively treating classes like inline styles. While it’s easy to appreciate the reduction in file size, the impacts to both your codebase and your fellow team members are anything but insignificant. These optimisations, by their very nature, involve changes to both your CSS _and_ your markup, making them a more significant architectural effort.
通过最大程度地提高类的复用性以及有效处理内联样式的类名，可以达到尽可能地精简 CSS 的目的。虽然很容易理解文件大小的减少，但对于你的代码库和团队成员的影响确实是微乎其微的。这些优化涉及你的 CSS 和标记语言的变化，是他们成为更重要的构建工作。

正如我们已经介绍过的，当使用 CSS-in-JS 或者 CSS 模块时，你不再需要在 HTML 中硬编码你的类名，而是动态引用由库或者构建工具自动生成的 JavaScript 值。

我们这样写样式:

```
<aside className={styles.sidebar} />
```

而不是:

```
<aside className="sidebar" />
```


This may look like a fairly superficial change, but this is a monumental shift in how we manage the relationship between our markup and our styles. By giving our CSS tooling the ability to alter not just our styles, _but the final classes we apply to our elements,_ we unlock an entirely new class of optimisations for our style sheets.
这可能看起来是一个相当肤浅的变化，但这是我们如何管理我们的标记语言和样式之间关系的巨大改变。我们为我们的样式表解锁了一个全新的优化。

如果我们看看上面的例子，会发现 'styles.sidebar' 对应了一个字符串，但没有限制到什么样的类。就我们所知，它可以很容易的对应一个或者十几个类的字符串。

```
<aside className={styles.sidebar} />
// Could easily resolve to this:
<aside className={'class1 class2 class3 class4'} />
```

如果我们可以优化我们的样式，为每一套样式生成多个类，我们就可以做一些非常有趣的事

我最喜欢的例子是 [Ryan Tsao](https://twitter.com/rtsao) 编写的 [Styletron](https://github.com/rtsao/styletron)

![](https://cdn-images-1.medium.com/max/1600/1*7xxb6FOmcmPCnQNrFy5pjg.png)

In the same way that CSS-in-JS and CSS Modules automate the process of adding BEM-style class prefixes, Styletron does the same thing to the Atomic CSS mindset.
与 CSS-in-JS 和 CSS 模块

The core API is focused around a single task—defining individual CSS rules for each combination of property, value and media query, which then returns an automatically generated class.

```
import styletron from 'styletron';
styletron.injectDeclaration({
  prop: 'color',
  val: 'red',
  media: '(min-width: 800px)'
});
// → 'a'
```

Of course, Styletron provides higher level APIs, such as its `injectStyle` function which allows multiple rules to be defined at once.

```
import { injectStyle } from 'styletron-utils';
injectStyle(styletron, {
  color: 'red',
  display: 'inline-block'
});
// → 'a d'
injectStyle(styletron, {
  color: 'red',
  fontSize: '1.6em'
});
// → 'a e'
```

Take special note of the commonality between the two sets of class names generated above.

**_By relinquishing low-level control over the classes themselves, only defining the desired set of styles, we allow the library to generate the optimal set of atomic classes on our behalf._**

![](https://cdn-images-1.medium.com/max/1600/1*pWXr1A6uhiOkYHqwfBMtWg.png)

Optimisations that are typically done by hand—finding the most efficient way to split up our styles into reusable classes—can now be completely automated. You might be starting to notice a trend here. **_Atomic CSS is baked in, not opt-in._**

### 4.

#### 包管理

在谈论这一点之前，我们先停下来问自己一个看似简单的问题。

**我们如何分享 CSS？**

我们已经从手动下载 CSS 文件向使用特定的前端包管理工具转变，比如 [Bower](https://bower.io)，或者现在通过 [npm](https://www.npmjs.com/) 可以使用 [Browserify](http://browserify.org/) 和 [webpack](https://webpack.js.org)。虽然这些工具已经自动处理外部包的 CSS 依赖，但是前端社区大多还是手工处理 CSS 的依赖关系。

无论使用哪种方式，CSS 之间的依赖都不是很好处理。

As many of you might remember, we’ve seen a similar effect with _JavaScript modules_ between Bower and npm.
你们中的很多人可能还记得，我们已经看到与 Bower 和 npm 之间的 **JavaScript 模块**类似的效果。

Bower 没有依赖任何特定的模块格式，而发布到 npm 的模块使用 [CommonJS 模块格式](http://wiki.commonjs.org/wiki/Modules/1.1)。这对发布到每个平台的包的数量产生了巨大的影响。

小型但是有复杂依赖关系的模块更愿意使用 npm，Bower 则吸引了大量大型而独立的模块。当然，你可能只有两三个插件，但是由于你没有一个模块系统来管理你的依赖，每个模块就无法轻易地利用它自己的依赖关系，因此就只能靠开发者手动构建。

As a result, the number of packages on npm over time forms an exponential curve, while Bower only had a fairly linear increase of packages. While there are certainly a variety of reasons for this differentiation, it’s fair to say that a _lot_ of it has to do with the way each platform allows (or doesn’t allow) packages to depend on each other at runtime.
因此，随着时间的退推移，npm 上的包的数量呈指数性增长，而 Bower 只能是有限的线性增长。虽然这可能是各种原因导致的，但是不得不说，它与许多平台允许（或不允许）包再运行时彼此依赖的方式有很大关系

![](https://cdn-images-1.medium.com/max/1600/1*LTrsIISPV5qK-qAQKaeINA.png)

不幸的是，这对于 CSS 社区来说太熟悉了，我们发现相对于 npm 上的 JavaScript 来说，独立 CSS 模块的数量也增长的很慢。

如果我们也想实现 npm 的指数增长该怎么做？如果我们想依赖不同大小不同层次的复杂模块，而不是专注于大型，全面的框架呢？为了做到这一点，我们不仅需要一个包管理器，还需要一个合适的模块格式。

这是否意味着我们需要专门为 CSS 或者 Sass 和 Less 这样的预处理器设计一个包管理工具？

What’s really interesting is that we’ve already gone through a similar realisation with HTML. If you ask the same questions about how we share _markup_ with each other, you’ll quickly notice that we almost never share raw HTML directly—we share _HTML-in-JS._
真正有趣的是，在 HTML 上我们已经实现了类似的功能。

We do this via [jQuery plugins](https://plugins.jquery.com/), [Angular directives](http://ngmodules.org) and [React components](https://react.parts/web). We compose large components out of smaller components, each with their own HTML, each published independently to npm. HTML as a format might not be powerful enough to allow this, but by _embedding HTML within a fully-fledged programming language,_ we’re easily able to work around this limitation.
我们通过 [jQuery 插件](https://plugins.jquery.com/)，[Angular 指令](http://ngmodules.org) 和 [React 组件](https://react.parts/web)实现了这个功能。我们将大的组件拆分成较小的组件，每个组件都有自己的 HTML，并将它们独立的发布到 npm 上。HTML 这种格式可能不足以强大到完成这个功能，但是**通过将 HTML 嵌入到完整的编程语言中**，我们就可以很轻松的越过这个限制

如果我们像 HTML 一样通过 JavaScript 来共享和生成 CSS 呢？比如使用**函数返回对象和字符串**而不使用 [mixins](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#mixins) ？又或者我们利用  [_Object.assign_](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) 和新的 [object spread operator](https://github.com/tc39/proposal-object-rest-spread) 操作符来**简单地 merge 对象**而不是用 [extending classes](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#extend) 呢？

```
const styles = {
  ...rules,
  ...moreRules,
  fontFamily: 'Comic Sans MS',
  color: 'blue'
}
```

Once we start writing our styles this way, we can now compose and share our styling code like any other code in our application, using the same patterns, the same tooling, the same infrastructure, _the same ecosystem._
一旦我们开始用这种方式编写我们的样式，我们就可以使用相同的模式，相同的工具，相同的基础架构，相同的生态系统来和生成我们的样式代码，就像我们应用程序中的其他任何代码一样。

由 [Max Stoiber](https://twitter.com/mxstbr)、[Nik Graf](https://twitter.com/nikgraf) 和 [Brian Hough](https://twitter.com/b_hough) 开发的 [Polished](https://github.com/styled-components/polished) 就是一个很好的例子。 

![](https://cdn-images-1.medium.com/max/1600/1*fczf3OWmmKBkFgtUqZnq2g.png)

Polished 就像是 CSS-in-JS 界的 [Lodash](https://lodash.com)，它提供了一整套完整的 mixins，颜色函数等等，使得在 JavaScript 可以得到使用 [Sass](http://sass-lang.com) 编写样式的体验。最关键的区别则在于这些代码现在是可以复用，测试和分享的，并且能够使用完整的 JavaScript 包生态系统

So, when it comes to CSS, how do we achieve the same level of open source activity seen across npm as a whole, composing large collections of styles from small, reusable, open-source packages? Strangely enough, we might finally achieve this by embedding our CSS within another language and completely embracing JavaScript modules.
那么，当谈到 CSS 时，我们如何获得

### 5.

#### Non-browser styling

到目前为止，我的文章已经涵盖了所有的要点，在 JavaScript 中编写 CSS 肯定容易的多，但是常规的 CSS 并不是完不成这些功能。这也是我把最有趣，最面向未来的一点留到现在的原因。这一点并不一定在如今的 CSS-in-JS 社区中发挥巨大的作用，但它可能成为未来设计的基础层面。它不仅会影响开发人员，也会影响设计师，最终它将改变这两个领域相互沟通的方式。

首先，为了介绍它，我们需要先简单介绍一下 React。

—

React 的理念是用组件作为最终渲染的中间层。在浏览器中工作时，我们构建复杂的虚拟 DOM 树而不是直接操作 DOM 元素。

有趣的是，DOM渲染相关的代码并不属于 React 的核心部分，而是由 **react-dom** 提供的。

```
import { render } from 'react-dom'
```

尽管最初 React 是为 DOM 设计的，并且大部分情况下还是在浏览器中使用，但是这种模式也允许 React 通过引入新的渲染器来适配不同的环境。

JSX 不仅仅可以用于虚拟 DOM，他可以用在任何的虚拟视图上。

This is what allows [Reac Native](https://facebook.github.io/react-native) to work, writing truly native applications in JavaScript, by writing components that render virtual representations of their native counterparts. Instead of _div_ and _span_, we have _View_ and _Text._
这就是 [React Native](https://facebook.github.io/react-native) 的工作原理，我们通过编写那些渲染成 native 组件以实现写用 JavaScript 编写真正的 native 应用，通过编写那些渲染成的组件，比如我们用 **View** 和 **Text** 取代了 **div** 和 **span**。

从 CSS 的角度来看，React 最有趣的就是它拥有自己的 [StyleSheet API](https://facebook.github.io/react-native/docs/stylesheet.html)。

```
var styles = StyleSheet.create({
  container: {
    borderRadius: 4,
    borderWidth: 0.5,
    borderColor: '#d6d7da',
  },
  title: {
    fontSize: 19,
    fontWeight: 'bold',
  },
  activeTitle: {
    color: 'red',
  }
})
```


在这里你会看到一组熟悉的样式，我们编写了颜色，字体和边框样式。

这些规则都非常简单，并且很容易映射到大部分的 UI 环境上，但是当涉及到 native 布局时，事情就变得非常有趣了。

```
var styles = StyleSheet.create({
  container: {
    display: 'flex'
  }
})
```


因为在浏览器环境之外，所以 **React Native 有自己的 [flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes) 实现**

最初发布时他是一个名为 [css-layout](https://www.npmjs.com/package/css-layout) 的JavaScript 模块，完全用 JavaScript 重新实现了 flexbox（有充分的测试），为了更好的可移植性它现在已经迁移到 C 语言。

Given the scope and importance of the project, it’s been given a more significant brand of its own in the form of [Yoga](https://facebook.github.io/yoga).
鉴于这个项目的影响力和重要性，它以被赋予了更重要的品牌 ——— [Yoga](https://facebook.github.io/yoga)。

![](https://cdn-images-1.medium.com/max/1600/1*mv_hHmbOgU7SOd5t2J2Q2g.png)

Even though Yoga is all about porting CSS concepts to non-browser environments, the potentially unmanageable scope has been reigned in by focusing on only a subset of CSS features.
虽然 Yoga 是专注于将 CSS 迁移到非浏览器环境的，但是仅关注与 CSS 特性的一个子集无法

> "Yoga 的重点是成为一个有表现力的布局框架，而不是实现各种各样的 CSS"

These sorts of tradeoffs may seem limiting, but when you look at the history of CSS architecture, it’s clear that _working with CSS at scale is all about picking a reasonable subset of the language._

在 Yoga 中，为了控制样式的作用域，他们避开了级联样式，并且将布局引擎完全集中在 flexbox 上。虽然这样会丧失很多功能，但它也为需要嵌入样式的跨平台组件创造了惊人的机会，我们已经看到几个试图利用这个特性的开源项目。

[Nicolas Gallagher](https://twitter.com/necolas) 开发的 [React Native for Web](https://github.com/necolas/react-native-web) 旨在成为 react-native 的一个替代品。当使用 webpack 这类打包工具时，很容易用别名来替换第三方库。

```
module: {
  alias: {
    'react-native': 'react-native-web'
  }
}
```

使用 React Native for Web 后可以在浏览器环境中运行 React Native 组件，包括 [React Native 样式 API](https://facebook.github.io/react-native/docs/stylesheet.html)

同样，[Leland Richardson](https://twitter.com/intelligibabble) 开发的 [react-primitives](https://github.com/lelandrichardson/react-primitives) 也提供了一套跨平台的原始组件，它可以抽象目标平台的实现细节，为跨平台组件创造可行的标准。

甚至 [微软](https://github.com/Microsoft) 也开始引进 [ReactXP](https://microsoft.github.io/reactxp)，这个库旨在简化跨 web 和 native 的工作流，它也有自己的[跨平台样式实现](https://microsoft.github.io/reactxp/docs/styles.html)
—

Even if you don’t write software for native applications, it’s important to note that having a truly cross-platform component abstraction allows us to target an effectively limitless set of environments, sometimes in ways that you might never have predicted.
即使你不编写 native 应用程序，拥有一个真正的跨平台组件抽象也是非常重要的，它能帮我们有针对性地，有事甚至是以一种你无法预测的方式来做到的

我所见过的最令人震惊的例子是 [Airbnb](https://github.com/airbnb) 的 [Jon Gold](https://twitter.com/jongold) 开发的 [react-sketchapp](http://airbnb.io/react-sketchapp)。

![](https://cdn-images-1.medium.com/max/1600/1*qfskIhHAWpYwfR5Lz0_cIA.png)

我们很多人都花费了大量时间去尝试标准化我们的设计语言，并且尽可能的避免系统中的重复。不幸的是，尽管我们希望样式只有一个来源，但似乎我们最多只能减少到两个，**开发人员的动态样式以及设计师的静态样式**。虽然这已经比我们之前的模式好了很多，但是它仍然需要我们手工的将样式从 [Sketch](https://www.sketchapp.com) 这样的设计工具上同步到代码里。这也是 react-sketchapp 被开发出来的原因。

感谢 Sketch 的 [JavaScript API](http://developer.sketchapp.com/reference/api)，以及 React 连接到不同渲染引擎的能力，react-sketchapp 让我们可以用跨平台的 React 组件渲染我们的 Sketch 文件。

![](https://cdn-images-1.medium.com/max/1600/1*v2L1DB8OS38GScyBRFD8hQ.png)

Needless to say, this has the potential to massively shake up how designers and developers collaborate. Now, when we refer to the same components while iterating on our designs, we can potentially be referring to the same _implementation_ too, regardless of whether we’re working with tools for designers or developers.
不用说，这有很大的可能会改变设计师和开发人员的合作方式。现在，当我们在对设计进行迭代时，我们可以使用相同的实现，无论我们是在使用设计工具还是开发者工具

通过 [Sketch 中的符号](https://www.sketchapp.com/learn/documentation/symbols)和[ React 中的组件](https://facebook.github.io/react/docs/components-and-props.html)，我们的行业已经从本质上开始趋于抽象，并且我们通过使用相同的工具可以更紧密的协作。


这么多新的尝试都来自 React 和其周边的社区，看来这并不是巧合。

在组件架构中，最重要的是将组件的集中在一起。这自然就包括它的局部样式，往更复杂的方向延伸就涉及到数据的获取。这里要感谢 [Relay](https://facebook.github.io/relay) 和 [Apollo](http://dev.apollodata.com)，因为我们只了解了皮毛，但是他们帮我们解决了很多复杂的问题。

While this has a huge impact on the way we style our applications, it has an equally large effect on everything else in our architecture—but for good reason.
虽然这对我们产生了很大的影响，但是它对我们架构里的其他一切都有很大的影响，当然，是出于好的理由

By unifying our model around components written in a single language, we have the potential to better separate our concerns—not by technology, but by _functionality._ Scoping everything around the unit of a component, scaling large yet maintainable systems from them, optimised in ways that weren’t possible before, sharing our work with each other more easily and composing large applications out of small open-source building blocks. Most importantly, we can do all of this without breaking progressive enhancement, without giving up on the principles that many of us see as a non-negotiable part of taking the web platform seriously.
通过使用单一语言

Most of all, I’m excited about the potential of components written in a single language to form the basis of _a new, unified styling language_—one that unites the front-end community in ways we’ve never seen before.
最重要的是，我对使用单一语言编写的组件的潜力感到兴奋，

在 SEEK，我们正在努力利用这一功能，我们围绕组件模型来构建在线样式指南，其中语义化，交互性和视觉风格都有统一的抽象。这形成了开发人员和设计师之间共享的通用设计语言。

As much as possible, building a page should be as simple as combining an opinionated set of components that ensure our work stays on brand, while allowing us to upgrade our design language long after we’ve shipped to production.
构建一个页面应该尽可能的简单

```
import {
  PageBlock,
  Card,
  Text
} from 'seek-style-guide/react'
const App = () => (
  <PageBlock>
    <Card>
      <Text heading>Hello World!</Text>
    </Card>
  </PageBlock>
)
```

Even though our style guide is currently built with React, webpack and CSS Modules, the architecture exactly mirrors what you’d find in any system built with CSS-in-JS. The technology choices may differ, but the mindset is the same.

However, these technology choices will likely need to shift in unexpected ways in the future, which is why keeping an eye on this space is so critical to the ongoing development of our component ecosystem. We may not be using CSS-in-JS today, but it’s quite possible that a compelling reason to switch could arise sooner than we think.
然而，未来这些技术选型可能会以一种意想不到的方式进行转变，这就是为什么要关注。我们现在可能不会用 CSS-in-JS 这项技术，但是很可能没过多久就会出现一个令人信服的理由让我们使用它。

在这段时间里，CSS-in-JS 已经给我们带来了很多惊喜，但更重要的是，它只是这个宏伟蓝图的开始。

它还有很大的改进空间，并且它的创新还没有停止的迹象。新的库正不断涌现，它们解决了未来会出现的问题并且提升了开发人员的体验 —— 比如性能的提升，在构建时抽取静态 CSS，支持 CSS 变量以及降低了前端开发人员的入门门槛。

This is where the CSS community comes in. Despite all of these massive alterations to our workflow, **_none of this changes the fact that you still need to know CSS._**

We may express it with different syntax, we may architect our apps in different ways, but the fundamental building blocks of CSS aren’t going away. Equally, our industry’s move towards component architectures is inevitable, and the desire to reimagine the front-end through this lens is only getting stronger. There is a very real need for us to work together, to ensure our solutions are widely applicable to developers of all backgrounds, whether design-focused, engineering-focused, or both.
我们可能使用不同的语法，也可能以不同的方式构建我们的应用，但是 CSS 的基本构建块不会消失。同样，我们行业向组件架构的转变是不可避免的，通过这种方式重新设计前端的意愿只会越来越强烈。我们非常需要合作来

虽然有时我们的观点不一致，但是 CSS 和 JS 社区对于改进前端，认真对待 Web 平台以及改进我们下一代 web 开发流程都有很大的激情。社区的潜力是巨大的，而且尽管到目前为止我们已经解决了大量的问题，但还有很多工作要做。

At this point, you still might not be convinced, and that’s totally okay. It’s completely reasonable to find CSS-in-JS to be ill-fitting for your work _right now,_ but my hope is that it’s for the _right reasons,_ rather than superficial objections to mere _syntax._


无论如何，未来几年这种编写样式的风格可能会越来越流行，并且值得关注的是它发展的非常快。我衷心希望你可以加入我们，无论是通过贡献代码还是**简单的参与我们的对话讨论**，都能让下一代 CSS 工具尽可能的提高前端开发人员的工作效率。


这篇文章是我在德国柏林参加 CSSconf EU 2017 做相同主题演讲时撰写的，并且现在可以在 [YouTube](https://www.youtube.com/watch?v=X_uTCnaRe94) 上看到相关视频。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


