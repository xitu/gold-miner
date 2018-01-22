> * 原文地址：[Continuation (Summer vs Winter Observable) of Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part6](http://www.uwanttolearn.com/android/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md)
> * 译者：
> * 校对者：

# Continuation (Summer vs Winter Observable) of Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part6

WOW, we got one more day so its time to make this day awesome by learning something new 🙂.

Hello guys, hope you are doing good. This is our sixth post in series of RxJava2 Android [ [part1](https://juejin.im/entry/58ada9738fd9c5006704f5a1), [part2](https://juejin.im/entry/58d78547a22b9d006465ca57), [part3](https://juejin.im/entry/591298eea0bb9f0058b35c7f), [part4](https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md), [part5](https://juejin.im/post/590ab4f7128fe10058f35119), [part6,](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md) [part7](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md) and [part8](https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md) ]. In this part we are going to continue our dialogue with Rx. One more important thing basically Summer vs Winter Observable means Hot vs Cold 🙂 .

**Motivation:**
Motivation is same which I share with you in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/).

**Introduction:
**There is no intro for this post because that is a continuation of our last post but before going to start I think we will do revise about our last post. In last part we met with a Rx Observable. He gave us some suggestions about learning Rx, after that he shared with us the methods, which we can use to create Observables and in the end he is going to tell us about Hot and Cold Observable but we paused our dialogue there.

**Continuation:**

Observable: There is a lot. But I think I can explain here about two types of Observables. One is called Cold Observable and the second one is called Hot Observable. Some time developers used to Hot vs Cold Observables. :). These are really simple concepts. Instead I will tell you concept by taking some really childish example so you guys have a concept and then I will tell you how you can use this concept in code. Later I think [Me] will give you some real world example. What you think [Me]?

Me: Yes sure, I will try in front of you so you can check am I right or wrong.

Observable: haha ok sure. So now how many people know about the sale’s person, which are mostly available in markets, in front of shops who are trying to grab people by saying some slogans?

Me: I think so, not lot of people know about the culture that is mostly available in asian countries like Pakistan, India … Can you try to take some other example which will be more general. So all over the world people can grab easily this concept.

Observable: Yes sure no problem. How many people know about coffee cafe’s?

Me: I think every one.

Observable: Good. There are two cafe’s and there name is Cold Music coffee cafe and Hot Music coffee cafe. Any one who will go to Cold Music coffee cafe he can buy a coffee and after that he can go and sit any where in the cafe. In cafe there are smart headphones which are attached with every sitting place. They have a play list of three poems. Now the smartness of these headphones is, any one who will wear headphone. Headphone always start from poem 1 and if in between any one took off headphone and wear again that always start from poem 1. Also if any body took off headphone will stop poem playing.

Vice versa in Hot Music coffee cafe they have a complete music system. As you enter in that cafe you will start listening poems because they have a very good music system with very large speakers. They have also unlimited poems and as a first cafe boy open the cafe he/she starts the system. So there system is independent from there cafe clients, any body will enter in cafe he will start listening the poem from that point of time and he never know before he enter in the cafe how many poems already finished. Now this is the same concept in observables.

Just like Cold Music coffee cafe headphones, cold observables are always lazy. Like you will create a Observable by using Observable.fromArray() or any other method but they are just like a headphone. As you subscribe to that Observable you will start getting data same like any body wear a headphone and poem start playing. Now subscriber unsubscribed from Observable, so you will not get any new data just like a headphone took off stop playing poem.

Last and important point Cold Music coffee cafe have a lot of headphones but every headphone always start when anybody wear a headphone. If one person is reached to a second poem and some other person will wear a other headphone he will start listening from poem 1. Its mean every person will get a separate poem playlist. In a same way if we have three subscribers and they will subscribe to Cold Observable they will get a separate data stream, means observable will call there onNext method for these three subscribers separately as they will subscribe. In that way we can say Cold Observables are dependent upon there subscriber just like a headphone.

Now Hot observables are just like a Hot Coffee Cafe music system. Once cafe open, music system start playing poems with out taking care of any one. It always playing poems and any body come in side, he will start listening that poem from that point of time. That is same happen in Hot Observables, once they are created and they start emitting the data, any subscriber will subscribe to that Observable and start getting data from that specific point of time and he will never get the old values. Its mean Hot Observable are independent from subscribers and they don’t care of any previous data. Any time any subscriber will subscribe will start getting data from that point. I think I will use the same example in code and later [Me] will give you some real world example.

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

Now that is a really simple example in code. I have 4 clients and I have a playlist which I turn into coldMusicCoffeeCafe Observable. After that first two clients attached with the cold observable as program start and later I have a 2 second wait and then 3 and 4 client subscribe to the cold observable and in the end when we saw the output we can easily saw all subscribers or clients will get all poems from start to end.

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

    Thread.sleep(4000); // Client 3 and 4 enter will start from poem 9.
    connectableObservable.subscribe(client3);
    connectableObservable.subscribe(client4);

    while (true);
}
```

Hot Music Coffee cafe open and the cafe boy starts the system. Poems start playing as shown in above line where we call connect method. For the time being don’t focus on connect only try to grasp the concept. After two poems or seconds first customer enter in the cafe so he will start listening from poem 2\. Then next customer enter after 1 second so he start listening from poem 3\. Later customer 3,4 enter in a cafe after 4 seconds of a customer 2\. Now they start listening from poem 9\. You can see this Hot Observable is independent from subscriber. Once he start emitting data he don’t care any body is subscribe or not. On the other hand all subscriber will get data from the time when they subscribe they never get the history or events which are already emitted.
Now I have a feeling you grasp the concept of Hot vs Cold Observable. Now Its time to see how to create these observables in the form of points.

Cold Observable:
1. All Observables implicitly are Cold Observables. Its mean if we use Observable.create() or Observable.fromArray() or any other method to create Observable that is Cold Observable.
2. Any subscriber when subscribe to Cold Observable that always get independent data stream from start to end.
3. If no subscriber subscribes with the Cold Observable they are doing nothing. They are lazy.

Hot Observable:
1. Hot Observable once created, they start emitting data without taking care of subscribers.
2. All subscribers will get the same data from the specific point when they will do subscribe to a Hot Observable.

Me: Hmmm good. Can you tell us how I can convert our Cold Observable into Hot Observable.

Observable: Yes. Conversion between Cold to Hot Observable is really simple.

```
List<Integer> integers = new ArrayList<>();
Observable.range(0, 10000)
        .subscribe(count -> integers.add(count));

