
> * 原文地址：[Improve Web Typography with CSS Font Size Adjust](https://www.sitepoint.com/improve-web-typography-css-font-size-adjust/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[Panayotis Matsinopoulos](https://www.sitepoint.com/author/pmatsinopoulos/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/improve-web-typography-css-font-size-adjust.md](https://github.com/xitu/gold-miner/blob/master/TODO/improve-web-typography-css-font-size-adjust.md)
> * 译者：[lampui](https://github.com/lampui)
> * 校对者：[sun](https://github.com/sunui)、[Yuuoniy](https://github.com/Yuuoniy)

# 使用 CSS 的 font-size-adjust 属性改善网页排版

CSS 中的 `font-size-adjust` [属性](https://drafts.csswg.org/css-fonts-3/#propdef-font-size-adjust)允许开发者基于小写字母的高度指定 `font-size` ，这可以有效地提高网页文字的可读性。

在这篇文章中，你不仅能了解到 [font-size-adjust](https://drafts.csswg.org/css-fonts-3/#propdef-font-size-adjust) 属性的重要性，并且还能学会如何在你的项目中使用它。

## font-size-adjust 的重要性

你访问的网站大多都是由文本组成的，由于书面文字是网站的重要组成部分，因此就很值得把注意力放到你用来显示信息的字体上面。选对正确的字体能带给用户愉快的阅读体验，然而，使用不恰当的字体则会使网站变得难以阅读。当你决定将要使用什么字体后，一般你就会再给这个字体选择一个合适的大小。

`font-size`　属性会设置网页中所有 `font-family` 下你想使用的字体的大小，然而在大多数情况下，浏览器一般都是使用 `font-family` 下声明的第一种字体。只有当第一种字体因为某些原因不可用时，浏览器才会使用候选字体继续渲染页面。

举个例子，看下面的代码：

```
body {
  font-family: 'Lato', Verdana, sans-serif;
}
```

如果你的浏览器从 [Google Fonts](https://fonts.google.com/?query=lato&selection.family=Lato) 下载的 ‘Lato’ 字体不可用时，在这种情况下，Verdana 字体就会被使用。但是，脑海里 `font-size` 的值好像是针对 ‘Lato’ 字体设定的，而不是 Verdana。

### 什么是字体的纵横比？

字体的外观尺寸及其可读性可能会因为 `font-size` 的值而产生很大的变化，特别像是对拉丁文这种文字会导致其在大小写之间差别巨大。在这种情况下，小写字母与对应的大写字母的高度比例是决定一种字体易读性的重要因素，这个比值通常被叫做一种字体的**纵横比**。

正如我之前说的，一旦你设置了 `font-size` 的值，这个值将会对所有的字体起作用。如果候选字体的纵横比跟首选字体的纵横比相差太大，这可能影响候选字体的易读性。

`font-size-adjust` 属性在这种情形下则扮演着一个尤为重要的角色，因为它允许你设置所有字体的 [x 轴高度](https://typedecon.com/blogs/type-glossary/x-height/) 为统一大小，以便提高文字的易读性。

## 给 font-size-adjust 属性选择合适的值

现在你知道使用 `font-size-adjust` 属性的重要性了吧，是时候把它用到你的网站上了。这个属性的语法如下：

```
font-size-adjust: none | <number>
```

`none` 是默认值，这个值意味着不调整字体的大小。

你也可以设置属性的值为一个数字，这个数字将用来计算一张网页上所有字体的 x 轴高度，x 轴高度等于这个数字乘以 `font-size` 的值。 这可以提高小尺寸字体的可读性。以下是一个使用 `font-size-adjust` 属性的例子：

```
font-size: 20px;
font-size-adjust: 0.6;
```

所有字体的 x 轴高度现在是 20px * 0.6 = 12px，一种字体的实际大小现在可以被修改以确保 x 轴高度总是等于 12px。调整后 `font-size` 的值可以通过以下公式计算

```
c = ( a / a' ) s.
```

这里， `c` 指调整后的 `font-size`，`s` 指原先指定的 `font-size`，a 是 `font-size-adjust` 属性指定的纵横比，`a'` 指实际字体的纵横比。

你不能设置 `font-size-adjust` 的值为负数，设置为 0 则会致使文字没有高度，换句话说，就是文字会被隐藏。在旧的浏览器中，例如 Firefox 40，如果设置其属性值为 0 则相当于设置为 `none`。

大多数情况下，开发者一般会尝试不同的 `font-size` 取值以确定哪个值对给定的字体最好看。这意味着在理想情况下，他们希望所有字体的 x 轴高度与首选字体的 x 轴高度相等。换句话说，最合适的 `font-size-adjust` 取值就是你首选字体的纵横比。

## 如何计算一种字体的纵横比

要确定一种字体合适的纵横比，你可以凭实际经验就是调整后的字体大小应该跟原来声明的字体大小一样。这就是说上面公式中的 `a` 应该跟 `a'` 相等。

计算纵横比的第一步是先创建 2 个 `<span>` 元素，每个 `<span>` 元素将会包含一个字母和一个包围着字母的边框（因为我们要进行比较，所以每个 `<span>` 中的字母都必须相同）。同时，每个元素的 `font-size` 属性值都应该相同，但只有一个元素会使用 `font-size-adjust` 属性。当 `font-size-adjust` 的值等于给定字体的纵横比时，每个 `<span>` 下的字母都是一样的大小。

在下面的 demo 中，我创建了一个边框围绕着字母 ‘t’ 和 ‘b’ 并且对每组字母应用了不同的 `font-size-adjust` 属性值。

以下是相关代码：

```
.adjusted-a {
  font-size-adjust: 0.4;
}

.adjusted-b {
  font-size-adjust: 0.495;
}

.adjusted-c {
  font-size-adjust: 0.6;
}
```

正如下面 demo 所示，`font-size-adjust` 的值越大则字母会显得越大，反之则越小，当该值等于纵横比时，每组字母的尺寸都相等。

[![](http://oiklhfczu.bkt.clouddn.com/1504780206%281%29.jpg)](https://codepen.io/SitePoint/pen/YxxbMp)

## 在网站上使用 font-size-adjust

以下 demo 使用的 `font-size-adjust` 取值于上一个 CodePen demo 中为 ‘Lato’ 字体设置的值，现在将会用来调整 ‘Verdana’ 这个候选字体。会有一个按钮控制修改是否发生，所以你可以看出修改前后的变化：

[![](http://oiklhfczu.bkt.clouddn.com/1504780255%281%29.jpg)](https://codepen.io/SitePoint/pen/KvvLOr)

当你处理大量文字时效果会更加引人注目，然而上面的例子应该足够让你认识到这个属性的有用之处。

## 浏览器支持

目前，只有 Firefox 默认支持 `font-size-adjust` 属性。Chrome 和 Opera 分别从 43 和 30 版本开始作为试验特性予以支持，开发者需前往 chrome://flags 中开启 “Experimental Web Platform Features” 选项。Edge 和 Safari 不支持这个属性。

如果你决定使用这个属性，低版本浏览器的支持将不成问题，这个属性被设计时就已经考虑到向后兼容性，不支持的浏览器会正常的显示文本，支持的浏览器则会基于该属性的值调整字体大小。

## 总结

读完这篇文章后，你应该知道 `font-size-adjust` 属性是什么，为什么它很重要以及如何计算出不同字体的纵横比。

因为 `font-size-adjust` 在旧浏览器中优雅降级，你今天就可以直接应用该属性到你的生产环境中，以便提高页面文字易读性。

你还有其他工具或方法可以帮助开发者更快地计算纵横比吗？留言告诉他们吧。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
