> * 原文地址：[For the Sake of Your Event Listeners, Use Web Workers](https://macarthur.me/posts/use-web-workers-for-your-event-listeners)
> * 原文作者：[Alex MacArthur](https://macarthur.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/use-web-workers-for-your-event-listeners.md](https://github.com/xitu/gold-miner/blob/master/TODO1/use-web-workers-for-your-event-listeners.md)
> * 译者：
> * 校对者：

# For the Sake of Your Event Listeners, Use Web Workers

I’ve been tinkering with the [Web Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers) lately, and as a result, I’m really feeling the guilt of not looking into this well-supported tool a lot sooner. Modern web applications are seriously upping demands on the browser’s main thread, impacting performance and the ability to deliver smooth user experiences. This tool is just one way to address the challenge.

## Where Things on(‘click’)ed for Me

The advantages of Web Workers are many, but things really clicked for me when it came to the several DOM event listeners in any given application (form submissions, window resizes, button clicks, etc.) These all necessarily live on the browser’s main thread, and if that thread is congested by a long-running process, the responsiveness of those listeners begins to suffer, stalling the entire application until the event loop is free to continue firing.

Admittedly, the reason listeners stick out to me so much is due to my initial misunderstanding about the problems Workers are meant to solve. At first, I thought it was mainly about the **speed** of my code execution, start to finish. “If I can do more on separate threads in parallel, my code will execute so much more quickly!” But! It’s pretty common to **need** to wait for one thing to happen before another can start, like when you don’t want to update the DOM until some sort of calculation has taken place. “If I’m gonna have to wait anyway, I don’t see the point of moving something into a separate thread,” naive me thought.

Here’s the type of code that came to mind:

```javascript
const calculateResultsButton = document.getElementById('calculateResultsButton');
const openMenuButton = document.getElementById('#openMenuButton');
const resultBox = document.getElementById('resultBox');

calculateResultsButton.addEventListener('click', (e) => {
    // "Why put this into a Worker when I 
    // can't update the DOM until it's done anyway?"
    const result = performLongRunningCalculation();
    resultBox.innerText = result;
});

openMenuButton.addEventListener('click', (e) => {
    // Do stuff to open menu. 
});
```

Here, I update the text of a box after performing some sort of presumably heavy calculation. Doing these things in parallel would be pointless (the DOM update necessarily depends on the calculation), so **of course** I want everything to be synchronous. What I didn’t initially understand was that **none of the **other** listeners can fire if the thread is blocked**. Meaning: things get janky.

## The Jank, Illustrated

In the example below, clicking “Freeze” will kick off a synchronous pause for three seconds (simulating a long-running calculation) before incrementing the click count, and the “Increment” button will increment that count immediately. During the first button’s pause, the whole thread is at a standstill, preventing **any** other main thread activities from firing until the event loop can turn over again.

To witness this, click the first button and immediately click the second.

See the Pen <a href='https://codepen.io/alexmacarthur/pen/XWWKyGe'>Event Blocking - No Worker</a> by Alex MacArthur (<a href='https://codepen.io/alexmacarthur'>@alexmacarthur</a>) on <a href='https://codepen.io'>CodePen</a>.

Frozen, because that long, synchronous pause is blocking the thread. And the impact goes beyond that. Do it again, but this time, immediately try to resize the blue-bordered box after clicking “Freeze.” Since the main thread is also where all layout changes and repainting occur, you’re yet again stuck until the timer is complete.

## They’re Listening More Than You Think

Any normal user would be annoyed to have to deal with an experience like this — and we were only dealing with a couple of event listeners. In the real world, though, there’s a lot more going on. Using Chrome’s `getEventListeners` method, I used the following script to take a tally of all event listeners attached to every DOM element on a page. Drop it into the inspector, and it’ll spit back a total.

```javascript
Array
  .from([document, ...document.querySelectorAll('*')])
  .reduce((accumulator, node) => {
    let listeners = getEventListeners(node);
    for (let property in listeners) {
      accumulator = accumulator + listeners[property].length
    }
    return accumulator;
  }, 0);
```

I ran it on an arbitrary page within each of the following applications to get a quick count of the active listeners.

| Application     | Number of Listeners |
| --------------- | ------------------- |
| Dropbox         | 602                 |
| Google Messages | 581                 |
| Reddit          | 692                 |
| YouTube         | 6,054 (!!!)         |

Pay little attention to the specific numbers. The point is that the numbers are big, and **if even a single long-running process in your application goes awry, **all** of these listeners will be unresponsive.** That’s a lot of opportunity to frustrate your users.

## Same Illustration, but Less Jank (Thx, Web Workers!)

With all that in mind, let’s upgrade the example from before. Same idea, but this time, that long-running operation has been moved into its own thread. Performing the same clicks again, you’ll see that clicking “Freeze” still delays the click count from being updated for 3 seconds, but it **doesn’t block any other event listeners on the page**. Instead, other buttons still click and boxes still resize, which is exactly what we want.

See the Pen <a href='https://codepen.io/alexmacarthur/pen/qBEORdO'>Event Blocking - Worker</a> by Alex MacArthur (<a href='https://codepen.io/alexmacarthur'>@alexmacarthur</a>) on <a href='https://codepen.io'>CodePen</a>.

If you dig into that code a bit, you’ll notice that while the Web Worker API could be a little more ergonomic, it really isn’t as scary as you might expect (a lot of that scariness is due to the way I quickly threw the example together). And to make things even **less** scary, there are some good tools out there to ease their implementation. Here are a few that caught my eye:

* [workerize](https://github.com/developit/workerize) — run a module inside a Web Worker
* [greenlet](https://github.com/developit/greenlet) — run an arbitrary piece of async code inside a worker
* [comlink](https://github.com/GoogleChromeLabs/comlink) — a friendly layer of abstraction over the Web Worker API

## Start Threadin’ (Where It Makes Sense)

If your application is typical, it probably has a lot of listenin’ going on. And it also probably does a lot of computing that just doesn’t need to happen on the main thread. So, do these listeners and your users a favor by considering where it makes sense to employ Web Workers.

To be clear, going all-in and throwing literally **all** non-UI work into worker threads is probably the wrong approach. You might just be introducing a lot of refactoring & complexity to your app for little gain. Instead, maybe start by identifying notably intense processes and spin up a small Web Worker for them. Over time, it could make sense to stick your feet in a little deeper and rethink your UI/Worker architecture more at a wider scale.

Whatever the case, dig into it. With their solid browser support and the growing performance demands of modern applications, we’re running out of reasons to not invest in tools like this.

Happy threadin’!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
