> * 原文地址：[A cartoon intro to WebAssembly](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/)
* 原文作者：[Lin Clark](https://code-cartoons.com/@linclark)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

# A cartoon intro to WebAssembly

WebAssembly is fast. You’ve probably heard this. But what is it that makes WebAssembly fast?

In this series, I want to explain to you why WebAssembly is fast.

## Wait, so what is WebAssembly?

WebAssembly is a way of taking code written in programming languages other than JavaScript and running that code in the browser. So when people say that WebAssembly is fast, what they are comparing it to is JavaScript.

Now, I don’t want to imply that it’s an either/or situation — that you’re either using WebAssembly or using JavaScript. In fact, we expect that developers will use both WebAssembly and JavaScript in the same application.

But it is useful to compare the two, so you can understand the potential impact that WebAssembly will have.

## A little performance history

JavaScript was created in 1995. It wasn’t designed to be fast, and for the first decade, it wasn’t fast.

Then the browsers started getting more competitive.

In 2008, a period that people call the performance wars began. Multiple browsers added just-in-time compilers, also called JITs. As JavaScript was running, the JIT could see patterns and make the code run faster based on those patterns.

The introduction of these JITs led to an inflection point in the performance of JavaScript. Execution of JS was 10x faster.

![A graph showing JS execution performance increasing sharply in 2008](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/01-01-perf_graph05-500x409.png)

With this improved performance, JavaScript started being used for things no one ever expected it to be used for, like server-side programming with Node.js. The performance improvement made it feasible to use JavaScript on a whole new class of problems.

We may be at another one of those inflection points now, with WebAssembly.

![A graph showing another performance spike in 2017 with a question mark next to it](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2017/02/01-02-perf_graph10-500x412.png)

So, let’s dive into the details to understand what makes WebAssembly fast.