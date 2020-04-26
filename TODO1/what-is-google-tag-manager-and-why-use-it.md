> * 原文地址：[What is Google Tag Manager and why use it? The truth about Google Tag Manager](https://www.orbitmedia.com/blog/what-is-google-tag-manager-and-why-use-it/)
> * 原文作者：[Amanda Gant](https://www.orbitmedia.com/team/amanda-gant/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-google-tag-manager-and-why-use-it.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-is-google-tag-manager-and-why-use-it.md)
> * 译者：[zhanght9527](https://github.com/zhanght9527)
> * 校对者：[xionglong58](https://github.com/xionglong58)

# Google Tag Manager 的真相大揭秘

如果你对 Google Tag Manager 不太熟悉，你可能会想知道它是什么以及为什么要使用它。让我们来回答关于 Google Tag Manager 的一些最常见的问题。

- 什么是 Google Tag Manager ？
- 它和 Google Analytics 有哪些不同？
- 它用起来容易吗？
- 为什么我们要使用 Google Tag Manager ？
  - 它有哪些好处？
  - 它还存在哪些问题？
- 我们可以在 Google Tag Manager 中跟踪哪些东西？
- 在哪里可以了解更多关于 Google Tag Manager 的信息？

## 什么是 Google Tag Manager（GTM）？

Google Tag Manager 一款允许你在你的网站（或移动应用）上管理和部署营销跟踪代码（代码片段或跟踪像素）而不必修改任何代码的工具，并且它是完全免费的。

下面是一个 GTM 如何工作的非常简单的例子。来自一个数据源（你的网站）的信息通过 Google Tag Manager 与另一个数据源（Analytics）共享。当有很多代码需要管理时，GTM 变得非常方便，因为所有的代码都存储在一个地方。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/GTM-v2.jpg)

Tag Manager 的一个巨大的好处就是，作为运营人员，你可以自己管理代码。“终于不再需要开发小哥哥了。Whoo hoo！”

听起来很简单吧？不幸的是，事情没那么简单。

## Google Tag Manager 易于上手吗？

根据 Google 的说法，

> “Google Tag Manager 允许运营人员和网站管理员在同一个位置部署网站跟踪代码，从而帮助实现代码管理的**简单性**、**易用性**和**可靠性**。

他们说，这是一个“简单”的工具，任何运营人员都可以使用，而不需要网络开发人员。

我可能会因为说下面的话而在评论区里被人批评，但我仍然坚持自己的立场。**如果没有一些技术知识或培训（课程或自学），Google Tag Manager 使用起来还是比较困难的。**

你必须具备**一些**技术知识才能理解如何设置跟踪代码、触发器和变量。如果你也在使用 Facebook pixels，你也需要了解**一些** Facebook 像素追踪的原理。

如果你想在 Google Tag Manager 中设置事件跟踪，你需要了解**一些**关于什么是“事件”、Google Analytics 的工作原理、你可以用事件跟踪什么数据、Google Analytics 中的报告是什么样子以及如何命名你的类别、动作和跟踪代码的知识。

虽然在 GTM 中管理多个跟踪代码是很“容易的”，但是也有一个学习曲线。一旦你越过了这个障碍，你便能轻松地驾驭 GTM。

## 让我们看看 Google Tag Manager 是如何工作的...

Google Tag Manager 有三个主要部分：

- **跟踪代码**：Javascript 片段或跟踪像素
- **触发器**：告诉 GTM 何时或如何触发跟踪代码
- **变量**：GTM 可能需要的能使代码和触发器正常工作的附加信息

### 什么是跟踪代码？

跟踪代码来自第三方工具的代码片段或跟踪像素。这些代码告诉 Google Tag Manager 需要去做**什么**。

Google Tag Manager 中常见的跟踪代码示例如下：

- Google Analytics Universal tracking 代码
- Adwords Remarketing 代码
- Adwords Conversion Tracking 代码
- Heatmap tracking 代码（Hotjar、CrazyEgg 等）
- Facebook pixels

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/examples-of-tags.png)

### 什么是触发器？

触发器是触发设置的跟踪代码的方法。它们告诉 Tag Manager **什么时候**去做你想做的事情。是要在页面视图中触发代码，单击链接还是自定义？

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/example-triggers.png)

### 什么是变量？

变量是 GTM 跟踪代码和触发器工作**可能**需要的附加信息。下面是一些不同变量的例子。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/example-variables-2.png)

在 GTM 中可以创建的最基本的常量变量类型是 Google Analytics UA number（跟踪 ID 编号）。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/example-variables.png)

这些是 GTM 的一些基本元素，你需要知道这些元素才能开始自己管理跟踪代码。

如果读到这里你已经觉得枯燥的话，那么证明你可以熟练管理跟踪代码了。如果你仍然没有头绪，那么你需要去寻求技术人员的帮助了。

