> * 原文地址：[Deeply Understanding JavaScript Async and Await with Examples](https://blog.bitsrc.io/understanding-javascript-async-and-await-with-examples-a010b03926ea)
> * 原文作者：[Arfat Salman](https://medium.com/@arfatsalman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-javascript-async-and-await-with-examples.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-javascript-async-and-await-with-examples.md)
> * 译者：[xionglong58](https://github.com/xionglong58)
> * 校对者：

# 通过一些例子深入了解 JavaScript 的 Async 和 Await

![](https://cdn-images-1.medium.com/max/3840/1*3kAwfTZXxNynBOB5O6VQtg.jpeg)

  首先来了解下回调函数。**回调函数会在被调用后的某一时刻执行，除此之外与其他普通函数并无差别。**由于 JS 的异步特征，在一些不能立即获得函数返回值的地方都需要使用回调函数。

下面是一个 Node.js 读取文件时的示例（异步操作）—

```
fs.readFile(__filename, 'utf-8', (err, data) => {
  if (err) {
    throw err;
  }
  console.log(data);
});
```
但当我们要处理多重异步操作时问题就会凸显出来。假设有下面的应用场景（其中的所有操作都是异步的）—

* 在数据库中查找用户 `Arfat`，读取 `profile_img_url` 数据，然后把图片从 `someServer.com` 上下载下来。
* 在获取图片之后，我们将其转换成其它不同的格式，比如把 PNG 格式转换至 JPEG 格式。
* 如果图片格式转换成功，则向用户 `Arfat` 发送 email。
* 将此次任务记录在文件 `transformations.log` 并加上时间戳。

上述过程的代码大致如下 —

![Example of Callback hell.](https://cdn-images-1.medium.com/max/2000/1*uYstZyc0A4ZSO2Xxh-ASIg.png)

**Note the nesting of callbacks and the staircase of** `})` **at the end.** 鉴于结构上的相似性，这种方式被形象地称作[**回调地狱**](http://callbackhell.com/)或[**回调金字塔**](https://en.wikipedia.org/wiki/Pyramid_of_doom_(programming))。这种方式的一些缺点是 —

* 不得不从左至右去理解代码，使得代码变得更难以阅读。
* 处理错误变得更加复杂，并且容易引发错误代码。

为了解决上述问题，JS 提出了 [**Promise**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)。**现在，我们可以使用链式结构取代回调函数嵌套的结构。**下面是一个例子 —

![Using Promises](https://cdn-images-1.medium.com/max/2000/1*RMxmAiwD-QFKspkHx_nKmA.png)

回调流程变成熟悉的**自上而下**，而不是**从左至右**，这是一个优点。但是 promise 仍然有一些缺点 —

* 我们仍然得在每一个 `.then` 中处理回调。
* 不同于使用 `try/catch`，我们需要使用 `.catch` 处理错误。
* **在循环体中顺序执行多个 promise 具有挑战且不直观。**

我们为了证明上面的最后一个缺点，**尝试一下下面的挑战吧！**

### 挑战

**假设要在 for 循环中以任意时间间隔（0 到 n 秒）输出数字 0 到 10。我们将使用 promise 去顺序打印 0 到 10，比如打印 0 需要 6 秒，打印 1 要延迟 2 秒，而 1 需要 0 打印完成之后才能打印，其它数字打印过程也类似。** 

当然，不要使用 `async/await` 或 `.sort` 方法，随后我们将会解决这一问题。

## Async 函数

Introduced in **ES2017**(ES8), async functions make working with promises much easier.

* **注意到 async 函数是基于 promise 的这一点很重要。**
* async/await 并不是完全全新的概念。
* async/await 可以被理解为基于 promise 实现异步方案的一种替代方案。
* 我们可以使用 async/await 来避免使用**链式调用 promise**。
* async/await 允许代码异步执行的同时**保持正常的**、同步式的**感觉**。

因此，在理解 async/await 概念之前你**必须要对 promise 有所了解**。

### 语法

async/await 包含两个关键字 async 和 await。**`async` 用来使得函数异步执行。** It **unlocks** the use of `await` inside these functions. Using `await` in any other case is a syntax error.

```
// 应用到普通的声明函数

async function myFn() {
  // await ...
}

// 应用到箭头函数

const myFn = async () => {
  // await ...
}

function myFn() {
  // await fn(); (Syntax Error since no async) 
}
```

注意，在函数声明中 `async` 关键字位于**声明的前面**。在箭头函数中，`async` 关键字则位于 `=` 和 圆括号的中间。

async 函数还能作为对象的方法，或是像下面代码一样位于类中。

```
// 作为对象方法

const obj = {
  async getName() {
    return fetch('https://www.example.com');
  }
}

// 位于类中

class Obj {
  async getResource() {
    return fetch('https://www.example.com');
  }
}
```

**注意：类的构造函数和 [getters/setters](https://blog.bitsrc.io/diving-deeper-in-javascripts-objects-318b1e13dc12)** 不能**作为 async 函数。**

## Semantics and Evaluation Rules

async 函数与普通 JavaScript 函数相比有以下区别 —

### 一个 async 函数总是返回 promise。

```
async function fn() {
  return 'hello';
}

fn().then(console.log)
// hello
```

函数 `fn` 返回值 `'hello'`，由于我们使用了 `async` 关键字，返回值 `'hello'` 是**一个新的 promise 对象**（通过 `Promise.resolve` 实现）。

因此，不使用 `async` 关键字的**具有同等作用的替代方案**可写作 —

```
function fn() {
  return Promise.resolve('hello');
}

fn().then(console.log);
// hello
```

在上面的代码中我们**手动返回了一个 promise 对象**用于替换 `async` 关键字。

确切地说，**async 函数的返回值将会被传递到 `Promise.resolve` 方法中。**

如果返回值是一个原始值，`Promise.resolve` 则返回该值的一个 **promise 版本** 但是，如果返回值是 promise 对象，那么 `Promise.resolve` 将**原封不动地返回这个对象**

```
// 返回值是原始值的情况

const p = Promise.resolve('hello')
p instanceof Promise; 
// true

// p is returned as is it

Promise.resolve(p) === p; 
// true
```

**在 async 函数中**抛出一个错误**会发生什么？**

比如 —

```
async function foo() {
  throw Error('bar');
}

foo().catch(console.log);
```

如果错误**未被捕获**，`foo()` 函数会返回一个状态为 **rejected** 的 promise。不同于 `Promise.resolve`，`Promise.reject` wraps the error and is returned. See E**rror Handling** section later.

最终结果是，无论你想要返回什么结果，最终在 async 函数外，**你都会得到一个 promise。**

### async 函数在执行 await \<表达式>时会中止

`await` 命令就像一个**表达式一样。**当 await 后面跟着一个 promise 时，**async 函数遇到 await 会中止运行，直到相应的 promise 状态变成 resolved。**当 await 后面跟的是原始值时，原始值会被传入 `Promise.resolve` 而转变成一个 promise 对象，并且状态为 resolved。

```
// 多功能函数：获取随机值/延时

const delayAndGetRandom = (ms) => {
  return new Promise(resolve => setTimeout(
    () => {
      const val = Math.trunc(Math.random() * 100);
      resolve(val);
    }, ms
  ));
};

async function fn() {
  const a = await 9;
  const b = await delayAndGetRandom(1000);
  const c = await 5;
  await delayAndGetRandom(1000);
  
  return a + b * c;
}

// 执行函数 fn
fn().then(console.log);
```

然我们来逐行检验函数 `fn` —

* 当函数 `fn` 被调用时，首先被执行的是 `const a = await 9;`。它被**隐式地转换成** `const a = await Promise.resolve(9);`。

* 由于我们使用了 `await` 命令，`fn` 函数会在此时会**暂停到变量 a 获得值为止**。In this case, the **promise resolves it to** `9`.

* `delayAndGetRandom(1000)` 函数使得 `fn` 中的其它程序暂停执行，直到 1 秒钟之后 `delayAndGetRandom` 状态转变成 resolved。 所以，`fn` 函数的执行有效地暂停了 1 秒钟。

* 此外，`delayAndGetRandom` 中的 resolve 函数返回一个随机值。无论往 `resolve` 函数中传入什么值, 都会赋值给变量 `b`。

* 相似的，变量 `c` 值为 `5` ，然后使用 `await delayAndGetRandom(1000)` 又延时了 1 秒钟。在这个例子中我们并没有使用 `Promise.resolve` 返回值。

* 最后我们计算 `a + b * c` 的结果，通过 `Promise.resolve` 将该结果包装成一个 promise，并将作为 async 函数的返回值。

**注意：** If this pause and resume are reminding you of ES6 [**generators**](https://codeburst.io/understanding-generators-in-es6-javascript-with-examples-6728834016d5), it’s because there are [**good reasons**](https://github.com/tj/co) for it.

### 解决方案

让我们使用 async/await 解决在前面提出的假设问题 —

![Using async/await](https://cdn-images-1.medium.com/max/2000/1*AUT5DU_0gzjWMTT00Yc0zw.png)

我们定义了一个 async 函数 `finishMyTask`，使用 `await` 去等待 `queryDatabase`、`sendEmail`、`logTaskInFile` 的操作结果。

如果我们将 async/await 解决方案与 promise If we contrast this solution with the solutions using promises above, we find that **it is roughly the same line of code**. However, async/await has made it simpler in terms of syntactical complexity. **There aren’t multiple callbacks and `.then` /`.catch` to remember.**

Now, let’s solve the **challenge of numbers** listed above. Here are two implementations —

```JavaScript
const wait = (i, ms) => new Promise(resolve => setTimeout(() => resolve(i), ms));

// Implementation One (Using for-loop)
const printNumbers = () => new Promise((resolve) => {
  let pr = Promise.resolve(0);
  for (let i = 1; i <= 10; i += 1) {
    pr = pr.then((val) => {
      console.log(val);
      return wait(i, Math.random() * 1000);
    });
  }
  resolve(pr);
});

// Implementation Two (Using Recursion)

const printNumbersRecursive = () => {
  return Promise.resolve(0).then(function processNextPromise(i) {

    if (i === 10) {
      return undefined;
    }

    return wait(i, Math.random() * 1000).then((val) => {
      console.log(val);
      return processNextPromise(i + 1);
    });
  });
};
```

If you want, you can run them yourself at [**repl.it**** console**](https://repl.it/@ArfatSalman1/blogsequentialnumbers).

If you were allowed async function, the task would have been much simpler.

```
async function printNumbersUsingAsync() {
  for (let i = 0; i < 10; i++) {
    await wait(i, Math.random() * 1000);
    console.log(i);
  }
}
```

This implementation is also provided in the **repl.it** [**console**](https://repl.it/@ArfatSalman1/blogsequentialnumbers).

## Error Handling

As we saw in the **Semantics** section, an **uncaught** `Error()` is wrapped in a rejected promise. However, we can use `try-catch` in async functions to **handle errors** **synchronously**. Let’s begin with this utility function —

```
async function canRejectOrReturn() {
  // wait one second
  await new Promise(res => setTimeout(res, 1000));

// Reject with ~50% probability
  if (Math.random() > 0.5) {
    throw new Error('Sorry, number too big.')
  }

return 'perfect number';
}
```

`canRejectOrReturn()` is an async function and it will either **resolve with** `'perfect number'` or **reject with** Error('Sorry, number too big').

Let’s look at the code example —

```
async function foo() {
  try {
    await canRejectOrReturn();
  } catch (e) {
    return 'error caught';
  }
}
```

Since we are awaiting `canRejectOrReturn`, **its own rejection will be turned into a throw** and the `catch` block will execute. That is, `foo` will **either resolve with** `undefined` (because we are not returning anything in `try`) or **it will resolve with** `'error caught'`. It will never reject since we used a `try-catch` block to handle the error in the `foo` function itself.

Here’s another example —

```
async function foo() {
  try {
    return canRejectOrReturn();
  } catch (e) {
    return 'error caught';
  }
}
```

Note that **we are returning** (and not awaiting) `canRejectOrReturn` from `foo` this time. `foo` will either **resolve with `'perfect number'`** or **reject with** Error('Sorry, number too big'). **The `catch` block will never be executed.**

It is because we **return the promise returned** by `canRejectOrReturn`. Hence, the resolution of `foo` becomes the resolution of `canRejectOrReturn`. You can break `return canRejectOrReturn()` into two lines to see clearly (**Note the missing await** in the first line)—

```
try {
    const promise = canRejectOrReturn();
    return promise;
}
```

Let’s see the usage of `await` and `return` together —

```
async function foo() {
  try {
    return await canRejectOrReturn();
  } catch (e) {
    return 'error caught';
  }
}
```

In this case, `foo` **resolves with either** `'perfect number'` or **resolve with** `'error caught'`. **There is no rejection.** It is like the first example above with just `await`. Except, we **resolve with the value that** `canRejectOrReturn` produces rather than `undefined`.

You can break return await canRejectOrReturn(); to see the effect —

```
try {
    const value  = await canRejectOrReturn();
    return value;
}
// ...
```

## Common Mistakes and Gotchas

Because of an intricate play of Promise-based and async/await concepts, there are some subtle errors that can creep into the code. Let’s look at them —

### Not using await

In some cases, **we forget to use** the `await` keyword before a promise or return it. Here’s an example —

```
async function foo() {
  try {
    canRejectOrReturn();
  } catch (e) {
    return 'caught';
  }
}
```

Note that we are not using `await` or `return`. `foo` **will always resolve with `undefined` without** **waiting for 1 second**. However, the promise **does start** its execution. If there are side-effects, **they will happen**. If it throws an error or rejects, then UnhandledPromiseRejectionWarning will be issued.

### async functions in callbacks

We often use async functions in `.map` or `.filter` as callbacks. Let’s take an example — Suppose we have a function fetchPublicReposCount(username) that fetched the number of public GitHub repositories a user has. We have three users whose counts we want to fetch. Let’s see the code —

```
const url = 'https://api.github.com/users';

// Utility fn to fetch repo counts
const fetchPublicReposCount = async (username) => {
  const response = await fetch(`${url}/${username}`);
  const json = await response.json();
  return json['public_repos'];
}
```

We want to fetch repo counts of ['ArfatSalman', 'octocat', 'norvig']. We may do something like this —

```
const users = [
  'ArfatSalman',
  'octocat',
  'norvig'
];

const counts = users.map(async username => {
  const count = await fetchPublicReposCount(username);
  return count;
});
```

Note the `async` in the callback to the `.map`. We might expect that `counts` variable will contain the numbers of repos. However, as we have seen earlier, **all async functions return promises.** Hence, `counts` is actually **an array of promises.** `.map` calls the anonymous callback with every `username`, and a promise is returned with every invocation which `.map` keeps in the resulting array.

### Too sequential using await

We may also think of a solution such as —

```
async function fetchAllCounts(users) {
  const counts = [];
  for (let i = 0; i < users.length; i++) {
    const username = users[i];
    const count = await fetchPublicReposCount(username);
    counts.push(count);
  }
  return counts;
}
```

We are manually fetching each count, and appending them in the `counts` array. The **problem with this code** is that until the first username’s count is fetched, **the next will not start.** At a time, **only one repo count** is fetched.

If a single fetch takes 300 ms, then `fetchAllCounts` will take ~900ms for 3 users. As we can see that time usage will linearly grow with user counts. Since the **fetching of repo counts is not co-dependent**, we can **parallelize the operation.**

We can fetch users concurrently instead of doing them sequentially. We are going to utilize `.map` and `[**Promise.all**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)`.

```
async function fetchAllCounts(users) {
  const promises = users.map(async username => {
    const count = await fetchPublicReposCount(username);
    return count;
  });
  return Promise.all(promises);
}
```

`Promise.all` receives an array of promises as input and returns a promise as output. The returned promise resolves with **an array of all promise resolutions or rejects with the first rejection.** However, it may not be feasible to start all promises at the same time. Maybe you want to complete promises in batches. You can look at **[p-map](https://github.com/sindresorhus/p-map)** for limited concurrency.

## Conclusion

Async functions have become really important. With the introduction of [Async Iterators](https://github.com/tc39/proposal-async-iteration), async functions will see more adoption. It is important to have a good understanding of them for modern JavaScript developer. I hope this article sheds some light on that. :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
