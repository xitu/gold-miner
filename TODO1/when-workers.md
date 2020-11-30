> * 原文地址：[When should you be using Web Workers?](https://dassur.ma/things/when-workers/)
> * 原文作者：[Surma](https://dassur.ma/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/when-workers.md](https://github.com/xitu/gold-miner/blob/master/TODO1/when-workers.md)
> * 译者：[weibinzhu](https://github.com/weibinzhu)
> * 校对者：[ahabhgk](https://github.com/ahabhgk)，[febrainqu](https://github.com/febrainqu)

# 在什么时候需要使用 Web Workers？

你应该在什么时候都使用 Web Workers。与此同时在我们当前的框架世界中，这几乎不可能。

我这么说吸引到你的注意吗？很好。当然对于任何一个主题，都会有其精妙之处，我会将他们都展示出来。但我会有自己的观点，并且它们很重要。系紧你的安全带，我们马上出发。

## 性能差异正在扩大

> **注意：** 我讨厌“新兴市场”这个词，但是为了让这篇博客尽可能地通俗易懂，我会在这里使用它。

手机正变得越来越快。我想不会有人不同意。更强大的 GPU，更快并且更多的 CPU，更多的 RAM。手机正经历与 2000 年代早期桌面计算机经历过的一样的快速发展时期。

![图片展示了从 iPhone 4 到 iPhone X 的不断上涨的 geekbench 分数](https://dassur.ma/iphone-scores-89f089e4.svg)

从 [Geekbench](https://browser.geekbench.com/ios-benchmarks) 获得的基准测试分数（单核）。

然而，这仅仅是真实情况的其中一个部分。**低阶的手机还留在 2014 年。**用于制作 5 年前的芯片的流程已经变得非常便宜，以至于手机能够以大约 20 美元的价格卖出，同时便宜的手机能吸引更广的人群。全世界大约有 50% 的人能接触到网络，同时也意味着还有大约 50% 的人没有。然而，这些还没上网的人也**正在**去上网的路上并且主要是在新兴市场，那里的人买不起[有钱的西方网络（Wealthy Western Web）](https://www.smashingmagazine.com/2017/03/world-wide-web-not-wealthy-western-web-part-1/)的旗舰手机。

在 Google I/O 2019 大会期间，[Elizabeth Sweeny](https://twitter.com/egsweeny) 与 [Barb Palser](https://twitter.com/barb_palser) 在一个合作伙伴会议上拿出了 Nokia 2 并鼓励合作伙伴去使用它一个星期，去**真正**感受一下这个世界上很多人日常是在用什么级别的设备。Nokia 2 是很有意思的，因为它看起来有一种高端手机的感觉但是在外表下面它更像是一台有着现代浏览器和操作系统的 5 年前的智能手机 —— 你能感受到这份不协调。

让事情变得更加极端的是，功能手机正在回归。记得哪些没有触摸屏，相反有着数字键和十字键的手机吗？是的，它们正在回归并且现在它们运行着一个浏览器。这些手机有着更弱的硬件，也许有些奇怪，却有着更好的性能。部分原因是它们只需要控制更少的像素。或者换另一种说法，对比 Nodia 2，它们有更高的 CPU 性能 - 像素比。

![一张保罗正在使用 Nokia 8110 玩 PROXX 的照片](https://dassur.ma/banana-5c71e1f7.jpg)

Nokia 8110，或者说“香蕉手机”

虽然我们每个周期都能拿到更快的旗舰手机，但是大部分人负担不起这些手机。更便宜的手机还留在过去并有着高度波动的性能指标。在接下来的几年里，这些低端手机更有可能被大量的人民用来上网。**最快的手机与最慢的手机之间的差距正在变大，中位数在减少。**

![一个堆叠柱状图展示了低端手机用户占所有手机用户的比例在不断增加。](https://dassur.ma/demographic-4c15c204.svg)

手机性能的中位数在降低，所有上网用户中使用低端手机的比例则在上升。**这不是一个真实的数据，只是为了直观展现。**我是根据西方世界和新兴市场的人口增长数据以及对谁会拥有高端手机的猜测推断出来的。

## JavaScript 是阻塞的

也许有必要解释清楚：长时间运行的 JavaScript 的缺点就是它是阻塞的。当 JavaScript 在运行时，不能去做任何其他事情。**除了运行一个网页应用的 JavaScript 以外，主线程还有别的指责。**它也需要渲染页面，及时将所有像素展示在屏幕上，并且监听诸如点击或者滑动这样的用户交互。在 JavaScript 运行的时候这些都不能发生。

浏览器已经对此做了一些缓解措施，例如在特定情况下会把滚动逻辑放到不同的线程。不过整体而言，如果你阻塞了主线程，那么你的用户将会有**很差**的体验。他们会愤怒地点击你的按钮，被卡顿的动画与滚动所折磨。

## 人类的感知

多少的阻塞才算过多的阻塞？[RAIL](https://developers.google.com/web/fundamentals/performance/rail) 通过给不同的任务提供基于人类感知的时间预算来尝试回答这个问题。比如说，为了让人眼感到动画流畅，在下一帧被渲染之前你要有大约 16 毫秒的间隔。**这些数字是固定的**，因为人类心理学不会因为你所拿着的设备而改变。

看一下日趋扩大的性能差距。你可以构建你的 app，做你的尽职调查以及性能分析，解决所有的瓶颈并达成所有目标。**但是除非你是在最低端的手机上开发，不然是无法预测一段代码在如今最低端手机上要运行多久，更不要说未来的最低端手机。**

这就是由不一样的水平带给 web 的负担。你无法预测你的 app 将会运行在什么级别的设备上。你可以说“Sura，这些性能低下的手机与我/我的生意无关！”，但对我来讲，这如同“那些依赖屏幕阅读器的人与我/我的生意无关！”一样的恶心。**这是一个包容性的问题。我建议你 仔细想想，是否正在通过不支持低端手机来排除掉某些人群。**我们应该努力使每一个人都能获取到这个世界的信息，而不管喜不喜欢，你的 app 正是其中的一部分。

话虽如此，由于涉及到很多术语和背景知识，本博客无法给所有人提供指导。上面的那些段落也一样。我不会假装无障碍访问或者给低端手机编程是一件容易的事，但我相信作为一个工具社区和框架作者还是有很多事情可以去做，去以正确的方式帮助人们，让他们的成果默认就更具无障碍性并且性能更好，默认就更加包容。

## 解决它

好了，尝试从沙子开始建造城堡。尝试去制作那些能在各种各样的，你都无法预测一段在代码在上面需要运行多久的设备上都能保持符合 RAIL 模型性能评估的时间预算的 app。

### 共同合作

一个解决阻塞的方式是“分割你的 JavaScript”或者说是“让渡给浏览器”。意思是通过在代码添加一些固定时间间隔的**断点**来给浏览器一个暂停运行你的 JavaScript 的机会然后去渲染下一帧或者处理一个输入事件。一旦浏览器完成这些工作，它就会回去执行你的代码。这种在 web 应用上让渡给浏览器的方式就是安排一个宏任务，而这可以通过多种方式实现。

> **必要的阅读：** 如果你对宏任务或者宏任务与微任务的区别，我推荐你去阅读 [Jake Archibald](https://twitter.com/jaffathecake) 的[谈谈事件循环](https://www.youtube.com/watch?v=cCOL7MC4Pl0)。

在 PROXY，我们使用一个 `MessageChannel` 并且使用 `postMessage()` 去安排一个宏任务。为了在添加断点之后代码仍能保持可读性，我强烈推荐使用 `async/await`。在 [PROXX](https://proxx.app) 上，用户在主界面与游戏交互的同时，我们在后台生成精灵。

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
    await task(); // 断点
  }
  // ...
}
```

但是**分割依旧受到日趋扩大的性能差距的影响：**一段代码运行到下一个断点的时间是取决于设备的。在一台低端手机上耗时小于 16 毫秒，但在另一台低端手机上也许就会耗费更多时间。

## 移出主线程

我之前说过，主线程除了执行网页应用的 JavaScript 以外，还有别的一些职责。而这就是为什么我们要不惜代价避免长的，阻塞的 JavaScript 在主线程。但假如说我们把大部分的 JavaScript 移动到一条**专门**用来运行我们的 JavaScript，除此之外不做别的事情的线程中呢。一条没有其他职责的线程。在这样的情况下，我们不需要担心我们的代码受到日趋扩大的性能差距的影响，因为主线程不会收到影响，依然能处理用户输入并保持帧率稳定。

### Web Workers 是什么？

**[Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Worker)，也被叫做 “Dedicated Workers”，是 JavaScript 在线程方面的尝试。**JavaScript 引擎在设计时就假设只有一条线程，因此时没有并发访问的 JavaScript 对象内存，而这符合所有同步机制的需求。如果一条具有共享内存模型的普通线程被添加到 JavaScript，那么少说也是一场灾难。相反，我们有了 [Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Worker)，它基本上就是一个运行在另一条独立线程上的完整的 JavaScript 作用域，没有任何的共享内存或者共享值。为了使这些完全分离并且孤立的 JavaScript 作用域能共同工作，你可以使用 [`postMessage()`](https://developer.mozilla.org/en-US/docs/Web/API/Worker/postMessage)，它使你能够在**另一个** JavaScript 作用域内触发一个 `message` 事件并带有一个你提供的值的拷贝（使用[结构化克隆算法](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm) 来拷贝）。

到目前为止，除了一些通常涉及长时间运行的计算密集任务的“银弹”用例以外 workers 基本没得到采用。我想这应该被改变。**我们应该开始使用 workers。经常使用。**

### 所有酷小孩都在这么做

这不是一个新的想法，实际上还挺老的。**大部分原生平台都把主线程称为 UI 线程，因为它应该只会被用来处理 UI 工作**，并且它们给你提供了工具去实现。安卓从很早的版本开始就有一个叫 [`AsyncTask`](https://developer.android.com/reference/android/os/AsyncTask) 的东西，并从那开始添加了更多更方便的 API（最近的是 [Coroutines](https://kotlinlang.org/docs/reference/coroutines/basics.html) 它可以很容易地被派发在不同线程）。如果你选用了[“严格模式”](https://developer.android.com/reference/android/os/StrictMode)，那么在 UI 线程上使用某些 API —— 例如文件操作 —— 会导致你的应用奔溃，以此来提醒你在 UI 线程上做了一些与 UI 无关的操作。

从一开始 iOS 就有一个叫 [Grand Central Dispatch](https://developer.apple.com/documentation/dispatch) (“GCD”)的东西，用来在不同的系统提供的线程池上派发任务，其中包括 UI 线程。通过这方式他们强制了两个模式：你总是要将你的逻辑分割成若干任务，然后才能被放到队列中，允许 UI 线程在需要的时候将其放入对应的线程，但同时也允许你通过简单地将任务放到不同的队列来在不同的线程执行非 UI 相关的工作。锦上添花的是还可以给任务指定优先级，这样帮助我们确保时间敏感的工作能尽快被完成，并且不会牺牲系统整体的响应。

我的观点是这些原生平台从一开始就已经支持使用非 UI 线程。我觉得可以公正地说，经过这么多时间，他们已经证明来这是一个好主意。将在 UI 线程的工作量降到最低有助于让你的 app 保持响应灵敏。为什么不把这样的模式用在 web 上呢？

## 开发体验是一个障碍

我们只能通过 Web Worker 这么一个简陋的工具在 web 上使用线程。当你开始使用 Workers 以及他们提供的 API 时，`message` 事件处理器就是其中的核心。这感觉并不好。此外，Workers **像**线程，但又跟线程不完全一样。你无法让多个线程访问同一个变量（例如一个静态对象），所有的东西都要通过消息传递，这些消息能携带很多但不是全部 JavaScript 值。例如你不能发送一个 `Event` 或者没有数据损失的对象实例。我想，对于开发者来说这是最大的阻碍。

### Comlink

因为这样的原因，我编写了 [Comlink](https://github.com/GoogleChromeLabs/comlink) 它不仅帮你隐藏掉 `postMessage()`，甚至能让你忘记正在使用 Workers。**感觉**就像是你能够访问到来自别的线程的共享变量：

```js
// main.js
import * as Comlink from "https://unpkg.com/comlink?module";

const worker = new Worker("worker.js");
// 这个 `state` 变量其实是在别的 worker 中！
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

> **说明：**我用了顶层 await 以及模块 worker（modules-in-workers）来让例子变短。请到 [Comlink 的代码仓库](https://github.com/GoogleChromeLabs/comlink)查看真实的例子以及更多细节。

在这问题上 Comlink 不是唯一的解决方案，只是我最熟悉它（很正常，考虑到是我写的  🙄）。如果你对其他方法感兴趣，看一下 [Andrea Giammarchi](https://twitter.com/webreflection) 的 [workway](https://github.com/WebReflection/workway) 或者 [Jason Miller](https://twitter.com/_developit) 的 [workerize](https://github.com/developit/workerize)。

我不在意你用哪个库，只要你最终转换到“离开主线程”架构。我们在 [PROXX](https://proxx.app) 和 [Squoosh](https://squoosh.app) 上成功使用了 Comlink，因为它很小(gzip 后 1.2KiB)并且让我们不需要在开发上改动太多就能使用很多来自其他有“真正”线程的语言的常用模式。

### 参与者

最近我和 [Paul Lewis](https://twitter.com/aerotwist) 一起评估过其他的方法。除了说隐藏你正在使用 Worker 的事实以及 `postMessage`，我们还从 70 年代和使用过的[参与者模式](https://dassur.ma/things/actormodel/)中得到灵感，这种架构模式将消息传递当作基本的积木。经过那次思想实验，我们编写了一个[支撑参与者模式的库](https://github.com/PolymerLabs/actor-helpers)，一个[入门套件](https://github.com/PolymerLabs/actor-boilerplate)，并在 2018 Chrome 开发者峰会上做了[一次演讲](https://www.youtube.com/watch?v=Vg60lf92EkM)，介绍了这个架构以及它的应用。

## “基准测试”

你也许会想：**是不是值得去使用“离开主线程”架构？**让我们来做一个投入/产出分析：有了 [Comlink](https://github.com/GoogleChromeLabs/comlink) 这样的库，切换到“离开主线程”架构的代价应该会比以前有显著的降低，非常接近于零。那么好处呢？

[Dion Almaer](https://twitter.com/dalmaer) 叫过我去给 [PROXX](https://proxx.app) 写一个完全运行在主线程上的版本，这也许能解答那个问题。因此[我就这么做了](https://github.com/GoogleChromeLabs/proxx/pull/437)。在 Pixel 3 或者 MacBook 上仅仅有一点可感知的差别。但是在 Nokia 2 上则有了明显不同。**如果把所有东西都运行在主线程上，在最差的情形下应用卡住了高达 6.6 秒。**并且还有很多正在流通的设备的性能比 Nokia 2 还要低！而运行使用了“离开主线程”架构的 PROXX 版本，执行一个 `tap` 事件处理函数仅仅耗时 48 毫秒，因为所做的仅仅是通过调用 `postMessage()` 发了一条消息到 Worker 中。这代表着，特别是考虑到日趋扩大的性能差距，**“离开主线程”架构能够提高处理意想不到的大且长的任务的韧性**。

![一个采用“离开主线程”架构的 PROXX 的运行跟踪](https://dassur.ma/trace-omt-bb7bc9f7.png)

PROXX 的事件处理器是非常简洁的并且只会被用来给指定的 worker 发送消息。总而言之这个任务耗时 48 毫秒。

![一个采用所有都运行在主线程的 PROXX 的运行跟踪](https://dassur.ma/trace-nonomt-0d7f2457.png)

在一个所有东西都运行在主线程的 PROXX 版本，执行一个事件处理器需要耗时超过 6 秒。

有一个需要注意的是，任务并没有消失。即使使用了“离开主线程”架构，代码仍需要运行大约 6 秒的事件（在 PROXX 这实际上会更加长）。然而由于这些工作是在另一个线程上进行的，UI 线程仍然能保持响应。我们的 worker 也会把中间结果传回主线程。**通过保持事件处理器的简洁，我们保证了 UI 线程能保持响应并能更新视觉状态。**

## 框架的窘困

现在说一下我一个脱口而出的意见：**我们现有的框架让“离开主线程”架构变得困难并减少了它的回归。** UI 框架应该去做 UI 的工作，也因此有权去运行在 UI 线程。然而实际上，它们所做的工作是 UI 工作以及其他一些相关但是非 UI 的工作。

让我们拿 VDOM diff 做例子：虚拟 DOM 的目的将开发者的代码与真实 DOM 的更新解耦。虚拟 DOM 仅仅是一个模拟真实 DOM 的数据结构，这样它的改变就不会引起高消耗的副作用。只有当框架认为时机合适的时候，虚拟 DOM 的改变才会引起真实 DOM 的更新。这通常被称为“冲洗（flushing）”。直到冲洗之前的所有工作是绝对不需要运行在 UI 线程的。然而实际上它正在耗费你宝贵的 UI 线程资源。鉴于低端手机无法应付 diff 的工作量，在 [PROXX](https://proxx.app) 我们[去除了 VDOM diff](https://github.com/GoogleChromeLabs/proxx/blob/94b08d0b410493e2867ff870dee1441690a00700/src/services/preact-canvas/components/board/index.tsx#L116-L118) 并实现了我们自己的 DOM 操作。

VDOM diff 仅仅是其中一个框架引导的开发体验的例子，或者一个简单的克服用户设备性能的例子。一个面向全球发布的框架，除非它明确表明自己只针对哪些[富有的西方网络](https://www.smashingmagazine.com/2017/03/world-wide-web-not-wealthy-western-web-part-1/)，**否则他是有责任去帮助开发者开发支持不同级别手机的应用。**

## 结论

Web Worker 帮助你的应用运行在更广泛的设备上。像 [Comlink](https://github.com/GoogleChromeLabs/comlink) 这样的库协助你在无需放弃便利以及开发速度的情况下使用 worker。我想**我们应该思考的是，为什么除了 web 以外的所有平台都在尽可能的少占用 UI 线程的资源**。我们应该改变自己的老办法，并帮助促成下一代框架改变。

---

特别感谢 [Jose Alcérreca](https://twitter.com/ppvi) 和 [Moritz Lang](https://twitter.com/slashmodev)，他们帮我了解原生平台是如何解决类似问题的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
