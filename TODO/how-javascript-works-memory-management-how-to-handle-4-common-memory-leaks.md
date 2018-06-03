> * 原文地址：[How JavaScript works: memory management + how to handle 4 common memory leaks](https://blog.sessionstack.com/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks-3f28b94cfbec)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md)
> * 译者：[曹小帅](https://github.com/caoxiaoshuai1)
> * 校对者：[PCAaron](https://github.com/PCAaron) [Usey95](https://github.com/Usey95)

# JavaScript 是如何工作的：内存管理 + 处理常见的4种内存泄漏

几周前，我们开始了一系列旨在深入挖掘 JavaScript 及其工作原理的研究。我们的初衷是：通过了解 JavaScript 代码块的构建以及它们之间协调工作的原理，我们将能够编写更好的代码和应用程序。

本系列的第一篇文章着重于提供[引擎概览, 运行时, 以及堆栈调用](https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf)。第二篇文章仔细审查了 [Google 的 V8 JavaScript 引擎的内部区块](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code-ac089e62b12e)并且提供了一些关于怎样编写更好 JavaScript 代码的建议。

在第三篇文章中, 我们将讨论另外一个越来越被开发人员忽视的主题，原因是应用于日常基础内存管理的程序语言越来越成熟和复杂。我们也将会在 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-3-v8-intro) 提供一些关于如何处理 JavaScript 内存泄漏的建议，我们需要确认 SessionStack 不会导致内存泄漏，或者不会增加我们集成的 web 应用程序的消耗。

#### 概览

例如，像 C 这样的编程语言，有 `malloc()` 和 `free()` 这样的基础内存管理函数。开发人员可以使用这些函数来显式分配和释放操作系统的内存。

与此同时，JavaScrip 在对象被创建时分配内存，并在对象不再使用时“自动”释放内存，这个过程被称为垃圾回收。这种看似“自动”释放资源的特性是导致混乱的来源，它给了 JavaScript（和其他高级语言）开发者们一种错觉，他们可以选择不去关心内存管理。**这是一种错误的观念**

即使使用高级语言，开发者也应该对内存管理有一些理解（至少关于基本的内存管理）。有时，自动内存管理存在的问题（比如垃圾回收器的错误或内存限制等）要求开发者需要理解内存管理，才能处理的更合适（或找到代价最少的替代方案）。

#### 内存生命周期

无论你使用哪种程序语言，内存生命周期总是大致相同的：

![](https://cdn-images-1.medium.com/max/800/1*slxXgq_TO38TgtoKpWa_jQ.png)

以下是对循环中每一步具体情况的概述：

*  **内存分配** — 内存由操作系统分配，它允许你的应用程序使用。在基础语言中 (比如 C 语言)，这是一个开发人员应该处理的显式操作。然而在高级系统中，语言已经帮你完成了这些工作。
*  **内存使用** — 这是你的程序真正使用之前分配的内存的时候，**读写**操作在你使用代码中已分配的变量时发生。

*  **内存释放** — 释放你明确不需要的内存，让其再次空闲和可用。和**内存分配**一样，在基础语言中这是显式操作。
关于调用栈和内存堆的概念的快速概览，可以阅读我们的[关于主题的第一篇文章](https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf)。

#### 内存是什么?

在直接跳到有关 JavaScript 中的内存部分之前，我们将简要地讨论一下内存的概况以及它是如何工作的：

在硬件层面上，内存包含大量的[触发器](https://en.wikipedia.org/wiki/Flip-flop_%28electronics%29)。每一个触发器包含一些晶体管并能够存储一位。单独的触发器可通过**唯一标识符**寻址, 所以我们可以读取和覆盖它们。因此，从概念上讲，我们可以把整个计算机内存看作是我们可以读写的一个大的位组。

作为人类，我们并不擅长在位操作中实现我们所有的思路和算法，我们把它们组装成更大的组，它可以用来表示数字。8 位称为 1 个字节。除字节外，还有单词（有时是 16，有时是 32 位）。

很多东西存储在内存中:

1. 所有程序使用的所有变量和其他数据。
2. 程序的代码，包括操作系统的代码。

编译器和操作系统一起为您处理了大部分的内存管理，但是我们建议您看看底层发生了什么。

当你编译代码时，编译器可以检查原始数据类型，并提前计算它们需要多少内存。然后所需的数量被分配给**栈空间**中的程序。分配这些变量的空间称为栈空间，因为随着函数被调用，它们的内存被添加到现有的内存之上。当它们终止时，它们以 LIFO（后进先出）顺序被移除。 例如，请考虑以下声明：

```
int n; // 4 bytes
int x[4]; // array of 4 elements, each 4 bytes
double m; // 8 bytes
```

编译器可以立即计算到代码需要

4 + 4 × 4 + 8 = 28 bytes

> 这是它处理 integers 和 doubles 类型当前大小的方式。大约 20 年前，integers 通常是 2 个字节，doubles 通常是 4 个字节。您的代码不应该依赖于某一时刻基本数据类型的大小。

编译器将插入与操作系统交互的代码，为堆栈中的变量请求存储所需的字节数。

在上面的例子中，编译器知道每个变量的具体内存地址。 事实上，只要我们写入变量 `n`，它就会在内部被翻译成类似“内存地址 4127963”的内容。

注意，如果我们试图在这里访问 `x[4]`，我们将访问与 m 关联的数据。这是因为我们正在访问数组中不存在的一个元素 - 它比数组中最后一个实际分配的元素 `x[3]` 深了 4 个字节，并且最终可能会读取（或覆盖）一些 `m` 的位。这对项目的其余部分有预料之外的影响。

![](https://cdn-images-1.medium.com/max/800/1*5aBou4onl1B8xlgwoGTDOg.png)

当函数调用其他函数时，每个其他函数调用时都会产生自己的栈块。栈块保留了它所有的局部变量和一个记录了执行地点程序计数器。当函数调用完成时，其内存块可再次用于其他方面。

#### 动态分配

遗憾的是，当我们不知道编译时变量需要多少内存时，事情变得不再简单。假设我们想要做如下的事情：

```
int n = readInput(); // reads input from the user
...
// create an array with "n" elements
```

这里，在编译时，编译器不知道数组需要多少内存，因为它是由用户提供的值决定的。

因此，它不能为堆栈上的变量分配空间。相反，我们的程序需要在运行时明确地向操作系统请求正确的内存量。这个内存是从**堆空间**分配的。下表总结了静态和动态内存分配之间的区别：

![](https://cdn-images-1.medium.com/max/800/1*qY-yRQWGI-DLS3zRHYHm9A.png)

静态和动态内存分配的区别

为了充分理解动态内存分配是如何工作的，我们需要在**指针**上花费更多的时间，这可能与本文的主题略有偏差。如果您有兴趣了解更多信息，请在评论中告诉我们，我们可以在以后的文章中详细介绍指针。

#### JavaScript 中的内存分配

现在我们将解释第一步（**分配内存**）是如何在JavaScript中工作的。

JavaScript 减轻了开发人员处理内存分配的责任 - JavaScript自己执行了内存分配，同时声明了值。

```
var n = 374; // allocates memory for a number
var s = 'sessionstack'; // allocates memory for a string 
var o = {
  a: 1,
  b: null
}; // allocates memory for an object and its contained values
var a = [1, null, 'str'];  // (like object) allocates memory for the
                           // array and its contained values
function f(a) {
  return a + 3;
} // allocates a function (which is a callable object)
// function expressions also allocate an object
someElement.addEventListener('click', function() {
  someElement.style.backgroundColor = 'blue';
}, false);
```

一些函数调用也会导致对象分配：

```
var d = new Date(); // allocates a Date object

var e = document.createElement('div'); // allocates a DOM element
```

方法可以分配新的值或对象：

```
var s1 = 'sessionstack';
var s2 = s1.substr(0, 3); // s2 is a new string
// Since strings are immutable, 
// JavaScript may decide to not allocate memory, 
// but just store the [0, 3] range.
var a1 = ['str1', 'str2'];
var a2 = ['str3', 'str4'];
var a3 = a1.concat(a2); 
// new array with 4 elements being
// the concatenation of a1 and a2 elements
```

#### 在 JavaScript 中使用内存

基本上在 JavaScript 中使用分配的内存，意味着在其中读写。

这可以通过读取或写入变量或对象属性的值，甚至传递一个变量给函数来完成。

#### 在内存不再需要时释放内存

绝大部分内存管理问题都处于这个阶段。

这里最困难的任务是确定何时不再需要这些分配了的内存。它通常需要开发人员确定程序中的哪个部分不再需要这些内存，并将其释放。

高级语言嵌入了一个称为**垃圾回收器**的软件，其工作是跟踪内存分配和使用情况，以便找到何时何种情况下不再需要这些分配了的内存，它将自动释放内存。

不幸的是，这个过程是一个近似值，因为预估是否需要某些内存的问题通常是[不可判定的](http://en.wikipedia.org/wiki/Decidability_%28logic%29)（无法通过算法解决）。

大多数垃圾回收器通过收集不能再访问的内存来工作，例如，所有指向它的变量都超出了作用域。然而，这是可以收集的一组内存空间的近似值，因为在某种情况下内存位置可能仍然有一个指向它的变量，但它将不会被再次访问。

#### 垃圾回收机制

由于发现一些内存是否“不再需要”事实上是不可判定的，所以垃圾收集在实施一般问题解决方案时具有局限性。本节将解释主要垃圾收集算法及其局限性的基本概念。

#### 内存引用

垃圾收集算法所依赖的主要概念来源于**附录参考资料**。

在内存管理的上下文中，如果一个对象可以访问另一个对象（可以是隐式的或显式的），则称该对象引用另一个对象。例如, 一个 JavaScript 引用了它的 [prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Inheritance_and_the_prototype_chain) (**隐式引用**)和它的属性值(**显式引用**)。

在这种情况下，“对象”的概念扩展到比普通JavaScript对象更广泛的范围，并包含函数作用域（或全局**词法范围**）。

> 词法作用域定义了变量名如何在嵌套函数中解析：即使父函数已经返回，内部函数仍包含父函数的作用域。

#### 引用计数垃圾收集

这是最简单的垃圾收集算法。 如果有**零个指向它**的引用，则该对象被认为是“可垃圾回收的”。

请看下面的代码:

```
var o1 = {
  o2: {
    x: 1
  }
};
// 2 objects are created. 
// 'o2' is referenced by 'o1' object as one of its properties.
// None can be garbage-collected

var o3 = o1; // the 'o3' variable is the second thing that 
            // has a reference to the object pointed by 'o1'. 
                                                       
o1 = 1;      // now, the object that was originally in 'o1' has a         
            // single reference, embodied by the 'o3' variable

var o4 = o3.o2; // reference to 'o2' property of the object.
                // This object has now 2 references: one as
                // a property. 
                // The other as the 'o4' variable

o3 = '374'; // The object that was originally in 'o1' has now zero
            // references to it. 
            // It can be garbage-collected.
            // However, what was its 'o2' property is still
            // referenced by the 'o4' variable, so it cannot be
            // freed.

o4 = null; // what was the 'o2' property of the object originally in
           // 'o1' has zero references to it. 
           // It can be garbage collected.
```

#### 周期产生问题

在周期循环中有一个限制。在下面的例子中，两个对象被创建并相互引用，这就创建了一个循环。在函数调用之后，它们会超出界限，所以它们实际上是无用的，并且可以被释放。然而，引用计数算法认为，由于两个对象中的每一个都被至少引用了一次，所以两者都不能被垃圾收集。

```
function f() {
  var o1 = {};
  var o2 = {};
  o1.p = o2; // o1 references o2
  o2.p = o1; // o2 references o1. This creates a cycle.
}

f();
```

![](https://cdn-images-1.medium.com/max/800/1*GF3p99CQPZkX3UkgyVKSHw.png)

#### 标记和扫描算法

为了确定是否需要某个对象，本算法判断该对象是否可访问。

标记和扫描算法经过这 3 个步骤：

1.根节点：一般来说，根是代码中引用的全局变量。例如，在 JavaScript 中，可以充当根节点的全局变量是“window”对象。Node.js 中的全局对象被称为“global”。完整的根节点列表由垃圾收集器构建。
2.然后算法检查所有根节点和他们的子节点并且把他们标记为活跃的（意思是他们不是垃圾）。任何根节点不能访问的变量将被标记为垃圾。
3.最后，垃圾收集器释放所有未被标记为活跃的内存块，并将这些内存返回给操作系统。

![](https://cdn-images-1.medium.com/max/800/1*WVtok3BV0NgU95mpxk9CNg.gif)

标记和扫描算法行为的可视化。

因为“一个对象有零引用”导致该对象不可达，所以这个算法比前一个算法更好。我们在周期中看到的情形恰巧相反，是不正确的。

截至 2012 年，所有现代浏览器都内置了标记扫描式的垃圾回收器。去年在 JavaScript 垃圾收集（通用/增量/并发/并行垃圾收集）领域中所做的所有改进都是基于这种算法（标记和扫描）的实现改进，但这不是对垃圾收集算法本身的改进，也不是对判断一个对象是否可达这个目标的改进。

[在本文中](https://en.wikipedia.org/wiki/Tracing_garbage_collection), 您可以阅读有关垃圾回收跟踪的更详细的信息，文章也包括标记和扫描算法以及其优化。

#### 周期不再是问题

在上面的第一个例子中，函数调用返回后，两个对象不再被全局对象中的某个变量引用。因此，垃圾收集器会认为它们不可访问。

![](https://cdn-images-1.medium.com/max/800/1*FbbOG9mcqWZtNajjDO6SaA.png)

即使两个对象之间有引用，从根节点它们也不再可达。

#### 统计垃圾收集器的直观行为

尽管垃圾收集器很方便，但他们也有自己的一套权衡策略。其中之一是不确定性。换句话说，GCs（垃圾收集器）们是不可预测的。你不能确定一个垃圾收集器何时会执行收集。这意味着在某些情况下，程序其实需要使用更多的内存。其他情况下，在特别敏感的应用程序中，短暂暂停可能是显而易见的。尽管不确定性意味着不能确定一个垃圾收集器何时执行收集，大多数 GC 共享分配中的垃圾收集通用模式。如果没有执行分配，大多数 GC 保持空闲状态。考虑如下场景：

1. 大量的分配被执行。
2. 大多数这些元素（或全部）被标记为不可访问（假设我们废除一个指向我们不再需要的缓存的引用）。
3. 没有执行更深的内存分配。

在这种情况下，大多数 GC 不会运行任何更深层次的收集。换句话说，即使存在不可用的引用可用于收集，收集器也不会声明这些引用。这些并不是严格的泄漏，但仍会导致高于日常的内存使用率。

#### 什么是内存泄漏?

就像内存描述的那样，内存泄漏是应用程序过去使用但不再需要的尚未返回到操作系统或可用内存池的内存片段。

![](https://cdn-images-1.medium.com/max/800/1*0B-dAUOH7NrcCDP6GhKHQw.jpeg)

编程语言偏好不同的内存管理方式。但是，某段内存是否被使用实际上是一个[不可判定问题](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management#Release_when_the_memory_is_not_needed_anymore)。换句话说，只有开发人员可以明确某块内存是否可以返回给操作系统。

某些编程语言提供了帮助开发人员执行上述操作的功能。其他人则希望开发人员能够完全明确某段内存何时处于未使用状态。维基百科在如何[手工](https://en.wikipedia.org/wiki/Manual_memory_management)和[自动](https://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29)内存管理方面有很好的文章。

#### JavaScript 常见的四种内存泄漏

#### 1：全局变量

JavaScript 用一种有趣的方式处理未声明的变量：当引用一个未声明的变量时，在 _global_ 对象中创建一个新变量。在浏览器中，全局对象将是 `window`，这意味着

```
function foo(arg) {
    bar = "some text";
}
```

等同于:

```
function foo(arg) {
    window.bar = "some text";
}
```

我们假设 `bar` 的目的只是引用 foo 函数中的一个变量。然而，如果你不使用 `var` 来声明它，就会创建一个冗余的全局变量。在上面的情况中，这不会造成很严重的后果。你可以想象一个更具破坏性的场景。

你也可以用 `this` 意外地创建一个全局变量：

```
function foo() {
    this.var1 = "potential accidental global";
}
// Foo called on its own, this points to the global object (window)
// rather than being undefined.
foo();
```

> 你可以通过在 JavaScript 文件的开头添加 `'use strict';` 来避免这些后果，这将开启一种更严格的 JavaScript 解析模式，从而防止意外创建全局变量。

意外的全局变量当然是个问题，然而更常出现的情况是，你的代码会受到显式的全局变量的影响，而这些全局变量无法通过垃圾收集器收集。需要特别注意用于临时存储和处理大量信息的全局变量。如果你必须使用全局变量来存储数据，当你这样做的时候，要保证一旦完成使用就把他们**赋值为 null 或重新赋值** 。

#### 2：被忘记的定时器或者回调函数

我们以经常在 JavaScript 中使用的 `setInterval` 为例。

提供观察者和其他接受回调的工具库通常确保所有对回调的引用在其实例无法访问时也变得无法访问。然而，下面的代码并不鲜见：

```
var serverData = loadData();
setInterval(function() {
    var renderer = document.getElementById('renderer');
    if(renderer) {
        renderer.innerHTML = JSON.stringify(serverData);
    }
}, 5000); //This will be executed every ~5 seconds.
```

上面的代码片段显示了使用定时器引用节点或无用数据的后果。

`renderer` 对象可能会在某些时候被替换或删除，这会使得间隔处理程序封装的块变得冗余。如果发生这种情况，处理程序及其依赖项都不会被收集，因为间隔处理需要先备停止（请记住，它仍然是活动的）。这一切都归结为一个事实，即事实存储和处理负载数据的 `serverData` 也不会被收集。

当使用观察者时，你需要确保一旦依赖于它们的事务已经处理完成，你编写了明确的调用来删除它们（不再需要观察者，或者对象将变得不可用时）。

幸运的是，大多数现代浏览器都会为你做这件事：即使你忘记删除监听器，当观察对象变得无法访问时，它们也会自动收集观察者处理程序。过去一些浏览器无法处理这些情况（旧的 IE6）。

但是，尽管如此，一旦对象变得过时，移除观察者才是符合最佳实践的。看下面的例子：

```
var element = document.getElementById('launch-button');
var counter = 0;
function onClick(event) {
   counter++;
   element.innerHtml = 'text ' + counter;
}
element.addEventListener('click', onClick);
// Do stuff
element.removeEventListener('click', onClick);
element.parentNode.removeChild(element);
// Now when element goes out of scope,
// both element and onClick will be collected even in old browsers // that don't handle cycles well.
```

现在的浏览器支持检测这些循环并适当地处理它们的垃圾收集器，因此在制造一个无法访问的节点之前，你不再需要调用 `removeEventListener`。

如果您利用 `jQuery` API（其他库和框架也支持这个），您也可以在节点废弃之前删除监听器。即使应用程序在较旧的浏览器版本下运行，这些库也会确保没有内存泄漏。

3：闭包

JavaScript开发的一个关键方面是闭包：一个内部函数可以访问外部（封闭）函数的变量。由于JavaScript运行时的实现细节，可能以如下方式泄漏内存：

```
var theThing = null;
var replaceThing = function () {
  var originalThing = theThing;
  var unused = function () {
    if (originalThing) // a reference to 'originalThing'
      console.log("hi");
  };
  theThing = {
    longStr: new Array(1000000).join('*'),
    someMethod: function () {
      console.log("message");
    }
  };
};
setInterval(replaceThing, 1000);
```

一旦调用了 `replaceThing` 函数，`theThing` 就得到一个新的对象，它由一个大数组和一个新的闭包（`someMethod`）组成。然而 `originalThing` 被一个由 `unused` 变量（这是从前一次调用 `replaceThing` 变量的 `Thing` 变量）所持有的闭包所引用。需要记住的是**一旦为同一个父作用域内的闭包创建作用域，作用域将被共享。**

在个例子中，`someMethod` 创建的作用域与 `unused` 共享。`unused` 包含一个关于 `originalThing` 的引用。即使 `unused` 从未被引用过，`someMethod` 也可以通过 `replaceThing` 作用域之外的 `theThing` 来使用它（例如全局的某个地方）。由于 `someMethod` 与 `unused` 共享闭包范围，`unused` 指向 `originalThing` 的引用强制它保持活动状态（两个闭包之间的整个共享范围）。这阻止了它们的垃圾收集。

在上面的例子中，为闭包 `someMethod` 创建的作用域与 `unused` 共享，而 `unused` 又引用 `originalThing`。`someMethod` 可以通过 `replaceThing` 范围之外的 `theThing` 来引用，尽管 `unused` 从来没有被引用过。事实上，unused 对 `originalThing` 的引用要求它保持活跃，因为 `someMethod` 与 unused 的共享封闭范围。

所有这些都可能导致大量的内存泄漏。当上面的代码片段一遍又一遍地运行时，您可以预期到内存使用率的上升。当垃圾收集器运行时，其大小不会缩小。一个闭包链被创建（在例子中它的根就是 `theThing` 变量），并且每个闭包作用域都包含对大数组的间接引用。

Meteor 团队发现了这个问题，[它们有一篇很棒的文章](https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156)详细地描述了这个问题。

#### 4：超出 DOM 的引用

有些情况下开发人员在数据结构中存储 DOM 节点。假设你想快速更新表格中几行的内容。如果在字典或数组中存储对每个 DOM 行的引用，就会产生两个对同一个 DOM 元素的引用：一个在 DOM 树中，另一个在字典中。如果你决定删除这些行，你需要记住让两个引用都无法访问。

```
var elements = {
    button: document.getElementById('button'),
    image: document.getElementById('image')
};
function doStuff() {
    elements.image.src = 'http://example.com/image_name.png';
}
function removeImage() {
    // The image is a direct child of the body element.
    document.body.removeChild(document.getElementById('image'));
    // At this point, we still have a reference to #button in the
    //global elements object. In other words, the button element is
    //still in memory and cannot be collected by the GC.
}
```

在涉及 DOM 树内的内部节点或叶节点时，还有一个额外的因素需要考虑。如果你在代码中保留对表格单元格（`td` 标记）的引用，并决定从 DOM 中删除该表格但保留对该特定单元格的引用，则可以预见到严重的内存泄漏。你可能会认为垃圾收集器会释放除了那个单元格之外的所有东西。但情况并非如此。由于单元格是表格的子节点，并且子节点保持对父节点的引用，所以**对表格单元格的这种单引用会把整个表格保存在内存中**。

我们在 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-3-v8-outro) 尝试遵循这些最佳实践，编写正确处理内存分配的代码，原因如下：

一旦将 SessionStack 集成到你的生产环境的 Web 应用程序中，它就会开始记录所有的事情：所有的 DOM 更改，用户交互，JavaScript 异常，堆栈跟踪，失败网络请求，调试消息等。

通过 SessionStack，你可以像视频一样回放 web 应用程序中的问题，并查看所有的用户行为。所有这些都必须在您的网络应用程序没有性能影响的情况下进行。

由于用户可以重新加载页面或导航你的应用程序，所有的观察者，拦截器，变量分配等都必须正确处理，这样它们才不会导致任何内存泄漏，也不会增加我们正在整合的Web应用程序的内存消耗。

这里有一个免费的计划所以你可以[试试看](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-3-v8-getStarted).

![](https://cdn-images-1.medium.com/max/800/1*kEQmoMuNBDfZKNSBh0tvRA.png)

#### Resources

* [http://www-bcf.usc.edu/~dkempe/CS104/08-29.pdf](http://www-bcf.usc.edu/~dkempe/CS104/08-29.pdf)
* [https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156](https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156)
* [http://www.nodesimplified.com/2017/08/javascript-memory-management-and.html](http://www.nodesimplified.com/2017/08/javascript-memory-management-and.html)
* [https://auth0.com/blog/four-types-of-leaks-in-your-javascript-code-and-how-to-get-rid-of-them/](https://auth0.com/blog/four-types-of-leaks-in-your-javascript-code-and-how-to-get-rid-of-them/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
