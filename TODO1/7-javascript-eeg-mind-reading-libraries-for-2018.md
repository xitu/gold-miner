> * 原文地址：[7 Javascript EEG Mind Reading Libraries for 2018](https://blog.bitsrc.io/7-javascript-eeg-mind-reading-libraries-for-2018-9a8e28544cd7)
> * 原文作者：[Gilad Shoham](https://blog.bitsrc.io/@giladshoham?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/7-javascript-eeg-mind-reading-libraries-for-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/7-javascript-eeg-mind-reading-libraries-for-2018.md)
> * 译者：
> * 校对者：

# 7 Javascript EEG Mind Reading Libraries for 2018

## Useful JS libraries for exploring human-brain signals and reading people’s minds.

![](https://cdn-images-1.medium.com/max/1600/1*TOFxZJnsy9DPK3a3ZES05w.jpeg)

“Cool headset right?”

Electroencephalography is a method of monitoring electrical activity in the human brain. It can be used to detect conditions like epilepsy or a brain tumor, to research cognitive aspects of the brain activity, or to learn how the brain reacts to external stimulation like music or images.

Although somewhat crude compared to other methods, it’s also useful for working the other way around- translating brain activity into actions using external devices (like a laser-equipped robot army).

MathLab, python and even R are often [popular languages](https://www.researchgate.net/post/What_is_the_best_open_source_software_to_analyse_EEG_signals2) for working with EEG signals as development in the field (led by projects such as [openBCI](http://openbci.com/)). Much like in [IOT](https://blog.bitsrc.io/10-javascript-iot-libraries-to-use-in-your-next-projects-bef5f9136f83), [ML](https://blog.bitsrc.io/11-javascript-machine-learning-libraries-to-use-in-your-app-c49772cca46c) and other research areas, Javascript [also kicks in](http://www.castillo.io/blog/2016/4/25/neurojavascript/getting-your-brainwaves-to-the-browser-with-javascript).

As part of working on [**Bit**](https://bitsrc.io)**,** we always try to find the frontier of JS applications. So, here are some Javascript libraries and experiments for working with EEG we found particularly cool. Your’e welcome to suggest more useful projects!

### 1. Muse-js

![](https://cdn-images-1.medium.com/max/1600/1*gN7_qSoxnCv7y2rW8WpO2g.gif)

An example taken from this great post: [https://medium.com/@urish/reactive-brain-waves-af07864bb7d4](https://medium.com/@urish/reactive-brain-waves-af07864bb7d4)

Muse-js is a JavaScript Library for the 2016 Muse EEG Headset (using web Bluetooth). Inspired by the [muse-lsl](https://github.com/alexandrebarachant/muse-lsl/blob/d2b74412585f3baa852516542a0d0853faec1b4e/muse/muse.py) python library, muse-js is built by [@UriShaked](https://twitter.com/UriShaked) with a humble vision in mind: communicating directly from your brain to your webpage. Why not?

Muse-js enables web developers to connect, analyze and visualize EEG data with tools like the web browser, RxJS and Angular. Apart from working with “ordinary” brain signals and communicating them to the web, muse-js also handles EEG signals related to eye-movement, which is not only super-cool but also very useful in cutting edge cognitive studies. Give it a go.

* [**urish/muse-js**: muse-js — Muse 2016 EEG Headset JavaScript Library (using Web Bluetooth)](https://github.com/urish/muse-js)

* [**Reactive Brain Waves**: How to use RxJS, Angular, and Web Bluetooth, along with an EEG Headset, to Do More With Your Brain](https://medium.com/@urish/reactive-brain-waves-af07864bb7d4)

### 2. Wits

![](https://cdn-images-1.medium.com/max/1600/1*AlCW5rzbus1jqJBDSiIkRw.gif)

Born as a part of Brain-Bits, wits is a Node.js library that reads EEG signals with [Emotiv](https://www.emotiv.com/) EPOC EEG headset. It’s implemented as a native C module for raw performance (based on [openyou/emokit-c](https://github.com/openyou/emokit-c.git)), handles a raw EEG data stream of 14 electrodes with 128Hz sample rate and provides a thoughtful API for end users. Here’s an example, and you’re welcome to give it a try.

```
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

### Learn More

* [**Monorepos Made Easier with Bit and NPM**: _How to leverage Bit + NPM to go monorepo without the overhead.](https://blog.bitsrc.io/monorepo-architecture-simplified-with-bit-and-npm-b1354be62870)

* [**Write GraphQL APIs on Node with MongoDB**: _How to write GraphQL APIs on Node.js with MongoDB.](https://blog.bitsrc.io/write-graphql-apis-on-node-with-mongodb-f3d0084cbbb8)

* [**11 Javascript Utility Libraries You Should Know In 2018**: _11 Useful Javascript utility libraries to speed your development.](https://blog.bitsrc.io/11-javascript-utility-libraries-you-should-know-in-2018-3646fb31ade)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
