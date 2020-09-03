> * 原文地址：[JavaScript Engines: An Overview](https://blog.bitsrc.io/javascript-engines-an-overview-2162bffa1187)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-engines-an-overview.md](https://github.com/xitu/gold-miner/blob/master/article/2020/javascript-engines-an-overview.md)
> * 译者：
> * 校对者：

# JavaScript Engines: An Overview

![Photo by [JOSHUA COLEMAN](https://unsplash.com/@joshstyle?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/t/technology?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10944/1*VzPVDApZ_xVLY0qGZGMAoA.jpeg)

## Introduction

A JavaScript engine is a computer program or an interpreter that executes JavaScript code. A JavaScript engine can be written in a wide variety of languages. For example, the V8 engine which powers Chrome browsers was written in C++, while the SpiderMonkey engine which powers Firefox browsers was written in C and C++.

A JavaScript engine can be implemented as a standard interpreter, or just-in-time compiler that compiles JavaScript to bytecode in some form. The first JavaScript engines were almost only interpreters, but most modern engines employ just-in-time (JIT) compilation for upgraded performance.

## Popular JavaScript Engines

All popular browsers have their own implementation of a JavaScript engine. Here are some popular JavaScript engines.

* Chrome’s [V8 engine](https://v8.dev/)
* Firefox’s [SpiderMonkey](https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey)
* Safari’s [JavaScriptCore](https://developer.apple.com/documentation/javascriptcore) (a.k.a Nitro, SquirrelFish and SquirrelFish Extreme)
* Edge’s [Chakra](https://github.com/microsoft/ChakraCore) — **but Edge has recently embraced Chromium‘s V8 engine**

## Flow Diagram of the JavaScript Engine

![Image Credits: Sander in [Dev.to](https://dev.to/sanderdebr/a-brief-explanation-of-the-javascript-engine-and-runtime-2idg)](https://cdn-images-1.medium.com/max/2000/0*NzDz1ZLZxP6ZgbvO.jpeg)

If you have ever wondered, how your JavaScript is processed, here is a simplified flow diagram.

#### 1. Parser

Initially, the HTML parser would come across a script tag with a JavaScript source. The source code within this script will be loaded as a UTF-16 byte stream to the byte stream decoder. These bytes are decoded into tokens that are forwarded to the parser. The engine would always avoid parsing code that isn’t currently needed, to be more efficient.

#### 2. AST

The parser generates nodes that are based on the tokens it receives. With these nodes, the Abstract Syntax Tree (AST) is created. ASTs play a crucial role in the semantic analysis where the compiler validates the proper use of language elements and keywords.

You can check out a live example by visiting [https://astexplorer.net/](https://astexplorer.net/)

#### 3. Interpreter

Next in the flow is the interpreter, it analyzes through the AST and generates byte code. It interprets the code line by line. When the byte code is generated, the AST will be removed and the memory space will be cleared. The interpreter produces unoptimized machine code quickly and can start running without delay.

The concern with interpreters is that executing the same function several times can get very sluggish, which is why we have a compiler that doesn’t repeat loops and is more streamlined.

#### 4. Profiler

The profiler assesses the code as it runs and recognizes areas where optimization techniques can be performed.

#### 5. Compiler

With the support of the profiler, any unoptimized code is passed to the compiler to perform enhancements and produce machine code that ultimately replaces its equivalent in the previously created unoptimized code by the interpreter.

#### 6. Optimized code

At the end of these 6 steps, you will receive a highly optimized code.

**Let's now have a brief look at Chrome’s V8 engine and what makes it stand out from others.**

## Chrome’s V8 Engine

V8 JavaScript engine is an open-source application written in C++ that compiles JavaScript to optimized machine code before execution. The V8 engine was initially created with the intention of increasing JavaScript performance in Chrome and Chromium-based browsers. Later on, with time, the latest versions enabled the execution of JavaScript code outside of the browser, enabling server-side scripting.

As initial JavaScript engines were interpreters, they worked on the code line by line. With time, this was not good enough. The Chrome V8 implemented a technique called Just-In-Time (JIT) compilation. This technique uses a mix of both interpreters and compilers to get better execution.

#### How does V8 differ from other engines?

V8 and other modern engines like SpiderMonkey, Rhino follow the same approach. But what makes V8 stand out is that it does not produce any intermediate code or bytecode.

But this all changed after 2016 where Chrome V8 team introduced an interpreter called **Ignition**. With Ignition, V8 compiles JavaScript functions to a short bytecode, which is between 50% to 25% the size of the equivalent baseline machine code. This bytecode is then executed by a high-performance interpreter which produces execution speeds on real-world websites close to those of code generated by V8’s existing baseline compiler.

![V8’s compilation pipeline with Ignition enabled (2016)— Source: [V8 Docs](https://v8.dev/blog/ignition-interpreter)](https://cdn-images-1.medium.com/max/2000/0*zEOYOFjXg-iJE3_i.png)

#### Rapid Change

You must keep in mind that the domain of web development is rapidly changing every day. Especially with browsers, there are numerous attempts to make performance and experience better. This results in regular changes and updates to the structure of the JavaScript engines. Therefore I would always advise you to check the official docs of an engine if you would like to learn more about it, as blog posts can become outdated. Even sometimes, this blog post can be outdated, by the time you read this 😜

**In the case of V8, the above-shown pipeline illustration is not what is present currently.** The below diagram shows the current pipeline. Be aware, this too can change soon as the V8 team is constantly working hard for continuous performance enhancements.

![V8’s latest abstract compilation pipeline(2017) — Source: [V8 Presentation](https://docs.google.com/presentation/d/1chhN90uB8yPaIhx_h2M3lPyxPgdPmkADqSNAoXYQiVE/edit#slide=id.g18d89eb289_1_362)](https://cdn-images-1.medium.com/max/2000/1*qKBM3zUTK_lE3vu87vwdlg.png)

![V8’s latest compilation pipeline(2017) — Source: [V8 Presentation](https://docs.google.com/presentation/d/1_eLlVzcj94_G4r9j9d_Lj5HRKFnq6jgpuPJtnmIBs88/edit#slide=id.g2134da681e_0_125)](https://cdn-images-1.medium.com/max/2000/1*Da6ylguo0X6aIKW1v51YcQ.png)

If you compare the above diagrams with the 2016 version of the pipeline, you would find that the Baseline section of the pipeline has completely been removed. You would also find that the Crankshaft has also been removed.

#### Advantages over old pipeline

The V8 team has given many reasons for this newly updated pipeline, some of them are,

* Reduced memory usage — the ignition code is up to 8 times smaller than full-codegen code
* Improved startup time — the byte code is smaller and faster to generate
* Improved baseline performance — no longer relying on optimizing compiler for **sufficiently** fast code

You can read more from the team over [here](https://github.com/thlorenz/v8-perf/blob/master/compiler.md#advantages-over-old-pipeline).

## New Developments from V8

#### JIT-less mode

V8 even has a JIT-less mode to run without any runtime allocation of executable memory. This is extremely useful in situations where there is no write access to executable memory in platforms such as iOS, smart TVs, game consoles.

You can read more over [here](https://v8.dev/blog/jitless).

#### Background compilation

With Chrome 66, V8 compiles JavaScript source code on a background thread, reducing the amount of time spent compiling on the main thread by between 5% to 20% on standard websites.

Read more in the official blog post over [here](https://v8.dev/blog/background-compilation).

---

I hope you got a great overview of a JavaScript Engine. Happy Coding!

**Resources**

- [V8 Docs](https://v8.dev/)
- [A crash course in just-in-time (JIT) compilers by Lin Clark](https://hacks.mozilla.org/2017/02/a-crash-course-in-just-in-time-jit-compilers/)
- [Article by Sander](https://dev.to/sanderdebr/a-brief-explanation-of-the-javascript-engine-and-runtime-2idg)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
