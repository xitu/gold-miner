> * 原文地址：[On let vs const](https://overreacted.io/on-let-vs-const/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/on-let-vs-const.md](https://github.com/xitu/gold-miner/blob/master/article/2020/on-let-vs-const.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)
> * 校对者：[Gesj-yean](https://github.com/Gesj-yean), [rachelcdev](https://github.com/rachelcdev)

# 关于 let 和 const 的对比

我 [之前的帖子](https://overreacted.io/what-is-javascript-made-of/) 包括了这一段：

> **`let` 和 `const` 和 `var` 的比较**：通常你会想用 `let`。如果你想要禁止这个变量二次赋值，你可以使用 `const`。（一些代码库或者开发者是很教条的，要求你在只有一次赋值的时候使用 `const`。）

这件事很有争议，在 Twitter 和 Reddit 上引发了大量讨论。看起来大多数人的意见（至少是声音最响的意见）是应该**尽可能使用 `const`**，只在必须的时候使用 let，就像 [`prefer-const`](https://eslint.org/docs/rules/prefer-const) 这条 ESLint 规则规定的一样。

在本帖中，我将简短概括我见到的正反论据，以及我个人对此的结论。

## 为什么 `倾向于 const`

* **只用一种方式**：每次在 `let` 和 `const` 之间选择会造成精神负担。像“只要能用就使用 `const`”这样的规则就会让你不再纠结，并且它可以通过一个 linter 实现。
* **重新赋值可能造成 Bug**：在一个较长的函数中，对一个变量重新赋值的过程是很容易被忽略的。这可能造成 bug。特别是在闭包中，`const` 使你确信每次你可以“看见”同一个值。
* **学习修改变量**：JavaScript 初学者经常以为 `const` 意味着不可变。有些人说，学习修改变量的值和变量的重新赋值之间的区别，是非常重要的；而且倾向使用 `const` 迫使你从一开始就面对这种区别。
* **无意义的赋值**：有时候，赋值并没有任何意义。例如对于 React Hooks，你从一个 Hook，比如 useState 中获取的值，像 `useState` 之类，更像是参数。他们只在一个方向上流动。在赋值中看到一个错误帮助你更早学习到 React 数据流相关的知识。
* **性能优势**：有时候有人声称 JavaScript 引擎能让使用 `const` 的代码运行得更快，因为这些变量不会被重新赋值。

## 为什么不 `倾向于 const`

* **失去意图**：如果我们在所有能用的地方都使用 `const`，我们就不知道变量能不能被重新赋值是否 **重要** 了。
* **和不可变搞混**：在每一个为什么你应该倾向于 `const` 的讨论中, 总有人把它和不可变混淆。这并不奇怪，因为修改和赋值都使用 `=` 操作符。人们通常回应说，他们应该 “多学学这门语言”。但是，相反的论据是，如果这个特性主要用于防止新手犯错，却难以被新手理解，它就不是很有帮助。不幸的是，它无法防止修改变量导致的错误，这些错误会跨模块传播，影响到所有人。
* **防止重新声明的压力**：优先使用 `const` 的代码库迫使人们不对有条件赋值的变量使用 `let`。例如，你可能会写 `const a = cond ? b : c` 而不是一个 `if` 判断，哪怕 `b` 和 `c` 分支都很费解，而且给他们取名很尴尬。
* **重新赋值可能不会产生 Bug**：有三种常见的情况，会导致重新赋值产生 bug：作用域特别广（例如模块或巨型的函数），值是一个参数（所以往往想不到它会等于除传入的值以外的值），以及在嵌套函数中使用。但是，很多代码库中，大多数变量不满足上述任何一种情况，而且参数不能被标记为常量。
* **没有性能优势**：我的理解是，JS 引擎已经知道哪些变量只被赋值一次，哪怕你使用 `var` 或 `let`。如果我们坚持推测，也可以推测说额外的检查会 **创造** 性能代价而不是减少它。但是，真的，引擎是很聪明的。

## 我的结论

我不在意。

我可以使用任何在代码库中已经存在的规范。

如果你关心的话，可以使用一个自动检查和修复的 linter，这样，把 `let` 变为 `const` 不会在 code review 时耽误时间。

最后，记住 linter 是为 **你** 服务的。如果一个 linter 规则使你和你的团队烦恼，删除它。它也许不值得。从你自己的错误中学习。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
