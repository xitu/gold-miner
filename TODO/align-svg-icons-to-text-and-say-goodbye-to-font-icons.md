> * 原文链接: [Align SVG Icons to Text and Say Goodbye to Font Icons](https://blog.prototypr.io/align-svg-icons-to-text-and-say-goodbye-to-font-icons-d44b3d7b26b4#.9gcnlx2bm)
* 原文作者 : [Elliot Dahl](https://blog.prototypr.io/@Elliotdahl)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [aleen42](https://github.com/aleen42)
* 校对者 : [zhouzihanntu](https://github.com/zhouzihanntu)、[hikerpig](https://github.com/hikerpig)

![](https://cdn-images-1.medium.com/max/1600/1*YJKqXVh1XZcKB9QeyVcKkA.png)

# 把 SVG 图标对齐到文本，以告别字体图标（Font Icons）的时代

在字体图标盛行的时代，推行 SVG 图标可谓是 Web 社区中的一次重要契机。毕竟，使用 SVG 图标系统能更好地遵循图形的访问性标准，并渲染出更高质量的图像。此外，开发者还能轻而易举地通过该类系统增加/删除/修改库中的图标。因此，鉴于这样的优势，我们使用 React 开发了一套自家的 SVG 图标系统产品，并发布在 [Pivotal](https://pivotal.io/) 上。本文将阐述作者如何使用 CSS 来对 SVG 图标系统进行样式的定制以高效便捷地使用该类系统。

### 为何在乎 SVG 图标样式的定制方式？

若您过去曾使用过像 [Font Awesome](http://fontawesome.io/) 这样的字体图标系统，你就会发现在一个项目中引用并使用该类系统将会是一件极其简单的事情。况且，我们还能轻松地把该类字体图标对齐到文本，并通过 `font-size` 属性修改元素的大小。而相比之下，我们目前却还没有一套清晰的方法去为 SVG 图标定制样式。当然，市面上的一些系统也只是把定制的样式应用到库中的单个图标，而非全部。因此，在 UI 中倘若想同时利用超过15个 SVG 图标，那将会是一件何等痛苦且无法持续下去的事情。

### **SVG 图标能像字体图标那样进行缩放吗？**

我们只需要引用一个 CSS 类对 SVG 的尺寸置为 1em / 1em 的大小，就能模拟使用 `font-size` 属性去缩放图标。这也就意味着，若标题文本的字体尺寸为 48px，那么对应之下 SVG 图标将会是 48px / 48px 的大小。当往像按钮或输入框这样的组件添加图标时，该方法显得尤为有效。此外，我们还可以通过修饰类或使用内联的 CSS 样式来给定一个字体尺寸。换而言之，SVG 图标的大小取决于其 `font-size` 属性。

![](https://cdn-images-1.medium.com/max/1600/1*rrztHq_Ic2NwMp5CkHzYog.png)

    .svg-icon svg {
      height: 1em;
      width: 1em;
    }

### **如何解决 SVG 图标未与文本对齐的问题？**

上述方法的负面影响在于，DOM 元素自身并未与文本对齐。针对于此，过去我会采用一个标签处理类（handler class）`.svg-icon` 来承托该元素的尺寸，并使用相对定位的方式进行布局。这样的话，SVG 图标就能在该类内部采用绝对定位的方式改变位置。也就是说，把该图标往下移动 “-0.125em” 的距离，就可以使得图标在任何尺寸下都能往下移动12.5%。

![](https://cdn-images-1.medium.com/max/1600/1*F49a4lqd8Lw5eFVTnPm4Lg.png)

从该首例中，我们可以看到 DOM 元素默认情况下会与文本的基线（baseline）对齐。既然图标已经适配于该基线，那么，我们只需要把该基线往下移动，就能达到真正对齐的效果。因此，通过计算可以得出上述例子尺寸下的移动距离为 6px，或 6px/48px，即12.5%。同样，在第二个例子中，我们只需要把图标往下移动-0.125em 的位置，即能对齐文本的基线。

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

### 该方法适用于个人的字体和图标系统吗？

也许适用吧。毕竟，每一种字体都会以不同的方式进行构建。从下例可以看到，尽管每一个字族中的字母都有着同样的 `font-size` 值，但它们却有着各自唯一的宽高。当然，浏览器对行高容器（line-height container）的计算并不会产生任何变化，但这也并不意味着你不需要为自己已有图标集定制出一个 CSS 样式，来修改图标的位置。

![](https://cdn-images-1.medium.com/max/1600/1*GSfAY-rib0QAngPUK9LHMA.png)

### 如何创建一个新图标？

首先，先创建一个模板并制定好字体的尺寸。如下图所示，我是采用了96px 的文本尺寸，并配有相称的行高。然后，画出数条红线来标识文本行高及其基线的边界，以便分辨出最大的图标。当然在该例中，我还借鉴了 [Google 的 Material 图标](https://material.io/icons/)并引用其[设计模板](https://material.io/guidelines/style/icons.html#icons-system-icons)，去更好地理解如何构建属于自己的图标。

![](https://cdn-images-1.medium.com/max/2000/1*-fnv9uyDUgahTAozqb9jqg.png)

利用下面这个 Codepen 来测试你自己的字体与图标的配对效果。

[![](http://i1.piimg.com/567571/92bc3cae3455dbc9.jpg)](https://codepen.io/elliotdahl/embed/ygYrvm?amp%3Bdefault-tabs=html%2Cresult&amp%3Bembed-version=2&amp%3Bhost=http%3A%2F%2Fcodepen.io&amp%3Bslug-hash=ygYrvm&height=600&referrer=https%3A%2F%2Fblog.prototypr.io%2Fmedia%2F78db9599a37b1b90530624815c99c973%3FpostId%3Dd44b3d7b26b)

### **有何优化之处？**

当然有。如有任何想法，不妨留言或访问我的 [Twitter](https://twitter.com/Elliotdahl)。

### 想要了解 SVG ？

可查阅相关资料以快速入门。

《[从字体图标转向 SVG - Making the Switch Away from Icon Fonts to SVG](https://sarasoueidan.com/blog/icon-fonts-to-svg/)》，Sara Soueidan

《[内联 SVG vs 字体图标 [网战中] - Inline SVG vs Icon Fonts [CAGEMATCH]](https://css-tricks.com/icon-fonts-vs-svg/)》，Chris Coyier

《[千万不要使用字体图标 - Seriously, Don’t Use Icon Fonts](https://cloudfour.com/thinks/seriously-dont-use-icon-fonts/)》，Tyler Sticka

《[使用 React 去创建一个 SVG 图标系统 - Create an SVG Icon System with React](https://css-tricks.com/creating-svg-icon-system-react/)》，Sarah Drasner
