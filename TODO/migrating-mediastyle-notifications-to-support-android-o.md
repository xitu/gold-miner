> * 原文地址：[Migrating MediaStyle notifications to support Android O](https://medium.com/google-developers/migrating-mediastyle-notifications-to-support-android-o-29c7edeca9b7)
> * 原文作者：[Nazmul Idris (Naz)](https://medium.com/@nazmul?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/migrating-mediastyle-notifications-to-support-android-o.md](https://github.com/xitu/gold-miner/blob/master/TODO/migrating-mediastyle-notifications-to-support-android-o.md)
> * 译者：
> * 校对者：

# Migrating MediaStyle notifications to support Android O

## Make MediaStyle notifications work for you on O

![](https://cdn-images-1.medium.com/max/2000/1*tnLgad0_ePYanfSAQ3F7pA.png)

### Introduction

If you are using `MediaStyle` notifications on API level 25 and lower, this article serves as a migration guide to moving these to Android O. `MediaStyle` notifications are typically used by bound and started services that allow audio playback to occur in the background.

There are a few major differences in Android O that have to be taken into account.

1. Background services now have to be started with `[startForegroundService(Intent)](https://developer.android.com/preview/features/background.html#services)` and then a persistent notification must be shown within 5 seconds.
2. Notification channels must be used in order to display notifications.

The migration to O requires a few short steps that are outlined here.

### Step 1 — Change your import statements

Make sure to add the following lines to your import statements:

```
import android.support.v4.app.NotificationCompat;  
import android.support.v4.content.ContextCompat;  
import android.support.v4.media.app.NotificationCompat.MediaStyle;</pre>
```

You might have an import statement from v7, that you no longer need:

```
import android.support.v7.app.NotificationCompat;</pre>
```

In your `build.gradle`, you now only need to import the `media-compat` support library. The `media-compat` library is where the `MediaStyle` class is located. The `media-compat` library is where the `MediaStyle` class is located.

```
implementation ‘com.android.support:support-media-compat:26.+’</pre>
```

`MediaStyle` is in the `android.support.v4.**media**` package because it is now part of the `[media-compat](https://developer.android.com/topic/libraries/support-library/packages.html#v4-media-compat)` dependency. They are specifically not in the `support-compat` library due to separation of concerns within the support library modules.

### Step 2 — Use NotificationCompat with channels

In order to use notifications in O, you must use notification channels. The v4 support library now has a new constructor for creating notification builders:

```
NotificationCompat.Builder notificationBuilder =  
        new NotificationCompat.Builder(mContext, CHANNEL_ID);</pre>
```

The old constructor is deprecated as of version 26.0.0 of the Support Library and will cause your notifications to fail to appear once you target API 26 (as a channel is a requirement for all notifications when targeting API 26 or higher):

```
NotificationCompat.Builder notificationBuilder =  
        new NotificationCompat.Builder(mContext);</pre>
```

To understand channels better in Android O, please read all about it on [developer.android.com](https://developer.android.com/preview/features/notification-channels.html). Google Play Music has fine grained controls about what you wish to be notified. For example, if you only care about “Playback” related notifications, you can enable those and disable the rest.

![](https://cdn-images-1.medium.com/max/800/0*I8gqatqtqnPtzCZP.)

The `NotificationCompat` class does not create a channel for you. You still have to create a [channel yourself](https://developer.android.com/preview/features/notification-channels.html#CreatingChannels). Here’s an example for Android O.

```
private static final String CHANNEL_ID = "media_playback_channel";

    @RequiresApi(Build.VERSION_CODES.O)
    private void createChannel() {
        NotificationManager
                mNotificationManager =
                (NotificationManager) mContext
                        .getSystemService(Context.NOTIFICATION_SERVICE);
        // The id of the channel.
        String id = CHANNEL_ID;
        // The user-visible name of the channel.
        CharSequence name = "Media playback";
        // The user-visible description of the channel.
        String description = "Media playback controls";
        int importance = NotificationManager.IMPORTANCE_LOW;
        NotificationChannel mChannel = new NotificationChannel(id, name, importance);
        // Configure the notification channel.
        mChannel.setDescription(description);
        mChannel.setShowBadge(false);
        mChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
        mNotificationManager.createNotificationChannel(mChannel);
    }
```

Here’s code that creates a `MediaStyle` notification with `NotificationCompat`.

```
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.ContextCompat;
import android.support.v4.media.app.NotificationCompat.MediaStyle;

//...

// You only need to create the channel on API 26+ devices
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

### Step 3 — Use ContextCompat in order to startForegroundService()

In Android O, services that are meant to run in the background, such as music playback services, are required to be started using `Context.startForegroundService()` instead of `Context.startService()`. In order to do this, you can use the `ContextCompat` class that automatically does this for you if you are on O, and still uses `startService(Intent)` on N and prior versions of Android.

```
if (isPlaying && !mStarted) {
   Intent intent = new Intent(mContext, MusicService.class);
   ContextCompat.startForegroundService(mContext, intent);
   mContext.startForeground(NOTIFICATION_ID, notification);
   mStarted = true;
}
```

That’s it! These are 3 simple steps to get you to migrate your pre-Android O `MediaStyle` notifications that are tied to background services.

For more information about the change to `MediaStyle`, read the [change log](https://developer.android.com/topic/libraries/support-library/revisions.html#26-0-0) for the support lib.

### Android Media Resources

* [Understanding MediaSession](https://medium.com/google-developers/understanding-mediasession-part-1-3-e4d2725f18e4)
* [Building a simple audio playback app using MediaPlayer](https://medium.com/google-developers/building-a-simple-audio-app-in-android-part-1-3-c14d1a66e0f1)
* [Android Media API Guides — Media Apps Overview](https://developer.android.com/guide/topics/media-apps/media-apps-overview.html)
* [Android Media API Guides — Working with a MediaSession](https://developer.android.com/guide/topics/media-apps/working-with-a-media-session.html)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
