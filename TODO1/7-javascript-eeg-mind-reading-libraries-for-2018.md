> * 原文地址：[7 Javascript EEG Mind Reading Libraries for 2018](https://blog.bitsrc.io/7-javascript-eeg-mind-reading-libraries-for-2018-9a8e28544cd7)
> * 原文作者：[Gilad Shoham](https://blog.bitsrc.io/@giladshoham?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/7-javascript-eeg-mind-reading-libraries-for-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/7-javascript-eeg-mind-reading-libraries-for-2018.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：[Park-ma](https://github.com/Park-ma)、[huangyuanzhen](https://github.com/huangyuanzhen)

# 2018 年七个通过脑电图分析实现“读心术”的 Javascript 库

## 用于探索人脑信号以实现读心的 JavaScript 库。

![](https://cdn-images-1.medium.com/max/1600/1*TOFxZJnsy9DPK3a3ZES05w.jpeg)

“这个头戴装置是不是很酷？”

脑电图是一种检测人脑中生物电活动的方法。它可以用来检测人体状态，比如癫痫或者脑瘤，以此来研究脑活动与认知方面的联系，或者用来学习人脑是如何对外部刺激产生反应，比如音乐或影像。

尽管相比其他方法，此方法还不够成熟，但是在一些方面它的用途还是很大的 — 可以通过外部设备将大脑活动转化成行为（比如装备激光武器的机器人军队）。

在脑电图信号的开发领域（由类似 [openBCI](http://openbci.com/) 这样的项目所引领），MathLab、python 和 R 都是十分 [流行的语言](https://www.researchgate.net/post/What_is_the_best_open_source_software_to_analyse_EEG_signals2)。但是就像其他领域，比如 [IOT](https://blog.bitsrc.io/10-javascript-iot-libraries-to-use-in-your-next-projects-bef5f9136f83)、[ML](https://blog.bitsrc.io/11-javascript-machine-learning-libraries-to-use-in-your-app-c49772cca46c) 和其他一些研究领域那样，Javascript [也会参与其中](http://www.castillo.io/blog/2016/4/25/neurojavascript/getting-your-brainwaves-to-the-browser-with-javascript)。

作为在 [**Bit**](https://bitsrc.io) 工作的一部分,我们一直在努力追寻 Javascript 前沿应用。所以，在这里是我们找到的一些非常炫酷的处理脑电图的 Javascript 库和示例。欢迎你能够提供其他更多有用的项目！

### 1. Muse-js

![](https://cdn-images-1.medium.com/max/1600/1*gN7_qSoxnCv7y2rW8WpO2g.gif)

从这篇文章可以找到一个示例：[https://medium.com/@urish/reactive-brain-waves-af07864bb7d4](https://medium.com/@urish/reactive-brain-waves-af07864bb7d4)

Muse-js 是一个与 2016 Muse 脑电头盔相匹配的 Javasript 库（使用 web bluetooth）。灵感来自于 [muse-lsl](https://github.com/alexandrebarachant/muse-lsl/blob/d2b74412585f3baa852516542a0d0853faec1b4e/muse/muse.py) python 库, muse-js 由 [@UriShaked](https://twitter.com/UriShaked) 编译，它的目标是：通过人脑直接控制网页。为什么不可以呢？

Muse - js 可以让 web 开发者通过浏览器、RxJs 和 Angular 这样的工具去连接、分析或可视化脑电图数据。除了处理“普通”的脑电信号并把它们传送到网页上，muse-js 还可以处理与眼睛移动相关的脑电信号, 这不仅仅超级炫酷，而且对于人类认知的前沿研究也非常有帮助。尝试一下。

* [**urish/muse-js**: muse-js — Muse 2016 脑电头盔 Javascript 库（使用 Web Bluetooth）](https://github.com/urish/muse-js)

* [**Reactive Brain Waves**: 如何使用 RxJS、Angular 和 Web Bluetooth，配合脑电头盔，发掘你的大脑](https://medium.com/@urish/reactive-brain-waves-af07864bb7d4)

### 2. Wits

![](https://cdn-images-1.medium.com/max/1600/1*AlCW5rzbus1jqJBDSiIkRw.gif)

wits 是 Brain-Bits 项目的一部分, 它是一个 Node.js 库，可以读取来自 [Emotiv](https://www.emotiv.com/) EPOC 脑电头盔的脑电图信号。它由原生 C 模块实现（基于 [openyou/emokit-c](https://github.com/openyou/emokit-c.git)），以 128Hz 采样率的速度处理 14 路电极原始的脑电图数据流，并且给终端用户提供了丰富的接口。这里有个例子，欢迎试用一下。

```Javascript
const mind = require('wits')
mind.open()
mind.read(console.log)
```

* [**dashersw/wits**：wits — 一个使用 Emotiv EPOC 脑电头盔来读心的 Node.js 库](https://github.com/dashersw/wits)

### 3. Brain-monitor

![](https://cdn-images-1.medium.com/max/1600/1*hDVSjp4vSjrmqt0wwvKU1Q.gif)

Brain-monitor 实际上是一个用 Javascript 编写的可以实时显示脑电图信号的终端应用。它配合 Emotiv EPOC 脑电头盔一起工作，以 128Hz 的采样频率对 14 个电极的原生脑电信号进行分析，并能处理一些额外的信息，比如头的方向，甚至是头盔的电量。对于喜欢使用命令行的开发者，这是个不错的选择。

* [**dashersw/brain-monitor**: _brain-monitor — 一个用 Node.js 编写的实时显示脑电信号的终端应用](https://github.com/dashersw/brain-monitor)

### 4. Brain-bits

![](https://cdn-images-1.medium.com/max/1600/1*6pYMJ2_4fV8iMP2_sPwTAg.gif)

由 wits 和 brain-monitor 的开发者创建，Brain-bits 是为 Emotiv 脑电头盔所做的一套 P300 在线拼写系统。这个项目基于 [Electron](https://electronjs.org) 应用，后端运行 Node，而前端使用 Vue.js，利用 Node.js 的原生模块以及 [brain.js](https://github.com/BrainJS/brain.js) 来处理神经网络，并使用 [d3](https://d3js.org) 来绘制脑电图。你可以在开发者在 2018 Amsterdam JS 论坛上的 [这次演讲](https://www.youtube.com/watch?v=_4nrh6mTt4E) 里面看到一个现场演示，并能了解更多内容。

* [**dashersw/brain-bits**: _brain-bits — 一套为 Emotiv 脑电头盔使用的 P300 在线拼写系统。使用 Node.js 编写，GUI 是……](https://github.com/dashersw/brain-bits)

### 5. EEG-101

![](https://cdn-images-1.medium.com/max/1600/1*iPMqXQS3FK1lOa3sD6oolw.png)

EEG-101 是一个使用 Muse 和 React Native 来教授脑电图和 BCI 基础知识的交互式神经学的 [教程应用](https://play.google.com/store/apps/details?id=com.eeg_project&hl=en)。内容包括信号从哪里来，设备如何工作以及如何处理数据。使用 React Native 开发了 Android 应用，项目包含了一个用于脑电图数据的通用二进制分类器，它使用 LibMuse Java API 获取来自 Muse 头盔的数据流。这是一种很好的采集和播放脑电信号的方式。

* [**NeuroTechX/eeg-101**: _eeg-101 — 使用 Muse 和 Reac Native 来教授脑电图和 BCI 基础知识的交互式神经学教程应用。](https://github.com/NeuroTechX/eeg-101)

### 6. EEG pipes

![](https://cdn-images-1.medium.com/max/1600/1*1SPDOMNKy-3ntUgiDnpeDA.png)

这个项目提供在 Node 和浏览器环境中处理脑电图数据的可管道化的 RxJS 操作符，包括的功能比如 FFT、功率谱密度（PSD）和功率带宽、缓冲和 Epoching、IIR 滤波器等。注意需要一个关于脑电图的 Observable，可以使用 RxJS 的 `fromEvent` 将回调事件压入 Observable 流中。试用一下。

* [**neurosity/eeg-pipes**: _eeg-pipes — 在 Node 和浏览器中处理脑电图数据的可管道化 RxJS 操作符](https://github.com/neurosity/eeg-pipes)

### 7. Open BCI & JS

Open BCI 是一个提供脑机接口和低成本硬件的开源项目。由工程师、研究人员和制造商组成的开发小组创建，他们希望“分享对利用脑电信号来更深入地理解并扩展我们是谁的坚定热情”。

基于此，它为各种各样脑电相关软硬件实现构筑了一个基础。其中有一些非常棒的 Javascript 实现，使用从 Node.js 到 Angular 进行脑电图处理、可视化和一系列工作。这是一些例子。

* [**pwstegman/WebBCI**: _WebBCI — :bar_chart: 基于 JavaScript 的脑电信号处理]((https://github.com/pwstegman/WebBCI)

* [**NeuroJS/openbci-dashboard**: _openbci-dashboard — 一个获取并可视化 OpenBCI 脑电数据的全栈 Javascript 应用](https://github.com/NeuroJS/openbci-dashboard)

* [**neurosity/openbci-observable**: _openbci-observable — Making OpenBCI for Node Reactive_github.com](https://github.com/neurosity/openbci-observable)

* [**alexcastillo/angular-openbci-rx**: _angular-openbci-rx — 使用 Angular 4 实现脑电时序数据可视化](https://github.com/alexcastillo/angular-openbci-rx)

* * *

### 还可以看看：

* [**karan/brain2music**: _brain2music — :音符: 脑电波数据实时音乐转换（更像是噪音）](https://github.com/karan/brain2music)

* [**NeuroJS/topogrid**: _topogrid — javascript library for interpolation of topographic EEG plots](https://github.com/NeuroJS/topogrid)

* * *

### 遇见 Bit

[**Bit**](https://bitsrc.io) 可以帮助你的团队通过导入组件和模块到编译模块中来快速搭建应用，这些非常容易分享、开发并在任意地方去构建新的工程项目。用 Javascript、React 或者其他方式试用下 Bit。

* [**Bit — 共享和创建代价组件**: Bit 可以帮助你在项目和应用之间共享、发现并使用代码组件来创建新功能特性和其他……](https://bitsrc.io/)

* * *

### 更多了解

* [**Monorepos Made Easier with Bit and NPM**：如何利用 Bit 和 NPM 更简单地创建 Monorepos。](https://blog.bitsrc.io/monorepo-architecture-simplified-with-bit-and-npm-b1354be62870)

* [**Write GraphQL APIs on Node with MongoDB**：如何使用 Node.js 和 MongoDB 来编写 GraphQL APIs。](https://blog.bitsrc.io/write-graphql-apis-on-node-with-mongodb-f3d0084cbbb8)

* [**11 Javascript Utility Libraries You Should Know In 2018**：能够加快开发的 11 个有用的 Javascript 工具包。](https://blog.bitsrc.io/11-javascript-utility-libraries-you-should-know-in-2018-3646fb31ade)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
