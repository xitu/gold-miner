    
  > * 原文地址：[Under the hood of Futures & Promises in Swift](https://www.swiftbysundell.com/posts/under-the-hood-of-futures-and-promises-in-swift)
  > * 原文作者：[John Sundell](https://twitter.com/johnsundell)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/under-the-hood-of-futures-and-promises-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/under-the-hood-of-futures-and-promises-in-swift.md)
  > * 译者：[oOatuo](https://github.com/atuooo)
  > * 校对者：[Kangkang](https://github.com/xuxiaokang), [Richard_Lee](https://github.com/richardleeh)

# 探究 Swift 中的 Futures & Promises 

异步编程可以说是构建大多数应用程序最困难的部分之一。无论是处理后台任务，例如网络请求，在多个线程中并行执行重操作，还是延迟执行代码，这些任务往往会中断，并使我们很难调试问题。

正因为如此，许多解决方案都是为了解决上述问题而发明的 - 主要是围绕异步编程创建抽象，使其更易于理解和推理。对于大多数的解决方案来说，它们都是在"回调地狱"中提供帮助的，也就是当你有多个嵌套的闭包为了处理同一个异步操作的不同部分的时候。

这周，让我们来看一个这样的解决方案 - **Futures & Promises** - 让我们打开"引擎盖"，看看它们是如何工作的。。

## A promise about the future

当介绍 Futures & Promises 的概念时，大多数人首先会问的是 **Future 和 Promise 有什么区别？**。在我看来，最简单易懂的理解是这样的：

- **Promise** 是你对别人所作的承诺。
- 在 **Future** 中，你可能会选择兑现（解决）这个 promise，或者拒绝它。

如果我们使用上面的定义，Futures & Promises 变成了一枚硬币的正反面。一个 Promise 被构造，然后返回一个 Future，在那里它可以被用来在稍后提取信息。

那么这些在代码中看起来是怎样的？

让我们来看一个异步的操作，这里我们从网络加载一个 "User" 的数据，将其转换成模型，最后将它保存到一个本地数据库中。用”老式的办法“，闭包，它看起来是这样的：

```
class UserLoader {
    typealias Handler = (Result<User>) -> Void

    func loadUser(withID id: Int, completionHandler: @escaping Handler) {
        let url = apiConfiguration.urlForLoadingUser(withID: id)

        let task = urlSession.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                completionHandler(.error(error))
            } else {
                do {
                    let user: User = try unbox(data: data ?? Data())

                    self?.database.save(user) {
                        completionHandler(.value(user))
                    }
                } catch {
                    completionHandler(.error(error))
                }
            }
        }

        task.resume()
    }
}
```

正如我们可以看到的，即使有一个非常简单（非常常见）的操作，我们最终得到了相当深的嵌套代码。这是用 Future & Promise 替换之后的样子：

```
class UserLoader {
    func loadUser(withID id: Int) -> Future<User> {
        let url = apiConfiguration.urlForLoadingUser(withID: id)

        return urlSession.request(url: url)
                         .unboxed()
                         .saved(in: database)
    }
}
```

这是调用时的写法：

```
let userLoader = UserLoader()
userLoader.loadUser(withID: userID).observe { result in
    // Handle result
}
```

现在上面的代码可能看起来有一点黑魔法（所有其他的代码去哪了？！😱），所以让我们来深入研究一下它是如何实现的。

## 探究 future

**就像编程中的大多数事情一样，有许多不同的方式来实现 Futures & Promises。在本文中，我将提供一个简单的实现，最后将会有一些流行框架的链接，这些框架提供了更多的功能。**

让我们开始探究下 `Future` 的实现，这是从异步操作中*公开返回*的。它提供了一种**只读**的方式来观察每当被赋值的时候以及维护一个观察回调列表，像这样：

```
class Future<Value> {
    fileprivate var result: Result<Value>? {
        // Observe whenever a result is assigned, and report it
        didSet { result.map(report) }
    }
    private lazy var callbacks = [(Result<Value>) -> Void]()

    func observe(with callback: @escaping (Result<Value>) -> Void) {
        callbacks.append(callback)

        // If a result has already been set, call the callback directly
        result.map(callback)
    }

    private func report(result: Result<Value>) {
        for callback in callbacks {
            callback(result)
        }
    }
}
```

## 生成 promise

接下来，硬币的反面，`Promise` 是 `Future` 的子类，用来添加**解决**和**拒绝**它的 API。解决一个承诺的结果是，在未来成功地完成并返回一个值，而拒绝它会导致一个错误。像这样：

```
class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()

        // If the value was already known at the time the promise
        // was constructed, we can report the value directly
        result = value.map(Result.value)
    }

    func resolve(with value: Value) {
        result = .value(value)
    }

    func reject(with error: Error) {
        result = .error(error)
    }
}
```

正如你看到的，Futures & Promises 的基本实现非常简单。我们从使用这些方法中获得的很多神奇之处在于，这些扩展可以增加连锁和改变未来的方式，使我们能够构建这些漂亮的操作链，就像我们在 UserLoader 中所做的那样。

但是，如果不添加用于链式操作的api，我们就可以构造用户加载异步链的第一部分 - `urlSession.request(url:)`。在异步抽象中，一个常见的做法是在 SDK 和 Swift 标准库之上提供方便的 API，所以我们也会在这里做这些。`request(url:)` 方法将是 `URLSession` 的一个扩展，让它可以用作基于 Future/Promise 的 API。

```
extension URLSession {
    func request(url: URL) -> Future<Data> {
        // Start by constructing a Promise, that will later be
        // returned as a Future
        let promise = Promise<Data>()

        // Perform a data task, just like normal
        let task = dataTask(with: url) { data, _, error in
            // Reject or resolve the promise, depending on the result
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }

        task.resume()

        return promise
    }
}
```

我们现在可以通过简单地执行以下操作来执行网络请求：

```
URLSession.shared.request(url: url).observe { result in
    // Handle result
}
```

## 链式

接下来，让我们看一下如何将多个 future 组合在一起，形成一条链 — 例如当我们加载数据时，将其解包并在 UserLoader 中将实例保存到数据库中。

链式的写法涉及到提供一个闭包，该闭包可以返回一个新值的 future。这将使我们能够从一个操作获得结果，将其传递给下一个操作，并从该操作返回一个新值。让我们来看一看：

```
extension Future {
    func chained<NextValue>(with closure: @escaping (Value) throws -> Future<NextValue>) -> Future<NextValue> {
        // Start by constructing a "wrapper" promise that will be
        // returned from this method
        let promise = Promise<NextValue>()

        // Observe the current future
        observe { result in
            switch result {
            case .value(let value):
                do {
                    // Attempt to construct a new future given
                    // the value from the first one
                    let future = try closure(value)

                    // Observe the "nested" future, and once it
                    // completes, resolve/reject the "wrapper" future
                    future.observe { result in
                        switch result {
                        case .value(let value):
                            promise.resolve(with: value)
                        case .error(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .error(let error):
                promise.reject(with: error)
            }
        }

        return promise
    }
}
```

使用上面的方法，我们现在可以给 **`Savable` 类型的 future** 添加一个扩展，来确保数据一旦可用时，能够轻松地保存到数据库。

```
extension Future where Value: Savable {
    func saved(in database: Database) -> Future<Value> {
        return chained { user in
            let promise = Promise<Value>()

            database.save(user) {
                promise.resolve(with: user)
            }

            return promise
        }
    }
}
```

现在我们来挖掘下 Futures & Promises 的真正潜力，我们可以看到 API 变得多么容易扩展，因为我们可以在 `Future` 的类中使用不同的通用约束，方便地为不同的值和操作添加方便的 API。

## 转换

虽然链式调用提供了一个强大的方式来有序地执行异步操作，但有时你只是想要对值进行简单的同步转换 - 为此，我们将添加对**转换**的支持。

转换直接完成，可以随意地抛出，对于 JSON 解析或将一种类型的值转换为另一种类型来说是完美的。就像 `chained()` 那样，我们将添加一个 `transformed()` 方法作为 `Future` 的扩展，像这样：

```
extension Future {
    func transformed<NextValue>(with closure: @escaping (Value) throws -> NextValue) -> Future<NextValue> {
        return chained { value in
            return try Promise(value: closure(value))
        }
    }
}
```

正如你在上面看到的，转换实际上是一个链式操作的同步版本，因为它的值是直接已知的 - 它构建时只是将它传递给一个新 `Promise` 。

使用我们新的变换 API, 我们现在可以添加支持，将 `Data` 类型 的 future 转变为一个 `Unboxable` 类型(JSON可解码) 的 future类型，像这样：

```
extension Future where Value == Data {
    func unboxed<NextValue: Unboxable>() -> Future<NextValue> {
        return transformed { try unbox(data: $0) }
    }
}
```

## 整合所有

现在，我们有了把 `UserLoader` 升级到支持 Futures & Promises 的所有部分。我将把操作分解为每一行，这样就更容易看到每一步发生了什么：

```
class UserLoader {
    func loadUser(withID id: Int) -> Future<User> {
        let url = apiConfiguration.urlForLoadingUser(withID: id)

        // Request the URL, returning data
        let requestFuture = urlSession.request(url: url)

        // Transform the loaded data into a user
        let unboxedFuture: Future<User> = requestFuture.unboxed()

        // Save the user in the database
        let savedFuture = unboxedFuture.saved(in: database)

        // Return the last future, as it marks the end of the chain
        return savedFuture
    }
}
```

当然，我们也可以做我们刚开始做的事情，把所有的调用串在一起 (这也给我们带来了利用 Swift 的类型推断来推断 `User` 类型的 future 的好处):

```
class UserLoader {
    func loadUser(withID id: Int) -> Future<User> {
        let url = apiConfiguration.urlForLoadingUser(withID: id)

        return urlSession.request(url: url)
                         .unboxed()
                         .saved(in: database)
    }
}
```

## 结论

在编写异步代码时，Futures & Promises 是一个非常强大的工具，特别是当您需要将多个操作和转换组合在一起时。它几乎使您能够像同步那样去编写异步代码，这可以提高可读性，并使在需要时可以更容易地移动。

然而，就像大多数抽象化一样，你本质上是在掩盖复杂性，把大部分的重举移到幕后。因此，尽管 `urlSession.request(url:)` 从外部看，API看起来很好，但调试和理解到底发生了什么都会变得更加困难。

我的建议是，如果你在使用 Futures & Promises，那就是让你的调用链尽可能精简。记住，好的文档和可靠的单元测试可以帮助你避免很多麻烦和棘手的调试。

以下是一些流行的 Swift 版本的 Futures & Promises 开源框架：

- [PromiseKit](https://github.com/mxcl/PromiseKit)
- [BrightFutures](https://github.com/Thomvis/BrightFutures)
- [When](https://github.com/vadymmarkov/When)
- [Then](https://github.com/freshOS/then)

你也可以在 [GitHub](https://github.com/JohnSundell/SwiftBySundell/blob/master/Blog/Under-the-hood-of-Futures-and-Promises.swift) 上找到该篇文章涉及的的所有代码。

如果有问题，欢迎留言。我非常希望听到你的建议！👍你可以在下面留言，或者在 Twitter [@johnsundell](https://twitter.com/johnsundell) 联系我。

另外，你可以获取最新的 [Sundell 的 Swift 播客](https:swiftbysundell.compodcast)，我和来自社区的游客都会在上面回答你关于 Swift 开发的问题。

感谢阅读 🚀。

  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  
