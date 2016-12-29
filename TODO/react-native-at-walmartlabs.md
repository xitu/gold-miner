> * 原文地址：[React Native at WalmartLabs](https://medium.com/walmartlabs/react-native-at-walmartlabs-cdd140589560#.aynnbnjy1)
* 原文作者：[Keerti](https://medium.com/@Keerti)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Draftbk](https://github.com/draftbk)
* 校对者：[marcmoore](https://github.com/marcmoore), [DeadLion](https://github.com/DeadLion)

# 看沃尔玛如何玩转 React Native

![](https://cdn-images-1.medium.com/max/1600/1*FgddJm_KiUTCA5mh_fM7_Q.jpeg)

在[沃尔玛](http://careers.walmart.com/)，顾客总是第一位的，所以我们一直在寻找方法去改善我们给客户提供的购物体验。目前沃尔玛 app 有许多嵌入式的 Web 网页，我们发现这样的实现低于我们和我们的客户对这个应用程序的要求。即使在高端机上，这种混合 Web 视图实现的性能也不是很好，并且缺少了原生应用的感觉。不止如此，通过 Web 来访问非常依赖网络（我们使用服务器端呈现 Web），网络不好的用户会有不好的体验。因此，我们在思考：“有没有一种方法，能让我们修改或者替换现在的实现方式，为顾客提供更好更流畅的体验？”于是我们开始寻找答案。

### 可能的解决方案

经过一些头脑风暴，我们想出了以下的解决方案：

1. 纯原生实现 (没有网页了)
2. 用 React Native

![](https://cdn-images-1.medium.com/max/1200/1*iUQwmDC3ym3JJe_iSLZQ7A.png)

理论上来说使用原生语言实现是很不错的，但是实际上，我们需要考虑生产力、代码的共享、发布时间这些因素。这时一个像 React Native 这样的跨平台框架更胜一筹。当然还有一些其他的跨平台的移动开发框架，例如 PhoneGap、Xamarin 以及 Meteor，但是考虑到我们当前的 Web 使用了 React 以及 Redux，React Native 是我们优先考虑的。更不用说，它现在很稳定并且很可能会继续流行一段时间。

下面是我们发现使用 React Native 的好处:

**效率**

- 在 iOS 和 Android 两个平台上我们有 95% 的代码是可以共享的
- 不需要知识共享，因为每个功能都由单个团队实现的
- **开发者体验很赞**。 无需重新编译就可以看到简单的更改
- React Native 是用 JavaScript 写的。 我们可以充分利用整个组织内部的编程技能和资源

**代码共享**

- 前端/演示代码在 iOS 和 Android 之间可以共享
- 业务逻辑（redux store）也可以与 Web 应用共享
- 不同平台间的大量代码可以复用

**应用商店的审批**

- 不需要通过应用商店审批流程。我们可以在我们自己的服务器上托管代码，并实现 ota 更新

**上市时间**

- 非常快
- 我们可以控制发布日期
- 这两个平台可以控制在同一天同一时间发布

**性能**

- React Native 提供了和原生应用几乎一样的性能

**动画**

- React Native 提供了非常流畅的动画，因为代码在渲染之前转换为原生视图（View）

**用户体验（UX）**

- 我们可以有平台特定的 UI 设计

**自动化**

- 相同的自动化工具可以在 iOS 和 Android 上运行

### **性能**

当我们在 [WalmartLabs](http://www.walmartlabs.com/team/) 进行性能测试时，我们是有一些既定目标的。通过衡量 RAM 使用率、FPS、CPU 利用率等指标，我们希望能够了解 React Native 是如何在其竞争对手当中脱颖而出的。我们也想研究 React Native 的扩展能力 ——因为 React Native 可能成为整个企业的标准移动技术。既然这个项目是 WalmartLabs 的一次实验，我们的短期目标是证明这个技术和我们当前的技术有着相当的或者更好的性能。 我们的长期目标就是像 [Facebook](https://code.facebook.com/posts/924676474230092/mobile-performance-tooling-infrastructure-at-facebook/) 那样用我们的 CI 进行性能测试, 因此我们可以测试我们的每个变化对整体应用程序性能的影响。

**美中不足（[The trouble with tribbles](https://en.wikipedia.org/wiki/The_Trouble_with_Tribbles)）**

至于现在，性能测试 React Native 仍然让人头疼。由于这是两个不同的平台，有两套用于收集数据的工具。苹果为测试提供了工具，为我们提供了我们所需要的大多数测试。安卓系统需要使用多种工具来收集所有我们想要的数据。此外，对于许多测量，没有简单的方法来获得数据流，所以一些测量不得不靠估计。

Facebook 试图通过在 React Native 开发人员菜单中提供一个性能监视器来减小 Android 和 iOS 性能测试之间的差别。不幸的是，这个解决方案并不完美。在 iOS 上，它提供 RAM 使用，FPS 数据以及一系列与 React Native 相关的测量，但是对于 Android，perf 监视器仅提供 FPS 数据。在未来，如果可能，我希望看到所提供的测量能在两个平台上标准化。

**闭嘴，告诉我 React Native 是怎么做的!**

Ok，好的，但是要注意的是，我们报告的效果是基于我们的 app，可能不能代表你的 app。然而，我还是会尝试提供可以从我们的测试中得出的一般结论。

我们收集的数据预示着希望。它已经表明，React Native 确实是一个可行的解决方案，适用于大和小的移动应用程序。在图形性能，RAM 使用和 CPU 方面，我们采取的每一项措施都与我们当前的混合解决方案相当或更好，并且这对两个平台都是如此。应用程序的整体感觉有显著改善，并提供了远胜 Hybird 方案的用户体验。

React Native 很快，飞一样快。虽然我们没有用一个纯粹的原生版本来测试比较，但是可以说，就外观和感觉，用原生的方式编写这个应用程序不会提供任何明显超过 React Native 的优点。总的来说，我们对 React Native 的性能非常满意，我们希望我们收集的结果将得到业务部门的赞赏，最终获得用户的认可。

### 测试

为了确保我们的 React Native 代码的质量，我们的目标是 100％ 的测试都进行了单元测试和集成测试。

#### 集成测试

沃尔玛的 iOS 和 Android 应用程序是由数百名工程师合作开发的。我们使用我们的集成测试，以确保我们的 React Native 代码能在以后的发展中也保持良好的功能。

在沃尔玛，我们需要支持各种设备和操作系统。[Sauce Labs](https://saucelabs.com/) 使得我们能在不同版本的硬件和操作系统组合的 iOS 和 Android 设备上运行我们的集成测试。在多个设备上运行集成测试需要很长时间，所以我们每天晚上只做一次测试。

我们还使用我们的集成测试来防止回滚。我们已经使用 GitHub Enterprise 连接了我们的 [TeamCity CI](https://www.jetbrains.com/teamcity/) 以便对每个 pull 请求运行我们的测试。与集成测试不同，在 pull 请求时，我们只在一个设备上运行测试。 但即便这样也可能需要更长的时间，因此我们采用一些工具来减少所消耗的时间。[Magellan](https://github.com/TestArmada/magellan) 也是一个我们的开源项目，它允许我们并行运行测试，显著减少了测试时间。

测试本身用 JavaScript 编写，由 Mocha 运行，并使用 [Appium](http://appium.io/) 命令来控制手机模拟器。React Native 允许我们在每个组件上设置一个`testID`属性。这些`testID`作为 CSS 类名。我们方便地使用它们来精确地指定使用 XPath 的组件，并与之交互来达到测试的目的。


#### 单元测试

我们使用单元测试来独立地运行我们的 React Native 组件，防止无意的更改。

我们使用常用的 React 单元测试工具，如 Mocha、Chai、Sinon 和 Enzyme。但是 React Native 也有一些[独特的挑战](https://formidable.com/blog/2016/02/08/unit-testing-react-native-with-mocha-and-enzyme/)，因为它的组件有环境[依赖](http://airbnb.io/enzyme/docs/guides/react-native.html)使得它无法在 Node 上运行。[react-native-mock](https://github.com/lelandrichardson/react-native-mock) 为我们解决了这个问题，因为它提供了模拟的 React Native 组件，当在 iOS 或 Android 之外运行时不会中断。当我们发现自己需要模拟额外的依赖时，我们使用 [rewire](https://github.com/jhnns/rewire) 这样的 Node 模块。

#### 复用性

我们利用相同的自动化测试套件在 iOS 和 Android 上运行。

### 部署

React Native 的一个主要优点是能够通过 ota 实现快速修复问题，可以绕过应用商店。这意味着 React Native JavaScript 的 bundle 将托管在服务器上，并由客户端直接检索，有点像 web 的工作方式。

然而，React Native 提出的一个挑战是，为了使 JS bundle 工作，在本地端必须有一个兼容的 React Native 副本。如果将本机端升级到最新的 React Native，并且用户更新了应用程序，但是他们下载了旧的 bundle，则应用程序将中断。如果您更新该 bundle 以匹配最新的本机端，并将其提供给尚未更新其应用程序的用户，则它也会中断。

像 Microsoft [CodePush](https://github.com/Microsoft/react-native-code-push) 之类的工具可用于将 bundles 映射到正确的应用程序版本。但是在决定使用 React Native 时应该考虑到同时支持多个版本的应用程序是也一种开销。


### 挑战

#### iOS 和 Android 的不同

在 iOS 和 Android 上的 React Native 的功能之间有很多的不一致，使得同时支持这两个平台变得棘手。一些 React Native 行为和风格在不同的平台实现起来是不同的。例如，iOS 上支持 style 属性`overflow`，而 Android 不支持。组件属性也是在不同平台有不同的特性。在 React Native 文档中，你可以看到标记为 “Android only” 或 “iOS only” 的许多属性和功能。自动化测试代码还需要针对每个平台进行调整。

我们发现 iOS 有比 Android 更多的特性，所以对于一个针对这两个平台的产品，用“先开发安卓”的方法来开发是有意义的。

#### 开发和调试

在我们的经历中的一个痛点是 React Native 代码在调试模式与正常模式下的不同行为，造成这个情况的原因是 React Native 对这两种模式使用了[不同的 JavaScript 引擎](https://facebook.github.io/react-native/docs/javascript-environment.html#javascript-runtime)。当一个 bug 是常规模式特有时，自然很难调试，因为它在调试模式下是不可重现的。


### 总结

React Native 的确进行着一些伟大的事情。React Native 的标志（可以说是其最好的卖点）是它的跨平台 ——允许同一个团队在 iOS 和 Android 上同时开发，这可以减少大约一半的人工成本。说到团队， JavaScript 开发人员是很多的，所需的移动端开发的专业技能要求是很少的，这意味着有适合的熟练劳动力是随时待命的。产品的初始开发以及增加功能非常快，因此您可以比竞争对手更快地满足客户的需求。锦上添花的是，以 React Native 编写的应用程序一般来说具有与原生语言编写的应用程序性能相当甚至有潜在的优越性。

虽然 React Native 是有一些很棒的卖点，但在开始使用 React Native 的项目之前，还需要记住一些事情。 首先，尽管 React Native 在减小 iOS 和 Android 之间的差距方面做得很好，但是你不会在两个操作系统之间实现完全的平衡。还是有一些事情其中一个平台可以做，但是另一个平台无法处理，主要涉及到样式视图，但是，还有很多需要注意的问题，例如性能测试。虽然开源社区对开发和发布新功能和性能调整非常满意，但是实际上升级 React Native 版本往往还是给人带来巨大的烦恼，特别是如果你有一个用 React Native 构建的平台，就比如我们的 Walmart。

我们坚信 React Native 是一个非常棒的框架。它做了我们想要的一切，它是如此令人钦佩。尽管它确实有一些问题，这些问题也被使用它所能得到的好处掩盖了。从创业公司到世界 500 强公司，如果你考虑开发一个新的移动应用，可以考虑使用 React Native —— 我们觉得你不会后悔的。


**贡献者**

本文是由 WalmartLabs 的 React Native 团队的工程师协作完成的 —— [Matt Bresnan](https://medium.com/u/bbf6a1d22e3)、[M.K. Safi](https://medium.com/u/a4da983a03a0)、 [Sanket Patel](https://medium.com/u/3736ca4de438) 和 [Keerti](https://medium.com/u/5d46542ee15f)。
