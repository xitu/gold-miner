> * 原文地址：[Functional Programming for Android developers — Part 1](https://medium.com/@anupcowkur/functional-programming-for-android-developers-part-1-a58d40d6e742#.it6ndspj6)
* 原文作者：[Anup Cowkur](https://medium.com/@anupcowkur)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [skyar2009](https://github.com/skyar2009)
* 校对者：

---

# Functional Programming for Android developers — Part 1
# Android 开发者如何函数式编程 （一）

![](https://cdn-images-1.medium.com/max/2000/1*DCzEYU60hk2pO7WCJj3GoQ.jpeg)

Lately, I’ve been spending a lot of time learning [Elixir](http://elixir-lang.org/) — An awesome functional programming language that is friendly to beginners.
最近我花了一些时间学习 [Elixir](http://elixir-lang.org/) —— 一个对初学者非常友好的函数式编程语言。

This got me thinking. Why not use some of the concepts and techniques from the functional world in Android programming?
我在想，为什么我们不在 Android 开发中使用函数式编程的思想和技术呢？

When most people hear the term *Functional Programming,* they think of Hacker News posts yammering on about Monads, Higher Order Functions and Abstract Data Types. It seems to be a mystical universe far removed from the toils of the daily programmer, reserved only for mightiest hackers descended from the the realm of Númenor.
大多数人当听到**函数式编程**时，他们会想到 Hacker News 发布的一些关于单子、高阶函数以及抽象数据类型的内容。这好像是一个离平时辛勤编码的程序员很远的神秘领域，它仅仅属于强大的黑客们。

Well, *screw that* ! I’m here to tell you that you too can learn it. You too can use it. You too can create beautiful apps with it. Apps that have elegant, readable codebases and have fewer errors.
不去管它！我要说你也可以学它，你也可以使用它，你也可以用它打造漂亮的应用 —— 优雅的、可读性强的并且错误少的应用。

Welcome to Functional Programming(FP) for Android developers. In this series, we’re gonna learn the fundamentals of FP and how we can use them in good old Java. The idea is to keep the concepts grounded in practicality and avoid as much academic jargon as possible.
欢迎阅读 Android 开发者如何函数式编程（FP）。接下来的一系列文章中，我将带领大家一起学习 FP 基础以及如何在老版本的 Java 中使用 FP。本文旨在实用性，会尽量少用学术性的言论。

FP is a huge subject. We’re gonna learn only the concepts and techniques that are useful to writing Android code. We might visit a few concepts that we can’t directly use for the sake of completeness but I’ll try to keep the material as relevant as possible.
FP 是一个很大的话题。我们接下来只会涉及对编写 Android 代码有用的思想和技术。由于完整性的原因大家可能会看到了一些不能直接应用的思想，但是我会尽可能的保证材料的相关性。

Ready? Let’s go.
准备好了吗？我们开始吧。

### What is Functional Programming and why should I use it?
### 什么是函数式编程？我为什么要用？

Good question. The term *Functional programming* is an umbrella for a range of programming concepts which the moniker doesn’t quite do justice to. At it’s core, It’s a style of programming that treats programs as evaluation of mathematical functions and avoids *mutable state* and *side effects* (we’ll talk about these soon enough).
问得好。**函数式编程**是一系列被不公平对待的编程思想的保护伞。它的核心思想是，它是一种将程序看成是数学方法的求值、不会**改变状态**、不会产生**副作用**（后面我们马上回谈到）的编程方式。

At it’s core, FP emphasises :
FP 核心思想强调：

- **Declarative code** — Programmers should worry about the *what* and let the compiler and runtime worry about the *how* ***.***
- **Explicitness** — Code should be as obvious as possible. In particular, Side effectsare to be isolated to avoid surprises. Data flow and error handling are explicitly defined and constructs like *GOTO* statements and *Exceptions* are avoided since they can put your application in unexpected states.
- **Concurrency** — Most functional code is concurrent by default because of a concept known as *functional purity*. The general agreement seems to be that this trait in particular is causing functional programming to rise in popularity since CPU cores aren’t getting faster every year like they used to (see [Moore’s law](https://en.wikipedia.org/wiki/Moore%27s_law)) and we have to make our programs more concurrent to take advantage of multi-core architectures.
- **Higher Order Functions** — Functions are first class members just like all the other language primitives. You can pass functions around just like you would a string or an int.
- **Immutability** — Variables are not to be modified once they’re initialised. Once a thing is created, it is that thing forever. If you want it to change, you create a new thing. This is another aspect of explicitness and avoiding side effects. If you know that a thing cannot change, you have much more confidence about its state when you use it.

- **声明式代码** —— 程序员应该关心**是什么**，让编译器和运行环境去关心**怎样做**。
- **明确性** —— 代码应该尽可能的明显。尤其是要隔离副作用避免意外。要明确定义数据流和错误处理，要避免 **GOTO** 语句和 **异常**，因为它们会将应用置于意外的状态。
- **高阶函数** —— 函数和其他的语言基本元素一样是一等公民。你可以像使用 string 和 int 一样的去传递函数。
- **不变性** —— 变量一经初始化将不能修改。一经创建，永不改变。如果需要改变，需要创建新的。这是明确性和避免副作用之外的另一方面。如果你知道一个变量不能改变，当你使用时会对它的状态更有信心。

Declarative, Explicit and Concurrent code that is easier to reason about and is designed to avoid surprises? I hope I’ve piqued your interest.
声明式、明确性和可并发的代码，难道不是更易推导以及从设计上就避免了意外吗？真希望已经激起了你的兴趣。

In this first part of the series, let’s start with some of the most fundamental concepts in FP : *Purity*, *Side effects* and *Ordering*.
作为本系类文章的第一部分，我们从一些 FP 的基本概念开始：**纯粹**、**副作用**和**排序**。

### Pure functions
### 纯函数

A function is pure if its output depends only on its input and has no *side effects* (we’ll talk about the side effects bit right after this). Let’s see an example, shall we?
当一个函数的输出只依赖输入并且没有**副作用**（我们后面马上会谈到），那么这个函数就是纯函数。下面我们看一个例子。

Consider this simple function that adds two numbers. It reads one number from a file and the other number is passed in as a parameter.
一个简单的两数求和的函数。一个数从文件中读取，另一个数是传进来的参数。

    int add(int x) {
        int y = readNumFromFile();
        return x + y;
    }

This function’s output is not dependent solely on its input. Depending on what *readNumFromFile()* returns, it can have different outputs for the same value of *x*. This function is said to be *impure*.
这个函数的输出不仅仅依赖于输入，还依赖于 **readNumFromFile()** 的返回，对于相同的入参 **x** 可能有不同的输出。这个函数不是纯函数。

Let’s convert it into a pure function.
下面我们将它改为纯函数。

    int add(int x, int y) {
        return x + y;
    }

Now the function’s output is only dependent on its inputs. For a given *x* and *y,* The function will always return the same output. This function is now said to be *pure*. Mathematical functions also operate in the same way. A mathematical functions output only depends on its inputs — This is why functional programming is much closer to math than the usual programming style we are used to.
现在函数的输出只依赖于输入了。对于给定的 **x** 和 **y**，函数总会返回相同的输出。这个函数式**纯函数**。数学函数的计算与之一样，一个数学函数的输出只依赖于输入 —— 这也是为什么函数式编程更像数学，而不是我们通常使用的编程方式。

P.S. An empty input is still an input. If a function takes no inputs and returns the same constant every time, it’s still pure.
P.S. 没有输入也是一种输入。如果一个函数没有输入并且每次的返回总是相同不变的，那么它也是一个纯函数。

P.P.S. The property of always returning the same output for a given input is also known as *referential transparency* and you might see it used when talking about pure functions.
P.P.S. 固定输入总是返回相同输出的属性也被成为 **引用透明性**，当讨论纯函数时你可能会遇到这种说法。

### Side effects
### 副作用

Let’s explore this concept with the same addition function example. We’ll modify the addition function to also write the result to a file.
我们修改下原来的函数来研究这个概念，我们将函数改成可以将计算结果存储到文件中。

    int add(int x, int y) {
        int result = x + y;
        writeResultToFile(result);
        return result;
    }

This function is now writing the result of the computation to a file. i.e. it is now modifying the state of the outside world. This function is now said to have a *side effect* and is no longer a pure function.
该函数将计算结果写到了一个文件中，也就是修改了外界的状态。那么该函数就是有 **副作用**，不再是纯函数了。

Any code that modifies the state of the outside world — changes a variable, writes to a file, writes to a DB, deletes something etc — is said to have a side effect.
任何修改外界状态（修改变量、写文件、存储 DB、删除内容等）的代码都是有副作用的。

Functions that have side effects are avoided in FP because they are no longer pure and depend on *historical context*. The context of the code is not self contained. This makes them much harder to reason about.
FP 中应该避免使用有副作用的函数，因为它们不在是纯函数而是依赖于**历史上下文**。代码的上下文不是由自身决定，这将导致它们更难推导。

Let’s say you are writing a piece of code that depends on a cache. Now the output of your code depends on whether someone wrote to the cache, what was written in it, when it was written, if the data is valid etc. You can’t understand what your program is doing unless you understand all the possible states of the cache it depends on. If you extend this to include all the other things your app depends on — network, database, files, user input and so on, it becomes very hard to know what exactly is going on and to fit it all into your head at once.
我们假设你写了一段依赖缓存的代码，代码的输出依赖于是否有人已经对缓存做了写操作、写入了什么、什么时候写入的、写入的数据是否有效等。你无法知道你的程序在做什么，除非你知道它依赖的缓存的所有可能状态。如果你拓展代码以包括所有应用依赖的内容 —— 网络、数据库、文件、用户输入等等，那么会变得很难确切的知道正在发生什么，以及很难一次性将所有内容都考虑到。

Does this means we don’t use network, databases and caches then? Of course not. At the end of the execution, you want the app to do something. In the case of Android apps, it usually means updating the UI so that the user can actually get something useful from our app.
这是否意味着我们不使用网络、数据库和缓存了？当然不是。当执行结束之后，应用往往需要做些什么。以 Android 应用为例，往往是更新 UI 以便用户从我们的应用中真正的获得有用的内容。

FP’s greatest idea is not to completely forego side effects but to contain and isolate them. Instead of having our app littered with functions that have side effects, we push side effects to the edges of our system so they have as little impact as possible, making our app easier to reason about. We’ll talk about this in detail when we explore a *functional architecture* for our apps later in the series.
FP 最伟大的概念并非完全的放弃副作用，而是包容、隔离它们。我们将副作用置于系统的边缘，尽可能减少影响，使得应用更易懂，避免有副作用的函数将应用弄得一团糟。在本系列后面的文章中，研究应用的**函数式架构**时，我们会具体的讨论这个问题。

### Ordering
### 排序

If we have a bunch of pure functions that have no side effects, then the order in which they are executed becomes irrelevant.
如果我们有几个没有副作用的纯函数，那么它们的执行顺序是无关紧要的。

Let’s say we have a function that calls 3 pure functions internally:
我们看个例子，我们有一个函数，函数会调用 3 个纯函数：

    void doThings() {
        doThing1();
        doThing2();
        doThing3();
    }

We know for sure that these functions don’t depend on each other (since the output of one is not the input of another) and we also know that they won’t change anything in the system (since they are pure). This makes the order in which they are executed completely interchangeable.
我们明确的知道这些函数互不依赖（因为一个函数的输出不是另一个的输入）并且我们知道它们不会改变系统的任何内容（因为它们是纯函数）。这样它们的执行顺序是完全可交换的。

The order of execution can be re-shuffled and optimised for independent pure functions. Note that if the input of *doThing2()* were the result of *doThing1()* then these would have to be executed in order, but *doThing3()* could still be re-ordered to execute before *doThing1().*
独立的纯函数的执行顺序是可重排序和优化的。需要注意的是，如果 **doThing1()** 的结果是 **doThing2()** 的输入，那么它们需要按顺序执行，但是 **doThing3()** 依然可以重排序在 **doThing1()** 之前执行。

What does this ordering property get us though? *Concurrency,* that’s what! We can run these functions on 3 separate CPU cores without worrying about screwing anything up!
可重排序的特性对我们来说有什么益处？当然是**并发**了。我们可以在 3 个 CPU 上分别运行它们，而不需要担心发生任何问题。

In many cases, compilers in advanced pure functional languages like [Haskell](https://www.haskell.org/) can tell by formally analysing your code whether it’s concurrent or not, and can stop you from shooting yourself in the foot with deadlocks, race conditions and the like. These compilers can theoretically also auto-parallelise your code (this doesn’t actually exist in any compiler I know of at the moment but research is ongoing).
多数情况下，像 [Haskell](https://www.haskell.org/) 这样高级纯函数式语言的编译器中，可以通过分析你的代码判断是否可并行，可以防止你出现搬起石头砸自己的脚的事情（比如死锁、条件竞争等）。这些编译器理论上可以自动并行化你的代码（虽然据我所知目前编译器都不支持，但是相关的研究正在进行）。

Even if your compiler is not looking at this stuff, as a programmer, it’s great to be able to tell whether your code is concurrent just by looking at the function signatures and avoid nasty threading bugs trying to parallelise imperative code which might be full of hidden side effects.
尽管你的编译器并不像上面说的那样，但单作为一个程序员，有能够根据函数的签名判断代码是否可并行，并且避免代码存在隐性副作用而导致线程问题的能力还是很重要的。

### Summary
### 总结

I hope this first part has intrigued you about FP. Pure, Side effect free functions make it much easier to reason about code and are the first step to achieving concurrency.
希望第一本分已经激起了你对 FP 的兴趣。纯粹性、无副作用的函数是的代码更易读并且是实现并行的第一步。

Before we get to concurrency though, we have to learn about *immutability*. We’ll do just that in Part 2 of this series and see how pure functions and immutability can help us write simple and easy to understand concurrent code without resorting to locks and mutexes.
在我们开始实现并行之前，我们需要了解下 **不变性**。在本系列文章的第二部分将进行探讨，并且可以看到在不需要借助锁和互斥变量的情况下，纯函数和不变性是如何帮助我们编写简单易懂的可并行代码的。