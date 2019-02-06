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

当用户想去做这些事的时候：

*   研究一些有趣的东西，
*   去某地，
*   进行购买，
*   或做点什么......

他们不会在他们的设备上打开与数据息息相关的应用程序，而是打开他们的搜索浏览器并键入或说出他们的查询。这就是我们作为用户最有可能去做的事情。有一个问题？需要某物？想要帮助选择一家餐馆吗？转到 Google。

如果您的网站或应用程序提供了这类问题的答案，您不希望它隐藏在应用程序商店中，您也不想给他们一个提供“下载应用程序”选项的移动网站。你只是为他们创造额外的工作。

通过 PWA，您可以将应用直接放置在搜索结果中，并为您的用户提供所需的即时答案。

我认为这就是为什么电子商务企业特别倾向于像 [HobbyCraft](https://www.hobbycraft.co.uk/) 这样的 PWA。

[![HobbyCraft PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4c932970-c61b-4193-9d20-9a204f4b24d2/11-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4c932970-c61b-4193-9d20-9a204f4b24d2/11-will-pwas-replace-native-mobile-apps.png) 

HobbyCraft PWA 示例（图片来源： [HobbyCraft](https://www.hobbycraft.co.uk/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/4c932970-c61b-4193-9d20-9a204f4b24d2/11-will-pwas-replace-native-mobile-apps.png)）

正如你在这里看到的，HobbyCraft 是一家零售商，在英国境外销售工艺品。在应用程序商店中放置这样的东西是没有多大意义的 —— 特别是当 PWA 入口工作得很好时。

[兰蔻](https://www.lancome-usa.com/) 是另一家电子零售商，它有意识地决定放弃原生应用，并将移动购物体验保持在 PWA 格式。

[![Lancome PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52a5212c-488b-4a69-a2f1-08d83ccb3cf0/1-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52a5212c-488b-4a69-a2f1-08d83ccb3cf0/1-will-pwas-replace-native-mobile-apps.png) 

兰蔻电子商务PWA示例（图片来源：[Lancome](https://www.lancome-usa.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52a5212c-488b-4a69-a2f1-08d83ccb3cf0/1-will-pwas-replace-native-mobile-apps.png)）

我将在这两个示例中指出的一个重要设计元素是位于顶部导航栏中的Stores图标。对于拥有实体产品的企业，没有理由让您的应用在Google中进行[本地搜索](https://www.smashingmagazine.com/2018/06/local-search-mobile-web-design/)。

如果您正确设计了PWA，则可以将其显示在相关的基于位置的查询中。如果你提供一个让人想起原生应用程序的界面 —— 并且与在原生应用上一样安全（因为 PWA 需要 HTTPS）—— 你可以促使更多的移动用户在 PWA 上进行购买。

#### 原因＃4：原生应用难以被持久保留

对于具有钩子的应用类型，该钩子促使用户在原生应用中花费时间并花钱进一步享受体验，这很棒。当你发现完美契合时，有一个原生应用程序可以赚到很多钱。这只是让人们愿意承诺下载的问题。

但是，正如我们最近看到的 [本机应用程序都很难留住用户](https://www.smashingmagazine.com/2018/10/mobile-app-retention-rate/).

您获得的初始下载量无关紧要。如果移动用户未返回应用以与您的内容互动，购买订阅或升级或点击广告，则将其视为浪费的投资。不幸的是，很多人就是这种情况。

另一方面，PWA 不是必须下载应用程序到一个设备上。哎呀，用户甚至不必将 PWA 保存到他们的主屏幕，如果他们不想这样做的话。这是一个整体更方便的体验。

尽管如此，您可能更希望用户将其保存以便将来即时访问，就像 [The Weather Channel](https://weather.com/) 这样做的：

[![The Weather Channel PWA message](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f5167704-6515-4283-bdc9-5e530dbaf288/8-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f5167704-6515-4283-bdc9-5e530dbaf288/8-will-pwas-replace-native-mobile-apps.png) 

天气频道要求用户将PWA保存到设备。（图片来源：[The Weather Channel](https://weather.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/f5167704-6515-4283-bdc9-5e530dbaf288/8-will-pwas-replace-native-mobile-apps.png)）

真的，它取决于你构建的应用程序的类型。

天气频道，实话说，提供的服务 _将会_ 在日常被使用。用户可以通过应用程序商店安装原生应用程序查看最新的天气预报，但该应用程序可能比基于浏览器的 PWA 更快地消耗数据和电池电量。

出于这个原因，还有其他业务类型应考虑使用PWA。 就好像 [Forbes](https://www.forbes.com/) 这样的在线杂志。

[![Forbes PWA add to homescreen](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1bf93e11-6217-414c-96ae-65119a598c93/5-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1bf93e11-6217-414c-96ae-65119a598c93/5-will-pwas-replace-native-mobile-apps.png) 

用户可以将福布斯 PWA 添加到其主屏幕，就像原生应用程序一样。（图片来源：[Forbes](https://www.forbes.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/1bf93e11-6217-414c-96ae-65119a598c93/5-will-pwas-replace-native-mobile-apps.png)）

高度专业化的出版物为他们的日常读者开发 PWA 也可以有更好的效果。

同样，它为他们的手机提供了更轻量级的体验。此外，PWA 为用户提供离线访问，因此他们随时可以访问内容，无论他们身在何处或者网络情况是否有限。主屏幕入口的存在（如果他们选择将按钮放在那里），在移动网络浏览器之外提供了一个很好的小捷径。

#### 理由5：PWA 可以产生更多收入

除了应用内广告外，Apple 和 Google 从您通过原生应用进行的推广中获得了相当大的利润削减。这包括付费下载、应用内购买或升级和订阅费用。甚至有时候，这些费用高达每次销售30％。

当你希望花钱进行设计调整，急需的开发更新和促销广告时，这是你想听到的最后一件事。换句话说，从您的原生应用程序 _开始_ 流入的大部分资金直接进入应用程序商店所有者的口袋。这似乎不太对劲，特别是如果您必须为应用商店广告付费以获得其中的搜索可见性。

PWA 不收取任何费用，这意味着它们产生的所有收入都直接发送给您（或业务所有者）。如果您有像本地报纸（例如 The Billings Gazette）这样给您带来较小的利润率的应用程序，这一点尤为出色。

[![Billings Gazette PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/10fe37f8-8aa1-4873-a68b-fa619447a4c3/12-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/10fe37f8-8aa1-4873-a68b-fa619447a4c3/12-will-pwas-replace-native-mobile-apps.png) 

Billings Gazette PWA货币化示例（图片来源： [The Billings Gazette](https://billingsgazette.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/10fe37f8-8aa1-4873-a68b-fa619447a4c3/12-will-pwas-replace-native-mobile-apps.png)）

这不是您从 PWA 获得比原生应用更多资金的唯一方式。

首先，它们比原生应用程序更容易构建。此外，在发布后管理它们需要更少的时间和资源。是的，它仍然需要更新和维护 —— 就像网络上的任何其他内容一样 - 但您不必处理应用商店中带来的障碍。

例如，您只需构建一个PWA Web应用程序。您无需创建单独的符合不同移动设备的指南。

更新也更容易，特别是如果您的 PWA 是基于 WordPress 网站。您通过 pipeline 推送更新，它会实时在 PWA 中生效。无需将更新推送到应用商店管理员并等待他们的批准。一切都是实时发生的，这意味着更快地向公众发布新功能和赚钱计划。

这对于像 [Twitter](https://twitter.com/) 这样的 PWA 很有用。

[![Twitter Lite PWA](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8dcaca3f-b3eb-49b6-b83e-f20091130445/10-will-pwas-replace-native-mobile-apps.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8dcaca3f-b3eb-49b6-b83e-f20091130445/10-will-pwas-replace-native-mobile-apps.png) 

Twitter Lite PWA可以实时保持最前沿（图片来源：[Twitter](https://twitter.com/)) ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8dcaca3f-b3eb-49b6-b83e-f20091130445/10-will-pwas-replace-native-mobile-apps.png)）

当面对主导应用商店的众多社交媒体巨头时，能够让您的应用实时更新可以作为强大的竞争优势。这是通过渐进式Web格式开发应用程序所带来的所有其他好处的附赠品。

这就是 Twitter 推出其 PWA 之后所发生的事情。

正如 Google 的 [case study from Google](https://developers.google.com/web/showcase/2017/twitter) 所示，Twitter 采取了渐进的方法来优化其 PWA。因此，他们能够在没有最终用户检测的情况下对用户体验进行大幅改进。事实上，他们对更新的唯一回应是更多地使用PWA。

### PWA是（大部分）Web的未来

可见性和可搜索性是原生移动应用程序的常见问题，用户保留是另一个。它们只是不可持续的，除非你有一个想法能够创造一个肯定带来钱的原生入口。手机游戏就是其中的一个例子。我认为网约应用程序是另一个。我曾经认为社交媒体属于这一类别，但Twitter证明我错了。

**根据我在网上看到的内容以及我从开发人员朋友和同事那里听到的内容，我相信未来是在PWA中。**

我认为随着开发人员意识到将中小型公司的应用程序放入 PWA Web 中有很多好处，应用程序商店将逐渐退出减缓热度。主要参与者将保持不变，而已经超出 PWA 范围的公司可能最终会转移。否则，大多数应用程序将以 PWA 的形式结束。

随着PWA的这种趋势继续增长，用户将更加习惯于在搜索中遇到它并且知道这个用户友好的界面可以直接从他们的浏览器访问。相反，他们只会去应用商店寻找属于那里的各种应用，即消息，游戏，娱乐和一些社交媒体。这将在在线搜索和应用商店搜索之间创建更清晰的划分，并进一步帮助改善在线的整体用户体验

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
