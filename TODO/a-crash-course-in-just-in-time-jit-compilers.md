> * 原文地址：[A crash course in just-in-time (JIT) compilers](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)
* 原文作者：[Lin Clark](http://code-cartoons.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[zhouzihanntu](https://github.com/zhouzihanntu)
* 校对者：

# A crash course in just-in-time (JIT) compilers #
# JIT 编译器快速入门 #

*This is the second part in a series on WebAssembly and what makes it fast. If you haven’t read the others, we recommend [starting from the beginning](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/).*
**本文是 WebAssembly 系列文章的第二部分。如果你还没有阅读过前面的文章，我们建议你 [从头开始看](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/).**

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
在电影中，人类和外星人在尝试交流的过程里并不只是做逐字翻译。这两个群体对世界有不同的思考方式，人类和机器也是如此（我将在下一篇文章中详细说明）。

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
因此，解释器看起来自然很适合 JavaScript 这类语言。对 Web 开发者来说，能够快速运行代码相当重要。

And that’s why browsers used JavaScript interpreters in the beginning.
这就是各浏览器一开始使用 JavaScript 解释器的原因。

But the con of using an interpreter comes when you’re running the same code more than once. For example, if you’re in a loop. Then you have to do the same translation over and over and over again.
但是当你重复运行同样的代码时，解释器的劣势就显现出来了。举个例子，如果在循环中，你就不得不重复执行同样的转化。

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
## 两全其美的解决办法————即时编译器 ##

As a way of getting rid of the interpreter’s inefficiency—where the interpreter has to keep retranslating the code every time they go through the loop—browsers started mixing compilers in.

Different browsers do this in slightly different ways, but the basic idea is the same. They added a new part to the JavaScript engine, called a monitor (aka a profiler). That monitor watches the code as it runs, and makes a note of how many times it is run and what types are used.

At first, the monitor just runs everything through the interpreter.

![Monitor watching code execution and signaling that code should be interpreted](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-04-jit02-500x365.png)

If the same lines of code are run a few times, that segment of code is called warm. If it’s run a lot, then it’s called hot.

### Baseline compiler ###

When a function starts getting warm, the JIT will send it off to be compiled. Then it will store that compilation.

![Monitor sees function is called multiple times, signals that it should go to the baseline compiler to have a stub created](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-05-jit06-500x368.png)

Each line of the function is compiled to a “stub”. The stubs are indexed by line number and variable type (I’ll explain why that’s important later). If the monitor sees that execution is hitting the same code again with the same variable types, it will just pull out its compiled version.

That helps speed things up. But like I said, there’s more a compiler can do. It can take some time to figure out the most efficient way to do things… to make optimizations.

The baseline compiler will make some of these optimizations (I give an example of one below). It doesn’t want to take too much time, though, because it doesn’t want to hold up execution too long.

However, if the code is really hot—if it’s being run a whole bunch of times—then it’s worth taking the extra time to make more optimizations.

### Optimizing compiler ###
### 优化编译器 ###

When a part of the code is very hot, the monitor will send it off to the optimizing compiler. This will create another, even faster, version of the function that will also be stored.

![Monitor sees function is called even more times, signals that it should be fully optimized](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-06-jit09-500x365.png)

In order to make a faster version of the code, the optimizing compiler has to make some assumptions.

For example, if it can assume that all objects created by a particular constructor have the same shape—that is, that they always have the same property names, and that those properties were added in the same order— then it can cut some corners based on that.

The optimizing compiler uses the information the monitor has gathered by watching code execution to make these judgments. If something has been true for all previous passes through a loop, it assumes it will continue to be true.

But of course with JavaScript, there are never any guarantees. You could have 99 objects that all have the same shape, but then the 100th might be missing a property.

So the compiled code needs to check before it runs to see whether the assumptions are valid. If they are, then the compiled code runs. But if not, the JIT assumes that it made the wrong assumptions and trashes the optimized code.

![Monitor sees that types don't match expectations, and signals to go back to interpreter. Optimizer throws out optimized code](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-07-jit11-500x361.png)

Then execution goes back to the interpreter or baseline compiled version. This process is called deoptimization (or bailing out).

Usually optimizing compilers make code faster, but sometimes they can cause unexpected performance problems. If you have code that keeps getting optimized and then deoptimized, it ends up being slower than just executing the baseline compiled version.

Most browsers have added limits to break out of these optimization/deoptimization cycles when they happen. If the JIT has made more than, say, 10 attempts at optimizing and keeps having to throw it out, it will just stop trying.

### An example optimization: Type specialization ###
### 优化示例: Type specialization ###

There are a lot of different kinds of optimizations, but I want to take a look at one type so you can get a feel for how optimization happens. One of the biggest wins in optimizing compilers comes from something called type specialization.

The dynamic type system that JavaScript uses requires a little bit of extra work at runtime. For example, consider this code:

```
functionarraySum(arr) {
  var sum = 0;
  for (var i = 0; i < arr.length; i++) {
    sum += arr[i];
  }
}

```

The `+=` step in the loop may seem simple. It may seem like you can compute this in one step, but because of dynamic typing, it takes more steps than you would expect.

Let’s assume that `arr` is an array of 100 integers. Once the code warms up, the baseline compiler will create a stub for each operation in the function. So there will be a stub for `sum += arr[i]`, which will handle the `+=` operation as integer addition.

However,`sum` and `arr[i]` aren’t guaranteed to be integers. Because types are dynamic in JavaScript, there’s a chance that in a later iteration of the loop, `arr[i]` will be a string. Integer addition and string concatenation are two very different operations, so they would compile to very different machine code.

The way the JIT handles this is by compiling multiple baseline stubs. If a piece of code is monomorphic (that is, always called with the same types) it will get one stub. If it is polymorphic (called with different types from one pass through the code to another), then it will get a stub for each combination of types that has come through that operation.

This means that the JIT has to ask a lot of questions before it chooses a stub.

![Decision tree showing 4 type checks](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-08-decision_tree01-500x257.png)

Because each line of code has its own set of stubs in the baseline compiler, the JIT needs to keep checking the types each time the line of code is executed. So for each iteration through the loop, it will have to ask the same questions.

![Code looping with JIT asking what types are being used in each loop](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-09-jit_loop02-500x323.png)

The code would execute a lot faster if the JIT didn’t need to repeat those checks. And that’s one of the things the optimizing compiler does.

In the optimizing compiler, the whole function is compiled together. The type checks are moved so that they happen before the loop.

![Code looping with questions being asked ahead of time](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/02-10-jit_loop02-500x318.png)

Some JITs optimize this even further. For example, in Firefox there’s a special classification for arrays that only contain integers. If `arr` is one of these arrays, then the JIT doesn’t need to check if `arr[i]` is an integer. This means that the JIT can do all of the type checks before it enters the loop.

## Conclusion ##
## 结论 ##

That is the JIT in a nutshell. It makes JavaScript run faster by monitoring the code as it’s running it and sending hot code paths to be optimized. This has resulted in many-fold performance improvements for most JavaScript applications.

Even with these improvements, though, the performance of JavaScript can be unpredictable. And to make things faster, the JIT has added some overhead during runtime, including:

- optimization and deoptimization
- memory used for the monitor’s bookkeeping and recovery information for when bailouts happen
- memory used to store baseline and optimized versions of a function

There’s room for improvement here: that overhead could be removed, making performance more predictable. And that’s one of the things that WebAssembly does.

In the [next article](https://hacks.mozilla.org/?p=30503), I’ll explain more about assembly and how compilers work with it.
