> * 原文地址：[lazy var in ios swift](https://medium.com/@abhimuralidharan/lazy-var-in-ios-swift-96c75cb8a13a)
> * 原文作者：[Abhimuralidharan](https://medium.com/@abhimuralidharan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-var-in-ios-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-var-in-ios-swift.md)
> * 译者：
> * 校对者：

# lazy var in ios swift

> This article explains the working of lazy var in swift.You must have some knowledge in closures.

**[Read this article for more info on closures](https://medium.com/@abhimuralidharan/functional-swift-all-about-closures-310bc8af31dd).**

While dealing with iOS app development we should be really very much conscious about the amount of memory used by the application. If the app is a complex one, then the memory issues are one of the major challenges for the developer. So, the developer should be really writing an optimised code which consider memory allocation at first place. The developer need to avoid doing expensive work unless it’s really needed. These complex allocations will take more time and it will seriously affect the performance of the application as well.

![](https://cdn-images-1.medium.com/max/2000/1*HRKGc4RHwRXiyIHOzlpKbA.png)

Swift has a mechanism built right into the language that enables just-in-time calculation of expensive work, and it is called a ****lazy variable****. These variables are created using a function you specify only when that variable is first requested. If it’s never requested, the function is never run, so it does help save processing time.

*Apple’s official documentation says:*

**A lazy stored property is a property whose initial value is not calculated until the first time it is used. You indicate a lazy stored property by writing the `lazy` modifier before its declaration.**

> You must always declare a lazy property as a variable (with the `var` keyword), because its initial value might not be retrieved until after instance initialization completes. Constant properties must always have a value **before** initialization completes, and therefore cannot be declared as lazy.

To explain this, I will use a basic example: Consider a struct called InterviewCandidate. It has an optional bool value to decide if the candidate is applying for ios or android. Resume description for iOS and android are declared as lazy variables. So , in the following code, the person is an iOS developer and the lazy variable **iOSResumeDescription** will be initialized when called for printing . **androidResumeDescription** undefinedwill be nil.

```swift
//: Playground - noun: a place where people can play
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

This is a very basic level example. If we have a complex class or struct which contains computed variables which return the result from a recursive function and if we create a 1000 objects of this, then the performance and memory will be affected.

## Lazy Stored Property vs Stored Property

There are a few advantage of a lazy property over a stored property.

 1. The closure associated to the lazy property is executed only if you read that property. So if for some reason that property is not used (maybe because of some decision of the user) you avoid unnecessary allocation and computation.

 2. You can populate a lazy property with the value of a stored property.

 3. **Important to note:** You can use `self` inside the closure of a lazy property. It will not cause any retain cycles. The reason is that the immediately applied closure `{}()` is considered `@noescape`. It does not retain the captured `self`.
> But, if you need to use `self` inside the ****function****. In fact, if you're using a class rather than a structure, you should also declare `[unowned self]` inside your function so that you don't create a strong reference cycle(check the code below).

```swfit
// playground code

import UIKit
import Foundation

class InterviewTest {
var name: String
lazy var greeting : String = { return “Hello \(self.name)” }()
// No retain cycles here ..

init(name: String) {
self.name = name
 }
}

let testObj = InterviewTest(name:”abhi”)

testObj.greeting
```

You can reference variables regardless of whether or not you use a closure.

lazy var iOSResumeDescription = “I am an iOS developer”

This is also a working syntax.

> **Note: Remember, the point of lazy properties is that they are computed only when they are first needed, after which their value is saved. So, if you call the `iOSResumeDescription `for the second time, the previously saved value is returned.**

## Lazy rules:

* You can’t use `lazy` with `let` .

* You can’t use it with `computed properties` . Because, a computed property returns the value every time we try to access it after executing the code inside the computation block.

* You can use `lazy` only with members of `struct` and `class` .

* Lazy variables are not initialised atomically and so is not thread safe.

### If you enjoyed reading this post, please share and recommend it so others can find it 💚💚💚💚💚💚 !!!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
