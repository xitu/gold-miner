> * 原文地址：[Exposing the Searchbar Implementing a Dialer-like Search transition](https://medium.com/@alexstyl/https-medium-com-alexstyl-animating-the-toolbar-7a8f1aab39dd#.waucttqbf)
* 原文作者：[Alex Styl](https://medium.com/@alexstyl)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegen](https://github.com/siegeout)
* 校对者：[XHShirley](https://github.com/XHShirley),[jamweak](https://github.com/jamweak)

关于我的应用，我收到了一些用户的反馈，他们反馈最多的是缺少**搜索**功能。对于像 Memento Calendar 这种囊括了诸如社交时间，纪念日，银行休假日，信息来源错综复杂的应用，我很赞同搜索是这个应用最重要的功能之一。问题是这个功能已经被实现了。Toolbar 里的一个搜索图标引导用户到一个搜索界面。


![A user can search by tapping the search icon on the Toolbar](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/search_toolbar.png)


我决定调研一些用户来看看问题究竟是什么。在和这些幸运的用户通过邮件往来交流了一番后，我总结出下面的内容：

> 人们似乎更加习惯于其他流行应用中的搜索栏，例如 Facebook，Swarm 以及其他的应用。在上述的应用中，搜索栏可以直接通过 Toolbar 访问到，这意味着用户可以从主界面开始搜索。



因为搜索的逻辑已经在应用里实现了，我有充裕的时间来尝试使用 Android 的动画 API 为我的应用增添生气。


### 试验的进程



这个点子是利用 transition 来衔接已经包含搜索栏的主界面，以及拥有神奇搜索功能的搜索界面。




从一个视图设计的角度，我想要这个 transition 尽可能的相似以便于用户可以聚焦于搜索，感觉不到他们正在看一个新的界面。从一个视图开发的角度，两个界面（Activities）不得不保持分离。每一个 Activity 处理它们自己的事务，从维护的角度来说把它们联合在一起完全是一个噩梦。


因为这是我第一次使用 Transition，我不得不做一些阅读。我觉得 Nick Butcher 和 Nick Weiss 的
[**有意义运动**的谈话](https://skillsmatter.com/skillscasts/6798-meaningful-motion)视频对我理解新的 API 是怎样工作的很有帮助，并且这个视频里的幻灯片曾经是（现在仍然是）我处理 Transition 相关内容的核心备忘单。




一个类似于我想要实现的特效可以在[ Android 手机应用市场](https://play.google.com/store/apps/details?id=com.google.android.dialer)里被找到。一旦用户点击了搜索栏，当前的界面就会逐渐消失，搜索栏变大，用户可以开始搜索了。

![The transition as seen in the Dialer app](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/dialer.gif)


不幸的是这个应用的实现跟我预期的完全不一样。[所有的事情都是在一个单独的 activity 里完成的](http://grepcode.com/file/repository.grepcode.com/java/ext/com.google.android/android-apps/5.1.0_r1/com/android/dialer/DialtactsActivity.java)。即使这确实行得通，但我不喜欢把几个功能结合在一起，我希望在未来可以更加灵活的更新应用的设计。虽然这个实现不完全是我想要的，但是关于下一步我该怎么走，我从中获得了一个好主意。



我把期望的 transition 分解成三个简单步骤：

1) 让 toolbar 的内容渐隐

2) 把 toolbar 框变大

3) 让内容逐渐显示回来。



这些步骤可以很容易的通过 `TransitionManager` 类来实现。通过简单调用 [`TransitionManager.beginDelayedTransition()`](http://alexstyl.com/exposing-the-searchbar/) ，然后修改这个视图的属性。这个框架会自动的把这些改变应用到视图里。这对搜索栏的扩展和折叠都起作用。渐隐的效果也是用这种方式实现的，但是我们所做的却是正在改变多个视图的可视性。现在唯一欠缺的事是如何在一个操作步骤里实现无缝隙地跳转到搜索 activity。


幸运的是，我记得在一个 Android 开发者视频里见过类似的东西。在名为 [DevBytes: Custom Activity Animations](https://www.youtube.com/watch?v=CPxkoe2MraA) 的视频里 Cheet Haase 展示了在 activity 开始或是结束的时候如何覆写系统的动画。最后一点,这点也很重要，我们可以对这个Transition 进一步的修饰让它进行的更快，在 Transition 一开始的时候就显示出键盘。实现这个的简单方式是在应用的 Manifest 文件里声明正确的 windowSoftInputMode。通过这种方式，当第二个 activity 开始的时候键盘就变得可见了。

### 最终的结果



综上所述，下面的结果被实现了。

![The transition as seen in Memento Calendar](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/memento.gif)


你可能想知道这个设计决定是否真的有效。我对这个设计很满意，因为它为我的应用带来了额外的 30% 搜索量。这可能意味这个设计让用户更易于搜索，也可能用户喜欢这个动画效果![😄](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f604.png)

* * *


还有一些细微的 UX 提升还可以去实现来达到一个更好的效果，例如返回按钮图标的颜色，或者是当用户返回的时候,如果没有在搜索栏里填入搜索内容，就把 activity 结束掉。如果你对学习如何实现此类的效果感兴趣的话， **Memento Calendar 是开源的** 你可以来看看这个应用里这块内容的实现原理。你可以在 [github.com/alexstyl/Memento-Namedays](https://github.com/alexstyl/Memento-Namedays) **获得源码**或者从 [Google Play Store](http://alexstyl.com/exposing-the-searchbar/play.google.com/store/apps/details?id=com.alexstyl.specialdates) **下载这个应用**。
