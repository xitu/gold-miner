> * 原文地址：[Memory Leaks in Swift: Unit Testing and other tools to avoid them.](https://medium.com/flawless-app-stories/memory-leaks-in-swift-bfd5f95f3a74)
> * 原文作者：[Leandro Pérez](https://medium.com/@leandromperez?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/memory-leaks-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/memory-leaks-in-swift.md)
> * 译者：
> * 校对者：

# Memory Leaks in Swift

## Unit Testing and other tools to avoid them.

![](https://cdn-images-1.medium.com/max/2000/1*7ISuh6UwWtqCmfzSUpyUBw.png)

In this article we will talk about memory leaks and will learn how to use Unit Testing to detect them. Here’s a sneak peek:

```
describe("MyViewController"){
    describe("init") {
        it("must not leak"){
            let vc = LeakTest{
                return MyViewController()
            }
            expect(vc).toNot(leak())
        }
    }
}
```

This is a test written in [**_SpecLeaks_**](https://cocoapods.org/pods/SpecLeaks)**_._**

Important: I will explain what memory leaks are, talk about retain cycles and other things you might already know. If you want to read only about Unit Testing Leaks, skip to the last section.

### **Memory Leaks**

Indeed, it’s one of the most frequent problems we face as developers. We code feature after feature and as the app grows, we introduce leaks.

A memory leak is a portion of memory that is occupied forever and never used again. It is garbage that takes space and causes problems.

> Memory that was allocated at some point, but was never released and is no longer referenced by your app. Since there are no references to it, there’s now no way to release it and the memory can’t be used again.
>
> [Apple Docs](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/CommonMemoryProblems.html)

We all create leaks at some point, from junior to senior devs. It doesn’t matter how experienced we are. It is paramount to eliminate them to have a clean, crash-free application. Why? Because _they are dangerous._

### Leaks are dangerous

Not only they _increase the memory footprint_ of the app, but they also _introduce unwanted side effects_ and _crashes._

Why does the **memory footprint** grow? It is a direct consequence of objects not being released. Those objects are actually garbage. As the actions that create those objects are repeated, the occupied memory will grow. Too much garbage! This can lead to memory warnings situations and in the end, the app will crash.

Explaining **unwanted side effects** requires a little more detail.

Imagine an object that starts listening to a notification when it is created, inside `init`. It reacts to it, saving things to a database, playing a video, or posting events to an analytics engine. Since the object needs to be balanced, we make it stop listening to the notification when it is released, inside `deinit`.

What happens if such an object leaks?

It will never die and it will never stop listening to the notification. Each time the notification is posted, the object will react to it. If the user repeats an action that creates the object in question, there will be multiple instances alive. All those instances responding to the notification and stepping into each other.

In such situations, a **crash might be the best thing that happens.**

Multiple leaked objects reacting to app notifications, altering the database, the UI, corrupting the entire state of the app. You can read about the importance of kind of problems in _“Dead programs tell no lies”_ in [The Pragmatic Programmer](https://www.goodreads.com/book/show/4099.The_Pragmatic_Programmer).

Leaks will undoubtedly lead to a bad UX and poor ratings in the App Store.

### Where do Leaks come from?

Leaks may come from a 3rd party SDK or framework for example. Even from classes created by Apple too like `CALayer` or `UILabel`. In those cases there isn’t much we can do, except waiting for an update or discarding the SDK.

But it is much more likely that leaks are introduced by us inour code. _The number one reason for leaks are_ **retain cycles**.

In order to avoid leaks, we must understand memory management and retain cycles.

### Retain Cycles

The word _retain_ comes from the Manual Reference Counting days in Objective-C. Before ARC and Swift and all the nice things we can do now with value types, there was Objective-C and MRC. You can read about MRC and ARC in [this article](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html).

Back in those days we needed to know a bit more about memory handling. Understanding the meaning of alloc, copy, retain and to how to balance those actions with opposites, like release, was crucial. The basic rule was: whenever you create an object, you own it and you are responsible for releasing it.

Now things are much easier, but still, there are some concepts that need to be learned.

In Swift, when an object has a strong association to another object, it is retaining it. When I say object I am talking about Reference Types, Classes basically.

Struct and Enums are _Value Types._ It is not possible to create retain cycles with value types only. When capturing and storing value types (structs and enums), there is no such thing as references. Values are copied, rather than referenced, although values can hold references to objects.

When an object references a second one, it owns it. The second object will stay alive until it is released. This is known as a **Strong Reference**. Only when you set the property to **nil** will the second object be destroyed.

```
class Server {
}

class Client {
    var server : Server //Strong association to a Server instance
    
    init (server : Server) {
        self.server = server
    }
}
```

Strong association.

If A retains B and B retains A there is a retain cycle.

A 👉 B + A 👈 B = 🌀

```
class Server {
    var clients : [Client] //Because this reference is strong
    
    func add(client:Client){
        self.clients.append(client)
    }
}

class Client {
    var server : Server //And this one is also strong
    
    init (server : Server) {
        self.server = server
        
        self.server.add(client:self) //This line creates a Retain Cycle -> Leak!
    }
}
```

A retain cycle.

In this example, it would be impossible to dealloc neither the client nor the server.

In order to be released from memory, an object must first release all its dependencies. Since the object itself is a dependency, it cannot be released. Again, _when an object has a retain cycle, it cannot die._

Retain cycles are broken when one of the references in the cycle is **weak or unowned.** The cycle must exist because it is required by the nature of the associations we are coding. The problem is that all the associations cannot be strong. One of them must be weak.

### How to break retain cycles

> Swift provides two ways to resolve strong reference cycles when you work with properties of class type: weak references and unowned references.
>
> Weak and unowned references enable one instance in a reference cycle to refer to the other instance _without_ keeping a strong hold on it. The instances can then refer to each other without creating a strong reference cycle.
>
> [Apple’s Swift Programming Language](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID48)

**Weak:** A variable can optionally not take ownership of an object it references to. A weak reference is when a variable does not take ownership of an object. **A weak reference can be nil.**

**Unowned**: Like weak references, an unowned reference does not keep a strong hold on the instance it refers to. Unlike a weak reference, however, an unowned reference is assumed to always have a value. Because of this, an unowned reference is always defined as a non-optional type. **An unowned reference cannot be nil.**

[When to Use Each:](https://krakendev.io/blog/weak-and-unowned-references-in-swift)

> Define a capture in a closure as an unowned reference when the closure and the instance it captures will always refer to each other, and will always be deallocated at the same time.
>
> Conversely, define a capture as a weak reference when the captured reference may become `nil` at some point in the future. Weak references are always of an optional type, and automatically become `nil` when the instance they reference is deallocated.
>
> [Apple’s Swift Programming Language](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html)

```
ass Parent {
    var child : Child
    var friend : Friend
    
    init (friend: Friend) {
        self.child = Child()
        self.friend = friend
    }
    
    func doSomething() {
        self.child.doSomething( onComplete: { [unowned self] in  
              //The child dies with the parent, so, when the child calls onComplete, the Parent will be alive
              self.mustBeAlive() 
        })
        
        self.friend.doSomething( onComplete: { [weak self] in
            // The friend might outlive the Parent. The Parent might die and later the friend calls onComplete.
              self?.mightNotBeAlive()
        })
    }
}
```

weak vs unowned references.

It is not rare to forget a `weak self` somewhere along the way while we code. We usually introduce leaks when we write block closures, like `flatMap` and `map` inside reactive code, or when we code observers, or delegates. In [this article](https://medium.com/@stremsdoerfer/understanding-memory-leaks-in-closures-48207214cba) you can read about leaks in closures.

### How to eliminate Memory Leaks?

1.  Don’t create them. Have a strong understanding of memory management. Have a strong [code-style](https://swift.org/documentation/api-design-guidelines/%5C) defined for your project and respect it. If you are tidy and respect your code-style, the absence of `weak self` will be noticeable. Core reviews can really help.
2.  Use [Swift Lint](https://github.com/realm/SwiftLint). It is a great tool that enforces you to adhere to a code style and keep rule 1\. It helps you detect early issues at compile-time. Like delegate variable declarations that are not weak, becoming potential retain cycles.
3.  Detect leaks at run-time and make them visible. If you know how many instances of a certain object must be alive at a time, you can use [LifetimeTracker](https://github.com/krzysztofzablocki/LifetimeTracker). It is a great tool to have running in development mode.
4.  Profile the app frequently. The [memory analysis tools](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/CommonMemoryProblems.html) that come with XCode do an excellent job. See [this article](https://useyourloaf.com/blog/xcode-visual-memory-debugger/). Instruments used to be the way to go not a while ago and it is great tool too.
5.  Unit Test Leaks with [**SpecLeaks**](https://cocoapods.org/pods/SpecLeaks). This pod uses Quick and Nimble and lets you easily create tests for leaks. You can read about it in the following section.

### Unit Testing Leaks

Once we know how cycles and weak references work, we can write code to test for retain cycles. The idea is to use weak references to probe for cycles. With a weak reference to an object we can test if that object leaks or not.

> Because a weak reference does not keep a strong hold on the instance it refers to, it’s possible for that instance to be deallocated while the weak reference is still referring to it. Therefore, **ARC automatically sets a weak reference to** `**nil**` **when the instance that it refers to is deallocated.**

Let’s say we want to see if object `x` leaks. We can create a weak reference to it and call it `leakReferece.` If `x` is released from memory, ARC will set `leakReference` to nil. So, if `x` leaks, the `leakReferece` can never be nil.

```
func isLeaking() -> Bool {
   
    var x : SomeObject? = SomeObject()
  
    weak var leakReference = x
  
    x = nil
    
    if leakReference == nil {
        return false //Not leaking
    }
    else{
        return true //Leaking
    }
}
```

Testing if an object leaks.

If `x` is actually leaking, the weak variable `leakReference` will point to the leaked instance. On the other hand, if the object is not leaking, after setting it to nil, it should not exist anymore. In that case, `leakReference` will be nil.

“Swift by Sundell” wrote a detailed explanation of different kinds of leaks [in this article](https://www.swiftbysundell.com/posts/using-unit-tests-to-identify-avoid-memory-leaks-in-swift). That post was really helpful for me to write this article and SpecLeaks too. Another [nice article](https://medium.com/wolox-driving-innovation/how-to-automatically-detect-a-memory-leak-in-ios-769b7bb1ec7c) that follows a similar approach.

Based on this notion, I have created SpecLeaks, an extension of Quick and Nimble that allows you to test for leaks. The idea is to code unit test for leaks without having to write much boilerplate code.

### SpecLeaks

Quick and Nimble is a great combination to write unit tests in a more humanly readable fashion. [SpecLeaks](https://cocoapods.org/pods/SpecLeaks) is only a few additions to those frameworks that will let you create unit tests to see if objects are leaking.

If you don’t know about unit testing, this screenshot might give you a hint of what it does:

![](https://cdn-images-1.medium.com/max/1000/1*i8K2uBxYToiym52MvIrFFQ.png)

You can create a set of tests that will instantiate objects and try things on them. You define what to expect and if the results are as expected, the test will pass, green. If the outcomes are not what you defined as expected, the test fails in red.

#### **Testing for leaks in initialization**

The simplest test you can write to see if an object is leaking. Just instantiate the object and see if it leaks. Sometimes, objects register as observers, or have delegates, or register to notifications. For those cases, this kind of test can detect a few leaks:

```
describe("UIViewController"){
    let test = LeakTest{
        return UIViewController()
    }

    describe("init") {
        it("must not leak"){
            expect(test).toNot(leak())
        }
    }
}
```

Testing initialization

#### Testing for Leaks in View Controllers

A view controller might start leaking right away when its view is loaded. After that, a million things can happen, but with this simple test you can ensure that your viewDidLoad is not leaking.

```
describe("a CustomViewController") {
    let test = LeakTest{
        let storyboard = UIStoryboard.init(name: "CustomViewController", bundle: Bundle(for: CustomViewController.self))
        return storyboard.instantiateInitialViewController() as! CustomViewController
    }

    describe("init + viewDidLoad()") {
        it("must not leak"){
            expect(test).toNot(leak())
            //SpecLeaks will detect that a view controller is being tested 
            // It will create it's view so viewDidLoad() is called too
        }
    }
}
```

Testing init + viewDidLoad on a view controller.

Using _SpecLeaks_ you don’t need to manually call `view` on the view controller in order for `viewDidLoad` to be called. SpecLeaks will do that for you when you are testing a `UIViewController` subclass.

#### Testing for Leaks when a method is called

Sometimes it’s not enough to instantiate an object to see if it leaks. It might start leaking when a method is called. For such cases, you can test if an object leaks when an action is executed, like this:

```
describe("doSomething") {
    it("must not leak"){
        
        let doSomething : (CustomViewController) -> () = { vc in
            vc.doSomething()
        }

        expect(test).toNot(leakWhen(doSomething))
    }
}
```

Test if CustomViewController leaks when `doSomething` is called.

### To wrap it up

Leaks are problematic. They pave the way for poor UX, crashes and bad reviews in the App Store. We need to eliminate them. A strong code style, good practices, understanding memory management and unit testing will help.

Unit Testing will not guarantee the absence of leaks though. You will never cover all the permutations of method calls and states. Testing the whole spectrum of interactions with an object might be just impossible. Also, it is often necessary to mock dependencies. And the original dependencies might be the ones leaking.

Unit Testing will decrease the chances of leaking. It is quite easy to test and to spot leaks in closures with [**SpeakLeaks**](https://cocoapods.org/pods/SpecLeaks). Like `flatMap` or any other escaping closure that retains `self`. The same if you forget to declare a delegate as weak.

I use RxSwift a lot, and flatMap, map, subscribe and others require to pass closures. For such cases, the absence of weak/unowned often will create leaks that can be detected with SpecLeaks quite easily.

Personally, I am trying to add this kind of tests to all my classes. Whenever I create a view controller, for example, I just add a Spec for it. Sometimes view controllers contain leaks in view loading, and those can be quickly caught with this kind of testing.

What do you think? Do you write unit tests for memory leaks? Do you write tests at all?

I hope you enjoy reading this article, send me a line with your opinion or questions! And feel free to try SpeakLeaks :)

* * *

Thanks to [Flawless App](https://medium.com/@FlawlessApp?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
