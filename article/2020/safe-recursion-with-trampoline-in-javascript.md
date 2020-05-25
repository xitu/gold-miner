> * 原文地址：[Safe Recursion with Trampoline in JavaScript](https://levelup.gitconnected.com/safe-recursion-with-trampoline-in-javascript-dbec2b903022)
> * 原文作者：[Valeriy Baranov](https://medium.com/@baranovxyz)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/safe-recursion-with-trampoline-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/safe-recursion-with-trampoline-in-javascript.md)
> * 译者：[Gesj-yean](https://github.com/Gesj-yean)
> * 校对者：[cyz980908](https://github.com/cyz980908)，[z0gSh1u](https://github.com/z0gSh1u)

# 使用JavaScript中的蹦床函数实现安全递归

![来自[Charles Cheng](https://unsplash.com/@charlesc7?utm_source=medium&utm_medium=referral) 在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7274/0*9Sxt2ppwVpNELxC0)

在 JavaScript 中使用递归是不安全的，请考虑使用蹦床函数。它将递归转化为 `while` 循环去绕过 JavaScript 的限制，目的是为了防止溢出。

一个典型的递归函数就是阶乘计算。我们调用 `factorial` 函数 `n` 次来得到一个结果。每次调用都会向调用的堆栈添加一个 `factorial` 函数。

```JavaScript
function factorial(n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1);
}

console.log(factorial(5)); // 120
```

JavaScript 中的递归通常是代码出现问题的象征，通常应该避免使用。因为 JavaScript 是一种基于堆栈的语言，但目前没有尾调用优化。如果你运行了以下代码，将会报错 RangeError: Maximum call stack size exceeded，意思是超过最大调用堆栈大小。

```JavaScript
function recursiveFn(n) {
  if (n < 0) return true;
  recursiveFn(n - 1);
}

recursiveFn(100000); // RangeError: Maximum call stack size exceeded
```

不过，也有需要使用递归函数的情况。例如，遍历 `DOM` 树或其他的树形结构。

```JavaScript
function traverseDOM(tree) {
  if (isLeaf(tree)) tree.className = 'leaf';
  else for (const leaf of tree.childNodes) traverseDOM(leaf);
}
```

#### 蹦床函数 —— JavaScript中的安全递归方式

使用 `蹦床函数`，你可以将递归函数转化为 `while` 循环：

```JavaScript
function trampoline(f) {
  return function trampolined(...args) {
    let result = f.bind(null, ...args);

    while (typeof result === 'function') result = result();

    return result;
  };
}
```

让我们用 `蹦床函数` 去重写一个 `阶乘` 函数。我们需要去：

1. 在基本情况下返回一个值。
2. 在其他情况下返回要调用的函数。

我们还为 `_factorial` 的内部实现添加了累加器参数。

```JavaScript
const factorial = trampoline(function _factorial(n, acc = 1) {
  if (n <= 1) return acc;
  return () => _factorial(n - 1, n * acc);
});

console.log(factorial(5));
```

 `recursiveFn` 可以像 `factorial`一样被重写，但我们不需要累加器去跟踪状态。这个实现方式甚至可以安全的运行数百万次的迭代。

```JavaScript
const recursiveFn = trampoline(function _recursiveFn(n) {
  if (n < 0) return;
  return () => _recursiveFn(n - 1);
});

recursiveFn(100000);
console.log('No range error!');
```

下一次你想使用递归的时候，试试 `蹦床函数` 吧！

你可以尝试 `蹦床函数` 在这里 [CodePen](https://codepen.io/baranovxyz/pen/zYvjKGN)。

---

蹦床函数并不是一种流行的技术。即使在 ramda 和 lodash 中，也没有提供蹦床函数。

感谢 Kyle Simpson 为我提供了蹦床函数的灵感。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
