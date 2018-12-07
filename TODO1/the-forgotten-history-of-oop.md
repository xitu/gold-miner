> * 原文地址：[The Forgotten History of OOP](https://medium.com/javascript-scene/the-forgotten-history-of-oop-88d71b9b2d9f)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-forgotten-history-of-oop.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-forgotten-history-of-oop.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 被遗忘的面向对象编程史（软件编写）（第十六部分）

![](https://user-gold-cdn.xitu.io/2018/12/4/16778a1832d9facc?w=2000&h=910&f=jpeg&s=120724)

Smoke Art Cubes to Smoke—MattysFlicks—(CC BY 2.0)

> 注: 这是 "组合软件" 系列的一部分，旨在从头开始学习 Javascript ES6+ 中的函数式编程和组合软件技术。更多内容即将推出，敬请关注！
> [< 上一篇](https://github.com/xitu/gold-miner/blob/a9a689ee3df732ea0c9e88207ad6cf0a10ad7d4b/TODO1/abstraction-composition.md) | [<< Start over at Part 1](https://github.com/xitu/gold-miner/blob/a9a689ee3df732ea0c9e88207ad6cf0a10ad7d4b/TODO1/composing-software-an-introduction.md)

我们今天使用的函数式和命令式编程范例最早出现于 20 世纪 30 年代，当时使用 Lambda 演算和图灵机进行数学探索，它们是通用计算（可执行通用计算的形式化系统）的替代公式。Church Turing 理论表明，lambda 演算和图灵机是等价的，任何使用图灵机可以做的计算都可以使用 lambda 演算来计算，反之亦然。

> 注：有一个普遍的误解，认为图灵机可以计算任何可计算的问题。但是有一些问题（例如，[停机问题](https://en.wikipedia.org/wiki/Halting_problem)） 在某些情况下是可计算的，但有些情况却是使用图灵机无法计算的。当我在本文中使用“可计算”一词时，我的意思是“可以由图灵机计算”。

Lambda 演算代表一种自上而下的函数式应用计算方法，而图灵机的纸带/寄存器式的机器公式则代表一种自下而上的、命令式（步进式）计算方法。

从 20 世纪 40 年代，开始出现像机器码和汇编语言这样的低级语言，直到 20 世纪 50 年代末，出现了第一个流行的高级语言。Lisp 语言，当然还包括 Clojure，Scheme，AutoLISP 等语言，直到今天还在被广泛使用。FORTRAN 和 COBOL 都出现在 20 世纪 50 年代，但直到今天还在被当作命令式高级语言的范例在使用，尽管对于大多数应用程序来说，C 族语言已经取代了 COBOL 和 FORTRAN。

命令式编程和函数式编程都起源于计算数学理论，它们比数字计算机还要早。“面向对象编程”（OOP）是艾伦·凯（Alan Kay）在 1966 年或 1967 年读研究生时创造的。

Ivan Sutherland 创新的 Sketchpad 应用程序是 OOP 的早期灵感。它开发于 1961 年至 1962 年，并于 1963 年发表在他的 [Sketchpad 论文](https://dspace.mit.edu/./1721.1/14979) 中。其中对象是表示在示波器屏幕上显示的图像的数据结构，并且通过动态表示具有继承特性，Ivan Sutherland 在他的论文中称之为“masters”。任何对象都可以成为“master”，而对象的其他实例称为“occurrences”。Sketchpad 的 masters 和 JavaScript 的原型链继承有很多共同之处。

> **注意：** 麻省理工学院林肯实验室的 TX-2 是使用激光笔直接进行屏幕交互的图形计算机显示器的早期用途之一。1948-1958 运行的 EDSAC，可以在屏幕上显示图形。1949 年，麻省理工学院的“旋风”项目使用了一个示波器。该项目的动机是创建一个能够模拟多架飞机仪器反馈的通用飞行模拟器。这引领了 SAGE 计算系统的发展。[TX-2 是 SAGE 的测试计算机](http://www.computerhistory.org/revolution/real-time-computing/6/123)。

提出于 1965 年的 simula 语言，是第一个被广泛认可的“面向对象”的编程语言。与 Sketchpad 一样，Simula 使用了对象，甚至还引入了类，类继承，子类和虚方法。

> 注意：**虚方法**是定义在类上的方法，它被设计为可以被子类重写。虚方法允许程序动态指定在编译代码时可能不存在的方法，以此确定在运行时调用哪个具体方法。JavaScript 具有动态类型，并使用委托链来确定要调用的方法，因此不需要向开发者再提供虚方法的概念。换句话说，JavaScript 中的所有方法都是运行时进行动态调度，因此 JavaScript 中的方法不需要声明为“虚方法”。

 ### 伟大的想法

> “我使用'面向对象'这个术语，我告诉你我并没有考虑到 C++。” Alan Kay，OOPSLA '97

Alan Kay 在 1966 或 1967 年间在研究生院创造了“面向对象编程”一词。这个伟大的想法是想在软件中使用封装好的微型计算机，通过消息传递而不是直接的数据共享， 以此来防止将程序分裂为单独的“数据结构“和“程序”。

“递归设计的基本原理是使局部具有与整体相同的能力。”BB Barton，B5000 的主要设计者，这是一个经过优化来运行 Algol-60 的主机。

Smalltalk 由 Alan Kay，Dan Ingalls，Adele Goldberg 和 Xerox PARC 的其他人一起开发。Smalltalk 比 Simula 更加面向对象 - Smalltalk 中的所有东西都是对象，包括类，整数和块(闭包)。最初的 Smalltalk-72 不支持创建子类。[创建子类是由 Dan Ingalls 在 Smalltalk-76 中引入的](http://worrydream.com/EarlyHistoryOfSmalltalk)。

尽管 Smalltalk 支持类并最终支持创建子类，但 Smalltalk 不只是关于类或创建子类的。它是受到 Lisp 和 Simula 启发的功能语言。Alan Kay 认为业界对子类过度关注而由此忽略了面向对象编程带来的真正好处。

>“我很抱歉，我很久以前为这个话题创造了“对象“一词，而因为它让很多人专注于细枝末节。实际上真正重要的是消息传递。”
> ~Alan Kay

在 [2003 年的电子邮件](http://www.purl.org/stefan_ram/pub/doc_kay_oop_en) 中，Alan Kay 阐明了他为什么称 Smalltalk 为“面向对象”：

> “OOP 对我来说意味着消息传递，对状态进程的本地保留保护和隐藏，以及对所有事物的动态绑定。”
> ~Alan Kay

换句话说，根据 Alan Kay 的说法，OOP 的基本要素是：

 * 消息传递
 * 封装
 * 动态绑定

显然，创造了这个术语，并为我们带来 OOP 的 Alan Kay 并不认为继承和子类多态性是 OOP 的必要组成部分。

 ### OOP 的本质

消息传递和封装的结合有一些重要的目的：

* **避免共享可变状态**，通过封装状态并将其他对象与本地状态更改隔离开来。影响另一个对象状态的唯一方法是通过发送消息来请求(而不是命令)该对象来更改它。状态变化由局部控制，蜂窝级别，而不是暴露于共享访问。
 * **解耦** - 通过消息传递 API，消息发送者与消息接收者松散耦合。
 * **适应变化**，通过动态绑定在运行时适应变化。Alan Kay 认为运行的时适应性给 OOP 带来很多至关重要的好处。

这些想法的灵感来自于生物细胞和/或网络上的个人计算机，受到 Alan Kay 的生物学背景和 Arpanet(早期版本的互联网)的设计影响。在想法提出之前，Alan Kay 就想象软件运行在巨大的分布式计算机(互联网)上，个人计算机就像生物细胞一样，在自己的孤立状态下独立运行，并通过消息传递进行通信。

> “我意识到细胞与整个计算机类比会脱离数据\ [... \]”
>  ~Alan Kay

通过“脱离数据”，Alan Kay 意识到共享可变状态的问题和由共享数据引起的耦合问题 - 这些都是今天的普遍问题。

但是在 20 世纪 60 年代后期，[ARPA 程序员对在程序编写之前选择数据模型的需求感到沮丧](https://www.rand.org/content/dam/rand/pubs/research_memoranda/2007/RM5290.pdf)。程序与特定数据结构过度耦合使得程序无法适应变化。他们希望对数据进行更加统一的处理。

>“[...] OOP 的核心是不需要再关心对象内部的内容。使用不同机器和不同语言开发的对象应该可以互相交通信[...]” ~ Alan Kay

对象可以被抽象出来并隐藏数据结构的实现方法。对象的内部实现可以在不破坏软件系统其他部分的情况下进行更改。实际上，通过迟约束，完全不同的计算机系统可以接管对象的功能，并且软件可以继续工作。与此同时，对象可以公开一个标准接口，该接口可以处理对象在内部使用的任何数据结构。相同的接口可以使用链表，树，流等。

Alan Kay 还将对象视为代数结构，这些结构可以通过数学来证明它们的行为：

> “我的数学背景使我意识到每个对象可能有几个与之相关的代数式，可能有代数式族，而这些将会非常有用。”
> ~Alan Kay

这已经被证明是对的，并且构成了 promises 和 lenses 等对象的基础，这两个对象都受到类别理论的启发。

Alan Kay 对于对象具有代数性质的观点将允许对象提供公式化验证，确定性行为和改进的可测试性，因为代数本质上是遵循方程式规则的操作。

在程序员术语中，代数就像是由函数(操作)组成的抽象，这些函数必须通过单元测试强制执行的特定规则(公理/方程式)。

这样的想法在大多数 C 族面向对象语言中被遗忘了几十年，包括 C++，Java，C# 等，但现在在它们的最新版本中正在逐渐找回这样的特性。

你可能会说编程世界正在重新发现面向对象语言环境中的函数式编程和理性思维带来的优势。

就像之前的 JavaScript 和 Smalltalk 一样，大多数的现代面向对象语言正变得越来越“多范式”。已经没有理由在函数式编程和面向对象编程之间进行选择。当我们追溯它们各自的历史本源时，它们是既相互兼容，又相互互补的。

因为它们有如此多共通的特性，我想说 JavaScript 是针对世界对面向对象编程的误解的一种反击。Smalltalk 和 JavaScript 都支持：

 * 对象
 * 主类函数和闭包
 * 动态类型
 * 迟绑定(函数/方法在运行时可更改)
 * 不支持类继承的面向对象语言

什么是面向对象编程的必要特性(根据 Alan Kay 的说法)？

 * 封装
 * 消息传递
 * 动态绑定(程序在运行时进化/适应的能力)

什么是非必要的特性？

 * 类
 * 类继承
 * 对象/函数/数据的特殊处理
 * `new`关键字
 * 多态性
 * 静态类型
 * 将类识别为“类型”

如果您是 Java 或 C# 的开发者，您可能会认为静态类型和多态性是必不可少的成分，但Alan Kay 倾向于以代数形式处理共性行为。例如，来自 Haskell：

```
fmap ::(a  - > * b) - > * f a  - > * f b
```

这是仿函数映射签名，它通常用于未指定类型`a`和`b`，在`a`的仿函数的上下文中应用从`a`到`b`的函数来生成`b 的仿函数`。仿函数是数学术语，含义是“支持映射操作”。如果您熟悉 JavaScript 中的`[] .map()`，那么您已经知道它的含义是什么。

这是 JavaScript 中的两个例子：

```
// isEven = Number => Boolean
const isEven = n => n % 2 === 0;

const nums = [1， 2， 3， 4， 5， 6];

// map takes a function `a => b` and an array of `a`s (via `this`)
// and returns an array of `b`s。
// in this case， `a` is `Number` and `b` is `Boolean`
const results = nums。map(isEven);

console.log(results);
// [false， true， false， true， false， true]
```

`.map()`方法是通用的，因为 `a` 和 `b` 可以是任何类型，而 `.map()` 处理它刚刚好，因为数组是代数上实现 `functor` 规则的数据结构。类型与 `.map()` 无关，因为它不会尝试直接操作它们，而是通过一个函数来返回正确的期望类型。

```
// matches = a => Boolean
// here， `a` can be any comparable type
const matches = control => input => input === control;

const strings = ['foo'， 'bar'， 'baz'];

const results = strings。map(matches('bar'));

console.log(results);
// [false， true， false]
```

泛型类型关系很难在 TypeScript 这样的语言中完全正确地表达，但在 Haskell 的 Hindley Milner 类型中很容易表达，因为它支持更高级的类型(类型的类型)。

大多数类型系统有太多的限制，不允许自由表达动态和函数的想法，例如函数组合，自由对象组合，运行时对象扩展，组合器，镜头等。换句话说，静态类型经常会使得组合软件的编写更加困难。

如果类型系统限制太多(例如 TypeScript，Java)，您将不得不为了实现相同的目标编写更加复杂的代码。这并不是说静态类型是一个糟糕的主意，或者说所有静态类型的实现都具有同样的限制性。我使用 Haskell 类型系统遇到的问题就很少。

如果你热衷静态类型，你不会介意这些限制，这会是你更加有掌控力，但是如果你发现一些本文中建议中提到的那些困难，比如很难输入组合函数和复合代数结构，因此就归咎于类型系统，这样并不是可取的想法。人们喜欢 SUV 能给你带来舒适性，但不会有人抱怨 SUV 不能让你飞起来。如果为了追求那样的体验，您需要一辆拥有更多自由度的车辆。

如果这样的限制能使您的代码更简单，那就太棒了!但是如果这些限制迫使你编写更复杂的代码，那么这样的限制可能就是错误的。

 ### 什么是对象？

多年来，对象已经被赋予大量的含义。我们在 JavaScript 中称之为“对象”的只是复合数据类型，没有任何基于类的编程或 Alan Kay 所说的消息传递的含义。

在 JavaScript 中，对象可以并且通常必须支持封装，消息传递，通过方法进行行为共享，甚至子类多态(尽管使用委托链而不是基于类型的调度)。您可以将任何函数赋给任何属性。您可以动态创建对象行为，并在运行时更改对象的含义。JavaScript 还支持使用闭包进行封装以实现隐私。但所有这些都是选择加入的行为。

我们现在认为对象只是一个复合数据结构，并不需要其他更多的含义。但是使用这样的对象                     进行编程并不会使您的代码比使用函数编程更加的“面向对象”。

 #### 面向对象不再是真正的面向对象

因为现代编程语言中的“对象”意味的比 Alan Kay 设想的要少得多，所以我使用“组件”而不是“对象”来描述真正的面向对象的规则。在 JavaScript 中，许多_objects_可以由其他代码直接拥有和操作，但是**组件**应该封装和控制它们自己的状态。

真正的面向对象的含义：

 * 使用**组件**编程(就是 Alan Kay 所说的“对象”)
 * 必须封装组件状态
 * 使用消息传递进行对象间通信
 * 组件可以在运行时被创建/更改/替换

大多数组件行为可以使用代数型数据结构进行定义。不需要继承。组件可以通过共用函数和模块化导入来进行重用，而无需共享数据。

在 JavaScript 中操作_objects_或使用_class inheritance_并不意味着你在“面向对象”。但是这样使用组件就意味着“面向对象”。但流行的用法是如何定义单词，所以也许我们应该放弃面向对象并将其称为“面向消息的编程(MOP)”而不是“面向对象的编程(OOP)”？

拖把被用来清理垃圾是一种巧合吗？

 ### 什么是好的面向消息的编程（MOP）

在大多数现代软件中，有一些负责管理用户交互的界面，还有管理应用程序状态(用户数据)，代码管理系统或者网络 I/O 的代码。

每个系统可能都需要长期驻留的进程，例如事件监听器，跟踪网络连接状态，界面元素状态和应用程序状态等。

好的 MOP 意味着系统是通过消息调度与其他组件通信，不是各个系统去直接操纵彼此的状态。当用户单击保存按钮时，可能会调度“保存”消息，应用程序状态组件可能会将其解析并转发到状态更新处理程序(例如纯缩减器函数)。也许在状态更新之后，状态组件可能会向界面组件发送一个“状态更新”的消息，而界面组件又将解析状态，协调界面的哪些部分需要更新，并将更新后的状态转发给处理界面的子组件。

同时，网络连接组件可能正在监视用户与网络上另一台计算机的连接，侦听消息以及调度更新状态以便在远程计算机上保存数据。它在内部保持网络心跳计时器，无论当前连接是在线还是离线。

这些系统不需要知道系统其他部分的细节。只需要关注自身的模块化问题。系统组件是可分解和可重新组合的。它们实现标准化接口，以便它们能够相互操作。只要接口满足，您就可以用使用其他实现方式来替换当前的方式，或在不同的事物之间使用相同的消息通信。你甚至可以在运行时进行切换，一切都会照常工作。

同一个软件系统的组件甚至都不需要位于同一台机器上。系统可以是分布式的。网络存储可能会在分布式存储系统中共享数据，比如[IPFS](https://en。wikipedia。org/wiki/InterPlanetary_File_System)，因此用户不会依赖任何特定计算机的运行状况来确保其数据的安全，以免遭受来自黑客的安全威胁。

面向对象部分受到 Arpanet 的启发，Arpanet 的目标之一是构建一个分布式网络，可以抵御像原子弹那样的攻击。根据 DARPA 总监 Stephen J. Lukasik 在 Arpanet 开发期间所说([“为什么建立 Arpanet”](https://ieeexplore。ieee。org/document/5432117))：

> “我们的目标是开发新的计算机技术，以满足军事上抵抗核威胁的需要，实现对美国核力量的控制，并改善军事战术和管理决策。”

> **注** Arpanet 的主要推动力是方便而不是核威胁，其明显的防御优势是后来提出的。ARPA 使用三个独立的计算机终端与三个独立的计算机研究项目进行通信。Bob Taylor 想要一个单独的计算机网络将每个项目与其他项目连接起来。

一个好的 MOP 系统可以在应用程序运行时使用可热插拔的组件来共享互联网的健壮性。如果用户在使用手机时因为进入一条隧道而发生离线，它可以继续工作。如果飓风将其中一个数据中心的电源摧毁，它仍然可以继续运行。

现在是时候让软件世界放弃失败的类继承实验了，转而接受最初定义面向对象时所秉承的数学和科学精髓。

现在是时候开始构建更灵活，更具弹性，更容易组合的软件了，让 MOP 和函数编程协调工作。

> 注意：MOP 的首字母缩略词已被用于描述“面向监视的编程”，OOP 不太可能的会悄无声息的消失。

> 如果 MOP 没有成为编程术语，请不要沮丧。
> 在你的 OOP 基础上开始 MOP。

### 通过 EricElliottJS.com 了解更多信息

EricElliottJS.com 的会员可以观看函数编程的相关视频。如果您还不是会员，请[今天注册](https://ericelliottjs.com/)。

 * * *

 **_Eric Elliott_** _是_ [_“编程 JavaScript 应用程序”_](http://pjabook.com)_(O'Reilly)的作者，软件导师平台_[_DevAnywhere.io_](https://devanywhere。io/) _的联合创始人_ 。_他是很多软件的贡献者_， **_Adobe Systems_** ，**_Zumba Fitness_**，**_华尔街日报_**，**_ESPN_**，**_BBC_**， _还和顶级的唱片艺人合作，包括_**_Usher, Frank Ocean, Met_**。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到[掘金翻译计划](https://github.com/xitu/gold-miner)对译文进行修改并 PR，也可获得相应奖励积分。文章开头的**本文永久链接**即为本文在 GitHub 上 的 MarkDown 链接。


 ......

> [Nuggets Translation Program] (https://github.com/xitu/gold-miner) is a community that translates high-quality Internet technology articles from [Nuggets] (https://juejin。im)Share articles in English。Content coverage [Android] (https://github.com/xitu/gold-miner#android)， [iOS] (https://github.com/xitu/gold-miner#ios)， [front end] (https://github.com/xitu/gold-miner# frontend)， [backend] (https://github.com/xitu/gold-miner#backend)， [blockchain] (https://github.com/xitu/gold-miner# blockchain)， [product] (https://github.com/xitu/gold-miner# product)， [design] (https://github.com/xitu/gold-Miner# design)， [artificial intelligence] (https://github.com/xitu/gold-miner# artificial intelligence)， etc。， if you want to view more high-quality translations， please keep an eye on [Nuggets translation plan] (https://github.com/xitu/gold-miner)， [Official Weibo] (http://weibo.com/juejinfanyi)， [Knowledge Column] (https://zhuanlan。zhihu.com/juejinfanyi)。
