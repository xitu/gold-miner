> * 原文地址：[Using Swift’s Enums for Quick Actions](https://medium.com/the-traveled-ios-developers-guide/using-swifts-enums-for-quick-actions-a08c0f6d5b8b#.lbt8itrxd)
* 原文作者：[Jordan Morgan](https://medium.com/@JordanMorgan10?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


#### Makin’ 3D Touch All “Swifty” Up In Here

I’m not sure if Swift’s forefathers could’ve estimated the passion and fervor its future developers would hold for the very language they were crafting. Suffice to say, the community has grown and the language has stabilized(ish) to a point where we even have a term now to bestow upon code that displays Swift in all of its intended glory:

不知道发明 Swift 的人是否会料到他们正在编写的语言，未来会深受开发者的青睐。 我只想说，Swift 社区已经成长且语言已经稳定（ISH）到一个地步，现在甚至有个专有名词赞美 Swift 编程的美好未来。

_Swifty._

> “That code isn’t Swifty”. “This should be more Swifty”. “This is a Swifty pattern”. “We can make this Swifty”.

这些赞扬的话还会越来越多。虽然我不太提倡说这些赞赏的话语，但是我真的找不到其它可以替代的话来夸赞，用 Swift 为 3D touch 编写快捷操作的那种“美感”。

这周，让我们来看看 在 [UIApplicationShortcutItem](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationShortcutItem_class/) 实现细节中，Swift 是如何让我们成为 “一等公民” 的。

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

可惜的是，随着增加越来越多的快捷操作，即便在 Swiftosphere**™** 中，switch 条件用字符串实例有额外好处的情况下，这种方法很快就会变得十分繁琐。它也被大量证明，对于这种情况使用字符串字面值可能是白费功夫：

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

处理这些快捷操作就想你代码库的一小部分，尽管如此——Swift 能处理的更好而且更安全些。所以，让我们看看 Swift 如何发挥它的“魔法”，给我们提供一个更好的选择。

#### Enum .Fun

恕我直言， Swift 的枚举很“疯狂”。当 Swift 在 14 年发布的时候，我从来没想过它们能用属性、初始化程序和功能，但是我们现在已经在用了。

不管怎么说，我们可以在工作中用上它们。当你考虑支持 UIApplicationShortcutItem 的实现细节时，几个关键点应该注意：

*  必须通过 _type_ 属性给快捷方式指定一个名称
*  根据苹果官方指南，必须给这些操作绑定标示符前缀
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

With Objective-C, we may have stopped there. I’d submit it’s widely accepted that just having the enum cases is far superior to the String literals we had before. However, some String interpolation would still come in to play as its also best practice to prefix your app’s bundle identifier to each action’s type property (i.e. com.dreaminginbinary.myApp.MyApp).

如果是用 Objective-C，我们可能到这就结束了。我认为，使用枚举远远优于之前使用字符串文字的观点，已经被大家所接受。然而，为应用每个操作类型属性绑定标识符前缀（例如，com.dreaminginbinary.myApp.MyApp）来说，使用一些字符串插值仍是最佳解决办法。

But — since Swift’s enums have superpowers, we can implement this in a very tidy fashion:

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

Ah — nice! We’ve got our app’s bundle identifier tucked away safely in a computed property. [Recall from last week](https://medium.com/the-traveled-ios-developers-guide/swift-initialization-with-closures-5ea177f65a5#.ar2zxzrfc) that including the parenthesis at the end of the closure signifies that we wish to assign _prefix_ to the closure’s return statement, and not the closure itself.

#### The Cherry on Top

To finalize the pattern, we’ll make use of two of my dearest Swift features. That is, creating a failable initializer for an enumeration, and using a guard statement to enforce safety and promote clear intent.

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


The failable initializer is important. If there isn’t a matching short cut action corresponding to the given String, we should bail out. It also tells me, if I was the maintainer, that it might lend itself well to a guard statement when the time comes to use it.

The part I especially adore, though, is how we’re able to take advantage of the enum’s _rawValue_ and easily tack it on to our bundle identifier. It’s all housed right where it needs to be, inside of an initializer.

Lest we forget, once its initialized we can also use it for what it is — a enum. That means we’ll have a very readable switch statement with which to reason against later on.

Here is what the final product might look like when it all comes together, slightly abbreviated from a production app:

```
static func handleShortcutItem(shortcutItem:UIApplicationShortcutItem) -&gt; Bool
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


Here, our short cut actions become typed and we promote clear intent using this pattern, which is why I quite like it. It’s also unnecessary to provide a final “return false” statement at the end of the method (or even a _default_within the switch statement to boot) since we’re already exhaustive, which is an added culling of the proverbial code fat.

Contrast this from before:

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


True, this could be made a little easier on the eyes with a switch. But I’ve seen similar code abundant before (I’ve certainly written it 🙈), and while it works — I think it illustrates how we can leverage Swift’s features to our advantage. To make our code _that_ much better.

#### Final Thoughts

When I first started reading about enums in Swift way back when, I found them to be a bit heavy handed. Why do I need enums to be able to conform to protocols, have first class inits(), etc. It just seemed a bit much. Years later, though, I believe patterns like this really show why that is.

When I saw Apple implement this pattern, I indeed got 😍. I think this is a great way to solve a small problem, as its a very “team friendly” approach to the implementation details of short cut actions. I would assume they tend to agree, as its included in two of their sample projects showcasing 3D touch.

Until .NextTime 👋
