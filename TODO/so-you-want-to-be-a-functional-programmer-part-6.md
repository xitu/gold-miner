> * 原文地址：[So You Want to be a Functional Programmer (Part 6)](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-6-db502830403#.2bgj637a5)
* 原文作者：[Charles Scalfani](https://medium.com/@cscalfani)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[DeadLion](https://github.com/DeadLion)
* 校对者：[cyseria](https://github.com/cyseria), [luoyaqifei](https://github.com/luoyaqifei)

# 准备充分了嘛就想学函数式编程？(Part 6)


第一步，理解函数式编程概念是最重要的一步，同时也是最难的一步。如果你从正确的角度或方法来理解的话，它也未必会有那么难。

回顾之前的部分: [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-1.md), [Part 2](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-2.md), [Part 3](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-3.md), [Part 4](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-4.md), [Part 5](https://github.com/xitu/gold-miner/blob/master/TODO/so-you-want-to-be-a-functional-programmer-part-5.md)

#### 现在该做什么?









![](https://cdn-images-1.medium.com/max/1600/1*yVZA0aT5t6crvBPAMn46Kg.png)





现在你已经学会了所有这些新东西了，你可能在想，“现在该干什么？我如何在日常编程中使用它？”

这得看情况。如果你会使用纯函数式语言（如 Elm 或 Haskell）编程，那么你可以尝试所有这些想法。这些语言能够很容易实现这些想法。

如果你只会使用 Javascript 这样的命令式语言编程（我们中大多数人肯定都是），那么你仍然可以使用很多你学到的知识，但是还需要更多的训练。


#### Javascript 函数式









![](https://cdn-images-1.medium.com/max/1600/1*w_gG-CXQX4TV3B5bN24nqg.png)





Javascript 有许多特性能让你以近乎函数式的方式编程。它不是纯粹的函数式，但你可以从语言中得到不变性，甚至更多的库。

它不是最佳的，但如果你必须使用的时候，那为什么不利用一些函数式语言的优点呢？

**不变性**

首先要考虑的是不变性。 在 ES2015，或者也叫 ES6，因为它有一个被称为 **常量** 的新关键字。这意味着一旦设置了变量，则无法修改该变量：

    const a = 1;
    a = 2; // this will throw a TypeError in Chrome, Firefox or Node
           // but not in Safari (circa 10/2016)

这里的 **_a_** 被定义为常量，意味着一旦赋值无法再改变。 这就是为什么 **_a = 2_** 会抛出异常 (除了 Safari)。

Javascript **常量** 有个问题就是不变性不够深入。以下示例说明了其限制：

    const a = {
        x: 1,
        y: 2
    };
    a.x = 2; // NO EXCEPTION!
    a = {}; // this will throw a TypeError

注意 **_a.x = 2_** 并没有抛出异常。 **_const_** 关键字的不变性只对变量 **_a_** 生效。 **_a_** 所指向的任何变量都可以改变。

这是非常令人失望的，因为它本可以让 Javascript 更好。

那么我们如何从 Javascript 中获得不变性呢?

很不幸，我们只能通过一个库 [Immutable.js](https://facebook.github.io/immutable-js/) 来实现。
这可能给我们更好的不变性，但可悲的是，它实现的方式使我们的代码看起来更像 Java。

**柯里化和组合**

在本系列之前的文章，我们学习了如何编写柯里化的功能。这是一个更复杂的例子：

    const f = a => b => c => d => a + b + c + d

请注意，我们不得不手工编写柯里化部分。

调用 **_f,_** 我们必须写成:

    console.log(f(1)(2)(3)(4)); // prints 10

但是这么多的括号，足以让 Lisp 程序员哭泣了！（译者注：Lisp 语句中会使用很多括号）

有许多库能够简化这一过程。 我最喜欢的一个是 [Ramda](http://ramdajs.com/).

使用 Ramda 我们可以这样写:

    const f = R.curry((a, b, c, d) => a + b + c + d);
    console.log(f(1, 2, 3, 4)); // 打印 10
    console.log(f(1, 2)(3, 4)); // 也打印 10
    console.log(f(1)(2)(3, 4)); // 也打印 10

函数定义并没有什么改进，但我们已经消除了对所有括号的需求。请注意，我们可以应用与我们每次调用 **_f_** 时一样多的参数。


通过 Ramda, 我们可以重写 [Part 3](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-3-1b0fd14eb1a7)和 [Part 4](https://medium.com/@cscalfani/so-you-want-to-be-a-functional-programmer-part-4-18fbe3ea9e49) **_mult5AfterAdd10_** 功能:

    const add = R.curry((x, y) => x + y);
    const mult5 = value => value * 5;
    const mult5AfterAdd10 = R.compose(mult5, add(10));

事实证明，Ramda 有很多帮助函数来做这些事情，例如。**_R.add_** 和 **_R.multiply_**，这意味着我们可以少写代码：

    const mult5AfterAdd10 = R.compose(R.multiply(5), R.add(10));

**Map, Filter 和 Reduce**

Ramda 也有它自己的 **_map_**, **_filter_** 和 **_reduce_**。 尽管这些功能在普通 Javascript **_Array.prototype_** 中已经存在， Ramda 的版本功能更加丰富:

    const isOdd = R.flip(R.modulo)(2);
    const onlyOdd = R.filter(isOdd);
    const isEven = R.complement(isOdd);
    const onlyEven = R.filter(isEven);

    const numbers = [1, 2, 3, 4, 5, 6, 7, 8];
    console.log(onlyEven(numbers)); // prints [2, 4, 6, 8]
    console.log(onlyOdd(numbers)); // prints [1, 3, 5, 7]

**_R.modulo_** 用了两个参数. 第一个是 **_dividend_** (被除数) ，第二个参数是 **_divisor_** (除数)。

 **_isOdd_** 函数只是除以 2 的余数。余数为 0 是 **_falsy_**, 不是奇数，余数为 1 则是 **_truthy_**，奇数。
我们翻转 **_modulo_** 的第一和第二参数，使得我们可以指定 2 作为除数。

 **_isEven_** 功能只是 **_isOdd_** 的 **_complement（补集）_**。

 **_onlyOdd_** 函数是通过 **_isOdd_** 来 **断言（只返回布尔类型的方法）** 的 **过滤器** 。它在等待 numbers 数组，即它在执行前需要的的最后一个参数。

The **_onlyEven_** 是一个使用 **_isEven_** 来断言的 **过滤器** 。

当我们将 **_numbers_** 传给 **_onlyEven_** 、**_onlyOdd_** 、**_isEven_** 和 **_isOdd_** 方法，获取它们最终的参数，最后执行然后返回我们期望的结果。

#### Javascript 缺点








![](https://cdn-images-1.medium.com/max/1600/1*GjSzT5C7dKD0GPgSZVFGIw.png)





Javascript 已经有很多的库，语言也得到增强，它仍然需要面对残酷的现实，它是一种命令式语言，对大家来说似乎能够做任何事情。

大多数前端人员在浏览器中一直使用着 Javascript ，因为一直以来只有这一种选择。但现在许多开发人员逐渐不再直接编写 Javascript。

取而代之，他们用不同的语言编写和编译，或者更准确的说，是用其他语言转换成 Javascript。

CoffeeScript 就是这些语言中的第一种。如今，Angular 2 中采用了 Typescript。Babel 也是一种 Javascript 转换编译器。

越来越多的人正在采用这种方法用于生产环境。

但是这些语言还是基于 Javascript ，而且只是稍微改进了一点点。为什么不从一个纯函数式语言转换到 Javascript？

#### Elm









![](https://cdn-images-1.medium.com/max/1600/1*oVJSlb6bJfNCXYacQmcvew.png)




在这个系列里，我们了解了 Elm 来帮助理解函数式编程。

**但是什么才是 Elm？我又该怎么用它呢？**

Elm 是一种纯函数式编程语言，最终编译成 Javascript ，所以你可以用它来创建 Web 应用，使用 [The Elm Architecture](https://guide.elm-lang.org/architecture/)，又叫 TEA（这个架构激励了 Redux 的开发者）。


Elm 程序没有任何运行时错误。

像 [NoRedInk](https://www.noredink.com/) 这样的公司已经在生产环境中使用了 Elm，Elm 的创造者 Evan Czapliki 现在工作的公司(他之前在 [Prezi](https://prezi.com/) 公司工作)。

看看这个访谈，[6 个月应用 Elm 在生产环境](https://www.youtube.com/watch?v=R2FtMbb-nLs), 由来自 NoRedInk 的 Richard Feldman 和 Elm 的布道者讲解。

**我需要用 Elm 替换我所有的 Javascript 吗?**

不，你可以逐渐替换。 完整的看看这篇文章 [How to use Elm at Work](http://elm-lang.org/blog/how-to-use-elm-at-work)，来学习更多知识。

**为什么学习 Elm?**

1.  函数式编程是限制和自由并存的。它限制了你可以做什么（大部分是保证你不会“误伤”自己)，但是同时也让你远离 bug 和错误的设计决策，因为所有的 Elm 程序遵循 Elm Architecture，一个函数式响应编程模型。
2.  函数式编程能让你成为一个更好的程序员。本文中的想法只是冰山一角。 你真的需要在实践中看到，它们是如何让你的程序缩小尺寸，增加稳定性。
3.  Javascript 最初是在 10 天内构建的，然后在过去的二十年中修补，以成为一种有点功能，有点面向对象和完全命令式的编程语言。
    Elm 的设计吸取了 Haskell 社区过去 30 年工作中的知识，以及数十年的数学和计算机科学经验。
    Elm 架构（TEA）是经过多年设计和完善的，是 Evan 在功能响应式性编程中论文的结果。看看 [Controlling Time and Space（控制时间和空间）](https://www.youtube.com/watch?v=Agu6jipKfYw)，以了解这个设计的构思。
4.  Elm 专为前端 Web 开发人员而设计。 它的目的是使他们的工作更容易。 观看 [Let’s Be Mainstream（让我们成为主流）](https://www.youtube.com/watch?v=oYk8CKH7OhE)，更好地了解这一目标。

#### 未来









![](https://cdn-images-1.medium.com/max/1600/1*0FpreasFPaa5rYns6Mpe6w.png)





不可能知道将来会怎样，但我们可以做一些猜测。下面是一些我的：

> 将会出现一个明确的语言，编译为 Javascript。

> 已经存在了 40 多年的函数式编程思想将被重新发现，以解决当前的软件复杂性问题。

> 硬件的状态，例如千兆字节的便宜内存和快速处理器，将使函数式技术成为可行。

> CPU 不会变得更快，但内核的数量将继续增加。

> 可变状态将成为复杂系统中的最大问题之一。

我写这系列文章，因为我相信未来是函数式编程的未来，在过去的几年中，我在努力学习它(我还在学习)。

我的目标就是帮助别人比我更容易和更快的去学习这些概念，帮助别人成为更好的程序员，以便他们将来能有更好的就业前景。

即使我的预测，Elm 在未来将是一门伟大的语言是错误的，我可以肯定地说，函数式编程和 Elm 也会在未来的画卷上留下浓墨重彩的一笔。

我希望在阅读完本系列以后，你会对你的能力和这些概念的理解感到更加自信。

在今后的工作中，祝你好运。


如果你想加入一个 web 开发者社区学习以及相互帮助使用 Elm 函数式编程开发 web 应用的话，来加入我的 Facebook Group， **_Learn Elm Programming_**[https://www.facebook.com/groups/learnelm/](https://www.facebook.com/groups/learnelm/)
