> * 原文地址：[Understanding WebViews](https://www.kirupa.com/apps/webview.htm)
> * 原文作者：[kirupa](https://www.kirupa.com/me/index.htm)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-webviews.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-webviews.md)
> * 译者：[子非](https://github.com/CoolRice)
> * 校对者：[swants](https://github.com/swants), [wuyanan](https://github.com/wuyanan)

# 理解 WebView

我们通常使用 Chrome, Firefox, Safari, Internet Explorer 和 Edge 等浏览器来浏览网页。你也许正在使用其中一种浏览器阅读本文！虽然浏览器对于访问互联网内容的任务来说非常流行，它们还有一些我们从未过多关注过的竞争对手。这些竞争对手以 **WebView** 的形式被我们所熟知。这片文章将讲解 WebView 的神秘之处以及为什么它这么棒。

我们继续！

## WebView 入门知识

让我们来点无聊的定义。**WebView 是一种嵌入式浏览器，原生应用可以用它来展示网络内容**。这句话有两部分要注意：

1.  第一，**原生应用（亦称 app）**。原生应用由专门为特定平台设计的编程语言和 UI 框架编写：

![](https://www.kirupa.com/apps/images/native_app_200.png)

> 换句话说，应用不是指在浏览器中运行的跨平台网络应用。相反，你的应用主要是用像 Swift、Objective-C、Java、C++、C# 语言来编写的。这种工作方式与系统更加贴近。在这样的背景下，你使用的大多数应用都应该是原生应用。许多流行的应用，比如你的台式机/笔记本上的 Microsoft Office 也是如此。

2.  第二个处需要注意的是**嵌入式浏览器**。我们都知道浏览器是什么。它是让我们可以在网上冲浪的独立应用：

![](https://www.kirupa.com/apps/images/browser_raccoon_200.jpg)

> 如果你把浏览器想象成两部分，一部分是 UI（地址栏，导航栏按钮等），其它部分是把标记跟代码转换成我们可见和可交互视图的引擎。

![](https://www.kirupa.com/apps/images/browser_ui_engine_200.jpg)

> WebView 就是浏览器引擎部分，你可以像插入 iframe 一样将 Webview 插入到你的原生应用中，并且编程化的告诉它将会加载什么网页内容。

把所有的这些概念放到一起并简单整合下，WebView 只是一个可视化的组件/控件/微件等。这样我们可以用它来作为我们原生 app 的视觉部分。当你使用原生应用时，WebView 可能只是被隐藏在普通的原生 UI 元素中，你甚至用不到注意到它。

![](https://www.kirupa.com/apps/images/webview_200.png)

你的 WebView 就像是原生组件海洋里一座对 Web 友好的岛。对于你的应用来说这座岛的内容不需要存储在本地。你的 WebView 通常会从 http:// 或者 https:// 地址下载网络内容。这意味着你可以从服务器中获取部分（或全部）Web 应用并且依赖 Webview 将这部分内容展示在原生应用中：

![](https://www.kirupa.com/apps/images/webview_html5_remote_200.png)

这种灵活性打开了一个浏览器端的 Web 应用和希望展示在原生应用中的 Web 应用代码之间可重用的世界。这一切听起来真的非常棒……

运行在你的 WebView 中的 JavaScript **有能力调用原生的系统 API**。这意味着你不必受到 Web 代码通常必须遵守的传统浏览器安全沙箱的限制。下图解释了使这样成为可能的架构差异：

![](https://www.kirupa.com/apps/images/webview_browser_2_200.png)

默认情况下，在 WebView 或 Web 浏览器中运行的任何 Web 代码都与应用的其余部分保持隔离。这样做是出于安全原因，主要是为降低恶意的 JavaScript 代码对系统造成的伤害。如果浏览器或 WebView 出现故障，那很不幸，但**可以接受**。如果整个系统发生故障，那很不幸……并且**这样不能接受**。对于任意 Web 内容，这种安全级别很有意义。你永远不能完全信任加载的 Web 内容。WebView 的情况并非如此。对于 WebView 方案，开发人员通常可以完全控制加载的内容。恶意代码进入并在设备上造成混乱的可能性非常低。

这就是为什么对于 WebView，开发人员可以使用各种受支持的方式来覆盖默认的安全行为，并让 Web 代码和原生应用代码相互通信。这种沟通通常称为 **bridge**。你可以在前面的图表中看到 **bridge** 可视化为 Native Bridge 和 JavaScript Bridge 的一部分。详细了解这些 bridge 的内容超出了本文的范围，但要点如下：**为 Web 编写的相同 JavaScript 不仅可以在 WebView 中运行，还可以调用原生 API 并帮助你的应用更深入地集成酷炫的系统级功能，如传感器，存储，日历/联系人等。**

## WebView 用例

现在我们已经了解了 WebView 的概况以及他们所拥有的一些强大作用，让我们退后一步，看看我们一些在原生应用中受欢迎的 WebView 的用例情况。

### App 内置浏览器

WebView 最常见的用途之一是显示链接的内容。在移动设备上启动浏览器，将用户从一个应用切换到另一个应用以及希望他们找到返回应用的操作尤其令人失望。WebView 通过在应用本身内完全加载链接的内容来很好地解决这个问题。

看看下面的视频，了解当我们点击 Twitter 或 Facebook 应用中的链接时会发生什么：

Twitter 和 Facebook 都没有在默认浏览器中加载链接的内容。他们使用 WebView 伪造应用内浏览器并将内容呈现为应用体验本身的一部分。Twitter 的应用内浏览器看起来非常简单，但 Facebook 则更进一步，做了一个看起来很棒的地址栏甚至还有一个漂亮的菜单：

![](https://www.kirupa.com/apps/images/fb_browser.jpg)

选择 Twitter 和 Facebook 做例子是因为我安装了这两个应用，并且可以随时录制视频与大家分享。有许多应用通过依赖 WebView 作为应用内浏览器来以类似的方式打开链接。

### 广告

广告仍然是原生应用最流行的赚钱方式之一。这些广告大部分是如何投放的？答案是**通过 WebView 提供的 Web 内容**：

![](https://www.kirupa.com/apps/images/inline_webview.png)

虽然原生广告确实存在，但大多数原生解决方案在幕后使用 WebView，并从集中式广告服务器提供类似于你在浏览器中看到的广告。

### 全屏混合应用

到目前为止，我们一直在将 WebView 视为舞台上的次要支持角色，并由原生应用和其他原生 UI 元素完全支配。WebView 具有成为明星的深度和广度，并且在一大类应用中 WebView 内部加载的 Web 内容**构成了整个应用用户体验**：

![](https://www.kirupa.com/apps/images/hybrid_200.png)

这些应用被称为**混合应用**。从技术角度来看，这些仍然是原生应用。事实上，这些应用所做的唯一原生操作就是托管 WebView，而 WebView 又加载 Web 内容和用户交互的所有 UI。混合应用很受欢迎有几个原因。最大的一个是**开发人员生产力**。如果你有一个在浏览器中运行的响应式 Web 应用，那么在各种设备上使用相同的应用作为混合应用会非常简单：

![](https://www.kirupa.com/apps/images/webview_hybrid_everywhere_200.png)

当你对 Web 应用进行更新时，所有使用它的设备都可以立即使用该更改，因为内容来自一个集中位置，也就是你的服务器：

![](https://www.kirupa.com/apps/images/webview_hybrid_everywhere_updated_200_2.png)

如果你必须使用纯原生应用，不仅需要为构建应用的每个平台更新项目，你可能必须经历耗时的应用审核过程才能使你的更新在所有的应用商店获取到。从部署和更新的角度来看，混合应用非常方便。将这种便利性与原生设备访问相结合能为你的 Web 应用提供超能力，这样你就拥有了一个成功的技术解决方案。WebView 使一切成为可能。

### 原生应用扩展

你将看到 WebView 使用的最后一个大类与可扩展性有关。许多原生应用（尤其是桌面应用）为你提供了一种通过安装加载项或扩展程序来扩展其功能的方法。由于 Web 技术的简单性和强大，这些加载项和扩展通常以 HTML、CSS 和 JavaScript 而不是 C++，C# 或其他方式构建。一个流行的例子是 Microsoft Office。构成 Microsoft Office 的各种应用尽可能是原生和经典的方式，但是为其构建扩展的方法之一就涉及 Web 技术。例如，一个流行的此类扩展是[维基百科应用](https://appsource.microsoft.com/en-us/product/office/WA104099688?tab=Overview)：

![](https://www.kirupa.com/apps/images/wikipedia_window2.PNG)

这些基于 Web 的扩展程序（如维基百科）在 Word 等 Office 应用中的表现方式是通过——是的，WebView：

![](https://www.kirupa.com/apps/images/word_wikipedia_2.png)

WebView 中显示的实际内容来自[此URL](https://wikipedia.firstpartyapps.oaspapps.com/wikipedia/wikipedia_dev.html)。当你在浏览器中访问该页面时，你并没有真正看到很多内容。是原生应用功能和 Web 代码（通过 WebView 暴露）的功能之间的交集使体验工作完整。作为 Word 应用内维基百科扩展的用户，你可能永远不会有疑问幕后发生了什么，因为功能已经被很好地集成，**我们要的仅仅是它能正常工作**。

## WebView（通常）并不特别

WebView 非常棒。虽然看起来它们看起来像是完全特殊和独特的野兽，记住，它们只不过是一个在应用中设置好位置和大小的浏览器，而且不会放置任何花哨的 UI。其实还有更多东西，但这是它的精髓。在大多数情况下，除非你要调用原生 API，否则不必在 WebView 中专门测试 Web 应用。除此以外，你在 WebView 中看到的内容与你在浏览器中看到的内容相同，尤其是使用同一渲染引擎时：

1. 在 iOS 上，Web 渲染引擎**始终**是 WebKit，与 Safari 和 Chrome 相同。是的，你没看错。iOS 上的 Chrome 实际上使用了 WebKit。
2. 在 Android 上的渲染引擎**通常是** Blink，与 Chrome 相同。
3. 在 Windows，Linux 和 macOS 上，由于这些是更宽松的桌面平台，因此在选择 WebView 风格和渲染引擎时会有很大的灵活性。你看到的流行渲染引擎将是 Blink（Chrome）和 Trident（Internet Explorer），但是没有一个引擎可以依赖。这完全取决于应用以及它正在使用的 WebView 引擎。


我们可以花更多的时间来了解 WebView，并更深入地了解它们提供的一些特殊行为，但这会让我们偏离主题。对于我们在本篇文章要讲的东西，不偏离主题并宽泛了解WebView 才是正确的——至少到目前为止。

如果你对此主题或任何其他主题有疑问，最简单的方法是通过[我们的论坛](http://forum.kirupa.com)，这里有一群最友好的人等着你的到来，并且会乐于帮助你解决问题！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
