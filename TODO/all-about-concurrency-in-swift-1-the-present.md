> * 原文地址：[All about Concurrency in Swift - Part 1: The Present](https://www.uraimo.com/2017/05/07/all-about-concurrency-in-swift-1-the-present/)
> * 原文作者：[Umberto Raimondi](https://www.uraimo.com/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[Deepmissea](http://deepmissea.blue)
> * 校对者：[Feximin](https://github.com/Feximin)，[zhangqippp](https://github.com/zhangqippp)

# Swift 中关于并发的一切：第一部分 — 当前

在 Swift 语言的当前版本中，并没有像其他现代语言如 Go 或 Rust 一样，包含任何原生的并发功能。

如果你计划异步执行任务，并且需要处理由此产生的竞争条件时，你唯一的选择就是使用外部库，比如 libDispatch，或者 Foundation 和 OS 提供的同步原语。

在本系列教程的第一部分，我们会介绍 Swift 3 提供的功能，涵盖一切，从基础锁、线程和计时器，到语言守护和最近改善的 GCD 和操作队列。

我们也会介绍一些基础的并发概念和一些常见的并发模式。

![klingon 示例代码中的关键部分](https://www.uraimo.com/imgs/concurr.png)

即使 pthread 库的函数和原语可以在任一个运行 Swift 的平台上使用，我们也不会在这里讨论，因为对于每个平台，都有更高级的方案。

NSTimer 类也不会在这里介绍，你可以看一看[这里](/swiftbites/nstimer-in-swift-3/)，来了解如何在 Swift 3 中使用它。

就像已多次公布的，Swift 4.0 之后的主要版本之一（不一定是 Swift 5）会扩展语言的功能，更好地定义内存模型，并包含了新的原生并发功能，可以不需要借助外部库来处理并发，实现并行化，定义了一种 Swift 方式来实现并发。

这是本系列下一篇文章讨论的内容，我们会讨论一些其他语言实现的替代方法和范式实现，和在 Swift 中他们是如何实现的。并且我们会分析一些用当前版本 Swift 完成的开源实现，这些实现中我们可以使用 Actor 范式，Go 的 CSP 通道，软件事务内存等特性。

第二篇文章将会完全是推测性的，它主要的目的是为你介绍这些主题，以便你以后可以参与到更热烈讨论当中，而这些讨论将会定义未来 Swift 版本的并发是怎么处理的。

#### **本文或其他文章的 playground 可以在 [GitHub](https://github.com/uraimo/Swift-Playgrounds) 或 [Zipped](/archives/2017-05-07-ConcurrencyInSwift.playground.zip) 找到。** ####

### 目录 ###

- [多线程与并发入门](#多线程与并发入门)
- [语言守护](#语言守护)
- [线程](#线程)
- [同步原语](#同步原语)
	- [NSLock](#nslock)
	- [NSRecursiveLock](#nsrecursivelock)
	- [NSConditionLock](#nsconditionlock)
	- [NSCondition](#nscondition)
	- [NSDistributedLock](#nsdistributedlock)
	- [OSAtomic 你在哪里？](#osatomic-你在哪里)
	- [同步块](#同步块)

- [GCD: 大中枢派发](#gcd-大中枢派发)
	- [调度队列](#调度队列)
	- [使用队列](#使用队列)
	- [屏障](#屏障)
	- [单例和 Dispatch_once](#单例和-dispatch_once)
	- [Dispatch Groups](#dispatch-groups)
	- [Dispatch Work Items](#dispatch-work-items)
	- [Dispatch Semaphores](#dispatch-semaphores)
	- [Dispatch Assertions](#dispatch-assertions)
	- [Dispatch Sources](#dispatch-sources)
	
- [操作与可操作的队列](#操作与可操作的队列)
- [闭幕后的思考](#闭幕后的思考)

## 多线程与并发入门 ##

现在，无论你构建的是哪一种应用，你迟早会考虑应用在多线程环境运行的情况。

具有多个处理器或者多核处理器的计算平台已经存在了几十年，而像 **thread** 和 **process** 这样的概念甚至更久。

操作系统已经通过各种方式开放了这些能力给用户的程序，每个现代的框架或者应用都会实现一些涉及多线程的广为人知的设计模式，来提高程序的性能与灵活性。

在我们开始钻研如何处理 Swift 并发的细节之前，让我先简要地解释几个你需要知道的概念，然后再开始考虑你是使用 
**Dispatch Queues** 还是 **Operation Queues**。

首先，你可能会问，虽然 Apple 的平台和框架使用了线程，但是我为什么要在自己的应用中引入它们呢？

有一些常见的情况，让多线程的使用合情合理：

- **任务组分离**: 线程能从执行流程的角度，模块化你的程序。不同的线程用可预测方式，执行一组相同的任务，把他们与你程序的其他执行流程部分隔离，这样你会更容易理解程序当前的状态。

- **独立数据的计算并行化**: 可以使用由硬件线程支持的多个软件线程（可以参考下一条），来并行化在原始输入数据结构的子集上运行的相同任务的多个副本。

- **等待条件达成或 I/O 的一种简洁的实现方式**: 在执行 I/O 阻塞或其他类型的阻塞操作时，可以使用后台线程来干净地等待这些操作完成。使用线程可以改进你程序的整体设计，并且使处理阻塞问题变成细枝末节的事情。

但是，当多个线程执行你应用的代码时，一些从单线程的角度看起来无意义的假设就变得非常重要了。

在每个线程都独立地执行且没有数据共享的完美情况下，并发编程实际上并不比编写单线程执行的代码复杂多少。但是，就像经常发生的那样，你打算用多个线程操作同一数据，那就需要一种方式来规划对这些数据结构的访问，以确保该数据上的每个操作都按预期完成，而不会与其他线程有任何的交互操作。

并发编程需要来自语言和操作系统的额外保证，需要明确地说明在多个线程同时访问变量（或更一般的称之为“资源”）并尝试修改他们的值时，他们的状态是如何变化的。

语言需要定义一个**内存模型**，一组规则明确地列出在并发线程的运行下一些基本语句的行为，并且定义如何共享内存以及哪种内存访问是有效的。

多亏了这个（内存模型)，用户有了一个线程运行行为可预知的语言，并且我们知道编译器将仅对遵循内存模型中定义的内容进行优化。

定义内存模型是语言进化的一个精妙的步骤，因为太严格的模型可能会限制编译器的自身发展。对于内存模型的过去策略，新的巧妙的优化会变得无效。

定义内存模型的例子：

- 语言中哪些语句可以被认为是**原子性**的，哪些不是，哪些操作只能作为一个整体执行，其它线程看不到中间结果。比如必须知道变量是否被原子地初始化。

- 如何处理变量在线程之间的共享，他们是否被默认缓存，以及他们是否会对被特定语言修饰符修饰的缓存行为产生影响。

- 例如，用于标记和规划访问**关键部分**（那些操作共享资源的代码块）的并发操作符一次只允许一个线程访问一个特定的代码路径。

现在让我们回头聊聊在你程序中并发的使用。

为了正确处理并发问题，你要标识程序中的**关键部分**，然后用并发原语或并发化的数据结构来规划数据在不同线程之间的共享。

对代码或数据结构这些部分的强制访问规则打开了另一组问题，这些源于事实的问题就是，虽然期望的结果是每个线程都能够被执行，并有机会修改共享数据，但是在某些情况下，其中一些可能根本无法执行，或者数据可能以意想不到的和不可预测的方式改变。

你将面临一系列额外的挑战，并且必须处理一些常见的问题：

- **竞争条件**: 同一数据上多个线程的操作，例如并发地读写，一系列操作的执行结果可能会变得无法预测，并且依赖于线程的执行顺序。

- **资源争夺**: 多个线程执行不同的任务，在尝试获取相同资源的时候，会增加安全获取所需资源的时间。获取这些资源延误的这些时间可能会导致意想不到的行为，或者可能需要你构建程序来规划对这些资源的访问。

- **死锁**: 多线程之间互相等待对方释放他们需要的资源/锁，这组线程将永远的被阻塞。

- **（线程）饥饿**: 一个永远无法获取资源，或者一组有特定的顺序资源的线程，由于各种原因，它需要不断尝试去获取他们却永远失败。

- **优先级反转**: 具有低优先级的线程持续获取高优先级线程所需的资源，实质地反转了系统指定的优先级。

- **非决定论与公平性**: 我们无法对线程获取资源的时间和顺序做出臆断，这个延迟[无法事前确定](https://en.wikipedia.org/wiki/Unbounded_nondeterminism)，而且它严重的受到线程间争夺的影响，线程甚至从不能获得一个资源。但是用于守护关键部分的并发原语也可以用来构建**公平（fair）**或者支持**公平（fairness）**，确保所有等待的线程都能够访问关键部分，并且遵守请求顺序。

## 语言守护 ##

即使在 Swift 语言本身没有并发性相关功能的时期，它仍然提供了一些有关如何访问属性的保证。

例如全局变量的初始化是原子性地，我们从不需要手动处理多个线程初始化同一个全局变量的并发情况，或者担心初始化还在进行的过程中看到一个只初始化了一部分的变量。

在下次讨论单例的实现时，我们会继续讨论这个特性。

但要记住的重要一点是，延迟属性的初始化并不是原子执行的，现在版本的语言并没有提供注释或修饰符来改变这一行为。

类属性的访问也不是原子的，如果你需要访问，那你不得不实现手动独占式的访问，使用锁或类似的机制。

## 线程 ##

Foundation 提供了 Thread 类，内部基于 pthread，可以用来创建新的线程并执行闭包。

线程可以使用 Thread 类中的 `detachNewThreadSelector:toTarget:withObject:` 函数来创建，或者我们可以创建一个新的线程，声明一个自定义的 Thread 类，然后覆盖 `main()` 函数：

```
classMyThread : Thread {
    override func main(){
        print("Thread started, sleep for 2 seconds...")
        sleep(2)
        print("Done sleeping, exiting thread")
    }
}

```

但是自从 iOS 10 和 macOS Sierra 推出以后，所有平台终于可以使用初始化指定执行闭包的方式创建线程，本文中所有的例子仍会扩展基础的 Thread 类，这样你就不用担心为操作系统而做尝试了。

```

var t = Thread {
    print("Started!")
}

t.stackSize = 1024 * 16
t.start()               //Time needed to spawn a thread around 100us
```

一旦我们有了一个线程实例，我们需要手动的启动它。作为一个可选步骤，我们也可以为线程定义栈的大小。

线程可以通过调用 `exit()` 来紧急停止，但是我们从不推荐这么做，因为它不会给你机会来干净利落地终止当前任务，如果你有需要，多数情况下你会选择自己实现终止逻辑，或者只需要使用 `cancel()` 函数，然后检查在主闭包中的 `isCancelled` 属性，以明确线程是否需要在它自然结束之前终止当前的工作。

## 同步原语 ##

当我们有多个线程想要修改共享数据时，就很有必要通过一些方式来处理这些线程之间的同步，防止数据破损和非确定性行为。

通常，用于同步线程的基本套路是锁、信号量和监视器。


这些 Foundation 都提供了。

正如你要看到的，在 Swift 3 中，这些[没有去掉 NS 前缀](https://github.com/apple/swift-evolution/blob/master/proposals/0086-drop-foundation-ns.md#proposed-solution)的类（对，他们都是引用类型）实现了这些结构，但是在 Swift 接下来的某个版本中也许会去掉。

### NSLock ###

NSLock 是 Foundation 提供的基本类型的锁。

当一个线程尝试锁定一个对象时，可能会发生两件事，如果锁没有被前面的线程获取，那么当前线程将得到锁并执行，否则线程将会陷入等待，阻塞执行，直到锁的持有者解锁它。换句话说，在同一时间，锁是一种只能被一个线程获取（锁定）的对象，这可以让他们完美的监控对关键部分的访问。

NSLock 和 Foundation 的其他锁都是**不公平的**，意思是，当一系列线程在等待获取一个锁时，他们**不会**按照他们原来的锁定顺序来获取它。

你无法预估执行顺序。在线程争夺的情况下，当多个线程尝试获取资源时，有的线程可能会陷入**饥饿**，他们永远也不会获得他们等待的锁（或者不能及时的获得）。

没有竞争地获取锁所需要的时间，测量在 100 纳秒以内。但是在多个线程尝试获取锁定的资源时，这个时间会急速增长。所以，从性能的角度来讲，锁并不是处理资源分配的最佳方案。

让我们来看一个例子，例中有两个线程，记住由于锁会被谁获取的顺序无法确定，T1 连续获取两次锁的机会也会发生（但是不怎么常见）。

```

let lock = NSLock()

class LThread : Thread {
    varid:Int = 0
    
    convenience init(id:Int){
        self.init()
        self.id = id
    }
    
    override func main(){
        lock.lock()
        print(String(id)+" acquired lock.")
        lock.unlock()
        iflock.try() {
            print(String(id)+" acquired lock again.")
            lock.unlock()
        }else{  // If already lockedmove along.
            print(String(id)+" couldn't acquire lock.")
        }
        print(String(id)+" exiting.")
    }
}

var t1 = LThread(id:1)
var t2 = LThread(id:2)
t1.start()
t2.start()

```

在你决定使用锁之前，容我多说一句。由于你迟早会调试并发问题，要把锁的使用，限制在某种数据结构的范围内，而不是在代码库中的多个地方直接使用。

在调试并发问题的同时，检查有少量入口的同步数据结构的状态，比跟踪某个部分的代码处于锁定，并且还要记住多个功能的本地状态的方式更好。这会让你的代码走的更远并让你的并发结构更优雅。

### NSRecursiveLock ###

递归锁能被已经持有锁的线程多次获取，在递归函数或者多次调用检查相同锁的函数时很有用处。不适用于基本的 NSLock。

```
let rlock = NSRecursiveLock()

classRThread : Thread {
    
    override func main(){
        rlock.lock()
        print("Thread acquired lock")
        callMe()
        rlock.unlock()
        print("Exiting main")
    }
    
    func callMe(){
        rlock.lock()
        print("Thread acquired lock")
        rlock.unlock()
        print("Exiting callMe")
    }
}

var tr = RThread()
tr.start()

```

### NSConditionLock ###

条件锁提供了可以独立于彼此的附加锁，用来支持更加复杂的锁定设置（比如生产者-消费者的场景）。

一个全局锁（无论特定条件如何都锁定）也是可用的，并且行为和经典的 NSLock 相似。

让我们看一个保护共享整数锁的简单的例子，每次生产者更新而消费者打印都会在屏幕上显示。

```
let NO_DATA = 1
let GOT_DATA = 2

let clock = NSConditionLock(condition: NO_DATA)
var SharedInt = 0

classProducerThread : Thread {
    
    override func main(){
        for i in 0..<5 {
            clock.lock(whenCondition: NO_DATA) //Acquire the lock when NO_DATA//If we don't have to wait for consumers we could have just done clock.lock()
            SharedInt = i
            clock.unlock(withCondition: GOT_DATA) //Unlock and set as GOT_DATA
        }
    }
}

classConsumerThread : Thread {
    
    override func main(){
        for i in0..<5 {
            clock.lock(whenCondition: GOT_DATA) //Acquire the lock when GOT_DATA
            print(i)
            clock.unlock(withCondition: NO_DATA) //Unlock and set as NO_DATA
        }
    }
}

let pt = ProducerThread()
let ct = ConsumerThread()
ct.start()
pt.start()

```

当创建锁的时候，我们需要指定一个由整数代表的初始条件。

`lock(whenCondition:)` 函数在条件符合时会获得锁，或者等待另一个线程用 `unlock(withCondition:)` 设置值来释放锁定。

对比基本锁的一个小改进是，我们可以对更复杂的场景进行稍微建模。

### NSCondition ###

不要与条件锁产生混淆，一个条件提供了一种干净的方式来等待**条件**的发生。

当获取了锁的线程验证它需要的附加条件（一些资源，处于特定状态的另一个对象等等）不能满足时，它需要一种方式被搁置，一旦满足条件再继续它的工作。

这可以通过连续性或周期性地检查这种条件（繁忙等待）来实现，但是这么做，线程持有的锁会发生什么？在我们等待的时候是保持还是释放他们以至于在条件符合时重新获取他们？

条件提供了一个干净的方式来解决这个问题，一旦获取一个线程，就把它放进关于这个条件的一个**等待**列表中，它会在另一个线程**发信号**时，表示条件满足，而被唤醒。

让我们看个例子：

```
let cond = NSCondition()
var available = false
var SharedString = ""
classWriterThread : Thread {
    
    override func main(){
        for _ in0..<5 {
            cond.lock()
            SharedString = "😅"
            available = true
            cond.signal() // Notify and wake up the waiting thread/s
            cond.unlock()
        }
    }
}

classPrinterThread : Thread {
    
    override func main(){
        for _ in0..<5 { //Just do it 5 times
            cond.lock()
            while(!available){   //Protect from spurious signals
                cond.wait()
            }
            print(SharedString)
            SharedString = ""
            available = false
            cond.unlock()
        }
    }
}

let writet = WriterThread()
let printt = PrinterThread()
printt.start()
writet.start()

```

### NSDistributedLock ###

分布式锁与之前我们所看到的截然不同，我不期望你经常需要它们。

它们由多个应用程序共享，并由文件系统上的条目（如简单文件）支持。很明显这个文件系统能被所有想要获取他（分布式锁）的应用访问。

这种锁需要使用 `try()` 函数，一个非阻塞方法，它立即返回一个布尔值，指出是否获取锁。获取锁通常需要多次的手动执行，并在连续尝试之间适当延迟。

分布式锁通常使用 `unlock()` 方法释放。

让我们看一个基本的例子：

```
var dlock = NSDistributedLock(path: "/tmp/MYAPP.lock")

iflet dlock = dlock {
    var acquired = falsewhile(!acquired){
        print("Trying to acquire the lock...")
        usleep(1000)
        acquired = dlock.try()
    }

    // Do something...

    dlock.unlock()
}

```

### OSAtomic 你在哪里? ###

像 [OSAtomic](https://www.mikeash.com/pyblog/friday-qa-2011-03-04-a-tour-of-osatomic.html) 提供的原子操作是简单的，并且允许设置、获取或比较变量，而不需要经典的锁逻辑，因为他们利用 CPU 的特定功能（有时是原生原子指令），并提供了比前面锁所描述的更优越的性能。

对于建立并发数据结构来讲，他们是非常有用的，因为处理并发所需的开销被降低到最低。

OSAtomic 在 macOS 10.12 已经被舍弃使用，而在 Linux 上从来都不可以使用，但是一些开源的的项目，比如[这个](https://github.com/glessard/swift-atomics)提供了实用的 Swift 扩展，或者[这个](https://github.com/bignerdranch/AtomicSwift)提供了类似的功能。

### 同步块 ###

在 Swift 中你不能像在 Objective-C 中一样，创建一个 @synchronized 块，因为没有等效的关键字可用。

在 Darwin 上，通过一些代码，你可以直接使用 `objc_sync_enter(OBJ)` 和 `objc_sync_exit(OBJ)` 来弄出类似的东西，以进入现有的 @objc 对象监视器，就像 @synchronized 在底层所做的一样，但这并不值得，如果你想要他们更灵活的话，最好是简单地使用一个锁。

就如我们将要描述调度队列时看到的，用队列，我们甚至可以使用更少的代码来执行同步调用来复制这个功能：

```
var count: Int {
    queue.sync {self.count}
}

```

#### **本文或其他文章的 playground 可以在 [GitHub](https://github.com/uraimo/Swift-Playgrounds) 或 [Zipped](/archives/2017-05-07-ConcurrencyInSwift.playground.zip) 找到。** ####

## GCD: 大中枢派发 ##

对于不熟悉这个 API 的人来说，GCD 是一种基于队列的 API，允许在工作池上执行闭包。

换句话说，包含需要执行的工作的闭包能被添加到一个队列中，队列会依赖于配置选项，顺序或并行的用一系列线程来执行他们。但是无论队列是什么类型的，工作始终会按照**先进先出**的顺序启动，这意味着工作会始终遵循插入顺序启动。完成顺序将依赖于每项工作的持续时间。

这是一种常见的模式，几乎可以从每个处理并发的相对现代的语言运行时系统中找到。线程池的方式比一系列空闲和无关的线程更易于管理、检查和控制。

GCD 的 API 在 Swift 3 中有一些小改动，[SE-0088](https://github.com/apple/swift-evolution/blob/master/proposals/0088-libdispatch-for-swift3.md) 模块化了它的设计，让它看上去更面向对象了。

### 调度队列 ###

GCD 允许创建自定义的队列，但是也提供了一些可以访问的预定义系统队列。

要创建一个顺序执行你的闭包的基本串行队列，你只需要提供一个字符串标签来标识它，通常建议使用反向域名前缀，在堆栈追踪的时候就能简单地跟踪队列的所有者。

```
let serialQueue = DispatchQueue(label: "com.uraimo.Serial1")  //attributes: .serial

let concurrentQueue = DispatchQueue(label: "com.uraimo.Concurrent1", attributes: .concurrent)

```

我们创建的第二个队列是并发的，意味着在执行工作时，队列会使用底层线程池中的所有可用线程。这种情况下，执行顺序是无法预测的，不要以为你的闭包完成的顺序与插入顺序有任何关系。

可以从 `DispatchQueue` 对象获得默认队列：

```
let mainQueue = DispatchQueue.main

let globalDefault = DispatchQueue.global()

```

**main** 队列是 iOS 和 macOS 上处理图形应用**主事件循环**的顺序主队列，用于响应事件和更新用户界面。就如我们知道的，每个对用户界面的改动都会在这个队列执行，且这个线程中任何一个耗时操作都会使用户界面的渲染变得不及时。

运行时系统也提供了对其他不同优先级全局队列的访问，可以通过 **Quality of Service (Qos)** 参数来查看他们的标识。

不同优先级声明在 `DispatchQoS` 类里，优先级从高到低：

- .userInteractive
- .userInitiated
- .default
- .utility
- .background
- .unspecified

重要的是要注意，移动设备提供了低电量模式，在电池较低时，[后台队列会挂起](https://mjtsai.com/blog/2017/04/03/beware-default-qos/)。

要取得一个特定的默认全局队列，使用 `global(qos:)` 根据想要的优先级来获取：

```
let backgroundQueue = DispatchQueue.global(qos: .background)

```

在创建自定义队列时，也可以选择使用与其他属性相同的优先说明符：

```
let serialQueueHighPriority = DispatchQueue(label: "com.uraimo.SerialH", qos: .userInteractive)

```

### 使用队列 ###

包含任务的闭包可以以两种方式提交给队列：**同步**和**异步**，分别使用 `sync` 和 `async` 方法。

在使用前者时，`sync` 会被阻塞，换句话说，当它闭包完成（在你需要等待闭包完成时很有用，但是有更好的途径）时调用的 `sync` 方法才会完成，而后者会把闭包添加到队列，然后允许程序继续执行。

让我们看一个简单的例子：

```

globalDefault.async {
    print("Async on MainQ, first?")
}

globalDefault.sync {
    print("Sync in MainQ, second?")
}

```

多个调度可以嵌套，例如在后台完成一些东西、低优先、需要我们更新用户界面的操作。

```

DispatchQueue.global(qos: .background).async {
    // Some background work here

    DispatchQueue.main.async {
        // It's time to update the UI
        print("UI updated on main queue")
    }
}

```

闭包也可以在一个特定的延迟之后执行，Swift 3 最终以一种更舒适的方式指定这个时间间隔，那就是使用 `DispatchTimeInterval` 工具枚举，它允许使用这四个时间单位组成间隔：`.seconds(Int)`、`.milliseconds(Int)`、`.microseconds(Int)` 和 `.nanoseconds(Int)`。

要安排一个闭包在将来执行，使用 `asyncAfter(deadline:execute:)` 方法，并传递一个时间：

```
globalDefault.asyncAfter(deadline: .now() + .seconds(5)) {
    print("After 5 seconds")
}

```

如果你需要多次并发执行相同的闭包（就像你以前用 **dispatch_apply** 一样），你可以使用 `concurrentPerform(iterations:execute:)` 方法，但请注意，**如果在当前队列的上下文中可能的话**，这些闭包会并发执行，所以记得，始终应该在支持并发的队列中同步或异步地调用此方法。

```

globalDefault.sync {  
    DispatchQueue.concurrentPerform(iterations: 5) {
        print("\($0) times")
    }
}

```

虽然队列在通常情况下，创建好就会准备执行它的闭包，但是它也可以配置为按需启动。

```
let inactiveQueue = DispatchQueue(label: "com.uraimo.inactiveQueue", attributes: [.concurrent, .initiallyInactive])
inactiveQueue.async {
    print("Done!")
}

print("Not yet...")
inactiveQueue.activate()
print("Gone!")

```

这是我们第一次需要制定多个属性，但就如你所见，如果需要，你可以用一个数组添加多个属性。

也可以使用继承自 `DispatchObject` 的方法暂停或恢复执行的工作：

```
inactiveQueue.suspend()

inactiveQueue.resume()

```

仅用于配置非活动队列（在活动的队列中使用会造成崩溃）优先级的方法 `setTarget(queue:)` 也是可用的。调用此方法的结果是将队列的优先级设置为与给定参数的队列相同的优先级。

### 屏障 ###

让我们假设你添加了一组闭包到特定的队列（执行闭包的持续时间不同），但是现在你想只有当所有之前的异步任务完成时再执行一个工作，你可以使用屏障来做这样的事情。

让我们添加五个任务（会睡眠 1 到 5 秒的时间）到我们前面创建的并发队列中，一旦其他工作完成，就利用屏障来打印一些东西，我们在最后 **async** 的调用中规定一个 `DispatchWorkItemFlags.barrier` 标志来做这件事。

```

globalDefault.sync { 
    DispatchQueue.concurrentPerform(iterations: 5) { (id:Int) in
        sleep(UInt32(id)+1)
        print("Async on globalDefault, 5 times: "+String(id))
    }
}   

globalDefault.async (flags: .barrier) {
    print("All 5 concurrent tasks completed")
}

```

### 单例和 Dispatch_once ###

就如你所知的一样，在 Swift 3 中并没有与 `dispatch_once` 等效的函数，它多数用来构建线程安全的单例。

幸运地，Swift 保证了全局变量的初始化是原子性地，如果你认为常量在初始化后，他们的值不能发生改变，这两个属性使全局常量成为实现单例的更容易的选择。

```

final classSingleton {

    public static let sharedInstance: Singleton = Singleton()

    privateinit() { }

    ...
}

```

我们将类声明为 `final` 以拒绝它子类化的能力，我们把它的指定构造器设为私有，这样就不能手动创建它对象的实例。公共静态变量是进入单例的唯一入口，它会用于获取单例、共享实例。

相同的行为可以用于定义只执行一次的代码块：

```
func runMe() {
    struct Inner {
        static let i: () = {
            print("Once!")
        }()
    }
    Inner.i
}

runMe()
runMe() // Constant already initialized
runMe() // Constant already initialized
```

虽然不太好看，但是它的确可以正常工作，而且如果只是**执行一次**，它也是可以接受的实现。

但是如果我们需要完全的复制 `dispatch_once` 的功能，我们就需要从头实现它，就如[同步块](#on-synchronized-blocks)中描述的一样，利用一个扩展：

```

import Foundation

public extension DispatchQueue {
    
    private static var onceTokens = [Int]()
    private static var internalQueue = DispatchQueue(label: "dispatchqueue.once")
    
    public class func once(token: Int, closure: (Void)->Void) {
        internalQueue.sync {
            if onceTokens.contains(token) {
                return
            }else{
                onceTokens.append(token)
            }
            closure()
        }
    }
}

let t = 1
DispatchQueue.once(token: t) {
    print("only once!")
}
DispatchQueue.once(token: t) {
    print("Two times!?")
}
DispatchQueue.once(token: t) {
    print("Three times!!?")
}

```

和预期一致，三个闭包中，只有第一个会被实际执行。

或者，可以使用 `objc_sync_enter` 和 `objc_sync_exit` 来构建性能稍微好一点的东西，如果他们在你的平台上可用的话：

```

import Foundation

public extension DispatchQueue {
    
    privatestatic var _onceTokens = [Int]()
    
    publicclass func once(token: Int, closure: (Void)->Void) {
        objc_sync_enter(self);
        defer { objc_sync_exit(self) }
        
        if _onceTokens.contains(token) {
            return
        }else{
            _onceTokens.append(token)
        }
        closure()
    }
}

```

### Dispatch Groups ###

如果你有多个任务，虽然把他们添加到不同的队列，也希望等待他们的任务完成，你可以把他们分到一个派发组中。

让我们看一个例子，任务直接被添加到一个特定的组，用 **sync** 或 **async** 调用：

```
let mygroup = DispatchGroup()

for i in0..<5 {
    globalDefault.async(group: mygroup){
        sleep(UInt32(i))
        print("Group async on globalDefault:"+String(i))
    }
}

```

任务在 `globalDefault` 上执行，但是我们可以注册一个 `mygroup` 完成的处理程序，我们可以选择在所有这些被完成后，执行这个队列中的闭包。`wait()` 方法可以用于执行一个阻塞等待。

```
print("Waitingforcompletion...")
mygroup.notify(queue: globalDefault) {
    print("Notify received, done waiting.")
}
mygroup.wait()
print("Done waiting.")

```

另一种追踪队列任务的方式是，在队列执行调用的时候，手动的进入和离开一个组，而不是直接指定它：

```

for i in 0..<5 {
    mygroup.enter()
    sleep(UInt32(i))
    print("Group sync on MAINQ:"+String(i))
    mygroup.leave()
}

```

### Dispatch Work Items ###

闭包不是指定作业需要由队列执行的唯一方法，有时你可能需要一个能够跟踪其执行状态的容器类型，为此，我们就有 `DispatchWorkItem`。每个接受闭包的方法都有一个工作项的变型。

工作项封装一个由队列的线程池调用 `perform()` 方法执行的闭包：

```
let workItem = DispatchWorkItem {
    print("Done!")
}

workItem.perform()

```

WorkItems 也提供其他很有用的方法，比如 `notify`，与组一样，允许在一个指定的队列完成时执行一个闭包

```
workItem.notify(queue: DispatchQueue.main) {
    print("Notify on Main Queue!")
}

defaultQueue.async(execute: workItem)

```

我们也可以等到闭包已经被执行或者在队列尝试执行它之前，使用 `cancel()` 方法（在闭包执行之间**不会**取消执行）把它标记为移除。

```
print("Waiting for work item...")
workItem.wait()
print("Done waiting.")

workItem.cancel()

```

但是，重要的是要知道，`wait()` 不仅仅会阻塞当前线程的完成，也会**提升**队列中所有前面的工作项目的优先级，以便于尽快的完成这个特定的项目。

### Dispatch Semaphores ###

Dispatch Semaphores 是一种由多个线程获取的锁，它依赖于计数器的当前值。

线程在信号量上 `wait`，直到那个每当信号量被获取时值都减小的计数器的值为 0

用于访问信号量，释放等待线程的插槽名为 `signal`，它可以让计数器的计数增加。

让我们看一个简单的例子：

```

let sem = DispatchSemaphore(value: 2)

// The semaphore will be held by groups of two pool threads
globalDefault.sync {
    DispatchQueue.concurrentPerform(iterations: 10) { (id:Int) in
        sem.wait(timeout: DispatchTime.distantFuture)
        sleep(1)
        print(String(id)+" acquired semaphore.")
        sem.signal()
    }
}

```

### Dispatch Assertions ###

Swift 3 介绍了一种新的函数来执行当前上下文的断言，可以校验闭包是否在期望的队列上执行。我们可以使用 `DispatchPredicate` 的三个枚举来构建谓词：`.onQueue`，用来校验在特定的队列，`.notOnQueue`，来校验相反的情况，以及 `.onQueueAsBarrier`，来校验是否当前的闭包或工作项是队列上的一个障碍。

```
dispatchPrecondition(condition: .notOnQueue(mainQueue))
dispatchPrecondition(condition: .onQueue(queue))

```

#### **本文或其他文章的 playground 可以在 [GitHub](https://github.com/uraimo/Swift-Playgrounds) 或 [Zipped](/archives/2017-05-07-ConcurrencyInSwift.playground.zip) 找到。** ####

### Dispatch Sources ###

Dispatch Sources 是处理系统级别异步事件（比如内核信号或系统，文件套接字相关事件）的一种便捷方式。

有几种可用的调度源，分组如下：

- **Timer Dispatch Sources:** **用于在特定时间点或周期性事件中生成事件 (DispatchSourceTimer)。**
- **Signal Dispatch Sources:** **用于处理 UNIX 信号 (DispatchSourceSignal)。**
- **Memory Dispatch Sources:** **用于注册与内存使用状态相关的通知 (DispatchSourceMemoryPressure)。**
- **Descriptor Dispatch Sources:** **用于注册与文件和套接字相关的不同事件 (DispatchSourceFileSystemObject, DispatchSourceRead, DispatchSourceWrite)。**
- **Process dispatch sources:** **用于监视与执行状态有关的某些事件的外部进程 (DispatchSourceProcess)。**
- **Mach related dispatch sources:** **用于处理与Mach内核的 [IPC 设备](http://fdiv.net/2011/01/14/machportt-inter-process-communication)有关的事件 (DispatchSourceMachReceive, DispatchSourceMachSend)。**

如果有需要，你也可以构建你自己的调度源。所有调度源都符合 `DispatchSourceProtocol` 协议，它定义了注册处理程序所需的基本操作，并修改了调度源的激活状态。

让我们通过一个 `DispatchSourceTimer` 相关的例子，来理解如何使用这些对象。

源是由 `DispatchSource` 提供的工具方法创建的，在这我们会使用 `makeTimerSource`，指定我们想要执行处理程序的调度队列。

Timer Sources 没有其他的参数，所以我们只需要指定队列，创建源，就如我们所见，能够处理多个事件的调度源通常需要你指定要处理的事件的标识符。

```

let t = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
t.setEventHandler{ print("!") }
t.scheduleOneshot(deadline: .now() + .seconds(5), leeway: .nanoseconds(0))
t.activate()

```

一旦源被创建，我们就会使用 `setEventHandler(closure:)` 注册一个事件处理程序，如果不需要其他配置，就可以通过 `activate()` 让源可用。

调度源初始化不具备活性，意味着如果没有进一步的配置，他们不会开始传递事件。一旦我们准备就绪，源就能通过 `activate()` 激活，如果有需要，可以通过 `suspend()` 和 `resume()` 来暂时挂起和恢复事件传递。

Timer Sources 需要一个额外的步骤来配置对象需要传递的是哪一种类型的定时事件。在上面的例子中，我们定义了单一的事件，会在注册后 5 秒严格执行。

我们也可以配置对象来传递周期性事件，就像我们使用 [Timer](/swiftbites/nstimer-in-swift-3/) 对象那样：

```
t.scheduleRepeating(deadline: .now(), interval: .seconds(5), leeway: .seconds(1))

```

当我们完成了调度源的使用，并想要完全停止事件的传递时，我们可以调用 `cancel()`，它会停止事件源，调用消除相关的处理程序（如果我们已经设置了一个处理一些结束后的清理操作，比如注销）。

```
t.cancel()

```

对于其他类型的调度源来说 API 都是相似的，让我们看一个关于 [Kitura](https://github.com/IBM-Swift/Kitura-net/blob/master/Sources/KituraNet/IncomingSocketHandler.swift#L96) 初始化读取源的例子，它用于在已建立的套接字上进行异步读取：

```

readerSource = DispatchSource.makeReadSource(fileDescriptor: socket.socketfd,
                                             queue: socketReaderQueue(fd: socket.socketfd))

readerSource.setEventHandler() {
    _ = self.handleRead()
}
readerSource.setCancelHandler(handler: self.handleCancel)
readerSource.resume()

```

当套接字的数据缓冲区有新的字节可以传入的时候，`handleRead()` 方法会被调用。Kitura 也使用 **WriteSource** 执行缓冲写入，使用调度源事件[有效地调整写入速度](https://github.com/IBM-Swift/Kitura-net/blob/master/Sources/KituraNet/IncomingSocketHandler.swift#L328)，一旦套接字通道准备好发送就写入新的字节。在执行 I/O 操作的时候，对比于 Unix 平台上的其他低阶 API，读/写源是一个很好的高阶替代。

与文件相关的调度源的主题，另一个在某些情况中可能有用的是 `DispatchSourceFileSystemObject`，它允许监听特定文件的更改，从其名称到其属性。通过此调度源，在文件被修改或删除时，你也会收到通知。Linux 上的事件子集实质上都是由 **inotify** 内核子系统管理的。

剩余类型的源操作大同小异，你可以从 [libDispatch 的文档](https://developer.apple.com/reference/dispatch/dispatchsource)中查看完整的列表，但是记住他们其中的一些，比如 Mach 源和内存压力源只会在 Darwin 的平台工作。

## 操作与可操作的队列 ##

我们简要的介绍一下 Operation Queues，以及建立在 GCD 之上的附加 API。它们使用并发队列和模型任务作为操作，这样做可以轻松的取消操作，而且能让他们的执行依赖于其他操作的完成。

操作能定义一个执行顺序的优先级，被添加到 `OperationQueues`里异步执行。

我们看一个基础的例子：

```

var queue = OperationQueue()
queue.name = "My Custom Queue"queue.maxConcurrentOperationCount = 2

var mainqueue = OperationQueue.main //Refers to the queue of the main threadqueue.addOperation{
    print("Op1")
}
queue.addOperation{
    print("Op2")
}

```

我们也可以创建一个**阻塞操作**对象，然后在加入队列之前配置它，如有需要，我们也可以向这种操作添加多个闭包。

要注意的是，在 Swift 中不允许 `NSInvocationOperation` 使用目标+选择器创建操作。

```
var op3 = BlockOperation(block: {
    print("Op3")
})
op3.queuePriority = .veryHigh
op3.completionBlock = {
    if op3.isCancelled {
        print("Someone cancelled me.")
    }
    print("Completed Op3")
}

var op4 = BlockOperation {
    print("Op4 always after Op3")
    OperationQueue.main.addOperation{
        print("I'm on main queue!")
    }
}

```

操作可以有主次优先级，一旦主优先级完成，次优先级才会执行。

我们可以从 `op4` 添加一个依赖关系到 `op3`，这样 `op4` 会等待 `op3` 的完成再执行。

```

op4.addDependency(op3)

queue.addOperation(op4)  // op3 will complete before op4, alwaysqueue.addOperation(op3)

```

依赖也可以通过 `removeDependency(operation:)` 移除，被存储到一个公共可访问的 `dependencies` 数组里。

当前操作的状态可以通过特定的属性查看：

```

op3.isReady       //Ready for execution?
op3.isExecuting   //Executing now?
op3.isFinished    //Finished naturally or cancelled?
op3.isCancelled    //Manually cancelled?
```

你可以调用 `cancelAllOperations` 方法，取消队列中所有的当前操作，这个方法会设置队列中剩余操作的 `isCancelled` 属性。一个单独的操作可以通过调用它的 `cancel` 方法来取消：

```
queue.cancelAllOperations() 

op3.cancel()

```

如果在计划运行队列之后取消操作，建议您检查操作中的 `isCancelled` 属性，跳过执行。

最后要说是，你也可以停止操作队列上执行新的操作（正在执行的操作不会受到影响）：

```
queue.isSuspended = true
```

#### **本文或其他文章的 playground 可以在 [GitHub](https://github.com/uraimo/Swift-Playgrounds) 或 [Zipped](/archives/2017-05-07-ConcurrencyInSwift.playground.zip) 找到。** ####

## 闭幕后的思考 ##

本文可以说是从 Swift 可用的外部并发框架的视角，给出一个很好的总结。

第二部分将重点介绍下一步可能在语言中出现的处理并发的“原生”功能，而不需要借助外部库。通过目前的一些开源实现来讲述几个有意思的范例。

我希望这两篇文章能够对并发世界做一个很好的介绍，并且将帮助你了解和参与在急速发展的邮件列表中的讨论，在社区开始考虑将要介绍的内容时，我们一起期待 Swift 5 的到来。

关于并发和 Swift 的更多有趣内容，请看 [Cocoa With Love](https://www.cocoawithlove.com/tags/asynchrony.html) 的博客。

你喜欢这篇文章吗？让我[在推特](https://www.twitter.com/uraimo)上看到你！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
