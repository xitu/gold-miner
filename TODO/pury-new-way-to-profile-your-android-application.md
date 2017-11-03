> * 原文地址：[Pury — 一个新的 Android App 性能分析工具](https://medium.com/@nikita.kozlov/pury-new-way-to-profile-your-android-application-7e248b5f615e)
* 原文作者：[Nikita Kozlov](https://medium.com/@nikita.kozlov)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[欧文](https://github.com/owenlyn)
* 校对者：[Graning](https://github.com/Graning), [lizwangying](https://github.com/lizwangying)

# Pury — 一个新的 Android App 性能分析工具

手机应用存在的目的，就是在帮助用户做他们想做的事情的同时，提供最好的用户体验 —— 而用户体验的重中之重是应用的性能。但有时候开发者们却以性能为借口，既没有达到既定目标，又写着低质量并难以维护的代码。在这里我想引用 Michael A. Jackson 的一句话：

> “程序优化守则第一条：别去做它。程序优化守则第二条（仅限于专业人员）：别去做它，现在还不是时候。”


![](https://cdn-images-1.medium.com/max/1600/1*YVKsfvtGMavBcYOo_tTHbA.jpeg)


在开始任何优化之前，我们要先认清问题的症结所在。
第一步，我们先收集和App性能表现的常规数据。比如，从调用 _startActivity()_ 到数据显示在屏幕上的时间。又比如，加载下一页 _RecyclerView_ 的内容所需要的时间。我们把这个时间和一个可以接受的阀值进行比较就可以发现有没有什么问题需要改进了。当应用程序使用的时间比预计的要长的时候，我们就需要深入的查看并找出是哪些方法（函数）或者API（应用程序接口）出了问题。

幸运的是，我们有一些工具来分析安卓应用程序（的性能）：

1. [Hugo[1]](https://github.com/JakeWharton/hugo) 是一个库，它提供注解驱动的方法调用日志。你只需要在你的方法上用 _@DebugLog_ 注解，然后它就会记录参数，返回值以及运行所需的时间。我很喜欢这个库，但是这个库仅仅适用于单个方法的调用，所以并不能用来测量从调用 _startActivity()_ 到数据显示在屏幕上的时间。
2. Android Studio 工具包，比如 System Trace，就是一个非常精确且提供很多信息的工具。但你需要花很多时间来收集、分析数据。
3. 后端解决方案，比如 [JMeter[2]](https://jmeter.apache.org/)。这些工具有很多功能，但需要很多时间来学习怎么使用它们。不过话说回来，你经常需要在大量并发负载下分析一个应用程序吗？这看起来并不像一个常见的情况。

#### 缺少的工具

如果你深入思考一下关于应用程序速度的问题，可以发现其中的一大部分可以被分成两类：


1. 某个特定方法或者 API 的调用。这类问题可以用 Hugo 一类的软件来解决。
2. 两个不同事件之间的时间。这可能发生在独立的、但逻辑上关联的两段代码之间。Android Studio 工具包可以解决这个问题，但就像前面说过的，你需要在这上面花很多时间。

当我在搜寻可用的分析工具并思考所有的可能性的时候，我意识到至少一样工具是没有的，所以我列出了以下需求：

1.  分析程序的开始和结束应该是两个独立触发的事件，这样我们就可以按照需求来灵活使用它了。
2.  如果我们想要监视应用的性能表现，仅仅有开始和结束是不够的。有些时候我们想要知道中间到底发生了什么。所有关于中间过程的信息应该被汇总在一个大的报告中。这让分析和分享数据变得更加简单。
3.  有时候，有些脚本是经常被重复调用的，比如，为 _RecyclerView_ 加在下一页的内容。这时候，仅仅对这段脚本进行一次分析是不够的 —— 我们需要一些统计数据，比如平均、最快和最慢的时间，来进行更深入的研究。

这就是为什么我开发了 _Pury_ 。

#### Pury 简介

_Pury_ 是一个用来分析多个独立事件之间的时间的库。事件可以用注解或者调用方法来触发。一个脚本的所有事件都被汇总到一个报告中。

用 _Pury_ 打开一个示例应用的输出:

    App Start --> 0ms
      Splash Screen --> 5ms
        Splash Load Data --> 37ms
        Splash Load Data <-- 1042ms, execution = 1005ms
      Splash Screen  1043ms 
        onCreate() --> 1077ms 
        onCreate()  1101ms 
        onStart() <-- 1131ms, execution = 30ms
      Main Activity Launch <-- 1182ms, execution = 139ms
    App Start <-- 1182ms
      

就像你看到的， Pury 测量应用启动的时间，包括中间阶段，比如在等待屏幕时加载数据和活动生命周期内的方法。每个阶段的开始和结束时间以及执行所需的时间。除了常规的分析，它也可以用来监视程序的性能，来确保一些改动不会带来意外的延迟。

某次运行结果的一个分页:

```
Get Next Page --> 0ms
  Load --> avg = 1.80ms, min = 1ms, max = 3ms, for 5 runs
  Load <-- avg = 258.40ms, min = 244ms, max = 278ms, for 5 runs
  Process --> avg = 261.00ms, min = 245ms, max = 280ms, for 5 runs
  Process <-- avg = 114.20ms, min = 99ms, max = 129ms, for 5 runs
Get Next Page <-- avg = 378.80ms, min = 353ms, max = 411ms, for 5 runs
```

在这个例子中，你可以看到， _Pury_ 收集了加载下一页 5 次的信息，并输出了平均值。 _Pury_ 记录并显示了每次开始和结束的时间，以及运行的时间。

#### 内部结构及不足

在深入介绍文档之前，我想简单介绍一下 Pury 的内部结构以及它的不足。这会帮助（你们）了解方法的参数以及报错的信息。

性能测试都是由 _Profiler_ 来完成的。每个 _Profiler_ 都包含了一个 _Runs_ 列表。多个 _Profilers_ 可以并行运行，但每个 _Profiler_ 只能同时运行一个 _Run_ 。当一个 _Profiler_ 内所有的 _Run_ 都运行完成时，就会有一个报告自动生成。 _Runs_ 的数量由 _runsCounter_ 参数来决定。





[//]:<>![](https://cdn-images-1.medium.com/freeze/max/60/1*tYB7kEVojU-s0pRcNApIwQ.jpeg?q=20)

![](http://ww3.sinaimg.cn/large/006y8lVagw1f89jd8r2l8j30z50ltq5z.jpg)





两个并列运行的 _Profilers_。第一个只有一个 _Run_ 并且处于活跃的 _stage_ 中。第二个有一个停止的 _Run_ 和一个活跃的 _Run_，每个 _Run_ 都包含了一个含有两个 _nested stage_ 的 _root stage_。活跃的 _stage_ 是绿色的，停止 _stage_ 是红色的。



_Run_ 内部有一个 _root state_ （**根状态**）。每个状态都有一个名字，一个序列号和一个不限定数量的、嵌套的 _nested stage_ (**子状态**)。每个 _stage_ 只能有一个活跃的 _nested stage_ 。如果你停止了一个 _parent stage_ （**父状态**），那么所有这个状态的 _nested stage_ 也会停止。

#### 使用 Pury 

就像之前提到的， _Pury_ 测量多个独立事件之间的时间。事件可以由注解或调用方法来触发。以下是三个基本的注解：

1\. _StartProfiling_ — 触发一个事件来启动 _Stage_ 或者 _Run_. 分析会在方法运行之前就开始。

    @StartProfiling(profilerName = "List pagination", runsCounter = 3, stageName = "Loading", stageOrder = 0)
      private void loadNextPage() { }

_StartProfiling_ 可以接受最多 5 个参数:

*   _profilerName_ — 分析者的名字将和标识 _Profiler_ 的 _runsCounter_ 一起显示在结果中。
*   _runsCounter_ — _Profiler_ 等待执行的任务的数量。结果只会在所有任务都完成只会才会显示。
*   _stageName_ — 用来标记一个即将执行的状态。名字会显示在结果中。
*   _stageOrder_ — 显示状态顺序。新开始的状态的序号必须大于嵌套最内层活跃状态的序号。同时，第一个状态的序号必须是 0。
*   _enabled_ — 当这个变量的值为“否”时，注解将被略过。

我想强调一点。 _Profiler_ 是由 _profilerName_ 和 _runsCounter_ 组合在一起进行识别的。如果你使用了相同的 _profilerName_ ， 但是不同的 _runsCounter_ ，你将会得到两份独立的、不同的报告， 而不是一个。

2\. _StopProfiling_ — 触发一个事件来停止 _Stage_ 或 _Run_. 分析会在方法运行结束后停止。当 _Stage_ 或 _Run_ 停止了，所有 _nested stage_ 都会停止。

    @StopProfiling(profilerName = "List pagination", runsCounter = 3, stageName = "Loading")
      private void displayNextPage() { }

它有和 _StartProfiling_ 相同的参数，除了 _stageOrder_ 。

3\. _MethodProfiling_ — _StartProfiling_ 和 _StopProfiling_ 的结合。

    @MethodProfiling(profilerName = "List pagination", runsCounter = 3, stageName = "Process", stageOrder = 1)
      private List processNextPage() { }

除了一个小地方需要注意之外，它有和 _StartProfiling_ 相同的参数。 如果 _stageName_ 是空的，那么它将会有方法的名字和类中产生。这么做是为了在不输入参数的情况下使用 _MethodProfiling_ 并得到一个有意义的结果。

因为 Java 7 并不支持可重复的注解，我为以上的注解写了一个注解集：

    @StartProfilings(StartProfiling[] value)

    @StopProfilings(StopProfiling[] value)

    @MethodProfilings(MethodProfiling[] value)

就像之前提到的，你可以直接调用一个方法来开始或结束分析：

    Pury.startProfiling();

    Pury.stopProfiling();

参数和对应的注解是完全相同的 —— 当然，除了 _enabled_ 。

#### 记录结果

_Pury_ 使用默认的记录器，但同时也允许你设置你自己喜欢的记录器。你要做的就是实现 _Logger_ 端口并在 _Pury.setLogger()_ 中进行设置。

    public interface Logger {
        void result(String tag, String message);
        void warning(String tag, String message);
        void error(String tag, String message);
    }

在默认情况下， _result_ 被记录在 _Log.d_ 中， _warning_ 被记录在 _Log.w_ 中， _error_ 被记录在 _Log.e_ 中。

#### 怎样开始使用 Pury？

要开始使用 _Pury_, 你只需要做两个简单的步骤。 第一，使用 AspectJ 插件, 市面上有不止一种这样的插件。我使用的是 [_WeaverLite_[3]](https://github.com/NikitaKozlov/WeaverLite)， _Pury_ 也使用这个插件。它非常轻便且易于使用。

    buildscript {
        repositories {
            jcenter()
        }
        dependencies {
            classpath 'com.nikitakozlov:weaverlite:1.0.0'
        }
    }
    apply plugin: 'com.nikitakozlov.weaverlite'

你可以在调试或发布版本中使用/禁用它。默认设置如下：

    weaverLite {
        enabledForDebug = true
        enabledForRelease = false
    }

第二，包括以下依赖:

    dependencies {
       compile 'com.nikitakozlov.pury:annotations:1.0.1'
       debugCompile 'com.nikitakozlov.pury:pury:1.0.2'
    }

如果你想在发布的时候分析, 在第二个依赖中使用 _compile_ 来代替 _compileDebug_ 。

#### 小建议

在没有设置一些常数的时候，管理多于5个状态是非常浪费时间的，所有我总是创建一个类，将某个分析情境需要用到的所有东西都集中在这个类里。就像这样：

    public final class StartApp {
        public static final String PROFILER_NAME = "App Start";
        public static final String TOP_STAGE ="App Start";
        public static final int TOP_STAGE_ORDER = 0;
        public static final String SPLASH_SCREEN = "Splash Screen";
        public static final int SPLASH_SCREEN_ORDER = TOP_STAGE_ORDER + 1;
        public static final String MAIN_ACTIVITY_LAUNCH = "Main Activity Launch";
        public static final int MAIN_ACTIVITY_LAUNCH_ORDER = SPLASH_SCREEN_ORDER + 1;
        public static final String MAIN_ACTIVITY_CREATE = "onCreate()";
        public static final int MAIN_ACTIVITY_CREATE_ORDER = MAIN_ACTIVITY_LAUNCH_ORDER + 1;
    }

就像你所看到的，每个 _ORDER_ 常数都是基于 _parent stage_，这样非常的方便。你还可以给 _runsCounter_ 添加一些常数来保证你每次用的都一样。你可以添加一个 _enabled_ 标记来轻松的禁用某个特定情境。

#### 结论

_Pury_ 是一个简洁的分析工具，它仅有三个注解需以及一点它们背后逻辑要学习。我希望你们不要把它想象的过分复杂。如果有什么问题的话，你们可以在这里我的 [GitHub[4]](https://github.com/NikitaKozlov/Pury) 里找到例子。

我很希望收到你们关于这个解决方案的看法。如果你们有任何的建议，欢迎在 [GitHub[5]](https://github.com/NikitaKozlov/Pury) 上创建一个 issue。你也可以通过 [Gitter[6]](https://gitter.im/NikitaKozlov/Pury) 来联系我。



