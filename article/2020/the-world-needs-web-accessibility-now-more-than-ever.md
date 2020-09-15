> * 原文地址：[The World Needs Web Accessibility Now More Than Ever](https://levelup.gitconnected.com/the-world-needs-web-accessibility-now-more-than-ever-df8dc4aab2b6)
> * 原文作者：[KBronJohn](https://medium.com/@kbronjohncompinclus)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-world-needs-web-accessibility-now-more-than-ever.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-world-needs-web-accessibility-now-more-than-ever.md)
> * 译者：[tonylua](tonylua@sina.com)（[掘金主页](https://juejin.im/user/3034307821311895)）
> * 校对者：[Chorer](https://github.com/Chorer), [rachelcdev](https://github.com/rachelcdev)

# 世界比以往任何时候都更需要 Web 可访问性

![](https://cdn-images-1.medium.com/max/2158/1*fM91JgfWigiKGZLA5hYC5w.jpeg)

我注意到 [Mike Gifford](https://openconcept.ca/users/mike) 在去年的一次谈话中说到：“实际上从 2011 年起 web 就变得缺少可访问性了。”

如今任何人创建一个网站都是廉价和容易的，而谁都难以考虑到可访问性（accessibility）。那为什么你要考虑这个呢？如果其本就不在你的视野中，那它也不会出现在你的网站需求列表里。糟糕的是，大多数人在创建一个网站时，的确不会考虑其终端用户是不是残障人士。特别是当他们使用一个“拖放”式的网站创建平台时，就更顾及不到。我并不是反对那些平台，只不过它们常常不会内置可访问性功能，即便你有意愿，要做到这点也十分困难。

对网站可访问性不利的另一个方面是，当你说出“可访问性”这个词时，并非每个人都对其意味着什么有个清楚的概念。最近我曾询问过一位网站设计师是否做了可访问性站点的工作，然后他说，“是的…… 我们为所有图片增添了 `alt` 属性。”嗯…… OK。很棒。但一个屏幕阅读器能读出你的网站吗？

那么，接下来让我们消除一些谬误，并深入理解一下实现 web 可访问性意味着什么吧。

首先很重要的一点是，美国实际上拥有非常明确的针对可访问性的立法。在这部被称为美国残疾人法（Americans with Disabilities Act）的法案中，也涉及到了网站。美国公司应该意识到，业务网站若是连最低限度的可访问性都没达到，公司是会面临法律诉讼和罚款的。我是一名在加拿大注册的公司内工作的加拿大人，所以实际上我并不用真的担心因为缺乏一个可访问的网站而被起诉，但我还真额外的有一个可访问性网站！下面，我将解释拥有一个可访问的网站的益处，而这无关乎你是否在一家美国公司工作。

当人们担忧创建一个可访问网站的麻烦或其潜在成本时，不如提醒自己看看这篇文章： [可访问性会造福每个人](https://medium.com/@kbronjohn_2775/accessibility-makes-everyones-life-easier-98af7efaea4e)。如果我们追根溯源，就会知道 22% 的加拿大人都有某类缺陷（美国则是 18%），用不着做数学计算，就能知道那是很多的人。**很多想线上购物、购买你的商品、了解你的服务，或学习你的在线课程的人**。早在疫情的数年之前，残障人士就已经能够上网、打破隔离，并远程工作了。这对于我们来说并不新鲜。所以，既然如今的疫情封锁让每个人都对呆在家里有了一些了解（大量的线上购物、线上教育研讨会、艺术和娱乐活动），也许我们都能认识到，能够轻松访问网络是多么重要。

正如我所说，可访问性让每个人的生活更便利，并且如果你已经尝试为此做一个商业案例，你并不只是为人口的 18-22% 创建一个网站；而应该着眼全部人口。**你想限制你能吸引的潜在消费者的数量吗？** 这就像是有个商店，而老板在说：“我真的不想让人们进来并在这儿购物。他们应该去我的竞争对手那”。权力在于你，业务也在于你，企业当然有许多理由让他们从一开始就过滤部分客户。**但是，我此刻强调的是，你已无意中为那些本来是你的目标客户的人设置了障碍，把他们拒之门外了**。

了解了上述这些事情后，让我们来看看 web 可访问性到底需要什么。所有这些都可以归结为用户体验问题，毕竟你想让每一位用户对你的品牌有最好和最积极的体验。

以**最低要求**来衡量，要做到可访问，网站访问者应该能够做到下面这些关键的事情：

* 用他们更喜欢的语言浏览你的网站
* 更改字体样式或字号
* 更改背景对比度
* 使用一个屏幕阅读器导航站点
* 不用鼠标就能导航站点
* 停止/关闭任何音乐、视频，或图片轮播
* 在点击一条链接之前就了解其包含了什么
* 站点中包含的任何视频都有字幕
* 在图片或图标上获得准确并相关的图像描述
* 在任何图表或关键的图片上有适合色盲症的配色

这只是个开始，但应该成为一个好的起点。在这之后，仍要首先考虑终端用户，并认识到他们有各自不同的需求。**同时，由真实的人群测试你的站点**（向其付费）。是的，你可以借助模拟器，也可以借助部分输入你网站的 URL 后就能给你评分的站点，但只有来自真实用户的真实反馈才会带给你宝贵的、甚至是无价的见解。从来自不同年龄层、有着不同缺陷、背景各异的目标人群中收集意见并认真研究。我保证你可以打造杰出的体验，并为你的品牌赢得一个好名声。

更不必说，如果你的站点拥有清晰且易用的导航，搜索引擎会将其排名提得更高。对用户友好的事情之于搜索引擎程序也是友好的。这是个双赢之事！

将 web 可访问性视为吸引新客户、建立新关系、使客户满意，和增加盈利之门。同时，这也是正确的应做之事。

> 作者为 [**Completely Inclusive**](https://compinclus.ca/) 的创始人，这是一家致力于帮助企业创造包容性和无障碍的工作场所和空间的咨询公司。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
