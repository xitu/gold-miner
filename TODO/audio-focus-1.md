> * 原文地址：[Understanding Audio Focus (Part 1 / 3): Common Audio Focus use cases](https://medium.com/google-developers/audio-focus-1-6b32689e4380)
> * 原文作者：[Nazmul Idris (Naz)](https://medium.com/@nazmul?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-1.md)
> * 译者：
> * 校对者：

# Understanding Audio Focus (Part 1 / 3)

## Common Audio Focus use cases

Many apps on your Android phone can play audio simultaneously. While the Android operating system mixes all audio streams together, it can be very disruptive to a user when multiple apps are playing audio at the same time. This results in the user having a poor experience on their phone. To deliver a good UX, Android provides an [API](https://developer.android.com/guide/topics/media-apps/audio-focus.html) that lets apps share _audio focus_, where only one app can hold audio focus at a time.

The goal of this series of articles is to give you a deep understanding of what audio focus is, why it’s important to delivering a good media UX, and how to use it. This is the first part of a three part series that includes:

1.  The importance of being a good media citizen and the most common Audio Focus use cases (**_this article_**)
2.  [Other use cases where Audio Focus is important to your media app’s UX](https://medium.com/@nazmul/audio-focus-2-42244043863a)
3.  [Three steps to implementing Audio Focus in your app](https://medium.com/@nazmul/audio-focus-3-cdc09da9c122)

Audio focus is cooperative and relies on apps to comply with the audio focus guidelines. The system does not enforce the rules. If an app wants to continue to play loudly even after losing audio focus, nothing can prevent that. This however results in a bad user experience for the user on the phone and there’s a good chance they will uninstall an app that misbehaves in this way.

Here are some scenarios where audio focus comes into play. Assume that the user has launched your app and it’s playing audio.

When your app needs to output audio, it should request audio focus. Only after it has been granted focus, it should play sound.

### Use case 1 — While playing audio from your app, the user starts another media player app and starts playback in that app

#### What happens if your app doesn’t handle audio focus

When the other media app starts playing audio, it overlaps with your app playing audio as well. This results in a bad UX since the user won’t be able to hear audio from either app properly.

![](https://cdn-images-1.medium.com/max/800/1*zaIB6fKmwSwhm_UM3Yox_A.png)

#### **_What should happen with your app handling audio focus_**

When the other media app starts playback, it requests permanent audio focus. Once granted by the system, it will begin playback. Your app needs to respond to a permanent loss of audio focus by stopping playback so the user will only hear audio the other media app.

![](https://cdn-images-1.medium.com/max/800/1*xk8Tio4_XxtmuoH9CK7qkQ.png)

Now, if the user then tries to start playback in your app, then your app will once again request permanent audio focus. And only once this focus is granted should your app start playback of audio. The other app will have to respond to the permanent loss of audio focus by stopping its playback.

### Use case 2 — An incoming phone call arrives while your app is playing audio

#### **_What happens if your app doesn’t handle audio focus_**

When the phone starts to ring, the user will hear audio from your app in addition to the ringer, which is not a good UX. If they choose to decline the call, then your audio will continue to play. If they choose to accept the call, then the audio will play along with the phone audio. When they are done with the call, then your app will not automatically resume playback, which is also not a good UX.

![](https://cdn-images-1.medium.com/max/1000/1*_HjTvrT4locQYp8LHIMVrA.png)

#### **_What should happen with your app handling audio focus_**

When the phone rings (and the user hasn’t answered yet), your app should respond to a transient loss of audio focus with the option to duck (as this is being requested by the phone app). It should respond by either reducing the volume to about 20% (called _ducking_), or pause playback all together (if it’s a podcast or other spoken word type of app).

*   If the user declines the call, then your app should react to the gain of audio focus by restoring the volume, or resuming playback.
*   If the user accepts the call, the system will send you a loss of audio focus (without the option to _duck_). Your app should pause playback in response. When they’re finished with the call, your app should react to the gain of audio focus by resuming playback of audio at full volume.

![](https://cdn-images-1.medium.com/max/1000/1*P1JDTh8I8XkDwXMPjGD2cg.png)

### Summary

When your app needs to output audio, it should request audio focus. Only after it has been granted focus, it should play sound. However, after you acquire audio focus you may not be able to keep it until your app has completed playing audio. Another app can request focus, which preempts your hold on audio focus. In this case your app should either pause playing or lower its volume to let users hear the new audio source more easily.

To learn more about the other use cases where audio focus comes into play in your app, read the [second article in this series](https://medium.com/@nazmul/audio-focus-2-42244043863a).

[**Understanding Audio Focus (Part 2 / 3) - Nazmul Idris (Naz) - Medium**](https://medium.com/@nazmul/audio-focus-2-42244043863a)

To learn more about how to implement audio focus in your app read the [final article in this series](https://medium.com/@nazmul/audio-focus-3-cdc09da9c122).

[**Understanding Audio Focus (Part 3 / 3) - Nazmul Idris (Naz) - Medium**](https://medium.com/@nazmul/audio-focus-3-cdc09da9c122)

### Android Media Resources

*   [Sample code — MediaBrowserService](https://github.com/googlesamples/android-MediaBrowserService)
*   [Sample code — MediaSession Controller Test (with support for audio focus testing)](https://github.com/googlesamples/android-media-controller)
*   [Understanding MediaSession](https://medium.com/google-developers/understanding-mediasession-part-1-3-e4d2725f18e4)
*   [Media API Guides — Media Apps Overview](https://developer.android.com/guide/topics/media-apps/media-apps-overview.html)
*   [Media API Guides — Working with a MediaSession](https://developer.android.com/guide/topics/media-apps/working-with-a-media-session.html)
*   [Building a simple audio playback app using MediaPlayer](https://medium.com/google-developers/building-a-simple-audio-app-in-android-part-1-3-c14d1a66e0f1)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
