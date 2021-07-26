> * 原文地址：[Replace null with ES6 Symbols](https://javascript.plainenglish.io/replace-null-with-es6-symbols-c0e77d74542e)
> * 原文作者：[Robin Pokorny](https://medium.com/@robinpokorny)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/replace-null-with-es6-symbols.md](https://github.com/xitu/gold-miner/blob/master/article/2021/replace-null-with-es6-symbols.md)
> * 译者：
> * 校对者：

# Replace null with ES6 Symbols

![](https://cdn-images-1.medium.com/max/4480/1*cF5KQi37G9SnB99KyYLADQ.jpeg)

When I was working on my small side-project library, I needed to represent a missing value. In the past, I’d used the nullable approach in simple settings and Option (aka Maybe) when I wanted more control.

In this case, neither felt correct so I came up with a different approach I’d like to present.

## Why Nullable was not enough

Nullable means that when there is a value it is a string, a number, or an object. When there is no value, we use either `null` or `undefined`.

> **Tip:** if you work with nullable types in TypeScript, make sure you turn on the `[strictNullChecks](https://www.typescriptlang.org/tsconfig#strictNullChecks)`

This is often fine.

There are, in general, two cases when it’s not:

1. The value **can** be `null` or `undefined`. In the end, these are both valid JavaScript primitives and people can use them in many ways.
2. You want to add some advanced logic. Writing `x == null` everywhere gets cumbersome.

In my case I was handling an output of a Promise, that can return anything. And I could foresee that both of the ‘missing’ will be eventually returned.

In general, the problem 1 and 2 have the same solution: use a library that implements the Option type.

## Why Option was too much

Option (sometimes called Maybe) type has two possibilities: either there is no value ( `None` on `Nothing`) or there is a value ( `Some` or `Just`).

In JavaScript/TypeScript this means introducing a new structure that wraps the value. Most commonly an object with a property `tag` that defines what possibility it is.

This is how you could quickly implement Option in TypeScript:

```TypeScript
type Option<T> = { tag: 'none' } | { tag: 'some', value: T }
```

Usually, you would use a library that defines the type and a bunch of useful utils alongside. [Here is an intro to Option in my favourite fp-ts library](https://dev.to/ryanleecode/practical-guide-to-fp-ts-option-map-flatten-chain-6d5).

[**The library** I was building](https://github.com/robinpokorny/promise-throttle-all) was small, had zero dependencies, and there was no need for using any Option utility. Therefore, bringing in an Option library would be overkill.

For a while I was thinking about inlining the Option, that is coding it from scratch. For my use case that would be just a few lines. It would complicate the logic of the library a bit, though.

Then, I had a better idea!

## Symbol as the new null

Coming back to Nullable, the unsolvable problem is that `null` (or `undefined`) is global. It is one value equal to itself. It is the same for everybody.

If you return `null` and I return `null`, later, it is not possible to find out where the `null` comes from.

In other words, there is ever only one instance. To solve it, we need to have a new instance of `null`.

Sure, we could use an empty object. In JavaScript each object is a new instance that is not equal to any other object.

But hey, in ES6 we got a new primitive that does exactly that: Symbol. (Read some [introduction to Symbols](https://hacks.mozilla.org/2015/06/es6-in-depth-symbols/))

What I did was a new constant that represented a missing value, which was a symbol:

```TypeScript
const None = Symbol(`None`)
```

Let’s look at the benefits:

* It is a simple value, no wrapper needed
* Anything else is treated as data
* It’s a private None, the symbol cannot be recreated elsewhere
* It has no meaning outside our code
* The label makes debugging easier

That is great! Especially the first point allows using None as `null`. See some example use:

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

## Symbols are almost nulls

There are some disadvantages, too.

First, which is IMO rare, is that the environment has to [support ES6 Symbols](https://caniuse.com/mdn-javascript_builtins_symbol). That means Node.js >=0.12 (not to be confused with v12).

Second, there are problems with (de)serialisation. Funnily, Symbols behave exactly like `undefined`.

```TypeScript
JSON.stringify({ x: Symbol(), y: undefined })
// -> "{}"

JSON.stringify([Symbol(), undefined])
// -> "[null,null]"
```

So, the information about the instance is, of course, lost. Yet, since it then behaves like `undefined` -the native 'missing value')-makes it well suited for representing a custom 'missing value'.

In contrast, Option is based on structure not instances. Any object with a property `tag` set to `none` is considered None. This allows for easier serialisation and deserialisation.

## Summary

I’m rather happy with this pattern. It seems it’s a safer alternative to `null` in places where no advanced operations on the property are needed.

Maybe, I’d avoid it if this custom symbol should leak outside of a module or a library.

I especially like that with the variable name and the symbol label, I can communicate the domain meaning of the missing value. In my small library it represents that the promise is not settled:

```TypeScript
const notSettled = Symbol(`not-settled`)
```

Potentially, there could be multiple missing values for different domain meanings.

Let me know what you think of this use? Is it a good replacement for `null`? Should everybody always use an Option?

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
