> * 原文地址：[Why Learn Functional Programming in JavaScript? (Composing Software)(part 2)](https://medium.com/javascript-scene/why-learn-functional-programming-in-javascript-composing-software-ea13afc7a257)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[gy134340](https://github.com/gy134340)
> * 校对者：[sunui](https://github.com/sunui),[avocadowang](https://github.com/avocadowang)

# 为什么用 JavaScript 学习函数式编程？（软件编写）（第三部分）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

烟雾的方块艺术 —MattysFlicks —(CC BY 2.0)
> 注意：这是从基础学习函数式编程和使用 JavaScript ES6+ 撰写软件的第二部分。保持关注，接下来还有很多！
>  [第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md) | [第三篇 >](https://github.com/xitu/gold-miner/blob/master/TODO/a-functional-programmers-introduction-to-javascript-composing-software.md)

忘掉你认为知道的关于 JavaScript 的一切，用初学者的眼光去看待它。为了帮助你做到这一点，我们将会从头复习一下 JavaScript 的基础，就像你与其尚未谋面一样。如果你是初学者，那你就很幸运了。最终从零开始探索 ES6 和函数式编程！希望所有的概念都被解释清楚 — 但不要太依赖于此。

如果你是已经熟悉 JavaScript 或者纯函数式语言的老开发者了，也许你会认为 JavaScript 是探索函数式编程有趣的选择。把这些想法放在一边，用更开放的思想接触它，你会发现 JavaScript 编程更高层次的东西。一些你从来不知道的东西。

由于这个被称为“组合式软件”，同时函数式编程是明显的构建软件的方法（使用函数组合，高阶函数等等），你也许想知道为什么我不用 Haskell、ClojureScript,或者 Elm，而是 JavaScript。

JavaScript 有函数式编程所需要的最重要的特性：

1. **一级公民函数：** 使用函数作为数据值的能力：用函数传参，返回函数，用函数做变量和对象属性。这个属性允许更高级别的函数，使偏函数应用、柯里化和组合成为可能。
2. **匿名函数和简洁的 lambda 语法：** `x => x * 2` 是 JavaScript 中有效的函数表达式。简洁的 lambda 语法使得高阶函数变的简单。
3. **闭包：** 闭包是一个有着自己独立作用域的捆绑函数。闭包在函数被创建时被创建。当一个函数在另一个函数内部被创建，它可以访问外部函数的变量，即使在外部函数退出后。通过闭包偏函数应用可以获取内部固定参数。固定的参数时绑定在返回函数的作用域范围内的参数。在 `add2(1)(2)` 中，`1` 是 `add2(1)` 返回的函数中的固定参数。

### JavaScript 缺少了什么

JavaScript 是多范式语言，意味着它支持多种风格的编程。其他被 JavaScript 支持的风格包括过程式（命令式）编程（比如 C），把函数看作可以被重复调用和组织的子程序指令；面向对象编程，对象— 而不是函数— 作为初始构造块；当然，还有函数式编程。多范式编程语言的劣性在于命令式和面向对象往往意味着所有东西都是可变的。

可变性指的是数据结构上的变化。比如：
	
	const foo = {
	  bar: 'baz'
	};

	foo.bar = 'qux'; // 改变

对象通常需要可变性以便于被方法更新值，在命令式的语言中，大部分的数据结构可变以便于数组和对象的高效操作。

下面是一些函数式语言拥有但是 JavaScript 没有的特性：

1. **纯粹性：** 在一些函数式语言中，纯粹性是强制的，有副作用的表达式是不被允许的。
2. **不可变性：** 一些函数式语言不允许转变，采用表达式来产生新的数据结构来代替更改一个已存的数据结构，比如说数组或者对象。这样看起来可能不够高效，但是大多数函数式语言在引擎下使用 trie 数据结构，具有结构共享的特点：意味着旧的对象和新的对象是对相同数据的引用。
3. **递归：** 递归是函数引用自身来进行迭代的能力。在大多数函数式语言中，递归是迭代的唯一方式，它们没有像 `for` 、`while`、`do` 这类循环语句。

**纯粹性：** 在 JavaScript 中，纯粹性由约定来达成，如果你不是使用纯函数来构成你的大多数应用，那么你就不是在进行函数式风格的编程。很不幸，在 JavaScript 中，你很容易就会不小心创建和使用一些不纯的函数。

**不可变性：** 在纯函数式语言中，不可变性通常是强制的，JavaScript 缺少函数式语言中高效的、基于 trie 树的数据结构，但是你可以使用一些库，包括 [Immutable.js](https://facebook.github.io/immutable-js/) 和 [Mori](https://github.com/swannodette/mori)，由衷期望未来的 ECMAScript 规范版本可以拥抱不可变数据结构。

有一些迹象带来了希望，比如说在 ES6 中添加了 `const` 关键字，`const` 声明的变量不能被重新赋值，重要的是要理解 `const` 所声明的值并不是不可改变的。

`const` 声明的对象不能被重新声明为新的对象，但是对象的属性却是可变的，JavaScript 有 `freeze()` 对象的能力，但是这些对象只能在根实例上被冻结，意味着嵌套着的对象还是可以改变它的属性。换句话说，在 JavaScript 规范中看到真正的不可变还有很长的路要走。

**递归：** JavaScript 技术上支持递归，但是大多数函数式语言都有尾部调用优化的特性，尾部调用优化是一个允许递归的函数重用堆栈帧来递归调用的特性。

没有尾部调用优化，一个调用的栈很可能没有边界导致堆栈溢出。JavaScript 在 ES6 规范中有一个有限的尾调用优化。不幸的是，只有一个主要的浏览器引擎支持它，这个优化被部分应用随后从 Babel(最流行的 JavaScript 编译器，在旧的浏览器中被用来把 ES6 编译到 ES5) 中移除。

最重要的事实：现在使用递归来作为大的迭代还不是很安全 — 即使你很小心的调用尾部的函数。

### 什么又是 JavaScript 拥有但是纯函数式语言缺乏的

一个纯粹主义者会告诉你 JavaScript 的可变性是它的重大缺点，这是事实。但是，引起的副作用和改变有时候很有用。事实上，不可能在规避所有副作用的情况下开发有用的现代应用。纯函数式语言比如说 Haskell 使用副作用，使用 monads 包将有副作用的函数伪装成纯函数，从而使程序保持纯净，尽管用 Monads 所带来的副作用是不纯净的。

Monads 的问题是，尽管它的使用很简单，但是对一个不是很熟悉它的人解释清楚它有点像“对牛谈琴”。

> “Monad说白了不过就是自函子范畴上的一个幺半群而已，这有什么难以理解的?” ～James Iry 所引用 Philip Wadler 的话，解释一个 Saunders Mac Lane 说过的名言。[**“编程语言简要、不完整之黑历史”**](http://james-iry.blogspot.com/2009/05/brief-incomplete-and-mostly-wrong.html)

典型的，这是在调侃这有趣的一点。在上面的引用中，关于 Monads 的解释相比最初的有了很大的简化，原来是下面这样：

> “`X` 中的 monad 是其 endofunctor 范畴的幺半群，生成 endofunctor 和被 endofunctor 单位 set 组合所代替的 `X` ” ~ Saunders Mac Lane。 [*"Categories for the Working Mathematician"*](https://www.amazon.com/Categories-Working-Mathematician-Graduate-Mathematics/dp/0387984038//ref=as_li_ss_tl?ie=UTF8&amp;linkCode=ll1&amp;tag=eejs-20&amp;linkId=de6f23899da4b5892f562413173be4f0)

尽管这样，在我的观点看来，害怕 Monads 是没有必要的，学习 Monads 最好的方法不是去读关于它的一堆书和博客，而是立刻去使用它。对于大部分的函数式编程语言来说，晦涩的学术词汇比它实际概念难的多，相信我，你不必通过了解 Saunders Mac Lane 来了解函数式编程。

尽管它不是对所有的编程风格都绝对完美，JavaScript 无疑是作为适应各种编程风格和背景的人的通用编程语言被设计出来的。

根据 [Brendan Eric](https://brendaneich.com/2008/04/popularity/) 所言，在一开始的时候，网景公司就有意适应两类开发者：

> “...写组件的，比如说 C++ 或者 Java；写脚本的、业余的和爱好者，比如直接写嵌在 HTML 里的代码的。”

本来，网景公司的意向是支持两种不同的语言，同时脚本语言大致要像 Scheme (一个 Lisp 的方言)，而且，Brendan Eich：

> “我被招聘到网景公司，目的是在浏览器中 **做一些 Scheme**”。

JavaScript 应当是一门新的语言：

> “上级工程管理的命令是这门语言**应当像 Java**，这就排除了 Perl，Python，和 Tcl，以及 Scheme。”

所以，Brendan Eich 最初脑子里的想法是：

1. 浏览器中的 Scheme。
2. 看起来像 Java。

它最终更像是个大杂烩：

>“我不骄傲，但我很高兴我选择了 Scheme 的一类函数和 Self（尽管奇怪）的原型作为主要的元素。”由于 Java 的影响，特别是 y2k 的 Date 问题以及对象的区别（比如 string 和 String），就不幸了。”

我列出了这些 “不好的” 的类 Java 特性，最后整理成 JavaScript:

* 构造函数和 `new` 关键子，跟工厂函数有着不同的调用和使用语义。
* `class` 的关键字和单一父类 `extends` 作为最初的继承机制。
* 用户更习惯于把 `class` 看作是它的静态类型（实际并非如此）。

我的意见：永远避免使用这些东西。

很幸运 JavaScript 成为了这样厉害的语言，因为事实上证明脚本的方式赢了那些建立在“组件”上的方式（现在，Java、Flash、和 ActiveX 扩展已经不被大部分安装的浏览器支持）。

我们最终创作了一个直接被浏览器支持的语言：JavaScript。

那意味着浏览器可以减少臃肿和问题，因为它们现在只需要支持一种语言：JavaScript。你也许认为 WebAssembly 是例外，但是 WebAssembly 设计之初的目的是使用兼容的抽象语法树来共享 JavaScript 的语言绑定（AST）。事实上，最早的把 WebAssembly 编译成 JavaScript 的子集的示范是 ASM.js。

作为 web 平台唯一的通用标准编程语言，JavaScript 在软件历史潮流中乘风直上：

App 吞食世界， web 吞食 app， 同时 JavaScript 吞食 web。

根据[多个平台](http://redmonk.com/sogrady/2016/07/20/language-rankings-6-16/)[调查](http://stackoverflow.com/research/developer-survey-2016)，[JavaScript](https://octoverse.github.com/) 是目前世界上最流行的语言。

JavaScript 并不是函数式编程的理想化工具，但是它却是为大型的分布式的团队开发大型应用的好工具，因为不同的团队对于如何构建一个应用或许有不同的看法。

一些团队致力于脚本化，那么命令式的编程就特别有用，另外一些更精于抽象架构，那么一点保留的面向对象方法也许不失为坏。还有一些拥抱函数式编程，使用纯函数来确保稳定性、可测试性和项目状态管理以便减少用户的反馈。团队里的这些人可以使用相同的语言，意味着他们可以更好的交换想法，互相学习和在其他人的基础上更进一步的开发。

在 JavaScript 中，所有这些想法可以共存，这样就让更多的人开始拥抱 JavaScript，然后就产生了[世界上最大的开源包管理器](http://www.modulecounts.com/) (2017 年 2 月)，[npm](https://www.npmjs.com/)。

JavaScript 的真正优势在于其生态系统中的思想和用户的多样性。它也许不是纯函数式编程最理想的语言，但它是你可以想象的工作在不同平台的人共同合作的理想语言，比如说 Java、Lisp 或者 C。JavaScript 也许并不对有这些背景的用户完全友好，但是这些人很乐意学习这门语言并迅速投入生产。

我同意 JavaScript 并不是对函数式编程者最好的语言。但是，没有任何其他语言可以声称他们可以被所有人使用，同时正如 ES6 所述：JavaScript 可以满足到更与喜欢函数式编程的人的需要，同时也越来越好。相比于抛弃 JavaScript 和世界上几乎每家公司都使用的令人难以置信的生态系统，为什么不拥抱它，把它变成一个更适合软件组合化的语言？

现在，JavaScript 已经是一门**足够优秀**的函数式编程语言，意味着人们可以使用 JavaScript 的函数式编程方法来构造很多有趣的和有用的东西。Netflix（和其他使用 Angular 2+ 的应用）使用基于 RxJS 的函数式功能。[Facebook](https://github.com/facebook/react/wiki/sites-using-react)在 React 中使用纯函数、高阶函数和高级组件来开发 Facebook 和 Instagram，[PayPal、KhanAcademy、和Flipkart](https://github.com/reactjs/redux/issues/310)使用 Redux 来进行状态管理。

它们并不孤单：Angular、React、Redux 和 Lodash 是 JavaScript 生态系统中主要的框架和库，同时它们都被函数式编程很深的影响到— 在 Lodash 和 Redux 中，明确地表达是为了在实际的 JavaScript 应用中使用函数式编程模式。

“为什么是 JavaScript?”因为 JavaScript 是实际上大多数公司开发真实的软件所使用的语言。无论你对它是爱是恨，JavaScript 已经取代了 Lisp 这个数十年来 “最受欢迎的函数式编程语言”。事实上，Haskell 更适合当今函数式编程概念的标准，但是人们并不使用它来开发实际应用。

在任何时候，在美国都有近十万的 JavaScript 工作需求，世界其他地方也有数十万的量。学习 Haskell 可以帮助你很好的学习函数式编程，但学习 JavaScript 将会教会你在实际工作中开发应用。

App 正在吞食世界， web 正在吞食 app， 同时 JavaScript 正在吞食 web。

[**第三篇: 函数式开发者的 JavScript 介绍…**](https://github.com/xitu/gold-miner/blob/master/TODO/a-functional-programmers-introduction-to-javascript-composing-software.md)

### 下一步

想更多的学习 JavaScript 的函数式编程？

[Learn JavaScript with Eric Elliott](http://ericelliottjs.com/product/lifetime-access-pass/)，什么，你还不是其中之一，out 了！

[![](https://cdn-images-1.medium.com/freeze/max/30/1*3njisYUeHOdyLCGZ8czt_w.jpeg?q=20)![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/)


*Eric Elliott* 是 [*“Programming JavaScript Applications”*](http://pjabook.com) (O’Reilly) 和 “Learn JavaScript with Eric Elliott” 的作者。他曾效力于 *Adobe Systems, Zumba Fitness, he Wall Street Journal, ESPN, BBC, and top recording artists including Usher, Frank Ocean, Metallica* 和其他一些公司。

**他和她的老婆（很漂亮）大部分时间都在旧金山湾区里。**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
