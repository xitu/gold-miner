> * 原文地址：[How JavaScript works: inside the V8 engine + 5 tips on how to write optimized code](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code-ac089e62b12e)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code.md)
> * 译者：[春雪](https://github.com/balancelove)
> * 校对者：[PCAaron](https://github.com/PCAaron) [Raoul1996](https://github.com/Raoul1996)

# JavaScript 是如何工作的：在 V8 引擎里 5 个优化代码的技巧

几个星期前我们开始了一个旨在深入挖掘 JavaScript 以及它是如何工作的系列文章。我们通过了解它的底层构建以及它是怎么发挥作用的，可以帮助我们写出更好的代码与应用。

[第一篇文章](https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf) 主要关注引擎、运行时以及调用栈的概述。第二篇文章将会深入到 Google 的 JavaScript V8 引擎的内部。 我们还提供了一些关于如何编写更好的 JavaScript 代码的快速技巧 —— 我们 [SessionStack](https://www.sessionstack.com/) 开发团队在开发产品的时候遵循的最佳实践。

#### 概述

**JavaScript 引擎** 是执行 JavaScript 代码的程序或者说是解释器。JavaScript 引擎能够被实现成标准解释器或者是能够将 JavaScript 以某种方式编译为字节码的即时编译器。

下面是一些比较火的实现 JavaScript 引擎的项目：

* [**V8**](https://en.wikipedia.org/wiki/V8_%28JavaScript_engine%29 "V8 (JavaScript engine)") — 由 Google 开发，使用 C++ 编写的开源引擎
* [**Rhino**](https://en.wikipedia.org/wiki/Rhino_%28JavaScript_engine%29 "Rhino (JavaScript engine)") — 由 Mozilla 基金会管理，完全使用 Java 开发的开源引擎
* [**SpiderMonkey**](https://en.wikipedia.org/wiki/SpiderMonkey_%28JavaScript_engine%29 "SpiderMonkey (JavaScript engine)") — 第一个 JavaScript 引擎，在当时支持了 Netscape Navigator，现在是 Firefox 的引擎
* [**JavaScriptCore**](https://en.wikipedia.org/wiki/JavaScriptCore "JavaScriptCore") — 由苹果公司为 Safari 浏览器开发，并以 Nitro 的名字推广的开源引擎。
* [**KJS**](https://en.wikipedia.org/wiki/KJS_%28KDE%29 "KJS (KDE)") — KDE 的引擎，最初是由 Harri Porten 为 KDE 项目的 Konqueror 网络浏览器开发
* [**Chakra** (JScript9)](https://en.wikipedia.org/wiki/Chakra_%28JScript_engine%29 "Chakra (JScript engine)") — IE 引擎
* [**Chakra** (JavaScript)](https://en.wikipedia.org/wiki/Chakra_%28JavaScript_engine%29 "Chakra (JavaScript engine)") — 微软 Edge 的引擎
* [**Nashorn**](https://en.wikipedia.org/wiki/Nashorn_%28JavaScript_engine%29 "Nashorn (JavaScript engine)") — 开源引擎，由 Oracle 的 Java 语言工具组开发，是 OpenJDK 的一部分
* [**JerryScript**](https://en.wikipedia.org/wiki/JerryScript "JerryScript") — 这是物联网的一个轻量级引擎

#### 为什么要创建 V8 引擎？

V8 引擎是由 Google 用 **C++** 开发的开源引擎，这个引擎也在 Google chrome 中使用。和其他的引擎不同的是，V8 引擎也用于运行 Node.js。

![](https://cdn-images-1.medium.com/max/800/1*AKKvE3QmN_ZQmEzSj16oXg.png)

V8 最初被设计出来是为了提高浏览器内部 JavaScript 的执行性能。为了获取更快的速度，V8 将 JavaScript 代码编译成了更加高效的机器码，而不是使用解释器。它就像 SpiderMonkey 或者 Rhino (Mozilla) 等许多现代JavaScript 引擎一样，通过运用即时编译器将 JavaScript 代码编译为机器码。而这之中最主要的区别就是 V8 不生成字节码或者任何中间代码。

#### V8 曾经有两个编译器

在 V8 的 v5.9 版本出来之前（今年早些时候发布的）有两个编译器：

*   full-codegen — 一个简单并且速度非常快的编译器，可以生成简单但相对比较慢的机器码。
*   Crankshaft — 一个更加复杂的 (即时) 优化编译器，生成高度优化的代码。

V8 引擎在内部也使用了多个线程：

*   主线程完成你所期望的任务：获取你的代码，然后编译执行
*   还有一个单独的线程用于编译，以便主线程可以继续执行，而前者就能够优化代码
*   一个 `Profiler` (分析器) 线程，它会告诉运行时在哪些方法上我们花了很多的时间，以便 `Crankshaft` 可以去优化它们
*   还有一些线程处理垃圾回收扫描

当第一次执行 JavaScript 代码的时候，V8 利用 **full-codegen** 直接将解析的 JavaScript 代码不经过任何转换翻译成机器码。这使得它可以 **非常快速** 的开始执行机器码，请注意，V8 不使用任何中间字节码表示，从而不需要解释器。

当你的代码已经运行了一段时间了，分析器线程已经收集了足够的数据来告诉运行时哪个方法应该被优化。

然后， **Crankshaft** 在另一个线程开始优化。它将 JavaScript 抽象语法树转换成一个叫 **Hydrogen** 的高级静态单元分配表示(SSA)，并且尝试去优化这个 Hydrogen 图。大多数优化都是在这个级完成。

#### 代码嵌入 (Inlining)

首次优化就是尽可能的提前嵌入更多的代码。代码嵌入就是将使用函数的地方(调用函数的那一行)替换成调用函数的本体。这简单的一步就会使接下来的优化更加有用。

![](https://cdn-images-1.medium.com/max/800/0*RRgTDdRfLGEhuR7U.png)

#### 隐藏类 (Hidden class)

JavaScript 是一门基于原型的语言: 没有类和对象是通过克隆来创建的。同时 JavaScript 也是一门动态语言，这意味着在实例化之后也能够方便的从对象中添加或者删除属性。

大多数 JavaScript 解释器使用类似字典的结构 (基于[散列函数](http://en.wikipedia.org/wiki/Hash_function)) 去存储对象属性值在内存中的位置。这种结构使得在 JavaScript 中检索一个属性值比在像 Java 或者 C# 这种非动态语言中计算量大得多。在 Java 中, 编译之前所有的属性值以一种固定的对象布局确定下来了，并且在运行时不能动态的增加或者删除 (当然，C# 也有 [动态类型](https://docs.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/dynamic)，但这是另外一个话题了)。因此，属性值 (或者说指向这些属性的指针) 能够以连续的 buffer 存储在内存中，并且每个值之间有一个固定的偏移量。根据属性类型可以很容易地确定偏移量的长度，而在 JavaScript 中这是不可能的，因为属性类型可以在运行时更改。

由于采用字典的方式去内存中查找对象属性的位置效率很低，因此 V8 就采用了一种不一样的方法：**隐藏类**。隐藏类与 Java 等语言中使用的固定对象布局（类）的工作方式很类似，除了它们是在运行时创建的。现在，来让我们看看它们实际的样子：

```js
function Point(x, y) {
    this.x = x;
    this.y = y;
}
var p1 = new Point(1, 2);
```

一旦 “new Point(1, 2)” 被调用,V8 将会创建一个叫 “C0” 的隐藏类。

![](https://cdn-images-1.medium.com/max/800/1*pVnIrMZiB9iAz5sW28AixA.png)

运行到这里，Point 还没有定义任何的属性，所以 “C0” 是空的。

当第一条语句 “this.x = x” 开始执行 (在 “Point” 函数中), V8 将会基于 “C0” 创建第二个隐藏类叫做 “C1”。“C1” 描述了属性值 x 在内存中的位置(相对于对象指针)。在这个例子中, “x” 被存在 [偏移值](http://en.wikipedia.org/wiki/Offset_%28computer_science%29) 为 0 的地方, 这意味着当在内存中把 point 对象视为一段连续的 buffer 时，它的第一个偏移量对应的属性就是 “x”。V8 也会使用类转换更新 “C0”，如果一个属性 “x” 被添加到这个 point 对象中，隐藏类就会从 “C0” 切换到 “C1”。那么，现在这个point 对象的隐藏类就是 “C1” 了。

![](https://cdn-images-1.medium.com/max/800/1*QsVUE3snZD9abYXccg6Sgw.png)

每当一个新属性添加到对象，老的隐藏类就会通过一个转换路径更新成一个新的隐藏类。隐藏类转换非常重要，因为它们允许以相同方法创建的对象共享隐藏类。如果两个对象共享一个隐藏类，并给它们添加相同的属性，隐藏类转换能够确保这两个对象都获得新的隐藏类以及与之相关联的优化代码。

当执行语句 “this.y = y” (同样，在 Point 函数内部，“this.x = x” 语句之后) 时，将重复此过程。

一个新的隐藏类 “C2” 被创建了，如果属性 “y” 被添加到 Point 对象(已经包含了 “x” 属性)，同样的过程，类型转换被添加到 “C1” 上，然后隐藏类开始更新成 “C2”，并且 Point 对象的隐藏类就要更新成 “C2” 了。

![](https://cdn-images-1.medium.com/max/800/1*spJ8v7GWivxZZzTAzqVPtA.png)

隐藏类转换是根据属性被添加到对象上的顺序而发生变化。我们看看下面这一小段代码：

```js
function Point(x, y) {
    this.x = x;
    this.y = y;
}
var p1 = new Point(1, 2);
p1.a = 5;
p1.b = 6;
var p2 = new Point(3, 4);
p2.b = 7;
p2.a = 8;
```

现在，你可能会想 p1 和 p2 使用了相同的隐藏类和类转换。其实不然，对于 p1 来说，属性 “a” 被第一个添加，然后是属性 “b”。而对于 p2 来说，首先分配 “b”，然后才是 “a”。因此，p1 和 p2 会以不同的类转换路径结束，隐藏类也不同。其实，在这两个例子中我们可以看到，最好的方式是使用相同的顺序初始化动态属性，这样的话隐藏类就能够复用了。

#### 内联缓存 (Inline caching)

V8 还利用另一种叫内联缓存的技术来优化动态类型语言。内联缓存依赖于我们观察到：同一个方法的重复调用是发生在相同类型的对象上的。关于内联缓存更深层次的解读请看[这里](https://github.com/sq/JSIL/wiki/Optimizing-dynamic-JavaScript-with-inline-caches)。

我们来大致了解一下内联缓存的基本概念 (如果你没有时间去阅读上面的深层次的解读)。

那么它是如何工作的呢？V8 维护了一个对象类型的缓存，存储的是在最近的方法调用中作为参数传递的对象类型，然后 V8 会使用这些信息去预测将来什么类型的对象会再次作为参数进行传递。如果 V8 对传递给方法的对象的类型做出了很好的预测，那么它就能够绕开获取对象属性的计算过程，取而代之的是使用先前查找这个对象的隐藏类时所存储的信息。

那么隐藏类和内联缓存的概念是怎么联系在一起的呢？无论什么时候当一个特定的对象上的方法被调用时，V8 引擎都会查找这个对象的隐藏类以便确定获取特定属性的偏移值。当对于同一个隐藏类两次成功的调用了同一个方法时，V8 就会略过查找隐藏类，将这个属性的偏移值添加到对象本身的指针上。对于未来这个方法的所有调用，V8 引擎都会假设隐藏类没有改变，而是直接跳到特定属性在内存中的位置，这是通过之前查找时存储的偏移值做到的。这极大的提高了 V8 的执行速度。

同时，内联缓存也是同类型对象共享隐藏类如此重要的原因。如果我们使用不同的隐藏类创建了两个同类型的对象(就如同我们前面做的那样)，V8 就不能使用内联缓存，因为即使两个对象是相同的，但是它们对应的隐藏类对它们的属性分配了不同的偏移值。

![](https://cdn-images-1.medium.com/max/800/1*iHfI6MQ-YKQvWvo51J-P0w.png)

这两个对象基本相同，但是属性 “a” 和 “b” 是以不同的顺序创建的

#### 编译成机器代码

一旦 Hydrogen 图被优化，Crankshaft 就会把这个图降低到一个比较低层次的表现形式 —— 叫做 Lithium。大多数 Lithium 实现都是面向特定的结构的。寄存器分配就发生在这一层次。

最后，Lithium 被编译成机器码。然后，OSR就开始了：一种运行时替换正在运行的栈帧的技术(on-stack replacement)。在我们开始编译和优化一个明显耗时的方法时，我们可能会运行它。V8 不会把它之前运行的慢的代码抛在一旁，然后再去执行优化后的代码。相反，V8 会转换这些代码的上下文(栈， 寄存器)，以便在执行这些慢代码的途中转换到优化后的版本。这是一个非常复杂的任务，要知道 V8 已经在其他的优化中将代码嵌入了。当然了，V8 不是唯一能做到这一点的引擎。

V8 还有一种保护措施叫做反优化，能够做相反的转换，将代码逆转成没有优化过的代码以防止引擎做的猜测不再正确。

#### 垃圾回收

对于垃圾回收，V8 使用一种传统的分代式标记清除的方式去清除老生代的数据。标记阶段会阻止 JavaScript 的运行。为了控制垃圾回收的成本，并且使 JavaScript 的执行更加稳定，V8 使用增量标记：与遍历全部堆去标记每一个可能的对象的不同，取而代之的是它只遍历部分堆，然后就恢复正常执行。下一次垃圾回收就会从上一次遍历停下来的地方开始，这就使得每一次正常执行之间的停顿都非常短。就像前面说的，清理的操作是由独立的线程的进行的。

#### Ignition 和 TurboFan

随着 2017 年早些时候 V8 5.9 版本的发布，一个新的执行管线被引入。这个新的执行管线在 **实际的** JavaScript 应用中实现了更大的性能提升、显著的节省了内存的使用。

这个新的执行管线构建在 V8 的解释器 [Ignition](https://github.com/v8/v8/wiki/Interpreter) 和 最新的优化编译器 [TurboFan](https://github.com/v8/v8/wiki/TurboFan) 之上。

你可以在[这里](https://v8project.blogspot.bg/2017/05/launching-ignition-and-turbofan.html)查看 V8 团队有关这个主题的所有博文。

自从 V8 的 5.9 版本发布提来，V8 团队一直努力的跟上 JavaScript 的语言特性以及对这些特性的优化保持一致，而 full-codegen 和 Crankshaft (这两项技术从 2010 年就开始为 V8 服务) 不再被 V8 使用来运行 JavaScript。

这将意味着整个 V8 将拥有更简单、更易维护的架构。

![](https://cdn-images-1.medium.com/max/800/0*pohqKvj9psTPRlOv.png)

在 web 和 Node.js 上的改进

当然这些改进仅仅是个开始。全新的 Ignition 和 TurboFan 管线为进一步的优化铺平了道路，这将在未来几年提高 JavaScript 性能以及使得 V8 在 chrome 和 Node.js 中节省更多的资源。

最后，这里提供一些小技巧去帮助大家写出优化更好、更棒的 JavaScript。从上文中你一定能总结出这些技巧，不过我依然总结了一下提供给你们：

#### 如何写出优化的 JavaScript

1.  **对象属性的顺序**: 在实例化你的对象属性的时候一定要使用相同的顺序，这样隐藏类和随后的优化代码才能共享。
2.  **动态属性**: 在对象实例化之后再添加属性会强制使得隐藏类变化，并且会减慢为旧隐藏类所优化的代码的执行。所以，要在对象的构造函数中完成所有属性的分配。
3.  **方法**: 重复执行相同的方法会运行的比不同的方法只执行一次要快 (因为内联缓存)。
4.  **数组**: 避免使用 keys 不是递增的数字的稀疏数组，这种不是每一个元素在里面的稀疏数组其实是一个 **hash 表**。在这种数组中每一个元素的获取都是昂贵的代价。同时，要避免提前申请大数组。最好的做法是随着你的需要慢慢的增大数组。最后，不要删除数组中的元素，因为这会使得 keys 变得稀疏。
5.  **标记值 (Tagged values)**: V8 用 32 位来表示对象和数字。它使用一位来区分它是对象 (flag = 1) 还是一个整型 (flag = 0)，也被叫做小整型(SMI)，因为它只有 31 位。然后，如果一个数值大于 31 位，V8 将会对其进行 box 操作，然后将其转换成 double 型，并且创建一个新的对象来装这个数。所以，为了避免代价很高的 box 操作，尽量使用 31 位的有符号数。

我们在 SessionStack 会尝试去遵循这些最佳实践去写出高质量、优化的代码。原因是一旦你将 SessionStack 集成到你的 web 应用中，它就会开始记录所有东西：包括所有 DOM 的改变，用户交互，JavaScript 异常，栈追踪，网络请求失败和 debug 信息。有了 SessionStack 你就能够把你 web 应用中的问题当成视频，你可以看回放来确定你的用户发生了什么。而这一切都不会影响到你的 web 应用的正常运行。
这儿有个免费的计划可以让你 [开始](https://www.sessionstack.com/signup/)。

![](https://cdn-images-1.medium.com/max/800/1*kEQmoMuNBDfZKNSBh0tvRA.png)

#### 更多资源

* [https://docs.google.com/document/u/1/d/1hOaE7vbwdLLXWj3C8hTnnkpE0qSa2P--dtDvwXXEeD0/pub](https://docs.google.com/document/u/1/d/1hOaE7vbwdLLXWj3C8hTnnkpE0qSa2P--dtDvwXXEeD0/pub)
* [https://github.com/thlorenz/v8-perf](https://github.com/thlorenz/v8-perf)
* [http://code.google.com/p/v8/wiki/UsingGit](http://code.google.com/p/v8/wiki/UsingGit)
* [http://mrale.ph/v8/resources.html](http://mrale.ph/v8/resources.html)
* [https://www.youtube.com/watch?v=UJPdhx5zTaw](https://www.youtube.com/watch?v=UJPdhx5zTaw)
* [https://www.youtube.com/watch?v=hWhMKalEicY](https://www.youtube.com/watch?v=hWhMKalEicY)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
