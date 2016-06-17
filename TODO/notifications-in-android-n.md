>* 原文链接 : [Notifications in Android N](https://android-developers.blogspot.hk/2016/06/notifications-in-android-n.html)
* 原文作者 : Ian Lake
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :
* 校对者:


Android 通知往往是应用和用户之间至关重要的交互形式。为了提供更好的用户体验，Android N 在通知上做出了诸多改进：收到消息后的视觉刷新，改进对自定义视图的支持，扩展了更加实用的直接回复消息的形式，新的 `MessagingStyle`，捆绑的通知。

### 同样的通知，不一样的“面貌”

首先，最明显的变化是通知的默认外观已经显著改变。很多分散在通知周围的字段被折叠进新的标题行内，和应用程序的图标、名称固定在通知内。这一改变是为了确保尽可能腾出更多空间给标题、文本和大图标，这样一来通知就比现在的稍大些，更加易读。

![](http://ww3.sinaimg.cn/large/a490147fgw1f4w3pakcdrj20hs0853zv.jpg)

给出单标题行，这就比以往的信息更加重要且更有用。**当指定 Android N 时,默认情况下，时间会被隐藏** - 如果对时间敏感的通知（比如消息类应用），可以 `setShowWhen(true)` 设置重新启用显示时间。此外，现在 subtext 会取代内容消息和数量的作用：数量是绝不会在 Android N 设备上出现的，除非指定之前的 Android 版本，而且不包含任何 subtext，内容消息将会显示。在所有情况下，都要确保 subtext 是相关且有意义的。例如，如果用户有一个账号，就不要再添加邮箱账户作为 subtext 了。

通知收到后的操作也重新设计了，现在视觉上是在通知下方单独的一栏中。

![](http://ww4.sinaimg.cn/large/a490147fgw1f4w3pwyytkj20b203vdfw.jpg)

你会注意到，图标都没有出现在新的通知中；取而代之的是，将通知内有限的空间提供给了标签本身。然而，通知操作图标仍然需要，并继续在旧版本的Android 和设备上使用，如 Android Wear 。

如果你使用 [NotificationCompat.Builder](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) 创建了自己的通知，那么可以使用标准样式，无需修改任何代码就能变成默认的新样子。

### 更好的支持自定义视图


如果要从自定义 `RemoteViews` 创建自己的通知，以适应任何新的样式一直以来都很具有挑战性。随着新的 header，扩展行为，操作，和大图标位置都作为元素，从通知的主要内容标题中分离出来，我们已经介绍一种新的 `DecoratedCustomViewStyle` 和 `DecoratedMediaCustomViewStyle` 提供所有这些元素使用，这样就能专注于内容部分以及新的 `setCustomContentView()` 方法了。

![](http://ww4.sinaimg.cn/large/a490147fjw1f4w3qquphlj209p03hglr.jpg)


这也确保未来外观改变了，就能轻易的随着平台更新，适配这些样式，还无需修改 app 端的代码。

### 直接回复


虽然通知动作已经能够启动一个 `Activity`，或以一个 `Service` 、`BroadcastReceiver` 的方式在后台工作，**直接回复** 允许你使用通知操作直接在内嵌输入框中回复。

![](http://ww2.sinaimg.cn/large/a490147fjw1f4w3r9gdt2j207l02pt8n.jpg)

直接回复使用相同的 [RemoteInput](https://developer.android.com/reference/android/support/v4/app/RemoteInput.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) API，最初是为 Android Wear 某个 [Action](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Action.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog)用的，为了能直接接收用户的输入。

`RemoteInput` 本身包含信息，如将用于以后恢复输入的秘钥，在用户开始输入之前的提示信息。

<pre>// Where should direct replies be put in the intent bundle (can be any string)
private static final String KEY_TEXT_REPLY = "key_text_reply";

// Create the RemoteInput specifying this key
String replyLabel = getString(R.string.reply_label);
RemoteInput remoteInput = new RemoteInput.Builder(KEY_TEXT_REPLY)
        .setLabel(replyLabel)
        .build();

</pre>

一旦已经构造好 `RemoteInput` ，可以通过恰当命名的 [addRemoteInput()](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Action.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#addRemoteInput(android.support.v4.app.RemoteInput) 方法附加到 Action 上。也可以考虑调用 `setAllowGeneratedReplies(true)` 方法允许 [Android Wear 2.0](https://developer.android.com/wear/preview/index.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) 生成[智能回复](https://developer.android.com/wear/preview/api-overview.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#smart-replies)，方便用户快速回应。

<pre>// Add to your action, enabling Direct Reply for it
NotificationCompat.Action action =
    new NotificationCompat.Action.Builder(R.drawable.reply, replyLabel, pendingIntent)
        .addRemoteInput(remoteInput)
        .setAllowGeneratedReplies(true)
        .build();

</pre>

Keep in mind that the `pendingIntent` being passed into your `Action` should be an `Activity` on Marshmallow and lower devices that don’t support Direct Reply (as you’ll want to dismiss the lock screen, start an `Activity`, and focus the input field to have the user type their reply) and should be a `Service` (if you need to do work on a separate thread) or `BroadcastReceiver` (which runs on the UI thread) on Android N devices so as the process the text input in the background even from the lock screen. (There is a separate user control to enable/disable Direct Reply from a locked device in the system settings.)

请记住，在 Marshmallow 中，被传入 `Action` 的 `pendingIntent` 应该是一个 `Activity`。更低版本的设备不支持直接回复（你可能会想解锁屏幕，启动一个 `Activity`，然后聚焦到用户回复的输入框中），应该是一个 `Service`（如果你想要在一个单独的线程中运行） 或 `BroadcastReceiver`（运行在 UI 线程中） 在 Android N 设备只要在锁频后台事件处理文本输入。（在系统设置中有一个独立的用户选项，可以启用/禁用锁定设备的直接回复功能。）

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
