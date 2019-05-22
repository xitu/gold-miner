> - 原文地址：[Swift 5 Frozen enums](https://useyourloaf.com/blog/swift-5-frozen-enums)
> - 原文作者：[Keith Harrison](https://useyourloaf.com)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swift-5-frozen-enums.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swift-5-frozen-enums.md)
> - 译者：
> - 校对者：

# Swift 5 Frozen enums

Are you upgrading an Xcode project to Swift 5? It’s a mostly pain-free experience, but you might hit a warning about switching on enums with additional unknown values.

### Additional unknown values warning

What’s the problem? Here’s a code snippet that I might use to adapt a layout for different size classes. It switches on **all the possible values** of the `UIUserInterfaceSizeClass` enum:

```swift
func configure(for sizeClass: UIUserInterfaceSizeClass) {
   switch sizeClass {
     case .unspecified:
        // ...
     case .compact:
        // ...
     case .regular:
        // ...
      }
}
``` 

With the Swift Language Version of my project set to Swift 5, Xcode rewards me with a warning:

![additional unknown values warning](https://useyourloaf.com/assets/images/2019/2019-04-05-001.png)

The warning in full:

> Switch covers known cases, but `UIUserInterfaceSizeClass` may have additional unknown values, possibly added in future versions
> 
> Handle unknown values using “@unknown default”

If you accept the fix, Xcode adds an extra `@unknown default:` case:

```swift
switch sizeClass {
    case .unspecified:
        // ...
    case .compact:
        // ...
    case .regular:
        // ...
    @unknown default:
        fatalError()
}   
``` 

You can change the `fatalError()`, but what does it mean?

### Frozen and non-frozen enums

**A Swift `switch` expression must be exhaustive or include a default catch-all case.** My original switch statement was exhaustive for all values of the `UIUserInterfaceSizeClass` enum defined by Apple in the version of the `UIKit` framework shipped with iOS 12.

What happens if Apple introduces a `.tiny` or a `.large` size class in iOS 13? When you build with the updated SDK the compiler complains the switch is no longer exhaustive. One way to satisfy the compiler is to include a `default:` case. I could rewrite my switch statement:

```swift
switch sizeClass {
   case .compact:
      // do the compact thing
   default:
      // do the regular thing by default
      // even for future unknown sizes.
  }
``` 

The switch is no longer exhaustive but it handles all known and future unknown cases. That’s fine, but there are advantages to the compiler, and for library binary compatibility when it knows at compile-time, a switch is exhaustive. You might also want the warning when an enum gets a new case when upgrading.

The Swift evolution proposal [SE-0192](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md) adds the `@unknown default:` syntax to allow you continue to use an exhaustive switch with a catch-all case for any future cases:

```swift
switch sizeClass {
    case .unspecified:
        // ...
    case .compact:
        // ...
    case .regular:
        // ...
    @unknown default:
        // ...
}
``` 

**The `@unknown default:` case can only be used with exhaustive enums and matches any new cases added to the enum.** It also still produces a compiler warning for those new cases so you can decide what action to take. This is different from using `default:` with a non-exhaustive enum which silently swallows the new cases.

#### Frozen enums

The change also adds the concept of a **frozen enum** which is not intended to get any new cases. It only applies to C, or Objective-C, enums imported to Swift. One example from the standard library is `ComparisonResult`. This is the Objective-C definition:

```swift
typedef NS_CLOSED_ENUM(NSInteger, NSComparisonResult) {
   NSOrderedAscending = -1L,
   NSOrderedSame,
   NSOrderedDescending
};
``` 

There are only three possible results for comparison so this enum should never change. Note the `NS_CLOSED_ENUM` annotation instead of the usual `NS_ENUM`. We don’t need an `@unknown default` case in Swift 5 if we make our switch exhaustive:

```swift
let result: ComparisonResult = ...
switch result {
    case .orderedAscending:
      // ...
    case .orderedSame:
      // ...
    case .orderedDescending:
      // ...
}
``` 

If the library author adds a new case to a frozen enum, the compiler complains about any exhaustive switches on that enum.

### Not yet frozen?

I don’t know if Apple plans to annotate any of the enums in `UIKit` and related frameworks. Most are likely to be non-frozen, but there are some cases where frozen might make sense.

For example, the stack view axis is a `UILayoutConstraintAxis` enum which is still non-frozen in iOS 12. Here’s the Objective-C header file (note the `NS_ENUM`):

    typedef NS_ENUM(NSInteger, UILayoutConstraintAxis) {
      UILayoutConstraintAxisHorizontal = 0,
      UILayoutConstraintAxisVertical = 1
    };
    

This means if you want to switch on the stack view axis you need to allow for a future possibility that is not horizontal or vertical:

```swift
switch stackView.axis {
   case .horizontal:
        // ...
	case .vertical:
        // ...
  @unknown default:
        // ...
}
``` 

Maybe Apple will change this to an `NS_CLOSED_ENUM,` or perhaps stack views will get a third-axis in iOS 13?

### What do I need to do?

*   Firstly, nothing changes for your own Swift enums. You don’t need to start sprinkling `@unknown default:` over your code when you migrate to Swift 5. Xcode warns you where you need to take action.
*   This change only matters for C-style enums found in the standard library and other frameworks.
*   If your switch includes a `default:` case then nothing changes.
*   An exhaustive switch over a C-style non-frozen enum including all known cases (no `default:`) is a warning in Swift 5.
*   Accept the Xcode fix-it to add an `@unknown default:` case and silence the warning.

### Read more

See the Swift evolution proposal for more details:

*   [SE-0192 Handling Future Enum Cases](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


