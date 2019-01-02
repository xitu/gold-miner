>* 原文链接：[Design patterns for safe timer usage](http://www.cocoawithlove.com/blog/2016/07/30/timer-problems.html)
* 原文作者：[Matt Gallagher](http://www.cocoawithlove.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[mypchas6fans] (https://github.com/mypchas6fans)
* 校对者：[Graning] (https://github.com/Graning) [lizwangying] (https://github.com/lizwangying)

# 安全的计时器设计模式

本文版权所有者为 [Matt Gallagher](http://www.cocoawithlove.com)，原文链接在 [Design patterns for safe timer usage](http://www.cocoawithlove.com/blog/2016/07/30/timer-problems.html)。 译文的翻译和发表得到了原作者的许可。


计时器是一个非常难以正确使用的工具。

延迟调用和单次计时器使用非常简单，但它们有时会陷入无法维护的反模式，有时很容易在控制和 handler 上下文之间出现序列问题。

和我一起看看有关计时器的 bug 和潜在维护问题吧。

> **注意**：本文的代码会使用 Swift 3 版本的 Dispatch API 演示单次计时器。但许多共通原则适用于其他各种周期计时器和异步计时器 API。

## 计时器的目的

计时器的问题通常在写代码之前就开始了。

有一个概念上的问题：计时器的*接口*看起来是要让某个功能延迟一定时间。严格来说，延迟是它们所做的事情，但绝不是其*目的*所在。

单次计时器的目的是为某个临时资源执行生存期结束后的操作。比如 Session 计时器到期删除 Session，超时会关闭闲置的连接，UI 计时器会删除视图元素或重置视图状态，日历事件计时器把事件从待完成变为已完成。

有时，你会发现计时器*看起来*只是一段延时，没有底层的临时资源。最糟的情况是期望被延时的功能可能会在一些先决条件满足*之后*调用。期望独立的代码在一定时间内完成是最糟糕的[耦合](https://en.wikipedia.org/wiki/Coupling_(computer_programming))(并且几乎总是会忽略应该触发其执行的通知)。

反之，周期计时器不一定有这样清晰定义的目的。它可能不断更新同一个资源，可能每次创建或删除单个资源，也可能不依赖持续的资源，只是做一些短暂的工作。

但即使是这种仅仅为了延迟的情况，*延迟状态本身也是一个临时资源*。为了状态的组合、测试、调试，所有状态都应该由数据中的数值清晰表达，延迟状态当然也不例外。

我强调计时器的目的是因为它会带来如下的要求：

1. 一个计时器总是会与一个临时资源紧密联系。
2. 计时器或临时资源的变化必须引发另一方的变化（即使它们并不一定同步*发生*）

计时器的很多问题都是因为不能满足其中一个要求。

## 延迟调用

在 libdispatch 中，最简单的计时器就是 `DispatchQueue.after`。这就是一个“延迟调用”，仅仅推迟某个功能但不返回引用，所以没有可能取消。

一个基本的 `after` 调用看起来是这样的:

    DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(10)) {
      // 推迟的代码
    }

延迟调用有时候在调试过程中很有用，但它们**太容易出问题，不能放心的用到线上代码中去**。

我们看看延迟调用会引发问题的一个最直观场景：

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


当 `temporaryChild` 被创建的时候, 一个延迟调用预计会在 `10.0` 秒后删除它，但延迟调用和 `temporaryChild` 的生存期并不一致。

很容易看出哪里有问题: 执行 `createChild` 两次，第一个延迟调用将会删除第二个 `temporaryChild`.

鉴于引起维护问题的可能性，我认为 `after` 在线上代码中是不能使用的；你可以让代码工作，但程序容易挂掉。计时器直接作用域*之外*的微小变化就会打破它的行为。更糟的是，当计时器出问题时，它*看起来*还是正常的，可能会通过自动化测试，到了引发问题的那个时间点，程序就会崩溃。

**不要在调试以外的场合使用延迟调用。**

## 可取消计时器

可取消计时器并不比延迟调用难多少。

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

返回的 `DispatchSourceTimer` 如果被释放，会*自动*取消计时器，这样我们会有一个安全许多的设计。

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

计时器的生存期和它操作的资源的生存期绑到了一起，前面说的问题就解决了。

**但是这段代码中仍然有个严重的问题。**

## 忽略可取消计时器

前面的 `Parent` 例子中，对 `temporaryChild` 的访问都是用 `queue.sync` 作为互斥锁来保护的。但是，关于互斥锁的重要一点是:
**互斥锁本身是不能保证代码线程安全的。**

考虑下面的事件顺序:

1. 用 `createChild()` 创建一个 child
2. 10秒之后，`DispatchQueue.global()` 并发队列上的 handler 被调用
3. handler启动但还没有进入 `s.queue.sync`
4. 这时再次调用 `createChild()`，进入队列创建新的 child 和计时器，然后退出队列。
5. 第3步中的 handler，本应删除旧的 child，进入 `s.queue.sync` 之后却删掉了*新的* child。

旧的计时器删掉了新的 child。啊哦。

我们又回到了老问题，计时器没有和正确的 child 绑定. 任何情况下 handler 的控制和执行如果发生在互斥锁之外，就会使互斥锁的序列版本和计时器的序列版本不一致。
因为我们只关注*互斥锁的*序列版本，所以需要忽略那些不是最新应用到互斥锁上的计时器。具体就是改变计时器的构造方法，使 handler 接受参数，能够识别过时的计时器。

一种方式是把`计时器`自己的引用传递给 handler，这需要重写前面的 `DispatchSource.timer` 方法：

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

然后你就可以使用新的`计时器`构造方法:

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

我们的 handler 现在可以识别是否是“当前的”计时器，如果不是就退出。

## 有世代计数的计时器

上面的代码*差不多*可以用了，但是还有一种情况不能处理：*重设*了的计时器。

重设了的计时器是指我们需要延长计时器的到期时间。例如等待计时器（sleep 或者 timeout 计时器）。对于等待计时器，每个新的 activity 都会把它重置到完整的时长。

重设的问题在于，计时器的到期时间被更改了，但计时器的实例还是原来的。如果 handler 的执行当中计时器被重设了，handler 会按照旧的到期时间执行，因为计时器的标识没变。

为了忽略取消*和*重设的计时器，我们可以用一个“世代”计数。这个数只是一个 `Int` 参数，在构造和重设的时候传给 `DispatchSource.timer`，并在 handler 被调用的时候传递给它。
我们可以和验证计时器标识一样验证世代计数，但是好处是还可以在重设的时候改变计数值，而不只是创建的时候。

它非常灵活有效，但是在每个节点都加了一层复杂度， 所以代码量几乎是上面可取消计时器的*两倍*：

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

## 单队列同步计时器

我们的简单计时器现在有了*很多*代码，大部分都是为了过滤无效的结果。一个更好的选择是，保证计时器在同一个上下文中创建，由一把互斥锁围绕计时器和相关的临时资源，从根源上避免无效结果产生。

我们来*再次*重构一下 `DispatchSource.timer`：

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

`Parent` 类可以神奇的简化:

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

现在代码比原来简洁清晰很多，而且同样线程安全.

这样的计时器使用模式并不是*永远*可行的 - 在某些情况下，需要使用前面的“世代计数”方法。比如你选择使用不同的互斥锁(更快的互斥锁，比如我在之前文章中提到的[Mutexes and closure capture in Swift](http://www.cocoawithlove.com/blog/2016/06/02/threads-and-mutexes.html))。
在其他 API 中，还有可能无法用调度队列作为同步互斥锁（比如 C++ 中的 `boost::asio`，用于序列化的 `io_service::strand` 类不能以确保同步的方式调用）。

## 外部需求

“世代计数”和“单队列同步”的计时器还有个问题，就是它们都有外部需求。

什么是外部需求？我指的是它们都有非功能参数的需求，需要用互斥锁来围绕计时器和相关临时资源，不然就会有同步失败的风险。

理想情况下，我们应该有一个不需要*任何*外部需求和前置条件的接口 - 只要你实现了接口的类型需求，接口的使用就是有效的。

在某些具体场合，这是可以做到的。最直接的方式就是把数值，计时器*和*互斥锁包装到一个接口里。例如：

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

这种方式的问题是，它会限制计时器结束时可以执行的动作：这个例子中做的就是把 `Optional` 设为 `nil`。很多情况下这是不够用的。一段时间后的变化通常需要广播通知，执行刷新或者重新处理，这样内存中的其他对象可以调整到新的值。变化的传播需要在同一个互斥锁下发生，或者在避免死锁的前提下在多个互斥锁中发生。

虽然你*可以*把 `possibleValue` 成员做成一个 `OnDelete` 结构体(像我在这里描述的 [Breaking Swift with reference counted structs](http://www.cocoawithlove.com/blog/2016/03/27/on-delete.html))，然后用 `OnDelete` handler 来执行*任意*操作。但这像是回到了一个原始的计时器。
你应该对底层计时器有另一层抽象，最终使得计时器结束时触发一个简单的 handler。

要处理一系列的级联变化传播，在锁之间进出还要保证线程安全，需要扫描整个程序中的变化。在这种情况下，*可以*把计时器隐藏在大的框架接口之下。具体的实现要根据变化传播的框架。

如果没有线程安全的变化传播框架，**最好的方法就是上述的在使用计时器时保证外部需求**。这样可以使你正确的在 `Parent` 对象中处理变化传播。

## 使用

> “世代计数”和“单队列同步”版本的 `DispatchSource.timer` 实现是我的 CwlUtils 的一部分 [mattgallagher/CwlUtils](https://github.com/mattgallagher/CwlUtils). 现在在 Swift 3 prerelease 分支当中 [swift3-prerelease branch](https://github.com/mattgallagher/CwlUtils/tree/swift3-prerelease)，当 Swift 3 正式发布时会 merge 到 master。

文章中并没有放很多代码 – 我的重点是在代码*之间*的模式. 如果你需要，[CwlDispatch.swift](https://github.com/mattgallagher/CwlUtils/blob/swift3-prerelease/CwlUtils/CwlDispatch.swift?ts=3) 是一个完整自包含的代码文件。

## 总结

有一个著名的设计准则： [“你不需要它”](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it), 指的是你应该只关注当前的需求，只要现在的代码可以工作，就别担心将来的问题. 这话有一定的道理，但是如果要处理难以测试的问题，多加小心，未雨绸缪总是必要的。

计时器有一个讨厌的倾向，看起来工作正常，但是不太相关（甚至*毫不相干*）的代码稍微变化，就会出问题了。由于自动化测试通常只会用一些固定的时间模式，可能时间相关的 bug 不会被发现，任何测试都通过了，但结果程序中有严重的问题。最好能有一些简单的步骤，从一开始就保证计时器在不同的使用模式下工作正常，哪怕你不需要取消或者重设计时器。

对每一个计时器:

- 对每个计时器清晰的定义相关的“临时资源”，保证计时器和资源的变化在同一个互斥锁下面发生。
- 所有计时器都应该可以取消，它们的生存期应该和相关的临时资源一致。
- 计时器取消或重设触发的 handler 调用应该不可行或者没有效果。

你应该遵守这些需求，即使你不需要取消或者重设计时器。

我演示了满足上面条件的两种不同方法：“世代计数”和“单队列同步”模式的计数器使用。

后者语法上更简单，包括下面的步骤:

1. 把计时器和相关临时资源存放到一个复合值中。
2. 使用 `DispatchQueue` 作为互斥锁围绕计时器和相关临时资源。
3. 在同一个 `DispatchQueue` 中启动计时器。

“世代计数”模式避免了对 `DispatchQueue` 作为互斥锁的要求，也不需要限制计时器的启动队列。但是它仍然需要*互斥锁*，并且还需要跟踪世代计数。并且这个方法更加复杂。

不幸的是，两者都有一样的烦恼：对作用域上互斥锁的要求 - 并且难以通过`前置条件`或其他方式确认。

想在异步环境中设计线程安全的计时器代码，还想*不借助*外部依赖的话，需要在整个程序的变化管理中加入更多个人的想法。我很想将来继续研究这个问题。
