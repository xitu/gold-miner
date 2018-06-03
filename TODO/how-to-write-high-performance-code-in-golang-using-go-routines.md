 
> * 原文地址：[How to write high-performance code in Golang using Go-Routines](https://medium.com/@vigneshsk/how-to-write-high-performance-code-in-golang-using-go-routines-227edf979c3c)
> * 原文作者：[Vignesh Sk](https://medium.com/@vigneshsk?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-high-performance-code-in-golang-using-go-routines.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-high-performance-code-in-golang-using-go-routines.md)
> * 译者：[tmpbook](https://github.com/tmpbook)
> * 校对者：[altairlu](https://github.com/altairlu)

# 如何使用 Golang 中的 Go-Routines 写出高性能的代码

![](https://cdn-images-1.medium.com/max/800/1*jdAaUNHvhS0n1FjS2RUxgw.jpeg)

为了用 Golang 写出快速的代码，你需要看一下 Rob Pike 的视频 - [Go-Routines](https://www.youtube.com/watch?v=f6kdp27TYZs)。

他是 Golang 的作者之一。如果你还没有看过视频，请继续阅读，这篇文章是我对那个视频内容的一些个人见解。我感觉视频不是很完整。我猜 Rob 因为时间关系忽略掉了一些他认为不值得讲的观点。不过我花了很多的时间来写了一篇综合全面的关于 go-routines 的文章。我没有涵盖视频中涵盖的所有主题。我会介绍一些自己用来解决 Golang 常见问题的项目。

好的，为了写出很快的 Golang 程序，有三个概念你需要完全了解，那就是 Go-Routines，闭包，还有管道。

## Go-Routines

让我们假设你的任务是将 100 个盒子从一个房间移到另一个房间。再假设，你一次只能搬一个盒子，而且移动一次会花费一分钟时间。所以，你会花费 100 分钟的时间搬完这 100 个箱子。

现在，为了让加快移动 100 个盒子这个过程，你可以找到一个方法更快的移动这个盒子（这类似于找一个更好的算法去解决问题）或者你可以额外雇佣一个人去帮你移动盒子（这类似于增加 CPU 核数用于执行算法）

这篇文章重点讲第二种方法。编写 go-routines 并利用一个或者多个 CPU 核心去加快应用的执行。

任何代码块在默认情况下只会使用一个 CPU 核心，除非这个代码块中声明了 go-routines。所以，如果你有一个 70 行的，没有包含 go-routines 的程序。它将会被单个核心执行。就像我们的例子，一个核心一次只能执行一个指令。因此，如果你想加快应用程序的速度，就必须把所有的 CPU 核心都利用起来。


所以，什么是 go-routine。如何在 Golang 中声明它？

让我们看一个简单的程序并介绍其中的 go-routine。

### 示例程序 1

假设移动一个盒子相当于打印一行标准输出。那么，我们的实例程序中有 10 个打印语句（因为没有使用 for 循环，我们只移动 10 个盒子）。

```
package main

import "fmt"

func main() {
	fmt.Println("Box 1")
	fmt.Println("Box 2")
	fmt.Println("Box 3")
	fmt.Println("Box 4")
	fmt.Println("Box 5")
	fmt.Println("Box 6")
	fmt.Println("Box 7")
	fmt.Println("Box 8")
	fmt.Println("Box 9")
	fmt.Println("Box 10")
}

```

因为 go-routines 没有被声明，上面的代码产生了如下输出。

### 输出

```
Box 1
Box 2
Box 3
Box 4
Box 5
Box 6
Box 7
Box 8
Box 9
Box 10
```

所以，如果我们想在在移动盒子这个过程中使用额外的 CPU 核心，我们需要声明一个 go-routine。

### 包含 Go-Routines 的示例程序 2

```
package main

import "fmt"

func main() {
	go func() {
		fmt.Println("Box 1")
		fmt.Println("Box 2")
		fmt.Println("Box 3")
	}()
	fmt.Println("Box 4")
	fmt.Println("Box 5")
	fmt.Println("Box 6")
	fmt.Println("Box 7")
	fmt.Println("Box 8")
	fmt.Println("Box 9")
	fmt.Println("Box 10")
}

```

这儿，一个 go-routine 被声明且包含了前三个打印语句。意思是处理 main 函数的核心只执行 4-10 行的语句。另一个不同的核心被分配去执行 1-3 行的语句块。

### 输出

```
Box 4
Box 5
Box 6
Box 1
Box 7
Box 8
Box 2
Box 9
Box 3
Box 10
```

## 分析输出

在这段代码中，有两个 CPU 核心同时运行，试图执行他们的任务，并且这两个核心都依赖标准输出来完成它们相应的任务（因为这个示例中我们使用了 print 语句）
换句话来说，标准输出（运行在它自己的一个核心上）一次只能接受一个任务。所以，你在这儿看到的是一种随机的排序，这取决于标准输出决定接受 core1 core2 哪个的任务。

## 如何声明 go-routine？

为了声明我们自己的 go-routine，我们需要做三件事。

1. 我们创建一个匿名函数
2. 我们调用这个匿名函数
3. 我们使用 「go」关键字来调用

所以，第一步是采用定义函数的语法，但忽略定义函数名（匿名）来完成的。

```
func() {
	fmt.Println("Box 1")
	fmt.Println("Box 2")
	fmt.Println("Box 3")
}
```

第二步是通过将空括号添加到匿名方法后面来完成的。这是一种叫命名函数的方法。

```
func() {
  fmt.Println("Box 1")
  fmt.Println("Box 2")
  fmt.Println("Box 3")
} ()
```

步骤三可以通过 go 关键字来完成。什么是 go 关键字呢，它可以将功能块声明为可以独立运行的代码块。这样的话，它可以让这个代码块被系统上其他空闲的核心所执行。

> #细节 1：当 go-routines 的数量比核心数量多的时候会发生什么？
>
> 单个核心通过[上下文切换](https://stackoverflow.com/a/5201906)并行执行多个go程序来实现多个核心的错觉。
>
> #自己试试之1：试着移除示例程序2中的 go 关键字。输出是什么呢？
>
> 答案：示例程序2的结果和1一模一样。
>
> #自己试试之 2：将匿名函数中的语句从 3 增加至 8 个。结果改变了吗？
>
> 答案：是的。main 函数是一个母亲 go-routine（其他所有的 go-routine 都在它里面被声明和创建）。所以，当母亲 go-routine 执行结束，即使其他 go-routines 执行到中途，它们也会被杀掉然后返回。

我们现在已经知道 go-routines 是什么了。接下来让我们来看看**闭包**。

如果之前没有在 Python 或者 JavaScript 中学过闭包，你可以现在在 Golang 中学习它。学到的人可以跳过这部分来节省时间，因为 Golang 中的闭包和 Python 或者 JavaScript 中是一样的。

在我们深入理解闭包之前。让我们先看看不支持闭包属性的语言比如 C，C++ 和 Java，在这些语言中，

1. 函数只访问两种类型的变量，全局变量和局部变量（函数内部的变量）。
2. 没有函数可以访问声明在其他函数里的变量。
3. 一旦函数执行完毕，这个函数中声明的所有变量都会消失。

对 Golang，Python 或者 JavaScript 这些支持闭包属性的语言，以上都是不正确的，原因在于，这些语言拥有以下的灵活性。

1. 函数可以声明在函数内。
2. 函数可以返回函数。

> 推论 #1：因为函数可以被声明在函数内部，一个函数声明在另一个函数内的嵌套链是这种灵活性的常见副产品。

为了了解为什么这两个灵活性完全改变了运作方式，让我们看看什么是闭包。

## 所以什么是闭包？

除了访问局部变量和全局变量，函数还可以访问函数声明中声明的所有局部变量，只要它们是在之前声明的（包括在运行时传递给闭包函数的所有参数），在嵌套的情况下，函数可以访问所有函数的变量（无论闭包的级别如何）。


为了理解的更好，让我们考虑一个简单的情况，两个函数，一个包含另一个。

```
package main

import "fmt"

var zero int = 0

func main() {
	var one int = 1
	child := func() {
		var two int = 3
		fmt.Println(zero)
		fmt.Println(one)
		fmt.Println(two)
		fmt.Println(three) // causes compilation Error
	}
	child()
	var three int = 2
}

```

这儿有两个函数 - 主函数和子函数，其中子函数定义在主函数中。子函数访问

1. zero 变量 - 它是全局变量
2. one 变量 - 闭包属性 - one 属于主函数，它在主函数中且定义在子函数之前。
3. two 变量 - 它是子函数的局部变量

> 注意：虽然它被定义在封闭函数「main」中，但它不能访问 three 变量，因为后者的声明在子函数的定义后面。

和嵌套一样。

```
package main

import "fmt"

var global func()

func closure() {
	var A int = 1
	func() {
		var B int = 2
		func() {
			var C int = 3
			global = func() {
				fmt.Println(A, B, C)
				fmt.Println(D, E, F) // causes compilation error
			}
			var D int = 4
		}()
		var E int = 5
	}()
	var F int = 6
}
func main() {
	closure()
	global()
}

```

如果我们考虑一下将一个最内层的函数关联给一个全局变量「global」。

1. 它可以访问到 A、B、C 变量，和闭包无关。
1. 它无法访问 D、E、F 变量，因为它们之前没有定义。

> 注意：即使闭包执行完了，它的局部变量任然不会被销毁。它们仍然能够通过名字是 「global」的函数名去访问。

下面介绍一下 **Channels**。

Channels 是 go-routines 之间通信的一种资源，它们可以是任意类型。

```
ch := make(chan string)
```

我们定义了一个叫做 ch 的 string 类型的 channel。只有 string 类型的变量可以通过此 channel 通信。

```
ch <- "Hi"
```

就是这样发送消息到 channel 中。

```
msg := <- ch
```

这是如何从 channel 中接收消息。

所有 channel 中的操作（发送和接收）本质上是阻塞的。这意味着如果一个 go-routine 试图通过 channel 发送一个消息，那么只有在存在另一个 go-routine 正在试图从 channel 中取消息的时候才会成功。如果没有 go-routine 在 channel 那里等待接收，作为发送方的 go-routine 就会永远尝试发送消息给某个接收方。

最重要的点是这里，跟在 channel 操作后面的所有的语句在 channel 操作结束之前是不会执行的，go-routine 可以解锁自己然后执行跟在它后面的的语句。这有助于同步其他代码块的各种 go-routine。

> 免责声明：如果只有发送方的 go-routine，没有其他的 go-routine。那么会发生死锁，go 程序会检测出死锁并崩溃。
>
> 注意：所有以上讲的也都适用于接收方 go-routines。

## 缓冲 Channels

```
ch := make(chan string, 100)
```

缓冲 channels 本质上是半阻塞的。

比如，ch 是一个 100 大小的缓冲字符 channel。这意味着前 100 个发送给它的消息是非阻塞的。后面的就会阻塞掉。

这种类型的 channels 的用处在于从它中接收消息之后会再次释放缓冲区，这意味着，如果有 100 个新 go-routines 程序突然出现，每个都从 channel 中消费一个消息，那么来自发送者的下 100 个消息将会再次变为非阻塞。


所以，一个缓冲 channel 的行为是否和非缓冲 channel 一样，取决于缓冲区在运行时是否空闲。

## Channels 的关闭

```
close(ch)
```

这就是如何关闭 channel。在 Golang 中它对避免死锁很有帮助。接收方的 go-routine 可以像下面这样探测 channel 是否关闭了。

```
msg, ok := <- ch
if !ok {
  fmt.Println("Channel closed")
}
```

## 使用 Golang 写出很快的代码

现在我们讲的知识点已经涵盖了 go-routines，闭包，channel。考虑到移动盒子的算法已经很有效率，我们可以开始使用 Golang 开发一个通用的解决方案来解决问题，我们只关注为任务雇佣合适的人的数量。

让我们仔细看看我们的问题，重新定义它。

我们有 100 个盒子需要从一个房间移动到另一个房间。需要着重说明的一点是，移动盒子1和移动盒子2涉及的工作没有什么不同。因此我们可以定义一个移动盒子的方法，变量「i」代表被移动的盒子。方法叫做「任务」，盒子数量用「N」表示。任何「计算机编程基础 101」课程都会教你如何解决这个问题：写一个 for 循环调用「任务」N 次，这导致计算被单核心占用，而系统中的可用核心是个硬件问题，取决于系统的品牌，型号和设计。所以作为软件开发人员，我们将硬件从我们的问题中抽离出去，来讨论 go-routines 而不是核心。越多的核心就支持越多的 go-routines，我们假设「R」是我们「X」核心系统所支持的 go-routines 数量。

> FYI：数量「X」的核心数量可以处理超过数量「X」的 go-routines。单个核心支持的 go-routines 数量（R/X）取决于 go-routines 涉及的处理方式和运行时所在的平台。比如，如果所有的 go-routine 仅涉及阻塞调用，例如网络 I/O 或者 磁盘 I/O，则单个内核足以处理它们。这是真的，因为每个 go-routine 相比运算来说更多的在等待。因此，单个核心可以处理所有 go-routine 之间的上下文切换。

因此我们的问题的一般性的定义为

> 将「N」个任务分配给「R」个 go-routines，其中所有的任务都相同。

如果 N≤R，我们可以用以下方式解决。

```
package main

import "fmt"

var N int = 100

func Task(i int) {
	fmt.Println("Box", i)
}
func main() {
	ack := make(chan bool, N) // Acknowledgement channel
	for i := 0; i < N; i++ {
		go func(arg int) { // Point #1
			Task(arg)
			ack <- true // Point #2
		}(i) // Point #3
	}

	for i := 0; i < N; i++ {
		<-ack // Point #2
	}
}

```

解释一下我们做了什么...

1. 我们为每个任务创建一个 go-routine。我们的系统能同时支持「R」个 go-routines。只要 N≤R 我们这么做就是安全的。
2. 我们确认 main 函数在等待所有 go-routine 完成的时候才返回。我们通过等待所有 go-routine（通过闭包属性）使用的确认 channel（「ack」）来传达其完成。
3. 我们传递循环计数「i」作为参数「arg」给 go-routine，而不是通过[闭包属性](https://golang.org/doc/faq#closures_and_goroutines)在 go-routine 中直接引用它。

另一方面，如果 N>R，则上述解决方法会有问题。它会创建系统不能处理的 go-routines。所有核心都尝试运行更多的，超过其容量的 go-routines，最终将会把更多的时间话费在上下文切换上而不是运行程序（俗称抖动）。当 N 和 R 之间的数量差异越来越大，上下文切换的开销会更加突出。因此要始终将 go-routine 的数量限制为 R。并将 N 个任务分配给 R 个 go-routines。

下面我们介绍 **workers** 函数

```
var R int = 100
func Workers(task func(int)) chan int { // Point #4
 input := make(chan int)                // Point #1
 for i := 0; i < R; i++ {               // Point #1
   go func() {
     for {
       v, ok := <-input                   // Point #2
       if ok {
         task(v)                           // Point #4
       } else {
         return                            // Point #2
       }
     }
   }()
 }
 return input                          // Point #3
}
```

1. 创建一个包含有「R」个 go-routines 的池。不多也不少，所有对「input」channel 的监听通过闭包属性来引用。
2. 创建 go-routines，它通过在每次循环中检查 ok 参数来判断 channel 是否关闭，如果 channel 关闭则杀死自己。
3. 返回 input channel 来允许调用者函数分配任务给池。
4. 使用「task」参数来允许调用函数定义 go-routines 的主体。

## 使用

```
func main() {
ack := make(chan bool, N)
workers := Workers(func(a int) {     // Point #2
  Task(a)
  ack <- true                        // Point #1
 })
for i := 0; i < N; i++ {
  workers <- i
 }
for i := 0; i < N; i++ {             // Point #3
  <-ack
 }
}
```

通过将语句（Point #1）添加到 worker 方法中（Point #2），闭包属性巧妙的在任务参数定义中添加了对确认 channel 的调用，我们使用这个循环（Point #3）来使 main 函数有一个机制去知道池中的所有 go-routine 是否都完成了任务。所有和 go-routines 相关的逻辑都应该包含在 worker 自己中，因为它们是在其中创建的。main 函数不应该知道内部 worker 函数们的工作细节。

因此，为了实现完全的抽象，我们要引入一个『climax』函数，只有在池中所有 go-routine 全部完成之后才运行。这是通过设置另一个单独检查池状态的 go-routine 来实现的，另外不同的问题需要不同类型的 channel 类型。相同的 int cannel 不能在所有情况下使用，所以，为了写一个更通用的 worker 函数，我们将使用[空接口类型](https://tour.golang.org/methods/14)重新定义一个 worker 函数。

```
package main

import "fmt"

var N int = 100
var R int = 100

func Task(i int) {
	fmt.Println("Box", i)
}
func Workers(task func(interface{}), climax func()) chan interface{} {
	input := make(chan interface{})
	ack := make(chan bool)
	for i := 0; i < R; i++ {
		go func() {
			for {
				v, ok := <-input
				if ok {
					task(v)
					ack <- true
				} else {
					return
				}
			}
		}()
	}
	go func() {
		for i := 0; i < R; i++ {
			<-ack
		}
		climax()
	}()
	return input
}
func main() {

	exit := make(chan bool)

	workers := Workers(func(a interface{}) {
		Task(a.(int))
	}, func() {
		exit <- true
	})

	for i := 0; i < N; i++ {
		workers <- i
	}
	close(workers)

	<-exit
}

```

你看，我已经试图展示了 Golang 的力量。我们还研究了如何在 Golang 中编写高性能代码。

请观看 Rob Pike 的 Go-Routines 视频，然后和 Golang 度过一个美好的时光。

直到下次...

感谢 [Prateek Nischal](https://medium.com/@prateeknischal25?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
