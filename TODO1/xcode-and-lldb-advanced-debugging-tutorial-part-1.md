> * 原文地址：[Xcode and LLDB Advanced Debugging Tutorial: Part 1](https://medium.com/@fadiderias/xcode-and-lldb-advanced-debugging-tutorial-part-1-31919aa149e0)
> * 原文作者：[Fady Derias](https://medium.com/@fadiderias)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-1.md)
> * 译者：[kirinzer](https://github.com/kirinzer)
> * 校对者：[iWeslie](https://github.com/iWeslie)

# Xcode 和 LLDB 高级调试教程：第 1 部分

在 2018 年的 WWDC 期间，Apple 最优秀的一些调试工程师们开展了一场非常吸引人的会议[使用Xcode和LLDB进行高级调试](https://developer.apple.com/videos/play/wwdc2018/412/)。他们向我们展示了一些令人印象深刻的技巧， 关于每当发生开发人员遇到错误并全部修复它们时，如何利用 Xcode 的断点和低级调试器（LLDB）来优化调试过程。

在这个 3 部分的教程中，我将向你介绍 WWDC 会议中已经完成的大部分内容。我创建了一个演示项目专门用于阐述如何配合 LLDB 使用不同类型的断点来修复项目/应用程序中的错误。

## 演示项目

我写了一个常见的任务项目，大多数 iOS 开发人员肯定在某些时候已经处理过。在继续阅读本文之前，需要首先了解它的功能或规则。以下是演示项目的全部内容：

1. 一个表视图控制器，在第一次打开时加载一个文章列表。
2. 表视图控制器支持在到达底部时上拉加载更多文章。
3. 限制用户加载文章的次数 **7 次 **。
4. 用户可以通过下拉刷新重新加载新文章。
5. 导航栏上有两个标签，右侧标签用于显示请求到的文章数，左侧标签则用来显示用户已加载文章数。

如果你比较熟悉 Objective-C，可以在下载这个项目 [这里](https://github.com/FadyDerias/IBGPosts)。
更熟悉 Swift，从这里下载 [这里](https://github.com/FadyDerias/IBGPostsSwift)。
用 Xcode 打开并运行！ 😉

## 需要修复的错误！

现在你的项目准备就绪了，也许你已经注意到了下面的错误：

1. 下拉刷新没有加载新的文章。
2. 当用户网络请求失败的时候，没有收到任何提示(例如警报控制器)。
3. 用户可以下拉刷新 **超过** 7 次。
4. 导航栏左侧指示用户加载次数的标签也没有更新。

**指导原则**：在本文剩下的部分，你不必停止编译器或者重新运行应用，你可以在运行时修复这些错误。

## 表达式的力量

让我们来解决第一个错误。

> 1. 下拉刷新没有加载新的文章。

这里有复现这个错误的步骤：

✦ 运行应用程序 → 前十个文章被加载。

✦ 向下滚动加载更多文章。

✦ 滚动到表视图顶部，然后下拉刷新。

✦ 新文章 **没有** 重新加载，旧文章仍让存在并且文章计数没有重置。

修复此错误的常规方法是调查分配给表视图控制器的专用 UIRefreshControl 的选择器方法内部发生了什么。前往 `**PostsTableViewController**` 找到有 pragma mark `Refresh control support` 的部分。我们能从`setupRefreshControl` 方法推断出决定刷新的是 `reloadNewPosts` 方法。让我们给这个方法的第一行加一个断点，看看这里到底发生了什么。现在滚动到表视图的顶部，下拉刷新。

![Objective-C](https://cdn-images-1.medium.com/max/2000/1*t3vOwPZMfYXA33XraHBReQ.png)

![Swift](https://cdn-images-1.medium.com/max/2000/1*5o64at1-25xhG8x7MOQCcQ.png)

一旦你释放了下拉刷新控件，调试器就会在你设置断点的地方暂停。现在，为了探究背后发生了什么，点击调试器的跨过按钮。

![Objective-C](https://cdn-images-1.medium.com/max/2000/1*NnCfWSc4ALsmVW4MtVDmsQ.png)

![Swift](https://cdn-images-1.medium.com/max/2000/1*O9EsnTPL8Bc7eRaDnggkNQ.png)

现在我们就很清楚的知道发生了什么！

因为 if 条件没有满足（例如`isPullDownToRefreshEnabled` 布尔值类型的属性被设置为 `NO`）因此，相应的用于加载文章的代码就没有被执行。

修复这个错误的常规做法是停止编译器，设置 `isPullDownToRefreshEnabled` 属性为 `YES`/`true`。但是在真正的修改代码和停止编译器之前，就可以对这些假设做出验证会更方便。这里有表达式语句的断点调试器的命令动作，非常方便。

双击设置的断点，或右键单击，编辑断点并点击“添加动作”按钮。选择“调试器命令”动作。

![](https://cdn-images-1.medium.com/max/2000/1*5Q7AfSRWER__yCY-ygHrxA.png)

现在我们要做的是设置 `isPullDownToRefreshEnabled` 属性未 `YES`/`true`。添加如下的调试器命令。

**Objective-C**

```
expression self.isPullDownToRefreshEnabled = YES
```

![](https://cdn-images-1.medium.com/max/2012/1*lAJyDbhVTYjwfBzKszTDig.png)

**Swift**

```
expression self.isPullDownToRefreshEnabled = true
```

![](https://cdn-images-1.medium.com/max/2476/1*xY2IFUHIJQkqBSddN5hmog.png)

接下来你要做的是检查“评估动作后自动继续”框。这会使得调试器**不会**在每次触发它的断点时暂停，并在评估你刚才添加的表达式后自动继续。

现在滑动到顶部，下拉刷新。

**瞧** 新的文章被取回来了，并且替换了旧的，因此文章的技术也得到了更新。

既然你已经解决了第一个错误，拿起你的除虫武器开始处理第二个吧。

> 2. 当用户的 HTTP 请求失败的时候，没有收到任何提示（例如警报控制器）。

这里有复现这个错误的步骤：

✦ 关闭手机或模拟器的网络连接。

✦ 滑动到表视图的顶部，下拉刷新。

✦ 由于网络错误，没有加载到新文章。

✦ 网络连接错误的警报控制器没有展示给用户。

前往 **PostsTableViewController** 找到 pragma mark `Networking`的部分。它只有一个方法 `loadPosts`。它利用网络管理器的单例去执行一个 GET HTTP 请求，它会返回一个包含文章对象的数组，通过一个“成功”完成的回调或者一个 `NSError` 的实例，通过一个“失败”完成的回调。

我们想要做的是在失败完成处理回调中添加一些代码以展示一个网络错误警报控制器。 如果你找到到带有 pragma mark “Support” 的部分，你将会发现已经有一个已实现的方法 presentNetworkFailureAlertController 处理了所需警报控制器的显示。我们需要做的就是在 `loadPosts` 失败完成回调中调用该方法。

常规的做法是停止编译器，添加所需的代码，然后就行了。让我们超脱出来！

**在**这一行代码下**下**，添加一个断点

**Objective-C**

```
[self updateUIForNetworkCallEnd];
```

**Swift**

```
self.updateUIForNetworkCallEnd()
```

双击设置的断点，点击“添加动作”按钮。选择调试器命令动作。添加下面的调试器命令。

**Objective-C**

```
expression [self presentNetworkFailureAlertController]
```

![](https://cdn-images-1.medium.com/max/3048/1*Q1RqsI7GGn5Nx7MI9oaOFA.png)

**Swift**

```
expression self.presentNetworkFailureAlertController()
```

![](https://cdn-images-1.medium.com/max/2708/1*o1j-d1NS0j0DOBJlySEM6A.png)

勾选“评估动作后自动继续”。

停用网络连接后，滚动到表视图顶部并下拉刷新，或者你可以向下滚动到表视图底部尝试加载更多。你会得到这个 🎉🎉

![](https://cdn-images-1.medium.com/max/2000/1*Ohh02CA-HA3rqtgmx7atPQ.png)

你刚才做的是**“注入”**一行代码，通过一个在专用断点内实现为调试器命令动作的表达式语句。

## 概括

让我简单概括一下我们用断点调试器命令动作表达式语句做的事情：

1. 控制存在的属性的值。
2. 注入新的代码。

这两项任务都是在运行时实现的，我们不需要真的停止编译器，修改内容然后重新运行应用程序。

## 接下来去哪里？

查看 [**第二部分**](https://github.com/xitu/gold-miner/blob/master/TODO1/xcode-and-lldb-advanced-debugging-tutorial-part-2.md) 本教程中修复了额外的错误，并学习一种特殊类型的断点，观察点。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
