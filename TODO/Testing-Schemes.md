>* 原文链接 : [Using Xcode's Schemes to run a subset of your tests](http://artsy.github.io/blog/2016/04/06/Testing-Schemes/)
* 原文作者 : [Orta Therox](http://artsy.github.io/author/orta/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Tuccuay](https://github.com/Tuccuay)
* 校对者 :

[Eigen](https://github.com/artsy/eigen) 是个应对测试这样例行公事的行为的好办法。这是一个积极的迹象，在过去的三年内应用程序的大小、复杂度和开发人员的数量都在急剧增加。测试套件让我们可以舒适的进行这一演变。

在我最快的计算机上，我们只需要等一分钟—— `Executed 1105 tests, with 1 failure (0 unexpected) in 43.221 (48.201) seconds` 来执行整个套件。我想大概可以用 20 秒来完成，所以我研究了如何用 [AppCode](https://www.jetbrains.com/objc/) 处理运行测试，这份指导可以帮助你轻松的把测试集跑起来。

我曾经有一个 [点子](https://github.com/orta/life/issues/71) 来节约时间进行通常的测试，基于 [代码注入](http://artsy.github.io/blog/2016/03/05/iOS-Code-Injection/)，但它并没有完全解决问题，我希望是时间密集型的，当时还没有完全达到要求。

### 什么是 Schemes？

> 一个 Xcode scheme 定义了一个构建目标集合。一个构建时所使用的配置和一个用于测试的集合。
>
> 如果你想的话，你可以有很多 schemes，但是你一次只能运行一个而不能同时运行。你可以指定一个 scheme 是否要放在一个项目中，这种情况下他在每一个包含这个项目的工作区都可以使用。或者仅仅在一个工作空间中，这种情况下仅仅在这个工作区可用。当你选择了一个活动的 scheme，你也就选择了一个运行目标（也就是选择的产品构建的硬件架构）。

引用自 [Apple](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Schemes.html)。

### 规划 Scheme

这个测试套件大概有 50 个类，看起来像是这样：

![Tests](http://artsy.github.io/images/2016-04-06-Testing-Schemes/tests.png)

在你开始之前，你可能会说：“我只想从 Eigen 那里拿来一些有关 Fairs 的测试”。因为我接下来的几天都将为了这个目标而努力。为了准备开始，我需要创建一个新的 Scheme。当你点击 Xcode 左上角的 Targer/Sim 按钮的时候你就会看见这个 schemes。

![Empty Scheme](http://artsy.github.io/images/2016-04-06-Testing-Schemes/empty_scheme.png)

我的看起来像是这样，我们需要创建一个新的 scheme。当你需要选择你应用的 target 的时候将会 modal 出一个窗口（这样你可以按下 `cmd + r` 继续运行）。

![New Scheme](http://artsy.github.io/images/2016-04-06-Testing-Schemes/new_scheme.png)

我给它起名叫 "Artsy just for Fairs"，因为我是唯一会看到它的人，所以我可以随意命名成我想要的。点击 "OK" 选择它，这个 modal 会被收起。你现在需要回到 target 选择，并且从 "Edit Schemes ..." 来继续。

![Edit Schemes](http://artsy.github.io/images/2016-04-06-Testing-Schemes/edit_schemes.png)

### 做一些修正

现在，在侧栏中点击 "Test"，现在你进入了 Schemes 测试编辑器。这将是你接下来要干活的地方。

![Empty Edit Schemes](http://artsy.github.io/images/2016-04-06-Testing-Schemes/empty_edit_schemes.png)

你需要点击 "+" 来吧你的测试 Target 添加到 Scheme

![Test Scheme](http://artsy.github.io/images/2016-04-06-Testing-Schemes/test_scheme.png)

选择并 "Add" 你的 Targets。在这里添加 target，你需要点击向下箭头让他来显示所有测试类。

__来，给你表演个魔法__。按住 `alt` 并单击蓝色的的标记框把测试 target 关闭。然后不按住 `alt` 再单击一次。这将会取消选择所有的类，这是所有 Mac 应用都可以进行的通用操作，所以不要在意。

![Deselect All](http://artsy.github.io/images/2016-04-06-Testing-Schemes/deselect_all.png)

这就意味这你可以去寻找你想要运行的类，对我来说我想要运行关于 Fairs 的类。

![Just The Good Tests](http://artsy.github.io/images/2016-04-06-Testing-Schemes/just_the_good_tests.png)

现在当我按下 `cmd + u` 就将指运行这些测试类。

### 封装起来

这意味这我可以以合理的速度继续工作了。`Executed 15 tests, with 0 failures (0 unexpected) in 0.277 (0.312) seconds`。现在我可以在我泡一杯茶的时间内运行一遍完整的测试套件了。

_Note:_ If you want to avoid using the mouse to change scheme, the [key commands](http://artsy.github.io/images/2016-04-06-Testing-Schemes/next_prev.png) to change between visible schemes is `cmd + ctrl + [` and `cmd + ctrl + ]`.
__额外提醒__：如果你不想用鼠标来改变 scheme，这些 [快捷键](http://artsy.github.io/images/2016-04-06-Testing-Schemes/next_prev.png) 可以让你在 scheme 之间上(``cmd + ctrl + [``)下(`cmd + ctrl + ]`)切换。
