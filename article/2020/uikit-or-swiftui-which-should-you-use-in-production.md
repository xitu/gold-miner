> * 原文地址：[UIKit or SwiftUI: Which Should You Use in Production?](https://medium.com/better-programming/uikit-or-swiftui-which-should-you-use-in-production-f57258bc6ad5)
> * 原文作者：[Alexey Naumov](https://medium.com/@nalexn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/uikit-or-swiftui-which-should-you-use-in-production.md](https://github.com/xitu/gold-miner/blob/master/article/2020/uikit-or-swiftui-which-should-you-use-in-production.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[Zilin Zhu](https://github.com/zhuzilin)、[lsvih](https://github.com/lsvih)

# UIKit 和 SwiftUI：该选择哪一个运用在实际产品开发中？

### SwiftUI 准备好去投入生产运营了吗？

![图自 [Mario Dobelmann](https://unsplash.com/@mariodobelmann?utm_source=medium&utm_medium=referral) 源于 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11516/0*uqSWA_30Auiz_7F4)

Apple 最近发布了 iOS 14 —— 这意味着 Apple 已经给了开发者们一年的缓冲时间来决定是否使用 SwiftUI 了。而且这意味着 SwiftUI 不仅可以被开发爱好者们在其业余的项目中使用，而且它也要被企业团队评估是否能在企业团队所要发布的应用中使用了。

从每个人的评论的字面上看，大家都说编写 SwiftUI 代码很有趣，但是 SwiftUI 究竟是仅仅只能充当一个“玩具”，还是真的可以当作一个专业的工具在实际生产中使用呢？如果我们需要在实际生产中使用 SwiftUI，那我们就需要以对待一个专业工具而非对待玩物的态度，开始着手考虑它的稳定性和灵活性了。

那我们应该在什么时候开始在实际生产的应用的代码中使用 SwiftUI？

如果你准备在 2020 年至 2022 年之间开始一个新的重大项目，这个问题着实很难回答。

SwiftUI 带来了不少创新，但是即使在 iOS 14 上运行使用 SwiftUI 构建的应用，我们[仍然会遇到 bugs，并且 SwiftUI 的在自定义方面的灵活性仍然不足](https://steipete.com/posts/state-of-swiftui/) 。

尽管我们可以有选择地采取 UIKit 来缓解这些问题，但你能否估计有多少代码最终是用 UIKit 写的呢？从长远来看，SwiftUI 有没有可能成为负担，让你觉得不如单纯使用 UIKit 呢？

真要解决这个问题，我们只能打赌到了 iOS 15 的发布前后，SwiftUI 的问题都被解决了。这意味着最快需要到 2022 年（iOS 16 发布的时候），我们才能完全信任 SwiftUI。

在本文中，我将详细介绍如何在如下两种情况下搭建项目：

1. 如果你的应用需要支持 iOS 11 或 iOS 12，但也考虑在未来将应用程序迁移到 SwiftUI。
2. 如果你的应用只用支持 iOS 13+，但希望控制 SwiftUI 库可能会带来的相关的风险，并希望能够同时无缝回退至 UIKit。

## UI 框架具有粘性

从过往的经验上看，UI 框架对于移动应用程序的结构体系有着非常大的影响 —— 在 iOS 开发上，我们使用 UIKit 并围绕它构建了几乎所有其他的代码。

回忆一下你上一个使用了 UIKit 的项目，并尝试评估一下，如果要完全摆脱 UIKit，将其替换为另一个 UI 框架（例如 [AsyncDisplayKit](https://github.com/texturegroup/texture/)）需要耗费多少精力？

—— 对于大多数项目，这可能意味着要完全重写代码。

网络开发者们会嘲笑我们，毕竟他们一向有着各式的 UI 框架。因此，他们早已定下了应用与依赖库之间的原则，并将 UI 仅仅当作程序的其中一小部分，就像具体使用哪种数据库一样，无关紧要。

这是否意味着我们（移动开发人员）没将 UI 与业务逻辑层捆解构开来？可是我们应该做到了啊 —— MVC、MVVM、VIPER 等框架都在帮助着我们。

但我们仍然受困于 UI 库啊。

移动应用很少负责任何核心的业务逻辑 —— 比如说计算贷款利息并批准贷款。每个企业都希望在这里尽量降低各种风险，因此他们会在后端运行这样的逻辑。

但是，现代移动应用程序上仍然有很多业务逻辑。这种逻辑与上面提到的那些逻辑是不同的 —— 它只专注于 UI 的呈现，而不是业务运行的核心逻辑。

这意味着我们需要做得更好 —— 将与 UI 呈现相关的计算与正在使用的 UI 框架解构。

如果我们不这样做，也难怪框架会完全与代码库所捆绑。

---

UIKit 和 SwiftUI 的 API 都粘在了别的非表示层代码中 —— 这些框架鼓励开发人员将它们变成核心，推动将表示层与其他所有的东至是在根本不是 UI 的地方也要与 UI 捆绑使用！

以 SwiftUI 中的 `@FetchRequest` 为例。它在表示层中捆绑了 `CoreData` 模型。看起来的确很是方便。但这同时严重违背了计算机科学中的多种软件设计原则和最佳做法 —— 这样的代码可以在短期内节省时间，但从长远来看可能会对项目造成极大的危害。

`@AppStorage` 怎么样？数据、文件操作就在表示层中实现。那你又该如何测试这些代码？你可以轻松识别容器中的键名的冲突吗？你能否能将其无缝迁移到其他数据存储类型，比如迁移到使用 KeyChain？

再次强调，开发速度得以最大化的提高之时，我们都忽略了代码质量、可维护性和代码重用性。

再来看看不同界面的导航。

UIKit 总是对我们耳语：“噢！你快点用 `presentViewController(:，animation：，completion :);` 代码替换掉旧代码吧！不要再使用那些代码了！”

而 SwiftUI 更为张狂，向我们大声嚷嚷：“听我的，除非你按照我想要的方式来做，要么我就会以一套复杂的方式搞垮你的应用！”

有没有一种方法可以保护我们的代码库免受这些野蛮的 API 的侵害？

当然是有的！

这种张狂的 API 通常情况下是挺好的 —— 让程序员更不容易犯错。但是，当此类 API 无法正常工作时，这就会变成一个巨大的问题，例如 SwiftUI 的自动化页面导航就出现了问题。

## 布置 UI 界面

如你所见，框架中处处是陷阱。

你使用框架越多的功能，你就越难在特定界面或整个应用程序中停止使用此框架。

如果我们希望应用足够的顽强，可以忍耐 UIKit 与 SwiftUI 之间的痛苦过渡（反之亦然），则需要确保表示层和其他层之间不是简简单单的一个木栅栏分割，而是一堵巨墙完全分隔它们。

我指的是，什么都不应该被留下表示层中 —— 即使是字符串格式化也应该完全扔出表示层。

你是否可以在没有 UIKit 或 SwiftUI 库的支持下将浮点数 `5434.35` 转换为 `$5,434.35`？就让我们在表示层之外完成这项工作！

UI 框架在屏幕之间的导航的 API 是否会让视图粘合其他代码？就让我们把导航隔离开！

我们不仅需要从 UI 层中提取尽可能多的逻辑，而且还需要使 UIKit 组件或 SwiftUI 组件与获取数据的函数完全兼容。

我们如何让 UIKit 和 SwiftUI 之间兼容？

我们知道，SwiftUI 是完全由数据驱动的 —— 需要提供响应式数据的绑定。幸运的是，UIKit 可以与 MVVM 和响应式框架一起变换。

这意味着数据源，委托，目标操作以及其他 UIKit API 应该在 UI 层中被隔离开。

—— `import UIKit` 不应出现在任何的 ViewModel 中。

我要提醒一下，只要 UI 组件是完全由数据驱动的，则显示模块的确切架构模式并不重要。为了简化示例，我将在本文中提及 MVVM。

现在。我们应该为 ViewModel 使用哪一个响应式框架？我们知道 SwiftUI 仅可以与 [Combine](https://developer.apple.com/documentation/combine) 一起使用，而 UIKit 最适合与 RxCocoa 一起使用。

—— 两种方法都可行，因此这取决于你是否要让你的应用只支持 iOS 13 或以上（Combine）以及你对 RxSwift 的喜爱程度。

让我们同时考虑下这两个方法吧！

## 构建 RxSwift 和 SwiftUI 之间的桥梁

从 iOS 13 开始我们就可以使用 Combine 套件，对于仍然需要支持 iOS 11 或 12 的用户来说这可不是个什么好消息。

在这里，我将讨论一种将 UIKit + RxSwift 迁移到 SwiftUI + RxSwift 的简便方法。

考虑一下这个最简单的配置：

```Swift
class HomeViewModel {
    
    let isLoadingData: Driver<Bool>
    let disposeBag = DisposeBag()
    
    func doSomething() { ... }
}

class HomeViewController: UIViewController {
    
    let loadingIndicator: UIActivityIndicatorView!
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .isLoadingData
            .drive(loadingIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    @IBAction func handleButtonPressed() {
        viewModel.doSomething()
    }
}
```

这个视图是完全由数据驱动的 —— ViewModel 完全控制视图的状态、内容更改。

那如果让我们在不涉及 ViewModel 的代码的情况下将该界面迁移到 SwiftUI？

有两种方法可以尝试：

1. 在原始 ViewModel 中给绑定了 `Driver` （或`Observable`）的 `@Published` 的变量绑定一个新的 `ObservableObject`。
2.在 SwiftUI 的视图内，将每个 `Driver` 适配为 `Publisher` 并绑定到 `@State`。

## 由 `Observable` 到 `@Published` 的迁移

对于第一种方法，我们需要创建一个新的 `ObservableObject`，以将原来的 ViewModel 中的每个 `Observable`变量镜像过去：

```Swift
extension HomeViewModel {
    class Adapter: ObservableObject {
        let viewModel: HomeViewModel
        @Published var isLoadingData = false
    }
}

struct HomeView: View {
    let adapter: HomeViewModel.Adapter
    
    var body: some View {
        if adapter.isLoadingData {
            ProgressView()
        }
        Button("Do something!") {
            self.adapter.viewModel.doSomething()
        }
    }
}
```

原来的 ViewModel 和适配器之间的值的绑定代码应尽可能简洁。这是在 `Driver` 和 `Observable` 的情况下桥接的样子：

```Swift
let observable: Observable<Bool> = ...
observable
    .bind(to: self.binder(\.isLoadingData))
    .disposed(by: disposeBag)
    
let driver: Driver<Bool> = ...
driver
    .drive(self.binder(\.name))
    .disposed(by: disposeBag)
```

这里我们需要的是使用 RxSwift 的 `Binder`，它会将值分配给特定的 `@Published` 值。这是进行桥接的 `binder` 函数的代码片段：

```Swift
extension ObservableObject {
    func binder<Value>(_ keyPath: WritableKeyPath<Self, Value>) -> Binder<Value> {
        Binder(self) { (object, value) in
            var _object = object
            _object[keyPath: keyPath] = value
        }
    }
}
```

回到我们的 ViewModel，你可以在 `Adapter` 的初始化中进行绑定：

```Swift
extension HomeViewModel {

    class Adapter: ObservableObject {
    
        let viewModel: HomeViewModel
        private let disposeBag = DisposeBag()
        
        @Published var isLoadingData = false
        
        init(viewModel: HomeViewModel) {
            self.viewModel = viewModel
            viewModel.isLoadingData
                .drive(self.binder(\.isLoadingData))
                .disposed(by: self.disposeBag)
        }
    }
}
```

这种方法的一个缺点是必须为你拥有的每个 `@Published` 变量都写一份一样的模版化的代码。

---

## 将 `Observable` 与 `@State` 绑定

第二种方法只需要写较少的代码，并且基于 SwiftUI 变成可以使用外部状态的另一种方式：使用 View 的 `onReceive` 方法，将值分配给本地的 `@State`。

这里的好处是我们可以直接在 SwiftUI 视图中使用原始的 ViewModel：

```Swift
struct HomeView: View {

    let viewModel: HomeViewModel
    @State var isLoadingData = false
    
    var body: some View {
        if isLoadingData {
            ProgressView()
        }
        Button("Do something!") {
            self.viewModel.doSomething()
        }
        .onReceive(viewModel.isLoadingData.publisher) {
            self.isLoadingData = $0
        }
    }
}
```

这里的 `viewModel.isLoadingData` 是一个 `Driver`，也因此我们需要将其转化为 Combine 中的 `Publisher`。

开源社区中已经发布了 [RxCombine](https://github.com/CombineCommunity/RxCombine) 库，该库支持从 `Observable` 到 `Publisher` 的桥接，因此使用该库支持 `Driver` 会很简单：

```Swift
import RxCombine
import RxCocoa

extension Driver {
    var publisher: AnyPublisher<Element, Never> {
        return self.asObservable()
            .publisher
            .catch { _ in Empty<Element, Never>() }
            .eraseToAnyPublisher()
    }
}
```

## 将 UIKit 与 Combine 连接

如果你可以只支持 iOS 13+，则可以考虑在应用程序中使用 Combine 构建网络和其他非 UI 模块。

即使将 Combine 与 UIKit 绑定起来有些不便，但从长远来看，当项目完全迁移到 SwiftUI 时，选择 Combine 作为驱动应用程序中数据的核心框架总是有所裨益的。

而且同时，你可以在 `sink` 函数中更新 UIKit 视图：

```Swift
viewModel.$userName
    .sink { [weak self] name in
        self?.nameLabel.text = name
    }
    .store(in: &cancelBag)
```

或者，你可以利用上述 RxCombine 库将 RxCocoa 中可用的数据绑定转换为 `Publisher` 或 `Observable`。

```Swift
viewModel.$userName // Publisher
    .asObservable() // Observable
    .bind(to: nameLabel.rx.text) // RxCocoa 绑定
    .disposed(by: disposeBag)
```

应该注意，如果我们在应用程序中选择 Combine 作为主要的响应框架，则 RxSwift、RxCocoa 和 RxCombine 的使用应仅限于将数据绑定到 UIKit 视图，这样我们就可以轻松摆脱这些依赖关系以及应用程序中的最后一个 UIKit 视图。

在这种情况下，ViewModel 应该只去使用 Combine 来构建（不要再使用 `import RxSwift` 了！）。

让我们一起回到原始的示例：

```Swift
class HomeViewModel: ObservableObject {

    @Published var isLoadingData = false
    func doSomething() { ... }
}

class HomeViewController: UIViewController {
    
    let loadingIndicator: UIActivityIndicatorView!
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .$isLoadingData // 获取 Publisher
            .asObservable() // 转换到 Observable
            .bind(to: loadingIndicator.rx.isAnimating) // RxCocoa 绑定
            .disposed(by: disposeBag)
    }
    
    @IBAction func handleButtonPressed() {
        viewModel.doSomething()
    }
}
```

当需要在 SwiftUI 中重建这个界面时，一切都将自动完成：我们无需在 ViewModel 中进行任何更改。

## 关于页面导航的想法

过去，我曾探讨过 [程序导航](https://nalexn.github.io/swiftui-deep-linking/) 在 SwiftUI 中的工作方式，根据我的经验，这是 SwiftUI 使用起来不是很方便的部分。这里发生着各种故障和崩溃，也不支持自定义动画。

随着时间的推移，这些问题肯定会得到解决，但是到目前为止，我丝毫不信任 SwiftUI 的页面间导航功能。

停止使用 SwiftUI 的页面导航后，我们其实并不会损失太多 —— 只要 SwiftUI 仍是由 UIKit 支持的，与我们使用 UIKit 所实现的性能相比，就不会有什么大的性能差异。

在为本文构建的示例项目中，我使用了传统的协调器模式（MVVM-R），该模式适用于使用 SwiftUI 中的 `UIHostingController` 构建的页面。

## 结论

如果我们想控制与使用特定 UI 框架有关的风险，我们应该付出更多的努力来控制其在代码库中的扩展。

SwiftUI 存在的问题不应阻止你至少在可预见的将来准备将你的项目要迁移到此框架。

从 UI 层中提取尽可能多的业务逻辑，并使 UIKit 屏幕由数据驱动。这样，迁移到 SwiftUI 变得轻而易举。

我用普通的 Login-Home-Detail 界面构建了一个 [示例项目](https://github.com/nalexn/uikit-swiftui)，演示了 UIKit 和 SwiftUI 视图如何变得不再重要，让你可以轻松分离并更换。

（这个项目有两个运行目标 —— 一个在 UIKit 上运行，另一个在 SwiftUI 上运行。除了界面部分的其他基础部分都共享了一样的代码库。）

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
