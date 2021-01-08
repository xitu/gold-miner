> * 原文地址：[What’s new in Swift 5.0](https://www.hackingwithswift.com/articles/126/whats-new-in-swift-5-0)
> * 原文作者：[Paul Hudson](https://www.hackingwithswift.com/about)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-swift-5-0.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-swift-5-0.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[DevMcryYu](https://github.com/DevMcryYu), [swants](https://github.com/swants)

# Swift 5.0 新特性

![](https://www.hackingwithswift.com/uploads/swift-evolution-5.jpg)

Swift 5.0 是 Swift 的下一个主要的 release，随之而来的是 ABI 的稳定性，同时还实现了几个关键的新功能，包括 raw string，未来的枚举 case，`Result` 类型，检查整数倍数等等。

*  **你可以亲自尝试一下**：我创建了一个 [Xcode Playground](https://github.com/twostraws/whats-new-in-swift-5-0) 来展示 Swift 5.0 的新特性，里面有一些你可以参考的例子。

### 标准 `Result` 类型

*  [**YouTube 视频讲解**](https://www.youtube.com/watch?v=RBZFCp3kSLM)

[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) 在标准库中引入了全新的 `Result` 类型，它让我们能够更加方便清晰地在复杂的代码中处理 error，例如异步 API。

Swift 的 `Result` 类型是用枚举实现的，其中包含了 `success` 和 `failure`。它们两者都使用泛型，因此你可以为它们指定任意类型。但是 `failure` 必须遵循 Swift 的 `Error` 协议。

为了进一步演示 `Result`，我们可以写一个网络请求函数来计算用户有多少未读消息。在此示例代码中，我们将只有一个可能的错误，即请求的字符串不是有效的 URL：

```swift
enum NetworkError: Error {
    case badURL
}
```

fetch 函数将接受 URL 字符串作为其第一个参数，并将 completion 闭包作为其第二个参数。该 completion 闭包本身将接受一个 `Result`，其中 success 将存储一个整数，failure 将是某种 `NetworkError`。我们实际上并没有在这里连接到服务器，但使用 completion 闭包可以让我们模拟异步代码。

代码如下：

```swift
import Foundation

func fetchUnreadCount1(from urlString: String, completionHandler: @escaping (Result<Int, NetworkError>) -> Void)  {
    guard let url = URL(string: urlString) else {
        completionHandler(.failure(.badURL))
        return
    }

    // 此处省略复杂的网络请求
    print("Fetching \(url.absoluteString)...")
    completionHandler(.success(5))
}
```

要调用此函数，我们需要检查 `Result` 中的值来看看我们的请求是成功还是失败，代码如下：

```swift
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    switch result {
    case .success(let count):
        print("\(count) 个未读信息。")
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

在开始在自己的代码中使用 `Result` 之前，你还有三件事应该知道。

首先，`Result` 有一个 `get()` 方法，如果存在则返回成功值，否则抛出错误。这允许你将 `Result` 转换为常规会抛出错误的函数调用，如下所示：

```swift
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    if let count = try? result.get() {
        print("\(count) 个未读信息。")
    }
}
```

其次，`Result` 还有一个接受抛出错误闭包的初始化器：如果闭包返回一个成功的值，用于 `success` 的情况，否则抛出的错误则被传入 `failure`。

举例：

```swift
let result = Result { try String(contentsOfFile: someFile) }
```

第三，你可以使用通用的 `Error` 协议而不是你创建的特定错误的枚举。实际上，Swift Evolution 提议说道“预计 Result 的大部分用法都会使用 `Swift.Error` 作为 `Error` 类型参数。”

因此你要用 `Result <Int，Error>` 而非 `Result<Int, NetworkError>`。这虽然意味着你失去了可抛出错误类型的安全性，但你可以抛出各种不同的错误枚举，其实这取决于你的代码风格。

### Raw string

*   [**YouTube 视频讲解**](https://www.youtube.com/watch?v=e6tuUzmxyOU)

[SE-0200](https://github.com/apple/swift-evolution/blob/master/proposals/0200-raw-string-escaping.md) 添加了创建原始字符串（raw string）的功能，其中反斜杠和井号是被作为标点符号而不是转义字符或字符串终止符。这使得许多用法变得更容易，特别是正则表达式。

要使用原始字符串，请在字符串前放置一个或多个 `#`，如下所示：

```swift
let rain = #"西班牙"下的"雨"主要落在西班牙人的身上。"#
```

字符串开头和结尾的 `#` 成为字符串分隔符的一部分，因此 Swift 明白 "雨" 和 "西班牙" 两边独立引号应该被视为标点符号而不是终止符。

原始字符串也允许你使用反斜杠：

```swift
let keypaths = #"诸如 \Person.name 之类的 Swift keyPath 包含对属性未调用的引用。"#
```

这将反斜杠视为字符串中的文字字符而不是转义字符。不然则意味着字符串插值的工作方式不同：

```swift
let answer = 42
let dontpanic = #"生命、宇宙及万事万物的终极答案都是 \#(answer)."#
```

请注意我是如何使用 `\#(answer)` 来调用字符串插值的，一般 `\(answer)` 将被解释为 answer 字符串中的字符，所以当你想要在原始字符串中进行引用字符串插值时你必须添加额外的 `＃`。

Swift 原始字符串的一个有趣特性是在开头和结尾使用井号，因为你一般不会一下使用多个井号。这里很难提供一个很好的例子，因为它真的应该非常罕见，但请考虑这个字符串：**我的狗叫了一下 "汪"#好狗狗**。因为在井号之前没有空格，Swift 看到 `"#` 会立即把它作为字符串终止符。在这种情况下，我们需要将分隔符从 `#"` 改为 `##"`，如下所示：

```swift
let str = ##"我的狗叫了一下 "汪"#乖狗狗"##
```

注意末尾的井号数必须与开头的一致。

原始字符串与 Swift 的多行字符串系统完全兼容，只需使用 `#"""` 开始，然后以 `"""#` 结束，如下所示：

```swift
let multiline = #"""
生命、
宇宙,
以及众生的答案都是 \#(answer).
"""#
```

能在正则表达式中不再大量使用反斜杠足以证明这很有用。例如编写一个简单的正则表达式来查询关键路径，例如 `\Person.name`，看起来像这样：

```swift
let regex1 = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"
```

多亏了原始字符串，我们可以只用原来一半的反斜杠就可以编写相同的内容：

```swift
let regex2 = #"\\[A-Z]+[A-Za-z]+\.[a-z]+"#
```

我们仍然需要 **一些** 反斜杠，因为正则表达式也使用它们。

### Customizing string interpolation

[SE-0228](https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md) 大幅改进了 Swift 的字符串插值系统，使其更高效、灵活，并创造了以前不可能实现的全新功能。

在最基本的形式中，新的字符串插值系统让我们可以控制对象在字符串中的显示方式。Swift 具有有助于调试的结构体的默认行为，它打印结构体名称后跟其所有属性。但是如果你使用类的话就没有这种行为，或者想要格式化该输出以使其面向用户，那么你可以使用新的字符串插值系统。

例如，如果我们有这样的结构体：

```swift
struct User {
    var name: String
    var age: Int
}
```

如果我们想为它添加一个特殊的字符串插值，以便我们整齐地打印用户信息，我们将使用一个新的 `appendInterpolation()` 方法为 `String.StringInterpolation` 添加一个 extension。Swift 已经内置了几个，并且用户插值 **类型**，在这种情况下需要 `User` 来确定要调用哪个方法。

在这种情况下，我们将添加一个实现，将用户的名称和年龄放入一个字符串中，然后调用其中一个内置的 `appendInterpolation()` 方法将其添加到我们的字符串中，如下所示：

```swift
extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: User) {
        appendInterpolation("我叫\(value.name)，\(value.age)岁")
    }
}
```

现在我们可以创建一个用户并打印出他们的数据：

```swift
let user = User(name: "Guybrush Threepwood", age: 33)
print("用户信息：\(user)")
```

这将打印 **用户信息：我叫 Guybrush Threepwood，33 岁**，而使用自定义字符串插值它将打印 **用户信息：User(name: "Guybrush Threepwood", age: 33)** 。当然，该功能与仅实现` CustomStringConvertible` 协议没有什么不同，所以让我们继续使用更高级的用法。

你的自定义插值方法可以根据需要使用任意数量的参数，标记的和未标记的。例如，我们可以使用各种样式添加插值来打印数字，如下所示：

```swift
extension String.StringInterpolation {
    mutating func appendInterpolation(_ number: Int, style: NumberFormatter.Style) {
        let formatter = NumberFormatter()
        formatter.numberStyle = style

        if let result = formatter.string(from: number as NSNumber) {
            appendLiteral(result)
        }
    }
}
```

`NumberFormatter` 类有许多样式，包括货币形式（489.00 元），序数形式（第一，第十二）和朗读形式（五, 四十三）。 因此，我们可以创建一个随机数，并将其拼写成如下字符串：

```swift
let number = Int.random(in: 0...100)
let lucky = "这周的幸运数是 \(number, style: .spellOut)."
print(lucky)
```

你可以根据需要多次调用 `appendLiteral()`，如果需要的话甚至可以不调用。例如我们可以添加一个字符串插值来多次重复一个字符串，如下所示：

```swift
extension String.StringInterpolation {
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0 ..< count {
            appendLiteral(str)
        }
    }
}

print("Baby shark \(repeat: "doo ", 6)")
```

由于这些只是常规方法，你可以使用 Swift 的全部功能。例如，我们可能会添加一个将字符串数组连接在一起的插值，但如果该数组为空，则执行一个返回字符串的闭包：

```swift
extension String.StringInterpolation {
    mutating func appendInterpolation(_ values: [String], empty defaultValue: @autoclosure () -> String) {
        if values.count == 0 {
            appendLiteral(defaultValue())
        } else {
            appendLiteral(values.joined(separator: ", "))
        }
    }
}

let names = ["Harry", "Ron", "Hermione"]
print("学生姓名：\(names, empty: "空").")
```

使用 `@autoclosure` 意味着我们可以使用简单值或调用复杂函数作为默认值，但除非 `values.count` 为零，否则不会做任何事。

通过结合使用 `ExpressibleByStringLiteral` 和 `ExpressibleByStringInterpolation` 协议，我们现在可以使用字符串插值创建整个类型，如果我们添加 `CustomStringConvertible`，只要我们想要的话，甚至可以将这些类型打印为字符串。

为了让它生效，我们需要满足一些特定的标准：

* 我们创建的类型应该遵循 `ExpressibleByStringLiteral`，`ExpressibleByStringInterpolation` 和 `CustomStringConvertible`。只有在你想要自定义打印类型的方式时才需要遵循最后一个协议。
* 在你的类型 **内部** 需要是一个名为 `StringInterpolation` 并遵循 `StringInterpolationProtocol` 的嵌套结构体。
* 嵌套结构体需要有一个初始化器，它接受两个整数，告诉我们大概预期的数据量。
* 它还需要实现一个 `appendLiteral()` 方法，以及一个或多个 `appendInterpolation()` 方法。
* 你的主类型需要有两个初始化器，允许从字符串文字和字符串插值创建它。

我们可以将所有这些放在一个可以从各种常见元素构造 HTML 的示例类型中。嵌套 `StringInterpolation` 结构体中的 “暂存器” 将是一个字符串：每次添加新的文字或插值时，我们都会将其追加到字符串的末尾。为了让你确切了解其中发生了什么，我在各种追加方法中添加了一些 `print()` 来打印。

以下是代码：

```swift
struct HTMLComponent: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
    struct StringInterpolation: StringInterpolationProtocol {
        // 以空字符串开始
        var output = ""

        // 分配足够的空间来容纳双倍文字的文本
        init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity * 2)
        }

        // 一段硬编码的文本，只需添加它就可以
        mutating func appendLiteral(_ literal: String) {
            print("追加 ‘\(literal)’")
            output.append(literal)
        }

        // Twitter 用户名，将其添加为链接
        mutating func appendInterpolation(twitter: String) {
            print("追加 ‘\(twitter)’")
            output.append("<a href=\"https://twitter/\(twitter)\">@\(twitter)</a>")
        }

        // 电子邮件地址，使用 mailto 添加
        mutating func appendInterpolation(email: String) {
            print("追加 ‘\(email)’")
            output.append("<a href=\"mailto:\(email)\">\(email)</a>")
        }
    }

    // 整个组件的完整文本
    let description: String

    // 从文字字符串创建实例
    init(stringLiteral value: String) {
        description = value
    }

    // 从插值字符串创建实例
    init(stringInterpolation: StringInterpolation) {
        description = stringInterpolation.output
    }
}
```

我们现在可以使用字符串插值创建和使用 `HTMLComponent` 的实例，如下所示：

```swift
let text: HTMLComponent = "你应该在 Twitter 上关注我 \(twitter: "twostraws")，或者你可以发送电子邮件给我 \(email: "paul@hackingwithswift.com")。"
print(text)
```

多亏了分散在里面的 `print()`，你会看到字符串插值功能的准确作用：“追加 ‘你应该在 Twitter 上关注我’”，“追加 ’twostraws’”，“追加 ’，或者你可以发送电子邮件给我 ’”，“追加 ’paul@hackingwithswift.com’”，最后 “追加 ’。’”，每个部分触发一个方法调用，并添加到我们的字符串中。

### 动态可调用（dynamicCallable）类型

[SE-0216](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md) 为 Swift 添加了一个新的 `@dynamicCallable` 注解，它让一个类型能被直接调用。它是语法糖，而不是任何类型的编译器的魔法，它把以下这段代码：

```swift
let result = random(numberOfZeroes: 3)
```

转换为：

```swift
let result = random.dynamicallyCall(withKeywordArguments: ["numberOfZeroes": 3])
```

之前有一篇关于 [Swift 中的动态特性](https://juejin.im/post/5bfd087be51d457a013940e8) 的文章里有提到了动态查找成员（@dynamicMemberLookup）。`@dynamicCallable` 是 `@dynamicMemberLookup` 的自然扩展，它能使 Swift 代码更容易与 Python 和 JavaScript 等动态语言一起工作。

要将此功能添加到你自己的类型，你需要添加 `@dynamicCallable` 注解以及这些方法中的一个或两个：

```swift
func dynamicallyCall(withArguments args: [Int]) -> Double

func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double
```

第一个用于调用不带参数标签的类型（例如 `a(b, c)`），第二个用于你 **提供标签** 时（例如 `a(b: cat, c: dog)`）。

`@dynamicCallable` 对于其方法接受和返回的数据类型非常灵活，它使你可以从 Swift 的所有类型安全性中受益，同时具有一些高级用法。因此，对于第一种方法（无参数标签），你可以使用遵循了 `ExpressibleByArrayLiteral` 的任何东西，例如数组、数组切片和集合，对于第二种方法（使用参数标签），你可以使用遵循 `ExpressibleByDictionaryLiteral` 的任何东西。例如字典和键值对。

除了接受各种输入外，你还可以为各种输出提供多个重载，可能返回一个字符串、整数等等。只要 Swift 能推出使用哪一个，你就可以混合搭配你想要的一切。

我们来看一个例子。首先，这是一个 `RandomNumberGenerator` 结构体，它根据传入的输入生成介于 0 和某个最大值之间的数字：

```swift
struct RandomNumberGenerator {
    func generate(numberOfZeroes: Int) -> Double {
        let maximum = pow(10, Double(numberOfZeroes))
        return Double.random(in: 0...maximum)
    }
}
```

要把它切换到 `@dynamicCallable`，我们会写这样的代码：

```swift
@dynamicCallable
struct RandomNumberGenerator {
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double {
        let numberOfZeroes = Double(args.first?.value ?? 0)
        let maximum = pow(10, numberOfZeroes)
        return Double.random(in: 0...maximum)
    }
}
```

你可以传任意数量的参数甚至不传参数来调用该方法，因此我们小心读取第一个值并结合是否为 nil 的判断来确保存在合理的默认值。

我们现在可以创建一个 `RandomNumberGenerator` 实例并像函数一样调用它：

```swift
let random = RandomNumberGenerator()
let result = random(numberOfZeroes: 0)
```

如果你曾经使用过 `dynamicallyCall(withArguments:)`，或者同时使用，因为你可以让它们都是单一类型，就可以写以下代码：

```swift
@dynamicCallable
struct RandomNumberGenerator {
    func dynamicallyCall(withArguments args: [Int]) -> Double {
        let numberOfZeroes = Double(args[0])
        let maximum = pow(10, numberOfZeroes)
        return Double.random(in: 0...maximum)
    }
}

let random = RandomNumberGenerator()
let result = random(0)
```

使用 `@dynamicCallable` 时需要注意一些重要的规则：

* 你可以将其应用于结构体、枚举、类和协议。
* 如果你实现了 `withKeywordArguments:` 并且没有实现 `withArguments:`，你的类型仍然可以在没有参数标签的情况下调用，你只需要为键获得空字符串。
* 如果 `withKeywordArguments:` 或 `withArguments:` 的实现被标记为 throw，则调用该类型也将可抛出。
* 你不能把 `@dynamicCallable` 添加到 extension 里，只可在类的主体里面添加。
* 你仍然可以为你的类型添加其他方法和属性，并照常使用它们。

也许更重要的是，不支持方法决议，这意味着我们必须直接调用类型（例如 `random(numberOfZeroes: 5)`）而不是调用类型上的特定方法（例如 `random.generate(numberOfZeroes: 5)`）。已经有一些关于使用方法签名添加后者的讨论，例如：

```swift
func dynamicallyCallMethod(named: String, withKeywordArguments: KeyValuePairs<String, Int>)
```

如果那在未来的 Swift 版本中可能实现，它可能会为 test mock 创造出一些非常有趣的可能性。

与此同时 `@dynamicCallable` 不太可能广受欢迎，但对于希望与 Python，JavaScript 和其他语言交互的少数人来说，它非常重要。

### 面向未来的枚举 case

[SE-0192](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md) 增加了在固定的枚举和可能将被改变的枚举间的区分度。

Swift 的一个安全特性是它要求所有 switch 语句都是详尽的，它们必须覆盖所有情况。虽然这从安全角度来看效果很好，但是在将来添加新案例时会导致兼容性问题：系统框架可能会发送你未提供的不同内容，或者你依赖的代码可能会添加新案例并导致你的编译中断，因为你的 switch 不再详尽。

使用 `@unknown` 注解，我们现在可以区分两个略有不同的场景：“这个默认情况应该针对所有其他情况运行，因为我不想单独处理它们” 和 “我想单独处理所有情况，但如果将来出现任何问题，请使用此而非报错。”

以下是一个枚举示例：

```swift
enum PasswordError: Error {
    case short
    case obvious
    case simple
}
```

我们可以使用 `switch` 编写代码来处理每个案例：

```swift
func showOld(error: PasswordError) {
    switch error {
    case .short:
        print("Your password was too short.")
    case .obvious:
        print("Your password was too obvious.")
    default:
        print("Your password was too simple.")
    }
}
```

对于短密码和弱强度密码，它使用两个 case，但将第三种情况将会到 default 中处理。

现在如果将来我们在 enum 中添加了一个名为 `old` 的新 case，对于以前使用过的密码，我们的 `default` case 会被自动调用，即使它的消息没有意义。

Swift 无法向我们发出有关此代码的警告，因为它在语法上没有问题，因此很容易错过这个错误。幸运的是，新的 `@unknown` 注解完美地修复了它，它只能用于 `default` 情况，并且设计为在将来出现新案例时可以运行。

例如：

```swift
func showNew(error: PasswordError) {
    switch error {
    case .short:
        print("Your password was too short.")
    case .obvious:
        print("Your password was too obvious.")
    @unknown default:
        print("Your password wasn't suitable.")
    }
}
```

该代码现在将产生警告，因为 `switch` 块不再详尽，Swift 是希望我们明确处理每个 case 的。实际上这只是一个 **警告**，这使得这个属性很实用：如果一个框架在未来添加一个新 case，你将得到警告，但它不会让你的代码编译不通过。

### try? 嵌套可选的展平

[SE-0230](https://github.com/apple/swift-evolution/blob/master/proposals/0230-flatten-optional-try.md) 修改 `try?` 的工作方式，以便嵌套的可选项被展平成为一个常规的选择。这使得它的工作方式与可选链和条件类型转换（if let）的工作方式相同，这两种方法都在早期的 Swift 版本中展平了可选项。

这是一个演示变化的示例：

```swift
struct User {
    var id: Int

    init?(id: Int) {
        if id < 1 {
            return nil
        }

        self.id = id
    }

    func getMessages() throws -> String {
        // 复杂的一段代码
        return "No messages"
    }
}

let user = User(id: 1)
let messages = try? user?.getMessages()
```

`User` 结构体有一个可用的初始化器，因为我们想确保开发者创建具有有效 ID 的用户。`getMessages()` 方法理论上包含某种复杂的代码来获取用户的所有消息列表，因此它被标记为 `throws`，我已经让它返回一个固定的字符串，所以代码可编译通过。

关键在于最后一行：因为用户是可选的而使用可选链，因为 `getMessages()` 可以抛出错误，它使用 `try?` 将 throw 方法转换为可选的，所以我们最终得到一个嵌套的可选。在 Swift 4.2 和更早版本中，这将使 `messages` 成为 `String??`，一个可选的可选字符串，但是在 Swift 5.0 和更高版本中 `try?` 如果对于已经是可选的类型，它们不会将值包装成可选类型，所以 `messages` 将只是一个 `String?`。

此新行为与可选链和条件类型转换（if let）的现有行为相匹配。也就是说，如果你需要的话，可以在一行代码中使用可选链十几次，但最终不会有那么多个嵌套的可选。类似地，如果你使用 `as?` 的可选链，你仍然只有一个级别的可选性，而这通常是你想要的。

### Integer 整倍数自省

* [**YouTube 视频讲解**](https://www.youtube.com/watch?v=iCRwqxON8Os)

[SE-0225](https://github.com/apple/swift-evolution/blob/master/proposals/0225-binaryinteger-iseven-isodd-ismultiple.md) 为整数添加 `isMultiple(of:)` 方法来允许我们以比使用取余数运算 `%` 更清晰的方式检查一个数是否是另一个数的倍数。

例如：

```swift
let rowNumber = 4

if rowNumber.isMultiple(of: 2) {
    print("Even")
} else {
    print("Odd")
}
```

没错，我们可以使用 `if rowNumber % 2 == 0` 实现相同的功能，但你不得不承认这样看起来不清晰，使用 `isMultiple(of:)` 意味着它可以在 Xcode 的代码自动补全中列出，这有助于你发现。

### 使用 compactMapValues() 转换和解包字典值

* [**YouTube 视频讲解**](https://www.youtube.com/watch?v=Le32Tbkv2v0)

[SE-0218](https://github.com/apple/swift-evolution/blob/master/proposals/0218-introduce-compact-map-values.md) 为字典添加了一个新的 `compactMapValues()` 方法，它能够将数组中的 `compactMap()` 功能转换我需要的值，解包结果，然后丢弃任何 nil，与字典中的 `mapValues()` 方法一起使用能保持键的完整并只转换值。

举个例子，这里是一个比赛数据的字典，以及他们完成的秒数。其中有一个人没有完成，标记为 “DNF”（未完成）：

```swift
let times = [
    "Hudson": "38",
    "Clarke": "42",
    "Robinson": "35",
    "Hartis": "DNF"
]
```

我们可以使用 `compactMapValues()` 创建一个名字和时间为整数的新字典，删除一个 DNF 的人：

```swift
let finishers1 = times.compactMapValues { Int($0) }
```

或者你可以直接将 `Int` 初始化器传递给 `compactMapValues()`，如下所示：

```swift
let finishers2 = times.compactMapValues(Int.init)
```

你还可以使用 `compactMapValues()` 来展开选项并丢弃 nil 值而不执行任何类型转换，如下所示：

```swift
let people = [
    "Paul": 38,
    "Sophie": 8,
    "Charlotte": 5,
    "William": nil
]

let knownAges = people.compactMapValues { $0 }
```

### 被移除的特性：计算序列中的匹配项

* [**YouTube 视频讲解**](https://www.youtube.com/watch?v=syPKtPb0y-Y)

**这个 Swift 5.0 功能在 beta 版中被撤销，因为它导致了类型检查器的性能问题。希望它能够在 Swift 5.1 回归，或者用一个新名称来避免问题。**

[SE-0220](https://github.com/apple/swift-evolution/blob/master/proposals/0220-count-where.md) 引入了一个新的 `count(where:)` 方法，该方法执行 `filter()` 的等价方法并在一次传递中计数。这样可以节省立即丢弃的新阵列的创建，并为常见问题提供清晰简洁的解决方案。

此示例创建一个测试结果数组，并计算大于或等于 85 的数的个数：

```swift
let scores = [100, 80, 85]
let passCount = scores.count { $0 >= 85 }
```

这计算了数组中有多少名称以 “Terry” 开头：

```swift
let pythons = ["Eric Idle", "Graham Chapman", "John Cleese", "Michael Palin", "Terry Gilliam", "Terry Jones"]
let terryCount = pythons.count { $0.hasPrefix("Terry") }
```

所有遵循 `Sequence` 的类型都可以使用此方法，因此你也可以在集合和字典上使用它。

### 接下来干嘛？

Swift 5.0 是 Swift 的最新版本，但之前的版本也包含了很多功能。你可以阅读以下文章：

*   [What's new in Swift 4.2?](https://www.hackingwithswift.com/articles/77/whats-new-in-swift-4-2)
*   [What's new in Swift 4.1?](https://www.hackingwithswift.com/articles/50/whats-new-in-swift-4-1)
*   [What's new in Swift 4.0?](https://www.hackingwithswift.com/swift4)

但还有更多，苹果已经在 Swift.org 上宣布了 [Swift 5.1发布流程](https://swift.org/blog/5-1-release-process/)，其中包括模块稳定性以及其他一些改进。在撰写本文时，5.1 的附加条款很少，但看起来我们会看到它在 WWDC 附近发布。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
