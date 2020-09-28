> * 原文地址：[Best Features of ES2017 — Async Functions and Arrays and Shared Buffers](https://medium.com/javascript-in-plain-english/best-features-of-es2017-async-functions-and-arrays-and-shared-buffers-74dace23aa59)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/best-features-of-es2017-async-functions-and-arrays-and-shared-buffers.md](https://github.com/xitu/gold-miner/blob/master/article/2020/best-features-of-es2017-async-functions-and-arrays-and-shared-buffers.md)
> * 译者：[tonylua](https://github.com/tonylua)
> * 校对者：[Chorer](https://github.com/Chorer), [dupanpan](https://github.com/dupanpan)

# ES2017 最佳特性 -- 数组中的异步函数以及共享缓冲区

![照片由 [Elaine Casap](https://unsplash.com/@ecasap?utm_source=medium&utm_medium=referral) 拍摄并发表在 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 上](https://oscimg.oschina.net/oscnet/up-1da089eee95145e809f80d9ce4b883ce7b3.JPEG)

自 2015 年起，JavaScript 可谓突飞猛进。

现在使用它比过去要舒服多了。

在本文中，我们将着眼于 ES2017 的最佳特性。

## 异步函数（Async Functions）和 Array.prototype.forEach()

`Array.prototype.forEach` 并不适用 `async` 和 `await` 语法。

举例来说，如果有如下代码：

```js
async function downloadContent(urls) {
  urls.forEach(async url => {
    const content = await makeRequest(url);
    console.log(content);
  });
}
```

那么并不会得到包含若干 promise 的结果，因为 `forEach` 不会等待每个 promise 完成。

取而代之的是，可以用 for-of 循环来迭代每个异步函数以获取结果：

```js
async function downloadContent(urls) {
  for (const url of urls) {
    const content = await makeRequest(url);
    console.log(content);
  }
}
```

for-of 循环能感知 `await` 操作符，所以可以用它循序运行所有异步函数。

若要并行运行若干异步函数，可以使用 `Promise.all`：

```js
async function downloadContent(urls) {
  await Promise.all(urls.map(
    async url => {
      const content = await makeRequest(url);
      console.log(content);
    }));
}
```

我们将多个 URL 映射为异步函数的集合，这样一来就能在 promise 数组上调用 `Promise.all` 了。

调用该方法后会返回一个 promise，其解决值（resolved value）是一个包含了每一个 promise 解决值的数组。

## 立即调用异步函数表达式

我们也可以创建立即运行的异步函数。

举例来说，相比于以下写法：

```js
async function foo() {
  console.log(await promiseFunc());
}
foo();
```

我们可以这么写：

```js
(async function () {
  console.log(await promiseFunc());
})();
```

也可以写成箭头函数：

```js
(async () => {
  console.log(await promiseFunc());
})();
```

## 未处理过的 rejection

在使用异步函数时，并不用担心未处理过的 rejection 。

这是因为当浏览器遇到它们时会自动报告。

举例来说，我们可以这样写：

```js
async function foo() {
  throw new Error('error');
}
foo();
```

而后我们将在控制台中看到被记录的报错信息。

## Shared Array Buffers

ES2017 引入的共享数组缓冲区（shared array buffers）使得我们可以构建并发的应用了。

这让我们可以在多个 worker 和主线程之间共享 `SharedArrayBuffer` 对象的字节数据。

被共享的缓冲由一个类型化数组（typed array）包裹，这样就能访问到它们了。

我们可以快速在 worker 间共享数据，而跨 worker 的数据协同也变得简便了。

举例来说，可以编写如下代码来创建一个共享数组缓冲区：

```js
const worker = new Worker('worker.js');

const sharedBuffer = new SharedArrayBuffer(
  100 * Int32Array.BYTES_PER_ELEMENT);
  
worker.postMessage({
  sharedBuffer
});

const sharedArray = new Int32Array(sharedBuffer);
```

我们在 `worker.js`  中创建了一个 worker。

之后我们用 `SharedArrayBuffer` 创建了一个 shared buffer。

它包含 100 个元素。

接着，为了与其它 worker 共享缓冲区，我们调用了 `postMessage` 以发送缓冲数据。

要访问缓冲区中的数据，就得创建一个新的 `Int32Array` 实例。

接下来在 `worker.js` worker 中，这样编写以获得缓冲数据：

```js
self.addEventListener('message', (event) => {
  const {
    sharedBuffer
  } = event.data;
  const sharedArray = new Int32Array(sharedBuffer);
  //...
});
```

我们监听了 `message` 事件并从 `event.data` 中取得了 `sharedBuffer` 属性。

之后就能用与先前相同的方式访问它了。

## 总结

异步函数并不适配既有的数组实例方法。

同时，我们可以使用共享数组缓冲区在主线程和 worker 线程之间共享数据。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
