> * 原文地址：[React Native: A retrospective from the mobile-engineering team at Udacity](https://engineering.udacity.com/react-native-a-retrospective-from-the-mobile-engineering-team-at-udacity-89975d6a8102)
> * 原文作者：[Nate Ebel](https://engineering.udacity.com/@n8ebel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-a-retrospective-from-the-mobile-engineering-team-at-udacity.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-a-retrospective-from-the-mobile-engineering-team-at-udacity.md)
> * 译者：[pkuwwt](https://github.com/pkuwwt)
> * 校对者：[DateBro](https://github.com/DateBro)

# React Native: 回顾 Udacity 移动工程团队的使用历程

![](https://cdn-images-1.medium.com/max/1600/1*AjesIvV-kkwk6LLvNf1t4A.png)

[Udacity](https://www.udacity.com/) 的移动团队最近把我们的应用程序中用 [React Native](https://facebook.github.io/react-native/) 编写的最后一个功能移除了。

我们收到了很多关于 React Native 及其使用的一些问题，还有人问我们为什么停止使用 React Native。

在本文中，我希望能够回答这些问题中的大部分，并且重点介绍：

  * 我们的相关团队的规模及人员组成？
  * 我们为什么一开始会尝试 React Native？
  * 移除 React Native 的原因？
  * 哪些方面可行？哪些方面不可行？
  * ...以及其它 🙂

我必然不能自称是 React Native 专家。我们团队中有的人比我更有经验，不过他们也未必能够称为专家。

我只是想谈一谈我们自己的经验，介绍一下在我们这个特定的使用情况下哪些可行哪些不可行。React Native 是否适合于你的团队/项目，这完全取决于你。而本文的作用是为你决策时提供一些额外的有用参考。

> “是否在你的团队/项目中使用 React Native 完全取决于你”

还需要指出的是，这里的经验和观点来自于 Udacity 的移动工程团队，并不涉及到公司其他团队。我们的想法不代表其它使用 React/React Native，或为之构建内容的团队的观点。

* * *

### 团队

第一件事，我们的团队是什么样的？你的团队的规模，经验和组织都会对 React Native 在你的工程中的可行性产生重大影响。

我们的移动工程团队覆盖了 iOS 和 Android 两个平台。


> 团队规模

**引入 React Native 时**

  * 1 个 iOS 开发人员
  * 2 个 Android 开发人员
  * 1 个 PM
  * 1 个 设计师

**如今**

  * 4 个 iOS 开发人员
  * 3 个 Android 开发人员
  * 1 个 PM
  * 1 个 设计师

在我们使用 React Native 的约 18 个月的时间里，我们 iOS 和 Android 两个团队都扩容了。整个团队还迎来了新的 PM。我们还经历了多种设计和多种范式。

> 开发者背景

当引入 React Native 时，每个团队对 JavaScript 和 React 编程范式的舒适度如何？

**iOS**

iOS 团队最初唯一的那个开发者对跳进 React Native 阵营相当认同，因为他之间已经有了大量的 JavaScript 和 web 开发经验。

现在，4 个 iOS 开发者中有 3 人在 JavaScript 和 React Native 开发中比较得心应手。

**Android**

引入 React Native 之初，两个 Android 开发者之一对 JavaScript 比较适应。另一个（我自己）基本没有什么 JavaScript，React 或 web 开发背景。

后来加入的另一个 Android 开发者也没什么 JavaScript 或 web 开发经验。

* * *

### 应用程序

我们的应用程序是干什么用的？

我们的移动应用程序的目标是将 Udacity 的学习体验带到移动设备上。它们需要支持认证、内容发现、项目注册（某些情况下还会有支付）、最后还要支持对不同的项目和内容类型的学习材料的使用。

这些应用程序还是新的实验性功能的测试温床，皆在改进用户的整体学习进展。

> **代码库的规模**

  * iOS: 97400 行代码（.swift，.h，.m）
  * Android：93000 行代码（xml, java, kotlin, gradle）

> **功能的一致性**

当引入 React Native 时，这些应用程序的功能基本上是一致的。

随着项目推进，核心体验基本上保持一致，但每个团队都有一些在特定平台上独有的“实验性”功能。

此外，由于更大的国际化需求，诸如本地化和更小的 apk 软件包大小之类的需求日益成为 Android 团队的优先事项。Android 团队还和其它地区的团队密切合作，为特定市场开发一些功能，这是 iOS 团队不需要重点考虑的。

* * *

## 为什么/如何采用 React Native？

> **我们为什么要引入 React Native？**

当时，我们想要开发一个全新的只在移动设备上运行的功能。我们希望在两个平台上实验和快速地验证，所以跨平台是非常吸引人的。

因为这是一个新的封闭性的功能，我们将其视为一个尝试跨平台方法的有意思的尝试。

我们选择 React Native 的原因如下：

  * 越来越可行的跨平台方案
  * 团队大部分人（2/3开发者）适应 JavaScript 和 web 开发
  * 更快的开发速度
  * 公司外其它团队的成功故事

> **我们是如何引入的？**

我们最初的 React Native 功能基于一个独立的 GitHub 仓库，然后将其作为 [git 子树](https://www.atlassian.com/blog/git/alternatives-to-git-submodule-git-subtree)，同时合并回 iOS 和 Android 仓库中。

这种方式支持非常快速的原型开发，如果有必要，也可以让这个功能以独立产品的形式发布。

随着积累了更多的原型开发经验，我们逐渐在 React Native 代码仓库中加入更大的第二个功能。

> **时间线**

  * Aug 2016: 创建功能 1 的 React Native 仓库
  * Nov 2016: 功能 1 在 Android 上发布
  * Nov 2016: 功能 2 开始开发
  * Dec 2016: 功能 3 原型开发开始
  * Jan 2017: 功能 1 开发结束
  * Feb 2017: 功能 2 发布
  * Mar 2017: 功能 3 原型开发结束
  * Nov 2017: 功能 2 在 Android 上的最后一次更新
  * Dec 2017: 功能 4 作为独立应用进行原型开发。最后由于性能原因重新用本地代码实现。
  * Feb 2018: 功能 2 在 iOS 上的最后一次更新
  * Apr 2018: 功能 1 从 Android 上移除
  * Jun 2018: 功能 2 同时从两个应用中移除

* * *

### 移除 React Native 的动机？

答案相当直接。

我们移除应用程序中与 React Native 相关的最后一点代码，原因在于剩下的唯一一个 React Native 功能已经快要下线，我们不打算对它继续支持了。

> “为什么停止用 React Native 开发新功能呢”

更有意思的问题可能是：为什么停止用 React Native 开发新功能呢？

原因大概有以下几条：

  1. 需要同时在两个平台上开发的功能数目下降
  2. Android 平台独有的产品请求量增加
  3. 长期维护成本的噩梦
  4. Android 团队不愿继续用 React Native

* * *

### 那么用什么来替代呢？

用 React Native 开发的功能被移除且不再支持，我们也没有替代这些功能的需求。

* * *

### React Native 哪些方面用得不错？

我们在使用 React Native 时，有哪些方面用得不错呢？

  * React Native 的入门、运行、及在两个平台上的构建都相当容易
  * 可以从 React 和 JavaScript 更大的生态系统中获取代码库和工具
  * 我们可以在两个平台上同时原型开发功能 1
  * 在一个跨功能团队中，同一个开发者可以同时为两个平台构建功能 2 的大部分代码
  * 团队对 React Native 的共同理解更深入了

* * *

### 遇到过哪些问题？

在我们使用 React Native 的过程中，我们遇到了一系列的问题。其中一些来源于我们的使用过程，一些来源于我们的使用案例，还有一些则来自于 React Native 本身。

### **设计和用户体验方面的挑战**

> **平台一致的 UI/UX**

因为我们要将几个新的屏幕集成到现有的更大的用户体验区中，我们希望新的 React Native 代码能够遵守本地平台的开发模式和风格。这意味着我们在两个平台上用的不一定是同一个 UI 设计。

让 React Native 的风格和本地平台一致并不是什么难事，但是你需要了解每个代码库中的设计范式。至少，你要核对每个平台，甚至要为每个操作系统开发新的定制控件。

对我们而言，经常需要接触每个平台的开发者和设计者，以理解需要做什么，否则在两边同时使用一个风格会导致 Android 这边的用户体验与其余应用完全不同。

在更复杂的情况下，我们需要编写额外的平台独有的代码，来定制每个应用程序的用户体验。

其中一个例子是，确保一个 back/up 图标的正确行为。因为要考虑到新的 React Native 功能代码集成到已有的应用中（集成到哪里/如何集成），确保 back/up 图标和 back 按钮点击时的正确行为需要 Android 平台的本地代码，而且要在 React Native 代码库中进行 Android 特有的代码改动。 

> **在本地设计中的改动会导致集成功能时 React Native 代码的变动**

至少在一个场合中，Android 应用的导航结构变动时，我们需要相应地更新 React Native 代码，不为别的，只是为了处理两者的集成问题。

我们没能做到让它们独立存在，React Native 实现的功能实际上在一个 fragment 中，它先是被放在一个 BottomNavigationView 的屏幕中，然后又被移到它自己与本地其它 fragment 之间的坐标状态中。

这种平台修改需要回到独立的代码库，进行修改并更新集成，确保新的改动不会对 iOS 应用程序产生负面影响。

> **设备相关的问题**

不管你叫它“碎片化”还是“分散化”，我们面临的现实是，Android 设备上有更多独特的配置需要考虑。

在很多情况下，我们发现布局不能很好地适配到不同尺寸的 Android 手机。我们发现最新的 iPhone 和 Pixel 设备上可以很流畅地运行动画，但是在国际市场上更广泛使用的低端设备上是做不到的。 

这当然不是 React Native 独有的问题，只不过是 Android 应用开发中共有的问题。但是，这确实是我们需要考虑的平台相关的问题，当这类问题多起来之后，我们不得不反思：React Native 的跨平台到底为我们省了多少时间？

> **全球化增长**

在我们使用 React Native 的时间里，Android 团队对国际化越来越关注。我们有数个国际化办公室，它们要求本地化和轻量化的 apk 包。 

React Native 是可以做字符串的本地化的，但需要额外的设置。在我们的案例中，它需要对不同的仓库的代码进行改动。这增加了本地化任务的复杂度，特别是你需要其它团队辅助完成本地化时，就不是很美妙了。这使得 React Native 实现的功能的本地化频率变得更低。

我们能够按要求减小 apk 文件大小，但是难以处理 React Native 占用的相当可观的那部分。当我们移除了最后一个用 React Native 实现的功能之后，我们的 apk 减少了约 10MB，这包括了命令资源（command resource）和 React Native 本身。

### **集成的挑战**

> **与本地组件和导航结构的集成**

根据我们的经验，将 React Native 集成到已有的应用中时，如果是一个独立的功能，则集成是相当直接的；不过如何需要与已有组件紧密集成并通信，则你会遇到麻烦。

我们发现，常常需要大量的桥接代码，来实现本地组件和 React Native 组件的通信。当我们需要修改 React Native 组件以适应导航结构时，这部分代码也是需要更新的。

> **工具链/构建问题**

集成 React Native 需要更新每个应用程序的构建过程。我们使用 CircleCI 来构建我们的工程，它需要重新配置以支持额外的 React Native 构建步骤。

在我们之前的一篇文章中介绍过，在 Android 这边并不是那么直观。

[在 Android 上发布版本时的 React Native 打包: 在 Android 发布build_engineering.udacity.com 时如何运行 React Native 打包命令行](https://engineering.udacity.com/bundling-react-native-during-android-release-builds-43d5c825d296)

一旦我们的构建过程包含了所需的 React Native 任务，它让 CircleCI 的发行版构建时间增加了约 20%。

在我们的代码库中移除最后一个 React Native 功能之后，我们有了如下的改进：

  * CircleCI 构建时间由约 15 分钟变成了 约 12 分钟
  * apk 发布文件大小由 28.4MB 变成了 18.1MB

Android 团队还经历了 Android/Gradle 构建工具与 React Native 冲突的一些问题。最近，我们一直在解决的一个问题是：[issues with Gradle 4](https://github.com/facebook/react-native/issues/16906)。

iOS 团队同样存在不少问题。

配置构建工具比较痛苦，因为我们使用 React Native 时采用的是非标准文件结构。因为我们有多个项目仓库，我们将 React Native 仓库置于 srcroot/ReactNative 目录下，而很多已有的构建工具却假设默认的应用文件结构为 /ReactNative/ios/ios。

此外，我们使用过 cocoapods 来管理依赖关系，它原来是包含 React Native 的推荐方式，但是后来却不再被推荐了。这个问题因为我们的非标准文件结构而变得更为严重，于是我们需要在 Podfile 中用一些很恼人的小技巧来从正确的位置读取文件。

由于 cocoapods 不再是包含 React Native 的标准方式，于是 Podfile 的更新会依赖于社区的更新，两者不总是同步的。我们数个版本的 css/Yoga 依赖已经更新，其 Podfile 却仍然在引用错误的版本。直到最后，我们仍然在使用一些恶心的安装后小技巧，实际上只不过是用 sed/regex 来定位那些包含的调用代码。

最后，iOS 项目的 CI 同样是一个痛点。现在，我们不得不添加一个 npm 依赖层，并确保在继续安装前正确地更新。这为我们的构建时间增加了不少时间。

我们还遇到过一个崩溃问题，因为一个版本的 npm 有 `package.lock`，而另一个没有，这导致我们在一次 React Native 升级时安装了错误的依赖版本。

* * *

### React Native 自身的挑战

> **文档**

React Native 作为一个整体发展是非常快的，然而我们也发现它的文档有时却是缺乏的。特别是当我们第一次采用时，我们发现某些特定版本的文档/回答也许仅仅是相关的，也许不相关。 

当前，将 React Native 集成到一个已有的工程中的文档是比较少的。这也是我们更新 CI 构建时头痛的一个问题。

当 React Native 持续进化时，文档和社区支持已经有所改善。如果我们是从今天开始使用，也许我们曾经的一些问题更容易找到答案。

> **导航**

我们最初是从 NavigationExperimental 开始的，它不是并容易使用的导航代码库。当 [React Navigation](https://github.com/react-navigation/react-navigation) 出现之后，它迅速成为社区接受的导航，于是 NavigationExperimental 在 ReactNavigation 完全采纳之前逐步不再推荐使用。

尽管如此，如果不将一些东西强行组合起来，我们是无法用 ReactNavigation 来实现一些功能的（比如：在一个当前 modal 流中推送 flow）。

> **性能**

前面已经提过，我们有几次都注意到了性能的问题。

我们可以在空间足够的 iOS 和 Android 设备上实现非常漂亮的动画，但是这些动画在国际市场上更广泛使用的低端 Android 设备上却难以良好运行。

在进入到应用的 React Native 部分时的加载时间比我们预期要长。这使得它不像是一种无缝过渡。

当原型开发独立的功能 4 时，图形渲染性能成为我们关心的主要问题，因为 React Native 完全比不了本地程序的性能。

> **滞后于本地平台**

因为和 iOS 或 Android 本地应用并不是同步构建，React Native 常常滞后于本地平台。它常常依赖于社区所支持的新的本地功能。

一个例子是我们急需的对 iPhone X 的 [safe area](https://facebook.github.io/react-native/docs/safeareaview.html) 支持。我们最终不得不暂时不支持 SafeArea，因为这个功能很快就会出来。SafeAreaView 是一种平台相关的功能，跨平台开发者在开发相关的功能时需要考虑到。

在其它时候，React Native 在采纳新平台要求方面也是滞后的，比如在 2018 年 8 月 Android 应用 [要求采用 API 26](https://android-developers.googleblog.com/2017/12/improving-app-security-and-performance.html)。要实现这个要求，仍然有一些未解决的问题。

> **不持续的更新**

React Native 升级时不支持后向兼容，这点让人非常崩溃。一个例子是 React Native 在升级它的 React 库时的 [PropType deprecation](https://github.com/react-navigation/react-navigation/issues/1352)。

除非维护自己定制的复制仓库，许多第三方库如果没有继续维护则将无法使用。

* * *

### 维护的挑战

代码库中 React Native 部分的维护是我们经常要头痛的问题。如前所述，Android 经常需要额外的工作来与已有代码集成或修正 UI 问题。这使得 iOS 和 Android 在不同的 React Native 代码库分支上不再同步，只有这样才不会让不同平台的开发互相拖累。

因为这种分支问题，代码开始慢慢变得发散，将它们重新一致起来所需的精力越来越多。于是，一个平台上的更新不会立刻反映到另一个平台上。

React Native 的改动的速度也构成挑战。因为存在不持续的改动的可能性，我们往往不能很快地更新一个依赖关系，来增加一个新功能或修复一个 BUG。

同样，一些时候这会产生更多摩擦，从而拖慢代码维护的频率。对于一个小团队，在有限的带宽下，如果无法对 React Native 代码进行容易/快速的修复，那么代码中的问题得到修复的可能性只会越来越低，因为它可能牵扯额外的开发精力。

增加了 React Native 之后，我们往往不是很清楚一个 BUG 存在于哪个层次。到底是两个平台都有？还是一个平台独有？如果只存在于一个平台，那这个 BUG 来自于本地代码还是 React Native 代码？这些问题增加了复杂性，从而拖慢了 QA 进程。

当需要在代码库的 React Native 部分中修复一个问题时，目前我们不得不同时考虑 iOS 和 Android，于是有可能需要同时考虑 3 个技术栈，而不是理想中的 1 个。

另外，因为团队中不是所有人都对 React Native 感到适应，能够在技术栈之间快速跳转并修复问题的人自然就更少了。

* * *

### 我们是否可以做得更好？
我相信我们面临的其中一些问题来源于我们的特定使用案例，不过，有些问题确实是可以缓解的。

> **更少的代码分支**

让应用程序与 React Native 仓库中的改动保持一致，我们就可以做得更好。我相信让这些更新同步会让我们在实现这些功能时有更强烈的跨平台开发的感觉。

增加设备上的测试，特别是 Android，可有助于我们在早期发现更多 UI/性能问题，并且在发布之前修复。在新代码编写之前修复问题，又可以进一步减少代码分支的数目。

> **更一致的设计**

从开始就采用更具体的设计计划，有可能可以改善这些功能的本地外观。一个具体的例子是，采用与本地应用程序其余部分一致的 text/margin 值，而非在新用户体验区中使用新值，并同时应用到两个平台上。

> **更好地理解你的团队**

团队中对 React Native 更不适应的那些成员应该更努力地适应其它技术栈。这会增加能够快速修复问题的人员的数目。

* * *

### 有没有使用案例更适合使用 React Native？

我不认为我们团队有人认为 React Native 一无是处。显然，我相信有些使用案例中 React Native 会更适用。

你是否需要快速地、双平台、从头原型开发/构建一个新应用？

你是否需要实现一个外观/行为与平台无关的应用/功能？

你是否有空闲的 JavaScript 开发者用于移动设备应用开发？

如果上述这些问题的答案都是肯定的，那么对你来说 React Native 可能是一个可行选项。

特别是，如果你有 JavaScript/React 背景，并且不需要太多本地代码，那么 React Native 将非常具有吸引力。它能让你无需学习两个技术栈的情况下开始构建一个移动应用。

对于一个完全跨平台应用的重头开发，React Native 也将是一个不错的选择。

* * *

### 我们还会不会用 React Native？

iOS 团队和 Android 团队有不同的说法。

> **iOS**

有可能。iOS 团队大体上对 React Native 开发相当开心，并且已经考虑用它来构建新功能。此外，在产品发布方面，相对于 Android 平台，我们的 PM 对 iOS 设备上的 React Native 方案更有信心。

> **Android**

不会。理想情况下，Android 团队将不会投入到 React Native 中去。我们发现 React Native 组件的集成过程相当烦琐，并且其用户体验并不能在所有 Android 设备上都同样运行良好。

此外，我们倾向于坚持使用一种技术栈，而不愿意在 Android 框架上再增加一层抽象，因为这也意味着增加潜在的 BUG。

我们的印象是，用 React Native 为 Android 创建新功能的过程是比较快的，但是这个功能从早期阶段过渡到最终发布版本，以及长期的维护过程，往往会花费更多时间。

* * *

### 我们是否会再次使用其它跨平台的方案？

作为一个团队，我们很可能不会在短期内投入到跨平台的开发中。iOS 团队有可能会用 React Native 来构建一些新东西，并且这只限于 iOS 设备，因为他们大体上会更享受这种开发体验。

个体而言，团队成员会继续关注 React Native，以及 Flutter。因为诸如 React Native 和 Flutter 这样的解决方案也在一直进化，我们会持续为我们的团队评估这些技术。

那么，这就是我们今天所处的状态。

我们对 React Native 如何能更好地适应我们的团队以及路线图方面有了更好的理解。我们可以基于这种判断来指导我们下一步的决策，从而为团队做出正确的技术选择。

> “我们可不可以确定地判断 React Native 是否适合于你？不能。”

我们知道 React Native 的优点以及不足，那么我们可不可以确定地判断 React Native 是否适合你？

不能。

但是，我们的经验完全能够可以作为你的参考依据，帮助你评估 React Native 在你的项目中的可行性。


* * *

#### 想要学习更多移动开发？

* [**谷歌的安卓开发纳米学位 | Udacity**：和谷歌一起使用我们的安卓开发纳米课程，开启你的职业生涯](https://www.udacity.com/course/android-developer-nanodegree-by-google--nd801)

* [**成为一个 iOS 开发得 | Udacity**：学习 iOS 应用开发，使用我们的 iOS 开发者纳米课程成为一个 iOS 开发者](https://www.udacity.com/course/ios-developer-nanodegree--nd003)

* [**React | Udacity**：React 是一种完全的颠覆性的前端开发。和 Udacity 一起来掌握这种来自于 Facebook 的 UI 库](https://www.udacity.com/course/react-nanodegree--nd019)

* [**使用 Flutter 来构建本地移动应用 | Udacity**：从谷歌专家那里学习如何使用 Flutter 在 iOS 和安卓设备上创建高质量的本地界面](https://www.udacity.com/course/build-native-mobile-apps-with-flutter--ud905)

#### 关注我们

想了解更多构建 Udacity 的工程师和科学家，请在 Medium 上[关注](https://engineering.udacity.com/)我们。

想加入我们？请 @udacity，[机会多多。](http://www.udacity.com/jobs)

#### 移动设备上的 Udacity

[**移动设备上的 Udacity | iPad, iPhone 和 Android**：我们已经将 Udacity 的课程体验带到了 iPad 和 iPhone 和 Android 上。开始学习你所需的技能吧](https://www.udacity.com/mobile)

感谢 [Aashish Bansal](https://medium.com/@aashish.bansal?source=post_page) 和 [Justin Li](https://medium.com/@li.justin?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

