>* 原文链接 : [Notifications in Android N](https://android-developers.blogspot.hk/2016/06/notifications-in-android-n.html)
* 原文作者 : Ian Lake
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :[DeadLion](https://github.com/DeadLion)
* 校对者:[danke77](https://github.com/danke77), [xcc3641](https://github.com/xcc3641)


Android 通知往往是应用和用户之间至关重要的交互形式。为了提供更好的用户体验，Android N 在通知上做出了诸多改进：收到消息后的视觉刷新，改进对自定义视图的支持，扩展了更加实用的直接回复消息的形式，新的 `MessagingStyle`，捆绑的通知。

### 同样的通知，不一样的“面貌”

首先，最明显的变化是通知的默认外观已经显著改变。除了应用程序的图标和名称会固定在通知内，很多分散在通知周围的字段也被折叠进新的标题行内。这一改变是为了确保尽可能腾出更多空间给标题、文本和大图标，这样一来通知就比现在的稍大些，更加易读。

![](http://ww3.sinaimg.cn/large/a490147fgw1f4w3pakcdrj20hs0853zv.jpg)

给出单标题行，这就比以往的信息更加重要且更有用。**当指定 Android N 时，默认情况下，时间会被隐藏** - 对时间敏感的通知（比如消息类应用），可以 `setShowWhen(true)` 设置重新启用显示时间。此外，现在 subtext 会取代内容消息和数量的作用：数量是绝不会在 Android N 设备上出现的，除非指定之前的 Android 版本，而且不包含任何 subtext，内容消息将会显示。在所有情况下，都要确保 subtext 是相关且有意义的。例如，如果用户只有一个账号，就不要再添加邮箱账户作为 subtext 了。

通知收到后的操作也重新设计了，现在视觉上是在通知下方单独的一栏中。

![](http://ww4.sinaimg.cn/large/a490147fgw1f4w3pwyytkj20b203vdfw.jpg)

你会注意到，图标都没有出现在新的通知中；取而代之的是，将通知内有限的空间提供给了标签本身。然而，在旧版本的 Android 和设备上，通知操作图标仍然需要且被继续使用，如 Android Wear 。

如果你使用 [NotificationCompat.Builder](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) 创建了自己的通知，那么可以使用标准样式，无需修改任何代码就能变成默认的新样子。

### 更好的支持自定义视图


如果要从自定义 `RemoteViews` 创建自己的通知，以适应任何新的样式一直以来都很具有挑战性。随着新的 header，扩展行为，操作，和大图标位置都作为元素从通知的主要内容标题中分离出来，我们已经介绍一种新的 `DecoratedCustomViewStyle` 和 `DecoratedMediaCustomViewStyle` 提供所有这些元素使用， 这样就能使用新的 `setCustomContentView()` 方法，专注于内容部分。

![](http://ww4.sinaimg.cn/large/a490147fjw1f4w3qquphlj209p03hglr.jpg)


这也确保未来外观改变了，也能轻易的随着平台更新，适配这些样式，还无需修改 app 端的代码。

### 直接回复


虽然通知是可以用来启动一个 `Activity`，或以一个 `Service` 、`BroadcastReceiver` 的方式在后台工作，**直接回复** 允许你使用通知操作直接在内嵌输入框中回复。

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

一旦已经构造好 `RemoteInput` ，可以通过恰当命名的 [addRemoteInput()](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Action.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#addRemoteInput(android.support.v4.app.RemoteInput)) 方法附加到 Action 上。也可以考虑调用 `setAllowGeneratedReplies(true)` 方法允许 [Android Wear 2.0](https://developer.android.com/wear/preview/index.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) 生成[智能回复](https://developer.android.com/wear/preview/api-overview.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#smart-replies)，方便用户快速回应。

<pre>// Add to your action, enabling Direct Reply for it
NotificationCompat.Action action =
    new NotificationCompat.Action.Builder(R.drawable.reply, replyLabel, pendingIntent)
        .addRemoteInput(remoteInput)
        .setAllowGeneratedReplies(true)
        .build();

</pre>

请记住，在 Marshmallow 中，被传入 `Action` 的 `pendingIntent` 应该是一个 `Activity`。更低版本的设备不支持直接回复（你可能会想解锁屏幕，启动一个 `Activity`，然后聚焦到用户回复的输入框中），Android N 设备上 `Service`（如果你想要在一个单独的线程中运行） 或 `BroadcastReceiver`（运行在 UI 线程中） 即便处于锁频状态，后台也能处理文本输入。（在系统设置中有一个独立的用户选项，可以启用/禁用锁定设备的直接回复功能。）

在 `Service`/`BroadcastReceiver` 中提取输入的文本，可能需要 [RemoteInput.getResultsFromIntent()](https://developer.android.com/reference/android/support/v4/app/RemoteInput.html#getResultsFromIntent(android.content.Intent)) 的帮助。

<pre>private CharSequence getMessageText(Intent intent) {
    Bundle remoteInput = RemoteInput.getResultsFromIntent(intent);
    if (remoteInput != null) {
        return remoteInput.getCharSequence(KEY_TEXT_REPLY);
    }
    return null;
 }

</pre>

处理文本后，**必须更新通知**。这将触发隐藏直接回复 UI，这可以作为一种技巧来确认用户是否收到回复并正确处理。

对于大多数模板，这将涉及使用新的 `setRemoteInputHistory()` 方法，将答复追加到通知底部。更多回复应该追到历史记录下，直到主要内容更新（比如别人的回复）。

![](http://ww1.sinaimg.cn/large/a490147fjw1f4w3rp4glij20b408qt9x.jpg)

不过，如果你是在做一个消息应用，期待着“你来我往”的对话，那就应该用 `MessagingStyle`，将额外消息追加上去。


### MessagingStyle

我们已经优化过正在对话状态中消息的显示，用新的 `MessagingStyle` 直接回复。

![](http://ww2.sinaimg.cn/large/a490147fgw1f4w3s4fxm7j20b405iglr.jpg)

对于通过多 `addMessage()` 方法增加多条消息，这种风格提供内置的格式化。每个消息支持通过文本本身、 一个时间戳，以及消息的发送人来增加（使它易于支持组对话）。

<pre>builder.setStyle(new NotificationCompat.MessagingStyle("Me")
    .setConversationTitle("Team lunch")
    .addMessage("Hi", timestampMillis1, null) // Pass in null for user.
    .addMessage("What's up?", timestampMillis2, "Coworker")
    .addMessage("Not much", timestampMillis3, null)
    .addMessage("How about lunch?", timestampMillis4, "Coworker"));

</pre>

你可能会注意到，这种风格能很好的支持特殊用户消息的展示，填写它们的名字（上例中的“Me”），设置一个可选的对话标题。
虽然可以手动通过 “BigTextStyle” 来完成，使用这种风格的 Android Wear 2.0 用户能立即得到内置响应，不会被“踢出”扩展通知视图，无需创建完整的穿戴（Android Wear）应用就能达到无缝体验。

### 捆绑通知

一旦你想建立了一个“巨牛逼”的通知，通过使用新的视觉设计，直接回复，`MessagingStyle`还有[所有之前最佳实践](https://www.youtube.com/watch?v=-iog_fmm6mE),但考虑通知的整体体验也很重要，尤其是发送多条通知的情况（每个正在进行的谈话或每个新的电子邮件线程）。


![](http://ww3.sinaimg.cn/large/a490147fgw1f4w3suh75sj20hs05ujrp.jpg)

**捆绑通知** 提供两全其美的办法: 一个单独的概要通知，当用户在看其他通知或者想要同时操作所有通知时在个别通知上扩展了组操作能力（包括使用操作和直接回复）。

如果你为 Android Wear 创建了 [堆通知](https://developer.android.com/training/wearables/notifications/stacks.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog)，这里使用的 API 是完全一样的。只需将 [setGroup()](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#setGroup(java.lang.String)) 添加到每个单独通知中，将那些通知“绑定”到一起。不仅限于绑定成一组，所有捆绑通知是十分灵活的。对于邮件应用，可能考虑每个账户的邮件“捆”成一组。

创建概要通知也是很重要的。这个概要通知，通过 [setGroupSummary(true)](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog#setGroupSummary(boolean)) 展示通知，这也是唯一支持 Marshmallow 和更低版本的设备的通知，会归纳所有个人通知（你猜对了）。这是使用 InboxStyle 的最佳时机，虽然没有要求用它。在 Android N 或更高版本设备上，从概要通知上提取的某些信息（如 subtext、content intent 和 delete intent），来为捆绑通知生成 collapsed 通知，所以你应该继续在所有 API级别上生成概要通知。

为了提升所有 Android N 设备的用户体验，**发送 4 个或者更多通知时没有以组的方式，这些通知将自动合并成一组**

### 为通知而生的 Android N

通知在 Android 上是一直不断改进的功能。从 Gingerbread 时代的单击目标，到可扩展通知，操作，MediaStyle 以及现在的直接回复，绑定通知。通知在 Android 用户体验上扮演着不可或缺的一部分。

随着许多新工具可使用（[NotificationCompat](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.html?utm_campaign=android_series_notificationsandroidnblog_060816&utm_source=anddev&utm_medium=blog) 能帮助保持向后兼容），我已经迫不及待的想看看如何用这些工具创建更好的应用。
