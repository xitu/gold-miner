> * 原文地址：[Generators in JavaScript: When should I use yield, and yield*?](https://medium.com/javascript-in-plain-english/generators-in-javascript-when-should-i-use-yield-and-yield-a5dbea6ad625)
> * 原文作者：[Heloise Parein](https://medium.com/@hparein)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/generators-in-javascript-when-should-i-use-yield-and-yield.md](https://github.com/xitu/gold-miner/blob/master/article/2020/generators-in-javascript-when-should-i-use-yield-and-yield.md)
> * 译者：
> * 校对者：

# Generators in JavaScript: When should I use yield, and yield*?

![](https://cdn-images-1.medium.com/max/12000/1*svZ2D_mxiAEqmtqX73eG2g.jpeg)

Even five years after the release of ES6, there are still some aspects of it that not every JavaScript developer is familiar with. These are usually the sides of it that are not used in every day code. That is fine. But even seemingly useless knowledge is never actually useless. This ES6 feature that no one knows about might be the elegant solution to that one tricky problem that has been causing you headaches.

One of these features is generators. Even though extremely powerful, generators are mostly buried deep inside useful libraries, but rarely used in the day-to-day programming. Still, most of us have at least a vague idea of what the `yield` keyword does. Can you say that much of `yield*`?

## Generators

These two keywords, `yield` and `yield*`, appear in the context of generators, and can’t be understood outside of it.

A generator is an object that can produce a sequence of values but can also be iterated over like an array. To use more precise terms, a generator is an object that implements the iterator and the iterable protocols.

Concretely, because generators are iterators, we can do this:

```
const generator = ... // we will see later how to create a generator

generator.next();
generator.next();
generator.next();
generator.next();
```

And because they also are iterables we can do this:

```
const generator = ... // a bit of patience

for (const value of generator) {
  // ...
}
```

As you might have guessed from the part I have left out, `yield` intervenes in the creation of a generator.

## Generator Functions

Generators are created using generator functions. These functions are declared using `function*` or `function *`.

In a generator function you define the values that are going to be returned when the `next` function is called on the generator. To do so, you use the keyword `yield` :

```
function* generatorFunction() {
  yield 1;
  yield 2;
  yield 3;
}

const generator = generatorFunction();

generator.next(); // { value: 1, done: false }
generator.next(); // { value: 2, done: false }
generator.next(); // { value: 3, done: false }
generator.next(); // { value: undefined, done: true }
```

When the `next` method is called, the generator is executed until the next `yield` expression and returns the specified value.

`yield` is actually a two-way street. You can also use it to **pass** value to your generator. Let’s say you want a generator that can receive some value as input to then return this value every time the `next` method is called. You would do it by using `yield` like this:

```
function* generatorFunction() {
  const a = yield;

  while(true) {
   yield a;
  }
}

const generator = generatorFunction();

generator.next();
generator.next(1); // { value: 1, done: false }
generator.next(); // { value: 1, done: false }
generator.next(); // { value: 1, done: false }
```

You might find the first call `generator.next()` weird but it is not a mistake. As said earlier, when the `next` function is called, the generator is executed until the next `yield` expression. The first time we call it on our brand new generator, it runs until the first `yield`, has nothing to return so waits there. The second time, we call it with a value, it initialises the variable `a` to this value and goes to the next `yield`, where it returns `a`, in our case `1`. For every call afterwards, it yields the value of `a`.

## yield*

What about `yield*`? `yield*` is also being used in generator functions, but of course to achieve something different.

Imagine you want to create a generator that returns the Fibonacci numbers. As a reminder, Fibonacci numbers are defined as follows:

* the first one is 0
* the second one is 1
* after this each number is the sum of the two previous ones

In other words: F(0) = 0; F(1) = 1; ... F(n) = F(n-1) + F(n-2);

How would you create a generator generating these values? You would probably want to do it recursively.

```
function* fibonacciGeneratorFunction() {
  yield 0;
  yield 1;
  ???
}

const fibonacciGenerator = fibonacciGeneratorFunction();
```

We actually want to yield the values of an other generator, inside our generator. This is where `yield*` comes in:

```
function* fibonacciGeneratorFunction(a = 0, b = 1) {
  yield a;   
  yield* fibonacciGeneratorFunction(b, b + a);
}

const fibonacciGenerator = fibonacciGeneratorFunction();

fibonacciGenerator.next(); // { value: 1, done: false }
fibonacciGenerator.next(); // { value: 1, done: false }
fibonacciGenerator.next(); // { value: 2, done: false }
fibonacciGenerator.next(); // { value: 3, done: false }
fibonacciGenerator.next(); // { value: 5, done: false }
```

`yield*` isn’t only used in recursive cases. It generally enables you to delegate to another generator. A simple example from the [MDN web docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield*) is:

```
function* g1() {
  yield 2;
  yield 3;
  yield 4;
}

function* g2() {
  yield 1;
  yield* g1();
  yield 5;
}

const iterator = g2();

console.log(iterator.next()); // {value: 1, done: false}
console.log(iterator.next()); // {value: 2, done: false}
console.log(iterator.next()); // {value: 3, done: false}
console.log(iterator.next()); // {value: 4, done: false}
console.log(iterator.next()); // {value: 5, done: false}
console.log(iterator.next()); // {value: undefined, done: true}
```

---

I hope this article unveiled the mystery of `yield` and `yield*`. While both are used in the context of generator, `yield` and `yield*` enable you to generate values differently. The first one lets you return values directly or provide them to your generator. The second one lets you delegate the value generation to another generator.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
