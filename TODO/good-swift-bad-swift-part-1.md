>* 原文链接 : [Good Swift, Bad Swift — Part 1](https://medium.com/@ksmandersen/good-swift-bad-swift-part-1-f58f71da3575)
* 原文作者 : [Kristian Andersen](https://medium.com/@ksmandersen)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [达仔](https://github.com/zhangjd)
* 校对者: [Nicolas(Yifei) Li](https://github.com/yifili09)、[Jack King](https://github.com/Jack-Kingdom)


# 好的与坏的，Swift 语言面面观（一）

在 WWDC 2014（苹果 2014 年开发者大会）发布的 Swift 编程语言，大约在一周内将迎来它的两周岁生日（译注：WWDC 2014 的时间是 2014-6-3）。当时听到这个消息，我们在工作室里兴奋地跳了起来，并从此投入到了 Swift 的怀抱。然而两年时间过去了，我依然在苦苦思索着怎样写出好的 Swift 代码。要知道 Objective-C 已经快有三十年历史了，我们都已经摸索出 Objective-C 的最佳实践，以及什么是好或坏的 Objective-C 代码，然而 Swift 还很年轻。

在这一系列的文章里，我将尝试提炼出我认为的 Swift 语言中好与不好的部分。诚然我不是这方面的专家，我只是希望抛砖引玉，分享我对这个问题的思考，并激励其它开发者（没错就是你）表达自己的见解。如果你对此有任何想法、批评，或者对于好代码的看法，可以在原文下面留言，或者 [在 Twitter 上联系我](http://twitter.com/ksmandersen)。

让我们进入正题。


### 使用枚举类型（Enums）避免代码中的字符串输入错误

我早已无法数清我有多少次犯下了同一种错误：花费大量时间在寻找字符串拼写错误导致的各种各样的古怪 bug。枚举类型除了可以帮你节省调试时间外，还可以减少字符输入的时间，因为 XCode 的代码补全功能会推荐定义好的枚举值。

在使用 NSURLSession 的每个项目里，我都包含了下面的代码片段：

    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE
    }

这是一个非常简单的枚举，我知道大部分的开发者可能都不屑于这么做。然而基于上述原因，我确实是这么使用的。

**更新：** [Tobias Due Munk](https://medium.com/u/82271c72eab3) 指出，你甚至不需要把和键名相同的值字符串写出来，Swift 有更简化的语法。你只需要这样写：

    enum HTTPMethod: String { case GET, POST, PUT, DELETE }

### 使用访问控制关键词限制内容可访问性

稍等一会儿，还记得 public, private, internal 这都是什么鬼吗？为什么会有一种 Java 既视感？就跟大部分 CS（计算机科学）专业毕业生一样，我也写过 Java 代码，可是我不喜欢这门语言及其生态系统。然而，尽管我不喜欢它，但不得不承认这门语言有着一些明智的设计。如果你正在为其他开发者提供 API，而他们不清楚代码的输入输出，此时你就会明白定义完善且文档清晰的 API 的重要性了。因此，合理地添加权限控制关键词到 API 方法中，可以帮助你的用户更好地理解你的 API “表面积”，并寻找到他们想要调用的接口。当然，你也可以写文档来解释应该使用哪些方法，哪些应该保留下来，但是为什么不通过添加关键词来强制实行呢？

让我感到吃惊的是，我曾经和不少开发者聊过，他们并不喜欢添加权限控制关键词。其实对于 iOS/OS X 开发者而言，权限控制的概念并不新鲜。在 Objective-C 中，我们就把“公有的”接口放在 .h 文件中，而把“私有的”接口放在 .m 文件中。

在写 Swift 代码的过程中，我总是遵循“最严格的”原则，在一开始尽可能先把所有类、结构、枚举以及函数设成私有。如果之后我发现需要一个函数暴露在类外，我才会尝试降低这个限制。通过遵循这一原则，我可以实现最小化 API “表面积”，方便其他开发者调用。

### 使用泛型避免 UIKit 模板代码

自从 Swift 出现以后，我就一直在代码逻辑中完全实现 view 和 view controller。作为曾经的 Storyboard 重度用户的我，现在发现把所有的属于视图的代码放在一个地方，比起分开放在 XML 文件和几行逻辑代码更加实用。

在编写了大量 view 和 view controller 代码之后，我遇到了一个难题。因为我更喜欢 auto layout，所以我偏向于不使用参数初始化视图（init:frame 是指定构造器）。如果你在 Swift 中，对于任何的 UIKit 类指定一个无参数的构造函数，你就不得不指定一个 init:coder 构造器。这很烦人，为了避免每次创建视图都写这段模板代码，我创建了一个 “泛型视图类（Generic View Class）” ，让所有视图继承这个类而无需继承 UIView。

    public class GenericView: UIView {
        public required init() {
            super.init(frame: CGRect.zero)
            configureView()
        }
             public required init?(coder: NSCoder) {
            super.init(coder: coder)
            configureView()
        }
       internal func configureView() {}
    }

这个类同时也表达出我的另一个编程习惯：创建一个 “configureView” 方法，把所有配置视图的操作，包括添加子视图、约束、调整颜色、字体等，全都放到这个方法中。这样的话，无论什么时候创建视图，我都不需要再写一遍上述的模板代码了。

    class AwesomeView: GenericView {
        override func configureView() {
            ....
        }
    }let awesomeView = AwesomeView()

当你把这个模式配合泛型 view controller 一起使用，效果更佳。

    public class GenericViewController&lt;View: GenericView&gt;: UIViewController {
        internal var contentView: View {
            return view as! View
        }
        public init() {
            super.init(nibName: nil, bundle: nil)
        }
        public required init?(coder: NSCoder)
            super.init(coder: coder)
        }
        public override func loadView() {
            view = View()
        }
    }

现在要给视图创建 view controller 更加简单了。

    class AwesomeViewController: GenericViewController&lt;AwesomeView&gt; {
        override func viewDidLoad()
            super.viewDidLoad()
            ....
        }
    }

我把这个模式的代码抽离出来，放到了一个 [GitHub repo](https://github.com/ksmandersen/GenericViewKit) 中。这套代码可以配合 Carthage 或者 CocoaPods 作为一套框架使用。

我同意这 4 个基类几乎没实现什么功能，也称不上一套框架。之所以发布这套代码，是因为我觉得对于大部分人来说，这种用法是最容易上手的方式。我觉得你完全可以把这几个类复制粘贴到你的代码当中，我预计不会对这套代码作出很大修改了。

以上就是 Swift 语言面面观系列的第一部分，期待大家更多的想法、批评和建议。欢迎在下面留言，或者 [给我发 Twitter](http://twitter.com/ksmandersen)

