> * 原文地址：[Tab Bars are the new Hamburger Menus](https://uxplanet.org/tab-bars-are-the-new-hamburger-menus-9138891e98f4)
> * 原文作者：[Fabian Sebastian](https://uxplanet.org/@fabiansebastian?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tab-bars-are-the-new-hamburger-menus.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tab-bars-are-the-new-hamburger-menus.md)
> * 译者：[Rydensun](https://github.com/rydensun)
> * 校对者：[foxxnuaa](https://github.com/foxxnuaa)  [Park-ma](https://github.com/Park-ma)

# Tab Bar 就是新的汉堡菜单

这篇文章，我们将会讨论一种失去控制的导航模式。

![](https://cdn-images-1.medium.com/max/1000/1*2bmlj_WCGK8nrYXDWXTf5g.jpeg)

通常，我不喜欢只吐槽一些不好的 UX 设计，也不喜欢仅仅指出一个问题。相反，我一直努力给出一些建议和解决方案。这次情况有些不同：解决方案很明显 —— 就是 tab bar —— 但是近些年，这个解决方案的最初意图有些迷失，导致了同样的老问题。在我们探讨解决方案之前，是时候再次讨论这些问题了。但凡事一步一步来：

* * *

### 历史课程

2014 年，Apple 在考虑移动导航应该如何工作时，提出了一个底层的改变。在那之前，“汉堡式菜单”或“抽屉式导航”（Material Design 官方命名）在移动应用导航里最为流行。在 2014 年，WWDC 演讲  “[设计直觉性的用户体验](https://developer.apple.com/videos/play/wwdc2014/211/)”  中， Apple 基本上打碎了这种设计元素并且建议使用一种不同类型的导航 —— 如  **tab bars**。

![](https://cdn-images-1.medium.com/max/1000/1*dVH3vmhY9UQxSC11437E8g.jpeg)

WWDC 演讲 “设计直觉性的用户体验” (来源： [https://developer.apple.com/videos/play/wwdc2014/211/](https://developer.apple.com/videos/play/wwdc2014/211/))

这个 WWDC 演讲像病毒式的扩散，全世界的 UX 和 UI 设计师开始探讨汉堡式菜单的弊端：

*   **为何并且如何避免汉堡式菜单**  
    [https://lmjabreu.com/post/why-and-how-to-avoid-hamburger-menus/](https://lmjabreu.com/post/why-and-how-to-avoid-hamburger-menus/)
*   **汉堡式菜单的替代方案 —— UX Planet**  
    [https://uxplanet.org/alternatives-of-hamburger-menu-a8b0459bf994](https://uxplanet.org/alternatives-of-hamburger-menu-a8b0459bf994)
*   **消除汉堡按钮 —— TechCrunch**
*   [https://techcrunch.com/2014/05/24/before-the-hamburger-button-kills-you/?guccounter=1](https://techcrunch.com/2014/05/24/before-the-hamburger-button-kills-you/?guccounter=1)
*   **汉堡式菜单和隐藏式导航违背了 UX 设计原则 — NN Group**
*   [https://www.nngroup.com/articles/hamburger-menus/](https://www.nngroup.com/articles/hamburger-menus/)

从那开始，汉堡式菜单开始消失并且 tab bar 替代它作为默认方案。2015 甚至谷歌（抽屉式导航之父）都开始引入一种“底部导航”（等于 iOS 中的 “tab bar”）到他们自己的安卓应用和 Material Design 指导原则中。这看起来是满足直觉性导航目标的最佳解决方案。设计师们开始思考他们想要实现的目标。

![](https://cdn-images-1.medium.com/max/1000/1*Gycb7q465smTr92XZ_mVdA.png)

底部导航, 谷歌 Material Design 指导原则 (来源: [https://material.io/design/components/bottom-navigation.html#usage](https://material.io/design/components/bottom-navigation.html#usage))

* * *

### 导航目标

简述: 一个导航简单来说是要告诉用户三件事:

*   **我在哪？**
*   **我还可以去哪？**
*   **当我到那时我能找到什么？**

Tab bar 满足了所有的 3 个问题。它在每个屏幕中都是可见的，因此可以一直给你可视化的引导。它展示出在信息架构中你在哪里（选中的 tab 会高亮），你可以去哪里（其他的 tab）并且告诉你你将会在那里找到什么（图标和描述性的标签）。你可以接触更深层次的内容（从父级屏幕到子屏幕），这个过程中，你并不会丢失上下文联系和你在应用中的位置。

换句话说: Tab bar 是移动导航一个完美的解决方案。至少他们曾经是 —— 直到设计师们开始在使用它们时不再去考虑“为什么？”。他们在考虑真正的问题之前先去考虑解决方案，忘记了什么是 tab bar 最初要去实现的。现在 tab bar 经常像 2014 年前汉堡式菜单那样被使用。

* * *

### Tab bar 的问题

看看下面的 UI，你喜欢的 Medium iOS 版 app，试着发现它的问题：

![](https://cdn-images-1.medium.com/max/1000/1*16K8VPrRMCI8yQoD_jrNCA.jpeg)

截图: Medium iOS 版本 (文章模块)

当用户从上层视图导航至子视图（比如文章），子视图会覆盖包括 tab bar 的整个屏幕。

![](https://cdn-images-1.medium.com/max/1000/1*01HSwcT6pcws4fM6luY5aA.png)

截图： Medium iOS 版本 (个人设置)

现在，让我重新看一下导航的三个目标：

*   **我在哪？**
*   通过在子视图隐藏导航，用户不再知道他是在 app 的哪一个上层页面。用户会丢失他在整个信息架构中的位置。
*   **我还可以去哪？** 
*  通过隐藏其他的上层页面，用户便不能够直接导航至 app 的其他区域。相反，他们需要先返回至信息架构的顶部。
*   **当我到那时我能找到什么？**  
    子视图上仅有的一个导航元素是一个不附带任何描述的小小的左箭头。它不会告诉用户，通过点击它，你会到哪里。

Medium 可能在引入 tab 导航方式时有最好的意愿，这也是其他成千上万的 iOS 和 Android app 有的意愿。它在顶层视图时工作很完美，但他们在子视图上的实现，却是没有满足任何一个导航目标。

子视图就像一个 **模态视图**，遮挡住了整个导航系统（tab bar），但他的动画展示却像一个**子视图**（从右向左），并且展示了一个后退链接（箭头）。但模态并不是一个不好的东西。“模态通过阻止用户做其他事情，直到他们完成了当前的任务或是取消这个消息或者视图，来吸引用户注意力” ([苹果](https://developer.apple.com/ios/human-interface-guidelines/app-architecture/modality/)). 但是模态也需要使用模态动画（iOS：动画从底部到覆盖整个屏幕）并且包含完成和取消按钮来退出模态视图。模态视图只是用来完成短期任务的，这些任务是**自我包含的进程**并且只可以被完成或是取消，比如写一个邮件，在日历上添加一个事件，取消一个通知等。他们并不是被意图用来当做一个详情界面或是来代替一个子视图。那些子视图并不是一个自我包含的进程并且他们也不是只可以被取消或是保存的。

一些人可能会说，对于这些模态的严格用法也有一些特殊情况，例如**全屏详情页面**，就想一张单独的图片。通过隐藏 app 的整体 UI（如 tab bar）来创造吸引力和减少注意力分散。在这些情况下，通常会使用一个自定义转场动画来解释这些模态的不寻常用法。然而，Medium 的文章详情可以被考虑成为一个全屏的想也页面，但是缺少一个自定义专场动画。而且，那个差不多的设置页面是绝对不可能这么被考虑的。

![](https://cdn-images-1.medium.com/max/800/1*4bXY4-kFshVmA6KfOU1TlA.gif)

自定义的针对内容的转场动画 (来源: [https://material.io/design/navigation/navigation-transitions.html#hierarchical-transitions](https://material.io/design/navigation/navigation-transitions.html#hierarchical-transitions))

* * *

### 谷歌和苹果的做法

只有在极少数情况下，苹果和谷歌会在某个问题上保持意见一致。这就是其中一个极少数的情况。苹果和谷歌的指导原则中都鼓励设计师在使用 tab bar（底部导航） 的时候，将它一直显示在应用的每一个屏幕上：

> “当底部导航被使用时，应该在每个屏幕的底部都显示” —[ 谷歌 Material Design](https://material.io/design/components/bottom-navigation.html#usage)

> “Tab bar 只有在键盘显示时才隐藏” — [苹果 Human Interface Guidelines](https://developer.apple.com/ios/human-interface-guidelines/bars/tab-bars/)

苹果相当严厉的遵守自己提出的规定，在其 app 的每一个自屏幕上都显示 tab bar，比如 Apple Music, Photos, Podcasts, Health 或 Files。

![](https://cdn-images-1.medium.com/max/1000/1*XvyavA7fFYdRFNUXYuVAOw.jpeg)

Tab bar 在 Google Photos vs Apple Photos

然而谷歌经常打破自己的规定，因其经常在子视图上隐藏底部导航。当 Youtube（谷歌开发）一直保持底部导航的可见性时，Google Photo 和 Google+ 却在子视图中隐藏掉它（如相册和群组）。Material Design 指导手册中从来没有明确的要求设计师把底部导航放到每一个子视图中，但却要求它被添加到“每一个屏幕”中，这其中并没有指出这些屏幕在信息架构中的层次。

苹果一直都是在每个 app 底部都使用 tab bar，谷歌经常看起来是在每个屏幕底部都使用底部导航。这样做，谷歌就制造了一个子屏幕，它既不是一个真正的子视图（因为没有明显的主导航），也不是一个模态视图（因为它不是一个自我包含的进程，没有取消和保存按钮）—— 它是一个介于两者中间的东西。然而这些介于中间的屏幕是一个正在变大的问题。理论上，谷歌确实是引入了等价意义上的 tab bar，但实际上他们可能只是引入了另一个汉堡式菜单。许多 iOS 开发者随后都适应了“谷歌方式”的 tab bar 使用方法。通过这样做，他们忘记了最初为什么 tab bar 会替代汉堡式菜单。

*_编辑于 28.05.2018: 如_ [_Craig Phares_](https://medium.com/@craigphares) _指出的,这是因为 iOS 和 Android 的开发工具对于 tab bar 的使用处理方式不同。Xcode 会自动将导航添加至每一个 View Controller。然而，安卓开发者需要耗费许多时间与努力在保持导航持续可见性上。_ [_保持 tab bar 在每个新 activity 上可见_](https://stackoverflow.com/questions/17918198/how-to-keep-tabs-visible-on-every-activity)_. (_[_Read more_](https://medium.com/@craigphares/the-reason-apple-and-google-bottom-tabs-behave-differently-is-due-to-their-respective-authoring-8bac9bd5588d)_)_

* * *

### 结论

为什么谷歌要这样使用底部导航？并且他们希望设计师如何使用这些中间物，模态子视图? 我不清楚。我很希望能够听到谷歌关于这个的观点！我也很希望听到你们关于这个话题的观点. 目前为止，这是我的建议:

*   在模态视图和子视图之间划清界限并且知道何时去使用哪一个
*   只有在**自我包含的进程下使用模态视图** (包含某些特殊情况下的全屏详情页面)
*   对于其他所有的页面使用子视图
*   展示**tab bar / 底部导航于每一个视图** 包含子视图
*   隐藏导航栏（顶部）或是 tab bar（底部）在你滑动时，如果你想吸引用户注意力并且最大化屏幕使用面积（比如文章等）

Tab bar 是新的汉堡式菜单吗? 某种意义上是的。如果正确使用的话，它们都是很强大的导航元素 (是的，某些情况下汉堡式菜单的确 [有意义](https://uxplanet.org/when-to-use-a-hamburger-menu-199d62f764aa)). But once you start using tab bars for the sake of using tab bars (because everybody does), 但只要你开始使用 tab bar 仅仅是因为别人也用的话，你正在失去对于导航目标的认知。同样的事情，4 年前也发生在汉堡式菜单上，因此不要停止去思考“为什么？”。

### 沟通是关键

_欢迎留言：_ [_www.fabiansebastian.com_](http://www.fabiansebastian.com)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
