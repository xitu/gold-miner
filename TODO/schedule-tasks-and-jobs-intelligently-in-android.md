> * 原文地址：[Schedule tasks and jobs intelligently in Android](https://android.jlelse.eu/schedule-tasks-and-jobs-intelligently-in-android-e0b0d9201777)
> * 原文作者：[Ankit Sinhal](https://android.jlelse.eu/@ankit.sinhal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Schedule tasks and jobs intelligently in Android

![](https://cdn-images-1.medium.com/max/2000/1*WocBeIFoDtFZE7euHzm_Kg.png)

In the modern application development, it is very common for our application to perform tasks asynchronously and scope of them are outside the application’s life-cycle like downloading some data or updating network resources. In some situations we also have to do some work but it is not required to do it right now. To schedule background work, Android introduced several APIs which we can use wisely in our applications.

Selecting a proper scheduler can improve application performance and battery life of the device.

Android M also introduced [Doze mode ](https://developer.android.com/training/monitoring-device-state/doze-standby.html)to minimize battery drain while user has been away from device for a period of time.

There are several APIs available to schedule tasks in Android:

- Alarm Manager
- Job Scheduler
- GCM Network Manager
- Firebase Job Dispatcher
- Sync Adapter

### **Problems with Services**

Services allows you to perform long-running operations in the background. Running services in the background is very expensive for the battery life of the device.

Services are especially harmful when it continuously uses device resources even when not performing useful tasks. Above problem increased when those background services are listening for different system broadcasts (like CONNECTIVITY_CHANGE or NEW_PICTURE etc.).

### **Schedule task in lifetime of your app**

When application is running and we want to schedule or run a task at a specific time then it is recommended to use Handler class in conjunction with Timer and Thread. Instead of using Alarm Manger, Job Scheduler etc. it is easier and much more efficient to use [Handler](https://developer.android.com/reference/android/os/Handler.html).

### **Schedule task outside the lifetime of your app**

### [**Alarm Manager**](https://developer.android.com/reference/android/app/AlarmManager.html)

AlarmManager provides access to system-level alarm services. This give a way to perform any operations outside the lifetime of your application. So you can trigger events or actions even when your application is not running. AlarmManager can startup a service in future. It is used to trigger a PendingIntent when alarm goes off.

Registered alarms are retained while the device is asleep (and can optionally wake the device up if they go off during that time), but will be cleared if it is turned off and rebooted.

*“We should only use AlarmManager API for tasks that must execute at a specific time. This does not provide more robust execution conditions like device is idle, network is available or charging detect.”*

**Use Case: **Let’s say we want to perform a task after 1 hour or every 1 hour. In this case AlarmManager works perfectly for us. But this API is not suitable in a situations like perform the above task only when network is available or when device is not charging.

### [**Job Scheduler**](https://developer.android.com/reference/android/app/job/JobScheduler.html)

This is the chief among all the mentioned scheduling options and perform the background work very efficiently. *JobScheduler* API which was introduced in Android 5.0(API level 21).

This API allows to batch jobs when the device has more resources available or when the right conditions are met. All of the conditions can be defined when you’re creating a job. When the criteria declared are met, the system will execute this job on your application’s JobService. *JobScheduler* also defers the execution as necessary to comply with Doze mode and App Standby restrictions.

Batching job execution in this fashion allows the device to enter and stay in sleep states longer, preserving battery life. In general this API can be used to schedule everything that is not time critical for the user.

### [**GCM Network Manager**](https://developers.google.com/cloud-messaging/network-manager)

GCM (Google Cloud Messaging) Network Manager has all the schedule features from JobScheduler. GCM Network Manager is also meant for performing repeated or one-off, non-imminent work while keeping battery life in mind.

It is used to support backward compatibility and can also use below Android 5.0 (API level 21). From API level 23 or higher, GCM Network Manager uses the framework’s JobScheduler. GCM Network Manager uses the scheduling engine inside Google Play services so this class will **only work if the Google Play services is installed** on the device.

Google has strongly recommended for GCM users to upgrade to FCM and instead use Firebase Job Dispatcher for scheduling any tasks.

### [**Firebase Job Dispatcher**](https://github.com/firebase/firebase-jobdispatcher-android#user-content-firebase-jobdispatcher-)

The Firebase JobDispatcher is also a library for scheduling background jobs. It is also used to support backward compatibility (below API level 21) and works on all recent versions of Android (API level 9+).

This library will also works when running device do not have Google play services installed and wants to schedule a job in the application. In this condition this library internally uses AlarmManager. If Google Play service is available on the device then it uses the scheduling engine inside Google Play services.

**Tip:** It uses AlarmManager to support API levels <= 21 if Google Play services is unavailable.

For the device running on API level 21, it uses JobScheduler. This library also has the same framework so there is no change in functionality.

### [**Sync Adapter**](https://developer.android.com/reference/android/content/AbstractThreadedSyncAdapter.html)

Sync adapters are designed specifically for syncing data between a device and the cloud. It should be only use for this type of task. Syncs could be triggered from data changes in either the cloud or device, or by elapsed time and time of day. The Android system will try to batch outgoing syncs to save battery life and transfers that are unable to run will queue up for transfer at some later time. The system will attempt syncs only when the device is connected to a network.

Wherever possible, it is advised via Google to use JobScheduler, Firebase JobDispatcher, or GCM Network Manager.

In Android N (API level 24), the SyncManager sits on top of the JobScheduler. You should only use the SyncAdapter class if you require the additional functionality that it provides.

### **Exercise**

We discussed lots of theoretical things so now have a look how to use the Android job scheduler.

**1. Creating the Job Service**

Create *JobSchedulerService* and extend the *JobService* class, which requires that two methods be created *onStartJob(JobParameters params)* and *onStopJob(JobParameters params)*.

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

The method* onStartJob(JobParameters params) *gets called when the JobScheduler decides to run your job. The JobService runs on the main thread so any logic needs to be performed should be in a separate thread. Method *onStopJob(JobParameters params) *gets called if the system determined that you must stop execution of your job even before you’ve had a chance to call jobFinished(JobParameters, boolean).

You also have to register your job service in the AndroidManifest.

    <application>

    <service

    android:name=”.JobSchedulerService “

    android:permission=”android.permission.BIND_JOB_SERVICE”

    android:exported=”true”/>

    </application>

**2. Create *JobInfo* object**

To construct a *JobInfo* object, pass the *JobService* into *JobInfo.Builder()* as shown below. This job builder allows to set many different options for controlling when job executes.

    ComponentName serviceName = new ComponentName(context, JobSchedulerService.class);

    JobInfo jobInfo = new JobInfo.Builder(JOB_ID, serviceName)

    .setRequiredNetworkType(JobInfo.NETWORK_TYPE_UNMETERED)

    .setRequiresDeviceIdle(true)

    .setRequiresCharging(true)

    .build();

**3. Schedule Job**

Now we have JobInfo and JobService so it is time to schedule our job. All we need to do is to schedule a job with desired JobInfo as shown below:

    JobScheduler scheduler = (JobScheduler) context.getSystemService(Context.JOB_SCHEDULER_SERVICE);

    int result = scheduler.schedule(jobInfo);

    if (result == JobScheduler.RESULT_SUCCESS) {

    Log.d(TAG, “Job scheduled successfully!”);

    }

You can download the complete source code of *JobSchedulerExample* from [GitHub](https://github.com/AnkitSinhal/JobSchedulerExample).

### **Conclusion**

While scheduling a job, you’ll need to think carefully about when and what should trigger your job and what should happen if it fails for some reason. You have to be very careful with your app performance along with other aspects such as battery life.

*JobScheduler* is easy to implement and handle most of the complexity for you. While using *JobScheduler*, our scheduled jobs persists even if system reboots. At this moment the only downside of *JobScheduler* is that it is only available for api level 21 (Android 5.0).

Thanks for reading. To help others please click ❤ to recommend this article if you found it helpful.

Stay tuned for upcoming articles. For any quires or suggestions, feel free to hit me on [Twitter](https://twitter.com/ankitsinhal)[Google+](https://plus.google.com/109883670809423986640)[LinkedIn](https://in.linkedin.com/in/ankit-sinhal-58a16319)

Check out my[ blogger page](http://androidjavapoint.blogspot.in/) for more interesting topics on Software development.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
