> * 原文地址：[Why should you learn Go?](https://medium.com/@kevalpatel2106/why-should-you-learn-go-f607681fad65)
> * 原文作者：[Keval Patel](https://medium.com/@kevalpatel2106)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-should-you-learn-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-should-you-learn-go.md)
> * 译者：[dior](https://github.com/todaycoder001)
> * 校对者：

# Why should you learn Go?
# 为什么你要学习 Go？
![Image from: [http://kirael-art.deviantart.com/art/Go-lang-Mascot-458285682](http://kirael-art.deviantart.com/art/Go-lang-Mascot-458285682)](https://cdn-images-1.medium.com/max/2000/1*vHUiXvBE0p0fLRwFHZuAYw.gif)

> “[Go will be the server language of the future.](https://twitter.com/tobi/status/326086379207536640)” — Tobias Lütke, Shopify

In past couple of years, there is a rise of new programming language: [**Go or GoLang**](https://golang.org/). Nothing makes a developer crazy than a new programming language, right? So, I started learning Go 4 to 5 months ago and here I am going to tell you about why you should also learn this new language.

在过去几年，有一门崛起的新语言：[**Go 或者 GoLang**](https://golang.org/)。没有什么能使开发者痴迷于一门新的编程语言，不是么? 因此，我在4、5个月之前开始学习Go，在这里，我将告诉你，你为什么也要学习这门语言。

I am not going to teach you, how you can write “Hello World!!” in this article. There are lots of other articles online for that. **I am going the explain current stage of computer hardware-software and why we need new language like Go?** Because if there isn’t any problem, then we don’t need solution, right?

在这篇文章中，我不打算教你怎样写 “Hello World!!”。网上有许多其他的文章会教你。**我将阐述软硬件发展的现状以及为什么我们要学习像Go这样的新语言？**因为如果没有任何问题，我们就不需要解决方案，不是么？

## Hardware limitations:
## 硬件限制

**[Moore’s law](http://www.investopedia.com/terms/m/mooreslaw.asp) is failing.**

**[摩尔定律](http://www.investopedia.com/terms/m/mooreslaw.asp)正在失效。**

First Pentium 4 processor with 3.0GHz clock speed was [introduced back in 2004](http://www.informit.com/articles/article.aspx?p=339073) by Intel. Today, my [Mackbook Pro 2016](http://www.apple.com/macbook-pro/specs/) has clock speed of 2.9GHz. So, nearly in one decade, there is not too much gain in the raw processing power. You can see the comparison of increasing the processing power with the time in below chart.

英特尔公司在[2004年推出](http://www.informit.com/articles/article.aspx?p=339073)了第一款具有 3.0 GHz 时钟速度的奔腾4处理器。如今，我的[2016款 MacBook Pro](http://www.apple.com/macbook-pro/specs/)的时钟速度为2.9GHz。因此，差不多十年，原始处理能力都没有太多的增加。你可以在下图中看到处理能力的增长与时间的关系。

![](https://cdn-images-1.medium.com/max/2000/1*Azz7YwzYYR6lDKFj8iIGZg.png)

From the above chart you can see that the single-thread performance and the frequency of the processor remained steady for almost a decade. If you are thinking that adding more transistor is the solution, then you are wrong. This is because at smaller scale some quantum properties starts to emerge (like tunneling) and because it actually costs more to put more transistors ([why?](https://www.quora.com/What-is-Quantum-Tunneling-Limit-How-does-it-limit-the-size-of-a-transistor)) and the number of transistors you can add per dollar starts to fall.

从上面的图表可以看出，单线程的性能和处理器的频率在近十年几乎保持稳定。如果你认为添加更多的晶体管是一种解决问题的方法，那你就错了。这是因为在较小规模上，量子特性开始显现（例如：隧道），放更多的晶体管花费也会越多([为什么？](https://www.quora.com/What-is-Quantum-Tunneling-Limit-How-does-it-limit-the-size-of-a-transistor))，而且，每美元可以添加晶体管的数量也开始下降。

So, for the solution of above problem,

所以，针对上述问题的解决方案，

* Manufacturers started adding more and more cores to the processor. Nowadays we have quad-core and octa-core CPUs available.
  
* 厂商开始向处理器添加越来越多的内核。如今，我们已经有四核和八核的 CPU 可用

* We also introduced hyper-threading.

* 我们还介绍了超线程。

* Added more cache to the processor to increase the performance.

* 为处理器添加更多的缓存以提升性能。

But above solutions have its own limitations too. We cannot add more and more cache to the processor to increase performance as cache have physical limits: the bigger the cache, the slower it gets. Adding more core to the processor has its cost too. Also, that cannot scale to indefinitely. These multi-core processors can run multiple threads simultaneously and that brings concurrency to the picture. We’ll discuss it later.

但是，以上方案也有它们的限制。我们无法向处理器添加更多的缓存以提升性能，因为缓存具有物理限制：缓存越大，速度越慢。添加更多的内核到处理器也有它的成本。而且，这也无法无限扩展。这些多核处理器能同时运行多个线程，同时也能带来并发能力。我们稍后会讨论它。

So, if we cannot rely on the hardware improvements, the only way to go is more efficient software to increase the performance. But sadly, modern programming language are not much efficient.

因此，如过我们不能依赖于硬件的改进，唯一的出路就是找到一个高效的软件来提升性能，但遗憾的是，现代编程语言都不是那么高效。

> “Modern processors are a like nitro fueled funny cars, they excel at the quarter mile. Unfortunately modern programming languages are like Monte Carlo, they are full of twists and turns.” — [David Ungar](https://en.wikipedia.org/wiki/David_Ungar)

## Go has goroutines !!

## Go 有 goroutines ！！

As we discussed above, hardware manufacturers are adding more and more cores to the processors to increase the performance. All the data centers are running on those processors and we should expect increase in the number of cores in upcoming years. More to that, today’s applications using multiple micro-services for maintaining database connections, message queues and maintain caches. So, the software we develop and the programming languages should support concurrency easily and they should be scalable with increased number of cores.

如上所述，硬件提供商正在向处理器添加更多的内核以提升性能。所有的数据中心都在这些处理器上运行，我们应该期待在未来几年内核数量的增长。更重要的是，如今的应用程序都是使用多个微服务来维持数据库的连接、消息队列和缓存的维护。因此，我们开发的软件和变编程语言可以更容易的支持并发，并且它们应该随着内核数量的增长而可扩展。

But, most of the modern programming languages(like Java, Python etc.) are from the ’90s single threaded environment. Most of those programming languages supports multi-threading. But the real problem comes with concurrent execution, threading-locking, race conditions and deadlocks. ****Those things make it hard to create a multi-threading application on those languages.

但是大多数现代语言（如 Java，Python 等都来自于90年代的单线程环境。这些语言大多数都支持多线程。但真正的问题是并发执行，线程锁、竞争条件和死锁。这些问题都使得很难在这些语言上创建一个多线程的应用程序。

For an example, creating new thread in Java is not memory efficient. As every thread consumes approx 1MB of the memory heap size and eventually if you start spinning thousands of threads, they will put tremendous pressure on the heap and will cause shut down due to out of memory. Also, if you want to communicate between two or more threads, it’s very difficult.

例如，在 Java 中创建新的线程并不是内存有效的。因为每一个线程都会消耗大约1 MB 大小的堆内存大小，如果你运行上千个线程，他们会对堆造成巨大的压力，最终会由于内存不足而宕机。此外，你想要在两个或者多个线程之间通信也是非常困难的。

On the other hand, Go was released in 2009 when multi-core processors were already available. That’s why Go is built with keeping concurrency in mind. Go has goroutines instead of threads. They consume almost 2KB memory from the heap. So, you can spin millions of goroutines at any time.

另一方面，Go 于2019年发布，那时多核处理器已经上市了。这也是为什么 Go 是在保持并发的基础上构建的。Go 用 goroutines 来替代线程，它们从堆中消耗了大约2 KB 的内存。因此，你可以随时启动上百万个 goroutines。

![How Goroutines work? Reffrance: [http://golangtutorials.blogspot.in/2011/06/goroutines.html](http://golangtutorials.blogspot.in/2011/06/goroutines.html)](https://cdn-images-1.medium.com/max/2000/1*NFojvbkdRkxz0ZDbu4ysNA.jpeg)


![Go协程是怎样工作的呢？参考：[http://golangtutorials.blogspot.in/2011/06/goroutines.html](http://golangtutorials.blogspot.in/2011/06/goroutines.html)](https://cdn-images-1.medium.com/max/2000/1*NFojvbkdRkxz0ZDbu4ysNA.jpeg)

**Other benefits are :**

**其他的好处：**


* Goroutines have growable segmented stacks. That means they will use more memory only when needed.

* Goroutines 具有可分段的分段堆栈，这意味着它只会在需要的时候才会使用更多的内存。

* Goroutines have a faster startup time than threads.

* Goroutines 比线程启动的更快。

* Goroutines come with built-in primitives to communicate safely between themselves (channels).

* Goroutines 带有内置原语，可以在它们（通道）之间安全的进行通信。

* Goroutines allow you to avoid having to resort to mutex locking when sharing data structures.

* Goroutines 允许你在共享数据结构时避免使用互斥锁。

* Also, goroutines and OS threads do not have 1:1 mapping. A single goroutine can run on multiple threads. Goroutines are multiplexed into small number of OS threads.

* 此外，goroutines 和系统线程没有 1：1 的映射。单个 goroutines 能在多个线程上运行。Goroutines 能被多路复用到少量的系统线程上。

> You can see Rob Pike’s excellent talk [concurrency is not parallelism](https://blog.golang.org/concurrency-is-not-parallelism) to get more deep understanding on this.

> 你能在 Rob Pike's 的优秀演讲[并发不是并行](https://blog.golang.org/concurrency-is-not-parallelism)中获取更深刻理解。

All the above points, make Go very powerful to handle concurrency like Java, C and C++ while keeping concurrency execution code strait and beautiful like Erlang.

以上这些点，能使 Go 能像 Java，C 或者 C++ 一样拥有强大的并发处理能力，同时在保证并发执行代码严谨性的基础上，像 Erlang 一样优美。

![Go takes good of both the worlds. Easy to write concurrent and efficient to manage concurrency](https://cdn-images-1.medium.com/max/2000/1*xbsHBQJReC5l_VO4XgNSIQ.png)

## Go runs directly on underlying hardware.

## Go 直接在底层硬件上运行。

One most considerable benefit of using C, C++ over other modern higher level languages like Java/Python is their performance. Because C/C++ are compiled and not interpreted.

与其他现代高级语言（如 Java/Python）相比，使用 C，C++的最大好处就是它的性能，因为 C/C++ 是编译的而不是解释的。

Processors understand binaries. Generally, when you build an application using Java or other JVM-based languages when you compile your project, it compiles the human readable code to byte-code which can be understood by JVM or other virtual machines that run on top of underlying OS. While execution, VM interprets those bytecodes and convert them to the binaries that processors can understand.

处理器能理解二进制文件。通常来说，当你编译一个用 Java或者其他基于 JVM 语言构建的应用程序，它将人类可读的代码编译为字节代码，这可以通过 JVM 或者在底层操作系统之上运行的其他虚拟机。当执行的时候，VM 解释这些字节码并且将他们转化为处理器能理解的二进制文件。

![Execution steps for VM based languages](https://cdn-images-1.medium.com/max/2000/1*TVR-VLVg68KwCOLjqQmQAw.png)

While on the other side, C/C++ does not execute on VMs and that removes one step from the execution cycle and increases the performance. It directly compiles the human readable code to binaries.

而另一个方面，C/C++ 不会在 VMs 上执行，并且从执行周期中删除一步并提高性能。它直接将人类可读的代码编译为二进制文件。

![](https://cdn-images-1.medium.com/max/2000/1*ii6xUkU_PchybiG8_GnOjA.png)

But, freeing and allocating variable in those languages is a huge pain. While most of the programming languages handle object allocation and removing using Garbage Collector or Reference Counting algorithms.

但是，在这些语言中释放和分配变量是一件极其痛苦的事情。虽然大部分编程语言都使用垃圾回收器或者引用计数的算法来处理对象的分配和移除。

Go brings best of both the worlds. Like lower level languages like C/C++, Go is compiled language. That means performance is almost nearer to lower level languages. It also uses garbage collection to allocation and removal of the object. So, no more malloc() and free() statements!!! Cool!!!

Go 做到了两全其美，Go 像一些低级别的语言（如： C/C++ ）一样是一门编译型语言，这意味着它的性能几乎接近于低级别语言，它还用垃圾回收来分配和删除对象。因此，不再需要 malloc() 和 free() 声明了！！！这太酷了！！！

## Code written in Go is easy to maintain.

## 用 Go 编写的代码易于维护

Let me tell you one thing. Go does not have crazy programming syntax like other languages have. It has very neat and clean syntax.

我告诉你一件事，Go 没有像其他语言一样疯狂于编程语法，它的语法非常整洁。

The designers of the Go at google had this thing in mind when they were creating the language. As google has the very large code-base and thousands of developers were working on that same code-base, code should be simple to understand for other developers and one segment of code should has minimum side effect on another segment of the code. That will make code easily maintainable and easy to modify.

Go 的的设计者在谷歌创建这门语言的时候就考虑到了这一点，由于谷歌拥有非常强大的代码库，成千上万的开发者都工作在相同的代码库上，代码应该易于其他开发者理解，一段代码应该对另一段代码有最小的影响。这些都会使得代码易于维护，易于修改。

Go intentionally leaves out many features of modern OOP languages.

Go 有意的忽视了许多现代面向对象语言的一些特性。

* **No classes.** Every thing is divided into packages only. Go has only structs instead of classes.

* **没有 classes。所有代码都仅用 packages 分开，Go 只有结构体而不是类** 

* **Does not support inheritance.** That will make code easy to modify. In other languages like Java/Python, if the class ABC inherits class XYZ and you make some changes in class XYZ, then that may produce some side effects in other classes that inherit XYZ. By removing inheritance, Go makes it easy to understand the code also **(as there is no super class to look at while looking at a piece of code)**.

* **不支持继承。** 这将使得代码易于修改，在其他语言中，如： Java/Python ，如果类 ABC 继承类 XYZ 并且你在类 XYZ 中做了一些改动，那么这可能会在继承类 XYZ 的其他类中产生一些副作用。通过移除继承，Go 也能很容易的理解代码（因为当你在看一段代码时没有父类以供参考）。

* No constructors.

* 没有构造方法。

* No annotations.

* 没有注释。

* No generics.

* 没有泛型。

* No exceptions.

* 没有例外

Above changes make Go very different from other languages and it makes programming in Go different from others. You may not like some points from above. But, it is not like you can not code your application without above features. All you have to do is write 2–3 more lines. But on the positive side, it will make your code cleaner and add more clarity to your code.

以上这些改变使得 Go 与其他语言截然不同，这使得用 Go 编程与其他语言很不一样。你可能不喜欢以上的一些观点。但是，如果没有上述这些特性，你就无法对你的应用程序编码。你要做的就是多写几行代码，但从积极的一面，它将使你的代码更加清晰，为代码添加更多的清晰度。

![Code readability vs, Efficiency.](https://cdn-images-1.medium.com/max/2020/1*nlpYI256BR71xMBWd1nlfg.png)

Above graph displays that Go is almost as efficient as C/C++, while keeping the code syntax simple as Ruby, Python and other languages. That is a win-win situation for both humans and processors!!!

如上图所示，Go 几乎与 C/C++ 一样高效，同时像 Ruby，Python以及其他一些语言一样保持代码语法的简洁，对于人类和处理器来说，这是一个双赢的局面！！！

[Unlike other new languages like Swift](https://www.quora.com/Is-Swifts-syntax-still-changing), it’s syntax of Go is very stable. It remained same since the initial public release 1.0, back in year 2012. That makes it backward compatible.

## Go is backed by Google.
## Go 由谷歌备书

* I know this is not a direct technical advantage. But, Go is designed and supported by Google. Google has one of the largest cloud infrastructures in the world and it is scaled massively. Go is designed by Google to solve their problems of supporting scalability and effectiveness. Those are the same issues you will face while creating your own servers.

* 我知道这不是一个直接的技术优势，但是，Go 是由谷歌设计并支持的，谷歌拥有世界上最大的云基础设施之一，并且规模庞大。Go 被谷歌设计用于解决支持可扩展性和有效性。这些都是创建我们自己的服务器时都会遇到的问题。

* More to that Go is also used by some big companies like Adobe, BBC, IBM, Intel and even [Medium](https://medium.engineering/how-medium-goes-social-b7dbefa6d413#.r8nqjxjpk).**(Source: [https://github.com/golang/go/wiki/GoUsers](https://github.com/golang/go/wiki/GoUsers))**

* Go 更多的也是被一些大公司所使用，如 Adobe，BBC，IBM，因特尔甚至是 [Medium](https://medium.engineering/how-medium-goes-social-b7dbefa6d413#.r8nqjxjpk)**(来源: [https://github.com/golang/go/wiki/GoUsers](https://github.com/golang/go/wiki/GoUsers))**

## Conclusion:
## 结论

* Even though Go is very different from other object-oriented languages, it is still the same beast. Go provides you high performance like C/C++, super efficient concurrency handling like Java and fun to code like Python/Perl.

* 尽管 Go 与其他面向对象的语言非常不同，但他仍然是同一个野兽。Go 提供了像 C/C++ 一样的高性能，像 Java 一样高效的并发处理以及像 Python/Perl 一样的编码乐趣。

* If you don’t have any plans to learn Go, I will still say hardware limit puts pressure to us, software developers to write super efficient code. Developer needs to understand the hardware and make their program optimize accordingly. **The optimized software can run on cheaper and slower hardware (like[**IOT**](https://en.wikipedia.org/wiki/Internet_of_things)devices) and overall better impact on end user experience.**

* 如果你没有任何学习 Go 的计划，我将仍然会说硬件的限制会给我们带来压力，软件开发者应该写超高效的代码。开发者应该理解硬件并相应的优化他们的程序。**优化的软件能运行在更廉价或者更慢的机器上（例如[物联网](https://en.wikipedia.org/wiki/Internet_of_things)设备），并且整体上对最终用户体验有更好的影响。**

***

**~If you liked the article, click the 💚 below so more people can see it! Also, you can follow me on** ****[Medium](http://bit.ly/2h9p8o2)** or on **M[y Blog](http://bit.ly/2iTjfui)**, so you get updates regarding future articles on Go!!~**

**~如果你喜欢这篇文章，点击下方的💚以便于更多的人看到它！此外，你也可以在 [Medium](http://bit.ly/2h9p8o2) 或者[我的博客](http://bit.ly/2iTjfui)关注我，以便于你及时获取 Go 的更新的文章！！~**

![](https://cdn-images-1.medium.com/max/2000/1*dIpjUmlzby59m09dyKqTuw.gif)

## Credits:
## 来源
* **GoLang or the future of the dev** from [Edoardo Paolo Scalafiotti](https://medium.com/@edoardo849)
* [Program your next server in Go](https://www.youtube.com/watch?v=5bYO60-qYOI)
* [Concurrency Is Not Parallelism](https://vimeo.com/49718712) by Rob Pike
* [Why Go?](https://nathany.com/why-go/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
