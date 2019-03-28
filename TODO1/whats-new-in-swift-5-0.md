> * 原文地址：[What’s new in Swift 5.0](https://www.hackingwithswift.com/articles/126/whats-new-in-swift-5-0)
> * 原文作者：[Paul Hudson](https://www.hackingwithswift.com/about)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-swift-5-0.md](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-new-in-swift-5-0.md)
> * 译者：
> * 校对者：

# What’s new in Swift 5.0

![](https://www.hackingwithswift.com/uploads/swift-evolution-5.jpg)

Swift 5.0 is the next major release of Swift, and brings ABI stability at long last. That's not all, though: several key new features are already implemented, including raw strings, future enum cases, a `Result` type, checking for integer multiples and more.

*   **Try it yourself:** I created an [Xcode Playground showing what's new in Swift 5.0 with examples you can edit](https://github.com/twostraws/whats-new-in-swift-5-0).

### A standard `Result` type

*   [**Watch the video**](https://www.youtube.com/watch?v=RBZFCp3kSLM)

[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md) introduces a `Result` type into the standard library, giving us a simpler, clearer way of handling errors in complex code such as asynchronous APIs.

Swift’s `Result` type is implemented as an enum that has two cases: `success` and `failure`. Both are implemented using generics so they can have an associated value of your choosing, but `failure` must be something that conforms to Swift’s `Error` type.

To demonstrate `Result`, we could write a function that connects to a server to figure out how many unread messages are waiting for the user. In this example code we’re going to have just one possible error, which is that the requested URL string isn’t a valid URL:

```
enum NetworkError: Error {
    case badURL
}
```

The fetching function will accept a URL string as its first parameter, and a completion handler as its second parameter. That completion handler will itself accept a `Result`, where the success case will store an integer, and the failure case will be some sort of `NetworkError`. We’re not actually going to connect to a server here, but using a completion handler at least lets us simulate asynchronous code.

Here’s the code:

```
import Foundation

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

There are three more things you ought to know before you start using `Result` in your own code.

First, `Result` has a `get()` method that either returns the successful value if it exists, or throws its error otherwise. This allows you to convert `Result` into a regular throwing call, like this:

```
fetchUnreadCount1(from: "https://www.hackingwithswift.com") { result in
    if let count = try? result.get() {
        print("\(count) unread messages.")
    }
}
```

Second, `Result` has an initializer that accepts a throwing closure: if the closure returns a value successfully that gets used for the `success` case, otherwise the thrown error is placed into the `failure` case.

For example:

```
let result = Result { try String(contentsOfFile: someFile) }
```

Third, rather than using a specific error enum that you’ve created, you can also use the general `Error` protocol. In fact, the Swift Evolution proposal says “it's expected that most uses of Result will use `Swift.Error` as the `Error` type argument.”

So, rather than using `Result<Int, NetworkError>` you could use `Result<Int, Error>`. Although this means you lose the safety of typed throws, you gain the ability to throw a variety of different error enums – which you prefer really depends on your coding style.

### Raw strings

*   [**Watch the video**](https://www.youtube.com/watch?v=e6tuUzmxyOU)

[SE-0200](https://github.com/apple/swift-evolution/blob/master/proposals/0200-raw-string-escaping.md) added the ability to create raw strings, where backslashes and quote marks are interpreted as those literal symbols rather than escapes characters or string terminators. This makes a number of use cases more easy, but regular expressions in particular will benefit.

To use raw strings, place one or more `#` symbols before your strings, like this:

```
let rain = #"The "rain" in "Spain" falls mainly on the Spaniards."#
```

The `#` symbols at the start and end of the string become part of the string delimiter, so Swift understands that the standalone quote marks around “rain” and “Spain” should be treated as literal quote marks rather than ending the string.

Raw strings allow you to use backslashes too:

```
let keypaths = #"Swift keypaths such as \Person.name hold uninvoked references to properties."#
```

That treats the backslash as being a literal character in the string, rather than an escape character. This in turn means that string interpolation works differently:

```
let answer = 42
let dontpanic = #"The answer to life, the universe, and everything is \#(answer)."#
```

Notice how I’ve used `\#(answer)` to use string interpolation – a regular `\(answer)` will be interpreted as characters in the string, so when you want string interpolation to happen in a raw string you must add the extra `#`.

One of the interesting features of Swift’s raw strings is the use of hash symbols at the start and end, because you can use more than one in the unlikely event you’ll need to. It’s hard to provide a good example here because it really ought to be extremely rare, but consider this string: **My dog said "woof"#gooddog**. Because there’s no space before the hash, Swift will see `"#` and immediately interpret it as the string terminator. In this situation we need to change our delimiter from `#"` to `##"`, like this:

```
let str = ##"My dog said "woof"#gooddog"##
```

Notice how the number of hashes at the end must match the number at the start.

Raw strings are fully compatible with Swift’s multi-line string system – just use `#"""` to start, then `"""#` to end, like this:

```
let multiline = #"""
The answer to life,
the universe,
and everything is \#(answer).
"""#
```

Being able to do without lots of backslashes will prove particularly useful in regular expressions. For example, writing a simple regex to find keypaths such as `\Person.name` used to look like this:

```
let regex1 = "\\\\[A-Z]+[A-Za-z]+\\.[a-z]+"
```

Thanks to raw strings we can write the same thing with half the number of backslashes:

```
let regex2 = #"\\[A-Z]+[A-Za-z]+\.[a-z]+"#
```

We still need _some_, because regular expressions use them too.

### Customizing string interpolation

[SE-0228](https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md) dramatically revamped Swift’s string interpolation system so that it’s more efficient and more flexible, and it’s creating a whole new range of features that were previously impossible.

In its most basic form, the new string interpolation system lets us control how objects appear in strings. Swift has default behavior for structs that is helpful for debugging, because it prints the struct name followed by all its properties. But if you were working with classes (that don’t have this behavior), or wanted to format that output so it could be user-facing, then you could use the new string interpolation system.

For example, if we had a struct like this:

```
struct User {
    var name: String
    var age: Int
}
```

If we wanted to add a special string interpolation for that so that we printed users neatly, we would add an extension to `String.StringInterpolation` with a new `appendInterpolation()` method. Swift already has several of these built in, and users the interpolation _type_ – in this case `User` to figure out which method to call.

In this case, we’re going to add an implementation that puts the user’s name and age into a single string, then calls one of the built-in `appendInterpolation()` methods to add that to our string, like this:

```
extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: User) {
        appendInterpolation("My name is \(value.name) and I'm \(value.age)")
    }
}
```

Now we can create a user and print out their data:

```
let user = User(name: "Guybrush Threepwood", age: 33)
print("User details: \(user)")
```

That will print **User details: My name is Guybrush Threepwood and I'm 33**, whereas with the custom string interpolation it would have printed **User details: User(name: "Guybrush Threepwood", age: 33)**. Of course, that functionality is no different from just implementing the `CustomStringConvertible` protocol, so let’s move on to more advanced usages.

Your custom interpolation method can take as many parameters as you need, labeled or unlabeled. For example, we could add an interpolation to print numbers using various styles, like this:

```
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

The `NumberFormatter` class has a number of styles, including currency ($72.83), ordinal (1st, 12th), and spell out (five, forty-three). So, we could create a random number and have it spelled out into a string like this:

```
let number = Int.random(in: 0...100)
let lucky = "The lucky number this week is \(number, style: .spellOut)."
print(lucky)
```

You can call `appendLiteral()` as many times as you need, or even not at all if necessary. For example, we could add a string interpolation to repeat a string multiple times, like this:

```
extension String.StringInterpolation {
    mutating func appendInterpolation(repeat str: String, _ count: Int) {
        for _ in 0 ..< count {
            appendLiteral(str)
        }
    }
}

print("Baby shark \(repeat: "doo ", 6)")
```

And, as these are just regular methods, you can use Swift’s full range of functionality. For example, we might add an interpolation that joins an array of strings together, but if that array is empty execute a closure that returns a string instead:

```
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
print("List of students: \(names, empty: "No one").")
```

Using `@autoclosure` means that we can use simple values or call complex functions for the default value, but none of that work will be done unless `values.count` is zero.

With a combination of the `ExpressibleByStringLiteral` and `ExpressibleByStringInterpolation` protocols it’s now possible to create whole types using string interpolation, and if we add `CustomStringConvertible` we can even make those types print as strings however we want.

To make this work, we need to fulfill some specific criteria:

*   Whatever type we create should conform to `ExpressibleByStringLiteral`, `ExpressibleByStringInterpolation`, and `CustomStringConvertible`. The latter is only needed if you want to customize the way the type is printed.
*   _Inside_ your type needs to be a nested struct called `StringInterpolation` that conforms to `StringInterpolationProtocol`.
*   The nested struct needs to have an initializer that accepts two integers telling us roughly how much data it can expect.
*   It also needs to implement an `appendLiteral()` method, as well as one or more `appendInterpolation()` methods.
*   Your main type needs to have two initializers that allow it to be created from string literals and string interpolations.

We can put all that together into an example type that can construct HTML from various common elements. The “scratchpad” inside the nested `StringInterpolation` struct will be a string: each time a new literal or interpolation is added, we’ll append it to the string. To help you see exactly what’s going on, I’ve added some `print()` calls inside the various append methods.

Here’s the code.

```
struct HTMLComponent: ExpressibleByStringLiteral, ExpressibleByStringInterpolation, CustomStringConvertible {
    struct StringInterpolation: StringInterpolationProtocol {
        // start with an empty string
        var output = ""

        // allocate enough space to hold twice the amount of literal text
        init(literalCapacity: Int, interpolationCount: Int) {
            output.reserveCapacity(literalCapacity * 2)
        }

        // a hard-coded piece of text – just add it
        mutating func appendLiteral(_ literal: String) {
            print("Appending \(literal)")
            output.append(literal)
        }

        // a Twitter username – add it as a link
        mutating func appendInterpolation(twitter: String) {
            print("Appending \(twitter)")
            output.append("<a href=\"https://twitter/\(twitter)\">@\(twitter)</a>")
        }

        // an email address – add it using mailto
        mutating func appendInterpolation(email: String) {
            print("Appending \(email)")
            output.append("<a href=\"mailto:\(email)\">\(email)</a>")
        }
    }

    // the finished text for this whole component
    let description: String

    // create an instance from a literal string
    init(stringLiteral value: String) {
        description = value
    }

    // create an instance from an interpolated string
    init(stringInterpolation: StringInterpolation) {
        description = stringInterpolation.output
    }
}
```

We can now create and use an instance of `HTMLComponent` using string interpolation like this:

```
let text: HTMLComponent = "You should follow me on Twitter \(twitter: "twostraws"), or you can email me at \(email: "paul@hackingwithswift.com")."
print(text)
```

Thanks to the `print()` calls that were scattered inside, you’ll see exactly how the string interpolation functionality works: you’ll see “Appending You should follow me on Twitter”, “Appending twostraws”, “Appending , or you can email me at “, “Appending paul@hackingwithswift.com”, and finally “Appending .” – each part triggers a method call, and is added to our string.

### Dynamically callable types

[SE-0216](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md) adds a new `@dynamicCallable` attribute to Swift, which brings with it the ability to mark a type as being directly callable. It’s syntactic sugar rather than any sort of compiler magic, effectively transforming this code:

```
let result = random(numberOfZeroes: 3)
```

Into this:

```
let result = random.dynamicallyCall(withKeywordArguments: ["numberOfZeroes": 3])
```

Previously I wrote about a [feature in Swift 4.2 called @dynamicMemberLookup](/articles/55/how-to-use-dynamic-member-lookup-in-swift). `@dynamicCallable` is the natural extension of `@dynamicMemberLookup`, and serves the same purpose: to make it easier for Swift code to work alongside dynamic languages such as Python and JavaScript.

To add this functionality to your own types, you need to add the `@dynamicCallable` attribute plus one or both of these methods:

```
func dynamicallyCall(withArguments args: [Int]) -> Double

func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Int>) -> Double
```

The first of those is used when you call the type without parameter labels (e.g. `a(b, c)`), and the second is used when you _do_ provide labels (e.g. `a(b: cat, c: dog)`).

`@dynamicCallable` is really flexible about which data types its methods accept and return, allowing you to benefit from all of Swift’s type safety while still having some wriggle room for advanced usage. So, for the first method (no parameter labels) you can use anything that conforms to `ExpressibleByArrayLiteral` such as arrays, array slices, and sets, and for the second method (with parameter labels) you can use anything that conforms to `ExpressibleByDictionaryLiteral` such as dictionaries and key value pairs.

*   **Note:** If you haven’t used `KeyValuePairs` before, now would be a good time to learn what they are because they are extremely useful with `@dynamicCallable`. Find out more here: [What are KeyValuePairs?](/example-code/language/what-are-keyvaluepairs)

As well as accepting a variety of inputs, you can also provide multiple overloads for a variety of outputs – one might return a string, one an integer, and so on. As long as Swift is able to resolve which one is used, you can mix and match all you want.

Let’s look at an example. First, here’s a `RandomNumberGenerator` struct that generates numbers between 0 and a certain maximum, depending on what input was passed in:

```
struct RandomNumberGenerator {
    func generate(numberOfZeroes: Int) -> Double {
        let maximum = pow(10, Double(numberOfZeroes))
        return Double.random(in: 0...maximum)
    }
}
```

To switch that over to `@dynamicCallable` we’d write something like this instead:

```
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

```
let random = RandomNumberGenerator()
let result = random(numberOfZeroes: 0)
```

If you had used `dynamicallyCall(withArguments:)` instead – or at the same time, because you can have them both a single type – then you’d write this:

```
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

```
func dynamicallyCallMethod(named: String, withKeywordArguments: KeyValuePairs<String, Int>)
```

If that became possible in future Swift versions it might open up some very interesting possibilities for test mocking.

In the meantime, `@dynamicCallable` is not likely to be widely popular, but it _is_ hugely important for a small number of people who want interactivity with Python, JavaScript, and other languages.

### Handling future enum cases

[SE-0192](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md) adds the ability to distinguish between enums that are fixed and enums that might change in the future.

One of Swift’s security features is that it requires all switch statements to be exhaustive – that they must cover all cases. While this works well from a safety perspective, it causes compatibility issues when new cases are added in the future: a system framework might send something different that you hadn’t catered for, or code you rely on might add a new case and cause your compile to break because your switch is no longer exhaustive.

With the `@unknown` attribute we can now distinguish between two subtly different scenarios: “this default case should be run for all other cases because I don’t want to handle them individually,” and “I want to handle all cases individually, but if anything comes up in the future use this rather than causing an error.”

Here’s an example enum:

```
enum PasswordError: Error {
    case short
    case obvious
    case simple
}
```

We could write code to handle each of those cases using a `switch` block:

```
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

```
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

```
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

```
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

```
let times = [
    "Hudson": "38",
    "Clarke": "42",
    "Robinson": "35",
    "Hartis": "DNF"
]
```

We can use `compactMapValues()` to create a new dictionary with names and times as an integer, with the one DNF person removed:

```
let finishers1 = times.compactMapValues { Int($0) }
```

Alternatively, you could just pass the `Int` initializer directly to `compactMapValues()`, like this:

```
let finishers2 = times.compactMapValues(Int.init)
```

You can also use `compactMapValues()` to unwrap optionals and discard nil values without performing any sort of transformation, like this:

```
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

```
let scores = [100, 80, 85]
let passCount = scores.count { $0 >= 85 }
```

And this counts how many names in an array start with “Terry”:

```
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
