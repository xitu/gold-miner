>* 原文链接 : [Optimize Battery Life with Android's GCM Network Manager](https://www.bignerdranch.com/blog/optimize-battery-life-with-androids-gcm-network-manager/)
* 原文作者 : [Matt Compton](https://www.bignerdranch.com/about-us/nerds/matt-compton/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


The [GCM Network Manager](https://developers.google.com/android/reference/com/google/android/gms/gcm/GcmNetworkManager) enables apps to register services that perform network-oriented tasks, where a task is an individual piece of work to be done. The API helps with scheduling these tasks, allowing Google Play services to batch network operations across the system.

The API also helps simplify common networking patterns, such as waiting for network connectivity, network retries and backoff. Essentially, the GCM Network Manager allows developers to focus a little less on networking issues and more on the actual app, by providing a straightforward API for scheduling network requests.

## Battery Concerns and Networking

Before diving into the GCM Network Manager and what it offers, let’s take a detour and talk about battery concerns in relation to network requests, so that we understand _why_ batching together network calls is important.

Here’s a diagram of the Android radio state machine:

![Radio State Machine](https://www.bignerdranch.com/img/blog/2016/04/mobile_radio_state_machine.png "Radio State Machine")

It’s pretty straightforward. I include the diagram to reinforce the idea that waking up the radio is the most costly process when dealing with network connectivity. As such, network calls are one of the largest consumers of battery.

No single network transaction kills the battery, though, but rather the sheer number of individual requests that wake up the radio. If network requests are launched separately from one another, then the device is constantly awoken and the radio turned on. A device being constantly woken and unable to sleep causes a significant drain on the battery (just like with people who can’t sleep).

The diagram below shows an individual network request from an image fetching app called PhotoGallery, one of the sample apps from our best-selling [Android programming book](https://www.bignerdranch.com/we-write/android-programming/):

![Single Network Request](https://www.bignerdranch.com/img/blog/2016/04/network_request_single.png "Single Network Request")

Well, a single request doesn’t look so bad. The radio is awoken for it, but hey—it’s **only** one request, right?

Now here’s a diagram with multiple network calls:

![Multiple Network Request](https://www.bignerdranch.com/img/blog/2016/04/network_request_multiple.png "Multiple Network Request")

Suddenly we have multiple requests, and notice how the radio has woken up for each one, which will quickly drain the battery and annoy the end user.

We can easily improve battery life by making network calls in batches, as this optimizes the cost of starting up the radio. If the most expensive part of the radio lifecycle is the initial waking-up stage, then we’ll simply wake it up only once across these multiple requests. This method works well if the data being requested isn’t needed immediately, but instead will be used at some point in the future.

Here’s a diagram of the batched network calls:

![Batched Network Request](https://www.bignerdranch.com/img/blog/2016/04/network_request_batched.png "Batched Network Request")

Now the radio is only awoken once, saving battery life.

Sometimes you **do** need network calls immediately, like when you’re playing a game or sending a message. For those occasions, you should continue as normal with the individual network requests, but keep in mind that this type of network call does not optimize for battery life, network conditions or reboots.

## GcmTaskService

Now that we’ve seen the usefulness of batching multiple network requests in order to optimize for battery efficiency, let’s dive into how to implement GCM Network Manager in an app.

First, add the appropriate dependency for the GCM Network Manager to the `build.gradle` file:



    dependencies {
        ...
        compile 'com.google.android.gms:play-services-gcm:8.1.0'
        ...
    }



Make sure to depend only on the GCM subset of Google Play Services, or you will import all of Google Play Services, adding many methods and unnecessary bulk to your app.

Next, we must declare a new Service in the Android Manifest:

```
<service android:name=".CustomService"
        android:permission="com.google.android.gms.permission.BIND_NETWORK_TASK_SERVICE"
        android:exported="true">
   <intent-filter>
       <action android:name="com.google.android.gms.gcm.ACTION_TASK_READY"/>
   </intent-filter>
</service>
```

The name of the service (CustomService) is the name of the class that will extend GcmTaskService, which is the core class for dealing with GCM Network Manager. This service will handle the running of a task, where a task is any piece of individual work that we want to accomplish. The intent-filter of action `SERVICE_ACTION_EXECUTE_TASK` is to receive the notification from the scheduler of the GCM Network Manager that a task is ready to be executed.

Next, we’ll actually define the GcmTaskService, making a `CustomService.java` class that extends GcmTaskService:



    public class CustomService extends GcmTaskService {
            ...
    }



This is the class that will handle a task anytime it’s being run. Due to extending GcmTaskService, we must implement the `onRunTask` method in CustomService:



    @Override
    public int onRunTask(TaskParams taskParams) {
            Log.i(TAG, "onRunTask");
            switch (taskParams.getTag()) {
                    case TAG_TASK_ONEOFF_LOG:
                            Log.i(TAG, TAG_TASK_ONEOFF_LOG);
                            // This is where useful work would go
                            return GcmNetworkManager.RESULT_SUCCESS;
                    case TAG_TASK_PERIODIC_LOG:
                            Log.i(TAG, TAG_TASK_PERIODIC_LOG);
                            // This is where useful work would go
                            return GcmNetworkManager.RESULT_SUCCESS;
                    default:
                            return GcmNetworkManager.RESULT_FAILURE;
            }
    }



This is what’s called when it’s time for a task to be run. We check the tag of the TaskParams that’s been given as a parameter, as each tag will uniquely identify a different task that’s been scheduled. Normally some important networking task or logic would occur inside the case blocks, but this example just prints a log statement.

## GcmNetworkManager

Now that we’ve set up our GcmTaskService, we must grab a reference to the GcmNetworkManager object, which will be our hook into scheduling new tasks to be run for our previously defined service.



    private GcmNetworkManager mGcmNetworkManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);
            ...
            mGcmNetworkManager = GcmNetworkManager.getInstance(this);
    }


The GcmNetworkManager object will be used to schedule tasks, so one way to do this is to hold a reference as a member variable in `onCreate`. Alternatively, you can just get an instance of the GcmNetworkManager when you need it for scheduling.

## Scheduling Tasks

A single task is one individual piece of work to be performed, and there are two types: one-off and periodic.

We provide the task with a window of execution, and the scheduler will determine the actual execution time. Since tasks are non-immediate, the scheduler can batch together several network calls to preserve battery life.

The scheduler will consider network availability, network activity and network load. If none of these matter, the scheduler will always wait until the end of the specified window.

Now, here’s how we would schedule a one-off task:



    Task task = new OneoffTask.Builder()
                  .setService(CustomService.class)
                  .setExecutionWindow(0, 30)
                  .setTag(LogService.TAG_TASK_ONEOFF_LOG)
                  .setUpdateCurrent(false)
                  .setRequiredNetwork(Task.NETWORK_STATE_CONNECTED)
                  .setRequiresCharging(false)
                  .build();

    mGcmNetworkManager.schedule(task);


Using the builder pattern, we define all the aspects of our Task:

*   **Service:** The specific GcmTaskService that will control the task. This will allow us to cancel it later.
*   **Execution window:** The time period in which the task will execute. First param is the lower bound and the second is the upper bound (both are in seconds). This one is mandatory.
*   **Tag:** We’ll use the tag to identify in the `onRunTask` method which task is currently being run. Each tag should be unique, and the max length is 100.
*   **Update Current:** This determines whether this task should override any pre-existing tasks with the same tag. By default, this is false, so new tasks don’t override existing ones.
*   **Required Network:** Sets a specific network state to run on. If that network state is unavailable, then the task won’t be executed until it becomes available.
*   **Requires Charging:** Whether the task requires the device to be connected to power in order to execute.

All together, the task is built, scheduled on the GcmNetworkManager instance, and then eventually runs when the time is right.

Here’s what a periodic task looks like:


    Task task = new PeriodicTask.Builder()
                            .setService(CustomService.class)
                            .setPeriod(30)
                            .setFlex(10)
                            .setTag(LogService.TAG_TASK_PERIODIC_LOG)
                            .setPersisted(true)
                            .build();

    mGcmNetworkManager.schedule(task);


It seems pretty similar, but there are a few key differences:

*   **Period:** Specifies that the task should recur once every interval at most, where the interval is the input param in seconds. By default, you have no control over where in that period the task will execute. This setter is mandatory.
*   **Flex:** Specifies how close to the end of the period (set above) the task may execute. With a period of 30 seconds and a flex of 10, the scheduler will execute the task between the 20-30 second range.
*   **Persisted:** Determines whether the task should be persisted across reboots. Defaults to true for periodic tasks, and is not supported for one-off tasks. Requires “Receive Boot Completed” permission, or the setter will be ignored.

We’ve now seen the real strength of using the GCM Network Manager API, as the creation and scheduling of tasks is both simple and flexible.

## Canceling Tasks

We saw how to schedule tasks, so now we should also take a look at how to cancel them. There’s no way to cancel a task that is currently being executed, but we can cancel any task that hasn’t yet run.

You can cancel all tasks for a given GcmTaskService:



    mGcmNetworkManager.cancelAllTasks(CustomService.class);



And you can also cancel a specific task by providing its tag and GcmTaskService:



    mGcmNetworkManager.cancelTask(
            CustomService.TAG_TASK_PERIODIC_LOG,
            CustomService.class
    );



In either case, remember that an in-flight task cannot be canceled.

## Google Play Services

The entry point to scheduling a task with the network manager is the `schedule` method that we used earlier, which requires Google Play Services. In order to safely use Google Play Services, we should always check for its existence, like so:



    int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
    if (resultCode == ConnectionResult.SUCCESS) {
            mGcmNetworkManager.schedule(task);
    } else {
            // Deal with this networking task some other way
    }



If Google Play Services is unavailable, the GcmNetworkManager will just silently fail—so you should always check.

In a similar vein, when Google Play Services or the client app is updated, all scheduled tasks will be removed. To avoid losing all your currently scheduled tasks, GcmNetworkManager will invoke our GcmTaskService’s (so CustomService’s) `onInitializeTasks()` method. This method should be used to reschedule any tasks, which is most common when dealing with periodic tasks. Here’s an example:



    @Override
    public void onInitializeTasks() {
        super.onInitializeTasks();
        // Reschedule removed tasks here
    }



Simply override this function and reschedule the necessary tasks within it.

## Wrapping Up

Phew! We took a deep look at the GCM Network Manager and how to use it to conserve battery life, optimize network performance, and peform bits of batched work using Tasks. The next time you need to perform a bit of networking logic on a particular schedule, consider using the GCM Network Manager for a streamlined yet robust approach.

If you found this blog post interesting and would like to learn more about the exciting features of Android Marshmallow or the various new community tools, then check out our Android bootcamps:

*   [Beginning Android with Java](https://training.bignerdranch.com/classes/beginning-android-with-java)
*   [Android Fundamentals](https://training.bignerdranch.com/classes/android-fundamentals)
*   [Advanced Android](https://training.bignerdranch.com/classes/advanced-android)

