> * 原文地址：[Introducing AloeStackView for iOS](https://medium.com/airbnb-engineering/introducing-aloestackview-for-ios-a676d253c6ba)
> * 原文作者：[Marli Oshlack](https://medium.com/@marli.oshlack?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-aloestackview-for-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-aloestackview-for-ios.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[Weslie](https://github.com/iWeslie)

# 介绍适用于 iOS 的 AloeStackView

一个简单的开源类，通过一些方便的 API 来对视图集合进行布局。

![](https://cdn-images-1.medium.com/max/1000/1*vSbYW1xdhd0x9gXKJZDvYA.png)

在 Airbnb iOS APP 中，大约有 200 个页面是通过使用 AloeStackView 构建的。

在 Airbnb，我们一直在寻找提高构建产品效率的方法。

在过去几年中，我们的移动开发工作以惊人的速度增长。仅在过去一年中，我们就已经为我们的 iOS 应用添加了超过 260 个页面。与此同时，越来越多的人开始使用我们的原生移动应用程序。这种趋势没有显示出放缓的迹象。

大约两年前，我们详尽讨论了我们在 iOS 上如何构建产品，看看是否有提高开发效率的空间。我们发现的一个主要问题是，在我们的 iOS 应用中实现一个新的页面需要花费数天甚至数周的开发时间。

所以我们要着手改变这一点。我们希望找到一个尽可能比我们想象的还要快的方法来构建页面。我们希望工程师能够在在几分钟或几小时内为 iOS 应用添加新页面，而不是数天或数周的时间。

在过去两年中，我们在快速构建高质量的 iOS UI 方面吸取了许多教训。

基于其中的一些知识，我们今天非常兴奋地介绍我们在 Airbnb 开发过程中的一种工具，以帮助您快速，轻松，高效地编写 iOS UI。

### AloeStackView 简介

在 Airbnb，我们从 2016 年开始在我们的 iOS 应用程序中使用 [AloeStackView](https://github.com/airbnb/AloeStackView)，并且已经使用它在应用程序中实现了近 200 个页面。用例非常多样化：从设置页面的使用到创建新的列表，再到列表状的操作弹层(例如 UIActionSheet)。

AloeStackView 是一个允许在垂直列表中布局视图集合的类。从广义上讲，它类似于 UITableView，但它的实现是完全不同的，它做了不同的权衡取舍。

AloeStackView 首先着重于使 UI 非常快速，简单和直接实现。它以以下两种方式来实现这一点:

*   它利用自动布局的强大功能在更改视图时自动更新 UI。
*   它放弃了 UITableView 的一些功能，例如视图回收，以实现更简单，更安全的 API。

### 简化 iOS UI 开发

当我们研究如何提高 iOS 开发效率时，我们意识到的第一件事就是在应用程序中实现最小的页面需要做多少工作。

事实证明，引入了设计用于处理大型和复杂页面的抽象，有时会成为较小页面的负担。

通常，较小的页面不会受益于这些抽象提供的优点。例如，如果 UI 完全适合单个页面，那么它将不会从视图回收中受益。显然，如果我们使用围绕视图回收的抽象来构建单个页面，那么我们必须要为这个功能增加的 API 复杂性付出代价。

为了解决这个问题，我们首先寻找更简单的方法来编写页面。我们发现的一种非常有效的技术是使用嵌套在 UIScrollView 中的 UIStackView 来布局页面。这种方法成为我们构建 AloeStackView 的基础。

是什么让这项技术非常有用？是它允许您随时保持对视图的强引用并动态更改其属性，而自动布局会自动使 UI 保持最新。

在 Airbnb，我们发现这种技术非常适合接受用户输入的页面，例如表格。在这些情况下，保持对用户正在编辑的字段的强引用通常很方便，并直接使用验证反馈更新 UI。

我们发现这种技术另一个有用的地方是在由不同视图组成的较小页面上，少于一两个内容。简单地以简单的方式在 UI 中声明视图列表通常可以更快，更轻松地实现这些屏幕。

在实践中，我们发现 iOS 应用程序中的大量的页面属于这些类别。AloeStackView 简单灵活的 API 使我们能够快速，轻松地构建多个页面，使其成为我们工具箱中的有用工具。

### 减少 Bug

我们提高开发人员效率的另一种方法是专注于使 iOS UI 开发能更容易的正确完成。AloeStackView API 的主要目标是通过设计确保安全性，以便工程师花费更多时间来构建产品，减少跟踪 Bug 的时间。

AloeStackView 没有 reloadData 方法，或其他任何方式通知它更改有关视图。这使得它比像 UITableView 这样的类更不容易出错且更容易调试。例如，AloeStackView 永远不会因为对其管理的视图的基础数据的更改导致崩溃。

由于 AloeStackView 底层使用了 UIStackView，因此在滚动时它不会回收视图。这消除了因未正确回收视图而导致的常见错误。 它还提供了额外的优点，即当用户与它们交互时不需要独立地维护视图状态。这可以使一些UI更容易实现，并减少错误可能蔓延的表面区域。

### 权衡利弊

虽然 AloeStackView 既方便又实用，但我们发现它并不适合所有的情况。

例如，AloeStackView 在您加载屏幕时一次性布局整个 UI。因此，较长的屏幕会在 UI 首次显示之前看到延迟。 因此，AloeStackView 更适合用少于一两个内容来实现的 UI。

放弃视图回收机制也是一种权衡：虽然 AloeStackView 编写 UI 的速度更快，而且不容易出错，但是它的性能不佳，并且对更长的页面来说，会比 UITableView 这样的类使用更多的内存。 因此，像 UITableView 和 UICollectionView 这样的类仍然是展示包含许多相同类型视图的页面的良好选择，它们都展示相似了的数据。

尽管有这些限制，我们发现AloeStackView非常适合大量的用例。事实证明，AloeStackView 在实现 UI 方面非常高效和高效，并帮助我们实现了提高 iOS 开发效率的目标。

### 保持代码可管理性

经常引入第三方依赖会导致的一个问题是二进制包大小的增加。这正是我们想用 AloeStackView 避免的。整个库少于 500 行代码，没有外部依赖，这使二进制包大小的增加最小。

少量代码除了占用空间少以外也有其他方面的帮助：它使库更易于理解，更快地集成到现有应用程序中，无需调试，也更容易做出贡献。

另一个问题是，有时与第三方具有依赖关系的库和您的应用当前的工作方式之间会出现不匹配的情况。为了缓解这个问题，AloeStackVie 尽可能少地限制它的使用方式。任何 UIView 都可以与 AloeStackView 一起使用，这使您可以轻松地与您当前用于在应用程序中构建 UI 的任何模式集成。

所有这些功能相结合，使 AloeStackView 非常容易且毫无风险地进行试用。如果您对此感兴趣，请 [试一试](https://github.com/airbnb/AloeStackView) 并告诉我们您的想法。

AloeStackView 不是我们用于在 Airbnb 上构建 iOS UI 的唯一基础架构，但在许多情况下它对我们很有价值。我们希望您也觉得它很有用！

### 开始您的使用

我们很高兴的开源了 AloeStackView。如果您想了解更多信息，请访问 [GitHub repository](https://github.com/airbnb/AloeStackView) 。

如果您或您的公司发现此库有用，我们很乐意听取您的意见。如果您想要取得联系，请随时给维护人员发送电子邮件 (你可以在 [GitHub](https://github.com/airbnb/AloeStackView#maintainers) 找到我们)，或者你可以通过 [aloestackview@airbnb.com](mailto:aloestackview@airbnb.com) 联系我们。

* * *

**想参与其中吗？我们一直在寻找** [**有才华的人加入我们的团队**](https://www.airbnb.com/careers) **!**

* * *

**AloeStackView 由 Marli Oshlack、Fan Cox 和 Arthur Pang 开发和维护。**

**AloeStackView 同样也受益于许多 Airbnb 工程师的贡献: Daniel Crampton、Francisco Diaz、 David He、 Jeff Hodnett、 Eric Horacek、 Garrett Larson、 Jasmine Lee、 Isaac Lim、 Jacky Lu、 Noah Martin、 Phil Nachum、 Gonzalo Nuñez、 Laura Skelton、 Cal Stephens 和 Ortal Yahdav。**

**此外，如果没有得到 Jordan Harband、 Tyler Hedrick、 Michael Bachand、 Laura Skelton、 Dan Federman 和 John Pottebaum 的帮助和支持，就不可能开源这个项目。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
