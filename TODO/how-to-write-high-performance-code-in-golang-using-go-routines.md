 
> * 原文地址：[How to write high-performance code in Golang using Go-Routines](https://medium.com/@vigneshsk/how-to-write-high-performance-code-in-golang-using-go-routines-227edf979c3c)
> * 原文作者：[Vignesh Sk](https://medium.com/@vigneshsk?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-high-performance-code-in-golang-using-go-routines.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-write-high-performance-code-in-golang-using-go-routines.md)
> * 译者：[tmpbook](https://github.com/tmpbook)
> * 校对者：

# How to write high-performance code in Golang using Go-Routines
# 如何使用 Golang 中的 Go-Routines 写出高性能的代码

![](https://cdn-images-1.medium.com/max/800/1*jdAaUNHvhS0n1FjS2RUxgw.jpeg)

In order to write fast code in Golang, you need to check out this video by Rob Pike on [Go-Routines](https://www.youtube.com/watch?v=f6kdp27TYZs).
Golang 中为了写出很快的代码，你需要看一下 Rob Pike 的视频 - [Go-Routines](https://www.youtube.com/watch?v=f6kdp27TYZs)。

He is one of Golang’s creators. And if you haven’t seen it yet, keep reading, since this blog is my own take on the contents of that video. I don’t feel the video is complete. I guess Rob omitted some of the topics he felt were too trivial to deserve a mention in his time constrained video. But I, on the other hand with time at my disposal have written a comprehensive blog about go-routines. I have not covered all of the topics covered in the video. And I have included code from my own projects I use to solve common problems in Golang.
他是 Golang 的作者之一。如果你还没有看过视频，请继续阅读，这篇文章是我对那个视频内容的一些个人见解。我感觉视频不是很完整。我猜 Rob 因为时间关系忽略掉了一些他认为不值的讲的观点。不过我在 go-routines 上花了很多时间，写了一个综合全面的文章来讲它。我没有涵盖视频中涵盖的所有主题。我会介绍一些自己用来解决 Golang 常见问题的项目。

So, There are 3 concepts you need to absolutely understand, in order to write fast code in Golang. They are Go-Routines, Closures & Channels.
好的，为了写出很快的 Golang 程序，有三个概念你需要完全了解，那就是 Go-Routines，闭包，还有管道。

## Go-Routines
## Go-Routines

Let’s say your task is to move 100 boxes from one room to another. Let’s also say, you can carry only one box at a time and you will take 1 min to move one box. So, you will end up taking 100 mins to move 100 boxes.
让我们假设你的任务是将 100 个盒子从一个房间移到另一个房间。再假设，你一次只能搬一个盒子，而且移动一次会花费一分钟时间。所有，最终你搬这 100 个箱子花了 100 分钟。

Now, to speed up the process of moving 100 boxes, you can either figure out a way to move one box faster (which is analogous to finding a better algorithm to solve the problem) or you can hire an additional person to help you with moving boxes (which is analogous to increasing the number of CPU cores used to execute your algorithm).
现在，为了让加快移动 100 个盒子这个过程，你可以找到一个方法更快的移动这个盒子（这类似于找一个更好的算法去解决问题）或者你可以额外雇佣一个人去帮你移动盒子（这类似于增加 CPU 核数用于执行算法）

The focus of this blog is the second approach. Writing go-routines and utilizing 1 or more CPU cores to speed up the execution of your application.
这篇文章重点讲第二种方法。编写 go-routines 并利用一个或者多个 CPU 核心去加快应用的执行。

Any block of code is executed only by a single core by default unless that block of code has go-routines declared in it. So, if you have a program that is 70 lines long without go-routines. It will be taken up for execution only by a single core. And like our example, a single core can execute only one instruction at a time. So, you would need to use all the cores available in your system in order to speed up your application.
任何代码块在默认情况下只会使用一个 CPU 核心，除非这个代码块中声明了 go-routines。所以，如果你有一个 70 行的，没有包含 go-routines 的程序。它将会被单个核心执行。就像我们的例子，一个核心一次只能执行一个指令，因此，你需要使用系统的所有核心才能加快应用程序的速度。


## So, What is a go-routine and How do we declare one in Golang ?
所以，什么是 go-routine，如何在 Golang 中声明它？

Let’s take a sample program and introduce go-routines in it.
让我们看一个简单的程序并介绍其中的 go-routine。

### Sample Program 1
### 示例程序 1

Let’s say moving a box is analogous to printing a line. So, in our sample program we have 10 print statements (since for loops are not being used, we are moving only 10 boxes).
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

Since go-routines are not declared, the above code produces the following output.
因为 go-routines 没有被声明，上面的代码产生了如下输出。

### Output
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

So, if we want to use an additional core in moving our boxes, we declare a go-routine.
所以，如果我们想在在移动盒子这个过程中使用额外的 CPU 核心，我们声明一个 go-routine。

### Sample Program 2 with Go-Routines
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

Here, a go-routine has been declared for the first 3 statements. Meaning whatever core has taken up the execution of the main method, will execute only statements 4–10. And a different core assigned to statements 1–3 will take up the responsibility of executing that block.
这儿，一个 go-routine 被声明且包含了前三个打印语句。意思是处理 main 函数的核心只执行 4-10 行的语句。另一个不同的核心被分配去执行 1-3 行的语句块。

### Output
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

## Analysing the output
## 分析输出

Whats happening here is, there are 2 cores running at the same time, trying to execute it’s tasks and both cores depend on stdout to accomplish it’s respective tasks (since we have used print statements in our example).
这里发生的是，有两个 CPU 核心同时运行，试图执行他们的任务，并且这两个核心都依赖标准输出来完成它们相应的任务（因为这个示例中我们使用了 print 语句）
stdout (running on a single core of it’s own) on the other hand can accept only one task at a time. So, what you are seeing here is, the random order in which stdout decided to accept tasks from both core1 and core2.
标准输出（运行在它自己的一个核心上）换句话来说，一次只能接受一个任务。所以，你在这儿看到的是一种随机的排序，这取决于标准输出决定接受 core1 core2 哪个的任务。

## How we declared the go-routine?
## 如何声明 go-routine？

There are 3 things we are doing here in order to declare our go-routine.
为了声明我们的 go-routine 有三件事我们要做。

1. We are creating an anonymous function
1. 我们创建一个匿名函数
2. We are calling the anonymous function
2. 我们调用这个匿名函数
3. And we are calling it using “go” keyword
3. 我们使用 「go」关键字来调用

So, step 1 is accomplished by taking the syntax to define a function and omitting the name of the function in that syntax (anonymous).
所以，第一步是采用定义函数的语法，但忽略定义函数名（匿名）来完成的。

```
func() {
	fmt.Println("Box 1")
	fmt.Println("Box 2")
	fmt.Println("Box 3")
}
```

Step 2 is accomplished by appending empty parenthesis to our anonymous function. The way one would call named functions.
第二步是通过将空括号添加到匿名方法后面来完成的。这是一种叫命名函数的方法。

```
func() {
  fmt.Println("Box 1")
  fmt.Println("Box 2")
  fmt.Println("Box 3")
} ()
```

And step 3 is accomplished by prepending it with the go keyword. What a go keyword does is, it declares a function block as an independently runnable block of code. Thus, letting it be taken up by any other free/idle core available in your system.
步骤三可以通过 go 关键字来完成。什么是 go 关键字呢，它可以将功能块声明为可以独立运行的代码块。这样的话，它可以让这个代码块被系统上其他空闲的核心所执行。

> #Trivia 1: What happens when there are more go-routines than there are cores?
> #细节 1：当 go-routines 的数量比核心数量多的时候会发生什么？
>
> A single core achieves the illusion of several cores by executing several go-routines in parallel through context switching.
> 单个核心通过上下文切换并行执行多个go程序来实现多个核心的错觉。
>
> #TryItYourself 1: Try removing go keyword from sample program 2 . What’s the output?
> #自己试试之1：试着移除示例程序2中的 go 关键字。输出是什么呢？
>
> Answer: Sample program 2 gives the same output as Sample program 1
> 答案：示例程序2的结果和1一模一样。
>
> #TryItYourself 2: Try adding 8 statements to the anonymous function instead of 3. Does the output change?
> #自己试试之2：将8个语句而不是3个，添加到匿名函数中。结果改变了吗？
>
> Answer: Yes. The main function is the mother go-routine (It’s the go-routine in which all go-routines are declared or created). So, when the mother go-routine completes execution, all other go-routines are killed even if they are midway to completion and the program returns.
> 答案：是的。main 函数是一个母亲 go-routine（所有其他 go-routines 都被声明和创建在它里面）。所以，当母亲 go-routine 执行结束，即使其他 go-routines 执行到中途，它们也会被杀掉然后返回。

We have seen what go-routines are now. Let’s move onto **Closures**.
我们现在已近知道 go-routines 是什么了。接下来让我们来看看闭包。

For those of you who don’t know what closures are from python or Javascript, you can learn it now in Golang here. Others can save time by skipping this part as closures in Golang are just the same as they are in python or javascript.
如果没有从 Python 或者 JavaScript 学到什么闭包，你现在可以在 Golang 中学习它了。学到的人可以跳过这部分来节省时间，因为 Golang 中的闭包和 Python 或者 JavaScript 中是一样的。

Before we dive into closures. Let’s look at languages like C, C++ and Java where closure property is not supported. In these languages,
在我们深入理解闭包之前。让我们先看看不支持闭包属性的语言比如 C，C++ 和 Java，

1. Functions have access to only two types of variables, variables declared in the global scope and variables declared in the local scope (body of the function).
1. 函数只访问两种类型的变量，全局变量和局部变量（函数体重）。
2. No function gets access to variables declared in other functions.
2. 没有函数可以访问声明在其他函数里的变量。
3. And all variables declared inside a function cease to exist once it’s execution gets completed.
3. 一旦函数执行完毕，函数中声明的所有变量都会消失。

None of the above hold true in the case of languages like Golang, python & javascript where closure property is supported. The reason being, these languages allow the following flexibilities.
对 Golang，Python 或者 JavaScript 这些支持闭包属性的语言，以上都是不正确的，原因在于，这些语言允许以下的灵活性。

1. Functions can be declared inside functions.
1. 函数可以声明在函数内。
2. And Functions can return functions.
2. 函数可以返回函数。

> Extrapolation of #1: As functions can be declared inside functions, A nested chain of functions where each function is declared within the other is a commonly seen byproduct of this flexibility.
> 推论 #1：因为函数可以被声明在函数内部，一个函数声明在另一个函数内的嵌套链是这种灵活性的常见副产品。

To understand why these 2 flexibilities completely change the game, let’s see what a closure is.
为了了解为什么这两个灵活性完全改变了运作方式，让我们看看什么是闭包。

## So what is closure?
## 所以什么是闭包？

On top of getting access to local variables and global variables, functions get access to all local variables declared in functions enclosing it’s definition provided they are declared before (including all arguments passed to the enclosing function at runtime). And in the case of nesting, functions get access to variables of all functions enclosing it’s definition (irrespective of the level of enclosure).


To understand it better, let’s consider a simple scenario where there are only 2 functions one enclosing the other. We can bother about nesting after that.
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

There are 2 functions here — main and child, where child is defined inside main. Child gets access to
这儿有两个函数 - 主函数和子函数，其中子函数定义在主函数中。子函数访问

1. zero — since it’s global variable
1. zero 变量 - 它是全局变量
2. one — closure property — one belongs to enclosing function and it’s declaration precedes child’s definition in the enclosing function.
2. one 变量 - 闭包属性 - one 属于主函数，它在主函数中且定义在子函数之前。
3. two — since it’s local variable
3. two 变量 - 它是子函数的局部变量

> Note: It doesn’t get access to three —although declared in enclosing function “main” since it’s declaration doesn’t precede child’s definition.
> 注意：虽然它被定义在封闭函数「main」中，但它不能访问 three 变量，因为后者的声明在子函数的定义后面。

Now the same with nesting.
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

If we consider the innermost function assigned to “global” declared above in the global scope.
如果我们考虑赋值给全局变量「global」的内部方法。

1. It has access to A,B,C since the layer of enclosure does not matter.
1. 它可以访问到 A、B、C 变量，和闭包无关。
2. It doesn’t have access to D,E,F since their declaration don’t precede.
1. 它无法访问 D、E、F 变量，因为它们之前没有定义。

> Note: Even after execution of “closure” function, it’s local variables were not destroyed. They were accessible in the call to “global” function.
> 注意：即使闭包执行完了，它的局部变量任然不会被销毁。它们仍然允许「global」方法去访问。

Moving on to **Channels**.
下面介绍一下 **Channels**。

Channels are the resources go-routines use to communicate with each other. And they can be of any type.
Channels 是 go-routines 之间通信的一种资源，它们可以是任意类型。

```
ch := make(chan string)
```

We have declared a string channel here called ch. Only strings can be communicated via this channel.
我们定义了一个叫做 ch 的 string 类型的 channel。只有字符可以通过此 channel 通信。

```
ch <- "Hi"
```

This is how you send messages into the channel.
就是这样发送消息到 channel 中。

```
msg := <- ch
```

And this is how you receive messages from a channel.
这是如何从 channel 中接收消息。

All operations (sending & receiving) on a channel are blocking in nature. Meaning if a go-routine is attempting to send a message through a channel, the send operation succeeds only if there exists another go-routine trying to receive a message from that channel. If no go-routines are waiting on the channel, the sender go-routine waits indefinitely trying to send the message to someone.
所有 channel 中的操作（发送和接收）本质上是阻塞的。这意味着如果一个 go-routine 试图通过 channel 发送一个消息，那么只有在存在另一个 go-routine 正在试图从 channel 中取消息的时候才会成功。如果没有 go-routine 在 channel 那里等待接收，作为发送方的 go-routine 就会永远尝试发送消息给某个接收方。

The important point to note here is, all statements following the channel operation in the go-routine don’t get executed. Once the channel operation completes, the go-routine can unblock itself and continue executing statements following the channel operation. This helps to synchronize the various go-routines which are otherwise independently executing blocks of code.
最重要的点是这里，跟在 channel 操作后面的所有的语句在 channel 操作结束之前是不会执行的，go-routine 可以解锁自己然后执行跟在它后面的的语句。这有助于同步其他代码块的各种 go-routine。

> Disclaimer: If no other go-routine is present except for the sender go-routine. A deadlock occurs and the go program crashes as a result of identifying the deadlock.
> 免责声明：如果只有发送方的 go-routine，没有其他的 go-routine。那么会发生死锁，go 程序会检测出死锁并崩溃。
>
> Note: All of the above applies to receiver go-routines as well.
> 注意：所有以上讲的也都适用于接收方 go-routines。

## Buffered Channels
## 缓冲 Channels

```
ch := make(chan string, 100)
```

Buffered channels are channels that are semi-blocking in nature.
缓冲 channels 本质上是半阻塞的。

For example, ch is a buffered string channel, where the buffer length is 100. What this means, is any send operation on the channel is non-blocking for the first 100 messages. And it becomes blocking for any message after that.
比如，ch 是一个 100 大小的缓冲字符 channel。这意味着前 100 个发送给它的消息是非阻塞的。后面的就会阻塞掉。

Usefulness of this type of channels comes from the fact that receiving messages from the channel frees up the buffer again, meaning, if 100 new go-routines spring up suddenly each consuming a message from the channel, then the next 100 messages from the sender go-routine becomes non-blocking again.
这种类型的 channels 的用处在于从它中接收消息之后会再次释放缓冲区，这意味着，如果有 100 个新 go-routines 程序突然出现，每个都从 channel 中消费一个消息，那么来自发送者的下 100 个消息将会再次变为非阻塞。


So, a buffered channel behaves as a blocking channel as well as a non-blocking channel depending upon whether the buffer is free or not at runtime.
Closing Channels
所以，一个缓冲 channel 的行为是否和非缓冲 channel 一样，取决于缓冲区在运行时是否空闲。

## Closing Channels
## Channels 的关闭

```
close(ch)
```

This is how you close a channel. It helps save deadlock situations in Golang. Receiver go-routine can detect if a channel has been closed or not as shown below.
这就是如何关闭 channel。在 Golang 中它对避免死锁很有帮助。接收方的 go-routine 可以像下面这样探测 channel 是否关闭了。

```
msg, ok := <- ch
if !ok {
  fmt.Println("Channel closed")
}
```

## Writing fast code in Golang
使用 Golang 写出很快的代码

Now that concepts like go-routines, closures & channels have been covered. We can begin developing a generic solution in Golang to solve the problem of “moving boxes fast” given the algorithm used to move a box is already efficient and our concern is only about hiring the right number of individuals for the task.
现在我们讲的知识点已经涵盖了 go-routines，闭包，channel。考虑到移动盒子的算法已经很有效率，我们可以开始使用 Golang 开发一个通用的解决方案来解决问题，我们只关注为任务雇佣合适的人的数量。

Let’s take a closer look at our problem to redefine it generically.
让我们仔细看看我们的问题，重新定义它。

We have 100 boxes to move from one room to another. An important point to note here is work involved in moving box1 is no different than work involved for box2. Therefore we can define a function for moving a box where argument ‘i’ is the box to be moved. We can call this function “Task” and the number of boxes to be moved as ‘N’. Any “Basics of Computer Programming 101” class will teach you how to solve this problem by writing a for loop that runs N times and calls the “Task” function each time. This causes the computation to be seized by a single core which is not what we are after. And the number of cores available in a system is a hardware question that depends upon the make, model & design of the system. So, being software developers we abstract hardware away from our problem and we talk in terms of go-routines rather than cores. The more the number of cores a system has, the more the number of go-routines it can support. Let’s say, ‘R’ is the number of go-routines our system with ‘X’ cores can support.
我们有 100 个盒子需要从一个房间移动到另一个房间。需要着重说明的一点是，移动盒子1和移动盒子2涉及的工作没有什么不同。因此我们可以定义一个移动盒子的方法，变量「i」代表被移动的盒子。方法叫做「任务」，盒子数量用「N」表示。任何「计算机编程基础 101」课程都会教你如何解决这个问题：写一个 for 循环调用「任务」N 次，这导致计算被单核心占用，而系统中的可用核心是个硬件问题，取决于系统的品牌，型号和设计。所以作为软件开发人员，我们将硬件从我们的问题中抽离出去，来讨论 go-routines 而不是核心。越多的核心就支持越多的 go-routines，我们假设「R」是我们「X」核心系统所支持的 go-routines 数量。

> FYI: ‘X’ number of cores can handle more than ‘X’ number of go-routines. How many number of go-routines a single core can support (R/X) depends on the nature of processing involved in the go-routines and the runtime platform. For example, if all go-routines involve only blocking calls such as network I/O or disk I/O, then a single core is enough to process all of them. This is true because, every go-routine has more waiting work to do than computation work. Therefore a single core can manage executing all of them by context switching between each of them.
> FYI：数量「X」的核心数量可以处理超过数量「X」的 go-routines。单个核心支持的 go-routines 数量（R/X）取决于 go-routines 涉及的处理方式和运行时所在的平台。比如，如果所有的 go-routine 仅涉及阻塞调用，例如网络 I/O 或者 磁盘 I/O，则单个内核足以处理它们。这是真的，因为每个 go-routine 相比运算来说更多的在等待。因此，单个核心可以处理所有 go-routine 之间的上下文切换。

Therefore a generic definition of our problem would be
因此我们的问题的一般性的定义为

> Assigning ‘N’ tasks to ‘R’ go-routines where all tasks are identical to each other.
将「N」个任务分配给「R」个 go-routines，其中所有的任务都相同。

If N≤R, we can solve the problem as shown below.
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

What we have done here is…
解释一下我们做了什么...

1. We have created a separate go-routine for each task. Our system is capable of supporting R go-routines at a time. And since N≤R, we are safe in doing so.
1. 我们为每个任务创建一个 go-routine。我们的系统能同时支持「R」个 go-routines。只要 N≤R 我们这么做就是安全的。
2. We have made sure the main function returns only after waiting for all go-routines to complete. We do this by waiting on the acknowledgement channel (“ack”), which is used by all go-routines (via closure property), to communicate their completion.
2. 我们确认 main 函数在等待所有 go-routine 完成的时候才返回。我们通过等待所有 go-routine（通过闭包属性）使用的确认 channel（「ack」）来传达其完成。
3. We pass the loop counter ‘i’ as an argument ‘arg’ to the go-routine instead of directly referencing it in the go-routine through closure property.
3. 我们传递循环计数「i」作为参数「arg」给 go-routine，而不是通过闭包属性在 go-routine 中直接引用它。
1. 
On the other hand if N>R, the above solution would prove problematic. It will create more go-routines than our system can handle. All cores trying to process more go-routines than their capacity, will end up spending more time in context switching than in processing (commonly known as thrashing). This overhead caused by context switching becomes more prominent when the difference between N and R goes up. Therefore, to always limit the number of go-routines to R and assign N tasks to R go-routines only.
另一方面，如果 N>R，则上述解决方法会有问题。它会创建系统不能处理的 go-routines。所有核心都尝试运行更多的，超过其容量的 go-routines，最终将会把更多的时间话费在上下文切换上而不是运行程序（俗称抖动）。当 N 和 R 之间的数量差异越来越大，上下文切换的开销会更加突出。因此要始终将 go-routine 的数量限制为 R。并将 N 个任务分配给 R 个 go-routines。

We introduce **workers** function, which
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

1. Creates a pool of ‘R’ go-routines. No less and no more, all listening to the ‘input’ channel referenced via closure property.
1. 创建一个包含有「R」个 go-routines 的池。不多也不少，所有对「input」channel 的监听通过闭包属性来引用。
2. Creates go-routines that can kill itself if the input channel is closed by checking the ok parameter every time inside the for loop.
2. 创建可以通过在 for 循环内每次检查 ok 参数来关闭输入 channel 的自定义程序。
3. Returns the input channel to allow the caller function to assign tasks to the pool.
3. 返回 input channel 来允许调用者函数分配任务给池。
4. Takes in a ‘task’ argument to allow the caller function to define the body of the go-routines.
4. 使用「task」参数来允许调用函数定义 go-routines 的主体。

## Usage
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

Here, (Point #1) By cleverly adding the call to acknowledgement channel using closure property in the (Point #2) definition for the task argument of the workers function, we make sure (Point #3) the main function has a way to figure out whether all go-routines in the pool have completed their tasks or not. Although this works, this is not good practice. All logic related to the go-routines should be contained within workers itself, since they were created in it. The main function shouldn’t have to know the inner working details of the workers function.
通过将语句（Point #1）添加到 worker 方法中（Point #2），闭包属性巧妙的在任务参数定义中添加了对确认 channel 的调用，我们使用这个循环（Point #3）来使 main 函数有一个机制去知道池中的所有 go-routine 是否都完成了任务。所有和 go-routines 相关的逻辑都应该包含在 worker 自己中，因为它们是在其中创建的。main 函数不应该知道内部 worker 函数们的工作细节。

Therefore, to implement complete abstraction, we are going to introduce a “climax” function that runs only after all go-routines in the pool have completed. This is accomplished by setting up another go-routine that solely checks the status of the pool. Also different problem statements would require channels of different type. The same int channel cannot be used in all situations. Therefore, in order to write a more generic workers function, we will redefine workers function using [empty interface](https://tour.golang.org/methods/14).
因此，为了实现完全的抽象，我们要引入一个『高潮』函数，只有在池中所有 go-routine 全部完成之后才运行。这是通过设置另一个单独检查池状态的 go-routine 来实现的，另外不同的问题需要不同类型的 channel 类型。相同的 int cannel 不能在所有情况下使用，所以，为了写一个更通用的 worker 函数，我们将使用[空接口类型](https://tour.golang.org/methods/14)重新定义一个 worker 函数。

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

With this, I have attempted to demonstrate the power of Golang. We also looked at how one can write expressive code in Golang that delivers high performance.
你看，我已经试图展示了 Golang 的力量。我们还研究了如何在 Golang 中编写高性能代码。

Do watch the Go-Routines video by Rob Pike and have a great time coding in Golang.
请观看 Rob Pike 的 Go-Routines 视频，然后和 Golang 度过一个美好的时光。

Until next time…
直到下次...

Thanks to [Prateek Nischal](https://medium.com/@prateeknischal25?source=post_page).
感谢 [Prateek Nischal](https://medium.com/@prateeknischal25?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
