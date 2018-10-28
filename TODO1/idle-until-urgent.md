> * 原文地址：[Idle Until Urgent](https://philipwalton.com/articles/idle-until-urgent/?utm_source=mybridge&utm_medium=blog&utm_campaign=read_more)
> * 原文作者：[PHILIP WALTON](https://philipwalton.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/idle-until-urgent.md](https://github.com/xitu/gold-miner/blob/master/TODO1/idle-until-urgent.md)
> * 译者：[Ivocin](https://github.com/Ivocin)
> * 校对者：

# Google 工程师提升网页性能的新策略：空闲到紧急

几周前，我开始查看我网站的一些性能指标。 具体来说，我想看看我的网站在最新的性能指标 —— [首次输入延迟](https://developers.google.com/web/updates/2018/05/first-input-delay) (FID) 上的表现如何。 我的网站只是一个博客（并没有运行很多的 JavaScript），所以我原本预期得到相当不错的结果。

用户一般对于小于 100 毫秒的输入延迟 [没有感知](https://developers.google.com/web/fundamentals/performance/rail#ux)，因此我们建议的性能目标（以及我希望在我的分析中看到的数字）是对于 99％ 的页面加载，FID 小于100 毫秒。

令我惊讶的是，我网站 99% 的页面的 FID 在 254 毫秒以内。我是个完美主义者，尽管结果不是很糟糕，但我却无法对这个结果置之不理。我一定得把它搞定！

简而言之，我在不删除网站的任何功能的情况下，把 99% 页面的 FID 降到了 100 毫秒以内。但我详细读者朋友们更感兴趣的是：

*   我是**如何**诊断问题的。
*   我采用了**什么**具体的策略和技术。

说到上文中的第二点，当时我试图解决我的问题时，偶然发现了一个非常有趣的性能策略，特别想分享给大家（这是我写这篇文章的主要原因）。

我把这个策略叫做： **空闲到紧急**。

## 我的性能问题

首次输入延迟（FID）是一个网站性能指标，指用户与您的网站[首次交互](https://developers.google.com/web/updates/2018/05/first-input-delay#what_counts_as_a_first_input) （像我这样的博客，最有可能的首次交互是点击链接）和浏览器响应该交互（请求加载下一页面）的时间。

存在延迟是由于浏览器的主线程正在忙于做其他事情（通常是在执行 JavaScript 代码）。因此，要诊断这个高于预期的 FID，首先我们需要在网站加载时启动性能追踪（启用 CPU 降频和网络限速），然后找到主线程上找到执行时间长的任务。一旦确定了这些耗时长的任务，我们就可以尝试将它们分解为更小的任务。

以下是我在对网站进行性能追踪时的发现：

[![我的网站加载时的 JavaScript 性能追踪图（启用网络限速/ CPU 降频）](https://philipwalton.com/static/idle-until-urget-before-9bc2ecd0b0.png)](https://philipwalton.com/static/idle-until-urget-before-1400w-efc9f3a53c.png)

我的网站加载时的 JavaScript 性能追踪图（启用网络限速/ CPU 降频）。

请注意，浏览器把分析主要脚本包作为了一个独立的任务，这个任务耗时 233 毫秒。

[![运行我网站的主要脚本包耗时 233 毫秒](https://philipwalton.com/static/idle-until-urget-before-eval-1d68f2dff6.png)](https://philipwalton.com/static/idle-until-urget-before-eval-1400w-7a455de908.png)

运行我网站的主要脚本包耗时 233 毫秒。

在这些代码中，一部分来自 webpack 样板文件和 babel polyfill，但大多数代码来自我脚本的 `main()` 入口函数，它本身需要 183 毫秒才能完成：

[![执行我网站的 `main()` 入口函数耗时 183 毫秒。](https://philipwalton.com/static/idle-until-urget-before-main-59f7c95e33.png)](https://philipwalton.com/static/idle-until-urget-before-main-1400w-08fe4dd1c5.png)

执行我网站的 `main()` 入口函数耗时 183 毫秒。

然而我并没有在 `main()` 函数中做什么可笑的事情。在`main()` 函数中，我先初始化了我的 UI 组件，然后运行了我的 `analytics` 方法：

```
const main = () => {
  drawer.init();
  contentLoader.init();
  breakpoints.init();
  alerts.init();

  analytics.init();
};

main();
```

那么是什么花了如此长时间运行？

我们接着来看一下这个火焰图的尾部，可以看到没有一个单独的函数占据了大部分时间。绝大多数函数在耗时不到 1 毫秒，但是当你将它们全部加起来时，在单个同步调用堆栈中，运行它们却需要超过 100 毫秒。

JavaScript 就像被“千刀万剐”了一样。

由于这些功能全都作为单个任务的一部分运行，因此浏览器必须等到此任务完成才能响应用户的交互。很明显，解决方案是将这些代码分解为多个任务，但这说起来容易做起来难。

乍一看，明显的解决方案是将 `main()` 函数中的每个组件分配优先级（它们实际上已经按优先级顺序排列了），立即初始化优先级最高的组件，然后将其他组件的初始化推迟到后续任务中。

虽然这可能有一些作用，但它的可操作行并不强，而且难以应用到大型网站中。原因如下：

*   推迟 UI 组件初始化的方法仅在组件尚未渲染时才有用。推迟初始化组件的方法会造成风险：用户有可能遇到组件没有渲染完成的情况。
*   在许多情况下，所有 UI 组件要么同等重要，要么彼此依赖，因此它们都需要同时进行初始化。
*   有时单个组件需要足够长的时间来初始化，即使它们在自己的任务中运行，它们也会阻塞主线程。

实际情况是，我们通常很难让每个组件在各自的任务中初始化，而且这种做法往往不可能实现。我们需要的是在每个组件**内部**的初始化过程中拆解任务。

### 贪婪的组件

从下面的性能追踪图可以看出，我们是否真的需要把组件初始化代码进行拆分，让我们来看一个比较好的例子： 在 `main（)` 函数的中间，你会看到我的一个组件使用了 [Intl.DateTimeFormat](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat) API:

[![创建一个 Intl.DateTimeFormat 实例需要 13.47 毫秒！](https://philipwalton.com/static/idle-until-urget-before-date-time-format-252558f2ab.png)](https://philipwalton.com/static/idle-until-urget-before-date-time-format-1400w-c67615763f.png)

创建一个 `Intl.DateTimeFormat` 实例需要 13.47 毫秒！

创建此对象需要 13.47 毫秒！

问题是，虽然  `Intl.DateTimeFormat` 实例是在组件的构造函数中创建的，但实际上**并没有**其他组件引用它来格式化日期。可是由于该组件不知道何时会引用 `Int.DateTimeFormat` 对象，因此它选择立即初始化该对象。

但这是正确的代码求值策略吗？如果不是，那什么是正确的代码求值策略？

## 代码求值策略

在选择[求值策略](https://en.wikibooks.org/wiki/Introduction_to_Programming_Languages/Evaluation_Strategies)时，大多数开发人员会从如下两种策略中做出选择：

*   **[立即求值](https://en.wikipedia.org/wiki/Eager_evaluation)：** 你可以立即运行耗时的代码。
*   **[惰性求值](https://en.wikipedia.org/wiki/Lazy_evaluation)：** 等到你的程序里的其他部分需要这段耗时代码的结果时，再去运行它。

这两种求值策略可能是目前最受欢迎​​的，但在我重构了我的网站后，我认为这两个策略可能是最糟糕两个选择。

### 立即求值的缺点

从我网站上的性能问题可以很好地看出，立即求值有一个缺点：如果用户在代码计算时与你的页面进行交互，浏览器必须等到代码运行完成后才能做出响应。

当你的页面**看起来**已经准备好响应用户输入却无法响应时，这个问题尤为明显。用户会感觉你的页面很卡或者甚至认为页面彻底崩溃了。

预先运行的代码越多，页面交互所需的时间就越长。

### 惰性求值的缺点

如果立即运行所有代码是不好的，那么一个显而易见的解决方案就是等到需要的时候再运行。这样就不会提前运行不必要的代码，尤其是一些从未被使用过的代码。

当然，等到用户需要的时候再运行的问题是：你必须**确保**你的高耗时的代码能够阻止用户输入。

对于某些事情（比如从网络加载其他内容），将其推迟到用户请求时再加载是有意义的。但对于你的大多数代码（例如 从 localStorage 读取数据，处理大型数据集等等）而言，你肯定希望它在需要它的用户交互**之前**就执行完毕。

### 其他选择

其他可选择的求值策略介于立即求值和惰性求值之间。我不确定以下两种策略是否有官方名称，我把它们称作延迟求值和空闲求值：

*   **延迟求值：** 使用 `setTimeout` 之类的函数，在后续任务中来执行你的代码。
*   **空闲求值:** 一种延迟求值策略，你可以使用像  [requestIdleCallback](https://developers.google.com/web/updates/2015/08/using-requestidlecallback) 这样的 API 来组织代码运行。

这两个选项通常都比立即求值或惰性求值好，因为它们不太可能由于单个长任务阻塞用户输入。这是因为，虽然浏览器不能中断任何单个任务来响应用户输入（这样做很可能会破坏网站），但是它们**可以**在计划任务队列之间运行任务，而且大多数浏览器**会**优先处理用户输入触发的任务。这称为[输入优先](https://blogs.windows.com/msedgedev/2017/06/01/input-responsiveness-event-loop-microsoft-edge/)。

换句话说：如果确保所有代码都运行在耗时短、不同的任务中（最好[小于 50 毫秒](https://developers.google.com/web/fundamentals/performance/user-centric-performance-metrics#long_tasks)），你的代码就再也不会阻塞用户输入了。

**重要！** 虽然浏览器能够在任务队列中优先执行输入回调函数，但它们**无法**在排列好的微任务之前运行。由于 promise 和 `async` 函数作为微任务运行，将你的同步代码转换为基于 promise 的代码不会起到缓解用户输入阻塞的作用！

如果你不熟悉任务和微任务之间的区别，我强烈建议你观看我的同事杰克[关于事件循环](https://youtu.be/cCOL7MC4Pl0)的精彩演讲。

鉴于我刚才所说的，我可以使用 `setTimeout（)` 和`requestIdleCallback（)` 来重构我的 `main()` 函数，将我的初始化代码拆解为单独的任务：

```
const main = () => {
  setTimeout(() => drawer.init(), 0);
  setTimeout(() => contentLoader.init(), 0);
  setTimeout(() => breakpoints.init(), 0);
  setTimeout(() => alerts.init(), 0);

  requestIdleCallback(() => analytics.init());
};

main();
```

然而，虽然这比以前更好（许多小任务 vs 一个长任务），正如我上文解释的那样，它可能还不够好。例如，如果我延迟我 UI 组件（特别是 `contentLoader` 和 `drawer`）的初始化过程，虽然它们几乎不会阻塞用户输入，但是当用户尝试与它们交互时，它们也存在未准备好的风险！

虽然使用 `requestIdleCallback ()`  来延迟我的 `analytics` 方法可能是一个好主意，但在下一个空闲时段之前我关心的任何交互都将被遗漏。而且如果在用户离开页面之前没有空闲时段，这些回调可能永远不会运行！

因此，如果所有这些求值策略都有缺点，那么我们该如何选择呢？

## 空闲到紧急

在长时间思考这个问题之后，我意识到我**真正**想要的求值策略是：首先代码推迟到空闲时间段执行，但是一旦被调用则立即执行。换句话说：“空闲到紧急”。

“空闲到紧急”的策略回避了我在上一节中指出的大多数缺点。在最坏的情况下，它与延迟计算具有完全相同的性能特征；在最好的情况下，它完全不会阻塞用户交互，因为在空闲时间段，代码都已经执行好了。

我还得提一点，这个策略既适用于单任务（空闲时间求值），也适用于多任务（一个有序的任务队列，可以空闲时间运行）。我先解释一下单任务（空闲值）变体，因为它更容易理解。

### 空闲值

我在上文提到过，初始化 `Int.DateTimeFormat` 对象可能非常耗时，因此若不需要立即调用该实例，最好在空闲时间去初始化。当然，一旦需要它，你就希望它存在，所以这是一个完美的可以用“空闲到紧急”策略来解决的例子。

如下是使用我们新策略的简化版组件的例子：

```
class MyComponent {
  constructor() {
    addEventListener('click', () => this.handleUserClick());

    this.formatter = new Intl.DateTimeFormat('en-US', {
      timeZone: 'America/Los_Angeles',
    });
  }

  handleUserClick() {
    console.log(this.formatter.format(new Date()));
  }
}
```

上面的 `MyComponent` 实例在它们的构造函数中做了两件事：

*   为用户交互添加事件侦听器。
*   创建 `Intl.DateTimeFormat` 对象。

该组件很好地说明了为什么我们经常需要在单个组件**内部**拆解任务（而不仅仅在组件级别拆解任务）。

在这种情况下，事件监听器立即运行非常重要，但在事件处理程序需要之前，创建 `Intl.DateTimeFormat` 实例是不必要的。当然我们也不想在事件处理函数中创建`Intl.DateTimeFormat` 对象，因为这样会使事件处理函数变得很慢。

下面就是我们如何使用“空闲到紧急”策略修改的代码。需要注意的是，我使用了 `IdleValue`  帮助类，后续我会进行讲解：

```
import {IdleValue} from './path/to/IdleValue.mjs';

class MyComponent {
  constructor() {
    addEventListener('click', () => this.handleUserClick());

    this.formatter = new IdleValue(() => {
      return new Intl.DateTimeFormat('en-US', {
        timeZone: 'America/Los_Angeles',
      });
    });
  }

  handleUserClick() {
    console.log(this.formatter.getValue().format(new Date()));
  }
}
```

如你所见，此代码和先前的版本没有太大的区别，但在新代码中，我没有将 `this.formatter` 赋值给新的`Intl.DateTimeFormat` 对象，而是在初始化函数中，将 `this.formatter` 赋值给了 `IdleValue` 对象。

`IdleValue` 类的工作方式是调度初始化函数，在下一个空闲期间运行。如果空闲时间在引用 `IdleValue` 实例之前，则不会发生阻塞，而且可以在请求时立即返回该值。但另一方面，如果在下一个空闲时间**之前**引用该值，则取消初始化函数在空闲时间中的调度任务， 并立即运行该函数。

下面是如何实现 `IdleValue` 类的要点（注意：我已经发布了这段代码，它是[`idlize` package](https://github.com/GoogleChromeLabs/idlize)包的一部分，`idlize` 包含了本文中出现的全部帮助类):

```
export class IdleValue {
  constructor(init) {
    this._init = init;
    this._value;
    this._idleHandle = requestIdleCallback(() => {
      this._value = this._init();
    });
  }

  getValue() {
    if (this._value === undefined) {
      cancelIdleCallback(this._idleHandle);
      this._value = this._init();
    }
    return this._value;
  }

  // ...
}
```

虽然在上面的示例中包含 `IdleValue` 类并不需要很多修改，但是它在技术上改变了公共 API（ `this.formatter ` vs `this.formatter.getValue()`）。

如果你想要使用 `IdleValue` 类但却无法修改公共 API ，则可以将 `IdleValue` 类与 ES2015 的 getters一起使用：

```
class MyComponent {
  constructor() {
    addEventListener('click', () => this.handleUserClick());

    this._formatter = new IdleValue(() => {
      return new Intl.DateTimeFormat('en-US', {
        timeZone: 'America/Los_Angeles',
      });
    });
  }

  get formatter() {
    return this._formatter.getValue();
  }

  // ...
}
```

或者，如果你不介意抽象一点，你可以使用[`defineIdleProperty()`](https://github.com/GoogleChromeLabs/idlize/blob/master/docs/defineIdleProperty.md)  帮助类（底层使用的是 `Object.defineProperty()`）：

```
import {defineIdleProperty} from './path/to/defineIdleProperty.mjs';

class MyComponent {
  constructor() {
    addEventListener('click', () => this.handleUserClick());

    defineIdleProperty(this, 'formatter', () => {
      return new Intl.DateTimeFormat('en-US', {
        timeZone: 'America/Los_Angeles',
      });
    });
  }

  // ...
}
```

对于计算耗时很长的单个属性值，没有理由不使用此策略，尤其使用此策略可以不更改你的 API！

虽然这个例子使用了 `Intl.DateTimeFormat` 对象，但如下情况使用本策略也是一个好的选择：

*   处理大量数据集。
*   从 localStorage（或 cookie）中获取值。
*   运行 `getComputedStyle()` 、`getBoundingClientRect()` 或任何其他可能需要在主线程上重绘样式或布局的 API。

### 空闲任务队列

上述技术适用于可以通过单个函数计算出来的属性，但在某些情况下，逻辑可能无法写到单个函数里，或者，即使技术上可行，您仍然希望将其拆分为更小的一些函数，以免其长时间阻塞中线程。

在这种情况下，我们真正​​需要的是一种队列，在浏览器有空闲时间时，可以安排多个任务（函数）运行的先后顺序。队列将在可能的情况下运行任务，并且当需要回退到浏览器时它将暂停执行任务（例如， 如果用户正在进行交互）。

为了解决这个问题，我构建了一个 [`IdleQueue`](https://github.com/GoogleChromeLabs/idlize) 类，可以像这样使用它：

```
import {IdleQueue} from './path/to/IdleQueue.mjs';

const queue = new IdleQueue();

queue.pushTask(() => {
  // Some expensive function that can run idly...
});

queue.pushTask(() => {
  // Some other task that depends on the above
  // expensive function having already run...
});
```

**注意：** 将同步的 JavaScript 代码拆解为可作为任务队列的一部分的异步运行和[代码分割](https://developers.google.com/web/fundamentals/performance/optimizing-javascript/code-splitting/)不同，代码分割是将较大的 JavaScript 包分解为较小的文件的过程（它对于提高性能也很重要）。

与上面提到的的空闲时间初始化属性的策略一样，空闲任务队列也可以在需要立即执行结果的情况下立即运行（“紧急”情况）。

同样，最后一点非常重要；不仅仅因为有时我们需要尽快计算某些东西，还有一个原因是通常我们集成了同步的第三方 API ，我们需要能够同步运行任务，以保证兼容性。

在理想的情况下，所有 JavaScript API 都是非阻塞的、异步的、代码量小的，并且由能够返回主线程。但在实际情况下，由于遗留的代码库或集成了无法控制的第三方库，我们通常别无选择，只能保持同步。

正如我之前所说，这是“空闲到紧急”策略的巨大优势之一。它可以轻松应用于大多数程序，而无需大规模重写架构。

### 保证紧急任务执行

我在上文提到过，`requestIdleCallback()` 不能保证回调函数一定会执行。这也是我在于开发人员讨论 `requestIdleCallback()`时，得到的他们不使用 `requestIdleCallback()` 的主要原因。在许多情况下，代码可能无法运行的足以成为不使用它的理由 —— 开发人员宁愿保持代码同步以保证安全性（即使会发生阻塞）。

分析代码就是一个很好的例子。分析代码的问题在于，很多情况下，在页面卸载时，分析代码就要运行（例如， 跟踪外链点击等），在这种情况下，显然使用 `requestIdleCallback()` 不合适，因为回调函数根本不会执行。而且由于开发人员不清楚分析库的 API 在页面的生命周期中的调用时机，他们也倾向于安全地运行它并同步运行所有代码（这很不幸，因为分析代码绝对不是用户体验的关键）。

但是使用“闲置到紧急”模式，有一个简单的解决方案。我们所要做的就是确保页面只要处于将要卸载的状态，就会立即运行队列中的分析代码。

如果你熟悉我近期发表在 [Page Lifecycle API](https://developers.google.com/web/updates/2018/07/page-lifecycle-api)的文章中给出的建议，你就会知道在页面被终止或丢弃之前，[最后一个可靠的回调函数](https://developers.google.com/web/updates/2018/07/page-lifecycle-api#advice-hidden)是 `visibilitychange` 事件（因为页面的 `visibilityState` 会变为隐藏）。而且由于在用户无法在页面隐藏的情况下进行交互，因此这正是运行空闲任务的最佳时机。

实际上，如果你使用了 `IdleQueue` 类，可以通过一个简单的配置项传递给构造函数，来启用该功能。

```
const queue = new IdleQueue({ensureTasksRun: true});
```

对于渲染等任务，无需确保在页面卸载之前运行任务，但对于保存用户状态和发送结束回话分析等任务，你可能希望将此选项设置为 `true`。

**注意：** 监听 `visibilitychange` 事件应该足以确保在卸载页面之前运行任务，但是由于 Safari 漏洞，当用户关闭选项卡时，[页面隐藏和 `visibilitychange` 事件并不总是触发](https://github.com/GoogleChromeLabs/page-lifecycle/issues/2)，你必须实现一个解决方案适用于 Safari 浏览器。这个解决方案已经在 `IdleQueue` 类中[为你实现好了](https://github.com/GoogleChromeLabs/idlize/blob/master/IdleQueue.mjs#L60-L69)，但如果你需要自己实现它，则需要了解它。

**警告！** 不要使用监听 `unload` 事件的方式来执行页面卸载前需要执行的队列。 `unload` 事件不可靠，在某些情况下还会降低性能。有关更多详细信息，请参阅我在[Page Lifecycle API 上的文章](https://developers.google.com/web/updates/2018/07/page-lifecycle-api#the-unload-event)。

“空闲到紧急”策略的使用场景
-------------------------------

每当要运行可能非常耗时的代码时，应该尝试将其拆解为更小的任务。如果不需要立即运行该代码，但未来某些时候可能需要，那么这就是一个使用“空闲到紧急”策略的完美场景。

在你自己的代码中，我建议做的第一件事是查看所有构造函数，如果存在可能会很耗时的操作，使用 [`IdleValue`](https://github.com/GoogleChromeLabs/idlize/blob/master/docs/IdleValue.md) 对象重构它们。

对于其他的对于用户交互是必不可少，但不关键的逻辑，请考虑将这些逻辑添加到 [`IdleQueue`](https://github.com/GoogleChromeLabs/idlize/blob/master/docs/IdleQueue.md)中。不用担心，你可以在任何你需要的时候立即运行该代码。

特别适合使用该技术的两个具体例子（并且与大部分网站相关）是持久化应用状态（如 Redux）和网站分析。

**注意：** 这些使用场景的**目的**都是使任务在空闲时间运行，因此如果这些任务不立即运行则没有问题。 如果你需要处理高优先级的任务，**想要**让它们尽快运行（但仍然优先级低于用户输入），那么`requestIdleCallback()` 可能无法解决你的问题。

幸运的是，我的几个同事开发出了新的 web 平台 API([`shouldYield()`](https://discourse.wicg.io/t/shouldyield-enabling-script-to-yield-to-user-input/2881/17)和原生的 [Scheduling API](https://github.com/spanicker/main-thread-scheduling/blob/master/README.md)）可以帮助我们解决这个问题。

### 持久化应用状态

我们来看一个 Redux 应用程序，它将应用程序状态存储在内存中，但也需要将其存储在持久化存储（如localStorage）中，以便用户下次访问页面时可以重新加载。

大多数使用 localStorage 持久化存储状态的 Redux 应用程序使用了防抖技术，大致代码如下：

```
let debounceTimeout;

// Persist state changes to localStorage using a 1000ms debounce.
store.subscribe(() => {
  // Clear pending writes since there are new changes to save.
  clearTimeout(debounceTimeout);

  // Schedule the save with a 1000ms timeout (debounce),
  // so frequent changes aren't saved unnecessarily.
  debounceTimeout = setTimeout(() => {
    const jsonData = JSON.stringify(store.getState());
    localStorage.setItem('redux-data', jsonData);
  }, 1000);
});
```

虽然使用防抖技术总比什么都不做强，但它并不是一个完美的解决方案。问题是无法保证防抖函数运行不会阻塞对用户至关重要的主线程。

在空闲时间执行 localStorage 写入会好得多。你可以将上述代码从防抖策略转换为“空闲到紧急”的策略，如下所示：

```
const queue = new IdleQueue({ensureTasksRun: true});

// Persist state changes when the browser is idle, and
// only persist the most recent changes to avoid extra work.
store.subscribe(() => {
  // Clear pending writes since there are new changes to save.
  queue.clearPendingTasks();

  // Schedule the save to run when idle.
  queue.pushTask(() => {
    const jsonData = JSON.stringify(store.getState());
    localStorage.setItem('redux-data', jsonData);
  });
});
```

请注意，此策略肯定比使用防抖策略更好，因为它能够保证即使用户离开页面之前将状态存储好。 如果使用上面的防抖策略的例子，在用户离开页面的情况下，很有可能写入状态失败。

### 分析

另一个“空闲到紧急”策略适合的场景就是网站分析代码。下面的例子教你如何使用 `IdleQueue` 类来发送你的网站分析数据，并且可以保证即使用户关闭了标签页或跳转到了其他页面，并且还没有到下次空闲时间的时候，这些数据也可以**正常发送**：

```
const queue = new IdleQueue({ensureTasksRun: true});

const signupBtn = document.getElementById('signup');
signupBtn.addEventListener('click', () => {
  // Instead of sending the event immediately, add it to the idle queue.
  // The idle queue will ensure the event is sent even if the user
  // closes the tab or navigates away.
  queue.pushTask(() => {
    ga('send', 'event', {
      eventCategory: 'Signup Button',
      eventAction: 'click',
    });
  });
});
```

除了可以保证紧急情况之外，把这个任务添加到空闲时间队列也能够确保其不会阻塞响应用户点击事件的其他代码。

实际上，我建议将你所有的网站分析代码放到空闲时间执行，包括初始化代码。而且像 analytics.js 这样的库，其 [API 已经支持命令队列](https://developers.google.com/analytics/devguides/collection/analyticsjs/how-analyticsjs-works#the_ga_command_queue)，我们只需简单地在我们的 `IdleQueue` 实例上添加这些命令。

例如，你可以将[默认的 analytics.js 初始化代码片段](https://developers.google.com/analytics/devguides/collection/analyticsjs/#the_javascript_tracking_snippet)的最后一部分：

```
ga('create', 'UA-XXXXX-Y', 'auto');
ga('send', 'pageview');
```

修改为：

```
const queue = new IdleQueue({ensureTasksRun: true});

queue.pushTask(() => ga('create', 'UA-XXXXX-Y', 'auto'));
queue.pushTask(() => ga('send', 'pageview'));
```

(你也可以[我做的](https://github.com/philipwalton/blog/blob/0670d46/assets/javascript/analytics.js#L114-L127)一样在 `ga()` 函数外包裹一个包装器，使其能够自动执行队列命令)。

## requestIdleCallback 的浏览器兼容性

在撰写本文时，只有 Chrome 和 Firefox 支持 `requestIdleCallback()`。虽然真正的 polyfill 是不可能的（只有浏览器可以知道它何时空闲），但是使用 setTimeout 作为一个备用方案还是很容易的（本文提到的所有帮助器类和方法都使用这个[备用方案](https://github.com/GoogleChromeLabs/idlize/blob/master/docs/idle-callback-polyfills.md)）。

而且即使在不原生支持 `requestIdleCallback()` 的浏览器中，使用 `setTimeout` 这种备用方案也比不用强，因为浏览器仍然是优先处理用户输入，然后是通过 `setTimeout()` 函数创建的队列中的任务。

## 使用本策略实际上提高了多少性能？

在本文开头我提到我想出了这个策略，因为我试图提高我网站的 FID 值。我尝试拆分我代码中页面开始加载就运行的代码，并且还得保证一些使用同步 API 的第三方库（如 analytics.js）的正常运行。

上文已经提到，在我使用“空闲到紧急”策略之前，我所有初始化代码在一个任务中耗费了 233 毫秒。在使用了这个策略之后，可以看到出现了更多耗时更短的任务。实际上，最长的一个任务也仅仅耗时 37 毫秒！

[![我网站的 JavaScript 性能跟踪图，上面展示了很多短任务。](https://philipwalton.com/static/idle-until-urget-after-4789aca119.png)](https://philipwalton.com/static/idle-until-urget-after-1400w-d526f6cca8.png)

我网站的 JavaScript 性能跟踪图，上面展示了很多短任务。

需要重点强调的是，使用新策略重构的代码和之前执行的任务的数量是相同的，现在仅仅就是将其分为多个任务，并且在空闲时间里执行它们。

因为所有任务都不超过 50 毫秒，所以没有任何一个任务影响我的交互时间（TTI），这对我的 lighthouse 得分很有帮助：

[![使用了“空闲到紧急”策略后，我的 lighthouse 报告。 - 全部 100 分！](https://philipwalton.com/static/lighthouse-report-4721b091da.png)](https://philipwalton.com/static/lighthouse-report-1400w-1136c250ac.png)

使用了“空闲到紧急”策略后，我的 lighthouse 报告。

最后, 由于本工作的目的是提高我网站的 FID, 在将这些变更上线之后, 经过分析，我非常兴奋地看到了**对于99%页面的 FID 减小了 67%！**

| Code version | FID (p99) | FID (p95) | FID (p50) |
| ------------ | --------- | --------- | --------- |
| Before _idle-until-urgent_ | **254ms** | 20ms | 3ms |
| After _Idle-until-urgent_ | **85ms** | 16ms | 3ms |

## 总结

在理想情况下，没有网站再会去不必要的阻塞主线程了。我们会使用 web worker 来处理我们非 UI 的工作，而且我们还有浏览器内置好的 [`shouldYield()`](https://discourse.wicg.io/t/shouldyield-enabling-script-to-yield-to-user-input/2881/17) 和原生的 [Scheduling API](https://github.com/spanicker/main-thread-scheduling/blob/master/README.md)）。

但在实际情况下，我们网站工程师往往没有选择，只能将非 UI 的代码放到主线程去执行，这导致了网页出现无响应的问题。

希望这篇文章已经说服了你，是时候去打破我们的长耗时 JavaScript 任务了。而且“空闲到紧急”能够把看起来同步的 API 转到空闲时间运行，能够和所有我们已知的和在使用中的工具库结合，“空闲到紧急”是一个极好的解决方案。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
