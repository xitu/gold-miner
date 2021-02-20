> * 原文地址：[Monads For JavaScript Developers](https://js.plainenglish.io/monads-for-javascript-developers-af29819823c)
> * 原文作者：[MelkorNemesis](https://medium.com/@melkornemesis)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/monads-for-javascript-developers.md](https://github.com/xitu/gold-miner/blob/master/article/2021/monads-for-javascript-developers.md)
> * 译者：
> * 校对者：

# Monads For JavaScript Developers

![](https://cdn-images-1.medium.com/max/5760/1*gA2dHvfpZEylFTBuiLiKxw.jpeg)

Like every other programmer, I wanted to know, what **Monads** are. But every time you search for Monads on the internet, you get flooded with category theory papers. And other resources don’t seem to make much sense either.

To learn what Monads are, I did it the hard way. I started learning Haskell. Only to realize, after few months, that people make too much of a fuss of Monads. If you’re a JavaScript developer, you’re most definitely using them daily. You’re just not aware of it.

---

We won’t be getting into much detail about the category theory or Haskell, but there’s one thing you need to know. When you search for Monads on the internet, you cannot miss this definition:

```
(>>=) :: m a -> (a -> m b) -> m b
```

This is the definition of a `bind` operator in Haskell. Different languages have different names for this operation, but they all mean the same thing. Some of the alternative names are `chain`, `bind`, `flatMap`, `then`, `andThen`.

## Monadic Context

```
(>>=) :: m a -> (a -> m b) -> m b

m    :: monadic context
a, b :: value inside the context (string, number, ..)
```

**Monadic context** is just a box that implements all that is needed for that box to be a Monad. A very simple (non-monadic) box could be something like this:

```
const Box = val => ({ val }); 
const foo = Box("John");
```

This is a box—just a wrapped value. The box does not have any behavior because it does not have any methods.

> **For something to be a Monad, you must make it behave like a Monad yourself.**

So let’s get back to the (>>=) :: m a -> (a -> m b) -> m b. The `(>>=)` is used as an infix operator: `m a >>= (a -> m b)`. and the result of the `(>>=)` operation is `m b`.

## The Problem

Have you noticed that we have `m a`, but the function takes `a` as an argument? That’s what Monads are about.

The `(>>=)` operation is about taking a value in a monadic context `m a`, unwrapping it, so we get just the `a` and pipelining that to the function `(a -> m b)`. And it’s not magic. You have to code that behavior yourself. We’ll see that later on.

## JavaScript Promises Are Similar To Monads

Better said, they have **Monad-ish** behavior. For something to be a Monad, it also has to implement a **Functor** and **Applicative** interfaces. I’m mentioning this just for the sake of completeness, but we will not get any deeper into that.

JavaScript **Promises** implement the monadic interface with `.then()` method. Let’s see about that.

```js
// p :: m a :: Promise { 42 }
const p = Promise.resolve(42);
```

This basically creates a box. We have a value `42`, inside the **Promise**. 
☝️ This is our `m a`.

Then we have a function that divides a number by two. The input is not wrapped in a **Promise**. But the returned function is wrapped in a **Promise**.

```js
// divideByTwo :: (a -> m b)
const divideByTwo = val => Promise.resolve(val / 2);
```

☝️ This is our `(a -> m b)`.

Again, notice that we have a value `42` inside a **Promise**, but the function `divideByTwo` accepts an unwrapped value. And we’re still able to chain these.

```js
// p :: m a :: Promise { 42 }
const p = Promise.resolve(42);
// p2 :: m a :: Promise { 21 }
const p2 = p.then(divideByTwo);
// p3 :: m a :: Promise { 10.5 }
const p3 = p2.then(divideByTwo);
```

Or more obviously:

```js
// p :: m a :: Promise { 10.5 }
const p4 = p.then(divideByTwo).then(divideByTwo);
```

**This is the most important feature of Monads.**

You have a value in a box — `Promise { 42 }`. You have a function that takes the unwrapped value — `42`. The types don’t match — `m a` vs. `a`. And you’re still able to apply the function to the boxed value.

#### How Is That Possible

Because the **Promise** implements the `then` method to work that way. Most of the time, the code running inside a **Promise** is asynchronous. But the **Promise’s** monad-ish behavior makes it possible for chaining a sequence of functions anyway.

**Monads abstract away auxiliary data management, control flow, or side-effects.** Turning a possibly complicated sequence of functions into a succinct pipeline.

## Custom Monad-ish Class

I put together a very simple example of a monad-ish class in TypeScript. It does not perform any side-effect but allows for the chaining of functions.

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

## Monad Laws

There’re some laws that a class with Monad behavior must follow.

* left identity
* right identity
* associativity

You can read more about these on the internet. I’ll drop here a snippet of code proving that the Dummy class follows these rules.

```js
const m = Dummy.unit(1);
const f = (val: number) => new Dummy(val + 1);
const g = (val: number) => new Dummy(val + 2);

// 1. left identity
Dummy.unit(1).chain(f) ==== f(1)

// 2. right identity
m.chain(Dummy.unit) ==== m

// 3. associativity
const m1 = Dummy.unit(1);
m.chain(f).chain(g) ==== m.chain(val => f(val).chain(g)
```

`==` or `===` won’t work here; the object references are different. For that purpose, I’m using `====` that does not exist, but understand it as comparing the inner value of the monad-ish object.

## Wrapping up

I hope this sheds some light on what Monads are. If you’re a JavaScript developer, you’re using them daily. Feeding a value boxed in a **Promise** to a function expecting the unwrapped value. And returning a new value wrapped in the **Promise** again.

## Resources

* (A) [https://en.wikipedia.org/wiki/Monad_(functional_programming)](https://en.wikipedia.org/wiki/Monad_(functional_programming))

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
