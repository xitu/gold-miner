>* 原文链接 : [Avoiding the overuse of @objc in Swift](http://www.jessesquires.com/avoiding-objc-in-swift/)
* 原文作者 : [Jesse Squires](http://www.jessesquires.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Dwight](https://github.com/ldhlfzysys)
* 校对者: [jk77me](https://github.com/jk77me), [owenlyn](https://github.com/owenlyn)

# iOS 开发者在 Swift 中应避免过度使用

就在前几天，我终于把项目迁移到了Swift2.2，在使用[SE-0022](https://github.com/apple/swift-evolution/blob/master/proposals/0022-objc-selectors.md)建议的`#selector`语句时，我遇到了一些问题。如果在protocol extension中使用`#selector`，这个protocol必须添加`@Objc`修饰符。而之前的`Selector("method:")`语句则不需要添加。


### 通过协议的扩展配置视图控制器

为了达到本文的目的，我简化了工作中项目的代码，但所有核心的思想都保留着。一种我经常在swift里用的模式是：为了重用的配置写protocols(协议)和extensions(扩展)，特别是有Uikit的时候

假设我们有一组视图控制器，每个控制器都需要一个 view model 和 一个“取消”按钮。每一个控制器需要各自响应
“cancel”按钮的点击事件。我们可以这样写：


    struct ViewModel {
        let title: String
    }

    protocol ViewControllerType: class {
        var viewModel: ViewModel { get set }

        func didTapCancelButton(sender: UIBarButtonItem)
    }



如果就写成这样，那每个控制器都需要自己去添加和写一个一样的取消按钮。这样就会有很多一样的代码。我们可以通过扩展（用老的 `Selector("")` 语句）来解决：



    extension ViewControllerType where Self: UIViewController {
        func configureNavigationItem() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: Selector("didTapCancelButton:"))
        }
    }



现在每个符合协议的控制器都可以通过在`viewDidLoad()`里调用协议的`configureNavigationItem()` 方法来配置取消按钮，是不是好多了~我们的控制器看起来是这样的：


    class MyViewController: UIViewController, ViewControllerType {
        var viewModel = ViewModel(title: "Title")

        override func viewDidLoad() {
            super.viewDidLoad()
            configureNavigationItem()
        }

        func didTapCancelButton(sender: UIBarButtonItem) {
            // handle tap
        }
    }



这仅是一个简单的例子，但我们可以想象通过这个方式制造更多复杂的配置。

把以上代码段升级到 Swift 2.2后，是这样的：



    extension ViewControllerType where Self: UIViewController {
        func configureNavigationItem() {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Cancel,
                target: self,
                action: #selector(didTapCancelButton(_:)))
        }
    }



但现在我们有了个问题，一个新的编译错误



    Argument of '#selector' refers to a method that is not exposed to Objective-C.

    Fix-it   Add '@objc' to expose this method to Objective-C



### 当`@objc`试图破坏所有的东西

因为一系列的原因， 在原始的`ViewControllerType`协议中，我们并不能简单的给这个方法添加一个`@objc`修饰符。如果我们这么做了，那么所有的protocol都需要用`@objc`来标记，这将意味着：

*   所有这个protocol的父protocol都需要用`@objc`来标记。
*   所有继承自这个protocol的protocol都会被自动添加`@objc`。
*   我们在protocol中的结构体(`ViewModel`)不能用Objective-C来表示。

到目前，`@objc`在这里的唯一功能就是定义了一个普通的target-action selectors。尽管我们可以使用swift的强大功能，但是因为Cocoa依然贯穿我们的代码[Cocoa all the way down](http://inessential.com/2016/05/25/oldie_complains_about_the_old_old_ways)，我们并没有正真的在写纯粹的swift - 除非我们开始在各个地方引入@objc。

我们在这的例子很简单，但是想象一下更复杂的类依赖关系图，大量使用Swift的值类型和当这个协议处在多个协议的中间层时。把引入`@objc`作为解决方案真是app的末日。如果我们这样做，`@objc`这种做法会让我们的Swift代码毫无美感并变得乱糟糟。这会毁了所有的东西。

但是希望还是有的。

### 不使用`@objc`来避免乱糟糟

我们大可不必让为了让我们的Swifit代码能使用Objcetive-C的语法而使用`@objc`。

我们可以把protocol分解成多个protocol来去除`@objc`，然后我们再重组这些protocol。事实上，我们可以让编译器顺利编译和避免更改任何视图控制器的代码。

第一步，我们把protocol拆成2个。`ViewModelConfigurable` 和 `NavigationItemConfigurable`。把`ViewControllerType `里的extension放到`NavigationItemConfigurable`。


    protocol ViewModelConfigurable {
        var viewModel: ViewModel { get set }
    }

    @objc protocol NavigationItemConfigurable: class {
        func didTapCancelButton(sender: UIBarButtonItem)
    }



最终，我们可以把原`ViewControllerType` protocol定义成`typealias`。


    typealias ViewControllerType = protocol<ViewModelConfigurable, NavigationItemConfigurable>



和迁移到Swift2.2之前比一切都很正常，而且我们定义的原视图控制器也没有发生任何改变，没有东西被破坏。如果你曾经遇到类似的情况，或者你也想阻止`@objc`带来的破坏（你应该这么做），我强烈建议采用这个策略。

### 这并不是显而易见的


现在的代码，我还是觉得有点不爽，当然，针对这个问题，这就是最Swift化的答案。当Xcode突然开始提示你并且很快的应用它的修复方案依然会把所有都破坏掉。特别是当Xcode提供的修复方案正中你下怀的时候，这个时候，上面说的到的这类解决方案并不能立即很清楚。

最后，在做了以上那些更改之后，我意识到总的来说这其实是一个很好的解决方案。。没有什么理由在一个地方只用一个协议。像`ViewModelConfigurable` 和 `NavigationItemConfigurable`这两个协议分工明确。把不同的协议组合在一起始终都是最优雅、最适当的设计。
