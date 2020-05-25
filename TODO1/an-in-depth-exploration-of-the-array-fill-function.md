> * 原文地址：[An In-Depth Exploration of the Array.fill() Function](https://levelup.gitconnected.com/an-in-depth-exploration-of-the-array-fill-function-800155bf9dd)
> * 原文作者：[Keith Dawson](https://medium.com/@keithvictordawson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-in-depth-exploration-of-the-array-fill-function.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-in-depth-exploration-of-the-array-fill-function.md)
> * 译者：[niayyy](https://github.com/niayyy-S)
> * 校对者：[Siva](https://github.com/IAMSHENSH)、[Long Xiong](https://github.com/xionglong58)

# 深入浅出 Array.fill() 函数

![Photo by [Tracy Adams](https://unsplash.com/@tracycodes?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/javascript?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6364/1*KWkWLwUxBxxLh6ZzXg0-8Q.jpeg)

过去几年来，Javascript `Array` 全局对象添加了许多有用的函数，为开发人员编写 `Array` 相关代码时提供了更多选择。这些函数具有许多优点，最值得注意的是，过去，开发人必须自己实现复杂的逻辑才能来执行各种数组操作，而现在，所有这些新的函数淘汰了需要自己实现的函数。本文将探索有用的数组函数之一：[‘fill()’](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fill) 函数。

## 函数概述

`fill()` 函数提供将数组中给定范围内的所有元素更改为特定值的功能。这个函数不但会直接修改原数组，还会返回修改后的新数组。因此要记住一件非常重要的事情，如果你选择使用 `fill()` 函数，而不先保存一个原数组深拷贝，将无法维护原数组。还值得指出的是，此函数不会更改原数组的长度。

`fill()` 函数最多接收三个参数，第一个参数是**必须的**，第二个和第三个参数是**可选的**。第一个参数可以是任何期望的值，第二个和第三个参数的索引是从零开始的。如果这些参数中有一个负值，将会从数组的结尾开始计算，这意味着参数 `-3` 相当于数组的长度加上 `-3`（`Array.length + -3`）。

第一个参数是 `value`。这个参数可以是任何值，将会用来把新数组的指定的范围填充为相同的值。第二个参数是 `start`。这个参数是填值范围的起始索引，且该范围**将会**包括 `start` 索引位。这个参数是可选的，未指定的话则默认为 `0`，也就是如果未指定这个参数的话将会从第一个值开始填充数组。第三个参数是 `end`。这个参数是填值范围的结尾索引，且该范围**将不**包括索引处的值。这个参数是可选的，未指定的话则默认为数组的长度值（`Array.length`），也就是如果未指定这个参数的话将会填充到数组的结尾。

## 原始值

这种情况覆盖了一般的函数行为，让我们看一些 `fill()` 函数在实际中如何工作的示例。下面的示例指定了原始参数 `value` 的情况：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0);
// array: [0, 0, 0, 0, 0]
```

`fill()` 函数传入参数 `0` 来进行调用。考虑到可选参数的默认值，这个函数调用相当于 `fill(0, 0, 5)`。这意味着指定值的填充范围为从头到尾包含整个数组。

代码示例举例说明了前面提到的有关 `fill()` 函数如何不改变数组长度的内容。尽管没有明确填充范围的边界，但填充范围默认为数组的实际大小，这个函数用指定值填充数组中的每一项。

## 原始值，正起始索引值

下面示例演示了指定原始值参数 `value` 和正的 `start` 参数值的情况：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, 2);
// array: [1, 2, 0, 0, 0]
```

`fill()` 函数传入参数 `0` 和 `2` 来进行调用，考虑到可选参数的默认值，这个函数调用相当于 `fill(0, 2, 5)`。这意味着指定值的填充范围为从索引 `2` 开始直到数组的结尾。

## 原始值，负起始索引值

下面示例演示了指定原始值参数 `value` 和负的 `start` 参数值的情况：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, -2);
// array: [1, 2, 3, 0, 0]
```

`fill()` 函数传入参数 `0` 和 `-2` 来进行调用，考虑到可选参数的默认值和负索引值的转换，这个函数调用相当于 `fill(0, 3, 5)`。这意味着指定值的填充范围为从索引 `3` 开始直到数组的结尾。指定负的 `start` 参数时要注意的是，如果这个值导致 `start` 参数值加上数组长度仍然小于 `0` 的话，`fill()` 函数将忽略`起始索引`值，并从数组的开头用指定值填充数组。

## 原始值，正起始索引值，正结尾索引值

下面示例演示了指定原始值参数 `value`、正的 `start` 和 `end` 参数值的情况：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, 2, 4);
// array: [1, 2, 0, 0, 5]
```

`fill()` 函数传入参数 `0`、`2` 和 `4` 来进行调用，指定值的填充范围以索引 `2` 开始，在索引 `3` 处结束，因此只有从索引 `2` 开始的两个数组项填充了指定值。指定正的 `end` 参数值时需要注意的是，如果这个值大于数组长度，则 `fill()` 函数将忽略 `end` 参数值，并填充特定值到数组结尾。

## 原始值，正起始索引值，负结尾索引值

下面示例演示了指定原始值参数 `value`、正的 `start` 和负的 `end` 参数值的情况：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, 2, -3);
// array: [1, 2, 3, 4, 5]
```

`fill()` 函数传入参数 `0`, `2` 和 `-3` 来进行调用。考虑到负索引值的转换，这个函数调用相当于 `fill(0, 2, 2)`。这个代码示例是在文章中我们第一次看到 `start` 和 `end` 参数值相同的情况。由于这两个索引参数值相同，索引特定值不会填充任何数组项，因此数组状态和执行函数前的状态完全相同。

当使用 `fill()` 函数时，在以下任何一种情况下，都会发生结果数组与执行该函数之前状态完全相同的情况：`end` 参数值小于 `start` 参数值；`start` 参数值等于或大于数组长度；或者 `end` 参数值等于或小于`0`。

## 对象值

下面示例演示了指定对象值参数 `value` 的情况：

```js
var array = [1, 2, 3];
array.fill({ a: 1, b: 2 });
// array: [{ a: 1, b: 2 }, { a: 1, b: 2 }, { a: 1, b: 2 }]
```

`fill()` 函数传入对象值参数 `value` 来进行调用。考虑到可选参数的默认值，这个函数调用相当于 `fill({ a: 1, b: 2 }, 0, 3)`。这意味着特定值的填充范围是从头到尾包含整个数组。尽管之前的示例中都使用的是原始值 `0` 用作 `value` 参数值，但该代码示例表明当必要时也可使用对象值来填充数组的指定范围。

## 经验总结

关于 `fill()` 函数，从本文中可以获得一些经验。第一是无论 `start` 和 `end` 指定什么值作为参数，`fill()` 函数**都不会**改变原始数组的大小。第二是除了返回一个修改后数组以外，`fill()` 函数还**会**直接修改原始数组。这意味着，如果出于某种原因需要维护原始数组的状态，那么需要在执行函数前深拷贝一个原始的数组。

本文带来的另一个收获是，不再需要实现任何类型的自定义逻辑来用单个值替换数组中的所有或部分项。在这种情况下，首先想到的是通过 for 循环来实现这样的逻辑，这当然可以很好的工作，但是不会像使用 `fill()` 函数一样严谨和易于阅读。另一种类似的案例可能是创建特定大小的数组，并为每个索引设置默认值，我们首先想到的可能是创建数组，然后使用 for 循环来对数组进行默认值的填充。但是，使用 `fill()` 函数可以非常简单的实现，比如接下来的语句：`Array(10).fill(0)`。

关于 `fill()` 函数需要知道的最后一件事情是如何处理作为 `value` 参数值传递的对象。当传递任何值作为 `value` 参数值时，数组中所有的填充项将会完全相同。对于对象，所有的填充项都将指向完全相同的对象。这意味着更新数组中已填充的任何对象都将更新其他数组里填充的对象。下面的示例展示了这个功能的实际作用：

```js
var array1 = [1, 2, 3];
array1.fill([1, 2, 3]);

// array1: [[1, 2, 3], [1, 2, 3], [1, 2, 3]]

array1[0].fill(0);

// array1: [[0, 0, 0], [0, 0, 0], [0, 0, 0]]

var array2 = [1, 2, 3];
array2.fill({ a: 1, b: 2});

// array2: [{ a: 1, b: 2 }, { a: 1, b: 2 }, { a: 1, b: 2 }]

array2[1].a = 3;
array2[2].b = 4;

// array2: [{ a: 3, b: 4 }, { a: 3, b: 4 }, { a: 3, b: 4 }]
```

在第一个数组的情况下，原始数组填充了三个数组，然后把这三个数组中的第一个数组用零填充。这导致其他两个数组也填充了零。在第二个数组的情况下，原始数组填充了三个对象，第二个和第三个对象都以相同的方式进行更改，导致三个对象都同时更新了值。当然，正如前面说到的，这是每个填充的数组或对象在填充数组时指向了完全相同的对象的结果。更改任何数组或对象相当于更改了实际引用的单个数组或对象。

## 结论

非常感谢你阅读本篇文章。我希望对 JavaScript `Array` 全局对象上的 `fill()` 函数的探索能提供很多有用的信息，并且希望获取这些知识能让你在自己的代码中充分利用到。如果你还有其他关于这个函数的疑问，建议你参考下面的链接获取与 `fill()` 函数有关的所有信息。请在将来继续浏览更多关于 JavaScript `Array` 全局对象上的有趣和有用的函数的文章。

## 相关资源

[Javascript Array.fill() 函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fill)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
