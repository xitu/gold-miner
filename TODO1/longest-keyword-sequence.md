> * 原文地址：[What's the longest keyword sequence in Javascript?](https://gist.github.com/lhorie/c0d9fd9b2aa215f4984f3ce1c8fd01bf)
> * 原文作者：[Leo Horie](https://mithril.js.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/longest-keyword-sequence.md](https://github.com/xitu/gold-miner/blob/master/TODO1/longest-keyword-sequence.md)
> * 译者：[xionglong58](https://github.com/xionglong58)
> * 校对者：[Endone](https://github.com/Endone), [Jingyuan0000](https://github.com/Jingyuan0000)

# Javascript 中最长的关键字序列长什么样子？

最近有几个关于使用 Javascript 编写最长关键字序列的挑战。

* https://twitter.com/bterlson/status/1093624668903268352
* https://news.ycombinator.com/item?id=19102367

但问题是：

* 这些解决方案使用了非关键字标记(null、true、false 实际上是[字面量](https://tc39.github.io/ecma262/#prod-Literal)，而不是[关键字](https://tc.github.io/ecma262/#prod-Keyword))
* 其中一个解决方案有些说不通

让我们试试能不能做的更好。

（但是我们首先的回顾一些基础规则）

## 规则

1) 代码必须能作为有效的 Javascript 进行解析和运行。不能忽略 [early errors](https://tc39.github.io/ecma262/#early-error)
2) 只允许使用[关键字](https://tc39.github.io/ecma262/#sec-keywords)
3) 除小写字母外，其它唯一允许的字符是空格
4) 不能在序列中重复使用一个关键字
5) 您可以根据需要添加尽可能多的前同步码和后同步码

## 额外挑战

6) 关键字之间允许换行
7) 允许使用类似关键字的标记

## 进入正题

[@arjunb_msft](https://twitter.com/arjunb_msft) 提出的最长 15 个关键字的程序

```js
function *f() {
  if (1);
  else do return yield delete true instanceof typeof void new class extends false in this {}; while (1)
}
```

不幸的是，他的方法里使用了保留字 `true` 和 `false`，而两者实际上不是关键字。在 Chrome 中运行程序也会抛出一个错误：“Uncaught SyntaxError: Unexpected token in”。

[@bluepnume](https://news.ycombinator.com/user?id=bluepnume) 提出 15 个关键字的方案是：

```js
async function* foo() {
  return yield delete void await null in this instanceof typeof new class extends async function () {} {}
}
```

这段程序可以在 Chrome 中运行，但是程序中使用了 `null`，这也不是一个关键字。

虽然有些卖弄，如果我们从第二个解决方案中剔除 `null`，并结合第一个解决方案，可以得到一个不同的 15 个关键字长度的解决方案：

```js
async function* foo() {
  if (0);
  else do return yield delete void await this instanceof typeof new class extends async function
  () {} {}; while (0)
}
```

哦耶！

## 更有趣的在这儿

虽然这样做没什么意思，但卖弄知识却很有趣。

但不用担心，因为在下面的讨论中 [Bterlson](https://twitter.com/bterlson/status/1093651943325483008) 作了这样的补充:

> `this`、`null` 和 `undefined` 可以认为是关键字，即使它们在技术上不是关键字。这使得比赛更有趣（加上编辑们把它们标记成关键字，所以这么说也行得通）

从技术层面讲，`this` 实际上是一个关键字。但是，Bterlson 对 `null` 和 `undefined` 不是关键字的认定却是正确的。

在余下部分，我们可以看到 `true` 和 `false` 也被当作关键字使用。这就给我们带来了一个问题：如果可以使用非关键字标记，那么对于这个挑战，哪些标记更合适？

`null`、`true` 和 `false` 的共同点是它们都是只包含字母的字面量（显然，包含字符和数字的字面量是不允许的）。

由于可以使用 null 字符和 boolean 字符，我们可以轻松地复现出先前的序列，并构建 17 个单词长度的序列：

```js
async function* foo() {
  if (0);
  else do return yield await delete void typeof null instanceof this in new class extends async function () {} {}; while (0);
}
```

那 `undefined` 呢？它实际上是一个标识符。如果允许 ASI，那我们就可以使用任意标识符去构造一个无限序列，但这就索然无味了，也失去了挑战的乐趣。

```js
a
b
c
// boooring
```

我倒认为这项挑战的意义在于仅使用**类似**关键字的标记完成挑战（即使这些类似关键字的词在技术层面不能算作规范的关键字）。

下面是一些看起来像关键字但实际上不是关键字的标记：

```js
let x
for (foo of bar) {}
class { static foo() {} }
import {foo as bar} from 'baz'
{get foo() {}, set foo() {}}
```

如果你不喜欢仔细研究编程语言诸多的规范，而且不能一眼看出哪些标记是关键字，哪些不是关键字，那么下面的标记都可以当作是关键字：`let`、`of`、`static`、`as`、`from`、`get`、`set`。它们看起来也确实像关键字。

我们可能认为不可以往上面的列表中添加 `NaN` 和 `Infinity` 之类的东西，是因为它们与 `undefined` 属于同一个类型，都是标识符（标识符总是指向相同的值），也可能是由于只允许使用小写字符。不管怎样，我们将它们排除在外。我们也应该排除 `atguments`，因为在语法规范中它没有作为标记出现，因此它实际上只是一个 magic 变量，而不是关键字。

另一个我们需要排除是 `new.target`，因为它中间有一个“.”。

一些标记例如 `enum` 和 `public` 是保留字，它们看起来非常像关键字，特别是如果你熟悉像 Java 这样的语言。问题是，它们在语法中几乎处处都会自动变成语法错误，所以即使我们允许使用它们，也不能真正地使用它们...

```js
// the party poopers

let enum // SyntaxError
interface Bar {} // SyntaxError
package Baz; // SyntaxError
class {
  private foo() {} // SyntaxError
}
```

既然我们已经理清了规则，我们接下来能做什么呢？

当然有很多啦

由于一贯的向后兼容性问题，在某些情况下，许多“关键字” 充当...呃，不能称它们为关键词。我们之前说过滥用 ASI 和标识符很无聊，但你知道吗？在 Javascript 他们却是有效的语法。

```js
var undefined
typeof let
```

这当然不是无聊的，而且非常有希望，所以以娱乐的名义，我们必须允许它。

最后还有一个小细节要谈。虽然上面的代码片段很有趣，而且让人眼花缭乱，但它有一个问题：它跨越了两行。很不幸，但我们需要 ASI 将这两个语句分开，所以我们无法将它们放在同一行。

或者这样做：

输入一个段落分隔符（`\u2029`），如果正确呈现，它看起来如下：<code></code>

什么都看不见？这就对了！这是一个**隐形变量**。

现在，有了上面的知识储备，我们可以提出自己的解决方案：

```js
async function* foo() {
  from: set: while (0) {
    if (0)
    throw as  else this  null  continue from  false  break set  true  var let  debugger  do return yield await delete void typeof get instanceof static in new class of extends async function undefined
    () {} {}; while (0);
  }
}
```

你没看错，这就是在 Chrome 上解析和运行有效的 Javascript 程序。它是在一行中有 **32 个关键字的序列！**

当然，并不是所有 32 个词都是关键字，这可能是 ASI 有史以来最严重的滥用，但是，这仍然有挑战意义。另外，我很开心，这才是最重要的！

那么，你觉得呢？你能做一个更长的序列吗？你能弄明白为什么这在语法上是有效的吗？这是作弊吗？Gists [译者注：原文发布在 gist 上]是有史以来最被滥用的博客平台吗？下面评论！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
