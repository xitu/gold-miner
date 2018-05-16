> * 原文地址：[Sending Web Push Notifications from Node.js](https://thecodebarbarian.com/sending-web-push-notifications-from-node-js.html)
> * 原文作者：[code_barbarian](http://www.twitter.com/code_barbarian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/sending-web-push-notifications-from-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/sending-web-push-notifications-from-node-js.md)
> * 译者：
> * 校对者：

# Sending Web Push Notifications from Node.js

Using [service workers](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API), you can send push notifications to Chrome straight from your Node.js app. The excellent
[`web-push` npm module](https://www.npmjs.com/package/web-push) lets you send
push notifications without going through an intermediary service like [PubNub](https://www.pubnub.com/). This article will walk you through setting
up a "Hello, World" example of web push notifications using a vanilla JavaScript
frontend and [Express](https://www.npmjs.com/package/express) on the backend. The final result will look like what you
see below. The full source for this project is available on [GitHub](https://github.com/vkarpov15/web-push-demo).

![](https://i.imgur.com/bGyKuaW.png)

## Credentials and Server Setup

In order to set up web push, you need to create a set of [VAPID keys](https://blog.mozilla.org/services/2016/04/04/using-vapid-with-webpush/). VAPID keys identify who is sending the push notification. The `web-push` npm
module can [generate VAPID keys for you](https://www.npmjs.com/package/web-push#command-line), so let's install `web-push` along with some other dependencies and use `web-push generate-vapid-keys`
to create the keys.

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

In order to support older browsers you may need to also get a [GCM API key](https://medium.com/@jasminejacquelin/integrating-push-notifications-in-your-node-react-web-app-4e8d8190a52c#9a53), but you don't need this in desktop Chrome 63 or higher.

Next, create a file called `index.js` that will contain your server. You'll
need to `require()` and configure the web-push module with your VAPID keys.
In the interest of simplicity, put the VAPID keys in the `PUBLIC_VAPID_KEY`
and `PRIVATE_VAPID_KEY` environment variables.

```javascript
const webpush = require('web-push');
const publicVapidKey = process.env.PUBLIC_VAPID_KEY;
const privateVapidKey = process.env.PRIVATE_VAPID_KEY;
// Replace with your email
webpush.setVapidDetails('mailto:val@karpov.io', publicVapidKey, privateVapidKey);
```

Next, add a `/subscribe` [endpoint](http://expressjs.com/en/guide/routing.html) to your Express app. Your browser JavaScript will send an HTTP request to this
endpoint with a [`PushSubscription` object](https://developer.mozilla.org/en-US/docs/Web/API/PushSubscription) in the request body. You need the `PushSubscription` object in order to send a push
notification via `webpush.sendNotification()`.

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

That's all you need on the server side. You can [find the complete source on GitHub](https://github.com/vkarpov15/web-push-demo/blob/master/index.js). Now,
you need to create a client `client.js` and a service worker `worker.js`.

## Client and Service Worker

First, in order to serve up your static assets to the client, use the
[`express-static` npm module](http://npmjs.com/package/express-static) to [configure your Express app](https://github.com/vkarpov15/web-push-demo/blob/b356e53c1468c5611b9c4722411af3839bafc360/index.js#L26) to serve static files from the top-level directory.
Just make sure you put this `app.use()` call **after** your `/subscribe` route
handler, otherwise Express will look for a `subscribe.html` file instead of
using your route handler.

```javascript
app.use(require('express-static')('./'));
```

Next, create an `index.html` file that will serve as an entry point for your
application. The only part of this file that really matters is the `<script>` tag
that pulls in the client-side JavaScript, the rest is a placeholder.

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

Now that you have an entry point, create a JavaScript file called `client.js`.
[This file](https://github.com/vkarpov15/web-push-demo/blob/b356e53c1468c5611b9c4722411af3839bafc360/client.js) will be responsible for telling the browser to initialize
your service worker and making the HTTP request to `/subscribe`. The below
example uses [async/await](http://thecodebarbarian.com/80-20-guide-to-async-await-in-node.js.html), because if your browser supports service workers it should support async/await as well.

```javascript
// Hard-coded, replace with your public key
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
      // The `urlBase64ToUint8Array()` function is the same as in
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

Finally, you need to implement the `worker.js` file that `client.js` loads.
This is where your service worker logic lives. In a service worker, you get
a ['push' event](https://developers.google.com/web/ilt/pwa/introduction-to-push-notifications#handling_the_push_event_in_the_service_worker) when your subscription receives
a push notification.

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

And that's it! Start your server with the correct environment variables:

```
$ env PUBLIC_VAPID_KEY='OMITTED' env PRIVATE_VAPID_KEY='OMITTED' node .
```

Navigate to `http://localhost:3000` in Chrome, and you should see the below
push notification!

![](https://i.imgur.com/bGyKuaW.png)

These notifications aren't just limited to Chrome, this same code works with
[Firefox](https://support.mozilla.org/en-US/kb/push-notifications-firefox) as well.

![](https://i.imgur.com/uufjZPH.png)

## Moving On

Web push is just one of [numerous advantages service workers provide](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API).
With a single [npm module](https://www.npmjs.com/package/web-push), you can
send push notifications to most modern browsers. Give service workers a shot
next time you want to add push notifications to your web app!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
