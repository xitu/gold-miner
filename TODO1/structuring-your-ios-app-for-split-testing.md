> * 原文地址：[Structuring Your iOS App for Split Testing](https://heartbeat.fritz.ai/structuring-your-ios-app-for-split-testing-178eacf5aa7c)
> * 原文作者：[Arlind Aliu](https://medium.com/@arlindaliu.dev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/structuring-your-ios-app-for-split-testing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/structuring-your-ios-app-for-split-testing.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[swants](https://github.com/swants)

# 为你的 iOS App 构建分离测试

![](https://cdn-images-1.medium.com/max/3000/1*WZf4olsps6kCjyVj0PM7JA.jpeg)

> 分离测试是为应用提供哪种方案对于给定目标表现更优决策的方法。
>
> 我们为应用的用户以随机的方式分发变量或行为不同的方案，通过收集数据并统计分析，确定哪个方案表现的更好。

本文旨在提供一种结构化组织构建 App 的简单方法，以便你可以在使用分离测试时能获得整洁而可扩展的代码。

本文提供了一些技巧和示例，你可以把它当作实际应用下的指南。

## 一般性问题

使用分离测试（也称为 A/B 测试），我们拥有无限的测试可能性。但总的来说，我们可以按以下顺序对分离测试所需进行的修改进行分组：

1. **内容变更**：仅更改指定视图中的特定部分或根据给定的测试添加或删除特定内容。

2. **设计变更**：测试颜色、排版或布局等变化会如何影响用户的行为。

3. **行为变更**：根据拆分组来更改按钮操作或屏幕显示的行为。

但其中问题在于，所有这些类别中可能会出现大量重复的代码。

我们需要为测试创建一种易于维护的代码结构，这是因为我们需要不断添加新测试或删除修改旧测试，因此需要考虑它的可扩展性。

## 创建拆分离测试管理器

我们将尝试创建一个通用解决方案并将其用于上述的变更类别。

首先我们创建一个协议来定义拆分测试对象必须符合的规则：

```swift
protocol SplitTestProtocol {
    associatedtype ValueType: Any
    static var identifier: String { get }
    var value: ValueType { get }
    init(group: String)
}
```

`value` 表示一个通用值，该值将由具体的分离测试对象实现。它将对应于我们为目标目标测试的颜色，字体或任何属性。

`identifier` 将作为测试的唯一标识符。

其中的 `group` 将代表当前正在测试的值。它可以是 `a` 和 `b` 或 `red` 和 `green`，这完全取决于为给定测试确定的值的命名。

我们还将创建一个管理器，负责根据与测试标识符相关的数据库中存储的组获取拆分测试的值：

```swift
class SplitTestingManager {
    static func getSplitValue<Value: SplitTestProtocol>(for split: Value.Type) -> Value.ValueType {
        let group = UserDefaults.standard.value(forKey: split.self.identifier) as! String
        return Value(group: group).value
    }
}
```

## 内容变更

![[https://dribbble.com/shots/5805125-Book-Reading-App](https://dribbble.com/shots/5805125-Book-Reading-App)](https://cdn-images-1.medium.com/max/3200/1*k8Pv6wbdmPGWJMx-R-mZOQ.png)

假设我们正在开发阅读类 App，我们决定为用户提供免费的电子书。

我们的营销团队决定首先通过要求用户提供以下内容来创建分离测试：

**在社交媒体上分享我们的应用**

或者

**订阅我们的新闻**

这两种情况都使用相同的 View Controller，但设计的一部分会随情况而改变。在我们的 View Controller 中，我们将创建一个 Content View 区域并在其中添加不同的内容。

在这种情况下，我们需要创建两个不同的 View：一个用于社交共享，另一个用于新闻稿，并分别添加到 View Controller 的 Content View 区域内。

首先创建一个保存 View Controller 样式的对象，并将其传递给 View Controller 的初始化器：

```swift
struct PromotionViewControllerStyle {
    let contentView: String
}
```

```swift
init(style: PromotionViewControllerStyle) {
    self.style = style
    super.init(nibName: nil, bundle: nil)
}
```

基本上，样式对象当前包含我们的 `PromotionViewController` 中 Content View 的 xib 名称。

我们可以创建遵循 `SplitTestProtocol` 的测试对象：

```swift
class EBookPromotionSplitTest: SplitTestProtocol {
    typealias ValueType = PromotionViewControllerStyle
    static var identifier: String = "ebookPromotionTest"
    var value: PromotionViewControllerStyle

    required init(group: String) {
        self.value =
            group == "social" ?
                PromotionViewControllerStyle.init(contentView: "\(TwitterView.self)")
            :   PromotionViewControllerStyle.init(contentView: "\(NewsLetterView.self)")
    }
}
```

现在我们可以根据我们的分离测试轻松地向我们的 View Controller 显示新闻或社交共享的内容：

```swift
@IBAction func presentNextVc(_ sender: UIButton) {
    let style = SplitTestManager.getSplitValue(for: EBookPromotionSplitTest.self)
    let vc = PromotionViewController(style: style)
    self.present(vc, animated: true)
}
```

```swift
func addContentView() {
    let nib = UINib(nibName: style.contentView, bundle: nil)
    let view = nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    contentView.addSubview(view)
    view.bindFrameToSuperviewBounds()
}
```

## 设计变更

通常，在电商 App 中，更改号召性用语的按钮设计很受欢迎，即 `添加到购物车` 或 `购买` 按钮，它们能够更加吸引用户，从而能获得更多点击。

![[https://dribbble.com/shots/5546168-Gate-B](https://dribbble.com/shots/5546168-Gate-B)](https://cdn-images-1.medium.com/max/3200/1*FHM9s3d34M386PQeH10DCg.png)

我们总是可以使用我们需要的任何对象进行分离管理，在这种情况下，假设我们需要一个保存购买按钮颜色值的对象：

```swift
class PurchaseButtonColorSplitTest: SplitTestProtocol {
    typealias ValueType = UIColor

    static var identifier: String = "purchase_button_color"
    var value: ValueType

    required init(group: String) {
        if group == "a" {
            self.value = UIColor.red
        } else {
            self.value = UIColor.green
        }
    }
}
```

如下所示，我们可以简单地从我们的角度来使用它：

```swift
let color = SplitTestManager.getSplitValue(for: PurchaseButtonColorSplitTest.self)
purchaseButton.backgroundColor = color
```

同样，它也可以测试任何其他属性，如字体，边距或任何其他需要根据我们的测试进行更改的属性。

## 行为变更

假设我们打算将 App 中的订阅用户分成两组：

![[https://dribbble.com/shots/5058686-Potted-In-app-Purchases](https://dribbble.com/shots/5058686-Potted-In-app-Purchases)](https://cdn-images-1.medium.com/max/3200/1*xmhmJIL8hSlkxhugjPgDog.png)

我们既希望

**打开 IAP 视图时显示折扣对话框**

也希望

**显示没有任何对话框的默认视图**

我们将使用此示例的策略模式来处理我们的折扣演示。
> 策略模式是一种设计模式，用于创建可互换的算法组，你可以在运行时从中选择所需的算法。

由于我们的 `SplitTestProtocol` 包含一个通用值，我们可以创建将该策略作为其值保存的分离测试对象：

```swift
class DiscountSplitTest: SplitTestProtocol {
    typealias ValueType = DisountStrategy
    static var identifier: String = "iap_discount_type"
    var value: DisountStrategy


    required init(group: String) {
        if group == "offer" {
            value = DefaultDiscountStrategy()
        }
        value = NoDiscountStrategy()
    }
}
```

然后我们可以根据具体策略初始化并呈现我们的 View Controller：

```swift
init(discountStrategy: DisountStrategy) {
    self.discountStrategy = discountStrategy
    super.init(nibName: nil, bundle: nil)
}
```

```swift
func presentDiscoutViewController() {
    let strategy = SplitTestManager.getSplitValue(for: DiscountSplitTest.self)
    let viewController = DiscountViewController(discountStrategy: strategy)
    self.present(viewController, animated: true)
}
```

我们现在可以轻松地将我们的折扣责任传递给 `DiscountStrategy` 对象，并根据我们的需求进行扩展，而无需更改 View Controller 里的代码：

```swift
protocol DisountStrategy {
    func presentDiscountMessage()
}

struct NoDiscountStrategy: DisountStrategy {
    // 提供处理非打折的情况
}

struct DefaultDiscountStrategy: DisountStrategy {
    // 提供处理打折的情况
}
```

```swift
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    discountStrategy.presentDiscountMessage()
}
```

## 一般性提示

当你在进行分离测试时，请务必注意以下几点：

1. 始终使用 **缓存** 作为测试值，以使 App 在用户使用的时候保持一致。

2. 在一次特定测试完成后 **清理** 测试代码，删除你在项目中为分离测试添加的视图，字体，图像和其他任何资源。

3. 确保如果出现问题你可以控制并且可以 **禁用** A/B 测试。

## 总结

分离测试（也称为 A/B 测试）对于我们的 App 来说是一个强大而有效的工具，但如果我们的代码设计不严谨的话，它很容易使你的代码变得一团糟。

在本文中，我们创建了一个可以管理分离测试逻辑的通用解决方案。同时还提供了一些真实的 App 示例和实用技巧，以便你可以在给你的 iOS App 进行分离测试的时候参考。

你可以在 **[medium](https://medium.com/@arlindaliu.dev)** 上关注我，我还写了很多篇 iOS 的高级技巧类文章。

如果你有任何问题或者意见，请给我发送电子邮件 [arlindaliu.dev@gmail.com](http://arlindaliu.dev@gmail.com)。

***

**编者注：打算准备深入研究一些代码吗？你可以浏览 [Fritz](https://github.com/fritzlabs) 的 GitHub 主页。你将找到一些流行的对手机优化过的开源机器学习和深度学习的模型，你可以用它们来构建你自己的 ML 驱动的 iOS 和 Android App 的训练脚本，同时还有一些项目模板和工具。**

**你可以在 [Slack](https://join.slack.com/t/heartbeat-by-fritz/shared_invite/enQtNTI4MDcxMzI1MzAwLWIyMjRmMGYxYjUwZmE3MzA0MWQ0NDk0YjA2NzE3M2FjM2Y5MjQxMWM2MmQ4ZTdjNjViYjM3NDE0OWQxOTBmZWI) 上加入我们以获得技术支持，你也可以跟我们分享你的工作，或者与我们探讨移动端开发与机器学习方面的问题。同时，你可以关注我们的 [Twitter](https://twitter.com/fritzlabs) 和 [LinkedIn](https://www.linkedin.com/company/fritz-labs-inc/) 来获取所有最新内容，更多来自移动机器学习世界的东西。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
