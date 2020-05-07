> * 原文地址：[An In-Depth Exploration of the Array.fill() Function](https://levelup.gitconnected.com/an-in-depth-exploration-of-the-array-fill-function-800155bf9dd)
> * 原文作者：[Keith Dawson](https://medium.com/@keithvictordawson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-in-depth-exploration-of-the-array-fill-function.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-in-depth-exploration-of-the-array-fill-function.md)
> * 译者：
> * 校对者：

# 深入浅出 Array.fill() 函数

![Photo by [Tracy Adams](https://unsplash.com/@tracycodes?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/javascript?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6364/1*KWkWLwUxBxxLh6ZzXg0-8Q.jpeg)

过去几年来，Javascript `Array` 全局对象添加了许多有用的函数，为开发人员编写 `Array` 相关代码时提供了更多选择。这些函数具有许多优点，最值得注意的是，过去，开发人员不得不一次实现自己的复杂逻辑来执行各种数组操作，而现在，所有这些新的函数淘汰了数组操作的本地实现。本文将探索有用的数组函数之一：`[fill()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fill)` 函数。

## 函数概述

`fill()` 函数提供将数组中给定范围内的所有元素更改为特定值的功能。这个函数会直接修改数组，然后返回修改后的函数版本。要记住一件非常重要的事情，如果你选择使用 `fill()` 函数如果不先保存一个复制，将会改变原数组。还值得指出的是，此函数不会更改原始数组的长度。

`fill()` 函数最多接收三个参数，第一个参数是**必须的**，第二个和第三个参数是**可选的**。第一个参数可以是任何期望的值，第二个和第三个参数是从零开始的索引。如果这些参数中有一个负值，将会从数组的结尾开始计算，这意味着参数 `-3` 相当于数组的长度加上 `-3`（`Array.length + -3`）。

第一个参数是`值`。这个参数可以是任何值，将会用来把指定范围数组的填充为相同的值。第二个参数是`起始索引`。这个参数是填充指定值范围的起始索引，且范围**将会**包括该索引处的值。这个参数是可选的，未指定的话则默认为 `0`，如果未指定这个参数的话将会从第一个值开始填充数组。第三个参数是`结尾索引`。这个参数是填充指定值范围的结尾索引，并且范围**将不**包括索引处的值。这个参数是可选的，为指定的话则默认为数组的长度值（`Array.length`），如果位置顶这个参数的话将会填充到数组的结尾。

## 原始值

包含了大多数的函数行为，让我们看一些 `fill()` 函数在实际中如何工作的示例。下面的示例仅指定了原始`值`参数：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0);
// array: [0, 0, 0, 0, 0]
```

`fill()` 函数传入 `0` 作为参数值来进行调用。考虑到可选参数的默认值，这个函数调用相当于 `fill(0, 0, 5)`。这意味着指定值的填充范围为从头到尾包含整个数组。

代码示例举例说明了前面提到的有关 `fill()` 函数如何不改变数组长度的内容。尽管没有明确填充范围的边界，但填充范围默认未数组的实际大小，这个函数用指定值填充数组中的每一项。

## 原始值，正起始索引

下面示例演示了指定原始`值`和正`起始索引`参数的情况：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, 2);
// array: [1, 2, 0, 0, 0]
```

`fill()` 函数传入 `0` 和 `2` 作为参数来进行调用，考虑到可选参数的默认值，这个函数调用相当于 `fill(0, 2, 5)`。这意味着指定值的填充范围为从索引 `2` 开始直到数组的结尾。

## 原始值，负起始索引

下面示例演示了指定原始`值`和负`起始索引`参数的情况：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, -2);
// array: [1, 2, 3, 0, 0]
```

`fill()` 函数传入 `0` 和 `-2` 作为参数来进行调用，考虑到可选参数的默认值和负值的转换，这个函数调用相当于 `fill(0, 3, 5)`。这意味着指定值的填充范围为从索引 `3` 开始直到数组的结尾。指定负`起始索引`时要注意的是，如果这个值导致`起始索引`加上数组长度仍然小于 `0` 的话，`fill()` 函数将忽略`起始索引`值，并从数组的开头用指定值填充数组。

## 原始值，正起始索引，正结尾索引

下面示例演示了指定原始`值`、正`起始索引`和正`结尾索引`参数的情况：

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, 2, 4);
// array: [1, 2, 0, 0, 5]
```

`fill()` 函数传入 `0`、`2` 和 `4`作为参数来进行调用，指定值的填充范围为以索引 `2` 开始，在索引 `3` 处结束，只用两个从索引 `2` 开始的数组项填充了指定值。指定正`结尾索引`时需要注意的是，如果这个值大于数组长度，则 `fill()` 函数将忽略`结尾索引`，并填充特定值到数组结尾。

## Primitive Value, Positive Start, Negative End

The following example demonstrates the situation where a primitive `value` parameter value, a positive `start` parameter value, and a negative `end` parameter value are specified:

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, 2, -3);
// array: [1, 2, 3, 4, 5]
```

The `fill()` function is called with a `value` parameter value of `0`, a `start` parameter value of `1`, and an `end` parameter value of `-3`. Considering how negative parameter values are evaluated, this function call is the same as `fill(0, 2, 2)`. This code sample is the first example that we have seen in this article where the `start` and `end` parameter values are the same. Due to the fact that these two parameter values reference the same index, no array items are filled with the specified value, resulting in an array that is in the exact same state as it was before the function was executed.

This same behavior where the resulting array is in the exact same state as it was before the function was executed will occur in any of the following situations when using the `fill()` function: the `end` parameter index falls before the `start` parameter index; the `start` parameter value is equal to or greater than the length of the array; and the `end` parameter value is equal to or less than `0`.

## Object Value

The following example demonstrates the situation where an object `value` parameter value is specified:

```js
var array = [1, 2, 3];
array.fill({ a: 1, b: 2 });
// array: [{ a: 1, b: 2 }, { a: 1, b: 2 }, { a: 1, b: 2 }]
```

The `fill()` function is called with an object `value` parameter value. Considering the optional parameter default values, this function call is the same as `fill({ a: 1, b: 2 }, 0, 3)`. This means that the fill range for the specified value is the entire array from beginning to end. Whereas all of the previous code samples only used a primitive value of `0` for the `value` parameter value, this code sample shows that it is equally acceptable to use an object should it be necessary to fill a range in an array with such a value.

## Lessons Learned

There are a few lessons to take away from this article regarding the `fill()` function. The first thing to keep in mind is that the `fill()` function **will not** alter the size of the original array at all, no matter what values are specified for the `start` and `end` parameters. The second thing to keep in mind is that the `fill()` function **will** modify the original array in-place, in addition to returning a reference to the modified array. This means that it is absolutely imperative that you make a completely new copy of the original array before executing the function if you need to maintain the state of the original array for any reason.

Another takeaway from this article should be that it is no longer necessary to implement any sort of custom logic for replacing all or a subset of items in an array with a single value. In such a situation, the first impulse may be to implement such logic using a for loop, which would certainly work just fine, but it would not be nearly as compact and easy-to-read as using the `fill()` function. Another similar use case may be when it is necessary to create an array of a specific size with a default value set for every index within that array. Once again, the first impulse may be to create the array and then use a for loop to fill the entire array with the default value. Using the `fill()` function, however, it is as simple as writing the following statement: `Array(10).fill(0)`.

The final thing to keep in mind about the `fill()` function is how it handles an object that is passed as the `value` parameter value. When passing any value as the `value` parameter value, all of the items in the array that are filled with that value will be exactly the same. In the case of an object, all of the items that are filled will have a reference to the same exact object. This means that updating any one of the objects that has been filled in the array will also update all of the other objects that were filled. The following example shows this functionality in action:

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

In the case of the first array, the original array is filled with three arrays and then the first of these arrays is filled with zeroes. This results in the other two arrays also being filled with zeroes. In the case of the second array, the original array is filled with three objects and the second and third objects are both altered. This results in all three of the objects being altered in the same way. Of course, as mentioned earlier, this is a result of each of the filled arrays or objects referencing the exact same object in all places where the array or object was filled. Altering any of the arrays or objects will only ever be altering the single array or object that is actually being referenced.

## 结论

Thank you very much for reading this article. I hope that this exploration of the `fill()` function on the Javascript `Array` global object has been informative and I hope that after gaining some knowledge about it you will be able to put it to good use in your own code. I encourage you to consult the resource link below for all information pertaining to the `fill()` function if you still have any further questions about how it works. Please stop back in the future for more articles about interesting and useful functions that can be found on the Javascript `Array` global object.

## 相关资源

[Javascript Array.fill() function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fill)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
