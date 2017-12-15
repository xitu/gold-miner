> * 原文地址：[Chrome DevTools- Performance monitor](https://hospodarets.com/chrome-devtools-performance-monitor?utm_source=SitePoint&utm_medium=email&utm_campaign=Versioning)
> * 原文作者：[malyw](https://twitter.com/malyw)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/chrome-devtools-performance-monitor.md](https://github.com/xitu/gold-miner/blob/master/TODO/chrome-devtools-performance-monitor.md)
> * 译者：
> * 校对者：

# Chrome DevTools- Performance monitor

How often have you applied the JavaScript or CSS solution considered as an optimization, and after couldn’t find an easy way to measure how effective it was?
Of course, you have the performance timeline recording, but in most cases, it provides the retrospective data, not the life-updated.
For this and other performance-measuring techniques, Chrome DevTools added the “Performance Monitor” tab which represents the real-time app performance metrics:

![](https://static.hospodarets.com/img/blog/1511527599607549000.png)

This is available in Chrome stable and to get the “Performance Monitor”:

1. Open “chrome://flags/#enable-devtools-experiments” URL
2. Activate the “Developer Tools experiments” flag
3. Press “Relaunch now” to restart Chrome
4. Open Chrome DevTools (CMD/CTRL + SHIFT + I)
5. Open DevTools “Setting” -> “Experiments” tab
6. Press SHIFT 6 times (sorry 😜) to show the hidden features
7. Check the “Performance Monitor” checkbox
8. Close and open DevTools (CMD/CTRL + SHIFT + I twice)
9. Press “Esc” to open the additional panel with tabs
10. Choose the “Performance monitor” in the drawer
11. Enable/disable the metrics via click
12. Enjoy the “Performance Monitor” if you get here 😀

![](https://static.hospodarets.com/img/blog/1511540400748823000.gif)

This gives you many different metrics, most of which are very useful and we could/can measure them in Chrome in some ways (e.g. in Timeline, Performance Tab etc.)

But there are couple new I’d like to share:

*  “Layouts / sec” and
*  “Style recalcs / sec”

They allow you to measure in the the real-time how performant your CSS solutions are. For example:
thank’s to [csstriggers.com](https://csstriggers.com/) we know, that change of the [top](https://csstriggers.com/top) and [left](https://csstriggers.com/left) CSS properties triggers the whole Pixel Rendering pipeline stages: paint, layout, and composition. If we use these properties for the animation, it will trigger dozens/hundreds of operations per a second.

But if you switch the animation to use “transform” CSS Property with “translateX/Y”, you will find out, that [it won’t trigger paint and layout, only the composite stage](https://csstriggers.com/top), which is done on GPU and will decrease your CPU usage nearly to 0%.

All this was described in the Paul Irish’s article [Why Moving Elements With Translate() Is Better Than Pos:abs Top/left](https://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/). For measuring the difference, Paul used the “Timeline”, which showed the triggered Paint/Layout actions. But latest years Paul is working on Chrome DevTools improvements, so I’m not surprised we finally have a proper way to measure the CSS performance in the real-time (I forked his demo to represent the animation props switching):

[![](https://static.hospodarets.com/img/blog/1511532158184634000.gif)](https://codepen.io/malyw/pen/QOQvyz) 

[Demo](https://codepen.io/malyw/pen/QOQvyz)

In general, there are many usages for Performance monitor in Chrome and finally, you have the real-time app performance data available.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
