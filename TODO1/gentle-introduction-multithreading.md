> * 原文地址：[A gentle introduction to multithreading](https://www.internalpointers.com/post/gentle-introduction-multithreading)
> * 原文作者：[Triangles](https://www.internalpointers.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/gentle-introduction-multithreading.md](https://github.com/xitu/gold-miner/blob/master/TODO1/gentle-introduction-multithreading.md)
> * 译者：[steinliber](https://github.com/steinliber)
> * 校对者：[Graywd](https://github.com/Graywd)，[Endone](https://github.com/Endone)

# 多线程简介

> 一步一步来接近多线程的世界

现代计算机已经具备了在同一时间执行多个操作的能力。在更先进的硬件和更智能的操作系统支持下，这个特征可以让你程序的执行和响应速度变得更快。

编写能够利用这种特性的软件会很有意思，但也很棘手：这需要你理解计算机背后所发生的事情。在第一节中，我将会试着简单覆盖关于线程的知识，它是由操作系统提供能实现这种魔术的工具之一。让我们开始吧！

## 进程和线程：用正确的方式来命名事物

现代操作系统可以在同一时间运行多个程序。这就是为什么你可以在浏览器（一个程序）阅读这篇文章的同时还可以在播放器（另一个程序）上收听音乐。这里的每个程序被认为是一个正在执行的进程。操作系统知道很多软件层面的技巧来使一个进程和其他进程一起运行，也可以利用底层硬件来实现这个目的。无论哪种方式，最终的结果就是你会**感觉**所有程序都正在同时运行。

在操作系统中运行进程并不是同时执行多个操作唯一的方式。每个进程其内部还可以同时运行多个子任务，这些子任务叫做线程。你可以把线程理解为进程本身的一部分。每个进程在启动时至少会触发一个线程，被称为主线程。然后，根据程序/开发者的需要，可以在进程内启动和终止额外的线程。多线程就是指在同一个进程中运行多个线程的技术。

比如说，你的播放器就可能运行了多个线程：一个线程用来渲染界面 —— 这个线程通常是主线程，另一个用于播放音乐等等。

你可以把操作系统理解为一个包含多个进程的容器，其中的每个进程都是一个包含多个线程的容器。在本文中，我将只关注线程，但是这整个主题都很吸引人，所以值得在将来做更深入的分析。

![进程 vs 线程](https://raw.githubusercontent.com/monocasual/internalpointers-files/master/2019/02/processes-threads.png)

图 1：操作系统可以被看作一个包含进程的盒子，进程又可以被看作包含一个或多个线程的盒子。

### 进程和线程之间的区别

每个进程都有属于它自己的内存块，由操作系统负责进行分配。在默认情况下，进程之间不能共享彼此的内存块：浏览器程序无法访问分配给播放器的内存，反之亦然。就算你运行了相同的进程实例（比如你启动了浏览器两次），它们之间也不会共享内存。操作系统将每个实例视为一个新的进程，并分配其各自独立的内存。所以，在一般情况下，多个进程相互之间无法共享数据，除非它们使用一些高级的技巧 —— 所谓的[进程间通信](https://en.wikipedia.org/wiki/Inter-process_communication)。

和进程不一样，线程共享由操作系统分配给其父进程的同一块内存：这样播放器的音频引擎可以很简单的读取到主界面的数据，反之亦然。因此相较于进程，线程之间相互通信更加容易。除此之外，线程通常比进程更轻：它们占用的资源更少，创建的速度更快，这就是为什么它们也被称为轻量级进程的原因。

要让你的程序在同一时间执行多个操作，线程是一种简单的方式。如果没有线程，你就需要为每个任务写一个程序，把它们作为进程运行并通过操作系统对这些进程进行同步。相较之下，这不仅会变得更难（进程间通信比较棘手）而且速度更慢（进程比线程更重）。

### 绿色线程，纤程

到目前为止提到的线程都是操作系统层面的概念：一个进程想要启动一个新线程必须通过操作系统。然而并非每个平台都原生支持线程。绿色线程，也被称为纤程是对线程的一种模拟，使多线程程序可以在不提供线程能力的环境下工作。比如说，在虚拟机的底层操作系统并没有对线程原生支持的情况下，它还是可以实现绿色线程。

绿色线程可以更快的创建和管理，因为对其的操作完全绕过了操作系统，但是这也有缺点。我将在下一节中谈到这个话题。

“绿色线程”的名字来自于 Sun Microsystem 的绿色团队，他们在 90 年代设计了 Java 最初 的线程库。现在，Java 不再使用绿色线程：它们在 2000 年的时候被切换成了原生线程。其它一些像 Go，Haskell 或者 Ruby 等编程语言 —— 它们采用了和绿色线程相同的实现而没有用原生线程。

## 线程是用来干嘛的

为什么一个进程应该使用多个线程？就像我之前提到的，并行处理可以极大加快速度。假设你要在电影编辑器中渲染一部电影。这个编辑器足够智能的话，它可以将渲染操作分散到多个线程中，每个线程负责处理电影的一部分。这样的话如果用一个线程处理该任务要一个小时，那么使用两个线程则需要 30 分钟；使用 4 个线程要 15 分钟，以此类推。

真的有那么简单吗？这里有三点需要考虑：

1. 并不是每个程序都需要多线程。如果你的应用执行的是顺序操作或者等待用户做一些事情，多线程可能并没有那么好；
2. 你不能只是简单在应用中增加更多的线程，来让它运行更快：每个子任务都必须经过仔细的思考和设计从而实现并行操作；
3. 并不能百分百保证线程将真正并行的执行操作（即**同时执行**）：它实际上取决于程序运行的底层硬件。

最后至关重要的一点：如果你的计算机不支持在同一时间执行多个操作，操作系统就会伪装成它们是那样运行的。我们之后将会马上看到这个。目前，让我们把并发理解成**我们看起来**任务在同时运行，而真正的并行就是像字面上理解的那样，任务在同一时间运行。

![并发 vs 并行](https://raw.githubusercontent.com/monocasual/internalpointers-files/master/2019/02/concurrency-parallelism.png)

图 2：并行是并发的子集。

## 是什么使并发和并行成为可能

计算机的中央处理单元（CPU）负责运行程序的繁重工作。它由几部分组成，其中主要的部分叫做核心：这就是实际执行计算的地方。一个核心在同一时间只能执行一个操作。

无疑，这是核心一个主要的缺点。因此，操作系统层面提供了先进的技术使用户能够同时运行多个进程（或线程），特别是在图形环境中，甚至在单核机器上。其中最重要的方式叫做抢占式多任务处理，这里面的抢占式是指可以控制中断正在运行的任务，切换到另一个任务，一段时间后再恢复执行之前运行任务的能力。

因此如果你的 CPU 只有一个核心，那么操作系统的一部分工作就是把这个单核的计算能力分配到多个进程或线程中，这些进程或线程会一个接一个地循环执行。这种操作会给你一种多个程序在并行运行的错觉，如果是使用了多线程，就会觉得这个程序在同时做很多事。这满足了并发性，但是并不是真的并行 —— 即**同时**运行进程的能力仍然是缺失的。

目前现代 CPU 都会有多个核心，其中每个核心同一时间执行一次独立的操作。这意味着在多核的情况下真正的并行是可以实现的。比如说，我的 Intel Core i7 处理器有 4 个核心：它可以同时运行 4 个不同的进程和线程。

操作系统可以检测 CPU 内部核心的数量并为其中的每一个都分配进程或者线程。只要操作系统喜欢，线程可以被分配到其中的任何一个核心，并且这种调度对于运行的程序来讲是完全透明的。另外如果所有核心都在忙的话，抢占式多任务就会参与其中进行调度。这就可以让你能够运行比计算机实际可用核心数量更多的进程和线程。

### 多线程应用跑在一个单独的核心：这有意义吗？

在单核机器上是不可能实现真正意义上的并行的。然而，如果你的应用可以从多线程中获益，那在单核机器上跑多线程应用还是有意义的。这种情况下当一个进程使用多线程的时候，即使其中的一个线程在执行比较慢或者阻塞的任务，抢占式多任务机制还是可以让应用保持运行。

比如说你正在开发一个桌面应用，它会从一个很慢的磁盘读取一些数据。如果你只是写了个单线程程序，整个应用在读取数据的时候就会失去响应一直到读取完成：分配给这个唯一线程的 CPU 算力在等待磁盘唤醒的过程中被浪费。当然，操作系统还运行了除此之外的其它很多进程，但是你这个特定应用的运行将不会有任何进展。

让我们重新用多线程的方式思考你的应用。程序的线程 A 负责磁盘访问，线程 B 负责主界面。如果线程 A 由于设备读取慢而卡住，线程 B 仍运行着主界面，从而让你的应用保持响应。这是有可能的，因为有了两个线程，操作系统就可以在它们之间切换分配 CPU 资源，而不会让这个程序因为较慢的线程而卡住。

## 线程越多，问题越多

如我们所知，线程共享它们父进程的同一块内存。这使得在同一个应用的线程间交换数据非常容易。比如：一个电影编辑器可能有一大部分的共享内存用于包含视频时间线。这样的共享内存被数个用于渲染电影到文件中的工作线程读取。它们只需要一个指向该内存区域的句柄（例如指针），就可以从中读取数据并将渲染帧输出到磁盘。

只要多个线程是从同一个内存位置**读取**数据那这事情还算顺利。如果它们之中的一个或多个**写**数据到共享内存中而有其他线程正从中读取数据的时候，麻烦就开始了。这个时候会出现两个问题：


- 数据竞争 —— 当写线程修改内存的时候，读线程可能这在读这个内存。如果写线程还没有完成写操作，读线程将会得到损坏的数据；

- 竞争条件 —— 读线程应该在写线程写完之后才能读内存。如果事情发生的顺序正好相反呢？比数据竞争更微妙在于，竞争条件是指多个线程以不可预知的顺序执行它们的工作，而实际上，我们想要这些操作按照正确的顺序执行。即使对数据竞争做了保护，你的程序可能还是会触发竞争条件。

### 线程安全的概念

如果一段代码由多个线程同时执行，且正常工作，即没有数据竞争或竞争条件，那么就可以说它是线程安全的。你可能已经注意到一些程序库声明自己是线程安全的：如果你正在编写一个多线程程序，想要确保任何第三方的函数可以跨线程使用而不会触发并发问题，就要注意这些声明。

## 数据竞争的根本原因

我们知道一个 CPU 核心在同一时间只能执行一条机器指令。这样的指令叫做原子操作因为它是不可分割的：它不能被分解成更小的操作。希腊语单词 “atom”（ἄτομος; atomos）就是指**不能被切分了**。

不可分割的属性使原子操作本质上就是线程安全的。当一个线程在共享数据上执行原子写时，没有其它线程可以读取被修改了一半的数据。相反，当一个线程在共享数据上执行原子读时，它会读取在某一时刻出现在内存中的整个值。在执行原子操作的时候其它线程不可能蒙混过关插入进来，因此就不会发生数据竞争。

不幸的是，绝大部分操作都是非原子的。在一些硬件上即使是像 `x = 1` 这样简单的赋值操作也可能是由多个原子机器指令组成的，这就使赋值操作这个整体本身成为一个非原子操作。如果一个线程在读取 `x` 值的同时另一个线程在对其进行赋值就会触发数据竞争。

## 竞争条件的根本原因

抢占式多任务机制给予了操作系统对线程管理完全的控制权：它可以根据高级调度算法来开始，停止或者暂停线程。作为开发者，你不能控制线程执行的时间或者顺序。实际上，像下面这样简单的代码也不能保证按照特定的顺序启动：

```
writer_thread.start()
reader_thread.start()
```

运行这个程序几次，你就会注意到它每次运行的行为是如何的不同：有时写线程先启动，有时读线程先启动。如果你的程序需要在读之前先写，那么肯定会遇到竞争条件。

这种表现被称为非确定性：运行结果每次都会改变而你无法预测。调试受竞争条件影响的程序非常烦人，因为你不能总是以一种可控的方式来重现问题。

## 来教线程们相处：并发控制

数据竞争和竞争条件都是现实世界的问题：有些人甚至[因之而死](https://en.wikipedia.org/wiki/Therac-25)。调度多个并发线程的艺术叫做并发控制：为了处理这个问题，操作系统和编程语言提供了几个解决方案。其中最重要的是：

- 同步 —— 一种确保同一时间资源只会被一个线程使用的方式。同步就是把代码的特定部分标记为“受保护的”，这样多个并发线程就不会同时执行这段代码，避免它们把共享数据搞砸；

- 原子操作 —— 由于操作系统提供了特殊指令，许多非原子操作（像之前的赋值操作）可以变成原子操作。这样，无论其它线程如何访问共享数据，共享数据始终保持有效状态。

- 不可变数据 —— 共享数据被标记为不可变的，没有什么可以改变它：线程只能从中读取，这样就消除了根本原因。正如我们所知，只要不修改内存线程就可以安全的从相同的内存位置读取数据。这是[函数式编程](https://en.wikipedia.org/wiki/Functional_programming)背后的主要理念。

在这个关于并发的小系列下一节中，我将会讨论所有这些引人入胜的主题。敬请期待！

## 参考

8 bit avenue - [Difference between Multiprogramming, Multitasking, Multithreading and Multiprocessing](https://www.8bitavenue.com/difference-between-multiprogramming-multitasking-multithreading-and-multiprocessing/)\
Wikipedia - [Inter-process communication](https://en.wikipedia.org/wiki/Inter-process_communication)\
Wikipedia - [Process (computing)](https://en.wikipedia.org/wiki/Process_%28computing%29)\
Wikipedia - [Concurrency (computer science)](https://en.wikipedia.org/wiki/Concurrency_%28computer_science%29)\
Wikipedia - [Parallel computing](https://en.wikipedia.org/wiki/Parallel_computing)\
Wikipedia - [Multithreading (computer architecture)](https://en.wikipedia.org/wiki/Multithreading_%28computer_architecture%29)\
Stackoverflow - [Threads & Processes Vs MultiThreading & Multi-Core/MultiProcessor: How they are mapped?](https://stackoverflow.com/questions/1713554/threads-processes-vs-multithreading-multicore-multiprocessor-how-they-are)\
Stackoverflow - [Difference between core and processor?](https://stackoverflow.com/questions/19225859/difference-between-core-and-processor)\
Wikipedia - [Thread (computing)](https://en.wikipedia.org/wiki/Thread_%28computing%29)\
Wikipedia - [Computer multitasking](https://en.wikipedia.org/wiki/Computer_multitasking)\
Ibm.com - [Benefits of threads](https://www.ibm.com/support/knowledgecenter/en/ssw_aix_71/com.ibm.aix.genprogc/benefits_threads.htm)\
Haskell.org - [Parallelism vs. Concurrency](https://wiki.haskell.org/Parallelism_vs._Concurrency)\
Stackoverflow - [Can multithreading be implemented on a single processor system?](https://stackoverflow.com/questions/16116952/can-multithreading-be-implemented-on-a-single-processor-system)\
HowToGeek - [CPU Basics: Multiple CPUs, Cores, and Hyper-Threading Explained](https://www.howtogeek.com/194756/cpu-basics-multiple-cpus-cores-and-hyper-threading-explained/)\
Oracle.com - [1.2 What is a Data Race?](https://docs.oracle.com/cd/E19205-01/820-0619/geojs/index.html)\
Jaka's corner - [Data race and mutex](http://jakascorner.com/blog/2016/01/data-races.html)\
Wikipedia - [Thread safety](https://en.wikipedia.org/wiki/Thread_safety)\
Preshing on Programming - [Atomic vs. Non-Atomic Operations](https://preshing.com/20130618/atomic-vs-non-atomic-operations/)\
Wikipedia - [Green threads](https://en.wikipedia.org/wiki/Green_threads)\
Stackoverflow - [Why should I use a thread vs. using a process?](https://stackoverflow.com/questions/617787/why-should-i-use-a-thread-vs-using-a-process)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
