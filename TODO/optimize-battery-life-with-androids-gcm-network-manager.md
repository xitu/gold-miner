> * 原文链接 : [Optimize Battery Life with Android's GCM Network Manager](https://www.bignerdranch.com/blog/optimize-battery-life-with-androids-gcm-network-manager/)
* 原文作者 : [Matt Compton](https://www.bignerdranch.com/about-us/nerds/matt-compton/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [程大治](http://blog.chengdazhi.com)
* 校对者: [leokelly](https://github.com/leokelly), [Zhongyi Tong](https://github.com/geeeeeeeeek)

# 使用 GCM 网络管理工具优化电池使用

通过[GCM网络管理工具](https://developers.google.com/android/reference/com/google/android/gms/gcm/GcmNetworkManager)我们可以注册用于执行网络任务的服务，其中每一个任务都是一件独立的工作。GCM的API帮助进行任务的调度，并让Google Play服务在系统中批量进行网络操作。

其API还有助于简化网络操作模式，比如等待网络连接、进行网络重连与补偿等。总的来说，GCM网络管理工具通过提供一个简洁明快的网络请求调度API来帮助开发者在网络相关的问题上少费心思。

## 电量和网络操作

在深入GCM与其优势之前，我们先聊一聊与网络请求相关的电池使用问题，这有助于我们认识批量处理网络操作的重要性。

下面是Android通讯模块(radio)的状态机：

![radio_diagram](http://7xpg2f.com1.z0.glb.clouddn.com/mobile_radio_state_machine.png)

这个图还是挺清晰的。我想通过这个图表告诉大家唤醒通讯模块是处理网络连接时最耗电的操作，也就是说，网络操作是电池最大的消耗者。

虽然一个网络操作不可能耗尽电池，但唤醒通讯模块所发送的单个请求数目相当可观。如果网络请求是单独发送的，那么设备就会被持续唤醒，通讯模块也会保持开启状态。设备持续唤醒无法休眠会导致电量大幅消耗。（就如人睡不着觉一样）

下面的示意图说明了一个叫PhotoGallery的图片获取APP的单次网络请求，这个APP也是我们的畅销书[Android Programming Book](https://www.bignerdranch.com/we-write/android-programming/)中的一个示例APP。

![network_request](http://7xpg2f.com1.z0.glb.clouddn.com/network_request_single.png)

看起来单次网络操作也没啥。网络模块被唤醒了，但这只是单次请求。

而多次请求的示意图是这样的：

![network_multiple](http://7xpg2f.com1.z0.glb.clouddn.com/network_request_multiple.png)

现在我们有了多次网络请求，注意观察网络模块在每次请求时都被唤醒，这会快速消耗电量，让使用者不爽。

在这里我们可以通过批量进行网络操作来优化电池使用，因为这可以减少启动网络模块所消耗的电量。如果网络模块生命周期中最耗电的部分是启动部分，那么我们可以在多次请求中只唤醒一次。如果我们所请求的数据不需要马上获取，而是在未来的某个时间点需要用到，那这种方式还算可行。

批量网络请求的示意图如下：

![network_batch](http://7xpg2f.com1.z0.glb.clouddn.com/network_request_batched.png)

现在网络模块只会唤醒一次，省了不少电。

有时你的确马上需要用到网络请求的数据，如打游戏或者发短信的情况。这些情况下，还是需要发送单次网络请求，不过要记住这对电池、网络状态和设备重启并无好处。

## GcmTaskService

既然我们已经看到了批量进行网络请求对优化电池使用能起到不小的作用，现在让我们在应用中实现GCM网络管理工具。

首先，在build.gradle文件中添加GCM网络管理工具的依赖。

	dependencies {
		...
		compile 'com.google.android.gms:play-services-gcm:8.1.0'
		...
	}

切记只需依赖Google Play Services的GCM部分，不然你需要依赖所有的Google Play Service，而其中大部分是用不到的方法。

下一步，我们需要在AndroidManifest中声明一个新的Service：

	<service android:name=".CustomService"
			android:permission="com.google.android.gms.permission.BIND_NETWORK_TASK_SERVICE"
			android:exported="true">
		<intent-filter>
			<action android:name="com.google.android.gms.gcm.ACTION_TASK_READY"/>
		</intent-filter>
	</service>

这里Service的name属性是继承了GcmTaskService的类的类名，GcmTaskService是与GCM网络管理工具交互的核心类。这个Service会处理任务的执行，这里的任务是任何网络工作的一部分。上面代码中action是ACTION_TASK_READY的intent-filter是用于接收GCM中的调度工具所发送的某任务可被执行的通知。

下一步，我们写一个CustomService.java继承GcmTaskService：

	public class CustomService extends GcmTaskService {
		...
	}

这个类会处理所有执行中的任务。由于继承了GcmTaskService，我们需要在CustomService中重写onRunTask方法。

	@Override
	public int onRunTask(TaskParams taskParams) {
		Log.i(TAG, "onRunTask");
		switch (taskParams.getTag()) {
			case TAG_TASK_ONEOFF_LOG:
				Log.i(TAG, TAG_TASK_ONEOFF_LOG);
				// 进行逻辑处理
				return GcmNetworkManager.RESULT_SUCCESS;
			case TAG_TASK_PERIODIC_LOG:
				Log.i(TAG, TAG_TASK_PERIODIC_LOG);
				// 进行逻辑处理
				return GcmNetworkManager.RESULT_SUCCESS;
			default:
				return GcmNetworkManager.RESULT_FAILURE;
		}
	}

当某一个任务需要执行时，这个方法就会被调用。我们在这里要检测作为参数传入的TaskParams的tag，一个tag单独映射到一个被调度的任务。一般来说我们需要在case代码块中添加网络操作或逻辑操作，但在这里我只打了一个tag。

## GcmNetworkManager

现在我们写好了GcmTaskService，我们需要获取到GcmNetworkManager对象的引用，并通过它调度新的任务让刚才写的Service执行。

	private GcmNetworkManager mGcmNetworkManager;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		...
		mGcmNetworkManager = GcmNetworkManager.getInstance(this);	}

GcmNetworkManager对象是用来调度网络任务的，所以我们可以在onCreate中获取其引用并存为成员变量。或者，你也可以在需要进行网络调度时再获取实例（饿汉）。

## 任务调度

一个单独的任务相当于一件等待执行的工作，可以分为两种类型：一次性的(OneoffTask)和周期性的(PeriodicTask)。

我们将执行区间(window of execution)传给任务，而后调度工具就会计算确切的执行时间。因为这些任务不需要立即执行，调度器会将许多网络请求捆绑执行来节省电量。

调度器会自己判断网络连接情况、网络任务与网络负荷，如果这些因素都正常，调度工具会等待至给定区间的结束点。

下面是调度一个单次任务的代码：

	Task task = new OneoffTask.Builder()
			.setService(CustomService.class)
			.setExecutionWindow(0, 30)
			.setTag(LogService.TAG_TASK_ONEOFF_LOG)
			.setUpdateCurrent(false)
			.setRequiredNetwork(Task.NETWORK_STATE_CONNECTED)
			.setRequiresCharging(false)
			.build();
	
	mGcmNetworkManager.schedule(task);

通过使用Builder模式，我们给定了任务的所有参数：

* Service: 用于控制任务的确切GcmTaskService。这样我们可以在后面停止它。
* ExecutionWindow：任务执行的时间区间。第一个参数是最低时间，第二个参数是最高时间（都是以秒为单位）。这个参数是强制的。
* Tag：这里通过tag来在onRunTask方法中识别哪一个任务正在执行。每个tag都应该是唯一的，长度上限是100位。
* UpdateCurrent：判断该任务是否要覆盖之前存在的有相同tag的任务。默认情况下这个参数是false，也就是不覆盖。
* RequiredNetwork：设置一个任务执行所需的网络状态。在这里如果无网络连接，任务就不会被执行。
* RequiresCharging：任务执行是否需要设备处在充电状态。

都设置好之后，任务就被构建好了，通过GcmNetworkManager实例进行调度，然后在某个时间执行。

而调度一个周期性任务要这样做：

	Task task = new PeriodicTask.Builder()
			.setService(CustomService.class)
			.setPeriod(30)
			.setFlex(10)
			.setTag(LogService.TAG_TASK_PERIODIC_LOG)
			.setPersisted(true)
			.build();
	
	mGcmNetworkManager.schedule(task);

和上面的代码区别不大，主要的区别有这些：

* Period：指定该任务至少要每个时间区间执行一次，时间区间以秒为单位作为参数传入。默认情况下你无法控制任务是在时间区间内的哪个具体时间点执行。这个参数是强制的。
* Flex：指定该任务需要在距离结束点多长时间之内执行。在这里Period是30，Flex是10，那么任务就会在20-30秒的区间内执行。
* Persisted：判断该任务在重启过程后是否保留。默认情况下周期性任务的这个参数都是true，而一次性任务没有这个参数。如果是true则需要Receive Boot Completed权限，不然无效。

看到GCM网络管理工具的API有多么的强大了吧？创建和调度代码简直不能更简单。

## 取消任务

我们已经看到了如何调度任务，所以还需要看一下如何取消任务。正在执行的任务是无法被取消的，但我们可以取消还未被执行的任务。

你可以直接取消给定GcmTaskService的所有任务：

	mGcmNetworkManager.cancelAllTasks(CustomService.class);

你也可以通过给出tag和GcmTaskService来取消一个具体任务：

	mGcmNetworkManager.cancelTask(
			CustomService.TAG_TASK_PERIODIC_LOG,
			CustomService.class
	);

不管怎样，要记住正在执行的任务无法取消。

## Google Play服务

使用网络管理工具调度任务的起始点就是刚才使用到的schedule方法，而这需要Google Play服务。为了正常使用其服务，我们需要进行如下检测：

	int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);
	if (resultCode == ConnectionResult.SUCCESS) {
		mGcmNetworkManager.schedule(task);
	} else {
		// 以其他方式处理task
	}

如果Google Play服务不可使用，GcmNetworkManager会静默失效，这就是为什么需要提前检测。

类似地，当Google Play服务或是客户端APP被升级，所有的已调度的任务都会失效。为了避免丢失当前已调度的任务，GcmNetworkManager会调用GcmTaskService(这里是CustomService)的onInitializeTasks()方法。这个方法是用来重新调度任务的，对周期性任务尤其常见。下面是示例：

	@Override
	public void onInitializeTasks() {
		super.onInitializeTasks();
		// 重新调度已失效的任务
	}

## 总结

我们已经深入研究了一下GCM网络管理工具，以及如何用它来节省电量，优化网络表现，并使用Task进行批量工作。下次你需要在某个时间进行一些网络操作的时候，不妨考虑使用GCM网络管理工具使网络访问更加精简且不失健壮。

如果你觉得这篇文章还算因吹斯挺，打算学习更多有关Android Marshmallow或其他社区工具的特点，不妨查看下面的链接（英文）：

* [用Java开始开发Android](https://training.bignerdranch.com/classes/beginning-android-with-java)
* [Android基础](https://training.bignerdranch.com/classes/android-fundamentals)
* [Android进阶](https://training.bignerdranch.com/classes/advanced-android)








