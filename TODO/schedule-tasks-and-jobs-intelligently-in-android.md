> * 原文地址：[Schedule tasks and jobs intelligently in Android](https://android.jlelse.eu/schedule-tasks-and-jobs-intelligently-in-android-e0b0d9201777)
> * 原文作者：[Ankit Sinhal](https://android.jlelse.eu/@ankit.sinhal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[PhxNirvana](https://juejin.im/user/57a16f4e6be3ff00650682d8)
> * 校对者：[ilumer](https://github.com/ilumer)、[wilsonandusa](https://github.com/wilsonandusa)

# Android 中的定时任务调度

![](https://cdn-images-1.medium.com/max/2000/1*WocBeIFoDtFZE7euHzm_Kg.png)


在近期的应用开发中，异步执行任务是很流行的，而且这些任务经常在应用的生命周期之外运行，如下载数据或更新网络资源。有些情况下我们还需要做一些并不是马上需要执行的工作。Android 提供了一些 API 来帮助我们在应用中调度这些任务。

选择合适调度器可以提升应用的性能并且延长电池使用时间。

Android M 还引入了 [打盹模式（Doze mode](https://developer.android.com/training/monitoring-device-state/doze-standby.html) 来减少用户在短期内不使用设备时的电池消耗。

Android 中可以使用的调度器有以下几种：

- Alarm Manager
- Job Scheduler
- GCM Network Manager
- Firebase Job Dispatcher
- Sync Adapter

### **Services 的问题**

Services 允许应用在后台执行长时间的操作， 但这一行为是十分耗电的。

当持续使用设备资源却没有有效任务在执行时，service 便更加有害了。当那些后台服务在监听不同系统广播时（比如 *CONNECTIVITY_CHANGE* 或者 *NEW_PICTURE* 等），问题的严重性还会提升。 

### **在应用的生命周期之内调度任务**

当应用正在运行时，如果我们想在特定时间执行任务的话，推荐使用 Handler 结合 Timer 和 Thread，而不是使用 Alarm Manger, Job Scheduler 等。使用 [Handler](https://developer.android.com/reference/android/os/Handler.html) 更简单高效。

### **在应用的生命周期之外调度任务**

### [**Alarm Manager**](https://developer.android.com/reference/android/app/AlarmManager.html)

AlarmManager 提供系统级的定时服务。正因此，也是一种在应用生命周期之外执行操作的方法。即使应用没有运行，也可以触发事件或动作。AlarmManager 可以在未来唤起服务。当达到预定时间时，触发特定的 PendingIntent。

注册过的定时任务会在设备休眠时保留（并且可以选择是否唤醒设备），但在关机和重启时会被清空。

**“我们应该只在执行特定时间的任务时使用 AlarmManager API。这并不是一个用来粗暴检查诸如设备空闲、网络状况或充电情况的方法。”**

**用例：**假设我们想在一小时后执行任务或每隔一小时执行一次任务， AlarmManager 是完美选择。但这 API 并不适合执行特定条件的任务，如网络好或不充电时执行任务这种情况。

### [**Job Scheduler**](https://developer.android.com/reference/android/app/job/JobScheduler.html)

这是所有提过的调度器中最主要的一个，它可以高效地执行后台任务。 *JobScheduler* API 是在 Android 5.0(API level 21) 引入的

该 API 可以在资源充足时或满足条件时批量执行任务。创建任务时可以定义执行的先决条件。当条件满足时，系统会在应用的 JobService 上执行任务。 *JobScheduler* 的执行也取决于系统的打盹模式和应用当前状态。

批量执行的特性使得设备可以更快地进入休眠，并拥有更长的休眠期，以此来延长电池使用时间。总而言之，这个 API 可以用来执行任何对时间不敏感的计划。

### [**GCM Network Manager**](https://developers.google.com/cloud-messaging/network-manager)

GCM (Google Cloud Messaging) Network Manager 有着 JobScheduler 的全部特性，GCM Network Manager 也用在重复的或一次性的，不紧急的任务上来延长电量。

这个 API 是向下兼容的，支持 Android 5.0 (API level 21) 以下。从 API level 23 开始，GCM Network Manager 使用 Android 框架的 JobScheduler。GCM Network Manager 使用 Google Play 服务 内置的调度器，所以这个类 **只会在安装了 Google Play 服务** 的设备上运行。

Google 强烈建议 GCM 的用户升级到 FCM 并使用 Firebase Job Dispatcher 执行任务调度。

### [**Firebase Job Dispatcher**](https://github.com/firebase/firebase-jobdispatcher-android#user-content-firebase-jobdispatcher-)

Firebase JobDispatcher 也是一个后台任务调度库。该库也被用来向下支持（低于 API level 21）并且支持所有近期 Android 设备（API level 9+）。

这个库也可以在没有安装 Google play 服务的设备，却仍想调度任务的应用上使用。这时，库内部的实现是 AlarmManager。如果设备上有 Google Play 服务，则会使用 Google Play 服务内置的调度器。

**提示：** 当 Google Play 服务不可用时，会使用 AlarmManager 来支持 API level <= 21 

如果设备是 API level 21 的话，则使用 JobScheduler。这个库的框架是相同的，所以没有什么功能改变。

### [**Sync Adapter**](https://developer.android.com/reference/android/content/AbstractThreadedSyncAdapter.html)

Sync adapter 是被特别设计用来同步设备和云端数据的。它的用途也只限定在这方面。同步可以在云端或客户端数据有改变时触发，也可以通过时间差或设定每日一次。Android 系统会试图执行批量同步来节省电量，无法同步的将会被放到队列中稍后执行。系统只在联网时会尝试执行同步。

不管什么情况，都建议使用 Google 提供的 JobScheduler、Firebase JobDispatcher、或 GCM Network Manager。

在 Android N (API level 24)中，SyncManager 在 JobScheduler （任务）的顶端。如果需要 SyncAdapter 提供的额外功能的话，建议只使用 SyncAdapter。

### **练习**

我们已经讨论了一堆理论性的东西，下面来看看如何使用 Android job scheduler。

**1. 建立 Job Service**

建立 *JobSchedulerService* 并继承 *JobService* 类，需要重写下面两个方法：*onStartJob(JobParameters params)* 和 *onStopJob(JobParameters params)*

    public class JobSchedulerService extends JobService {

    @Override

    public boolean onStartJob(JobParameters params) {

    return false;

    }

    @Override

    public boolean onStopJob(JobParameters params) {

    return false;

    }

    }


*onStartJob(JobParameters params)* 方法在 JobScheduler 决定执行任务时调用。JobService 在主线程工作，所以任何耗时操作都应该在另外的线程执行。*onStopJob(JobParameters params)* 在任务还没执行完（调用 jobFinished(JobParameters, boolean) 之前），但系统决定停止执行时调用。

还需要在 AndroidManifest 中注册 job service

    <application>

    <service

    android:name=”.JobSchedulerService “

    android:permission=”android.permission.BIND_JOB_SERVICE”

    android:exported=”true”/>

    </application>

**2. 创建 *JobInfo* 对象**

建立 *JobInfo* 对象需要将 *JobService* 传递到 *JobInfo.Builder()* 中，如下所示。这个 job builder 允许设置不同选项来控制任务的执行。

    ComponentName serviceName = new ComponentName(context, JobSchedulerService.class);

    JobInfo jobInfo = new JobInfo.Builder(JOB_ID, serviceName)

    .setRequiredNetworkType(JobInfo.NETWORK_TYPE_UNMETERED)

    .setRequiresDeviceIdle(true)

    .setRequiresCharging(true)

    .build();

**3. 调度任务**

现在有了 JobInfo 和 JobService ，所以是时候来调度任务了。 用 JobInfo 调度任务时只需要执行如下代码即可：

    JobScheduler scheduler = (JobScheduler) context.getSystemService(Context.JOB_SCHEDULER_SERVICE);

    int result = scheduler.schedule(jobInfo);

    if (result == JobScheduler.RESULT_SUCCESS) {

    Log.d(TAG, “Job scheduled successfully!”);

    }

可以在 [GitHub](https://github.com/AnkitSinhal/JobSchedulerExample) 下载 *JobSchedulerExample* 的源码

### **总结**

当调度任务时，需要仔细考虑执行的时间和条件，以及出错的后果。需要在应用性能和其他电池之类的条件间取舍。

*JobScheduler* 容易实现，并且处理了大多数的复杂情况。当使用 *JobScheduler* 时，即使系统重启我们的任务依旧可以执行下去。此刻，*JobScheduler* 唯一的缺点就是它最低只在 api level 21 (Android 5.0) 上提供。

感谢阅读。如果感觉有用，还请轻点❤来推荐文章给更多人。

关注接下来的文章。有任何意见和建议请通过下面的渠道联系我们： [Twitter](https://twitter.com/ankitsinhal)[Google+](https://plus.google.com/109883670809423986640)[LinkedIn](https://in.linkedin.com/in/ankit-sinhal-58a16319)

进入我的 [博客](http://androidjavapoint.blogspot.in/) 获取更多有趣的开发话题。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
