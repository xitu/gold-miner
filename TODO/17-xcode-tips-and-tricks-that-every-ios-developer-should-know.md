> * 原文地址：[17 Xcode Tips and Tricks That Every iOS Developer Should Know](https://www.detroitlabs.com/blog/2017/04/13/17-xcode-tips-and-tricks-that-every-ios-developer-should-know/)
> * 原文作者：[Elyse Turner](https://www.detroitlabs.com/blog/author/elyse-turner/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/17-xcode-tips-and-tricks-that-every-ios-developer-should-know.md](https://github.com/xitu/gold-miner/blob/master/TODO/17-xcode-tips-and-tricks-that-every-ios-developer-should-know.md)
> * 译者：[PTHFLY](https://github.com/pthtc)
> * 校对者：[Danny1451](https://github.com/Danny1451)、[ryouaki](https://github.com/ryouaki)

# 每个 iOS 开发者都该知道的 17 个 Xcode 小技巧

![](https://dl-blog-uploads.s3.amazonaws.com/2017/Apr/dual_screen_1745705-1492006265590.png)

对于 iOS 开发者，尤其是新手，来说，Xcode 可谓太过复杂，但是不要害怕！我们在这里帮助你。 Xcode 可以帮助你、允许你做的事情非常多。熟悉你的 IDE 是最简单有效增进实力的方法之一。

在对抗越来越臃肿的 Xcode 方面，我们底特律实验室没有新手，并且想与你分享我们的对抗策略。在底特律实验室的开发者投票之后，这是 17 个我们最受欢迎的 Xcode 小技巧。

**键位参考：**

* `⌃`: Control
* `⌘`: Command
* `⌥`: Option
* `⇧`: Shift
* `⏎`: Return

* * *

**1)** 上下移动一整行或者许多行代码：使用 `⌘ ⌥ {` 上移 或者 `⌘ ⌥ }` 下移。如果你选择了一些内容, Xcode 会移动所有你选择的代码行；否则，只会移动光标所在的那一行。

**2)** 使用 tabs 来保持聚焦。Tab 可以在不同使用情况下被单独配置和优化。Tab可以在`Behaviors`<sup><a href="#note1">[1]</a></sup>中被命名以及使用。

**3)** 使用 `Behaviors` 来根据上下文显示有用的面板。

* `Behaviors` 在 Xcode 回应某个事项时是重要的偏好设置。当你开始构建的时候，你可以设置一个偏好来打开一个窗口来响应成功、失败、开始调试等等。
* **有趣的事实:** 在测试失败的时候，你可以将播放音乐作为一个 `behavior` 。一个这儿的开发者喜欢用『 The Price is Right. 』的音乐当做失败音。

**4)** 以辅助编辑窗模式打开文件。当使用『快速打开』( `⌘ ⇧ O` )时，按住 `⌥` 的同时按 `return`。

**5)**  当光标处于显示『 Copy Qualified Symbol Name 』命令的方法内，使用 `⌘ ⇧ ⌃ ⌥ C` 会以一个优质、容易粘贴的格式拷贝方法名称。（译者注：例如`[UIColor colorWithRed:255/255.0f green:127/255.0f blue:80/255.0f alpha:1]`将会被拷贝为`+[UIColor colorWithRed:green:blue:alpha:]`。）

**6)** 当按住 `⌥` 并点击代码或方法时，有效地使用 Xcode 解析的行内文档可以提供帮助。

**7)** 在全局范围一次性更改某个变量名，可以使用 `⌘ ⇧ E`<sup><a href="#note2">[2]</a></sup>。

**8)** 你是否使用终端进入一个文件夹并且不确定你的工程使用的是 Xcode 的 workspaces 或者 仅仅是 project ？只需要运行 `open -a Xcode` 来打开文件夹本身 Xcode 会自动识别。专业提示：把这个加入你的 `.bash_profile` ，使用一个牛逼的名字（比如 `workit` ）来让你看起来像一个真的骇客。

**9)** Xcode 中显示和隐藏的快捷键。

* `⌘ ⇧ Y` : 显示/隐藏调试区域
* `⌘ ⌥ ⏎` : 显示辅助编辑器
* `⌘ ⏎` : 隐藏辅助编辑器

**10)** 使用 `⌘ A ^ I` 进行自动缩进代码

**11)** [LICEcap](http://www.cockos.com/licecap/) 对于制作在模拟器中的 GIF 动图非常有帮助，用于项目评审非常棒。在 LICEcap 上方，你可以使用 QuickTime 在屏幕上来分享你的硬件（做一个示范或者使用 LICEcap 制作 GIF ）。 在你的 iPhone 或者 iPad 插入的情况下，打开 QuickTime Player，点击 File -> New Movie Recording。然后点击记录按钮旁边的向下箭头，选择你的连接设备。这对于远程展示很有用，使用 LICEcap 来制作 GIF 或者为展示制作真机视频。![](https://dl-blog-uploads.s3.amazonaws.com/2017/Apr/Screen_Shot_2017_04_12_at_11_41_31_AM-1492011708141.png)

**12)** 按下 `⌥ ⇧` 然后点击项目导航栏中的文件打开一个选择窗口，这时你可以选择在编辑器的哪个位置显示打开的文件。 

**13)** 按住 `⌥` 的同时点击一个项目导航栏中的文件，它会显示在辅助编辑器中。

**14)** 把导航面板（显示在 Xcode 界面的左边）想成是『 Command 』面板。那是因为按住 `⌘` 的同时按一个数字键可以切换到导航栏内相关的『标签』。例如，`⌘ 1` 打开项目导航；`⌘ 7` 打开断点导航。相似的，把工具面板看作『 Command+Option 』窗口，`⌘ ⌥ 1` 也可以打开那个面板的第一个标签 —— 文件检查器。

**15)** `⌥ ⌘ ↑` 和 `⌥ ⌘ ↓` 在相关文件中进行导航(例如 .m .h 和 .xib 文件)。

**16)** 如果你在与 `code signing` 作战而 Xcode 说你没有一个有效的符合 `provisioning profile` 的签名身份，它可能会显示给你一个看起来随机、没有什么意义的码。find-identity 会很有帮助。命令 `Security find-identity -v` 会显示出一件安装的有效身份。

**17)** 在你的层层叠叠的文件夹中讯中某个文件夹非常浪费时间。在 Xcode 8 中，你可以使用『 Open Quickly 』对话框或者 `⌘ ⇧ O` 来省点时间。当它打开了你可以输入你正寻找的文件的文件名的任何部分来找到它。

你是一个 iOS 开发者吗？看看在这里工作是怎样的体验，如果你有兴趣的话，[点此申请](https://detroitlabs.workable.com/j/F1D69FF0B5)！

译者注：

1. <a name="note1"></a> `Behaviors` 可以在`偏好设置`中找到
2. <a name="note2"></a> 此处意思是缓存选中的变量名，此时进行 `Replace` 操作时，替换内容将会直接显示为缓存的内容，而不是空白一片。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

