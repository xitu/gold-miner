>* 原文链接 : [The GCD Handbook](http://khanlou.com/2016/04/the-GCD-handbook/)
* 原文作者 : [Soroush](soroush@khanlou.com.)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Grand Central Dispatch, or GCD, is an extremely powerful tool. It gives you low level constructs, like queues and semaphores, that you can combine in interesting ways to get useful multithreaded effects. Unfortunately, the C-based API is a bit arcane, and it isn’t immediately obvious how to combine the low-level components into higher level behaviors. In this post, I hope to describe the behaviors that you can create with the low-level components that GCD gives you.

### Work In The Background

Perhaps the simplest of behaviors, this one lets you do do some work on a background thread, and then come back to the main thread to continue processing, since components like those from `UIKit` can (mostly) be used only with the main thread.

In this guide, I’ll use functions like `doSomeExpensiveWork()` to represent some long running task that returns a value.

This pattern can be set up like so:



    let defaultPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    let backgroundQueue = dispatch_get_global_queue(defaultPriority, 0)
    dispatch_async(backgroundQueue, {
    	let result = doSomeExpensiveWork()
    	dispatch_async(dispatch_get_main_queue(), {
    		//use `result` somehow
    	})
    })



In practice, I never use any queue priority other `DISPATCH_QUEUE_PRIORITY_DEFAULT`. This returns a queue, which can be backed by hundreds of threads of execution. If you need the expensive work to always happen on the a specific background queue, you can create your own with `dispatch_queue_create`. `dispatch_queue_create` accepts a name for the queue and whether the queue should be concurrent or serial.

Note that each call uses `dispatch_async`, not `dispatch_sync`. `dispatch_async` returns _before_ the block is executed, and `dispatch_sync` waits until the block is finished executing before returning. The inner call can use `dispatch_sync` (because it doesn’t matter when it returns), but the outer call must be `dispatch_async` (otherwise the main thread will be blocked).

### Creating singletons

`dispatch_once` is an API that can be used to create singletons. It’s no longer necessary in Swift, since there is a simpler way to create singletons. For posterity, however, I’ve included it here (in Objective-C).



    + (instancetype) sharedInstance {  
    	static dispatch_once_t onceToken;  
    	static id sharedInstance;  
    	dispatch_once(&onceToken, ^{  
    		sharedInstance = [[self alloc] init];  
    	});  
    	return sharedInstance;  
    }  



### Flatten a completion block

This is where GCD starts to get interesting. Using a _semaphore_, we can block a thread for an arbitrary amount of time, until a signal from another thread is sent. Semaphores, like the rest of GCD, are thread-safe, and they can be triggered from anywhere.

Semaphroes can be used when there’s an asynchronous API that you need to make synchronous, but you can’t modify it.



    // on a background queue
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0)
    doSomeExpensiveWorkAsynchronously(completionBlock: {
        dispatch_semaphore_signal(semaphore)
    })
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    //the expensive asynchronous work is now done



Calling `dispatch_semaphore_wait` will block the thread until `dispatch_semaphore_signal` is called. This means that `signal` **must** be called from a different thread, since the current thread is totally blocked. Further, you should never call `wait` from the main thread, only from background threads.

You can choose any timeout when calling `dispatch_semaphore_wait`, but I tend to always pass `DISPATCH_TIME_FOREVER`.

It might not be totally obvious why would you want to flatten code that already has a completion block, but it does come in handy. One case where I’ve used it recently is for performing a bunch of asynchronous tasks that must happen serially. A simple abstraction for that use case could be called `AsyncSerialWorker`:



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



This small class creates a serial queue, and then allows you enqueue work onto the block. The `WorkBlock` gives you a `DoneBlock` to call when your work is finished, which will trip the semaphore, and allow the serial queue to continue.

### Limiting the number of concurrent blocks

In the previous example, the semaphore is used as a simple flag, but it can also be used as a counter for finite resources. If you want to only open a certain number of connections to a specific resource, you can use something like the code below:



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



