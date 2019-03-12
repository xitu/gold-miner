> * 原文地址：[Futures - Isolates - Event Loop](https://www.didierboelens.com/2019/01/futures---isolates---event-loop/)
> * 原文作者：[www.didierboelens.com](https://www.didierboelens.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/futures-isolates-event-loop.md](https://github.com/xitu/gold-miner/blob/master/TODO1/futures-isolates-event-loop.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：[sunui](https://github.com/sunui), [Fengziyin1234](https://github.com/Fengziyin1234)

# Flutter 异步编程：Future、Isolate 和事件循环

本文介绍了 Flutter 中不同的代码执行模式：单线程、多线程、同步和异步。

难度：**中级**

## 概要

我最近收到了一些与 **Future**、**async**、**await**、**Isolate** 以及并行执行概念相关的一些问题。

由于这些问题，一些人在处理代码的执行顺序方面遇到了麻烦。

我认为通过一篇文章来解释**异步**、**并行**处理这些概念并消除其中任何歧义是非常有用的。

* * *

## Dart 是一种单线程语言

首先，大家需要牢记，**Dart** 是**单线程**的并且 **Flutter** 依赖于 **Dart**。

> **重点**
>
> **Dart 同一时刻只执行一个操作，其他操作在该操作之后执行**，这意味着只要一个操作正在执行，它就**不会**被其他 **Dart** 代码中断。

也就是说，如果你考虑**纯粹的同步**方法，那么在它完成之前，后者将是**唯一**要执行的方法。

```dart
void myBigLoop(){
    for (int i = 0; i < 1000000; i++){
        _doSomethingSynchronously();
    }
}
```

在上面的例子中，**myBigLoop()** 方法在执行完成前永远不会被中断。因此，如果该方法需要一些时间，那么在整个方法执行期间应用将会被**阻塞**。

* * *

## **Dart** 执行模型

那么在幕后，**Dart** 是如何管理操作序列的执行的呢？

为了回答这个问题，我们需要看一下 **Dart** 的代码序列器（**事件循环**）。

当你启动一个 **Flutter**（或任何 **Dart**）应用时，将创建并启动一个新的**线程**进程（在 **Dart** 中为 「**Isolate**」）。该**线程**将是你在整个应用中唯一需要关注的。

所以，此线程创建后，Dart 会自动：

1.  初始化 2 个 FIFO（先进先出）队列（「**MicroTask**」和 「**Event**」）；
2.  并且当该方法执行完成后，执行 **main()** 方法，
3.  启动**事件循环**。

在该线程的整个生命周期中，一个被称为**事件循环**的**单一**且隐藏的进程将决定你代码的执行方式及顺序（取决于 **MicroTask** 和 **Event** 队列）。

**事件循环**是一种**无限**循环（由一个内部时钟控制），在每个**时钟周期内**，**如果没有其他 Dart 代码执行**，则执行以下操作：

```dart
void eventLoop(){
    while (microTaskQueue.isNotEmpty){
        fetchFirstMicroTaskFromQueue();
        executeThisMicroTask();
        return;
    }

    if (eventQueue.isNotEmpty){
        fetchFirstEventFromQueue();
        executeThisEventRelatedCode();
    }
}
```

正如我们看到的，**MicroTask** 队列优先于 **Event** 队列，那这 2 个队列的作用是什么呢？

### MicroTask 队列

**MicroTask** 队列用于**非常简短**且需要**异步**执行的内部动作，这些动作需要在其他事情完成之后并在将执行权送还给 **Event** 队列**之前**运行。

作为 **MicroTask** 的一个例子，你可以设想必须在资源关闭后立即释放它。由于关闭过程可能需要一些时间才能完成，你可以按照以下方式编写代码：

```dart
MyResource myResource;

...

void closeAndRelease() {
    scheduleMicroTask(_dispose);
    _close();
}

void _close(){
    // 代码以同步的方式运行
    // 以关闭资源
    ...
}

void _dispose(){
    // 代码在
    // _close() 方法
    // 完成后执行
}
```

这是大多数时候你不必使用的东西。比如，在整个 **Flutter** 源代码中 scheduleMicroTask() 方法仅被引用了 7 次。

最好优先考虑使用 **Event** 队列。

### Event 队列

**Event** 队列适用于以下参考模型

*   外部事件如
    *   I/O；
    *   手势；
    *   绘图；
    *   计时器；
    *   流；
    *   ……
*   futures

事实上，每次**外部**事件被触发时，要执行的代码都会被 **Event** 队列所引用。

一旦没有任何 **micro task** 运行，**事件循环**将考虑 **Event** 队列中的第一项并执行它。

值得注意的是，**Future** 操作也通过 **Event** 队列处理。

* * *

### Future

**Future** 是一个**异步**执行并且在未来的某一个时刻完成（或失败）的**任务**。

当你实例化一个 **Future** 时：

*   该 **Future** 的一个实例被创建并记录在由 **Dart** 管理的内部数组中；
*   需要由此 **Future** 执行的代码直接推送到 **Event** 队列中去；
*   该 **future 实例** 返回一个状态（= incomplete）；
*   如果存在下一个同步代码，执行它（**非 Future 的执行代码**）

只要**事件循环**从 **Event** 循环中获取它，被 **Future** 引用的代码将像其他任何 **Event** 一样执行。

当该代码将被执行并将完成（或失败）时，**then()** 或 **catchError()** 方法将直接被触发。

为了说明这一点，我们来看下面的例子：

```dart
void main(){
    print('Before the Future');
    Future((){
        print('Running the Future');
    }).then((_){
        print('Future is complete');
    });
    print('After the Future');
}
```

如果我们运行该代码，输出将如下所示：

```
Before the Future
After the Future
Running the Future
Future is complete
```

这是完全正确的，因为执行流程如下：

1.  print(‘Before the Future’)
2.  将 **(){print(‘Running the Future’);}** 添加到 Event 队列；
3.  print(‘After the Future’)
4.  **事件循环**获取（在第二步引用的）代码并执行它
5.  当代码执行时，它会查找 **then()** 语句并执行它

需要记住一些非常重要的事情：

> **Future** **并非**并行执行，而是遵循**事件循环**处理事件的顺序规则执行。

* * *

### Async 方法

当你使用 **async** 关键字作为方法声明的后缀时，**Dart** 会将其理解为：

*   该方法的返回值是一个 **Future**；
*   它**同步**执行该方法的代码直到**第一个 await 关键字**，然后它暂停该方法其他部分的执行；
*   一旦由 **await** 关键字引用的 **Future** 执行完成，下一行代码将立即执行。

了解这一点是**非常重要**的，因为很多开发者认为 **await** 暂停了整个流程**直到**它执行完成，但事实**并非如此**。他们忘记了**事件循环**的运作模式……

为了更好地进行说明，让我们通过以下示例并尝试指出其运行的结果。

```dart
void main() async {
  methodA();
  await methodB();
  await methodC('main');
  methodD();
}

methodA(){
  print('A');
}

methodB() async {
  print('B start');
  await methodC('B');
  print('B end');
}

methodC(String from) async {
  print('C start from $from');

  Future((){                // <== 该代码将在未来的某个时间段执行
    print('C running Future from $from');
  }).then((_){
    print('C end of Future from $from');
  });

  print('C end from $from');
}

methodD(){
  print('D');
}
```

正确的顺序是：

1.  A
2.  B start
3.  C start from B
4.  C end from B
5.  B end
6.  C start from main
7.  C end from main
8.  D
9.  C running Future from B
10.  C end of Future from B
11.  C running Future from main
12.  C end of Future from main

现在，让我们认为上述代码中的 **methodC()** 为对服务端的调用，这可能需要不均匀的时间来进行响应。我相信可以很明确地说，预测确切的执行流程可能变得非常困难。

如果你最初希望示例代码中仅在所有代码末尾执行 **methodD()** ，那么你应该按照以下方式编写代码：

```dart
void main() async {
  methodA();
  await methodB();
  await methodC('main');
  methodD();
}

methodA(){
  print('A');
}

methodB() async {
  print('B start');
  await methodC('B');
  print('B end');
}

methodC(String from) async {
  print('C start from $from');

  await Future((){                  // <== 在此处进行修改
    print('C running Future from $from');
  }).then((_){
    print('C end of Future from $from');
  });
  print('C end from $from');
}

methodD(){
  print('D');
}
```

输出序列为：

1.  A
2.  B start
3.  C start from B
4.  C running Future from B
5.  C end of Future from B
6.  C end from B
7.  B end
8.  C start from main
9.  C running Future from main
10.  C end of Future from main
11.  C end from main
12.  D

事实是通过在 **methodC()** 中定义 **Future** 的地方简单地添加 **await** 会改变整个行为。

另外，需特别谨记：

> **async** **并非**并行执行，也是遵循**事件循环**处理事件的顺序规则执行。

我想向你演示的最后一个例子如下。
运行 **method1** 和 **method2** 的输出是什么？它们会是一样的吗？

```dart
void method1(){
  List<String> myArray = <String>['a','b','c'];
  print('before loop');
  myArray.forEach((String value) async {
    await delayedPrint(value);
  });
  print('end of loop');
}

void method2() async {
  List<String> myArray = <String>['a','b','c'];
  print('before loop');
  for(int i=0; i<myArray.length; i++) {
    await delayedPrint(myArray[i]);
  }
  print('end of loop');
}

Future<void> delayedPrint(String value) async {
  await Future.delayed(Duration(seconds: 1));
  print('delayedPrint: $value');
}
```

答案：

| method1() | method2() |
| --------- | --------- |
| 1.  before loop | 1.  before loop |
| 2.  end of loop | 2.  delayedPrint: a (after 1 second) |
| 3.  delayedPrint: a (after 1 second) | 3.  delayedPrint: b (1 second later) |
| 4.  delayedPrint: b (directly after) | 4.  delayedPrint: c (1 second later) |
| 5.  delayedPrint: c (directly after) | 5.  end of loop (right after) |

你是否清楚它们行为不一样的区别以及原因呢？

答案基于这样一个事实，**method1** 使用 **forEach()** 函数来遍历数组。每次迭代时，它都会调用一个被标记为 **async**（因此是一个 **Future**）的新回调函数。执行该回调直到遇到 **await**，而后将剩余的代码推送到 **Event** 队列。一旦迭代完成，它就会执行下一个语句：“print(‘end of loop’)”。执行完成后，**事件循环** 将处理已注册的 3 个回调。

对于 **method2**，所有的内容都运行在一个相同的代码「块」中，因此能够一行一行按照顺序执行（在本例中）。

正如你所看到的，即使在看起来非常简单的代码中，我们仍然需要牢记**事件循环**的工作方式……

* * *

## 多线程

因此，我们在 Flutter 中如何并行运行代码呢？这可能吗？

**是的**，这多亏了 [Isolates](https://api.dartlang.org/stable/2.1.0/dart-isolate/Isolate-class.html)。

* * *

### Isolate 是什么？

正如前面解释过的， **Isolate** 是 **Dart** 中的 **线程**。

然而，它与常规「**线程**」的实现存在较大差异，这也是将其命名为「**Isolate**」的原因。

> 「Isolate」在 Flutter 中**并不共享内存**。不同「Isolate」之间通过「**消息**」进行通信。

* * *

### 每个 Isolate 都有自己的**事件循环**

每个「**Isolate**」都拥有自己的「**事件循环**」及队列（MicroTask 和 Event）。这意味着在一个 **Isolate** 中运行的代码与另外一个 **Isolate** 不存在任何关联。

多亏了这一点，我们可以获得**并行处理**的能力。

* * *

### 如何启动 Isolate？

根据你运行 **Isolate** 的场景，你可能需要考虑不同的方法。

#### 1. 底层解决方案

第一个解决方案不依赖任何软件包，它完全依赖 **Dart** 提供的底层 API。

##### 1.1. 第一步：创建并握手

如前所述，**Isolate** 不共享任何内存并通过消息进行交互，因此，我们需要找到一种方法在「调用者」与新的 **isolate** 之间建立通信。

每个 **Isolate** 都暴露了一个将消息传递给 **Isolate** 的被称为「**SendPort**」的**端口**。（个人觉得该名字有一些误导，因为它是一个**接收/监听**的端口，但这毕竟是官方名称）。

这意味着「**调用者**」和「**新的 isolate**」需要互相知道彼此的端口才能进行通信。这个握手的过程如下所示：

```dart
//
// 新的 isolate 端口
// 该端口将在未来使用
// 用来给 isolate 发送消息
//
SendPort newIsolateSendPort;

//
// 新 Isolate 实例
//
Isolate newIsolate;

//
// 启动一个新的 isolate
// 然后开始第一次握手
//
//
void callerCreateIsolate() async {
    //
    // 本地临时 ReceivePort
    // 用于检索新的 isolate 的 SendPort
    //
    ReceivePort receivePort = ReceivePort();

    //
    // 初始化新的 isolate
    //
    newIsolate = await Isolate.spawn(
        callbackFunction,
        receivePort.sendPort,
    );

    //
    // 检索要用于进一步通信的端口
    //
    //
    newIsolateSendPort = await receivePort.first;
}

//
// 新 isolate 的入口
//
static void callbackFunction(SendPort callerSendPort){
    //
    // 一个 SendPort 实例，用来接收来自调用者的消息
    //
    //
    ReceivePort newIsolateReceivePort = ReceivePort();

    //
    // 向调用者提供此 isolate 的 SendPort 引用
    //
    callerSendPort.send(newIsolateReceivePort.sendPort);

    //
    // 进一步流程
    //
}
```

> **约束**
> isolate 的「**入口**」**必须**是顶级函数或**静态**方法。

##### 1.2. 第二步：向 Isolate 提交消息

现在我们有了向 Isolate 发送消息的端口，让我们看看如何做到这一点：

```dart
//
// 向新 isolate 发送消息并接收回复的方法
//
//
// 在该例中，我将使用字符串进行通信操作
// （发送和接收的数据）
//
Future<String> sendReceive(String messageToBeSent) async {
    //
    // 创建一个临时端口来接收回复
    //
    ReceivePort port = ReceivePort();

    //
    // 发送消息到 Isolate，并且
    // 通知该 isolate 哪个端口是用来提供
    // 回复的
    //
    newIsolateSendPort.send(
        CrossIsolatesMessage<String>(
            sender: port.sendPort,
            message: messageToBeSent,
        )
    );

    //
    // 等待回复并返回
    //
    return port.first;
}

//
// 扩展回调函数来处理接输入报文
//
static void callbackFunction(SendPort callerSendPort){
    //
    // 初始化一个 SendPort 来接收来自调用者的消息
    //
    //
    ReceivePort newIsolateReceivePort = ReceivePort();

    //
    // 向调用者提供该 isolate 的 SendPort 引用
    //
    callerSendPort.send(newIsolateReceivePort.sendPort);

    //
    // 监听输入报文、处理并提供回复的
    // Isolate 主程序
    //
    newIsolateReceivePort.listen((dynamic message){
        CrossIsolatesMessage incomingMessage = message as CrossIsolatesMessage;

        //
        // 处理消息
        //
        String newMessage = "complemented string " + incomingMessage.message;

        //
        // 发送处理的结果
        //
        incomingMessage.sender.send(newMessage);
    });
}

//
// 帮助类
//
class CrossIsolatesMessage<T> {
    final SendPort sender;
    final T message;

    CrossIsolatesMessage({
        @required this.sender,
        this.message,
    });
}
```

##### 1.3. 第三步：销毁这个新的 Isolate 实例

当你不再需要这个新的 Isolate 实例时，最好通过以下方法释放它：

```dart
//
// 释放一个 isolate 的例程
//
void dispose(){
    newIsolate?.kill(priority: Isolate.immediate);
    newIsolate = null;
}
```

##### 1.4. 特别说明 - 单监听器流

你可能已经注意到我们正在使用**流**在「**调用者**」和新 **isolate** 之间进行通信。这些**流**的类型为：「**单监听器**」流。

* * *

#### 2. 一次性计算

如果你只需要运行一些代码来完成一些特定的工作，并且在工作完成之后不需要与 **Isolate** 进行交互，那么这里有一个非常方便的称为 [compute](https://docs.flutter.io/flutter/foundation/compute.html) 的 **Helper**。

主要包含以下功能：

*   产生一个 **Isolate**，
*   在该 isolate 上运行一个**回调函数**，并传递一些数据，
*   返回回调函数的处理结果，
*   回调执行后终止 **Isolate**。

> **约束**
>
> 「回调」函数**必须**是顶级函数并且**不能**是闭包或类中的方法（静态或非静态）。

* * *

#### 3. **重要限制**

在撰写本文时，发现这点十分重要

> Platform-Channel 通信**仅仅**由**主 isolate 支持**。该**主 isolate** 对应于应用启动时创建的 **isolate**。

也就是说，通过编程创建的 **isolate** 实例，无法实现 **Platform-Channel** 通信……

不过，还是有一个解决方法的……请参考[此连接](https://github.com/flutter/flutter/issues/13937)以获得关于此主题的讨论。

* * *

### 我应该什么时候使用 Futures 和 Isolate？

用户将根据不同的因素来评估应用的质量，比如：

*   特性
*   外观
*   用户友好性
*   ……

你的应用可以满足以上所有因素，但如果用户在一些处理过程中遇到了**卡顿**，这极有可能对你不利。

因此，以下是你在开发过程中应该系统考虑的一些点：

1.  如果代码片段**不能**被中断，使用**传统**的同步过程（一个或多个相互调用的方法）；
2.  如果代码片段可以独立运行**而不**影响应用的性能，可以考虑通过 **Future** 使用**事件循环**；
3.  如果繁重的处理可能需要一些时间才能完成，并且可能影响应用的性能，考虑使用 **Isolate**。

换句话说，建议尽可能地使用 **Future**（直接或间接地通过 **async** 方法），因为一旦**事件循环**拥有空闲时间，这些 **Future** 的代码就会被执行。这将使用户**感觉**事情正在被并行处理（而我们现在知道事实并非如此）。

另外一个可以帮助你决定使用 **Future** 或 **Isolate** 的因素是运行某些代码所需要的平均时间。

*   如果一个方法需要几**毫秒** => **Future**
*   如果一个处理流程需要几百**毫秒** => **Isolate**

以下是一些很好的 **Isolate** 选项：

*   **JSON** 解码：解码 JSON（HttpRequest 的响应）可能需要一些时间 => 使用 **compute**
*   加密：加密可能非常耗时 => **Isolate**
*   图像处理：处理图像（比如：剪裁）确实需要一些时间来完成 => **Isolate**
*   从 Web 加载图像：该场景下，为什么不将它委托给一个完全加载后返回完整图像的 **Isolate**？

* * *

## 结论

我认为了解**事件循环**的工作原理非常重要。

同样重要的是要谨记 **Flutter**（**Dart**）是**单线程**的，因此，为了取悦用户，开发者必须确保应用运行尽可能流畅。**Future** 和 **Isolate** 是非常强大的工具，它们可以帮助你实现这一目标。

请继续关注新文章，同时……祝你编程愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
