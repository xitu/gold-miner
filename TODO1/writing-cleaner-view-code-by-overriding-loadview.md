> * 原文地址：[Writing Cleaner View Code in Swift By Overriding loadView()](https://swiftrocks.com/writing-cleaner-view-code-by-overriding-loadview.html)
> * 原文作者：[Bruno Rocha](https://bit.ly/2IY5F4Y)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-cleaner-view-code-by-overriding-loadview.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-cleaner-view-code-by-overriding-loadview.md)
> * 译者：[RickeyBoy](https://github.com/RickeyBoy)
> * 校对者：[徐键](https://github.com/foxxnuaa)

# 重写 loadView() 方法使 Swift 视图代码更加简洁

究竟选择使用 Storyboards 还是纯代码书写 view 是非常主观的事情。在对两种方式都进行了尝试之后，我个人支持使用纯代码书写 view 来完成项目，这样能够允许多人编辑相同的类而不产生讨厌的冲突，也更方便进行代码审查。

在最开始练习纯代码写 view 的时候，人们普遍遇到的一个问题是最开始不知道将代码放在**哪里**。如果你采用普通 storyboard 的方式，将所有相关代码都放进你的 ViewController 之中，这样很容易会最终产生一个巨大的上帝类：

```
final class MyViewController: UIViewController {
    private let myButton: UIButton = {
    	//
    }()
  
  	private let myView: UIView = {
    	//
    }()
  
  	// 其他 10 个左右的 view
  
  	override func viewDidLoad() {
        super.viewDidLoad()
      	setupViews()
    }
  
  	private func setupViews() {
    	setupMyButton()
      	setupMyView()
      	// 设置其他的 view
    }
  
  	private func setupMyButton() {
  	    view.addSubview(myButton)
    	// 十行约束代码
    }
  
    private func setupMyView() {
  	    view.addSubview(myView)
    	// 十行约束代码
    }
  
  	// 所有其他的设置
  
  	// 所有 ViewModel 的逻辑
  
  	// 所有 Button 的点击逻辑等东西...
}
```

你可以通过把 view 移动到不同的文件并添加引用到原来的 ViewController 之中来改善这样的情况，但是你仍然需要用本不应该在 ViewController 中的内容填满 ViewController，就比如约束代码和其他设置 view 的代码 — 更不用说你现在有两个 view 属性（`myView` 和原生 `view`）在 ViewController 之中，而这没有任何好处。

```
final class MyViewController: UIViewController {
    
	let myView = MyView()
  
  	override func viewDidLoad() {
        super.viewDidLoad()
      	setupMyView()
    }
  
  	private func setupMyView() {
  	    view.addSubview(myView)
    	// 10 行左右的约束代码
    	myView.delegate = self
    	// 现在我们同时有了 view 和 MyView...
    }
}
```

臃肿的 ViewController 以及逻辑**过多**的 ViewController 都非常难以管理和维护。在像 MVVM 这样的架构下，ViewController 应该主要作为自身的 View 以及 ViewModel 之间的路由器 -- 设置并且约束 View 并不是它们的职责，ViewController 只应该起到前后传递信息的**路由作用**。

在一个大部分代码都是关于自身 View 的视图代码项目中，能够清晰地拆分你的架构中各部分的职责，对于一个便于维护的项目来说非常重要。你要让你真正构建视图部分的代码完全和你的 ViewController 分离 -- 幸运的是有一个简单的方法，就是重写 `UIViewController` 中原生的 `View` 属性。这样做允许你在分离的文件中管理你的多个 View，同时也仍能保证你的 ViewController 不用去设置任何 View。

## loadView()

`loadView()` 是 `UIViewController` 中并不常见的一个方法，但它是 ViewController 的生命周期中非常重要的一部分，因为它承担着最开始加载出 `view` 属性的责任。当使用 Storyboard 的时候，它会加载出 nib 并将其附加给 `view`，但当手动初始化 ViewController 时，这个方法所做的一切就是创建出一个空的 `UIView`。你可以重写这个方法并改变它的行为，并且在 ViewController 的 `view` 上添加任何类型的 view。

```
final class MyViewController: UIViewController {
	override func loadView() {
	    let myView = MyView()
	    myView.delegate = self
        view = myView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		print(view) // 一个 MyView 的实例
	}
}
```

注意 `view` 会自动的约束自己到 ViewController 的边界，所以并不需要为 `myView` 设置外部约束！

现在，`view` 成为了我自定义的 view（在本例中为 `MyView`）的一个引用。你可以在这个 view 独立的文件内部构建其所有功能，并且 ViewController 对此毫无权限。太棒了！

为了获取 `MyView` 中的内容，你可以将 `View` 强制转换为你自己的类型：

```
var myView: MyView {
    return view as! MyView
}
```

这样看起来有点奇怪，但这是因为 `view` 将仍然被定义为 `UIView` 类型，而不是你为它定义的类型。

为了避免我的 ViewController 中重复出现这样的代码，我喜欢创建一个 `CustomView` 协议，并在其中定义包含关联类型的行为：

```
/// HasCustomView 协议为 UIViewController 定义了一个 customView 属性，它是为了去代替普通的 view 属性。
/// 为了实现这些，你必须在 loadView() 方法时为你的 UIViewController 提供一个自定义的 View。
public protocol HasCustomView {
    associatedtype CustomView: UIView
}

extension HasCustomView where Self: UIViewController {
    /// UIViewController 的自定义 view。
    public var customView: CustomView {
        guard let customView = view as? CustomView else {
            fatalError("Expected view to be of type \(CustomView.self) but got \(type(of: view)) instead")
        }
        return customView
    }
}
```

最终会：

```
final class MyViewController: UIViewController, HasCustomView {
	typealias CustomView = MyView

	override func loadView() {
	    let customView = CustomView()
	    customView.delegate = self
        view = customView
    }

    override func viewDidLoad() {
    	super.viewDidLoad()
    	customView.render() // 一些 MyView 的方法
	}
}
```

如果每次都定义这个 `CustomView` 类型别名会让你有点烦，那么你可以进一步在泛型类中定义这些行为：

```
class CustomViewController<CustomView: UIView>: UIViewController {
    var customView: CustomView {
        return view as! CustomView // 因为我们正在重写 view，所以永远不会解析失败。
    }

    override func loadView() {
        view = CustomView()
    }
}

final class MyViewController: CustomViewController<MyView> {
	override func loadView() {
		super.loadView()
	    customView.delegate = self
    }
}
```

我个人不太喜欢泛型的方式，因为编译器并不允许泛型类具有的 `@objc` 方法的扩展，这会禁止你在扩展中拥有 `UITableViewDataSource` 之类的协议。但是，除非你需要做一些特殊的事情（比如设置委托），它会允许你跳过重写 `loadView()` 这一步，从而能保持 ViewController 的整洁。

## 结论

重写 `loadView()` 是一个让你的视图代码项目更加易于理解、易于维护的好方法，并且我已经使用 `HasCustomView` 方法获得了非常良好的效果，特别是在最近几个项目中。编写视图部分的代码也许不是你的选择，但是它带来了很多显而易见的好处。尝试一下吧，看看它是不是更适合你。

如果你有更好的定义 view 并且不需要 storyboard 的方法，或者你可能有一些疑问、意见或者反馈，请让我知道。

## 参考文献和推荐阅读

[苹果官方文档: loadView()](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
