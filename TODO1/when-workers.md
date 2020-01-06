> * 原文地址：[When should you be using Web Workers?](https://dassur.ma/things/when-workers/)
> * 原文作者：[Surma](https://dassur.ma/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/when-workers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/when-workers.md)
> * 译者：
> * 校对者：

# When should you be using Web Workers?

You should always use Web Workers. And in our current landscape of frameworks it’s virtually impossible.

Did I get your attention with that? Good. Of course, as with any topic, there is nuance and I will lay that all out. But I have opinions, and they are important. Buckle up.

## The Performance Gap is widening

> **Note:** I hate the “emerging markets” terminology, but to makes this blog post intuitive to as many people as possible, I’ll be using it here.

Phones are getting faster. I don’t think anyone will disagree with that. Stronger GPUs, faster and more CPUs, more RAM. Phones are going through the same rapid development desktop machines did in the early 2000s.

![A graph showing the always increasing geekbench scores from iPhone 4 to iPhone X](https://dassur.ma/iphone-scores-89f089e4.svg)

Benchmark scores taken from [Geekbench](https://browser.geekbench.com/ios-benchmarks) (single-core).

However, that’s just one edge of the distribution. ****Slow** phones are stuck in 2014.** The process to create the chips from half a decade ago has gotten so cheap that phones can now be sold for around $20, and cheaper phone will reach a wider audience. ~50% of the world are online, meaning that the other ~50% are not. However, these offliners are **coming** online and are predominantly located in emerging markets, where people simply can’t afford any of the [Wealthy Western Web](https://www.smashingmagazine.com/2017/03/world-wide-web-not-wealthy-western-web-part-1/) flagship phones.

At Google I/O 2019, [Elizabeth Sweeny](https://twitter.com/egsweeny) and [Barb Palser](https://twitter.com/barb_palser) handed out Nokia 2 phones at a partner meeting and encouraged them to use it for a week to **really** get a feel for what class of device many people in the world use on a daily basis. The Nokia 2 is interesting because it looks and feels like a high-end phone but under the hood it is more like a smartphone from half a decade ago with a browser and an OS from today — and you can feel that mismatch.

To make things even more extreme, feature phones are making a comeback. Remember the phones that didn’t have a touch screen but instead come with number keys and a D-Pad? Yeah, those are coming back and now they run a browser. These phones have even weaker hardware but, maybe somewhat surprisingly, better performance. That’s partly because they have considerably less pixels to control. Or to say it another way: relative to the Nokia 2, they have more CPU power per pixel.

![A picture of Paul playing PROXX on the Nokia 8110](https://dassur.ma/banana-5c71e1f7.jpg)

The Nokia 8110, or “Banana phone”

While we are getting faster flagship phones every cycle, the vast majority of people can’t afford these. The more affordable phones are stuck in the past and have highly fluctuating performance metrics. These low-end phones will mostly likely be used by the massive number of people coming online in the next couple of years. **The gap between the fastest and the slowest phone is getting wider, and the median is going **down**.**

![A stacked bar graph showing the increasing portion occupied of low-end mobile users amongst all online users.](https://dassur.ma/demographic-4c15c204.svg)

The median of mobile phone performance is going down, the fraction of people using low-end mobile phones amongst all online users is going up. **This is not real data, just a visualization.** I heavily extrapolated from population growth data of the western world and emerging markets as well as making some educated guesses who owns high-end mobile phones.

## JavaScript is blocking

Maybe it’s worth spelling it out: The bad thing about long-running JavaScript is that it’s blocking. Nothing else can happen while JavaScript is running. **The main thread has other responsibilties in addition to running a web app’s JavaScript.** It also has to do page layout, paint, ship all those pixels to the screen in a timely fashion and look out for user interactions like clicking or scrolling. All of these can’t happen while JavaScript is running.

Browsers have shipped some mitigations for this, for example by moving the scrolling logic to a different thread under certain conditions. In general, however, if you block the main thread, your users will have a bad time. Like **bad**. They will be rage-tapping your buttons, they will be tortured by janky animations and potentially laggy scrolling.

## Human perception

How much blocking is too much blocking? [RAIL](https://developers.google.com/web/fundamentals/performance/rail) is one attempt at answering that question by providing you with time-based budgets for different tasks based on human perception. For example, you have ~16ms until the next frame needs to get rendered to make animations feel smooth to the human eye. **These numbers are fixed**, because human psychology doesn’t change depending on what device you are holding.

Looking at The Widening Performance Gap™️, this spells trouble. You can build your app, do your due diligence and do performance audits, fix all bottlenecks and hit all the marks. **But unless you are developing on the slowest low-end phone available, it is almost impossible to predict how long a piece of code will take on the slowest phone today, let alone the slowest phone tomorrow.**

That is the burden of the web with its unparalleled reach. You can’t predict what class of device your app will be running on. If you say “Surma, these underpowered devices are not relevant to me/my business!”, it strikes me as awfully similar to “People who rely on screenreaders are not relevant to me/my business!”. **It’s a matter of inclusivity. I encourage you to **really** think if you are excluding people by not supporting low-end phones.** We should strive to allow every person to have access to the world’s information, and your app is part of that, whether you like it or not.

That being said, a blog post like this can never give guidance that applies to everyone, because there is always nuance and context. This applies to the paragraph above as well. I won’t pretend that either accessibility or writing for low-end phones is easy, but I do believe that there is a lot of things we can do as a community of tooling and framework authors to set people up the right way, to make their work more accessible and more performant by default, which will also make it more inclusive by default.

## Fixing it

Here we are, trying to build castles in the shifting sands. Trying to build apps that stay within the RAIL time budgets, but for a vast variety of devices where the duration for a piece of code is practically unpredictable.

### Being cooperative

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
