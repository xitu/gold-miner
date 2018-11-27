> * 原文地址：[Dynamic Features in Swift](https://www.raywenderlich.com/5743-dynamic-features-in-swift)
> * 原文作者：[Mike Finney](https://www.raywenderlich.com/u/finneycanhelp)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dynamic-features-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dynamic-features-in-swift.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：

# Swift 中的动态特性

> 在本教程中，你将学习如何使用 Swift 中的动态特性编写简洁、清晰的代码并快速解决无法预料的问题。

作为一名忙碌的 Swift 开发人员，你的需求对你来说是特定的，但对所有人来说都是共同的。你希望编写整洁的代码，一目了然地了解代码中的内容并快速解决无法预料的问题。

本教程将 Swift 的动态性和灵活性结合在一起来满足那些需求。 通过使用最新的 Swift 技术，你将学习如何自定义输出到控制台，挂钩第三方对象状态更改，并使用一些甜蜜的语法糖来编写更清晰的代码。

具体来说，你将学习以下内容：

*   `Mirror`
*   `CustomDebugStringConvertible`
*   使用 keypath 进行键值监听（KVO）
*   动态查找成员
*   相关技术

最重要的是，你将度过一段美好的时光！

本教程需要 Swift 4.2 或更高版本。你必须下载最新的 [Xcode 10](https://developer.apple.com/download/) 或安装最新的 [Swift 4.2](https://swift.org/download/#snapshots)。

此外，你必须了解基本的 Swift 类型。Swift 入门教程（[原文链接](https://www.raywenderlich.com/119881/enums-structs-and-classes-in-swift)）中的[枚举](https://www.cnswift.org/enumerations)，[类和结构体](https://www.cnswift.org/classes-and-structures)是一个很好的起点。 虽然不是严格要求，但你也可以查看在 Swift 中实现[自定义下标](https://www.cnswift.org/subscripts)（[原文链接](https://www.raywenderlich.com/123102/implementing-custom-subscripts-swift)）。

## 入门

在开始之前，**请先[下载资源](https://koenig-media.raywenderlich.com/uploads/2018/08/DynamicFeaturesInSwift.zip)**（入门项目和最终项目）。

为了让你专注于学习 Swift 动态特性，其他所需的所有代码都已经为你写好了！就像和一只友好的导盲犬一起散步一样，本教程将指导你完成入门代码中的所有内容。

![](https://koenig-media.raywenderlich.com/uploads/2018/06/smiling_dog_small.jpg)

​			快乐的狗狗

在名为 **DynamicFeaturesInSwift-Starter** 的入门项目代码目录中，你将看到三个 Playground 页面：**DogMirror**，**DogCatcher** 和 **KennelsKeyPath**。Playground 在macOS上运行。本教程与平台无关，仅侧重于 Swift 语言。

## 使用 Mirror 的反射机制与调试输出

无论你是断点调试追踪问题还是只探索正在运行的代码，控制台中的信息是否整洁都会产生比较大的影响。 Swift 提供了许多自定义控制台输出和捕获关键事件的方法。 对于自定义输出，它没有 Mirror 深入。 Swift 提供比最强大的雪橇犬还要强大的力量，能把你从冰冷的雪地拉出来！

![](https://koenig-media.raywenderlich.com/uploads/2018/06/siberian_husky_small.jpg)

​			西伯利亚雪橇犬

在了解有关 `Mirror` 的更多信息之前，你首先要为一个类型编写一些自定义的控制台输出。 这将有助于你更清楚地了解目前正在发生的事情。

### CustomDebugStringConvertible

用 Xcode 打开 **DynamicFeaturesInSwift.playground** 并前往 **DogMirror** 页面。

为了纪念那些迷路的可爱的小狗，它们被捕手抓住然后与它们的主人团聚，这个页面有 Dog 类和 DogCatcherNet 类。 首先我们看一下 DogCatcherNet 类。

由于丢失的小狗必须被捕获并与其主人团聚，所以我们必须支持捕狗者。你在以下项目中编写的代码将帮助捕狗者评估捕狗网的质量。

在 Playground 里，看看以下内容：

```swift
enum CustomerReviewStars { case one, two, three, four, five }
```

```swift
class DogCatcherNet {
  let customerReviewStars: CustomerReviewStars
  let weightInPounds: Double
  // ☆ Add Optional called dog of type Dog here

  init(stars: CustomerReviewStars, weight: Double) {
    customerReviewStars = stars
    weightInPounds = weight
  }
}

```

```swift
let net = DogCatcherNet(stars: .two, weight: 2.6)
debugPrint("Printing a net: \(net)")
debugPrint("Printing a date: \(Date())")
print()

```

`DogCatcherNet` 有两个属性：`customerReviewStars` 和 `weightInPounds`。客户评论的星星数量反映了客户对净产品的感受。 以磅为单位的重量告诉狗捕捉者他们将经历拖拽网的负担。

运行 Playground。你应该看到的内容前两行与下面类似：

```
"Printing a net: __lldb_expr_13.DogCatcherNet"
"Printing a date: 2018-06-19 22:11:29 +0000"
```

正如你所见，控制台中的调试输出会打印与网络和日期相关的内容。保佑它吧！代码的输出看起来像是由机器宠物制作的。这只宠物已经尽力了，但它需要我们人类的帮助。正如您所看到的，它打印出了诸如 “__lldb_expr_” 之类的额外信息。打印出的日期可以提供更有用的功能，但是这是否足以帮助你追踪一直困扰着你的问题还尚不清楚。

为了增加成功的机会，你需要用到 **CustomDebugStringConvertible** 的魔力来基础自定义制台输出。在 Playground 上，在 **DogCatcherNet **里的 **☆ Add Conformance to CustomDebugStringConvertible** 下面添加以下代码：

```swift
extension DogCatcherNet: CustomDebugStringConvertible {
  public var debugDescription: String {
    return "DogCatcherNet(Review Stars: \(customerReviewStars), Weight: \(weightInPounds)"
  }
}

```

对于像 `DogCatcherNet` 这样的小东西，一个类可以遵循 `CustomDebugStringConvertible` 并使用 `debugDescription` 属性来提供自己的调试信息。

运行 Playground。除日期值会有差异外，前两行应包括：

```
"Printing a net: DogCatcherNet(Review Stars: two, Weight: 2.6)"
"Printing a date: 2018-06-19 22:10:31 +0000"
```

对于具有许多属性的较大类型，此方法需要显式样板的类型。 对于有决心的人来说，这不是问题。 如果时间不够，还有其他选项，例如 `dump`。

### Dump

如何避免需要手动添加样板代码？一种解决方案是使用 `dump`。`dump` 是一个通用函数，它打印出类型属性的所有名称和值。

Playground 已经包含 dump 出捕狗网和日期的调用。代码如下所示：

```swift
dump(net)
print()

dump(Date())
print()
```

运行 playground。控制台的输出如下：

```
▿ DogCatcherNet(Review Stars: two, Weight: 2.6) #0
  - customerReviewStars: __lldb_expr_3.CustomerReviewStars.two
  - weightInPounds: 2.6

▿ 2018-06-26 17:35:46 +0000
  - timeIntervalSinceReferenceDate: 551727346.52924
```

由于你目前使用 `CustomDebugStringConvertible` 完成的工作，`DogCatcherNet` 看起来比其他方式更好。 输出包含：

```swift
DogCatcherNet(Review Stars: two, Weight: 2.6)
```

`dump` 还会自动输出每个属性。棒极了！现在是时候使用 Swift 的 `Mirror` 让这些属性更具可读性了。

### Swift Mirror

![](https://koenig-media.raywenderlich.com/uploads/2018/06/mirror_dog_small.jpg)

​			魔镜魔镜，告诉我，谁才是世界上最棒的狗？

`Mirror` 允许你在运行时通过 playground 或调试器显示任何类型实例的值。简而言之，`Mirror` 的强大在于内省。内省是 [反射 ](https://developer.apple.com/documentation/swift/swift_standard_library/debugging_and_reflection)的一个子集。

### 创建一个 Mirror 驱动的狗狗日志

是时候创建一个 Mirror 驱动的狗狗日志了。为了协助调试，最理想的是通过日志功能向控制台显示捕狗网的值，其中自定义输出带有表情符号。日志功能应该能够处理你传递的任何类型。

### 创建一个 Mirror

是时候创建一个使用 Mirror 的日志功能了。首先，在 **☆ Create log function here** 添加以下代码：

```swift
func log(itemToMirror: Any) {
  let mirror = Mirror(reflecting: itemToMirror)
  debugPrint("Type: 🐶 \(type(of: itemToMirror)) 🐶 ")
}
```

这将为传入的对象创建镜像，镜像允许你迭代实例的各个部分。

将以下代码添加到 `log(itemToMirror:)` 的末尾:

```swift
for case let (label?, value) in mirror.children {
  debugPrint("⭐ \(label): \(value) ⭐")
}
```

这将访问镜像的 `children` 属性，获取每个标签值对，然后将它们打印到控制台。标签值对的类型别名为 `Mirror.Child`。 对于 `DogCatcherNet` 实例，代码迭代捕狗网对象的属性。

澄清一点，被检查实例的子级与父类或子类层次结构无关。 通过镜像访问的孩子只是被检查实例的一部分。

现在，是时候调用新的日志方法了。在 **☆ Log out the net and a Date object here** 添加以下代码：

```swift
log(itemToMirror: net)
log(itemToMirror: Date())
```

运行 playground。你会在控制台的底部看到一些很棒的输出：

```
"Type: 🐶 DogCatcherNet 🐶 "
"⭐ customerReviewStars: two ⭐"
"⭐ weightInPounds: 2.6 ⭐"
"Type: 🐶 Date 🐶 "
"⭐ timeIntervalSinceReferenceDate: 551150080.774974 ⭐"
```

这显示了所有属性的名称和值。名称和你在代码中写的一样。例如，`customerReviewStars` 实际上是如何在代码中拼写属性名称。

### CustomReflectable

如果你想要让更多的狗或者小马也能更清楚地显示其中的属性名称应该怎么办呢？如果你又不想显示某些属性要怎么办呢？如果你希望在技术上显示的不属于该类型的每一项，又该怎么办呢？这时你可以使用 `CustomReflectable`。

`CustomReflectable` 提供了一个接口，你可以使用自定义的 `Mirror` 来指定需要显示类型实例的哪些部分。要遵循 `CustomReflectable` 协议，这个类必须定义 `customMirror` 属性。
在与几位捕手程序员交谈后，你发现打印捕狗网的 `weightInPounds` 属性并没有帮助于调试。但是 `customerReviewStars` 的信息非常有用，他们希望`customerReviewStars` 的标签显示为 “Customer Review Stars”。现在，是时候让 `DogCatcherNet` 遵循 `CustomReflectable` 了。
在 **☆ Add Conformance to CustomReflectable for DogCatcherNet here** 后面添加以下代码：

```swift
extension DogCatcherNet: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(DogCatcherNet.self,
                  children: ["Customer Review Stars": customerReviewStars,
                            ],
                  displayStyle: .class, ancestorRepresentation: .generated)
  }
}
```

运行 playground 能看到如下的输出：

```
"Type: 🐶 DogCatcherNet 🐶 "
"⭐ Customer Review Stars: two ⭐"
```

**狗狗上哪去了呢？**
捕狗网的作用是当有狗来的时候抓住它。当网里装满狗时，必须有办法在网中提取有关狗的信息。具体来说，你需要狗的名字和年龄。

Playground 的页面已经有一个 `Dog` 类。是时候将 `Dog` 与 `DogCatcherNet` 连接起来了。在标记了 **☆ Add Optional called dog of type Dog here** 的标签下为 `DogCatcherNet` 添加以下属性：

```swift
var dog: Dog?
```

随着狗的属性添加到了 `DogCatcherNet`，是时候再将狗添加到`DogCatcherNet` 的 `customMirror` 了。在 `children：[“Customer Review Stars”：customerReviewStars，` 这一行下添加以下的一个字典：

```swift
"dog": dog ?? "",
"Dog name": dog?.name ?? "No name"
```

这将使用其默认调试描述和狗的名称输出狗的属性。

是时候轻轻地把狗放进网里了。现在把 **☆ Uncomment assigning the dog** 那一行取消注释，可爱的小狗就可以被放到网里了。
```swift
net.dog = Dog() // ☆ Uncomment out assigning the dog
```

运行 Playground 能看到如下输出：

```
"Type: 🐶 DogCatcherNet 🐶 "
"⭐ Customer Review Stars: two ⭐"
"⭐ dog: __lldb_expr_23.Dog ⭐"
"⭐ Dog name: Abby ⭐"
```

**Mirror 的便利**

能够看到一切真是太好了。但是，有些时候你只想看到镜像的其中一部分。为此，使用 [`descendant(_:_:)`](https://developer.apple.com/documentation/swift/mirror/1540759-descendant) 来取出名称和年龄：

```swift
let netMirror = Mirror(reflecting: net)

print ("The dog in the net is \(netMirror.descendant("dog", "name") ?? "nonexistent")")
print ("The age of the dog is \(netMirror.descendant("dog", "age") ?? "nonexistent")")
```

运行 Playground，你将在控制台底部看到如下输出：

```
The dog in the net is Bernie
The age of the dog is 2
```

那是烦人的动态内省。它对于调试自定义的类型非常有用！在深入探讨了 `Mirror` 后，你就完成了 **DogMirror.xcplaygroundpage**。

### 封装 Mirror 调试输出

有很多方法可以追踪程序中发生了什么，例如猎犬。`CustomDebugStringConvertible` ，`dump` 和 `Mirror` 能让你更清楚地看到你在寻找什么。Swift 的内省功能非常有用，特别是当你开始构建更庞大更复杂的应用程序时！

## KeyPath

有关跟踪程序中发生的事情的情况，Swift 有一些很棒的解决方案，叫做 keypath。要捕获事件，例如当第三方库对象中的值发生更改时，请向 `键值监听` 寻求帮助。

在 Swift 中，keyPath 是强类型的路径，其类型在编译时被检查。在 Objective-C 中，它们只是字符串。教程 [Swift 4 新特性](https://knightcai.github.io/2017/09/11/Swift-4-新特性/) 在键值编码部分的概念方面做得很好。

有几种不同类型的 `KeyPath`。常见的类型包括 [KeyPath](https://developer.apple.com/documentation/swift/keypath)，[WritableKeyPath](https://developer.apple.com/documentation/swift/writablekeypath) 和 [ReferenceWritableKeyPath](https://developer.apple.com/documentation/swift/referencewritablekeypath)。以下是它们的摘要：

*   `KeyPath`：指定特定值类型的根类型。
*   `WritableKeyPath`：可写入的 KeyPath，它不能用于类。
*   `ReferenceWritableKeyPath`：用于类的可写入 KeyPath，因为类是引用类型。

使用 KeyPath 的一个例子是在对象的值发生更改后观察或捕获。

当你遇到涉及第三方对象的 bug 时，知道该对象的状态何时发生变化就显得尤为重要。除了调试之外，有时在第三方对象（例如Apple的UIImageView对象）中的值发生更改时，调用自定义代码进行响应是有意义的。在[Design Patterns on iOS using Swift – Part 2/2](https://www.raywenderlich.com/160653/design-patterns-ios-using-swift-part-22)中，你可以了解有关观察者模式的更多信息。


然而，这里有一个与狗窝相关的用例，它适合我们的狗狗世界。如果没有强大的键值监听，捕狗者如何轻易地知道什么时候狗窝可以放入更多的狗呢？虽然许多捕狗者只是喜欢把他们发现的每只丢失的狗带回家，但这是不切实际的。

因此，只想帮助狗回家的捕狗者需要知道什么时候狗窝可以放入狗。实现这一目标的第一步是创建一个 KeyPath。打开 **KennelsKeyPath** 页面，然后在 **☆Add KeyPath here** 下面添加：

```swift
let keyPath = \Kennels.available
```

这就是你创建 `KeyPath` 的方法。你可以在类型上使用反斜杠，后跟一系列点分隔的属性，在这种情况下能取到最后一个属性。要使用 `KeyPath` 来监听对 `available` 属性的更改，请在 **☆ Add observe method call here** 之后添加以下代码：

```swift
kennels.observe(keyPath) { kennels, change in
  if kennels.available {
    print("kennels are available")
  }
}
```

点击运行，你能看到控制台的输出如下：

```
Kennels are available.
```

这种方法对于确定值何时发生变化的情况也很有用。想象一下，我们居然能够调试第三方框架里对象状态的修改！当有意思的项发生变化时，可以确保你不用看到烦人的错误调用的树的输出。

到现在为止你已经完成了 **KennelsKeyPath** 项目！

## 理解动态成员查询
如果你一直在紧跟 Swift 4.2 的变化，你可能听说过 **动态成员查询（Dynamic Member Lookup）**。如果没有，你在这里不仅仅只是学习这个概念。

在本教程的这一部分中，你将通过一个如何创建真正的 JSON DSL（域规范语言）的示例来看到 Swift 中 **动态成员查询** 的强大功能，该示例允许调用者使用点表示法来访问来自 JSON 数据的值。

**动态成员查询** 使编码人员能够对编译时不存在的属性使用点语法，而不是使用混乱的方式。简而言之，你将拥有那些属性运行时必存在的信念来编写代码，从而获得易于阅读的代码。

正如 [proposal for this feature](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md)  和  [associated conversations in the Swift community](https://forums.swift.org/t/se-0195-introduce-user-defined-dynamic-member-lookup-types/8658/10) 中提到，这个功能为和其他语言的互操作性提供了极大的支持，例如 Python，数据库实现者和围绕 “基于字符串的” API（如CoreImage）创建无样板包装器等。

### @dynamicMemberLookup 简介

打开 **DogCatcher** 页面并查看代码。在 Playground 里，`狗` 表示狗的运行有一个 `方向`。

使用 `dynamicMemberLookup` 的功能，即使这些属性没有明确存在，也可以访问 `directionOfMovement` 和 `moving` 。现在是时候让 ` Dog`  变的动态了。

### 把 dynamicMemberLookup 添加到 Dog

激活此动态功能的方法是使用注解 `@dynamicMemberLookup`。

在 **☆ Add subscript method that returns a Direction here** 下添加以下代码：

```swift
subscript(dynamicMember member: String) -> Direction {
  if member == "moving" || member == "directionOfMovement" {
    // Here's where you would call the motion detection library
    // that's in another programming language such as Python
    return randomDirection()
  }
  return .motionless
}
```

现在通过取消 **☆ Uncomment this line** 下面的注释，来将标记 `dynamicMemberLookup` 添加到 `Dog` 中。

你现在可以访问名为 `directionOfMovement` 或 `moving` 的属性。尝试在 **☆ Use the dynamicMemberLookup feature for dynamicDog here** 下面上添加以下内容：

```swift
let directionOfMove: Dog.Direction = dynamicDog.directionOfMovement
print("Dog's direction of movement is \(directionOfMove).")

let movingDirection: Dog.Direction = dynamicDog.moving
print("Dog is moving \(movingDirection).")
```

运行 Playground。由于狗有时在 **左边** 且有时在 **右边**，因此你应该看到输出的前两行类似于：

```
Dog's direction of movement is left.
Dog is moving left.
```

### 重载下标 (dynamicMember:)

Swift 支持用不同的返回值 [重载下标声明](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-ID379) 。在 **☆ Add subscript method that returns an Int here** 下面尝试添加返回一个  `Int` 的 `subscript` ：

```swift
subscript(dynamicMember member: String) -> Int {
  if member == "speed" {
    // Here's where you would call the motion detection library
    // that's in another programming language such as Python.
    return 12
  }
  return 0
}
```

现在你可以访问名为 `speed` 的属性。通过在之前添加的 `movingDirection` 下添加以下内容来加快胜利速度：

```swift
let speed: Int = dynamicDog.speed
print("Dog's speed is \(speed).")
```

运行 Playground，输出应该包含以下内容：

```
Dog's speed is 12.
```

是不是太棒了。即使你需要访问其他编程语言（如Python），这也是一个强大的功能，可以使代码保持良好状态。如前所述，有一个问题......

![](https://koenig-media.raywenderlich.com/uploads/2018/06/dog_ears_perk_up2_small.jpg)

​			“想抓我？”我全听到了。

### 给狗编译并完成代码

为了换取动态运行时的特性，你无法获得依赖于 `subscript（dynamicMember :)` 功能属性的编译时检查的好处。此外，Xcode 的代码自动补全功能也无法帮助你。但好消息是专业 iOS 开发者能阅读到比他们编写的还要多的代码。

**动态成员查询** 给你的语法糖只是扔掉了。这是一个很好的功能，使 Swift 的某些特定用例和语言互操作性可以让人看到并且令人愉快。

### 友好的捕狗者

**动态成员查询** 的原始提案解决了语言互操作性问题，尤其是对于 Python。但是，这并不是唯一有用的情况。

为了演示纯粹的 Swift 用例，你将使用 **DogCatcher.xcplaygroundpage** 中的 `JSONDogCatcher` 代码。它是一个简单的结构，具有一些属性，用于处理`String`，`Int`和 JSON 字典。使用这样的结构，你可以创建一个 `JSONDogCatcher` 并最终搜索特定的 `String` 或 `Int` 值。
**传统下标方法**
实现类似遍历 JSON 字典的传统方法是使用 `下标` 方法。Playground 已经包含传统的 `下标` 实现。使用 `subscript` 方法访问 `String` 或 `Int` 值通常如下所示，并且也在 Playground 中：

```swift
let json: [String: Any] = ["name": "Rover", "speed": 12,
                          "owner": ["name": "Ms. Simpson", "age": 36]]

let catcher = JSONDogCatcher.init(dictionary: json)

let messyName: String = catcher["owner"]?["name"]?.value() ?? ""
print("Owner's name extracted in a less readable way is \(messyName).")
```

虽然你必须遍历查询括号，引号和问号来获得其中的数据，但这很有效。
运行 Playground，你看到的输出将会如下：

```
Owner's name extracted in a less readable way is Ms. Simpson.
```

虽然它可以解决问题，但是使用点语法就可以更轻松了。使用 **动态成员查询**，你可以深入了解多级 JSON 数据结构。

**将 dynamicMemberLookup 添加到 Dog Catcher**
就像 `Dog` 一样，是时候将 `dynamicMemberLookup` 属性添加到 `JSONDogCatcher` 结构中了。

在 **☆ Add subscript(dynamicMember:) method that returns a JSONDogCatcher here** 下添加以下代码：

```swift
subscript(dynamicMember member: String) -> JSONDogCatcher? {
  return self[member]
}
```

下标方法  `subscript(dynamicMember:)` 调用已存在的 `下标` 方法，但删除了使用括号和 `String` 作为键的样板代码。 现在，取消在 `JSONDogCatcher` 上 标有 **☆ Uncomment this line**  的注释：

```swift
@dynamicMemberLookup
struct JSONDogCatcher {
```

有了这个之后，你就可以使用点语法来获得狗的速度和它主人的名字。 尝试在 **☆ Use dot notation to get the owner’s name and speed through the catcher** 下添加以下代码：

```swift
let ownerName: String = catcher.owner?.name?.value() ?? ""
print("Owner's name is \(ownerName).")

let dogSpeed: Int = catcher.speed?.value() ?? 0
print("Dog's speed is \(dogSpeed).")
```

运行 Playground，你会看到控制台输出了速度和狗主人的名字：

```
Owner's name is Ms. Simpson.
Dog's speed is 12.
```

现在你得到了主人的名字，狗捕手可以联系主人来让他知道他的狗被找到了！

多么幸福的结局！ 狗和它的主人再次团聚，而且代码也看起来更整洁。 通过 Swift 的动态的力量，这条活泼的狗可以回到后院去追兔子了。

![](https://koenig-media.raywenderlich.com/uploads/2018/06/bunny_small.jpg)

​			辛普森的狗喜欢追逐而不是追赶

## 后记

你可以使用本教程顶部的 **下载材料** 链接下载到项目的完整版本。

在本教程中，你利用了 Swift 4.2 中提供的动态功能。了解了 Swift 的内省反射功能（例如 `Mirror` ）自定义控制台输出，使用 KeyPath 进行 **键值监听 ** 和 **动态成员查找**。

通过学习动态的功能，你可以清楚地看到有用的信息，拥有更易读的代码，并为你的应用程序，通用框架或者是库提供一些强大的运行时功能。

深入 Mirror 的 [官方文档](https://developer.apple.com/documentation/swift/mirror) 和相关项目进行探索是值得的。有关 **键值监听 ** 的更多信息，请看使用 [Swift 的 iOS 设计模式](https://www.raywenderlich.com/160651/design-patterns-ios-using-swift-part-12)。想了解更多 Swift 4.2 新特性，请看[What’s New in Swift 4.2?](https://www.raywenderlich.com/194066/whats-new-in-swift-4-2)。

关于 Swift 4.2 里 **动态成员查找** 功能，查看 Swift 提案 [SE-0195: “Introduce User-defined ‘Dynamic Member Lookup’ Types”](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md)，其中介绍了 `dynamicMemberLookup` 注解和潜在用例。在一个相关的说明中，一个值得关注的 Swift 提案 [SE-216: “Introduce User-defined Dynamically ‘callable’ Types](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md) 是 **动态成员查找** 的近亲，其中介绍了  `dynamicCallable` 注解。



> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
