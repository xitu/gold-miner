> * 原文地址：[My Least Favorite Thing About Swift](http://khanlou.com/2016/08/my-least-favorite-thing-about-swift/)
* 原文作者：[Soroush Khanlou](http://www.twitter.com/khanlou)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[cbangchen](https://github.com/cbangchen)
* 校对者：




There’s a lot to love about Swift, which I’ve written about [before](http://khanlou.com/2016/05/six-months-of-swift/). Today, however, I want to write about where the language falls short. This is a complicated issue with lots of nuance, so I’ll go into a couple of examples of where I think the language gets it right, where it gets it wrong, and what the future holds.

关于喜欢 Swift 的理由，可以有很多，[之前](http://khanlou.com/2016/05/six-months-of-swift/)我已经写到了。
但是今天，我想要写的是这门语言不足的地方。这是一个有着很多细微差别且具有很强争议性的问题，所以我将举出几个例子，这几个例子是关于我所认为的这门语言做的好的地方，做的不好的地方和这门语言未来所会有的模样。

### Defining within the language vs without

语言内定义 VS 非语言内定义

Take a look at Ruby.

看一下 Ruby

Ruby’s `attr_accessor` is a way to define a setter and a getter for an instance variable. You use it like so:

Ruby 的 `attr_accessor` 是一种定义实例变量的 setter 和 getter 的方法。你会像下面这样使用它：


    class Person
    	attr_accessor :first_name, :last_name
    end



At first blush, this looks like a language feature, like Swift’s `let` and `var` property declarations. But Ruby’s functions can be called without parentheses, and this is just a function defined in the class scope (which we’d call a static function in Swift):

乍一看，它像是一种语言的特性，就像 Swift 的 `let` 和 `var` 两种属性声明方式。但是 Ruby 的函数即便没有括号也可以被调起，而且这只是一个被定义在类范围内的函数（在 Swift 中我们将会调起一个静态函数）：

    def self.attr_accessor(*names)
      names.each do |name|
        define_method(name) {instance_variable_get("@#{name}")} # This is the getter
        define_method("#{name}=") {|arg| instance_variable_set("@#{name}", arg)} # This is the setter
      end
    end

If you can’t read Ruby, that’s okay. It uses a function called `define_method` to create a getter and setter for the keys that you pass in. In Ruby, `@first_name` means the instance variable named `first_name`.

如果你不能读懂 Ruby ，没有关系。它使用了一个名为 `define_method` 的函数来为你所传递的 keys 创建一个 getter 和 setter。在 Ruby ，`@first_name` 意味着一个名为 `first_name` 的实例变量。

This is one of the reasons I love Ruby’s language design — they first create the meta-tools to create useful language features, and then they use those tools to implement the language features that they want. [Yehuda Katz explores](http://yehudakatz.com/2010/02/07/the-building-blocks-of-ruby/) how Ruby applies this idea to its blocks. Because Ruby’s language features are written with the same tools and in the same language that users have access to, users can also write features similar in style and scope to the ones that define the language.

这是我爱上 Ruby 这门语言的设计的其中一个原因 - 它们首先创建一个可创建有用语言特性的元数据工具集，然后它们使用这些工具来实现它们所需要的语言特性。[Yehuda Katz explores](http://yehudakatz.com/2010/02/07/the-building-blocks-of-ruby/) 讲述了 Ruby 是怎样在它的 blocks 中实现这个想法的。因为编写 Ruby 语言特性的工具和在同一门语言中用户可以访问的工具是相同的，这意味着用户也可以使用相同的风格和范围来编写定义语言的特性。

### Optionals

### 可选类型

This brings us to Swift. One of Swift’s core features is its `Optional` type. This allows users to define whether a certain variable can be null or not. It’s defined within the system with an enum:

这给我们带来了 Swift。Swift 的一个核心特性就是它的 `Optional`（可选）类型。允许用户定义某个变量是否可以为空。在系统中，有这样的一个枚举：

    enum Optional {
    	case Some(WrappedType)
    	case None
    }



Like `attr_accessor`, this feature uses a Swift language construct to define itself. This is good, because it means users can create similar things with different semantic meanings, such as this fictional `RemoteLoading` type:

就像 `attr_accessor` ，这个特性使用了一个 Swift 的语言结构来定义自身。这是很好的，因为这也意味着用户可以使用不同的语义来创建相同的事物，就像这个虚构的 `RemoteLoading` 类型:

    enum RemoteLoading {
    	case Loaded(WrappedType)
    	case Pending
    }


It has the exact same shape as `Optional` but carries different meanings. (Arkadiusz Holko takes this enum a step further [in a great blog post](http://holko.pl/2016/06/09/data-state-as-an-enum/).)

它和 `Optional` 有着相同的形态却有着不同的含义。（[在一个不错的博客帖子里](http://holko.pl/2016/06/09/data-state-as-an-enum/)，Arkadiusz Holko 让这个枚举有了进一步的改变）

However, the Swift compiler _knows_ about the `Optional` type in a way it doesn’t know about `RemoteLoading`, and it lets you do special things. Take a look at these identical declarations:

然而，在某种程度上，Swift 的编译器 _知道_ `Optional` (可选) 类型但却不知道 `RemoteLoading`（远程加载），这可以让你做一些特殊的事情。看一下这些相同的声明：


    let name: Optional = .None
    let name: Optional = nil
    let name: String? = nil
    var name: String?



Let’s unpack them. The first one is the full expression (with type inference). You could declare your own `RemoteLoading` property with the same syntax. The second uses the `NilLiteralConvertible` protocol to define what happens when you set that value to the literal `nil`. While this piece of syntax is accessible for your own types, it doesn’t seem quite right to use it with `RemoteLoading`. This is the first of a few language features that are designed to make Swift feel more comfortable to writers of C family languages, which we’ll come back to in a moment.

让我们解析一下它们。第一条语句是完整的表述（带有类型推断）。你可以使用相同的语法声明你自己的 `RemoteLoading` （远程加载）属性。第二条语句使用了 `NilLiteralConvertible` 协议来定义当你把这个值设置为 nil 的时候所要执行的操作。虽然这种语法对于你自己的类型访问是可以的，但是配合 `RemoteLoading` （远程加载）使用却显得不是很正确。这是首先被设计来使 Swift 编写 C 族语言的时候感觉更加顺畅的几条语言特性，待会我们会再次提到这一点。

The third and fourth declarations are where the compiler starts using its knowledge of the `Optional` type to allow us to write special code that we couldn’t write with other types. The third one uses a shorthand for `Optional` where it can be written as `T?`. This is called _syntactic sugar_, where the language lets you write common bits of code in simpler ways. The final line is another piece of syntactic sugar: if you declare an optional type, but don’t give it a value, the compiler will infer that its value should be `.None`/`nil` (but only if it’s a `var` reference).

第三条和第四条语句，编译器开始使用 `Optional` (可选) 类型来允许我们编写特殊的代码，这些代码确定了我们所编写代码的类型。第三条语句使用了一个 `Optional` (可选)类型的简写 `T?`。这被称为 _语法糖_，这种语法可以用更简单的方式来编写常用的代码。最后一句是另外一块语法糖：如果你定义一个可选类型，但是你不赋给它任何值，那编译器将会推测出它的值应该为 `.None`/`nil` （仅仅当他是一个 `var` 变量的时候才成立）。

You can’t access these last two optimizations with your own types. The language’s `Optional` type, which started out awesomely, by being defined within the existing constructs of language, ends up with special-cased compiler exceptions that only this type can access.

后面的两条语句都不允许自定义可访问类型。这种语言的 `Optional` （可选）类型，它的出现令人十分赞叹，通过被语言内已存在结构所定义，最终除了特殊情况下产生的编译器异常外，只有指定的类型才能访问。

### Families

### 家族

Swift is defined to “feel at home in the C family of languages”. This means having for loops and if statements.

Swift 是一门被定义为“在 C 语言家族中宾至如归”的语言。这个意义来自于它的 loop (循环)语句和 if 语句。

Swift’s `for..in` construct is special. Anything that conforms to `SequenceType` can be iterated over in a `for..in` loop. That means I can define my own types, declare that they’re sequential, and use them in `for..in` loops.

Swift 的 `for..in` 语法结构是特殊的。任何符合 `SequenceType` 的事物可以通过一个 `for..in` 循环来遍历。这意味着我可以定义自己的类型值，声明它们的连续性，然后在 `for..in` 循环中来使用它们。

Although `if` statements and `while` loops [currently work this way in Swift 2.2](http://khanlou.com/2016/06/falsiness-in-swift/) with `BooleanType`, this functionality has been removed in Swift 3\. I can’t define my own boolean types to use within `if` statements like I can with `for..in`.

虽然 `if` 语句和 `while` 循环是通过 `BooleanType` 类型[在 Swift 2.2 中这样子工作的](http://khanlou.com/2016/06/falsiness-in-swift/)，但是这种功能在  Swift 3\ 已经被移除了。我不能像在 `for..in` 循环语句中那样子定义自己的布尔类型值然后在 `if` 语句中使用。

These are two fundamentally different approaches to a language feature, and they define a duality in Swift. The first creates a meta-tool that can be used to define a language feature; the other creates a explicit and concrete connection between the feature of the language and the types of that language.

从根本上来说，对于一种语言特性，它们是两种完全不同的方法，也在 Swift 中定义了一种二元性。首先创建了一个可以用来定义语言特性的元工具；另外创建了语言特性和语言类型值之间的一种明确和具体的联系。

You could argue that types conforming to `SequenceType` are more useful than types conforming to `BooleanType`. Swift 3 fully removes this feature, though, so you have to fully commit: you have to argue that `BooleanType` is so useless that it should be completely disallowed.

你可以对于符合 `SequenceType` 的类型值比符合 `BooleanType` 的类型值更加有用这个观点提出异议。但是，Swift 3 已经完全的移除了这个特性，所以，你不得不承认：你不得不去认为 `BooleanType` 是如此没有用处以至于会被完全禁止。

Being able to conform my own types `SequenceType` shows that the language trusts me to make my own useful abstractions (with no loss of safety or strictness!) on the same level as its own standard library.

能够自己去定义符合 `SequenceType` 的类型值意味着这门语言相信我可以像它自己的标准库一样，在相同的水平上，去自行创建有用的抽象概念值。（没有值丢失，安全，严格！）。

### Operations

### 运算符

Operators in Swift are also worth examining. Syntax exists within the language to define operators, and all the arithmetic operators are defined within that syntax. Users are then free to define their own operators, useful for if they create their [own BigInt type](https://github.com/lorentey/BigInt) and want to use standard arithmetic operators with it.

在 Swift 中的运算符也值得研究。语言中存在着定义运算符的语法，所有的算术运算符都是在这个语法中被定义的。用户们可以自由的定义自己的运算符，这对于想要创建[自己的长整数类型](https://github.com/lorentey/BigInt) 的同时也想要使用标准的算术运算符来说是有用处的。

While the `+` operator is defined within the language, the ternary operator `?:` isn’t. Command-clicking on the `+` operator jumps you to its definition. Command-clicking on either the `?` or the `:` of the ternary operator yields nothing. If you want to use a sole question mark or colon as an operator for your code, you can’t. Note that I’m _not_ saying that it would be a good idea to use a colon operator in your code; all I’m saying is that this operator has been special-cased, hard-coded into the compiler, to add familiarity to those weaned on C.

然而 `+` 运算符在语言中被定义，三元运算符 `?:` 却没有。当你点击 `+` 时，命令跳转到这个运算符的声明处。当你点击三元运算符中的 `?` 和 `:` 的时候，却没有任何反应。如果你想要在你的代码中使用单个的问号和感叹号作为操作符的话，你做不到。注意我这里 _不是_ 说在你的代码中使用一个感叹号操作符不是一个好主意。我只是想说，这个操作符已经被特殊对待，硬编码到了编译器，与其他 C 中定义的操作符一般无二。
 
In each of these three cases, we’ve compared two things: the first, a useful language syntax which the standard library uses to implement features; and the second, a special-case which privileges standard library code over consumer code.

这三个例子中的每一个，我们都比较了两个东西：第一个是一种被标准类库用来实现特性的有用语法；第二个是特权标准库超越消费者代码的特殊例子。（这一句不确定，请帮忙多考虑一下）

The best kinds of syntax and syntactic sugar can be tapped into by the writers of the language, with their own types and their own systems. Swift sometimes handles this with protocols like `NilLiteralConvertible`, `SequenceType`, and the soon-defunct `BooleanType`. The way that `var name: String?` can infer its own default (`.None`) crucially _isn’t_ like this, and therefore is a less powerful form of syntactic sugar.

最好的语法和语法糖是可以被一门语言的作者利用自己的类型和系统不断深入挖掘的。Swift 有时候使用类似 `NilLiteralConvertible`, `SequenceType`, 和易僵化的 `BooleanType` 等协议来处理这些事情。这种 `var name: String?` 能够推测出自己的默认属性值（`.None`）的方式很明显不是这样子的，因此这是一种不那么给力的语法糖。

I think it’s also worth noting that even though I love Ruby’s syntax, two places where it doesn’t have very much flexibility are operators and falsiness. You can define your own implementations for the Ruby’s existing operators, but you can’t add new ones, and the precedences are fixed. Swift is _more_ flexible in this regard. And, of course, it was more flexible with respect to defining falsiness as well, until Swift 3.

我认为值得注意的是，即使我爱 Ruby 的语法，但是 Ruby 在运算符和 falsiness 这两个地方却不是很灵活。你可以自行定义已存在运算符的实现方式，但是不能添加一个新的运算符，这部分优先级是固定的。Swift 在这个方面 _更_ 灵活。而且，当然，在 Swift 3 之前，Swift 在定义 falsiness 方面同样具有更强的灵活性。

### Errors

### 错误

In the same way that Swift’s Optional type is a shade of C’s nullability, Swift’s error handling resembles a shade of C’s exception handling. Swift’s error handling introduces several new keywords: `do`, `try`, `throw`, `throws`, `rethrows`, and `catch`.

在某种程度上来说，Swift 的可选类型类似于 C 语言的可空性， Swift 的错误处理也类似于 C 语言的异常处理。Swift 的错误处理引入了一些新的关键词：`do`, `try`, `throw`, `throws`, `rethrows`, 和 `catch`。

Functions and methods marked with `throws` can `return` a value or `throw` an `ErrorType`. Thrown errors are land in `catch` blocks. Under the hood, you can imagine Swift rewriting the return type for the function

使用 `throws` 标记的函数和方法可以 `return` 一个值或者 `throw` 一个 `ErrorType`。抛出错误后将执行 `catch` blocks函数。在这种机制下，你可以想象 Swift 是通过内部潜在代表成功或者失败的 `_Result` 类型 （就像 [`antitypical/Result`](https://github.com/antitypical/Result)）来重写一个函数的返回值的。

    func doThing(with: Property) throws -> Value

    func doThing(withProperty) -> _Result



with some internal `_Result` type (like [`antitypical/Result`](https://github.com/antitypical/Result)) that represents potential success or failure. (The reality is this `_Result` type isn’t explicitly defined, but rather [implicitly handled in the bowels of the compiler](https://marc.ttias.be/swift-evolution/2016-08/msg00322.php). It doesn’t make much of a difference for our example.) At the call site, this is unpacked into its successful value, which is passed through the `try` statement, and the error, which jumps execution to the `catch` block.

（事实上，这种 `_Result` 类型并没有被显式定义，而是[在编译器中被隐式的处理了]((https://marc.ttias.be/swift-evolution/2016-08/msg00322.php))。这对于我们的例子并没有造成太多的不同。）在调用函数的内部，传入成功的值的时候将会执行 `try` 语句，而发生错误的时候，则会跳入并执行 `catch` block函数。

Compare this to the previous examples, where useful features are defined within the language, and then syntax (in the case of operators or `SequenceType`) and syntactic sugar (in the case of `Optional`) are added _on top_ of them to make the code look the way we expect it. In contrast, the Swift’s error handling doesn’t expose its internal `_Result` model, so users can’t use it or build on it.

对比这个与之前的例子中有用的语言特性在语言内部被定义的地方，再 _在上面_ 加上语法（例如操作符和 `SequenceType`）和语法糖（例如 `Optional`（可选性））,那么这个代码就变的像我们所期待的那样了。相反的，Swift 的错误处理并没有暴露它的内部 `_Result` 模型，所以用户无法使用或者改变它。

Some cases for error handling works great with Swift’s model, like [Brad Larson’s code for moving a robot arm](http://www.sunsetlakesoftware.com/2015/06/12/swift-2-error-handling-practice) or [my JSON parsing code](http://khanlou.com/2016/04/decoding-json/). Other code might work better with a `Result` type and `flatMap`.

一些例子使用 Swift 模型来进行错误处理非常合适，例如[Brad Larson 用来移动机器人手臂的代码](http://www.sunsetlakesoftware.com/2015/06/12/swift-2-error-handling-practice)和[我的 JSON 解析代码](http://khanlou.com/2016/04/decoding-json/)。其他情况的话，使用 `Result` 类型和 `flatMap` 会更合适。

Still other code might rely on asynchronicity and want to pass a `Result` type to a completion block. Apple’s solution only works in certain cases, and giving users of the language more flexibility in the error model would help cover this distance. `Result` is great, because it’s flexible enough to build multiple things on top of it. The `try`/`catch` syntax is weak, because it’s very rigid and can only be used in one way.

其他的代码可能依赖异步处理，想要传递一个 `Result` 的类型值到一个处理完成 block。苹果的解决方案只能在某些特定的情况下起到作用，给予在错误模型上更大的自由可以帮助缩小这门语言和使用者之间的距离。`Result` 是很好的，因为它足够灵活，可以在上面玩很多花样。`try`/`catch` 语法并不是很给力，因为它的使用十分严格而且只有一种使用方法。

### The Future

### 未来

Swift 4 promises language features for asynchronous work soon. It’s not clear how these features will be implemented yet, but Chris Lattner has written about the road to the Swift 4:

Swift 4 承诺很快异步的语言特性就会可以使用。目前还不清楚将如何实现这些功能，但是 Chris Lattner 曾经写过关于 Swift 4 的道路：

> First class concurrency: Actors, async/await, atomicity, memory model, and related topics.

> 一流的并发，包括：Actors、同步/等待、原子性、内存模型及其它一些相关主题。

Async/await is my leading theory for what asynchronicity in Swift will look like. For the uninitiated, async/await involves declaring when functions are `async`, and using the `await` keyword to wait for them to finish. Take this simple example from C#:

异步/等待 是我对于 Swift 的异步的处理机制后面将会是什么模样所采取的主要理论。在外行人眼里看来，异步/等待 涉及到当函数是异步的时候，需要声明函数的 `async`，并使用 `await` 来等待函数方法的结束。从 C# 的这个简单例子来了解一下：


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

第一个函数方法，`GetIntAsync` 返回了一个任务，该任务等待一段时间后返回了一个值。因为这个函数返回了一个 `Task`，所以被标记为 `async`。第二个函数方法，首先调用 `MyMethodAsync`，使用关键词 `await`。这个信号监测了这个信号系统，在 `Task` 完成并执行 `GetIntAsync`
之前，这个系统可以做其他的事情。而一旦这个任务完成了，这个函数就会恢复控制功能，重新获得编写控制台输出的能力。

Judging from this example, `Task` objects in C# seem a lot like [promises](http://khanlou.com/2016/08/promises-in-swift/). Also, any function that uses the `await` keyword must itself be declared as `async`. The compiler can enforce this guarantee. This solution mirrors Swift’s error model: functions that throw must be caught, and if they don’t, they must be marked with `throws` as well.

从这个例子看来，C# 的 `Task` 对象看起来很像 [Promise (承诺)](http://khanlou.com/2016/08/promises-in-swift/)。此外，任何函数，使用 `await` 关键词都必须被定义为 `async`。编译器可以确保这点。这个解决方案映射出了 Swift 的错误模型：被抛出的函数方法必须被捕捉到，而如果没有，那这些函数方法一定也是被标记了 `throws` 。

It also has the same flaws as the error model. Rather than being mere syntactic sugar over a more useful tool, a brand new construct and a bunch of keywords are added. This construct is partially dependent on types within defined in the standard library and partially dependent on syntax baked into the compiler.

它也像错误模型一样有着缺陷。一个全新的构造和一些关键词的添加之后变的更像是一种纯粹的语法糖而不是一个更有用的工具。这种构造部分依赖类型内定义标准库和部分依赖于编译器的语法。（这一段不确定，请帮忙多考虑）

### Properties

### 属性

Property behaviors are another big feature that might come in Swift 4\. There is a [rejected proposal](https://github.com/apple/swift-evolution/blob/master/proposals/0030-property-behavior-decls.md) for property behaviors, which is set to be examined more closely for Swift 4.

属性行为是 Swift 4 可能引入的另一个重大特性。这里是关于属性行为的[被拒绝的提案](https://github.com/apple/swift-evolution/blob/master/proposals/0030-property-behavior-decls.md)，被用来对 Swift 4 进行更加仔细地检查。

Property behaviors let you attach a behavior like `lazy` to a property. The `lazy` property, for example, would only set up a value the first time it’s accessed. While you currently can use this particular behavior, it’s hard-coded into the Swift compiler. Property behaviors as proposed would allow the facility for the standard library to implement some behaviors and for users to define others entirely.

属性行为让你可以对一个属性附加上一个类似 `lazy` 的行为。这个 `lazy` 属性，举个例子，将只在第一次访问时设置一个值。但你已经可以使用这个特定的行为，这是直接硬编码进 Swift 的编译器的。按照计划，属性行为将允许标准库设施来实现一些行为和允许用户去对其他进行完全的定义。

Perhaps this is the best of all worlds. Start with a feature that’s hard-coded in the compiler, and after the feature has gained some prominence, create a more generic framework which lets you define that feature through the language itself. At that point, any writer of Swift can create similar functionality, tweaked precisely to suit their own requirements.

可能这对整个世界来说是最好的。从一个已经被硬编码进编译器的一个特性开始，然后在这个特性取得一定声望之后，创建一个更通用的框架来允许你通过语言本身定义这个特性。在这一点上,任何 Swift 的作者都可以创建类似的功能,精确调整来满足自己的需求。

If Swift’s error model followed that same path, Swift’s standard library might expose a `Result` type, and any function returning a `Result` would be able to use the `do`/`try`/`catch` syntax when it is most useful (like for many parallel, synchronous actions that can each fail). For error needs that don’t fit in to the currently available syntax, like async errors, users would have a common `Result` type that they can use. If the `Result` requires lots of chaining, users can `flatMap`.

如果 Swift 的错误模型遵循着相同的路径，Swift 的标准库可能会暴露出一个 `Result` 类型值，然后任何返回一个 `Result` 的功能都可以使用 `do`/`try`/`catch` 语法（就像那些可以单个失败的并行、同步事件）。对于那些不需要符合当前可用语法的错误，就像异步错误，用户可能拥有一个他们可以使用的一个共同的 `Result`。如果这个 `Result` 同时请求很多锁，用户可以 `flatMap`。

Async/await could work the same way. Define a `Promise` or `Task` protocol, and things that conform to that would be `await`-able. `then` or `flatMap` would be available on that type, and depending on user’s needs, they could use the language feature at as high or as low of a level as needed.

异步/等待 能够以相似的方式工作。定义一个 `Promise` 或者 `Task` 协议，而符合这些协议的将会可以 `await` 的。 `then` 或者 `flatMap` 将会是类型中可用的部分，根据用户的需求，它们能够根据需要以不同的程度使用语言的特性。

I’d like to close with a note on metaprogramming. I’ve written extensively [about metaprogramming in Objective-C](http://genius.com/Soroush-khanlou-metaprogramming-isnt-a-scary-word-not-even-in-objective-c-annotated), but it’s similar to what we’re working with here. The lines between code and metacode are blurry. The code in the Swift compiler is the meta code, and Swift itself is the code. If defining an implementation of an operator (as you do in Ruby) is just code, then defining a whole new operator seems like it has to be metacode.

我想要去更加多的认识元编程，我已经写了具有扩展性的[关于 Objective-C 中的元编程](http://genius.com/Soroush-khanlou-metaprogramming-isnt-a-scary-word-not-even-in-objective-c-annotated)，但是它与我们正着手在做的东西很相似。代码和元代码之间的界限是模糊的。Swift 编译器中的代码是元代码，并且 Swift 本身也是代码。如果定义一个 operator 函数的实现（就像Ruby所做的）就是代码，那么定义一个全新的运算符看起来就像是元代码。

As a protocol-oriented language, Swift is uniquely set up to let us tap into the syntax of the language, as we do with `BooleanType` and `SequenceType`. I’d love to see these capacities expanded.

作为一种面向协议的语言，Swift 很独特的被专门设置来让我们挖掘这门语言的语法魅力，就像我们用 `BooleanType` 和 `SequenceType` 所做的一样。我很乐意去看一下这些被扩展的能力。

The line where keywords stop and syntax starts, or where syntax stops and syntactic sugar starts, isn’t very well defined, but the engineers who write code in the language should have the ability to work with the same tools as those who develop the standard library.

关键词停止和语法开始或者语法停止和语法糖开始的界限，不是很明确，但是使用这门语言编写代码的工程师应该有能力去使用那些同样被用来开发标准库的工具。

