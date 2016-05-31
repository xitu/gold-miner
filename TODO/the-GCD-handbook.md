>* 原文链接 : [The GCD Handbook](http://khanlou.com/2016/04/the-GCD-handbook/)
* 原文作者 : [Soroush](soroush@khanlou.com.)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [LoneyIsError](https://github.com/LoneyIsError)
* 校对者:[woopqww111](https://github.com/woopqww111), [hsinshufan](https://github.com/hsinshufan)



Grand Central Dispatch,或者GCD，是一个极其强大的工具。它给你一些底层的组件，像队列和信号量，让你可以通过一些有趣的方式来获得有用的多线程效果。可惜的是，这个基于C的API是一个有点神秘，它不会明显的告诉你如何使用这个底层组件来实现更高层次的方法。在这篇文章中，我希望描述那些你可以通过GCD提供给你的底层组件来实现的一些用法。


### 后台工作


也许最简单的用法，GCD让你在后台线程上做一些工作，然后回到主线程继续处理，因为像那些属于 `UIKit` 的组件只能（主要）在主线程中使用。

在本指南中，我将使用 `doSomeExpensiveWork()` 方法来表示一些长时间运行的有返回值的任务。

这种模式可以像这样建立起来：


    let defaultPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    let backgroundQueue = dispatch_get_global_queue(defaultPriority, 0)
    dispatch_async(backgroundQueue, {
    	let result = doSomeExpensiveWork()
    	dispatch_async(dispatch_get_main_queue(), {
    		//use `result` somehow
    	})
    })




在实践中，我从不使用任何队列优先级除了 `DISPATCH_QUEUE_PRIORITY_DEFAULT` 。这返回一个队列，它可以支持数百个线程的执行。如果你的耗性能的工作总是在一个特定的后台队列中发生，你也可用通过 `dispatch_queue_create` 方法来创建自己的队列。 `dispatch_queue_create` 可以创建一个任意名称的队列，无论它是串行的还是并行的。

注意每一个调用使用 `dispatch_async` ，不使用 `dispatch_sync` 。`dispatch_async` 在 block 执行前返回，而 `dispatch_sync` 会等到 block 执行完毕才返回。内部的调用可以使用 `dispatch_sync`（因为不管它什么时候返回），但外部必须调用 `dispatch_async` （否则，主线程会被阻塞）。

### 创建单例

 
`dispatch_once` 是一个可以被用来创建单例的API。在 Swift 中它不再是必要的，因为 Swift 中有一个更简单的方法来创建单例。为了以后，当然，我把它写在这里（用 Objective-C ）。

    + (instancetype) sharedInstance {  
    	static dispatch_once_t onceToken;  
    	static id sharedInstance;  
    	dispatch_once(&onceToken, ^{  
    		sharedInstance = [[self alloc] init];  
    	});  
    	return sharedInstance;  
    }  



### 扁平化一个完整的block

现在 GCD 开始变得有趣了。使用一个信号量，我们可以让一个线程暂停任意时间，直到另一个线程向它发送一个信号。这个信号量，就像 GCD 其余部分一样，是线程安全的，并且他们可以从任何地方被触发。

当你需要去同步一个你不能修改的异步API时，你可以使用信号量解决问题。


    // on a background queue
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0)
    doSomeExpensiveWorkAsynchronously(completionBlock: {
        dispatch_semaphore_signal(semaphore)
    })
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    //the expensive asynchronous work is now done



`dispatch_semaphore_wait` 会阻塞线程直到 `dispatch_semaphore_signal` 被调用。这就意味着 `signal` 一定要在另外一个线程中被调用，因为当前线程被完全阻塞。此外，你不应该在在主线程中调用 `wait` ，只能在后台线程。

在调用 `dispatch_semaphore_wait` 时你可以选择任意的超时时间，但是我倾向于一直使用 `DISPATCH_TIME_FOREVER` 。


这可能不是完全显而易见的，为什么你要把已有的一个完整的 block 代码变为扁平化，但它确实很方便。我最近使用的一种情况是，执行一系列必须连续发生的异步任务。这个使用这种方式的简单抽象被称作 `AsyncSerialWorker` :

    typealias DoneBlock = () -> ()
    typealias WorkBlock = (DoneBlock) -> ()

    class AsyncSerialWorker {
        private let serialQueue = dispatch_queue_create("com.khanlou.serial.queue", DISPATCH_QUEUE_SERIAL)

        func enqueueWork(work: WorkBlock) {
            dispatch_async(serialQueue) {
                let semaphore = dispatch_semaphore_create(0)
                work({
                    dispatch_semaphore_signal(semaphore)
                })
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            }
        }
    }



这一小类可以创建一个串行队列，并允许你将工作添加到 block 中。当你的工作完成后， `WorkBlock` 会调用 `DoneBlock` ，开启信号量，并允许串行队列继续。

### 限制并发 block 的数量。

在前面的例子中，信号量作为一个简单的标志，但它也可以被用来作为一种有限的资源计数器。如果你想在一个特定资源上打开特定数量的连接，你可以使用下面的代码：

    class LimitedWorker {
        private let concurrentQueue = dispatch_queue_create("com.khanlou.concurrent.queue", DISPATCH_QUEUE_CONCURRENT)
        private let semaphore: dispatch_semaphore_t

        init(limit: Int) {
        	semaphore = dispatch_semaphore_create(limit)
        }

        func enqueueWork(work: () -> ()) {
            dispatch_async(concurrentQueue) {
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                work()
                dispatch_semaphore_signal(semaphore)
            }
        }
    }



这个例子从苹果的[Concurrency Programming Guide](https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html#//apple_ref/doc/uid/TP40008091-CH102-SW24)拿来的。他们可以更好的解释在这里发生了什么：

> 当你创建一个信号量时，你可以指定你的可用资源的数量。这个值是信号量的初始计数变量。你每一次等待信号量发送信号时，这个  `dispatch_semaphore_wait` 方法使计数变量递减1。如果产生的值是负的，则函数告诉内核来阻止你的线程。在另一端，这个 `dispatch_semaphore_signal` 函数递增count变量用1表示资源已被释放。如果有任务阻塞和等待资源，其中一个随即被放行并进行它的工作。

其效果类似于 `maxConcurrentOperationCount` 在 `NSOperationQueue` 。如果你使用原 GCD队 列而不是 `NSOperationQueue`，你可以使用信号庄主来限制同时执行的 block 数量。

一个值得注意的就是，每次你调用 `enqueueWork` ，如果你打开信号量的限制，就会启动一个新线程。如果你有一个低限并且大量工作的队列，您可以创建数百个线程。一如既往，先配置文件，然后更改代码。

### 等待许多并发任务来完成

如果你有多 block 工作来执行，并且在他们集体完成时你需要发一个通知，你可以使用 group 。`dispatch_group_async` 允许你在队列中添加工作（在 block 里面的工作应该是同步的），并且记录添加了多少了项目。注意，在同一个 dispatch group 中可以将工作添加到不同的队列中，并且可以跟踪它们。当所有跟踪的工作完成，这个 block 开始运行 `dispatch_group_notify` ，就像是一个完整的 block 。


    dispatch_group_t group = dispatch_group_create()
    for item in someArray {
    	dispatch_group_async(group, backgroundQueue, {
    		performExpensiveWork(item: item)
    	})
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), {
    	// all the work is complete
    }



拥有一个完整的block，对于扁平化一个功能来说是一个很好的案例。 dispatch group 认为，当它返回时，这个 block 应该完成了，所以你需要这个 block 等待直到其他工作已经完成。

有更多的手动方式来使用 dispatch groups ，特别是如果你耗性能的工作已经是异步的：


    // must be on a background thread
    dispatch_group_t group = dispatch_group_create()
    for item in someArray {
    	dispatch_group_enter(group)
    	performExpensiveAsyncWork(item: item, completionBlock: {
    		dispatch_group_leave(group)
    	})
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER)

    // all the work is complete



这段代码是比较复杂的，但通过一行一行的阅读可以帮助理解它。就像信号量，groups 也还保持线程安全，是一个你可以操作的内部计数器。您可以使用此计数器来确保在执行完成 block 之前，多个长的运行任务都已完成。使用 “enter” 递增计数器，并用 “leave” 递减计数器。 `dispatch_group_async` 为你处理所有的这些细节，所以我愿意尽可能的使用它。

在这段代码的最后一点是 `wait` 方法：它会阻塞线程，并等待计数器为0后，继续执行。注意，即使你使用了`enter`/`leave` API，你也可以在在队列中添加一个 `dispatch_group_notify` block.反过来也是对的：当你使用 `dispatch_group_async` API时你也可以使用 `dispatch_group_wait` 。

`dispatch_group_wait`，就像`dispatch_semaphore_wait`一样，可以设置超时。再一次声明，`DISPATCH_TIME_FOREVER` 已非常足够使用, 我从未觉得需要使用其他的来设置超时。当然就像 `dispatch_semaphore_wait` 一样，永远不要在主线程使用 `dispatch_group_wait` 。

两者之间最大的区别是，使用 `notify` 可以完全从主线程调用，而使用 `wait`，必须发生在后台队列（至少 `wait` 的部分，因为它会完全阻塞当前队列）。

### 隔离队列

 Swift 语言的 `Dictionary` （和  `Array` ）类型都是值类型。 当他们被改变时, 他们的引用会完全被新的结构给替代。当然，因为更新实例变量的 Swift 对象不是原子性的，它们不是线程安全的。双线程可以在同一时间更新一个字典（例如，增加一个值），并且两个尝试写在同一块内存，这可能导致内存损坏。我们可以使用隔离队列来实现线程安全。
让我们创建一个 [identity map] (http://martinfowler.com/eaaCatalog/identityMap.html)。 identity map 是一个字典，将项目从其`ID` 属性映射到模型对象。


    class IdentityMap<T: Identifiable> {
    	var dictionary = Dictionary<String, T>()

    	func object(forID ID: String) -> T? {
    		return dictionary[ID] as T?
    	}

    	func addObject(object: T) {
    		dictionary[object.ID] = object
    	}
    }



这个对象基本上是一个字典的包装器。如果我们的方法 `addObject` 同一时间被多个线程所调用，它可能会损害内存，因为这些线程对对同一个引用进行处理。这被称之为 [readers-writers problem](https://en.wikipedia.org/wiki/Readers–writers_problem)。总之，我们可以同时有多个读者阅读，但是只有一个线程可以在任何给定的时间写。
幸运的是，GCD 给了我们很好的工具去处理这样的情况。我们可以使用以下四种 API ：

*   `dispatch_sync`
*   `dispatch_async`
*   `dispatch_barrier_sync`
*   `dispatch_barrier_async`

我们理想的情况是，读同步，同时，而写可以异步，当引用该对象时必须是唯一的。 GCD 的 `barrier` API集可以做一些特别的事情：他们执行 block 之前必须等到队列完全空了。使用 `barrier` API去进行字典写入的操作将会被限制，这样确保我们永远不会有任何写入发生在同一时间，无论是读取或是写入。


    class IdentityMap<T: Identifiable> {
    	var dictionary = Dictionary<String, T>()
    	let accessQueue = dispatch_queue_create("com.khanlou.isolation.queue", DISPATCH_QUEUE_CONCURRENT)

    	func object(withID ID: String) -> T? {
    		var result: T? = nil
    		dispatch_sync(accessQueue, {
    			result = dictionary[ID] as T?
    		})
    		return result
    	}

    	func addObject(object: T) {
    		dispatch_barrier_async(accessQueue, {
    			dictionary[object.ID] = object
    		})
    	}
    }



`dispatch_sync` 将 block 添加到我们的隔离队列，然后等待它在返回之前执行。这样，我们就会有我们的同步阅读的结果。（如果我们没有做到同步，我们的 getter 方法可能需要一个完成的 block 。）因为 `accessQueue` 是并发的，这些同步读取就能同时发生。
`dispatch_barrier_async` 将 block 添加到隔离队列。这个 `async` 部分意味着它将实际执行的 block 之前返回（执行写入操作）。这对我们的表现有好处，但也有一个缺点是，在 “write” 操作后立即执行 “read” 操作可能会导致获取改变之前的旧数据。
这个 `dispatch_barrier_async` 的 `barrier` 部分，意味着它将等待直到当前运行队列中的每个 block 执行完毕后才执行。其他 block 将在它后面排队，当barrier调度完成时执行。

### 总结
Grand Central Dispatch 是一个有很多底层语言的框架。使用它们，这个是我能建立的比较高级的技术。如果有其他一些你使用的GCD的高级用法而我没有罗列在这里，我喜欢听到它们并将它们添加到列表中。
