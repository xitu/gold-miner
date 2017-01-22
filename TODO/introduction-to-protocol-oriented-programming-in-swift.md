> * 原文地址：[Introduction to Protocol Oriented Programming in Swift](https://medium.com/ios-geek-community/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f#.ezvkbpy7o)
* 原文作者：[Bob Lee](https://medium.com/@bobleesj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Introduction to Protocol Oriented Programming in Swift #

## OOP is okay, but could’ve been better ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*5yuIezhfETFouNNTablgSA.jpeg">

Not me, but how it feels to use POP over OOP

#### Introduction ####

This tutorial is also written for those who have no clear answer to the fundamental difference between Classes and Structs. We all know there is no inheritance in Structs, but why?

If you don’t know the answer, take a couple seconds to read the code below. Again, please excuse me for its format. I tried to have it as concise as possible.

```
class HumanClass {
 var name: String
 init(name: String) {
 self.name = name } }
 
var classyHuman = HumanClass(name: "Bob")
classyHuman.name // "Bob"

var newClassyHuman = classyHuman // Created a "copied" object

newClassyHuman.name = "Bobby"
classyHuman.name // "Bobby"
```

When I changed the name property of newClassyHuman to “Bobby”, the name property of the original object, classyHuman, also changed to “Bobby”.

Now, let’s take a look at Structs

```
struct HumanStruct {
 var name: String }
 
var humanStruct = HumanStruct(name: "Bob" )
var newHumanStruct = humanStruct // Copy and paste

newHumanStruct.name = "Bobby"
humanStruct.name // "Bob"

```

Do you see the difference? The change to the name property of the copied object hasn’t affected the original humanStruct object.

In Classes, when you make a copy of a variable, both variables are referring to the same object in memory. A change to one of the variables will change the other (Reference Type). In Structs, however, you simply copy and paste variables by creating a separate object (Value Type)

If you didn’t get it, try to re-read the previous paragraph. If not, you can watch the video I made.

[Struct vs Class Lesson](https://www.youtube.com/watch?v=MNnfUwzJ4ig)

#### Bye OOP ####

You might be wondering why I talk about all these seemingly unrelated topics to Protocol Oriented Programming. But, before I talk about certain benefits of using POP over OOP, you just had to understand the difference between Reference type and Value type.

There are certainly benefits of using OOP, but the opposites as well.

1. When you subclass, you have to inherit properties and methods which you may not need. Your object becomes unnecessarily bloated.

2. When you make a lot of super classes, it becomes extremely hard to navigate between each class and fix bugs/edit.

3. Since objects are referencing to the same place in memory, if you make a copy and create a small change its property, it can f up the rest. (Mutability due to reference)

By the way, take a look at how the UIKit framework is written in OOP

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*hjEXB3PGUOSbxet0qUJRNA.png">

2015 WWDC_Hideous Structure

If you were to work at Apple as a software engineer for the first time, can you work with this code? I mean we developers have a hard time using it at the surface level.

*One said OOP is just a modulized way to write spaghetti code. If you want to find more bad things about OOP, here are* [*rant 1*](http://krakendev.io/blog/subclassing-can-suck-and-heres-why) , [*rant 2*](https://blog.pivotal.io/labs/labs/all-evidence-points-to-oop-being-bullshit),[*rant 3*](http://www.smashcompany.com/technology/object-oriented-programming-is-an-expensive-disaster-which-must-end), [*rant 4*](https://www.leaseweb.com/labs/2015/08/object-oriented-programming-is-exceptionally-bad/).

#### Welcome POP ####

You might have guessed it right, unlike Classes, the fundamental of Protocol Oriented Programming is Value Type. No more referencing. Unlike the pyramid structure you see above, POP encourages flat and non-nested code.

Just to scare you a little, I’m going to pull Apple’s definition.

“A protocol defines a ***blueprint*** of methods, properties… The protocol can then be ***adopted*** by a class, structure, or enumeration” — Apple

The only thing you need to remember right now is the word, “blueprint”.

A protocol is like a basketball coach. He tells his players what to do, but he doesn’t know how to dunk a basketball.

#### Getting Real with POP ####

Firstly, let’s make a blueprint for a human.

```
protocol Human {
 var name: String { get set }
 var race: String { get set }
 func sayHi() }
```

As you can see, there is no actual “dunking” in the protocol. It only tells you that certain things exist. By the way, don’t worry about { get set } for now. It just indicates that you can set the property value to something different and also access (get) the property. Don’t worry about for now unless you are using a computed property.

Let’s make a Korean 🇰🇷 struct that adopts the protocol

```
struct Korean: Human {
 var name: String = "Bob Lee"
 var race: String = "Asian"
 func sayHi() { print("Hi, I'm \(name)") }
}
```

Once the struct adopts the Human protocol, it has to “conform” to the protocol by implementing all of the properties and methods belong to it. If not, Xcode will scream and of course, 😡 on the left side.

As you can see, you can customize all these properties as long as you meet the blueprint. You can even build a *wall.*

Of course, for American 🇺🇸 as well.

```
struct American: Human {
 var name: String = "Joe Smith"
 var race: String = "White"
 func sayHi() { print("Hi, I'm \(name)") }
}
```

Pretty cool? Look how much freedom you have without using those hideous “init” and “override” key words. Does it start to make sense?

[Intro to Protocol Lesson](https://www.youtube.com/watch?v=lyzcERHGH_8&amp;t=2s&amp;list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML&amp;index=1)

#### Protocol Inheritance ####

What if you want to create a superhuman protocol that also inherits the blueprint from the Human protocol?

```
protocol SuperHuman: Human {
 var canFly: Bool { get set } }
 func punch()
```

Now, if you make a struct or class that adopts SuperHuman, you have to meet the requirement of the Human protocol as well.

```
// 💪 Over 9000
struct SuperSaiyan: SuperHuman {
 var name: String = "Goku"
 var race: String = "Asian"
 var canFly: Bool = true
 func sayHi() { print("Hi, I'm \(name)") }
 func punch() { print("Puuooookkk") } }
```

For those who didn’t get the reference, watch the [video](https://www.youtube.com/watch?v=5196mjp9fcU)

Of course, you can conform to many protocols just like inherting more than on class.

```
// Example
struct Example: ProtocolOne, ProtocolTwo { }
```

[Protocol Inheritance Lesson](https://www.youtube.com/watch?v=uT7AZQBD6-w&amp;list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML&amp;index=2) 

#### Protocol Extension ####

Now, this is the most powerful feature of using protocol. I don’t think I need to talk too much.

```
// Super Animal speaks English
protocol SuperAnimal {
 func speakEnglish() }
```

Add an extension to SuperAnimal

```
extension SuperAnimal {
 func speakEnglish() { print("I speak English, pretty cool, huh?")}}
```

Now, let’s make a class that adopts SuperAnimal

```
class Donkey: SuperAnimal { }
var ramon = Donkey() 
ramon.speakEnglish() //  "I speak English, pretty cool, huh?"
```

If you use an extension, you can add default functions and properties to class, struct, and enum. Isn’t it just awesome? I find this as a true nugget.

By the way, if you don’t get the reference, you can watch [this](https://www.youtube.com/watch?v=MzLEjzvygYE)

[Protocol Extension Lesson](https://www.youtube.com/watch?v=ZydVdiFj3WM&amp;list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML&amp;index=3)

#### Protocol as Type (Last) ####

What if I told you that you could make an array that both contains a struct object and class object without type casting? 😮

That’s right.

For the example, I am going to use kangaroos that battle for getting females 👊. If you don’t believe me, watch this [Kangaroo fight](https://www.youtube.com/watch?v=WCcLMNcWZOc&amp;t=129s) 

```
protocol Fightable {
 func legKick() }
 
struct StructKangaroo: Fightable {
 func legKick() { print("Puuook") } }
 
class ClassKangaroo: Fightable { 
 func legKick() {print("Pakkkk") } }
```

Now, let’s make two kangaroo objects

```
let structKang = StructKangaroo()
let classKang = ClassKangaroo()
```

Now, you can combine them together in an array.

```
var kangaroos: [Fightable] = [structKang, classKang]
```

Holy shit. For real? 😱 Watch this

```
for kang in kangaroos { kang.legKick() }
// "Puuook"
// "Pakkkk"
```

Isn’t this just so beautiful? How could you have acheived this in OOP… Does the cover image make sense to you now? POP is purely gold.

[Protocol as Type Lesson](https://www.youtube.com/watch?v=PxWoWmJAMiA&amp;list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML&amp;index=4)

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*6gtsyoBiGnwGpE9gFITlSw.png">

Free for now until it gets released :)

#### **Last Remark** ####

If you found this tutorial useful, and you think I did an okay job, please ❤️ for me and share with your community. I swear, more iOS developers should implement POP! I am trying, and that’s why I wrote this, but I need your support for greater impact!

#### Shout out ####

Special thanks to these people who engaged and cared enough to point out some issues here and there. [Kilian Költzsch](https://medium.com/u/349636c3001c) , [Erik Krietsch](https://medium.com/u/dd5ed617a156), [Özgür Celebi](https://medium.com/u/25d83dd03e02) , [Sanchika Singh Rana](https://medium.com/u/77243d9a97fe), [Frederick C. Lee](https://medium.com/u/371511f27079) , [moh tabi](https://medium.com/u/21b724ed8bc8) , [october hammer](https://medium.com/u/5b8a0ae35a7d) , [Anthony Kersuzan](https://medium.com/u/a650a21c13f1) , [Kenneth Trueman](https://medium.com/u/1d5eb30a7418) , [Wilson Balderrama](https://medium.com/u/15294c9ab368) , [Rowin](https://medium.com/u/1231cd205c16) , [Quang Dinh Luong](https://medium.com/u/c71180f83786) , [Oren Alalouf](https://medium.com/u/52c31b8c769d) , [Peter Witham](https://medium.com/u/471adcab696e) , [Victor Tong](https://medium.com/u/449b3f6dffd5).

### Upcoming ###

On this Saturday I’m going to write about the Delegate design pattern in Swift 3 using Protocol. A few people requested me to write about it, so I decided to listen to them. If you want quick updates or request me any topics, you can follow my Bob the Developer[**Facebook Page**](https://www.facebook.com/bobthedeveloper/) where I engage a lot with my readers. See you soon!
