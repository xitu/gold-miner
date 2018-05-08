> * 原文地址：[How JavaScript works: tracking changes in the DOM using MutationObserver](https://blog.sessionstack.com/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver-86adc7446401)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[jasonxia23](https://github.com/jasonxia23)

# JavaScript 是如何工作的：用 MutationObserver 追踪 DOM 的变化

本系列专门研究 JavaScript 及其构建组件，这是第 10 期。在识别和描述核心元素的过程中，我们也分享了一些构建 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=javascript-series-push-notifications-intro) 的重要法则，SessionStack 是一个 JavaScript 应用，为了帮助用户实时查看和再现他们的 web 应用程序缺陷，它需要健壮并且高性能。

![](https://cdn-images-1.medium.com/max/800/0*mPXf5zRCdEQ42Hn0.)

1. [[译] JavaScript 是如何工作的：对引擎、运行时、调用堆栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
2. [[译] JavaScript 是如何工作的：在 V8 引擎里 5 个优化代码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code.md)
3. [[译] JavaScript 是如何工作的：内存管理 + 处理常见的4种内存泄漏](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md)
4. [[译] JavaScript 是如何工作的: 事件循环和异步编程的崛起 + 5个如何更好的使用 async/await 编码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with.md)
5. [[译] JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path.md)
6. [[译] JavaScript 是如何工作的：与 WebAssembly 一较高下 + 为何 WebAssembly 在某些情况下比 JavaScript 更为适用](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it.md)
7. [[译] JavaScript 是如何工作的：Web Worker 的内部构造以及 5 种你应当使用它的场景](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them.md)
8. [[译] JavaScript 是如何工作的：Web Worker 生命周期及用例](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-service-workers-their-life-cycle-and-use-cases.md)
9. [[译] JavaScript 是如何工作的：Web 推送通知的机制](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-mechanics-of-web-push-notifications.md)

web 应用正在持续的越来越侧重客户端，这是由很多原因造成的，例如需要更丰富的 UI 来承载复杂应用的需求，实时运算，等等。

持续增加的复杂度使得在 web 应用的生命周期的任意时刻中获取 UI 的确切状态越来越困难。

而当你在搭建某些框架或者库的时候，甚至会更加困难，例如，前者需要根据 DOM 来作出反应并执行特定的动作。

### 概览

[MutationObserver](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver) 是一个现代浏览器提供的 Web API，用于检测 DOM 的变化。借助这个 API，可以监听到节点的新增或移除，节点的属性变化或者字符节点的字符内容变化。

为什么你会想要监听 DOM？

这里有很多 MutationObserver API 带来极大便捷的例子，比如：

*   你想要提醒 web 应用的用户，他现在所浏览的页面有内容发生了变化。
*   你正在使用一个新的花哨的 JavaScript 框架，它根据 DOM 的变化动态加载 JavaScript 模块。
*   也许你正在开发一个 WYSIWYG 编辑器，并试着实现撤销/重做功能。借助 MutationObserver API，你在任何时间都能知道发生了什么变化，所以撤销也就非常容易。

![](https://cdn-images-1.medium.com/max/800/1*48tGIboHxgLeKEjMTGkUGg.png)

这里有几个关于 MutationObserver 是如何带来便捷的例子。

#### 如何使用 MutationObserver

将 `MutationObserver` 应用于你的应用相当简单。你需要通过传入一个函数来创建一个 `MutationObserver` 实例，每当有变化发生，这个函数将会被调用。函数的第一个参数是一个批次内所有的变化（mutation）的集合。每个变化都会提供它的类型和已经发生的变化的信息。

```
var mutationObserver = new MutationObserver(function(mutations) {
  mutations.forEach(function(mutation) {
    console.log(mutation);
  });
});
```

这个被创建的对象有三个方法：

*   `observe` — 开始监听变化。需要两个参数 - 你需要观察的 DOM 和一个设置对象
*   `disconnect` — 停止监听变化
*   `takeRecords` — 在回调函数调用之前，返回最后一个批次的变化。

下面这个代码片段展示了如何开始观察：

```
// 开始监听页面中根 HTML 元素中的变化。
mutationObserver.observe(document.documentElement, {
  attributes: true,
  characterData: true,
  childList: true,
  subtree: true,
  attributeOldValue: true,
  characterDataOldValue: true
});
```

现在，假设在 DOM 中你有一些非常简单的 `div` ：

```
<div id="sample-div" class="test"> Simple div </div>
```

使用 jQuery，你可以移除这个 div 的 `class` 属性：

```
$("#sample-div").removeAttr("class");
```

当我们开始观察，在调用 `mutationObserver.observe(...)` 之后我们将会在控制台看到每个 [MutationRecord](https://developer.mozilla.org/en-US/docs/Web/API/MutationRecord) 的日志：

![](https://cdn-images-1.medium.com/max/800/1*UxkSstuyCvmKkBTnjbezNw.png)

这个是由移除 `class` 属性导致的变化。

最后，为了在任务结束后停止对 DOM 的观察，你可以这样做：

```
// 停止 MutationObserver 对变化的监听。
mutationObserver.disconnect();
```

现在，`MutationObserver` 已经被广泛支持：

![](https://cdn-images-1.medium.com/max/800/0*nlOmrsfy-Y1XoR8B.)

#### 备择方案

不管怎么说，`MutationObserver` 并不是一直就有的。那么当 `MutationObserver` 出现之前，开发者用的是什么？

这是几个可用的其他选项：

*   **Polling**
*   **MutationEvents**
*   **CSS animations**

#### Polling

最简单的最接近原生的方法是 polling。使用浏览器的 setInterval web 接口你可以设置一个在一段时间后检查是否有变化发生的的任务。自然，这个方法将会严重的降低应用或者网站的性能。

#### MutationEvents

在 2000 年，[MutationEvents API](https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Mutation_events) 被引入。尽管很有用，但是每次 DOM 发生变化 mutation events 都会被触发，这将再次导致性能问题。现在 `MutationEvents` 接口已经被废弃，很快，现代浏览器将会完全停止对它的支持。

这是浏览器对 `MutationEvents` 的支持：

![](https://cdn-images-1.medium.com/max/800/0*l-QdpBfjwNfPDTyh.)

#### CSS animations

一个有点奇怪的备选方案依赖于 [CSS animations](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Animations/Using_CSS_animations)。这可能听起来有些让人困惑。基本上，这个方案是创建一个动画，一旦一个元素被添加到了 DOM，这个动画就将会被触发。动画开始的时候，`animationstart` 事件会被触发：如果你对这个事件绑定了一个处理器，你将会确切的知道元素是什么时候被添加到 DOM 的。动画执行的时间段很短，所以实际应用的时候它对用户是不可见的。

首先，我们需要一个父级元素，我们在它的内部监听节点的插入：

```
<div id=”container-element”></div>
```

为了得到节点插入的处理器，我们需要设置一系列的 [keyframe](https://www.w3schools.com/cssref/css3_pr_animation-keyframes.asp) 动画，当节点插入的时候，动画将会开始。

```
@keyframes nodeInserted { 
 from { opacity: 0.99; }
 to { opacity: 1; } 
}
```

keyframes 已经创建，动画还需要被应用于你想要监听的元素。注意应设置很小的 duration 值 —— 它们将会减弱动画在浏览器上留下的痕迹：

```
#container-element * {
 animation-duration: 0.001s;
 animation-name: nodeInserted;
}
```

这为 `container-element` 的所有子节点都添加了动画。当动画结束后，插入的事件将会被触发。

我们需要一个作为事件监听者的 JavaScript 方法。在方法内部，必须确保初始的 `event.animationName` 检测是我们想要的那个动画。

```
var insertionListener = function(event) {
  // 确保这是我们想要的那个动画。
  if (event.animationName === "nodeInserted") {
    console.log("Node has been inserted: " + event.target);
  }
}
```

现在是时候为父级元素添加事件监听了：

```
document.addEventListener(“animationstart”, insertionListener, false); // standard + firefox
document.addEventListener(“MSAnimationStart”, insertionListener, false); // IE
document.addEventListener(“webkitAnimationStart”, insertionListener, false); // Chrome + Safari

```

这是浏览器对于 CSS 动画的支持：

![](https://cdn-images-1.medium.com/max/800/0*W4wHvVAeUmc45vA2.)

`MutationObserver` 能提供上述提到的解决方案没有的很多优点。本质上，它能覆盖到每一个可能发生的 DOM 的变化，并且它会在一个批次的变化发生后被触发，这种方法使得它得到大大的优化。最重要的，`MutationObserver` 被所有的主流现代浏览器所支持，还有一些使用引擎下 MutationEvents 的 polyfill。

`MutationObserver` 在 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=mutation-observer-post) 库中占据了核心位置。

你一旦将 SessionStack 库整合进 web 应用，它就开始收集 DOM 变化、网络请求、错误信息、debug 信息等等，并发送到我们的服务器。SessionStack 使用这些信息重新创建了你的用户端发生的一切，并以发生在用户端的同样的方式将产品的问题展现给你。很多用户认为 SessionStack 记录的实际是视频 -- 然而它并没有。记录真实情况的视频是很耗费资源的，然而我们收集的少量数据却很轻量，并不会影响 UX 和你的 web 应用的性能。

如果你想要[尝试一下 SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=source&utm_content=javascript-series-web-workers-try-now)，这是一个免费的设计案例。

![](https://cdn-images-1.medium.com/max/800/0*h2Z_BnDiWfVhgcEZ.)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
