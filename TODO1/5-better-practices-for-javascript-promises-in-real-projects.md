> * 原文地址：[5 Better Practices for JavaScript Promises in Real Projects](https://medium.com/javascript-in-plain-english/5-better-practices-for-javascript-promises-in-real-projects-4917a9daec01)
> * 原文作者：[bitfish](https://medium.com/@bf2)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-better-practices-for-javascript-promises-in-real-projects.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-better-practices-for-javascript-promises-in-real-projects.md)
> * 译者：
> * 校对者：

# 5 Better Practices for JavaScript Promises in Real Projects

#### Use Promise.all, Promise.race and Promise.prototype.then to improve your code quality.

![Photo by [Kelly Sikkema](https://unsplash.com/@kellysikkema?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10814/0*WrO6pqf5aLgB319V)

After learning the basic usage of Promise, this article hopes to help you better use Promise in real projects.

## Promise.all

Promise.all is actually a promise that takes an array(or an iterable) of promises as an input. Then it gets resolved when all the promises get resolved or any one of them gets rejected.

For example, assume that you have ten promises (Async operation to perform a network call or a database connection). You have to know when all the promises get resolved or you have to wait till all the promises resolve. So you are passing all ten promises to promise.all. Then, Promise.all itself as a promise will get resolved once all the ten promises get resolved or any of the ten promises get rejected with an error.

**Let’s see it in code:**

```
Promise.all([promise1, promise2, promise3])
 .then(result) => {
   console.log(result)
 })
 .catch(error => console.log(`Error in promises ${error}`))
```

As you can see, we are passing an array to promise.all. And when all three promises get resolved, promise.all resolves and the output is consoled.

**Let’s see an example:**

```JavaScript
// A simple promise that resolves after a given time
const timeOut = (t) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(`Completed in ${t}`)
    }, t)
  })
}
// Resolving a normal promise.
timeOut(1000)
 .then(result => console.log(result)) // Completed in 1000
// Promise.all
Promise.all([timeOut(1000), timeOut(2000)])
 .then(result => console.log(result)) // ["Completed in 1000", "Completed in 2000"]
```

In the above example, Promise.all resolves after 2000 ms and the output is consoled as an array.

One interesting thing about Promise.all is that the order of the promises is maintained. The first promise in the array will get resolved to the first element of the output array, the second promise will be a second element in the output array, and so on.

OK, the above is the basic usage of promise.all. Let me introduce its application to the real project.

#### 1. Synchronize multiple asynchronous requests

In a real project, a page often needs to send multiple asynchronous requests to the background. And wait until the results in the background return before we start rendering the page.

Some programmers may write code like this:

```JavaScript
function getBannerList(){
  return new Promise((resolve,reject)=>{
      // Suppose we make an asynchronous request to the server
      setTimeout(function(){
          resolve('BannerList')
      },300)
  })
}

function getStoreList(){
 return new Promise((resolve,reject)=>{
      // Suppose we make an asynchronous request to the server
      setTimeout(function(){
          resolve('StoreList')
      },500)
  })
}

function getCategoryList(){
 return new Promise((resolve,reject)=>{
      // Suppose we make an asynchronous request to the server
      setTimeout(function(){
          resolve('CategoryList')
      },700)
  })
}

getBannerList().then(function(data){
  // render data
})
getStoreList().then(function(data){
  // render data
})
getCategoryList().then(function(data){
  // render data
})
```

The above code does work, but there are two defects in this code:

* Each time we request data from the server, we need to write a separate function to process the data. This will lead to code redundancy and is not convenient for future upgrades and expansion.
* Each request takes a different amount of time, resulting in functions that render the page three times out of sync, and the user feels the page is stuck.

Now we can use Promise.all to optimize our code.

```JavaScript
function getBannerList(){
  // ...
}
function getStoreList(){
  // ...
}
function getCategoryList(){
  // ...
}

function initLoad(){
  Promise.all([getBannerList(),getStoreList(),getCategoryList()]).then(res=>{
      // render datas
  }).catch(err=>{
      // ...
  })
}
initLoad()
```

When all the requests are completed, we process the data uniformly.

#### 2. Handle exceptions

In the example above, we took this approach very directly to handling exceptions:

```
Promise.all([p1, p2]).then(res => {
  // ...
}).catch(error => {
  // handle error
})
```

As we know, the Promise.all mechanism is that only if any promise instance in the promise array as a parameter throws an exception, then the entire Promise.all function will go directly into the catch method, regardless of whether other promise instances succeed or fail.

But in practice, what we often need is this: even if one or more promise instances throw an exception, we still want Promise.all to continue executing normally. For example, in the above example, even if an exception occurs in `getBannerList()`, we continue to want to execute the program as long as no exception occurs in `getStoreList()` or `getCategoryList()`.

To address this need, we can use a tip to enhance the Promise.all feature. We can write our code in this way:

```JavaScript
Promise.all([p1.catch(error => error), p2.catch(error => error)]).then(res => {
  // ...
}))
```

This way, even if an exception occurs in one promise instance, it does not interrupt other instances of Promise.all.

Applied to the previous example, this is the result.

```JavaScript
function getBannerList(){
  return new Promise((resolve,reject)=>{
      setTimeout(function(){
          // Suppose here reject an Error
          reject(new Error('error'))
      },300)
  })
}

function getStoreList(){
 // ...
}

function getCategoryList(){
 // ...
}


function initLoad(){
  Promise.all([
    getBannerList().catch(err=>err),
    getStoreList().catch(err=>err),
    getCategoryList().catch(err=>err)
  ]).then(res=>{

    if(res[0] instanceof Error){
      // handle error
    } else {
      // render data
    }

    if(res[1] instanceof Error){
      // handle error
    } else {
      // render data
    }

    if(res[2] instanceof Error){
     // handle error
    } else {
      // render data
    }
  })
}

initLoad()
```

#### 3. Let multiple promise instances work together

When users try to upload or publish some content, we may need to verify the content provided by users. For example, check whether the content contains bloody violence, pornography, fake news, etc. In many cases, these detection behaviors are performed by different APIs provided by the backend or different cloud functions provided by SaaS service providers.

Some programmers may write code like this:

```JavaScript
function verify1(content){
  return new Promise((resolve,reject)=>{
      // Suppose we perform an asynchronous operation
      setTimeout(function(){
          resolve(true)
      },200)
  })
}

function verify2(content){
  return new Promise((resolve,reject)=>{
      // Suppose we perform an asynchronous operation
      setTimeout(function(){
          resolve(true)
      },700)
  })
}

function verify3(content){
  // Suppose we perform an asynchronous operation
  return new Promise((resolve,reject)=>{
      setTimeout(function(){
          resolve(true)
      },300)
  })
}

verify1().then(() => {
  verify2().then(() => {
    verify3().then(() => {
      // User content is approved and can be published.
    }).catch(() => {
      // User content is not approved and cannot be published.
    })
  }).catch(() => {
    // User content is not approved and cannot be published.
  })
}).catch(() => {
  // User content is not approved and cannot be published.
})
```

But with Promise.all, we can make different promise tasks work together:

```JavaScript
function verify1(content){
  return new Promise((resolve,reject)=>{
      // Suppose we perform an asynchronous operation
      setTimeout(function(){
          resolve(true)
      },200)
  })
}

function verify2(content){
  return new Promise((resolve,reject)=>{
      // Suppose we perform an asynchronous operation
      setTimeout(function(){
          resolve(true)
      },700)
  })
}

function verify3(content){
  // Suppose we perform an asynchronous operation
  return new Promise((resolve,reject)=>{
      setTimeout(function(){
          resolve(true)
      },300)
  })
}

let content = 'some content'
Promise.all([verify1(content),verify2(content),verify3(content)]).then(result=>{
  // User content is approved and can be published.
}).catch(err => {
  // User content is not approved and cannot be published.
})
```

## Promise.race

The parameter of `promise.race` is the same as `promise.all`, which can be a promise array or an iterable object.

The `Promise.race()` method returns a promise that fulfills or rejects as soon as one of the promises in an iterable fulfills or rejects, with the value or reason from that promise.

#### 4. Timing function

When we request a resource asynchronously from the back-end server, we often limit a time. If no data is received within the specified time, an exception is thrown.

Consider how you would implement this feature? Promise.race can help us solve this problem.

```JavaScript
function requestImg(){
    var p = new Promise(function(resolve, reject){
        var img = new Image();
        img.onload = function(){
           resolve(img);
        }
        img.src = "https://www.example.com/a.png";
    });
    return p;
}

// Delay function for timing requests
function timeout(){
    var p = new Promise(function(resolve, reject){
        setTimeout(function(){
            reject('Picture request timeout');
        }, 5000);
    });
    return p;
}

Promise
.race([requestImg(), timeout()])
.then(function(results){
    // The resource request was completed within the specified time
    console.log(results);
})
.catch(function(reason){
    // The resource request did not complete within the specified time
    console.log(reason);
});

```

## Promise.then

We know that `promise.then()` always returns a promise object, so `promise.then` supports chain calls.

```
Promise.then().then().then()
```

#### 5. Promise Chaining

Therefore, if the amount of data returned by the interface is large and the processing in one then seems bloated, we can consider interviewing the processing logic and executing it in turns in multiple then methods:

```JavaScript
// Suppose this is the data returned by the backend
let result = {
    bannerList:[
      //...
    ],
    storeList:[
      //...
    ],
    categoryList:[
      //...
    ],
    //...
}

function getInfo(){
    return new Promise((resolve,reject)=>{
        setTimeout(()=>{
            resolve(result)
        },500)
    })
}

getInfo().then(res=>{

    let { bannerList } = res

    // do something with bannerList
    console.log(bannerList)

    // Return res for the next then method
    return res

}).then(res=>{
    let { storeList } = res
    console.log(storeList)
    return res

}).then(res=>{
    let { categoryList } = res
    console.log(categoryList)
    return res
})
```

#### A note from JavaScript In Plain English

We have launched three new publications! Show some love for our new publications by following them: [**AI in Plain English**](https://medium.com/ai-in-plain-english), [**UX in Plain English**](https://medium.com/ux-in-plain-english), **[Python in Plain English](https://medium.com/python-in-plain-english)** — thank you and keep learning!

We are also always interested in helping to promote quality content. If you have an article that you would like to submit to any of our publications, send us an email at **[submissions@plainenglish.io](mailto:submissions@plainenglish.io)** with your Medium username and we will get you added as a writer. Also let us know which publication/s you want to be added to.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
