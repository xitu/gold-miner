> * 原文地址：[A Unified Styling Language](https://medium.com/seek-blog/a-unified-styling-language-d0c208de2660)
> * 原文作者：本文已获原作者 [Mark Dalgleish](https://medium.com/@markdalgleish) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[ZhangFe](https://github.com/ZhangFe)
> * 校对者：[JackGit](https://github.com/JackGit),[yifili09](https://github.com/yifili09)

# 统一样式语言

在过去几年中，我们见证了  [CSS-in-JS](https://github.com/MicheleBertoli/css-in-js) 的兴起，尤其是在 [React](https://facebook.github.io/react) 社区。当然，它也饱含争议。很多人，尤其是那些已经对 CSS 非常熟悉的人都表示难以置信。

> "为什么有人要在 JS 中写 CSS？

> 这简直是一个可怕的想法！

> 但愿他们学过 CSS !"

如果这就是你的反应，那么请继续读下去。我们来看看到底为什么在 JavaScript 中编写样式并不是一个可怕的想法，并且为什么我认为你应该关注这个快速发展的领域。

![](https://cdn-images-1.medium.com/max/2000/1*Ipu5Grtzr21suPiTfvGXaw.png)

### 对社区的误解

React 社区经常被 CSS 社区误解，反之亦然。对我来说这很有趣，因为我经常混迹于这两个社区。

我从九十年代后期开始学习 HTML，并且从基于表格布局的黑暗时代以来就一直使用 CSS。受 [CSS Zen Garden](http://www.csszengarden.com) 启发，我是最早一批将现有代码向 [语义化标签](https://en.wikipedia.org/wiki/Semantic_HTML) 和级联样式表迁移的人。不久之后，我开始专注于前后端分离，使用[非侵入式 JavaScript](https://www.w3.org/wiki/The_principles_of_unobtrusive_JavaScript) 和客户端的交互来装饰服务端渲染的 HTML。围绕这些做法有一个小型且充满活力的社区，并且我们成为第一代尝试给浏览器平台应有尊重的前端开发者。

伴随这样的背景，你可能会认为我会强烈反对 React 的 [HTML-in-JS](https://facebook.github.io/react/docs/jsx-in-depth.html) 模式，它似乎违背了我们所坚持的原则，但实际上恰恰相反。根据我的经验，React 的组件模型加上服务端渲染的能力，最终给我们提供了一种构建大规模复杂单页应用的方式，从而使我们能够将快速，可访问，逐渐增强的应用推送给我们的用户。在 [SEEK](https://www.seek.com.au) 上我们就利用了这种能力，这是我们的旗舰产品，它是 React 单页应用程序，当 JavaScript 被禁用时我们的核心搜索流程依然可用，因为我们通过在服务器端运行同构的 JavaScript 代码来完成到传统的网站优雅降级。

所以，也请考虑一下我抛出的从一个社区到另一个社区的橄榄枝。让我们一起尝试理解这个转变。它可能不完美，它可能不是你计划在产品中使用的东西，它可能对你不是很有说服力，但是至少值得你尝试思考一下。

### 为什么使用 CSS-in-JS?

如果你熟悉我最近做的与 React 以及 [CSS 模块](https://github.com/css-modules/css-modules)相关的工作，当看到我维护 CSS-in-JS 时你可能会很惊讶。

![](https://cdn-images-1.medium.com/max/1600/1*RtAMWbxdwW2ujyrurU9plw.png)

毕竟，通常那些希望有局部样式但是又不希望在 JS 中写 CSS 的开发者会选择使用 CSS 模块。事实上，甚至我自己在工作中也还没用到 CSS-in-JS。

尽管如此，我任然对 CSS-in-JS 社区保持浓厚的兴趣，对他们不断提出的创意保持密切关注。不仅如此，**我认为更广泛的 CSS 社区对它也应该很感兴趣**

原因是什么呢?

为了更清楚地了解为什么人们选择在 JavaScript 中编写他们的样式，我们将重点关注采用这种方式时带来的实际好处。

我把它分为五个方面:

1.  局部样式
2.  关键 CSS
3.  智能优化
4.  打包管理
5.  在非浏览器环境下的样式


让我们进一步的细分并且仔细看看 CSS-in-JS 提供的每一点优势。

### 1.

#### **局部样式**

想要在大规模项目中高效的构建 CSS 是非常困难的。当加入一个现有的长期运行的项目时，通常我们会发现 CSS 是系统中最复杂的部分。

为了解决这个问题，CSS 社区已经投入了巨大的努力，通过 [Nicole Sullivan](https://twitter.com/stubbornella) 的 [OOCSS](https://github.com/stubbornella/oocss/wiki) 和 [Jonathan Snook](https://twitter.com/snookca) 的 [SMACSS](https://smacss.com/) 都可以使我们的样式更好维护，不过 [Yandex](https://github.com/yandex) 开发的 [BEM](http://getbem.com) 更流行一些。

根本上来说，BEM （纯粹用于 CSS）只是一个命名规范，它要求样式的类名要遵守 `.Block__element--modifier` 的模式。在任何使用 BEM 风格的代码库中，开发人员必须始终遵守 BEM 的规则。当严格遵守时，BEM 的效果很好，但是为什么这些如同作用域一般基础的功能，却只使用单纯的**命名规范**来限制呢？

无论是否有明确表示，大多数 CSS-in-JS 类库都遵循 BEM 的思路，它们尝试将样式定位到单个 UI 组件，只不过用了完全不同的实现方式。

那么在实际编写代码时什么样的呢？当使用 [Sunil Pai](https://twitter.com/threepointone) 开发的 [glamor](https://github.com/threepointone/glamor) 时，代码看起来像下面这样：

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

你可能会注意到**代码中没有 CSS 的类名**。因为它不再是一个指向定义在项目其他位置 class 的硬编码，而是由我们的库自动生成的。我们不必再担心全局作用域内的选择器冲突，这也意味着我们不再需要替他们添加前缀了。

这个选择器的作用域与周围代码的作用域一致。如果你希望在你应用的其他地方使用这个规则，你就需要将它改写成一个 JavaScript 模块并且在需要使用的地方引用它。就保持代码库的可维护性而言，它是非常强大的，**它确保了任何给定的样式都可以像其他代码一样容易追踪来源**。

**通过从仅仅是命名约定到默认强制局部样式的转变，我们已经提高了我们样式质量的基准线。BEM 已经烙在里面了，而不再是一个可选项。**

—

在继续之前，我要说明至关重要的一点。

**它生成的是真正的级联样式，而不是内联样式**

大多数早期的 CSS-in-JS 库都是将样式直接添加到每个元素上，但是这个模式有个严重的缺点，'styles' 属性并不能做到 CSS 可以做到的每件事。大多数新的库不再关注于**动态样式表**，而是在运行时在全局样式中插入和删除规则。

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

一旦你将这些样式插入到文档中，你就可以使用那些自动生成的类名。

```
const { classes } = jss.createStyleSheet(styles).attach()
```

无论你是使用一个完整的框架，还是简单的使用 **innerHTML**，你都可以在 JavaScript 中使用这些生成的 class，而不是硬编码你的 class 字符串。

```
document.body.innerHTML = `
  <h1 class="${classes.heading}">Hello World!</h1>
`
```

单独使用这种方式管理样式并没有多大的优势，它通常和一些组件库搭配使用。因此，通常可以找到用于最流行库的绑定方案。例如，JSS 可以通过 [react-jss](https://github.com/cssinjs/react-jss) 的帮助轻松地绑定到 React 组件上，在管理生命周期的同时，它可以帮你给每个组件插入一小段样式。

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

通过将我们的样式集中到组件上，可以将他们和代码跟紧密的结合，这不就是 BEM 的思想么？所以 CSS-in-JS 社区的很多人觉得在所有的样式绑定样板中，提取、命名和复用组件的重要性都丢失了。

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

使用这些样式时，我们不会将 class 添加到存在的元素上，而是简单地渲染这些被生成的组件。

```
<Title>Hello World!</Title>
```

虽然 styled-components 通过模板字面量的方式使用了传统的 CSS 语法，但是有人更喜欢使用数据结构。来自 [PayPal](https://github.com/paypal) 的 [Kent C. Dodds](https://twitter.com/kentcdodds) 开发的 [Glamorous](https://github.com/paypal/glamorous) 是一个值得关注的替代方案。

![](https://cdn-images-1.medium.com/max/1600/1*Ere9GQTIJeNac2ONfZlfdw.png)

Glamorous 和 styled-components 一样提供了组件优先的 API，但是他的方案是使用**对象**而不是**字符串**，这样就无需在库中引入一个 CSS 解析器，可以降低库的大小并提高性能。

```
import glamorous from 'glamorous'

const Title = glamorous.h1({
  fontFamily: 'Comic Sans MS',
  color: 'blue'
})
```

无论你使用什么语法描述你的样式，他们不再仅仅是组件的**一部分**，他们和组件已经无法分离。当使用一个像 React 这样的库时，组件是基本构建块，并且现在我们的样式也成了构建这个架构的核心部分。**如果我们将我们应用程序中的所有内容都描述为组件，那么为什么我们的样式不行呢？**

—

考虑到我们之前介绍的对系统做出改变的意义，对于那些有丰富 BEM 开发经验的工程师来说，这一切看起来似乎是一个很小的提升。事实上，CSS 模块让你在不用放弃 CSS 工具生态系统的同时获得了这些提升。很多项目坚持使用 CSS 模块还有一个原因，他们发现 CSS 模块充分解决了编写大规模 CSS 的问题，并且可以保持编写常规 CSS 时的习惯。

然而，当我们开始在这些基本概念上构建时，事情开始变得更有趣。

### 2.

#### 关键 CSS

在文档头部内联关键样式已经成为一种比较新的最佳实践，通过仅提供当前页面所需的样式可以提高首屏时间。这与我们常用的样式加载方式形成了鲜明对比，之前我们通常会强制浏览器在渲染之前为应用下载所有的样式。

虽然有工具可以用于提取和内联关键 CSS，比如 [Addy Osmani](https://twitter.com/addyosmani) 的 [critical](https://github.com/addyosmani/critical)，但是他们无法从根本上改变关键 CSS 难以维护和难以自动化的事实。这是一个棘手的、可选的性能优化，所以大部分项目似乎放弃了这一步。

CSS-in-JS 则是一个完全不同的故事。

当你的应用使用服务端渲染时，提取关键 CSS 不仅仅是一个优化，从根本上来说，服务器端的 CSS-in-JS 是**使用**关键 CSS 的首要工作。

举个例子，当使用 [Khan Academy](https://github.com/Khan) 开发的 [Aphrodite](https://github.com/Khan/aphrodite) 给元素添加 class 时，可以通过内联调用它的 `css` 函数来跟踪在这次渲染过程中使用的样式。

```
import { StyleSheet, css } from 'aphrodite'
const styles = StyleSheet.create({
  title: { ... }
})
const Heading = ({ children }) => (
  <h1 className={css(styles.heading)}>{ children }</h1>
)
```

即便你所有的样式都是在 JavaScript 中定义的，你也可以很轻松的从当前页面中提取所有的样式并生成一个 CSS 字符串，在执行服务端渲染时将它们插入文档的头部。

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

如果你看过 React 的服务端渲染模型，你可能会发现这个模式非常熟悉。在 React 中，你的组件在 JavaScript 中定义他们的标记，但可以在服务器端渲染成常规的 HTML 字符串。

**如果你使用渐进增强的方式构建你的应用，尽管全部使用 JavaScript 编写，但也有可能在客户端根本就不需要 JavaScript**

无论用哪种方式，客户端 JavaScript bundle 都要包含启动单页应用所需的代码，它能让页面瞬间活起来，并与此同时开始浏览器中进行渲染。

由于在服务器上渲染 HTML 和 CSS 是同时进行的，就像前面的例子所示， Aphrodite 这样的库通常会以一个函数调用的方式帮助我们流式生成关键 CSS 和服务端渲染的 HTML。现在，我们可以用类似的方式将我们的 React 组件渲染成静态 HTML。

```
const appHtml = `
  <div id="root">
    ${html}
  </div>
`
```

通过在服务器端使用 CSS-in-JS，我们的单页应用不仅可以脱离 JavaScript 工作，**它甚至可以加载的更快**。

**与我们选择器的作用域一样，渲染关键 CSS 的最佳实践如今已经烙在里面了，而不是一个可选项**。

### 3.

#### 更智能的优化

我们最近看到了构建 CSS 的新方式的兴起，比如 [Yahoo](https://github.com/yahoo) 的 [Atomic CSS](https://acss.io/) 和 [Adam Morse](https://twitter.com/mrmrs_) 的 [Tachyons](http://tachyons.io/)，它们更喜欢短小的，单一用途的类名，而不是语义化的类名。举个例子，当使用 Atomic CSS 时，你将使用类似于函数调用的语法去作为类名，并且这些类名会在之后被用来生成合适的样式表。

```
<div class="Bgc(#0280ae.5) C(#fff) P(20px)">
  Atomic CSS
</div>
```

通过最大程度地提高类的复用性以及用内联样式的方式一样有效处理类名，可以达到尽可能地精简 CSS 的目的。虽然文件大小的减少很容易体现，但对于你的代码库和团队成员的影响确实是微乎其微的。这些优化会从底层引起你的 CSS 和标记语言的变化，使他们成为构建工作中更重要的部分。

正如我们已经介绍过的，当使用 CSS-in-JS 或者 CSS 模块时，你不再需要在 HTML 中硬编码你的类名，而是动态引用由库或者构建工具自动生成的 JavaScript 变量。

我们这样写样式:

```
<aside className={styles.sidebar} />
```

而不是:

```
<aside className="sidebar" />
```


这个变化可能看起来相当肤浅，但是从如何管理标记语言和样式之间关系上来说，这却是一个里程碑式的改变。通过给我们的 CSS 工具不止修改样式，还能修改最终提供给组件的 class 的能力，我们为我们的样式表解锁了一个全新的优化方式。

如果看看上面的例子，就会发现 'styles.sidebar' 对应了一个字符串，但并没有什么去限制它只能是一个 class。就我们所了解的，它可以很容易的对应成表示十几个 class 的字符串。

```
<aside className={styles.sidebar} />
// Could easily resolve to this:
<aside className={'class1 class2 class3 class4'} />
```

如果我们可以优化我们的样式，为每一套样式生成多个类，我们就可以做一些非常有趣的事。

我最喜欢的例子是 [Ryan Tsao](https://twitter.com/rtsao) 编写的 [Styletron](https://github.com/rtsao/styletron)。

![](https://cdn-images-1.medium.com/max/1600/1*7xxb6FOmcmPCnQNrFy5pjg.png)


与 CSS-in-JS 和 CSS 模块自动添加 BEM 风格前缀的过程相同，Styletron 对 Atomic CSS 也做了相同的事。

它的核心 API 专注于一件事，为每个由属性、值、媒体查询组合起来的样式定义一个独立的 CSS 规则，然后返回自动生成的 class。

```
import styletron from 'styletron';
styletron.injectDeclaration({
  prop: 'color',
  val: 'red',
  media: '(min-width: 800px)'
});
// → 'a'
```

当然，Styletron 也提供了一些高级 API，比如它的 `injectStyle` 函数允许一次定义多个规则。

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


尤其要注意上面生成的类名之间的相同点。

**通过放弃对 class 本身的低级控制，而仅定义所需要的样式集合，这些库就能帮我们生成最佳的 class 原子集合。**


![](https://cdn-images-1.medium.com/max/1600/1*pWXr1A6uhiOkYHqwfBMtWg.png)

之前我们通过手工查找的方式将样式分割成可复用的 class，现在已经可以完全自动化的完成这种优化了，并且你应该也开始注意到这个趋势。**原子性 CSS 已经烙在里面了，并非一个可选项**。

### 4.

#### 包管理

在谈论这一点之前，我们先停下来问自己一个看似简单的问题。

**我们如何共享 CSS？**

我们已经从手动下载 CSS 文件向使用前端专门的模块管理工具转变，比如 [Bower](https://bower.io)，或者现在通过 [npm](https://www.npmjs.com/) 可以使用 [Browserify](http://browserify.org/) 和 [webpack](https://webpack.js.org)。虽然这些工具已经自动处理了外部模块的 CSS 依赖，但是目前前端社区大多还是手工处理 CSS 的依赖关系。

无论使用哪种方式，CSS 之间的依赖都不是很好处理。

你们许多人可能还记得，在使用 Bower 和 npm 管理 **JavaScript 模块**时，出现过类似的情况。

Bower 没有依赖任何特定的模块格式，而发布到 npm 的模块则要求使用 [CommonJS 模块格式](http://wiki.commonjs.org/wiki/Modules/1.1)。这种不一致，对发布到两者任何一个平台的包的数量都产生了巨大的影响。

小型但是有复杂依赖关系的模块更愿意使用 npm，Bower 则吸引了大量大型而独立的模块，当然，你可能也就有两三个模块，再加几个插件，但由于在 Bower 中你的依赖没有一个模块系统去作支撑，每个包无法简单的利用它自己的依赖关系，所以在整合这一块，基本上就留给开发者手动去操作了。

因此，随着时间的推移，npm 上的模块数量呈指数性增长，而 Bower 只能是有限的线性增长。虽然这可能是各种原因导致的，但是不得不说，主要原因还是在于两个平台处理运行时包与包之间的依赖关系的不同方法。

![](https://cdn-images-1.medium.com/max/1600/1*LTrsIISPV5qK-qAQKaeINA.png)

很不幸，这对于 CSS 社区来说太熟悉了，我们发现相对于 npm 上的 JavaScript 来说，独立 CSS 模块的数量也增长的很慢。

如果我们也想实现 npm 的指数增长该怎么做？如果我们想依赖不同大小不同层次的复杂模块，而不是专注于大型、全面的框架呢？为了做到这一点，我们不仅需要一个包管理器，还需要一个合适的模块格式。

这是否意味着我们需要专门为 CSS 或者 Sass 和 Less 这样的预处理器设计一个包管理工具？


有趣的是，在 HTML 上我们已经实现了类似的功能。如果你问我相同的问题：我们如何共享标记语言？你可能很快会想起来，我们几乎不会直接共享原始的 HTML —— 我们共享 **HTML-in-JS**。


我们通过 [jQuery 插件](https://plugins.jquery.com/)，[Angular 指令集](http://ngmodules.org) 和 [React 组件](https://react.parts/web)实现了这个功能。我们的大组件由小组件组成，每一个小组件都有着自己的 HTML，它们也都独立的发布在了 npm 上。HTML 这种格式可能不足以强大到完成这个功能，但是**通过将 HTML 嵌入到完整的编程语言中**，我们就可以很轻松的越过这个限制。

我们能不能像 HTML 那样，通过 JavaScript 去分享 CSS呢？能不能使用**函数来返回对象和字符串**而不是使用 [mixins](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#mixins) ？又或者我们利用  [Object.assign](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) 和新的 [object spread 操作符](https://github.com/tc39/proposal-object-rest-spread) 来 **merge 对象**而不是用 [extending classes](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#extend) 呢？

```
const styles = {
  ...rules,
  ...moreRules,
  fontFamily: 'Comic Sans MS',
  color: 'blue'
}
```

一旦我们开始用这种方式编写我们的样式，我们就可以使用相同的模式、相同的工具、相同的基础架构、相同的生态系统来编写和分享我们的样式代码，就像我们应用程序中的其他任何代码一样。

由 [Max Stoiber](https://twitter.com/mxstbr)、[Nik Graf](https://twitter.com/nikgraf) 和 [Brian Hough](https://twitter.com/b_hough) 开发的 [Polished](https://github.com/styled-components/polished) 就是一个很好的例子。 

![](https://cdn-images-1.medium.com/max/1600/1*fczf3OWmmKBkFgtUqZnq2g.png)

Polished 就像是 CSS-in-JS 界的 [Lodash](https://lodash.com)，它提供了一整套完整的 mixins、颜色函数等等，使得在 JavaScript 中可以得到使用 [Sass](http://sass-lang.com) 编写样式的体验。最大的区别在于，现在这些代码在复用、测试和分享方面，都提高了一个层次，并且能够完整的使用 JavaScript 模块生态系统。

当谈到 CSS 时我们会想，作为一个由小型可复用的开源模块组合成的一个样式集合，我们如何获得和 npm 上其他模块相似的开源程度？奇怪的是，我们最终通过将我们的 CSS 嵌入其他的语言并且完全拥抱 JavaScript 模块实现了这一点。

### 5.

#### 在非浏览器环境下的样式

到目前为止，我的文章已经涵盖了所有的要点，虽然在 JavaScript 中编写 CSS 会容易的多，但是常规的 CSS 并非完不成这些功能。这也是我把最有趣、最面向未来的一点留到现在的原因。这一点并不一定能在如今的 CSS-in-JS 社区中发挥巨大的作用，但它可能会成为未来设计的基础层面。它不仅会影响开发人员，也会影响设计师，最终它将改变这两个领域相互沟通的方式。

首先，为了介绍它，我们需要先简单介绍一下 React。

—

React 的理念是用组件作为最终渲染的中间层。在浏览器中工作时，我们构建复杂的虚拟 DOM 树而不是直接操作 DOM 元素。

有趣的是，DOM 渲染相关的代码并不属于 React 的核心部分，而是由 **react-dom** 提供的。

```
import { render } from 'react-dom'
```

尽管最初 React 是为 DOM 设计的，并且大部分情况下还是在浏览器中使用，但是这种模式也允许 React 只通过简单地引入新的渲染引擎就能从容面对各种不同的使用环境。

JSX 不仅仅可以用于虚拟 DOM，他可以用在任何的虚拟视图上。

这就是 [React Native](https://facebook.github.io/react-native) 的工作原理，我们通过编写那些渲染成 native 的组件以实现用 JavaScript 编写真正的 native 应用，比如我们用 **View** 和 **Text** 取代了 **div** 和 **span**。

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


在这里你会看到一组熟悉的样式，我们编写了颜色、字体和边框样式。

这些规则都非常简单，并且很容易映射到大部分的 UI 环境上，但是当涉及到 native 布局时，事情就变得非常有趣了。

```
var styles = StyleSheet.create({
  container: {
    display: 'flex'
  }
})
```


因为在浏览器环境之外，所以 **React Native 有自己的 [flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes) 实现**

最初发布时他是一个名为 [css-layout](https://www.npmjs.com/package/css-layout) 的JavaScript 模块，完全用 JavaScript 重新实现了 flexbox（包含充分的测试），为了更好的可移植性它现在已经迁移到 C 语言。


鉴于这个项目的影响力和重要性，它被赋予了更重要的品牌 ——— [Yoga](https://facebook.github.io/yoga)。

![](https://cdn-images-1.medium.com/max/1600/1*mv_hHmbOgU7SOd5t2J2Q2g.png)


虽然 Yoga 专注于将 CSS 迁移到非浏览器环境中，但是仅关注于 CSS 特性的一小部分无法扩大它的统治范围。

> "Yoga 的重点是成为一个有表现力的布局框架，而不是去实现一套完整的 CSS"


这看起来似乎很难实现，但是当你回顾 CSS 体系的历史时会发现**使用 CSS 进行规模化的工作就是选择一个合适的语言子集**。

在 Yoga 中，为了控制样式的作用域，他们避开了级联样式，并且将布局引擎完全集中在 flexbox 上。虽然这样会丧失很多功能，但它也为需要嵌入样式的跨平台组件创造了惊人的机遇，我们已经看到几个试图利用这个特性的开源项目。

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

甚至 [微软](https://github.com/Microsoft) 也开始推出 [ReactXP](https://microsoft.github.io/reactxp)，这个库旨在简化跨 web 和 native 的工作流，它也有自己的[跨平台样式实现](https://microsoft.github.io/reactxp/docs/styles.html)

—


即使你不编写 native 应用程序，也要注意一点：拥有一个真正的跨平台组件抽象，能够使我们将目标设定在那些高效的、无限可能的环境中去，有时这些会让你无法想象。

我所见过的最令人震惊的例子是 [Airbnb](https://github.com/airbnb) 的 [Jon Gold](https://twitter.com/jongold) 开发的 [react-sketchapp](http://airbnb.io/react-sketchapp)。

![](https://cdn-images-1.medium.com/max/1600/1*qfskIhHAWpYwfR5Lz0_cIA.png)

我们很多人都花费了大量时间去尝试标准化我们的设计语言，并且尽可能的避免系统中的重复。不幸的是，尽管我们希望样式只有一个来源，但我们最多也只能减少到两个，**开发人员的动态样式以及设计师的静态样式**。虽然这已经比我们之前的模式好了很多，但是它仍然需要我们手工的将样式从 [Sketch](https://www.sketchapp.com) 这样的设计工具上同步到代码里。这也是 react-sketchapp 被开发出来的原因。

感谢 Sketch 的 [JavaScript API](http://developer.sketchapp.com/reference/api)，以及 React 连接到不同渲染引擎的能力，react-sketchapp 让我们可以用跨平台的 React 组件渲染我们的 Sketch 文件。

![](https://cdn-images-1.medium.com/max/1600/1*v2L1DB8OS38GScyBRFD8hQ.png)


不用多说，这很可能改变设计师和开发人员的合作方式。现在，当我们对设计进行迭代时，无论在设计工具还是开发者工具上，我们都可以通过相同的声明引用同一个组件。

通过 [Sketch 中的符号](https://www.sketchapp.com/learn/documentation/symbols)和 [React 中的组件](https://facebook.github.io/react/docs/components-and-props.html)，我们的行业已经开始从本质上趋于抽象，并且通过使用相同的工具我们可以更紧密的协作。

这么多新的尝试都来自 React 和其周边的社区，看来这并不是巧合。

在组件架构中，最重要的是将组件的功能集中在一起。这自然包括它的局部样式，往更复杂的方向延伸就涉及到数据的获取。这里要感谢 [Relay](https://facebook.github.io/relay) 和 [Apollo](http://dev.apollodata.com)，让这个过程变得简单。这些成果解锁了巨大了潜力，我们现在所了解的，只是其中冰山一角。

虽然这对我们编写样式产生了很大的影响，但其实它对我们架构里的一切都有很大的影响，当然，是出于好的理由。

通过统一单一语言开发组件的模式，我们能够从功能上，而不是从技术上，将我们的关注点进行更好的隔离。将组件的所有内容局部化，用他们构建大型可维护的系统，用之前无法使用的方式进行优化，更容易的分享我们的工作，以及利用小型开源模块构建大型应用程序。更重要的是，完成这一切并不需要打破渐进增强的理念，也不会让我们放弃认真对待 web 平台的理念。

最重要的是，我对使用单一语言编写出的组件的潜力感到兴奋，他们形成了一种新的、统一的样式语言基础，以一种前所未有的方式统一了前端社区。

在 SEEK，我们正在努力利用这一功能，我们围绕组件模型来构建在线样式指南，其中语义化、交互性和视觉风格都有统一的抽象。这构成了开发人员和设计师之间共享的通用设计语言。

构建一个页面应该尽可能的和拼装组件一样简单，这样可以确保我们工作的高品质，并且让我们在产品上线很久以后，也有能力去升级其设计语言。

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


尽管我们现在使用 React，webpack 和 CSS 模块构建了这个样式指南，但是这个架构，和任何你之前知道的 CSS-in-JS 系统是一致的。技术上可能不一致，但是核心理念是一样的。

然而，未来这些技术选型可能也需要以一种意想不到的方式进行转变，这也就是为什么保持对这个领域的持续关注，对与我们不断发展的组件生态是如此的重要。我们现在可能不会用 CSS-in-JS 这项技术，但是很可能没过多久就会出现一个令人信服的理由让我们使用它。

CSS-in-JS 在短时间里有了出人意料的发展，但更重要的是，它只是这个宏伟蓝图的开始。

它还有很大的改进空间，并且它的创新还没有停止的迹象。新的库正不断涌现，它们解决了未来会出现的问题并且提升了开发人员的体验 —— 比如性能的提升，在构建时抽取静态 CSS，支持 CSS 变量以及降低了前端开发人员的入门门槛。

这也是 CSS 社区关注的地方。尽管这些对我们的工作流程有很大的改动，**但是他们不会改变你仍然需要学习 CSS 的事实**。

我们可能使用不同的语法，也可能以不同的方式构建我们的应用，但是 CSS 的基本构建块不会消失。同样，我们行业向组件架构的转变是不可避免的，通过这种方式重新构想前端的意愿只会越来越强烈。我们非常需要共同合作以确保我们的解决方案广泛适用于各种背景的开发人员，无论是专注于设计的还是工程的。

虽然有时我们的观点不一致，但是 CSS 和 JS 社区对于改进前端，把 Web 平台变得更加重要以及改进我们下一代 web 开发流程都有很大的激情。社区的潜力是巨大的，而且尽管到目前为止我们已经解决了大量的问题，仍然有很多工作还没有完成。


到这里，可能你还是没有被说服，但是完全没关系。虽然现在在工作上使用 CSS-in-JS 不是很合适，但我希望它有合适的原因，而不是仅仅因为语法就反对它。

无论如何，未来几年这种编写样式的风格可能会越来越流行，并且值得关注的是它发展的非常快。我衷心希望你可以加入我们，无论是通过贡献代码还是**简单的参与我们的对话讨论**，都能让下一代 CSS 工具尽可能的提高前端开发人员的工作效率。或者，我希望已经让你们至少了解为什么人们对这一块如此饱含激情，或者，至少了解为什么这不是一个愚蠢的点子。


这篇文章是我在德国柏林参加 CSSconf EU 2017 做相同主题演讲时撰写的，并且现在可以在 [YouTube](https://www.youtube.com/watch?v=X_uTCnaRe94) 上看到相关视频。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