Observable<List<Integer>> listObservable = Observable.fromArray(integers);
```

Now in above code block. listObservable is a Cold observable. Its time to see how we can convert this Cold observable into Hot observable.

```
Observable<List<Integer>> listObservable = Observable.fromArray(integers);
ConnectableObservable connectableObservable = listObservable.publish();
```

In above code we converted our Cold observable into Hot observable by using publish() method. So we can say any Cold observable will be converted into Hot by calling there publish() method and this publish method always give you ConnectableObservable but currently that is not emitting data. That is a little tricky thing. As I call publish() method on any observable. Its mean from now any subscriber will subscribe with this Observable will share a same data, from that point of time when he subscribe. As we know in Hot Coffee every body will get a same poem data stream only difference is when subscriber subscribe they get data from that specific point of time. Now interesting point is, if any number of subscribers subscribe with **connectableObservable** they will get nothing. May be you guys are confused. Basically there are two things. When I will call publish() its mean from now this Observable will emit a single data or this observable have a single data source for emitting data to all subscribers but to start data emitting I need to call **connect()** method like as shown below.

```
Observable<List<Integer>> listObservable = Observable.fromArray(integers);
ConnectableObservable connectableObservable = listObservable.publish();
connectableObservable.connect();
```

Now that is really simple. Remember publish() will convert Cold Observable to Hot but never start data emission. For data emission we need to call a connect() method. As I call a connect() method on ConnectableObservable data will start emitting without any subscriber or may be with thousand subscribers. Now there are also some other methods which are really useful in real life projects like refCount(), share(), replay() but currently I am stopping here and [Me] will give you one more good example which I will do a review. So you guys really grasp this concept.

Me: Oh man that is very long but easy.

Observable: haha that is nothing [Me]. Only I need to explain in a way so every body should grasp the concept otherwise that is a very easy and simple topic.

Me: Agree. So Now I am going to give a one example which may more helpful to grasp this concept more accurately.
Now consider we have one Observable as shown below.

```
Observable<String> just = Observable.just("Hello guys");
```

Now two different subscriber, subscriber to this Observable.

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

Now I have a question. Is this Observable is cold or hot. Yes I know you already know there is no publish() method so that is cold. For the time being image that observable I am getting from some third party library. So I don’t know what is the type of this Observable. Now I am going to take a new example due to that lot of things will clear to everyone.

```
public static void main(String[] args) {
    Random random = new Random();
    Observable<Integer> just = Observable.create(source->source.onNext(random.nextInt()));
    just.subscribe(s-> System.out.println(s));
    just.subscribe(s-> System.out.println(s));
}
```

Here I have a Random value so Its time to review program output and discuss is it Cold or Hot Observable?

Output:
1531768121
607951518

So both values are different. Its mean that is a cold observable because every time I am getting a new value according to definition of Cold Observable they never share the data. Every time they produce a new or fresh data or in simple words onNext() method call two times for two different subscribers.

Now its time to change this same Cold into Hot Observable.

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

Before going to explain the above code first we should review the output of this code.
Output:
1926621976
1926621976

Now this time I got a same data in both subscribers. Its mean that is a Hot Observable because hot observable always send a data from a single source or in simple words we got a data only from one time call of onNext() method. Next thing I am going to explain the call of publish() and connect() method.
As I call a publish() method, its mean now my this observable is independent of subscribers and that only share the same source of data emission with all subscribers. In simple words, this Hot Observable will push the same onNext() method call data to all subscribers. Here may be one thing is little bit confused, I called a connect() method after the subscription of two subscribers. Because I want to show you guys Hot Observable is independent and data emission should be done by one call of onNext() and we know Hot Observable only start data emitting when we call connect() method. So fist we subscribed two subscribers and then we called a connect() method, in that way both will get same data. Now I am going to give you one more taste of same example.

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
