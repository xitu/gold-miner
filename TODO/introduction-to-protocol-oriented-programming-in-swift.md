> * 原文地址：[Introduction to Protocol Oriented Programming in Swift](https://medium.com/ios-geek-community/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f#.ezvkbpy7o)
* 原文作者：[Bob Lee](https://medium.com/@bobleesj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Danny Lau](https://github.com/Danny1451)
* 校对者：[Tuccuay](https://github.com/Tuccuay) [lovelyCiTY](https://github.com/lovelyCiTY)

# Swift 面向协议编程入门 #

## 面向对象编程的思想没毛病，但老铁你可以更 666 的 ##

![](https://cdn-images-1.medium.com/max/2000/1*5yuIezhfETFouNNTablgSA.jpeg)

上图这个人不是我，但这就是使用面向协议编程替换掉面向对象编程之后的感觉。

#### 介绍 ####

这个教程也是为了那些不知道类和结构体根本区别的人写的。我们都知道在结构体里是没有继承的，但是为什么没有呢？

如果你不知道上面问题的答案，那么花几秒钟看下下面的代码。请再次原谅我的排版，我已经让它尽可能的简单明了了。

>注：译者已经改过排版了🤔

```
class HumanClass {
    var name: String
    init(name: String) {
        self.name = name
     } 
}

var classyHuman = HumanClass(name: "Bob")
classyHuman.name // "Bob"

var newClassyHuman = classyHuman // Created a "copied" object

newClassyHuman.name = "Bobby"
classyHuman.name // "Bobby"

```

当我把 newClassyHuman 的 name 属性设为 “Bobby” 之后，原来对象 classyHuman 的 name 属性也会变成 “Bobby” 。

现在，让我们来看一下结构体的情况。

```
struct HumanStruct {
	var name: String 
}
 
var humanStruct = HumanStruct(name: "Bob" )
var newHumanStruct = humanStruct // Copy and paste

newHumanStruct.name = "Bobby"
humanStruct.name // "Bob"

```

你看到它们的不同之处了么？对拷贝出来的对象的 name 属性的改变并没有影响到原有的 humanStruct 对象。

在类中，当你对一个变量进行拷贝的时候，两个变量都指向内存中的同一个对象。两个中的任何一个变量中的改变都会影响另外一个变量（引用类型）。然而在结构体中，你是通过创建了一个新的对象（值类型）来实现简单的拷贝和复制的。

如果你还没有理解的话，试着把之前那一段再看一遍。如果还是不理解的话，你可以看下我做的这个视频。

[结构体 vs 类课程](https://www.youtube.com/watch?v=MNnfUwzJ4ig)

#### 再见面向对象编程 ####

你可能会很奇怪为什么我所讲的这些好像和面向协议编程的话题一点关系都没有。然而，在我讲使用面向协议编程替换面向对象编程的好处之前，是必须要理解引用类型和值类型的区别的。

使用面向对象编程当然有优点的，但是相对的缺点也存在。

1. 当时构建子类的时候，你必须继承一些你不需要的属性和方法。你的对象变得不必要的虚胖。

2. 当时使用了大量的父类（太多继承层级），在不同的类里面跳来跳去编写代码或者修复 bug 都会变得非常棘手。

3. 因为对象都是指向内存中的同一个空间，如果你创建了一个拷贝，并且对它的属性进行了一点小改动，它会影响到其余的对象。（引用导致的易变性）

顺便说一下，来看一下 UIKit 框架是怎么用面向对象编程来写的。

![2015 WWDC_Hideous Structure](https://cdn-images-1.medium.com/max/800/1*hjEXB3PGUOSbxet0qUJRNA.png)


如果你作为软件工程师第一次去苹果工作的话，你能使用这些代码么？我的意思是我们开发者在界面层使用中都有过很痛苦的经历。

**有人说过面向对象编程就是通过模块化的模式来写意大利面条式的代码。如果你想找到更多关于面向对象编程的缺点的话，看这里的**[**咆哮 1**](http://krakendev.io/blog/subclassing-can-suck-and-heres-why) 、[**咆哮 2**](https://blog.pivotal.io/labs/labs/all-evidence-points-to-oop-being-bullshit) 、[**咆哮 3**](http://www.smashcompany.com/technology/object-oriented-programming-is-an-expensive-disaster-which-must-end) 、[**咆哮 4**](https://www.leaseweb.com/labs/2015/08/object-oriented-programming-is-exceptionally-bad/) 。

#### 欢迎使用面向协议编程 ####

你可能已经猜到了，和类不一样的是，面向协议编程的基础是值类型。不再是引用了，和你之前看到的金字塔结构不一样，面向协议所提倡的是扁平化和去嵌套的代码。

可能会有点吓到你，我将引出的是苹果的定义。

“协议定义了方法、属性的蓝图…… 然后类、结构体或枚举类型都能够使用协议” — 苹果

你现在唯一需要记住的就是这个词语，“蓝图”。

协议就好像是一个篮球教练，他告诉他的队员该怎么做，但是他却不知道怎么扣篮。

#### 真正的使用面向协议编程 ####

首先，我们来生成人的蓝图。

```
protocol Human {
	var name: String { get set }
	var race: String { get set }
	func sayHi() 
}
```

就像你看到的，在协议里是没有真正的”扣篮“。它只会告诉你有那么个东西的存在。顺便说一下，现在你不需要担心 { get set } 。它只是表示你可以改变这个属性的值并能够获取这个属性。除非你用的是一个计算属性话，现在是不用担心的。

现在让我们通过这个协议来写一个韩国人 🇰🇷 结构体

```
struct Korean: Human {
	var name: String = "Bob Lee"
	var race: String = "Asian"
	func sayHi() {
 		print("Hi, I'm \(name)") 
 	}
}
```

一旦这个结构体采用了人类这个协议，它就必须”遵循”这个协议，实现它的所有属性和方法。如果不这么做的话, Xcode 会警报，当然左边也会报错 😡 。

就像你看到的，为了满足蓝图你能够自定义所有的协议。你甚至可以建造一个“围墙”。

当然，对美国人 🇺🇸 来说也是一样的。

```
struct American: Human {
 var name: String = "Joe Smith"
 var race: String = "White"
 func sayHi() { print("Hi, I'm \(name)") }
}
```

是不是相当酷？看看不再使用 “init” 和 “override” 关键词之后你拥有了多少自由。它是不是开始变得有点意思了？

[协议介绍课程](https://www.youtube.com/watch?v=lyzcERHGH_8&amp;t=2s&amp;list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML&amp;index=1)

#### 协议继承 ####

如果你想创建一个继承人类协议蓝图的超人协议该怎么办呢？

```
protocol SuperHuman: Human {
	var canFly: Bool { get set } 
	func punch()
}
```

现在，如果你想生成一个采用超人协议的结构体或者类的话，你必须也要让它满足人类的协议。

```
// 💪 超过 9000
struct SuperSaiyan: SuperHuman {
	var name: String = "Goku"
	var race: String = "Asian"
	var canFly: Bool = true
	func sayHi() { 
		print("Hi, I'm \(name)") 
	}
	func punch() { 
		print("Puuooookkk") 
	} 
}
```

那些理解不了的人，看下这个[视频](https://www.youtube.com/watch?v=5196mjp9fcU)

当然，你可以像在类上面一样遵循多个协议。

```
// 例子
struct Example: ProtocolOne, ProtocolTwo { }
```

[协议继承课程](https://www.youtube.com/watch?v=uT7AZQBD6-w&amp;list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML&amp;index=2) 

#### 协议扩展 ####

现在，这是使用协议最强大的特点了，我不认为我需要讲太多。

```
// 会说英语的超级动物
protocol SuperAnimal {
	func speakEnglish()
}
```

给 SuperAnimal 增加一个扩展

```
extension SuperAnimal {
	func speakEnglish() { 
		print("I speak English, pretty cool, huh?")
	}
}
```

现在，让我们来创建一个采用 SuperAnimal 协议的类。


```
class Donkey: SuperAnimal { }
var ramon = Donkey() 
ramon.speakEnglish() //  "I speak English, pretty cool, huh?"
```

如果你使用扩展的话，你能够给类，结构体和枚举增加默认方法和属性。它难道不神奇么？我发现这是真正的金块啊。

顺带提一下，如果你没有理解的话，你可以看[这个](https://www.youtube.com/watch?v=MzLEjzvygYE)

[Protocol Extension Lesson](https://www.youtube.com/watch?v=ZydVdiFj3WM&amp;list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML&amp;index=3)

#### 协议作为类型 (Last) ####

如果我告诉你不需要类型修饰就能够生成一个既包含结构体对象又有类对象的数组呢？

就是这样。

我用为获得雌性配偶而打架的袋鼠来举个例子。如果你不相信我的话，看看这个[袋鼠打架](https://www.youtube.com/watch?v=WCcLMNcWZOc&amp;t=129s) 

```
protocol Fightable {
	func legKick() 
}
 
struct StructKangaroo: Fightable {
	func legKick() {
		print("Puuook")
	}
}
 
class ClassKangaroo: Fightable { 
	func legKick() {
		print("Pakkkk") 
	}
}
```

来，我们生成两个袋鼠对象

```
let structKang = StructKangaroo()
let classKang = ClassKangaroo()
```

现在，你可以把它们放到一个数组里了。

```
var kangaroos: [Fightable] = [structKang, classKang]
```

厉害了我的哥，这是真的么？😱 看看这个

```
for kang in kangaroos {
	kang.legKick()
}
// "Puuook"
// "Pakkkk"
```

这个难道不巧妙么？你在面向对象编程中怎么可能实现这个效果... 封面的图片是不是对你来说已经有意义了？面向协议编程纯粹是金子啊。

[协议类型课程](https://www.youtube.com/watch?v=PxWoWmJAMiA&amp;list=PL8btZwalbjYm5xDXDURW9u86vCtRKaHML&amp;index=4)

![](https://cdn-images-1.medium.com/max/1000/1*6gtsyoBiGnwGpE9gFITlSw.png)

现在是免费的，直到它发布之前:)

#### **最后提示** ####

如果你觉得这个教程有用的话，而且你认为我做了一个很棒的事情，请 ❤️ 我并且分享到你的社交圈中。我发誓，更多的 iOS 开发者都该应该使用面向协议编程 ！我也在努力中，所以才写了这个文章，但是为了更大的影响我需要你的支持。

#### 公开感谢 ####

特别感谢那些参与和指出各处问题的人们。[Kilian Költzsch](https://medium.com/u/349636c3001c) , [Erik Krietsch](https://medium.com/u/dd5ed617a156), [Özgür Celebi](https://medium.com/u/25d83dd03e02) , [Sanchika Singh Rana](https://medium.com/u/77243d9a97fe), [Frederick C. Lee](https://medium.com/u/371511f27079) , [moh tabi](https://medium.com/u/21b724ed8bc8) , [october hammer](https://medium.com/u/5b8a0ae35a7d) , [Anthony Kersuzan](https://medium.com/u/a650a21c13f1) , [Kenneth Trueman](https://medium.com/u/1d5eb30a7418) , [Wilson Balderrama](https://medium.com/u/15294c9ab368) , [Rowin](https://medium.com/u/1231cd205c16) , [Quang Dinh Luong](https://medium.com/u/c71180f83786) , [Oren Alalouf](https://medium.com/u/52c31b8c769d) , [Peter Witham](https://medium.com/u/471adcab696e) , [Victor Tong](https://medium.com/u/449b3f6dffd5).

### 预告 ###

这个周六，我将写一些关于在 Swift 3 中如何通过协议实现代理的设计模式的东西。有些人让我写这个，所以我决定听你们的。如果你想要快速更新或者请求我的文章的话，你可以关注我[**Facebook Page**](https://www.facebook.com/bobthedeveloper/)，那里我和我的读者有很多的互动。再见！
