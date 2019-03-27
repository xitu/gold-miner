> * 原文地址：[What’s new in Swift 5.0](https://www.hackingwithswift.com/articles/126/whats-new-in-swift-5-0)
> * 原文作者：[Paul Hudson](https://www.hackingwithswift.com/about)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-swift-5-0.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-swift-5-0.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：

# Swift 5.0 新特性

![](https://www.hackingwithswift.com/uploads/swift-evolution-5.jpg)

Swift 5.0 是 Swift 的下一个主要发行版，随之而来的是 ABI 的稳定性，同时还实现了几个关键的新功能，包括 raw string，未来的枚举 case，`Result` 类型，检查整数倍数等等。

*  **你可以亲自尝试一下：** 我创建了一个 [Xcode Playground](https://github.com/twostraws/whats-new-in-swift-5-0) 来展示 Swift 5.0 的新特性，里面有一些你可以参考的例子。

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

fetch 函数将接受 URL 字符串作为其第一个参数，并将 completion 闭包作为其第二个参数。该 completion 闭包本身将接受一个`Result`，其中 success 将存储一个整数，failure 将是某种  `NetworkError`。我们实际上并没有在这里连接到服务器，但使用 completion 闭包可以让我们模拟异步代码。

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

第三，你可以使用通用的 `Error` 协议而不是你创建的特定错误的枚举。实际上，Swift Evolution 提议说道 “预计 Result 的大部分用法都会使用 `Swift.Error` 作为 `Error` 类型参数。”

因此你要用 `Result <Int，Error>` 而非 `Result <Int，NetworkError>`。这虽然意味着你失去了可抛出错误类型的安全性，但你可以抛出各种不同的错误枚举，其实这取决于你的代码风格。

### Raw string

*   [**YouTube 视频讲解**](https://www.youtube.com/watch?v=e6tuUzmxyOU)

[SE-0200](https://github.com/apple/swift-evolution/blob/master/proposals/0200-raw-string-escaping.md) 添加了创建原始字符串（raw string）的功能，其中反斜杠和井号是被作为标点符号而不是转义字符或字符串终止符。这使得许多用法变得更容易，但特别是正则表达式。

要使用原始字符串，请在字符串前放置一个或多个 `#`，如下所示：

```swift
let rain = #""西班牙"下的"雨"主要落在西班牙人的身上。"#
```

字符串开头和结尾的 `#` 成为字符串分隔符的一部分，因此 Swift 明白 "雨" 和 "西班牙" 两边独立引号应该被视为标点符号而不是终止符。

原始字符串也允许你使用反斜杠：

```swift
let keypaths = #"诸如 \Person.name 之类的 Swift keyPath 包含对属性未调用的引用。"#
```

这将反斜杠视为字符串中的文字字符而不是转义字符。不然则意味着字符串插值的工作方式不同：

```swift
let answer = 42
let dontpanic = #"生命、宇宙和一切的答案都是 \#(answer)."#
```

请注意我是如何使用 `\#(answer)` 来调用字符串插值的，一般 `\(answer)` 将被解释为 answer 字符串中的字符，所以当你想要在原始字符串中进行引用字符串插值时你必须添加额外的 `＃`。

Swift 原始字符串的一个有趣特性是在开头和结尾使用井号，因为你一般不会一下使用多个井号。这里很难提供一个很好的例子，因为它真的应该非常罕见，但请考虑这个字符串：**我的狗叫了一下 "汪"#好狗狗**。因为在井号之前没有空格，Swift 看到 `"#` 会立即把它作为字符串终止符。在这种情况下，我们需要将分隔符从 `#"` 改为 `##"`，如下所示：

```swift
let str = ##"我的狗叫了一下 "汪"#好狗狗"##
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

没有大量反斜杠就能证明在正则表达式中特别有用。例如编写一个简单的正则表达式来查询关键路径，例如 `\Person.name`，看起来像这样：

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

In this case, we’re going to add an implementation that puts the user’s name and age into a single string, then calls one of the built-in `` methods to add that to our string, like this:在这种情况下，我们将添加一个实现，将用户的名称和年龄放入一个字符串中，然后调用其中一个内置的 `appendInterpolation()` 方法将其添加到我们的字符串中，如下所示：

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

这将打印 **用户信息：我叫 Guybrush Threepwood，33岁**，而使用自定义字符串插值它将打印 **用户信息：User(name: "Guybrush Threepwood", age: 33)**。当然，该功能与仅实现` CustomStringConvertible` 协议没有什么不同，所以让我们继续使用更高级的用法。

你的自定义插值方法可以根据需要使用任意数量的参数，被标记或未被标记。例如，我们可以使用各种样式添加插值来打印数字，如下所示：

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
* 在你的类型 **内部** 需要是一个名为 `StringInterpolation` 并遵循 `StringInterpolationProtocol` 的的嵌套结构体。
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
            print("追加 ’\(twitter)’")
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

Thanks to the  calls that were scattered inside, you’ll see exactly how the string interpolation functionality works: you’ll see “Appending You should follow me on Twitter”, “Appending twostraws”, “Appending , or you can email me at “, “Appending paul@hackingwithswift.com”, and finally “Appending .” – each part triggers a method call, and is added to our string.多亏了分散在里面的 `print()`，你会看到字符串插值功能的准确作用：“追加 ‘你应该在 Twitter 上关注我’”，“追加 ’twostraws’”，“追加 ’，或者你可以发送电子邮件给我 ’“，”追加 ’paul@hackingwithswift.com’“，最后 “追加 ’。’”，每个部分触发一个方法调用，并添加到我们的字符串中。

### Dynamically callable types

[SE-0216](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md) adds a new `@dynamicCallable` attribute to Swift, which brings with it the ability to mark a type as being directly callable. It’s syntactic sugar rather than any sort of compiler magic, effectively transforming this code:

```swift
let result = random(numberOfZeroes: 3)
```

Into this:

```swift
let result = random.dynamicallyCall(withKeywordArguments: ["numberOfZeroes": 3])
```

Previously I wrote about a [feature in Swift 4.2 called @dynamicMemberLookup](/articles/55/how-to-use-dynamic-member-lookup-in-swift). `@dynamicCallable` is the natural extension of `@dynamicMemberLookup`, and serves the same purpose: to make it easier for Swift code to work alongside dynamic languages such as Python and JavaScript.

To add this functionality to your own types, you need to add the `@dynamicCallable` attribute plus one or both of these methods:

```swift
func dynamicallyCall(withArguments args: [Int]) -> Double

func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double
```

The first of those is used when you call the type without parameter labels (e.g. `a(b, c)`), and the second is used when you _do_ provide labels (e.g. `a(b: cat, c: dog)`).

`@dynamicCallable` is really flexible about which data types its methods accept and return, allowing you to benefit from all of Swift’s type safety while still having some wriggle room for advanced usage. So, for the first method (no parameter labels) you can use anything that conforms to `ExpressibleByArrayLiteral` such as arrays, array slices, and sets, and for the second method (with parameter labels) you can use anything that conforms to `ExpressibleByDictionaryLiteral` such as dictionaries and key value pairs.

*   **Note:** If you haven’t used `KeyValuePairs` before, now would be a good time to learn what they are because they are extremely useful with `@dynamicCallable`. Find out more here: [What are KeyValuePairs?](/example-code/language/what-are-keyvaluepairs)

As well as accepting a variety of inputs, you can also provide multiple overloads for a variety of outputs – one might return a string, one an integer, and so on. As long as Swift is able to resolve which one is used, you can mix and match all you want.

Let’s look at an example. First, here’s a `RandomNumberGenerator` struct that generates numbers between 0 and a certain maximum, depending on what input was passed in:

```swift
struct RandomNumberGenerator {
    func generate(numberOfZeroes: Int) -> Double {
        let maximum = pow(10, Double(numberOfZeroes))
        return Double.random(in: 0...maximum)
    }
}
```

To switch that over to `@dynamicCallable` we’d write something like this instead:

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

That method can be called with any number of parameters, or perhaps zero, so we read the first value carefully and use nil coalescing to make sure there’s a sensible default.

We can now create an instance of `RandomNumberGenerator` and call it like a function:

```swift
let random = RandomNumberGenerator()
let result = random(numberOfZeroes: 0)
```

If you had used `dynamicallyCall(withArguments:)` instead – or at the same time, because you can have them both a single type – then you’d write this:

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

There are some important rules to be aware of when using `@dynamicCallable`:

*   You can apply it to structs, enums, classes, and protocols.
*   If you implement `withKeywordArguments:` and don’t implement `withArguments:`, your type can still be called without parameter labels – you’ll just get empty strings for the keys.
*   If your implementations of `withKeywordArguments:` or `withArguments:` are marked as throwing, calling the type will also be throwing.
*   You can’t add `@dynamicCallable` to an extension, only the primary definition of a type.
*   You can still add other methods and properties to your type, and use them as normal.

Perhaps more importantly, there is no support for method resolution, which means we must call the type directly (e.g. `random(numberOfZeroes: 5)`) rather than calling specific methods on the type (e.g. `random.generate(numberOfZeroes: 5)`). There is already some discussion on adding the latter using a method signature such as this:

```swift
func dynamicallyCallMethod(named: String, withKeywordArguments: KeyValuePairs<String, Int>)
```

If that became possible in future Swift versions it might open up some very interesting possibilities for test mocking.

In the meantime, `@dynamicCallable` is not likely to be widely popular, but it _is_ hugely important for a small number of people who want interactivity with Python, JavaScript, and other languages.

### Handling future enum cases

[SE-0192](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md) adds the ability to distinguish between enums that are fixed and enums that might change in the future.

One of Swift’s security features is that it requires all switch statements to be exhaustive – that they must cover all cases. While this works well from a safety perspective, it causes compatibility issues when new cases are added in the future: a system framework might send something different that you hadn’t catered for, or code you rely on might add a new case and cause your compile to break because your switch is no longer exhaustive.

With the `@unknown` attribute we can now distinguish between two subtly different scenarios: “this default case should be run for all other cases because I don’t want to handle them individually,” and “I want to handle all cases individually, but if anything comes up in the future use this rather than causing an error.”

Here’s an example enum:

```swift
enum PasswordError: Error {
    case short
    case obvious
    case simple
}
```

We could write code to handle each of those cases using a `switch` block:

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

That uses two explicit cases for short and obvious passwords, but bundles the third case into a default block.

Now, if in the future we added a new case to the enum called `old`, for passwords that had been used previously, our `default` case would automatically be called even though its message doesn’t really make sense – the password might not be too simple.

Swift can’t warn us about this code because it’s technically correct (the best kind of correct), so this mistake would easily be missed. Fortunately, the new `@unknown` attribute fixes it perfectly – it can be used only on the `default` case, and is designed to be run when new cases come along in the future.

For example:

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

That code will now issue warnings because the `switch` block is no longer exhaustive – Swift wants us to handle each case explicitly. Helpfully this is only a _warning_, which is what makes this attribute so useful: if a framework adds a new case in the future you’ll be warned about it, but it won’t break your source code.

### Flattening nested optionals resulting from try?

[SE-0230](https://github.com/apple/swift-evolution/blob/master/proposals/0230-flatten-optional-try.md) modifies the way `try?` works so that nested optionals are flattened to become regular optionals. This makes it work the same way as optional chaining and conditional typecasts, both of which flatten optionals in earlier Swift versions.

Here’s a practical example that demonstrates the change:

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
        // complicated code here
        return "No messages"
    }
}

let user = User(id: 1)
let messages = try? user?.getMessages()
```

The `User` struct has a failable initializer, because we want to make sure folks create users with a valid ID. The `getMessages()` method would in theory contain some sort of complicated code to get a list of all the messages for the user, so it’s marked as `throws`; I’ve made it return a fixed string so the code compiles.

The key line is the last one: because the user is optional it uses optional chaining, and because `getMessages()` can throw it uses `try?` to convert the throwing method into an optional, so we end up with a nested optional. In Swift 4.2 and earlier this would make `messages` a `String??` – an optional optional string – but in Swift 5.0 and later `try?` won’t wrap values in an optional if they are already optional, so `messages` will just be a `String?`.

This new behavior matches the existing behavior of optional chaining and conditional typecasting. That is, you could use optional chaining a dozen times in a single line of code if you wanted, but you wouldn’t end up with 12 nested optionals. Similarly, if you used optional chaining with `as?`, you would still end up with only one level of optionality, because that’s usually what you want.

### Checking for integer multiples

*   [**Watch the video**](https://www.youtube.com/watch?v=iCRwqxON8Os)

[SE-0225](https://github.com/apple/swift-evolution/blob/master/proposals/0225-binaryinteger-iseven-isodd-ismultiple.md) adds an `isMultiple(of:)` method to integers, allowing us to check whether one number is a multiple of another in a much clearer way than using the division remainder operation, `%`.

For example:

```swift
let rowNumber = 4

if rowNumber.isMultiple(of: 2) {
    print("Even")
} else {
    print("Odd")
}
```

Yes, we could write the same check using `if rowNumber % 2 == 0` but you have to admit that’s less clear – having `isMultiple(of:)` as a method means it can be listed in code completion options in Xcode, which aids discoverability.

### Transforming and unwrapping dictionary values with compactMapValues()

*   [**Watch the video**](https://www.youtube.com/watch?v=Le32Tbkv2v0)

[SE-0218](https://github.com/apple/swift-evolution/blob/master/proposals/0218-introduce-compact-map-values.md) adds a new `compactMapValues()` method to dictionaries, bringing together the `compactMap()` functionality from arrays (“transform my values, unwrap the results, then discard anything that’s nil”) with the `mapValues()` method from dictionaries (“leave my keys intact but transform my values”).

As an example, here’s a dictionary of people in a race, along with the times they took to finish in seconds. One person did not finish, marked as “DNF”:

```swift
let times = [
    "Hudson": "38",
    "Clarke": "42",
    "Robinson": "35",
    "Hartis": "DNF"
]
```

We can use `compactMapValues()` to create a new dictionary with names and times as an integer, with the one DNF person removed:

```swift
let finishers1 = times.compactMapValues { Int($0) }
```

Alternatively, you could just pass the `Int` initializer directly to `compactMapValues()`, like this:

```swift
let finishers2 = times.compactMapValues(Int.init)
```

You can also use `compactMapValues()` to unwrap optionals and discard nil values without performing any sort of transformation, like this:

```swift
let people = [
    "Paul": 38,
    "Sophie": 8,
    "Charlotte": 5,
    "William": nil
]

let knownAges = people.compactMapValues { $0 }
```

### Withdrawn: Counting matching items in a sequence

*   [**Watch the video**](https://www.youtube.com/watch?v=syPKtPb0y-Y)

**This Swift 5.0 feature was withdrawn in beta testing because it was causing performance issues for the type checker. Hopefully it will come back in time for Swift 5.1, perhaps with a new name to avoid problems.**

[SE-0220](https://github.com/apple/swift-evolution/blob/master/proposals/0220-count-where.md) introduces a new `count(where:)` method that performs the equivalent of a `filter()` and count in a single pass. This saves the creation of a new array that gets immediately discarded, and provides a clear and concise solution to a common problem.

This example creates an array of test results, and counts how many are greater or equal to 85:

```swift
let scores = [100, 80, 85]
let passCount = scores.count { $0 >= 85 }
```

And this counts how many names in an array start with “Terry”:

```swift
let pythons = ["Eric Idle", "Graham Chapman", "John Cleese", "Michael Palin", "Terry Gilliam", "Terry Jones"]
let terryCount = pythons.count { $0.hasPrefix("Terry") }
```

This method is available to all types that conform to `Sequence`, so you can use it on sets and dictionaries too.

### Where next?

Swift 5.0 is the latest release of Swift, but previous releases have been packed with great features too. You can read my articles on those below:

*   [What's new in Swift 4.2?](/articles/77/whats-new-in-swift-4-2)
*   [What's new in Swift 4.1?](/articles/50/whats-new-in-swift-4-1)
*   [What's new in Swift 4.0?](/swift4)

But there's more to come – Apple already announced the [Swift 5.1 release process](https://swift.org/blog/5-1-release-process/) on Swift.org, which will include module stability alongside some other improvements. At the time of writing there are very few hard dates attached to 5.1, but it's looking like we'll see it ship in beta around WWDC.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
