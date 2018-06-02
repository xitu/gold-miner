> * 原文地址：[What are JavaScript Generators and how to use them](https://codeburst.io/what-are-javascript-generators-and-how-to-use-them-c6f2713fd12e)
> * 原文作者：[Vladislav Stepanov](https://codeburst.io/@vldvel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-are-javascript-generators-and-how-to-use-them.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-are-javascript-generators-and-how-to-use-them.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：

# 什么是 JavaScript 生成器？如何使用生成器？

![](https://cdn-images-1.medium.com/max/2000/1*9XJAQFEiYvd2i1hv9tgwXA.jpeg)

在本文中，我们将了解 ECMAScript 6 中引入的生成器（Generator）。先看一看它究竟是什么，然后用几个示例来说明它的用法。

### 什么是 JavaScript 生成器？

生成器是一种可以用来控制迭代器的（iterator）函数，它可以随时暂停，并可以在任意时候恢复。

上面的描述没法说明什么，让我们来看一些例子，解释什么是生成器，以及生成器与 for 循环之类的迭代器有什么区别。

下面是一个 for 循环的例子，它会在执行后立刻返回一些值。这段代码其实就是简单地生成了 0-5 这些数字。

```
for (let i = 0; i < 5; i += 1) {
  console.log(i);
}
// 它将会立刻返回 0 -> 1 -> 2 -> 3 -> 4
```

现在看看生成器函数。

```
function * generatorForLoop(num) {
  for (let i = 0; i < num; i += 1) {
    yield console.log(i);
  }
}

const genForLoop = generatorForLoop(5);

genForLoop.next(); // 首先 console.log - 0
genForLoop.next(); // 1
genForLoop.next(); // 2
genForLoop.next(); // 3
genForLoop.next(); // 4
```

它做了什么？它实际上只是对上面例子中的 for 循环做了一点改动，但产生了很大的变化。这种变化是由于生成器最重要的特性造成的 - 只有在需要的时候它才会产生下一个值，而不会一次性产生所有的值。在某些情景下，这种特性十分方便。

### 生成器语法

如何定义一个生成器函数呢？下面列出了各种可行的定义方法，不过万变不离其宗的是在函数关键词后加上一个星号。

```
function * generator () {}
function* generator () {}
function *generator () {}

let generator = function * () {}
let generator = function* () {}
let generator = function *() {}

let generator = *() => {} // SyntaxError
let generator = ()* => {} // SyntaxError
let generator = (*) => {} // SyntaxError
```

如上面的例子所示，我们并不能使用箭头函数来创建一个生成器。

以下例子为将生成器作为方法（method）创建。定义方法与定义函数的方式是一样的。

```
class MyClass {
  *generator() {}
  * generator() {}
}

const obj = {
  *generator() {}
  * generator() {}
}
```

#### yield

现在让我们一起看看新的关键词 `yield`。它有些类似 `return`，但又不完全相同。`return` 会在完成函数调用后简单地将值返回，在 `return` 语句之后你无法进行任何操作。

```
function withReturn(a) {
  let b = 5;
  return a + b;
  b = 6; // 不可能重新定义 b 了
  return a * b; // 这儿新的值没可能返回了
}

withReturn(6); // 11
withReturn(6); // 11
```

而 `yield` 的工作方式却不同。

```

function * withYield(a) {
  let b = 5;
  yield a + b;
  b = 6; // 在第一次调用后仍可以重新定义变量
  yield a * b;
}

const calcSix = withYield(6);

calcSix.next().value; // 11
calcSix.next().value; // 36
```

`yield` 每次都会返回一个值，在你再次调用同一个函数的时候，它会执行至下一个 `yield` 语句处。

在生成器中，我们通常会在输出时得到一个对象。这个对象有两个属性：`value` 与 `done`。如你所想，`value` 为返回值，`done` 则会显示生成器是否完成了它的工作。

```
function * generator() {
  yield 5;
}

const gen = generator();

gen.next(); // {value: 5, done: false}
gen.next(); // {value: undefined, done: true}
gen.next(); // {value: undefined, done: true} - 之后的任何调用都会返回相同的结果
```

在生成器中，不仅可以使用 `yield`，也可以使用 `return` 来返回同样的对象。但是，在函数执行到第一个 `return` 语句的时候，生成器将结束它的工作。

```
function * generator() {
  yield 1;
  return 2;
  yield 3; // 到不了这个 yield 了
}

const gen = generator();

gen.next(); // {value: 1, done: false}
gen.next(); // {value: 2, done: true}
gen.next(); // {value: undefined, done: true}
```

#### yield 委托迭代

带星号的 `yield` 可以将它的工作委托给另一个生成器。通过这种方式，你就能将多个生成器连接在一起。

```
function * anotherGenerator(i) {
  yield i + 1;
  yield i + 2;
  yield i + 3;
}

function * generator(i) {
  yield* anotherGenerator(i);
}

var gen = generator(1);

gen.next().value; // 2
gen.next().value; // 3
gen.next().value; // 4
```

在开始下一节前，我们先观察一个第一眼看上去比较奇特的行为。

下面是正常的代码，不会报出任何错误，这表明 `yield` 可以在 `next()` 方法中返回传递的值：

```
function * generator(arr) {
  for (const i in arr) {
    yield i;
    yield yield;
    yield(yield);
  }
}

const gen = generator([0,1]);

gen.next(); // {value: "0", done: false}
gen.next('A'); // {value: undefined, done: false}
gen.next('A'); // {value: "A", done: false}
gen.next('A'); // {value: undefined, done: false}
gen.next('A'); // {value: "A", done: false}
gen.next(); // {value: "1", done: false}
gen.next('B'); // {value: undefined, done: false}
gen.next('B'); // {value: "B", done: false}
gen.next('B'); // {value: undefined, done: false}
gen.next('B'); // {value: "B", done: false}
gen.next(); // {value: undefined, done: true}
```

在这个例子中，你可以看到 `yield` 默认是 `undefined`，但如果我们在调用 `yield` 时传递了任何值，它就会返回我们传入的值。我们将很快利用这个特性。

#### 初始化与方法

生成器是可以被复用的，但是你需要对它们进行初始化。还好初始化的方法十分简单。

```
function * generator(arg = 'Nothing') {
  yield arg;
}

const gen0 = generator(); // OK
const gen1 = generator('Hello'); // OK
const gen2 = new generator(); // 不 OK

generator().next(); // 可以运行，但每次都会从头开始运行
```

如上所示，`gen0` 与 `gen1` 不会互相影响，`gen2` 完全不会运行（会报错）。因此初始化对于保证程序流程的状态是十分重要的。

下面让我们一起看看生成器给我们提供的方法。

**next() 方法**

```
function * generator() {
  yield 1;
  yield 2;
  yield 3;
}

const gen = generator();

gen.next(); // {value: 1, done: false}
gen.next(); // {value: 2, done: false}
gen.next(); // {value: 3, done: false}
gen.next(); // {value: undefined, done: true} 之后所有的 next 调用都会返回同样的输出
```

这是最常用的方法。它会在被调用时每次返回一个 next 对象。在生成器工作结束时，`next()` 会将 `done` 属性设为 `true`，`value` 属性设为 `undefined`。

我们不仅可以用 `next()` 来迭代生成器，还可以用 `for of` 循环来一次得到生成器所有的值（而不是对象）。

```
function * generator(arr) {
  for (const el in arr)
    yield el;
}

const gen = generator([0, 1, 2]);

for (const g of gen) {
  console.log(g); // 0 -> 1 -> 2
}

gen.next(); // {value: undefined, done: true}
```

但它不适用于 `for in` 循环，并且不能直接用数字下标来访问属性：`generator[0] = undefined`。

**return() 方法**

```
function * generator() {
  yield 1;
  yield 2;
  yield 3;
}

const gen = generator();

gen.return(); // {value: undefined, done: true}
gen.return('Heeyyaa'); // {value: "Heeyyaa", done: true}

gen.next(); // {value: undefined, done: true} - 在 return() 之后的所有 next() 调用都会返回相同的输出

```

`return()` 将会忽略生成器中的任何代码。它会根据传值设定 `value`，并将 `done` 设为 `true`。任何在 `return()` 之后进行的 `next()` 调用都会返回 done 对象。

**throw() 方法**

```
function * generator() {
  yield 1;
  yield 2;
  yield 3;
}

const gen = generator();

gen.throw('Something bad'); // 会报错 Error Uncaught Something bad
gen.next(); // {value: undefined, done: true}
```

`throw()` 做的事非常简单 - 就是抛出错误。我们可以用 `try-catch` 来处理。

#### 自定义方法的实现

由于我们无法直接访问 `Generator` 的 constructor，因此如何增加新的方法需要另外说明。下面是我的方法，你也可以用不同的方式实现：

```
function * generator() {
  yield 1;
}

generator.prototype.__proto__; // Generator {constructor: GeneratorFunction, next: ƒ, return: ƒ, throw: ƒ, Symbol(Symbol.toStringTag): "Generator"}

// 由于 Generator 不是一个全局变量，因此我们只能这么写：
generator.prototype.__proto__.math = function(e = 0) {
  return e * Math.PI;
}

generator.prototype.__proto__; // Generator {math: ƒ, constructor: GeneratorFunction, next: ƒ, return: ƒ, throw: ƒ, …}

const gen = generator();
gen.math(1); // 3.141592653589793
```

#### 生成器的作用

在前面，我们用了已知迭代次数的生成器。但如果我们不知道要迭代多少次会怎么样呢？为了解决这个问题，需要在生成器函数中创建一个无限循环。下面以一个会返回随机数的函数为例进行演示：

```
function * randomFrom(...arr) {
  while (true)
    yield arr[Math.floor(Math.random() * arr.length)];
}

const getRandom = randomFrom(1, 2, 5, 9, 4);

getRandom.next().value; // 返回随机数
```

这是个简单的例子。下面来举一些更复杂的函数为例，我们要写一个节流（throttle）函数。如果你还不知道节流函数是什么，请参阅[这篇文章](https://medium.com/@_jh3y/throttling-and-debouncing-in-javascript-b01cad5c8edf)。
```
function * throttle(func, time) {
  let timerID = null;
  function throttled(arg) {
    clearTimeout(timerID);
    timerID = setTimeout(func.bind(window, arg), time);
  }
  while (true)
    throttled(yield);
}

const thr = throttle(console.log, 1000);

thr.next(); // {value: undefined, done: false}
thr.next('hello'); // {value: undefined, done: false} + 1s after -> 'hello'
```

还有没有更好的利用生成器的例子呢？如果你了解递归，那你肯定听过[斐波那契数列](https://en.wikipedia.org/wiki/Fibonacci_number)。通常我们是用递归来解决这个问题的，但有了生成器后，可以这样写：

```
function * fibonacci(seed1, seed2) {
  while (true) {
    yield (() => {
      seed2 = seed2 + seed1;
      seed1 = seed2 - seed1;
      return seed2;
    })();
  }
}

const fib = fibonacci(0, 1);
fib.next(); // {value: 1, done: false}
fib.next(); // {value: 2, done: false}
fib.next(); // {value: 3, done: false}
fib.next(); // {value: 5, done: false}
fib.next(); // {value: 8, done: false}
```

不再需要递归了！我们可以在需要的时候获得数列中的下一个数字。

#### The use of generators with HTML

既然是讨论 JavaScript，那使用生成器的最明确的方法就是操作 HTML。

假设有一些 HTML 块需要处理，可以使用生成器来轻松实现。（当然除了生成器之外还有很多方法可以做到）

我们只需要少许代码就能完成此需求。

```
const strings = document.querySelectorAll('.string');
const btn = document.querySelector('#btn');
const className = 'darker';

function * addClassToEach(elements, className) {
  for (const el of Array.from(elements))
    yield el.classList.add(className);
}

const addClassToStrings = addClassToEach(strings, className);

btn.addEventListener('click', (el) => {
  if (addClassToStrings.next().done)
    el.target.classList.add(className);
});
```

仅有 5 行逻辑代码。

#### 总结

还有更多使用生成器的方法。例如，在进行异步操作或者按需循环时生成器也非常有用。

我希望这篇文章能帮你更好地理解 JavaScript 生成器。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
