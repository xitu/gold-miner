
  > * 原文地址：[Under the hood of Futures & Promises in Swift](https://www.swiftbysundell.com/posts/under-the-hood-of-futures-and-promises-in-swift)
  > * 原文作者：[John Sundell](https://twitter.com/johnsundell)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/under-the-hood-of-futures-and-promises-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/under-the-hood-of-futures-and-promises-in-swift.md)
  > * 译者：
  > * 校对者：

  # Under the hood of Futures & Promises in Swift

  Asynchronous programming is arguably one of the hardest parts of building most apps. Whether it's handling background tasks such as a network request, performing heavy operations in parallel across multiple threads, or executing code with a delay - things tend to break and leave us with hard to debug problems.

Because of this, many solutions have been invented to try to combat the above problem - basically creating abstractions around asynchronous programming to make it easier to understand and reason about. What's true for most of these solutions is that they all offer a helping hand out of "callback hell", which is when you have multiple nested closures all dealing with different parts of an async operation.

This week, let's take a look at one such solution - *Futures & Promises* - and go a bit "under the hood" to see how they actually work.

## A promise about the future

When introduced to the concept of Futures & Promises, the first thing most people ask is *"What's the difference between a Future and a Promise?"*. The easiest way to think about it, in my opinion, is like this:

- A **Promise** is something you make to someone else.
- In the **Future** you may choose to honor (resolve) that promise, or reject it.

If we use the above definition, Futures & Promises become two sides of the same coin. A promise gets constructed, then returned as a future, where it can be used to extract information at a later point.

So what does that look like in code?

Let's take a look at an asynchronous operation, where we load data for a `User` over the network, transform it into a model, and then finally save it to a local database. Using the "old fashioned way", with closures, it would look like this:

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

As we can see above, even with a quite simple (and very common) operation like this, we end up with quite deeply nested code. This is what the above looks like with Futures & Promises instead:

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

And this is what the call site looks like:

```
let userLoader = UserLoader()
userLoader.loadUser(withID: userID).observe { result in
    // Handle result
}
```

Now the above might seem a bit like black magic (where did all of our code go?! 😱), so let's dive deeper and take a look at how it's all implemented.

## Looking into the future

*Like most things in programming, there are of course many different ways to implement Futures & Promises. In this post I'll provide a simple implementation, and at the end there will be links to some popular frameworks that offer a lot more functionality.*

Let's start by taking a look under the hood of a `Future`, which is what is *publicly returned* from an async operation. It offers a *read only* way to observe whenever a value is assigned to it and maintains a list of observation callbacks, like this:

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

## Making a promise

Next, the flip side of the coin, `Promise` is a subclass of `Future` that adds APIs for *resolving* and *rejecting* it. Resolving a promise results in the future being successfully completed with a value, while rejecting it results in an error. Here's what `Promise` looks like:

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

As you can see above, the basic implementation of Futures & Promises is quite simple. A lot of the "magic" that we get from using them though, comes from extensions that adds ways to chain and transform futures, enabling us to construct these nice chains of operations like we did in `UserLoader`.

But without adding APIs for chaining, we can already construct the first part of our user loading async chain - `urlSession.request(url:)`. A common practice in async abstractions is to provide convenience APIs on top of the SDKs and the Swift standard library, so that's what we'll do here too. The `request(url:)` method will be an extension on `URLSession` that lets it be used as a Future/Promise-based API:

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

We can now perform a network request by simply doing the following:

```
URLSession.shared.request(url: url).observe { result in
    // Handle result
}
```

## Chaining

Next, let's take a look at how we can chain multiple futures together to form a chain - like the one we used to load data, unbox it and save an instance to a database in `UserLoader`.

Chaining involves providing a closure that given a value returns a future for a new  value. This will enable us to take the result from one operation, pass it onto the next, and return a new value from that. Let's take a look:

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

Using the above, we can now add an extension on *futures for `Savable` types*, to enable values to easily be saved to a database once available:

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

Now we're starting to tap into the true potential of Futures & Promises, and we can see how easily extendable the API becomes, as we can easily add convenience APIs for various values and operations by using different generic constraints on the `Future` class.

## Transforms

While chaining provides a powerful way to sequentially perform async operations, sometimes you just want to do a simple synchronous transform of a value - and for that, we're going to add support for *transforms*.

A transform completes directly, can optionally throw, and is perfect for things like JSON parsing or transforming a value of one type into another. Just like we did for `chained()`, we'll add a `transformed()` method as an extension on `Future`, like this:

```
extension Future {
    func transformed<NextValue>(with closure: @escaping (Value) throws -> NextValue) -> Future<NextValue> {
        return chained { value in
            return try Promise(value: closure(value))
        }
    }
}
```

As you can see above, a transform is really just a synchronous version of a chaining operation, and since its value is known directly - it simply passes it into a new `Promise` when constructing it.

Using our new transform API, we can now add support for transforming a future for `Data` into a future for an `Unboxable` (JSON decodable) type, like this:

```
extension Future where Value == Data {
    func unboxed<NextValue: Unboxable>() -> Future<NextValue> {
        return transformed { try unbox(data: $0) }
    }
}
```

## Putting it all together

We now have all the parts needed to upgrade our `UserLoader` to support Futures & Promises. I'll break down the operations to each be on its own line, so it's easier to see what's going on for each step:

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

And we can of course also do what we did in the beginning, and chain all the calls together (which also gives us the benefit of utilizing Swift's type inference to infer the type of the `User` future):

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

## Conclusion

Futures & Promises can be a really powerful tool when writing asynchronous code, especially if you need to chain multiple operations and transforms together. It almost enables you to write async code as if it was synchronous, which can really improve readability and make it easier to move things around if needed.

However - like in most abstractions - you are essentially "burying complexity", moving most of the heavy lifting under the covers. So while a `urlSession.request(url:)` API looks really nice from the outside, it can get harder to both debug and understand what exactly is going on on the inside.

My advice if you're using Futures & Promises, is to try to keep your chains as short and simple as possible, and remember that good documentation and solid unit tests can really help you avoid a lot of headaches and tricky debugging in the future.

Here are some popular open source frameworks for Futures & Promises in Swift:

- [PromiseKit](https://github.com/mxcl/PromiseKit)
- [BrightFutures](https://github.com/Thomvis/BrightFutures)
- [When](https://github.com/vadymmarkov/When)
- [Then](https://github.com/freshOS/then)

You can also find all the sample code from this post on [GitHub here](https://github.com/JohnSundell/SwiftBySundell/blob/master/Blog/Under-the-hood-of-Futures-and-Promises.swift).

Do you have questions, feedback or comments? I'd love to hear from you! 👍 Feel free to either leave a comment below, or contact me on Twitter [@johnsundell](https://twitter.com/johnsundell).

Also make sure to check out the new [Swift by Sundell podcast](https://swiftbysundell.com/podcast), on which me & guests from the community answer your questions about Swift development!

Thanks for reading 🚀


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  