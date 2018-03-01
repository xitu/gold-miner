> * 原文地址：[Chrome DevTools- Performance monitor](https://hospodarets.com/chrome-devtools-performance-monitor?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[malyw](https://twitter.com/malyw)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/chrome-devtools-performance-monitor.md](https://github.com/xitu/gold-miner/blob/master/TODO/chrome-devtools-performance-monitor.md)
> * 译者：[Cherry](https://github.com/sunshine940326)
> * 校对者：[萌萌](https://github.com/yanyixin)、[noahziheng](https://github.com/noahziheng)

# Chrome DevTools - 性能监控

你是否经常需要 JavaScript 或者 CSS 进行优化，但是不能找到一个简单的方式来衡量优化的效果？

当然，你可以使用时间轴来记录，但是在大多数情况下，时间轴只记录数据，并不是实时更新的。在这点还有其他的性能测量技巧，Chrome DevTools 添加了 “Performance Monitor（性能监控）” 选项卡，可以体现实时性能：

![](https://static.hospodarets.com/img/blog/1511527599607549000.png)

这些都是在 Chrom 稳定版本中可用的并且可以进行以下性能监控：

1. 打开 URL：“chrome://flags/#enable-devtools-experiments” 
2. 将 “Developer Tools experiments” 选项设置为“启用”
3. 点击 “Relaunch now” 来重启 Chrome
4. 打开 Chrome DevTools (快捷键为 CMD/CTRL + SHIFT + I)
5. 打开 DevTools “Setting” -> “Experiments” 选项
6. 点击 6 次 `SHIFT` 显示隐藏的选项
7. 选中 “Performance Monitor” 选项
8. 重启 DevTools (快捷键 CMD/CTRL + SHIFT + I )
9. 点击 “Esc” 打开附加面板
10. 选择 “Performance monitor” 
11. 单击启用/禁用
12. 开始使用性能监控吧 😀

![](https://static.hospodarets.com/img/blog/1511540400748823000.gif)


这里有很多不同的性能选项，大部分都是非常实用的并且我们在 Chrome 中用一些方法进行度量（例如时间轴，性能选项等）。

但是我想要分享一些新内容：

* “Layouts / sec” 和
* “Style recalcs / sec”
 
允许你实时的检测你的 CSS 性能，例如：

感谢 [csstriggers.com](https://csstriggers.com/)，我们知道，改变 CSS 的 [`top`](https://csstriggers.com/top) 和 [`left`](https://csstriggers.com/left) 属性会触发整个像素渲染流程：绘制，布局和组合。如果我们将这些属性用于动画，它将每秒触发几十次/上百次操作。

但是如果你使用 CSS 的 `transform` 属性的 `translateX/Y` 来切换动画，你将会发现，[这并不会触发绘制和布局，仅仅会触发组合这一阶段](https://csstriggers.com/top)，因为这是基于 GPU 的，会将你的 CPU 使用率降低为基本为 0%。

所有的这些都在 Paul Irish 的文章 [为什么使用 Translate() 移动元素优于 Top/left](https://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/)。为了测量差异，Paul 使用“时间轴”，展示了触发绘制和布局动作。但是近些年，Paul 正在致力于使用 Chrome DevTools 进行改良，这并不令人惊讶，我们终于有了一个合适的方法来衡量实时 CSS 性能。（我 fork 了他动画切换的示例代码）


![](https://user-gold-cdn.xitu.io/2017/12/17/1606485cac9627b6?w=972&h=424&f=gif&s=4926541)

[示例](https://codepen.io/malyw/pen/QOQvyz)

一般来说，Chrome 中的性能监视器有很多用途。现在，您可以获得实时的应用程序性能数据。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
