> * 原文地址：[Replace null with ES6 Symbols](https://javascript.plainenglish.io/replace-null-with-es6-symbols-c0e77d74542e)
> * 原文作者：[Robin Pokorny](https://medium.com/@robinpokorny)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/replace-null-with-es6-symbols.md](https://github.com/xitu/gold-miner/blob/master/article/2021/replace-null-with-es6-symbols.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)、[jaredliw](https://github.com/jaredliw)

# 如何使用 ES6 新增 Symbols 代替 null

![](https://cdn-images-1.medium.com/max/4480/1*cF5KQi37G9SnB99KyYLADQ.jpeg)

当我在做业余项目库时，我需要表示一个缺失的值。在过去，我习惯在设置中使用 `nullable` 方法，而当我想要更多的控制时，则使用 `Option` 方法。

在这种情况下，我觉得两者都不合适，所以我想出了一个不同的方法，并在本文中分享出来。

## `nullable` 方法的不足之处

`nullable` 方法表示当有一个值时，它是一个字符串、一个数字或一个对象；当没有值时，使用 `null` 或 `undefined`。

> **提示**：如果你在 `TypeScript` 中使用 `nullable` 类型，请确保开启了 [`strictNullChecks`](https://www.typescriptlang.org/tsconfig#strictNullChecks)。

这通常是可行的。

通常来说，有两种情况是不可以的：

1、这个值可以是 `null`，也可以是 `undefined`。这些都是有效的 JavaScript 代码，可以在很多场景使用它们。
2、你想添加一些高级逻辑，到处写 `x == null` 会很麻烦。

在我的示例中，我正在处理一个 `Promise` 的输出，它可以返回任何内容。而且我可以预见到，这两个空缺值最终都会被返回。

通常来说，问题 1 和 2 有相同的解决方案：使用一个实现 `Option` 类型的库。

## `Option` 方法的冗余之处

`Option` 类型有两种可能性：要么没有值（`None` 或 `Nothing`），要么有一个值（`Some` 或 `Just`）。

在 `JavaScript` 或 `TypeScript` 中，这意味着引入一个新的结构来包装这个值。最常见的是一个带有属性 `tag`（标签）的对象，定义了它可能是什么。

这就是你如何在 `TypeScript` 中快速实现 `Option` 方法：

```TypeScript
type Option<T> = { tag: 'none' } | { tag: 'some', value: T }
```

通常情况下，你会使用一个定义了类型的库，再附带使用一堆有用的工具。[这里有一个关于我最喜欢的 `fp-ts` 库中的 `Option` 介绍](https://dev.to/ryanleecode/practical-guide-to-fp-ts-option-map-flatten-chain-6d5)。

[我正在建立的这个库](https://github.com/robinpokorny/promise-throttle-all)很小，没有任何依赖，而且没有必要使用任何 `Option` 工具。因此，引入一个 `Option` 库将是多余的。

有一段时间，我在考虑对 `Option` 进行内联，也就是从头开始编码。对于我的用例来说，这只是几行而已。不过，这将使库的逻辑变得有点复杂。

然后，我有了一个更好的想法！

## 使用 Symbol 代替 null

回到 `Nullable`，无法解决的问题是 `null`（或 `undefined`）是全局的，它是一个等于自身的值，对每个人都是一样的。

如果你返回 `null`，我也返回 `null`，以后就不可能找到 `null` 的来源了。

换句话说，永远只有一个实例。为了解决这个问题，我们需要有一个新的 `null` 实例。

当然，我们可以使用一个空对象。在 `JavaScript` 中，每个对象都是一个新的实例，不等于任何其他对象。

但是，在 `ES6` 中，我们得到了一个新的基元：`Symbol`。（这里有一些[关于 `Symbols` 的介绍](https://hacks.mozilla.org/2015/06/es6-in-depth-symbols/)）

我所做的是使用 `Symbol` 表示一个新的常量，代表一个缺失的值。

```TypeScript
const None = Symbol(`None`)
```

让我们来看下有哪些好处：

* 它是一个简单的值，不需要封装
* 其他的都被当作数据来处理
* 这是一个私有的 `None`，不能在别处重新创建
* 它在我们的代码之外没有任何意义
* 标签使调试变得更容易

特别是第一点允许使用 `None` 作为 `null`。请看一些使用示例：

```TypeScript
const isNone = (value: unknown) => x === None

const hasNone = (arr: Array<unknown>) =>
  arr.some((x) => x === None)

const map = <T, S>(
  fn: (x: T) => S,
  value: T | typeof None
) => {
  if (value === None) {
    return None
  } else {
    return fn(value)
  }
}
```

## `Symbols` 通常当作是 `nulls`

`Symbols` 也有一些缺点。

首先，开发环境必须[支持 ES6 的 Symbols](https://caniuse.com/mdn-javascript_builtins_symbol)。在我看来这很罕见，这意味着 `Node.js` 版本不低于 `0.12`（不要与 `v12` 混淆）。

第二，存在着序列化或反序列化的问题。有趣的是，`Symbols` 的行为和 `undefined` 完全一样。

```TypeScript
JSON.stringify({ x: Symbol(), y: undefined })
// -> "{}"

JSON.stringify([Symbol(), undefined])
// -> "[null,null]"
```

所以，关于这个实例的信息当然会丢失。然而，由于它的行为类似于原生的缺失值：`undefined`，使得它很适合代表一个自定义的缺失值。

相比之下，`Option` 是基于结构而非实例的。任何 `tag` 属性设置为 `none` 的对象都被认为是无，这使得序列化和反序列化变得更加容易。

## 本文总结

我对这种模式相当满意。在不需要对属性进行高级操作的地方，这似乎是一个比 `null` 更安全的选择。

也许，如果这个自定义符号应该在模块或库外泄漏，我会避免它。

我特别喜欢用变量名和符号标签，我可以传达缺失值的领域含义。在我的项目库中，它代表着 `promise` 没有被解决。

```TypeScript
const notSettled = Symbol(`not-settled`)
```

代码中有可能出现不同领域含义的多个缺失值。

让我知道你对这种用法的看法：它是 `null` 的一个很好的替代吗？每个人都应该总是使用一个 `Option` 吗？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
