> - 原文地址：[Swift 5 Frozen enums](https://useyourloaf.com/blog/swift-5-frozen-enums)
> - 原文作者：[Keith Harrison](https://useyourloaf.com)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swift-5-frozen-enums.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swift-5-frozen-enums.md)
> - 译者：[iWeslie](https://github.com/iWeslie)
> - 校对者：[Lobster-King](https://github.com/Lobster-King)

# Swift 5 中的枚举冻结

你是否已经将你的 Xcode 工程升级到了兼容 Swift 5？升级 Swift 5 基本不会有大问题，但当你用 switch 语句去枚举一个未知值的时候可能会遇到很多警告。。

### 其他未知值的警告

到底是什么问题呢？我现在用一小段代码展示为不同大小的类适配布局。它枚举出了 `UIUserInterfaceSizeClass` 的 **所有可能值**：

```swift
func configure(for sizeClass: UIUserInterfaceSizeClass) {
    switch sizeClass {
    case .uppercased:
        // ...
    case .compact:
        // ...
    case .regular:
        // ...
    }
}
```

当我把项目升级到 Swift 5 之后，Xcode 会报出一些警告：

![additional unknown values warning](https://useyourloaf.com/assets/images/2019/2019-04-05-001.png)

警告内容：

> Switch 语句涵盖了所有 case，但是 `UIUserInterfaceSizeClass` 以后可以会添加一些其他未知的值
>
> 请使用 “@unknown default” 来处理未知值

如果你点击了修复，Xcode 会自动添加一个 `@unknown default:` 的 case：

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

你可以修改 `fatalError()`，但这到底是什么意思呢？

### 冻结和非冻结的枚举

**Swift 中的一个 `switch` 语句必须是详尽的或者包含一个默认的 default case 来处理其他所有情况**。我原来的 switch 语句把在 Apple 在 iOS 12 的 `UIKit` 中定义的 `UIUserInterfaceSizeClass` 的所有可能值都进行了枚举。

如果 Apple 在 iOS 13 中引入了 `.tiny` 或 `.large`，那会发生什么呢？使用新版本的 SDK 编译时，编译器会因 switch 语句不再详尽而报错。解决错误的的一种方法是引入一个 `default:` case。我可以重写我的 switch 语句：

```swift
switch sizeClass {
   case .compact:
      // 布局为 compact 该做的事
   default:
      // 默认情况下该做的事
      // 其中也包含了一些未知情况
  }
```

该 switch 不再详尽，但它能处理所有现在已知和未来的未知的情况。这一点很好，但如果 switch 是详尽的，这对编译器就有优势，并且它在编译时能兼容二进制库。当枚举更新后有新的 case，你可能还需要警告。

Swift 进化的提案 [SE-0192](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md) 添加了 `@unknown default:` 语法，这允许你可以继续使用一个详尽的 switch 来用于未来可能出现的情况：

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

**`@unknown default:` 这个 case 只能用于让枚举变得详尽，并匹配添加到枚举的任何新案例**。它依旧会为这些新 case 生成警告，以便你可以决定采取怎么样的操作。这不同于使用 `default:` 和一个非详尽的枚举，它不会提示你有新的 case 未处理。

#### 冻结枚举

这一变化还增加了 **冻结枚举** 的概念，这不是为了获得任何新 case。它仅适用于在 Swift 里导入 C 或 Objective-C 的枚举。举个例子，标准库中的 `ComparisonResult`。这是他在 Objective-C 中的定义：

```objective-c
typedef NS_CLOSED_ENUM(NSInteger, NSComparisonResult) {
    NSOrderedAscending = -1L,
    NSOrderedSame,
    NSOrderedDescending
};
```

只有三种可能的情况，所以这个枚举永远不会改变。注意 `NS_CLOSED_ENUM` 注释而不是通常的 `NS_ENUM`。我们并不需要在 switch 里添加 `@unknown default` 来让它变得详尽：

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

如果库的作者将新 case 添加到了冻结枚举，则编译会报错。

### 冻结还是非冻结？

我们不知道 Apple 是否计划在 `UIKit` 和相关框架中枚举的情况。大多数可能是非冷冻的，但在某些情况下，冷冻可能是有意义的。

例如，堆栈视图轴是一个 `UILayoutConstraintAxis` 的枚举，在 iOS 12 中仍未冻结。这是 Objective-C 的头文件（注意 `NS_ENUM`）：

```objective-c
typedef NS_ENUM(NSInteger, UILayoutConstraintAxis) {
    UILayoutConstraintAxisHorizontal = 0,
    UILayoutConstraintAxisVertical = 1
};
```

这意味着如果要打开堆栈视图轴，则需要允许将来可能的未知情况：

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

也许 Apple 会将其更改为 `NS_CLOSED_ENUM`，又或者堆栈视图是否会在 iOS 13 有别的可能值？

### 我们需要做什么？

* 首先，你不需要改变你自己原先的 Swift 枚举。当你升级到 Swift 5 时，你不需要一开始就手动在代码上添加 `@unknown default:`。Xcode 会发出警告来提示你需要添加的位置。
* 此更改仅适用于标准库和其他框架中的 C 语言枚举。
* 如果您的 switch 包含 `default:` case，那就不需要进行任何变化。
* 彻底切换 C 语言的非冻结枚举，包括所有已知的情况（不含 `default:`）是 Swift 5 中的警告。
* 你可以让 Xcode 帮你自动修复代码，它会添加一个 `@unknown:` 的 case 并消除警告。

### 阅读更多

有关更多详细信息，请参阅 Swift 进化的提案：

*   [SE-0192 Handling Future Enum Cases](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
