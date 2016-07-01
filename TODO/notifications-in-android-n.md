>* 原文链接 : [Notifications in Android N](https://android-developers.blogspot.hk/2016/06/notifications-in-android-n.html)
* 原文作者 : Ian Lake
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:

Android notifications are often a make-or-break interaction between your Android app and users. To provide a better user experience, notifications on Android N have received a visual refresh, improved support for custom views, and expanded functionality in the forms of Direct Reply, a new `MessagingStyle`, and bundled notifications.

### Same notification, new look

The first and most obvious change is that the default look and feel of notifications has significantly changed. Many of the fields that were spread around the notifications have been collapsed into a new header row with your app’s icon and name anchoring the notification. This change ensured that the title, text, and large icon are given the most amount of space possible and, as a result, notifications are generally slightly larger now and easier to read.

![](http://ww3.sinaimg.cn/large/a490147fgw1f4w3pakcdrj20hs0853zv.jpg)

Given the single header row, it is more important than ever that the information there is useful. **When you target Android N, by default the time will be hidden** - if you have a time critical notification such as a messaging app, you can re-enable it with `setShowWhen(true)`. In addition, the subtext now supersedes the role of content info and number: number is never shown on Android N devices and only if you target a previous version of Android and don’t include a subtext will content info appear. In all cases, ensure that the subtext is relevant and useful - don’t add an account email address as your subtext if the user only has one account, for example.

Notification actions have also received a redesign and are now in a visually separate bar below the notification.

![](http://ww4.sinaimg.cn/large/a490147fgw1f4w3pwyytkj20b203vdfw.jpg)

You’ll note that the icons are not present in the new notifications; instead more room is provided for the labels themselves in the constrained space of the notification shade. However, the notification action icons are still required and continue to be used on older versions of Android and on devices such as Android Wear.

If you’ve been building your notification with [NotificationCompat.Builder](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) and the standard styles available to you there, you’ll get the new look and feel by default with no code changes required.

### Better Support for Custom Views

If you’re instead building your notification from custom `RemoteViews`, adapting to any new style has been challenging. With the new header, expanding behavior, actions, and large icon positioning as separate elements from the main text+title of the notification, we’ve introduced a new `DecoratedCustomViewStyle` and `DecoratedMediaCustomViewStyle` to provide all of these elements, allowing you to focus only on the content portion with the new `setCustomContentView()` method.

![](http://ww4.sinaimg.cn/large/a490147fjw1f4w3qquphlj209p03hglr.jpg)

This also ensures that future look and feel changes should be significantly easier to adapt to as these styles will be updated alongside the platform with no code changes needed on the app side.

### Direct Reply

While notification actions have already been able to launch an `Activity` or do background work with a `Service` or `BroadcastReceiver`, **Direct Reply** allows you to build an action that directly receives text input **inline** with the notification actions.

![](http://ww2.sinaimg.cn/large/a490147fjw1f4w3r9gdt2j207l02pt8n.jpg)

Direct Reply uses the same [RemoteInput](https://developer.android.com/reference/android/support/v4/app/RemoteInput.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) API - originally introduced for Android Wear - to mark an [Action](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Action.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) as being able to directly receive input from the user.

The `RemoteInput` itself contains information like the key which will be used to later retrieve the input and the hint text which is displayed before the user starts typing.

<pre>// Where should direct replies be put in the intent bundle (can be any string)
private static final String KEY_TEXT_REPLY = "key_text_reply";

// Create the RemoteInput specifying this key
String replyLabel = getString(R.string.reply_label);
RemoteInput remoteInput = new RemoteInput.Builder(KEY_TEXT_REPLY)
        .setLabel(replyLabel)
        .build();

</pre>

Once you’ve constructed the `RemoteInput`, it can be attached to your Action via the aptly named [addRemoteInput()](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Action.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#addRemoteInput(android.support.v4.app.RemoteInput)) method. You might consider also calling `setAllowGeneratedReplies(true)` to enable [Android Wear 2.0](https://developer.android.com/wear/preview/index.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) to generate [Smart Reply](https://developer.android.com/wear/preview/api-overview.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#smart-replies) choices when available and make it easier for users to quickly respond.

<pre>// Add to your action, enabling Direct Reply for it
NotificationCompat.Action action =
    new NotificationCompat.Action.Builder(R.drawable.reply, replyLabel, pendingIntent)
        .addRemoteInput(remoteInput)
        .setAllowGeneratedReplies(true)
        .build();

</pre>

Keep in mind that the `pendingIntent` being passed into your `Action` should be an `Activity` on Marshmallow and lower devices that don’t support Direct Reply (as you’ll want to dismiss the lock screen, start an `Activity`, and focus the input field to have the user type their reply) and should be a `Service` (if you need to do work on a separate thread) or `BroadcastReceiver` (which runs on the UI thread) on Android N devices so as the process the text input in the background even from the lock screen. (There is a separate user control to enable/disable Direct Reply from a locked device in the system settings.)

Extracting the text input in your `Service`/`BroadcastReceiver` is then possible with the help of the [RemoteInput.getResultsFromIntent()](https://developer.android.com/reference/android/support/v4/app/RemoteInput.html#getResultsFromIntent(android.content.Intent)) method:

<pre>private CharSequence getMessageText(Intent intent) {
    Bundle remoteInput = RemoteInput.getResultsFromIntent(intent);
    if (remoteInput != null) {
        return remoteInput.getCharSequence(KEY_TEXT_REPLY);
    }
    return null;
 }

</pre>

After you’ve processed the text, **you must update the notification**. This is the trigger which hides the Direct Reply UI and should be used as a technique to confirm to the user that their reply was received and processed correctly.

For most templates, this should involve using the new `setRemoteInputHistory()` method which appends the reply to the bottom of the notification. Additional replies should be appended to the history until the main content is updated (such as the other person replying).

![](http://ww1.sinaimg.cn/large/a490147fjw1f4w3rp4glij20b408qt9x.jpg)

However, if you’re building a messaging app and expect back and forth conversations, you should use `MessagingStyle` and append the additional message to it.

### MessagingStyle

We’ve optimized the experience for displaying an ongoing conversation and using Direct Reply with the new `MessagingStyle`.

![](http://ww2.sinaimg.cn/large/a490147fgw1f4w3s4fxm7j20b405iglr.jpg)

This style provides built-in formatting for multiple messages added via the `addMessage()` method. Each message supports passing in the text itself, a timestamp, and the sender of the message (making it easy to support group conversations).

<pre>builder.setStyle(new NotificationCompat.MessagingStyle("Me")
    .setConversationTitle("Team lunch")
    .addMessage("Hi", timestampMillis1, null) // Pass in null for user.
    .addMessage("What's up?", timestampMillis2, "Coworker")
    .addMessage("Not much", timestampMillis3, null)
    .addMessage("How about lunch?", timestampMillis4, "Coworker"));

</pre>

You’ll note that this style has first-class support for specifically denoting messages from the user and filling in their name (in this case with “Me”) and setting an optional conversation title. While this can be done manually with a `BigTextStyle`, by using this style Android Wear 2.0 users will get immediate inline responses without kicking them out of the expanded notification view, making for a seamless experience without needing to build a full Wear app.

### Bundled Notifications

Once you’ve built a great notification by using the new visual designs, Direct Reply, `MessagingStyle`, and [all of our previous best practices](https://www.youtube.com/watch?v=-iog_fmm6mE), it is important to think about the overall notification experience, particularly if you post multiple notifications (say, one per ongoing conversation or per new email thread).

![](http://ww3.sinaimg.cn/large/a490147fgw1f4w3suh75sj20hs05ujrp.jpg)

**Bundled notifications** offer the best of both worlds: a single summary notification for when users are looking at other notifications or want to act on all notifications simultaneously and the ability to expand the group to act on individual notifications (including using actions and Direct Reply).

If you’ve built [stacking notifications for Android Wear](https://developer.android.com/training/wearables/notifications/stacks.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog), the API used here is exactly the same. Simply add [setGroup()](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#setGroup(java.lang.String)) to each individual notification to bundle those notifications together. You’re not limited to one group, so bundle notifications appropriately. For an email app, you might consider one bundle per account for instance.

It is important to also create a **summary notification**. This summary notification, denoted by [setGroupSummary(true)](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#setGroupSummary(boolean)), is the **only** notification that appears on Marshmallow and lower devices and should (you guessed it) summarize all of the individual notifications. This is an opportune time to use the [InboxStyle](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.InboxStyle.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog), although using it is not a requirement. On Android N and higher devices, some information (such as the subtext, content intent, and delete intent) is extracted from the summary notification to produce the collapsed notification for the bundled notifications so you should continue to generate a summary notification on all API levels.

To improve the overall user experience on Android N devices, **posting 4 or more notifications without a group will cause those notifications to be automatically bundled**.

### N is for Notifications

Notifications on Android have been a constant area of progressive enhancement. From the single tap targets of the Gingerbread era to expandable notifications, actions, MediaStyle, and now features such as Direct Reply and bundled notifications, notifications play an important part of the overall user experience on Android.

With many new tools to use (and [NotificationCompat](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) to help with backward compatibility), I’m excited to see how you use them to #BuildBetterApps


