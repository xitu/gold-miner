# The Event Loop and Dart
Dart中的异步代码无处不在。 许多库函数返回Future对象，您可以注册处理程序以响应鼠标单击，文件I / O完成和计时器到期等事件。

本文介绍了Dart的事件循环体系结构，以便您可以编写更好的异步代码，减少意外。 您将学习安排未来任务的选项，并且您将能够预测执行的顺序。

注意：本文中的所有内容都适用于本机运行的Dart应用程序（使用Dart VM）和已编译为JavaScript的Dart应用程序（dart2js的输出）。 本文使用术语Dart来区分Dart应用程序和用其他语言编写的软件。
在阅读本文之前，您应该熟悉期货和错误处理的基础知识。

# Basic concepts
如果您编写了UI代码，那么您可能熟悉事件循环和事件队列的概念。 它们确保一次处理一个图形操作和鼠标点击等事件。

# Event loops and queues
事件循环的作用是从事件队列中获取一个项目并处理它，只要队列中有项目，就重复这两个步骤。
![](https://upload-images.jianshu.io/upload_images/901318-93ce8157d82a9682.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

队列中的项可能表示用户输入，文件I / O通知，计时器等。 例如，这是包含计时器和用户输入事件的事件队列的图片：
![](https://upload-images.jianshu.io/upload_images/901318-1a38056a171ca09d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

所有这些可能都是您熟悉的非Dart语言所熟悉的。 现在让我们来谈谈它如何适应Dart平台。

# Dart’s single thread of execution

一旦Dart函数开始执行，它将继续执行直到它退出。 换句话说，Dart函数不能被其他Dart代码中断。

注意：Dart命令行应用程序可以通过创建隔离来并行运行代码。 （Dart Web应用程序目前无法创建其他隔离区，但它们可以创建工作程序。）隔离区不共享内存; 它们就像通过传递消息而相互通信的独立应用程序。 除了应用程序明确在其他隔离区或工作程序中运行的代码之外，所有应用程序的代码都在应用程序的主隔离区中运行。 有关详细信息，请参阅本文后面的“使用隔离区或工作程序”。

如下图所示，Dart应用程序在其主隔离执行app的main（）函数时开始执行。 main（）退出后，主隔离的线程开始逐个处理应用程序事件队列中的任何项目。
![](https://upload-images.jianshu.io/upload_images/901318-030c36fef1b23f66.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
实际上，这是一个轻微的过度简化。

# Dart’s event loop and queues
Dart应用程序具有单个事件循环，其中包含两个队列 - 事件队列和微任务队列。

事件队列包含所有外部事件：I / O，鼠标事件，绘图事件，计时器，Dart隔离之间的消息等。

微任务队列是必要的，因为事件处理代码有时需要稍后完成任务，但在将控制权返回给事件循环之前。例如，当可观察对象发生更改时，它会将多个突变更改组合在一起并以异步方式报告它们。微任务队列允许可观察对象在DOM显示不一致状态之前报告这些突变变化。

事件队列包含来自Dart和系统中其他位置的事件。目前，微任务队列仅包含源自Dart代码的条目，但我们希望Web实现插入浏览器微任务队列。 （有关最新状态，请参阅dartbug.com/13433。）

如下图所示，当main（）退出时，事件循环开始工作。首先，它按FIFO顺序执行任何微任务。然后它出列并处理事件队列中的第一个项目。然后它重复循环：执行所有微任务，然后处理事件队列中的下一个项目。一旦两个队列都为空并且不再需要事件，应用程序的嵌入器（例如浏览器或测试框架）就可以处理该应用程序。

注意：如果Web应用程序的用户关闭其窗口，则Web应用程序可能会在其事件队列为空之前退出。
![](https://upload-images.jianshu.io/upload_images/901318-a9e64b9a5ccb9f50.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
重要提示：当事件循环从微任务队列执行任务时，事件队列被卡住：应用程序无法绘制图形，处理鼠标点击，对I / O做出反应等等。

虽然您可以预测任务执行的顺序，但您无法准确预测事件循环何时将任务从队列中删除。 Dart事件处理系统基于单线程循环; 它不是基于刻度或任何其他类型的时间测量。 例如，在创建延迟任务时，会在您指定的时间将事件排入队列。 但是，直到处理事件队列中的所有内容（以及微任务队列中的每个任务）之前，才能处理该事件。

#Tip: Chain futures to specify task order
如果您的代码具有依赖关系，请将它们显式化。 显式依赖关系有助于其他开发人员理解您的代码，并使您的程序更能抵抗代码重构。

以下是错误编码方式的示例：
![屏幕快照 2018-12-30 12.21.10.png](https://upload-images.jianshu.io/upload_images/901318-c06bcab204c3d91f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
相反，编写如下代码：
![屏幕快照 2018-12-30 12.21.17.png](https://upload-images.jianshu.io/upload_images/901318-8f9adcca84ab9da1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
更好的代码使用then（）来指定必须先设置变量才能使用它。 （如果希望代码执行即使发生错误，也可以使用whenComplete（）而不是then（）。）

如果使用变量需要花费时间并且可以在以后完成，请考虑将该代码放在新的Future中：
![屏幕快照 2018-12-30 12.21.30.png](https://upload-images.jianshu.io/upload_images/901318-c8525862098e0a15.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
使用新的Future为事件循环提供了处理事件队列中其他事件的机会。 下一节详细介绍了稍后运行的计划代码。
#How to schedule a task
当您需要指定稍后要执行的代码时，可以使用dart：async库提供的以下API：

Future类，它将一个项添加到事件队列的末尾。
顶级scheduleMicrotask（）函数，它将项添加到微任务队列的末尾。
注意：scheduleMicrotask（）函数曾被命名为runAsync（）。 （见公告。）

使用这些API的示例位于Event queue：new Future（）和Microtask queue：scheduleMicrotask（）下的下一节中。
使用适当的队列（通常是：事件队列）
尽可能使用Future在事件队列上安排任务。 使用事件队列有助于缩短微任务队列的速度，从而降低微任务队列使事件队列匮乏的可能性。

如果在处理事件队列中的任何项之前绝对必须完成任务，那么通常应该立即执行该函数。 如果不能，则使用scheduleMicrotask（）将项添加到微任务队列。 例如，在Web应用程序中使用微任务来避免过早释放js-interop代理或结束IndexedDB事务或事件处理程序。
![屏幕快照 2018-12-30 12.24.18.png](https://upload-images.jianshu.io/upload_images/901318-cf6e3e891b39d35e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#Event queue: new Future()
要在事件队列上安排任务，请使用new Future（）或new Future.delayed（）。 这些是dart：async库中定义的两个Future构造函数。

注意：您也可以使用Timer来安排任务，但如果任务中发生任何未捕获的异常，您的应用程序将退出。 相反，我们推荐Future，它建立在Timer之上，并添加了检测任务完成和响应错误等功能。

要立即将项目放在事件队列中，请使用new Future（）：
![屏幕快照 2018-12-30 12.25.06.png](https://upload-images.jianshu.io/upload_images/901318-433b8b42262fbe27.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
您可以添加对then（）或whenComplete（）的调用，以在新Future完成后立即执行某些代码。 例如，以下代码在新Future的任务出列时打印“42”：
![屏幕快照 2018-12-30 12.25.17.png](https://upload-images.jianshu.io/upload_images/901318-47e6cd78f15ca493.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
要在一段时间后将项目排入队列，请使用新的Future.delayed（）：
![屏幕快照 2018-12-30 12.25.26.png](https://upload-images.jianshu.io/upload_images/901318-fccc8931317d8cc2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
虽然前面的示例在一秒钟之后将任务添加到事件队列，但是在主隔离空闲，微任务队列为空以及事件队列中先前排队的条目消失之前，该任务无法执行。例如，如果main（）函数或事件处理程序正在运行昂贵的计算，则该任务在计算完成之后才能执行。在这种情况下，延迟可能远远超过一秒。

提示：如果您在Web应用程序中为动画绘制帧，请不要使用Future（或Timer或Stream）。相反，使用animationFrame，它是requestAnimationFrame的Dart接口。

关于未来的有趣事实：

传递给Future的then（）方法的函数在Future完成时立即执行。 （该函数未入队，只是被调用。）
如果在调用then之前已经完成了Future，那么就会在微任务队列中添加一个任务，该任务执行传递给then（）的函数。
Future（）和Future.delayed（）构造函数不会立即完成;他们将一个项添加到事件队列中。
Future.value（）构造函数在微任务中完成，类​​似于＃2。
Future.sync（）构造函数立即执行其函数参数（除非该函数返回Future）在微任务中完成，类​​似于＃2。

#Microtask queue: scheduleMicrotask()
dart：async库将scheduleMicrotask（）定义为顶级函数。 您可以像这样调用scheduleMicrotask（）：
由于错误9001和9002，第一次调用scheduleMicrotask（）会在事件队列上调度任务;此任务创建微任务队列并将指定的函数排入scheduleMicrotask（）。只要微任务队列至少有一个条目，对scheduleMicrotask（）的后续调用就会正确地添加到微任务队列中。一旦微任务队列为空，就必须在下次调用scheduleMicrotask（）时再次创建它。

这些错误的结果：您使用scheduleMicrotask（）调度的第一个任务看起来就像是在事件队列中。

解决方法是在第一次调用new Future（）之前先调用scheduleMicrotask（）。这会在事件队列上执行其他任务之前创建微任务队列。但是，它不会阻止将外部事件添加到事件队列中。当你有一个延迟的任务时它也没有帮助。

将任务添加到微任务队列的另一种方法是在已经完成的Future上调用then（）。有关更多信息，请参阅上一节。
# Use isolates or workers if necessary
如果您要运行计算密集型任务，该怎么办？为了使您的应用程序保持响应，您应该将任务放入其自己的隔离或工作者。隔离可能在单独的进程或线程中运行，具体取决于Dart实现。在1.0中，我们不希望Web应用程序支持隔离或Dart语言工作者。但是，您可以使用dart：html Worker类将JavaScript工作程序添加到Dart Web应用程序。

你应该使用多少个菌株？对于计算密集型任务，通常应该使用尽可能多的可用CPU的隔离区。如果它们纯粹是计算的话，任何额外的分离物都会被浪费掉。但是，如果隔离区执行异步调用 - 例如执行I / O--那么它们不会花太多时间在CPU上，因此拥有比CPU更多的隔离区是有意义的。

如果这是一个适合您的应用程序的良好架构，您还可以使用比CPU更多的隔离。例如，您可以为每个功能使用单独的隔离，或者在需要确保不共享数据时使用。
#Test your understanding
现在您已经阅读了有关计划任务的所有内容，让我们测试您的理解。

请记住，您不应该依赖Dart的事件队列实现来指定任务顺序。 实现可能会改变，Future的then（）和whenComplete（）方法是更好的选择。 如果你能正确回答这些问题，你会不会觉得聪明？
#Question #1
这个样本打印出来的是什么？

![](https://upload-images.jianshu.io/upload_images/901318-d1fa9063dc537f21.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

The answer:

![屏幕快照 2018-12-30 12.30.03.png](https://upload-images.jianshu.io/upload_images/901318-fc8e1db63716af46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
该顺序应该是您所期望的，因为示例的代码分三批执行：

main（）函数中的代码
微任务队列中的任务（scheduleMicrotask（））
事件队列中的任务（new Future（）或new Future.delayed（））
请记住，main（）函数中的所有调用都是同步执行，从头到尾完成。 首先main（）调用print（），然后调用scheduleMicrotask（），然后调用new Future.delayed（），然后调用new Future（），依此类推。 只有回调 - 指定为scheduleMicrotask（），new Future.delayed（）和new Future（）的参数的闭包体中的代码 - 稍后执行。

注意：目前，如果您注释掉第一次调用scheduleMicrotask（），那么期货＃2和＃3的回调将在微任务＃2之前执行。 这是由于错误9001和9002，如Microtask queue：scheduleMicrotask（）中所讨论的。

#Question #2
这是一个更复杂的例子。 如果你能正确预测这段代码的输出，你就会得到一颗金星。
![屏幕快照 2018-12-30 12.31.18.png](https://upload-images.jianshu.io/upload_images/901318-28108e146deeec28.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

The output, assuming bugs 9001/9002 aren’t fixed:
![屏幕快照 2018-12-30 12.31.50.png](https://upload-images.jianshu.io/upload_images/901318-909068baf5b3b4d8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

注意：由于错误9001/9002，微任务＃0在未来＃4之后执行;它应该在未来＃3之前执行。这个错误出现了，因为在未来＃2b执行时，没有微任务排队，因此微任务＃0会在事件队列上产生一个新任务，从而创建一个新的微任务队列。该微任务队列包含微任务＃0。如果你注释掉微任务＃1，那么微任务就会在未来＃2c和未来＃3之前出现在一起。

像以前一样，执行main（）函数，然后执行微任务队列上的所有操作，然后执行事件队列上的任务。以下是一些有趣的观点：

当future（）回调为将来3调用new Future（）时，它会创建一个新任务（＃3a），它被添加到事件队列的末尾。
所有then（）回调都会在调用Future完成后立即执行。因此，在控制返回到嵌入器之前，将来的2,2a，2b和2c一次执行。同样，未来3a和3b将一次性执行。
如果你将3a代码从那时（（_）=>新的Future（...））更改为then（（_）{new Future（...）;}），那么“future＃3b”会更早出现（之后）未来＃3，而不是未来＃3a）。原因是从回调中返回Future是你如何得到then（）（它本身返回一个新的Future）将这两个Futures链接在一起，这样当回调返回的Future完成后，then（）返回的Future就完成了。 。有关更多信息，请参阅then（）参考。

#Annotated sample and output
以下是一些可能澄清问题＃2答案的数字。 首先，这是带注释的程序源：
![屏幕快照 2018-12-30 12.32.58.png](https://upload-images.jianshu.io/upload_images/901318-a1f26c05eaed358c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

And here’s what the queues and output look like at various points in time, assuming no external events come in:
![](https://upload-images.jianshu.io/upload_images/901318-8884c216775a2838.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#Summary
您现在应该了解Dart的事件循环以及如何安排任务。以下是Dart中事件循环的一些主要概念：

Dart应用程序的事件循环从两个队列执行任务：事件队列和微任务队列。
事件队列包含来自Dart（期货，计时器，隔离消息等）和系统（用户操作，I / O等）的条目。
目前，微任务队列只有来自Dart的条目，但我们希望它与浏览器微任务队列合并。
事件循环在出列并处理事件队列中的下一个项之前清空微任务队列。
一旦两个队列都为空，应用程序已完成其工作并（取决于其嵌入器）可以退出。
main（）函数以及微任务和事件队列中的所有项都在Dart应用程序的主隔离上运行。
安排任务时，请遵循以下规则：

如果可能，将其放在事件队列中（使用新的Future（）或新的Future.delayed（））。
使用Future的then（）或whenComplete（）方法指定任务顺序。
为避免使事件循环挨饿，请将微任务队列保持尽可能短。
要使应用程序保持响应，请在任一事件循环中避免计算密集型任务。
要执行计算密集型任务，请创建其他隔离区或工作程序。
在编写异步代码时，您可能会发现这些资源很有帮助：

期货和错误处理
dart：async  - 库浏览的异步编程部分
dart：异步API参考

