> * 原文地址：[WorkManager Basics](https://medium.com/androiddevelopers/workmanager-basics-beba51e94048)
> * 原文作者：[Lyla Fujiwara](https://medium.com/@lylalyla)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/workmanager-basics.md](https://github.com/xitu/gold-miner/blob/master/TODO1/workmanager-basics.md)
> * 译者：[Rickon](https://github.com/gs666)
> * 校对者：[Feximin](https://github.com/Feximin)

# WorkManager 基础入门

![](https://cdn-images-1.medium.com/max/800/0*_fXBLlwf_uEp7nDj)

插图来自 [Virginia Poltrack](https://twitter.com/VPoltrack)

欢迎来到我们 WorkManager 系列的第二篇文章。[WorkManager](https://developer.android.com/topic/libraries/architecture/workmanager/) 是一个 [Android Jetpack](https://developer.android.com/jetpack/) 库，当满足工作的约束条件时，用来运行可延迟、需要保障的后台工作。对于许多类型的后台工作，WorkManager 是当前的最佳实践方案。[在第一篇博文中](https://juejin.im/post/5ca3463bf265da308939f9b1)，我们讨论了 WorkManager 是什么以及何时使用 WorkManager。

在这篇博文中，我将介绍：

*   将你的后台任务定义为工作
*   定义特定的工作应该如何运行
*   运行你的工作
*   使用链进行存在依赖的工作
*   监视你的工作的状态

我还将解释 WorkManager **幕后**发生的事情，以便你可以就如何使用它做出明智的决定。

### 从一个例子开始

假设你有一个图片编辑应用，可让你给图像加上滤镜并将其上传到网络让全世界看到。你希望创建一系列后台任务，这些任务用于滤镜，压缩图像和之后的上传。在每个环节，都有一个需要检查的约束——给图像加滤镜时要有足够的电量，压缩图像时要有足够的存储空间，以及上传图像时要有网络连接。

![](https://cdn-images-1.medium.com/max/800/0*GuigyLoSuBZ86hH1)

这个例子如上图所示

这个例子正是具有以下特点的任务：

*   **可延迟的**，因为你不需要它立即执行，而且实际上可能希望等待某些约束被满足（例如等待网络连接）。
*   需要**确保**能够运行，无论应用程序是否退出，因为如果加了滤镜后的图像永远没能与世界共享，你的用户会非常不满意！

这些特点使我们的图像加滤镜和上传任务成为 WorkManager 的完美用例。

### 添加 WorkManager 依赖

本文使用 Kotlin 书写代码，使用 KTX 库（KoTlin eXtensions）。KTX 版本的库提供了 [扩展函数](https://developer.android.com/reference/kotlin/androidx/work/package-summary#extension-functions-summary) 为了更简洁和习惯的使用 Kotlin。你可以添加如下依赖来使用 KTX 版本的 WorkManager：

```
dependencies {
 def work_version = "1.0.0-beta02"
 implementation "android.arch.work:work-runtime-ktx:$work_version"
}
```

你可以在 这里](https://developer.android.com/topic/libraries/architecture/adding-components#workmanager) 到该库的最新版本。如果你想使用 Java 依赖，那就移除“-ktx”。

### 定义你的 work 做什么

在我们将多个任务连接在一起之前，让我们关注如何执行一项工作。我将会着重细说上传任务。首先，你需要创建自己的 [`Worker`](https://developer.android.com/reference/androidx/work/Worker) 实现类。我将会把我们的类命名为 `UploadWorker`，然后重写 [`doWork()`](https://developer.android.com/reference/androidx/work/Worker.html#doWork%28%29) 方法。

`Worker`s:

*   定义你的工作实际**做了**什么。
*   接受输入并产生输出。输入和输出都以键值对表示。
*   始终返回表示成功，失败或重试的值。

这是一个示例，展示了如何实现上传图像的 `Worker`：

```
class UploadWorker(appContext: Context, workerParams: WorkerParameters)
    : Worker(appContext, workerParams) {

    override fun doWork(): Result {
        try {
            // Get the input
            val imageUriInput = inputData.getString(Constants.KEY_IMAGE_URI)

            // Do the work
            val response = upload(imageUriInput)

            // Create the output of the work
            val imageResponse = response.body()
            val imgLink = imageResponse.data.link
            // workDataOf (part of KTX) converts a list of pairs to a [Data] object.
            val outputData = workDataOf(Constants.KEY_IMAGE_URI to imgLink)

            return Result.success(outputData)

        } catch (e: Exception) {
            return Result.failure()
        }
    }

    fun upload(imageUri: String): Response {
        TODO(“Webservice request code here”)
        // Webservice request code here; note this would need to be run
        // synchronously for reasons explained below.
    }

}
```

有两点需要注意：

*    输入和输出是作为 [`Data`](https://developer.android.com/reference/androidx/work/Data) 传递，它本质上是原始类型和数组的映射。`Data` 对象应该相当小 —— 实际上可以输入/输出的总大小有限制。这由 [`MAX_DATA_BYTES`](https://developer.android.com/reference/androidx/work/Data.html#MAX_DATA_BYTES) 设置。如果您需要将更多数据传入和传出 `Worker`，则应将数据放在其他地方，例如 [Room database](https://developer.android.com/training/data-storage/room/)。作为一个例子，我传入上面图像的 URI，而不是图像本身。
*   在代码中，我展示了两个返回示例：[`Result.success()`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result#success%28%29) 和 [`Result.failure()`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result#failure%28%29)。还有一个 [`Result.retry()`](https://developer.android.com/reference/androidx/work/ListenableWorker.Result#retry%28%29) 选项，它将在之后的时间再次重试你的工作。

###  定义您的 work 应该如何运行

一方面 `Worker` 定义工作的**作用**，另一方面 [`WorkRequest`](https://developer.android.com/reference/androidx/work/WorkRequest) 定义**应该如何以及何时运行工作**。

以下是为 `UploadWorker` 创建 [`OneTimeWorkRequest`](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest) 的示例。也可以有重复性的 [`PeriodicWorkRequest`](https://developer.android.com/reference/androidx/work/PeriodicWorkRequest)：

```
// workDataOf (part of KTX) converts a list of pairs to a [Data] object.
val imageData = workDataOf(Constants.KEY_IMAGE_URI to imageUriString)

val uploadWorkRequest = OneTimeWorkRequestBuilder<UploadWorker>()
        .setInputData(imageData)
        .build()
```

此 `WorkRequest` 将输入 `imageData: Data` 对象，并尽快运行。

假设 `UploadWork` 并不总是应该立即运行 —— 它应该只在设备有网络连接时运行。你可以通过添加 [`Constraints`](https://developer.android.com/reference/androidx/work/Constraints.Builder) 对象来完成此操作。你可以创建这样的约束：

```
val constraints = Constraints.Builder()
        .setRequiredNetworkType(NetworkType.CONNECTED)
        .build()
```

以下是其他受支持约束的示例：

```
val constraints = Constraints.Builder()
        .setRequiresBatteryNotLow(true)
        .setRequiredNetworkType(NetworkType.CONNECTED)
        .setRequiresCharging(true)
        .setRequiresStorageNotLow(true)
        .setRequiresDeviceIdle(true)
        .build()
```

最后，还记得 `Result.retry()` 吗？我之前说过，如果 `Worker` 返回 `Result.retry()`，WorkManager 将重新计划工作。你可以在创建新的 `WorkRequest` 时自定义退避条件。这允许你定义何时应重试运行。

[退避条件](https://developer.android.com/reference/kotlin/androidx/work/WorkRequest.Builder#setbackoffcriteria)由两个属性定义：

*   [**BackoffPolicy**](https://developer.android.com/reference/androidx/work/BackoffPolicy)，默认为指数性的，但是可以设置为线性。
*   **持续时间**，默认为 30 秒。

用于对上传工作进行排队的组合代码如下，包括约束，输入和自定义退避策略：

```
// Create the Constraints
val constraints = Constraints.Builder()
        .setRequiredNetworkType(NetworkType.CONNECTED)
        .build()

// Define the input
val imageData = workDataOf(Constants.KEY_IMAGE_URI to imageUriString)

// Bring it all together by creating the WorkRequest; this also sets the back off criteria
val uploadWorkRequest = OneTimeWorkRequestBuilder<UploadWorker>()
        .setInputData(imageData)
        .setConstraints(constraints)        
        .setBackoffCriteria(
                BackoffPolicy.LINEAR, 
                OneTimeWorkRequest.MIN_BACKOFF_MILLIS, 
                TimeUnit.MILLISECONDS)
        .build()
```

### 运行 work

 这些都很好，但你还没有**真正调度**好你的工作去运行。以下是告诉 WorkManager 调度工作所需的一行代码：

```
WorkManager.getInstance().enqueue(uploadWorkRequest)
```

你首先需要获取 [`WorkManager`](https://developer.android.com/reference/androidx/work/WorkManager) 的实例，这是一个负责执行你的工作的单例。调用 [`enqueue`](https://developer.android.com/reference/androidx/work/WorkManager#enqueue%28androidx.work.WorkRequest%29) 来启动 `WorkManager` 跟踪和调度工作的整个过程。

### 在幕后 —— 工作是怎么运行的

那么，`WorkManager` 能为您做些什么呢？默认情况下，`WorkManager` 会：

*   **脱离主线程**运行你的工作（假设你正在继承 `Worker` 类，如上面的 `UploadWorker` 所示）。
*   **保障** 你的工作将会运行（即使你重启设备或应用程序退出，它也不会忘记运行你的工作）。
*   根据**用户 API 级别的最佳实践**运行（如[上一篇文章](https://medium.com/androiddevelopers/introducing-workmanager-2083bcfc4712)所述）。

让我们探讨一下 WorkManager 如何确保你的工作脱离主线程运行并保证执行。在幕后，WorkManager 包括以下部分：

*   内部 TaskExecutor：一个单线程 [`Executor`](https://developer.android.com/reference/java/util/concurrent/Executor)，处理所有排队工作的请求。如果您不熟悉 `Executors`，可以在[这里](https://developer.android.com/reference/java/util/concurrent/Executor)阅读更多相关信息。
*   **WorkManager 数据库**：一个本地数据库，可跟踪所有工作的所有信息和状态。这包括工作的当前状态，工作的输入和输出以及对工作的任何约束限制。此数据库使 WorkManager 能够保证你的工作能够完成 —— 如果你的用户的设备重新启动并且工作中断，则可以从数据库中提取工作的所有详细信息，并在设备再次启动时重新启动工作。
*   **WorkerFactory**：一个默认工厂，用于创建 `Worker` 的实例。我们将在以后的博文中介绍为什么以及如何配置它。
*   **Default Executor**：一个默认的执行程序，运行你的工作，除非你另行指定。这确保在默认情况下，你的工作是同步运行的，并且在主线程之外运行。

* 这些部分可以被重写以具有不同的行为。

![](https://cdn-images-1.medium.com/max/800/1*1Wbw_Hi1u5SJ1QtJYemV4g.png)

来自：[Working with WorkManager](https://youtu.be/83a4rYXsDs0) Android 开发者大会展示 2018

当你安排 `WorkRequest`：

1.  内部 TaskExecutor 立即将你的 `WorkRequest` 信息保存到 WorkManager 数据库。
2.  稍后，当满足 `WorkRequest` 的 `Constraints` 时（可以立即发生），Internal TaskExecutor 会告诉 `WorkerFactory` 创建一个 `Worker`。
3.  之后，默认的 `Executor` 调用你的 `Worker` 的 `doWork()` 方法**脱离主线程**。

通过这种方式，默认情况下，你的工作都可以保证执行脱离主线程运行。

现在，如果你想使用除默认 `Executor` 之外的一些其他机制来运行你的工作，也是可以的！对协程（`CoroutineWorker`）和 RxJava（[`RxWorker`](https://developer.android.com/reference/androidx/work/RxWorker)）的开箱即用支持作为工作的手段。

或者，你可以使用 [`ListenableWorker`](https://developer.android.com/reference/androidx/work/ListenableWorker) 准确指定工作的执行方式。`Worker` 实际上是 `ListenableWorker` 的一个实现，它默认在默认的 `Executor` 上运行你的工作，因此是同步的。所以，如果你想要完全控制工作的线程策略或异步运行工作，你可以将 `ListenableWorker` 子类化（具体细节将在后面的文章中讨论）。

WorkManager 虽然将所有工作信息保存到数据库中有些麻烦，但它还是会做，这使得它成了非常适合需要保障执行的任务。这也是使得 WorkManager 轻松应对对于不需要保障且只需要在后台线程上执行的任务的的原因。例如，假设你已经下载了图像，并且希望根据该图像更改 UI 部分的颜色。这是应该脱离主线程运行的工作，但是，因为它与 UI 直接相关，所以如果关闭应用程序则不需要继续。所以在这样的情况下，不要使用 WorkManager —— 坚持使用像 [Kotlin 协程](https://codelabs.developers.google.com/codelabs/kotlin-coroutines/#0)那样轻量的东西或创建自己的 `Executor`。

### 使用链进行依赖性工作

我们的滤镜示例包含的不仅仅是一个任务 —— 我们想要给多个图像加滤镜，然后压缩并上传。如果要一个接一个地或并行地运行一系列 `WorkRequests`，则可以使用 [链](https://developer.android.com/topic/libraries/architecture/workmanager/advanced#chained)。示例图显示了一个链，其中有三个并行运行的滤镜任务，后面是压缩任务和上传任务，按顺序运行：

![](https://cdn-images-1.medium.com/max/800/0*4VeMy6t8hLS1OyrM)

使用 WorkManager 非常简单。假设你已经用适当的约束创建了所有 WorkRequests，代码如下所示：

```
WorkManager.getInstance()
    .beginWith(Arrays.asList(
                             filterImageOneWorkRequest, 
                             filterImageTwoWorkRequest, 
                             filterImageThreeWorkRequest))
    .then(compressWorkRequest)
    .then(uploadWorkRequest)
    .enqueue()
```

三个图片滤镜 `WorkRequests` 并行执行。一旦完成所有滤镜 WorkRequests （并且只有完成所有三个），就会发生 `compressWorkRequest`，然后是 `uploadWorkRequest`。

链的另一个优点是：一个 `WorkRequest` 的输出作为下一个 `WorkRequest` 的输入。因此，假设你正确设置了输入和输出数据，就像我上面的 `UploadWorker` 示例所做的那样，这些值将自动传递。

为了处理并行的三个滤镜工作请求的输出，可以使用 [`InputMerger`](https://developer.android.com/reference/androidx/work/InputMerger)，特别是 [`ArrayCreatingInputMerger`](https://developer.android.com/reference/androidx/work/ArrayCreatingInputMerger)。代码如下：

```
val compressWorkRequest = OneTimeWorkRequestBuilder<CompressWorker>()
        .setInputMerger(ArrayCreatingInputMerger::class.java)
        .setConstraints(constraints)
        .build()
```

请注意，`InputMerger` 是添加到 `compressWorkRequest` 中的，而不是并行的三个滤镜请求中的。

假设每个滤镜工作请求的输出是映射到图像 URI 的键 “KEY_IMAGE_URI”。添加 `ArrayCreatingInputMerger` 的作用是并行请求的输出，当这些输出具有匹配的**键**时，它会创建一个包含所有输出值的数组，映射到单个键。可视化图表如下：

![](https://cdn-images-1.medium.com/max/800/1*Ft-4gVTZVjVtz6xIaEtNOg.png)

`ArrayCreatingInputMerger` 功能可视化

因此，`compressWorkRequest` 的输入将最终成为映射到滤镜图像 URI 数组的 “KEY_IMAGE_URI” 对。

### 观察你的 WorkRequest 状态

监视工作的最简单方法是使用 [`LiveData`](https://developer.android.com/reference/android/arch/lifecycle/LiveData) 类。如果你不熟悉 LiveData，它是一个生命周期感知的可监视数据持有者 —— [这里](https://developer.android.com/topic/libraries/architecture/livedata) 对此有更详细的描述。

调用 [`getWorkInfoByIdLiveData`](https://developer.android.com/reference/androidx/work/WorkManager.html#getWorkInfoById%28java.util.UUID%29) 返回一个  [`WorkInfo`](https://developer.android.com/reference/androidx/work/WorkInfo) 的 `LiveData`。`WorkInfo` 包含输出的数据和表示工作状态的枚举。当工作顺利完成后，它的 [`State`](https://developer.android.com/reference/kotlin/androidx/work/State) 就会是 `SUCCEEDED`。因此，例如，你可以通过编写一些监视代码来实现当工作完成时自动显示该图像：

```
// In your UI (activity, fragment, etc)
WorkManager.getInstance().getWorkInfoByIdLiveData(uploadWorkRequest.id)
        .observe(lifecycleOwner, Observer { workInfo ->
            // Check if the current work's state is "successfully finished"
            if (workInfo != null && workInfo.state == WorkInfo.State.SUCCEEDED) {
                displayImage(workInfo.outputData.getString(KEY_IMAGE_URI))
            }
        })
```

有几点需要注意：

*   每个 `WorkRequest` 都有一个[唯一的 id](https://developer.android.com/reference/androidx/work/WorkRequest.html#getId%28%29)，该唯一 id 是查找关联 `WorkInfo` 的一种方法。
*   `WorkInfo` 更改时进行监视并被通知的能力是 `LiveData` 提供的功能。

工作有一个由不同 [`State`](https://developer.android.com/reference/kotlin/androidx/work/State) 代表的生命周期。监视 `LiveData<WorkInfo>` 时，你会看到这些状态；例如，你可能会看到：

![](https://cdn-images-1.medium.com/max/800/1*ygDDGGdiBm8_c2_u3rXWkQ.png)

“happy path” 或工作状态

工作状态经历的 “happy path” 如下：

1.  `BLOCKED`：只有当工作在链中并且不是链中的下一个工作时才会出现这种状态。
2.  `ENQUEUED`：只要工作是工作链中的下一个并且有资格运行，工作就会进入这个状态。这项工作可能仍在等待 `Constraint` 被满足。
3.  `RUNNING`：在这种状态时，工作正在运行。对于 `Worker`，这意味着 `doWork()` 方法已经被调用。
4.  `SUCCEEDED`：当 `doWork()` 返回 `Result.success()` 时，工作进入这种最终状态。

现在，当工作处于 `RUNNING` 状态，你可以调用 `Result.retry()`。这将会导致工作退回 `ENQUEUED` 状态。工作也可能随时被 `CANCELLED`。

如果工作运行的结果是 `Result.failure()` 而不是成功。它的状态将会以 `FAILED` 结束，因此，状态的完整流程图如下所示：

![](https://cdn-images-1.medium.com/max/800/1*nliDtycHUhVVlKlWO-oQ2Q.png)

（来自：[Working with WorkManager](https://youtu.be/83a4rYXsDs0) Android 开发者峰会 2018）

想看精彩的视频讲解，请查看 [WorkManager Android 开发者峰会演讲](https://youtu.be/83a4rYXsDs0?t=1144)。

### 总结

这就是 WorkManager API 的基础知识。使用我们刚刚介绍的代码片段，你现在就可以：

*   创建包含输入/输出的 `Worker`。
*   使用 `WorkRequest`、`Constraint`、启动输入和退出策略配置 `Worker` 的运行方式。
*   调度 `WorkRequest`。
*   了解默认情况下 `WorkManager` 在线程和保障运行方面的幕后工作。
*   创建复杂链式相互依赖的工作，可以顺序运行和并行运行。
*   使用 `WorkInfo` 监视你的 `WorkRequest` 的状态。

想亲自试试 WorkManager 吗？查看 codelab，包含 [Kotlin](https://codelabs.developers.google.com/codelabs/android-workmanager-kt/index.html?index=..%2F..index#0) 和 [Java](https://codelabs.developers.google.com/codelabs/android-workmanager/index.html?index=..%2F..index#0) 代码。

随着我们继续更新本系列，请继续关注有关 WorkManager 主题的更多博客文章。 有什么问题或者你希望我们写到的东西吗？请在评论区告诉我们！

**感谢 [Pietro Maggi](https://medium.com/@pmaggi)**

### WorkManager 相关资源

*   [官方文档](https://developer.android.com/topic/libraries/architecture/workmanager/)
*   [参考指南](https://developer.android.com/reference/androidx/work/package-summary)
*   [WorkManager 1.0.0-beta02 Release notes](https://developer.android.com/jetpack/docs/release-notes#january_15_2019)
*   Codelab：[Kotlin](https://codelabs.developers.google.com/codelabs/android-workmanager-kt/index.html?index=..%2F..index#0) 和 [Java](https://codelabs.developers.google.com/codelabs/android-workmanager/index.html?index=..%2F..index#0).
*   [源码（AOSP 的一部分）](https://android.googlesource.com/platform/frameworks/support/+/master/work)
*   [Working with WorkManager (Android 开发者峰会 2018) presentation](https://www.youtube.com/watch?v=83a4rYXsDs0)
*   [Issue Tracker](https://issuetracker.google.com/issues?q=componentid:409906)
*   [StackOverflow 上面的 WorkManager 相关问题](https://stackoverflow.com/questions/tagged/android-workmanager)
*   [Google’s Power blog post series](https://android-developers.googleblog.com/search/label/Power%20series)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
