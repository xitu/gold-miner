> * 原文地址：[On let vs const](https://overreacted.io/on-let-vs-const/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/on-let-vs-const.md](https://github.com/xitu/gold-miner/blob/master/article/2020/on-let-vs-const.md)
> * 译者：
> * 校对者：

# 关于 let 和 const 的对比

我 [之前的帖子](https://overreacted.io/what-is-javascript-made-of/) 包括了这一段:

> **`let` 和 `const` 和 `var` 的比较**: 通常你会想用 `let`。如果你想要防止给这个变量赋值，你可以使用 `const`。 （一些代码库或者开发者是很教条的，要求你在只有一次赋值的时候使用 `const`。）

这件事很有争议，在 Twitter 和 Reddit 上引发了大量讨论。看起来大多数人的意见（至少是声音最响的意见）是应该**尽可能使用 `const`** ，只在必须的时候使用 let，就像 [`prefer-const`](https://eslint.org/docs/rules/prefer-const) 这条 ESLint 规则规定的一样。

在本帖中，我将简短概括我见到的正反论据，以及我个人对此的结论。

## 为什么 `倾向于 const`

* **只有一种方式**: 每次在 `let` 和 `const` 之间选择会造成精神负担。像 “只要能用就使用 `const`” 这样的规则使你停止思考这个问题。它可以通过一个 linter 实现。
* **重新赋值可能造成 Bug**: 在较长的函数中，你可能漏掉一个变量的赋值。这可能造成bug。特别是在闭包中，`const` 使你确信每次你可以“看见”同一个值。
* **学习修改变量**: 新学  JavaScript 的人们经常以为 `const` 意味着不可变。有些人说，学习修改变量的值和变量的重新赋值之间的区别，是非常重要的；而且倾向使用 `const` 迫使你从一开始就面对这种区别。
* **无意义的赋值**: 有时候，赋值并没有任何意义。例如对于 React Hooks，你从 Hook 中获取的值，像 `useState` 之类，更像是参数。他们只在一个方向上流动。在赋值中看到一个错误帮助你更早学习到 React 数据流相关的知识。
* **性能优势**: 有时候有人声称 JavaScript 引擎能让使用 `const` 的代码运行得更快，因为这些变量不会被重新赋值。

## 为什么不 `倾向于 const`

* **失去意图**: 如果我们在所有能用的地方都使用 `const`，我们就丧失了表达某些东西不被重新赋值是否 **重要** 的能力。
* **Confusion with Immutability**: 在每一个为什么你应该倾向于 `const` 的讨论中, someone always confuses with immutability. This is unsurprising, as both assignment and mutation use the same `=` operator. In response, people are usually told that they should “just learn the language”. However, the counter-argument is that if a feature that prevents mostly beginner mistakes is confusing to beginners, it isn’t very helpful. And unfortunately, it doesn’t help prevent mutation mistakes which span across modules and affect everyone.
* **Pressure to Avoid Redeclaring**: A `const`-first codebase creates a pressure to not use `let` for conditionally assigned variables. For example, you might write `const a = cond ? b : c` instead of an `if` condition, even if both `b` and `c` branches are convoluted and giving them explicit names is awkward.
* **Reassignments May Not Cause Bugs**: There are three common cases when reassignments cause bugs: when the scope is very large (such as module scope or huge functions), when the value is a parameter (so it’s unexpected that it would be equal to something other than what was passed), and when a variable is used in a nested function. However, in many codebases most variables won’t satisfy either of those cases, and parameters can’t be marked as constant at all.
* **No Performance Benefits**: It is my understanding that the engines are already aware of which variables are only assigned once — even if you use `var` or `let`. If we insist on speculating, we could just as well speculate that extra checks can **create** performance cost rather than reduce it. But really, engines are smart.

## My Conclusion

I don’t care.

I would use whatever convention already exists in the codebase.

If you care, use a linter that automates checking and fixing this so that changing `let` to `const` doesn’t become a delay in code review.

Finally, remember that linters exist to serve **you**. If a linter rule annoys you and your team, delete it. It may not be worth it. Learn from your own mistakes.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
