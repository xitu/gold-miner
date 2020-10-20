> * 原文地址：[Brief History of JavaScript](https://roadmap.sh/guides/history-of-javascript)
> * 原文作者：[Kamran Ahmed](https://twitter.com/kamranahmedse)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/history-of-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/history-of-javascript.md)
> * 译者：[Pingren](https://github.com/Pingren)
> * 校对者：[Chorer](https://github.com/Chorer)，[PingHGao](https://github.com/PingHGao)

# JavaScript 简史

> JavaScript 的起源以及这些年的发展情况

大约十年前<sup><a name="noteref1" href="#note1">[1]</a></sup>，Jeff Atwood（Stackoverflow 创始人）断言 JavaScript 将会是未来的方向，并创造了 “Atwood 定律”：**任何可以使用 Javascript 编写的程序，最终都会由 Javascript 编写**。十年后的今天，这个断言相比之前更加可信了。JavaScript 的应用范围不断扩大。

### JavaScript 发布

JavaScript 最初由 NetScape 的 [Brendan Eich](https://twitter.com/BrendanEich) 创造，并在 1995 年 Netscape 的闻稿中首次发布。它有着非同寻常的命名历史：首先由创造者命名为 `Mocha`，接着被重命名为 `LiveScript`。1996 年，在发布大约一年之后，NetScape 希望能够蹭蹭 Java 社区的热度（虽然 JavaScript 与 Java 毫无关系），因此决定再将其重命名为 JavaScript，并发布了支持 JavaScript 的 Netscape 2.0 浏览器。

### ES1、ES2 和 ES3

1996 年，Netscape 决定将 JavaScript 提交到 [ECMA 国际](https://en.wikipedia.org/wiki/Ecma_International)，期望将其标准化。第 1 版标准规范在 1997 年发布，同时该语言也被标准化了。在首次发布之后，`ECMAScript` 的标准化工作持续进行，不久之后，发布了两个新的版本：1998 年的 ECMAScript 2 和 1999 年的 ECMAScript 3。

### 十年沉寂和 ES4

1999 年发布 ES3 之后，官方标准出现了十年的沉寂，这期间没有任何变化。第 4 版标准起初有一些进展，部分被讨论的特性有类、模块、静态类型、解构等等。它本来定在 2008 年发布，但是由于关于语言复杂度的不同政治意见<sup><a name="noteref2" href="#note2">[2]</a></sup>而被废弃。但是，浏览器厂商不停引入语言的扩展，这让开发者大伤脑筋 —— 他们只能添加 polyfill<sup><a name="noteref3" href="#note3">[3]</a></sup> 来解决不同浏览器之间的兼容性问题。

### 从沉寂到 ES5

Google、Microsoft、Yahoo 和其余 ES4 的争论者最终走到了一起，决定在 ES3 之上创造一个小范围的更新，并暂时命名为 ES3.1。但是整个团队仍旧关于 ES4 该包含什么内容而争论不休。终于，在 2009 年，ES5 发布了，主要修复了兼容性和安全问题等。但是它并没有翻起多大浪花 —— 经过了数年时间后浏览器厂商才完全遵循了相关标准，许多开发者在不知道 “现代” 标准的情况下依旧使用 ES3。

### ES6 —— ECMASript 2015 发布

在 ES5 发布数年之后，事情开始有了转机。TC39（ECMA 国际之下负责 ECMAScript 标准化的委员会）持续进行下一版本的标准化的工作，该版本的 ECMAScript（ES6）起初命名为 ES Harmony<sup><a name="noteref4" href="#note4">[4]</a></sup>，在最终发布时被命名为 ES2015。ES2015 添加了许多重要的特性和语法糖以便于编写复杂的程序。部分 ES6 提供的特性包括了类、模块、箭头函数、加强的对象字面量、模板字符串、解构、默认参数 + Rest 参数 + Spread 操作符、Let 和 Const 语法、异步迭代器 + for..of、生成器、集合 + 映射、Proxy、Symbol、Promise、math + number + string + array + object 的 API [等等](http://es6-features.org/#Constants)<sup><a name="noteref5" href="#note5">[5]</a></sup>。

浏览器对 ES6 的支持依旧十分有限，但是开发者只需要编写 ES6 代码并将其转译至 ES5，就可以使用 ES6 的所有特性。随着第 6 版 ECMAScript 的发布，TC39 决定以每年更新的模式来发布 ECMAScript 的更新，这样新特性就可以在通过时尽快地加入标准，不需要等待完整的规范起草和通过 —— 因此第 6 版 ECMAScript 在 2015 年 6 月发布前，被命名为 ECMAScript 2015 或 ES2015。并且之后的 ECMAScript 版本发布定于每年 6 月。

### ES7 —— ECMASript 2016 发布

在 2016 年 6 月，第 7 版 ECMAScript 发布了。由于 ECMAScript 变成了年更模式，ECMAScript 2016（ES2016）相对来说没有太多新内容。ES2016 只包含了两个新特性：

* 指数运算符 `**`
* `Array.prototype.includes`

### ES8 —— ECMAScript 2017 发布

第 8 版 ECMAScript 在 2017 年 6 月发布。ES8 主要的亮点在于增加了异步函数，以下是 ES8 新特性的列表：

* `Object.values()` 和 `Object.entries()`
* 字符串填充 比如 `String.prototype.padEnd()` 和 `String.prototype.padStart()`
* `Object.getOwnPropertyDescriptors`
* 在函数参数定义和函数调用中使用尾后逗号
* 异步函数

### 什么是 ESNext

ESNext 是一个动态的名字，指当前的 ECMAScript 版本。例如，在本文编写的时候，`ES2017` 或 `ES8` 是 `ESNext`。

### 未来会发生什么

自从 ES6 发布后，[TC39](https://github.com/tc39) 极大提高了他们的效率。 现在 TC39 以 Github 组织的形式运行，在上面有许多关于下一版的 ECMAScript 新特性和语法的[提议](https://github.com/tc39/proposals)。任何人都可以[发起提议](https://github.com/tc39/proposals)，因此开发者社区可以更多地参与进来。在正式形成规范前，每个提议都会经过[四个发展阶段](https://tc39.github.io/process-document/)。

这差不多就是全部内容了，欢迎在评论区留下你的反馈。以下是原始语言规范的链接：[ES6](https://www.ecma-international.org/ecma-262/6.0/)、[ES7](https://www.ecma-international.org/ecma-262/7.0/) 和 [ES8](https://www.ecma-international.org/ecma-262/8.0/)。

1. 译者注：本文写于 2017 年，所以十年前是 2007 年。<a name="note1" href="#noteref1">↩︎</a>
2. 译者注：技术层面的分歧以及商业政治都是 ES4 失败的原因，知乎上曾经有过相关的[讨论](https://www.zhihu.com/question/24715618)。<a name="note2" href="#noteref2">↩︎</a>
3. 译者注：Web 开发中，polyfill 指用于实现浏览器并不支持的原生 API 的代码。<a name="note3" href="#noteref3">↩︎</a>
4. 译者注：Harmony 有和谐，协调的意思。<a name="note4" href="#noteref4">↩︎</a>
5. 译者注：如果你感兴趣，可以使用[这个中文教程](https://zh.javascript.info/)学习这些特性。<a name="note5" href="#noteref5">↩︎</a>

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。