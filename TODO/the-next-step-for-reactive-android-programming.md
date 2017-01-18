> * 原文地址：[The Next Step for Reactive Android Programming](http://futurice.com/blog/the-next-step-for-reactive-android-programming)
* 原文作者：[Tomek Polański](http://futurice.com/people/tomek-polanski)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Goshin](https://github.com/Goshin)
* 校对者：[tanglie](https://github.com/tanglie1993)、[jamweak](https://github.com/jamweak)

# Android 响应式编程的未来展望

下一代的 RxJava 已经发布：RxJava 2。如果你现在的工作项目使用 RxJava 1，现在可以选择迁移至新版本。但我们是应该马上动手迁移，还是应该等待一段时间，先做些项目的其他工作？

要做出这个决定，你需要仔细考虑一下「投资回报（ROI）」，想想花费时间进行迁移能否在短期或长期内得到回报。


## 迁移的好处

### 响应流的兼容性

RxJava 2 其中一个结构性变化就是增加了对 [响应流（Reactive Streams）](https://github.com/reactive-streams/reactive-streams-jvm) 的兼容性。为此，RxJava 只能从头开始重写。

响应流为描述响应式编程库该如何运作提供了一种共同的理解和通用的 API。

我们大多数人并不编写响应式编程库，但相同的 API 可以让我们能够同时使用不同的响应式编程库。

其中一个例子就是 [Reactor 3](https://github.com/reactor/reactor-core) 库，这个库很像 RxJava。如果你是个 Android 开发者，可能没怎么跟它打过交道，因为它只支持 Java 8 及以上版本。

但不管怎样，现在在这两个库之间转换响应流可以像下面这样简单：

![](https://flockler.com/files/sites/377/rxjava_reactor.gif)

绿色代码是 RxJava 2，红色代码是 Reactor 3

Reactor 3 相较 RxJava 2 有 10% 至 50% 的性能提升，但遗憾的是不能用在 Android 上。

据我所知 RxJava 2 现在是唯一一个 Android 上支持响应流的库。也就是说，现如今为了响应流而使用 RxJava 2 意义并不大。

 

### 负载压力处理 - Observable/Flowable

RxJava 2 新增了一种响应式类型：[Flowable](http://reactivex.io/RxJava/2.x/javadoc/io/reactivex/Flowable.html)，它跟 RxJava 1 中的 Observable 很相似，关键区别在于 Flowable 类型支持[负载压力（backpressure）](https://github.com/ReactiveX/RxJava/wiki/Backpressure)处理。

首先明确一下什么是「支持负载压力处理」。

刚接触 RxJava 2 的开发者经常会听到「Flowable 支持负载压力处理」，想问：「支持负载压力处理就是说我不会遇到 MissingBackpressureException 是吗？」但答案是否定的。

支持负载压力处理就是说当事件消费者的处理能力不能负载源源不断的事件输入时，它可以指定一种策略来处理这些事件。

 

#### Flowable

在使用 Flowable 的情况下，你需要指明如何处理这种过载情况，包括以下几种策略：

- 缓存 - 对于消费者不能马上开始处理的事件，RxJava 会把它们缓存起来，等到消费者处理完先前事件时重新输入给消费者。

- 丢弃 - 如果消费者事件处理过慢，它会忽略所有新的到达事件，并在完成当前事件的处理后从最近的一个输入事件开始处理。

- 错误 - 消费者将会抛出 MissingBackpressureException。

在实际情况中，在我们的应用中会遇到负载压力吗？我也很好奇，所以编写了一个调用加速度传感器的 Flowable 例子，读取传感器数据并显示在屏幕上。


![ezgif.com-resize.gif](https://lh4.googleusercontent.com/WlQs0ZXPuMRwwvURLtJNbFMt8zs1TJRHVeLMDm2Lr6IudegwaeWqTqyOi_wdZ-TdMHtxa_HNx4AsZi1h9IUW6EOY1lQg-rhQjPJtVSPsoKrLYKGlbhKpchnAt2sL0a5MUF5sWYEX)

利用 Flowable 的加速度计


这个 Android 加速度计每秒处理大概 50 次数据读取，而这种频率下的数据显示尚不足以发生负载过重的情况。当然这取决于响应式序列中的每个事件的处理负荷，但也足以说明负载压力并不会经常出现。

#### Observable

Observable 不支持负载压力处理，这意味着 Observable 不会抛出 MissingBackpressureException。如果消费者不能马上处理事件，事件会被缓存起来等待重新输入。

那么我们什么时候该用 Flowable，什么时候又该用 Observable 呢？

在可能会出现负载压力且需要仔细处理对待的时候，我会选择 Flowable。例如上面的加速度计，我仍会使用 Flowable。因为如果我在读取传感器数据时需要额外做一些处理，而不是仅仅把它们显示出来，就有可能出现负载压力。

如果不太可能出现这种情况，应该选择 Observable。用户在一小段时间内点击多次按钮时，把这些事件进行缓存处理也是可以接受的。

不过要注意，使用 Observable 时，如果缓存了过多事件，整个应用会因此崩溃。

我的经验是，在创建 Observable 时，考虑事件源是否对应以下情形：

- 用户点击按钮，每秒最多数个事件，使用 Observable。

- 光线传感器或加速度传感器，每秒几十个事件，使用 Flowable。


记住：就算是点击按钮，如果每次处理耗时很长，也会出现负载压力！

 

### 性能表现

RxJava 2 的性能表现要[优于](https://github.com/akarnokd/akarnokd-misc/issues/2)上个版本的 RxJava 1.


可以用更高性能的库总是好事情。但是，只有当前性能瓶颈在于 RxJava 时，你才能看到明显的提升。

那你又是否曾经面对代码，抱怨「flatMap 实在是太慢了」？

对于一个 Android 应用，计算性能往往不成问题。在多数情况下，UI 渲染才是瓶颈所在。

发生丢帧不是因为有太多计算任务，而是因为布局太过复杂、没有把文件操作放在后台线程，或是在 onDraw 中创建 bitmap 等错误。


## 迁移带来的挑战

### 跟 Null 说再见

近年来对于 null 的抵制愈演愈烈，这并不奇怪，即使是 Null 引用的发明者也把它称为是「导致 10 亿美元损失的错误」。

在 RxJava 1 中你还可以使用 null 值。但在新版本，流序列中 null 值的使用会被完全禁止，你将不能再继续使用 null。如果你在当前项目中正使用着 null 值，请做好进行大量改写工作的准备。

你需要寻求一些其他方式，例如[空对象模式](https://sourcemaking.com/refactoring/introduce-null-object)或是 [Optional 对象](https://github.com/tomaszpolanski/Options)，来表示空值。
 

### Dex 限制

你有试过向函数式编程开发者解释「在 Android ，实际上函数的数量存在限制」吗？你可以试试，他们的反应会很有趣。

很遗憾，的确存在这个我们都尽量避免的 65000 个方法的数量限制。（译者注：如果方法超出这个数量，Java 字节码将需要分开存放在两个或多个 Dex 中。这个分割过程可以自动完成，一般无需干预，但在特定场景下，可能会引发问题。）RxJava 1 有大概 5500 个方法，数量不少。而现在 RxJava 2 则有超过 9200 个方法。这 4000 方法数量的增加相较于新增的功能来说还算是可以接受的，但在你逐步迁移的过程中，你也许会需要两个版本的库同时并存。

那么总共差不多就是 15000 个方法，已经占到了 Dex 限制的 22%！

注意以上方法数量的预估未考虑 Proguard 的压缩处理，所以实际中还可以省下几千个方法。

如果你早已经超出了这个限制，则不用担心这个问题。

但如果是十分接近的情况，则要在迁移过程中多加留意是否会超出 Dex 限制。


### 编写操作符

![good news.jpg](https://flockler.com/thumbs/sites/377/goog-news_s830x0_q80_noupscale.jpg)

RxJava 现有的操作符（Operator）可能不能满足你的需要。要实现一些自定义的行为机制，你也许会考虑自己编写操作符。

> 现在，给 RxJava 2.x 编写操作符要比给 1.x 编写难上 10 倍。
> 
> - [Dávid Karnok ](https://github.com/ReactiveX/RxJava/wiki/Writing-operators-for-2.0)

在 RxJava 1 时这也不是一件易事。你需要考虑多线程并发访问和对负载压力的处理支持。

到 RxJava 2 情况变得更加复杂。第一，创建操作符的方式已经改变，不再使用之前饱受诟病的创建方法。而且在 RxJava 2 中，除了多线程并发访问，负载压力处理，消除机制（cancellation）等麻烦问题，你还要考虑用上第四代特性，例如[操作符融合（Operator Fusion）](http://akarnokd.blogspot.de/2016/03/operator-fusion-part-1.html)，来提高操作符的性能。但这同时也增加了编写操作符的复杂性。

那么自己编写自定义操作符值得吗？

除非你是想为 RxJava 2 或其他响应式库贡献代码，否则我都建议用其他方法解决问题。

首先看看能不能通过现有操作符的组合使用来解决问题。或者你可以考虑编写一个[转换器（transformer）](https://github.com/ReactiveX/RxJava/wiki/Implementing-Your-Own-Operators#transformational-operators)。虽然不能像操作符那样高度可定制，但相对而言要容易编写得多。虽然使用操作符还有另一个提升性能的好处，但如上文所述，这种性能提升在 Android 中有很大可能会被浪费或掩盖，因为瓶颈往往在 UI 方面。

如果你仍想编写一个自定义操作符，可以对照一下最简单的操作符（[map](https://github.com/ReactiveX/RxJava/blob/2.x/src/main/java/io/reactivex/internal/operators/observable/ObservableMap.java)），和一个最复杂的操作符（[flatMap](https://github.com/ReactiveX/RxJava/blob/2.x/src/main/java/io/reactivex/internal/operators/observable/ObservableFlatMap.java)），看看你是否要应对挑战。
 

## 总结

以上就是升级到 RxJava 2 带来的主要好处与挑战。但要判断迁移是否值得总得根据你的实际情况而定。

就目前来说，停留在 RxJava 1 十分不错，它仍受开发团队维护和支持。在不久之后，当 RxJava 开发团队不再维护而选择[弃用 RxJava 1](https://github.com/ReactiveX/RxJava/issues/4853#issuecomment-260660000)，届时你也会有更加充分的理由升级到 RxJava 2。

如果你的项目要持续一年以上，你可能需要考虑迁移事宜，否则停留在 RxJava 1 是更好的选择。
 

如果你对如何迁移感兴趣，请留意我的下一篇文章。

 
