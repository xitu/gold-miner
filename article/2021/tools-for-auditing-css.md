> * 原文地址：[Tools for Auditing CSS](https://css-tricks.com/tools-for-auditing-css/)
> * 原文作者：[Silvestar Bistrović](https://css-tricks.com/author/silvestar/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/tools-for-auditing-css.md](https://github.com/xitu/gold-miner/blob/master/article/2021/tools-for-auditing-css.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/Hoarfroster)
> * 校对者：[zenblo](https://github.com/zenblo)

# 不会吧不会吧，都 1202 年了，你还不知道这些检查 CSS 的工具？？？

在开发者的日常工作中检查 CSS 并不是一项常见的任务，但有时却不得不做。或许这是性能检查的一部分，用来排查有问题的 CSS 或删去未使用的选择器。也许是努力提高可访问性的一部分，在代码库中使用的所有颜色都要进行对比评估。甚至可能是为了加强一致性。

不管是什么情况，每当需要检查 CSS 的时候到来，我通常都会使用我将在下文中向大家介绍的那些工具。但在此之前，让我们先看看检查 CSS 到底是什么。

## 目录

1. 浏览器内的开发工具
2. 在线工具
3. CLI 工具

## 检查 CSS 有难度

一般来说，代码检查涉及分析代码，以发现 bug 或其他不对劲的地方，就比如说那些可能存在的性能上的问题。对于大多数编程语言来说，检查代码的概念相对简单：它正常工作了还是没能够正常工作。但 CSS 是一种特殊的语言，错误大多都会被浏览器忽略。而且我们能够[用很多不同的方式实现相同的样式](https://css-tricks.com/hearts-in-html-and-css/)，这就使得 CSS 的检查变得有些棘手 —— 至少可以这么说。

通过使用你最喜欢的代码编辑器的扩展程序，或者设置一个 CSS 的 linter 或 CSS 代码检查器可能会帮助到你及时发现这些错误，不过这不是我想在这里展示的，而且我们不应该止步于此。因为我们可以使用[太多](https://css-tricks.com/a-quick-css-audit-and-general-notes-about-design-systems/)的颜色、排版定义或 `z-index` 值，而所有这些都可能让一个 CSS 代码库变得混乱、不可维护且不稳定。

要真正检查 CSS，我们需要深入挖掘并找到那些不被认为是最佳实践的地方。为了找到这些地方，我们可以使用以下工具：

## 浏览器内置的开发工具

我们先来看看 Chrome DevTools 的 CSS 检查工具吧。我这里使用的是基于 Chromium 的 Brave 浏览器。你可能还想[看看 Umar Hansa 的这篇文章](https://css-tricks.com/whats-new-in-devtools-2020/) —— 他编译了一大堆发布于 2020 年的「伟大的」 DevTool 功能。

如果你喜欢手动检查 CSS 代码，我们可以使用 **Inspect** 工具以找出应用于特定元素的 CSS 代码。使用 "Inspect arrow"，我们甚至可以看到关于颜色、字体、大小和可访问性的那些额外的细节。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a335f578d3a94dd5902d1134275dbf9d~tplv-k3u1fbpfcp-zoom-1.image)

### Grid 和 Flex 的检查器

DevTools 界面中有很多实用的实用工具与细节，但我最喜欢的是 Grid 和 Flex 检查器。要启用它们，请进入设置（DevTools 右上方的一个小齿轮图标），点击 `Experiments`，然后启用 CSS Grid 和 Flexbox 调试功能。虽然这个工具主要用于调试布局问题，但我有时也会用它来快速判断页面上是否使用了 CSS Grid 或 Flexbox。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e050875f7cfd41e2bb84718106b37500~tplv-k3u1fbpfcp-zoom-1.image)

## CSS Overview

检查 CSS 是非常基本的，一切都需要手动完成。让我们看看一些更高级的 DevTools 功能。

**CSS Overview** 就是其中之一。要启用 CSS Overview 工具，进入设置，点击 `Experiments`，启用 CSS Overview 选项。

要打开 CSS Overview 面板，我们可以使用 `⌘ ⇧ P` 或 `Ctrl ⇧ P` 快捷键，输入 `css overview`，然后选择 `Show CSS Overview`。这个工具可以展现 CSS 属性的概览，比如颜色、字体、对比度问题、未使用的声明和媒体查询。我通常用这个工具来判断当前 CSS 代码的好坏。例如，如果有 50 种灰度色彩或过多的排版定义，就意味着样式指南没有被应用到实际，或者甚至可能不存在样式指南。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/f6a4dcdda0cf490eb6bbc20ed837f3db~tplv-k3u1fbpfcp-zoom-1.image)

不过请注意，该工具会对应用于这个页面的样式做出概览，而不是对单个文件做出概览。

### Coverage Panel

**Coverage Panel** 工具会显示页面上使用的代码数量和百分比。要查看它，我们可以使用 `⌘ ⇧ P` 或 `Ctrl ⇧ P` 快捷键，键入 `Coverage`，选择 `Show Coverage`，然后点击刷新图标。

你可以在 URL 过滤器输入中输入 `.css` 以用于过滤专门显示 CSS 文件。我通常使用这个工具来了解网站的交付技术。例如，如果我看到 CSS 的覆盖率相当的高，我就可以人为 CSS 文件是为每个页面单独生成的。这可能不是关键数据，但有时它有助于了解缓存策略。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/9e6075f8bbb541048e15258bf3073b6d~tplv-k3u1fbpfcp-zoom-1.image)

## Rendering Panel

**Rendering Panel** 是另一个有用的工具。要打开渲染面板，我们可以使用 `⌘ ⇧ P` 或 `Ctrl ⇧ P` 快捷键。这次输入 "Rendering"，然后选择 "Show Rendering" 选项。这个工具有很多选项，但我最喜欢的是：

* **Paint flashing** —— 当重绘事件发生时会显示绿色矩形。我用它来识别需要花费太多渲染时间的区域。
* **Layout Shift Regions** —— 当布局移动发生时显示蓝色矩形。为了充分利用这些选项，我通常在 "网络" 选项卡下设置 "慢速 3G" 预设。我有时会录制我的屏幕，然后放慢视频速度来寻找布局转移。
* **Frame Rendering Stats** —— 显示 GPU 和帧的实时使用情况。这个工具在识别重动画和滚动问题时很方便。

这些工具会给出常规检查中没有的东西，但我发现它对于了解 CSS 代码是否具有性能并且不会消耗设备的能量是必不可少的。

其他选项可能对调试问题更有利，比如模拟和禁用各种功能，强制使用 `prefers-color-scheme` 功能或打印媒体类型，以及禁用本地字体。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/a9f1e9ee7947416ba484e1ef95e02a1f~tplv-k3u1fbpfcp-zoom-1.image)

### Performance Monitor

另一个检查 CSS 代码性能的工具是 **Performance Monitor**。要启用它，我们可以使用 `⌘ ⇧ P` 或 `Ctrl ⇧ P` 快捷键，输入 `Performance Monitor`，然后选择 `Show Performance Monitor` 选项。我通常使用这个工具来查看与页面交互或动画发生时会触发多少次重新计算和布局。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/95a2dc65b9cf405d931e8f2ff9c682fa~tplv-k3u1fbpfcp-zoom-1.image)

