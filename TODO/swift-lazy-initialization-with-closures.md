> * 原文地址：[Swift Lazy Initialization with Closures](https://blog.bobthedeveloper.io/swift-lazy-initialization-with-closures-a9ef6f6312c)
> * 原文作者：[Bob Lee](https://blog.bobthedeveloper.io/@bobthedev?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：


# Swift Lazy Initialization with Closures #

## Learn how to create objects with modularity and readability ##

![](https://cdn-images-1.medium.com/max/2000/1*KNmIy5QAOeokXPW86TtVyA.png)

Magic Keyboard 2 and Magic Mouse 2

*Welcome my lovely readers. Good to see you here today. For those who are new, I’m Bob. Just for real quick, if you wish to be on my mailing list, you can sign up* [*here*](https://boblee.typeform.com/to/oR9Nt2) *and get more value for your learning with iOS development :)*

### Motivation ###

In the beginning of my iOS journey, I followed tutorials on YouTube. I saw a few using something like below to create UI objects.

```
let makeBox: UIView = {
 let view = UIView()
 return view
}()
```

As a learner, I copied the practice and used it. One day, however, one of my readers asked me, “why do you add `{}` and why does `()` exist at the end? Is it a computed property?” I could not answer. I was a zombie.

I wrote this tutorial for my younger self. Yet, some may find it useful.

### Objectives ###

There are three objectives. First, understand how to initialize an object using the unconventional way as shown above. Second, learn when to use `lazy var` in Swift. Last, join my mailing list.

#### Prerequisites ####

To fully enjoy the ride with me, I highly recommend you to be familiar with the topics below.

1. [*Closures*](https://blog.bobthedeveloper.io/no-fear-closure-in-swift-3-with-bob-72a10577c564)
2. [*Capture List and retention cycle [weak self]*](https://blog.bobthedeveloper.io/swift-retention-cycle-in-closures-and-delegate-836c469ef128)
3. *Descent Object Oriented Programming*

### Create UI Components ###

Before I explain the unconventional method above, let’s look into your past. In order to create a button in Swift, you probably have done something like this,

```
// Determine Size
let buttonSize = CGRect(x: 0, y: 0, width: 100, height: 100)

// Create Instance
let bobButton = UIButton(frame: buttonSize)
bobButton.backgroundColor = .black
bobButton.titleLabel?.text = "Bob"
bobButton.titleLabel?.textColor = .white
```

This is *Okay.*

Assume, you have to create three other buttons, you probably have to copy the code above and then change the name from `bobButton` to `bobbyButton`.

It’s quite tedious.

```
// New Button 
let bobbyButton = UIButton(frame: buttonSize)
bobbyButton.backgroundColor = .black
bobbyButton.titleLabel?.text = "Bob"
bobbyButton.titleLabel?.textColor = .white
```

To make things just a bit easier, you may

![](https://cdn-images-1.medium.com/max/800/1*oDIPy0i4YzUnKVR4XYI4kg.gif)

This works too with the keyboard shortcut: ctrl-cmd-e

If you don’t wish to repeat yourself, you may create a function instead.

```
func createButton(enterTitle: String) -> UIButton {
 let button = UIButton(frame: buttonSize)
 button.backgroundColor = .black
 button.titleLabel?.text = enterTitle
 return button
}

createButton(enterTitle: "Yoyo") //  👍
```

However, in iOS development, it is rare that custom buttons look similar. Therefore, a function may require a lot more parameters including background color, title, border radius, shadow, and so on. You function may end up looking like,

```
func createButton(title: String, borderWidth: Double, backgrounColor, ...) -> Button 
```

The code above is not ideal even if you add default parameters to the function. It decreases readability. Therefore, it’s better to stay with the tedious method above.

But, is there any way we can make it less tedious and more organized? Of course. We’ve looked into your past — It’s time to step up and look into your future.

### Introducing the Unconventional Way ###

Before we create UI components with the unconventional way, let’s first answer the initial questions my reader asked. What does `{}` mean, and is it a `computed property`?

*Nope, it’s just a* ***closure block***.

First, let’s demonstrate how to create an object using a closure. We will design a struct called `Human`.

```
struct Human {
 init() {
  print("Born 1996")
 }
}
```

Now, this is how you create an object with a closure

```
let createBob = { () -> Human in
 let human = Human()
 return human
}

let babyBob = createBob() // "Born 1996"
```

*If the syntax above doesn’t look familiar to you, you may stop reading now, and go to* [*Fear No Closure with Bob*](https://blog.bobthedeveloper.io/no-fear-closure-in-swift-3-with-bob-72a10577c564) *, and bring some bullets.*

Just to explain, `createBob` is a closure whose type is `() -> Human`. You’ve created an instance called, `babyBob` by calling `createBob()` .

However, you had to create two constants: `createBob` and `babyBob`. What if you want to do everything in a single statement? Here you go.

```
let bobby = { () -> Human in
 let human = Human()
 return human
}()
```

Now, the closure block executes itself through adding `()` at the end and `bobby` now has a `Human` object attached. Pretty good stuff.

**You’ve learned how to initialize an object with a closure block.**

Now, let’s apply to creating an UI object which should be similar to the example right above.

```
let bobView = { () -> UIView in
 let view = UIView()
 view.backgroundColor = .black
 return view
}()
```

Great, we can make it shorter. In fact, we don’t need to specify the type of the closure block. Instead, all we have to do is specify the type of the instance, `bobView`, for example.

```
let bobbyView: **UIView** = {
 let view = UIView()
 view.backgroundColor = .black
 return view
}()
```

Swift is able to infer that the closure block is `() -> UIView` based on the keyword, `return`.

Now, take a look. The example right above should look identical to the “unconventional way” I feared.

### Benefits of Init with Closures ###

We discussed the tediousness of creating objects and the problem that arises from using a function. In your head, you must be thinking, “why should I use a closure block instead?”

#### Easy to Duplicate ####

I don’t like to use Storyboard, I love copy and pasting UI objects. In fact, I’ve a “library” of code in my computer. Let us assume that there is a button as shown below in the library.

```
let myButton: UIButton = {
 let button = UIButton(frame: buttonSize)
 button.backgroundColor = .black
 button.titleLabel?.text = "Button"
 button.titleLabel?.textColor = .white
 button.layer.cornerRadius = 
 button.layer.masksToBounds = true
return button
}()
```

All I have to do is copy the entire lines, and then just change the name of `myButton` to `newButton` for the usage. Had I not used the closure method, I probably had to change the name of `button` to `newButton` 7–8 times. We could use the Xcode shortcut above, but why not make it just simpler.

#### Look Cleaner ####

Since objects are grouped together, it feels cleaner based on my eyes. Let’s compare

```
// Init with Closure 
let leftCornerButton: UIButton = {
 let button = UIButton(frame: buttonSize)
 button.backgroundColor = .black
 button.titleLabel?.text = "Button"
 button.titleLabel?.textColor = .white
 button.layer.cornerRadius = 
 button.layer.masksToBounds = true
return button
}()

let rightCornerButton: UIButton = {
 let button = UIButton(frame: buttonSize)
 button.backgroundColor = .black
 button.titleLabel?.text = "Button"
 button.titleLabel?.textColor = .white
 button.layer.cornerRadius = 
 button.layer.masksToBounds = true
return button
}()
```

vs

```
// Init With Fingers 
let leftCornerButton = UIButton(frame: buttonSize)
leftCornerButton.backgroundColor = .black
leftCornerButton.titleLabel?.text = "Button"
leftCornerButton.titleLabel?.textColor = .white
leftCornerButton.layer.cornerRadius = 
leftCornerButton.layer.masksToBounds = true

let rightCornerButton = UIButton(frame: buttonSize)
rightCornerButton.backgroundColor = .black
rightCornerButton.titleLabel?.text = "Button"
rightCornerButton.titleLabel?.textColor = .white
rightCornerButton.layer.cornerRadius = 
rightCornerButton.layer.masksToBounds = true
```

Although creating an object with the closure add a couple lines more, I feel less overwhelmed since I only have to add attributes to `button` rather than `rightCornerButton` or `leftCornerButton`.

*In fact, if the name of a button gets more descriptive, often times it requires fewer lines to create an object with a closure block.*

**You’ve accomplished the first objective. Congratulations**

### Lazy Init Application ###

You’ve come a long way. It’s time to meet the second objective of this tutorial.

You might have seen something like this below

```
class IntenseMathProblem {
 lazyvar complexNumber: Int = {
  // imagine it requires a lot of CPU
  1 * 1
 }()
}
```

What `lazy` allows you to do is, the `complexNumber` property will be only calculated when you try to access it. For example,

```
let problem = IntenseMathProblem 
problem()  // No value for complexNumber 
```

Currently, there is no value for `complexNumber`. However, once you access the property,

```
problem().complexNumber // Now returns 1
```

The `lazy var` is often used to sort database and fetch data from any backend services because you definitely don’t want to calculate and sort everything when you create an object.

*In fact, your phone will crash since the object is super bloated and the RAM can’t handle.*

### Application ###

Below is just an application of `lazy var`.

#### Sorting ####

```
class SortManager {
 lazy var sortNumberFromDatabase: [Int] = {
  // Sorting logic
  return [1, 2, 3, 4]
 }()
}
```

#### Image Compression ####

```
class CompressionManager {
 lazy var compressedImage: UIImage = {
  let image = UIImage()
  // Compress the image
  // Logic
  return image
 }()
}
```

### Rules with `Lazy` ###

1. You can’t use `lazy` with `let` since there is no initial value, and it is attained later when it is accessed.
2. You can’t use it with a `computed property` since computed property is always recalculated (requires CPU) when you modify any of the variables that has a relationship with the `lazy` property.
3. `Lazy` is only valid for members of a struct or class

### Does Lazy Capture? ###

So, if you’ve read the previous article on [Retention Cycle in Closures and Delegate](https://blog.bobthedeveloper.io/swift-retention-cycle-in-closures-and-delegate-836c469ef128) , you might wonder. Let’s test it out. Create a class called `BobGreet`. It has two properties: `name` whose type is `String` and `greeting` whose type is also `String` but initialized with a closure block.

```
class BobGreet {
 var name = "Bob the Developer"
 lazy var greeting: String = {
  return "Hello, \(self.name)"
 }()

deinit { 
  print("I'm gone, bruh 🙆&zwj;")}
 }
}
```

The closure block *might* have a strong reference to `BobGuest` but let’s attempt to deallocate.

```
var bobGreet: BobGreet? = BobClass()
bobGreet?.greeting
bobClass = nil // I'm gone, bruh 🙆&zwj;
```

No need to worry about `[unowned self]` The closure block does not have a reference to the object. Instead, it just copies `self` within the closure block. If you are confused by the previous statement, feel free to read [Swift Capture Lists](https://blog.bobthedeveloper.io/swift-capture-list-in-closures-e28282c71b95) to learn more. 👍

### Last Remarks ###

I learned a quite a bit while preparing for this tutorial. I hope you did as well. I’d appreciate your genuine fat ❤️. But, there is just one more. As the last objective, if you wish to on my mailing list and receive greater value from me, you can sign up right [**here**](https://boblee.typeform.com/to/oR9Nt2) .

As you can see by the cover photo, I recently bought Magic Keyboard and Mouse. They are pretty good and increase my productivity a lot. You can get the mouse [here](http://amzn.to/2noHxgl)  or the keyboard [here](http://amzn.to/2noHxgl). I never regret despite the price. 😓

> [Source Code](https://github.com/bobthedev/Blog_Lazy_Init_with_Closures) 

### Swift Conference I Will Join ###

I will be joining my first conference @[SwiftAveir](https://twitter.com/SwiftAveiro) o from June 1–2. A friend of mine, [Joao](https://twitter.com/NSMyself) , is helping organize the conference, so I’m super excited. You can learn more about the event [here](http://swiftaveiro.xyz) !

#### Recommended Articles ####

> Intro to Functional Programming ([Blog](https://blog.bobthedeveloper.io/intro-to-swift-functional-programming-with-bob-9c503ca14f13))

> My Favorite Xcode Shortcuts ([Blog](https://blog.bobthedeveloper.io/intro-to-swift-functional-programming-with-bob-9c503ca14f13) )

### Bob the Developer ###

I’m an iOS instructor from Seoul, 🇰🇷. Feel free to get to know me on [Instagram](https://instagram.com/bobthedev) . I post regular updates on [Facebook Page](https://facebook.com/bobthedeveloper)  and 🖨 on Sat 8pm EST.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
