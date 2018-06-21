> * 原文地址：[Learning Go’s Concurrency Through Illustrations](https://medium.com/@trevor4e/learning-gos-concurrency-through-illustrations-8c4aff603b3)
> * 原文作者：[Trevor Forrey](https://medium.com/@trevor4e?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/learning-gos-concurrency-through-illustrations.md](https://github.com/xitu/gold-miner/blob/master/TODO1/learning-gos-concurrency-through-illustrations.md)
> * 译者：[Elliott Zhao](https://github.com/elliott-zhao)
> * 校对者：

# 通过插图学习 Go 的并发

你很可能从各种各样的途径听说过 Go。它因为各种原因而越来越受欢迎。Go 很快，很简单，并且拥有一个很棒的社区。并发模型是学习这门语言最令人兴奋的方面之一。Go 的并发原语使创建并发、多线程的程序变得简单而有趣。我将通过插图介绍Go的并发原语，希望能让这些概念更加清晰而有助于将来的学习。本文适用于 Go 的新手，并且想要了解Go的并发原语：Go 例程和通道。

### 单线程程序与多线程程序

你可能以前写过很多单线程程序。编程中一种常见的模式是用多个函数来完成一个特定的任务，但只有在程序的前一部分为下一个函数准备好数据时才会调用它们。

![](https://cdn-images-1.medium.com/max/800/1*bFlCApzWW8EYVmSAnXcWYA.jpeg)

这就是我们设立的第一个例子，采矿程序。这个例子中的函数执行：**寻矿**，**挖矿**和**炼矿**。在我们的例子中，矿坑和矿石被表示为一个字符串数组，每个函数接收它们并返回一个“处理好的”字符串数组。对于单线程应用程序，程序设计如下。

![](https://cdn-images-1.medium.com/max/800/1*ocFND1VTSp89syQdtvestg.jpeg)

有3个主要函数。一个**寻矿者**，一个**矿工**和一个**冶炼工**。在这个版本的程序中，我们的函数在单个线程上运行，一个接一个地运行 - 而这个单线程（名为 Gary 的 gopher）需要完成所有工作。

```
func main() {
 theMine := [5]string{“rock”, “ore”, “ore”, “rock”, “ore”}
 foundOre := finder(theMine)
 minedOre := miner(foundOre)
 smelter(minedOre)
}
```

在每个函数的末尾打印出处理后的“矿石”数组，我们得到以下输出：

```
From Finder: [ore ore ore]

From Miner: [minedOre minedOre minedOre]

From Smelter: [smeltedOre smeltedOre smeltedOre]
```

这种编程风格具有易于设计的优点，但是当你想要利用多个线程并执行彼此独立的功能的时候，会发生什么情况？这是并发编程发挥作用的地方。

![](https://cdn-images-1.medium.com/max/800/1*TAzVDPM6qAZI90yPLkvI7g.jpeg)

这种采矿设计更有效率。现在多线程（gopher 们）独立工作；因此，并不是让 Gary 完成整个行动。有一个 gopher 寻找矿石，一个开采矿石，另一个冶炼矿石——可能全部在同一时间进行。

为了让我们将这种类型的功能带入我们的代码中，我们需要两件事：一种创建独立工作的 gopher 的方法，以及一种让 gopher 们相互沟通（**发送矿石**）的方法。这就是 Go 并发原语进场的地方：Go 例程和通道。

### Go 例程

Go 例程可以被认为是轻量级线程。创建 Go 例程简单到只需要将 _go_ 添加到调用函数的开始。举一个简单的例子，让我们创建两个寻矿函数，使用 _go_ 关键字调用它们，并在他们每次在矿中发现“矿石”时将其打印出来。

![](https://cdn-images-1.medium.com/max/800/1*lPX8LWWRYZRZzF9E3rSw0g.jpeg)

```
func main() {
 theMine := [5]string{“rock”, “ore”, “ore”, “rock”, “ore”}
 go finder1(theMine)
 go finder2(theMine)
 <-time.After(time.Second * 5) //你可以先忽略这个
}
```

以下是我们程序的输出结果：

```
Finder 1 found ore!
Finder 2 found ore!
Finder 1 found ore!
Finder 1 found ore!
Finder 2 found ore!
Finder 2 found ore!
```

从上面的输出中可以看到，寻矿者正在同时运行。谁先发现矿石并没有真正的顺序，并且当多次运行时，顺序并不总是相同的。

这是伟大的进步！现在我们有一个简单的方法来建立一个多线程（多 Gopher）程序，但是当我们需要我们独立的 Go 例程相互通信时会发生什么？欢迎来到神奇的**通道**世界。

### 通道

![](https://cdn-images-1.medium.com/max/800/1*9QQ_B3EqsjSa9QtjqHLAZA.jpeg)

通道允许例程彼此通信。您可以将通道视为管道，从中可以发送和接收来自其他 Go 例程的信息。

![](https://cdn-images-1.medium.com/max/800/1*_rq9tbbJ2SeTfx_j-vlbmw.jpeg)

```
myFirstChannel := make(chan string)
```

Go 例程可以在通道上**发送**和**接收**。这是通过使用指向数据的方向的箭头（<-）来完成的。

![](https://cdn-images-1.medium.com/max/800/1*KsMXEiIsh4T3Bxopc7fyzg.jpeg)

```
myFirstChannel <- "hello" // 发送
myVariable := <- myFirstChannel // 接收
```

现在通过使用一个通道，我们可以让我们的寻矿 gopher 立即将他们发现的东西发送给我们的挖矿 gopher，而无需等待全部发现。

![](https://cdn-images-1.medium.com/max/800/1*xwA5l08Fy-P8yUQAZ2HVww.jpeg)

我已经更新了示例，于是寻矿代码和挖矿函数被设置为匿名函数。如果你从来没有见过lambda函数，不要过多地关注程序的那一部分，只要知道每个函数都是用 _go_ 关键字调用的，所以它们正在在自己的例程上运行。重要的是注意 Go 例程如何使用通道 _oreChan_ 在彼此之间传递数据。**别担心，我会在最后解释匿名函数。**

```
func main() {
 theMine := [5]string{“ore1”, “ore2”, “ore3”}
 oreChan := make(chan string)

 // 寻矿者
 go func(mine [5]string) {
  for _, item := range mine {
   oreChan <- item //send
  }
 }(theMine)

 // 矿工
 go func() {
  for i := 0; i < 3; i++ {
   foundOre := <-oreChan //接收
   fmt.Println(“Miner: Received “ + foundOre + “ from finder”)
  }
 }()
 <-time.After(time.Second * 5) // 还是先忽略这个
}
```

在下面的输出中，您可以看到我们的矿工三次通过矿石通道读取，每次接收到一块“矿石”。

Miner: Received ore1 from finder

Miner: Received ore2 from finder

Miner: Received ore3 from finder

太好了，现在我们可以在程序中的不同 Go 例程（gophers）之间发送数据。在我们开始编写带有通道的复杂程序之前，让我们首先介绍一些理解通道属性的关键点。

#### 通道阻塞

在多种情况下，通道会阻塞例程。这允许我们的 Go 例程在彼此踏上各自的愉悦旅途之前先进行同步。

#### 发送阻塞

![](https://cdn-images-1.medium.com/max/800/1*1NeNS9JYuZP4iQ9OmdxZqw.jpeg)

一旦一个 Go 例程（gopher）在一个通道上发送，进行发送的 Go 例程就会阻塞，直到另一个 Go 例程收到通道发送的信息为止。

#### 接收阻塞

![](https://cdn-images-1.medium.com/max/800/1*bDwp4np-zsKhq0brOvvK9Q.jpeg)

类似于在通道上发送后的阻塞，Go例程在等待从通道获取值，但还没有发送给它的时候会阻塞。

一开始，阻塞可能有点难以理解，但你可以把它想象成两个 Go 例程（gophers）之间的交易。无论 gopher 是等待金钱还是汇款，都会等待交易中的其他合作伙伴出现。

现在我们对 Go 例程通过通道进行通信的时候会阻塞的不同方式有了一个印象，让我们讨论两种不同类型的通道：**无缓冲**，和**缓冲**。选择使用什么类型的通道可以改变你的程序的行为。

#### 无缓冲通道

![](https://cdn-images-1.medium.com/max/800/1*uBaxExhmc7yJWKYAl1wr-g.jpeg)

在之前的所有例子中，我们都使用了无缓冲的通道。它们的特殊之处在于，一次只有一条数据能够通过通道。

#### 缓冲通道

![](https://cdn-images-1.medium.com/max/800/1*4504pB8sc8Tzk19rOnJ7tA.jpeg)

在并发程序中，时序并不总是完美的。在我们的采矿案例中，我们可能会遇到这样一种情况：我们的寻矿 gopher 可以在矿工 gopher 处理一块矿石的时间内找到 3 块矿石。为了不让寻矿 gopher 把大部分时间花费在等待给矿工 gopher 的工作完成上，我们可以使用*缓冲*通道。让我们开始做一个容量为 3 的缓冲通道。

```
bufferedChan := make(chan string, 3)
```

缓冲通道的工作原理类似于无缓冲通道，仅有一点不同 —— 我们可以在需要另外的 Go 例程读取通道之前将多条数据发送到通道。

![](https://cdn-images-1.medium.com/max/800/1*17IpvEF6LJCDqLLHQJoCuA.jpeg)

```
bufferedChan := make(chan string, 3)

go func() {
 bufferedChan <- "first"
 fmt.Println("Sent 1st")
 bufferedChan <- "second"
 fmt.Println("Sent 2nd")
 bufferedChan <- "third"
 fmt.Println("Sent 3rd")
}()

<-time.After(time.Second * 1)

go func() {
 firstRead := <- bufferedChan
 fmt.Println("Receiving..")
 fmt.Println(firstRead)
 secondRead := <- bufferedChan
 fmt.Println(secondRead)
 thirdRead := <- bufferedChan
 fmt.Println(thirdRead)
}()
```

我们两个 Go 例程之间的打印顺序是：

```
Sent 1st
Sent 2nd
Sent 3rd
Receiving..
first
second
third
```

为了简单起见，我们不会在最终程序中使用缓冲通道，但了解并发工具带中可用的通道类型很重要。

> 注意：使用缓冲通道不会阻止阻塞的发生。例如，如果寻矿 gopher 比矿工快10倍，并且它们通过大小为 2 的缓冲通道进行通信，则发现 gopher 仍将在程序中多次阻塞。

### 把它们结合起来

现在凭借 Go 例程和通道的强大功能，我们可以编写一个程序，使用 Go 的并发原语来充分利用多线程。

![](https://cdn-images-1.medium.com/max/800/1*mdkQasa9ipcJZrSGajSU1A.jpeg)

```
theMine := [5]string{"rock", "ore", "ore", "rock", "ore"}
oreChannel := make(chan string)
minedOreChan := make(chan string)
// Finder
go func(mine [5]string) {
 for _, item := range mine {
  if item == "ore" {
   oreChannel <- item //在 oreChannel 上发送东西
  }
 }
}(theMine)
// Ore Breaker
go func() {
 for i := 0; i < 3; i++ {
  foundOre := <-oreChannel //从 oreChannel 上读取
  fmt.Println("From Finder: ", foundOre)
  minedOreChan <- "minedOre" //向 minedOreChan 发送
 }
}()
// Smelter
go func() {
 for i := 0; i < 3; i++ {
  minedOre := <-minedOreChan //从 minedOreChan 读取
  fmt.Println("From Miner: ", minedOre)
  fmt.Println("From Smelter: Ore is smelted")
 }
}()
<-time.After(time.Second * 5) // 还是一样，你可以忽略这些
```

程序的输出如下：

```
From Finder:  ore

From Finder:  ore

From Miner:  minedOre

From Smelter: Ore is smelted

From Miner:  minedOre

From Smelter: Ore is smelted

From Finder:  ore

From Miner:  minedOre

From Smelter: Ore is smelted
```

与我们原来的例子相比，这是一个很大的改进！现在，我们的每个函数都是独立运行在自己的 Go 例程上的。另外，每一块矿石在处理之后，都会进入我们采矿线的下一个阶段。

为了将注意力集中在了解通道和 Go 例程的基础知识上，有一些我没有提到的重要信息 —— 如果你不知道，当你开始编程时可能会造成一些麻烦。现在您已了解 Go 例程和通道的工作原理，让我们在开始使用 Go 例程和通道编写代码之前，先了解一些您应该了解的信息。

### 在出发前，你应该知道……

#### 匿名 Go 例程

![](https://cdn-images-1.medium.com/max/800/1*khLRmT0Dr_ZHN2SU1GVkaQ.jpeg)

类似于我们可以使用 _go_ 关键字设置一个可以运行自己的 Go 例程的函数，我们可以使用以下格式创建一个匿名函数来运行自己的 Go 例程：

```
// 匿名 Go 例程
go func() {
 fmt.Println("I'm running in my own go routine")
}()
```

这样，如果我们只需要调用一次函数，我们可以将它放在自己的 Go 例程中运行，而不用担心创建官方函数声明。

#### 主函数是一个 Go 例程

![](https://cdn-images-1.medium.com/max/800/1*2XfhTF9gRaS1D7PKNXHyXw.jpeg)

主程序实际上是在自己的 Go 例程中运行的！更重要的是要知道，一旦主函数返回，它将关闭其它所有正在运行的例程。这就是为什么我们在主函数底部有一个计时器 —— 它创建了一个通道，并在 5 秒后发送了一个值。

```
<-time.After(time.Second * 5) //在 5 秒后从通道接收
```

还记得一个 Go 例程是如何阻塞一个读取，直到一些东西被发送的吗？通过添加上面的代码，这正是主例程发生的情况。主例程会阻塞，给我们其他的例程 5 秒额外的生命运行。

现在有更好的方法来处理阻塞主函数，直到所有其他的 Go 例程完成。通常的做法是创建一个主函数在等待读取时阻塞的 _done_ **通道**。一旦你完成你的工作，写入这个通道，程序将结束。

![](https://cdn-images-1.medium.com/max/800/1*pMThGvvn_4DhBhcpFfrQiQ.jpeg)

```
func main() {
 doneChan := make(chan string)
 go func() {
  // Do some work…
  doneChan <- “I’m all done!”
 }()
 
 <-doneChan // 阻塞直到 Go 例程发出工作完成的信号
}
```

#### 您可以在通道上范围取值

在前面的例子中，我们让我们的矿工在 for 循环中经历了 3 次迭代读取通道。如果我们不知道究竟寻矿者会发送多少矿石，会发生什么？那么，类似于在集合上范围取值，你可以**在通道上范围取值**。

更新我们以前的矿工函数，我们可以写：

```
 // 矿工
 go func() {
  for foundOre := range oreChan {
   fmt.Println(“Miner: Received “ + foundOre + “ from finder”)
  }
 }()
```

由于矿工需要读取寻矿者发送给他的所有内容，因此在此通道上范围取值能够确保我们收到发送的所有内容。

> 注意：对通道进行范围取值将会阻塞通道，直到通道上发送另一个包裹。在发生所有发送之后，阻止Go例程阻塞的唯一方法是通过关闭通道'close(channel)'

#### 您可以在通道上进行非阻塞读取

但你刚才告诉我们的全是通道如何阻塞 Go 例程？！没错，但是有一种技术可以使用Go的 _select case_ 结构在通道上进行非阻塞式读取。通过使用下面的结构，如果有东西的话，您的 Go 例程将从通道中读取，否则运行默认情况。

```
myChan := make(chan string)
 
go func(){
 myChan <- “Message!”
}()
 
select {
 case msg := <- myChan:
  fmt.Println(msg)
 default:
  fmt.Println(“No Msg”)
}
<-time.After(time.Second * 1)
select {
 case msg := <- myChan:
  fmt.Println(msg)
 default:
  fmt.Println(“No Msg”)
}
```

运行时，此示例具有以下输出：

```
No Msg  
Message!
```

#### 您也可以在通道上进行非阻塞式发送

非阻塞发送使用相同的 _select case_ 结构来执行其非阻塞操作，唯一的区别是我们的情况看起来像发送而不是接收。

```
select {  
 case myChan <- “message”:  
  fmt.Println(“sent the message”)  
 default:  
  fmt.Println(“no message sent”)  
}
```

### 下一步学习

![](https://cdn-images-1.medium.com/max/800/1*qCzFQ2-l9vmNm6WZ4pFZqA.jpeg)

有很多讲座和博客文章涵盖通道和例程的更多细节。既然您对这些工具的目的和应用有了扎实的理解，那么您应该能够充分利用以下文章和演讲。

> [Google I/O 2012 — Go 并发模式](https://www.youtube.com/watch?v=f6kdp27TYZs&t=938s)

> [Rob Pike — ‘并发并非并行’](https://www.youtube.com/watch?v=cN_DpYBzKso)

> [GopherCon 2017: Edward Muller — Go 反模式](https://www.youtube.com/watch?v=ltqV6pDKZD8&t=1315s)

感谢您抽时间阅读。我希望你能够了解Go例程，通道以及它们为编写并发程序带来的好处。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
