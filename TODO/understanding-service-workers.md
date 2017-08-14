
  > * 原文地址：[Understanding Service Workers](http://blog.88mph.io/2017/07/28/understanding-service-workers/)
  > * 原文作者：[Adnan Chowdhury](http://blog.88mph.io/author/adnan/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/understanding-service-workers.md](https://github.com/xitu/gold-miner/blob/master/TODO/understanding-service-workers.md)
  > * 译者：[zyziyun](https://github.com/zyziyun)
  > * 校对者：[undead25](https://github.com/undead25)、[calpa](https://github.com/calpa)


# 理解 Service Workers

  什么是 Service Workers？他们能够做什么，怎样使你的 web app 表现得更好？本文旨在回答这些问题，以及如何使用 Ember.js 框架来实现他们。

## 目录

- [背景](#背景)
- [注册](#注册)
- [安装事件](#安装事件)
- [Fetch 事件](#Fetch事件)
- [缓存策略](#缓存策略)
- [激活事件](#激活事件)
- [同步事件](#同步事件)
- [什么时候同步事件被触发？](#什么时候同步事件被触发？)
- [通知推送](#通知推送)
- [通知](#通知)
- [消息推送](#消息推送)
- [使用 Ember.js 实现](#使用Ember.js实现)
- [了解 ember-service-worker 的约定](#了解ember-service-worker的约定)
- [构建基于 Ember 和 Service-Workers 的App](#构建基于Ember和Service-Workers的App)
- [结论](#结论)

## 背景

在互联网早期时代，几乎没人会考虑用户处于离线状态时该如何呈现一个 web 页面，只会考虑在线状态。

![Connected!](http://blog.88mph.io/content/images/2017/07/aol-connected.jpg)

连接上了！这帮家伙在这里！永远别想离开。

但是，随着移动互联网的到来以及网络在世界其他地区的普及，参差不齐的网络质量在用户使用的现代网络中已经越来越普遍。

因此，网站在离线状态时候的表现，以便用户不受网络可用性的限制，已变得非常有价值。

[AppCache](https://developer.mozilla.org/en-US/docs/Web/HTML/Using_the_application_cache) 最初是作为 HTML5 规范的一部分引入，用以解决离线 web 应用程序的问题。它包含以 **Cache Manifest** 配置文件为中心的HTML和JS的组合，配置文件以声明式语言来编写。 

AppCache 最终被发现是 [不实用的和充满陷阱的](https://alistapart.com/article/application-cache-is-a-douchebag)。因此它已被废弃，被 Service Workers 有效的取代。

[Service workers](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) 提供了一个更具前瞻性的离线应用解决方案，通过更加程序化的语言书写规则替代 AppCache 的声明式书写方式。

Service Workers 在浏览器后台进程中持续的执行其代码。它是事件驱动的，这意味着在 Service Worker 的作用域范围内触发的事件会驱动其行为。

这篇文章剩下的部分将对 Service Worker 的每个事件阶段做个简要的说明，但是在开始使用 Service Workers 之前，你首先需要在你的 web app 中执行代码来注册 Service Worker 。

## 注册

下面的代码说明了怎样在你的客户端浏览器中注册你的 Service Worker，这是通过在你的 web app 前端代码的某一处执行 `register` 方法调用来实现的：

```
if (navigator.serviceWorker) {
  navigator.serviceWorker.register('/sw.js')
    .then(registration => {
      console.log('congrats. scope is: ', registration.scope);
    })
    .catch(error => {
      console.log('sorry', error);
    });
}
```

这将告诉浏览器在哪里找到你的 Service Worker 的实现，浏览器将查找对应的（`/sw.js`）文件，并将它保存在你正在访问的域名下，这个文件将包含所有你自己定义的 Service Worker 事件处理程序。

![](http://blog.88mph.io/content/images/2017/07/Screenshot-2017-07-16-17.39.10.png)

在 Chrome 开发者工具中查看已注册的 Service Worker 

它也将设置你的 Service Worker 的**作用域**，这个 `/sw.js` 文件意味着 Service Worker 的作用范围是在你 URL（这里是指`http://localhost:3000/`） 的根路径下。这意味着在你的根路径下的任何请求，都将通过触发事件的方式告诉 Service Worker。一个文件路径为`/js/sw.js`的文件就仅仅可以捕获`http://localhost:3000/js`该链接下的请求。

另外，你也可以通过将第二个参数传入给 `register` 方法来明确地设置 Service Worker 的作用域范围：`navigator.serviceWorker.register('/sw.js', { scope: '/js' })`。

## 事件处理程序

现在你的 Service Worker 已经被注册好了，是时候在你的 Service Worker 生命周期中触发实现对应的事件处理程序了。

#### 安装事件

当你的 Service Worker 首次注册的时，或者你的 Service Worker 文件（`/sw.js`）在之后的任何时间被更新时（浏览器会自动检测这些更改），install 事件都将被触发。

对于那些你想在你的 Service Worker 初始化时执行的逻辑，install 事件是非常有用的，它可以执行一些一次性的操作，贯穿在整个 Service Worker 应用程序的生命周期中。一个常见的例子是在 install 阶段加载缓存。

下面是一个在 install 事件处理程序阶段向缓存添加数据的例子。

```
const CACHE_NAME = 'cache-v1';
const urlsToCache = [
  '/',
  '/js/main.js',
  '/css/style.css',
  '/img/bob-ross.jpg',
];

self.addEventListener('install', event => {
  caches.open(CACHE_NAME)
    .then(cache => {
      return cache.addAll(urlsToCache);
    });
});
```

`urlsToCache` 包含了一组我们想要添加到缓存的 URL。

`caches` 是一个全局的 [CacheStorage](https://developer.mozilla.org/en-US/docs/Web/API/CacheStorage) 对象，允许你在浏览器中管理你的缓存。我们将调用 `open` 方法来检索具体我们想要使用的 [Cache](https://developer.mozilla.org/en-US/docs/Web/API/Cache) 对象。

`cache.addAll` 将收到一组 URL，并向每个 URL 发起一个请求，然后将响应存储在其缓存中。它使用请求体作为每个缓存值的键名。了解更多请参阅 [addAll](https://developer.mozilla.org/en-US/docs/Web/API/Cache/addAll)。

![](http://blog.88mph.io/content/images/2017/07/Screenshot-2017-07-16-20.09.42.png)

在 Chrome 开发者工具中查看缓存数据

#### Fetch事件

**Fetch** 事件是在每次网页发出请求的时候触发的，触发该事件的时候 Service Worker 能够 '拦截' 请求，并决定返回内容 ———— 是返回缓存的数据，还是返回真实请求响应的数据。

下面的例子说明了**缓存优先**的策略：与请求匹配的任何缓存数据都将优先被返回，而不需要发送网络请求。只有当没有现有的缓存数据时才会发出网络请求。

```
self.addEventListener('fetch', event => {
  const { request } = event;
  const findResponsePromise = caches.open(CACHE_NAME)
    .then(cache => cache.match(request))
    .then(response => {
      if (response) {
        return response;
      }

      return fetch(request);
    });

  event.respondWith(findResponsePromise);
});
```

`request` 属性包含在 [FetchEvent](https://developer.mozilla.org/en-US/docs/Web/API/FetchEvent) 对象里，它用于查找匹配请求的缓存。

`cache.match` 将尝试找到一个与指定请求匹配的缓存响应。如果没有找到对应的缓存，则 promise 会 resolve 一个 `undefined` 值。在这个例子里，我们通过判断这个值来决定是返回这个值，还是调用 fetch 发起一个网络请求并返回一个 promise。

`event.respondWith` 是一个 FetchEvent 对象中的特殊方法，用于将请求的响应发送回浏览器。它接收一个对响应（或网络错误）resolve 后的 Promise 对象作为参数。

###### 缓存策略

Fetch 事件特别重要，因为它能够定义你的缓存策略。也就是说，你可以决定何时使用缓存数据，何时使用网络请求来的数据。

Service Worker 的好用之处在于它是一个用于拦截请求的低层 API，并允许你决定为其提供哪些响应。这允许我们自由的提供我们自己的缓存策略或者网络来源的内容。当你尝试实现一个最好的 Web App 的时候，有几种基本的缓存策略可以使用。

Mozilla 基金会有一个  [handy resource](https://serviceworke.rs/caching-strategies.html) 的文档，其中有写几种不同的缓存策略。还有 Jake Archibald 编写的 [The Offline Cookbook](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook) 书中有概述几种相似的缓存策略等等。

在上文的一个例子中，我们演示了一个基本的**缓存优先**的策略。以下是我发现的一个适用于我自己项目的示例：**缓存和更新**策略。这个方法首先让缓存响应，随后在后台发起对应的网络请求。来自后台请求的响应用于更新缓存中的数据，以便在下次访问时提供更新后的响应。

```
self.addEventListener('fetch', event => {
  const { request } = event;

  event.respondWith(caches.open(CACHE_NAME)
    .then(cache => cache.match(request))
    .then(matching => matching || fetch(request)));

  event.waitUntil(caches.open(CACHE_NAME)
    .then(cache => fetch(request)
      .then(response => cache.put(request, response))));
});
```

`event.respondWith` 用于提供对请求的响应。这里我们打开缓存找到匹配的响应，如果它不存在，我们会走网络请求。

随后，我们将调用 `event.waitUntil` 方法以允许在 Service Worker 上下文终止之前 resolve 一个异步Promise。这里会走一个网络请求，然后缓存其响应。一旦这个异步操作完成，`waitUntil` 将会 resolve，操作将会终止。

#### 激活事件

激活事件是一个较少记录的事件，但当你需要更新 Service Worker 文件，执行清理或者维护之前版本的 Service Worker 的时候，它是非常重要的。

当你更新你的 Service Worker 文件（`/sw.js`）的时候，浏览器会检测到这些改变，它们在 Chrome 开发者工具中的展示如下图所示：

![](http://blog.88mph.io/content/images/2017/07/Screenshot-2017-07-18-08.29.32.png)

你的新 Service Worker 正在“等待激活”。

当实际网页关闭并重新打开的时候，浏览器将使用新的 Service Worker 替换旧的 Service Worker，然后在 **install** 事件触发之后，触发 **activate** 事件，如果你需要清理缓存或者对旧版本的 Service Worker 进行维护，激活事件可以让你完美的做到这一点。

#### 同步事件

Sync 事件允许延迟网络任务，直到用户连接上网络，它实现的功能通常被称为**后台同步**。这对于在离线模式下，确保用户启动的任何有网络依赖的任务，最终都将在网络再次可用时达到其预期目的，是非常有用的。

下面是一个后台同步实现的例子。你需要在前端 JavaScript 中注册一个 sync 事件，并在 Service Worker 中附带 sync 事件处理程序。

```
// app.js
navigator.serviceWorker.ready
  .then(registration => {
    document.getElementById('submit').addEventListener('click', () => {
      registration.sync.register('submit').then(() => {
        console.log('sync registered!');
      });
    });
  });
```

在这里，我们分配一个 click 事件给 button 元素，它将调用 [ServiceWorkerRegistration](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration) 对象上的 `sync.register` 方法。

基本上，要确保任何操作都可以立即或最终在网络可用时到达网络，都需要被注册为 sync 事件。

在 Service Worker 的事件处理程序中，可能的操作像是发送一个评论，或者获取用户数据等等。

```
// sw.js
self.addEventListener('sync', event => {
  if (event.tag === 'submit') {
    console.log('sync!');
  }
});
```

这里我们监听一个 sync 事件，并检查 [SyncEvent](https://developer.mozilla.org/en-US/docs/Web/API/SyncEvent) 对象上的 `tag` 属性属性是否匹配我们指定给 click 事件的`'submit'`标签。

如果对应 `'submit'` 标签下的多个 sync 事件信息被注册，sync 事件处理程序将只执行一次。

因此，在这个例子中，如果用户离线，并点击了七次按钮，那么当网络恢复时，所有同步的注册事件将被合并且只触发一次。

在这种情况下，如果你想拆分同步事件给每一次点击，你可以注册多个具有唯一标记的同步事件。

###### 什么时候同步事件被触发？

如果用户在线，则同步事件将会立即触发，并完成你定义的任何任务，而不会延时。

如果用户离线，则一旦重新获得网络连接，同步事件就会触发。

如果你像我一样，想在 Chrome 中尝试一下，一定要通过禁用 Wi-Fi 或者其他网络适配器来断开互联网连接。而在 Chrome 开发者工具中切换网络复选框不会触发 sync 事件。

想了解更多的信息，你可以阅读文档 [this explainer document](https://github.com/WICG/BackgroundSync/blob/master/explainer.md) ，还有这篇文档  [introduction to background syncs](https://developers.google.com/web/updates/2015/12/background-sync) 。sync 事件现在在大部分浏览器当中并没有实现（撰写本文时，只能在 Chrome 中使用），但势必在将来会发生变化，敬请期待。

#### 通知推送

通知推送是 Service Workers 通过曝露其 `push` 以及浏览器实现的 [Push API](https://developer.mozilla.org/en-US/docs/Web/API/Push_API)  来启用的功能。

当我们讨论网络推送通知的时候，实际上会涉及两种对应的技术：通知和推送信息。

###### 通知

通知是可以通过 Service Workers 实现的非常简单的功能：

```
// app.js
// ask for permission
Notification.requestPermission(permission => {
  console.log('permission:', permission);
});

// display notification
function displayNotification() {
  if (Notification.permission == 'granted') {
    navigator.serviceWorker.getRegistration()
      .then(registration => {
        registration.showNotification('this is a notification!');
      });
  }
}
```

```
// sw.js
self.addEventListener('notificationclick', event => {
  // notification click event
});

self.addEventListener('notificationclose', event => {
  // notification closed event
});
```

你首先需要向用户发出许可才能启用网页的通知。从那时起，你可以切换通知，并处理某些事件，例如用户关闭一个通知的时候。

###### 消息推送

推送消息涉及利用浏览器提供的 Push API 以及后端实现。这个要点可以单独抽出一篇文章详细讲解，但是其基本要点如下图所示：

![Push API Diagram](http://blog.88mph.io/content/images/2017/07/push-api.svg)

这是一个稍微复杂的过程，超出了本文的范围。但如果你想了解更多，可以参考 [introduction to push notifications](https://developers.google.com/web/ilt/pwa/introduction-to-push-notifications) 这篇文章 。

## 使用Ember.js实现

用 Ember.js 实现 Service Workers 的 APP 是非常容易的，凭借其脚手架工具 [ember-cli](https://ember-cli.com/) 和其插件体系 [Ember Add-ons](https://www.emberaddons.com) 社区的支持，你可以以一种即插即拔的方式在你的 Web App 中增加 Service Worker。

这是由 DockYard 的人员提供的一系列插件 [ember-service-worker](https://github.com/DockYard/ember-service-worker) 及其对应文档 [here](http://ember-service-worker.com/documentation/getting-started/)。

**ember-service-worker** 建立了一个模块化的结构，可以被用于插入其他 ember-service-worker-* 的插件，例如 [ember-service-worker-index](https://github.com/DockYard/ember-service-worker-index) 或者 [ember-service-worker-asset-cache](https://github.com/DockYard/ember-service-worker-asset-cache)。这些插件使用不同的表现实现对应行为，以及不同的缓存策略组成你的 Service Worker 服务。

#### 了解`ember-service-worker`的约定

所有的 **ember-service-worker-** 插件都遵循相同的模块结构，它们的核心逻辑存储在其根目录的`/service-worker` and `/service-worker-registration` 这两个文件夹中。

    node_modules/ember-service-worker
    ├── ...
    ├── package.json
    ├── service-worker
        └── index.js
    └── service-worker-registration
        └── index.js


`/service-worker` 该目录是实现 Service Worker 的主要存储位置（如文章前面所说的那个 `sw.js` 就是存储在这个目录下）。

`/service-worker-registration` 该目录下有你需要在前端代码中运行的逻辑，像 Service Worker 的注册流程。

让我们看看 **ember-service-worker-index** 该插件的 `/service-worker` 目录下的代码实现  (code [here](https://github.com/DockYard/ember-service-worker-index/blob/master/service-worker/index.js)) ，符合上面所说的内容。

```
import {
  INDEX_HTML_PATH,
  VERSION,
  INDEX_EXCLUDE_SCOPE
} from 'ember-service-worker-index/service-worker/config';

import { urlMatchesAnyPattern } from 'ember-service-worker/service-worker/url-utils';
import cleanupCaches from 'ember-service-worker/service-worker/cleanup-caches';

const CACHE_KEY_PREFIX = 'esw-index';
const CACHE_NAME = `${CACHE_KEY_PREFIX}-${VERSION}`;

const INDEX_HTML_URL = new URL(INDEX_HTML_PATH, self.location).toString();

self.addEventListener('install', (event) => {
  event.waitUntil(
    fetch(INDEX_HTML_URL, { credentials: 'include' }).then((response) => {
      return caches
        .open(CACHE_NAME)
        .then((cache) => cache.put(INDEX_HTML_URL, response));
    })
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(cleanupCaches(CACHE_KEY_PREFIX, CACHE_NAME));
});

self.addEventListener('fetch', (event) => {
  let request = event.request;
  let isGETRequest = request.method === 'GET';
  let isHTMLRequest = request.headers.get('accept').indexOf('text/html') !== -1;
  let isLocal = new URL(request.url).origin === location.origin;
  let scopeExcluded = urlMatchesAnyPattern(request.url, INDEX_EXCLUDE_SCOPE);

  if (isGETRequest && isHTMLRequest && isLocal && !scopeExcluded) {
    event.respondWith(
      caches.match(INDEX_HTML_URL, { cacheName: CACHE_NAME })
    );
  }
});
```

不去看具体的细节，我们可以看到，这个代码基本实现了我们之前讨论过的三个事件处理程序：`install`, `activate` and `fetch`。

在 `install` 事件处理程序中，我们调用 `INDEX_HTML_URL`对应的接口，获取数据，然后调用 `cache.put` 存储响应数据。

`activate` 阶段做了一些基本的清理缓存的操作。

在 `fetch` 事件处理程序中，我们检查 `request` 是否满足几个条件（是否是 `GET` 请求，是否请求 HTML，是否是本地资源等等），只有满足一系列的条件，我们才把对应的数据缓存返回。

注意我们调用 `cache.match`方法 和 `INDEX_HTML_URL` 地址，来查找值，而不使用 `request.url`请求的 url。这意味着无论实际调用的 URL 请求是什么，我们始终会根据相同的缓存密钥做对应的查找操作。

这是因为 Ember 的应用程序将始终使用 `index.html` 进行页面渲染。在应用程序的根路径下的任何 URL 请求都将以 `index.html` 的缓存版本结尾，Ember 应用程序通常会接管。这就是 **ember-service-worker-index** 来缓存`index.html`的目的。

同样的，[**ember-service-worker-asset-cache**](https://github.com/DockYard/ember-service-worker-asset-cache) 该插件将缓存所有在 `/assets` 目录下可以找到的所有资源，文件，触发调用其 `install`和 `fetch` 事件处理函数。

有几个插件 [several add-ons](https://www.emberaddons.com/?query=service-worker) 也使用 **ember-service-worker** 该插件的结构，允许你自定义和微调对应的 Service Worker 的表现和缓存策略。

#### 构建基于Ember和Service-Workers的App

首先，你需要下载 [ember-cli](https://ember-cli.com/)，然后在命令行中执行下面的语句操作：

```
$ ember new new-app
$ cd new-app
$ ember install ember-service-worker
$ ember install ember-service-worker-index
$ ember install ember-service-worker-asset-cache
```


你的应用程序现在由 Service Workers 提供缓存服务，默认情况下，会将 `index.html`文件和 `/assets/**/*` 该目录下的内容缓存。

你可以通过修改 `config/environment.js` 这个配置文件调整  `/assets` 文件夹下哪些文件将被缓存。

如果你发现现有的 ember-service-worker 插件没有解决你的问题，你可以参照这个文档 [docs at the ember-service-worker website](http://ember-service-worker.com/documentation/authoring-plugins/) 创建你自己的插件。

## 结论

我希望你能够对 Service Workers 和其底层架构有一个更深入理解，以及怎样利用他们创建用户体验更好的Web App。

`ember-service-worker` 插件让你能在你的 Ember.js 应用程序中很容易地实现他们。如果你发现需要实现一个自己的 Service Worker 的逻辑，你可以很容易的创建自己的插件，来实现你需要的行为所对应的事件处理程序，这是我想在不久的将来解决的问题，敬请关注！

#### 来自我们的赞助商

![](http://blog.88mph.io/content/images/2017/07/Quartzy-logo.png)

**如果你对基于 Ember.js 的全职工作感兴趣，[Quartzy](https://www.quartzy.com/) 正在招聘前端工程师！我们帮助世界各地的科学家节省资金，使得他们更有效率的在实验室研究。[点击这里](http://grnh.se/coe8yp1)申请吧。**


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  
