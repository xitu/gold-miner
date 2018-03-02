> * 原文地址：[Understanding JavaScript’s Engine with Cartoons](https://codeburst.io/understanding-javascripts-engine-with-cartoons-3ef56487a987)
> * 原文作者：[Codesmith Staffing](https://codeburst.io/@codesmith.staff?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/understanding-javascripts-engine-with-cartoons.md](https://github.com/xitu/gold-miner/blob/master/TODO/understanding-javascripts-engine-with-cartoons.md)
> * 译者：[MechanicianW](https://github.com/MechanicianW)
> * 校对者：[FateZeros](https://github.com/FateZeros) [tvChan](https://github.com/tvChan)

# 漫画图解 JavaScript 引擎： let jsCartoons = ‘Awesome’;

![](https://cdn-images-1.medium.com/max/1000/1*NV7LTr8xvs9p5BSzL79qsw.jpeg)

### 概述

[在之前的文章中](https://codeburst.io/javascript-what-are-you-ad28fabebdf1)，我们从事件执行机制详细地讲解了 JavaScript 引擎是如何工作的，同时也简略地提到了编译的知识。是的，你没看错。JavaScript 是编译的，尽管它并不像其它语言编译器有可以进行提前优化的构建阶段，JavaScript 不得不在最后一秒编译代码 —— 从字面上看。用于编译 JavaScript 的技术有一个十分恰当的名字，即时编译器（JIT）。这种 "即时编译" 技术已经应用到现代 JavaScript 引擎中，用于实现浏览器的加速。

开发者将 JavaScript 称为解释型语言，这会让人有点困惑。因为直到最近，JavaScript 引擎总是和解释器联系在一起。现在，伴随着像 Google [V8](https://v8project.blogspot.bg/2017/05/launching-ignition-and-turbofan.html) 这样的引擎出现，开发者们实现了鱼与熊掌兼得 —— 既拥有解释器也拥有编译器的引擎。

下面我们将展示这些流行的 JIT 编译器是怎么处理 JavaScript 代码的。引擎优化代码的复杂机制（如内联（去除空格），利用隐藏类以及消除冗余代码等）不在本文的讨论范围内。与之相反，本文着眼于编译原理，让你了解现代的 JavaScript 引擎内部是如何工作的。

**免责声明：** 看完这篇文章你可能会变成代码素食主义者。

### **语言与代码**

![](https://cdn-images-1.medium.com/max/800/0*I6a0MwHn5e7QzGs1.)

为了能够 **心意相通** 地领会编译器是怎么读懂代码的，你可以先想一下你此刻读文章时使用的语言：英语。我们都在开发控制台里看到过鲜红的 `SyntaxError` 报错，当我们抓破脑袋去找是哪里少了一个分号时，也许都想起过 Noam Chomsky。他将语法定义为：

> “研究以特定语言构造句子的原则和过程。”

我们在 Noam Chomsky 的定义的基础上调用 “内置” 的 `simplify()` 函数。

`simplify(quote, "grossly")`

`// 结果：语言的顺序并不相同`

当然，Chomsky 的定义是指德语和斯瓦西里等语言，而不是 JavaScript 和 Ruby。尽管如此，高级编程语言脱离了我们所说的语言。实质上，JavaScript 编译器已经被精明的工程师们 “教会” 阅读 JavaScript 代码，像我们的父母老师训练我们读懂句子一样。

我们可以观察出，语言学中的三个方面都与编译器有关：词法单元，语法和语义。换句话说，也就是研究单词的含义及其关系，研究单词的排列以及研究句子的含义（为了适应我们的场景，在此处限制了语义的定义）。

以这个句子为例： _We_ _ate beef._

#### 词法单元

请注意句子里的每个单词是如何被分解成具有词汇含义的单位：We/ate/beef

#### 语法

这个基础的句子在语法上遵循了主语 / 动词 / 宾语的协议。假设这就是每个英文句子必须遵从的构造方式。为什么要做这样的假设？因为编译器必须在严格的规定下工作，这样才能检测到语法错误。因此，_Beef we ate,_ 虽然仍是一个可以理解的句子，但在我们假设出的极简版英文语法规定中会是错误的。

#### 语义

从语义上讲，每个句子都有它的含义。我们知道许许多多的人过去都吃过牛肉。我们就可以通过把句子改写成 _We+ beef ate_ 来剥离出它的语义。

* * *

现在，我们英文中原有的 **句子** 翻译成 JavaScript **表达式**。

`let sentence = “We ate beef”;`

#### 词法单元

表达式可以被分解成词素： let/sentence/=/ “We ate beef”/;

#### 语法

我们的表达式，像句子一样必须是遵从语法构造的。JavaScript 以及大多数其它编程语言都遵从 (类型) / 变量 / 赋值 / 值 的顺序。类型是适应于上下文的。如果你也困扰于宽松的类型声明，可以给程序的全局作用域加上 `“use strict”;`。`“use strict”;` 是一种可以强制执行 JavaScript 语法规则的严格语法。相信我，使用 `“use strict”;` 利远大于弊。

#### 语义

从语义上讲，我们的代码都具有最终能被机器通过编译器来理解的含义。为了取到代码中的语义，编译器必须去读代码。我们在下一节深入研究这一环节。

**提示：** 上下文与作用域是不一样的。做更深层的阐述的话就超出了本文的 “作用域”。

### **LHS/RHS**

我们读英文是按照从左往右的顺序，编译器读代码却是双向的。编译器是怎么做到的？通过 LHS 查询 和 RHS 查询。我们来深入看看它们是怎么一回事。

LHS 查找聚焦于赋值操作的 “左边”。意思就是 LHS 负责查找赋值操作的 **目标**。我们要使用 **目标** 这个概念而不是 **位置**，因为 LHS 查找的目标可能位置不同。并且，**赋值操作** 也并不一定显式地指向 **赋值运算符**。

为了解释地更清楚，我们来看看下面这个例子：

```
function square(a){
    return a*a;

}

square(5);
```

这个函数会调起一次针对 `a` 的 LHS 查找。为什么？因为我们把 `5` 作为参数传入这个函数，并隐式地将它的值赋给了 a。注意，不可能一眼就看出赋值目标是什么，必须通过推断得出。

相反地，RHS 查找聚焦于值本身。回顾刚才的例子，RHS 查找会在 `a*a;` 表达式里找到 a 的值。

还有很重要的一点，这些查找操作是出现在编译的最后阶段，代码生成阶段。等讲到那一步我们将进一步阐述。现在我们来探索一下编译器。

### 编译器

把编译器想象成一个肉制品加工厂，有几种机制把代码研磨成计算机认为可食用或可执行的包。在这个例子中，我们将处理表达式。

![](https://cdn-images-1.medium.com/max/800/1*3lcS4meTcK8-nGZ6zIxyEQ.jpeg)

#### 标记解析器

首先，标记解析器将代码分解成称为 token 的单元。

![](https://cdn-images-1.medium.com/max/1000/1*aIyeA-blspqI0_EcQ0ZdnQ.jpeg)

这些 token 随后会被标记解析器标记。当标记解析器发现一个不属于该语言的 “字母” 时，会出现词法错误。请记住，这和语法错误不一样。例如，如果我们使用了 @ 符号而不是赋值运算符，那么标记解析器就会看到 @ 符号，并且说：“嗯......这个词法在 JavaScript 的词典里找不到......**红色警戒，关掉所有东西**。

**提示：** 如果这个系统能够在一个标记和另一个标记之间进行关联，然后像解析器一样将它们组合在一起，那么它将被视为一个**词法分析器**。

![](https://cdn-images-1.medium.com/max/1000/1*cpak2aD6ghUw62aqdbTehQ.jpeg)

#### 语法分析器

语法分析器会去查找语法错误。如果没有错误的话，语法分析器会把 token 打包成被一种被称为解析语法树的结构。在编译的这一环节，JavaScript 代码被视为已解析过，将要进行语义分析的。再一次，如果遵循了 JavaScript 规则，则会产生一个被称为抽象语法树 (AST) 的数据结构。

![](https://cdn-images-1.medium.com/max/1000/1*WxknfoF76q_SZkHg382xhA.jpeg)

这就是简化版的 AST

* * *

还有一个 **中间步骤** ，解释器将源码按照声明语句，逐个转换为中间代码（通常为字节码）。字节码随后在虚拟机内执行。

然后，**代码会被优化**，这其中包含了移除空格，不会被执行的死码和冗余代码，以及其它很多优化过程。

* * *

#### **代码生成器**

一旦代码优化完毕，代码生成器的工作是将中间代码转换为机器可以理解的底层汇编语言。此时，生成器负责：

(1) 确保底层代码保留与源代码相同的指令

(2) 将字节码映射到目标机器

(3) 决定值是否应该存储在寄存器或内存中，以及值可以在哪里检索读取

* * *

这是代码生成器执行 LHS 和 RHS 查找的环节。简而言之，LHS 查找会将目标值写入内存，RHS 查找会从内存中读取目标值。

如果值既被存入内存又被存入寄存器，代码生成器就会从寄存器中取值来进行优化。从内存中取值是最次选择。

* * *

到了最后……

(4) 决定了指令的执行顺序。

![](https://cdn-images-1.medium.com/max/800/1*aAzbHCGv1aeWGUUi0Zo7Eg.jpeg)

### **最后的一点思考**

理解 JavaScript 引擎的另一个方法是看看你的 [大脑](https://www.brainson.org/books-how-theyre-made-and-how-your-brain-reads-them/)。当你读到这里，你的大脑正在从视网膜获取数据。通过视神经传递的数据是网页的翻转版本，为了能解释图像，你的大脑会通过反转它来进行编译。

除了翻转图像并着色之外，大脑可以根据识别模式的能力来填充空格，就像编译器从缓存中读取数据一样。

因此如果我们写下 _please give us a round of ______,_ 这句话，你就很容易地执行这段代码。

* * *

code in peace

Raji Ayinla,

科技内容实习作家 @ [Codesmith Staffing](http://codesmithstaffing.com/)

**参考内容**

* [Anatomy of a Compiler by James Alan Farrel](http://www.cs.man.ac.uk/~pjj/farrell/comp3.html)
* [You Don’t Know JS Chapter 1](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20%26%20closures/ch1.md)
* [How JavaScript Works](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code-ac089e62b12e)
* [Compiler Design](https://www.tutorialspoint.com/compiler_design/compiler_design_overview.htm)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
