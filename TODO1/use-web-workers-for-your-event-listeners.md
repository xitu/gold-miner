> * 原文地址：[For the Sake of Your Event Listeners, Use Web Workers](https://macarthur.me/posts/use-web-workers-for-your-event-listeners)
> * 原文作者：[Alex MacArthur](https://macarthur.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/use-web-workers-for-your-event-listeners.md](https://github.com/xitu/gold-miner/blob/master/TODO1/use-web-workers-for-your-event-listeners.md)
> * 译者：[vitoxli](https://github.com/vitoxli)
> * 校对者：[Alfxjx](https://github.com/Alfxjx)、[febrainqu](https://github.com/febrainqu)、[jilanlan](https://github.com/jilanlan)

# 使用 Web Workers 优化事件监听器

我最近一直在捣鼓 [Web Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers)，结果，我真的后悔没有尽早去研究这个功能强大的工具。现代 Web 应用程序对浏览器主线程的要求越来越高，进而影响程序的性能和提供流畅用户体验的能力。而 Web Worker 正是应对这种挑战的一种方法。

## 点击后发生了什么

Web Workers 有很多优点，但当涉及到程序中多个 DOM 事件监听器（表单提交、窗口大小调整、点击按钮等）的时候，我真的被震撼到了。这些监听器都必须存在于浏览器的主线程上，当主线程因长时间运行的进程而阻塞时，监听器的响应能力会受到影响，在事件循环可以正常运行之前，整个应用程序都会被阻塞。

诚然，监听器之所以困扰我多时，是因为我一开就误解了 Workers 要解决的问题。最开始，我一直以为它主要是关于代码的执行**速度**。“如果我可以在不同的线程上并行执行更多操作，那么我的代码执行速度将大大提升！”但是！在通常情况下，一件事开始执行前需要另一件事发生为前提，例如当你希望一系列计算完成之后才能更新 DOM。所以我幼稚地想：“如果我仍然要等待事件完成后才进行别的操作，把一些任务移到单独的线程中执行的意义没有那么大”。

这是我想到的代码：

```javascript
const calculateResultsButton = document.getElementById('calculateResultsButton');
const openMenuButton = document.getElementById('#openMenuButton');
const resultBox = document.getElementById('resultBox');

calculateResultsButton.addEventListener('click', (e) => {
    // "在它执行完前，我不能更新 DOM，
    // 所以我为什么要把它放到 Worker 里呢？"
    const result = performLongRunningCalculation();
    resultBox.innerText = result;
});

openMenuButton.addEventListener('click', (e) => {
    // Do stuff to open menu. 
});
```

在这里，我在执行某种可能大计算量的操作后更新了 box 中的文本。并行执行这些操作没有什么意义（DOM 的更新取决于计算的结果），所以，**理所当然**，我希望所有操作都是同步的。但最开始我不了解的是，**如果线程被阻塞，**其它**所有的监听器都无法被触发**。这意味着，操作变得不可靠了。

## 举例说明不靠谱的场景

在下面的示例中，点击“Freeze”按钮将会在增加计数，但在这之前会执行3秒的同步暂停（来模拟长时间运行的计算），而点击“Increment”按钮将立即增加计数。在第一个按钮暂停期间，整个线程处于静止状态，在事件循环可以再次执行前，不会触发其它任何主线程的活动。

为了证明这一点，请单击第一个按钮，然后立即单击第二个按钮。

请在 <a href='https://codepen.io'>CodePen</a> 中查看 Alex MacArthur (<a href='https://codepen.io/alexmacarthur'>@alexmacarthur</a>)的 <a href='https://codepen.io/alexmacarthur/pen/XWWKyGe'>Event Blocking - No Worker</a>。

页面卡住是因为较长的同步暂停阻塞了线程。但造成的影响不止于此。再次执行此操作，但是这次，单击“Freeze”后立即尝试调整蓝色边框的大小。由于布局更改和重绘也在主线程中进行，因此在计时完成前，将再次被阻塞。

## 它们监听的远比你想象得多

任何普通的用户都不愿意经历这种体验，而我们不过是处理了几个事件监听器。不过，在现实世界中，我们要做的还很多。通过使用 Chrome 的`getEventListeners`方法，我使用以下脚本汇总了页面上每个 DOM 元素的事件监听器。将这段代码放到控制台中，它会返回监听器的总数。

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

我在下列程序中任意的页面运行以上代码，得到的可用的监听器数如下。

| Application     | Number of Listeners |
| --------------- | ------------------- |
| Dropbox         | 602                 |
| Google Messages | 581                 |
| Reddit          | 692                 |
| YouTube         | 6,054 (!!!)         |

注意这些特殊的数字。绑定到 DOM 中监听器的数量很多，而且即使应用程序中只有一个长时间运行的进程出错了，**所有**的监听器都将无响应。这很有可能就降低你程序的用户体验。

## 更靠谱一些的同样的示例（多亏了 Web Workers！）

考虑到以上种种情况，让我们升级上述示例。同样地方法，但是这次，我们把长时间运行的操作移至单独的线程中。再次执行相同的点击，你会发现点击“Freeze”仍然会延迟 3 秒钟更新点击次数，但是**不会阻止页面上其他任何事件监听器**。 相反，其它按钮仍可单击，并且 box 的大小仍然可以调整，这正是我们想要的。

请在 <a href='https://codepen.io'>CodePen</a> 中查看 Alex MacArthur (<a href='https://codepen.io/alexmacarthur'>@alexmacarthur</a>)的 <a href='https://codepen.io/alexmacarthur/pen/qBEORdO'>Event Blocking - Worker</a>。

如果你深入研究该代码，你会注意到，虽然 Web Worker API 可能更符合人机工程学，但实际上并没有想象中那么可怕（恐惧更多是由于直接将众多代码示例放在一起）。为了变得不那么吓人，有一些好的工具可以简化其实现。以下是一些我觉得不错的内容：

* [workerize](https://github.com/developit/workerize) — 在 Web Worker 中运行模块
* [greenlet](https://github.com/developit/greenlet) — 在 worker 中运行任意一端异步代码
* [comlink](https://github.com/GoogleChromeLabs/comlink) — 基于 Web Worker API 的抽象封装

## 开始线程编程吧（可以更有意义）

如果你的应用程序是典型的，则可能已经绑定了很多监听器。而且它可能还会执行很多不需要在主线程上进行的计算。因此，可以考虑使用 Web Workers 进行监听并提高用户体验。

需要明确的是，将**所有**非 UI 工作放到工作线程中可能不是一个好方法。可能只是给你的程序增加了很多重构和复杂性，而收效甚微。或许，可以考虑先确定有哪些明显的计算密集的进程，然后分别给这些进程分配一个小型 Web Worker。随着时间的推移，再逐步深入研究并考虑在更大地范围内使用 UI/Worker 架构。

无论如何，深入研究它吧。其强大的浏览器支持以及现代应用程序对性能的需求不断增长，我们没有理由不去研究这类工具。

愉快地开始线程编程吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
