> * 原文地址：[Localize Swift Application](https://levelup.gitconnected.com/localize-swift-application-f1fd0f4af800)
> * 原文作者：[Dmytro Pylypenko](https://medium.com/@dimpiax)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/localize-swift-application.md](https://github.com/xitu/gold-miner/blob/master/TODO1/localize-swift-application.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[Bruce-pac](https://github.com/Bruce-pac)

# 如何运用 Swift 的属性包装器实现应用本地化

![](https://cdn-images-1.medium.com/max/4800/1*SjXk6V6r3e94guJcg5mRzw.png)

您好，Swift 开发者，在本文中，我想与您分享我的经验和知识，主要内容有**属性包装器**（**Property Wrapper**）的使用，以及如何简化代码并使其易于维护。我会通过几个主题对此进行说明。

在 Swift 5.1 中，Apple 引入了**属性包装器**，它可以让我们在属性和访问逻辑（getter 和 setter）之间设置中间层。

下面的内容是在 `@IBOutlet` 变量内部使用**属性包装器**的简便方法来实现应用本地化。

---

优化下面这个**基础**版本：

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

我们可以用**属性包装器** `@Localized` 改进代码，如下：

```Swift
class NatureViewController: UIViewController {
  @Localized("natureTitle")
  @IBOutlet private var label: UILabel!
  
  @Localized("saveNatureButton")
  @IBOutlet private var button: UIButton!
}
```

这代码看起来很优雅，不是吗？下面让我们创建 `@Localized` 属性包装器。
将 key 当做枚举来使用会更好，如：`@Localized(.natureTitle)`。

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

为了能让更多的类型能够支持 `Localizable` 协议，
我们要实现 `UILabel` 和 `UIButton` 的扩展方法。

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

最后我们只需要实现 `LocalizationKey`:

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

我们可以直接用 raw 的值来表示相应的 key，`String` 类型默认遵守这个协议，所以只需要枚举中的值与 `Localizable.strings` 中的 key 保持一致就可以了。

最终的代码如下：

```Swift
class NatureViewController: UIViewController {
  @Localized(.natureTitle)
  @IBOutlet private var label: UILabel!
  
  @Localized(.saveNatureButton)
  @IBOutlet private var button: UIButton!
}
```

---

本章结束！关于 `@Localized` 还有一些潜在功能：

* 格式化字符串数据，并进行动态替换。
* 能够确定来自指定的表单和资源包的字符串。

**想了解更多关于属性包装器的知识，请阅读官方文档：**
[**Properties - The Swift Programming Language (Swift 5.2)**](https://docs.swift.org/swift-book/LanguageGuide/Properties.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
