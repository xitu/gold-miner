>* 原文链接：[Design patterns for safe timer usage](http://www.cocoawithlove.com/blog/2016/07/30/timer-problems.html)
* 原文作者：[Matt Gallagher](http://www.cocoawithlove.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

Timers can be a surprisingly tricky tool to use correctly.

Deferred invocations and single fire timers are simple enough to get working but they vary between an unmaintainable anti-pattern that should never be used and a construct highly prone to subtle ordering problems between control and handler contexts.

Join me for a look at bugs and potential maintenance issues involving timers.

> **NOTE**: code in this article will demonstrate single fire timers with the Swift 3 version of the Dispatch API. Many of the same principles should be applicable to periodic timers and other asynchronous timer APIs to varying extents.

## Purpose of a timer

The problems with timers often start before any code is written.

Timers have a conceptual problem: their *interface* makes them look like their purpose is to delay a function to some time in the future. Technically, delaying a function is what they do but it is never their *purpose*.

The purpose of a single fire timer is to perform end-of-lifetime operations for a temporary resource. Session timers delete the session when they elapse. Timeouts close idle connections. User interface timers delete view elements or reset view state. Timers for calendar events move the event from pending to elapsed.

Occasionally, you might see timers that *look* like a delay without an underlying temporary resource. The worst of these are delays in the hope that the delayed function might be invoked *after* some precondition occurs. Hoping that independent code will complete within a specific time period is the worst kind of [coupling](https://en.wikipedia.org/wiki/Coupling_(computer_programming)) (and is almost always ingoring a notification that could trigger it properly).

By contrast, periodic timers don't necessarily have such a clearly defined purpose. A periodic timer might continuously update the same resource, might create or delete a discrete resource each time or might perform ephemeral work without a persistent resource.

But even in this undesirable delay-only scenario, *the delay state is itself is a temporary resource*. All states should be clearly represented as values in your data – allowing composability, testing and debugging of the state – and this type of state is no exception.

I am stressing this purpose of timers since it leads to the following expectations:

1. a timer should always be closely tied to an associated temporary resource
2. changes to either the timer or its associated temporary resource must resolve synchronously with the other (even when they don’t always *occur* synchronously)

Most problems around timers involve failure to meet one of these expectations.

## Deferred invocations

Using libdispatch, the simplest form of timer is `DispatchQueue.after`. This is a form of “deferred invocation” that simply delays a function but returns no reference and therefore offers no possibility for cancellation.

A basic `after` invocation might look something like this:

    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(10)) {
      // Some deferred code
    }

Deferred invocations are sometimes useful for quickly probing and tesing scenarios during debug investigations but they are simply **too prone to problems to be safely used in a deployed program**.

Let’s look at the most obvious situation where a deferred invocation will cause problems:

    class Parent {
      let queue = DispatchQueue(label: "")
      var temporaryChild: Child? = nil
       
      func createChild() {
        queue.sync {
          // Construct a new, temporary value
          temporaryChild = Child()
             
          // Schedule cleanup after a 10 seconds
          let t = DispatchTime.now() + DispatchTimeInterval.seconds(10)
          DispatchQueue.global().asyncAfter(deadline: t) { [weak self] in
            guard let s = self else { return }
                
              // Delete the value when invoked
              s.queue.sync { s.temporaryChild = nil }
          }
        }
      }
    }


When the `temporaryChild` is created, a deferred invocation is scheduled to remove it after `10.0` seconds but this deferred invocation does not share the same lifetime as the `temporaryChild`.

It should be easy to see how this goes wrong: call `createChild` twice and the first deferred invocation will delete the second `temporaryChild`.

I consider `after` to be unusable in deployed code due to its potential for causing maintenance problems; you can make it work but the result is highly fragile. Small changes to code *outside* the immediate scope of the timer can break its behavior. Worse: when it breaks, it might continue to *look* like it works and might pass your automated testing unless you hit the exact timing pattern required to cause problems.

**Don’t use deferred invocations outside of debug investigations.**

## Cancellable timer

A cancellable timer is not much more difficult than a deferred invocation. 

    public extension DispatchSource {
      public class func makeTimerSource(interval: DispatchTimeInterval, handler: () -> Void)
        -> DispatchSourceTimer {
        let result = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        result.setEventHandler(handler: handler)
        result.scheduleOneshot(deadline: DispatchTime.now() + interval)
        result.resume()
        return result
     }
  }

The returned `DispatchSourceTimer` will *automatically* cancel the timer if it is released, so we immediately have a much safer design.

    class Parent {
       let queue = DispatchQueue(label: "")
       var temporaryChild: (child: Child, timer: DispatchSourceTimer)? = nil
       
       func createChild() {
          queue.sync {
             // Construct a new child
             let c = Child()
             
             // Schedule deletion
             let t = DispatchSource.makeTimerSource(interval: .seconds(10)) { [weak self] in
                guard let s = self else { return }
                
                // Delete the child when invoked
                s.queue.sync { s.temporaryChild = nil }
             }
             
             // Tie the child and timer together
             temporaryChild = (c, t)
          }
       }
    }

The lifetime of the timer is tied to the lifetime of the resource that it manipulates and the previous problem is solved.

**But we still have a critical flaw in this code.**

## Ignoring cancelled timers

In all the `Parent` examples, access to the `temporaryChild` was protected by using `queue.sync` as a mutex. However, there’s an important lesson here about mutexes: **the mutex alone is not enough to make the code thread safe**.

Consider the following order of events:

1. A child is created using `createChild()`
2. 10 seconds later, the handler is invoked on the `DispatchQueue.global()` concurrent queue
3. The handler starts but does not yet enter `s.queue.sync`
4. While that is happening, the `createChild()` function is called again, entering the queue, creating a new child and new timer and exiting the queue.
5. The handler from step 3 – which was associated with the old, already deleted child – finally enters `s.queue.sync` and deletes the *new* child.

A previous timer has deleted the new child. Oops.

We’re back to the problem where the timer is not correctly tied to the appropriate child. Any scenario where handler control or execution occurs outside the mutex can create a mismatch between the mutex’s version of sequential and the timer’s version of sequential. Since we only care about the *mutex’s* version of sequential, we need to ignore timer handlers that are not the most recent timer handler applied under the mutex. This involves changing the timer’s construction so that the handler takes a parameter that we can use to distinguish out-of-date timers.

One way this is sometimes done is to pass a reference to the `timer` itself into the handler function. This requires re-writing the previous `DispatchSource.timer` function:

    public extension DispatchSource {
     // Similar to before but we pass an instance of the timer to the handler function
     public class func makeTimerSource(interval: DispatchTimeInterval, handler:
        (DispatchSource) -> Void) -> DispatchSourceTimer {
        let result = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        
        // Some minor juggling with the timer instance to avoid creating a retain cycle
        let res = result as! DispatchSource
        result.setEventHandler { [weak res] in
           guard let r = res else { return }
           handler(r)
        }
        
        result.scheduleOneshot(deadline: DispatchTime.now() + interval)
        result.resume()
        return result
     }
  }

and then you can use the new `timer` construction like this:

    class Parent {
       let queue = DispatchQueue(label: "")
       var temporaryChild: (child: Child, timer: DispatchSourceTimer)? = nil
       
       func createChild() {
          queue.sync {
             // Construct a new child
             let c = Child()
             
             // Schedule deletion
             let t = DispatchSource.makeTimerSource(interval: .seconds(10)) {
                [weak self] (t: DispatchSource) in
                guard let s = self else { return }
                s.queue.sync {
                   // Verify the identity of the timer
                   guard let childTimer = s.temporaryChild?.timer,
                      t === (childTimer as AnyObject) else {
                      return
                   }
                   s.temporaryChild = nil
                }
             }
             
             // Tie the child and timer together
             temporaryChild = (c, t)
          }
       }
    }

Our handler function now verifies it is still the “current” timer and aborts if it isn’t.

## A timer with generation count

The code now *mostly* works but there’s a situation it doesn’t handle: *rescheduled* timers.

A rescheduled timer is one where we needed to extend the deadline for the timer. An example is an idle timer (e.g. a sleep timer or a timeout timer). For an idle timer, each new activity should reset the timer to its full duration.

The problem with rescheduling is that it sets a new deadline for the timer but the underyling timer instance remains the same. If a handler is in the middle of invocation while we’re changing the deadline, the handler invocation for the old deadline will still succeed since it has the same timer identity.

To ignore cancelled timers *and* rescheduled timers, we can instead use a “generation” count. A generation count is just an arbitrary `Int` parameter, passed to the `DispatchSource.timer` on construction and when rescheduled. This value is then passed through to the handler when invoked. As before with the timer’s identity, we can verify the generation count but it has the added advantage that we can change the value on rescheduling, not just creation.

It’s very flexible and effective but it adds an additional layer of complexity at each point so the code size is almost *double* that of the original cancellable timer example:

    public extension DispatchSource {
       // Similar to before but we pass a user-supplied Int to the handler function
       public class func makeTimerSource(interval: DispatchTimeInterval, parameter: Int,
    		handler: (parameter: Int) -> Void) -> DispatchSourceTimer {
          let result = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
          result.scheduleOneshot(interval: interval, parameter: parameter, handler: handler)
          result.resume()
          return result
       }
    }
    
    public extension DispatchSourceTimer {
       // An overload of scheduleOneshot that updates the handler function with a new
       // user-supplied Int when it changes the expiry deadline
       public func scheduleOneshot(interval: DispatchTimeInterval, parameter: Int, handler:
          (parameter: Int) -> Void) {
          suspend()
          setEventHandler { handler(parameter: parameter) }
          scheduleOneshot(deadline: DispatchTime.now() + interval)
          resume()
       }
    }
    
    class Parent {
       let queue = DispatchQueue(label: "")
       var generation: Int = 0
       var temporaryChild: (child: Child, timer: DispatchSourceTimer)? = nil
       
       func createChild() {
          queue.sync {
             // Construct a new child
             let c = Child()
             
             // Increment the generation
             generation += 1
    
             // Schedule deletion
             let t = DispatchSource.makeTimerSource(interval: .seconds(10), parameter:
                generation) { [weak self] p in
                guard let s = self else { return }
                s.timerHandler(parameter: p)
             }
             
             // Tie the child and timer together
             temporaryChild = (c, t)
          }
       }
       
       func resetChildTimer() {
          queue.sync {
             guard temporaryChild == nil else { return }
             
             // Increment the generation
             generation += 1
             
             // Reschedule the timer
             self.temporaryChild?.timer.scheduleOneshot(interval: .seconds(10), parameter:
                generation) { [weak self] p in
                guard let s = self else { return }
                s.timerHandler(parameter: p)
             }
          }
       }
    
       // Since we're changing the handler each time, it helps to have a shared
       // function to create the handler
       func timerHandler(parameter: Int) {
          queue.sync {
             guard parameter == generation else { return }
             temporaryChild = nil
          }
       }
    }

## A single queue, synchronized timer

Our simple handler now contains a *lot* of code and a significant amount of this exists purely so we can ignore invalid results. When available a better option is to prevent invalid results from occurring at all by ensuring that the timer is scheduled on the same context used as a mutex around the timer and associated temporary resource.

A `DispatchSourceTimer` offers a way to do this by ensuring that the timer is scheduled on the same queue that we use as a mutex around our data. For this, let’s redo the `DispatchSource.timer` function *again*:

    public extension DispatchSource {
       // Similar to before but the scheduling queue is passed as a parameter
       public class func makeTimerSource(interval: DispatchTimeInterval, queue: DispatchQueue,
          handler: () -> Void) -> DispatchSourceTimer {
          // Use the specified queue
          let result = DispatchSource.makeTimerSource(queue: queue)
          result.setEventHandler(handler: handler)
          
          // Unlike previous example, no specialized scheduleOneshot required
          result.scheduleOneshot(deadline: DispatchTime.now() + interval)
          result.resume()
          return result
       }
    }

and the `Parent` class can now be dramatically simplified:

    class Parent {
       let queue = DispatchQueue(label: "")
       var temporaryChild: (child: Child, timer: DispatchSourceTimer)? = nil
       
       func createChild() {
          queue.sync {
             let t = DispatchSource.makeTimerSource(interval: .seconds(10), queue: queue) {
                [weak self] in
                self?.temporaryChild = nil
             }
             temporaryChild = (Child(), t)
          }
       }
    
       func resetChildTimer() {
          queue.sync {
             temporaryChild?.timer.scheduleOneshot(deadline: DispatchTime.now() + .seconds(10))
          }
       }
    }

It’s dramatically cleaner and simpler than the previous example, while equally thread safe.

This timer usage pattern isn’t *always* possible – in these cases, the previous “generation count” approach should be used instead. This includes cases where you might choose to use a different type of mutex around your data (possibly a faster mutex as I discussed in [Mutexes and closure capture in Swift](http://www.cocoawithlove.com/blog/2016/06/02/threads-and-mutexes.html)). In other APIs, it might not be possible to use a scheduling queue as a sychronous mutex (an example is `boost::asio` in C++ where the `io_service::strand` class used to serialize jobs can’t be invoked in a guaranteed synchronous manner).

## External requirements

The problem with both the “generation count” and the “single-queue synchronized” patterns for using a timer is that they both have external requirements.

What do I mean by an external requirement? I mean that these design patterns have requirements that are not part of any function parameter. Specifically, both require a mutex around the timer and mutations to its associated temporary resource or they risk falling out of synchronization.

Ideally, we would have an interface that avoids *any* external requirements or preconditions – if you fulfill the type requirements of the interface, then your usage of the interface is valid.

In narrow scenarios, this is possible. The most straightforward approach is to wrap the value, the timer *and* the mutex in a single interface that ensures the requirements are met. For example:

    public class TimeLimitedContainer<T> {
       var possibleValue: T?
       let timer: DispatchSourceTimer
       let queue: DispatchQueue
      
       public init(value: T, interval: DispatchTimeInterval) {
          self.possibleValue = nil
          self.queue = DispatchQueue(label: "")
          self.timer = DispatchSource.makeTimerSource(queue: queue)
          
          self.timer.setEventHandler(handler: { [weak self] in self?.possibleValue = nil })
          self.timer.scheduleOneshot(deadline: DispatchTime.now() + interval)
          self.timer.resume()
       }
       
       public var value: T? {
          var result: T? = nil
          queue.sync { result = possibleValue }
          return result
       }
    
       public func resetTimer(interval: DispatchTimeInterval) {
          queue.sync {
             timer.scheduleOneshot(deadline: DispatchTime.now() + interval)
          }
       }
    }

The problem with this is that it limits the actual action that can be performed at the end of the timer: in this case, all it does is sets an `Optional` to `nil`. In most cases, that’s simply not useful enough. Changes over time usually require a notification to be broadcast and possibly some kind of refresh or reprocessing operation so that other objects in memory can adjust to the new value. This change propagation might need to occur under the same mutex or under separate mutexes in a way that avoids deadlocks.

While you *could* make the `possibleValue` member an `OnDelete` struct (like I described in [Breaking Swift with reference counted structs](http://www.cocoawithlove.com/blog/2016/03/27/on-delete.html)) and then use the `OnDelete` handler to perform *any* kind of action when this occurs, this is just reverting back to behaving like a bare timer. You would have another arbitrary layer of abstraction around the underlying timer but the end result is a timer that triggers a simple handler when it fires.

To handle a series of cascading change propagations, moving in and out of locks while remaining thread safe would require sweeping changes throughout the whole program. In that scenario, there *are* ways to hide timers within the interface of the larger framework. How that’s done ends up being specific to the change propagation framework.

Without a thread safe change propagation framework, **the best option is simply to endure the external requirement on timer usage** since it allows you to perform change propagation from your `Parent` object as appropriate.

## Usage

> The “generation count” and “single queue synchronized” `DispatchSource.timer` implementations from this file are part of the [swift3-prerelease branch](https://github.com/mattgallagher/CwlUtils/tree/swift3-prerelease) of [mattgallagher/CwlUtils](https://github.com/mattgallagher/CwlUtils). This branch will be merged into master when Swift 3 becomes final.

There’s not a large amount of code in this article – my aim was to focus on the required patterns *around* the code. In any case, the [CwlDispatch.swift](https://github.com/mattgallagher/CwlUtils/blob/swift3-prerelease/CwlUtils/CwlDispatch.swift?ts=3) file is fully self-contained so you can copy just the file, if that’s all you need.

## Conclusion

There’s a popular design principle which states: [“You ain’t gonna need it”](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it), implying that you should focus solely on your current requirements and you shouldn’t worry about future problems if your code works in the present. There’s some value in the principle but when dealing with problems that are difficult to test, a different level of caution and future proofing is required.

Timers have a nasty tendency to *look* like they’re working but then break when barely related (or even *unrelated*) code changes slightly. Since automated testing tends to follow a narrow range of timing patterns, it may fail to uncover timing bugs and you can end up with serious issues in your program without any tests failing. It’s best to take a few simple steps to ensure your timers are safe under a range of usage modalities from the outset – even if you don’t think you need cancellation or rescheduling for your timers.

For every timer:

- Clearly identify the associated “temporary resource” for every timer and ensure changes to timer and resource occur under a common mutex.
- All timers should be cancellable and their lifetime should be limited to that of any associated temporary resources.
- Timer handler invocations from cancelled or rescheduled timers are impossible or have no effect.

You should obey these requirements even when you don’t think you need cancellation or rescheduling.

I showed two different ways that these requirements can be satisfied: a “generation count” pattern and a “single queue synchronized” pattern for timer usage.

The latter is the more syntactically efficient and involves the following steps:

1. Store the timer and its associated temporary resource together in a compound value.
2. Use a `DispatchQueue` as a mutex around the timer and its associated temporary resource
3. Schedule the timer on the same `DispatchQueue`

The alternative “generation count” pattern avoided the requirement on `DispatchQueue` as a mutex and avoided any constraint on the scheduled queue for the timer. However, it still requires *some* kind of mutex and adds the additional requirement of tracking the generation count. It also tends to be significantly more verbose.

Sadly, both patterns represent an ongoing nuisance since both have an external requirement on a mutex in the surrounding scope – something that is difficult to confirm with a `precondition` or other check.

Designing thread safe code involving timers in an asynchronous environment without *any* external requirements would require a more opinionated approach to change management throughout your program. This is definitely a topic I’ll revisit in the future.
