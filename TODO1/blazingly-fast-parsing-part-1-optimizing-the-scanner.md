> * 原文地址：[Blazingly fast parsing, part 1: optimizing the scanner](https://v8.dev/blog/scanner)
> * 原文作者：[tverwaes](https://twitter.com/tverwaes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/blazingly-fast-parsing-part-1-optimizing-the-scanner.md](https://github.com/xitu/gold-miner/blob/master/TODO1/blazingly-fast-parsing-part-1-optimizing-the-scanner.md)
> * 译者：[nettee](https://github.com/nettee)
> * 校对者：[suhanyujie](https://github.com/suhanyujie)

# 超快速的分析器（一）：优化扫描器

要运行 JavaScript 程序，首先要处理源代码，让 V8 能理解它。V8 首先将源代码解析为一个抽象语法树（AST），这是用来表示程序结构的一系列对象。Ignition 会将它编译为字节码（bytecode）。语法分析 + 编译的这两个步骤的性能很重要，因为 V8 只有等编译完成才能运行代码。在这个系列的博客文章中，我们关注语法分析阶段，以及 V8 为提供一个超快速的分析器所做的工作。

实际上我们的系列文章始于语法分析器的前一阶段。V8 的语法分析器接收**扫描器**（也就是词法分析器 —— 译注）提供的标记（token）作为输入。Token 是由一个或多个字符相连而成、有单一语义含义的字符块，例如字符串、标识符，或像 `++` 这样的操作符。扫描器通过组合底层字符流中的连续字符来构造这些 token。

扫描器接收 Unicode 字符流。这些 Unicode 字符总是从一个有 UTF-16 码元（code unit）的流中解码。为了避免扫描器和语法分析器面对不同编码的特殊处理，我们只支持一种编码。我们选择 UTF-16 是因为它是 JavaScript 字符串的编码。并且源码位置需要相对于该编码而提供。[`UTF16CharacterStream`](https://cs.chromium.org/chromium/src/v8/src/scanner.h?rcl=edf3dab4660ed6273e5d46bd2b0eae9f3210157d&l=46) 提供了（可能是缓冲的）UTF-16 视图，该视图构建于 V8 从 Chrome 接收的 Latin1、UTF-8 或 UTF-16 编码之上。除了可以支持多种编码，这种扫描器和字符流分离的方式使 V8 在扫描时可以如同整个源代码都可用一样，即使可能只通过网络接收了一部分代码。

![](https://v8.dev/_img/scanner/overview.svg)

扫描器和字符流之间的接口是一个叫做 [`Utf16CharacterStream::Advance()`](https://cs.chromium.org/chromium/src/v8/src/scanner.h?rcl=edf3dab4660ed6273e5d46bd2b0eae9f3210157d&l=54) 的方法。它要么返回下一个 UTF-16 码元，要么返回 `-1` 来标识输入的结束。UTF-16 无法将每一个 Unicode 字符都编码在单个码元中。[Basic Multilingual Plane](https://en.wikipedia.org/wiki/Plane_(Unicode)#Basic_Multilingual_Plane) 之外的字符要编码为两个码元，它们也叫做代理对（surrogate pair）。扫描器在 Unicode 字符上进行工作，而不是 UTF-16 码元，所以它使用 [`Scanner::Advance()`](https://cs.chromium.org/chromium/src/v8/src/scanner.h?sq=package:chromium&g=0&rcl=edf3dab4660ed6273e5d46bd2b0eae9f3210157d&l=569) 方法包装底层流接口。这个方法将 UTF-16 码元解码为完整的 Unicode 字符。当前解码出的字符会被缓冲，然后被 [`Scanner::ScanString()`](https://cs.chromium.org/chromium/src/v8/src/scanner.cc?rcl=edf3dab4660ed6273e5d46bd2b0eae9f3210157d&l=775) 之类的扫描方法取走。

扫描器会最多向前看 4 个字符 —— 这是 JavaScript 中歧义字符序列的最大长度 [[1]](#fn1) —— 以此[选择](https://cs.chromium.org/chromium/src/v8/src/scanner.cc?rcl=edf3dab4660ed6273e5d46bd2b0eae9f3210157d&l=422)特定的扫描器方法或 token。一旦选定了像 `ScanString` 这样的方法，它会取走这个 token 余下的字符，并将不属于这个 token 的第一个字符缓冲，留给下一个扫描的 token。在 `ScanString` 的情况中，它还将扫描到的字符拷贝到一个编码为 Latin1 或 UTF-16 的缓冲区中，同时解码转义序列。

## 空白符

token 之前可以由多种空白符分隔，如换行、空格、制表符、单行注释、多行注释等等。一类空白符可以跟随其他类型的空白符。如果空白符导致了两个 token 之前的换行，会增加含义：这可能导致[自动插入分号](https://tc39.github.io/ecma262/#sec-automatic-semicolon-insertion)。因此，在扫描下一个 token 之前，会跳过所有的空白符，并记录是否遇到了换行。大多数真实生产环境中的 JavaScript 代码都进行了缩小化（minify），所以幸运地，多字符的空白不是很常见。出于这个原因，V8 统一独立地扫描出每种空白符，就像是常规 token 一样。例如，如果 token 的第一个字符是 `/`，第二个字符也是 `/`，V8 会将其扫描为单行注释，返回 `Token::WHITESPACE`。这个过程会一直重复，[直到](https://cs.chromium.org/chromium/src/v8/src/scanner.cc?rcl=edf3dab4660ed6273e5d46bd2b0eae9f3210157d&l=671)我们找到了一个不是 `Token::WHITESPACE` 的 token。这意味着，如果下一个 token 前面没有空白符，我们立即开始扫描相关的 token，而不需要显式检查空白符。

然而，这种循环会增加每个扫描出的 token 的开销 —— 它需要分支来判断刚扫描出的 token。更好的方案是，只在我们刚扫描出的 token 有可能是 `Token::WHITESPACE` 的时候才继续这个循环，否则就跳出循环。我们通过将循环本身放在一个单独的[辅助方法](https://cs.chromium.org/chromium/src/v8/src/parsing/scanner-inl.h?rcl=d62ec0d84f2ec8bc0d56ed7b8ed28eaee53ca94e&l=178)中来做到这一点。在这个方法中，我们在确信 token 不会是 `Token::WHITESPACE` 的时候就立即返回。也许这看起来只是一些小变动，但这能减少每一个扫描的 token 的额外开销。这对于标点符号之类的非常短的 token 尤其有用：

![](https://v8.dev/_img/scanner/punctuation.svg)

## 扫描标识符

[标识符](https://tc39.github.io/ecma262/#prod-Identifier)是最复杂同时也最常见的 token，在 JavaScript 中用作变量名（以及其他内容）。标识符以具有 [`ID_Start`](https://cs.chromium.org/chromium/src/v8/src/unicode.cc?rcl=d4096d05abfc992a150de884c25361917e06c6a9&l=807) 属性的 Unicode 字符开头，后跟一串（可选的）具有 [`ID_Continue`](https://cs.chromium.org/chromium/src/v8/src/unicode.cc?rcl=d4096d05abfc992a150de884c25361917e06c6a9&l=947) 属性的字符。查看一个 Unicode 字符是否有 `ID_Start` 或 `ID_Continue` 属性非常耗性能。我们可以通过添加一个从字符到它们的属性的映射作为缓存来稍微加速。

不过，大多数 JavaScript 源代码是用 ASCII 字符编写的。在 ASCII 范围的字符中，只有 `a-z`、`A-Z`、`$` 以及 `_` 是标识符的起始字符。`ID_Continue` 还另外包括 `0-9`。我们通过为 128 个 ASCII 字符构建一个表来加速标识符的扫描。这个表中有标志位，表示一个字符是否是 `ID_Start`、是否是 `ID_Continue` 等。因为我们查找的字符是在 ASCII 范围内，我们可以用一个分支来查看表中相应的标志位，判断字符的属性。在我们找到第一个没有 `ID_Continue` 属性的字符之前，所有的字符都是标识符的一部分。

这篇文章中提到的所有改进都会增加如下所示的标识符扫描的性能差距：

![](https://v8.dev/_img/scanner/identifiers-1.svg)

越长的标识符扫描得越快，这看起来似乎违反直觉。这可能会让你认为增加标识符的长度有利于提升性能。就 MB/s 而言，扫描较长的标识符当然更快，因为我们在非常紧凑的循环中停留了更长的时间，而没有返回给语法分析器。然而，从你的应用的性能的角度来看，你关注的应当是扫描完整的 token 有多快。下图粗略地展示了每秒钟扫描的 token 数量与 token 长度之间的关系：

![](https://v8.dev/_img/scanner/identifiers-2.svg)

这里很明显，使用较短的标识符有利于提升你的应用程序的分析性能：我们可能每秒钟扫描更多的 token。这意味着，那些我们看起来在 MB/s 上以较快的速度分析的位置，有着较低的信息密度，实际上每秒产出的 token 较少。

## 内化缩小化的标识符

所有的字符串字面量和标识符，都会在扫描器和语法分析器的边界上删除重复的数据。如果分析器请求一个字符串或标识符的值，对每个可能的字面量值，它会得到一个唯一的字符串对象。这通常需要哈希表查找。由于 JavaScript 代码常常进行缩小化，V8 为单个 ASCII 字符组成的字符串建立了简单的查找表。

## 关键字

关键字是由语言定义的标识符的特殊子集，例如 `if`、`else` 和 `function`。V8 的扫描器会为关键字返回与标识符不同的 token。在扫描出标识符之后，我们需要识别该标识符是否是关键字。由于 JavaScript 中的所有关键字仅包含小写字母 `a-z`，我们也可以记录标志位来表明一个 ASCII 字符是否是可能的关键字 start 和 continue 字符（类似标识符的 `ID_Start` 和 `ID_Continue` —— 译注）。

如果标志位表明一个标识符可能是关键字，我们通过在这个标识符的第一个字符上进行条件判断，缩减候选关键字的集合。由于关键字的不同的第一个字符数量要多于关键字不同的长度数量，因此这种条件判断可以减少后续分支的数量。对于每个字符，我们基于可能的关键字长度进行条件判断，只在长度也匹配的情况下比较标识符与关键字。

更好的方式是使用一种叫做[完美散列](https://en.wikipedia.org/wiki/Perfect_hash_function)的技术。由于关键字列表是事先确定的，我们可以计算出一个完美散列函数，它对每个标识符只给出至多一个候选关键字。V8 使用 [gperf](https://www.gnu.org/software/gperf/) 来计算这个函数。[结果](https://cs.chromium.org/chromium/src/v8/src/parsing/keywords-gen.h)是由标识符的长度和前两个字符来寻找单个候选关键字。我们在两者长度相等的情况下才会将这个标识符与关键字进行比较。对于标识符不是关键字的情况，这种方法尤其提高了性能，因为我们只需要较少的分支就可以判断出（它不是关键字）。

![](https://v8.dev/_img/scanner/keywords.svg)

## 代理对

如前所述，我们的扫描器工作在一个 UTF-16 编码的字符流上，但是接收的是 Unicode 字符。补充平面中的字符只在标识符 token 中有特殊的含义。如果说这种字符出现在字符串中，它们不会是字符串的结尾。JavaScript 支持单独代理（lone surrogate），它们也会简单地从源码中拷贝过来。出于这个原因，除非绝对必要，最好避免组合代理对，让扫描器直接工作在 UTF-16 码元上，而不是 Unicode 字符上。当我们扫描字符串时，我们不需要寻找代理对，将它们组合，然后当我们存储字符构建字面量的时候再将它们拆开。只剩两种情况下扫描器确实需要处理代理对。在 token 扫描的开始处，只有当我们无法将字符识别为其他任何东西的时候我们才需要[组合](https://cs.chromium.org/chromium/src/v8/src/parsing/scanner-inl.h?rcl=d4096d05abfc992a150de884c25361917e06c6a9&l=515)代理对，看看组合结果是否是一个标识符的开头。类似地，我们需要在标识符扫描的慢速路径中，[组合](https://cs.chromium.org/chromium/src/v8/src/parsing/scanner.cc?rcl=d4096d05abfc992a150de884c25361917e06c6a9&l=1003)代理对来处理非 ASCII 字符。

## `AdvanceUntil`

扫描器和 `UTF16CharacterStream` 之间的接口是有状态的。字符流会记录它在缓冲区中的位置，在每次码元被取走之后将位置递增。扫描器会在返回给请求一个字符的扫描方法之前，先缓冲这个接收到的码元。这个扫描方法会读到已缓冲的字符，并根据字符的值继续执行。这提供了漂亮的分层，但速度相当慢。去年秋天，我们的实习生 Florian Sattler 提出了改进的接口，它保留了分层的好处，同时提供了更快访问流中码元的方法。一个模板化的函数 [`AdvanceUntil`](https://cs.chromium.org/chromium/src/v8/src/parsing/scanner.h?rcl=d4096d05abfc992a150de884c25361917e06c6a9&l=72)（特化参数为扫描帮助函数），会使用流中的每个字符调用帮助函数，直到帮助函数返回 false。这本质上为扫描器提供了直接访问底层数据，而又不破坏抽象的方法。这个方案实际上简化了扫描帮助函数，因为它们不需要处理 `EndOfInput` 了。

![](https://v8.dev/_img/scanner/advanceuntil.svg)

`AdvanceUntil` 对于加快那些需要处理大量字符的扫描函数尤其有用。我们使用它来加速之前提到的标识符，同时还同来加速字符串 [[2]](#fn2) 和注释。

## 结语

扫描的性能是语法分析器性能的基石。我们已经将扫描器调节得尽可能高效了。这导致了全面性的提升，扫描单个 token 的性能提升了约 1.4 倍，字符串 1.3 倍，多行注释 2.1 倍，标识符 1.2-1.5 倍，取决于标识符长度。

然而，我们的扫描器也只能做这么多。作为开发者，你可以通过提升程序的信息密度来进一步提升语法分析的性能。最简单的方法是将你的源代码缩小化，去除不必要的空白符，避免出现不必要的非 ASCII 字符。理想情况下，这些步骤都作为构建流程的一部分自动完成了，那么你就不需要在写代码的时候担心这些了。

* * *

1. `<!--` 是 HTML 注释的开头，而 `<!-` 会被识别为“小于”、“非”、“减”。[↩︎](#fnref1)
    
2. 当前，无法被编码为 Latin1 的字符串和标识符处理代价会较昂贵，因为我们会先尝试将他们缓冲为 Latin1，当遇到一个无法编码为 Latin1 的字符的时候再转化为 UTF-16。[↩︎](#fnref2)

作者：Toon Verwaest ([@tverwaes](https://twitter.com/tverwaes))，可耻的优化者。

[转推这篇文章！](https://twitter.com/v8js/status/1110205101652787200)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
