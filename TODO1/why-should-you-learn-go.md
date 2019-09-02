> * 原文地址：[Why should you learn Go?](https://medium.com/@kevalpatel2106/why-should-you-learn-go-f607681fad65)
> * 原文作者：[Keval Patel](https://medium.com/@kevalpatel2106)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-should-you-learn-go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-should-you-learn-go.md)
> * 译者：
> * 校对者：

# Why should you learn Go?

![Image from: [http://kirael-art.deviantart.com/art/Go-lang-Mascot-458285682](http://kirael-art.deviantart.com/art/Go-lang-Mascot-458285682)](https://cdn-images-1.medium.com/max/2000/1*vHUiXvBE0p0fLRwFHZuAYw.gif)

> “[Go will be the server language of the future.](https://twitter.com/tobi/status/326086379207536640)” — Tobias Lütke, Shopify

In past couple of years, there is a rise of new programming language: [**Go or GoLang**](https://golang.org/). Nothing makes a developer crazy than a new programming language, right? So, I started learning Go 4 to 5 months ago and here I am going to tell you about why you should also learn this new language.

I am not going to teach you, how you can write “Hello World!!” in this article. There are lots of other articles online for that. **I am going the explain current stage of computer hardware-software and why we need new language like Go?** Because if there isn’t any problem, then we don’t need solution, right?

## Hardware limitations:

**[Moore’s law](http://www.investopedia.com/terms/m/mooreslaw.asp) is failing.**

First Pentium 4 processor with 3.0GHz clock speed was [introduced back in 2004](http://www.informit.com/articles/article.aspx?p=339073) by Intel. Today, my [Mackbook Pro 2016](http://www.apple.com/macbook-pro/specs/) has clock speed of 2.9GHz. So, nearly in one decade, there is not too much gain in the raw processing power. You can see the comparison of increasing the processing power with the time in below chart.

![](https://cdn-images-1.medium.com/max/2000/1*Azz7YwzYYR6lDKFj8iIGZg.png)

From the above chart you can see that the single-thread performance and the frequency of the processor remained steady for almost a decade. If you are thinking that adding more transistor is the solution, then you are wrong. This is because at smaller scale some quantum properties starts to emerge (like tunneling) and because it actually costs more to put more transistors ([why?](https://www.quora.com/What-is-Quantum-Tunneling-Limit-How-does-it-limit-the-size-of-a-transistor)) and the number of transistors you can add per dollar starts to fall.

So, for the solution of above problem,

* Manufacturers started adding more and more cores to the processor. Nowadays we have quad-core and octa-core CPUs available.
* We also introduced hyper-threading.
* Added more cache to the processor to increase the performance.

But above solutions have its own limitations too. We cannot add more and more cache to the processor to increase performance as cache have physical limits: the bigger the cache, the slower it gets. Adding more core to the processor has its cost too. Also, that cannot scale to indefinitely. These multi-core processors can run multiple threads simultaneously and that brings concurrency to the picture. We’ll discuss it later.

So, if we cannot rely on the hardware improvements, the only way to go is more efficient software to increase the performance. But sadly, modern programming language are not much efficient.

> “Modern processors are a like nitro fueled funny cars, they excel at the quarter mile. Unfortunately modern programming languages are like Monte Carlo, they are full of twists and turns.” — [David Ungar](https://en.wikipedia.org/wiki/David_Ungar)

## Go has goroutines !!

As we discussed above, hardware manufacturers are adding more and more cores to the processors to increase the performance. All the data centers are running on those processors and we should expect increase in the number of cores in upcoming years. More to that, today’s applications using multiple micro-services for maintaining database connections, message queues and maintain caches. So, the software we develop and the programming languages should support concurrency easily and they should be scalable with increased number of cores.

But, most of the modern programming languages(like Java, Python etc.) are from the ’90s single threaded environment. Most of those programming languages supports multi-threading. But the real problem comes with concurrent execution, threading-locking, race conditions and deadlocks. Those things make it hard to create a multi-threading application on those languages.

For an example, creating new thread in Java is not memory efficient. As every thread consumes approx 1MB of the memory heap size and eventually if you start spinning thousands of threads, they will put tremendous pressure on the heap and will cause shut down due to out of memory. Also, if you want to communicate between two or more threads, it’s very difficult.

On the other hand, Go was released in 2009 when multi-core processors were already available. That’s why Go is built with keeping concurrency in mind. Go has goroutines instead of threads. They consume almost 2KB memory from the heap. So, you can spin millions of goroutines at any time.

![How Goroutines work? Reffrance: [http://golangtutorials.blogspot.in/2011/06/goroutines.html](http://golangtutorials.blogspot.in/2011/06/goroutines.html)](https://cdn-images-1.medium.com/max/2000/1*NFojvbkdRkxz0ZDbu4ysNA.jpeg)

**Other benefits are :**

* Goroutines have growable segmented stacks. That means they will use more memory only when needed.
* Goroutines have a faster startup time than threads.
* Goroutines come with built-in primitives to communicate safely between themselves (channels).
* Goroutines allow you to avoid having to resort to mutex locking when sharing data structures.
* Also, goroutines and OS threads do not have 1:1 mapping. A single goroutine can run on multiple threads. Goroutines are multiplexed into small number of OS threads.

> You can see Rob Pike’s excellent talk [concurrency is not parallelism](https://blog.golang.org/concurrency-is-not-parallelism) to get more deep understanding on this.

All the above points, make Go very powerful to handle concurrency like Java, C and C++ while keeping concurrency execution code strait and beautiful like Erlang.

![Go takes good of both the worlds. Easy to write concurrent and efficient to manage concurrency](https://cdn-images-1.medium.com/max/2000/1*xbsHBQJReC5l_VO4XgNSIQ.png)

## Go runs directly on underlying hardware.

One most considerable benefit of using C, C++ over other modern higher level languages like Java/Python is their performance. Because C/C++ are compiled and not interpreted.

Processors understand binaries. Generally, when you build an application using Java or other JVM-based languages when you compile your project, it compiles the human readable code to byte-code which can be understood by JVM or other virtual machines that run on top of underlying OS. While execution, VM interprets those bytecodes and convert them to the binaries that processors can understand.

![Execution steps for VM based languages](https://cdn-images-1.medium.com/max/2000/1*TVR-VLVg68KwCOLjqQmQAw.png)

While on the other side, C/C++ does not execute on VMs and that removes one step from the execution cycle and increases the performance. It directly compiles the human readable code to binaries.

![](https://cdn-images-1.medium.com/max/2000/1*ii6xUkU_PchybiG8_GnOjA.png)

But, freeing and allocating variable in those languages is a huge pain. While most of the programming languages handle object allocation and removing using Garbage Collector or Reference Counting algorithms.

Go brings best of both the worlds. Like lower level languages like C/C++, Go is compiled language. That means performance is almost nearer to lower level languages. It also uses garbage collection to allocation and removal of the object. So, no more malloc() and free() statements!!! Cool!!!

## Code written in Go is easy to maintain.

Let me tell you one thing. Go does not have crazy programming syntax like other languages have. It has very neat and clean syntax.

The designers of the Go at google had this thing in mind when they were creating the language. As google has the very large code-base and thousands of developers were working on that same code-base, code should be simple to understand for other developers and one segment of code should has minimum side effect on another segment of the code. That will make code easily maintainable and easy to modify.

Go intentionally leaves out many features of modern OOP languages.

* **No classes.** Every thing is divided into packages only. Go has only structs instead of classes.
* **Does not support inheritance.** That will make code easy to modify. In other languages like Java/Python, if the class ABC inherits class XYZ and you make some changes in class XYZ, then that may produce some side effects in other classes that inherit XYZ. By removing inheritance, Go makes it easy to understand the code also **(as there is no super class to look at while looking at a piece of code)**.
* No constructors.
* No annotations.
* No generics.
* No exceptions.

Above changes make Go very different from other languages and it makes programming in Go different from others. You may not like some points from above. But, it is not like you can not code your application without above features. All you have to do is write 2–3 more lines. But on the positive side, it will make your code cleaner and add more clarity to your code.

![Code readability vs, Efficiency.](https://cdn-images-1.medium.com/max/2020/1*nlpYI256BR71xMBWd1nlfg.png)

Above graph displays that Go is almost as efficient as C/C++, while keeping the code syntax simple as Ruby, Python and other languages. That is a win-win situation for both humans and processors!!!

[Unlike other new languages like Swift](https://www.quora.com/Is-Swifts-syntax-still-changing), it’s syntax of Go is very stable. It remained same since the initial public release 1.0, back in year 2012. That makes it backward compatible.

## Go is backed by Google.

* I know this is not a direct technical advantage. But, Go is designed and supported by Google. Google has one of the largest cloud infrastructures in the world and it is scaled massively. Go is designed by Google to solve their problems of supporting scalability and effectiveness. Those are the same issues you will face while creating your own servers.
* More to that Go is also used by some big companies like Adobe, BBC, IBM, Intel and even [Medium](https://medium.engineering/how-medium-goes-social-b7dbefa6d413#.r8nqjxjpk).**(Source: [https://github.com/golang/go/wiki/GoUsers](https://github.com/golang/go/wiki/GoUsers))**

## Conclusion:

* Even though Go is very different from other object-oriented languages, it is still the same beast. Go provides you high performance like C/C++, super efficient concurrency handling like Java and fun to code like Python/Perl.
* If you don’t have any plans to learn Go, I will still say hardware limit puts pressure to us, software developers to write super efficient code. Developer needs to understand the hardware and make their program optimize accordingly. **The optimized software can run on cheaper and slower hardware (like[** IOT **](https://en.wikipedia.org/wiki/Internet_of_things)devices) and overall better impact on end user experience.**

***

**~If you liked the article, click the 💚 below so more people can see it! Also, you can follow me on** ****[Medium](http://bit.ly/2h9p8o2)** or on **M[y Blog](http://bit.ly/2iTjfui)**, so you get updates regarding future articles on Go!!~**

![](https://cdn-images-1.medium.com/max/2000/1*dIpjUmlzby59m09dyKqTuw.gif)

## Credits:

* **GoLang or the future of the dev** from [Edoardo Paolo Scalafiotti](undefined)
* [Program your next server in Go](https://www.youtube.com/watch?v=5bYO60-qYOI)
* [Concurrency Is Not Parallelism](https://vimeo.com/49718712) by Rob Pike
* [Why Go?](https://nathany.com/why-go/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
