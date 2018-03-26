> * 原文地址：[Reducers VS Transducers](http://maksimivanov.com/posts/reducers-vs-transducers)
> * 原文作者：[Maksim Ivanov](http://maksimivanov.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/reducers-vs-transducers.md](https://github.com/xitu/gold-miner/blob/master/TODO/reducers-vs-transducers.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[allenlongbaobao](https://github.com/allenlongbaobao) [leviding](https://github.com/leviding)

# Reducers VS Transducers

今天我们为您准备了一份函数范式甜点。我也不知道为什么会用「VS」，而且它俩还互相恭维。不管那么多了，让我们看点好东西......

## Reducers

简单来说，`Reducer` 就是个接收上一个计算值和一个当前值并返回新的计算值的方法。

![reducers](http://d33wubrfki0l68.cloudfront.net/8da7177f710424f3236cb13803ce8442e4b93127/5e09a/assets/images/reducers_vs_transducers_1.png)

如果你使用过数组的 `Array.prototype.reduce()` 方法，就已经熟悉了 reducer。数组的 `.reduce()` 方法本身并不是一个 reducer，这个方法会遍历一个集合（译注：累加器初始值和数组中的元素组成的集合），然后对集合中的每个元素应用传给这个方法的回调函数，这个回调函数才是一个 **reducer**。

假设我们有一个包含五个数字的数组：`[1, 2, 3, 14, 21]`，我们要找出它们中的最大值。

```
const numbers = [1, 2, 3, 14, 21];

const biggestNumber = numbers.reduce(
  (accumulator, value) => Math.max(accumulator, value)
);

// 21
```

这里的箭头函数就是一个 reducer。数组的 `.reduce()` 方法只是取这个 reducer 上一次执行的结果（译注：初始值参数或数组第一个元素）和数组中的下一个元素传给并继续调用这个 reducer。

Reducers 可以处理任何类型的值。唯一条件就是计算方法返回的值类型和传给计算方法的值类型要保持一致。

在下面的例子中，你可以轻松创建一个作用于字符串的 reducer：

```
const folders = ['usr', 'var', 'bin'];

const path = folders.reduce(
  (accumulator, value) => `${accumulator}/${value}`
, ''); // Here I passed empty string as an initial value

// /usr/var/bin
```

实际上，不使用 `Array.reduce()` 方法来说明更好理解。如下：

```
const stringReducer = (accumulator, value) => `${accumulator} ${value}`

const helloWorld = stringReducer("Hello", "world!")

// Hello world!
```

## Map 和 Filter 方法作为 Reducers

Reducers 还有一个好处是你可以链式地连接它们，来实现对某些数据的一系列操作。这就为功能模块化和 reducer 的复用提供了巨大的可能。

假设有一个有序的数字数组。你想获取其中的偶数，然后再乘以 2。

实现上述功能通常的方法是调用数组的 `.map` 和 `.filter` 方法：

```
[1, 2, 3, 4, 5, 6]
  .filter((x) => x % 2 === 0)
  .map((x) => x * 2)
```

但如果这个数组有 1000000 个元素呢？你需要遍历整个数组的每个元素，这样的效率太低了。

我们需要用某种方式去组合传给 `map` 和 `filter` 方法的函数。因为它们的接口不同，所以我们无法实现。传给 `filter` 方法的函数称为**断言函数**，它接收一个值，依据内部逻辑返回断言的 **True** 或者 **False**。传给 `map` 方法的函数称为**转换函数**，它接收一个值，并返回**转换后的值**。

我们可以通过 reducers 来实现这一点，让我们创建自己的 **reducer** 版本的 `.map` 和 `.filter` 方法。

```
const filter = (predicate) => {
  return (accumulator, value) => {
    if(predicate(value)){
      accumulator.push(value);
    }
    return accumulator;
  }
}

const map = (transformer) => {
  return (accumulator, value) => {
    accumulator.push(transformer(value));
    return accumulator;
  }
}
```

真棒，我们使用了 **装饰器** 来包装我们的 reducers。现在我们有自己的 `map` 和 `filter` 方法，它们返回的 **reducers** 可以传递给数组的 `Array.reduce()` 方法。

```
[1, 2, 3, 4, 5, 6]
  .reduce(filter((x) => x % 2 === 0), [])
  .reduce(map((x) => x * 2), [])
```

太棒了，现在我们就能链式地调用一系列的 `.reduce` 方法，但我们还是没有组合我们的 reducers！好消息是我们只差一步了。为了能组合 reducers 我们需要让它们能互相传递。

## Transducers， 可以有吗？

来升级下我们的 `filter` 方法，让它能够接收 **reducers** 作为参数。我们要分解下它，不是将值添加到 **accumulator**，而是要传给传入的 reducer，并执行这个 reducer。

```
const filter = (predicate) => (reducer) => {
  return (accumulator, value) => {
    if(predicate(value)){
      return reducer(accumulator, value);
    }
    return accumulator;
  }
}
```

我们接收一个 **reducer** 作为参数，并返回另一个 **reducer** 的这种模式就叫做 **transducer**。它是 **transformer** 和 **reducer** 的结合（我们接收一个 reducer，并对它进行了转换）。

```
const transducer => (reducer) => {
  return (accumulator, value) => {
    // 转换 reducer 的逻辑
  }
}
```

所以最基础的 transducer 就像 `(oneReducer) => anotherReducer` 这样。

现在我们就可以组合使用我们的 **mapping** reducer 和 **filtering** transducer，一次调用就可以实现我们的计算了。

```
const evenPredicate = (x) => x % 2 === 0;
const doubleTransformer = (x) = x * 2;

const filterEven = filter(evenPredicate);
const mapDouble = map(doubleTransformer);

[1, 2, 3, 4, 5, 6]
  .reduce(filterEven(mapDouble), []);
```

实际上，我们也可以把我们的 map 方法改造为一个 transducer，然后无限地继续这种改造。

但如果要组合 2 个以上的 reducers 呢？我们要找到更简便的组合方法。

## 更好的组合方法

总体来说就是，我们需要一个能接收一定数量的函数并把它们按顺序组合的方法。类似下面这样：

```
compose(fn1, fn2, fn3)(x) => fn1(fn2(fn3(x)))
```

幸运的是，很多库都提供了这种功能。比如 [RamdaJS](http://ramdajs.com/docs/#compose) 这个库。但为了解释清楚，来创建我们自己的版本吧。

```
const compose = (...functions) =>
  functions.reduce((accumulation, fn) =>
    (...args) => accumulation(fn(args)), x => x)
```

这个函数的功能非常紧凑，我们来分解下。

如果我们像这样 `compose(fn1, fn2, fn3)(x)` 调用了这个函数。

首先看 `x => x` 部分。在 λ 演算中，这被称为 **恒等函数**。不管接收什么参数，它都不会改变。我们就从这里展开。

所以在第一次遍历中，我们将使用 **fn1** 函数作为参数来调用 **identity function** 函数（为了方便，我们称之为 **I**）：

```
  // 恒等函数：I
  (...args) => accumulation(fn(args))

  // 第一步
  // 我们把 fn1 传给 accumulation 方法
  (...args) => accumulation(fn1(args))

  // 第二步
  // 这里我们用 I 接收 fn1 作为参数替代 accumulation
  (...args) => I(fn1(args))
```

耶，我们计算出了第一次遍历后新的 `accumulation` 方法。我们再来一次：

```
  (...args) => I(fn1(args)) // 新的 accumulation 方法

  // 第三步
  // 现在我们把 fn2 传给 accumulation 方法
  (...args) => accumulation(fn2(args))

  // 第四步
  // 我们来算出 accumulation 的当前值
  (...args) => I(fn1(fn2(args)))
```

我认为你应该理解了。现在只需要对 `fn3` 重复第三步和第四步，就可以把 `compose(fn1, fn2, fn3)(x)` 转为 `fn1(fn2(fn3(x)))` 了。

最后我们就可以像下面这样组合我们的 `map` 和 `filter` 了：

```
[1, 2, 3, 4, 5, 6]
  .reduce(compose(filterEven,
          mapDouble));
```

## 总结

我想你已经掌握了 **reducers**，如果还没有 — 你也已经学会了处理集合的抽象方法。Reducers 可以处理不同的数据结构。

你也学会了如何用 **transducers** 有效地进行计算。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
