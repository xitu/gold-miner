> * 原文地址：[How Google builds web frameworks](https://medium.freecodecamp.com/how-google-builds-a-web-framework-5eeddd691dea#.dv1nhpg5w)
* 原文作者：[Filip Hracek](https://medium.freecodecamp.com/@filiph)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [fghpdf](https://github.com/fghpdf) 
* 校对者：[dubuqingfeng](https://github.com/dubuqingfeng)，[Germxu](https://github.com/Germxu)

# Google 是如何构建 web 框架的

![](https://cdn-images-1.medium.com/max/1000/1*QDS-kCgeF8ZJg_JSEwwIeA.jpeg)

[众所周知](http://cacm.acm.org/magazines/2016/7/204032-why-google-stores-billions-of-lines-of-code-in-a-single-repository/fulltext)，Google 通过一个有 20 亿行的代码仓库来分享代码，而且它是主从式架构的代码仓库。

![](https://cdn-images-1.medium.com/max/800/1*3hPZNDocbp68XsbsJoZ-iQ.jpeg)

对于不在 Google 的众多开发者来说，这件事非常的令人吃惊和违背常理，但是这个代码仓库却工作的非常好。（上面链接里的文章提供了很好的例子，所以我在此不再赘述。）

> Google 的代码库为 Google 在全球各个国家和地区超过 2 万 5 千名的官方开发人员提供代码共享服务。在具有代表性的工作日中，这些开发者有 16,000 份代码修改提交给代码库。（[来源](http://cacm.acm.org/magazines/2016/7/204032-why-google-stores-billions-of-lines-of-code-in-a-single-repository/fulltext)）

这篇文章讲述构建一个开源 web 框架 [AngularDart](https://webdev.dartlang.org/angular) 的一些细节

![](https://cdn-images-1.medium.com/max/800/1*42xyxKFKI9a0j0BWuHGIHg.jpeg)

### 只有一个版本

当你在一个巨大的项目中采用主从式的开发模式，这个项目中的任何东西都只有一个版本。即使这种情况显而易见，但这里还是指出一下，因为这种情况意味着  ——  在 Google  ——  不可能有一款叫做 FooBar 的应用程序用着 AngularDart 2.2.1 版本，而另一款叫做 BarFoo 的应用程序却用着 2.3.0 版本。所有的 app 都必须使用的是同一个版本 (AngularDart)  ——  最新的版本。

![](https://cdn-images-1.medium.com/max/800/0*vdQqatZdTxZ9CUDs.)

采集的图片来源于 [trunkbaseddevelopment.com](https://trunkbaseddevelopment.com/)

这就是为什么 Google 的员工会说，他们的软件都采用的是及时更新的先进技术。

如果你的整个灵魂尖叫着“危险”！现在是可以理解的。仅仅依靠处于生产环境中的代码仓库中的主干（类似 “master” 分支在 git 中）听起来很危险。但它却真实的在进行。

### 每一个提交有着 7 万 4 千个测试

AngularDart 定义了 1601 个测试 （[AngularDart 的测试](https://github.com/dart-lang/angular2/tree/master/test)）。但是当你在 Google 的仓库中提交了一份关于 AngularDart 的代码改动时，这个代码仓库就会让每一个依赖这个框架的 Google 员工执行测试。目前，一份提交大约有 7 万 4 千个测试（这取决于你提交的代码有多大的改动  ——  一种让系统知道你的代码不会造成影响的启发式测试）

![](https://cdn-images-1.medium.com/max/800/1*5VjjBOiVq74495vLAKctOg.png)

多点测试总是好的。


我做了一个仅能展现测试耗时 5% 的改动，就是在检测变化的算法中模拟了类似于竞争条件的东西（我添加了`&& random.nextDouble() > .05`这个语句到[这个条件中](https://github.com/dart-lang/angular2/blob/v2.1.0/lib/src/core/change_detection/differs/default_iterable_differ.dart#L386)）。当我在运行它们时（一旦），它并没有表现出有 1601 个测试的样子。但它确实打断了一系列的客户端测试。

真正的价值在这里，即使这些测试是**实际的应用程序** 。他们不仅数量众多，而且还反映了开发人员如何使用框架（不仅仅是框架作者）。很有意思的是：框架所有者并不能够总是正确地估计他们的框架被如何使用。

它还帮助那些在生产环境中的应用程序获得每月数十亿美金的流量。框架作者在业余时间做的演示程序与实际生产环境中的应用程序之间存在很大的区别，这些生产环境中的应用程序每年具有几十或几百个人的投资。如果在未来网页是相互关联的，我们就需要更好地支持后者的发展



![](https://cdn-images-1.medium.com/max/800/1*DrJBfzzSTkGdmrlu6OnYfA.png)

那么，如果框架破坏了基于它的一些应用程序，会发生什么呢？


### 谁损坏，谁治理

当 AngularDart 的作者们想引入一个具有破坏性的变化时，**他们不得不去为他们的用户修复它**。由于 Google 的所有内容都存在于单一的项目中，因此找出他们出问题的地方很容易，他们可以立即开始修复。

对 AngularDart 的任何破坏性更改还包括所有依赖它的 Google 应用中对该更改的所有修复。因此破损和修复同时进入代码仓库  ——  当然  ——  是在所有相关方进行正确的代码审查后。

让我们举一个具体一点的例子。当 AngularDart 团队中的某个人做了会影响 AdWords 应用中代码的变更时，他们会去查看该应用的源码并予以修正这个问题。他们可以在此过程中运行 AdWords 的现有测试，也可以添加新的测试。然后，他们把所有这些更改都放入他们的更改列表里，并要求进行代码审查。由于它们的更改列表涉及到 AngularDart 项目和 AdWords 项目中的代码，因此系统会自动要求这两个小组进行代码审查。只有这样，才能提交更改。

![](https://cdn-images-1.medium.com/max/800/1*kbwhvH4lz1B-jRHBCEvAcA.png)

这对处于早期不受影响的发展阶段的框架能起到很明显的保护。AngularDart 框架的开发人员可以使用他们的平台构建的数百万行代码，他们自己也经常接触那些代码。但他们不需要假设他们的框架被如何使用。（有一个警告很明显，他们只看到 Google 的代码，但这份代码而不是世界上所有的 Workivas、Wrikes 和 StableKernels 使用 AngularDart 的代码，也使用 AngularDart 的代码。）

不得不升级用户的代码也会减慢开发速度。虽然没有你想象的那么多（看看 AngularDart 自十月以来的进展），但它仍然拖慢了很多事情。这种情况说好也行，说坏也可以，这取决于你想从一个框架中得到什么。我们会回来处理这个事的。

无论如何。下次 Google 的某个员工说，某个代码库的 alpha 版本是稳定的版本和处于生产环境的版本，现在你知道是为什么了。

### 大范围改动

如果 AngularDart 需要做出重大突破性改变的时候（比如，从 2.x 版本到 3.0 版本）并且这个改变会使 7 万 4 千个测试失效的时候怎么办？团队会去修复这些测试吗？他们会去修改**成千上万**大部分不是他们写的源码吗？

答案是：会。

一个关于声音类型系统 [sound type system](https://www.dartlang.org/guides/language/sound-dart) 的很酷的事情是你的工具将会变得更加有用。在声音的 Dart 中，举个例子，工具可以确认某个声音是哪种类型的。从重构的角度来说，这意味着很多改动都是全自动的，不需要开发人员去确认。

当类 Foo 里一个方法从 `bar()` 变成了 `baz()`，你可以通过整个 Google 项目来创建一个工具，来查找该 Foo 类及其子类的所有实例，并且把他们的 `bar()` 方法改为 `baz()` 方法。在那个 Dart 的声音类型系统中，你就可以确认这个改动不会破坏任何东西。在没有声音类型的情况下，任何一个小的改动都会让你陷入困境。

![](https://cdn-images-1.medium.com/max/800/1*yxqdl9CBoB48XG0avf4piQ.gif)

另一个能帮助你进行大范围修改的就是 [dart_style](https://github.com/dart-lang/dart_style) ，Dart 的默认格式化器。所有在 Google 的 Dart 的代码都是通过这个工具格式化的。当你的代码被审查的时候，它就会自动使用 dart 的样式工具自动格式化，所以没有关于是否把换行放在这里或那里的论据。这也适用于大范围的重构。

### 性能指标

正如我上面所说，AngularDart 受益于其依赖的测试。但测试仅仅是测试而已。Google 非常严格地衡量其应用的性能，所以大多数（所有？）生产环境中的应用都有基准套件。

因此，当 AngularDart 团队引入了一项变化，导致 AdWords 速度下降1％时，他们在发生变化*之前*就知道会这样了。当这个团队在10月份[表示](https://www.youtube.com/watch?list=PLOU2XLYxmsILKY-A1kq4eHMcku3GMAyp2&amp;v=8ixOkJOXdMo)，AngularDart 应用程序自8月以来已经减少了 40％ 的体积，并且增长了 10％ 速度时，他们不是在探讨一些合成的小型 TodoMVC 示例应用。他们谈论的是现实生活中，承担关键任务的生产环境中的应用，数百万用户和兆字节的业务逻辑代码。

![](https://cdn-images-1.medium.com/max/800/1*FFPofhArfE_q-ppyTkDniA.png)

### 附注：封闭式构建工具

你可能想知道：这个人怎么知道往 AngularDart 中这个巨大仓库的引入一点错误的代码后运行了哪些测试？当然，他不是手工挑选的 7 万 4 千次测试，而且肯定他没有运行 Google *所有*的测试。答案就是一个叫 Bazel 的东西。

当处于这个规模的时候，你不能用一系列 shell 脚本来构建东西。因为会把事情弄得支离破碎和出奇得慢。这就是你为什么需要这个封闭式构建工具。

“封闭” 在上下文中非常类似于函数领域中的“[pure](https://zh.wikipedia.org/wiki/%E7%BA%AF%E5%87%BD%E6%95%B0)”。你的构建步骤不会有副作用（就像临时文件，换了路径而已），并且它们的结果是确定的（相同的输入总是导致相同的输出）。在这种情况下，您可以在任何时间在任何机器上运行构建和测试，您将获得一致的输出。你不会再需要 `make clean` 这个命令。因此，您可以使用 build 或者 test 命令来来构建服务器并将其并行化。

![](https://cdn-images-1.medium.com/max/800/1*sq_8UFpeBsxSIpBXpmWiSg.png)

Google 花费了数年时间来开发这个构建工具。去年它开源啦，[开源地址](https://bazel.build/)。

多亏了这个基础设施，内部测试工具可以确定每个产生影响的 build 或者 test 命令，并在合适的时候运行它们。

### 它意味着什么？

AngularDart 的明确目标是在提高生产力，性能和可靠性方面上来建立大型 Web 应用程序。这篇文章希望涵盖最后一部分 — 可靠性，以及为什么如此重要的 Google 应用，如 AdWords 和 AdSense 使用这个框架。这不只是团队吹嘘自己的用户 — 如上所述，有大型内部用户的存在使得 AngularDart 不太可能引入表面的变化。所以使框架更可靠。

![](https://cdn-images-1.medium.com/max/800/1*BjhLEoihrMr6eRcTYL50ag.png)

如果你正在寻找一个框架，它使得你的代码进行重大检修，并引入了最近几个月的主要功能，AngularDart 绝对不适合你。即使 AngularDart 团队希望以这种方式构建框架，我认为这篇文章讲得很清楚了，他们没法这么做。然而，我们确信，留给框架发展空间是少一点新潮，多一点稳定。

在我看来，预测开源技术栈能否得到长期良好的支持要看它的主要维护者是否把它当做业务的一部分。比如 Android、dagger、MySQL 和 git。这就是为什么我很高兴于 Dart 终于有了一个首选的 Web 框架（AngularDart），一个首选组件库（ [AngularDart Components](https://pub.dartlang.org/packages/angular2_components) 组件）和一个首选移动框架（ [Flutter](https://flutter.io/) ） ——  所有这些都用于构建 Google 的关键应用。