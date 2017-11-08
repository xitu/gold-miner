> * 原文地址：[Migrating MediaStyle notifications to support Android O](https://medium.com/google-developers/migrating-mediastyle-notifications-to-support-android-o-29c7edeca9b7)
> * 原文作者：[Nazmul Idris (Naz)](https://medium.com/@nazmul?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/migrating-mediastyle-notifications-to-support-android-o.md](https://github.com/xitu/gold-miner/blob/master/TODO/migrating-mediastyle-notifications-to-support-android-o.md)
> * 译者： [ppp-man](https://github.com/ppp-man)
> * 校对者：[llp0574](https://github.com/llp0574) [zhaochuanxing](https://github.com/zhaochuanxing)

# 在 Android O 上用到 MediaStyle 的提醒功能

## 让 MediaStyle 的提醒功能在 Android O 上为你服务

![](https://cdn-images-1.medium.com/max/2000/1*tnLgad0_ePYanfSAQ3F7pA.png)

### 简介

如果你在 API level 25 或以下的版本上用 `MediaStyle` 的提醒功能，这篇文章充当把这功能迁移到 Android O 上的指引。`MediaStyle` 的提醒功能通常是有限制的，并在后台开启那些允许音频回放的服务。

Android O 的一些主要的区别需要被考虑到。

1. 后台要以 `[startForegroundService(Intent)](https://developer.android.google.cn/preview/features/background.html#services)` 开头， 而且五秒内一定要出现个持续性的提醒。
2. 如果要显示提醒就一定要用到提醒渠道。

整合到 Android O 的迁移需要以下几个小步骤。

### 第一步：改变导入的语句

记得把下面的代码加到你的导入语句中：

```
import android.support.v4.app.NotificationCompat;  
import android.support.v4.content.ContextCompat;  
import android.support.v4.media.app.NotificationCompat.MediaStyle;</pre>
```

或许之前会有 v7 的导入语句，但现在已经不再需要：

```
import android.support.v7.app.NotificationCompat;</pre>
```

现在你的 `build.gradle` 文件里，只需要导入包含 `MediaStyle` 类的 `media-compat` 函数库。

```
implementation ‘com.android.support:support-media-compat:26.+’</pre>
```

`MediaStyle` 在 `android.support.v4.media` 这个包里因为它现在是 `[media-compat](https://developer.android.google.cn/topic/libraries/support-library/packages.html#v4-media-compat)` 依赖的一部分。特意不将它们放在 `support-compat` 库里的原因是保持支持库模块里的关注点分离。

### 第二步：用 NotificationCompat 和渠道

为了在 Android O 里用到提醒功能，你一定要用提醒渠道。v4 支持库现在有为了创建提醒的新构造器：

```
NotificationCompat.Builder notificationBuilder =  
        new NotificationCompat.Builder(mContext, CHANNEL_ID);</pre>
```

老的构造器到了 26.0.0 版的支持库就不能用了，因而你在用 API 26 的时候提醒就不会显示（因为渠道在 API 26 里是提醒功能的先要条件）：

```
NotificationCompat.Builder notificationBuilder =  
        new NotificationCompat.Builder(mContext);</pre>
```

为了更好地理解 Android O 里的渠道，请在 [developer.android.google.cn](https://developer.android.google.cn/preview/features/notification-channels.html) 上阅读所有相关信息。Google Play Music 可以让你自定义提醒消息。例如，如果你只关心”重放“相关的提醒，就可以只启用与之相关的提醒并禁用其他。

![](https://cdn-images-1.medium.com/max/800/0*I8gqatqtqnPtzCZP.)

`NotificationCompat` 这个类并不帮你创建渠道，你依然要[自己创建一个](https://developer.android.google.cn/preview/features/notification-channels.html#CreatingChannels)。这里有一个 Android O 的例子。

```
private static final String CHANNEL_ID = "media_playback_channel";

    @RequiresApi(Build.VERSION_CODES.O)
    private void createChannel() {
        NotificationManager
                mNotificationManager =
                (NotificationManager) mContext
                        .getSystemService(Context.NOTIFICATION_SERVICE);
        // 渠道 ID
        String id = CHANNEL_ID;
        // 用户看到的渠道名字
        CharSequence name = "Media playback";
        // 用户看到的渠道描述
        String description = "Media playback controls";
        int importance = NotificationManager.IMPORTANCE_LOW;
        NotificationChannel mChannel = new NotificationChannel(id, name, importance);
        // 渠道的配置
        mChannel.setDescription(description);
        mChannel.setShowBadge(false);
        mChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
        mNotificationManager.createNotificationChannel(mChannel);
    }
```

这段代码利用 `NotificationCompat` 生成 `MediaStyle` 提醒。

```
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.media.app.NotificationCompat.MediaStyle;

//...

// 你只需要在 API 26 以上的版本创建渠道
if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
  createChannel();
}
NotificationCompat.Builder notificationBuilder =
       new NotificationCompat.Builder(mContext, CHANNEL_ID);
notificationBuilder
       .setStyle(
               new MediaStyle()
                       .setMediaSession(token)
                       .setShowCancelButton(true)
                       .setCancelButtonIntent(
                           MediaButtonReceiver.buildMediaButtonPendingIntent(
                               mContext, PlaybackStateCompat.ACTION_STOP)))
       .setColor(ContextCompat.getColor(mContext, R.color.notification_bg))
       .setSmallIcon(R.drawable.ic_stat_image_audiotrack)
       .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
       .setOnlyAlertOnce(true)
       .setContentIntent(createContentIntent())
       .setContentTitle(“Album”)
       .setContentText(“Artist”)
       .setSubText(“Song Name”)
       .setLargeIcon(MusicLibrary.getAlbumBitmap(mContext, description.getMediaId()))
       .setDeleteIntent(MediaButtonReceiver.buildMediaButtonPendingIntent(
               mService, PlaybackStateCompat.ACTION_STOP));
view rawMediaStyleNotification.java hosted with ❤ by GitHub
```

### 第三步：用 ContextCompat 来激活 startForegroundService()

在 Android O里，像音乐重放这类理应是在后台运行的服务需要用 `Context.startForegroundService()` 而不是 `Context.startService()` 来启动。如果你在 Android O 上，就可以用 `ContextCompat` 这个类来自动帮你完成，如果你在 Android N 或之前的版本就需要用 `startService(Intent)` 来启动。

```
if (isPlaying && !mStarted) {
   Intent intent = new Intent(mContext, MusicService.class);
   ContextCompat.startForegroundService(mContext, intent);
   mContext.startForeground(NOTIFICATION_ID, notification);
   mStarted = true;
}
```

就是那么简单！三个简单步骤就能帮你把 `MediaStyle` 的后台提醒功能从 Android O 之前的版本迁移到 Android O 上。

关于 `MediaStyle` 更新的更多资讯，请看[这里](https://developer.android.google.cn/topic/libraries/support-library/revisions.html#26-0-0)

### 安卓（Android）媒体资源

* [Understanding MediaSession](https://medium.com/google-developers/understanding-mediasession-part-1-3-e4d2725f18e4)
* [Building a simple audio playback app using MediaPlayer](https://medium.com/google-developers/building-a-simple-audio-app-in-android-part-1-3-c14d1a66e0f1)
* [Android Media API Guides — Media Apps Overview](https://developer.android.google.cn/guide/topics/media-apps/media-apps-overview.html)
* [Android Media API Guides — Working with a MediaSession](https://developer.android.google.cn/guide/topics/media-apps/working-with-a-media-session.html)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
