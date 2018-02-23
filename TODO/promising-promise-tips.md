> * 原文地址：[9 Promising Promise Tips](https://dev.to/kepta/promising-promise-tips--c8f)
> * 原文作者：[Kushan Joshi](https://dev.to/kepta)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/promising-promise-tips.md](https://github.com/xitu/gold-miner/blob/master/TODO/promising-promise-tips.md)
> * 译者：
> * 校对者：


# 9 Promising Promise Tips

Promises are great to work with! Or so does your fellow developer at work says.

![prom](https://res.cloudinary.com/practicaldev/image/fetch/s--zlauxVhZ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://user-images.githubusercontent.com/6966254/36483828-3e361d88-16e5-11e8-9f11-cbe99d719066.png)

This article would give you to the point no bullshit tips on how to improve your relationship with the Promises.

## 1. You can return a Promise inside a .then

Let me make the most important tip standout

> **Yes! you can return a Promise inside a .then**

Also, the returned promise is automatically unwrapped in the next `.then`

```
.then(r => {
    return serverStatusPromise(r); // this is a promise of { statusCode: 200 }
})
.then(resp => {
    console.log(resp.statusCode); // 200; notice the automatic unwrapping of promise
})
```

## 2. You create a new Promise everytime you do .then

If you are familiar with the dot chaining style of javascript you would feel at home. But for a newcomer this might now be obvious.

In promises whenever you `.then` or `.catch` you are creating a new Promise. This promise is a composition of the promise you just chained and the `.then` / `.catch` you just attached.

Let us look at an example:

```
var statusProm = fetchServerStatus();

var promA = statusProm.then(r => (r.statusCode === 200 ? "good" : "bad"));

var promB = promA.then(r => (r === "good" ? "ALL OK" : "NOTOK"));

var promC = statusProm.then(r => fetchThisAnotherThing());
```

The relationship of above promises can be described neatly in a flow chart:
![image](https://res.cloudinary.com/practicaldev/image/fetch/s--gf5-9vXv--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://user-images.githubusercontent.com/6966254/36400725-dac92186-15a0-11e8-8b4f-6a344e6a5229.png)

The important thing to note here is that `promA`, `promB` and `promC` are all different promises but related.

I like to think of `.then`ing as a big massive plumbing where water will stop flowing to the children when the parent node malfunctions. For eg. if `promB` fails, no other node will be affected but if `statusProm` fails all the nodes will be affected i.e. `rejected`.

## 3. A Promise is resolved/rejected for EVERYONE

I find this as one of the most important thing that makes promises great to work with. To put it simply, if a promise is shared between multiple parts of your app, all of them would get notified when it gets `resolved/rejected`.

> This also means nobody can ever mutate your promise, so please feel free to pass it around without worrying.

```
function yourFunc() {
  const yourAwesomeProm = makeMeProm();

  yourEvilUncle(yourAwesomeProm); // rest assured you promise will work, regardless of how evil uncle consumes your promise

  return yourAwesomeProm.then(r => importantProcessing(r));
}

function yourEvilUncle(prom) {
  return prom.then(r => Promise.reject("destroy!!")); // your evil uncle
}
```

In the example above you can see that promise by design makes it difficult for anyone to do nefarious things. As I said above, `Keep calm and pass the promise around`

## 4. Promise Constructor is not the solution

I have seen fellow developers exploiting the constructor style everywhere, thinking they are doing it the promise way. But this is a big lie, the actual reason is that the constructor API is very similar to the good old callback API and old habits die hard.

> **If you find yourself writing `Promise constructors` everywhere, you are doing it wrong!**

To actually take a step forward and move away from callbacks, you need to carefully minimize the amount of Promise constructor's you use.

Let us jump to the actual use case of a `Promise constructor`:

```
return new Promise((res, rej) => {
  fs.readFile("/etc/passwd", function(err, data) {
    if (err) return rej(err);
    return res(data);
  });
});
```

`Promise constructor` should **only be used when you want to convert a callback to promise**.
Once you have grasped this beautiful way of creating promises, it can become really tempting to use it at other places which are already promisified!

Let us look at a redundant `Promise constructor`

☠️**Wrong**

```
return new Promise((res, rej) => {
    var fetchPromise = fetchSomeData(.....);
    fetchPromise
        .then(data => {
            res(data); // wrong!!!
        })
        .catch(err => rej(err))
})
```

💖**Correct**

```
return fetchSomeData(...); // when it looks right, it is right!
```

Wrapping a promise with `Promise constructor` is just **redundant and defeats the purpose of the promise itself**.

😎**Protip**

If you are a **nodejs** person, I recommend checking out [util.promisify](http://2ality.com/2017/05/util-promisify.html). This tiny thing helps you convert your node style callback into promises.

```
const {promisify} = require('util');
const fs = require('fs');

const readFileAsync = promisify(fs.readFile);

readFileAsync('myfile.txt', 'utf-8')
  .then(r => console.log(r))
  .catch(e => console.error(e));
```

</div>

## 5. Use Promise.resolve

Javascript provides `Promise.resolve`, which is a short hard for writting something like this:

```
var similarProm = new Promise(res => res(5));
// ^^ is equivalent to
var prom = Promise.resolve(5);
```

This has multiple use cases and my favourite one being able to convert a regular (sync) javascript object into a promise.

```
// converting a sync function to an async function
function foo() {
  return Promise.resolve(5);
}
```

You can also use it as a safety wrapper around a value which you are unsure whether it is a promise or regular value.

```
function goodProm(maybePromise) {
  return Promise.resolve(maybePromise);
}

goodProm(5).then(console.log); // 5

var sixPromise = fetchMeNumber(6); // this is a promise which resolves into number 5

goodProm(sixPromise).then(console.log); // 6

goodProm(Promise.resolve(Promise.resolve(5))).then(console.log); // 5, Notice it unwraps all the layers of promises automagically!
```

## 6.Use Promise.reject

Javascript also provides `Promise.reject`, which is a short hand for this

```
var rejProm = new Promise((res, reject) => reject(5));

rejProm.catch(e => console.log(e)) // 5
```

One of my favourite use case is rejecting early with `Promise.reject`.

```
function foo(myVal) {
    if (!mVal) {
        return Promise.reject(new Error('myVal is required'))
    }
    return new Promise((res, rej) => {
        // your big callback to promie conversion!
    })
}
```

In simple words, use `Promise.reject` wherever you want to reject promise.

In the example below I use inside a `.then`

```
.then(val => {
  if (val != 5) {
    return Promise.reject('Not Good');
  }
})
.catch(e => console.log(e)) // Not Good
```

_Note: You can put any value inside `Promise.reject` just like `Promise.resolve`. The reason you often find `Error` in a rejected promise is that it is primarily used for throwing an async error._

## 7. Use Promise.all

Javascript provides [Promise.all](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all), which is a shorthand for …. well I can't come up with this 😁.

In a pseudo algorithm, `Promise.all` can be summarised as

```
Takes an array of promises

    then runs all of them simultaneously

    then waits for all of them to finish

    then returns a new Promise which resolves into an Array

    catches if even a single fails/rejects.
```

The following example shows when all the promises resolve:

```
var prom1 = Promise.resolve(5);
var prom2 = fetchServerStatus(); // returns a promise of {statusCode: 200}

Proimise.all([prom1, prom2])
.then([val1, val2] => { // notice that it resolves into an Array
    console.log(val1); // 5
    console.log(val2.statusCode); // 200
})
```

This one shows when one of them fails:

```
var prom1 = Promise.reject(5);
var prom2 = fetchServerStatus(); // returns a promise of {statusCode: 200}

Proimise.all([prom1, prom2])
.then([val1, val2] => {
    console.log(val1); 
    console.log(val2.statusCode); 
})
.catch(e =>  console.log(e)) // 5, jumps directly to .catch
```

_Note: `Promise.all` is smart! In case of a rejection, it doesn't wait for all of the promises to complete!. Whenever any promise rejects, it immediately aborts without waiting for other promises to complete._

## 8. Do not fear the rejection _OR_

Do not append redundant `.catch` after every .then

How often do we fear errors being gobbled up somewhere in between?

To overcome this fear, here's a very simple tip:

> **Make the rejection handling the problem of the parent function.**

Ideally, rejection handling should be at the root of your app and all the promise rejections trickle down to it.

**Do not fear writing something like this**

```
return fetchSomeData(...);
```

Now if you do want to handle the rejection in your function, decide whether you want to resolve things or continue the rejection.

💘 **Resolving a rejection**

Resolving rejection is simple, in the `.catch` whatever you return would be assumed to be resolved. However there is a catch (pun intended), if you return a `Promise.reject` in a `.catch` the promise will be rejected.

```
.then(() => 5.length) // <-- something wrong happenned here
.catch(e => {
        return 5;  // <-- making javascript great again
})
.then(r => {
    console.log(r); // 5
})
.catch(e => {
    console.error(e); // this function will never be called :)
})
```

💔**Rejecting a Rejection**
To reject a rejection is simple, **don't do anything.** As I said above, let it be some other functions problem. More often than not, parent functions have a better way to handle the rejection than your current function.

The important thing to remember is, once you write a catch it means you are handling the error. This is similar to how sync `try/catch` works.

If you do want to intercept a rejection: (I highly recommend not!)

```
.then(() => 5.length) // <-- something wrong happenned here
.catch(e => {
  errorLogger(e); // do something impure
  return Promise.reject(e); // reject it, Yes you can do that!
})
.then(r => {
    console.log(r); // this .then (or any subsequent .then) will never be called as we rejected it above :)
})
.catch(e => {
    console.error(e); //<-- it becomes this catch's problem
})
```

**The fine line between .then(x,y) and then(x).catch(x)**
The `.then` accepts a second callback parameter which can also be used to handle errors. This might look similar to doing something like `then(x).catch(x)`, but both these error handlers differ in which error they catch.

I will let the following example speak for itself.

```
.then(function() {
   return Promise.reject(new Error('something wrong happened'));
}).catch(function(e) {
   console.error(e); // something wrong happened
});

.then(function() {
   return Promise.reject(new Error('something wrong happened'));
}, function(e) { // callback handles error coming from the chain above the current `.then`
    console.error(e); // no error logged
});
```

The `.then(x,y)` comes really handy when you want to handle an error coming from the promise you are .`then`ing and not want to handle from the `.then` you just appended to the promise chain.

Note: 99.9% of the times you are better off using the simpler `then(x).catch(x)` .

## 9. Avoid the .then hell

This tip is pretty simple, try to avoid the `.then` inside a `.then` or `.catch`. Trust me it can be avoided more often than you think.

☠️**Wrong**

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

💖**Correct**

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

Sometimes it does happen that we need multiple variables in a `.then` scope and there is no option but to create another `.then` chain.

```
.then(myVal => {
    const promA = foo(myVal);
    const promB = anotherPromMake(myVal);
    return promA
          .then(valA => {
              return promB.then(valB => hungryFunc(valA, valB)); // very hungry!
          })
})
```

I recommend using the ES6 destructuring power mixed with `Promise.all` to the rescue!

```
.then(myVal => {
    const promA = foo(myVal);
    const promB = anotherPromMake(myVal);
    return Promise.all([prom, anotherProm])
})
.then(([valA, valB]) => {   // putting ES6 destructing to good use
    console.log(valA, valB) // all the resolved values
    return hungryFunc(valA, valB)
})
```

Note: You can also use [async/await](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/async_function) to solve this problem if your node/browser/boss/conscious allows!

**I really hope this article helped you in understanding Promises.**

Please check out my previous blog posts.

*   [A toddlers guide to memory leaks in Javascript](https://dev.to/kepta/a-toddlers-guide-to-memory-leaks-in-javascript-25lf)
*   [Understanding Default Parameters in Javascript](https://dev.to/kepta/understanding-default-parameters-in-javascript-ali)

If you ❤️ this article, please share this article to spread the words.

Reach out to me on Twitter [@kushan2020](https://twitter.com/kushan2020).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
