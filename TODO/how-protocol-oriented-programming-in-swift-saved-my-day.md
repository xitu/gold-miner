> * 原文地址：[How Protocol Oriented Programming in Swift saved my day?](https://medium.com/ios-os-x-development/how-protocol-oriented-programming-in-swift-saved-my-day-75737a6af022)
* 原文作者：[NIkant Vohra](https://medium.com/@nikantvohra)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：









Object Oriented programming (OOP) has been there in use for decades now and has become the de facto standard to build large software projects. It is at the heart of iOS programming and it is almost impossible to write an iOS application with following the OOP paradigm. Although OOP offers a lot of advantages like encapsulation, access control and abstractions but it comes with its own set of problems.

1.  You mostly start with single class inheritance but then you realize that you need some more functionality in your class from some different class. This makes you lean towards multiple inheritance which is not supported by most programming languages and leads to undesired complexity.
2.  As classes are reference types passing them around in functions can cause unexpected behavior especially if you are working in a multi threaded environment.
3.  Due to tight coupling of classes with one another it becomes difficult to write unit tests for a single class.

There are rants all over the web about OOP .

[All evidence points to OOP being bullshit | Pivotal](about:blank)

[Object Oriented Programming is an expensive disaster which must end | Smash Company](http://www.smashcompany.com/technology/object-oriented-programming-is-an-expensive-disaster-which-must-end)



Swift tries to fight the inherent OOP problems by introducing a new paradigm called Protocol Oriented Programming. This WWDC 2015 talk gives an amazing introduction to Protocol Oriented Programming. I cannot recommend it enough.

Swift from the very beginning has embraced the idea of value types. Structs and Enums are first class citizens in Swift and come packed with a lot of features like properties, methods and extensions which are only find in Classes in most languages. Although value types do not support inheritance in Swift, they can conform to protocols which allows them to enjoy the benefits of Protocol Oriented Programming.

Ray Wenderlich’s tutorial on Protocol Oriented Programming showcases its power.

[Introducing Protocol-Oriented Programming in Swift 2](about:blank)

Now I will show you how Protocol Oriented Programming saved my day. My app follows the classic left menu navigation with a few options. The app has around ten different view controllers which all inherit from a base view controller which has some basic functions and styles needed by each view controller.



![](https://cdn-images-2.medium.com/max/800/1*kzD0ekSgHvBvu23OAyW7Fg.jpeg)

Left Menu App Example similar to my app



The app relies on Websockets to communicate with a server. The server can send an event anytime and the app needs to respond to that event depending upon the View Controller the user is on. One example of such event is the logout event. When the app receives that event from the server depending upon the state, the app needs to logout the user and show the login screen.

The first thing that came to my mind was to include this logout functionality in the base view controller and call it from the required view controller when the event occurs.

    class BaseViewController {
      func logout() {
        //Perform Logout
        print("Logout User")
      }
    }

The problem with this approach is that though every view controller in the does not need to implement the logout functionality still it will inherit the logout function. In addition to this different view controllers needed to respond to different events so it did not make sense to include very function in the base view controller.

Luckily Protocol Oriented Programming came to my rescue. I declared a protocol Logoutable and the View Controllers that needed the logout functionality conformed to Logoutable protocol.

    protocol Logoutable {
      func logout()
    }

    class ViewController : Logoutable {
      func logout() {
        //Perform Logout
        print("Logout User")
      }
    }

The problem with this approach was that I had to repeat the same implementation of the Logout function in each one of my view controllers that conformed to Logoutable protocol.

This is where Protocol Oriented Programming shines in Swift as it provides us with Protocol Extensions that can be used to define a default behavior of the functions in a protocol. So all I had to do was to write an extension on Logoutable protocol with the default logout implementation and the function became available to every view controller that conformed to Logoutable protocol.

    extension Logoutable where Self : BaseViewController {
      func logout() {
        //Perform Logout
        print("Logout User")
      }
    }

It felt like pure magic when all this worked without defining any complicated inheritance structure. Now I could define different protocols for different events and the respective view controllers could conform to the required protocols.

Protocol Oriented Programming really saved my day. Now whenever I have to use inheritance and other object oriented principles for structuring my code, I think whether it can be done in a better way using Protocol Oriented Programming. I am not saying it is the perfect way of doing things but still it is worth giving a shot.













_If you liked this article please recommend it, so that others can enjoy it as well._







