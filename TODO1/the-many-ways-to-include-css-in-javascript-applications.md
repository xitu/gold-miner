> * 原文地址：[The Many Ways to Include CSS in JavaScript Applications](https://css-tricks.com/the-many-ways-to-include-css-in-javascript-applications/)
> * 原文作者：[Dominic Magnifico](https://css-tricks.com/author/dominicmagnifico/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-many-ways-to-include-css-in-javascript-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-many-ways-to-include-css-in-javascript-applications.md)
> * 译者：[逆。寒](https://github.com/thisisandy)、[lsvih](https://github.com/lsvih)
> * 校对者：[HeroXiaozheng](https://github.com/HeroXiaozheng)、[Chorer](https://github.com/Chorer)

# Javascript 应用中引入 CSS 的几种方式

![](https://res.cloudinary.com/css-tricks/image/fetch/w_1200,q_auto,f_auto/https://css-tricks.com/wp-content/uploads/2017/06/css-vs-js.png)

欢迎你踏上了一条在前端世界中饱含争议的道路！相信大部分读者会在关于如何[在 JavaScript 应用中处理 CSS](https://css-tricks.com/tag/css-in-js/) 这一话题上产生共鸣。

文章伊始，先声明一句：**无论是在基于 Vue、Angular 还是 React 构建的应用，针对如何处理 CSS，世界上并没有任何放之四海而皆准的方法。**各个项目皆有不同，每种方式也有可取之处！可能这么说显得含糊其辞，但就我所知，在我们的开发社区内，那些追寻新知识，推动网页开发向前发展的人举目皆是。

让我们放下对本文话题的感性认知，先领会下 CSS 世界架构的奇妙之处。

### 让我们盘点一番引入 CSS 的方式

单单谷歌一下“如何在框架内加入 CSS”，各种言辞凿凿的关于如何在项目中应用样式的观点和看法便映入眼帘。排除一些无关紧要的信息，我们可以先宏观上挑选出更通用的方法和目的检验一番。

#### 选项 1： 传统样式表

先从我们最熟悉的方式开始：老掉牙的样式表。我们自然可以在应用中 `<link>` 一个外部样式表，活儿就完了。

```html
<link rel="stylesheet" href="styles.css" />
```

我们可以一如往常地写熟悉的 CSS。这样做在一般情况下倒没什么问题，然而，当应用逐渐臃肿、越来越复杂时，维护一个样式表就变成了难题。上千行的 CSS 对应整个应用的样式，开发者要维护这样的样式表将痛苦不堪。样式级联看着很美好，但控制样式也同样困难，比如某个开发改动了一部分样式，会导致其它部分也因此需要跑回归测试。这些问题似曾相识，也因此 [Sass](https://sass-lang.com/)（和更新的 [PostCSS](https://github.com/postcss/postcss)）悉数登出救场。

顺着这个思路，我们用 PostCSS 来攥写模块化的 CSS 片段，并通过 `@import` 将这些模块组合起来。虽然这需要花点精力配置 webpack，但这对你来说不成问题！

无论你最终选择了哪种编译器，它们最终都会通过一个头部的 `<link>` 标签，把所有的样式扔在一个 CSS 文件内。随着应用日益复杂，这个文件将更加臃肿，异步加载将变得缓慢，从而阻塞了应用的其余部分的渲染（当然，阻塞渲染不**总是**是件坏事，但总体来说，我们还是会尽量避免使用会阻塞渲染的样式和脚本）。

我并不是说这种方式毫无可取之处。对于小应用来说，抑或对前端开发并不重视的团队们来讲，一张样式表足以满足需求了。它清晰地分离了业务逻辑和样式，而且它不是生成的，对开发者而言所写即所得，随心所欲。此外，浏览器也可以轻松缓存这张样式表，所以那些回头客们也就不用重新下载了。

而我们现在所寻找的，是一种能够完全发挥工具优势、稳健的 CSS 架构。这种架构需要能通过一种精细的方式，管理整个应用：CSS 模块化呼之欲出。

#### 选项 2：CSS 模块化

单张样式表一个严峻的问题是回归的风险。样式表内写一个模糊选择器样式可能会改动到另一个无关组件的样式。带作用域的样式此刻就发挥了其作用。

带作用域的样式可以程序化的生成对应组件的明确类名，以确保它们的类名唯一。自动生成的类名例如 `header__2lexd`，后面那小部分是选择器唯一的哈希值。当一个组件叫 header 时，你可以给它的类名取名为 header，程序将自动生成类似 `header__15qy_` 的新哈希后缀。

基于不同的实现方式，CSS 模块生成类名的方式不尽相同，这部分我就不赘述了，请参考 [CSS 模块化文档](https://github.com/css-modules/css-modules/tree/master/docs)。

**到头来，在浏览器内我们仍然是用头部的 `<link>` 标签来加载使用生成的单个 CSS 文件。**伴随而来的有潜在问题（诸如阻塞渲染、文件大小膨胀等），和上文提到的些许好处（缓存是主要优势）。一个需要注意的点是：这种方法移除了全局作用域 —— 起码一开始没有，而这正是其样式作用域所致。

比如在一个应用内，你想将一个全局的类名 `.screen-reader-text` 应用在任何一个组件上，当你使用 CSS 模块化时，你得在 `:global` 伪选择器内定义样式，才能使得这个类样式能被其它组件引用到；接着你需要把这个带有全局选择器的文件导入到各个组件的样式表内，才能生效。这样做虽然不算麻烦，但还是得花点力气习惯这种做法。

这是一个使用 `:global` 伪选择器的范例：

```css
// typography.css
:global {
  .aligncenter {
    text-align: center;
  }
  .alignright {
    text-align: right;
  }
  .alignleft {
    text-align: left;
  }
}
```

你可能得冒险把一大摞的字体、表格和大部分页面都有的通用元素样式扔进这一个 `:global` 选择器。幸好 [PostCSS Nested](https://github.com/postcss/postcss-nested) 或者 Sass 可以帮你导入样式表，让代码看着更加清爽。

```scss
// main.scss
:global {
  @import "typography";
  @import "forms";
}
```

像这样，把部分样式抽离出来，不再需要用 `:global` 伪选择器包装，只需要在主样式表中导入即可。

还有一点需要适应的是，在 DOM 节点中引用类名的方式。这点 [Vue](https://vue-loader.vuejs.org/guide/css-modules.html#usage)、[React](https://github.com/css-modules/css-modules/blob/master/docs/css-modules-with-react.md) 和 [Angular](https://github.com/css-modules/css-modules/blob/master/docs/css-modules-with-angular.js.md) 在它们的文档中都有说明。我这里也有一些例子，可以说明在 React 组件内，这些类是如何被引用的。

```javascript
// ./css/Button.css

.btn {
  background-color: blanchedalmond;
  font-size: 1.4rem;
  padding: 1rem 2rem;
  text-transform: uppercase;
  transition: background-color ease 300ms, border-color ease 300ms;

  &:hover {
    background-color: #000;
    color: #fff;
  }
}

// ./Button.js

import styles from "./css/Button.css";

const Button = () => (
  <button className={styles.btn}>
    Click me!
  </button>
);

export default Button;
```

CSS 模块化有诸多精彩的用例。如果你在寻找一种带作用域的样式，又希望保留静态样式的优势，那么 CSS 模块化正适合你。

同样值得注意的是，CSS 模块化可以和你喜爱的 CSS 预处理器相结合。通过 CSS 模块化，诸如 Sass、Less、PostCSS 等 CSS 预处理工具与插件都可以结合进项目构建过程中。

但是，假如你的应用程序是基于 JavaScript 开发的，那么如果 CSS 样式也可以访问组件的各种状态，并根据状态的变化做出反应，也会是不错的路子。假设你希望轻松地将关键 CSS 加入到应用程序中，有请 CSS-in-JS！

#### 选项 3：CSS-in-JS

CSS-in-JS 这个话题颇为宽泛。也有一些库致力于轻松书写 CSS-in-JS。像 [JSS](https://cssinjs.org/?v=v10.0.0-alpha.16)、[Emotion](https://emotion.sh/docs/introduction) 和 [Styled Components](https://www.styled-components.com/) 这类框架扛起了 CSS-in-JS 的大旗。

总体而言，这些框架大部分的实现方式是相通的。它们都会给单个组件写样式，并在构建过程中**只编译页面上即将渲染的组件**的 CSS。CSS-in-JS 框架通过 `<head>` 内的 `<style>` 标签输出 CSS，这种关键 CSS 加载策略开箱即用，并且像 CSS 模块化一样包含作用域，类名也经过了哈希。

当你在应用内跳转时，卸载的组件会把对应的样式从 `<head>` 内移除，加载的组件会加上对应的样式，因此性能得到了提升。不再有 HTTP 请求，也不会阻塞渲染，还确保了浏览器只会下载用户需要看到的样式。

有趣的是，CSS-in-JS 可以获取不同组件的状态和方法，借此渲染不同的 CSS。它可以像基于状态改变而重复加减类名那样简单，也可以像制作一套主题那样复杂。

因为 CSS-in-JS 着实是热门话题，我知道许多人也有不同的实践。我对 CSS-in-JS 的第一反应是十分负面的，我不喜欢 CSS 和 JS 两者这个理念在一起交叉污染，但我还是想保持开放的心态，因此需要从前端开发者的角度来评估哪些功能是我们**需要**的。现在我将分享一些其他人的感受，这群人非常重视 CSS，尤其是用 JS 写 CSS：

- 如果我们采用 CSS-in-JS，我们就得编写**纯正**的 CSS。有些包提供了编写 CSS-in-JS 的模板，但你得使用驼峰式命名 - 即 `padding-left` 变成 `paddingLeft`。这不是我个人想放弃的习惯。
- 一些 CSS-in-JS 方案要求你在需要样式的元素上编写内联样式。特别是在复杂的组件中，它的语法，开始变得非常冗繁，同样我也不想妥协。
- 要想让我使用 CSS-in-JS，它必须得有强大的工具，需要能解决 CSS 模块化或传统的样式表难以解决的痛点。
- 我们必须能够利用具有前瞻性思维的 CSS，如嵌套和变量。为了增强开发人员体验，我们还必须能够结合诸如 [Autoprefixer](https://css-tricks.com/autoprefixer/) 和其它的附加组件。

此外针对框架还有很多问题。但对于我们这些人来说，一生中大部分时间都在研究和实施我们喜爱语言的解决方案，我们要确保尽最大的可能把同样的语言写到最好。

下面是使用 Styled Components 的 React 组件：

```javascript
// ./Button.js
import styled from "styled-components";

const StyledButton = styled.button`
  background-color: blanchedalmond;
  font-size: 1.4rem;
  padding: 1rem 2rem;
  text-transform: uppercase;
  transition: background-color ease 300ms, border-color ease 300ms;

  &:hover {
    background-color: #000;
    color: #fff;
  }
`;

const Button = () => <StyledButton>Click Me!</StyledButton>;

export default Button;
```

我们还需要探索 CSS-in-JS 解决方案的潜在缺点 —— 绝对不是我加戏。使用 CSS-in-JS，我们很容易落入另一个陷阱，日积月累写出一个组件里有几百行 CSS 的臃肿的 JavaScript 文件，让开发者难以辨别组件的方法和结构。但同时，我们可以非常仔细地检查我们如何以及为什么要如此构建组件。在更深入地思考这个问题时，我们可以利用它并编写更精简的代码和更多可重用的组件。

此外，此方法完全模糊了业务逻辑和应用程序样式之间的界限。但只要架构的文档完备且经过深思熟虑，项目中的其他开发人员便可以放心遵从这个想法而不会不知所措。

### 总结

现在有各种各样的框架和方法可以在任何项目中解决 CSS 架构问题。我们作为开发者，有**如此之多的选择**，是让人无比兴奋的。然而我们仍会在碎片化社交媒体中产生选择困难症，因为每个解决方案都有其优点和不足的缺点。归根结底，我们是在讨论如何仔细而周密地实现系统在未来可控，让未来的我们和开发人员们感谢自己曾花时间建立这个架构。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
