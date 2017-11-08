> * 原文地址：[Rebuilding slack.com: A redesign powered by CSS Grid and optimized for performance and accessibility.](https://slack.engineering/rebuilding-slack-com-b124c405c193)
> * 原文作者：[Mina Markham](https://slack.engineering/@minamarkham?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/rebuilding-slack-com.md](https://github.com/xitu/gold-miner/blob/master/TODO/rebuilding-slack-com.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：[IridescentMia](https://github.com/IridescentMia)、[Usey95](https://github.com/Usey95)

# 重建 slack.com

## 使用 CSS Grid 重新设计，并针对性能和可访问性进行了优化。

![](https://cdn-images-1.medium.com/max/1000/1*N48fpqutpCqswRistXpymw.jpeg)

[Alice Lee](http://byalicelee.com/) 的插图。

在八月, 我们重新设计了 [slack.com](https://slack.com/),我们想让您稍微看下屏幕后面发生了什么。重建我们的营销网站是一个经过各团队、部门、机构仔细协调的大规模项目。

我们重新设计网站的同时彻底检查了所有的底层代码。我们想要同时实现这样的一些目标：提供一致的更新体验的同时对网站的架构，代码的模块化，整体性能和可访问性进行大改。这将为公司的几个重大事宜提供新的基础，包括[国际化](https://slackhq.com/bienvenue-willkommen-bienvenidos-to-a-more-globally-accessible-slack-546a458b21ae).

![](https://cdn-images-1.medium.com/max/400/1*Q0gC53oTuet-cjsfhRafUQ.png)

![](https://cdn-images-1.medium.com/max/400/1*HrvfG0uHQYUc0j763Cp4uw.png)

![](https://cdn-images-1.medium.com/max/400/1*5BjTaWrvqZPjbhDrS5FBOQ.png)

Slack.com (从左到右: 2013 年 8 月, 2017 年 1 月, 2017 年 8 月)

### 更干净、精简的代码

旧的 slack.com 和我们基于 web 的 Slack 客户端共享了很多代码和资源依赖。我们的目标之一就是将网站和 “web app” 解耦，以简化我们的代码库。通过只包含我们运行 slack.com 所需要的资源的方式，可以提高站点的稳定性，减少开发人员的困惑，创建一个更容易迭代的代码库。这项工作的基本部分之一就是创建我们新的UI框架，名为 :spacesuit: **👩🏾‍🚀**。

:spacesuit: 框架包含基于类(class)的可重用组件和用于标准化我们营销页面的工具类。它降低了我们的 CSS 载荷，在一种情况下降低了近70%(从 416kB 降低至 132kB).

其他有意思的数据：

* 声明数量从 1,881 降至 799 
* 颜色数量从 91 降至 14 
* 选择器数量从 2,328 降至 1,719

![](https://cdn-images-1.medium.com/max/1000/0*Kx8ltSgpKXyXRdaD.)

**_重建之前_**_：大量的波动表明 [CSS 特异性](https://csswizardry.com/2014/10/the-specificity-graph/)管理不善。_

![](https://cdn-images-1.medium.com/max/1000/0*BmFqbD-18McrbaDi.)

**_重建之后_**_：使用大部分基于类的系统导致我们的特异性下降。_

我们的 CSS 是基于 [ITCSS 理念](http://www.creativebloq.com/web-design/manage-large-css-projects-itcss-101517528) 组织的，并且使用 [类似 BEM ](https://csswizardry.com/2015/08/bemit-taking-the-bem-naming-convention-a-step-further/) 命名规范。选择器使用单个字母作为前缀来指定类表示的类型。前缀后面跟着组件的名称以及组件的所有变体。举个例子，`u-margin-top--small` 表示我们用变量将 `margin-top` 设置为比较小的数值的工具类。这样的工具类是我们系统不可或缺的部分，因为它允许我们的开发者在不重写大量 CSS 的情况下微调 UI 片段。另外，组件之间的距离是创建设计系统窍门之一。诸如 `u-margin-top--small` 这样的工具类可以创建一致的间距，让我们不必去重置或撤销任何已经设置到组件上的间距。
![](https://cdn-images-1.medium.com/max/800/0*YrT_q3rSjUFssyYy.)

加载时间减少了 53% 的定价页面是我们最大的成果。

### 现代的响应式布局

新网站使用 Flexbox 和 CSS Grid 的组合来创建响应式布局。我们想要使用 CSS 最新的特性，又希望那些使用较旧的浏览器的访问者获得相似的体验。

开始我们尝试使用 CSS Grid 实现传统的 12 列网格布局，但是最终没有奏效。因为当网格是两种的时候，我们会把自己限制在单一的尺寸布局上。最后我们发现实际上[并不需要](https://rachelandrew.co.uk/archives/2017/07/01/you-do-not-need-a-css-grid-based-grid-system/)基于列的网格。由于 Grid 布局允许你去创建自定义的网格来适配你所有的布局，所以不需要强制12列网格。相反，我们为设计中一些常见的布局模式创建了 CSS Grid 对象。

一些模式很简单

![](https://cdn-images-1.medium.com/max/1000/0*IXMPtmw5vQfr-fZ0.)

经典的三列网格块布局

其他更复杂的则真正展现了 Grid 的能力

![](https://cdn-images-1.medium.com/freeze/max/30/0*Q_tqzOLre__HPLIL.?q=20)

![](https://cdn-images-1.medium.com/max/2000/0*Q_tqzOLre__HPLIL.)

照片拼贴对象

在实现我们的网格之前，像上面这样的布局需要大量的包装，有时使用空 div 来模仿一个二维网格。

```
<section class=”o-section”>
    <div class=”o-content-container”>
        <div class=”o-row”>
            <div class=”col-8">…</div>
            <div class=”col-4">…</div>
        </div>
        <div class=”o-row”>
            <div class=”col-1"></div>
            <div class=”col-3">…</div>
            <div class=”col-8">…</div>
        </div>
    </div>
</section>
```

使用 CSS Grid，我们可以删除模拟网格所需要的额外标记，只需要在本地简单的创建一个就好。使用 Grid 让我们可以使用更少的标记。此外还确保我们使用的标记是有语义的。

```
<section class=”c-photo-collage c-photo-collage--three”>
    <img src=”example-1.jpg” alt=””>
    <img src=”example-2.jpg” alt=””>
    <blockquote class=”c-quote”>
        <p class=”c-quote__text”>…</p>
    </blockquote>
    <img src=”example-3.jpg” alt=””>
</section>
```

起初，我们使用 Modernizr 来测试对网格的支持情况。然而当库加载时，导致了闪烁的无格式布局。

![](https://cdn-images-1.medium.com/max/1000/0*PFKwdHYeunJfV-Sh.)

当 Modernizr 检测到网格支持的时候，页面默认为移动布局并重排。

我们认为解决布局切换时抖动的体验比向后兼容更重要。折中方案是将 CSS Grid 作为增强方案，当有需要时回退到 Flexbox 和其他技术。
我们使用了 CSS 功能查询来检测网格支持，而不是使用库。不幸的是，并不是每一个浏览器都支持功能查询。这就意味着只有能处理 `@supports` 规则的浏览器才能使用 CSS Grid 布局。因此，IE11，即使支持某些网格功能，也将会使用基于 FLexBox 的布局。

我们使用一些目前尚未在所有浏览器中完全支持的 Grid 功能。最明显的就是基于百分比的 `grid-gap`。尽管 Safari 的某些版本已经支持这个属性，但是我们仍然需要预见到它的缺失。在实践中，Grid 对象的样式如下：

```
@supports (display: grid) and (grid-template-columns: repeat(3, 1fr)) and (grid-row-gap: 1%) and (grid-gap: 1%) and (grid-column-gap: 1%) {
    .c-photo-collage {
        display: grid;
        grid-gap: 1.5rem 2.4390244%;
    }
    .c-photo-collage > :nth-child(1) {
        grid-column: 1 / span 3;
        grid-row: 1;
    }
    .c-photo-collage > :nth-child(2) {
        grid-column: 2;
        grid-row: 2;
    }
    .c-photo-collage > :nth-child(3) {
        grid-column: 4;
        grid-row: 1;
        align-self: flex-end;
    }
    .c-photo-collage > :nth-child(4) {
        grid-column: 3 / span 2;
        grid-row: 2 / span 2;
    }
};
```
任何不符合查询要求的浏览器将使用我们的 FlexBox 回退方案

```
@supports not ((display: grid) and (grid-column-gap: 1%)) {
    /* fabulously written CSS goes here */
}
```

### 流式排版

一旦我们有响应式的布局，我们需要同样适应性的排版。我们使用了[Less mixins](http://lesscss.org/features/#mixins-feature) 来帮助我们微调排版。排版是一个可以作为所有排版设置单一来源的 mixin。对于每种类型的样式，mixin中都会创建一个包含样式名称或者用途的新行，后跟每种类型样式的设置列表。它们的顺序是：`font-family`，min 和 max `font-size` (默认单位是rem)，`line-height`，`font-weight`，以及任何的 `text-transforms`。例如 `uppercase`。为了清楚起见，每种类型名称都以 `display-as-`作为前缀，确保其目的明确。

下面是 mixin 的简化版本：

```
.m-typeset(@setting) {
    @display-as-h1: @font-family-serif, 2, 2.75, 1.1, @font-semibold;
    @display-as-btn-text: @font-family-sans, .9, .875, 1.3, @font-bold, ~”uppercase”;
    font-family: extract(@@setting, 1);
    font-weight: extract(@@setting, 5);
    line-height: extract(@@setting, 4);
}
```

看看它的作用：

```
.c-button { .m-typeset(“display-as-btn-text”); }
```

这个 mixin 的逻辑需要一个参数，比如 `display-as-btn-text`，并且会从列表中提取每个属性指定的索引。在这个例子中，`line-height` 属性将设置为1.3，因为它是第4个索引值。所以产生的 CSS 将是

```
.c-button {
    font-family: ‘Slack-Averta’, sans-serif;
    font-weight: 700;
    line-height: 1.3;
    text-transform: uppercase;
}
```

### 美术指导 & 意象(imagery)

[Alice Lee](http://byalicelee.com/) 为我们提供了一些漂亮的插图，我们想要确保我们尽可能好的展出他们。有时想要根据视口(viewport)宽度来显示不同版本的图像。我们在视网膜(retina)和非视网膜(non-retina)资源之间进行切换，对特定的屏幕宽度进行图像调整。

这个过程也成为 [美术指导(art direction)](http://usecases.responsiveimages.org/#art-direction),通过使用 [Picturefill](https://scottjehl.github.io/picturefill/) 的 `[picture](https://html.spec.whatwg.org/multipage/embedded-content.html#embedded-content)` 和 `[source](https://html.spec.whatwg.org/multipage/embedded-content.html#embedded-content)` 元素作为旧版浏览器的 polyfill。例如设备尺寸，设备分辨率，方向等定义的特征可以让我们在设计时规定显示不同的图像资源。

![](https://cdn-images-1.medium.com/max/1000/1*5SzojYwz0QGQF614iNNBmg.gif)

我们的功能页面使用  _srcset_  来显示基于视口大小的不同图像。

借助这些工具，我们能够根据我们设置的查询参数来显示资源的最佳版本。在上面的例子中，小视口需要更简单的首图(hero image)。

```
<picture class=”o-section__illustration for-desktop-only”>
    <source srcset=”/img/features/information/desktop/hero.png” sizes=”1x, 2x” media=”(min-width: 1024px)” alt=””>
    <img srcset=”/img/features/information/mobile/hero.png” sizes=”1x, 2x” alt=””>
</picture>
```

这种技术使我们能够为特定的媒体查询显示指定的图片资源，以及需要的是视网膜还是非视网膜资源。最终的结果是在整个网站上良好的美术指导。


### 兼容, 从头开始

另一个主要的目标就是确保低视力用户，屏幕阅读器用户和键盘用户可以轻松的浏览网站。从一个干净的代码库开始，我们用少量额外的工作就能在颜色的对比，HTML 的语义化和键盘的可访问性上做出很多有效的改进。此外，我们还能够使用一些新功能来获得更好的访问体验。我们在导航前面添加了[跳过链接](https://webaim.org/techniques/skipnav/)，以便用户可以根据需要绕过菜单。为了获得更好的屏幕阅读体验，我们添加了[aria-live 区域](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Live_Regions) 和辅助函数来报告表单错误和路由更改。此外，在交互键盘可访问和明显的焦点状态上，我们也努力使用清晰，描述性的替代文字(alt text)。


### 期待

在获得更好性能，可维护性和可访问性上，总是有很多的胜利。我们正在改进我们站点的遥测(telemetry)，以更好的了解瓶颈所在，以及我们可以在哪些方面发挥最大的影响力。我们为自己取得的进步感到骄傲。我们希望为世界各地的客户创造更愉快的体验。


* * *

感谢 [Matt Haughey](https://medium.com/@mathowie?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
