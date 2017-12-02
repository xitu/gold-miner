> * 原文地址：[3 New CSS Features to Learn in 2017](https://bitsofco.de/3-new-css-features-to-learn-in-2017/)
* 原文作者：[ireaderinokun](https://twitter.com/ireaderinokun)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [熊贤仁](https://github.com/FrankXiong)
* 校对者： [vuuihc](https://github.com/vuuihc) [aleen42](https://github.com/aleen42)

# 2017 年要去学的 3 个 CSS 新属性

## 1. 特性查询（Feature Queries）

不久前，我写过一篇关于特性查询的文章 —— [《一个我十分期待的CSS特性 - the one CSS feature I really want》](https://bitsofco.de/the-one-css-feature/)。如今果然出现了。除了 IE浏览器之外，所有主流浏览器（包括 Opera Mini）均已支持特性查询。

特性查询采用 `@supports` 规则，它使得我们可以将 CSS 代码包裹一个条件块中。只有当浏览器的用户代理（user agent）支持某个特定的 CSS 属性-值对时，该条件块中的样式代码才会生效。下面举个简单的例子来说：只有支持 display: flex 的浏览器才会应用 Flexbox 样式
```
@supports ( display: flex ) {
  .foo { display: flex; }
}
```
另外，我们甚至可以使用像 `and` 和 `not` 这类操作符来创建更为复杂的特性查询。例如，检测一个浏览器是否只支持老式的 Flexbox 语法
```
@supports ( display: flexbox )
          and
          ( not ( display: flex ) ) {
  .foo { display: flexbox; }
}
```

### 兼容性

![](http://i1.piimg.com/567571/bd5cfc239fccdda6.jpg)

## 2. 栅格布局（Grid Layout）

[CSS 栅格布局模块（CSS Grid Layout Module）](https://drafts.csswg.org/css-grid/) 定义了一个用于创建基于栅格布局的系统。它和 [弹性盒子布局模块（Flexbible Box Layout Module）](https://www.w3.org/TR/css-flexbox-1/) 有些相似，但由于其专为页面布局而设计，因此拥有许多不同的特性。

### 显式定位元素

一个栅格由栅格容器（由 `display: grid` 所创建）和栅格项（子元素）组成。在 CSS 中，我们可以简单且显式地组织栅格项的位置及顺序，并独立于 markup 语言中元素的位置。

在[《CSS栅格实现圣杯布局》](https://bitsofco.de/holy-grail-layout-css-grid/)这篇文章中，我演示了如何使用栅格布局模块来创建万恶的“圣杯布局”。

![Holy Grail Layout Demo](https://bitsofco.de/content/images/2016/03/Holy_Grail_CSS_Grid.gif)

下列 CSS 代码仅有 31 行

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

### 弹性长度

CSS 栅格模块引入了一个新的长度单位：`fr` ，用于表示栅格容器中所剩空间的占比。

这样我们可以根据栅格容器中的可用空间来分配栅格项的宽高。比如在圣杯布局中，我们可以通过下面的简单代码使得 `main` 区域占用两个边栏外的余下空间。
```
.hg {
  grid-template-columns: 150px 1fr 150px;
}
```

### 槽（Gutters）

我们可以使用 `grid-row-gap`，`grid-column-gap`，和 `grid-gap` 属性来为栅格布局明确地定义槽。这些属性接受一个 [`<length-percentage>` 数据类型](https://bitsofco.de/generic-css-data-types/#percentages) 作为值，以表示内容区大小的相对百分比。

比如设置一个 5% 的槽，我们可以这样写
```
.hg {
  display: grid;
  grid-column-gap: 5%;
}
```

### 兼容性

CSS 栅格模块最早将在今年三月份被浏览器们支持。

![](http://i1.piimg.com/567571/229e6ea502a22d93.jpg)

## 3. 原生变量（Native Variables）

最后，原生 CSS 变量（[层叠变量模块（Cascading Variables Module）的自定义属性](https://drafts.csswg.org/css-variables/)）来了。该模块引入了一个用于创建用户自定义变量的方法，变量可被赋值给 CSS 属性。

譬如，若有多个样式表使用同一个主题颜色，那么我们就可以将其抽象成一个变量，并引用该变量，而非重复书写。

```
:root {
  --theme-colour: cornflowerblue;
}

h1 { color: var(--theme-colour); }  
a { color: var(--theme-colour); }  
strong { color: var(--theme-colour); }
```

我们之前可以用像 SASS 这种 CSS 预处理器来做到这一点，但 CSS 变量的优势是能实际运行于浏览器中。这就意味着，变量的值可以被动态的更新。比如要修改以上所有 --theme-colour 属性，我们只需要这样做
```
const rootEl = document.documentElement;  
rootEl.style.setProperty('--theme-colour','plum');
```

## 兼容性

 ![](http://i1.piimg.com/567571/fe40f3b4ec633b1c.jpg)


## 关于兼容性？

如你所见，以上所有特性目前都没有被所有浏览器完全支持，那么我们如何在生产环境中舒服地用上他们呢？渐进增强（Progressive Enhancement）！去年的前端开发者大会上，我就曾就如何在 CSS 中进行渐进增强做过一次分享。点击下面可以看到

[![JavaScript Array Methods -　Mutator](http://bitsofco.de/content/images/2017/01/Screen-Shot-2017-01-09-at-20.58.09--2-.png)](https://player.vimeo.com/video/194815985)

2017年有哪些 CSS 特性令你激动不已想要学习？
