> * 原文地址：[API Pollution in Swift Modules](https://nshipster.com/swift-api-pollution/)
> * 原文作者：[Mattt](https://nshipster.com/authors/mattt/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swift-api-pollution.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swift-api-pollution.md)
> * 译者：[iWeslie](https://github.com/iWeslie)

# Swift 模块中的 API 污染

当你将一个模块导入 Swift 代码中时，你希望它们产生的效果是叠加的，也就是说，你不需要什么代价就可以使用新功能，仅仅 app 的大小会增加一点。

导入 `NaturalLanguage` 框架，你的 app 就可以 [确定文本的语言](https://nshipster.com/nllanguagerecognizer/)。导入 `CoreMotion`，你的应用可以 [响应设备方向的变化](https://nshipster.com/cmdevicemotion/)。但是如果进行语言本地化的功能干扰到手机检测设备方向的功能，那就太不可思议了。

虽然这个特殊的例子有点极端，但在某些情况下，Swift 依赖库可以改变你 app 的一些行为方式，**即使你不直接使用它也是如此**。

在本周的文章中，我们将介绍导入模块可以静默更改现有代码行为的几种方法，并提供当你作为一个 API 生产者有关如何防止这种情况的发生以及作为 API 调用者如何减轻这种情况带来的影响的一些建议。

## 模块污染

这是一个和 `<time.h>` 一样古老的故事：有两个东西叫做 `Foo`，并且编译器需要决定做什么。

几乎所有具有代码重用机制的语言都必须以某种方式处理命名冲突。在 Swift 里，你可以使用显式的声明来区分模块 `A` 中的 `Foo` 类型（`A.Foo`）和模块 `B` 中的 `Foo` 类型（`B.Foo`）。但是，Swift 具有一些独特的风格会导致编译器忽视其他可能存在的歧义，这会导致导入模块时对现有行为进行更改。

> 在本文中，我们使用 “污染” 这个术语来描述由导入编译器未显现的 Swift 模块引起的这种副作用。我们并不完全承认这个术语，所以如果你有其他更好的任何建议，请 [联系我们](https://twitter.com/nshipster)。

### 运算符重载

在 Swift 里，`+` 运算符表示两个数组连接。一个数组加上另一个数组产生一个新数组，其中前一个数组的元素后面跟着后一个数组的元素。

```swift
let oneTwoThree: [Int] = [1, 2, 3]
let fourFiveSix: [Int] = [4, 5, 6]
oneTwoThree + fourFiveSix // [1, 2, 3, 4, 5, 6]
```

如果我们查看运算符在 [标准库中的声明](https://github.com/apple/swift/blob/master/stdlib/public/core/Array.swift#L1318-L1324)，我们可以看到它已经提供了在 `Array` 的 extension 中：

```swift
extension Array {
    @inlinable public static func + (lhs: Array, rhs: Array) -> Array {...}
}
```

Swift 编译器负责解析对其相应实现的 API 调用。如果调用与多个声明匹配，则编译器会选择最具体的声明。

为了阐释这一点，请考虑在 `Array` 上使用以下条件扩展，它定义了 `+` 运算符，以便对元素遵循 `Numeric` 的数组执行加法运算：

```swift
extension Array where Element: Numeric {
    public static func + (lhs: Array, rhs: Array) -> Array {
        return Array(zip(lhs, rhs).map {$0 + $1})
    }
}

oneTwoThree + fourFiveSix // [5, 7, 9] 😕
```

因为 extension 中 `Element: Numeric` 规定了数组元素必须为数字，这比标准库里没有进行显示的声明更加具体，所以 Swift 编译器在遇到元素为数字的数组时会将 `+` 解析为我们定义的以上函数。

现在这些新语义也许可以接受的，确实它们更加可取，但得在你知道它们怎么用的时候才行。问题是如果你像 **import** 一样导入这样一个模块，你可以在不知情的情况下改变整个应用程序的行为。

然而这个问题不仅局限于语义问题。

### 函数的阴影

在 Swift 中，函数声明时可以为参数指定默认值，使这些参数在调用时也可以不传入值。例如，top-level 下的函数 [`dump(_:name:indent:maxDepth:maxItems:)`](https://developer.apple.com/documentation/swift/1539127-dump) 有特别多的参数：

```swift
@discardableResult func dump<T>(_ value: T, name: String? = nil, indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max) -> T
```

但是多亏了参数默认值，你只需要在调用的时候指定第一个参数：

```swift
dump("🏭💨") // "🏭💨"
```

可是当方法签名重叠时，这种便利来源可能会变得比较混乱。

假设我们有一个模块，你并不熟悉内置的 `dump` 函数，因此定义了一个 `dump(_:)` 来打印字符串的 UTF-8 代码单元。

```swift
public func dump(_ string: String) {
    print(string.utf8.map {$0})
}
```

在 Swift 标准库中声明的 `dump` 函数在其第一个参数（实际上是“Any”）中采用了一个泛型 `T` 参数。因为 `String` 是一个更具体的类型，所以当有更具体的函数声明时，Swift 编译器将会选择我们自己的 `dump(_:)` 方法。

```swift
dump("🏭💨") // [240, 159, 143, 173, 240, 159, 146, 168]
```

与前面的例子不同的是，与之竞争的声明中存在任何歧义并不完全清楚。毕竟开发人员有什么理由认为他们的 `dump(_:)` 方法可能会以任何方式与 `dump(_:name:indent:maxDepth:maxItems:)` 相混淆呢？

这引出了我们最后的例子，它可能是最令人困惑的...

### 字符串插值污染

在 Swift 中，你可以通过在字符串文字中的插值来拼接两个字符串，作为级联的替代方法。

```swift
let name = "Swift"
let greeting = "Hello, \(name)!" // "Hello, Swift!"
```

从 Swift 的第一个版本开始就是如此。自从 Swift 5 中新的 [`ExpressibleByStringInterpolation`](https://nshipster.com/expressiblebystringinterpolation) 协议的到来，这种行为不再是理所当然的。

考虑 `String` 的默认插值类型的以下扩展：

```swift
extension DefaultStringInterpolation {
    public mutating func appendInterpolation<T>(_ value: T) where T: StringProtocol {
        self.appendInterpolation(value.uppercased() as TextOutputStreamable)
    }
}
```

`StringProtocol` 遵循了 [一些协议](https://swiftdoc.org/v4.2/protocol/stringprotocol/)，其中包括 `TextOutputStreamable` 和 `CustomStringConvertible`，使其比 [通过 `DefaultStringInterpolation` 声明的 `appendInterpolation` 方法](https://github.com/apple/swift/blob/master/stdlib/public/core/StringInterpolation.swift#L63) 更加具体，如果没有声明，插入 `String` 值的时候就会调用它们。

```swift
public struct DefaultStringInterpolation: StringInterpolationProtocol {
    @inlinable public mutating func appendInterpolation<T>(_ value: T) where T: TextOutputStreamable, T: CustomStringConvertible {...}
}
```

再一次地，Swift 编译器的特异性导致我们预期的行为变得不可控。

如果 app 中的任何模块都可以跨越访问以前别模块中的声明，这就会更改所有插值字符串值的行为。

```swift
let greeting = "Hello, \(name)!" // "Hello, SWIFT!"
```

> 不可否认，这最后一个例子有点做作，实现这个函数时必须尽全力确保其实非递归。但请注意这是一个不明显的例子，这个例子更可能真实地发生在现实应用场景中。

鉴于语言的快速迭代，期望这些问题在未来的某个时刻得到解决并非没有道理。

但是在此期间我们要做什么呢？以下是作为 API 使用者和 API 提供者管理此行为的一些建议。

## API 使用者的策略

作为 API 使用者，你在很多方面都会受到导入依赖项所施加的约束。它确实 **不应该** 是你要解决的问题，但至少有一些补救措施可供你使用。

### 向编译器添加提示

通常，让编译器按照你的意愿执行操作的最有效方法是将参数显式地转换为与你要调用的方法匹配的类型。

以我们之前的 `dump(_:)` 方法为例：通过从 `String` 向下转换为 `CustomStringConvertible`，我们可以让编译器解析调用以使用标准库函数。

```swift
dump("🏭💨") // [240, 159, 143, 173, 240, 159, 146, 168]
dump("🏭💨" as CustomStringConvertible) // "🏭💨"
```

### 范围导入声明

> 如 [上一篇文章](https://nshipster.com/swift-import-declarations) 中所述，你可以使用 Swift 导入声明来解决命名冲突。

> 不幸的是，对模块中某些 API 的导入范围目前不会阻止扩展应用于现有类型。也就是说，你不能只导入 `adding(_:)` 方法而不导入在该模块中声明 `+` 运算符的重载。

### Fork 依赖库

如果所有其他方法都失败了，你可以随时将问题掌握在自己手中。

如果你对第三方依赖库不满意，只需 fork 它的源代码，然后去除你不想要的东西再使用它。你甚至可以尝试让他们上游做出一些改变。

> 不幸的是，这种策略不适用于闭源模块，包括 Apple 的 SDK 中的模块。[“雷达或GTFO”](https://nshipster.com/bug-reporting/)。我想你可以试试 [“Radar or GTFO”](https://nshipster.com/bug-reporting/)。

## API 提供者的策略

作为开发 API 的人，你有在设计决策中慎重考虑的最终责任。当你考虑你的操作的影响时，请注意以下事项：

### 对使用泛型约束更加谨慎

未指定的 `<T>` 泛型约束与 `Any` 相同。如果这样做有意义，请考虑使你的约束更具体，以减少与其他不相关声明重叠的可能性。

### 从便利性中分离核心功能

作为普适规则，代码应组成模块而负责单一的责任。

如果这样做是有意义的，请考虑模块中类型和方法提供的打包功能，你需要将该模块与你为内置类型提供的任何扩展分开，以提高其可用性。在可以从模块中挑选和选择我们想要的功能之前，最好的解决方案是让调用者可以选择在可能导致下游问题的情况下选择性地加入功能。

### Avoid Collisions Altogether完全避免碰撞

当然，如果你能够知情地避免冲突，那就太棒了...但是这会进入整个 [“不知之不知”](https://en.wikipedia.org/wiki/There_are_known_knowns)，我们现在没有时间讨论认识论。

所以现在让我们假设，如果你知道某些事情可能会产生冲突，一个好的选择是完全避免使用它。

例如，如果你担心某人可能会对你重载基本算术运算符感到不满，你可以选择另一个，比如 `.+`：

```swift
infix operator .+: AdditionPrecedence

extension Array where Element: Numeric {
    static func .+ (lhs: Array, rhs: Array) -> Array {
        return Array(zip(lhs, rhs).map {$0 + $1})
    }
}

oneTwoThree + fourFiveSix // [1, 2, 3, 4, 5, 6]
oneTwoThree .+ fourFiveSix // [5, 7, 9]
```

作为开发者，我们可能不太习惯于考虑我们决策的深远影响。代码是看不见的，没有重量的，所以很容易忘记它在我们发布后忘记它的存在。

但是在 Swift 中，我们的决策产生的影响超出了人们的直接理解，所以考虑我们如何履行 API 管理员的责任这一点非常重要。

## NSMutableHipster

如果你有其他问题，欢迎给我们提 [Issues](https://github.com/NSHipster/articles/issues) 和 [pull requests](https://github.com/NSHipster/articles/blob/master/2019-02-18-swift-api-pollution.md)。

**这篇文章使用 Swift 5.0.**。你可以在 [状态页面](https://nshipster.com/status/) 上查找所有文章的状态信息。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
