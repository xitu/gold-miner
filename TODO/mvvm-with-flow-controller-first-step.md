>* 原文链接 : [MVVM with Flow Controller-First Step](https://medium.com/@digoreis/mvvm-with-flow-controller-first-step-83e60ade0018)
* 原文作者 : [Rodrigo Reis]()
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [shixinzhang](https://github.com/shixinzhang)
* 校对者: [yifili09](https://github.com/yifili09) , [rccoder](https://github.com/rccoder)

# 使用流动控制器（Flow Controller ）实现 MVVM 协议模型

> 我看了好久 Krzysztof Zablocki 关于 MVVM 的视频，最后发现理解新东西只有一种方法：动手建个项目！

在阅读许多关于软件架构的知识后，我最近 6 个月一直在学习 MVVM 协议模型。为了理解这个协议需要引用 [**Natasha The Robot**](https://www.natashatherobot.com/swift-2-0-protocol-oriented-mvvm/) 的一篇文章，这篇文章里介绍了关于编程协议的所有知识。如果你听不到我说的是什么鬼，建议你最好去读一下 [**Natasha The Robot**](https://www.natashatherobot.com/)。

一个月前我看完了 [**Steve “Scotty” Scott**](https://twitter.com/macdevnet)  关于 MVVM-C 的课程。在这个我今年看过最佳视频之一的视频中，阐述了最重要的不是代码量减少，而是这个架构能让我们的软件有什么提升。我不反对人们把某个技术称作“银弹”(译者注：“银弹”有“狂拽炫酷吊炸天”一样浮夸的意思)，但是我更喜欢追求极致、找到最好的解决方案。

[![](https://i.ytimg.com/vi_webp/9VojuJpUuE8/sddefault.webp)](https://www.youtube.com/embed/9VojuJpUuE8)

最近几周，我想了很多有关如何提高我对 MVVM 架构的理解，并且创建一个可维护的开发框架。所以我看了 [**Krzysztof Zabłocki**](https://twitter.com/merowing_) 关于软件架构的视频，
这个视频太赞了。如果你想看讲了什么可以点这里看[视频](http://slideslive.com/38897361/good-ios-application-architecture-en)或者点这里看[博客](http://merowing.info/2016/01/improve-your-ios-architecture-with-flowcontrollers/)。

看完 Krzysztof Zablocki 的视频后我决定建个项目来实现一种更好的架构。所以，我为（实现）这个架构制定了清晰的目标。

### 总目标

在选择哪一个架构之前，我会制定一个包含这个架构所关注的能解决什么目标的列表，这是从我多年 Java 项目开发中总结出的。这帮助我定义我们架构的优点。下面是促使我测试的要点。

#### 模块

我希望我的架构可以创建代码可用性强的模块。还可以创建整个项目都可以复用的结构，同时能够使用某个方法创建一个灵活的接口，
以至于项目可拓展性比较好。

#### 好，开始测试

单元测试和用户界面测试，这个就不用解释了吧。但我关注的是有关架构的分层，它为了（更好的部署）自动测试，让 QA 分析员想出新的测试机制来保证应用程序的（高）质量。

#### A/B 测试（简单来说，就是为同一个目标制定两个方案，让一部分用户使用 A 方案，另一部分用户使用 B 方案，记录下用户的使用情况，看哪个方案更符合设计）

应用市场上基于不同的界面和功能的应用日益复杂，界定应用优劣与否的方案有很多。在这里我重点研究应用是否有自定义和模拟用户体验的能力。

### MVVM 与流控制器

在这个概念下，我决定将完全使用 MVVM 写接口来创建一个明确的区分。添加必要的依赖关系。管理这些依赖并且决定哪些将使用的接口会是流控制器。

#### 流控制器

流控制器是一个控制用户路径的小型类和结构的集合。这使我们能够为 A / B 测试创建不同的数据流，例如，权限管理。
流之间的通信是通过一个共同的、可以传递窗口引用或导航控制器的对象，那可以让你创造出不同流的导航。

该模型的另一个重要的功能就是它可以负责为 ViewController 实例化并注入 ViewModel + Model。
这有助于依赖注入时代码重用更多。对于这种情况，有必要研究一下 Swift 的泛型，虽然它仍然有一些问题。

#### MVVM

这种架构和我之前项目的架构很像，唯一不同的是 VC (ViewController) 必须接受一个兼容的 ViewModel（通过既定协议）。
因此 VC 是独立的、封装完整的，重要的是要方便测试和提高代码的重用性。

这种独立意味着在我想要让界面灵活可变的时候可以用这种控制器来实现。另一个例子是抽象相似界面，如网格和列表使用相同的 ViewModel 。抽象必然会更复杂些，但当你的应用程序的增长或者随着时间的变化，你的收益也会越来越多。

我谈论的是保持一个应用持续发展的方法，改进一个成品的代码和创建第一个版本一样重要。
更多细节可以看这篇文章： [https://medium.com/@digoreis/your-app-is-getting-old-at-this-time-e025662e20e7#.py9qlarui](https://medium.com/@digoreis/your-app-is-getting-old-at-this-time-e025662e20e7#.py9qlarui)

在下面的文本中解释了架构测试的原因后，我将举例证明初步的结果。

### 实战项目

我决定创建一个简单的项目，一个列表和详情。为了便于理解和证明我要测试的另一个很重要的点，不使用 CocoaPods，不能使用依赖。

我注意到一件事，随着时间的推进，我们都意识到开发应用时构建的时间很长，这是因为项目主要几步的编译问题。一开始评估时可能只会看到部分细节，
然而事实是等待 Xcode 翻译、组织项目浪费了许多时间。

[**digoreis/ExampleMVVMFlow** _ExampleMVVMFlow - One Example of MVVM w/ Flow Controller_github.com](https://github.com/digoreis/ExampleMVVMFlow)

#### Storyboard

我不赞同在 Xcode 中 Storyboard 带走什么是不好的。相反，不使用它的结果才是值得我们担心的。在下个项目中我将考虑不使用它，这只不过是一个本地代码的 XML 表示。在一个项目合并复杂性和构建时间逐渐增长的成熟团队中，我认为每个人都应该思考一下这个。

**但请不要争论！**

#### 挑战

挑战的第一阶段是很简单的，作为一个项目列表显示他们，并选择一个显示细节。我相信，这是开发应用程序的最常见的任务。在这里是一个简单的猫头鹰列表，有名称，照片和描述。这个内容的显示是通过 FlowController 枚举配置的。

我不会讲太多我决定构建的内容有多混乱，因为我在很短的的时间（ 8 小时）内测试我的抽象极限，现在正在完善的代码，而不是增加项目。
在下一节中，我讲讲实验的结果。

#### 结果

第一步是把 Storyboards（左边启动屏的）和其他不会使用的东西去掉。然后只在应用启动时开始系统流程。

    import UIKit

    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate {

        var window: UIWindow?

        func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
            window = UIWindow(frame : UIScreen.mainScreen().bounds)
            let configure = FlowConfigure(window: window, navigationController: nil, parent: nil)
            let mainFlow = MainFlowController(configure: configure)
            mainFlow.start()

            return true
        }
    }

在为流程系统提供应用程序窗口后，它启动一个看起来像是下图所示的树的系统。为了使用导航，我想保持 UINavigationController ，
这样你就可以从 UIWindow 或 UINavigationController 启动流。

![](https://cdn-images-1.medium.com/max/1600/1*oUJ72oZR6wpVkufvCbrMWg.png)

关于 MVVM 与流控制器的基本方案

一个流初始化时会构建一个 ViewModel 和 Model（需要的话会更多），启动创造了必要的接口的方法，添加它的依赖。
这需要这些实体之间的代码耦合更具优势。
我们可以看到在 OwlsFlowController 案例中，通过配置选择是否在网格还是列表中显示数据，在本例中是固定的，但它可以有两种测试情况。

    import UIKit

    class OwlsFlowController : FlowController, GridViewControllerDelegate, ListTableViewControllerDelegate {

        private let showType = ShowType.List
        private let configure : FlowConfigure
        private let model = OwlModel()
        private let viewModel : ListViewModel<OwlModel>

        required init(configure : FlowConfigure) {
            self.configure = configure
            viewModel = ListViewModel<OwlModel>(model: model)
        }

        func start() {

            switch showType {
            case .List:
                let configureTable = ConfigureTable(styleTable: .Plain, title: "List of Owls",delegate: self)
                let viewController = ListTableViewController<OwlModel>(viewModel: viewModel, configure: configureTable) { owl, cell in
                    cell.textLabel?.text = owl.name
                }
                configure.navigationController?.pushViewController(viewController, animated: false)
                break
            case .Grid:
                 let layoutGrid = UICollectionViewFlowLayout()
                layoutGrid.scrollDirection = .Vertical
                let configureGrid = ConfigureGrid(viewLayout: layoutGrid, title: "Grid of Owls", delegate: self)
                let viewController = GridViewController<OwlModel>(configure: configureGrid) { owl, cell in
                    cell.image?.image = owl.avatar
                }
                 viewController.configure(viewModel:viewModel)
                configure.navigationController?.pushViewController(viewController, animated: false)
                break
            }

        }

        private enum ShowType {
            case List
            case Grid
        }

        func openDetail(id : Int) {
             let detail = FlowConfigure(window: nil, navigationController: configure.navigationController, parent: self)
             let childFlow = OwlDetailFlowController(configure: detail,item: viewModel.item(ofIndex: id))
             childFlow.start()
        }
    }

该模型的有点是应用中的大多数列表都共享相同的行为和相同的接口。在本例中，只有数据和子单元的变化，可以作为一个参数传递，并为所有列表创建一份可重用的代码。

这里有趣的一点是实现了两种响应协议：一个用于网格和一个列表。但两个的实现是相同的。这很有趣，因为我对每种类型的接口都有单独的操作，但通用的操作可以共享，同时不使用继承。

    import UIKit

    struct ConfigureTable {
        let styleTable : UITableViewStyle
        let title : String
        let delegate : ListTableViewControllerDelegate
    }

    protocol ListTableViewControllerDelegate {
        func openDetail(id : Int)
    }

    class ListTableViewController<M : ListModel>: UITableViewController {

        var viewModel : ListViewModel<M>
        var populateCell : (M.Model,UITableViewCell) -> (Void)
        var configure : ConfigureTable

        init(viewModel model : ListViewModel<M>, configure : ConfigureTable, populateCell : (M.Model,UITableViewCell) -> (Void)) {
            self.viewModel = model
            self.populateCell = populateCell
            self.configure = configure
            super.init(style: configure.styleTable)
            self.title = configure.title
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

        override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }

        override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.count()
        }

        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            populateCell(viewModel.item(ofIndex: indexPath.row), cell)
            return cell
        }

        override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            configure.delegate.openDetail(indexPath.row)
        }

    }

接口的实现是清晰和干净的，它是一个有简单的参数展示的客观的基础设施。所有的创建、删除都没有业务实现。

另一件事是为了填充子单元封闭的通道，在不久将来它可以允许我们用一个参数来决定使用那部手机。这种架构的想法是将接口分为两部分，第一部分是一系列现成的基础设施和可重复使用的整个项目。

第二部分 UIViews 和 子单元为每个情况，对每一个数据集进行定制化。因此，我们通常的测试可以覆盖大多数的接口，增加安全性的实现。

**_备注：因为某些原因，在某些情况下，Swift 将不会接受一个泛型类型作为一个 init 方法的协议参数。目前仍在调查究竟是 Swift 的 bug 还是故意限制。_**

得到的结果是代码非常干净，并最大限度地提高接口的重用。还研究了泛型和协议作为一种抽象问题的方法。其他的结果是构建时间明显快得多。

这些都是这几个星期的初步结果，还有其他我期待的结果我会在其他文章中一一介绍。如果他们想在 Github 上跟随或者想在 Medium 上编辑文章，
我将把文章发上去。

接下来要做的事和致谢。

### 要做的事：

*   测试：单元测试和模拟界面测试（我开始测试的结果是 78% 的覆盖率）
*   扩展模型 ：其他对象（我需要找到其他的动物）
*   接口和基础设施：创建其他类型的单元，使用相同的 UIViewController

我的下一篇文章将是如何建立有效的测试，简单易维护。祝我好运吧。

### 特别致谢：

首先猫头鹰的灵感来自我的妻子。她喜欢猫头鹰。我也需要你感谢 HootSuite 制造了这一系列很酷的图片。

我努力把我引用的代码都标记出处，如果我遗漏了谁请原谅我。

我不能忘记感谢 [Mikail Freitas](https://github.com/mikailcf)  帮助我识别泛型协议初始化时的错误。我们永远不明白为什么在一个案例中运行好好地，而另一个则不起作用。
