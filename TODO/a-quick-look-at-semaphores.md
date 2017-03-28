> * 原文地址：[A Quick Look at Semaphores in Swift 🚦](https://medium.com/swiftly-swift/a-quick-look-at-semaphores-6b7b85233ddb#.61uw6lq2d)
> * 原文作者：[Federico Zanetello](https://medium.com/@zntfdr)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Deepmissea](http://deepmissea.blue)
> * 校对者：[Gocy015](http://blog.gocy.tech)，[skyar2009](https://github.com/skyar2009)

---

# 看！Swift 里竟然有红绿灯 🚦！

首先，如果你对 GCD 和 Dispatch Queue 不熟悉，请看看 [AppCoda](https://medium.com/@appcodamobile) 的[这篇文章](http://www.appcoda.com/grand-central-dispatch/)。

好了！是时候来聊聊信号量了！

![](https://cdn-images-1.medium.com/max/1600/1*8ZCGzvA6DjfR9JoamqauoQ.jpeg)

### 引言

让我们想象一下，一群**作家**只能共同使用一支**笔**。显然，在任何指定的时间里，只有一名**作家**可以使用**笔**。

现在，把**作家**想象成我们的线程，把**笔**想象成我们的**共享资源**（可以是任何东西：一个文件、一个变量、做某事的权利等等）。

怎么才能确保我们的**资源**是真正[互斥](https://en.wikipedia.org/wiki/Mutual_exclusion)的呢？

![](https://cdn-images-1.medium.com/max/1600/1*nfAYVSYFMB874-z4sfJ_YQ.jpeg)

### 实现我们自己的资源控制访问

有人可能会想：我只要用一个 **Bool** 类型的 **resourceIsAvailable** 变量，然后设置它为 **true** 或者 **false** 就可以互斥了。

```
if (resourceIsAvailable) {
  resourceIsAvailable = false
  useResource()
  resourceIsAvailable = true
} else {
  // resource is not available, wait or do something else
}
```

问题是出现在并发上，**不论线程之间的优先级如何，我们都没办法确切知道哪个线程会执行下一步。**

#### 例子

假设我们实现了上面的代码，我们有两个线程，**threadA** 和 **threadB**，他们会使用一个互斥的资源：

- **threadA** 读取到 if 条件语句，发现资源可用，很棒！
- 但是，在执行下一行代码（**resourceIsAvalilable = false**）之前，处理器切换到 **threadB**，然后它也读取了 if 条件语句。
- 现在我们的两个线程都确信资源是可用的，然后他们都会执行**使用资源**部分的代码块。


不用 GCD 编写线程安全的代码可不是一个容易的任务。

![](https://cdn-images-1.medium.com/max/1600/1*p54pBislRafckGffcDqRdA.png)

### 信号量是如何工作的

三步：

1. 在我们需要使用一个共享资源的时候，我们发送一个 **request** 给它的信号量；
2. 一旦信号量给出我们绿灯（see what I did here?），我们就可以假定资源是我们的并使用它；
3. 一旦不需要资源了，我们通过发送给信号量一个 **signal** 让它知道，然后它可以把资源分配给另一个的线程。

当这个资源只有一个，并且在任何给定的时间里，只有一个线程可以使用，你就可以把这些 **request/signal** 作为资源的 **lock/unlock**。

![](https://cdn-images-1.medium.com/max/1600/1*-_owdkyNPRUQS5a5yjdEkA.jpeg)

### 在幕后发生了什么

#### 结构

信号量由下面的两部分组成：

- 一个**计数器**，让信号量知道有多少个线程能使用它的资源；
- 一个 **FIFO 队列**，用来追踪这些等待资源的线程；

#### 请求资源: wait()

当信号量收到一个请求时，它会检查它的**计数器**是否大于零：

- 如果是，那信号量会减一，然后给线程放绿灯；
- 如果不是，它会把线程添加到它队列的末尾；

#### 释放资源: signal()

一旦信号量收到一个信号，它会检查它的 FIFO 队列是否有线程存在：

- 如果有，那么信号量会把第一个线程拉出来，然后给他一个绿灯；
- 如果没有，那么它会增加它的计数器；

#### 警告: 忙碌等待

当一个线程发送一个 **wait()** 资源请求给信号量时，线程会**冻结**直到信号量给线程绿灯。

⚠️️如果你在在主线程这么做，那整个应用都会冻结⚠️️

![](https://cdn-images-1.medium.com/max/1600/1*3GANzX3n1uEiuhXE49fcrg.jpeg)

### 在 Swift 里使用信号量 (通过 GCD)

让我们写一些代码！

#### 声明

声明一个信号量很简单：

```
let semaphore = DispatchSemaphore(value: 1)
```

**value** 参数代表创建的信号量允许同时访问该资源的线程数量。

#### 资源请求

如果要**请求信号量**的资源，我们只需：

```
 semaphore.wait()
```

要知道信号量并不能实质上地给我们任何东西，资源都是在线程的范围内，而我们只是在请求和释放调用之间使用资源。

一旦信号量给我们放行，那线程就会恢复正常执行，并可以放心地将资源纳为己用了。

#### 资源释放

要**释放**资源，我们这么写：

```
semaphore.signal()
```

在发送这个信号后，我们就不能接触到任何资源了，直到我们再次的请求它。

### Playgrounds 中的信号量

跟随 [AppCoda](https://medium.com/@appcodamobile) 上[这篇文章](http://www.appcoda.com/grand-central-dispatch/)的例子，让我们看看实际应用中的信号量！

> 注意：这些是 Xcode 中的 Playground，Swift Playground 还不支持日志记录。希望 WWDC17 能解决这个问题！

在这些 playground 里，我们有两个线程，一个线程的优先级比其他的略微高一些，打印 10 次表情和增加的数字。

#### 没有信号量的 Playground

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

和你想的一样，多数情况下，高优先级的线程先完成任务：

![](https://cdn-images-1.medium.com/max/1600/1*OjtJO8-44tStXpRS8y1N-A.png)

#### 有信号量的 Playground

这次我们会使用和前面一样的代码，但是在同一时间，我们只给一个线程赋予打印**表情+数字**的权利。

为了达到这个目的，我们定义了一个信号量并且更新了我们的 **asyncPrint** 函数：

```
import Foundation
import PlaygroundSupport

let higherPriority = DispatchQueue.global(qos: .userInitiated)
let lowerPriority = DispatchQueue.global(qos: .utility)

let semaphore = DispatchSemaphore(value: 1)

func asyncPrint(queue: DispatchQueue, symbol: String) {
  queue.async {
    print("\(symbol) waiting")
    semaphore.wait()  // 请求资源
    
    for i in 0...10 {
      print(symbol, i)
    }
    
    print("\(symbol) signal")
    semaphore.signal() // 释放资源
  }
}

asyncPrint(queue: higherPriority, symbol: "🔴")
asyncPrint(queue: lowerPriority, symbol: "🔵")

PlaygroundPage.current.needsIndefiniteExecution = true
```

我还添加了一些 **print** 指令，以便我们看到每个线程执行中的实际状态。

![](https://cdn-images-1.medium.com/max/1600/1*g7SMrR7svWNetOqjSGIEYA.png)

就像你看到的，当一个线程开始打印队列，另一个线程必须等待，直到第一个结束，然后信号量会从第一个线程收到 **signal**。**当且仅当此后**，第二个线程才能开始打印它的队列。

第二个线程在队列的哪个点发送 **wait()** 无关紧要，它会一直处于等待状态直到另一个线程结束。

**优先级反转**

现在我们已经明白每个步骤是如何工作的，请看一下这个日志：

![](https://cdn-images-1.medium.com/max/1600/1*eCFBl9XpF6JYX1b8xwD26w.png)

在这种情况下，通过上面的代码，处理器决定先执行低优先级的线程。

这时，高优先级的线程必须等待低优先级的线程完成！这是真的，它的确会发生。
问题是即使一个高优先级线程正等待它，低优先级的线程也是低优先级的：这被称为[***优先级反转***](https://en.wikipedia.org/wiki/Priority_inversion)。

在不同于信号量的其他编程概念里，当发生这种情况时，低优先级的线程会暂时**继承**等待它的最高优先级线程的优先级，这被称为：[***优先级继承***](https://en.wikipedia.org/wiki/Priority_inheritance)。

在使用信号量的时候不是这样的，实际上，谁都可以调用 **signal()** 函数（不仅是当前正使用资源的线程）。

**线程饥饿** 

为了让事情变得更糟，让我们假设在我们的高优先级和低优先级线程之间还有 1000 多个中优先级的线程。

如果我们有一种像上面那样**优先级反转**的情况，高优先级的线程必须等待低优先级的线程，但是，大多数情况下，处理器会执行中优先级的线程，因为他们的优先级高于我们的低优先级线程。

这种情况下，我们的高优先级线程正被 CPU 饿的要死（于是有了[饥饿](https://en.wikipedia.org/wiki/Starvation_%28computer_science%29)的概念）。

#### 解决方案

我的观点是，在使用信号量的时候，线程之间最好都使用相同的优先级。如果这不符合你的情况，我建议你看看其他的解决方案，比如[临界区块](https://en.wikipedia.org/wiki/Critical_section)和[管程](https://en.wikipedia.org/wiki/Monitor_%28synchronization%29).

### Playground 上的死锁

现在我们有两个线程，使用两个互斥的资源，“**A**” 和 “**B**”。

如果两个资源可以分离使用，为每个资源定义一个信号量是有意义的，如果不可以，那一个信号量足以管理两者。

我想用一个用前一种情况（2 个资源， 2 个信号量）做一个例子：高优先级线程会先使用资源 “A”，然后 “B”，而低优先级的线程会先使用 “B”，然后再使用 "A"。

代码在这：

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

如果我们幸运的话，会这样:

![](https://cdn-images-1.medium.com/max/1600/1*_ASgiqbV_o9caE7M7hNBpQ.png)

简单来说就是，第一个资源会先提供给高优先级线程，然后对于第二个资源，处理器只有稍后把它移动到低优先级线程。

然而，如果我们不是很幸运的话，那这种情况也会发生：

![](https://cdn-images-1.medium.com/max/1600/1*cVvGM-1NRH7kouSRu2mSRQ.png)

两个线程都没有完成他们的执行！让我们检查一下当前的状态：

- 高优先级的线程正在等待资源 “B”，可是被低优先级的线程持有；
- 低优先级的线程正在等待资源 “A”，可是被高优先级的线程持有；

两个线程都在等待相互的资源，谁也不能向前一步：欢迎来到[**线程死锁**](https://en.wikipedia.org/wiki/Deadlock)!

#### 解决方案

避免[死锁](https://en.wikipedia.org/wiki/Deadlock)很难。最好的解决方案是编写[不能达到这种状态](https://en.wikipedia.org/wiki/Deadlock_prevention_algorithms)的代码来防止他们。

例如，在其他的操作系统里，为了其他线程的继续执行，其中一个死锁线程可能被杀死（为了释放它的所有资源）。

...或者你可以使用[鸵鸟算法（Ostrich_Algorithm）](https://en.wikipedia.org/wiki/Ostrich_algorithm) 😆。

![](https://cdn-images-1.medium.com/max/1600/1*Nmcb2GTIk-PO0TNPNPD8Mw.jpeg)

### 结论

信号量是一个很棒的概念，它可以在很多应用里方便的使用，只是要小心：过马路要看两边。

---

**[Federico](https://twitter.com/zntfdr) 是一名在曼谷的软件工程师，对 Swift、Minimalism、Design 和 iOS 开发有浓厚的热情。**
