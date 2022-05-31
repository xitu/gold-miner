> * 原文地址：[Generators in JavaScript: When should I use yield, and yield*?](https://medium.com/javascript-in-plain-english/generators-in-javascript-when-should-i-use-yield-and-yield-a5dbea6ad625)
> * 原文作者：[Heloise Parein](https://medium.com/@hparein)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/generators-in-javascript-when-should-i-use-yield-and-yield.md](https://github.com/xitu/gold-miner/blob/master/article/2020/generators-in-javascript-when-should-i-use-yield-and-yield.md)
> * 译者： [Isildur46](https://github.com/Isildur46)
> * 校对者： [Chorer](https://github.com/Chorer)，[Rachel Cao](https://github.com/rachelcdev)

# JavaScript 生成器：何时用 yield，何时用 yield* ？

![](https://cdn-images-1.medium.com/max/12000/1*svZ2D_mxiAEqmtqX73eG2g.jpeg)

尽管 ES6 发布已经有 5 年了，但并非每一个开发者都熟悉它的所有特性。这些基本都是较冷门的、不是每天都用的特性。没关系，即便是看上去无用的知识，也不一定就真的无用。这些冷门的 ES6 特性或许可以优雅地解决一些让你头疼的棘手难题。

其中一个就是生成器，尽管生成器十分强大，很多优秀的库都在内部使用它，但我们在日常代码中很少使用。我们大部分人至少对 `yield` 关键字都有一定了解了，但是了解 `yield*` 的人恐怕不会那么多了吧？

## 生成器

`yield` 和 `yield*` 这两个关键字都出现在生成器的上下文中，是不能脱离于生成器之外去理解和使用的。

生成器是一种可以生成值的序列的对象，它所生成的值序列可以像数组一样去进行迭代。准确地说，生成器是一种实现了迭代器和迭代协议的对象。

具体来说，由于生成器是迭代器，我们可以：

```js
const generator = ... // 我们后面再讨论如何创建生成器

generator.next();
generator.next();
generator.next();
generator.next();
```

又因为它们是可迭代对象，我们可以：

```js
const generator = ... // 稍安勿躁

for (const value of generator) {
  // ...
}
```

也许你可以从我省略掉的代码中推测，`yield` 肯定介入其中，参与了生成器输出内容的过程。

## 生成器函数

生成器是通过生成器函数来创建的。生成器函数通过 `function*` 或 `function *` 这种语法进行声明。

在生成器函数中，定义了将来生成器调用 `next` 函数时要返回的值。为了指定返回什么值，我们使用 `yield` 关键字：

```js
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

当调用 `next` 方式时，生成器内部会执行代码，直到遇到下一个 `yield` 表达式为止，它在此处停下并把表达式的值返回。

`yield` 实际上是一个双向通道。我们也可以利用它往生成器**传递**值。打个比方，我们想让生成器可以接收一些值作为输入，并在每次调用 `next` 方法时返回该值，那我们就可以像这样去使用 `yield`：

```js
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

你可能会发现第一次调用 `generator.next()` 有点奇怪，但这没写错。就像之前说的，当调用 `next` 函数时，生成器会一路执行，直到遇到一个 `yield` 表达式。我们在第一次调用时，是进入一个全新的生成器内部来运行。它一直运行直到遇到第一个 `yield`，它没有需要返回的内容，并且在此处暂停。第二次，我们带着一个值来调用它，它以这个值对变量 `a` 进行初始化，接着一路走下去，直到下一个 `yield`，并在此处返回 `a`，本例中是 `1`。每次继续调用，它都会输出（yields）`a` 的值。

## yield*

那 `yield*` 呢？在生成器函数中也可以使用 `yield*` ，但用处显然略有不同。

比如说你想创建一个生成器用于返回一个斐波那契数列，斐波那契数列定义如下：

* 第一个数是 0
* 第二个数是 1
* 之后的每一个数是前两个数之和

换言之，即：F(0) = 0; F(1) = 1; ... F(n) = F(n-1) + F(n-2);

你会创建怎样的生成器来生成这些数呢？你可能会想到用递归的方式。

```js
function* fibonacciGeneratorFunction() {
  yield 0;
  yield 1;
  ???
}

const fibonacciGenerator = fibonacciGeneratorFunction();
```

实际上我们希望在一个生成器里输出一些来自其它生成器的值。这时 `yield*` 就派上用场了：

```js
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

`yield*` 不仅可用于递归。它的常见用法是对其它生成器进行委托。这有一个 [MDN web docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield*) 上的简单例子：

```js
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

我希望本文能解释明白 `yield` 和 `yield*` 的运行逻辑。它们都在生成器上下文中使用，但是 `yield` 和 `yield*` 能够以不同的方式生成值。前者可以直接返回值或者将值传递给生成器，后者可以将值的生成过程委托给另一个生成器。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
