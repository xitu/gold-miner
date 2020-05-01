> * 原文地址：[Localize Swift Application](https://levelup.gitconnected.com/localize-swift-application-f1fd0f4af800)
> * 原文作者：[Dmytro Pylypenko](https://medium.com/@dimpiax)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/localize-swift-application.md](https://github.com/xitu/gold-miner/blob/master/TODO1/localize-swift-application.md)
> * 译者：
> * 校对者：

# Localize Swift Application

![](https://cdn-images-1.medium.com/max/4800/1*SjXk6V6r3e94guJcg5mRzw.png)

Hello Swift developers, I want to share with you my experience and knowledge about using **Property Wrappers** in an application and how to reduce your code and make it easier to maintain. I will write about this in several topic parts.

In Swift 5.1, Apple introduced **Property Wrappers**, which gives the possibility to set up additional layer between your property and serving logic.

This part is about how to localize your application using **Property Wrappers** and simple way within `@IBOutlet`.

---

So, instead of the **basic** case:

```Swift
class NatureViewController: UIViewController {
  @IBOutlet private var label: UILabel! {
    didSet {
      label.title = NSLocalizedString("natureTitle", comment: "")
    }
  }
  
  @IBOutlet private var button: UIButton! {
    didSet {
      button.setTitle(NSLocalizedString("saveNatureButton", comment: ""), for: .normal)
    }
  }
}
```

We can improve the code with **property wrapper** `@Localized`, and have:

```Swift
class NatureViewController: UIViewController {
  @Localized("natureTitle")
  @IBOutlet private var label: UILabel!
  
  @Localized("saveNatureButton")
  @IBOutlet private var button: UIButton!
}
```

It looks pretty, doesn’t it? So let’s create `@Localized` property wrapper.
It will be good to apply key as enum, to have: `@Localized(.natureTitle)`

```Swift
@propertyWrapper
struct Localized<T: Localizable> {
  private let key: LocalizationKey
  
  var wrappedValue: T? = nil {
    didSet {
      wrappedValue?.set(localization: key)
    }
  }
  
  init(_ key: LocalizationKey) {
    self.key = key
  }
}
```

And be able to apply for any that conforms `Localizable` protocol.
To achieve our goal, we will extend also `UILabel` and `UIButton`.

```Swift
protocol Localizable {
  func set(localization: LocalizationKey)
}

extension UIButton: Localizable {
  func set(localization key: LocalizationKey) {
    setTitle(key.string, for: .normal)
  }
}

extension UILabel: Localizable {
  func set(localization key: LocalizationKey) {
    text = key.string
  }
}
```

And the final thing that we need is `LocalizationKey`:

```Swift
enum LocalizationKey: String {
  case 
  natureTitle, 
  saveNatureButton
}

extension LocalizationKey {
  var string: String {
    NSLocalizedString(rawValue, comment: rawValue)
  }
}
```

As our enum is raw representable, as a `String` conforms to the protocol, it’s enough just to have `Localizable.strings` with the same keys for values.

So in the end our code looks like:

```Swift
class NatureViewController: UIViewController {
  @Localized(.natureTitle)
  @IBOutlet private var label: UILabel!
  
  @Localized(.saveNatureButton)
  @IBOutlet private var button: UIButton!
}
```

---

That’s all in this part! Here are some potential ideas that `@Localized` can contain:

* applying format values with strings for dynamic replacement.
* be able to determine strings from a specific table and bundle.

**More about Property Wrapper read in the official documentation:**
[**Properties - The Swift Programming Language (Swift 5.2)**
**Properties associate values with a particular class, structure, or enumeration. Stored properties store constant and…**docs.swift.org](https://docs.swift.org/swift-book/LanguageGuide/Properties.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
