> * 原文地址：[Javascript - Generator-Yield/Next & Async-Await](https://codeburst.io/javascript-generator-yield-next-async-await-e428b0cb52e4)
> * 原文作者：[Deepak Gupta](https://codeburst.io/@ideepak.jsd)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-generator-yield-next-async-await.md](https://github.com/xitu/gold-miner/blob/master/TODO1/javascript-generator-yield-next-async-await.md)
> * 译者：
> * 校对者：

# Javascript - Generator-Yield/Next & Async-Await

![](https://cdn-images-1.medium.com/max/2000/0*yONeU8vuaq8eIyTD)

Generator (ES6)-

> Functions that can return multiple values at different time interval, as per the user demands and can manage its internal state are generator functions. A function becomes a GeneratorFunction if it uses the `[function*](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function* "The function* declaration (function keyword followed by an asterisk) defines a generator function, which returns a Generator object.")` syntax.

They are different from the normal function in the sense that normal function run to completion in a single execution where as _generator function can be paused and resumed_, so they do run to completion but the trigger remain in our hand. They allow _better execution control for asynchronous functionality_ but that does not mean they cannot be used as synchronous functionality.

> Note: When generator function are executed it returns a new Generator object.

The pause and resume are done using `yield`&`next`. So lets look at what are they and what they do.

#### Yield/Next-

> The `yield` keyword pauses generator function execution and the value of the expression following the `yield` keyword is returned to the generator's caller. It can be thought of as a generator-based version of the `return` keyword.

The `yield` keyword actually returns an `IteratorResult` object with two properties, `value` and `done`. ([Don’t know what are iterators and iterables then read here](https://codeburst.io/javascript-es6-iterables-and-iterators-de18b54f4d4)).

> Once paused on a `yield` expression, the generator's code execution remains paused until the generator's `next()` method is called. Each time the generator's `next()` method is called, the generator resumes execution and return the [iterator](https://codeburst.io/javascript-es6-iterables-and-iterators-de18b54f4d4) result.

pheww..enough of theory, lets see an example

```
function* UUIDGenerator() {
    let d, r;
    while(true) {
        yield 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
            r = (new Date().getTime() + Math.random()*16)%16 | 0;
            d = Math.floor(d/16);
            return (c=='x' ? r : (r&0x3|0x8)).toString(16);
        });
    }
};
```

Here, UUIDGenerator is an generator function which calculate the UUID using current time an a random number and return us a new UUID every time its executed.

To run above function we need to create a generator object on which we can call `next()`

```
const UUID = UUIDGenerator();
// UUID is our generator object

UUID.next() 
// return {value: 'e35834ae-8694-4e16-8352-6d2368b3ccbf', done: false}
```

UUID.next() this will return you the new UUID on each UUID.next() under value key and done will always be false as we are in infinite loop.

> Note: We pause above the infinite loop, which is kind of cool and at any “stopping points” in a generator function, not only can they yield values to an external function, but they also can receive values from outside.

There are lot of practical implementation of generators as one above and lot of library that heavily use it, [co](https://github.com/tj/co) , [koa](https://koajs.com/) and [redux-saga](https://github.com/redux-saga/redux-saga) are some examples.

* * *

#### Async/Await (ES7)

![](https://cdn-images-1.medium.com/max/1600/0*LAkE4GiZATgtseM5)

Traditionally, callbacks were passed and invoked when an asynchronous operation returned with data which are handled using `Promise.`

> Async/Await is special syntax to work with promises in a more comfort fashion which is surprisingly easy to understand and use.

**_Async_** _keyword_ is used to define an _asynchronous function_, which returns a `[AsyncFunction](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/AsyncFunction "The AsyncFunction constructor creates a new async function object. In JavaScript every asynchronous function is actually an AsyncFunction object.")` object.

_Await keyword_ is used to pause async function execution until a `Promise` is fulfilled, that is resolved or rejected, and to resume execution of the `async` function after fulfillments. When resumed, the value of the `await` expression is that of the fulfilled `Promise`.

**Key points:**

> 1. Await can only be used inside an async function.
> 2. Functions with the async keyword will _always_ return a promise.
> 3. Multiple awaits will always run in sequential order under a same function.
> 4. If a promise resolves normally, then `await promise` returns the result. But in case of a rejection it throws the error, just if there were a `throw` statement at that line.
> 5. Async function cannot wait for multiple promises at the same time.
> 6. Performance issues can occur if using await after await as many times one statement doesn’t depend on the previous one.

So far so good, now lets see a simple example :-

```
async function asyncFunction() {

  const promise = new Promise((resolve, reject) => {
    setTimeout(() => resolve("i am resolved!"), 1000)
  });

  const result = await promise; 
  // wait till the promise resolves (*)

  console.log(result); // "i am resolved!"
}

asyncFunction();
```

The `asyncFunction` execution “pauses” at the line `await promise` and resumes when the promise settles, with `result` becoming its result. So the code above shows “`i am resolved!`” in one second.

* * *

#### Generator and Async-await — Comparison

1.  _Generator functions/yield_ and _Async functions/await_ can both be used to write asynchronous code that “waits”, which means code that looks as if it was synchronous, even though it really is asynchronous.
2.  _Generator function_ are executed **yield by yield** i.e one yield-expression at a time by its iterator (the `next` method) where as _Async-await_, they are executed sequential **await by await**.
3.  _Async/await_ makes it easier to implement a particular use case of _Generators_.
4.  The return value of _Generator_ is always **{value: X, done: Boolean}** where as for _Async function_ it will always be a **promise** that will either resolve to the value X or throw an error.
5.  _Async function_ can be decomposed into G_enerator and promise_ implementation which are good to know stuff.

* * *

Please consider [**entering your email here**](https://goo.gl/forms/MOPINWoY7q1f1APu2) if you’d like to be added to my email list and **follow me on** [**medium**](https://medium.com/@ideepak.jsd) **to read more article on javascript and on** [**github**](https://github.com/dg92) **to see my crazy code**. If anything is not clear or you want to point out something, please comment down below.

You may also like my other articles

1.  [Nodejs app structure](https://codeburst.io/fractal-a-nodejs-app-structure-for-infinite-scale-d74dda57ee11)
2.  [Javascript data structure with map, reduce, filter](https://codeburst.io/write-beautiful-javascript-with-%CE%BB-fp-es6-350cd64ab5bf)
3.  [Javascript- Currying VS Partial Application](https://codeburst.io/javascript-currying-vs-partial-application-4db5b2442be8)
4.  [Javascript ES6 — Iterables and Iterators](https://codeburst.io/javascript-es6-iterables-and-iterators-de18b54f4d4)
5.  [Javascript performance test — for vs for each vs (map, reduce, filter, find).](https://codeburst.io/write-beautiful-javascript-with-%CE%BB-fp-es6-350cd64ab5bf)
6.  [Javascript — Proxy](https://codeburst.io/why-to-use-javascript-proxy-5cdc69d943e3)

* * *

**If you liked the article, please clap your heart out. Tip — You can clap 50 times! Also, recommend and share to help others find it!**

**THANK YOU!**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
