> * 原文地址：[Dynamic Features in Swift](https://www.raywenderlich.com/5743-dynamic-features-in-swift)
> * 原文作者：[Mike Finney](https://www.raywenderlich.com/u/finneycanhelp)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dynamic-features-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dynamic-features-in-swift.md)
> * 译者：
> * 校对者：

# Dynamic Features in Swift

> In this tutorial, you’ll learn to use dynamic features in Swift to write clean code, create code clarity and resolve unforeseen issues quickly.

As a busy Swift developer, you have needs that are specific to your world yet common to all. You want to create clean-looking code, learn what’s going on in your code at a glance and resolve unforeseen issues quickly.

This tutorial ties together the dynamic and flexible parts of Swift to meet those needs. Using the latest Swift technology, you’ll learn how to customize output to your console, hook into third-party object state changes, and use some sweet syntactical sugar to write cleaner code.

Specifically, you will learn about:

*   `Mirror`
*   `CustomDebugStringConvertible`
*   Key-value Observing with Key Paths
*   Dynamic Member Lookup
*   Related technologies

Most of all, you’ll have a doggone good time!

This tutorial requires Swift 4.2 or later. Until Xcode 10 is released, you must [download the latest Xcode 10 Beta](https://developer.apple.com/download/) or install the latest [Swift 4.2 snapshot](https://swift.org/download/#snapshots).

Also, you must have an understanding of basic Swift types. The [Getting to Know Enums, Structs and Classes in Swift](https://www.raywenderlich.com/119881/enums-structs-and-classes-in-swift) tutorial is a great place to start. Although not strictly required, you may want to look into [Implementing Custom Subscripts in Swift](https://www.raywenderlich.com/123102/implementing-custom-subscripts-swift) as well.

## Getting Started

Before doing anything, download the starter and final projects by clicking on the _Download Materials_ button at the top or the bottom of the tutorial. Unzip the downloaded file.

You’ll be happy to know that all the code you need to let you focus on learning the dynamic features of Swift is already written for you! Like walking with a friendly guide dog, this tutorial will guide you through everything in the starter code.

![](https://koenig-media.raywenderlich.com/uploads/2018/06/smiling_dog_small.jpg)

Happy Dog

In the starter code directory named _DynamicFeaturesInSwift-Starter_, you’ll see three playground pages: _DogMirror_, _DogCatcher_ and _KennelsKeyPath_. The playground is set to run on macOS. This tutorial is platform-agnostic and only focuses on the Swift language.

## Reflecting on Mirror and Debug Output

Whether you’re tracking down an issue or just exploring running code, uncluttered information in the console makes all the difference. Swift offers many ways of customizing console output and capturing crucial events. For customizing output, it doesn’t get any deeper than Mirror. Swift offers more power than the strongest sled dog to pull you out of the icy cold land of confusion!

![](https://koenig-media.raywenderlich.com/uploads/2018/06/siberian_husky_small.jpg)

Siberian Husky Sled Dogs

Before learning more about `Mirror`, you’ll first write some customized console output for a type. This will help you more clearly see what’s going on.

### CustomDebugStringConvertible

Open _DynamicFeaturesInSwift.playground_ in Xcode and go to the **DogMirror** page.

In honor of all those cute little dogs that get lost, caught by a dog catcher and then reunited with their owners, this page has a `Dog` class and `DogCatcherNet` class. Focus on the `DogCatcherNet` first.

Since the lost doggies out there must be caught and reunited with their owners, dog catchers must be supported. The code you write in the following project will help dog catchers evaluate the quality of nets.

In the playground, look at the following:

```
enum CustomerReviewStars { case one, two, three, four, five }
```

```
class DogCatcherNet {
  let customerReviewStars: CustomerReviewStars
  let weightInPounds: Double
  // ☆ Add Optional called dog of type Dog here

  init(stars: CustomerReviewStars, weight: Double) {
    customerReviewStars = stars
    weightInPounds = weight
  }
}

```

```
let net = DogCatcherNet(stars: .two, weight: 2.6)
debugPrint("Printing a net: \(net)")
debugPrint("Printing a date: \(Date())")
print()

```

The `DogCatcherNet` has two properties: `customerReviewStars` and its `weightInPounds`. Customer review stars reflect the customers’ feelings about the net product. The weight in pounds tells the dog catchers what burden they will experience lugging a net around.

Run the playground. The first two lines you should see are similar to the following:

```
"Printing a net: __lldb_expr_13.DogCatcherNet"
"Printing a date: 2018-06-19 22:11:29 +0000"
```

As you can see, the debug output in the console prints something related to a net and a date. Bless its heart; the output from the code looks like it was made by a robotic pet. This pet tried hard, but it needs help from us humans. As you can see, it’s printing out extra information such as “__lldb_expr_.” Printing out the date provides something more useful. It’s up in the air as to whether or not this is enough to help you track down a problem that’s been dogging you.

To increase your chances of success, you need to apply some console output customization basics using `CustomDebugStringConvertible` magic. In the playground, add the following code right under _☆ Add Conformance to CustomDebugStringConvertible for DogCatcherNet here_:

```
extension DogCatcherNet: CustomDebugStringConvertible {
  var debugDescription: String {
    return "DogCatcherNet(Review Stars: \(customerReviewStars),"
      + " Weight: \(weightInPounds))"
  }
}

```

For something small like `DogCatcherNet`, a type can conform to `CustomDebugStringConvertible` and provide its own debug description using the `debugDescription` property.

Run the playground. Except for a date value difference, the first two lines should include:

```
"Printing a net: DogCatcherNet(Review Stars: two, Weight: 2.6)"
"Printing a date: 2018-06-19 22:10:31 +0000"
```

For a larger type with many properties, this approach comes with the cost of explicit boilerplate to type. That’s not a problem for one with dogged determination. If short on time, there are other options such as `dump`.

### Dump

How to avoid needing to add boilerplate code manually? One solution is to use `dump`. `dump` is a generic function that prints out all the names and values of a type’s properties.

The playground already contains calls that dump out the net and `Date`. The code looks like this:

```
dump(net)
print()

dump(Date())
print()
```

Run the playground. The console output looks something like:

```
▿ DogCatcherNet(Review Stars: two, Weight: 2.6) #0
  - customerReviewStars: __lldb_expr_3.CustomerReviewStars.two
  - weightInPounds: 2.6

▿ 2018-06-26 17:35:46 +0000
  - timeIntervalSinceReferenceDate: 551727346.52924
```

Due to the work you’ve done so far with `CustomDebugStringConvertible`, the `DogCatcherNet` looks better than it otherwise would. The output contains:

```
DogCatcherNet(Review Stars: two, Weight: 2.6)
```

`dump` also spits out each property automatically. Great! It’s time to make those properties more readable by using Swift’s `Mirror`.

### Swift Mirror

![](https://koenig-media.raywenderlich.com/uploads/2018/06/mirror_dog_small.jpg)

Mirror, mirror, on the wall. Who’s the fairest dog of them all?

`Mirror` lets you display values of any type instance through the playground or the debugger at runtime. In short, `Mirror`‘s power is introspection. Introspection is a subset of [reflection](https://developer.apple.com/documentation/swift/swift_standard_library/debugging_and_reflection).

### Creating a Mirror-Powered Dog Log

It’s time to create a Mirror-powered dog log. To help with debugging, it’s ideal to display the values of the net to the console through a log function with custom output complete with emoticons. The log function should be able to handle any item you pass it.

### Creating a Mirror

It’s time to create a log function that uses a mirror. To start, add the following code right under _☆ Create log function here_:

```
func log(itemToMirror: Any) {
  let mirror = Mirror(reflecting: itemToMirror)
  debugPrint("Type: 🐶 \(type(of: itemToMirror)) 🐶 ")
}
```

This creates the mirror for the passed-in item. A mirror lets you iterate over the parts of an instance.

Add the following code to the end of the `log(itemToMirror:)`:

```
for case let (label?, value) in mirror.children {
  debugPrint("⭐ \(label): \(value) ⭐")
}
```

This accesses the `children` property of the mirror, gets each label-value pair, then prints them out to the console. The label-value pair is type-aliased as `Mirror.Child`. For a `DogCatcherNet` instance, the code iterates over the properties of a net object.

To clarify, a child of the instance being inspected has nothing to do with a superclass or subclass hierarchy. The children accessible through a mirror are just the parts of the instance being inspected.

Now, it’s time to call your new log method. Add the following code right under _☆ Log out the net and a Date object here_:

```
log(itemToMirror: net)
log(itemToMirror: Date())
```

Run the playground. You’ll see at the bottom of the console output some doggone great output:

```
"Type: 🐶 DogCatcherNet 🐶 "
"⭐ customerReviewStars: two ⭐"
"⭐ weightInPounds: 2.6 ⭐"
"Type: 🐶 Date 🐶 "
"⭐ timeIntervalSinceReferenceDate: 551150080.774974 ⭐"
```

This shows all the properties’ names and values. The names appear as they do in your code. For example, `customerReviewStars` is literally how the property name is spelled in code.

### CustomReflectable

What if you wanted more of a dog and pony show in which the property names are displayed more clearly as well? What if you didn’t want some of the properties displayed? What if you wanted items displayed that are not technically part of the type? You’d use `CustomReflectable`.

`CustomReflectable` provides the hook with which you can specify what parts of a type instance are shown by using a custom `Mirror`. To conform to `CustomReflectable`, a type must define the `customMirror` property.

After speaking with several dog catcher programmers, you’ve discovered that spitting out the `weightInPounds` of the net has not helped with debugging. However, the `customerReviewStars` information is extremely helpful and they’d like the label for `customerReviewStars` to appear as “Customer Review Stars.” Now, it’s time to make `DogCatcherNet` conform to `CustomReflectable`.

Add the following code right under _☆ Add Conformance to CustomReflectable for DogCatcherNet here_:

```
extension DogCatcherNet: CustomReflectable {
  public var customMirror: Mirror {
    return Mirror(DogCatcherNet.self,
                  children: ["Customer Review Stars": customerReviewStars,
                            ],
                  displayStyle: .class, ancestorRepresentation: .generated)
  }
}
```

Run the playground and see the following output:

```
"Type: 🐶 DogCatcherNet 🐶 "
"⭐ Customer Review Stars: two ⭐"
```

_Where’s the Dog?_  
The whole point of the net is to handle having a dog. When the net is populated with a dog, there must be a way to pull out information about the dog in the net. Specifically, you need the dog’s name and age.

The playground page already has a `Dog` class. It’s time to connect `Dog` with `DogCatcherNet`. In the spot labeled as _☆ Add Optional called dog of type Dog here_, add the following property to `DogCatcherNet`:

```
var dog: Dog?
```

With the dog property added to the `DogCatcherNet`, it’s time to add the dog to the `customMirror` for the `DogCatcherNet`. Add the following dictionary entries right after the line `children: ["Customer Review Stars": customerReviewStars,`:

```
"dog": dog ?? "",
"Dog name": dog?.name ?? "No name"
```

This will output the dog using its default debug description and dog’s name, respectively labeled “dog” and “Dog name.”

Time to gently put a dog into the net. Right under _☆ Uncomment assigning the dog_, uncomment that line so the cute little dog is put into the net:

```
net.dog = Dog() // ☆ Uncomment out assigning the dog
```

Run the playground and see the following:

```
"Type: 🐶 DogCatcherNet 🐶 "
"⭐ Customer Review Stars: two ⭐"
"⭐ dog: __lldb_expr_23.Dog ⭐"
"⭐ Dog name: Abby ⭐"
```

_Mirror Convenience_  
It’s pretty nice to be able to see everything. However, there are those times when you just want to pluck out a part from a mirror. To do that, you use [`descendant(_:_:)`](https://developer.apple.com/documentation/swift/mirror/1540759-descendant). Add the following code to the end of the playground page to create a mirror and use `descendant(_:_:)` to pluck out the name and age:

```
let netMirror = Mirror(reflecting: net)

print ("The dog in the net is \(netMirror.descendant("dog", "name") ?? "nonexistent")")
print ("The age of the dog is \(netMirror.descendant("dog", "age") ?? "nonexistent")")
```

Run the playground and see at the bottom of the console output:

```
The dog in the net is Bernie
The age of the dog is 2
```

That’s doggone dynamic introspection there. It can be quite useful for debugging your own types! Having deeply explored `Mirror`, you’re done with _DogMirror.xcplaygroundpage_.

### Wrapping Up Mirror and Debug Output

There are many ways to track, like a bloodhound, what’s going on in a program. `CustomDebugStringConvertible`, `dump` and `Mirror` let you see more clearly what you are hunting for. Swift’s introspection power is highly useful — especially as you start building bigger and more complex applications!

## Key Paths

On the subject of tracking what’s going on in a program, Swift has something wonderful called key paths. For capturing an event such as when a value has changed in a third-party library object, look `to KeyPath`‘s `observe` for help.

In Swift, key paths are strongly typed paths whose types are checked at compile time. In Objective-C, they were only strings. The tutorial [What’s New in Swift 4?](https://www.raywenderlich.com/163857/whats-new-swift-4) does a great job covering the concepts in the Key-Value Coding section.

There are several different types of `KeyPath`. Commonly discussed types include [KeyPath](https://developer.apple.com/documentation/swift/keypath), [WritableKeyPath](https://developer.apple.com/documentation/swift/writablekeypath) and [ReferenceWritableKeyPath](https://developer.apple.com/documentation/swift/referencewritablekeypath). Here’s a summary of the different ones:

*   `KeyPath`: Specifies a root type on a specific value type.
*   `WritableKeyPath`: A KeyPath whose value you can also write to. It doesn’t work with classes.
*   `ReferenceWritableKeyPath`: A WritableKeyPath used for classes since classes are reference types.

A practical example of using a key path is in observing or capturing when a value changes on an object.

When you encounter a bug involving a third-party object, there is immense power in knowing when the state of that object changes. Beyond debugging, sometimes it just makes sense to hook up your custom code to respond when a value changes in a third-party object such as Apple’s UIImageView object. In [Design Patterns on iOS using Swift – Part 2/2](https://www.raywenderlich.com/160653/design-patterns-ios-using-swift-part-22), you can learn more about the observer pattern in the section titled _Key-Value Observing (KVO)_.

However, there’s a use case here related to the kennels that fits right into our doggy world. Without this KVO power, how would dog catchers easily know when the kennels are available to put more dogs inside? Although many dog catchers would just love to take home each and every lost dog they find, it’s just not practical.

So dog catchers who just want to help dogs find their way home need to know when the kennels are available to place dogs into. The first step to making this possible is creating a key path. Open the _KennelsKeyPath_ page and, right after _☆ Add KeyPath here_, add this:

```
let keyPath = \Kennels.available
```

This is how you create a `KeyPath`. You use a backslash on the type, followed by a chain of dot-separated properties — in this case, one property deep. To use the `KeyPath` to observe changes to the `available` property, add the following code after _☆ Add observe method call here_:

```
kennels.observe(keyPath) { kennels, change in
  if (kennels.available) {
    print("kennels are available")
  }
}
```

Click run and see the following message output to the console:

```
Kennels are available.
```

This approach can also be great for figuring out when a value has changed. Imagine being able to debug state changes to third-party objects! Nailing down when an item of interest changes can really keep you from barking up the wrong tree.

You’re done with the _KennelsKeyPath_ page!

## Understanding Dynamic Member Lookup

If you’ve been keeping up with Swift 4.2 changes, you may have heard about _Dynamic Member Lookup_. If not, you’ll go beyond just learning the concept here.

In this part of the tutorial, you’ll see the power of _Dynamic Member Lookup_ in Swift by going over an example of how to create a real JSON DSL (Domain Specification Language) that allows the caller to use dot notation to access values from a JSON dictionary.

_Dynamic Member Lookup_ empowers the coder to use dot syntax for properties that don’t exist at compile time as opposed to messier ways. In short, you’re coding on faith that the members will exist at runtime and getting nice-to-read code in the process.

As mentioned in the [proposal for this feature](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md) and [associated conversations in the Swift community](https://forums.swift.org/t/se-0195-introduce-user-defined-dynamic-member-lookup-types/8658/10), this power offers great support for interoperability with other languages such as Python, database implementors and creating boilerplate-free wrappers around “stringly-typed” APIs such as CoreImage.

### Introducing @dynamicMemberLookup

Open the _DogCatcher_ page and review the code. In the playground, `Dog` represents the way a dog is running with `Direction`.

With the `dynamicMemberLookup` power, `directionOfMovement` and `moving` can be accessed even though those properties don’t explicitly exist. It’s time to make `Dog` dynamic.

### Adding dynamicMemberLookup to the Dog

The way to activate this dynamic power is through the use of the type attribute `@dynamicMemberLookup`.

Add the following code under _☆ Add subscript method that returns a Direction here_:

```
subscript(dynamicMember member: String) -> Direction {
  if member == "moving" || member == "directionOfMovement" {
    // Here's where you would call the motion detection library
    // that's in another programming language such as Python
    return randomDirection()
  }
  return .motionless
}
```

Now add `dynamicMemberLookup` to `Dog` by uncommenting the line that’s marked _☆ Uncomment this line_ above `Dog`.

You can now access a property named `directionOfMovement` or `moving`. Give it a try by adding the following on the line after _☆ Use the dynamicMemberLookup feature for dynamicDog here_:

```
let directionOfMove: Dog.Direction = dynamicDog.directionOfMovement
print("Dog's direction of movement is \(directionOfMove).")

let movingDirection: Dog.Direction = dynamicDog.moving
print("Dog is moving \(movingDirection).")
```

Run the playground. With the values sometimes being _left_ and sometimes being _right_, the first two lines you should see are similar to:

```
Dog's direction of movement is left.
Dog is moving left.
```

### Overloading subscript(dynamicMember:)

Swift supports [overloading subscript declarations](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/Declarations.html#//apple_ref/doc/uid/TP40014097-CH34-ID379) with different return types. Try this out by adding a `subscript` that returns an `Int` right under _☆ Add subscript method that returns an Int here_:

```
subscript(dynamicMember member: String) -> Int {
  if member == "speed" {
    // Here's where you would call the motion detection library
    // that's in another programming language such as Python.
    return 12
  }
  return 0
}
```

Now, you can access a property named `speed`. Speed to victory by adding the following under `movingDirection` that you added earlier:

```
let speed: Int = dynamicDog.speed
print("Dog's speed is \(speed).")
```

Run the playground. The output should contain:

```
Dog's speed is 12.
```

Pretty nice, huh? That’s a powerful feature that keeps the code looking nice even if you need to access other programming languages such as Python. As hinted at earlier, there’s a catch…

![](https://koenig-media.raywenderlich.com/uploads/2018/06/dog_ears_perk_up2_small.jpg)

“A catch?” I’m all ears.

### Compiler and Code Completion Gone to the Dogs

In exchange for this dynamic runtime feature, you don’t get the benefits of compile-time checking of properties that depend on the `subscript(dynamicMember:)` functionality. Also, Xcode’s code completion feature can’t help you out either. However, the good news is that professional iOS developers read more code than they write.

The syntactic sugar that _Dynamic Member Lookup_ gives you is nothing to just throw away. It’s a nice feature that makes certain specific use cases of Swift and language interoperability bearable and enjoyable to view.

### Friendly Dog Catcher

The original proposal for _Dynamic Member Lookup_ addressed language interoperability, particularly with Python. However, that’s not the only circumstance where it’s useful.

To demonstrate a pure Swift use case, you’re going to work on the `JSONDogCatcher` code found in _DogCatcher.xcplaygroundpage_. It’s a simple struct with a few properties designed to handle `String`, `Int` and JSON dictionary. With a struct like this, you can create a `JSONDogCatcher` and ultimately go foraging for specific `String` or `Int` values.

_Traditional Subscript Method_  
A traditional way of drilling down into a JSON dictionary with a struct like this is to use a `subscript` method. The playground already contains a traditional `subscript` implementation. Accessing the `String` or `Int` values using the `subscript` method typically looks like the following and is also in the playground:

```
let json: [String: Any] = ["name": "Rover", "speed": 12,
                          "owner": ["name": "Ms. Simpson", "age": 36]]

let catcher = JSONDogCatcher.init(dictionary: json)

let messyName: String = catcher["owner"]?["name"]?.value() ?? ""
print("Owner's name extracted in a less readable way is \(messyName).")
```

Although you have to look past the brackets, quotes and question marks, this works.

Run the playground. You can now see the following:

```
Owner's name extracted in a less readable way is Ms. Simpson.
```

Although it works fine, it would be easier on the eyes to just use dot syntax. With _Dynamic Member Lookup_, you can drill down a multi-level JSON data structure.

_Adding dynamicMemberLookup to the Dog Catcher_  
Like `Dog`, it’s time to add the `dynamicMemberLookup` attribute to the `JSONDogCatcher` struct.

Add the following code right under _☆ Add subscript(dynamicMember:) method that returns a JSONDogCatcher here_:

```
subscript(dynamicMember member: String) -> JSONDogCatcher? {
  return self[member]
}
```

The `subscript(dynamicMember:)` method calls the already existing `subscript` method but takes away the boilerplate code of using brackets and `String` keys. Now, uncomment the line which has _☆ Uncomment this line_ above `JSONDogCatcher`:

```
@dynamicMemberLookup
struct JSONDogCatcher {
```

With that in place, you can use dot notation to get the dog’s speed and owner’s name. Try it out by adding the following right under _☆ Use dot notation to get the owner’s name and speed through the catcher_:

```
let ownerName: String = catcher.owner?.name?.value() ?? ""
print("Owner's name is \(ownerName).")

let dogSpeed: Int = catcher.speed?.value() ?? 0
print("Dog's speed is \(dogSpeed).")
```

Run the playground. See the speed and the owner’s name in the console:

```
Owner's name is Ms. Simpson.
Dog's speed is 12.
```

Now that you have the owner’s name, the dog catcher can contact the owner and let her know her dog has been found!

What a happy ending! The dog and its owner are together again and the code looks cleaner. Through the power of dynamic Swift, this dynamic dog can go back to chasing bunnies in the backyard.

![](https://koenig-media.raywenderlich.com/uploads/2018/06/bunny_small.jpg)

Simpson’s dog loves chasing but not catching

## Where to Go From Here?

You can download the completed version of the project using the _Download Materials_ button at the top or bottom of this tutorial.

In this tutorial, you harnessed the dynamic power that Swift offers in version 4.2. You learned about Swift’s introspective reflection powers such as `Mirror`, customizing console output, hooking into _Key-Value Observing with KeyPaths_ and _Dynamic Member Lookup_.

With that dynamic smorgasbord, you can clearly see helpful information, have more readable code and hook into some powerful runtime capabilities for your app or general purpose framework and library.

Sniffing around [Apple’s documentation about Mirror](https://developer.apple.com/documentation/swift/mirror) and related items is a worthy endeavor. For more about _Key-Value Observing_, have a look at [Design Patterns on iOS using Swift](https://www.raywenderlich.com/160651/design-patterns-ios-using-swift-part-12). Be sure to check out the [What’s New in Swift 4.2?](https://www.raywenderlich.com/194066/whats-new-in-swift-4-2) to see more of what’s in Swift 4.2.

In regards to the _Dynamic Member Lookup_ Swift 4.2 feature, it doesn’t hurt to look at the Swift proposal [SE-0195: “Introduce User-defined ‘Dynamic Member Lookup’ Types”](https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md) that introduces the `dynamicMemberLookup` type attribute and potential use cases. On a related note, a Swift proposal to keep an eye on is the close cousin of _Dynamic Member Lookup_ called [SE-216: “Introduce User-defined Dynamically ‘callable’ Types](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md) that introduces the `dynamicCallable` type attribute.

Have more to say or ask about the dynamic power of Swift? Join in on the forum discussion below!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
