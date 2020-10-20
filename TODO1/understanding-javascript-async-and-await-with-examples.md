> * 原文地址：[Deeply Understanding JavaScript Async and Await with Examples](https://blog.bitsrc.io/understanding-javascript-async-and-await-with-examples-a010b03926ea)
> * 原文作者：[Arfat Salman](https://medium.com/@arfatsalman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-javascript-async-and-await-with-examples.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-javascript-async-and-await-with-examples.md)
> * 译者：[xionglong58](https://github.com/xionglong58)
> * 校对者：[Baddyo](https://github.com/Baddyo)，[Mcskiller](https://github.com/Mcskiller)，[fireairforce](https://github.com/fireairforce)

# 通过一些例子深入了解 JavaScript 的 Async 和 Await

![](https://cdn-images-1.medium.com/max/3840/1*3kAwfTZXxNynBOB5O6VQtg.jpeg)

首先来了解下回调函数。**回调函数会在被调用后的某一时刻执行，除此之外与其他普通函数并无差别**。由于 JavaScript 的异步特征，在一些不能立即获得函数返回值的地方都需要使用回调函数。

下面是一个 Node.js 读取文件时的示例（异步操作）——

```
fs.readFile(__filename, 'utf-8', (err, data) => {
  if (err) {
    throw err;
  }
  console.log(data);
});
```
但当我们要处理多重异步操作时问题就会凸显出来。假设有下面的应用场景（其中的所有操作都是异步的）——

* 在数据库中查找用户 `Arfat`，读取 `profile_img_url` 数据，然后把图片从 `someServer.com` 上下载下来。
* 在获取图片之后，我们将其转换成其它不同的格式，比如把 PNG 格式转换至 JPEG 格式。
* 如果图片格式转换成功，则向用户 `Arfat` 发送 email。
* 将此次任务记录在文件 `transformations.log` 并加上时间戳。

上述过程的代码大致如下 ——

![回调地狱示例。](https://cdn-images-1.medium.com/max/2000/1*uYstZyc0A4ZSO2Xxh-ASIg.png)

**注意回调函数的嵌套和程序末尾** `})` **的层级**。 鉴于结构上的相似性，这种方式被形象地称作[**回调地狱**](http://callbackhell.com/)或[**回调金字塔**](https://en.wikipedia.org/wiki/Pyramid_of_doom_(programming))。这种方式的一些缺点是 ——

* 不得不从左至右去理解代码，使得代码变得更难以阅读。
* 错误处理变得更加复杂，并且容易引发错误代码。

为了解决上述问题，JavaScript 提出了 [**Promise**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)。**现在，我们可以使用链式结构取代回调函数嵌套的结构**。下面是一个例子 ——

![使用 promise](https://cdn-images-1.medium.com/max/2000/1*RMxmAiwD-QFKspkHx_nKmA.png)

回调流程由**从左至右**结构变成我们所熟悉的**自上而下**的结构，这是一个优点。但是 promise 仍然有一些缺点 ——

* 我们仍然得在每一个 `.then` 中处理回调。
* 不同于使用 `try/catch`，我们需要使用 `.catch` 处理错误。
* **在循环体中顺序执行多个 promise 具有挑战且不直观。**

为了证明上面的最后一个缺点，**尝试一下下面的挑战吧！**

### 挑战

**假设要在 for 循环中以任意时间间隔（0 到 n 秒）输出数字 0 到 10。我们将使用 promise 去顺序打印 0 到 10，比如打印 0 需要 6 秒，打印 1 要延迟 2 秒，而 1 需要 0 打印完成之后才能打印，其它数字打印过程也类似。** 

当然，不要使用 `async/await` 或 `.sort` 方法，随后我们将会解决这一问题。

## Async 函数

async 函数在 **ES2017** (ES8) 中引入，使得 promise 的应用更加简单。

* **注意到 async 函数是基于 promise 实现的这一点很重要。**
* async/await 并不是完全全新的概念。
* async/await 可以被理解为基于 promise 实现异步方案的一种替代方案。
* 我们可以使用 async/await 来避免**链式调用 promise**。
* async/await 允许代码异步执行的同时**保持正常的**、同步式的**感觉**。

因此，在理解 async/await 概念之前你**必须要对 promise 有所了解**。

### 语法

async/await 包含两个关键字 async 和 await。**`async` 用来使得函数可以异步执行**。`async` 使得在函数中可以使用 `await` 关键字，除此之外，在任何地方使用 `await` 都属于语法错误。

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

注意，在函数声明中 `async` 关键字位于**声明的前面**。在箭头函数中，`async` 关键字则位于 `=` 和圆括号的中间。

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

## 语义和评估准则

async 函数与普通 JavaScript 函数相比有以下区别 ——

### async 函数总是返回 promise 对象。

```
async function fn() {
  return 'hello';
}

fn().then(console.log)
// hello
```

函数 `fn` 的返回值 `'hello'`，由于我们使用了 `async` 关键字，返回值 'hello' 被包装成了**一个 promise 对象**（通过 `Promise.resolve` 实现）。

因此，不使用 `async` 关键字的**具有同等作用的替代方案**可写作 ——

```
function fn() {
  return Promise.resolve('hello');
}

fn().then(console.log);
// hello
```

在上面的代码中我们**手动返回了一个 promise 对象**用于替换 `async` 关键字。

确切地说，**async 函数的返回值将会被传递到 `Promise.resolve` 方法中。**

如果返回值是一个原始值，`Promise.resolve` 则返回该值的一个 **promise 版本**。但是，如果返回值是 promise 对象，那么 `Promise.resolve` 将**原封不动地返回这个对象**。

```
// 返回值是原始值的情况

const p = Promise.resolve('hello')
p instanceof Promise; 
// true

//p 被原封不动地返回

Promise.resolve(p) === p; 
// true
```

**在 async 函数中**抛出一个错误**会发生什么？**

比如 ——

```
async function foo() {
  throw Error('bar');
}

foo().catch(console.log);
```

如果错误**未被捕获**，`foo()` 函数会返回一个状态为 **rejected** 的 promise。不同于 `Promise.resolve`，`Promise.reject` 会包装错误并返回。详情请看稍后的**错误处理**部分。

最终结果是，不论你想要返回什么结果，最终在 async 函数外，**你都会得到一个 promise。**

### async 函数在执行 await \<表达式>时会中止

`await` 命令就像一个**表达式一样**。当 await 后面跟着一个 promise 时，**async 函数遇到 await 会中止运行，直到相应的 promise 状态变成 resolved**。当 await 后面跟的是原始值时，原始值会被传入 `Promise.resolve` 而转变成一个 promise 对象，并且状态为 resolved。

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

让我们来逐行检验函数 `fn` ——

* 当函数 `fn` 被调用时，首先被执行的是 `const a = await 9;`。它被**隐式地转换成** `const a = await Promise.resolve(9);`。

* 由于我们使用了 `await` 命令，`fn` 函数会在此时会**暂停到变量 a 获得值为止**。在该情况下 **`Promise.resolve` 方法返回值**为 9。

* `delayAndGetRandom(1000)` 函数使得 `fn` 中的其它程序暂停执行，直到 1 秒钟之后 `delayAndGetRandom` 状态转变成 resolved。所以，`fn` 函数的执行有效地暂停了 1 秒钟。

* 此外，`delayAndGetRandom` 中的 resolve 函数返回一个随机值。无论往 `resolve` 函数中传入什么值, 都会赋值给变量 `b`。

* 同样，变量 `c` 值为 `5` ，然后使用 `await delayAndGetRandom(1000)` 又延时了 1 秒钟。在这个例子中我们并没有使用 `Promise.resolve` 返回值。

* 最后我们计算 `a + b * c` 的结果，通过 `Promise.resolve` 将该结果包装成一个 promise，并将其作为 async 函数的返回值。

**注意：** 如果上面程序的暂停和恢复操作让你想起了 ES6 的 [**generator**](https://codeburst.io/understanding-generators-in-es6-javascript-with-examples-6728834016d5)，那是因为 generator 也有[**很多优点**](https://github.com/tj/co)。

### 解决方案

让我们使用 async/await 解决在前面提出的假设问题 ——

![使用 async/await](https://cdn-images-1.medium.com/max/2000/1*AUT5DU_0gzjWMTT00Yc0zw.png)

我们定义了一个 async 函数 `finishMyTask`，使用 `await` 去等待 `queryDatabase`、`sendEmail`、`logTaskInFile` 的操作结果。

如果我们将 async/await 解决方案与使用 promise 的方案进行对比之后会发现**代码的数量很相近**。但是 async/await 使得代码在语法复杂性方面变得更简单，**不用去记忆多层回调函数以及 `.then` /`.catch`。**

现在，就让我们解决上面所列的打印数字的挑战。下面是两种不同的解决方法 ——

```JavaScript
const wait = (i, ms) => new Promise(resolve => setTimeout(() => resolve(i), ms));

// 方法一（使用 for 循环）
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

// 方法二（使用回调）

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

你可以在 [**repl.it console**](https://repl.it/@ArfatSalman1/blogsequentialnumbers) 上运行上面的代码。

如果允许你使用 async 函数，那么这个挑战解决起来将会简单得多。

```
async function printNumbersUsingAsync() {
  for (let i = 0; i < 10; i++) {
    await wait(i, Math.random() * 1000);
    console.log(i);
  }
}
```

同样，该方法也可以在 **repl.it** [**console**](https://repl.it/@ArfatSalman1/blogsequentialnumbers) 上运行。

## 错误处理

如同我们在**语法**部分所见，一个**未捕获**的 `Error()` 被包装在一个 rejected promise 中。但是，我们可以在 async 函数中**同步地**使用 `try-catch` **处理错误**。让我们从这一实用的函数开始 ——

```
async function canRejectOrReturn() {
  // 等待一秒
  await new Promise(res => setTimeout(res, 1000));

// 50% 的可能性是 Rejected 状态
  if (Math.random() > 0.5) {
    throw new Error('Sorry, number too big.')
  }

return 'perfect number';
}
```

`canRejectOrReturn()` 是一个 async 函数，他可能返回 `'perfect number'` 也可能抛出错误（'Sorry, number too big'）。

我们来看看示例代码 ——

```
async function foo() {
  try {
    await canRejectOrReturn();
  } catch (e) {
    return 'error caught';
  }
}
```

因为我们在等待执行 `canRejectOrReturn` 函数的时候，**canRejectOrReturn 函数体内的 promise 会转移到 rejected 状态而抛出错误**，这将导致 `catch` 代码块被执行。也就是说 `foo` 函数运行结果为 `rejected`，返回值为 `undefined`（因为我们在 `try` 中没有返回值）或者 `'error caught'`。因为我们在 `foo` 函数中使用了 `try-catch` 处理错误，所以说 `foo` 函数的结果永远不会是 rejected。

下面是另外一个版本的例子 ——

```
async function foo() {
  try {
    return canRejectOrReturn();
  } catch (e) {
    return 'error caught';
  }
}
```

注意这一次我们使用了 **return** （而不是 await）将函数 `canRejectOrReturn` 从 `foo` 函数中返回。`foo` 函数运行结果是 **resolved，返回值为 `'perfect number'` **或者值为 Error('Sorry, number too big')。**`catch` 代码块永远都不会被执行。**

这是因为函数 `foo` 返回了 `canRejectOrReturn` 返回的 promise 对象。因此 `foo` 的 resolved 变成了 `canRejectOrReturn` 的 resolved。你可以将 `return canRejectOrReturn()` 等价为下面两行程序去理解（**注意第一行没有 await**）——

```
try {
    const promise = canRejectOrReturn();
}
```

让我们看看 `await` 和 `return` 搭配使用时的情况 ——

```
async function foo() {
  try {
    return await canRejectOrReturn();
  } catch (e) {
    return 'error caught';
  }
}
```

在上面的例子中，`foo` 函数**运行结果为 resolved，**返回值为 `'perfect number'` 或 `'error caught'`。**`foo` 函数的结果永远不会是 rejected。** 这就像上面那个只有 `await` 的例子。只是这里将函数 `canRejectOrReturn` 的 rejected 结果返回了，而不是返回了 `undefined`。

你可以将语句 `return await canRejectOrReturn();`拆开再看看效果 ——

```
try {
    const value  = await canRejectOrReturn();
    return value;
}
// ...
```

## 常见错误和陷阱

由于涉及 promise 和 async/await 之间错综复杂的操作，程序中可能会潜藏一些细微的差错。让我们一起看看吧 ——

### 没有使用 await 关键字

有时候，在 promise 对象之前**我们忘记了使用** `await` 关键字，或者是忘记将 promise 对象返回。如下所示 ——

```
async function foo() {
  try {
    canRejectOrReturn();
  } catch (e) {
    return 'caught';
  }
}
```

注意我们并没有使用 `await` 或 `return`。`foo` 函数运行结果为**返回值是 `undefined` 的 resolved**，并且函数执行不会**延迟 1 秒钟**。但是canRejectOrReturn() 中的 promise 的确被执行了。如果没有副作用产生，**这的确会发生**。如果 canRejectOrReturn() 抛出错误或者状态转移为 rejected，UnhandledPromiseRejectionWarning 错误将会产生。

### 在回调中使用 async 函数

我们经常把 async 函数作为`.map` 或 `.filter` 方法的回调。让我们举个例子 — 假设我们有一个函数 fetchPublicReposCount(username) 可以获取一个 github 用户拥有的公开仓库的数量。我们想要获得三名不同用户的公开仓库数量，让我们来看代码 —

```
const url = 'https://api.github.com/users';

// 使用 fn 函数获取仓库数量
const fetchPublicReposCount = async (username) => {
  const response = await fetch(`${url}/${username}`);
  const json = await response.json();
  return json['public_repos'];
}
```

想要获得三名用户 ['ArfatSalman', 'octocat', 'norvig'] 的公开仓库数量。我们可能会这样做 ——

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
### 过于按顺序使用 await

注意 `async` 在 `.map`方法中。我们可能希望变量 `counts` 存储着的公开仓库数量。但是，就如我们之前所见，**所有的 async 函数均返回 promise 对象**。 因此，`counts` 实际上是一个 **promise 对象数组**。`.map` 为每一个 `username` 调用异步函数，`.map` 方法将每次调用返回的 promise 结果保存在数组中。

我们可能也会有其它解决方法，比如 ——

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

我们手动获取了每一个 count，并将它们 append 到 `counts` 数组中。**程序的问题在于**第一个用户的 count 被获取之后，第二个用户的 count 才能被获取。同一时间，只有一个**公开仓库数量**可以被获取。

如果一个 fetch 操作耗时 300 ms，那么 `fetchAllCounts` 函数耗时大概在 900 ms 左右。由此可见，程序耗时会随着用户数量的增加而线性增加。因为**获取不同用户公开仓库数量之间没有依赖**，我们可以将**操作并行处理。**

我们可以同时获取用户的公开仓库数量，而不是顺序获取。我们将使用 `.map` 方法和 **[`Promise.all`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all)**。

```
async function fetchAllCounts(users) {
  const promises = users.map(async username => {
    const count = await fetchPublicReposCount(username);
    return count;
  });
  return Promise.all(promises);
}
```

`Promise.all` 接受一个 promise 对象数组作为输入，返回一个 promise 对象。当所有 promise 对象的状态都转变成 resolved 时，返回值为**所有 promise 对应返回值组成的 promise 数组**，只要有一个 promise 对象被 rejected，`Promise.all` 的返回值为**第一个被 rejected 的 promise 对象对应的返回值**。但是，同时运行所有 promise 的操作可能行不通。可能你想批量执行 promise。你可以考虑下使用 **[p-map](https://github.com/sindresorhus/p-map)** 实现受限的并发。

## 结论

async 函数变得很重要。随着 [Async Iterators](https://github.com/tc39/proposal-async-iteration) 的引入，async 函数将会应用得越来越广。对于现代 JavaScript 开发人员来说深入理解 async 函数至关重要。我希望这篇文章能对你有所启发。:)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
