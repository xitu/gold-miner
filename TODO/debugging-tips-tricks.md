> * 原文地址：[Debugging Tips and Tricks](https://css-tricks.com/debugging-tips-tricks/)
> * 原文作者：本文已获原作者 [SARAH DRASNER](https://css-tricks.com/author/sdrasner/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[loveky](https://github.com/loveky),[ymz1124](https://github.com/ymz1124)

# 前端调试技巧与诀窍  #

编写代码其实只是开发者的一小部分工作。为了让工作更有效率，我们还必须精通 debug。我发现，花一些时间学习新的调试技巧，往往能让我能更快地完成工作，对我的团队做出更大的贡献。关于调试这方面我有一些自己重度依赖的技巧与诀窍，同时我在 workshop 中经常建议大家使用这些技巧，因此我对它们进行了一个汇总（其中有一些来自于社区）。我们将从一些核心概念开始讲解，然后深入探讨一些具体的例子。

### 主要概念 ###

#### 隔离问题 ####

隔离问题大概是 debug 中最重要的核心概念。我们的代码库是由不同的类库、框架组成的，它们有着许多的贡献者，甚至还有一些不再参与项目的人，因此我们的代码库是杂乱无章的。隔离问题可以帮助我们逐步剥离与问题无关的部分以便我们可以把注意力放在解决方案上。

隔离问题的好处包括但不限于以下几条：

- 能够弄清楚问题的根本原因是否是我们想的那样，还是存在其它的冲突。
- 对于时序任务，能判断是否存在时序紊乱。
- 严格审查我们的代码是否还能够更加精简，这样既能帮助我们写代码也能帮助我们维护代码。
- 解开纠缠在一起的代码，以观察到底是只有一个问题还是存在更多的问题。

让问题能够被重现是很重要的。如果你不能重现问题来分辨出它到底出在哪里，你将会很难修复这个问题。或者你也可以将它和类似的正常工作的模块进行对比，这样你就可以发现哪里进行过改动，或者发现两者之间有什么不同。

在实际操作中，我有许多种方法对问题进行隔离。其中一种是在本地创建一个精简的测试用例，当然你也可以在 CodePen 创建一个私人测试用例，或者在 JSBin 创建你的用例。另一种是在代码中创建断点，这样可以让我详细地观察代码的执行情况。以下是几种定义断点的方式：

你可以在你代码中写上 `debugger;`，这样你可以看到当时这一小块代码做了什么。

你还可以在 Chrome 开发者工具中进一步进行调试，单步跟踪事件的发生。你也可以用它选择性地观察指定的事件监听器。

![Step into the next function call](https://cdn.css-tricks.com/wp-content/uploads/2017/04/stepintonextfunctioncall.gif)

古老，好用的 `console.log` 是另一种隔离的方法。（PHP 中是 `echo`，python 中是 `print` ……）。你可以一小片一小片地执行代码并对你的假设进行测试，或者检查看有什么东西发生了变化。这可能是最耗费时间的测试方式了。但是无论你的水平如何高，你还是得乖乖用它。ES6 的箭头函数也可以加速我们的 debug 游戏，它让我们可以在控制台中更方便地写单行代码。

`console.table` 函数也是我最喜欢的工具之一。当你有大量的数据（例如很长的数组、巨大的对象等等）需要展示的时候，它特别有用。`console.dir` 函数也是个不错的选择。它可以把一个对象的属性以可交互的形式展示出来。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/dir.png)

**上图为 console.dir 输出的可交互的列表**

#### 保持条理清晰 ####

当我在 workshop 上做讲师，帮助我的班级的学生时，我发现，思路不够清晰是阻碍他们调试的一大问题。这实际上是一种龟兔赛跑的情形。他们想要行动的更快，因此他们会在写代码时一次就改写很多的代码——然后出了某些问题，他们不知道到底是改的那部分导致了问题的出现。接着，为了 debug，他们又一次改很多代码，最后迷失在寻找哪里能正常运行、哪里不能正常运行中。

其实我们或多或少都在这么做。当我们对一个工具越来越熟练时，我们会在没有对设想的情况进行测试的情况下写越来越多的代码。但是当你刚开始用一个语法或技术时，你需要放慢速度并且非常谨慎。你将能越来越快地处理自己无意间造成的错误。其实，当你弄出了一个问题的时候，一次调试一个问题可能会看起来慢一些，但其实要找出哪里发生了变化以及问题的所在是没法快速解决的。我说以上这些话是想告诉你：欲速则不达。

**你还记得小时候父母告诉你的话吗？“如果你迷路了，待在原地别动。“** 至少我的父母这么说了。这么说的原因是如果他们在到处找我，而我也在到处跑着找他们的话，我们将更难碰到一起。代码也是这样的。你每次动的代码越少就越好，你返回一致的结果越多，就越容易找到问题所在。所以当你在调试时，请尽量不要安装任何东西或者添加新的依赖。如果本应该返回一个静态结果的地方每次都出现不同的错误，你就得特别注意了！

### 选用优秀的工具 ###

人们开发了无数的工具用于解决各种各样的问题。下面，我会依次介绍一些我觉得最有用的工具，并在最后贴上相关资源的链接。

#### 代码高亮 ####

当然，为你的代码高亮主题找一个最热辣的配色与风格方案是很有趣的，但是请花点时间想清楚这件事。我通常使用深色主题，当有语法错误时，深色主题会用较亮的颜色显示我的代码，使我能轻松快速地找到错误。我也尝试过使用 Oceanic Next 配色方案与 Panda 配色方案，但是说实话我还是最喜欢自己的那种。在寻找优秀的代码高亮工具的时候请保持理智，帅气的外观当然很棒，但是为你揪出错误的功能性更加重要。当然，你完全有可能找到两者都很优秀的代码高亮工具。

#### 使用 Lint 工具 ####

使用 Lint 工具能够帮助我们标记出来一些可疑的代码，并且能报出我们忽视的一些错误。Lint 工具相当的重要，使用何种 lint 工具取决于你使用的语言与框架，以及最重要的：你认可怎样的代码风格。

不同的公司有着不同的代码风格及规定。我个人比较喜欢 [AirBnB 的 JS 代码规范](https://github.com/airbnb/javascript)。你的 Lint 工具将会强制你按照指定的模式进行编程，否则它可以终止你的构建过程。我曾经使用过一个 CSS Lint 工具，当我为浏览器写 css hack 时，它一直在报错。最后我不得不常常关闭它，它也就没能起到应有的作用。但是一个好的 Lint 工具可以把你忽视的一些潜在的问题指出来。

下面是几个资源：

- 我最近找到了一个[响应式图片 lint 工具](https://github.com/ausi/respimagelint)，它可以告诉你使用 picture 元素、srcset 属性以及 size 属性的时机。
- 这儿有个[很好的分类](https://www.sitepoint.com/comparison-javascript-linting-tools/)，收集与对比了一些 JS lint 工具。

#### 浏览器插件 ####

插件是真的超级棒，你可以轻松地启用或禁用它们。并且它们能在特定需求中发挥重要的作用。如果你使用一些特定的框架或类库工作，使用它们的开发者工具插件将会带给你无与伦比的便利。不过请注意，插件不仅会降低浏览器的速度，它们也有权限执行脚本。因此在你使用之前，请先了解一下插件的作者、评价及背景。总之，下面是一些我最喜欢的插件：

- Deque Systems 提供的 [aXe](https://chrome.google.com/webstore/detail/axe/lhdoppojpmngadmnindnejefpokejbdd)，是一款优秀的可行性分析插件。
- 如果你工作中使用 React，[React DevTools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi) 是你必不可少的工具，你可以通过它观察虚拟 DOM。
- [Vue DevTools](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd)，当你使用 Vue 时，同上。
- [Codopen](https://chrome.google.com/webstore/detail/codopen/agnkphdgffianchpipdbkeaclfbobaak)：它会会从编辑器模式弹出 CodePen 的调试窗口。八卦：我老公因为不喜欢看到我一直手动打开调试窗口，所以特意开发了这个工具。（真是个好礼物）
- [Pageruler](https://chrome.google.com/webstore/detail/page-ruler/jlpkojjdgbllmedoapgfodplfhcbnbpn)：它能得到页面中的像素尺寸以及任何需要测量的值。我喜欢这个工具，因为我对于我的布局变态般挑剔。它能帮助我解决这些问题。

### 开发者工具 ###

这可能是最直观的调试工具了，你可以用它们办到许多事情。它们有着许多内置的特性容易被人所忽视，因此在这个章节中，我们会深入探讨一些我喜欢的特性。

关于学习开发者工具的功能，Umar Hansa 有一套特别好的资料。他制作了一个[每周周报与 GIF 动图](https://umaar.com/dev-tips/)网站、制作了我们最后一节提到的一个新课程，并在我们网站发表了[这篇文章](https://css-tricks.com/six-tips-for-chrome-devtools/)。

我最近特别喜欢的一个工具是[CSS Tracker 增强插件](https://umaar.com/dev-tips/126-css-tracker/)，收到 Umar 的许可之后我将这个工具在这儿展示给大家看。它会显示出所有没有使用过的 CSS，你可以由此来理解 CSS 对于性能的影响。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/Screen-Shot-2017-04-10-at-10.20.11-AM.png)

**上图展示了 CSS tracker 为代码被使用的部分和未被使用的部分按照规则表上不同的颜色。**

#### 各色各样的工具 ####

- [What input](https://ten1seven.github.io/what-input/) 是一个能跟踪当前输入（鼠标、键盘、触摸）与当前信息的实用工具。（感谢 Marcy Sutton 提供了这个便捷的工具）
- 如果你做的是响应式开发，或者你得在无数种设备上进行检查，那么 [Ghostlabapp](https://www.vanamco.com/ghostlab/) 是个挺适合你的时髦工具。它为你提供了同步移动 web 开发、测试与检查。
- [Eruda 是个很棒的工具](http://eruda.liriliri.io/)，它可以帮助我们在移动设备上进行调试。我很喜欢它，因为它不仅是一个模拟器，还为你准备了控制台和真实的开发者工具，让你更容易理解。

![eruda gives you a mobile console](https://cdn.css-tricks.com/wp-content/uploads/2017/04/Screen-Shot-2017-04-10-at-10.38.57-AM.png)

### 特别提示 ###

我一直对其他人是怎么 debug 的很感兴趣，所以我通过 CSS-Tricks 与我的个人账号在社区征集大家最喜欢的调试方式。以下是社区中大家给出的技巧的合集。

> 译注：以下如“@xxx -2017年3月15日”格式的文字均为用户在推特上的发言，点击日期可以看到原推特。

#### 辅助方法 ####

```
$('body').on('focusin',function(){
  console.log(document.activeElement);});
```

> 这段代码会记录当前焦点所在的元素。它用起来很方便，因为当你打开开发者工具的时候会将 activeElement 的焦点移除。

-[Marcy Sutton](https://twitter.com/marcysutton)

#### 调试 CSS ####

我们收到很多回复说一些人喜欢在元素外面加上红色的边框（border），以此来观察元素的行为。

> [@sarah_edo](https://twitter.com/sarah_edo)：对于 CSS，我通常会给有问题的元素加上一个 .debug 的 class，这个 class 定义了红色的 border。
>
> — Jeremy Wagner (@malchata) [2017年3月15日](https://twitter.com/malchata/status/842029469246324736)

我也会这么做。而且我还做了一个简单的 CSS 文件，可以让我方便地用一些 class 来加上不同的颜色。

#### 检测 React 的 State ####

> [@sarah_edo](https://twitter.com/sarah_edo)：<pre>{JSON.stringify(this.state, null, 2)}</pre>
>
> — MICHAEL JACKSON (@mjackson) [2017年3月15日](https://twitter.com/mjackson/status/842041642760646657)

Michael 提到的这个办法，是我认为最有用的 debug 工具之一。这点代码可以“美观地输出”你当前正在使用的组件的 state，因此你可以了解此时此刻这个组件将会如何变化。你可以确认这个 state 是否和你设想的一样正常工作，它可以帮助你跟踪任何 state 中的错误，以及你使用 state 出现的错误。

#### 动画 ####

我们收到了许多的回复，说他们会在调试时减慢动画速度：

> [@sarah_edo](https://twitter.com/sarah_edo)[@Real_CSS_Tricks](https://twitter.com/Real_CSS_Tricks)： * { animation-duration: 10s !important; }
>
> — Thomas Fuchs (@thomasfuchs) [2017年3月15日](https://twitter.com/thomasfuchs/status/842029720820695040)

我在之前的文章[《调试 CSS 关键帧动画》](https://css-tricks.com/debugging-css-keyframe-animations/)中提到过这个问题，那篇文章里还有更多的技巧，例如如何使用硬件加速、如何在不同时刻进行多种变换等。

我也会使用 JavaScript 将我的动画减速。在  GreenSock 中，以这种形式实现：`timeline.timeScale(0.5)`，它将会将整个时间轴都减速，而不是仅仅将一个动画减速，这个功能超级有用。在 mo.js 中，这个功能是这么写的：`{speed: 0.5}`。

> 译注：[GreenSock](https://greensock.com) 与 mo.js 都是功能强大的js动画库

[Val Head 通过屏幕录像做了一个很好的视频](https://www.youtube.com/watch?v=MjRipmP7ffM&feature=youtu.be)，这个视频展示了 Chrome 与 Firefox 开发者工具中提供的动画调试功能。

如果你打算用 Chrome 开发者工具的时间轴来进行性能评估，那么请注意绘制（paint）是最耗性能的步骤，因此当时间轴中绿色占比很高的时候请当心。

#### 检查不同连接状态下的加载情况 ####

我往往在网速很快的条件中工作，所以我会限制我的网速来观察那些网速较慢的人们所体验到的性能。

![throttle connection in devtools](https://cdn.css-tricks.com/wp-content/uploads/2017/04/Screen-Shot-2017-04-10-at-9.29.00-AM.png)

这是个很有用的功能。它可以与强制刷新、清除缓存结合起来使用。

> [@sarah_edo](https://twitter.com/sarah_edo)：这儿有个不是秘密的小技巧，但是很多人还不知道：打开开发者工具，然后在刷新按钮上右击。[pic.twitter.com/FdAfF9Xtxm](https://t.co/FdAfF9Xtxm)
>
> — David Corbacho (@dcorbacho) [2017年3月15日](https://twitter.com/dcorbacho/status/842033259664035840)

#### 设置定时 Debugger ####

这一条是 Chris 提供的。对于这点我们写了一篇[详细的文章](https://css-tricks.com/set-timed-debugger-web-inspect-hard-grab-elements/)。

```
setTimeout(function() {
  debugger;
}, 3000);
```

它与我之前提到的 `debugger;` 工具很类似，不过你可以把它放在 setTimeout 函数中，得到更多详细的信息。

#### 模拟器 ####

> [@Real_CSS_Tricks](https://twitter.com/Real_CSS_Tricks) 有的 Mac 用户可能还不知道，用 iOS 模拟器加上 Safari 简直不要太方便！ [pic.twitter.com/Uz4XO3e6uD](https://t.co/Uz4XO3e6uD)
>
> — Chris Coyier (@chriscoyier) [2017年3月15日](https://twitter.com/chriscoyier/status/842034009060302848)

我前面提到了使用 Eruda 模拟器。iOS 用户还有一种很好的模拟器可以使用。在过去，我会告诉你你得先安装 XCode，但是这条推特提供了一种不同的方法：

> [@chriscoyier](https://twitter.com/chriscoyier)[@Real_CSS_Tricks](https://twitter.com/Real_CSS_Tricks) 如果你不想装 XCode，你也可以通过这种方式来使用模拟器：[https://t.co/WtAnZNo718](https://t.co/WtAnZNo718)
>
> — Chris Harrison (@cdharrison) [2017年3月15日](https://twitter.com/cdharrison/status/842038887904088065)

Chrome 也有切换设备型号功能，很实用。

#### 远程调试 ####

> [@chriscoyier](https://twitter.com/chriscoyier)[@Real_CSS_Tricks](https://twitter.com/Real_CSS_Tricks)：[jsconsole](https://jsconsole.com) 是个很棒的工具。
>
> — Gilles 💾⚽ (@gfra54) [2017年3月15日](https://twitter.com/gfra54/status/842035375304523777)

在看到他发的这条推特前，我还真不知道有这么一个好用的工具！

> 译注，jsconsole 官网现在因为未知原因打不开了，也可以用 Weinre 和 Ghostlab 等工具进行移动远程调试。

#### 调试 CSS 网格布局 ####

Rachel Andrew 也送给我们一个很好的方法。当你使用 Firefox 时，点击一个图标，网格的间隔将会被高亮。[她的视频](http://gridbyexample.com/learn/2016/12/17/learning-grid-day17/)详细地解释了这个技巧。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/04/Screen-Shot-2017-04-10-at-9.58.14-AM.png)

**上图为 Rachel Andrew 展示了如何在 Firefox 开发者工具中将网格的间距高亮。**

#### 数组调试 ####

Wes Bos 提供了一个在数据中搜索元素的一个很有用的技巧：

>  你可以用 array.find 来查找元素🔥 [https://t.co/AuRtyFwnq7](https://t.co/AuRtyFwnq7)
>
>  — Wes Bos (@wesbos) [2017年3月15日](https://twitter.com/wesbos/status/842069915158884354)

### 更多调试相关的资源 ###

Jon Kuperman 制作了一个 [“前端能手课程”](https://frontendmasters.com/courses/chrome-dev-tools/)，这个课程将会通过[这个 app](https://github.com/jkup/mastering-chrome-devtools) 来帮助你掌握开发者工具的使用。

code school 的一个小课程：[发现开发者工具](https://www.codeschool.com/courses/discover-devtools)。

Umar Hansa 的一个新的在线课程： [现代开发者工具](https://moderndevtools.com/)。

Julia Evans 写了一篇很不错的 [关于调试的文章](http://jvns.ca/blog/2015/11/22/how-i-got-better-at-debugging/)，在此向 Jamison Dance 致谢，感谢他让我看到这么好的文章。

Paul Irish 总结了一些 [使用开发者工具进行性能检查的高级技巧](https://docs.google.com/document/d/1K-mKOqiUiSjgZTEscBLjtjd6E67oiK8H2ztOiq5tigk/pub)。如果你和我一样是个书呆子，可以把它收藏起来深入研究。

在文章的最后，我将放上一个让人喜忧参半的资源。我的朋友 James Golick 是一位杰出的程序员，在多年以前做过一个关于 degub 的会议讲话。虽然 James 去世了，但是我们仍然能在这个视频中回忆他、向他学习。[点击观看视频]([https://youtu.be/VV7b7fs4VI8](https://youtu.be/VV7b7fs4VI8))

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
