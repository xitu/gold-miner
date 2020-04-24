> * 原文地址：[Why Math.max() is Less Than Math.min() in JavaScript](https://levelup.gitconnected.com/why-math-max-is-less-than-math-min-in-javascript-7aaf2c39ee36)
> * 原文作者：[Dr. Derek Austin 🥳](https://medium.com/@derek_develops)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-math-max-is-less-than-math-min-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-math-max-is-less-than-math-min-in-javascript.md)
> * 译者：[zhanght9527](https://github.com/zhanght9527)

# 在 JavaScript 中为什么 Math.max() 会比 Math.min() 小？

![图片来自 [Brett Jordan](https://unsplash.com/@brett_jordan?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9196/0*NqSH9Eveu-3BTQ2V)

> **Math.max() \< Math.min() === true**

惊讶吗？这就是为什么在不传递参数时，JavaScript 中取最大值函数小于取最小值函数的原因。

你知道在 JavaScript 中 [`Math.max()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max) 不传参数返回的值要比 [`Math.min()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/min) 不传参数返回的值小的原因吗？

```JavaScript
console.log(Math.max() < Math.min()) // true
```

为什么会这样？让我们检查一下这个函数返回了什么：

```JavaScript
console.log(Math.max()) // -Infinity
```

很奇怪 —— 在 JavaScript 中 [`Infinity`](https://medium.com/swlh/what-is-infinity-in-javascript-%EF%B8%8F-1faf82f100bc) 实际上是数值最大的数，还有 [`Number.MAX_VALUE`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_VALUE) 和 [`Number.MAX_SAFE_INTEGER`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MAX_SAFE_INTEGER).

那么 `Math.min()` 不带参数会返回什么呢？

```JavaScript
console.log(Math.min()) // Infinity
```

又一次，我们所期待的恰恰相反 —— 在 JavaScript 中 [`-Infinity`](https://medium.com/swlh/what-is-infinity-in-javascript-%EF%B8%8F-1faf82f100bc) 应该是数值最小的数，还有 [`Number.MIN_VALUE`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/MIN_VALUE).

那么为什么 `Math.min()` 和 `Math.max()` 实际的值和我们预期的会相反呢？

答案就藏在 [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max#Description) ：

> “[`-Infinity`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Infinity) 是初始比较项，因为几乎所有其他值都比它更大，这就是为什么没有给出参数的时候，会返回 -[`Infinity`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Infinity)。
>
> 如果至少有一个参数让其不能转换为一个数字，那么结果将是 [`NaN`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/NaN).” — [`Math.max()` 在 MDN 中的文档](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/max#Description)

当然了！ `Math.max()` 只是一个基于 `for` 循环的参数实现 （看看 [Chrome V8 的实现](https://github.com/v8/v8/blob/cd81dd6d740ff82a1abbc68615e8769bd467f91e/src/js/math.js#L77-L102)）。

因此，`Math.max()` 会从 `-Infinity` 开始搜索，因为任何其他数字都比 `-Infinity` 大。 

同样，`Math.min()` 会从 `Infinity` 开始搜索：

> “如果没有传任何参数，那么将返回 [`Infinity`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Infinity)。
>
> 如果至少有一个参数不能转换为数字，那么将返回 [`NaN`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/NaN)。” — [MDN Docs for `Math.min()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/min#Description)

[ECMAScript 规范](https://www.ecma-international.org/ecma-262/10.0/index.html#sec-math.max) 中对于 `Math.max()` 和 `Math.min()`也指出，通过这些函数，`+0` 被认为大于 `-0`：

```JavaScript
console.log(Math.max(+0,-0)) // 0
console.log(Math.min(+0,-0)) // -0
console.log(+0 > -0) // false
console.log(+0 > -0) // false
console.log(+0 === -0) // true
console.log(+0 == -0) // true
console.log(Object.is(+0,-0)) // false
```

这种行为不同于 [`>` 大于和 `\<` 小于运算符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Relational_operators)，后者认为 `-0` [负零](https://medium.com/coding-at-dawn/is-negative-zero-0-a-number-in-javascript-c62739f80114) 等于 `+0` 正零。

从技术上讲，根据 [`==` 和 `===` 相等运算符](https://medium.com/better-programming/making-sense-of-vs-in-javascript-f9dbbc6352e3) `-0` 负零是和 `0` 正零相等的，而不是根据 [`Object.is()`](https://medium.com/coding-at-dawn/es6-object-is-vs-in-javascript-7ce873064719)。

因此，在某种意义上，`Math.max()` 和 `Math.min()` 比 `-0` 负零单纯的实现更加地优雅（[参见V8代码中的第 96-99 行](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Comparison_Operators#Relational_operators)）。

喜欢这篇文章吗？ 那么你会喜欢我的这篇文章：用最快的方式[在 JavaScript 数组中找到最大和最小值](https://medium.com/coding-at-dawn/the-fastest-way-to-find-minimum-and-maximum-values-in-an-array-in-javascript-2511115f8621) —— 我展示了一个使用 `Math.max()` 和 `Math.min()` 的方法，比使用 [`...` 扩展运算符](https://medium.com/coding-at-dawn/how-to-use-the-spread-operator-in-javascript-b9e4a8b06fab) 更快：
[**用最快的方法在 JavaScript 中查找数组中最小值和最大值**](https://medium.com/coding-at-dawn/the-fastest-way-to-find-minimum-and-maximum-values-in-an-array-in-javascript-2511115f8621)

现在你已经了解了 `Math.max()` 和 `Math.min()` 的所有特性！

Happy Coding! 😊💻😉🔥🙃

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
