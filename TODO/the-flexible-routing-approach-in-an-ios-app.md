> * 原文地址：[A Flexible Routing Approach in an iOS App](https://medium.com/rosberryapps/the-flexible-routing-approach-in-an-ios-app-eb4b05aa7f52)
> * 原文作者：[Nikita Ermolenko](https://medium.com/@otbivnoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-flexible-routing-approach-in-an-ios-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-flexible-routing-approach-in-an-ios-app.md)
> * 译者：[YinTokey](https://github.com/YinTokey)
> * 校对者：[ellcyyang](https://github.com/ellcyyang), [94haox](https://github.com/94haox)

# iOS App 上一种灵活的路由方式

![](https://ws2.sinaimg.cn/large/006tKfTcly1fpahnxn7qrj318g0pcdvt.jpg)

“Trollstigen”

在 [Rosberry](http://about.rosberry.com/) 中我们已经放弃使用除了 Launch Screen 以外的所有 storyboard，当然，所有布局和跳转逻辑都在代码里进行配置。如果想要进一步了解，请参考我们团队的这篇文章 [没有 Interface Builder 的生活](https://blog.zeplin.io/life-without-interface-builder-adbb009d2068)，我希望你会觉得这篇文章非常实用。

在这篇文章里，我将会介绍一种在 View Controller 之间的新的路由方式。我们将带着问题开始，然后一步一步地走向最终结论。享受阅读吧！

* * *

#### 深入挖掘这个问题

让我们使用一个具体的例子来理解这个问题。例如我们准备做一个 App，它包含了个人主页、好友列表、聊天窗口等组成部分。很显然，我们可以注意到在很多 Controller 里都需要通过页面跳转去显示用户的个主页，如果这个逻辑只实现一次，并且能复用的话，那就非常好了。我们记得 [**DRY**](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)！
我们无法使用一些 storyboard 来实现它，你可以想象一下，它在 storyboard 里面看起像什么 —— weeeeb 页面. 😬

现在我们使用的是 **MVVM + Router** 的架构，由 **ViewModel** 告诉 **Router** 需要跳转到一个其他的模块，然后 router 去执行。在我们的例子中，为了避免 view controller（或者View model）臃肿，**Router** 仅仅携带了所有的跳转逻辑。如果你一开始不是很明白，不用担心！我将会用一种比较浅显的方式来解释这种解决方案，所以它也会很容易地被应用到简单的 **MVC** 中去。

* * *

#### 解决方案

**1.** 一开始，添加一个拓展到 **ViewController** 看起来像是一个毫无异议的解决方案：

```
extension UIViewController {
    func openProfile(for user: User) {
        let profileViewController = ProfileViewController(user: user)
        present(profileViewController, animated: true, completion: nil)
    }
}
```

这就是我们想要的 —— 一次编写，多次使用。但是当有很多页面跳转的时候，它会变得很凌乱。我知道 Xcode 的自动补全不好用，但是有时候会给显示很多不需要的方法。即使你不想要在这一页面显示一个个人主页，它还是会存在于那里。所以试着更进一步去优化它。

**2.** 不要在 **ViewControlelr** 里写一个扩展，然后在一个地方写大量方法，让我们在一个单独的**协议**中实现每一个路由，然后使用 Swift 的一个非常好的特性 —— 协议扩展。

```
protocol ProfileRoute {
    func openProfile(for user: User)
}

extension ProfileRoute where Self: UIViewController {
    func openProfile(for user: User) {
        let profileViewController = ProfileViewController(user: user)
        present(profileViewController, animated: true, completion: nil)
    }
}

final class FriendsViewController: UIViewController, ProfileRoute {}
```

现在这个方法就比较灵活了 —— 我们可以扩展一个控制器，仅添加那些所需要的路由（避免写大量的方法），只是添加一个路由到控制器的继承体系里。 🎉

**3.** 但是，理所当然地这里还有一些改进方式：

*   如果我们想要从所有地方跳转到个人主页，除了一个地方以外（这很罕见，但有可能）呢？
*   或者更严重的情况 —— 如果我改变了跳转的进入方式，那么我也应该改变跳转页消失的方式（ present / dismiss )。

我们现在没有机会去配置它，所以现在是时候使用少量的代码去实现一个抽象**跳转** —— **ModalTransition** 和 **PushTransition**：

```
protocol Transition: class {
    weak var viewController: UIViewController? { get set }

    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController)
}
```

为了排版简化，下面我少写了一些 **ModalTransition** 的实现逻辑代码。[Github](https://github.com/Otbivnoe/Routing/blob/master/Routing/Routing/Transitions/ModalTransition.swift) 上有完整能用的版本。

```
class ModalTransition: NSObject {
    var animator: Animator?
    weak var viewController: UIViewController?

    init(animator: Animator? = nil) {
        self.animator = animator
    }
}

extension ModalTransition: Transition {}
extension ModalTransition: UIViewControllerTransitioningDelegate {}
```

下面同样减少了部分 [PushTransition](https://github.com/Otbivnoe/Routing/blob/master/Routing/Routing/Transitions/PushTransition.swift) 的代码逻辑：

```
class PushTransition: NSObject {
    var animator: Animator?
    weak var viewController: UIViewController?

    init(animator: Animator? = nil) {
        self.animator = animator
    }
}

extension PushTransition: Transition {}
extension PushTransition: UINavigationControllerDelegate {}
```

你一定注意到了 **Animator** 这个对象，它是一个简单的用于自定义跳转的协议：

```
protocol Animator: UIViewControllerAnimatedTransitioning {
    var isPresenting: Bool { get set }
}
```

正如我之前所说到的臃肿的 view controller，现在让我们添加一个包含整个路由逻辑的对象，然后让他作为 controller 的一个属性。这就是我们所实现的**路由** —— 一个未来可以被所有路由继承的基类。 🎉

```
protocol Closable: class {
    func close()
}

protocol RouterProtocol: class {
    associatedtype V: UIViewController
    weak var viewController: V? { get }
    
    func open(_ viewController: UIViewController, transition: Transition)
}

class Router<U>: RouterProtocol, Closable where U: UIViewController {
    typealias V = U
    
    weak var viewController: V?
    var openTransition: Transition?

    func open(_ viewController: UIViewController, transition: Transition) {
        transition.viewController = self.viewController
        transition.open(viewController)
    }

    func close() {
        guard let openTransition = openTransition else {
            assertionFailure("You should specify an open transition in order to close a module.")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close.")
            return
        }
        openTransition.close(viewController)
    }
}
```

请稍微花点时间去理解上面这些代码，这个类包含两个用于页面的打开和关闭的方法、一个 view controller 的引用和一个 `openTransition` 对象来让我们知道如何关闭这个模块。

现在让我们使用这个新的类来更新我们的 **ProfileRoute**：


```
protocol ProfileRoute {
    var profileTransition: Transition { get }
    func openProfile(for user: User)
}

extension ProfileRoute where Self: RouterProtocol {

    var profileTransition: Transition {
        return ModalTransition()
    }

    func openProfile(for user: User) {
        let router = ProfileRouter()
        let profileViewController = ProfileViewController(router: router)
        router.viewController = profileViewController

        let transition = profileTransition // 这是一个已经计算过的属性，为了获取一个实例，我把它存为一个变量
        router.openTransition = transition
        open(profileViewController, transition: transition)
    }
}
```

你可以看到默认的界面的跳转是模态的，在 `openProfile` 方法中我们生成一个新的模块，然后打开它（当然如果使用建造者模式或者工厂模式来生成会更好）。同时注意一个变量 `transition`，为了拥有一个实例，`profileTransition` 会被保存到这个变量里。

下一步是更新 **Friends** 模块：

```
final class FriendsRouter: Router<FriendsViewController>, FriendsRouter.Routes  {
    typealias Routes = ProfileRoute & /* other routes */ 
}

final class FriendsViewController: UIViewController {

    private let router: FriendsRouter.Routes

    init(router: FriendsRouter.Routes) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
  
    func userButtonPressed() {
        router.openProfile(for: /* some user */)
    }
}
```

我们已经创建了 **FriendsRouter** ，并且通过 **typealias** 添加了所需要的路由。这正是魔术发生的地方！我们使用协议组成（**&**）去添加更多路由和协议扩展，以此来使用一个默认的路由实现。😎

这篇文章的最后一步是简单友好的实现关闭跳转。如果你重新调用  **ProfileRouter**，那边我们实现已经配置好了 `openTransition`，那么现在就可以利用它。

我创建了一个 **Profile** 模块，它只有一个路由 —— **关闭**，而且当一个用户点击了关闭按钮，我们使用一样的跳转方式去关闭这个模块。

```
final class ProfileRouter: Router<ProfileViewController> {
    typealias Routes = Closable
}

final class ProfileViewController: UIViewController {

    private let router: ProfileRouter.Routes

    init(router: ProfileRouter.Routes) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    func closeButtonPressed() {
        router.close()
    }
}
```

如果需要改变跳转模式，只需要在 **ProfileRoute** 的协议扩展里去修改，这些代码可以继续运行，不需要改。是不是很好？

* * *

#### 结论

最后我想说这个路由方式可以简单地适配 **MVC**，**VIPER**，**MVVM** 架构，即使你使用 **Coordinators**，它们可以一起运行。我正在尽力去改进这个方案，而且我也很乐意听取你的建议！

对这个方案感兴趣的人，我准备了一个[例子](https://github.com/Otbivnoe/Routing)，里面包含了少数模块，在它们之间有不同的跳转方式，来让你更深入地理解它。去下载和玩一下！

* * *

感谢阅读！如果你喜欢上面文章 —— 不要客气，加入我们的 [telegram channel](https://t.me/readaggregator)！

![](https://cdn-images-1.medium.com/max/800/1*s9Rzi_gHLe5rllzlj5ox1A.png)

这是编译ITC过程中的我。

在 [Rosberry](http://www.rosberry.com) 的粗野iOS工程师。Reactive、开源爱好者和循环引用检测家。

感谢 [Anton Kovalev](https://medium.com/@totowkos?source=post_page) 和 [Rosberry](https://medium.com/@Rosberry?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


