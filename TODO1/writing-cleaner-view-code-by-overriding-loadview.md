> * 原文地址：[Writing Cleaner View Code in Swift By Overriding loadView()](https://swiftrocks.com/writing-cleaner-view-code-by-overriding-loadview.html)
> * 原文作者：[Bruno Rocha](https://bit.ly/2IY5F4Y)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-cleaner-view-code-by-overriding-loadview.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-cleaner-view-code-by-overriding-loadview.md)
> * 译者：
> * 校对者：

# Writing Cleaner View Code in Swift By Overriding loadView()

The choice between using Storyboards and writing views programmatically is very subjetive. Having dealt with both in the past, I personally vouch for writing projects entirely through view code as it allows multiple people to work in the same class without nasty conflicts, and easier code reviews.

When starting with the practice of writing views programatically, a common problem people face is _where_ to put the code in the first place. If you follow the regular storyboard approach of putting everything view related in your view controller, it's very easy to end up with a giant god class:

```
final class MyViewController: UIViewController {
    private let myButton: UIButton = {
    	//
    }()
  
  	private let myView: UIView = {
    	//
    }()
  
  	//Other 10 views or so
  
  	override func viewDidLoad() {
        super.viewDidLoad()
      	setupViews()
    }
  
  	private func setupViews() {
    	setupMyButton()
      	setupMyView()
      	//setup for all the other views
    }
  
  	private func setupMyButton() {
  	    view.addSubview(myButton)
    	//10 lines of constraints
    }
  
    private func setupMyView() {
  	    view.addSubview(myView)
    	//10 lines of constraints
    }
  
  	//All other setups
  
  	//All ViewModel logic
  
  	//All the button clicking logic and stuff...
}
```

You can make this better by moving the views to a different file and adding a reference back to the View Controller, but you'll still have to fill your View Controller with things that are not supposed to be in it, such as constraint code and other forms of view setup - not to mention you now have two different view properties (`myView` and the native `view`) in it for no good reason:

```
final class MyViewController: UIViewController {
    
	let myView = MyView()
  
  	override func viewDidLoad() {
        super.viewDidLoad()
      	setupMyView()
    }
  
  	private func setupMyView() {
  	    view.addSubview(myView)
    	//10 lines of constraints or so
    	myView.delegate = self
    	//We now have both 'view' and 'myView'...
    }
}
```

Giant View Controllers and View Controllers that know _too much_ are very difficult to maintain and scale. In architectures like MVVM, the View Controller should act mostly as a router between the View itself and the View Model - it's not its job to know how to setup the views or constrain them, it should merely **route** information back and forth.

In a View Code project where most of the code are the views themselves, it's very important to have a clear separation of responsibilities between the aspects of your architecture in order to have a maintainable project. You want your actual view code to be completely separate from your View Controller - and fortunately, there is a very simple way to override the original `view` property of an `UIViewController`, allowing you to maintain separate files for your views while still making sure your view controller doesn't have to do any kind of view setup.

## loadView()

`loadView()` is an `UIViewController` method that you don't see very often, but it is very important to a view controller's lifecycle since it is responsible for making the `view` property exist in the first place. When using Storyboards, this is the method that will load your nib and attach it to the `view`, but when instantiating view controllers manually, all this method does is create an empty `UIView`. You can override it to change this behaviour and add any kind of view to the view controller's `view` property.

```
final class MyViewController: UIViewController {
	override func loadView() {
	    let myView = MyView()
	    myView.delegate = self
        view = myView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		print(view) // a MyView instance
	}
}
```

Notice that `view` will automatically constrain itself to the edges of the View Controller, so no constraints are needed for the outer `myView`!

Now, `view` is a reference to my custom view (`MyView` in this case). You can build the entire functionality of the view inside its own separate file without the View Controller having to know anything about it. Nice!

To access the contents of `MyView`, you can cast `view` to your custom type:

```
var myView: MyView {
    return view as! MyView
}
```

This looks a bit weird, but it's because `view` will still be defined as an `UIView` regardless of the type you change it for.

To avoid duplicating this code across my View Controllers, I like defining this behaviour inside a `CustomView` protocol with an associated type requirement:

```
/// The HasCustomView protocol defines a customView property for UIViewControllers to be used in exchange of the regular view property.
/// In order for this to work, you have to provide a custom view to your UIViewController at the loadView() method.
public protocol HasCustomView {
    associatedtype CustomView: UIView
}

extension HasCustomView where Self: UIViewController {
    /// The UIViewController's custom view.
    public var customView: CustomView {
        guard let customView = view as? CustomView else {
            fatalError("Expected view to be of type \(CustomView.self) but got \(type(of: view)) instead")
        }
        return customView
    }
}
```

Which results in:

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
    	customView.render() //some MyView method
	}
}
```

If defining this `CustomView` typealias every time is something that would bother you, you can go further and define this behaviour inside a generic class:

```
class CustomViewController<CustomView: UIView>: UIViewController {
    var customView: CustomView {
        return view as! CustomView //Will never fail as we're overriding 'view'
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

I personally don't like the generic approach because the compiler doesn't allow generic classes to have extensions with `@objc` methods, which forbids you from having protocols like `UITableViewDataSource` in extensions. However, it allows you to skip overriding `loadView()` unless something special needs to be done (like setting delegates), which really helps keep your View Controllers clean.

## Conclusion

Overriding `loadView()` is a great way to make a View Code project easier to read and maintain, and I've been using `HasCustomView` specifically in my last few projects with great results. View coding is something that might not be your thing, but it brings many advantages to the table. Try it out, and see what works better for you.

Let me know if you have other ways of defining views in a project without storyboards, along with any other questions, comments or feedback you might have.

## References and Good reads

[Apple Docs: loadView()](https://developer.apple.com/documentation/uikit/uiviewcontroller/1621454-loadview)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
