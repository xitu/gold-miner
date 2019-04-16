> * 原文地址：[9 Promising Promise Tips](https://dev.to/kepta/promising-promise-tips--c8f)
> * 原文作者：[Kushan Joshi](https://dev.to/kepta)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/promising-promise-tips.md](https://github.com/xitu/gold-miner/blob/master/TODO/promising-promise-tips.md)
> * 译者：[position_柚子君](https://github.com/yanyixin)
> * 校对者：[Starrier](https://github.com/Starriers), [DukeWu](https://github.com/94haox)


# 关于 Promise 的 9 个提示

正如同事所说的那样，Promise 在工作中表现优异。

![prom](https://res.cloudinary.com/practicaldev/image/fetch/s--zlauxVhZ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://user-images.githubusercontent.com/6966254/36483828-3e361d88-16e5-11e8-9f11-cbe99d719066.png)

这篇文章会给你一些如何改善与 Promise 之间关系的建议。

## 1. 你可以在 .then 里面 return 一个 Promise

让我来说明这最重要的一点

> **是的！你可以在 .then 里面 return 一个 Promise**

而且，return 的这个 Promise 将在下一个 `.then` 中自动解析。

```
.then(r => {
    return serverStatusPromise(r); // 返回 { statusCode: 200 } 的 Promise
})
.then(resp => {
    console.log(resp.statusCode); // 200; 注意自动解析的 promise
})
```

## 2. 每次执行 .then 的时候都会自动创建一个新的 Promise

如果熟悉 javascript 的链式风格，那么你应该会感到很熟悉。但是对于一个初学者来说，可能就不会了。

在 Promise 中不论你使用 `.then` 或者 `.catch` 都会创建一个新的 Promise。这个 Promise 是刚刚链式调用的 Promise 和 刚刚加上的 `.then` / `.catch` 的组合。

让我们来看一个 🌰：

```
var statusProm = fetchServerStatus();

var promA = statusProm.then(r => (r.statusCode === 200 ? "good" : "bad"));

var promB = promA.then(r => (r === "good" ? "ALL OK" : "NOTOK"));

var promC = statusProm.then(r => fetchThisAnotherThing());
```

上面 Promise 的关系可以在流程图中清晰的描述出来：
![image](https://res.cloudinary.com/practicaldev/image/fetch/s--gf5-9vXv--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://user-images.githubusercontent.com/6966254/36400725-dac92186-15a0-11e8-8b4f-6a344e6a5229.png)

需要特别注意的是 `promA`、 `promB` 和 `promC` 全部都是不同的但是有关联的 Promise。

我喜欢把 `.then` 想像成一个大型管道，当上游节点出现问题时，水就会停止流向下游。例如，如果 `promB` 失败，下游节点不会受到影响，但是如果 `statusProm` 失败，那么下游的所有节点都将受到影响，即 `rejected`。

## 3. 对调用者来说，`Promise` 的 `resolved/rejected` 状态是唯一的

我认为这个是让 Promise 好好运行的最重要的事情之一。简单来说，如果在你的应用中 Promise 在很多不同的模块之间共享，那么当 Promise 返回 `resolved/rejected` 状态时，所有的调用者都会收到通知。

> 这也意味着没有人可以改变你的 Promise，所以可以放心的把它传递出去。

```
function yourFunc() {
  const yourAwesomeProm = makeMeProm();

  yourEvilUncle(yourAwesomeProm); // 无论 Promise 受到了怎样的影响，它最终都会成功执行

  return yourAwesomeProm.then(r => importantProcessing(r));
}

function yourEvilUncle(prom) {
  return prom.then(r => Promise.reject("destroy!!")); // 可能遭受的影响
}
```

通过上面的例子可以看出，Promise 的设计使得自身很难被改变。正如我上面所说的："保持冷静，并将 Promise 传递下去"。

## 4. Promise 构造函数不是解决方案

我看到很多开发者喜欢用构造函数的风格，他们认为这就是 Promise 的方式。但这却是一个谎言，实际的原因是构造函数 API 和之前回调函数的 API 相似，而且这样的习惯很难改变。

> **如果你发现自己正在到处使用 `Promise 构造函数`，那你的做法是错的！**

要真正的向前迈进一步并且摆脱回调，你需要小心谨慎并且最小程度地使用 Promise 构造函数。

让我们看一下使用 `Promise 构造函数` 的具体情况：

```
return new Promise((res, rej) => {
  fs.readFile("/etc/passwd", function(err, data) {
    if (err) return rej(err);
    return res(data);
  });
});
```

`Promise 构造函数` 应该**只在你想要把回调转换成 Promise 时使用**。
一旦你掌握了这种创建 Promise 的优雅方式，它将会变的非常有吸引力。

让我们看一下冗余的 `Promise 构造函数`。

☠️**错误的**

```
return new Promise((res, rej) => {
    var fetchPromise = fetchSomeData(.....);
    fetchPromise
        .then(data => {
            res(data); // 错误！！！
        })
        .catch(err => rej(err))
})
```

💖**正确的**

```
return fetchSomeData(...); // 正确的！
```

用 `Promise 构造函数` 封装 Promise 是**多余的，并且违背了 Promise 本身的目的**。

😎**高级技巧**

如果你是一个 **nodejs** 开发者，我建议你可以看一看 [util.promisify](http://2ality.com/2017/05/util-promisify.html)。这个方法可以帮助你把 node 风格的回调转换为 Promise。

```
const {promisify} = require('util');
const fs = require('fs');

const readFileAsync = promisify(fs.readFile);

readFileAsync('myfile.txt', 'utf-8')
  .then(r => console.log(r))
  .catch(e => console.error(e));
```

</div>

## 5. 使用 Promise.resolve

Javascript 提供了 `Promise.resolve` 方法，像下面的例子这样简洁：

```
var similarProm = new Promise(res => res(5));
// ^^ 等价于
var prom = Promise.resolve(5);
```

它有多种使用情况，我最喜欢的一种是可以把普通的（异步的）js 对象转化成 Promise。

```
// 将同步函数转换为异步函数
function foo() {
  return Promise.resolve(5);
}
```

当不确定它是一个 Promise 还是一个普通的值的时候，你也可以做一个安全的封装。

```
function goodProm(maybePromise) {
  return Promise.resolve(maybePromise);
}

goodProm(5).then(console.log); // 5

var sixPromise = fetchMeNumber(6);

goodProm(sixPromise).then(console.log); // 6

goodProm(Promise.resolve(Promise.resolve(5))).then(console.log); // 5, 注意，它会自动解析所有的 Promise！
```

## 6.使用 Promise.reject

Javascript 也提供了 `Promise.reject` 方法。像下面的例子这样简洁：

```
var rejProm = new Promise((res, reject) => reject(5));

rejProm.catch(e => console.log(e)) // 5
```

我最喜欢的用法是提前使用 `Promise.reject` 来拒绝。

```
function foo(myVal) {
    if (!mVal) {
        return Promise.reject(new Error('myVal is required'))
    }
    return new Promise((res, rej) => {
        // 从你的大回调到 Promise 的转换！
    })
}
```

简单来说，使用 `Promise.reject` 可以拒绝任何你想要拒绝的 Promise。

在下面的例子中，我在 `.then` 里面使用：

```
.then(val => {
  if (val != 5) {
    return Promise.reject('Not Good');
  }
})
.catch(e => console.log(e)) // 这样是不好的
```

**注意：你可以像 `Promise.resolve` 一样在 `Promise.reject` 中传递任何值。你经常在失败的 Promise 中发现 `Error` 的原因是因为它主要就是用来抛出一个异步错误的。**

## 7. 使用 Promise.all

Javascript 提供了 [Promise.all](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all) 方法。像 ... 这样的简洁，好吧，我想不出来例子了😁。

在伪算法中，`Promise.all` 可以被概括为：

```
接收一个 Promise 数组

    然后同时运行他们

    然后等到他们全部运行完成

    然后 return 一个新的 Promise 数组

    他们其中有一个失败或者 reject，都可以被捕获。
```

下面的例子展示了所有的 Promise 完成的情况：

```
var prom1 = Promise.resolve(5);
var prom2 = fetchServerStatus(); // 返回 {statusCode: 200} 的 Promise

Proimise.all([prom1, prom2])
.then([val1, val2] => { // 注意，这里被解析成一个数组
    console.log(val1); // 5
    console.log(val2.statusCode); // 200
})
```

下面的例子展示了当他们其中一个失败的情况：

```
var prom1 = Promise.reject(5);
var prom2 = fetchServerStatus(); // 返回 {statusCode: 200} 的 Promise

Proimise.all([prom1, prom2])
.then([val1, val2] => {
    console.log(val1); 
    console.log(val2.statusCode); 
})
.catch(e =>  console.log(e)) // 5, 直接跳转到 .catch
```

**注意：`Promise.all` 是很聪明的！如果其中一个 Promise 失败了，它不会等到所有的 Promise 完成，而是立即中止！**

## 8. 不要害怕 reject，也不要在每个 .then 后面加冗余的 `.catch`

我们是不是会经常担心错误会在它们之间的某处被吞噬？

为了克服这个恐惧，这里有一个简单的小提示：

> **让 reject 来处理上游函数的问题。**

在理想的情况下，reject 方法应该是应用的根源，所有的 reject 都会向下传递。

**不要害怕像下面这样写**

```
return fetchSomeData(...);
```

现在如果你想要处理函数中 reject 的情况，请决定是解决问题还是继续 reject。

💘 **解决 reject**

解决 reject 是很简单的，在 `.catch` 不论你返回什么内容，都将被假定为已解决的。然而，如果你在 `.catch` 中返回 `Promise.reject`，那么这个 Promise 将会是失败的。

```
.then(() => 5.length) // <-- 这里会报错
.catch(e => {
        return 5;  // <-- 重新使方法正常运行
})
.then(r => {
    console.log(r); // 5
})
.catch(e => {
    console.error(e); // 这个方法永远不会被调用 :)
})
```

💔**拒绝一个 reject**

拒绝一个 reject 是简单的。**不需要做任何事情。** 就像我刚刚说的，让它成为其他函数的问题。通常情况下，父函数有比当前函数处理 reject 更好的方法。

需要记住的重要的一点是，一旦你写了 catch 方法，就意味着你正在处理这个错误。这个和同步 `try/catch`的工作方式相似。

如果你确实想要拦截一个 reject：（我强烈建议不要这样做！）

```
.then(() => 5.length) // <-- 这里会报错
.catch(e => {
  errorLogger(e); // 做一些错误处理
  return Promise.reject(e); // 拒绝它，是的，你可以这么做！
})
.then(r => {
    console.log(r); // 这个 .then (或者任何后面的 .then) 将永远不会被调用，因为我们在上面使用了 reject :)
})
.catch(e => {
    console.error(e); //<-- 它变成了这个 catch 方法的问题
})
```

**.then(x,y) 和 then(x).catch(x) 之间的分界线**

`.then` 接收的第二个回调函数参数也可以用来处理错误。它和 `then(x).catch(x)` 看起来很像，但是他们处理错误的区别在于他们自身捕获的错误。

我会用下面的例子来说明这一点：

```
.then(function() {
   return Promise.reject(new Error('something wrong happened'));
}).catch(function(e) {
   console.error(e); // something wrong happened
});

.then(function() {
   return Promise.reject(new Error('something wrong happened'));
}, function(e) { // 这个回调处理来自当前 `.then` 方法之前的错误
    console.error(e); // 没有错误被打印出来
});
```

当你想要处理的是来自上游 Promise 而不是刚刚在 `.then` 里面加上去的错误的时候， `.then(x,y)` 变的很方便。

提示: 99.9% 的情况使用简单的 `then(x).catch(x)` 更好。

## 9. 避免 .then 回调地狱

这个提示是相对简单的，尽量避免 `.then` 里包含 `.then` 或者 `.catch`。相信我，这比你想象的更容易避免。

☠️**错误的**

```
request(opts)
.catch(err => {
  if (err.statusCode === 400) {
    return request(opts)
           .then(r => r.text())
           .catch(err2 => console.error(err2))
  }
})
```

💖**正确的**

```
request(opts)
.catch(err => {
  if (err.statusCode === 400) {
    return request(opts);
  }
})
.then(r => r.text())
.catch(err => console.erro(err));
```

有些时候我们在 `.then` 里面需要很多变量，那就别无选择了，只能再创建一个 `.then` 方法链。

```
.then(myVal => {
    const promA = foo(myVal);
    const promB = anotherPromMake(myVal);
    return promA
          .then(valA => {
              return promB.then(valB => hungryFunc(valA, valB)); // 很丑陋!
          })
})
```

我推荐使用 ES6 的解构方法混合着 `Promise.all` 方法就可以解决这个问题。

```
.then(myVal => {
    const promA = foo(myVal);
    const promB = anotherPromMake(myVal);
    return Promise.all([prom, anotherProm])
})
.then(([valA, valB]) => {   // 很好的使用 ES6 解构
    console.log(valA, valB) // 所有解析后的值
    return hungryFunc(valA, valB)
})
```

注意：如果你的 node/浏览器/老板/意识允许，还可以使用 [async/await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function) 方法来解决这个问题。

**我真心希望这篇文章对你理解 Promise 有所帮助。**

请查看我之前的博客文章。

*   [一个初学者指导 Javascript 内存泄漏问题](https://dev.to/kepta/a-toddlers-guide-to-memory-leaks-in-javascript-25lf)
*   [了解 Javascript 中的默认参数](https://dev.to/kepta/understanding-default-parameters-in-javascript-ali)

如果你 ❤️ 这篇文章，请分享这篇文章来传播它。

在 Twitter 上联系我 [@kushan2020](https://twitter.com/kushan2020)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
