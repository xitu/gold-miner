> * 原文地址：[Designing search for mobile apps](https://medium.muz.li/designing-search-for-mobile-apps-ab2593e9e413)
> * 原文作者：[Shashank Sahay](https://medium.muz.li/@shashanksahay?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/designing-search-for-mobile-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/designing-search-for-mobile-apps.md)
> * 译者：吃土小2叉（https://github.com/xunge0613）
> * 校对者：

# 如何设计移动应用的搜索功能？

## 探索实现搜索功能的各种方式及其背后的理念

![](https://cdn-images-1.medium.com/max/2000/1*KMCNd82pJP-lUQIoZaxpGQ.png)

第四期功能探索：移动应用的搜索功能

经过了前三期的功能探索后，这次我又为你们准备了一个有趣的主题 —— **移动应用的搜索功能**。当然搜索功能相当复杂，因此本文并未涵盖所有相关的内容。而我将讨论如何从应用的两种最常见的搜索模式之间进行选择：着陆页搜索栏或导航栏上的搜索选项卡。

### 移动应用的搜索功能

许多常用的应用都具备搜索功能。而这些应用实现搜索的方式却可能大相径庭。可是为什么对同一个功能需要不同的实现方式呢？是因为比其他的酷炫吗？让我们一起分析下。

### 1. 着陆页的搜索栏

![](https://cdn-images-1.medium.com/max/2000/1*L8hbI6zINOlZwUoCXvq0YQ.png)

着陆页的搜索栏

以下是一些常用应用的屏幕截图，它们在着陆页添加了搜索栏。因为大多数情况下**搜索栏**都出现在着陆页顶部，所以很容易被用户发现。

在这种情况下，该搜索模式迎合了带有**明确意图**的用户。平台提供的任何建议或帮助都将基于用户输入的关键字。

**（此解释也适用于在着陆屏右上角有搜索图标的应用。我将这两种案例放在一起，因为它们在可发现性，可访问性方面非常相似，甚至用户的点击率也很接近。）**

### 2. 导航栏上的搜索选项卡

![](https://cdn-images-1.medium.com/max/2000/1*htxb3xD_rwZOeDkjGc5YnA.png)

导航栏上的搜索选项卡

以下是一些把搜索入口作为导航栏上的选项卡的应用的屏幕截图。这种搜索不像着陆页上的搜索栏那样容易被发现，不过考虑到位置离用户的拇指很近，因此也很容易访问。

通常这种情况下，搜索会独占一个屏幕。在屏幕顶部有一个搜索栏，而屏幕的其余部分填充了有助于用户搜索或帮助用户探索平台内容的数据。这有助于尚未有明确意图的用户进行**探索式搜索**。

### 搜索框还是搜索选项卡？

这两种搜索模式分别满足了用户的不同的需求。此外，搜索模式也取决于平台的类型以及平台提供的内容类型。

#### 使用着陆屏上的搜索栏的场景

1. **用户打开应用的主要目的可能就是搜索**。举个例子，比如 Google Maps，Uber 或 Zomato。大多数情况下，人们打开这些应用恰恰是要搜索位置，餐馆或菜肴。
2. **用户在搜索时有明确的意图**，例如 Facebook 的用户通常会寻找其他用户或主页。大多数情况下，他们即使不完全确定用户或者主页的名称是如何拼写的，也知道它的名称可能是什么。对于这类平台，用户很少对寻找的内容只有模糊的信息。而且即使真的有这种可能性，平台也无法帮助到用户。

#### 使用搜索作为导航栏上的选项卡的场景

1. 希望帮助用户在平台上探索和发现新内容来**增强用户参与度**。举个例子，比如 Instagram 和 Twitter。这些平台希望吸引用户在应用上停留的时间更长，因此他们提供来自用户的社交圈以外的个性化内容，以帮助用户发现可能感兴趣的新用户或新内容。
2. **用户不确定他们正在寻找什么**，该应用可以引导用户找到他们想要的东西。举个例子，比如 Netflix 和 Uber Eats。它们允许用户通过浏览各种流派和美食的方式来探索应用。这迎合了想要观看喜剧节目，但不确定应该看哪个的用户。

### 现在，一起来看看 Airbnb ？

![](https://cdn-images-1.medium.com/max/2000/1*yhxaOzAg5yPGXeIdHPVRPw.png)

Airbnb（爱彼迎）

Airbnb 结合了这两种搜索模式：着陆屏上有一个搜索栏，同时着陆屏本身又是搜索/浏览选项卡所在屏。

鉴于 Airbnb 的业务场景，我认为这很有意义：同时迎合了两类用户 —— 一类是确定了目的地的用户将使用搜索栏（具有**明确意图的用户**），而另一类可能还没想好去哪儿的用户，正在考虑旅行目的地（他们需要**探索式搜索**）。

### 结论

这两种不同模式各有利弊。它们都适用于特定场景。通过上述案例，我们可以得出结论：有两个因素决定了应该使用哪种搜索模式 —— 用户访问应用的意图以及应用本身能提供的内容。


* * *

#### 特别鸣谢

感谢 [Tanvi Kumthekar](https://medium.com/@tanvikumthekar) 和 [Shailly Kishtawal](https://medium.com/@shailly.kishtawal) 的头脑风暴。  
感谢 [Dhruvi Shah](https://www.linkedin.com/in/dhruvishah394/)、[Nisshtha Khattar](https://www.linkedin.com/in/nisshtha-khattar-9ab554159/)、[Preethi Shreeya](https://uxplanet.org/@preethishreeya1) 和 [Prasanth Marimuthu](https://www.linkedin.com/in/prasanthuxer/) 的反馈意见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