## Google Tag Manager 和 Google Analytics 有哪些不同？

Google Tag Manager 是一个只用于存储和管理第三方代码的完全不同的工具，在 GTM 中没有任何报告或分析的功能。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/gtm-workspace.png)

Google Analytics 用于实际的报告和分析。所有转化跟踪目标（Goals）和过滤器（Filters）都通过 Analytics 进行管理。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/filters-goals.png)

所有的报告（目标转化报告、自定义细分报告、电子商务销售报告、用户页面停留时间、用户跳出率、用户参与度报告等）都在 Google Analytics 中完成。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/google-analytics.png)

## Google Tag Manager 有哪些好处？

一旦你越过了学习曲线，你可以在 Google Tag Manager 中做很多神奇的事情。你可以自定义发送到 Analytics 的数据。

你可以设置和跟踪基本事件，如 PDF 下载、出站链接或按钮单击。或者，复杂的增强电子商务产品和促销跟踪也可以设置。

假设我们想要跟踪网站上所有的出站链接。在 GTM 中，选择类别名称、动作和代码。我们选择站外链接，点击和点击 URL 。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/customize-data.png)

在 Google Analytics 前往 Behavior > Events > Top Events > Offsite link。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/ga-events.png)

现在，选择事件动作或代码以获得完整的报告。我们在 Google Tag Manager 中设置的数据现在出现在分析报告中。漂亮！

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/event-action-label.png)

想要自由试用某个工具吗？你可以将代码添加到 Tag Manager 并进行测试，而不需要让开发人员参与其中。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/freetrial.png)

小贴士：

- 它**可能**帮助加快你的网站加载速度但取决于你使用了多少跟踪代码。
- 它适用于非 Google 的产品。
- 你可以灵活玩转并测试几乎任何你想要的东西。
- 所有的第三方代码都在一个地方。
- GTM 有一个预览和调试模式，所以在你做任何事情之前，你可以看到哪些是有效的，哪些不是。它会向你展示页面上正在触发的跟踪代码。**爱死这个功能了！**

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/preview-mode.png)

## 缺点是什么？

**1\. 你必须得有一些技术知识**，即使是基本设置。

查看 [documentation from Google](https://developers.google.com/tag-manager/devguide#thepits) 如何设置 Google Tag Manager。一旦你读完了“快速入门指南”，它会让你感觉到这是一个开发指南，而不是运营指南。如果你是第一次使用，这会读起来像胡言乱语。

![](https://www.orbitmedia.com/wp-content/uploads/2017/03/developer-guide.png)

**2\. 这是一个时间投资。**

除非你是一名经验丰富的开发人员，否则你需要留出大量的研究和测试时间。即使是在看一些博客文章或者上一堂网络课。

**3\. 腾出时间解决问题。**

在设置标记、触发器和变量时，会产生很多问题。尤其是如果你不是经常在 Tag Manager 中工作，会很容易让你忘记刚刚学到的东西。对于更复杂的标记，你可能需要一个了解网站构建方式的开发人员。

## 你可以在 GTM 跟踪什么？

- 事件（链接点击、PDF 下载、添加购物车点击、删除购物车点击）
- 滚动跟踪
- 表单被放弃
- 购物车被遗弃
- [视频播放次数跟踪](https://www.orbitmedia.com/blog/tracking-video-views-google-analytics-tag-manager/)
- [所有退出链接的单击](https://www.orbitmedia.com/blog/whered-they-go-track-every-exit-click-using-google-tag-manager-in-10-steps/)
- ......

我们只是粗略地介绍了一下你在 Google Tag Manager 中能做些什么，但是你可以做的东西似乎无穷无尽。但是，正如 [Himanshu Sharma 指出](https://www.optimizesmart.com/may-no-longer-need-google-tag-manager/) ，跟踪代码和数据源越多，管理起来就越困难。

## 我在哪里可以了解更多关于 Google Tag Manager 的信息？

我和 Chris Mercer 通过 Conversion XL 参加了一个现场课程，这是我上过的最好的在线课程之一。如果你感兴趣，可以 [购买视频](https://conversionxl.com/institute/live-courses/#view-recordings) 。

其他可以参考的资源：

- Himanshu Sharma, [Optimize Smart blog](https://www.optimizesmart.com/may-no-longer-need-google-tag-manager/)
- [Simo Hava blog](https://www.simoahava.com/)
- [Conversion XL blog](https://conversionxl.com/blog/)
- Chris Mercer, [Seriously Simple Marketing](https://seriouslysimplemarketing.com/beginners-guide-google-tag-manager-digital-marketing-week-episode-33/)
- [AnalyticsPros blog](https://www.analyticspros.com/blog/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
