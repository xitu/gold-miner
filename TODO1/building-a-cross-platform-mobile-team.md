> * 原文地址：[Building a Cross-Platform Mobile Team: Adapting mobile for a world with React Native](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)
> * 原文作者：[Gabriel Peal](https://medium.com/@gpeal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-cross-platform-mobile-team.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-cross-platform-mobile-team.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：

# 建立一个跨平台的移动端团队

## 使用 React Native 适应移动端

![](https://cdn-images-1.medium.com/max/2000/1*3WNSZyXGOWKJyPT9r8VY8Q.jpeg)

**这是[系列博客文章](https://juejin.im/post/5b2c924ff265da59a401f050)中的第三篇，本文将会概述使用 React Native 的经验，以及 Airbnb 移动端接下来要做的事情。**

除了 React Native 数不清的技术优势和缺陷之外，我们还了解到 React Native 对于一个工程组织意味着什么。采用它比在现有平台添加新库或模式要复杂得多。这同时也带来了一些组织上的挑战。与通常可以有效解决的技术挑战不同，组织上的挑战更难以发现，纠正和恢复。不过值得庆幸的是，我们的手机文化是健康的，但在考虑 React Native 时有很多事情需要注意。

#### React Native 呈现出两极化

根据我们的经验，工程师们在刚接触 React Native 时候，提出了截然不同的观点，从赞扬它将会成为集 Android、iOS 和 Web 的高招，到完全反对任何在团队中使用 React Native。在正式投入使用了之后也是这样的情况。一些团队有着令人难以置信的经历，而其他团队则为此后悔不已，并重回原生的怀抱。

#### 根本原因

在使用 React Native 时，存在一些不可避免的错误，改进和性能问题。但是，有很多动人的东西：

1.  React Native 本身迭代速度很快。
2.  我们可以同时进行基础架构和功能的开发。
3.  工程师们可以一起学习 React Native，这门语言对每个人相对来说都是比较新的。
4.  我们在开发和正式生产环境中进行调试的文档和指南有时不一致，可能会造成混淆。

因此，通常很难找到问题的根本原因。有时候，不清楚问题出在哪个团队，或者这个问题是不是 React Native 固有的问题。

#### React Native 仍然需要原生

一个常见的误解是，React Native 允许你完全不用编写原生代码。然而，事情并不是这样的。React Native 的原生基础有时还会继续向前发展。例如，每个平台上的文本渲染略有不同，键盘处理方式不同，并且默认情况下在 Android 上旋转时重新创建 Activity。一个高质量的 React Native 体验，需要仔细地保持不同平台的平衡。再加上，开发者难以精通三种平台上的专业知识，因此在开发中始终难以实现优质体验。

#### 跨平台调试

大多数工程师都能精通一或两个平台。很少有人能同时精通 Android、iOS 和 React。尽管成熟的 React Native 环境中，绝大多数工作都是通过 JavaScript 和 React 完成的，但有时构建或调试某些东西需要钻研原生的东西。这些情况可能导致工程师在他们从未使用过的平台上调试时，陷入专业知识之外困境。更糟糕的是，由于根本原因难以确定，工程师甚至不确定往什么方向定位问题。

#### 持续招聘

尽管我们投入使用 React Native，但我们移动端的野心和团队仍在同步扩大。然而，通过社区口碑，许多人开始将 Airbnb 与 React Native 联系起来，甚至有人认为我们的应用是 100％ React Native。尽管事实远非如此，但许多 Android 和 iOS 工程师也因此不愿意申请来 Airbnb。以防你是其中之一，[我们还在招人呢](https://www.airbnb.com/careers/departments/engineering)！

#### 混合应用很难实现

100％ 原生或 100％ React Native 的路相对简单。但是，一旦你在代码库中混合使用了，就会出现许多新问题。你如何分配你的团队？团队如何协作？如何在你的应用中共享状态？如何确保代码得到测试？工程师如何在三个平台上进行有效调试？如何决定使用哪个平台来实现新功能？如何在整个组织中聘用和分配资源？这些都是非常重要的需要解决方案的问题，如果你沿着这条路一直走下去，就不可避免地会出现这些问题。

#### 三种开发环境

为了成为一名高效率的 React Native 工程师，拥有稳定且最新的 React Native、Android 和 iOS 环境非常重要。对于像 Airbnb 这样大的组织来说，每个平台都需要大量时间来配置，学习并保持最新状态。短短几周后，常常意味着要花费几个小时，才能使所有东西都恢复到最新状态。

#### Balancing Native vs React Native

在许多情况下，问题的最佳解决方案需要跨越原生和 React Native。例如，我们导航的实现大量使用 Activity 和 ViewController，其大部分代码都是原生的，适用于每个平台。但很多时候，不清楚代码是否应该用原生或 React Native 编写。当然，工程师通常会选择他们更舒适的平台，但是这可能导致代码不合理。

#### 跨平台测试

我们发现，由于方便或舒适，工程师主要在一个平台上进行开发。通常，他们会假设如果它在他们测试的平台上正常工作，那么它在全平台同理也能完美运行。大多数情况下，这证明了 React Native 强大。然而，这往往不是真实的情况，它最终会导致在 QA 周期的后期或生产环境中频繁发生问题。

#### 拆分

在原生以及 React Native 工作的团队，经常面临技术和沟通方面的挑战。一旦代码库在原生和 React Native 之间拆分，代码就会变得支离破碎。共享业务逻辑、模型、状态等变成更具挑战性的难题，工程师不再具备在整个流程中工作的专业知识。我们知道，这个问题从一开始就存在，但认为可能会通过与 Web 的更多合作来平衡。一些团队确实开始通过 Web 和移动设备共享资源和代码，但是大多数团队没有意识到这一潜在的好处。

#### 感知迭代速度

我们使用 React Native 的质量目标之一，就是提高开发速度。通常，React Native 的功能是由单个工程师编写的，而不是针对每个平台编写的。从 React Native 工程师的角度来看，如果他们比在 Android 或 iOS 上花费的时间多 50％，即使总体的花费的时间更少，他们也会觉得花费的时间更长。

#### 公共资源和文件

Android 和 iOS 已有十年的时间了，有数百万的工程师为学习资源、开源和在线帮助都贡献了不少力量。我们利用 [CodePath](https://codepath.com/androidbootcamp) 等许多资源来帮助人们学习 Android 和 iOS。尽管 React Native 拥有最大的跨平台社区之一，并且可以利用 React 资源，但它相比 Android 和 iOS 还小得多。再加上我们必须在内部建设大部分基础架构，这一事实意味着，相对于原生资源，我们有限的原生资源在教育和培训上会投入过大。

* * *

这是系列博客文章的第三部分，重点讲述了我们使用 React Native 的经验，以及 Airbnb 移动端接下来要做的事情。
 
 *   [第一部分：Airbnb 中的 React Native](https://juejin.im/post/5b2c924ff265da59a401f050)
 *   [第二部分：技术细节](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838)
 *   [**第三部分：构建跨平台的移动端团队**](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)
 *   [第四部分：在 React Native 上作出的决策](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a)
 *   [第五部分：移动端接下来的事情](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)
    
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
