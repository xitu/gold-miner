> * 原文地址：[Scheduling in React](https://philippspiess.com/scheduling-in-react/)
> * 原文作者：[Philipp Spiess](https://github.com/philipp-spiess)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/scheduling-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/scheduling-in-react.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[portandbridge](https://github.com/portandbridge), [Reaper622](https://github.com/Reaper622)

# React 中的调度

在现代的应用程序中，用户界面通常要同时处理多个任务。例如，一个搜索组件可能要在响应用户输入的同时自动补全结果，一个交互式仪表盘可能需要在从服务器加载数据并将分析数据发送到后端的同时更新图表。

所有这些并行的步骤都有可能导致交互界面响应缓慢甚至无响应，拉低用户的满意度，所以让我们学习下如何解决这个问题。

## 用户界面中的调度

我们的用户期望及时反馈。无论是点击打开模态框的按钮还是在输入框中添加文字，他们都不想在看到某种确认状态之前进行等待。例如，点击按钮可以立即打开模态框，输入框可以立即显示刚刚输入的关键字。

为了想象在并行操作下会发生什么，让我们来看看 Dan Abramov 在 JSConf Iceland 2018 上以[超越 React 16](https://reactjs.org/blog/2018/03/01/sneak-peek-beyond-react-16.html) 为主题的演讲中演示的应用程序。

这个应用程序的工作原理如下：你在输入框中的输入越多，下面的图表中的细节就会越多。由于两个更新（输入框和图表）同时进行，所以浏览器必须进行大量计算以至于会丢弃其中的一些帧。这会导致明显的延时以及糟糕的用户体验。

![](https://ws3.sinaimg.cn/large/006tKfTcgy1g1fyziynqqj31180nytwy.jpg)

[视频地址](https://philippspiess.com/blog/scheduling-in-react/sync-mode.mp4)

但是，当有新键入时，优先更新用户界面上输入框的版本对用户来说似乎运行得更快。因为用户能收到及时的反馈，尽管它们需要相同的计算时间。

![](https://ws4.sinaimg.cn/large/006tKfTcgy1g1fyornqkoj31180n4qch.jpg)

[视频地址](https://philippspiess.com/blog/scheduling-in-react/concurrent-mode.mp4)

不幸的是，当前的用户界面体系架构使得实现这种优先级变得非常重要，解决此问题的一种方法是通过[防抖（debouncing）](https://davidwalsh.name/javascript-debounce-function)进行图表更新。这种方法的问题在于当防抖函数的回调函数执行时，图表依旧在同步地渲染，这会再次导致用户界面在一段时间内无响应。我们可以做的更好！

## 浏览器事件循环

在我们学习如何正确地实现更新优先级之前，让我们深入挖掘并理解浏览器为何在处理用户交互时存在问题。

JavaScript 代码在单线程中执行，意味着在任意给定的时间段内只有一行 JavaScript 代码可以运行。同时，这个线程也负责处理其他文档的生命周期，例如布局和绘制。<sup id="fnref-1">[1](#fn-1)</sup>意味着每当 JavaScript 代码运行时，浏览器会停止做任何其他的事情。

为了保证用户界面的及时响应，在能够接收下一次输入之前，我们只有很短的一个时间段进行准备。在 2018 年的 Chrome Dev 峰会（Chrome Dev Summit 2018）上，Shubhie Panicker 和 Jason Miller 发表了以[保证响应性的追求（A Quest to Guarantee Responsiveness）](https://developer.chrome.com/devsummit/schedule/scheduling-on-off-main-thread)为主题的演讲。在演讲中，他们对浏览器事件循环进行了可视化描述，我们可以看到在绘制下一帧之前我们只有 16ms（在典型的 60Hz 屏幕上），紧接着浏览器就需要处理下一个事件：

[![](https://philippspiess.com/static/805b72e5fe22f38f3f794de9668a14cc/26338/event-loop-browser.png)](/static/805b72e5fe22f38f3f794de9668a14cc/5854f/event-loop-browser.png)

大多数 JavaScript 框架（包括当前版本的 React）将同步进行更新。我们可以将此行为视为一个函数 `render()`，而此函数只有在 DOM 更新后才会返回。在此期间，主线程被阻塞。

## 当前解决方案存在的问题

有了上面的信息，我们可以拟定两个必须解决的问题，以便获得更具响应性的用户界面：

1.  **长时间运行的任务会导致帧丢失。** 我们需要确保所有任务都很小，可以在几毫秒内完成，以便可以在一帧内运行。

2.  **不同的任务有不同的优先级。** 在上面的示例应用程序中，我们看到优先考虑用户输入可以带来更好的整体体验。为此，我们需要一种方法来定义优先级的排序并按照排序进行任务调度。

## 并发的 React 和调度器

**⚠️ 警告：下面的 API 尚不稳定并且会发生变化。我会尽可能地保持更新。**

为了使用 React 实现调度得宜的用户界面，我们必须看看以下两个即将推出的 React 新功能：

*   **并发（Concurrent）React，也称为时间分片（Time Slicing）。** 在 React 16 改写的新 [Fiber 架构](https://www.youtube.com/watch?v=ZCuYPiUIONs)帮助下，React 现在可以允许渲染过程分段完成，中间可以返回<sup id="fnref-2">[2](#fn-2)</sup>至主线程执行其他任务。

    我们将在之后听到更多有关并发 React 的消息。现在重要的是理解，当启用这个模式之后，React 会把同步渲染的 React 组件切分成小块，然后在多个帧上运行。

    ➡️ 使用这个模式，在将来我们就可以将需要长时间渲染的任务分成小任务块。

*   **调度器。** 它是由 React Core 团队开发的通用协作主线程调度程序，可以在浏览器中注册具有不用优先级的回调函数。

    目前，优先级有这么几种：

    *   `Immediate` 立即执行优先级，需要同步执行的任务。
    *   `UserBlocking` 用户阻塞型优先级（250 ms 后过期），需要作为用户交互结果运行的任务（例如，按钮点击）。
    *   `Normal` 普通优先级（5 s 后过期），不必让用户立即感受到的更新。
    *   `Low` 低优先级（10 s 后过期），可以推迟但最终仍然需要完成的任务（例如，分析通知）。
    *   `Idle` 空闲优先级（永不过期），不必运行的任务（例如，隐藏界面以外的内容）。

    每个优先级都有对应的过期时间，这些过期时间是必须的，这样才能确保即使在高优先级任务多得可以连续运行的情况下，优先级较低的任务仍能运行。在调度算法中，这个问题被称为[饥饿（starvation）](https://en.wikipedia.org/wiki/Starvation_(computer_science))。过期时间可以保证每一个调度任务最终都可以被执行。例如，即使我们的应用中有正在运行的动画，我们也不会错过任何一个分析通知。

    在引擎中，调度器将所有已经注册的回调函数按照过期时间（回调函数注册的时间加上该优先级的过期时间）排序然后存储在列表中。接着，调度器将自己注册在浏览器绘制下一帧之后的回调函数里。<sup id="fnref-3">[3](#fn-3)</sup>在这个回调函数中，浏览器将执行尽可能多的已注册回调函数，直到浏览开始绘制下一帧为止。

    ➡️ 通过这个特性，我们可以调度具有不同优先级的任务。

## 方法中的调度

让我们来看看如何使用这些特性让应用程序更具响应性。为此，我们先来看看 [ScheduleTron 3000](https://github.com/philipp-spiess/scheduletron3000)，这是我自己构建的应用程序，它允许用户在姓名列表中高亮搜索词。我们先来看一下它的初始实现：

```
// 应用程序包含一个搜索框以及一个姓名列表。
// 列表的显示内容由 searchValue 状态变量控制。
// 该变量由搜索框进行更新。
function App() {
  const [searchValue, setSearchValue] = React.useState();

  function handleChange(value) {
    setSearchValue(value);
  }

  return (
    <div>
      <SearchBox onChange={handleChange} />
      <NameList searchValue={searchValue} />
    </div>
  );
}

// 搜索框渲染了一个原生的 HTML input 元素，
// 用 inputValue 变量对它进行控制。
// 当一个新的按键按下时，它会首先更新本地的 inputValue 变量，
// 然后它会更新 App 组件的 searchValue 变量，
// 接着模拟一个发向服务器的分析通知。
function SearchBox(props) {
  const [inputValue, setInputValue] = React.useState();

  function handleChange(event) {
    const value = event.target.value;

    setInputValue(value);
    props.onChange(value);
    sendAnalyticsNotification(value);
  };

  return (
    <input
      type="text"
      value={inputValue}
      onChange={handleChange}
    />
  );
}

ReactDOM.render(<App />, container);
```

**ℹ️ 这个例子使用了 [React Hooks](https://reactjs.org/docs/hooks-intro.html)。如果你对这个新特性没有那么熟悉的话，可以看看  [CodeSandbox code](https://codesandbox.io/s/j3zrqpzkr5)。此外，你可能想知道为什么在这个示例中我们使用了两个不同的状态变量。接下来我们一起来找找看原因。**

试试看！在下面的搜索框中输入一个名字（例如，“Ada Stewart”），然后看看它是怎么工作的：

在 [CodeSandbox](https://codesandbox.io/s/j3zrqpzkr5) 中查看

你可能注意到界面响应没有那么快。为了放大这个问题，我故意加长了列表的渲染时间。由于这个列表很大，它会应用程序的性能影响很大。

我们的用户希望得到即时反馈，但是在按下按键后相当长的一段时间内，应用程序是没有响应的。为了了解正在发生的事情，我们来看看开发者工具的 Performance 选项卡。这是当我在输入框中输入姓名“Ada”时录制的屏幕截图：

[![](https://philippspiess.com/static/d8e525b8fc31fdba90634f8577da8301/26338/devtools-sync.png)](/static/d8e525b8fc31fdba90634f8577da8301/3e72c/devtools-sync.png)

我们可以看到有很多红色的三角形，这通常不是什么好信号。对于每一次键入，我们都会看到一个 `keypress` 事件被触发。所有的事件在一帧内被触发，<sup id="fnref-5">[5](#fn-5)</sup>导致帧的持续时间延长到 **733 ms**。这远高于我们 16 ms 的平均帧预算。

在这个 `keypress` 事件中，会调用我们的 React 代码，更新 inputValue 以及 searchValue，然后发送分析通知。反过来，更新后的状态值会致使应用程序重新渲染每一个姓名项。任务相当繁重但是必须完成，如果使用原生的方法，它会阻塞主进程。

改进现在这个状态的第一步是使用并不稳定的并发模式。实现方法是，使用 `<React.unstable_ConcurrentMode>` 组件把我们的 React 树的一部分包裹起来，就像下面这样<sup id="fnref-4">[4](#fn-4)</sup>：

```
- ReactDOM.render(<App />, container);
+ ReactDOM.render(
+  <React.unstable_ConcurrentMode>
+    <App />
+  </React.unstable_ConcurrentMode>,
+  rootElement
+ );
```

但是，在这个例子中，仅仅使用并发模式并不会改变我们的体验。React 仍然会同时收到两个状态值的更新，没办法知道哪一个更重要。

我们想要首先设置 inputValue，然后更新 searchValue 以及发送分析通知，所以我们只需要在开始的时候更新输入框。为此，我们使用了调度器暴露的 API（可以使用 `npm i scheduler` 进行安装）对低优先级的回调函数进行排序：

```
import { unstable_next } from "scheduler";
function SearchBox(props) {
  const [inputValue, setInputValue] = React.useState();

  function handleChange(event) {
    const value = event.target.value;

    setInputValue(value);
    unstable_next(function() {      
      props.onChange(value);      
      sendAnalyticsNotification(value);    
    });  
  }
  
  return <input type="text" value={inputValue} onChange={handleChange} />;
}
```

在我们使用的 API `unstable_next()` 中，所有的 React 更新都会被设置成 `Normal` 优先级，这个优先级低于 `onChange` 监听器内部默认的优先级。

事实上，通过这种改变，我们的输入框响应速度已经快了不少，并且我们打字的时候不会再有帧被丢弃。让我们再看看 Performance 选项卡：

[![](https://philippspiess.com/static/a523aeacdf07611d54568ba07f655d9d/26338/devtools-normal.png)](/static/a523aeacdf07611d54568ba07f655d9d/50025/devtools-normal.png)

我们可以看到需要长时间运行的任务现在被分解成可以在单个帧内完成的较小任务。提示我们有帧丢弃的红色三角也消失了。

但是，分析通知（在上面的截图中高亮的部分）仍然不理想，它依旧在渲染的同时执行。因为我们的用户不会看到这个任务，所以可以给它安排一个更低的优先级。

```
import {
  unstable_LowPriority,
  unstable_runWithPriority,
  unstable_scheduleCallback
} from "scheduler";

function sendDeferredAnalyticsNotification(value) {
  unstable_runWithPriority(unstable_LowPriority, function() {
    unstable_scheduleCallback(function() {
      sendAnalyticsNotification(value);
    });
  });
}
```

如果我们现在在搜索框组件中使用 `sendDeferredAnalyticsNotification()`，然后再次查看 Performance 选项卡，并拖动到末尾，我们可以看到在渲染工作完成后，分析通知才被发送，程序中的所有任务都被完美地调度了：

[![](https://philippspiess.com/static/e5ef87ea4a1dc1f0ef5c1a52776ca343/26338/devtools-normal-and-low.png)](/static/e5ef87ea4a1dc1f0ef5c1a52776ca343/63a84/devtools-normal-and-low.png)

试试看：

在 [CodeSandbox](https://codesandbox.io/s/v0lxm0xlzl) 中查看

## 调度器的限制

使用调度器，我们可以控制回调函数的执行顺序。它内置于最新的 React 实现中，无需另行设置就能够和并发模式协同使用。

这就是说，调度器有两个限制：

1.  **资源抢夺。** 调度器尝试所有使用所有的可用资源。如果调度器的多个实例运行在同一个线程上并争夺资源，就会导致问题。我们需要确保应用程序的所有部分使用的是同一个调度器实例。
2.  **通过浏览器工作平衡用户定义的任务。** 由于调度器在浏览器中运行，因此它只能访问浏览器公开的API。文档生命周期（如渲染或垃圾回收）可能会以无法控制的方式干扰工作。

为了消除这些限制，Google Chrome 团队正在与 React、Polymer、Ember、Google Maps 和 Web Standards Community 合作，在浏览器中创建 [Scheduling API](https://github.com/spanicker/main-thread-scheduling)。是不是很让人兴奋！

## 总结

并发的 React 和调度器允许我们在应用程序中实现任务调度，这将使得我们可以创建响应迅速的用户界面。

React 官方可能会在 [2019 第二季度](https://reactjs.org/blog/2018/11/27/react-16-roadmap.html#react-16x-q2-2019-the-one-with-concurrent-mode)发布这些功能。在此之前，大家可以使用这些不稳定的 API，但要密切关注它的变化。

如果您想成为第一个知道这些 API 何时更改或者编写新功能文档的人，请订阅 [This Week in React ⚛️](https://this-week-in-react.org)。

* * *

<a id="fn-1">1.</a> MDN web docs 上有一篇关于这个问题很棒的[文章](https://developer.mozilla.org/en-US/docs/Tools/Performance/Scenarios/Intensive_JavaScript)。[↩](#fnref-1)

<a id="fn-2">2.</a> 这是一个超赞的词，可以返回一个支持暂停之后继续执行的方法。可以在 [generator functions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield) 上查看相似的概念。[↩](#fnref-2)

<a id="fn-3">3.</a> 在[调度器的目前实现](https://github.com/facebook/react/blob/master/packages/scheduler/src/forks/SchedulerHostConfig.default.js)中，它通过在一个 [`requestAnimationFrame()`](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame) 回调函数中使用 [`postMessage()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage) 实现。它会在帧渲染结束后立即被调用。[↩](#fnref-3)

<a id="fn-4">4.</a> 这是另外一个可以实现并发模式的方法，使用新的 [`createRoot()`](https://github.com/facebook/react/blob/1d48b4a68485ce870711e6baa98e5c9f5f213fdf/packages/react-dom/src/client/ReactDOM.js#L833-L853) API。[↩](#fnref-4)

<a id="fn-5">5.</a> 在处理第一次的 `keypress` 事件时，浏览器会在它的队列中查看待处理事件，然后决定在渲染帧之前运行哪个事件监听器。[↩](#fnref-5)


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
