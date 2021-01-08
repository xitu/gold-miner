> - 原文地址：[iOS Responder Chain: UIResponder, UIEvent, UIControl and uses](https://swiftrocks.com/understanding-the-ios-responder-chain.html)
> - 原文作者：[Bruno Rocha](bruno@swiftrocks.com)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/iOS-Responder-Chain-UIResponder-UIEvent-UIControl-and-uses.md](https://github.com/xitu/gold-miner/blob/master/TODO1/iOS-Responder-Chain-UIResponder-UIEvent-UIControl-and-uses.md)
> - 译者：[iWeslie](https://github.com/iWeslie)
> - 校对者：[swants](https://github.com/swants)

# iOS 响应者链 UIResponder、UIEvent 和 UIControl 的使用

**当我用使用 UITextField 究竟谁是第一响应者？**
**为什么 UIView 像 UIResponder 一样进行子类化？**
**这其中的关键又是什么？**

在 iOS 里，**响应者链** 是指 UIKit 生成的 UIResponder 对象组成的链表，它同时还是 iOS 里一切相关事件（例如触摸和动效）的基础。

响应者链是你在 iOS 开发的世界中经常需要打交道的东西，并且尽管你很少需要在除了 `UITextField` 的键盘问题之外直接处理它。了解它的工作原理将让你解决事件相关的问题更加容易，或者说更加富有创造力，你甚至可以只依赖响应者链来进行架构。

## UIResponder、UIEvent 和 UIControl

简而言之，UIResponder 实例对象可以对随机事件进行响应并处理。iOS 中的许多东西诸如 UIView、UIViewController、UIWindow、UIApplication 和 UIApplicationDelegate。

相反，`UIEvent` 代表一个单一并只含有一种类型和一个可选子类的 UIKit 事件，这个类型可以是触摸、动效、远程控制或者按压，对应的子类具体一点可能是设备的摇动。当检测到一个系统事件，例如屏幕上的点击，UIKit 内部创建一个 `UIEvent` 实例并且通过调用 `UIApplication.shared.sendEvent()` 把它派发到系统事件队列。当事件被从队列中取出时，UIKit 内部选出第一个可以处理事件的 `UIResponder` 并把它发送到对应的响应者。这个选择过程当事件类型不同的时候也会有所变化，其中触摸事件直接发送到被触摸的 View，其他种类的事件将会被派发给一个所谓的 **第一响应者**。

为了处理系统事件，`UIResponder` 的子类可以通过重写一些对应的方法从而让它们可处理具体的 `UIEvent` 类型：

```swift
open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
open func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesChanged(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?)
open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
open func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?)
open func remoteControlReceived(with event: UIEvent?)
```

在某种程度上，你可以将 `UIEvents` 视为通知。虽然 `UIEvents` 可以被子类化并且 `sendEvent` 可以被手动调用，但它们并不真正意味着可以这么做，至少不是通过正常方式。由于你无法创建自定义类型，派发自定义事件会出现问题，因为非预期的响应者可能会错误地 “处理” 你的事件。尽管如此，你仍然可以使用它们，除了系统事件，`UIResponder` 还可以以 Selector 的形式响应任意 “事件”。

这种方法的诞生给 macOS 应用程序提供了一种简单的方法来响应 “菜单” 的操作，例如选择、复制还有粘贴，因为 macOS 中存在多个窗口使得简单的代理难以实现。在任何情况下，它们也可用于 iOS 以及自定义操作，这正是类似 `UIButton` 之类的 `UIControl` 可以在触摸后派发事件。看一下如下的一个按钮：

```swift
let button = UIButton(type: .system)
button.addTarget(myView, action: #selector(myMethod), for: .touchUpInside)
```

虽然 `UIResponder` 可以完全检测触摸事件，但处理它们并非易事。 那你要如何区分不同类型的触摸事件呢？

这就是 `UIControl` 擅长的地方，这些 `UIView` 的子类把处理触摸事件的过程进行抽象，并揭示了为特定的触摸分配事件的能力。

在内部，触摸此按钮会产生以下结果：

```swift
let event = UIEvent(...) //包含触摸位置和属性的UIKit生成的触摸事件。
//派发一个触摸事件。
//通过 `hitTest()` 确定哪个 UIView 被 选中。
//因为选择了 UIControl，所以直接调用：
UIApplication.shared.sendAction(#selector(myMethod), to: myView, from: button, for: event)
```

当一个特定的目标被发送到 `sendAction` 时，UIKit 将直接尝试在所需的目标上调用所需的 Selector，如果它没有实现直接就崩溃，但是如果目标为 `nil` 又怎么办呢？

```swift
final class MyViewController: UIViewController {
    @objc func myCustomMethod() {
        print("SwiftRocks!")
    }

    func viewDidLoad() {
        UIApplication.shared.sendAction(#selector(myCustomMethod), to: nil, from: view, for: nil)
    }
}
```

如果你运行它，你会看到即使事件是从没有 target 的普通 `UIView` 发送的，`MyViewController` 的 `myCustomMethod` 也会被调用。

当你没有指定 target 时，UIKit 将搜索能够处理此操作的 `UIResponder`，就像之前在处理简单的 `UIEvent` 示例中一样。在这种情况下，能够处理动作与以下 `UIResponder` 方法有关：

```swift
open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
```

默认情况下，此方法只检查响应者是否实现了实际的方法。 “实现” 方法可以通过三种方式完成，具体取决于你需要多少信息（这适用于 iOS 中的任何原生 target/action 的控件）：

```swift
func myCustomMethod()
func myCustomMethod(sender: Any?)
func myCustomMethod(sender: Any?, event: UIEvent?)
```

现在，如果响应者没有实现该方法怎么办？在这种情况下，UIKit 就会使用以下 `UIResponder` 方法来确定如何继续：

```swift
open func target(forAction action: Selector, withSender sender: Any?) -> Any?
```

默认情况下，这将返回 **另一个可能可以** 处理所需的操作的 `UIResponder`。此步骤将重复执行，直到处理完事件或没有其他选择为止。但是响应者如何知道把操作的路由导向谁呢？

## 响应者链

如开头所述，UIKit 通过动态管理 `UIResponder` 对象的链表来处理这个问题。所谓的 **第一响应者** 只是链表的头节点，如果响应者无法处理特定的事件，则事件被递归地发送给链表的下一个响应者，直到某个响应者可以处理该事件或者链表遍历结束。

虽然查看实际的第一响应者是受 `UIWindow` 中的私有 `firstResponder` 属性的保护，但你可以通过检查 `next` 属性是否有值来检查任何给定响应者的响应者链：

```swift
 extension UIResponder {
    func responderChain() -> String {
        guard let next = next else {
            return String(describing: self)
        }
        return String(describing: self) + " -> " + next.responderChain()
    }
}

myViewController.view.responderChain()
// MyView -> MyViewController -> UIWindow -> UIApplication -> AppDelegate
```

![](https://i.imgur.com/922BVYT.png)

在上一个 `UIViewController` 处理 action 的例子中，UIKit 首先将事件发送给 `UIView` 第一响应者，但由于它没有实现 `myCustomMethod`，view 将事件发给下一个响应者，正好下一个 `UIViewController` 实现了所需方法。

虽然在大多数情况下，响应者链符合子视图的结构顺序，但你可以对其进行自定义以更改常规流程顺序。除了能够重写 `next` 属性以返回其他内容之外，你还可以通过调用 `becomeFirstResponder()` 强制 `UIResponder` 成为第一响应者，并通过调用 `resignFirstResponder()` 来取消。这通常与 `UITextField` 结合使用以显示键盘，`UIResponders` 可以定义一个可选的 `inputView` 属性，使得键盘仅在它是第一响应者时显示。

## 响应者链自定义用途

虽然响应者链完全由 UIKit 处理，但你可以使用它来帮助解决通信或代理中的问题。

在某种程度上，您可以将 `UIResponder` 的操作视为一次性通知。想想任何一个应用程序，几乎每个 view 都可以添加闪烁效果。来导航用户在教程中如何操作。当触发此操作时，如何确保只有当前活动的视图闪烁呢？可能的解决方案如下之一是使每个 view 遵循一个协议，或者使用除了 `"currentActiveView"` 之外每个 view 都需要忽略的通知，但响应者操作允许你不通过代理并用最少的编码来实现这一点：

```swift
final class BlinkableView: UIView {
    override var canBecomeFirstResponder: Bool {
        return true
    }

    func select() {
        becomeFirstResponder()
    }

    @objc func performBlinkAction() {
        //闪烁动画
    }
}

UIApplication.shared.sendAction(#selector(BlinkableView.performBlinkAction), to: nil, from: nil, for: nil)
//将精确地让最后一个调用了 select() 的 BlinkableView 进行闪烁。
```

这与常规通知非常相似，不同之处在于通知会触发注册它们的每个对象，而这个方法只会触发在响应链上最先被查找到的 BlinkableView 对象。

如前所述，甚至可以用此方法进行架构。这是 Coordinator 结构的框架，它定义了一个自定义类型的事件并将自身注入到响应者链中：

```swift
final class PushScreenEvent: UIEvent {

    let viewController: CoordenableViewController

    override var type: UIEvent.EventType {
        return .touches
    }

    init(viewController: CoordenableViewController) {
        self.viewController = viewController
    }
}

final class Coordinator: UIResponder {

    weak var viewController: CoordenableViewController?

    override var next: UIResponder? {
        return viewController?.originalNextResponder
    }

    @objc func pushNewScreen(sender: Any?, event: PushScreenEvent) {
        let new = event.viewController
        viewController?.navigationController?.pushViewController(new, animated: true)
    }
}

class CoordenableViewController: UIViewController {

    override var canBecomeFirstResponder: Bool {
        return true
    }

    private(set) var coordinator: Coordinator?
    private(set) var originalNextResponder: UIResponder?

    override var next: UIResponder? {
        return coordinator ?? super.next
    }

    override func viewDidAppear(_ animated: Bool) {
        //在 viewDidAppear 填写信息以确保 UIKit
        //已配置此 view 的下一个响应者。
        super.viewDidAppear(animated)
        guard coordinator == nil else {
            return
        }
        originalNextResponder = next
        coordinator = Coordinator()
        coordinator?.viewController = self
    }
}

final class MyViewController: CoordenableViewController {
    //...
}

//在 app 的起其他任何位置：

let newVC = NewViewController()
UIApplication.shared.push(vc: newVC)
```

这让 `CoordenableViewController` 都持有对其原始下一个响应者（window）的引用，但是它重写了 `next` 让它指向 `Coordinator`，而后者又将 window 指向下一个响应者。

```swift
// MyView -> MyViewController -> **Coordinator** -> UIWindow -> UIApplication -> AppDelegate
```

这允许 `Coordinator` 接收系统事件，并通过定义一个新的包含了有关新 view controller 信息的 `PushScreenEvent`，我们可以调用由这些 `Coordinators` 处理的 `pushNewScreen` 事件来刷新屏幕。

有了这个结构，`UIApplication.shared.push(vc: newVC)` 可以在 app 中的 **任何地方** 调用，而不需要单个代理或单例，因为 UIKit 将确保只通知当前的 `Coordinator` 这个事件，这得多亏了响应者链。

这里显示的例子非常理论化，但我希望这有助于你理解响应者链的目的和用途。

你可以在 Twitter 上关注本文作者 — [@rockthebruno](https://twitter.com/rockthebruno)，有更多建议也可以分享。

## 官方参考文档

 [使用响应者和响应者链来处理事件](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/using_responders_and_the_responder_chain_to_handle_events)
- [UIResponder](https://developer.apple.com/documentation/uikit/uiresponder)
- [UIEvent](https://developer.apple.com/documentation/uikit/uievent)
- [UIControl](https://developer.apple.com/documentation/uikit/uievent)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
