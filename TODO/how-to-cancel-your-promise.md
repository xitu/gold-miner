> * 原文地址：[How to Cancel Your Promise](http://blog.bloomca.me/2017/12/04/how-to-cancel-your-promise.html)
> * 原文作者：[Seva Zaikov](http://blog.bloomca.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-cancel-your-promise.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-cancel-your-promise.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[kangkai124](https://github.com/kangkai124) [hexianga](https://github.com/hexianga)

# 如何取消你的 Promise

在 JavaScript 语言的国际标准 ECMAScript 的 ES6 版本中，引入了新的异步原生对象 [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)。这是一个非常强大的概念，它使我们可以避免臭名昭著的 [回调陷进](http://callbackhell.com/)。例如，几个异步操作很容易写成下面这样的代码：

```
function updateUser(cb) {
  fetchData(function(error, data) => {
    if (error) {
      throw error;
    }
    updateUserData(data, function(error, data) => {
      if (error) {
        throw error;
      }
      updateUserAddress(data, function(error, data) => {
        if (error) {
          throw error;
        }
        updateMarketingData(data, function(error, data) => {
          if (error) {
            throw error;
          }

          // finally!
          cb();
        });
      });
    });
  });
}

```

正如你所看到的，我们嵌套了几个回调函数，如果想要改变一些回调函数的顺序，或者想同时执行一些回调函数，我们将很难管理这些代码。但是，通过 Promise，我们可以将其重构为可读性更好的版本：

```
// 我们不再需要回调函数了 – 只需要使用 then 方法
// 处理函数的返回结果
function updateUser() {
  return fetchData()
    .then(updateUserData)
    .then(updateUserAddress)
    .then(updateMarketingData);
}

```

这样的代码不仅更简洁，可读性更强，而且可以轻松切换回调的顺序，同时执行回调或删除不必要的回调（或者在回调链中间新增一个回调）。

> 使用 Promise 链式写法的一个缺点是我们无法访问每个回调函数的作用域（或者其中未返回的的变量），你可以阅读 Alex Rauschmayer 博士这篇 [a great article](http://2ality.com/2017/08/promise-callback-data-flow.html) 来解决这个问题。

但是，我发现了 [这个问题](https://stackoverflow.com/questions/30233302/promise-is-it-possible-to-force-cancel-a-promise)，你不能取消 Promise，这是一个很关键的问题。有时你**需要**取消 Promise，你要构建变通的方法 — 工作量取决于你多长时间使用一次这个功能。

## 使用 Bluebird

[Bluebird](http://bluebirdjs.com/docs/getting-started.html) 是一个 Promise 实现库， 完全兼容原生的 Promise 对象, 并且在原型对象 Promise.prototype 上添加了一些有用的方法（译者注：扩展了原生 Promise 对象的方法）。在这里我们只介绍下 [cancel](http://bluebirdjs.com/docs/api/cancellation.html) 方法, 它部分实现了我们的想要的 — 当我们使用 `promise.cancel` 取消 Promise 时，它允许我们有自定义的逻辑(为什么是部分实现? 因为代码冗长还不通用).

在我们的例子中，我们来看看如何使用 Bluebird 实现取消 Promise：

```
import Promise from 'Bluebird';

function updateUser() {
  return new Promise((resolve, reject, onCancel) => {
    let cancelled = false;

    // 你需要更改 Bluebird 的配置，才能使用 cancellation 特性
    // http://bluebirdjs.com/docs/api/promise.config.html
    onCancel(() => {
      cancelled = true;
      reject({ reason: 'cancelled' });
    });

    return fetchData()
      .then(wrapWithCancel(updateUserData))
      .then(wrapWithCancel(updateUserAddress))
      .then(wrapWithCancel(updateMarketingData))
      .then(resolve)
      .catch(reject);

    function wrapWithCancel(fn) {
      // promise resolved 的状态只需要传递一个参数
      return (data) => {
        if (!cancelled) {
          return fn(data);
        }
      };
    }
  });
}

const promise = updateUser();
// 等一会...
promise.cancel(); // 用户还是会被更新
```

正如你所看到的，我们在之前干净的例子中增加了很多代码。不幸的是，没有其他办法，因为我们不能停止执行一个随机的 Promise 链（如果我们想，我们需要把它包装到另一个函数中），所以我们需要用处理取消状态的函数包装每个回调函数。

## 纯 Promises

上面的技术并不是 Bluebird 的特别之处，更多的是关于接口 - 你可以实现你自己的取消版本，但需要额外的属性/变量。通常这种方法被称为`cancellationToken`，在本质上，它几乎和前一个一样，但不是在`Promise.prototype.cancel`上有这个方法，我们将它实例化在一个不同的对象 - 我们可以用`cancel`属性返回一个对象，或者我们可以接受额外的参数，一个对象，我们将在那里添加一个属性。

```
function updateUser() {
  let resolve, reject, cancelled;
  const promise = new Promise((resolveFromPromise, rejectFromPromise) => {
    resolve = resolveFromPromise;
    reject = rejectFromPromise;
  });

  fetchData()
    .then(wrapWithCancel(updateUserData))
    .then(wrapWithCancel(updateUserAddress))
    .then(wrapWithCancel(updateMarketingData))
    .then(resolve)
    .then(reject);

  return {
    promise,
    cancel: () => {
      cancelled = true;
      reject({ reason: 'cancelled' });
    }
  };

  function wrapWithCancel(fn) {
    return (data) => {
      if (!cancelled) {
        return fn(data);
      }
    };
  }
}

const { promise, cancel } = updateUser();
// 等一会...
cancel(); // 用户还是会被更新
```

这比以前的解决方案稍微冗长一点，但是它解决了同样的问题，如果你没有使用 Bluebird（或者不想在 Promise 中使用非标准的方法），这是一个可行的解决方案。正如你所看到的，我们改变了签名 - 现在我们返回对象而不是一个 Promise，但实际上我们可以传递一个对象参数给函数，并附上`cancel`方法（或者 Promise 的 monkey-patch 实例，但它也会在以后给你造成问题）。如果你只在几个地方有这个要求，这是一个很好的解决方案。

## 切换到 generators

Generators 是 ES6 另一个新特性，但由于某些原因，它们并没有被广泛使用。使用前请想清楚 - 你团队中的新手会看不懂呢，还是全部成员都游刃有余呢？而且，它还存在于其他一些语言中，如 [Python](https://wiki.python.org/moin/Generators)，所以作为团队使用这个解决方案应该会很容易。

Generators 有它自己的文档, 所以我不会介绍基础知识，只是实现一个 Generator 执行器，这将允许我们以通用方式取消我们的 Promise，而不会影响我们的代码。

```
// 这是运行我们异步代码的核心方法
// 并且提供 cancellation 方法
function runWithCancel(fn, ...args) {
  const gen = fn(...args);
  let cancelled, cancel;
  const promise = new Promise((resolve, promiseReject) => {
    // 定义 cancel 方法，并返回它
    cancel = () => {
      cancelled = true;
      reject({ reason: 'cancelled' });
    };

    let value;

    onFulfilled();

    function onFulfilled(res) {
      if (!cancelled) {
        let result;
        try {
          result = gen.next(res);
        } catch (e) {
          return reject(e);
        }
        next(result);
        return null;
      }
    }

    function onRejected(err) {
      var result;
      try {
        result = gen.throw(err);
      } catch (e) {
        return reject(e);
      }
      next(result);
    }

    function next({ done, value }) {
      if (done) {
        return resolve(value);
      }
      // 假设我们总是接收 Promise，所以不需要检查类型
      return value.then(onFulfilled, onRejected);
    }
  });

  return { promise, cancel };
}
```

这是一个相当长的函数，但基本上它（除了检查，当然这是一个非常初级的实现） - 代码本身将保持完全相同，我们将从字面上获取`cancel`方法！让我们看看如何在我们的例子中使用它：

```
// * 表示这是一个 Generator 函数
// 你可以把 * 放到几乎任何地方 :)
// 这种写法语法上和 async/await 很相似
function* updateUser() {
  // 假设我们所有的函数都返回 Promise
  // 否则需要调整我们的执行器函数
  // 去接受 Generator
  const data = yield fetchData();
  const userData = yield updateUserData(data);
  const userAddress = yield updateUserAddress(userData);
  const marketingData = yield updateMarketingData(userAddress);
  return marketingData;
}

const { promise, cancel } = runWithCancel(updateUser);

// 见证奇迹的时刻
cancel();
```

正如你所看到的，接口保持不变，但是现在我们可以选择在执行过程中取消任何基于 Generator 的函数，只需将其包装到合适的运行器中即可。缺点是一致性 - 如果它只是在你的代码中的几个地方，那么别人看你代码时会很困惑，因为你在代码中使用了所有可能的异步方法，这又是一个折中方案。

我想，Generator 是最具扩展性的选择，因为你可以从字面上完成所有你想要的事情 - 如果出现某种情况，你可以暂停，等待，重试，或者运行另一个 Generator。但是，我并没有经常在 JavaScript 代码中看到他们，所以你应该考虑采用和认知负载 - 你真的有很多的它的使用场景吗？如果是，那么这是一个非常好的解决方案，你将来可能会感谢你自己。

## 注意 async/await

在 [ES2017](https://tc39.github.io/ecma262/2017/#sec-async-function-definitions) 版本提供了 async/await，你可以在 Node.js（[版本7.6](https://www.infoq.com/news/2017/02/node-76-async-await)之后）中没有任何标志的情况下使用它们。不幸的是，没有任何东西可以支持取消 Promise，而且由于 async 函数隐含地返回 Promise，所以我们不能真正感觉到它（附加一个属性或返回其他东西），只有 resolved/rejected 状态的值。这意味着为了使我们的函数可以被取消，我们需要传递一个对象，并将每个调用包装在我们著名的包装器方法中：

```
async function updateUser(token) {
  let cancelled = false;

  // 我们不调用 reject，因为我们无法访问
  // 返回的 Promise
  // 我们不调用其它函数
  // 在结束时调用 reject
  token.cancel = () => {
    cancelled = true;
  };

  const data = await wrapWithCancel(fetchData)();
  const userData = await wrapWithCancel(updateUserData)(data);
  const userAddress = await wrapWithCancel(updateUserAddress)(userData);
  const marketingData = await wrapWithCancel(updateMarketingData)(userAddress);

  // 因为我们已经包装了所有的函数，以防取消
  // 不需要调用任何实际函数来达到这一点
  // 我们也不能调用 reject 方法
  // 因为我们无法控制返回的 Promise
  if (cancelled) {
    throw { reason: 'cancelled' };
  }

  return marketingData;

  function wrapWithCancel(fn) {
    return data => {
      if (!cancelled) {
        return fn(data);
      }
    }
  }
}

const token = {};
const promise = updateUser(token);
// 等一会...
token.cancel(); // 用户还是会被更新
```

这是非常相似的解决方案，但是因为我们没有直接在`cancel`方法中调用 reject，所以可能会使读者感到困惑。另一方面，它是现在语言的一个标准功能，具有非常方便的语法，允许你在后面使用前面调用的结果（所以在这里解决了 Promise 链式调用的问题），并且具有非常简明和直观的通过`try / catch`的错误处理。所以，如果取消不再困扰你（或者你可以用这种方式来取消某些东西），那么这个特性绝对是在现代 JavaScript 中编写异步代码的最好方式。

## 使用 streams (就像 RxJS)

Streams 是完全不同的概念，但实际上它的应用更广泛 [不仅在 JavaScript ](http://reactivex.io/)，所以你可以将其视为独立于平台的模式。和 Promie/Generator 相比，Streams 可能更好也可能更糟糕。如果你已经接触过它，并且使用它来处理过一些（或者所有的）异步逻辑，你会发现 Streams 更好，如果你没接触过，你会发现 Streams 更糟糕，因为它是完全不同的方法。

我不是一个使用 Streams 的专家，只是使用过一些，我认为你应该使用它们来处理所有的异步事件，或者完全不使用它们。所以，如果你已经在使用它们，这个问题对你来说应该不是一件难事，因为这是 Streams 库的一个长期以来众所周知的特性。

正如我所提到的，我没有足够的使用 Streams 的经验来提供使用它们的解决方案，所以我只是放几个关于 Streams 实现取消的链接：

* [GitHub issue 解释](https://github.com/Reactive-Extensions/RxJS/issues/817#issuecomment-122729155)
* [关于使用 * 方法的文章](https://medium.com/@benlesh/rxjs-dont-unsubscribe-6753ed4fda87)

## 接受

事情朝着好的方向发展 - fetch 将会新增 [abort](https://github.com/whatwg/fetch/issues/447) 方法，如何取消 Promise 在将来还会热议很长一段时间。取消 Promise 能够实现吗？可能会可能不会。而且，取消 Promise 对于许多应用程序来说不是至关重要的 - 是的，你可以提出一些额外的请求，但有一个以上的请求结果是非常罕见的。另外，如果发生一次或两次，则可以从一开始就使用扩展示例来解决这些特定函数。但是，如果你的应用程序中有很多这样的情况，请考虑一下上面列出的内容。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

