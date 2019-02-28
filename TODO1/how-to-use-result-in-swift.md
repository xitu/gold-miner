> * 原文地址：[How to use Result in Swift 5](https://www.hackingwithswift.com/articles/161/how-to-use-result-in-swift)
> * 原文作者：[Paul Hudson](https://twitter.com/twostraws)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-result-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-use-result-in-swift.md)
> * 译者：
> * 校对者：

# How to use Result in Swift 5

![](https://www.hackingwithswift.com/uploads/swift-evolution-5.jpg)

[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) introduces a `Result` type into the standard library, giving us a simpler, clearer way of handling errors in complex code such as asynchronous APIs. This is something folks have been asking for since the very earliest days of Swift, so it's great to see it finally arrive!

Swift’s `Result` type is implemented as an enum that has two cases: `success` and `failure`. Both are implemented using generics so they can have an associated value of your choosing, but `failure` must be something that conforms to Swift’s `Error` type.

To demonstrate `Result`, we could write a function that connects to a server to figure out how many unread messages are waiting for the user. In this example code we’re going to have just one possible error, which is that the requested URL string isn’t a valid URL:

```
enum NetworkError: Error {
    case badURL
}
```
The fetching function will accept a URL string as its first parameter, and a completion handler as its second. That completion handler will itself accept a `Result`, where the success case will store an integer, and the failure case will be some sort of `NetworkError`. We’re not actually going to connect to a server here, but using a completion handler at least lets us simulate asynchronous code.

Here’s the code:

```
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

To use that code we need to check the value inside our `Result` to see whether our call succeeded or failed, like this:

```
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    switch result {
    case .success(let count):
        print("\(count) unread messages.")
    case .failure(let error):
        print(error.localizedDescription)
    }
}
```

Even in this simple scenario, `Result` has given us two benefits. First, the error we get back is now strongly typed: it must be some sort of `NetworkError`. Swift’s regular throwing functions are unchecked and so can throw any type of error. As a result, if you add a `switch` block to go over their cases you need to add `default` case even when it isn’t possible. With the strongly-typed errors of `Result` we can create exhaustive `switch` blocks by listing all the cases of our error enum.

Second, it’s now clear that we will get back _either_ successful data _or_ an error – it is not possible to get both or neither of them. You can see the importance of this second benefit if we rewrite `fetchUnreadCount1()` using the traditional, Objective-C approach to completion handlers:

```
func fetchUnreadCount2(from urlString: String, completionHandler: @escaping (Int?, NetworkError?) -> Void) {
    guard let url = URL(string: urlString) else {
        completionHandler(nil, .badURL)
        return
    }
    
    print("Fetching \(url.absoluteString)...")
    completionHandler(5, nil)
}
```

Here the completion handler is expected to receive both an integer and an error, although either of them might be nil. Objective-C used this approach because it doesn’t have the ability to express enums with an associated value, so there was no choice but to send back both and let users figure it out.

However, this approach means we’ve gone from two possible states to four: an integer with no error, an error with no integer, an error _and_ an integer, and no error with no integer. Those last two ought to be impossible states, but there was no easy way to express this before Swift introduced `Result`.

This situation occurs a _lot_. The `dataTask()` method from `URLSession` uses the same approach, for example: it calls its completion handler with `(Data?, URLResponse?, Error?)`. That might give us some data, a response, and an error, or any combination of the three – the Swift Evolution proposal calls this situation “awkwardly disparate”.

Think of `Result` as a super-powered `Optional`: it wraps a successful value, but can also wrap a second case that expresses the absence of a value. With `Result`, though, that absence conveys bonus data, because rather than just being `nil` it instead tells us what went wrong.

## Why not use `throws`?

When you first meet `Result` it’s common to wonder why it’s useful, particularly when Swift already has a perfectly good `throws` keyword for handling errors ever since Swift 2.0.

You could implement much the same functionality by making the completion handler accept _another_ function that throws or returns the data in question, like this:

```
func fetchUnreadCount3(from urlString: String, completionHandler: @escaping  (() throws -> Int) -> Void) {
    guard let url = URL(string: urlString) else {
        completionHandler { throw NetworkError.badURL }
        return
    }
    
    print("Fetching \(url.absoluteString)...")
    completionHandler { return 5 }
}
```

You could then call `fetchUnreadCount3()` with a completion handler that accepts a function to run, like this:

```
fetchUnreadCount3(from: "https://www.hackingwithswift.com") { resultFunction in
    do {
        let count = try resultFunction()
        print("\(count) unread messages.")
    } catch {
        print(error.localizedDescription)
    }
}
```

This gets us to more or less the same place, but it’s significantly more complicated to read. Worse, we don’t actually know what calling the `result()` function does, so there’s a risk it might cause its own problems if it does more than just send back a value or throw.

Even with simpler code, using `throws` often forces us handle errors immediately, rather than store them away for later processing. With `Result` that problem goes away: errors are stashed away in a value that we can read when we’re ready.

## Working with Result

We’ve already looked at how `switch` blocks let us evaluate both the `success` and `failure` cases of `Result` in a clean way, but there are five more things you ought to know before you start using it.

First, `Result` has a `get()` method that either returns the successful value if it exists, or throws its error otherwise. This allows you to convert `Result` into a regular throwing call, like this:

```
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    if let count = try? result.get() {
        print("\(count) unread messages.")
    }
}

```

Second, you can use regular `if` statements to read the cases of an enum if you prefer, although some find the syntax a little odd. For example:

```
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    if case .success(let count) = result {
        print("\(count) unread messages.")
    }
}
```

Third, `Result` has an initializer that accepts a throwing closure: if the closure returns a value successfully that gets used for the `success` case, otherwise the thrown error is placed into the `failure` case.

For example:

```
let result = Result { try String(contentsOfFile: someFile) }
```

Fourth, rather than using a specific error enum that you’ve created, you can also use the general `Error` protocol. In fact, the Swift Evolution proposal says “it's expected that most uses of Result will use `Swift.Error` as the `Error` type argument.”

So, rather than using `Result<Int, NetworkError>` you could use `Result<Int, Error>`. Although this means you lose the safety of typed throws, you gain the ability to throw a variety of different error enums – which you prefer really depends on your coding style.

Finally, if you already have a custom `Result` type in your project – anything you have defined yourself or imported from one of the custom `Result` types on GitHub – then they will automatically be used in place of Swift’s own `Result` type. This will allow you to upgrade to Swift 5.0 without breaking your code, but ideally you’ll move to Swift’s own `Result` type over time to avoid incompatibilities with other projects.

## Transforming Result

`Result` has four other methods that may prove useful: `map()`, `flatMap()`, `mapError()`, and `flatMapError()`. Each of these give you the ability to transform either the success or error somehow, and the first two work similarly to the methods of the same name on `Optional`.

The `map()` method looks inside the `Result`, and transforms the success value into a different kind of value using a closure you specify. However, if it finds failure instead, it just uses that directly and ignores your transformation.

To demonstrate this, we’re going to write some code that generates random numbers between 0 and a maximum then calculate the factors of that number. If the user requests a random number below zero, or if the number happens to be prime – i.e., it has no factors except itself and 1 – then we’ll consider those to be failures.

We might start by writing code to model the two possible failure cases: the user has tried to generate a random number below 0, and the number that was generated was prime:

```
enum FactorError: Error {
    case belowMinimum
    case isPrime
}
```
Next, we’d write a function that accepts a maximum number, and returns either a random number or an error:

```
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

