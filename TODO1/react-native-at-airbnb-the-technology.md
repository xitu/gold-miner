> * 原文地址：[React Native at Airbnb: The Technology](https://medium.com/airbnb-engineering/react-native-at-airbnb-the-technology-dafd0b43838)
> * 原文作者：[Gabriel Peal](https://medium.com/@gpeal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-at-airbnb-the-technology.md](https://github.com/xitu/gold-miner/blob/master/TODO1/react-native-at-airbnb-the-technology.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[ssshooter](https://github.com/ssshooter)、[LeeSniper](https://github.com/LeeSniper)

# Airbnb 中的 React Native：技术部分

## 技术细节

![](https://cdn-images-1.medium.com/max/2000/1*iaYan0f1NeQlzGnwzjXEvg.jpeg)

这是[系列博客文章](https://juejin.im/post/5b2c924ff265da59a401f050)中的第二篇，本文将会概述我们使用 React Native 的经验，以及 Airbnb 移动端接下来要做的事情。

React Native 本身在 Android，iOS，Web 和跨平台框架的各个部分上，是一个相对较新且快速迭代的平台。两年后，我们可以很有把握地说，React Native 在很多方面都是革命性的。这是移动设备的转变范例，我们能够从众多目标中获得收益。然而，它的好处并非没有明显的痛点。

### 技术性优势

#### 跨平台

React Native 的主要好处在于，你所编写的代码能够同时在 Andriod 和 iOS 上运行。使用 React Native 的大多数功能都可以实现 **95 - 100% 的共享代码**，和 **0.2% 不同平台需要用的的文件**（**.android.js/.ios.js**）。

#### 统一设计语言系统（DLS）

我们开发了一种名为 [DLS](https://airbnb.design/building-a-visual-language/) 的跨平台设计语言。同时拥有每个组件的 Android、iOS、React Native 和 Web 版本。拥有统一的设计语言可以实现编写跨平台代码的功能，这意味着设计，组件名称和屏幕可以跨平台保持一致。但是，我们仍然能够在适用的情况下，做出适合平台的决策。例如，我们在 Andriod 上使用原生的 [Toolbar](https://developer.android.com/reference/android/support/v7/widget/Toolbar)，iOS 上使用 [UINavigationBar](https://developer.apple.com/documentation/uikit/uinavigationbar)，但我们需要在 Andriod 上隐藏 [disclosure indicators](https://developer.apple.com/ios/human-interface-guidelines/views/tables/)，因为这不符合 Andriod 平台设计准则。

我们选择了重写组件，而不是封装原生组件。因为每个平台分别制作适用的 API 会更加可靠，并且可以减少 Android 和 iOS 工程师的维护开销，他们可能不清楚应该如何正确测试 React Native 中更改的代码。但是，它确实会导致同一组件的原生和 React Native 版本不同步的平台之间出现碎片。

#### React

React 成为[最受开发者欢迎的](https://insights.stackoverflow.com/survey/2018/#technology-most-loved-dreaded-and-wanted-frameworks-libraries-and-tools) Web 框架也是有原因。那就是它非常简单但功能强大，适用于大型代码库。我们非常喜欢的特点是：

*   **组件：** React 组件通过明确定义的属性和状态强制分离关注点。React 的可扩展性在其中起着很大作用。
*   **简单的生命周期：** 简单来说, Android 和 iOS 的生命周期都出了名的[复杂](https://i.stack.imgur.com/fRxIQ.png)。函数式和响应式 React 组件从根本上解决了这个问题，所以学习 React Native 比学习 Andriod 和 iOS 更简单。
*   **声明式：** React 的声明特性帮助我们的 UI 与基础状态保持同步。

#### 迭代速度

在使用 React Native 进行开发时，我们能够稳定地使用[热加载](https://facebook.github.io/react-native/blog/2016/03/24/introducing-hot-reloading.html)来测试我们在 Android 和 iOS 上的改动，过程只需一两秒钟的时间。即使原生应用竭尽全力也没法达到 React Native 实现的迭代速度。在最理想的情况下，原生编译时间为 15 秒，但对于完整项目的构建，竟高达 20 分钟。

#### 基础框架的投入

我们开发了广泛的集成到我们的原生基础框架，诸如网络、国际化、实验、共享元素转换、设备信息，帐户信息等许多核心组件都封装在一个 React Native API 中。这些桥接是一些更复杂的部分，因为我们想要将现有的 Android 和 iOS API 封装成对 React 一致且规范的东西。尽管通过快速迭代和新基础架构的开发，来保持这些桥接是最新的，但基础架构团队的投入能简化产品工作。

如果没有大量投入基础架构，React Native 会导致糟糕的开发人员和用户体验。因此，我们不相信 React Native 可以在没有重大和持续投入的情况下，直接应用到现有的应用程序中。

#### 性能表现

性能是React Native 最大的问题之一。但是，实践中遇到这个问题的机会不大。我们的大多数使用了 React Native 的屏幕都像原生的一样流畅。我们往往会总在一个单一的维度中去考虑性能。我们经常看到移动端工程师认为 JS，“比Java慢”。然而，在很多情况下，移动端主线程的业务逻辑和[布局](https://github.com/facebook/yoga)都可以提高渲染性能。

当我们确实发现性能问题时，大多数是由过度渲染引起的，这可以通过有效地使用 [shouldComponentUpdate](https://reactjs.org/docs/react-component.html#shouldcomponentupdate)，[removeClippedSubviews](https://facebook.github.io/react-native/docs/view.html#removeclippedsubviews)，和使用 Redux 来解决。

然而，初始化和初识渲染时间（下面概述）使得 React Native 在启动屏幕，Deep Links 表现不佳，并且在屏幕之间导航时增加了 TTI 时间。另外，因为 [Yoga](https://github.com/facebook/yoga) 在 React Native 组件和原生视图之间进行了转换，所以丢失帧的屏幕很难调试。 

#### Redux

我们使用了 [Redux](https://redux.js.org/) 进行状态管理，发现这种方法非常有效。不但防止了 UI 与状态不同步的问题，在屏幕之间也能轻松实现数据共享。但是，Redux 以其模板和相对困难的学习曲线而声名狼藉。我们为一些常见模板提供了生成器，但它仍然是在使用 React Native 时，最具挑战性的部分和混淆之一。值得注意的是，这些挑战不是 React Native 特有的。

#### 原生支持

由于 React Native 中的所有内容都可以通过原生代码进行桥接，因此我们最终能够在开始时构建许多我们不确定的事情，例如：

1.  **共享元素转换：**我们构建了一个 **<SharedElement>** 组件，该组件由 Android 和 iOS 上的原生共享元素代码所支持。这甚至适用于原生和 React Native 屏幕。
2.  **Lottie：** 通过在 Android 和 iOS 上封装现有的库，我们能够让 Lottie 在 React Native 中正常工作。
3.  **Native 网络栈：**React Native 在两个平台上都使用我们现有的原生网络栈和缓存。
4.  **其它核心基础架构：**就像网络一样，我们将其他现有的原生基础架构（如国际化，实验等）封装起来，以便它能够在 React Native 中无缝工作。

#### 静态分析

我们在网络方面上[使用 eslint 的历史非常悠久](https://github.com/airbnb/javascript)，这次我们也可以利用它。不过，Airbnb 是开创 [Prettier](https://github.com/prettier/prettier) 的第一个平台。我们发现它可以有效减少 PR 上的麻烦。现在，我们的网络基础架构团队正在积极研究 Prettier。

我们还用分析来衡量渲染时间和性能，以确定哪些屏幕是性能问题调查的首要任务。

由于 React Native 比我们的网络基础结构更小、更新，因此是良好的测试新想法的平台。我们为 React Native 创建的许多工具和想法现在都被 Web 采用。

#### Animated

多亏了 React Native [动画](https://facebook.github.io/react-native/docs/animated.html) 库，我们能够实现流畅动画，甚至交互驱动的动画，如视差滚动。

#### JS/React 开源

由于 React Native 会运行 React 和 JavaScript，因此我们能够利用大量的 Javascript 项目，例如 Redux、Reselect、Jest 等。

#### Flexbox

React Native 使用了 [Yoga](https://github.com/facebook/yoga) 来处理布局。这是个跨平台的 C 语言库，通过 [flexbox](https://www.w3schools.com/css/css3_flexbox.asp) API 处理布局计算。早些时候，我们受到 Yoga 的局限，例如缺乏长宽比，不过在后续更新增添了。此外，像 [flexbox froggy](https://flexboxfroggy.com/) 这样有趣的教程，能让你在上手的时候更加享受。

#### 与 Web 互相协作

在 React Native 探索的后期，我们开始一次性为 Web，iOS 和 Android 构建项目。鉴于 Web 也使用 Redux，我们发现大量代码可以在 Web 和原生平台上共享，无需做任何更改。

### 缺点

#### React Native 还不成熟

React Native 相对 Android 或 iOS 来说，略显不够成熟。它很新，也有野心，并且迭代速度非常快。虽然 React Native 在大多数情况下都能很好地工作，但有些情况下，它的不成熟可能会显现出来，使用原生就能轻而易举实现的事情变得非常困难。不幸的是，这些情况很难预测，而且可能需要几小时到几天的时间才能解决。

#### 维护 React Native 的分支

由于 React Native 还不成熟，我们有时需要修补 React Native 源码。除了将问题反馈给 React Native 之外，我们还必须[维护一个分支](https://github.com/airbnb/react-native/commits/0.46-canary)，我们可以在其中快速合并更改并升级版本。在过去两年中，我们不得不在 React Native 添加大约 50 次 commit。这使得升级 React Native 的过程非常痛苦。

#### JavaScript 工具

JavaScript 是一种无类型语言。缺乏类型安全既难以扩展，也成为习惯于类型化语言的移动端工程师争论的焦点，否则他们可能会对学习 React Native 感兴趣。我们探讨了采用 [flow](https://flow.org/) 的方式，但隐晦的错误消息导致了令人沮丧的开发者体验。我们还探讨了 [TypeScript](http://www.typescriptlang.org/)，但将其整合到我们现有的基础架构中时，如 [babel](https://babeljs.io/)和 [metro bundler](https://github.com/facebook/metro) 是有问题的。不过，我们正在继续积极研究 Web 上的 TypeScript。

#### 重构

JavaScript 一个无类型的副作用是，重构非常困难且容易出错。重命名一些属性，特别是带有通用名称的属性（如 **onClick** ）或通过多个组件传递的属性，对于准确地重构来说是一场噩梦。更糟糕的是，重构在生产环境中崩溃，而不是在编译时，很难对其进行适当的静态分析。

#### JavaScriptCore 不一致

React Native 的一个微妙和棘手的方面是，它需要在 [JavaScriptCore 环境](https://facebook.github.io/react-native/docs/javascript-environment.html)上执行。以下是我们遇到的问题：

*   iOS 自带的 [JavaScriptCore](https://developer.apple.com/documentation/javascriptcore) 可以开箱即用。这就是说，iOS 大部分是一致的，对我们来说没有问题。
*   Android 不带有 JavaScriptCore，因此由 React Native 提供。但是，默认情况下，获得的是[旧版本](https://github.com/facebook/react-native/issues/10245)的。这导致的结果是，我们不得不自己捆绑一个[新版本](https://github.com/react-community/jsc-android-buildscripts)的 JavaScriptCore。
*   在调试时，React Native 会连接到 Chrome 开发者工具。这点非常好，因为它是一个强大的调试器。但是，一旦连接了调试器，所有 JavaScript 都将在 Chrome 的 V8 引擎中运行。99.9% 的情况都运行良好。但是，在一个实例中，我们在 iOS 上使用 toLocaleString 时，我们碰到了问题，调试只能在 Android 上工作。事实证明，Android [(不包括 JSC）](https://github.com/facebook/react-native/issues/15717)，除非你正在调试，在这种情况下，它使用的是 V8 引擎，否则它会悄无声息地失败。在不知道这些技术细节的情况下，可能会导致产品工程师进行数日痛苦的调试。

#### React Native 开源库

学习平台既困难又费时。大多数人只能很好地了解一或两个平台。React Native 库有原生桥接，例如地图，视频等，开发者需要对三个平台都有相同的认识才能实现。我们发现大多数 React Native 开源项目都是由有一两次经验的人所编写的。这导致了 Android 或 iOS 上的不一致或意想不到的错误。

在 Android 上，许多 React Native 库也要求你使用 node_modules 的相对路径，而不是发布与社区所期望的不一致的 Maven Artifact。

#### 并行基础架构和工作

我们在 Android 和 iOS 上积累了多年的原生基础架构。但是，在 React Native 中，我们从完全空白的状态开始，不得不编写或创建所有现有基础架构的桥接。这意味着，有时产品工程师需要一些尚不存在的功能。这种情况，他们要么在一个不熟悉的平台上工作，要么在项目范围之外构建，或者干等到有人创建这个功能。

#### 崩溃监控

我们使用 [Bugsnag](https://www.bugsnag.com/) 进行 Android 和 iOS 崩溃报告。虽然 Bugsnag 通常在两个平台上能正常工作，但它不太靠谱，并且需要比在其他平台上做更多的工作。由于 React Native 在行业中相对较新且罕见，因此我们必须构建大量基础架构，例如内部上传的源地图，并且必须与 Bugsnag 合作才能执行诸如发生在 React Native 过滤器崩溃等事件。

由于 React Native 周围的自定义基础架构数量众多，偶尔也会出现严重问题，例如未报告崩溃或源地图未正确上传。

最后，如果问题跨越 React Native 和原生代码，调试 React Native 崩溃往往更具挑战性，因为堆栈跟踪不能在 React Native 和原生代码之间跳转。

#### 原生桥接

React Native 有 [桥接 API](https://facebook.github.io/react-native/docs/communication-ios.html) 用于原生和 React Native 之间进行通信。虽然它能按预期正常工作，但编写起来非常麻烦。首先，它要求所有三种开发环境都要正确设置。我们也遇到了很多来自 JavaScript 的类型不正确的问题。例如，整数通常是由字符串封装的，这个问题直到桥接后才能被察觉。更糟糕的是，有时 iOS 会悄无声息地失败，而 Android 则会崩溃。到 2017 年底，我们开始研究从 TypeScript 定义自动生成的桥接代码，但为时已晚。

#### 初始化时间

在 React Native 首次渲染之前，你必须初始化其运行时。不幸的是，即使在高端设备上，我们的应用也需要几秒钟的时间。所以，几乎是不可能使用 React Native 来启动屏幕。我们通过在应用程序启动时初始化 React Native 来缩短第一次渲染时间。

#### 初始渲染时间

与原生屏幕不同，渲染 React Native 需要至少一个完整的主线程 -> JS  -> Yoga 布局线程 -> 主线程返回之前，然后才有足够的信息来第一次渲染屏幕。我们可以看到 iOS 平均初始 p90 渲染 280ms，而 Android 需要 440ms。在 Android 上，我们使用通常用于共享元素转换的 [postponeEnterTransition](https://developer.android.com/reference/android/app/Activity.html#postponeEnterTransition%28%29) API 来延迟显示屏幕直到它完成渲染。在 iOS 上，我们遇到了问题，从 React Native 快速设置导航栏配置。因此，我们为所有 React Native 屏幕过渡添加了 50ms 的仿真延迟，以防止配置加载后导航栏闪烁。

#### App 大小

React Native 对应用程序大小也有不可忽视的影响。在 Android 上，React Native（Java + JS + 原生库，例如 Yoga + Javascript 运行时）的总大小为每个 ABI 8MB。在一个 APK 中使用 x86 和 arm（仅 32 位），体积将接近 12MB。

#### 64 位

由于[这个](https://github.com/facebook/react-native/issues/2814)问题，我们仍然不能在 Android 上安装一个 64 位的 APK。

#### 手势

我们避免在涉及复杂手势的页面上使用 React Native，因为 Android 和 iOS 的触摸子系统非常不同，以至于整理出一套统一的 API 对整个 React Native 社区来说都具有挑战性。然而，这项工作仍在继续进行，[react-native-gesture-handler](https://github.com/kmagiera/react-native-gesture-handler) 最近已经发布 1.0 版本。

#### List 太长

React Native 在这方面取得了一些进展，比如 [FlatList](https://facebook.github.io/react-native/docs/flatlist.html) 库。但是，它们远不及 Android 上的 [RecyclerView](https://developer.android.com/guide/topics/ui/layout/recyclerview) 或是 iOS 上的 [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview) 的成熟度和灵活性。由于多进程的问题，许多限制难以克服。适配器数据无法同步访问，这会导致视图闪烁，因为它们在快速滚动时进行了异步渲染。另外，文本也无法同步测量，因此 iOS 无法使用预先计算的 cell 高度进行某些优化。

#### 升级 React Native

尽管大多数 React Native 升级都很微不足道，但有一些却令人非常痛苦。尤其是， React Native 0.43（2017 年 4 月）至 0.49（2017 年 10月）版本几乎无法使用，因为其中使用了 React 16 alpha 和 beta。这是个大问题，因为大多数专为 Web 使用而设计的 React 库不支持以前发布的 React 版本。争论此次升级的适当依赖关系的过程，对 2017 年中其他 React Native 基础架构工作造成重大损害。

#### 辅助功能

在 2017 年，我们进行了一次[辅助功能大修](https://airbnb.design/designing-for-access/)，其中我们投入了大量的精力，确保残疾人士可以使用 Airbnb 预订来满足他们的房源需要。但是，React Native 关于辅助功能的 API 有很多漏洞。为了满足甚至最小可接受的辅助功能条，我们必须要[维护 React Native 的一个分支](https://github.com/airbnb/react-native/commits/0.46-canary)，来合并修复程序。对于这些情况，Android 或 iOS 上的一行修复需要数天时间，才能确定如何将其添加到 React Native，然后 cherry-pick，接着在 React Native Core 上提交问题，并在接下来的几周内对其进行跟踪。

#### 棘手的崩溃

我们不得不面对一些难以解决的、非常奇怪的崩溃。例如，我们目前在 **@ReactProp** 注解中遇到了[这个崩溃](https://issuetracker.google.com/issues/37045084)，并且无法在任何设备上复现，即使是和那些持续崩溃的设备具有相同硬件和软件也是如此。

#### 在 Android 上的 SavedInstanceState 跨进程 

Android 经常会去清理后台进程，但给了它们一个[同步把状态保存在 bundle 中的](https://developer.android.com/topic/libraries/architecture/saving-states#use_onsaveinstancestate_as_backup_to_handle_system_initiated_process_death)机会。但是，在 React Native 上，所有状态只能在 JS 线程中访问，因此无法同步进行。即使情况并非如此，作为状态存储的 Redux 与此方法也不兼容，因为它混合了包含可序列化和不可序列化数据，并且可能包含比 saveInstanceState 包中容纳的更多类型的数据，这会导致[在生产环境下崩溃](https://medium.com/@mdmasudparvez/android-os-transactiontoolargeexception-on-nougat-solved-3b6e30597345)。

* * *

这是系列博客文章的第二部分，重点讲述了我们使用 React Native 的经验，以及 Airbnb 移动端接下来要做的事情。

*   [第一部分：Airbnb 中的 React Native](https://juejin.im/post/5b2c924ff265da59a401f050)
*   [**第二部分：技术细节**](https://juejin.im/post/5b3b40a26fb9a04fab44e797)
*   [第三部分：构建跨平台的移动端团队](https://github.com/xitu/gold-miner/blob/master/TODO1/sunsetting-react-native.md)
*   [第四部分：在 React Native 上作出的决策](https://github.com/xitu/gold-miner/blob/master/TODO1/sunsetting-react-native.md)
*   [第五部分：移动端接下来的事情](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-next-for-mobile-at-airbnb.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
