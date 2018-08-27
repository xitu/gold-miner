> * 原文地址：[How Not to Crash](http://blog.supertop.co/post/152615019837/how-not-to-crash-1)
* 原文作者：[Padraig](https://twitter.com/supertopsquid)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gocy](https://github.com/Gocy015/)
* 校对者：[lovelyCiTY](https://github.com/lovelyCiTY), [DeadLion](https://github.com/DeadLion)


# 如何避免应用崩溃

应用崩溃时有发生。崩溃会打断用户当前的工作流，导致数据的丢失，还会扰乱应用在后台的操作。对于开发者而言，那些最难修复的崩溃往往是那些难以重现，甚至难以检测到的崩溃。

我最近发现并修复了一个 bug ，而它正是导致 Castro 反复出现难以检测的崩溃的罪魁祸首（译者注： Castro 是原文作者开发的一款应用），我将处理这个问题的过程分享给大家并附上一些我的建议，或许能帮助你定位类似的问题。

我和 Oisin 在九月份发布了 Castro 2.1 版本，那之后不久，从 iTunes Connect 上报的 Castro 崩溃数量便急剧上升。

![图表展示了 Castro 从 2.0 升级到 2.1 后崩溃数量上升的情况](http://supertop.co/images/crashes.png)

### iTunes Connect 崩溃上报

有趣的是，这些崩溃并没有出现在我们平时使用的崩溃上报服务 HockeyApp 中，因此我们实际上在晚些时候才发现我们的应用出现了问题。想要查看到应用的所有崩溃，开发者需要从 iTunes Connect 或是 Xcode 中查看崩溃上报。（更新： Greg Parker [指出](https://twitter.com/gparker/status/794076875249225728) **“第三方崩溃上报系统在对应的应用进程中建立 handler 来记录应用行为，但如果操作系统从外部终止进程，这个 handler 就永远无法执行了。”**），另外， HockeyApp 的联合创始人 Andreas Linde [引用](https://twitter.com/therealkerni/status/794275740631973888) 了一篇文章来界定那些 [Hockey 能以及不能检测到的崩溃](http://t.umblr.com/redirect?z=https%3A%2F%2Fsupport.hockeyapp.net%2Fkb%2Fclient-integration-ios-mac-os-x-tvos%2Fwhich-types-of-crashes-can-be-collected-on-ios-and-os-x&t=M2RkMzgyMDY2MzU0ZWNmZmVjNDdiOTQ4MjljYWZhNjFiNDgwOGZhOCxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1)。）

如果你是一名应用开发者并且登陆了开发者账号， Xcode 允许你检视 Apple 官方从你的当前帐号下的 app 用户那收集到的崩溃日志。这项功能在 Window 导航栏下的 Organizer 窗口中的 Crashes 标签中。你可以选择特定的应用版本， Xcode 会下载 Apple 从用户手上收集到的崩溃日志，前提是用户同意将信息分享给开发者。

![图为 Xcode 中的 Crashes 标签栏所展示的用户崩溃信息](http://supertop.co/images/crashes_tab.png)

我发现 Xcode 的这个功能也非常容易崩溃，尤其是当点击崩溃日志中线程的详情按钮进行切换的时候。一个简便的解决方案是，在列表中右键选中相应的崩溃，并选择在 Finder 中显示。如果你要研究研究包中的内容，你可以把这些崩溃日志简单地当作文本文件。

### 分析崩溃原因

许多不同的代码路径都触发了这个崩溃，但崩溃最终都指向一个数据库查询方法。

一开始我认为是多线程引发的问题，毕竟在被线程问题折磨了多年之后，我总是第一时间想到它。我以文本文件的格式打开崩溃日志，因为这样比直接用 Xcode 打开展示了更多的细节。崩溃的异常类型是 `EXC_CRASH (SIGKILL)` ，对应的信息是 `EXC_CORPSE_NOTIFY` ，程序被终止的原因是 `Code 0xdead10cc` 。于是我试着找出 `0xdead10cc` 是什么含义。 Google 或是 Apple Developer 论坛都没有多少相关的信息，但 [Technical Note 2151](http://t.umblr.com/redirect?z=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Fcontent%2Ftechnotes%2Ftn2151%2F_index.html&t=MTJmNGU4NThiODlmYzE1ZWJhMTM2MWFlODU3MzFiYTFmZGU2NWY4OSxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) 中提到：

> 异常码 0xdead10cc 出现意味着应用程序因为在后台操作系统资源（譬如通讯录数据库）而被 iOS 系统终止。

这时候我意识到 iOS 强制关闭我的应用是因为我违反了系统规则，而不是说我的代码出了什么小问题。但是， Castro 并没有用到通讯录数据库或是任何我能想到的类似的系统资源。我还怀疑原因是不是应用在后台长时间运行而没有取消，但我也发现日志中有一些应用仅仅运行了两秒钟就发生崩溃的记录。

经过推理，我最终将可能原因定位到我们的数据库相关的 SQLite 文件上，因为绝大部分的堆栈信息都显示崩溃是在操作数据库的时候发生的。但 2.1 版本上的哪个改动，突然就引起了这个崩溃呢？

### 应用的共享容器

Castro 2.1 版本引入了对 iMessage 的支持来让用户轻松地分享他们最近听过的播客。为了让 message app 能够访问数据库，我们将数据库逻辑移动到了应用共享容器中。

我猜想文件的锁机制对在共享区域的文件有更严格的要求。或许当 iOS 准备挂起一个应用的时候，系统会检查这个应用是否正在使用一些可能被其他进程使用的文件，如果有， iOS 就会直接终止这个应用。这看起来是个有理有据的解释。


### 如何重现崩溃

如何重现正在修复的崩溃是锻炼开发者的绝佳实践。这可能涉及到临时改写一部分代码来刻意提高崩溃出现的可能性。如果我们能稳定地看到崩溃的发生，就能够逐步的验证我们的猜测，同时我们测试修复的正确性就有了参考。而与之对应的另一个方法是盲目地进行修复，发布版本，然后等着看是否会有崩溃上报。有时候，只有盲目修复一条路可走，但这条路枯燥乏味，而且到头来应用依然不断地在用户侧发生崩溃。

而这个崩溃就非常不容易重现，我觉得这里批评一下 iOS 的开发环境并不过分。操作系统粗野地执行着自己的规则，大部分时候，这样做很好，因为这样可以提高安全性，延长电池寿命和稳定性。但在这样的大环境下进行应用的测试和修复，就增加了不必要的麻烦。这些规则的变化悄无声息，而要人为地在应用周期可能出现的每一个状态下进行测试非常不方便，有时候甚至根本无法完成。 

在本例中，我意识到在 debugger 模式下进行测试无法触发程序后台挂起的状态。实际上，debugger [会阻止挂起，而且模拟器也不会精准的模拟挂起](http://t.umblr.com/redirect?z=https%3A%2F%2Fforums.developer.apple.com%2Fthread%2F14855&t=NmNmMmFhODVlZTk0Y2E3NDkzMzBmMWY5NzRhODY3NWRiY2MwNDExMSxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1)。如果不在 debugger 模式下的话，那么就只剩下反复测试然后查看设备日志这一个选择了。

macOS Sierra 上的全新 Console App 提供了访问任何当前连接中的 iPhone 的系统日志的功能，而在 Sierra 之前，我都是靠 Lemon Jar 的 [iOS Console](http://t.umblr.com/redirect?z=https%3A%2F%2Flemonjar.com%2Fiosconsole%2F&t=ZDQ0Y2E0YjdiNDJkMDliYzA3ZDViYTMxYTUyYThiM2Y3NjU5MzY3ZixXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) 来完成这个操作，但是，看到 Apple 官方提供能够访问日志的工具，了解这样的技术是被官方所接受并支持的，感觉也是极好的。你值得花时间去学习如何使用全新的 Console App ，它呈现出许多 Xcode 调试器无法呈现的操作。由于这份日志是整个系统所有日志的统一输出，所以会有许多不相关的冗余信息，但你可以轻松地创建一个过滤器，将显示的内容限定在与你的应用相关的范围内。

为了刻意重现崩溃 `dead10cc` ：

*   我在 `applicationDidEnterBackground` 方法中做了几百次数据库查询操作。
*   在我的 Mac 上打开 Console 应用，并过滤信息，仅显示 Castro 相关。
*   我从 Xcode 上运行安装应用，但以直接点击应用图标的形式打开应用。
*   我按 Home 键将应用退到后台，并立刻打开 Pokémon Go ，以期系统会由于内存吃紧而挂起 Castro 。

在重复了几次上述步骤之后，我发现 Console 中已经出现了我尝试重现的崩溃信息。调用堆栈看起来和真实场景的崩溃一模一样，现在我就非常自信地知道崩溃的原因何在了。

接着我发现并修复了项目中一个在后台访问数据库触发的错误：在网络状况变化时，应用会在没有创建 background task 的情况下进行数据库刷新操作。如果在刷新操作尚未完成时应用进入挂起状态， iOS 就会强制终止应用运行。

### 理解后台获取（ Background Fetch Gotcha ）

我还要再分享一件让我惊讶的事情。在 Castro 2 版本，我们在有新剧集发布后通知客户端，从而客户端会刷新用户的推送内容。当 iOS 将这条消息转发给我们的应用的时候，它会调用 `didReceiveRemoteNotification` 方法，而在这个方法中，我们有一个 completion block 的回调。官方文档中提到：

> 你的应用至多只有三十秒时间来处理推送消息，而后调用相应的 completion handler block 。实际开发中，一旦你处理完推送，就应该尽快地调用这个 handler block 。系统会记录下应用在后台所耗费的时间、电量、以及数据处理所消耗的流量。

令人抓狂的点在于：就像我在前文中提到的， Castro 有时候运行不到两秒就被终止了，我从调用栈信息明确看到这时候还没有调用 completion block ，所以说，尽管文档写着说应用可以安安心心的运行个 30 秒，但我的应用还是被挂起了。

这实在是出乎意料，于是我决定使用一次开发者 Technical Support Incidents 来看看到底发生了什么事（译者注： [Technical Support Incidents](https://developer.apple.com/support/technical/) 是苹果提供的一项技术支持服务 ）。我从负责我的请求的工程师 Kevin Elliott 那得到了一些非常有帮助的回应：

正如我所怀疑的那样， `dead10cc` 问题源于文件上锁：

> “真正触发崩溃的原因是， iOS 在挂起你的应用的时候，检查到在你的应用容器中有一个被锁住的文件（本例中就是一个 SQLite 锁）。这个检查的目的在于管理和减少应用内的数据损坏。本例的问题在于，一个文件处于被锁状态，意味着它很可能正在被修改，处于一个数据不连贯的状态。也就是说，一个应用对一个文件加锁的唯一理由就是它接下来要对这个文件进行一系列的读／写操作，并且需要保证这些写操作能够顺利完成而不被其他的写操作插队。简单的说就是，一个文件还处于被锁状态意味着对应的应用还没有完成数据的写入，而处于这种状态下的文件可能会有以下的几个问题：
> 
> *		如果应用在挂起状态被强制终止，那些“应该却还未被写入”的数据便不会被写入，导致数据损坏。
> *		如果这个文件在两个应用之间共享，此时第二个应用／应用扩展开始运行，那这个应用将要么被迫解除这个锁，并试图将文件恢复到一个稳定连续的状态，而让第一个应用继续处在一个不连续的状态，要么就完全忽略这个共享文件。”

至于那 30 秒的后台运行时间：

> ...正确的做法应该是彻底规避这个问题 － 如果你不能在 delegate 方法中完成所有的操作（译者注：这里的 delegate 方法即指 `didReceiveRemoteNotification` 方法），那么就直接另起一个 background task ，这样 iOS 在（completion block 中）挂起你的应用之前就会先通知你...

另外， Kevin 也建议应用进入后台的时候应该关闭数据库，以此来确保应用已经完成了数据刷新并能更准确的找到少见的 bug ：

> 将关闭文件作为一项常规操作，从而将一些隐蔽而奇怪的 bug （应用在后台有时不太对劲），转化成稳定出现的问题（应用在后台无法正常运行），这时候你就可以直接去定位问题了。

这看起来是个明智的做法；我从没想过要在应用进入后台的时候关闭一部分功能，但其实这么做非常合理。在 Castro 的下一个版本更新中，我将会尝试在退后台时关闭数据库。

### 总结

通过把任何会在后台持续运行的操作放到一系列 background task 中，我成功地在 beta 版本中解决了这一问题。我们会尽快发布包含这个修复的更新。

以下是我所学到的东西的小小总结：

*   Apple 官方会上报一些其他服务不会上报的崩溃。所以除了外部服务之外，也要查看在 iTunes Connect 和 Xcode 上面的崩溃信息。
*   文件的锁机制对于在共享区域的文件有着更严格的要求。
*   依赖于 background fetch 的 completion block 是远远不够的，不要在一个现行的 background task 之外做**任何**后台操作。
*   想要调试那些仅仅在应用生命周期的特定条件下出现的问题是非常困难的。如果你还没有尝试过新的 Sierra Console.app ，现在就开始学习吧。
*   别忘了 [Technical Support Incidents](http://t.umblr.com/redirect?z=https%3A%2F%2Fdeveloper.apple.com%2Fsupport%2Ftechnical%2F&t=MmJjYzRkN2JmNTg0YjlmYjEyMmZkN2QwMzFmNzAyMGNjYTZjYzI1NixXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) ，你每年的开发者账号可都为这两次机会买了单噢。（多谢啦 Kevin 大兄弟！）

如果你欣赏这篇文章，或许你也会对 [Supertop podcast](http://t.umblr.com/redirect?z=https%3A%2F%2Fitunes.apple.com%2Fca%2Fpodcast%2Fsupertop-podcast%2Fid1143273587%3Fmt%3D2&t=OGRlZTk5NmVhMDc2YmNlMmRmN2FhYmRjMzJmMTgxODYyZDcwNzFmZSxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) 和我们的播客应用 [Castro](http://t.umblr.com/redirect?z=http%3A%2F%2Fsupertop.co%2Fcastro%2Fdownload%3Fcampaign%3DCastroBGCrashPost&t=OTJiNjAwYTgwOWJhNzNmNzI2NWNiMDI3Y2RhNGFhOWNiNDVmOWY2OCxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) 感兴趣。

这篇文章的标题引用了 Brent Simmons 的 ["How Not to Crash”](http://t.umblr.com/redirect?z=http%3A%2F%2Finessential.com%2Fhownottocrash&t=YWQwOTk2YWRiOTZlYmU3ZDIyYzUwM2I5OWEzOTBiMGYxZDA0ODNjNSxXbjdGaWFQcQ%3D%3D&b=t%3AicJmaFg9TmrfMRpH7q0GXw&m=1) 系列，我强烈推荐还没看过的读者去看看这个系列。