> * 原文地址：[Why Math.max() is Less Than Math.min() in JavaScript](https://levelup.gitconnected.com/why-math-max-is-less-than-math-min-in-javascript-7aaf2c39ee36)
> * 原文作者：[Dr. Derek Austin 🥳](https://medium.com/@derek_develops)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-math-max-is-less-than-math-min-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-math-max-is-less-than-math-min-in-javascript.md)
> * 译者：
> * 校对者：

# Why Math.max() is Less Than Math.min() in JavaScript

#### Math.max() \< Math.min() === true

#### Surprised? Here’s why JavaScript’s maximum function is less than its minimum function when no arguments are passed.

![Photo by [Brett Jordan](https://unsplash.com/@brett_jordan?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9196/0*NqSH9Eveu-3BTQ2V)

Did you know that `[Math.max()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max)` with no arguments returns a value that is smaller than `[Math.min()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/min)` with no arguments in JavaScript?

```JavaScript
console.log(Math.max() < Math.min()) // true
```

Why is that? Let’s check what the functions return:

```JavaScript
console.log(Math.max()) // -Infinity
```

That’s weird — `[Infinity](https://medium.com/swlh/what-is-infinity-in-javascript-%EF%B8%8F-1faf82f100bc)` is actually the biggest number in JavaScript, along with the values `[Number.MAX_VALUE](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_VALUE)` and `[Number.MAX_SAFE_INTEGER](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER)`.

What does `Math.min()` return with no arguments?

```JavaScript
console.log(Math.min()) // Infinity
```

Again, we have the reverse of what we might expect — `[-Infinity](https://medium.com/swlh/what-is-infinity-in-javascript-%EF%B8%8F-1faf82f100bc)` is the smallest number in JavaScript, along with `[Number.MIN_VALUE](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_VALUE)`.

So why do `Math.min()` and `Math.max()` seem to have it backwards?

The answer is buried in the [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max#Description):

> “`[-Infinity](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Infinity)` is the initial comparant because almost every other value is bigger, that's why when no arguments are given, -`[Infinity](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Infinity)` is returned.
>
> If at least one of arguments cannot be converted to a number, the result is `[NaN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/NaN)`.” — [MDN Docs for `Math.max()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max#Description)

Of course! `Math.max()` is just an implementation of a `for` loop over the parameters (check out [the actual Chrome V8 implementation](https://github.com/v8/v8/blob/cd81dd6d740ff82a1abbc68615e8769bd467f91e/src/js/math.js#L77-L102)).

So, `Math.max()` starts with a search value of `-Infinity`, because any other number is going to be greater than -Infinity.

Similarly, `Math.min()` starts with the search value of `Infinity`:

> “If no arguments are given, the result is `[Infinity](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Infinity)`.
>
> If at least one of arguments cannot be converted to a number, the result is `[NaN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/NaN)`.” — [MDN Docs for `Math.min()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/min#Description)

[The ECMAScript Specification](https://www.ecma-international.org/ecma-262/10.0/index.html#sec-math.max) for `Math.max()` and `Math.min()` also points out that `+0` is considered to be larger than `-0` by these functions:

```JavaScript
console.log(Math.max(+0,-0)) // 0
console.log(Math.min(+0,-0)) // -0
console.log(+0 > -0) // false
console.log(+0 > -0) // false
console.log(+0 === -0) // true
console.log(+0 == -0) // true
console.log(Object.is(+0,-0)) // false
```

That behavior is different than the [`>` greater than and `\<` less than operators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Relational_operators), which consider `-0` [negative zero](https://medium.com/coding-at-dawn/is-negative-zero-0-a-number-in-javascript-c62739f80114) to be equal to `+0` positive zero.

Technically, `-0` negative zero is equal to `0` positive zero according to [the `==` and `===` equality operators,](https://medium.com/better-programming/making-sense-of-vs-in-javascript-f9dbbc6352e3) but not according to `[Object.is()](https://medium.com/coding-at-dawn/es6-object-is-vs-in-javascript-7ce873064719)`.

So, in a sense, `Math.max()` and `Math.min()` are smarter for `-0` negative zero than a naive implementation ([see lines 96–99 in the V8 code](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Relational_operators)).

Like this article? Then you’ll like my article on the fastest way to [find the min and max in a JavaScript array](https://medium.com/coding-at-dawn/the-fastest-way-to-find-minimum-and-maximum-values-in-an-array-in-javascript-2511115f8621) — where I show a method of using `Math.max()` and `Math.min()` that is much faster than using the [`...` spread operator](https://medium.com/coding-at-dawn/how-to-use-the-spread-operator-in-javascript-b9e4a8b06fab):
[**The Fastest Way to Find Minimum and Maximum Values in an Array in JavaScript**
**JavaScript offers several ways to find the smallest and largest numbers in a list, including the built-in Math…**medium.com](https://medium.com/coding-at-dawn/the-fastest-way-to-find-minimum-and-maximum-values-in-an-array-in-javascript-2511115f8621)

Now you know all the quirks of `Math.max()` and `Math.min()`!

Happy Coding! 😊💻😉🔥🙃

![Photo by [DaYsO](https://unsplash.com/@dayso?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6098/0*4LIUeFlJirUg9atL)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