When that’s called, the `Result` we get back will either be an integer or an error, so we could use `map()` to transform it:

```
let result1 = generateRandomNumber(maximum: 11)
let stringNumber = result1.map { "The random number is: \($0)." }
```

As we’ve passed in a valid maximum number, `result` will be a success with a random number. So, using `map()` will take that random number, use it with our string interpolation, then return another `Result` type, this time of the type `Result<String, FactorError>`.

However, if we had used `generateRandomNumber(maximum: -11)` then `result` would be set to the failure case with `FactorError.belowMinimum`. So, using `map()` would still return a `Result<String, FactorError>`, but it would have the same failure case and same `FactorError.belowMinimum` error.

Now that you’ve seen how `map()` lets us transform the success type to another type, let’s continue: we have a random number, so the next step is to calculate the factors for it. To do this, we’ll write another function that accepts a number and calculates its factors. If it finds the number is prime it will send back a failure `Result` with the `isPrime` error, otherwise it will send back the number of factors.

Here’s that in code:

```
func calculateFactors(for number: Int) -> Result<Int, FactorError> {
    let factors = (1...number).filter { number % $0 == 0 }
    
    if factors.count == 2 {
        return .failure(.isPrime)
    } else {
        return .success(factors.count)
    }
}
```

If we wanted to use `map()` to transform the output of `generateRandomNumber()` using `calculateFactors()`, it would look like this:

```
let result2 = generateRandomNumber(maximum: 10)
let mapResult = result2.map { calculateFactors(for: $0) }
```

However, that make `mapResult` a rather ugly type: `Result<Result<Int, FactorError>, FactorError>`. It’s a `Result` inside another `Result`.

Just like with optionals, this is where the `flatMap()` method comes in. If your transform closure returns a `Result`, `flatMap()` will return the new `Result` directly rather than wrapping it in another `Result`:

```
let flatMapResult = result2.flatMap { calculateFactors(for: $0) }
```

So, where `mapResult` was a `Result<Result<Int, FactorError>, FactorError>`, `flatMapResult` is flattened down into `Result<Int, FactorError>` – the first original success value (a random number) was transformed into a new success value (the number of factors). Just like `map()`, if either `Result` was a failure, `flatMapResult` will also be a failure.

As for `mapError()` and `flatMapError()`, those do similar things except they transform the _error_ value rather than the _success_ value.

## What next?

I’ve written articles about some of the other great new features coming in Swift 5, and you might want to check them out:

* [How to use custom string interpolation in Swift 5](/articles/163/how-to-use-custom-string-interpolation-in-swift)
* [How to use @dynamicCallable in Swift](/articles/134/how-to-use-dynamiccallable-in-swift)
* [Swift 5.0 is changing optional try](/articles/147/swift-5-is-changing-optional-try)
* [What’s new in Swift 5.0](/articles/126/whats-new-in-swift-5-0)

You might also want to try out my [What’s new in Swift 5.0 playground](https://github.com/twostraws/whats-new-in-swift-5-0), which lets you try Swift 5’s new features interactively.

If you’re curious to learn more about result types in Swift, you might want to look over the source code for [antitypical/Result](https://github.com/antitypical/Result) on GitHub, which is one of the most popular result implementations.

I would also highly recommend reading Matt Gallagher’s [excellent discussion of `Result`](https://www.cocoawithlove.com/blog/2016/08/21/result-types-part-one.html) – it’s a few years old now, but still both useful and interesting.

**Sponsored** You’re already busy updating your app for Swift 4.2 and iOS 12, so why not let Instabug help you find and fix bugs? **Add just two lines of code** to your project and receive comprehensive reports with all the feedback you need to ship a world-class app – [click here to learn more](https://try.instabug.com/ios/?utm_source=hackingwithswift&utm_medium=native_ads&utm_campaign=hackingwithswiftv3)!


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


