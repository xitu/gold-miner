> * 原文地址：[Designing notifications for apps: Explore different notification models and when to use which](https://medium.muz.li/designing-notifications-for-applications-3cad56fecf96)
> * 原文作者：[Shashank Sahay](https://medium.muz.li/@shashanksahay?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/designing-notifications-for-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/designing-notifications-for-applications.md)
> * 译者：[Ryden Sun](https://juejin.im/user/585b9407da2f6000657a5c0c/posts)
> * 校对者：[pkuwwt](https://github.com/pkuwwt) [sanfran1068](https://github.com/sanfran1068)

# 为应用程序设计通知提醒

## 探索不同的通知提醒模型以及如何去选择

![](https://cdn-images-1.medium.com/max/2000/1*iMPfw0qHQdgGzVdtAdJooQ.png)

通知提醒模型

Medium 的读者们，我们又见面啦。这里是我们的功能分解系列文章的第五期：应用程序的通知提醒模型。当前，通知提醒算是一个处理起来比较复杂的功能。这篇文章不会覆盖其所有的痛点，但是我希望可以为你提供足够清晰的理解，并在选择合适的应用程序通知提醒模型时，为你指明一个方向。

在我们开始讨论通知提醒模型之前，我们简要的看一下通知提醒的介绍以及它是由什么组成的。通知提醒是由应用程序发送给用户的一系列消息提示。这里是一些其重要的组成部分。

![](https://cdn-images-1.medium.com/max/2000/1*QbGBgcZWdNJ9C_VR6ORPxg.png)

通知提醒模型 — 图解

**来源：** 应用的这部分是通知提醒的起源。一个应用的架构可以有多个由信息分类组成的部分，并且这些部分是通知提醒的来源。

**信息：** 信息是一条需要通过通知提醒的方式传达给用户的消息。比如“嫦娥妹妹请求添加你为好友”或者“康熙开始关注你啦”。

**类型：** 通知提醒主要可分为两部分：通知型和可操作型。所有的类型都可根据其应用的内容有更深入的细分。

**通知标记:** 通知提醒提供可视化标示来引导用户查看通知。这些标示可以只是简单的点状符号，还可以加上未读消息的数目。

**锚点：** 锚点是应用程序界面上显示通知的可视化组件。简单来说，就是用户看到的通知标记所在的那个组件。简单来说，这个部分就是用户在哪里可以看到通知标记。注意，锚点不一定是通知的来源，只不过是显示通知的位置。一个锚点可以显示一个或多个来源的消息。换一句话说，消息来源是架构/信息层面的概念，而锚点只不过是实现层面让你可以看到通知标记的可视化组件。

通知提醒是应用程序用来和用户通讯的媒介，应用程序用通知提醒向用户发送信息，并且可能吸引用户重回应用。因此，它们是一个应用程序很重要的部分。让我来给你介绍一些最流行的通知提醒模型，并且合适去选择最合适的模型。

### 1. 通知中心

在这个模型里，会有一个明确的区域来落地所有的通知提醒。通知中心可以是一一整块专门的屏幕或者根据目前可用空间来弹出的界面。这个模型里，所有的通知提醒，不管其来源如何，都统一被放在通知中心。通过通知中心，你可以导航至不同通知提醒的源头。一个有通知标记的铜铃图标，就是所有通知提醒的入口。已读和未读通知提醒有一个可见的不同是很重要的，可以让用户来区别他们。

![](https://cdn-images-1.medium.com/max/2000/1*mFXz_7bAx1xn7_D2GhNP-Q.png)

Medium — 通知中心

这个模型最大的优势在于它的灵活性。这个地方可以容纳所有的通知提醒，不管是已存在或是新的来源。

#### 指导方针

*   所有不同类型的通知提醒都需要被考虑到，并且采用统一的设计形式。当设计此形式时，很重要的一点，是要将其可扩展性当做我们的首要目标。
*   如果你有太多不同来源的通知提醒，那这种模型可能会变得有一些杂乱。如果有相似的通知提醒类型，你应该将它们组合起来，以此来减少重复。举个例子，“王昭君和其他三个人请求添加您为好友”。
*   确保通知中心很容易被用户发现并访问到。

#### 什么时候使用通知中心

*   你的产品有通知提醒的需求，而这些通知无法集成到任何已有的导航选项中。原因可能是通知与产品上已存在的对象不一致，或者通知并不源自于当前信息架构中定义的任何消息源。
*   可能还有更多的消息源头无法在应用程序的首页显示。
*   你的时间有限。可能还没来得及考虑清楚每一种可能的场景及相应的锚点，你就必须交付一个功能了。这种情况下，通知中心是你简单的解决方案，并且它天生就很灵活。

### 2. 锚点在消息源上的通知提醒

这个模型里，每一个通知提醒都固定于一个导航选项，最可能的选择是消息源。这里没有一个承载所有通知提醒的中心。看一看 WhatsApp 会有一个更清晰的认识。在两个平台（android 和 iOS）上，来源于聊天或者通话的通知的锚点都置于其相应的导航菜单上。这个模型的优势在于它能引导用户发现更多内容。通过这种方式，用户可以直接访问到通知所传递的消息内容，无需多一个中间层。但这个模型并不像通知中心那样灵活和可扩展。

![](https://cdn-images-1.medium.com/max/2000/1*c2kNVbmXqVkyom8mHhPtsw.png)

WhatsApp — 锚点在消息源上的通知提醒

这个模型强烈依赖于应用程序的信息架构。导航必须容纳所有不同类型的通知。类似于前面的模型，已读和未读通知提醒有一个可见的不同是很重要的，可以让用户来区别他们。

#### 指导方针

*   确保每个通知提醒的锚点都能对应到应用程序首页的某个导航选项上。随着你应用复杂度的增长，通知提醒的数目也会增加。这种情况下，你可以投向通知中心的怀抱，或者考虑一种混合模型（那就是锚点模型和通知中心的结合）。我们会在下一节讲到混合模型。
*   每一个锚点都应有一个对应其所含内容的设计形式。确保你的通知契合锚点的设计形式。为了理解这个，让我们看一下 WhatsApp 的例子。锚点“聊天”有一个设计形式，它定义了一个聊天对象看起来应该是什么样子。这意味着每一个锚点固定于聊天的通知提醒都应该服从这种设计形式。这同样被用来设计“通话”的通知提醒。
*   确保锚点易于发现和访问。避免使用嵌套锚点。

#### 什么时候使用锚点在消息源上的通知提醒

*   当所有可能的消息通知来源都可以被首页容纳。
*   你已考虑到所有可能使用到通知提醒的场景，并且所有的通知提醒都可以适用于已存在的设计形式。很重要的一点是这些通知提醒应该遵守其锚点所在的消息源的设计形式。

### 3. 混合模型

这种模型是前面两种的结合。这种模型是最常被使用的。有很多比较火的应用是使用这种模式的，如 Facebook, LinkedIn, Twitter 和 Instagram。这些应用中，通知中心变成了导航菜单上的一个选项，它可以是不同来源的锚点，这些来源都不还不够资格在首页展示。比如，Facebook 把请求添加好友的通知锚点到“朋友”选项，但邀请点赞被锚点到了通知中心。

![](https://cdn-images-1.medium.com/max/2000/1*xQ8ULaQ6PFvPueFQOYxTpQ.png)

Facebook — 混合模型

这种模型有以上两种模型的优点，并且可以轻易地适用大多数情况。即使现在你有能力将消息提醒锚点到通知中心，但依旧有必要考虑所有的场景并且将它们排出优先级，找到那些可以适用锚点于来源的通知提醒。

就像锚点在消息源上的通知提醒模型，这个模型也严重依赖于导航菜单，而且还有一个通知中心的菜单选项。

#### 指导方针

*   找出产品架构中最重要的那些信息，并对其优先级排序，这样你才可以决定哪些锚点应放在消息源，哪些应放在通知中心。因为此模型依赖于导航，通知提醒的配置可能会因可用空间的变化而改变。
*   确保首屏的导航中容易找到主要的锚点和通知中心

#### 什么时候使用混合模型

*   你有考虑过所有通知提醒的使用场景。你有一些通知提醒的锚点可以放在消息源上，但是还有一些无法放在当前架构的任何消息源上
*   你的架构中存在嵌套的消息源。比如，Facebook 应用程序的汉堡式菜单图标是一个锚点，它对应于多个消息源，比如 Groups、Watch、Memories、Saved 和 Marketplace 等等。

### 结论

以上所有提到的模型在正确的使用场景下都是很有用的。你的应用程序选择使用哪种模型取决于产品的信息架构和你青睐的消息通知类型。

### 不要忘记点赞

10 次不错，20 次更好，但 50 次是最好的。直接按住按钮不放就行了。:P

希望这篇文章有助于你为应用程序选择合适的通知提醒模型。如果你有任何的反馈，在评论中让我们知道。

* * *

#### 特别鸣谢

[Shailly Kishtawal](https://medium.com/@shailly.kishtawal) 的头脑风暴。[Prerna Pradeep](https://www.linkedin.com/in/prernapradeep/) 在内容上的帮助。以及 [Dhruvi Shah](https://www.linkedin.com/in/dhruvishah394/) 和 [Tanvi Kumthekar](https://medium.com/@tanvikumthekar) 的早期反馈。

点击下面链接来查看之前的功能分解系列文章。

1.  [Medium Claps: Why it’s so difficult?](https://medium.muz.li/feature-breakdown-1-medium-claps-40fc7de4539b)
2.  [Google Search Results: List View vs Grid View](https://medium.muz.li/feature-breakdown-2-google-search-results-list-vs-grid-1f3f26d66656)
3.  [YouTube Search Query: Why doesn’t it go away?](https://medium.muz.li/feature-breakdown-3-youtube-search-query-web-25c6d318f6d)
4.  [Designing search for mobile apps](https://medium.muz.li/designing-search-for-mobile-apps-ab2593e9e413)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
