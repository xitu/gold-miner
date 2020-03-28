> * 原文地址：[Fixing memory leaks in web applications](https://nolanlawson.com/2020/02/19/fixing-memory-leaks-in-web-applications/)
> * 原文作者：[Nolan](https://nolanlawson.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/fixing-memory-leaks-in-web-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/fixing-memory-leaks-in-web-applications.md)
> * 译者：
> * 校对者：

## Fixing memory leaks in web applications

Part of the bargain we struck when we switched from building server-rendered websites to client-rendered SPAs is that we suddenly had to take a lot more care with the resources on the user’s device. Don’t block the UI thread, don’t make the laptop’s fan spin, don’t drain the phone’s battery, etc. We traded better interactivity and “app-like” behavior for a new class of problems that don’t really exist in the server-rendered world.

One of these problems is memory leaks. A poorly-coded SPA can easily eat up megabytes or even gigabytes of memory, continuing to gobble up more and more resources, even as it’s sitting innocently in a background tab. At this point, the page might start to slow to a crawl, or the browser may just terminate the tab and you’ll see Chrome’s familiar “Aw, snap!” page.

[![Chrome page saying "Aw snap! Something went wrong while displaying this web page."](https://nolanwlawson.files.wordpress.com/2020/02/awsnap.png?w=570&h=186)](https://nolanwlawson.files.wordpress.com/2020/02/awsnap.png)

(Of course, a server-rendered website can also leak memory on the server side. But it’s extremely unlikely to leak memory on the client side, since the browser will clear the memory every time you navigate between pages.)

The subject of memory leaks is not well-covered in the web development literature. And yet, I’m pretty sure that most non-trivial SPAs leak memory, unless the team behind them has a robust infrastructure for catching and fixing memory leaks. It’s just far too easy in JavaScript to accidentally allocate some memory and forget to clean it up.

So why is so little written about memory leaks? My guesses:

* **Lack of complaints**: most users are not diligently watching Task Manager while they surf the web. Typically, you won’t hear about it from your users unless the leak is so bad that the tab is crashing or the app is slowing down.
* **Lack of data**: the Chrome team doesn’t provide data about how much memory websites are using in the wild. Nor are websites often measuring this themselves.
* **Lack of tooling**: it’s still not easy to identify or fix memory leaks with existing tooling.
* **Lack of caring**: browsers are pretty good at killing tabs that consume too much memory. Plus people seem to [blame the browser](https://www.google.com/search?hl=en&q=chrome%20memory%20hog) rather than the websites.

In this post, I’d like to share some of my experience fixing memory leaks in web applications, and provide some examples of how to effectively track them down.

## Anatomy of a memory leak

Modern web app frameworks like React, Vue, and Svelte use a component-based model. Within this model, the most common way to introduce a memory leak is something like this:

window.addEventListener('message', this.onMessage.bind(this));

That’s it. That’s all it takes to introduce a memory leak. If you call [`addEventListener`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener) on some global object (the `window`, the `<body>`, etc.) and then forget to clean it up with [`removeEventListener`](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/removeEventListener) when the component is unmounted, then you’ve created a memory leak.

Worse, you’ve just leaked your entire component. Because `this.onMessage` is bound to `this`, the component has leaked. So have all of its child components. And very likely, so have all the DOM nodes associated with the components. This can get very bad very fast.

Here is the fix:

```js
// Mount phase
this.onMessage = this.onMessage.bind(this);
window.addEventListener('message', this.onMessage);

// Unmount phase
window.removeEventListener('message', this.onMessage);
```

Note that we saved a reference to the bound `onMessage` function. You have to pass in exactly the same function to `removeEventListener` that you passed in to `addEventListener`, or else it won’t work.

## The memory leak landscape

In my experience, the most common sources of memory leaks are APIs like these:

1. `addEventListener`. This is the most common one. Call `removeEventListener` to clean it up.
2. [`setTimeout`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setTimeout) / [`setInterval`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setInterval). If you create a recurring timer (e.g. to run every 30 seconds), then you need to clean it up with [`clearTimeout`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/clearTimeout) or [`clearInterval`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/clearInterval). (`setTimeout` can leak if it’s used like `setInterval` – i.e., scheduling a new `setTimeout` inside of the `setTimeout` callback.)
3. [`IntersectionObserver`](https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver), [`ResizeObserver`](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver), [`MutationObserver`](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver), etc. These new-ish APIs are very convenient, but they are also likely to leak. If you create one inside of a component, and it’s attached to a globally-available element, then you need to call `disconnect()` to clean them up. (Note that DOM nodes which are garbage-collected will have their listeners and observers garbage-collected as well. So typically, you only need to worry about global elements, e.g. the `<body>`, the `document`, an omnipresent header/footer element, etc.)
4. [Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise), [Observables](https://rxjs.dev/guide/observable), [EventEmitters](https://nodejs.org/api/events.html#events_class_eventemitter), etc. Any programming model where you’re setting up a listener can leak memory if you forget to stop listening. (A Promise can leak if it’s never resolved or rejected, in which case any `.then()` callbacks attached to it will leak.)
5. Global object stores. With something like [Redux](https://redux.js.org/) the state is global, so if you’re not careful, you can just keep appending memory to it and it will never get cleaned up.
6. Infinite DOM growth. If you implement an infinite scrolling list without [virtualization](https://github.com/WICG/virtual-scroller#readme), then the number of DOM nodes will grow without bound.

Of course, there are plenty of other ways to leak memory, but these are the most common ones I’ve seen.

## Identifying memory leaks

This is the hard part. I’ll start off by saying that I just don’t think any of the tooling out there is very good. I’ve tried Firefox’s memory tool, the Edge and IE memory tools, and even Windows Performance Analyzer. The best-in-class is still the Chrome Developer Tools, but it has a lot of rough edges that are worth knowing about.

In the Chrome DevTools, our main tool of choice is going to be the “heap snapshot” tool in the “Memory” tab. There are other memory tools in Chrome, but I don’t find them very helpful for identifying leaks.

[![Screenshot of the Chrome DevTools Memory tab with the Heap Snapshot tool](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-11-03-49.png?w=570&h=333)](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-11-03-49.png)

The Heap Snapshot tool allows you to take a memory capture of the main thread or web workers or iframes.

When you click the “take snapshot” button, you’ve captured all the live objects in a particular JavaScript VM on that web page. This includes objects referenced by the `window`, objects referenced by `setInterval` callbacks, etc. Think of it as a frozen moment in time representing all the memory used by that web page.

The next step is to reproduce some scenario that you think may be leaking – for instance, opening and closing a modal dialog. Once the dialog is closed, you’d expect memory to return back to the previous level. So you take another snapshot, and then **diff it with the previous snapshot**. This diffing is really the killer feature of the tool.

![Diagram showing a first heapsnapshot followed by a leaking scenario followed by a second heap snapshot which should be equal to the first](https://nolanwlawson.files.wordpress.com/2020/02/leak-scenario.png?w=570&h=285)

However, there are a few limitations of the tool that you should be aware of:

1. Even if you click the little “collect garbage” button, you may need to take a few consecutive snapshots for Chrome to truly clean up the unreferenced memory. In my experience, three should be enough. (Check the total memory size of each snapshot – it should eventually stabilize.)
2. If you have web workers, service workers, iframes, shared workers, etc., then this memory will not be represented in the heap snapshot, because it lives in another JavaScript VM. You can capture this memory if you want, but just be sure you know which one you’re measuring.
3. Sometimes the snapshotter will get stuck or crash. In that case, just close the browser tab and start all over again.

At this point, if your app is non-trivial, then you’re probably going to see a **lot** of leaking objects between the two snapshots. This is where things get tricky, because not all of these are true leaks. Many of these are just normal usage – some object gets de-allocated in favor of another one, something gets cached in a way that will get cleaned up later, etc.

## Cutting through the noise

I’ve found that the best way to cut through the noise is to repeat the leaking scenario several times. For instance, instead of just opening and closing a modal dialog once, you might open and close it 7 times. (7 is a nice conspicuous prime number.) Then you can check the heap snapshot diff to see if any objects leaked 7 times. (Or 14 times, or 21 times.)

[![Screenshot of the Chrome DevTools heap snapshot diff showing six heap snapshot captures with several objects leaking 7 times](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-10-56-12-2.png?w=570&h=264)](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-10-56-12-2.png)

A heap snapshot diff. Note that we’re comparing snapshot #6 to snapshot #3, because I take three captures in a row to allow more garbage collection to occur. Also note that several objects are leaking 7 times.

(Another helpful technique is to run through the scenario once before recording the first snapshot. Especially if you are using a lot of code-splitting, then your scenario is likely to have a one-time memory cost of loading the necessary JavaScript modules.)

At this point, you might wonder why we should sort by the number of objects rather than the total memory. Intuitively, we’re trying to reduce the amount of memory leaking, so shouldn’t we focus on the total memory usage? Well, this doesn’t work very well, for an important reason.

When something is leaking, it’s because ([to paraphrase Joe Armstrong](https://www.johndcook.com/blog/2011/07/19/you-wanted-banana/)) you’re holding onto the banana, but you ended up getting the banana, the gorilla holding the banana, and the whole jungle. If you measure based on total bytes, you’re measuring the jungle, not the banana.

![Gorilla eating a banana](https://nolanwlawson.files.wordpress.com/2020/02/gorilla_eating_optimized.jpg?w=570&h=428)

Via [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Gorilla_Eating.jpg).

Let’s go back to the `addEventListener` example above. The source of the leak is an event listener, which is referencing a function, which references a component, which probably references a ton of stuff like arrays, strings, and objects.

If you sort the heap snapshot diff by total memory, then it’s going to show you a bunch of arrays, strings, and objects – most of which are probably unrelated to the leak. What you really want to find is the event listener, but this takes up a minuscule amount of memory compared to the stuff it’s referencing. To fix the leak, you want to find the banana, not the jungle.

So if you sort by the number of objects leaked, you’re going to see 7 event listeners. And maybe 7 components, and 14 sub-components, or something like that. That “7” should stand out like a sore thumb, since it’s such an unusual number. And no matter how many times you repeat the scenario, you should see exactly that number of objects leaking. This is how you can quickly find the source of the leak.

## Walking the retainer tree

The heap snapshot diff will also show you a “retainer” chain showing which objects are pointing to which other objects and thus keeping the memory alive. This is how you can figure out where the leaking object was allocated.

[![Screenshot of a retainer chain showing someObject referenced by a closure referenced by an event listener](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-10-56-12-3.png?w=570&h=111)](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-10-56-12-3.png)

The retainer chain shows you which object is referencing the leaked object. The way to read it is that each object is referenced by the object below it.

In the above example, there is a variable called `someObject` which is referenced by a closure (aka “context”), which is referenced by an event listener. If you click the source link, it will take you to the JavaScript declaration, which is fairly straightforward:

```js
class SomeObject () { /* ... */ }

const someObject = new SomeObject();
const onMessage = () => { /* ... */ };
window.addEventListener('message', onMessage);
```

In the above example, the “context” is the `onMessage` closure which references the `someObject` variable. (This is a [contrived example](https://github.com/nolanlawson/pinafore/commit/de6ca2d85334ad5f657ddd0f335750b60afab895); real memory leaks can be much less obvious!)

But the heap snapshotting tool has several limitations:

1. If you save and re-load the snapshot file, then you will lose all the file references to where the object was allocated. So for instance, you won’t see that the event listener’s closure comes from line 22 of `foo.js`. Since this is really critical information, it’s almost useless to save and send heap snapshot files.
2. If there are [`WeakMap`s](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap) involved, then Chrome will show you those references even though they don’t really matter – those objects would be de-allocated as soon as the other references are cleaned up. So they are just noise.
3. Chrome classifies the objects by their prototype. So the more you use actual classes/functions and the less you use anonymous objects, the easier it will be to see what exactly is leaking. As an example, imagine if our leak was somehow due to an `object` rather than an `EventListener`. Since `object` is extremely generic, we’re unlikely to see exactly 7 of them leaking.

This is my basic strategy for identifying memory leaks. I’ve successfully used this technique to find dozens of memory leaks in the past.

This guide is just the start, though – beyond this, you will also have to be handy with setting breakpoints, logging, and testing your fix to see if it resolves the leak. Unfortunately, this is just inherently a time-consuming process.

## Automated memory leak analysis

I’ll precede this by saying that I haven’t found a great way to automate the detection of memory leaks. Chrome has a non-standard [performance.memory](https://webplatform.github.io/docs/apis/timing/properties/memory/) API, but for privacy reasons [it doesn’t have a very precise granularity](https://bugs.webkit.org/show_bug.cgi?id=80444), so you can’t really use it in production to identify leaks. The [W3C Web Performance Working Group](https://github.com/w3c/web-performance) has discussed [memory](https://docs.google.com/document/d/1tFCEOMOUg4zmqeHNg1Xo11Xpdm7Bmxl5y98_ESLCLgM/edit) [tooling](https://github.com/WICG/memory-pressure) in the past, but has yet to agree on a new standard to replace this API.

In a lab or synthetic testing environment, you can increase the granularity on this API by using the Chrome flag [`--enable-precise-memory-info`](https://github.com/paulirish/memory-stats.js/blob/master/README.md). You can also create heap snapshot files by calling the proprietary Chromedriver command [`:takeHeapSnapshot`](https://webdriver.io/docs/api/chromium.html#takeheapsnapshot). This has the same limitation mentioned above, though – you probably want to take three in a row and discard the first two.

Since event listeners are the most common source of memory leaks, another technique that I’ve used is to monkey-patch the `addEventListener` and `removeEventListener` APIs to count the references and ensure they return to zero. Here is [an example](https://github.com/nolanlawson/pinafore/blob/2edbd4746dfb5a7c894cb8861cf315c800a16393/tests/spyDomListeners.js) of how to do that.

In the Chrome DevTools, you can also use the proprietary [`getEventListeners()`](https://developers.google.com/web/tools/chrome-devtools/console/utilities#geteventlisteners) API to see the event listeners attached to a particular element. Note that this can only be used in DevTools, though.

****Update:** Mathias Bynens has informed me of another useful DevTools API: [`queryObjects()`](https://developers.google.com/web/updates/2017/08/devtools-release-notes#query-objects), which can show you all objects created with a particular constructor. Christoph Guttandin also has [an interesting blog post](https://media-codings.com/articles/automatically-detect-memory-leaks-with-puppeteer) about using this API for automated memory leak detection in Puppeteer.**

## Summary

The state of finding and fixing memory leaks in web apps is still fairly rudimentary. In this blog post, I’ve covered some of the techniques that have worked for me, but admittedly this is still a difficult and time-consuming process.

As with most performance problems, an ounce of prevention can be worth a pound of cure. You might find it worthwhile to put synthetic testing in place rather than trying to debug a memory leak after the fact. Especially if there are several leaks on a page, it will probably turn into an onion-peeling exercise – you fix one leak, then find another, then repeat (while weeping the whole time!). Code review can also help catch common memory leak patterns, if you know what to look for.

JavaScript is a memory-safe language, so it’s somewhat ironic how easy it is to leak memory in a web application. Part of this is just inherent to UI design, though – we need to listen for mouse events, scroll events, keyboard events, etc., and these are all patterns that can easily lead to memory leaks. But by trying to keep our web applications’ memory usage low, we can improve runtime performance, avoid crashes, and be respectful of resource constraints on the user’s device.

**Thanks to Jake Archibald and Yang Guo for feedback on a draft of this post. And thanks to Dinko Bajric for inventing the “choose a prime number” technique, which I’ve found so helpful in memory leak analysis.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
