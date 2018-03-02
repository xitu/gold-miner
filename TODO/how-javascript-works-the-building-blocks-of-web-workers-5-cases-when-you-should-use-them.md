> * 原文地址：[How JavaScript works: The building blocks of Web Workers + 5 cases when you should use them](https://blog.sessionstack.com/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them-a547c0757f6a)
> * 原文作者：[Alexander Zlatkov](https://blog.sessionstack.com/@zlatkov?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-javascript-works-the-building-blocks-of-web-workers-5-cases-when-you-should-use-them.md)
> * 译者：[刘嘉一](https://github.com/lcx-seima)
> * 校对者：[缪宇](https://github.com/goldEli)，[MechanicianW](https://github.com/MechanicianW)

# JavaScript 工作原理：Web Worker 的内部构造以及 5 种你应当使用它的场景

![](https://cdn-images-1.medium.com/max/800/0*b5WMJNTRt9QqN-Zy.jpg)

这是探索 JavaScript 及其内建组件系列文章的第 7 篇。在认识和描述这些核心元素的过程中，我们也会分享我们在构建 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=source&utm_content=javascript-series-web-workers-intro) 时所遵循的一些经验规则。SessionStack 是一个轻量级 JavaScript 应用，它协助用户实时查看和复现他们的 Web 应用缺陷，因此其自身不仅需要足够健壮还要有不俗的性能表现。

如果你错过了前面的文章，你可以在下面找到它们：

* [对引擎、运行时和调用栈的概述](https://juejin.im/post/5a05b4576fb9a04519690d42)
* [深入 V8 引擎以及 5 个写出更优代码的技巧](https://juejin.im/post/5a102e656fb9a044fd1158c6)
* [内存管理以及四种常见的内存泄漏的解决方法](https://juejin.im/post/59ca19ca6fb9a00a42477f55)
* [事件循环和异步编程的崛起以及 5 个如何更好的使用 async/await 编码的技巧](https://juejin.im/post/5a221d35f265da43356291cc)
* [JavaScript 是如何工作的：深入剖析 WebSockets 和拥有 SSE 技术 的 HTTP/2，以及如何在二者中做出正确的选择](https://juejin.im/post/5a522647518825732d7f6cbb)
* [JavaScript 工作原理：与 WebAssembly 一较高下 + 为何 WebAssembly 在某些情况下比 JavaScript 更为适用](https://blog.sessionstack.com/how-javascript-works-a-comparison-with-webassembly-why-in-certain-cases-its-better-to-use-it-d80945172d79)

这一次我们将剖析 Web Worker：对它进行简单概述后，我们将分别讨论不同类型的 Worker 以及它们内部组件的运作方法，同时也会以场景为例说明它们各自的优缺点。在文章的最后，我们将讲解最适合使用 Web Worker 的 5 个场景。

我们在 [之前的文章](https://juejin.im/post/5a522647518825732d7f6cbb) 中已经详尽地讨论了 JavaScript 的单线程运行机制，对此你应当已经了然于胸。然而，JavaScript 是允许开发者在单线程模型上书写异步代码的。

#### 异步编程的 “天花板”

我们已经讨论过了 [异步编程](https://blog.sessionstack.com/how-javascript-works-event-loop-and-the-rise-of-async-programming-5-ways-to-better-coding-with-2f077c4438b5?source=---------2----------------) 的概念及其使用场景。

异步编程通过把部分代码 “放置” 到事件循环较后的时间点执行，保证了 UI 渲染始终处于较高的优先级，这样你的 UI 就不会出现卡顿无响应的情况。

AJAX 请求是异步编程的最佳实践之一。通常网络请求不会在短时间内得到响应，因此异步的网络请求能让客户端在等待响应结果的同时执行其他业务代码。

```
// 假设你使用了 jQuery
jQuery.ajax({
    url: 'https://api.example.com/endpoint',
    success: function(response) {
        // 正确响应后需要执行的代码
    }
});
```

当然这里有个问题，上例能够进行异步请求是依靠了浏览器提供的 API，其他代码又该如何实现异步执行呢？例如，在上例 success 回调函数中存在 CPU 密集型计算：

```

var result = performCPUIntensiveCalculation();
```

假如 `performCPUIntensiveCalculation` 不是一个 HTTP 请求，而是一段可以阻塞线程的代码（例：一段巨型 `for` 循环代码）。这样会使 event loop 不堪重负，浏览器 UI 也随之阻塞 —— 用户将面对卡顿无响应的网页。

这就说明了使用异步函数只能解决 JavaScript 单线程模型带来的一小部分问题。

在一些因大量计算引起的 UI 阻塞问题中，使用 `setTimeout` 来解决阻塞的效果还不错。例如，我们可以把一系列的复杂计算分批放到单独的 `setTimeout` 中执行，这样做等于是把连续的计算分散到了 event loop 中的不同位置，以此为 UI 的渲染和事件响应让出了时间。

让我们来看一个简单的计算数组均值的函数：

```

function average(numbers) {
    var len = numbers.length,
        sum = 0,
        i;

    if (len === 0) {
        return 0;
    } 
    
    for (i = 0; i < len; i++) {
        sum += numbers[i];
    }
   
    return sum / len;
}
```

下面是对上方代码的一个重写，使其获得了异步性：

```
function averageAsync(numbers, callback) {
    var len = numbers.length,
        sum = 0;

    if (len === 0) {
        return 0;
    } 

    function calculateSumAsync(i) {
        if (i < len) {
            // 把下一次函数调用放入 event loop
            setTimeout(function() {
                sum += numbers[i];
                calculateSumAsync(i + 1);
            }, 0);
        } else {
            // 计算完数组中所有元素后，调用回调函数返回结果
            callback(sum / len);
        }
    }

    calculateSumAsync(0);
}
```

通过使用 `setTimeout` 可以把每一步计算都放置到 event loop 较后的时间点执行。在每两次的计算间隔，event loop 便会有足够的时间执行其他计算，从而保证浏览器不会一 ”冻“ 不动。

#### 拯救你于水火之中的 Web Worker

[HTML5](https://www.w3schools.com/html/html5_intro.asp) 已经提供了不少开箱即用的好东西，包括：

* SSE （在 [上一篇文章](https://blog.sessionstack.com/how-javascript-works-deep-dive-into-websockets-and-http-2-with-sse-how-to-pick-the-right-path-584e6b8e3bf7) 中已经谈过它的特性并与 WebSocket 进行了对比)
* 地理信息
* 应用缓存
* LocalStorage
* 拖放手势
* **Web Worker**

Web Worker 是内建在浏览器中的轻量级 **线程**，使用它执行 JavaScript 代码不会阻塞 event loop。

非常神奇吧，本来 JavaScript 中的所有范例都是基于单线程模型实现的，但这里的 Web Worker 却（在一定程度上）突破了这一限制。

从此开发者可以远离 UI 阻塞的困扰，通过把一些执行时间长、计算密集型的任务放到后台交由 Web Worker 完成，使他们的应用响应变得更加迅速。更重要的是，我们再也不需要对 event loop 施加任何的 `setTimeout` 黑魔法。

这里有一个简单的数组排序 [demo](http://afshinm.github.io/50k/) ，其中对比了使用 Web Worker 和不使用 Web Worker 时的区别。

#### **Web Worker 概览**

Web Worker 允许你在执行大量计算密集型任务时，还不阻塞 UI 进程。事实上，二者互不不阻塞的原因就是它们是并行执行的，可以看出 Web Worker 是货真价实的多线程。

你可能想说 — ”JavaScript 不是一个在单线程上执行的语言吗？“。

你可能会惊讶 JavaScript 作为一门编程语言，却没有定义任何的线程模型。因此 Web Worker 并不属于 JavaScript 语言的一部分，它仅仅是浏览器提供的一项特性，只是它可以被 JavaScript 访问、调用罢了。过往的众多浏览器都是单线程程序（以前的理所当然，现在也有了些许变化），并且浏览器一直以来也是 JavaScript 主要的运行环境。对比在 Node.JS 中就没有 Web Worker 的相关实现 — 虽然 Web Worker 对应着 Node.JS 中的 “cluster” 或 “child_process” 概念，不过它们还是有所区别的。

值得注意的是，Web Worker 的 [定义](http://www.whatwg.org/specs/web-workers/current-work/) 中一共包含了 3 种类型的 Worker：

* [Dedicated Worker（专用 Worker）](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers)
* [Shared Worker（共享 Worker）](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorker)
* [Service worker（服务 Worker）](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorker_API)

#### Dedicated Worker（专用 Worker）

Dedicated Worker 由主线程实例化且只能与它通信。

![](https://cdn-images-1.medium.com/max/800/1*ya4zMDfbNUflXhzKz9EBIw.png)

Dedicated Worker 浏览器兼容性一览

#### Shared Worker（共享 Worker）

Shared Worker 可以被同一域（浏览器中不同的 tab、iframe 或其他 Shared Worker）下的所有线程访问。

![](https://cdn-images-1.medium.com/max/800/1*lzOIevUBVy5eWyf2kHf--w.png)

Shared Worker 浏览器兼容一览

#### Service Worker（服务 Worker）

Service Worker 是一个事件驱动型 Worker，它的初始化注册需要网页/站点的 origin 和路径信息。一个注册好的 Service Worker 可以控制相关网页/网站的导航、资源请求以及进行粒度化的资源缓存操作，因此你可以极好地控制应用在特定环境下的表现（如：无网络可用时）。

![](https://cdn-images-1.medium.com/max/800/1*6o2TRDmrJlS97vh1wEjLYw.png)

Service Worker 浏览器兼容一览

在本文中，我们主要讨论 Dedicated Worker，后文的 ”Web Worker“ 或 “Worker” 都默认指代它。

#### Web Worker 工作原理

最终实现 Web Worker 的是一堆 `.js` 文件，网页会通过异步 HTTP 请求来加载它们。当然 [Web Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API) 已经包办了这一切，上述加载对使用者完全无感。

Worker 利用类似线程的消息机制保持了与主线程的平行，它是提升你应用 UI 体验的不二人选，使用 Worker 保证了 UI 渲染的实时性、高性能和快速响应。

Web Worker 是运行在浏览器内部的一条独立线程，因此需要使用 Web Worker 运行的代码块也必须存放在一个 **独立文件** 中。这一点需要牢记在心。

让我们看看，如何创建一个基础 Worker：

```
var worker = new Worker('task.js');
```

如果此处的 “task.js” 存在且能被访问，那么浏览器会创建一个新的线程去异步地下载源代码文件。一旦下载完成，代码将立刻执行，此时 Worker 也就开始了它的工作。
如果提供的代码文件不存在返回 404，那么 Worker 会静默失败并不抛出异常。

为了启动创建好的 Worker，你需要显式地调用 `postMessage` 方法：

```
worker.postMessage();
```

#### Web Worker 通信

为了使创建好的 Worker 和创建它的页面能够通信，你需要使用 `postMessage` 方法或 [Broadcast Channel（广播通道）](https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel).

#### 使用 postMessage 方法

在较新的浏览器中，postMessage 方法支持 `JSON` 对象作为函数的第一个入参，但是在旧版本浏览器中它还是只支持 `string`。

下面的 demo 会展示 Worker 是如何与创建它的页面进行通信的，同时我们将使用 JSON 对象作为通信体好让这个 demo 看起来稍微 “复杂” 一点。若改为传递字符串，方法也不言而喻了。

让我们看看下面的 HTML 页面（或者准确地说是片段）：

```
<button onclick="startComputation()">Start computation</button>

<script>
  function startComputation() {
    worker.postMessage({'cmd': 'average', 'data': [1, 2, 3, 4]});
  }
  var worker = new Worker('doWork.js');
  worker.addEventListener('message', function(e) {
    console.log(e.data);
  }, false);
  
</script>
```

这部分则是 Worker 脚本中的内容：

```
self.addEventListener('message', function(e) {
  var data = e.data;
  switch (data.cmd) {
    case 'average':
      var result = calculateAverage(data); // 一个计算数值型数组元素均值的函数
      self.postMessage(result);
      break;
    default:
      self.postMessage('Unknown command');
  }
}, false);
```

当主页面中的 button 被按下，触发调用了 `postMessage` 方法。`worker.postMessage` 这行代码会传递一个 `JSON` 对象给 Worker，对象中包含了 `cmd` 和 `data` 两个键以及它们对应的值。相应的，Worker 会通过定义的 `message` 响应方法拿到和处理上面传递过来的消息内容。

当消息到达 Worker 后，实际的计算便开始运行，这样完全不会阻塞 event loop。在此过程中，Worker 只会检查传递来的事件 `e`，然后像往常执行 JavaScript 函数一样继续执行。当最终执行完成，执行结果会回传回主页面。

在 Worker 的执行上下文中，`self` 和 `this` 都指向 Worker 的全局作用域。

> 有两种停止 Worker 的方法：1、在主页面中显示地调用 `worker.terminate()` ；2、在脚本中调用 `self.close()` 让 Worker 自行了断。

#### Broadcast Channel（广播通道）

[Broadcast Channel](https://developer.mozilla.org/en-US/docs/Web/API/BroadcastChannel) 是更纯粹地为通信而生的 API。它允许我们在同域下的所有的上下文中发送和接收消息，包括浏览器 tab、iframe 和 Worker：

```
// 创建一个到 Broadcast Channel 的连接
var bc = new BroadcastChannel('test_channel');

// 发送一段简单的消息
bc.postMessage('This is a test message.');

// 这是一个简单的事件 handler
// 我们会在 handler 中接收并打印消息到终端
bc.onmessage = function (e) { 
  console.log(e.data); 
}

// 断开与 Broadcast Channel 的连接
bc.close()
```

下图会帮助你理解 Broadcast Channel 的工作原理：

![](https://cdn-images-1.medium.com/max/800/1*NVT6WbNrH_mQL64--b-l1Q.png)

使用 Broadcast Channel 会有更严格的浏览器兼容限制：

![](https://cdn-images-1.medium.com/max/800/1*81mCsOzyJj-HfQ1lP_033w.png)

#### 消息的大小

一共有 2 种给 Web Worker 发送消息的方法：

* **拷贝消息：** 这种方法下消息会被序列化、拷贝然后再发送出去，接收方接收后则进行反序列化取得消息。因此上例中的页面和 Worker 不会共享同一个消息实例，它们之间每发送一次消息就会多创建一个消息副本。大多数浏览器都采用这样的发送方法，并且会在发送和接收端自动进行 JSON 编码/解码。如你所预料的，这些数据处理会给消息传送带来不小的负担。传送的消息越大，时间开销就越大。
* **传递消息：** 使用这种方法意味着消息发送者一旦成功发送消息后，就再也无法使用发出的消息数据了。消息的传送几乎不耗费任何时间，美中不足的是只有 [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer) 支持以这种方式发送。

#### Web Worker 中支持的 JavaScript 特性

因为 Web Worker 的多线程天性使然，它只能使用 **一小撮** JavaScript 提供的特性，列表如下：

* `navigator` 对象
* `location` 对象（只读）
* `XMLHttpRequest`
* `setTimeout()/clearTimeout()` 与 `setInterval()/clearInterval()`
* [应用缓存](https://www.html5rocks.com/tutorials/appcache/beginner/)
* 使用 `importScripts()` 引入外部 script
* [创建其他的 Web Worker](https://www.html5rocks.com/en/tutorials/workers/basics/#toc-enviornment-subworkers)

#### Web Worker 的局限性

令人遗憾的是 Web Worker 无法访问一些非常重要的 JavaScript 特性：

* DOM 元素（访问不是线程安全的）
* `window` 对象
* `document` 对象
* `parent` 对象

这意味着 Web Worker 不能做任何的 DOM 操作（也就是 UI 层面的工作）。刚开始这会显得略微棘手，不过一旦你学会了如何正确使用 Web Worker。你就只会把 Web Worker 用作单独的 ”计算机器“，而把所有的 UI 操作放到页面代码中。你可以把所有的脏活累活都交给 Web Worker 完成，再将它劳作的结果传到页面并在那里进行必要的 UI 操作。

#### 异常处理

像对待任何 JavaScript 代码一样，你希望处理 Web Worker 抛出的任何错误。当 Worker 在运行时发生错误，它会触发 `ErrorEvent` 事件。该接口包含 3 个有用的属性，它们能帮助你定位代码出错的原因：

* **filename** - 发生错误的 script 文件名
* **lineno** - 发生错误的代码行号
* **message** - 错误信息

这有一个例子：

```
function onError(e) {
  console.log('Line: ' + e.lineno);
  console.log('In: ' + e.filename);
  console.log('Message: ' + e.message);
}

var worker = new Worker('workerWithError.js');
worker.addEventListener('error', onError, false);
worker.postMessage(); // 不传递消息仅启动 Worker
```

```
self.addEventListener('message', function(e) {
  postMessage(x * 2); // 此行故意使用了未声明的变量 'x'
};
```

可以看到，我们在这儿创建了一个 Worker 并监听着它发出的 `error` 事件。

通过使用一个在作用域内未定义的变量 `x` 作乘法，我们在 Worker 内部（`workerWithError.js` 文件内）故意制造了一个异常。这个异常会被传递到最初创建 Worker 的 scrpit 中，同时调用 `onError` 函数。

#### Web Worker 的最佳实践

到此为止我们已经见识了 Web Worker 的强悍与不足，下面就一起来看看最适合使用它的场景有哪些：

* **光线追踪（Ray Tracing）：**：光线追踪属于计算机图形学中的 [渲染（Rendering）](https://en.wikipedia.org/wiki/Rendering_%28computer_graphics%29 "Rendering (computer graphics)") 技术，它会追踪并转换[光线](https://en.wikipedia.org/wiki/Light "Light") 的轨迹为一个个像素点，最终生成一张完整的图片。为模拟光线的轨迹，光线追踪需要 CPU 进行大量的数学计算。光线追踪包括模拟光的反射、折射及物质效果等。以上所有的计算逻辑都可以交给 Web Worker 完成，从而不阻塞 UI 线程的执行。或者更好的方案是使用多个 Worker （以及多个 CPU）来完成图片渲染。这有一个使用 Web Worker 进行光线追踪的 demo — [https://nerget.com/rayjs-mt/rayjs.html](https://nerget.com/rayjs-mt/rayjs.html).

* **加密：** 针对个人敏感数据的保护条例变得日益严格，端对端的数据加密也变得更为流行。当程序中需要经常加密大量数据时（如向服务器发送数据），加密成为了非常耗时的工作。Web Worker 可以非常好的切入此类场景，因为这里不涉及任何的 DOM 操作，Worker 中仅仅运行一些专为加密的算法。Worker 会勤恳地默默工作，丝毫不会打扰用户，也绝不会影响用户的体验。

* **数据预获取：** 为优化你的网站或 web 应用的数据加载时长，你可以使用 Web Worker 预先获取一些数据，存储起来以备后续使用。Web Worker 在这里发挥着重要作用，因为它绝不会影响应用的 UI 体验，若不使用 Web Worker 情况会变得异常糟糕。

* **Progressive Web App：** 当网络状态不是很理想时，你仍需保证 PWA 有较快的加载速度。这就意味着 PWA 的数据需要被持久化到本地浏览器中。在此背景下，一些与 [IndexDB](https://developer.mozilla.org/en-US/docs/Web/API/IndexedDB_API) 类似的 API 便应运而生了。从根本上来说，客户端一侧需要有数据存储能力。为保证存取时不阻塞 UI 线程，这部分工作理应交给 Web Worker 完成。好吧，在 IndexDB 中你可以不使用 Web Worker，因为它提供的异步 API 同样不会阻塞 UI。但是在这之前，IndexDB 提供的是同步API（可能会被再次引入），这种情况使用 Web Worker 还是非常有必要的。

* **拼写检查：** 进行拼写检查的基本流程如下 — 程序首先从词典文件中读取一系列拼写正确的单词。整个词典的单词会被解析为一个搜索树用于实际的文本搜索。当待测词语被输入后，程序会检查已建立的搜索树中是否存在该词。如果在搜索树中没有匹配到待测词语，程序会替换字符组成新的词语，并测试新的词语是否是用户期待输入的，如果是则会返回该词语。整个检测过程可以被轻松 “下放” 给 Web Worker 完成，Worker 会完成所有的词语检索和词语联想工作，这样一来用户的输入就不会阻塞 UI 了。

对 [SessionStack](https://www.sessionstack.com/?utm_source=medium&utm_medium=source&utm_content=javascript-series-web-workers-outro) 来说，保持高性能和高可靠性是极其重要的. 持有这种理念的主要原因是，一旦你的应用集成 SessionStack 后，它会开始记录从 DOM 变化、用户交互行为到网络请求、未捕获异常和 debug 信息的所有数据。收集到的跟踪数据会被 **实时** 发送到后台服务器，以视频的形式向你还原应用中出现的问题，帮助你从用户的角度重现错误现场。这一切功能的实现需要足够的快并且不能给你的应用带来任何性能上的负担。

这就是为什么我们尽可能地把 SessionStack 中，值得优化的业务逻辑交给 Web Worker 完成。诸如在核心监控库和播放器中，都包含了像 hash 数据完整性验证、渲染等 CPU 密集型任务，这些都是值得使用 Web Worker 优化的地方。

Web 技术持续向前变更和发展，所以我们宁肯先行一步也要保证 SessionStack 是一个不会给用户 app 带来任何性能损耗的轻量级应用。

如果阁下愿意试试 SessionStack ，这里有一个[免费的试用计划](https://www.sessionstack.com/?utm_source=medium&utm_medium=source&utm_content=javascript-series-web-workers-try-now)。

![](https://cdn-images-1.medium.com/max/800/1*YKYHB1gwcVKDgZtAEnJjMg.png)

#### 参考资料

* [https://www.html5rocks.com/en/tutorials/workers/basics/](https://www.html5rocks.com/en/tutorials/workers/basics/)
* [https://hacks.mozilla.org/2015/07/how-fast-are-web-workers/](https://hacks.mozilla.org/2015/07/how-fast-are-web-workers/)
* [https://developer.mozilla.org/en-US/docs/Web/API/Broadcast_Channel_API](https://developer.mozilla.org/en-US/docs/Web/API/Broadcast_Channel_API)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
