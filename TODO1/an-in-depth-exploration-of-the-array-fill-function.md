> * 原文地址：[An In-Depth Exploration of the Array.fill() Function](https://levelup.gitconnected.com/an-in-depth-exploration-of-the-array-fill-function-800155bf9dd)
> * 原文作者：[Keith Dawson](https://medium.com/@keithvictordawson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/an-in-depth-exploration-of-the-array-fill-function.md](https://github.com/xitu/gold-miner/blob/master/TODO1/an-in-depth-exploration-of-the-array-fill-function.md)
> * 译者：
> * 校对者：

# An In-Depth Exploration of the Array.fill() Function

![Photo by [Tracy Adams](https://unsplash.com/@tracycodes?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/javascript?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6364/1*KWkWLwUxBxxLh6ZzXg0-8Q.jpeg)

There have been many useful functions that have been added to the Javascript `Array` global object over the last few years that offer developers a wide variety of options when they are writing code that works with arrays. These functions offer a number of advantages, the most noteworthy of which is the fact that, while at one time in the past developers had to implement their own complex logic to perform various array operations, now the need for such homegrown implementations has been eliminated by all of these new functions. One of those useful functions that will be explored in this article is the `[fill()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fill)` function.

## Function Overview

The `fill()` function provides the ability to change all elements in a given range within an array to a specific value. Not only does this function modify the array in-place, but it also returns the updated version of the array upon function completion. A very important thing to keep in mind if you choose to use the `fill()` function is that you will not be able to maintain the original array without making a completely new copy of it beforehand. It is also worth pointing out that this function will not alter the length of the original array.

The `fill()` function takes up to three parameters with the first parameter being **required** and the second and third parameters being **optional**. While the first parameter can be any desired value, the second and third parameters are zero-based indexes. If either of these parameters has a negative value, it will be counted from the end of the array instead of from the beginning. This means that a parameter value of `-3` would actually result in the value of that parameter being `3` less than the length of the array (`Array.length + -3`).

The first parameter is the `value` parameter. This parameter can have any desired value and the same exact value will be used to fill the array within the specified range. The second parameter is the `start` parameter. This parameter is the starting index of the range that will be filled with the specified value and the range **will** include the item at this index. As this parameter is optional, it has a default value of `0` and the array will be filled from the beginning of the array if this parameter is not specified. The third parameter is the `end` parameter. This parameter is the ending index of the range that will be filled with the specified value and the range **will not** include the item at this index. As this parameter is optional, it has a default value of the length of the array (`Array.length`) and the array will be filled through the end of the array if this parameter is not specified.

## Primitive Value

With the general function behavior covered, let’s take a look at some examples of how the `fill()` function works in practice. The following example demonstrates the situation where only a primitive `value` parameter value is specified:

```js
var array = [1, 2, 3, 4, 5];
array.fill(0);
// array: [0, 0, 0, 0, 0]
```

The `fill()` function is called with a `value` parameter value of `0`. Considering the optional parameter default values, this function call is the same as `fill(0, 0, 5)`. This means that the fill range for the specified value is the entire array from beginning to end.

This code sample exemplifies what was mentioned earlier about how the `fill()` function does not alter the length of the array. Despite the fact that no bounds to the fill range were explicitly specified, the fill range simply defaults to the exact size of the array and the function only fills each of the existing array items with the specified value and no more.

## Primitive Value, Positive Start

The following example demonstrates the situation where a primitive `value` parameter value and a positive `start` parameter value are specified:

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, 2);
// array: [1, 2, 0, 0, 0]
```

The `fill()` function is called with a `value` parameter value of `0` and a `start` parameter value of `2`. Considering the optional parameter default values, this function call is the same as `fill(0, 2, 5)`. This means that the fill range for the specified value begins at index `2` and continues to the end of the array.

## Primitive Value, Negative Start

The following example demonstrates the situation where a primitive `value` parameter value and a negative `start` parameter value are specified:

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, -2);
// array: [1, 2, 3, 0, 0]
```

The `fill()` function is called with a `value` parameter value of `0` and a `start` parameter value of `-2`. Considering the optional parameter default values and how negative parameter values are evaluated, this function call is the same as `fill(0, 3, 5)`. This means that the fill range for the specified value begins at index `3` and continues to the end of the array. One important thing to keep in mind when specifying a negative `start` parameter value is that if the value causes the `start` parameter value to be less than `0` when added to the array length, the `fill()` function will ignore the `start` parameter value and instead fill the specified value from the beginning of the array.

## Primitive Value, Positive Start, Positive End

The following example demonstrates the situation where a primitive `value` parameter value and positive `start` and `end` parameter values are specified:

```js
var array = [1, 2, 3, 4, 5];
array.fill(0, 2, 4);
// array: [1, 2, 0, 0, 5]
```

The `fill()` function is called with a `value` parameter value of `0`, a `start` parameter value of `2`, and an `end` parameter value of `4`. With the fill range for the specified value beginning at index `2` and ending at index `3`, only the two indexes beginning at index `2` are filled with the specified value. One important thing to keep in mind when specifying a positive `end` parameter value is that if the value is greater than the length of the array, the `fill()` function will ignore the `end` parameter value and instead fill the specified value to the end of the array.

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

## Conclusions

Thank you very much for reading this article. I hope that this exploration of the `fill()` function on the Javascript `Array` global object has been informative and I hope that after gaining some knowledge about it you will be able to put it to good use in your own code. I encourage you to consult the resource link below for all information pertaining to the `fill()` function if you still have any further questions about how it works. Please stop back in the future for more articles about interesting and useful functions that can be found on the Javascript `Array` global object.

## Resources

[Javascript Array.fill() function](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fill)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
