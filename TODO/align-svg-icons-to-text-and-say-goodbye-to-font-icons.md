> * 原文链接: [Align SVG Icons to Text and Say Goodbye to Font Icons](https://blog.prototypr.io/align-svg-icons-to-text-and-say-goodbye-to-font-icons-d44b3d7b26b4#.9gcnlx2bm)
* 原文作者 : [Elliot Dahl](https://blog.prototypr.io/@Elliotdahl)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :
* 校对者 :

![](https://cdn-images-1.medium.com/max/1600/1*YJKqXVh1XZcKB9QeyVcKkA.png)

# Align SVG Icons to Text and Say Goodbye to Font Icons

# 对齐 SVG 图标与文本，以告别文本图标的时代

The push for SVG icons over font icons has caught serious momentum in the web community. With an SVG icon system you can better meet accessibility standards, render higher quality visuals, and add/remove/modify icons in the library with ease. At [Pivotal](https://pivotal.io/) we’ve created an SVG icon system with React for use on our suite of products. This article is about my approach to styling the SVG icon system with CSS to make it easy and effective to use.

在文本图标盛行的时代，推行 SVG 图标可谓是 Web 社区中的一次重要契机。毕竟，SVG 图标系统能更好地遵循图形的访问性标准，并渲染出更高质量的图像。此外，开发者还能轻而易举地通过该类系统对库中的图标进行增删改查。因此，鉴于这样的优势，我们使用 React 开发了一套自家的 SVG 图标系统产品，并发布在 [Pivotal](https://pivotal.io/) 上。本文将阐述作者是如何使用 CSS 来对 SVG 图标系统进行样式定制以高效便捷地使用该类系统。

### Why should I care about how SVGs are styled?

### 为何要关注 SVG 图标样式的定制方式？

If you’ve ever used font icon systems like [Font Awesome](http://fontawesome.io/) you know how easy it is to add to a project and get going. The icons align to your text easily and can be modified by changing the font-size of the element. There is no clearly defined way for styling an SVG icon system. I’ve seen some systems custom style and place each icon in their library. This route sounds painfully unsustainable if you utilize more than 15 icons in your UI.

若您曾经用过像 [Font Awesome](http://fontawesome.io/) 这样的文本图标系统，你就会发现引用该类系统到一个项目中并使用它将会是一件何等简单的事情。而且，该类文本图标能轻松地对齐文本，并通过 `font-size` 属性修改元素的大小。相比之下，目前我们还没有一套清晰的方法去为 SVG 图标定制样式。当然，市面上的部分系统只是把定制的样式应用到库中的单个图标。可想而知，在 UI 中倘若想同时利用超过 15 个图标，那将会是一件何等痛苦且无法持续下去的事情。

### **Can it scale like an icon font?**

### **我们能像文本图标一样缩放 SVG 图标吗？**

To emulate the font-size scaling I use a class to set the SVG size to 1em by 1em. This means that if your title text is a 48px font size the SVG will be 48px by 48px. This works nicely for components like buttons and inputs when you want to add an icon. This also empowers you to pass a font size to the element via modifier class or inlined CSS. Using font-size to determine the size of your icon makes your life a little easier.

为了仿真使用 `font-size` 属性去进行缩放，我通过一个类把 SVG 的尺寸置为 1em / 1em 的大小。这就意味着，若你的标题文本为 48px 的尺寸，那么对应之下 SVG 图标将会是 48px / 48px 的大小。该方法对于想要添加像按钮或输入框这样的图标组件时，尤为有效。同时，有了该方法，你还可以通过修改类或内联的 CSS 样式来传递一个文本尺寸。这也就意味着，你可以简单地通过 `font-size` 属性去决定 SVG 图标的大小。

![](https://cdn-images-1.medium.com/max/1600/1*rrztHq_Ic2NwMp5CkHzYog.png)

    .svg-icon svg {
      height: 1em;
      width: 1em;
    }

### **My SVG won’t align to with my text. How do I fix this?**

### **我的 SVG 图标并未对齐文本，该如何解决？**

The downside is that a DOM element on it’s own doesn’t align nicely with text. To counter this I wrote the .svg-icon handler class to hold the size and be relative positioned so that I can absolute position the SVG inside of it. Moving the icon down by “-0.125em” allows me to pull down the icon by 12.5% at any scale.

上述方法其负面的影响在于，DOM 元素自身并未与文本对齐。针对于此，过去我会采用一个标签处理类（handler class）`.svg-icon` 来承托该元素的尺寸，并使用相对定位的方式进行布局。这样的话，SVG 图标就能在该类内部采用绝对定位的方式进行布局。也就是说，把该图标往下移动 `-0.125em` 的距离，可以使得图标在任何尺寸下都能往下移动 12.5% 的距离。

![](https://cdn-images-1.medium.com/max/1600/1*F49a4lqd8Lw5eFVTnPm4Lg.png)

The first example shows that DOM elements align to the baseline of text by default. However, since our icon is already properly scaled to consider the baseline, we need to pull it down for the baseline to truly align. At this size the distance is 6px away, 6px/48px = ? or 12.5%. In the second example, pulling the icon down by -0.125em places the icon onto the proper baseline of the text.

从该首例我们可以看出，DOM 元素默认情况下会与文本的基线（baseline）对齐。既然，我们的图标已经适配于该基线，那么，我们只需要把该基线往下移动，就能达到真正对齐的效果。通过计算，上述例子尺寸下的移动距离为 6px，或 6px/48px，即 12.5%。同样在第二个例子中，我们只需要把图标往下移动 -0.125em 的位置，就能与文本的基线对齐。

    .svg-icon {
      display: inline-flex;
      align-self: center;
      position: relative;
      height: 1em;
      width: 1em;
    }

    .svg-icon svg {
      height:1em;
      width:1em;
    }

    .svg-icon.svg-baseline svg {
      bottom: -0.125em;
      position: absolute;
    }

### Will this work with my typeface and icon system?

### 该方法适用于你的字体图标系统吗？

Maybe. Every typeface is built differently. In the example below you can see that despite being the same font-size the letter height and width are unique to each family. However, the browser’s measurement of the line-height container will not change. You may have to customize the CSS above to position your existing icon set.

也许适用吧。毕竟，每一种字体都会以不同的方式进行构建。从下面的例子我们也可以看到，尽管每一个字体家族中的字母都有着同样的 `font-size` 值，但它们却有着各自唯一的宽高。当然，浏览器对行高容器（line-height container）的计算并不会产生变化，但这并不意味着你不需要为自己既定的图标集定制出一个 CSS 样式，来修改图标的位置。

![](https://cdn-images-1.medium.com/max/1600/1*GSfAY-rib0QAngPUK9LHMA.png)

### How do I create new icons?

### 如何创建一个新图标？

Start with a template sized to match a sample of your preferred typeface. In the example below I’m using a 96px font-size with with a matching line-height. Drawing redlines to describe the boundaries of the line-height and the baseline of the text I’m able to figure out how to size my largest icons. In this example I’m comparing [Google’s Material Icons](https://material.io/icons/). I’ve referenced their [icon design template](https://material.io/guidelines/style/icons.html#icons-system-icons) to better understand how to build my own icons.

首先，先创建一个模板并制定好字体的尺寸。如下图所示，我是采用了 96px 的文本尺寸，并配有相称的行高。然后，画出数条红线来标识文本行高及其基线的边界，以便分辨出最大的图标。当然在该例中，我还借鉴了 Google 的 Material 图标，去更好地理解如何构建属于自己的图标。

![](https://cdn-images-1.medium.com/max/2000/1*-fnv9uyDUgahTAozqb9jqg.png)

查阅以下 Codepen 并测试自己的字体与配对的图标。

Check out this Codepen below to test your own typeface and icon pairing.

[![](http://i1.piimg.com/567571/92bc3cae3455dbc9.jpg)](https://codepen.io/elliotdahl/embed/ygYrvm?amp%3Bdefault-tabs=html%2Cresult&amp%3Bembed-version=2&amp%3Bhost=http%3A%2F%2Fcodepen.io&amp%3Bslug-hash=ygYrvm&height=600&referrer=https%3A%2F%2Fblog.prototypr.io%2Fmedia%2F78db9599a37b1b90530624815c99c973%3FpostId%3Dd44b3d7b26b)

### **Can this be improved?**

### **是否有可优化之处？**

Yes. If you’ve got thoughts, please leave a comment or reach out on [Twitter](https://twitter.com/Elliotdahl).

有。如有想法，不妨留言或访问我的 [Twitter](https://twitter.com/Elliotdahl)。

### Not on the SVG train?

### 想要了解 SVG ？

Go check out these amazing articles to get caught up.

可查阅相关资料以快速入门。

《[从文本图标转向 SVG - Making the Switch Away from Icon Fonts to SVG](https://sarasoueidan.com/blog/icon-fonts-to-svg/)》，Sara Soueidan

《[内联 SVG vs 文本图标 [网战中] - Inline SVG vs Icon Fonts [CAGEMATCH]](https://css-tricks.com/icon-fonts-vs-svg/)》，Chris Coyier

《[千万不要使用文本图标 - Seriously, Don’t Use Icon Fonts](https://cloudfour.com/thinks/seriously-dont-use-icon-fonts/)》，Tyler Sticka

《[使用 React 去创建一个 SVG 图标系统 - Create an SVG Icon System with React](https://css-tricks.com/creating-svg-icon-system-react/)》，Sarah Drasner
