> * 原文地址：[How Protocol Oriented Programming in Swift saved my day?](https://medium.com/ios-os-x-development/how-protocol-oriented-programming-in-swift-saved-my-day-75737a6af022)
* 原文作者：[NIkant Vohra](https://medium.com/@nikantvohra)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Danny Lau](https://github.com/Danny1451)
* 校对者：[Jing Liu](https://github.com/shliujing),[lm](https://github.com/DeepMissea)

# Swift 中的面向协议编程是如何点亮我的人生的

面向对象编程至今已经使用了数十年了，并且成为了构建大型软件约定俗成的标准。作为iOS编程的中心思想，遵循面向对象规范来编写一个 iOS 的应用几乎不可能实现。虽然面向对象有很多优点比如封装性，访问控制和抽象性，但是它也自带有固有的缺点。

1.  大多数类的情况下，当一个单继承的类需要更多不同类中的函数功能时，你会倾向于使用多继承来实现。 但是大部分的编程语言不支持这一特性，而且会导致类的继承关系变得复杂。
2.  在多线程环境下，如果所有对象在函数中都是通过引用来传递会导致意想不到的问题。
3.  因为类与类之间的高耦合性，为一个单独的类写测试单元会很困难。

下面是网上大量的对面向对象的抱怨

[All evidence points to OOP being bullshit | Pivotal](https://blog.pivotal.io/pivotal-labs/labs/all-evidence-points-to-oop-being-bullshit)

[Object Oriented Programming is an expensive disaster which must end | Smash Company](http://www.smashcompany.com/technology/object-oriented-programming-is-an-expensive-disaster-which-must-end)



Swift 尝试引入一种叫做面向协议的编程新规范来解决传统的面向对象编程中固有的问题。WWDC2015 演讲做了一个令人惊叹的关于面向协议编程的介绍。我迫不及待的想推荐它了。


[![](https://i.ytimg.com/vi_webp/g2LwFZatfTI/hqdefault.webp)](https://www.youtube.com/embed/g2LwFZatfTI?wmode=opaque&widget_referrer=https%3A%2F%2Fmedium.com%2Fmedia%2Ff137712b1f42988c4a0a99675aa7c26d%3FmaxWidth%3D700&enablejsapi=1&origin=https%3A%2F%2Fcdn.embedly.com&widgetid=1)

Swift 在最初的时候是包含值类型的概念。结构体和枚举都是 Swift 中的[一等公民](https://en.wikipedia.org/wiki/First-class_citizen)，还拥有很多像 propertites, methods 和 extensions 等在大多数语言只有类才有的特点。虽然在Swift中值类型不支持继承，但是通过遵循协议的方式一样能够享受到面向协议的好处。

Ray Wunderlich 的面向协议编程的教程展示了它的能力。

[Introducing Protocol-Oriented Programming in Swift 2](https://www.raywenderlich.com/109156/introducing-protocol-oriented-programming-in-swift-2)

现在我将向你展示面向协议编程是如何点亮我的人生的。我的应用程序遵循经典的左侧菜单导航模式（附带一些选项）。这个应用大概有十个不同的 view controller，它们都是继承自一个拥有基础函数和各个界面所需样式的基类 view controller。


![](https://cdn-images-2.medium.com/max/800/1*kzD0ekSgHvBvu23OAyW7Fg.jpeg)

和我的应用相似的左侧菜单的应用例子

这个应用依赖于 Webscokets 来与服务器交互。服务器可以随时发送事件，而应用根据用户所在的界面来进行相应的事件响应。举个事件例子的话，比如登出事件，当用户收到了服务器关于这个状态的事件时，应用需要登出并显示登录界面。
在我脑中的第一想法是把登出事件写在基础的 view controller 里面，当事件发生的时候，在需要的 view controller 进行调用。

    // BaseViewController.swift
    class BaseViewController {
      func logout() {
        //Perform Logout
        print("Logout User")
      }
    }

这一步的问题就是并不是每个 view controller 都必须实现这个登出的功能，但是它还是都会继承这个登出的函数。此外不同的 view controller 需要响应不同的事件，所以在基础 view controller 中包含所有的函数并没有什么意义。

幸运地是面向协议编程拯救了我，我声明一个 Logoutable 的协议，那些需要登出功能的 view controller 遵循这个 Logoutable 的协议就可以了。

    // Logoutable.swift
    protocol Logoutable {
      func logout()
    }

    // ViewController.swift
    class ViewController : Logoutable {
      func logout() {
        //Perform Logout
        print("Logout User")
      }
    }

这一个进步带来的问题是我必须在每个需要遵循这个协议的 view controller 中重复这个登出函数的实现。

这正是面向协议编程在 Swift 中的闪光点，因为它给我们提供了协议拓展功能，可以在一个协议中定义一个默认的函数的行为。所以我所需要做的仅仅是在 Logoutable 的协议中写一个带有默认登出行为的实现的拓展，这样这个函数对那些遵循这个协议的 view controller 的来说就是可选的。

    //LogoutableExtension.swift
    extension Logoutable where Self : BaseViewController {
      func logout() {
        //Perform Logout
        print("Logout User")
      }
    }

面向协议编程完全就像魔法一样，不定义任何复杂的继承就够就实现这些功能。现在我就能为不同的事件定义不同的协议并且各自 view controller 就能够遵循它所需要的协议。

面向协议编程是真正地点亮了我的人生，现在每当我需要使用继承或者其他面向对象的原理来构建我的代码时，我会想这能否通过使用面向协议编程的方法来更好的完成这项工作。我不是说它是完美的解决方案但是它仍然值得一试。


_如果你喜欢这篇文章的话，请推荐它，这样其他人也可以欣赏它。_

