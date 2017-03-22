> * 原文地址：[A Quick Look at Semaphores in Swift 🚦](https://medium.com/swiftly-swift/a-quick-look-at-semaphores-6b7b85233ddb#.61uw6lq2d)
> * 原文作者：[Federico Zanetello](https://medium.com/@zntfdr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： 
> * 校对者：

---

# A Quick Look at Semaphores in Swift 🚦

First of all, if you’re not familiar with the Grand Central Dispatch (GCD) and Dispatch Queues, please head over [this awesome article](http://www.appcoda.com/grand-central-dispatch/) from [AppCoda](https://medium.com/@appcodamobile).

All right! Time to talk about Semaphores!

![](https://cdn-images-1.medium.com/max/1600/1*8ZCGzvA6DjfR9JoamqauoQ.jpeg)

### Introduction

Let’s imagine a group of *writers* that must share a single *pen*. 
Obviously only one *writer *can use the *pen* at any given time.

Now, imagine that those *writers* are our threads and that the *pen* is our *shared resource* (it can be anything: a file, a variable, the right to do something, etc).

How do we make sure that our *resource* is really [mutually exclusive](https://en.wikipedia.org/wiki/Mutual_exclusion)?

![](https://cdn-images-1.medium.com/max/1600/1*nfAYVSYFMB874-z4sfJ_YQ.jpeg)

### Implementing our own Resource Control Access

Someone may think: well I can just use a *resourceIsAvailable* *Bool* and set it to *true*/*false.*

```
if (resourceIsAvailable) {
  resourceIsAvailable = false
  useResource()
  resourceIsAvailable = true
} else {
  // resource is not available, wait or do something else
}
```

The problem is that, on concurrency, **there’s no guarantee of knowing which thread, among all, is going to execute the next step, regardless of their priority**.

#### Example

Imagine that we’ve implemented the code above and that we have two threads, *threadA* and *threadB*, that would like to use a mutual exclusive resource:

- *threadA* reads the if-condition and see that the resource is available, great!
- But, before the execution of the next line (*resourceIsAvalilable = false*), the processor turns to *threadB* and it also reads the if-condition.
- Now we have two threads that believe that the resource is available and both are going to execute the *use-the-resource* block.

Writing thread-safe code without GCD is not an easy task.

![](https://cdn-images-1.medium.com/max/1600/1*p54pBislRafckGffcDqRdA.png)

### How Semaphores Work

Three steps:

1. Whenever we would like to use one shared resource, we send a **request** to its semaphore;
2. Once the semaphore gives us the green light (see what I did here?) we can assume that the resource is ours and we can use it;
3. Once the resource is no longer necessary, we let the semaphore know by sending him a **signal**,allowing him to assign the resource to another thread.

When this resource is only one and can be used only by onethread at any given time, you can think of these **request/signal** as the resource **lock/unlock**.

![](https://cdn-images-1.medium.com/max/1600/1*-_owdkyNPRUQS5a5yjdEkA.jpeg)

### What’s Happening Behind the Scenes

#### The Structure

The Semaphore is composed by:

- a *counter* that let the Semaphore know how many threads can use its resource(s);
- a *FIFO queue* for tracking the threads waiting for the resource;

#### Resource Request: wait()

When the semaphore receives a request, it checks if its *counter* is above zero:

- if yes, then the semaphore decrements it and gives the thread the green light;
- otherwise it pushes the thread at the end of its queue;

#### Resource Release: signal()

Once the semaphore receives a signal, it checks if its FIFO queue has threads in it:

- if yes, then the semaphore pulls the first thread and give him the green light;
- otherwise it increments its counter;

#### Warning: Busy Waiting

When a thread sends a *wait() *resource request to the semaphore, the thread **freezes **until the semaphore gives the thread the green light.

⚠️️If you do this in the main thread, the whole app will freeze ⚠️️

![](https://cdn-images-1.medium.com/max/1600/1*3GANzX3n1uEiuhXE49fcrg.jpeg)

### Using Semaphores in Swift (with GCD)

Let’s write some code!

#### Declaration

Declaring a Semaphore is simple:

```
let semaphore = DispatchSemaphore(value: 1)
```

The *value* parameter is the number of threads that can access to the resource as for the semaphore creation.

#### Resource Request

To **request** the *semaphore*’s resource(s), we just call:

```
 semaphore.wait()
```

Note that the semaphore is not physically giving us anything, the resource has to be in the thread’s scope already, we just use the resource only between our request and release calls.

Once the semaphore gives us its blessing, the thread resumes its normal execution and can consider the resource his to use.

#### Resource Release

To **release** the resource we write:

```
semaphore.signal()
```

After sending this signal we aren’t allowed to touch the resource anymore, until we request for it again.

### Semaphore Playgrounds

Following [AppCoda](https://medium.com/@appcodamobile)[article](http://www.appcoda.com/grand-central-dispatch/) examples, let’s see this Semaphore in action!

> Warning: these are Xcode Playgrounds, as Swift Playgrounds don’t support Logging just yet. Fingers crossed for WWDC17!

In these playgrounds we have two threads, one with slightly higher priority than the other, that print 10 times an emoji and incremental numbers.

#### Semaphore-less Playground

```
import Foundation
import PlaygroundSupport

let higherPriority = DispatchQueue.global(qos: .userInitiated)
let lowerPriority = DispatchQueue.global(qos: .utility)

func asyncPrint(queue: DispatchQueue, symbol: String) {
  queue.async {
    for i in 0...10 {
      print(symbol, i)
    }
  }
}

asyncPrint(queue: higherPriority, symbol: "🔴")
asyncPrint(queue: lowerPriority, symbol: "🔵")

PlaygroundPage.current.needsIndefiniteExecution = true
```

As you can Imagine, the higher priority thread finishes first most of the times:

![](https://cdn-images-1.medium.com/max/1600/1*OjtJO8-44tStXpRS8y1N-A.png)

#### Semaphore Playground

In this case we will use the same code as before, but we will give the right to print the *emoji+number* sequence only to one thread at a time.

In order to do so we will define one semaphore and update our *asyncPrint* function:

```
import Foundation
import PlaygroundSupport

let higherPriority = DispatchQueue.global(qos: .userInitiated)
let lowerPriority = DispatchQueue.global(qos: .utility)

let semaphore = DispatchSemaphore(value: 1)

func asyncPrint(queue: DispatchQueue, symbol: String) {
  queue.async {
    print("\(symbol) waiting")
    semaphore.wait()  // requesting the resource
    
    for i in 0...10 {
      print(symbol, i)
    }
    
    print("\(symbol) signal")
    semaphore.signal() // releasing the resource
  }
}

asyncPrint(queue: higherPriority, symbol: "🔴")
asyncPrint(queue: lowerPriority, symbol: "🔵")

PlaygroundPage.current.needsIndefiniteExecution = true
```

I’ve also added a couple more *print* commands to see the actual state of each thread during our execution.

![](https://cdn-images-1.medium.com/max/1600/1*g7SMrR7svWNetOqjSGIEYA.png)

As you can see, when one thread starts printing the sequence, the other thread must wait until the first one ends, then the semaphore will receive the *signal* from the first thread and then, *only then*, the second thread can start printing its own sequence.

It doesn’t matter at which point of the sequence the second thread will send the *wait()* request, it will always have to wait until the other thread is done.

**Priority Inversion**

Now that we understand how everything works, please take a look at the following log:

![](https://cdn-images-1.medium.com/max/1600/1*eCFBl9XpF6JYX1b8xwD26w.png)

In this case, with the exact code above, the processor has decided to execute the low priority thread first.

When this happens, the high priority thread must wait the low priority thread to finish! This is ok, it can happen. 
The problem is that the low priority thread has low priority even when one high priority thread is waiting for him: this is called [***Priority Inversion***](https://en.wikipedia.org/wiki/Priority_inversion).

In other programming concepts different than the Semaphore, when this happens the low priority thread will temporarily *inherit* the priority of the highest priority thread that is waiting on him: this is called [***Priority Inheritance***](https://en.wikipedia.org/wiki/Priority_inheritance).

With Semaphores this is not the case because, actually, anybody can call the *signal()* function (not only the thread that is currently using the resource).

**Thread Starvation** 

To make things even worse, let’s imagine that between our high & low priority threads there are 1000 more middle-priority threads.

If we have a case of *Priority Inversion* like above, the high priority thread must wait for the low priority thread, but, most of the time, the processor will execute the middle priority threads, as they have higher priority than our low priority one.

In this scenario our high priority thread is being starved of CPU time (hence the concept of [Starvation](https://en.wikipedia.org/wiki/Starvation_%28computer_science%29)).

#### Solutions

In my opinion, it’s better to use Semaphores only among threads of the same priority. If this is not your case, I suggest you to look at other solutions such as [Regions](https://en.wikipedia.org/wiki/Critical_section) and [Monitors](https://en.wikipedia.org/wiki/Monitor_%28synchronization%29).

### Deadlock Playground

This time we have two threads that use two mutual exclusive resources “*A*” and “*B*”.

If the two resources can be used separately, it makes sense to define one semaphore for each resource. If not, one semaphore can manage both.

I want to make an example with the former case (2 resources, 2 semaphores) with a twist: the high priority thread will use first resource “A” and then “B”, while our low priority one will use first resource “B” and then “A”.

Here’s the code:

```
import Foundation
import PlaygroundSupport

let higherPriority = DispatchQueue.global(qos: .userInitiated)
let lowerPriority = DispatchQueue.global(qos: .utility)

let semaphoreA = DispatchSemaphore(value: 1)
let semaphoreB = DispatchSemaphore(value: 1)

func asyncPrint(queue: DispatchQueue, symbol: String, firstResource: String, firstSemaphore: DispatchSemaphore, secondResource: String, secondSemaphore: DispatchSemaphore) {
  func requestResource(_ resource: String, with semaphore: DispatchSemaphore) {
    print("\(symbol) waiting resource \(resource)")
    semaphore.wait()  // requesting the resource
  }
  
  queue.async {
    requestResource(firstResource, with: firstSemaphore)
    for i in 0...10 {
      if i == 5 {
        requestResource(secondResource, with: secondSemaphore)
      }
      print(symbol, i)
    }
    
    print("\(symbol) releasing resources")
    firstSemaphore.signal() // releasing first resource
    secondSemaphore.signal() // releasing second resource
  }
}

asyncPrint(queue: higherPriority, symbol: "🔴", firstResource: "A", firstSemaphore: semaphoreA, secondResource: "B", secondSemaphore: semaphoreB)
asyncPrint(queue: lowerPriority, symbol: "🔵", firstResource: "B", firstSemaphore: semaphoreB, secondResource: "A", secondSemaphore: semaphoreA)

PlaygroundPage.current.needsIndefiniteExecution = true
```

If we’re lucky, this is what happens:

![](https://cdn-images-1.medium.com/max/1600/1*_ASgiqbV_o9caE7M7hNBpQ.png)

Simply, the high priority thread will be served with the first resource, then the second and only later the the processor will move to the low priority thread.

However, if we’re unlucky, this can also happen:

![](https://cdn-images-1.medium.com/max/1600/1*cVvGM-1NRH7kouSRu2mSRQ.png)

Both threads didn’t finish their execution! Let’s review the current state:

- The high priority thread is waiting for the resource “B”, which is held by the low priority thread;
- The low priority thread is waiting for the resource “A”, which is held by the high priority thread;

Both threads are waiting on each other with no possibility to move forward: welcome to a [*Thread Deadlock*](https://en.wikipedia.org/wiki/Deadlock)!

#### Solutions

Avoiding [deadlocks](https://en.wikipedia.org/wiki/Deadlock) is not simple. The best solution would be preventing them by writing code that [can’t possibly reach this state](https://en.wikipedia.org/wiki/Deadlock_prevention_algorithms).

In other OSs, for example, one of the deadlock threads could be killed (in order to release all its resources) with the hope that other threads can continue their execution.

…Or you can just use the [Ostrich_Algorithm](https://en.wikipedia.org/wiki/Ostrich_algorithm) 😆.

![](https://cdn-images-1.medium.com/max/1600/1*Nmcb2GTIk-PO0TNPNPD8Mw.jpeg)

### Conclusions

Semaphores are a little nice concept that can be very handy in many applications. Just, be careful: look both ways before crossing.

---

[*Federico*](https://twitter.com/zntfdr) *is a Bangkok-based Software Engineer with a strong passion for Swift, Minimalism, Design, and iOS Development.*