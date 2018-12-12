> * 原文地址：[Understanding Compilers — For Humans (Version 2)](https://towardsdatascience.com/understanding-compilers-for-humans-version-2-157f0edb02dd)
> * 原文作者：[Luke Wilson](https://towardsdatascience.com/@aesl?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-compilers-for-humans-version-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-compilers-for-humans-version-2.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[Raoul1996](https://github.com/Raoul1996), [Gavin-Gong](https://github.com/Gavin-Gong)

# 理解编译器 —— 从人类的角度（版本 2）

## 编程语言的工作原理

![](https://cdn-images-1.medium.com/max/2000/1*V5BFrMTfgA1GVPmVgQozBQ.jpeg)

理解编译器的内部原理会促使你更高效地使用它。在这个按时间排序的概要中，了解编程语言和编译器的工作原理。（为此）编写了大量的链接、示例代码和图表来帮助你理解。

* * *

#### 作者标注

**理解编译器 —— 从人类的角度（Version 2）**是我在 Medium 上发表的第二篇文章（有超过 21000 的阅读量）的后续。我很高兴自己的内容对大家产生了积极的影响，我也很开心**能根据从原文章收集到的意见来对其进行完整的重写**。

* [**理解编译器 —— 从人类的角度**：尽管你知道点击绿色按钮就可以执行，但你真的知道它的底层发生了哪些事情么？](https://medium.com/@CanHasCommunism/understanding-compilers-for-humans-ba970e045877 "https://medium.com/@CanHasCommunism/understanding-compilers-for-humans-ba970e045877")

我选择 Rust 作为这篇文章的首选语言。因为它详细、高效、现代化，而且从设计上看，编写编译器时会相对简单。我非常喜欢它。[https://www.rust-lang.org/](https://www.rust-lang.org/)

写这篇文章的目的是为了保证读者能集中精神，而不是 20 页的精神疲惫阅读。你可以在文中的许多链接中，选择自己感兴趣的内容，去了解相关内容的深层解读。当然，大部分都是链接向维基百科的。

请随意在文末进行评论，或者说出问题建议。感谢你的关注，希望你可以喜欢这篇文章。

* * *

### 简介

#### 什么是编译器

**当然，你也可以认为编程语言就是叫做编译器的软件，它读取文本文件，对其进行大量的处理，然后生成二进制文件**。由于计算机只能读 1 和 0，比起二进制，人类更擅长写 Rust，所以编译器将人类可读的文本转化为计算机可读的机器代码。**

编译器可以是将一个文本转变成另一个文本的程序。比如，这里有用 Rust 编写的编译器，它将 0 与 1 相互转化：

```
// 一个示例编译器，将 0 与 1 互换。
 
fn main() {
    let input = "1 0 1 A 1 0 1 3";
    
    // 对输入的每个字符 `c` 进行迭代
    let output: String = input.chars().map(|c|
        if c == '1' { '0' }
        else if c == '0' { '1' }
        else { c } // 如果不是 0 或 1，就忽略它（不进行处理）
    ).collect();
    
    println!("{}", output); // 0 1 0 A 0 1 0 3
}
```

尽管这个编译器不读取文件，不生成 AST（抽象语法树）或者二进制文件，但它仍然被看成是一个编译器，原因很简单，就是它可以翻译输入的内容。

#### 编译器会做什么事情

简而言之，编译器读取源代码并生产二进制文件。由于直接从人类可读的复杂代码转换成 1 和 0 非常复杂，因此编译器在运行之前会有几个处理步骤：

1.  读取给定源代码的每个字符。
2.  将字符排序为字母、数字、符号和运算符。
3.  获取已排序的字符，通过将它们与已有模式匹配并创建操作树来确定它们要执行的操作。
4.  迭代上一步生成的树中的每一个操作，并生成等效的二进制文件。

**虽然我说编译器会立即从运算符树转换为二进制，但它实际上会生成汇编代码，然后组装/编译成二进制代码，汇编是一个更高层次的、人类可读的二进制文件。更多程序集的相关阅读可[在此查询](https://en.wikipedia.org/wiki/Assembly_language)。**

![](https://cdn-images-1.medium.com/max/800/1*ttOYPPL-XJIf4zVZQUBzsQ.jpeg)

#### 解释器是什么

[解释器](https://en.wikipedia.org/wiki/Interpreter_%28computing%29)更像是编译器，因为它们都读取一种语言，然后对其进行处理。但是**解释器会跳过代码生成，[即时](https://en.wikipedia.org/wiki/Just-in-time_compilation)生成 AST**。对解释器来说，最大的优点就是降低在调试运行期间所花费时间。编译器在执行前可能需要从一秒钟到几分钟的时间来编译程序，而解释器则会立即开始执行，而不需要编译。解释器最大的缺点是需要在程序执行之前安装在用户的计算机上。

![](https://cdn-images-1.medium.com/max/800/1*QFH7Zl7s3vQJjBNjhTO1kg.jpeg)

**本文主要涉及编译器，但应该清楚它们之间的区别以及编译器之间的关系。**

### 1. 词法分析

第一步是将输入的内容分割成字符。这一步称为[词法分析](https://en.wikipedia.org/wiki/Lexical_analysis)，或标记化。主要目的是**将字符组合在一起，形成我们的单词、标识符、符号等**。词法分析通常不处理任何逻辑上的问题，比如求解 `2+2` —— 它只会说有三个[标记](https://en.wikipedia.org/wiki/Lexical_analysis#Token)：一个数字：`2`，一个加号，以及另一个数字：`2`。

假设你是在给像 `12+3` 这样的字符串下定义：它会读取字符 `1`、`2`、`+` 和 `3`。我们有单独的字符，但我们必须将它们组合在一起；这是 tokenizer 的主要任务之一。比如，尽管我们将 `1` 和 `2` 最为单独的字母，但我们最后还是要将它们组合在一起，然后解析成一个整数。`+` 将被识别为一个加号，而不是它的字面量值 —— [字符码](http://www.asciitable.com/) 43。

![](https://cdn-images-1.medium.com/max/800/1*D9FGqfO5JjSX9ZYERX9M5A.jpeg)

如果你可以看到代码并以这种方式使其更具意义，那么以下的 Rust 标记生成器可以将数字分成 32 位整数，并加上符号作为 `Token` 值 `Plus`。

[**Rust Playground**：play.rust-lang.org](https://play.rust-lang.org/?gist=070c3b6b985098a306c62881d7f2f82c&version=stable&mode=debug&edition=2015 "https://play.rust-lang.org/?gist=070c3b6b985098a306c62881d7f2f82c&version=stable&mode=debug&edition=2015")

**你可以单击 Rust Playground 左上角的 “RUn” 按钮，在你的浏览器中编译并执行代码。**

在编程语言的编译器中，lexer 词法分析器可能需要几种不同类型的标记。例如，符号、数字、标识符、字符串、运算符等。这完全取决于语言本身是否知道你需要从源码中提取什么样的标记。

```
int main() {
    int a;
    int b;
    a = b = 4;
    return a - b;
}

扫描生成内容：
[Keyword(Int), Id("main"), Symbol(LParen), Symbol(RParen), Symbol(LBrace), Keyword(Int), Id("a"), Symbol(Semicolon), Keyword(Int), Id("b"), Symbol(Semicolon), Id("a"), Operator(Assignment), Id("b"),
Operator(Assignment), Integer(4), Symbol(Semicolon), Keyword(Return), Id("a"), Operator(Minus), Id("b"), Symbol(Semicolon), Symbol(RBrace)]
```

已进行词法分析的 C 源码示例及其标记。

### 2. 解析

解析器确实是语法的核心。**解析器获取由 lexer 生成的标记，试图查看它们是否在某些模式中，然后将这些模式与诸如调用函数、回调变量或者数学操作相关联**。解析器实际上定义了语言的语法。

在解析器中，词组 `int a = 3` 和 `a: int = 3` 之间的区别。解析器决定了语法的外观。它确保括号和大括号的平衡性，每个语句都以分号结尾，而且每个函数都有一个名称。当代码不符合顺序，标记与预期模式不符，解析器都会知道。

**有几种不同的[类型解析器](https://en.wikipedia.org/wiki/Parsing#Types_of_parsers)可以编写。其中最常见的一种是自顶向下的*[_recursive-descent 解析器_](https://en.wikipedia.org/wiki/Recursive_descent_parser)。 _Recursive-descent_ 解析器使用和理解起来都是最简单的方法。我创建的所有解析器示例都是基于 _recursive-descent_。**

解析器解析的语法可以使用[语法](https://en.wikipedia.org/wiki/Formal_grammar)进行概括。像 [EBNF](https://en.wikipedia.org/wiki/Extended_Backus-Naur_form) 这样的语法可以描述像 `12+3` 这样简单数字操作的解析器：

```
expr = additive_expr ;
additive_expr = term, ('+' | '-'), term ;
term = number ;
```

用于简单加减表达式的 EBNF 语法。

**请记住，语法文件不是解析器，但是它是解析器所做工作的概要。你可以围绕这样的语法构建一个解析器。它将被人类使用，并且比直接查看解析器的代码更容易阅读和理解。**

该语法的解析器是 `expr` 解析器，因为它是顶级内容，所以基本上所有的内容都与之相关。唯一有效的输入必须是任意数字之间的加减。`expr` 期望 `additive_expr` 出现的主要是进行加减的地方。`additive_expr` 首先期望一个  `term`（一个数字），然后对另一个 `term` 进行加减。

![](https://cdn-images-1.medium.com/max/600/1*p6qemn-x4-KqbQMHa15qPQ.jpeg)

解析 12 + 3 而生产的示例 AST。

**解析器在解析过程生成的树称为[抽象语法树](https://en.wikipedia.org/wiki/Abstract_syntax_tree)，或者 AST**。AST 拥有所有的操作。解析器不计算操作，只保证按正确的顺序记录它们。

我将它们添加到之前的 lexer 代码中，这样就可以匹配我们的语法，并且可以像图表一样生成 AST。我用注释 `// BEGIN PARSER //` 和 `// END PARSER //` 标记了新解析代码的开头和结尾。

[**Rust 页面**：play.rust-lang.org](https://play.rust-lang.org/?gist=205deadb23dbc814912185cec8148fcf&version=stable&mode=debug&edition=2015 "https://play.rust-lang.org/?gist=205deadb23dbc814912185cec8148fcf&version=stable&mode=debug&edition=2015")

事实上我们可以了解的更深入。假设我们想要支持仅仅是没有运算符的数字输入，或者添加乘法和除法，甚至是添加优先级。这可以快速更改语法文件，并进行调整以将其反映在我们的解析器代码中。

```
expr = additive_expr ;
additive_expr = multiplicative_expr, { ('+' | '-'), multiplicative_expr } ;
multiplicative_expr = term, { ("*" | "/"), term } ;
term = number ;
```

新语法。

[**Rust 页面**：play.rust-lang.org](https://play.rust-lang.org/?gist=1587a5dd6109f70cafe68818a8c1a883&version=nightly&mode=debug&edition=2018 "https://play.rust-lang.org/?gist=1587a5dd6109f70cafe68818a8c1a883&version=nightly&mode=debug&edition=2018")

![](https://cdn-images-1.medium.com/max/800/1*OGlmE7PLYnK0H_apbU0kcg.gif)

C 的扫描器（又名词法分析器）和解释器示例。从字符 "`if(net>0.0)total+=net*(1.0+tax/100.0);"` 开始，扫描器组成一系列标记，并为每个标记分类，例如，作为标识符、保留字。数字文字或运算符。后一个序列由解析器转化为语法树，然后由其余的编译器阶段处理。扫描器和解析器分别处理 C 语法中正常和适当上下文无关的部分。Credit：Jochen Burghardt。[原件](https://commons.wikimedia.org/wiki/File:Xxx_Scanner_and_parser_example_for_C.gif)。

### 3. 生成代码

[代码生成器](https://en.wikipedia.org/wiki/Code_generation_%28compiler%29)接受 AST，然后在代码或汇编中生成等效的代码**代码生成器必须以递归下降的顺序遍历 AST 中的每一项 —— 就像解析器的工作原理 —— 然后在代码中发出等效项。**

* [**编译器资源管理器 —— Rust (rustc 1.29.0)**：godbolt.org](https://godbolt.org/z/K8416_ "https://godbolt.org/z/K8416_")

如果打开上面的链接，你会看到左边示例代码生成的程序集。汇编代码的第 3 行和第 4 行显示了编译器在 AST 中遇到常量时是如果生成常量代码的。

**Godbolt 编译器管理资源是一个优秀的工具，允许你用高级语言编写代码并查看其生产的汇编代码。你可以随意查看这些，看看应该编写什么样的代码，但不要忘记将优化标志添加到语言的编译器中，看看它们有多高明（Rust 的 `-O`）。**

如果你对编译器如何在 ASM 中将局部变量保存到内存中感兴趣，[这篇文章](https://norasandler.com/2018/01/08/Write-a-Compiler-5.html)（“代码生成”部分）详细解释了[栈](https://stackoverflow.com/a/80113)。在变量不是本地变量的多数情况下，高级编译器将在堆上的为变量分配内存，并将它们存储在堆中而不是栈中。你可以在 [StackOverflow](https://stackoverflow.com/a/18446414) 上阅读更多关于存储变量的信息。

由于组装是一个完全不同的复杂主题，所以我不会详细讨论它。我只想强调代码生成器的重要性以及工作原理。此外，代码生成器可以产生的不仅仅是集合内容。[Haxe](https://haxe.org/) 编译器有一个 [backend](https://en.wikipedia.org/wiki/Compiler#Back_end)，可以生成六种以上不同的编程语言；包括 C++、Java 和 Python。

后端主要是编译器的代码生成器或计算程序；因此，前端是 lexer 和解析器。还有一个与优化相关的中间件。IRs 将在本节末解释。后端大部分与前端无关，它只关心接收到的 AST。这意味着可以为几种不同的前端或语言重用相同的后端。[**GNU 编译器集合**](https://gcc.gnu.org/)就是这种情况。

**我想，我再也找不大比我的 C 编译器生成的后端代码更好的示例了：[你应该可以找到](https://github.com/asmoaesl/ox/blob/master/src/generator.rs)。**

生成程序集之后，应该将其写入一个新的组装文件（`.s` 或 `.asm`）。然后汇编器（程序集的编译器）会传递该文件，并以二进制形式生成等效的文件。二进制代码会写入一个称为对象文件（`.o`）的新文件。

**对象文件是机器码，它们是不可执行的。**想让它们成为可执行文件，就需要将对象文件链接在一起。链接器接受这个通用的机器代码，并使它们成为一个可执行文件，一个[共享库](https://en.wikipedia.org/wiki/Library_%28computing%29#Shared_libraries) 或 [静态库](https://en.wikipedia.org/wiki/Library_%28computing%29#Static_libraries)。**更多链接器可[在此查询](https://en.wikipedia.org/wiki/Linker_%28computing%29#Overview)。**

**链接器是基于操作系统变化而来实用性程序。一个独立的第三方链接器应该可以编译后端生成的对象代码。在生成编译器时，不再需要创建自己的链接器。**

![](https://cdn-images-1.medium.com/max/800/1*PP9A2JnhqTov_jCgqPCLxw.png)

编译器可能有一个[代理中间件](https://en.wikipedia.org/wiki/Intermediate_representation)，或者是 IR。**IR 是为优化或翻译成另一种语言而无损失的原生指令的表示**。IR 不是源代码，IR 是为了在代码中发现优化的可能性而进行的无损简化。[展开循环](https://en.wikipedia.org/wiki/Loop_unrolling)和[向量化](https://en.wikipedia.org/wiki/Automatic_vectorization)是使用 IR 完成的。更多 IR 相关的优化示例可在此 [PDF](http://www.keithschwarz.com/cs143/WWW/sum2011/lectures/140_IR_Optimization.pdf) 参阅。

### 结论

在你了解编译器之后，你的编程开发将会更加高效。将来的某一刻，你也许会对创造自己的编程语言感兴趣。希望这篇文章能对你有所帮助。

### 资源和深入学习的相关文章

*   [http://craftinginterpreters.com/](http://craftinginterpreters.com/) —— 指导你使用 C 和 Java 编写编译器。
*   [https://norasandler.com/2017/11/29/Write-a-Compiler.html](https://norasandler.com/2017/11/29/Write-a-Compiler.html) ——  对我来说，可能是最好的“编写编译器”教程。
*   我的 C 编译器和科学计算器解析器在[这里](https://github.com/asmoaesl/ox)以及[这里](https://github.com/asmoaesl/rsc)。
*   另一种称为 precedence climbing 解析器的示例，可以在[这里](https://play.rust-lang.org/?gist=d9db7cfad2bb3efb0a635cddcc513839&version=stable&mode=debug&edition=2015)找到。Credit：Wesley Norris。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
