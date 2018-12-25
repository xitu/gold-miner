> * 原文地址：[The Rise and Fall and Rise of Functional Programming (Composing Software)(part 1)](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[gy134340](https://github.com/gy134340)
> * 校对者：[avocadowang](https://github.com/avocadowang),[Aladdin-ADD](https://github.com/Aladdin-ADD)

# 跌宕起伏的函数式编程（软件编写）（第二部分）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

烟雾的方块艺术 —MattysFlicks —(CC BY 2.0)

> 注意：这是从基础学习函数式编程和使用 JavaScript ES6+ 编写软件的第一部分。保持关注，接下来还有很多！
>
> [<< 从第一篇开始](https://github.com/xitu/gold-miner/blob/master/TODO1/composing-software-an-introduction.md) | [下一篇 >](https://github.com/xitu/gold-miner/blob/master/TODO/why-learn-functional-programming-in-javascript-composing-software.md)

当我 6 岁时，我花了很多时间跟我的小伙伴玩电脑游戏，他家有一个装满电脑的房间。对于我说，它们有不可抗拒的魔力。我花了很多时间探索所有的游戏。一天我问他，“我们怎样做一个游戏？”

他不知道，所以我们问了他的老爸，他的老爸爬上一个很高的架子拿下来一本使用 Basic 编写游戏的书籍。就那样开始了我的编程之路。当公立学校开始教授代数时，我已经熟稔其中的概念了，因为编程基本上是代数。无论如何，它都是。

### 组合型软件的兴起

在计算机科学的起步阶段，在大多数的计算机科学在电脑上完成之前，有两位伟大的计算机科学家：阿隆佐·邱奇和艾伦·图灵。他们发明了两种不同、但是普遍通用的计算模型。两种都可以计算所有可被计算的东西（因此，“普遍”）。

阿隆佐·邱奇发明了 lambda 表达式。lambda 表达式是基于函数应用的通用计算模型。艾伦·图灵因为图灵机而知名。图灵机使用定义一个在磁带上操作符号的理论装置来计算的通用模型。

总的说，他们共同说明了 lambda 表达式和图灵机功能上是相等的。

lambda 表达式全是函数组成，依靠函数来编写软件是非常高效和有意义的。本文中，我们将会讨论软件设计中函数的组合的重要性。

有三点造就了 lambda 表达式的特别之处：

1. 函数都是匿名的，在 JavaScript 中，表达式 `const sum = (x, y) => x + y` 的右侧，可以看作一个匿名函数表达式 `(x, y) => x + y`。
2. lambda 表达式中的函数只接收一个参数。他们是一元的，如果你需要多个参数，函数将会接受一个输入返回一个调用下一个函数的函数，然后继续这样。非一元函数 `(x, y) => x + y` 可以被表示为一个像 `x => y => x + y` 的一元函数。这个把多元函数转换成一元函数的过程叫做柯里化。
3. 函数是一等公民的，意味着函数可以作为参数传递给其他函数，同时函数可以返回函数。

总的说来，这些特性形成一个简单且具有表达性的方法来构造软件，即使用函数作为初始模块。在 JavaScript 中，函数的匿名和柯里化都是可选的特性。虽然 JavaScript 支持这些 lambda 表达式的重要属性，它却并不强制使用这些。

这些经典的函数组合方法用一个函数的输出来作为另一个函数的输入，例如，对于组合：

	f . g
	
也可以写做：

	compose2 = f => g => x => f(g(x))
	
这里是你使用它的方法：
	
	double = n => n * 2
	inc = n => n + 1
	
	compose2(double)(inc)(3)

`compose2()` 函数使用 `double` 函数作为第一个参数，使用 `inc` 函数作为第二个参数，同时对于两个函数的组合传入参数 `3`。再看一下 `compose2()` 函数所写的，`f` 是 `double()`，`g` 是 `inc()`，同时 `x` 是 `3`。函数 `compose2(double)(inc)(3)` 的调用，实际上是三个不同函数的调用：

1. 首先传入 `double` 同时返回一个新的函数。
2. 返回的函数传入 `inc` 同时再返回一个新的函数。
3. 再返回的函数传入 `3` 同时计算 `f(g(x))`，最后实际上是 `double(inc(3))`。
4. `x` 等于 `3` 同时传给 `inc()`。
5. `inc(3)` 等于 `4`。
6. `double(4)` 等于 `8`。
7. 函数返回 `8`。

组合软件时，可以被看作一个由函数组合的图。看一下下面：
	
	append = s1 => s2 => s1 + s2
	append('Hello, ')('world!')

你可以想象成这样：

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*LSXnRbKzQ4yhq1fjZjvq6Q.png">

lambda 表达式对软件设计产生了很大的影响，在 1980 年之前，计算机科学领域很多有影响的东西使用函数来构造软件。Lisp 在 1958 年被创作出来，很大程度上受到了 lambda 表达式的影响。如今，Lisp 是广泛使用的第二老的语言了。

我通过 AutoLISP：一个作为脚本语言被用于最流行的计算机辅助设计（CAD）软件：AutoCAD，接触到它。AutoCAD 很流行，实际上所有其他的 CAD 软件都兼容支持 AutoLISP。Lisp 因为以下三点原因被广泛作为计算机科学的课程：

1. 可以很容易的在一天左右学习 Lisp 基础的词法和语法。
2. Lisp 全是由函数组成，函数组合是构造应用非常优雅的方式。
3. 我知道的使用 Lisp 的最棒的计算机科学书籍：[计算机程序的结构与解释](https://www.amazon.com/Structure-Interpretation-Computer-Programs-Engineering/dp/0262510871/ref=as_li_ss_tl?ie=UTF8&amp;linkCode=ll1&amp;tag=eejs-20&amp;linkId=4896ed63eee8657b6379c2acd99dd3f3)。

### 组合型软件的衰落

在 1970 到 1980 中间的某段时间，软件的构造开始偏离简单的组合，成为一串线性的让计算机执行的指令。然后面向对象编程 — 一个伟大的关于组件的封装和信息传递的思想被流行的编程语言扭曲了，变成为了特性的重用所采取的糟糕的继承层次和 *is-a* 关系。

函数式编程语言退居二线：只有编程极客的痴迷、常春藤盟校的教授和一些幸运的学生可以在 1990 — 2010 年间逃离 Java 的强迫性学习。

对于我们的大多数人来说，已经经历了大约 30 年的软件编写噩梦和黑暗时期。

### 组合型软件的兴起

在 2010 年左右，一些有趣的事情发生了：JavaScript 的崛起。在大概 2006 年以前，JavaScript 被广泛的看作玩具语言和被用制作浏览器中好玩的动画，但是它里面隐藏着一些极其强大的特性。即 lambda 表达式中最重要的特性。人们开始暗中讨论一个叫做 “函数式编程的” 酷东西。

![](http://ww1.sinaimg.cn/large/006tNbRwgy1fekui0p6i3j30j50hcmyn.jpg)

我一直在告诉大家 #JavaScript 并不是一门玩具语言。现在我需要展示它。

在 2015 年，使用函数的组合来编写软件又开始流行起来。为了更简单化，JavaScript 规范获得的数十年来第一次主要的更新并且添加了箭头函数，为了更简单的编写和读取函数、柯里化，和 lambda 语句。

箭头函数像是 JavaScript 函数式编程飞升的燃料。现在很少看见不使用很多函数式编程技术的大型应用了。

组合型可以简单、优雅的表达软件的模型和行为。通过把小的、确定的函数组合成稍大的组件并构成软件的过程，可以更为简单的组织、理解、调试、扩展、测试和掌控。

你在阅读下一部分时，可以使用实例实验，记住要把你自己当孩子一样把其他的思想扔在一边在学习中去探索和玩耍。重新发现孩童时发现新事物的欣喜。让我们来做一些魔术吧。

[接下来的第二部分：“为什么要用 JavaScript 学习函数式编程？”](https://github.com/xitu/gold-miner/blob/master/TODO/why-learn-functional-programming-in-javascript-composing-software.md)

### 下一步

想更多的学习 JavaScript 的函数式编程？

[Learn JavaScript with Eric Elliott](http://ericelliottjs.com/product/lifetime-access-pass/)，什么，你还没有参加，out 了！

[![](https://cdn-images-1.medium.com/freeze/max/30/1*3njisYUeHOdyLCGZ8czt_w.jpeg?q=20)![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/)


*Eric Elliott* 是 [*“Programming JavaScript Applications”*](http://pjabook.com) (O’Reilly) 和 “Learn JavaScript with Eric Elliott” 的作者。他曾效力于 *Adobe Systems, Zumba Fitness, he Wall Street Journal, ESPN, BBC, and top recording artists including Usher, Frank Ocean, Metallica* 和其他一些公司。

**他和她的老婆（很漂亮）大部分时间都在旧金山湾区里。**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
