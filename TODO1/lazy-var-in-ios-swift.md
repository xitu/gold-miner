> * 原文地址：[lazy var in ios swift](https://medium.com/@abhimuralidharan/lazy-var-in-ios-swift-96c75cb8a13a)
> * 原文作者：[Abhimuralidharan](https://medium.com/@abhimuralidharan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-var-in-ios-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-var-in-ios-swift.md)
> * 译者：[kirinzer](https://github.com/kirinzer)
> * 校对者：[portandbridge](https://github.com/portandbridge), [iWeslie](https://github.com/iWeslie)

# 在 iOS Swift 中的懒加载变量

> 这篇文章解释了在 Swift 中懒加载变量是如何工作的，你必须对闭包有一些了解。

**[阅读这篇文章获取更多关于闭包的信息](https://medium.com/@abhimuralidharan/functional-swift-all-about-closures-310bc8af31dd).**

当我们进行 iOS 开发时，我们应该非常关注应用程序的内存占用情况。如果应用程序很复杂，那么内存问题就会是对于开发者的一个主要的挑战。所以，首先考虑到内存分配问题的开发者能够真正的写出优化的代码。除非确实有必要，否则开发者要避免做一些耗时的工作。那些复杂的分配内存操作会消耗更多的时间，并且对于程序的性能有严重的影响。

![](https://cdn-images-1.medium.com/max/2000/1*HRKGc4RHwRXiyIHOzlpKbA.png)

Swift 有内置在语言中的机制，可以即时的计算那些耗时工作。它叫做**懒加载变量**。这种变量只有在你第一次需要它的时候才被指定的方法创建。如果从没有使用过该变量。那么方法就不会运行，所以它可以帮助减少一些处理时间。

*苹果的官方文档写道：*

**一个懒加载储存属性是种只有在首次使用时，才计算其初始值的属性。你可以通过在声明前加 `lazy` 修饰符来标示一个懒加载存储属性。**

> 你必须将一个懒加载属性声明为一个变量(通过 `var` 关键字)，因为它的初始化值也许不能获得，直到实例的初始化完成。常量属性在初始化完成**之前**一定会有一个值，因此不能用懒加载声明。

为了解释这些，我会使用一个很基础的示例：假设有一个结构体叫做 InterviewCandidate。它有一个可选的布尔值，决定候选人正在申请 iOS 或者 Android。iOSResumeDescription 和 androidResumeDescription 被声明为懒加载属性。那么在下面的代码中，一个人是 iOS 开发者，懒加载变量 **iOSResumeDescription** 将会在调用打印方法的时候被初始化。没有被调用的 **androidResumeDescription** 就会是 nil。

```swift
//: Playground - noun: 人们用来玩耍的地方
import UIKit


struct InterviewCandidate {
    var isiOS:Bool?
    
    lazy var iOSResumeDescription: String = {
        return "I am an iOS developer"
    }()
    lazy var androidResumeDescription: String = {
        return "I am an android developer"
    }()
}

var person1 = InterviewCandidate()
person1.isiOS = true

if person1.isiOS! {
    print(person1.iOSResumeDescription)
} else {
    print(person1.androidResumeDescription)

}
```

这是一个非常基础的例子。如果我们有一个复杂的类或结构，它包含从循环的函数返回结果的计算变量，并且如果我们创建 1000 个这样的对象，那么性能和内存将会受到影响。

## 懒加载存储属性 vs 存储属性

这有一些懒加载属性相对于存储属性的优点。

 1. 只有在读取懒加载属性时，才会执行与该属性关联的闭包。 因此，如果由于某种原因该属性未被使用（可能是因为用户的某些决定），则可以避免不必要的分配和计算。

 2. 你可以使用一个存储属性给懒加载属性赋值。

 3. **注意** 你能够在懒加载的属性闭包内部使用 `self`。这不会导致任何循环引用。原因在于它立即使用的这个闭包 `{}()` 被认为是 `@noescape`。它不会引用捕获的 `self`。
> 但是，如果你在 **方法** 中使用 `self`。事实上，如果你正在使用的是一个类而不是结构体，你也应该在你的方法内声明 `[unowned self]` 那样你才不会创建一个强引用（查看下面的代码）。

```swift
// playground code

import UIKit
import Foundation

class InterviewTest {
	var name: String
	lazy var greeting : String = { return “Hello \(self.name)” }()
	// 这里没有循环引用 ..

	init(name: String) {
		self.name = name
	}
}

let testObj = InterviewTest(name:”abhi”)

testObj.greeting
```

你能够引用这个变量，无论你是否使用了闭包。

```swift
lazy var iOSResumeDescription = “I am an iOS developer”
```

这样的语法也可以运行。

> **注意：记住，懒加载属性的用途是只有它们第一次被需要的时候才会被计算，在这之后它们的值就被存储下来了。所以，如果你第二次使用 `iOSResumeDescription `，预先存储的属性就会返回。**

## 懒加载规则:

* 你不能对 `let` 类型使用 `lazy`。

* 你不能对于 `计算属性` 使用它。因为一个计算属性会在每次我们试图访问它的时候去执行在计算代码块中的代码并返回相应的值。

* 你只能对 `struct` 和 `class` 的成员使用 `lazy`。

* 懒加载变量不是原子初始化类型，所以它并不是线程安全的。

**如果你喜欢阅读这篇文章，那么分享和推荐它以便其他人能够看到💚💚💚💚💚💚！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
