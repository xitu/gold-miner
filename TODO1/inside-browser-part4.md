> * 原文地址：[Inside look at modern web browser (part 4)](https://developers.google.com/web/updates/2018/09/inside-browser-part4)
> * 原文作者：[Mariko Kosaka](https://developers.google.com/web/resources/contributors/kosamari)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part4.md)
> * 译者：
> * 校对者：

# 现代浏览器内部揭秘（第四部分）

## 当输入行为介入合成器 

内部揭秘系列博客对现代浏览器如何处理代码显示页面展开探讨。该系列博客共四篇，这是最后一篇。在上篇博客里我们探讨了 [渲染进程与合成器](https://developers.google.com/web/updates/2018/09/inside-browser-part3)。这里我们将一窥用户输入行为介入时，合成器如何继续保障交互流畅。

## 浏览器视角下的输入事件

听到 "输入事件" ，你脑海里闪现的恐怕只是输入文本或点击鼠标。但在浏览器眼中，输入意味者一切用户行为。不单滚动鼠标齿轮是输入事件，触摸屏幕、滑动鼠标同样也是用户输入事件。

诸如触摸屏幕之类用户行为产生时，浏览器进程是最先将其捕获到的。然而浏览器进程所掌握的信息无非行为发生的区域，因为标签页里的内容皆由渲染进程处理。所以浏览器进程会将事件类型 ( 如 `touchstart` ) 及其坐标发送给渲染进程。 渲染进程会寻至事件目标，运行其事件监听，妥善地处理事件。

![input event](https://developers.google.com/web/updates/images/inside-browser/part4/input.png)

图1:输入事件由浏览器进程发往渲染进程

## 合成器接受输入事件

![composit.gif](https://i.loli.net/2018/10/08/5bbaaa3d26b97.gif)

图2:悬于页面图层的视图窗口

之前文章里，我们探讨了合成器如何通过合成栅格化图层，实现流畅页面滚动。如果页面未添加任何事件监听，合成器线程会创建新的合成帧，新帧完全独立于主线程。但若是页面添加了一些事件监听呢？合成器线程如何得知事件是否需要处理？

## 理解非快速滚动区

因为运行 JavaScript 脚本是主线程的工作，所以页面合成后，合成进程会将页面里添加了的事件监听的区域标记为 "非快速滚动区"。有了这个信息，如有输入事件发生在这一区域，合成进程则可确定将其发往主线程处理。如其发生在该区域外，排版进程则无需等候主线程，继续合成新帧。

![limited non fast scrollable region](https://developers.google.com/web/updates/images/inside-browser/part4/nfsr1.png)

图3:非快速滚动区输入描述示意图

### 设定事件处理器时须当心

web 开发中常用的事件处理模式是事件代理。因为事件会冒泡，所以你可以在最顶层的元素中添加一个事件处理器，用以代为处理目标事件产生的任务。下面这样的代码，你或许见过，可能自己也写过。

```
document.body.addEventListener('touchstart',  event => {
    if (event.target === area) {
        event.preventDefault();
    }
});
```

使用事件代理模式产生的工程效益引人瞩目，这样你只需为所有的元素添加一个事件处理。然而，如果从浏览器的角度去观察这些代码，这样做就等于把整个页面都标记成了 '非快速滚动区'，意味着即便你的应用无须理会页面上一些区域的输入行为，合成线程也必须得在每次输入事件产生后与主线程通信并等待结果。如此则合成器使页面流畅滚动的能力消失殆尽。

![full page non fast scrollable region](https://developers.google.com/web/updates/images/inside-browser/part4/nfsr2.png)

图4:非快速滚动区覆盖整个页面下的输入描述示意图

为了从一开始便抵消这种负面效应，你可以给事件监听添加一个 [`passive:true` 选项](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener#Improving_scrolling_performance_with_passive_listeners) 。这会提示浏览器你想在主线程中继续监听事件，但合成器不必停滞，可继续创建新的合成帧。

```
document.body.addEventListener('touchstart', event => {
    if (event.target === area) {
        event.preventDefault()
    }
 }, {passive: true});
```

## 检查事件是否可以撤销

![page scroll](https://developers.google.com/web/updates/images/inside-browser/part4/scroll.png)

图5:部分区域仅可水平方向滚动的网页

试想一下，你要把一个页面上的盒子设置为仅可水平方向滚动。

为目标事件设置 `passive:true` 选项可让页面滚动平滑，但在你设置 `preventDefault` 以限制滚动方向时，垂直方向滚动可能已经触发。通过使用 `event.cancelable` 方法可以检查阻止该情形。

```
document.body.addEventListener('pointermove', event => {
    if (event.cancelable) {
        event.preventDefault(); // 阻止默认的滚动行为
        /*
        *  这里设置程序执行任务
        */
    } 
}, {passive:: true});
```

或者，你也可以应用 `touch-action` 这类 CSS 规则，完全地将事件处理器屏蔽掉。

```
#area { 
  touch-action: pan-x; 
}
```

## 定位事件目标

![hit test](https://developers.google.com/web/updates/images/inside-browser/part4/hittest.png)

图6:主线程检查绘制记录查询坐标 x、y 处绘制内容

合成器将输入事件发送至主线程后，首先运行的是 hit test. hit test 会使用渲染进程中产生的绘制记录数据，找出事件发生坐标下的内容。

## 降低往主线程发送事件的频率  

之前的文章里，我们探讨了通常显示屏如何以每秒60帧的频率刷新，以及我们要怎样才能跟上刷新频率，营造出流畅的动画效果。而对于用户的输入行为，常见触摸屏幕设备可以每秒60~120次的频率发送触摸事件。可见，输入事件有着比显示屏幕更高的保真度。

如果一连串 `touchmove` 这样的事件以每秒120次的频率发送往主线程，那么可能会触发过量的 hit test 及 JavaScript 脚本运行，而我们的屏幕刷新率相形更为低下。

![unfiltered events](https://developers.google.com/web/updates/images/inside-browser/part4/rawevents.png)

图7:大量事件涌入合成帧时间轴会造成页面卡顿

为了降低往主线程中传递的大量调用， Chrome 会聚结这些连续事件(如：`wheel`, `mousewheel`, `mousemove`, `poitermove`, `touchmove` 等)，并将其延迟至下一次 `requestAnimationFrame` 前发送。 

![coalesced events](https://developers.google.com/web/updates/images/inside-browser/part4/coalescedevents.png)

图8:时间轴与前相同，但事件被聚结并延迟发送

所有独立的事件，如: `keydown`, `keyup`, `mouseup`, `mousedown`, `touchstart`, 及  `touchend` 会立即发往主线程。

## 使用 `getCoalescedEvents` 获取帧内事件

事件聚结可帮助大多数 web 应用构建良好的用户体验。然而，如果你开发的是一个绘图类应用，需要基于 `touchmove` 事件的坐标绘制路径，那么在你试图画下一根光滑的线条时，区间内的一些坐标点也可能会因事件聚结而丢失。这时，你可以使用目标事件的  `getCoalescedEvents` 方法获取事件聚合后的信息。

![getCoalescedEvents](https://developers.google.com/web/updates/images/inside-browser/part4/getCoalescedEvents.png)

图9:左为流畅的触摸动作路径、右为聚合后有所限制的路径

```
window.addEventListener('pointermove', event => {
    const events = event.getCoalescedEvents();
    for (let event of events) {
        const x = event.pageX;
        const y = event.pageY;
        // 使用x、y坐标画线
    }
});
```

## 后续步骤

本系列文章中，我们探讨了很多关于 web 浏览器内部的工作原理。如果之前你从来没想过：为什么 Devtools 推荐在事件处理器上添加 `{passive:true}` 选项？为什么有时须在 script 标签里添加 `async` 属性？那么我希望本系列文章帮助你了解为什么浏览器会需要这些信息去提供更为快速、更为流畅的 web 体验。

### 使用 Lighthouse  

如果你想写出对浏览器更为友好的代码，却一时不知从何开始，[Lighthouse](https://developers.google.com/web/tools/lighthouse/) 工具可以帮助你审查网站，并提供页面性能报告。性能报告会告诉你什么地方处理得当，什么地方有待提升。浏览审查列表也能让你了解浏览器关注的重点在什么地方。

### 学习如何评测性能

对于不同的站点，桎梏网站性能的地方可能不尽相同。所以专门为你自己的站点制定性能评测，并决定最适合的技术方案，是十分重要的。Chrome 的 Devtools 团队就 [如何测试你的站点性能](https://developers.google.com/web/tools/chrome-devtools/speed/get-started) 撰有一些教程。

### 为你的站点添加 Feature Policy

如果你想进一步采用更多方案，[Feature Policy](https://developers.google.com/web/updates/2018/06/feature-policy) 是一个新的 web 平台，可在开发时为你保驾护航。开启 feature policy 可以限制应用行为，并使你远离诸多技术弊端。举个例子，如果你想确保你的应用不会阻塞解析，那么可以采用同步脚本方案运行应用。开启 `sync-script:'none'` 后，导致解析阻塞的 JavaScript 脚本会被阻止运行。这就确保了你的代码不会阻塞解析，浏览器也无须再顾虑暂停运行解析器。

## 总结

![thank you](https://developers.google.com/web/updates/images/inside-browser/part4/thanks.png)

刚踏上开发之路时，我几乎只关注怎样去写代码、怎样提升自己的生产效率。诚然，这些事情很重要，但同时我们也应当思考浏览器会怎么去处理我们写的代码。现代浏览器一直致力探索如何提供更好的用户体验。书写对浏览器友好的代码，反过来也能提供友好的用户体验。路漫漫其修远兮，希望我们能携手共进，构建出对浏览器更为友好的代码。

诚挚感谢 [Alex Russell](https://twitter.com/slightlylate), [Paul Irish](https://twitter.com/paul_irish), [Meggin Kearney](https://twitter.com/MegginKearney), [Eric Bidelman](https://twitter.com/ebidel), [Mathias Bynenes](https://twitter.com/mathias), [Addy Osmani](https://twitter.com/addyosmani), [Kinuko Yasuda](https://twitter.com/kinu), [Nasko Oskov](https://twitter.com/nasko), 以及 Charlie Reis 等人对本系列文章初稿的校对.

你喜欢这一系列的文章吗？对之后文章如有任何意见或建议，欢迎在下面评论区或是推特       [@kosamari](https://twitter.com/kosamari) 里留下您的宝贵意见。 

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。



### Be aware when you write event handlers

Common event handling pattern in web development is the event delegation. Since events bubble, you can attach one event handler at the topmost element and delegate tasks based on event target. You might have seen or written code like the blow.

```
document.body.addEventListener('touchstart',  event => {
    if (event.target === area) {
        event.preventDefault();
    }
});
```

Since you only need to write one event handler for all elements, ergonomics of this event delegation pattern are attractive. However, if you look at this code from the browser's point of view, now the entire page is marked as a non-fast scrollable region. This means even if your application doesn't care about input from certain parts of the page, the compositor thread has to communicate with the main thread and wait for it every time an input event comes in. Thus, the smooth scrolling ability of the compositor is defeated.

![full page non fast scrollable region](https://developers.google.com/web/updates/images/inside-browser/part4/nfsr2.png)

Figure 4: Diagram of described input to the non-fast scrollable region covering an entire page

In order to mitigate this from happening, you can pass `passive: true` options in your event listener. This hints to the browser that you still want to listen to the event in the main thread, but compositor can go ahead and composite new frame as well.

```
document.body.addEventListener('touchstart', event => {
    if (event.target === area) {
        event.preventDefault()
    }
 }, {passive: true});
```

## Check if the event is cancelable

![page scroll](https://developers.google.com/web/updates/images/inside-browser/part4/scroll.png)

Figure 5: A web page with part of the page fixed to horizontal scroll

Imagine you have a box in a page that you want to limit scroll direction to horizontal scroll only.

Using `passive: true` option in your pointer event means that the page scroll can be smooth, but vertical scroll might have started by the time you want to `preventDefault` in order to limit scroll direction. You can check against this by using `event.cancelable` method.

```
document.body.addEventListener('pointermove', event => {
    if (event.cancelable) {
        event.preventDefault(); // block the native scroll
        /*
        *  do what you want the application to do here
        */
    } 
}, {passive: true});
```

Alternatively, you may use CSS rule like `touch-action` to completely eliminate the event handler.

```
#area { 
  touch-action: pan-x; 
}
```

## Finding the event target

![hit test](https://developers.google.com/web/updates/images/inside-browser/part4/hittest.png)

Figure 6: The main thread looking at the paint records asking what's drawn on x.y point

When the compositor thread sends an input event to the main thread, the first thing to run is a hit test to find the event target. Hit test uses paint records data that was generated in the rendering process to find out what is underneath the point coordinates in which the event occurred.

## Minimizing event dispatches to the main thread

In the previous post, we discussed how our typical display refreshes screen 60 times a second and how we need to keep up with the cadence for smooth animation. For input, a typical touch-screen device delivers touch event 60-120 times a second, and a typical mouse delivers events 100 times a second. Input event has higher fidelity than our screen can refresh.

If a continuous event like `touchmove` was sent to the main thread 120 times a second, then it might trigger excessive amount of hit tests and JavaScript execution compared to how slow the screen can refresh.

![unfiltered events](https://developers.google.com/web/updates/images/inside-browser/part4/rawevents.png)

Figure 7: Events flooding the frame timeline causing page jank

To minimize excessive calls to the main thread, Chrome coalesces continuous events (such as `wheel`, `mousewheel`, `mousemove`, `pointermove`, `touchmove` ) and delays dispatching until right before the next `requestAnimationFrame`.

![coalesced events](https://developers.google.com/web/updates/images/inside-browser/part4/coalescedevents.png)

Figure 8: Same timeline as before but event being coalesced and delayed

Any discrete events like `keydown`, `keyup`, `mouseup`, `mousedown`, `touchstart`, and `touchend` are dispatched immediately.

## Use `getCoalescedEvents` to get intra-frame events

For most web applications, coalesced events should be enough to provide a good user experience. However, if you are building things like drawing application and putting a path based on `touchmove` coordinates, you may lose in-between coordinates to draw a smooth line. In that case, you can use the `getCoalescedEvents` method in the pointer event to get information about those coalesced events.

![getCoalescedEvents](https://developers.google.com/web/updates/images/inside-browser/part4/getCoalescedEvents.png)

Figure 9: Smooth touch gesture path on the left, coalesced limited path on the right

```
window.addEventListener('pointermove', event => {
    const events = event.getCoalescedEvents();
    for (let event of events) {
        const x = event.pageX;
        const y = event.pageY;
        // draw a line using x and y coordinates.
    }
});
```

## Next steps

In this series, we've covered inner workings of a web browser. If you have never thought about why DevTools recommends adding `{passive: true}` on your event handler or why you might write `async` attribute in your script tag, I hope this series shed some light on why a browser needs those information to provide faster and smoother web experience.

### Use Lighthouse

If you want to make your code be nice to the browser but have no idea where to start, [Lighthouse](https://developers.google.com/web/tools/lighthouse/) is a tool that runs audit of any website and gives you a report on what's being done right and what needs improvement. Reading through the list of audits also gives you an idea of what kind of things a browser cares about.

### Learn how to measure performance

Performance tweaks may vary for different sites, so it is crucial that you measure the performance of your site and decide what fits the best for your site. Chrome DevTools team has few tutorials on [how to measure your site's performance](https://developers.google.com/web/tools/chrome-devtools/speed/get-started).

### Add Feature Policy to your site

If you want to take an extra step, [Feature Policy](https://developers.google.com/web/updates/2018/06/feature-policy) is a new web platform feature that can be a guardrail for you when you are building your project. Turning on feature policy guarantees the certain behavior of your app and prevents you from making mistakes. For example, If you want to ensure your app will never block the parsing, you can run your app on synchronous scripts policy. When `sync-script: 'none'` is enabled, parser-blocking JavaScript will be prevented from executing. This prevents any of your code from blocking the parser, and the browser doesn't need to worry about pausing the parser.

## Wrap up

![thank you](https://developers.google.com/web/updates/images/inside-browser/part4/thanks.png)

When I started building websites, I almost only cared about how I would write my code and what would help me be more productive. Those things are important, but we should also think about how browser takes the code we write. Modern browsers have been and continue to invest in ways to provide a better web experience for users. Being nice to the browser by organizing our code, in turn, improves your user experience. I hope you join me in the quest to be nice to the browsers!

Huge thank you to everyone who reviewed early drafts of this series, including (but not limited to): [Alex Russell](https://twitter.com/slightlylate), [Paul Irish](https://twitter.com/paul_irish), [Meggin Kearney](https://twitter.com/MegginKearney), [Eric Bidelman](https://twitter.com/ebidel), [Mathias Bynenes](https://twitter.com/mathias), [Addy Osmani](https://twitter.com/addyosmani), [Kinuko Yasuda](https://twitter.com/kinu), [Nasko Oskov](https://twitter.com/nasko), and Charlie Reis.

Did you enjoy the this series? If you have any questions or suggestions for the future post, I'd love to hear from you in the comment section below or [@kosamari](https://twitter.com/kosamari) on Twitter.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
