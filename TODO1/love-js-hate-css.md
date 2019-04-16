> * 原文地址：[Love JavaScript, but hate CSS?](https://daveceddia.com/love-js-hate-css/)
> * 原文作者：[Dave Ceddia](https://daveceddia.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/love-js-hate-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/love-js-hate-css.md)
> * 译者：[allenlongbaobao](https://github.com/allenlongbaobao)
> * 校对者：[Xekin-FE](https://github.com/Xekin-FE)、[L9m](https://github.com/L9m)

# 热爱 JavaScript，但是讨厌 CSS ？

![热爱 JS，讨厌 CSS](https://daveceddia.com/images/love-js-hate-css.png)

一个读者留言说他自己写起 JS 和 React 来觉得很有趣，但是当要处理样式的时候，他就很沮丧。

> 我热爱 JavaScript 但是我讨厌 CSS，我没有耐心去改变这一现状。

编程是有趣的，解决问题也是有趣的。当你经历千辛万苦让你的程序正确运行的时候，这种感觉，简直不可思议。

然而，**哦，糟糕，是 CSS**。你的 App 运行得很好，就是样式有点糟糕，那么没有人会把它当回事，因为它不像 Apple(TM) 看上去那么高大上。

## 你不是一个人

首先，我要明确一个事：如果你热爱前端中的其他所有事，**除了 CSS**，那么你并不是另类。我在现实 **工作** 中认识一些专业级别的 UI 开发者，他们要么在样式处理方面很糟糕，要么 **能解决样式问题** 但是讨厌这个过程并且想方设法尽快把这一环节熬过去。

几年前我也曾经历过这样的困境，CSS 就像是一个有魔力的黑盒，每当我往里面输入一些代码，至少三分之二的情况下，它会输出一些比我开始编码前还要糟糕的东西。我通过 Google 和 StackOverflow 来解决大部分的 CSS 难题，并且发疯似地祈祷有人遇到跟我一模一样的难题（从某种意义上来讲，他们的确有过）。

当我从那个不堪回首的阴影下走出来后，我可以负责任地说：CSS（以及给页面应用样式这一过程）是一项可习得的技能。甚至 **设计** 也是一项可习得的技能。严格来讲，它们是不同的技能。

## 样式应用不等同与设计

拿到现成的视觉设计稿，然后通过写 CSS 代码把一大堆 `div` 转化成和设计稿相匹配，这个过程就是所谓的 **样式应用（ styling ）**

拿过来一块空白画布，在上面呈现出一个美观的网页，这个过程是所谓的 **设计（ design ）**

可能出现的情况是：你做到了熟练掌握（甚至是精通）这两项中的其中一项，与此同时，另一项则是一窍不通。

作为一个前端，你需要掌握一定的样式应用技巧（CSS），但不一定需要掌握设计技巧

## 我能选择逃避 CSS 吗？

我也希望我能大声地告诉你：忘掉 CSS 吧，只要 100% 专注于 JS 就可以了。

但是真相是：我不能。只要你还想走前端这条路，就不可避免地跟 CSS 打交道，学习一些 CSS。

经验告诉我，一旦你对 CSS 了解多了一点，它看上去就没那么难，甚至还有点有趣。当我发现我能正确地应用样式到一个页面，并且知道修改哪个参数让它达到我想要的效果，这种感觉，也是很令人满意的。

## 我该怎么做？

既然不能逃避，那么就学一些让 CSS 不怎么难的技巧吧。

### 框架

CSS 框架能让你快速开发项目，它能很好地弥补设计技巧的不足。通常，它们都可以通过 npm/yarn 来安装，或者通过 CDN 来部署。每种框架都有自己的特色样式，所以你在做选择的时候就要有所权衡。CSS 框架能够帮助你搭建一个美观的应用，其中避免了大量样式布局的困扰（至少没那么多）。

以下就是一些流行的框架（我选了一些和 React 兼容的）：

*   [Bootstrap](https://getbootstrap.com/) —— 非常流行（注：在 SO 上有大量的问答），而且外观很正式。最新版本（V4）看上去更加现代化，老版本显得有些过时了。你可以自定义样式，也可以使用免费主题和 [付费主题](https://themes.getbootstrap.com/) 来改变它的外观。如果你正在使用 React，可以通过 [react-bootstrap](https://react-bootstrap.github.io/getting-started/introduction) 来获取大量的预制组件比如现代化控件、弹框、表单等等。

*   [Semantic UI](https://react.semantic-ui.com/introduction) —— 另一个兼容 React 组件的流行 CSS 框架，它的可用组件比 Bootstrap 更多，外观上（我认为）更加的现代化。

*   [Blueprint](http://blueprintjs.com/) ——  Blueprint 外观上比 Bootstrap 和 Semantic UI 更棒，至少我这么觉得。但是我自己没有使用过它。Blueprint 脱颖而出的一点是它是用 TypeScript 写的，而且支持 TypeScript 开发。它并不 **依赖** TypeScript，但是如果你在用 TS，那么它值得一试。

除了以上三种，还有很多好用的 CSS 框架。下面是一些 [列表](https://hackernoon.com/the-coolest-react-ui-frameworks-for-your-new-react-app-ad699fffd651) ，它们都支持 React。

如果说框架是让你少碰一些 CSS，那么下面两种方法就更加直接地帮助你轻松应对 CSS。

### 弹性布局（Flexbox）

弹性布局是一种使用 CSS 来呈现内容的现代化布局方式。相对于之前的 `float` 浮动布局（或者五分钟前的瞎蒙乱撞），它简单很多。它拥有 [很好的浏览器兼容性](https://caniuse.com/#search=flexbox) 并且十分简单地就能解决 CSS 的一些史诗级难题，比如 **垂直居中** 。

看这里：

想象一下如何优雅地让红色方块居中！只需要在外部的灰色块中添加三行 CSS 语句就能做到：

```
display: flex;           /* turn flexbox on */
justify-content: center; /* center horizontally */
align-items: center;     /* center vertically */
```

如果你在浏览器中右击外部灰色块，然后查看元素，你会发现它里面远远不止三行…… 但是多出来的那些并不负责居中红方块。增加的代码给了它一个灰色边框，让它成为一个矩形块，在文章中水平居中 （ `margin: a auto` ），底部的 margin 给了下面的文字一些空间。

如果你对弹性布局感兴趣，在 CSS Tricks 有极好的 [弹性布局完整指南](https://css-tricks.com/snippets/css/a-guide-to-flexbox/) ，强力推荐。弹性布局切实帮助我更好地运用 CSS，它也是我现在正在研究解决布局问题的工具。

### CSS 网格布局

网格布局是一种更加现代化的布局方式，它比弹性布局更加强大。前者能解决二维（行和列）上的布局，后者更擅长解决单一的行或者列上的布局。它在浏览器兼容上 [表现良好](https://caniuse.com/#feat=css-grid) 。CSS Tricks 上这样说道：

> 从 2017 年 3 月起，绝大多数的浏览器在应用网格布局时已无需添加任何前缀，比如：Chrome （包括 Android）、Firefox、Safari（包括 iOS）以及 Opera。IE 10 和 11 也支持它，但是它基于一种过时的语法来实现的。网格布局的时代来临了！

在我写这篇文章的时候，我仅仅只在排版上尝试过网格布局。它比弹性布局更强大，也更复杂。我发现绝大部分情况弹性布局已经能很好地满足我的需求。网格布局是我下一步要学习的目标。

有兴趣了解更多地话，可以阅读 CSS Tricks 中的 [网格布局完整指南](https://css-tricks.com/snippets/css/complete-guide-grid/)

### 更具操作性的方法

解决 CSS 问题有大量的有用策略。尽可能避免随机乱猜或者直接从 StackOverflow 上复制粘贴来完成任务。

尝试一种更加靠谱的方式吧。

*   定位元素（弹性、网格，大不了在相对定位的父元素中绝对定位子元素）
*   设置元素的 margin 和 padding 的值
*   设置边框
*   设置一种背景颜色
*   然后 [完善细节](http://knowyourmeme.com/memes/how-to-draw-an-owl) —— 增加阴影、设置 :hover/:active/:focus 下的调整样式等等。

![完善细节](https://daveceddia.com/images/draw-an-owl.jpg)

总而言之，软件工程中的经典法则比如 [DRY (Don’t Repeat Yourself)](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) 以及 [Law of Demeter](https://en.wikipedia.org/wiki/Law_of_Demeter) 都可以应用到样式布局中来。举个例子，思考一下如何结合头像布局用户信息：

![用户头像信息布局](https://daveceddia.com/images/css-layout-dry-example.png)

我们发现每个元素都距离边缘 20 像素，那么一种实现方法就是两个元素都设置 `margin` 值为 `20px`。

但是这样做有缺点。首先，重复问题：如果说 margin 值需要改变，那么我们需要在两处修改。

其次，相对于内部元素自己决定与边缘的距离，这难道不应该是外部盒子的职责吗？

一个更好的解决方式是外部盒子设置其 `padding` 值为 `20px`，这样一来，内部元素就不用操心自己的位置了。这样也方便添加新的元素到盒子中 —— 你不用显式声明每个元素的位置

这仅仅是一个小例子，用来明确一点：思考问题加上有逻辑的方法能够让布局变得简单得多。

## 实践步骤

1.  找到三个布局样式，复制下来。这些可以是你在使用的站点的小组件（单个推文、一个相册卡等等），也可以是现实内容比如信用卡、书籍封面等等。
2.  阅读 [弹性布局完整手册](https://css-tricks.com/snippets/css/a-guide-to-flexbox/).
3.  使用弹性布局去实现你在步骤一中挑选的布局。

- [欢迎在推特上关注我 @dceddia](https://twitter.com/intent/follow?screen_name=dceddia)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
