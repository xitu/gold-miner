> * 原文地址：[How to become an iOS developer, Bob](https://medium.com/ios-geek-community/how-to-become-an-ios-developer-bob-82944188ea7d#.dpn3k2gk1)
* 原文作者：[Bob Lee](https://medium.com/@bobleesj?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[thanksdanny](https://github.com/thanksdanny)
* 校对者：

# How to become an iOS developer, Bob #
# Bob，我要怎样才能成为一名 iOS 开发者 #

## iOS Development is hard. Embrace it and deal with it. ##
## iOS 开发虽不易，但别怕尽管上就是了。 ##

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*65b3tcODklio-5koqOe0dA.png">

然而这并不是我的桌面

### Personal Motivation ###
### 自我驱动 ###

I often receive emails and messages,
我经常收到类似的邮件跟私信，

*“Bob, how do I become a badass developer?”*
*“Bob，我怎样才能成为一个超酷的开发者？”*

*“Bob, I want to change my career. I like your articles and videos. How do I become an iOS developer?”*
*“Bob，我想转行了。我好喜欢你的文章跟视频。我要怎样才能成为一个 iOS 开发者呢？”*

*“Bob, I don’t know how to get started. I’ve never programmed before. Can u help me plz?”*
*“Bob，我不知道应该如何开始学。而且我之前也从来没写过代码，你能帮帮我吗？”*

I get it. But, I won’t lie. I despite answering generic questions. I call this, a ***How’s weather*** ***question***. It has no meaning. It shows a lack of preparation. I find myself repeating.
好啦我知道啦。但我会实话实说。我尽量去回答这些一般问题。我叫这中问题叫做“今天天气如何”。这没有任何特别的意思。这只说明缺少准备。我发现我自己在不断重复啦。

If they were my close friends, I probably would have retorted,
如果我是我身边的朋友问这些，我大概会怼他们了，

> “Have you googled, bro? If yes, google more.” — Me
> “哥们，你有自己去 goole 搜吗？已经查过的话，那就继续啊” - 我

Nonetheless, I’m aware I might be able to share limited insights through this article. Second, when someone asks me those how’s weather questions, I can say, “Please read this article first and then get back to me if you have any :)”.
虽说如此，我意识到我还是可以通过这篇文章分享我一些小小的见解的。这样当再有人问我类似的问题的时候，我就可以直接说，“先去看看我的这篇文章，还有问题才再来问我 :)”

***Disclaimer:*** *This is coming from my own head. I’m biased. I can only share my experience as Swift is my first programming language. Feel free to agree*
***免责声明：*** *这文章只是表达我个人的想法，可能还会存在错误的地方，因为我有时也会带有一些偏见。我只能分享一些 Swift 相关的经验，毕竟这是我的第一门编程语言。信不信由你啦* 


### 1. Chill and get the fundamentals ###
### 放松，慢慢去了解基础原理 ###

I understand. When I first started learning iOS, all I could think was building the next big thing. I bought online courses and books — “*The only course you need to become a paid iOS developer and make 18 apps*!” — I got hooked. Bullshit.
我也是过来人，当我最开始学 iOS的时候，我只能想象它就像是一个庞然大物。我买了一些线上课程还有一些书 -“*这堂课你唯一目标，就是要成为一个付费的 iOS 开发者，还要做出18个应用*！” - 当时我就迷上！太牛逼了！

I never understood what these `super`, `!`, `?` , `as`, `if let`, keywords represent. I became a code monkey. I copied off from the screen like a zombie. If you are currently there, **learn Swift first**. It’s not about iOS. It’s getting the fundamentals. It’s like you are learning how to write books before you learn grammar and alphabets. Yes, you still can publish that book.
我之前根本不知道 `super`, `!`, `?` , `as`, `if let` 这些关键词代表什么意思。我开始成为程序猿，像丧尸一般不停地写代码。如果你的进度也是差不多的话，**那就先学 Swift 吧**，虽然这跟 iOS 没有太大关系。但这是在为以后的学习打好基础。同样道理，在你学会写文章出书之前，你必须先学会语法跟字母表。相信我，只要坚持你也能将这本“书”出版的！

If you don’t understand any of these concepts in Swift below, you resort to those red marks on the left side of Xcode. Make sure you understand,
如果你还不清楚 Swift 下的这些概念，看着 Xcode 左侧的那些红色标记。保证你会明白了，

`delegate``extension``Protocol``optionals``super``generics``type casting``error handling``enum``closures``completion handlers``property observer``override``class vs struct`

