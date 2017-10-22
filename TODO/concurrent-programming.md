
> * 原文地址：[Concurrent programming](https://www.nada.kth.se/~snilsson/concurrency/#Parallel)
> * 原文作者：[StefanNilsson](https://plus.google.com/+StefanNilsson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/concurrent-programming.md](https://github.com/xitu/gold-miner/blob/master/TODO/concurrent-programming.md)
> * 译者：[kobehaha](http://github.com/kobehaha)
> * 校对者：[joyking7](http://github.com/joyking7) [alfred-zhong](http://github.com/alfred-zhong)

# 并发编程

[![bouncing balls](https://www.nada.kth.se/~snilsson/concurrency/bouncing-balls.jpg)](http://www.flickr.com/photos/un_photo/5853737946/) 

* [1. 多线程执行](#Thread)
* [2. Channels](#Chan)
* [3. 同步](#Sync)
* [4. 死锁](#Dead)
* [5. 数据竞争](#Race)
* [6. 互斥锁](#Lock)
* [7. 检测数据竞争](#Race2)
* [8. Select标识符](#Select)
* [9. 最基本的并发实例](#Match)
* [10. 并行计算](#Parallel)

这篇文章将会以[Go](https://golang.org)语言举例介绍并发编程,包括以下内容

* 线程的并发执行(goroutines)
* 基本的同步技术(channel和锁)
* Go中的基本并发模式
* 死锁和数据竞争
* 并行计算

开始之前，你需要去了解怎样写最基本的 Go 程序。 如果你已经对 C/C++，Java 或者Python比较熟悉，[A tour of go](https://tour.golang.org/)将会给你一些帮助。你也可以看一下[Go for C++ programmers](https://code.google.com/p/go-wiki/wiki/GoForCPPProgrammers) 或者[Go for Java programmers](http://www.nada.kth.se/~snilsson/go_for_java_programmers/)。

## 1.多线程执行

[goroutine](https://golang.org/ref/spec#Go_statements) 是 go 的一种调度机制。 Go 使用 go 进行声明，以 goroutine 调度机制开启一个新的执行线程。它会在新创建的 goroutine 执行程序。在单个程序中，所有goroutines都是共享相同的地址空间。


相比于分配栈空间，goroutine 更加轻量，花销更小。栈空间初始化很小,需要通过申请和释放堆空间来扩展内存。Goroutines 内部是被复用在多个操作系统线程上。如果一个goroutine阻塞了一个操作系统线程，比如正在等待输入，此时，这个线程中的其他 goroutine 为了保证继续运行，将会迁移到其他线程中，而你不需要去关心这些细节。

下面的程序将会打印 `"Hello from main goroutine"`. 是否打印`"Hello from another goroutine"`，取决于两个goroutines谁先完成.

```
func main() {

    go fmt.Println("Hello from another goroutine")
    fmt.Println("Hello from main goroutine")

    // 程序执行到这,所有活着的goroutines都会被杀掉

}
```

[goroutine1.go](https://www.nada.kth.se/~snilsson/concurrency/src/goroutine1.go)

下一段程序 `"Hello from main goroutine"` 和 `"Hello from another goroutine"` 可能会以任何顺序打印。但有一种可能性是第二个goroutine运行的非常慢，以至于到程序结束之前都不会打印。

```
func main() {
    go fmt.Println("Hello from another goroutine")
    fmt.Println("Hello from main goroutine")

    time.Sleep(time.Second) // 为其他goroutine完成等1秒钟
}
```

[goroutine2.go](https://www.nada.kth.se/~snilsson/concurrency/src/goroutine2.go)

这有一个更实际的例子，我们定义一个使用并发来推迟事件的函数。

```
// 在指定时间过期后，文本会被打印到标准输出
// 这无论如何都不会被阻塞
func Publish(text string, delay time.Duration) {
    go func() {
        time.Sleep(delay)
        fmt.Println("BREAKING NEWS:", text)
    }() // 注意括号。我们必须调用匿名函数
}
```

[publish1.go](https://www.nada.kth.se/~snilsson/concurrency/src/publish1.go)

你可能用下面的方式调用 `Publish` 函数

```
func main() {
    Publish("A goroutine starts a new thread of execution.", 5*time.Second)
    fmt.Println("Let’s hope the news will published before I leave.")

    // 等待消息被发布
    time.Sleep(10 * time.Second)

    fmt.Println("Ten seconds later: I’m leaving now.")
}
```

[publish1.go](https://www.nada.kth.se/~snilsson/concurrency/src/publish1.go)

该程序很有可能按以下顺序打印三行，每行输出会间隔五秒钟。

```
$ go run publish1.go
Let’s hope the news will published before I leave.
BREAKING NEWS: A goroutine starts a new thread of execution.
Ten seconds later: I’m leaving now.
```

一般来说，我们不可能让线程休眠去等待对方。在下一节中, 我们将会介绍 Go 的一种同步机制, __channels__ 。然后演示如何使用channel来让一个 goruntine 等待另外的 goruntine。

## 2. Channels

[![Sushi conveyor belt](https://www.nada.kth.se/~snilsson/concurrency/sushi-conveyor-belt.jpg)](http://www.flickr.com/photos/erikjaeger/35008017/) 

寿司输送带

[channel](https://golang.org/ref/spec#Channel_types) 是一种 Go 语言结构,它通过传递特定元素类型的值来为两个 goroutines 提供同步执行和交流数据的机制
。 `<-` 标识符表示了channel的传输方向，接收或者发送。如果没有指定方向。那么 channel 就是双向的。


```
chan Sushi      // 能被用于接收和发送 Sushi 类型的值
chan<- float64  // 只能被用于发送 float64 类型的值
<-chan int      // 只能被用于接收 int 类型的值
```

Channels 是一种被 make 分配的引用类型

```
ic := make(chan int)        // 不带缓存的  int channel
wc := make(chan *Work, 10)  // 带缓冲工作的 channel
```

通过 channel 发送值，可使用 <- 作为二元运算符。通过 channel 接收值，可使用它作为一元运算符。

```
ic <- 3       // 向channel中发送3
work := <-wc  // 从channel中接收指针到work
```

如果 channel 是无缓冲的，发送者会一直阻塞直到有接收者从中接收值。如果是带缓冲的，只有当值被拷贝到缓冲区且缓冲区已满时，发送者才会阻塞直到有接收者从中接收。接收者会一直阻塞直到 channel 中有值可被接收。

### 关闭

[`close`](https://golang.org/ref/spec#Close) 的作用是保证不能再向 channel 中发送值。 channel 被关闭后，仍然是可以从中接收值的。接收操作会获得零值而不会阻塞。多值接收操作会额外返回一个布尔值，表示该值是否被发送的。

```
ch := make(chan string)
go func() {
    ch <- "Hello!"
    close(ch)
}()
fmt.Println(<-ch)  // 打印 "Hello!"
fmt.Println(<-ch)  // 不阻塞的打印空值 ""
fmt.Println(<-ch)  // 再一次打印 ""
v, ok := <-ch      // v 的值是 "" , ok 的值是 false
```

伴有 range 分句的 for 语句会连续读取通过 channel 发送的值，直到 channel 被关闭

```
func main() {
    var ch <-chan Sushi = Producer()
    for s := range ch {
        fmt.Println("Consumed", s)
    }
}

func Producer() <-chan Sushi {
    ch := make(chan Sushi)
    go func() {
        ch <- Sushi("海老握り")  // Ebi nigiri
        ch <- Sushi("鮪とろ握り") // Toro nigiri
        close(ch)
    }()
    return ch
}
```

[sushi.go](https://www.nada.kth.se/~snilsson/concurrency/src/sushi.go)

## 3.同步

下一个例子中，`Publish` 函数返回一个channel，它会把发送的文本当做消息广播出去。

```
// 指定时间过期后函数Publish将会打印文本到标准输出.
// 当文本被发布channel将会被关闭.
func Publish(text string, delay time.Duration) (wait <-chan struct{}) {
    ch := make(chan struct{})
    go func() {
        time.Sleep(delay)
        fmt.Println("BREAKING NEWS:", text)
        close(ch) // broadcast – a closed channel sends a zero value forever
    }()
    return ch
}
```

[publish2.go](https://www.nada.kth.se/~snilsson/concurrency/src/publish2.go)

注意我们使用一个空结构的 channel : `struct{}`。 这表明该 channel 仅仅用于信号，而不是传递数据。

你可能会这样使用该函数

```
func main() {
    wait := Publish("Channels let goroutines communicate.", 5*time.Second)
    fmt.Println("Waiting for the news...")
    <-wait
    fmt.Println("The news is out, time to leave.")
}
```

[publish2.go](https://www.nada.kth.se/~snilsson/concurrency/src/publish2.go)

程序将按给出的顺序打印下列三行信息。在信息发送后，最后一行会立刻出现

```
$ go run publish2.go
Waiting for the news...
BREAKING NEWS: Channels let goroutines communicate.
The news is out, time to leave.
```

## 4.死锁

[![traffic jam](https://www.nada.kth.se/~snilsson/concurrency/traffic-jam.jpg)](http://www.flickr.com/photos/lasgalletas/263909727/)

让我们去介绍 `Publish` 函数中的一个bug。

```
func Publish(text string, delay time.Duration) (wait <-chan struct{}) {
    ch := make(chan struct{})
    go func() {
        time.Sleep(delay)
        fmt.Println("BREAKING NEWS:", text)
        **//close(ch)**
    }()
    return ch
}
```

这时由 `Publish` 函数开启的 goroutine 打印重要信息然后退出，留下主 goroutine 继续等待。

```
func main() {
    wait := Publish("Channels let goroutines communicate.", 5*time.Second)
    fmt.Println("Waiting for the news...")
    **<-wait**
    fmt.Println("The news is out, time to leave.")
}
```

在某些情况下，程序将不会有任何进展，这种情况被称为死锁。

>_deadlock_ 是线程之间相互等待而都不能继续执行的一种情况

在运行时，Go 对于运行时死锁检测具有良好支持。但在某种情况下goroutine无法取得任何进展，这时Go程序会提供一个详细的错误信息. 下面就是我们崩溃程序的日志:

```
Waiting for the news...
BREAKING NEWS: Channels let goroutines communicate.
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [chan receive]:
main.main()
    .../goroutineStop.go:11 +0xf6

goroutine 2 [syscall]:
created by runtime.main
    .../go/src/pkg/runtime/proc.c:225

goroutine 4 [timer goroutine (idle)]:
created by addtimer
    .../go/src/pkg/runtime/ztime_linux_amd64.c:73
```

多数情况下下，在 Go 程序中很容易搞清楚是什么导致了死锁。接着就是如何去修复它了。

## 5. 数据竞争

死锁可能听起来很糟糕, 但是真正给并发编程带来灾难的是数据竞争。它们相当常见，而且难于调试。

> 一个 _数据竞争_ 发生在当两个线程并发访问相同的变量,同时最少有一个访问是在写.

数据竞争是没有规律的。举个例子，打印数字1，尝试找出它是如何发生的 — 一个可能的解释是在代码之后.

```
func race() {
    wait := make(chan struct{})
    n := 0
    go func() {
        **n++** // 一次操作：读,增长,写
        close(wait)
    }()
    **n++** // 另一个冲突访问
    <-wait
    fmt.Println(n) // 输出: 不确定
}
```

[datarace.go](https://www.nada.kth.se/~snilsson/concurrency/src/datarace.go)

两个goroutines, `g1` 和 `g2`, 在竞争过程中，我们无法知道他们执行的顺序.下面只是许多可能的结果性的一种.

* `g1` 从`n`变量中读取值`0`
* `g2` 从`n`变量中读取值`0`
* `g1` 增加它的值从`0`变为`1`
* `g1` 把它的值把`1`赋值给`n`
* `g2` 增加它的值从`0`到`1`
* `g2` 把它的值把`1`赋值给`n`
* 这段程序将会打印n的值,它的值为`1`

"数据竞争” 的称呼多少有些误导，不仅仅是他的执行顺序无法被设定，而且也无法保证接下来会发生的情况。编译器和硬件时常会为了更好的性能而调整代码的顺序。如果你仔细观察一个正在运行的线程,那么你才可能会看到更多细节。

[![mid action](https://www.nada.kth.se/~snilsson/concurrency/mid-action.jpg)](http://www.flickr.com/photos/brandoncwarren/2953838847/)

避免数据竞争的唯一方式是同步操作在线程间所有共享的可变数据。存在几种方式，在Go中,可能最多使用 channel 或者 lock。较底层的操作可使用 [`sync`](https://golang.org/pkg/sync/) and [`sync/atomic`](https://golang.org/pkg/sync/atomic/) 包，这里不再讨论。

在Go中，处理并发数据访问的首选方式是使用一个 channel，它将数据从一个goroutine传递到另一个goroutine。有一句经典的话:"不要通过共享内存来传递数据;而要通过传递数据来共享内存"。

```
func sharingIsCaring() {
    ch := make(chan int)
    go func() {
        n := 0 // 局部变量只能对当前 goroutine 可见
        n++
        ch <- n // 数据通过 goroutine 传递
    }()
    n := <-ch   // ...从另外一个 goroutine 中安全接受
    n++
    fmt.Println(n) // 输出: 2
}
```

[datarace.go](https://www.nada.kth.se/~snilsson/concurrency/src/datarace.go)

在这份代码中 channel 充当了双重角色。它作为一个同步点，在不同 goroutine 中传递数据。发送的 goroutine 将会等待其它的 goroutine 去接收数据,而接收的 goroutine 将会等待其他的 goroutine 去发送数据。

[Go内存模型](https://golang.org/ref/mem) - 当一个 goroutine 在读一个变量,另外一个goroutine在写相同的变量，这个过程实际上是非常复杂的,但是只要你用 channel 在不同goroutines中共享数据,那么这个操作就是安全的。

## 6. 互斥锁

[![lock](https://www.nada.kth.se/~snilsson/concurrency/lock.jpg)](http://www.flickr.com/photos/dzarro72/7187334179/)

有时通过直接锁定来同步数据比使用 channel 更加方便。为此，Go 标准库提供了互斥锁[sync.Mutex](https://golang.org/pkg/sync/#Mutex)。

要让这种类型的锁正确工作，所有对于共享数据的操作（包括读和写）必须在一个 goroutine 持有该锁时进行。这一点至关重要，goroutine 的一次错误就足以破坏程序和导致数据竞争。

因此你需要为API去设计一种定制化的数据结构，并且确保所有同步操作都在内部执行。在这个例子中，我们构建了一种安全易用的并发数据结构，`AtomicInt`，它存储了单个整型，任何goroutines 都能安全的通过 `Add` 和 `Value` 方法访问数字。

```
// AtomicInt 是一种持有int类型的支持并发的数据结构。
// 它的初始化值为0.
type AtomicInt struct {
    mu sync.Mutex // 同一时间只能有一个 goroutine 持有锁。
    n  int
}

// Add adds n to the AtomicInt as a single atomic operation.
// 原子性的将n增加到AtomicInt中
func (a *AtomicInt) Add(n int) {
    a.mu.Lock() // 等待锁被释放然后获取。
    a.n += n
    a.mu.Unlock() // 释放锁。
}

// 返回a的值.
func (a *AtomicInt) Value() int {
    a.mu.Lock()
    n := a.n
    a.mu.Unlock()
    return n
}

func lockItUp() {
    wait := make(chan struct{})
    var n AtomicInt
    go func() {
        n.Add(1) // one access
        close(wait)
    }()
    n.Add(1) // 另一个并发访问
    <-wait
    fmt.Println(n.Value()) // Output: 2
}
```

[datarace.go](https://www.nada.kth.se/~snilsson/concurrency/src/datarace.go)

## 7. 检测数据竞争

竞争有时候难以检测。当我执行这段存在数据竞争的程序,它打印`55555`。再试一次,可能会得到不同的结果。 [`sync.WaitGroup`](https://golang.org/pkg/sync/#WaitGroup)是go标准库的一部分;它等待一系列 goroutines 执行结束。

```
func race() {
    var wg sync.WaitGroup
    wg.Add(5)
    for i := 0; i < 5; **i++** {
        go func() {
            **fmt.Print(i)** // 局部变量i被6个goroutine共享
            wg.Done()
        }()
    }
    wg.Wait() // 等待5个goroutine执行结束
    fmt.Println()
}
```

[raceClosure.go](https://www.nada.kth.se/~snilsson/concurrency/src/raceClosure.go)

对于输出 `55555` 较为合理的解释是执行 `i++` 操作的 goroutine 在其他 goroutines 打印之前就已经执行了5次。事实上，更新后的 `i` 对于其他 goroutines 可见是随机的。

一个非常简单的解决办法是通过使用本地变量作为参数的方式去启动另外的goroutine。

```
func correct() {
    var wg sync.WaitGroup
    wg.Add(5)
    for i := 0; i < 5; i++ {
        go func(n int) { // 局部变量。
            fmt.Print(n)
            wg.Done()
        }(i)
    }
    wg.Wait()
    fmt.Println()
}
```

[raceClosure.go](https://www.nada.kth.se/~snilsson/concurrency/src/raceClosure.go)

这段代码是正确的，他打印了期望的结果，`24031`。回想一下,在不同 goroutines 中,程序的执行顺序是乱序的。

我们仍然可以使用闭包去避免数据竞争。但是我们需要注意在每个 goroutine 中需要有不同的变量。

```
func alsoCorrect() {
    var wg sync.WaitGroup
    wg.Add(5)
    for i := 0; i < 5; i++ {
        n := i // 为每个闭包创建单独的变量
        go func() {
            fmt.Print(n)
            wg.Done()
        }()
    }
    wg.Wait()
    fmt.Println()
}
```

[raceClosure.go](https://www.nada.kth.se/~snilsson/concurrency/src/raceClosure.go)

## 7. 自动竞争检测

总的来说.我们不可能自动的发现所有的数据竞争。但是 Go(从1.1版本开始) 提供了一个强大的数据竞争检测器 [data race detector](http://tip.golang.org/doc/articles/race_detector.html)。

这个工具使用下来非常简单: 仅仅增加 `-race` 到 `go` 命令后。运行上述程序将会自动检查并且打印出下面的输出信息。

```
$ go run -race raceClosure.go 
Data race:
==================
WARNING: DATA RACE
Read at 0x00c420074168 by goroutine 6:
  main.race.func1()
      ../raceClosure.go:22 +0x3f

Previous write at 0x00c420074168 by main goroutine:
  main.race()
      ../raceClosure.go:20 +0x1bd
  main.main()
      ../raceClosure.go:10 +0x2f

Goroutine 6 (running) created at:
  main.race()
      ../raceClosure.go:24 +0x193
  main.main()
      ../raceClosure.go:10 +0x2f
==================
12355
Correct:
01234
Also correct:
01234
Found 1 data race(s)
exit status 66
```

这个工具发现在程序20行存在数据竞争，一个goroutine向某个变量写值，而22行存在另外一个 goroutine 在不同步的读取这个变量的值。

注意这个工具只能找到实际执行时发生的数据竞争。

## 8. Select 语句

在 Go 并发编程中,最后讲的一个是 [select](https://golang.org/ref/spec#Select_statements) 语句。它会挑选出一系列通信操作中能够执行的操作。如果任意的通信操作都可执行，则会随机挑选一个并执行相关的语句。否则，如果也没有默认执行语句的话，则会阻塞直到其中的任意一个通信操作能够执行。

这有一个例子,显示了如何用 select 去随机生成数字.

```
// RandomBits 返回产生随机位数的channel
func RandomBits() <-chan int {
    ch := make(chan int)
    go func() {
        for {
            select {
            case ch <- 0: // 没有相关操作语句
            case ch <- 1:
            }
        }
    }()
    return ch
}
```

[randBits.go](https://www.nada.kth.se/~snilsson/concurrency/src/randBits.go)

更简单，这里 select 被用于设置超时。这段代码只能打印 news 或者 time-out 消息,这取决于两个接收语句中谁可以执行.

```
select {
case news := <-NewsAgency:
    fmt.Println(news)
case <-time.After(time.Minute):
    fmt.Println("Time out: no news in one minute.")
}
```


[`time.After`](https://golang.org/pkg/time/#After)是 go 标准库的一部分;他等待特定时间过去，然后将当前时间发送到返回的 channel.



## 9. 最基本的并发实例

[![couples](https://www.nada.kth.se/~snilsson/concurrency/couples.jpg)](http://www.flickr.com/photos/julia_manzerova/4617019027/)

多花点时间仔细理解这个例子。当你完全理解它,你将会彻底的理解 Go 内部的并发工作机制。

程序演示了单个 channel 同时发送和接受多个 goroutines 的数据。它也展示了 select 语句如何从多个通信操作中选择执行。

```
func main() {
    people := []string{"Anna", "Bob", "Cody", "Dave", "Eva"}
    match := make(chan string, 1) // 给未匹配的元素预留空间
    wg := new(sync.WaitGroup)
    for _, name := range people {
        wg.Add(1)
        go Seek(name, match, wg)
    }
    wg.Wait()
    select {
    case name := <-match:
        fmt.Printf("No one received %s’s message.\n", name)
    default:
        // 没有待处理的发送操作.
    }
}

// 寻求发送或接收匹配上名称名称的通道,并在完成后通知等待组.
func Seek(name string, match chan string, wg *sync.WaitGroup) {
    select {
    case peer := <-match:
        fmt.Printf("%s received a message from %s.\n", name, peer)
    case match <- name:
        // 等待其他人接受消息.
    }
    wg.Done()
}
```

[matching.go](https://www.nada.kth.se/~snilsson/concurrency/src/matching.go)

实例输出:

```
$ go run matching.go
Anna received a message from Eva.
Cody received a message from Bob.
No one received Dave’s message.
```

## 10. 并行计算

[![CPUs](https://www.nada.kth.se/~snilsson/concurrency/cpus.jpg)](http://www.flickr.com/photos/somegeekintn/4819945812//)

具有并发特性应用会将一个大的计算划分为小的计算单元，每个计算单元都会单独的工作。

多 CPU 上的分布式计算不仅仅是一门科学，更是一门艺术。

* 每个计算单元执行时间大约在100us至1ms之间.如果这些单元太小,那么分配问题和管理子模块的开销可能会增大。如果这些单元太大，整个的计算体系可能会被一个小的耗时操作阻塞。很多因素都会影响计算速度，比如调度，程序终端，内存布局(注意工作单元的个数和 CPU 的个数无关)。

* 尽量减少数据共享的量。并发写入是非常消耗性能的，特别是多个 goroutines 在不同CPU上执行时。共享数据读操作对性能影响不是很大。

* 数据的合理组织是一种高效的方式。如果数据保存在缓存中，数据的加载和存储的速度将会大大加快。再次强调，这对写操作来说是非常重要的。

下面的例子将会显示如何将多个耗时计算分配到多个可用的 CPU 上。这就是我们想要优化的代码。

```
type Vector []float64

// Convolve computes w = u * v, where w[k] = Σ u[i]*v[j], i + j = k.
// Precondition: len(u) > 0, len(v) > 0.
func Convolve(u, v Vector) Vector {
    n := len(u) + len(v) - 1
    w := make(Vector, n)

    for k := 0; k < n; k++ {
        w[k] = mul(u, v, k)
    }
    return w
}

// mul returns Σ u[i]*v[j], i + j = k.
func mul(u, v Vector, k int) float64 {
    var res float64
    n := min(k+1, len(u))
    j := min(k, len(v)-1)
    for i := k - j; i < n; i, j = i+1, j-1 {
        res += u[i] * v[j]
    }
    return res
}
```

这个想法很简单：识别适合大小的工作单元，然后在单独的 goroutine 中运行每个工作单元. 这就是 `Convolve` 的并发版本.

```
func Convolve(u, v Vector) Vector {
    n := len(u) + len(v) - 1
    w := make(Vector, n)

    // 将w划分为多个将会计算100us-1ms时间计算的工作单元
    size := max(1, 1000000/n)

    var wg sync.WaitGroup
    for i, j := 0, size; i < n; i, j = j, j+size {
        if j > n {
            j = n
        }
        // goroutines只为读共享内存.
        wg.Add(1)
        go func(i, j int) {
            for k := i; k < j; k++ {
                w[k] = mul(u, v, k)
            }
            wg.Done()
        }(i, j)
    }
    wg.Wait()
    return w
}
```

[convolution.go](https://www.nada.kth.se/~snilsson/concurrency/src/convolution.go)

当定义好计算单元，通常最好将调度留给程序执行和操作系统。然而,在 Go1.*版本中，你需要指定 goroutines 的个数。

```
func init() {
    numcpu := runtime.NumCPU()
    runtime.GOMAXPROCS(numcpu) // 尽量使用所有可用的 CPU
}
```

[Stefan Nilsson](https://plus.google.com/+StefanNilsson/about?rel=author)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
