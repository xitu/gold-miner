> * 原文地址：[Structuring Your iOS App for Split Testing](https://heartbeat.fritz.ai/structuring-your-ios-app-for-split-testing-178eacf5aa7c)
> * 原文作者：[Arlind Aliu](https://medium.com/@arlindaliu.dev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/structuring-your-ios-app-for-split-testing.md](https://github.com/xitu/gold-miner/blob/master/TODO1/structuring-your-ios-app-for-split-testing.md)
> * 译者：
> * 校对者：

# Structuring Your iOS App for Split Testing

![](https://cdn-images-1.medium.com/max/3000/1*WZf4olsps6kCjyVj0PM7JA.jpeg)
> Split testing is a method of determining which variation of an application performs better for a given goal.
>
> Multiple variants or behaviors of an application are distributed in a random manner. After statistics gathering and analysis, we determine which version performs better.

The goal of this article is to provide a simple way of structuring and organizing your application in order to achieve clean and scalable iOS code when using split testing.

Practical tips and examples are provided in order for this article to stay as a guideline for real-world app scenarios.

## General Problems

Using split testing (also known as an A/B testing), we have endless possibilities for what to test. But in general, we can group the changes needed regarding a split test in the following order:

 1. **Content Changes:** Changing only specific parts in a given view or adding/removing specific content based on the given test.

 2. **Design Changes:** Testing how changes like colors, typography, or layout can affect our users’ behaviors.

 3. **Behavioral Changes:** Changing the behavior of a button action or a screen presentation depending on the split group

The problem is that in all of these categories, huge code duplications can arise.

We need a way to create an easily maintainable code structure for the tests—this is because we’ll have continuous requirements for adding new tests and dropping or modifying old ones. Therefore, we should design with scalability in mind.

## Creating a Split Testing Manager

We’ll try to create a generic reusable solution that we could use for our change categories described above.

We’ll first create a protocol that defines the rules to which an object has to conform in order to represent a split test:

```Swift
protocol SplitTestProtocol {
    associatedtype ValueType: Any
    static var identifier: String {get}
    var value: ValueType {get}
    init(group: String)
}
```

The `value` field will represent a generic value that’ll be implemented by a concrete Split Testing Object. It will correspond to a color, font, or any attribute that we’re testing for our target goal.

Our `identifier` will simply be a unique identifier for our test.

Our `group` will represent which value of the test is currently being tested. It can be `a` and `b` or `red` and `green`. This all depends on the naming of the values that are decided for a given test.

We’ll also create a manager that’s responsible for getting the value of our split test based on the group stored in our database related to the testing identifier:

```Swift
class SplitTestingManager {
    static func getSplitValue<Value: SplitTestProtocol>(for split: Value.Type) -> Value.ValueType {
        let group = UserDefaults.standard.value(forKey: split.self.identifier) as! String
        return Value(group: group).value
    }
}
```

## Content Changes

![[https://dribbble.com/shots/5805125-Book-Reading-App](https://dribbble.com/shots/5805125-Book-Reading-App)](https://cdn-images-1.medium.com/max/3200/1*k8Pv6wbdmPGWJMx-R-mZOQ.png)

Suppose that we’re working on a reading application and we decide to give users a free e-book.

Our marketing team has decided to create a split test for giving the book by first asking the users to either:

**Share our app on social media**

or

**Subscribe to our newsletter**

Both of these two cases use the same view controller, but a part of the design changes based on the given case. In our view controller, we’ll create a content view area where we’ll be adding different content views.

In this case, we need to create two different views: one for social share and one for the newsletter and add them respectively to our view controller’s content defined area.

Let’s first create an object that holds our view controller style and pass it in the view controller’s initializer:

```Swift
struct PromotionViewControllerStyle {
    let contentView: String
}
```

```Swift
init(style: PromotionViewControllerStyle) {
    self.style = style
    super.init(nibName: nil, bundle: nil)
}
```

Basically, the style object currently holds the xib name for the content view of our `PromotionViewController`.

We can create our Test Object that conforms to our `SplitTestProtocol`:

```Swift
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

We can now easily present our view controller with either newsletter or social share content based on our split test:

```Swift
@IBAction func presentNextVc(_ sender: UIButton) {
    let style = SplitTestManager.getSplitValue(for: EBookPromotionSplitTest.self)
    let vc = PromotionViewController(style: style)
    self.present(vc, animated: true)
}
```

```Swift
func addContentView() {
    let nib = UINib(nibName: style.contentView, bundle: nil)
    let view = nib.instantiate(withOwner: nil, options: nil)[0] as! UIView
    contentView.addSubview(view)
    view.bindFrameToSuperviewBounds()
}
```

## Design Changes

Usually, in e-commerce-based applications, it’s popular to change the call to action button design, i.e an `add to cart` button or `purchase` button to make it more appealing to the users so it gets more clicks.

![[https://dribbble.com/shots/5546168-Gate-B](https://dribbble.com/shots/5546168-Gate-B)](https://cdn-images-1.medium.com/max/3200/1*FHM9s3d34M386PQeH10DCg.png)

We can always use any object of our need for our splitting manager. In this case, suppose we need an object that holds our purchase button color as a value:

```Swift
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

and we can use it simply from our view as follows:

```Swift
let color = SplitTestManager.getSplitValue(for: PurchaseButtonColorSplitTest.self)
purchaseButton.backgroundColor = color
```

Similarly, any other attributes can be tested, like fonts and margins or any other attribute that needs to change based on our testing.

## Behavioral changes

Let’s suppose that we decide to split users into two groups regarding subscriptions in our app:

![[https://dribbble.com/shots/5058686-Potted-In-app-Purchases](https://dribbble.com/shots/5058686-Potted-In-app-Purchases)](https://cdn-images-1.medium.com/max/3200/1*xmhmJIL8hSlkxhugjPgDog.png)

We want to either

**Present a discount dialog when opening the IAP view**

or

**Present a default view without any dialog**

We’ll be using the Strategy Pattern for this example to handle the discount presentation base in our strategy.
> The strategy pattern is a design pattern used to create an interchangeable group of algorithms from which the required one is chosen at run-time.

Since our `SplitTestProtocol` contains a generic value, we can create the split testing object that will hold the strategy as its value:

```Swift
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

We can then initialize and present our view controller depending on the specific strategy:

```Swift
init(discountStrategy: DisountStrategy) {
    self.discountStrategy = discountStrategy
    super.init(nibName: nil, bundle: nil)
}
```

```Swift
func presentDiscoutViewController() {
    let strategy = SplitTestManager.getSplitValue(for: DiscountSplitTest.self)
    let viewController = DiscountViewController(discountStrategy: strategy)
    self.present(viewController, animated: true)
}
```

We now can easily pass our discount responsibility to the `DiscountStrategy` object and scale it based on our needs without having to change anything in our view controller’s code:

```Swift
protocol DisountStrategy {
    func presentDiscountMessage()
}

struct NoDiscountStrategy: DisountStrategy {
    //Provides handling for non discount case
}

struct DefaultDiscountStrategy: DisountStrategy {
    //Provides handling for discount case
}
```

```Swift
override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    discountStrategy.presentDiscountMessage()
}
```

## General Tips

While doing split testing, it’s important to always be careful regarding the following points:

 1. Always using **caching** for the test values in order for the app to stay consistent for the user.

 2. **Clean up** the code after one specific test is finished. Remove views, fonts, images, and whatever resources you added in the project for the split test.

 3. Make sure that if something goes wrong you have control over and can **disable** the A/B test.

## In Conclusion

Split testing (also known as A/B testing) is a powerful and effective tool for our apps, but it can easily create messy code if we’re not careful with our code design.

In this article, we’ve created a generic solution that can manage our split testing logic. We gave some real-world app examples and practical tips in order for this article to work as a guide when implementing split testing for your iOS applications.

If you enjoyed this article make sure to **clap** to show your support.

**[Follow me](https://medium.com/@arlindaliu.dev)** to view many more free articles that can take your iOS skills to the next level.

If you have any questions or comments feel free to leave a note here or email me at [arlindaliu.dev@gmail.com](http://arlindaliu.dev@gmail.com).

***

**Editor’s Note: Ready to dive into some code? Check out [Fritz on GitHub](https://github.com/fritzlabs). You’ll find open source, mobile-friendly implementations of the popular machine and deep learning models along with training scripts, project templates, and tools for building your own ML-powered iOS and Android apps.**

**Join us on [Slack](https://join.slack.com/t/heartbeat-by-fritz/shared_invite/enQtNTI4MDcxMzI1MzAwLWIyMjRmMGYxYjUwZmE3MzA0MWQ0NDk0YjA2NzE3M2FjM2Y5MjQxMWM2MmQ4ZTdjNjViYjM3NDE0OWQxOTBmZWI) for help with technical problems, to share what you’re working on, or just chat with us about mobile development and machine learning. And follow us on [Twitter](https://twitter.com/fritzlabs) and [LinkedIn](https://www.linkedin.com/company/fritz-labs-inc/) for all the latest content, news, and more from the mobile machine learning world.**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
