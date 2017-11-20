> * 原文地址：[How JavaScript works: memory management + how to handle 4 common memory leaks](https://blog.sessionstack.com/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks-3f28b94cfbec)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md)
> * 译者：曹小帅
> * 校对者：

# JavaScript工作原理: 内存管理 + 处理常见的4种内存泄漏

几周前，我们开始了一系列旨在深入挖掘JavaScript及其工作原理的研究。我们的结论是：通过了解构建JavaScript代码块以及它们组合在一起的方式，我们将能够编写更好的代码和应用程序。

本系列的第一篇文章着重于提供 [引擎概览, 运行时间, 以及堆栈调用](https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf).  [第二篇文章仔细审查了Google的V8 JavaScript引擎的内部区块](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code-ac089e62b12e) 并且提供了一些关于怎样编写更好JavaScript代码的提示。

在第三篇文章中, 我们将讨论另外一个越来越被开发人员忽视的主题，原因是应用于日常基础内存管理的程序语言越来越成熟和复杂。我们也将会在[SessionStack网](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-3-v8-intro) 提供一些关于如何处理JavaScript内存泄漏的提示，我们需要确认SessionStack不会导致内存泄漏，或者不会增加我们集成的web应用程序的消耗。

#### 概览

关于语言，像C语言，内置基础层次的内存管理原生函数比如`malloc()`和`free()`。开发人员使用这些原生函数从操作系统、往操作系统显式分配和释放内存。

与此同时，JavaScrip在对象被创建时分配内存，并在对象不被使用时“自动”释放内存，这个过程被称为垃圾回收。这种看似“自动”释放资源的特性是导致混乱的来源，它给了JavaScript（和其他高级语言）开发者们一种错觉，他们可以选择不去关心内存管理。**这是一种错误的观念**

即使使用高级语言，开发者也应该对内存管理有一些理解（至少关于基本的内存管理）。有时，自动内存管理存在的问题（比如垃圾回收器的错误或内存限制等）需要开发者需要理解内存管理，才能处理的更合适（或找到适合的处理方法，具有最少的权衡工作和开发量）。

#### 内存生命周期
无论你使用哪种程序语言，内存生命周期总是大致相同的：

![](https://cdn-images-1.medium.com/max/800/1*slxXgq_TO38TgtoKpWa_jQ.png)

以下是对循环中每一步具体情况的概述：

*   **内存分配** — 内存由操作系统分配，它允许你的应用程序使用。在基础语言中 (比如C语言)，这是一个开发人员应该处理的显示操作。然而在高级系统中，语言已经帮你完成了这些工作。
*   **内存使用** — 这是你的程序真正使用之前分配内存的时候，**读写**操作在你使用代码中分配的变量时发生。

*   **内存释放** — 现在是释放全部你不需要的内存的时候，这样对于基础语言中明确的**内存分配**操作来说，内存变得再一次空闲和可用。

关于调用栈和内存堆的概念的快速概览，可以阅读我们的[关于主题的第一篇文章](https://blog.sessionstack.com/how-does-javascript-actually-work-part-1-b0bacc073cf).

#### 内存是什么?

在直接跳到有关JavaScript中的内存部分之前，我们将简要地讨论一下内存的概况以及它是如何工作的：

在硬件层面上，内存包含大量的[触发器](https://en.wikipedia.org/wiki/Flip-flop_%28electronics%29)。 每一个触发器包含一些晶体管并能够存储一位。 单独的触发器可通过**唯一标识符**寻址, 所以我们可以读取和覆盖它们。 因此，从概念上讲，我们可以把整个计算机内存看作是我们可以读写的一个大的位组。

作为人类，我们并不擅长在位操作中实现我们所有的思路和算法，我们把它们组装成更大的组，它可以用来表示数字。8位称为1个字节。除字节外，还有单词（有时是16，有时是32位）。

很多东西存储在内存中:

1.  所有程序使用的所有变量和其他数据。
2.  程序的代码，包括操作系统的代码。

编译器和操作系统一起为您处理了大部分的内存管理，但是我们建议您看看底层发生了什么。

当你编译代码时，编译器可以检查原始数据类型，并提前计算它们需要多少内存。然后所需的数量被分配给**堆栈空间**中的程序。分配这些变量的空间称为堆栈空间，因为随着函数被调用，它们的内存被添加到现有的内存之上。当它们终止时，它们以LIFO（后进先出）顺序被移除。 例如，请考虑以下声明：

```
int n; // 4 bytes
int x[4]; // array of 4 elements, each 4 bytes
double m; // 8 bytes
```

编译器可以立即计算到代码需要
4 + 4 × 4 + 8 = 28 bytes.
> 这是它处理integers和doubles类型当前大小的方式。 大约20年前，integers通常是2个字节，double通常是4个字节。 您的代码不应该依赖于某一时刻基本数据类型的大小。

编译器将插入与操作系统交互的代码，为堆栈中的变量请求存储所需的字节数。

在上面的例子中，编译器知道每个变量的具体内存地址。 事实上，只要我们写入变量`n`，它就会在内部被翻译成类似“内存地址4127963”的内容。

注意，如果我们试图在这里访问`x[4]`，我们将访问与m关联的数据。 这是因为我们正在访问数组中不存在的一个元素 - 它比数组中最后一个实际分配的元素`x [3]`深了4个字节，并且最终可能会读取（或覆盖）一些`m`的位。这对项目的其余部分有预料之外的影响。

![](https://cdn-images-1.medium.com/max/800/1*5aBou4onl1B8xlgwoGTDOg.png)

当函数调用其他函数时，每个其他函数调用时都会产生自己的堆栈块。堆栈块保留了它所有的局部变量和一个记录了执行地点程序计数器。当函数调用完成时，其内存块可再次用于其他方面。

#### 动态分配

遗憾的是，当我们不知道编译时变量需要多少内存时，事情变得不再简单。 假设我们想要做如下的事情：

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

#### JavaScript中的内存分配

现在我们将解释第一步（**分配内存**）是如何在JavaScript中工作的。

JavaScript减轻了开发人员处理内存分配的责任 - JavaScript自己执行了内存分配，同时声明了值。

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

#### 在JavaScript中使用内存

基础的使用JavaScript分配的内存，意味着在其中进行读写。

这可以通过读取或写入变量或对象属性的值，甚至传递一个变量给函数来完成。

#### 在内存不再需要时释放内存

绝大部分内存管理问题都处于这个阶段。

这里最困难的任务是确定何时不再需要分配的内存。它通常需要开发人员确定程序中的哪个部分不再需要这些内存，并将其释放。

高级语言嵌入了一个称为**垃圾回收器**的软件，其工作是跟踪内存分配和使用情况，以便找到何时何种情况下不再需要分配的内存，它将自动释放内存。

不幸的是，这个过程是一个近似值，因为预估是否需要某些内存的问题通常是[不可判定的](http://en.wikipedia.org/wiki/Decidability_%28logic%29)（无法通过算法解决）。

大多数垃圾收集器通过收集不能再访问的内存来工作，例如，所有指向它的变量都超出了作用域。然而，这是可以收集的一组内存空间的近似值，因为在某种情况下内存位置可能仍然有一个指向它的变量，但它将不会被再次访问。

#### 垃圾收集

由于发现一些内存是否“不再需要”事实上是不可判定的，所以垃圾收集在实施一般问题解决方案时具有局限性。本节将解释主要垃圾收集算法及其局限性的基本概念。

#### 内存引用

垃圾收集算法所依赖的主要概念来源于**附录参考资料**其中一个。

在内存管理的情况下，如果一个对象可以访问另一个对象（可以是隐含的或显式的），则称该对象引用另一个对象。例如, 一个JavaScript引用了它的[prototype](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Inheritance_and_the_prototype_chain) (**隐式引用**)和它的属性值(**显式引用**).

在这种情况下，“对象”的概念扩展到比普通JavaScript对象更广泛的范围，并包含函数范围（或全局**词法范围**）。

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

在周期循环中有一个限制。在下面的例子中，两个对象被创建并相互引用，这就创建了一个循环。在函数调用之后，它们会超出界限，所以它们实际上是无用的，并且可以被释放。 然而，引用计数算法认为，由于两个对象中的每一个都被至少引用了一次，所以两者都不能被垃圾收集。

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

标记和扫描算法经过这3个步骤：

1.根节点：一般来说，根是代码中引用的全局变量。例如，在JavaScript中，可以充当根节点的全局变量是“window”对象。 Node.js中的全局对象被称为“global”。完整的根节点列表由垃圾收集器构建。
2.然后算法检查所有根节点和他们的孩子并且把他们标记为活跃的（意思是他们不是垃圾）。任何根节点不能访问的变量将被标记为垃圾。
3.最后，垃圾收集器释放所有未被标记为活跃的内存块，并将这些内存返回给操作系统。

![](https://cdn-images-1.medium.com/max/800/1*WVtok3BV0NgU95mpxk9CNg.gif)

标记和扫描算法行为的可视化。

因为“一个对象有零引用”导致该对象不可达，所以这个算法比前一个算法更好。我们在周期中看到的情形恰巧相反，是不正确的。

截至2012年，所有现代浏览器都内置了标记扫描式的垃圾回收器。 去年在JavaScript垃圾收集（通用/增量/并发/并行垃圾收集）领域中所做的所有改进都是基于这种算法（标记和扫描）的实现改进，但这不是对垃圾收集算法本身的改进，也不是对判断一个对象是否可达这个目标的改进。

[在本文中](https://en.wikipedia.org/wiki/Tracing_garbage_collection), 您可以阅读有关垃圾回收跟踪的更详细的信息，文章也包括标记和扫描算法以及其优化。

#### 周期不再是问题

在上面的第一个例子中，函数调用返回后，两个对象不再被全局对象中的某个变量引用。 因此，垃圾收集器会认为它们不可到达。

![](https://cdn-images-1.medium.com/max/800/1*FbbOG9mcqWZtNajjDO6SaA.png)

即使两个对象之间有引用，从根节点它们也不再可达。

#### 统计垃圾收集器的直观行为

尽管垃圾收集器很方便，但他们也有自己的一套权衡策略。 其中之一是不确定性。换句话说，GCs（垃圾收集器）们是不可预测的。你不能确定一个垃圾收集器何时会执行收集。 这意味着在某些情况下，程序其实需要使用更多的内存。其他情况下，在特别敏感的应用程序中，短暂暂停可能是显而易见的。尽管不确定性意味着不能确定一个垃圾收集器何时执行收集，大多数GC共享分配中的垃圾收集通用模式。 如果没有执行分配，大多数GC保持空闲状态。 考虑如下场景：

1. 大量的分配被执行。
2. 大多数这些元素（或全部）被标记为不可到达（假设我们废除一个指向我们不再需要的缓存的引用）。
3. 没有执行更深的内存分配。

在这种情况下，大多数GC不会运行任何更深层次的收集。换句话说，即使存在不可用的引用可用于收集，收集器也不会声明这些引用。这些并不是严格的泄漏，但仍会导致高于日常的内存使用率。

#### 什么是内存泄漏?

就像内存描述的那样，内存泄漏是应用程序过去使用但不再需要的尚未返回到操作系统或可用内存池的内存片段。

![](https://cdn-images-1.medium.com/max/800/1*0B-dAUOH7NrcCDP6GhKHQw.jpeg)

编程语言偏好不同的内存管理方式。但是，某段内存是否被使用实际上是一个[不可判定问题](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management#Release_when_the_memory_is_not_needed_anymore)。 换句话说，只有开发人员可以明确某块内存是否可以返回给操作系统。

某些编程语言提供了帮助开发人员执行上述操作的功能。 其他人则希望开发人员能够完全明确某段内存何时处于未使用状态。 维基百科在如何[手工](https://en.wikipedia.org/wiki/Manual_memory_management) 和 [自动](https://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29)内存管理方面有很好的文章。

#### JavaScript 常见的四种内存泄漏

#### 1: Global variables

JavaScript用一种有趣的方式处理未声明的变量：当引用一个未声明的变量时，在_global_对象中创建一个新变量。在浏览器中，全局对象将是`window`，这意味着

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

我们假设`bar`的目的只是引用foo函数中的一个变量。然而，如果你不使用`var`来声明它，就会创建一个冗余的全局变量。 在上面的情况中，这不会造成很严重的后果。 你可以想象一个更具破坏性的场景。

你也可以用`this`意外地创建一个全局变量：

```
function foo() {
    this.var1 = "potential accidental global";
}
// Foo called on its own, this points to the global object (window)
// rather than being undefined.
foo();
```

> 你可以通过在JavaScript文件的开头添加`'use strict';`来避免这些后果，这将开启一种更严格的JavaScript解析模式，从而防止意外创建全局变量。

意外的全局变量当然是个问题，然而更常出现的情况是，你的代码会受到显式的全局变量的影响，而这些全局变量无法通过垃圾收集器收集。 需要特别注意用于临时存储和处理大量信息的全局变量。 如果你必须使用全局变量来存储数据，当你这样做的时候，要保证一旦完成使用就把他们**赋值为null或重新赋值** 。

#### 2: 忘记定时器或者回调

Let’s take `setInterval` for example as it’s often used in JavaScript.

Libraries which provide observers and other instruments that accept callbacks usually make sure all references to the callbacks become unreachable once their instances are unreachable too. Still, the code below is not a rare find:

```
var serverData = loadData();
setInterval(function() {
    var renderer = document.getElementById('renderer');
    if(renderer) {
        renderer.innerHTML = JSON.stringify(serverData);
    }
}, 5000); //This will be executed every ~5 seconds.
```

The snippet above shows the consequences of using timers that reference nodes or data that’s no longer needed.

The `renderer` object may be replaced or removed at some point which would make the block encapsulated by the interval handler redundant. If this happens, neither the handler, nor its dependencies would be collected as the interval would need to be stopped first (remember, it’s still active). It all boils down to the fact that `serverData` which surely stores and processes loads of data will not be collected either.

When using observers, you need to make sure you make an explicit call to remove them once you are done with them (either the observer is not needed anymore, or the object will become unreachable).

Luckily, most modern browsers would do the job for you: they’ll automatically collect the the observer handlers once the observed object becomes unreachable even if you forgot to remove the listener. In the past some browsers were unable to handle these cases (good old IE6).

Still, though, it’s in line with best practices to remove the observers once the object becomes obsolete. See the following example:

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

You no longer need to call `removeEventListener` before making a node unreachable as modern browsers support garbage collectors that can detect these cycles and handle them appropriately.

If you leverage the `jQuery` APIs (other libraries and frameworks support this too) you can also have the listeners removed before a node is made obsolete. The library would also make sure there are no memory leaks even when the application is running under older browser versions.

3: Closures

A key aspect of JavaScript development are closures: an inner function that has access to the outer (enclosing) function’s variables. Due to the implementation details of the JavaScript runtime, it is possible to leak memory in the following way:

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

Once `replaceThing` is called, `theThing` gets a new object which consists of a big array and a new closure (`someMethod`). Yet, `originalThing` is referenced by a closure that’s held by the `unused` variable (which is `theThing` variable from the previous call to `replaceThing`). The thing to remember is that **once a scope for closures is created for closures in the same parent scope, the scope is shared.**

In this case, the scope created for the closure `someMethod` is shared with `unused`. `unused` has a reference to `originalThing`. Even though `unused` is never used, `someMethod` can be used through `theThing` outside of the scope of `replaceThing` (e.g. somewhere globally). And as `someMethod` shares the closure scope with `unused`, the reference `unused` has to `originalThing` forces it to stay active (the whole shared scope between the two closures). This prevents its collection.

In the above example, the scope created for the closure `someMethod` is shared with `unused`, while `unused` references `originalThing`. `someMethod` can be used through `theThing` outside of the `replaceThing` scope, despite the fact that `unused` is never used. The fact that unused references `originalThing` requires that it remains active since `someMethod` shares the closure scope with unused.

All this can result in a considerable memory leak. You can expect to see a spike in memory usage when the above snippet is run over and over again. Its size won’t shrink when the garbage collector runs. A linked list of closures is created (its root is `theThing` variable in this case), and each the closure scopes carries forward an indirect reference to the big array.

This issue was found by the Meteor team and [they have a great article](https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156) that describes the issue in great detail.

#### 4: Out of DOM references

There are cases in which developers store DOM nodes inside data structures. Suppose you want to rapidly update the contents of several rows in a table. If you store a reference to each DOM row in a dictionary or an array, there will be two references to the same DOM element: one in the DOM tree and another in the dictionary. If you decide to get rid of these rows, you need to remember to make both references unreachable.

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

There’s an additional consideration that has to be taken into account when it comes to references to inner or leaf nodes inside a DOM tree. If you keep a reference to a table cell (a `<td>` tag) in your code and decide to remove the table from the DOM yet keep the reference to that particular cell, you can expect a major memory leak to follow. You might think that the garbage collector would free up everything but that cell. This will not be the case, however. Since the cell is a child node of the table and children keep references to their parents, **this single reference to the table cell would keep the whole table in memory**.

We at [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-3-v8-outro) try to follow these best practices in writing code that handles memory allocation properly, and here’s why:

Once you integrate SessionStack into your production web app, it starts recording everything: all DOM changes, user interactions, JavaScript exceptions, stack traces, failed network requests, debug messages, etc.
With SessionStack, you replay issues in your web apps as videos and see everything that happened to your user. And all of this has to take place with no performance impact for your web app.
Since the user can reload the page or navigate your app, all observers, interceptors, variable allocations, etc. have to be handled properly, so they don’t cause any memory leaks or don’t increase the memory consumption of the web app in which we are integrated.

There is a free plan so you can [give it a try now](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=Post-3-v8-getStarted).

![](https://cdn-images-1.medium.com/max/800/1*kEQmoMuNBDfZKNSBh0tvRA.png)

#### Resources

* [http://www-bcf.usc.edu/~dkempe/CS104/08-29.pdf](http://www-bcf.usc.edu/~dkempe/CS104/08-29.pdf)
* [https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156](https://blog.meteor.com/an-interesting-kind-of-javascript-memory-leak-8b47d2e7f156)
* [http://www.nodesimplified.com/2017/08/javascript-memory-management-and.html](http://www.nodesimplified.com/2017/08/javascript-memory-management-and.html)
* [https://auth0.com/blog/four-types-of-leaks-in-your-javascript-code-and-how-to-get-rid-of-them/](https://auth0.com/blog/four-types-of-leaks-in-your-javascript-code-and-how-to-get-rid-of-them/)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
