> * 原文地址：[MVVM + RxSwift on iOS part 1](https://hackernoon.com/mvvm-rxswift-on-ios-part-1-69608b7ed5cd)
> * 原文作者：[Mohammad Zakizadeh](https://medium.com/@mamalizaki74)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mvvm-rxswift-on-ios-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mvvm-rxswift-on-ios-part-1.md)
> * 译者：
> * 校对者：

# MVVM + RxSwift on iOS part 1

![](https://cdn-images-1.medium.com/max/3200/1*MBFqJmaLduJLbjYleVVOqQ.jpeg)

In this article I’m going to introduce MVVM design pattern in iOS programming and of course with RxSwift.This article divides into two parts. In part 1 design pattern explained briefly and basics of RxSwift, and in [part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) , we have an example project of MVVM with RxSwift.

## Design patterns:

***

At first ,It’s better to explain why we should use design patterns? In short: In order to avoid our code getting spaghetti 🍝 and of course this is not the only reason. One of the reasons is testability . There are bunch of design patterns and we can point some of the popular ones to **MVC**,**MVVM**,**MVP** and **VIPER**. There is a good picture from NSLondon slides that compare design pattern to Distribution,Testability and Ease of use.

![Compare of design patterns ( from NSLondon )](https://cdn-images-1.medium.com/max/3664/1*wRnW_Qb2Q0rPTjbqQ96dhQ.png)

All of these design patterns have its own advantages and disadvantages but in the end, each of them makes our code cleaner, simpler and easier to read.This article focuses on **MVVM,** which I hope you’d realize the reason at the end of [part 2](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md).

So let's take a brief look at MVC and then we proceed to MVVM

***

### MVC:

You are probably familiar with **MVC** if you have been coding in iOS for a while ( Apple suggests using MVC for iOS programming ).This pattern composes from **Model**,**View** and **Controller** in which the controller is responsible for connecting model to view.In theory, it seems that the view and the controller are two different things but in iOS world, unfortunately, these two become one thing ( mostly ) . Of course everything seems well ordered in small projects but once your project gets bigger, controller almost has most of the responsibilities ( also named as Massive View Controller :D ), which leads your code becoming a mess, but if you can write MVC in correct way and divide your controller as much as you can, the problem will be resolved ( mostly ).

![MVC from apple docs](https://cdn-images-1.medium.com/max/2608/1*la8KCs0AKSzVGShoLQo2oQ.png)

### MVVM:

![picture from github](https://cdn-images-1.medium.com/max/2912/1*VoIppMaaG6ZwRuE6zpctlg.jpeg)

Well **MVVM** stands for **Model**,**View**,**ViewModel** in which controllers, views and animations take place in **View** and Business logics, api calls take place in **ViewModel.** In fact this layer is interface between model and View and its going to provide data to **View** undefinedas it wants. There is point that if you see following code in your ViewModel file you probably made a mistake somewhere :

```
import UIKit
```

because ViewModel shouldn't know anything from view, In [Part II](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) we will examine this article with a precise example.

## RxSwift:

***

One of the MVVM’s features is binding of data and view, which makes it pleasant with RxSwift.Of course you can do this with delegate,KVO or closures but one of the RxSwift’s feature is that if you learn it in one language you can reuse it on other languages too, because basic of Rx is same in languages that it is supported ( you can find list of languages [here](http://reactivex.io/languages.html) ). Now in this part we are going to explain the basics of RxSwift which are basics of Rx world as well. Then in [part II](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) we’ll have a project in MVVM with RxSwift.

### Reactive programming:

Well RxSwift is based on reactive programming, so what does that mean?

```
In computing, reactive programming is a programming paradigm oriented around data flows and the propagation of change. This means that it should be possible to express static or dynamic data flows with ease in the programming languages used, and that the underlying execution model will automatically propagate changes through the data flow. — Wikipedia
```

Probability you didn't understand anything of this paragraph after reading it. We maybe it would be better to understand it with the following example:

Imagine you have three variables ( a,b,c ) like :

![](https://cdn-images-1.medium.com/max/2000/1*itRGsvQIT3NE7ceswB7_iw.png)

Now if we change `a` from 1 to 2 and we print `c` its value remains 3.But things are different in reactive world and `c` value’s is depend on `a` and `b` it means if you change `a` from 1 to 2 `c` value is change from 3 to 4 automatically and its not necessary to change it yourself.

![](https://cdn-images-1.medium.com/max/2000/1*JLHnWaaUf5doo76E6BIXeA.png)

Now let's start RxSwift basics:

In RxSwift (and of course Rx ) world everything is stream of events ( including UI events , network requests , …) now remember this in your mind I will explain with real life example:

Your phone is an **Observable** which produces events for example ringing, push notifications , … which makes you to pay attention and in fact you **subscribed** to your phone and decide what to do with these events for example you sometime dismiss some of notifications or you answer some of them,… ( in fact these events are **signals** and you are an **observer** and making decisions)

![](https://cdn-images-1.medium.com/max/2000/1*iq8fm2j0k2b5xlpQorNiuA.gif)

Now let's do with code:

### Observables and observers (subscribers):

In Rx world some of variables are **Observable** and the other are **Observers ( or subscribers) .**

Hence **Observable** undefinedis generic you can make observable from any type you want if it confirms to ObservableType protocol.

![](https://cdn-images-1.medium.com/max/2000/1*6_7m7BB05qfWrK4opp5xDA.png)

Now let's define some observables:

![](https://cdn-images-1.medium.com/max/2012/1*_Lzu5Qp3f0j8PTyJ76QM3Q.png)

In first line of above example we have observable of String in line two we have observable of Int and at last we have observable of dictionary , now we should **subscribe** our observable values so we can read from emitted signals

![](https://cdn-images-1.medium.com/max/2000/1*aV60Aj4zGQ8O4jkSXE-BWQ.png)

It may question comes in your mind what are `next` and `completed` in output and just why ‘hello world’ is not printed well here I must say maybe the most important feature of Observables:

In fact every observables are **sequence** which the main difference with [swift sequence](https://developer.apple.com/documentation/swift/sequence) is that its value can be asynchronously .( if you didn’t understand these two lines it’s not important that much , hope you will understand with following description ) if we want say with image:

![sequence of events](https://cdn-images-1.medium.com/max/2000/1*sXgodZ2an2tnAixXOsEoWg.png)

In above image we have three observables which first one is type of Int and emitted 6 values of 1 to 6 in time then it has been completed.In second line we have observables of string and emitted ‘a,b,c,d,e,f’ in time then some error has occurred and it has been finished.At last we have observables of gesture then it has NOT been completed and it continues.

These images that shows events of observables are named marble diagrams. for more information you can either visit the [website](http://rxmarbles.com/) or download this application from [app store](https://itunes.apple.com/us/app/rxmarbles/id1087272442?ls=1&mt=8). ( it's [open source](https://github.com/RxSwiftCommunity/RxMarbles) too👍😎)

In Rx world for every observable in its persistent time emits 0 to … number of events ( above example ) which these events are enum consist of there 3 probable values:

***

 1. **.next**(value: T)

2. **.error**(error: Error)

3. **.completed**

When Observable adds value/values the `next` event is called and value/values are passed to subscribers(observers) via associated value property ( the 1 to 6 numbers , a to f and taps in above examples ).

If observable faces error ❌, the error event is emitted and observable has finished. ( after emitting `f` in above example )

if observable completes, .completed event is emitted ( after emitting 6 in above example )

If we want to cancel a subscription and unsubscribe from an observable we can call ****dispose**** method or if you want this method called when your view deinits you should make variable with ****DisposeBag**** type and this variable do the work for you when your class deinitilized. ****I must say if you don't remember this your subscribers will make memory leak****☠️💀****.**** undefinedfor instance observables should be subscribed like this:

![observable with disposeBag](https://cdn-images-1.medium.com/max/2000/1*aFPgU5V4UW8A5yNf32mssA.png)

Now let's see beauty of combining Rx with functional programming . Imagine you have observable of Int and you have subscribed to it, now that observable will give you bunch of Ints, you can do lots of changing on the emitted signals from observable for example:

***

### Map:

For changing signals before it reaches to its subscribers you can use map method , for instance we have observable of Int which emits 3 numbers of 2,3,4 now we want numbers multipled by 10 before reaching its subscriber we can do this with following code:

![map marble](https://cdn-images-1.medium.com/max/2000/1*fba7HHwf1BBKRiM8ka6WjQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*EI9Th1KK6ZzzJLef3nCfzA.png)

### Filter:

You may want filter some of values before reaching to subscribers for example you want numbers that are above 25 in above example:

![](https://cdn-images-1.medium.com/max/2000/1*bY-E-8wc2aAyC9LcVvFQBQ.png)

### FlatMap:

Imagine you have two observables and you want combine them into one observable:

![](https://cdn-images-1.medium.com/max/2868/1*UIhBMXe5aD1WFKeIbUTnaQ.png)

In above example observable A and observable B are combined and made new observable :

![](https://cdn-images-1.medium.com/max/2000/1*FzEoC5ds45mcvgux7fm_UQ.png)

### DistinctUntilChanged or Debounce:

These two methods are one of the most useful methods in searching. For example, user wants to search a word ,you probably call search api every character when user typed. Well, if the user types quickly, you are calling many unneeded requests to the server. Correct way of achieving this is to call search api when user stops typing . To solve this problem, you can use the Debounce function :

![](https://cdn-images-1.medium.com/max/2000/1*RnjfihjNN8ImbJN9CrWGGw.png)

In above example if username text field changes under 0.3 second those signals are not getting to subscribers so the search method isn't called and only when user stopped after 0.3 sec, signal will received by subscribers and search method is called.

The DistinctUntilChanged function is sensitive to changes, meaning that if two signals get the same signal until the signal does not change, it will not be sent to subscriber.

***

The Rx world is much bigger than what you can think of, and I just told a few basic concepts that I think would be needed in [the next part of the article](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md), which is a real project with RxSwift.

The RxSwift from [raywenderlich](https://store.raywenderlich.com/products/rxswift) describes very well RxSwift from 0 that I highly recommend reading.

You might not notice much about RxSwift from just one article because it’s one of Swift’s advanced concepts, and you might have to read different articles every day to find out. In [this link](https://github.com/mohammadZ74/handsomeIOS) you can see several good articles from his RxSwift section.

Hopefully, with [the next part of the article](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-mvvm-rxswift.md) that Rx introduces into the real project with MVVM, you will understand the concepts of RxSwift because it will be much easier to understand with real examples.

My twitter id is [Mohammad_z74](https://twitter.com/Mohammad_z74), and my email mohammad_z74@icloud.com✌️

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
