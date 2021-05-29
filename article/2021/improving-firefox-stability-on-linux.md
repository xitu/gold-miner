> * 原文地址：[Improving Firefox stability on Linux – Mozilla Hacks - the Web developer blog](https://hacks.mozilla.org/2021/05/improving-firefox-stability-on-linux/)
> * 原文作者：[Gabriele Svelto](https://hacks.mozilla.org/author/gsveltomozilla-com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/improving-firefox-stability-on-linux.md](https://github.com/xitu/gold-miner/blob/master/article/2021/improving-firefox-stability-on-linux.md)
> * 译者：[没事儿](https://github.com/tong-h)
> * 校对者： [Kimhooo](https://github.com/Kimhooo)  [PingHGao](https://github.com/PingHGao)

# 提高 Firefox 在 Linux 上的稳定性

大约一年前在 Mozilla, 我们开始努力提升 Firefox 在 Linux 上的稳定性。这个努力很快转变成 FOSS(Free and open source software, 自由及开放源代码软件) 项目之间的一个良好协同的案例。

每次 Firefox 崩溃的时候, 用户都可以发送一份错误报告给我们, 我们通过这份报告分析问题并且希望能够修复它。

![A screenshot of a tab that justc crashed](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2021/04/image2.png)

除了其他信息外，这份报告还包含一个小型转储文件：进程内存在崩溃时生成的一个小型快照。这包含进程寄存器的内容，以及来自每个线程堆栈中的数据。

通常是这样：

![](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2021/04/image4.png)

如果你熟悉核心转储文件，那么小型转储文件在本质上是他们的一个缩小版。小型转储文件的格式最初是微软设计出来的，且在 Windows 中有一个原生的方式编写小型转储文件。在 Linux 中，我们使用 Breakpad 来做这个工作。Breakpad 起源于谷歌，用于他们自己的软件(Picasa, Google Earth 等等)，。但我们 fork 了这个项目，为了达到我们的目标做了大量修改且最近用 Rust 重写了它的部分代码。

一旦用户提交一份崩溃报告，我们就有一个服务端组件 Socorro，去处理这份报告以及从小型转储文件里提取堆栈跟踪信息。然后根据崩溃线程的堆栈跟踪的顶层方法名对报告进行集群。当一份新的崩溃报告被发现时，我们会把他归类为 bug 并开始致力于修复它。下面是一个关于崩溃如何被分组的例子：

![The snapshot of a stack trace as displayed on crash-stats.mozilla.com](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2021/04/image3.png)

从一个小型转储文件里提取一份有意义的堆栈跟踪信息，还需要两件事：展开信息和符号。展开信息是一组指令，描述如何根据给定的一个指令指针在堆栈中找到各类框架。符号信息包含与给定的地址范围相对应的函数名称，以及其源文件和给定指令所对应的行号。

在常规的 Firefox 版本中，我们从构建文件中提取这些信息且以 Breakpad 标准格式存储到符号文件中。带有这些信息， Socorro 可以创建一个人类可读的堆栈跟踪。下面是这一整个流程图：

![图形化表示崩溃报告的流程：从客户机上的捕获到服务器上的处理](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2021/04/image7.png)

一个正确的堆栈跟踪的例子：

![A fully symbolicated stack trace](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2021/04/image1.png)

如果 Socorro 不能使用正确的符号文件去提取一个崩溃的堆栈跟踪信息，那么结果就只有地址，这并不是很有帮助：

![A stack trace showing raw addresses instead of symbols](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2021/04/image6.png)

当涉及到 Linux 时，情况就与其他平台不同：我们的大部分的用户安装的不是我们的构建文件，而是他们喜欢的发行版打包的 Firefox 版本。

这将导致一个严重的问题，当处理 Firefox 在 Linux 上的稳定性问题时：对于大量的崩溃报告，我们都无法产生高质量的堆栈跟踪，因为提交报告的 Firefox 构建并不是我们创建的，所以我们缺少必需的符号文件。更糟糕的是， Firefox 依赖于大量的第三方程序包(比如 GTK, Mesa, FFmpeg, SQLite 等等)。如果一个崩溃没有发生在 Firefox 而是任何一个第三方程序包中，我们也拿不到正确的堆栈跟踪，因为我们没有它们的符号文件。

为了处理这个问题，我们开始收集 Firefox 构建的调试信息，以及从多个发行版的程序包仓库收集其依赖的调试信息：Arch, Debian, Fedora, OpenSUSE and Ubuntu。由于每个发行版都有点不同，我们必须写一些特别针对发行版的脚本，这些脚本将通过其仓库中的程序包列表找到相关的调试信息。([这里](https://github.com/gabrielesvelto/symbol-scrapers/)提供脚本)。然后，这些数据将注入一个从调试信息中提取符号文件并上传到我们的符号服务器的工具。

用那些有效的调试信息，我们就能分析研究 99% 以上的来自 Linux 用户的崩溃报告，否则这一比例将小于 20%。下面是一个从发行版本的 Firefox 提取的高质量跟踪的例子。我们还没有创建过任何相关的库，但函数名称、被影响的代码的文件和行号都是存在的。

![A fully symbolicated stack trace including external code](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2021/04/image5.png)

这里有一个重点不能被低估：Linux 用户大多对技术更有洞察力并且更有可能帮助我们解决问题，所以所有的这些报告都是可以提升稳定性的宝藏，甚至对其他操作系统(包括 Windows, Mac, Android 等等)都如此。实际上，我们经常在 Linux 中首先发现 [Fission bugs](https://bugzilla.mozilla.org/show_bug.cgi?id=1633459)。

检测 Linux 崩溃，这个新能力的的第一影响是极大的加速了我们对 Linux 特定问题的反应时间，并且使我们能够在正式版中用户遇到问题之前，就能在 Firefox 的 Nightly 和 Beta 版本中识别到。

在前沿组件中我们也能快速识别问题，就像 [WebRender](https://github.com/servo/webrender), [WebGPU](https://hacks.mozilla.org/2020/04/experimental-webgpu-in-firefox/), [Wayland](https://fedoraproject.org/wiki/Changes/Firefox_Wayland_By_Default_On_Gnome) 和 VA-API 视频加速；通常能在因改变而引发问题后的几天里提供解决方案。

我们并没有止步于此：我们现在可以识别发行版的特殊问题并且回归。这允许我们通知程序包维护者并且使问题能快速得到解决。举个例子，我们能在两周之内识别且立即解决 Debian 的特殊问题。这是由于 Debian 对 Firefox 的其中一个依赖做了修改，这会在启动时导致崩溃，如果你比较好奇其中的细节，可以在 bug [1679430](https://bugzilla.mozilla.org/show_bug.cgi?id=1679430) 归档中查看。

另一个还不错的例子来自 Fedora：在 Firefox 构建中，他们一直使用他们自己的崩溃报告系统 (ABRT) 来捕获崩溃，但是考虑到我们这边的改善[他们开始发送 Firefox 崩溃给我们](https://src.fedoraproject.org/rpms/firefox/c/de27f20acc7bdf391ccb1b571a9cb2061fc2dc3c?branch=master)。

我们也可以在我们的依赖中识别退化和问题。这使我们能够与上游沟通问题，并且有时候甚至能贡献修复方案，使我们两方的用户都能受益。

举个例子，在某个时刻，Debian 更新了字体配置包，通过反向移植一个关于内存泄漏的上游修复。然而，这个修复包含一个 bug， [会导致 Firefox 崩溃](https://bugzilla.mozilla.org/show_bug.cgi?id=1633467)，可能也会使其他软件崩溃。在 Debian 源码应用了这个修改后，仅仅 6 天我们就发现了这个新的崩溃问题，并且仅仅几周内这个问题便在上游和 Debian 里修复了。我们也发送了报告和修复方案给其他项目：[Mesa](https://gitlab.freedesktop.org/mesa/mesa/-/issues/3066), GTK, [glib](https://gitlab.gnome.org/GNOME/glib/-/issues/954), [PCSC](https://github.com/LudovicRousseau/PCSC/issues/51), SQLite 等等。

Firefox 的 Nightly 版本也包含一个工具用于检测安全敏感问题的：[概率性堆检查器](https://groups.google.com/g/mozilla.dev.platform/c/AyECjDNsqUE/m/Jd7Jr4cXAgAJ)。这个工具随机填补一些内存分配，用来检测缓冲区溢出和释放后使用的途径，当检测到其中一个时，它会给我们发送一个非常详细的崩溃报告。考虑到 Firefox 有庞大的用户群体使用 Linux，这使我们能在上游项目中发现和报告一些复杂的问题。

我们为了崩溃分析而使用这个工具，也暴露了一些关于这个工具的限制，所以我们决定使用 Rust 重写，大量的依赖了由 Sentry 开发的优秀的 crates。相比原来的工具，重写的新工具的速度要快得多，使用少量的内存并且产生的结果更为精确。这是互利的：我们为他们的 crates （以及依赖）贡献了改善建议，而他们延伸了自己的 API 来处理我们的新的使用案例以及修复我们发现的问题。

这项工作的另一个令人愉快的副作用是 Thunderbird 现在也从我们为 Firefox 做的提升中受益。

这会持续展示在 FOSS 项目之间的协作不止有利于他们的用户，而且最终会提升整个生态系统以及更广泛的依赖于此的团体。
特别感谢 Calixte Denizet, Nicholas Nethercote, Jan Auer 以及其他对此有贡献的人！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
