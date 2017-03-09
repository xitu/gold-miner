> * 原文地址：[If I have one month to learn iOS: How would I spend it?](https://android.jlelse.eu/if-i-have-one-month-to-learn-ios-how-would-i-spend-it-a5b2aba87cc2#.8dh9co4nl)
* 原文作者：[Quang Nguyen](https://android.jlelse.eu/@quangctkm9207?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# If I have one month to learn iOS: How would I spend it? # 

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*7kScZyq1aZUf6bjVC7oA7g.png">

Source: [https://unsplash.com/@firmbee](https://unsplash.com/@firmbee) 

Exactly one year ago, I had been working as an Android developer. At that time, I did not have any knowledge about iOS programming, even I had never used any Apple products. It, however, was in the past, I have been developing both iOS and Android apps in parallel.

Today, after looking back, I want to share the syllabus of iOS programming course that I created by myself for one-month studying. 
In my personal experience, I really recommend that Android developers learn to develop iOS apps. It sounds weird but don’t get me wrong. There is a reason: **Expanding your knowledge widely helps you to go deeper in your field.**

> “If you do something and it turns out pretty good, then you should go do something else wonderful, not dwell on it for too long. Just figure out what’s next.” — **Steve Jobs**

Coming back to the main topic, I started by writing my own schedule for one month, and of course, every resources were completely free.

### Get started with Swift ###

You can learn Objective-C instead but I really recommend that you go with Swift. It is a friendly and easy to learn.

[Apple official resource](https://developer.apple.com/library/prerelease/content/documentation/Swift/Conceptual/Swift_Programming_Language/index.html) is the first place I visited. Read through basic concepts and get your hand dirty by coding them along on Xcode.

Besides, you can try [Swift-learning course on Udacity](https://www.udacity.com/course/learn-swift-programming-syntax--ud902). Although the website said that it will take about 3 weeks, but you can complete it in several days (several hours/days).

In my case, I spent one week on learning Swift. So, if you have time, there are several following resources you can explore:

- [Swift basic playgrounds](https://github.com/danielpi/Swift-Playgrounds) 
- [Raywenderlich’s Swift tutorials](https://www.raywenderlich.com/category/swift)
- [Design Pattern in Swift](https://github.com/ochococo/Design-Patterns-In-Swift)

### Draw your app interface with UIKit ###

Let’s move to a visual and interesting part. UIKit helps your work to be seen and interacted on iOS devices. It sounds good, doesn’t it.

In my case, I went to search for a free course on Udacity. Fortunately, I found it. [UIKit Fundamental Course](https://www.udacity.com/course/uikit-fundamentals--ud788)

At first, iOS Auto Layout was quite strange to me.The reason was that when developing Android apps, I used to implementing its interface via layout xml files and saw the result visually, almost never used drag-and-drop features. iOS, however, is totally different. 
After spending a while on practicing to understand Auto Layout mechanism, it was pretty awesome that I learnt something else beyond usual Android design style.

Besides, in Xcode, you can make transition between screens by just using dragging their connection in Storyboard, while Android requires some lines of code.

There are various features that you can explore.

Furthermore, you can check out more iOS UIKit tutorials in “Core Concepts” section of [iOS Raywenderlich page](https://www.raywenderlich.com/category/ios).

### Understand iOS data persistence ###

At the time you become familiar with UIKit, you can display data to users and retrieve data from them. It is great.

Next move is to store data that users can get them back even the app is closed. What I mean here is to keep data in user’s device hard drive but not in a remote server.

In iOS apps, you have several options:

- **NSUserDefaults** : is a key-pair type that is similar to SharePreferences in Android)
- **NSCoding / NSKeyed&#8203;Archiver** : serializes compliant classes to and from a data representation and stores it in File System or via NSUserDefaults
- **Core Data**: is iOS super-powerful framework
- Others: SQLite, Realm, and etc.

Now many iOS developers prefer Realm over Core Data but I recommend to learn Core Data because it is the iOS official persistent framework and when you understand its core structure and implementation, you can move the mountain.

The resources that I went through includes:

- [iOS Data Persistence and Core Data](https://www.udacity.com/course/ios-persistence-and-core-data--ud325)  by Udacity
- [Some Core Data tutorials](https://www.youtube.com/results?search_query=core+data)  on Youtube
- [NSCoding/NSKeyedArchiver article](http://nshipster.com/nscoding/)  by Mattt Thompson

### Get in touch with outside world via iOS networking ###

We are living in internet era, so your app should connect with the outside world and exchange information with others. Let’s move to the next lesson: iOS networking. You learn to work with REST API in iOS. It is important thing to remember that you should not use any third-party libraries at the moment. Let’s complete this lesson in iOS built-in frameworks.

In the future you have a lot of chances to work with cool http networking libraries like [Alamofire ](https://github.com/Alamofire/Alamofire) , but we are learning now. Going with basic and official things before swimming into others.

Recommended courses and tutorials:

- [NSURL Protocol](https://www.raywenderlich.com/76735/using-nsurlprotocol-swift)  tutorial by Raywenderlich
- [NSURL Session](https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started)  tutorial by Raywenderlich
- [Fundamental Networking course](https://www.udacity.com/course/ios-networking-with-swift--ud421) by Udacity

### **Build your first awesome app** ###

> “Knowing is not enough. Let’s apply”. — Leonardo da Vinci

You have many tools in your hand after following your iOS self-studying journey. You can program in Swift, sketch iOS app interface by using Story board and UIKit, persist data on device’s storage, and exchange information with the world via internet by using iOS Networking.

You are awesome, man. Let’s build whatever you want.

We are developers who make cool and valuable stuffs to make our tough world easier. So, you can try to build iOS app that improve your daily work, help your little brother, or even solve a global problem. Finally, I recommend that you publish it on Apple store. It helps you feel good and keep going on.

3 years ago, I published my first Android app (a note-taking app) on Google Play after learning Android for 1 months. 1 years ago, I also published my first iOS app (a weather app) on Apple Store after 1 month self-studying. They were both simple stupid at first, but they kept me being motivated and improving day by day.

You are better and I bet on it. So, let’s create something and show it to the world.

*Note:* There are many good resources out there, you can pick them up by searching Google. The tutorials and courses above are just my favorite selection.

Hope that this article is useful to you. If you liked this, click the 💚 below so other people will see this here on Medium.

