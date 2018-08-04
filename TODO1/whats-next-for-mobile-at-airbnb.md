> * 原文地址：[What’s Next for Mobile at Airbnb:: Bringing the best back to native](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)
> * 原文作者：[]()
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-next-for-mobile-at-airbnb.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-next-for-mobile-at-airbnb.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[DateBro](https://github.com/DateBro)

# Airbnb 移动端路在何方？

## 发挥原生最大的潜力

![](https://cdn-images-1.medium.com/max/2000/1*_N3sz8fhNFU5tB5YTVfGHg.jpeg)

**这是[系列博客文章](https://juejin.im/post/5b2c924ff265da59a401f050)中的第五篇，本文将会概述使用 React Native 的经验，以及 Airbnb 移动端接下来要做的事情。**

### 激动人心的时刻即将来临

即使当初在尝试使用 React Native 时，我们也同时加快了原生的开发。今天，我们在生产环境或正在进行中的项目方面，有许多令人激动的计划。其中一些项目的灵感，来自我们使用 React Native 的最佳部分和经验。

#### 服务器驱动渲染

即使我们已不再使用 React Native，但也看到了只编写一次产品代码的价值。我们仍然非常依赖通用设计语言系统（[DLS](https://airbnb.design/building-a-visual-language/)），因为许多页面在 Android 和 iOS 上几乎一模一样。

几个团队已经尝试开始在强大的服务器驱动的渲染框架上达成一致。使用这些框架，服务器将数据发送到设备，描述需要渲染的组件，页面配置以及可能发生的操作。然后，每个移动平台都会对这些数据进行解析，并使用 DLS 组件渲染原生页面，甚至是整个流程。

服务器驱动的大规模渲染还有很多难题。下面是我们正在解决的几个问题：

*   在保持向下兼容性的同时，需要安全地更新组件定义。
*   跨平台共享组件的类型定义。
*   在运行时响应事件，如按钮点击或用户输入。
*   在保留内部状态的同时，在多个 JSON 驱动的屏幕之间进行过渡。
*   在构建时渲染完全没有现有实现的自定义组件。我们正在试验 [Lona](https://github.com/airbnb/Lona/) 格式。

服务器驱动的渲染框架已经提供了巨大的价值，我们可以即时实验和更新功能。

#### Epoxy 组件

2016 年，我们开源了 Android 的 [Epoxy](https://github.com/airbnb/epoxy)。Epoxy 是一个框架，可以实现简单的异构 RecyclerView、UICollectionView 和 UITableView。今天，大多数新页面都采用了 Epoxy。这可以让我们将每个页面拆分为独立的组件，实现延迟渲染。现今，我们在 Android 和 iOS 上都有用 Epoxy。

在 iOS 上大概长这个样子：

```
BasicRow.epoxyModel(
  content: BasicRow.Content(
    titleText: "Settings",
    subtitleText: "Optional subtitle"),
  style: .standard,
  dataID: "settings",
  selectionHandler: { [weak self] _, _, _ in
    self?.navigate(to: .settings)
  })
```

在 Android 上，我们利用使用 [Kotlin 编写 DSL](https://kotlinlang.org/docs/reference/type-safe-builders.html)，使编写组件更加简单和类型安全：

```
basicRow {
 id("settings")
 title(R.string.settings)
 subtitleText(R.string.settings_subtitle)
 onClickListener { navigateTo(SETTINGS) }
}
```

#### Epoxy Diffing

在 React 中，利用 [render](https://reactjs.org/tutorial/tutorial.html#what-is-react) 可返回一个组件列表。React 性能的关键在于，这些组件只表示你要渲染的实际视图/HTML 的数据模型。然后对组件树进行扩展，只渲染更改的部分。我们为 Epoxy 建立了一个类似的概念。在 Epoxy 中，你可以在 [buildModel](https://reactjs.org/tutorial/tutorial.html#what-is-react) 中为整个页面声明模型。与优雅的 Kotlin 和 DSL 搭配使用，在概念上与 React 非常相似，看起来像这样：

```
override fun EpoxyController.buildModels() {
  header {
    id("marquee")
    title(R.string.edit_profile)
  }
  inputRow {
    id("first name")
    title(R.string.first_name)
    text(firstName)
    onChange { 
      firstName = it 
      requestModelBuild()
    }
  }
  // Put the rest of your models here...
}
```

每当数据发生变化时，你都要调用 `requestModelBuild()`，这个方法会重新渲染你的页面，并调用最佳的 RecyclerView。

在 iOS 上大概长这个样子：

```
override func itemModel(forDataID dataID: DemoDataID) -> EpoxyableModel? {
  switch dataID {
  case .header:
    return DocumentMarquee.epoxyModel(
      content: DocumentMarquee.Content(titleText: "Edit Profile"),
      style: .standard,
      dataID: DemoDataID.header)
  case .inputRow:
    return InputRow.epoxyModel(
      content: InputRow.Content(
        titleText: "First name",
        inputText: firstName)
      style: .standard,
      dataID: DemoDataID.inputRow,
      behaviorSetter: { [weak self] view, content, dataID in
        view.textDidChangeBlock = { _, inputText in
          self?.firstName = inputText
          self?.rebuildItemModel(forDataID: .inputRow)
        }
      })
  }
}
```

#### 一个新的 Android 产品架构（MvRx）

最近令人非常激动的进展之一是，我们正在开发新架构，内部称之为 MvRx。 MvRx 结合了 Epoxy、[Jetpack](https://developer.android.com/jetpack/)、[RxJava](https://github.com/ReactiveX/RxJava) 的优点，以及 Kotlin 与 React 的许多原理，构建出的新页面比以往任何时候都更容易、更流畅。它是一个固执己见而又灵活的框架，通过采用我们观察到的共同开发模式以及 React 的最佳部分而开发出来的。同时它也是线程安全的，几乎所有事情都从主线程运行，这使得滚动和动画都能变得非常流畅。

到目前为止，它已经在各种页面上正常工作了，并且几乎不用去处理生命周期。我们目前正在针对一系列 Android 产品进行试用，如果它能继续取得成功，我们会计划开源。这是创建发出网络请求的功能页面所需的完整代码：

```
data class SimpleDemoState(val listing: Async<Listing> = Uninitialized)

class SimpleDemoViewModel(override val initialState: SimpleDemoState) : MvRxViewModel<SimpleDemoState>() {
    init {
        fetchListing()
    }

    private fun fetchListing() {
        // This automatically fires off a request and maps its response to Async<Listing>
        // which is a sealed class and can be: Unitialized, Loading, Success, and Fail.
        // No need for separate success and failure handlers!
        // This request is also lifecycle-aware. It will survive configuration changes and
        // will never be delivered after onStop.
        ListingRequest.forListingId(12345L).execute { copy(listing = it) }
    }
}

class SimpleDemoFragment : MvRxFragment() {
    // This will automatically subscribe to the ViewModel state and rebuild the epoxy models
    // any time anything changes. Similar to how React's render method runs for every change of
    // props or state.
    private val viewModel by fragmentViewModel(SimpleDemoViewModel::class)

    override fun EpoxyController.buildModels() {
        val (state) = withState(viewModel)
        if (state.listing is Loading) {
            loader()
            return
        }
        // These Epoxy models are not the views themself so calling buildModels is cheap. RecyclerView
        // diffing will be automaticaly done and only the models that changed will re-render.
        documentMarquee {
            title(state.listing().name)
        }
        // Put the rest of your Epoxy models here...
    }

    override fun EpoxyController.buildFooter() = fixedActionFooter {
        val (state) = withState(viewModel)
        buttonLoading(state is Loading)
        buttonText(state.listing().price)
        buttonOnClickListener { _ -> }
    }
}
```

MvRx 的架构比较简单，主要用于处理 Fragment 参数，跨进程重启的 savedInstanceState 持久性，TTI 跟踪以及其他一些功能。

我们还在开发一个类似的 iOS 框架，该框架正在进行早期测试。

预计很快会听到更多这方面的消息，我们对迄今取得的进展感到兴奋。

#### 迭代速度

当从 React Native 切换回原生时，马上显现出来的问题就是迭代速度。从一个在一或两秒就能可靠地测试更改部分的平台，到一个可能需要等待 15 分钟的平台，根本无法接受。幸好，我们也找到了一些补救措施。

我们在 Android 和 iOS 上构建了基础架构，可以只编译包含启动器的应用中的一部分，并且可以依赖于特定的功能模块。

在 Android 上，这里使用了 [gradle product flavors](https://developer.android.com/studio/build/build-variants#product-flavors)。我们的 gradle 模块看起来像这样：

![](https://cdn-images-1.medium.com/max/1600/1*KVrbsdwESyfbtKFeh2acXg.png)

这种新的间接层，使得工程师们能够在应用的一小部分上进行构建和开发。与 [IntelliJ 的卸载模块](https://blog.jetbrains.com/idea/2017/06/intellij-idea-2017-2-eap-introduces-unloaded-modules/)配合使用，大大提高了 MacBook Pro 上的构建时间和 IDE 性能。

我们编写了脚本来创建新的测试 flavor，在短短几个月内，我们已经创建了 20 多个。使用这些新的 flavor 开发版本平均要快 2.5 倍，花费 5 分钟以上的构建时间百分比下降了 15 倍。

作为参考，这是 [gradle 代码段](https://gist.github.com/gpeal/d68e4fc1357ef9d126f25afd9ab4eee2)，可用于动态生成具有根依赖性模块的 product flavor。

同样，在 iOS 上，我们的模块如下所示：

![](https://cdn-images-1.medium.com/max/1600/1*AVB7em_JCmj-JmjTCkLdQw.png)

相同系统的构建速度可提高 3-8 倍

### 结论

很高兴能够成为一家不怕尝试新技术，同时又努力保持高质量、高速度和良好开发体验的公司。最后，React Native 是一个发行新功能的重要工具，它为我们提供了新的移动开发思路。如果你想参与其中，[请告诉我们](https://www.airbnb.com/careers/departments/engineering)！

* * *

这是系列博客文章的第五部分，重点讲述了我们使用 React Native 的经验，以及 Airbnb 移动端接下来要做的事情。

*   [第一部分：Airbnb 中的 React Native](https://juejin.im/post/5b2c924ff265da59a401f050)
*   [第二部分：技术细节](https://juejin.im/post/5b3b40a26fb9a04fab44e797)
*   [第三部分：构建跨平台的移动端团队](https://juejin.im/post/5b446177f265da0f7c4faec8)
*   [第四部分：在 React Native 上作出的决策](https://juejin.im/post/5b447b1e6fb9a04fd3437dad)
*   [**第五部分：移动端接下来的事情**](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-next-for-mobile-at-airbnb.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
