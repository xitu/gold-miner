> - 原文地址：[The Complete Guide to Concurrency and Multithreading in iOS](https://betterprogramming.pub/the-complete-guide-to-concurrency-and-multithreading-in-ios-59c5606795ca)
> - 原文作者：[Varga Zolt](https://medium.com/@varga-zolt)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/the-complete-guide-to-concurrency-and-multithreading-in-ios.md](https://github.com/xitu/gold-miner/blob/master/article/2022/the-complete-guide-to-concurrency-and-multithreading-in-ios.md)
> - 译者：[YueYong](https://github.com/YueYongDev)
> - 校对者：[haiyang-tju](https://github.com/haiyang-tju)、[DylanXie123](https://github.com/DylanXie123)

# iOS 并发与多线程完整指南

![Photo by [John Anvik](https://unsplash.com/@redviking509?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8634/0*OUahLXqbffAW6U5y)

> 主线程 vs 后台线程。 Async/await 和 Actor。 GCD vs 操作队列（OperationQueue） 分组调度（Group dispatch），如何授权后台线程，以及其他

## 说明

在本文中，我们将会学习以下内容：

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

本文涉及较多主题。如果有些内容你已经很熟悉了，可以尝试跳过它，阅读你还未熟悉的部分。会有一些技巧和提示。

## 现实世界中的多线程实例

假设你有一个餐厅，服务员在收集订单。厨房在准备食物，酒保在制作咖啡和鸡尾酒。

有时，会有很多人点咖啡和食物这些需要很多时间来准备的东西。此时铃声突然响起，5 份食物和 4 份咖啡已经准备完成。但是，即使所有的产品都已备齐，服务员也要逐一送到不同的餐桌上。这就是**串行队列**。使用串行队列，你只能有一个服务员。

现在假设你有两个或三个服务员。他们可以在同一时间以更快的速度为各桌服务。这就是**并行**。即，使用多个 CPU 来操作多个进程。

继续假设，一个服务员不只服务一个桌子，而是先为所有桌子的人送上所有的咖啡，然后，他们会为一些新来桌子的顾客进行点单，最后才供应所有的食物。这个概念被称为**并发**。即在同一时间段内进行上下文切换，管理以及多计算任务。这并不一定意味着它们会在同一时刻都在运行。例如，在单核机器上进行的多任务处理。

如今的设备都有多个 CPU（[中央处理器](https://en.wikipedia.org/wiki/Central_processing_unit)）。为了能够创建具有无缝流转的应用程序，我们需要了解**多线程**的概念。这是应用程序中处理多任务的一种方式。很重要的一点是，我们需要明白，如果某个东西 "有效"，它也许不是最好的、最理想的方式。很多时候，我看到一个任务长期运行在 UI 线程上，并且阻塞了应用程序几秒钟。现在，对于用户来说，这可能是一个抉择的时刻。用户可能会删除你的应用程序，因为他们觉得其他的应用程序启动得更快，可以更快地获取书籍、下载音乐等。竞争激烈，人们都追求着更优秀的体验。

![线程执行类型](https://cdn-images-1.medium.com/max/2000/1*VAGYSwgHGTHvAPhP1m204Q.png)

如果 "Serial 6" 的任务是在当前时间安排的，那么你就可以看到它了。它将以 **FIFO** 的方式添加到列表中，并等待将来的执行。

## 多线程的基础

我一直纠结的一件事是，没有标准的术语。为了帮助解决这个问题，对于这些主题，我将首先写下同义词、例子。如果你使用 iOS 以外的其他技术，你仍然可以理解这个概念并将其延伸到其他技术的理解与使用上，因为基本原理是相同的。幸运的是，在我职业生涯的早期，我一直在使用 C、C++、C#、node.js、Java（Android） 等技术栈，所以我已经习惯了这种上下文的切换。

- **主线程 / UI 线程：** 这是一个预先定义好的串行线程，与应用程序一起启动。它监听用户交互和用户界面的变化。所有的变化都需要一个即时的响应。需要注意的是，不要让这个线程执行较多的耗时任务，因为应用程序会卡死。

![在 UI 线程上运行耗时任务（错误的做法）](https://cdn-images-1.medium.com/max/2000/1*xz9E1Nuw29R-rcINHsnUlA.png)

```
DispatchQueue.main.async {
    // Run async code on the Main/UI Thread. E.g.: Refresh TableView
}
```

- **后台线程（全局）:** 预定义的。大多数情况下，我们根据自己的需要在新线程上创建任务。例如，如果我们需要下载体积较大的图片，这是在后台线程上完成的。又例如当调用一些 API 时，我们不想因为等待这个任务的完成而阻止用户的操作。我们将在后台线程上调用一个 API 来获取一个电影数据的列表。当收到响应并完成数据解析后，我们便切换至主线程上并更新用户界面。

![长时间运行的任务（正确的做法是在后台线程上执行）](https://cdn-images-1.medium.com/max/2000/1*WqeTWiks2f1AXxy2uAdWUQ.png)

```
DispatchQueue.global(qos: .background).async {
     // Run async on the Background Thread. E.g.: Some API calls.
}
```

![一个 SerialQueue 的例子](https://cdn-images-1.medium.com/max/2216/1*VnKZUZS-ZeYlZ9CHgsxCgw.png)

在上面的图片中，我们在第 56 行添加了一个断点。当它被执行到时，应用程序将会中断，我们可以在左侧的线程信息面板上看到这一点。

1. 你可以看到调度队列（DispatchQueue）的定义（label: “com.kraken.serial”）。 label 是该队列的标识符。
2. 这些按钮可以用来关闭/过滤掉系统方法调用，只看到用户发起的方法。
3. 你可以看到，我们添加了`sleep(1)`。这段代码将会使应用程序停止 1 秒。
4. 如果你看了这个命令，它仍然是以串行方式触发的。

基于之前的 iOS，最常用的两个术语之一是串行队列和并发队列。

![一个 ConcurrentQueue 的例子](https://cdn-images-1.medium.com/max/2488/1*bnTmlYColH5efxcnLtJBzQ.png)

1. 这就是并发队列的结果之一。你可以看到上面的串行/主线程也是这样的（**com.apple.main-thread**）。
2. `sleep(2)`被添加到这个断点上。
3. 整个过程没有任何顺序。它是在后台线程上以异步方式完成的。

```
let mainQueue = DispatchQueue.main
let globalQueue = DispatchQueue.global()
let serialQueue = DispatchQueue(label: “com.kraken.serial”)
let concurQueue = DispatchQueue(label: “com.kraken.concurrent”, attributes: .concurrent)
```

我们还可以创建一个私有队列，它也可以是串行和并发的。

## GCD (Grand Central Dispatch)

GCD 是苹果的低级线程接口，用于支持多核硬件上的并发代码执行。GCD 以一种简单的方式，让你的手机可以在后台下载视频的同时保持用户界面的响应。

> "DispatchQueue 是一个管理应用程序的主线程或后台线程任务的串行或并发执行的对象。" —— Apple Developer

如果你注意到上面的代码示例，你可以看到 “qos” 这个词。它指的是服务质量。通过这个参数，我们可以定义如下的优先级。

- **background** — 当一个任务对时间不敏感，或者当用户可以在这个过程中做一些其他的互动时，我们可以使用这个方法。比如预先获取一些图片做预加载，或者在后台处理一些数据。这个任务的执行需要一定的时间，几秒或者几分钟，甚至几个小时。
- **utility** — 长期运行的任务。一些用户可以看到处理过程。例如，下载一些带有指标的地图。这个任务可能需要几秒钟甚至几十分钟的时间。
- **userInitiated** — 用户从用户界面启动一些任务并等待结果以继续与应用程序交互。这个任务需要几秒钟或一瞬间。
- **userInteractive** — 用户需要立即完成某些任务，以便能够继续与应用程序进行下一次交互。是一个即时任务。

标记 "DispatchQueue "很有用。这可以帮助我们在需要时识别不同的线程类型。

## 调度组（DispatchGroup）

通常我们需要启动多个异步进程，但当所有进程完成后，我们只需要一个事件。这可以通过 DispatchGroup 来实现。

> “作为一个单元监控的一组任务。” —— Apple Docs

例如，有时候在应用程序准备好与用户互动或在主线程上更新用户界面之前，你需要在后台线程上进行多个 API 调用。这里有一些示例代码。

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

- **步骤 1.** 新建 `DispatchGroup`
- **步骤 2.** 然后，对于该组需要为每个任务调用 `group.enter()` 事件来启动任务。
- **步骤 3.** 对于每一个 `group.enter()` 都需要在任务完成后调用 `group.leave()`。
- **步骤 4.** 当所有的 enter-leave 任务对完成后，`group.notify` 被调用。如果你注意到它是在后台线程中完成的。你可以根据你的需要进行配置。

![调度组。任务依次执行，通知统一发送](https://cdn-images-1.medium.com/max/3028/1*5abBihhgOraZToTOi4lwVA.gif)

值得一提的是 `wait(timeout:)` 选项。它将等待一些时间来完成任务，但在超时后，它会继续执行下去。

## 调度信号量（DispatchSemaphore）

> "一个通过使用传统的计数信号来控制跨多个执行环境对资源的访问的对象。" —— Apple Docs

```Swift
let semaphore = DispatchSemaphore(value: 1)
semaphore.wait()
task { (result) in
    semaphore.signal()
}
```

每次访问某些共享资源时，调用 `wait()`。

当我们准备释放共享资源时，调用 `signal()`。

`DispatchSemaphore` 的 `value` 表示并发任务的数量。

## DispatchWorkItem

一个普遍的看法是，当一个 GCD 任务被安排后，它就不能被取消。但这是不正确的。因为只有在 iOS8 之前是这样的。

> "你想执行的工作，以一种可以附加完成句柄或执行依赖项的方式封装。" —— Apple Docs

举个例子，如果你正在使用一个搜索栏。每一个字母的输入都会调用一次查询电影列表的 API。假设你正在输入 "蝙蝠侠"。"B"、"Ba"、"Bat"......每个字母的输入都会触发一次网络请求，但事实上我们不希望这样。我们可以简单地取消之前的调用，例如，如果在那一秒的范围内输入了另一个字母。只有当输入的间隔时间超过一秒，而用户没有输入新的字母时，那么我们才认为需要调用那个 API。

![搜索栏。使用 DispatchWorkItem 模拟 “Debounce” ](https://cdn-images-1.medium.com/max/2480/1*kurFvLtoj7jovJcKT1P4tg.gif)

当然，如果借助 RxSwift/Combine 这样的函数式编程，我们会有更好的选择，比如 debounce(for:scheduler:options:)。

## 调度障碍 Dispatch Barrier

Dispatch Barriers 尝试用一个读/写锁来解决这个问题。这保证了只有这个 DispatchWorkItem 会被执行。

> “这会使线程不安全对象变得线程安全。” —— Apple Docs

![Dispatch Barrier](https://cdn-images-1.medium.com/max/2000/1*WlHRf0N33mKFj_GHm91Wyg.png)

![Barrier Timeline](https://cdn-images-1.medium.com/max/4268/1*GiFY0BTDW2guffVbajIPJw.png)

例如，如果我们要保存游戏，我们要写到一些打开的共享文件，资源。

## AsyncAfter

我们可以用如下代码来延迟一些任务的执行：

```Swift
// 1. Time
let delay = 2.0

// 2. Schedule
DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
    // Execute some task with delay
}
```

在我看来，就异常而言，这是万恶之源。对于每一个需要延迟的异步任务，我建议要考虑清楚，如果可能的话，可以使用一些状态管理系统，但不要把这个作为第一选择。通常情况下，还会有其他解法。

## (NS)Operation and (NS)OperationQueue

如果你正在使用 NSOperation，这意味着你在页面逻辑背后使用了 GCD，因为 NSOperation 是建立在 GCD 之上的。NSOperation 的一些好处是，它有一个更友好的接口来处理 Dependencies（按特定顺序执行任务），它是可观察的（KVO 来观察属性），有暂停、取消、恢复和控制（你可以指定队列中任务的数量）。

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

你可以把并发操作数设置为 1，这样它就可以作为一个串行队列工作。

```
queue.maxConcurrentOperationCount = 1
```

串行 OperationQueue:

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

同步 OperationQueue:

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

组并发 OperationQueue:

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

最后这个是调度组。唯一的区别是，它更容易编写复杂的任务。

## 调度源（DispatchSource）

DispatchSource 用于检测文件和文件夹的变化。针对不同的需求，可以检测不同的变化。篇幅有限，下面我只展示一个例子。

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

## 死锁（Deadlock）

有一种情况是，两个任务会互相等待对方完成。这被称为死锁。该任务将永远不会被执行，并会阻塞应用程序。

```Swift
// 1. Deadlock
serialQueue.sync {
   serialQueue.sync {
      print(“Deadlock”)
   }
}
```

千万不要在主队列上调用同步任务，这将导致死锁。

## 主线程检查器（Main Thread Checker）

有一种方法可以警告我们哪里做错了。这是一个非常实用的功能，它可以轻松捕获一些不重要的问题。

如果你在目标上打开并编辑下一张图片上的方案，此时打开主线程检查器，那么当我们在后台做一些 UI 上的更新时，运行时的这个选项会通知我们。请看下图中的紫色通知。

![主线程检查器](https://cdn-images-1.medium.com/max/2000/1*iIBFEKYQx3iX0eaOWuVwPw.png)

![主线程检查结果](https://cdn-images-1.medium.com/max/2416/1*l_UquEAZtmgM7bMSYb2vWg.png)

![可以看到问题所在的方法名称](https://cdn-images-1.medium.com/max/2262/1*jQORZnI8tlPbxYRmkuwN6A.png)

你也可以在 Xcode 终端看到什么是错误的。对于新手来说，这可能是一个有点奇怪的信息，但很快你就会习惯它。但是你可以在这一行中看到问题所在的方法的名称。

## Xcode 中的线程

在调试的时候，有几个小技巧可以帮助我们。

如果你添加一个断点并在某一行停止。在 Xcode 终端中，你可以输入命令 `thread info` 它将打印出当前线程的一些细节。

![在代码终端调试线程](https://cdn-images-1.medium.com/max/2628/1*17YeQlxRG8Dtt4cD9zpzOw.png)

下面是一些对终端有用的命令：

`po Thread.isMainThread`

`po Thread.isMultiThreaded()`

`po Thread.current`

`po Thread.main`

也许你也有过类似的情况——当应用程序崩溃时，在错误日志中你可以看到诸如 com.alamofire.error.serialization.response 的东西。这意味着框架创建了一些自定义线程，这就是标识符。

## Async / Await

在 iOS13 和 Swift 5.5 中，引入了人们期待已久的 Async / Await。苹果公司机智的意识到了一个问题，那就是当新的东西被引入时，在它可以被运用到实际的生产使用前，会有一个很长的缓冲时间，因为我们通常需要支持更多的 iOS 版本。

Async / Await 是一种运行异步代码的方式，不需要回调处理程序。

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

这里有一些值得一提的代码：

- `Task.isCancelled`
- Task.init(priority: .background) {}
- Task.detached(priority: .userInitiated) {}
- `Task.cancel()`

我想强调一下 TaskGroup。这是 Awaiting/Async 世界中的 “DispatchGroup”。我发现 Paul Hudson 在这方面有一个非常好的例子[链接](https://www.hackingwithswift.com/quick-start/concurrency/how-to-create-a-task-group-and-add-tasks-to-it)。

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

Actors 是一个类，它是线程安全的引用类型。它被用来处理数据竞争和并发问题。正如你在下面看到的，访问 actor 的属性是通过 `await` 关键字完成的。

> “Actors 一次只允许一个任务访问其可变状态。 ” — Apple Docs

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

## 结论

我们已经聊了很多多线程的话题——从 UI 和后台线程到死锁和 DispatchGroup。我相信你现在已经在成为专家的路上了，或者至少为 iOS 面试中关于多线程主题的问题做好准备。

整个代码示例可以在下面的链接中找到：[GitHub](https://github.com/skyspirit86/Multithreading)。我希望这对你来说是有价值的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
