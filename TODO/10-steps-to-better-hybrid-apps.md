>* 原文链接 : [10 steps to better hybrid apps](https://medium.com/net-magazine/10-steps-to-better-hybrid-apps-e8e33831ea5e#.4fh1wbsy9)
* 原文作者 : [Oliver Lindberg](https://medium.com/@oliverlindberg)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Yves X](https://github.com/Yves-X)
* 校对者: [Malcolm](https://github.com/malcolmyu), [circlelove](https://github.com/circlelove)

# 10 步带你做一个棒棒的 Hybrid 应用

**随着 Hybrid 应用人气渐涨，人们创造了越来越多的工具帮助开发者高效创建跨平台应用。** [**James Miller**](https://twitter.com/jimhunty) **介绍了 10 条建议以助你得到最佳成果。** 

![](https://cdn-images-1.medium.com/max/1200/1*AaxKJp4gFBPiMv8mYqJvjA.jpeg)

<figcaption>插图来自 [Luke O’Neill](http://lukeoneill.co.uk)</figcaption>

为手机和平板开发应用程序并非移动开发者的专利。如今 Web 开发者可以通过原生应用封装工具，使用 HTML、CSS 与 JavaScript 来构建自己的应用，而无需了解任何设备特定代码。这种方式使用设备的 Web 视图，像浏览器一般去展示 Hybrid 应用中基于 Web 的代码。在这 10 条建议的帮助下，你将把自己的 Hybrid 应用打造得尽善尽美。

#### **1\. 规划**

在开始开发前规划你的应用能避开许多坑，带来更成功的结果。开发过程中的很多情况，应该在规划阶段中考虑清楚。

Hybrid 应用使用的 Web 视图实际上是按比例缩小的浏览器，你需要预见到，那些存在于传统浏览器的问题，在这里也同样存在。理解你的目标受众及其期望，有助于明确你的应用的技术短板。这可以与设备分析一道，帮助你发掘潜在性能，并达到更高的性能指标。

一旦你知道你的目标受众想要什么，你需要考虑发行渠道。Google Play 和 Apple 的 App Store 是最大的两个生态系统。为了在这些商店上架你的应用，你必须确定你的应用遵循它们的准则。

Google Play 对应用审查提供了更多回溯渠道，发行也相对容易。然而举报能使你的应用遭到移除。遵循这份[准则](https://play.google.com/about/developer-content-policy.html?rd=1)会让你的应用更有望列入精选。

Apple 有更严格的[准则](https://developer.apple.com/app-store/review/guidelines/)，堪称一项挑战。你需要整合手机的原生功能，而非构建一个 Web 应用了事。需要整合的功能包含相机、定位和其它一些功能，在适当的框架下它们能通过 JavaScript 插件调用。不要仅仅为了迎合商店准则去添加功能，要确认它们真的是用户想要的。

![](https://cdn-images-1.medium.com/max/800/1*KpdzFI7j0VnryX4qGKWIkQ.jpeg)

<figcaption>**避免违规** 使用 Google Play 的内容审查工具把那些可能违规的国家从你的发行列表中移除。</figcaption>

#### 2\. 市场考虑

应用程序是一种全球性产品，但不像 Web 一般开放，它们主要可用于特定国家的应用商城。每个国家有其不同的文化和法律。不要假设你的应用全球通吃，这很重要——在一个不合适的国家上架，对你的品牌弊大于利。

同样重要的是注意欲发行国家的网络局限性。并非处处都有快如闪电的移动互联网接入或 Wi-Fi 热点。即使你的应用不是面向新兴市场，网络连接依然是个问题。使应用的网络请求轻量一些，并试着保持最少吧。

#### 3\. 可扩展性

无论是登录还是更新数据，大多数应用程序需要一个网络组件。这需要一些形式的服务器与 API。当你的应用俘获了更多用户，这份压力会加诸你的后端，像是超时和错误等会愈演愈烈。为了避免这个问题，计划好你的后端将如何升级很重要。你的 API 应该遵循 REST 风格的接口模式来建立一个工作标准。还要考虑加以验证，因为一个开放的 API 可能会遭到滥用。终端也必须正确管理，因为一旦应用发布，鉴于审查流程，可能需要数周才能让更新版本得以运行。

也许有朝一日你的 API 会收到过多请求然后挂掉。别急着投资于更多服务器，现有大量的后端即服务（BaaS）可选择，包括 [Parse](http://parse.com) 和 [Firebase](http://firebase.com) 在内，它们可以助你搞定这个问题。它们储存你的数据，并常提供基于你的数据结构和认证方式的标准 API。 还有许多基于用量的免费套餐。在全球覆盖、优良技术和强力网络的支持下，你知道自己应用的网络部件将有良好性能。

![](https://cdn-images-1.medium.com/max/800/1*RslHAZKu3bZscXv6ERaHZQ.jpeg)

<figcaption>**Parse** Facebook 的 BaaS 解决方案，使你不再需要投资于私有服务器</figcaption>

#### 4\. 性能

在用 Web 视图呈现的 Hybrid 应用中，老掉牙的多浏览器和多操作系统支持程度不同的问题又会出现。这在 Web 上用渐进增强解决，同样的策略亦可用于 Hybrid 以提供平滑的跨平台体验。

拥有太多后台进程会逐渐榨干电量、拖低性能。考虑使用像 AngularJS 或者 Ember.js 这样的框架将你的应用构建为单页应用吧。这会使你结构化你的代码，使你的应用更易维护。这个通行做法将保证更好的性能，并减少内存泄漏的可能。像是 Ionic 这样包含了 Cordova、AngularJS 以及自有 UI 组件的框架，用于构建快速原型和最终产品都不赖。

在移动设备上，CSS 动画的性能比 JavaScript 更好。试着以每秒 60 帧为目标，给应用原生感，并且在可以使动画更带感的地方使用硬件加速。

![](https://cdn-images-1.medium.com/max/800/1*dKzEwQWP3ArLAUfSJh5ZWg.jpeg)

<figcaption>**便捷框架** Ionic 框架提供了结构化的方法来构建你的 Hybrid 应用</figcaption>

#### 5\. 交互设计

近乎所有移动设备都主要靠触控操作。基于这种认识，尽量跳出 Web 的局限来思考，使用基于手势的简单交互，让你的应用体验尽量直观。触屏设备没有 hover 状态，所以要考虑换用 active 和 visited 状态之类的视觉提示。

> 跳出 Web 的局限来思考，使用基于手势的简单交互，让你的应用体验尽量直观

在触屏设备上，用户触摸屏幕到事件被触发之间有 300 毫秒的延迟。这是由于 Web 视图等着确认是单击还是双击。尽管乍一听并不长，但这延迟是可察觉的。为了克服它，在你的项目中添加 [FastClick](http://github.com/ftlabs/fastclick) 脚本库并在 body 对它实例化。

#### 6\. 响应式设计

如今设备的屏幕尺寸千差万别，涵盖了广泛的分辨率。所幸响应式设计原则仍然适用于 Hybrid 应用与平板电脑。在你选定的设备范围内，专注于最小的屏幕尺寸，然后选择你想要拉伸覆盖的断点。横向和纵向试图都要考虑。它们都可以在构建应用时锁定，这有助于减小复杂度和引导用户行为。

想一想你要如何使用应用设计规范：弹出菜单，固定头部以及列表设计。有限的屏幕尺寸适合于使用图标而不是文本来叙述，但是恰当的标签仍有助于提升可访问性。尽管用户们期待特定元素，不要让此局限你的设计。

#### 7\. 图片

高清屏幕是移动设备厂商的优先选择。但别忘记，许多用户仍然使用屏幕分辨率较低的旧设备。针对你目标市场的设备选用适当的图片，并且确保每一张图片看上去都尽可能好。当图片经常复用时，在设备上储存它们。文件体积可以比你通常在移动网站上使用的更大，但也必须考虑到设备内存大小。对 Retina 屏幕酌情使用 SVG 来最大化视觉输出，但要留心设备支持情况。

#### 8\. 网络

采取离线优先的做法。用移动设备，用户总会有没有网络连接的时候，不应该以用户体验受损收场。通过在本地缓存网络请求来搞定它，从而优化信号不好甚至没有信号的时候的体验。

> 采取离线优先的做法。通过在本地缓存网络请求来优化信号不好甚至没有信号的时候的体验。

本地保存脚本。Web 开发中，外链脚本会提升性能，因为它们更可能被缓存。这在应用程序中就行不通了——就算没有网络，应用也要工作。脚本往往并不会拖累文件体积和连接速度，却带来更快的加载速度以及原生感。如果你的用户路径的预设性很强，不妨试试提前预加载数据，带来无缝衔接的体验。

#### 9\. 插件

正如之前所述，通过使用相机、定位或是社交分享添加原生功能来扩展你基于 Web 的应用，能够显著提升用户体验。通常你无法通过移动 Web 浏览器来调用原生功能，但这可以在 Hybrid 应用中使用插件实现。

Cordova 是一款 Hybrid 应用封装工具，它有大量可用 JavaScript 调用的相关插件。详见 [Plugreg](http://plugreg.com)，它们的目录。

要对第三方插件保持警惕。移动操作系统迅速发展，缺乏支持的第三方插件可能导致问题、减少电池寿命，还可能让你的应用不稳定。去找那些在 Github 上好评如潮并且开发活跃的项目。

#### 10\. 测试

Hybrid 应用的核心以 Web 技术构建。这意味着非设备的功能可在浏览器里得到测试。使用像 gulp 或 Grunt 这样的任务运行器启动 LiveReload 之类的工具，创建一个有效的并行开发和测试流程。

接下来的一步是模拟。Google Chrome 提供了[移动模拟器](https://developer.chrome.com/devtools/docs/device-mode)，所以你可以在最流行的设备间测试各种屏幕分辨率，这对设计断点很有帮助。Apple 提供了 [iOS 模拟器](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/iOS_Simulator_Guide/Introduction/Introduction.html)作为 Xcode 的一部分，而 Google 提供了 [Android 模拟器](http://developer.android.com/tools/help/emulator.html)作为它的开发者工具的一部分。

这向你提供了在模拟设备上测试你的应用的机会，这比在物理设备上搭建更快，并且意味着你可以测试原生设备的功能。然而模拟器性能取决于你的机器，Android 模拟器更是特别慢。这也导致 [Genymotion](http://genymotion.com) 创造了一个竞品，它模拟 Android 快得多。

你不该上架一款从未在至少一部真机上完全测试过的应用。真机环境与模拟器一样有用，它能够突显性能问题和关于用户交互的痛点。

#### 结论

这 10 条建议为你将构想转化为全功能的移动应用提供了一个良好的开端。然而，在 Web 开发的方方面面，Hybrid 应用的发展步伐如此迅速。随着社区成长，新工具和新技术几乎每天都在涌现。

如果你真的决定在 Hybrid 应用的世界里深耕细作，社区将是你最宝贵的资源之一。前来参加会议和聚会很有价值，这能让你与最新进展齐头并进，并分享自己的创造。我们期待着一览你的高见！

#### 流行的 Hybrid 应用框架

[CORDOVA](http://cordova.apache.org)   
原始且最受欢迎的开源 Hybrid 框架。JS APIs 可调用手机原生功能。它有助力开发跨平台应用的 CLI。

[PHONEGAP](http://phonegap.com)   
PhoneGap 是在 Cordova 基础上构建的 Adobe 产品。这俩基本是一样的，但 PhoneGap 提供了额外的服务，包括云上的应用构建和跨渠道经销。

[IONIC](http://ionicframework.com)   
Ionic 为商业逻辑和设计准则给 Cordova 添加了 AngularJS 和自有 UI 框架。它基于 Cordova 的 CLI，并向之添加了 LiveReload 这样的服务来部署设备。[Ionic Creator](http://creator.ionic.io) 允许使用它的 Web 接口创建应用。

[APPCELERATOR](http://appcelerator.com)   
它提供了一个用以构建原生和 Web 应用的统一平台，辅以自动化测试工具、实时分析和 BaaS。它旨在提供你部署和延伸应用所需的一切，且这些服务在你应用上架以前都是免费的。

[COCOONJS](http://ludei.com/cocoonjs)   
提供了一个应用封装工具，它有内置以及改装的 Canvas 和 WebGL 引擎。这使得它成为用 Web 技术写 iOS 和 Android 游戏的理想环境。
