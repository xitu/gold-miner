> * 原文地址：[Will SCSS be replaced by CSS3?](https://blog.bitsrc.io/will-scss-be-replaced-by-css3-754842d6b681)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/will-scss-be-replaced-by-css3.md](https://github.com/xitu/gold-miner/blob/master/article/2021/will-scss-be-replaced-by-css3.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Chorer](https://github.com/Chorer)、[Usualminds](https://github.com/Usualminds)

# CSS3 会替代 SCSS 吗？

![](https://cdn-images-1.medium.com/max/5760/1*iiuMRihN7Lj3i1-hTk8PjA.jpeg)

当谈及设置网页样式的时候，我们可以选择在项目中使用纯 CSS 或是 SCSS（除了其它处理器之外）。SCSS 是 CSS 的超集。大多数的开发者都认为，受益于高级的功能和清晰的语法，SCSS 使用起来比 CSS 更加方便。

在这篇文章中我想要带着大家一起探索 SCSS 的功能以及 CSS 这些年来在功能上的提升。此外，我还会评估是否可以在实际项目中用 CSS 替代 SCSS。

## CSS 当前的功能

CSS 自诞生以来已经取得了很大的进展。近些年来 CSS 的发展也降低了在动画领域使用 JavaScript 的必要性。现代浏览器甚至使用了 GPU 去提升这些 CSS 动画的性能。我们现在甚至只需要稍微学习一下，就可以使用 CSS 构建复杂的响应式网格布局。

如今 CSS 有了许多新的功能，但本文只会重点提及一些在现代 Web 应用中常用的新功能。

* 在任何 Web 应用的构建中，最主要的一部分就是页面的布局。我们当中的大多数人这些年都依赖于诸如 Bootstrap 这样的 CSS 框架，但 CSS 如今已经提供了 Grid（网格）、Subgrid（子网格）、Flexbox（弹性盒）等新功能去原生地构建布局。虽说 Flexbox 在开发者当中广受欢迎，但 Grid 布局也正迎头赶上。
* 灵活的文字排版
* Transition 和 Transform 的强大能力让我们不再需要使用 JavaScript 去制作动画
* 自定义属性或变量

## SCSS 的功能

#### SCSS 支持使用变量 —— 避免冗杂的代码

我们其实可以在我们的样式表中重用一堆的颜色 `color` 或其他元素定义（例如字体 `font`）。为了做到在统一的一个地方声明这些可重用的东西，SCSS 为我们提供了变量功能，让我们能够用一个变量名表示某个颜色，并在项目的其它地方使用该变量名，而不是重写一遍颜色值。

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

> # 但是在运行时 CSS 自定义属性比 SCSS 变量更耗时。

这是因为浏览器会在运行时去处理这些属性。而 SCSS 则相反，它在预处理阶段会被转化为 CSS，并去处理变量。因此，SCSS 中变量的使用和代码的重用相比 CSS 而言有着更好的性能。

#### SCSS 允许嵌套的语法 —— 更简洁的源代码

假如有下面这样的 CSS 代码块：

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

上述的代码看起来很混乱，为了给子元素添加样式，不得不重复声明同一个父元素。

但如果使用 SCSS 的嵌套语法，我们可以编写更简洁的代码。上述的代码如果用 SCSS 编写，是这样的：

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

因此，与传统的 CSS 相比，使用 SCSS 设计组件似乎更加优雅而简洁。

#### @extend 功能 —— 避免重复同样的样式！

在 SCSS 中，我们可以使用 `@extend` 在不同的选择器中共享相同的属性。带有占位符的 `@extend` 的使用方法如下所示：

```scss
%unstyled-list {
    list-style: none;
    margin: 0;
    padding: 0;
}
```

`%unstyled-list` 是一个可以避免重复编写代码的语法糖，我们可以在不同的地方使用这个列表样式模版，例如说：

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

同样，我们可以在所有引入了这个定义的样式表中重用它。

SCSS 中还有很多例如[函数](https://sass-lang.com/documentation/at-rules/function)、[混入](https://sass-lang.com/documentation/at-rules/mixin)、[循环](https://sass-lang.com/documentation/at-rules/control/for) 的功能，能让我们的前端开发更加高效。

## 我应该从 SCSS 切换到 CSS 吗？

在上文中我们探索了 CSS 现有提供的功能以及 SCSS 的功能。但是，如果将 CSS 与 SCSS 进行比较，我们会发现还有一些必要的功能无法在 CSS 中使用。

* 随着 Web 应用的不断发展，样式表会变得越发复杂和庞大。CSS 的嵌套功能将大幅度地提高代码的可读性，让我们在开发此类项目的时候得心应手。但是，截止撰写本文的时间，CSS 尚未支持该功能。
* CSS 无法处理流控制规则。 SCSS 内置提供了诸如 `@if`、`@else`、`@each`、`for` 和 `@while` 的流控制规则。作为程序员，我发现这个功能对于定义样式来说是非常有用的。这也让我们可以编写更少更简洁的代码。
* 此外，SCSS 还支持数字运算符的标准集，而在 CSS 中我们必须使用 `calc()` 函数才能完成数值运算。SCSS 的数值运算还能在其兼容的单位之间进行自动转换。

**但是**, `calc()` 这个 CSS 函数几乎没有限制，例如除法中除数必须是数字，或是对于乘法运算至少有一个参数是数字。

* 另一个重要方面是样式重用，这是 SCSS 的”杀手锏“。在这个方面，SCSS 提供了许多功能，例如内置模块、映射、循环和变量。

因此我认为，即使 CSS 已经诞生了很多新功能，SCSS 仍然是更好的选择。你可以在下面的评论区中谈谈你的想法。

希望你能够喜欢这篇文章。谢谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
