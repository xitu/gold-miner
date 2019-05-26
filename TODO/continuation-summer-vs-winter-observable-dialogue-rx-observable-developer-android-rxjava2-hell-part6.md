> * 原文地址：[Continuation (Summer vs Winter Observable) of Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part6](http://www.uwanttolearn.com/android/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md)
> * 译者：[hanliuxin](https://github.com/hanliuxin5)
> * 校对者：[JayZhaoBoy](https://github.com/JayZhaoBoy)，[Lixiang](https://github.com/LeeSniper)

# 大话（Summer vs Winter Observable）之我与 Rx Observable[Android RxJava2]（这是什么鬼）第六话

哇哦，又是新的一天，是时候来学习一些新的「姿势」了 🙂。

嗨，朋友们，希望大家一切都好。这是我们 RxJava2 Android 系列的第六篇文章【【第一话】(https://juejin.im/entry/58ada9738fd9c5006704f5a1),【第二话】(https://juejin.im/entry/58d78547a22b9d006465ca57),【第三话】(https://juejin.im/entry/591298eea0bb9f0058b35c7f),【第四话】(https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md),【第五话】(https://juejin.im/post/590ab4f7128fe10058f35119),【第六话】(https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md)【第七话】(https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md) 和【第八话】(https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md) 】。在这一篇文章中，我们将继续围绕 Rx 展开对话。还有一件重要的事情是，基本上 Summer vs Winter 意味着 Hot 和 Cold Observale 🙂 。

**我为啥要写这个呢:**

原因和我在 [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/) 与你分享过的一样。

**引言:**

**这篇文章并没有引言，因为这其实是我们上一篇文章的延续，但在开始之前我想我们应该进行一下前景回顾。上一篇文章中我们遇到了一位 Rx Observable 先生。他给了我们不少关于学习 Rx 的建议，然后他还分享给了我们一些可以用来创造 Observable 的方法，最后他打算告诉我们一些关于 Could 和 Hot Observable 的东西，结果我们就此打住。

**紧接上一话:**

Observable：其实还有很多。我在这里介绍两类 Observable 对象。一种叫做 Cold Observable，第二个是 Hot Observable。有些时候开发者习惯把 Hot 和 Cold Observabels 拿来做比较 :)。 这些真的是很简单的概念。这里，我会通过一些简单的例子来阐述一下概念，然后我会告诉你如何在编码中使用它们。再之后我想我会给你一些真实案例，你觉得如何？

Me：当然，我就在你眼前，这样你可以随时检查我是否有做错的地方。

Observable: 哈哈哈哈，当然了。那么有多少人了解商场的促销人员，就是那些站在商店门口希望藉由大声吆喝来招揽顾客的人呢？

Me: 估计没几个，很多人都不太了解这种盛行于亚洲国家比如巴基斯坦和印度的销售文化……你能试着采用一些更加通俗的例子吗，这样的话每个人都能更加轻易的理解这个概念。

Observable: 当然，没问题。有多少人了解咖啡和咖啡店呢？

Me: 差不多每个人吧。

Observable: 很好。现在这里有两家咖啡店，一家叫做霜语咖啡店，一家叫做火舞咖啡店。任何一个去霜语咖啡馆的人都可以买一杯咖啡，然后坐在咖啡馆的任何地方。咖啡厅里的每个座位上都提供了一副智能耳机。他们提供了一个有三首诗的播放列表。这些耳机最智能的地方在于，每当有人带上它们，这些耳机总是从第一首诗开始播放，如果有人中途取下了耳机后再次重新戴上，那么这些耳机仍然会重新从第一首诗开始播放。对了，如果你只是取下了耳机，那么它也就会停止播放。

反过来，火舞咖啡馆有一套完善的音乐播放系统。当你进入咖啡馆的时候，你就会开始听到他们播放的诗，因为他们有着非常好的音乐播放系统和一个大号的扬声器。他们的诗歌列表里有无数首诗，当他们每天开始营业的时候他们就会打开这个系统。所以说这个系统的运行与顾客无关，任何将会进入这家咖啡馆的人都能听到那个时刻正在播放的诗，并且他永远也不知道他进入之前已经播放完了多少诗了。这跟我们要讲的 Observable 是一个概念。

就像霜语咖啡馆的那些耳机，Cold Obervable 总是被动的。就像你用 Observable.fromArray() 或者其他任何方法来创造 Observable 一样，他们和那些耳机差不多。如同戴上耳机播放列表才会播放一样，当你开始订阅那些 Observable 后你才会开始接收到数据。而当订阅者取消了对 Observable 的订阅后，如同取下耳机后诗会停止播放一样，你也将不再能接收到数据。

最后的重点是霜语咖啡馆提供了很多副耳机，但是每副耳机只会在有人戴上它们之后才会开始播放。即使某个人已经播放到了第二首诗，但另外的某个人才戴上耳机，那么第二个人会从第一首诗开始播放。这意味着每个人都有独立的播放列表。就如同我们有三个订阅了 Cold Observable 的订阅者一样，它们会得到各自独立的数据流，也就是说 Observable 会对每个订阅者单独地去调用三次 onNext 方法。换句话说就是，Cold Observable 如同那些耳机一样依赖于订阅者的订阅(顾客戴上耳机)。

Hot observable 就像火舞咖啡馆的音乐系统一样。一旦咖啡馆开始营业，其音乐系统就会开始播放诗歌，不管有没有人在听。每位进来的顾客都会从那个时刻正好在播放的诗开始聆听。这跟 Hot Observable 所做的事情一样，一旦它们被创建出来就会开始发射数据，任何的订阅者都会从它们开始订阅的那个时间点开始接收到数据，并且绝不会接收到之前就发射出去的数据。任何订阅者都会在订阅之后才接收到数据。我想我会使用同样的例子来进行编码，并且之后我会给一些真实案例。

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

好吧，这是一些很简单的示例代码。我有 4 个顾客和 1 个我在霜语咖啡馆例子里提到的播放列表。当前两个顾客戴上了耳机后，我暂停了 2 秒的程序，然后 3 号和 4 号顾客也戴上了耳机。在最后我们查看输出数据时，我们能轻易地看出每个顾客都把 3 首诗从头听了一遍。

```
Output:
[Poem 1, Poem 2, Poem 3]
[Poem 1, Poem 2, Poem 3]
1494142518697
1494142520701
[Poem 1, Poem 2, Poem 3]
[Poem 1, Poem 2, Poem 3]
```

**Hot Observable:**

```
public static void main(String[] args) throws InterruptedException {

    Observable<Long> hotMusicCoffeeCafe = Observable.interval(1000, TimeUnit.MILLISECONDS);
    ConnectableObservable<Long> connectableObservable = hotMusicCoffeeCafe.publish();
    connectableObservable.connect(); //  咖啡馆开始营业，音乐播放系统开启

    Consumer client1 = poem-> System.out.println("Client 1 poem"+poem);
    Consumer client2 = poem-> System.out.println("Client 2 poem"+poem);
    Consumer client3 = poem-> System.out.println("Client 3 poem"+poem);
    Consumer client4 = poem-> System.out.println("Client 4 poem"+poem);

    Thread.sleep(2000); // 在２首诗已经播放完毕后第一位顾客才进来，所以他会才第二首诗开始听
    connectableObservable.subscribe(client1);
    Thread.sleep(1000); // 第二位顾客会从第三首诗开始听
    connectableObservable.subscribe(client2);

    Thread.sleep(4000); // 第三和第四为顾客为从第七首诗开始听（译者注：本来是写的 poem 9）
    connectableObservable.subscribe(client3);
    connectableObservable.subscribe(client4);

    while (true);
}
```

火舞咖啡馆开始营业的时候就会开启其音乐播放系统。诗歌会在以上代码里我们调用 connect 方法的时候开始播放。暂时先不需要关注 connect 方法，而只是试着理解这个概念。当经过 2 秒暂停，第一个顾客走进了咖啡馆后，他会从第二首诗开始听。下一位顾客会在 1 秒之后进来，并且从第三首诗开始听。之后，第三和第四位顾客会在 4 秒后进入，并且从第七首诗开始听。你可以看到这个音乐播放系统是独立于顾客的。一旦这个音乐系统开始运行，它并不在乎有没人顾客在听。也就是说，所有的顾客会在他们进入时听到当前正在播放的诗，而且他们绝不会听到之前已经播放过的诗。现在我觉得你已经抓住了 Hot vs Cold Observable 的概念。是时候来瞧一瞧如何创建这些不同 Observables 的要点了。

Cold Observable:
1. 所有的 Observable 默认都是 Cold Obserable。这就是说我们使用诸如 Observable.create() 或者 Observable.fromArray() 这类的方法所创建出来的 Observable 都是 Cold Observable。
2. 任何订阅 Cold Observable 的订阅者都会接收到独立的数据流。
3. 如果没有订阅者订阅，它就什么事情也不会做。是被动的。

Hot Observable:
1. 一旦 Hot Observable 被创建了，不管有没有订阅者，它们都会开始发送数据。
2. 相同时间开始订阅的订阅者会得到同样的数据。

Me: 听上去不错。你能告诉我如何将我们的 Cold Observable 转换成 Hot Observable 吗？

Observable: 当然，Cold 和 Hot Observable 之间的转换很简单。

```
List<Integer> integers = new ArrayList<>();
Observable.range(0, 10000)
        .subscribe(count -> integers.add(count));

Observable<List<Integer>> listObservable = Observable.fromArray(integers);
```

在上面的代码里面，listObservable 是一个 Cold Observable。现在来看看我们怎么把这个 Cold Observable 转换成 Hot Observable 的。

```
Observable<List<Integer>> listObservable = Observable.fromArray(integers);
ConnectableObservable connectableObservable = listObservable.publish();
```

我们用 publish() 方法将我们的 Cold Observable 转换成了 Hot Observable。于是我们可以说任何的 Cold Observable 都可以通过调用 publish() 方法来转换成 Hot Observable，这个方法会返回给你一个 ConnectableObservable，只是此时还没有开始发射数据。有点神奇啊。当我对任意 Observable 调用 publish() 方法时，这意味着从现在开始任何开始订阅的订阅者都会分享同样的数据流。有趣的一点是，如果现在有任意的订阅者订阅了 **connectableObservable**，它们什么也得不到。也许你们感到有些疑惑了。这里有两件事需要说明。当我调用 publish() 方法时，只是说明现在这个 Observable 做好了能成为单一数据源来发射数据的准备，为了真正地发射数据，我需要调用 **connect()** 方法，如下方代码所示。

```
Observable<List<Integer>> listObservable = Observable.fromArray(integers);
ConnectableObservable connectableObservable = listObservable.publish();
connectableObservable.connect();
```

很简单对吧。记住调用 publish() 只是会把 Cold Observable 转换成 Hot Observable，而不会开始发射数据。为了能够发射数据我们需要调用 cocnnect()。当我对一个 ConnectableObserbale 调用 connect() 时，数据才会开始被发射，不管有没有订阅者。这里还有一些在正式项目里会非常有用的方法，比如 refCount()、share()、replay()。在开始谈及它们之前，我会就此打住并再给你展示一个例子，以确保你们真正抓住了要领。

Me: 好嘞，希望不要太复杂。

Observable: 哈哈哈，不会的。我只是需要再来详细解释一下，确保每个人都把握了这个概念，因为这个概念其实并不算是特别简单的和容易理解的。

Me: 我也觉得。

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

```
Output:
Hello guys
Hello guys
```

我的问题是，这个 Observable 是 Cold 还是 Hot 的呢。我知道你肯定已经知道这个是 cold，因为这里没有 publish() 的调用。先暂时把这个想象成我从某个第三方库获得而来的，于是我也不知道这是哪种类型的 Observable。现在我打算写一个例子，这样很多事情就不言而喻了。

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

两个不同的值。这就是说这是一个 Cold observable，因为根据 Cold Observable 的定义每次都会得到一个全新的值。每次它都会创建一个全新的值，或者简单来说 onNext() 方法会被不同的订阅者分别调用一次。

现在让我们来把这个 Cold Observable 转换成 Hot Observable。

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
```
Output:
1926621976
1926621976
```

我们的两个不同订阅者得到了同一份数据。根据 Hot Observable 总是每份数据只发射一次的定义说明了这是一个 Hot Obsevable，或者简单来说 onNext() 只被调用了一次。我接下来会解释 publish() 和 connect() 的调用。

当我调用 publish() 方法时，这意味着我的这个 Observable 已经独立于订阅者，并且所有订阅者只会接收到同一个数据源发射的同一份数据。简单来说，Hot Observable 将会对所有订阅者发射调用一次 onNext() 所产生的数据。这里或许有些让你感到困惑，我在两个订阅者订阅之后才调用了 connect() 方法。因为我想告诉你们 Hot Observable 是独立的并且数据的发射应该通过一次对 onNext() 的调用，并且我们知道 Hot Observable 只会在我们调用 connect() 之后才会开始发射数据。所以首先我们让两个订阅者去订阅，然后在我们才调用 connect() 方法，于是我们就可以得到同样一份数据。现在让我们来对这个例子做些小小的改动。

```
Random random = new Random();
Observable<Integer> just = Observable.create(source->source.onNext(random.nextInt()));
ConnectableObservable<Integer> publish = just.publish();
publish.connect();
publish.subscribe(s-> System.out.println(s));
publish.subscribe(s-> System.out.println(s));
```

我们看到这里只有一处小小的变化。我在调用 connect() 之后才让订阅者订阅。大家来猜猜会输出什么？
```
Output:
Process finished with exit code 0
```

没错，没有输出。是不是觉得有点不对劲？听我慢慢解释。如你所见，我创建了一个发射随机数的 Observable，并且它只会调用一次了。通过调用 publish() 我将这个 Cold Observable 转换成了 Hot Observable，接着我立即调用了 **connect()** 方法。我们知道现在它是一个独立于订阅者的 Hot Observable，并且它生成了一个随机数将其发射了出去。在调用 connect() 之后我们才让两个订阅者订阅了这个 Observable，两个订阅者没有接收到任何数据的原因是在它们订阅之前 Hot Observable 就已经将数据发射了出去。我想大家都能明白的吧。现在让我们在 Observable 内部加上日志打印输出，这样我们就可以确认这个流程是如同我所解释的一样了。

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

```
Output:

Emitted data: -690044789

Process finished with exit code 0
```

如上所示，我的 Hot Observable 在调用 connect() 之后开始发射数据，然后才是订阅者发起了订阅。这就是为什么我的订阅者没有得到数据。让我们在继续深入之前来复习一下。
1. 所有的 Observable 默认都是 Cold Obserable。
2. 通过调用 Publish() 方法我们可以将一个 Cold Observable 转换成 Hot Observable，该方法返回了一个 ConnectableObservable，它现在并不会立即开始发射数据。
3. 在对 ConnectableObservable 调用 connect() 方法后它才开始发射数据。

Observable: 小小的暂停一下，在我们继续研究 Observable 之前，你如果能将以上的代码改造成能无限制间隔发射数据的话就太棒了。

Me: 小菜一碟。

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
    ); // 简单的把数据源变成了每间隔一秒就发射一次数据。
    ConnectableObservable<Integer> publish = just.publish();
    publish.connect();

    Thread.sleep(2000); // 我们的订阅者在 2 秒后才开始订阅。
    publish.subscribe(s -> System.out.println(s));
    publish.subscribe(s -> System.out.println(s));

    while (true);

}
```

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
```

输出结果如上所示。我们的 Hot Observable 完全在按照我们之前得出的定义在工作。当它开始发射数据的 ２ 秒时间后，我们得到了 ２ 个不同的输出值，接着我们让两个订阅者去订阅它，于是它们得到了同一份第三个被发射出来的值。
是时候来更加深入的来理解这个概念了。在我们已经对 Cold 和 Hot 有一定概念的基础上，我将针对一些场景对 Hot Observable 做更详细的介绍。

场景 1:
我希望任意订阅者在订阅之后也能首先接收到其订阅这个时间点之前的数据，然后才是同步接收到新发射出来的数据。要解决这个问题，我们只需要简单的调用 replay() 方法就行。

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
```

以上所示，你能轻松的理解 Hot Observabel 里的 replay() 这个方法。我首先创建了一个每隔 0.5 秒发射数据的 Hot Observable，在 ２ 秒过后我们才让两个订阅者去订阅它。此时由于我们的 Observable 已经发射出来了 4 个数据，于是你能看到输出结果里，我们的订阅者首先得到了在其订阅这个时间点之前已经被发射出去的 4 个数据，然后才开始同步接收到新发射出来的数据。

场景 2:
我希望有一种 Hot Observable 能够在最少有一个订阅者的情况下才发射数据，并且如果所有它的订阅者都取消了订阅，它就会停止发射数据。
这同样能够很轻松的办到。

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
Subscriber 3: 3 (译者注：原文少写了一行输出)

至关重要的一点是，这是一个 Hot Observable，并且它在第一个订阅者订阅之后才开始发射数据，然后当它没有订阅者时它会停止发射数据。
如上面的输出所示，当头两个订阅者开始订阅它之后，它才开始发射数据，然后其中一个订阅者取消了订阅，但是它并没有停止发射数据，因为此时它还拥有另外一个订阅者。又过了一会，另外一个订阅者也取消了订阅后，它便停止了发射数据。当 2 秒过后第三个订阅者开始订阅它之后，它开始从头开始发射数据，而不是从第二个订阅者取消订阅时停留在的位置。

Observable: 哇哦，你真棒！你把这个概念解释地超好。

Me: 多谢夸奖。

Observable: 那么你还有其他的问题吗？

Me: 是的，我有。你能告诉我什么是 Subject 以及不同类别的 Subject 的区别吗，比如 Publish，Behaviour 之类的。

Observable: Emmmmmm。我觉我应该在教你那些个概念之前告诉你关于 Observer API 的相关知识，还有就是关于如何使用 Lambda 表达式或者叫函数式接口来代替使用完整的 Observer 接口的方法。你觉得呢？

Me: 好啊，都听你的。

Observable: 就目前我们了解到的 Observable，这里还有一个关于我们一直在使用的 Observable 的概念...

小结:
你们好啊，朋友们。这次的对话真是有点长啊，我必须在此打住了。否则的话这篇文章就会变成一本四库全书，什么乱七八糟的东西都会出现。我希望我们能够系统地有条理地来学习这一切。所以余下的内容，我们下回再揭晓。再者，试试看尽你可能把我们这次学到的东西用在你真正的项目中。最后感谢 Rx Observable 的到场。
周末快乐，再见。🙂


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
