> * 原文地址：[How to use Result in Swift 5](https://www.hackingwithswift.com/articles/161/how-to-use-result-in-swift)
> * 原文作者：[Paul Hudson](https://twitter.com/twostraws)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-result-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-result-in-swift.md)
> * 译者：[Bruce-pac](https://github.com/Bruce-pac)
> * 校对者：[iWeslie](https://github.com/iWeslie)

# 如何在 Swift 5 中使用 Result

![](https://www.hackingwithswift.com/uploads/swift-evolution-5.jpg)

[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) 在标准库中引入了一个 `Result` 类型，使我们能够更简单、更清晰地处理复杂代码中的错误，比如异步 API。这是人们在 Swift 早期就开始要求的东西，所以很高兴看到它终于到来!

Swift 的  `Result` 类型被实现为一个枚举，它有两种情况：`success` 和 `failure`。两者都是使用泛型实现的，因此它们可以有您选择的关联值，但 `failure` 必须符合 Swift 的 `Error` 类型。

为了演示 `Result`，我们可以编写一个网络请求函数来计算有多少未读消息在等待用户。在这个例子代码中，我们将只有一个可能的错误，那就是请求的 URL 字符串不是一个有效的 URL：

```swift
enum NetworkError: Error {
    case badURL
}
```

这个函数将接受一个 URL 字符串作为它的第一个参数，并接受一个 completion 闭包作为它的第二个参数。该 completion 闭包本身接受一个 `Result`，其中 `success` 将存储一个整数，而 `failure` 案例将是某种 `NetworkError`。我们实际上并不打算在这里连接到服务器，但是使用一个 completion 闭包至少可以让我们模拟异步代码。

代码如下：

```swift
func fetchUnreadCount1(from urlString: String, completionHandler: @escaping (Result<Int, NetworkError>) -> Void)  {
    guard let url = URL(string: urlString) else {
        completionHandler(.failure(.badURL))
        return
    }
    
    // complicated networking code here
    print("Fetching \(url.absoluteString)...")
    completionHandler(.success(5))
}
```

要使用该代码，我们需要检查我们的 `Result` 中的值，看看我们的调用成功还是失败，如下所示：

```swift
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    switch result {
    case .success(let count):
        print("\(count) unread messages.")
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

即使在这个简单的场景中，`Result` 也给了我们两个好处。首先，我们返回的错误现在是强类型的：它一定是某种 `NetworkError`。Swift 的常规抛出函数是不检查类型的，因此可以抛出任何类型的错误。因此，如果您添加了一个 `switch` 语句来查看他们的情况，您需要添加 `default` 情况，即使这种情况是不可能的。使用 `Result` 的强类型错误，我们可以通过列出错误枚举的所有情况来创建详尽的 `switch` 语句。

其次，现在很清楚，我们要么返回成功的数据要么返回一个错误，它们两个中有且只有一个一定会返回。如果我们使用传统的 Objective-C 方法重写 `fetchUnreadCount1()` 来完成 completion 闭包，你可以看到第二个好处的重要性：

```swift
func fetchUnreadCount2(from urlString: String, completionHandler: @escaping (Int?, NetworkError?) -> Void) {
    guard let url = URL(string: urlString) else {
        completionHandler(nil, .badURL)
        return
    }
    
    print("Fetching \(url.absoluteString)...")
    completionHandler(5, nil)
}
```

这里，completion 闭包将同时接收一个整数和一个错误，尽管它们中的任何一个都可能是 nil。Objective-C 之所以使用这种方法，是因为它没有能力用关联的值来表示枚举，所以别无选择，只能将两者都发送回去，让用户自己去弄清楚。

然而，这种方法意味着我们已经从两种可能的状态变成了四种:一个没有错误的整数，一个没有整数的错误，一个错误和一个整数，没有整数和没有错误。最后两种状态应该是不可能的，但在 Swift 引入 `Result` 之前，没有简单的方法来表达这一点。

这种情况经常发生。`URLSession` 中的 `dataTask()` 方法使用相同的解决方案，例如：它用 `(Data?, URLResponse?, Error?)`。这可能会给我们提供一些数据、一个响应和一个错误，或者三者的任何组合 — Swift Evolution 的提议称这种情况“尴尬不堪”。

可以将 `Result` 看作一个超级强大的 `Optional`，`Optional` 封装了一个成功的值，但也可以封装第二个表示没有值的情况。然而，对于 `Result`，第二种情况还可以传递了额外的数据，因为它告诉我们哪里出了问题，而不仅仅是 `nil`。

## 为何不使用 `throws`？

当你第一次看到 `Result` 时，你常常会想知道它为什么有用，尤其是自从 Swift 2.0 以来，它已经有了一个非常好的 `throws` 关键字来处理错误。

你可以通过让 completion 闭包接受另一个函数来实现几乎相同的功能，该函数会抛出或返回有问题的数据，如下所示：

```swift
func fetchUnreadCount3(from urlString: String, completionHandler: @escaping  (() throws -> Int) -> Void) {
    guard let url = URL(string: urlString) else {
        completionHandler { throw NetworkError.badURL }
        return
    }
    
    print("Fetching \(url.absoluteString)...")
    completionHandler { return 5 }
}
```

然后，您可以使用一个接受要运行的函数的 completion 闭包调用 `fetchUnreadCount3()`，如下所示：

```swift
fetchUnreadCount3(from: "https://www.hackingwithswift.com") { resultFunction in
    do {
        let count = try resultFunction()
        print("\(count) unread messages.")
    } catch {
        print(error.localizedDescription)
    }
}
```

这也能解决问题，但读起来要复杂得多。更糟的是，我们实际上并不知道调用 `result()` 函数是做什么的，所以如果它不仅仅返回一个值或抛出一个值，那么就有可能导致它自己的问题。

即使使用更简单的代码，使用 `throws` 也常常迫使我们立即处理错误，而不是将错误存储起来供以后处理。有了 `Result`，这个问题就消失了，错误被保存在一个值中，我们可以在准备好时读取这个值。

## 处理 `Result`

我们已经了解了 `switch` 语句如何让我们以一种干净的方式评估 `Result` 的 `success` 和 `failure` 案例，但是在开始使用它之前，还有五件事您应该知道。

首先，`Result` 有一个 `get()` 方法，如果存在则返回成功值，否则抛出错误。这允许您将 `Result` 转换为一个常规抛出调用，如下所示：

```swift
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    if let count = try? result.get() {
        print("\(count) unread messages.")
    }
}

```

其次，如果您愿意，可以使用常规的 `if` 语句来读取枚举的情况，尽管有些人觉得语法有点奇怪。例如：

```swift
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    if case .success(let count) = result {
        print("\(count) unread messages.")
    }
}
```

第三，`Result` 有一个接受可能会抛出错误的闭包的初始化器:如果闭包成功返回一个值，该值用于 `success` 情况，否则抛出的错误将被放入 `failure` 情况。

例如：

```swift
let result = Result { try String(contentsOfFile: someFile) }
```

第四，您还可以使用一般的 `Error` 协议，而不是使用您创建的特定错误枚举。事实上，Swift Evolution 的提议说：“预计 `Result` 的大多数用法都将使用 `Swift.Error` 作为 `Error` 类型参数。”

因此，可以使用 `Result<Int, Error>` 而不是 `Result<Int, NetworkError>`。虽然这意味着您失去了类型抛出的安全性，但是您获得了抛出各种不同错误枚举的能力 —— 您更喜欢哪种错误枚举实际上取决于您的编码风格。

最后，如果你已经在你的项目中有了一个自定义的 `Result`类型（任何你自己定义的或者从 GitHub 上的自定义 `Result` 类型导入的），那么它们将自动代替 Swift 自己的 `Result` 类型。这将允许您在不破坏代码的情况下升级到 Swift 5.0，但理想情况下，随着时间的推移，您将迁移到 Swift 自己的 `Result` 类型，以避免与其他项目不兼容。

## 转换 `Result`

`Result` 有另外四个可能被证明有用的方法:`map()`、`flatMap()`、` mapError()` 和 `flatMapError()`。这几个方法都能够以某种方式转换成功或错误，前两种方法和 `Optional` 上的同名方法行为类似。

`map()` 方法查看 `Result` 内部，并使用指定的闭包将成功值转换为另一种类型的值。但是，如果它发现失败，它只直接使用它，而忽略您的转换。

为了演示这一点，我们将编写一些代码，生成 0 到最大值之间的随机数，然后计算该数的因数。如果用户请求一个小于零的随机数，或者这个随机数恰好是素数，即它没有其他因数，除了它自己和 1，我们会认为这些都是失败情况。

我们可以从编写代码开始，对两种可能的失败案例进行建模:用户试图生成一个小于 0 的随机数和生成的随机数是素数：

```swift
enum FactorError: Error {
    case belowMinimum
    case isPrime
}
```

接下来，我们将编写一个函数，它接受一个最大值，并返回一个随机数或一个错误:

```swift
func generateRandomNumber(maximum: Int) -> Result<Int, FactorError> {
    if maximum < 0 {
       // creating a range below 0 will crash, so refuse
            return .failure(.belowMinimum)
        } else {
            let number = Int.random(in: 0...maximum)
            return .success(number)
        }
    }
```

当它被调用时，我们返回的 `Result` 要么是一个整数，要么是一个错误，所以我们可以使用 `map()` 来转换它：

```swift
let result1 = generateRandomNumber(maximum: 11)
let stringNumber = result1.map { "The random number is: \($0)." }
```

当我们传入一个有效的最大值时，`result1` 将是一个成功的随机数。因此，使用 `map()` 将获取这个随机数，并将其与字符串插值一起使用，然后返回另一个 `Result` 类型，这次的类型是 `Result< string, FactorError>`。

但是，如果我们使用了 `generateRandomNumber(maximum: -11)`，那么 `result1` 将被设置为 `FactorError.belowMinimum` 的失败情况。因此，使用 `map()` 仍然会返回 `Result<String, FactorError>`，但是它会有相同的失败情况和相同的 `FactorError.belowMinimum` 错误。

既然您已经了解了 `map()` 如何让我们将成功类型转换为另一种类型，那么让我们继续，我们有一个随机数，因此下一步是计算它的因数。为此，我们将编写另一个函数，它接受一个数字并计算其因数。如果它发现数字是素数，它将返回一个带有 `isPrime` 错误的失败 `Result`，否则它将返回因数的数量。

这是代码：

```swift
func calculateFactors(for number: Int) -> Result<Int, FactorError> {
    let factors = (1...number).filter { number % $0 == 0 }
    
    if factors.count == 2 {
        return .failure(.isPrime)
    } else {
        return .success(factors.count)
    }
}

```

如果我们想使用 `map()` 来转换 `generateRandomNumber()` 生成随机数后再 `calculateFactors()` 的输出，它应该是这样的：

```swift
let result2 = generateRandomNumber(maximum: 10)
let mapResult = result2.map { calculateFactors(for: $0) }

```

然而，这使得 `mapResult` 成为一个相当难看的类型:`Result<Result<Int, FactorError>, FactorError>`。它是另一个 `Result` 内部的一个 `Result`。

就像可选值一样，现在是 `flatMap()` 方法起作用的时候了。如果你的转换闭包返回一个 `Result`，`flatMap()` 将直接返回新的 `Result`，而不是包装在另一个 `Result` 内：

```swift
let flatMapResult = result2.flatMap { calculateFactors(for: $0) }
```

因此，其中 `mapResult` 是一个 `Result<Result<Int, FactorError>, FactorError>`，`flatMapResult` 被展平成 `Result<Int, FactorError>` – 第一个原始成功值(一个随机数)被转换成一个新的成功值(因数的数量)。就像 `map()` 一样，如果其中一个 `Result` 失败，那么 `flatMapResult` 也将失败。

至于 `mapError()` 和 `flatMapError()`，除了转换 **error** 值而不是 **success** 值外，它们执行类似的操作。

## 接下来？

我写过一些关于 Swift 5 其他一些很棒的新功能的文章，你可能想看看：

- [How to use custom string interpolation in Swift 5](/articles/163/how-to-use-custom-string-interpolation-in-swift)
- [How to use @dynamicCallable in Swift](/articles/134/how-to-use-dynamiccallable-in-swift)
- [Swift 5.0 is changing optional try](/articles/147/swift-5-is-changing-optional-try)
- [What’s new in Swift 5.0](/articles/126/whats-new-in-swift-5-0)

您可能还想尝试我的 [What’s new in Swift 5.0 playground](https://github.com/twostraws/whats-new-in-swift-5-0)，它允许您交互式地尝试 Swift 5 的新功能。

如果您想了解更多 Swift 中的 result 类型，您可能想查看 GitHub 上的 [antitypical/Result](https://github.com/antitypical/Result) 的源代码，这是最流行的 result 实现之一。

我还强烈推荐阅读 Matt Gallagher 的 [excellent discussion of `Result`](https://www.cocoawithlove.com/blog/2016/08/21/result-types-part-one.html)，这本书已经有几年的历史了，但仍然很有用，也很有趣。

你已经在忙着为 Swift 4.2 和 iOS 12 更新你的应用程序了，为什么不让 Instabug 帮你发现和修复 bug 呢?**只需添加两行代码** 到您的项目中，就可以收到全面的报告，其中包含您发布世界级应用程序所需的所有反馈 — [单击此处了解更多信息](https://try.instabug.com/ios/?utm_source=hackingwithswift&utm_medium=native_ads&utm_campaign=hackingwithswiftv3)!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
