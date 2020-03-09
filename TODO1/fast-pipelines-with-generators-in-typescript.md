> * 原文地址：[Lazy Pipelines with Generators in TypeScript](https://itnext.io/fast-pipelines-with-generators-in-typescript-85d285ae6f51)
> * 原文作者：[Wim Jongeneel](https://medium.com/@wim.jongeneel1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/fast-pipelines-with-generators-in-typescript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/fast-pipelines-with-generators-in-typescript.md)
> * 译者：[febrainqu](https://github.com/febrainqu)
> * 校对者：[xionglong58](https://github.com/xionglong58),[GJXAIOU](https://github.com/GJXAIOU)

# TypeScript中带生成器的惰性管道

![Photo by [Quinten de Graaf](https://unsplash.com/@quinten149?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9704/1*wEQnHaPoHc_QJo5vxwrCEg.jpeg)

近年来，JavaScript 社区已经接受了函数式的数组方法，例如 `map` 和 `filter`。for循环 只能在Jquery中见到。但是在性能方面，JavaScript 中的数组方法远远达不到预期。让我们看一个例子来说明这些问题:

```TypeScript
const x = [1,2,3,4,5]
  .map(x => x * 2)
  .filter(x => x > 5)
  [0]
```

这段代码将执行以下步骤:

* 创建一个含有五个元素的数组
* 创建一个新数组，元素时前一个数组对应元素的2倍
* 创建一个符合过滤条件的新数组
* 取数字的第一个元素

实际上有很步骤是多余的，唯一必要的就是返回第一个大于 5 的元素。 在其他语言中 (例如 Python)，用迭代器来解决此类问题。 这些迭代器是一个惰性集合，只在请求时处理数据。 如果 JavaScript 将懒惰的迭代器用于其数组方法，则会发生以下情况：

* `[0]` 请求经  `filter` 操作后数组的第一个元素
* `filter` 从 `map` 中请求元素，直到发现一个符合条件的元素，并返回 (‘returns’) 它
* 每当 `filter` 发送一次请求， `map` 便处理一个元素

在这里，我们只对数组中的第一个树项进行了 `map` 和 `filter` 操作，因为迭代器不再请求树项。 T这里也没有额外的数组或迭代器，因为每一项都是一个接一个地遍历整个管道。这是一个概念：**可以** 在处理大量数据时获得巨大的性能收益。

## JavaScript 中的生成器和迭代器

幸运的是 JavaScript 确实支持[迭代器](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators)的概念。 可以使用生成集合项的[生成器](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators) 函数来创建它们。一个生成器函数如下:

```TypeScript
function* iterator() {
  yield 1
  yield 2
  yield 3
}

for(let x of iterator()) {
  console.log(x)
}
```

在这里，for循环将为每个循环请求迭代器的一个项。 生成器函数使用 `yield` 关键字来返回集合中的下一项。 如你所见，我们可以多次生成包含多个项的迭代器。 永远不会有任何数组构造在内存中。 我们可以删除一些语法糖，使这一点更好地理解:

```TypeScript
const itt = iterator()
let current = itt.next()

while(current.done == false) {
  console.log(current.value)
  current = itt.next()
}
```

这里你可以看到迭代器有一个 `next` 方法用于请求下一项。 此方法的结果具有一个值和一个布尔值，指示迭代器中还有更多结果。 虽然这一切都很有趣，但如果我们想要使用迭代器构建正确的数据管道，还需要做更多的事情:

* 从数组到迭代器的转换
* 在其它迭代器上运作的迭代器, 如 `map` 和 `filter` (也称为“高阶迭代器”)
* 一个合适的接口，以优雅和实用的方式将所有这些链接在一起

下面，我将展示如何实现这些功能。 在文末，我添加了一个指向我创建的包含更多特性的库的链接。遗憾的是，这不是惰性迭代器的本机实现。 这意味着存在开销，而且在很多情况下，这个库不值得这样做。 但我还是想向你们展示这个概念的实际应用，并讨论它的利弊。

## 迭代器的构造函数

我们希望能够从多个数据源创建迭代器。 最容易被遗忘的就是数组。 这是相当容易的，我们循环数组，并产生所有项目:

```TypeScript
function* from_array<a>(a:a[]) {
  for(const v of a) yield v
}
```

在数组中调用迭代器需要调用 `next`，直到获得所有的项。 当然，您只希望在绝对需要时将迭代器转换为数组，因为这个函数会导致完整的迭代。

```TypeScript
function to_array<a>(a: Iterator<a>) {
  let result: a[] = []
  let current = a.next()
  while(current.done == false) {
    result.push(current.value)
    current = a.next()
  }
  return result
}
```

从迭代器中读取数据的另一种方法是 `first`。 它的实现如下所示。 注意，它只向迭代器请求第一项! 这意味着将永远不会计算所有以下潜在值，从而减少数据管道中的资源浪费。

```TypeScript
export function first<a>(a: Iterator<a>) {
  return a.next().value
}
```

在完整的库中还有一些构造函数，它们从 [functions](https://github.com/WimJongeneel/ts-lazy-collections/blob/master/src/main.ts#L65-L74) 或 [ranges](https://github.com/WimJongeneel/ts-lazy-collections/blob/master/src/main.ts#L57-L63)创建迭代器。

## 高阶迭代器

高阶迭代器将现有的迭代器转换为新的迭代器。 这些迭代器组成了管道中的操作。 著名的转换函数 `map` 如下所示。 它接受一个迭代器和一个函数，并返回一个新的迭代器，其中该函数应用于原始迭代器中的所有项。 请注意，我们仍然生成项目对项目，并在转换迭代器时保留迭代器的惰性。 这是非常重要的，如果我们想要真正实现更高的效率，我在介绍这篇文章!

```TypeScript
function* map<a, b>(a: Iterator<a>, f:(a:a) => b){
  let value = a.next()
  while(value.done == false) {
    yield f(value.value)
    value = a.next()
  }
}
```

过滤器可以用类似的方式实现。 当请求下一项时，它将一直从内部迭代器请求项，直到找到一个通过条件的项。 将产生此项目，并停止执行，直到收到下一个项目的请求。

```TypeScript
function* filter<a>(a: Iterator<a>, p: (a:a) => boolean) {
  let current = a.next()
  while(current.done == false) {
    if(p(current.value)) yield current.value
    current = a.next()
  }
}
```

可以用上面介绍的概念构造更多的高阶迭代器。 图书馆里有很多这样的书，可以看 [这里](https://github.com/WimJongeneel/ts-lazy-collections#collection-methods)。

## 构建器接口

库的最后一部分是面向公众的 API。 该库使用构建器模式来允许您像在数组上那样链接方法。 这是通过创建一个接受迭代器并返回带有方法的对象的函数来完成的。 这些方法可以再次调用构造函数与更新迭代器的链接:

```TypeScript
const fromIterator = <a>(itt: Iterator<a>) => ({
  toArray: () => to_array(itt),
  filter: (p: (a:a) => boolean) => lazyCollection(filter(itt, p)),
  map: <b>(f:(a:a) => b) => lazyCollection(map(itt, f)),
  first: () => first(itt)
})
```

本文开头的例子可以写成如下。在这个实现中，我们不创建额外的数组，只处理实际使用的数据!

```TypeScript
const x = fromIterator(from_array([1,2,3,4,5]))
  .map(x => x * 2)
  .filter(x => x > 5)
  .first()
```

## 结论

在本文中，我向您展示了如何使用生成器和迭代器来创建功能强大且非常高效的库来处理大量数据。当然，迭代器并不是解决所有问题的金钥匙。 效率的提高是由于节省了不必要的计算。 这实际上提升了多少，完全取决于可以优化多少计算，这些计算有多繁重以及您正在处理多少数据。 当没有要保存的计算或集合相对较小时，你可能会因为库的开销而损失性能。

完整的源代码可以在 [Github](https://github.com/WimJongeneel/ts-lazy-collections#collection-methods) 找到并包含本文中包含的更多特性。 我很想听听你对此的意见。 您是否认为JavaScript不对数组方法使用延迟迭代是很可惜的？您是否认为使用生成器是JavaScript集合的前进方向？如果JavaScript在默认情况下使用惰性迭代器，则它们应该能够优化开销（就像其他语言一样），同时仍然保持效率的潜在优势。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
