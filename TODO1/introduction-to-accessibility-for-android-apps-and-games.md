> * 原文地址：[Android 应用和游戏的辅助功能介绍](https://medium.com/googleplaydev/introduction-to-accessibility-for-android-apps-and-games-d0e7af5384d)
> * 原文作者：[Maxim Mai](https://medium.com/@maximfmai?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-accessibility-for-android-apps-and-games.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-accessibility-for-android-apps-and-games.md)
> * 译者：
> * 校对者：

# Android 应用和游戏的辅助功能介绍

## 如何定制应用和游戏的设计以改善用户体验

![](https://cdn-images-1.medium.com/max/800/0*C2kWfqX8bsbps-ME.)

虽然我们的目标是设计和开发迎合广大受众群体的应用，但我们不应该忘记，有些人使用Android和Google Play可能存在某种形式的残疾。据 [世界卫生组织](http://www.who.int/disabilities/world_report/2011/report/en/) 估计，世界人口的15％，大约10亿人，经历了一些影响听力，视觉，认知和运动功能的残疾。这可能会影响这些用户与技术进行互动的方式，对于我们在Google Play和Android中使用他们最喜爱的应用和游戏感到欢迎和舒适的人来说，这一点非常重要。

我们经常认为残疾是永久的或能力的持续恶化，但通常情况下会影响每个人的情景或临时无障碍需求。只有一只手抱着婴儿，从手术中恢复过来，或者只是骑自行车，都代表了可以通过使用良好设计来改善和适应的情境无障碍需求。

在Android和Google Play上，我们致力于为开发者提供工具，指导和支持，以便为尽可能多的人推广包容性体验。我们最近还在Play商店中策划了[collection of accessibility-related apps](https://www.google.com/url?q=http://play.google.com/store/apps/topic?id%3Dcampaign_editorial_300324a_accessapps18&sa=D&source=hangouts&ust=1526630727446000&usg=AFQjCNFT86-9N1DrImf9arznkRQ-QdarXA) 。看看这些令人敬畏的应用程序，因为我们很自豪能够在Android和Google Play上发布这些应用程序！

一些Android开发者也已将可访问性体验提升到一个新的水平，特别是满足残疾人的需求。让我们深入了解一下我们可以从他们的应用和游戏中学到什么。

### 简单的步骤，使您的应用程序和游戏更容易访问

无论您是专门针对辅助功能使用案例构建应用程序，还是正在努力让您的应用程序或游戏对残疾人士更具包容性，我们都会为您提供支持。

我们已经为Android开发人员创建了可 [accessibility](https://developer.android.com/guide/topics/ui/accessibility/) 资源，您将在其中找到关于该主题的简单介绍，以及 [using material design to support accessibility needs](https://material.io/guidelines/usability/accessibility.html), 最佳实践。 [developing more accessible apps](https://developer.android.com/guide/topics/ui/accessibility/apps).

您可以确保您的应用 **正确标记用户界面元素** 以便让使用屏幕阅读器的用户（例如“话语提示”）更清楚地听到内容。同样，您可以考虑在屏幕上对您的内容进行分组，以便那些有视力障碍的人可以快速高效地浏览您的应用。

有些人可能在与小型触摸控制器交互时遇到困难，因此请记住提供 **更大的触摸目标**。这可能会让很多人浏览您的应用程序变得更容易。颜色和对比度是另外两个可能影响大部分观众的区域。**避免**前景色和背景色之间的低对比度是另一种最佳做法，同时确保用户界面元素清晰可辨，适用于色盲。

添加视频和音频内容或说明可以确保听力受损的人可以访问您的应用。考虑提供**切换字幕**的选项，并且如果通过视频给出指令，请考虑以其他格式提供相同的指令。

这些都是简单步骤的示例，您可以按照这些步骤使您的应用更具包容性，但它们绝不意味着作为详尽的清单。我们将在今年夏天晚些时候进行深入研究，以提供关于可访问设计和开发的更多提示。

### 三个关注可访问性的应用程序

这些应用程序和游戏为残疾人士在日常生活中提供访问和利用移动技术的机会。

[**做我的眼睛**](https://play.google.com/store/apps/details?id=com.bemyeyes.bemyeyes)

你多久会帮助有需要的陌生人？“我的眼睛”背后的团队正在利用Android的全球规模，挖掘人类慷慨和社区意识的力量，目标是让盲人和低视力人士过上更加独立的生活。

无需任何费用，该应用程序通过视频通话让盲人或弱视用户与视力不佳的志愿者相匹配，他们可以提供帮助，例如帮助在新环境中进行定位，阅读标签或控件，区分颜色以及执行更多任务等。

![](https://cdn-images-1.medium.com/max/800/0*ZWrIIDxpH76qNmfL.)

视力受损的用户准备打电话给有视力的志愿者

由于超过 [253 亿的](http://www.who.int/en/news-room/fact-sheets/detail/blindness-and-visual-impairment) 视力障碍患者中绝大多数生活在中低收入国家，因此在应用中添加更多本地语言并提高翻译质量非常重要。您也可以通过 [参与翻译项目来提供帮助](https://crowdin.com/project/be-my-eyes-android).

[**芝麻开门**](https://play.google.com/store/apps/details?id=com.sesame.phone_nougat)

触摸屏革新了手机，因为它们可以在手持设备上提供直观的导航。然而，对于由脊髓损伤，多发性硬化症，ALS和神经退行性疾病导致的数百万患有严重灵活性障碍的人而言，可能需要不同的相互作用模型。

结合先进的计算机视觉技术和语音控制功能，Open Sesame允许任何可以控制头部移动的人完全免提使用Android手机或平板电脑。该应用程序通过注册Android无障碍服务来实现这一目标，以便人们可以控制整个操作系统，通过Play商店下载应用程序，以及玩任何游戏和控制连接的家庭设备和服务。

![](https://cdn-images-1.medium.com/max/800/0*xPVd0S0KMl_mN3Cn.)

电机受损用户使用头部移动控制Android手机

许多美国州政府提供补贴，让更多符合条件的人士可以获得开放式芝麻的魔力。Sesame Enable团队正在努力增加这些计划的数量，并乐意通过补贴流程 [引导新用户](https://sesame-enable.com/get-help-with-state-benefits/) 

[**音频游戏中心2.0**](https://play.google.com/store/apps/details?id=com.AUT.AudioGameHub)

位于新西兰奥克兰的Sonar Interactive团队擅长利用语音，声音和音乐为有视力和无视力的用户制作游戏。这个想法是为世界各地带有视觉障碍的人带来视频游戏社区的乐趣和感觉。

音频游戏中心是由11个独立游戏组成的集合，包括炸弹解散者，射箭，武士锦标赛和狩猎。许多人可以在同一台设备上由多个玩家玩，以实现协作和竞争性体验，让视力和视力受损的朋友参与其中。

![](https://cdn-images-1.medium.com/max/800/1*2lC2yhviSS9fjtcju9TVHA.png)

射箭比赛正在进行中，瞄准以声音为指导

该团队不断在游戏领域进行创新。Checkout Animal Escape是Audio Game Hub的最新成员，今天推出并可在Play商店中使用。

### 一款有用的开发者工具，用于测试您的应用和游戏的可访问性

测试您的应用程序的可访问性是您开发过程的关键组成部分。我们发布了 [入门指南](https://developer.android.com/training/accessibility/testing#top_of_page)，强调了结合手动，用户和自动化测试的重要性，以发现可能会错失的可用性问题。

在 [谷歌无障碍扫描仪](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor) 使用的 [辅助测试框架](https://github.com/google/Accessibility-Test-Framework-for-Android) ，并提出您的手机上安装，而不需要技术技能的任何Android应用程序的改进。它在查看内容标签，可点击项目，对比度等内容后提供可操作的建议。

例如，内容标签提供了有用的描述性描述，向人们解释每个互动元素的含义和目的。这些标签允许屏幕阅读器（如TalkBack）正确解释可能依赖这些服务的特定控件的功能。

![](https://cdn-images-1.medium.com/max/800/1*aAcJvQ75gLoECAO5grbCLA.png)

辅助功能扫描程序已打开并准备好分析任何应用程序

虽然我们希望您会使用Accessibility Scanner来改善您自己的应用程序的可访问性，但它也允许您向其他开发人员提供可访问性改进建议。

我们已经与那些在这个领域取得重大进展的人分享了一些例子，并希望我们提供的资源的提示和链接将帮助您为每个想要使用您的应用或游戏的人创造更好的体验。无论您是专门为残障人士创建应用程序，还是试图与所有感兴趣的人分享您的应用程序或游戏，这些洞察力都有希望提供一些灵感和良好的起点。正如我们上面提到的，它们绝不是详尽无遗的，在开发，设计和开始构思应用程序或游戏时，仍然有许多考虑因素可以帮助每个人更容易访问和享受。看看我的下一篇文章，它将深入探讨无障碍开发，并记得检查一下与此同时，Play商店中的 [新可访问性收藏](https://www.google.com/url?q=http://play.google.com/store/apps/topic?id%3Dcampaign_editorial_300324a_accessapps18&sa=D&source=hangouts&ust=1526630727446000&usg=AFQjCNFT86-9N1DrImf9arznkRQ-QdarXA) 

* * *

### 你怎么看?

D你有没有想过设计可访问性的应用程序？请在下面的评论中告诉我们，或者使用#AskPlayDev发微博，我们会回复 [@GooglePlayDev](http://twitter.com/googleplaydev), 我们会定期分享有关如何在Google Play上取得成功的新闻和提示。.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
