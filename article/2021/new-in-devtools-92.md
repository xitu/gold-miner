> * 原文地址：[What's New In DevTools (Chrome 92)](https://developer.chrome.com/blog/new-in-devtools-92/)
> * 原文作者：[Jecelyn Yeen](https://jec.fyi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/new-in-devtools-92.md](https://github.com/xitu/gold-miner/blob/master/article/2021/new-in-devtools-92.md)
> * 译者：[Usualminds](https://github.com/Usualminds)
> * 校对者：[KimYangOfCat](https://github.com/KimYangOfCat)、[Chorer](https://github.com/Chorer)、[finalwhy](https://github.com/finalwhy)

![](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/XtJztwxzQqOWhOHrKmhM.jpg?auto=format)

# Chrome 92 DevTools 的新功能

## CSS 网格编辑器

`CSS Grid` 编辑器是一个社区呼声很高的特性。现在你可以通过它来预览和创建 `CSS Grid` 布局了。

![CSS Grid 编辑器](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/mV9Ac7QAD8vVPoiqmii6.png?auto=format)

当页面上的 HTML 元素应用了 `display: grid` 或者 `display: inline-grid` 样式时，你可以在样式面板中看到一个图标在它的旁边。单击它就可以切换到 CSS grid 编辑器。在编辑器里，你可以通过屏幕上的图标预览页面的可能发生的变化。（比如：`justify-content: space-around`），只需要点击一下就可以创建网格对应的外观布局。

> Chromium issue: [1203241](https://crbug.com/1203241)

## 控制台支持 `const` 常量重复声明 

除了支持现有的 [`let` 和 `class` 重复声明](/blog/new-in-devtools-80/#redeclarations)外，控制器现在也支持了 `const` 常量的重复声明。无法重复声明常量对 web 开发者来说是一个令人头疼的问题，因为他们经常需要通过控制台来调试 JavaScript 代码。

这样允许开发人员将代码直接复制到 DevTools 控制台，进而查看其工作原理或进行相关调试，对代码进行小范围修改，并且是在不刷新页面的情况下，对该过程进行重复。以前，如果代码中重复声明了 `const` 绑定的常量，DevTools 是会抛出语法错误的。

可以参考下面的例子。在**不同的 REPL 脚本**中支持 `const` 常量的重复声明（参考变量 `a`）。需要注意的是，以下场景是不予支持的：

* 页面脚本中的 `const` 重复声明，在 REPL 脚本中是不允许的
* 同一个 REPL 脚本中的 `const` 变量，也是不允许重复声明的（参考变量 `b`）

![const 变量重复声明](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/tJCPlokvxw6OWyCAmocM.png?auto=format)

> Chromium issue: [1076427](https://crbug.com/1076427)

## 源代码查看器 

你可以在屏幕上查看页面元素的排列顺序，这可以更好地进行可访问性检查。

![源代码查看器](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/2QoBtjGjFxgDAkKaO3y2.png?auto=format)

HTML 文档中内容的顺序对于搜索引擎优化和提升可访问性至关重要。新的 CSS 特性允许开发人员创建页面内容，这些新创建的内容，在屏幕上的顺序和原来 HTML 文档中的顺序大不相同。这会导致很大的可访问性问题，因为使用屏幕阅读器的用户可能获得和正常用户不同的内容，这是最可能使人感到困惑的用户体验。

> Chromium issue: [1094406](https://crbug.com/1094406)

## 新的查看 iframe 的快捷方式

通过右键单击元素面板中的 iframe 元素，并选择 **Show iframe details** 来查看 iframe 的详细信息。

![Show frame details](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/YdENg6wjsgPNyMODdOHC.png?auto=format)

你可以在应用面板（Application）中查看 iframe 详细信息视图，在该面板中可以检查文档详细信息、安全性和隔离状态、权限策略等以调试可能存在的问题。

![Frame details view](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/YdENg6wjsgPNyMODdOHC.png?auto=format)

> Chromium issue: [1192084](https://crbug.com/1192084)

## 增强的 CORS 调试支持 

跨域资源共享（CORS）错误会展示在“问题”选项卡中。造成 CORS 错误的原因有很大。你可以单击展开每个问题来了解可能的原因和解决方法。

![CORS issues in the Issues tab](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/UpiZQCNnlENB8ZluzeFt.png?auto=format)

> Chromium issue: [1141824](https://crbug.com/1141824)

## Network 面板更新

### 重命名 XHR 标签为 Fetch/XHR 

XHR 标签现在被重命名为 **Fetch/XHR**。这个变更更明确地说明来该过滤器同时包含了 [`XMLHttpRequest`](https://xhr.spec.whatwg.org/) 和 [Fetch API](https://fetch.spec.whatwg.org/) 两种类型的网络请求。

![Fetch/XHR label](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/I0QOVTO52JRpl0jJO6Zt.png?auto=format)

> Chromium issue: [1201398](https://crbug.com/1201398)

### Network 面板中过滤新增 Wasm 过滤类型

现在你可以单击新的 **Wasm** 按钮来过滤 Wasm 类型的网络请求。

![Filter by Wasm](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/vuTMcfCjDWFfVtDN6Dpf.png?auto=format)

> Chromium issue: [1103638](https://crbug.com/1103638)

### Network 状态面板新增提示用户代理端设备选项

[用户代理端提示](https://web.dev/user-agent-client-hints)（User-Agent Client Hints）现在迁移到 **Network conditions** 标签下的 **User agent** 字段中。

用户代理端提示（User-Agent Client Hints）是 Client Hints API 的一个新扩展，它允许开发人员以保护隐私和符合人体工程学的方式访问用户的浏览器信息。。

![Network 状态面板新增提示用户代理端设备选项](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/iMlkTtV9OUdfujSWdHnR.png?auto=format)

> Chromium issue: [1174299](https://crbug.com/1174299)

## 在 Issues 标签页中反馈兼容模式问题

DevTools 现在可以反馈[兼容模式](https://quirks.spec.whatwg.org/) 和[受限兼容模式](https://dom.spec.whatwg.org/#concept-document-limited-quirks)问题。

兼容模式和受限兼容模式是网络标准制定之前就遗留下来的浏览器模式。这些模式模拟的是标准时代之前的布局行为，通常它们会产生意料之外的视觉效果。

当调试布局问题时，开发人员可能会误认为它们是由用户编写的 CSS 或 HTML bug 导致的问题，而真正的问题是页面所在的 Compat 模式。DevTools 提供了修复该问题的建议。

![Report Quirks mode issues in the Issues tab](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/XqtqSZPa1S1YnmeIt0ee.png?auto=format)

> Chromium issue: [622660](https://crbug.com/622660)

## Performance 面板中新增计算交集

DevTools 现在可以在火焰图中展示**计算交集**。这个变化可以帮助你识别[交集观察](https://web.dev/intersectionobserver-v2/)事件，并调试其的性能开销。

![Compute Intersections in the Performance panel](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/Nx3K0Lpst0lICGbtpzsW.png?auto=format)

> Chromium issue: [1199137](https://crbug.com/1199137)

## Lighthouse 面板 7.5 版本

Lighthouse 面板现在运行的是 7.5 版本了。由于 CSS images 的新特性 `aspect-ratio`，"缺少明确的宽带和高度（missing explicit width and height）" 的警告现在已经被移除，此前，Lighthouse 会对没有明确宽高的图像显示警告。

查看[发布说明](https://github.com/GoogleChrome/lighthouse/releases/tag/v7.5.0)以获取完整的变更列表。

> Chromium issue: [772558](https://crbug.com/772558)

## 调用栈弃用 "Restart frame" 上下文菜单

**Restart frame** 选项已弃用。这个功能需要进一步完善才可以正常工作，目前它已经崩溃，并且经常如此。

![弃用 restart frame 上下文菜单](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/Alvnt4FkoEFoP0SkdKgi.png?auto=format)

> Chromium issue: [1203606](https://crbug.com/1203606)

## \[实验阶段\] 协议监控器

如果要启用该实验性质功能，请开启 **Settings** \> **Experiments** 下的 **Protocol Monitor** 选项。

Chrome DevTools 使用 [Chrome DevTools 协议 (CDP)](https://chromedevtools.github.io/devtools-protocol/) 来检测、调试和配置 Chrome 浏览器。**协议监控器** 为你提供了一种查看所有 CDP 请求和 DevTools 响应的方法。

新增了两个功能，方便 CDP 测试：

一个是新的 **Save** 按钮允许你下载历史记录消息的 JSON 文件；一个是新的字段，允许你直接发送一个原始的 CDP 命令。

![协议监控](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/mRVrHC9WEet7cwA7QAeV.png?auto=format)

> Chromium issues: [1204004](https://crbug.com/1204004), [1204466](https://crbug.com/1204466)

## \[实验阶段\] Puppeteer Recorder 

如果要启用该实验性质功能，请开启 **Settings** \> **Experiments** 下的 **Recorder** 选项。

[Puppeteer recorder](/blog/new-in-devtools-89/#record) 现在可以根据你和浏览器的交互生成一个操作步骤列表，而之前的 DevTools 则是直接生成一个 Puppeteer 脚本。添加了另一个新的 **Export** 按钮，允许你以 Puppeteer 脚本的形式导出这些步骤。

记录完这些操作步骤后，你可以使用新的 **Replay** 按钮来重放这些步骤。可以按照这个[说明](/blog/new-in-devtools-89/#record)来学习如何开始记录浏览器操作步骤。

请注意，这是一个早期的实验功能。我们计划随着时间的推移改善和扩展 Recorder 的功能。

![Puppeteer Recorder](https://developer-chrome-com.imgix.net/image/dPDCek3EhZgLQPGtEG3y0fTn4v82/kh1Z4jcWxbO6rYCSoIPn.png?auto=format)

> Chromium issue: [1199787](https://crbug.com/1199787)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