## Performance Panel

在 **Performance Panel** 上，我们可以详细查看页面加载过程中的所有浏览器事件。要启用性能工具，我们可以使用 `⌘ ⇧ P` 或 `Ctrl ⇧ P` 快捷键，输入 `Performance`，选择 `Show Performance`，然后点击 "重新加载" 图标。我通常会启用 Screenshots 和 Web Vitals 选项。对我来说，最有趣的是 "首次渲染"、"首次内容丰富的渲染"、"布局转变 "和 "最大内容丰富的渲染" 这几个指标。还有一个饼图显示了绘制和渲染时间。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/8dee1041c8e1496988214e57333ae9d9~tplv-k3u1fbpfcp-zoom-1.image)

DevTools 可能不算是一个经典的检查工具，但它可以帮助我们了解哪些 CSS 功能被使用，代码的效率，以及代码的执行情况，而这些都是 CSS 代码检查的关键所在。

# 在线工具

DevTools 只是用于检查的其中一个包含了许多功能的工具，但我们还有其他可用的工具用来检查 CSS 代码：

## Specificity Visualizer

[**Specificity Visualizer**](https://isellsoap.github.io/specificity-visualizer/)显示代码库中 CSS 选择器的特殊性。只需访问网站并粘贴 CSS。

主图 Main Chart 会显示特定样式与样式表中的位置的关系。另外两个图表显示了特定样式的使用情况。我经常使用这个网站来寻找 "坏的" 选择器。例如，如果我看到许多特定样式被标记为红色，我很容易得出结论 —— 这里的 CSS 代码可以改进得更好。在你努力改进时，保存截图以供参考是很有帮助的。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/28bf0a06361542ba98dfa0ceffdfa59f~tplv-k3u1fbpfcp-zoom-1.image)

## CSS Specificity Graph Generator

