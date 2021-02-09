> * 原文地址：[The Ultimate Guide to the SwiftUI 2 Application Life Cycle](https://peterfriese.dev/ultimate-guide-to-swiftui2-application-lifecycle/)
> * 原文作者：[Peter Friese](https://peterfriese.dev/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/ultimate-guide-to-swiftui2-application-lifecycle.md](https://github.com/xitu/gold-miner/blob/master/article/2021/ultimate-guide-to-swiftui2-application-lifecycle.md)
> * 译者：[zhuzilin](https://github.com/zhuzilin)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[zenblo](https://github.com/zenblo)

![Image based on [Rocket](https://thenounproject.com/kavya261990/collection/space/?i=3437783) by [Icongeek26](https://thenounproject.com/kavya261990) on [The Noun Project](https://thenounproject.com/)](https://cdn-images-1.medium.com/max/2880/1*nhb0C-BMierO2SW0bvtKqA.png)

# SwiftUI 2 应用生命周期的终极指导

在很长一段时间里，iOS 开发者们都是使用 `AppDelegate` 作为应用的主要入口。随着 SwiftUI 2 在 WWDC 2020 上发布，苹果公司引入了一个新的应用生命周期。新的生命周期几乎（几乎）完全与 `AppDelegate` 无关，为类 DSL 方法铺平了道路。

在本文中，我会讨论引入新的生命周期的原因，以及你该如何在已有的应用或新的应用中使用它。

## 指定应用入口

我们的第一个问题是，该如何告诉编译器哪里是应用的入口呢？[SE-0281](https://github.com/apple/swift-evolution/blob/master/proposals/0281-main-attribute.md) 详述了**基于类型的程序入口（Type-Based Program Entry Points）**的工作方式：

> Swift 编译器将识别标注了 `@main` 属性的类型为程序的入口。标有 `@main` 的类型有一个隐式要求：类型内部需要声明一个静态 `main()` 方法。

创建新的 SwiftUI 应用时，应用的主类（main class）如下所示：

```swift
import SwiftUI

@main
struct SwiftUIAppLifeCycleApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
```

那么 SE-0281 提到的静态 `main()` 函数在哪儿呢？

实际上，框架可以（并且应该）为用户提供方便的默认实现。你会从上面的代码片段注意到 `SwiftUIAppLifeCycleApp` 遵循 `App` 协议。对于 `App` 协议，苹果提供了如下协议扩展：

```swift
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension App {

    /// 初始化并运行应用。
    ///
    /// 如果你在你的 ``SwiftUI/App`` 的实现类（conformer）的声明前加上了
    /// [@main](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html#ID626)
    /// 属性，系统会调用这个实现类的 `main()` 方法来启动应用。
    /// SwiftUI 提供了该方法的默认实现，从而能以适合平台的方式处理应用启动流程。
    public static func main()
}
```

这下你就懂了吧 —— 这个协议扩展提供了处理应用启动的默认的实现。

由于 SwiftUI 框架不是开源的，所以我们看不到苹果是如何实现此功能的，但是 [Swift Argument Parser](https://github.com/apple/swift-argument-parser) 是开源的，并且也用了这个办法。查看 `ParsableCommand` 的源码，就能了解它是如何用协议扩展来提供静态 `main` 函数的默认实现，并将其用作程序入口的：

```swift
extension ParsableCommand {
...
  public static func main(_ arguments: [String]?) {
    do {
      var command = try parseAsRoot(arguments)
      try command.run()
    } catch {
      exit(withError: error)
    }
  }

  public static func main() {
    self.main(nil)
  }
}
```

如果上述这些听起来有点复杂，好消息是实际上在创建新的 SwiftUI 应用程序时你不必关心它：只需确保在 **Life Cycle** 下拉菜单中选择 **SwiftUI App** 来创建你的应用程序就行了：

![**创建一个新的 SwiftUI 项目**](https://cdn-images-1.medium.com/max/2000/0*XWa5RgMK2WllmlHk.png)

让我们来看一些常见的情况。

## 初始化资源 / 你最喜欢的 SDK 或框架

大多数应用程序需要在启动时执行这些步骤：获取一些配置值，连接数据库或者初始化框架或第三方 SDK。

通常，您可以在 `ApplicationDelegate` 的 `application(_:didFinishLaunchingWithOptions:)` 方法中进行这些操作。由于已经没有应用委托了，我们需要找到其他方法来初始化我们的应用程序。根据您的特定需求，有以下策略：

* 为你的主类实现一个构造函数（initializer）（详见[文档](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID205)）
* 为存储属性设置初始值（详见[文档](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID206)）
* 用闭包设置属性的默认值（详见[文档](https://docs.swift.org/swift-book/LanguageGuide/Initialization.html#ID232)）

```swift
@main
struct ColorsApp: App {
  init() {
    print("Colors application is starting up. App initialiser.")
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
}
```

如果上述几种策略都无法满足你的需求，你可能还是需要一个 `AppDelegate`。后文会介绍如果能在应用中加入一个 AppDelegate。

## 处理你的应用的生命周期

了解你的应用程序处于哪种状态有时很有用。例如，你可能希望应用处于活动状态时立即获取新数据，或者在应用程序变为非活动状态并转换到后台后清除所有缓存。

通常，您可以在你的 `ApplicationDelegate` 上实现 `applicationDidBecomeActive`，`applicationWillResignActive` 或 `applicationDidEnterBackground`。

从 iOS 14.0 起，苹果提供了新的 API，该 API 允许以更优雅，更易维护的方式跟踪应用程序状态：`[ScenePhase](https://developer.apple.com/documentation/swiftui/scenephase)`。你的项目可以有多个场景（scene），不过有时只有一个场景。这些场景将由 `[WindowGroup](https://developer.apple.com/documentation/swiftui/windowgroup)` 展示。

SwiftUI 追踪环境中场景的状态，你可以使用 `@Environment` 属性包装器来获取 `scenePhase` 的值，然后使用 `onChange(of:)` modifier 来监听该值的变化：

```swift
@main
struct SwiftUIAppLifeCycleApp: App {
  @Environment(\.scenePhase) var scenePhase
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .onChange(of: scenePhase) { newScenePhase in
      switch newScenePhase {
      case .active:
        print("App is active")
      case .inactive:
        print("App is inactive")
      case .background:
        print("App is in background")
      @unknown default:
        print("Oh - interesting: I received an unexpected new value.")
      }
    }
  }
}
```

值得注意的是，你可以从应用中的其他位置读取该值。当在应用的顶层读取该值时（如上面的代码片段所示），你将获得应用程序中所有阶段（phase）的汇总。`.inactive` 表示你应用中的所有场景均未激活。当在视图中读取 `scenePhase` 时，你将收到包含该视图的阶段值。请记住，你的应用程序在在同一时刻可能包含在不同阶段的多个场景。想了解有关场景阶段的更多详细信息，请阅读苹果的[文档]（https://developer.apple.com/documentation/swiftui/scenephase）。

## 处理深层链接（Deeplink）

之前，在处理深层链接时，你需要实现 `application(_:open:options:)`，并将传入的 URL 转给最合适的处理程序。

新的应用生命周期模型可以更容易地处理深层链接。在最顶层的场景上添加 `onOpenURL` 就可以处理传入的 URL 了：

```swift
@main
struct SwiftUIAppLifeCycleApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .onOpenURL { url in
          print("Received URL: \(url)")
        }
    }
  }
}
```

真正酷的是：你可以在整个应用程序中装上多个 URL 处理程序 —— 让进行深层链接变得很轻松，因为你可以在最合适的位置处理传入的链接。

可能的话，你应该使用 [universal links](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content)（或者 [Firebase Dynamic Links](https://firebase.google.com/docs/dynamic-links)，它使用了 [universal links for iOS apps](https://firebase.google.com/docs/dynamic-links/operating-system-integrations)），因为它们使用了关联域（associated domain）来创建网站和你的应用之间的链接 —— 这会让你可以安全地共享数据。

不过，你仍可以使用[自定义 URL scheme](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app) 来链接应用内部的内容。

无论哪种方式，触发应用中的深层链接的一种简单方法是在开发计算机上使用以下命令：

```bash
xcrun simctl openurl booted <your url>
```

![Demo: Opening deep links and continuing user activities](https://cdn-images-1.medium.com/max/2000/1*RMYt_zbKht6oqYJdTn9S_w.gif)

## 继续用户 activity

如果你的应用使用 `NSUserActivity` 来[集成](https://developer.apple.com/documentation/foundation/nsuseractivity) Siri、Handoff 或 Spotlight，你需要处理用户继续进行的 activity。

同样，新的应用生命周期模型通过提供两个 modifier 使你更容易实现这一点。这些 modifier 使你可以声明 activity 并让用户可以继续进行它们。

下面是一个展现如何声明 activity 的代码片段。在一个具体的视图里：

```swift
struct ColorDetailsView: View {
  var color: String
  
  var body: some View {
    Image(color)
      // ...
      .userActivity("showColor") { activity in
        activity.title = color
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        // ...
      }
  }
}
```

为了允许继续进行这个 activity，你可以在最顶层的导航视图中注册 `onContinueUserActivity` 闭包，如下所示：

```swift
import SwiftUI

struct ContentView: View {
  var colors = ["Red", "Green", "Yellow", "Blue", "Pink", "Purple"]
  
  @State var selectedColor: String? = nil
  
  var body: some View {
    NavigationView {
      ScrollView {
        LazyVGrid(columns: columns) {
          ForEach(colors, id: \.self) { color in
            NavigationLink(destination: ColorDetailsView(color: color),
                           tag: color,
                           selection: $selectedColor) {
              Image(color)
            }
          }
        }
        .onContinueUserActivity("showColor") { userActivity in
          if let color = userActivity.userInfo?["colorName"] as? String {
            selectedColor = color
          }
        }
      }
    }
  }
}
```

## 请帮帮我 —— 上述的那些对我都不管用！

新的应用声明周期（截止当前）并非支持 `AppDelegate` 的所有回调函数。如果上述这些都不满足你的需求，你可能还是需要一个 `AppDelegate`。

另一个需要 AppDelegate 的原因是你使用的第三方 SDK 会使用 [method swizzling](https://pspdfkit.com/blog/2019/swizzling-in-swift/) 来把它们注入应用生命周期。[Firebase](https://firebase.google.com/) 就是一个[典型的例子](https://stackoverflow.com/a/62633158/281221)。

为了帮助上述情况中的你摆脱困境，Swift 提供了一种将 `AppDelegate` 的一个实现类与你的 `App` 实现相连接的方法：`@UIApplicationDelegateAdaptor`。使用方法如下：

```swift
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    print("Colors application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
    return true
  }
}

@main
struct ColorsApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
```

如果你是在复制现有的 `AppDelegate` 实现，不要忘记删除 `@main` 属性 —— 不然，编译器该向你抱怨存在多个应用入口了。

## 总结

至此，让我们讨论一下苹果为什么要进行这些改变。我觉得有以下的几个原因：

[SE-0281](https://github.com/apple/swift-evolution/blob/master/proposals/0281-main-attribute.md#motivation) explicitly states that one of the design goals was **“to offer a more general purpose and lightweight mechanism for delegating a program’s entry point to a designated type.”**

苹果选择的基于 DSL 来处理应用生命周期的方法和 SwiftUI 的声明式 UI 搭建方法相契合。两者采用相同的概念可以更方便新加入的开发者们理解。

声明式方法的主要好处是：框架/平台将替代开发者承受实现特定功能的负担。如果需要进行任何更改，这种模式可以在不破坏许多开发人员的应用的情况下进行发布，这也使发布更改变得更容易 —— 理想情况下，开发人员无需更改其实现，因为框架将把一切都搞定。

总体而言，新的应用生命周期模型使实现应用程序的启动更加简单。你的代码将变得更加简洁，更易于维护 —— 要我说，这总是一件好事。

我希望本文能帮你了解新的应用生命周期的来龙去脉。如果你有关于本文的任何疑问或评论，欢迎[在 Twitter 上关注](https://twitter.com/peterfriese)并私信我，或者在 [GitHub 上的样例项目](https://github.com/peterfriese/Colors)中提 issue。

感谢你的阅读！

## 扩展阅读

想了解更多，请查看下面的这些资料：

* [Swift Evolution SE-0281 - @main: Type-Based Program Entry Points](https://github.com/apple/swift-evolution/blob/master/proposals/0281-main-attribute.md)
* [The App Protocol](https://developer.apple.com/documentation/swiftui/app)
* [Allowing Apps and Websites to Link to Your Content](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
