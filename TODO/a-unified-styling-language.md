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

Since rendering your HTML and CSS on the server happen at the same time, libraries like Aphrodite often help us streamline the generation of both critical CSS _and_ server-rendered HTML into a single call, as we saw in the previous example. This now allows us to render our React components to static HTML in a similar fashion.
由于在服务器上渲染 HTML 和 CSS 是同时的，像 Aphrodite 这样的库通常会帮助我们。现在，我们可以用类似的方式将我们的 React 组件渲染成静态 HTML。

```
const appHtml = `
  <div id="root">
    ${html}
  </div>
`
```

By using CSS-in-JS on the server, not only does our single-page app continue to work without JavaScript, _it might even render faster too._
通过在服务器端使用 CSS-in-JS，

**_As with the scoping of our selectors, the best practice of rendering critical CSS is now baked in, not opt-in._**

### 3.

#### 更智能的优化

We’ve recently seen the rise of new ways of structuring our CSS—like [Atomic CSS](https://acss.io/) from [Yahoo](https://github.com/yahoo) and [Tachyons](http://tachyons.io/) by [Adam Morse](https://twitter.com/mrmrs_)—that eschew “semantic classes” in favour of tiny, single-purpose classes. For example, when using Atomic CSS, you apply classes with a function-like syntax which can then be used to generate an appropriate style sheet.
我们最近看到了构建 CSS 的新方式的兴起，比如 [Yahoo](https://github.com/yahoo) 的 [Atomic CSS](https://acss.io/) 和 [Adam Morse](https://twitter.com/mrmrs_) 的 [Tachyons](http://tachyons.io/)，它们避免了语义化类名，有利于小的，单一用途的类名。举个例子，当使用  Atomic CSS 时，你使用类似于函数的语法提供 class，然后可以使用它生成

```
<div class="Bgc(#0280ae.5) C(#fff) P(20px)">
  Atomic CSS
</div>
```

The goal is to keep your CSS bundle as lean as possible by maximising the re-usability of classes, effectively treating classes like inline styles. While it’s easy to appreciate the reduction in file size, the impacts to both your codebase and your fellow team members are anything but insignificant. These optimisations, by their very nature, involve changes to both your CSS _and_ your markup, making them a more significant architectural effort.
这么做的目的是通过最大程度地提高类的复用性和有效处理相似内联样式的类来尽可能地精简你的 CSS。虽然很容易理解文件大小的减少，但对于你的代码库和团队成员的影响确实微乎其微的。

As we’ve touched on already, when using CSS-in-JS or CSS Modules, you no longer hard-code class strings in your markup, instead using dynamic references to JavaScript values that have been generated automatically by a library or build tool.

Instead of this:

```
<aside className="sidebar" />
```

We write this:

```
<aside className={styles.sidebar} />
```

This may look like a fairly superficial change, but this is a monumental shift in how we manage the relationship between our markup and our styles. By giving our CSS tooling the ability to alter not just our styles, _but the final classes we apply to our elements,_ we unlock an entirely new class of optimisations for our style sheets.

If we look at the example above, _‘styles.sidebar’_ evaluates to a string, but there’s nothing limiting it to a single class. For all we know, it could just as easily end up being a string of over a dozen classes.

```
<aside className={styles.sidebar} />
// Could easily resolve to this:
<aside className={'class1 class2 class3 class4'} />
```

If we can optimise our styles, generating multiple classes for each set of styles, we can do some really interesting things.

My favourite example of this is [Styletron](https://github.com/rtsao/styletron) by [Ryan Tsao](https://twitter.com/rtsao).

![](https://cdn-images-1.medium.com/max/1600/1*7xxb6FOmcmPCnQNrFy5pjg.png)

In the same way that CSS-in-JS and CSS Modules automate the process of adding BEM-style class prefixes, Styletron does the same thing to the Atomic CSS mindset.

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

#### Package management

Before digging into this point, it’s first worth stopping and asking yourself a seemingly simple question.

_How do we share CSS with each other?_

We’ve migrated from manually downloading CSS files, towards front-end specific package managers like [Bower](https://bower.io), and now via [npm](https://www.npmjs.com/) thanks to tools like [Browserify](http://browserify.org/) and [webpack](https://webpack.js.org). Even though some tooling has automated the process of including CSS from external packages, the front-end community has mostly settled on manual inclusion of CSS dependencies.

Either way, there’s one thing that CSS dependencies aren’t very good at—depending on _other_ CSS dependencies.

As many of you might remember, we’ve seen a similar effect with _JavaScript modules_ between Bower and npm.

Bower wasn’t coupled to any particular module format, whereas modules published to npm use the [CommonJS module format](http://wiki.commonjs.org/wiki/Modules/1.1). This has had a massive impact on the number of packages published to each platform.

Complex trees of small, _nested_ dependencies felt right at home on npm, while Bower attracted large, _monolithic_ dependencies, of which you might only have two or three—plus a few plugins, of course. Since your dependencies didn’t have a module system to rely on, each package couldn’t easily make use of its _own_ dependencies, so the integration was always a manual step left up to the consumer.

As a result, the number of packages on npm over time forms an exponential curve, while Bower only had a fairly linear increase of packages. While there are certainly a variety of reasons for this differentiation, it’s fair to say that a _lot_ of it has to do with the way each platform allows (or doesn’t allow) packages to depend on each other at runtime.

![](https://cdn-images-1.medium.com/max/1600/1*LTrsIISPV5qK-qAQKaeINA.png)

Unfortunately, this looks all too familiar to the CSS community, where we’ve also seen a relatively slow increase of monolithic packages compared to what we see with JavaScript packages on npm.

What if we instead wanted to match npm’s exponential growth? What if we wanted to be able to depend on complex package hierarchies of varying sizes, with less focus on large, all-encompassing frameworks? To do this, we’d not only need a package manager that’s up to the task—we’d also need an appropriate module format too.

Does this mean that we need a package manager specifically designed for CSS? For preprocessors like Sass and Less?

What’s really interesting is that we’ve already gone through a similar realisation with HTML. If you ask the same questions about how we share _markup_ with each other, you’ll quickly notice that we almost never share raw HTML directly—we share _HTML-in-JS._

We do this via [jQuery plugins](https://plugins.jquery.com/), [Angular directives](http://ngmodules.org) and [React components](https://react.parts/web). We compose large components out of smaller components, each with their own HTML, each published independently to npm. HTML as a format might not be powerful enough to allow this, but by _embedding HTML within a fully-fledged programming language,_ we’re easily able to work around this limitation.

What if, like HTML, we shared our CSS—and the logic that generates it—via JavaScript? What if, instead of using [mixins](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#mixins), we used _functions returning objects and strings?_ Instead of [extending classes](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#extend), what if we simply _merged objects_ with [_Object.assign_](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign), or the new [object spread operator](https://github.com/tc39/proposal-object-rest-spread)?

```
const styles = {
  ...rules,
  ...moreRules,
  fontFamily: 'Comic Sans MS',
  color: 'blue'
}
```

Once we start writing our styles this way, we can now compose and share our styling code like any other code in our application, using the same patterns, the same tooling, the same infrastructure, _the same ecosystem._

A great example of how this starts to pay off is in libraries like [Polished](https://github.com/styled-components/polished) by [Max Stoiber](https://twitter.com/mxstbr), [Nik Graf](https://twitter.com/nikgraf) and [Brian Hough](https://twitter.com/b_hough).

![](https://cdn-images-1.medium.com/max/1600/1*fczf3OWmmKBkFgtUqZnq2g.png)

Polished is essentially the [Lodash](https://lodash.com) of CSS-in-JS, providing a complete suite of mixins, colour functions, shorthands and more, making the process of authoring styles in JavaScript much more familiar for those coming from languages like [Sass](http://sass-lang.com). The key difference now is that this code is much more composable, testable and shareable, able to use the full JavaScript package ecosystem.

So, when it comes to CSS, how do we achieve the same level of open source activity seen across npm as a whole, composing large collections of styles from small, reusable, open-source packages? Strangely enough, we might finally achieve this by embedding our CSS within another language and completely embracing JavaScript modules.

### 5.

#### Non-browser styling

So far, all of the points we’ve covered—while certainly a lot _easier_ when writing CSS in JavaScript—they’re by no means things that are _impossible_ with regular CSS. This is why I’ve left the most interesting, future-facing point until last. Something that, while not necessarily playing a huge role in today’s CSS-in-JS community, is quite possibly going to become a foundational layer in the future of _design._ Something that affects not just developers, but designers too, radically altering the way these two disciplines communicate with each other.

First, to put this in context, we need to take a quick detour into React.

—

The React model is all about components rendering intermediate representations of the final output. When working in the browser, rather than directly mutating DOM elements, we’re building up complex trees of virtual DOM.

What’s interesting, though, is that rendering to the DOM is not part of the core React library, instead being provided by _react-dom._

```
import { render } from 'react-dom'
```

Even though React was built for the DOM first, and still gets most of its usage in that environment, this model allows React to target wildly different environments simply by introducing new renderers.

JSX isn’t just about virtual DOM—it’s about virtual _whatever._

This is what allows [React Native](https://facebook.github.io/react-native) to work, writing truly native applications in JavaScript, by writing components that render virtual representations of their native counterparts. Instead of _div_ and _span_, we have _View_ and _Text._

From a CSS perspective, the most interesting thing about React Native is that it comes with its own [StyleSheet API](https://facebook.github.io/react-native/docs/stylesheet.html):

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

Here you can see a familiar set of styles, in this case covering colours, fonts and border styling.

These rules are fairly straightforward and map easily to most UI environments, but things get really interesting when it comes to native layout.

```
var styles = StyleSheet.create({
  container: {
    display: 'flex'
  }
})
```

Despite being outside of a browser environment, _React Native ships with its own native implementation of_ [_flexbox_](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes)_._

Initially released as a JavaScript package called [_css-layout_](https://www.npmjs.com/package/css-layout)_,_ reimplementing flexbox entirely in JavaScript (backed by an appropriately comprehensive test suite), it’s now been migrated to C for better portability.

Given the scope and importance of the project, it’s been given a more significant brand of its own in the form of [Yoga](https://facebook.github.io/yoga).

![](https://cdn-images-1.medium.com/max/1600/1*mv_hHmbOgU7SOd5t2J2Q2g.png)

Even though Yoga is all about porting CSS concepts to non-browser environments, the potentially unmanageable scope has been reigned in by focusing on only a subset of CSS features.

> “Yoga’s focus is on creating an expressive layout library, not implementing all of CSS”

These sorts of tradeoffs may seem limiting, but when you look at the history of CSS architecture, it’s clear that _working with CSS at scale is all about picking a reasonable subset of the language._

In Yoga’s case, they eschew the cascade in favour of scoped styles, and focus their layout engine entirely on flexbox. While this rules out a lot of functionality, it also unlocks an amazing opportunity for cross-platform components with embedded styling, and we’ve already seen several notable open source projects trying to capitalise on this fact.

[React Native for Web](https://github.com/necolas/react-native-web) by [Nicolas Gallagher](https://twitter.com/necolas) aims to be a drop-in replacement for the react-native library. When using a bundler like webpack, aliasing third-party packages is fairly straightforward.

```
module: {
  alias: {
    'react-native': 'react-native-web'
  }
}
```

Using React Native for Web allows React Native components to work in a browser environment, including a browser port of the [React Native StyleSheet API](https://facebook.github.io/react-native/docs/stylesheet.html)_._

Similarly, [react-primitives](https://github.com/lelandrichardson/react-primitives) by [Leland Richardson](https://twitter.com/intelligibabble) is all about providing a cross-platform set of primitive components that abstract away the implementation details of the target platform, creating a workable baseline for cross-platform components.

Even [Microsoft](https://github.com/Microsoft) is getting in on the act with the introduction of [ReactXP](https://microsoft.github.io/reactxp), a library designed to streamline efforts to share code across both web and native, which also includes its own [platform-agnostic style implementation](https://microsoft.github.io/reactxp/docs/styles.html).

—

Even if you don’t write software for native applications, it’s important to note that having a truly cross-platform component abstraction allows us to target an effectively limitless set of environments, sometimes in ways that you might never have predicted.

The most surprising example of this I’ve seen is [react-sketchapp](http://airbnb.io/react-sketchapp) by [Jon Gold](https://twitter.com/jongold) at [Airbnb](https://github.com/airbnb).

![](https://cdn-images-1.medium.com/max/1600/1*qfskIhHAWpYwfR5Lz0_cIA.png)

For many of us, so much of our time is spent trying to standardise our design language, limiting the amount of duplication in our systems as much as possible. Unfortunately, as much as we’d like to only have a single source of truth, it seemed like the best we could hope for was to reduce it to _two_—a living style guide for developers, and _a static style guide for designers._ While certainly much better than what we’ve been historically used to, this still leaves us manually syncing from design tools—like [Sketch](https://www.sketchapp.com)—to code and back. This is where react-sketchapp comes in.

Thanks to Sketch’s [JavaScript API](http://developer.sketchapp.com/reference/api), and the ability for React to connect to different renderers, react-sketchapp lets us take our cross-platform React components and render them into our Sketch documents.

![](https://cdn-images-1.medium.com/max/1600/1*v2L1DB8OS38GScyBRFD8hQ.png)

Needless to say, this has the potential to massively shake up how designers and developers collaborate. Now, when we refer to the same components while iterating on our designs, we can potentially be referring to the same _implementation_ too, regardless of whether we’re working with tools for designers or developers.

With [symbols in Sketch](https://www.sketchapp.com/learn/documentation/symbols) and [components in React](https://facebook.github.io/react/docs/components-and-props.html), our industry is essentially starting to converge on the same abstraction, opening the opportunity for us to work closer together by sharing the same tools.

It’s no coincidence that so many of these new experiments are coming from within the React community, and those communities surrounding it.

In a component architecture, co-locating as many of a component’s concerns in a single place becomes a high priority. This, of course, includes its locally scoped styles, but even extends to more complicated areas like data fetching thanks to libraries like [Relay](https://facebook.github.io/relay) and [Apollo](http://dev.apollodata.com). The result is something that unlocks an enormous amount of potential, of which we’ve only just scratched the surface.

While this has a huge impact on the way we style our applications, it has an equally large effect on everything else in our architecture—but for good reason.

By unifying our model around components written in a single language, we have the potential to better separate our concerns—not by technology, but by _functionality._ Scoping everything around the unit of a component, scaling large yet maintainable systems from them, optimised in ways that weren’t possible before, sharing our work with each other more easily and composing large applications out of small open-source building blocks. Most importantly, we can do all of this without breaking progressive enhancement, without giving up on the principles that many of us see as a non-negotiable part of taking the web platform seriously.

Most of all, I’m excited about the potential of components written in a single language to form the basis of _a new, unified styling language_—one that unites the front-end community in ways we’ve never seen before.

At SEEK, we’re working to take advantage of this by building our own living style guide around this component model, where semantics, interactivity and visual styling are all united under a single abstraction. This forms a common design language, shared between developers and designers alike.

As much as possible, building a page should be as simple as combining an opinionated set of components that ensure our work stays on brand, while allowing us to upgrade our design language long after we’ve shipped to production.

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

CSS-in-JS has come a surprisingly long way in a short amount of time, but it’s important to note that, in the grand scheme of things, it’s only just getting started.

There’s still so much room for improvement, and the innovations are showing no signs of stopping. Libraries are still popping up to address the outstanding issues and to improve the developer experience—performance enhancements, extracting static CSS at build time, targeting CSS variables and lowering the barrier to entry for all front-end developers.

This is where the CSS community comes in. Despite all of these massive alterations to our workflow, **_none of this changes the fact that you still need to know CSS._**

We may express it with different syntax, we may architect our apps in different ways, but the fundamental building blocks of CSS aren’t going away. Equally, our industry’s move towards component architectures is inevitable, and the desire to reimagine the front-end through this lens is only getting stronger. There is a very real need for us to work together, to ensure our solutions are widely applicable to developers of all backgrounds, whether design-focused, engineering-focused, or both.

While we may sometimes seem at odds, the CSS and JS communities both share a passion for improving the front-end, for taking the web platform seriously, and improving our processes for the next generation of web sites. There’s so much potential here, and while we’ve covered an incredible amount of ground so far, there’s still so much work left to be done.

At this point, you still might not be convinced, and that’s totally okay. It’s completely reasonable to find CSS-in-JS to be ill-fitting for your work _right now,_ but my hope is that it’s for the _right reasons,_ rather than superficial objections to mere _syntax._

Regardless, it seems quite likely that this approach to authoring styles is only going to grow more popular over the coming years, and it’s worth keeping an eye on it while this approach continues to evolve at such a rapid pace. I sincerely hope that you’re able to join us in helping make the next generation of CSS tooling as effective as possible for all front-end developers, whether through code contributions or _simply being an active part of the conversation._ If not, at the _very least,_ I hope I’ve been able to give you a better understanding of why people are so passionate about this space, and—maybe—why it’s not such a ridiculous idea after all.

_This article was written in parallel with a talk of the same name — presented at CSSconf EU 2017 in Berlin, Germany — which is now_ [_available on YouTube_](https://www.youtube.com/watch?v=X_uTCnaRe94)_._

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


