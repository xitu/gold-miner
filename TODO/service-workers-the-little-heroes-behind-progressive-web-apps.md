> * 原文地址：[Service workers: the little heroes behind Progressive Web Apps](https://medium.freecodecamp.org/service-workers-the-little-heroes-behind-progressive-web-apps-431cc22d0f16)
> * 原文作者：[Flavio Copes](https://medium.freecodecamp.org/@writesoftware?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/service-workers-the-little-heroes-behind-progressive-web-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO/service-workers-the-little-heroes-behind-progressive-web-apps.md)
> * 译者：[FateZeros](https://github.com/FateZeros)
> * 校对者：[MechanicianW](https://github.com/MechanicianW) [atuooo](https://github.com/atuooo)

# Service workers：Progressive Web Apps 背后的小英雄

![](https://cdn-images-1.medium.com/max/800/1*CqQTKb0N2o0suacfiluO8w.jpeg)

Service workers 是 [Progressive Web Apps](https://flaviocopes.com/what-is-a-progressive-web-app/) 的核心。它们允许缓存资源和推送通知，这是原生 app 应用的两个突出特性。

service worker 是你的网页和网络之间的 **可编程代理**，它可以拦截和缓存网络请求。这实际上可以让你 **使自己的 app 具有离线优先的体验**。

Service workers 是一种特殊的 web worker：一个关联工作环境上运行的网页且与主线程分离的 JavaScript 文件。它带来了非阻塞这一优点 —— 所以计算处理可以在不牺牲 UI 响应的情况下完成。

因为它在单独的线程上，因此它没有访问 DOM 的权限，也没有访问本地存储 APIs 和 XHR API 的权限。它只能使用 **Channel Messaging API** 与主线程通信。

Service Workers 与其他新进的 Web APIs 搭配：

* **Promises**
* **Fetch API**
* **Cache API**

它们 **只在使用 HTTPS** 协议的页面可用（除了本地请求不需要安全连接，这会使测试更简单。）。

### 后台运行

Service workers 独立运行，当与其相关联的应用没有运行的时候也可以接收消息。

它们可以后台运行的几种情况：

* 当你的手机应用 **在后台运行**，没有激活
* 当你的手机应用 **关闭** 甚至没有在后台运行
* 当**浏览器关闭**，如果 app 运行在浏览器上

service workers 非常有用的几种场景：

* 它们可以作为**缓存层**来处理网络请求，并且缓存离线时要使用的内容
* 它们允许**推送通知**

service worker 只有在需要的时候运行，不然则停止运行。

### 离线支持

传统上，web app 的离线体验一直很差。没有网络，web app 通常根本无法工作。另一方面，原生手机 app 则有能力提供一种可以离线运行的版本或者友好的消息提示。

这就不是一种友好的消息提示，但这是 Chrome 中一个网页在没有网络连接情况下的样子：

![](https://cdn-images-1.medium.com/max/800/0*JxRXpDzGFHmwnED8.png)

可能唯一的好处就是你可以点击恐龙来玩免费的小游戏 —— 但这很快就会变的无聊。

![](https://cdn-images-1.medium.com/max/800/0*X11fKp3LDkz0G6ug.gif)

最近，HTML5 AppCache 已经承诺允许 web apps 缓存资源和离线工作。但是它缺乏灵活性，而且混乱的表现也让它不足胜任这项工作（并[已经停止](https://html.spec.whatwg.org/multipage/offline.html#offline)）。

Service workers 是新的离线缓存标准。

可以进行哪种缓存？

### 在安装期间预缓存资源

可以在第一次打开 app 的时候安装在整个应用中重用的资源，如图片，CSS，JavaScript 文件。

这就给出了所谓的 **App Shell 体系**。

### 缓存网络请求

使用 **Fetch API**，我们可以编辑来自服务器的响应，如果服务器无法访问，可以从缓存中提供响应作为替代。

### Service Worker 生命周期

service worker 经过以下三个步骤才能提供完整的功能：

* 注册
* 安装
* 激活

### 注册

注册告诉浏览器 service worker 在哪里，并在后台开始安装。

注册放置在 `worker.js` 中 service worker 的示例代码：

```
if ('serviceWorker' in navigator) { 
  window.addEventListener('load', () => {   
    navigator.serviceWorker.register('/worker.js') 
    .then((registration) => { 
      console.log('Service Worker registration completed with scope: ', registration.scope) 
    }, (err) => { 
      console.log('Service Worker registration failed', err)
    })
  })
} else { 
  console.log('Service Workers not supported') 
}
```

即使此代码被多次调用，如果 service worker 是新的，并且以前没有被注册，或者已更新，浏览器将仅执行注册。

#### 作用域

`register()` 调用还接受一个作用域参数，该参数是一个路径用来确定应用程序的哪一部分可以由 service worker 控制。

它默认包含 service worker 的文件夹中的所有文件和子文件夹，所以如果将它放到根文件夹，它将控制整个 app。在子文件夹中，它将只会控制当前路径下的页面。

下面的示例通过指定 `/notifications/` 文件夹范围来注册 service worker。

```
navigator.serviceWorker.register('/worker.js', { 
  scope: '/notifications/' 
})
```

`/` 很重要：在这种情况下，页面 `/notifications` 不会触发 service worker，而如果作用域是：

```
{ scope: '/notifications' }
```

它就会起作用。

注意：service worker 不能从一个文件夹中“提升”自己的作用域：如果它的文件放在 `/notifications` 下，它不能控制 `/` 路径或其他不在 `/notifications` 下的路径。 

### 安装

如果浏览器确定 service worker 过期或者以前从未注册过，则会继续安装。

```
self.addEventListener('install', (event) => { 
  //... 
});
```

这是使用 service worker **初始化缓存**的好时机。然后使用 **Cache API** **缓存 App Shell** 和静态资源。

### 激活

一旦 service worker 被成功注册和安装，第三步就是激活。

这时，当界面加载时，service worker 就能正常工作了。

它不能和已经加载的页面进行交互，因此 service worker 只有在用户和应用交互的第二次或重新加载已打开的页面时才有用。

```
self.addEventListener('activate', (event) => { 
  //... 
});
```

这个事件的一个好的用例是清除旧缓存和一些关联到旧版本并且没有被新版本的 service worker 使用的文件。

### 更新 Service Worker

要更新 service worker，你只需修改其中的一个字节。当寄存器代码运行的时候，它就会被更新。

一旦更新了 service worker，直到所有关联到旧版本 service worker 已加载的页面全部关闭，新的 service worker 才会起作用。

这确保了在已经工作的应用/页面上不会有任何中断。

刷新页面还不够，因为旧的 worker 仍在运行，且没有被删除。

### Fetch 事件

当网络请求资源时 **fetch 事件** 被触发。

这给我们提供了在发起网络请求前查看**缓存**的能力。

例如，下面的代码片段使用 **Cache API** 来检查请求的 URL 是否已经存储在缓存响应里面。如果已存在，它会返回缓存中的响应。否则，它会执行 fetch 请求并返回结果。

```
self.addEventListener('fetch', (event) => {
  event.respondWith( 
    caches.match(event.request) 
      .then((response) => { 
        if (response) { 
          //entry found in cache 
          return response 
        } 
        return fetch(event.request) 
      } 
    ) 
  ) 
})
```

### 后台同步

后台同步允许发出的连接延迟，直到用户有可用的网络连接。

这是确保用户能离线使用 app，能对其进行操作，并且当网络连接时排队进行服务端更新（而不是显示尝试获取信号的无限旋转圈）的关键。

```
navigator.serviceWorker.ready.then((swRegistration) => { 
  return swRegistration.sync.register('event1') 
});
```

这段代码监听 service worker 中的事件：

```
self.addEventListener('sync', (event) => { 
  if (event.tag == 'event1') { 
    event.waitUntil(doSomething()) 
  } 
})
```

`doSomething()` 返回一个 promise 对象。如果失败，另一个同步事件将安排自动重试，直到成功。

这也允许应用程序在有可用网络连接时，立即从服务器更新数据。

### 推送事件

Service workers 让 web apps 为用户提供本地推送。

推送和通知实际上是两种不同的概念和技术，它们结合起来就是我们所知的 **推送通知**。推送提供了允许服务器向 service worker 发送消息的机制，通知就是 servic worker 向用户显示信息的方式。

因为 service workers 即使在 app 没有运行的时候也可以运行，它们可以监听即将到来的推送事件。然后它们要么提供用户通知，要么更新 app 状态。

推送事件用后端通过浏览器推送服务启动，如 [Firebase](https://flaviocopes.com/firebase-hosting) 提供的推送服务。

下面这个例子展示了 web worker 如何能够监听到即将到来的推送事件：

```
self.addEventListener('push', (event) => { 
  console.log('Received a push event', event) 
  const options = { 
    title: 'I got a message for you!', 
    body: 'Here is the body of the message', 
    icon: '/img/icon-192x192.png', 
    tag: 'tag-for-this-notification', 
  } 
  event.waitUntil( 
    self.registration.showNotification(title, options) 
  ) 
})
```

### 有关控制台日志的说明：

如果 service work 有任何控制台日志语句（`console.log` 和其类似），请确保你打开了 Chrome Devtools（或类似工具）提供的 `Preserve log` 功能。

否则，由于 service worker 在页面加载前执行，并且在加载页面前清除了控制台，你将不会在控制台看到任何日志输出。

感谢阅读这篇文章，关于这个主题还有很多值得学习的地方！我在[关于前端开发的博客](https://flaviocopes.com)中发表了很多相关的内容，别忘记去看！😀

**最初发表于**[**flaviocopes.com**](https://flaviocopes.com/service-workers/)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
