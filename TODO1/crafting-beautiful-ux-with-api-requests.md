> * 原文地址：[Crafting beautiful UX with API requests](https://uxdesign.cc/crafting-beautiful-ux-with-api-requests-56e7dcc2f58e)
> * 原文作者：[Ryan Baker](https://uxdesign.cc/@ryan.da.baker?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-beautiful-ux-with-api-requests.md](https://github.com/xitu/gold-miner/blob/master/TODO1/crafting-beautiful-ux-with-api-requests.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：[sunhaokk](https://github.com/sunhaokk)

# 用 API 请求制作赏心悦目的 UX

## 在构建 Web 应用时，首先要创建一个优雅且响应迅速的体验。

试图控制超出 Web 应用程序范围的体验通常是事后的想法。工程师忘记了处理从 API 请求数据时可能会遇到的所有麻烦事情。在本文中，我将为你提供三种模式（包括代码片段），以使你的应用程序能弹性应对不可预测的情形。

![](https://cdn-images-1.medium.com/max/1000/1*lEMi48f7LTbhCpaFKQVM6A.jpeg)

让你的用户和这个愚蠢的人类一样快乐

### 模式 1：超时

超时是一种简单的模式。简而言之，就是：“如果你的反应比我想要的慢，请取消我的请求”。

#### 什么时候用

你应该使用超时来设置你希望请求耗用的时长**上限**。有什么可能会使你的 API 响应时间比预期的长？这取决于你的 API，但以下是一些现实场景的示例：

你的服务器与数据库进行通信。数据库宕机了，但服务器的连接超时为 30 秒。服务器将花费完整的 30 秒来确定它无法与数据库通信。这意味着你的用户将等待 30 秒！

你使用了 AWS 负载均衡器，其背后的服务器已宕机（无论出于何种原因）。你将负载均衡器超时保留为[默认值 60 秒](https://aws.amazon.com/blogs/aws/elb-idle-timeout-control/)，并且在失败之前一直尝试连接服务器。

#### 什么时候不用

如果你的 API 已知响应时间具有可变性，则不应使用超时。一个很好的例子可能是返回报告数据的 API。请求一天的数据是快速的（可能是亚秒响应时间），但请求八个月的数据大约需要 12 秒。

**如果你无法确定对于请求应该花多长时间的可靠上限，则不要使用超时。**

#### 如何使用

假设你的应用程序中有一个方法可以做到这一点：

![](https://cdn-images-1.medium.com/max/800/1*VrWx5PPIf84n8PKfaxCi8g.png)

示例方法可能存在于 React 组件内部

你知道你的 API 在 99％ 的时间里会在 3 秒内响应。假设你使用 [Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) 从 API 获取数据，你可以这样做：

![](https://cdn-images-1.medium.com/max/800/1*n4ONmQQn8dwfd674LIPfLw.png)

为你的 API 调用配置超时

**注意：你可能用于进行 API 调用的大多数库都具有超时配置。请使用你工具的内置功能，而不是自己编写**

### 模式 2：最短等待时间

最短等待时间也是一种简单的模式。它与超时相反：它可以保护你的应用免受 API **快速**响应的影响。

#### 什么时候用

如果要向用户显示加载状态，则最短等待时间是一种非常好的模式，但 API 可能会快速响应。结果就是用户会看到加载状态，接着数据“弹出”进入视图，然后其才能专注于想做的事。

这不是一个良好的体验。如果你显示加载状态，你是在告诉用户“稍等，我们正在处理些事儿，我们会马上回来”。这让用户可以喘口气，也许查看一下他们的手机 —— 如果用户看到加载状态，那么用户**希望等待**。如果你获取太快，那就太突兀了。你打断了她的休息，让她变得紧张。

#### **什么时候不用**

当你拥有响应速度始终非常快的 API 时，最好避免使用最短等待模式。**不要**为了添加加载状态而添加，如果不需要，就**不要**让用户等待。

#### 如何使用

使用上面的示例，你可以编写代码“在这两件事完成之前不做任何事”，如下所示：

![](https://cdn-images-1.medium.com/max/800/1*-eXymmc8GfkuGTG4XrBMfw.png)

强制请求的最短等待时间

### 模式 3：重试

重试模式是我将要介绍的最复杂的模式。基本的想法是，如果得到错误的响应，我们想要重试几次请求。这是一个非常简单的想法，但在使用它时需要记住一些注意事项。

#### 什么时候用

当你向可能发生间歇性故障的 API 发出请求时，你会希望使用此方法。当知道请求会**不时**因为无法控制的问题而失败时我们几乎都希望重试。

就我而言，当我知道我正在发出使用特定数据库的请求时，我会经常使用它。访问该数据库时，有时它会失败。是的，这很糟糕。是的，这是我们应该解决的问题。作为应用程序开发人员，当被告知“暂时处理它”时，我们可能没有能力修复底层基础架构问题。这就是你想要重试的时候。

#### 什么时候不用

如果我们拥有可靠的且始终如一的响应式 API，则无需重试。如果响应失败并且重试后依然不能成功响应，那我们也就不需要重试了。

大多数 API 都是一致的。这就是为什么你需要小心这个模式：

#### 如何使用

我们希望确保在发出请求时，不会对服务器造成冲击。想象一下因为负载过重造成服务器宕机的情形吧。重试将把一个已死的服务器再埋到六英尺深的地下。出于这个原因，我们在进行后续请求时需要所谓的**退避策略**。我们不希望在服务器宕机的情况下仍然立即一个接一个地发出 5 个请求。我们应该错开它们以减少 API 服务器上的负载。

大多数情况下，我们使用**指数退避**来确定在发送下一个请求之前我们应该等待多长时间。我们通常只想重试 3 次，所以这里有一个使用不同函数的等待时间示例：

![](https://cdn-images-1.medium.com/max/600/1*SrIVlW-y7ihWboBqzM6O9A.png)

立即发送第一个请求。它失败了。接下来，我们需要确定在发送第一次重试之前使用退避策略等待多长时间。让我们看一下这些曲线，其中 X 等于我们已经发送的重试次数。

使用我们的二次（y = x²）函数和线性（y = x）函数，在第一个等待时间内我们得到 0，即应该立即发送下一个请求。

所以可以在运行时消除这两个函数了。

使用指数（y = 2^x）函数和常数（y = 1）函数，我们得到 1 秒的等待时间。

常数函数使我们无法灵活处理已经发送的重试次数，从而改变我们应该等待的时间。

这就只剩下指数函数了。让我们编写一个函数，来告诉我们根据已经发送的重试次数确定等待多少秒：

![](https://cdn-images-1.medium.com/max/800/1*3D0xaSIUBz-M5-h1ccbZuA.png)

简单的 y = 2^x 函数

在编写重试函数之前，我们想要一种方法来确定请求是否错误。假设状态码大于或等于 500 时，请求是错误的。这个就是我们可以为此编写的函数了：

![](https://cdn-images-1.medium.com/max/800/1*y2ir3VPSLIbr1aWi_WcERg.png)

如果响应错误，我们的函数会抛出自定义错误

请记住，你可能有不同的标准来确定请求是否失败。最后，我们可以使用指数退避策略编写重试函数：

![](https://cdn-images-1.medium.com/max/1000/1*kcvzvrQ58jm8GaCRmAKYvA.png)

我们使用指数退避策略重试

你会注意到我创建了一个我没有导出的函数（_retryWithBackoff）。使用我们的重试函数时，调用代码不能在迭代中显式传递。

### 总结

有很多很好的防御模式可以提供良好的用户体验。这三个你今天就可以使用！如果你有兴趣了解更多，我建议阅读 [**Release It**](https://www.amazon.com/Release-Design-Deploy-Production-Ready-Software/dp/1680502395/ref=pd_lpo_sbs_14_t_0?_encoding=UTF8&psc=1&refRID=BNBXXWPWRX7DEQ4CWMKB)！一本关于如何在构建可扩展软件时解决这些确切问题的书。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
