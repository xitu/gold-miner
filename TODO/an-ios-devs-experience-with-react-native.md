> * 原文地址：[An iOS Dev’s Experience with React Native](https://blog.madebywindmill.com/an-ios-devs-experience-with-react-native-559275b5a4e8#.qvkcgzpaa)
> * 原文作者：本文已获原作者 [John Scalo](https://blog.madebywindmill.com/@scalo?source=post_header_lockup) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[1992chenlu](https://github.com/1992chenlu),[avocadowang](https://github.com/avocadowang)

# 一名 iOS 开发者的 React Native 开发经历 #

如果你是一名 iOS 开发者，你应该听说过 React Native。它给出了简单而吸引人的承诺：一次编写，两处部署，同时搞定 iOS 与安卓版本的 app。我是一名资深的 iOS 开发者（还是一名更资深的 macOS 开发者），我想分享我应用这门神奇技术的经历。

去年，我们和一个客户进行过交谈。他们来找我们是因为他们想尽快完成他们的 iOS app。在讨论的过程中，他们提到了这个叫做 React Native 的东西。他们有个善于使用 Javascript 的 web 开发人员，那个人指出使用 RN 可以让开发速度快很多。这场谈判最终我们没有达成共识而是以失败告终，但这件事也让我开始思考是否应该将 RN 纳入我们的技术栈中

几周后一位老友来访，让我为他出版的一本书制作一个 app 作为补充参考资料。因为这个工作我找到了一线机会：这是一个很棒的时机来试一试 React Native。由于他的读者大多数使用安卓系统，因此「一次编写，两处部署」的理念在此深得我心。

我不会带你亲历一遍我的各种尝试和遇到的问题。但我要说的是，就这么一个简单的 app，并不能使用 RN 很好的进行开发。以下是原因。

首先，我必须说一下除开「一次编写，两处部署」的承诺，我喜欢 React Native 的地方。

- React.js，RN 由它而生。它是一种描述与更新 UI 的优雅方法。它的基本原理是组件使用一组传递给它的属性由上到下渲染其 UI。感谢 React 的虚拟 DOM，当属性变化时 UI 会立即更新，使得 model 与 view 能够自动且无缝地同步。我多么希望 iOS 的 UIKit 也这样设计啊！
- 更新 JSX 代码就可以在模拟器中更新 app 而不需要重新编译与重新运行，这点真的很棒。
- 蓬勃发展的 RN 社区提供了数以百计的预制组件，你可以在你的 app 中使用它们。（实际上我非常讨厌这种看似专业的「脚本小子」的编程方法。构建一个大部分都不是你自己写的，并且弄不明白的 app，将会导致之后的维护如同陷入泥潭一般困难）
- 我很担心 RN 的性能，但是在我的经历中它并没有出现问题。滚动和动画都很流畅。毕竟 RN app 大部分使用的是平台原生的 UI 控件，RN 的工程师们也对它们进行了很好的优化。

那么为什么我不喜欢它呢？老实说，我并不是 React Native 的目标用户。我熟悉 Javascript 但我并不精通它，我精通的是 Swift/Objective-C。我很快就意识到，如果我使用 RN 来完成这个 app，将会比我用 Swift 慢 10-20 倍。当然，安卓版本还要单独写，但是考虑到我学习 RN 的学习曲线，我还不如去学习 Java。

除此之外，我认为采用 RN 的解决方案还有一些严重的问题。

### 脆弱的依赖链 ###

React Native 并不是一个一站式解决方案。我制作了一个粗略的必要组件依赖图：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*781lZgF4IFAvLrnFRHcvaQ.png">

React Native 的依赖链

如果你来自 web 开发的世界，这可能对你来说很正常；但是对我来说，这很不正常。我的世界中有 Xcode，任何创建 Swift/Obj-C/iOS/Mac/Apple TV 等 app 所需要的东西都已经封装好并由 Xcode 管理。依赖链和前面的图一样（甚至更长），**但是依赖链中的东西都保证是同步且兼容的。**

我现在肯定 RN 依赖链中的大多数组件都是互相兼容的。但我遇到了四五个需要在 StackOverflow 上花几小时寻求解决方案的问题。在我心中更重要的是之后会发生的事情。例如，升级 Nuclide（IDE 的 RN 拓展）可能需要新版的 Atom。我系统中的另一个工具需要新版的 `winston`，如果那个版本不兼容 RN 怎么办？后果可想而知。

### 被打破的承诺 ###

事实证明「一次编写，两处部署」的承诺只有部分实现了。我遇到了必须要把我的 RN app 根据目标平台（iOS 或安卓）进行「分支」的问题。例如 tab bar，你可能认为像它这么随处可见的组件会被 RN 列为「一等公民」，但事实不是这样的。RN 为 iOS 收录了 `TabBarIOS` 组件，但是因为某些原因它在安卓上并不相同。相反，在 GitHub 上有一堆的教程和解决方案教你如何从头做起。又例如 nav bar，iOS 的 `NavigatorIOS` 与安卓的 `Navigator` 工作方式差别巨大。这些核心的导航功能结构在两个平台上的差异会导致要为每个平台分别编写大量的不同的文件与组件。我开始感觉到，尽管承诺很神奇，尽管我在用同一种语言，但其实我仍然在写两个不同的 app。

* 实际上，这个「承诺」其实是别人推断的，并不是官方宣称的（至少 Facebook/RN 的人没有这么宣称过）。官方宣传的是「一次学习，随处编写」。

### 令人惊讶的技术限制 ###

我在做的这个项目其实是一个层级化的参考指南。书作者和我为目录与文章用我们设计的 UI 范式规划了一套挺合理的布局。根据我们的想法，我们可以通过链接或导航跳转到数百个使用静态内容的详情页中。我写好了代码，但奇怪的是我调用 `require()` 一直不成功。我经过一段时间的研究，了解到 RN 限制**您无法从任意路径读取文件**。显然你的 RN app 在编译时收集了所有可能用到的路径，任何编译器无法找到的路径都将不能读取。所以你可以用 `require(‘../file1.json’)` 但不能用 `require(‘../file’ + ‘1’ + ‘.json’)`。这个让人惊讶的限制使得我们的架构无法实现。

### 冒牌货般的 UI ###

你最终完成的 RN app 可能既不像原生的 iOS app 也不像原生的安卓 app。大多数用户可能不会察觉这个问题，但有些人会发现更大的问题。你有可能会丢失一些用户会注意到的平台特有的细节，例如不能从左侧右滑来返回。（当你用 `NavigatorIOS` 完成两个平台的导航时会出现这个问题）


总而言之，iOS 开发者不应该将 React Native 视为两个平台的跨平台解决方案。写一个原生的 iOS app 将会花费**更少**的时间并可能得到更棒的 UX。对于安卓 app 也一样，所以我认为大家应该更多的去专注于平台原生解决方案。

什么时候用 RN 才是正确的呢？如果你是一个专业的 Javascript 程序员或者你有这么一个员工，并且你**不打算**配置 iOS 开发或安卓开发人员，那么你**可能**会从中获益。还记得那个想要尽快做好跨平台 app 的那个客户吗？他们**曾**有一名 Javascript 工程师，他们 app 的 v1.0 版本最近才出现在应用商店中。此时，距他们联系我们已经过去了 8 个月。


**最后是无耻的广告时间！如果你需要人帮你开发 iOS app，**[**请点这里**](http://www.madebywindmill.com)**！**


> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
