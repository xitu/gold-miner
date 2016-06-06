>* 原文链接 : [Compile Time vs. Run Time Type Checking in Swift](http://blog.benjamin-encz.de/post/compile-time-vs-runtime-type-checking-swift/)
* 原文作者 : [Benjamin Encz](https://twitter.com/benjaminencz)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


At some point, when learning how to use Swift’s type system, it is important to understand that Swift (like many other languages) has two different forms of type checking: static and dynamic. Today I want to briefly discuss the difference between them and why headaches might arise when we try to combine them.

Static type checking occurs at compile time and dynamic type checking happens at run time. Each of these two stages come with a different, partially incompatible, toolset.

## Compile Time Type Checking

Compile time type checking (or static type checking) operates on the Swift source code. The Swift compiler looks at explicitly stated and inferred types and ensures correctness of our type constraints.

Here’s a trivial example of static type checking:

    let text: String = ""
    // Compile Error: Cannot convert value of 
    // type 'String' to specified type 'Int'
    let number: Int = text

Based on the source code the type checker can decide that `text` is not of type `Int` - therefore it will raise a compile error.

Swift’s static type checker can do a lot more powerful things, e.g. verifying generic constraints:

    protocol HasName {}
    protocol HumanType {}

    struct User: HasName, HumanType { }
    struct Visitor: HasName, HumanType { }
    struct Car: HasName {}

    // Require a type that is both human and provides a name
    func printHumanName<T: protocol<HumanType, HasName>>(thing: T) {
        // ...
    }

    // Compiles fine:
    printHumanName(User())
    // Compiles fine:
    printHumanName(Visitor())
    // Compile Error: cannot invoke 'printHumanName' with an 
    // argument list of type '(Car)'
    printHumanName(Car())

In this example, again, all of the type checking occurs at compile time, solely based on the source code. The swift compiler can verify which function calls provide arguments that match the generic constraints of the `printHumanName` function; and for ones that don’t it can emit a compile error.

Since Swift’s static type system offers these powerful tools we try to verify as much as possible at compile time. However, in same cases run time type verification is necessary.

## Run Time Type Checking

In some unfortunate cases relying on static type checking is not possible. The most common example is reading data from an outside resource (network, database, etc.). In such cases the data and thus the type information is not part of the source code, therefore we cannot prove to the static type checker that our data has a specific type (since the static type checker can only operate on type information it can extract from our source code).

This means instead of being able to _define_ a type statically, we need to _verify_ a type dynamically at run time.

When checking types at run time we rely on the type metadata stored within the memory of all Swift instances). The only tools we have available at this stage are the `is` and `as` keywords that use that metadata to confirm whether or not the instance is of a certain type or conforms to a certain protocol.

This is what all the different Swift JSON mapping libraries do - they provide a convenient API for dynamically casting an unknown type to one that matches the type of a specified variable.

In many scenarios dynamic type checking enables us to integrate types that are unknown at compile time with our statically checked Swift code:

    func takesHuman(human: HumanType) {}

    var unknownData: Any = User()

    if let unknownData = unknownData as? HumanType {
        takesHuman(unknownData)
    }

All we need to do in order to call the function with `unknownData` is to cast it to the argument type of the function.

However, if we try to use this approach to call a function that defines arguments as generic constraints, we run into issues…

## Combining Dynamic and Static Type Checking

Continuing the earlier `printHumanName` example, let’s assume we have received data from a network request, and we need to call the `printHumanName` method - if the dynamically detected type allows us to do that.

We know that our type needs to conform to two different protocols in order to be eligible as argument for the `printHumanName` function. So let’s check that requirement dynamically:

    var unknownData: Any = User()

    if let unknownData = unknownData as? protocol<HumanType, HasName> {
        // Compile Error: cannot invoke 'printHumanName' 
        // with an argument list of type '(protocol<HasName, HumanType>)'
        printHumanName(unknownData)
    }

The dynamic type check in the above example actually works correctly. The body of the `if let` block is only executed for types that conform to our two expected protocols. However, we cannot convey this to the compiler. The compiler expects a _concrete_ type (one that has a fully specified type at compile time) that conforms to `HumanType` and `HasName`. All we can offer is a dynamically verified type.

As of Swift 2.2, there is no way to get this to compile. At the end of this post I will briefly touch on which changes to Swift would likely be necessary to make this approach work.

For now, we need a workaround.

### Workarounds

In the past I’ve used one of these two approaches:

*   Cast `unknowndData` to a concrete type instead of casting it to a protocol
*   Provide a second implementation of `printHumanName` without generic constraints

The concrete type solution would look something like this:

    if let user = unknownData as? User {
        printHumanName(user)
    } else if let visitor = unknownData as? Visitor {
        printHumanName(visitor)
    }

Not beautiful; but it might the best possible solution in some cases.

A solution that involves providing a second implementation of `printHumanName` might look like this (though there are many other possible solutions):

    func _printHumanName(thing: Any) {
        if let hasName = thing as? HasName where thing is HumanType {
            // Put implementation code here
            // Or call a third function that is shared between
            // both implementations of `printHumanName`
        } else {
            fatalError("Provided Incorrect Type")
        }
    }

    _printHumanName(unknownData)

In this second solution we have substituted the compile time constraints for a run time check. We cast the `Any` type to `HasName`, that allows us to access the relevant information for printing a name, and we include an `is` check to verify that the type is one that conforms to `HumanType`. We have established a dynamic type check that is equivalent to our generic constraint.

This way we have offered a second implementation that will run code dynamically, if an arbitrary type matches our protocol requirements. In practice I would extract the actual functionality of this function into a third function that gets called from both `printHumanName` and `_printHumanName` - that way we can avoid duplicate code.

The solution of the “type erased” function that accept an `Any` argument isn’t really nice either; but in practice I have used similar approaches in cases where other code guarantees that the function will be called with the correct type, but there wasn’t a way of expressing that within Swift’s type system.

## Conclusion

The examples above are extremely simplified, but I hope they demonstrate the issues that can arise from differences in compile time and run time type checking. The key takeaways are:

*   The static type checker runs at compile time, operates on the source code and uses type annotations and constraints for type checking
*   The dynamic type checker uses run time information and casting for type checking
*   **We cannot cast a an argument dynamically, in order call a function that has generic constraints**.

Is there potential for adding support for this to Swift? I think we would need the ability to dynamically create & use a constrained metatype. One could imagine a syntax that looks somewhat like this:

    if let <T: HumanType, HasName> value = unknownData as? T {
    	printHumanName(value)
    }

I know too little about the Swift compiler to know if this is feasible at all. I would assume that the relative cost of implementing this is huge, compared to the benefits it would provide to a very small part of the average Swift codebase.

However, according to this [Stack Overflow answer](http://stackoverflow.com/questions/28124684/swift-check-if-generic-type-conforms-to-protocol) by [David Smith](https://twitter.com/Catfish_Man), Swift currently checks generic constraints at run time (unless the compiler generates specialized copies of a function for performance optimizations). This means the information about generic constraints is still available at run time and, at least in theory, the idea of dynamically created constrained metatypes might be possible.

For now it is helpful to understand the limitations of mixing static and dynamic type checking and to be aware of the possible workarounds.

I cannot finish this post without a fabulous quote from [@AirspeedSwift](https://twitter.com/AirspeedSwift):

