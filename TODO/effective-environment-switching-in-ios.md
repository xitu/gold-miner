> * 原文地址：[Effective Environment Switching in iOS](https://medium.com/@volbap/effective-environment-switching-in-ios-6df0b08e9556)
> * 原文作者：[Pablo Villar](https://medium.com/@volbap?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/effective-environment-switching-in-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO/effective-environment-switching-in-ios.md)
> * 译者：[swants](http://www.swants.cn)
> * 校对者：[charsdavy](https://github.com/charsdavy) [VernonVan](https://github.com/VernonVan)

# Xcode 环境配置最佳实践

![](https://cdn-images-1.medium.com/max/2000/1*phOfJPH1G1VTDfpyqVlkow.jpeg)

### 前言

工欲善其事，必先利其器。在 iOS 中，如何处理 **配置环境** 和根据需求自定义的 **设置** 关系也尤为重要。虽然 Xcode 提供了一系列的工具帮助我们进行妥善地配置。但遗憾的是，我见过的很多团队在绝大多数时候都没有充分利用这些辅助工具。这并不是他们的错：苹果只为我们提供了一些不怎么好用的默认配置，而没有更好的帮助我们学习如何达到最佳实践。

在这篇文章里，我们将探索如何更好地利用 Xcode 配置，如何把 APP 的设置定义得更加有条理。

### Xcode 配置

Xcode 可以通过各种配置构建不同设置的包。通俗地讲，配置就是告诉编译器如何构建版本的一系列设置。IDE 允许你根据不同的配置来自定义一些设置。你可能经常看到这些：

![](https://cdn-images-1.medium.com/max/800/1*3M9G9pHYcupklR3xdFX7PA.png)

等等…

#### Debug vs. Release

Debug 和 Release 是 Xcode 提供的两种默认配置。你完全也可以创建你自己的配置，但我们通常不这么做，因为自定义的配置是否有效可能取决于项目，iOS 开发者们对哪些配置可以对项目普遍有效还没有达成共识。 

这两种默认配置有几处差别，具体的差别在这里我不会详细讨论，只是简单概括下：

> 在 **debug** 构建的版本中，Xcode 会给我们发送完整的符号调试信息来帮助我们调试应用，并且 Xcode 不会对代码进行优化（更快的构建速度）。而在 **release** 构建的版本中，不会发送调试信息并且代码会被优化（较慢的构建速度）。

至于这两种配置的用途，**debug** 通常会在我们日常开发中使用。而 **release** 我们通常会在需要将 APP 分发给其他非开发人员如：测试人员、项目经理、客户或用户时使用。

需要注意的是，这两个配置通常是不能完全满足需求的。而且开发者经常把 ≪debug vs. release≫ 和 ≪staging vs. production≫ 这两个概念搞混，这完全是不应该的。

#### 我们可以继续完善

一些项目使用不同的配置环境：开发环境、临时环境、生产环境、预生产环境等等，用你最想用的那个就好。这种分类方式和上面讨论的两种默认配置没有直接联系。就算我们强制这么分类，用的时候达到的效果也没有想象中的那样好。比如，你想准备构建一个 **_release_** 版本，但这并不意味着你的 APP 一定要指向 **生产** 服务器：想像一下，你需要为 QA 打个 release 的版本的包，而这个包需要在临时服务器上进行测试。 这时就连 debug & release 两个默认的配置也不能满足需求了。

因此，我想用可以满足我们更多需求的其他配置方案来代替基本的 debug & release 配置。为了足够简单，在我的方案中只会保留临时环境和生产环境，在你需要使用其它环境配置时，你会发现在我的方案里可以轻松添加。

#### 让我们重新定义配置环境

我们可以定义四种配置环境：

* Debug Staging
* Debug Production
* TestFlight Staging
* TestFlight Production


从它们的名字上，你就能猜到它们大概的设置，下面就是它们的详细设置：


* 前两个（Debug Staging & Debug Production）和默认的 Debug 配置一样，但 **每个都指向不同的服务器环境**。
* 后两个配置环境（两个 TestFlight 配置环境 ）也是这样，它们和默认的 Release 配置一样，不包含调试信息并进行了代码优化，但 **每个都在对应的服务器环境下使用**。

![](https://cdn-images-1.medium.com/max/800/1*E24WkTnP6IXFceTvE3MtxQ.png)

实现的操作也是非常简单，找到 project 的 Settings > Info > Configurations，然后点击 + 按钮。拷贝一份 Debug 配置，并将默认的配置命名为 “Debug Staging”，拷贝出来的配置命名为 “Debug Production”。按照这个方式对 Release 进行处理。

当你操作完后是这个效果：

![](https://cdn-images-1.medium.com/max/1000/1*TalswynK3oCREkrhNBJGlg.png)

一个 project 包含四种不同的配置环境。

#### 第五种配置环境

我使用 “ __TestFlight__” 命名 release 配置，而不是使用原来的 “__Release__” 命名是有原因的。因为代码中有些特定事件只在最终用户使用时触发，而在测试人员和客户使用时不触发。一个具体的场景就是使用用户统计来跟踪事件，这可能要求跟踪事件仅作用于最终用户，而不是生产环境下的测试人员。在这种情况下， 我们就要考虑 __TestFlight Production__ 配置具有的细微差别，因此我们需要将这个配置继续细分下去。引进第五种配置：

* AppStore

你可以快速地拷贝一份 TestFlight Production 来添加这个配置。但需要注意的是这个配置可能一直不会用到，因为你不一定会遇到需要细分 TestFlight Production 配置的需求。

那么，现在你可能很想知道 **如何根据所选配置来管理 APP 中的触发事件**。这些将会在接下来部分详细介绍。

### 自定义设置

有很多方式可以做到根据所选不同配置来执行不同的操作：预编译器指令、环境变量、各种 plist 文件等等。这些方式都有自己的优缺点，这里只讨论我将采取的比较纯净的方式。

需要根据配置执行的各种操作通常可以由变量来控制，通过这些变量来决定 APP 的行为。这些变量通常称为 **settings** 。比如一些像这样的 settings ：服务器 API 的 base URL、Facebook App ID、日志的详细级别、是否支持离线访问等等。

接着，展示我现在如何根据所选配置来管理这些自定义 settings 的方法。从我的以往经验来看，这是目前最方便的方案。

#### Settings.swift

APP 的自定义 settings 可以通过单例很简单的获取到。

```
struct Settings {
    static var shared = Settings()
    let apiURL: URL
    let isOfflineAccessEnabled: Bool
    let feedItemsPerPage: Int
    private init() {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")!
        let plist = NSDictionary(contentsOfFile: path) as! [AnyHashable: Any]
        let settings = plist["AppSetings"] as! [AnyHashable: Any]
        
        apiURL = URL(string: (settings["ServerBaseURL"] as! String))!
        isOfflineAccessEnabled = settings["EnableOfflineAccess"] as! Bool
        feedItemsPerPage = settings["FeedItemsPerPage"] as! Int
        
        print("Settings loaded: \(self)")
    }
}
```

这个结构体用来读取和记录 APP 的各种 settings（这些 settings 会在 APP 的 `Info.plist` 文件中定义），这样我们就可以在代码中随时拿到这些 settings。在这里我喜欢使用强制解包，因为这样如果缺少某项设置，APP 也会无法运行。

#### Info.plist

在 `Info.plist` 文件中定义 appSettings 。这里我建议大家使用字典把这些设置汇总到一起。

![](https://cdn-images-1.medium.com/max/1000/1*NlmqO1X2mvioMWhj9swBXg.png)

这样，我们就非常纯净地完成了对 APP settings 的读取。这些 settings 在不同的配置环境中值都是不同的，还差一点就完成了。

#### User-Defined Settings

想一下，在所有的工程内 **什么会随配置的不同而改变** ？ 对，编译器的代码优化级别、header 的搜索路径、描述文件等等。如果我们能够定义我们自己的随所选配置改变的设置，那不就简单了！事实证明，我们确实可以创建用户自定义的设置。

![](https://cdn-images-1.medium.com/max/800/1*ilzKZsI_BCcgal5tzhkUWw.png)

创建 User-Defined settings 非常简单，只需要在你的 Target > Build Settings 中，点击 + 按钮，然后选择 “Create User-Defined Setting”。这些也可以在 project > Build Settings 下创建，但我觉得在 Target > Build Settings 创建更合适。

 因为你刚创建的 User-Defined Settings 可能还需与其他的 Settings 来搭配使用，所以建议最好用合适的前缀来命名。


![](https://cdn-images-1.medium.com/max/800/1*25yr4QF6vBFNK2F1DOh6nw.png)

我这里使用了我名字缩写来作为 User-Defined Settings 的前缀， 但我建议最好用项目名的缩写。

接下来，在你的 `Info.plist` 文件中引用对应的属性值，你可以这样做：

```
$(YOUR_USER_DEFINED_SETTING_NAME)
```

#### 整合全部

真正神奇的地方在于：你可以将 `Info.plist` 中 settings 的所有已经填好的属性值替换为 User-Defined Setting 的对应地址。而你现有的自定义 setting 各需对应一条 User-Defined Setting。

![](https://cdn-images-1.medium.com/max/1000/1*UMNV9ZDKIjr3J3UpWKOIbA.png)

当 `Info.plist` 文件被编译时，它会获取所选配置对应的所有 settings 属性值，而这些属性值也会在编译时对应到每个 settings 上。

现在，你就可以在你的代码里随时随地 *优雅* 地获取到这些 settings 的属性值：

```
if Settings.shared.isOfflineAccessEnabled {
    // do stuff
}
```

最后，在 Xcode 中选择所需的编译配置就非常简单了：

![](https://cdn-images-1.medium.com/max/800/1*D5Z2ipWESxi1MW5s0xvmMw.png)

或者在 CLI 中:

![](https://cdn-images-1.medium.com/max/800/1*MHK2NWnxjk0rPY4mFuzAZQ.png)

### 总结

采用这套方案，我们会获得这些好处：

* 有组织地构建工作流程。
* 有组织地管理应用程序的自定义设置。
* 根据配置灵活改变设置。
* 轻松持续集成（在命令行工具中，选择要编译的配置很容易实现）。

然而，这个方案也有些值得警惕的地方：

* 在运行时不能灵活地更改设置，因为设置在编译时就被打包到版本内了。
* 在配置之间切换时体验并不是很好：每次更改配置后，Xcode 都会重新创建一个版本，也就是说你必须等待整个项目重新编译。
* 只能在 `.xcodeproj` 中修改这些设置的值，而不能在外部 [灵活](https://hackernoon.com/system-settings-9ed72d5ef629)  修改这些设置的值。
* User-Defined Settings [暴露给了所有能够接触到代码的人](https://medium.freecodecamp.org/how-to-securely-store-api-keys-4ff3ea19ebda) , **所以千万不要把任何重要的 key 值放到这里** 。

虽然这些隐患可以一一排除，但是，这个方案的初衷只是为了从这片几乎空白的领域摸索出这些工具更好的使用方法。解决这些问题就意味着更多更复杂的修改，而且这些已经超出了本文讨论的内容，我不希望这篇文章跑题。但相信我，我们做的已经足够完善了。**在下篇文章里，我们将研究如何处理这些隐患，并让我们的项目变得更加完善...**

待续。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


