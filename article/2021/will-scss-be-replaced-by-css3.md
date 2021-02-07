> * 原文地址：[Will SCSS be replaced by CSS3?](https://blog.bitsrc.io/will-scss-be-replaced-by-css3-754842d6b681)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/will-scss-be-replaced-by-css3.md](https://github.com/xitu/gold-miner/blob/master/article/2021/will-scss-be-replaced-by-css3.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# SCSS 会被 CSS3 替代吗？

![](https://cdn-images-1.medium.com/max/5760/1*iiuMRihN7Lj3i1-hTk8PjA.jpeg)

当提到给网页加样式这个领域的时候，我们拥有在项目中使用纯 CSS 文本或是 SCSS 文本的选择（纵观其他处理器）。SCSS 是 CSS 的超集。大多数的开发者都发现使用

在这篇文章中我想要带着大家一起探索 SCSS 的功能以及 CSS 在这些年来的功能提升。并且我还会对 CSS 是否能够作为一个 SCSS 的替代品做出评价。

## CSS 现如今的功能

自从 CSS 的诞生已经过了一长段时间了。近些年来 CSS 的发展也着力减少了在动画领域使用 JavaScript 的必要性。现代浏览器甚至使用了 GPU 去提升这些 CSS 动画的性能。我们现在甚至只需要以一点点的学习就可以使用 CSS 构建复杂的响应式的网格布局。

如今 CSS 有了许多新的功能，本文中我想要去强调其中现代网络程序中的常用的新的功能。

* 在任何网络应用程序的构建中，最主要的一部分就是页面的布局。当我们当中的大多数人都依赖于 CSS 框架例如 Bootstrap 的时候，CSS 为我们提供了例如 Grid（网格）、Subgrid（子网格）、Flexbox（弹性盒）等新功能去原生地构建布局。虽说 Flexbox 在开发者当中被广泛地使用着，但 Grid 布局正在赶上来。
* 灵活的文字排版
* Transition 和 Transform 的强大能力将 JavaScript 完全扔出动画构建领域
* 自定义属性或变量

## SCSS 的功能

#### SCSS 支持使用变量 — 避免冗杂的代码

我们其实可以在我们的样式表中重用一堆的颜色 `color` 或其他元素定义（例如字体 `font`）。为了在一处定义这些用于重复使用的变量，SCSS 为我们提供了变量功能，让我们能将一个颜色与一个变量名捆绑，并在项目的其他的样式表中重用这个变量名，而非冗杂的重复一致的颜色定义。

例如下面这个例子：

```scss
$black: #000000;
$primary-font: 'Ubuntu', 'Helvetica', sans-serif;
$unit: 1rem;

body {
    color: $black;
    font-family: $primary-font;
    padding: #{$unit * 2};
}
```

CSS 也支持变量和自定义属性，以下就是 CSS 中的自定义属性：

```css
--black: #000000;
--width: 800px;
--primaryFont: 'Ubuntu', 'Helvetica', sans-serif;

body {
    width: var(--width);
    color: var(--black);
    font-family: var(--primaryFont);
}
```

> # 但是在运行时 CSS 属性比 SCSS 属性更耗使用

造成这个问题的原因是浏览器处理 CSS 的方式决定的 —— SCSS 编译的时候会将变量名替代为定义的内容，而 CSS 是在运行时检索变量的。因此，SCSS 中变量的使用和代码的重用对比 CSS 而言拥有着更加的性能表现。

#### SCSS 允许嵌套的语法 —— 更干净的源代码

如果说有这样一大块 CSS 代码像这样：

```css
.header {
    padding: 1rem;
    border-bottom: 1px solid grey;
}

.header .nav {
    list-style: none;
}

.header .nav li {
    display: inline-flex;
}

.header .nav li a {
    display: flex;
    padding: 0.5rem;
    color: red;
}
```

上述的代码看起来很是混乱，重复定义了大量的同一个父元素来获取一个子元素并对子元素添加样式。

但如果我们使用 SCSS 我们其实可以嵌套这些代码，构造出更简洁的代码，上述的代码在 SCSS 中长这样：

```scss
.header {
    padding: 1rem;
    border-bottom: 1px solid grey;

    .nav {
        list-style: none;

        li {
            display: inline-flex;

            a {
                display: flex;
                padding: 0.5rem;
                color: red;
            }
        }
    }
}
```

因此，与传统的 CSS 定义相比，使用 SCSS 样式化组件似乎更优更简洁。

#### @extend 功能 — 避免重复同样的样式！

在 SCSS 中我们可以使用 `@extend` 去在不同的选择器中重用相同的属性。带有占位符的 `@extend` 的使用方法应该是这样的。

```scss
%unstyled-list {
    list-style: none;
    margin: 0;
    padding: 0;
}
```

`%unstyled-list` 是一个可以用于避免重复编写列表样式代码的一个占位符，我们可以在不同的地方使用这个列表样式模版，例如说：

```scss
.search-results {
    @extend %unstyled-list;
}

.advertisements {
    @extend %unstyled-list;
}

.dashboard {
    @extend %unstyled-list;
}
```

同样，我们可以在所有引入了这个定义的样式表中重复使用此定义。

SCSS 中还有很多例如 [functions](https://sass-lang.com/documentation/at-rules/function)、[mixins](https://sass-lang.com/documentation/at-rules/mixin)、[loops](https://sass-lang.com/documentation/at-rules/control/for) 的功能，能让我们的前端生活更加美好。

## 我应该从 SCSS 切换到 CSS 嘛？

在上文中我们探索了 CSS 现有提供的功能以及 SCSS 的功能。但是，如果我们将 CSS 与 SCSS 进行比较，我们会发现一些目前 CSS 中尚不可用的一些比较实用的基础功能。

* 随着 Web 应用程序的不断发展，样式表往往变得越来越复杂。嵌套 CSS 样式的功能将成为此类项目中每个人的生命救星，能够大幅度地提高代码的可读性。但是，截止撰写本文的时间，CSS 不支持该功能。
* CSS 无法处理流控制规则。 SCSS 内置提供了诸如 `@if`、`@else`、`@each`、`for` 和 `@while` 的流控制规则。作为程序员，我发现这个功能对于定义样式来说是非常有用的。这也让我们可以编写更少更简洁的代码。
* 除此之外，SCSS 还支持直接执行定义的标准数字运算符集而无需使用函数，而在 CSS 中我们必须使用 `calc()` 函数才能完成数字运算。SCSS 的数值运算还能在兼容的单位之间自动转换。

**但是**, `calc()` 这个 CSS 函数几乎没有限制，例如除法中除数必须是数字，或是对于乘法运算至少要一个参数是数字。

* 另一个重要方面是样式重用，这是 SCSS 的战略优势。在这个方面，SCSS 提供了许多功能，例如内置模块、映射、循环和变量。

因此，我认为，即使具有 CSS 的最新功能，SCSS 仍然是更好的选择。在下面的评论中让我知道你的想法。

希望你能够喜欢这篇文章。谢谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