This example is pulled from Apple’s [Concurrency Programming Guide](https://developer.apple.com/library/ios/documentation/General/Conceptual/ConcurrencyProgrammingGuide/OperationQueues/OperationQueues.html#//apple_ref/doc/uid/TP40008091-CH102-SW24). They can explain what’s happening here better than me:

> When you create the semaphore, you specify the number of available resources. This value becomes the initial count variable for the semaphore. Each time you wait on the semaphore, the `dispatch_semaphore_wait` function decrements that count variable by 1\. If the resulting value is negative, the function tells the kernel to block your thread. On the other end, the `dispatch_semaphore_signal` function increments the count variable by 1 to indicate that a resource has been freed up. If there are tasks blocked and waiting for a resource, one of them is subsequently unblocked and allowed to do its work.

The effect is similar to `maxConcurrentOperationCount` on `NSOperationQueue`. If you’re using raw GCD queues instead of `NSOperationQueue`, you can use semaphores to limit the number of blocks that execute simultaneously.

One notable caveat is that each time you call `enqueueWork`, if you have hit the semaphore’s limit, it will spin up a new thread. If you have a low limit and lots of work to enqueue, you can create hundreds of threads. As always, profile first, and change the code second.

### Wait for many concurrent tasks to finish

If you have many blocks of work to execute, and you need to be notified about their collective completion, you can use a _group_. `dispatch_group_async` lets you add work onto a queue (the work in the block should be synchronous), and it keeps track of how many items have been added. Note that the same dispatch group can add work to multiple different queues and can keep track of them all. When all of the tracked work is complete, the block passed to `dispatch_group_notify` is fired, kind of like a completion block.



    dispatch_group_t group = dispatch_group_create()
    for item in someArray {
    	dispatch_group_async(group, backgroundQueue, {
    		performExpensiveWork(item: item)
    	})
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), {
    	// all the work is complete
    }



This is a great case for flattening a function that has a completion block. The dispatch group considers the block to be completed when it returns, so you need the block to wait until the work is complete.

There’s a more manual way to use dispatch groups, especially if your expensive work is already async:



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



This snippet is more complex, but stepping through it line-by-line can help in understanding it. Like the semaphore, groups also maintain a thread-safe, internal counter that you can manipulate. You can use this counter to make sure multiple long running tasks are all completed before executing a completion block. Using “enter” increments the counter, and using “leave” decrements the counter. `dispatch_group_async` handles all these details for you, so I prefer to use it where possible.

The last thing in this snippet is the `wait` call: it blocks the thread and waits for the counter to reach 0 before continuing. Note that you can queue a block with `dispatch_group_notify` even if you use the `enter`/`leave` APIs. The reverse is also true: you can use the `dispatch_group_wait` if you use the `dispatch_group_async` API.

`dispatch_group_wait`, like `dispatch_semaphore_wait`, accepts a timeout. Again, I’ve never had a need for anything other than `DISPATCH_TIME_FOREVER`. Also similar to `dispatch_semaphore_wait`, _never_ call `dispatch_group_wait` on the main thread.

The biggest difference between the two styles is that the example using `notify` can be called entirely from the main thread, whereas the example using `wait` must happen on a background queue (at least the `wait` part, because it will fully block the current queue).

### Isolation Queues

Swift’s `Dictionary` (and `Array`) types are value types. When they’re modified, their reference is fully replaced with a new copy of the structure. However, because updating instance variables on Swift objects is not atomic, they are _not_ thread-safe. Two threads can update a dictionary (for example by adding a value) at the same time, and both attempt to write at the same block of memory, which can cause memory corruption. We can use isolation queues to achieve thread-safety.

Let’s build an [identity map](http://martinfowler.com/eaaCatalog/identityMap.html). An identity map is a dictionary that maps items from their `ID` property to the model object.



    class IdentityMap<T: Identifiable> {
    	var dictionary = Dictionary<String, T>()

    	func object(forID ID: String) -> T? {
    		return dictionary[ID] as T?
    	}

    	func addObject(object: T) {
    		dictionary[object.ID] = object
    	}
    }



This object basically acts as a wrapper around a dictionary. If our function `addObject` is called from multiple threads at the same time, it could corrupt the memory, since the threads would be acting on the same reference. This is known as the [readers-writers problem](https://en.wikipedia.org/wiki/Readers–writers_problem). In short, we can have multiple readers reading at the same time, and only one thread can be writing at any given time.

Fortunately, GCD gives us great tools for this exact scenario. We have four APIs at our disposal:

*   `dispatch_sync`
*   `dispatch_async`
*   `dispatch_barrier_sync`
*   `dispatch_barrier_async`

Our ideal case is that reads happen synchronously and concurrently, whereas writes can be asynchronous and must be the only thing happening to the reference. GCD’s `barrier` set of APIs do something special: they will wait until the queue is totally empty before executing the block. Using the `barrier` APIs for our writes will limit access to the dictionary and make sure that we can never have any writes happening at the same time as a read or another write.



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



`dispatch_sync` will dispatch the block to our isolation queue and wait for it to be executed before returning. This way, we will have the result of our read synchronously. (If we didn’t make it synchronous, our getter would need a completion block.) Because `accessQueue` is concurrent, these synchronous reads will be able to occur simultaneously.

`dispatch_barrier_async` will dispatch the block to the isolation queue. The `async` part means it will return before actually executing the block (which performs the write). This is good for our performance, but does have the drawback that performing a “read” immediately after a “write” may result in stale date.

The `barrier` part of `dispatch_barrier_async` means that it will wait until every currently running block in the queue is finished executing before it executes. Other blocks will queue up behind it and be executed when the barrier dispatch is done.

### Wrap Up

Grand Central Dispatch is a framework with a lot of low-level primitives. Using them, these are the higher-level behaviors I’ve been able to build. If there are any higher-level things you’ve used GCD to build that I’ve left out here, I’d love to hear about them and add them to the list.

