> * 原文地址：[Widgets on iOS](https://medium.com/@nrakshith94/widgets-on-ios-e0156a2e7239)
> * 原文作者：[Rakshith N](https://medium.com/@nrakshith94)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/widgets-on-ios.md](https://github.com/xitu/gold-miner/blob/master/article/2020/widgets-on-ios.md)
> * 译者：[zhuzilin](https://github.com/zhuzilin)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)、[zenblo](https://github.com/zenblo)

# iOS 中的 widget

苹果最近在 iOS 中支持了 widget（应用小插件）。它们可以让用户在不访问应用程序的情况下获取有限但有用的信息。

![source: [computer world](https://www.computerworld.com/article/3564605/ios-14-how-to-use-widgets-on-ipad-and-iphone.html)](https://cdn-images-1.medium.com/max/2400/1*TRYbj13rl7VonfzuVL46RQ.jpeg)

本文旨在介绍 widget。我们将在本文中广泛探究 WidgetKit SDK，并带你了解构建 widget 所需的组件和流程。
本文需要你已经熟悉 SwiftUI，因为构建 widget 的过程中会大量使用它。由于 widget 自身并不是一个完整的应用程序，因此它不使用应用代理（app delegates）或导航栈（navigation stacks）。此外，widget 不能独立存在，而是需要依赖一个父应用程序。
总而言之，widget 为用户提供了应用信息的快照。操作系统会在你设置的时刻快速触发 widget 以刷新其视图。

#### 使用要求

首先，在开发 widget 之前，你需要满足以下条件：

1. Mac OS 10.15.5 或更高版本。
2. Xcode 12 或更高版本，Xcode 12 的[链接](https://developer.apple.com/download/more/)（如果不能从应用商店更新的话可以使用这个链接，不能直接更新的原因一般是磁盘空间不足）

## 基本配置

如前文所述，widget 必须依赖于一个父应用程序。所以，让我们先来创建一个单页面应用。
对于生命周期选项，我选择了 SwiftUI，这将使用 @main 属性来确定代码入口。
完成构建应用后，我们现在需要添加一个 widget 扩展 以存放 widget 的代码。

> **Select File -> New -> Target -> Widget extension.**

![](https://cdn-images-1.medium.com/max/2940/1*a-KEHHxPtDKzcIIS1rVcGQ.png)

给 widget 设定一个名字，取消选中 ‘**Include Configuration Intent**’，取消选中的原因我们之后会讲到。

![](https://cdn-images-1.medium.com/max/2924/1*RBapNhpn2b858rtzyCNd5Q.png)

接下来点击完成，你将看到一个弹出窗口，要求你激活 widget extension scheme。点击激活后，设置就完成了。

![](https://cdn-images-1.medium.com/max/2000/1*ynPcdI0jU-bWjNmypreylA.png)

现在，选择 widget 扩展下的 swift 文件，你会发现 Xcode 已经生成了代码的骨架。让我们来了解一下骨架的各个部分。
首先看 Widget 类型的结构体，它将是你在安装过程中输入的 widget 文件的名称。此结构体前有 ‘@main’ 属性，表明这里是 widget 的入口。让我们更细致地了解一下各个配置属性。

```Swift
       StaticConfiguration(kind: kind, provider: Provider()) { entry in
           Static_WidgetEntryView(entry: entry)
               .frame(maxWidth: .infinity, maxHeight: .infinity)
               .background(Color.black)
       }
       .configurationDisplayName("My Widget")
       .description("This is an example widget.")
```

**Kind：**这是小部件的标识符，可用于执行更新或进行查询。
**Provider：**此值的类型为 **“TimelineProvider”**，它是 widget 的数据来源，负责确定在不同时间点需要显示哪些数据。
**Content：**这是将显示给用户的 SwiftUI 视图。

注意，WidgetConfiguration 会返回一个 StaticConfiguration 实例。实际上存在两类 widget 配置，静态配置和 intent 配置。intent 配置让用户可以在运行时设置 widget。在我们现在的配置（也就是静态配置）中，widget 显示的是静态数据，也就是说，用户无法在运行时更改 widget 上显示的数据。

接下来，让我们谈谈 **‘SimpleEntry’**。它的类型是 **‘TimelineEntry’** ，主要负责 widget 的数据模型。在我们的样例中，只用了一个日期参数，你可以根据需要添加其他值。例如，如果需要依照一些条件向用户显示文本，则可以在此处添加文本参数。在这个结构体中，你需要实现日期参数，用于为 OS 提供不同的数据时间戳（译者注：让 OS 知道什么时间使用这条数据）。

接下来是 widget 的内容，**‘Static_WidgetEntryView’** 是你发挥自己的创造力的地方。不过要牢记，widget 的尺寸是有一定限制的。

![image source: [https://withintent.com/blog/do-i-need-ios-widgets-for-my-mobile-app/](https://withintent.com/blog/do-i-need-ios-widgets-for-my-mobile-app/)](https://cdn-images-1.medium.com/max/4000/1*1_zg9sp_4LG7V5HM8UMTyA.png)

#### 支持不同尺寸的 widget

WidgetKit 支持小、中、大三种尺寸。
在 widget 启动时可以使用 **‘supportedFamilies’** 选项来确定你打算支持的尺寸，默认情况下，所有尺寸都会被启用。

```
supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
```

鉴于用户可以自由选择 widget 的三种尺寸，我们需要为 widget 的每种尺寸都设计最合适的 UI。在 View 文件中，我们需要能够确定用户选择了哪个尺寸，并根据他们的选择更改 UI。为此，widget kit 提供了返回用户选中的 widget 尺寸的环境变量，我们可以基于它来设置 UI。

```Swift
struct Static_WidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {

        switch family {
        case .systemSmall:
            ViewForSystemSmall(entry: entry)
        case .systemMedium:
            ViewForSystemMedium(entry: entry)
        case .systemLarge:
            ViewForSystemLarge(entry: entry)
        @unknown default:
            fatalError()
        }
    }
}
```

#### 时间线 Provider

构建我们的 widget 的最后一块拼图是 Provider。Provider 的类型为 **‘TimelineProvider’**，这个类型实现了三个方法

```Swift
func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ())
func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ())
func placeholder(in context: Context) -> SimpleEntry
```

这三个方法中，一个（`placeholder`）用于给 widget 提供占位符，一个（`getSnapshot`）用于提供快照，剩下的一个（`getTimeline`）用于返回当前时间线。

**快照**是 OS 在需要尽快返回视图，而无需加载任何数据或进行网络通信的时候使用的。widget gallery 就会使用快照，让用户可以在把 widget 添加到主屏幕之前进行预览。理想的快照是 widget 的模拟视图（mocked view）。

**getTimeline函数** 用于告诉 widget 在不同时间需要显示什么内容。**时间线** 基本上是遵从 **TimelineEntry** 协议的对象的数组。例如，如果你想做一个显示特定事件的倒计时天数的 widget，你就需要创建从现在到那个事件发生日的一系列视图。

![source: wwdc video](https://cdn-images-1.medium.com/max/5760/1*kgxFM7tdR4AZYHjVmWqHYw.png)

这也是你可以进行异步网络通信的地方。小部件可以通过网络通信或者主机应用程序共享的容器来获取数据。这些通信调用完成后，widget 将显示获取到的数据。

**时间线重载策略**
OS 使用 ‘TimelineReloadPolicy’（时间线重载策略）来确定何时需要更新 widget 到下一组视图。
“**.atEnd**” 重载策略下 OS 会在没有更多时间线条目（entries）的时候重新加载新的条目。我在示例代码中创建了一个以1分钟为间隔的时间线，并添加了五个视图条目。这样，widget 会在每分钟都更新显示为相应的时间。5分钟后，系统将调用 “**getTimeline**” 方法来获取下一组视图。
TimelineReloadPolicy 还提供诸如 “**after(date)**” 和 “**never**” 之类的选项，前者会在指定时间更新时间线，后者则是设置完全不更新时间线。

```Swift
struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // 条目之间间隔1分钟
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
```

运行项目，并在主屏幕上长按并单击左上角的 “+”。从选项中选中你的 widget 应用，并选择要添加的 widget 样式，并点击 “Add Widget”。这时，你应该可以看到 widget 显示着当前时间。
## Widget 的动态配置

到目前为止，我们的 widget 基本是静态的，用户无法与它交互，也无法在运行时决定 widget 显示的内容。使用 Intent 配置，我们将能够使我们的 widget 动态化。
在我们最初的项目设置中，取消选中了 “**Include Configuration Intent**” 选项来让 widget 可自定义，现在让我们看看如何使 widget 更具交互性。

在本次演示中，我们将实现一个 widget，它的功能是可以让用户从一个有关城市的列表中进行选择。

## 设置自定义 intent

1）我们需要创建一个自定义的 intent definition，为此我们将使用 **SiriKit Intent Definition**。单击 File 菜单选项，选择 New File 选项，然后继续选择 “SiriKit Intent Definition”。给它取个名字，例如我将它命名为了 CityNamesIntent。

![](https://cdn-images-1.medium.com/max/4668/1*ABRRWfIFJfgSV5BgWhnD5w.png)

2）选择新创建的 intent 文件，我们现在需要添加一个新的 Intent。为此，请点击左下角的“+”图标，选择 **New Intent**，并命名为 CityNames。接下来，在右侧的 **Custom Intent** 下，将类别设置为 **View**，并确保选中了 **Intent is eligible for widgets**。

![](https://cdn-images-1.medium.com/max/4664/1*1AezXCgg9qByWSpko1NOKA.png)

3）添加新的 intent 后，我们需要定义 intent 将处理的属性。对于这个例子来说，一个简单的城市名的枚举就足够了。再次点击“+”图标，然后选择 **New Enum**。单击新创建的枚举来设置它的属性。在 **Cases section** 中，单击“+”图标以向枚举中添加值，就如图中我添加的城市名。

4）最后，回到我们创建的 CityName intent，在参数部分，单击底部的“+”图标并添加一个新参数，并命名为 cities。提供适当的显示名称，然后在 **type** 下选择我们刚刚创建的 CityNamesEnum。

我们的自定义 intent definition 就完成了。下一步我们需要让我们的 widget 可以访问到这个 intent。为此，需要在 **Project Targets** 中的 **Supported Intents** 里选择我们创建的 intent。

现在，我们需要将 widget 从静态配置更新为 Intent 配置。
为此，让我们创建一个新的 Provider 实例。创建类型为 **IntentTimelineProvider** 的 “ConfigurableProvider”，并沿用了和 TimelineProvider 相同的三个函数，注意，参数中添加了 **configuration**，这个新参数的类型就是我们前文定义的 CityNamesIntent。
这个新的配置参数可以用于获取用户选择的值，并相应地更新或修改时间线。

```Swift
struct ConfigurableProvider: IntentTimelineProvider {

    typealias Entry = SimpleEntry

    typealias Intent = CityNamesIntent

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: CityNamesIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: CityNamesIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
```

我们要做的最后一件事是将小部件的定义从 StaticConfiguration 更新为 IntentConfiguration。
在 **Static_Widget** 的定义部分中，把 StaticConfiguration 替换为 IntentConfiguration。它需要一个 intent 实例，把 **CityNameIntent** 传给它。对于 Provider，请使用我们创建的 **ConfigurableProvider**。其余的保持不变。

```Swift
@main
struct Static_Widget: Widget {
    let kind: String = "Static_Widget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: CityNamesIntent.self,
                            provider: ConfigurableProvider(),
                            content: { entry in
                                Static_WidgetEntryView(entry: entry)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.black)
                            })
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
```

到这里，用户就可以配置我们的 widget 了。运行应用，长按 widget 并选择 “Edit Widget”，你将看到一个我们提供的城市名称列表。
进行任何选择后，你可以在 Provider 中获取选定值，并相应地更改视图。

![](https://cdn-images-1.medium.com/max/2000/1*iLhD0gNJKOIsZ5ICLtQ5lQ.png)

本文到这里就结束了，希望你学会了 widget 的基础知识。widget 提供给用户了一种新的使用应用的方式，并为应用带来了更大的可能性。我强烈建议你继续探索 widget 的其他用法，例如 deep linking。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
