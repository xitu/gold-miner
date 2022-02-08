> * 原文地址：[A Beginner’s Guide to Memoization with JavaScript](https://blog.bitsrc.io/a-beginners-guide-to-memoization-with-javascript-59d9c818f4c8)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-beginners-guide-to-memoization-with-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-beginners-guide-to-memoization-with-javascript.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[regon-cao](https://github.com/regon-cao), [Ashira97](https://github.com/Ashira97), [PassionPenguin](https://github.com/PassionPenguin)

# JavaScript Memoization 入门指南

![Photo by [Tamanna Rumee](https://unsplash.com/@tamanna_rumee?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*ppVRXfrCk7iBldw8)

作为一名软件开发者，需要不断学习。永远存在需要学习的新事物，特别是 JavaScript 相关技术。当我们的应用程序变得复杂起来，运行速度就显得尤为重要了。当应用程序代码量不断增加，就需要进行性能优化。Memoization 是一种概念，它能帮助你构建高效的应用，即使在应用程序变得越来越庞大的情况下也是如此。Memoization 概念跟 JavaScript 中纯函数和函数式编程密切相关。

**务必记住，Memoization 只是一种概念，跟任何编程语言都无关。在本文中，我们从 JavaScript 的视角来讨论 Memoization。**

## 什么是 Memoization

从[定义](https://www.cs.cmu.edu/~rwh/introsml/techniques/memoization.htm)上来说，Memoization 是一种编程技术，它把某个函数复杂的运算结果保存起来，使得下一次以相同的输入调用这个函数时，不需要重复进行处理，直接快速返回已保存的结果。

如果把这个定义进一步分解，你应该注意到，有三个要点：

* **把结果缓存** — 缓存是一种临时保存数据的方式，它可以加快下次访问的速度。
* **复杂的运算** — 这里是指复杂的运算或处理过程。复杂是指该过程耗费的系统资源大或需要很长时间，这两者都是计算机世界中重要的衡量标准。
* **输入数据相同** — 这是一种直白的说法。但它确立了 Memoization 和纯函数之间的联系。从基本概念上来说，如果一个函数对于相同的输入数据总能得到相同的结果，这样的函数就称为纯函数。

把这个概念分解后，我们应该对 Memoization 有了基本的认识。如果你仍然不理解，不必担心，我会深入讲解，让你明白的。

## 何时以及为何需要对你的函数进行 Memoize？

#### 为什么？

我们先来了解为什么需要 Memoize。Memoization 能在很大程度上帮助你提升调用复杂函数时的性能。当某个函数接收输入，接着进行一些复杂的运算，返回输出结果，这个输出值可以被缓存。如果这个函数再次接收到相同的输入，就顺理成章地返回相同的输出值，而不是再次从头进行运算。

网上有不少关于使用 Memoization 进行性能优化的资料。你也可以通过查看本文结尾列出的那些资料去了解更多信息。

#### 何时？

只有纯函数才可以进行 Memoize。如果函数的输入数据相同，却可能产生不同的结果，对这样的函数进行 Memoize 是没有实际用途的。看一看下面的代码。 

虽然输入的数据相同，但每次调用函数输出的结果却不同。对这样的函数进行 Memoize 是没有实际意义的。

更进一步，在这些情况下，你可能需要对函数进行 Memoize：

* 函数是递归的，并且输入的数据是重复的。
* 调用函数耗费的时间或资源较多的情况。

## 重点

![Photo by [Matthew Cabret](https://unsplash.com/@majinmdub?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8320/0*m5L_0XBWVSlIUumn)

关于 Memoization，有三个要点你需要记住。必须满足这些先决条件，Memoization 才是有意义的。

* **纯函数** — 虽然已经提到过，但还是需要强调：欲对函数进行 Memoize，这个函数必须是纯函数。
* **高阶函数** — 这类函数返回另一个可以再次被调用的函数。
* **闭包** — 由于闭包和高阶函数的存在，函数内部的缓存可以记住它的值。

学习以下的例子，可以理解这些概念在实践中的应用。

## Memoization 的应用

关于 Memoization 的应用，常用的例子是阶乘的计算。我们来了解一下。

在上面的例子中，每次调用都要重新进行计算。第二次调用 `factorial(100)` 时，整个过程都会重复执行。如果我们在这里实施 Memoization，由于我们已经把 `factorial(100)` 的计算结果存在缓存里，就不需要再次计算了。

我们来研究一下这个使用 Memoization 的例子。

在这个例子中，你可以清楚地看到，无论何时都会取缓存的值。这使你能方便地跳过那些计算过程，因为在这之前结果已经计算出来，并被保存起来，而且耗费了大量资源。

如果你仔细观察调用过程，你会发现，由于不涉及计算过程，就很快得到了 `factorial(50)` 的值。这是因为 `factorial(50)` 已经计算完毕，并且缓存在 `factorial(60)` 的内存空间。

你可以在[这里](https://jsfiddle.net/2u7rofyp/1/)运行这个例子。

#### 关于上面的例子需要注意的东西

你可以清楚地看到，factorial 函数是一个**纯函数**，因为对于相同的输入，输出值永远是相同的。你也应当注意到，Memoize 函数是一个**高阶函数**，这是因为它返回的是一个将来需要调用、也会把函数用作输入参数的函数。更进一步，我们也可以看到，由于正在使用高阶函数，会创建一个闭包，它允许内部嵌套函数访问缓存对象。

现在，我们能理解如何使用三个要点对函数进行 Memoize。

## Caching 和 Memoization 的区别

你可能想知道 Caching 和 Memoization 的区别在哪里。实际上，Caching 是各种形式的缓存的总称，例如 HTTP 缓存、图片缓存等。但 Memoization 在大多数情况下是一种特定类型的缓存，**它缓存的是函数返回值**。

**你应当注意到，我已经提及了 Memoization 的要点。因此 Caching 只是 Memoization 的一部分，不是 Memoization 本身。**

## Memoization 相关的库

有这样一些库，你可以使用它们进行函数 Memoization，但是它们实现 Memoization 的方式各不相同。

* Moize
* Lodash
* Underscore
* Memoize Immutable and more.

你可以在[stack overflow 的问答版块](https://stackoverflow.com/a/61402805)看一看所有的库以及它们的特性。

## 需要对所有的函数进行 Memoization 吗？

**不是的**

虽然 Memoization 可以大大提高程序的性能，还是有一些你需要记住的事项。缓存**存储**了相关的值，这表明数据被存储了。如果函数的输入范围太大，你的缓存就会越来越大。通常 Memoization 函数的空间复杂度为O(n)。也可以使用一些算法来改进 Memoization 函数的空间复杂度。

你需要理解，必须平衡两种资源 —— 时间和空间，这很重要。虽然 Memoization 可以减少函数的时间复杂度，但另一方面，空间复杂度却增大了。

因此，我认为，当函数的输入值范围固定，并且确定这个函数会反复调用时，对函数进行 Memoization 是恰当的选择。

----

感谢您阅读本文。编码快乐！

**相关资源**

- [Article by Philip](https://scotch.io/tutorials/understanding-memoization-in-javascript)
- [Article by Codesmith](https://codeburst.io/understanding-memoization-in-3-minutes-2e58daf33a19)
- [Article by Divyanshu](https://www.freecodecamp.org/news/understanding-memoize-in-javascript-51d07d19430e/)
- [Lecture Notes — Carnegie Mellon University](https://www.cs.cmu.edu/~rwh/introsml/techniques/memoization.htm)
- [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
