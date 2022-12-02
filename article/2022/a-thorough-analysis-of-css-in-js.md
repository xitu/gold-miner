> * 原文地址：[A Thorough Analysis of CSS-in-JS](https://css-tricks.com/a-thorough-analysis-of-css-in-js/)
> * 原文作者：[Andrei Pfeiffer](https://css-tricks.com/author/andreipfeiffer/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/a-thorough-analysis-of-css-in-js.md](https://github.com/xitu/gold-miner/blob/master/article/2022/a-thorough-analysis-of-css-in-js.md)
> * 译者：[tong-h](https://github.com/Tong-H)
> * 校对者：[Quincy-Ye](https://github.com/Quincy-Ye)[DylanXie123](https://github.com/DylanXie123)

# 深入分析 CSS-in-JS


比选择一个 JavaScript 框架更有挑战的是什么呢？你猜对了：选择一个 CSS-in-JS 方案。为什么？因为现在已经有 [50 个以上的库](http://michelebertoli.github.io/css-in-js/)，而且每个库都有独一无二的特色。

我们测试了 [10 个不同的库](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#overview)（排列没有特定的顺序）：[Styled JSX](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#styled-jsx)、[styled-components](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#styled-components)、[Emotion](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#emotion)、[Treat](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#treat)、[TypeStyle](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#typestyle)、[Fela](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#fela)、[Stitches](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#stitches)、[JSS](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#jss)、[Goober](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#goober) 以及 [Compiled](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#compiled)。我们发现，尽管每一个库都提供了一系列不同的功能，但事实上很多功能和其他的库是一样的。

所以比起单独评估每一个库，我们会分析最突出的功能。这可以帮助我们更好地理解，在特定的使用场景下哪一个库最适合。

**注意**：在这篇文章里，我们假定你已经熟悉 CSS-in-JS 了。如果你想寻找一篇更基础的文章，可以看下 [CSS-in-JS 简介](https://webdesign.tutsplus.com/articles/an-introduction-to-css-in-js-examples-pros-and-cons--cms-33574)

## 常见的 CSS-in-JS 特性

大多数积极维护的处理 CSS-in-JS 的库都支持以下功能，所以我们可以把这些功能视为事实。

### 有作用域的 CSS

这是 **CSS 模块**开创的一项技术，所有的 CSS-in-JS 库都会生成独一无二的 CSS class 名。在不影响其他定义于组件之外的样式的情况下的组件样式封装，使其样式只作用于各自的组件。

有了这个内置功能，我们再也不用担心 CSS 类名重名，特性冲突，或者为了想一个整个代码库中独特的类名而耗费时间。

这个特性对基于组件的开发非常宝贵。

### SSR (服务端渲染)

在单页面应用（SPAs）里，HTTP 服务只提供基础的空白 HTML 页面，所有的渲染都由浏览器执行。相比之下，在服务端渲染（SSR）可能不是很有用。但，任何需要被搜索引擎**解析和索引**的网站或应用都必须有 SSR 页面，而样式也需要在服务端生成。

与适用于静态网站生成器（SSG）的原则一样，页面会与CSS代码在打包时一起预先生成，用作静态 HTML 文件。

好消息是**我们测试过的所有库都支持 SSR**，这使得它们几乎适用于所有类型的项目。

### 自动添加浏览器引擎前缀

由于复杂的 [CSS 标准化流程](https://www.youtube.com/watch?v=TQ7NqpFMbFs)，任何新的 CSS 功能可能需要几年时间才能在所有流行的浏览器中使用。在非标准的 CSS 语法前添加[浏览器引擎前缀](https://developer.mozilla.org/en-US/docs/Glossary/Vendor_Prefix)是一种使我们提前使用实验性功能的方法：

```css
/* WebKit 浏览器：Chrome, Safari, most iOS browsers, 等等 */
-webkit-transition: all 1s ease;

/* Firefox */
-moz-transition: all 1s ease;

/* Internet Explorer 和 Microsoft Edge */
-ms-transition: all 1s ease;

/* Opera 的旧 pre-WebKit 版本 */
-o-transition: all 1s ease;

/* 标准格式 */
transition: all 1s ease; 
```

然而，事实证明[添加浏览器引擎前缀是有问题的](https://css-tricks.com/is-vendor-prefixing-dead/)，CSS 工作组打算在未来停止使用这种方式。如果我们想要完全支持那些没有实施标准规范的旧浏览器，那我们需要知道[哪些功能要求添加浏览器引擎前缀](http://shouldiprefix.com/)。

幸运的是，有一些工具通过自动生成携带浏览器引擎前缀的 CSS 属性，让我们可以在源代码中使用标准语法。**所有的 CSS-in-JS 库都提供该功能，开箱即用**。

### 没有内联样式

一些 CSS-in-JS 库，比如 Radium 或 Glamor，将所有样式的定义以内联样式的方式输出。这种技术有巨大的局限性，因为无法通过内联样式来定义伪类、伪元素或者媒体查询。所以，这些库不得不通过添加 DOM 事件监听以及从 JavaScript 中触发样式更新的方式来处理这些功能，本质上是重新创建例如 `:hover`、 `:focus` 之类的原生 CSS 功能。

人们普遍认为，内联样式的性能比 class [性能更差](https://esbench.com/bench/5908f78199634800a0347e94)。使用内联样式作为主要的方式为组件定义样式通常是一种[不鼓励的做法](https://reactjs.org/docs/dom-elements.html#style) .

**目前所有的 CSS-in-JS 库都不再使用内联样式**，而是采用 CSS class 的方式来定义样式。

### 全面的 CSS 支持

使用 CSS class 而不是内联样式的结果是，[CSS 属性](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference) 的使用没有限制。在分析期间，我们主要感兴趣的是：

* 伪类和伪元素
* 媒体查询
* 关键帧动画

*我们分析过的所有库都全面支持所有的 CSS 属性。**

## 差异化特征

这就是变得更有趣的地方。几乎每个库都提供了一套独具特色的功能，在为特定项目选择合适的解决方案时，这些功能会大大的影响我们的决定。一些库开创了一个特别的功能，而其他库可以选择借用甚至改进某些功能。

### 特定于 React 还是与框架无关？

CSS-in-JS 在 React 生态圈中更流行，这并不是秘密。 这也是为什么有些库是 **特别为 React 构建**：[**Styled JSX**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#styled-jsx)，[**styled-components**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#styled-components)，以及 [**Stitches**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#stitches)。

但也有很多库是 **无关框架的**，这使得它们可以应用于所有项目： [**Emotion**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#emotion)，[**Treat**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#treat)，[**TypeStyle**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#typestyle)，[**Fela**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#fela)，[**JSS**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#jss) 或 [**Goober**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#goober)。

如果我们需要支持原生 JavaScript 代码或者其他非 React 的框架，那决定就很简单：我们应该选择一个无关框架的库。但针对 React 应用，我们有更广泛的选择，那做决定就比较困难了。那就让我们来探索一下其他标准吧。

### 样式/组件并置

跟随组件定义样式是非常便利的功能，这样就不需要在两个不同的文件中反复切换：包含样式的 `.css` 或 `.less` / `.scss` 文件，与包含指令和行为的组件文件。

[React Native StyleSheets](https://reactnative.dev/docs/stylesheet)、[Vue.js SFCs](https://vuejs.org/v2/guide/single-file-components.html) 或者 [Angular Components](https://angular.io/guide/component-styles) 默认支持样式共置，不论是开发还是维护阶段都能真正从中受益。我们依然可以选择将样式提取到一个单独的文件中，以防我们觉得它们掩盖了代码的其他部分。

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/aKsPahlPZ8qr6R8aVCancNsC_LOuKlcpBo-Ys44a1ya3QDvoLabbiBTYf36xX90hAfgMxgvBjMxxuBgIGnzH-_NId-71NfK7hh-ZFBJizZF6l3A4sLgb2vyYKgwnod86YBoLsE4.png?resize=800%2C589&ssl=1)

几乎所有的 CSS-in-JS 库都支持样式的共置。我们遇到的唯一一个例外是 [**Treat**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#treat)，类似于 CSS Modules 的工作原理，它要求我们在一个单独的 `.treat.ts` 文件中定义样式。

### 样式定义的语法

我们可以用两种不同的方式来定义我们的样式。有些库只支持一种方法，而有些库则相当灵活，同时支持这两种方法。

#### 标签模板语法

**标签模板**语法让我们可以将样式定义为标准 [ES 模板字面量](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)内的一串普通 CSS 代码。

```js
// 将 "css " 视作一个通用的 CSS-in-JS 库的 API
const heading = css`
  font-size: 2em;
  color: ${myTheme.color};
`;
```

我们可以发现：

* CSS 属性就像普通的 CSS 一样用 kebab-case （短横线命名）编写。
* 可以对 JavaScript 值进行插值替换。
* 我们可以很容易地迁移现有的 CSS 代码，而不需要重写它。

需要记住：

* 为了获得**语法高亮和**代码提示**，还需要一个额外的编辑器插件。这个插件通常可用于流行的编辑器，如 VSCode、WebStorm 等等。
* 由于最终的代码必须由 JavaScript 执行，所以样式定义需要被**解析并转换为 JavaScript 代码**。这可以在运行时或者构建时完成，对应的会在在包大小或计算上产生少量的开销。

#### 样式对象语法

**样式对象** 语法使我们可以像定义普通 JavaScript 对象一样定义样式：

```js
// 将 "css " 视作一个通用的 CSS-in-JS 库的 API
const heading = css({
  fontSize: "2em",
  color: myTheme.color,
});
```

我们可以发现：

* CSS 属性用 camel-case （驼峰命令）书写，字符串值必须用引号包裹。
* JavaScript 值可以像预期的那样被引用。
* **样式**定义的语法有点差异，感觉好像不是在写 CSS，但又与 CSS 中的属性名和值相同（不要被这个吓到，你很快就会习惯的）。
* 迁移现有的 CSS 需要用这种新的语法重写。

需要记住：

* **语法高亮** 是开箱即用的功能，因为我们实际上是在写 JavaScript 代码.
* *为了**代码补全**功能，该库必须装载 CSS 类型定义，其中大部分是扩展了通用的类型包 [CSSType](https://www.npmjs.com/package/csstype)。
* 因为样式已经是用 JavaScript 写好了，所以不需要额外的解析或转换。

| 库 | 标签模板 | 样式对象 |
| --- | --- | --- |
| styled-components | ✅ | ✅ |
| Emotion | ✅ | ✅ |
| Goober | ✅ | ✅ |
| Compiled | ✅ | ✅ |
| Fela | 🟠 | ✅ |
| JSS | 🟠 | ✅ |
| Treat | ❌ | ✅ |
| TypeStyle | ❌ | ✅ |
| Stitches | ❌ | ✅ |
| Styled JSX | ✅ | ❌ |

> ✅  全面支持         🟠  插件要求          ❌  不支持

### 样式应用方式

现在我们知道有哪些可用的样式定义选项，让我们看看如何将它们应用于我们的组件和元素。

#### 使用 class 属性 / className prop

最简单和最直观的应用样式的方式是将它们与 class 名关联。支持这种方法的库提供一个 API，返回生成的唯一的 class 名。

```js
// 将 "css " 视作一个通用的 CSS-in-JS 库的 API
const heading_style = css({
  color: "blue"
});
```

`heading_style` 包含一串自动生成的 CSS class 名，接下来我们可以把 `heading_style` 应用于我们的 HTML 元素。

```js
// 原生 DOM 使用方式
const heading = `<h1 class="${heading_style}">Title</h1>`;

// 特定于 React 的 JSX 使用方式
function Heading() {
  return <h1 className={heading_style}>Title</h1>;
}
```

正如我们所看到的，这种方法与传统的样式使用方法非常相似：首先我们定义样式，然后在我们需要的地方使用。这对于以前写过 CSS 的人来说，学习曲线很低。

#### 使用一个 `<Styled />` 组件

另一种流行的方法是由 [styled-components](https://styled-components.com/docs/basics#getting-started) 库首先引入的（并以其命名），它采取了一种不同的方法。

```js
// 将 "styled " 视作一个通用的 CSS-in-JS 库的 API
const Heading = styled("h1")({
  color: "blue"
});
```

比起单独定义样式并将它们添加到现有的组件或 HTML 元素上，我们倾向于通过指定要创建的元素类型和要添加的样式来使用一个特殊的 API。

这个 API 将**返回一个已经应用了类名的新组件**，我们可以像渲染我们的应用程序中的其他组件一样进行渲染。这基本上就删除了组件和其样式之间的映射关系。

#### 使用 `css` prop

一种较新的方法，由 [Emotion](https://emotion.sh/docs/css-prop) 推广，使我们可以将样式传递给一个特殊的 prop，通常名为 `css`。这个 API 只适用于基于 JSX 的语法。

```js
// 针对于 React JSX 语法
function Heading() {
  return <h1 css={{ color: "blue" }}>Title</h1>;
}
```

这种方法有一定的人性化优势，因为我们不需要从库导入和使用任何特殊的API。我们可以简单地将样式传递给这个 `css` prop，就像我们使用内联样式一样。

请注意，这个自定义的 `css` prop 不是一个标准的 HTML 属性，需要通过库提供的单独的 Babel 插件来启用和支持。

| 库 | 标签模板 | 对象样式 |
| --- | --- | --- |
| styled-components | ✅ | ✅ |
| Emotion | ✅ | ✅ |
| Goober | ✅ | ✅ |
| Compiled | ✅ | ✅ |
| Fela | 🟠 | ✅ |
| JSS | 🟠 | ✅ |
| Treat | ❌ | ✅ |
| TypeStyle | ❌ | ✅ |
| Stitches | ❌ | ✅ |
| Styled JSX | ✅ | ❌ |

> ✅  全面支持         🟠  插件要求          ❌  不支持

| 库 | `className` | `<Styled />` | `css` prop |
| --- | --- | --- | --- |
| styled-components | ❌ | ✅ | ✅ |
| Emotion | ✅ | ✅ | ✅ |
| Goober | ✅ | ✅ | 🟠 2 |
| Compiled | 🟠 1 | ✅ | ✅ |
| Fela | ✅ | ❌ | ❌ |
| JSS | ✅ | 🟠 2 | ❌ |
| Treat | ✅ | ❌ | ❌ |
| TypeStyle | ✅ | ❌ | ❌ |
| Stitches | ✅ | ✅ | 🟠 1 |
| Styled JSX | ✅ | ❌ | ❌ |

> ✅  全面支持         🟠 1  支持受限          🟠 2  插件要求          ❌  不支持

### 样式输出

这里有两种互斥的方法可以生成并向浏览器发送样式。这两种方法都有好处和坏处，所以让我们详细分析一下。

#### `<style>`- DOM 样式注入

大部分 CSS-in-JS 库会在运行时向 DOM 注入样式，使用一个或多个 [`<style>` 标签](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#1-using-style-tags)，或使用 [`CSSStyleSheet`](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#2-using-cssstylesheet-api) API 直接在 CSSOM 中管理样式。在 SSR 中，样式总是作为 `<style>` 标签添加在需要渲染的 HTML 页面的 `<head>` 中。

这种方法有几个**关键优势**和**首选用例**：

1. 在 SSR 中内嵌样式可以 [提高网页加载性能指标](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#2-style-tag-injected-styles)，比如 **FCP** (First Contentful Paint)，因为从服务器上获取单独的 `.css` 文件不会阻碍渲染。
2. SSR 项目中，通过内联初始 HTML 渲染所需的样式，达到了开箱即用的[**关键 CSS 提取**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#-critical-css-extraction)。它还删除了动态样式，从而通过下载更少的代码进一步改善加载时间。
3. **动态样式**通常更容易实现，这种方法似乎更适用于高交互性的用户界面和**单页应用（SPA）**，因为 SPA 应用中的大多数组件都是**客户端渲染。

弊端一般与总包大小有关：

* 需要一个额外的**运行时库**来处理浏览器中的动态样式。
* 内联的 SSR 样式不会被直接缓存，它们需要在每次请求时被传送到浏览器，因为它们属于服务器渲染的 `.html` 文件的一部分。
* 在 `.html` 页面中内联的 SSR 样式将在 [rehydration](https://developers.google.com/web/updates/2019/02/rendering-on-the-web#rehydration-issues) 过程中作为 JavaScript 资源再次发送到浏览器。

#### 静态 `.css` 文件提取

有极少数的库采取了完全不同的方法。相比于往 DOM 中注入样式，他们选择去生成静态的 `.css` 文件。从加载性能的角度来看，优缺点与编写普通 CSS 文件是一样的。

1.由于不再需要额外的运行时代码或 Rehydration 开销，所以**传输的代码总量要小很多**。
2.静态的 `.css` 文件受益于浏览器内部开箱即用的缓存，因此同一页面的后续请求不会再次去服务器请求该样式。
3.这种方法对 **SSR 页面**或**静态生成的页面**似乎更有帮助，因为它们受益于默认的缓存机制。

然而，有一些重要的弊端我们需要注意一下：

* 和前面提到的几种方法相比，使用这个方法，在没有缓存的情况下第一次访问该页面会有较长的 [**FCP**](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#1-css-file-extraction)。因此，是为**首次访问的用户**还是为**再次访问的用户**进行优化，这个因素对是否选择这种方法起到至关重要的作用。
* 所有会在页面上使用的动态样式都将包含在预先生成的包中，这可能会导致前台需要加载更大的 `.css` 资源。

我们测试过的所有库，几乎都实施了第一种方法，将样式注入到 DOM 中，其中唯一支持静态 `.css` 文件提取的库是 [Treat](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#treat)。也有些其他的支持这个功能的库，比如 [Astroturf](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#astroturf)，[Linaria](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#linaria)，和没有包含在我们最后分析中的 [style9](https://github.com/andreipfeiffer/css-in-js/blob/main/README.md#style9)。

### Atomic CSS（原子化 CSS）

有些库为了进一步优化，实现了一种技术叫做 [**Atomic CSS-in-JS（原子化 CSS）**](https://sebastienlorber.com/atomic-css-in-js)，其灵感来自 [Tachyons](https://tachyons.io/) 或 [Tailwind](https://tailwindcss.com/)这样的框架。

相比于为某个的标签定义一个包含所有属性的 CSS class，Atomic CSS 为每一个的 CSS 键值对生成一个唯一的 CSS class。

```css
/* 非 Atomic CSS class */
._wqdGktJ {
  color: blue;
  display: block;
  padding: 1em 2em;
}

/* Atomic CSS class */
._ktJqdG { color: blue; }
._garIHZ { display: block; }
/* 简写的属性通常会被展开 */
._kZbibd { padding-right: 2em; }
._jcgYzk { padding-left: 2em; }
._ekAjen { padding-bottom: 1em; }
._ibmHGN { padding-top: 1em; }
```

每一个单独的 CSS class 都可以在代码库任何地方复用，这大大提高了复用率。

理论上，这个方法很适合大型应用。为什么？因为整个应用所需的 CSS 属性是有限的，所以增长规模是**对数型**，而非线性。因此 Atomic CSS 比非 Atomic CSS 输出的 CSS 代码更少。

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/kwyuFPAdFlkMaYo7vYFufdUG3WP4mp7_bbAsQnU7sVCnGH31dDmSgYp5KHqX4tQQR60KfzWV890kBXDPC68H4rLuYvMeVEhItg_oBFt59mCJmsN8giiB6HogBD9F7h6p2aMbs7Q.png?resize=800%2C449&ssl=1)

但是这里有个隐患：单独的 class 名必须应用于每一个需要它们的元素，这会导致 HTML 文件更大些：

```html
<!-- 非 Atomic CSS class -->
<h1 class="_wqdGktJ">...</h1>

<!-- Atomic CSS class -->
<h1 class="_ktJqdG _garIHZ _kZbibd _jcgYzk _ekAjen _ibmHGN">...</h1>
```

所以基本上，我们是把代码从 CSS 转移到 HTML 。由此产生的大小差异取决于太多方面，我们无法得出一个明确的结论。但总的来说，Atomic CSS **应该会减少**传输给浏览器的总字节量。

## 结论

CSS-in-JS 将极大地改变我们编写 CSS 的方式，可以提供许多好处以及改善我们的整体开发体验。

然而，选择采用哪个库并不简单，所有的选择都伴随着许多技术上的妥协。为了识别最适合我们需求的库，我们必须了解项目要求以及库的使用情况：

* **我们是否使用 React？** React 应用有更广泛的选择，而非 React 的解决方案需要使用无关框架的库。
* **我们是否在处理一个高互动性的应用，并在客户端进行渲染？** 在这种情况下，我们可能不是很关心 Rehydration 的开销以及静态的 `.css` 文件的提取。
* **我们是否要用 SSR 建立一个动态网站？** 那么，静态 `.css` 文件提取可能是一个更好的选择，因为它可以让我们从缓存中受益。
* **我们需要迁移现有的 CSS 代码吗？** 使用支持标签模板的库会使迁移更快更容易。
* **我们要优化首次访问或再次访问的用户体验吗？** 通过资源缓存，静态的 `.css` 文件为再次访问的用户提供最好的体验，但首次访问需要一个额外的 HTTP 请求，这会阻碍页面渲染。
* ***我们是否频繁更新样式？** 如果我们频繁更新样式，导致缓存失效，那么 `.css` 文件缓存就毫无价值。
* **我们是否重复使用大量的样式和组件？** 如果我们在代码库中重复使用大量的 CSS 属性，Atomic CSS 将大放异彩。

回答上述问题可以帮助我们明确，在选择 CSS-in-JS 的解决方案时应该关注哪些特性，使我们能够做出更有根据的决定。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
