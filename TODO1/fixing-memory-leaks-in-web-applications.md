> * 原文地址：[Fixing memory leaks in web applications](https://nolanlawson.com/2020/02/19/fixing-memory-leaks-in-web-applications/)
> * 原文作者：[Nolan](https://nolanlawson.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/fixing-memory-leaks-in-web-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO1/fixing-memory-leaks-in-web-applications.md)
> * 译者：[febrainqu](https://github.com/febrainqu)
> * 校对者：[niayyy-S](https://github.com/niayyy-S)、[QinRoc](https://github.com/QinRoc)、[cyz980908](https://github.com/cyz980908)

## 解决 web 应用程序中的内存泄漏问题

当我们由服务端渲染的应用切换到客户端渲染的单页面应用时，我们要付出的一部分代价是，必须更加注重用户设备上的资源。不要阻塞 UI 进程，不要让笔记本的风扇旋转，不要损耗手机电池等等。我们用在服务端渲染中不存在的一类新问题换来了更好的交互性和更类似 app 的表现。

这类新问题中，其中一个问题就是内存泄漏。一个差的单页面应用会消耗 MB 甚至 GB 的内存，持续地占用越来越多的资源，即使它仅存在于一个背景标签。 因此，页面可能开始变慢，或者浏览器终止这个页面，你会看到 Chrome 熟悉的“喔唷 崩溃啦” 页面。

[![Chrome 显示“喔唷 崩溃啦！显示此页面时出了点问题”](https://nolanwlawson.files.wordpress.com/2020/02/awsnap.png?w=570&h=186)](https://nolanwlawson.files.wordpress.com/2020/02/awsnap.png)

（当然，一个服务端渲染的网站也会在服务器端出现内存泄漏。但是在客户端出现内存泄漏的可能性非常小，因为每当我们切换页面时浏览器都会清除内存。）

关于内存泄漏的内容在 web 开发的文章中没有得到很好的覆盖。但是，我确定大多数重要的单页面应用都存在内存泄漏问题，除非他们背后的团队有一个强大的基础架构来捕获和修复内存泄漏。在 JavaScript 中，很容易意外地分配一些内存而忘记清理。

那么，为什么关于内存泄漏的文献如此之少呢？我的猜测：

* **缺乏反馈**：大多数使用者在他们上网时不会认真观察他们的任务管理器。通常，除非泄漏严重到页面崩溃或应用程序运行缓慢，否则你不会得到用户的反馈。
* **缺乏数据**：Chrome 团队不会提供关于网站通常使用了多少内存的数据。网站通常也不自己测量。
* **缺乏工具**：使用现有工具识别或修复内存泄漏仍然困难。
* **缺乏关心**：浏览器非常擅长杀死消耗过多内存的页面。人们会把[这种问题归咎于浏览器](https://www.google.com/search?hl=en&q=chrome%20memory%20hog) 而不是网页。

在这篇文章中，我想分享一些我在解决 Web 应用程序中的内存泄漏方面的经验，并提供一些示例来说明如何有效地跟踪它们。

## 内存泄漏的解析

现代 Web 应用程序框架，例如 React，Vue 和 Svelte 都是基于组件的模型。在此模型中，导致内存泄漏的最常见方法是这样的：

window.addEventListener('message', this.onMessage.bind(this));

就是这样。这样就会导致内存泄漏。如果你在一些全局对象（例如 window， <body> 等）中调用 addEventListener ，然后忘记用 removeEventListener 将它们清理干净。当组件被卸载时，你就创建了一个内存泄漏。

更糟糕的是，你刚刚泄漏了整个组件。因为 this.onMessage 绑定到了 this 上，这个组件就会泄漏。进而它的所有子组件也都会泄漏。因此它的所有子组件也都会泄漏。 而且所有与这些组件相关联的 DOM 节点很可能也都会泄露。这很快就会变得非常糟糕。

解决方法是：

```js
// 挂载阶段
this.onMessage = this.onMessage.bind(this);
window.addEventListener('message', this.onMessage);

// 卸载阶段
window.removeEventListener('message', this.onMessage);
```

注意，我们保存了对 `onMessage` 函数的引用。你传递给 `addEventListener` 的参数必须和之前传递给 `removeEventListener` 的参数完全相同，否则它不会生效。

## 内存泄漏情况

根据我的经验，内存泄漏最常见的来源是这样的 API：

1. `addEventListener`。这是最常见的一种。调用 `removeEventListener` 来清理它。
2. [`setTimeout`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setTimeout) / [`setInterval`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setInterval)。如果你创建一个循环计时器（例如，每 30 秒运行一次），那么你就需要用 [`clearTimeout`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/clearTimeout) 或 [`clearInterval`](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/clearInterval)来清除它。（如果像 `setInterval` 那样使用 `setTimeout` 会造成内存泄漏 —— 即，在 `setTimeout` 中回调一个新的 `setTimeout`。）
3. [`IntersectionObserver`](https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver)，[`ResizeObserver`](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver)，[`MutationObserver`](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver) 等。这些新 API 非常方便，但是它们也可能会造成内存泄漏。如果你在组件内部创建了一个观察器，并且将它绑定到一个全局变量上，那么你需要调用 `disconnect()` 来清除它们。（注意，被被垃圾回收的 DOM 节点上绑定的 listener 和 observer 事件也将被垃圾回收。通常，你只需要考虑全局元素，例如 `<body>`，`document`，无处不在的 header 或 footer 元素等等。）
4. [Promises](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)，[Observables](https://rxjs.dev/guide/observable)，[EventEmitters](https://nodejs.org/api/events.html#events_class_eventemitter)，等。如果你忘记停止监听，任何用于设置侦听器的编程模型都可能会造成内存泄漏。（如果一个 Promise 从未执行 resolved 或 rejected，那么它可能造成内存泄漏，在这种情况下，任何这个 Promise 对象上的 .then() 回调都会泄漏。）
5. 全局对象存储。像 [Redux](https://redux.js.org/) 这样的全局对象，如果你不小心，你可以一直为它追加内存，它永远不会被清理。
6. 无限的新增 DOM。如果你在没有 [virtualization](https://github.com/WICG/virtual-scroller#readme)的情况下，实现无限滚动列表，那么 DOM 节点的数量将无限制地增长。

当然，还有许多其他方法会导致内存泄漏，但这些是我见过的最常见的方式。

## 识别内存泄漏

这是最难的部分。我首先要说的是，我认为现有的工具都不够好。我尝试了 Firefox 的内存工具、Edge 和 IE 的内存工具，甚至 Windows 性能分析器。同类中最好的仍然是 Chrome 开发者工具，但它有很多值得我们去了解的不足。

在 Chrome 开发者工具中，我们选择的主要工具是“Memory”选项卡中的“heap snapshot”工具。Chrome 中有其他内存工具，但我没有发现它们对识别内存泄漏有多大帮助。

[![使用 Heap Snapshot 工具的 Chrome 开发者工具内存选项卡中的屏幕截图](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-11-03-49.png?w=570&h=333)](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-11-03-49.png)

Heap Snapshot 工具允许你对主线程或 web workers 或 iframe 进行内存捕获。

当你单击“take snapshot”按钮时，你已经捕获了该 web 页面上特定 JavaScript VM 中的所有活动对象。这包括 `window` 引用的对象，`setInterval` 回调引用的对象，等等。你可以把它想象成一个代表了那个网页所使用的所有内存的凝固瞬间。

下一步是重现一些你认为可能泄漏的场景 —— 例如，打开和关闭一个模态对话框。一旦对话框关闭，你期望内存恢复到以前的水平。因此，你获取另一张快照，并 **与前一个快照比较**。这个比较功能确实是该工具的杀手级功能。

![图中显示了第一个堆快照，随后是一个泄漏场景，然后是第二个堆快照，它应该等于第一个堆快照](https://nolanwlawson.files.wordpress.com/2020/02/leak-scenario.png?w=570&h=285)

然而，你应该意识到这个工具有一些限制：

1. 即使你点击了“collect garbage”按钮，你也可能需要拍几个连续的快照才能真正清理未引用的内存。根据我的经验，三个就足够了。（检查每个快照的总内存大小 —— 它最终应该稳定下来。）
2. 如果你使用了 web workers、service workers、iframes、shared workers 等，那么这个内存将不会显示在堆快照上，因为它位于另一个 JavaScript VM 中。如果你想的话，你可以捕获这个内存，但是要确保你知道你在测量的是哪一个。
3. 有时 snapshotter 会卡住或崩溃。在这种情况下，只需关闭浏览器选项卡并重新开始。

此时，如果你的应用程序很简单，那么你可能会在两个快照之间看到**很多**对象泄漏。这是个棘手的问题，因为这些并非都是真正的泄漏。其中很多都是正常的使用 —— 一些对象被释放以满足另一个对象的内存需求，一些对象以某种方式被缓存，以便之后的清理，等等

## 去除干扰

我发现去除干扰的最好方法是重复几次泄漏的场景。例如，不只是打开和关闭一个模态对话框一次，你可以打开和关闭它 7 次。（7 是一个很明显的质数。）然后你可以检查堆快照的差异，以查看是否有任何对象泄漏了 7 次。（或 14 次、21 次。）

[![Chrome 开发者工具的屏幕截图堆快照差异显示 6 个堆快照捕获，其中多个对象泄漏 7 次](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-10-56-12-2.png?w=570&h=264)](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-10-56-12-2.png)

一个堆快照差异。请注意，我们正在比较快照 #6 和快照 #3，因为我连续进行了三次捕获，以便进行更多的垃圾回收。还要注意，有几个对象泄漏了 7 次。

（另一种有用的技巧是在记录第一个快照之前遍历一次场景。特别是如果你使用了大量的代码拆分，来实现按需加载，那么你的场景很可能需要一次性的内存开销来加载必要的 JavaScript 模块）

此时，你可能想知道为什么我们应该根据对象的数量而不是总内存来排序。根据直觉，既然我们在试图减少内存泄漏的数量，那么难道我们不应该关注总的内存使用量吗？但是由于一个重要的原因，这个方法不是很有效。

当发生内存泄漏时，([套用乔·阿姆斯特朗的话](https://www.johndcook.com/blog/2011/07/19/you-wanted-banana/)) 由于你紧抓着香蕉不放，你最终得到的是香蕉、抓着香蕉的大猩猩和整个丛林。如果你基于总字节进行度量，那么你是在度量丛林，而不是香蕉。

![大猩猩吃香蕉](https://nolanwlawson.files.wordpress.com/2020/02/gorilla_eating_optimized.jpg?w=570&h=428)

通过 [维基共享](https://commons.wikimedia.org/wiki/File:Gorilla_Eating.jpg).

让我们回到上面的 `addEventListener` 事例。内存泄漏的来源是一个事件监听器，它在引用一个函数，这个函数又引用一个组件，这个组件可能还引用大量的东西，比如数组、字符串和对象。

如果你根据总内存对堆快照差异进行排序，那么它将向你显示一堆数组、字符串和对象 —— 其中大多数可能与内存泄漏无关。你真正想要找到的是事件监听器，但是与它所引用的东西相比，它只占用了极小的内存。要修复泄漏，你需要找到的是香蕉，而不是丛林。

因此，如果按泄漏对象的数量排序，你将看到 7 个事件监听器。可能有 7 个组件，14 个子组件，或者类似的东西。“7”这个数字应该很醒目，因为它是一个不寻常的数字。无论你重复该场景多少次，你都应该确切地看到泄漏的对象数量。这就是如何快速找到泄漏源的方法。

## 查找 retainer 树

堆快照差异还将向你展示一个“retainer”链，它显示着保持内存活动的对象间的相互指向。这样你就可以找出内存泄漏对象的分配位置。

[![一个 retainer 链的屏幕截图，显示了一个事件监听器引用的闭包中引用的一些对象](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-10-56-12-3.png?w=570&h=111)](https://nolanwlawson.files.wordpress.com/2020/02/screenshot-from-2020-02-16-10-56-12-3.png)

retainer 链显示哪个对象正在引用泄漏的对象。阅读它的方法是每个对象都由它下面的对象引用。

在上面的例子中，有一个名为 `someObject` 的变量，它被一个闭包（又名“上下文”）引用，这个闭包又被一个事件监听器引用。 如果你点击源链接，它会跳转到 JavaScript 声明，这种方式相当直接明了：

```js
class SomeObject () { /* ... */ }

const someObject = new SomeObject();
const onMessage = () => { /* ... */ };
window.addEventListener('message', onMessage);
```

在上面的例子中，“上下文”是 `onMessage` 的闭包，它引用了 `someObject` 变量。（这是一个 [人为的例子](https://github.com/nolanlawson/pinafore/commit/de6ca2d85334ad5f657ddd0f335750b60afab895)；真正的内存泄漏可能不那么明显!）

但 heap snapshotting 工具有几个限制：

1. 如果保存并重新加载快照文件，则将丢失对分配对象的位置的所有文件引用。例如，你不会看到 `foo.js` 第 22 行的事件监听器闭包。由于这是非常重要的信息，所以保存和发送堆快照文件几乎毫无用处。
2. 如果涉及到 [`WeakMap`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakMap)，那么 Chrome 将向你显示这些引用，即使它们实际上并不重要 —— 只要清除了其他引用，这些对象就会被释放。所以它们只是干扰。
3. Chrome 根据原型对这些对象进行分类。因此，使用实际的类/函数越多，使用匿名对象越少，就越容易发现究竟是什么东西在泄漏。例如，想象一下，如果我们的泄漏是由于 `object` 而不是 `EventListener`。由于 `object` 是非常通用的，所以我们不太可能正好看到其中 7 个被泄漏。

这是我识别内存泄漏的基本策略。我曾经成功地使用这种技术发现了许多内存泄漏。

不过，本指南只是一个开始 —— 除此之外，你还必须能够灵活地设置断点、记录日志并测试修复程序，以查看它是否解决了泄漏。不幸的是，这本身就是一个耗时的过程。

## 自动的内存泄漏分析

在此之前，我要说的是，我还没有找到一个自动检测内存泄漏的好方法。Chrome 提供了非标准的 [performance.memory](https://webplatform.github.io/docs/apis/timing/properties/memory/) API，但是由于隐私原因[没有一个非常精确的粒度](https://bugs.webkit.org/show_bug.cgi?id=80444)，所以你不能在生产中真正使用它来识别泄漏。[W3C Web 性能工作组](https://github.com/w3c/web-performance) 曾讨论了 [内存](https://docs.google.com/document/d/1tFCEOMOUg4zmqeHNg1Xo11Xpdm7Bmxl5y98_ESLCLgM/edit) [工具](https://github.com/WICG/memory-pressure)，但尚未达成新的标准来取代这个API。

在实验环境或综合测试环境中，你可以通过使用 Chrome 标志 [`--enable-precise-memory-info`](https://github.com/paulirish/memory-stats.js/blob/master/README.md)来增加这个 API 的粒度。你还可以通过调用专用的 Chromedriver 命令 [`:takeHeapSnapshot`](https://webdriver.io/docs/api/chromium.html#takeheapsnapshot) 来创建堆快照文件。不过，这也有上面提到的限制 —— 你可能想要连续取三个，并丢弃前两个。

由于事件监听器是最常见的内存泄漏源，所以我使用的另一种技术是对 `addEventListener` 和 `removeEventListener` 的 API 进行功能追加以对引用计数并确保它们归零。这个[例子](https://github.com/nolanlawson/pinafore/blob/2edbd4746dfb5a7c894cb8861cf315c800a16393/tests/spyDomListeners.js)讲述了如何操作。

在 Chrome 开发者工具中，你还可以使用专用的 [`getEventListeners()`](https://developers.google.com/web/tools/chrome-devtools/console/utilities#geteventlisteners) API 来查看绑定到特定元素上的事件监听器。注意，这只能在开发者工具中使用。

**更新：** Mathias Bynens 告诉了我另一个有用的开发者工具的 API:[`queryObjects()`](https://developers.google.com/web/updates/2017/08/devtools-release-notes#query-objects)，它可以显示使用特定构造函数创建的所有对象。Christoph Guttandin 也有 [一篇有趣的博客文章](https://media-codings.com/articles/automatically-detect-memory-leaks-with-puppeteer) 关于在 Puppeteer 中使用这个 API 进行自动内存泄漏检测。

## 总结

在 web 应用程序中查找和修复内存泄漏仍然处于初级阶段。在这篇博客文章中，我介绍了一些对我有用的技术，但必须承认，这仍然是一个困难和耗时的过程。

与大多数性能问题一样，预防内存泄漏比发现后再修复重要的多。你可能会发现，在适当的地方进行综合测试比在事后调试内存泄漏更有价值。特别是当一个页面上有几个漏洞时，它可能会变成一个剥洋葱的练习 —— 你修复一个漏洞，然后找到另一个，然后重复（在整个过程中哭泣！）如果你知道要查找什么，代码检查也可以帮助捕获常见的内存泄漏模式。

JavaScript 是一门内存安全的语言，在 web 应用程序中这么容易泄漏内存，实在是有点讽刺。其中一部分是 UI 设计固有的 —— 我们需要监听鼠标事件、滚动事件、键盘事件等等，而这些都是很容易导致内存泄漏的模式。但是，通过尽量降低 web 应用程序的内存使用量，我们可以提高运行时性能，避免崩溃，并尊重用户设备上的资源限制。

**感谢 Jake Archibald 和 Yang Guo 对本文草稿的反馈。感谢 Dinko Bajric 发明了“选择质数”技术，我发现它对内存泄漏分析很有帮助。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
