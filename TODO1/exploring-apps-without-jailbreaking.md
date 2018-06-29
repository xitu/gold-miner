> * 原文地址：[Exploring Apps Without Jailbreaking](https://medium.com/@nathangitter/exploring-apps-without-jailbreaking-e932904f9863)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/exploring-apps-without-jailbreaking.md](https://github.com/xitu/gold-miner/blob/master/TODO1/exploring-apps-without-jailbreaking.md)
> * 译者：[melon8](https://github.com/melon8)
> * 校对者：[ALVINYEH](https://github.com/ALVINYEH)

# 不越狱探索 App 的技巧

## 学习如何构建其他应用的五种简单技巧

Medium 的 iOS应用是一个带伪导航条的原生应用，而 Product Hunt 则是用 React Native 构建的。

![](https://cdn-images-1.medium.com/max/800/1*OW-khVXV7oFfBpwdtOD_hw.png)

Medium iOS 应用（左）和 Product Hunt iOS 应用(右)。

我是怎么知道的呢？除了我自己编写代码或向开发人员询问以外，我可以用几个简单的测试来确定 —— 不需要越狱。

想知道我怎么做的？

### 背景

在网络的“早期”时代，很容易了解任何网站是如何建立的。通过在浏览器中查看源码，底层代码可以暴露给任何人看到、拿去混淆或者重用。随着网络的发展和框架的使用，网站变的越来越复杂，到现在，这几乎是不可能做到的。

![](https://cdn-images-1.medium.com/max/800/1*F1PatoKhttsUn6yowfwjDA.png)

使用 Chrome 检查 Medium 文章的 HTML。

App 有相同的问题，但更糟。app 会经过编译，这意味着原代码已经从人类可阅读的格式转换为计算机友好格式。

虽然有工具可以反编译 iOS 应用，但它们需要越狱设备，特殊工具和专业编程知识。我将分享一些不需要任何黑客技巧的策略 —— 只要应用安装在你的设备上就够了。

### 关键的理念

我们的策略很简单：将应用推向极限，期待着出状况。如果我们能看到它们出现的具体问题，就可以推断它们如何工作。

我们将尝试回答以下问题：

1. 该应用是原生的吗？如果不是，它是一个 web view？React Native？PhoneGap？Unity？某种 hybrid？
2. 使用了哪些 UI 元素？是开箱即用的组件还是一些自定义的东西？如何使用它们来达到预期的效果？

### 实验

为了收集数据，我们将做五个测试。我将解释每项测试如何执行，寻找的目标是什么以及从结果中可以得出什么结论。

我们将测试：

1. 按钮触摸状态 👆
2. 交互式导航栏手势 🔙
3. VoiceOver 🔊
4.动态类型🔎
5. 飞行模式 ✈️

![](https://cdn-images-1.medium.com/max/2000/1*Mji7eJHwKQKQBh82Tv2obw.jpeg)

### 实验 #1：按钮触摸状态 👆

一个按钮看起来很简单。你点击它，然后发生一些事情。但是，并非所有的按钮都是相同的。

我们将测试按钮交互的边缘情况 —— 用户不仅仅是点击一下按钮时的行为。

iOS 开发新人常常对 `UIButton`（iOS 上的默认按钮组件）的交互复杂性感到惊讶。在交互中的不同节点有九个事件会发生。

1. `touchDown`
2. `touchDownRepeat`
3. `touchDragInside`
4. `touchDragOutside`
5. `touchDragEnter`
6. `touchDragExit`
7. `touchUpInside`
8. `touchUpOutside`
9. `touchCancel`

（在[苹果开发者文档](https://developer.apple.com/documentation/uikit/uicontrolevents)中了解有关 `UIControlEvents` 的更多信息。）

几乎所有的按钮都会在 `touchUpInside` 上执行一个动作（当用户在控件边界内触摸并松手时）。用户触摸时，大多数按钮都会表现出特殊的状态。

真正的区别因素是按钮如何处理 `touchDragExit` 和 `touchDragEnter` 事件。当用户触摸按钮时，按钮如何响应，然后不抬起手指，拖动到按钮之外，然后再拖回来。

![](https://cdn-images-1.medium.com/max/800/1*o9vaFZNIOoJOyRbe9QvU6A.gif)

在 iOS 模拟器中测试标准按钮。

标准的 `UIButton` 有一些常见的行为：

1. 拖回按钮时的“触摸区域”大于按钮的边界。
2. 在 touchDragEnter 和 touchDragExit 的时候有一个动画。

但是，自定义的原生按钮通常会丢掉这些默认动画。

![](https://cdn-images-1.medium.com/max/800/1*7WEjgmPpcWb1RJU_7Vk3VQ.gif)

没有动画的自定义按钮。

#### 一个例子

我们来看看 Medium 应用。如果你在 Medium 的 iOS 应用中阅读此内容，你可以直接在上面试试！

让我们试一下右下角的这个看起来很花哨的按钮：

![](https://cdn-images-1.medium.com/max/800/1*LjDIPzIsPupqBavlayV06g.png)

如果你点击按钮，然后按住不动，将手指向外移动并返回，你会发现手形图标在其明暗状态之间切换。

（我的下一篇文章：“我如何通过增长黑客来得到 10 万用户” 😉）

#### React Native 按钮

React Native 按钮很容易认出来。它们通常有一个缓慢的淡入淡出动画，并且适用于**一切** React Native 按钮。

![](https://cdn-images-1.medium.com/max/800/1*TRzUveN7gJy-QCCo-p-pEA.gif)

Facebook 的 F8 应用中的按钮动画。这是 React Native 应用程序中的常见效果。

React Native 应用程序通常会大量使用滚动视图，这会使按钮的行为难以测试，因为拖动按钮也会滚动视图。

当谈到 React Native 的话题时，另一个泄露秘密的表现就是 cell 的点击状态。iOS 的原生 cell 点击后会出现一个纯色背景，而 React Native 的 cell 点击后与其按钮类似的高光效果。

![](https://cdn-images-1.medium.com/max/800/1*kDDB-EtlYgMR_yENeMmg4Q.gif)

左：React Native cell 行为。右：原生 cell 行为。

#### Web View 按钮

在我下载测试的 PhoneGap 应用程序中，约 95％ 的按钮完全没有触摸状态，其余的约 5％ 保留了触摸按钮的状态，但在拖出或返回时没有任何表现。

#### 按钮触摸状态的结论

请记住很重要的一点，这些按钮行为很容易被重写。表现出特定的行为并不意味着一个绝对的原因 —— 它只是某个方向的线索。

但是随着时间的推移，你会不自觉对按钮有一种“感觉”，但它是探索 app 如何构建的，做出有根据猜测的最简单方法之一。（这种技术也可以用来确定一个交互元素是一个按钮还是其他类型的控件。）

### 实验 #2：交互式导航手势

从 iOS 7 开始，用户可以通过滑动显示屏的左侧边缘来导航到前一个界面。这个手势特别有趣，因为它是交互式的，这意味着它可以搓来搓去。

在 iOS 上使用标准的 `UINavigationController` 时，这种行为是自带的。出于某种原因，许多应用程序弃用了标准导航栏，并最终导致了导航转换效果的丢失，损坏或[质量不高](https://medium.com/@nathangitter/designing-jank-free-apps-9f66d43b9c87)。

让我们在 Medium 中试一下。

![](https://cdn-images-1.medium.com/max/800/1*DXaY3wngOmbDnygRsGR_5w.gif)

比较 Medium（左侧）和 App Store（右侧）上的导航转换效果。

与标准导航转换不同，Medium app 将导航栏与屏幕的其余部分一起移动。而标准情况下，导航栏保持不变，上面的所有标签会淡入淡出。

另外，Medium app 的前一个界面上的黑色半透明叠加层较暗，看起来导航转换部分被重写了，或者更有可能是直接使用了自定义的组件。

我个人认为它看起来非常好，并且理解他们出于设计和开发的需要而采取了这种方法。

#### React Native 导航

从开发的角度来看，React Native 中的导航功能实现起来更加困难。因此，React Native 应用程序倾向于使用自定义导航转换，而不是使用`UINavigationController`的标准“push”和“pop”。

![](https://cdn-images-1.medium.com/max/800/1*xkAtEig66JoJISlBcl3YCw.gif)

Facebook 的 F8 应用程序中的自定义转换效果。

iOS 上的默认模态演示不是交互式的，并且在重新出现的界面上没有缩放效果。

以下是 React Native 中自定义转换的另一个示例。

![](https://cdn-images-1.medium.com/max/800/1*iOqkUpe_3TDIvt_JqSYo-A.gif)

Facebook 的 F8 应用中的导航转换效果。

没有阴影或黑色叠加，但真正泄露秘密的表现是动画时机。在这个 gif 中很难看到，但是在我抬手之后，动画完成比平常慢得多。

就像按钮触摸状态一样，通过测试许多导航转换，你可以在一段时间的后获得一种“感觉”。

#### 交互式导航手势的结论

这是我最喜欢的测试之一，因为它可以揭示更多关于 app 的信息，而不仅仅是导航栏的工作方式。如果手势把 app 搞出了 bug，则可能得到的信息不仅仅是导航转换的方式了。

但是，就像按钮触摸状态一样，导航转换可以被重写。然而实际上，由于导航转换需要大量的开发工作，所以导航转换不太可能被严格定制。

### 实验 #3：VoiceOver（旁白）🔊

你想要超能力？试试 VoiceOver。

VoiceOver 是 Apple 版本的屏幕阅读器。适用于视力障碍用户，这种辅助功能选项会大声朗读用户界面。

VoiceOver 有另一个我们更感兴趣的效果：它在当前选定的元素周围显示一个黑框。

![](https://cdn-images-1.medium.com/max/800/1*7B6BZBbp-amooMt5ZOMvpA.png)

在 App Store 和 Weather 应用程序中选择元素的声音。

这使我们能够将界面分解成各个部分。不需要猜测界面是如何构建的，我们可以让 VoiceOver 告诉我们！有时它甚至会大声朗读元素的类型（“按钮”，“日期选择器”等）。

如果您以前没有使用过 VoiceOver，那么它很值得去学习。基本概念：

1. 在屏幕上拖动以选择元素。
2. 双击屏幕上的任意位置以“点击”所选元素。
3. 左右滑动以在元素之间快速跳转。

让我们来研究一下在 Medium 中使用 VoiceOver 的效果。

![](https://cdn-images-1.medium.com/max/800/1*_wvOl8sGA-2RjevOJcBzpA.png)

使用 VoiceOver 在 Medium 中选择帖子的标题。

大多数元素的表现和预期一致。VoiceOver 只是读取选择的内容或元素的名称。但是，有一些不寻常的行为。

在主屏幕上，选择帖子的标题只能读取标题的一半。首先它说，“Color Contrast Crash C”，然后选择标题的底部读取“Course for Interface Design”。这说明 label 的布局肯定有一些自定义的部分，这使得 VoiceOver 认为标题被分成多个 label，每行一个 label。（我的猜测是他们为自定义行间距的 label 构建了一个变通方案，而通常的解决方案是使用 `attributedString` 属性，并且他们的方案可能会导致以后出现复杂问题。）

选择描述 label 后，我们可以看到 VoiceOver 揭示隐藏信息的威力。对于大多数用户来说，label 只是显示“估计有 2.85 亿...”。但是VoiceOver告诉我们更多的信息：“估计有 2.85 亿人视力受损。这个数字包括从法律上来看这些人的人数“。在这种情况下说明，所有数据都存储在标签中，但视觉上被截断了。

* YouTube 视频链接：https://youtu.be/7iiah_J_N0A

Medium 的 VoiceOver 演示。(确保你的声音不是静音)

如果幸运的话，你可以使用它来访问你无法访问的信息。

这是另一个有趣实验。在“书签”选项卡上，如果你没有书签，则有一个不可见的标签。它说：“要给文章加书签，在任一地方点击书签图标，文章会被添加到这个列表。”

![](https://cdn-images-1.medium.com/max/800/1*o-X2hCfV1rWjXIRWdWOa_g.png)

使用 VoiceOver 在 Medium 中选择不可见标签。

我猜是开发人员会快速暂时隐藏这个标签，并假定可能将来产品又会让它显示。（或者，也许我正在被 A/B 测试。）

#### 非原生应用程序

VoiceOver 也适用于基于网络视图的 app。如果你听到“链接”或“标题级别”等字眼时，表示你正在一个网络视图之中。

此外，文本元素可能会基于样式以各种奇怪的方式拆分（因为它的 HTML 表示），并且元素可能不会自然分组。

游戏（由 Unity，SpriteKit 等构建）通常根本没有任何 VoiceOver 支持。

#### VoiceOver 的结论

VoiceOver 提供的证据在这些测试中最可靠。它显示元素的可视范围，并可以读取不可见的属性。这是关于任何界面的宝贵资料。

随着你更多地使用 VoiceOver，你会学习到各种 UI 元素的默认表达方式，并开始注意到它的不同之处。

与上述任何测试一样，VoiceOver 不是 100％ 可靠的。所有的 VoiceOver 文本和边界框都可以由开发人员配置。针对 VoiceOver 优化过的应用程序也可能会揭露更少关于应用程序如何工作的信息，因为开发人员会修复可能导致 app 出问题的 bug。

（专业提示：将 VoiceOver 设置为你的“辅助功能快捷键”，便于在测试时打开和关闭。）

### 实验 #4：动态类型🔎

与 VoiceOver 类似，动态类型 是适用于视力障碍用户的辅助功能。它可以修改整个系统的文字大小。

我们想要使用动态类型来破坏布局。有了新的“辅助功能中的更大字体”后，这比以往更容易看出 app 端倪，这绝对是巨大字体。

![](https://cdn-images-1.medium.com/max/800/1*KmwvxTP9Q2KyLfTqwo54MQ.png)

调至最大字体的“更大文本”设置界面。

动态类型 可以在设置 > 辅助功能 > 更大字体中设置。这也可以作为一个 widget 添加到 iOS 11 中的控制中心，以便于访问。

不幸的是，Medium 不支持 动态类型，所以我们将使用 App Store 演示。

我将文字大小设置为最大值，并找到了一个错误的布局 —— 搜索界面上的一个广告。

![](https://cdn-images-1.medium.com/max/800/1*IsqwosbqCtJVJADUySBb3A.png)

最大字体（左侧）和默认字体（右侧）的 App Store 搜索界面。

文本“22K”布局的非常好，但它没有揭露太多布局的秘密，因为布局为更大字体做了调整（可以看到元素改位堆叠排列，而不是并排）。

我最喜欢的部分是淡蓝色的“广告”按钮。和正常字体大小时的漂亮的圆角矩形不同，我们得到了一个怪怪的拉伸的形状。

![](https://cdn-images-1.medium.com/max/800/1*Q-v6oAigHDVBWNfBgzgmXQ.png)

更大字体设置下的“广告”按钮。

我的猜测是，这个蓝色框被绘制成一个硬编码半径的自定义路径。通常，控件不会使用动态类型调整大小（请参阅“GET”按钮作为示例），所以这里有一些自定义内容。

####动态类型的结论

有些应用程序根本不支持 动态类型。即使支持，他们也可能不支持辅助设置中更大的字体。

但是当动态类型生效时，就可以对布局进行压力测试。使用 VoiceOver 已经可以了解一些信息，结合动态类型更有助于验证理论。通常支持动态类型的 app 也会测试这一部分，这会减少显示有用信息的机会。

### 实验 #5：飞行模式✈️

另一个简单的测试是启用飞行模式。飞行模式会禁用 Wi-Fi 和蜂窝移动网络，这会立即导致网络请求失败。通过在各种情况下禁用网络连接，我们可以看到 app 如何出问题。

在 Medium 中，如果你加载主页，打开飞行模式，并选择一篇文章，文章仍会加载。事实上，整个帖子仍然可读。

![](https://cdn-images-1.medium.com/max/800/1*uKDEsrYBp0PRfIVlq8aLoA.png)

飞行模式下的 Medium。文字内容加载，但图像不加载。

由此，我们推断 Medium 在加载预览时会拉取整个帖子的内容（并进行一些缓存）。

App Store 也会延迟加载图像。加载完一个页面并滚动到底部之后打开飞行模式会看到图像区域是空白的。

![](https://cdn-images-1.medium.com/max/800/1*ayzVeFPBdoN9UwaPIKdSsQ.png)

App Store 在飞行模式下。图像（即使在同一页面上）似乎是懒加载。

大多数现代应用程序重度依赖于网络连接，来下载内容然后允许交互，所以飞行模式会让大多数 app 出错。

#### React Native 和非原生应用

在我测试过的 React Native app 中，大多数应用程序通过删除屏幕上的所有内容，并显示一条自定义的“无连接”消息，对缺乏互联网连接的情况立即做出反应。

对于基于 webview 的 app，大多数没有反应。没有迹象表明当前正在加载或者加载失败。

#### 飞行模式的结论

不幸的是，飞行模式并没有给出如何构建应用程序的明确答案，因为大多数应用程序在没有可用连接时会有某种回退方式。

想继续深入？通过观察 app 的网络流量，你可以了解更多关于其他应用的信息。Charles Proxy（代理）的 iOS app 是洞悉各种 app 的好方法，但需要一些 HTTP 网络知识。

### 小贴士

尽管可能不能完全确定 app 的构建方式，但有一些方法可以让你进行有根据的猜测。通过研究边缘案例，我们可以更大程度上揭示它们的内部运作。

我们的学习也可以为我们自己的 app 的设计和开发提供信息。多了解一些方法有助于我们在未来做出更好的决策。

在一个不开源的应用程序的世界中，做些小改动的能力有限。（或重新发现）思考事物运转的方式的乐趣。

* * *

喜欢这个故事？在 Medium 上留言，并与 iOS 设计/开发者朋友分享。想要了解最新的移动应用设计/开发？在 Twitter上关注我：[twitter.com/nathangitter](https://twitter.com/nathangitter)

感谢 [David Okun](https://twitter.com/dokun24) 修改本文的草稿。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
