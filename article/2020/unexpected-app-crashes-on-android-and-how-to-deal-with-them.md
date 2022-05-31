> * 原文地址：[Unexpected App Crashes on Android and How to Deal with Them](https://levelup.gitconnected.com/unexpected-app-crashes-on-android-and-how-to-deal-with-them-c5d07512d99f)
> * 原文作者：[Kunal Chaubal](https://medium.com/@kunalchaubal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/unexpected-app-crashes-on-android-and-how-to-deal-with-them.md](https://github.com/xitu/gold-miner/blob/master/article/2020/unexpected-app-crashes-on-android-and-how-to-deal-with-them.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[zenblo](https://github.com/zenblo)、[HumanBeing](https://github.com/HumanBeingXenon)

# Android 中意料之外的应用崩溃以及它们的解决方案

![图自 [testbytes](https://pixabay.com/users/testbytes-1013799/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=762486) 源于 [Pixabay](https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=762486)](https://cdn-images-1.medium.com/max/2560/1*4WT3_B3SVKgvexQOTE_ZqQ.jpeg)

如果问前端、后端甚至游戏开发人员之间存在什么共同点，那就是我们都讨厌应用产品出现 Bug，尤其是当这些错误导致应用崩溃时。而在应用发布后，监视应用程序中这些不断增加的崩溃是一种极其不愉快的体验。

不管应用程序的业务逻辑如何，都可能会因为运行的系统或平台问题而导致出现某些奇怪的崩溃现象。在 Android 中，从后台状态恢复应用程序时可能会产生崩溃 —— 此类崩溃是意外发生的，而且仅通过查看崩溃日志，我们很难理解崩溃的具体原因以及解决问题，而本文讨论了此类问题及其解决方法。

## 问题

在监视产品的崩溃日志时，我注意到一些问题与日俱增。该应用在正常测试条件下似乎运行良好，并且崩溃不可复现，直到应用程序从后台任务中进入前台。

每个 Android 应用程序都在其自己的进程中运行，并且操作系统已为该进程分配了一些内存。当用户与其他应用程序交互时将应用程序置于后台时，如果应用程序没有足够的可用内存，则操作系统会终止你的应用程序进程。而这一情况通常发生在前台运行另一个需要更大手机内存 (RAM) 的应用程序时。

当应用程序进程被终止的时候，所有的单例对象和临时数据都同时丢失了，而现在如果你返回你的应用程序，系统会创建一个新的进程，而你的应用程序会从你退出时候的 Activity 栈顶执行 Resume 函数恢复该 Activity。

由于此时你的所有的单例对象都丢失了，因此当这个 Activity 尝试访问相同的对象时，就会遇到空指针异常而崩溃退出。

这是个问题。在我们继续讨论解决方案之前，让我们复现一下这种情况。

## 复现崩溃

1. 在模拟器或通过 USB 电缆（译者注：Android 11 也可使用 Wi-Fi 连接设备调试）连接的实际设备上使用 ADB 运行指令（如 Android Studio）运行的任何应用程序。
2. 导航到任意一个页面，然后按下“主页”按钮。
3. 打开终端，键入以下命令，我们就可以获取应用程序的进程 ID（PID）。

```bash
adb shell pidof com.darktheme.example
```

该命令的语法为 `adb shell pidof APP_BUNDLE_ID`

请记下你在终端窗口上看到的 PID（这可用于验证现有的应用程序进程是否已被终止，并在我们恢复应用程序时启动了新的进程）。

4. 键入以下终端命令以终止你的应用程序进程

```bash
adb shell am kill com.darktheme.example
```

此时，你的终端窗口应如下所示：

![执行 kill 命令后的命令行窗口](https://cdn-images-1.medium.com/max/2276/1*pYpZN8FbnrYeo_6QPGqc0g.png)

现在，从后台任务中打开你的应用程序，并检查该应用程序是否崩溃。如果是，请不要担心，我们将在下一部分中讨论如何处理此问题。如果没有，你可以松一口气了，因为这是你应得的。

需要注意的是，从后台打开应用后，请重新获取应用所属进程的 PID。如果你在第 3 步中记下的 PID 与新的 PID 相等，则该过程并没有被终止。

## 建议的解决方案

有两种方法可以解决此问题。根据你所处的情况，你可以决定用哪一个方法来推进问题的解决：

#### 解决方案 1：

一种简便的解决方案是，当用户从后台恢复应用程序时，让应用程序检查我们现有的应用程序进程是否被结束并重新创建。如果是，则可以导航回启动界面，使其看起来像是一个应用程序的初始化界面。

你可以将以下代码放在 BaseActivity 中：

```Kotlin
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState != null) {
            // 获取当前 PID
            val currentPID = android.os.Process.myPid().toString()
            
            // 比较当前 PID 与 保存的 PID 是否一致
            if (currentPID != savedInstanceState.getString(PID)) {
                // 如果当前 PID 与 保存的 PID 不相同，意味着新的进程被创建，从 SplashActivity 重启应用
                val intent = Intent(applicationContext, SplashActivity::class.java)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                startActivity(intent)
                finish()
            }
        }
    }

    override fun onSaveInstanceState(bundle: Bundle) {
        super.onSaveInstanceState(bundle)
        bundle.putString(PID, android.os.Process.myPid().toString())
    }
```

* 通过覆写 `onSaveInstanceState()` 功能，你可以将你的 PID 打包保存下来。
* 在 `onCreate()` 方法中，你需要比较当前 PID 和打包保存的 PID。
* 如果当前进程是重新创建的流程，则重定向导航到 Splash Activity。

当用户从后台导航回被结束了的应用程序时候，该应用程序将从 SplashActivity 重新启动，就像是一次新的启动。

这将防止应用程序访问在进程重建过程中可能已丢失的数据，从而防止应用程序崩溃。

虽然此解决方案可以防止崩溃，但是这种方法其实就是重新启动应用程序，而不是从中断的位置恢复应用程序。如果你在发布应用后遇到此问题，并且急切地希望快速解决这个问题，则此解决方案应该能帮你大忙。

但是，如果你刚从头开始开发，则解决方案 2 将是你的理想选择，因为它可以做到从中断的位置恢复应用程序。

#### 解决方案 2：

现在，你肯定已经注意到可以利用“包”对象保存和访问数据。与前面的示例中的操作类似，将每个 Activity / Fragment 中所有必要的信息保存下来。

由于我们访问是被保存在“包”中的数据，这会避免应用程序崩溃，并且应用程序能从中断处恢复。所有其他 Activity / Fragment 也会被重新创建。

对于 Fragment 中的 RecyclerView，做法应该是：

```Kotlin
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        val recyclerView = view.findViewById(R.id.recyclerView)
        recyclerView.layoutManager = LinearLayoutManager(context)
        users = savedInstanceState?.getParcelableArrayList("userList") ?: viewModel.getUsers()
        rv.adapter = DataAdapter(users, this)
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putParcelableArrayList("userList", users as ArrayList)
    }
```

* 通过覆写 `onSaveInstanceState()` 功能，我们可以将所需信息保存在 Bundle 对象中。
* 我们会让应用程序检查 `onViewCreated()` 函数中捆绑包中的数据是否可用，如果不可用，则会通过访问 ViewModel 的方法获取数据。

## 结论

在 Android 平台上，由于进程被终止而导致的应用崩溃是很常见的。而如果我们使用较新的 Android 版本，我们可以注意到，出于节省电源的目的，大量的后台应用程序被强制结束运行了。

解决方案 1 可以快速解决你现有的应用崩溃问题。

但是，如果你正在从头开始开发应用程序，我建议使用解决方案 2，因为它可以确保系统会从先前关闭的位置恢复该应用程序，因此带来更好的用户体验。

研究此类崩溃的根本原因可能会挺困难的，因此我希望本文能够以任何可能的方式对你有所帮助。请告诉我你们对文中讨论的解决方案有何看法。

这就是本文的全部内容，祝编程愉快，代码无 Bug！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
