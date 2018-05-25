> * 原文地址：[How JavaScript works: the mechanics of Web Push Notifications](https://blog.sessionstack.com/how-javascript-works-the-mechanics-of-web-push-notifications-290176c5c55d)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-mechanics-of-web-push-notifications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-mechanics-of-web-push-notifications.md)
> * 译者：[Starrier](https://github.com/StarriersStarrier)
> * 校对者：[allen](https://github.com/allenlongbaobao)、[老教授](https://github.com/weberpan)

# JavaScript 是如何工作的：Web 推送通知的机制

这是专门研究 JavaScript 及其构建组件系列文章的第 9 章。在识别和描述核心元素的过程中，我们还分享了我们在构建一个轻量级 JavaScript 应用程序 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=javascript-series-push-notifications-intro) 时使用的一些经验规则，该应用程序需要健壮、高性能，可以帮助用户实时查看和重现它们的 Web 应用程序缺陷。

如果你错过了前几章，你可以在这里找到它们：

1. [[译] JavaScript 是如何工作的：对引擎、运行时、调用堆栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
2. [[译] JavaScript 是如何工作的：在 V8 引擎里 5 个优化代码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code.md)
3. [[译] JavaScript 是如何工作的：内存管理 + 处理常见的4种内存泄漏](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md)
4. [[译] JavaScript 是如何工作的: 事件循环和异步编程的崛起 + 5个如何更好的使用 async/await 编码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with.md)
5. [[译] JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path.md)
6. [[译] JavaScript 是如何工作的：与 WebAssembly 一较高下 + 为何 WebAssembly 在某些情况下比 JavaScript 更为适用](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it.md)
7. [[译] JavaScript 是如何工作的：Web Worker 的内部构造以及 5 种你应当使用它的场景](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them.md)
8. [[译] JavaScript 是如何工作的：Web Worker 生命周期及用例](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-service-workers-their-life-cycle-and-use-cases.md)

今天，我们来关注 Web 推送通知：我们将了解它们的构建组件，探索发送/接收通知的流程，最后分享 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=javascript-series-push-notifications-2nd) 是如何利用这些来构建新产品的特性。

推送通知在手机领域被广泛使用。由于某种原因，它们很晚才进入 Web 领域，尽管开发人员呼唤了很久。

#### 概述

Web 推送通知允许用户在 Web 应用程序中选择接收更新信息，这些旨在重新吸引用户群注意的更新信息通常是对用户来说有趣、重要、实时的内容。

推送基于我们在[上一篇文章](https://blog.sessionstack.com/how-javascript-works-service-workers-their-life-cycle-and-use-cases-52b19ad98b58)中详细讨论过的 Service Worker。

在这种情况下，使用 Service Worker 的原因是它们在后台工作。这对推送通知非常有用，因为这意味着只有当用户与通知本身进行交互时才会执行它们的代码。

#### 推送和通知

推送和通知是两种不同的 API。

*   [推送](https://developer.mozilla.org/en-US/docs/Web/API/Push_API) —— 它在服务器端将消息推送给 Service Worker 时被调用
*   [通知](https://developer.mozilla.org/en-US/docs/Web/API/Notifications_API) —— 这是 Service Worker 或 web 应用程序中向用户显示信息脚本的操作。

#### 推送

实现推送有三个步骤：

1.  **UI** —— 添加必要的客户端逻辑来让用户订阅推送，这是你的 Web 应用程序 UI 需要的 JavaScript 逻辑，这样用户就能给自己注册从而可以收到消息推送。
2.  **发送推送消息** —— 在服务器上实现 API 调用，该调用将触发对用户设备的推送消息。
3.  **接受推送消息** —— 一旦推送消息到达浏览器，就进行处理。

现在我们将更详细地描述整个过程。

#### 浏览器支持检测

首先，我们需要检查当前浏览器是否支持推送消息。我们可以通过两个简单的方法检查是否支持推送消息：

1.  检查 `navigator` 对象上的 `serviceWorker` 
2.  检查 `window` 对象上的 `PushManager`

两种检查看起来都是这样的：

```
if (!('serviceWorker' in navigator)) { 
  // Service Worker isn't supported on this browser, disable or hide UI. 
  return; 
}

if (!('PushManager' in window)) { 
  // Push isn't supported on this browser, disable or hide UI. 
  return; 
}
```

#### 注册一个 Service Worker

此时，我们知道该功能是受支持的。下一步是注册我们的 Service Worker。

如何注册 Service Worker，你从我们以前的一篇文章中应该[已经熟悉了](https://blog.sessionstack.com/how-javascript-works-service-workers-their-life-cycle-and-use-cases-52b19ad98b58)。

#### 请求许可

在注册了 Service Worker 之后，我们可以开始订阅用户。要做到这一点，我们需要得到他的许可才能给他发送推送信息。

获取许可的 API 相对简单，但缺点是 API 已经[从接受回调变为返回 Promise](https://developer.mozilla.org/en-US/docs/Web/API/Notification/requestPermission)，这带来了一个问题：我们无法判断当前浏览器实现了哪个 API 版本，因此你必须实现和处理这两个版本。

看起来是这样的：

```
function requestPermission() {
  return new Promise(function(resolve, reject) {
    const permissionResult = Notification.requestPermission(function(result) {
      // Handling deprecated version with callback.
      resolve(result);
    });

    if (permissionResult) {
      permissionResult.then(resolve, reject);
    }
  })
  .then(function(permissionResult) {
    if (permissionResult !== 'granted') {
      throw new Error('Permission not granted.');
    }
  });
}
```

`Notification.requestPermission()` 调用将向用户显示以下提示：

![](https://cdn-images-1.medium.com/max/800/1*xhB8ceUNM6vb8s0ZQKMHNg.png)

一旦被授权、关闭或阻止，我们将得到字符串格式的结果：`‘granted’`、`‘default’` 或 `‘denied’`。

记住，如果用户单击 `Block` 按钮，你的 Web 应用程序将无法再次请求用户的许可，直到他们通过更改权限状态手动 “unblock” 你的应用程序的限制。此选项隐藏在设置界面中。

#### 用户订阅使用 PushManager

一旦我们注册了 Service Worker 并获得许可权限，当你在注册你的 Service Worker 时，我们就可以通过调用 `registration.pushManager.subscribe()` 来订阅用户。

整个片段可能如下所示（包括 Service Workder 注册）：

```
function subscribeUserToPush() {
  return navigator.serviceWorker.register('service-worker.js')
  .then(function(registration) {
    var subscribeOptions = {
      userVisibleOnly: true,
      applicationServerKey: btoa(
        'BEl62iUYgUivxIkv69yViEuiBIa-Ib9-SkvMeAtA3LFgDzkrxZJjSgSnfckjBJuBkr3qBUYIHBQFLXYp5Nksh8U'
      )
    };

    return registration.pushManager.subscribe(subscribeOptions);
  })
  .then(function(pushSubscription) {
    console.log('PushSubscription: ', JSON.stringify(pushSubscription));
    return pushSubscription;
  });
}
```

`registration.pushManager.subscribe(options)` 接受一个 **options** 对象，它包含必要参数和可选参数：

*   **userVisibleOnly**：布尔值指示返回的推送订阅将仅用于对用户可见的消息。它必须设置为 `true`，否则你会得到一个错误（这有历史原因）。
*   **applicationServerKey**：Base64-encoded `DOMString` 或者 `ArrayBuffer` 包含推送服务器用来验证应用服务器的公钥。

你的服务器需要生成一对**应用程序服务器密钥** —— 也称为 VAPID 密钥，对于你的服务器来说，它们是唯一的。它们是一对公钥和私钥。私钥被秘密存储在你的终端，而公钥则与客户端交换。这些密钥允许推送服务知道哪个应用服务器订阅了用户，并确保它是触发向该特定用户推送消息的相同服务器。

你只需要为应用程序创建一次私钥/公钥对。做到这一点的方法是去完成这个 —— [https://web-push-codelab.glitch.me/](https://web-push-codelab.glitch.me/)。

浏览器在订阅用户时将 `applicationServerKey`（公钥）传递给推送服务，这意味着推送服务可以将应用程序的公钥绑定到用户的 `PushSubscription` 中。

情况是这样的：

*   你的 web app 被加载时，你可以调用 `subscribe()` 来传入你的 server 密钥。
*   浏览器向生成端点的推送服务发出请求，将此端点与该键关联并将端点返回给浏览器。
*   浏览器将此端点添加到 `PushSubscription` 对象中，该对象通过 `subscribe()` 的 promise 返回。

之后，无论你想何时发送推送消息，你都需要创建一个包含使用应用程序服务器的专用密钥签名信息的 **Authorization header**。当推送服务收到发送推送消息的请求时，它将通过查找已经连接到该特定端点的公钥来验证头（第二步）。

#### 推送对象

`PushSubscription` 包含用户设备发送推送消息所需的所有信息。就像这样： 

```
{
  "endpoint": "https://domain.pushservice.com/some-id",
  "keys": {
    "p256dh":
"BIPUL12DLfytvTajnryr3PJdAgXS3HGMlLqndGcJGabyhHheJYlNGCeXl1dn18gSJ1WArAPIxr4gK0_dQds4yiI=",
    "auth":"FPssMOQPmLmXWmdSTdbKVw=="
  }
}
```

`endpoint` 是推送服务的 URL。要触发推送消息，请对此 URL 发送 POST 请求。

这里的 `keys` 对象的值是用来加密推送消息带过来的消息数据。

一旦用户被订阅并且你有 `PushSubscription`，你需要将它发送到你的服务器。在那里（在服务器上），你将这个订阅存到数据库中，从今以后如果你要向该用户推送消息就使用它。

![](https://cdn-images-1.medium.com/max/800/1*hTMGxzZrOmxxIfaQU7nKig.png)

#### **发送推送消息**

当你想向用户发送推送消息时，你首先需要一个推送服务。你要（通过 API 调用）告诉推送服务要发送哪些数据，谁来接收数据以及其他关于怎么发送数据的标准。通常，此 API 调用是在你服务器上完成的。 

#### 推送服务

推送服务是接收请求，验证请求并将推送消息传递给对应的浏览器。

注意推送服务不是由你管理的 —— 它是第三方服务。你的服务器通过 API 与 推送服务进行通讯。推送服务的一个例子是 [Google 的 FCM](https://firebase.google.com/docs/cloud-messaging/)。

推送服务处理所有繁重的任务，比如，如果浏览器处于脱机状态，推送服务会在发送相应消息之前对消息进行排队，等待浏览器的再次联机。

每个浏览器都使用它们想要的任何推送服务，这是开发者无法控制的。

然而所有的推送服务都具有相同的 API，因此在实现过程中不会有很大难度。

为了获得 URL 来进行消息推送请求，你需要检查 `PushSubscription` 对象中存储的 `endpoint` 值。

#### 推送服务 API

推送服务 API 提供了一种将消息发送给用户的方式。API 基于 [Web 推送协议](https://tools.ietf.org/html/draft-ietf-webpush-protocol-12)，它是一种定义了如何对推送服务进行 API 调用的 IETF 标准。

你使用推送消息发送的数据必须被加密。这样可以防止推送服务查看发送的数据。这很重要，因为浏览器是可以决定使用哪种推送服务的（它可能使用了一些不受信任且不够安全的服务器）。

对于每个推送消息，你还可以提供下列说明：

*   **TTL** —— 定义消息会在队列中等多久，超过这个时间消息就会被删除不做推送。。
*   **优先级** —— 定义消息的优先级，因为推送服务只发送高优先级的消息，以此来保护用户设备的电池寿命。
*   **Topic** —— 给推送消息一个主题，新消息会替换等待中的带相同主题的消息，这样一旦设备处于活动状态，用户将不会收到过时的消息。

![](https://cdn-images-1.medium.com/max/800/1*PgclyCPqxWc1rENfAOesag.png)

#### 浏览器中的推送事件

如上所述，将消息发送到推送服务后，消息将处于挂机状态，直到发生下列情况之一：

*   设备上线。
*   消息由于 TTL 而在队列上过期。

当推送服务传递消息时，浏览器会接收它，解密并在 Service Worker 中分发一个 `push` 事件。

这里最好的是，即使是你的网页没有打开，浏览器也可以执行你的 Service Worker。将会发生下面的事情：

*   推送消息到达解密它的浏览器
*   浏览器唤醒 Service Worker
*   `push` 事件被分发给 Service Worker

设置推送事件监听器的代码应该与用 JavaScript 编写的任何其他事件监听器类似：

```
self.addEventListener('push', function(event) {
  if (event.data) {
    console.log('This push event has data: ', event.data.text());
  } else {
    console.log('This push event has no data.');
  }
});
```

需要了解 Service Worker 的一点是，你没有 Service Worker 代码运行时长的控制权。浏览器决定何时将其唤醒以及何时终止它。

在 Service Workers 中，`event.waitUntil(promise)` 通知浏览器工作正在进行，直到 promise 确定为止，如果它想要完成该工作，它不应该终止 sercice worker。

这里是处理 `push` 事件的例子：

```
self.addEventListener('push', function(event) {
  var promise = self.registration.showNotification('Push notification!');

  event.waitUntil(promise);
});
```

调用 `self.registration.showNotification()` 会向用户发送一个通知，并返回一个 promise，只要消息展示了该 promise 就会触发 resolve。

`showNotification(title, options)` 方法可以在视觉上进行调整以适应你的需求。`title` 参数是一个 `string`，而 options 是一个看起来像这样的对象：

```
{
  "//": "Visual Options",
  "body": "<String>",
  "icon": "<URL String>",
  "image": "<URL String>",
  "badge": "<URL String>",
  "vibrate": "<Array of Integers>",
  "sound": "<URL String>",
  "dir": "<String of 'auto' | 'ltr' | 'rtl'>",

  "//": "Behavioural Options",
  "tag": "<String>",
  "data": "<Anything>",
  "requireInteraction": "<boolean>",
  "renotify": "<Boolean>",
  "silent": "<Boolean>",

  "//": "Both Visual & Behavioural Options",
  "actions": "<Array of Strings>",

  "//": "Information Option. No visual affect.",
  "timestamp": "<Long>"
}
```

你可以在这里阅读到每个选项内容的更多细节 — [https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration/showNotification](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration/showNotification)。

推送通知是一种可以在有紧急、重要和时间敏感的信息需要与用户进行分享的情况下，吸引用户注意的绝好方式。

例如，我们在 SessionStack 计划利用推送通知来提醒用户，让他们知道自己的产品中何时发生崩溃、问题或异常。这会让用户立即知道出现了问题。然后他们可以利用我们的库所收集的数据（如 DOM 修改、用户交互、网络请求、未处理异常和调试信息），以视频的形式重现问题并查看最终发生在用户身上的一切事情。

这个特性不仅可以帮助客户理解和重现任何问题，而且还可以在发生问题的第一时间通知客户。

如果你想[尝试 SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=source&utm_content=javascript-series-web-workers-try-now)，这里有一个免费的计划。

![](https://cdn-images-1.medium.com/max/800/1*YKYHB1gwcVKDgZtAEnJjMg.png)

#### 资源

*   [https://developers.google.com/web/fundamentals/push-notifications/](https://developers.google.com/web/fundamentals/push-notifications/)
*   [https://developers.google.com/web/fundamentals/push-notifications/how-push-works](https://developers.google.com/web/fundamentals/push-notifications/how-push-works)
*   [https://developers.google.com/web/fundamentals/push-notifications/subscribing-a-user](https://developers.google.com/web/fundamentals/push-notifications/subscribing-a-user)
*   [https://developers.google.com/web/fundamentals/push-notifications/handling-messages](https://developers.google.com/web/fundamentals/push-notifications/handling-messages)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
