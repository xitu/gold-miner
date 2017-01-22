> * 原文地址：[3 New CSS Features to Learn in 2017](https://bitsofco.de/3-new-css-features-to-learn-in-2017/)
* 原文作者：[ireaderinokun](https://twitter.com/ireaderinokun)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [熊贤仁](https://github.com/FrankXiong)
* 校对者：

# 3 New CSS Features to Learn in 2017
# 2017 年要去学的 3 个 CSS 新属性

## 1. Feature Queries
## 1. 特性查询

A while ago, I wrote about Feature Queries being [the one CSS feature I really want](https://bitsofco.de/the-one-css-feature/). Well, now its basically here! It is now supported in every major browser (Opera Mini included) besides Internet Explorer.
不久前，我写过一篇关于特性查询的文章 —— [一个我十分期待的CSS特性](https://bitsofco.de/the-one-css-feature/)。目前除了IE之外的所有主流浏览器（包括Opera Mini）均已支持特性查询。

Feature Queries, using the `@supports` rule, allow us to wrap CSS in a conditional block that will only be applied if the current user agent supports a particular CSS property-value pair. A simple example of this is to only apply Flexbox styles to browsers that support `display: flex` -
特性查询使用了 `@supports` 规则，它允许我们将 CSS 代码包裹在条件语句中，只有在当前用户代理支持某个特定的 CSS 属性-值对时，该条件语句才会被应用。举个简单的例子：只有支持 `display: flex` 的浏览器才会应用 Flexbox 样式 －
```
@supports ( display: flex ) {
  .foo { display: flex; }
}
```

Additionally, using operators like `and` and `not`, we can create even more complicated feature queries. For example, we can detect if a browser only supports the old Flexbox syntax -
另外，使用像 `and` 和 `not` 这类操作符，我们甚至可以创建更复杂的特性查询。举个例子，检测一个浏览器是否支持老式的 Flexbox 语法 －
```
@supports ( display: flexbox )
          and
          ( not ( display: flex ) ) {
  .foo { display: flexbox; }
}
```

### Support
### 浏览器支持

![](http://i1.piimg.com/567571/bd5cfc239fccdda6.jpg)

## 2. Grid Layout
## 2. 栅格布局

The [CSS Grid Layout Module](https://drafts.csswg.org/css-grid/) defines a system for creating grid-based layouts. It has similarities with the [Flexbible Box Layout Module](https://www.w3.org/TR/css-flexbox-1/), but is more specifically designed for page layouts, and thus has a number of different features.
[CSS 栅格布局模块](https://drafts.csswg.org/css-grid/) 定义了一个用于创建基于栅格布局的系统。它和 [弹性盒子布局模块](https://www.w3.org/TR/css-flexbox-1/) 有些相似，但 CSS 栅格布局是专为页面布局而设计，因此拥有许多不同的特性。

### Explicit Item Placement
### 显式定位元素

A grid is made up of the Grid Container (created with `display: grid`), and Grid Items (it's children). In our CSS, we can easily and explicitly orgnise the placement and order of the grid items, independent of their placement in the markup.
一个栅格由栅格容器( `display: grid` 可创建一个栅格容器)和栅格项(栅格的子元素)组成。我们可以简单而显式地定位和排列栅格元素，元素位置与其在HTML中的位置无关。

For example, in my article on [The Holy Grail Layout with CSS Grid](https://bitsofco.de/holy-grail-layout-css-grid/), I showed how we can use this module to create the infamous "holy grail layout".
在[ CSS 实现圣杯布局](https://bitsofco.de/holy-grail-layout-css-grid/) 这篇文章中，我演示了如何使用栅格布局模块来创建万恶的“圣杯布局”。

![Holy Grail Layout Demo](https://bitsofco.de/content/images/2016/03/Holy_Grail_CSS_Grid.gif)

The underlying CSS was only 31 lines -
下列 CSS 代码仅有 31 行 －

```
.hg__header { grid-area: header; }
.hg__footer { grid-area: footer; }
.hg__main { grid-area: main; }
.hg__left { grid-area: navigation; }
.hg__right { grid-area: ads; }

.hg {
    display: grid;
    grid-template-areas: "header header header"
                         "navigation main ads"
                         "footer footer footer";
    grid-template-columns: 150px 1fr 150px;
    grid-template-rows: 100px
                        1fr
                        30px;
    min-height: 100vh;
}

@media screen and (max-width: 600px) {
    .hg {
        grid-template-areas: "header"
                             "navigation"
                             "main"
                             "ads"
                             "footer";
        grid-template-columns: 100%;
        grid-template-rows: 100px
                            50px
                            1fr
                            50px
                            30px;
    }
}
```

### Flexible Lengths
### 弹性长度

The CSS Grid Module introduces a new length unit, the `fr` unit, which represents a fraction of the free space left in the grid container.
 CSS 栅格模块引入了一个新的长度单位：`fr` ，它等于剩余空间在栅格容器中的占比。　　　　

This allows us to apportion heights and widths of grid items depending on the available space in the grid container. For example, in the Holy Grail Layout, I wanted the `main` section to take up all the remaining space after the two sidebars. To do that, I simply wrote -
这样我们可以根据栅格容器中的可用空间来分配元素的宽高。比如在圣杯布局中，我希望 `main` 区块占用两个边栏之外的所有空间。因此我简单地写了如下代码 －
```
.hg {
  grid-template-columns: 150px 1fr 150px;
}
```

### Gutters
### 槽

We can specifically define gutters for our grid layout using the `grid-row-gap`, `grid-column-gap`, and `grid-gap` properties. These properties accept a [`<length-percentage>` data type](https://bitsofco.de/generic-css-data-types/#percentages) as value, with the percentage corresponding to the dimension of the content area.
我们可以使用 `grid-row-gap`，`grid-column-gap`，和 `grid-gap` 属性来明确地定义槽。这些属性接受一个 [`<length-percentage>` 数据类型](https://bitsofco.de/generic-css-data-types/#percentages) 作为值，其值为相对于内容区大小的百分比。

For example, to have a 5% gutter, we would write -
比如设置一个 5% 的槽，我们可以这样写 －
```
.hg {
  display: grid;
  grid-column-gap: 5%;
}
```

### Support
### 浏览器支持

The CSS Grid Module will be available in browsers as early as March this year.
 CSS 栅格模块最早将在今年三月份被浏览器们支持。

![](http://i1.piimg.com/567571/229e6ea502a22d93.jpg)

## 3. Native Variables
## 3. 原生变量

Lastly, native CSS Variables ([Custom Properties for Cascading Variables Module](https://drafts.csswg.org/css-variables/)). This module introduces a method for creating author-defined variables, which can be assigned as values to CSS properties.
最后，原生 CSS 变量（[层叠变量模块的自定义属性](https://drafts.csswg.org/css-variables/)）来了。这个模块引入了一个用于创建用户自定义变量的方法，变量可被赋值给 CSS 属性。

For example, if we have a theme colour we are using in several places in our stylesheet, we can abstract this out into a variable and reference that variable, instead of writing out the actual value multiple times.
举例来说，如果我们有一个主题颜色，它在样式表中很多地方都在使用。我们可以把它抽出来用一个变量表示，然后引用该变量，这样就不用多次书写实际的值了。

```
:root {
  --theme-colour: cornflowerblue;
}

h1 { color: var(--theme-colour); }  
a { color: var(--theme-colour); }  
strong { color: var(--theme-colour); }
```

This is something we have been able to do with the help of CSS pre-processors like SASS, but CSS Variables have the advantage of living in the browser. This means that their values can be updated live. To change the `--theme-colour` property above, for example, all we have to do is the following -
我们之前可以用诸如 SASS 之类的 CSS 预处理器来做到这一点，但是 CSS 变量的优势是在浏览器中运行。这意味着变量的值可以被动态的更新。比如要修改以上所有 --theme-colour 属性，我们只需要这样做 －
```
const rootEl = document.documentElement;  
rootEl.style.setProperty('--theme-colour','plum');
```

## Support
## 浏览器支持

 ![](http://i1.piimg.com/567571/fe40f3b4ec633b1c.jpg)


## What about Support?
## 关于浏览器支持？

As you can see, none of these features are fully supported in every browser yet, so how do we comfortably usem the in production? Well, Progressive Enhancement! Last year I gave a talk about how to apply Progressive Enhancement in relation to CSS at Fronteers Conference. You can watch the talk below -
如你所见，以上所有特性目前都没有被所有浏览器完全支持，那么我们如何在生产环境中舒服地用上他们呢？渐进增强！去年我在前端开发者大会上做了一个分享，讲了如何做 CSS 相关的渐进增强。点击下面可以观看此次分享 －

[![JavaScript Array Methods -　Mutator](http://bitsofco.de/content/images/2017/01/Screen-Shot-2017-01-09-at-20.58.09--2-.png)](https://player.vimeo.com/video/194815985)

What CSS features are you excited about to learn in 2017?
2017年有哪些 CSS 特性令你激动不已想要学习？
