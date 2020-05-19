> * 原文地址：[Safe Recursion with Trampoline in JavaScript](https://levelup.gitconnected.com/safe-recursion-with-trampoline-in-javascript-dbec2b903022)
> * 原文作者：[Valeriy Baranov](https://medium.com/@baranovxyz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/safe-recursion-with-trampoline-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/safe-recursion-with-trampoline-in-javascript.md)
> * 译者：
> * 校对者：

# Safe Recursion with Trampoline in JavaScript

![Photo by [Charles Cheng](https://unsplash.com/@charlesc7?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7274/0*9Sxt2ppwVpNELxC0)

Using recursion in JavaScript is not safe — consider trampoline. This converts recursion to a `while` loop to get around JavaScript’s limitations and prevent an overflow.

An idiomatic example of a recursive function is a factorial calculation. We call `factorial` function `n` times to get a result. Every call will add one more `factorial` function to the call stack.

```JavaScript
function factorial(n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

console.log(factorial(5)); // 120
```

Recursion in JavaScript is mostly a sign of code smell and generally should be avoided. The reason is that JavaScript is a stack-based language, there is no tail call optimization yet. If you execute the following snippet, you will get a RangeError: Maximum call stack size exceeded.

```JavaScript
function recursiveFn(n) {
  if (n < 0) return true;
  recursiveFn(n - 1);
}

recursiveFn(100000); // RangeError: Maximum call stack size exceeded
```

Still, there are situations when you want to use a recursive function. A realistic one would be to traverse a `DOM` tree or any other tree-like structure.

```JavaScript
function traverseDOM(tree) {
  if (isLeaf(tree)) tree.className = 'leaf';
  else for (const leaf of tree.childNodes) traverseDOM(leaf);
}
```

#### Trampoline — a safe way to use recursion in JavaScript.

With `trampoline`, your transform recursive function into a `while` loop:

```JavaScript
function trampoline(f) {
  return function trampolined(...args) {
    let result = f.bind(null, ...args);

    while (typeof result === 'function') result = result();

    return result;
  };
}
```

Let's rewrite the `factorial` function to use `trampoline`. We need to:

1. return a value in a base case.
2. return a function to be called in other cases.

We also add accumulator argument for our internal implementation of `_factorial`.

```JavaScript
const factorial = trampoline(function _factorial(n, acc = 1) {
  if (n <= 1) return acc;
  return () => _factorial(n - 1, n * acc);
});

console.log(factorial(5));
```

Our `recursiveFn` can be rewritten similar to `factorial`, but we do not need an accumulator to track state. This implementation can be safely run even for millions of iterations.

```JavaScript
const recursiveFn = trampoline(function _recursiveFn(n) {
  if (n < 0) return;
  return () => _recursiveFn(n - 1);
});

recursiveFn(100000);
console.log('No range error!');
```

Next time you want to use recursion, try `trampoline`!

You can try `trampoline` in this [CodePen](https://codepen.io/baranovxyz/pen/zYvjKGN).

---

Trampoline is not a popular technique. Even in ramda and lodash, there are no trampoline helpers.

Thanks to Kyle Simpson for the inspiration about trampolines.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
