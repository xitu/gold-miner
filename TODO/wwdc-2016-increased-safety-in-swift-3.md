>* 原文链接 : [WWDC 2016: Increased Safety in Swift 3.0](https://www.bignerdranch.com/blog/wwdc-2016-increased-safety-in-swift-3/)
* 原文作者 : [
Matt Mathias](https://www.bignerdranch.com/about-us/nerds/matt-mathias/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zheaoli](https://github.com/Zheaoli)
* 校对者:


在 **Swift** 发布之后，**Swift** 的开发者一直在强调，安全性与可选择类型是 **Swift** 最为重要的特性之一。他们提供了一种 **nil** 的代理机制，要求在将 **nil** 和已经明确实例化的对象共同使用。

可选择类型主要以下两种:

1.  `Optional`
2.  `ImplicitlyUnwrappedOptional`

第一种做法是一种安全的做法：它要求开发者对使用可选择类型的变量进行拆包处理。第二种做法是一种不安全的做法：开发者在不对使用可选择类型的变量拆包的情况下直接访问其的值。比如，如果在变量值为 **nil** 的时候，使用 **ImplicitlyUnwrappedOptional** 可能会导致一些异常。

下面将展示一个关于这个问题的例子：

~~~Swift

    let x: Int! = nil
    print(x) // Crash! `x` is nil!

~~~

在 **Swift3.0** 中，苹果改进了 **ImplicitlyUnwrappedOptional** ，使其相对于以前变得更为安全。这里我们不禁想问，苹果到底在 **Swift3.0** 对 **ImplicitlyUnwrappedOptional** 做了哪些改进，从而使 **Swift** 变得更为安全了呢。答案在于，苹果在编译器对于 **ImplicitlyUnwrappedOptional** 进行类型推导的过程中进行了优化。

## 在 **Swift 2.x** 中的使用方式

让我们来通过一个例子来理解这里面的变化。


~~~Swift
    struct Person {
        let firstName: String
        let lastName: String

        init!(firstName: String, lastName: String) {
            guard !firstName.isEmpty && !lastName.isEmpty else {
                return nil
            }
            self.firstName = firstName
            self.lastName = lastName
        }
    }
~~~


这里我们创建了一个初始化过程有缺陷的结构体 **Person**。如果我们在初始化中不给实例提供 **first name** 和 **last name** 的值的话，那么初始化将会失败。

The initializer is declared with a `!` and not a `?`: `init!(firstName: String, lastName: String)`. We use `init!` here simply to make a point of how `ImplicitlyUnwrappedOptional`s work in Swift 2.x vs. Swift 3.0\. `init!` should be used sparingly regardless of the version of Swift you are using. Generally speaking, you’ll want to use `init!` when you want accesses to the resulting instance to lead to a crash if the instance is nil.

In Swift 2.x, this initializer would yield an `ImplicitlyUnwrappedOptional<Person>`. If the initializer failed, then accessing the underlying `Person` instance would generate a crash.

For example, in Swift 2.x the following would crash:


~~~Swift
    // Swift 2.x

    let nilPerson = Person(firstName: "", lastName: "Mathias")
    nilPerson.firstName // Crash!

~~~

Notice that we don’t have to use optional binding or chaining to try to access a value on `nilPerson` because it was implicitly unwrapped by the initializer.

## The New Way: Swift 3.0

Things are different with Swift 3.0\. The `!` in `init!` indicates that the initialization process can fail, and if it doesn’t, that the resulting instance may be forced (i.e., implicitly unwrapped). Unlike in Swift 2.x, instances resulting from `init!` are `Optional`s and not `ImplicitlyUnwrappedOptional`s. That means you will have to employ optional binding or chaining to access the underlying value.

~~~Swift

    // Swift 3.0

    let nilPerson = Person(firstName: "", lastName: "Mathias")
    nilPerson?.firstName

~~~

In this reprise of the example above, `nilPerson` is now an `Optional<Person>`. Thus, `nilPerson` needs to be unwrapped if we want to access its value. The usual machinery for optional unwrapping is appropriate here.

## Safety and Type Inference

This change may feel unintuitive. Why is the initializer, which was declared with `init!`, creating a regular `Optional`? Doesn’t that `!` at the end of `init` mean that it should create an `ImplicitlyUnwrappedOptional`?

The answer depends upon the relationship between being safe and being declarative. Remember that the code above (namely: `let nilPerson = Person(firstName: "", lastName: "Mathias")`) relied upon the compiler to infer the type of `nilPerson`.

In Swift 2.x, the compiler would infer `nilPerson` to be `ImplicitlyUnwrappedOptional<Person>`. We got used to this, and it made some sense. After all, the initializer at play above was declared with `init!`.

Nonetheless, this isn’t quite safe. We never explicitly declared that `nilPerson` should be an `ImplicitlyUnwrappedOptional`. And it’s not great that the compiler inferred unsafe type information.

Swift 3.0 solves this problem by treating `ImplicitlyUnwrappedOptional`s as `Optional` unless we explicitly declare that we want an `ImplicitlyUnwrappedOptional`.

## Curtailing the Propagation of `ImplicitlyUnwrappedOptional`

The beauty of this change is that it curtails the propagation of implicitly unwrapped optionals. Given our definition for `Person` above, consider what we would expect in Swift 2.x code:

~~~Swift

    // Swift 2.x

    let matt = Person(firstName: "Matt", lastName: "Mathias")
    matt.firstName // `matt` is `ImplicitlyUnwrappedOptional<person>`; we can access `firstName` directly</person>
    let anotherMatt = matt // `anotherMatt` is also `ImplicitlyUnwrappedOptional<person>`</person>

~~~

`anotherMatt` is created with the exact same type information as `matt`. You may have expected that to be the case, but it isn’t necessarily desirable. The `ImplicitlyUnwrappedOptional` has propagated to another instance in our code base. There is yet another line of potentially unsafe code that we have to be careful with.

For example, what if there were something asynchronous about the code above (a stretch, I know…)?


~~~Swift
    // Swift 2.x

    let matt = Person(firstName: "Matt", lastName: "Mathias")
    matt.firstName // `matt` is `ImplicitlyUnwrappedOptional<person>`, and so we can access `firstName` directly</person>
    ... // Stuff happens; time passes; code executes; `matt` is set to nil
    let anotherMatt = matt // `anotherMatt` has the same type: `ImplicitlyUnwrappedOptional<person>`</person>

~~~

In this contrived example, `anotherMatt` is nil, which means any direct access to its underlying value will lead to a crash. But this sort of access is exactly what `ImplicitlyUnwrappedOptional` encourages. Wouldn’t it be better if `anotherMatt`’s type was `Optional<Person>`?

That is exactly the case in Swift 3.0!

~~~Swift

    // Swift 3.0

    let matt = Person(firstName: "Matt", lastName: "Mathias")
    matt?.firstName // `matt` is `Optional<person>`</person>
    let anotherMatt = matt // `anotherMatt` is also `Optional<person>`</person>

~~~

Since we do not explicitly declare that we want an `ImplicitlyUnwrappedOptional`, the compiler infers the safer `Optional` type.

## Type Inference Should be Safe

The main benefit in the change is that type inference no longer automatically makes our code less safe. If we choose to not be safe, then we should have to be explicit about it. The compiler should not make that choice for us.

If we want to use an `ImplicitlyUnwrappedOptional` for whatever reason, then we still can. We just have to explicitly declare that we want to be unsafe.

~~~Swift
    // Swift 3.0

    let runningWithScissors: Person! = Person(firstName: "Edward", lastName: "") // Must explicitly declare Person!
    let safeAgain = runningWithScissors // What's the type here?
~~~


`runningWithScissors` is nil because the initializer was given an empty `String` for `lastName`.

Notice that we declared `runningWithScissors` to be an `ImplicitlyUnwrappedOptional<Person>`. If we want to run through the house with scissors in both hands, then Swift will let us. But Swift wants us to be explicit about it; we must specifically declare that we know we want an `ImplicitlyUnwrappedOptional`.

Thankfully, however, the compiler does not infer `safeAgain` to be an `ImplicitlyUnwrappedOptional`. Instead, the compiler dutifully hands us a very safe `Optional<Person>`. Swift 3.0 seeks to curtail the unwitting propagation of unsafe code by default.

## The Future

`ImplicitlyUnwrappedOptional` now behaves more similarly to the intent behind its purpose: it exists to facilitate how we interact with APIs for whom nullability is meaningful or the return type cannot be known. Both of these are often true in Objective-C, which Swift needs in order to do work on macOS or iOS.

But pure Swift seeks to eschew these problems. Thanks to the changes to `ImplicitlyUnwrappedOptional`, we are now in an even better position to transcend them. Imagine: a future without `ImplicitlyUnwrappedOptional`s.

## Further Information

If you’re curious to read more, then see [this proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0054-abolish-iuo.md) for further information. You’ll see how the proposal’s authors thought through this issue, and get a little more detail on the change. There is also a link to a thread where the community discussed the proposal.
