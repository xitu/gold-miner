> * 原文地址：[My Least Favorite Thing About Swift](http://khanlou.com/2016/08/my-least-favorite-thing-about-swift/)
* 原文作者：[Soroush Khanlou](http://www.twitter.com/khanlou)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：




There’s a lot to love about Swift, which I’ve written about [before](http://khanlou.com/2016/05/six-months-of-swift/). Today, however, I want to write about where the language falls short. This is a complicated issue with lots of nuance, so I’ll go into a couple of examples of where I think the language gets it right, where it gets it wrong, and what the future holds.

### Defining within the language vs without

Take a look at Ruby.

Ruby’s `attr_accessor` is a way to define a setter and a getter for an instance variable. You use it like so:



    class Person
    	attr_accessor :first_name, :last_name
    end



At first blush, this looks like a language feature, like Swift’s `let` and `var` property declarations. But Ruby’s functions can be called without parentheses, and this is just a function defined in the class scope (which we’d call a static function in Swift):



    def self.attr_accessor(*names)
      names.each do |name|
        define_method(name) {instance_variable_get("@#{name}")} # This is the getter
        define_method("#{name}=") {|arg| instance_variable_set("@#{name}", arg)} # This is the setter
      end
    end



If you can’t read Ruby, that’s okay. It uses a function called `define_method` to create a getter and setter for the keys that you pass in. In Ruby, `@first_name` means the instance variable named `first_name`.

This is one of the reasons I love Ruby’s language design — they first create the meta-tools to create useful language features, and then they use those tools to implement the language features that they want. [Yehuda Katz explores](http://yehudakatz.com/2010/02/07/the-building-blocks-of-ruby/) how Ruby applies this idea to its blocks. Because Ruby’s language features are written with the same tools and in the same language that users have access to, users can also write features similar in style and scope to the ones that define the language.

### Optionals

This brings us to Swift. One of Swift’s core features is its `Optional` type. This allows users to define whether a certain variable can be null or not. It’s defined within the system with an enum:



    enum Optional {
    	case Some(WrappedType)
    	case None
    }



Like `attr_accessor`, this feature uses a Swift language construct to define itself. This is good, because it means users can create similar things with different semantic meanings, such as this fictional `RemoteLoading` type:



    enum RemoteLoading {
    	case Loaded(WrappedType)
    	case Pending
    }



It has the exact same shape as `Optional` but carries different meanings. (Arkadiusz Holko takes this enum a step further [in a great blog post](http://holko.pl/2016/06/09/data-state-as-an-enum/).)

However, the Swift compiler _knows_ about the `Optional` type in a way it doesn’t know about `RemoteLoading`, and it lets you do special things. Take a look at these identical declarations:



    let name: Optional = .None
    let name: Optional = nil
    let name: String? = nil
    var name: String?



Let’s unpack them. The first one is the full expression (with type inference). You could declare your own `RemoteLoading` property with the same syntax. The second uses the `NilLiteralConvertible` protocol to define what happens when you set that value to the literal `nil`. While this piece of syntax is accessible for your own types, it doesn’t seem quite right to use it with `RemoteLoading`. This is the first of a few language features that are designed to make Swift feel more comfortable to writers of C family languages, which we’ll come back to in a moment.

The third and fourth declarations are where the compiler starts using its knowledge of the `Optional` type to allow us to write special code that we couldn’t write with other types. The third one uses a shorthand for `Optional` where it can be written as `T?`. This is called _syntactic sugar_, where the language lets you write common bits of code in simpler ways. The final line is another piece of syntactic sugar: if you declare an optional type, but don’t give it a value, the compiler will infer that its value should be `.None`/`nil` (but only if it’s a `var` reference).

You can’t access these last two optimizations with your own types. The language’s `Optional` type, which started out awesomely, by being defined within the existing constructs of language, ends up with special-cased compiler exceptions that only this type can access.

### Families

Swift is defined to “feel at home in the C family of languages”. This means having for loops and if statements.

Swift’s `for..in` construct is special. Anything that conforms to `SequenceType` can be iterated over in a `for..in` loop. That means I can define my own types, declare that they’re sequential, and use them in `for..in` loops.

Although `if` statements and `while` loops [currently work this way in Swift 2.2](http://khanlou.com/2016/06/falsiness-in-swift/) with `BooleanType`, this functionality has been removed in Swift 3\. I can’t define my own boolean types to use within `if` statements like I can with `for..in`.

These are two fundamentally different approaches to a language feature, and they define a duality in Swift. The first creates a meta-tool that can be used to define a language feature; the other creates a explicit and concrete connection between the feature of the language and the types of that language.

You could argue that types conforming to `SequenceType` are more useful than types conforming to `BooleanType`. Swift 3 fully removes this feature, though, so you have to fully commit: you have to argue that `BooleanType` is so useless that it should be completely disallowed.

Being able to conform my own types `SequenceType` shows that the language trusts me to make my own useful abstractions (with no loss of safety or strictness!) on the same level as its own standard library.

### Operations

Operators in Swift are also worth examining. Syntax exists within the language to define operators, and all the arithmetic operators are defined within that syntax. Users are then free to define their own operators, useful for if they create their [own BigInt type](https://github.com/lorentey/BigInt) and want to use standard arithmetic operators with it.

While the `+` operator is defined within the language, the ternary operator `?:` isn’t. Command-clicking on the `+` operator jumps you to its definition. Command-clicking on either the `?` or the `:` of the ternary operator yields nothing. If you want to use a sole question mark or colon as an operator for your code, you can’t. Note that I’m _not_ saying that it would be a good idea to use a colon operator in your code; all I’m saying is that this operator has been special-cased, hard-coded into the compiler, to add familiarity to those weaned on C.

In each of these three cases, we’ve compared two things: the first, a useful language syntax which the standard library uses to implement features; and the second, a special-case which privileges standard library code over consumer code.

The best kinds of syntax and syntactic sugar can be tapped into by the writers of the language, with their own types and their own systems. Swift sometimes handles this with protocols like `NilLiteralConvertible`, `SequenceType`, and the soon-defunct `BooleanType`. The way that `var name: String?` can infer its own default (`.None`) crucially _isn’t_ like this, and therefore is a less powerful form of syntactic sugar.

I think it’s also worth noting that even though I love Ruby’s syntax, two places where it doesn’t have very much flexibility are operators and falsiness. You can define your own implementations for the Ruby’s existing operators, but you can’t add new ones, and the precedences are fixed. Swift is _more_ flexible in this regard. And, of course, it was more flexible with respect to defining falsiness as well, until Swift 3.

### Errors

In the same way that Swift’s Optional type is a shade of C’s nullability, Swift’s error handling resembles a shade of C’s exception handling. Swift’s error handling introduces several new keywords: `do`, `try`, `throw`, `throws`, `rethrows`, and `catch`.

Functions and methods marked with `throws` can `return` a value or `throw` an `ErrorType`. Thrown errors are land in `catch` blocks. Under the hood, you can imagine Swift rewriting the return type for the function



    func doThing(with: Property) throws -> Value


as


    func doThing(withProperty) -> _Result



with some internal `_Result` type (like [`antitypical/Result`](https://github.com/antitypical/Result)) that represents potential success or failure. (The reality is this `_Result` type isn’t explicitly defined, but rather [implicitly handled in the bowels of the compiler](https://marc.ttias.be/swift-evolution/2016-08/msg00322.php). It doesn’t make much of a difference for our example.) At the call site, this is unpacked into its successful value, which is passed through the `try` statement, and the error, which jumps execution to the `catch` block.

Compare this to the previous examples, where useful features are defined within the language, and then syntax (in the case of operators or `SequenceType`) and syntactic sugar (in the case of `Optional`) are added _on top_ of them to make the code look the way we expect it. In contrast, the Swift’s error handling doesn’t expose its internal `_Result` model, so users can’t use it or build on it.

Some cases for error handling works great with Swift’s model, like [Brad Larson’s code for moving a robot arm](http://www.sunsetlakesoftware.com/2015/06/12/swift-2-error-handling-practice) or [my JSON parsing code](http://khanlou.com/2016/04/decoding-json/). Other code might work better with a `Result` type and `flatMap`.

Still other code might rely on asynchronicity and want to pass a `Result` type to a completion block. Apple’s solution only works in certain cases, and giving users of the language more flexibility in the error model would help cover this distance. `Result` is great, because it’s flexible enough to build multiple things on top of it. The `try`/`catch` syntax is weak, because it’s very rigid and can only be used in one way.

### The Future

Swift 4 promises language features for asynchronous work soon. It’s not clear how these features will be implemented yet, but Chris Lattner has written about the road to the Swift 4:

> First class concurrency: Actors, async/await, atomicity, memory model, and related topics.

Async/await is my leading theory for what asynchronicity in Swift will look like. For the uninitiated, async/await involves declaring when functions are `async`, and using the `await` keyword to wait for them to finish. Take this simple example from C#:



    async Task GetIntAsync()
    {
        return new Task(() =>
        {
            Thread.Sleep(10000);
            return 1
        });
    }

    async Task MyMethodAsync()
    {
        int result = await GetIntAsync();
        Console.WriteLine(result);
    }



The first function, `GetIntAsync` returns a tasks that waits for some amount of time, and then returns a value. Because it returns a `Task`, it is marked as `async`. The second function, `MyMethodAsync`, calls the first, using the keyword `await`. This signals to the system that it can do other work until the `Task` from `GetIntAsync` completes. Once it completes, control is restored to the function, and it can write to the console.

Judging from this example, `Task` objects in C# seem a lot like [promises](http://khanlou.com/2016/08/promises-in-swift/). Also, any function that uses the `await` keyword must itself be declared as `async`. The compiler can enforce this guarantee. This solution mirrors Swift’s error model: functions that throw must be caught, and if they don’t, they must be marked with `throws` as well.

It also has the same flaws as the error model. Rather than being mere syntactic sugar over a more useful tool, a brand new construct and a bunch of keywords are added. This construct is partially dependent on types within defined in the standard library and partially dependent on syntax baked into the compiler.

### Properties

Property behaviors are another big feature that might come in Swift 4\. There is a [rejected proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0030-property-behavior-decls.md) for property behaviors, which is set to be examined more closely for Swift 4.

Property behaviors let you attach a behavior like `lazy` to a property. The `lazy` property, for example, would only set up a value the first time it’s accessed. While you currently can use this particular behavior, it’s hard-coded into the Swift compiler. Property behaviors as proposed would allow the facility for the standard library to implement some behaviors and for users to define others entirely.

Perhaps this is the best of all worlds. Start with a feature that’s hard-coded in the compiler, and after the feature has gained some prominence, create a more generic framework which lets you define that feature through the language itself. At that point, any writer of Swift can create similar functionality, tweaked precisely to suit their own requirements.

If Swift’s error model followed that same path, Swift’s standard library might expose a `Result` type, and any function returning a `Result` would be able to use the `do`/`try`/`catch` syntax when it is most useful (like for many parallel, synchronous actions that can each fail). For error needs that don’t fit in to the currently available syntax, like async errors, users would have a common `Result` type that they can use. If the `Result` requires lots of chaining, users can `flatMap`.

Async/await could work the same way. Define a `Promise` or `Task` protocol, and things that conform to that would be `await`-able. `then` or `flatMap` would be available on that type, and depending on user’s needs, they could use the language feature at as high or as low of a level as needed.

### Metaprogramming

I’d like to close with a note on metaprogramming. I’ve written extensively [about metaprogramming in Objective-C](http://genius.com/Soroush-khanlou-metaprogramming-isnt-a-scary-word-not-even-in-objective-c-annotated), but it’s similar to what we’re working with here. The lines between code and metacode are blurry. The code in the Swift compiler is the meta code, and Swift itself is the code. If defining an implementation of an operator (as you do in Ruby) is just code, then defining a whole new operator seems like it has to be metacode.

As a protocol-oriented language, Swift is uniquely set up to let us tap into the syntax of the language, as we do with `BooleanType` and `SequenceType`. I’d love to see these capacities expanded.

The line where keywords stop and syntax starts, or where syntax stops and syntactic sugar starts, isn’t very well defined, but the engineers who write code in the language should have the ability to work with the same tools as those who develop the standard library.



