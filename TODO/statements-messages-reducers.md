
> * 原文地址：[Statements, messages and reducers](https://www.cocoawithlove.com/blog/statements-messages-reducers.html)
> * 原文作者：[Matt Gallagher](https://www.cocoawithlove.com/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/statements-messages-reducers.md](https://github.com/xitu/gold-miner/blob/master/TODO/statements-messages-reducers.md)
> * 译者：[zhangqippp](https://github.com/zhangqippp)
> * 校对者：[atuooo](https://github.com/atuooo)，[sqrthree](https://github.com/sqrthree)

# 语句，消息和归约器

在优化程序的设计时，一个通常的建议是将程序拆分成小而独立的功能单元，以便我们可以隔离组件之间的联系，独立地考虑组件内部的行为。

但是如果这是你优化程序的唯一思路，那么在实践中应用它的时候就会有些困难。

在本文中，我将通过一小段代码的简单演进来向你展示如何实践上述的优化建议，最终我们将达成一个并发编程中普遍的模式（在大多数有状态的程序中都很有用），在此种模式中我们从计算单元的三个不同层面构建我们的程序：“语句”、“消息” 和 “归约器”。

> 你可以在 GitHub 上[下载本文的 Swift Playground](https://github.com/mattgallagher/CocoaWithLovePlaygrounds) 。

内容
- 
- [目标](#目标)
- [一系列语句](#一系列语句)
- [通过消息控制你的程序](#通过消息控制你的程序)
- [通过组件连接构建逻辑](#通过组件连接构建逻辑)
- [归约器](#归约器)
- [我们还能做些什么？](#我们还能做些什么)
- [结论](#结论)
- [展望…](#展望)

## 目标

本文的目的是介绍如何在程序中将状态独立起来。有很多我们可能想要这么做的原因：

1. 如果控制逻辑是简洁的，那么在单一位置的行为就很容易理解。
2. 如果控制逻辑是简洁的，模式化和理解组件之间的联系就很简单。
3. 如果只在单一的位置访问某个状态，那么改变这个访问入口的执行环境（例如队列，线程，或者一个锁的内部）将很容易，同样也可以轻易地将程序变为线程安全的或者同步的。
4. 如果状态只能以受限制的方式被访问，我们就能够更谨慎地管理依赖，并且在依赖变化时及时更新。

## 一系列语句

**语句**是命令式编程语言（如 Swift ）中的标准计算单元。语句包含赋值，函数和控制流，还可能包括逻辑结果（如状态变化）。

我知道我是在向程序员解释基本的编程术语，我只会简洁的说明。

下面是一段简单的程序，其内部的逻辑是由语句组成的：

```
func printCode(_ code: Int) {
   if let scalar = UnicodeScalar(code) {
      print(scalar)
   } else {
      print("�")
   }
}

let grinning = 0x1f600
printCode(grinning)

let rollingOnTheFloorLaughing = 0x1f923
printCode(rollingOnTheFloorLaughing)

let notAValidScalar = 0x999999
printCode(notAValidScalar)

let smirkingFace = 0x1f60f
printCode(smirkingFace)

let stuckOutTongueClosedEyes = 0x1f61d
printCode(stuckOutTongueClosedEyes)
```

这段程序会分行打印如下内容： 😀 🤣 � 😏 😝

**上面的被框起来的问号字符不是错误，代码中故意在将参数转化为 `UnicodeScalar` 失败时打印 Unicode 替代符号（`0xfffd`）。**

## 通过消息控制你的程序

纯粹由语句构建的逻辑的最大的问题在于不易于扩展。在寻求减少代码冗余的过程中自然地会导致代码被数据驱动（至少是部分驱动）。

例如，通过数据驱动上述例子可以将最后的 10 行代码减少到 4 行：

```
let codes = [0x1f600, 0x1f923, 0x999999, 0x1f60f, 0x1f61d]
for c in codes {
   printCode(c)
}
```

当然，上述例子有些过于简单，可能不能清晰地反映出这种变化。我们可以增加这个例子的复杂性来使差异更加明显。

我们将数组中的基本类型 `Int` 替换成一种需要更多处理的类型。

```
enum Instruction {
   case print
   case increment(Int)
   case set(Int)

   static func array(_ instrs: Instruction...) -> [Instruction] { return instrs }
}
```

现在，相对于简单地打印收到的每个 `Int` 值，我们的处理机需要管理一个内部的 `Int` 型的存储器和不同的 `Instruction` 值，这些 `Instruction` 值可能会用 `.set` 方法给存储器赋值，或者用 `.increment` 方法给存储器做累加，又或者用 `.print` 方法打印存储器的值。

来看一下我们会用什么代码来处理数组中的 `Instruction` 对象：

```
struct Interpreter {
   var state: Int = 0
   func printCode() {
      if let scalar = UnicodeScalar(state) {
         print(scalar)
      } else {
         print("�")
      }
   }
   mutating func handleInstruction(_ instruction: Instruction) {
      switch instruction {
      case .print: printCode()
      case .increment(let x): state += x
      case .set(let x): state = x
      }
   }
}

var interpreter = Interpreter()
let instructions = Instruction.array(
   .set(0x1f600), .print,
   .increment(0x323), .print,
   .increment(0x999999), .print,
   .set(0x1f60f), .print,
   .increment(0xe), .print
)
for i in instructions {
   interpreter.handleInstruction(i)
}
```

这段代码产生了和之前的例子一样的输出，它在内部使用了和之前类似的 `printCode` 方法，但是实际上是 `Interpreter` 结构体执行了一小段由 `instructions` 数组定义的微程序。

现在可以“更”清楚地看到我们的程序逻辑是由两个层面上的逻辑组成：

1.  `handleInstruction` 方法和 `printCode` 方法中的 Swift 语句解释和执行每一条指令。
2.  `Instructions.array` 中包含了一系列需要被解释的消息。

我们的第二层计算单元就是所谓的**消息**，它可以是任何能够被放入数据流中传递给组件的数据，这些数据流中的数据的结构本身就能够决定执行结果。

> **术语提示**：我将这些指令称为“消息”，这是沿袭了[过程演算](https://en.wikipedia.org/wiki/Process_calculus)和[参与者模式](https://en.wikipedia.org/wiki/Actor_model)中的术语用法，但有时候也会使用“命令”这个词。在某些情况下，这些消息也会被当成是一种完全的“特定作用域语言”。

## 通过组件连接构建逻辑

上一节的代码最大的问题在于它的结构并不能直观地反映出计算的结构；我们很难一眼就看出逻辑的走向。

我们需要弄明白计算的结构应该是什么样子的。我们做如下尝试：

1. 取一系列的指令
2. 将这些指令转化为一系列对内部状态的影响
3. 将消息传递给能够实现`打印`动作的第三方控制台

我们能够从执行这些任务的 `Interpreter` 结构体中识别出这几部分，但是这个结构体没有被直观地组织起来以反映出这三个步骤。

所以我们将代码重构成能够直接地展示这种联系的样子。

```
var state: Int = 0
Instruction.array(
   .set(0x1f600), .print,
   .increment(0x323), .print,
   .increment(0x999999), .print,
   .set(0x1f60f), .print,
   .increment(0xe), .print
).flatMap { (i: Instruction) -> Int? in
   switch i {
   case .print: return state
   case .increment(let x): state += x; return nil
   case .set(let x): state = x; return nil
   }
}.forEach { value in
   if let scalar = UnicodeScalar(value) {
      print(scalar)
   } else {
      print("�")
   }
}
```

这段代码依然会和之前的例子打印同样的输出。

现在我们有一个三节的管道，它能够直接地反映出上面提到的 3 点：一系列指令，解释指令并对状态值产生影响，以及输出阶段。

## 归约器

我们来看一下管道中间的 `flatMap` 这一节。为什么这一节最重要？

不是因为 `flatMap` 函数本身而是因为我只在这一节中使用了捕获闭包。 `state` 变量只在这一节中被捕获和操作，这相当于 `state` 的值是 `flatMap` 闭包的一个私有变量。这个状态在 `flatMap` 这一节之外只能被间接地访问 —— 即只能通过提供一个 `Instruction` 输入来设置，同样也只能通过 `flatMap` 这一节中选择发送的 `Int` 值来进行访问。

我们可以将这一节抽象为如下模型：

![Figure 1: a diagram of a reducer, its state and messages](https://www.cocoawithlove.com/assets/blog/reducer.svg)

作为“归约器”的管道中某一节的图表
 
此图中每个 `a` 变量的值都是 `Instruction` 值。 `x` 变量的值是 `state` ， `b` 变量的值是将被发送的 `Int?` 类型的值。

我将之称为**归约器**，这是我想要讨论的第三层计算单元。归约器是一种带有身份标识（ Swift 中的一种引用类型）的实体，其内部状态只能通过出入的消息进行访问。

我说归约器是我想讨论的第三层计算单元是因为我没有考虑归约器内部的逻辑，而是把归约器（典型的 Swift 语句影响被包装的状态）当做一个由其和其它单元的连接定义的黑盒单元来考虑，这些黑盒单元是我们设计更高层逻辑的基础。

另一种解释是当语句**在**上下文中执行逻辑时，归约器通过在执行环境之间跨越形成逻辑。

我使用一个捕获闭包来将一个 `flatMap` 函数和一个 `Int` 变量组成了一个归约器，但大部分归约器是`类`的实例，这些实例会将它们的状态维持的更加紧密，并且帮助我们把逻辑整合到更大的逻辑结构中。

> 用“归约器”这个词来描述这种结构来自于编程语言语义学中的[归约语义学](https://en.wikipedia.org/wiki/Operational_semantics#Reduction_semantics)。有一个奇怪的术语转换，“归约器”也被称为“累加器”，尽管这两个词在语义上近乎对立。这是一个视角的问题：“归约器”是指将输入的消息流归约成为一个单一的状态值；而“累加器”则是指在输入消息到达时这种结构会将新的信息累加到它内部的状态上。

## 我们还能做些什么？

我们可以将归约器的抽象替换为完全不同的机制。

我们可以迁移之前的代码，将对 Swift `数组`值的操作迁移成使用 CwlSignal 响应式编程框架，这其中的工作量不只是拖拽操作这么简单。这样做能够给我们提供异步能力或者给程序的不同部分提供真实的交流通道。

代码如下：

```
Signal<Instruction>.from(values: [
   .set(0x1f600), .print,
   .increment(0x323), .print,
   .increment(0x999999), .print,
   .set(0x1f60f), .print,
   .increment(0xe), .print
]).filterMap(initialState: 0) { (state: inout Int, i: Instruction) -> Int? in
   switch i {
   case .print: return state
   case .increment(let x): state += x; return nil
   case .set(let x): state = x; return nil
   }
}.subscribeValuesAndKeepAlive { value in
   if let scalar = UnicodeScalar(value) {
      print(scalar)
   } else {
      print("�")
   }
   return true
}
```

这里的 `filterMap` 功能更适合作为一个归约器，因为它提供了真实的内部私有状态作为 API 的一部分 —— 没有更多的被捕获变量需要建立私有状态 —— 它在语义上等同于之前的 `flatMap` ，因为它映射了信号中的一系列值并且过滤掉了可选项。

抽象之间的简单变化是可实现的，因为归约器的内容取决于消息，而不是归约器机制本身。

除了归约器之外是否还有其它层次的计算单元？我不清楚，至少我没遇到过。我们已经解决了状态封装的问题，所以任何额外的层次都将是新的问题。但是，如果人工神经网络可以具有“深度学习”，那么为什么编程不能有“深度语义学”？显然，这是未来的趋势 😉。

## 结论

> 你可以在 GitHub 上[下载本文的 Swift Playground](https://github.com/mattgallagher/CocoaWithLovePlaygrounds)。

这里的结论是，将程序分解成小而隔离的组件的最自然的方法是以三个不同的层次组织你的程序：

1. 归约器中的状态代码被限制为只有进出的消息能够访问
2. 能够将归约器执行为指定状态的消息
3. 归约器形成的图表结构组成更高级的程序逻辑

这些都不是什么新思路；这一切都源自于 20 世纪 70 年代中期的并行计算理论，而且自从 20 世纪 90 年代初“归约语义学”确立以来，这些思路并没有大的改变。

当然，这并不意味着人们总是遵循这些好的思路。面向对象编程是 20 世纪 90 年代和 21 世纪初人们曾经试图解决所有编程问题的锤子，你可以从对象中构建一个归约器，但并不意味着所有的对象都是归约器。对象中没有限制的接口会使状态，依赖和接口耦合的维护变得非常困难。

然而，我们可以直接将对象建模为归约器，只要通过将公共接口简化成如下内容：

- 构建器
- 接受消息输入的方法
- 订阅或者其它连接到消息输出的方法

在这种情况下，**限制**接口的功能会极大地提供维护和迭代设计的能力。

### 展望…

在[通过组件连接构建逻辑](#通过组件连接构建逻辑)这一节的例子中，我对 `flatMap`（不是单子）使用了有争议的定义。在我的下一篇文章中，我将讨论为什么单子被许多功能程序员认为是基本计算单位，而在命令式编程中的严格实现有时却并不如非单子的转换有用。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
