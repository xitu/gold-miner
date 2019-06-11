> * 原文地址：[Discovery in the age of abundant video](https://medium.com/googleplaydev/discovery-in-the-age-of-abundant-video-294b1e3fe7c4)
> * 原文作者：[Albert Reynaud](https://medium.com/@Reynaud_10696?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/discovery-in-the-age-of-abundant-video.md](https://github.com/xitu/gold-miner/blob/master/TODO1/discovery-in-the-age-of-abundant-video.md)
> * 译者：[Yuhanlolo](https://github.com/Yuhanlolo)
> * 校对者：[DateBro](https://github.com/DateBro)

# 海量视频时代下的内容发现之旅

## 提升内容发现平台上用户体验的关键因素

![](https://cdn-images-1.medium.com/max/1600/0*Z4o0cUjhfdNMRrOd.)

如今在互联网上，人们可以接触到海量的视频信息，[而提供这些视频的平台数量已经超过五年前的两倍](https://www.ericsson.com/en/trends-and-insights/consumerlab/consumer-insights/reports/tv-and-media-2017)。因此，人们往往需要花费更多的时间和精力（[+13% YoY](https://www.ericsson.com/en/trends-and-insights/consumerlab/consumer-insights/reports/tv-and-media-2017)）去搜索自己感兴趣的内容。

![](https://cdn-images-1.medium.com/max/1600/0*enf33FQyYbhzNvV2.)

对于大部分内容创作者而言，随着许多开放式（“OTT”）平台的激增以及新型消费习惯的形成，建立平台对用户的粘性越来越具有挑战性。而具备让用户能够在各种情景下畅行无阻地享受视频探索过程的能力，很大程度上可以保证这些平台的成功。

在这篇文章里，我将分享我在欧洲各个媒体平台的工作经历中收集到的关于内容发现的一些干货以及实际操作。由于谷歌是用户进入你的应用或者网站的基本途径，我将集中讨论用户进入你的应用之后的发现过程。

### 决定如何评估成功

![](https://cdn-images-1.medium.com/max/1600/0*kdOZRPISbF-SyFvm.)

让我们先来谈谈发现！但是等等，我们应该如何评估用户的发现之旅是否成功呢？

无需强调选择正确的 KPI 对于评估内容发现实验的重要性。有意思的是，无论你是否使用视频订阅（“SVOD”）、投放广告（“AVOD”），或者商业传播的服务，这些 KPI 在不同情景下会非常不一样。下面是一些通过 KPI 来评估用户在内容发现平台上的体验的常见例子：  

*   视频观看时间及次数
*   每周平均回放次数，播放完成次数
*   会话（session）数量及时长
*   来自推荐引擎的会话（session）和回放数量所占的百分比

这些短期 KPI 的潜在问题在于，过度地关注它们反而会导致你偏离原本的长期的商业目标。比如说，你可以通过推荐低质量的轰动性内容增加播放量，但从长远来看，这样做会影响平台的形象以及用户的忠诚度。

因此，我推荐采用短期 KPI 和 长期 KPI 结合的方式，比如说 **订阅人数或 30 天之内的用户留存率。** 虽然这比 A/B test 更加困难, 但它可以保证你为用户所提供的体验与你的长期商业目标是一致的。

### 为你的推荐引擎选择正确的燃料

![](https://cdn-images-1.medium.com/max/1600/0*pXKT80eUkgEbBk-7.)

当推荐引擎变得更聪明的时候，它们毫无疑问地将在用户对平台内容的认知里扮演越来越重要的角色。它们贯穿于整个媒体平台，从动态排序，语义搜索，到集合聚类。

许多系统在使用基本的推荐引擎时取得了一些成功。然而，越来越多的内容提供者正在为他们的推荐系统寻找更复杂的方法，比如：    

*   **合作式过滤：** 通过其他相似用户的喜好以及用户之间的相似程度预测某个用户的喜好。
*   **基于内容的过滤：** 为用户推荐与他们过去喜欢的内容特性相似的内容。

但是你不能期待算法为你实现所有的事情。找到算法与长期目标之间的平衡比它看起来要复杂得多：

*   **间接反馈与直接反馈：** 如何解释间接反馈呢？用户的什么行为需要被考虑：点击视频，完成回放？如何简化直接反馈呢：评分，点赞等等？最近升级的 Play Movies & TV 是一个典型的例子。我们添加了喜欢和不喜欢的按钮作为直接反馈，并且将该反馈加入推荐算法中 — 这里有一个 16 秒的示例 [video](https://www.youtube.com/watch?v=smc80kgmZ8k&feature=youtu.be&t=16s)。
*   **手动编辑与自动化：** 如何保持由你的品牌和配置组成的人类推荐呢？内容发现解决方案提供商 [CogniK](https://www.cognik.net/discovery-recommendations/) 推荐通过编辑部门提供的内容列表来改进推荐引擎。类似地，编辑部门可以通过增加特定内容或是分类的权重来控制推荐引擎的某些参数。
*   **实时推荐与按需推荐：** 何时需要考虑其中实时推荐多于按需推荐，或是按需推荐多于实时推荐呢？如何在不让用户感到疑惑的情况下将这两者结合呢？
*   **流行程度与新颖程度：** 如何推荐新的和未知的内容，并且避免回声效应呢？如果应用界面与流行趋势不相悖的话，基于合作式过滤的推荐通常会与趋向于当下流行的内容，那么如何平衡意外发现新奇内容的几率和推荐内容的相似程度呢？根据用户在平台停留的时长，一些内容提供者倾向于提高用户意外发现新奇内容的几率。

### 在更广的情景下丰富你的推荐系统

![](https://cdn-images-1.medium.com/max/1600/0*bSqwlsJr9xRmtE3b.)

在一些场景下，个性化要么是不可能（比如初次使用你的平台的用户），要么是不完备的。你也许需要通过其他外部信息来丰富用户体验。

考虑其他因素诸如 **时间**（工作日和周末, 一天中的时间等等），或者 **地点**（突出当地的新闻或频道，运动队等等）是现在媒体和娱乐平台上比较常见的。类似地，内容提供者们倾向于通过 **形态系数**，即人们大多更喜欢在手机上观看短视频，在大屏幕上观看长视频，来调整视频的时长和类别。

最近，我看到越来越多的平台利用 **流行话题** 和即将到来的事件，为他们的推荐系统增加信息流和精选（大选，头条，运动新闻等等）。

### 适应用户的期望和心态

![](https://cdn-images-1.medium.com/max/1600/0*mz0_hVhri9mnMHqI.)

作为一个媒体平台，你应该做好服务于用户各种可能的意图的准备。

其中一个办法是根据目标用户犹豫不决的程度，让你所设计的用户体验能够适应不同的寻找视频观看的行为。由于受到一系列外界因素的影响（和谁一起观看、可以观看的时间、观看的动机、心情等等），你的目标用户也许会用完全不一样的方式去打开他们想要观看的视频。基于之前的研究，Google Play 的电影产品部门使用了一个框架，该框架将用户决定观看某个视频时的操作方式分类成 4 种形式：**搜索、选择、浏览，或者冲浪**。也就是说，你的用户体验应当在 **“特定范畴”** 内涉及每一种形式。

![](https://cdn-images-1.medium.com/max/1600/0*vuY5zE6OLPbnWO5G.)

来源：Google Play 电影研究

同样地，一些内容提供者例如 [Spideo](http://spideo.tv/en/mood-based-discovery/) 正在尝试通过关键词和愿望清单捕捉用户的 **心情**，从而在特定时间为他们推荐合适的内容。

![](https://cdn-images-1.medium.com/max/1600/0*bbcv1sLpaPG5JA-8.)

来源：[Spideo](http://spideo.tv/en/)

虽然让你的内容发现平台适用于用户所有可能的意图是非常困难的，为了让产品团队更好地了解相关信息，通过 **用户画像** 定义典型的目标用户是很有帮助的。通过实验数据，用户的思维方式、需求，以及用户细分的目标组成了用户画像。[通过综合数据分析进一步发现绘制用户画像的最佳实践](https://research.google.com/pubs/pub44167.html)。

![](https://cdn-images-1.medium.com/max/1600/0*x08S8A8z7h-BIN4B.)

来源：Luma Institute

以下是一些我想到的媒体用户画像的示例：坐在沙发上看电视的人、经常跳转屏幕的人、看电视没有节制的的人、运动迷，用电脑看视频的人等等。

### 促进日常行为养成

![](https://cdn-images-1.medium.com/max/1600/0*XGPPuhAGqBeEKFWx.)

与其让人们每次一打开你的平台就进入完全的探索发现之旅，不如帮助他们改善经常从事的事情。

通常来说，一些用户细分例如看周末精选的足球迷、看晨间新闻的人，或者在周六晚上看电影的人，他们的行为模式都可以轻易被平台所支持。其中一些目标用户甚至可能不会意识到他们自身的行为模式从而感激你能够预计他们的偏好。

另一个为用户习惯设计体验的很棒的例子是 [Spotify](https://play.google.com/store/apps/details?id=com.spotify.music&hl=en) 的“每周发现”播放列表，这是一个对所有用户开放的个性化的播放列表，让用户在一周内能够发现并享受新的内容。

### 一个舒适的背靠式观影体验

![](https://cdn-images-1.medium.com/max/1600/0*l41zSwlD0gkObg18.)

根据 Ericsson ConsumerLab 的调查，电视台直播和线性录播的节目仍然占据了 58% 的活跃播放时长。虽然年轻一代的观众越来越倾向于点播，大部分人仍旧喜欢意外发现新奇内容的经历和观看录播的电视节目，并且他们会继续寻找一个更加舒适的背靠式观影的体验。

为了重新创建背靠式观影的优势，许多点播服务开始提供为用户提供微交互的方式（例如，来自 [Deezer](https://youtu.be/ykbaMNaGLgc) 的 Flow），让用户可以非常容易地根据自己的喜好打开和调整节目。观众们将会期待更多的背靠式观影体验、原谅那些不够准确的信息，以及要求透明度和播放控制权。

也有其他可以将这种流程带入发现体验的方法。一些例如自动播放的功能已经被大部分平台使用了。除此之外，我也看到了许多很棒的功能，比如说[**子母画面**](https://developer.android.com/guide/topics/ui/picture-in-picture.html)，或者“集中注意力的时候开始播放”。以上所有的功能都参与了在点播平台上重建线性节目。

### 辅助决定

![](https://cdn-images-1.medium.com/max/1600/0*lnTXJY_3Rgi_k8w3.)

对于产品团队来说，尽可能多地将各种信息和平台内容联系起来是一件很吸引人的事情，他们认为这样可以帮助用户更好地作出决定。然而，一系列信息比如标题，描述，分类，价格，评分，预告等等，很快地让用户信息过载，从而导致他们进入一个 **“决定无能”** 的状态。

我们常说：“一图胜千言”，因此，现今许多平台都投入了越来越多的时间去为优化内容的视觉效果。用户研究同时也可以帮助你区别“最关键的”的信息和“重要的”，或者是“加分的”信息，从而决定相应的优先权。

另一个常见的方法是只在用户有需求或是有兴趣的情况下才显示额外的信息，以此来简化用户体验。用户的兴趣通常表现为：点击，光标集中等等 — 这里有一个 37 秒的视频例子 [video](https://www.youtube.com/watch?v=smc80kgmZ8k&feature=youtu.be&t=37s)/s。

最后，你可以考虑为你的标题 **插入编者意见**，从而让他们比起简单的标题更有可读性。通过强调运动节目的情景，故事的含义，电视节目的精选，或者新剧集放送，在发现体验中用户将更容易感受到他们自己与内容的关联。

* * *

希望这些建议能够帮助你定义和优化你的平台内容以及取悦你的用户 — 无论你是通过更好的目标定位，优化推荐引擎从而加速内容可见度，提高对用户的理解，还是预测他们的行为和在不同时间地方的喜好。

### 你怎么看？

你对媒体平台上的内容发现有什么想法吗？请在下面留言或者用通过 **#AskPlayDev** 的标签在 tweet 上告诉我们。我们将会通过 [@GooglePlayDev](http://twitter.com/googleplaydev) 这个邮箱地址回复你，这也是也是我们通常用来分享如何让 Google Play 变得更好的新闻和意见的邮箱。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
