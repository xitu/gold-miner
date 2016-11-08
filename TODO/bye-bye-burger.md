> * 原文地址：[Bye, Bye Burger! What we learned from implementing the new Android Bottom Navigation](https://medium.com/startup-grind/bye-bye-burger-5bd963806015#.b1x3w6elg)
* 原文作者：[Sebastian Lindemann](https://medium.com/@S_Lindemann)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [Xiaonan Shen](https://github.com/shenxn)
* 校对者： [Jaeger](https://github.com/laobie), [jamweak](https://github.com/jamweak)

# 再见，汉堡菜单，我们有了新的 Android 交互设计方案

我清楚地记得 3 月 15日当那条新闻传来的时候我正在干什么——当我们正深陷于将我们 [Android 职位搜索应用](https://play.google.com/store/apps/details?id=com.xing.mpr.cep) 中的汉堡菜单抛弃，转而使用一种可见的标签式导航时，谷歌宣布将底部导航栏添加到 Android Material Design 的指导手册中，这个新闻快速传遍了 Android 社区，并且引发了关于底部栏的视觉效果以及功能性的 [热烈争论](https://plus.google.com/+LukeWroblewski/posts/ZgNUpC72FVt)。



![](https://cdn-images-1.medium.com/max/600/1*DEsoBD74AHj4Z6U4zdnSpA.png)

Android 底部导航栏。来源：[Material Design Guidelines](https://material.google.com/components/bottom-navigation.html#bottom-navigation-specs)



一开始，与其他人一样，我们的热情被完全浇灭了。选择谷歌扔给我们的这个全新的、没有经过验证的导航方式，而放弃我们努力了几个月的成果，让我们感到很恐慌。然而，我们还是决定在较短时间内为我们的 Android 应用发布一个新版本，成为最先使用新导航栏的应用之一。

移动设备上的导航栏和菜单一直都是一个热门话题，尤其是当 [汉堡菜单](https://blog.placeit.net/history-of-the-hamburger-icon/) 被引入，同时智能手机开始变成主要的信息消费设备。这种三条线的菜单变成了许多主要应用（如 Facebook、Spotify 以及 Youtube）的默认导航元素。但是因为这种导航方式将相关入口从用户视野中隐藏，使得其变得不那么优雅了。对于 iOS 应用来说，[底部标签栏](https://developer.apple.com/ios/human-interface-guidelines/ui-bars/tab-bars/) 作为一种全新的可视化导航栏，快速成为了苹果智能手机上实现一级导航栏的标准方式。

不幸的是，Android 应用缺少一种合适的底部导航栏解决方案，只给应用（比如我们的）提供了汉堡菜单。为了在不破坏 Material Design 指南的前提下使得导航栏依然可见，（太多的）应用开发者开始使用 [顶部标签导航栏](https://material.google.com/components/tabs.html)。虽然标签在简单的应用上工作良好，但是当需要使用二级导航或者有三个以上入口的时候，就会出现空间不足的问题。考虑到移动设备的 [“拇指区域（Thumb Zones）”](http://blog.experts-exchange.com/ee-blog/smartphone-thumb-zone/)，顶部空间也被认为是对于智能手机用户来说难以点击的区域，特别是与底部导航栏相比。

随着 Material Design 底部导航栏的引入，谷歌意识到了应用开发者所面临的挑战，并且提供了从用户的角度出发的解决方案，以实现一种脱离汉堡式的一级导航栏。这使得我们非常乐于使用它。

在决定使用底部导航栏之后，我们进入了最具有挑战性的部分——设计阶段。在大量的规范和动画中，我们不得不做出了一些 UX 和产品的重要决定：



![](https://cdn-images-1.medium.com/max/600/1*2HlX9ZSSHnQ5llC_o8dOOA.gif)

我们的底部导航栏



*   **滚动时隐藏：** 我们希望在用户的屏幕上显示尽可能多的内容。因此，我们决定在向下滚动的时候隐藏导航栏，从而给内容区域提供更多的空间。而向上滚动可以使导航栏重新显现。
*   **变换式导航栏：** Material Design 底部栏有一个非常平滑的动画，它参考了变换式导航栏——在不同目标间切换的时候，被选中的部分会被放大，同时未被选中的元素会被向后移动，从而在导航栏上浏览不同的目标就有点像在浏览一个旋转木马。我们决定要使用这种效果因为它使得切换导航目标变得更加有趣了。我们希望这可以推动我们的用户更多地在应用的不同功能组间切换。同时，该动画在我们的下一个观点中非常重要。



![](https://cdn-images-1.medium.com/max/600/1*uMnDyq7fTZ3KDu2BteuIxw.gif)

Android 的变换式导航栏。来源：[Material Design Guidelines](https://material.google.com/components/bottom-navigation.html#bottom-navigation-specs)



*   **Material Design 的外观和体验：** 我们希望这个底部导航栏尽可能地融入原生 Android 环境。这意味着在动画和视觉设计上投入更多。只有这样做我们才能够在我们的 Android 用户群中获得高接受度——我们最不希望看到的就是用户在与导航栏交互时怀疑他们在使用从一个 iOS 简单拷贝过来的应用。
*   **保存状态：** 使用底部导航栏的应用需要记住用户在每一个视图组都做了什么，这与汉堡菜单非常不同。因为可见的分组安排就是为了更快速和频繁的切换，所以每一个视图组的点击路径都应该被储存起来，这样用户就可以很方便地返回之前的任务。 相反的是，使用汉堡菜单的应用不会储存状态，当应用回到一个分组时，应用都会从视图的第一层级重新开始。基于你应用的基础结构，保存分组中的状态可能会成为一个巨大的技术难题，因此我建议尽早与你的开发团队讨论此事。
*   **减少分组的数量：** 当我们从汉堡菜单转换到底部导航栏的时候，我们只需要转换少量分组以便于管理，这样可以让我们更快完成设计和开发，同时也可以确保只给用户展示最重要的入口。这使得我们将设置的入口移动到了右上角的三点菜单中，而不是将它放在最重要的特性（如搜索，书签和推荐）旁边。我建议在确定将哪些功能放在导航栏中时应该尽量严格。如果你的应用有大量分组，底部栏可能会相对难以实现，并且你可能需要考虑将其中的一些合并或者重新排列。幸运的是，我们并不需要做这些。
*   **保持精干** 虽然你需要搞清楚你在新导航栏中想实现哪些特性，但更重要的是，不要在验证核心想法正确与否之前过分沉迷于细节。因此，我们底部导航栏的最小可行产品并没有包含大量的额外修饰。当然，我们最终将会把这些附加物加入我们的产品中，我们只是希望在一开始就能确认我们做的是否正确。我们甚至向一小部分用户发布了一个无法保存用户状态（详见之前的观点）的版本。我们在测试样本中看到了积极的数据后，才开始处理后续任务。

**需要注意的是，虽然谷歌的 [Material Design 指南](https://material.google.com/components/bottom-navigation.html) 可能为如何使用这种新导航栏提供了详尽的定义，你依然需要基于你自己的目标以及你应用的工作方式来做一些重要的决定。**

我们使用 [Google Play 分阶段发布](https://support.google.com/googleplay/android-developer/answer/6346149) 功能小心地铺开我们的新导航栏，以确保这个改变实现了我们预想的效果。幸运的是，我们很快确认了它做到了：

*   **增加了用户参与度：** 我们的用户变得更加积极，这使得我们的访问量显著增加了（PV 和 月活跃用户都有两位数的增长）。同时，我们的用户回访更加频繁了，这意味着新导航栏与用户形成了共鸣，从而提高了用户粘性（访客数量和月活用户都有接近两位数的增长）。
*   **应用各功能组访客数量增长了：** 重要的应用功能，像书签以及工作推荐，现在都在底部栏中可见了，并且从数据中反映出其使用量大大增加（进入这些功能组的用户数量有两到三位数的增长）。这个增长帮助我们更好地向用户展示我们独特的优点，同时也提高了整个产品的体验。
*   **无负面用户反馈** 到目前为止，无论是通过直接的用户反馈或者是通过应用评价，我们都没有收到过对于新导航栏的抱怨。而通过上述途径，我们可以看到很多正面的反馈。



![](https://cdn-images-1.medium.com/max/800/1*NArH9VWRmCHAd67OYR1hrw.png)

汉堡菜单 vs 无汉堡菜单：我们应用在导航栏改变前后的对比



我们从对新 Android 底部导航栏的冒险尝试中获得了回报，并且我们成功地达成了改善用户体验和 KPI 表现的目标。因此，如果你的应用还依赖于汉堡导航，我会强烈建议你去探索这个转换到可见导航栏的机会。当然，在开发上大量投入之前要先对需要改变的设计有一个初步的认识，从而对工作总量有一个更好的了解。

你可以 [从这里](https://play.google.com/store/apps/details?id=com.xing.mpr.cep) 查看我们最新版本的应用，最新版本中会有我们随后对底部导航栏的设计调整。这个应用是针对德国就业市场的，所以它可能不会有你所在地的完整职位列表。我欢迎任何的问题以及想法，并且期待你们的评论和邮件。

最后但同样重要的是，我想要对我们超棒的设计和开发团队（像 [Dema](https://twitter.com/demito29)，[Miguel](https://twitter.com/miguel_eedl) 和 [Cristian](https://twitter.com/cmonfortep)）说谢谢！他们精巧地实现了这个新的导航方式，并使得整个实现过程令人愉悦和兴奋。





[![](https://cdn-images-1.medium.com/max/400/1*Mro-phkgJv4rZQ223OYosA.jpeg)](http://eepurl.com/bBbrFX)





[![](https://cdn-images-1.medium.com/max/400/1*kHlMuCZPyf0mQQWAuaR7HQ.jpeg)](http://facebook.com/startupgrind)





[![](https://cdn-images-1.medium.com/max/400/1*B3UHAfn5Xm2QNIPW1sYJHA.jpeg)](https://twitter.com/startupgrind)


