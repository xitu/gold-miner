
  > * 原文地址：[Understanding Service Workers](http://blog.88mph.io/2017/07/28/understanding-service-workers/)
  > * 原文作者：[Adnan Chowdhury](http://blog.88mph.io/author/adnan/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/understanding-service-workers.md](https://github.com/xitu/gold-miner/blob/master/TODO/understanding-service-workers.md)
  > * 译者：
  > * 校对者：

  # Understanding Service Workers

  What are Service Workers? What can they do, and how can make your web app perform better? This article sets out to answer those questions, plus how to implement them using the Ember.js framework.

## Table of Contents

- [Background](#background)
- [Registration](#registration)
- [Install Event](#installevent)
- [Fetch Event](#fetchevent)
- [Caching Strategies](#cachingstrategies)
- [Activate Event](#activateevent)
- [Sync Event](#syncevent)
- [When is the Sync Event fired?](#whenisthesynceventfired)
- [Push Notifications](#pushnotifications)
- [Notifications](#notifications)
- [Push messaging](#pushmessaging)
- [Implementing Using Ember.js](#implementingusingemberjs)
- [Understanding ember-service-worker Conventions](#understandingemberserviceworkerconventions)
- [Build your Ember App w/ Service Workers](#buildyouremberappwserviceworkers)
- [Conclusion](#conclusion)

## Background

In a time when the web was young, there was scarcely any thought given to how a web page should behave when a user was offline. You were just *always* online.

![Connected!](http://blog.88mph.io/content/images/2017/07/aol-connected.jpg)

Connected! The gang's all here! Don't ever leave.

But with the advent of mobile internet, and with the rest of the world catching up, spotty internet connections have become increasingly commonplace across users of the modern web.

Consequently, it has become valuable for websites to take ownership of how they behave offline so that users are not limited by network availability.

[AppCache](https://developer.mozilla.org/en-US/docs/Web/HTML/Using_the_application_cache) was initially introduced as part of the HTML5 spec as a solution for offline web applications. It consisted of a combination of HTML and JS that centered around a *cache manifest*, a configuration file written in a declarative language.

AppCache was eventually found to be [unwieldy and full of gotchas](https://alistapart.com/article/application-cache-is-a-douchebag). It has since been deprecated and effectively replaced by Service Workers.

[Service workers](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API) provide a more future-proof solution to the offline problem, by replacing AppCache's declarative style of implementation with a more imperative, procedural one.

Service Workers are a way to execute code in a persistent, background process contained in the web browser. The code is event-driven, meaning the events that fire in the scope of a Service Worker are what drives its behavior.

The rest of this article is a brief explanation for each of those events. But to begin utilizing Service Workers, you will first need to implement code in your front-facing web app that registers the Service Worker.

## Registration

The code below illustrates how to **register** your Service Worker in the client's browser. This is accomplished by having the following `register` call executed somewhere on your front-facing web app:

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

This will tell the browser where to find your Service Worker implementation. The browser will look for the file (`/sw.js`) and save it as a Service Worker under the domain that is being accessed. This file will contain all of the event handlers that will define your Service Worker.

![](http://blog.88mph.io/content/images/2017/07/Screenshot-2017-07-16-17.39.10.png)

A registered Service Worker in Chrome DevTools

It will also set the **scope** of your ServiceWorker. The filename `/sw.js` implies that the scope of the SW is the root path of your URL (or `http://localhost:3000/`). This means any requests that are made under the root path of your URL will be made visible to the SW via fired events. A filename such as `/js/sw.js` would capture requests only under `http://localhost:3000/js`.

Alternatively, you could explicitly set the scope of your SW by passing a second argument to the `register` method:
`navigator.serviceWorker.register('/sw.js', { scope: '/js' })`.

## Event Handlers

Now that your Service Worker is registered, it's time to implement the event handlers that are triggered during the lifetime of your Service Worker.

#### Install Event

The install event is fired when your Service Worker registers for the first time, and any time after that when your Service Worker file (`/sw.js`) is updated (the browser will automatically detect changes).

The install event is useful for logic you want to execute during the initialization of your Service Worker, i.e. a one-off operation that sets things up for the life of your Service Worker. A common use case is to load the cache during the install step.

Here is an example of an install event handler that will add data to the cache.

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

`urlsToCache` contains a list of URLs we want to add to the cache.

`caches` is a global [CacheStorage](https://developer.mozilla.org/en-US/docs/Web/API/CacheStorage) object that allows you to manage your caches in the browser. We call `open` to retrieve the specific [Cache](https://developer.mozilla.org/en-US/docs/Web/API/Cache) object we want to work with.

`cache.addAll` will take a list of URLs, make a request to each, and then store the response in its cache. It uses the request body as a key for each cache value. Read more at the [addAll](https://developer.mozilla.org/en-US/docs/Web/API/Cache/addAll) docs.

![](http://blog.88mph.io/content/images/2017/07/Screenshot-2017-07-16-20.09.42.png)

Cached data in Chrome DevTools

#### Fetch event

The **fetch** event is fired every time the web page makes a request. When it fires, your Service Worker has the ability to 'intercept' the request and decide what to return - whether that be cached data, or the response to an actual network request.

The following example illustrates a *cache-first* strategy: any cached data that matches the request will be sent off first, without a network request. Only if there is no existing cached data will a network request be made.

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

`request` contains the request body that is included in the [FetchEvent](https://developer.mozilla.org/en-US/docs/Web/API/FetchEvent) object. It is used to lookup a matching response in the cache.

`cache.match` will try to find a cached response that matches the specified request. If it finds nothing, the promise will resolve with `undefined`. We check for this, and make a `fetch` call in this case, which makes a network request and returns a promise.

`event.respondWith` is a method specifically on a FetchEvent object that we use to send a response back to the browser for the request. It accepts a Promise that resolves to a response (or network error).

###### Caching Strategies

The fetch event is particularly important because it's where you can define your *caching strategy*. That is, how you determine when to use cached data, and when to use network-sourced data.

The beauty in Service Workers is that it is a low-level API for intercepting requests and lets you decide what response to provide for them. This allows us the freedom to implement our own strategy for providing cached or network-sourced content. There are several basic caching strategies that you could employ when trying to implement the best one for your web app.

Mozilla has a [handy resource](https://serviceworke.rs/caching-strategies.html) that documents several different caching strategies. There is also [The Offline Cookbook](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook) written by Jake Archibald that outlines some of the same caching strategies, and more.

In an above example, we demonstrated a basic **cache-first** strategy. The following is an example which I've found applicable in my own projects: a **cache and update** strategy. This method will let the cache respond first, but subsequently make a network request in the background. The response from this background request is used to update the value in the cache so that an updated response is provided the next time it is accessed.

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

`event.respondWith` is used to provide a response to the request. Here we are opening the cache and finding a matching response. If it doesn't exist, we reach out to the network.

Subsequently, we call `event.waitUntil` to allow the async Promise to resolve before the Service Worker context is terminated. Here we make a network request, and then cache the response. Once this asynchronous operation is finished, `waitUntil` will resolve and the operation will terminate.

#### Activate Event

The activate event is a slightly less documented event, but is important for when you are updating your Service Worker file and need to execute any clean up or maintenance from the previous version of your Service worker.

When you update your Service Worker file (`/sw.js`), the browser will detect changes and display this in Chrome DevTools:

![](http://blog.88mph.io/content/images/2017/07/Screenshot-2017-07-18-08.29.32.png)

Your new Service Worker is 'waiting to activate'.

When the actual web page is closed, and re-opened again, the browser will replace the old Service Worker with the new one, and fire the **activate** event, after the **install** event. If you needed to clean up the caches or perform maintenance regarding the old version of your Service Worker, the activate event allows you the perfect time to do this.

#### Sync event

The sync event allows the deferring of network tasks until the user has connectivity. The feature it implements is commonly referred to as **background sync**. This is useful for ensuring that any network-dependent tasks that a user kicks off during offline mode will eventually reach their intended destination when the network is available again.

Here is an example of what a background sync implementation would look like. You'll need code in your front-facing JS that registers a sync event, accompanied by a sync event handler in your Service Worker:

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

Here we are assigning a click event to a button that will call `sync.register` on the [ServiceWorkerRegistration](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration) object.

Basically, any operation that you want to ensure reaches the network either immediately or eventually when the network comes online, needs to be registered as a sync event.

This could be something like POSTing a comment, or fetching user data, which will be defined in the Service Worker's event handler:

```
// sw.js
self.addEventListener('sync', event => {
  if (event.tag === 'submit') {
    console.log('sync!');
  }
});
```

Here we are listening for a sync event, and checking for the `tag` on the [SyncEvent](https://developer.mozilla.org/en-US/docs/Web/API/SyncEvent) object to see if it matches the `'submit'` tag we specified for the click event.

If multiple sync's under the `'submit'` tag are registered, the sync event handler will only execute once.

So for this example, if the user were offline, and clicked the button seven times, when the network returned, all sync registrations would consolidate and the sync event would fire just once.

In the case you would want separate syncs for each click event, you would register syncs under unique tags.

###### When is the Sync Event fired?

If the user is online, then the sync event will fire immediately and accomplish whatever task you've defined without delay.

If the user is offline, the sync event will fire as soon as network connectivity is regained.

If you're like me, and want to try this out in Chrome, be sure to actually disconnect your internet by disabling your Wi-Fi or otherwise network adapter. Toggling the Network checkbox in Chrome DevTools will not trigger sync events.

For more information, you can read [this explainer document](https://github.com/WICG/BackgroundSync/blob/master/explainer.md), as well as this [introduction to background syncs](https://developers.google.com/web/updates/2015/12/background-sync). The sync event is largely unimplemented across browsers (only in Chrome at the time of this writing), and is bound to undergo changes, so stay tuned.

#### Push Notifications

Push notifications are a feature that are enabled by Service Workers by exposing the `push` event to Service Workers, as well as the [Push API](https://developer.mozilla.org/en-US/docs/Web/API/Push_API) implemented by the browser.

When speaking about Web Push Notifications, there are actually two technologies at work: Notifications & Push Messaging.

###### Notifications

Notifications are pretty straightforward feature to implement with Service Workers:

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

You first need to ask permission from the user to enable notifications for your web page. From then on, you are able to toggle on notifications, and handle certain events, such as when a notification is closed by the user.

###### Push Messaging

Push messaging involves utilizing the Push API provided by the browser, coupled with backend implementation. An entirely separate article could be written on the implementation of Push API, but the basic gist is:

![Push API Diagram](http://blog.88mph.io/content/images/2017/07/push-api.svg)

It is an involved and slightly complicated process, and is outside the scope of this article. But if you'd like to learn more, this [introduction to push notifications](https://developers.google.com/web/ilt/pwa/introduction-to-push-notifications) is an informative read.

## Implementing Using Ember.js

Implementing Service Workers for your Ember app is incredibly easy. By virtue of [ember-cli](https://ember-cli.com/) and the [Ember Add-ons](https://www.emberaddons.com) community, you can equip your web app with Service Workers in plug-and-play fashion.

This is made possible in part by the [ember-service-worker](https://github.com/DockYard/ember-service-worker) add-on, provided by the folks at DockYard (docs [here](http://ember-service-worker.com/documentation/getting-started/)).

**ember-service-worker** sets up a modular architecture that can be used to plug in other ember-service-worker-* add-ons, such as [ember-service-worker-index](https://github.com/DockYard/ember-service-worker-index) or [ember-service-worker-asset-cache](https://github.com/DockYard/ember-service-worker-asset-cache). These add-ons implement different parts of behavior and caching strategies to make up your Service Worker.

#### Understanding `ember-service-worker` conventions

All of the **ember-service-worker-*** add-ons follow a convention, in that their core logic is stored in one of two folders in the root directory of the add-on, `/service-worker` and `/service-worker-registration`:

    node_modules/ember-service-worker
    ├── ...
    ├── package.json
    ├── service-worker
        └── index.js
    └── service-worker-registration
        └── index.js


`/service-worker` is where the main implementation of your Service Worker is located (what you would store in `sw.js` as shown earlier).

`/service-worker-registration` holds the logic you need to run in your front-facing code, where Service Worker registration would take place.

Let's take a look at the `/service-worker` implementation for **ember-service-worker-index** (code [here](https://github.com/DockYard/ember-service-worker-index/blob/master/service-worker/index.js)) to divulge what it actually does:

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

Without getting bogged down in the details, we can see that this code is basically implementing three of the event handlers we've talked about: `install`, `activate` and `fetch`.

In the `install` event handler, we are fetching `INDEX_HTML_URL`, and then calling `cache.put` to store the response.

`activate` does some rudimentary clean up.

In the `fetch` handler, we are checking to see if `request` meets several conditions (is it a `GET` request; is it asking for HTML; is it local; etc.) and if it satisfies those conditions, we respond with what is stored in the cache.

Notice we're calling `cache.match` and using `INDEX_HTML_URL` to look up the value, and not `request.url`. This means we'd always look up the same cache key, no matter what the actual URL is.

This is because an Ember app will always render using `index.html`. Any URL requests that are under the root URL of the app will end up with a cached version of `index.html`, where the Ember app would normally take over. That is the purpose of **ember-service-worker-index** - to cache `index.html`.

Similarly, [**ember-service-worker-asset-cache**](https://github.com/DockYard/ember-service-worker-asset-cache) will cache all the assets found in the `/assets` folder by implementing its own `install` and `fetch` event handlers.

There are [several add-ons](https://www.emberaddons.com/?query=service-worker) that employ **ember-service-worker** architecture and allow you to customize and fine tune your Service Worker's behavior and caching strategies.

#### Build your Ember App w/ Service Workers

First, you'll need [ember-cli](https://ember-cli.com/) installed. Then execute the following commands:

```
$ ember new new-app
$ cd new-app
$ ember install ember-service-worker
$ ember install ember-service-worker-index
$ ember install ember-service-worker-asset-cache
```


Your app is now serviced by Service Workers and by default will have `index.html` and `/assets/**/*` cached.

You can fine tune what files under the `/assets` folder will get cached via `config/environment.js`.

If you find that none of the existing ember-service-worker add-ons solve your problem, you can create your own following the [docs at the ember-service-worker website](http://ember-service-worker.com/documentation/authoring-plugins/).

## Conclusion

I hope you have gained a firmer understanding of Service Workers, and their underlying architecture, and also how web apps can utilize them to create a better experience for users.

`ember-service-worker` add-ons allow you implement them easily in your Ember.js web app. If you find that you need to implement your own logic for a Service Worker, it should be easy to create your own add-on that implements the event handlers you need to implement the behavior you want. This is something I'd like to tackle in the near future, so stay tuned!

#### From our Sponsors

![](http://blog.88mph.io/content/images/2017/07/Quartzy-logo.png)

*If you are interested in working with Ember.js full-time, [Quartzy](https://www.quartzy.com/) is hiring frontend devs! We help scientists around the world by helping them save money and be more efficient in the lab. Apply [here](http://grnh.se/coe8yp1).*


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  