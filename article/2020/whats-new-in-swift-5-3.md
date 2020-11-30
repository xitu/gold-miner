> * 原文地址：[What’s New in Swift 5.3?](https://medium.com/better-programming/whats-new-in-swift-5-3-142d89d4d1f7)
> * 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/whats-new-in-swift-5-3.md](https://github.com/xitu/gold-miner/blob/master/article/2020/whats-new-in-swift-5-3.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[chaingangway](https://github.com/chaingangway)、[Zorro](https://github.com/lizhenZuo)

# Swift 5.3 的新功能，你了解吗?

![Photo by [Kira auf der Heide](https://unsplash.com/@kadh?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10368/0*FYXrss0agbTq1JVx)

> 支持跨平台，多个尾随闭包，多模式 catch 子句等等

Swift 5.3 的发布流程始于三月底，直到最近才进入最后的开发阶段。该版本的主要目标之一是扩展语言支持 Windows 和 Linux 平台。

苹果公司也非常注重改善语言的综合性能，以提升 SwiftUI 和 iOS 中机器学习的表现。让我们来仔细研究一下即将发布的新版本中有哪些重要更新。

## 多个尾随闭包

在 [SE-0279](https://github.com/apple/swift-evolution/blob/master/proposals/0279-multiple-trailing-closures.md) 提案中提出了新的尾随闭包语法，使您可以用更容易理解的方式将多个闭包作为函数的参数进行调用。这是一种更加强大的语法糖，可最大程度地减少在函数签名中使用过多括号。

它允许您在初始未带标签的闭包之后附加几个带标签的闭包。以下示例演示了这种用法：

```Swift
//old
UIView.animate(withDuration: 0.5, animations: {
  self.view.alpha = 0
}, completion: { _ in
  self.view.removeFromSuperview()
})

//new multiple trailing closures
UIView.animate(withDuration: 0.5) {
            self.view.alpha = 0
        } completion: { _ in
            self.view.removeFromSuperview()
        }
```

上面的语法变化能让 SwiftUI 视图更容易编写。

## 多模式 catch 子句

当前，do-catch 语句中的每个 catch 子句只能包含一个模式。要解决此问题，开发人员在 catch 语句的主体中最好使用 swtich case 语句，但这样会增加嵌套和重复的代码。

[SE-0276](https://github.com/apple/swift-evolution/blob/master/proposals/0276-multi-pattern-catch-clauses.md) 是另一个很好的改进，它允许 catch 字句进行模式匹配。Catch 子句将允许用户指定逗号分隔的模式列表，并将变量与 catch 主体绑定，就像 switch 语句一样。下面是例子：

```Swift
enum NetworkError: Error {
    case failure, timeout
}

//old
func networkCall(){
  do{
    try someNetworkCall()
  }catch NetworkError.timeout{
    print("timeout")
  }catch NetworkError.failure{
    print("failure")
  }
}

//new
func networkCall(){
  do{
    try someNetworkCall()
  }catch NetworkError.failure, NetworkError.timeout{
    print("handle for both")
  }
}
```

多模式 catch 子句能让代码清晰简洁。

## 实现枚举类型的比较功能

到目前为止，比较两个枚举类型还不是一件容易的事。首先必须遵守 `Comparable` 协议，然后实现 `static fun \<` 方法来决定一个枚举类型的原始值是否小于另一个枚举类型的原始值。（对于 `>` 的情况反之亦然）。

值得庆幸的是，在 [SE-0266](https://github.com/apple/swift-evolution/blob/master/proposals/0266-synthesized-comparable-for-enumerations.md) 中，我们可以让枚举类型遵守 `Comparable` 协议而不必显式地实现它，只需保证枚举是标准类型。如果枚举类型没有设置关联值，`enums` 会根据声明的语义顺序进行比较。

下面是枚举类型排序的例子：

```Swift
enum Brightness: Comparable {
    case low(Int)
    case medium
    case high
}

([.high, .low(1), .medium, .low(0)] as [Brightness]).sorted()
// [Brightness.low(0), Brightness.low(1), Brightness.medium, Brightness.high]
```

## 枚举 case 与协议相匹配

Swift 中协议匹配模型是非常严格的，其中规定，与协议有着相同名称和参数的枚举 case 是不匹配的。我们只能手动实现，如下所示：

```Swift
protocol DecodingError {
  static var fileCorrupted: Self { get }
  static func keyNotFound(_ key: String) -> Self
}

enum JSONDecodingError: DecodingError {
  case _fileCorrupted
  case _keyNotFound(_ key: String)
  static var fileCorrupted: Self { return ._fileCorrupted }
  static func keyNotFound(_ key: String) -> Self { return ._keyNotFound(key) }
}
```

在 [SE-0280](https://github.com/apple/swift-evolution/blob/master/proposals/0280-enum-cases-as-protocol-witnesses.md) 中取消了此限制，以便在协议中的名称与参数和枚举 case 相同时，枚举 case 可以直接与协议相匹配。

```Swift
protocol DecodingError {
  static var fileCorrupted: Self { get }
  static func keyNotFound(_ key: String) -> Self
}
enum JSONDecodingError: DecodingError {
  case fileCorrupted
  case keyNotFound(_ key: String)
}
```

## self 不需要在每处都显式使用

在 [SE-0269](https://github.com/apple/swift-evolution/blob/master/proposals/0269-implicit-self-explicit-capture.md) 提案中允许我们在不需要的时候省略 `self`。之前，当我们从闭包外部捕获值时，必须在闭包中使用 `self`。现在，当循环引用不太可能发生时，`self` 将会隐式存在。

下面的例子展示了这个更新：

```Swift
struct OldView: View {

    var body: some View {
        Button(action: {
            self.sayHello()
        }) {
            Text("Press")
        }
    }
    
    func sayHello(){}
}

struct NewView: View {

    var body: some View {
        Button {
            sayHello()
        } label: {
            Text("Press")
        }
    }
    
    func sayHello(){}
}
```

使用 SwiftUI 的开发人员会很乐意接受这一点。因为视图保存在值类型的`结构体`中，所以不会发生循环引用。

## 基于类型的程序入口

在 [SE-0281](https://github.com/apple/swift-evolution/blob/master/proposals/0281-main-attribute.md) 中允许我们使用新的 `@main` 属性，它可以定义 app 的入口。用属性对结构体或类进行标记能够保证它是程序进入的位置，所以你不必手动调用 `AppDelegate.main()`。

```Swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
static func main() {
        print("App will launch & exit right away.")
    }
}
```

我们可以认为，在以后的版本中将弃用旧版本中特定域的属性 `@UIApplicationMain` 和 `@NSApplicationMain`，而推荐使用 `@main`。

## where 字句在泛型声明上下文中的变化

到目前为止，`where` 字句不能在泛型上下文内嵌声明。比如，如果你在方法中添加 `where` 限制，编译器会抛出错误。要解决这个问题，我们必须创建单独的扩展来处理特定的 `where` 子句。

在 [SE-0267](https://github.com/apple/swift-evolution/blob/master/proposals/0267-where-on-contextually-generic.md) 中，只要引用了泛型参数，我们就可以实现带有 `where` 字句的方法。下面是一个简短的代码片段：

```Swift
struct Base<T> {
    var value : T 
}

extension Base{

  func checkEquals(newValue: T) where T : Equatable{...}
  func doCompare(newValue: T) where T : Comparable{...}

}
```

通过在成员声明上允许 `where` 子句，我们可以轻松创建更短，更简洁的通用接口，而不用创建单独的扩展。

## 对集合中非连续元素的新操作

当前的版本中，访问集合中连续范围的元素很简单。对于数组，您只需用 `[startIndex ... endIndex]` 访问。

在 [SE-0270](https://github.com/apple/swift-evolution/blob/master/proposals/0270-rangeset-and-collection-operations.md) 中介绍了一种叫做 `RangeSet` 的新类型，它可以获取不连续索引的集合，

```Swift
var numbers = Array(1...15)

// Find the indices of all the even numbers
let indicesOfEvens = numbers.subranges(where: { $0.isMultiple(of: 2) })

// Find the indices of all multiples of 3
let multiplesofThree = numbers.subranges(where: { $0.isMultiple(of: 3) })

let combinedIndexes = multiplesofThree.intersection(indicesOfEvens)
let sum = numbers[combinedIndexes].reduce(0, +)
//Sum of 6 + 12 = 18
```

使用 `RangeSet`，我们可以对集合做很多计算和操作。例如，通过使用 `moveSubranges` 函数，我们可以在数组中移动一系列索引。这样我们可以很容易将数组中的所有偶数移动到数组的开头：

```Swift
let rangeOfEvens = numbers.moveSubranges(indicesOfEvens, to: numbers.startIndex)
// numbers == [2, 4, 6, 8, 10, 12, 14, 1, 3, 5, 7, 9, 11, 13, 15]
```

## 完善 didSet 语义

之前，无论属性的引用是否有新的赋值，`didSet` 属性观察器的 getter 方法总是会被调用来检索 `oldValue`。

这个机制可能对变量影响不大，但是对于大型数组，会分配存储空间并加载未使用的值，这个过程会影响程序性能。

[SE-0268](https://github.com/apple/swift-evolution/blob/master/proposals/0268-didset-semantics.md) 中提出，仅在需要时才会加载 `oldValue`，这将提升 `didSet` 属性观察器的效率。而且，如果只实现了 `didSet` 而没有实现 `willSet`，更新也会正常进行。

下面是改进版 `didSet` 的例子：

```Swift
class A {
    var firstArray = [1,2,3] {
        didSet { print("didSet called") }
    }

    var secondArray = [1,2,3,4] {
        didSet { print(oldValue) }
    }
}

let a = A()
// This will not call the getter to fetch the oldValue of firstArray
a.firstArray = [1,2]
// This will call the getter to fetch the oldValue of secondArray
a.secondArray = [1]
```

## Float16 新类型

[SE-0277](https://github.com/apple/swift-evolution/blob/master/proposals/0277-float16.md) 提出了 `Float16` —— 半精度浮点类型。随着近年来机器学习在移动设备上的出现，苹果公司在这一领域表现了其雄心壮志。`Float16` 通常用于移动设备上的 GPU 计算，并作为 ML 程序中权重的压缩格式。

```
let f16: Float16 = 7.29
```

## 总结

我们已经总结了 Swift 5.3 语言重要的新功能，Swift 包管理器也进行了很多改进。让我们快速浏览一下它们：

* [SE-0271](https://github.com/apple/swift-evolution/blob/master/proposals/0271-package-manager-resources.md) 允许您将资源（图像，数据文件等）添加到 Swift 包中。
* [SE-0278](https://github.com/apple/swift-evolution/blob/master/proposals/0278-package-manager-localized-resources.md) 可以添加本地化资源。
* [SE-0272](https://github.com/apple/swift-evolution/blob/master/proposals/0272-swiftpm-binary-dependencies.md) 允许您在软件包管理器中以二进制格式集成闭源依赖（例如 Firebase）。
* [SE-0273](https://github.com/apple/swift-evolution/blob/master/proposals/0273-swiftpm-conditional-target-dependencies.md) 使您可以有条件地为不同的目标平台指定依赖管理器。

您可以在[这个博客](https://swift.org/blog/additional-linux-distros/)下载 Swift 的 Linux 发行版。或者您可以直接访问[ Swift 的官网](https://swift.org/download/#snapshots)快速浏览 Swift 5.3 的快照版本。

本文结束。谢谢阅读。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

