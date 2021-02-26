> * 原文地址：[About Async Iterators in Node.js](https://blog.risingstack.com/async-iterators-in-node-js/)
> * 原文作者：[janos](https://blog.risingstack.com/author/janos/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/About-Async-Iterators-in-Node.js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/About-Async-Iterators-in-Node.js.mdd)
> * 译者：
> * 校对者：

# About Async Iterators in Node.js
> Async Iterators can be used when we don't know the values & end state we iterate over. Instead, we get promises eventually resolving to the usual object.

Async iterators have been around in Node since version 10.0.0, and they seem to be gaining more and more traction in the community lately. In this article, we’ll discuss what Async iterators do and we'll also tackle the question of what they could be used for.

## **What are Async Iterators**

So what are async iterators? They are practically the async versions of the previously available iterators. Async iterators can be used when we don't know the values and the end state we iterate over. Instead, we get promises that eventually resolve to the usual `{ value: any, done: boolean }` object. We also get the for-await-of loop to help us with looping over async iterators. That is just like the for-of loop is for synchronous iterators.

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

The for-await-of loop will wait for every promise it receives to resolve before moving on to the next one, as opposed to a regular for-of loop.

Outside of streams, there are not a lot of constructs that support async iteration currently, but the symbol can be added to any iterable manually, as seen here.

## **Streams as async iterators**

Async iterators are very useful when dealing with streams. Readable, writable, duplex, and transform streams all have the asyncIterator symbol out of the box.

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

If you write your code this way, you don't have to listen to the 'data' and 'end' events as you get every chunk by iterating, and the for-await-of loop ends with the stream itself.

## **Consuming paginated APIs**

You can also fetch data from sources that use pagination quite easily using async iteration. To do this, we will also need a way to reconstruct the body of the response from the stream the Node https request method is giving us. We can use an async iterator here as well, as https requests and responses are streams in Node:

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
          Instead of res.on to listen for data on the stream,
          we can use for-await-of, and append the data chunk
          to the rest of the response body
        */for await (const chunk of res) {
          body += chunk;
        }
    
        // Handle the case where the response don't have a bodyif (!body) resolve({});
        // We need to parse the body to get the json, as it is a stringconst result = JSON.parse(body);
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

We are going to make our requests to the **[Cat API](https://thecatapi.com/)** to fetch some cat pictures in batches of 10. We will also include a 7-second delay between the requests and a maximum page number of 5 to avoid overloading the cat API as that would be CATtastrophic.

```
function fetchCatPics({ limit, page, done }) {
  return homebrewFetch(`https://api.thecatapi.com/v1/images/search?limit=${limit}&page=${page}&order=DESC`)
    .then(body => ({ value: body, done }));
}

function catPics({ limit }) {
  return {
    [Symbol.asyncIterator]: async function*() {
      let currentPage = 0;
      // Stop after 5 pageswhile(currentPage < 5) {
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
      // Wait for 7 seconds between requestsawait new Promise(resolve => setTimeout(resolve, 7000));
    }
  } catch(error) {
    console.log(error);
  }
})()

```

This way, we automatically get back a pageful of cats every 7 seconds to enjoy.

A more common approach to navigation between pages might be to implement a `next` and a `previous` method and expose these as controls:

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

As you can see, async iterators can be quite useful when you have pages of data to fetch or something like infinite scrolling on the UI of your application.

> In case you're looking for a battle-tested Node.js team to build your product, or extend your engineering team, be kind and consider RisingStack's services: https://risingstack.com/nodejs-development-consulting-services

These features have been available in browsers for some time as well, in Chrome since version 63, in Firefox since version 57 and in Safari since version 11.1. They are, however, currently unavailable in IE and Edge.

Did you get any new ideas on what you could use async iterators for? Do you already use them in your application?

Let us know in the comments below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
