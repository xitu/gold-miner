> * 原文地址：[Using Swift’s Enums for Quick Actions](https://medium.com/the-traveled-ios-developers-guide/using-swifts-enums-for-quick-actions-a08c0f6d5b8b#.lbt8itrxd)
* 原文作者：[Jordan Morgan](https://medium.com/@JordanMorgan10?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[DeadLion](https://github.com/DeadLion)
* 校对者：[Graning](https://github.com/Graning), [cbangchen](https://github.com/cbangchen)

# 用 Swift 枚举完美实现 3D touch 快捷操作

#### 完美实现 3D Touch 

我不确定是否一开始 Swift 的创造者们能够估计到他们创造的这一门极其优美的语言，将带给开发者们如此激昂的热情。 我只想说，Swift 社区已经成长且语言已经稳定（ISH）到一个地步，现在甚至有个专有名词赞美 Swift 编程的美好未来。

_Swifty._

> “That code isn’t Swifty”. “This should be more Swifty”. “This is a Swifty pattern”. “We can make this Swifty”.（反正就是漂亮，美得让人窒息之类的话）

这些赞扬的话还会越来越多。虽然我不太提倡说这些赞赏的话语，但是我真的找不到其它可以替代的话来夸赞，用 Swift 为 3D touch 编写快捷操作的那种“美感”。

这周，让我们来看看在 [UIApplicationShortcutItem](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationShortcutItem_class/) 实现细节中，Swift 是如何让我们成为 “一等公民” 的。

#### 实现方案

当一个用户在主屏开始一个快捷操作时，会发生下面两件事中的一个。应用程序可以调用指定的函数来处理该快捷方式，或快速休眠再启动 — — 这意味着最终还是通过熟悉的 didFinishLaunchingWithOptions 来执行。

无论哪种方式，开发人员通常根据  UIApplicationShortcutItem 类型属性来决定用哪种操作。

```
if shortcutItem.type == "bundleid.shortcutType"
{
    //Action triggered
}
```

上面代码是正确的，项目中只是用一次的话还是可以的。

可惜的是，即便在 Swiftosphere**™** 中，switch 条件用字符串实例有额外好处的情况下，随着增加越来越多的快捷操作，这种方法还是很快令人觉得十分繁琐。同时它也被大量证明，对于这种情况使用字符串字面值可能是白费功夫：

```
if shortcutItem.type == "bundleid.shortcutType"
{
    //Action triggered
}
else if shortcutItem.type == "bundleid.shortcutTypeXYZ"
{
    //Another action
}
//and on and on
```

处理这些快捷操作就像你代码库的一小部分，尽管如此—— Swift 能处理的更好而且更安全些。所以，让我们看看 Swift 如何发挥它的“魔法”，给我们提供一个更好的选择。

#### Enum .Fun

讲真， Swift 的枚举很“疯狂”。当 Swift 在 14 年发布的时候，我从来没有想过在枚举中可以使用属性，进行初始化和调用函数，但现在我们已经在这样子做了。

不管怎么说，我们可以在工作中用上它们。当你考虑支持 UIApplicationShortcutItem 的实现细节时，几个关键点应该注意：

*  必须通过 _type_ 属性给快捷方式指定一个名称
*  根据苹果官方指南，必须以 bundle id 作为这些操作的前缀
*  可能会有多个快捷方式
*  可能会在应用程序多个位置采取基于类型的特定操作

我们的游戏计划很简单。我们不采用硬编码字符串字面量，而是初始化一个枚举实例来表示这就是被调用的快捷方式。

#### 具体实现

我们虚构两个快捷方式，每个都额外附加一个之后，现在就是由一个枚举表示。

```
enum IncomingShortcutItem : String
{
    case SomeStaticAction
    case SomeDynamicAction
}
```

如果是用 Objective-C，我们可能到这就结束了。我认为，使用枚举远远优于之前使用字符串字面量的观点，已经被大家所接受。然而，对于为应用每个操作类型属性指定 bundle id 为前缀（例如，com.dreaminginbinary.myApp.MyApp）来说，使用一些字符串插值仍是最佳解决办法。

但是，因为 Swift 枚举超级厉害，我们可以用它以一种非常简洁的方法来实现：

```
enum IncomingShortcutItem : String
{
    case SomeStaticAction
    case SomeDynamicAction
    private static let prefix: String = {
        return NSBundle.mainBundle().bundleIdentifier! + "."
    }()
}
```

看！厉害吧！我们能安全的从计算属性中获取应用的包路径。回忆起上个星期的[一篇文章](https://medium.com/the-traveled-ios-developers-guide/swift-initialization-with-closures-5ea177f65a5#.ar2zxzrfc)，在介绍闭包的最后提到了插入值，我们希望将_前缀_分配给闭包的返回语句，并不是闭包本身。

#### 最佳模式


最终方案，将用上两个我们最喜爱的 Swift 功能。那就是为枚举创建一个可能会失败的初始化函数的时候，使用 guard 语句清除空值以确保安全。

```
enum IncomingShortcutItem : String
{
    case SomeStaticAction
    case SomeDynamicAction
    private static let prefix: String = {
        return NSBundle.mainBundle().bundleIdentifier! + "."
    }()

    init?(shortCutType: String)
    {
        guard let bundleStringRange = shortCutType.rangeOfString(IncomingShortcutItem.prefix) else
        {
            return nil
        }
        var enumValueString = shortCutType
        enumValueString.removeRange(bundleStringRange)
        self.init(rawValue: enumValueString)
    }
}
```

这个允许失败的初始化是很重要的。如果没有匹配到快捷操作对应的字符串，应该跳出。它还能告诉我，如果我是维护者，当该使用它的时候，它可能更适合使用 guard 语句。

我特别喜欢这部分，这也是我们如何能够利用枚举 _rawValue_ 的优势，且很容易把它拼接到包路径上。这一切都在正确的地方，一个初始化函数的内部。

别忘了，一旦其初始化，我们还可以当枚举来用的。这意味着我们会有一个可读很高的 switch 语句，后面有些反对的理由。

下面可能是最终产品的样子，所有的东西都集成进来了，与线上应用相比略有删减：

```
static func handleShortcutItem(shortcutItem:UIApplicationShortcutItem) -> Bool
{
    //Initialize our enum instance to check for a shortcut
    guard let shortCutAction = IncomingShortcutItem(shortCutType: shortcutItem.type) else
    {
        return false
    }
    //Now we've got a valid shortcut, and can use a switch
    switch shortCutAction
    {
        case .ShowFavorites:
            return ShortcutItemHelper.showFavorites()
        case .ShowDeveloper:
            return ShortcutItemHelper.handleAction(with: developer)
    }
}
```


至此，通过使用这种模式，我们的快捷操作变的可分类和内容安全，这也是我为什么这么喜欢它的原因。在方法的末尾提供一个最终的 “return false” 语句其实没什么必要（甚至在 switch 语句中是默认启动），因为我们已经十分了解，最后给代码精简一下。

和之前的代码比较一下：

```
static func handleShortcutItem(shortcutItem:UIApplicationShortcutItem) -&gt; Bool
{
    //Initialize our enum instance to check for a shortcut
    let shortcutAction = NSBundle.mainBundle().bundleIdentifier! + "." + shortcutItem.type

    if shortCutAction == "com.aCoolCompany.aCoolApp.shortCutOne"
    {
        return ShortcutItemHelper.showFavorites()
    }
    else if shortCutAction == "com.aCoolCompany.aCoolApp.shortCutTwo"
    {
         return ShortcutItemHelper.handleAction(with: developer)
    }
    return false
}
```


真的，这看起来比用 switch 简单点。但我之前见过很多类似的代码（当然是我自己写的啦），虽然能很好的运行，但我认为可以利用 Swift 特性的优势，写出更好的代码。

#### 最后的感想


当我刚开始阅读 Swift 枚举的返回时，发现它们有点“重”。有类的 inits()，为什么我还要枚举符合协议，这看起来有点多余。多年以后，我想这种模式已经充分展示了为什么就是这样的原因。

当我看到苹果实现了这种模式，确实很开心。我觉得这是个非常好的方式来解决一个小问题，同时对于快捷操作的实现细节来说也是个“团队友好”的方法。我认为他们也会同意我的观点，毕竟这种方式也在他们两个 3D touch 示例项目中。

下次再见👋
