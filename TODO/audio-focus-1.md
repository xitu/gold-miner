> * 原文地址：[Understanding Audio Focus (Part 1 / 3): Common Audio Focus use cases](https://medium.com/google-developers/audio-focus-1-6b32689e4380)
> * 原文作者：[Nazmul Idris (Naz)](https://medium.com/@nazmul?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-1.md)
> * 译者：[oaosj](https://github.com/oaosj)

# 理解音频焦点 (第1/3部分)：常见的音频焦点用例

![](https://cdn-images-1.medium.com/max/2000/1*2_mUAwAihjBYMszQCCL0Mw.png)


Android手机支持多个应用同时播放音频。操作系统会把多个音频流混合在一起播放，但是多个应用同时播放音频，给用户带来的体验往往不佳。为了提供更友好的用户体验，Android提供了一个[API](https://developer.android.com/guide/topics/media-apps/audio-focus.html)，让应用程序可以共享**音频焦点**，旨在保证同一时段内只有一个应用可以维持音频聚焦。

本系列文章旨在让您深入理解音频焦点的含义，使用方法和其对用户体验的重要性。本篇文章是该系列的第一部分，该系列三篇文章包含了：

1.  最常见的音频焦点用例和成为一个优秀的媒体使用者的重要性（**此篇文章**）
2.  [其它一些能体现音频焦点对应用体验的重要性的用例](https://medium.com/@nazmul/audio-focus-2-42244043863a)
3.  [在您的应用中实现音频焦点的三个步骤](https://medium.com/@nazmul/audio-focus-3-cdc09da9c122)

音频焦点的良好协作性，主要依赖于应用程序是否遵循音频焦点指南，操作系统没有强制执行音频焦点的规范来约束应用程序，如果应用选择在失去音频焦点后继续大声播放音频，会带来不良的用户体验，可能直接导致用户卸载应用，但这是无法阻止的行为，只能靠开发者自我约束。

下面是一些音频焦点使用场景（假设用户正在使用您的应用播放音频）。

当您的应用需要播放声音的时候，应该先请求音频聚焦，在获得音频焦点后再播放声音。

### 用例一 ： 用户在使用您的应用播放音频1时，打开另一个应用并尝试播放该应用相关的音频2

#### 您的应用不处理音频焦点的情况下：

您的音频1和另一个应用的音频2会重叠播放，用户无法正常听到来自任何应用的音频，这样的用户体验很不友好。

![](https://cdn-images-1.medium.com/max/800/1*zaIB6fKmwSwhm_UM3Yox_A.png)

#### **您的应用处理了音频焦点的情况下：**

在另一个应用需要播放音频时，它会请求音频焦点常驻，即音频永久聚焦。一旦系统授权，它便会开始播放音频，这时候您的应用需要响应音频焦点的丢失通知，停止播放。这样用户就只会听到另一个应用的音频。

![](https://cdn-images-1.medium.com/max/800/1*xk8Tio4_XxtmuoH9CK7qkQ.png)

同样的道理，假如过了五分钟，您的应用需要播放音频，您同样需要申请音频焦点，一旦获得系统授权，我们就可以开始播放音频，其它应用响应音频焦点丢失通知，停止播放。

### 用例二 ： 当您播放音频时候，正好手机来电，需要播放响铃。

#### **您的应用不处理音频焦点的情况下：**

手机响铃后，用户会听到铃声和您的手机音频叠加在一起播放。如果用户选择直接挂断电话，您的音频会保持播放。如果用户选择接通电话，他会听到通话声音和您的应用音频叠加在一起播放，挂断通话后您的应用音频会保持播放。无论如何，您的应用音频将全程保持播放状态。这带来的通话体验极差。

![](https://cdn-images-1.medium.com/max/1000/1*_HjTvrT4locQYp8LHIMVrA.png)

#### **您的应用处理了音频焦点的情况下：**

当手机响铃（您还未接通电话）, 您的应用应该选择相应的回避（这是系统应用的要求）措施来响应短暂的音频焦点丢失。回避的措施可以是把应用的音量降低到百分之二十，也可以是直接暂停播放（如果您的应用是播客类，语音类应用）。

*   如果用户拒绝接听电话，您的应用可以马上采取响应音频焦点的获取，然后做出提高音量或恢复播放的相关操作。
*   如果用户接听了电话，操作系统会发出音频焦点丢失的通知。您的应用应该选择暂停播放，然后在通话结束后恢复播放。

![](https://cdn-images-1.medium.com/max/1000/1*P1JDTh8I8XkDwXMPjGD2cg.png)

### 总结

当您的应用需要输出音频时，应该请求音频焦点。只有在获得音频焦点后，才能开始播放。但是，在播放过程中可能无法把音频焦点一直据为己有，因为其它应用程序可以发出音频焦点的请求来抢占音频焦点，这种情况下，您的应用可以选择暂停播放或者降低音量，这样用户才能更清晰地听到其它应用程序的音频。

想详细了解更多应用程序中音频焦点的场景用例，请阅读本系列 [第二篇文章](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-2.md)。

[**理解音频焦点 (第2/3部分) - Nazmul Idris (Naz) - Medium**](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-2.md)

想学习怎么在您的应用中实现音频焦点的相关操作，请阅读本系列 [第三篇文章（终章）](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-3.md)。

[**理解音频焦点 (第3/3部分) - Nazmul Idris (Naz) - Medium**](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-3.md)

### Android多媒体开发资源

*   [示例代码 — MediaBrowserService](https://github.com/googlesamples/android-MediaBrowserService)
*   [示例代码 — MediaSession Controller Test （带有音频焦点测试）](https://github.com/googlesamples/android-media-controller)
*   [了解 MediaSession](https://medium.com/google-developers/understanding-mediasession-part-1-3-e4d2725f18e4)
*   [多媒体API指南 — 多媒体应用程序概述](https://developer.android.com/guide/topics/media-apps/media-apps-overview.html)
*   [多媒体API指南 — 使用MediaSession](https://developer.android.com/guide/topics/media-apps/working-with-a-media-session.html)
*   [使用MediaPlayer构建简单的音频应用程序](https://medium.com/google-developers/building-a-simple-audio-app-in-android-part-1-3-c14d1a66e0f1)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
