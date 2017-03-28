> * 原文地址：[Swift Retention Cycle in Closures and Delegate](https://blog.bobthedeveloper.io/swift-retention-cycle-in-closures-and-delegate-836c469ef128#.8z0z62321)
> * 原文作者：[Bob Lee](https://blog.bobthedeveloper.io/@bobthedev?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Swift Retention Cycle in Closures and Delegate #

## Let’s understand [weak self], [unowned self] , and weak var ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*G9ICr1PGK9UexE3uAnavOQ.png">

Lost Ship

### Problem

When I encountered closures and delegate for the first time, I’ve noticed people put `[weak self]` in closures and `weak var` in front a delegate property. I’ve wondered why.

### Prerequisite

This isn’t a tutorial for beginners. The following list is what I expect from my readers to know.

1. *How to pass data between view controllers with Delegate*
2. *Memory management in Swift with ARC.*
3. Closures capture list
4. *Protocols as Type*

Don’t worry if you aren’t confident with the materials above. I’ve covered all of them in my previous articles and YouTube tutorials. You may find the required knowledge and my productive development tools in a single basket [here](https://learnswiftwithbob.com/RESOURCES.html).

### Objectives ###

First, you will learn why we use `weak var` in delegate. Second, you will learn when to use `[weak self]` and `[unowned self]` in closures.

*I like that the content is getting more advanced. We are growing together.*
 
### Retention Cycle in Delegate ###

First, let’s create a protocol called, `SendDataDelegate`.

    protocol SendDataDelegate: class {}

Second, let’s create a class called `SendingVC `with a property whose type is `SendDataDelegate?`.

    class SendingVC {
     var delegate: SendDataDelegate?
    }

Last, lets assign the delegate to another class.

    class ReceivingVC: SendDataDelegate {
     lazy var sendingVC: SendingVC = {
      let vc = SendingVC()
      vc.delegate = self // self refers to ReceivingVC object
      return vc
     }()

    deinit {
     print("I'm well gone, bruh")
     }
    }

*You might be baffled by the* `lazy` *init method. Well, you could do your own research or you can wait for my next article.*

Now, let’s create an instance.

    var receivingVC: ReceivingVC? = ReceivingVC()

#### Recap

First, `receivingVC` is an instance of `ReceivingVC()`. `ReceivingVC()` has a property, `sendingVC`.

Second, `sendingVC` is an instance of `SendingVC()`. `SendingVC()` has a property, `delegate`.

I’ve made a simple graph for you to visualize.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*xCtLEY2ud9Mq97S1tQPz4g.png">


Strong reference cycle and memory leak

*Make sure you are comfortable with the meaning of strong vs weak reference. If not, you may start with* [*Make Memory Management Great Again*](https://blog.bobthedeveloper.io/make-memory-management-great-again-f781fb29cea1#.2dv5zisgd).

There is a strong reference between `ReceivingVC` and `SendingVC`. Although `ReceivingVC` is referencing the `delegate` property, not `SendingVC`, **it is considered as referencing the object since you must have an object in order to access its methods and properties.**

If you attempt the following code below, nothing happens.

    var receivingVC = nil // not deallocated 

### Introducing weak var

The only thing that we need to do is, put `weak` in front of `var delegate`.

    class SendingVC {
     weak var delegate: SendDataDelegate?
    }

*There is no such thing as* `weak let` *. When you use* `weak`*, just like the delegate property above, the property should be optional and mutable in order to set it as*`nil`*or assign value to the* ` delegate` *property. Consequently,*`let` *is not allowed.*

Let’s see how it looks now.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*y87pKaXDgoT9EfEQDbLBmg.png">

var delegate has a weak reference to ReceivingVC

Let’s attempt to get rid of it.

    receivingVC = nil 
    // "I'm well gone, bruh"

*You only need to use* `weak` *if the delegate is a class. Swift structs and enums are value types, not reference types, so they don't make strong reference cycles. If you are confused by the previous sentence, you may read* [*Intro to Protocol Oriented Programming*](https://blog.bobthedeveloper.io/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f)

**Congratulations! You’ve completed the first objective. Let’s move on.**

### Retention Cycle in Closures

Now, let’s look l the second objective. Our goal is to find out why we use `[weak self]` within a closure block. First, let’s create a class called, `BobClass`. It contains two properties whose types are `String` and `(() -> ())?`

    class BobClass {
     var bobClosure: (() -> ())? 
     var name = “Bob”

     init() {
      self.bobClosure = { print(“Bob the Developer”) }
     }

     deinit {
      print(“I’m gone... ☠️”)
     }

    }

Let us create an instance.

    var bobClass: BobClass? = BobClass()

Let us visualize.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*vyG--bpwZDKNLGFpfYLPCA.png">

No reference cycle. Unidirectional

*As you’ve noticed, the closure block is a separate entity from the entire class*

Let us destroy.

    bobClass = nil // I'm gone... ☠️

Everything works great. However, we don’t live in an ideal world. What if the closure block has a reference to the property?

    init() {
     self.bobClosure = { print("\(**self.name**) the Developer") }
    }

Let us visualize.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*VeT_-gsbNFhTvPa-JnA4UQ.png">

Strong reference cycle between the closure block and BobClass

Let us destroy

    bobClass = nil // Not deallocated 😱

It’s urgent. We need do something about it

### Capture List

There is one way for us to set the relationship “weak” from the closure block to the object (self). Let us introduce capture lists.

    self.bobClosure = { **[weak self]** in
     print("\(**self?**.name) the Developer")
    }

The closure block stole and copied the object (self). However, the closure had it `weak`.

Let us visualize.

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*Zq_QhNaclXkhIraYb2wTKQ.png">

Closure block has a weak reference to object, thus the property as well

*If you don’t understand what* `[]` *does within the closure above, you may read*[*Swift capture list*](https://blog.bobthedeveloper.io/swift-capture-list-in-closures-e28282c71b95#.hys3jq1jk) *and come back after.*

**There is something weird.**

All of a sudden, the `self` (object) became an optional type based on `**self?**.name`. Here is why. The closure should be able to break the reference (green arrow) by setting `self` as `nil` within the closure block because the relationship is `weak`. Therefore, Swift automatically converts the type of `self` as optional

Let’s attempt to deallocate

    bobClass = nil // I'm gone...☠️

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*R5nZJi9BngMeia-dQXyhUQ.png">

Good

**Congratulations, you’ve completed the second objective. But, there is just one more: *Unowned.***

### Unowned

Some of you guys be like, “There is one more? Come on, Bob”. Yeah, there is one more. You’ve come a long way. Let us finish strong.

`weak` and `unowned` are the same. Except one thing. Unlike `weak` we’ve seen, `unowned` does not automatically convert `self` as optional within the closure block.

For example, if I create a normal instance instead of an optional type,

    var neverNilClass: BobClass = BobClass()

There is no reason to use `weak` because if you do, the closure captures `self` as an optional type and you have to unwrap which is unnecessary like below.

    self.bobClosure = { [weak self] in

    guard let object = self else {
      return 
     }

    print("\(object.name) the Developer")
    }

Instead, if you are 100% sure that `self` will never be `nil`, then just use

    self.bobClosure = { [unowned self] in
     print("\(self.name) the Developer")
    }

> **That’s it.**

### Last Remarks

I hope you guys had fun! By the way, I recently changed the name of the publication from iOS Geek Community to Bob the Developer. There are two reasons. First, the name doesn’t match with the fact that I’m the only author. Second, I want to increase my personal brand to a point I want you guys to associate Swift with Bob the Developer.

If you’ve learned something new, I’d appreciate your gratitude by gently tapping the ❤️ below or left. I was thinking of not putting those graphics since it added a lot more time, but anything for my lovely Medium readers.

### Resources

> [The Resource Page for iOS Developers](https://learnswiftwithbob.com/RESOURCES.html)

> [Source Code](https://github.com/bobthedev/Blog_Reference_Cycle_Delegate_Closures)

### Bob the Developer

I work towards providing affordable education. I’ve started with teaching iOS Development. [bobthedeveloper.io](https://bobthedeveloper.io)[Facebook](https://facebook.com/bobthedeveloper), [Instagram](https://instagram.com/bobthedev), [YouTube](https://youtube.com/bobthedeveloper), [LinkedIn](https://linkedin.com/in/bobthedev)
