> * 原文地址：[Monads For JavaScript Developers](https://js.plainenglish.io/monads-for-javascript-developers-af29819823c)
> * 原文作者：[MelkorNemesis](https://medium.com/@melkornemesis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/monads-for-javascript-developers.md](https://github.com/xitu/gold-miner/blob/master/article/2021/monads-for-javascript-developers.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[ZavierTang](https://github.com/ZavierTang)

# 面向 JavaScript 开发人员的 Monads

![](https://cdn-images-1.medium.com/max/5760/1*gA2dHvfpZEylFTBuiLiKxw.jpeg)

和别的程序员一样，我也很想知道 **Monads** 到底是什么。但每当我在网上搜索 Monads 的时候，都只会找到大量的 Monads 理论范畴文章，而其它的资源似乎也并没有什么参考意义。

为了搞清楚什么是 Monads，我花费了大量的时间精力。我开始去学习 Haskell，但在学了几个月后，我才突然意识到，大家都在 Monads 上面太小题大做了。如果你是一名 JavaScript 开发人员，那么你肯定每天都在使用它，只是你并没有意识到而已。

---

本文并不会提及太多有关 Monads 的理论范畴或 Haskell 的细节，但有一件事我们始终需要知道 —— 当我们在互联网上搜索 Monads 时，不能错过这个定义：

```
(>>=) :: m a -> (a -> m b) -> m b
```

这是 Haskell 中 `bind` 运算符的定义。不同的语言对这个操作有不同的叫法，但意思都是一样的。比如一些替代名称是 `chain`、`bind`、`flatMap`、`then`、`andThen`。

## Monadic 上下文

```
(>>=) :: m a -> (a -> m b) -> m b

m    :: monadic 上下文
a, b :: 上下文的值 (string, number, ..)
```

**Monadic 上下文（Monadic Context）** 只是一个盒子，它实现了使该盒子成为一个 Monad 所需的全部功能。一个很简单的（非 Monadic）盒子可能是这样的：

```js
const Box = val => ({ val }); 
const foo = Box("John");
```

这是一个只包装了值的盒子，该盒子没有任何功能，因为它没有任何方法实现。

> **要使某个东西成为一个 Monad，你必须使其表现得像一个 Monad。**

接着让我们回到 `(>>=) :: m a -> (a -> m b) -> m b`。`(>>=)` 用作 `m a >>= (a -> m b)` 的中缀运算符，而 `(>>=)` 运算的结果是 `m b`。

## 存在的问题

你有没有注意到我们有 `m a`，但是函数以 `a` 为参数？这就是 Monads 的意义所在。

`(>>=)` 操作是在 Monadic 上下文 `m a` 中取一个值展开它，所以我们只得到 `a`，再将其传递给函数 `(a -> m b)`。这并不奇怪，你还要自己制定这种行为准则，我们稍后会介绍。

## JavaScript 的 Promises

JavaScript 中的 Promises 类似于 Monads，更确切地说，他们都有 Monad 式（**Monad-ish**）行为。要成为 Monad，它还必须实现一个仿函数（**Functor**）和应用程序接口（**Applicative**）。我提这一点只是为了表述完整，但我们不会更深入地讨论这些。

JavaScript 的 **Promises** 使用 `.then()` 方法实现 Monadic 接口。我们来看以下示例：

```js
// p :: m a :: Promise { 42 }
const p = Promise.resolve(42);
```

这通常会创建一个箱子，在 **Promise** 中有一个值为 `42`。 
☝️ 这是我们的 `m a`。

接着我们有一个将数字除以二的函数，输入的内容没有包装在 **Promise** 中，但是返回的函数包装在 **Promise** 中。

```js
// divideByTwo :: (a -> m b)
const divideByTwo = val => Promise.resolve(val / 2);
```

☝️ 这就是我们的 `(a -> m b)`。

再次注意，我们在 **Promise** 中有一个值 `42`，但是函数 `divideByTwo`  接受一个未包装的值，并且我们仍然可以链接这些。

```js
// p :: m a :: Promise { 42 }
const p = Promise.resolve(42);
// p2 :: m a :: Promise { 21 }
const p2 = p.then(divideByTwo);
// p3 :: m a :: Promise { 10.5 }
const p3 = p2.then(divideByTwo);
```

或者更明显的是：

```js
// p :: m a :: Promise { 10.5 }
const p4 = p.then(divideByTwo).then(divideByTwo);
```

**这是 Monads 最重要的特性。**

箱子中有一个值 —— `Promise { 42 }`，你有一个采用展开值 `42` 的函数。`m a` 与 `a` 的类型不匹配，你仍然可以将该函数应用于封装的值。

**那怎么可能呢？**

这是因为 **Promise** 实现 `then` 方法并以这种方式工作。大多数时候，在 **Promise** 中运行的代码是异步的。但是 **Promise** 的单步行为使得它可以链接一系列函数。

Monads 抽象出辅助数据管理、控制流或函数副作用（**side-effects**），将可能复杂的函数序列转换成简明的管道。

## 自定义 Monad 式类

我使用 TypeScript 整理了一个非常简单的 Monad 式类例子，它不产生任何函数副作用，并且允许链接函数。

```ts
class Dummy<T> {
  constructor(private val: T) {}

  chain<TResult>(fn: (value: T) => Dummy<TResult>): Dummy<TResult> {
    return fn(this.val);
  }

  static unit<T>(val: T): Dummy<T> {
    return new Dummy(val);
  }
}

const d = new Dummy(41);
d.chain(val => new Dummy(val + 1))
 .chain(val => new Dummy("The answer is: " + val));
```

## Monad 规则

具有 Monad 特性的类必须遵循一些规则。

* 左单位元
* 右单位元
* 可结合性

你可以在网上查找更多有关信息。在这里放一段代码，以证明 Dummy 类遵循这些规则。

```js
const m = Dummy.unit(1);
const f = (val: number) => new Dummy(val + 1);
const g = (val: number) => new Dummy(val + 2);

// 1. 左单位元
Dummy.unit(1).chain(f) ==== f(1)

// 2. 右单位元
m.chain(Dummy.unit) ==== m

// 3. 可结合性
const m1 = Dummy.unit(1);
m.chain(f).chain(g) ==== m.chain(val => f(val).chain(g)
```

`==` 或 `===` 在这里不起作用，因为对象引用是不同的。为此，我使用不存在的 `====`，但可以理解为 Monad 式类的对象的内部值。

## 本文总结

我希望本文能使你了解 Monads，如果你是 JavaScript 开发人员，则每天都会使用它们。例如将 **Promise** 中装箱的值提供给需要未包装值的函数，并再次返回包装在 **Promise** 中的新值。

## 参考资料

* [https://en.wikipedia.org/wiki/Monad_(functional_programming)](https://en.wikipedia.org/wiki/Monad_(functional_programming))

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
