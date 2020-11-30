> * 原文地址：[The missing ☑️: SwiftWebUI](http://www.alwaysrightinstitute.com/swiftwebui/)
> * 原文作者：[The Always Right Institute](http://www.alwaysrightinstitute.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swiftwebui.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swiftwebui.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[iWeslie](https://github.com/iWeslie)，[Pingren](https://github.com/Pingren)

# Web 端的 SwiftUI：SwiftWebUI

这个月初，苹果在 [2019 年 WWDC 大会](https://developer.apple.com/wwdc19/)公布了 [SwiftUI](https://developer.apple.com/xcode/swiftui/)。它是一个独立的“跨平台”、“声明式”框架，可用于构建 tvOS、macOS、watchOS 以及 iOS 的用户界面（UI）。而 [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) 正在将这个框架迁移到 Web 研发✔️。

**免责声明**：SwiftWebUI 只是一个玩具级项目！不要用于生产环境。建议用它来学习 SwiftUI 和它的内部工作原理。

## SwiftWebUI

所以 [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) 到底可以用来做什么？答案是使用 SwiftWebUI，它可以在 web 浏览器内展示你编写的 SwiftUI  [View](https://developer.apple.com/documentation/swiftui/view)。

```swift
import SwiftWebUI

struct MainPage: View {
  @State var counter = 0
  
  func countUp() { counter += 1 }
  
  var body: some View {
    VStack {
      Text("🥑🍞 #\(counter)")
        .padding(.all)
        .background(.green, cornerRadius: 12)
        .foregroundColor(.white)
        .tapAction(self.countUp)
    }
  }
}
```

代码运行的结果是：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoCounter/AvocadoCounter.gif)

和其他一些代码库作出的努力不同，它并不仅仅将 SwiftUI Views 渲染为 HTML。它同时也会在浏览器和 Swift 服务器的代码之间建立一个连接，用来支持用户交互 —— 包括 button、picker、stepper、list、navigation 等等，全部都可以支持。

换句话说：[SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) 是 SwiftUI API 于浏览器的实现（实现了大部分的 API，但不是全部）。

重申一次**免责声明**：SwiftWebUI 只是一个玩具级项目！不要用于生产环境。建议用它来学习 SwiftUI 和它的内部工作原理。

## 一次学习，随处可用

SwiftUI 的核心目标不是“[一次编码，随处可运行](https://en.wikipedia.org/wiki/Write_once,_run_anywhere)”，而是“[一次学习，随处可用](https://developer.apple.com/videos/play/wwdc2019/216)”。不要期待着可以将 iOS 上好看的 SwiftUI 应用直接拿来，把代码拷贝到 SwiftWebUI 项目中然后就可以在浏览器看到一模一样的渲染效果。因为这并不是 SwiftWebUI 的重点。

重点是能够像 [knoff-hoff](https://en.wikipedia.org/wiki/Die_Knoff-Hoff-Show) 一样让开发者模仿 SwiftUI 进行代码实验并看到运行结果，同时还可以跨平台共享。在这个意义上，Web 比较有优势。

现在让我们就开始着手细节，写一个简单的 SwiftWebUI 应用吧。秉承着“一次学习，随处可用”这样的理念，先看看这两个 WWDC 会议记录吧：[SwiftUI 介绍](https://developer.apple.com/videos/play/wwdc2019/204/) 和 [SwiftUI 核心](https://developer.apple.com/videos/play/wwdc2019/216)。虽然在这篇博客中我们不会深入讲解，但是推荐你看看 [SwiftUI 的数据流](https://developer.apple.com/videos/play/wwdc2019/226)（其中的大部分概念也适用于 SwiftWebUI）。

## 需要的准备工作

目前由于 Swift ABI 不兼容，SwiftWebUI 需要 [macOS Catalina](https://www.apple.com/macos/catalina-preview/) 才能运行。幸运的是，[在单独的 APFS 宗卷上安装 Catalina](https://support.apple.com/en-us/HT208891) 很简单。同时还需要安装 [Xcode 11](https://developer.apple.com/xcode/)，这样才能使用最新的 Swift 5.1 特性，这些特性 SwiftUI 将会大量使用。都懂了吗？非常好！

> 如果你使用的是 Linux 系统该怎么办？这个项目已经**即将准备**运行在 Linux 上了，但是工作还并没有完成。目前项目还缺少的部分是一个对 [Combine](https://developer.apple.com/documentation/combine) [PassthroughSubject](https://developer.apple.com/documentation/combine/passthroughsubject) 的简单实现，并且在这个方面，我遇到了一点困难。目前准备好的代码在：[NoCombine](https://github.com/SwiftWebUI/SwiftWebUI/blob/master/Sources/SwiftWebUI/Misc/NoCombine.swift)。欢迎大家为项目提 pull request！

> 如果你使用的是 Mojave 该怎么办？有一个方法可以在 Mojave 和 Xcode 11 上运行项目。你需要创建一个 iOS 13 模拟器项目，然后将整个项目在模拟器中运行。

## 开始构建第一个应用

### 创建 SwiftWebUI 项目

打开 Xcode 11，选择 “File > New > Project…” 或者直接使用快捷键 Cmd-Shift-N：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/1-new-project.png)

选择 “macOS / Command Line Tool” 项目模版：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/2-new-cmdline-tool.png)

给项目起一个合适的名字，我们就用 “AvocadoToast” 吧：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/3-swift-project-name.png)

然后，将 [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) 添加到 Swift 包管理器并导入项目。这个选项在 “File / Swift Packages” 菜单中：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/4-add-pkg-dep.png)

输入 `https://github.com/SwiftWebUI/SwiftWebUI.git` 作为包的 URL 地址：

[![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/5-add-swui-dep.png)](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/5-add-swui-dep-large.png)

“Branch” 设置为 `master` 选项，这样就总可以获取到最新和最优秀的代码（你也可以使用修订版或者使用 `develop` 分支）：

[![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/6-branch-select.png)](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/6-branch-select-large.png)

最后将 `SwiftWebUI` 库加入到目标工具中：

[![](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/7-target-select.png)](http://www.alwaysrightinstitute.com/images/swiftwebui/ProjectSetup/7-target-select-large.png)

这样就可以了。现在你有了一个可以直接 `import SwiftWebUI` 的工具项目了。（Xcode 可能会需要一段时间来获取和构建依赖。）

### 使用 SwiftWebUI 显示 Hello World

我们现在就开始学习使用 SwiftWebUI 吧。打开 `main.swift` 文件然后将内容替换为：

```swift
import SwiftWebUI

SwiftWebUI.serve(Text("Holy Cow!"))
```

将代码进行编译并在 Xcode 中运行应用，打开 Safari 浏览器然后访问 [`http://localhost:1337/`](http://localhost:1337/)：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/HolyCow/holycow.png)

这背后究竟发生了什么事呢：首先 SwiftWebUI 模块被引用进来（请注意不要不小心引用了 macOS SwiftUI 😀）

接下来我们调用 `SwiftWebUI.serve`，它可能会使用返回一个 View 的闭包，或者仅仅是一个 View —— 而如上所示，这里返回的是个 [`Text`](https://developer.apple.com/documentation/swiftui/text) View（又名 “UILabel”，它可以展示出简单的或者格式化的文字）。

#### 幕后原理

[`serve`](https://github.com/SwiftWebUI/SwiftWebUI/blob/master/Sources/SwiftWebUI/ViewHosting/Serve.swift#L66) 函数中创建了一个非常简单的[SwiftNIO](https://github.com/apple/swift-nio) HTTP 服务器，这个服务器会监听端口 1337。当浏览器访问这个服务器的时候，它创建了一个 [session](https://github.com/SwiftWebUI/SwiftWebUI/blob/master/Sources/SwiftWebUI/ViewHosting/NIOHostingSession.swift) 并将我们的 (Text) View 传递给这个 session 了。
最后 SwiftWebUI 在服务器中创建了一个 “Shadow DOM”，将 View 渲染为 HTML 并将结果发送给浏览器。这个 “Shadow DOM”（以及一个会和它绑定在一起的状态对象）会被保存在 session 中。

> SwiftWebUI 应用和 watchOS 或者 iOS 上的 SwiftUI 应用是有区别的。一个 SwiftWebUI 应用可以服务多个用户，而不是像 SwiftUI 应用那样只服务于一个用户。

### 添加一些用户交互

第一步完成后，我们将代码结构优化一下。在项目中创建一个新的 Swift 文件并命名为 `MainPage.swift。并为其添加一个简单的 SwiftUI View 定义：

```swift
import SwiftWebUI

struct MainPage: View {
  
  var body: some View {
    Text("Holy Cow!")
  }
}
```

调整 main.swift，使之可以服务于我们的自定义 View：

```swift
SwiftWebUI.serve(MainPage())
```

现在我们可以先不用去管 `main.swift` 了，可以在我们自定义的 [`View`](https://developer.apple.com/documentation/swiftui/view) 中完成其他的工作。现在我们为它添加一些用户交互的功能：

```swift
struct MainPage: View {
  @State var counter = 3
  
  func countUp() { counter += 1 }
  
  var body: some View {
    Text("Count is: \(counter)")
      .tapAction(self.countUp)
  }
}
```

我们的 [`View`](https://developer.apple.com/documentation/swiftui/view) 有一个名为 `counter` 的 [`State`](https://developer.apple.com/documentation/swiftui/state) 变量（不清楚这是什么？建议你可以看一看 [SwiftUI 介绍](https://developer.apple.com/videos/play/wwdc2019/204/)）。以及一个可以增加 counter 的简单函数。
然后我们使用 SwiftUI 的修饰符 [`tapAction`](https://developer.apple.com/documentation/swiftui/text/3086357-tapaction) 将时间处理函数绑定到我们的 `Text` 上。最后，我们在标签中展示当前的数值：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/HolyCow/ClickCounter.gif)

🧙‍♀️ **简直像魔法一样** 🧙

#### 幕后原理

这一切都是如何运作的呢？当我们点击浏览器后，SwiftWebUI 创建了一个含有 “Shadow DOM” 的 session。接下来它将会把 View 的 HTML 描述发送给浏览器。`tapAction` 通过 HTML 添加的 `onclick` 事件处理可以被调用执行。SwiftWebUI 也可以将 JavaScript 代码传输给浏览器（只能传输少量代码，不可以是大型框架代码！），这部分代码将会处理点击事件，并将事件转发给我们的 Swift 服务器。

然后就轮到 SwiftUI 魔法登场了。SwiftWebUI 让点击事件和我们在 “Shadow DOM” 中的事件处理函数关联在一起，并会调用 `countUp` 函数。通过修改变量 `counter` [`State`](https://developer.apple.com/documentation/swiftui/state)，函数将 View 的渲染设置为无效。此时 SwiftWebUI 开始对比 “Shadow DOM” 中出现的区别和变化。接下来这些改变将会被发回到浏览器中。

> 这些修改将会以 JSON 数组的形式发送，这些数组可以被页面上的 JavaScript 代码片解析。如果 HTML 结构的一个子树的所有内容都改变了（例如，假设用户进入了一个新的 View），那么这个修改就可能是一个比较大的 HTML 代码片，将会被应用于 innerHTML` 或 `outerHTML` 方法。
> 但是通常情况下，修改都比较微小，例如 `add class`，`set HTML attribute` 这样的（即浏览器 DOM 修改）。

## 🥑🍞 Avocado Toast 应用

棒极了，现在我们已经完成了所有基础工作。让我们来加入更多的交互性吧。下面的内容都是基于 “Avocado Toast 应用”的，它在 [SwiftUI 核心](https://developer.apple.com/videos/play/wwdc2019/216)演讲中被用作为 SwiftUI 的范例。你还没有看过它的话，建议你看一看，毕竟它是关于美味烤面包片的（toast 又意为面包片）。

> HTML 和 CSS 样式还不是很完美，也不太美观。而你也知道我们并不是 web 设计师，所以这方面我们需要大家的帮助。欢迎给项目提出 pull request！

如果你想要跳过细节讲解，直接查看应用的动图，可以在 GitHub 上下载：[🥑🍞](#the--finished-app)。

### 🥑🍞应用的 Order Form（表单）

我们从如下这段代码开始吧（它在视频中大约 6 分钟的位置），首先我们将它写入一个新建的 `OrderForm.swift` 文件：

```swift
struct Order {
  var includeSalt            = false
  var includeRedPepperFlakes = false
  var quantity               = 0
}
struct OrderForm: View {
  @State private var order = Order()
  
  func submitOrder() {}
  
  var body: some View {
    VStack {
      Text("Avocado Toast").font(.title)
      
      Toggle(isOn: $order.includeSalt) {
        Text("Include Salt")
      }
      Toggle(isOn: $order.includeRedPepperFlakes) {
        Text("Include Red Pepper Flakes")
      }
      Stepper(value: $order.quantity, in: 1...10) {
        Text("Quantity: \(order.quantity)")
      }
      
      Button(action: submitOrder) {
        Text("Order")
      }
    }
  }
}
```

这可以直接测试 `main.swift` 中的 `SwiftWebUI.serve()` 以及新的 OrderForm` View。

如下是在浏览器展示的效果：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoOrder/orderit.gif)

> [SemanticUI](https://semantic-ui.com) 可用于为 SwiftWebUI 中的一些内容定义样式。对于操作逻辑，它并不是必需的，但是它可以帮助你完成一些看起来不错的小部件。
> 注意：它只用了 CSS/fonts，而没有用 JavaScript 组件。

### 放松一下：认识一些 SwiftUI 布局

在 [SwiftUI 核心](https://developer.apple.com/videos/play/wwdc2019/216)演讲的第 16 分钟左右，他们开始解说 SwiftUI 布局和 View 修饰符顺序：

```swift
var body: some View {
  HStack {
    Text("🥑🍞")
      .background(.green, cornerRadius: 12)
      .padding(.all)
    
    Text(" => ")
    
    Text("🥑🍞")
      .padding(.all)
      .background(.green, cornerRadius: 12)
  }
}
```

结果在这里，注意观察修饰符顺序是如何相互联系的：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoLayout.png)

> SwiftWebUI 在尝试复制一些常用的 SwiftUI 布局，但还并没有完全成功。毕竟这项工作与浏览器的布局系统有关。我们需要帮助，尤其欢迎 flexbox 布局方面的专家！

### 🥑🍞 应用的历史订单

我们接着回到应用的介绍中来，演讲在大约 19 分 50 秒的时候介绍了可以用于展示 Avocado toast 应用历史订单的 [List](https://developer.apple.com/documentation/swiftui/list) View。这是它在 web 端展示的样子：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/OrderHistory/OrderHistory1.png)

`List` View 遍历了包含所有订单的数组，然后为每一项都创建了一个子 View（`OrderCell`），并将列表中每一项订单的信息传入这个 `OrderCell`。

这是我们使用的代码：

```swift
struct OrderHistory: View {
  let previousOrders : [ CompletedOrder ]
  
  var body: some View {
    List(previousOrders) { order in
      OrderCell(order: order)
    }
  }
}

struct OrderCell: View {
  let order : CompletedOrder
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(order.summary)
        Text(order.purchaseDate)
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      Spacer()
      if order.includeSalt {
        SaltIcon()
      }
      else {}
      if order.includeRedPepperFlakes {
        RedPepperFlakesIcon()
      }
      else {}
    }
  }
}

struct SaltIcon: View {
  let body = Text("🧂")
}
struct RedPepperFlakesIcon: View {
  let body = Text("🌶")
}

// Model

struct CompletedOrder: Identifiable {
  var id           : Int
  var summary      : String
  var purchaseDate : String
  var includeSalt            = false
  var includeRedPepperFlakes = false
}
```

> SwiftWebUI List View 的效率极低，它总是渲染出子元素的整个集合。Cell（列表单元格） 完全没有复用 😎。在 web 应用中，有很多不同的方式可以解决这个问题，例如，通过使用分页或者使用更多客户端逻辑。

我们已经为你准备好了演讲中使用的样本数据代码，你不需要再次打字输入了：

```swift
let previousOrders : [ CompletedOrder ] = [
  .init(id:  1, summary: "Rye with Almond Butter",  purchaseDate: "2019-05-30"),
  .init(id:  2, summary: "Multi-Grain with Hummus", purchaseDate: "2019-06-02",
        includeRedPepperFlakes: true),
  .init(id:  3, summary: "Sourdough with Chutney",  purchaseDate: "2019-06-08",
        includeSalt: true, includeRedPepperFlakes: true),
  .init(id:  4, summary: "Rye with Peanut Butter",  purchaseDate: "2019-06-09"),
  .init(id:  5, summary: "Wheat with Tapenade",     purchaseDate: "2019-06-12"),
  .init(id:  6, summary: "Sourdough with Vegemite", purchaseDate: "2019-06-14",
        includeSalt: true),
  .init(id:  7, summary: "Wheat with Féroce",       purchaseDate: "2019-06-31"),
  .init(id:  8, summary: "Rhy with Honey",          purchaseDate: "2019-07-03"),
  .init(id:  9, summary: "Multigrain Toast",        purchaseDate: "2019-07-04",
        includeSalt: true),
  .init(id: 10, summary: "Sourdough with Chutney",  purchaseDate: "2019-07-06")
]
```

### 🥑🍞 应用的 Spread Picker（可展开选择器）

Picker 的控制以及如何与枚举类型一起使用它会在大约 43 分钟的时候讲解。首先我们来看不同 toast 弹窗选项的枚举类型；

```swift
enum AvocadoStyle {
  case sliced, mashed
}

enum BreadType: CaseIterable, Hashable, Identifiable {
  case wheat, white, rhy
  
  var name: String { return "\(self)".capitalized }
}

enum Spread: CaseIterable, Hashable, Identifiable {
  case none, almondButter, peanutButter, honey
  case almou, tapenade, hummus, mayonnaise
  case kyopolou, adjvar, pindjur
  case vegemite, chutney, cannedCheese, feroce
  case kartoffelkase, tartarSauce

  var name: String {
    return "\(self)".map { $0.isUppercase ? " \($0)" : "\($0)" }
           .joined().capitalized
  }
}
```

我们可以将这些都加入我们的 `Order` 结构体：

```swift
struct Order {
  var includeSalt            = false
  var includeRedPepperFlakes = false
  var quantity               = 0
  var avocadoStyle           = AvocadoStyle.sliced
  var spread                 = Spread.none
  var breadType              = BreadType.wheat
}

```

然后使用不同类型的 Picker 来展示它们。你可以非常简便的直接循环遍历枚举类型的所有值：

```swift
Form {
  Section(header: Text("Avocado Toast").font(.title)) {
    Picker(selection: $order.breadType, label: Text("Bread")) {
      ForEach(BreadType.allCases) { breadType in
        Text(breadType.name).tag(breadType)
      }
    }
    .pickerStyle(.radioGroup)
    
    Picker(selection: $order.avocadoStyle, label: Text("Avocado")) {
      Text("Sliced").tag(AvocadoStyle.sliced)
      Text("Mashed").tag(AvocadoStyle.mashed)
    }
    .pickerStyle(.radioGroup)
    
    Picker(selection: $order.spread, label: Text("Spread")) {
      ForEach(Spread.allCases) { spread in
        Text(spread.name).tag(spread) // there is no .name?!
      }
    }
  }
}
```

代码运行的结果：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoOrder/picker.png)

> 再次声明，我们需要一些 CSS 高手来让界面更好看一些…

### 🥑🍞 应用的最终成果

我们和原生的 SwiftUI 界面其实还略有不同，现在也并没有完全的完成它。虽然看上去还不非常完美，但是毕竟已经可以用来演示了 😎

![](http://www.alwaysrightinstitute.com/images/swiftwebui/AvocadoOrder/AvocadoToast.gif)

最终完成的应用代码可以在 GitHub 上查看：[AvocadoToast](https://github.com/SwiftWebUI/AvocadoToast)。

## HTML 和 SemanticUI

[`UIViewRepresentable`](https://developer.apple.com/documentation/swiftui/uiviewrepresentable) 在 SwiftWebUI 中的等价物用于生成原生 HTML 代码。

它提供了两个变量，`HTML` 会按原样输出字符串，或者通过 HTML 转译内容：

```swift
struct MyHTMLView: View {
  var body: some View {
    VStack {
      HTML("<blink>Blinken Lights</blink>")
      HTML("42 > 1337", escape: true)
    }
  }
}
```

使用这种结构，你基本可以构建出任何想要的 HTML。

级别稍微高级一些，但是也被用在 SwiftWebUI 中的是 `HTMLContainer`。例如这是 `Stepper` 控制的实现方法：

```swift
var body: some View {
  HStack {
    HTMLContainer(classes: [ "ui", "icon", "buttons", "small" ]) {
      Button(self.decrement) {
        HTMLContainer("i", classes: [ "minus", "icon" ], body: {EmptyView()})
      }
      Button(self.increment) {
        HTMLContainer("i", classes: [ "plus", "icon" ], body: {EmptyView()})
      }
    }
    label
  }
}
```

`HTMLContainer` 要更加灵活一些，例如，如果元素的 class，样式或者属性变化了，它将会生成一个常规的 DOM 变化（而不是重新渲染所有内容）。

### SemanticUI

SwiftWebUI 也包含了一些 [SemanticUI](https://semantic-ui.com) 控制的预配置：

```swift
VStack {
  SUILabel(Image(systemName: "mail")) { Text("42") }
  HStack {
    SUILabel(Image(...)) { Text("Joe") } ...
  }
  HStack {
    SUILabel(Image(...)) { Text("Joe") } ...
  }
  HStack {
    SUILabel(Image(...), Color("blue"), 
             detail: Text("Friend")) 
    {
      Text("Veronika")
    } ...
  }
}
```

…渲染结果为：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/SemanticUI/labels.png)

> 注意，SwiftWebUI 也支持一些内置图标库（SFSymbols）图像名（使用方法是 Image(systemName:)`）。SemanticUI [对 Font Awesome 的支持](https://semantic-ui.com/elements/icon.html) 是其幕后的技术支持。

同时 SwiftWebUI 还包括`SUISegment`、`SUIFlag` 和 `SUICard`：

```swift
SUICards {
  SUICard(Image.unsplash(size: UXSize(width: 200, height: 200),
                         "Zebra", "Animal"),
          Text("Some Zebra"),
          meta: Text("Roaming the world since 1976"))
  {
    Text("A striped animal.")
  }
  SUICard(Image.unsplash(size: UXSize(width: 200, height: 200),
                         "Cow", "Animal"),
          Text("Some Cow"),
          meta: Text("Milk it"))
  {
    Text("Holy cow!.")
  }
}
```

…其渲染效果为：

![](http://www.alwaysrightinstitute.com/images/swiftwebui/SemanticUI/cards.png)

添加这样的 View 非常轻松愉快。使用 WOComponent 的 SwiftUI Views，每个人都能快速地创作复杂又好看的布局。

> `Image.unsplash` 会根据运行在 `http://source.unsplash.com` 的 API 构建图片请求。只需要传递给它一些请求参数，比如你想要的图片大小和其他的可配置选项。
> 注意：这个 Unsplash 服务有时候会比较慢，有点靠不住。

# 总结

上述所有就是本次的演示内容啦。希望你喜欢！但是重申一次**免责声明**：SwiftWebUI 只是一个玩具级项目！不要用于生产环境。建议用它来学习 SwiftUI 和它的内部工作原理。

但我们认为它是一个很好的入门级试玩项目，也是一个学习 SwiftUI 内部工作原理的很有价值的工具。

## 可选读的技术说明

这里列出了一系列关于技术的不同方面的提示信息。你可以跳过不看，这些内容没那么有趣了 😎

### Issues

我们的项目就有很多的 issue，有一部分在 Github 上：[Issues](https://github.com/SwiftWebUI/SwiftWebUI/issues)。你也可以尝试给我们提更多的 issue。

这里面包括了很多与 HTML 布局相关的内容（例如，`ScrollView` 有时候不会滚动），但同时也有很多开放式的问题，比如关于 Shape 的（如果使用 SVG 或者 CSS，可能会更容易实现）。

还有一个是关于 If-ViewBuilder 无效的问题。目前还不知道是什么原因：

```swift
var body: some View {
  VStack {
    if a > b {
      SomeView()
    }
    // 目前还需要一个空的 else 语句：`else {}` 来使其可以编译。
  }
}
```

我们需要帮助，欢迎为我们提出 pull request！

### 和原生 SwiftUI 的对比

目前我们的实现方法非常简单，也并不高效。正式版必须要处理高频率的状态改变，还要将所有的动画效果都改为 60Hz 的帧率等等。

我们目前主要集中经历于将基础的操作完成，例如，状态和绑定如何运作，View 在何时并以何种方式更新等等。很多时候实现方法都可能会出错，然而 Apple 忘记将原始代码作为 Xcode 11 的一部分发送给我们。

### WebSockets

我们现在使用 AJAX 来连接浏览器和服务器。而其实使用 WebSockets 能够带来更大优势： 

* 能保证事件运行的顺序（AJAX 请求是异步的，返回的顺序不定）
* 不需要用户初始化，而是在服务端更新 DOM（例如 timers，push）
* 可以检测 session 过期

这会让聊天客户端的演示更轻松。

而为项目添加 WebSocket 实际上非常简单，因为目前事件已经是以 JSON 的格式发送了。我们只需要客户端和服务端的 shim 就可以了。这部分内容已经在 [swift-nio-irc-webclient](https://github.com/NozeIO/swift-nio-irc-webclient) 实现，只需要迁移到项目中即可。

### SPA

目前 SwiftWebUI 是一个 SPA（单页应用）项目，和一个支持状态的后端服务绑定。

也有其他方式可以实现 SPA，比如，当用户通过普通链接在应用中的不同页面切换时，保持状态树不变。又称为 WebObjects ;-)

通常情况下，如果你想要对 DOM ID 的生成、链接的生成以及路由等等做更多更全面的控制，这是一个不错的选择。
但是最后，用户可能不得不放弃“一次学习，随处可用”，因为 SwiftUI 的行为处理函数通常是围绕着它们要捕获任意的状态这样的事实构建的。

接下来我们将会看到基于 Swift 的服务端框架做了什么 👽

### WASM

当我们使用了合适的 Swift WASM，所有的代码都能变得更加实用了。来一起学习吧 WASM！

### WebIDs

一些 SwiftUI View，比如 `ForEach`，都需要 `Identifiable` 对象，使用了它那么 `id` 就可以是任意的 `Hashable` 值。但是用于 DOM 的时候，它的性能并不非常好，因为我们需要字符串类型的 ID 来分辨节点。
而通过一个全局的 map 结构将 ID 映射为字符串，它就可以正常工作了。从技术上来说这并不难（就是一个特定的关于类引用的问题）。

总结：对于 web 端的代码，使用字符串或者数字来识别项目是比较明智的选择。

### Form

表单收到了很多人的青睐：[Issue](https://github.com/SwiftWebUI/SwiftWebUI/issues/10)。

SemanticUI 有很多很好的表单布局。我们也许会重写这部分的子树。还有待完善。

## 用于 Swift 的 WebObjects 6

等一下再点击它：

> 为 40s+ 的用户作出的 SwiftUI 的总结。[pic.twitter.com/6cflN0OFon](https://t.co/6cflN0OFon)
> 
> — Helge Heß (@helje5) [2019 年 6 月 7 日](https://twitter.com/helje5/status/1137092138104233987?ref_src=twsrc%5Etfw)

使用 [SwiftUI](https://developer.apple.com/xcode/swiftui/)，Apple 真的给了我们 Swift 模式的 [WebObjects](https://en.wikipedia.org/wiki/WebObjects) 6！

接下来:（让我们期待新时代的） Direct To Web 和 Swift 化的 EOF (即 CoreData 或 ZeeQL)。

## 参考链接

* [SwiftWebUI](https://github.com/SwiftWebUI/SwiftWebUI) on GitHub
* [SwiftUI](https://developer.apple.com/xcode/swiftui/)
    * [Introducing SwiftUI](https://developer.apple.com/videos/play/wwdc2019/204/) (204)
    * [SwiftUI Essentials](https://developer.apple.com/videos/play/wwdc2019/216) (216)
    * [Data Flow Through SwiftUI](https://developer.apple.com/videos/play/wwdc2019/226) (226)
    * [SwiftUI Framework API](https://developer.apple.com/documentation/swiftui)
* [SwiftObjects](http://swiftobjects.org/)
* [SemanticUI](https://semantic-ui.com)
    * [Font Awesome](https://fontawesome.com/)
    * [SemanticUI Swift](https://github.com/SwiftWebResources/SemanticUI-Swift)
* [SwiftNIO](https://github.com/apple/swift-nio)

## 联系我们

嗨，我们希望你喜欢这篇文章，我们也非常欢迎你向我们作出反馈！
反馈可以发送在 Twitter 或者：[@helje5](https://twitter.com/helje5)、[@ar_institute](https://twitter.com/ar_institute) 都可以。
Email 地址为：[wrong@alwaysrightinstitute.com](mailto:wrong@alwaysrightinstitute.com)。
Slack：可以在 SwiftDE、swift-server、noze、ios-developers 找到我们。

写于 2019 年 6 月 30 日

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
