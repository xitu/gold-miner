>* 原文链接 : [Compile Time vs. Run Time Type Checking in Swift](http://blog.benjamin-encz.de/post/compile-time-vs-runtime-type-checking-swift/)
* 原文作者 : [Benjamin Encz](https://twitter.com/benjaminencz)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Jack](https://github.com/Jack-Kingdom)
* 校对者: [Tuccuay](https://github.com/Tuccuay), [void-main](https://github.com/void-main)

# 深度剖析 Swift 编译与运行时的类型检查

当我们学习如何使用 Swift 的类型系统时，理解 Swift（与其他编程语言类似）静态与动态两种不同的类型检查机制非常重要。 今天,我想简短地谈论一下二者的不同以及组合使用二者时一些令人头疼的地方。

静态类型检查发生在编译期，动态类型检查则在运行期。 二者使用了部分不兼容的不同工具集。

## 编译期的类型检查

编译期类型检查（或称为静态类型检查）操作 Swift 源码。 Swift 编译器会检查声明的类型并进行类型推断，确保类型约束的正确性。

这是一个静态类型检查的简单的例子：

    let text: String = ""
    // 编译错误: 不能将 'String' 类型的值转换为 'Int' 
    let number: Int = text

据源码编译器能够确定 `text` 不是 `Int` 类型 - 因此他抛出了一个编译错误。

Swift 的静态类型检查器可以完成许多更强大的工作，例如验证泛型约束：

    protocol HasName {}
    protocol HumanType {}

    struct User: HasName, HumanType { }
    struct Visitor: HasName, HumanType { }
    struct Car: HasName {}

    // Require a type that is both human and provides a name
    func printHumanName<T: protocol<HumanType, HasName>>(thing: T) {
        // ...
    }

    // 正常编译：
    printHumanName(User())
    // 正常编译：
    printHumanName(Visitor())
    // 不能用类型为 '(Car)' 的参数列表调用 'printHumanName' 
    printHumanName(Car())

在这个例子中，所有的类型检查再次发生在编译期，仅基于源代码。 Swift 编译器能够验证调用 `printHumanName` 函数的参数与泛型约束的是否匹配；一有不符便会发出编译错误。
尽管 Swift 的静态类型系统提供了如此多的编译期验证的强大工具。 但是，在某些情况下，运行期类型检查也是必要的。

## 运行期的类型检查

不幸的是我们并不能光靠静态类型检查就解决所有问题。 从外部资源（网络，数据库，等等）读取数据就是最常见的例子。 在这些情况下数据和类型信息并不在源码中，此外我们也无法向静态类型检查器证明我们的数据是一个特定的类型（因为静态类型检查器只能对源码上获取的信息进行操作）。

这意味着我们需要在运行期动态地_验证_类型，而非静态地定义。

在进行运行期的类型检查时我们依赖于 Swift 实例存储在内存中的元数据类型。 在这个阶段，`is` 和 `as` 关键字是验证元数据是否是特定类型或符合特定协议的实例的仅有工具。

这也是形形色色的 Swift JSON 映射库所做的事——提供一套方便的API动态地转换一个未知的类型使其与一个特定变量的类型相匹配。

在许多情况下动态类型检查使得我们能够在通过静态检查的 Swift 代码中整合编译期的未知类型：

    func takesHuman(human: HumanType) {}

    var unknownData: Any = User()

    if let unknownData = unknownData as? HumanType {
        takesHuman(unknownData)
    }

以 `unknownData` 调用函数，我们只需将其转换为函数的参数类型。

虽然如此，如果我们尝试使用这种方法去调用以泛型约束为参的函数时，则会出错...

## 结合动态与静态类型检查

继续之前 `printHumanName` 的例子，假定我们通过网络请求收到了数据，继而我们需要调用 `printHumanName` 方法 - 如果动态类型推断允许我们这样做的话。

我们的类型必须符合两种不同的协议才能成为 `printHumanName` 函数的合格参数。
那么，我们动态地检查一下条件：

    var unknownData: Any = User()

    if let unknownData = unknownData as? protocol<HumanType, HasName> {
        // 编译错误：不能以 '(protocol<HasName, HumanType>)' 参数类型调用 'printHumanName' 
        printHumanName(unknownData)
    }

上面例子中的动态类型检查实际上正确地执行了。 确认类型满足两种预期的协议后， `if let`代码块才能执行。 虽然如此，我们不能对编译器如此使用。 编译器期待的是一个符合 `HumanType` 与 `HasName` 的_具体的_类型（能够在编译期完全界定的类型）。 而我们所能提供的是一个只能动态验证的类型。

在 Swift 2.2 中，没有办法使其通过编译。 在这篇文章的最后，我我将简要地谈一谈如何对 Swift 做出一些必要的改变使得这种方法能够工作。

现在，我们需要一个解决方案。

### 解决方案

之前，我们尝试使用了下面两种方法：

*   将 `unknownData` 转换为一种确定的类型而非协议
*   提供 `printHumanName` 第二种不使用泛型约束的实现

确定类型的解决方案如下：

    if let user = unknownData as? User {
        printHumanName(user)
    } else if let visitor = unknownData as? Visitor {
        printHumanName(visitor)
    }

并不优雅；但在某些情况下这是最可能的解决方案。

重新实现 `printHumanName` 方法的解决方案如下(具体的方案有很多)： 

    func _printHumanName(thing: Any) {
        if let hasName = thing as? HasName where thing is HumanType {
            // Put implementation code here
            // Or call a third function that is shared between
            // both implementations of `printHumanName`
        } else {
            fatalError("Provided Incorrect Type")
        }
    }

    _printHumanName(unknownData)

在这种解决方案里，我们用运行期检查取代了编译器约束。 我们将 `Any` 类型转换为能够允许我们获取相应信息打印姓名的 `HasName` 类型，并且我们使用了 `is` 检查确认类型符合 `HumanType` 。 我们已经确立了一种等价于泛型约束的动态类型检查。

如果一个随机的类型符合我们需要的协议，那么我们所提供的第二种实现将会动态地执行。实际上，我会将调用 `printHumanName` 与 `_printHumanName` 的实际功能抽取出来写成一个新的函数——这样我们就能避免重复编码。

方案中的“类型擦除”函数接受一个 `Any` 参数并不十分美观； 实际上在函数能够被保证通过正确的类型调用时我使用过类似的方法，但是没有一种 Swift 类型系统支持的表达方式。

## 结论

上面的例子是非常简单的，但是我希望他们能展示编译期与运行期类型检查的不同。 关键在于：

*   静态类型检查在编译期工作，依靠类型声明和类型约束对源码进行类型检查。
*   动态类型检查依靠运行时的信息和转换进行类型检查。
*   **我们不能动态转换一个参数去调用一个以泛型约束为参的函数**.

Swift 是否有可能会添加这样的支持呢？ 我认为这种动态地创建和使用约束元类型的能力需要的。
这种语法可能会像这样：

    if let <T: HumanType, HasName> value = unknownData as? T {
    	printHumanName(value)
    }

关于 Swift 编译器我了解的太少以至于我并不知道这样是否可行。 可以预见的是这样的改进相比给 Swift 代码库的微小益处而言，修改关联代码重新实现的代价将可能非常巨大。

虽然如此, 根据这篇 [David Smith](https://twitter.com/Catfish_Man) 在 [Stack Overflow 的回答](http://stackoverflow.com/questions/28124684/swift-check-if-generic-type-conforms-to-protocol)， Swift 现今已可以在运行期检查泛型约束（除非编译器为一个函数生成的性能优化的副本）. 这意味着泛型约束的信息在运行期是可用的，并且至少在理论上来说动态创建元类型约束是可行的。

现在，我们就更好理解结合动态与静态类型检查的局限性和可行的解决方法。

没有 [@AirspeedSwift](https://twitter.com/AirspeedSwift) 的优秀引文我难以完成这篇文章。
