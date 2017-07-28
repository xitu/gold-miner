> * 原文地址：[An Animated Intro to RxJS](https://css-tricks.com/animated-intro-rxjs/)
> * 原文作者：[David Khourshid](https://css-tricks.com/author/davidkpiano/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [luoyaqifei](http://www.zengmingxia.com)
> * 校对者：[vuuihc](https://github.com/vuuihc)，[AceLeeWinnie](https://github.com/AceLeeWinnie)

# 看动画，学 RxJS

你以前可能听过 RxJS、ReactiveX、响应式编程，或者只是函数式编程。当我们谈论最新的、最伟大的前端技术时，这些术语正变得越来越重要。如果你的学习心路像我一样，那么你在最开始学习它时一定也是一头雾水。

根据 [ReactiveX.io](http://reactivex.io/)：

> ReactiveX 是一个库，它使用可观察（observable）序列，用于组织异步的、基于事件的程序。

单单在这句话里，就有许多值得我们琢磨的东西。在本文中，通过创建 **响应式动画**，我们将采用一种不同的做法来学习 RxJS（ReactiveX 的 JavaScript 实现）和 Observable（可观察对象）。

### 理解 Observable

数组即元素集合，比如说 `[1, 2, 3, 4, 5]`。你能够马上拿到所有的元素，并且可以对它们做一些诸如 [map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/map) 和 [filter](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter) 这样的操作。这使得你可以将元素集合用你想要的方式转换。

现在假定数组里的每个元素 **伴随时间流动** 出现，也就是说，你不是马上拿到所有的元素，而是一次拿到一个。你可能在第一秒拿到第一个元素，第三秒拿到下一个，诸如此类。就像图中展现的这样：

![](https://cdn.css-tricks.com/wp-content/uploads/2017/02/rx-article-1.svg)
这就被称为数据流，或者是事件序列，或者更加贴切地说，一个 **observable**。

一个 **observable** 就是一个伴随着时间流动的数据集合。

就像对数组做的那些操作一样，你可以对这些数据进行 map、filter 或者做些其他的操作，来创建和组合新的 observable。最后，你还可以 subscribe（订阅）到这些 observable 上，来对最后的数据流进行你想要的任何操作。这些就是 RxJS 的用武之处。

### RXJS 上手

开始使用 [RxJS](http://reactivex.io/rxjs/) 最简单的方式是使用 CDN，尽管根据你的项目需求，有 [很多安装它的方法](http://reactivex.io/rxjs/manual/installation.html)。

```
HTML

<!-- 最新的，最小化后的 RxJS 版本-->
<scriptsrc="https://unpkg.com/@reactivex/rxjs@latest/dist/global/Rx.min.js"></script>

```

一旦你的项目里有了 RxJS，你可以从 **任何东西** 开始创建一个 observable：

```
JS

const aboutAnything = 42;

// 从 just about anything（单个数据）创建。
// observable 发送这个数据，然后完成。
const meaningOfLife$ = Rx.Observable.just(aboutAnything);

// 从一个数组或一个可迭代对象创建。
// observable 发送数组中的每个元素，然后完成。
const myNumber$ = Rx.Observable.from([1, 2, 3, 4, 5]);

// 从一个 promise 创建。
// observable 发送最终的结果，然后完成（或者抛出错误）。
const myData$ = Rx.Observable.fromPromise(fetch('http://example.com/users'));

// 从一个事件创建。
// observable 连续地发送事件监听器上的事件。
const mouseMove$ = Rx.Observable
  .fromEvent(document.documentElement, 'mousemove');
```

**注意：变量后的美元符(`$`)只是一个约定，用于表明这个变量是 observable。** observable 可以被用于代表任何可以用伴随时间流动的数据流表示的东西，比如事件、Promise、定时执行函数、间隔执行函数和动画。

现在创建的这些 observable 并不做任何有意义的事，除非你真正地 **observe** 它们。**subscription** 就是做这个的，可以用 `.subscribe()` 来创建它。

```
JS

// 只要我们从 observable 收到一个数，
// 就将它打印在控制台上。
myNumber$.subscribe(number => console.log(number));

// 结果：
// > 1
// > 2
// > 3
// > 4
// > 5
```

让我们在实战中来学习下：

[codepen](http://codepen.io/davidkpiano/pen/d6f5fa72a9b7b6c2c9141de6fa1ab93f)

```
JS

const docElm = document.documentElement;
const cardElm = document.querySelector('#card');
const titleElm = document.querySelector('#title');

const mouseMove$ = Rx.Observable
  .fromEvent(docElm, 'mousemove');

mouseMove$.subscribe(event => {
  titleElm.innerHTML = `${event.clientX}, ${event.clientY}`
});
```

通过 `mouseMove$` observable，每一次 `mousemove` 事件发生，subscription 将 `titleElm` 的 `.innerHTML` 更改为鼠标的当前位置。[`.map`](http://reactivex.io/rxjs/class/es6/Observable.js%7EObservable.html#instance-method-map) 操作符（与 `Array.prototype.map` 的工作机制类似）可以帮助简化这段代码：

```
JS

// 产生如 {x: 42, y: 100} 这种结果，而不是整个事件
const mouseMove$ = Rx.Observable
  .fromEvent(docElm, 'mousemove')
  .map(event => ({ x: event.clientX, y: event.clientY }));
```

使用一点点计算和内联样式，你可以让卡片跟着鼠标旋转。`pos.y / clientHeight` 和 `pos.x / clientWidth` 的值都在 0 到 1 之间，所以乘上 50 再减掉一半（25）会产生 -25 到 25 之间的值，也就是我们的旋转值所需要的：

[codepen](http://codepen.io/davidkpiano/pen/55cb38a26b9166c41017c6512ea00209)

```
JS

const docElm = document.documentElement;
const cardElm = document.querySelector('#card');
const titleElm = document.querySelector('#title');

const { clientWidth, clientHeight } = docElm;

const mouseMove$ = Rx.Observable
  .fromEvent(docElm, 'mousemove')
  .map(event => ({ x: event.clientX, y: event.clientY }))

mouseMove$.subscribe(pos => {
  const rotX = (pos.y / clientHeight * -50) - 25;
  const rotY = (pos.x / clientWidth * 50) - 25;

  cardElm.style = `
    transform: rotateX(${rotX}deg) rotateY(${rotY}deg);
  `;
});
```

### 使用 `.merge` 进行结合

现在你如果想要响应鼠标移动，并在触摸设备上响应触摸移动，你可以使用 RxJS 用不同的方式来结合 observable，不会再有任何因为回调带来的混乱。在这个例子里，我们将使用 [`.merge`](http://reactivex.io/documentation/operators/merge.html) 操作符。就像将多个车道融入单个车道，这将返回单个 observable，其中包含了从多个 observable 融合来的所有数据。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/02/merge.png)

	JS

    const touchMove$ = Rx.Observable
      .fromEvent(docElm,'touchmove').map(event =>({
        x: event.touches[0].clientX,
        y: event.touches[0].clientY
      }));
    const move$ = Rx.Observable.merge(mouseMove$, touchMove$);

    move$.subscribe(pos =>{// ...});

继续，尝试着在触摸设备上左右平移：

[codepen](http://codepen.io/davidkpiano/pen/4a430c13f4faae099e5a34cb2a82ce6d)

也有一些别的 [有用的用于组合 observable 的操作符](http://reactivex.io/documentation/operators.html#combining)，譬如`.switch()`，`.combineLatest()` 和 `.withLatestFrom()`，我们接下来会讨论这些。

### 加入平滑运动（Smooth Motion）

因为旋转卡片实现得太简洁，其运动有一点点生硬。无论什么时候鼠标（或手指）一停，旋转戛然而止。为了补救这点，可以使用线性插值（LERP）。Rachel Smith 的 [这个教程](https://codepen.io/rachsmith/post/animation-tip-lerp) 里描述了这种通用技术。从本质上说，不再直接从 A 点跳到 B 点，LERP 将在每个动画帧上走一部分路。这就产生了平滑的过渡，即使鼠标／触摸已经停止。

让我们创建一个函数，这个函数有一个职责：给定一个开始值和一个结束值，使用 LERP 计算下一个值：

```
JS

function lerp(start, end) {
  const dx = end.x - start.x;
  const dy = end.y - start.y;

  return {
    x: start.x + dx * 0.1,
    y: start.y + dy * 0.1,
  };
}
```

很短小但是很棒的一段代码。我们有一个 **纯** 函数，每次返回一个新的、线性插值后的位置值，通过在每个动画帧将当前（开始）位置移动 10% 来靠近下一个（结束）位置。

#### Scheduler 和 `.interval`

现在的问题是，我们怎么在 RxJS 里表示动画帧？答案是，RxJS 有一个叫做 **Scheduler** 的东西，它可以控制数据 **什么时候** 从一个 observable 被发送，以及一些其他功能，比如什么时候 subscription 应该开始接收数据。

使用 [`Rx.Observable.interval()`](http://reactivex.io/documentation/operators/interval.html)，你可以创建一个在规律定时的间隔上发送数据的 observable，比如每一秒（`Rx.Observable.interval(1000)`）。如果你创建一个微小的间隔，比如 `Rx.Observable.interval(0)` ，并将它定时为只在使用了 `Rx.Scheduler.animationFrame` 的每个动画帧上发送数据的话，一个数据将会每 16 到 17 毫秒被发送，就像你希望的那样，在一个动画帧内：

```
JS

const animationFrame$ = Rx.Observable.interval(0, Rx.Scheduler.animationFrame);
```

#### 使用 `.withLatestFrom` 进行结合

为了创建一个平滑的线性插值，你只需要关心在 **每个动画帧** 的最新的鼠标／触摸位置。可以使用操作符 [`.withLatestFrom()`](http://reactivex.io/rxjs/class/es6/Observable.js%7EObservable.html#instance-method-withLatestFrom) 来实现：

```
JS

const smoothMove$ = animationFrame$
  .withLatestFrom(move$, (frame, move) => move);
```

现在，`smoothMove$` 是一个新的 observable，**只有** 当 `animationFrame$` 发送一个数据时，才会从 `move$` 发送最新的数据。这也是我们想要的——你不想要数据从动画帧外被发送（除非你实在喜欢卡顿）。第二个参数是一个函数，其描述了与每个 observable 最新的数据结合时需要做什么。在这种情况下，唯一重要的值是 `move` 值，也就是返回的所有东西。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/02/with-latest-from.png)

#### 使用 `.scan` 进行过渡

既然你有一个 observable ，它能在每个动画帧上从 `move$` 发送最新的数据，是时候加入线性插值了。如果指定一个传入当前和下一个值的函数[`.scan()`](http://reactivex.io/documentation/operators/scan.html) 操作符会从一个 observable 中「累积」这些值。

![](https://cdn.css-tricks.com/wp-content/uploads/2017/02/scan.png)

对于我们的线性插值用例来说，这是最好不过的了。记住我们的 `lerp(start, end)` 函数传入两个参数：`start`（当前）值和 `end`（下一个）值。

```
JS

const smoothMove$ = animationFrame$
  .withLatestFrom(move$, (frame, move) => move)
  .scan((current, next) => lerp(current, next));
  // or simplified: .scan(lerp)
```

现在，你可以 subscribe 到 `smoothMove$` 上，而不是 `move$` 上，从而在动作中看到线性插值：

[codepen](http://codepen.io/davidkpiano/pen/YNOoEK)

### 总结

RxJS **不** 是一个动画库，这是自然，但是使用可组合的、描述式的方式来处理伴随时间流动的数据，对于 ReactiveX 而言是一个核心概念，因此动画是一种能很好地展现这个技术的方式。响应式编程是另一种编程的思维方式，有许多优点：

- 它是声明式的、可组合的，以及不可变的，这避免了回调地狱，让你的代码更加简洁、可复用以及模块化。
- 它在处理任何类型的异步数据上都很有用，无论是获取数据、通过 WebSockets 通信，从多个源头监听外部事件，还是动画。
- “关注点分离”——你使用 Observable 和操作符声明式地表示你想要的数据，然后在一个单独的 `.subscribe()` 里处理副作用，而不是将这些在你的代码库里洒得到处都是。
- 有 **如此多** 语言的实现——Java、PHP、Python、Ruby、C#、Swift，以及别的你甚至没听过的语言。
- 它 **不是一个框架**，很多流行框架（比如 React，Angular 和 Vue）都跟它一起工作得很好。
- 如果你想的话，你可以得到很酷的点，但是 ReactiveX 最早在接近十年以前（2009）被实现，从 [Conal Elliott 和 Paul Hudak](http://conal.net/papers/icfp97/) **二** 十年以前（1997）的想法中被提出，这个想法描述的是函数式响应式动画（真是惊奇啊真是惊奇）。不用说，它是经过战斗考验的。

本文探索了一系列 RxJS 中有用的部分和概念——使用 `.fromEvent()` 和 `.interval()` 创建 observable，使用 `.map()` 和 `.scan()` 操作 observable，使用 `.merge()` 和 `.withLatestFrom()` 结合多个 observable，以及使用 `Rx.Scheduler.animationFrame` 引入 scheduler。以下是一些学习 RxJS 的其他有用资源：

- [ReactiveX: RxJS](http://reactivex.io/rxjs/) - 官方文档
- [RxMarbles](http://rxmarbles.com/) - 用于可视化 observable
- Andre Staltz 写的 [你曾错过的响应式编程入门](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)

如果你想要在 RxJS 的动画上钻得更深的话（并且使用 CSS 变量变得更加声明式），可以查看 [我在 2016 年 CSS 开发大会上的幻灯片](http://slides.com/davidkhourshid/reactanim#/) 和 [我在 2016 年 JSConf Iceland 上的讲话](https://www.youtube.com/watch?v=lTCukb6Zn3g)。为了给你更多灵感，这里有一些使用了 RxJS 来做动画的代码：

- [3D 数字时钟](http://codepen.io/davidkpiano/pen/Vmyyzd)
- [心率 app 概念](http://codepen.io/davidkpiano/pen/mAoaxP)
- [使用 RxJS 的透镜式拖动](http://codepen.io/Enki/pen/eBwKgO)
