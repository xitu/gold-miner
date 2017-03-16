> * 原文地址：[Comparing the Performance between Native iOS (Swift) and React-Native](https://medium.com/the-react-native-log/comparing-the-performance-between-native-ios-swift-and-react-native-7b5490d363e2#.ads9p0f4n)
* 原文作者：[John A. Calderaio](https://medium.com/@jcalderaio?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Deepmissea](http://deepmissea.blue)
* 校对者：[gy134340](http://gy134340.com/)，[Danny1451](http://danny-lau.com/)

# 原生 iOS(Swift) 和 React-Native 的性能比较

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*e1ndrqm2zZhe7IVjA6ugpw.jpeg">

React-Native 是一个混合的移动框架，可以让你仅仅使用 JavaScript 来构建应用。然而，与其他混合移动开发技术不同的是，你构建的并不是一个 “移动网页应用”（把网页应用封装到一个原生的容器里）。在最后，你会得到一个真正的应用。与使用 Objective-C 编写的 iOS 以及 Java 编写的 Android 应用相同，你的 JavaScript  代码最终会被编译成一个移动应用。这意味着 React-Native 拥有了原生应用和混合应用的好处，而没有任何缺点。

我的目标是找出他们是否能够准确地履行他们的承诺。要实现目标的话，我就需要用 Swift 和 React-Native 构建相同的应用。它需要足够简单，以便我可以学习两种语言并及时完成应用程序，但也需要足够的复杂，才能比较每个应用的 CPU、GPU、内存的使用情况和功耗。应用会有四个 tab。第一个叫做 “Profile”，用来提示用户登录 Facebook 来获得用户个人资料里的照片和邮箱，并展示在页面上。第二个 tab 叫做 “To Do List”，是用 NSUserDefaults（iPhone 内部存储）来做的一个简单的待办事项表，它将有添加和删除条目的功能。第三个 tab 叫做 “Page Viewer”，由一个 PageViewController 组成。PageViewController 有三屏，用户可以来回切换（红、绿、蓝三屏）。最后一个 tab 叫 “Maps”，由一个 MapView 组成，放大用户的当前位置，然后在地图上的用蓝点表示。

### Swift 的历程 ###

第一步是 iOS 和 Swift。学习 Swift 相对比较容易，因为它很像我知道的其他语言（Java、C++）。然而，学习 Cocoa Touch（iOS 框架）才是更难的任务。我看了 **Udemy.com** 上 Rob Percival 的一系列视频，这让我从初识 Swift 阶段过渡到完成了几个应用。虽然我在看完介绍视频后还是在 Cocoa Touch 上有很多问题。视频里大多数的“学习”只是调用复制/粘贴代码，但是我们不是很清楚它做了什么。我感觉可能老师也不知道这是啥，只是记住了它。我不喜欢对我的代码一无所知。

Apple 的 IDE（Xcode）对用户无疑即先进又友好。你可以点击叫做 Storyboard 的东西，按你想要的顺序来设置你应用的屏幕，放一个箭头，指向程序启动的首屏。在第一个 tab（“Profile”）里，我要拖一个图片视图、姓名标签和邮箱标签。然后，我拖住它跟代码做一个链接，在代码里创建一个新变量。接着，以编程的方式，一旦用户登录了 Facebook，我就把变量的值改变成 Facebook 里的值。通过视频，我花了三周的时间来适应并完成了 Swift/iOS 的代码。

你可以在 GitHub 上看一下这个应用的 Swift 版本的代码，链接在这里：[https://github.com/jcalderaio/swift-honors-app](https://github.com/jcalderaio/swift-honors-app)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*2rOfHO8rCsb8S8EANfTXCg.png">

Swift Tab 1 (Facebook Login)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*oqP5ST5jpRs-ag_WCqEXjA.png">

Swift Tab 2 (To-Do List)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*YPb_6vT2RWm54CVDvl84WQ.png">

Swift Tab 3 (Page View)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*S3KFEaCqOzPJ22DPvxGfRQ.png">

Swift Tab 4 (Maps)

### React-Native 的历程 ###

第二部分是 React-Native。学习 JavaScript 比 Swift 要难上一点，但也不是很困难。我试着利用我从网上学到的一些零碎的 React-Native 知识来编写应用，但是还不够。我需要一些视频讲座。回到 **Udemy.com**，我看了 Stephen Grider 介绍 React-Native 的精彩演讲。一开始的时候，我感到非常不知所措，React-Native 的结构对我一点用也没有。不过在看了 Stephen Grider 的演讲之后的一周，我已经可以自己编码了。

我对 React-Native 感到真正喜欢的地方是，你写的每一行代码都很说得通，你知道每一行代码的作用。另外，不像在 iOS 里（需要调整每个页面，让他们在横屏或者竖屏时显示正确的尺寸），在 React-Native 里，所有的都调整好了。不需要任何设置，我就能让我的应用看上去很完美。我在一些不同尺寸的 iphone 上运行我的程序也跑得很好。因为 React-Native 使用的是 flexbox（有点像 HTML 中的 CSS），它对正在展示的页面尺寸来说是响应式的。

你可以在 GitHub 上看一下这个应用的 React-Native 版本的代码，连接在这里：[https://github.com/jcalderaio/react-native-honors-app](https://github.com/jcalderaio/react-native-honors-app) 

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*wvxOOPoww_9IZto4cSpXYQ.png">

React-Native Tab 1 (Facebook Login)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*4sSsR52cS8fQ30uf0hmbWw.png">

React-Native Tab 2 (To-Do List)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*lh7tO4NH2DHbbrLle_vZ9A.png">

React-Native Tab 3 (Page View)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*xYt9lyH_vaT5NQTOz86e2A.png">

React-Native Tab 4 (Maps)

### 数据 ###

现在是时候来对比一下看看哪个应用性能更出色了。我会通过 Apple Instruments（Xcode 里的工具包）工具，测试两个应用的三个主要类别：CPU（“Time Profiler Tool”）、GPU（“Core Animation Tool”）和内存使用 （“Allocations Tool”）。Apple Instruments 允许我连接手机，然后选择手机上的任何应用，再选择我要用的测试工具，然后记录测试。

每个应用有 4 个 tab，每个 tab 都有一个“任务”，我在每个类别里测试。首先是 “Profile”，它的功能是登陆 Facebook。在代码里的表现形式是请求 Facebook 服务器，返回个人信息图片、邮箱以及姓名。第二个（“To Do List”）任务是从列表里添加或删除一个“代办项”。第三个（“Page View”）任务是在三个页面间来回滑动。第四个(“Maps”)任务是点击 tab 后，代码会让 GPS 来放大我当前的位置，在我的位置上放一个蓝色的放射形标记。

### CPU 测试 ###

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*pSaqGVOJ8EnNgSr3i7cmwg.png">

Swift VS React-Native 的 CPU 用量

**让我们来看看各个类别的情况：**

***Profile:*** React-Native 在这里略胜一筹，它比 Swift 更有效地利用了 1.86% 的 CPU。在执行任务并记录数据的过程中，当我按下 “Log in with Facebook” 按钮的时候可以明显观察到有一个峰值。

***To Do List:*** React-Native 同样以微弱的优势胜出，它比 Swift 节省了 1.53% 的 CPU 的使用。在执行任务并记录数据的过程中，当我**添加完(added)** 一项以及**删除完(deleted)** 一项的时候，可以明显观察到有一个峰值。

***Page View:*** 这一次，Swift 用 8.82% 的 CPU 使用率打败了 React-Native。在执行任务并记录数据的过程中，当我滑动到另一个不同的页面时候可以明显观察到有一个峰值。当我停留在一个页面时，CPU 的使用会减少，但是如果我再次滑动页面，CPU 的使用就会增加。

***Maps:*** Swift 再次以 13.68% 的优势胜出。在执行任务并记录数据的过程中，当我按下 “Maps” 这个 tab 的时候可以明显观察到有一个峰值，这会促使 MapView 找到我当前位置，并显示一个显眼的蓝色脉冲点。

是的，Swift 和 React-Native 都赢得了两个 tab 的胜利，但是整体而言 Swift 更高效的使用了 17.58% 的 CPU。如果我让自己不专注于单个任务执行与停止，而是在各个应用长时间运行，那结果可能会不同。而我也注意到了在切换不同的 tab 时，CPU 使用并没有变化。

### GPU 测试 ###

我们要绘制的第二个数据表是 GPU 用量情况。 我将为 Swift 和 React Native 的项目中的每个 tab 执行一个任务并记下测量结果。Y 轴的高度是 60 帧/秒。每秒，我执行每个 tab 的任务的时候，一个测量就会被 “Core Animation” 工具记录下来。我会取这些数据的平均值，然后绘制成下面的图表。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*VCrdvrBoterX_v25H9z3Pw.png">

Swift VS React-Native 的 GPU 用量
让我们看看每个类别的情况：

***Profile:*** Swift 以比 React Native 高出 1.7 帧/秒的帧率的微弱优势，赢得了这个 tab 的胜利。在执行任务并记录数据的过程中，当我按下 “Log in with Facebook” 按钮的时候可以明显观察到有一个峰值。

***To Do List:*** React-Native 以比 Swift 高出 6.25 帧/秒的帧率赢得了这个类别的胜利。在执行任务并记录数据的过程中，当我**添加完(added)** 一项以及**删除完(deleted)** 一项的时候，可以明显观察到有一个峰值。

***Page View:*** Swift 在这个 tab 上以 3.6 帧/秒的帧率击败了 React-Native。在执行任务并记录数据的过程中，我观察到，如果我快速滑动两个页面，帧率会急升到 50。如果我停留在一个页面，那帧率会下降，但是如果我重新再页面之间滑动，帧数又会急升。

***Maps:*** React-Native 赢得了这个类别的胜利，因为它的帧率比 Swift 高出 3 帧/秒。在执行任务并记录数据的过程中，当我按下 “Maps” 这个 tab 的时候，可以明显观察到有一个峰值，且这会促使 MapView 会找到我当前位置，并显示一个显眼的蓝色脉冲点。

Swift 和 React-Native 再一次的各自赢得了两个 tab 的胜利。但是，React-Native 以 0.95 帧/秒在整体上胜出。Facebook 从 React-Native 的代码中榨出的果汁量让人非常吃惊 — 目前为止，React-Native 似乎和 iOS（Swift）不相上下。

### 内存测试 ###

我们要绘制的第三个数据表是内存的使用情况。我将为 Swift 和 React Native 的项目中的每个 tab 执行一个任务并记下测量结果。Y 轴（内存）的高度是我测量数据的最高值。CPU 的使用率采集间隔是 1 毫秒。在每毫秒，我执行每个 tab 的任务的时候，“Allocations” 工具就会记录一个测量。我会取这些数据的平均值，然后绘制成下面的图表。

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*zV5VBZJBc7IfX9qSMzPm1A.png">

Swift VS React-Native 内存使用
让我们看看每个类别的情况：

***Profile:*** Swift 以节省 0.02 MiB 的内存使用，稍微赢得这个 tab 的胜利。在执行任务并记录数据的过程中，当我按下 “Log in with Facebook” 按钮的时候可以明显观察到有一个峰值。

***To Do List:*** React-Native 以比 Swift 节省 0.83 MiB 的内存赢得了这个 tab 的胜利。在执行任务并记录数据的过程中，当我向列表**添加完(added)** 一项以及**删除完(deleted)** 一项的时候，可以明显观察到有一个峰值。

***Page View:*** 在这个 tab 中，React-Native 以节省 0.04 MiB 的内存用量击败了 Swift。在执行任务并记录数据的过程中，我发现我在 PageView 切换页面的时，内存的峰值并没有改变。字面上没变。

***Maps:*** React-Native 节省了 61.11 MiB 的内存，以巨大优势赢得了这个类别的胜利。在执行任务并记录数据的过程中，我按下 “Maps” 这个 tab 的时候可以明显观察到一个峰值，而且这会促使 MapView 会找到我当前位置，并显示一个显眼的蓝色脉冲点。在两个 app 里，内存都在持续的增加，但最终都停止了。

React-Native 赢得了 3 个 tab 的胜利，而 Swift 赢得了 1 个。整体而言，React-Native 比 Swift 节省了 61.96 MiB 的内存。如果我让自己不专注于单个任务执行与停止，而是在各个应用长时间运行，那结果可能会不同。我在 “Maps” 的 tab 注意到，当我缩放地图或者移动地图的时候，内存呈指数地增长。“Maps” 消耗的内存要远远高于其他情况。

### 结论 ###

我用 Swift 和 React-Native 写的移动应用程序外观看上去几乎相同。从我在 4 个 tab 的任务中，测试应用程序的 CPU、GPU 和内存所收集的数据可以看出，应用程序的性能也几乎相同。Swift 在 CPU 这一类别整体胜出，React-Native 在 GPU 这一类别（略微）胜出，而在内存上以巨大的优势胜出。我可以从这个数据推测出，在 iPhone 上，Swift 比 React-Native 更有效的利用了 CPU，而 React-Native 比 Swift 略微有效的利用了 GPU，而且 React-Native 在某种程度上更有效的利用了 iphone 的内存。React-Native 在平台上的性能更好，赢得了三个类别中的两个。

我并没有考虑原生的 Android 应用。iOS 是我优先选择的平台，所以这是我最关心的。但是，我也会尽快的在 Android 上完成同样的实验。我很好奇结果会是什么，但是我敢打赌，如果 React-Native 能比原生的 iOS 性能好，那它也一定比原生的 Android 的性能要好。

我现在更加确信 React-Native 是未来的框架 - 它有这么多的优点，那么少的缺点。React-Native 可以用Javascript 编写（许多开发人员已经知道的语言），它的代码库可以部署到 iOS 和 Android 平台，制作应用程序的速度更快、成本更低，而且开发人员可以直接推送更新，而用户不必再下载更新。最棒的是，在刚推出一年的时候，React-Native 的性能已经超越了原生的 iOS Swift 应用程序。

### 引用 ###

Abed, Robbie. “Hybrid vs Native Mobile Apps — The Answer Is Clear.” *Y Media Labs*, 10 Nov. 2016, [www.ymedialabs.com/hybrid-vs-native-mobile-apps-the-answer-](http://www.ymedialabs.com/hybrid-vs-native-mobile-apps-the-answer-) is-clear/. Accessed 5 December 2016.

M, Igor. “IOS App Performance: Instruments &Amp; Beyond.” *Medium*, 2 Feb. 2016, medium.com/@mandrigin/ios-app-performance-instruments-beyond- 48fe7b7cdf2#.6knqxp1gd. Accessed 4 Dec 2016.

“React Native | A Framework for Building Native Apps Using React.” *React Native*, facebook.github.io/react-native/releases/next/. Accessed 5 Dec 2016.
