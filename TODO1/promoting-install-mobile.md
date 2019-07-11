> * 原文地址：[Patterns for Promoting PWA Installation](https://developers.google.com/web/fundamentals/app-install-banners/promoting-install-mobile?hl=zh-cn)
> * 原文作者：[Peter Mclachlan](https://developers.google.com/web/resources/contributors/pjmclachlan?hl=zh-cn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/promoting-install-mobile.md](https://github.com/xitu/gold-miner/blob/master/TODO1/promoting-install-mobile.md)
> * 译者：[Sam](https://github.com/xutaogit)
> * 校对者：[wuyanan](https://github.com/wuyanan)，[柯小基](https://github.com/lgh757079506)

# 推广安装 PWA 的模式（移动端）

渐进式网页应用（PWA）是一种[模式](https://developers.google.com/web/progressive-web-apps/?hl=zh-cn)，用于创建类应用程序，即时加载的，可靠的和可安装的网站。虽然 PWA 技术适用于包括[桌面端](https://developers.google.com/web/progressive-web-apps/desktop?hl=zh-cn)在内的所有设备，本篇文章重点介绍移动端 PWA 安装推广模式。

为什么你希望用户在他们的主页安装你的应用？和你希望用户从任何应用商店安装你的应用原因是一样的。安装了应用的用户是你最需关注的群体。安装了 PWA 的用户比一般的访客拥有更好的参与度指标，包括更频繁的访问次数，在页面上更久的停留时间以及更高的用户转化率，这些特点基本可以和移动设备上的本机应用相匹敌了。

**如果你的 PWA 有助于让用户安装你 app 的场景，例如，用户每周使用你的应用超过一次，那么你应该在 app 里使用网页 UI 技术推广你 PWA 的安装。**

**注意：**有关实施 PWA 安装推广所需的代码，请参阅[添加到主屏幕（Web）](https://developers.google.com/web/fundamentals/app-install-banners/?hl=zh-cn)。

## PWA 安装推广的最佳实践

无论你在网站上使用哪种推广模式，这些最佳做法都适用。

1. 将推广与你的用户操作流程相分离。举例来说，在 PWA 的登录页，将请求操作放在登陆表单和提交按钮下方。混乱的使用推广模式会降低你 PWA 的可用性，并且会对参与度指标造成负面影响。
2. 需包含关闭或减少推广的能力。如果他们这样做，请记住用户的偏好，并且只有在用户与你的应用内容的关系发生变化时才会重新提示，例如他们已登录或完成购买。
3. 可以在你 PWA 应用的不同部分里结合使用多种技术，但请注意不要过多的推广安装或打扰到你的用户。记住第一条规则 #1！
4. 仅在你[检测](https://developers.google.com/web/fundamentals/app-install-banners/?hl=zh-cn#listen_for_beforeinstallprompt)到 `beforeinstallprompt` 事件被触发时才显示推广信息。

## 浏览器自动推广

![](https://developers.google.com/web/updates/images/2018/06/a2hs-infobar-cropped.png?hl=zh-cn)

在主屏页添加 AirHorner 迷你信息栏的示例。

当你的 PWA 通过了 Android 上的[可安装性检查清单](https://developers.google.com/web/fundamentals/app-install-banners/?hl=zh-cn)时，浏览器就会告诉用户使用迷你信息栏 PWA 的可安装性。这个迷你信息栏只是一个辅助，未来它将被移除。

**注意：**从 Chrome 76 版本开始，你可以通过在 `beforeinstallprompt` 事件上调用 `preventDefault` [阻止迷你信息栏出现](https://developers.google.com/web/updates/2019/05/mini-infobar-update?hl=zh-cn)。如果你不调用 `preventDefault`，该条目会在用户第一次访问你的站点时被显示出来，并且这符合安卓的[可安装标准](https://developers.google.com/web/fundamentals/app-install-banners/?hl=zh-cn)，然后在大约 90 天以后它会再次显示。

## 应用 UI 推广模式

应用 UI 推广模式几乎适用于任何类型的 PWA 应用并在诸如网站导航，banner 等 UI 层面上体现出来。和使用任何其他类型的推广模式一样，很重要的一点是关照到用户的使用环境，尽量减少对用户操作流程的干扰。

在触发推广 UI 时，考虑周全的网站可以实现更多数量的安装，并避免干扰那些对安装不感兴趣的用户的操作流程。

### <a name="header"></a>固定标题

这里有一个安装按钮，它是你网站标题的一部分。其他标题内容通常包含网站品牌信息，诸如 logo 图标或者汉堡菜单。标题是否 `position:fixed` 取决于你的站点功能和用户需求。

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/header.png?hl=zh-cn)

如果使用得当，在你的站点标题处推行 PWA 安装是一种很好的方式，因为这可以让你的大多数忠实用户更轻松地回归到你的体验上来。PWA 标题里的每个像素都很有价值，所以请确保你的安装请求操作具有合适的大小，并且比其他任何可能的标题内容更重要，还不那么显眼。

你必须确保：

* 评估用户已安装用例的价值。考虑选择性定位的向那些可能从中受益的用户展示这些推广信息。
* 有效使用宝贵的标题空间。考虑在标题中可以为你的用户提供哪些其他帮助，并权衡安装推广相对于其他选项的优先级（译者注：也许其他选项比推广安装更重要）。

### <a name="nav"></a>导航菜单

在侧边滑出导航菜单里添加安装按钮或推广信息。

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/nav.png?hl=zh-cn)

导航菜单是推广安装应用的好地方，因为打开菜单的用户会发送与你的应用互动的相关信息。

请你确保：

* 避免破坏重要的导航内容。把 PWA 安装推广放在其他菜单项下面。
* 提供一个简短的相关说明，告诉用户安装 PWA 为什么能带来好处。

### <a name="landing"></a>落地页面

落地页的目的是宣传你的产品和服务，所以这里是一个适合大规模推广安装你们 PWA 应用优点的地方。

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/landing.png?hl=zh-cn)

首先，介绍你们网站的价值主张，然后让访问者了解他们能从安装中得到什么。

请你确保：

* 着重突出对你的访客最重要的功能，并强调可能将他们带到你落地页的关键字。（译者注：也许是这些关键字让用户访问的落地页）
* 既然是落地页。在明确了你的价值主张之后，应立即进行安装推广并使用号召性用语！
* 考虑在用户花费大量时间的应用上添加安装推广。

### <a name="banner"></a>安装 Banner

页面顶部可关闭的 banner。

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/banner.png?hl=zh-cn)

大多数用户在手机体验中遇到过安装 banner，并且熟悉 banner 提供的交互功能。应谨慎使用 banner，因为它们会对用户体验造成极大的破坏。

请你确保：

* 在显示 banner 之前，请等待用户对你的站点表现出足够的兴趣。如果你的用户关闭了 banner，请不要再显示，除非用户触发了转化事件，表明和你的内容有更高的参与度，例如在电子商务网站上的消费行为或者注册成为一个账号。
* 提供有关在 banner 中安装 PWA 的价值的简要说明。例如，你可以通过提及它的使用几乎不占用用户设备存储空间，也不会跳转到应用商店而是立即安装的方式，告诉用户安装一个 PWA 和本机应用的区别。

## 内在推广模式

内在推广技术将推广和站点内容交织在一起。这通常比应用 UI 上的推广更微妙一些，UI 具有权衡性。你希望你的推广足够突出，感兴趣的用户可能会注意到它，但降低了用户体验就不太值得。

### <a name="in-feed"></a>内反馈

在 PWA 中的新闻文章或其他信息卡列表之间出现的一个内反馈安装推广。

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/in-feed.png?hl=zh-cn)

你的目的是向用户展示他们如何更方便地访问到他们正在享受的内容。专注推广那些对你的用户有用的特性和功能。

请你确保：

* 减少推广的频率以免干扰到用户。
* 为用户提供关闭推广的能力。记住是你的用户选择去关闭

### <a name="journey"></a>预定或结账流程

在一系列流程进行或结束时展示安装推广，典型的是预定或结账流程。如果你在用户完成了流程操作时显示推广，那么因为流程已经结束你可以让它更加突出。

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/journey.png?hl=zh-cn)

请你确保：

* 包含一个相关的号召性用语。哪些用户可以从安装你的应用中受益？为什么？它与用户当下的操作流程有什么关系？
* 如果你的品牌为安装了应用的用户提供独特优惠，请务必在此处提及。
* 保证你的推广和流程的下一步是分离的，不然会对你的流程完成率造成负面影响。在上面的电子商务例子中，请注意关键结账流程操作是在应用安装推广之上的。

### <a name="sign-up"></a>注册，登录或注销流程

这类推广是前文[流程](#journey)推广模式的一种特例，并且促销卡可能会是一个更好的例子。
![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/sign-up.png?hl=zh-cn)

这些页面通常只会被参与的用户看到，其中你的 PWA 价值主张已经建立了。在这些页面上通常也不会放置很多其他有用的信息。所以，只要不干扰正常操作，较大规模的宣传性用语也只会产生较少的破坏性。

请你确保：

* 避免在注册表单里破坏用户的操作流程。如果这是一个多步骤过程，你可能需要等到用户完成流程再展示。
* 向已注册用户推广最相关的功能。
* 考虑在你的应用登录区域添加其他的安装推广。

## 我应该使用什么模式？

### 电子商户

许多电子商务品牌都拥有一批忠实的客户。这些客户想要推送通知，以便及早访问了解新的库存并且知道他们的商品什么时候发货。他们希望在主屏幕上使用应用，以便快速访问目录和全屏体验。

适用于电子商务PWA的模式包括：

* [Banner 模式](#banner)
* [标题模式](#header)
* [导航模式](#nav)
* [落地页模式](#landing)
* [内反馈模式](#in-feed)
* [流程模式](#journey)
* [注册模式](#sign-up)

#### 产品列表页 (PLP) 或者类别页面

这是内反馈安装推广模式的一个特例，这里的反馈是产品或类别列表。

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/plp.png?hl=zh-cn)

请你确保：

* 匹配产品列表页面其余部分的外观。
* 不干扰用户选择产品的选择过程。

### 富媒体和通讯

你是在构建下一个社交现象级或者音乐流媒应用吗？当用户第一次访问你的 PWA 应用时，邀请他们安装你的 PWA 是一种让他们再次回来的很好的方式。由于使用比本地应用更少的存储空间，你的用户会安装你的 PWA 并看看你的产品是否适合他们。

适用于富媒体和通信 PWA 的模式包括：

* [Banner 模式](#banner)
* [标题模式](#header)
* [导航模式](#nav)
* [落地页模式](#landing)
* [流程模式](#journey)
* [注册模式](#sign-up)

### 新闻

如果你在面向内容的站点上工作，那么你可能会有对安装 PWA 感兴趣的常规用户。

适用于新闻和社交 PWA 的模式包括：

* [Banner 模式](#banner)
* [标题模式](#header)
* [导航模式](#nav)
* [落地页模式](#landing)
* [内反馈模式](#in-feed)
* [流程模式](#journey)
* [注册模式](#sign-up)

### 游戏

现代网络对游戏来说是最伟大的分销平台，可以让最大型的游戏抵达世界各地。

适用于 PWA 游戏的模式包括：

* [Banner 模式](#banner)
* [标题模式](#header)
* [导航模式](#nav)
* [落地页模式](#landing)
* [内反馈模式](#in-feed)
* [流程模式](#journey)
* [注册模式](#sign-up)

#### 游戏结束

这实际上就是[流程](#journey) UI 模式的一个特例。

![](https://developers.google.com/web/fundamentals/app-install-banners/images/install-promo/game-over.png?hl=zh-cn)

大多数休闲和超级休闲游戏结束的很快。如果你的用户正在玩游戏，那么这是一个邀请他们安装的好机会。
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
