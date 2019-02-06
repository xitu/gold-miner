> * 原文地址：[Will PWAs Replace Native Mobile Apps?](https://www.smashingmagazine.com/2018/12/pwa-native-mobile-apps/?utm_source=mobiledevweekly&utm_medium=email)
> * 原文作者：[Suzanne Scacca](https://www.smashingmagazine.com/author/suzanne-scacca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/pwa-native-mobile-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/pwa-native-mobile-apps.md)
> * 译者：
> * 校对者：

# PWA 会取代原生移动应用吗？

当谈到移动用户体验，移动网站是不是很糟糕？您已经听到了很多关于构建专用原生应用程序的好处，但如果用户不接受它，这可能会成为令人难以置信的代价高昂的赌博。那么，渐进式网络应用程序是最佳选择吗？它是否最终将取代移动网页和原生应用吗？本文探讨了这个想法。

我的一位开发人员朋友决定为他的新公司构建一个 PWA 应用程序。当我问他为什么选择PWA而不是原生应用时，他说：

> “因为 PWA 是网页的未来。”

我认为那是一种有趣的想法。直到他提到它，我和 Aaron Gustafson 在讨论 [原生 APP 和 PWA 之间的斗争](https://www.smashingmagazine.com/2018/02/native-and-pwa-choices-not-challengers/) 时有着类似的心态。换句话说，我认为它真的只是应该归结为一个选择，而不是完全比另一个好。

既然这个想法已经被种下了，我不禁注意到一群人宣称他们支持原生应用程序上的 PWA。不仅如此，他们中的许多人甚至说 PWA 将完全取代原生应用程序。

我想看看这样的论点是否有一些水分。

### PWA会取代原生应用吗？

我现在要首先回答这个问题：

> “是的，但不适合所有人。”

这是我看到它的方式：

**移动网页**与几年前相比有了明显的改进。在设计中遇到100％响应的网站是非常罕见的。也就是说，我不认为很多移动网站在设计上都是100％移动优先(我最近在 [在移动设备上投放或重新利用的元素](https://www.smashingmagazine.com/2018/12/elements-ditch-repurpose-mobile/) 一文中提到了这一点)。

我认为，要获得真正的移动优先体验，它需要更快，并拥有原生应用程序的外壳，这正是 **PWA** 提供的。

虽然**原生应用**可以（大多数情况下）提供卓越的移动体验，但我认为没有必要花费这么多金钱和时间来构建和管理一个应用……除非您的应用程序在应用商店中位于某项类别的前20位。

让我打破我过去做出这个决定的逻辑。

#### 原因＃1：移动网页已经落伍了

comScore 在2018年发表的 [全球数字未来焦点报告](https://www.comscore.com/Insights/Presentations-and-Whitepapers/2018/Global-Digital-Future-in-Focus-2018) 明确地谈到这样一点

[![comScore 2018 mobile web vs. app](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4401052b-487f-4349-a901-5fbe018b4a6f/9-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4401052b-487f-4349-a901-5fbe018b4a6f/9-will-pwas-replace-native-mobile-apps.png) 

comScore 的2018报告显示移动网页与移动应用的用户占比 （图片来源： [comScore](https://www.comscore.com/Insights/Presentations-and-Whitepapers/2018/Global-Digital-Future-in-Focus-2018)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4401052b-487f-4349-a901-5fbe018b4a6f/9-will-pwas-replace-native-mobile-apps.png)）

也就是说，我不相信原生应用程序会让移动网页消失。我也不相信这一点可以抵消我今天试图提出的论点。如果此数据想要表示什么，那么则是移动用户非常喜欢通过应用程序界面进行数字交互的体验。

Web开发人员也发现了用户的这种偏好，正如 [来自 JAXenter 的调查](https://jaxenter.com/react-native-tool-native-vs-pwa-poll-150667.html) 表明：

[![JAXenter PWA survey](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/96c7279c-cff6-42ad-bb24-4c774ad83f9d/13-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/96c7279c-cff6-42ad-bb24-4c774ad83f9d/13-will-pwas-replace-native-mobile-apps.png) 

关于 PWA 的 JAXenter 开发人员调查（图片来源： [JAXenter](https://jaxenter.com/react-native-tool-native-vs-pwa-poll-150667.html)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/96c7279c-cff6-42ad-bb24-4c774ad83f9d/13-will-pwas-replace-native-mobile-apps.png)）

因此，虽然移动网页浏览器已被证明是用户不太喜欢看到某个网站的首要选择，但随着越来越多的企业建立 PWA，我不认为这样的情况会更久。

PWA拥有用户喜欢的原生应用程序的特点 —— 应用程序外壳，离线访问，电话功能，始终存在的导航栏等等 —— 并为用户提供了更方便的体验方式。

看看 [Crabtree & Evelyn](http://www.crabtree-evelyn.com/) 这样的品牌：

[![Crabtree & Evelyn PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b11bd3d3-0e48-4362-9780-aa1b929bb6b1/3-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b11bd3d3-0e48-4362-9780-aa1b929bb6b1/3-will-pwas-replace-native-mobile-apps.png) 

Crabtree & Evelyn PWA 示例 （图片来源： [Crabtree & Evelyn](http://www.crabtree-evelyn.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b11bd3d3-0e48-4362-9780-aa1b929bb6b1/3-will-pwas-replace-native-mobile-apps.png)）

这家大型零售商有资本建立与其网站类似的原生应用程序，但它没做那样的选择。相反，PWA Web 应用程序的为移动用户提供了浏览在线商店和购买而不必离开浏览器的便利体验。

或者，如果他们是频繁的用户，他们可以将此 PWA 添加到他们的主屏幕，并将其视为任何其他应用程序（将来会有更多）。

现在，让我们再看一个PWA的例子，它再次选择不去开发一个原生应用程序。相反，[Infobae](https://www.infobae.com/america/) 创造了一个打败移动网页体验的PWA：

[![Infobae PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4cac4628-c1c7-440f-8052-8630fa8f43ee/7-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4cac4628-c1c7-440f-8052-8630fa8f43ee/7-will-pwas-replace-native-mobile-apps.png) 

Infobae PWA 示例（图像来源：[Infobae](https://www.infobae.com/america/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4cac4628-c1c7-440f-8052-8630fa8f43ee/7-will-pwas-replace-native-mobile-apps.png)）

[根据谷歌数据](https://developers.google.com/web/showcase/2017/infobae)，Infobae PWA有以下优势：

*   跳出率为5％。移动网络是51％。
*   Session 机制比移动网页上的时间长230％。
*   每个 Session 查看的页面数比移动网络多三倍。

因此，如果您担心 PWA 不会成为移动网页的替代品，那么您可以在那里停下来，但建立PWA的确有明显的好处。

#### 原因＃2：原生应用商店逐渐饱和并已过量

原生应用在原生应用商店中存在很多竞争 —— 其中许多是移动用户都非常熟悉的重量级产品。如果您的目的是在已经拥挤的空间中竞争，那么应用程序商店真的是最适合它的地方吗？

[comScore](https://www.comscore.com/Insights/Presentations-and-Whitepapers/2018/Global-Digital-Future-in-Focus-2018)  的覆盖率进入前5应用的报告： 

[![comScore top 5 apps](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56b3e6fc-73ef-4608-8adf-0370929738a0/6-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56b3e6fc-73ef-4608-8adf-0370929738a0/6-will-pwas-replace-native-mobile-apps.png) 

ccomScore 在2018年达到前五的应用的数据（图片来源：[comScore](https://www.comscore.com/Insights/Presentations-and-Whitepapers/2018/Global-Digital-Future-in-Focus-2018)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56b3e6fc-73ef-4608-8adf-0370929738a0/6-will-pwas-replace-native-mobile-apps.png)）

正如您所看到的，无论移动用户位于世界的哪个部分，前5的应用程序往往由相同的移动应用程序主导。

您可能会想到的是，“但如果我的应用具有独特的优势呢？还不足以支配我们的市场吗？“

我可以预见，特别是如果您的应用针对特定地区的移动用户，您就必须考虑哪种应用类型与移动应用用户表现良好。

comScore 打破了这一点：

[![comScore total app minute share](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/fba4b726-7711-4ea1-a2ba-97bdde4bfd8c/2-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/fba4b726-7711-4ea1-a2ba-97bdde4bfd8c/2-will-pwas-replace-native-mobile-apps.png) 

comScore关于应用总分钟份额的数据（图片来源：[comScore](https://www.comscore.com/Insights/Presentations-and-Whitepapers/2018/Global-Digital-Future-in-Focus-2018)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/fba4b726-7711-4ea1-a2ba-97bdde4bfd8c/2-will-pwas-replace-native-mobile-apps.png)）

在移动应用程序中用户花费的时间大约在70％到80％可以分为四类：

*   娱乐（如YouTube）
*   社交媒体（如Facebook）
*   即时通讯（如Whatsapp）
*   游戏（如Fortnite）

如果您的应用程序概念不属于这些类别之一，那么将应用程序放入应用程序商店是否值得所有工作？虽然我认识到这些并不是唯一能成功的应用程序，但我认为这将是一个冒险且代价昂贵的赌博，特别是如果您的客户的业务是全新的。即便如此，尽管拥有足够多的受众或客户群，但仍有很多不在应用商店中的知名产品的竞争。

[West Elm](https://www.westelm.com/) 是零售商的一个很好的例子：

[![West Elm PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e7fefd4f-5d94-4bdc-ac5a-eece8e51c054/4-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e7fefd4f-5d94-4bdc-ac5a-eece8e51c054/4-will-pwas-replace-native-mobile-apps.png) 

West Elm PWA（图片来源：[West Elm](https://www.westelm.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e7fefd4f-5d94-4bdc-ac5a-eece8e51c054/4-will-pwas-replace-native-mobile-apps.png)）

如果您查看应用程序商店，您会发现 West Elm 已经开发了两个原生应用程序。一个是用于用户注册。这是有道理的，因为移动应用程序可能有助于标记和跟踪注册表项。它还有一个用于 West Elm 购物卡。如果有人经常购物，这种类型的应用程序也可能有意义。

也就是说，这些本机应用程序都不受用户欢迎（至少在评论数量方面不受欢迎）。因此，West Elm 将其主要购物界面保留在 PWA 中是一项明智而经济的举措。

#### 原因＃3：PWA在搜索中的排名

在相关的说明中，PWA 应用程序还具有在搜索引擎中排名的额外好处。您和您的客户应该为此高兴的原因有以下几个：

1.  您的应用在搜索中的排名取决于您投入的SEO工作。如果你已经在你的网站上这样做，这应该很容易！
2.  您不必担心一个全新的应用程序被埋没在应用程序商店搜索中，或者由于缺乏评级而轻易被下架。
3.  由于PWA可以存在于移动用户的浏览器中以及主屏幕上的按钮中，因此它需要具有链接。链接可以更方便地与朋友/家人/同事共享，而不是告诉他们应用程序的名称，希望他们可以自己在商店中找到它。

最后：如果您可以为用户提供与应用程序的实际链接，则可以大幅减少通常由于只有应用程序商店中存在的问题而导致的问题。以 [micro-moments](https://www.smashingmagazine.com/2018/08/designing-for-micro-moments/) 为例。

When a consumer is inspired to:

*   Research something of interest,
*   Go somewhere,
*   Make a purchase,
*   Or do something…

Instead of opening a data-hogging application on their device, they’ll open their search browser and type or speak their query. It’s what we’re all trained to do as consumers. Have a question? Need something? Want help choosing a restaurant? Go to Google.

If your website or app provides an answer to those kinds of questions, you don’t want it hidden away in app stores. You also don’t want to give them a mobile website that offers an option to “Download the App”. You’re only creating extra work for them.

A PWA enables you to place your app directly in search results and to get your users the instant answers they require.

I think this is why e-commerce businesses have especially gravitated towards PWAs, like [HobbyCraft](https://www.hobbycraft.co.uk/).

[![HobbyCraft PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4c932970-c61b-4193-9d20-9a204f4b24d2/11-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4c932970-c61b-4193-9d20-9a204f4b24d2/11-will-pwas-replace-native-mobile-apps.png) 

HobbyCraft PWA example (Image source: [HobbyCraft](https://www.hobbycraft.co.uk/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4c932970-c61b-4193-9d20-9a204f4b24d2/11-will-pwas-replace-native-mobile-apps.png))

As you can see here, HobbyCraft is a niche retailer that sells craft supplies out of the UK. It wouldn’t make much sense to put something like this in the app stores — especially when the PWA interface works well enough as it is.

[Lancome](https://www.lancome-usa.com/) is another e-tailer that’s made the conscious decision to forego the native app and keep the mobile shopping experience in a PWA format.

[![Lancome PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52a5212c-488b-4a69-a2f1-08d83ccb3cf0/1-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52a5212c-488b-4a69-a2f1-08d83ccb3cf0/1-will-pwas-replace-native-mobile-apps.png) 

Lancome e-commerce PWA example (Image source: [Lancome](https://www.lancome-usa.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52a5212c-488b-4a69-a2f1-08d83ccb3cf0/1-will-pwas-replace-native-mobile-apps.png))

One important design element I would point you to in both these examples is the Stores icon located in the top navigation bar. For businesses with brick-and-mortar counterparts, there’s no reason to keep your app out of [local search](https://www.smashingmagazine.com/2018/06/local-search-mobile-web-design/) in Google.

If you design your PWA correctly, you can make it show up in relevant location-based queries. And if you present an interface that’s reminiscent of a native app — and just as secure as one (since PWAs require HTTPS) — you can compel more mobile users to make a purchase on the spot.

#### Reason #4: Native Apps Struggle With Retention

For app types that have a hook that compels users to spend time inside a native app and spend money to enjoy the experience further, that’s great. When you find that perfect fit, there’s good money to be made from having a native app. It’s simply a matter of having people willing to commit to the download.

However, as we recently saw, most [native apps struggle to retain users](https://www.smashingmagazine.com/2018/10/mobile-app-retention-rate/).

It doesn’t matter how many initial downloads you get. If mobile users don’t return to the app to engage with your content, purchase subscriptions or upgrades or click on ads, consider it a wasted investment. Unfortunately, that’s the case with a lot of them.

PWAs, on the other hand, don’t require the lofty commitment of having to download an app to one’s device. Heck, users don’t even have to save the PWA to their home screens, if they don’t want to. It’s an overall more convenient experience.

Nevertheless, you may want to urge users to save it for instant access in the future, as [The Weather Channel](https://weather.com/) does:

[![The Weather Channel PWA message](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f5167704-6515-4283-bdc9-5e530dbaf288/8-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f5167704-6515-4283-bdc9-5e530dbaf288/8-will-pwas-replace-native-mobile-apps.png) 

The Weather Channel asks users to save PWA to device. (Image source: [The Weather Channel](https://weather.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f5167704-6515-4283-bdc9-5e530dbaf288/8-will-pwas-replace-native-mobile-apps.png))

Really, what it boils down to is the type of app you’ve built.

The Weather Channel, for instance, provides a service that mobile users _will_ want to use on a daily basis. They could install a native app from the app store with up-to-date weather forecasting, but that app would likely chew through data and battery power a lot more quickly than the browser-based PWA will.

There are other business types that should consider using a PWA for this reason. Think about an online magazine like [Forbes](https://www.forbes.com/).

[![Forbes PWA add to homescreen](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1bf93e11-6217-414c-96ae-65119a598c93/5-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1bf93e11-6217-414c-96ae-65119a598c93/5-will-pwas-replace-native-mobile-apps.png) 

Users can add the Forbes PWA to their home screen just like a native app. (Image source: [Forbes](https://www.forbes.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1bf93e11-6217-414c-96ae-65119a598c93/5-will-pwas-replace-native-mobile-apps.png))

Highly specialized publications would do really well to develop PWAs for their daily readers.

Again, it provides a much lighter-weight experience for their phones. Plus, PWAs give users offline access, so they can get access to content no matter where they are or how limited their access may be to the Internet. And the home screen presence (if they choose to put the button there), provides a nice little shortcut around the mobile web browser.

#### Reason #5: PWAs Can Generate More Revenue

With the exception of in-app advertising, Apple and Google take a sizable cut from any sales you make through a native app. This includes paid downloads, in-app purchases or upgrades and subscription fees. At one point, these fees were as high as 30% per sale.

When you’re hoping to spend money on design tweaks, much-needed development updates and promotional advertising, that’s the last thing you want to hear. In other words, a significant portion of the money that _starts_ to trickle in from your native app goes straight into the pockets of app store owners. That doesn’t seem right, especially if you have to pay for app store ads in order to gain visibility within them.

PWAs don’t come with fees to pay-to-play, which means all revenue generated from them go directly to you (or whoever the owner of the business is). This is especially nice if you have an app concept like a local newspaper (such as [The Billings Gazette](https://billingsgazette.com/)) that probably deals in smaller profit margins to begin with.

[![Billings Gazette PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/10fe37f8-8aa1-4873-a68b-fa619447a4c3/12-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/10fe37f8-8aa1-4873-a68b-fa619447a4c3/12-will-pwas-replace-native-mobile-apps.png) 

The Billings Gazette PWA monetization example (Image source: [The Billings Gazette](https://billingsgazette.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/10fe37f8-8aa1-4873-a68b-fa619447a4c3/12-will-pwas-replace-native-mobile-apps.png))

That’s not the only way you can make more money from PWAs than native apps either.

To start, they’re significantly easier to build than native apps. Plus, managing them after launch requires less of a time commitment and resources from you. Yes, it still needs to be updated and maintained — just like anything else on the web — but you don’t have to deal with the obstacles that come with apps in the app store.

For example, you only have to build one progressive web app. You don’t have to create separate ones to match the guidelines for different mobile devices.

Updates are easier, too, especially if your PWA is based off of a WordPress website. You push an update through the pipeline and it shows up immediately in the live PWA. There’s no need to push updates to the app store admins and wait for their approvals. Everything happens in real time, which means getting new features and money-making initiatives out to the public more quickly.

This is helpful in the case of PWAs like [Twitter](https://twitter.com/) Lite.

[![Twitter Lite PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8dcaca3f-b3eb-49b6-b83e-f20091130445/10-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8dcaca3f-b3eb-49b6-b83e-f20091130445/10-will-pwas-replace-native-mobile-apps.png) 

The Twitter Lite PWA can stay on the cutting edge in real time (Image source: [Twitter](https://twitter.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8dcaca3f-b3eb-49b6-b83e-f20091130445/10-will-pwas-replace-native-mobile-apps.png))

When going up against a plethora of social media giants that dominate the app stores, having the ability to keep your app updated in real time can serve as a strong competitive edge. This is in addition to all of the other benefits that come from developing your app in a progressive web format.

This is what happened when Twitter put out its PWA.

As this [case study from Google](https://developers.google.com/web/showcase/2017/twitter) shows, Twitter took an incremental approach to optimizing its PWA. As such, they’ve been able to introduce huge improvements to the user experience without much detection from the end user. Their only response to the updates, in fact, has been greater usage of the PWA.

### The PWA Is The Future For (Most Of) The Web

Visibility and searchability are known problems with native mobile apps. User retainment is another. And they’re just not sustainable unless you have an idea that’s inherently meant for a native interface that’s sure to bring in money. Mobile games are one example of this. I’d argue that dating apps are another. I used to think social media fell into that category, but Twitter has since proven me wrong.

**Based on what I’m seeing online and from what I’ve heard from developer friends and colleagues, I do believe the future is in the PWA.**

I think app stores will slowly quiet down as developers realize there are many more benefits to putting a small- to medium-sized company’s app into a progressive web form. The major players will stay put, and companies that have outgrown the bounds of the PWA may eventually move over. But, otherwise, most apps will end up in the progressive web format.

As this trend towards the PWA continues to grow, consumers will become more accustomed to encountering it in search and know that this user-friendly interface is accessible right from their browser. In turn, they’ll only go to the app stores for the kinds of apps that belong there, i.e. messaging, games, entertainment, and some social media. This will create a clearer division between online search and app store search, and further help to improve the overall user experience online.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
