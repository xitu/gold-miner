> * 原文地址：[How to optimize your app for Android (Go edition)](https://medium.com/googleplaydev/how-to-optimize-your-app-for-android-go-edition-f0d2bedf9e03)
> * 原文作者：[Raj Ajrawat](https://medium.com/@rajamatage?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-optimize-your-app-for-android-go-edition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-optimize-your-app-for-android-go-edition.md)
> * 译者：[androidxiao](https://github.com/androidxiao)

# 如何优化您的 Android 应用（Go 版）

## 洞察力可帮助您创建适用于全球 Android 手机的应用程序

![](https://cdn-images-1.medium.com/max/800/1*ZlH0h5W_-kszqcRfw6BLEw.png)

在去年的 Google I/O 大会上发布了 Android（Go 版），其目标是为全球入门级设备提供高质量的智能手机体验。在今年早些时候，6 家原始设备制造商在[移动世界大会上](https://www.blog.google/products/android/case-you-missed-it-android-announcements-mobile-world-congress/)宣布了他们的设备，并且更多的原始设备制造商将致力于构建新的 Android（Go 版）设备。我们对这种势头感到非常激动，并且我们鼓励您从我们的合作伙伴那里购买您自己的 Android（Go 版）设备！

我们的 OEM 合作伙伴一直在努力将设备推向市场，并且我们开始看到这些设备可供用户使用。与此同时，我一直在与 Google Play 团队合作，与 Android 社区开发人员合作，确保开发人员在适当的情况下优化他们对这些设备的应用体验。在这篇文章中，我将分享我们的合作伙伴的工作，优化他们的 Android 应用和游戏（Go 版）。

### 了解机会

正如我们在 [Google I/O 大会上](https://www.youtube.com/watch?v=-g7yxxTpF2o&list=PLOU2XLYxmsIInFRc3M44HUTQc3b_YJ4-Y&index=69&t=0s)讨论的那样，Android（Go 版）旨在改善入门级设备（内存 < 1GB 的设备）的体验。世界各地的用户一直在努力解决电池问题，设备缺乏存储，数据限制以及处理器速度差等问题，从而导致了他们对手机的更换和不满。尽管 Google 已经完成了大量工作来优化我们的应用，例如[搜索](https://play.google.com/store/apps/details?id=com.google.android.apps.searchlite)，[助理](https://play.google.com/store/apps/details?id=com.google.android.apps.assistant)，[地图](https://play.google.com/store/apps/details?id=com.google.android.apps.mapslite)和 [YouTube](https://play.google.com/store/apps/details?id=com.google.android.apps.youtube.mango)，但应用和游戏开发人员确保他们的产品能够在这些设备上顺利运行也很重要，以便用户在入门级价位上享受优质体验。

我们为 Android（Go 版）概述的要求旨在帮助您为入门级设备上的用户提供出色的体验。正如您所看到的，您应用的许多优化实际上将在全球所有设备上为用户带来更好性能的更小应用程序。

### 要优化，还是要开始尝试？选择您的应用策略
![](https://cdn-images-1.medium.com/max/800/0*gDxkFwplfrjaNDN8.)

许多人会问自己的第一个问题是：“我应该优化现有的应用程序还是创建一个新的应用程序？”虽然这个问题看似简单，但答案可能会更复杂一些。它还取决于诸如您拥有多少开发资源等因素; 无论您是否可以在应用中保留针对这些设备进行优化的功能，以及您希望为全球最终用户启用的分发场景类型。

有三种情况可以确定：

*  **一个应用程序的所有。** 针对 Android（Go 版）设备和具有相同体验的所有其他设备使用相同的应用程序。在这种情况下，您正在优化现有应用程序以便在这些设备上顺利运行，并且您的现有用户可以从这些优化中获得性能优势。这个应用程序可能是多进制的，但对于低 RAM 设备没有特定的经验。我们强烈建议您使用新的  [Android App Bundle](https://developer.android.com/platform/technology/app-bundle/) 来体验高达 65％ 的体积节省，而无需重构代码。

* **一个应用程序，不同的 APK。** 针对 Android（Go 版）设备和其他所有设备使用相同的应用，但是有不同的体验。创建不同的 APK; 一个 APK 针对新的 android.hardware.ram.low 尺寸 vs APK（s）定位其他所有设备。

* **两个应用。** 创建一个新的 “lite” 应用程序并定位 Android（Go 版）设备。您可以按原样保留现有的应用程序。“lite” 应用程序仍然可以定位所有区域设置中的所有设备，因为不需要此“精简版”应用程序仅针对 Android（Go 版）设备。

每种方式都有优点和缺点，最好根据您的特定业务来评估这些方案。

### 优化您的应用提示
![](https://cdn-images-1.medium.com/max/800/0*ebE0B6_J372H-oeR.)

确定应用策略后，在优化您的应用时需要考虑一些关键因素：

1. 确保您的应用没有 ANR 和崩溃
2. 针对 Android Oreo
3. 您安装的应用程序要低于 40 MB，游戏要低于 65 MB
4. 应用程序的 PSS 要低于 50 MB，游戏要低于 150 MB
5. 将您的应用或游戏的冷启动时间保持在 5 秒以下

现在我们来看一下这些性能指标，以现有 Android 开发人员为例。

#### 确保您的应用没有 ANR 和崩溃

研究表明，ANR（应用程序无响应）错误和崩溃可能会对用户保留造成重大负面影响，并可能导致高卸载率。购买 Android（Go版）手机的消费者会把它们作为他们的第一款智能手机，他们会期待一种快乐，干净，高效的体验，而不是让手机死机。Google Play 控制台中的 [Android 重要](https://developer.android.com/topic/performance/vitals/index.html)功能可让您跟踪 ANR 和崩溃情况，并深入了解影响特定用户或设备类型的错误。该工具对于我们许多开发人员来说是识别，分类和修复其应用程序中出现的问题所不可缺少的。

![](https://cdn-images-1.medium.com/max/800/0*TjnO4X-3zCNH1Imw.)

>“为了降低崩溃率和减少 ANR，我们使用了 Android 的重要功能和 Firebase 的 Crashlytics 进行主动监控，并且设法在大约 99.9％ 的无崩溃会话和 ANR 率小于 0.1％ 的情况下运行，从而使我们的崩溃比我们早期的版本降低了 10 倍,“ [Flipkart](https://play.google.com/store/apps/details?id=com.flipkart.android) 用户体验与成长高级总监 Arindam Mukherjee 说。“为了实现这一目标，我们分阶段推出了我们的应用程序 - 监控崩溃和 ANR，广泛使用 Nullity Annotations 来计算运行静态代码分析工具时的 NullPointerException 问题。我们还对启用 ProGuard 的版本进行了测试，这有助于我们在周期的早期捕获与混淆相关的问题。“

在诊断 ANR 时有一些常见的模式用于查找：

* 该应用程序在主线程上执行涉及 I/O 的耗时操作。
* 该应用程序正在主线程上进行耗时操作
* 主线程正在对另一个进程执行同步绑定程序调用，而其他进程需要很长时间才能返回。
* 主线程被阻塞，等待正在另一个线程上发生的耗时同步操作。
* 主线程与另一个线程处于死锁状态，无论是在您的进程中还是通过联编程序调用。主线程不是要等待很长时间才能完成操作，而是处于死锁状态。有关更多信息，请参见[死锁](https://developer.android.com/topic/performance/vitals/anr#deadlocks)。

请务必了解更多关于[诊断和再现崩溃的信息](https://developer.android.com/topic/performance/vitals/crash.html#diagnose_the_crashes)，并查看 [Flipkart](https://play.google.com/store/apps/details?id=com.flipkart.android) 关于 Android 版优化的最新视频（Go 版）：

YouTube 视频链接：https://youtu.be/4lHfTteF8tE?list=PLWz5rJ2EKKc9ofd2f-_-xmUi07wIGZa1c

#### 目标 Android 奥利奥

Android Oreo（目标 API 26）包含许多[资源优化措施](https://developer.android.com/about/versions/oreo/android-8.0.html#art)，如[后台执行限制](https://developer.android.com/about/versions/oreo/background.html)，这可确保进程在后台正常运行，同时保持手机流畅。许多这些功能都是专门为提高电池寿命和整体手机性能而设计的，并且确保使用这些设备的用户对您的应用有很好的体验。如果您的应用或游戏仍未针对 API 26 或更高版本，我强烈建议您[仔细阅读](https://developer.android.com/distribute/best-practices/develop/target-sdk.html) Google Play [的迁移指南](https://developer.android.com/distribute/best-practices/develop/target-sdk.html)。特别要密切关注[后台执行限制](https://developer.android.com/about/versions/oreo/background.html)和[通知渠道](https://developer.android.com/about/versions/oreo/android-8.0.html#notifications)。请记住[已经宣布安全更新](https://android-developers.googleblog.com/2017/12/improving-app-security-and-performance.html)：发布到 Play 控制台的新应用需要在 2018 年 8 月 1 日之前至少定位到 API 26（Android 8.0）或更高版本，而现有/已发布应用的更新将需要在 2018 年 11 月 1 日之前完成。为了符合这些要求，您需要尽快使用奥利奥。

#### 保持安装的大小很小
![](https://cdn-images-1.medium.com/max/800/0*BqSRQQuWQ7Q_Xna1.)

[APK 大小和安装率之间](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)存在[非常明显的相关性：APK 大小](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)越小，安装量越高。使用 Android（Go 版）的人对磁盘大小非常敏感，因为这些手机通常存储容量有限。这就是为什么 Play 商店会在搜索结果和 Play 商品详情等特定情况下展示应用尺寸超过应用评分的原因之一。尽管 Android（Go 版）设备上的 Play 商店与全球所有设备上的用户都可以使用的 Google Play 商店相同，但我们正在自定义商店体验，我们认为这对于这些设备上的用户非常重要。

> “我们的 Android 团队对使用网络和设备资源有限的用户会重点关注，” [Tinder](https://play.google.com/store/apps/details?id=com.tinder) 国际增长主管 AJ Cihla 说。“ 更好的是，随着  Android App Bundle 的推出，我们能够以简单，可持续的方式减少 20％，并且这样做自然适合我们的持续集成和流程部署。总而言之，我们正在寻找适用于 Android Go 设备的 27MB 
 APK; 这是我们去年发布的 90MB + 套件的一大飞跃。“


由于这些设备的容量限制，最好将您的应用程序保持在 40MB 以下，并将游戏保持在 65MB 以下。许多 Google Play 开发者认为这是他们为什么决定优化其现有 APK 的关键原因，或者是构建针对 Android（Go 版）设备的单独 APK。以下是关于如何保持 APK 较小的一些建议：


* **使用新的 Android App Bundle 去查看大小.**在今年的 Google I/O 上，我们发布了 Android App Bundle，这是来自 Google Play 的新发布格式。使用 Android App Bundle，您可以构建一个工程，其中应用程序包含已编译代码，资源和本地库。您不再需要为多个 APK 进行构建，签名，上传和管理版本代码。这为开发者节省了高达 65％ 的应用程序大小，并且前期工作量相对较少。要了解更多信息，请查看 [Android App Bundle](https://developer.android.com/platform/technology/app-bundle/)。


*   **用 WebP 文件替换 PNG/JPG 文件（如果有的话）**。通过有损 WebP 压缩，可以生成几乎相同的图像，并且文件大小更小。对于矢量图形，请使用 SVG。有关更多详细信息，请查看 [数十亿的连接：优化图像](https://developer.android.com/distribute/essentials/quality/billions/connectivity.html#images)和 [WebP 概述](https://developers.google.com/speed/webp/)。

* **用 MP3 或 AAC 替换原始音频格式（例如 WAV）以获取所有音频资源**。任何音质的损失都不应该被大多数用户感觉到，并且仍然会以较少的资源提供高质量的回放/音频聆听体验。

*   **确保使用的库是最新的并且是必要的**。考虑删除重复库并更新废弃的库。此外，如果可用，请使用移动端优化库而不是服务器优化库。要了解更多信息，请查看 [ClassyShark](https://github.com/google/android-classyshark)。

*   **保持 DEX 的合理性**。dex 代码可占用 APK 中的重要空间。考虑进一步优化代码以减小 APK 的大小。了解更多关于[减少代码的](https://medium.com/google-developers/smallerapk-part-2-minifying-code-554560d2ed40)信息，并查看我们的[为数十亿用户打造的产品指导方针中的](https://developer.android.com/distribute/essentials/quality/billions.html#appsize)相关细节。


>[AliExpress](https://play.google.com/store/apps/details?id=com.alibaba.aliexpresshd) 知道保持他们的 APK 意味着良好的商业意识：请记住，[APK 越小，安装次数越多](https://medium.com/googleplaydev/shrinking-apks-growing-installs-5d3fcba23ce2)。” 为了保持我们的 Android Go APK 尺寸小，我们首先将我们的代码分成多个模块，然后使用产品风格来定义特定的 Go 和常规版本，“ AliExpress 高级 Android 工程师 Donghua Xun 说。” 这使我们能够选择特定功能模块（例如实时视频），从我们的 Go 版本中排除。然后，我们使用 Gradle 脚本将这个 Go-edition APK 以及我们的常规 APK 打包，所有这些都来自相同的代码库。我们还使用尺寸更小的虚拟图像覆盖了第三方库中的图像。所有这些行为导致 Android Go APK 大小减少 8.8MB，而普通 APK 大小为 43MB。“


如果您有兴趣了解更多关于如何为用户提供按需功能的信息（从而保持初始下载大小），[请填写我们的兴趣表单](http://g.co/play/dynamicdeliverybeta)。


#### 保持您的记忆足迹

![](https://cdn-images-1.medium.com/max/800/0*A86M_KgUgfZyN-cR.)

Android（Go 版）手机是设备上具有 <1GB RAM 的设备。该操作系统经过优化，可在低内存环境下高效运行，开发人员关注的焦点是确保其应用程序或游戏经过优化以高效利用内存。在测试 APK 时，我们看看 [PSS](https://en.wikipedia.org/wiki/Proportional_set_size)（比例集大小），了解应用程序或游戏在设备上冷启动的内存量。PSS 的测量方式是您的应用的私有内存加上您的应用在设备上使用的共享内存的比例。



按照以下说明测试内存分配：

1. 安装应用程序并将设备连接到工作站/笔记本电脑后，启动应用程序并等待到达欢迎屏幕（我们建议等待 5 秒钟以确保所有内容都已加载）

2. 在终端中，运行命令 **adb shell dumpsys meminfo _<com.test.app>_ -d** (Where **_<com.test.app>_**（其中 <com.test.app> 是被测试的应用程序的 pkg_id，例如 com.tinder）

3. 在行 Total 中记录 PssTotal 列的值（该值以 KB 报告 - > 通过除以 1000 转换为 MB）

4. 重复步骤 2 和 3 多次（至少 5 次）并平均 PssTotal（KB）值

> LATAM 最大的购物应用程序 [Mercado Libre](https://play.google.com/store/apps/details?id=com.mercadolibre) 通过将精力集中在应用程序的体系结构上，能够解决内存分配和 APK 大小需求。”为了缩小我们 APK 的规模，我们首先通过架构和密度实现了多 APK，然后通过 ProGuard 在外部库中分离出任何额外的类或资源，“ Mercado Libre 的工程师 Nicolas Palermo 说。” 从那里，我们通过分析确认是否需要某些库，并删除那些我们不必要的库来关注我们的代码和资源。我们所有的图像都在可能的情况下更改为 WebP，并且任何未转换为 WebP 的图像都严格按照我们所需的质量进行压缩。最后，我们使用 APK 分析器了解更多关于我们的内存使用情况，以确保我们的 PSS 在可接受的范围内。“


> “我开始瞄准 SDK 26，以确保用户获得最新的 Android 体验。从那里，我找到了所有的静态函数和静态变量，看看它们是否真的有必要，然后删除那些没有的东西。为了在 Activities 和 Fragments 之间传值，可以用公共接口替换公共静态函数，”预算应用程序 [Gastos Diarios 3 的](https://play.google.com/store/apps/details?id=mic.app.gastosdiarios)创建者 Michel Carvajal 说。他补充说：“我还找到了诸如 While 和 For 这样的循环，用于读取数据库的执行操作，并尝试使用 AsyncTask 将大部分这些进程放入异步类中。最后，我搜索了不明确的 SQL 语句以取代更高效的 SQL 语句。所有这些项目以及其他一些项目共同帮助我将 PSS 降低了近 60％。

#### 保持冷启动时间在 5 秒以下

感知是关键。在用户测试和研究中，等待应用程序或游戏加载5秒后，人们会感到沮丧，这会导致放弃和卸载。您应该把它当作您的窗口，以确保您拥有一个用户，并且不要让他们有机会在他们的手机上安装您的应用后放弃您的应用。我们总是测量冷启动时间，因为这段时间是您的应用程序与用户充分交互。完成重新启动测试设备后，最好在冷启动时间内运行测试。

>“在考虑尺寸要求时，我们将工作重点放在图像压缩格式，声音片段长度和图像分辨率上，”  [Sachin Saga Cricket Champions](https://play.google.com/store/apps/details?id=com.jetplay.sachinsagacc) 制造商 JetSynthesys 生产副总裁 Amitabh Lakhera 说。“ 对于启动时间优化，减少数据加载，设置和后台实用程序，有助于节省大量时间。除了优化游戏着色器，并避免像玩家档案一样的检查，游戏平衡文件和强制更新显着加快了游戏开始。在启动时删除互联网连接并使用反作弊工具可防止玩家在游戏中出现任何潜在的不当行为，并减少内存使用量。”

总体而言，当您考虑如何让 Android 应用程序准备就绪（Go 版）时，请记住上述各种优化和调整。通过使用上述指导，所有开发人员已经完成了优化其应用和游戏的工作，我相信您将能够取得类似的成果！如果您想了解有关 Android Go 的构建以及如何针对全球市场进行优化的更多信息，请查看今年的 Google I/O 会话。

YouTube 视频链接：https://youtu.be/-g7yxxTpF2o?list=PLWz5rJ2EKKc9Gq6FEnSXClhYkWAStbwlC

* * *

### **您怎么认为？**

您有没有想过如何开发全球市场并优化您的应用策略？请在下面的评论中告诉我们，或者使用 **#AskPlayDev **发**微博**，我们会回复 [@GooglePlayDev](http://twitter.com/googleplaydev)，我们会定期分享有关如何在 Google Play 上取得成功的新闻和建议。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
