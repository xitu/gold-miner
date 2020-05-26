> * 原文地址：[On let vs const](https://overreacted.io/on-let-vs-const/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/on-let-vs-const.md](https://github.com/xitu/gold-miner/blob/master/article/2020/on-let-vs-const.md)
> * 译者：
> * 校对者：

# On let vs const

My [previous post](https://overreacted.io/what-is-javascript-made-of/) included this paragraph:

> **`let` vs `const` vs `var`**: Usually you want `let`. If you want to forbid assignment to this variable, you can use `const`. (Some codebases and coworkers are pedantic and force you to use `const` when there is only one assignment.)

This turned out to be very controversial, sparking conversations on Twitter and Reddit. It seems that the majority view (or at least, the most vocally expressed view) is that one should **use `const` wherever possible,** only falling back to `let` where necessary, as can be enforced with the [`prefer-const`](https://eslint.org/docs/rules/prefer-const) ESLint rule.

In this post, I will briefly summarize some of the arguments and counter-arguments I’ve encountered, as well as my personal conclusion on this topic.

## Why `prefer-const`

* **One Way to Do It**: It is mental overhead to have to choose between `let` and `const` every time. A rule like “always use `const` where it works” lets you stop thinking about it and can be enforced by a linter.
* **Reassignments May Cause Bugs**: In a longer function, it can be easy to miss when a variable is reassigned. This may cause bugs. Particularly in closures, `const` gives you confidence you’ll always “see” the same value.
* **Learning About Mutation**: Folks new to JavaScript often get confused thinking `const` implies immutability. However, one could argue that it’s important to learn the difference between variable mutation and assignment anyway, and preferring `const` forces you to confront this distinction early on.
* **Meaningless Assignments**: Sometimes, an assignment doesn’t make sense at all. For example, with React Hooks, the values you get from a Hook like `useState` are more like parameters. They flow in one direction. Seeing an error on their assignment helps you learn earlier about the React data flow.
* **Performance Benefits**: There are occasional claims that JavaScript engines could make code using `const` run faster due to the knowledge the variable won’t be reassigned.

## Why Not `prefer-const`

* **Loss of Intent**: If we force `const` everywhere it can work, we lose the ability to communicate whether it was **important** for something to not be reassigned.
* **Confusion with Immutability**: In every discussion about why you should prefer `const`, someone always confuses with immutability. This is unsurprising, as both assignment and mutation use the same `=` operator. In response, people are usually told that they should “just learn the language”. However, the counter-argument is that if a feature that prevents mostly beginner mistakes is confusing to beginners, it isn’t very helpful. And unfortunately, it doesn’t help prevent mutation mistakes which span across modules and affect everyone.
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
