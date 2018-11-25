> * 原文地址：[Abstraction & Composition](https://medium.com/javascript-scene/abstraction-composition-cb2849d5bdd6)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/abstraction-composition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/abstraction-composition.md)
> * 译者：Xekin-FE(https://github.com/Xekin-FE)
> * 校对者：[weibinzhu](https://github.com/weibinzhu) [Junkai Liu](https://github.com/Moonliujk)

# 函数式编程：抽象与组合

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> 备注：本篇本章是“组合式软件编程”中的一部分，从基础开始学习 JavaScript ES6+ 的函数式编程和组合软件技术。更多的内容请保持关注我们。
> [< 上一章节](https://github.com/xitu/gold-miner/blob/master/TODO/nested-ternaries-are-great.md) | [<< 返回第一章节](https://github.com/xitu/gold-miner/blob/master/TODO1/composing-software-an-introduction.md) | [下一章节 >](https://github.com/xitu/gold-miner/blob/master/TODO1/the-forgotten-history-of-oop.md)

随着我在程序开发中愈加成熟，我愈加重视底层的原理 —— 这是在我还是个初学者时所被我所忽视的，但现在随着开发经验越来越丰富，这些基础的原理也具有了深厚的意义。

> “在空手道中，黑带的骄傲象征是从黑带穿到褪色而变为白带，这象征着回到了最初的状态” ~ John Maeda，[“简化的法则：设计，技术，商业，生活”](https://www.amazon.com/Laws-Simplicity-Design-Technology-Business/dp/0262134721/ref=as_li_ss_tl?ie=UTF8&qid=1516330765&sr=8-1&keywords=the+laws+of+simplicity&linkCode=ll1&tag=eejs-20&linkId=287b1d3357fa799ce7563584e098c5d8)

在 Google 词典中写着，抽象是“独立于事物的关联、属性或具体附属物来考虑事物的过程”。

抽象的词源来自中世纪拉丁语 **abstractus**，意为“拽开、抽离”。我喜欢这样的解读。抽象意味着移除某些东西 —— 但到底我们移除掉了什么，又为了什么目的呢？

有时我喜欢将词汇翻译成其他语言然后再把它们翻译回英文，站在不同的角度去思考我们在英语中没有想到过的其他联想。当我把“抽象”一词翻译为意第绪语再翻译回英语时，结果意思是“心不在焉的”，我也喜欢这样的答案。一个心不在焉的人在使用自动驾驶仪的时候，不会去主动思考驾驶仪在做什么……只是这样做。

抽象让我们得以安全的使用自动驾驶仪。所有软件都是自动化的。如果你有足够的时间，你在电脑上做的任何事情也都可以用纸，墨水，再加上信鸽来做。软件就只是把这些手动做起来十分耗时的所有细节自动化处理了。

所有软件都是抽象的，在我们获利的同时，也将所有的辛勤工作以及那些无意识的细节埋藏。

软件的运行过程大多都是不停的重复着。如果在问题分解阶段，我们决定一遍又一遍地重复实现相同的功能，将会造成大量不必要的工作。至少这样做肯定是愚蠢的。在许多情况下，这都是不切实际的。

相反，我们可以通过编写一些对应的组件（像是函数、模块、类等等），再给个名称作为标识，然后我们就可以在需要使用它们的地方再去复用它们。

分解的过程就是抽象的过程。成功的抽象也就意味着结果是一组可以单独使用并且也可以重新组合的组件。由此我们了解了一个非常重要的软件架构原则：

软件解决方案应该可以被分解为其组件部分，并且可以重新组合成为新的解决方案，而无需更改内部的组件实现细节。

### 抽象是一种简化的行为

> “简化就是将显而易见的东西减去并增添有意义的东西” ~ John Maeda，[“简化的法则：设计，技术，商业，生活”](https://www.amazon.com/Laws-Simplicity-Design-Technology-Business/dp/0262134721/ref=as_li_ss_tl?ie=UTF8&qid=1516330765&sr=8-1&keywords=the+laws+of+simplicity&linkCode=ll1&tag=eejs-20&linkId=287b1d3357fa799ce7563584e098c5d8)

抽象过程主要有两个组成部分：

*   **泛化**是在重复模式中找到相似的（并显而易见的）功能并通过抽象来将它们隐藏的一个过程。
*   **特殊化**是在使用抽象时，为那些**只在某处不同**（且有其特殊意义的）提供用例。

抽象是一个提取概念本质的过程。通过发现不同领域中不同问题的共同点，我们可以认识到如果跨出自己的视界从不同的角度去看待问题。当我们看到问题的本质时，我们就可以找出一个好的解决方案同时它也可以适用于许多其他问题。如果我们将这样的思想应用在代码上，我们就可以从根本上降低应用程序的复杂性。

> “如果你愿意触碰事物的深层基础，你将触碰到它的一切。” ~ Thich Nhat Hanh

此原则可用于从根本上减少构建应用程序所需的代码。

### 软件中的抽象

软件中的抽象有很多种形式

*   算法
*   数据解构
*   模块
*   类
*   框架

而我个人最喜欢的是：

> “有时，优雅的实现仅仅是一个函数。而不是一种方法。也不是类。也不是框架。只是一个函数而已。” ~ John Carmack (Id Software, Oculus VR)

函数具有很好的抽象性，因为它们本身具有良好抽象所具备的特性：

*   **标识性** — 为其分配名称并在不同的上下文当中重复使用。
*   **可组合性** — 可以让简单的功能组合成更复杂的功能。

### 组合抽象

在软件中最常用于抽象的函数莫过于**纯函数**，它与数学中的函数有着相同的模块化特征。在数学中，一个函数对于相同的输入值，永远会得到相同的输出。我们可以将函数视为输入和输出之间的关系。给定一些输入 `A`，一个函数 `f` 将会产生 `B` 作为输出。你可以说是 `f` 定义了 `A` 和 `B` 之间的关系：

```
f: A -> B
```

同样的，我们可以定义另一个函数，`g`，它则定义了 `B` 和 `C` 之间的关系：

```
g: B -> C
```

这**意味着**另一个函数 `h` 就直接定义了 `A` 和 `C` 之间的联系：

```
h: A -> C
```

这些关系构成了问题空间的结构，也由此你在应用程序中组合函数的方式也就构成了应用程序的结构。

将这些结构隐藏起来，一个良好的抽象就诞生了，同样的方式我们使用 `h` 这个方法就可以将 `A -> B -> C` 这个过程缩减为 `A -> C`。

![](https://cdn-images-1.medium.com/max/800/1*uFTKDgI0kT878E97K14V1A.png)

### 如何用更少的代码做更多的事情

抽象是用更少代码做更多事的关键。举个例子，假如你写一个函数用来计算两个数字相加：

```
const add = (a, b) => a + b;
```

但是你经常将它用于递增，因此固定其中一个数字是合理的：

```
const a = add(1, 1);
const b = add(a, 1);
const c = add(b, 1);
// ...
```

我们可以柯里化这个方法

```
const add = a => b => a + b;
```

然后创建一个偏函数应用，在函数调用时传入第一个参数，就会返回一个接受下一个参数的新函数：

```
const inc = add(1);
```

现在，当我们需要增加 `1` 时，我们可以使用 `inc` 而不是之前的 `add` 方法，这就减少了我们所需的代码量：

```
const a = inc(1);
const b = inc(a);
const c = inc(b);
// ...
```

在这个例子里，inc 只是用来完成相加运算的一个**特定**版本。所有柯里化函数都是抽象出来的。而在实际上，所有高阶函数都可以概括为通过传递一个或者多个参数来得到特定的结果。

比如 `Array.prototype.map()` 就是一个高阶函数，它抽象出一个方案，用来将函数应用于数组当中的每个元素以返回处理后所得到的元素构成的新数组。我们可以将 `map` 写成一个柯里化函数来让这个过程更加的明显：

```
const map = f => arr => arr.map(f);
```

这版代码中的 map 是接受一个特定函数作为参数，然后返回另一个特定的方法，即以给定函数为方法，处理数组中每个元素：

```
const f = n => n * 2;

const doubleAll = map(f);
const doubled = doubleAll([1, 2, 3]);
// => [2, 4, 6]
```

注意这里我们定义 `doubleAll` 仅仅只需要这一小段代码 `map(f)` —— 就这么简单！这就是它的整个定义。如果我们在开始构建我们的代码块时就抽象那些常用的功能，我们就可以用很少的新代码来组合成相当复杂的行为。

### 结论

软件开发人员花费它们的整个职业生涯来创建抽象和组合抽象 —— 但仍有许多人对抽象或者组合它们没有一个良好的基本掌握。

每当你创建抽象时，你都应该仔细地去考虑它，而且你也应该要意识到有很多已经为你提供地良好抽象（例如常用的 `map`，`filter`，和 `reduce`）。我们应该要学会识别抽象的特征：

*   Simple（简单）
*   Concise（明了）
*   Reusable（可重用的）
*   Independent（独立的）
*   Decomposable（可分解的）
*   Recomposable（可重新组合的）

### 在 EricElliottJS.com 了解更多信息

更多关于函数式编程的视频课程可供 EricElliottJS.com 的会员使用。如果您还不是会员，请[立即注册](https://ericelliottjs.com/)。

[![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/)

* * *

Eric Elliott 是 “Programming JavaScript Applications”（O'Reilly）的作者，也是软件导师平台 DevAnywhere.io 的联合创始人。他为 Adobe Systems，Zumba Fitness，华尔街日报，ESPN，BBC 以及包括 Usher，Frank Oc 等在内的顶级录音艺术家的软件体验做出了贡献。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
