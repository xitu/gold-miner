> * 原文地址：[14 must knows for an iOS developer](https://swiftsailing.net/14-must-knows-for-an-ios-developer-5ae502d7d87f#.5qoqojm6n)
* 原文作者：[Norberto Gil Vasconcelos](https://swiftsailing.net/@nobizard)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

# 14 must knows for an iOS developer

![](https://cdn-images-1.medium.com/max/2000/1*GlmHP6nltxqLBZA3Rv8AGg.jpeg)

As an iOS developer (currently addicted to Swift 😍). I have created apps from scratch, maintained apps and, been in a lot of different teams. In all my time in the industry, a saying has stuck with me: “If you can’t explain it, you don’t understand it”. So in an attempt to fully understand what I do on a daily basis, I’m creating a list of what, in my opinion, is essencial to any iOS dev. I will try to explain each point in a clear fashion.*[Please, feel free to correct me, offer your opinion or even suggest a “must know” which, you feel, should be on the list.]*

**Topics:** **[** *Source Control* **|** *Architecture Patterns* **|** *Objective-C vs Swift* **|** *React* **|** *Dependency Manager* **|** *Storing Information* **|** *CollectionViews & TableViews* **|** *UI* **|** *Protocols* **|** *Closures* **|** *Schemes* **|** *Tests* **|** *Location* **|** *Localizable Strings* **]**

Without further ado, and in no particular order, here is my list.

#### 1 — Source control

Congratulations you were hired! Now fetch the code from the repo and get to work. Wait what?

Every project is going to need source control, even if you are the only dev. The most common ones are Git and SVN.

**SVN** relies on a centralised system for version management. It’s a central repository where working copies are generated and a network connection is required for access. Its access authorization is path based, it tracks changes by registering files and the change history can only be seen, fully, in the repository. Working copies only contain the newest version.

*Suggested visual interface:*

[**Versions - Mac Subversion Client (SVN)** *Versions, the first easy to use Mac OS X Subversion client* versionsapp.com](http://versionsapp.com)

**Git** relies on a distributed system for version management. You will have a local repository on which you can work, with a network connection only required to synchronise. Its access authorization is for the entire directory, tracks changes by registering content and both the repository and working copies have the complete change history.

*Suggested visual interface:*

[**SourceTree | Free Git and Hg Client for Mac and Windows**
*SourceTree is a free Mercurial and Git Client for Windows and Mac that provides a graphical interface for your Hg and…* www.sourcetreeapp.com](https://www.sourcetreeapp.com)

#### 2 — Architecture patterns

Your fingers are twitching with excitement, you figured out source control! Or was that the coffee? Doesn’t matter! You are in the zone and it’s time to code! Nope. What wait?

Before you start mashing your keyboard, you have to pick an architecture pattern to put in place. If you aren’t starting the project, you have to conform to the implemented pattern.

There is a wide array of patterns used in mobile app development, MVC, MVP, MVVM, VIPER, etc. I will give you a quick overview of the most commonly used in iOS development:

- **MVC** — Short for **M**odel, **V**iew, **C**ontroller. The controller creates the bridge between the Model and the View, which are unaware of each other. The connection between the View and the Controller is very tight-knit, thus, the controller ends up handling just about everything. What does this mean? Simply put, if you’re building a complex view, your Controller (ViewController) is going to be insanely big. There are ways to circumvent this, however they disobey the rules of MVC. Another downside to MVC would be testing. If you do tests (Good on you!), you will probably only test the Model, due to it being the only layer separate from the rest. The plus of using the MVC pattern is that it’s intuitive and most iOS developers are used to it.

![](https://cdn-images-1.medium.com/max/800/1*dLNPhFL6k2MFJBAm9g24UA.png)

- **MVVM** — Short for **M**odel, **V**iew, **V**iew**M**odel. Bindings (basically reactive programming) are setup between the View and the ViewModel, this allows the ViewModel to invoke changes on the Model, which then updates the ViewModel, automatically updating the View due to the bindings. The ViewModel knows nothing of the View, which facilitates testing and bindings reduce a lot of code.

![](https://cdn-images-1.medium.com/max/800/1*E1TC8beTXLlgVHO29wJTpA.png)

For a more in-depth explanation and info on the other patterns, i suggest reading:

[**iOS Architecture Patterns**
*Demystifying MVC, MVP, MVVM and VIPER* medium.com](https://medium.com/ios-os-x-development/ios-architecture-patterns-ecba4c38de52)

It might not seem of much importance, but well structured and organised code can prevent a lot of headaches. A big mistake every developer commits at some point, is to just get to the desired result and forgo organising the code, under the illusion they are saving time. If you don’t agree, take it from my man Benji:

> For every minute spent organising, an hour is earned.

> — Benjamin Franklin

The goal is to have something intuitive and easy to read, which you can easily build upon and maintain.

#### 3 — Objective-C vs. Swift

When deciding which language you will be programming your app in, you need to know what each language brings to the table. If given the option, I personally, suggest using Swift. Why? Honestly Objective-C has very few advantages over Swift. Most of the examples and tutorials are written in Objective-C and with every update to Swift, adjustments are made to the paradigms, which can be disheartening. However, these are issues that in the long run will fade away.

Swift really leaps ahead in a lot of ways. It’s easy to read, resembles natural english and because it’s not built on C, it drops legacy conventions. To those who know Objective-C, this means no more semi-colons, method calls don’t require brackets and no need for parentheses to surround conditional expressions. It’s also easier to maintain your code, Swift only needs a .swift file instead of a .h and a .m file, because Xcode and the LLVM compiler can figure out dependencies and perform incremental builds automatically. Overall you will have to worry less about creating boilerplate code and find that you can achieve the same results with less code.

Not convinced? Swift if safer, faster and takes care of memory management(Most of it!). Know what happens in Objective-C when you call a method with an uninitialised pointer variable? Nothing. The expression becomes a no-op and is skipped. Sounds great because it doesn’t crash the app, however, it leads to a series of bugs and erratic behaviour that are going to make you want to rethink your career. I sh*t you not. The idea of being a professional dog walker just became a little more appealing. Swift counter acts this with optionals. Not only will you have a better idea of what can possibly be nil and set guarantees into place to prevent nil being used, but if a nil optional does get used, Swift will trigger a runtime crash, facilitating debugging. Memory-wise and put simply, ARC (Automatic Reference Counting) does it’s business better in Swift. In Objective-C, ARC doesn’t work for procedural C code and APIs like Core Graphics.

#### 4 — To React or not to React?

![](https://cdn-images-1.medium.com/max/800/1*pXx4SEZ7TExz5uCi2soXhw.gif)

Functional Reactive Programming (**FRP**) is the new fad it seems. Its intention is to enable easy composition of asynchronous operations and event/data streams. For Swift it’s a generic abstraction of computation expressed through the`Observable<Element>` interface.

Easiest way to exemplify is with a bit of code. Let’s say little Timmy and his sister, Jenny, want to buy a new gaming console. Timmy gets 5€ from his parents every week, same goes for Jenny. However Jenny makes another 5€ by delivering newspapers on weekends. If they both save every cent, we can check every week if the console is attainable! Every time one of their savings is affected, their combined value is calculated. If it is enough, a message is saved in the variable isConsoleAttainable. At any point we can check the message by subscribing to it.

    // Savings
    let timmySavings = Variable(5)
    let jennySavings = Variable(10)

    var isConsoleAttainable =
    Observable
    .combineLatest(timmy.asObservable(), jenny.asObservable()) { $0 + $1 }
    .filter { $0 >= 300 }
    .map { "\($0) is enough for the gaming console!" }

    // Week 2
    timmySavings.value = 10
    jennySavings.value = 20
    isConsoleAttainable
       .subscribe(onNext: { print($0) }) // Doesn't print anything

    // Week 20
    timmySavings.value = 100
    jennySavings.value = 200
    isConsoleAttainable
       .subscribe(onNext: { print($0) }) // 300 is enough for the gaming        console!

This just scratches the surface on what we can do with FRP, once you get the hang of it, it opens up a whole new world of possibilites, allowing you to even adopt an architecture different to the common MVC… You guessed it! MVVM!

You can check out the two main contenders to the Swift FRP throne:

- **RxSwift**

[**ReactiveX/RxSwift**
*RxSwift - Reactive Programming in Swift* github.com](https://github.com/ReactiveX/RxSwift)

- **ReactiveCocoa**

[**ReactiveCocoa/ReactiveCocoa**
*ReactiveCocoa - Streams of values over time* github.com](https://github.com/ReactiveCocoa/ReactiveCocoa)

#### 5 — Dependency Manager

CocoaPods and Carthage are the most common dependency managers for Swift and Objective-C Cocoa projects. They simplify the process of implementing a library and keeping it updated.

**CocoaPods** has a truck load of libraries, is built with Ruby and can be installed using the following command:

    $ sudo gem install cocoapods

After installing it, you will want to create a Podfile for your project. You can run the following command:

    $ pod install

or create a custom Podfile with this structure:

    platform :ios, '8.0'
    use_frameworks!
    
    target 'MyApp' do
      pod 'AFNetworking', '~> 2.6'
      pod 'ORStackView', '~> 3.0'
      pod 'SwiftyJSON', '~> 2.3'
    end

once created, it’s time to install your new pods:

    $ pod install

Now you can open your project’s **.xcworkspace** and don’t forget to import your dependencies.

**Carthage** is a decentralised dependency manager, in opposition to CocoaPods. Downside to this is it becomes more difficult for users to find the existing libraries. On the other hand, it requires less maintenance work and avoids any central point of failure.

For more info on how to install and use, check out their GitHub:

[**Carthage/Carthage**
*Carthage - A simple, decentralized dependency manager for Cocoa* github.com](https://github.com/Carthage/Carthage)

#### 6 — Storing information

Lets start with a simple way of saving data for your apps. **NSUserDefaults**, called this way, because it’s generally used to save default user data, that is put in when the app is first loaded. For this reason it’s made to be simple and easy to use, however this implies some limitations. One of it’s limitations is the type of objects it accepts. It acts very much like a **Property List (Plist)**, which also has the same limitation. The six type of objects they can store are the following:

- NSData
- NSDate
- NSNumber
- NSDictionary
- NSString
- NSArray

To be compatible with Swift, NSNumber can accept the following:

- UInt
- Int
- Float
- Double
- Bool

Objects can be saved to NSUserDefaults in the following manner (First create a constant that will keep the key for the object we are saving):

    let keyConstant = "objectKey"

    let defaults = NSUserDefaults.standardsUserDefaults()
    defaults.setObject("Object to save", objectKey: keyConstant)

To read an object from NSUserDefaults, we can do the following:

    if let name = defaults.stringForKey(keyConstant) {
       print(name)
    }

There are several convenience methods for reading and writing to NSUserDefaults, that get specific objects instead of an AnyObject.

**Keychain** is a password management system and can contain passwords, certificates, private keys or private notes. The keychain has two levels of device encryption. The first level uses the lock screen passcode as the encryption key. The second level uses a key generated by and stored on the device.

What does this mean? It’s not exactly super safe, specially if you don’t use a lock screen passcode. There are also ways to access the key used on the second level, because it’s saved on the device.

Best solution is to use your own encryption. (Don’t store the key on the device)

**CoreData** is a framework designed by apple, for your application to communicate with it’s database in an object oriented manner. It simplifies the process, reducing the code and removing the need to test that section of code.

You should use it if your app requires persistent data, it simplifies the process of persisting data quite a bit and means you don’t have to build your own way of communicating with a DB or testing it either.

#### 7 — CollectionViews & TableViews

Just about every app has one or more collection views and/or table views. Knowing how they work, and when to use one or the other, will prevent complicated changes to your app in the future.

**TableViews** display a list of items, in a single column, a vertical fashion, and limited to vertical scrolling only. Each item is represented by a UITableViewCell, that can be completely customized. These can be sorted into sections and rows.

**CollectionViews** also display a list of items, however, they can have multiple columns and rows (grid for example). They can scroll horizontally and/or vertically, and each item is represented by a UICollectionViewCell. Just like UITableViewCells, these can be customised at will, and are sorted into sections and rows.

They both have similar functionality and use reusable cells to improve fluidity. Choosing which one you need depends on the complexity you want the list to have. A collection view can be used to represent any list and, in my opinion, is always a good choice. Imagine you want to represent a contact list. It’s simple, can be done with just one column, so you decide on a UITableView. Great it works! Few months down the line, your designer decides that the contacts should be displayed in grid format, instead of list format. The only way you can do this, is to change your UITableView implementation to a UICollectionView implementation. What I’m trying to get at is, even though your list might be simple and a UITableView can suffice, if there is a good chance the design will change, it’s probably best to imlpement the list with a UICollectionView.

Whichever you end up choosing, it’s a good idea to create a generic tableview/collectionview. It makes implementation easier and allows you to reutilize a lot of code.

#### 8 — Storyboards vs. Xibs vs. Programmatic UI

Each of these methods can be used individually to create a UI, however nothing prevents you from combining them.

**Storyboards** allow a broader view of the project, which designers love, because they can see the app flow and all of the screens. The downside is that as more screens are added, the connections become more confusing and storyboard load time is increased. Merge conflict issues happen a lot more often, because the whole UI belongs to one file. They are also a lot more difficult to resolve.

**Xibs** provide a visual view of screens or portions of a screen. Their advantages are ease of reuse, less merge conflicts than the storyboard approach and an easy way to see what’s on each screen.

**Programming** your UI gives you a lot of control over it, less merge conflicts and, if they do occur, are easy to solve. Downside is the lack of visual aid and extra time it will take to program.

There are very different approaches to creating your app’s UI. It’s quite subjective, however, what I consider the best approach is a combination of all 3. Multiple Storyboards (now that we can segue between storyboards!), with Xibs for any visual that isn’t a main screen and, finally, a touch of programming for the extra control needed in certain situations.

#### 9 — Protocols!

Protocols exist in our daily lives to make sure, in a given situation, we know how to react. For example, let’s say you are a fireman and an emergency situation arrises. Every fireman has to conform to the protocol that sets the requirements to successfully respond. The same applies to a Swift/Objective-C protocol.

A protocol defines a draft of the methods, properties and other requirements for given functionalities. It can be adopted by a class, a structure or an enumeration, that will then have an actual implementation of those requirements.

Here is an example of how a protocol could be created and used:

For my example I will need an enum that lists the different types of materials that can be used to extinguish a fire.

    enum ExtinguisherType: String {

       case water, foam, sand

    }

Next I’ll create a protocol that responds to emergency situations.

    protocol RespondEmergencyProtocol {

       func putOutFire(with material: ExtinguisherType)

    }

Now I’ll create a fireman class that conforms to the protocol.

    class Fireman: RespondEmergencyProtocol {

        func putOutFire(with material: ExtinguisherType) {

           print("Fire was put out using \(material.rawValue).")

        }

    }

Great! Now let’s put this fireman into action.

    var fireman: Fireman = Fireman()

    fireman.putOutFire(with: .foam)

The result should be *“Fire was put out using foam.”*

Protocols are also used in **Delegation.** It enables Classes or Structs to delegate certain functions to an instance of another type. A protocol is created with the responsibilities to be delegated, so as to guarantee the conforming type provides functionality for them.

Quick example!

    protocol FireStationDelegate {
       func handleEmergency()
    }

The firestation delegates the action of handling an emergency to the fireman.

    class FireStation {
       var delegate: FireStationDelegate?

       fun emergencyCallReceived() {
          delegate?.handleEmergency()
       }
    }

This means the fireman will have to conform to the FireStationDelegate protocol as well.

    class Fireman: RespondEmergencyProtocol, FireStationDelegate {

       func putOutFire(with material: ExtinguisherType) {
          print("Fire was put out using \(material.rawValue).")
       }

       func handleEmergency() {
          putOutFire(with: .water)
       }

    }

All that need to be done is for the fireman on call to be set as the firestation delegate, and he will handle the received emergency calls.

    let firestation: FireStation = FireStation()
    firestation.delegate = fireman
    firestation.emergencyCallReceived()

The result should be *“Fire was put out using water.”*

As you can see, protocols are very useful. There is a lot that can be done with them, but for now I’ll keep it at this.

#### 10 — Closures

I’ll be focusing only Swift closures. They are mostly used to return a completion block or with high order functions. Completion blocks are used, as the name indicates, to run a block of code, after a task is finished.

> Closures in Swift are similar to blocks in C and Objective-C.

> Closures are first-class objects, so that they can be nested and passed around (as do blocks in Objective-C).

> In Swift, functions are just a special case of closures.

Source: [Swift Block Syntax](http://fuckingswiftblocksyntax.com)

This source is a great place to learn closure syntax.

#### 11 — Schemes

Simply put, schemes are any easy way of switching between configurations. Let’s give you some background. A workspace contains various related projects. A project can have various targets — targets specify a product to build and how to build it. A project can also have various configurations. An Xcode scheme defines a collection of targets to build, a configuration to use when building, and a collection of tests to execute.

![](https://cdn-images-1.medium.com/max/800/1*eW_7GjRt-gmV1XoBB2BhlA.png)

#### 12 — Tests

If you can allocate time to testing your app, you are on the right track. It’s no silver bullet, you can’t prevent every single bug and can’t guarantee your app will be devoid of any issues, however I think the pros outweigh the cons.

Let’s start with Unit testing **cons:**

- Development time increased;
- Amount of code increased.

**Pros:**

- Forced to create modular code (to make testing easier);
- Obviously, more bugs caught before release;
- Easier to maintain.

Paired with **Instruments**, you will have all the tools to make sure your app is fluid, bug free and crash free.

There are quite a few instruments you can use to check what’s up with your app. Depending on what you want to see, you can pick one or more of them. Most commonly used, are probably Leak Checks, Profile Timer & Memory Allocation.

#### 13 — Location

A lot of apps will have some feature that requires the user’s location. So it’s a good idea to have a general knowledge of how location works for iOS.

There is a framework called Core Location that allows you to access all you need:

> The Core Location framework lets you determine the current location or heading associated with a device. The framework uses the available hardware to determine the user’s position and heading. You use the classes and protocols in this framework to configure and schedule the delivery of location and heading events. You can also use it to define geographic regions and monitor when the user crosses the boundaries of those regions. In iOS, you can also define a region around a Bluetooth beacon.

Pretty sweet right? Check out the Apple documentation guides and sample code to get a better idea of what you can do and how.

[**About Location Services and Maps**
*Describes the use of location and map services.* developer.apple.com](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/LocationAwarenessPG/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009497)

#### 14 — Localizable Strings

Something every app should implement. It allows the app to change language, according to the region it is in. Even if your app starts out with only one language, in the future the need to add a new language might arise. If all the text is input using localizable strings, all that needs to be done is to add a translated version of the Localizable.strings file, for the new language.

A resource can be added to a Language via file inspector. To fetch a String with NSLocalizedString, all you need to do is the following:

    NSLocalizedString(key:, comment:)

Unfortunately to add a new string to the Localizable file, it has to be done manually. Here is an example of the structure:

    {
       "APP_NAME" = "MyApp"
       "LOGIN_LBL" = "Login"
       ...
    }

Now a corresponding, different language (portuguese), Localizable file:

    {
       "APP_NAME" = "MinhaApp"
       "LOGIN_LBL" = "Entrar"
       ...
    }

There are even ways to implement plurals. 😁