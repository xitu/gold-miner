> * 原文地址：[A Unified Styling Language](https://medium.com/seek-blog/a-unified-styling-language-d0c208de2660)
> * 原文作者：本文已获原作者 [Mark Dalgleish](https://medium.com/@markdalgleish) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[ZhangFe](https://github.com/ZhangFe)
> * 校对者：[JackGit](https://github.com/JackGit), [yifili09](https://github.com/yifili09), [sunshine940326](https://github.com/sunshine940326), [sunui](https://github.com/sunui)

# 统一样式语言

在过去几年中，我们见证了  [CSS-in-JS](https://github.com/MicheleBertoli/css-in-js) 的兴起，尤其是在 [React](https://facebook.github.io/react) 社区。但它也饱含争议，很多人，尤其是那些已经精通 CSS 的人，对此持怀疑态度。

> "为什么有人要在 JS 中写 CSS？

> 这简直是一个可怕的想法！

> 但愿他们学过 CSS !"

如果这是你听到 CSS-in-JS 时的反应，那么请阅读下去。我们来看看为什么在 JavaScript 中编写样式并不是一个可怕的想法，以及为什么我认为你应该长期关注这个快速发展的领域。

![](https://cdn-images-1.medium.com/max/2000/1*Ipu5Grtzr21suPiTfvGXaw.png)

### 相互误解的社区

React 社区经常被 CSS 社区误解，反之亦然。对我来说这很有趣，因为我同时混迹于这两个社区。

我从九十年代后期开始学习 HTML，并且从基于表格布局的黑暗时代就开始专职于 CSS。受 [CSS 禅意花园](http://www.csszengarden.com)启发，我是最早一批将现有代码向[语义化标签](https://en.wikipedia.org/wiki/Semantic_HTML)和层叠样式表迁移的开发者。不久后我开始痴迷于 HTML 和 JavaScript 的分离工作，在服务器渲染出来的页面中使用[非侵入式 JavaScript](https://www.w3.org/wiki/The_principles_of_unobtrusive_JavaScript) 同客户端交互。围绕这些实践，我们组成了一个非常小但是充满活力的社区，并且我们成为了第一代前端开发人员，努力去解决各个浏览器的兼容性问题。

在这种关注于web的背景下，你可能会认为我会强烈反对 React 的 [HTML-in-JS](https://facebook.github.io/react/docs/jsx-in-depth.html) 模式，它似乎违背了我们所坚持的原则，但实际上恰恰相反。根据我的经验，React 的组件化模型结合其服务端渲染的能力，终于为我们提供了一种构建大规模复杂单页应用的方式，并且仍然能将快速、易访问、渐进增强的应用推送给我们的用户。在我们的旗舰产品 [SEEK](https://www.seek.com.au) 上我们就是这么做的，它是一个 React 单页应用，当 JavaScript 被禁用时，其核心搜索流程依然可用，因为我们通过在服务器端运行同构的 JavaScript 代码来实现优雅降级。

所以，请考虑将这篇文章作为两个社区之间相互示好的橄榄枝。让我们一起努力理解 CSS-in-JS 这次转变的实质所在。也许它不完美，也许你没有计划在你的产品中使用这门技术，也许它对你不是很有说服力，但是至少值得你尝试思考一下。

### 为什么要使用 CSS-in-JS?

如果你熟悉我最近做的与 React 以及 [CSS Modules](https://github.com/css-modules/css-modules)相关的工作，你会惊讶地发现我是捍卫 CSS-in-JS 的。

![](https://cdn-images-1.medium.com/max/1600/1*RtAMWbxdwW2ujyrurU9plw.png)

毕竟，通常那些希望样式有局部作用域但是又不希望在 JS 中写 CSS 的开发者才会选择使用 CSS Modules。事实上，我甚至在自己的工作中都不使用CSS-in-JS。

尽管如此，我仍然对 CSS-in-JS 社区保持浓厚的兴趣，对他们不断提出的创新保持密切关注。不仅如此，**我认为这些应该同样被更多的 CSS 社区所关注**

原因是什么呢？

为了更清楚地了解为什么人们选择在 JavaScript 中编写样式，我们将重点关注这种方式所带来的实际性好处.

我把这些优点分为五个主要方面：

1.  拥有作用域的样式
2.  抽取关键 CSS
3.  更智能的优化
4.  打包管理
5.  在非浏览器环境下的样式

让我们做进一步的了解，仔细看看 CSS-in-JS 在这几个方面分别带来了什么。

### 1.

#### **拥有作用域的样式**

众所周知，想要在大规模项目中高效地构建 CSS 是非常困难的。当加入一个需要长期维护的项目时，我们通常会发现 CSS 是系统中最复杂的部分。

为了解决这个问题，CSS 社区已经投入了巨大的努力，通过采用 [Nicole Sullivan](https://twitter.com/stubbornella) 提出的 [OOCSS](https://github.com/stubbornella/oocss/wiki) 和 [Jonathan Snook](https://twitter.com/snookca) 提出的 [SMACSS](https://smacss.com/) 都可以提高我们样式的可维护性。但是目前就流行程度而言，最佳的选择毫无争辩是 [Yandex](https://github.com/yandex) 提出的 [BEM](http://getbem.com) （Block Element Modifier）。

从根本上来说，BEM （纯粹用于 CSS 时）只是一个命名规范，它要求样式的类名要遵守 `.Block__element--modifier` 的模式。在任何使用 BEM 风格的代码库中，开发人员必须始终遵守 BEM 的规则。当被严格遵守时，BEM 的效果很好，但是为什么像作用域这种基础的东西，却只使用纯粹的**命名规范**来限制呢？

无论是否有明确表示，大多数 CSS-in-JS 类库的思路和 BEM 都很相似，它们努力将样式独立作用于单个 UI 组件，只不过他们用了完全不同的实现方式。

那么在实际代码中是什么样子呢？当使用 [Sunil Pai](https://twitter.com/threepointone) 开发的 [glamor](https://github.com/threepointone/glamor) 时，代码看起来像下面这样：

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

你可能会注意到**这段代码中没有 CSS 类**。样式不再是对系统其他地方定义的 class 的硬编码引用，而是由我们的工具库自动生成的。我们不必再担心选择器会在全局作用域里发生冲突，这也意味着我们不再需要替他们添加前缀了。

这个选择器的作用域与上下文代码的作用域一致。如果你希望在你应用的其他部分使用这个规则，你就需要将它转换成 JavaScript 模块并且在需要使用的地方引用它。就保持代码库的可维护性而言，这是非常强大的，**它确保了任何给定的样式都可以像其他代码一样容易追踪来源**。

**从仅仅靠命名约定来限制样式的作用域到默认强制局部作用域样式转变，我们已经提升了样式的基本能力。BEM 的功能已经被默认使用了，而不再是一个可选项。**
—

在我继续之前，我要澄清至关重要的一点。

**它生成的是真正的 CSS，而不是内联样式**

大多数早期的 CSS-in-JS 库都是将样式直接内联到每个元素上，但是这种模式有个严重的缺陷：'style' 属性并不能胜任所有 CSS 的功能。大多数新的 CSS-in-JS 库则侧重于**动态样式表**，在运行时从一个全局样式集中插入和删除规则。

举个例子，让我们看看由 [Oleg Slobodskoi](https://twitter.com/oleg008) 开发的 [JSS](https://github.com/cssinjs/jss)，这是最早生成**真正 CSS** 的 CSS-in-JS 库之一。

![](https://cdn-images-1.medium.com/max/1600/1*ltBvwbyvBt8OMdGZQOdMDA.png)

使用 JSS 时，你可以使用标准的 CSS 特性，比如 hover 和媒体查询，它们会映射成相应的 CSS 规则。

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

将这些样式插入到文档中后，你就可以使用那些自动生成的类名。

```
const { classes } = jss.createStyleSheet(styles).attach()
```

不管你是使用一个完整的框架，还是简单粗暴地使用 **innerHTML**，当用 **JavaScript** 生成 **HTML** 时，都可以使用这些生成的 **类** 代替硬编码的类名。

```
document.body.innerHTML = `
  <h1 class="${classes.heading}">Hello World!</h1>
`
```

但是单独使用这种方式管理样式并没有带来很大的优势，它通常需要和一些组件库搭配使用。因此，可以很容易找到适用于目前最流行库的绑定方案。例如，JSS 可以通过 [react-jss](https://github.com/cssinjs/react-jss) 的帮助轻松地绑定到 React 组件上，在管理生命周期的同时，它可以帮你给每个组件插入一个小的样式集。

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

通过代码层面上的紧密结合将我们的样式集中到组件上，我们得到了合乎 BEM 逻辑的结果。但是，CSS-in-JS 社区的许多人觉得提取、命名和复用组件的重要性在所有绑定样式的样板中都被遗弃了。

[Glen Maddern](https://twitter.com/glenmaddern) 和 [Max Stoiber](https://twitter.com/mxstbr) 提出了一个全新的思路来解决这个问题 —— [styled-components](https://github.com/styled-components/styled-components)。

![](https://cdn-images-1.medium.com/max/1600/1*l4nfMFKxfT4yNTWUK2Vsdg.png)

我们强制性地直接创建组件，而不是创建样式然后再手动地将他们绑定到组件上。

```
import styled from 'styled-components'

const Title = styled.h1`
  font-family: Comic Sans MS;
  color: blue;
`
```

在应用这些样式时，我们不会将 class 添加到一个现有的元素上，而是简单地渲染这些被生成的组件。

```
<Title>Hello World!</Title>
```

styled-components 通过模板字面量的方式来使用传统的 CSS 语法，但有人更喜欢使用数据结构。来自 [PayPal](https://github.com/paypal) 的 [Kent C. Dodds](https://twitter.com/kentcdodds) 所提供的 [Glamorous](https://github.com/paypal/glamorous) 是一个值得关注的替代方案。

![](https://cdn-images-1.medium.com/max/1600/1*Ere9GQTIJeNac2ONfZlfdw.png)

Glamorous 提供了与 styled-components 类似的组件优先的 API，但是他用**对象**替代了**字符串**。这样就无需在库中引入一个 CSS 解析器，从而可以降低库的大小并提升性能。

```
import glamorous from 'glamorous'

const Title = glamorous.h1({
  fontFamily: 'Comic Sans MS',
  color: 'blue'
})
```


无论你使用哪种语法来描述你的样式，他们都不再仅仅**作用于**某个组件，而是成为组件不可分割的一部分。当使用一个像 React 这样的库时，组件是基本的构建块，而现在我们的样式也成了构建这个架构的核心部分。**既然我们能将应用程序中的所有内容都描述为组件，那么为什么样式不行呢？**

—

对于那些有丰富 BEM 开发经验的工程师来说，我们对系统改造所带来的提升意义并不是很大。然而事实上，CSS Modules 让你在不用放弃所熟悉的 CSS 工具生态的同时获得了这些提升，这也是很多项目坚持使用 CSS Modules 的原因，他们可以在保持其常规 CSS 编码习惯的同时充分解决编写大规模 CSS 所遇到的问题。

然而，当我们开始在这些基本概念之上进行构建时，事情开始变得更有趣。

### 2.

#### 抽取关键 CSS

最近，在 document 的头部内联关键样式已经成为一种最佳实践，只提供当前页面所需的样式从而降低了首屏渲染时间。这与我们常用的样式加载方式形成了鲜明对比，之前我们通常会强制浏览器在渲染之前下载应用的所有样式。

虽然像 [Addy Osmani](https://twitter.com/addyosmani) 提供的 [critical](https://github.com/addyosmani/critical) 这类工具可以用于提取和内联关键 CSS，但是他们无法从根本上改变关键 CSS 难以维护和自动化的事实。这只是一个可选择用来做性能优化的奇技淫巧，所以大部分项目似乎放弃了这一步。

CSS-in-JS 则完全不同。

当你的应用使用服务端渲染时，提取关键 CSS 将不仅仅是优化，而是服务器端 CSS-in-JS 的首要工作。

举个例子，当使用 [Khan Academy](https://github.com/Khan) 开发的 [Aphrodite](https://github.com/Khan/aphrodite) 时，可以通过它的 `css` 函数来跟踪在这次渲染过程中使用的样式，并且将生成的 class 内联到元素上。

```
import { StyleSheet, css } from 'aphrodite'
const styles = StyleSheet.create({
  title: { ... }
})
const Heading = ({ children }) => (
  <h1 className={css(styles.heading)}>{ children }</h1>
)
```

即便你所有的样式都是在 JavaScript 中定义的，你也可以很轻松地提取当前页面所需要的所有样式并生成一个 CSS 字符串，在执行服务端渲染时将它们插入到 document 的头部。

```
import { StyleSheetServer } from 'aphrodite';

const { html, css } = StyleSheetServer.renderStatic(() => {
  return ReactDOMServer.renderToString(<App/>);
});
```

现在你可以像这样渲染你的关键 CSS 代码块：

```
const criticalCSS = `
  <style data-aphrodite>
    ${css.content}
  </style>
`;
```

如果你研究过 React 的服务端渲染模型，你可能会发现这个模式非常眼熟。在 React 中，你的组件是在 JavaScript 中定义他们的标签的，但却可以在服务器端渲染成常规的 HTML 字符串。

**如果你使用渐进增强的方式构建你的应用，即便整个项目可能全部是用 JavaScript 写的，客户端也可能根本就不需要 JavaScript。**

不管怎样，对于客户端运行的代码而言，其打包后的 bundle 都要包含启动单页应用所需要的代码。这些代码可以让页面瞬间活起来，浏览器中的渲染也是从这里开始的。

由于在服务器上渲染 HTML 和 CSS 是同时进行的，正如前面的例子所示，像 Aphrodite 这样的库通常会以一个函数调用的方式帮助我们流式生成关键 CSS 和服务端渲染的 HTML。现在，我们可以用类似的方式将我们的 React 组件渲染成静态 HTML。


```
const appHtml = `
  <div id="root">
    ${html}
  </div>
`
```

通过在服务器端使用 CSS-in-JS，我们的单页应用不仅可以脱离 JavaScript 工作，**它甚至可以渲染的更快**。

**正如有作用域的 CSS 选择器一样，渲染关键 CSS 这个最佳实践现在也是默认具备的能力了，而不是被选择性使用的**。

### 3.

#### 更智能的优化

我们最近看到了构建 CSS 的新方式的兴起，比如 [Yahoo](https://github.com/yahoo) 的 [Atomic CSS](https://acss.io/) 和 [Adam Morse](https://twitter.com/mrmrs_) 的 [Tachyons](http://tachyons.io/)，它们更推荐使用短小的、单一用途的 class，而不是语义化的 class。举个例子，当使用 Atomic CSS 时，你将使用类似于函数调用的语法来添加类名，并且它们会被用来生成合适的样式表。

```
<div class="Bgc(#0280ae.5) C(#fff) P(20px)">
  Atomic CSS
</div>
```

这种做法的目的是通过最大化地提高 class 的复用性，以及有效地将 class 像内联样式一样对待，lai确保打包出来的 CSS 尽可能的精简。虽然文件大小的减少很容易体现，但对于你的代码库和团队成员的影响似乎是微乎其微的。不过这些包含了对 CSS 和 HTML 更改的优化，由于其自身性质，成就了一个更具意义的架构。

正如我们之前介绍的那样，当使用 CSS-in-JS 或者 CSS Modules 时，你不再需要在 HTML 中硬编码你的 class，而是动态引用由库或者构建工具自动生成的 JavaScript 值。

我们不再这样写样式：

```
<aside className="sidebar" />
```

而是这样：

```
<aside className={styles.sidebar} />
```

这个变化表面上看起来也许没什么，但是从如何管理标记语言和样式之间的关系上来说，这却是一个里程碑式的改变。通过给予我们的 CSS 工具修改样式的能力，尤其是修改最终应用到元素上的 class 的能力，我们为样式表解锁了一个全新的优化方式。

如果看看上面的例子，就会发现 "styles.sidebar" 对应了一个字符串，但并没有限制它只能是一个单独的 class。我们都知道，它可以很容易地成为一个包含十几个 class 的字符串。

```
<aside className={styles.sidebar} />
// Could easily resolve to this:
<aside className={'class1 class2 class3 class4'} />
```

如果我们可以优化我们的样式，为每一套样式生成多个 class，我们就可以做一些真正有趣的事。

我最喜欢的例子是 [Ryan Tsao](https://twitter.com/rtsao) 编写的 [Styletron](https://github.com/rtsao/styletron)。

![](https://cdn-images-1.medium.com/max/1600/1*7xxb6FOmcmPCnQNrFy5pjg.png)

就像 CSS-in-JS 和 CSS Modules 自动添加 BEM 风格的前缀一样，Styletron 对 Atomic CSS 做了同样的事情。

它的核心 API 只专注于一件事 —— 为每个由属性、值、媒体查询组合起来的样式定义一个单独的 CSS 规则，然后返回一个自动生成的 class。

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

请注意上面生成的两组类名之间的相同点。

**通过放弃对 class 本身的低级控制，而仅定义所需要的样式，就可以让工具库帮我们生成最佳的原子 class 集合。**

![](https://cdn-images-1.medium.com/max/1600/1*pWXr1A6uhiOkYHqwfBMtWg.png)

过去我们只能通过手工查找的方式将样式拆分成可复用的 class，现在已经可以完全自动化的完成这种优化了。你应该也开始注意到这种趋势了。**原子 CSS 已经是默认具备的能力，而不再是被选择性使用的**。

### 4.

#### 打包管理

在深入讨论这一点之前，我们先停下来思考一个看似简单的问题。

**我们如何相互分享 CSS？**

我们已经从手动下载 CSS 文件转变为使用像 [Bower](https://bower.io) 这种前端特定的包管理工具，现在则可以通过 [npm](https://www.npmjs.com/) 使用 [Browserify](http://browserify.org/) 和 [webpack](https://webpack.js.org)。虽然这些工具已经可以自动引入外部依赖包里的 CSS，但是目前前端社区大多还是手动处理 CSS 的依赖关系。

无论使用哪种方式，你得清楚一件事：CSS 之间的依赖并不是很好处理。

正如许多人还记得的一样，在使用 Bower 和 npm 管理 **JavaScript 模块**时，出现过类似的情况。

Bower 没有指定任何特定的模块格式，而发布到 npm 的模块则要求使用 [CommonJS 模块格式](http://wiki.commonjs.org/wiki/Modules/1.1)。这种不一致，对发布到每个平台的包数量产生了巨大的影响。


规模小但是有嵌套依赖关系的模块更愿意使用 npm，Bower 则吸引了大型而又独立的模块，其中可能也就有两三个模块，再加几个插件。由于在 Bower 中你的依赖关系没有一个模块系统去作支撑，每个包无法轻松地利用它自己的依赖关系，所以在整合这一块，基本上就留给开发者手动去操作了。

因此，随着时间的推移，npm 上的模块数量呈指数性增长，而 Bower 只能是有限的线性增长。虽然这可能是各种原因导致的，但很公平地说，主要还是由每个平台是否允许模块在运行时互相引用导致的。

![](https://cdn-images-1.medium.com/max/1600/1*LTrsIISPV5qK-qAQKaeINA.png)

不幸的是，对于 CSS 社区来说这太熟悉了，我们发现相对于 npm 上的 JavaScript 包来说，独立的 CSS 模块的数量也增长的很慢。

如果我们也想实现 npm 的指数增长呢？如果我们想依赖不同大小不同层次的复杂模块，而不是专注于大型、全面的框架呢？为了做到这一点，我们不仅需要一个包管理器，还需要一个合适的模块格式。

这是否意味着我们需要专门为 CSS 或者 Sass 和 Less 这样的预处理器设计一个包管理工具？

真正有趣的是，我们已经通过 HTML 进行了类似的实现。如果你就如何分享 HTML 问我类似的问题，你可能马上就会意识到，我们几乎不会直接分享原始的 HTML —— 我们分享 **HTML-in-JS**。

我们通过 [jQuery 插件](https://plugins.jquery.com/)，[Angular 指令](http://ngmodules.org) 和 [React 组件](https://react.parts/web)来实现这个功能。我们的大组件是由一些独立发布在 npm 上，包含自己 HTML 的小组件组成的。原生 HTML 格式也许没有这种能力，但是**通过将 HTML 嵌入到完整的编程语言中**，我们就可以很轻松的突破这个限制。

如果我们像 HTML 那样，通过 JavaScript 去分享以及生成 CSS 呢？能不能使用**返回对象和字符串的函数**而不是使用 [mixins](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#mixins) ？又或者我们利用  [Object.assign](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Object/assign) 和新的 [object spread 操作符](https://github.com/tc39/proposal-object-rest-spread) 来 **merge 对象**而不是用 [extending classes](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#extend) 呢？

```
const styles = {
  ...rules,
  ...moreRules,
  fontFamily: 'Comic Sans MS',
  color: 'blue'
}
```

一旦我们开始用这种方式编写我们的样式，我们就可以使用相同的模式、相同的工具、相同的基础架构、相同的生态系统来编写和分享我们的样式代码，就像我们应用程序中的任何其他代码一样。

由 [Max Stoiber](https://twitter.com/mxstbr)、[Nik Graf](https://twitter.com/nikgraf) 和 [Brian Hough](https://twitter.com/b_hough) 提供的 [Polished](https://github.com/styled-components/polished) 就是一个你如何从中受益的良好示例。 

![](https://cdn-images-1.medium.com/max/1600/1*fczf3OWmmKBkFgtUqZnq2g.png)

Polished 就像是 CSS-in-JS 界的 [Lodash](https://lodash.com)，它提供了一整套完整的 mixins、颜色函数、一些速写方法等等，使得那些使用 [Sass](http://sass-lang.com) 的开发者可以熟练地在 JavaScript 中编写样式。现在有一个最大的区别就是这些代码在复用、测试和分享方面，都提高了一个层级，并且能够完整的使用 JavaScript 模块生态系统。

那么，当谈到 CSS 时，我们如何获得和 npm 上其他模块相似的开源程度，以及如何用一些小的可复用的开源包组合成大型样式集合？奇怪的是，我们最终可以通过将我们的 CSS 嵌入另一种语言并且完全拥抱 JavaScript 模块实现了这一点。

### 5.

#### 在非浏览器环境下的样式

到目前为止，我的文章已经涵盖了所有的要点，虽然在 JavaScript 中编写 CSS 会更加便捷，但是常规的 CSS 也可以实现这些功能。这也是我把最有趣、最面向未来的一点留到现在的原因。也许它不一定能在如今的 CSS-in-JS 社区中发挥巨大的作用，但它可能会成为设计领域未来发展的基石。它不仅会影响开发人员，也会影响设计师，最终它将改变这两个领域相互沟通的方式。

为了引入它，我先简单介绍一下 React。
—

React 的理念是用组件作为最终渲染的中间层。在浏览器中工作时，我们构建复杂的虚拟 DOM 树而不是直接操作 DOM 元素。

有趣的是，DOM 渲染相关的代码并不属于 React 的核心部分，而是由 **react-dom** 提供的。

```
import { render } from 'react-dom'
```

尽管最初 React 是为 DOM 设计的，并且大部分情况下还是在浏览器中使用，但是这种模式也允许 React 通过简单地引入新的渲染引擎就能从容面对各种不同的使用环境。

JSX 不仅仅可以用于虚拟 DOM，他可以用在任何的虚拟视图上。

这就是 [React Native](https://facebook.github.io/react-native) 的工作原理，我们通过编写那些渲染成 native 的组件以实现用 JavaScript 编写真正的 native 应用，比如我们用 **View** 和 **Text** 取代了 **div** 和 **span**。

从 CSS 的角度来看，React Native 最有趣的就是它拥有自己特有的 [StyleSheet API](https://facebook.github.io/react-native/docs/stylesheet.html)：

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


这里你会看到一组熟悉的样式，在这种情况下可以覆盖颜色、字体和边框样式。

这些规则都非常简单，并且很容易映射到大部分的 UI 环境上，但是当涉及到 native 布局时，事情就变得非常有趣了。

```
var styles = StyleSheet.create({
  container: {
    display: 'flex'
  }
})
```

尽管运行在浏览器环境之外，**React Native 有自己的 [flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes) 的 native 实现**

最初发布时它是一个名为 [css-layout](https://www.npmjs.com/package/css-layout) 的 JavaScript 模块，完全用 JavaScript 重新实现了 flexbox（包含充分的测试），为了更好的可移植性它现在已经迁移到 C 语言。

鉴于这个项目的影响力和重要性，它被赋予了一个独立的重要品牌 ——— [Yoga](https://facebook.github.io/yoga)。

![](https://cdn-images-1.medium.com/max/1600/1*mv_hHmbOgU7SOd5t2J2Q2g.png)

即使 Yoga 完全是为了把 CSS 概念移植到非浏览器环境而生，但通过仅仅专注 CSS 特性的子集，它已经统治了一些潜在的其他领域。

> "Yoga 的重点是成为一个有表现力的布局框架，而不是去实现一套完整的 CSS"

这看起来似乎很难实现，但是当你回顾 CSS 体系的历史时会发现**使用 CSS 进行规模化的工作就是选择一个合适的语言子集**。

在 Yoga 的例子里，他们避免了层叠样式，因为这样有利于控制样式的作用域，并且将布局引擎完全集中在 flexbox 上。虽然这样会丧失很多功能，但它也为那些需要嵌入样式的跨平台组件创造了惊人的机会，我们已经发现几个试图利用这个特性的开源项目。

[Nicolas Gallagher](https://twitter.com/necolas) 开发的 [React Native for Web](https://github.com/necolas/react-native-web) 旨在成为 react-native 的一个替代品。当使用 webpack 这类打包工具时，可以利用 alias 轻松替换第三方库。

```
module: {
  alias: {
    'react-native': 'react-native-web'
  }
}
```


使用 React Native for Web 后可以在浏览器环境中使用 React Native 组件，包括 [React Native StyleSheet API](https://facebook.github.io/react-native/docs/stylesheet.html) 的浏览器部分。

同样，[Leland Richardson](https://twitter.com/intelligibabble) 开发的 [react-primitives](https://github.com/lelandrichardson/react-primitives) 也提供了一套跨平台的基础组件集合，它根据目标平台来抽象具体的实现细节，为跨平台组件创造可行的标准。

甚至 [微软](https://github.com/Microsoft) 也推出了 [ReactXP](https://microsoft.github.io/reactxp)，这个库旨在简化跨 web 和 native 的工作流，它也有自己的[跨平台样式实现](https://microsoft.github.io/reactxp/docs/styles.html)。

—

即使你不为 native 应用程序编写代码，也有很重要的一点要注意：拥有一个真正的跨平台的组件抽象，能够帮我们有针对性地应对各种各样的环境，有时你都无法预测会遇到哪些情况。

我所见过的最令人震惊的例子是 [Airbnb](https://github.com/airbnb) 的 [Jon Gold](https://twitter.com/jongold) 开发的 [react-sketchapp](http://airbnb.io/react-sketchapp)。

![](https://cdn-images-1.medium.com/max/1600/1*qfskIhHAWpYwfR5Lz0_cIA.png)

我们中很多人都花费了大量时间去尝试标准化我们的设计语言，并且尽可能的避免系统中的重复部分。不幸的是，尽管我们希望样式是唯一的，但我们最少也会有两个来源 —— **开发人员的动态样式以及设计师的静态样式**。虽然这已经比我们之前的模式好了很多，但是它仍然需要我们手工的将样式从 [Sketch](https://www.sketchapp.com) 这样的设计工具同步到代码里。这也是 react-sketchapp 被开发出来的原因。

感谢 Sketch 的 [JavaScript API](http://developer.sketchapp.com/reference/api)，以及 React 与不同渲染引擎相连的能力，react-sketchapp 让我们可以利用跨平台的 React 组件并在 Sketch 文档里渲染他们。
![](https://cdn-images-1.medium.com/max/1600/1*v2L1DB8OS38GScyBRFD8hQ.png)

不必多说，这很可能改变设计师和开发人员的合作方式。现在，当我们对设计进行迭代时，无论在设计工具还是开发者工具上，我们都可以通过相同的声明引用同一个组件。

通过 [Sketch 中的 symbols](https://www.sketchapp.com/learn/documentation/symbols)和 [React 中的组件](https://facebook.github.io/react/docs/components-and-props.html)，我们的行业从本质上开始汇合成同一个抽象，并且通过分享相同的工具我们可以更紧密的协作。

这么多新的尝试都来自 React 和其周边的社区，这并不是巧合。

在组件架构中，优先级最高的就是将组件的关注点集中在一起。这自然包括它的局部作用域样式，也要感谢 [Relay](https://facebook.github.io/relay) 和 [Apollo](http://dev.apollodata.com) 这两个库，他们让我们可以往数据获取这些更复杂的方向延伸。结果就是他们释放了巨大的潜力，而我们现在所了解的，只是其中冰山一角。

这对我们的样式编写以及架构中的任何部分都产生了积极的影响。

通过将我们开发组件的模式统一到单一语言上，我们能够从功能上，而不是从技术上，将我们的关注点进行更好的分离。比如我们可以将组件的所有内容都限制在自己的作用域内，从他们扩展成大型的可维护的系统，用之前无法使用的方式进行优化，更便捷的分享我们的工作，以及利用小型开源模块构建大型应用程序。更重要的是，我们依然遵循渐进增强的理念，也不会放弃那些被认为是认真对待 web 平台的理念。

最重要的是，我对使用单一语言编写出的组件的潜力感到兴奋，他们形成了一种新的、统一的样式语言基础，并以一种前所未有的方式统一了前端社区。

在 SEEK，我们正在努力利用这一特性，我们围绕组件模型来构建在线样式指南，其中语义化、交互和视觉风格都统一在一个单独的抽象中。这形成了开发人员和设计师之间共享的通用设计语言。

构建一个页面应该尽可能的和拼装组件一样简单，这样可以确保我们的工作保持较高的质量，并且允许我们在产品上线很久后也有能力去升级其设计语言。

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

尽管我们的样式指南是用 React、webpack 和 CSS Modules 构建的，但该架构恰好反映了在使用 CSS-in-JS 构建的任何系统中您都需要注意哪些。技术选型可能有不同，但是核心理念是一样的。

然而，未来这些技术选型可能会以一种意想不到的方式进行转变，因此关注这个领域对于我们组件生态系统的持续发展至关重要。我们现在可能不会用 CSS-in-JS 这项技术，但是很可能没过多久就会出现一个令人信服的理由让我们使用它。

CSS-in-JS 在短时间里已经有了出人意料的发展，但更重要的是，它只是这个宏伟蓝图的开始。

它还有很大的改进空间，并且它的创新还没有停止的迹象。新的库正不断涌现，它们解决了未来会出现的问题并且提升了开发人员的体验 —— 比如性能的提升、在构建时抽取静态 CSS、支持 CSS 变量以及降低了前端开发人员的入门门槛。

这也是 CSS 社区的准入门槛。无论他们对我们的工作流程有多大的改动，**都不会改变你仍然需要学习 CSS 的事实**。

我们可能使用不同的语法，也可能以不同的方式构建我们的应用，但是 CSS 的基本构建块不会改变。同样，我们行业向组件架构的转变是不可避免的，通过这种方式重新构思前端开发的意愿只会越来越强烈。我们非常需要共同合作以确保我们的解决方案可以广泛适用于各种背景的开发人员，无论是专注于设计的，工程的或者对这两方面都很关注的开发者。

虽然有时我们的观点不一致，但是 CSS 和 JS 社区对于改进前端，更加认真地对待 Web 平台以及改进我们下一代 web 开发流程都有很大的热情。社区的潜力是巨大的，而且到目前为止，尽管我们已经解决了大量的问题，仍然有很多工作还没有完成。

到这里，可能你依然没有被说服，但是没关系。虽然现在在工作上使用 CSS-in-JS 并不是很合理，但我希望它有合适的原因，而不是仅仅因为语法就反对它。

无论如何，未来几年这种编写样式的方式可能会越来越流行，并且值得关注的是它发展的非常快。我衷心希望你可以加入我们，无论是通过贡献代码还是**简单地参与我们的对话讨论**，都能使下一代 CSS 工具尽可能有效地服务于所有前端开发人员。或者，至少我希望我已经让你们了解了为什么人们对这一块如此饱含激情，或者，至少了解为什么这不是一个愚蠢的点子。

这篇文章是我在德国柏林参加 CSSconf EU 2017 做相同主题演讲时撰写的，并且现在可以在 [YouTube](https://www.youtube.com/watch?v=X_uTCnaRe94) 上看到相关视频。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


