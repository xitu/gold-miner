> * 原文地址：[How to Cancel Your Promise](http://blog.bloomca.me/2017/12/04/how-to-cancel-your-promise.html)
> * 原文作者：[Seva Zaikov](http://blog.bloomca.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-to-cancel-your-promise.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-cancel-your-promise.md)
> * 译者：
> * 校对者：

# How to Cancel Your Promise

In ES2015, new version of EcmaScript, standart of JavaScript, we got new asynchronous primitive [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise). It is a very powerful concept, which allows us to avoid notoriously famous [callback hell](http://callbackhell.com/). For instance, several async actions easily cause code like that:

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

As you can see, we nest several calls, and in case we want to change some calls order, or we want to make several calls in parallel, we will have hard time managing this code. With promises we can refactor it to much more readable version:

```
// callback is not needed anymore – we just attach `.then`
// handler to result of this function
function updateUser() {
  return fetchData()
    .then(updateUserData)
    .then(updateUserAddress)
    .then(updateMarketingData);
}

```

Not only it is much more concise and readable, but it makes it very easy to switch order of calls, make some calls in parallel, or just remove unnecessary call (or add another add in the middle of the chain).

> One of the drawbacks of using promise chains is that we don’t have access to the lexical scope (or to variables in closure) of callbacks. You can read [a great article](http://2ality.com/2017/08/promise-callback-data-flow.html) how to solve this problem from Dr. Alex Rauschmayer

But, as soon it [was discovered](https://stackoverflow.com/questions/30233302/promise-is-it-possible-to-force-cancel-a-promise), you can not cancel a promise, and this is a real problem. Sometimes you _have_ to cancel something, and you need to build a workaround – the amount of work depends how often do you need this functionality.

## Use Bluebird

[Bluebird](http://bluebirdjs.com/docs/getting-started.html) is a promise library, which is fully compliant with native promises, but which also adds couple of helpful functions to Promise.prototype. We won’t cover them here, except for the [cancel](http://bluebirdjs.com/docs/api/cancellation.html) method, which does partially what we want from it – it allows us to have custom logic in case we want to cancel our promise using `promise.cancel` (Why partially? Because it is verbose and not generic).

Let’s look how we can implement cancellation using Bluebird in our example:

```
import Promise from 'Bluebird';

function updateUser() {
  return new Promise((resolve, reject, onCancel) => {
    let cancelled = false;

    // you need to config Bluebird to have cancellation
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
      // promise is resolved only with one parameter
      return (data) => {
        if (!cancelled) {
          return fn(data);
        }
      };
    }
  });
}

const promise = updateUser();
// wait some time...
promise.cancel(); // user will be updated any way
```

As you can see, we added a lot to our previous clean example. Unfortunately, there is no other way, since we can’t just stop a random promise chain from executing (if we want, we’ll need to wrap it into another function), so we need to touch all function, wrapping into cancelling token aware executor.

## Pure Promises

Tecnique above is not really special about bluebird, it is more about interface – you can implement your own version of cancellation, at the cost of additional property/variable. Usually this approached is called `cancellationToken`, and in the essense, it is almost the same as the previous one, but instead of having this function on the `Promise.prototype.cancel`, we instantiate it in a different object – we can return an object with `cancel` property, or we can accept additional parameter, an object, where we will add a property.

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
// wait some time...
cancel(); // user will be updated any way
```

This is a little bit more verbose than a previous solution, but it does exactly the same, and in case you don’t have Bluebird (or just don’t want to use non-standard methods on promises), it is a viable solution. As you can see, we changed signature – now we return object instead of a promise, but in fact we can just pass a parameter to the function, an object, and attach `cancel` method on it (or monkey-patch instance of Promise, but it can create you problems later). If you have this requirement only in couple places, it is a good solution.

## Switch to generators

Generators are another feature of ES2015, but they are not that popular for some reasons. Think about it, though, before adopting them – will it be very confusing for your newcomers or you can deal with it? Also, they exist in some other languages, like [Python](https://wiki.python.org/moin/Generators), so it might be easy for you as a team to go with this solution.

Generators deserve their own article, so I won’t cover the basics, and just implement a function to execute generators, which will allow us to cancel our promises in a general (!) way without affecting our code.

```
// this is a core function which will run our async code
// and provide cancellation method
function runWithCancel(fn, ...args) {
  const gen = fn(...args);
  let cancelled, cancel;
  const promise = new Promise((resolve, promiseReject) => {
    // define cancel function to return it from our fn
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
      // we assume we always receive promises, so no type checks
      return value.then(onFulfilled, onRejected);
    }
  });

  return { promise, cancel };
}
```

This was a pretty big function, but it is basically it (except for checks, of course – this is a very naïve implementation) – code itself will remain exactly the same, we will literally get `cancel` function for free! Let’s see how it will look like in our example:

```
// * means that it is a generator function
// you can put * almost anywhere :)
// this is very similar syntactically to async/await
function* updateUser() {
  // we assume all our function return promises
  // otherwise we'd need to adjust our runner to
  // accept generators
  const data = yield fetchData();
  const userData = yield updateUserData(data);
  const userAddress = yield updateUserAddress(userData);
  const marketingData = yield updateMarketingData(userAddress);
  return marketingData;
}

const { promise, cancel } = runWithCancel(updateUser);

// will do the trick
cancel();
```

As you can see, the interface remained the same, but now we have the option to cancel any generator-based functions during their execution for free, just wrapping into appropriate runner. The downside is consistency – if it is just couple places in your codebase, then it will be really confusing for other people to discover that you are using all possible async approaches in a single codebase; it is yet another trade-off.

Generators are, I guess, the most extensible option, because you do literally everything you want – in case of some condition you can pause, wait, retry, or just run another generator. However, I have not seen them very often in JavaScript code, so you should think about adoption and cognitive load – do you really have a lot of use-cases for them? If yes, then it is a very good solution and you’ll likely thank yourself in the future.

## Note on async/await

In the version of [ES2017](https://tc39.github.io/ecma262/2017/#sec-async-function-definitions) async/await were adopted, and you can use them without any flags in Node.js starting from the [version 7.6](https://www.infoq.com/news/2017/02/node-76-async-await). Unfortunately, there is nothing to support cancellation, and since async functions return promise implicitly, we can’t really affect it (attach a property, or return something else), only resolved/rejected values. It means that in order to make our function cancellable, we’ll need to pass a token object, and wrap each call in our famous wrapper:

```
async function updateUser(token) {
  let cancelled = false;

  // we don't reject, since we don't have access to
  // the returned promise
  // so we just don't call other functions, and reject
  // in the end
  token.cancel = () => {
    cancelled = true;
  };

  const data = await wrapWithCancel(fetchData)();
  const userData = await wrapWithCancel(updateUserData)(data);
  const userAddress = await wrapWithCancel(updateUserAddress)(userData);
  const marketingData = await wrapWithCancel(updateMarketingData)(userAddress);

  // because we've wrapped all functions, in case of cancellations
  // we'll just fall through to this point, without calling any of
  // actual functions. We also can't reject by ourselves, since
  // we don't have control over returned promise
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
// wait some time...
token.cancel(); // user will be updated any way
```

It is very similar solution, but because we don’t reject directly in `cancel` method, it might confuse a reader. On the other side, it is a standard feature of the language now, it has very convenient syntax, it allows you to use results of previous calls in the following (so problem of promise chaining is solved here), and has very clear and intuitive errors handling syntax via `try/catch`. So if cancellation does not bother you (or you are fine to use this way to cancel something), then this feature is definitely a superior way to write async code in modern JavaScript.

## Use streams (like RxJS)

Streams are completely different concept, but they are actually widespread [not only in JavaScript](http://reactivex.io/), so you might consider it as a platform-independent pattern. Streams are better and worse than promises/generators. Better if you already have them and handle some (or maybe all) async logic using them, and worse if you don’t, because it is absolutely different approach.

I am not a big specialist in using streams, but using them for a bit, I can say that you should either use them for all async stuff, or for none. So, in case you are already are using them, this question should not be a hard one for you, since it was a long time well-known feature of stream libraries.

As I mentioned, I don’t have enough experience with streams to give solutions using them, so I’ll just put couple of links for streams cancellation:

* [github issue explanation](https://github.com/Reactive-Extensions/RxJS/issues/817#issuecomment-122729155)
* [article about take* methods](https://medium.com/@benlesh/rxjs-dont-unsubscribe-6753ed4fda87)

## Accept it

Things are going to the right direction – fetch is going to get [abort](https://github.com/whatwg/fetch/issues/447) method, and cancellation is being under hot discussion for a long time. Will it result in some sort of cancellation? Maybe yes, maybe not. But also, cancellation is not that crucial for a lot of applications – yes, you can make some additional requests, but it is a pretty rare case to have more than several consequent requests. Also, if it happens once or twice, you can just workaround those specific functions using the extended example from the beginning. But in case there are a lot of such cases in your application, consider something from the listed above.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
