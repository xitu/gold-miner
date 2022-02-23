> * 原文地址：[The Complete Guide to Concurrency and Multithreading in iOS](https://betterprogramming.pub/the-complete-guide-to-concurrency-and-multithreading-in-ios-59c5606795ca)
> * 原文作者：[Varga Zolt](https://medium.com/@varga-zolt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/the-complete-guide-to-concurrency-and-multithreading-in-ios.md](https://github.com/xitu/gold-miner/blob/master/article/2022/the-complete-guide-to-concurrency-and-multithreading-in-ios.md)
> * 译者：
> * 校对者：

# The Complete Guide to Concurrency and Multithreading in iOS

![Photo by [John Anvik](https://unsplash.com/@redviking509?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8634/0*OUahLXqbffAW6U5y)

> Main thread vs. background thread. Async/await and Actor. GCD vs. OperationQueue. Group dispatch, how to empower background thread, and more

## Introduction

In this article, we will learn the following:

```
TABLE OF CONTENTS

What Is Multithreading
  Serial Queue vs. Concurrent Queue
  Parallelism
  Concurrency
Basics of Multithreading
  Main Thread (UI Thread) vs. Background Thread (Global Thread)
GCD (Grand Central Dispatch)
DispatchGroup
DispatchSemaphore
DispatchWorkItem
Dispatch Barrier
AsyncAfter
(NS)Operation and (NS)OperationQueue
DispatchSource (How To Handle Files and Folders)
Deadlock (Issue What To Avoid)
Main Thread Checker (How To Detect Thread Issues)
Threads in Xcode (How To Debug Threads)
Async / Await / Actor Is iOS13+
```

I know there are lots of topics. If something is already familiar to you, skip it and read the unknown parts. There are tricks and tips.

## Multithreading in Real-World Examples

Imagine you have a restaurant. The waiter is gathering the orders. The kitchen is preparing the food, the bartender is making the coffee and the cocktails.

At some point, lots of people will order coffee and food. That needs more time to get prepared. Suddenly the bell rings that 5x food is ready and 4x coffees. The waiter will need to serve the tables one by one even if all the products are prepared. This is the **Serial Queue**. With a serial queue, you are limited to only one waiter.

Now imagine there are two or three waiters. They can serve the tables much faster at the same time. This is **Parallelism**. Using multiple CPUs for operating multiple processes.

Now imagine one waiter will not serve one table at once, but will first serve all the coffees to all tables. Then, they will ask for the orders for some of the new tables, then serve all the food. This concept is called **Concurrency.** It is context switching, managing, and running many computations at the same time. It doesn’t necessarily mean they’ll ever both be running at the same instant. For example, multitasking on a single-core machine.

Today’s devices all have multiple CPUs ([Central Processing Unit](https://en.wikipedia.org/wiki/Central_processing_unit)). To be able to create apps with seamless flows, we need to understand the concept of **Multithreading**. It is a way how we will treat some tasks in the application. It is important to understand that if something “works,” maybe it is not the best, desired way. Lots of times I see a long-running task that is happening on the UI thread and blocking the execution of the application for a couple of seconds. Nowadays it could be the no-go moment. Users could delete your application as they feel that other apps start up faster, make faster fetch of the books, music. Competition is big, and high standards are expected.

![Thread execution types](https://cdn-images-1.medium.com/max/2000/1*VAGYSwgHGTHvAPhP1m204Q.png)

You can see the “Serial 6" task if it is scheduled at the current time. It will be added to the list in the **FIFO** manner and waiting to be executed in the future.

## Basics of Multithreading

One thing I have struggled with is that there is no standard terminology. To help with that for these subjects I will first write down the synonyms, examples. If you come from some other technology than iOS, you could still understand the concept and transfer it as the basics are the same. I had luck that early in my career I was working with C, C++, C#, node.js, Java(Android), etc. so I got used to this context switching.

* **Main thread / UI Thread:** This is the thread that is started with the application, pre-defined serial thread. It listens for user interaction and UI changes. All the changes immediately need a response. Need to care not to add a huge job to this thread as the app can freeze.

![Long-running task on UI Thread (wrong and should not do this)](https://cdn-images-1.medium.com/max/2000/1*xz9E1Nuw29R-rcINHsnUlA.png)

```
DispatchQueue.main.async {
    // Run async code on the Main/UI Thread. E.g.: Refresh TableView
}
```

* **Background Thread (global):** Predefined. Mostly we create tasks on new threads based on our needs. For example, if we need to download some image that is big. This is done on the background thread. Or any API call. We don’t want to block users from waiting for this task to be finished. We will call an API call to fetch a list of movies data on the background thread. When it arrives and parsing is done then we switch and update the UI on the main thread.

![Long-running task (done the right way on Background Thread)](https://cdn-images-1.medium.com/max/2000/1*WqeTWiks2f1AXxy2uAdWUQ.png)

```
DispatchQueue.global(qos: .background).async {
     // Run async on the Background Thread. E.g.: Some API calls.
}
```

![Example of SerialQueue](https://cdn-images-1.medium.com/max/2216/1*VnKZUZS-ZeYlZ9CHgsxCgw.png)

In the picture above, we added a breakpoint to line 56. When it is hit and the application stops, we can see this on the panel on the left side of the threads.

1. You can see the name of the DispatchQueue(label: “com.kraken.serial”). The label is the identifier.
2. These buttons can be useful to turn off / filter out the system method calls to see just user-initiated ones.
3. You can see that we have added `sleep(1)`. This stops the execution of the code for 1 second.
4. And if you watch the order it is still triggered in a serial manner.

Based on the previous iOS, one of the two most used terms are the Serial Queue and Concurrent Queue.

![Example of ConcurrentQueue](https://cdn-images-1.medium.com/max/2488/1*bnTmlYColH5efxcnLtJBzQ.png)

1. This is result one of Concurrent Queue. You can see above the Serial / Main Thread also (**com.apple.main-thread**).
2. The `sleep(2)` is added to this point.
3. You see there is no order. It was finished async on the background thread.

```
let mainQueue = DispatchQueue.main
let globalQueue = DispatchQueue.global()
let serialQueue = DispatchQueue(label: “com.kraken.serial”)
let concurQueue = DispatchQueue(label: “com.kraken.concurrent”, attributes: .concurrent)
```

We can also create a private queue that could be serial and concurrent also.

## GCD (Grand Central Dispatch)

GCD is Apple’s low-level threading interface for supporting concurrent code execution on multicore hardware. In a simple manner, GCD enables your phone to download a video in the background while keeping the user interface responsive.

> “DispatchQueue is an object that manages the execution of tasks serially or concurrently on your app’s main thread or on a background thread.” — Apple Developer

If you noticed in the code example above, you can see “qos.” This means Quality of Service. With this parameter, we can define the priority as follows:

* **background** — we can use this when a task is not time-sensitive or when the user can do some other interaction while this is happening. Like pre-fetching some images, loading, or processing some data in this background. This work takes significant time, seconds, minutes, and hours.
* **utility** — long-running task. Some process what the user can see. For example, downloading some maps with indicators. When a task takes a couple of seconds and eventually a couple of minutes.
* **userInitiated** — when the user starts some task from UI and waits for the result to continue interacting with the app. This task takes a couple of seconds or an instant.
* **userInteractive** — when a user needs some task to be finished immediately to be able to proceed to the next interaction with the app. Instant task.

It’s useful is also to label the `DispatchQueue`. This could help us to identify the thread when we need it.

## DispatchGroup

Often we need to start multiple async processes, but we need just one event when all are finished. This can be achieved by DispatchGroup.

> “A group of tasks that you monitor as a single unit.”— Apple Docs

For example, sometimes you need to make multiple API calls on the background thread. Before the app is ready for user interaction or to update the UI on the main thread. Here’s some code:

```Swift
// 1. Create Dispatch Group
let group = DispatchGroup()

// 2.a. Long running Task 1
group.enter()
runLongRunningTask1(completion: {
    print("DispatchGroup: Long running Task 1 finished")
    group.leave()
})

// 2.b. Long running Task 2
group.enter()
runLongRunningTask2(completion: {
    print("DispatchGroup: Long running Task 2 finished")
    group.leave()
})

// 2.b. Long running Task 3
group.enter()
runLongRunningTask3(completion: {
    print("DispatchGroup: Long running Task 3 finished")
    group.leave()
})

// 3. When all are finished Notify
let queueType = DispatchQueue.global(qos: .userInitiated)
group.notify(queue: queueType) {
    print("DispatchGroup - notify: All task Finished.")
}
```

* **Step 1.** Create `DispatchGroup`
* **Step 2.** Then for that group need to call `group.enter()` event for every task started
* **Step 3.** For every `group.enter()` needs to be called also the `group.leave()` when the task is finished.
* **Step 4.** When all the enter-leave pairs are finished then `group.notify` is called. If you notice it is done on the background thread. You can configure per your need.

![Dispatch Group. Task one by one and all by notify.](https://cdn-images-1.medium.com/max/3028/1*5abBihhgOraZToTOi4lwVA.gif)

It’s worth mentioning the `wait(timeout:)` option. It will wait some time for the task to finish but after timeout, it will continue.

## DispatchSemaphore

> “An object that controls access to a resource across multiple execution contexts through use of a traditional counting semaphore.” — Apple Docs

```Swift
let semaphore = DispatchSemaphore(value: 1)
semaphore.wait()
task { (result) in
    semaphore.signal()
}
```

Call `wait()` every time accessing some shared resource.

Call `signal()` when we are ready to release the shared resource.

The `value` in `DispatchSemaphore` indicates the number of concurrent tasks.

## DispatchWorkItem

A common belief is that when a GCD task is scheduled it can’t be cancelled. But this is not true. It was true before iOS8.

> “The work you want to perform, encapsulated in a way that lets you attach a completion handle or execution dependencies.” — Apple Docs

For example, if you are using a search bar. Every letter typing calls an API call to ask from the server-side for a list of movies. So, imagine if you are typing “Batman.” “B,” “Ba,” “Bat”… every letter will trigger a network call. We don’t want this. We can simply cancel the previous call if, for example, another letter is typed within that one-second range. If time passes the one second and the user does not type a new letter, then we consider that API call needs to be executed.

![SearchBar. Simulation “Debounce” with DispatchWorkItem](https://cdn-images-1.medium.com/max/2480/1*kurFvLtoj7jovJcKT1P4tg.gif)

Of course, using Functional Programming like RxSwift / Combine we have better options like debounce(for:scheduler:options:).

## Dispatch Barrier

Dispatch Barriers is resolving the problem with a read/write lock. This makes sure that only this DispatchWorkItem will be executed.

> “This makes thread-unsafe objects thread-safe.” — Apple Docs

![Dispatch Barrier](https://cdn-images-1.medium.com/max/2000/1*WlHRf0N33mKFj_GHm91Wyg.png)

![Barrier Timeline](https://cdn-images-1.medium.com/max/4268/1*GiFY0BTDW2guffVbajIPJw.png)

For example, if we want to save the game, we want to write to some opened shared file, resource.

## AsyncAfter

We can use this code to delay some task execution:

```Swift
// 1. Time
let delay = 2.0

// 2. Schedule 
DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
    // Execute some task with delay
}
```

From my perspective, this is the source of all evil, with respect for exceptions. For every async task that needs a delay, I would suggest thinking through this, and if it is possible use some state management system. Don’t pick this option as the first choice. Usually, there is another way.

## (NS)Operation and (NS)OperationQueue

If you are using NSOperation that means you are using GCD below the surface, as NSOperation is built on top of GCD. Some NSOperation benefits are that it has a more user-friendly interface for Dependencies(executes a task in a specific order), it is Observable (KVO to observe properties), has Pause, Cancel, Resume, and Control (you can specify the number of tasks in a queue).

```Swift
var queue = OperationQueue()
queue.addOperationWithBlock { () -> Void in  
    // Background URL 1 
    OperationQueue.mainQueue().addOperationWithBlock({
        // Update UI with URL 1 response
    })
}
queue.addOperationWithBlock { () -> Void in
    // Background URL 2
    OperationQueue.mainQueue().addOperationWithBlock({
        // Update UI with URL 2 response
    })
 }
```

You can set the concurrent operation count to 1 so it will work as a serial queue.

```
queue.maxConcurrentOperationCount = 1
```

Serial OperationQueue:

```Swift
let task1 = BlockOperation {
    print("Task 1")
}
let task2 = BlockOperation {
    print("Task 2")
}

task1.addDependency(task2)
let serialOperationQueue = OperationQueue()
let tasks = [task1, task2]
serialOperationQueue.addOperations(tasks, waitUntilFinished: false)
```

Concurrent OperationQueue:

```Swift
let task1 = BlockOperation {
    print("Task 1")
}
let task2 = BlockOperation {
    print("Task 2")
}
let concurrentOperationQueue = OperationQueue()
concurrentOperationQueue.maxConcurrentOperationCount = 2
let tasks = [task1, task2]
concurrentOperationQueue.addOperations(tasks, waitUntilFinished: false)
```

Group Concurrent OperationQueue:

```Swift
let task1 = BlockOperation {
    print("Task 1")
}
let task2 = BlockOperation {
    print("Task 2")
}
let taskCombine = BlockOperation {
    print("taskCombine")
}
taskCombine.addDependency(task1)
taskCombine.addDependency(task2)
let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 2
let tasks = [task1, task2, taskCombine]
operationQueue.addOperations(tasks, waitUntilFinished: false)
```

This last is the Dispatch Group. The only difference is that it is much easier to write complex tasks.

## DispatchSource

DispatchSource is used for detecting changes in files and folders. It has many variations depending on our needs. I will just show one example below:

```Swift
let urlPath = URL(fileURLWithPath: "/PathToYourFile/log.txt")
do {
    let fileHandle: FileHandle = try FileHandle(forReadingFrom: urlPath)

    let source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileHandle.fileDescriptor,
                                                           eventMask: .write, // .all, .rename, .delete ....
                                                           queue: .main) // .global, ...
    source.setEventHandler(handler: {
        print("Event")
    })

    source.resume()
} catch {
    // Error
}
```

## Deadlock

There is a situation when two tasks can wait for each other to finish. This is called Deadlock. The task will never be executed and will block the app.

```Swift
// 1. Deadlock
serialQueue.sync {
   serialQueue.sync {
      print(“Deadlock”)
   }
}
```

Never call sync tasks on the main queue; it will cause deadlock.

## Main Thread Checker

There is a way to get a warning that we did something wrong. This is a really useful option, and I recommend using it. It can easily catch some unwanted issues.

If you open on the target and edit the scheme as on the next image, turn on the Main Thread Checker, then when we do some UI update on background, this option on runtime will notify us. See the image below for the purple notification:

![Main Thread Checker](https://cdn-images-1.medium.com/max/2000/1*iIBFEKYQx3iX0eaOWuVwPw.png)

![Main Thread Checker result](https://cdn-images-1.medium.com/max/2416/1*l_UquEAZtmgM7bMSYb2vWg.png)

![Method name where is the issue can be seen](https://cdn-images-1.medium.com/max/2262/1*jQORZnI8tlPbxYRmkuwN6A.png)

You can also see in the Xcode terminal what is wrong. For newcomers, it is maybe a bit of a strange message, but fast you will get used to it. But you can connect that inside that line there is the name of the method where the issue is.

## Threads in Xcode

While debugging, there are a couple of tricks that can help us.

If you add a breakpoint and stop at some line. In the Xcode terminal you can type the command `thread info.` It will print out some details of the current thread.

![Debug the Threads in Code Terminal](https://cdn-images-1.medium.com/max/2628/1*17YeQlxRG8Dtt4cD9zpzOw.png)

Here are some more useful commands for the terminal:

`po Thread.isMainThread`

`po Thread.isMultiThreaded()`

`po Thread.current`

`po Thread.main`

Maybe you had a similar situation — when the app crashed and in the error log you could see something like com.alamofire.error.serialization.response. This means the framework created some custom thread and this is the identifier.

## Async / Await

With iOS13 and Swift 5.5, the long-awaited Async / Await was introduced. It was nice of Apple that they recognized the issue that when something new is introduced then a long delay is happening till it can be used on production as we usually need to support more iOS versions.

Async / Await is a way to run asynchronous code without completion handlers.

```Swift
func exampleAsyncAwait() {
    print("Task 1")
    Task { // 2. Create Task {} Block to be in regular method to handle the Async method 'make'
        let myBool = await make() // 3. Await the method result
        print("Task 2: \(myBool)")
    }
    print("Task 3")
}

func make() async -> Bool { // 1. Create method what rsult is async
    sleep(2)
    return true
}
```

Here is some code worth mentioning:

* `Task.isCancelled`
* Task.init(priority: .background) {}
* Task.detached(priority: .userInitiated) {}
* `Task.cancel()`

I would highlight TaskGroup. This is the “DispatchGroup” in the Await / Async world. I have found that Paul Hudson has a really nice example on this [link](https://www.hackingwithswift.com/quick-start/concurrency/how-to-create-a-task-group-and-add-tasks-to-it).

```Swift
func printMessage() async {
    let string = await withTaskGroup(of: String.self) { group -> String in
        group.addTask { "Hello" }
        group.addTask { "From" }
        group.addTask { "A" }
        group.addTask { "Task" }
        group.addTask { "Group" }

        var collected = [String]()

        for await value in group {
            collected.append(value)
        }

        return collected.joined(separator: " ")
    }

    print(string)
}

await printMessage()
```

## Actor

Actors are classes, reference types that are thread-safe. They handle data race and concurrency issues. As you can see below, accessing the property of the actor is done with `await` keyword.

> “Actors allow only one task to access their mutable state at a time.” — Apple Docs

```Swift
actor TemperatureLogger {
    let label: String
    var measurements: [Int]
    private(set) var max: Int

    init(label: String, measurement: Int) {
        self.label = label
        self.measurements = [measurement]
        self.max = measurement
    }
}

let logger = TemperatureLogger(label: "Outdoors", measurement: 25)
print(await logger.max) // Access with await
// Prints "25"
```

## Conclusion

We’ve covered lots of multithreading topics — from UI and Background Thread to Deadlocks and DispatchGroup. But I’m sure you are now on your way to being an expert or at least prepared for iOS interview questions about multithreading topics.

The whole code sample can be found on the next link: [GitHub](https://github.com/skyspirit86/Multithreading). I hope it will be valuable to play with it yourself.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
