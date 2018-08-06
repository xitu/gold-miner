> * 原文地址：[Logging Activity With The Web Beacon API](https://www.smashingmagazine.com/2018/07/logging-activity-web-beacon-api/)
> * 原文作者：[Drew](https://www.smashingmagazine.com/author/drew-mclellan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/logging-activity-web-beacon-api.md](https://github.com/xitu/gold-miner/blob/master/TODO1/logging-activity-web-beacon-api.md)
> * 译者： [Elliott Zhao](https://github.com/elliott-zhao)
> * 校对者：

# 使用 Web Beacon API 记录活动

Beacon API是一种从网页把信息传递给服务器的轻量并且高效的方法。我们来了解一下如何使用它，以及它与传统的 Ajax 技术有何不同。

![](https://d33wubrfki0l68.cloudfront.net/a2b586e0ae8a08879457882013f0015fa9c31f7c/9e355/images/drop-caps/t.svg)

Beacon API 是一个基于 JavaScript 的 Web API，用于将少量数据从浏览器发送到 Web 服务器，而无需等待响应。在本文中，我们将介绍它可以用在哪些场景，它和其他类似的技术，如 `XMLHTTPRequest`(‘Ajax’)有何不同，以及如何开始使用它。

如果您知道为什么要使用 Beacon，你可以随时直接跳到[入门](＃getting-started)部分。

### Beacon API 是做什么用的？

Beacon API用于将少量数据发送到服务器，而**无需等待响应**。最后一句是关键，指出了为何 Beacon 如此有用 —— 我们的代码也永远不会收到响应，即使服务器发送了一个。Beacon 专门用于发送数据然后忘记它。我本并不期待一个响应，而且我们也不会得到响应。

可以把它想象成度假时发回家的明信片。你把少量数据放在上面（有点类似于“真希望你也在这”和“天气真好”），把它放进信箱，你不会期待响应。没有人会给明信片回信说“是呀，我希望我真的在那儿，非常感谢！”

对于现代网站和应用，有很多用例都巧妙地融入了这种发送然后忘记模式。

让这个过程表现得**刚刚**好并不是个简单的任务。这就是为什么我们设置**“我这样工作”的会话** —— 智能 cookie 共享取得了很好的效果。当然，这是 [Smashing 会员服务](http://smashed.by/casestudypanelmembership)的一部分。

#### 跟踪统计数据和数据分析

大多数人想到的第一个用例是分析。像 Google Analytics 这样的大型解决方案可能会对页面访问等内容进行很好的概述，但如果我们想要更加个性化的内容呢？我们可以编写一些 JavaScript 来跟踪页面中发生的事情（可能是用户如何与组建交互，或者在听从 CTA 建议之前阅读过哪篇文章），然而我们还需要在用户离开页面的时候发送这些数据到服务器。Beacon 可以完美做到这一点，因为我们只是记录数据而不需要响应。

我们没有理由不能涵盖通常交给 Google Analytics 处理的那些普通任务，基于用户本身和他们的设备与浏览器的功能上报数据。如果用户登录了会话，你甚至可以把这些统计信息绑定到已知的个人。无论您收集什么数据，都可以使用 Beacon 将其发送回服务器。

#### 调试和日志

此行为的另一种有用的应用是从 JavaScript 代码中记录信息。假设你的页面上有一个复杂的交互组件，可以完美的通过所有的测试，但是在生产环境上偶尔失败。你知道出现了失败，但是你没有办法看到错误信息，从而开始调试。如果您可以从代码中嗅探到失败本身，则可以收集诊断信息并使用 Beacon 将其全部发回以进行记录。

实际上，任何日志任务都可以使用 Beacon 执行，例如游戏中创建检查点，收集有关功能使用的信息，或记录多变量测试的结果。如果您希望服务器知道在浏览器中发生的某件事，那么 Beacon 可能是一个有力的竞争者。

### 我们不是早就能做到了么？

我知道你在想什么。没有任何新东西，不是么？十多年来，我们已经能够使用 `XMLHTTPRequest` 从浏览器与服务器进行通信。近期我们又有了 Fetch API， 使用了更现代的，基于 Promise 的接口做到很多相同的事。既然如此，拿我们为什么需要 Beacon API 呢？

这里的关键是因为我们没有得到响应，浏览器可以排队请求并发送它，**非阻塞执行**任何其他代码。就浏览器而言，无论我们的代码是否仍在运行，或者代码执行到哪都不重要，因为没有什么可以返回的，它可以直接把 HTTP 请求转到后台，直到方便发送的时候。

这可能意味着要等待 CPU 负载较低，或网络空闲，或者在可能的情况下直接发送。重要的是浏览器将 Beacon 排队并立即返回控制。它在发送 Beacon 的时候不会保持任何东西。

要理解为什么这是一个重大举措，我们需要看看如何和怎样从我们的代码发出这种请求。以我们的分析日志脚本为例。我们的代码可能会计算用户在页面上花费的时间，因此在最后一刻将数据发送回服务器变得至关重要。当用户要离开页面的时候，我们希望停止计时器并且把数据送回家。

一般来讲，你应该使用 `unload` 或者 `beforeunload` 事件来执行日志。这些事件会在用户做出类似点击连接导航到其他页面这种操作的时候出发。这里有个问题，在某个 `unload` 事件上运行的代码会阻塞执行并且延迟页面的卸载。如果页面卸载被延迟，那么加载下一个页面也会被延迟，因此体验上会感觉很迟钝。

你要记得 HTTP 请求到底有多慢。如果您正在考虑性能，通常您尝试减少的主要因素之一是额外的 HTTP 请求，因为向网络发送请求并获得响应可能会超级慢。你要做的最后一件事就是把这个耗时操作放在激活链接和开始请求下一个页面之间。

Beacon 通过不阻塞的把请求排队，即刻把控制权交还给你的代码的方式处理这一点。然后浏览器负责在后台不阻塞地发送该请求。这使得一切都快得多，这让用户更高兴，也让我们都保住了工作。

### 入门

因此，我们了解 Beacon 是什么，以及为什么我们要用到它，所以让我们从一些代码开始。基础简单到不能再简单：

```
let result = navigator.sendBeacon(url, data);
```

结果是 boolean，如果浏览器接受并且把请求排队了则返回 `true`，如果在这个过程中出现了问题就返回 `false`。

#### 使用 `navigator.sendBeacon()`

`navigator.sendBeacon` 接受两个参数。第一个参数是请求的 URL。请求作为 HTTP POST 执行，发送在第二个参数中提供的任何数据。

数据参数可以是多种格式中的任何一种，这些是直接从 Fetch API 中拿过来的。可以试一个 `Blob`，一个 `BufferSource`，`FormData` 或者 `URLSearchParams`—— 基本上是使用 Fetch 创建请求时使用的任何请求体类型。

对于基础的键值数据，我喜欢使用 `FormData`，因为它不复杂也很容易读回。

```
// 将数据发送目标 URL
let url = '/api/my-endpoint';
    
// 创建一个新的 FormData 并添加一个键值对
let data = new FormData();
data.append('hello', 'world');
    
let result = navigator.sendBeacon(url, data);
    
if (result) { 
  console.log('Successfully queued!');
} else {
  console.log('Failure.');
}
```

#### 浏览器支持

在浏览器中对 Beacon 的支持很好，唯一值得注意的例外是 Internet Explorer（在 Edge 中能用）和 Opera Mini。对于大部分的用途，这应该是可以的，但是在尝试使用 `navigator.sendBeacon` 之前尽情测试也是值得的。

```
很简单就能做到：

    if (navigator.sendBeacon) {
      // Beacon 代码
    } else {
      // 没有 Beacon或许可以回退到 XHR？
    }
```

如果 Beacon 不可用，而且这个请求很重要，你可以回退到 XHR 等阻塞方法。取决于你的受众和目标，你同样可以选择不理会。

### 一个例子：记录在页面上停留的时间

为了在实践中理解，让我们创建一个基本的系统来记录用户停留在页面上的时间。当页面加载时，我们会记录下时间，当用户离开页面时，我们将发送开始时间和当前时间到服务器。

由于我们只关心所花费的时间（而不是实际的时间），所以我们可以使用 `performance.now()` 来获得页面加载时的基本时间戳。

```
let startTime = performance.now();
```

如果我们把日志放到一个函数中，我们可以在页面卸载时调用它。

```
let logVisit = function() {
  // 测试我们拥有 Beacon 支持
  if (!navigator.sendBeacon) return true;
      
  // 数据发送的URL的例子
  let url = '/api/log-visit';
      
  // 要发送的数据
  let data = new FormData();
  data.append('start', startTime);
  data.append('end', performance.now());
  data.append('url', document.URL);
      
  // 出发！
  navigator.sendBeacon(url, data);
};
```

最后，当用户离开页面时，我们需要调用这个函数。我本能地想使用 `unload` 事件，但是 Mac 上的 Safari 似乎用安全警告阻止了请求，所以我们在这边使用 `beforeunload` 会更好一些。

```
window.addEventListener('beforeunload', logVisit);
```

当页面卸载（或者马上要卸载）的时候，我们的 `logVisit()` 函数会被调用，如果浏览器支持 Beacon API 的话，我们的 Beacon 就会被发送。

（注意，如果没有 Beacon 支持，我们返回 `true` ，假装它正常工作。返回 `false` 会取消事件并且终止页面卸载。那就倒霉了。）

### 跟踪时的注意事项

由于 Beacon 的许多潜在用途都围绕着活动跟踪，我认为，当我们的日志和跟踪可能被绑定到用户时，开发人员的社会责任和法律责任就更不用说了。

#### GDPR

我们可以考虑最近欧洲的 GDPR 法案，它们和电子邮件有关，不过当然，这些法律也涉及任何形式的个人数据的存储。如果你知道你的用户是谁，并且可以识别他们的会话，那么你应该检查你正在记录的活动，以及它与你所声明的策略有何关系。

通常，我们不需要像开发人员告诉我们的那样，跟踪尽可能多的数据。最好是故意**不**存储能用来识别用户的信息，然后减少把事情搞砸的可能性。

#### DNT: Do Not Track

除了法律要求之外，大多数浏览器都有一个设置来允许用户表达不想被跟踪的意愿。Do Not Track 会随请求发送这样一个 HTTP 报头：

```
DNT: 1
```

如果您正在记录可以跟踪特定用户的数据，并且用户发送了一个正数的 `DNT` 报头，那么最好遵循用户的意愿并且匿名化该数据，或者根本不跟踪它。

例如，在PHP中，您可以很容易地检测这个报头如下：

```
if (!empty($_SERVER['HTTP_DNT'])) { 
  // 用户不想被跟踪…… 
}
```

### 总结

Beacon API 是从页面返回数据到服务器的一种非常有用的方式，尤其是在日志上下文中。浏览器支持非常广泛，它可以使您无缝地记录数据，而不会对用户的浏览体验和网站性能造成负面影响。请求的非阻塞性意味着性能比 XHR 和 Fetch 等替代方案好很多。

如果你想阅读更多关于 Beacon API 的文章，下面的网站值得一看。

*   “[W3C Beacon 规范](https://www.w3.org/TR/beacon/)”，W3C 备选推荐
*   “[MDN Beacon 文档](https://developer.mozilla.org/en-US/docs/Web/API/Beacon_API)”，MDN 网络文档，Mozilla
*   “[浏览器支持信息](https://caniuse.com/#feat=beacon)”，caniuse.com

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
