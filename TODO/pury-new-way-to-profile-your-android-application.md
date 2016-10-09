> * 原文地址：[Pury — New Way to Profile Your Android Application](https://medium.com/@nikita.kozlov/pury-new-way-to-profile-your-android-application-7e248b5f615e)
* 原文作者：[Nikita Kozlov](https://medium.com/@nikita.kozlov)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

Applications are all about helping users to do what they need to, while providing best User Experience possible. Significant part of it is performance. Sometimes in the name of efficiency developers are writing low quality code that is difficult to support and maintain, without necessarily achieving positive results. In this regards I would like to quote Michael A. Jackson:

> “The First Rule of Program Optimisation: Don’t do it. The Second Rule of Program Optimisation (for experts only!): Don’t do it yet.”





![](https://cdn-images-1.medium.com/max/1600/1*YVKsfvtGMavBcYOo_tTHbA.jpeg)





Before starting any optimisation we need to identify the problem. As a first step we should collect general data about application performance. For example, time from _startActivity()_ call until data is displayed on the new screen. Or time it takes to load next page of content for a _RecyclerView._ Comparing this information with acceptable thresholds can tell us if there is a problem. In case something takes longer then expected, we can check more deeply and identify method or API call that caused the issue.

Luckily for us, there are some tools for profiling Android applications:

1.  [Hugo[1]](https://github.com/JakeWharton/hugo) — library that provides annotation-triggered method call logging. You need to annotate your method with _@DebugLog_, and it will log arguments, return values, and the time it took to execute. I like it, but it is limited to a single method call, so you can’t measure time it takes from opening Activity till displaying content.
2.  Android Studio toolset, for example System Trace, is very precise and provides a lot of information. But you need to spend a significant amount of time to collect and analyze the data.
3.  Backend solutions, for example [JMeter[2]](https://jmeter.apache.org/). They have a lot of functionality, but it takes lots of efforts and time, first, to learn and, second, to use them. And after all, how often do you need to profile an application under heavy concurrent load? It doesn’t look like a common case in Android Development.

#### Missing tool

If you take a closer look into questions we are asking about speed of our applications, most of them can be separated into two blocks:

1.  Execution time for a particular method or API call. This can be covered by Hugo, for example.
2.  Time between two different events, that could happened in independent pieces of the code, but connected in terms of logic. Android Studio toolset can cover this topic, but, as already mentioned, you need to spend significant amount of time to profile.

While I was checking available profiling tools and trying to imagine all the possible cases, I realised that at least one tool is missing. So I came up with following requirements for it:

1.  Start and stop profiling should be triggered with two independent events, that will allow us to be as flexible as it needs.
2.  If we want to monitor application performance, then having just start and stop events is not enough. Sometimes we want to know more about what happens in between. Information about all intermediate stages should be united into one big report. That will allow us to easier understand and share the data.
3.  Sometimes we have scenarios that repeats frequently, for example, loading next page of content for a _RecyclerView._ Then one round of profiling is not enough, having statistical data, like average, minimal and maximal times, can give us more insights.

That is why I created _Pury_.

#### Introduction to Pury

_Pury_ is a profiling library for measuring time between multiple independent events. Events can be triggered with one of the annotations or with a method call. All events for a single scenario are united into one report.

Output for launching an example application:

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
      

As you can see, Pury measured time for launching the application, including intermediate stages, like loading data on splash screen and activity’s lifecycle methods. For each stage start and stop timestamps are displayed and so as execution time. Apart from the normal profiling, it could be useful for performance monitoring, to be sure that some changes don’t introduce an unexpected latency.

Output for a screen with pagination:

```
Get Next Page --> 0ms
  Load --> avg = 1.80ms, min = 1ms, max = 3ms, for 5 runs
  Load <-- avg = 258.40ms, min = 244ms, max = 278ms, for 5 runs
  Process --> avg = 261.00ms, min = 245ms, max = 280ms, for 5 runs
  Process <-- avg = 114.20ms, min = 99ms, max = 129ms, for 5 runs
Get Next Page <-- avg = 378.80ms, min = 353ms, max = 411ms, for 5 runs
```

In this example, as you can see, _Pury_ collected information about loading next page 5 times and then took the average. For each stage start timestamp and execution time are displayed.

#### Inner structure and limitations

Before diving into the documentation, I would like to make a small introduction to Pury’s inner structure and limitations. It will help to understand methods’ arguments and error messages.

Performance measurements are done by _Profilers._ Each _Profiler_ contains a list of _Runs_. Multiple _Profilers_ can work in parallel, but only a single _Run_ per each _Profiler_ can be active. Once all _Runs_ in a single _Profiler_ are finished, result is reported. Amount of runs defines by _runsCounter_ parameter.





![](https://cdn-images-1.medium.com/freeze/max/60/1*tYB7kEVojU-s0pRcNApIwQ.jpeg?q=20)

![](http://ww3.sinaimg.cn/large/006y8lVagw1f89jd8r2l8j30z50ltq5z.jpg)





Two _Profilers_ running in parallel. First has a single _Run_ with an active stage. Second has one stopped _Run_ and one active, each of Runs contains a root Stage with two nested Stages. Active stages are green, stopped stages are red.



_Run_ has a root _Stage_ inside. Each _Stage_ has a name, an order number and an arbitrary amount of nested _Stages_. _Stage_ can have only one active nested _Stage_. If you stop a parent _Stage,_ then all nested _Stages_ are also stopped.

#### Profiling with Pury

As already mentioned, _Pury_ measures time between multiple independent events. Events can be triggered with one of the annotations or with a method call. There are three base annotations:

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

#### Logging Results

By default _Pury_ uses default logger, but it also allows you to set your own one. All you need to do is to implement _Logger_ interface and set it via _Pury.setLogger()._

    public interface Logger {
        void result(String tag, String message);
        void warning(String tag, String message);
        void error(String tag, String message);
    }

By default _result_ goes to _Log.d_, _warning_ to _Log.w_ and _error_ to _Log.e_.

#### How to start using Pury?

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
