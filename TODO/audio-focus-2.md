> * 原文地址：[Understanding Audio Focus (Part 2 / 3): More Audio Focus use cases](https://medium.com/google-developers/audio-focus-2-42244043863a)
> * 原文作者：[Nazmul Idris (Naz)](https://medium.com/@nazmul?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-2.md)
> * 译者：
> * 校对者：

# Understanding Audio Focus (Part 2 / 3)

![](https://cdn-images-1.medium.com/max/2000/1*2_mUAwAihjBYMszQCCL0Mw.png)

## More Audio Focus use cases

The goal of this series of articles is to give you a deep understanding of what audio focus is, why it’s important to deliver a good media UX, and how to use it. This is the second part of the series that includes:

1.  [The importance of being a good media citizen and the most common Audio Focus use cases](https://medium.com/@nazmul/audio-focus-1-6b32689e4380)
2.  Other use cases where Audio Focus is important to your media app’s UX (**_this article_**)
3.  [Three steps to implementing Audio Focus in your app](https://medium.com/@nazmul/audio-focus-3-cdc09da9c122)

The first article in the series covered two of the most common use cases that you might encounter where audio focus is critical to the UX of your media app. This article will cover a few more, and introduce the notion of the type of audio focus that your app can request to help fine-tune the behavior of audio apps.

### Use case 1 — A navigation app running in the background gives turn-by-turn directions while another app plays audio

#### **_What happens if your app doesn’t handle audio focus_**

The navigation directions and music will overlap which is distracting for the user.

#### **_What should happen with your app handling audio focus_**

When the navigation app speaks the next direction, your app should respond to the transient audio focus loss with ducking (since this is being requested by the navigation app).

Your app should _duck_ (or lower the volume to about 20%) to respond to this transient loss of audio focus. The exception is if your app is playing audiobooks, podcasts, or spoken words, in which case you should pause playback.

When the directions have been spoken, the navigation app will abandon audio focus, and your app will gain it again. And it should restore the volume to the original level as a response to this gain of focus.

### Use case 2 — The user launches a game (that plays audio) while on a phone call

#### **_What happens if your app doesn’t handle audio focus_**

The user will have a bad experience with music and phone conversation overlapping.

#### **_What should happen with your app handling audio focus_**

In Android O, there’s an audio focus feature called _delayed audio focus gain_ that was created for just such a scenario. An example of this is a game that the user starts while they are on a phone call, that they want to keep playing without hearing any audio, but when the call has ended they want to hear audio from the game.

If your app supports this, and it tries to play audio while the user is in a phone call (which has acquired transient audio focus), then two things will happen.

1.  When your app requests permanent audio focus it will be denied the grant of focus, since it’s locked. The phone app has already acquired transient audio focus. And your app should not start playback (it will actually be granted audio focus at some later time). However, in the case your app is a game, it could just keep working without audio.
2.  When the phone call ends, your app will be granted _audio focus gain_. This grant is delayed by some period of time AFTER the initial request was made (while the user was in a phone call). You can handle this in the same was as your would after gaining audio focus after a transitive loss. In this case, it would start audio playback.

Versions of Android prior to Oreo don’t support _delayed audio focus gain_. On these versions, when your app attempts to start audio playback while the user is in a phone call, the audio focus request would simply not be granted, and playback would not start even after they ended the phone call.

### Use case 3 — Navigation app, or any app generating an audio notification or reminder

If you’re building an app that generates audio in bursts for short periods of time then audio focus is a very important thing for you to get right in order to deliver a good UX to your users. Examples of apps that do this are ones that generate a notification sound or a reminder sound. Or apps that generate spoken turn by turn by turn directions in the background.

Let’s say that your app is running in the background and is about to generate some audio. And the user is listening to music or a podcast, and your app generates audio for a short period of time

Before your app generates audio, it should request transient audio focus (with option to duck). Only when it’s been granted focus should it play audio. And the well behaved music app should respect its transient loss of audio focus, and duck; if the other app was a podcast app, then it might consider pausing until it regains audio focus to resume playback. Failure to request audio focus will result in the user hearing their music or podcast and your app’s audio at the same time.

### Use case 4 — Voice recorder app or speech recognition app

If you’re building an app that needs to record audio for a period of time during which the system or other apps should not make any sounds (notifications or other media playback) then handling audio focus is critical to you delivering a good UX. Examples of apps that do this are voice memo recording app or a speech recognition app.

Your app should request to gain transient and exclusive audio focus. If this is granted by the system, then you can start recording audio, knowing that no other sounds generated by the system will pollute your recording. During this period of recording, if other apps were to request audio focus, then they would be denied it. When your user has completed their recording, you should abandon audio focus, so that the system can play sounds normally.

### Summary

When your app needs to output audio, it should request audio focus (and there are different types of focus it can request).

Only after it has been granted focus, it should play sound. However, after you acquire audio focus you may not be able to keep it until your app has completed playing audio.

Another app can request focus, which preempts your hold on audio focus. In this case your app should either pause playing or lower its volume (ducking) to let users hear the new audio source more easily.

On Android O, if your app isn’t able to get audio focus when it asks, the system can give it to the app when it becomes available (delayed focus).

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
