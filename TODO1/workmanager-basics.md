> * 原文地址：[WorkManager Basics](https://medium.com/androiddevelopers/workmanager-basics-beba51e94048)
> * 原文作者：[Lyla Fujiwara](https://medium.com/@lylalyla)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/workmanager-basics.md](https://github.com/xitu/gold-miner/blob/master/TODO1/workmanager-basics.md)
> * 译者：
> * 校对者：

# WorkManager Basics

![Illustration by [Virginia Poltrack](https://twitter.com/VPoltrack)](https://cdn-images-1.medium.com/max/3200/0*_fXBLlwf_uEp7nDj)

Welcome to the second post of our WorkManager series. [WorkManager](https://developer.android.com/topic/libraries/architecture/workmanager/) is an [Android Jetpack ](https://developer.android.com/jetpack/)library that runs deferrable, guaranteed background work when the work’s constraints are satisfied. WorkManager is the current best practice for many types of background work. [In the first blog post](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-workmanager.md), we talked about what WorkManager is and when to use WorkManager.

In this blog post, I’ll cover:

* Defining your background task as work

* Defining how specific work should run

* Running your work

* Using Chains for dependent work

* Observing your work’s status

I’ll also explain what’s going on **behind the scenes** with WorkManager, so that you can make informed decisions about how to use it.

## Starting with an example

Let’s say you have an image editing app that lets you put filters on images and upload them to the web for the world to see. You want to create a series of background tasks that applies the filters, compresses the images, and then uploads them. In each phase, there is a constraint that needs to be checked — that there is sufficient battery when you are filtering the images, that you have enough storage space when compressing the images, and that you have a network connection when uploading the images.

![The example, visualized](https://cdn-images-1.medium.com/max/2394/0*GuigyLoSuBZ86hH1)

This is an example of a task that is:

* **Deferrable**, because you don’t need it to happen immediately, and in fact might want to wait for some constraints to be met (such as waiting for a network connection).

* Needs to be **guaranteed** to run, regardless of if the app exits, because your users would be pretty unhappy if their filtered images are never shared with the world!

These characteristics make our image filter and uploading tasks a perfect use case for WorkManager.

## Adding the WorkManager dependency

The code snippets in this blog post are in Kotlin, using the KTX library (KoTlin eXtensions). The KTX version of the library provides [extension functions](https://developer.android.com/reference/kotlin/androidx/work/package-summary#extension-functions-summary) for more concise and idiomatic Kotlin. You can use the KTX version of WorkManager using this dependency:

```
dependencies {
 def work_version = "1.0.0-beta02"
 implementation "android.arch.work:work-runtime-ktx:$work_version"
}
```

You can find the latest version of the library [here](https://developer.android.com/topic/libraries/architecture/adding-components#workmanager). If you want to use the Java dependency, just remove the “-ktx”.

## Define what your work does

Let’s focus on how you execute one piece of work, before we get to chaining multiple tasks together. I’ll zoom in on the upload task. First, you’ll need to create your own implementation of the `[Worker](https://developer.android.com/reference/androidx/work/Worker)` class. I’ll call our class `UploadWorker`, and override the `[doWork(](https://developer.android.com/reference/androidx/work/Worker.html#doWork()))` method.

`Worker`s:

* Define what your work actually **does**.

* Accept inputs and produce outputs. Both inputs and outputs are represented as key, value pairs.

* Always return a value representing success, failure, or retry.

Here’s an example showing how to implement a `Worker` that uploads an image:

Two things to note:

* The input and output are passed as `[Data](https://developer.android.com/reference/androidx/work/Data)`, which is essentially a map of primitive types and arrays. `Data` objects are intended to be fairly small — there’s actually a limit on the total size that can be input/output. This is set by the `[MAX_DATA_BYTES](https://developer.android.com/reference/androidx/work/Data.html#MAX_DATA_BYTES)`. If you need to pass more data in and out of your `Worker`, you should put your data elsewhere, such as a [Room database](https://developer.android.com/training/data-storage/room/). As an example, I’m passing in the URI of the image above, and not the image itself.

* In the code I show two return examples, `[Result.success()](https://developer.android.com/reference/androidx/work/ListenableWorker.Result#success())` and `[Result.failure()](https://developer.android.com/reference/androidx/work/ListenableWorker.Result#failure())`. There’s also a `[Result.retry()](https://developer.android.com/reference/androidx/work/ListenableWorker.Result#retry())` option which will retry your work again at a later time.

## Define how your work should run

While a `Worker` defines what the work **does**, a `[WorkRequest](https://developer.android.com/reference/androidx/work/WorkRequest)` defines **how and when work should be run**.

Here’s an example of creating a `[OneTimeWorkRequest](https://developer.android.com/reference/androidx/work/OneTimeWorkRequest)` for your `UploadWorker`. It is also possible to have a repeating `[PeriodicWorkRequest](https://developer.android.com/reference/androidx/work/PeriodicWorkRequest)`:


This `WorkRequest` takes in the `imageData: Data` object as input and runs as soon as possible.

Let’s say the `UploadWork` shouldn’t always just run immediately — it should only run if the device has a network connection. You can do this by adding a `[Constraints](https://developer.android.com/reference/androidx/work/Constraints.Builder)` object. You can create a constraint like this:


Here’s an example of other supported constraints:


Finally, remember `Result.retry()`? I said earlier that if a `Worker` returns `Result.retry()`, WorkManager will reschedule the work. You can customize the backoff criteria when you make a new `WorkRequest`. This allows you to define when the work should be retried.

The [backoff criteria](https://developer.android.com/reference/kotlin/androidx/work/WorkRequest.Builder#setbackoffcriteria) is defined by two properties:

* [**BackoffPolicy**](https://developer.android.com/reference/androidx/work/BackoffPolicy), which by default is exponential, but can be set to linear.

* **Duration**, which defaults to 30 seconds.

The combined code for enqueuing your upload work, with constraints, input and a custom back-off policy, is:


## Running work

This is all well and good, but you haven’t **actually** **scheduled** your work to run yet. Here’s the one line of code you need to tell WorkManager to schedule your work:


You first need to get the instance of `[WorkManager](https://developer.android.com/reference/androidx/work/WorkManager)`, which is a singleton responsible for executing your work. Calling `[enqueue](https://developer.android.com/reference/androidx/work/WorkManager#enqueue(androidx.work.WorkRequest))` is what starts the whole process of `WorkManager` tracking and scheduling work.

## Behind the Scenes — How work runs

So what can you expect `WorkManager` to do for you? By default, `WorkManager` will:

* Run your work **off of the main thread** (this assumes you are extending the `Worker` class, as shown above in `UploadWorker`).

* **Guarantee** your work will execute (it won’t forget to run your work, even if you restart the device or the app exits).

* Run according to **best practices for the user’s API level** (as described in the [previous article](https://medium.com/androiddevelopers/introducing-workmanager-2083bcfc4712)).

Let’s explore how WorkManager ensures your work is run off of the main thread and is guaranteed to execute. Behind the scenes, WorkManager includes the following parts:

* **Internal TaskExecutor**: ****A single threaded `[Executor](https://developer.android.com/reference/java/util/concurrent/Executor)` that handles all the requests to enqueue work. If you’re not familiar with `Executors` you can read more about them [here](https://developer.android.com/reference/java/util/concurrent/Executor).

* **WorkManager database**: A local database that tracks all of the information and statuses of all of your work. This includes things like the current state of the work, the inputs and outputs to and from the work and any constraints on the work. This database is what enables WorkManager to guarantee your work will finish — if your user’s device restarts and work gets interrupted, all of the details of the work can be pulled from the database and the work can be restarted when the device boots up again.

* **WorkerFactory****:** **A default factory that creates instances of your `Worker`s. We’ll cover why and how to configure this in a future blog post.

* **Default Executor****:** **A default executor that runs your work unless you specify otherwise. This ensures that by default, your work runs synchronously and off of the main thread.

** These are parts that can be overridden to have different behaviors.

![Credit: [Working with WorkManager](https://youtu.be/83a4rYXsDs0) Presentation Android Developer Summit 2018](https://cdn-images-1.medium.com/max/3972/1*1Wbw_Hi1u5SJ1QtJYemV4g.png)

When you enqueue your `WorkRequest`:

 1. The Internal TaskExecutor immediately saves your `WorkRequest` info to the WorkManager database.

 2. Later, when the `Constraints` for the `WorkRequest` are met (which could be immediately), the Internal TaskExecutor tells the `WorkerFactory` to create a `Worker`.

 3. Then the default `Executor` calls your `Worker`’s `doWork()` method **off of the main thread.**

In this way, your work, by default, is both guaranteed to execute and to run off of the main thread.

Now if you want to use some other mechanism besides the default `Executor` to run your work, you can do so! There’s out of the box support for coroutines (`CoroutineWorker`) and RxJava (`[RxWorker](https://developer.android.com/reference/androidx/work/RxWorker)`) as means of doing work.

Or you can specify exactly how work is executed by using `[ListenableWorker](https://developer.android.com/reference/androidx/work/ListenableWorker)`. `Worker` is actually an implementation of `ListenableWorker` that defaults to running your work on the default `Executor` and thus synchronously. So if you want full control over your work’s threading strategy or to run work asynchronously, you can subclass `ListenableWorker` (the details of this will be discussed in a later post).

The fact that WorkManager goes to the trouble of saving all of your work’s information into a database is what makes it perfect for tasks that need to be guaranteed to execute. This is also what makes WorkManager overkill for tasks that don’t need that guarantee and just need to be executed on a background thread. For example, let’s say you’ve downloaded an image and you want to change the color of parts of your UI based off of that image. This is work that should be run off of the main thread, but, because it’s directly related to the UI, does not need to continue if you close the app. So in a case like this, don’t use WorkManager — stick with something lighter weight like [Kotlin coroutines](https://codelabs.developers.google.com/codelabs/kotlin-coroutines/#0) or creating your own `Executor`.

## Using Chains for dependent work

Our filter example included more than just one task — we wanted to filter multiple images, then compress, then upload. If you want to run a series of `WorkRequest`s, one after the other or in parallel, you can use a [chain](https://developer.android.com/topic/libraries/architecture/workmanager/advanced#chained). The example diagram shows a chain where you have three filter tasks run in parallel, followed by a compress task and an upload task, run in sequence:

![](https://cdn-images-1.medium.com/max/2394/0*4VeMy6t8hLS1OyrM)

This is super easy with WorkManager. Assuming you have created all your WorkRequests with the appropriate constraints, the code looks like:


The three filter-image `WorkRequest`s execute in parallel. Once all three filter `WorkRequests` are finished (and only if all three finish), the `compressWorkRequest` happens, followed by the `uploadWorkRequest`.

Another neat feature of chains is that the output of one `WorkRequest` is given as input to the next `WorkRequest`. So assuming you set your input and output data correctly, like I did above with my `UploadWorker` example, these values will get passed along automatically.

For handling output from the three filter work requests run parallel, you can use an `[InputMerger](https://developer.android.com/reference/androidx/work/InputMerger)`, specifically the `[ArrayCreatingInputMerger](https://developer.android.com/reference/androidx/work/ArrayCreatingInputMerger)`. This looks like:


Notice that the `InputMerger` is added to the `compressWorkRequest`, not the three filter requests that are run in parallel.

Let’s assume that the output of each of the filter work requests is the key “KEY_IMAGE_URI” mapped to an image URI. What adding the `ArrayCreatingInputMerger` does is it takes the outputs from requests run in parallel and when those outputs have matching **keys**, it creates an array with all of the output values, mapped to the single key. Visualized this looks like:

![A visual of what an `ArrayCreatingInputMerger` does](https://cdn-images-1.medium.com/max/2636/1*Ft-4gVTZVjVtz6xIaEtNOg.png)

So the input to `compressWorkRequest` will end up being the pair of “KEY_IMAGE_URI” mapped to an array of filtered image URIs.

## Observing your WorkRequest status

The easiest way to observe work is by using the `[LiveData](https://developer.android.com/reference/android/arch/lifecycle/LiveData)` class. If you’re not familiar with `LiveData`, it’s a lifecycle-aware observable data holder — and it’s described in more detail [here](https://developer.android.com/topic/libraries/architecture/livedata).

Calling `[getWorkInfoByIdLiveData](https://developer.android.com/reference/androidx/work/WorkManager.html#getWorkInfoById(java.util.UUID))` returns a `LiveData` of `[WorkInfo](https://developer.android.com/reference/androidx/work/WorkInfo)`. `WorkInfo` includes the output data and an enum representing the state of the work. When the work finishes successfully, its’ `[State](https://developer.android.com/reference/kotlin/androidx/work/State)` is `SUCCEEDED`. So, for example, you could automatically display that image when the work is done by writing some observation code like:


A few things to note:

* Each `WorkRequest` has a [unique id](https://developer.android.com/reference/androidx/work/WorkRequest.html#getId()) and that unique id is one way to look up the associated `WorkInfo`.

* The ability to observe and be notified when the `WorkInfo` changes is a feature provided by `LiveData`.

Work has a lifecycle, represented by different `[State](https://developer.android.com/reference/kotlin/androidx/work/State)`s. When observing the `LiveData\<WorkInfo>` you’ll see those states; for example you might see:

![The “happy path” or work States](https://cdn-images-1.medium.com/max/2668/1*ygDDGGdiBm8_c2_u3rXWkQ.png)

The “happy path” of states that work goes through are:

 1. `BLOCKED` : This state occurs only if the work is in a chain and is not the next work in the chain.

 2. `ENQUEUED` : Work enters this state as soon as the work is next in the chain of work and eligible to run. This work may still be waiting on `Constraint`s to be met.

 3. `RUNNING` : In this state, the work is actively executing. For `Worker`s, this means the `doWork()` method has been called.

 4. `SUCCEEDED` : Work enters this terminal state when `doWork()` returns `Result.success()`.

Now when the work is `RUNNING`, you might call `Result.retry()`. This will cause the work to go back to `ENQUEUED`. The work can also be `CANCELLED` at any point.

If the work result is a `Result.failure()` instead of a success, its state will end in `FAILED`. The full flowchart of states therefore looks like this:

![(Credit: [Working with WorkManager](https://youtu.be/83a4rYXsDs0) Presentation Android Developer Summit 2018)](https://cdn-images-1.medium.com/max/2564/1*nliDtycHUhVVlKlWO-oQ2Q.png)

For an excellent video explanation, check out the [WorkManager Android Developer Summit talk](https://youtu.be/83a4rYXsDs0?t=1144).

## Conclusion

That’s the basics of the WorkManager API. Using the snippets we just covered you can now:

* Create `Worker`s with input and output.

* Configure how your `Worker`s will run, using `WorkRequest`s, `Constraint`s, starting input and back off policies.

* Enqueue `WorkRequest`s.

* Understand what `WorkManager` does under the hood, by default, in respect to threading and guaranteed execution.

* Create complex chains of interdependent work, running both sequentially and in parallel.

* Observe your `WorkRequest`s status using `WorkInfo`.

Want to try WorkManager yourself? Check out the codelab, which is in both [Kotlin](https://codelabs.developers.google.com/codelabs/android-workmanager-kt/index.html?index=..%2F..index#0) and [Java](https://codelabs.developers.google.com/codelabs/android-workmanager/index.html?index=..%2F..index#0).

Stay tuned for more blog posts about WorkManager topics as we continue this series. Have a question or something you’d like us to cover? Let us know in the comment section!

**Thanks to [Pietro Maggi.](https://medium.com/@pmaggi)**

## WorkManager’s Resources

* [Documentation](https://developer.android.com/topic/libraries/architecture/workmanager/)

* [Reference Guide](https://developer.android.com/reference/androidx/work/package-summary)

* [WorkManager 1.0.0-beta02 Release notes](https://developer.android.com/jetpack/docs/release-notes#january_15_2019)

* Codelab: [Kotlin](https://codelabs.developers.google.com/codelabs/android-workmanager-kt/index.html?index=..%2F..index#0) and [Java](https://codelabs.developers.google.com/codelabs/android-workmanager/index.html?index=..%2F..index#0).

* [Source code (part of AOSP)](https://android.googlesource.com/platform/frameworks/support/+/master/work)

* [Working with WorkManager (Android Dev Summit ’18) presentation](https://www.youtube.com/watch?v=83a4rYXsDs0)

* [Issue Tracker](https://issuetracker.google.com/issues?q=componentid:409906)

* [WorkManager questions on StackOverflow](https://stackoverflow.com/questions/tagged/android-workmanager)

* [Google’s Power blog post series](https://android-developers.googleblog.com/search/label/Power%20series)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
