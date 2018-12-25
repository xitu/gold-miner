> * 原文地址：[Misunderstanding ES6 Modules, Upgrading Babel, Tears, and a Solution](https://blog.kentcdodds.com/misunderstanding-es6-modules-upgrading-babel-tears-and-a-solution-ad2d5ab93ce0)
> * 原文作者：[Kent C. Dodds](https://blog.kentcdodds.com/@kentcdodds?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/misunderstanding-es6-modules-upgrading-babel-tears-and-a-solution.md](https://github.com/xitu/gold-miner/blob/master/TODO1/misunderstanding-es6-modules-upgrading-babel-tears-and-a-solution.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[SinanJS](https://github.com/SinanJS)，[caoyi0905](https://github.com/caoyi0905)

# 误解 ES6 模块，升级 Babel 的一个解决方案（泪奔）

![](https://cdn-images-1.medium.com/max/2000/1*2WG0tvoYhuwTt25y5B8IlA.png)

说多了都是泪...

在 [2015 年 10 月 29 号](http://babeljs.io/blog/2015/10/29/6.0.0/)，[Sebastian McKenzie](https://medium.com/@sebmck)、[James Kyle](https://medium.com/@thejameskyle) 以及 Babel 团队的其他成员，发布了一个面向各地前端开发者的大型版本：Babel 6.0.0。太棒了，因为它不再是一个转译器，而是一个可插拔的 JavaScript 工具平台。作为一个社区，我们只触及了它能力的表面，我对 JavaScript 工具的未来感到兴奋（谨慎乐观态度）。

所有这些都说明了，Babel 6.0.0 是一个非常重大的变革版本。一开始可能有点不稳定。因此升级也并不容易，需要学习。这篇文章不一定会讨论如何 Babel。我只想讨论我从自己代码中学会的内容 —— 当 Babel 修复了我的严重依赖问题时... 在尝试将 Babel 5 升级到 Babel 6 之前，希望你可以去阅读以下内容：

* [**清理 Babel 6 生态系统**：随着 Babel 6 的近期发布，与旧版本相比，每一个版本都发生了戏剧性的变化...](https://medium.com/p/c7678a314bf3 "https://medium.com/p/c7678a314bf3")

* [**快速指南：如何将 Babel 5.x 更新至 6.x：最近 Babel 6 将会发布**。](https://medium.com/p/d828c230ec53 "https://medium.com/p/d828c230ec53")

#### ES6 模块

如果我可以正确理解 ES6 模块规范，对我来说，升级就不会那么困难了。Babel 5 允许滥用 **export** 和 **import** 语句，Babel 6 解决了这个问题。一开始我以为这可能是 Bug。我在 [Stack Overflow](http://stackoverflow.com/q/33505992/971592) 和 [Logan Smyth](https://medium.com/@loganfsmyth) 上提问这个问题，反馈的信息告诉我，我从根本上误解了 ES6 模块，而且 Babel 5 助长了这种误解（编写一个转换器很困难）。

#### 当前危机

起初，我不太明白 Logan 的意思，但当我有时间全身心投入我的应用升级时，发生了这些事情：

> 我疯了么？这是无效的 ES6 么？export default { foo: 'foo', bar: 'bar', }
> 
> — [@kentcdodds](https://twitter.com/kentcdodds/status/671817302430515200)

[Tyler McGinnis](https://medium.com/@tylermcginnis)、[Josh Manders](https://medium.com/@joshmanders) 和我在这个线程上测试了一下。这可能很难理解，但我意识到问题不是将对象默认导出，而是如何像预期那样可以导入该对象。

我总是可以导出一个对象作为默认值，然后从该对象中通过解构的方式获得我所需要的部分（字段），如下所示：

```
// foo.js
const foo = {baz: 42, bar: false}
export default foo

// bar.js
import {baz} from './foo'
```

因为 Babel 5 的转换是导出默认语句，所以它允许我们这样做。然而，根据规范，这在技术上是不正确的，这也是为什么 Babel 6（正确地）删除了该功能，因为它的能力实际上是在破坏我在工作中应用程序的 200 多个模块。

当我回顾 [Nicolás Bevacqua 的](https://twitter.com/nzgb)[博客](https://ponyfoo.com/articles/es6)时，我终于明白了它的工作原理。

> 当然，也要感谢 [@nzgb](http://twitter.com/nzgb) 在 ES6 上的 350 个令人惊讶的要点，因为它非常清晰[https://ponyfoo.com/articles/es6#modules](https://ponyfoo.com/articles/es6#modules)[@rauschma](http://twitter.com/rauschma)。
>
> — [@kentcdodds](https://twitter.com/kentcdodds/status/671831027787038721)

当我读到 [Axel Rauschmayer](https://medium.com/@rauschma) 的[博客](http://www.2ality.com/2014/09/es6-modules-final.html)时，我发现为什么我一直在做内容无效。

> 我想感谢 [@rauschma](http://twitter.com/rauschma) 用 ES6 模块将我从早期中年危机中拯救出来。我可能对这事太专注了。。。
>
> — [@kentcdodds](https://twitter.com/kentcdodds/status/671830544129265664)

基本思想是：ES6 模块应该是静态可分析的（运行时不能更改该导出/导入），因此不能是动态的。在上述示例中，我可以在运行时更改 **foo** 的对象属性，然后我的 **import** 语句就可以导入该动态属性，就像这样：

```
// foo.js
const foo = {}
export default foo
somethingAsync().then(result => foo[result.key] = result.value)

// bar.js
import {foobar} from './foo'
```

我们将假设 **result.key** 是 ‘foobar’。在 CommonJS 中这很好，因为 require 语句发生在运行时（在模块被需要的时候）：

```
// foo.js
const foo = {}
module.exports = foo
somethingAsync().then(result => foo[result.key] = result.value)

// bar.js
const {foobar} = require('./foo')
```

> 可是，因为 ES6 规范规定导入和导出必须是静态可分析的，所以你不可能在 ES6 中完成这种动态行为。

这也是 Babel 做出改变的**原因**。这样做是不太可能的，但这也是件好事。

#### 这意味着什么？

**用文字来描述这个问题确实比较困难，所以我希望一些代码的示例与对比会有指导意义**。

我遇到的问题是，我将 ES6 **exports** 与 CommonsJS **require** 组合在一起。我会这样做：

```
// add.js
export default (x, y) => x + y

// bar.js
const three = require('./add')(1, 2)
```

Babel 改变后，我有三个选择：

**选择 1：** 默认 require

```
// add.js
export default (x, y) => x + y

// bar.js
const three = require('./add').default(1, 2)
```

**选择 2：**100% 的 ES6 模块

```
// add.js
export default (x, y) => x + y

// bar.js
import add from './add'
const three = add(1, 2)
```

**选择 3：**100% 的 CommonJS 

```
// add.js
module.exports = (x, y) => x + y

// bar.js
const three = require('./add')(1, 2)
```

#### 我如何修复它？

几小时后我开始运行构建并通过了测试。不同的场景，我有两种不同的方法：

1.  我将导出更改为 CommonJS（**module.exports**），而不是 ES6（**export default**），这样我就可以像一直做的那样继续 require。

2.  我写了一个复杂的正则表达式来查找并替换（应该使用一个 codemod）那些将其他 require 语句从 **require(‘./thing’)** 转向 require(‘./thing’).default** 的改变。

它工作的很完美，最大的挑战就是理解 ES6 模块规范是如何工作的，Babel 如何将其转换到 CommonJS，从而实现交互操作。一旦我把问题弄清楚了，遵循这一规则来升级我的代码就变成了超简单的工作。

#### 建议

尽量避免混合 ES6 模块和 CommonsJS。我个人而言，会尽量使用 ES6。首先，我将它们混合在一起的原因之一是我可以执行单行的 require，并立即使用所需的模块（比如 **require(‘./add’)(1, 2)**）。但这真的不是一个足够大的好处（就我个人看来）。

如果你觉得必须将它们组合起来，可以考虑使用以下 Babel 插件/预置之一：

* [**babel-preset-es2015-node5**：NPM 是 JavaScript 的包管理器](https://www.npmjs.com/package/babel-preset-es2015-node5 "https://www.npmjs.com/package/babel-preset-es2015-node5")

* [**babel-plugin-add-module-exports**：NPM 是 JavaScript 的包管理器](https://www.npmjs.com/package/babel-plugin-add-module-exports "https://www.npmjs.com/package/babel-plugin-add-module-exports")

* * *

#### 结论

所有这些真正的教训是，我们应该明白事情是如何运作的。如果我理解 ES6 模块规范实际上是如何运作的，我就可以节省大量时间。

你可能会受益于这个 Egghead.io 课程，我演示了如何从 Babel 5 升级到 Babel 6：

[https://egghead.io/lessons/angularjs-updating-babel-5-to-6](https://egghead.io/lessons/angularjs-updating-babel-5-to-6)

另外，记住，没有任何人是完美的，我们都在这里学习 :-) [Twitter](https://twitter.com) 上见

![](https://cdn-images-1.medium.com/max/800/1*Sa8ryLk8EgpsePcRkPfd6w.png)

* * *

#### 附录

**更多示例**：

在对 Babel 进行更改之前，有一个像这样的 require 语句：

```
import add from './add'
const three = add(1, 2)
```

但在 Babel 发生变化之后，Require 语句现在变得就像这样：

```
import * as add from './add'
const three = add.default(1, 2)
```

我想，导致这个问题的原因是，add 变量不再是默认导出，而是一个拥有所有命名导出以及 default export 的对象（在默认键下）。

**命名导出：**

值得注意的是，你可以使用命名导出，我的建议是在工具模块中那么做。这允许你在 import 语句（**警告，尽管由于前面的静态分析原因，他看起来并不是真正的析构**）中执行类似于析构的语法。因此，你可以那么做：

```
// math.js
const add = (x, y) => x + y
const subtract = (x, y) => x - y
const multiply = (x, y) => x * y
export {add, subtract, multiply}

// foo.js
import {subtract, multiply} from './math'
```

在 [tree shaking](http://www.2ality.com/2015/12/webpack-tree-shaking.html) 的情况下，这令人兴奋，还很棒。

个人而言，我通常建议对于组件（像 React 组件或 Angular 服务）使用 default export（你知道自己要导入的待定内容，单文件，单组件 😀）。但对于工具模块，通常有各种可以独立使用的纯函数。这是命名导出的一个很好的用例。

#### 还有一件事

如果你觉得这很有趣，那么你应该会喜欢[查看我博客的其他内容](https://blog.kentcdodds.com)并且[订阅我的最新内容 💌](https://kcd.im/news)（信息在发送到电子邮件 2 周后，会发布到我的博客）。

[TestingJavaScript.com](https://testingjavascript.com) 可以学习更好、更高效的方法来测试任何 JavaScript 程序。

感谢 [Tyler McG](https://medium.com/@tylermcginnis?source=post_page)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