Don’t worry. You are not doomed — I’ve covered all of them. You can find out here.
别担心啦，这些并概念并不是噩梦 - 我已经将它们全部转换了。你可以在这找到它们。

#### Resources ####
#### 资源 ####

Every tutorial above ([Personal Journey Note](https://bobleesj.gitbooks.io/bob-s-learning-journey/content/WORK.html))
所有的教程都在([Personal Journey Note](https://bobleesj.gitbooks.io/bob-s-learning-journey/content/WORK.html))

*Don’t even try learning functional programming, protocol-oriented programming, if you haven’t mastered Object Oriented Programming.*
*如果你你还没完全掌握面向对象编程，就不要尝试去学习函数式编程，面向协议编程了。*

### 2. Don’t get caught up with trying to understand all. Instead, find the patterns. ###
### 2. 不要苦于去理解全部，相反地，学会找到适合你的模式。 ###

This is contingent upon the fact you are familiar with those core concepts above in Swift, and you are currently learning the iOS ecosystem.
这实际上取决于你对 Swift 的核心概念的熟悉程度，何况你正在学习 iOS 的生态系统。

You don’t need to know everything in iOS. In fact, it’s too big. There are too many classes and frameworks we have to deal with, and we iOS developers can’t know much since they are not open sourced.
你根本不需要清楚 iOS 中的全部知识。实际上知识量太庞大了。要学这么多的类跟框架已经够呛了，何况 iOS 并不是开源的，我们开发者并不能清晰地了解其中的实现。

As a result, I’d like to describe iOS development is like **operating a microwave** . All you need to do is read the manuals, but in order to read the manuals, you must know how to read words and find some unique patterns.
所以做 iOS 相关开发的时候，我都会觉得像是在**操作一个微波炉**。你要做的只是去看操作手册，但读手册的时候，你也得知道如何去理解这些单词，还有找到独一无二的模式。

For example, to heat up, you press a couple buttons and the plate rotates along with a yellowish light comes from the wall. It’s the same thing. **It just works because Apple engineers have designed that way.** But as an iOS developer, your job is to understand why they have implemented such way. For example, I’d ask, “how does the rotation of the plate help heating up the food?”. That’s it. You don’t need to know how electromagnetism works in-detail although it certainly helps.
举个例子，当你去加热，你按下几个按钮后转盘开始旋转了，黄色的灯光开始照射在炉壁上。就是这么个道理，** 他之所以这样去运行，是因为苹果的工程师已经将他的运行方式设计好了。 **但作为 iOS 开发者，你的工作就是知道为啥他们会这么做。再举个例子，我问，“这旋转的盘子是怎么让食物加热的？”。就像是这样，你其实并不需要知道电磁学的细节原理，虽然知道的话确实会有帮助。

For example, I’d ask, why did Apple engineers implement `delegate` patterns and `MVC`? Always find their motives, and if you understand through googling, that’s it. It just works.
最后再举多个例子，我会问，为什么苹果的工程师要实现 `delegate` 模式与 `MVC`？学会去寻找他们的动机。假如你 google 到了其中的原理，对，就是这么做！

### 3. Dealing with APIs and document ###
### 3. 多与 API 和文档打交道 ###

Once you understand concepts such `delegate`, `protocol`, it becomes much easier for you to read the API documentation. However, most guides such as [Bundle Programming Guide](http://bundle%20iOS%20guide) are still written in Objective-C.
当你熟悉 `delegate`,`protocol`这些概念后，API 文档读起来就会变得更容易了。然而大部分像 [Bundle Programming Guide](http://bundle%20iOS%20guide) 类似的 guides 还是用 Objective-C 写的。

**Don’t worry**. You can easily convert Objective-C to Swift. You can find it right [here](https://objectivec2swift.com/#/home/main).
**不要担心**。从 Objective-C 转换为 Swift 还是很好理解的。你可以点击 [这里](https://objectivec2swift.com/#/home/main)。

I often describe learning APIs is analogous to learning how to drive various vehicles. For example, `UITableView` and `UICollectionView` are like riding a bicycle vs motorcycle. Using`NSURLSession` to download and upload data feels like riding a BMW. Creating an open source project is like controlling an airplane.
我经常说学习 API 就像学习如何驾驶各种交通一样。例如，`UITableView` 和 `UICollectionView` 对比起来，就像驾驶单车跟摩托。使用 `NSURLSession` 去上传下载数据的感觉，就像在开宝马一般。而创建一个开源项目，就像在驾驶着一架大型的飞机。

Regardless of vehicle types, they all share fundamental features/patterns. There are handle(s) and breaks, engines and oil to operate.
其实无论是任何交通工具的类型，他们都是共享着最基础的功能/模式。就比如我们的操作用到手把跟刹车，带来动力的引擎以及汽油。


Finding those patterns are hard. But, it’s okay to struggle. The harder the task, the more accomplishment you feel when you eventually get it. For instance, people climb the Mt.Everest despite death threat. People leave the stadium when the football/soccer score is 5–0. There are too many patterns and you already know the answer — google, learn, apply, repeat.
找到那些相似的模式都是不易的，但很值得投入时间去折腾。越有难度的任务，当你完成之后你就越有成就感。打个比方，就算面临死亡的威胁，人们还是不顾一切地去攀登珠穆朗玛峰。当球赛比分为 5-0 ，人们都会失望离场，就等着你逆袭的时候。这已经有太多熟悉的模式以及你所了解的答案 - goole，学习，应用，不断循环。

### 4. Opinion on open source ###
### 4. 关于开源的意见 ###

**Do not use open source projects unless you know how to duplicate such features on your own**
**不要使用开源项目，除非你有能力自己去实现出相同的功能**

iOS developers rely on open source projects for networking, animation, and UI. Often times, however, beginners simply download and implement. It has made everything so simple that they don’t even learn anything.
iOS 开发者依赖开源项目去实现网络，动画，还有 UI。然而，初学者通常都是直接下载这些库去使用。这让一切都变得十分简单，以至于他们学不到任何东西。

This is a problem. Imagine you need to do such a simple task. You must import a huge library. It’s like opening a soda can with a swiss army knife. You just don’t need it. If you have to carry it, it becomes cumbersome.
这就是问题所在，想象一下你只需要做一个十分简单的任务，你却需要导入一个这么大的库。这就像你只需要开一瓶小小的苏打水，却要用瑞士军刀。根本没必要大材小用。但当你必须添加这个库时，你的项目会变得十分臃肿。

If you don’t know how to get those effects and features, go study. It’s called, “Open Source”. Simply download their code and dissect, and copy proudly if necessary.
如果你不知道如何做出这些功能还有特效，那就去学习吧。这才是所谓的“开源”精神，下载他们的代码并开始仔细地分析，如果必要的话，你还可以“光明正大”地抄写这些代码。

*In order to do it successfully, you must understand* `Access Control` *and a firm understanding of Object Oriented Programming.*
*为了成功地去做到这一点，你必须了解* `Access Control` *，还有我们十分熟悉的面向对象编程。*

Don’t get me wrong. I use libraries all the time. But, I use them because I know how to use them without it. Most importantly, it saves time which has to do with preservation of my life.
不要误会我，这些开源库我也会经常使用，但我使用这些开源库，是因为就算没有这些库的情况下，我也知道应该如何去实现那些功能。更重要的是，利用这些开源库可以为我剩下不少的时间，然后去做我想做的事。

*I like to ride a bicycle with my hands off so that I can enjoy the scene at the same time, but there are times I have to quickly grab the bar to change the direction. Had I not known how to ride a bicycle in the first place, it would have been paradoxical.*
*我喜欢在骑单车的时候放开双手，这感觉让我十分的享受。一旦到关键时时刻，我也能快速抓紧把手控制好方向。若加入我不懂骑单车的话，那一切都太荒谬了。*

### 5. Protocol Oriented Mindset ###
### 5. 面向协议思维 ###

Assuming you are familiar with OOP, I’d like you to think how you can design such features with POP first. I’ve written a couple tutorials for you why it is a great idea to use POP. You may start with [Part 1](https://medium.com/ios-geek-community/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f#.nj16kndks) and [Part 2](https://medium.com/ios-geek-community/protocol-oriented-programming-view-in-swift-3-8bcb3305c427#.33aau3khn) .
假设你已经熟悉了 OOP（面向对象编程），我更首先推荐你去考虑用 POP（面向协议编程）去设计一个功能。我这里写了几个教程来告诉大家 POP（面向协议编程）是有多棒。你可以在 [Part 1](https://medium.com/ios-geek-community/introduction-to-protocol-oriented-programming-in-swift-b358fe4974f#.nj16kndks)和 [Part 2](https://medium.com/ios-geek-community/protocol-oriented-programming-view-in-swift-3-8bcb3305c427#.33aau3khn) 去开始学习。


### 6. Learn the life cycle of an App. ###
### 6. 理解 App 的生命周期。 ###

Know the differences between `ViewDidLoad`, `ViewWillAppear`, `ViewDidDisappear`. Understand why we use networking logic with `ViewWillAppear` instead of `ViewDidLoad`.
我们要知道 `ViewDidLoad`, `ViewWillAppear`, `ViewDidDisappear` 之间的区别。还要明白为啥要用 `ViewWillAppear` 来代替 `ViewDidLoad` 来实现网络逻辑。

Learn the role of `UIApplicataion` and why `AppDelegate` exists. I’ve already uploaded on YouTube for this.
学习 `UIApplicataion` 的作用，还有为啥 `AppDelegate` 会存在。我已经上传了相关视频在 YouTube 。

The Life Cycle of an App ([YouTube](https://www.youtube.com/watch?v=mD8hsQjR1zk))
关于 App 的生命周期 ([YouTube](https://www.youtube.com/watch?v=mD8hsQjR1zk))

### 7. Don’t worry about server. ###
### 7. 不要担心服务器 ###

If you are still struggling with Swift and iOS, forget about creating server and database. Just use **Firebase**, which is a backend as a service that allows you to store data with fewer than 10 lines of code.
如果你还在 Swift 与 iOS 中挣扎，那就不用考虑去设计一个服务器和数据库了。直接使用 **Firebase** 好了，他就是一个服务器后台，可以使你使用十行不到的代码就可以存储数据。

Hypothetically your app becomes popular over 100 million users, you can just hire a backend developer. An old man once said, if you try to catch two rabbits, you lose them all. Of course, if you feel confident with the iOS ecosystem, you may learn other areas.
假如你的 app 人气很旺，已经发展到一亿用户了，你可以请个开发会来做后台了。一个前辈曾经说过，如果你尝试去两头抓，那就就会两头都不到岸。当然，如果你觉得你对 iOS 的生态系统学习的差不多了，你也是时候去学习其他领域了。

### 8. Document. Document. Document ###
### 8. 笔记！笔记！笔记！ ###

I often describe learning APIs is like memorizing vocabulary words. I had to learn a couple thousand words to prepare for the standardized test for college. Of course, I mostly forget even if I fell confident at that moment. We’ve been there.
我经常说学习 API 就像是在背单词一样。在大学时候我得去学习几千个单词去应付考试。当然了，就算我现在已经忘得七七八八，但对于当时我的学习程度还是很自信的。

Some of you guys don’t know where to document. You don’t need a website. Look around first. Share on Medium. Upload on Github. Make YouTube videos, or if you are private, make a bunch of playground files on your computer.
有些人不知道应该在哪做笔记。你不需要什么特别的网站，先看看再说。你可以在 Medium 上分享，或者在 Github 上传你的笔记。还可以做个 Youtube 视频，就算是不公开的也 ok，然后多在电脑上做练习。

It not only serves as a place for you to store information but also you can possibly help others. I believe in good karma. Not to mention, it increases your personal brand and marketing.
写博客这并不仅是你存储信息的地方，通过在网上的记录你还可以帮助其他遇到同样问题的人。我相信善有善报的，更何况他还能构建起你的个人品牌，也能拓展开自己的市场。

If you’d like to know how to get started with blogging based on my journey, I’ve written an article on
我想你应该想知道在我是怎么开始写博客的，我把这篇文章写在

*What I learned from blogging for 10 weeks. (*[*LinkedIn*](https://www.linkedin.com/in/bobleesj?trk=hp-identity-photo) *)*
*我在写博客的这10周里学到了什么 (*[*LinkedIn*](https://www.linkedin.com/in/bobleesj?trk=hp-identity-photo) *)*

### 9. How to ask for help ###
### 9. 如何请求帮助 ###

As the editor of the Facebook Page called [iOS Developers](https://www.facebook.com/apple.ios.developers/?ref=bookmarks) close to 30,000 followers, I find that there could be a lot more improvement in soft-skills for those who ask for a favor.
有个博主他经营着一个叫 [iOS Developers](https://www.facebook.com/apple.ios.developers/?ref=bookmarks) 的 Facebook Page ，他已经将近有 30,000 粉丝，我发现那里有许多相关的软技能，相信对提问者会有很大帮助。

As a person who receives and asks many questions for help for many reasons, I’d like to share how I ask, and what has been working for me.
作为一个因为种种原因收到和提问很多问题想到得到帮助的人，在这里我分享一些我提问的方式以及行之有效的方法给大家。

Instead of stating my question right away, I’d write a sentence or two about who I’m, and how I’ve found the person. Then, I clearly state what I’ve been doing to find the answer/solution. Not to mention, I do not ask a how’s weather question. For bonus tips, if I really want my question to be answered thoroughly, I provide some incentives for the other person. I’d slightly indicate that I’d be more than happy to share his/her work with others.
首先我不会立刻说出我的问题，我会写几句来先介绍我是谁还有我是如何找到他的。然后，我开始列出我找到的问题答案还有解决办法。更不用说我不会问一些无关紧要的问题了。给个提示，如果我真的想要我的问题被彻底地解答，我会给其他人带来一些激励，我会表示当有解决方案的时候，我会乐意去分享给大家。

*Before you ask, search at least first 10 pages of Google. You will be surprised how much you learn besides that particular problem.*
*不过在你提问之前，先请搜索最少10页的 Google。你从中会很惊讶地发现，通过搜索这问题你会发现不少意外的收获。*

### 10. Do not rely on Tutorials ###
### 10. 不要依赖教程###

Often times, we seek mentors for guidance and help. However, it’s okay to attempt to crack a rock with an egg. You will learn and discover that it’s not the best way.
通常，我们都希望得到大神们的指导与帮助。然而遇到问题时，尝试去鸡蛋碰石头是 ok 的，因为这样你会发现这并不是最好的解决方法。

Learning is done by you. If you keep relying on tutorials, you lose the ability to catch fish. I mean, it’s good that you keep coming back to my work, but if you want to become a sustainable iOS developer, you go to **documentations**. Attempt to read those API guidelines provided by Apple. Challenge yourself. Sometimes you might have to grind through and read multiple times.
学习是靠你自己的。如果你一直依赖教程，你就是丧失“捕鱼”的能力。我的意思是，虽然你继续看我的教程也是很可以的，但如果你希望成为一个可持续发展的 iOS 开发者，你应该学会自己去总结出**文档**。尝试去阅读那些苹果提供的 API guidelines，并尝试着去挑战自己。有时你就是需要不断地阅读文档来折腾自己才能获得提升。

In fact, I’ve read the official Swift documentation from top to bottom more than 3 times, and memorized all of their examples. Reading a manual is a learned skill.
实际上，我已经能从头到尾读了 Swift 的官方文档超过3遍了，还熟记他里面的各种示例。通过阅读文档去学习也是种学习技能。

Tutorials are packaged in a way students easily understand, but it certainly does not cover the entire functionalities. For example, there is no way for me to go through the Foundation library in Swift and make tutorials out of it.
教程通常都被包装成一种让学生容易理解的方式，但毫无疑问他并不包含很多基础内容。举个例子，如果只通过教程的学习，我是没办法完整地学习 Swift 的 Foundation 库的。

*It’s okay to read tutorials. I do it all the time. However, be willing to raise your eyebrows time to time if you think there must be a better way. As a blogger and instructor myself, I admit that my way could be inefficient. I understand. I’m a flawed human being.*
*阅读教程是可以的。我以前也经常这么做。然而如果你发现有更好的学习方式，就要立刻睁大你的眼睛了。我身为这篇博客的导师，我敢说我的方法不一定是最好的，因为我知道人无完人。*

### Last Remarks ###
### 最后的话 ###

For those who want to give up iOS development, that’s okay. Please give up. We have plenty, and we do not need another mediocre iOS developer in 2017.
对于那些想放弃的 iOS 开发者，你可以随时放弃都没问题，毕竟现在开发者太多了，而且我们也并不希望在 2017 年有更多平庸的开发者。

If we have running water and an internet access, if we afford 3 meals a day, **we do not complain**. If I am able to learn and teach Swift and iOS in 6 months with no mentor, no CS degree at 20, but only through Google, yes we can.
如果能给我们提供充足的饮料、流畅的网络以及提供一日三餐，**我们就不会抱怨啥了**。假如我20岁的时候仅仅通过 Google，能在没有获得计算机学位的前提下六个月无师自通地学会 Swift 与 iOS，那么我相信你们也一定可以！

*I’m sorry if this article sounded brash. As I was writing it, I got frustrated how the voice of negativity and complains beat the shit out of the reality of how lucky and blessed we are to live in 2017, not in 1523. As a final statement, I’d like to share one of my favorite quotes from a blind person.*
*如果给篇文章读起来让你感觉到很傲慢，我感到十分抱歉。我感到很沮丧，为啥会有这种消极与抱怨的声音，去打击我们所在的现实中充满幸运与祝福的 2017 年，现在已经不是 1523 年了。作为文章最后的声明，我想分享一则来自一位失明者的格言，也是我最喜欢的格言之一。*

> “The only thing worse than being blind is having sight but no vision”. — Helen Keller
> “唯一比看不见更糟糕的事情就是能看见但是没有愿景”。 - Helen Keller

I hope this is my first and the last article without an emoji. Talk to you soon.
我希望这是我第一篇也是最后一篇没有使用 emoji 表情的文章。下次再见。
