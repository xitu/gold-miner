> * 原文地址：[Using CSS Grid: Supporting Browsers Without Grid](https://www.smashingmagazine.com/2017/11/css-grid-supporting-browsers-without-grid/?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/css-grid-supporting-browsers-without-grid.md](https://github.com/xitu/gold-miner/blob/master/TODO/css-grid-supporting-browsers-without-grid.md)
> * 译者：[Raoul1996](https://github.com/Raoul1996)
> * 校对者：[AceLeeWinnie](https://github.com/AceLeeWinnie)、[su-dan](https://github.com/su-dan)

# 使用 CSS Grid：以兼容不支持栅格化布局的浏览器

**摘要**

当使用任何 CSS 的新特性的时候，浏览器的兼容问题都必须去解决。与 Flexbox 和 CSS Grid 一样，在使用 CSS 新特性布局时，兼容性比性能增强更值得考虑。

在这篇文章中，我将探索**现今处理浏览器兼容问题**的方法。为了让我们现在就用上 CSS 的新特性，我们可以做出哪些努力，仍然给那些不支持新特性的浏览器提供很好的体验？

### 我们说的支持是什么？

在阐明如何在去支持那些本身不支持网格的浏览器之前，很有必要搞明白 **支持** 的含义。支持也许是站点必须在列表中的浏览器上看起来完全相同。这可能意味着对于所有的浏览器，你都可以不用去做一些收尾工作。这可能意味着你在测试这些浏览器的时候对他们能获得一致的体验而感到十分高兴。

一个相关的问题就是**你怎么确定要支持的浏览器列表？**即使是一个全新的网站，也不应该拍脑袋就定了。对于今天的大多数的企业都曾经创建过网站。你可能有一些分析工具用于查看网站支持的浏览器，但是要注意这些工具不会检测对移动端的支持情况。如果在较小屏幕上表现不佳，人们便不会在手机上访问这个网站！

如果没有任何的分析工具，你可以在 [Can I Use](https://caniuse.com/) 上面导入你所在位置的数据。

[![在 Can I Use 上可以导入你所在位置的使用情况数据](https://www.smashingmagazine.com/wp-content/uploads/2017/11/can-i-use-import-data-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/can-i-use-import-data-large-opt.png)

在 [Can I Use](https://caniuse.com/) 这个网站上，你可以导入所在位置的使用情况数据。 ([预览大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/can-i-use-import-data-large-opt.png))

同样值得在这里牢记网站的目标。例如，希望吸引生活在印度等新兴市场的访问者的网站应该确保能在这些国家用户使用的浏览器中正常运行。

### 我仅仅只需要担心旧浏览器吗？

截止发稿，Edge，Chrome，Firefox，Opera，Safari，iOS Safari 都支持了网格布局。

IE10 和 IE11 支持带有 `-ms` 前缀的原始规格。对于你正在使用的 **旧** 浏览器来说：

*	Internet Explorer 9（如果仅考虑新的规范，则为 IE 11 及更低版本）
* Edge 15 及以下
* Firefox 52 之前的版本
* Safari 和 iOS Safari 10.1 版本之前
* Chrome 57 之前的版本
* Samsung Internet 6.2 之前的版本

然而，正如上一节所述，这些流行的桌面端和移动端浏览器在新兴市场中已经更常用。**这些浏览器还不支持网格布局**。比如说从世界范围来看，UC 浏览器占用了 8.1% 的流量，俨然是世界第三大流行的浏览器。但是如果碰巧你住在美国或者欧洲，可能你从来都没有听说过。

[![](https://www.smashingmagazine.com/wp-content/uploads/2017/11/StatCounter-browser-ww-monthly-201610-201710-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/StatCounter-browser-ww-monthly-201610-201710-large-opt.png)

([图片来源](http://gs.statcounter.com/)) ([预览大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/StatCounter-browser-ww-monthly-201610-201710-large-opt.png))

UC 浏览器不支持网格布局。它不仅针对低功耗设备进行了优化，也适用于那些流量费昂贵地区的用户。这是我们在开始规划支持的一个重要考虑因素。

### 有没有 CSS Grid 的 Polyfill（垫片）？

在第一次遇到 CSS Grid 的时候，一个显而易见的问题是：“我可以使用 polyfill 吗？”不幸的是，即使有这样的好事，对于整个布局来说，一个神奇的 polyfill 既不太可能出现，也不是一个好主意。

使用旧的布局方式，网格几乎做不到这一点。所以，为了在不支持的浏览器中复制网格布局，需要在 JavaScript 中做很多的工作。即使在资源充足的计算机上，使用了快速渲染引擎，在计算高度和元素的定位方面还是可能会带来一些令人生厌的体验。我们已经知道，**不支持网格的浏览器**是新兴市场上低功耗设备上最常见的 **较老**，或者较慢的浏览器。为什么硬要在这些设备上放一堆 JavaScript 呢？

不要搜索一个 polyfill，而是要考虑如何使用网格布局为那些不支持的浏览器提供更好的体验。在支持的浏览器上，使用网格可以用最少的 CSS 创造复杂的布局，但同时仍然要为那些不支持的浏览器提供良好的体验。这样会比仅仅在这个问题上抛出一个 polyfill 多一些工作，但是这样做的话，你可以保证能提供良好的体验，反而让网站在所有的地方显示相同不是最重要的目标。

### 网格布局降级方案

那么，我们如何为正在使用的设备和浏览器提供定制的支持？事实证明，CSS 中有你要的答案。

#### 浏览器忽略那些他们不懂的 CSS

图片的第一部分是浏览器略过他们不懂的 CSS。如果一个浏览器不支持 CSS Grid 布局，遇到 `grid-template-columns` 属性的时候，他不知道这是什么东西，所以就会跳过这行继续解析下面的内容。

这就意味着你需要用一些旧的 CSS，就像你过去那样，使用 `float` 或者 `display: table-cell` 在古老浏览器中实现网格样式的布局。不支持网格布局的浏览器将使用此布局并且忽略所有的网格声明。支持网格布局的浏览器将会继续寻找网格指令并且应用他们。这一点上，我们需要考虑如果使用其他布局方法的项目成为网格项目的时候会发生什么情况。

#### 新布局兼容旧布局

规范规定了如果你的页面上有使用其他布局方式定位的元素的时候，网格将会如何处理。

使用了浮动（float）或清除（clear）属性的元素，再应用网格成为网格元素的话，将不再表现为浮动或清除，就像从没用过它们一样。在下一个 CodePen 中删除应用了 `.grid` 类的所有属性，你可以看到我们所有的项目是如何浮动的，第三个项目是如何清除浮动的。但是在网格布局中，这将被忽略。

可以看下 rachelandrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 写的这个 Pen [使用 display: grid 覆盖 float 和 clear](https://codepen.io/rachelandrew/pen/jamLjw/)。

`inline-block` 同样也是如此。`inline-block` 可以设置给子项，但是只要父窗口应用了 `display: grid`，那么 inline-block 将失效。

我经常使用 CSS `display: table-cell` 来创建一个列布局，并在非支持网格的浏览器中对齐项目，因为这样 `vertical-align` 属性可以生效。

如果你以前不知道, 阅读 [CSS 布局的反英雄 — “display:table”](https://colintoh.com/blog/display-table-anti-hero)。我不建议你现在使用这个作为主要的布局方式，但是它可以作为一个非常有用的回退方案。

当你使用 `display: table-cell` 创建列，CSS 将创建所谓的 **匿名框**。这些是表格的缺失部分 —— 真正的 HTML 表格中的单元格将在 `table` 元素里边的 `tr` 元素内。匿名框基本上解决了这些失踪的父元素。如果你的 `table-cell` 元素变成了一个网格元素。这样这个元素的 table 显示同样会失效，就像什么也没有发生。

`vertical-align` 属性在网格布局中仍然不适用。因此如果你可以在 CSS 表格布局或 `inline-block`中使用它，则可以安全的忽略该属性，尽情使用网格布局的框对齐方式。你可以在下一个 CodePen 中看到一个使用 CSS Grid 覆盖 `display:table-cell` 和 `vertical-align` 的布局。

可以看下 rachelandrew ([@rachelandrew](https://codepen.io/rachelandrew)) 在 [CodePen](https://codepen.io) 写的这个 Pen [display: grid 覆盖 display: table-cell 和 vertical-align](https://codepen.io/rachelandrew/pen/NwjaKp/)。

你同样可以使用 Flexbox 作为一个回退方案，一旦你在一个使用 `flex` 属性或者独立的 `flex-grow`，`flex-shrink` 或者 `flex-basis` 属性的元素上使用 grid 布局，它们（flex 等）同样会失效。

最后，请不要忘记多列布局在某种情况下可以作为一个回退方案。当对卡片或图像进行布局时，它将以列而不是行来显示每一项。但是在某些情况下可能是有用的。在容器上应用 `column-count` 或者 `column-width` 使其成为多列容器。然后应用 `display:grid` 将忽略 `column-*` 行为。

### 特征查询

其他大多数布局方式中，大多都只是针对单个项目而不是其容器。例如在浮动布局中，我们有一堆给定了百分比宽度的项目，为其设置左浮动（float: left）。这将让他们排列在一起。只要总数不超过父容器宽度的 100%，我们就可以实现类似网格的效果。

```
.grid > * {
  float: left;  
  width: 33%;
}
```

[![给定宽度的浮动元素给我们类似网格的感觉](https://www.smashingmagazine.com/wp-content/uploads/2017/11/floating-items-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/floating-items-large-opt.png)

给定宽度的浮动元素给我们类似网格的感觉。 ([预览大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/floating-items-large-opt.png))

如果我们把布局方式换成 CSS Grid 布局，在父级上创建一个网格。我们仅仅需要做的就是指定这些元素能横跨多少列。

```
.grid {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  grid-auto-rows: 100px;
  grid-gap: 20px;
}
```

在我们以前的布局中，我们为浮动元素给定了大小。在新的布局中，这些元素变成了网格元素，通常我们并不会给这些元素大小，因为可以从跨过的网格轨迹上确定。

在这里，我们只是能够 **用另一个覆盖一个布局的方式** 来解决问题。在浮动布局的例子中，一旦指定了百分比大小的元素成为网格元素的时候，大小就会变成它所在网格区域的百分比，而不是整个容器的百分比。你可以使用 Firefox Grid Inspector 来高亮显示这些行 —— 这些元素现在被挤压到了网格单元的一侧。

[![在网格布局中，宽度将成为网格区域的百分比](https://www.smashingmagazine.com/wp-content/uploads/2017/11/grid-inspector-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/grid-inspector-large-opt.png)

在网格布局中，宽度将成为网格区域的百分比。([预览大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/grid-inspector-large-opt.png))

这是特征查询可以发挥作用的地方。特征查询类似于媒体查询，不是去检查设备的宽度和方向，而是去检查浏览器是否支持 CSS 功能。

在我们想要变成网格布局的浮动布局示例中，我们只需要在特征查询中内部重写一个东西 —— 我们想要将宽度重新设置为自动。

查看 [@rachelandrew](https://codepen.io/rachelandrew) 在 [CodePen](https://codepen.io) 写的这个 Pen：[display: 特性查询 demo](https://codepen.io/rachelandrew/pen/vWmeOE/)。

你需要重写多少用于不支持浏览器的 CSS，取决于你要为这些较旧的浏览器创建多少不同的布局。

### IE10 和 11 版本的网格布局

虽然 Edge 浏览器现在已经升级到支持现代网格布局，但是 IE10 和 IE11 只支持像早期版本那样，在这些浏览器加 `-ms` 前缀的写法。我们今天所知道的网格规范最初来自于微软。对这个老的实现方案，我们不是不高兴。我们应该很高兴他们开始了这个过程，首先是给了我们网格。你可以从这篇文章了解更多：[CSS 网格的故事，来自它的创作者](https://alistapart.com/article/the-story-of-css-grid-from-its-creators)。

如上所述，你可能决定为 IE10 和 11 提供基于浮动或其他布局类型的回退方法。这个功能也可以正常工作，就像 IE10 和 11 不支持功能查询一样。只要使用这些功能来覆盖旧的方法来检查其支持情况，然后创建支持浏览器的版本，IE10 和 11 将使用较旧的方法。

你依旧可以使用 `-ms-grid` 版本来创建回退方法。然而这个前缀的版本和现代网格布局不一样，它是第一个版本，并且也是实验版本。自从运用五年左右以来，情况已经发生了变化。这意味着你不能只使用 autoprefixer 来添加前缀，这种方法可能会让 IE10 和 11 的用户体验比你不做任何处理还要糟。相反，你需要使用这个不同的、更有先的规范来创建一个布局。

要注意的要点如下：

1. 如果没有自动放置，你需要使用基于行的定位将每一个元素放在网格上。
2. `grid-template-areas` ascii-art 方法不是实现的一部分。
3. 不要设置网格间隙的属性
4. 你可以不要指定开始行和结束行，而是去指定开始行和要跨越的列数。

你可以在我的博客文章中找到所有的这些属性的完整细目，[我应该尝试使用 IE 的网格布局实现方案吗？](https://rachelandrew.co.uk/archives/2016/11/26/should-i-try-to-use-the-ie-implementation-of-css-grid-layout/)

如果你有大量的用户使用这些浏览器，那么你可能会发现这个老规范是有帮助的。即使你只是用他来解决几个小问题，那这对你来说也是值得的。

### 如果要支持这些浏览器，我何苦使用网格呢？

如果你的列表中有不支持的浏览器，那么你 _必须_ 为他们提供和那些已经被支持的浏览器相同的体验。然后我们就会怀疑是不是应该用网格布局，或者任何新的 CSS 特性。使用可行方案，这个方案最完美。

你可能还在考虑使用网格布局是不是有一个优良的回退方案，如果你知道，短期内很可能你会从“必须是相同的”列表中抛弃一堆不兼容的浏览器。特别是如果你知道现在做的开发会有很长的维护周期。然后，你可以在晚一点的时候，只使用网格版本，丢掉回退方案。

但是，支持对于你来说意味可能着会失去对一些浏览器的兼容来换取一些开发工作的简化，然而此时还非用网格布局不可，那么这是使用网格布局和针对不兼容浏览器单独设计非网格布局体验的时候。

### 回退测试

测试回退是最后一步。测试你的回退方案是否奏效的唯一方法就会使用不支持 CSS 网格的浏览器访问你的网站。使用[下载微软提供的虚拟机](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/)的这种方式，你可以不必购买其他电脑。然后，就可以用不支持网格布局的 Internet Explorer 进行测试。

你可以在手机上下载 UC 浏览器，或[使用桌面版](http://www.ucweb.com/desktop/)的 Windows 或者虚拟机。

还有比如说可以访问整个运行范围内浏览器的远程虚拟机工具 [BrowserStack](https://www.browserstack.com)。这些服务不是免费的，但是他们而已为你节省大量设置测试虚拟机的时间。

[![BrowserStack 可以访问到许多不同的浏览器和操作系统](https://www.smashingmagazine.com/wp-content/uploads/2017/11/browserstack-example-800w-opt.png)](https://www.smashingmagazine.com/wp-content/uploads/2017/11/browserstack-example-large-opt.png)

BrowserStack可以访问到许多不同的浏览器和操作系统。 ([预览大图](https://www.smashingmagazine.com/wp-content/uploads/2017/11/browserstack-example-large-opt.png))

我看到有人建议切换特征查询值来测试一些不存在的东西。比如测试 `display: gridx`。这是能正常工作，但是你需要把所有的网格代码放到特征查询的代码块里边，而不是忽略浏览器会跳过不支持的 CSS 代码的事实。如果你不知道有些网格代码可能会结束在特征查询之外，那么你很容易会得到一个虚假的正确结果。即使你在使用这个方法进行快速检查，我仍然强烈建议你做一些真机测试。

#### 延伸阅读

我已经列出了这篇文章提到的网址，还有一些额外的资源可以帮助你用自己的方式来支持浏览器，同时还能利用到新的布局方式。如果你遇到了任何好的资源，或者特别棘手的问题，都可以将他们添加到这个问题下面。网格布局对于我们所有人都是新生的东西，我们可以在生产环境中使用，但是不可避免会出现一些悬而未决的问题，让我们一起看看。

*   “[创造者讲述 CSS Grid 的故事](https://alistapart.com/article/the-story-of-css-grid-from-its-creators),” Aaron Gustafson, A List Apart
*   “[Internet Explorer 和 Edge 的测试虚拟机](https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/),” Microsoft
*   “[BrowserStack](https://www.browserstack.com),” 跨浏览器测试工具
*   “[我应该尝试使用IE浏览器实现网格布局？](https://rachelandrew.co.uk/archives/2016/11/26/should-i-try-to-use-the-ie-implementation-of-css-grid-layout/)” Rachel Andrew
*   [CSS 布局的反英雄 — “display:table”](https://colintoh.com/blog/display-table-anti-hero),” Colin Toh
*   “[CSS 网格回退和替代备忘录](https://rachelandrew.co.uk/css/cheatsheets/grid-fallbacks)” Rachel Andrew
*   “[在 CSS 中使用特征查询](https://hacks.mozilla.org/2016/08/using-feature-queries-in-css/),” Jen Simmons, Mozilla Hacks
*   “[特征查询视频教程](http://gridbyexample.com/learn/2016/12/24/learning-grid-day24/),” Rachel Andrew
*   “[CSS 网格和逐步增强](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout/CSS_Grid_and_Progressive_Enhancement),” MDN web docs, Mozilla


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
