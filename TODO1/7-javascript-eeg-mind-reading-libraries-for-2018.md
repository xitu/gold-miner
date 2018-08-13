> * 原文地址：[7 Javascript EEG Mind Reading Libraries for 2018](https://blog.bitsrc.io/7-javascript-eeg-mind-reading-libraries-for-2018-9a8e28544cd7)
> * 原文作者：[Gilad Shoham](https://blog.bitsrc.io/@giladshoham?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/7-javascript-eeg-mind-reading-libraries-for-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/7-javascript-eeg-mind-reading-libraries-for-2018.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 2018 年七个通过脑电图分析实现“读心术”的 Javascript 库

## 用于探索人脑信号以实现读心的 JavaScript 库。

![](https://cdn-images-1.medium.com/max/1600/1*TOFxZJnsy9DPK3a3ZES05w.jpeg)

“这个头戴装置是不是很酷?”

脑电图是记录人脑中生物电活动的一种方法。它可以用来检测人体状态，比如癫痫或者脑瘤，以此来研究脑活动与认知方面的联系，或者用来学习人脑是如何对外部刺激产生反应，比如音乐或影像。

尽管相比其他方法，此方法还不够成熟，但是在一些方面它的用途还是很大的 - 可以将大脑活动转化成动作来控制外部设备（比如装备激光武器的机器人军队）。

在脑电图信号的开发领域（由类似 [openBCI](http://openbci.com/) 这样的项目所引领），MathLab、python 和 R 都是十分 [流行的语言](https://www.researchgate.net/post/What_is_the_best_open_source_software_to_analyse_EEG_signals2)。但是就像其他领域，比如 [IOT](https://blog.bitsrc.io/10-javascript-iot-libraries-to-use-in-your-next-projects-bef5f9136f83)、[ML](https://blog.bitsrc.io/11-javascript-machine-learning-libraries-to-use-in-your-app-c49772cca46c) 和其他一些研究领域那样，Javascript [也会参与其中](http://www.castillo.io/blog/2016/4/25/neurojavascript/getting-your-brainwaves-to-the-browser-with-javascript)。

作为在 [**Bit**](https://bitsrc.io) 工作的一部分,我们一直在寻找前端的 Javascript 应用。所以，在这里是我们找到的一些非常炫酷的处理脑电图的 Javascript 库和示例。欢迎你能够建议其他更多有用的项目！

### 1. Muse-js

![](https://cdn-images-1.medium.com/max/1600/1*gN7_qSoxnCv7y2rW8WpO2g.gif)

从这篇文章可以找到一个示例: [https://medium.com/@urish/reactive-brain-waves-af07864bb7d4](https://medium.com/@urish/reactive-brain-waves-af07864bb7d4)

Muse-js 是一个与 2016 Muse 脑电头盔相匹配的 Javasript 库（使用 web bluetooth）。灵感来自于 [muse-lsl](https://github.com/alexandrebarachant/muse-lsl/blob/d2b74412585f3baa852516542a0d0853faec1b4e/muse/muse.py) python 库, muse-js 由 [@UriShaked](https://twitter.com/UriShaked) 编译，它的目标是：通过人脑直接控制网页。为什么不可以呢？

Muse-js 让 web 开发者可以通过浏览器去进行连接、分析并把脑电图数据进行可视化。除了处理“普通”的脑电信号并把它们传送到网页上，muse-js还可以根据眼睛移动来操作脑电信号, 这不仅仅超级炫酷，而且对于人类认知的前沿研究也非常有帮助。尝试一下。

* [**urish/muse-js**: muse-js — Muse 2016 EEG Headset JavaScript Library (using Web Bluetooth)](https://github.com/urish/muse-js)

* [**Reactive Brain Waves**: How to use RxJS, Angular, and Web Bluetooth, along with an EEG Headset, to Do More With Your Brain](https://medium.com/@urish/reactive-brain-waves-af07864bb7d4)

### 2. Wits

![](https://cdn-images-1.medium.com/max/1600/1*AlCW5rzbus1jqJBDSiIkRw.gif)

作为 Brain-Bits 项目的一部分, wits 是一个 Node.js 库，它读取来自 [Emotiv](https://www.emotiv.com/) EPOC 脑电头戴装置的脑电图信号。它是由原生 C 模块实现（基于 [openyou/emokit-c](https://github.com/openyou/emokit-c.git)），以 128Hz 采样率的速度处理 14 路电极原始的脑电图数据流，并且给终端用户提供了丰富的接口。这里是一个例子，欢迎你来试用一下。

```Javascript
const mind = require('wits')
mind.open()
mind.read(console.log)
```

* [**dashersw/wits**: _wits — A Node.js library that reads your mind with Emotiv EPOC EEG headset](https://github.com/dashersw/wits)

### 3. Brain-monitor

![](https://cdn-images-1.medium.com/max/1600/1*hDVSjp4vSjrmqt0wwvKU1Q.gif)

Brain-monitor is in fact a terminal app written in Javascript that displays human-brain EEG signals in real time. It works with Emotiv EPOC EEG headset, analyzing a Raw EEG data stream of 14 electrodes with 128Hz sample rate and processes additional information such as head-orientation and even battery level for your headset. A cool choice for CLI lovers.

* [**dashersw/brain-monitor**: _brain-monitor — A terminal app written in Node.js to monitor brain signals in real-time](https://github.com/dashersw/brain-monitor)

### 4. Brain-bits

![](https://cdn-images-1.medium.com/max/1600/1*6pYMJ2_4fV8iMP2_sPwTAg.gif)

Created by the author of wits and brain-monitor, brain-bits is an P300 online spelling mechanism for Emotiv headsets. The project is basically an [Electron](https://electronjs.org)app which runs Node on the backend and Vue.js on the front-end, making use of native modules for Node.js and [brain.js](https://github.com/BrainJS/brain.js) for the neural network and [d3](https://d3js.org) for drawing the EEG electrode monitor. You can see a live demo and learn more from the author [in this talk](https://www.youtube.com/watch?v=_4nrh6mTt4E) given at the 2018 Amsterdam JS conference.

* [**dashersw/brain-bits**: _brain-bits — A P300 online spelling mechanism for Emotiv headsets. It’s completely written in Node.js, and the GUI is…](https://github.com/dashersw/brain-bits)

### 5. EEG-101

![](https://cdn-images-1.medium.com/max/1600/1*iPMqXQS3FK1lOa3sD6oolw.png)

EEG-101 is an interactive neuroscience [tutorial app](https://play.google.com/store/apps/details?id=com.eeg_project&hl=en) using Muse and React Native to teach EEG and BCI basics. It teaches the basics of EEG, including where signals come from, how devices work, and how to process data. Built with React Native for Android, the project contains a general purpose binary classifier for EEG data, it streams data from the Muse headset with the LibMuse Java API. A nice way to pick-up and play EEG works.

* [**NeuroTechX/eeg-101**: _eeg-101 — Interactive neuroscience tutorial app using Muse and React Native to teach EEG and BCI basics.](https://github.com/NeuroTechX/eeg-101)

### 6. EEG pipes

![](https://cdn-images-1.medium.com/max/1600/1*1SPDOMNKy-3ntUgiDnpeDA.png)

This project provides pipeable RxJS operators for working with EEG data in Node and the Browser, with features such as FFT, PSD and Power Bands, Buffering and Epoching, IIR Filters and more. Note that an Observable of EEG data is required, which can be done using `fromEvent` from RxJS in order to push callback events into an Observable stream. Enjoy.

* [**neurosity/eeg-pipes**: _eeg-pipes — Pipeable RxJS operators for working with EEG data in Node and the Browser](https://github.com/neurosity/eeg-pipes)

### 7. Open BCI & JS

Open BCI is a project built to provide open-source brain-computer interfaces and low-cost hardware. Created by a group of engineers, researches and makers who “share an unfaltering passion for harnessing the electrical signals of the human brain and body to further understand and expand who we are”.

As such, it’s creating a base for a wide verity of implementations for working with all kinds of EEG-related hardware and software. Some of which, are awesome Javascript implementations for EEG proccessing, visualizing and more working with anything from Node.js to Angular 4. Here are some.

* [**pwstegman/WebBCI**: _WebBCI — :bar_chart: JavaScript based EEG signal processing]((https://github.com/pwstegman/WebBCI)

* [**NeuroJS/openbci-dashboard**: _openbci-dashboard — A fullstack javascript app for capturing and visualizing OpenBCI EEG data](https://github.com/NeuroJS/openbci-dashboard)

* [**neurosity/openbci-observable**: _openbci-observable — Making OpenBCI for Node Reactive_github.com](https://github.com/neurosity/openbci-observable)

* [**alexcastillo/angular-openbci-rx**: _angular-openbci-rx — EEG Time Series Data Visualization in Angular 4](https://github.com/alexcastillo/angular-openbci-rx)

* * *

### Also check out:

* [**karan/brain2music**: _brain2music — :musical_note: EEG brainwave data to music (more like noise) in realtime.](https://github.com/karan/brain2music)

* [**NeuroJS/topogrid**: _topogrid — javascript library for interpolation of topographic EEG plots](https://github.com/NeuroJS/topogrid)

* * *

### Meet Bit

[**Bit**](https://bitsrc.io) helps your team build applications faster by turning components and modules into building blocks which can be easily shared, developed and used anywhere to build new projects. Try Bit with Javascript, React and more.

* [**Bit — Share and build with code components**: _Bit helps you share, discover and use code components between projects and applications to build new features and…]https://bitsrc.io/)

* * *

### 更多了解

* [**Monorepos Made Easier with Bit and NPM**: _How to leverage Bit + NPM to go monorepo without the overhead.](https://blog.bitsrc.io/monorepo-architecture-simplified-with-bit-and-npm-b1354be62870)

* [**Write GraphQL APIs on Node with MongoDB**: _How to write GraphQL APIs on Node.js with MongoDB.](https://blog.bitsrc.io/write-graphql-apis-on-node-with-mongodb-f3d0084cbbb8)

* [**11 Javascript Utility Libraries You Should Know In 2018**: _11 Useful Javascript utility libraries to speed your development.](https://blog.bitsrc.io/11-javascript-utility-libraries-you-should-know-in-2018-3646fb31ade)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
