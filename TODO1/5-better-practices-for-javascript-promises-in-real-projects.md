> * 原文地址：[5 Better Practices for JavaScript Promises in Real Projects](https://medium.com/javascript-in-plain-english/5-better-practices-for-javascript-promises-in-real-projects-4917a9daec01)
> * 原文作者：[bitfish](https://medium.com/@bf2)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-better-practices-for-javascript-promises-in-real-projects.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-better-practices-for-javascript-promises-in-real-projects.md)
> * 译者：[febrainqu](https://github.com/febrainqu)
> * 校对者：[niayyy-S](https://github.com/niayyy-S)、[IAMSHENSH](https://github.com/IAMSHENSH)

# 实际项目中关于 JavaScript 中 Promises 的 5 种最佳实践

![Photo by [Kelly Sikkema](https://unsplash.com/@kellysikkema?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10814/0*WrO6pqf5aLgB319V)

在学习了 Promise 的基本用法后，本文希望可以帮助你在实际项目中更好地使用 Promise。

> 使用 Promise.all，Promise.race 和 Promise.prototype.then 来改善代码质量。

## Promise.all

Promise.all 实际上是一个 Promise，接收一个 Promise 数组（或一个可迭代的对象）做为参数。然后当其中所有的 Promise 都变为 resolved 状态，或其中一个变为 rejected 状态，会回调完成。

例如，假设你有十个 promise（执行网络请求或数据库连接的异步操作）。你必须知道什么时候所有的 promises 都转为 resolved 状态，或者等到所有的 promise 执行完。所以你要通过十个 promise 去完成 promise.all。然后，一旦十个 promise 都转为 resolved 状态，或者它们中的任意一个因为发生异常转为 rejected 状态，Promise.all 自身做为一个 promise 会转为 resolved 状态。

**让我们在代码中理解它：**

```js
Promise.all([promise1, promise2, promise3])
 .then(result) => {
   console.log(result)
 })
 .catch(error => console.log(`Error in promises ${error}`))
```

你可以看到，我们将一个数组传递给了 Promise.all。并且当三个 Promise 都转为 resolved 状态时，Promise.all 完成并在控制台输出。

**让我们看一个例子：**

```JavaScript
// 一个简单的 promise，经过给定时间会执行 resolve
const timeOut = (t) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      resolve(`Completed in ${t}`)
    }, t)
  })
}
// Resolve 一个正常的 promise。
timeOut(1000)
 .then(result => console.log(result)) // Completed in 1000
// Promise.all
Promise.all([timeOut(1000), timeOut(2000)])
 .then(result => console.log(result)) // ["Completed in 1000", "Completed in 2000"]
```

在上面的示例中，Promise.all 在 2000ms 之后 resolved，并且在控制台上输出结果数组。

关于 Promise.all 的一件有趣的事情是，Promise 的顺序是固定的。数组中的第一个 Promise 转为 resolved 并作为数组的第一个元素输出，第二个 Promise 转为 resolved 作为数组的第二个元素输出，以此类推。

好的，以上是 promise.all 的基本用法。让我介绍一下它在实际项目中的应用。

#### 1. 同步多个异步请求

在实际的项目中，页面通常需要将多个异步请求发送到后台。然后等到后台结果返回后，再开始渲染页面。

一些程序员可能会编写如下代码：

```JavaScript
function getBannerList(){
  return new Promise((resolve,reject)=>{
      // 假设我们向服务器发出异步请求
      setTimeout(function(){
          resolve('BannerList')
      },300)
  })
}

function getStoreList(){
 return new Promise((resolve,reject)=>{
      // 假设我们向服务器发出异步请求
      setTimeout(function(){
          resolve('StoreList')
      },500)
  })
}

function getCategoryList(){
 return new Promise((resolve,reject)=>{
      // 假设我们向服务器发出异步请求
      setTimeout(function(){
          resolve('CategoryList')
      },700)
  })
}

getBannerList().then(function(data){
  // 渲染数据
})
getStoreList().then(function(data){
  // 渲染数据
})
getCategoryList().then(function(data){
  // 渲染数据
})
```

上面的代码确实有效，但是有两个缺陷：

* 每次我们从服务端请求数据时，我们都需要编写一个单独的函数来处理数据。这将导致代码冗余，并且不便于将来的升级和扩展。
* 每个请求花费的时间不同，导致函数会异步渲染三次页面，会使用户感觉页面卡顿。

现在我们可以使用 Promise.all 来优化我们的代码。

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
      // 渲染数据
  }).catch(err=>{
      // ...
  })
}
initLoad()
```

所有请求完成后，我们将统一处理数据。

#### 2. 处理异常

在上面的示例中，我们非常直接地将这种方法用于异常处理：

```js
Promise.all([p1, p2]).then(res => {
  // ...
}).catch(error => {
  // 异常处理
})
```

众所周知，Promise.all 的机制是，只要做为参数的 Promise 数组中的任何一个 Promise 抛出异常时，无论其他 Promise 成功或失败，整个 Promise.all 函数都会进入 catch 方法。

但实际上，我们经常需要这样：即使一个或多个 Promise 抛出异常，我们仍希望 Promise.all 继续正常执行。例如，在上面的例子中，即使在 `getBannerList()` 中发生异常，只要在 `getStoreList()` 或 `getCategoryList()` 中没有发生异常，我们仍然希望该程序继续执行。

为了满足这个需求，我们可以使用一个技巧来增强 Promise.all 的功能。我们可以这样编写代码：

```JavaScript
Promise.all([p1.catch(error => error), p2.catch(error => error)]).then(res => {
  // ...
}))
```

这样，即使一个 Promise 发生异常，也不会中断 Promise.all 中其它 Promise 的执行。

应用到前面的示例，结果是这样的。

```JavaScript
function getBannerList(){
  return new Promise((resolve,reject)=>{
      setTimeout(function(){
          // 假设这里 reject 一个异常
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
      // 处理异常
    } else {
      // 渲染数据
    }

    if(res[1] instanceof Error){
      // 处理异常
    } else {
      // 渲染数据
    }

    if(res[2] instanceof Error){
     // 处理异常
    } else {
      // 渲染数据
    }
  })
}

initLoad()
```

#### 3. 让多个 Promise 一起工作

当用户要上传或发布某些内容时，我们可能需要验证用户上传的内容。例如，检查内容是否包含血腥暴力，色情，虚假新闻等。在多数情况下，这些检测行为是由后端提供的不同 API 或 SaaS 服务提供商提供的不同云功能执行的。

一些程序员可能会编写如下代码：

```JavaScript
function verify1(content){
  return new Promise((resolve,reject)=>{
      // 假设我们执行异步操作
      setTimeout(function(){
          resolve(true)
      },200)
  })
}

function verify2(content){
  return new Promise((resolve,reject)=>{
      // 假设我们执行异步操作
      setTimeout(function(){
          resolve(true)
      },700)
  })
}

function verify3(content){
  // 假设我们执行异步操作
  return new Promise((resolve,reject)=>{
      setTimeout(function(){
          resolve(true)
      },300)
  })
}

verify1().then(() => {
  verify2().then(() => {
    verify3().then(() => {
      // 用户上传的内容已通过验证并可以发布。
    }).catch(() => {
      // 用户上传的内容没有通过验证，并且不能发布。
    })
  }).catch(() => {
    // 用户上传的内容没有通过验证，并且不能发布。
  })
}).catch(() => {
  // 用户上传的内容没有通过验证，并且不能发布。
})
```

但是使用 Promise.all，我们可以使不同的 Promise 任务一起工作：

```JavaScript
function verify1(content){
  return new Promise((resolve,reject)=>{
      // 假设我们执行异步操作
      setTimeout(function(){
          resolve(true)
      },200)
  })
}

function verify2(content){
  return new Promise((resolve,reject)=>{
      // 假设我们执行异步操作
      setTimeout(function(){
          resolve(true)
      },700)
  })
}

function verify3(content){
  // 假设我们执行异步操作
  return new Promise((resolve,reject)=>{
      setTimeout(function(){
          resolve(true)
      },300)
  })
}

let content = 'some content'
Promise.all([verify1(content),verify2(content),verify3(content)]).then(result=>{
  // 用户上传的内容已通过验证并可以发布。
}).catch(err => {
  // 用户上传的内容没有通过验证，并且不能发布。
})
```

## Promise.race

`Promise.race` 的参数与 `Promise.all` 相同，可以是一个 Promise 数组或一个可迭代的对象。

`Promise.race()` 方法返回一个 Promise 对象，一旦迭代器中的某个 Promise 为 fulfilled 或 rejected 状态，就会返回结果或者错误信息。

#### 4. 定时功能

当我们从后端服务器异步请求资源时，通常会限制时间。如果在指定时间内未接收到任何数据，则将引发异常。

思考一下，你会怎么实现这个功能？Promise.race 可以帮我们解决这个问题。

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

// 定时功能的延迟函数
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
    // 该资源请求在指定时间内完成
    console.log(results);
})
.catch(function(reason){
    // 该资源请求被在指定时间内没有完成
    console.log(reason);
});

```

## Promise.then

我们知道 `promise.then()` 总返回一个 Promise 对象，因此 `promise.then` 支持链式调用。

```js
Promise.then().then().then()
```

#### 5. Promise 链

因此，如果接口返回的数据量很大，并且其中一个接口的处理似乎过于庞大，我们可以考虑在多个 then 方法中依次访问处理逻辑并执行：

```JavaScript
// 假设这是后端返回的数据
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

    // 使用 bannerList 进行操作
    console.log(bannerList)

    // 为下一个 then 方法返回 res 
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

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
