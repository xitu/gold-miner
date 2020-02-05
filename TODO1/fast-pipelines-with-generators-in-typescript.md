> * 原文地址：[Lazy Pipelines with Generators in TypeScript](https://itnext.io/fast-pipelines-with-generators-in-typescript-85d285ae6f51)
> * 原文作者：[Wim Jongeneel](https://medium.com/@wim.jongeneel1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/fast-pipelines-with-generators-in-typescript.md](https://github.com/xitu/gold-miner/blob/master/TODO1/fast-pipelines-with-generators-in-typescript.md)
> * 译者：
> * 校对者：

# Lazy Pipelines with Generators in TypeScript

![Photo by [Quinten de Graaf](https://unsplash.com/@quinten149?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9704/1*wEQnHaPoHc_QJo5vxwrCEg.jpeg)

In recent years the JavaScript community has embraced the functional array methods like `map` and `filter`. Writing for-loops has become something that gets associated with 2015 and JQuery. But the array methods in JavaScript are far from ideal when we are talking about performance. Lets look at an example to clarify the issues:

```TypeScript
const x = [1,2,3,4,5]
  .map(x => x * 2)
  .filter(x => x > 5)
  [0]
```

This code will execute the following steps:

* create the array with 5 items
* create a new array with all the numbers doubled
* create a new array with the numbers filtered
* take the first item

This involves a lot more stuff happening then is actually needed. The only thing has to happen is that the first item that passes `x > 5` gets processed and returned. In other languages (like Python) iterators are used to solve this issue. Those iterators are a lazy collection and only processes data when it is requested. If JavaScript would use lazy iterators for its array methods the following would happen instead:

* `[0]` requests the first item from `filter`
* `filter` requests items from `map` until it has found one item that passes the predicate and yields (‘returns’) it
* `map` has processed an item for each time `filter` requested it

Here we did only `map` and `filter` the first tree items in the array because no more items where requested from the iterator. There where also no additional arrays or iterators constructed because every item goes through the entire pipeline one after the other. This is a concept that **can** result in massive performance gains when processing a lot of data.

## Generators and iterators in JavaScript

Luckily for us JavaScript does actually support the concept of [iterators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators). They can be created with [generator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_Generators) functions that yield the items of the collection. A generator function looks as follows:

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

Here the for-loop will request an item of the iterator for each loop. The generator function uses the `yield` keyword to return the next item in the collection. As you see we can yield multiple times to create iterators that contain multiple items. There will never be any array constructed in memory. We can make this a bit better to understand when we remove some of the syntax sugar:

```TypeScript
const itt = iterator()
let current = itt.next()

while(current.done == false) {
  console.log(current.value)
  current = itt.next()
}
```

Here you can see that an iterator has a `next` method for requesting the next item. The result of this method has the value and a boolean indicating of we have more results left in the iterator. While this all very interesting, we will need some more things if we want to construct proper data pipelines with iterators:

* conversions from arrays to iterators and back
* iterators that operate on other iterators, like `map` and `filter` (also called ‘higher-order iterators’)
* a proper interface to chain all of those together in an elegant and practical way

In the rest of this article I will show how to do those things. At the end I have included a link to a library I created that contains a lot more features. Sadly, this is not a native implementations of lazy iterators. This means that there is overhead and in a lot of cases this library is not worth it. But I still want to show you the concept in action and discuss its pros and cons.

## Iterator constructors

We want to be able to create iterators from multiple data sources. The most oblivious one is arrays. This one is quite easy, we loop over the array and yield all items:

```TypeScript
function* from_array<a>(a:a[]) {
  for(const v of a) yield v
}
```

Turning an iterator in an array will require us to call `next` until we have gotten all the items. After this we can return our array. Of course you only want to turn an iterator into an array when absolutely needed because this function causes a full iteration.

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

Another method for reading data from an iterator is `first`. Its implementation is shown bellow. Note that it only request the first item from the iterator! This means that all the following potential values will never be calculated, resulting in less waste of resources in the data pipeline.

```TypeScript
export function first<a>(a: Iterator<a>) {
  return a.next().value
}
```

In the complete library there are also constructors that create iterators from [functions](https://github.com/WimJongeneel/ts-lazy-collections/blob/master/src/main.ts#L65-L74) or [ranges](https://github.com/WimJongeneel/ts-lazy-collections/blob/master/src/main.ts#L57-L63).

## Higher-order iterators

A higher-order iterator transforms an existing iterator into a new iterator. Those iterators are what makes up the operations in a pipeline. The well-known transform function `map` is shown bellow. It takes an iterator and a function and returns a new iterator where the function is applied to all items in the original iterator. Note that we still yield item-for-item and preserve the lazy nature of the iterators while transforming them. This is very important if we want to actually achieve the higher efficiency I talked about in the intro of this article!

```TypeScript
function* map<a, b>(a: Iterator<a>, f:(a:a) => b){
  let value = a.next()
  while(value.done == false) {
    yield f(value.value)
    value = a.next()
  }
}
```

Filter can be implemented in a similar way. When requested for the next item, it will keep requesting items from its inner iterator until it has found one that passed the predicate. This item will be yielded and execution is halted until the request for the next item comes in.

```TypeScript
function* filter<a>(a: Iterator<a>, p: (a:a) => boolean) {
  let current = a.next()
  while(current.done == false) {
    if(p(current.value)) yield current.value
    current = a.next()
  }
}
```

Many more higher-order iterators can be constructed in with the same concepts I have show above. The complete library ships with a lot of them, check them out over [here](https://github.com/WimJongeneel/ts-lazy-collections#collection-methods).

## The builder interface

The last part of the library is the public facing API. The library uses the builder pattern to allow you to chain methods like on arrays. This is done by creating a function that takes an iterator and returns an object with the methods on it. Those methods can call the constructor again with an updated iterator for the chaining:

```TypeScript
const fromIterator = <a>(itt: Iterator<a>) => ({
  toArray: () => to_array(itt),
  filter: (p: (a:a) => boolean) => lazyCollection(filter(itt, p)),
  map: <b>(f:(a:a) => b) => lazyCollection(map(itt, f)),
  first: () => first(itt)
})
```

The example of the start of this article can be written as bellow. In this implementation we don’t create additional arrays and only process the data that is actually used!

```TypeScript
const x = fromIterator(from_array([1,2,3,4,5]))
  .map(x => x * 2)
  .filter(x => x > 5)
  .first()
```

## Conclusion

In this article I have shown you how generators and iterators can be used to create a powerful and very efficient library for processing lots of data. Of course iterators are not the golden bullet that will fix everything. The gains in efficiency are down to saving on unnecessary calculations. How much this means in real numbers is completely down to how much calculations there can be optimized out, how heavy those calculations are and how much data you are processing. When there are no calculations to save or the collections are relative small, you will potentially lose performance to the overhead of the library.

The full source code can be found on [Github](https://github.com/WimJongeneel/ts-lazy-collections#collection-methods) and contains more features that fitted in this article. I would love to hear your opinion on this. Do you think it is a pity that JavaScript doesn’t use lazy iteration for the array methods? And do you think that using generators is the way forward for collections in JavaScript? If JavaScript would use lazy iterators by default they should be able to optimize the overhead away (like other languages have done) while still preserving the potential wins with efficiency.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
