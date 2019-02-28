> * 原文地址：[Using errors as control flow in Swift](https://www.swiftbysundell.com/posts/using-errors-as-control-flow-in-swift)
> * 原文作者：[John Sundell](https://github.com/johnsundell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-errors-as-control-flow-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-errors-as-control-flow-in-swift.md)
> * 译者：
> * 校对者：

# Using errors as control flow in Swift
I’ve written articles about some of the other great new features coming in Swift 5, and you might want to check them out:

How we manage the control flow within the apps and systems that we work on can have a huge impact on everything from how fast our code executes, to how easy it is to debug. Our code's control flow is essentially the order in which our various functions and statements get executed, and what code paths that end up being entered.

While Swift offers a number of tools for defining control flow - such as statements like `if`, `else` and `while`, and constructs like optionals - this week, let's take a look at how we can use Swift's built-in error throwing and handling model to make our control flow easier to manage.

## Throwing away optionals

Optionals, while being an important language feature and a great way to model data that can be legitimately missing, can often become a source of boilerplate when it comes to the control flow within a given function.

Here we've written a function that lets us load an image from our app's bundle, and then tint and resize it. Since each of those operations currently return an optional image, we end up with several `guard` statements and points where our function can exit:

```
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

The problem we're facing above is that we're essentially using `nil` values to deal with runtime errors - which both has the downside of forcing us to unwrap the result of each operation, and also hides the _underlying reason_ as to why the error occurred in the first place.

Let's see how we could solve both of those issues by refactoring our control flow to instead use throwing functions and errors. We'll start by defining an enum containing cases for each error that can occur within our image handling code - looking something like this:

enum ImageError: Error {
    case missing
    case failedToCreateContext
    case failedToRenderImage
    ...
}

We'll then change all of our inner functions to throw one of the above errors whenever it failed, instead of returning `nil`. For example, here's how we could quickly update `loadImage(named:)` to either return a _non-optional_ `UIImage` or throw `ImageError.missing`:

```
private func loadImage(named name: String) throws -> UIImage {
    guard let image = UIImage(named: name) else {
        throw ImageError.missing
    }
    
    return image
}
```

Once we've given our other image handling functions the same treatment, we can then apply the same changes to our top-level function as well - removing all optionals and making it either return a concrete image or throw any error generated during our chain of operations:

```
func loadImage(named name: String,
               tintedWith color: UIColor,
               resizedTo size: CGSize) throws -> UIImage {
    var image = try loadImage(named: name)
    image = try tint(image, with: color)
    return try resize(image, to: size)
}
```

Not only does the above changes make the body of our function much simpler - it also makes debugging easier, since we'll now end up with a clearly defined error in case anything goes wrong - rather than having to figure out what caused `nil` to be returned.

However, we might not _always_ be interested in actually handling all errors - so we don't want to require the use of the `do, try, catch` pattern everywhere in our code base (which would, ironically, cause much of the same boilerplate we were trying to avoid - but at the call site instead).

The good news is that we can go back to working with optionals whenever we want to - even when using throwing functions. All we have to do is to use the `try?` keyword when calling a throwing function and we'll once again get an optional back:

```
let optionalImage = try? loadImage(
    named: "Decoration",
    tintedWith: .brandColor,
    resizedTo: decorationSize
)
```

What's great about `try?` is that it kind of gives us the best of both worlds. We're able to get an optional at the call site - while still letting us use the power of throws and errors to manage our internal control flow 👍.

##Validating input

Next, let's take a look at how we can improve our control flow using errors when performing input validation. Even though Swift has a really advanced and powerful type system, it can't _always_ ensure that our functions will receive valid input - sometimes a runtime check is our only option.

Let's take a look at another example, in which we're validating the user's chosen credentials when signing up for a new account. Just like before, our code currently uses `guard` statements for each validation rule, and outputs an error message in case of a failure - like this:

```
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

Even though we're only validating two pieces of data above, our validation logic can end up growing much quicker than we might expect. Having this kind of logic live together with our UI code (typically in a view controller) also makes things like testing much harder - so let's see if we can do some decoupling and also improve our control flow in the process.

Ideally, we'd like our validation code to be self-contained. That way it can both be worked on and tested in isolation, and also easily be reused throughout our code base and beyond. To make that happen, let's start by creating a dedicated type for all validation logic. We'll call it `Validator` and make it a simple struct that holds a validation closure for a given `Value` type:

```
struct Validator<Value> {
    let closure: (Value) throws -> Void
}
```

Using the above, we'll be able to construct validators that throw an error whenever a value didn't pass validation. However, having to always define a new `Error` type for each validation process might again generate unnecessary boilerplate (especially if all we want to do with an error is to display it to the user) - so let's also introduce a function that lets us write validation logic by simply passing a `Bool` condition and a message to display to the user in case of a failure:

```
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

_Above we're again using @autoclosure, which lets us defer an expression by automatically wrapping it in a closure. For more on that, check out ["Using @autoclosure when designing Swift APIs"](https://www.swiftbysundell.com/posts/using-autoclosure-when-designing-swift-apis)._

With the above in place, we can now implement all of our validation logic as dedicated validators - constructed using computed static properties on the `Validator` type. For example, here's how we might implement a validator for passwords:

```
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

To wrap things up, let's create another `validate` overload that'll act as a bit of _syntactic sugar_, by letting us call it with the value we wish to validate and the validator to use:

```
func validate<T>(_ value: T,
                 using validator: Validator<T>) throws {
    try validator.closure(value)
}
```

With all the building blocks in place, let's update the call site to use our new validation system. The beauty of the above approach is that, while requiring a few extra types and a little bit of infrastructure, it lets us make our code requiring input validation very nice and clean:

```
func signUpIfPossible(with credentials: Credentials) throws {
    try validate(credentials.username, using: .username)
    try validate(credentials.password, using: .password)
    
    service.signUp(with: credentials) { result in
        ...
    }
}
```

Perhaps even better, is that we can now deal with all validation errors in a single place, by calling the above `signUpIfPossible` function using the `do, try, catch` pattern - and then simply display the localized description of any thrown error to the user:

```
do {
    try signUpIfPossible(with: credentials)
} catch {
    errorLabel.text = error.localizedDescription
}
```

_Worth noting is that, while the above code samples didn't use any localization, we'd always want to use localized strings for all error messages when displaying them to the user in a real app._

##Throwing tests

Another big benefit of structuring code around what kind of errors that could be encountered, is that it often makes testing much easier. Since a throwing function essentially has two distinct possible outputs - a value and an error - adding tests covering both of those two scenarios is in many cases quite straight forward.

For example, here's how we could easily add tests for our password validation code - that covers two of our requirements by simply asserting that the error case does indeed throw an error, and that the success case doesn't:

```
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

As you can see above, since `XCTest` supports throwing test functions - and every unhandled error counts as a failure - all we have to do to verify the success case is to call our `validate` function using `try`, and if the function doesn't throw our test will succeed 👍.

##Conclusion

While there are many ways of organizing the control flow of Swift code - for operations that can either succeed or fail, using errors and throwing functions can be a great option. While doing so does require a bit of extra _ceremony_ (such as introducing error types and making all calls with either `try` or `try?`) \- it can give us some really nice benefits while also making our code much more compact.

It will of course still be appropriate to return optionals from some functions - especially those that don't really have any sensible errors to throw - but in places where we're juggling several different optionals and `guard` statements - using errors instead might give us a more clear flow of control.

What do you think? Do you currently use errors and throwing functions to manage your code's control flow - or is it something you'll try out? Let me know - along with your questions, comments and feedback - [on Twitter @johnsundell](https://twitter.com/johnsundell).
    
 Thanks for reading! 🚀


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


