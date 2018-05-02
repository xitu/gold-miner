> * 原文地址：[How JavaScript works: tracking changes in the DOM using MutationObserver](https://blog.sessionstack.com/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver-86adc7446401)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver.md)
> * 译者：
> * 校对者：

# How JavaScript works: tracking changes in the DOM using MutationObserver

This is post # 10 of the series dedicated to exploring JavaScript and its building components. In the process of identifying and describing the core elements, we also share some rules of thumb we use when building [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=javascript-series-push-notifications-intro), a JavaScript application that needs to be robust and highly-performant to help users see and reproduce their web app defects real-time.

![](https://cdn-images-1.medium.com/max/800/0*mPXf5zRCdEQ42Hn0.)

Web apps are getting increasingly heavy on the client-side, due to many reasons such as the need of a richer UI to accommodate what more complex apps have to offer, real-time calculations, and so on.

The increased complexity makes it harder to know the exact state of the UI at every given moment during the lifecycle of your web app.

This gets even harder if you’re building some kind of a framework or just a library, for example, that has to react and perform certain actions that are dependent on the DOM.

### Overview

[MutationObserver](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver) is a Web API provided by modern browsers for detecting changes in the DOM. With this API one can listen to newly added or removed nodes, attribute changes or changes in the text content of text nodes.

Why would you want to do that?

There are quite a few cases in which the MutationObserver API can come really handy. For instance:

*   You want to notify your web app visitor that some change has occurred on the page he’s currently on.
*   You’re working on a new fancy JavaScript framework that loads dynamically JavaScript modules based on how the DOM changes.
*   You might be working on a WYSIWYG editor, trying to implement undo/redo functionality. By leveraging the MutationObserver API, you know at any given point what changes have been made, so you can easily undo them.

![](https://cdn-images-1.medium.com/max/800/1*48tGIboHxgLeKEjMTGkUGg.png)

These are just a few examples of how the MutationObserver can be of help.

#### How to use MutationObserver

Implementing `MutationObserver` into your app is rather easy. You need to create a `MutationObserver` instance by passing it a function that would be called every time a mutation has occurred. The first argument of the function is a collection of all mutations which have occurred in a single batch. Each mutation provides information about its type and the changes which have occurred.

```
var mutationObserver = new MutationObserver(function(mutations) {
  mutations.forEach(function(mutation) {
    console.log(mutation);
  });
});
```

The created object has three methods:

*   `observe` — starts listening for changes. Takes two arguments — the DOM node you want to observe and a settings object
*   `disconnect` — stops listening for changes
*   `takeRecords` — returns the last batch of changes before the callback has been fired.

The following snippet shows how to start observing:

```
// Starts listening for changes in the root HTML element of the page.
mutationObserver.observe(document.documentElement, {
  attributes: true,
  characterData: true,
  childList: true,
  subtree: true,
  attributeOldValue: true,
  characterDataOldValue: true
});
```

Now, let’s say that you have some very simple `div` in the DOM:

```
<div id="sample-div" class="test"> Simple div </div>
```

Using jQuery, you canremove the `class` attribute from that div:

```
$("#sample-div").removeAttr("class");
```

As we have started observing, after calling `mutationObserver.observe(...)` we’re going to see a log in the console of the respective [MutationRecord](https://developer.mozilla.org/en-US/docs/Web/API/MutationRecord):

![](https://cdn-images-1.medium.com/max/800/1*UxkSstuyCvmKkBTnjbezNw.png)

This is the mutation caused by removing the `class` attribute.

And finally, in order to stop observing the DOM after the job is done, you can do the following:

```
// Stops the MutationObserver from listening for changes.
mutationObserver.disconnect();
```

Nowadays, the `MutationObserver` is widely supported:

![](https://cdn-images-1.medium.com/max/800/0*nlOmrsfy-Y1XoR8B.)

#### Alternatives

The `MutationObserver`, however, has not always been around. So what did developers resort to before the `MutationObserver` came along?

There are a few other options available:

*   **Polling**
*   **MutationEvents**
*   **CSS animations**

#### Polling

The simplest and most unsophisticated way was by polling. Using the browser setInterval WebAPI you can set up a task that would periodically check if any changes have occurred. Naturally, this method significantly degrades web app/website performance.

#### MutationEvents

In the year 2000, the [MutationEvents API](https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Mutation_events) was introduced. Albeit useful, mutation events are fired on every single change in the DOM which again causes performance issues. Nowadays the `MutationEvents` API has been deprecated, and soon modern browsers will stop supporting it altogether.

This is the browser support for `MutationEvents`:

![](https://cdn-images-1.medium.com/max/800/0*l-QdpBfjwNfPDTyh.)

#### CSS animations

A somewhat strange alternative is one that relies on [CSS animations](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations/Using_CSS_animations). It might sound a bit confusing. Basically, the idea is to create an animation which would be triggered once an element has been added to the DOM. The moment the animation starts, the `animationstart` event will be fired: if you have attached an event handler to that event, you’d know exactly when the element has been added to the DOM. The animation’s execution time period should be so small that it’s practically invisible to the user.

First, we need a parent element, inside which, we’d like to listen to node insertions:

```
<div id=”container-element”></div>
```

In order to get a handle on node insertion, we need to set up a series of [keyframe](https://www.w3schools.com/cssref/css3_pr_animation-keyframes.asp) animations which will start when the node is inserted:

```
@keyframes nodeInserted { 
 from { opacity: 0.99; }
 to { opacity: 1; } 
}
```

With the keyframes created, the animation needs to be applied on the elements you’d like to listen for. Note the small durations — they are relaxing the animation footprint in the browser:

```
#container-element * {
 animation-duration: 0.001s;
 animation-name: nodeInserted;
}
```

This adds the animation to all child nodes of the `container-element`. When the animation ends, the insertion event will fire.

We need a JavaScript function which will act as the event listener. Within the function, the initial `event.animationName` check must be made to ensure it’s the animation we want.

```
var insertionListener = function(event) {
  // Making sure that this is the animation we want.
  if (event.animationName === "nodeInserted") {
    console.log("Node has been inserted: " + event.target);
  }
}
```

Now it’s time to add the event listener to the parent:

```
document.addEventListener(“animationstart”, insertionListener, false); // standard + firefox
document.addEventListener(“MSAnimationStart”, insertionListener, false); // IE
document.addEventListener(“webkitAnimationStart”, insertionListener, false); // Chrome + Safari

```

This is the browser support for CSS animations:

![](https://cdn-images-1.medium.com/max/800/0*W4wHvVAeUmc45vA2.)

`MutationObserver` offers a number of advantages over the above-mentioned solutions. In essence, it covers every single change that can possibly occur in the DOM and it’s way more optimized as it fires the changes in batches. On top of it, `MutationObserver` is supported by all major modern browsers, along with a couple of polyfills which use `MutationEvents` under the hood.

`MutationObserver` occupies a central position in [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=mutation-observer-post)’s library.

Once you integrate the SessionStack’s library in your web app, it starts collecting data such as DOM changes, network requests, exceptions, debug messages, etc. and sends it to our servers., SessionStack uses this data to recreate everything that happened to your users and show your product issues the same way they happened to your users. Quite a few users think that SessionStack records an actual video — it doesn’t. Recording an actual video is very heavy, while the small amount of data we gather is very lightweight and doesn’t impact the UX and performance of your web app.

There is a free plan if you’d like to [give SessionStack a try](https://www.sessionstack.com/?utm_source=medium&utm_medium=source&utm_content=javascript-series-web-workers-try-now).

![](https://cdn-images-1.medium.com/max/800/0*h2Z_BnDiWfVhgcEZ.)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
