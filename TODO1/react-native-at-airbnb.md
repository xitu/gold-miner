> * 原文地址：[React Native at Airbnb](https://medium.com/airbnb-engineering/react-native-at-airbnb-f95aa460be1c)
> * 原文作者：[Gabriel Peal](https://medium.com/@gpeal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-at-airbnb.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-at-airbnb.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：

# Airbnb 中的 React Native

## 在 2016 年，我们在 React Native 下了一个大赌注。两年后，我们准备与大家分享我们的经验并展示未来会怎样。

![](https://cdn-images-1.medium.com/max/2000/1*P9Kc_EWojKpqfc1-_AhnSg.jpeg)

多年以后，我们仍然可以在 Airstream 预订一次会议

**这是我们系列博客文章中的第一篇，其中概述了我们在 React Native 这方面的经验以及 Airbnb 移动端以后会发展成什么样子。**

当 Airbnb 在 10 年前推出时，智能手机还处于萌芽阶段。自那以来，智能手机已成为驾驭日常生活的一个重要工具，尤其是现在随着越来越多的人开始周游世界。作为一个能够为数百万人提供新形式旅行的社区，拥有一个世界级的应用显得至关重要。因为移动设备通常是旅行者们远离家时的主要或唯一的通信形式。

自 2008 年我们的前三名客人入住 Rausch 街以来，移动端用户的预定量每年从零增长到数百万。我们的应用让房东能够在行程中管理他们的房源，同时也为旅客提供灵感，用手指轻轻一点就能发现新的地方和体验。

为了跟上移动应用的加速步伐，我们已经将团队扩展到 100 多名移动工程师，以实现新的体验并改进现有的工作。

### 在 React Native 下赌注

我们不断评估新技术，使我们能够改善客人和房东在使用 Airbnb 时的体验，能够响应迅速的同时，保持良好的开发者体验。在 2016 年，其中一项技术就是 React Native。那时候，我们意识到移动对我们业务的重要性，但是却没有足够的移动工程师来完成我们的目标。因此，我们开始探索替代方案。我们的网站主要是由 React 构建的。在 Airbnb，它一直个是非常有效和普遍受欢迎的 Web 框架。因此，我们将 React Native 视为一个机会，通过利用其跨平台的特性，向更多工程师开放移动开发，并更快地发布代码。

当我们最初决定开始投资 React Native 时，也知道存在一些风险。我们需要为代码库添加一个新的、快速移动且未经验证的平台。该平台有可能对代码库进行分割，而不是统一。我们也知道，如果要使用 React Native，就像把它做好。我们的目标是：

1.  作为一个组织，允许我们**快速行动**。
2.  保持原生的**质量标准**。
3.  为移动端编写**一次**产品代码，而不是**两次**。
4.  改善**开发人员的体验**。

### 我们的经验

在过去的两年中，在这个实验上下了不少苦功夫。我们已经在应用中构建了一个令人难以置信的强大集成，实现了复杂的本地功能，如共享元素转换，视差和地理位置以及与我们现有的本地基础架构（如网络，实验和国际化）桥接。

我们使用 React Native 为 Airbnb 推出了一系列关键产品。React Native 使我们能够推出更多[体验活动](https://www.airbnb.com/s/experiences)，这是针对 Airbnb 的一项全新业务，从评论到礼品卡的数十项新功能。这些功能都是在我们没有足够的工程师来完成目标的时候构建的。

不同的团队对 React Native 都有丰富的经验。React Native 在其他方面提出技术和组织方面的挑战，有时会被证明是一种令人难以置信的工具。在本系列中，我们详细介绍了我们的经验以及接下来要做的事情。

[在第二部分](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838)我们列举了 React Native 作为一项技术的有效性和缺陷。

[在第三部分](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)，我们列举了与构建跨平台移动团队相关的一些组织挑战。

[在第四部分](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a)，我们重点介绍了我们今天与 React Native 的立场以及它在 Airbnb 中的未来。

[在第五部分](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)，我们会谈到从 React Native 中学到的最重要的知识，并利用它们使得原生表现地更好。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
