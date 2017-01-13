> * 原文地址：[The Next Step for Reactive Android Programming](http://futurice.com/blog/the-next-step-for-reactive-android-programming)
* 原文作者：[Tomek Polański](http://futurice.com/people/tomek-polanski)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# The Next Step for Reactive Android Programming #

The next generation of RxJava is out; RxJava 2. If you are working on a project which currently uses RxJava 1, you now have the option to migrate to the new version. But should you immediately start migrating or should you wait and pick up something from your project’s backlog instead?

To make a decision, you need to think in terms of Return on Investment (ROI); if the time spent on porting will pay off in short and long term.


## The Benefits of Migration ##


### Reactive Streams Compatibility ###

One of the architectural changes in RxJava 2 is the support for [Reactive Streams](https://github.com/reactive-streams/reactive-streams-jvm). To achieve that, RxJava had to be rewritten from the ground up.

Reactive Streams provides a common understanding and API of how a reactive library should work.

The majority of us do not write reactive libraries, but the benefit that it brings us is the ability to use different reactive libraries together.

An example is [Reactor 3](https://github.com/reactor/reactor-core) library, which is quite similar to RxJava. If you are an Android developer, you’re unlikely to have encountered it because it only works on Java 8+.

Nevertheless, converting a reactive sequence between those two libraries is as easy as this:

![](https://flockler.com/files/sites/377/rxjava_reactor.gif)

The code in green is RxJava 2 and in red is Reactor 3

It is a pity that we can’t use it on Android, as Reactor 3 has performance improvements of between 10% and 50% over RxJava 2.

To my knowledge, RxJava 2 is currently the only library that works on Android that supports Reactive Streams. That means, for the time being, that your ROI of using RxJava 2 for Reactive Streams is quite low.

 

### Backpressure - Observable/Flowable ###

In RxJava 2 there is a new reactive type, [Flowable](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Flowable.html), which is very similar to Observable from RxJava 1, but with a key difference; in RxJava 2, Flowable is the type that supports [backpressure](https://github.com/ReactiveX/RxJava/wiki/Backpressure).

Let’s clarify what “support backpressure” means.

People who are new to RxJava 2 often hear “Flowable supports backpressure” and ask, “Does backpressure support mean that I will never have MissingBackpressureException?”. The answer is, no.

The support for backpressure means that if the consumer of events is not keeping up with incoming events then it has a strategy to handle them. You need to specify that strategy!

 

#### Flowable ####

In the case of Flowables, you have to specify how it will behave - for that purpose you have a few strategies. This includes:

- 
Buffer - those events which the consumer is not able to begin processing immediately, are buffered and replayed when a consumer is done with the previous events.

- 
Drop - when the consumer is too slow, it will ignore all the items, once it’s ready for next element, it will take the most recently created one.

- 
Error - the consumer will emit MissingBackpressureException

Practically speaking, are you likely to encounter backpressure in our apps? I was wondering as well, so I wrote a Flowable that used accelerometer sensor. The readings I’ve printed on the screen:


![ezgif.com-resize.gif](https://lh4.googleusercontent.com/WlQs0ZXPuMRwwvURLtJNbFMt8zs1TJRHVeLMDm2Lr6IudegwaeWqTqyOi_wdZ-TdMHtxa_HNx4AsZi1h9IUW6EOY1lQg-rhQjPJtVSPsoKrLYKGlbhKpchnAt2sL0a5MUF5sWYEX)

Accelerometer using Flowables


The accelerometer on Android is producing around 50 readings per second and displaying all those values on the screen was not enough to encounter a backpressure problem. Naturally, this depends on processing load that occurs in your reactive sequence, but it’s enough to indicate that backpressure is not a routine occurrence.
 

#### Observable ####

Observable does not support backpressure. This means that they will never emit MissingBackpressureException. In case the consumer is not able to immediately process events, they will be buffered and replayed later.

So when should you use Flowable and when should you use Observable?

I use Flowable when backpressure issues are particularly likely to occur and if not handled correctly could lead to issues. In the case of the accelerometer, I would still use Flowable - if I took my sweet time with the readings than just printing them, backpressure would occur.

Observable should be used when the issue is not likely. If the user clicks some button a few times too many, we can live with them being buffered.

One word of caution, if you would use Observable in a place where a massive amount of events are buffered, the entire application will crash.

My rule of thumb would be when creating an Observable, think if the source of events behaves like:

- 
User tapping on a button - at most few events per second - use Observable

- 
Light or accelerometer sensor - tens of events per second - use Flowable

Remember that even if you take really long time to process button click, you will get backpressure issues!

 

### Performance ###

The performance of RxJava 2 [is better](https://github.com/akarnokd/akarnokd-misc/issues/2) than in the previous version.

Having more performant library is always a nice thing. However, you will only get noticeable returns if the bottleneck of your performance is in RxJava.

How many times you’ve looked at the code and thought “The speed of this flatMap is too damn slow!”?

In an Android application, the computation is not usually the issue. The majority of the times, the bottleneck is the UI rendering.

We are not losing frames because too many things happen on computation scheduler. We lose frames because the layout is too complex, we forgot to put file access on a background thread or we create bitmaps in onDraw.


## The Challenges of Migration ##
 

### Bye, Bye Nulls ###

In recent years more and more antagonism has grown against nulls. That shouldn’t be a surprise - even the inventor of Null Reference famously calls it “A Billion Dollar Mistake”.

In RxJava 1 you could get away with using null values. In the new version, you will not be able to use nulls at all: the use of null as a value in the stream is prohibited. If you are using nulls in your project, be prepared for plenty of rework.

You will need to find some other ways like [Null Objects Pattern](https://sourcemaking.com/refactoring/introduce-null-object) or [Optionals](https://github.com/tomaszpolanski/Options) to represent your missing values.
 

### Dex Limit ###

Have you ever tried to explain to a functional programmer that on Android we have an actual limit of how many functions we can write? Try it! Their reaction is priceless!

Sadly, we have this barrier of 65000 methods that we want to avoid exceeding. RxJava 1 has about 5500 methods, which is quite a lot. Now RxJava 2 has over 9200 methods. The increase of 4000 methods might be acceptable because of the functionality they bring, but because it is likely that you will migrate your application step by step, you will have both of the libraries at the same time while migrating.

In total, it is almost 15000 methods, which is 22% of the Dex limit!

Note that these numbers are taken without any minification via Proguard so will be able to save few thousands of methods.

Are you already over the limit? If you are, this is not an issue for you.

But if you are almost at the Dex limit, the migration might tip you over.


### Writing Operators ###

![good news.jpg](https://flockler.com/thumbs/sites/377/goog-news_s830x0_q80_noupscale.jpg)

The existing set of operators in RxJava might not always be enough. You might need some custom behaviour. In those cases, you might be tempted to write your own operator.

> Now writing an operator specifically for 2.x is 10 times harder than for 1.x.
> 
> - [Dávid Karnok ](https://github.com/ReactiveX/RxJava/wiki/Writing-operators-for-2.0)

In RxJava 1 this was not a trivial thing to do. You had to think about multi-threaded access and backpressure support.

In RxJava 2 things get serious. Firstly, the way that you create operators has changed; previously you would have done it with the infamous create method. Now in RxJava 2, apart from multi-threaded access, backpressure, cancellation and many others, you might consider using 4th generation features, such as [Operator Fusion](http://akarnokd.blogspot.de/2016/03/operator-fusion-part-1.html) that will increase your operator’s performance, but at the same time, will make it even more complex.

Is it really worth it to write custom operators?

Unless you write an operator to be included in RxJava 2 or other reactive libraries, I would advise you to find another solution.

First, check if it could actually be satisfied by a combination of the existing operators. Then you might consider writing a [transformer](https://github.com/ReactiveX/RxJava/wiki/Implementing-Your-Own-Operators#transformational-operators), it might be good enough solution for you. They won’t be as customizable as operators, but they are way easier to write. Another benefit of operators might be the performance, but again, on Android, there is a big chance that it would be wasted, as our bottleneck is usually the UI.

If you still are considering writing one, just compare one of the simplest ([map](https://github.com/ReactiveX/RxJava/blob/2.x/src/main/java/io/reactivex/internal/operators/observable/ObservableMap.java)) operators to one of the most complex ([flatMap](https://github.com/ReactiveX/RxJava/blob/2.x/src/main/java/io/reactivex/internal/operators/observable/ObservableFlatMap.java)), and consider if you are up to the challenge.
 

## Conclusion ##

So those are the main arguments for and against migration to RxJava 2. It is always up to you to say if the required migration work is worthwhile.

Currently, it’s completely fine to stay with RxJava 1, while it is still supported; support for it. In the near future, when RxJava 1 [will become deprecated](https://github.com/ReactiveX/RxJava/issues/4853#issuecomment-260660000), you will have a much stronger argument to switch to the next version.

If your project will last more than one year, you should reconsider migration, otherwise staying with RxJava 1 might be the better option.
 

If you are interested in how you could approach the migration, stay tuned for the next post.

 
