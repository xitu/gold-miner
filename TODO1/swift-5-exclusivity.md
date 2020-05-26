> * 原文地址：[Swift 5 Exclusivity Enforcement](https://swift.org/blog/swift-5-exclusivity/)
> * 原文作者：[swift.org](https://swift.org)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/swift-5-exclusivity.md](https://github.com/xitu/gold-miner/blob/master/TODO1/swift-5-exclusivity.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[Bruce-pac](https://github.com/Bruce-pac), [Danny1451](https://github.com/Danny1451)

# Swift 5 强制独占性原则

> 在理解概念时参照了喵神的[所有权宣言 - Swift 官方文章 Ownership Manifesto 译文评注版](https://onevcat.com/2017/02/ownership/)

Swift 5 允许在 Release 构建过程中默认启用关于「独占访问内存」的运行时检查，进一步增强了 Swift 作为安全语言的能力。在 Swift 4 中，这种运行时检查仅允许在 Debug 构建过程中启用。在这篇文章中，首先我将解释这个变化对 Swift 开发人员的意义，然后再深入研究为什么它对 Swift 的安全和性能策略至关重要。

## 背景

为了实现 [内存安全](https://docs.swift.org/swift-book/LanguageGuide/MemorySafety.html)，Swift 需要对变量进行独占访问时才能修改该变量。本质上来说，当一个变量作为 `inout` 参数或者 `mutating` 方法中的 `self` 被修改时，不能通过不同的名称被访问的。

在以下示例中，`modifyTwice` 函数通过将 `count` 作为 `inout` 参数传入来对它进行修改。出现独占性违规情况是因为，在 `count` 变量被修改的作用域内，`modifier` 闭包对 `count` 在变量进行读取操作的同时也被调用了。在 `modifyTwice` 函数中，`count` 变量只能通过 `inout` 修饰的 `value` 参数来进行安全访问，而在 `modifier` 闭包内，它只能以 `$0` 来进行安全访问。

```swift
func modifyTwice(_ value: inout Int, by modifier: (inout Int) -> ()) {
  modifier(&value)
  modifier(&value)
}

func testCount() {
  var count = 1
  modifyTwice(&count) { $0 += count }
  print(count)
}
```

违反独占性的情况通常如此，程序员的意图此时显得有些模糊。他们希望 `count` 打印的值是「3」还是「4」呢？无论哪种结果，编译器都无法保证。更糟糕的是，编译器优化会在出现此类错误时产生微妙的不可预测行为。为了防止违反独占性并允许引入依赖于安全保证的语言特性，强制独占性最初在 Swift 4.0 中引入的：[SE-0176：实施对内存的独占访问](https://github.com/apple/swift-evolution/blob/master/proposals/0176-enforce-exclusive-access-to-memory.md)。

编译时（静态）检测可以捕获许多常见的独占性违规行为，但是还需要运行时（动态）检测来捕获涉及逃逸闭包，类类型的属性，静态属性和全局变量的违规情况。Swift 4.0 同时提供了编译时和运行时的强制性检测，但运行时的强制检测仅在 Debug 构建过程中启用。

在 Swift 4.1 和 4.2 中，编译器检查能力逐渐得到加强，可以捕获到越来越多程序员绕过独占性规则的情况 —— 最明显的是在非逃逸闭包中捕获变量，或者将非逃逸闭包转换为逃逸闭包。Swift 4.2 宣称，[在 Swift 4.2 中将独占访问内存警告升级为错误](https://forums.swift.org/t/upgrading-exclusive-access-warning-to-be-an-error-in-swift-4-2/12704)，并解释了一些受新强制独占性检测影响的常见案例。

Swift 5 修复了语言模型中剩余的漏洞，并完全执行了该模型。 由于在 Release 编译过程中默认启用了对内存独占情况的强制性运行时检查，一些以前表现得很好的但未在 Debug 模式下被充分测试的 Swift 程序可能会受到一些影响.

一些罕见的还无法被编译器检测出来的涉及非法代码的情况（[SR-8546](https://bugs.swift.org/browse/SR-8546)，[SR-9043](https://bugs.swift.org/browse/SR-9043)）。

## 对 Swift 项目的影响

Swift 5 中的强制独占性检查对现有项目可能会产生以下两种影响：

1. 如果项目源码违反了 Swift 的独占性规则（具体查看 [SE-0176：实施对内存的独占访问](https://github.com/apple/swift-evolution/blob/master/proposals/0176-enforce-exclusive-access-to-memory.md)），Debug 调试测试时未能执行无效代码，然后，在构建 Release 二进制文件时可能会触发运行时陷阱。产生崩溃并抛出一个包含字符串的诊断消息：

   「Simultaneous accesses to …, but modification requires exclusive access」

    源代码级别修复通常很简单。后面的章节会展示常见的违规和修复示例。
    
2. 内存访问检查的开销可能会影响的 Release 二进制包的性能。在大多数情况下，这种影响应该很小；如果你发现某个明显的性能下降情况，请提交 bug，以便我们了解需要改进的内容。作为一般性准则，应当避免在大多数性能关键循环中执行类属性访问，特别是在每个循环迭代中的不同对象上。如果必须如此，那么你可以将类属性修饰为 `private` 或 `internal` 来帮助告知编译器没有其他代码访问循环内的相同属性。

你可以通过 Xcode 的「Exclusive Access to Memory」构建设置来禁用这些运行时检查，该设置还有「Run-time Checks in Debug Builds Only」和「Compile-time Enforcement Only」两个选项：

![Xcode exclusivity build setting](https://swift.org/assets/images/exclusivity-blog/XcodeBuildSettings.png)

相对应的 swiftc 编译器标志是 `-enforce-exclusivity = unchecked` 和 `-enforce-exclusivity = none`。

虽然禁用运行时检查可能会解决性能下降问题，但这并不意味着违反独占性是安全的。如果没有启用强制执行，程序员就必须承担遵守独占性规则的责任。强烈建议不要在构建 Release 包时禁用运行时检查，因为如果程序违反独占他性原则，则可能会出现不可预测的结果，包括崩溃或内存损坏。即使程序现在似乎能正常运行，未来的 Swift 版本也可能导致出现其他不可预测的情况，并且可能会暴露安全漏洞。

## 示例

在背景部分中的「testCount」示例中通过将局部变量作为 `inout` 参数来传递，与此同时在闭包中捕获它来违反了独占性原则。编译器在构建时检测到这一段时，就会如下面的屏幕截图所示：

![testCount error](https://swift.org/assets/images/exclusivity-blog/Example1.png)

通常可以通过添加 `let` 来简单地修复 `inout` 参数的违规情况：

```swift
let incrementBy = count
modifyTwice(&count) { $0 += incrementBy }
```

下一个示例可能会在 `mutating` 方法中同时修改 `self`，从而产生异常。`append(removingFrom:)` 方法通过删除另一个数组中所有元素来增加数组元素：

```swift
extension Array {
    mutating func append(removingFrom other: inout Array<Element>) {
        while !other.isEmpty {
            self.append(other.removeLast())
        }
    }
}
```

但是，使用此方法将自身数组中的所有元素添加到自身将引发意外情况 —— 死循环。在这里，编译器在构建时再次抛出异常，因为「inout arguments are not allowed to alias each other」：

![append(removingFrom:) error](https://swift.org/assets/images/exclusivity-blog/Example2.png)

为了避免这些同时修改，可以将局部变量复制到另一个 `var` 中，然后作为 `inout` 参数传递给 mutating 方法：

```swift
var toAppend = elements
elements.append(removingFrom: &toAppend)
```

现在，这两个修改方法对不同的变量进行修改，所以没有产生冲突。

可以在 [在 Swift 4.2 中将独占访问内存警告升级为错误](https://forums.swift.org/t/upgrading-exclusive-access-warning-to-be-an-error-in-swift-4-2/12704) 中找到导致构建错误的一些常见情况的示例。

通过更改第一个示例，使用全局变量而不是局部变量，可以防止编译器在构建时抛出错误。然而，运行程序会命中「Simultaneous access」的检查:

![global count error](https://swift.org/assets/images/exclusivity-blog/Example3.png)

如示例中所示，在许多情况下，冲突访问发生在不同的语句中。

```swift
struct Point {
    var x: Int = 0
    var y: Int = 0

    mutating func modifyX(_ body:(inout Int) -> ()) {
        body(&x)
    }
}

var point = Point()

let getY = { return point.y  }

// Copy `y`'s value into `x`.
point.modifyX {
    $0 = getY()
}
```

运行时检测捕获了在开始调用 `modifyX` 时的访问信息，以及在 `getY` 闭包内发生冲突的访问信息，以及显示了导致冲突的堆栈信息：

```swift
Simultaneous accesses to ..., but modification requires exclusive access.
Previous access (a modification) started at Example`main + ....
Current access (a read) started at:
0    swift_beginAccess
1    closure #1
2    closure #2
3    Point.modifyX(_:)
Fatal access conflict detected.
```

Xcode 首先确定了内部访问冲突：

![Point error: inner position](https://swift.org/assets/images/exclusivity-blog/Example4a.png)

从侧边栏中当前线程的视图中选择「上一次访问」来确定外部修改：

![Point error: outer position](https://swift.org/assets/images/exclusivity-blog/Example4b.png)

通过复制闭包中所需要用的任何值，可以避免独占性违规：

```swift
let y = point.y
point.modifyX {
    $0 = y
}
```

如果这是在没有 getter 和 setter 的情况下编写的：

```swift
point.x = point.y
```

…那么就不存在独占性违规，因为在一个简单的赋值中（没有 `inout` 参数），修改是瞬间的。

在这一点上，读者可能想知道为什么在读写两个单独的属性时，原始示例被视为违反独占性规则；`point.x` 和 `point.y`。因为 `Point` 被声明为 `struct`，它被认为是一个值类型，这意味着它的所有属性都是整个值的一部分，访问任何一个属性都会访问整个值。当通过简单的静态分析可以证明安全性时，编译器会对此规则进行例外处理。 特别是，当同一语句发起对两个不相交存储的属性访问时，编译器会避免抛出违反独占性的报告。在下一个示例中，先调用 `modifyX` 的方法访问 `point`，以便立即将其属性 `x` 作为 `inout` 传递。然后用相同的语句再次访问 `point`，以便在闭包中捕获它。因为编译器可以立即看到捕获的值只用于访问属性 `y`，所以没有错误。

```swift
func modifyX(x: inout Int, updater: (Int)->Int) {
  x = updater(x)
}

func testDisjointStructProperties(point: inout Point) {
  modifyX(x: &point.x) { // First `point` access
    let oldy = point.y   // Second `point` access
    point.y = $0;        // ...allowed as an exception to the rule.
    return oldy
  }
}
```

属性可以分为三类：

1. 值类型的实例属性
    
2. 引用类型的实例属性
    
3. 任意类型的静态和类属性
    

只有对第一类属性（实例属性）的修改才会要求对聚合值的整体存储具有独占性访问，如上面的 `struct Point` 示例所示。另外两种类别可以作为独立存储分别执行。 如果这个例子被转换成一个类对象，那么将不会违反独占性原则：

```swift
class SharedPoint {
    var x: Int = 0
    var y: Int = 0

    func modifyX(_ body:(inout Int) -> ()) {
        body(&x)
    }
}

var point = SharedPoint()

let getY = { return point.y  } // no longer a violation when called within modifyX

// Copy `y`'s value into `x`.
point.modifyX {
    $0 = getY()
}
```

## 目的

上述编译时和运行时独占性检查的结合对于加强 Swift 的 [内存安全](https://docs.swift.org/swift-book/LanguageGuide/MemorySafety.html) 是很必要的。完全执行这些规则，而不是让程序员承担遵守独占性规则的负担，至少有以下五种帮助：

1. 执行独占性检查消除了程序涉及可变状态和远距离动作的危险交互。

    随着程序规模的不断扩大，越来越可能会以意想不到的方式进行交互。下面的例子在类似于上面的`Array.append(removedFrom:)` 例子，需要执行独占性检查来避免程序员将相同的变量同时作为源数据和目标数据进行传递。但请注意，一旦涉及到类对象，因为这两个变量引用了同一个对象，程序就会在无意中更容易在 `src` 和 `dest` 位置上传递同一个的 `Names` 实例。当然，这样就会导致死循环：

```swift
func moveElements(from src: inout Set<String>, to dest: inout Set<String>) {
    while let e = src.popFirst() {
        dest.insert(e)
    }
}
 
class Names {
    var nameSet: Set<String> = []
}
 
func moveNames(from src: Names, to dest: Names) {
    moveElements(from: &src.nameSet, to: &dest.nameSet)
}
 
var oldNames = Names()
var newNames = oldNames // Aliasing naturally happens with reference types.
 
moveNames(from: oldNames, to: newNames)
```

   [SE-0176：实施对内存的独占访问](https://github.com/apple/swift-evolution/blob/master/proposals/0176-enforce-exclusive-access-to-memory.md) 更深入地描述了这个问题。

2. 执行独占性检查消除了语言中未指定的行为规则。

   在 Swift 4 之前，独占性对于明确定义的程序行为是必要的，但规则是不受限制的。在实践中，人们很容易以微妙的方式违反这些规则，使程序容易受到不可预测的行为的影响，特别是在编译器的各个发布版本中。

3. 执行独占性检查是稳定 ABI 的必要条件。

   未能完全执行独占性检查将会对 ABI 的稳定性产生不可预测的影响。在没有进行完全检查的情况下构建的现有二进制文件可能在某一个版本中能够正常运行，但在未来的编译器版本、标准库和运行时中无法正确运行。

4. 执行独占性检查使性能优化更合法，同时保护内存安全。

    对 `inout` 参数和 `mutating` 方法的独占性检查向编译器提供了重要信息，可用于优化内存访问和引用计数操作。鉴于 Swift 是一种内存安全语言，如上面第2点所述，简单地声明一个未指定的行为规则对于编译器来说是不够的。完全强制执行独占性检查允许编译器基于内存独占性进行优化，而不会牺牲内存安全性。

5. 独占性规则为程序员提供所有权和仅移动类型的控制权。

   在 Swift 的 [所有权宣言](https://github.com/apple/swift/blob/master/docs/OwnershipManifesto.m) 中新增了 [独占性原则](https://github.com/apple/swift/blob/master/docs/OwnershipManifesto.md#the-law-of-exclusivity)，并解释了它如何为语言添加所有权和仅限移动类型提供依据。

## 总结

通过在 Release 构建过程中强制启动完全独占性检查，Swift 5 有助于消除错误和安全性问题，确保二进制兼容性，并支持未来的优化和语言功能。

## 还有疑问?

请随时在 Swift 论坛的 [相关主题](https://forums.swift.org/t/swift-org-blog-swift-5-exclusivity-enforcement/20178) 上发布相关的问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
