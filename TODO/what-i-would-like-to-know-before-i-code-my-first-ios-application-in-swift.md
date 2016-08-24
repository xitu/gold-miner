> * 原文地址：[What I would like to know before I code my first iOS application in Swift](https://medium.com/@bkzl/what-i-would-like-to-know-before-i-code-my-first-ios-application-in-swift-f11fcdde7887#.oeafmue7p)
* 原文作者：[Bartłomiej Kozal](https://medium.com/@bkzl?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


Last week, together with [my brother](http://medium.com/@_mac), we released [our first iOS application](http://echotags.io/appstore)developed in Swift. In this article, I would like to share my thoughts about the process.

*This is written from the perspective of a person who spent the last six years building various (in terms of scale and domain) web applications in Ruby and JavaScript and has now been working in Swift for the last three months.*

### Is Objective-C dead?

Swift is developed by Apple, one of the biggest companies in the world. This implies a lot of things; first of all, Apple isn’t afraid of introducing major changes to its platform. By major changes, I mean code-breaking updates too. You need to be aware of this.

For example, during the last WWDC, they announced the renaming of the larger part of the API. Swift itself was a huge shift from the previous main language for iOS developers — Objective-C. By the way, WWDC was, for me, like a week off work to catch up on all the interesting presentations and announcements. Even so, Swift is one of the best maintained open source projects I’ve ever seen. Just check the [repository with its language proposals](https://github.com/apple/swift-evolution/tree/master/proposals).

![](https://cdn-images-1.medium.com/max/1600/1*j4lJm5Dtpb4jLpGKlInOVA.png)

Swift vs DHH ;)

Does this mean that Objective-C is dead and you don’t need to know it? Kind of. I’m pretty sure most of the external libraries and code examples you’ll find on the Internet are written in Objective-C. What is interesting though, is that when I do more in Swift I have fewer problems with understanding Objective-C code. I can read it almost naturally.

Another fact you need to know is the size of the internal API, it’s huge and you may be scared when you start browsing it. You can build basically anything and access to all the mobile specific features like camera, microphone, geolocation, accelerometer, touch screen etc., is a lot easier than on the web.

### Toolset

XCode (Apple IDE) is the place where the magic happens. It includes all the tools that you will need during the development of iOS applications: code editor, interface builder, database manager, debugger, instrumentation tools, and more.

Unfortunately, it’s far from being perfect. Especially Interface Builder, which gives the most *“what is going on”* moments. When I started playing with it, I was really impressed — *“WOW! I can build the whole interface in a graphic editor like Sketch or Photoshop” — *it’s not true. Interface Builder is more like a layer of abstraction to override the written code than a tool to design UI.

It’s not an uncommon situation that you select an option in the Interface Builder but it doesn’t affect your application at all. There are many things there that you can’t guess, you just need to know them; such us wrong constraint warnings that you can fix by literally clicking on the warnings description. Also, when you remove outlets or actions always remember to delete references in storyboards. You don’t get any warnings during the compilation, but your app will crash if you don’t delete them.

You need to find the sweet spot. From my experience, Interface Builder is handy to design the flow of the application, place built-in UI elements, and create segues between view controllers (not between buttons and view controllers!). Store all settings in code and create custom UI elements using inheritance on existing UI objects.

When you’re creating an iOS application, there is significantly more computer graphic programming than in web applications. My advice is to read about basics like vectors or how transformations work. It’s very useful to know these topics because you will face them sooner rather than later.

Always test your interface on real devices. The feeling of clicking in a simulator and tapping the real device with your finger is completely different.

![](https://cdn-images-1.medium.com/max/1600/1*oiYF-MoPLhP-4TzkFdYggQ.png)

Draw attention on the X button — may look better on the mockup but swipe-down gesture is more intuitive on the device

The official dependencies manager isn’t released yet but you can choose between two community-driven alternatives: CocoaPods or Carthage. I’m using the first one and haven’t faced too many problems.

Last small tip: don’t rely on the undo option too much. XCode doesn’t jump between files when you press *cmd+z* so you can’t visually track changes. Remember to use Git and do commits often.

### Development differences between web and iOS

Once you create a new project you will quickly notice that nothing forces you to use any particular convention. Contrary to Ruby applications (not necessarily Rails), where each project has a similar directories structure, in iOS there are no strict rules as to how to organize your code. Every developer can structure their application how they want to. I don’t like this to be honest. Ruby’s approach is way more intuitive and beneficial because you can presume where to find specific code.

![](https://cdn-images-1.medium.com/max/1600/1*iLaegkpeKax7WTn7wJNC-g.png)

So where should I save new classes?

My next observation is that things which are easy to do in web applications are hard to do in mobile applications, and things which are hard to do in web applications are easy to do in mobile applications. For example, a vertical alignment of an element is a no-brainer, however, changing the font leading of labels isn’t so straightforward.

All the fancy UI features like animations, transitions or gestures are so much easier to do using iOS API than JavaScript/CSS for me.

Other big topics are limited resources and optimization. You can’t scale your application by adding cheap hardware to the infrastructure. There is an additional limitation of device battery. Using multiple CPU threads to optimize the program is a common practice and the performance difference between phone models is very significant.

Communication with external APIs is harder to manage. There are more edge cases and most of the errors, if not properly handled, result in a freeze or crash of the application.

Static typing and live pre-compilation are super useful and prevent you from making a lot of mistakes. I also like the idea of optionals, they ensure you don’t pass the nil unnoticed. I miss them now in web apps which depend on ActiveRecord.

On the other hand, I also miss some built-in functions from the Ruby standard library. At least you still have access to *map()*, *filter()*, and *reduce()*but a larger variety of methods would be useful. Moreover, you have to be careful because inconsistencies in the design of system APIs are normal. I have even faced functions with different names that did the same task, it was just that the implementation of one of them was older.

### Releasing the application

I must point out one fact: preparing the content took us more time than programming the app! Please pay attention to things like this because creating an application is not only about writing code.

App Store is the only official way to distribute your iOS applications and you pay 30% from each transaction to Apple. It doesn’t feel like a big cut until you see your sales report. It’s significant, and when you add the income tax you will see that you earn only half of the price from each sold unit of your app. Excluding all other costs and average prices in the App Store (most of the apps are free or cheaper than a cup of coffee) you will notice that you need a great product and good marketing to make a profit from it.

Apple doesn’t give you too many tools to market your application. You can provide a 30s video, up to 5 screenshots, title, description, and search keywords limited to 100 characters in total. The rest depends on your efforts. I don’t like the fact that keywords statistics aren’t available and you have to use external tools.

The last detail is the time taken for the application review. Once you send the build to the Apple servers and click on the release button you will have to wait in two queues. In the first one, you are waiting for a review. In the second one, your app is being reviewed. So, don’t expect that your new product or patch will be available the next day for the users.

### Learning materials

To finish, I would like to list some books and resources that I’ve been learning from:

[Design & Code ](https://designcode.io/)— I started with this course. It includes five books (three are strictly about programming). It’s really good for people who never coded before or have a graphic design background. It may not be the best choice for everyone but I still recommend it even though some details are outdated. Every chapter has a recorded video version.

[Stanford CS 193P lecture on iTunes U ](https://itunes.apple.com/us/course/developing-ios-9-apps-swift/id1104579961)— In my opinion the best course to start as it covers a bit of everything. Not for total beginners because it requires experience with object oriented programming. It’s free and up-to-date (Xcode 7, Swift 2 and iOS9). Every chapter ends with a project to repeat and verify what you have learned.

[Hacking with Swift](https://gumroad.com/l/hws-book-pack) — All about Swift and iOS programming. A very good complementary book to the Stanford lecture. Every chapter is a mini project that utilizes and explains one specific API. It might be a bit too long and you could get bored before the end, but it’s still worth the money.

[Pro Swift ](https://gumroad.com/l/proswift)— Only covers advanced topics in Swift. Every chapter has attached video where the author explains the topic with code examples. A must read/watch resource if you want to better understand Swift. Highly recommend it.

[100 Days of Swift](http://samvlu.com/tutorials.html) — 40 real-life projects built in Swift in a video form. The author shows a lot of “tribal knowledge” and useful hacks. It looks like it’s targeted at beginners but I wouldn’t recommend it for them because of the lack of explanations on topics. Worth watching if you already played a bit with Swift and iOS.

[iOS Developer Library](https://developer.apple.com/library/ios/navigation/) — The main resource I use now. Hard to start if you don’t know what are you looking for. You can see how Apple employees write and structure code. Be aware that examples could be written in Objective-C or outdated. The only resource for finding information about new APIs.

![](https://cdn-images-1.medium.com/max/1600/1*ZhHNBLXvxMvjsIp1KIFSsw.jpeg)

I’m on the right, what’s up 👋
