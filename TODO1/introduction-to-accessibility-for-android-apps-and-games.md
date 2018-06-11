> * 原文地址：[Android 应用和游戏的辅助功能介绍](https://medium.com/googleplaydev/introduction-to-accessibility-for-android-apps-and-games-d0e7af5384d)
> * 原文作者：[Maxim Mai](https://medium.com/@maximfmai?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-accessibility-for-android-apps-and-games.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-accessibility-for-android-apps-and-games.md)
> * 译者：
> * 校对者：

# 安卓应用和游戏的无障碍开发介绍

## 如何定制应用和游戏的设计以改善用户体验

![](https://cdn-images-1.medium.com/max/800/0*C2kWfqX8bsbps-ME.)

虽然我们的目标是设计和开发迎合广大受众群体的应用，但我们不应该忘记，使用安卓和 Google Play 的用户中还有一些是残疾人。据 [世界卫生组织](http://www.who.int/disabilities/world_report/2011/report/en/) 估计，世界人口的15％，大约10亿人，有不同程度的听力，视觉，认知以及运动功能方面的残疾。这会影响他们与科技之间进行互动的方式，认识到这点对我们来说很重要，因为我们要让每个人在 Google Play 和安卓上使用他们最喜爱的应用和游戏时都感到幸福和舒适。

我们通常认为残疾是永久性或者持续性的能力缺陷，但经常也会有阶段性的或临时的无障碍需求影响我们每个人。比如，有些情况下我们只有一只手可以用，例如抱着孩子，或者刚做完手术，或者骑自行车，这些都是特定情境下的无障碍需求，可以通过优秀的设计来改善和适应。

在安卓和 Google Play 上，我们为开发者提供开发工具，开发指导和支持，以便为尽可能多的人群提供包容性的体验。我们最近还在 Play 商店中策划了[收集无障碍相关应用](https://www.google.com/url?q=http://play.google.com/store/apps/topic?id%3Dcampaign_editorial_300324a_accessapps18&sa=D&source=hangouts&ust=1526630727446000&usg=AFQjCNFT86-9N1DrImf9arznkRQ-QdarXA) 。使用这些非常棒的应用程序吧，我们确实非常自豪在安卓和 Google Play 上能够发布这些应用程序！

一些安卓开发者也已将无障碍体验提升到一个新的水平，特别是满足残疾人的需求。让我们深入了解一下我们可以从他们的应用和游戏中学到什么。

### 简单的步骤，使您的应用程序和游戏更容易被访问

无论您是专门针对无障碍用例构建应用程序，还是正在努力让您的应用程序或游戏对残疾人士更具包容性，我们都会为您提供支持。

我们已经为安卓开发人员创建了可用于 [无障碍](https://developer.android.com/guide/topics/ui/accessibility/) 开发的资源，您将在其中找到关于该主题的简单介绍，以及连接 [使用教程设计来支持无障碍的需求](https://material.io/guidelines/usability/accessibility.html) 和最佳实践 [开发更多的无障碍应用](https://developer.android.com/guide/topics/ui/accessibility/apps).

您可以确保您的应用 **正确地标记用户界面元素** 以便让使用屏幕阅读器的用户（例如“语音提示”）更清楚地听到内容。同样，您可以考虑在屏幕上对您的内容进行分组，以便那些有视力障碍的人可以快速高效地浏览您的应用。

有些人可能在与小型触摸控制器交互时遇到困难，因此请记住提供 **更大的触摸目标**。这可能会让很多人浏览您的应用程序变得更容易。颜色和对比度是另外两个可能影响很多用户的方面。**避免前景色和背景色之间的低对比度**是另外一种最佳做法，同时要确保对于色盲用户来说，用户界面的元素颜色可以很清晰的分辨。

添加视频和音频内容或指令可以确保听力受损的人可以访问您的应用。考虑提供**切换字幕**的选项，并且如果是通过视频给出指令，请考虑用多种样式提供相同的指令。

这些都是简单步骤的示例，您可以按照这些步骤使您的应用更具包容性，但这绝不意味着做到这些就足够了。我们将在今年夏天晚些时候发表更加深入的文章，以提供关于无障碍设计和开发的更多建议。

### 三个聚焦无障碍的应用程序

这些应用和游戏给与残疾人士在日常生活中访问和利用移动技术更多的机会。

[**做我的眼睛**](https://play.google.com/store/apps/details?id=com.bemyeyes.bemyeyes)

你多久会帮助有需要的陌生人？“做我的眼睛”的背后团队正在利用 Android 的全球规模，挖掘人类慷慨和社区意识的力量，旨在让盲人和弱视人群过上更加独立的生活。

无需任何费用，该应用程序通过视频通话让盲人或弱视人群与视力正常的志愿者相匹配，他们可以提供帮助，例如帮助在新环境中进行定位，阅读标签或控件，区分颜色以及执行更多任务等。

![](https://cdn-images-1.medium.com/max/800/0*ZWrIIDxpH76qNmfL.)

视力受损的用户准备打电话给视力正常的志愿者

由于超过 [253 亿](http://www.who.int/en/news-room/fact-sheets/detail/blindness-and-visual-impairment) 的视力障碍患者中绝大多数生活在中低收入国家，因此在应用中添加更多本地语言并提高翻译质量非常重要。您也可以通过 [参与翻译项目来提供帮助](https://crowdin.com/project/be-my-eyes-android).

[**芝麻开门**](https://play.google.com/store/apps/details?id=com.sesame.phone_nougat)

触摸屏革新了手机，因为它们可以在手持设备上提供直观的导航。然而，有数百万人因为脊髓损伤，多发性硬化症，ALS和神经退行性疾病等导致患有严重的运动障碍，对于他们可能需要不同的交互形态。

结合先进的计算机视觉技术和语音控制功能，芝麻开门应用允许任何人只通过控制头部移动而完全不使用手就可以使用 Android 手机或平板电脑。该应用程序通过注册Android 无障碍服务来实现这一目标，以便人们可以控制整个操作系统，通过 Play 商店下载应用程序，并能玩游戏以及控制连接的家庭设备和服务。

![](https://cdn-images-1.medium.com/max/800/0*xPVd0S0KMl_mN3Cn.)

运动障碍用户使用头部移动控制安卓手机

许多美国州政府提供补贴，让更多符合条件的人士可以体验芝麻开门的魔力。芝麻开门的团队正在努力增加这些计划的数量，他们很乐意通过补贴流程 [引导新用户](https://sesame-enable.com/get-help-with-state-benefits/) 

[**音频游戏中心 2.0**](https://play.google.com/store/apps/details?id=com.AUT.AudioGameHub)

位于新西兰奥克兰的声纳互动团队擅长利用语音，声响和音乐为有视力和无视力的用户制作游戏。这个应用是把视频游戏社区的乐趣和感觉带给世界各地有视觉障碍的人群。

音频游戏中心是由11个独立游戏组成的集合，包括炸弹解散者，射箭，武士锦标赛和狩猎。许多游戏可以由多个玩家在同一个设备上一起玩，以实现协作和竞技体验，让视力正常和视力受损的朋友都能参与其中。

![](https://cdn-images-1.medium.com/max/800/1*2lC2yhviSS9fjtcju9TVHA.png)

射箭游戏正在进行中，通过声音指导用户瞄准

该团队不断在游戏领域进行创新。Animal Escape 是音频游戏中心的最新成员，现在已经在 Play 商店中上线，可以下载使用。

### 一款有用的开发者工具，用于测试您的应用和游戏的无障碍功能

测试您的应用程序的无障碍功能是您开发过程中的的关键部分。我们发布了 [入门指南](https://developer.android.com/training/accessibility/testing#top_of_page)，强调了结合手动，用户和自动化测试的重要性，以发现可能会遗漏的无障碍问题。

[谷歌无障碍扫描程序](https://play.google.com/store/apps/details?id=com.google.android.apps.accessibility.auditor) 使用了 [无障碍测试框架](https://github.com/google/Accessibility-Test-Framework-for-Android) ，并会对您手机上安装的任何安卓应用提出改善建议，而这不需要任何技术能力。它通过查看内容标签，可点击项目，对比度等内容后会提供可行的建议。

例如，内容标签提供有用的描述，向人们解释每个交互元素的含义和目的。这些标签允许屏幕阅读器（如 TalkBack）来向那些需要这些服务的人正确解释出这些功能的特殊控制方法。

![](https://cdn-images-1.medium.com/max/800/1*aAcJvQ75gLoECAO5grbCLA.png)

无障碍扫描程序已打开并准备分析应用程序

我们希望您会使用无障碍扫描程序来改善您自己的应用程序的无障碍性，而且它也允许您向其他开发人员提供无障碍的改进建议。

我们已经从那些在这个领域取得重大进展的人那里分享了一些实例，并希望我们提供的建议和资源链接可以帮助为每个想要使用您应用或游戏的人创造更好的体验。无论您是专门为残障人士创建应用程序，还是试图与所有感兴趣的人分享您的应用或游戏，希望这些观点可以给您提供一些灵感和良好的开端。正如我们上面提到的，它们绝不是详尽无遗的，在开发，设计和开始构思应用程序或游戏时，仍然有许多考虑因素可以帮助提高无障碍的体验。看看我的下一篇文章，它将深入探讨无障碍开发，同时请记得看一下 Play 商店中的 [新的无障碍收藏夹](https://www.google.com/url?q=http://play.google.com/store/apps/topic?id%3Dcampaign_editorial_300324a_accessapps18&sa=D&source=hangouts&ust=1526630727446000&usg=AFQjCNFT86-9N1DrImf9arznkRQ-QdarXA) 

* * *

### 你怎么看?

D你有没有想过设计可访问性的应用程序？请在下面的评论中告诉我们，或者使用#AskPlayDev发微博，我们会回复 [@GooglePlayDev](http://twitter.com/googleplaydev), 我们会定期分享有关如何在Google Play上取得成功的新闻和提示。.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
