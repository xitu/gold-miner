> * 原文地址：[User Defaults in Swift](https://levelup.gitconnected.com/user-defaults-in-swift-dfe228f684c6)
> * 原文作者：[Yafonia Hutabarat](https://medium.com/@yafonia)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/user-defaults-in-swift.md](https://github.com/xitu/gold-miner/blob/master/article/2020/user-defaults-in-swift.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[chaingangway](https://github.com/chaingangway)

# 在 Swift 使用 User Defaults 的小技巧

![](https://cdn-images-1.medium.com/max/2560/0*6_KzN8_SEi_uf5vh.jpg)

所有 iOS 应用程序都具有内置的数据字典，在安装应用程序后，该字典可以存储少量用户设置的相关数据。这套机制叫做 UserDefault。

## User Defaults 是什么?

根据 Apple 的文档，UserDefaults 是用户默认数据库的接口，您可以对在程序启动期间的键值对进行持久化存储。

UserDefault 可以存储整数、布尔值、字符串数组、字典、日期和更多类型，但是不要保存太多数据，因为这会减慢程序的启动速度。

UserDefaults 就类似一个包含键值对的字典。例如：

```swift
var dict = [
    "Name": "Yafonia",
    "Age" : 21,
    "Language": "Indonesian"
]
```

User defaults 保存在 `.plist` 文件中，而在本例中我们保存在 `Info.plist` 文件里。

![UserDefaults on Info.plist file](https://cdn-images-1.medium.com/max/3480/1*mXhXVzPFqU0cfmsmbrqWJA.png)

## 什么时候使用 User Defaults

User Defaults 最好用来存储简单的数据片段。如果需要存储多个对象，你最好使用专业的数据库。下面是在 UserDefaults 存储简单数据片段的例子：

* 用户信息，比如姓名、邮箱地址、年龄、职业
* App 设置，比如界面语言，app 主题颜色或者字体
* 标记（isLoggedIn 用来检查用户是否登录等等。）

## 在 User Defaults 存储数据

我们可以在 UserDefaults 存储多种变量类型：

* 布尔值用 `Bool` 类型、整数值用 `Int` 类型、单精度浮点数用 `Float` 类型、双精度浮点数用 `Double` 类型
* 字符串用 `String` 类型、二进制数据用 `Data` 类型、[日期用 Date 类型](https://learnappmaking.com/swift-date-datecomponents-dateformatter-how-to/)、链接用 `URL` 类型
* 集合用 `Array` 和 `Dictionary` 类型

在 `UserDefaults` 的内部只能存储 `NSData`、`NSString`、`NSNumber`、`NSDate`、`NSArray` 和 `NSDictionary` 这些类型的数据。

例如，在这个项目中，我想保存几个帐户信息，例如电子邮件，代码，名称，令牌和 UserID。因此，我将 loginResponse 中的值设置为这些键 （Email、LawyerCode、LayererName、Token、UserID）的值。所有值都是字符串。

![](https://cdn-images-1.medium.com/max/2000/1*Ib1Wh7T8llBLq50fMuVfrA.png)

![](https://cdn-images-1.medium.com/max/3040/1*yudXhvkyriw_lS1efU3o6Q.png)

除了账户信息，还有一个叫做 `"Token"` 的 key，它用于校验登录信息。如果这个 key 有值，证明这个用户是登录的，反之亦然。你也可以使用标志位，比如命名一个叫做 `"isLoggedIn"` 的 `boolean` 值。

## 在 User Defaults 获取数据

在 User Defaults 中获取数据就像保存数据一样简单。让我们看下面的例子。

![Account page on my project](https://cdn-images-1.medium.com/max/2000/1*iddCb3-eth4W0BcpQITCVA.png)

在上面的页面中，我需要帐户名称（例如：lawyer_staging）和电子邮件（例如：lawyer_staging@justika.com），并以 `"Email"` 和 `"LawyerName"` 为键将其保存在 User Defaults 中。因此，这是我们要做的：

![](https://cdn-images-1.medium.com/max/2424/1*I1RNdSsvWvQxwj8tqFeYww.png)

要显示帐户的名称和电子邮件，您只需将标签的文本设置为从 UserDefaults 获取的数据即可。是的，就是这么简单！

## 在 User Defaults 重置数据

也许您一直在想，之前我没有使用标志来存储登录信息，那么当用户未登录时会怎样？

如果用户已注销，我们可以在 User Default 中重置键和值，如下：

![](https://cdn-images-1.medium.com/max/2496/1*TGG_S-wQRAm_W7zCJyXNzg.png)

当用户单击 “Keluar” 按钮时，我们重置 User Defaults 中所有的键和登录信息值。用户登录后，将在 User Defaults 中再次设置键和值。

## 在 User Defaults 设置界面语言

如上所述，我们还可以在 User Defaults 中保存像界面语言这样的应用设置。例如，字体信息保存在 User Defaults 中。

![Info.plist](https://cdn-images-1.medium.com/max/3508/1*Ixk7iG6wdvGSWCx8ciyWhA.png)

在上图中，您可以看到有一个名为 “Fonts provided by application” 的键，这是我们保存字体的地方。

## 总结

在本文中，我们轻松地使用 User Defaults 以字符串，布尔值，整数，数组，字典，日期等形式保存简单的数据，例如用户信息，应用设置和标志等等。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
