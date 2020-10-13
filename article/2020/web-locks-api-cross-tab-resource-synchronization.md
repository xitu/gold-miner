> * 原文地址：[Web Locks API: Cross-Tab Resource Synchronization](https://blog.bitsrc.io/web-locks-api-cross-tab-resource-synchronization-54326e079756)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/web-locks-api-cross-tab-resource-synchronization.md](https://github.com/xitu/gold-miner/blob/master/article/2020/web-locks-api-cross-tab-resource-synchronization.md)
> * 译者：
> * 校对者：

# Web Locks API: Cross-Tab Resource Synchronization

![Image by [MasterTux](https://pixabay.com/users/mastertux-470906/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3348307) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=3348307)](https://cdn-images-1.medium.com/max/3840/1*voZnUOIRnDc4kc_nfm4bEQ.jpeg)

## What are Locks?

As computers have now become more powerful, they use several CPU threads to process data. This brings forth newer problems regarding resource sharing as there can be synchronization issues when multiple threads access a single resource.

If you are familiar with threads, you would be aware of the concept of locks. Locks are a method of synchronization that enforces access restrictions to threads such that multiple threads cannot access a single resource at the same time. Although a variant of locks allows multiple threads to access a resource at an instant, it still limits the access to read-only. I highly advise you to read a few resources to understand the concepts of locks in the operating system.

![Single-thread and Multi-thread processes — Source: [Dave Kurtz](https://www.cs.uic.edu/~jbell/CourseNotes/OperatingSystems/images/Chapter4/4_01_ThreadDiagram.jpg)](https://cdn-images-1.medium.com/max/2000/0*iW0a4sDyFt4hsBfQ.jpg)

## What is the Web Locks API?

Web Locks API applies the same overall functionality of locks to web applications. This API allows a script to asynchronously hold a lock over a resource until the process is complete, and release it. When a lock is being held, no other script in the same origin can acquire a lock over the same resource although there is an exception which we would later speak about.

#### What are the steps?

1. The lock is requested.
2. Work is done while holding the lock in an asynchronous task.
3. The lock is automatically released when the task completes.
4. Other scripts that request a lock will be given access.

When a lock is held over a resource, if another script requests a lock for the same resource from the same execution context or from other tabs/workers, the lock request will be queued. As soon as the lock is released, the first in the queue will be granted a lock and access over the resource.

#### Locks and their Scopes

The scopes on how the Web Locks API can be quite confusing. Hence here is a summary for you to understand it better.

* According to the docs, locks are scoped to origins.

> The locks acquired by a tab from https://example.com have no effect on the locks acquired by a tab from https://example.org as they are separate origins.

* Separate user profiles within a browser are considered separate user agents and are considered out of the scope. Therefore, they do not share a lock manager even if they are from the same origin.
* A private mode browsing session (incognito mode) is considered a separate user agent and considered out of the scope. Hence, they do not share a lock manager even if they are from the same origin.
* Scripts in the same context on a single origin are considered within the scope and share a lock manager. For example, two functions on a web page trying to acquire a lock over the same resource.
* Pages and workers (agents) on a single origin opened in the same user agent share a lock manager even if they are in unrelated browsing contexts.

Suppose if `Script A` falls under `Lock Manager A` and `Script B` falls under `Lock Manager B`. `Script A` tries to acquire a lock on `resource X` and successfully holds the lock and performs an async task. In the meantime, `Script B` also tries to acquire a lock to `resource X` , and will successfully manage to do so as both these scripts fall under different lock managers. But if both of these scripts were to come under the same lock manager, then there will be a queue to acquire a lock over `resource X` . Hope I made that point clear.

#### What are these resources?

Well, they represent an abstract resource. It is simply a name we come up with, to refer to a resource we would like to hold on to. It has no meaning outside of the scheduling algorithm.

In other words, in the above example, I can refer to `resource X` as the database where I have stored my data. Or it can even be the `localStorage`.

## Why is Resource Coordination Important?

It is quite rare to find the need for resource coordination in simple web applications. However more complex, JavaScript-heavy web applications may have a need for resources to be coordinated.

If you have worked with applications that span across several tabs and can do CRUD operations, you will have to keep the tabs in sync to avoid issues. For example, if a user opens a text editing web app on one tab, and forgetfully opens another tab of the same application. Now he has two tabs of the same application running. If he does one action on one tab and tries to do something totally different on the other tab, there can be a clash on the server when two different processes are happening over the same resource. In a situation like this, it is advisable to acquire a lock over the resource and thereby synchronizing.

Although the above example might result in data loss, there can be instances where you might lose real money as well. For example, take an e-commerce application that uses local storage to store the details of your cart. If you run multiple tabs of the same application, you might do unintended changes to the `localStorage` because of it not being synchronized among both tabs and can result in you paying more than what you intended to.

Furthermore, there can be an instance where a user has opened two tabs of a stock investment web application. If the user buys a certain number of shares using one of the opened tabs, it is essential for both the tabs to be in sync to avoid situations where the customer would mistakenly do the transaction again. An easy alternative would be to only allow one tab or window of the application at a time. But mind that this can be overcome by using private browsing sessions.

Although APIs such as SharedWorker, BroadcastChannel, localStorage, sessionStorage, postMessage, unload handler can be used to manage tab communication and synchronization, they each have their shortcomings and require workarounds, which decreases code maintainability. The Web Locks API tries to simplify this process by bringing in a more standardized solution.

## Using the Web Locks API

Using the API is pretty straightforward. But you must make sure that the browser supports this API. The `request()` method is used to request a lock over a resource.

The method accepts three arguments.

* name of the resource (required first argument)— a string
* callback (required final argument) — A callback which is invoked when the lock requested is granted. It is advised to pass `async` callbacks so that it would return a Promise. Even if you pass a non-async callback, it will be wrapped into a Promise.
* options (optional second argument passed before callback) — An object with specific properties we will discuss in a while.

This method returns a promise which will be resolved once a lock is acquired. You can either use the `then..catch..` approach, or rather opt for the `await` approach to keep your asynchronous code synchronous.

```JavaScript
const requestForResource1 = async() => {
 if (!navigator.locks) {
  alert("Your browser does not support Web Locks API");
  return;
 }
  
try {
  const result = await navigator.locks.request('resource_1', async lock => {
   // The lock has been acquired.
   await doSomethingHere();
   await doSomethingElseHere();
   //optionally return a value
   return "ok";
   // Now the lock will be released.
  });
 } catch (exception) {
  console.log(exception);
 }
  
}
```

I believe the above code snippet is self-explanatory. But there are some additional parameters that can be passed on to the `request()` function. Let’s have a look at them.

## Optional Parameters

#### Mode

There are two modes in which a lock request can be initiated.

* Exclusive (default)
* Shared

When an exclusive lock is requested over a resource, and if that resource is already being held over an “exclusive” or “shared” lock, it will be not be granted. But if a “shared” lock is requested over a resource which is being held by a “shared” lock, the request will be granted. However, this will not be the case when the lock being held is an “exclusive” lock as the request will be queued by the lock manager. Below is a table that summarizes this.

![Source: [Shun Yan Cheung](http://www.mathcs.emory.edu/~cheung/Courses/554/Syllabus/7-serializability/compat-mat.html)](https://cdn-images-1.medium.com/max/2000/0*6-VW3zuoya_NHYsP.gif)

#### Signal

The signal property passes in an [AbortSignal](https://dom.spec.whatwg.org/#interface-AbortSignal). This allows a lock request to be aborted in the queue. You can use a timeout to abort a lock request if the request isn’t granted within a certain timeframe.

```JavaScript
const controller = new AbortController();
setTimeout(() => controller.abort(), 400); // wait at most 400ms
try {
  await navigator.locks.request('resource1', {signal: controller.signal}, async lock => {
    await doSomethingHere();
  });
} catch (ex) {
  // |ex| will be a DOMException with error name "AbortError" if timer fired.
}
```

#### ifAvailable

This property is a boolean and is `false` by default. If true, the lock request will only be granted, if there is no need to be queued. In other words, if the lock request can be obtained without any additional waiting, it will be granted, else `null` will be returned.

But please note that when `null` is returned, the function will not be synchronous. Rather the callback would receive the value `null` which can be handled by the developer.

```js
await navigator.locks.request('resource', {ifAvailable: true}, async lock => {
  if (!lock) {
    // Didn't receive lock. Handle appropriately
    return;
  }
  
  //If lock received, use here.
});
```

## Risks of Using Locks

There are several risks associated with the implementation of locks. These are more or less due to the concept of locks themselves, not because of any bugs in the API.

#### Deadlocks

The concept of deadlock is associated with concurrency. A deadlock happens when a process can no longer make progress because each component is waiting for a request that can not be met.

![Illustration by Author](https://cdn-images-1.medium.com/max/2840/1*DQI5-XUHL9L8e-32d_ufxg.png)

In order to avoid deadlocks, it is essential that we follow a strict pattern when acquiring locks. There are several techniques used such as avoiding nesting locks, make sure locks are well ordered, or even use the signal optional parameter to timeout the lock request. But a carefully crafted API design would be the optimal solution to avoid deadlocks. You can read more about deadlock prevention over [here](https://en.wikipedia.org/wiki/Deadlock_prevention_algorithms).

#### Unresponsive Tabs

There can be situations where you discover one of your tabs has become unresponsive. If this happens while the tab is holding a lock, you can fall into a tricky situation. A `steal` boolean was introduced as a part of the options argument we previously spoke about. Although `false` by default, if it is passed as `true`, any held locks over a resource will be released and this new lock request will be granted immediately, regardless of the number of requests in the queue for the resource.

But keep in mind that this controversial feature is supposed to be used only in exceptional circumstances. You can read more about this feature over [here](https://github.com/WICG/web-locks/issues/23).

#### Hard to Debug

Since there is a possibility of hidden states involved, there can be problems related to debugging. To fix this, a `query` method was introduced. This method returns the state of the lock manager at that specific instant. The result would contain details of pending and currently held locks. It would also contain details of the type of lock, resource in which the lock is held/requested and the clientId of the request.

The `clientId` is simply the corresponding value to the unique context (frame/worker) the lock was requested from. This is the same value used in Service Workers.

```JSON
{
    "held": [
      {
        "clientId": "da2deeaa-8bac-4d1d-97e7-6b1ee46b6730",
        "mode": "exclusive",
        "name": "resource_1"
      }
    ],
    "pending": [
        {
            "clientId": "da2deeaa-8bac-4d1d-97e7-6b1ee46b6730",
            "mode": "shared",
            "name": "resource_1"
        },
        {
            "clientId": "76384678-c5b6-452e-84f0-00c2ef65109e",
            "mode": "exclusive",
            "name": "resource_1"
        },
        {
            "clientId": "76384678-c5b6-452e-84f0-00c2ef65109e",
            "mode": "shared",
            "name": "resource_1"
        }
    ]
}
```

You must also note that this method should not be used by the application to make decisions on locks being held/requested as this output contains the state of the lock manager at that **specific instant** as I’ve mentioned before. This means that a lock could be released by the time your code makes a decision.

## Browser Compatibility

One let down of this API is browser compatibility. Although there was a polyfill for unsupported browsers, it was later removed.

![Source: [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/Web_Locks_API#Browser_compatibility)](https://cdn-images-1.medium.com/max/2010/1*qnGOiC-_s5tFzP0N0moG8A.png)

![Source: [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/Web_Locks_API#Browser_compatibility)](https://cdn-images-1.medium.com/max/2006/1*N6uF2s2tQHABBv5SsESNbg.png)

The Web Locks API is a highly useful feature with several use cases that make it a very important addition. Its limited support, however, can discourage developers from learning and implementing it. But with the level of impact this API can have on modern web applications, I personally believe it is essential for web developers to know their way around this new feature. Furthermore, since this API is experimental, you can expect changes in the future.

Head over to this simple [demo](https://mahdhir.github.io/Web-Locks-API-demo/) to get a hands-on experience on how this works. You can view the [source code](https://github.com/Mahdhir/Web-Locks-API-demo) here.

**Resources**

- [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/API/Web_Locks_API)
- [Web Locks Explainer](https://github.com/WICG/web-locks/blob/main/EXPLAINER.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
