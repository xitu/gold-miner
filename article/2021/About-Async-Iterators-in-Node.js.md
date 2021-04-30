> * 原文地址：[About Async Iterators in Node.js](https://blog.risingstack.com/async-iterators-in-node-js/)
> * 原文作者：[janos](https://blog.risingstack.com/author/janos/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/About-Async-Iterators-in-Node.js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/About-Async-Iterators-in-Node.js.md)
> * 译者：[Isildur46](https://github.com/Isildur46)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)

# 关于 Node.js 中的异步迭代器
> 当我们在迭代过程中不清楚值和结束状态时，我们可以使用异步迭代器，用它来解决（resolve）普通对象并最终得到 promise。

Node 在 10.0.0 版本中加入了异步迭代器，并且这个功能在最近逐渐赢得了社区的青睐。本文我们将了解什么是异步迭代器，并探索它的使用场景。

## **什么是异步迭代器**

所以什么是异步迭代器？他们其实就是之前迭代器的异步版本。当我们在迭代过程中不清楚值和结束状态时，我们可以使用异步迭代器，用它来解决（resolve）普通的 `{ value: any, done: boolean }` 对象并最终得到 promise。我们也可以使用 for-await-of 循环来帮助我们在异步迭代器中进行循环操作，这就像同步迭代器的 for-of 循环那样。

```
const asyncIterable = [1, 2, 3];
asyncIterable[Symbol.asyncIterator] = async function*() {
  for (let i = 0; i < asyncIterable.length; i++) {
    yield { value: asyncIterable[i], done: false }
  }
  yield { done: true };
};

(async function() {
  for await (const part of asyncIterable) {
    console.log(part);
  }
})();

```

for-await-of 循环会等待每个它接收的 promise 被解决，然后再执行下一个，这和常规的 for-of 循环是对应的。

目前，除了流以外并没有很多结构支持异步迭代器。但是正如本例所示，可以手动在任何可迭代对象上添加 symbol。

## **作为异步迭代器的流**

在处理流的时候，异步迭代器非常有用。可读流、可写流、双向流、转换流都带有开箱即用的 asyncIterator symbol。

```
async function printFileToConsole(path) {
  try {
    const readStream = fs.createReadStream(path, { encoding: 'utf-8' });

    for await (const chunk of readStream) {
      console.log(chunk);
    }

    console.log('EOF');
  } catch(error) {
    console.log(error);
  }
}

```

如果你像这样编写代码，就不必在迭代每个分片时去监听 `data` 和 `end` 事件了，并且 for-await-of 循环会在流结束时自行终止。

## **消费分页的 API**

我们也可以借助异步迭代器，从而让我们很容易地从源获取分页过的数据。为此，我们需要某种方式来重构 Node https 请求方法所返回的流的响应体。由于 Node 中请求和响应都是流，我们也可以使用异步迭代器实现这一功能：

```
const https = require('https');

function homebrewFetch(url) {
  return new Promise(async (resolve, reject) => {
    const req = https.get(url, async function(res) {
      if (res.statusCode >= 400) {
        return reject(new Error(`HTTP Status: ${res.statusCode}`));
      }

      try {
        let body = '';

        /*
          不再使用 res.on 监听流的数据，
          而是使用 for-await-of 向剩余响应体
          拼接数据切片
        */
        for await (const chunk of res) {
          body += chunk;
        }
    
        // 处理没有响应体的情况
        if (!body) resolve({});
        // 我们需要解析 body 来获取 json，它是字符串
        const result = JSON.parse(body);
        resolve(result);
      } catch(error) {
        reject(error)
      }
    });

    await req;
    req.end();
  });
}

```

我们会向 **[猫猫 API](https://thecatapi.com/)** 发起请求，获取一些猫猫图，10 张一页，每个请求中间暂停 7 秒，最多获取 5 页数据，这样就能避免猫猫 API 过载而出现猫病。

```
function fetchCatPics({ limit, page, done }) {
  return homebrewFetch(`https://api.thecatapi.com/v1/images/search?limit=${limit}&page=${page}&order=DESC`)
    .then(body => ({ value: body, done }));
}

function catPics({ limit }) {
  return {
    [Symbol.asyncIterator]: async function*() {
      let currentPage = 0;
      // 5 页之后停止
      while(currentPage < 5) {
        try {
          const cats = await fetchCatPics({ currentPage, limit, done: false });
          console.log(`Fetched ${limit} cats`);
          yield cats;
          currentPage ++;
        } catch(error) {
          console.log('There has been an error fetching all the cats!');
          console.log(error);
        }
      }
    }
  };
}

(async function() {
  try {
    for await (let catPicPage of catPics({ limit: 10 })) {
      console.log(catPicPage);
      // 每个请求间等待 7 秒
      await new Promise(resolve => setTimeout(resolve, 7000));
    }
  } catch(error) {
    console.log(error);
  }
})()

```

这样一来，我们可以每 7 秒自动获取一整页的猫猫图，然后吸爆。

有一种更常规的翻页手法是实现并暴露 `next` 和 `previous` 两个方法，用它们来控制页面导航：

```
function actualCatPics({ limit }) {
  return {
    [Symbol.asyncIterator]: () => {
      let page = 0;
      return {
        next: function() {
          page++;
          return fetchCatPics({ page, limit, done: false });
        },
        previous: function() {
          if (page > 0) {
            page--;
            return fetchCatPics({ page, limit, done: false });
          }
          return fetchCatPics({ page: 0, limit, done: true });
        }
      }
    }
  };
}

try {
    const someCatPics = actualCatPics({ limit: 5 });
    const { next, previous } = someCatPics[Symbol.asyncIterator]();
    next().then(console.log);
    next().then(console.log);
    previous().then(console.log);
} catch(error) {
  console.log(error);
}

```

如你所见，当我们有很多页数据要获取，或者类似于在应用的 UI 中要实现无限滚动时，异步迭代器是非常有用的。

> 如果您在寻找一支经历实战考验的 Node.js 团队来搭建产品，或者想要拓展您的工程师队伍，敬请考虑一下使用 RisingStack 的服务：https://risingstack.com/nodejs-development-consulting-services

浏览器支持这些功能已经有一段时间了，Chrome 从 63 版开始支持，Firefox 从 57 版开始支持，Safari 从 11.1 版开始支持。然而 IE 和 Edge 目前并不支持（译注：Edge 已从 79 版本开始支持了）。

关于异步迭代器的使用场景，你有新点子了吗？你是否已准备好了在实际应用中使用它？

请在下方评论让我们一起交流吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
