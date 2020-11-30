> * 原文地址：[Page Lifecycle API: A Browser API Every Frontend Developer Should Know](https://blog.bitsrc.io/page-lifecycle-api-a-browser-api-every-frontend-developer-should-know-b1c74948bd74)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/page-lifecycle-api-a-browser-api-every-frontend-developer-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2020/page-lifecycle-api-a-browser-api-every-frontend-developer-should-know.md)
> * 译者：
> * 校对者：

# Page Lifecycle API: A Browser API Every Frontend Developer Should Know

![Photo by [Jeremy Perkins](https://unsplash.com/@jeremyperkins?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11120/0*s7XvAqERxLnWWPbS)

As users, we always like to multi-task while browsing web pages. So it’s common to have several browser tabs open as it helps to get things done in parallel. However, at the same time, each of these tabs consumes system resources like memory and CPU.

Since it’s impossible to limit users from opening new browser tabs and leaving them behind, browsers have taken several measures to deallocate resources when the browser tabs aren’t active.

> Modern browsers today will sometimes suspend pages or discard them entirely when system resources are constrained — Philip Walton

#### So you might wonder why we need to worry about this, as it is taken care of by the browser?

It is not entirely true that the browser takes care of everything. Besides, these browser interventions have a direct impact on JavaScript execution. The good news is, almost all the modern browsers expose these interventions as events via the Page Lifecycle API.

## Page Lifecycle API

As the name suggests, the Page Lifecycle API exposes the web page lifecycle hooks to JavaScript. However, it isn’t an entirely new concept. [Page Visibility API](https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API) existed for some time, revealing some of the page visibility events to JavaScript.

However, if you happen to choose between these two, it’s worth mentioning some of the limitations of the Page Visibility API.

* It only provides visible and hidden states of a web page.
* It can not capture pages discarded by the operating system (Android, IOS, and the latest Windows systems can terminated background processes to preserve system resources).

Let’s take a look at the page lifecycle states exposed by the Page Lifecycle API.

## Page Lifecycle API States

There are six states introduced in the API. Out of them, two states are quite relevant to us.

* **FROZEN** — Lifecycle state for CPU suspension (Hidden pages will be frozen to conserve resources).

If a webpage has been hidden for a long time and the user does not close the page, the browser will freeze it and move the page into this state. However, the running tasks will continue until completed. But timers, callback function executions, and DOM operations will be stopped to release the CPU.

![Chrome Resource consumption](https://cdn-images-1.medium.com/max/2202/1*9XvnVKo4Z5YoFrJJZF6aHQ.png)

> # When I look at the Chrome Browser resource consumption on my PC, I observed that the two active tabs consume 14.7% and 11% of the CPU while the Frozen ones consume nearly 0%.

* **DISCARDED** — Frozen frames are moved to the Discarded state to conserve resources.

Suppose a webpage is in a frozen state for a long time. In that case, the browser will automatically unload the page into the discarded state, releasing some memory. And If the user re-visits a discarded page, the browser will reload the page to return to the Active State.

> It’s worth noticing that the users will typically experience the discarded state in devices with resource constraints.

Apart from the above two states, there are four other states introduced in the API as,

* **ACTIVE** — Page is visible and has input focus.
* **PASSIVE** — Page is visible but doesn’t have input focus.
* **HIDDEN** — Page is not visible (Not frozen either).
* **TERMINATED** — Page is unloaded and cleared from memory.

You can find the lifecycle states and the transition in detail by looking at the following diagram.

![Page Lifecycle API States and Transition](https://cdn-images-1.medium.com/max/2860/1*3NsVfS6gu7r39LRewVfKOQ.png)

## How to Respond to the Lifecycle States

Now that we understand the Page Lifecycle API, let’s see how we can respond to each event.

> The most important thing here is identifying what needs to remain and what needs to be stopped when the application reaches each state.

* **Active State** — Since the user is fully active on the page, your webpage should be fully responsive to user inputs. Any UI blocking tasks should be de-prioritized, such as synchronous and blocking network requests.
* **Passive State** — Even though the user does not interact with the page at this stage, they can still see it. Therefore your webpage should run all UI updates and animations smoothly.
* **Hidden State** — The hidden state should be treated as the end of a user’s session on the webpage. You can persist unsaved application state at this point and stop any UI updates or tasks that the user would not require to be running in the background.
* **Frozen State** — Any timers and connections that could affect other tabs should be terminated at this stage. For example, you should close all open IndexedDB connections, any open Web Socket connections, release any web locks being held, etc.
* **Terminated State** — Since the session ending logic is handled in the hidden state, no action is generally required.
* **Discarded State** — This state is not observable by applications. Therefore any preparation for a possible discard should happen in the hidden or frozen states. However, you can react to any restoration of the page at page load time by checking, `document.wasDiscarded` .

---

Okay, so now that we know what to be done at each state, let’s see how we can capture each state within our applications.

## How to Capture Lifecycle States in Your Code

You can use the following JavaScript function to determine the Active, Passive, and Hidden states of a given page.

```js
const getState = () => {
  if (document.visibilityState === 'hidden') {
    return 'hidden';
  }
  if (document.hasFocus()) {
    return 'active';
  }
  return 'passive';
};
```

With the release of Chrome 68, developers can observe when a hidden tab is frozen and unfrozen by listening to the `freeze` and `resume` events on `document` object.

```js
document.addEventListener('freeze', (event) => {
  // The page is now frozen.
});

document.addEventListener('resume', (event) => {
  // The page has been unfrozen.
});
```

To determine whether a page is discarded while in a hidden tab, the following code can be used.

```js
if (document.wasDiscarded) {
// Page was previously discarded by the browser while in a hidden tab.
} 
```

The `wasDiscarded` property mentioned above can be observed at the page load time.

## Browser Compatibility

Some of the older browsers do not have the capability to detect when its web pages are frozen or discarded. However, with the release of Chrome 68, the ability to predict the next state of the page has also been included.

#### Known Compatibility Issues

* Some browsers do not fire the `blur` event when switching tabs, which avoids the page going into a passive state.
* Older versions of IE (10 and below) do not implement the `visibilityChange` event.
* Safari does not fire the `pagehide` or `visibilitychange` events when closing a tab in a reliable manner

To overcome cross-browser incompatibilities, Google has developed a library called [Pagelifecycle.js](https://github.com/GoogleChromeLabs/page-lifecycle) as a polyfill for the following browsers.

![Source: [Github](https://github.com/GoogleChromeLabs/page-lifecycle#usage)](https://cdn-images-1.medium.com/max/2000/1*G7Kr9wxsOUkiahryW7y43w.png)

## Summary

Web pages shouldn’t consume excessive resources while the user is not actively engaging. Besides your applications should also aware of the management tasks performed by the system. The Page Lifecycle API introduces a simple way to make your application aware of these events.

---

Although it is relevant more for the advanced use cases, we could develop efficient web applications by knowing its capabilities. As a result, we could provide a better experience to the end-users.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
