> * 原文地址：[What It Was Like to Write a Full Blown Flutter App](https://hackernoon.com/what-it-was-like-to-write-a-full-blown-flutter-app-330d8202825b)
> * 原文作者：[Nick Manning](https://hackernoon.com/@seenickcode?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-it-was-like-to-write-a-full-blown-flutter-app.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-it-was-like-to-write-a-full-blown-flutter-app.md)
> * 译者：
> * 校对者：

# 写一个完整的 Flutter App 是什么感觉

![](https://cdn-images-1.medium.com/max/800/1*SZK7j8dPQuaecmaeJoWxwA.jpeg)

**更新**: 我将会放出一个新的 Flutter 课程，名为 Practical Flutter。它将在 18 年 七月底开始。如果你想收到通知， [点击这里](https://mailchi.mp/5a27b9f78aee/practical-flutter)。 🚀

今天早上我吃了两顿早饭，因为我需要发动所有的写博客用的脑力。从[我的上一个帖子](https://codeburst.io/why-flutter-will-take-off-in-2018-bbd75f8741b0) 以后，我有了很多想说的话，所以我们开始吧。

我非常激动，因为我可以正式继续写关于 Flutter 的文章了，因为我即将把我的第一个 Flutter app 放出到 iOS 和 Android 商店——只有一两周了！因为我在空闲时间里一直在写这个 app，所以在过去几个月我一直拒绝被打扰。

**自从 Ruby on Rails 或 Go 以来，我从没有因为一个技术而这么激动过。** 在花了好几年深入学习 iOS app 开发之后，我因为对 Android 非常不熟悉而感到不爽。而且，以前的那些跨平台开发框架都很难吸引我。

比如在两年前，前往跨平台 app 开发的聚会，我会觉得那些东西都很不正规、不稳定、开发者体验糟糕、难以使用，或者最近一两年都没法用。

我刚刚完成第一个 Flutter app，并感到我可以长期安全地向这个框架投入更多的时间。写一个 app 是对一个框架最后的检验，而 Flutter 通过了这个检验。能够熟练地开发 iOS 和 Android app 令我感到惊喜。我也很喜欢服务端的开发与扩容，而 [我的妻子 Irina](https://www.behance.net/irinamanning) 是一名用户体验设计师，所以这是一个强大的组合。

**这篇博文将会很长，因为它包括很多内容：**

1.  **我关于把 iOS app 迁移到 Flutter 的经验**
2.  **目前为止关于 Flutter 的想法**
3.  **对 Google 团队的建议**

我决定尽快写下我的想法，以便尽快继续写教程（以及更多的 app！）。

### 1. 把 iOS 应用迁移到 Flutter

自从我的上一个 [关于 Flutter 的帖子](https://codeburst.io/why-flutter-will-take-off-in-2018-bbd75f8741b0) 以来，我感觉合乎逻辑的下一步是真正深入地学习 Flutter。我非常喜欢久经考验、有端到端的实例的教程 (think Digital Ocean 或者甚至 Auth0 教程)。端到端，细致的，高质量的例子一直是新技术吸引我的方式，因为我可以看到基本能够正式上线的代码，并且确信我在使用正确的方式实现功能。我也想做同样的事，所以我决定写 Flutter 的教程。

有了这些目标之后，我决定最适合我的 app 是重写一个我已经发布到 App store 上的 iOS app。 Steady Calendar ([homepage](https://www.steadycalendar.com), [Product Hunt](https://www.producthunt.com/posts/steady-calendar)), 是一款 [我的妻子 Irina](https://www.behance.net/irinamanning) 和我设计和开发的习惯养成器。我们是在几年前生活在柏林时开发的。从那时候以来，这个产品使我们为设计、实现和发布帮助他人养成健康习惯的产品而着迷。

把这个 iOS app 迁移到 Flutter 花了我一到两个月的空闲时间。这使我可以毫无压力地写出优秀的 Flutter 教程。

很酷的是我可以把以下内容包括在我的教程中，因为我在 app 中实现了它们：
      
*   登录之前的介绍。
*   Facebook / email 注册与登录。
*   展示日历的网格 view ，用户可以在完成一个目标之后高亮某一天。
*   iOS 与 Android 用户都熟悉的跨平台表单。
*   使用 [Scoped Model](https://pub.dartlang.org/packages/scoped_model) 的 Redux 风格的状态管理。
*   具有栈、定位元素、图像和按钮的自定义 UI。
*   列表 view。
*   简单、多语言、国际化的 UI。
*   跨平台导航栏，同样是 iOS 和 Android 用户都很熟悉的。
*   具有全局样式的控件。
*   集成测试。
*   把 app 提交到 Apple 应用商店。
*   把 app 提交到 Google Play 商店。

### 2. 目前为止关于 Flutter 的想法

我已经在后端和 webapp 开发方面有了 17 年以上的经验，其中的 4 年我重度参与了 iOS 开发，并且在上一年，我需要花很多的工作时间在React Native 上 (去年也发布了一些 React 项目）。

**以下是在学习 Flutter 时出现的想法：**

1.  **开发者体验**, 开发者的团体精神和给我的支持十分惊人。从 Stack Overflow， Google Groups 到博文的所有东西质量都很高，因为人们对 Flutter 非常有热情。 Google 工程师在日常工作之外，还愿意花很多时间在 Google Groups 上回答问题，这就形成了一个了不起的社区。他们在和 各种背景的工程师合作时表现得非常礼貌、非常专业，而其他很多公司就不见得是这样。开发者社区非常热闹，成员们非常积极，并提供深思熟虑的答案。文档也非常出色。库非常稳定，Flutter 是基于 Dart 的，而这个语言已经存在了多年，易于学习，并且久经考验。总而言之，开发者体验很棒。
2.  如我所预期的， **使用 Dart 的第三方库还相对稀少**。但这些并不说明 Dart 不适合使用，至少在我的经验中不是这样。**我们需要的特性中 95% 已经可以使用了**，仅有的例外是第三方的分析工具，但是对 HTTP 简单封装一层即可完成这个功能。
3.  **Material Design 控件**, Flutter 框架包含了大量的这些东西。它适合迅速开发简单的 app，但对于专业的、跨平台的 app，它会使 iOS 用户感到陌生。我不能把 Material Design 控件呈现给我的 iOS 用户，因为这将使他们对我的 app 感到陌生。Flutter 当然提供一系列的 iOS 控件，但这些东西都还不够完整。幸好，我开发的 Steady app 中的大多数控件已经是自定义的了。对于表单之类的东西而言，这还是很有挑战的。所以最后，文档、示例和整个 Flutter SDK 都很依赖于 Material Design。这很好，但对于像我这样的人而言，还需要更多的平衡。
4.  **在 Flutter 中开发自定义 UI 非常顺畅**。在被 CocoaTouch / iOS宠坏之后，我有了非常高的标准。在接触了大量 Flutter 代码并比较了开发自定义 UI 的经验后， **Google 团队确实做得很好**。当然，有一些控件让我觉得过于复杂，会使学习曲线过于陡峭，但这不是很大的问题。在写完一个真正的 app 之后，人们将很快能够察觉最关键、最常用的控件有什么特征 （嘿，我将在将来的教程中包括这部分内容）。
5.  作为一个 iOS 用户，我花了几个月的时间开发最初的 iOS app Steady Calendar, **我将永远不会忘记第一次在实体的安卓设备上运行它时的激动之情**。我猜这是因为我总是特别不喜欢其它跨平台移动框架。如果你花了数月的空闲时间，辛辛苦苦开发了一些东西，发现你可以在两个主要平台上运行它，你将会迷上它。这对于很多人来说可能并不是有帮助的反馈，但我反正需要分享我的看法！
6.  **开发跨平台 app 将会让你遇到更多的设计挑战** 但这和 Flutter 本身真的没有太多关系，这主要是关于跨平台开发的。 当你计划开发一个 Flutter app 时，要确保你有一个好的设计师和好的自定义 UI，否则你就要准备好根据情况判断你的 app 是该使用 Material Design 还是 Cupertino 控件了。在前一种情况下，这和 Flutter 的关系较小，而和开发跨平台 app 本身的挑战关系更大。你需要确定 UI 对于 Android 和 iOS 的用户而言都很好看，而且他们都能习惯它。
7.  **学习和使用 Dart 非常愉快**。我喜欢它和 TypeScript 或 Flow 相比的稳定性和可靠性。说得具体一点，我有一些 React 方面的背景，并在过去几个月的日常工作中大量（非常大量）学习 React Native。我也有多年使用 Objective-C 然后是 Swift 的经验。 Dart 是一口新鲜的空气，因为 **并不试图变得过于复杂，并且有可靠的核心库和包**。说真的，我认为哪怕是高中新生也可以使用 Dart 完成基本的编程。我听见很多人抱怨说他们需要学习一种新的语言，但对于 Dart 而言只需要一两个小时，最多一天就够了。
8.  **Flutter很棒。** 它并不是完美的，但按照我个人的观点，它的学习曲线，易用性，可用的工具使它成为了比我以前用过的所有框架都更好的移动开发框架。

### Google 应该做什么

1.   Google 的团队成员和朋友们应该在 Google Groups 中**继续提供有内涵、友好和即时的支持**。这是一个很大的加分项，也是使得该框架在易用性和支持方面如此出色的原因。支持和培育开发者社区的团队 **心态良好、令人喜爱，而且这是很重要的**。
2.  Get a poll from community members to see which Widgets may simply not be useful. **For the not so useful Widgets, just remove them from documentation tutorials** or deprecate them altogether. For example, the ‘Center’ widget is nice for a Hello, World container but I never understood it. Why can’t ‘Container’, something that’s way more prevalent have a property to do the same thing? This is a super trivial example but I think that’s part of the reason why Go was so successful, because it’s core library was simple and lean (and stayed lean).
3.  **Devote more focus on iOS users.** Material Design is great to get going quickly or if you’re only building something for Android users. I’d never use Material Design in an iOS app. With that said, I’ve found Flutter to be a nicer, less complex developer experience than learning Swift and all the one million library features one has to know to write iOS apps nowdays. I think a lot of iOS users would love to learn Flutter if Flutter had just even a bit more iOS style widgets.
4.  **More tutorials** on building realistic features and screens. I’d love to see more tutorials like this one: [https://flutter.io/get-started/codelab/](https://flutter.io/get-started/codelab/) but also “end to end” ones, where an example of integration with a backend is shown.
5.  **Theming apps** should be **less focused on Material Design**. Again, I don’t want to use the ‘MaterialApp’ widget if I’m writing an iOS app. Theming seems tightly coupled to this and it should be more generic.
6.  **Less prevalence of Firebase in the documentation** or pushing it so often. I realize Firebase really useful to get going fast and it helps bolster the approachability for new developers, but a significant amount of folks out there already have a backend ready or would not ever consider using Firebase. So I think more emphasis on how to work with simple web services and JSON would help. I had to read a lot of third party tutorials on this because I felt the documentation wasn’t realistic enough. I can elaborate when I write a future blog post about this.

So far, I’m super happy with Flutter overall.

Next, I’m going to consider re-writing another iOS I have in the app store, [www.brewswap.co](http://www.brewswap.co) that’s more complex (Tinder-style photo swiping, real time chat, etc).

So far, those are the main takeaways I can think of for now. Like any framework, there are a lot of quirks and learning curve issues but really overall, **Flutter is something I feel like I can really invest in and most importantly, really enjoy using**.

Stay tuned for some initial Flutter tutorials and I hope I was able to give some insight for anyone considering making the investment in Flutter — I’d say, go for it!

For anyone with questions on insight, etc, it’s better to just [**ping me on Twitter**](https://twitter.com/seenickcode) **@seenickcode.**

**UPDATE**: [Sign up](https://mailchi.mp/5a27b9f78aee/practical-flutter) and get notified about my upcoming Flutter course, Practical Flutter. 🚀

Happy Fluttering.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
