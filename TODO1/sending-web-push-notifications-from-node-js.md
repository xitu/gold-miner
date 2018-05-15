> * 原文地址：[Sending Web Push Notifications from Node.js](https://thecodebarbarian.com/sending-web-push-notifications-from-node-js.html)
> * 原文作者：[code_barbarian](http://www.twitter.com/code_barbarian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/sending-web-push-notifications-from-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/sending-web-push-notifications-from-node-js.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：

# 由 Node.js 发送 Web 推送通知

使用 [service workers API](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) 可以让你直接由 Node.js 应用向 Chrome 浏览器发送推送通知。[`web-push` npm 模组](https://www.npmjs.com/package/web-push)可以让你免去 [PubNub](https://www.pubnub.com/) 之类的中间商，直接推送消息。本文将在前端使用原生 JavaScript，在后端使用 [Express](https://www.npmjs.com/package/express) 框架，通过一个“Hello, World”级别的样例来带你了解如何进行 web 推送通知。最终的效果如下图所示。本项目的全部源码可在 [GitHub](https://github.com/vkarpov15/web-push-demo) 查阅。

![](https://i.imgur.com/bGyKuaW.png)

## 鉴权及配置服务端

要设置 web 推送，必须先创建 [VAPID keys](https://blog.mozilla.org/services/2016/04/04/using-vapid-with-webpush/)。VAPID keys 用于识别是谁发送了推送消息。npm 的 `web-push` 模组能够[帮助你生成 VAPID keys](https://www.npmjs.com/package/web-push#command-line)，下面我们将安装 `web-push` 及其依赖，并使用 `web-push generate-vapid-keys` 来创建 VAPID keys。

```
$ npm install express@4.16.3 web-push@3.3.0 body-parser@1.18.2 express-static@1.2.5
+ express@4.16.3
+ web-push@3.3.0
+ body-parser@1.18.2
+ express-static@1.2.5
added 62 packages in 1.42s
$
$ ./node_modules/.bin/web-push generate-vapid-keys
=======================================
Public Key:
BOynOrGhgkj8Bfk4hsFENAQYbnqqLSigUUkCNaBsAmNuH6U9EWywR1JIdxBVQOPDbIuTaj0tVAQbczNLkC5zftw
Private Key:
<OMITTED>
=======================================
$
```

如果你需要支持低版本浏览器，那么还要获取 [GCM API key](https://medium.com/@jasminejacquelin/integrating-push-notifications-in-your-node-react-web-app-4e8d8190a52c#9a53)，但在桌面版 Chrome 63 或更高版本中不需要它。

下面创建 `index.js` 文件，其中包含你的服务。你需要使用 `require()` 导入 web-push 模组，并配置刚才的 VAPID keys。配置相当简单，将 VAPID keys 存放在 `PUBLIC_VAPID_KEY` 与 `PRIVATE_VAPID_KEY` 环境变量中即可。

```javascript
const webpush = require('web-push');
const publicVapidKey = process.env.PUBLIC_VAPID_KEY;
const privateVapidKey = process.env.PRIVATE_VAPID_KEY;
// 此处换成你自己的邮箱
webpush.setVapidDetails('mailto:val@karpov.io', publicVapidKey, privateVapidKey);
```

下一步，为 Express 应用添加一个名为 `/subscribe` 的端点。浏览器中的 JavaScript 将会发送一个 body 中包含 [`PushSubscription` 对象](https://developer.mozilla.org/en-US/docs/Web/API/PushSubscription)的 HTTP 请求。为了用 `webpush.sendNotification()` 发送推送通知，你需要获取 `PushSubscription` 对象。

```javascript
const app = express();
app.use(require('body-parser').json());
app.post('/subscribe', (req, res) => {
  const subscription = req.body;
  res.status(201).json({});
  const payload = JSON.stringify({ title: 'test' });
  console.log(subscription);
  webpush.sendNotification(subscription, payload).catch(error => {
    console.error(error.stack);
  });
});
```

以上就是服务端需要做的全部配置。你可以在 [GitHub](https://github.com/vkarpov15/web-push-demo/blob/master/index.js) 查阅完整代码。现在，我们就要创建客户端 `client.js` 与一个 service worker —— `worker.js` 了。

## 客户端与 Service Worker

首先，使用 [`express-static` npm 模组](http://npmjs.com/package/express-static)，[对 Express 应用进行配置](https://github.com/vkarpov15/web-push-demo/blob/b356e53c1468c5611b9c4722411af3839bafc360/index.js#L26)，为客户端部署静态资源，将静态资源部署在服务的最顶级目录下。
需要注意的是要在处理 `/subscribe` 路由之后再调用这个 `app.use()`，否则 Express 将不会根据你的配置处理路由，而是会去查找 `subscribe.html` 文件。

```javascript
app.use(require('express-static')('./'));
```

接着，创建 `index.html` 文件，这个文件将部署为你的应用的入口。文件中仅有的关键之处就是 `<script>` 标签，它将加载客户端 JavaScript 代码；其余部分都无关紧要。


```html
<html>
  <head>
    <title>Push Demo</title>
    <script type="application/javascript" src="/client.js"></script>
  </head>

  <body>
    Service Worker Demo
  </body>
</html>
```

现在你的入口做好了。创建一个名为 `client.js` 的文件。[这个文件](https://github.com/vkarpov15/web-push-demo/blob/b356e53c1468c5611b9c4722411af3839bafc360/client.js) 将告知浏览器初始化你的 service worker 并向 `/subscribe` 发送 HTTP 请求。由于支持 service workers 的浏览器也应该能支持 async 与 await，因此上述示例中使用了 [async/await](http://thecodebarbarian.com/80-20-guide-to-async-await-in-node.js.html)。

```javascript
// 在此用你自己的 public key 进行替换硬编码。
const publicVapidKey = 'BOynOrGhgkj8Bfk4hsFENAQYbnqqLSigUUkCNaBsAmNuH6U9EWywR1JIdxBVQOPDbIuTaj0tVAQbczNLkC5zftw';
if ('serviceWorker' in navigator) {
  console.log('Registering service worker');
  run().catch(error => console.error(error));
}
async function run() {
  console.log('Registering service worker');
  const registration = await navigator.serviceWorker.
    register('/worker.js', {scope: '/'});
  console.log('Registered service worker');
  console.log('Registering push');
  const subscription = await registration.pushManager.
    subscribe({
      userVisibleOnly: true,
      // `urlBase64ToUint8Array()` 函数与以下网址中的描述一致
      // https://www.npmjs.com/package/web-push#using-vapid-key-for-applicationserverkey
      applicationServerKey: urlBase64ToUint8Array(publicVapidKey)
    });
  console.log('Registered push');
  console.log('Sending push');
  await fetch('/subscribe', {
    method: 'POST',
    body: JSON.stringify(subscription),
    headers: {
      'content-type': 'application/json'
    }
  });
  console.log('Sent push');
}
```

最后，你需要实现 `client.js` 所加载的 `worker.js` 文件。
这个文件是 service worker 逻辑所在之处。当订阅者接受到一个推送消息时，service worker 将收到一个 ['push' 事件](https://developers.google.com/web/ilt/pwa/introduction-to-push-notifications#handling_the_push_event_in_the_service_worker)。

```javascript
console.log('Loaded service worker!');
self.addEventListener('push', ev => {
  const data = ev.data.json();
  console.log('Got push', data);
  self.registration.showNotification(data.title, {
    body: 'Hello, World!',
    icon: 'http://mongoosejs.com/docs/images/mongoose5_62x30_transparent.png'
  });
});
```

好了！配置正确的环境变量并启动你的服务：

```
$ env PUBLIC_VAPID_KEY='OMITTED' env PRIVATE_VAPID_KEY='OMITTED' node .
```

在 Chrome 中访问 `http://localhost:3000`，你应该可以看到下面的推送通知！

![](https://i.imgur.com/bGyKuaW.png)

这种通知不仅在 Chrome 中可用，在 [Firefox](https://support.mozilla.org/en-US/kb/push-notifications-firefox) 也可以用同样的代码实现。

![](https://i.imgur.com/uufjZPH.png)

## 最后

Web 推送只是 [service workers](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) 带来的诸多好处的其中一种。
通过一个 [npm 模组](https://www.npmjs.com/package/web-push)，你就能给大多数现代浏览器推送通知。下次你要为你的 web 应用增加推送通知功能的时候，记得用 service workers 哦！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


