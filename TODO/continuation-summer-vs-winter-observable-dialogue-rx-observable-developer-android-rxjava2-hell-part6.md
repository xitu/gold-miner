> * 原文地址：[Continuation (Summer vs Winter Observable) of Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part6](http://www.uwanttolearn.com/android/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md)
> * 译者：[hanliuxin](https://github.com/hanliuxin5)
> * 校对者：

# 大话（Summer vs winter Observable）之我与 Rx Observable[Android RxJava2]（这是什么鬼）第六话

哇哦，又是新的一天，是时候来学习一些新的＂姿势＂了 🙂。

大家好啊，希望你目前都还感觉不错。这是我们 RxJava2 Android 系列的第六篇文章　[ [第一话](https://juejin.im/entry/58ada9738fd9c5006704f5a1), [第二话](https://juejin.im/entry/58d78547a22b9d006465ca57), [第三话](https://juejin.im/entry/591298eea0bb9f0058b35c7f), [第四话](https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md), [第五话](https://juejin.im/post/590ab4f7128fe10058f35119), [第六话,](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md) [第七话](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md) and [第八话](https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md) ]。在这一篇文章中，我们将继续与 Rx 展开对话。还有一件重要的事情是，基本上 Summer vs Winter 意味着 Hot 和 Cold Observale 🙂 .

**我为啥要写这个呢:**
原因和我在 [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/) 与你分享过的一样。

**引言:
**这篇文章并没有引言，因为这其实是我们上一篇文章的延续，但在开始之前我想我们应该进行一下前景回顾。上一篇文章中我们遇到了一位 Rx Observable。他给了我们不少关于学习 Rx 的建议，然后他还分享给了我们一些可以用来创造 Observable 的方法，最后他打算告诉我们一些关于冷热 Observable 的东西，结果我们就此打住。

**紧接上一话:**

Observable：其实还有很多。我在这里介绍两类 Observable 对象。一种叫做 Cold Observable，第二个是 Hot Observable。有些时候开发者习惯把 Hot 和 Cold Observabels 来做比较 :)。 这些真的是很简单的概念。相反，我会通过使用一些真正不复杂的例子来给你一个概念，然后我会告诉你如何在编码中使用它们。再之后我想我会给你一些真真正在的例子，你觉得如何？

我：当然，我会试着保持在你跟前，这样你可以随时检查我是否有做错的地方.

Observable: 哈哈哈哈，当然了。那么有多少人了解商场的促销人员，就是那些站在商店门口希望藉由大声吆喝来招揽顾客的人？

Me: 估计没几个，很多人都不太了解这种盛行于亚洲国家比如巴基斯坦和印度的销售文化。。。你能试着采用一些更加通俗的例子吗，这样的话每个人都能更加轻易的理解这个概念。

Observable: 当然，没问题。有多少人了解咖啡和咖啡店呢？
Me: 差不多每个人吧。

Observable: 很好。现在这里有两家咖啡店，一家叫做霜语咖啡店，一家叫做火舞咖啡店。任何一个去霜语咖啡馆的人都可以买一杯咖啡，然后坐在咖啡馆的任何地方。咖啡厅里的每个座位上都提供了一副智能耳机。他们提供了一个有三首诗的播放列表。这些智能耳机很受欢迎，所以每个人都会戴上他们。这些耳机总是从第一首诗开始播放，如果有人中途取下了耳机后再次重新戴上，那么这些耳机仍然会重新从第一首诗开始播放。对了，如果你只是取下了耳机，那么它也就会停止播放。

反过来，火舞咖啡馆有一套完善的且需要耳机聆听的音乐播放系统。当你进入咖啡馆的时候，你就会开始听到他们播放的诗，因为他们有着非常好的音乐播放系统和一个大号的扬声器。他们还有着一个有着无限诗歌的播放列表，他们会打开这个系统当他们每天开始营业的时候。所以说这个系统的运行与顾客无关，任何将会进入这家咖啡馆的人都能听到那个时刻正在播放的诗，并且他永远也不知道他进入之前已经播放完了多少诗了。这跟我们要讲的 observable 是一个概念。

就像霜语咖啡馆的那些耳机，cold obervable 总是被动的。就像你用 Observable.fromArray() 或者其他任何方法来创造 Observable 一样，他们和那些耳机差不多。如同戴上耳机播放列表才会播放一样，当你开始订阅那些 Observable 后你才会开发接收到数据。而当订阅者取消了对 Observable 的订阅后，如同取下耳机后诗会停止播放一样，你也将不再能接收到数据。

最后的重点是霜语咖啡馆提供了很多副耳机，每副耳机只会在有人戴上它们之后才会开始播放。如果某个人已经播放到了第二首诗，但另外的某个人才戴上耳机，那么第二个人会从第一首诗开始播放。这意味着每个人都有独立的播放列表。就如同我们有三个订阅了 Cold Observable 的订阅者一样，它们会得到各自独立的数据流，也就是说 observable 会对每个订阅者单独地去调用三次 onNext 方法。换句话说就是，Cold Observable 如同那些耳机一样依赖于订阅者的订阅(顾客戴上耳机)。

Hot observable 就像火舞咖啡馆的音乐系统一样。一旦咖啡馆开始营业，其音乐系统就会开始播放诗歌，不管有没有人在听。每位进来的顾客都会从那个时刻正好在播放的诗开始聆听。这跟 Hot Observable 所做的事情一样，一旦它们被创建出来就会开始发射数据，任何的订阅者都会从它们开始订阅的那个时间点开始接收到数据，并且绝不会接收到之前就发射出去的数据。任何订阅者都会在订阅之后才接收到数据。我想我会使用同样的例子来进行编码，并且之后我会给一些真真正正的例子。

**Cold Observable:**

```
public class HotVsCold {

    public static void main(String[] args) throws InterruptedException {

        List<String > poemsPlayList = Arrays.asList("Poem 1", "Poem 2", "Poem 3");
        Observable coldMusicCoffeCafe = Observable.fromArray(poemsPlayList);

        Consumer client1 = poem-> System.out.println(poem);
        Consumer client2 = poem-> System.out.println(poem);
        Consumer client3 = poem-> System.out.println(poem);
        Consumer client4 = poem-> System.out.println(poem);

        coldMusicCoffeCafe.subscribe(client1);
        coldMusicCoffeCafe.subscribe(client2);
        System.out.println(System.currentTimeMillis());
        Thread.sleep(2000);
        System.out.println(System.currentTimeMillis());
        coldMusicCoffeCafe.subscribe(client3);
        coldMusicCoffeCafe.subscribe(client4);

    }
}
```

好吧，这是一些很简单的示例代码。我有4个顾客和1个我在霜语咖啡馆例子里提到的播放列表。当头两个顾客戴上了耳机后，我暂停了2秒的程序，然后3号和4号顾客也戴上了耳机。在最后我们查看输出数据时，我们能轻易地看出每个顾客都把3首诗从头听了一遍。

Output:
[Poem 1, Poem 2, Poem 3]
[Poem 1, Poem 2, Poem 3]
1494142518697
1494142520701
[Poem 1, Poem 2, Poem 3]
[Poem 1, Poem 2, Poem 3]

**Hot Observable:**

```
public static void main(String[] args) throws InterruptedException {

    Observable<Long> hotMusicCoffeeCafe = Observable.interval(1000, TimeUnit.MILLISECONDS);
    ConnectableObservable<Long> connectableObservable = hotMusicCoffeeCafe.publish();
    connectableObservable.connect(); //  Cafe open on this line and cafe boy start the system

    Consumer client1 = poem-> System.out.println("Client 1 poem"+poem);
    Consumer client2 = poem-> System.out.println("Client 2 poem"+poem);
    Consumer client3 = poem-> System.out.println("Client 3 poem"+poem);
    Consumer client4 = poem-> System.out.println("Client 4 poem"+poem);

    Thread.sleep(2000); // After two poems already played client 1 enter. So he should listens from poem 2.
    connectableObservable.subscribe(client1);
    Thread.sleep(1000); // Client two should start listening poem 3 
    connectableObservable.subscribe(client2);

    Thread.sleep(4000); // Client 3 and 4 enter will start from poem 7.（译者注：本来是写的 poem 9, 不知道为啥会是9）
    connectableObservable.subscribe(client3);
    connectableObservable.subscribe(client4);

    while (true);
}
```

火舞咖啡馆开始营业的时候就会开启其音乐播放系统。诗歌会在以上代码里我们调用 connect 方法的时候开始播放。暂时先不需要关注 connect 方法，而只是试着理解这个概念。当经过2秒暂停，第一个顾客走进了咖啡馆后，他会从第二首诗开始听。下一个顾客会在1秒暂停后进来，并且从第三首诗开始听。之后，第三和第四位顾客会在4秒后进入，并且从第七首诗开始听。你可以看到这个音乐播放系统是独立于顾客的。一旦这个音乐系统开始运行，它并不在乎有没人顾客在听。也就是说，所有的顾客会在他们进入时听到当前正在播放的诗，而且他们绝不会听到之前已经播放过的诗。现在我觉得你已经抓住了 Hot vs Cold Observable　的概念。是时候来瞧一瞧如何创建这些不同 observables 的要点了。

Cold Observable:
1. 所有的 Observable 默认都是 Cold Obserable。这就是说我们使用诸如 Observable.create() 或者 Observable.frinArray() 这类的方法所创建出来的 Observable 都是 Cold Observable。
2. 任何订阅 Cold Observable 的订阅者都会接收到独立的数据流。
3. 如果没有订阅者订阅，它就什么事情也不会做。是被动的。

Hot Observable:
1. 一旦 Hot Observable 被创建了，不管有没有订阅者，它们都会开始发送数据。
2. 相同时间开始订阅的订阅者会得到同样的数据。

Me: 听上去不错。你能告诉我如何将我们的 Cold Observable 转换成 Hot Observable吗。

Observable: 当然，Cold 和 Hot Observable之间的转换很简单。

```
List<Integer> integers = new ArrayList<>();
Observable.range(0, 10000)
        .subscribe(count -> integers.add(count));

Observable<List<Integer>> listObservable = Observable.fromArray(integers);
```

上面就是转换的代码啦。listObservable 是一个 Cold Observable。现在来看看我们怎么把这个 Cold Observable 转换成 Hot Observable 的。

```
Observable<List<Integer>> listObservable = Observable.fromArray(integers);
ConnectableObservable connectableObservable = listObservable.publish();
```

我们用 publish() 方法将我们的 Cold Observable 转换成了 Hot Observable。于是我们可以说任何的 Cold Observable都可以用调用 publish() 方法来转换成 Hot Observable，这个方法会返回给你一个 ConnectableObservable，只是此时还没有开始发射数据。有点神奇啊。当我对任意 observabale 调用 publish() 方法时，这意味着从现在开始任何开始订阅的订阅者都会分享同样的数据流。有趣的一点是，如果现在有任意的订阅者订阅了 **connectableObservable**，它们什么也得不到。也许你们感到有些疑惑了。这里有两件事需要说明。当我调用 publish() 方法时，只是说明现在这个 Observable 做好了能成为单一数据源来发射数据的准备，为了真正地发射数据，我需要调用 **connect()** 方法，如下方代码所示。

```
Observable<List<Integer>> listObservable = Observable.fromArray(integers);
ConnectableObservable connectableObservable = listObservable.publish();
connectableObservable.connect();
```

很简单对吧。记住调用 publish() 只是会把 Cold Observable 转换成 Hot Observable，而不会开始发射数据。为了能够发射数据我们需要调用 cocnnect()。当我对一个 ConnectableObserbale 调用 connect() 时，数据才会开始被发射，不管有没有订阅者。这里还有一些在正式项目里会非常有用的方法，比如 refCount()、share()、replay()。在开始谈及它们之前，我会就此打住并再给你展示一个例子，以确保你们真正抓住了要领。

Me: 好嘞，希望不要太复杂。

Observable: 哈哈哈，不会的。我只是需要再来详细解释一下，确保每个人都把握了这个概念，因为这个概念其实并不算是特别简单的和容易理解的。

Me: 我也觉得。Agree.

Observable：现在我会给你一个例子来让你更好地来准确把握这个概念。比如我们有如下的一个 Observable。

```
Observable<String> just = Observable.just("Hello guys");
```

还有两个不同的订阅者订阅了它。

```
public class HotVsCold {
    public static void main(String[] args) {
        Observable<String> just = Observable.just("Hello guys");
        just.subscribe(s-> System.out.println(s));
        just.subscribe(s-> System.out.println(s));
    }
}
```

Output:
Hello guys
Hello guys

我的问题是，这个 Observable 是　cold 还是 hot 的呢。我知道你肯定已经知道这个是 cold，因为这里没有 publish() 的调用。先暂时把这个想象成我从某个第三方库获得而来的，于是我也不知道这是哪种类型的 Observable。现在我打算写一个例子，这样很多事情就不言而喻了。

```
public static void main(String[] args) {
    Random random = new Random();
    Observable<Integer> just = Observable.create(source->source.onNext(random.nextInt()));
    just.subscribe(s-> System.out.println(s));
    just.subscribe(s-> System.out.println(s));
}
```

我有一段生产随机数的程序，让我们来看下输出再来讨论这是 Cold 还是 Hot。

Output:
1531768121
607951518

两个不同的值。这就是说这是一个 cold observable，因为根据 Cold Observable 的定义每次都会得到一个全新的值。每次它都会创建一个全新的值，或者简单来说 onNext() 方法会被不同的订阅者分别调用一次。

现在让我们来把这个 Cold Observable 转换成 Hot的。

```
public static void main(String[] args) {
    Random random = new Random();
    Observable<Integer> just = Observable.create(source->source.onNext(random.nextInt()));
    ConnectableObservable<Integer> publish = just.publish();
    publish.subscribe(s-> System.out.println(s));
    publish.subscribe(s-> System.out.println(s));
    publish.connect();
}
```

在解释上面的代码之前，先让我们来看一下输出。
Output:
1926621976
1926621976

我们的两个不同订阅者得到了同一份数据。根据 hot observable 总是发射一份数据只发射一次的定义说明了这是一个 Hot Obsevable，或者简单来说 onNext() 只被调用了一次。我接下来会解释　publish() 和 connect() 的调用。
当我调用 publish()　方法时，这意味着我的这个 observable 已经独立于订阅者，并且所有订阅者只会接收到同一个数据源发射地同一份数据。简单来说，Hot Observable 将会对所有订阅者发射调用一次 onNext() 所产生的数据。As I call a publish() method, its mean now my this observable is independent of subscribers and that only share the same source of data emission with all subscribers. In simple words, this Hot Observable will push the same onNext() method call data to all subscribers. Here may be one thing is little bit confused, I called a connect() method after the subscription of two subscribers. Because I want to show you guys Hot Observable is independent and data emission should be done by one call of onNext() and we know Hot Observable only start data emitting when we call connect() method. So fist we subscribed two subscribers and then we called a connect() method, in that way both will get same data. Now I am going to give you one more taste of same example.

```
Random random = new Random();
Observable<Integer> just = Observable.create(source->source.onNext(random.nextInt()));
ConnectableObservable<Integer> publish = just.publish();
publish.connect();
publish.subscribe(s-> System.out.println(s));
publish.subscribe(s-> System.out.println(s));
```

Here is only one difference. I called a connect() method before any subscriber subscription. Now what will be the output? Any body can assume what will be the output.
Output:

Process finished with exit code 0

Yes empty. Are you guys confused? oh ok I am going to explain. If you saw, I created an Observable from Random Int value, which only called once. As I created I converted that Cold Observable into Hot Observable by calling publish() method. After conversion I called a **connect()** method. Now because this is a Hot Observable and we know that is independent of Subscriber so that start emitting random number and we know that only generate a one random number. After connect() our subscribers, subscribed but at that time we are not getting any data because Hot Observable already emitted that one value. I think things are clearing to everyone. Now we can add log inside observable emission. So we can confirm, what I am saying that is true.

```
public static void main(String[] args) {
    Random random = new Random();
    Observable<Integer> just = Observable.create(source -> {
                int value = random.nextInt();
                System.out.println("Emitted data: " + value);
                source.onNext(value);
            }
    );
    ConnectableObservable<Integer> publish = just.publish();
    publish.connect();
    publish.subscribe(s -> System.out.println(s));
    publish.subscribe(s -> System.out.println(s));
}
```

Output:

Emitted data: -690044789

Process finished with exit code 0

Now my HotObservable start data emission after calling connect() as you can see in above output but subscribers subscribed late. That is why we are getting empty. Now I am going to revise before going to next step.
1. All observables are implicitly Cold Observables.
2. To convert a Cold Observable to Hot we need to call a publish() method which will return us a ConnectableObservable. Which is a Hot Observable but without start emitting data.
3. On ConnectableObservable we need to call a connect() method to start data emission.

Observable: Sorry for a interruption but [Me] before going to next level can you write a code for above Hot Observable with time interval that will be more good.

Me: Sure.

```
public static void main(String[] args) throws InterruptedException {
    Random random = new Random();
    Observable<Integer> just = Observable.create(
            source -> {
                Observable.interval(1000, TimeUnit.MILLISECONDS)
                        .subscribe(aLong -> {
                            int value = random.nextInt();
                            System.out.println("Emitted data: " + value);
                            source.onNext(value);
                        });
            }
    ); // Simple same Observable which we are using only I added a one thing now this will produce data after every one second.
    ConnectableObservable<Integer> publish = just.publish();
    publish.connect();

    Thread.sleep(2000); // Hot observable start emitting data and our new subscribers will subscribe after 2 second.
    publish.subscribe(s -> System.out.println(s));
    publish.subscribe(s -> System.out.println(s));

    while (true);

}
```

Output:

Emitted data: -918083931
Emitted data: 697720136
Emitted data: 416474929
416474929
416474929
Emitted data: -930074666
-930074666
-930074666
Emitted data: 1694552310
1694552310
1694552310
Emitted data: -61106201
-61106201
-61106201

Now we can easily saw in above output. Our Hot Observable working 100% according to definition which we already discuss in start of a post. As Hot Observable start data emission we got three values but there is no subscriber, after 2 seconds we subscribed 2 new subscribers to Hot Observable and they start getting new data values and both are getting same values.
Its time to take our this concept to next level. As we already grab the concept of Cold and Hot Observables. For next level of Hot Observables I am going to explain in the form of scenarios.

Scenario 1:
I want a Hot Observable with which any subscriber subscribed and get all previous values, which already emitted by this Hot Observable plus new values and all values should be synced. So to tackle that scenario we have a one very simple method. That is called replay(). Only we need to call that method.

```
public static void main(String[] args) throws InterruptedException {

    Random random = new Random();
    Observable<Integer> just = Observable.create(
            source -> {
                Observable.interval(500, TimeUnit.MILLISECONDS)
                        .subscribe(aLong -> {
                            int value = random.nextInt();
                            System.out.println("Emitted data: " + value);
                            source.onNext(value);
                        });
            }
    );
    ConnectableObservable<Integer> publish = just.replay();
    publish.connect();

    Thread.sleep(2000);
    publish.subscribe(s -> System.out.println("Subscriber 1: "+s));
    publish.subscribe(s -> System.out.println("Subscriber 2: "+s));

    while (true);

}
```

Output:
**Emitted data: -1320694608**
**Emitted data: -1198449126**
**Emitted data: -1728414877**
**Emitted data: -498499026**
Subscriber 1: -1320694608
Subscriber 1: -1198449126
Subscriber 1: -1728414877
Subscriber 1: -498499026
Subscriber 2: -1320694608
Subscriber 2: -1198449126
Subscriber 2: -1728414877
Subscriber 2: -498499026
**Emitted data: -1096683631**
**Subscriber 1: -1096683631**
**Subscriber 2: -1096683631**
**Emitted data: -268791291**
**Subscriber 1: -268791291**
**Subscriber 2: -268791291**

Here if you review our output and code together. You can get easily the concept of replay() in Hot Observable. First I created a Hot Observable which start emission of data after creation. Then after 2 seconds our first and second subscriber subscribe to that Hot observable but at that time Hot Observable already emitted four values. So you can see in output our subscribers first get the already emitted values and later they are sync with the Hot Observable data emission.

Second scenario:
I want a Hot Observable which only start data emission when first subscriber subscribed to that Hot observable and should stop when all subscriber unsubscribed to that Hot Observable.
Again this one is really simple to achieve.

```
public static void main(String[] args) throws InterruptedException {

    Observable<Long> observable = Observable.interval(500, TimeUnit.MILLISECONDS).publish().refCount();

    Consumer<Long > firstSubscriber = s -> System.out.println("Subscriber 1: "+s);
    Consumer<Long > secondSubscriber = s -> System.out.println("Subscriber 2: "+s);

    Disposable subscribe1 = observable.subscribe(firstSubscriber);
    Disposable subscribe2 = observable.subscribe(secondSubscriber);

    Thread.sleep(2000);
    subscribe1.dispose();
    Thread.sleep(2000);
    subscribe2.dispose();

    Consumer<Long > thirdSubscriber = s -> System.out.println("Subscriber 3: "+s);
    Disposable subscribe3 = observable.subscribe(thirdSubscriber);

    Thread.sleep(2000);
    subscribe3.dispose();

    while (true);
}
```

Output:
Subscriber 1: 0
Subscriber 2: 0
Subscriber 1: 1
Subscriber 2: 1
Subscriber 1: 2
Subscriber 2: 2
Subscriber 1: 3
Subscriber 2: 3
Subscriber 2: 4
Subscriber 2: 5
Subscriber 2: 6
Subscriber 2: 7
Subscriber 3: 0
Subscriber 3: 1
Subscriber 3: 2

First and most important point. Here this Observable is a Hot Observable but that only start data emission when first subscriber subscribe to that observable and will stop data emission as all subscribers unsubscribed to that Hot Observable.
As you saw in above output. When first two subscribers subscribed to Hot Observable data emission stared, later one subscriber unsubscribed but Hot Observable not stoped because there is one more subscriber currently subscribed but later that also unsubscribed so Hot Observable stoped data emission. After 2 seconds third subscriber subscribe to same Hot Observable but this time Hot Observable started data emission again but from zero not the point where that leaves.

Observable: WOW. You mazed me [Me]. You explained a concept in a good way.

Me: Thanks Observable.

Observable: So now you have any other question?

Me: Yes can you tell me about the concept of a Subject and different type’s of subjects like Publish, Behaviour etc.

Observable: Hmmm. I have a feeling before going to that concept. I should tell you about Observer API’s and how they work and how you can use Lambda or Functional interfaces without using a Complete Observer interface. What you think?

Me: Yes sure. I am with you.

Observable: So as we know about Observables. There is a one more concept Observer which we already using a lot in our examples…….

Conclusion:
Hello Friends. This dialogue is very very long but I need to stop some where. Otherwise this post will be like a giant book which may be ok but the main purpose will be die and that is, I want we should learn and know everything practically. So I am going to pause my dialogue here, I will do resume in next part. Only try your best to play with all these methods and if possible try to take your real world projects and refactor these for practice. In the end I want to say thanks to Rx Observable who give me a lot of his/her time.
Happy Weekend Friends Bye. 🙂


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
