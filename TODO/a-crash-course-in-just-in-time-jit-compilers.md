> * 原文地址：[A crash course in just-in-time (JIT) compilers](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)
* 原文作者：[Lin Clark](http://code-cartoons.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[zhouzihanntu](https://github.com/zhouzihanntu)
* 校对者：

# A crash course in just-in-time (JIT) compilers #
# JIT 编译器快速入门 #

*This is the second part in a series on WebAssembly and what makes it fast. If you haven’t read the others, we recommend [starting from the beginning](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/).*
**本文是 WebAssembly 系列文章的第二部分。如果你还没有阅读过前面的文章，我们建议你 [从头开始](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/).**

JavaScript started out slow, but then got faster thanks to something called the JIT. But how does the JIT work?
JavaScript 刚面世时运行速度是很慢的，而 JIT 的出现令其性能快速提升。那么问题来了，JIT 是如何运作的呢？

## How JavaScript is run in the browser ##
## JavaScript 在浏览器中的运行机制 ##

When you as a developer add JavaScript to the page, you have a goal and a problem.
作为一名开发者，当你向网页中添加 JavaScript 代码的时候，you have a goal and a problem.

Goal: you want to tell the computer what to do.
Goal: 你想要告诉计算机做什么。

Problem: you and the computer speak different languages.
Problem: 你和计算机使用的是不同的语言。

You speak a human language, and the computer speaks a machine language. Even if you don’t think about JavaScript or other high-level programming languages as human languages, they really are. They’ve been designed for human cognition, not for machine cognition.
你使用的是人类语言，而计算机使用的是机器语言。即使你不愿承认，对于计算机来说 JavaScript 甚至其他高级编程语言都是人类语言。这些语言是为人类的认知设计的，而不是机器。

So the job of the JavaScript engine is to take your human language and turn it into something the machine understands.
所以 JavaScript 引擎的作用就是将你使用的人类语言转换成机器能够理解的东西。

I think of this like the movie [Arrival](https://en.wikipedia.org/wiki/Arrival_(film), where you have humans and aliens who are trying to talk to each other.
我认为这就像电影 [降临](https://en.wikipedia.org/wiki/Arrival_(film) 里人类和外星人试图互相交谈的情节一样。

![A person holding a sign with source code on it, and an alien responding in binary](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-01-alien03-500x286.png)

In that movie, the humans and aliens don’t just do word-for-word translations. The two groups have different ways of thinking about the world. And that’s true of humans and machines too (I’ll explain this more in the next post).
在那部电影中，人类和外星人在尝试交流的过程里并不只是做逐字翻译。这两个群体对世界有不同的思考方式，人类和机器也是如此（我将在下一篇文章中详细说明）。

So how does the translation happen?
既然这样，那转化是如何发生的呢？

In programming, there are generally two ways of translating to machine language. You can use an interpreter or a compiler.
在编程中，我们通常使用解释器和编译器这两种方法将程序代码转化为机器语言。

With an interpreter, this translation happens pretty much line-by-line, on the fly.
解释器会在程序运行时对代码进行逐行转义。

![A person standing in front of a whiteboard, translating source code to binary as they go](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-02-interp02-500x291.png)

A compiler on the other hand doesn’t translate on the fly. It works ahead of time to create that translation and write it down.
相反的是，编译器会提前将代码转义并保存下来，而不是在运行时对代码进行转义。

![A person holding up a page of translated binary](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-03-compile02-500x297.png)

There are pros and cons to each of these ways of handling the translation.
以上两种转化方式都各有优劣。

### Interpreter pros and cons ###
### 解释器的优缺点 ###

Interpreters are quick to get up and running. You don’t have to go through that whole compilation step before you can start running your code. You just start translating that first line and running it.
解释器可以迅速开始工作。你不必等待所有的汇编步骤完成，只要开始转义第一行代码就可以就可以运行程序了。

Because of this, an interpreter seems like a natural fit for something like JavaScript. It’s important for a web developer to be able to get going and run their code quickly.
因此，解释器看起来自然很适用于 JavaScript 这类语言。对于 Web 开发者来说，能够快速运行代码相当重要。

And that’s why browsers used JavaScript interpreters in the beginning.
这就是各浏览器在初期使用 JavaScript 解释器的原因。

But the con of using an interpreter comes when you’re running the same code more than once. For example, if you’re in a loop. Then you have to do the same translation over and over and over again.
但是当你重复运行同样的代码时，解释器的劣势就显现出来了。举个例子，如果在循环中，你就不得不重复对循环体进行转化。

### Compiler pros and cons ###
### 编译器的优缺点 ###

The compiler has the opposite trade-offs.
编译器的权衡恰恰和解释器相反。

It takes a little bit more time to start up because it has to go through that compilation step at the beginning. But then code in loops runs faster, because it doesn’t need to repeat the translation for each pass through that loop.
使用编译器在启动时会花费多一些时间，因为它必须在启动前完成编译的所有步骤。但是在循环体中的代码运行速度更快，因为它不需要在每次循环时都进行编译。

Another difference is that the compiler has more time to look at the code and make edits to it so that it will run faster. These edits are called optimizations.
另一个不同之处在于编译器有更多时间对代码进行查看和编辑，来让程序运行得更快。这些编辑我们称为优化。Another difference is that the compiler has more time to look at the code and make edits to it so that it will run faster. These edits are called optimizations.

The interpreter is doing its work during runtime, so it can’t take much time during the translation phase to figure out these optimizations.
解释器在程序运行时工作，因此它无法在转义过程中花费大量时间来确定这些优化。

## Just-in-time compilers: the best of both worlds ##
## 两全其美的解决办法 —— JIT 编译器 ##

As a way of getting rid of the interpreter’s inefficiency—where the interpreter has to keep retranslating the code every time they go through the loop — browsers started mixing compilers in.
为了解决解释器在循环时重复编译导致的低效问题，浏览器开始将编译器混合进来。

Different browsers do this in slightly different ways, but the basic idea is the same. They added a new part to the JavaScript engine, called a monitor (aka a profiler). That monitor watches the code as it runs, and makes a note of how many times it is run and what types are used.
不同浏览器的实现方式稍有不同，但基本思路是一致的。它们向 JavaScript 引擎添加了一个新的部件，我们称之为监视器（又名分析器）。监视器会在代码运行时监视并记录下代码的运行次数和使用到的类型。

At first, the monitor just runs everything through the interpreter.
起初，监视器只是通过解释器执行所有操作。

![Monitor watching code execution and signaling that code should be interpreted](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-04-jit02-500x365.png)

If the same lines of code are run a few times, that segment of code is called warm. If it’s run a lot, then it’s called hot.
如果一段代码运行了几次，这段代码被称为 warm code ；如果这段代码运行了很多次，它就会被称为 hot code。（这里的 warm code 和 hot code 拿捏不清楚要不要翻译😳麻烦校对小伙伴帮忙斟酌一下哈～）

### Baseline compiler ###
### 基线编译器 ###

When a function starts getting warm, the JIT will send it off to be compiled. Then it will store that compilation.
当一个函数运行了数次时，JIT 会将该函数发送给编译器编译，然后把编译结果保存下来。

![Monitor sees function is called multiple times, signals that it should go to the baseline compiler to have a stub created](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-05-jit06-500x368.png)

Each line of the function is compiled to a “stub”. The stubs are indexed by line number and variable type (I’ll explain why that’s important later). If the monitor sees that execution is hitting the same code again with the same variable types, it will just pull out its compiled version.
该函数的每一行都被编译成一个“存根”，存根以行号和变量类型为索引（这很重要，我后面会解释）。如果监视器监测到程序再次使用相同类型的变量运行这段代码，它将直接抽取出对应代码的编译后版本。

That helps speed things up. But like I said, there’s more a compiler can do. It can take some time to figure out the most efficient way to do things… to make optimizations.
这有助于加快程序的运行速度，但是像我说的，编译器可以做得更多。只要花费一些时间，它能够确定最高效的执行方式，即优化。

The baseline compiler will make some of these optimizations (I give an example of one below). It doesn’t want to take too much time, though, because it doesn’t want to hold up execution too long.
基线编译器可以完成一些优化（我会在后续给出示例）。不过，为了不阻拦进程过久，它并不愿意在优化上花费太多时间。

However, if the code is really hot—if it’s being run a whole bunch of times—then it’s worth taking the extra time to make more optimizations.
然而，如果这段代码运行次数实在太多，那就值得花费额外的时间对它做进一步优化。

### Optimizing compiler ###
### 优化编译器 ###

When a part of the code is very hot, the monitor will send it off to the optimizing compiler. This will create another, even faster, version of the function that will also be stored.
当一段代码运行的频率非常高时，监视器会把它发送给优化编译器。然后得到另一个运行速度更快的函数版本并保存下来。

![Monitor sees function is called even more times, signals that it should be fully optimized](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-06-jit09-500x365.png)

In order to make a faster version of the code, the optimizing compiler has to make some assumptions.
为了得到运行速度更快的代码版本，优化编译器会做一些假设。

For example, if it can assume that all objects created by a particular constructor have the same shape—that is, that they always have the same property names, and that those properties were added in the same order— then it can cut some corners based on that.
举例来说，如果它可以假设由特定构造函数创建的所有对象结构相同，即所有对象的属性名相同，并且这些属性的添加顺序相同，它就可以基于这个进行优化。

The optimizing compiler uses the information the monitor has gathered by watching code execution to make these judgments. If something has been true for all previous passes through a loop, it assumes it will continue to be true.
优化编译器会依据监视器监测代码运行时收集到的信息做出判断。如果在之前通过的循环中有一个值总是 true，它便假定这个值在后续的循环中也是 true。

But of course with JavaScript, there are never any guarantees. You could have 99 objects that all have the same shape, but then the 100th might be missing a property.
但在 JavaScript 中没有任何情况是可以保证的。你可能会先得到 99 个结构相同的对象，但第 100 个就有可能缺少一个属性。

So the compiled code needs to check before it runs to see whether the assumptions are valid. If they are, then the compiled code runs. But if not, the JIT assumes that it made the wrong assumptions and trashes the optimized code.
所以编译后的代码在运行前需要检查假设是否有效。如果有效，编译后的代码即运行。但如果无效，JIT 就认为它做了错误的假设并销毁对应的优化后代码。

![Monitor sees that types don't match expectations, and signals to go back to interpreter. Optimizer throws out optimized code](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-07-jit11-500x361.png)

Then execution goes back to the interpreter or baseline compiled version. This process is called deoptimization (or bailing out).
进程会回退到解释器或基线编译器编译的版本。这个过程被称为去优化（或应急机制）。

Usually optimizing compilers make code faster, but sometimes they can cause unexpected performance problems. If you have code that keeps getting optimized and then deoptimized, it ends up being slower than just executing the baseline compiled version.
通常优化编译器会加快代码运行速度，但有时它们也会导致意外的性能问题。如果你的代码被不断的优化和去优化，运行速度会比基线编译版本更慢。

Most browsers have added limits to break out of these optimization/deoptimization cycles when they happen. If the JIT has made more than, say, 10 attempts at optimizing and keeps having to throw it out, it will just stop trying.
为了防止这种情况，许多浏览器添加了限制，以便在“优化-去优化”这类循环发生时打破循环。例如，当 JIT 尝试了 10 次优化仍未成功时，就会停止当前优化。

### An example optimization: Type specialization ###
### 优化示例: 类型专门化 ###

There are a lot of different kinds of optimizations, but I want to take a look at one type so you can get a feel for how optimization happens. One of the biggest wins in optimizing compilers comes from something called type specialization.
优化的类型有很多，但我会演示其中一种以便你理解优化是如何发生的。优化编译器最大的成功之一来自于类型专门化。


The dynamic type system that JavaScript uses requires a little bit of extra work at runtime. For example, consider this code:
JavaScript 使用的动态类型系统在运行时需要多做一些额外的工作。例如下面这段代码：

```
function arraySum(arr) {
  var sum = 0;
  for (var i = 0; i < arr.length; i++) {
    sum += arr[i];
  }
}

```

The `+=` step in the loop may seem simple. It may seem like you can compute this in one step, but because of dynamic typing, it takes more steps than you would expect.
执行循环中的 `+=` 一步似乎很简单。看起来你可以一步就得到计算结果，但由于 JavaScript 的动态类型，处理它所需要的步骤比你想象的多。

Let’s assume that `arr` is an array of 100 integers. Once the code warms up, the baseline compiler will create a stub for each operation in the function. So there will be a stub for `sum += arr[i]`, which will handle the `+=` operation as integer addition.
假定 `arr` 是一个存放 100 个整数的数组。在代码执行几次后，基线编译器将为函数中的每个操作创建一个存根。`sum += arr[i]` 将会有一个把 `+=` 依据整数加法处理的存根。

However,`sum` and `arr[i]` aren’t guaranteed to be integers. Because types are dynamic in JavaScript, there’s a chance that in a later iteration of the loop, `arr[i]` will be a string. Integer addition and string concatenation are two very different operations, so they would compile to very different machine code.
然而我们并不能保证 `sum` 和 `arr[i]` 一定是整数。因为在 JavaScript 中数据类型是动态的，有可能在下一次循环中的 `arr[i]` 是一个字符串。整数加法和字符串拼接是两个完全不同的操作，因此也会编译成非常不同的机器码。

The way the JIT handles this is by compiling multiple baseline stubs. If a piece of code is monomorphic (that is, always called with the same types) it will get one stub. If it is polymorphic (called with different types from one pass through the code to another), then it will get a stub for each combination of types that has come through that operation.
JIT 处理这种情况的方法是编译多个基线存根。一段代码如果是单态的（即总被同一种类型调用），将得到一个存根。如果是多态的（即被不同类型调用），那么它将得到分别对应各类型组合操作的存根。

This means that the JIT has to ask a lot of questions before it chooses a stub.
这意味着 JIT 在确定存根前要问许多问题。

![Decision tree showing 4 type checks](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-08-decision_tree01-500x257.png)

Because each line of code has its own set of stubs in the baseline compiler, the JIT needs to keep checking the types each time the line of code is executed. So for each iteration through the loop, it will have to ask the same questions.
在基线编译器中，由于每一行代码都有各自对应的存根，每次代码运行时，JIT 要不断检查该行代码的操作类型。因此在每次循环时，JIT 都要询问相同的问题。

![Code looping with JIT asking what types are being used in each loop](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-09-jit_loop02-500x323.png)

The code would execute a lot faster if the JIT didn’t need to repeat those checks. And that’s one of the things the optimizing compiler does.
如果 JIT 不需要重复这些检查，代码运行速度会加快很多。这就是优化编译器的工作之一了。

In the optimizing compiler, the whole function is compiled together. The type checks are moved so that they happen before the loop.
在优化编译器中，整个函数会被一起编译。The type checks are moved 所以类型检查可以在循环开始前完成。

![Code looping with questions being asked ahead of time](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-10-jit_loop02-500x318.png)

Some JITs optimize this even further. For example, in Firefox there’s a special classification for arrays that only contain integers. If `arr` is one of these arrays, then the JIT doesn’t need to check if `arr[i]` is an integer. This means that the JIT can do all of the type checks before it enters the loop.
一些 JIT 编译器做了进一步优化。例如，在 Firefox 中为仅包含整数的数组设立了一个特殊分类。如果 `arr` 是在这个分类下的数组，JIT 就不需要检查 `arr[i]` 是否是整数了。这意味着 JIT 可以在进入循环前完成所有类型检查。

## Conclusion ##
## 总结 ##

That is the JIT in a nutshell. It makes JavaScript run faster by monitoring the code as it’s running it and sending hot code paths to be optimized. This has resulted in many-fold performance improvements for most JavaScript applications.
简而言之，这就是 JIT。它通过监控代码运行确定高频代码，并进行优化，加快了 JavaScript 的运行速度。

Even with these improvements, though, the performance of JavaScript can be unpredictable. And to make things faster, the JIT has added some overhead during runtime, including:
即使有了这些改进，JavaScript 的性能仍是不可预测的。为了加速代码运行，JIT 在运行时增加了以下开销：

- optimization and deoptimization
- 优化和去优化
- memory used for the monitor’s bookkeeping and recovery information for when bailouts happen
- 用于存储监视器纪录和应急回退时的恢复信息的内存
- memory used to store baseline and optimized versions of a function
- 用于存储函数的基线和优化版本的内存

There’s room for improvement here: that overhead could be removed, making performance more predictable. And that’s one of the things that WebAssembly does.
这里还有改进空间：除去以上的开销，提高性能的可预测性。这是 WebAssembly 实现的工作之一。

In the [next article](https://hacks.mozilla.org/?p=30503), I’ll explain more about assembly and how compilers work with it.
在[下一篇文章](https://hacks.mozilla.org/?p=30503)中，我将对集成和它与编译器的工作原理做更多说明。
