> * 原文地址：[Pro Pattern-Matching in Swift](http://bignerdranch.com/blog/pro-pattern-matching-in-swift/)
> * 原文作者：[Nick Teissler](https://www.bignerdranch.com/about/the-team/nick-teissler)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/pro-pattern-matching-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/pro-pattern-matching-in-swift.md)
> * 译者：
> * 校对者：

# Pro Pattern-Matching in Swift

The switch statement is an indubitable strength of the Swift language. Behind the switch statement is Swift’s pattern-matching, which makes for more readable, safer code. It is possible to take the switch’s pattern-matching readability and power and apply it elsewhere in your code.

The [Swift language reference](https://docs.swift.org/swift-book/ReferenceManual/Patterns.html) specifies eight different varieties of patterns. It can be hard to know the right syntax to use in a pattern match expression. In a typical use-case you might need to know type information, to unwrap a variable, or to simply confirm an optional is non-nil. Using the right pattern, you can avoid awkward unwraps and unused variables.

There are two participants in a pattern match: the pattern and the value. The value is the expression that follows the `switch` keyword, or the `=` operator if the value is being tested outside a `switch` statement. The pattern is the expression that follows a `case` label. The pattern and value are evaluated against each other using rules of the Swift language. As of July 15th, 2018 the [reference](https://docs.swift.org/swift-book/ReferenceManual/Patterns.html) contains some errors about how and where patterns can be used in the prose, but these can be discovered with some experimentation.[1]

We’ll look at applying patterns in `if`, `guard`, and `while` statements, but before we do, let us warm up with some non-vanilla uses of the switch statement.

### Matching only non-nil Variables

If the value trying to be matched is possibly nil, we can use an _Optional Pattern_ to only match the value if it is non-nil and, as a bonus, unwrap it. This is especially useful when dealing with legacy (and some not-so-legacy) Objective-C methods and functions. As of Swift 4.2 with the [reimplementation of IUOs](https://swift.org/blog/iuo/) `!` will be a synonym for `?`. For Objective-C functions without [nullable annotations](https://developer.apple.com/swift/blog/?id=25), you may have to handle this behavior.

The example here is especially trivial as this new behavior can be unintuitive coming from Swift < 4.2. Take this Objective-C function:

```
- (NSString *)aLegacyObjcFunction {
    return @"I haven't been updated with modern obj-c annotations!";
}
```

The Swift signature will be: `func aLegacyObjcFunction() -> String!`, and in Swift 4.1, this function will compile:

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

In Swift 4.2, you’ll get an error: “Value of optional type ‘String?’ not unwrapped; did you mean to use ‘!’ or ‘?’?”. `case let output` is a simple variable-assignment pattern match. It will match the `String?` type returned by `aLegacyObjcFunction` without unwrapping the value. The unintuitive part is that `return aLegacyObjcFunction()` will compile because it skips the variable assignment (pattern match), and with it, the type inference so the returned type is a `String!` and treated as such by the compiler. We should handle this more gracefully, _especially_ if the Objective-C function in question actually can return `nil`.

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

This time, we are handling the optionality intentionally. Notice that we don’t have to use `if let` to unwrap the return value of `aLegacyObcFunction`. The nil pattern match `case let output?:` handles that for us; `output` is a `String`.

### Catching Custom Error Types with Precision

Pattern-matching can be extremely useful and expressive when catching custom error types. A common design pattern is to define custom error types with `enum`s. This works especially well in Swift, as it’s easy to attach associated values to enum cases to provide more detail about an error.

Here we use two flavors of the _Type-Casting Pattern_ as well as two flavors of the _Enumeration Case Pattern_ to handle any errors that may be thrown:

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

Above in each `catch`, we have matched and caught only as much information as we needed, and nothing extra. Now to move on from `switch` and see where else we can use pattern-matching.

### The One-Off Match

There are many times when you might want to do a one-off pattern match. Possibly a change should only be applied given a single enumeration value and you don’t care about the others. At that point, the beautifully readable switch statement suddenly becomes cumbersome boilerplate.

We can use `if case` to unpack a tuple value only if it is non-nil:

```
if case (_, let value?) = stringAndInt {
    print("The int value of the string is \(value)")
}
```

The above uses three patterns in one statement! At the top is a _Tuple Pattern_ containing an _Optional Pattern_ (not unlike the one above in **Matching a non-nil Variable**), and a sneaky _Wildcard Pattern_, the `_`. Had we used `switch stringAndInt { ... }`, the compiler would have forced us to handle all possible cases explicitly, or with a `default` label.

Alternatively, if a `guard case` suits your purposes better, there’s not much to change:

```
guard case (_, let value?) = stringAndInt else {
    print("We have no value, exiting early.")
    exit(0)
}
```

You can use patterns to define stopping conditions of `while` loops and `for-in` loops. This can be useful with ranges. An _Expression Pattern_ allows us to avoid the traditional `variable >= 0 && variable <= 10` construct[2]:

```
var guess: Int = 0

while case 0...10 = guess  {
    print("Guess a number")
    guess = Int(readLine()!)!
}
print("You guessed a number out of the range!")
```

In all of these examples, the pattern immediately follows the `case` label and the value comes after the `=`. The only time syntax departs from this is when there is an `is`, `as`, or `in` keyword in the expression. In those situations, the structure is the same if you think of those keywords as a substitute for the `=`. Remembering this, and with nudges from the compiler, you can use all 8 varieties of patterns without having to consult the language reference.

There is something unique about the `Range` matching _Expression Pattern_ above that we haven’t seen so far in previous examples: its pattern-matching implementation is not a built-in feature, at least not built-in to the compiler. The _Expression Pattern_ uses the Swift Standard Library [`~=` operator](https://developer.apple.com/documentation/swift/1539154?changes=_3). The `~=` operator is a free, generic function defined as:

```
func ~= <T>(a: T, b: T) -> Bool where T : Equatable
```

You can see the Swift Standard Library `Range` type [overrides this operator](https://developer.apple.com/documentation/swift/range/2428743?changes=_5) to provide a custom behavior that checks if the particular value is within the given range.

### Matching Regular Expressions

Let’s create a `Regex` type that implements the `~=` operator. It will be a paper-thin wrapper around [`NSRegularExpression`](https://developer.apple.com/documentation/foundation/nsregularexpression?changes=_9) that uses pattern-matching to make for more readable regex code, something we should always be interested in when working with the arcane regular expression.

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
    

There’s our `Regex` struct. It has a single `NSRegularExpression` property. It can be initialized as a string literal, with the consequence that if we fail to pass a valid regular expression, we’ll get a failure message and a match-all regex instead. Next, we implement the pattern-matching operator, nesting it in an extension so it’s clear where we want the operator to be used.

```
extension Regex {
    static func ~=(pattern: Regex, value: String) -> Bool {
        return pattern.match(value)
    }
}
```

We want this struct to be useful out of the box, so I’ll define two class constants that can handle some common regex validation needs. The email regex was borrowed from Matt Gallagher’s [_Cocoa with Love_](http://www.cocoawithlove.com/2009/06/verifying-that-string-is-email-address.html) article and checks email addresses as defined in [RFC 2822](https://www.ietf.org/rfc/rfc2822.txt).

If you’re working with regular expressions in Swift, you can’t simply copy-pasta from your choice of Stack Overflow Regex posts. Swift strings define escape sequences like the newline (`\n`), tab (`\t`), and unicode scalars (`\u{1F4A9}`). These clash with the syntax of regular expressions which is heavy with backslashes and all types of brackets. Other languages like python have convenient raw string syntax. A raw string will take every character literally and does not parse escape sequences, so regular expressions can be inserted in their “pure” form. In Swift, any lone backslashes in a string indicate an escape sequence, so for the compiler to accept most regular expressions, you will need to escape the escape sequences, as well as a few other special characters. There was an [attempt](https://forums.swift.org/t/se-0200-raw-mode-string-literals/11048/178) to bring raw strings to Swift that fizzled out. It’s possible that as Swift continues to become a multi-platform, multi-purpose language, interest will be renewed in this feature. Until then, the already complex email-matching regular expression, becomes this ascii art monster:

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

We can use a simpler expression to match phone numbers, borrowed from [Stack Overflow](https://stackoverflow.com/questions/16699007/regular-expression-to-match-standard-10-digit-phone-number) and double escaped as previously described:

```
static let phone: Regex = "^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}$"
```

Now we can identify phone numbers or emails with our handy, readable pattern syntax:

    let input = Bool.random() ? "nerd@bignerdranch.com" : "(770) 817-6373"
    switch input {
        case Regex.email:
            print("Send \(input) and email!")
        case Regex.phone:
            print("Give Big Nerd Ranch a call at \(input)")
        default:
            print("An unknown format.")
    }
    

You might be wondering why you don’t see the `~=` operator above. It’s an implementation detail of the `Expression Pattern` and is used implicitly.

### Remember the Basics!

With all these fancy patterns, we shouldn’t forget ways we can use the classic switch. When the pattern-matching `~=` operator is not defined, Swift falls back to using the `==` operator in switch statements. To reiterate, we are no longer in the domain of pattern-matching.

Below is an example. The switch statement here is being used as a [demultiplexer](https://www.electronicshub.org/demultiplexerdemux/) for delegate callbacks. It switches over the `textField` variable, a subclass of `NSObject`. Equality is therefore defined as identity comparison, which will check if the pointer values of the two variables are equal. As an example, take an object which serves as the delegate for three `UITextField`s. Each text field needs to validate its text in a different way. The delegate will receive the same callback for each text field when a user edits text

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

And can validate each text field differently.

### Concluding

We looked at a few of the patterns available in Swift and examined the structure of pattern-matching syntax. With this knowledge, all of the 8 varieties of patterns are available to use! Patterns come with many benefits and they are an indispensable part of any Swift developer’s toolbox. There is still content this post didn’t cover, like the [niceties of compiler checked exhaustive logic](https://nshipster.com/never/#eliminating-impossible-states-in-generic-types) and patterns combined with `where` clauses.

Thank you to Erica Sadun for introducing me to the `guard case` syntax in her blog post, [_Afternoon Whoa_](https://ericasadun.com/2016/03/15/afternoon-whoa-swifts-guard-case/), which inspired this one.

All of the examples for this post can be found in this [gist](https://gist.github.com/nteissler/a9d2b00beddcc309445ebebf1a373b49). The code can be run as a playground or picked through to suit your needs.

[1] The guide claims for enums with associated values, “the corresponding enumeration case pattern must specify a tuple pattern that contains one element for each associated value.” Just including the enum case without any associated values compiles and matches assuming you don’t need the associated value.

Another small correction is that the custom expression operator (~=) may “appear only in switch statement case labels”. Above, we use it in an `if` statement as well. The [language grammar](https://docs.swift.org/swift-book/ReferenceManual/Statements.html#//appleref/swift/grammar/condition-list) specifies both of the above usages correctly, and the error only exists in the prose.

[2] The `readLine` function won’t work in a playground. If you want to run this example, try it from a macOS command-line application.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
