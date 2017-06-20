> * 原文地址：[Messaging Sync — Scaling Mobile Messaging at Airbnb](https://medium.com/airbnb-engineering/messaging-sync-scaling-mobile-messaging-at-airbnb-659142036f06)
> * 原文作者：[Zhiyao Wang](https://medium.com/@zhiyaowang), [Michelle Leon](https://medium.com/@mkleon) , [Jason Goodman](https://medium.com/@jasonkgoodman) , [Nick Reynolds](https://medium.com/@thenickreynolds) , [Julia Fu](https://medium.com/@chengxiaofu) , [Jeff Hodnett](http://www.jeffhodnett.com/) , [Manuel Deschamps](https://medium.com/@manuel) , [John Pottebaum](https://medium.com/@johnpottebaum), Charlie Jiang
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Tuccuay](https://www.tuccuay.com)
> * 校对者：[ZhangRuixiang](https://github.com/ZhangRuixiang) , [zhangqippp](https://github.com/zhangqippp)

# 消息同步 —— 在 Airbnb 我们是怎样扩展移动消息的

![弱网环境下的新旧收件箱对比](https://cdn-images-1.medium.com/max/800/1*fZpQ95jk81Ae7tqpkXNIwA.gif)

随着从移动端发出的消息条数超过每小时 100k，消息传递成为了 Airbnb 应用中被使用得最频繁的功能，但是我们之前用在移动版收件箱中获取消息的方法缓慢且不能保证数据的一致性，必须要有网络连接才能阅读消息。这些原因导致了移动版收件箱的房东和游客的体验都不太好。为了让收件箱更快、更可靠、更一致，我们在 Airbnb 中构建了消息同步机制。

旧版收件箱的实现方式类似于上世纪末的邮箱客户端，用户每点击一次，就网络加载一次，从而获取需要展示的消息。通过消息同步，只有当数据改变时才会更新消息内容和消息列表，从而大大减少了网络请求的数量。这意味着在收件箱和消息列表之间来回切换导航的速度快了很多，大部分时间都是用本地缓存来展示数据，而不再需要在进入每个界面的时候都发起网络请求。消息同步还减少了每个网络请求的响应大小，从而使 API 的响应速度提升了两倍之多。这些体验优化在网速较慢的地区尤为明显。

以下为消息同步的工作方式，分三种情况：

**情景 1： 全幅增量更新**

![](https://cdn-images-1.medium.com/max/800/1*RqXfpzXiZ2nudOrEPA7Dvg.png)

常见的情景是这样的：

1. 移动客户端使用本地存储的 `sequence_id` （比如 1490000000，表示客户端上一次与服务器同步的时间）请求同步。
2. API 服务器只返回所有已修改的消息对象和新的消息并附带一个新的 `sequence_id` （比如 1491111111）。
3. 移动客户端将这些被修改的消息和新的消息和本地数据库合并。
4. 移动客户端还要存储新的 `sequence_id` 以供下次使用。

**情景 2：初始化同步**

这是在有大量的消息更新需要返回时的方案。比如当用户首次下载 app 的时候，服务器需要发送 10 个会话对象和 30 个消息以进行全增量更新。完整的增量同步响应体将会非常巨大，这将导致更长的加载时间和更差的用户体验。所以这个时候，我们只返回当前屏幕需要展示的会话。

![](https://cdn-images-1.medium.com/max/800/1*0NQo4EQtq4A6ZcD0I-FGCQ.png)

1. 移动客户端使用本地存储的 `sequene_id` 来调用同步 API。
2. API 服务器估计完全增量同步的响应体大小，并且判断觉得它太大了。
3. API 服务器仅返回最新 N 个会话对象，足够客户端渲染整个屏幕而没有空白。
4. 客户端清除本地的数据库。
5. 客户端存储最新的消息和 `sequence_id`。
6. 当用户打开会话时，客户端会向服务器请求这个会话的所有消息。
7. 当用户在收件箱中浏览历史记录时，客户端会发送分页请求来获取会话的消息。

**情景 3：删除会话**

会话有时候会需要从应用中移除。比如当房东搭档不再管理这个房子的时候，服务器将删除房东搭档和房客之间的会话。在这种情况 API 会在最后一次同步时发送包含所有需要删除的会话 ID 数组。

### 回归测试

当迁移到新的消息同步 API 的时候，有几个需要注意的点：

1. Airbnb 的消息系统与核心的预定流程及其它产品逻辑紧密结合。服务器需要监听那些会影响数据在屏幕上显示的变动。比如当行程完成后，应用需要在会话中显示「评价」按钮。我们当时有两种方案可选：一个是在阅读消息的时候检查评论对象是否被修改；另一个是订阅评论对象的状态并在下一次读取会话消息的时候改变它。我们选择了第二种方案，因为这种方案节省资源。但是，监控这些能影响 UI 改变的对象，是一个挑战。

2. 更新后的会话可能和本地存储的会话有不同的顺序。我们需要确保在合并数据后能够正确的刷新 UI。

为了抓取在旧的消息 API 和新的消息同步 API 返回的数据之间的差异，一小部分应用同时运行新旧两套 API 进行抽查。它记录两套 API 返回的会话中所有的属性值和会话顺序。这允许我们对新的 API 回归测试并进行快速迭代。每当遇到一个 bug 时，服务器会将会话对象标记为已修改，以便在下一次同步时纠正错误。

### 结论

1. 消息同步 API 将请求的延迟减少了一半。相对于旧的API（下面突出的蓝线），新的API的网络请求更加稳定。

![](https://cdn-images-1.medium.com/max/800/1*SbTsdzUkh9miVCbZScBKCQ.png)

2. 消息同步使用户能够在飞行模式或者网络状况不佳的情况下阅读消息。

在推出消息同步和其他关于消息的改进之后，我们看到更多的消息从手机上发送了（在 Android 和 iOS 上分别是 +3.8% 和 +5.3%），从网页上发送的消息变少了（-4.6% 和 -4.2%）。并且每天查看收件箱的次数也提升了（+200% 和 +96%），因为它现在是房东的首页。这个发布对于我们房东社区来说是一个非常巨大的胜利，因为消息是房东在 Airbnb 上最常用的功能。

**最后说一下，如果你有兴趣创造一个蓬勃发展的社区，在世界各地款待大家，Host & Homes 团队正在招募工程师** [**寻找有才华的人加入**](https://www.airbnb.com/careers/departments/engineering)！

![](https://cdn-images-1.medium.com/max/2000/1*XMOMFask2IOSeOQznGLe7Q.png)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
