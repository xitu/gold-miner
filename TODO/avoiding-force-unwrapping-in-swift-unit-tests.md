> * 原文地址：[Avoiding force unwrapping in Swift unit tests](https://www.swiftbysundell.com/posts/avoiding-force-unwrapping-in-swift-unit-tests)
> * 原文作者：[John](https://twitter.com/johnsundell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/avoiding-force-unwrapping-in-swift-unit-tests.md](https://github.com/xitu/gold-miner/blob/master/TODO/avoiding-force-unwrapping-in-swift-unit-tests.md)
> * 译者：[RickeyBoy](https://juejin.im/user/59c0ede76fb9a00a3d134e0b/posts)
> * 校对者：[YinTokey](https://github.com/YinTokey)

# 避免 Swift 单元测试中的强制解析

强制解析（使用 `!`）是 Swift 语言中不可或缺的一个重要特点（特别是和 Objective-C 的接口混合使用时）。它回避了一些其他问题，使得 Swift 语言变得更加优秀。比如 **[处理 Swift 中非可选的可选值类型](https://www.swiftbysundell.com/posts/handling-non-optional-optionals-in-swift)** 这篇文章中，在项目逻辑需要时使用强制解析去处理可选类型，将导致一些离奇的情况和崩溃。

所以尽可能地避免使用强制解析，将有助于搭建更加稳定的应用，并且在发生错误时提供更好的报错信息。那么如果是编写测试时，情况会怎么样呢？安全地处理可选类型和未知类型需要大量的代码，那么问题就在于我们是否愿意为编写测试做所有的额外工作。这就是我们这周将要探讨的问题，让我们开始深入研究吧！

## 测试代码 vs 产品代码

当编写测试代码时，我们经常明确区分**测试代码**和**产品代码**。尽管保持这两部分代码的分离十分重要（我们不希望意外地让我们的模拟测试对象成为 App Store 上架的部分😅），但就**代码质量**来说，没有必要进行明显区分。

如果你思考一下的话，我们想要对移交给使用者的代码进行高标准的要求，原因是什么呢？

* 我们想要我们的 app 为使用者稳定、流畅地运行。
* 我们想要我们的 app 在未来易于维护和修改。
* 我们想要更容易让新人融入我们的团队。

现在如果反过来考虑我们的测试，我们想要避免哪些事情呢？

* 测试不稳定、脆弱、难于调试。
* 当我们的 app 增加了新功能时，我们的测试代码需要花费大量时间来维护和升级。
* 测试代码对于加入团队的新人来说难于理解。

你可能已经理解我所讲的内容了 😉。

之前很长的时间，我曾认为测试代码只是一些我快速堆砌的代码，因为有人告诉我必须要编写测试。我不那么在乎它们的质量，因为我将它视为一件琐事，并不将它放在首位。然而，一旦我因为编写测试而发现验证自己的代码有多么快，以及对自己有多么自信 —— 我对测试的态度就开始了转变。

所现在我相信对于测试代码，和将要移交的产品代码进行同等的高标准要求是非常重要的。因为我们配套的测试是需要我们长期使用、拓展和掌握的，我们理应让这些工作更容易完成。

## 强制解析的问题

那么这一切与 Swift 中的强制解析有什么关系呢？🤔

有时必须要强制解析，很容易编写一个 “go-to solution” 的测试。让我们来看一个例子，测试 `UserService` 实现的登陆机制是否正常工作：

```
class UserServiceTests: XCTestCase {
    func testLoggingIn() {
        // 为了登陆终端
        // 构建一个永远返回成功的模拟对象
        let networkManager = NetworkManagerMock()
        networkManager.mockResponse(forEndpoint: .login, with: [
            "name": "John",
            "age": 30
        ])

        // 构建 service 对象以及登录
        let service = UserService(networkManager: networkManager)
        service.login(withUsername: "john", password: "password")

        // 现在我们想要基于已登陆的用户进行断言，
        // 这是可选类型，所以我们对它进行强制解析
        let user = service.loggedInUser!
        XCTAssertEqual(user.name, "John")
        XCTAssertEqual(user.age, 30)
    }
}
```

如你所见，在进行断言之前，我们强制解析了 service 对象的 `loggedInUser` 属性。像上面这样的做法并不是绝对意义上的错，但是如果这个测试因为一些原因开始失败，就可能会导致一些问题。

假设某人（记住，“某人”可能就是“未来的你自己”😉）改变了网络部分的代码，导致上述测试开始崩溃。如果这样的事情发生了，错误信息可能只会像下面这样：

```
Fatal error: Unexpectedly found nil while unwrapping an Optional value
```

尽管用 Xcode 本地运行时这不是个大问题（因为错误会被关联地显示 —— 至少在大多数时候 🙃），但当连续地整体运行整个项目时，它可能问题重重。上述的错误信息可能出现在巨大的“文字墙”中，导致难以看出错误的来源。更严重的是，它会**阻止后续的测试被执行**（因为测试进程会崩溃），这将导致修复工作进展缓慢并且令人烦躁。

## Guard 和 XCTFail

一个潜在的解决上述问题的方式是简单地使用 `guard` 声明，优雅地解析问题中的可选类型，如果解析失败再调用 `XCTFail` 即可，就像下面这样：

```
guard let user = service.loggedInUser else {
    XCTFail("Expected a user to be logged in at this point")
    return
}
```

尽管上述做法在某些情况下是正确的做法，但事实上我推荐避免使用它 —— 因为它向你的测试中增加了控制流。为了稳定性和可预测性，你通常希望测试只是简单的遵循 **given，when，then** 结构，并且增加控制流会使得测试代码难于理解。如果你真的非常倒霉，控制流可能成为误报的起源（对此之后的文章会有更多的相关内容）。

## 保持可选类型

另一个方法是让可选类型一直保持可选。这在某些使用情况下完全可用，包括我们 `UserManager` 的例子。因为我们对已经登录的 user 的 `name` 和 `age` 属性使用了断言，如果任意一个属性为 `nil` ，我们会自动得到错误提示。同时如果我们对 user 使用额外的 `XCTAssertNotNil` 检查，我们就能得到一个非常完整的诊断信息。

```
let user = service.loggedInUser
XCTAssertNotNil(user, "Expected a user to be logged in at this point")
XCTAssertEqual(user?.name, "John")
XCTAssertEqual(user?.age, 30)
```

现在如果我们的测试开始出错了，我们就能得到如下信息：

```
XCTAssertNotNil failed - Expected a user to be logged in at this point
XCTAssertEqual failed: ("nil") is not equal to ("Optional("John")")
XCTAssertEqual failed: ("nil") is not equal to ("Optional(30)")
```

这让我们能够更加容易地知道发生错误的地方，以及该从哪里入手去调试、解决这个错误 🎉。

## 使用 throw 的测试

第三个选择在某些情况下是非常有用的，就是将返回可选类型的 API 替换为 throwing API。Swift 中的 throwing API 的优雅之处在于，需要时它能够非常容易地被当成可选类型使用。所以很多时候选择采用 throwing 方法，不需要牺牲任何的可用性。比如说，假设我们有一个 `EndpointURLFactory` 类，被用来在我们的 app 中生成特定终端的 URL，这显然会返回可选类型：

```
class EndpointURLFactory {
    func makeURL(for endpoint: Endpoint) -> URL? {
        ...
    }
}
```

现在我们将其转换为采用 throwing API，像这样：

```
class EndpointURLFactory {
    func makeURL(for endpoint: Endpoint) throws -> URL {
        ...
    }
}
```

当我们仍然想得到一个可选类型的 URL 时，我们只需要使用 `try?` 命令去调用它：

```
let loginEndpoint = try? urlFactory.makeURL(for: .login)
```

就测试而言，上述这种做法的最大好处在于可以在测试中轻松地使用 `try`，并且使用 XCTest runner 完全可以毫无代价地处理无效值。这是鲜为人知的，但事实上 Swift 测试可以是 throwing 函数，看看这个：

```
class EndpointURLFactoryTests: XCTestCase {
    func testSearchURLContainsQuery() throws {
        let factory = EndpointURLFactory()
        let query = "Swift"

        // 因为我们的测试函数是 throwing，这里我们可以简单地采用 'try'
        let url = try factory.makeURL(for: .search(query))
        XCTAssertTrue(url.absoluteString.contains(query))
    }
}
```

没有可选类型，没有强制解析，某些发生错误的时候也能完美地做出诊断 👍。

## 使用 require 的可选类型

然而，并不是所有返回可选类型的 API 都可以被替换为 throwing。不过在写包含可选类型的测试时，有一个和 throwing API 同样好的方法。

让我们回到最开始 `UserManager` 的例子。如果既不对 `loggedInUser` 进行强制解析，又不把它看作可选类型，那么我们可以简单地这样做：

```
let user = try require(service.loggedInUser)
XCTAssertEqual(user.name, "John")
XCTAssertEqual(user.age, 30)
```

这实在是太酷了！😎这样我们可以摆脱大量的强制解析，同时避免让我们的测试代码难于编写、难于上手。那么为了达到上述效果我们应该怎么做呢？这很简单，我们只需要对 `XCTestCase` 增加一个拓展，让我们分析任何可选类型表达式，并且返回非可选的值或者抛出一个错误，像这样：

```
extension XCTestCase {
    // 为了能够输出优雅的错误信息
    // 我们遵循 LocallizedErrow
    private struct RequireError<T>: LocalizedError {
        let file: StaticString
        let line: UInt

        // 实现这个属性非常重要
        // 否则测试失败时我们无法在记录中优雅地输出错误信息
        var errorDescription: String? {
            return "😱 Required value of type \(T.self) was nil at line \(line) in file \(file)."
        }
    }

    // 使用 file 和 line 使得我们能够自动捕获
    // 源代码中出现的相对应的表达式
    func require<T>(_ expression: @autoclosure () -> T?,
                    file: StaticString = #file,
                    line: UInt = #line) throws -> T {
        guard let value = expression() else {
            throw RequireError<T>(file: file, line: line)
        }

        return value
    }
}
```

现在有了上述内容，如果我们 `UserManager` 登录测试发生失败，我们也能得到一个非常优雅的错误信息，告诉我们错误发生的准确位置。

```
[UserServiceTests testLoggingIn] : failed: caught error: 😱 Required value of type User was nil at line 97 in file UserServiceTests.swift.
```

**你可能意识到这个技巧来源于我的迷你框架 [Require](https://github.com/johnsundell/require), 它对所有可选类型增加了一个 require() 方法，以提高对无法避免的强制解析的诊断效果。**

## 总结

以同样谨慎的态度对待你的应用代码和测试代码，在最开始可能有些不适应，但可以让长期维护测试变的更加简单 —— 不论是独立开发还是团队开发。良好的错误诊断和错误信息是其中特别重要的一部分，使用本文中的一些技巧或许能够让你在未来避免很多奇怪的问题。

我在测试代码中唯一使用强制解析的时候，就是在构建测试案例的属性时。因为这些总是在 `setUp` 中被创建、`tearDown` 中被销毁，我并不把他们当作真正的可选类型。正如以往，你同样需要查看你自己的代码，根据你自己的喜好，来权衡决定。

所以你觉得呢？你会采用一些本文中的技巧，还是你已经用了一些相关的方式？请让我知道，包括你可能有的任何的问题、评价和反馈 —— 可以在下面回复栏直接回复或者在 [Twitter @johnsundell](https://twitter.com/johnsundell) 上回复我。

感谢阅读！🚀

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
