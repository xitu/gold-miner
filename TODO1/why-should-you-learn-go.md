> * 原文地址：[Why should you learn Go?](https://medium.com/@kevalpatel2106/why-should-you-learn-go-f607681fad65)
> * 原文作者：[Keval Patel](https://medium.com/@kevalpatel2106)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-should-you-learn-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-should-you-learn-go.md)
> * 译者：[todaycoder001](https://github.com/todaycoder001)
> * 校对者：[TokenJan](https://github.com/TokenJan)，[JackEggie](https://github.com/JackEggie)

# 为什么你要学习 Go？

![Image from: [http://kirael-art.deviantart.com/art/Go-lang-Mascot-458285682](http://kirael-art.deviantart.com/art/Go-lang-Mascot-458285682)](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190902123731.png)

> “[Go will be the server language of the future.](https://twitter.com/tobi/status/326086379207536640)” — Tobias Lütke, Shopify

在过去几年，有一门崛起的新语言：[**Go 或者 GoLang**](https://golang.org/)。没有什么比一门新的编程语言更令开发者兴奋了，不是么? 因此，我在 4、5 个月之前开始学习 Go。在这里我将告诉你，你为什么也要学习这门新语言。

在这篇文章中，我不打算教你怎样写 “Hello World!!”。网上有许多其他的文章会教你。**我将阐述软硬件发展的现状以及为什么我们要学习像 Go 这样的新语言？**因为如果没有任何问题，我们就不需要解决方案，不是么？

## 硬件的局限性

**[摩尔定律](http://www.investopedia.com/terms/m/mooreslaw.asp)正在失效。**

英特尔公司在 [2004 年推出](http://www.informit.com/articles/article.aspx?p=339073)了第一款具有 3.0 GHz时钟速度的奔腾 4 处理器。如今，我的 [2016款 MacBook Pro](http://www.apple.com/macbook-pro/specs/) 的时钟速度为 2.9 GHz。因此，差不多十年，原始处理能力都没有太多的增加。你可以在下图中看到处理能力的增长与时间的关系。

![](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190902125732.png)

从上面的图表可以看出，单线程的性能和处理器的频率在近十年几乎保持稳定。如果你认为添加更多的晶体管是一种解决问题的方法，那你就错了。这是因为在微观尺度上，量子特性开始显现（例如：量子隧道穿越），放更多的晶体管代价也会越多([为什么？](https://www.quora.com/What-is-Quantum-Tunneling-Limit-How-does-it-limit-the-size-of-a-transistor))，而且，每美元可以添加晶体管的数量也开始下降。

所以，针对上述问题的解决方案如下：

* 厂商开始向处理器添加越来越多的内核。如今，我们已经有四核和八核的 CPU 可用。
* 我们还引入了超线程技术。
* 为处理器添加更多的缓存以提升性能。

但是，以上方案也有它们自身的限制。我们无法向处理器添加更多的缓存以提升性能，因为缓存具有物理限制：缓存越大，速度越慢。添加更多的内核到处理器也有它的成本。而且，这也无法无限扩展。这些多核处理器能同时运行多个线程，同时也能带来并发能力。我们稍后会讨论它。

因此，如果我们不能依赖于硬件的改进，唯一的出路就是找到一个高效的软件来提升性能，但遗憾的是，现代编程语言都不是那么高效。

> “现代处理器就像一辆有氮氧加速系统的直线竞速赛车，它们在直线竞速赛中表现优异。不幸的是，现代编程语言却像蒙特卡罗赛道，它们有大量的弯道。” - [David Ungar](https://en.wikipedia.org/wiki/David_Ungar)

## Go 有 goroutine！！

如上所述，硬件提供商正在向处理器添加更多的内核以提升性能。所有的数据中心都在这些处理器上运行，我们应该期待在未来几年内核数量的增长。更重要的是，如今的应用程序都是使用多个微服务来维持数据库的连接、消息队列和缓存的维护。因此，我们开发的软件和编程语言可以更容易的支持并发，并且它们应该随着内核数量的增长而可扩展。

但是大多数现代编程语言（如 Java、Python 等）都来自于 90 年代的单线程环境。这些语言大多数都支持多线程。但真正的问题是并发执行，线程锁、竞争条件和死锁。这些问题都使得很难在这些语言上创建一个多线程的应用程序。

例如，在 Java 中创建新的线程会消耗大量内存。因为每一个线程都会消耗大约 1 MB 大小的堆内存，如果你运行上千个线程，他们会对堆造成巨大的压力，最终会由于内存不足而宕机。此外，你想要在两个或者多个线程之间通信也是非常困难的。

另一方面，Go 于 2009 年发布，那时多核处理器已经上市了。这也是为什么 Go 是在考虑并发的基础上构建的。Go 用 goroutine 来替代线程，它们从堆中消耗了大约 2 KB 的内存。因此你可以随时启动上百万个 goroutine。

![Goroutine 是怎样工作的呢？参考：[http://golangtutorials.blogspot.in/2011/06/goroutines.html](http://golangtutorials.blogspot.in/2011/06/goroutines.html)](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190902125813.png)

**其他的好处：**

* Goroutine 具有可增长的分段堆栈，这意味着它只会在需要的时候才会使用更多的内存。
* Goroutine 比线程启动的更快。
* Goroutine 带有内置原语，可以在它们（通道）之间安全的进行通信。
* Goroutine 允许你在共享数据结构时避免使用互斥锁。
* 此外，goroutine 和系统线程没有 1:1 的映射。单个 goroutine 能在多个线程上运行。Goroutine 也能被复用到少量的系统线程上。

> 你能在 Rob Pike 的优秀演讲[并发不是并行](https://blog.golang.org/concurrency-is-not-parallelism)中获取更深刻理解。

以上这些点，能使 Go 能像 Java、C 或者 C++ 一样拥有强大的并发处理能力，同时在保证并发执行代码严谨性的基础上，像 Erlang 一样优美。

![Go takes good of both the worlds. Easy to write concurrent and efficient to manage concurrency](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190902125953.png)

## Go 直接在底层硬件上运行

与其他现代高级语言（如 Java/Python）相比，使用 C、C++ 的最大好处就是它的性能，因为 C/C++ 是编译型语言而不是解释型语言。

处理器能理解二进制文件。通常来说，当你编译一个用 Java 或者其他基于 JVM 的语言构建的应用程序，它将人类可读的代码编译为字节代码，这可以被 JVM 或者在底层操作系统之上运行的其他虚拟机所理解。当执行的时候，虚拟机解释这些字节码并且将他们转化为处理器能理解的二进制文件。

![基于虚拟机语言的执行步骤](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190902130150.png)

而另一个方面，C/C++ 不会在 VM 上执行，并且从执行周期中删除（编译为字节代码）这一步提高性能。它直接将人类可读的代码编译为二进制文件。

![](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190902130237.png)

但是，在这些语言中释放和分配变量是一件极其痛苦的事情。虽然大部分编程语言都使用垃圾回收器或者引用计数的算法来处理对象的分配和移除。

Go 做到了两全其美，Go 像一些低级别的语言（如： C/C++ ）一样是一门编译型语言，这意味着它的性能几乎接近于低级别语言，它还用垃圾回收来分配和删除对象。因此，不再需要 malloc() 和 free() 声明了！！！这太酷了！！！

## 用 Go 编写的代码易于维护

我告诉你一件事，Go 没有像其他语言一样疯狂于编程语法，它的语法非常整洁。

Go 的的设计者在谷歌创建这门语言的时候就考虑到了这一点，由于谷歌拥有非常强大的代码库，成千上万的开发者都工作在相同的代码库上，代码应该易于其他开发者理解，一段代码应该对另一段代码有最小的影响。这些都会使得代码易于维护，易于修改。

Go 有意的忽视了许多现代面向对象语言的一些特性。

* **没有类。** 所有代码都仅用 package 分开，Go 只有结构体而不是类。
* **不支持继承。** 这将使得代码易于修改。在其他语言中，如： Java/Python，如果类 ABC 继承类 XYZ 并且你在类 XYZ 中做了一些改动，那么这可能会在继承类 XYZ 的其他类中产生一些副作用。通过移除继承，Go 也使得理解代码变得很容易 **（因为当你在看一段代码时不需要同时查看父类）**。
* 没有构造方法。
* 没有注解。
* 没有泛型。
* 没有异常。

以上这些改变使得 Go 与其他语言截然不同，这使得用 Go 编程与其他语言很不一样。你可能不喜欢以上的一些观点。但是，并不是说没有上述这些特性，你就无法对你的应用程序编码。你要做的就是多写几行代码，但从积极的一面，它将使你的代码更加清晰，为代码添加更多的清晰度。

![代码的可读性和效率的对比](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190902130259.png)

如上图所示，Go 几乎与 C/C++ 一样高效，同时像 Ruby、Python 以及其他一些语言一样保持代码语法的简洁，对于人类和处理器来说，这是一个双赢的局面！！！

[与 Swift 等这些新的语言不一样](https://www.quora.com/Is-Swifts-syntax-still-changing)，Go 的语法非常稳定。自从 2012 年首次公开发布 1.0 版本以来，它保持不变并且向后兼容。

## Go 由谷歌背书

* 我知道这不是一个直接的技术优势，但 Go 是由谷歌设计并支持的，谷歌拥有世界上最大的云基础设施之一，并且规模庞大。谷歌设计 Go 以解决可扩展性和有效性问题。这些是创建我们自己的服务器时都会遇到的问题。
* Go 更多的也是被一些大公司所使用，如 Adobe、BBC、IBM，因特尔甚至是 [Medium](https://medium.engineering/how-medium-goes-social-b7dbefa6d413#.r8nqjxjpk)。**(来源：[https://github.com/golang/go/wiki/GoUsers](https://github.com/golang/go/wiki/GoUsers))**

## 结论

* 尽管 Go 与其他面向对象的语言非常不同，但他同样产生了巨大的影响。Go 提供了像 C/C++ 一样的高性能，像 Java 一样高效的并发处理以及像 Python/Perl 一样的编码乐趣。
* 如果你没有任何学习 Go 的计划，我将仍然会说硬件的限制会给我们带来压力，软件开发者应该写超高效的代码。开发者应该理解硬件并相应的优化他们的程序。**优化的软件能运行在更廉价或者更慢的机器上（例如[物联网](https://en.wikipedia.org/wiki/Internet_of_things)设备），并且整体上对最终用户体验有更好的影响。**

***

**~如果你喜欢这篇文章，点击下方的💚以便于更多的人看到它！此外，你也可以在 [Medium](http://bit.ly/2h9p8o2) 或者[我的博客](http://bit.ly/2iTjfui)关注我，以便于你及时获取 Go 的更新的文章！！~**

![](https://raw.githubusercontent.com/todaycoder001/public-images/master/img/20190902130516.png)

## 参考文献

* **GoLang 或者开发者的未来** 来自于 [Edoardo Paolo Scalafiotti](https://medium.com/@edoardo849)
* [用 Go 编写下一代服务器](https://www.youtube.com/watch?v=5bYO60-qYOI)
* [并发不是并行](https://vimeo.com/49718712) by Rob Pike
* [为什么是 Go？](https://nathany.com/why-go/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
