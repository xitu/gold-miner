> * 原文地址：[How to become an iOS developer, Bob](https://medium.com/ios-geek-community/how-to-become-an-ios-developer-bob-82944188ea7d#.dpn3k2gk1)
* 原文作者：[Bob Lee](https://medium.com/@bobleesj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# How to become an iOS developer, Bob #

## iOS Development is hard. Embrace it and deal with it. ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*65b3tcODklio-5koqOe0dA.png">

Not my desk

### Personal Motivation ###

I often receive emails and messages,

*“Bob, how do I become a badass developer?”*

*“Bob, I want to change my career. I like your articles and videos. How do I become an iOS developer?”*

*“Bob, I don’t know how to get started. I’ve never programmed before. Can u help me plz?”*

I get it. But, I won’t lie. I despite answering generic questions. I call this, a ***How’s weather*** ***question***. It has no meaning. It shows a lack of preparation. I find myself repeating.

If they were my close friends, I probably would have retorted,

> “Have you googled, bro? If yes, google more.” — Me

Nonetheless, I’m aware I might be able to share limited insights through this article. Second, when someone asks me those how’s weather questions, I can say, “Please read this article first and then get back to me if you have any :)”.

***Disclaimer:*** *This is coming from my own head. I’m biased. I can only share my experience as Swift is my first programming language. Feel free to agree*

### 1. Chill and get the fundamentals ###

I understand. When I first started learning iOS, all I could think was building the next big thing. I bought online courses and books — “*The only course you need to become a paid iOS developer and make 18 apps*!” — I got hooked. Bullshit.

I never understood what these `super`, `!`, `?` , `as`, `if let`, keywords represent. I became a code monkey. I copied off from the screen like a zombie. If you are currently there, **learn Swift first**. It’s not about iOS. It’s getting the fundamentals. It’s like you are learning how to write books before you learn grammar and alphabets. Yes, you still can publish that book.

If you don’t understand any of these concepts in Swift below, you resort to those red marks on the left side of Xcode. Make sure you understand,

`delegate``extension``Protocol``optionals``super``generics``type casting``error handling``enum``closures``completion handlers``property observer``override``class vs struct`

Don’t worry. You are not doomed — I’ve covered all of them. You can find out here.

#### Resources ####

Every tutorial above ([Personal Journey Note](https://bobleesj.gitbooks.io/bob-s-learning-journey/content/WORK.html))

*Don’t even try learning functional programming, protocol-oriented programming, if you haven’t mastered Object Oriented Programming.*

### 2. Don’t get caught up with trying to understand all. Instead, find the patterns. ###

This is contingent upon the fact you are familiar with those core concepts above in Swift, and you are currently learning the iOS ecosystem.

You don’t need to know everything in iOS. In fact, it’s too big. There are too many classes and frameworks we have to deal with, and we iOS developers can’t know much since they are not open sourced.

As a result, I’d like to describe iOS development is like **operating a microwave** . All you need to do is read the manuals, but in order to read the manuals, you must know how to read words and find some unique patterns.

For example, to heat up, you press a couple buttons and the plate rotates along with a yellowish light comes from the wall. It’s the same thing. **It just works because Apple engineers have designed that way.** But as an iOS developer, your job is to understand why they have implemented such way. For example, I’d ask, “how does the rotation of the plate help heating up the food?”. That’s it. You don’t need to know how electromagnetism works in-detail although it certainly helps.

For example, I’d ask, why did Apple engineers implement `delegate` patterns and `MVC`? Always find their motives, and if you understand through googling, that’s it. It just works.

### 3. Dealing with APIs and document ###

Once you understand concepts such `delegate`, `protocol`, it becomes much easier for you to read the API documentation. However, most guides such as [Bundle Programming Guide](http://bundle%20iOS%20guide) are still written in Objective-C.

**Don’t worry**. You can easily convert Objective-C to Swift. You can find it right [here](https://objectivec2swift.com/#/home/main).

I often describe learning APIs is analogous to learning how to drive various vehicles. For example, `UITableView` and `UICollectionView` are like riding a bicycle vs motorcycle. Using`NSURLSession` to download and upload data feels like riding a BMW. Creating an open source project is like controlling an airplane.

Regardless of vehicle types, they all share fundamental features/patterns. There are handle(s) and breaks, engines and oil to operate.

Finding those patterns are hard. But, it’s okay to struggle. The harder the task, the more accomplishment you feel when you eventually get it. For instance, people climb the Mt.Everest despite death threat. People leave the stadium when the football/soccer score is 5–0. There are too many patterns and you already know the answer — google, learn, apply, repeat.

### 4. Opinion on open source ###

**Do not use open source projects unless you know how to duplicate such features on your own**

iOS developers rely on open source projects for networking, animation, and UI. Often times, however, beginners simply download and implement. It has made everything so simple that they don’t even learn anything.

This is a problem. Imagine you need to do such a simple task. You must import a huge library. It’s like opening a soda can with a swiss army knife. You just don’t need it. If you have to carry it, it becomes cumbersome.

If you don’t know how to get those effects and features, go study. It’s called, “Open Source”. Simply download their code and dissect, and copy proudly if necessary.

*In order to do it successfully, you must understand* `Access Control` *and a firm understanding of Object Oriented Programming.*

Don’t get me wrong. I use libraries all the time. But, I use them because I know how to use them without it. Most importantly, it saves time which has to do with preservation of my life.

*I like to ride a bicycle with my hands off so that I can enjoy the scene at the same time, but there are times I have to quickly grab the bar to change the direction. Had I not known how to ride a bicycle in the first place, it would have been paradoxical.*

### 5. Protocol Oriented Mindset ###

Assuming you are familiar with OOP, I’d like you to think how you can design such features with POP first. I’ve written a couple tutorials for you why it is a great idea to use POP. You may start with [Part 1](https://medium.com/ios-geek-community/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f#.nj16kndks) and [Part 2](https://medium.com/ios-geek-community/protocol-oriented-programming-view-in-swift-3-8bcb3305c427#.33aau3khn) .

### 6. Learn the life cycle of an App. ###

Know the differences between `ViewDidLoad`, `ViewWillAppear`, `ViewDidDisappear`. Understand why we use networking logic with `ViewWillAppear` instead of `ViewDidLoad`.

Learn the role of `UIApplicataion` and why `AppDelegate` exists. I’ve already uploaded on YouTube for this.

The Life Cycle of an App ([YouTube](https://www.youtube.com/watch?v=mD8hsQjR1zk))

### 7. Don’t worry about server. ###

If you are still struggling with Swift and iOS, forget about creating server and database. Just use **Firebase**, which is a backend as a service that allows you to store data with fewer than 10 lines of code.

Hypothetically your app becomes popular over 100 million users, you can just hire a backend developer. An old man once said, if you try to catch two rabbits, you lose them all. Of course, if you feel confident with the iOS ecosystem, you may learn other areas.

### 8. Document. Document. Document ###

I often describe learning APIs is like memorizing vocabulary words. I had to learn a couple thousand words to prepare for the standardized test for college. Of course, I mostly forget even if I fell confident at that moment. We’ve been there.

Some of you guys don’t know where to document. You don’t need a website. Look around first. Share on Medium. Upload on Github. Make YouTube videos, or if you are private, make a bunch of playground files on your computer.

It not only serves as a place for you to store information but also you can possibly help others. I believe in good karma. Not to mention, it increases your personal brand and marketing.

If you’d like to know how to get started with blogging based on my journey, I’ve written an article on

*What I learned from blogging for 10 weeks. (*[*LinkedIn*](https://www.linkedin.com/in/bobleesj?trk=hp-identity-photo) *)*

### 9. How to ask for help ###

As the editor of the Facebook Page called [iOS Developers](https://www.facebook.com/apple.ios.developers/?ref=bookmarks) close to 30,000 followers, I find that there could be a lot more improvement in soft-skills for those who ask for a favor.

As a person who receives and asks many questions for help for many reasons, I’d like to share how I ask, and what has been working for me.

Instead of stating my question right away, I’d write a sentence or two about who I’m, and how I’ve found the person. Then, I clearly state what I’ve been doing to find the answer/solution. Not to mention, I do not ask a how’s weather question. For bonus tips, if I really want my question to be answered thoroughly, I provide some incentives for the other person. I’d slightly indicate that I’d be more than happy to share his/her work with others.

*Before you ask, search at least first 10 pages of Google. You will be surprised how much you learn besides that particular problem.*

### 10. Do not rely on Tutorials ###

Often times, we seek mentors for guidance and help. However, it’s okay to attempt to crack a rock with an egg. You will learn and discover that it’s not the best way.

Learning is done by you. If you keep relying on tutorials, you lose the ability to catch fish. I mean, it’s good that you keep coming back to my work, but if you want to become a sustainable iOS developer, you go to **documentations**. Attempt to read those API guidelines provided by Apple. Challenge yourself. Sometimes you might have to grind through and read multiple times.

In fact, I’ve read the official Swift documentation from top to bottom more than 3 times, and memorized all of their examples. Reading a manual is a learned skill.

Tutorials are packaged in a way students easily understand, but it certainly does not cover the entire functionalities. For example, there is no way for me to go through the Foundation library in Swift and make tutorials out of it.

*It’s okay to read tutorials. I do it all the time. However, be willing to raise your eyebrows time to time if you think there must be a better way. As a blogger and instructor myself, I admit that my way could be inefficient. I understand. I’m a flawed human being.*

### Last Remarks ###

For those who want to give up iOS development, that’s okay. Please give up. We have plenty, and we do not need another mediocre iOS developer in 2017.

If we have running water and an internet access, if we afford 3 meals a day, **we do not complain**. If I am able to learn and teach Swift and iOS in 6 months with no mentor, no CS degree at 20, but only through Google, yes we can.

*I’m sorry if this article sounded brash. As I was writing it, I got frustrated how the voice of negativity and complains beat the shit out of the reality of how lucky and blessed we are to live in 2017, not in 1523. As a final statement, I’d like to share one of my favorite quotes from a blind person.*

> “The only thing worse than being blind is having sight but no vision”. — Helen Keller

I hope this is my first and the last article without an emoji. Talk to you soon.
