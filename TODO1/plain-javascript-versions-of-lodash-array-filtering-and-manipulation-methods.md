> * 原文地址：[Plain JavaScript versions of Lodash Array Filtering and Manipulation Methods](https://medium.com/javascript-in-plain-english/plain-javascript-versions-of-lodash-array-filtering-and-manipulation-methods-2469e2c6a5fa)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/plain-javascript-versions-of-lodash-array-filtering-and-manipulation-methods.md](https://github.com/xitu/gold-miner/blob/master/TODO1/plain-javascript-versions-of-lodash-array-filtering-and-manipulation-methods.md)
> * 译者：
> * 校对者：

# Plain JavaScript versions of Lodash Array Filtering and Manipulation Methods

![Photo by [Nathan Dumlao](https://unsplash.com/@nate_dumlao?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/13440/0*D1uL9uNDvEenTo3Z)

Lodash is a very useful utility library that lets us work with objects and arrays easily.

However, now that the JavaScript standard library is catching up to libraries such as Lodash, we can implement many of the functions in simple ways.

We can implement the `pullAllBy` , `pullAllWith` , `pullAt` , and `remove` methods easily with plain JavaScript.

## pullAllBy

The `pullAllBy` returns an array that removes the given values that matches the items we want to remove after converting them with the `iteratee` function.

We can implement it as follows:

```js
const pullAllBy = (arr, values, iteratee) => arr.filter(a => !values.map(iteratee).includes(iteratee(a)))
```

In the code above, we call the given `iteratee` function to map the values before doing the comparison with `includes` . Also in `includes` , we also call `iteratee` to do the same conversion so that they can be compared properly.

Then we can use our `pullAllBy` function as follows:

```js
const result = pullAllBy([1, 2.1, 3], [2.2, 3], Math.floor)
```

And we get `[1]` for `result` .

## pullAllWith

The Lodash `pullAllWith` method takes a comparator instead of the `iteratee` to compare the values to exclude with the comparator instead of an `iteratee` to convert the values before comparing them.

For instance, we can implement it as follows:

```js
const pullAllWith = (arr, values, comparator) => arr.filter(a => values.findIndex((v) => comparator(a, v)) === -1)
```

In the code above, we use the plain JavaScript’s `findIndex` method with a callback that calls the `comparator` to compare the values.

We call `filter` to filter out them items that are included with the `values` array.

Then when we call it as follows:

```js
const result = pullAllWith([1, 2, 3], [2, 3], (a, b) => a === b)
```

We get `[1]` for `result` .

## pullAt

The Lodash `pullAt` method returns an array with the elements with the items with the given indexes.

It also removes the elements in-place with those indexes.

Again, we can use the `filter` method to filter out the items that we want to remove as follows:

```js
const pullAt = (arr, indexes) => {
  let removedArr = [];
  const originalLength = arr.length
  for (let i = 0; i < originalLength; i++) {
    if (indexes.includes(i)) {
      removedArr.push(arr[i]);
    }
  }

  for (let i = originalLength - 1; i >= 0; i--) {
    if (indexes.includes(i)) {
      arr.splice(i, 1);
    }
  }
  return removedArr.flat()
}
```

In the code above, we used a `for` loop to loop through the array and call `splice` on `arr` on the items with the given index in the `indexes` array.

Then we push the removed items into the `removedArr` array.

We then have and 2nd loop, which loops `arr` in reverse so that it doesn’t change `arr` ‘s indexes before we call `splice` on it.

In the loop, we just call `splice` to remove the items with the given index.

Finally, we call `flat` to flatten the array since `splice` returns an array.

Therefore, when we call it as follows:

```js
const arr = [1, 2, 3]
const result = pullAt(arr, [1, 2])
```

We see that `result` is `[2, 3]` since we specified `[1, 2]` in the array with the index to remove and `arr` is now `[1]` since that’s the only one that’s not removed.

![Photo by [Tim Mossholder](https://unsplash.com/@timmossholder?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/16384/0*3y4v9xXTGABfhW8F)

## remove

The `remove` method removes the items from an array in place with the given condition and returns the removed items.

We can implement it ourselves with the `for` loop as follows:

```js
const remove = (arr, predicate) => {
  let removedArr = [];
  const originalLength = arr.length
  for (let i = 0; i < originalLength; i++) {
    if (predicate(arr[i])) {
      removedArr.push(arr[i]);
    }
  }
  for (let i = originalLength - 1; i >= 0; i--) {
    if (predicate(arr[i])) {
      arr.splice(i, 1);
    }
  }
  return removedArr.flat();
}
```

In the code above, we have 2 loops as we have with the `pullAt` method. However, instead of checking for indexes, we’re checking for a `predicate` .

Like `pullAt` , we have to loop through the array indexes in reverse to avoid `splice` changing the indexes as we’re looping through the items of `arr` .

Then when we call `remove` as follows:

```js
const arr = [1, 2, 3]
const result = remove(arr, a => a > 1)
```

We get that `result` is `[2, 3]` and `arr` is `[1]` since we specified that the `predicate` is `a => a > 1` , so anything bigger than 1 is removed from the original array and the rest are returned.

## Conclusion

The `pullAt` and `remove` methods are very similar, except that `pullAt` takes an array of index and `remove` takes a callback with the given condition.

`pullAllBy` and `pullAllWith` are implemented with the `filter` method. `pullAllBy` also needs to map the values with the `iteratee` function before doing comparisons.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
