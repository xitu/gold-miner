> * 原文地址：[Creating Stylesheet Feature Flags With Sass !default](https://css-tricks.com/creating-stylesheet-feature-flags-with-sass-default/)
> * 原文作者：[Nathan Babcock](https://css-tricks.com/author/nathanbabcock/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/creating-stylesheet-feature-flags-with-sass-default.md](https://github.com/xitu/gold-miner/blob/master/article/2021/creating-stylesheet-feature-flags-with-sass-default.md)
> * 译者：[Gesj-yean](https://github.com/Gesj-yean)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat) [nia3y](https://github.com/nia3y)

# 用 Sass 的 !default 创建样式表的特性标志

`!default` 是一个 Sass 标志，表明对一个变量进行 **条件赋值** —— 只有在变量未定义或为 `null` 时才赋值。例如以下代码片段：

```scss
$variable: 'test' !default;
```

对于 Sass 编译器来说，这一行表示：

> **仅当** `$variable` 没有被赋值时，将 `'test'` 赋值给 `$variable`。

这里有一个反例，说明了 `!default` 标志的条件赋值行为的另一种情况：

```scss
$variable: 'hello world';
$variable: 'test' !default;
// $variable 仍然为 `hello world`
```

运行这两行后，`$variable` 的值仍然是第 1 行原始赋值的 `'hello world'`。在这种情况下，第 2 行中 `!default` 的赋值将被忽略，因为已经提供了一个值，就不需要默认值。

## 样式库和 `@use...with`

Sass 中的 `!default` 主要是为了方便样式库的使用，并方便地将它们包含到下游应用程序或项目中。通过将一些变量指定为 `!default`，样式库可以允许导入的应用程序自定义或调整这些变量值，而不需要再完全地 fork 一份样式库。换句话说，`!default` 的变量本质上是作为修改样式库代码行为的 *参数*。


Sass 有一个专门用于此目的的特殊语法，它将样式表与相关的变量组合在一起：

```scss
// style.scss
@use 'library' with (
  $foo: 'hello',
  $bar: 'world'
);
```

这个语句的功能 *几乎* 相同于变量赋值后跟一个 `@import`，如下所示:

```scss
// style.scss - 一种不太常用的导入 `library.scss` 配置的方式
$foo: 'hello';
$bar: 'world';
@import 'library';
```

这里重要的区别以及原因是，关于覆盖的**范围**， `@use...with` 是可自取的。 `with` 代码块让 Sass 编译器和任何阅读源代码的人都清楚地知道，这些覆盖仅仅适用于在 `library.scss` 中定义和使用的变量。使用这种方法可以保持全局作用域的整洁，并有助于减少不同库之间的变量命名冲突。

## 最常用的例子：自定义主题

```scss
// library.scss
$color-primary: royalblue !default;
$color-secondary: salmon !default;


// style.scss
@use 'library' with (
  $color-primary: seagreen,
  $color-secondary: lemonchiffon
);
```

这一特性最常见的例子之一是 **主题** 的实现。主题色可以用 Sass 变量来定义，然后用 `!default` 允许自定义的主题色，为其他样式兜底（甚至包括混合或覆盖这些颜色）。

Bootstrap 使用 `!default` 标志设置每一项变量，来导出它的[整个 Sass 变量 API](https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss)，包括主题调色板，以及其他共享值，如间距，边框，字体设置，甚至动画渐变方法和时间。这是 `!default` 提供的灵活性的最好例子之一，即使是在一个非常全面的样式框架中。

在现代网络应用中，这种行为本身就可以被[CSS 用户属性](https://css-tricks.com/a-complete-guide-to-custom-properties/)和[回退参数](https://css-tricks.com/a-complete-guide-to-custom-properties/#h-custom-property-fallbacks)复制使用。如果您的工具链还没有使用 Sass，那么现代 CSS 可能已经足够用于主题化的目的。然而，我们将检查那些只能使用 Sass `!default` 的两个例子。

## 用例 2：加载网页字体

```scss
// library.scss
$disable-font-cdn: false !default;
@if not $disable-font-cdn {
    @import url('https://fonts.googleapis.com/css2?family=Public+Sans&display=swap');
}

// style.scss
@use 'library' with (
  $disable-font-cdn: true
);
// 没有额外的 http 请求
```

当 Sass 在 CSS 生命周期中利用它的预处理器时，它开始显示它的优势。假设你公司设计系统的样式库使用了自定义的网页字体。它从谷歌的 CDN 加载——理想的情况是尽快得到资源——但尽管如此，你公司的体验团队对页面加载时间仍然非常关心；每一毫秒对于他们的应用来说都很重要。

为了解决这个问题，你可以在你的样式库中引入一个可选的 **布尔** 标志（与第一个例子中的 CSS 颜色值略有不同）。当默认值设置为 `false` 时，你可以在 Sass `@if` 语句中检查这个特性标志，然后再运行消耗较大的操作，比如外部 HTTP 请求。你的库的普通用户甚至不需要知道这个选项的存在——为他们工作提供默认行为，他们自动从 CDN 加载字体，而其他团队可以访问切换他们需要的，以微调和优化页面加载。

一个 CSS 变量不足以解决这个问题——尽管 `font-family` 可以被覆盖，但 HTTP 请求加载了未使用的字体。

## 用例 3：调试间隔标记可视化

![](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/sass-default-visually-debugging.png?resize=1808%2C468&ssl=1)

[查看演示](https://codepen.io/nathanbabcock/project/editor/AYYygg)

`!default` 的特性标志也可以用来创建调试工具，以便在开发过程中使用。在本例中，可视化调试工具为间距标记创建颜色编码的覆盖。该基础是一组根据“T恤尺寸”（即“xs”或“最小码”到“xl”/“超大码”）升格定义的间距标记。从这个单一的标记集合，Sass `@each` 循环生成实用程序类的每个组合，将特定标志应用于每边（分别为上、右、下和左，或同时应用所有四个）的 padding 或 margin。

因为这些选择器都是在嵌套循环中动态构造的，并且只有一个 `!default` 标志可以将渲染行为从标准（margin 加 padding）切换到彩色调试视图（相同的尺寸使用相同大小的透明边框）。这种颜色编码的视图可能看起来非常类似于设计师移交给开发的可交付成果和线框图——特别是如果你已经对设计和开发们共享了相同的间距值。将视觉调试视图与模型并排可以快速直观地发现差异，以及调试更复杂的样式问题，如[margin 塌陷](https://css-tricks.com/what-you-should-know-about-collapsing-margins/)行为。

再次说明——当此代码被编译为生产代码时，调试可视化将不会出现在结果 CSS 中的任何地方，因为它将被相应的 margin 或 padding 语句完全取代。

## 进一步阅读

这些只是 Sass `!default` 的几个例子。当你将该技术应用于自己的项目时，请参考这些文档资源和使用示例。

* [`!default` 文档](https://sass-lang.com/documentation/variables#default-values)
* [`@use with` 文档](https://sass-lang.com/documentation/at-rules/use#configuration)
* [Bootstrap 中的变量默认值](https://getbootstrap.com/docs/4.0/getting-started/theming/#variable-defaults)
* [一个 Sass `default` 使用案例](https://thoughtbot.com/blog/sass-default) (thoughtbot)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
