> * 原文地址：[React at Light Speed](https://blog.vixlet.com/react-at-light-speed-78cd172a6411)
> * 原文作者：本文已获原作者 [Jacob Beltran](https://blog.vixlet.com/@jacob_beltran) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[ZhangFe](https://github.com/ZhangFe)
> * 校对者：[yzgyyang](https://github.com/yzgyyang),[xunge0613](https://github.com/xunge0613)

# 光速 React #

## Vixlet 团队优化性能的经验教训 ##

![](https://cdn-images-1.medium.com/max/1000/1*SJzLm3SW2IegLw0GzlaG-w.jpeg)

在过去一年多，我们 [Vixlet](http://www.vixlet.com) 的 web 团队已经着手于一个激动人心的项目：将我们的整个 web 应用迁移到 React + Redux 架构。对于整个团队来说，这是不断增长的机遇，而在迁移过程中，我们一路风雨兼程。

因为我们的 web-app 可能有非常大的 feed 视图，包括成百上千的媒体、文本、视频、链接元素，我们花了相当多的时间寻找能充分利用 React 性能的方法。在这里，我们将分享我们这一路学到的一些经验教训。

**声明**：**下面讲的做法和方法更适用于我们具体应用的性能需求。然而，像所有的开发者建议的那样，最重要的是要考虑到你的应用程序和团队的实际需求。React 是一个开箱即用的框架，所以你可能不需要像我们一样细致地优化性能。话虽如此，我们还是希望你能在这篇文章里找到一些有用的信息。**

### 基本原理 ###

![](https://cdn-images-1.medium.com/max/800/1*UOGdUM1V_rGUbxLS-eaWdQ.gif)

向更大的世界迈出第一步。

#### render() 函数 ####

一般来说，要尽可能少地在 render 函数中做操作。如果非要做一些复杂操作或者计算，也许你可以考虑使用一个 [memoized](https://en.wikipedia.org/wiki/Memoization) 函数以便于缓存那些重复的结果。可以看看 [Lodash.memoize](https://lodash.com/docs#memoize)，这是一个开箱即用的记忆函数。

反过来讲，避免在组件的 state 上存储一些容易计算的值也很重要。举个例子，如果 props 同时包含 `firstName` 和 `lastName`，没必要在 state 上存一个 `fullName`，因为它可以很容易通过提供的 props 来获取。如果一个值可以通过简单的字符串拼接或基本的算数运算从 props 派生出来，那么没理由将这些值包含在组件的 state 上。

#### Prop 和 Reconciliation ####

重要的是要记住，只要 props（或 state）的值不等于之前的值，React 就会触发重新渲染。如果 props 或者 state 包含一个对象或者数组，嵌套值中的任何改变也会触发重新渲染。考虑到这一点，你需要注意在每次渲染的生命周期中，创建一个新的 props 或者 state 都可能无意中导致了性能下降。
PS:译者对这段保留意见，对象或者数组只要引用不变，是不会触发rerender的，是我翻译有误还是原文的错误？

**例子:** **函数绑定的问题**

```
/*
给 prop 传入一个行内绑定的函数（包括 ES6 箭头函数）实质上是在每次父组件 render 时传入一个新的函数。
*/
render() {
  return (
    <div>
      <a onClick={ () => this.doSomething() }>Bad</a>
      <a onClick={ this.doSomething.bind( this ) }>Bad</a>
    </div>
  );
}


/*
应该在构造函数中处理函数绑定并且将已经绑定好的函数作为 prop 的值
*/

constructor( props ) {
  this.doSomething = this.doSomething.bind( this );
  //or
  this.doSomething = (...args) => this.doSomething(...args);
}
render() {
  return (
    <div>
      <a onClick={ this.doSomething }>Good</a>
    </div>
  );
}
```

**例子:** **对象或数组字面量**

```
/*
对象或者数组字面量在功能上来看是调用了 Object.create() 和 new Array()。这意味如果给 prop 传递了对象字面量或者数组字面量。每次render 时 React 会将他们作为一个新的值。这在处理 Radium 或者行内样式时通常是有问题的。
*/

/* Bad */
// 每次渲染时都会为 style 新建一个对象字面量
render() {
  return <div style={ { backgroundColor: 'red' } }/>
}

/* Good */
// 在组件外声明
const style = { backgroundColor: 'red' };

render() {
  return <div style={ style }/>
}
```

**例子** **: 注意兜底值字面量**

```
/*
有时我们会在 render 函数中创建一个兜底的值来避免 undefined 报错。在这些情况下，最好在组件外创建一个兜底的常量而不是创建一个新的字面量。
/*
/* Bad */
render() {
  let thingys = [];
  // 如果 this.props.thingys 没有被定义，一个新的数组字面量会被创建
  if( this.props.thingys ) {
    thingys = this.props.thingys;
  }

  return <ThingyHandler thingys={ thingys }/>
}

/* Bad */
render() {
  // 这在功能上和前一个例子一样
  return <ThingyHandler thingys={ this.props.thingys || [] }/>
}

/* Good */

// 在组件外部声明
const NO_THINGYS = [];

render() {
  return <ThingyHandler thingys={ this.props.thingys || NO_THINGYS }/>
}
```

#### 尽可能的保持 Props（和 State）简单和精简 ####

理想情况下，传递给组件的 props 应该是它直接需要的。为了将值传给子组件而将一个大的、复杂的对象或者很多独立的 props 传递给一个组件会导致很多不必要的组件渲染（并且会增加开发复杂性）。

在 Vixlet，我们使用 Redux 作为状态容器，所以在我们看来，最理想的是方案在组件层次结构的每一个层级中使用 [react-redux](https://www.npmjs.com/package/react-redux) 的 [connect()](https://github.com/reactjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options) 函数直接从 store 上获取数据。connect 函数的性能很好，并且使用它的开销也非常小。

#### 组件方法 ####

由于组件方法是为组件的每个实例创建的，如果可能的话，使用 helper/util 模块的纯函数或者[静态类方法](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes)。尤其在渲染大量组件的应用中会有明显的区别。

### 进阶 ###

![](https://cdn-images-1.medium.com/max/800/1*9n2fdJB1gPYLFJAj5D5RqA.gif)

在我看来视图的变化是邪恶的！

#### shouldComponentUpdate() ####

React 有一个生命周期函数 [shouldComponentUpdate()](https://facebook.github.io/react/docs/react-component.html#shouldcomponentupdate)。这个方法可以根据当前的和下一次的 props 和 state 来通知这个 React 组件是否应该被重新渲染。

然而使用这个方法有一个问题，开发者必须考虑到需要触发重新渲染的每一种情况。这会导致逻辑复杂，一般来说，会非常痛苦。如果非常需要，你可以使用一个自定义的  `shouldComponentUpdate()` 方法，但是很多情况下有更好的选择。

#### React.PureComponent ####

React 从 v15 开始会包含一个 PureComponent 类，它可以被用来构建组件。`React.PureComponent` 声明了它自己的 `shouldComponentUpdate()` 方法，它自动对当前的和下一次的 props 和 state 做一次浅对比。有关浅对比的更多信息，请参考这个 Stack Overflow：

[http://stackoverflow.com/questions/36084515/how-does-shallow-compare-work-in-react](http://stackoverflow.com/questions/36084515/how-does-shallow-compare-work-in-react)

在大多数情况下，`React.PureComponent` 是比 `React.Component` 更好的选择。在创建新组件时，首先尝试将其构建为纯组件，只有组件的功能需要时才使用 `React.Component`。

更多信息，请查阅相关文档 [React.PureComponent](https://facebook.github.io/react/docs/react-api.html#react.purecomponent)。

#### 组件性能分析（在 Chrome 里）

在新版本的 Chrome 里，timeline 工具里有一个额外的内置功能可以显示哪些 React 组件正在渲染以及他们花费的时间。要启用此功能，将 `?react_perf` 作为要测试的 URL 的查询字符串。React 渲染时间轴数据将位于 User Timing 部分。

更多相关信息，请查阅官方文档：[Profiling Components with Chrome Timeline](https://facebook.github.io/react/docs/optimizing-performance.html#profiling-components-with-chrome-timeline) 。

#### 有用的工具: [why-did-you-update](https://www.npmjs.com/package/why-did-you-update) ####

这是一个很棒的 NPM 包，他们给 React 添加补丁，当一个组件触发了不必要的重新渲染时，它会在控制台输出一个 console 提示。

**注意**: 这个模块在初始化时可以通过一个过滤器匹配特定的想要优化的组件，否则你的命令行可能会被垃圾信息填满，并且可能你的浏览器会挂起或者崩溃，查阅 [why-did-you-update 文档](https://www.npmjs.com/package/why-did-you-update)获取更多详细信息。

### 常见性能陷阱

![](https://cdn-images-1.medium.com/max/800/1*GVteDSQnhXZCSui8JRp10A.gif)

#### setTimeout() 和 setInterval() ####

在 React 组件中使用 `setTimeout()` 或者  `setInterval()` 要十分小心。几乎总是有更好的选择，例如 'resize' 和 'scroll' 事件（注意：有关注意事项请参阅下一节）。

如果你需要使用 `setTimeout()` 和 `setInterval()`，你必须**遵守下面两条建议**

> 不要设置过短的时间间隔。

当心那些小于 100 ms 的定时器，他们很可能是没意义的。如果确实需要一个更短的时间，可以使用 [window.requestAnimationFrame()](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame)。

> 保留对这些函数的引用，并且在 unmount 时取消或者销毁他们。

`setTimeout()` 和 `setInterval()` 都返回一个延迟函数的引用，并且需要的时候可以取消它们。由于这些函数是在全局作用域执行的，他们不在乎你的组件是否存在，这会导致报错甚至程序卡死。

**注意**: 对 `window.requestAnimationFrame()` 来说也是如此

解决这个问题最简答的方法是使用 [react-timeout](https://www.npmjs.com/package/react-timeout) 这个 NPM 包，它提供了一个可以自动处理上述内容的高阶组件。它将 setTimeout/setInterval 等功能添加到包装组建的 props 上。(**特别感谢 Vixlet 的开发人员 [*Carl Pillot*](https://twitter.com/@carlpillot) 提供这个方法**)

如果你不想引入这个依赖，并且希望自行解决此问题，你可以使用以下的方法：

```
// 如何正确取消 timeouts/intervals

compnentDidMount() {
 this._timeoutId = setTimeout( this.doFutureStuff, 1000 );
 this._intervalId = setInterval( this.doStuffRepeatedly, 5000 );
}
componentWillUnmount() {
 /*
   高级提示：如果操作已经完成，或者值未被定义，这些函数也不会报错
 */
 clearTimeout( this._timeoutId );
 clearInterval( this._intervalId );
}
```


如果你使用 requestAnimationFrame() 执行的一个动画循环，可以使用一个非常相似的解决方案，当前代码要有一点小的修改：

```
// 如何确保我们的动画循环在组件消除时结束

componentDidMount() {
  this.startLoop();
}

componentWillUnmount() {
  this.stopLoop();
}

startLoop() {
  if( !this._frameId ) {
    this._frameId = window.requestAnimationFrame( this.loop );
  }
}

loop() {
  // 在这里执行循环工作
  this.theoreticalComponentAnimationFunction()
  
  // 设置循环的下一次迭代
  this.frameId = window.requestAnimationFrame( this.loop )
}

stopLoop() {
  window.cancelAnimationFrame( this._frameId );
  // 注意: 不用担心循环已经被取消
  // cancelAnimationFrame() 不会抛出异常
}
```

#### 未去抖频繁触发的事件 ####

某些常见的事件可能会非常频繁的触发，例如 `scroll`，`resize`。去抖这些事件是明智的，特别是如果事件处理程序执行的不仅仅是基本功能。

Lodash 有 [_.debounce](https://lodash.com/docs/#debounce) 方法。在 NPM 上还有一个独立的 [debounce](https://www.npmjs.com/package/debounce) 包.

> “但是我真的需要立即反馈 scroll/resize 或者别的事件”

我发现一种可以处理这些事件并且以高性能的方式进行响应的方法，那就是在第一次事件触发时启动 `requestAnimationFrame()` 循环。然后可以使用 `[debounce()](https://lodash.com/docs#debounce)` 方法并且将 `trailing` 这个配置项设为 `true`（**这意味着该功能只在频繁触发的事件流结束后触发**）来取消对值的监听，看看下面这个例子。

```
class ScrollMonitor extends React.Component {
  constructor() {
    this.handleScrollStart = this.startWatching.bind( this );
    this.handleScrollEnd = debounce(
      this.stopWatching.bind( this ),
      100,
      { leading: false, trailing: true } );
  }

  componentDidMount() {
    window.addEventListener( 'scroll', this.handleScrollStart );
    window.addEventListener( 'scroll', this.handleScrollEnd );
  }

  componentWillUnmount() {
    window.removeEventListener( 'scroll', this.handleScrollStart );
    window.removeEventListener( 'scroll', this.handleScrollEnd );
    
    //确保组件销毁后结束循环
    this.stopWatching();
  }

  // 如果循环未开始，启动它
  startWatching() {
    if( !this._watchFrame ) {
      this.watchLoop();
    }
  }

  // 取消下一次迭代
  stopWatching() {
    window.cancelAnimationFrame( this._watchFrame );
  }

  // 保持动画的执行直到结束
  watchLoop() {
    this.doThingYouWantToWatchForExampleScrollPositionOrWhatever()

    this._watchFrame = window.requestAnimationFrame( this.watchLoop )
  }

}
```

#### 密集CPU任务线程阻塞 ####

某些任务一直是 CPU 密集型的，因此可能会导致主渲染线程的阻塞。举几个例子，比如非常复杂的数学计算，迭代非常大的数组，使用 `File` api 进行文件读写，利用 `<canvas>` 对图片进行编码解码。

在这些情况下，如果有可能最好使用 Web Worker 将这些功能移到另一个线程上，这样我们的主渲染线程可以保持顺滑。

**相关阅读**

MDN 文章: [Using Web Workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers)

MDN 文档: [Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Worker)

### 结语 ###

我们希望上述建议对您能有所帮助。如果没有 Vixlet 团队的伟大工作和研究，上述的提示和编程技巧是不可能产出的。他们真的是我曾经合作过的最棒的团队之一。

在你的 React 的征途中保持学习和练习，愿原力与你同在！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


