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

After 3 feature breakdowns, I have another interesting feature for you — **Search for mobile apps**. Search is a fairly complex feature and this article does not cover everything there is to know about it. In this story, I will be discussing how to pick between the two most popular ways of using search on your application, search bar on the landing screen or search tab on the navigation bar.
经过了前三期的功能探索后，这次我又为你们准备了一个有趣的主题 —— **移动应用的搜索功能**。当然搜索功能相当复杂，因此本文并未涵盖所有相关的内容。而我将讨论如何在应用上的两种最常见的搜索模式之间进行选择：着陆页搜索栏或导航栏上的搜索选项卡。

### 移动应用的搜索功能

So many applications that we use on a daily basis have the Search feature. The way these applications implement search can be very different. But why is there a need for different implementations of the same feature? Is one better than the other? Let’s find out.
许多常用的应用都具备搜索功能。而这些应用实现搜索的方式却可能大相径庭。可是为什么对同一个功能需要不同的实现方式呢？是因为这个比那个酷炫吗？让我们一起分析下。

### 1. Search bar on landing screen
### 1. 着陆页的搜索栏

![](https://cdn-images-1.medium.com/max/2000/1*L8hbI6zINOlZwUoCXvq0YQ.png)

Search bar on the landing screen
着陆页的搜索栏

Here’s a screenshot of some of the popular apps that use a search bar on the landing screen. The **search bar** is easily discoverable as most of the times it is present on the top of the landing screen.
以下是一些常用应用的屏幕截图，它们在着陆页添加了搜索栏。因为大多数情况下**搜索栏**都出现在着陆页顶部，所以很容易被用户发现。

In this case, the Search caters to the users who have a **clear intention** behind performing a search. Any suggestions or help the platform might provide will be on the basis of the keyword entered by the user.
在这种情况下，该搜索模式迎合了带有**明确意图**的用户。平台提供的任何建议或帮助都将基于用户输入的关键字。

_(This explanation also applies to apps that have a search icon on the top right of the landing screen. I’ve put these two variations together, as they’re very similar in terms of discoverability, accessibility and even take the same number of taps to use.)_

**（此解释也适用于在着陆屏右上方有搜索图标的应用。我将这两种案例放在一起，因为它们在可发现性，可访问性方面非常相似，甚至用户的点击率也很接近。）**

### 2. Search tab on navigation bar
### 2. 导航栏上的搜索选项卡

![](https://cdn-images-1.medium.com/max/2000/1*htxb3xD_rwZOeDkjGc5YnA.png)

Search tab on the navigation bar
导航栏上的搜索选项卡

And here are screenshots of some apps that use search as a tab on the navigation bar. This Search isn’t as discoverable as the Search bar on the landing screen, but it is easily accessible considering that the users can easily reach it with their thumbs.
以下是一些将搜索入口作为导航栏上的选项卡的应用程序的屏幕截图。此搜索不像登录屏幕上的搜索栏那样容易被发现，但考虑到用户可以轻松地用拇指轻松访问它，它很容易访问。

In this case, Search gets an entire screen for itself. This screen has a search bar on the top and the rest of the screen is populated with data that would either aid the user’s search or would help the user explore the content on the platform. This facilitates an **exploratory search** for the user who does not have a clear intention yet.
通常这种情况下，搜索会独占一个屏幕。在屏幕顶部有一个搜索栏，而屏幕的其余部分填充了有助于用户搜索或帮助用户探索平台内容的数据。这有助于尚未有明确意图的用户进行**探索性搜索**。

### Bar or Tab?
### 搜索框还是搜索选项卡？

Both the searches aid different intentions of the user. And that’s not all, both the searches also depend on the type of platform and the kind of content the platform offers.
这两种搜索分别满足了用户的不同的需求。此外，搜索模式也取决于平台的类型以及平台提供的内容类型。

#### Use a search bar on the landing screen when
#### 使用着陆屏上的搜索栏的场景

1.  The **user’s primary intention behind opening the app could be searching for something**. For reference, have a look at Google Maps, Uber or Zomato. Most of the times people open these apps precisely to perform a search for a location, a restaurant or a dish.
1. **用户打开应用的主要目的可能就是搜索**。举个例子，比如 Google Maps，Uber 或 Zomato。大多数情况下，人们打开这些应用恰恰是要搜索位置，餐馆或菜肴。
2.  The **user has a clear intention behind performing the search**, as in the case of Facebook where users generally look for other users or pages. Most of the times they know what the name of the user or page might be, even if they’re not completely certain of how it’s spelled. For such platforms, it’s a rare possibility that the user only has vague information about the thing they’re looking for. And even if this possibility arises, there’s not much that the platform can do to help the user.
2. **用户在进行搜索时有明确的意图**，例如 Facebook 的用户通常会寻找其他用户或主页。大多数情况下，他们即使不完全确定用户或者主页的名称是如何拼写的，也知道它的名称可能是什么。对于这样的平台，用户很少对正在寻找的东西只有模糊的信息。而且即使真的有这种可能性，平台也无法帮助到用户。

#### Use search as a tab on the navigation bar when
#### 使用搜索作为导航栏上的选项卡的场景

1.  You want to **enhance user engagement** by allowing the user to explore and discover new content on the platform. For reference, have a look at Instagram and Twitter. These platforms want the users to stay longer on the app, which is why they offer personalized content which is outside your network to help you discover new users or content that you might be interested in.
1. 希望通过允许用户在平台上探索和发现新内容来**增强用户参与度**。举个例子，比如 Instagram 和 Twitter。这些平台希望吸引用户在应用上停留的时间更长，因此他们提供来自用户的社交圈以外的个性化内容，以帮助用户发现可能感兴趣的新用户或新内容。
2.  The **user isn’t sure of what they’re looking for** and the app can guide the user in finding what they want. For reference, look at Netflix and Uber Eats. They allow the users to explore the app via the means of genres and cuisines. This caters to the user who knows he wants to watch a comedy show but isn’t really sure of which one he should watch.
2. **用户不确定他们正在寻找什么**，该应用可以引导用户找到他们想要的东西。举个例子，比如 Netflix 和 Uber Eats。它们允许用户通过浏览各种流派和美食的方式来探索应用。这迎合了想要观看喜剧节目，但不确定应该看哪个的用户。

### 现在，一起来看看 Airbnb ？

![](https://cdn-images-1.medium.com/max/2000/1*yhxaOzAg5yPGXeIdHPVRPw.png)

Airbnb（爱彼迎）

Airbnb 结合了这两种搜索模式：着陆屏上有一个搜索栏，同时着陆屏本身又是搜索/浏览选项卡所在屏。

鉴于 Airbnb 的业务场景，我认为这很有意义：同时迎合了两类用户 —— 一类是确定了目的地的用户将使用搜索栏（具有**明确意图的用户**），而另一类可能还没想好去哪儿的用户，正在考虑旅行目的地（他们需要**探索性的搜索**）。

### 结论

Both the variations have pros and cons. Both of them are suited for specific use cases. Going through all the examples above, we can conclude that there are two factors that determine which search to use — intentions of users coming to the app and the possible offerings of the app.
这两种不同模式各有利弊。它们都适用于特定场景。通过上述案例，我们可以得出结论：有两个因素决定了应该使用哪种搜索模式 —— 用户访问应用的意图以及应用本身能提供的内容。


* * *

#### Special Thanks To
#### 特别鸣谢

感谢 [Tanvi Kumthekar](https://medium.com/@tanvikumthekar) 和 [Shailly Kishtawal](https://medium.com/@shailly.kishtawal) 的头脑风暴。  
感谢 [Dhruvi Shah](https://www.linkedin.com/in/dhruvishah394/)、[Nisshtha Khattar](https://www.linkedin.com/in/nisshtha-khattar-9ab554159/)、[Preethi Shreeya](https://uxplanet.org/@preethishreeya1) 和 [Prasanth Marimuthu](https://www.linkedin.com/in/prasanthuxer/) 的反馈意见。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
