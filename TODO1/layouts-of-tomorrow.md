> * 原文地址：[The Layouts of Tomorrow](https://mxb.at/blog/layouts-of-tomorrow/)
> * 原文作者：[mxbck](https://twitter.com/intent/follow?screen_name=mxbck)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/layouts-of-tomorrow.md](https://github.com/xitu/gold-miner/blob/master/TODO1/layouts-of-tomorrow.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：[IridescentMia](https://github.com/IridescentMia)

# 明日之布局

如果在过去几年中你参加过任一网页设计演讲，你可能已经看过 Jon Gold 这篇著名的推文：

![](https://i.loli.net/2018/08/18/5b77acde227f4.png)

它讽刺了今天很多网站看起来都一样的事实，因为它们都遵循我们共同决定使用的相同标准布局实践。建立博客？主栏，工具侧边栏。营销网站？大图，三个博眼球的框（**一定**是三个）。

当我们回顾早期的网页时，我认为今天的网页设计有更大的创造力。

## 进入 CSS 网格

[Grid](https://www.w3.org/TR/css-grid-1/) 是网页布局上第一个真正的工具。到目前为止，我们所拥有的一切，从表格到浮动，从绝对定位到弹性盒子 —— 都是为了解决不同的问题，我们找到了使用和滥用它来进行布局的方法。

这些新工具的重点不是使用不同的底层技术再次构建相同的东西。它有更多的潜力：它可以重塑我们对布局的思考方式，使我们能够在网页上做一些全新的，不同的事情。

我知道，当你长时间以某种方式构建东西时，很难进入一种新的思维模式。我们受过培训，将网站视为标题，内容和页脚的组合。还有条纹和盒子。

但为了让我们的行业持续进步（以及让我们的工作有趣），偶尔退一步并重新思考我们的工作方式是个好主意。

如果我们不这样做，我们仍然会使用间隔的 gif 图和全大写 `<TABLE>` 标签来构建东西。😉

## 那么，看起来会是什么样呢？

我在 dribbble 上寻找过让布局有所突破的想法。那种会让像我这样的前端开发人员乍一看眉头紧锁的设计。

有很多很棒的作品 —— 这里有一些我最喜欢的：

[![](https://mxb.at/blog/layouts-of-tomorrow/warehouse.jpg)](https://dribbble.com/shots/1573896-Warehouse)

"Warehouse" by [Cosmin Capitanu](https://dribbble.com/Radium)

[![](https://mxb.at/blog/layouts-of-tomorrow/fashion_boutique.gif)](https://dribbble.com/shots/2375246-Fashion-Butique-slider-animation)

"Fashion Boutique" by [KREATIVA Studio](https://dribbble.com/KreativaStudio)

[![](https://mxb.at/blog/layouts-of-tomorrow/organic_juicy.png)](https://dribbble.com/shots/4316958-Organic-Juicy-Co-Landing-Page)

"Organic Juicy Co." by [Broklin Onjei](https://dribbble.com/broklinonjei)

[![](https://mxb.at/blog/layouts-of-tomorrow/travel_summary.jpg)](https://dribbble.com/shots/1349782-Travel-Summary)

"Travel Summary" by [Piotr Adam Kwiatkowski](https://dribbble.com/p_kwiatkowski)

[![](https://mxb.at/blog/layouts-of-tomorrow/digital_walls.gif)](https://dribbble.com/shots/2652364-Digital-Walls)

"Digital Walls" by [Cosmin Capitanu](https://dribbble.com/Radium)

我特别喜欢最后一个。它让我想起了 Windows 8 中风靡一时的“Metro Tiles”。它不仅视觉上令人印象深刻，而且非常灵活 —— 它可以在手机，平板电脑上工作，在设计师的建议下，即使在巨大的电视屏幕上或 AR 中也可以。

考虑到我们今天拥有的工具，制作这样的东西有多难？我想搞清楚，于是开始构建原型。

我试着在生产环境的真实约束下来实现它。因此，界面必须具有响应性，高性能和可访问性。（尽管如此，它并不需要像素级还原，因为你懂的 —— [那是不可能的](http://dowebsitesneedtobeexperiencedexactlythesameineverybrowser.com/)。）

结果如下：

你可以在 Codepen 上查看[最终结果](https://codepen.io/mxbck/live/81020404c9d5fd873a717c4612c914dd)。

👉 **由于这仅用于演示目的，因此我没有为旧版浏览器降级、打补丁。我的目标是在这里测试现代 CSS 的功能，因此并非所有功能都具有跨浏览器支持（如下所示）。我发现它在最新版本的 Firefox 或 Chrome 中效果最佳。**

实现过程中一些有趣的东西：

### 布局

不出所料，“Metro Tiles”的关键因素是网格。整个布局逻辑在此代码块下自适应：

```
.boxgrid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    grid-auto-rows: minmax(150px, auto);
    grid-gap: 2rem .5rem;

    &__item {
        display: flex;

        &--wide {
            grid-column: span 2;
        }
        &--push {
            grid-column: span 2;
            padding-left: 50%;
        }
    }
}
```

神奇的地方主要在第二行。`repeat(auto-fit, minmax(150px, 1fr))` 响应地处理列创建，这意味着它将连续放入尽可能多的盒子以确保它们与外边缘对齐。

`--push` 修饰类用于实现设计的效果，其中一些盒子“跳过”一栏。由于在没有明确设置网格线的情况下这是不可能的，我用了个技巧：实际的网格单元格跨越两列，但只允许有足够的空间来填充单元格。

### 动画

原始设计中每节背景和每个 tile 网格以不同的速度移动，产生了深度上的错觉。没什么特别的，只是一些好的旧视差而已。

虽然这种效果通常是通过 Javascript 绑定滚动事件然后应用不同的 transform 样式来实现的，但还有更好的方法：完全用 CSS。

这里的秘诀是利用 CSS 3D 变换将图层沿 z 轴分开。Scott Kellum 和 Keith Clark 的[这项技术](https://developers.google.com/web/updates/2016/12/performant-parallaxing)实际上是通过在滚动容器上使用 perspective 和在视差子元素上使用 translateZ 来实现的：

```
.parallax-container {
  height: 100%;
  overflow-x: hidden;
  overflow-y: scroll;

  /* set a 3D perspective and origin */
  perspective: 1px;
  perspective-origin: 0 0;
}

.parallax-child {
  transform-origin: 0 0;
  /* move the children to a layer in the background,
     then scale them back up to their original size */
  transform: translateZ(-2px) scale(3);
}
```

这种方法的一个巨大好处是提高了性能（因为它不会触及带有计算样式的 DOM ），其结果是减少了重绘及做到几乎 60fps 的平滑视差滚动。

### 吸附点

[CSS Scroll Snap Points](https://drafts.csswg.org/css-scroll-snap/) 是一个有点实验性的功能，但我认为它很适合这种设计。基本上，你可以告诉浏览器在文档中滚动到接近某个元素的点时“吸附”到该元素上。目前支持非常有限，你最好的选择是在 Firefox 或 Safari 中使用它。

目前有不同版本的规范，只有 Safari 支持最新的实现。Firefox 仍然使用较旧的语法。组合方法如下所示：

```
.scroll-container {
    /* current spec / Safari */
    scroll-snap-type: y proximity;

    /* old spec / Firefox */
    scroll-snap-destination: 0% 100%;
    scroll-snap-points-y: repeat(100%);
}
.snap-to-element {
    scroll-snap-align: start;
}
```

`scroll-snap-type` 告诉滚动容器沿着 `y` 轴（垂直方向）根据 `proximity` “严格”地进行吸附。这使浏览器可以决定是否可以使用吸附点，以及是否是跳转的好时机。

对于功能强大的浏览器，吸附点是一个小小的增强功能，而其他浏览器只是简单地降级为默认滚动。

### 平滑滚动

唯一涉及 Javascript 的地方是在左侧的菜单项或点击顶部/底部的方向箭头时处理平滑滚动时。这是从简单的页内锚链接 `<a href="#vienna">` 跳转到所选部分的渐进增强。

为了实现动画，我选择使用 vanilla `Element.scrollIntoView()` 方法 [(MDN Docs)](https://developer.mozilla.org/de/docs/Web/API/Element/scrollIntoView)。某些浏览器接受一个可选参数来使用“平滑”滚动行为，而不是立即跳转到目标部分。

[scroll behaviour property](https://developer.mozilla.org/en-US/docs/Web/CSS/scroll-behavior) 目前是一个工作草案，所以还没有普遍支持。目前只有 Chrome 和 Firefox 支持此功能 —— 但是，如果需要，可以使用[补丁](http://iamdustan.com/smoothscroll/)。

## 创造性思考

虽然这只是对可能性的一种解释，但我确信使用我们现有的工具可以实现无数其他创新想法。设计趋势可能一如既往地来去匆匆; 但我确信认为值得记住的是，网页是一种流动的媒介。技术在不断变化，为什么我们的布局保持不变？去探索吧。

## 更多资源

*   [Invision “Design Genome” Site](https://www.invisionapp.com/enterprise/design-genome) - Awesome Grid Layout
*   [Layout Land](https://www.youtube.com/channel/UC7TizprGknbDalbHplROtag) - Jen Simmons’ Youtube Channel
*   [The New CSS Layout](https://abookapart.com/products/the-new-css-layout) - Rachel Andrew (A Book Apart)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
