> * 原文地址：[What’s New in Swift 5.3?](https://medium.com/better-programming/whats-new-in-swift-5-3-142d89d4d1f7)
> * 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/whats-new-in-swift-5-3.md](https://github.com/xitu/gold-miner/blob/master/article/2020/whats-new-in-swift-5-3.md)
> * 译者：
> * 校对者：

# What’s New in Swift 5.3?

![Photo by [Kira auf der Heide](https://unsplash.com/@kadh?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10368/0*FYXrss0agbTq1JVx)

> Cross-platform support, multiple trailing closures, multi-pattern catch clauses, and more

The Swift 5.3 release process started at the end of March and has only recently entered the final stage of development. Extending the language support across platforms like Windows and Linux distributions has been one of the primary goals of this version.

But Apple has also given a lot of focus on improving the overall language and its performance to boost SwiftUI and machine learning for iOS. Let’s dig through the major changes that we’ll see in the soon-to-be-released update.

## Multiple Trailing Closures

The [SE-0279](https://github.com/apple/swift-evolution/blob/master/proposals/0279-multiple-trailing-closures.md) proposal brings a new syntax for trailing closures that lets you call multiple closures as parameters of a function in a more readable way. This is more syntactic sugar that minimizes the use of too many parentheses in a function signature.

Instead, it allows you to append several labeled closures after the initial unlabeled closure. The following example demonstrates a use case of this:

```Swift
//old
UIView.animate(withDuration: 0.5, animations: {
  self.view.alpha = 0
}, completion: { _ in
  self.view.removeFromSuperview()
})

//new multiple trailing closures
UIView.animate(withDuration: 0.5) {
            self.view.alpha = 0
        } completion: { _ in
            self.view.removeFromSuperview()
        }
```

The change above would make our SwiftUI views a lot easier to write.

## Multi-Pattern Catch Clauses

Currently, each catch clause in a do-catch statement can contain only a single pattern. To work around this, developers would ideally use the power of switch cases for including pattern matching in the body of catch statements, thereby increasing nested and duplicated code.

[SE-0276](https://github.com/apple/swift-evolution/blob/master/proposals/0276-multi-pattern-catch-clauses.md) is another fine evolution that brings pattern matching in catch clauses. Catch clauses would now allow the user to specify a comma-separated list of patterns with the ability to bind the variables with the catch body — like a switch statement. Here’s an example:

```Swift
enum NetworkError: Error {
    case failure, timeout
}

//old
func networkCall(){
  do{
    try someNetworkCall()
  }catch NetworkError.timeout{
    print("timeout")
  }catch NetworkError.failure{
    print("failure")
  }
}

//new
func networkCall(){
  do{
    try someNetworkCall()
  }catch NetworkError.failure, NetworkError.timeout{
    print("handle for both")
  }
}
```

Multi-pattern catch clauses would help make our codebase clear and concise.

## Synthesized Comparable Conformance for Enums

Up until now, comparing two enum cases wasn’t straightforward. You’d have to conform to `Comparable` and write up a `static fun \<` for determining if the raw value of a case is lower than the other (or vice versa for `>`).

Thankfully, [SE-0266](https://github.com/apple/swift-evolution/blob/master/proposals/0266-synthesized-comparable-for-enumerations.md) lets us opt into `Comparable` conformance for enums and you don’t need to explicitly implement the protocol as long as your enum has eligible types. If no associated values are set, `enums` will compare by semantic order of declaration.

Here’s an example of an enum that sorts them:

```Swift
enum Brightness: Comparable {
    case low(Int)
    case medium
    case high
}

([.high, .low(1), .medium, .low(0)] as [Brightness]).sorted()
// [Brightness.low(0), Brightness.low(1), Brightness.medium, Brightness.high]
```

## Enum Cases As Protocol Witnesses

Swift had a very restrictive protocol witness matching model wherein writing enum cases with the same name and arguments as the protocol was not considered a match. We were forced to fall back on manual implementation instead, as shown below:

```Swift
protocol DecodingError {
  static var fileCorrupted: Self { get }
  static func keyNotFound(_ key: String) -> Self
}

enum JSONDecodingError: DecodingError {
  case _fileCorrupted
  case _keyNotFound(_ key: String)
  static var fileCorrupted: Self { return ._fileCorrupted }
  static func keyNotFound(_ key: String) -> Self { return ._keyNotFound(key) }
}
```

[SE-0280](https://github.com/apple/swift-evolution/blob/master/proposals/0280-enum-cases-as-protocol-witnesses.md) has lifted this restriction so that enum cases can be protocol witnesses if they provide the same case names and arguments as the protocol requires.

```Swift
protocol DecodingError {
  static var fileCorrupted: Self { get }
  static func keyNotFound(_ key: String) -> Self
}
enum JSONDecodingError: DecodingError {
  case fileCorrupted
  case keyNotFound(_ key: String)
}
```

## self Isn’t Explicitly Required Everywhere

The [SE-0269](https://github.com/apple/swift-evolution/blob/master/proposals/0269-implicit-self-explicit-capture.md) proposal allows us to omit `self` in places where it’s no longer necessary. Earlier, using `self` in closures was necessary when we were capturing values from the outside scope. Now when reference cycles are unlikely to occur, `self` would be implicitly present.

Here’s an example that demonstrates this change:

```Swift
struct OldView: View {

    var body: some View {
        Button(action: {
            self.sayHello()
        }) {
            Text("Press")
        }
    }
    
    func sayHello(){}
}

struct NewView: View {

    var body: some View {
        Button {
            sayHello()
        } label: {
            Text("Press")
        }
    }
    
    func sayHello(){}
}
```

Developers using SwiftUI would happily embrace this. As views are held in `structs`, which are value types, reference cycles cannot occur.

## Type-Based Program Entry Points

[SE-0281](https://github.com/apple/swift-evolution/blob/master/proposals/0281-main-attribute.md) gifted us with a new `@main` attribute that lets us define entry points for our apps. You needn’t invoke an `AppDelegate.main()` method manually anymore, as marking a struct or class with the attribute ensures it’s the starting point of your program.

```Swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
static func main() {
        print("App will launch & exit right away.")
    }
}
```

One can assume that the older domain-specific provided attributes, `@UIApplicationMain` and `@NSApplicationMain`, would be deprecated in the future versions in favor of `@main`.

## where Clauses on Contextually Generic Declarations

Until now, `where` clauses couldn’t be placed on declarations nested inside generic contexts. For instance, the compiler would throw an error if you tried setting a `where` constraint on a function. As a workaround, we had to create separate extensions for handling specific `where` clauses.

With [SE-0267](https://github.com/apple/swift-evolution/blob/master/proposals/0267-where-on-contextually-generic.md), we can implement functions with `where` clauses as long as we’re referencing generic parameters. Here’s a code snippet that gives a glimpse of it:

```Swift
struct Base<T> {
    var value : T 
}

extension Base{

  func checkEquals(newValue: T) where T : Equatable{...}
  func doCompare(newValue: T) where T : Comparable{...}

}
```

By allowing `where` clauses on member declarations, we can easily create shorter and more concise generic interfaces and stay away from creating separate extensions.

## New Collection Operations for Noncontiguous Elements

Currently, accessing a continuous range of elements in a collection is straightforward. For arrays, all you need to do is `[startIndex...endIndex]`.

[SE-0270](https://github.com/apple/swift-evolution/blob/master/proposals/0270-rangeset-and-collection-operations.md) introduces a new optimized `RangeSet` type that lets us fetch a subrange of indexes that can be noncontiguous.

```Swift
var numbers = Array(1...15)

// Find the indices of all the even numbers
let indicesOfEvens = numbers.subranges(where: { $0.isMultiple(of: 2) })

// Find the indices of all multiples of 3
let multiplesofThree = numbers.subranges(where: { $0.isMultiple(of: 3) })

let combinedIndexes = multiplesofThree.intersection(indicesOfEvens)
let sum = numbers[combinedIndexes].reduce(0, +)
//Sum of 6 + 12 = 18
```

Using `RangeSet`, we can do a whole lot of computations and manipulations on collections. For example, by using the `moveSubranges` function, we can shift a range of indexes in an array. See how easy it is to tweak an array by moving all the even numbers to the beginning:

```Swift
let rangeOfEvens = numbers.moveSubranges(indicesOfEvens, to: numbers.startIndex)
// numbers == [2, 4, 6, 8, 10, 12, 14, 1, 3, 5, 7, 9, 11, 13, 15]
```

## Refine didSet Semantics

Previously, the getter of the `didSet` property observer was always called to retrieve the `oldValue` regardless of if the reference was assigned a value in the first place.

Now, this might not be a big cause of worry for variables, but for large arrays, allocating storage and loading a value that isn’t used can easily impact the performance of your applications.

[SE-0268](https://github.com/apple/swift-evolution/blob/master/proposals/0268-didset-semantics.md) has made the `didSet` property observers more efficient by only loading the `oldValue` if it’s needed. Besides, if we have a simple `didSet` and no `willSet`, then modifications would now happen in place.

Here’s an example of the refined `didSet`:

```Swift
class A {
    var firstArray = [1,2,3] {
        didSet { print("didSet called") }
    }

    var secondArray = [1,2,3,4] {
        didSet { print(oldValue) }
    }
}

let a = A()
// This will not call the getter to fetch the oldValue of firstArray
a.firstArray = [1,2]
// This will call the getter to fetch the oldValue of secondArray
a.secondArray = [1]
```

## A New Float16 Type

[SE-0277](https://github.com/apple/swift-evolution/blob/master/proposals/0277-float16.md) introduces `Float16` — a half-precision floating point. With the advent of machine learning on mobile in recent years, this only indicates Apple’s ambitions in pushing the envelope even further. A `Float16` is commonly used on mobile GPUs for computation and as a compressed format for weights in ML applications.

```
let f16: Float16 = 7.29
```

## Closing Thoughts

While that sums up the important Swift 5.3 language features, there are a lot of improvements in the Swift Package Manager as well. Let’s quickly walk through them:

* [SE-0271](https://github.com/apple/swift-evolution/blob/master/proposals/0271-package-manager-resources.md) lets you add resources(images, data files, etc.) to your Swift packages.
* [SE-0278](https://github.com/apple/swift-evolution/blob/master/proposals/0278-package-manager-localized-resources.md) makes it possible to add localized resources.
* [SE-0272](https://github.com/apple/swift-evolution/blob/master/proposals/0272-swiftpm-binary-dependencies.md) allows you to integrate closed-source dependencies such as Firebase in binary format in your package manager.
* [SE-0273](https://github.com/apple/swift-evolution/blob/master/proposals/0273-swiftpm-conditional-target-dependencies.md) lets you conditionally specify a dependencies manager for different target platforms.

You can download the Linux distributions of Swift from [this blog post](https://swift.org/blog/additional-linux-distros/). Or you can head to [Swift’s website](https://swift.org/download/#snapshots) to take a sneak peek at the snapshot version of Swift 5.3.

That’s it for this one. Thanks for reading.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
