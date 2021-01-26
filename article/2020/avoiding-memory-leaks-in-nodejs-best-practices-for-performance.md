> * 原文地址：[Avoiding Memory Leaks in Node.js: Best Practices for Performance](https://blog.appsignal.com/2020/05/06/avoiding-memory-leaks-in-nodejs-best-practices-for-performance.html)
> * 原文作者：[Deepu K Sasidharan](https://twitter.com/deepu105)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/avoiding-memory-leaks-in-nodejs-best-practices-for-performance.md](https://github.com/xitu/gold-miner/blob/master/article/2020/avoiding-memory-leaks-in-nodejs-best-practices-for-performance.md)
> * 译者： [laampui](https://github.com/laampui)
> * 校对者： [Usualminds](https://github.com/Usualminds), [regon-cao](https://github.com/regon-cao)

# 在 Node.js 中避免内存泄漏：性能最佳实践

内存泄漏是每一位开发者最终都会遇到的问题。它存在于大多数的编程语言里，即使是能够自动管理内存的语言也不例外。内存泄漏会导致一些如应用缓慢、崩溃、高延迟等问题。

在这篇文章中，我们会了解到什么是内存泄漏以及如何在 Node.js 中避免它。虽然这篇文章着重点在 NodeJS，但应该也适用于 JavaScript 和 TypeScript。规避内存泄漏有助于你的应用更高效地利用资源同时也能带来性能提升。

## JavaScript 中的内存管理

要理解内存泄漏，我们首先需要理解 NodeJS 是如何管理内存的。这意味着需要了解内存是如何被 NodeJS 的 JavaScript 引擎管理的。对于 JavaScript，NodeJS 使用 **[V8 引擎](https://v8.dev/)**，对于内存是如何被 V8 组织及利用，你可以参阅 [Visualizing memory management in V8 Engine](https://dev.to/deepu105/visualizing-memory-management-in-v8-engine-javascript-nodejs-deno-webassembly-105p) 来获得更好的理解。

总结上面提及的那篇参阅文章：

内存主要分为栈和堆。

* **栈**：存放静态数据，包括方法（函数）帧、原始值和指向对象的指针。这里的空间是被操作系统管理的。
* **堆**：V8 存放对象或动态数据。这是内存区域中最大的一块并且这里是 **垃圾回收(GC)** 生效的地方。

> V8 通过垃圾收集管理堆内存。简单地说，它会释放没有被引用的对象。例如，没有被栈直接或间接引用（通过另一个对象引用）的对象，它的内存空间都会被释放以用于新对象的创建。
> 
> V8 的垃圾收集器主要负责回收处理无用的内存，并提供给 V8 进程重复使用。V8 垃圾收集器是区分新老生代的（堆中的对象按它们的存放时间分组并会在不同的阶段被清理）。V8 的垃圾回收有两个阶段和三种算法。

![Mark-sweep-compact GC](https://d33wubrfki0l68.cloudfront.net/e3979bee7b7b51e6124594ea36dfde4eb7015da5/5c860/images/blog/2020-05/mark-sweep-compact.gif)

## 什么是内存泄漏

简单来说，内存泄漏就是堆上的一块孤立内存，这小块内存不再被程序使用并且也没有被垃圾收集器释放回操作系统，所以，这是一块没有被使用的内存。这样的内存块持续增加可能会导致应用没有足够内存空间去支撑其继续工作，也可能会导致你的操作系统没有足够的内存可供分配，进而导致系统缓慢或崩溃。

## 什么导致了内存泄漏

自动内存管理（如 V8 中的垃圾收集机制）目的在于避免内存泄漏，像循环引用不再是一个需要开发者关注的问题，然而内存泄漏依然可能发生，也许是因为预料之外的堆中的引用亦或是各种原因。一些常见的原因列举如下。

* **全局变量**：因为 JavaScript 中的全局变量被根节点（window 或 global `this`）引用，所以它们在整个应用生命周期中不会被收集，即会一直占用内存。这同样也适用于那些被全局变量（或其子属性）引用的对象，通过根节点引用数量庞大的对象可能导致内存泄漏。
* **多个引用**: 当同一个对象被多个对象引用时，当其中一个引用被挂起，可能会导致内存泄漏。
* **闭包**: JavaScript 闭包有一个很酷的特性，就是能够保存被它关联的上下文，当一个闭包持有一个引用，该引用指向堆中的一个庞大对象时，闭包会令该庞大对象持续在内存中直到闭包不再使用它。这意味着你可能会轻易地陷入这种情况，即持有着一个引用的闭包被不正确地使用从而导致内存泄漏。
* **定时器 & 事件**：使用 setTimeout、setInterval、Observers 和事件监听器时，如果没有妥当处理保存在它们回调函数中的庞大对象引用时，可能会导致内存泄漏。

## 避免内存泄漏的最佳实践

现在我们理解了什么会导致内存泄漏，马上看看如何避免它们，以及了解确保高效使用内存的最佳实践。

### 减少全局变量的使用

因为全局变量从不会被垃圾回收，所以最好不要过度使用它们，以下是一些方法：

**避免意外的全局变量**

当你赋值给一个未声明的变量时，在默认情况下 JavaScript 会自动提升它为全局变量。这可能是一种会导致内存泄漏的低级错误。另一种情况是赋值给 [`this`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/this)（在 JavaScript 中依然很神圣的东西）。

```js
// foo 会被提升为全局变量
function hello() {
    foo = "Message";
}

// foo 同样会成为全局变量，因为在非严格模式下，全局函数里的 \`this\` 指向全局上下文
function hello() {
    this.foo = "Message";
}
```

为了避免这些意外，总是在 JS 文件顶部使用 `'use strict';` 在严格模式下编写 JavaScript。在严格模式下，上述例子会报错。当你使用 ES modules 或转译器（如 TypeScript 或 Babel），你不需要声明严格模式因为这些工具已经自动开启。在最近的 NodeJS 版本，你可以在使用 `node` 命令时加上 `--use_strict` 参数开启全局严格模式。

```javascript
"use strict";

// foo 不会被提升到全局环境
function hello() {
    foo = "Message"; // 会抛运行时错误
}

// foo 不会成为全局变量，因为严格模式下，全局函数的 \`this\` 指向自身
function hello() {
    this.foo = "Message";
}
```

当你使用箭头函数，你同样需要小心不要意外的创建全局变量，不幸的是，严格模式对这种情况没有帮助，你可以使用来自 ESLint 的 `no-invalid-this` 规则来避免这种情况。如果你不使用 ESLint，确保不要在全局箭头函数里向 `this`赋值。

```js
// foo 会成为全局变量，因为箭头函数没有 `this`，它会沿着词法作用域向上寻找最近的 `this`
const hello = () => {
    this.foo = "Message";
}
```

最后，记住不要使用`bind` 或 `call` 方法绑定 `this` 到任何函数，因为这会违背使用严格模式的初衷。

**谨慎地使用全局作用域**

一般来说，尽可能地避免使用全局作用域和全局变量是一种好的实践。

1. 尽可能地不要使用全局作用域，相反，利用函数的局部作用域，因为它们会被垃圾回收并且内存会被释放。如果你基于某些原因非要使用全局变量，当你不再使用它时将它的值设为 `null`。
2. 只对常量、缓存和可复用的单例使用全局变量。不要因为传参麻烦而使用全局变量，对于在函数和类之间共享数据，可以通过参数或对象属性的方式传递。
3. 不要在全局作用域存放大对象。如果你必须存放它们，当你不再需要它们时，确保将它们赋值为 null。对于缓存对象，可以写一个工具函数周期地清理它们，避免它们无限制地增长。

### 高效利用栈内存

尽可能地使用栈变量，这有助于内存和性能的提升，因为访问栈远远比访问堆要快，同时这也确保了我们不会意外地制造内存泄漏。当然，单纯使用静态数据是不现实的。在现实世界的应用里，我们会不得不使用大量的对象和动态数据，但我们可以学习一些技巧来更好地利用栈。

1. 避免从栈变量引用堆对象，同时，切勿保留未使用的变量。
2. 使用解构从对象或数组中获取需要的字段，而不是将整个对象或数组传递给函数、闭包、定时器或事件处理函数。这避免了闭包保留一个对象的引用。获取的字段往往都是原始值，而原始值是存放在栈中的。

```js
function outer() {
    const obj = {
        foo: 1,
        bar: "hello",
    };

    const closure = () {
        const { foo } = obj;
        myFunc(foo);
    }
}

function myFunc(foo) {}
```

### 高效利用堆内存

在实际的应用中使用堆内存往往是无法避免的，但是我们可以遵循以下几点来更高效地利用堆内存：

1. 尽可能地拷贝对象而不是传递引用，只在对象较大且拷贝操作代价也大时才传递引用。
2. 尽可能避免对象操作，相反，使用对象扩展或 `Object.assign` 来复制它们。
3. 避免对同一个对象创建多个引用，相反，应拷贝一份这个对象。
4. 使用短暂存活的变量。
5. 避免创建嵌套过深的对象，如果无法避免，记得在当前作用域及时清理它们。

### 适当地使用闭包、定时器和事件处理函数

正如我们前面看到的，闭包、定时器和事件处理器是内存泄漏常发生的地方。让我们先从闭包开始，它是 JavaScript 中最常见的代码。看看以下来自 Meteor 团队的代码，因为 `longStr` 从未被回收并持续消耗内存，所以导致了内存泄漏，更多细节请阅读[这篇博客](https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156)。

```js
var theThing = null;
var replaceThing = function () {
    var originalThing = theThing;
    var unused = function () {
        if (originalThing) console.log("hi");
    };
    theThing = {
        longStr: new Array(1000000).join("*"),
        someMethod: function () {
            console.log(someMessage);
        },
    };
};
setInterval(replaceThing, 1000);
```

上面的代码创建了多个闭包，并且这些闭包持有对象引用。在这个情况下，可以通过在 `replaceThing` 函数末尾将 `originalThing` 的值设为 null 避免内存泄漏。这种情况同时也可以通过创建对象副本来避免，也可以参考前面提到的几种方法。

至于定时器，永远记住传递对象副本且避免对对象进行修改。同时，当定时器结束，记得使用 `clearTimeout` 和 `clearInterval` 方法。

对于事件监听器和观察者也一样，当任务完成就清理它们，不要让事件监听器一直运行，特别是当它们持有父级作用域的对象引用时。

## 总结

由于 JS 引擎的进化和对语言本身的优化，JavaScript 中的内存泄漏已不像以往那样是个大问题，但如果我们粗心大意，内存泄漏依然可能发生，并会导致性能问题甚至使得应用或操作系统崩溃。确保我们的代码不会发生内存泄漏的第一步是需要理解 V8 引擎是如何管理内存的。第二步是理解什么导致了内存泄漏。一旦我们理解了这两点，我们可以尽力避开导致内存泄漏的情景。当我们真的面对内存泄漏或性能问题时，我们会知道解决问题的方向在哪。至于 NodeJS，有些工具会有所帮助，例如，[Node-Memwatch](https://github.com/lloyd/node-memwatch) 和 [Node-Inspector](https://nodejs.org/en/docs/guides/debugging-getting-started/) 都是调试内存问题的优秀工具。

## 参考

* [Memory leak patterns in JavaScript](https://www.ibm.com/developerworks/web/library/wa-memleak/wa-memleak-pdf.pdf)
* [Memory Management](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management)
* [Cross-Browser Event Handling Using Plain ole JavaScript](https://docs.microsoft.com/en-us/previous-versions/msdn10/ff728624(v=msdn.10))
* [Four types of leaks in your JavaScript code and how to get rid of them](https://auth0.com/blog/four-types-of-leaks-in-your-javascript-code-and-how-to-get-rid-of-them/)
* [An interesting kind of JS memory leak](https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
