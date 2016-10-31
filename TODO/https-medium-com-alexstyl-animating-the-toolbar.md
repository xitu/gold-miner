> * 原文地址：[Exposing the Searchbar Implementing a Dialer-like Search transition](https://medium.com/@alexstyl/https-medium-com-alexstyl-animating-the-toolbar-7a8f1aab39dd#.waucttqbf)
* 原文作者：[Alex Styl](https://medium.com/@alexstyl)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Siegen](https://github.com/siegeout)
* 校对者：

I have been receiving some user feedback for my app that the feature they are missing the most is _search_. For an app that contains information from different sources such as contact’s events, name days or bank holidays, such as Memento Calendar, I would have to agree that Search is one of the most important features the app could have. The problem is that the feature is already implemented. A search icon in the Toolbar navigates the user to a dedicated search screen.

关于我的应用，我收到了一些用户的反馈，他们反馈最多的是*搜索*方面的。这个应用包含来自不同源头的信息，例如社交事件、命名日、银行假期或是纪念日，我很赞同搜索是这个应用最重要的方面之一。问题是这个功能已经被实现了。Toolbar 里的一个搜索图标引导用户到一个搜索界面。

![A user can search by tapping the search icon on the Toolbar](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/search_toolbar.png)

I decided to reach out to some of my users to see what the problem really was. After exchanging some emails and having some chats with some lucky users I concluded the following:

> People seem to be more accustomed to the search bar found in other popular apps such as Facebook, Swarm and others. In those said apps, the search bar can be accessed directly through the Toolbar, meaning that the user can start a search right from the main screen.

![A user can search by tapping the search icon on the Toolbar](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/search_toolbar.png)


我决定调研一些用户来看看问题究竟是什么。在交换了一些邮件并且和一些幸运用户聊天之后，我总结出下面的内容：

> 人们似乎更加习惯于发现其他流行应用中的搜索栏，例如 Facebook，Swarm 以及其他的应用。在上述的应用中，搜索栏可以直接通过 Toolbar 获得，这意味着用户可以从主界面开始一个搜索。


As the search logic was already there in the app, I had the luxury of time to experiment with the animations APIs of the platform and add some liveness into my app.

因为搜索的逻辑已经在应用里实现了，我有大量的时间来试验 Android 平台的动画 API 然后添加一些好用的到我的应用中。

### The course of action

### 试验的进程

The idea was to create a transition that links two screens together; the home screen of the app where the Search bar can be found and the Search screen where the search magic happens.

这个电子是创建一个 transition 来把两个界面链接到一起；在应用的主界面里可以找到搜索栏，而搜索界面就是搜索魔法发生的地方。


From a design point of view, I wanted the transition to be as seemingness as possible so that the user can focus on searching without having the feeling that they are looking at a new screen. From a developer point of view though, the two screens (Activities) had to stay separate. Each Activity handles their own responsibilities and having to combine them would be a complete nightmare for maintenance purposes.

从一个视图设计的角度，我想要这个 transition 尽可能的相似以便于用户可以聚焦于搜索，感觉不到他们正在看一个新的界面。从一个视图开发的角度，两个界面（Activity）不得不保持分离。每一个 Activity 处理它们自己的事务，从维护的角度来说把它们联合在一起完全是一个噩梦。

As this was my first time playing with Transitions I had some reading to do. I found Nick Butcher’s and Nick Weiss’s [_Meaningful motion_ talk](https://skillsmatter.com/skillscasts/6798-meaningful-motion) to be really helpful understanding how the new API works and the slides were (and still are) my go-to cheatsheet for anything Transition related.

因为这是我第一次使用 Transition，我不得不做一些阅读。我发现了 Nick Butcher 和 Nick Weiss 的
[_有意义运动_的谈话](https://skillsmatter.com/skillscasts/6798-meaningful-motion)视频，这对我理解新的 API 是怎样工作的很有帮助，并且这个视频里的幻灯片是（并且仍然是）我处理 Transition 相关内容的核心备忘单。


A similar effect of what I wanted to achieve can also be found in the [stock Android’s Phone app](https://play.google.com/store/apps/details?id=com.google.android.dialer). As soon as the user taps on the search bar, the current screen fades away, the search bar expands, and the user is ready to start searching.

![The transition as seen in the Dialer app](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/dialer.gif)

一个类似于我想要实现的特效可以在[ Android 手机应用市场](https://play.google.com/store/apps/details?id=com.google.android.dialer)里被找到。一旦用户点击了搜索栏，当前的界面就会逐渐消失，搜索栏变大，用户准备开始搜索。

Unfortunately, the implementation of the app is done differently from what I was expecting. [Everything is done in one single activity](http://grepcode.com/file/repository.grepcode.com/java/ext/com.google.android/android-apps/5.1.0_r1/com/android/dialer/DialtactsActivity.java). Even though that could work, I don’t like combining multiple responsibilities together, so that I can be more flexible in updating the design of the app in the future. Even though the implementation wasn’t exactly what I wanted it to be, I got a good idea what my next steps should be.

不幸的是这个应用的实现跟我预期的完全不一样。[所有的事情都是在一个单独的 activity 里完成的](http://grepcode.com/file/repository.grepcode.com/java/ext/com.google.android/android-apps/5.1.0_r1/com/android/dialer/DialtactsActivity.java)。即使这确实行得通，但我不喜欢把几个功能结合在一起，我希望在未来可以更加灵活的更新应用的设计。虽然这个实现不完全是我想要的，但是关于下一步我该怎么走，我从中获得了一个好主意。

I broke down the desired transition into three simple steps:

1) fade out the contents of the toolbar

2) expand the toolbar

3) fade the contents back in

我把期望的 transition 分解成三个简单步骤：

1) 让 toolbar 的内容渐隐

2) 把 toolbar 框变大

3) 让内容逐渐显示回来。


Those steps can easily be performed with the use of `TransitionManager` class. By a simple call of [`TransitionManager.beginDelayedTransition()`](http://alexstyl.com/exposing-the-searchbar/) and then modifying the properties of the view, the framework will automatically animate the changes done to the view. This can work for both the expansion and collapse of the search bar. The fading is done in the same way, but we are changing the visibility of the views instead. The only thing missing now is how to seamlessly jump to the search activity in a single go.

这些步骤可以很容易的通过 `TransitionManager` 类来实现。通过一个 [`TransitionManager.beginDelayedTransition()`](http://alexstyl.com/exposing-the-searchbar/) 的简单调用然后修改这个视图的属性。这个框架会自动的把这些改变应用到视图里。这对搜索栏的扩展和折叠都起作用。渐隐的效果也是用这种方式实现的，但是我们所做的却是正在改变多个视图的可视性。现在唯一欠缺的事是如何在一个操作步骤里实现无缝隙的跳转到搜索 activity。

Luckily, I remembered seeing something similar being done in one of the Android Developers videos. In the video titled [DevBytes: Custom Activity Animations](https://www.youtube.com/watch?v=CPxkoe2MraA) Cheet Haase showcases how to override the system’s animation when starting or finishing activities.  Last but not least, we can further polish the transition and make it seem faster, by showing the keyboard as soon as the Transition starts. A simple way of achieving this is by specifying the right windowSoftInputMode on the application Manifest file. That way the keyboard will be visible while the second activity is started.

幸运的是，我记得在一个 Android 开发者视频里见过类似的东西。在名为 [DevBytes: Custom Activity Animations](https://www.youtube.com/watch?v=CPxkoe2MraA) 的视频里 Cheet Haase 展示了在 activity 开始或是结束的时候如何覆写系统的动画。最后一点,最后这点也很重要，我们可以对这个Transition 进一步的修饰让它进行的更快，在 Transition 一开始的时候就显示出键盘。实现这个的简单方式是在应用的 Manifest 文件里声明正确的 windowSoftInputMode。通过这种方式，当第二个 activity 开始的时候键盘就变得可见了。

### The end result
### 最终的结果


Putting everything together the following result can be achieved:

![The transition as seen in Memento Calendar](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/memento.gif)

综上所述，下面的结果被实现了。

![The transition as seen in Memento Calendar](https://raw.githubusercontent.com/alexstyl/alexstyl.github.io/master/images/animating-the-toolbar/memento.gif)

You might be wondering whether this design decision actually had any effect. I’m quite happy with the result as this update brought 30% more searches into the app. This can either mean that it is easier for people to search, or people enjoy the animation ![😄](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f604.png)

你可能想知道这个设计决定是否真的有效。我对这个设计很满意，因为它为我的应用带来了额外的 30%搜索量。这也意味着对用户来说这样做更容易，或者说用户更喜欢这个动画![😄](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f604.png)

* * *

There are some minor UX improvements that can be done for a more polished effect, such as the tinting of the Up icon or finishing the activity when the user presses back without a search query in place. If you are interested in learning how to achieve such effects, **Memento Calendar is open-source** and you are more than welcome to have a look at how things work under the hood. You **grab the source** code at [Github.com](https://github.com/alexstyl/Memento-Namedays) or **download the app** from the [Google Play Store](http://alexstyl.com/exposing-the-searchbar/play.google.com/store/apps/details?id=com.alexstyl.specialdates).

还有一些细微的 UX 提升还可以去实现来达到一个更好的效果，例如返回按钮图标的颜色，或者是当用户返回的时候,如果没有在搜索栏里填入搜索内容，就把 activity 结束掉。如果你对学习如何实现此类的效果感兴趣的话， **Memento Calendar 是开源的** 你可以来看看这个应用里这块内容的实现原理。你可以在 [github.com/alexstyl/Memento-Namedays](https://github.com/alexstyl/Memento-Namedays) **获得源码**或者从 [Google Play Store](http://alexstyl.com/exposing-the-searchbar/play.google.com/store/apps/details?id=com.alexstyl.specialdates) **下载这个应用**。
