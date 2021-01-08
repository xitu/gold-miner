> * 原文地址：[Using errors as control flow in Swift](https://www.swiftbysundell.com/posts/using-errors-as-control-flow-in-swift)
> * 原文作者：[John Sundell](https://github.com/johnsundell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-errors-as-control-flow-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-errors-as-control-flow-in-swift.md)
> * 译者：[swants](https://github.com/swants)
> * 校对者：[Bruce-pac](https://github.com/Bruce-pac), [iWeslie](https://github.com/iWeslie)

# 在 Swift 中使用 errors 作为控制流

我们在 App 和系统中对控制流的管理方式，会对我们代码的执行速度、Debug 的难易程度等方方面面产生巨大影响。我们代码中的控制流本质上是我们各种方法函数和语句的执行顺序，以及代码最终将会进入到哪个流程分支。

Swift 为我们提供了很多定义控制流的工具 —— 如 `if`, `else` 和 `while` 语句，还有类似 Optional 这样的结构。这周让我们将目光放在如何使用 Swift 内置的错误抛出和处理 Model，以使我们能够更轻松地管理控制流。

## 撇开 Optional

Optional 作为一种重要的语言特性，也是数据建模时处理字段缺失的一种良好方式。在涉及到控制流的特定函数内却也成了大量重复样板代码的源头。

下面我写了个函数来加载 App Bundle 内的图片，然后调整图片尺寸并渲染出来。由于上面每一步操作都会返回一张可选值类型的图片，因此我们需要使用几次 `guard` 语句来指出函数可能会在哪些地方退出：

```Swift
func loadImage(named name: String,
               tintedWith color: UIColor,
               resizedTo size: CGSize) -> UIImage? {
    guard let baseImage = UIImage(named: name) else {
        return nil
    }
    
    guard let tintedImage = tint(baseImage, with: color) else {
        return nil
    }
    
    return resize(tintedImage, to: size)
}
```

上面代码面对的问题是我们实际上在两处地方用了 `nil` 来处理运行时的错误，这两处地方都需要我们为每步操作结果进行解包，并且还使引发 error 的语句变得无从查找。

让我们看看如何通过 error 重构控制流来解决这两个问题，而不是使用抛出函数。我们将从定义一个枚举开始，它包含图像处理代码中可能发生的每个错误的情况——看起来像这样：

```Swift
enum ImageError: Error {
    case missing
    case failedToCreateContext
    case failedToRenderImage
    ...
}
```

例如，下面是我们如何快速更新 loadImage(named:) 来返回一个非可选的 UIImage 或抛出 ImageError.missing：

```Swift
private func loadImage(named name: String) throws -> UIImage {
    guard let image = UIImage(named: name) else {
        throw ImageError.missing
    }
    
    return image
}
```

如果我们用同样的手法修改其它图像处理函数，我们就能在高层次的函数上也做出相同改变 —— 删除所有可选值并保证它要么返回一个正确的图像，要么抛出我们一系列的操作中产生的任何 error：

```Swift
func loadImage(named name: String,
               tintedWith color: UIColor,
               resizedTo size: CGSize) throws -> UIImage {
    var image = try loadImage(named: name)
    image = try tint(image, with: color)
    return try resize(image, to: size)
}
```

上面代码的改动不仅让我们的函数体变得更加简单，而且 Debug 的时候也变得更加轻松。因为当发生问题时将会返回我们明确定义的错误，而不是去找出到底是哪个操作返回了 nil。

然而我们可能对 **一直** 处理各种错误没有丝毫兴趣，所以我们就不需要在我们代码中到处使用 `do, try, catch` 语句结构，（讽刺的是，这些语句也同样会产生大量我们最初要避免的模板代码）。

开心的是当需要使用 Optional 的时候我们都可以回过头来用它 —— 甚至包括在使用抛出函数的时候。我们唯一需要做的就是在需要调用抛出函数的地方使用 `try?` 关键字，这样我们又会得到一开始那样可选值类型的结果：

```Swift
let optionalImage = try? loadImage(
    named: "Decoration",
    tintedWith: .brandColor,
    resizedTo: decorationSize
)
```

使用 `try?` 的好处之一就是它把世界上最棒的两件事融合到了一起。我们既可以在调用函数后得到一个可选值类型结果 —— 与此同时又让我们能够使用抛出 error 的优点来管理我们的控制流 👍。

## 验证输入

接下来，让我们看下在验证输入时使用 error 可以多大程度上改善我们的控制流。即使 Swift 已经是一个非常有优势并且强类型的环境，它也不能一直保证我们的函数收到验证过的输入值 —— 有些时候使用运行时检查是我们唯一能做的。

让我们看下另一个例子，在这个例子中，我们需要在注册新用户时验证用户的选择，在之前的时候，我们的代码常常使用 `guard` 语句来验证每条规则，当错误发生时输出一条错误信息 —— 就像这样：

```Swift
func signUpIfPossible(with credentials: Credentials) {
    guard credentials.username.count >= 3 else {
        errorLabel.text = "Username must contain min 3 characters"
        return
    }
    
    guard credentials.password.count >= 7 else {
        errorLabel.text = "Password must contain min 7 characters"
        return
    }
    
    // Additional validation
    ...
        
        service.signUp(with: credentials) { result in
            ...
    }
}
```

即使我们只验证上面的两条数据，我们的验证逻辑也比我们我们预期中的增长快。当这种逻辑和我们的 UI 代码混合在一起时（特别是同处在一个 View Controller 中）也让整个测试变得更加困难 —— 所以让我们看看是否可以把一些代码解耦以使控制流更加完善。

理想情况下，我们希望验证代码只被我们自己持有，这样就能使开发和测试相互隔离，并且能够使我们的代码变得更易于重用。为了达到这个目的，我们为所有的验证逻辑创建一个公用类型来包含验证代码的闭包。我们可以称这个类型为验证器，并将它定义为一个简单的结构体并让它持有针对给出 `Value` 类型进行验证的闭包：

```Swift
struct Validator<Value> {
    let closure: (Value) throws -> Void
}
```

使用上面的代码，我们就把验证函数重构为当一个输入值没有通过验证时抛出一个 error。然而，为每一个验证过程定义一个新的 `Error` 类型可能会再次引发产生不必要模板代码的问题（特别是当我们仅仅只是想为用户展示出来一个错误而已时）—— 所以让我们引入一个写验证逻辑时只需要简单传递一个 `Bool` 条件和一条当发生错误时展示给用户信息的函数：

```Swift
struct ValidationError: LocalizedError {
    let message: String
    var errorDescription: String? { return message }
}

func validate(
    _ condition: @autoclosure () -> Bool,
    errorMessage messageExpression: @autoclosure () -> String
    ) throws {
    guard condition() else {
        let message = messageExpression()
        throw ValidationError(message: message)
    }
}
```

**上面我们又使用了 @autoclosure，它是让我们在闭包内自动解包的推断语句。查看更多信息，点击 ["Using @autoclosure when designing Swift APIs"](https://www.swiftbysundell.com/posts/using-autoclosure-when-designing-swift-apis)。**

有了上述条件，我们现在可以实现共用验证器的全部验证逻辑 —— 在 `Validator` 类型内构造计算静态属性。例如，下面是我们如何实现密码验证的:

```Swift
extension Validator where Value == String {
    static var password: Validator {
        return Validator { string in
            try validate(
                string.count >= 7,
                errorMessage: "Password must contain min 7 characters"
            )
            
            try validate(
                string.lowercased() != string,
                errorMessage: "Password must contain an uppercased character"
            )
            
            try validate(
                string.uppercased() != string,
                errorMessage: "Password must contain a lowercased character"
            )
        }
    }
}
```

最后，让我们创建另一个 `validate` 重载函数，它的作用有点像 **语法糖**，让我们在有需要验证的值和要使用的验证器的时候去调用它:

```Swift
func validate<T>(_ value: T,
                 using validator: Validator<T>) throws {
    try validator.closure(value)
}
```

所有代码都写好了，让我们修改需要调用的地方以使用新的验证系统。上述方法的优雅之处在于，虽然需要一些额外的类型和一些基础准备，但它使我们的验证输入值的代码变得非常漂亮并且整洁：

```Swift
func signUpIfPossible(with credentials: Credentials) throws {
    try validate(credentials.username, using: .username)
    try validate(credentials.password, using: .password)
    
    service.signUp(with: credentials) { result in
        ...
    }
}
```

也许还能做的更好点，我们可以通过使用 `do, try, catch` 结构调用上面的 `signUpIfPossible` 函数将所有验证错误的逻辑放在一个单独的地方 —— 这时我们就只需要向用户显示抛出错误的描述信息：

```Swift
do {
    try signUpIfPossible(with: credentials)
} catch {
    errorLabel.text = error.localizedDescription
}
```

**值得注意的是，虽然上面的代码示例没有使用任何本地化，但我们总是希望在真实应用程序中向用户显示所有错误消息时使用本地化字符串。**

## 抛出异常测试

围绕可能遇到的错误构建代码的另一个好处是，它通常使测试更加容易。由于一个抛出函数本质上有两个不同的可能输出 —— 一个值和一个错误。在许多情况下，覆盖这两个场景去添加测试是非常直接的。

例如，下面是我们如何能够非常简单地为我们的密码验证添加测试 —— 通过简单地断言错误用例确实抛出了一个错误，而成功案例没有抛出错误，这就涵盖了我们的两个需求：

```Swift
class PasswordValidatorTests: XCTestCase {
    func testLengthRequirement() throws {
        XCTAssertThrowsError(try validate("aBc", using: .password))
        try validate("aBcDeFg", using: .password)
    }
    
    func testUppercasedCharacterRequirement() throws {
        XCTAssertThrowsError(try validate("abcdefg", using: .password))
        try validate("Abcdefg", using: .password)
    }
}
```

如上面代码所示，由于 `XCTest` 支持抛出测试功能 —— 并且每个未被处理的错误都会作为一个失败 —— 我们唯一需要做的就是使用 `try` 来调用我们的 `validate` 函数验证用例是否成功，如果没有抛出错误我们就测试成功了 👍。

## 总结

在 Swift 代码中其实有很多种方式来管理控制流 —— 无论操作成功还是失败，使用 error 结合抛出函数是一个非常好的选择。虽然这样做的时候会需要一些额外的操作（如引入 error 类型并使用 `try` 或 `try?` 来调用函数）—— 但是让我们的代码简洁起来真的会带来极大的提升。

函数将可选类型作为返回结果当然也是值得提倡的 —— 特别是在没有任何合理的错误可以抛出的情况下，但是如果我们需要在几处地方同时为可选值使用 `guard` 语句进行判断，那么使用 error 替代可能给我们带来更清晰的控制流。

你是什么想法呢？ 如果你现在正在使用 error 结合抛出函数来管理你代码中的控制流 —— 或者你正在尝试其他方案？请在 [Twitter @johnsundell](https://twitter.com/johnsundell) 告诉我，期待你的疑问、评论和反馈。

感谢阅读！🚀

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
