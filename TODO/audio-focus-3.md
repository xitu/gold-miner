> * 原文地址：[Understanding Audio Focus (Part 3 / 3): 3 steps to implementing Audio Focus in your app](https://medium.com/google-developers/audio-focus-3-cdc09da9c122)
> * 原文作者：[Nazmul Idris (Naz)](https://medium.com/@nazmul?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/audio-focus-3.md)
> * 译者：[oaosj](https://github.com/oaosj)

# 理解音频焦点 (第 3/3 部分)：三个步骤实现音频聚焦

![](https://cdn-images-1.medium.com/max/2000/1*2_mUAwAihjBYMszQCCL0Mw.png)


本系列文章旨在让您深入理解音频焦点的含义，使用方法和其对用户体验的重要性。本篇文章是该系列的最后一部分，该系列三篇文章包含了：

1.  [最常见的音频焦点用例和成为一个优秀的媒体使用者的重要性](https://medium.com/@nazmul/audio-focus-1-6b32689e4380)
2.  [其它一些能体现音频焦点对应用体验的重要性的用例](https://medium.com/@nazmul/audio-focus-2-42244043863a)
3.  在您的应用中实现音频焦点的三个步骤 (**此篇文章**)

如果您不妥善处理好音频聚焦，您的用户可能受到下图所示的困扰。

![如果您不处理音频焦点会发生什么呢](https://cdn-images-1.medium.com/max/800/1*53tFOWaJmR_hrJq8QL0DHg.png)

现在您已经知道音频聚焦的重要性，让我们通过一些步骤来让您的应用程序正确处理音频焦点。

开始代码示例之前，先看看下图，它展示了实现步骤：

![](https://cdn-images-1.medium.com/max/800/1*KdcNZbndhRg5ne18kquBKA.png)

### 步骤一 ：请求音频焦点

获取音频焦点的第一个步骤是先向系统发出申请焦点的消息。注意这只是发出请求，并非直接获取。为了申请到音频聚焦，您必须向系统描述好您的意图。介绍四个常见音频焦点类型：

*   [AUDIOFOCUS_GAIN](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_GAIN)的使用场景：应用需要聚焦音频的时长会根据用户的使用时长改变，属于不确定期限。例如：多媒体播放或者播客等应用。
*   [AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)的使用场景：应用只需短暂的音频聚焦，来播放一些提示类语音消息，或录制一段语音。例如：闹铃，导航等应用。
*  [AUDIOFOCUS_GAIN_TRANSIENT](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_GAIN_TRANSIENT)的使用场景：应用只需短暂的音频聚焦，但包含了不同响应情况，例如：电话、QQ、微信等通话应用。
*  [AUDIOFOCUS_GAIN_TRANSIENT_EXCLUSIVE](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_GAIN_TRANSIENT_EXCLUSIVE) 的使用场景：同样您的应用只是需要短暂的音频聚焦。未知时长，但不允许被其它应用截取音频焦点。例如：录音软件。

在 Android O 或者更新的版本上您必须使用 [builder](https://developer.android.com/reference/android/media/AudioFocusRequest.Builder.html) 来实例化一个 [AudioFocusRequest](https://developer.android.com/reference/android/media/AudioFocusRequest.html) 类。（在 builder 中必须指明请求的音频焦点类型）

```
AudioManager mAudioManager = (AudioManager) mContext.getSystemService(Context.AUDIO_SERVICE);
AudioAttributes mAudioAttributes =
       new AudioAttributes.Builder()
               .setUsage(AudioAttributes.USAGE_MEDIA)
               .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
               .build();
AudioFocusRequest mAudioFocusRequest =
       new AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN)
               .setAudioAttributes(mAudioAttributes)
               .setAcceptsDelayedFocusGain(true)
               .setOnAudioFocusChangeListener(...) // Need to implement listener
               .build();
int focusRequest = mAudioManager.requestAudioFocus(mAudioFocusRequest);
switch (focusRequest) {
   case AudioManager.AUDIOFOCUS_REQUEST_FAILED:
       // 不允许播放
   case AudioManager.AUDIOFOCUS_REQUEST_GRANTED:
       // 开始播放
}
```

音频焦点类型要点:

1.  [AudioManager.AUDIOFOCUS_GAIN](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_GAIN)：请求长时间音频聚焦。如果只是临时需要音频焦点可以选用这几个：[AUDIOFOCUS_GAIN_TRANSIENT](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_GAIN_TRANSIENT)或[AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)。
2. 您必须通过 [setOnAudioFocusChangeListener()](https://developer.android.com/reference/android/media/AudioFocusRequest.Builder.html#setOnAudioFocusChangeListener%28android.media.AudioManager.OnAudioFocusChangeListener%29) 方法来实现 [AudioManager.OnAudioFocusChangeListener](https://developer.android.com/reference/android/media/AudioManager.OnAudioFocusChangeListener.html) 接口。用来响应音频焦点状态的变化，如被其它应用截取了音频焦点，或者其它应用释放焦点，都会在这里回调。
3. 调用 AudioManager 的 [requestAudioFocus(…)](https://developer.android.com/reference/android/media/AudioManager.html#requestAudioFocus%28android.media.AudioFocusRequest%29) 方法，需要用到实例化好的 [AudioFocusRequest](https://developer.android.com/reference/android/media/AudioFocusRequest.html)。 请求结果以一个 int 变量返回：[AUDIOFOCUS_REQUEST_GRANTED](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_REQUEST_GRANTED) 表示获得授权，
[AUDIOFOCUS_REQUEST_FAILED](https://developer.android.com/reference/android/media/AudioManager.html#AUDIOFOCUS_REQUEST_FAILED) 表示被系统拒绝。

在 Android N 及其更早的版本中，不需要用到 AudioFocusRequest，只需实现 AudioManager.OnAudioFocusChangeListener 接口。代码如下：

```
AudioManager mAudioManager = (AudioManager) mContext.getSystemService(Context.AUDIO_SERVICE);
int focusRequest = mAudioManager.requestAudioFocus(
..., // Need to implement listener
       AudioManager.STREAM_MUSIC,
       AudioManager.AUDIOFOCUS_GAIN);
switch (focusRequest) {
   case AudioManager.AUDIOFOCUS_REQUEST_FAILED:
       // don't start playback
   case AudioManager.AUDIOFOCUS_REQUEST_GRANTED:
       // actually start playback
}
```

上述皆为音频焦点的申请，接下来我们将介绍 AudioManager.OnAudioFocusChangeListener 如何实现，以此来响应音频焦点的状态。

### 步骤二 ：响应音频焦点的状态改变

一旦获得音频聚焦，您的应用要马上做出响应，因为它的状态可能在任何时间发生改变（丢失或重新获取），您可以实现 **OnAudioFocusChangeListener** 来响应状态改变。

以下代码展示了 OnAudioFocusChangeListener 接口的实现，它处理了与 [Google Assistant](https://developer.android.com/guide/topics/media-apps/interacting-with-assistant.html) 应用协同工作的时候，音频焦点的各种状态的变化。

```
private final class AudioFocusHelper
        implements AudioManager.OnAudioFocusChangeListener {
private void abandonAudioFocus() {
        mAudioManager.abandonAudioFocus(this);
    }
@Override
    public void onAudioFocusChange(int focusChange) {
        switch (focusChange) {
            case AudioManager.AUDIOFOCUS_GAIN:
                if (mPlayOnAudioFocus && !isPlaying()) {
                    play();
                } else if (isPlaying()) {
                    setVolume(MEDIA_VOLUME_DEFAULT);
                }
                mPlayOnAudioFocus = false;
                break;
            case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK:
                setVolume(MEDIA_VOLUME_DUCK);
                break;
            case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT:
                if (isPlaying()) {
                    mPlayOnAudioFocus = true;
                    pause();
                }
                break;
            case AudioManager.AUDIOFOCUS_LOSS:
                mAudioManager.abandonAudioFocus(this);
                mPlayOnAudioFocus = false;
                stop();
                break;
        }
    }
}
```

关于暂停播放，应用程序的行为应该是不同的。如果用户主动暂停播放时，您的应用应释放音频焦点。如果是为了响应音频焦点的暂时丢失而暂停播放，则不应释放音频焦点。 这里有一些用例来说明这一点。

分析上面接口 **mPlayOnAudioFocus** 的场景，您的音频应用正在后台播放音乐：

1.  用户点击播放，您的应用向系统申请音频聚焦，假如系统授权了。
2.  现在用户长按 HOME 键启动 Google Assistant。Google Assistant 会向系统申请一个短暂的音频聚焦。
3.  一旦系统授权给 Google Assistant，您的 **OnAudioFocusChangeListener** 接口会收到 **AUDIOFOCUS_LOSS_TRANSIENT** 事件回调。您在这个回调里处理暂停音乐播放。
4.  当 Google Assistant 使用结束，您的 **OnAudioFocusChangeListener** 会收到 **AUDIOFOCUS_GAIN** 事件回调。 在这里您可以处理是否让音乐恢复播放。

以下代码展示如何释放音频焦点：

```
public final void pause() {
   if (!mPlayOnAudioFocus) {
       mAudioFocusHelper.abandonAudioFocus();
   }
  onPause();
}
```

您可以看到释放焦点是在用户暂停播放的时候，而非其它应用请求焦点 **AUDIOFOCUS_GAIN_TRANSIENT** 导致他们释放焦点。

#### 应对焦点丢失

选择在 **OnAudioFocusChangeListener** 中暂停还是降低音量,取决于您应用的交互方式。在 Android O 上，系统会自动地帮您降低音量，所以您可以忽略 **OnAudioFocusChangeListener** 接口的 **AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK** 事件。

在 Android O 以下的版本，您需要自己用代码实现，具体实现方式如上面代码所示。

#### 延迟聚焦

Android O 介绍了延迟聚焦这个概念，您可以在申请音频聚焦的时候来响应 **AUDIOFOCUS_REQUEST_DELAYED** 这个结果，如下所示：

```
public void requestPlayback() {
    int audioFocus = mAudioManager.requestAudioFocus(mAudioFocusRequest);
    switch (audioFocus) {
        case AudioManager.AUDIOFOCUS_REQUEST_FAILED:
            ...
        case AudioManager.AUDIOFOCUS_REQUEST_GRANTED:
            ...
        case AudioManager.AUDIOFOCUS_REQUEST_DELAYED:
            mAudioFocusPlaybackDelayed = true;
    }
}
```

在您 **OnAudioFocusChangeListener** 的实现,您需要检查 **mAudioFocusPlaybackDelayed** 这个变量，当您响应 **AUDIOFOCUS_GAIN** 音频聚焦的时候, 如下所示：

```
private void onAudioFocusChange(int focusChange) {
   switch (focusChange) {
       case AudioManager.AUDIOFOCUS_GAIN:
           logToUI("Audio Focus: Gained");
           if (mAudioFocusPlaybackDelayed || mAudioFocusResumeOnFocusGained) {
               mAudioFocusPlaybackDelayed = false;
               mAudioFocusResumeOnFocusGained = false;
               start();
           }
           break;
       case AudioManager.AUDIOFOCUS_LOSS:
           mAudioFocusResumeOnFocusGained = false;
           mAudioFocusPlaybackDelayed = false;
           stop();
           break;
       case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT:
           mAudioFocusResumeOnFocusGained = true;
           mAudioFocusPlaybackDelayed = false;
           pause();
           break;
       case AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK:
           pause();
           break;
   }
}
```

### 步骤三 ：释放音频焦点

播放完音频，记得使用 [AudioManager.abandonAudioFocus(…)](https://developer.android.com/reference/android/media/AudioManager.html#abandonAudioFocus%28android.media.AudioManager.OnAudioFocusChangeListener%29) 来释放掉音频焦点。在前面的步骤中，我们遇到了一个应用暂停播放应该释放音频焦点的情况，但是这个应用依旧保留了音频焦点。

### 代码示例

#### 几个您可以在您应用使用的案例

在 [GitHub gist](https://gist.github.com/nic0lette/c360dd353c451d727ea017890cbaa521) 上有三个类关于音频焦点的使用，这可能对您的代码有帮助。

*   [AudioFocusRequestCompat](https://gist.github.com/nic0lette/c360dd353c451d727ea017890cbaa521#file-audiofocusrequestcompat-java)：使用这个类来描述您的音频焦点类型
*   [AudioFocusHelper](https://gist.github.com/nic0lette/c360dd353c451d727ea017890cbaa521#file-audiofocushelper-java)：这个类帮助您处理音频焦点，您可以把它加入您的代码，但是必须确保在您的播放 service 中使用 AudioFocusAwarePlayer 这个接口。
*   [AudioFocusAwarePlayer](https://gist.github.com/nic0lette/c360dd353c451d727ea017890cbaa521#file-audiofocusawareplayer-java)：这个接口应该在 service 中实现，来管理您的播放组件（MediaPlayer或者ExoPlayer），它可以确保 AudioFocusHelper 正常工作。

#### 完整的代码示例

[android-MediaBrowserService](https://github.com/googlesamples/android-MediaBrowserService) 完整展示了音频焦点的处理，使用 **MediaPlayer** 来播放音乐，同时使用了 **MediaSession** 。

[PlayerAdapter](https://github.com/googlesamples/android-MediaBrowserService/blob/master/app/src/main/java/com/example/android/mediasession/service/PlayerAdapter.java)展示了音频聚焦的最佳实践，请注意 **pause()** 和 **onAudioFocusChange(int)** 方法的实现。

### 测试您的代码

一旦您在应用中实现了音频焦点的处理，您可以使用安卓媒体控制工具来测试您的应用对音频聚焦的真实反映，具体使用方法请查阅 [GitHub/Android Media Controller](https://github.com/googlesamples/android-media-controller#audio-focus).

![](https://cdn-images-1.medium.com/max/800/1*ZiD8Wht_tAyFC4WDwVhcjg.png)

### Android多媒体开发资源

*   [示例代码 — MediaBrowserService](https://github.com/googlesamples/android-MediaBrowserService)
*   [示例代码 — MediaSession Controller Test （带有音频焦点测试）](https://github.com/googlesamples/android-media-controller)
*   [了解 MediaSession](https://medium.com/google-developers/understanding-mediasession-part-1-3-e4d2725f18e4)
*   [多媒体 API 指南 — 多媒体应用程序概述](https://developer.android.com/guide/topics/media-apps/media-apps-overview.html)
*   [多媒体 API 指南 — 使用 MediaSession](https://developer.android.com/guide/topics/media-apps/working-with-a-media-session.html)
*   [使用 MediaPlayer 构建简单的音频应用程序](https://medium.com/google-developers/building-a-simple-audio-app-in-android-part-1-3-c14d1a66e0f1)



---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
