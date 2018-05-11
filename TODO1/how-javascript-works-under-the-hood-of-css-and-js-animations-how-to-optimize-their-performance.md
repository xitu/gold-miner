> * 原文地址：[How JavaScript works: Under the hood of CSS and JS animations + how to optimize their performance](https://blog.sessionstack.com/how-javascript-works-under-the-hood-of-css-and-js-animations-how-to-optimize-their-performance-db0e79586216)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-under-the-hood-of-css-and-js-animations-how-to-optimize-their-performance.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-under-the-hood-of-css-and-js-animations-how-to-optimize-their-performance.md)
> * 译者：
> * 校对者：

# How JavaScript works: Under the hood of CSS and JS animations + how to optimize their performance

This is post # 13 of the series dedicated to exploring JavaScript and its building components. In the process of identifying and describing the core elements, we also share some rules of thumb we use when building [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-networking-layer-intro), a JavaScript application that needs to be robust and highly-performant to help users see and reproduce their web app defects real-time.

If you missed the previous chapters, you can find them here:

1. [[译] JavaScript 是如何工作的：对引擎、运行时、调用堆栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
2. [[译] JavaScript 是如何工作的：在 V8 引擎里 5 个优化代码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-inside-the-v8-engine-5-tips-on-how-to-write-optimized-code.md)
3. [[译] JavaScript 是如何工作的：内存管理 + 处理常见的4种内存泄漏](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-memory-management-how-to-handle-4-common-memory-leaks.md)
4. [[译] JavaScript 是如何工作的: 事件循环和异步编程的崛起 + 5个如何更好的使用 async/await 编码的技巧](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with.md)
5. [[译] JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path.md)
6. [[译] JavaScript 是如何工作的：与 WebAssembly 一较高下 + 为何 WebAssembly 在某些情况下比 JavaScript 更为适用](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it.md)
7. [[译] JavaScript 是如何工作的：Web Worker 的内部构造以及 5 种你应当使用它的场景](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them.md)
8. [[译] JavaScript 是如何工作的：Web Worker 生命周期及用例](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-service-workers-their-life-cycle-and-use-cases.md)
9. [[译] JavaScript 是如何工作的：Web 推送通知的机制](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-mechanics-of-web-push-notifications.md)
10. [[译] JavaScript 是如何工作的：用 MutationObserver 追踪 DOM 的变化](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-tracking-changes-in-the-dom-using-mutationobserver.md)
11. [[译] JavaScript 是如何工作的：渲染引擎和性能优化技巧](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance.md)
12. [[译] JavaScript 是如何工作的：网络层内部 + 如何优化其性能和安全性](https://github.com/xitu/gold-miner/blob/master/TODO1/how-javascript-works-inside-the-networking-layer-how-to-optimize-its-performance-and-security.md)

### Overview

As you surely know, animations play an essential role in the creation of compelling web apps. As users increasingly shift their attention to UX and businesses start realizing the importance of flawless, enjoyable user journeys, web applications become heavier, and feature more dynamic UI. This all requires more complex animations for smoother state transitions throughout the journey of the user. Today, this is not even considered something special. Users are becoming more advanced, by default expecting highly responsive and interactive user interfaces.

Animating your interface, however, is not necessarily straightforward. What should be animated and when, and what kind of feel should the animation have, are all tough questions.

### JavaScript vs CSS animations

The two primary ways to create web animations are by using JavaScript and CSS. There’s no right or wrong choice; it all depends on what you’re trying to achieve.

#### Animate with CSS

Animating with CSS is the simplest way to get something moving on the screen.

We’ll start with a quick example on how to move a 50px element in both the X and Y axes. It’s done by using a CSS transition that’s set to take 1000ms.

```
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

When the `move` class is added, the `transform` value is changed and the transition begins.

Besides the transition duration, there are options for the **easing**, which is essentially how the animation feels. We’ll go through easing in more detail later in this post.

If, as in the above snippet, you create separate CSS classes to manage your animations, you can then use JavaScript to toggle each animation on and off.

If you have the following element:

```
<div class="box">
  Sample content.
</div>
```

You can then use JavaScript to toggle each animation on and off:

```
var boxElements = document.getElementsByClassName('box'),
    boxElementsLength = boxElements.length,
    i;

for (i = 0; i < boxElementsLength; i++) {
  boxElements[i].classList.add('move');
}
```

The snippet above takes all the elements that have the `box` class and add the `move` class in order to trigger the animation.

Doing this provides a nice balance to your apps. You can focus on managing state with JavaScript, and simply set the appropriate classes on the target elements, leaving the browser to handle the animations. If you go down this route, you can listen to `transitionend` events on the element, but only if you’re able to forego support for older versions of Internet Explorer:

![](https://cdn-images-1.medium.com/max/800/1*Qm9OFPq3siW0tCKfa03DqQ.png)

Listening for the `transitioned` event which is fired at the end of a transition, looks like this:

```
var boxElement = document.querySelector('.box'); // Get the first element which has the box class.
boxElement.addEventListener('transitionend', onTransitionEnd, false);

function onTransitionEnd() {
  // Handle the transition finishing.
}
```

In addition to using CSS transitions, you can also use CSS animations, which allow you to have much more control over individual animation keyframes, durations, and iterations.

> Keyframes are used to instruct the browser what values CSS properties need to have at given points, and it fills in the gaps.

Let’s look at an example:

```
/**
 * This is a simplified version without
 * vendor prefixes. With them included
 * (which you will need), things get far
 * more verbose!
 */
.box {
  /* Choose the animation */
  animation-name: movingBox;

  /* The animation’s duration */
  animation-duration: 2300ms;

  /* The number of times we want
      the animation to run */
  animation-iteration-count: infinite;

  /* Causes the animation to reverse
      on every odd iteration */
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

This is how it looks like (quick demo) — [https://sessionstack.github.io/blog/demos/keyframes/](https://sessionstack.github.io/blog/demos/keyframes/)

With CSS animations you define the animation itself independently of the target element and use the animation-name property to choose the required animation.

CSS animations are still somewhat vendor prefixed, with `-webkit-` being used in Safari, Safari Mobile, and Android. Chrome, Opera, Internet Explorer, and Firefox all ship without prefixes. Many tools can help you create the prefixed versions of the CSS you need, allowing you to write the unprefixed version in your source files.

#### Animate with JavaScript

Creating animations with JavaScript is more complex compared to using CSS transitions or animations, but it typically provides developers significantly more power.

JavaScript animations are written inline as part of your code. You can also encapsulate them inside other objects. Below is the JavaScript that you would need to write to re-create the CSS transition described earlier:

```
var boxElement = document.querySelector('.box');
var animation = boxElement.animate([
  {transform: 'translate(0)'},
  {transform: 'translate(150px, 200px)'}
], 500);
animation.addEventListener('finish', function() {
  boxElement.style.transform = 'translate(150px, 200px)';
});
```

By default, Web Animations only modify the presentation of an element. If you want to have your object remain at the location it was moved to, then you should modify its underlying styles when the animation has finished. This is why we’re listening for the `finish` event in the above example, and set the `box.style.transform` property to equal `translate(150px, 200px)` which is the same as the second transformation performed by our animation.

With JavaScript animations, you’re in total control of an element’s styles at every step. This means you can slow down animations, pause them, stop them, reverse them, and manipulate elements as you see fit. This is especially useful if you’re building complex, object-oriented applications, because you can properly encapsulate your behavior.

### What is Easing?

Natural motion makes your users feel more comfortable with your web apps, which leads to a better UX.

Naturally, nothing moves linearly from one point to another. Actually, things tend to accelerate or decelerate as they move in the physical world around us since we’re not in a vacuum and there are different factors that tend to impact this. The human brain is wired to expect this kind of motion, so when you’re animating your web apps, you should use this knowledge to your advantage.

There’s terminology that you need to understand:

*   **“ease in” **— this is when a motion starts slowly and then accelerates.
*   **“ease out”** — this is when a motion starts quickly and then decelerates.

These two can be combined, for example “ease in out”.

Easing allows you to make animations feel more natural.

#### Easing keywords

CSS transitions and animations allow you to choose the kind of easing you want to use. There are different keywords that affect the easing of the animation. You can also make your easing completely custom.

Here are some of the keywords that you can use in CSS to control the easing:

*   `linear`
*   `ease-in`
*   `ease-out`
*   `ease-in-out`

Let’s go through all of them and see what they really mean.

#### Linear animations

Animations without any kind of easing are referred to as **linear.**

Here is how a graph of a linear transition looks like:

![](https://cdn-images-1.medium.com/max/800/1*M5htfOGgza04ISv_l-69zg.png)

As time goes by, the value increases in equal amounts. With linear motion, things tend to feel unnatural. Generally speaking, you should avoid linear motion.

This is how a simple linear animation can be achieved:

`transition: transform 500ms linear;`

#### Ease-out animations

As mentioned earlier, easing out causes the animation to start more quickly compared to the linear ones, while it slows down at the end. This is how its graph looks like:

![](https://cdn-images-1.medium.com/max/800/1*VDWQl67cmbyAFC5xL9Og4g.png)

In general, easing out is best used for UI work because the quick start gives your animations a feeling of responsiveness, while the slow-down at the end feels natural due to the inconsistent motion.

There are many ways to achieve an ease out effect, but the simplest is the `ease-out` keyword in CSS:

```
transition: transform 500ms ease-out;
```

#### Ease-in animations

These are the opposite of the ease-out animations — they start slowly and end fast. This is how their graph looks like:

![](https://cdn-images-1.medium.com/max/800/1*rWh8YlBn8SypiMduLiYDhA.png)

Compared to ease-out animations, ease-ins can feel unusual because they create a feeling of unresponsiveness since they start slowly. The fast end can also create a strange feeling, since the whole animation is accelerating while objects in the real world tend to decelerate when stopping suddenly.

To use an ease-in animation, similarly to ease-out and linear animations, you can use its keyword:

```
transition: transform 500ms ease-in;
```

#### Ease-in-out animations

This animations is a combination of ease-in and ease-out. This is how its graph looks like:

![](https://cdn-images-1.medium.com/max/800/1*tGXhNroe8KxGN7r4UTVSHw.png)

Don’t use animation durations that are too long, as they make it feel as if your UI is unresponsive.

To get an ease-in-out animation, you can use the `ease-in-out` CSS keyword:

```
transition: transform 500ms ease-in-out;
```

#### Custom easing

You can define you own easing curves which provides a lot more control over the feel your project’s animations create.

In reality, the `ease-in`, `ease-out`, `linear`, `ease` keywords map to predefined [Bézier curves](https://en.wikipedia.org/wiki/B%C3%A9zier_curve), which are detailed in the [CSS transitions specification](http://www.w3.org/TR/css3-transitions/) and the [Web Animations specification](https://w3c.github.io/web-animations/#scaling-using-a-cubic-bezier-curve).

#### Bézier curves

Let’s see hоw Bézier curves work. A Bézier curve takes four values, or more precisely it takes two pairs of numbers. Each pair describes the X and Y coordinates of a cubic Bézier curve’s control point. The starting point of the Bézier curve has a coordinate (0, 0) and the end coordinate is (1, 1). You can set both of the pair numbers. The X values for the two control points must be in the [0, 1] range, and each control point’s Y value can exceed the [0, 1] limit, although the spec isn’t clear by how much.

Even slight changes in the X and Y value of each control point gives you a completely different curve. Let’s take a look at two graphs of Bézier curves with points having close but different coordinates.

![](https://cdn-images-1.medium.com/max/800/1*2v7G1ZJ1C-y_mWHOYQfQKQ.png)

and

![](https://cdn-images-1.medium.com/max/800/1*P5nzyldL4rg36dZmt2RViQ.png)

As you see, the graphs are quite different. The first control points have a
(0.045, 0.183) vector difference, while the second control points have a (-0.427, -0.054) difference.

This is how the CSS for the second curve looks like:

```
transition: transform 500ms cubic-bezier(0.465, 0.183, 0.153, 0.946);
```

The first two numbers are the X and Y coordinates of the first control point, and the second two numbers are the X and Y coordinates of the second control point.

### Performance optimizations

You should maintain 60fps whenever you are animating, otherwise it will negatively impact your users’ experience.

As everything else in the world, animations do not come free. Animating some properties is cheaper than others. For example, animating `width` and `height` of an element changes its geometry and may cause other elements on the page to move or change size. This process is called layout. We have discussed layout and rendering in more detail in one of our [previous posts](https://blog.sessionstack.com/how-javascript-works-the-rendering-engine-and-tips-to-optimize-its-performance-7b95553baeda).

In general, you should avoid animating properties that trigger layout or paint. For most modern browsers, this means limiting animations to `opacity` and `transform.`

#### Will-change

You can use `[will-change](https://dev.w3.org/csswg/css-will-change/)` to inform the browser that you intend to change an element’s property. This allows the browser to put the most appropriate optimizations in place ahead of when you make the change. Don’t overuse `will-change`, however, because doing so can cause the browser to waste resources, which in turn causes even more performance issues.

Adding `will-change` for transforms and opacity looks like this:

```
.box {  will-change: transform, opacity;}
```

The browser support for Chrome, Firefox and Opera is quite good.

![](https://cdn-images-1.medium.com/max/800/1*eyaMLcORDVsCFIf5h_ygjA.png)

#### Choosing between JavaScript and CSS

You probably saw it coming already — there is no right or wrong answer to this question. You just have to keep the following things in mind:

*   CSS-based animations, and Web Animations where supported natively, are typically handled on a thread known as the “compositor thread.” It’s different from the browser’s “main thread”, where styling, layout, painting, and JavaScript are executed. This means that if the browser is running some expensive tasks on the main thread, these animations can keep going without being interrupted.
*   Changes to `transforms` and `opacity` can, in many cases, also be handled by the compositor thread.
*   If any animation triggers paint, layout, or both, the “main thread” will be required to do work. This is true for both CSS- and JavaScript-based animations, and the overhead of layout or paint will likely dwarf any work associated with CSS or JavaScript execution, rendering the question moot.

#### Choose the right things to animate

Great animations add a layer of enjoyment and engagement to your projects for your users. You can animate pretty much anything you like, whether that’s widths, heights, positions, colors, or backgrounds, but you need to be aware of potential performance bottlenecks. Poorly chosen animations can negatively affect user experience, so animations need to be both performant and appropriate. Animate as less as possible. Animate only to make your UX feel natural but don’t over-animate.

#### Use animations to support interactions

Don’t just animate something because you can. Instead, use strategically placed animations to _reinforce_ the user interactions. Avoid animations that interrupt or obstruct the user’s activity unnecessarily.

#### Avoid animating expensive properties

The only thing worse than animations that are poorly placed are those that cause the page to stutter. This type of animation leaves users feeling frustrated and unhappy.

We go pretty easy on using animations in [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=blog&utm_content=js-series-rendering-engine-outro). In general, we follow the practices mentioned above but we also have a few more scenarios where we utilize animations due to the complexity of our UI. SessionStack has to recreate as a video everything that happened to end users at the time they experienced an issue while browsing a web app. To do this, SessionStack leverages only the data that was collected by our library during the session: user events, DOM changes, network requests, exceptions, debug messages, etc. Our player is highly optimized to properly render and make use of all the collected data in order to offer a pixel-perfect simulation of end users’ browser and everything that happened in it, both from a visual and technical standpoint.

To ensure the replication feels natural, especially with long and heavy user sessions, we use animations to properly indicate loading/buffering and follow best practices on how to implement them so that we don’t take up too much CPU time and leave the event loop free to render the sessions.

There is a free plan if you’d like to [give SessionStack a try](https://www.sessionstack.com/signup/).

![](https://cdn-images-1.medium.com/max/800/0*h2Z_BnDiWfVhgcEZ.)

#### Resources

*   [https://developers.google.com/web/fundamentals/design-and-ux/animations/css-vs-javascript](https://developers.google.com/web/fundamentals/design-and-ux/animations/css-vs-javascript)
*   [https://developers.google.com/web/fundamentals/design-and-ux/animations/](https://developers.google.com/web/fundamentals/design-and-ux/animations/)
*   [https://developers.google.com/web/fundamentals/design-and-ux/animations/animations-and-performance](https://developers.google.com/web/fundamentals/design-and-ux/animations/animations-and-performance)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
