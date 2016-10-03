> * 原文地址：[Pury — 一个新的 Android App 分析工具](https://medium.com/@nikita.kozlov/pury-new-way-to-profile-your-android-application-7e248b5f615e)
* 原文作者：[Nikita Kozlov](https://medium.com/@nikita.kozlov)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[欧文](https://github.com/owenlyn)
* 校对者：

手机应用存在的目的，就是在帮助用户做他们想做的事情的同时，提供最好的用户体验 —— 而用户体验的重中之重是应用的性能。 但有时候开发者们却以性能为借口，既没有达到既定目标，写出的代码质量低并难以维护。 在这里我想引用 Michael A. Jackson 的一句话：

> “程序优化守则第一条：别去做它。 程序优化守则第二条（仅限于专业人员）：别去做它，现在还不是时候。”



![](https://cdn-images-1.medium.com/max/1600/1*YVKsfvtGMavBcYOo_tTHbA.jpeg)





在开始任何优化之前，我们要先认清问题的症结所在。 第一步，我们先收集和App性能表现的常规数据。比如，从调用 _startActivity()_ 到数据显示在屏幕上的时间。 又比如，加载下一页 _RecyclerView_ 的内容所需要的时间。 我们把这个时间和一个可以接受的阀值进行比较就可以发现有没有什么问题需要改进了。当应用程序使用的时间比预计的要长的时候，我们就需要深入的查看并找出是哪些方法（函数）或者API（应用程序接口）出了问题。

幸运的是，我们有一些工具来分析安卓应用程序（的性能）：

1. [Hugo[1]](https://github.com/JakeWharton/hugo) 是一个库，它提供注释驱动的方法调用日志。你只需要在你的方法上用 _@DebugLog_ 注释，然后它就会记录参数，返回值以及运行所需的时间。我很喜欢这个库，但是这个库仅仅适用于单个方法的调用，所以并不能用来测量从调用 _startActivity()_ 到数据显示在屏幕上的时间。
2. Android Stutio 工具包，比如 System Trace，就是一个非常精确且提供很多信息的工具。但你需要花很多时间来收集、分析数据。
3. 后端解决方案，比如 [JMeter[2]](https://jmeter.apache.org/)。 这些工具有很多功能，但需要很多时间来学习怎么使用它们。不过话说回来，你经常需要在大量并发负载下分析一个应用程序吗？这看起来并不像一个常见的情况。

#### 缺少的工具

如果你深入思考一下关于应用程序速度的问题，可以发现其中的一大部分可以被分成两类：


1. 某个特定方法或者 API 的调用。这个可以用，比如 Hugo, 来解决。
2. 两个不同事件之间的时间。这可能发生在独立的、但逻辑上关联的两段代码之间。 Android Studio 工具包可以解决这个问题，但就像前面说过的，你需要在这上面花很多时间。 

当我在搜寻可用的分析工具并思考所有的可能性的时候，我意识到至少一样工具是没有的，所以我列出了一下需求：

1. 分析程序的开始和结束应该是两个看一看独立触发的事件，这样我们就可以按照需求来灵活使用它了。
2.  如果我们想要监视应用的性能表现，仅仅有开始和结束是不够的。有些时候我们想要知道中间到底发生了什么。所有关于中间过程的信息应该被汇总在一个大的报告中。这让分析和分享数据变得更加简单。
3.  有时候，有些脚本是经常被重复调用的，比如，为 _RecycylerView_ 加在下一页的内容。这时候，仅仅对这段脚本进行一次分析是不够的 —— 我们需要一些统计数据，比如平均，最快和最慢的时间，可以给我们提供更多思考（insights：思考/见解？）。

这就是为什么我开发了 _Pury_ 。

#### 介绍 Pury

_Pury_ 是一个用来分析多个独立事件之间的时间的库。事件可以用注释或者调用方法来出发。一个脚本的所有事件都被汇总到一个报告中。

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

在深入介绍文档事前，我想简单介绍一下 Pury 的内部结构以及它的不足。这会帮助（你们）了解方法的参数以及报错的信息。

性能测试都是由 _Profiler_ 来完成的。 每个 _Profiler_ 都包含了一个 _Runs_ 列表。多个 _Profilers_ 可以并行运行，但每个 _Profiler_ 只能同时运行一个 _Run_ 。 当一个 _Profiler_ 内所有的 _Run_ 都运行完成时，就会有一个报告自动生成。_Runs_ 的数量由 _runsCounter_ 这个参数来决定。





![](https://cdn-images-1.medium.com/freeze/max/60/1*tYB7kEVojU-s0pRcNApIwQ.jpeg?q=20)

![](http://ww3.sinaimg.cn/large/006y8lVagw1f89jd8r2l8j30z50ltq5z.jpg)





两个并列运行的 _Profilers_。第一个只有一个 _Run_ 并且处于活跃状态中。第二个有一个停止的 _Run_ 和一个活跃的 _Run_，每个 _Run_ 都包含了一个包含两个子状态的根状态。活跃状态是绿色的，停止状态是红色的。



_Run_ 内部有一个 _根状态_ 。每个状态都有一个名字，一个序列号和一个不限定数量的、嵌套的 _子状态_ 。每个 _状态_只能有一个活跃的、嵌套的 _子状态_ 。 如果你停止了一个 _母状态_ ，那么所有这个状态的 _子状态_ 也会停止。（这里把 “Stage” 翻译成“状态”合适吗，有没有更好的翻译？或者不翻译？）

#### 使用 Pury 

就想之前提到的， _Pury_ 测量多个独立事件之间的时间。事件可以由注释或调用方法来触发。以下是三个基本的注释：

1\. _StartProfiling_ — triggers an event to start S_tage_ or _Run_. Profiling will start before method execution.

    @StartProfiling(profilerName = "List pagination", runsCounter = 3, stageName = "Loading", stageOrder = 0)
      private void loadNextPage() { }

_StartProfiling_ can accept up to 5 arguments:

*   _profilerName — _name of the profiler is displayed in the result. Along with _runsCounter_ identifies the _Profiler._
*   _runsCounter — _amount of runs for _Profiler_ to wait for. Result is available only after all runs are stopped.
*   _stageName_ — identifies a stage to start. Name is displayed in the result.
*   _stageOrder — _stage order reflects the hierarchy of stages. In order to start a new stage, it must be bigger then order of current most nested active stage. Stage order is a subject to one more limitation: first start event must have order number equal zero.
*   _enabled — _if set to false, an annotation is skipped.

I want to emphasise one fact. _Profiler_ is identified by combination of _profilerName_ and _runsCounter._ So if you are using same _profilerName_, but different _runsCounter,_ then you will get two separate results, instead of a combined one.

2\. _StopProfiling_ — triggers an event to stop S_tage_ or _Run_. Profiling is stopped after method execution. Once S_tage_ or _Run_ is stopped, all nested stages are also stopped.

    @StopProfiling(profilerName = "List pagination", runsCounter = 3, stageName = "Loading")
      private void displayNextPage() { }

It has the same arguments as _StartProfiling,_ except _stageOrder._

3\. _MethodProfiling_ — combination of _StartProfiling_ and _StopProfiling._

    @MethodProfiling(profilerName = "List pagination", runsCounter = 3, stageName = "Process", stageOrder = 1)
      private List processNextPage() { }

It has exact same arguments as _StartProfiling_ with one small remark. If _stageName_ is empty then it will be generated from method’s name and class. This is made in order to be able to use _MethodProfiling_ without any arguments and get a meaningful result.

Since Java 7 doesn’t support repeatable annotations, I made group annotations for each of annotation above:

    @StartProfilings(StartProfiling[] value)

    @StopProfilings(StopProfiling[] value)

    @MethodProfilings(MethodProfiling[] value)

As already mentioned, you can call start or stop profiling with a direct call:

    Pury.startProfiling();

    Pury.stopProfiling();

Arguments are exactly the same as in corresponding annotations, except _enabled,_ of course.

#### Logging Results

By default _Pury_ uses default logger, but it also allows you to set your own one. All you need to do is to implement _Logger_ interface and set it via _Pury.setLogger()._

    public interface Logger {
        void result(String tag, String message);
        void warning(String tag, String message);
        void error(String tag, String message);
    }

By default _result_ goes to _Log.d_, _warning_ to _Log.w_ and _error_ to _Log.e_.

#### How to start using Pury?

To start using _Pury_, you need to do two simple steps. First, apply AspectJ weaving plugin, there are more than one such a plugin out there. I’m using [_WeaverLite_[3]](https://github.com/NikitaKozlov/WeaverLite), _Pury_ itself uses it as well. It is small and easy to configure.

    buildscript {
        repositories {
            jcenter()
        }
        dependencies {
            classpath 'com.nikitakozlov:weaverlite:1.0.0'
        }
    }
    apply plugin: 'com.nikitakozlov.weaverlite'

You can enable/disable it on a debug and/or release build. Default configuration looks like this.

    weaverLite {
        enabledForDebug = true
        enabledForRelease = false
    }

Second, include following dependencies:

    dependencies {
       compile 'com.nikitakozlov.pury:annotations:1.0.1'
       debugCompile 'com.nikitakozlov.pury:pury:1.0.2'
    }

If you want to profile on release, then use _compile_ instead of _compileDebug_ for a second dependency.

#### Small recommendation

Managing more then 5 stages without a usage of constants could be time-wasting, so I always create a class where everything about one profiling scenario is centralised. It looks like this:

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

As you can see, every _ORDER_ constant depends on the parent’s stage, it is very handy. You can also add a constant for _runsCounter_ to be sure that you are always using the same one. If you add here an _enabled_ flag then you can easily disable one particular scenario from a single place.

#### Conclusion

_Pury_ is a concise profiling tool, that has only three annotations to work with and a bit of logic behind it. I hope you don’t find it unreasonably complex. In case of problems you can always take a look into an example on [GitHub[4]](https://github.com/NikitaKozlov/Pury).

I would like to hear your opinion about this solution. If you have any suggestions please feel free to rise an issue on [GitHub[5]](https://github.com/NikitaKozlov/Pury). You can also contact me via [Gitter[6]](https://gitter.im/NikitaKozlov/Pury).



