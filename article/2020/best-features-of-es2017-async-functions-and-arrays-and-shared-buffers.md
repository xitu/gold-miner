> * 原文地址：[Best Features of ES2017 — Async Functions and Arrays and Shared Buffers](https://medium.com/javascript-in-plain-english/best-features-of-es2017-async-functions-and-arrays-and-shared-buffers-74dace23aa59)
> * 原文作者：[John Au-Yeung](https://medium.com/@hohanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/best-features-of-es2017-async-functions-and-arrays-and-shared-buffers.md](https://github.com/xitu/gold-miner/blob/master/article/2020/best-features-of-es2017-async-functions-and-arrays-and-shared-buffers.md)
> * 译者：
> * 校对者：

# Best Features of ES2017 — Async Functions and Arrays and Shared Buffers

![Photo by [Elaine Casap](https://unsplash.com/@ecasap?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11232/0*Eb7At4j_2a-MLzuS)

Since 2015, JavaScript has improved immensely.

It’s much more pleasant to use it now than ever.

In this article, we’ll look at the best features of ES2017.

## Async Functions and Array.prototype.forEach()

`Array.prototype.forEach` doesn’t work with the `async` and `await` syntax.

For instance, if we have:

```js
async function downloadContent(urls) {
  urls.forEach(async url => {
    const content = await makeRequest(url);
    console.log(content);
  });
}
```

then we won’t get all the results of the promises because `forEach` doesn’t wait for each promise to finish.

Instead, we want to use the for-of loop to iterate through each async function to get our result:

```js
async function downloadContent(urls) {
  for (const url of urls) {
    const content = await makeRequest(url);
    console.log(content);
  }
}
```

The for-of loop is aware of the `await` operator so we can use it loop run all the async functions sequentially.

If we want to run the async functions in parallel, we can use `Promise.all` :

```js
async function downloadContent(urls) {
  await Promise.all(urls.map(
    async url => {
      const content = await makeRequest(url);
      console.log(content);
    }));
}
```

We mapped the URLs to async functions so that we can call `Promise.all` on the array of promises.

And we return a promise with the resolved value being an array of the promises’ resolved values.

## Immediately Invoked Async Function Expressions

We can create async functions that are run immediately.

For instance, instead of writing:

```js
async function foo() {
  console.log(await promiseFunc());
}
foo();
```

We can write:

```js
(async function () {
  console.log(await promiseFunc());
})();
```

It can also be an arrow function:

```js
(async () => {
  console.log(await promiseFunc());
})();
```

## Unhandled Rejections

We don’t have to worry about unhandled rejections when we use async functions.

This is because browsers report them to us when we encounter them.

For instance, we can write:

```js
async function foo() {
  throw new Error('error');
}
foo();
```

Then we’ll see the error logged in the console.

## Shared Array Buffers

ES2017 introduced shared array buffers which lets us build concurrent apps.

They let us share the bytes of a `SharedArrayBuffer` object between multiple workers and the main thread.

The buffer us shared and is wrapped in a typed array so we can access them.

We can share data between workers quickly and coordination between workers is simple and fast.

For instance, we can create a shared array buffer by writing:

```js
const worker = new Worker('worker.js');

const sharedBuffer = new SharedArrayBuffer(
  100 * Int32Array.BYTES_PER_ELEMENT);
  
worker.postMessage({
  sharedBuffer
});

const sharedArray = new Int32Array(sharedBuffer);
```

We created a worker in `worker.js` .

Then we created a shared buffer with the `SharedArrayBuffer` .

It can contain 100 elements.

Then to share the buffer with the worker, we call `postMessage` to pass the buffer to the worker,.

To access the buffer’s data, we create a new `Int32Array` instance.

Then in the `worker.js` worker, we get the buffer by writing:

```js
self.addEventListener('message', (event) => {
  const {
    sharedBuffer
  } = event.data;
  const sharedArray = new Int32Array(sharedBuffer);
  //...
});
```

We listen to the `message` event and get the `sharedBuffer` property of `event.data` .

Then we can access it the same way.

![Photo by [Jenn Kosar](https://unsplash.com/@foodwithaview?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6912/0*fwSBAfnXl3cfbX0o)

## Conclusion

Async functions don’t work well with existing array instance methods.

Also, we can use shared array buffers to share data between the main and worker threads.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
