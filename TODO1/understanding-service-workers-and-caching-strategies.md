> * 原文地址：[Understanding Service Workers and Caching Strategies](https://blog.bitsrc.io/understanding-service-workers-and-caching-strategies-a6c1e1cbde03)
> * 原文作者：[Aayush Jaiswal](https://medium.com/@aayush1408)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-service-workers-and-caching-strategies.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-service-workers-and-caching-strategies.md)
> * 译者：
> * 校对者：

# Understanding Service Workers and Caching Strategies

> This guide will make sure that you understand service workers and know when to use which caching strategy.

![Photo by [Maksym Zakharyak](https://unsplash.com/photos/6VBRu8jR8to?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/search/photos/workflow?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10368/1*vMvkVSydVwjeXBOAXDjC5w.jpeg)

If you have been in the javascript or development world for some time, you must have heard about Service Workers. So what are they? In simple and plain words, **it’s a script that browser runs in the background and has whatsoever no relation with web pages or the DOM, and provide out of the box features.** Some of these features are proxying network requests, push notifications and background sync. Service workers ensure that the user has a rich offline experience.

You can think of the service worker as someone who sits between the client and server and all the requests that are made to the server pass through the service worker. Basically, **a middle man**. Since all the request pass through the service worker, it is capable to intercept these requests on the fly.

![Service Worker as the middle man👷‍♂️](https://cdn-images-1.medium.com/max/2000/1*st7O3EJn6_lrz9QkG0McvQ.png)

Service workers are like Javascript workers and have no interaction with the DOM or web pages. They run on a different thread and can access the DOM through the **postMessage** API. If you are planning on building, progressive web apps then you should possess a good understanding of the service workers and the caching strategies.

> **Note** Service workers are not web workers. Web workers are scripts that run on a different thread to perform load intensive calculations so that the main event loop is not blocked and does not cause a slow UI.

---

Tip: Use **[Bit](https://github.com/teambit/bit)** to reuse and sync components between apps. Share components as a team to build together, and build multiple apps faster with components.
[**Component Discovery and Collaboration · Bit**
Bit is where developers share components and collaborate to build amazing software together. Discover components shared…bit.dev](https://bit.dev/)

![Example: React spinners with Bit- choose, play, install](https://cdn-images-1.medium.com/max/2000/1*Yhkh7jbS5Mx9uP96Y88pZg.gif)

---

## Registering the service worker

To use service worker in a site we must first register a service worker in one of our javascript files.

![](https://cdn-images-1.medium.com/max/3976/1*EJh3hdqmn81tZEBTpfw6LQ.png)

In the above code, we first check if the service worker API exists or not. If the support exists, we’ll register the service worker, using the register method by providing the path of the service worker file. So once the page is loaded, your service worker is registered.

## Service Worker life cycle

![The life cycle of service worker 👀](https://cdn-images-1.medium.com/max/2000/1*2icy-zbfbPzd2kYhHwxcNQ.png)

#### Install

When the service worker is registered, an **install** event is fired. We can listen for this event in the **sw.js** file. Before moving into the code, let’s first understand what we should do in this **install** event.

* We would like to set up our cache in this event.
* Add all the static assets into the cache.

The **event.waitUntil()** method takes a promise and uses it to know how long installation takes, and whether it succeeded or not. If any single file is not cached, then the service worker is not installed. So, it is important to make sure that there is not a long list of URLs to cache because if even a single url fails to cache, it will halt the installation of the service worker.

![Install Stage](https://cdn-images-1.medium.com/max/3520/1*0fWZsySFns4KpUqaFZk3eQ.png)

#### Activate

Once a new Service Worker has been installed and a previous version isn’t being used, the new one activates, and we get an **activate** event. In this event, we can remove or delete the old existing cache. The below-given code snippet is taken from the service worker guide.

![Activate Stage](https://cdn-images-1.medium.com/max/3520/1*KQQGF9AgvjpzvnksqQ6Q2Q.png)

#### Idle

Not much to talk about this stage, after the activate stage the service worker sits idle and does nothing until another event is fired.

#### Fetch

Whenever a fetch request is made, a **fetch** event is fired. In this event, we try to implement caching strategies. As I mentioned before, the service worker works as a middle man, all the requests go through the service workers. From here on we can decide whether we want that request to go to the network or to the cache. Below is an example, where the request is intercepted by the service worker and the request is made to the cache if the cache doesn’t return a valid response then the request is fired to the network.

![Fetch Stage](https://cdn-images-1.medium.com/max/3520/1*kEE7vxaLlxIP4gCUUXPN8Q.png)

The above-shown code is one of the examples of caching strategies. Hope, you have understood about the service workers. Now, we’ll dive into some of the caching strategies.

## Caching strategies

In the above **fetch** event, we discussed one of the caching strategies called **c**ache falling back to network**.** One thing to remember is that all the caching strategies are to be implemented in the **fetch** event. Let’s get into some of the caching strategies -

#### Cache only

Easiest among the others. As you can guess by the name itself, it means all the requests go to the cache.

**When to use: Should be used when you want to access only your static assets.**

![Cache only](https://cdn-images-1.medium.com/max/3520/1*YWa918sEIMEmeTDH6KJQDg.png)

#### Network only

The client makes the request, the service worker intercepts it and makes the request to the network. No-brainer !!

**When to use- When things that have no offline equivalent, such as analytics pings, non-GET requests.**

![Network only](https://cdn-images-1.medium.com/max/3520/1*Rn7nC460uo0E_k6IgANO_Q.png)

> **Note**- This will also work if we don’t use the **respondWith** method.

#### Cache falling back to network

It is the one discussed before in the fetch event, service worker makes a request to the cache if the request is not successful it goes to the network.

**When to use- If you are building offline first app**

![Cache falling back to network](https://cdn-images-1.medium.com/max/3520/1*pF1Zr5gWmwEgPB2A2fPZjg.png)

#### Network falling back to cache

First, the service worker will make a request to the network, if the request is successful then great else fallback to cache.

**When to use- When you are building something that changes very often like a post page or a game leader board. When your priority is the latest data, this strategy is the go-to.**

![Network falling back to cache](https://cdn-images-1.medium.com/max/3520/1*xn7l--f2VtZGq5c4DWmmzQ.png)

#### Generic fallback

When both the requests fail, one to the cache and other to the network, you display a generic fallback so that your users won’t experience a blank screen or some weird error.

![Generic Fallback](https://cdn-images-1.medium.com/max/3520/1*sMjn8fVkJLWDwonMDB8gLg.png)

We have covered the most used and basic caching strategies required while developing a progressive web app. There is more to it and you can look it up at [The offline cookbook](https://developers.google.com/web/fundamentals/instant-and-offline/offline-cookbook/) by Jake Archibald.

## Conclusion

In this article, we learned about some cool stuff related to Service Workers and Caching Strategies. Hope you liked this article, and if you did, clap your 💖 out and follow me for more content. Thanks for reading 🙏 Please feel free to comment and ask anything.

---

## Learn more
[**5 Tools for Faster Development in React**
**5 tools to speed the development of your React application, focusing on components.**blog.bitsrc.io](https://blog.bitsrc.io/5-tools-for-faster-development-in-react-676f134050f2)
[**11 JavaScript Animation Libraries For 2019**
**Some of the finest JS and CSS animation libraries around.**blog.bitsrc.io](https://blog.bitsrc.io/11-javascript-animation-libraries-for-2018-9d7ac93a2c59)
[**How to Build a React Progressive Web Application (PWA)**
**A deep, comprehensive guide with live code examples**blog.bitsrc.io](https://blog.bitsrc.io/how-to-build-a-react-progressive-web-application-pwa-b5b897df2f0a)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
