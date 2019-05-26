> * 原文地址：[Understanding Audio Focus (Part 2 / 3): More Audio Focus use cases](https://medium.com/google-developers/audio-focus-2-42244043863a)
> * 原文作者：[Nazmul Idris (Naz)](https://medium.com/@nazmul?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-2.md)
> * 译者：[oaosj](https://github.com/oaosj)

# 理解音频焦点 (第 2/3 部分)：更多的音频焦点用例

![](https://cdn-images-1.medium.com/max/2000/1*2_mUAwAihjBYMszQCCL0Mw.png)


本系列文章旨在让您深入理解音频焦点的含义，使用方法和其对用户体验的重要性。本篇文章是该系列的第一部分，该系列三篇文章包含了：

1.  [最常见的音频焦点用例和成为一个优秀的媒体使用者的重要性](https://medium.com/@nazmul/audio-focus-1-6b32689e4380)
2.  其它一些能体现音频焦点对应用体验的重要性的用例 (**此篇文章**)
3.  [在您的应用中实现音频焦点的三个步骤](https://medium.com/@nazmul/audio-focus-3-cdc09da9c122)

本系列的第一篇文章介绍了您可能遇到的两种最常见的使用情况，其中音频焦点对您应用的用户体验至关重要。本文将继续介绍一些用例，并介绍应用可以请求的音频焦点类型的概念，以帮助应用微调音频。

### 用例一 ：当后台运行的导航程序正在播报转向语音的时候，另一个应用正在播放音乐。 

#### **您的应用不处理音频焦点的情况下：**

导航语音和音乐混在一起播放将会使用户分心。

#### **您的应用处理了音频焦点的情况下：**

当导航开始播报语音的时候,您的应用需要响应音频焦点丢失，选择回避模式，降低声音。

这里所说的回避模式，没有约束规定，建议您做到把音量调节到百分之二十。有一些特殊的情况，如果应用是有声读物，播客或口语类应用，建议暂停声音播放。

当语音播报完，导航应用会释放掉音频焦点，您的应用可以再次获得音频聚焦，然后恢复到原有音量播放（选择降低音量的回避模式时），或者恢复播放（选择暂停的回避模式时）。

### 用例二 ：用户在打电话的时候启动游戏（游戏播放音频）

#### **您的应用不处理音频焦点的情况下：**

通话声音和游戏声音的重叠播放同样会让用户的体验非常糟糕。

#### **您的应用处理了音频焦点的情况下：**

在 Android O 中，有一个应对诸如本用例的音频焦点的功能，叫做**延迟音频聚焦**。

假如当用户在通话中打开游戏，他们想玩游戏，不想听到游戏声音。但是当他们通话结束的时候他们想听到游戏声音（通话应用暂时持有音频焦点）。如果您的应用支持**延迟音频聚焦**，会发生如下情况：

1. 当您的应用申请音频焦点的时候，会被拒绝并锁住，通话应用继续持有音频焦点，您的应用因此不播放音频。因为您的应用是游戏，可以正常继续操作，只是没有声音。
2. 当通话结束，您的应用会被授权**延迟音频聚焦**。这个授权是来自刚才申请音频聚焦被拒绝后锁住的那个请求，它只是被延迟一段时间后再授权给您。您可以像上文建议应对音频焦点得失的处理方式那样处理，在本例中，此时便可以开始恢复播放。

目前低于 Android O 的版本是不支持**延迟音频聚焦**这个功能的，所以本用例在其它版本下，应用并不会延迟获得音频焦点。

### 用例三 ：导航应用或其它能生成音频通知的应用程序

如果您正在开发一款能够在短时间内以突发的方式生成音频的应用程序，提供良好的音频焦点用户体验是非常重要的。类似的应用程序功能如：生成通知声音，提醒声音或一次又一次地在后台生成口语播放的应用程序。

假设您的应用正在后台运行，并且即将生成一些音频。 用户正在收听音乐或播客，而您的应用正好在短时间内生成音频：

在您的应用程序生成音频之前，它应该请求短暂的音频焦点。 只有当它被授予焦点时，才能播放音频。优秀的应用程序应该遵守音频焦点的短暂丢失选择降低音量，如果抢占音频焦点的应用程序是播客应用程序，则您可以考虑暂停，直到重新获得音频焦点以恢复播放为止。未能正确请求音频焦点将导致用户同时听到音乐（或播客）和您的应用音频。

### 用例四 ：录音应用程序或语音识别应用程序

如果您正在开发一款需要在一段时间内录制音频的应用程序，在这段时间内系统或其他应用程序不应该发出任何声音（通知或其他媒体播放），这时处理好音频焦点对于提供良好的用户体验至关重要。需要做到这些的程序如：录音或语音识别应用程序

您的应用应当请求暂时的、独占的音频焦点，如果是来自于系统授权的，那么便可以安心地开始录制，因为系统了解并确保手机在此期间可能生成或存在的其它音频不会干扰到您的录制。在此期间，来自于其它应用的音频焦点申请都会被系统拒绝。当录制完成记得释放音频焦点，以便系统授权其它应用正常播放声音。

### 总结

当您的应用程序需要输出音频时，应该请求音频焦点（并且可以请求不同类型的焦点）。

只有在获得音频焦点之后，才能播放声音。但是，在获取音频焦点之后，您的应用程序在完成播放音频之前可能无法一直保留它。

另一个应用程序可以请求并抢占音频焦点。在这种情况下，您的应用程序应该暂停播放或降低其音量，以便让用户更清晰地听到新的音频来源。

在 Android O 上，如果您的应用程序在请求音频焦点时被拒，系统可以等音频焦点空闲时发送给您的应用程序（延迟聚焦）。

想详细了解如何在您的应用中用代码实现音频焦点，请阅读 [第三篇文章](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-3.md)。

[**理解音频焦点 (第 3/3 部分) - Nazmul Idris (Naz) - Medium**](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-3.md)

### Android多媒体开发资源

*   [示例代码 — MediaBrowserService](https://github.com/googlesamples/android-MediaBrowserService)
*   [示例代码 — MediaSession Controller Test（带有音频焦点测试）](https://github.com/googlesamples/android-media-controller)
*   [了解 MediaSession](https://medium.com/google-developers/understanding-mediasession-part-1-3-e4d2725f18e4)
*   [多媒体 API 指南 — 多媒体应用程序概述](https://developer.android.com/guide/topics/media-apps/media-apps-overview.html)
*   [多媒体 API 指南 — 使用MediaSession](https://developer.android.com/guide/topics/media-apps/working-with-a-media-session.html)
*   [使用 MediaPlayer 构建简单的音频应用程序](https://medium.com/google-developers/building-a-simple-audio-app-in-android-part-1-3-c14d1a66e0f1)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
