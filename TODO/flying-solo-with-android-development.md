> * 原文地址：[Flying Solo with Android Development](https://hackernoon.com/flying-solo-with-android-development-c52d911b62bf#.yhgjjtwz1)
> * 原文作者：[Anita Singh](https://hackernoon.com/@anitas3791?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Boiler Yao](https://github.com/boileryao)
> * 校对者： [gaozp](https://github.com/gaozp) 、[tanglie1993](https://github.com/tanglie1993)
# 一个人的 Android 开发 #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*gqA2o9GN2tU2xaIMuddXJg.jpeg">

Photo credit : [http://www.magic4walls.com/crop-image?id=14269](http://www.magic4walls.com/crop-image?id=14269) 

两年半之前，在一个由四个人组成的 Android 团队的帮助下，我开始从后端开发转向移动开发。一年之后，我加入了一个已经完成了B轮融资的初创公司，在那里主要做 Android 开发的工作。在一个小团队里工作，既能很好地保持独立，还不耽误向同事学习。

但随后，五个月前，我从原本的小团队跳槽到了一个“根本没有团队”的地方，我去的这家是刚刚成立的创业公司，只有六个人，而我是其中 **唯一的** Android 工程师。在这个新的岗位，我从零开始完成了 [Winnie](https://winnie.com/)，这个 APP 最近已经[发布](https://winnie.com/android) 了！

结果证明这是一个大飞跃。单飞一直是一个挑战，但它也带来了很多回报。一路走来，我发现独自工作是有利有弊的。不过最重要的是，你可以做一些事情来帮助自己走向成功。这里有一些目前为止已经帮到我的策略。

#### **跟社区保持接触 业余不忘充电** ####

对单飞的担心之一是，我已经习惯了以前的角色，担心没有人能一起讨论新的想法并且给我出主意。

好消息是有很多在线资源可以拓展你的知识和视野。 从 [**DroidCon**](https://twitter.com/droidcon?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor) 、 [**360|AnDev**](http://360andev.com/) 这样的开发者大会上的在线分享，到 [**Fragmented Podcast**](http://fragmentedpodcast.com/) 、 [**Android Dialogs**](https://www.youtube.com/channel/UCMEmNnHT69aZuaOrE-dF6ug/videos)  和 [**Android Weekly**](http://androidweekly.net/) 这样的时效性很高的网站，你有很多方法来拓展自己的想法。

我个人最喜欢的是 [**Caster.io**](https://caster.io/) —— 代码示例加上简短的解说视频让我随时脉动回来！ 线下聚会或者 [**AndroidDev subreddit**](https://www.reddit.com/r/androiddev/) 、 [**Google+ communities**](https://plus.google.com/communities/105153134372062985968) , Slack groups 和 Twitter 这样的社区对于继续讨论和解疑释惑，都是很好的去处。

#### **审查之前提交的代码 保持高标准** ####

我特别建议打开提交记录来审查自己的代码。在自己的提交下评论可能看上去很傻，但是我认为如果你一个人工作的话，这是个很好的习惯。这一点在 [一个跟 Android 相关的对话节目系列](https://www.youtube.com/watch?v=CtxBO9zq7vQ) 中也有讨论。

我用 GitHub 自带的预览功能完成第一步，之后把它放一边然后过一段时间再来查看。我尽全力来审查自己的提交，就像我审查同事的代码一样，来确保我用同样严格的标准要求自己。回过头看自己的代码还**有助于发现 bug 和错误的边界情况处理，以及让你的代码保持统一和整洁。**

#### **一个“不好的”模式通常比没有模式要好** ####

你不得不做出很多决定 —— 应该使用 [MVVM](https://upday.github.io/blog/model-view-viewmodel/) 、 [MVP](https://medium.com/upday-devs/android-architecture-patterns-part-2-model-view-presenter-8a6faaae14a5#.vcztbt47h) 、[Flux](http://lgvalle.xyz/2015/08/04/flux-architecture/)，还是其它的架构模式？使用 Fragment 还是 ViewGroup？哪些应该是抽象的而哪些不应该是？

项目开始的时候，一开始的时候使用一种模式，之后意识到另一种模式更好，并由此带来一些模式的重构和去除并不是一件新鲜事。

虽然在某些情况下打破你的模式是有意义的，但是当你发现更好的东西时，最好留心去重构并且改变之前的代码来使整体保持一致。这可能听起来很明显但是仅仅把新的模式用到新的代码中更为简单，所以当你一个人工作的时候可能会倾向这么干。但是这样会在你察觉到之前迅速让你的代码变得蜜汁混乱！**即使这个模式并不是很棒，保持代码的一致性会让之后的修补变得更容易**。

#### **墙裂建议使用Kotlin** ####

除非你是从头开始，不然的话，考虑一下在下一个你将要写的类里试试吧。

我最终没有在 Winnie 中使用 [Kotlin](https://kotlinlang.org/) ，因为我当时没有经验所以对这个想法不够自信，加之不想打击团队中的 Java 后端工程师向代码库中贡献代码的热情。

然而，在看过 [Christina的关于 Kotlin 的演讲](https://www.youtube.com/watch?v=mDpnc45WwlI)  并且做了一些研究之后，**如果能重来，我至少会试试这门语言**。 Kotlin 有很多优点 —— 即使只是防止 null pointer 引起的异常和不与 Java 笨拙的模式化代码同流合污（Kotlin 的语法比 Java 要精炼得多 —— 译注）就让我佩服得五体投地。 Jake Wharton 的 [这个讲座](https://realm.io/news/oredev-jake-wharton-kotlin-advancing-android-dev/) 是个很好的学习 Kotlin 的起点。

#### **掌握自己的代码 不要过分依赖第三方库** ####

我记得在 MVP 中，曾经花费过很多时间选择一个库来用，因为这些库实在是太多了。被丰富的选择惯坏是个很大的问题，最终我自己造了个简单的轮子，用得很开心。

当选择用哪个第三方库的时候，我建议考虑好你是否真的需要它以及它会对你未来的开发造成哪些限制 —— 它会为单元测试增加难度吗？它会限制使用 Android 自带的特性吗，比如多屏之间的过渡动画之类的？它的开发是不是仍然很热火朝天并且有很多 APP 使用它？这些考虑让我好好权衡并做出决定。

**我建议在尽可能保留掌控的情况下去优化，而无须重新造轮子** 虽然有个库已经几乎包含所有的东西了，但是自己去实现一些东西会更好。（使用第三方库的基础组件，自己根据需要进行组合。—— 译注）

#### **规划好测试（Testing）和辅助功能（Accessibility）** ####

如果你接手的项目是从头开始，那么你**现在就可以去做了**！不然的话，你可以在接下来你写的代码中这样做。

面对张牙舞爪的 deadline，测试和辅助功能往往是下等公民。而你把一旦它们的优先级放得很低，由于没有其他人跟你分担，你就更难找到时间去实现它们了。

我承认，我自己只是才开始做这方面的工作。但通过使用依赖注入，MVP 模式，只暴露 Model 对象的接口到 UI 等等方法来在脑海中写测试代码，来达到更容易测试的目标。从项目开始的时候，每次提交之后，我都会同时在 [**CircleCI**](https://circleci.com/) （一个持续集成和发布的平台 —— 译注）上进行编译，以便进行简单的检查和运行测试。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*IlMGg4Voi3RcLi7sjVQP0g.gif">

对于辅助功能（Accessibility），我在任何可以的时候都添加上内容描述，并且在发布前使用  [**Accessibility Scanner**](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor&hl=en) 来找出我接下来还需要做哪些这方面的工作。毫无疑问还有更多的工作要做，但这是个不错的开始。Kelly Schuster 的 [这个演讲](https://realm.io/news/kelly-shuster-android-is-for-everyone/) 给出了一些可行的建议使得开发者可以让自己的 APP 变得对有缺陷的人群更友好。

如果时间不允许来编写测试，那就人工测试就很方便了。比如，在一个文档中为每一个特性写下不同的测试案例（正面的、反面的），确保在每次发布前进行这些测试。**为自己定下编写测试和进行 Accessibility 改进的 deadline，不然你可能永远也完成不了它们**。

#### **告诉你的 iOS 设计师他们是错的 自己寻求到 Android 设计的转换 :-).** ####

不要因为支持你的平台上的正确的事情而担心！当你一个人干的时候，你有责任带着别人跟上最新的 Android UI 模式和代码库的发展速度。

我工作中通常得到的是 iOS 系统上的截图，但是使用 [Material 设计规范](https://material.io/guidelines/) 和一些优秀 Android APP 作为资源来把那些设计转换到 Android 里面。还有，没有什么比引用官方的 Material Design 文档更适合来说服别人了！

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*xFUdWXDI9s_aHY949_vZ8w.gif">

至于代码库，在我的 CEO 来帮忙的几个月内，我向她普及了我们的架构和 MVP、Dagger2、RxJava2 之类的概念。我建议保持向周围的人进行 Android 概念的传教，因为**向别人解释你的决定或者教给他们一个新的概念帮助你真正得掌握这个概念，有时还会让你意识到自己的错误。**

#### 尽早发布 beta 版 ####

如果你的 APP 还没有上线或者在现有的基础上进行了重大的变化，这条会很适用。Google play 有一个 [alpha 和 beta 频道](https://support.google.com/googleplay/android-developer/answer/3131213?hl=en)，在 beta 频道，你可以自由开关你的 beta 版本。

如果你在继续开发一个已经存在的 APP，你仍然可以平行地发布 beta 版，只要版本比当前的正式版高就好了。如果是开放的 beta 版，用户将可以通过在 play store 安装或者点击一些链接下载安装来使用。如果你要对变化进行小规模的测试， [staged-rollouts](https://support.google.com/googleplay/android-developer/answer/6346149?hl=en) 将会是个很合适的选择。

如果你在开发一个崭新的 APP，我建议**在上架前尽快开发出内测版，然后在这个内测版准备好了的时候把它转为开放的公测版。** 我们的第一个内测版只有很少的几个功能，但是它帮助我们及早发现了 bug，步入了周期性发布的正轨，并且获得了很有价值的反馈。这也让我们毫无压力并且可以平稳上线。

------

第一次单飞是个很好的学习经历，因为你**挑战自我**了，这是之前从未有过的。 你变得更加依赖自己、锻炼了对代码库的整体控制（或好或坏）、学习了更多自己喜欢的东西并且处理怪不得别人的错误（耶）。我曾经担心单飞，但是在上面的建议的帮助下，结果是一个很好玩的经历。我希望这些建议同样会对你有所帮助。

打算单飞或者和分享你的单飞经历？很高兴听到你们的声音。在原文下面评论或者 ❤ 这篇文章 或者到 [Twitter](https://twitter.com/anitas3791)上来找我。
