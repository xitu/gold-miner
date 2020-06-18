> * 原文地址：[Plain JavaScript versions of Lodash Array Filtering and Manipulation Methods](https://medium.com/javascript-in-plain-english/plain-javascript-versions-of-lodash-array-filtering-and-manipulation-methods-2469e2c6a5fa)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/plain-javascript-versions-of-lodash-array-filtering-and-manipulation-methods.md](https://github.com/xitu/gold-miner/blob/master/TODO1/plain-javascript-versions-of-lodash-array-filtering-and-manipulation-methods.md)
> * 译者：[Coolrice](https://github.com/CoolRice)
> * 校对者：[z0gSh1u](https://github.com/z0gSh1u)

# 纯 JavaScript 版本的 Lodash 数组 Filtering 和 Manipulation 方法

![Photo by [Nathan Dumlao](https://unsplash.com/@nate_dumlao?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/13440/0*D1uL9uNDvEenTo3Z)

Lodash 是一个十分有用的工具库，它能让我们轻松地处理对象和数组。

而现在 JavaScript 标准库正在追赶 Lodash 这样的库，我们可以用简单的方法实现很多功能。

我们可以用纯 JavaScript 轻松实现 `pullAllBy` 、`pullAllWith` 、`pullAt` 和 `remove` 方法。

## pullAllBy

`pullAllBy` 会返回一个数组，此数组会先通过 `iteratee` 函数转换元素，然后通过给定值匹配来移除我们想移除的元素。

我们按如下方式来实现：

```js
const pullAllBy = (arr, values, iteratee) => arr.filter(a => !values.map(iteratee).includes(iteratee(a)))
```

上面的代码中，在使用 `includes` 对比之前调用给定的 `iteratee` 函数获得对应的值。并且在 `includes` 中也调用 `iteratee` 做同样的转换来让值能正确地对比。

然后我们可以按如下方法使用我们的 `pullAllBy`：

```js
const result = pullAllBy([1, 2.1, 3], [2.2, 3], Math.floor)
```

`result` 得到 `[1]`。

## pullAllWith

Lodash 的 `pullAllWith` 方法需要一个比较器来比较然后排除值，而非用 `iteratee` 先转换再比较。

举一个例子，我们可以按如下方法实现：

```js
const pullAllWith = (arr, values, comparator) => arr.filter(a => values.findIndex((v) => comparator(a, v)) === -1)
```

上面的代码中，使用纯 JavaScript 中的带回调函数的 `findIndex` 方法，此方法调用回调函数 `comparator` 来比较值。

我们调用 `filter` 来过滤出 `values` 数组包含的元素。

下面可以按如下方法调用：

```js
const result = pullAllWith([1, 2, 3], [2, 3], (a, b) => a === b)
```

`result` 得到 `[1]`。

## pullAt

Lodash 的 `pullAt` 方法返回一个数组，此数组的元素通过给定的索引来得到。

它同时会在数组中移除这些索引对应的元素。

我们再一次使用 `filter` 方法来过滤出我们想要的元素，方法如下：

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

在上面的代码中，我们使用 `for` 循环遍历数组，并用给定的 `indexes` 数组调用 `includes` 对元素们做判断。

然后我们把要被移除的元素推送到 `removedArr` 数组中。

之后我们的第二个循环会反向遍历 `arr`，这样在我们调用 `splice` 时不会改变 `arr` 在当前 `i` 以前部分的索引。

在循环中，我们只用调用 `splice` 来移除给定索引的元素。

最终，我们调用 `flat` 来对数组做扁平化处理，因为 `splice` 会返回一个数组。

因此，当我们像下面这样调用它时：

```js
const arr = [1, 2, 3]
const result = pullAt(arr, [1, 2])
```

我们可以看到 `result` 是 `[2, 3]`，因为指定数组中的 `[1, 2]` 索引对应的元素要被删除，并且由于索引 0 的元素是唯一没有被移除的，所以 `arr` 现在是 `[1]`。

![Photo by [Tim Mossholder](https://unsplash.com/@timmossholder?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/16384/0*3y4v9xXTGABfhW8F)

## remove

`remove` 方法移除满足给定条件的元素并且返回被移除的元素。

我们自己可以向下面这样来用 `for` 循环来实现它：

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

在上文的代码中，我们的 `pullAt` 方法有两次循环。然而现在我们用 `predicate` 函数，而不是用数组索引来检查。。

就像 `pullAt` 一样，我们必须反向遍历数组来防止在循环 `arr` 时 `splice` 改变索引。

然后，当我们像下面这样调用它时：

```js
const arr = [1, 2, 3]
const result = remove(arr, a => a > 1)
```

`result` 的值是 `[2, 3]` 并且 `arr` 是 `[1]`，因为我们指定 `predicate` 为 `a => a > 1`，所以任何比 1 大的元素都会被移除，返回剩下的值。

## 总结

`pullAt` 和 `remove` 非常相似，除了 `pullAt` 接收一组索引而 `remove` 接收一个指定条件的回调函数。

`pullAllBy` 和 `pullAllWith` 都使用 `filter` 方法实现。`pullAllBy` 在对比之前使用 `iteratee` 来预处理元素。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
