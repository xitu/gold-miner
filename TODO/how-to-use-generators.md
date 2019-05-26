> * 原文地址：[How to Use Generators in JavaScript](http://blog.bloomca.me/2017/12/19/how-to-use-generators.html)
> * 原文作者：[Seva Zaikov](http://blog.bloomca.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-use-generators.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-use-generators.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[vuuihc](https://github.com/vuuihc) [congFly](https://github.com/congFly)

# 如何在 JavaScript 中使用 Generator

Generator 是一种非常强力的语法，但它的使用并不广泛（参见下图 twitter 上的调查！）。为什么这样？相比于 async/await，它的使用更复杂，调试起来也不太容易（大多数情况又回到了从前），即使我们可以通过非常简单的方式获得类似体验，但是人们一般会更喜欢 async/await。

![1513838054(1).jpg](https://i.loli.net/2017/12/21/5a3b56e1f35e4.jpg)

然而，Generator 允许我们通过 `yield` 关键字遍历我们自己的代码！这是一种超级强大的语法，实际上，我们可以操纵执行过程！从不太明显的取消操作开始，让我们先从同步操作开始吧。

> 我为文中提到的功能创建了一个代码仓库 —— [https://github.com/Bloomca/obscure-generator-fns](https://github.com/Bloomca/obscure-generator-fns)

## 批处理 (或计划)

执行 Generator 函数会返回一个遍历器对象，那意味着通过它我们可以同步地遍历。为什么我们想这么做？原因有可能是为了实现批处理。想象一下，我们需要下载 10000 个项目，并在表格中逐行的显示它们（不要问我为什么，假设我们不使用框架）。虽然立刻展示它们没有什么不好的，但有时这可能不是最好的解决方案 —— 也许你的 MacBook Pro 可以轻松处理它，但普通人的电脑不能（更别说手机了）。所以，这意味着我们需要用某种方式延迟执行。

> 请注意，这个例子是关于性能优化，在你遇到这个问题之前，没必要这样做 —— [过早优化是万恶之源](https://en.wikipedia.org/wiki/Program_optimization#When_to_optimize)!

```
// 最初的同步实现版本
function renderItems(items) {
  for (item of items) {
    renderItem(item);
  }
}

// 函数将由我们的执行器遍历执行
// 实际上，我们可以用相同的同步方式来执行它！
function* renderItems(items) {
  // 我使用 for..of 遍历方法来避免新函数的产生
  for (item of items) {
    yield renderItem(item);
  }
}
```

没有什么区别吧？那么，这里的区别在于，现在我们可以在不改变源代码的情况下以不同方式运行这个函数。实际上，正如我之前提到的，没有必要等待，我们可以同步执行它。所以，来调整下我们的代码。在每个 `yield` 后边加一个 4 ms（JavaScript VM 中的一个心跳） 的延迟怎么样？我们有 10000 个项目，下载将需要 4 秒 —— 还不错，假设我想在 2 秒之内渲染完毕，很容易想到的方法是每次渲染 2 个。突然使用 Promise 的解决方案将变得更加复杂 —— 我们必须要传递另一个参数：每次渲染的项目个数。通过我们的执行器，我们仍然需要传递这个参数，但好处是对我们的 `renderItems` 方法完全没有影响。


```
function runWithBatch(chunk, fn, ...args) {
  const gen = fn(...args);
  let num = 0;
  return new Promise((resolve, promiseReject) => {
    callNextStep();

    function callNextStep(res) {
      let result;
      try {
        result = gen.next(res);
      } catch (e) {
        return reject(e);
      }
      next(result);
    }

    function next({ done, value }) {
      if (done) {
        return resolve(value);
      }

      // every chunk we sleep for a tick
      if (num++ % chunk === 0) {
        return sleep(4).then(proceed);
      } else {
        return proceed();
      }

      function proceed() {
        return callNextStep(value);
      }
    }
  });
}

// 第一个参数 —— 每批处理多少个项目
const items = [...];
batchRunner(2, function*() {
  for (item of items) {
    yield renderItem(item);
  }
});
```

正如你所看到的，我们可以轻松改变每批处理项目的个数，不去考虑执行器，回到正常的同步执行方式 —— 所有这些都不会影响我们的 `renderItems` 方法。

## 取消


我们来考虑下传统的功能 —— 取消。在我 [promises cancellation in general](http://blog.bloomca.me/2017/12/04/how-to-cancel-your-promise.html) ([译文：如何取消你的 Promise?](https://juejin.im/post/5a32705a6fb9a045117127fa)) 这篇文章中已经详细谈到了。所以我会使用其中一些代码：

```
function runWithCancel(fn, ...args) {
  const gen = fn(...args);
  let cancelled, cancel;
  const promise = new Promise((resolve, promiseReject) => {
    // define cancel function to return it from our fn
    // 定义 cancel 方法，并返回它
    cancel = () => {
      cancelled = true;
      reject({ reason: 'cancelled' });
    };

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

这里最好的部分是我们可以取消所有还没来得及执行的请求（也可以给我们的执行器传递类似 [AbortController](https://developer.mozilla.org/en-US/docs/Web/API/AbortController) 的对象参数，所以它甚至可以取消当前的请求！），而且我们没有修改过自己业务逻辑中的一行的代码。

## 暂停/恢复

另一个特殊的需求可能是暂停/恢复功能。你为什么想要这个功能？想象一下，我们渲染了 10000 行数据，而且速度非常慢，我们希望给用户提供暂停/恢复渲染的功能，这样他们就可以停止所有的后台工作读取已经下载的内容了。让我们开始吧！

```
// 实现渲染的方法还是一样的
function* renderItems() {
  for (item of items) {
    yield renderItem(item);
  }
}

function runWithPause(genFn, ...args) {
  let pausePromiseResolve = null;
  let pausePromise;

  const gen = genFn(...args);

  const promise = new Promise((resolve, reject) => {
    onFulfilledWithPromise();

    function onFulfilledWithPromise(res) {
      if (pausePromise) {
        pausePromise.then(() => onFulfilled(res));
      } else {
        onFulfilled(res);
      }
    }

    function onFulfilled(res) {
      let result;
      try {
        result = gen.next(res);
      } catch (e) {
        return reject(e);
      }
      next(result);
      return null;
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
      return value.then(onFulfilledWithPromise, onRejected);
    }
  });

  return {
    pause: () => {
      pausePromise = new Promise(resolve => {
        pausePromiseResolve = resolve;
      });
    },
    resume: () => {
      pausePromiseResolve();
      pausePromise = null;
    },
    promise
  };
}
```

调用这个执行器，可以给我们返回一个具有暂停/恢复功能的对象，所有这些都可以轻松得到，还是使用我们之前的业务代码！所以，如果你有很多"沉重"的请求链，需要耗费很长时间，而你想给你的用户提供暂停/恢复功能的话，你可以随意在你的代码中实现这个执行器。

## 错误处理

我们有个神秘的 `onRejected` 调用，这是我们这部分谈论的主题。如果我们使用正常的 async/await 或 Promise 链式写法，我们将通过 try/catch 语句来进行错误处理，如果不添加大量的逻辑代码就很难进行错误处理。通常情况下，如果我们需要以某种方式处理错误（比如重试），我们只是在 Promise 内部进行处理，这将会回调自己，可能再次回到同样的点。而且，这还不是一个通用的解决方案 —— 可悲的是，在这里甚至 Generator 也不能帮助我们。我们发现了 Generator 的局限 —— 虽然我们可以控制执行流程，但不能移动 Generator 函数的主体；所以我们不能后退一步，重新执行我们的命令。一个可行的解决方案是使用 [command pattern](https://en.wikipedia.org/wiki/Command_pattern), 它告诉了我们 `yield` 的结果的数据结构 —— 应该是我们需要执行此命令需要的所有信息，这样我们就可以再次执行它了。所以，我们的方法需要改为：


```
function* renderItems() {
  for (item of items) {
    // 我们需要将所有东西传递出去：
    // 方法, 内容, 参数
    yield [renderItem, null, item];
  }
}

```

正如你所看到的，这使得我们不清楚发生了什么 —— 所以，也许最好是写一些 `wrapWithRetry` 方法，它会检查 `catch` 代码块中的错误类型并再次尝试。但是我们仍然可以做一些不影响我们功能的事情。例如，我们可以增加一个关于忽略错误的策略 —— 在 async/await 中我们不得不使用 try/catch 包装每个调用，或者添加空的 `.catch(() => {})` 部分。有了 Generator，我们可以写一个执行器，忽略所有的错误。

```
function runWithIgnore(fn, ...args) {
  const gen = fn(...args);
  return new Promise((resolve, promiseReject) => {
    onFulfilled();

    function onFulfilled(res) {
      proceed({ data: res });
    }

    // 这些是 yield 返回的错误
    // 我们想忽略它们
    // 所以我们像往常一样做，但不去传递出错误
    function onRejected(error) {
      proceed({ error });
    }

    function proceed(data) {
      let result;
      try {
        result = gen.next(data);
      } catch (e) {
        // 这些错误是同步错误（比如 TypeError 等）
        return reject(e);
      }
      // 为了区分错误和正常的结果
      // 我们用它来执行
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
}
```

## 关于 async/await

Async/await 是现在的首选语法（甚至 [co](https://github.com/tj/co#co-v4) 也谈到了它 ），这也是未来。但是，Generator 也在 ECMAScript 标准内，这意味着为了使用它们，除了写几个工具函数，你不需要任何东西。我试图向你们展示一些不那么简单的例子，这些实例的价值取决于你的看法。请记住，没有那么多人熟悉 Generator，并且如果在整个代码库中只有一个地方使用它们，那么使用 Promise 可能会更容易一些 —— 但是另一方面，通过 Generator 某些问题可以被优雅和简洁的处理。


明智地选择 —— 能力越大，责任越重（蜘蛛侠 2，2004）！

### 相关文章

* 15 Dec 2017 » [How to Push a Folder to Github Pages](/2017/12/15/how-to-push-folder-to-github-pages.html)
* 04 Dec 2017 » [How to Cancel Your Promise](/2017/12/04/how-to-cancel-your-promise.html) ([译文：如何取消你的 Promise?](https://juejin.im/post/5a32705a6fb9a045117127fa))
* 17 Nov 2017 » [Git Beyond the Basics](/2017/11/17/git-beyond-the-basics.html)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
