> * 原文地址：[When should you be using Web Workers?](https://dassur.ma/things/when-workers/)
> * 原文作者：[Surma](https://dassur.ma/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/when-workers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/when-workers.md)
> * 译者：[weibinzhu](https://github.com/weibinzhu)
> * 校对者：

# 在什么时候需要使用 Web Workers？

你应该在什么时候都使用 Web Workers。 与此同时在我们当前的框架世界中，这几乎不可能。

我这么说吸引到你的注意吗？ 很好。 当然对于任何一个主题，都会有其精妙之处，我会将他们都展示出来。 但我会有自己的观点，并且它们很重要。 系紧你的安全带，我们马上出发。

## 性能差异正在扩大

> **注意：** 我讨厌“新兴市场”这个词， 但是为了让这篇博客尽可能地通俗易懂，我会在这里使用它。

手机正变得越来越快。 我想不会有人不同意。更强大的 GPU，更快并且更多的 CPU，更多的 RAM。手机正经历与 2000 年代早期桌面计算机经历过的一样的快速发展时期。

![图片展示了从 iPhone 4 到 iPhone X 的不断上涨的 geekbench 分数](https://dassur.ma/iphone-scores-89f089e4.svg)

从 [Geekbench](https://browser.geekbench.com/ios-benchmarks) 获得的基准测试分数（单核）。

然而，这仅仅是真实情况的其中一个部分。 ****低阶的** 的手机还留在 2014 年。** 用于制作 5 年前的芯片的流程已经变得非常便宜，以至于手机能够以大约 20 美元的价格卖出，同时便宜的手机能吸引更广的人群。 全世界大约有 50% 的人能接触到网络，同时也意味着还有大约 50% 的人没有。 然而， 这些还没上网的人也**正在**去上网的路上并且主要是在新兴市场， 那里的人买不起 [有钱的西方网络（Wealthy Western Web）](https://www.smashingmagazine.com/2017/03/world-wide-web-not-wealthy-western-web-part-1/) 的旗舰手机。

在 Google I/O 2019 大会期间， [Elizabeth Sweeny](https://twitter.com/egsweeny) 与 [Barb Palser](https://twitter.com/barb_palser) 在一个合作伙伴会议上拿出了 Nokia 2 并鼓励合作伙伴去使用它一个星期，去**真正**感受一下这个世界上很多人日常是在用什么级别的设备。 Nokia 2 是很有意思的，因为它看起来有一种高端手机的感觉但是在外表下面它更像是一台有着今天的浏览器和操作系统的来自 5 年前的智能手机 —— 你能感受到这份不协调。

让事情变得更加极端的是，功能手机正在回归。记得哪些没有触摸屏，相反有着数字键和十字键的手机吗？是的，它们正在回归并且现在它们运行着一个浏览器。 这些手机有着更弱的硬件，但令人惊讶的是，也有着更好的性能。部分原因是它们只需要控制更少的像素。或者换另一种说法，对比 Nodia 2，它们有更高的 CPU 性能 - 像素比。

![一张保罗正在使用 Nokia 8110 玩 PROXX 的照片](https://dassur.ma/banana-5c71e1f7.jpg)

Nokia 8110， 或者说“香蕉手机”

当我们每个周期都能拿到更快的旗舰手机的同时，大部分人负担不起这些手机。更便宜的手机还留在过去并有着高度波动的性能指标。在接下来的几年里，这些低端手机更有可能被大量的人民用来上网。 **最快的手机与最慢的手机之间的差距正在变大， 中位数在 **减少**。**

![一个堆叠柱状图展示了低端手机用户占所有手机用户的比例在不断增加。](https://dassur.ma/demographic-4c15c204.svg)

手机性能的中位数在降低，人们使用低端手机的比例则在升高。 **这不是一个真实的数据，只是为了直观展现。** 我是根据西方世界和新兴市场的人口增长数据以及对谁会拥有高端手机的猜测推断出来的。

## JavaScript 是阻塞的

也许值得解释清楚：长时间运行的 JavaScript 的缺点就是它是阻塞的。JavaScript 在运行的时候没有别的事情可以做。 **除了运行一个网页应用的 JavaScript 以外，主线程还有别的指责。** 它也需要渲染页面，在恰当的时候将所有像素展示在屏幕上，并且监听诸如点击或者滑动这样的用户交互。 在 JavaScript 运行的时候这些都不能发生。

浏览器已经对此做了一些缓解措施，例如在某些情况下会把滚动逻辑放到不同的线程。不过整体而言，如果你阻塞了主线程，那么你的用户将会有**很差**的体验。他们会愤怒地点击你的按钮，被卡顿的动画与滚动所折磨。

## 人类的感知

多少的阻塞才算过多的阻塞？[RAIL](https://developers.google.com/web/fundamentals/performance/rail)通过给不同的任务提供基于人类感知的时间预算来尝试回答这个问题。比如说，为了让人眼感到动画流畅，在下一帧被渲染之前你要有大约 16 毫秒的间隔。**这些数字是固定的**，因为人类心理学不会因为你所拿着的设备而改变。

看一下 The Widening Performance Gap™️。你可以构建你的 app，做你的尽职调查以及性能分析，解决所有的瓶颈并达成所有目标。**但是除非你是在最低端的手机上开发，不然是无法预测一段代码在如今最低端手机上要运行多久，更不要说未来的最低端手机。**

这就是由不一样的水平带给 web 的负担。你无法预测你的 app 将会运行在什么级别的设备上。你可以说“Sura，这些性能低下的手机与我/我的生意无关！”，但对我来讲，这如同“那些依赖屏幕阅读器的人与我/我的生意无关！”一样的恶心。**这是一个包容性的问题。我建议你 **仔细** 想想，是否正在通过不支持低端手机来排除掉某些人群。**我们应该努力使每一个人都能获取到这个世界的信息，而不管喜不喜欢，你的 app 正是其中的一部分。

话虽如此，由于涉及到很多术语和背景知识，本博客无法给所有人提供指导。上面的那些段落也一样。我不会假装无障碍访问或者给低端手机编程是一件容易的事，但我相信作为一个工具社区和框架作者还是有很多事情可以去做，去以正确的方式帮助人们，让他们的成果默认就更具无障碍性并且性能更好，默认就更加包容。

## 解决它

好了，尝试从沙子开始建造城堡。尝试去制作那些能在各种各样的，你都无法预测一段在代码在上面需要运行多久的设备上都能保持符合 RAIL 的时间预算的 app。

### 共同合作

一个解决阻塞的方式是“分割你的 JavaScript”或者说是“让渡给浏览器”。意思是通过在代码添加一些固定时间间隔的**断点**来给浏览器一个暂停运行你的 JavaScript 的机会
One technique to diminish blocking is “chunking your JavaScript” or “yielding to the browser”. What this means is adding **breakpoints** to your code at regular intervals which give the browser a chance to stop running your JavaScript and ship a new frame or process an input event. Once the browser is done, it will go back to running your code. The way to yield to the browser on the web platform is to schedule a task, which can be done in a variety of ways.

> **Required reading:** If you are not familiar with tasks and/or the difference between a task and a microtask, I recommend [Jake Archibald](https://twitter.com/jaffathecake)’s [Event Loop Talk](https://www.youtube.com/watch?v=cCOL7MC4Pl0).

In PROXX, we used a `MessageChannel` and use `postMessage()` to schedule a task. To keep the code readable when adding breakpoints, I strongly recommend using `async`/`await`. Here’s what we actually shipped in [PROXX](https://proxx.app), where we generate sprites in the background while the user is interacting with the home screen of the game.

```js
const { port1, port2 } = new MessageChannel();
port2.start();

export function task() {
  return new Promise(resolve => {
    const uid = Math.random();
    port2.addEventListener("message", function f(ev) {
      if (ev.data !== uid) {
        return;
      }
      port2.removeEventListener("message", f);
      resolve();
    });
    port1.postMessage(uid);
  });
}

export async function generateTextures() {
  // ...
  for (let frame = 0; frame < numSprites; frame++) {
    drawTexture(frame, ctx);
    await task(); // Breakpoint!
  }
  // ...
}
```

But **chunking still suffers from the influence of The Widening Performance Gap™️**: The time a piece of code takes to reach the next break point is inherently device-dependent. What takes less than 16ms on one low-end phone, might take considerably more time on another low-end phone.

## Off the main thread

I said before that the main thread has other responsibilities in addition to running a web app’s JavaScript, and that’s the reason why we need to avoid long, blocking JavaScript on the main thread at all costs. But what if we moved most of our JavaScript to a thread that is **dedicated** to run our JavaScript and nothing else. A thread with no other responsibilities. In such a setting we wouldn’t have to worry about our code being affect by The Widening Performance Gap™️ as the main thread is unaffected and still able to respond to user input and keep the frame rate stable.

### What are Web Workers again?

**[Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Worker), also called “Dedicated Workers”, are JavaScript’s take on threads.** JavaScript engines have been built with the assumption that there is a single thread, and consequently there is no concurrent access JavaScript object memory, which absolves the need for any synchronization mechanism. If regular threads with their shared memory model got added to JavaScript it would be disastrous to say the least. Instead, we have been given [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Worker), which are basically an entire JavaScript scope running on a separate thread, without any shared memory or shared values. To make these completely separated and isolated JavaScript scopes work together you have [`postMessage()`](https://developer.mozilla.org/en-US/docs/Web/API/Worker/postMessage), which allows you to trigger a `message` event in the **other** JavaScript scope together with the copy of a value you provide (copied using the [structured clone algorithm](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm)).

So far, Workers have seen practically no adoption, apart from a few “slam dunk” use-cases, which usually involve long-running number crunching tasks. I think that should change. **We should start using workers. A lot.**

### All the cool kids are doing it

This is not novel idea. At all. Quite the opposite, actually. **Most native platforms call the main thread the UI thread, as it should **only** be used for UI work,** and they give you the tools to achieve that. Android has had [`AsyncTask`](https://developer.android.com/reference/android/os/AsyncTask) since it’s earliest versions and has added more convenient APIs since then (most recently [Coroutines](https://kotlinlang.org/docs/reference/coroutines/basics.html), which can be easily scheduled on different threads). If you opt-in to [“Strict mode”](https://developer.android.com/reference/android/os/StrictMode), certain APIs — like file operations — will crash your app when used on the UI thread, helping you notice when you are doing non-UI work on the UI thread.

iOS has had [Grand Central Dispatch](https://developer.apple.com/documentation/dispatch) (“GCD”) from the very start to schedule work on different, system-provided thread pools, including the UI thread. This way they are enforcing both patterns: You always have to chunk your work into tasks so that it can be put in a queue, allowing the UI thread to attend to its other responsibilities whenever necessary, but also allowing you to run non-UI work on a different thread simply by putting the task into a different queue. As a cherry on top, tasks can be assigned a priority which helps to ensure that time-critical work is done as soon as possible without sacrifcing the responsiveness of the system as a whole.

The point is that these native platforms have had support for utilizing non-UI threads since their inception. I think it’s fair to say that, over time, they have proven that this is a Good Idea™️. Keeping work on the UI thread to a minimum helps your app to stay responsive. Why hasn’t this pattern been adopted on the web?

## Developer Experience as a hurdle

The only primitive we have for threading on the web are Web Workers. When you start using Workers with the API they provide, the `message` event handler becomes the center of your universe. That doesn’t feel great. Additionally, Workers are **like** threads, but they are not the same as threads. You can’t have multiple threads access the same variable (like a state object) as everything needs to go via messages and these messages can carry many but not all JavaScript values. For example: you can’t send an `Event`, or any class instances without data loss. This, I think, has been a major deterrant for developers.

### Comlink

For this exact reason I wrote [Comlink](https://github.com/GoogleChromeLabs/comlink), which not only hides `postMessage()` from you, but also the fact that you are working with Workers in the first place. It **feels** like you have shared access to variables from other threads:

```js
// main.js
import * as Comlink from "https://unpkg.com/comlink?module";

const worker = new Worker("worker.js");
// This `state` variable actually lives in the worker!
const state = await Comlink.wrap(worker);
await state.inc();
console.log(await state.currentCount);
```

```js
// worker.js
import * as Comlink from "https://unpkg.com/comlink?module";

const state = {
  currentCount: 0,

  inc() {
    this.currentCount++;
  }
}

Comlink.expose(state);
```

> **Note:** I’m using top-level await and modules-in-workers here to keep the sample short. See [Comlink’s repository](https://github.com/GoogleChromeLabs/comlink) for real-life examples and more details.

Comlink is not the only solution in this problem space, it’s just the one I’m most familiar with (unsurprising, considering that I wrote it 🙄). If you want to look at some different approaches, take a look at [Andrea Giammarchi’s](https://twitter.com/webreflection) [workway](https://github.com/WebReflection/workway) or [Jason Miller’s](https://twitter.com/_developit) [workerize](https://github.com/developit/workerize).

I don’t care which library you use, as long as you end up switching to an off-main-thread architecture. We have used Comlink to great success in both [PROXX](https://proxx.app) and [Squoosh](https://squoosh.app), as it is small (1.2KiB gzip’d) and allowed us to use many of the common patterns from languages with “real” threads without notable development overhead.

### Actors

I evaluated another approach recently together with [Paul Lewis](https://twitter.com/aerotwist). Instead of hiding the fact that you are using Workers and `postMessage`, we took some inspiration from the 70s and used [the Actor Model](https://dassur.ma/things/actormodel/), an architecture that **embraces** message passing as its fundamental building block. Out of that thought experiment, we built a [support library for actors](https://github.com/PolymerLabs/actor-helpers), a [starter kit](https://github.com/PolymerLabs/actor-boilerplate) and gave [a talk](https://www.youtube.com/watch?v=Vg60lf92EkM) at Chrome Dev Summit 2018, explaining the architecture and its implications.

## “Benchmarking”

Some of you are probably wondering: **is it worth the effort to adopt an off-main-thread architecture?** Let’s tackle with a cost/benefit analysis: With a library like [Comlink](https://github.com/GoogleChromeLabs/comlink), the cost of switching to an off-main-thread architecture should be significantly lower than before, getting close to zero. What about benefit?

[Dion Almaer](https://twitter.com/dalmaer) asked me to write a version of [PROXX](https://proxx.app) where everything runs on the main thread, probably to clear up that very question. And so [I did](https://github.com/GoogleChromeLabs/proxx/pull/437). On a Pixel 3 or a MacBook, the difference is only rarely noticeable. Playing it on the Nokia 2, however, shows a a night-and-day difference. **With everything on the main thread, the app is frozen for up to 6.6 seconds** in the worst case scenario. And there are less powerful devices in circulation than the Nokia 2! Running the live version of PROXX using an off-main-thread architecture, the task that runs the `tap` event handler only takes 48ms, because all it does is calling `postMessage()` to send a message to the worker. What this shows is that, especially with respect to The Widening Performance Gap™️, **off-main-thread architectures increase resilience against unexpectedly large or long tasks**.

![A trace of PROXX running with an off-main-thread architecture.](https://dassur.ma/trace-omt-bb7bc9f7.png)

PROXX’ event handler are lean and are only used to send a message to a dedicated worker. All in all the task takes 48ms.

![A trace of PROXX running with everything on the main thread.](https://dassur.ma/trace-nonomt-0d7f2457.png)

In a branch of PROXX, everything runs on the main thread, making the task for the event handler take over 6 seconds.

It’s important to note that the work doesn’t just disappear. With an off-main-thread architecture, the code still takes ~6s to run (in the case of PROXX it’s actually significantly longer). However, since that work is now happening in a different thread the UI thread stays responsive. Our worker is also sends intermediate results back to the main thread. **By keeping the event handlers lean we ensured that the UI thread stays free and can update the visuals.**

## The Framework Quandary

Now for my juicy hot take: **Our current generation of frameworks makes off-main-thread architectures hard and diminishes its returns.** UI frameworks are supposed to do UI work and therefore have the right to run on the UI thread. In reality, however, the work they are doing is a mixture of UI work and other related, but ultimately non-UI work.

Let’s take VDOM diffing as an example: The purpose of a virtual DOM is to decouple costly updates to the real DOM from what the developers does. The virtual DOM is just a data structure mirroring the real DOM, where changes don’t have any costly side-effects. Only when the framework deems it appropriate, will the changes to the virtual DOM be replayed against the real DOM. This is often called “flushing”. Everything up until flushing has absolutely no requirement to run on the UI thread. Yet it is, wasting your precious UI thread budget. On [PROXX](https://proxx.app) we actually [opted out of VDOM diffing](https://github.com/GoogleChromeLabs/proxx/blob/94b08d0b410493e2867ff870dee1441690a00700/src/services/preact-canvas/components/board/index.tsx#L116-L118) and implemented the DOM manipulations ourselves, because the phones at the lower end of the spectrum couldn’t cope with the amount of diffing work.

VDOM diffing is just one of many examples of a framework choosing developer experience or simplicity of implementation over being frugal with their end-user’s resources. Unless a globally launched framework labels itself as exclusively targeting the users of the [Wealthy Western Web](https://www.smashingmagazine.com/2017/03/world-wide-web-not-wealthy-western-web-part-1/), **it has a responsibility to help developers target every phone on The Widening Performance Gap™️ spectrum.**

## Conclusion

Web Workers help your app run on a wider range of devices. Libraries like [Comlink](https://github.com/GoogleChromeLabs/comlink) help you utilize workers without losing convenience and development velocity. I think **we should question why every platform **but the web** is fighting for the UI thread to be as free as possible**. We need to shift our default approach and help shape the next generation of frameworks.

---

Special thanks to [Jose Alcérreca](https://twitter.com/ppvi) and [Moritz Lang](https://twitter.com/slashmodev) for helping me understand how native platforms are handling this problem space.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
