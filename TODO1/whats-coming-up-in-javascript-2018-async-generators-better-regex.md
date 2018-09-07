> * 原文地址：[What’s Coming Up in JavaScript 2018: Async Generators, Better Regex](https://thenewstack.io/whats-coming-up-in-javascript-2018-async-generators-better-regex/)
> * 原文作者：[Mary Branscombe](https://thenewstack.io/author/marybranscombe/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-coming-up-in-javascript-2018-async-generators-better-regex.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-coming-up-in-javascript-2018-async-generators-better-regex.md)
> * 译者：[MeFelixWang](https://github.com/MeFelixWang)
> * 校对者：[CoderMing](https://github.com/CoderMing)

![](https://cdn.thenewstack.io/media/2018/08/ba3bc5a9-res-3615421_1920-1024x681.jpg)

2018 年 6 月发布的最新年度[ ECMAScript 更新](http://www.ecma-international.org/ecma-262/9.0/index.html)，尽管在常见功能的积压上仍然远远小于 ECMAScript 6，但依然是迄今为止最大的年度版本。

身为 ECMAScript 编辑及微软在 [ECMA TC39 委员会]((https://github.com/tc39))代表的 [Brian Terlson](https://github.com/bterlson) 告诉 The New Stack：这个版本中两个最大的开发者功能是异步生成器和一些期待已久的正则表达式改进，以及 rest/spread 属性。

“异步生成器和迭代器是将异步函数和迭代器结合起来的结果，所以它就像你可以在其中等待的异步生成器或你可以从中得到返回值的异步函数，”他解释道。以前，ECMAScript 允许你编写一个可以输入或等待但不能同时进行两者操作的函数。“这对于在 Web 平台占比越来越大的消费流来说非常方便，尤其是在 Fetch 对象公开流的情况下。”

异步迭代器类似于 Observable 模式，但更灵活。“Observable 是推模型; 一旦你订阅了它，无论你是否准备好，你都会被爆炸式的事件和通知冲击，所以你必须实施缓冲或采样策略来处理干扰，”Terlson 解释道。异步迭代器是一种推拉模型 —— 你请求一个值后发送给你 —— 这对于诸如网络 IO 原语之类的东西更有效。

[Promise.prototype.finally](https://github.com/tc39/proposal-promise-finally) 对异步编程也很有帮助，在一个 promise 状态变为 fulfilled 或 rejected 后，指定一个最终方法来进行清理。

## 更多常规正则表达式

Terlson 对正则表达式的改进感到特别兴奋（其中大部分工作都是由 V8 团队完成的，他们已经完成了这四个主要功能的早期实现），因为这是此语言落后的领域。

“自从 JavaScript 诞生之日起，ECMAScript 正则表达式就没有过显著进步；几乎所有其他编程语言的正则表达式库都比 ECMAScript 的功能高级。“ECMAScript 6 包含了[一些小的更新](http://2ality.com/2015/07/regexp-es6.html)，但他将 ECMAScript 2018 视为“第一次明显改变你如何编写正则表达式的更新”。

[dotAll 标志](https://github.com/tc39/proposal-regexp-dotall-flag)使点字符匹配所有字符，而不再会对匹配一些换行符（比如 n 或 f ）无效。“你不能使用点字符，除非你处于多行模式并且你不关心每行的结束，”他指出。这方面的变通办法创造了一些不必要的复杂的正则表达式，Terlson 期望“每个人都能在正则表达式中使用该模式”。

[命名捕获组](https://github.com/tc39/proposal-regexp-named-groups)与许多其他语言中的命名组类似，你可以在命名正则表达式匹配的字符串中的不同部分，并将其视为对象。“这几乎等同于在你的正则表达式中添加注释，通过赋予它一个名字来解释该组试图捕捉的内容，”他解释道。“这个模式的一部分是月份，这是出生日期......这对于未来其他人维护你的模式真的很有帮助。”

还有其他关于空字符的提案，即告诉正则表达式引擎忽略模式匹配中的空格、换行符以及注释，允许在空格后的行尾添加注释，这种特性可能包含在 ECMAScript 的未来版本中并将进一步提高可维护性。

以前 ECMAScript 有先行断言但没有后行断言。“人们使用了一些技巧，比如反转字符串，然后进行匹配，或一些其他 hacks，”Terlson 指出。这对于查找和替换的正则表达式特别有用。“你看到的并没有成为你匹配的一部分，所以如果你要替换前后任何一边有美元符号的数字，你就可以做到这一点而无需做额外的工作将美元符号重新放回去。”ECMAScript [后行断言](https://github.com/tc39/proposal-regexp-lookbehind)允许像 C# 中那样的可变长度的后行断言，而不仅仅是 Perl 中的固定长度模式。

特别是对于需要支持国际用户的开发人员，允许在正则表达式中使用 [Unicode 属性转义](https://github.com/tc39/proposal-regexp-unicode-property-escapes#ecmascript-proposal-unicode-property-escapes-in-regular-expressions)  `\\p{…}` 和 `\\P{…}` 将使创建 Unicode 可识别的正则表达式变得更加容易。目前，这对开发人员来说是件很麻烦的事。

“Unicode 定义了数字，但这些数字不仅包括基本拉丁语 ASCII 0 到 9，还包括数学数字，粗体数字，大纲数字，花哨的演示数字，表格数字。如果要匹配 Unicode 中的任何数字，则 Unicode 可识别的应用程序必须具有可用的整个 Unicode 数据表。通过添加此功能，你可以将这些全部委托给 Unicode，”他说。如果你想以严格的方式匹配 Unicode 字符，比如说进行表单验证，并且你想做正确的事情而不是告诉人们他们的名称是无效的，这在很多情况下很难做到，但是使用 Unicode 字符类你可以明确指出名称所需的字符范围。已经有了不同语言和脚本的类，所以如果你只想处理希腊语或汉字，完全可以做到。Emoji 正变得越来越普遍。

还有一些新的国际化 API，用于本地化的[日期和时间格式](https://github.com/tc39/proposal-intl-formatToParts)，欧元货币格式和[复数形式](https://github.com/tc39/proposal-intl-plural-rules)，这样可以更轻松地执行本地化标签和按钮等操作。

ECMAScript 2018 扩展了[对象](https://github.com/tc39/proposal-object-rest-spread)和数组对 rest 和 spread 模式的支持（在 React 生态系统中很常见，许多开发人员都没有意识到它还没有完全标准化），Terlson 称之为有超大影响的小功能。rest 和 spread 对于复制和克隆对象很有用，例如，如果你有一个不可变的结构，而你要更改除一个属性之外的所有内容，或者你​​想复制一个对象但添加一个额外的属性。Terlson 指出，这种模式经常用于为选项记录分配默认值。“对于你一直在做的事情来说，这是一个非常好的语法模式。”

Babel 和 TypeScript 等转换器已经支持 ECMAScript 2018 的许多功能。浏览器支持也将随着时间的推移实现，并且所有新功能都已经在 Chrome 的发布版本中（要获得完整的支持矩阵图表，请查看[ ECMAScript 兼容性表](http://kangax.github.io/compat-table/es2016plus/)。）

[![](https://cdn.thenewstack.io/media/2018/08/cf694974-ecmascript.png)](https://cdn.thenewstack.io/media/2018/08/cf694974-ecmascript.png)

ECMAScript 兼容性表检测到的浏览器支持情况。

## 未来发展；ECMAScript 2019

一些有趣的提案尚未达到成为 ECMAScript 标准的一部分所必需的第四阶段，包括对私有字段和方法的声明略有争议的想法，其中包括许多备选提案。

当在 ECMAScript 6 中引入类时，它们是“极小的”，Terlson 解释为“故意在很小[范围]，因为我们将在以后继续处理它们。”私有字段允许开发人员声明可以在类的内部通过名称进行引用的字段，但不能从类的外部访问，”他说。这不只是提供了更好的性能，因为当在类构造函数中声明所有字段时，运行时可以更好地优化对象的处理，但也是语言强制实现隐私，而 TypeScript 中的私有字段则不是这样。与 symbols 不同，你可以使用 get 属性列出对象上的所有 symbols，私有字段将不允许反射。

“库作者正在寻求一种拥有私人状态的方式，以便开发者不能依赖它，”Terlson 解释道。“即使做了他们不应该做的事情，库也不喜欢打断用户。”例如，类中的私有属性将允许库作者避免暴露内部实现细节，如果他们将来可能会修改的话。

BigInt 提案也处于第三阶段。目前，ECMAScript 只有 64 位浮点数类型，但许多平台和 web API 使用 64 位整数 —— 包括[ Twitter 用作推文 ID ](https://dev.twitter.com/overview/api/twitter-ids-json-and-snowflake)的 64 位整数。“你不能再将 JavaScript 中的推文 ID 表示为数字，”Terlson 解释道。“它们必须表示为一个字符串。”BigInt 是一个更通用的提案，用于添加任意精度的整数，而不只是添加 64 位整数。加密 API 和高精度计时器也将利用这一点，Terlson 预计 JIT JavaScript 引擎可能会使用原生 64 位字段来提供大整数以提升性能。

两项提案已经进入第四阶段；让 catch 绑定成为可选项（如果你不需要实际使用变量，就不必再将变量传递给 catch 块），以及进行[小的语法更改](https://github.com/tc39/proposal-json-superset)以处理 JSON 和 ECMAScript 字符串格式之间的不匹配。这些将与其他在未来几个月内取得进展的提案一起进入 ECMAScript 2019。

微软是 The New Stack 的赞助商。

功能图[来自](https://pixabay.com/en/res-the-wind-pbx-current-3615421/) Pixabay。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
