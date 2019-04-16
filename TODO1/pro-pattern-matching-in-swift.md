> * 原文地址：[Pro Pattern-Matching in Swift](http://bignerdranch.com/blog/pro-pattern-matching-in-swift/)
> * 原文作者：[Nick Teissler](https://www.bignerdranch.com/about/the-team/nick-teissler)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/pro-pattern-matching-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/pro-pattern-matching-in-swift.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)

# Swift 中强大的模式匹配

Swift 语言一个无可置疑的优点就是 switch 语句。在 switch 语句的背后是 Swift 的模式匹配，它使得代码更易读，且安全。你可以利用 switch 语句的模式匹配的可读性和优势，将其应用于代码中的其他位置。

在 [Swift 语言文档](https://docs.swift.org/swift-book/ReferenceManual/Patterns.html)中指定了八种不同的模式。在模式匹配表达式中，我们很难知道其正确的语法。在实际情况中，你可能需要知道类型信息，来解包取得变量的值，或者只是确认可选值是非空的。使用正确的模式，可以避免笨拙地解包和未使用的变量。

模式匹配中有两个参与者：模式和值。值是紧跟 `switch` 关键字其后的表达式，或者，如果值在 `switch` 语句外测试的，则为 `=` 运算符。模式则是 `case` 后面的表达式。使用 Swift 语言的规则会对模式和值相互评估。截至 2018 年 7 月 15 日，[参考文档](https://docs.swift.org/swift-book/ReferenceManual/Patterns.html)中仍有一些关于如何在文章中以及在何处使用模式的一些错误，不过我们可以通过一些实验来发现它们。[1]

接下来，我们先看看在 `if`、`guard`、和 `while` 语句中应用模式，但在此之前，让我们用 switch 语句的一些非原生用法热下身。

### 仅匹配非空变量

如果试图匹配的值可能为空，我们可以使用**可选值模式**来匹配，如果不是非空的，就解包取值。在处理遗留下来的（以及一些不那么遗留）的 Objective-C 方法和函数时，这一点尤其有用。对于 Swift 4.2，[IUO 的重新实现](https://swift.org/blog/iuo/)使 `!` 与 `?` 同义。而对于 Objective-C 方法，如果没有 [nullable 注解](https://developer.apple.com/swift/blog/?id=25)，你可能不得不处理此行为。

下面的例子是特别微不足道的，因为这个新的行为可能对于小于 Swift 4.2 的版本不太直观。以下是 Objective-C 方法：

```
- (NSString *)aLegacyObjcFunction {
    return @"I haven't been updated with modern obj-c annotations!";
}
```

Swift 方法签名是：`func aLegacyObjcFunction() -> String!`，并且在 Swift 4.1 中，这个方法可以通过编译：

```
func switchExample() -> String {
    switch aLegacyObjcFunction() {
    case "okay":
       return "fine"
    case let output:
        return output  // implicitly unwrap the optional, producing a String
    }
}
```

而在 Swift 4.2 中，你会收到如下报错：“Value of optional type ‘String?’ not unwrapped; did you mean to use ‘!’ or ‘?’?”（可选类型 ‘String?’ 的值还没有解包，你是否想要使用 ‘!’ 或 ‘?’ ?）。`case let output` 是一个简单的变量赋值模式匹配。它会匹配 `aLegacyObjcFunction` 返回的 `String?` 类型而不会去解包取值。其中不直观的部分是，`return aLegacyObjcFunction()` 是可以通过编译的，因为它跳过了变量赋值（模式匹配），类型推断因此返回的类型是一个 `String!` 的值，这由编译器处理。我们应该更优雅地处理它，**特别是**如果存在有问题的 Objective-C 函数，实际上可以返回 `nil`。

```
func switchExample2() -> String {
    switch aLegacyObjcFunction() {
    case "okay":
        return "fine"
    case let output?:
        return output 
    case nil:
        return "Phew, that could have been a segfault."
    }
}
```

这一次，我们故意去处理可选性的问题。请注意，我们不必使用 `if let` 来解开 `aLegacyObcFunction` 的返回值。空模式匹配帮我们处理 `case let output?:`，其中 `output` 是一个 `String` 类型的值。

### 精确捕获自定义错误类型

在捕获自定义错误类型时，模式匹配非常有用，且富有表现力。一种常见的设计模式是，使用 `enum` 来定义自定义错误类型。这在 Swift 中尤其有效，因为可以容易地将关联值增添到枚举用例中，用来提供更多有关错误的详细信息。

这里我们使用两种类型的**类型转换模式**，以及两种**枚举用例模式**来处理可能抛出的任何错误：

```
enum Error: Swift.Error {
    case badError(code: Int)
    case closeShave(explanation: String)
    case fatal
    case unknown
}

enum OtherError: Swift.Error { case base }

func makeURLRequest() throws { ... }

func getUserDetails() {
    do {
        try makeURLRequest()
    }
    // Enumeration Case Pattern: where clause
    catch Error.badError(let code) where code == 50 {
         print("\(code)") }
    // Enumeration Case Pattern: associated value
     catch Error.closeShave(let explanation) {
         print("There's an explanation! \(explanation)")
     }
     // Type Matching Pattern: variable binding
     catch let error as OtherError {
         print("This \(error) is a base error")
     }
     // Type Matching Pattern: only type check
     catch is Error {
         print("We don't want to know much more, it must be fatal or unknown")
     }
     // is Swift.Error. The compiler gives us the variable error for free here
     catch {
         print(error)
     }
}
```

在每个 `catch` 上方，我们匹配并捕获了我们需要的尽可能多的信息。下面从 `switch` 开始，看看我们还能在哪里使用模式匹配。

### 一次性匹配

很多时候你可能想要进行一次性模式匹配。你可能只需在给定单个枚举值的情况下应用更改，而且不关心其他值。此时，优雅可读的 switch 语句突然变成了累赘的样板文件。

我们仅可以在非空的元组值中使用 `if case` 来解开它：

```
if case (_, let value?) = stringAndInt {
    print("The int value of the string is \(value)")
}
```

上面的例子在一条语句中使用了三种模式！顶部**元组模式**，其中包含了一个**可选模式**（与上面**匹配非空变量**的模式没有什么不同），还有一个鬼祟的通配符模式，`_`。 如果我们使用 `switch stringAndInt {...}`，编译器会强制我们显式地处理所有可能的情况，或者执行 `default` 语句。

或者，如果 `guard case` 更能满足你的需求，则无需更改：

```
guard case (_, let value?) = stringAndInt else {
    print("We have no value, exiting early.")
    exit(0)
}
```

你可以使用模式来定义 `while` 循环和 `for-in` 循环的停止条件。这在范围中非常有用。**正则表达式模式**允许我们避免传统的`variable >= 0 && variable <= 10` 构造 [2]：

```
var guess: Int = 0

while case 0...10 = guess  {
    print("Guess a number")
    guess = Int(readLine()!)!
}
print("You guessed a number out of the range!")
```

在所有这些例子中，模式紧跟在 `case` 之后，值则在 `=` 之后。语法与此不同的表达式中有 `is`、`as` 或 `in` 关键字。在这些情况下，如果将这些关键字视为 `=` 的替代品，那么结构是相同的。记住这一点，并且通过编译器的提示，你可以使用所有 8 种模式，而无需参考语言的文档。

到目前为止，我们在前面的例子中还没有看到用 `Range` 来匹配**表达式模式**的一些独特之处：它的模式匹配实现不是内置功能，至少不是内置于编译器中的。**表达式模式**使用了 Swift 标准库 [`~=` 操作符](https://developer.apple.com/documentation/swift/1539154?changes=_3)。`~=` 操作符是一个自由的泛型函数，定义如下：

```
func ~= <T>(a: T, b: T) -> Bool where T : Equatable
```

你可以看到 Swift 标准库中的 `Range` 类型[重写了该运算符](https://developer.apple.com/documentation/swift/range/2428743?changes=_5)，提供了一个自定义行为，用来检查特定值是否在给定的范围内。

### 匹配正则表达式

下面让我们创建一个实现 `~=` 操作符的 `Regex` 类型。它将会是围绕 [`NSRegularExpression`](https://developer.apple.com/documentation/foundation/nsregularexpression?changes=_9) 的一个轻量级的封装器，它使用模式匹配来生成更具可读性的正则表达式代码，在使用神秘的正则表达式时，应始终感兴趣。

```
struct Regex: ExpressibleByStringLiteral, Equatable {

    fileprivate let expression: NSRegularExpression

    init(stringLiteral: String) {
        do {
            self.expression = try NSRegularExpression(pattern: stringLiteral, options: [])
        } catch {
            print("Failed to parse \(stringLiteral) as a regular expression")
            self.expression = try! NSRegularExpression(pattern: ".*", options: [])
        }
    }

    fileprivate func match(_ input: String) -> Bool {
        let result = expression.rangeOfFirstMatch(in: input, options: [],
                                range NSRange(input.startIndex..., in: input))
        return !NSEqualRanges(result, NSMakeRange(NSNotFound, 0))
    }
}
```

这就是我们的 `Regex` 结构体。它有一个 `NSRegularExpression` 属性。它可以初始化为字符串字面常量，其结果是，如果我们无法传递一个有效的正则表达式，那么我们将得到失败的消息和一个匹配所有的正则表达式。接下来，我们实现模式匹配操作符，将其嵌套在扩展中，这样就可以清楚地知道要在何处使用该操作符。

```
extension Regex {
    static func ~=(pattern: Regex, value: String) -> Bool {
        return pattern.match(value)
    }
}
```

我们希望这个结构体是开箱即用的，所以我将定义两个类常量，用来处理一些常见的正则验证需求。匹配邮箱的正则表达式是从 Matt Gallagher 的 [**Cocoa with Love**](http://www.cocoawithlove.com/2009/06/verifying-that-string-is-email-address.html) 文章里面借用的，并检查了 [RFC 2822](https://www.ietf.org/rfc/rfc2822.txt) 中定义的电子邮件地址。

如果你在 Swift 中使用正则表达式，那么你不能就简单地从 Stack Overflow 关于 Regex 帖子中直接复制代码。Swift 字符串定义转义序列，如换行符（`\n`），制表符（`\t`），和 unicode 标量（`\u{1F4A9}`）。这与正则表达式的语法相冲突，因为正则表达式含有大量的反斜杠和所有类型的括号。像 Python，则有方便的原始字符串语法。原始字符串将按逐字逐句地获取每个字符，并且不会解析转义序列，因此可以以“纯净的”形式插入正则表达式。在 Swift 中，字符串中任何单独的反斜杠都表示转义序列，因此对于编译器来说，如果想要接受大多数的正则表达式，就需要转义序列以及一些其他特殊字符。这里有一个小[尝试](https://forums.swift.org/t/se-0200-raw-mode-string-literals/11048/178)，尝试在 Swift 中使用原始字符串，但最后失败了。随着 Swift 继续成为一种多平台，多用途的语言，人们可能会对这个功能重新产生兴趣。在此之前，现有复杂的匹配邮件的正则表达式，变成了这个 ASCII 的艺术怪物：

```
static let email: Regex = """
^(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\
\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@\
(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0\
-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?\
:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7\
f])+)\\])$
"""
```

我们可以使用一个更简单的表达式来匹配电话号码，借用 [Stack Overflow](https://stackoverflow.com/questions/16699007/regular-expression-to-match-standard-10-digit-phone-number) 以及如前面所述的双转义：

```
static let phone: Regex = "^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}$"
```

现在，我们可以使用方便、易读的模式语法来识别电话号码或电子邮件：

    let input = Bool.random() ? "nerd@bignerdranch.com" : "(770) 817-6373"
    switch input {
        case Regex.email:
            print("Send \(input) and email!")
        case Regex.phone:
            print("Give Big Nerd Ranch a call at \(input)")
        default:
            print("An unknown format.")
    }
    

你可能想知道为什么看不到上面的 `~=` 操作符。因为它是 `Expression Pattern` 的一个实现细节，且是隐式使用的。

### 牢记这些基础知识！

有了所有这些奇特的模式，我们不应该忘记使用经典 switch 语句的方法。当模式匹配 `~=` 操作符未定义时，Swift 在 switch 语句中会使用 `==` 操作符。重申一下，我们现在不再处于模式匹配的范畴。

以下是一个例子。这里的 switch 语句用来做一个给委托回调的[分离器](https://www.electronicshub.org/demultiplexerdemux/)。它对 `NSObject` 子类的 `textField` 变量执行了 switch 语句。因此，等式被定义为了标识比较，它会检查两个变量的指针值是否相等。举个例子，以一个对象作为三个 `UITextField` 对象的委托。每个文本字段都需要以不同的方式验证其文本。当用户编辑文本时，委托为每个文本字段接收相同的回调，

```
func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    switch textField {
        case emailTextField:
            return validateEmail()
        case phoneTextField:
            return validatePhone()
        case passwordTextField:
            return validatePassword()
        default:
            preconditionFailure("Unaccounted for Text Field")
    }
}
```

并且可以不同地验证每个文本字段。

### 结论

我们查阅了 Swift 中可用的一些模式，并检查了模式匹配语法的结构。有了这些知识，所有 8 种模式都可供使用！模式具有许多优点，它是每个 Swift 开发者的工具箱中不可或缺的一部分。这篇文章还有未涵盖到的内容，例如[编译器检查穷举逻辑的细节](https://nshipster.com/never/#eliminating-impossible-states-in-generic-types)以及结合 `where` 语句的一些模式。

感谢 Erica Sadun 在她的博客文章 [**Afternoon Whoa**](https://ericasadun.com/2016/03/15/afternoon-whoa-swifts-guard-case/) 中向我介绍了 `guard case` 语法，它是这篇文章的灵感来源。

这篇文章中的所有例子都可以在 [gist](https://gist.github.com/nteissler/a9d2b00beddcc309445ebebf1a373b49) 中找到。代码可以在 Playground 运行，也可以根据你的需要进行挑选。

[1] 该指南要求使用具有关联值的枚举，“对应的枚举用例模式必须指定一个元组模式，其中包含每个关联值的一个元素。”如果您不需要关联的值，只需包含没有任何关联值的enum情况就可以编译和匹配。

另一个小的更正是，自定义表达式操作符 `~=` 可能 “仅出现在 switch 语句大小写标签中”。在上述例子中，我们也在一个 `if` 语句中使用到它。[Swift 语法](https://docs.swift.org/swift-book/ReferenceManual/Statements.html#//appleref/swift/grammar/condition-list)正确地说明了上述两种用法，这个小错误只在本文中。

[2] `readLine` 方法不适用于 Playground。如果要运行此示例，请从 macOS 命令行应用中尝试。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
