> * 原文地址：[How JavaScript works: Under the hood of CSS and JS animations + how to optimize their performance](https://blog.sessionstack.com/how-javascript-works-under-the-hood-of-css-and-js-animations-how-to-optimize-their-performance-db0e79586216)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-under-the-hood-of-css-and-js-animations-how-to-optimize-their-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-under-the-hood-of-css-and-js-animations-how-to-optimize-their-performance.md)
> * 译者：[NoName4Me](https://github.com/NoName4Me)
> * 校对者：

# JavaScript 是如何工作的：CSS 和 JS 动画背后的原理 + 如何优化性能

这是专门探索 JavaScript 及其构建组件系列的第 13 篇文章。在识别和描述核心元素的过程中，我们还分享了构建 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-networking-layer-intro) 时的一些经验法则，SessionStack 是一个足够强大且高性能的 JavaScript 应用程序，用来帮助用户实时查看和重现其 Web 应用程序的缺陷。

如果你错过了前面的章节，你可以在这里找到它们：

1. [[译] JavaScript 是如何工作的：对引擎、运行时、调用堆栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
2. [[译] JavaScript 是如何工作的：在 V8 引擎里 5 个优化代码的技巧](https://juejin.im/post/5a102e656fb9a044fd1158c6)
3. [[译] JavaScript 是如何工作的：内存管理 + 处理常见的4种内存泄漏](https://juejin.im/post/5a2559ae6fb9a044fe4634ba)
4. [[译] JavaScript 是如何工作的: 事件循环和异步编程的崛起 + 5个如何更好的使用 async/await 编码的技巧](https://juejin.im/post/5a221d35f265da43356291cc)
5. [[译] JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择](https://juejin.im/post/5a522647518825732d7f6cbb)
6. [[译] JavaScript 是如何工作的：与 WebAssembly 一较高下 + 为何 WebAssembly 在某些情况下比 JavaScript 更为适用](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it.md)
7. [[译] JavaScript 是如何工作的：Web Worker 的内部构造以及 5 种你应当使用它的场景](https://juejin.im/post/5a90233bf265da4e92683de3)
8. [[译] JavaScript 是如何工作的：Web Worker 生命周期及用例](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-service-workers-their-life-cycle-and-use-cases.md)
9. [[译] JavaScript 是如何工作的：Web 推送通知的机制](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-mechanics-of-web-push-notifications.md)
10. [[译] JavaScript 是如何工作的：用 MutationObserver 追踪 DOM 的变化](https://juejin.im/post/5aee720df265da0b8f627173)
11. [[译] JavaScript 是如何工作的：渲染引擎和性能优化技巧](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance.md)
12. [[译] JavaScript 是如何工作的：网络层内部 + 如何优化其性能和安全性](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-inside-the-networking-layer-how-to-optimize-its-performance-and-security.md)

### 概览

你也知道，动画在创造吸引人的 web app 中扮演着重要的角色。随着用户越来越多地将注意力转移到用户体验上，商家也开始意识到完美、愉悦的用户体验的重要性，web app 变得更加重要，并且 UI 更趋于动效。这一切都需要更复杂的动画，以便在用户使用中实现更平滑的状态转换。今天，这甚至不被认为是特别的。用户正在变得越来越挑剔，默认期望高效响应和互动的用户界面。

但是，动效化你的界面可没那么简单。将什么做成动画，什么时候，做成什么样的动画，都是棘手的问题。

### JavaScript 和 CSS 动画

创建网页动画的两种主要方式是使用 JavaScript 和 CSS。没有绝对优劣; 一切都取决于你的目标。

#### CSS 动画

用 CSS 实现动画是让屏幕上的内容移动的最简单方法。

我们将以一个快速示例说明如何在 X 轴和 Y 轴上移动 50 像素的元素。通过设置耗时 1000 ms 的 CSS 过渡来完成的。

```css
.box {
  -webkit-transform: translate(0, 0);
  -webkit-transition: -webkit-transform 1000ms;

  transform: translate(0, 0);
  transition: transform 1000ms;
}

.box.move {
  -webkit-transform: translate(50px, 50px);
  transform: translate(50px, 50px);
}
```

当类 `move` 被添加后，`transform` 的值会改变，过渡开始。

除了过渡的时长，还有其它的用来**缓动**的选项，这些就是你看到的动画的本质。稍后我们将在本文中更详细地讨论缓动。

如果像上面的代码片段那样创建单独的 CSS 类来管理动画，你就可以使用 JavaScript 来切换每个动画的开启和关闭。

假设你有这样的一个元素：

```html
<div class="box">
  Sample content.
</div>
```

然后，你可以使用 JavaScript 切换每个动画的开启和关闭：

```js
var boxElements = document.getElementsByClassName('box'),
    boxElementsLength = boxElements.length,
    i;

for (i = 0; i < boxElementsLength; i++) {
  boxElements[i].classList.add('move');
}
```

上面的代码片段获取了所有具有 `box` 类的元素，并添加了 `move` 类以触发动画。

这样做可以为你的 app 提供很好的平衡。你可以专注于使用 JavaScript 管理状态，并简单地在目标元素上设置适当的类，让浏览器处理动画。如果沿着这条路线走下去，你可以监听 `transitionend` 元素上的事件，但前提是你能够放弃对旧版 Internet Explorer 的支持：

![](https://cdn-images-1.medium.com/max/800/1*Qm9OFPq3siW0tCKfa03DqQ.png)

监听 `transitioned` 过渡结束时触发的事件，如下所示：

```js
var boxElement = document.querySelector('.box'); // 获取有 box 类的第一个元素。
boxElement.addEventListener('transitionend', onTransitionEnd, false);

function onTransitionEnd() {
  // 处理过渡完成。
}
```

除了 CSS 过渡，你还可以使用 CSS 动画，它使你对动画关键帧、持续时间、重复有更多的控制。

> 关键帧用于指示浏览器在给定点处 CSS 属性应该有什么值，并填补（关键帧之间的）空白。

我们看个例子：

```css
/**
 * 这是没有加浏览器属性前缀的简化版本
 * 如果加上，会比较冗长！
 */
.box {
  /* 指定动画 */
  animation-name: movingBox;

  /* 动画时长 */
  animation-duration: 2300ms;

  /* 动画重复次数 */
  animation-iteration-count: infinite;

  /* 动画正反交替进行 */
  animation-direction: alternate;
}

@keyframes movingBox {
  0% {
    transform: translate(0, 0);
    opacity: 0.4;
  }

  25% {
    opacity: 0.9;
  }

  50% {
    transform: translate(150px, 200px);
    opacity: 0.2;
  }

  100% {
    transform: translate(40px, 30px);
    opacity: 0.8;
  }
}
```

它的效果是这样的（快速演示） — [https://sessionstack.github.io/blog/demos/keyframes/](https://sessionstack.github.io/blog/demos/keyframes/)

使用 CSS 动画，你可以独立于目标元素来定义动画本身，并使用 `animation-name` 属性选择所需的动画。

CSS 动画有时仍然是需要浏览器属性前缀的，`-webkit-` 用于 Safari，Safari Mobile 和 Android。Chrome，Opera，Internet Explorer 和 Firefox 都会在没有前缀的情况下起作用。许多工具可以帮助你创建所需 CSS 的浏览器属性前缀，从而允许你在源文件中编写无前缀的版本。

#### JavaScript 动画

与使用 CSS 过渡或动画相比，使用 JavaScript 创建动画更复杂，但它通常为开发人员提供了更强大的功能。

JavaScript 动画是作为代码的一部分内联编写的。你也可以将它们封装在其他对象中。下面是你需要用 JavaScript 来编写的重新创建前面描述的 CSS 过渡：

```js
var boxElement = document.querySelector('.box');
var animation = boxElement.animate([
  {transform: 'translate(0)'},
  {transform: 'translate(150px, 200px)'}
], 500);
animation.addEventListener('finish', function() {
  boxElement.style.transform = 'translate(150px, 200px)';
});
```

默认情况下，Web 动画仅修改元素的显示。如果你想让你的对象留在它被移动到的位置，那么当动画完成时你应该修改它的底层样式。这就是为什么我们要监听 `finish` 事件，并将 `box.style.transform` 属性设置为 `translate(150px, 200px)`，这与我们动画的第二个变换相同。

使用 JavaScript 动画，你可以在每一步完全控制元素的样式。这意味着你可以放慢动画，暂停动画，停止动画，反转动画，并根据需要操作元素。如果你构建复杂的面向对象的 app，这一点尤其有用，因为你可以适当地封装你的行为。

### 什么是缓动？

自然动作让你的用户对你的 web app 感到更加舒适，从而带来更好的用户体验。

自然情况下，没有什么东西是从一个点到另一个点做线性移动的。事实上，随着它们在我们周围的物质世界中移动，事物往往会加速或减速，因为我们并非处于真空状态，并且存在影响这个因素的不同因素。人类的大脑受制于此会期望这种运动，所以当你为 app 制作动画时，你应该利用这些知识为你带来好处。

有一些术语需要了解一下：

* **「ease-in」** - 开始慢，然后加速。
* **「ease out」** - 开始快，然后减速。

两个可以合并，比如「ease in out」。

缓动可以让动画感觉起来更自然。

#### 缓动关键词

CSS 过渡和动画允许你选择想要使用的缓动类型。有不同的会影响动画缓动的关键词。当然你完全可以使用自定义的缓动。

以下是你可以在 CSS 中用来控制缓动的一些关键词：

*   `linear`
*   `ease-in`
*   `ease-out`
*   `ease-in-out`

我们逐一研究，看看究竟是什么意思。

#### 线性（`linear`）动画

没有任何缓动的动画称为**线性**动画。

以下是线性过渡的图示：

![](https://cdn-images-1.medium.com/max/800/1*M5htfOGgza04ISv_l-69zg.png)

随着时间的推移，值会等量增加。使用线性运动时，总会感觉不自然。一般来说，你应该避免线性运动。

这是一个简单的实现线性动画的方式：

`transition: transform 500ms linear;`

#### 缓出（`ease-out`）动画

前面已经说过，缓出动画与线性动画相比更快地开始，而后变慢。这就是它的图示：

![](https://cdn-images-1.medium.com/max/800/1*VDWQl67cmbyAFC5xL9Og4g.png)

一般来讲，缓出是用户界面工作的最好选择，因为快速开始给你一种快速响应的感觉，而因为不一致运动在结束时慢下来感觉比较自然。

有很多实现缓出效果的方法，但最简单的就是使用 CSS 关键词：

```css
transition: transform 500ms ease-out;
```

#### 缓入（`ease-in`）动画

它与缓出相反 —— 开始慢，结束快。图示如下：

![](https://cdn-images-1.medium.com/max/800/1*rWh8YlBn8SypiMduLiYDhA.png)

与缓出相比，缓入感觉不太自然，因为它开始慢给人一种无响应的感觉。快速结束也很奇怪，因为整个动画是在加速，而在现实世界中，物体在忽然停止时往往会减速。

要使用缓入动画，类似于缓出或者线性动画，使用关键词：

```css
transition: transform 500ms ease-in;
```

#### 缓入缓出（`ease-in-out`）动画

它是缓入和缓出的结合，图示如下：

![](https://cdn-images-1.medium.com/max/800/1*tGXhNroe8KxGN7r4UTVSHw.png)

不要用于持续时间过长的动画，这会让人觉得你的用户界面无响应。

使用 CSS 关键词 `ease-in-out` 实现缓入缓出动画：

```css
transition: transform 500ms ease-in-out;
```

#### 自定义缓动

你可以定义自己的缓动曲线，从而更好地控制项目动画的形成的感受。

实际上，`ease-in`，`ease-out`，`linear`，`ease` 关键词可以对应到预定义的[贝塞尔曲线](https://en.wikipedia.org/wiki/B%C3%A9zier_curve)里，这在[CSS 过渡规范](http://www.w3.org/TR/css3-transitions/)和[网络动画规范](https://w3c.github.io/web-animations/#scaling-using-a-cubic-bezier-curve)里有详细说明。

#### 贝塞尔曲线

让我们看一下贝塞尔曲线的工作原理。贝塞尔曲线有四个值，或者更确切地说，它需要两对数字。每对描述三次贝塞尔曲线控制点的 X 和 Y 坐标。贝塞尔曲线的起点坐标是 (0, 0)，终点坐标是 (1, 1)。你可以设置这两组数。两个控制点的 X 值必须在 [0, 1] 范围内，并且每个控制点的 Y 值可以超过 [0, 1] 限制，尽管规范没有明确说超过多少。

即使每个控制点的 X 和 Y 值发生轻微变化，都会给你一个完全不同的曲线。我们来看看两个贝塞尔曲线图，点的坐标相近但不同。

![](https://cdn-images-1.medium.com/max/800/1*2v7G1ZJ1C-y_mWHOYQfQKQ.png)

和

![](https://cdn-images-1.medium.com/max/800/1*P5nzyldL4rg36dZmt2RViQ.png)

如你所见，两个图区别比较大。两条曲线的第一个控制点的矢量差为 (0.045, 0.183)，第二个控制点差 (-0.427, -0.054)。

第二条曲线的 CSS 写法如下：

```css
transition: transform 500ms cubic-bezier(0.465, 0.183, 0.153, 0.946);
```

前两个数字是第一个控制点的 X 和 Y 坐标，后两个数字是第二个控制点的 X 和 Y 坐标。

### 性能优化

无论何时动画，你都应该保持 60 fps，否则会对用户的体验产生负面影响。

与世界上其他所有的东西一样，动画也是有代价的。动画一些属性比其他属性更便宜。例如，动画修改一个元素的 `width` 和 `height` 会改变它的形状，而且可能引起页面上其它元素的移动和形状改变。这个过程称为布局。我们在[之前的一篇文章](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance.md)中已经详细讨论过布局和渲染。

一般来说，你应该避免使用触发布局或绘制的属性动画。对于大多数现代浏览器，这意味着将动画（修改的属性）限制为 `opacity` 和 `transform`.

#### `will-change`

你可以使用 `[will-change](https://dev.w3.org/csswg/css-will-change/)` 通知浏览器你打算更改元素的属性。浏览器会在你进行更改之前做最合适的优化。但不要过度使用 `will-change`，因为这样做会浪费浏览器资源，从而导致更多的性能问题。

可以这样为变换和不透明度添加 `will-change`：

```css
.box {  will-change: transform, opacity;}
```

Chrome，Firefox 和 Opera 的浏览器支持非常好。

![](https://cdn-images-1.medium.com/max/800/1*eyaMLcORDVsCFIf5h_ygjA.png)

#### 选 JavaScript 还是 CSS？

你可能知道了 —— 这个问题没有正确或错误的答案。你只需要记住以下几点：

* 基于 CSS 的动画和原生支持的 Web 动画通常在称为「合成器线程」的线程上处理。它与浏览器的「主线程」不同，在该主线程中执行样式，布局，绘制和 JavaScript。这意味着如果浏览器在主线程上运行一些耗时的任务，这些动画可以继续运行而不会中断。
* 在许多情况下，`transforms` 和 `opacity` 都可以在合成器线程中处理。
* 如果任何动画出发了绘制，布局，或者两者，那么「主线程」会来完成该工作。这个对基于 CSS 还是 JavaScript 实现的动画都一样，布局或者绘制的开销巨大，让与之关联的 CSS 或 JavaScript 执行工作、渲染都变得毫无意义。

#### 选择合适的对象来做动画

优秀的动画能让用户对你的项目的享受和参与感更添一层。无论你是喜欢宽度，高度，位置，颜色还是背景，你可以制作任何你喜欢的任何动画，但你需要了解潜在的性能瓶颈。选择不当的动画会对用户体验产生负面影响，因此动画需要兼具性能和适当性。动画越少越好。动画只是为了让你的用户体验感觉自然，但不要过度使用动画。

#### 用动画来增强交互

不要只是因为你能就做动画。相反，使用策略性放置的动画来**增强**用户交互。避免不必要的中断或阻碍用户活动的动画。

#### 避免高代价动画属性

唯一比放置得不好的动画还糟糕的是那些导致页面卡顿的动画。这种类型的动画让用户感到沮丧和不快乐。

在 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-rendering-engine-outro) 中使用动画非常简单。总的来说，我们遵循上述做法，但由于 UI 的复杂性，我们还有更多利用动画的场景。SessionStack 必须像视频一样重新创建用户在浏览 web app 时遇到问题时发生的所有内容。为此，SessionStack 仅利用会话期间我们的库收集的数据：用户事件，DOM 更改，网络请求，异常，调试消息等。我们的播放器经过高度优化，可以正确呈现和使用所有收集的内容数据，以便从视觉和技术角度出发，为终端用户的浏览器及其中发生的所有事情提供像素级的模拟。

为了确保复制得自然，尤其是在长时间和繁重的用户会话中，我们使用动画正确指示加载/缓冲，并遵循关于如何实现它们的最佳实践，以便我们不占用太多 CPU 时间并让事件轮询自由地渲染会话。

如果你想[试试 SessionStack](https://www.sessionstack.com/signup/)，有免费方案哦。

![](https://cdn-images-1.medium.com/max/800/0*h2Z_BnDiWfVhgcEZ.)

#### 资源

*   [https://developers.google.com/web/fundamentals/design-and-ux/animations/css-vs-javascript](https://developers.google.com/web/fundamentals/design-and-ux/animations/css-vs-javascript)
*   [https://developers.google.com/web/fundamentals/design-and-ux/animations/](https://developers.google.com/web/fundamentals/design-and-ux/animations/)
*   [https://developers.google.com/web/fundamentals/design-and-ux/animations/animations-and-performance](https://developers.google.com/web/fundamentals/design-and-ux/animations/animations-and-performance)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
