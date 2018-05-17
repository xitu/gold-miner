> * 原文地址：[What are JavaScript Generators and how to use them](https://codeburst.io/what-are-javascript-generators-and-how-to-use-them-c6f2713fd12e)
> * 原文作者：[Vladislav Stepanov](https://codeburst.io/@vldvel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/what-are-javascript-generators-and-how-to-use-them.md](https://github.com/xitu/gold-miner/blob/master/TODO1/what-are-javascript-generators-and-how-to-use-them.md)
> * 译者：
> * 校对者：

# What are JavaScript Generators and how to use them

![](https://cdn-images-1.medium.com/max/2000/1*9XJAQFEiYvd2i1hv9tgwXA.jpeg)

In this article, we’re going to take a look at the generators that were introduced in ECMAScript 6\. We’ll see what it is and then look at some examples of their use.

### What are JavaScript Generators?

Generators are functions that you can use to control the iterator. They can be suspended and later resumed at any time.

If that doesn’t make sense, then let’s look at some examples that will explain what generators are, and what’s the difference between a generator and an iterator like _for-loop_.

This is a _for-loop_ loop that returns a heap of values immediately. What does this code do? — simply repeats numbers from 0 to 5.

```
for (let i = 0; i < 5; i += 1) {
  console.log(i);
}
// this will return immediately 0 -> 1 -> 2 -> 3 -> 4
```

Now let’s look at the generator function.

```
function * generatorForLoop(num) {
  for (let i = 0; i < num; i += 1) {
    yield console.log(i);
  }
}

const genForLoop = generatorForLoop(5);

genForLoop.next(); // first console.log - 0
genForLoop.next(); // 1
genForLoop.next(); // 2
genForLoop.next(); // 3
genForLoop.next(); // 4
```

What does it do? In fact, it just wraps our for-loop from the example above with some changes. But the most significant change is that it does not ring immediately. And this is the most important feature in generators — we can get the next value in only when we really need it, not all the values at once. And in some situations it can be very convenient.

### The syntax generators

How can we declare the generator function? There is a list of possible ways to do this, but the main thing is to add an asterisk after the function keyword.

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

As you can see from the example above, we cannot create a generator using the arrow function.

Next-the generator as a method. It is declared in the same way as functions.

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

#### Yield

Now let’s take a look at the new keyword _yield_. It’s a bit like _return_, but not. _Return_ simply returns the value after the function call, and it will not allow you to do anything else after the _return_ statement.

```
function withReturn(a) {
  let b = 5;
  return a + b;
  b = 6; // we will never re-assign b
  return a * b; // and will never return new value
}

withReturn(6); // 11
withReturn(6); // 11
```

_Yield_ works different.

```

function * withYield(a) {
  let b = 5;
  yield a + b;
  b = 6; // it will be re-assigned after first execution
  yield a * b;
}

const calcSix = withYield(6);

calcSix.next().value; // 11
calcSix.next().value; // 36
```

_Yield_ returns a value only once, and the next time you call the same function it will move on to the next _yield_ statement.

Also in generators we always get the object as output. It always has two properties _value_ and _done_. And as you can expect, _value_ - returned value, and _done_ shows us whether the generator has finished its job or not.

```
function * generator() {
  yield 5;
}

const gen = generator();

gen.next(); // {value: 5, done: false}
gen.next(); // {value: undefined, done: true}
gen.next(); // {value: undefined, done: true} - all other calls will produce the same result
```

Not only can _yield_ be used in generators, _return_ will also return the same object to you, but after you reach the first _return_ statement the generator will finish it’s job.

```
function * generator() {
  yield 1;
  return 2;
  yield 3; // we will never reach this yield
}

const gen = generator();

gen.next(); // {value: 1, done: false}
gen.next(); // {value: 2, done: true}
gen.next(); // {value: undefined, done: true}
```

#### Yield delegator

Y_ield_ with asterisk can delegate it’s work to another generator. This way you can chain as many generators as you want.

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

Before we move on to methods, let’s take a look at some behavior that may seem rather strange the first time.

This is normal code without any errors, which shows us that _yield_ can return passed value in the call method _next()_.

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

As you can see in this example _yield_ by default is _undefined_ but if we will pass any value and just calls _yield_ it will return us our passed value. We will use this feature soon.

#### Methods and initialization

Generators are reusable, but to be so — you need to initialize them, fortunately it is quite simple.

```
function * generator(arg = 'Nothing') {
  yield arg;
}

const gen0 = generator(); // OK
const gen1 = generator('Hello'); // OK
const gen2 = new generator(); // Not OK

generator().next(); // It will work, but every time from the beginning
```

So _gen0_ and _gen1_ are won’t affect each other. And _gen2_ won’t work at all, even more you will get an error. Initialization is important to keep the state of progress.

Now let’s look at the methods that generators give us.

**Method _next():_**

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
gen.next(); // {value: undefined, done: true} and all next calls will return the same output
```

This is the main method that you will use most often. It gives us the next output object every time we call it. And when it is done, _next()_ set the _done_ property to _true_ and _value_ to _undefined_.

Not only _next()_ we can use to iterate generator. But using _for-of loop_ we get all the values (not the object) of our generator.

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

This will not work with _for-in loop_ and you can’t get access to properties by just typing number — _generator[0]_ = undefined.

**Method _return():_**

```
function * generator() {
  yield 1;
  yield 2;
  yield 3;
}

const gen = generator();

gen.return(); // {value: undefined, done: true}
gen.return('Heeyyaa'); // {value: "Heeyyaa", done: true}

gen.next(); // {value: undefined, done: true} - all next() calls after return() will return the same output

```

_Return()_ will ignore any code in the generator function that you have. But will set the value based on a passed argument and set _done_ to be true. Any calls _next()_ after _return()_ will return done-object.

**Method _throw():_**

```
function * generator() {
  yield 1;
  yield 2;
  yield 3;
}

const gen = generator();

gen.throw('Something bad'); // Error Uncaught Something bad
gen.next(); // {value: undefined, done: true}
```

It’s easy one all is _throw()_ do — just throws the error. We can handle it using _try — catch_.

#### Implementation of custom methods

We can’t directly access the _Generator_ constructor, so we need to figure out how to add new methods. That’s what I do, but you can choose a different path.

```
function * generator() {
  yield 1;
}

generator.prototype.__proto__; // Generator {constructor: GeneratorFunction, next: ƒ, return: ƒ, throw: ƒ, Symbol(Symbol.toStringTag): "Generator"}

// as Generator is not global variable we have to write something like this
generator.prototype.__proto__.math = function(e = 0) {
  return e * Math.PI;
}

generator.prototype.__proto__; // Generator {math: ƒ, constructor: GeneratorFunction, next: ƒ, return: ƒ, throw: ƒ, …}

const gen = generator();
gen.math(1); // 3.141592653589793
```

#### The use of generators!

Previously, we used generators with a known number of iterations. But what if we don’t know how many iterations are needed. To solve this problem, it is enough to create an infinite loop in the function generator. The example below demonstrates this for a function that returns a random number.

```
function * randomFrom(...arr) {
  while (true)
    yield arr[Math.floor(Math.random() * arr.length)];
}

const getRandom = randomFrom(1, 2, 5, 9, 4);

getRandom.next().value; // returns random value
```

It was easy, as for the more complex functions, for example, we can write a function of the throttle. If you don’t know what it is, there’s a [great article](https://medium.com/@_jh3y/throttling-and-debouncing-in-javascript-b01cad5c8edf) about it.

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

But what about something more useful in terms of using generators? If you’ve ever heard of recursions I’m sure you’ve also heard of [Fibonacci numbers](https://en.wikipedia.org/wiki/Fibonacci_number). Usually it is solved with recursion, but with the help of a generator we can write it this way:

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

There is no need of recursion more! And we can get the next number, when we really need them.

#### The use of generators with HTML

Since we are talking about JavaScript the most obvious way to use the generator is to perform some actions with HTML.

So, suppose we have some number of HTML blocks that we want to go through, we can easily achieve this with a generator, but keep in mind that there are many more possible ways to do this without generators.

This is done with a small amount of code.

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

In fact, only five lines of logic.

#### That’s it!

There are many more possible ways to use generators. For example, they can be useful when working with asynchronous operations. Or iterate through an on-demand item loop.

I hope this article has helped you better understand JavaScript generators.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
