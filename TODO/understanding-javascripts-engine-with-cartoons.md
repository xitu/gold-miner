> * 原文地址：[Understanding JavaScript’s Engine with Cartoons](https://codeburst.io/understanding-javascripts-engine-with-cartoons-3ef56487a987)
> * 原文作者：[Codesmith Staffing](https://codeburst.io/@codesmith.staff?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/understanding-javascripts-engine-with-cartoons.md](https://github.com/xitu/gold-miner/blob/master/TODO/understanding-javascripts-engine-with-cartoons.md)
> * 译者：[MechanicianW](https://github.com/MechanicianW)
> * 校对者：

# 漫画图解 JavaScript 引擎： let jsCartoons = ‘Awesome’;

![](https://cdn-images-1.medium.com/max/1000/1*NV7LTr8xvs9p5BSzL79qsw.jpeg)

### 概述

[在之前的文章中](https://codeburst.io/javascript-what-are-you-ad28fabebdf1)， 我们从事件执行机制详细地讲解了 JavaScript 引擎是如何工作的，同时也简略地提到了编译的知识。是的，你没看错。JavaScript 是编译的，尽管它并不像其它语言编译器有可以进行早优化的构建阶段，JavaScript 不得不在最后一秒编译代码 —— 从字面上看。用于编译 JavaScript 的技术有一个十分恰当的名字，即时编译器（JIT）。这种 "即时编译" 技术已经应用到现代 JavaScript 引擎中，用于加速浏览器呈现。

开发者将 JavaScript 称为解释型语言，这会让人有点困惑。因为直到最近，JavaScript 引擎总是和解释器联系在一起。现在，伴随着像 Google [V8](https://v8project.blogspot.bg/2017/05/launching-ignition-and-turbofan.html) 这样的引擎出现，开发者们实现了鱼与熊掌兼得 —— 既拥有解释器也拥有编译器的引擎。

下面我们将展示这些流行的 JIT 编译器是怎么处理 JavaScript 代码的。引擎优化代码的复杂机制（如内联（去除空格），利用隐藏类以及消除冗余代码等）不在本文的讨论范围内。与之相反，本文着眼于编译原理，让你了解现代的 JavaScript 引擎内部是如何工作的。

**免责声明：** 看完这篇文章你可能会变成代码素食主义者。

### **语言与代码**

![](https://cdn-images-1.medium.com/max/800/0*I6a0MwHn5e7QzGs1.)

为了能够 **心意相通** 地领会编译器是怎么读懂代码的，你可以先想一下你此刻读文章时使用的语言：英语。我们都在开发控制台里看到过鲜红的 `SyntaxError` 报错，当我们抓破脑袋去找是哪里少了一个分号时，也许都想起过 Noam Chomsky。他将语法定义为：

> “研究以特定语言构造句子的原则和过程。”

我们在 Noam Chomsky 的定义的基础上调用 “内置” 的 `simplify()` 函数。

`simplify(quote, "grossly")`

`//Result: Languages order their words differently.`

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

我们的表达式，像句子一样必须是遵从语法构造的。JavaScript 以及大多数其它编程语言都遵从 (类型) / 变量 / 赋值 / 值 的顺序。类型是适应于上下文的。如果你也困扰于宽松的类型声明，可以给程序的全局作用域加上 `“use strict”;`。`“use strict”;` 是一种可以强制执行 JavaScript 语法规则的霸道语法。相信我，使用 `“use strict”;` 利远大于弊。

#### 语义

Semantically, our code has meaning that our machines will eventually understand via the compiler. In order to achieve semantic meaning from code, the compiler must read code. We’ll delve into that in the next section.

**Note:** Context differs from scope. Explaining further would go beyond the “scope” of this article.

### **LHS/RHS**

We read English from left to right while the compiler reads code in both directions. How? With Left -Hand-Side(LHS) look-ups and Right-Hand-Side (RHS) look-ups. Let’s break them down.

LHS look-ups focus are the “left hand side” of an assignment. What this really means is that it is responsible for the target of the assignment. We should conceptualize _target_ rather than _position_ because an LHS look-up’s target can vary in its position. Also, _assignment_ does not explicitly refer to the _assignment operator_.

Check out the example below for clarification:

```
function square(a){
    return a*a;

}

square(5);
```

The function call triggers an LHS lookup for `a`. Why? Because passing `5` as an argument implicitly assigns value to a. Notice how the target can’t be determined by positioning at first glance and must be inferred.

Conversely, RHS look-ups focus on the values themselves. So if we go back to our previous example, an RHS lookup will find the value of a in the expression `a*a;`

It is important to keep in mind that these look-ups occur in the last phase of compilation, the code-generation phase. We’ll elaborate further once we get to that stage. For now, let’s explore the compiler.

### The Compiler

Think of the compiler as a meat processing plant with several mechanisms that grind the code into a package that our computer deems edible or executable. In this example, we will be processing Expression.

![](https://cdn-images-1.medium.com/max/800/1*3lcS4meTcK8-nGZ6zIxyEQ.jpeg)

#### Tokenizer

First, the tokenizer dissects code into units called tokens.

![](https://cdn-images-1.medium.com/max/1000/1*aIyeA-blspqI0_EcQ0ZdnQ.jpeg)

These tokens are then identified by the tokenizer. A lexical error will occur when the tokenizer finds an “alphabet” that does not belong to the language. Remember, this is different from a syntactical error. For example, if we had used an @ symbol instead of an assignment operator, the tokenizer would’ve seen that @ symbol and said, “Hmmm…This lexeme is not found within JavaScript’s lexicon… SHUT EVERYTHING DOWN. CODE RED.”

**Note:** If this same system is able to make associations between one token and another token, and then group them together like a parser, it will be considered a **lexer**.

![](https://cdn-images-1.medium.com/max/1000/1*cpak2aD6ghUw62aqdbTehQ.jpeg)

#### Parser

The parser looks for syntactical errors. If there are no errors, it packages the tokens into a data structure called a Parse Tree. At this point in the compilation process, the JavaScript code is considered to be parsed and is then semantically analyzed. Once again, if the rules of JavaScript are followed, a new data structure called an Abstract Syntax Tree(AST) is produced.

![](https://cdn-images-1.medium.com/max/1000/1*WxknfoF76q_SZkHg382xhA.jpeg)

This is an oversimplified AST

* * *

There is an **intermediary step** where the source code is transformed into intermediate code — usually bytecode — by an interpreter, statement by statement. The bytecode is then executed within a virtual machine.

Afterwards, the **code is optimized**. This involves the removal of white space, dead code, and redundant code, among many other optimization processes.

* * *

#### **Code-Generator**

Once the code is optimized, the code-generator’s job is to take the intermediate code and turn it into a low level assembly language that a machine can readily understand. At this juncture, the generator is responsible for:

(1) making sure that the low level code retains the same instructions as the source code

(2) mapping bytecode to the target machine

(3) deciding whether values should be stored in register or memory and where values should be retrieved.

* * *

Here is where a code-generator performs LHS and RHS look-ups. Simply put, an LHS look-up writes to memory the target’s value and an RHS look-up reads value from memory.

If a value is stored in both cache and register, the generator will have to optimize by taking the value from register. Taking values from memory should be the least preferred method.

* * *

And, finally…

(4) deciding the order in which instruction should be executed.

![](https://cdn-images-1.medium.com/max/800/1*aAzbHCGv1aeWGUUi0Zo7Eg.jpeg)

### **Final Thoughts**

One other way to understand JavaScript’s engine is to look at your [brain](https://www.brainson.org/books-how-theyre-made-and-how-your-brain-reads-them/). As you’re reading this, your brain is fetching data from your retina. This data, transferred by your optic nerve, is an inverted version of this web page. Your brain compiles the image by flipping it so that it is interpretable.

Beyond just flipping images and colorizing them, your brain can fill in blank spaces based on its ability to recognize patterns, like a compiler’s ability to read values from cached memory.

So if we write, _please give us a round of ______,_you should easily be able to execute that code.

* * *

code in peace

Raji Ayinla,

Intern Technical Content Writer @ [Codesmith Staffing](http://codesmithstaffing.com/)

**Resources**

* [Anatomy of a Compiler by James Alan Farrel](http://www.cs.man.ac.uk/~pjj/farrell/comp3.html)
* [You Don’t Know JS Chapter 1](https://github.com/getify/You-Dont-Know-JS/blob/master/scope%20%26%20closures/ch1.md)
* [How JavaScript Works](https://blog.sessionstack.com/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code-ac089e62b12e)
* [Compiler Design](https://www.tutorialspoint.com/compiler_design/compiler_design_overview.htm)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
