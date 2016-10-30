>* 原文链接 : [WWDC 2016: Increased Safety in Swift 3.0](https://www.bignerdranch.com/blog/wwdc-2016-increased-safety-in-swift-3/)
* 原文作者 : [
Matt Mathias](https://www.bignerdranch.com/about-us/nerds/matt-mathias/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zheaoli](https://github.com/Zheaoli)
* 校对者: [llp0574](https://github.com/llp0574), [thanksdanny](https://github.com/thanksdanny)

# WWDC 2016：更加安全的 Swift 3.0 

在 **Swift** 发布之后，**Swift** 的开发者一直在强调，安全性与可选择类型是 **Swift** 最为重要的特性之一。他们提供了一种'nil'的表示机制，并要求有一个明确的语法在可能为'nil'的实例上使用。

可选择类型主要以下两种:

1.  `Optional`
2.  `ImplicitlyUnwrappedOptional`

第一种做法是一种安全的做法：它要求我们去拆解可选类型变量是为了访问基础值。第二种做法是一种不安全的做法：我们可在不拆解可选择类型变量的情况下直接访问其底层值。比如，如果在变量值为 `nil` 的时候，使用 `ImplicitlyUnwrappedOptional` 可能会导致一些异常。

下面将展示一个关于这个问题的例子：


~~~Swift

    let x: Int! = nil
    print(x) // Crash! `x` is nil!

~~~

在 **Swift 3.0** 中，苹果改进了 `ImplicitlyUnwrappedOptional` 的实现，使其相对于以前变得更为安全。这里我们不禁想问，苹果到底在 **Swift 3.0** 对 `ImplicitlyUnwrappedOptional` 做了哪些改进，从而使 **Swift** 变得更为安全了呢。答案在于，苹果在编译器对于 `ImplicitlyUnwrappedOptional` 进行类型推导的过程中进行了优化。

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


这里我们创建了一个初始化方法有缺陷的结构体 `Person` 。如果我们在初始化中不给实例提供 `first name` 和 `last name` 的值的话，那么初始化将会失败。

在这里 `init!(firstName: String, lastName: String)` ，我们通过使用 `!` 而不是 `?` 来进行初始化的。不同于 **Swift 3.0**，在 **Swift 2.x** 中，我们用过利用 `init!` 来使用 `ImplicitlyUnwrappedOptional` 。不管我们所使用的 `Swift` 版本如何，我们应该谨慎的使用 `init!`。一般而言，如果你能允许在引用生成的为nil的实例时所产生的异常，那么你可以使用 `init!` 。因为如果对应的实例为 `nil` 的时候，你使用 `init!` 会导致程序的崩溃。

在 '.*' 中，这个初始化方法将会生成一个 `ImplicitlyUnwrappedOptional<Person>` 。如果初始化失败，所有基于 `Person` 的实例将会产生异常。

比如，在 **Swift 2.x** 里，下面这段代码在运行时将崩溃。


~~~Swift
    // Swift 2.x

    let nilPerson = Person(firstName: "", lastName: "Mathias")
    nilPerson.firstName // Crash!

~~~

请注意，由于在初始化器中存在着隐式解包，因此我们没有必要使用类型绑定（译者注1： `optional binding` ）或者是自判断链接（译者注2： `optional chaining` ）来保证 `nilPerson` 能被正常的使用。

## 在 **Swift 3.0** 里的新姿势

在 **Swift 3.0** 中事情发生了一点微小的变化。在 `init!` 中的 `!` 表示初始化可能会失败，如果成功进行了初始化，那么生成的实例将被强制隐式拆包。不同于 **Swift 2.x** ，`init!` 所生成的实例是 `optional` 而不是 `ImplicitlyUnwrappedOptional` 。这意味着你需要针对不同的基础值对实例进行类型绑定或者是自判断链接处理。

~~~Swift

    // Swift 3.0

    let nilPerson = Person(firstName: "", lastName: "Mathias")
    nilPerson?.firstName

~~~

在上面这个示例中，`nilPerson` 是一个 `Optional<Person>` 类型的实例。这意味着如果你想正常的访问里面的值，你需要对 `nilPerson` 进行拆包处理。这种情况下，手动拆包是个非常好的选择。

## 安全的类型声明

这种变化可能会令人疑惑。为什么使用的 `init!` 的初始化会会生成 `Optional` 类型的实例？不是说在 `init!` 中的 `!` 表示生成 `ImplicitlyUnwrappedOptional` 么？

答案是安全性与声明之间的依赖关系。在上面这段代码里（ `let nilPerson = Person(firstName: "", lastName: "Mathias")` ）将依靠编译器对 `nilPerson` 的类型进行推断。

在 **Swift 2.x** 中，编译器将会把 `nilPerson` 作为 `ImplicitlyUnwrappedOptional<Person>` 进行处理。讲道理，我们已经习惯了这种编译方式，而且它在某种程度上也是有道理的。总之一句话，在 **Swift 2.x** 中，想要使用 `ImplicitlyUnwrappedOptional` 的话，就需要利用 `init!` 对实例进行初始化。

然而，某种程度上来讲，上面这种做法是很不安全的。说实话，我们从没有任何钦定 `nilPerson` 应该是 `ImplicitlyUnwrappedOptional` 实例的意思，因为如果将来编译器推导出一些不安全的类型信息导致程序运行出了偏差，等于，你们也有责任吧。

**Swift 3.0** 解决这类安全问题的方式是在我们不是明确的声明一个 `ImplicitlyUnwrappedOptional` 时，会将 `ImplicitlyUnwrappedOptional` 作为 `optional` 进行处理。

## 限制 `ImplicitlyUnwrappedOptional` 的实例传递

这种做法很巧妙的一点在于限制了隐式解包的 `optional` 实例的传递。参考下我们前面关于 `Person` 的代码，同时思考下我们之前在 **Swift 2.x** 里的一些做法：

~~~Swift

    // Swift 2.x

    let matt = Person(firstName: "Matt", lastName: "Mathias")
    matt.firstName // `matt` is `ImplicitlyUnwrappedOptional<person>`; we can access `firstName` directly</person>
    let anotherMatt = matt // `anotherMatt` is also `ImplicitlyUnwrappedOptional<person>`</person>

~~~

`anotherMatt` 是和 `matt` 一样类型的实例。你可能已经预料到这种并不是很理想的情况。在代码里，`ImplicitlyUnwrappedOptional` 的实例已经进行了传递。对于所产生的新的不安全的代码，我们务必要多加小心。

比如，在上面的代码中，我们如果进行了一些异步操作，情况会怎么样呢？


~~~Swift
    // Swift 2.x

    let matt = Person(firstName: "Matt", lastName: "Mathias")
    matt.firstName // `matt` is `ImplicitlyUnwrappedOptional<person>`, and so we can access `firstName` directly</person>
    ... // Stuff happens; time passes; code executes; `matt` is set to nil
    let anotherMatt = matt // `anotherMatt` has the same type: `ImplicitlyUnwrappedOptional<person>`</person>

~~~

在上面这个例子中，`anotherMatt` 是一个值为 `nil` 的实例，这意味着任何直接访问他基础值的操作，都会导致崩溃。这种类型的访问确切来说是 'ImplicitlyUnwrappedOptional' 所推荐的方式。那么我们如果把`anotherMatt` 换成 `Optional<Person>` ，情况会不会好一些呢？

让我们在 **Swift 3.0** 中试试同样的代码会怎样。

~~~Swift

    // Swift 3.0

    let matt = Person(firstName: "Matt", lastName: "Mathias")
    matt?.firstName // `matt` is `Optional<person>`</person>
    let anotherMatt = matt // `anotherMatt` is also `Optional<person>`</person>

~~~

如果我们没有显示声明我们生成的是 `ImplicitlyUnwrappedOptional` 类型的实例，那么编译器会默认使用更为安全的 `Optional`。

## 类型推断应该是安全的

在这个变化中，最大的好处在于编译器的类型推断不会使我们代码的安全性降低。如果在必要的情况下，我们选择的一些不太安全的方式，我们必须进行显示的声明。这样编译器不会再进行自动的判断。

在某些时候，如果我们的确需要使用 `ImplicitlyUnwrappedOptional` 类型的实例，我们仅仅需要进行显示声明。

~~~Swift
    // Swift 3.0

    let runningWithScissors: Person! = Person(firstName: "Edward", lastName: "") // Must explicitly declare Person!
    let safeAgain = runningWithScissors // What's the type here?
~~~


`runningWithScissors` 是一个值为 `nil` 的实例，因为我们在初始化的时候，我们给 `lastName` 了一个空字符串。

请注意，我们所声明的 `runningWithScissors` 实例是一个 `ImplicitlyUnwrappedOptional<Person>` 的实例。在 **Swift 3.0** 中，**Swift** 允许我们同时使用 `Optional` 和 `ImplicitlyUnwrappedOptional` 。不过我们必须进行显示声明，从而告诉编译器我们所使用的是 `ImplicitlyUnwrappedOptional` 。

不过幸运的是，编译器不再自动将 `safeAgain` 作为一个 `ImplicitlyUnwrappedOptionalThankfully` 实例进行处理。相对应的是，编译器将会把 `safeAgain` 变量作为 `Optional` 实例进行处理。这个过程中，**Swift 3.0** 对不安全的实例的传播进行了有效的限制。

## 一些想说的话

`ImplicitlyUnwrappedOptional` 的改变可能是处于这样一种原因：我们通常在 **macOS** 或者 **iOS** 上操作利用 **Objective-C** 所编写的API，在这些API中，某些情况下，它们的返回值可能是为 `nil`，对于 **Swift** 来讲，这种情况是不安全的。

因此，**Swift** 正在避免这样的不安全的情况发生。非常感谢 **Swift** 开发者对于 `ImplicitlyUnwrappedOptional` 所进行的改进。我们现在可以非常方便的去编写健壮的代码。也许在未来某一天，`ImplicitlyUnwrappedOptional` 可能会彻底的从我们视野里消失。=

## 写在最后的话

如果你想知道更多关于这方面的知识，你可以从这里[this proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0054-abolish-iuo.md)获取一些有用的信息。你可以从 **issue** 里获得这个提案的作者的一些想法，同时通过具体的变化来了解更多的细节。同时那里也有相关社区讨论的链接。