[**CSS Specificity Graph Generator**](https://jonassebastianohlsson.com/specificity-graph/)是一个类似的可视化特定样式工具。它显示了一个略有不同的图表，可能会帮助你看到你的 CSS 选择器是如何按特定样式组织的。正如它在工具页面上所说的那样，"尖峰是不好的，总的趋势应该是在样式表的后期有更高的特定样式"。进一步讨论这个问题会很有意思，但这不在本文的讨论范围内。然而，Harry Roberts 在他的文章 ["The Specificity Graph"](https://csswizardry.com/2014/10/the-specificity-graph/) 中确实广泛地写到了这一点，值得一试。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3234eb428b1c4adbb048c7371b7ffeb4~tplv-k3u1fbpfcp-zoom-1.image)

## CSS Stats

[**CSS Stats**](https://cssstats.com/stats) 是另一个为你的样式表提供分析和可视化的工具。事实上，[Robin 在不久前写过关于它的文章](https://css-tricks.com/a-quick-css-audit-and-general-notes-about-design-systems/)，并展示了他如何使用它来审核他工作中的样式表。

你需要做的就是输入网站的 URL，然后点击 `Enter`。这些信息被分割成有意义的部分，包括了样式的声明数、颜色、排版、`z-index` 和特定样式等等。同样，你可能要把截图存储起来，以备日后参考。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b5e665f060b947c6b1e26ea7f4d371b3~tplv-k3u1fbpfcp-zoom-1.image)

## Project Wallace

[**Project Wallace**](https://www.projectwallace.com/analyze-css) 是由 Bart Veneman 开发的，而他已经[在 CSS Tricks 上介绍了这个项目](https://css-tricks.com/in-search-of-a-stack-that-monitors-the-quality-and-complexity-of-css/)。Project Wallace 的强大之处在于，它可以比较和可视化基于导入的变化。这意味着你可以看到你的 CSS 代码库以前的状态，并看到你的代码在不同状态之间的变化。我觉得这个功能相当有用，特别是当你想说服别人代码是改进过的。该工具对单个项目是免费的，并为更多项目提供付费计划。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/acf7cc0d697e4dd7bef11d5b1137f121~tplv-k3u1fbpfcp-zoom-1.image)

# CLI 工具

除了 DevTools 和在线工具，还有命令行界面（CLI）工具可以帮助我们检查 CSS：

## Wallace

我最喜欢的 CLI 工具之一是[**Wallace**](https://github.com/bartveneman/wallace-cli)。安装后，输入`wallace`，然后输入网站名称，它就会自动输出显示了你需要知道的关于网站的 CSS 代码的一切。我最喜欢看的是 `!important` 的使用次数，以及代码中有多少个 ID。另一个整洁的信息是顶级特定样式的数量以及有多少选择器使用它。这些可能是 "坏" 代码的危险信号。

我最喜欢这个工具的地方是，它可以从网站中提取所有的 CSS 代码 —— 不仅是外部文件，还能够包括内联代码。这就是为什么 CSS Stats 和 Wallace 的报告不匹配的原因。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4f7adfa0a5dc4032a0733ca2d443ed73~tplv-k3u1fbpfcp-zoom-1.image)

## csscss

[**csscss**](https://github.com/zmoazeni/csscss) CLI 工具可以显示哪些规则共享相同的声明，而这对于识别重复的代码和减少编写的代码量是很有用的。在这样做之前，我会三思而后行，因为这可能是不值得的，尤其是在今天的缓存机制下。值得一提的是，csscss 需要 Ruby 运行环境。

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/473219819ab2498fb88ebf3f62941b20~tplv-k3u1fbpfcp-zoom-1.image)

# 其他有用的工具

其他的 CSS 工具可能不用于检查，但还是很有用的。我们也来列举一下这些。

* [Color Sorter](https://github.com/bartveneman/color-sorter) —— 先按色调，再按饱和度对 CSS 颜色进行排序。
* [CSS Analyzer](https://github.com/projectwallace/css-analyzer) -—— 对一串 CSS 进行分析。
* [constyble](https://github.com/bartveneman/constyble) —— 这是一个基于 CSS Analyzer 的 CSS 复杂性分析器。
* [Extract CSS Now](https://extract-css.now.sh/) —— 从一个网页中获取所有 CSS。
* [Get CSS](https://content-project-wallace.vercel.app/get-css) —— 从一个网页中获取所有的 CSS。
* [uCSS](https://github.com/oyvindeh/ucss) —— 抓取网站以识别未使用的 CSS。

# 结语

CSS 在我们身边无处不在，我们需要把它当作每个项目的一等公民。别人怎么看你的 CSS 并不重要，但你对它的看法真的很重要。如果你的 CSS 有条不紊，写得很好，你就会花更少的时间去调试它，而花更多的时间去开发新功能。在一个理想的世界里，我们会教育每个人写好 CSS，但这需要时间。

让今天成为你开始关心你的 CSS 代码的日子。

我知道检查 CSS 对每个人来说都不会是一件有趣的事情。但是，如果你针对这些工具中的任何一个运行你的代码，并试图改善你的 CSS 代码库中的哪怕是一个部分，那么这篇文章已经完成了它的工作。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
