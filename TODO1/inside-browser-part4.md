> * 原文地址：[Inside look at modern web browser (part 4)](https://developers.google.com/web/updates/2018/09/inside-browser-part4)
> * 原文作者：[Mariko Kosaka](https://developers.google.com/web/resources/contributors/kosamari)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/inside-browser-part4.md)
> * 译者：
> * 校对者：

# 现代浏览器内部揭秘（第四部分）

## 用户输入行为与合成器 

内部揭秘系列博客对现代浏览器如何处理代码、显示页面展开探讨。该系列博客共四篇，这是最后一篇。在上篇博客里，我们了解了 [渲染进程与合成器](https://developers.google.com/web/updates/2018/09/inside-browser-part3)。这里我们将一窥当用户输入行为发生时，合成器如何继续保障交互流畅。

## 浏览器视角下的输入事件

听到 "输入事件" 这个字眼，你脑海里闪现的恐怕只是输入文本或点击鼠标。但在浏览器眼中，输入意味者一切用户行为。不单滚动鼠标滑轮是输入事件，触摸屏幕、滑动鼠标同样也是用户输入事件。

诸如触摸屏幕之类用户手势产生时，浏览器进程会率先将其捕获。然而浏览器进程所掌握的信息无非行为发生的区域，因为标签页里的内容都由渲染进程负责处理，所以浏览器进程会将事件类型 ( 如 `touchstart` ) 及其坐标发送给渲染进程。 渲染进程会寻至事件目标，运行其事件监听器，妥善地处理事件。

![input event](https://developers.google.com/web/updates/images/inside-browser/part4/input.png)

图1:输入事件由浏览器进程发往渲染进程

## 合成器接收输入事件

![composit.gif](https://i.loli.net/2018/10/08/5bbaaa3d26b97.gif)

图2:悬于页面图层的视图窗口

在上篇文章里，我们探讨了合成器如何通过合成栅格化图层，实现流畅的页面滚动。如果页面未添加任何事件监听，合成器线程会创建新的合成帧，新帧完全独立于主线程。但如果页面添加了一些事件监听，合成器线程如何得知事件是否需要处理？

## 理解非立即可滚动区

因为运行 JavaScript 脚本是主线程的工作，所以页面合成后，合成进程会将页面里添加了的事件监听的区域标记为 "非立即可滚动区"。有了这个信息，如果输入事件发生在这一区域，合成进程则能确定应将其发往主线程处理。如其发生在该区域外，合成进程则无需等待主线程，继续合成新帧。

![limited non fast scrollable region](https://developers.google.com/web/updates/images/inside-browser/part4/nfsr1.png)

图3:非立即可滚动区输入描述示意图

### 设置事件处理器时须注意

web 开发中常用的事件处理模式是事件代理。因为事件会冒泡，所以你可以在最顶层的元素中添加一个事件处理器，用来代理事件目标产生的任务。下面这样的代码，你可能见过或写过。

```
document.body.addEventListener('touchstart',  event => {
    if (event.target === area) {
        event.preventDefault();
    }
});
```

因为在所有的元素上仅需设置一个事件处理，所以这样的功效会吸引很多人去使用事件代理模式。然而，如果站在浏览器的角度去考量，这等于把整个页面都标记成了 '非立即可滚动区'，意味着即便你设计的应用本不必理会页面上一些区域的输入行为，合成线程也必须在每次输入事件产生后与主线程通信并等待返回。如此则得不偿失，使原本能保障页面滚动流畅的合成器无用武之地。

![full page non fast scrollable region](https://developers.google.com/web/updates/images/inside-browser/part4/nfsr2.png)

图4:非立即可滚动区覆盖整个页面下的输入描述示意图

为将这种情况的负面效应最小化，你可以给事件监听添加一个 [`passive:true` https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener#Improving_scrolling_performance_with_passive_listeners)选项 。这会提示浏览器你想在主线程中继续监听事件，但合成器不必停滞等候，可继续创建新的合成帧。

```
document.body.addEventListener('touchstart', event => {
    if (event.target === area) {
        event.preventDefault()
    }
 }, {passive: true});
```

## 检查事件是否可撤销

![page scroll](https://developers.google.com/web/updates/images/inside-browser/part4/scroll.png)

图5:部分区域仅可水平方向滚动的网页

设想一下这种情形：页面上有一个盒子，你想将其滚动方向限制为水平滚动。

为目标事件设置 `passive:true` 选项可让页面滚动平滑，但在你使用 `preventDefault` 以限制滚动方向时，垂直方向滚动可能已经触发。通过使用 `event.cancelable` 方法可以检查并阻止这种情况发生。

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

合成器将输入事件发送至主线程后，首先运行的是命中检测。命中检测会使用渲染进程中产生的绘制记录数据，找出事件发生坐标下的内容。

## 降低往主线程发送事件的频率  

之前的文章里，我们探讨了常见显示屏如何以每秒60帧的频率刷新，以及我们要怎样才能跟上其刷新频率，营造出流畅的动画效果。而对于用户的输入行为，常见触摸屏幕设备可以每秒60~120次的频率发送触摸事件。可见，输入事件有着比显示屏幕更高的保真度。

如果一连串 `touchmove` 这样的事件以每秒120次的频率发送往主线程，那么可能会触发过量的命中检测及 JavaScript 脚本执行，而我们的屏幕刷新率则相形见绌。

![unfiltered events](https://developers.google.com/web/updates/images/inside-browser/part4/rawevents.png)

图7:大量事件涌入合成帧时间轴会造成页面闪烁

为了降低往主线程中传递过量调用， Chrome 会合并这些连续事件(如：`wheel`, `mousewheel`, `mousemove`, `poitermove`, `touchmove` 等)，并将其延迟至下一次 `requestAnimationFrame` 前发送。 

![coalesced events](https://developers.google.com/web/updates/images/inside-browser/part4/coalescedevents.png)

图8:时间轴与之前相同，但事件被合并后延迟发送

所有独立的事件，如: `keydown`, `keyup`, `mouseup`, `mousedown`, `touchstart`, 及  `touchend` 会立即发往主线程。

## 使用 `getCoalescedEvents` 获取帧内事件

事件合并可帮助大多数 web 应用构建良好的用户体验。然而，如果你开发的是一个绘图类应用，需要基于 `touchmove` 事件的坐标绘制路径，那么在你试图画下一根光滑的线条时，区间内的一些坐标点也可能会因事件合并而丢失。这时，你可以使用目标事件的  `getCoalescedEvents` 方法获取事件合并后的信息。

![getCoalescedEvents](https://developers.google.com/web/updates/images/inside-browser/part4/getCoalescedEvents.png)

图9:左为流畅的触摸动作路径、右为合并后有所限制的路径

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

本系列文章里，我们探讨了很多关于 web 浏览器内部的工作原理。如果之前你从来没想过：为什么 Devtools 推荐在事件处理器上添加 `{passive:true}` 选项、为什么有时须在 script 标签里添加 `async` 属性？那么我希望这些文章能帮助你了解为什么浏览器会需要这些信息去构建更为迅捷流畅的 web 体验。

### 使用 Lighthouse  

如果你想写出对浏览器更为友好的代码，却一时不知从何开始，[Lighthouse](https://developers.google.com/web/tools/lighthouse/) 工具可以帮助你审查网站，并提供页面性能报告。性能报告会告诉你什么地方处理得当，什么地方有待提升。浏览审查列表也能让你了解浏览器关注的重点在什么地方。

### 学习如何评测性能

对于不同的站点，桎梏其性能之处可能不尽相同。所以专门为你自己的站点制定性能评测，并采取最适合的技术方案，是十分重要的。Chrome 的 Devtools 团队就 [如何测试你的站点性能](https://developers.google.com/web/tools/chrome-devtools/speed/get-started) 撰有一些教程。

### 为你的站点添加 Feature Policy

如果你想进一步采用更多方案，[Feature Policy](https://developers.google.com/web/updates/2018/06/feature-policy) 是一个新的 web 平台，可在开发时为你保驾护航。开启 feature policy 可以限制应用行为，并使你远离诸多技术弊端。举个例子，如果你想确保应用不会阻塞解析，那么可以采用同步脚本方案运行应用。开启 `sync-script:'none'` 后，导致解析阻塞的 JavaScript 脚本会被阻止运行。这就确保了你的代码不会阻塞解析，浏览器也无须考虑暂停运行解析器。

## 总结

![thank you](https://developers.google.com/web/updates/images/inside-browser/part4/thanks.png)

刚踏上开发之路时，我几乎只关注怎样去写代码、怎样提升自己的生产效率。诚然，这些事情很重要，但同时我们也应当思考浏览器会怎么去处理我们写的代码。现代浏览器一直致力探索如何提供更好的用户体验。书写对浏览器友好的代码，反过来也能提供友好的用户体验。路漫漫其修远兮，希望我们能携手共进，构建出对浏览器更为友好的代码。

诚挚感谢 [Alex Russell](https://twitter.com/slightlylate), [Paul Irish](https://twitter.com/paul_irish), [Meggin Kearney](https://twitter.com/MegginKearney), [Eric Bidelman](https://twitter.com/ebidel), [Mathias Bynenes](https://twitter.com/mathias), [Addy Osmani](https://twitter.com/addyosmani), [Kinuko Yasuda](https://twitter.com/kinu), [Nasko Oskov](https://twitter.com/nasko), 以及 Charlie Reis 等人对本系列文章初稿的校对.

你喜欢这一系列的文章吗？对之后文章如有任何意见或建议，欢迎在下面评论区或是推特[@kosamari](https://twitter.com/kosamari) 里留下您的宝贵意见。 

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
