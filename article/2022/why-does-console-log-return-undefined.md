> * 原文地址：[Why does console.log() return ‘undefined’?](https://blog.bitsrc.io/why-does-console-log-return-undefined-e06d44b4d0f8)
> * 原文作者：[Daniel Pericich](https://medium.com/@dpericich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/why-does-console-log-return-undefined.md](https://github.com/xitu/gold-miner/blob/master/article/2022/why-does-console-log-return-undefined.md)
> * 译者：[jjCatherine](https://github.com/xyj1020)、[jaredliw](https://github.com/jaredliw)
> * 校对者：[Isildur46](https://github.com/Isildur46)、[Chorer](https://github.com/Chorer)

# 为什么 console.log() 会返回 ‘undefined’？

如果你有花时间去研究浏览器的控制台或者终端中的 Node.js 命令行工具，你可能会发现一些与常见 JavaScript 方法相关的奇怪行为。如果你在终端中输入 `console.log()`，尽管你希望它只返回一个值，但实际上你会得到两个返回值。

如果你在终端中输入 `console.log(‘hello world’)`，那么第一个打印的值是 `‘hello world’`，这正是我们所期望的，对吧？

然而，如果再往下看一行，就会发现有第二个返回值 `undefined`。我们要求和期望的结果是 `‘hello world’`，为什么还有第二个返回值？

这是因为 REPL 的特性，它是脚本语言用来创建基于沙箱命令的命令行工具。

### 什么是 REPL？

你可能在想 REPL 是什么意思。REPL 是由 Read（读取）、Evaluate（求值）、Print（打印）、Loop（循环）四个单词的首字母组成的。REPL 是一种编码环境工具，也是脚本语言的共同特征。无论使用 Ruby 的 `irb`、JavaScript 的 `node` 还是 Python 的 `python` 访问它，只要进入了 REPL，都能创建一个沙箱环境来探索代码。

这个探索过程包括查看内置的类和函数，构建和测试函数，甚至对简单和复杂的表达式求值。如果你了解数学中的 PEMDAS 概念，那 REPL 将会非常有意义。

REPL 是以直白、常规的方式工作的。首先，他们使用你的 REPL 版本对应的本地语言读取你在当前终端表达式中输入的任何代码。如果你当前使用的是 Node.js 环境，那么 REPL 会将代码读取为 JavaScript。

读取代码后，REPL 就开始对所有的算数表达式、循环结构、字符串、数组、对象的操作以及其它所有可能的操作进行求值。其余的代码应仅包含输出语句，因为任何的数据操作、数据库调用或者其它操作都已经完成了。

一旦主要的求值执行完成，控制台就会打印 REPL 所告知要打印的任何内容。这就是控制台要输出的求值结果，它可以是 JavaScript 的 `console.log()`（或任何形式的 `console.`*），Ruby 的 `puts` 或 `pp`，或 Python 的 `print`。

REPL 最后执行的步骤是循环。但是这个循环跟 for 循环和 while 循环没有任何关系。这里的循环指的是一旦用户输入的所有语句和代码都被读取、求值以及打印出所有信息之后，REPL 会回到初始状态 —— 也就是随时接收输入的状态。因此，输入的代码全部都被 REPL 读取、求值以及打印之后，计算机就会准备好执行更多的操作。

用 REPL 对模型进行概念证明或对 UI 的输出进行检查是非常方便的。REPL 通常对后端的工作非常有帮助，因为在后端的工作中开发人员无法以可视化的方式去确认他们的结果是否符合预期。现在，让我们说回 JavaScript。

### 为什么 Node.js 中的 REPL 是这样的？

现在我们对什么是 REPL 有了更深的理解，让我们继续探讨为什么 `console.log()` 会返回 `undefined`。当我们在浏览器或者终端中调用 `console.log()` 时，实际上是 JavaScript 的 REPL 中调用的。

随着我们对 REPL 是什么以及它们如何工作有了新的理解，我们可以看看 `console.log(“Hello, Daniel!”)` 的执行过程。首先，REPL 会将我们在控制台输入的指令读取为 JavaScript，然后对我们的指令开始求值。在求值的过程中，REPL 总会返回一些结果，例如 `2 + 2` 的和或者修改后的数组。但是在这种情况下，不需要求值，所以最后会返回 `undefined`。

![图一：在 Node.js 的 REPL 中调用 “console.log(“Hello, Daniel!”) 的结果](https://cdn-images-1.medium.com/max/2000/1*oRXhxIJaSy_meLMsIxXjdw.png)

读取和求值都完成后，控制台开始打印我们需要计算机打印的信息。在我们举的例子中，我们告诉 REPL 打印 `“Hello, Daniel!”`，所以 REPL 将其打印到控制台中。在这之后，我们就准备好环回到初始状态，在这个状态下，REPL 可以接受我们的下一组指令。简单明了！

### 总结

现在你应该了解了什么是 REPL，更加具体地说，是你应该明白了 REPL 在 Node.js 中是怎么工作的。我希望你可以运用这些基础知识更加自如地去使用 Node.js 沙盒会话，或者使用对应的 REPL 更快地去学习一门新语言。如果你在使用某个语言的 REPL 期间遇到了什么有趣的事情，欢迎给我留言。

### 引用

* [https://stackoverflow.com/questions/24342748/why-does-console-log-say-undefined-and-then-the-correct-value](https://stackoverflow.com/questions/24342748/why-does-console-log-say-undefined-and-then-the-correct-value)
* [https://codewith.mu/en/tutorials/1.1/repl](https://codewith.mu/en/tutorials/1.1/repl)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
