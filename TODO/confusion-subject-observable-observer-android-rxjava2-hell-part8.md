> * 原文地址：[Confusion between Subject and Observable + Observer [ Android RxJava2 ] ( What the hell is this ) Part8](http://www.uwanttolearn.com/android/confusion-subject-observable-observer-android-rxjava2-hell-part8/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md](https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md)
> * 译者：
> * 校对者：

# Confusion between Subject and Observable + Observer [ Android RxJava2 ] ( What the hell is this ) Part8

WOW, we got one more day so its time to make this day awesome by learning something new 🙂.

Hello guys, hope you are doing good. This is our eight post in series of RxJava2 Android [ [part1](https://juejin.im/entry/58ada9738fd9c5006704f5a1), [part2](https://juejin.im/entry/58d78547a22b9d006465ca57), [part3](https://juejin.im/entry/591298eea0bb9f0058b35c7f), [part4](https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md), [part5](https://juejin.im/post/590ab4f7128fe10058f35119), [part6,](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md) [part7](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md) and [part8](https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md) ]. In this part we are going to discuss Subjects in Rx.

**Motivation:**
Motivation is same which I share with you in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/).

**Introduction:**When I started my journey with Rx. Subject is the most confusing part for me. Most of the time when I start reading any blog I always got one definition “Subject is just like a Observable and Observer both at a same time”. Which always confused me because I am not a clever guy. So after doing a lot of practice sessions with Rx. One day I got the concept of Subjects and I am amazed that is really powerful. So in this post I am going to discuss with you about this concept and how much powerful is this. May be on some places I will used this concept not in a proper way but that will give you the concept. In the end of this post you will be the best friend of Subjects. 🙂

First, if you guys have the same issue related to Subjects just like me (that is Observer + Observable )then please try to forgot that concept. Now I am going to revise little bit about Observable and Observer.
For Observable I will recommend you to revise [Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part5](http://www.uwanttolearn.com/android/dialogue-rx-observable-developer-android-rxjava2-hell-part5/) and for Observer I will recommend you to revise [Continuation (Observable Marriage Proposal to Observer) of Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part7](http://www.uwanttolearn.com/android/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7/) . Then you can easily understand my this post. Now I am going to share with you Observable and Observer API’s below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-8.55.46-AM-1024x329.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-8.55.46-AM.png)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-8.56.00-AM-1024x281.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-8.56.00-AM.png)

This is Observable code. Total lines are around 3000 as shown above. As we know Observable always used to change our data into streams by using its different API’s. Below I am giving a simple example.

```
public static void main(String[] args) {
    List<String> list = Arrays.asList("Hafiz", "Waleed", "Hussain");
    Observable<String> stringObservable = Observable.fromIterable(list);
}
```

Next we need the Observer to get benefit from the Observable. Now I am going to show you first Observer API’s below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-9.04.40-AM-1024x421.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-9.04.40-AM.png)

As we can see Observer is really simple. Only 4 methods. Now it’s time to use this Observer into our example.

```
/**
 * Created by waleed on 09/07/2017.
 */
public class Subjects {

    public static void main(String[] args) {
        List<String> list = Arrays.asList("Hafiz", "Waleed", "Hussain");
        Observable<String> stringObservable = Observable.fromIterable(list);

        Observer<String> stringObserver = new Observer<String>() {
            @Override
            public void onSubscribe(Disposable disposable) {
                System.out.println("onSubscribe");
            }

            @Override
            public void onNext(String s) {
                System.out.println(s);
            }

            @Override
            public void onError(Throwable throwable) {
                System.out.println(throwable.getMessage());
            }

            @Override
            public void onComplete() {
                System.out.println("onComplete");
            }
        };

        stringObservable.subscribe(stringObserver);
    }
}
```

Its output is simple. Now we successfully revised the Observable and Observer API’s. Observable basically call our Observer API’s when we do subscription.
Any time when Observable want to gave a data. That always called Observer onNext(data) method.
Any time when error occur Observable called onError(e) of Observer method.
Any time when stream is complete Observable called onComplete() of Observer.
That is a simple relationship between these two API’s.

Now I am going to start our today’s topic. If you guys again have any confusion related to Observable and Observer. Please try to read above mentioned part of my posts or may be ask a question in comments.
I think definition of Rx Subject we will discuss in the end. Now I am going to explain you one more simple example which will make our concept more strong to grasp the concept of Subjects in Rx.

```
Observable<String> stringObservable = Observable.create(observableEmitter -> {
    observableEmitter.onNext("Event");
});
```

This is Observable which will generate an Event String.

```
Consumer<String> consumer = new Consumer<String>() {
    @Override
    public void accept(String s) {
        System.out.println(s);
    }
};
```

This is a consumer which will subscribe with Observable.

```
while (true) {
    Thread.sleep(1000);
    stringObservable.subscribe(consumer);
}
```

This code will generate an event after every one second.
For ease of a reader I am copying all working code below.

```
public class Subjects {

    public static void main(String[] args) throws InterruptedException {

        Observable<String> stringObservable = Observable.create(observableEmitter -> {
            observableEmitter.onNext("Event");
        });

        Consumer<String> consumer = new Consumer<String>() {
            @Override
            public void accept(String s) {
                System.out.println(s);
            }
        };

        while (true) {
            Thread.sleep(1000);
            stringObservable.subscribe(consumer);
        }
    }
}
```

Output:
Event
Event
Event
Event

This is really simple example. I think there is no need to explain more. Now interesting part. I am going to make new example which will give us a same output but using a different technique.
Before going into deep. Try to read below code.

```
class ObservableObserver extends Observable<String> implements Observer<String>.
```

That is really simple. I am going to create a new class with name ObservableObserver. Which extend from Observable and implementing Observer. So its mean that will work as an Observable plus as an Observer. I don’t think there is any confusion. So as we already know Observable always generate streams. So this class also has this capability because that extending from Observable. Then we know Observer can observe any stream in Observable by subscribing to that Observable. Our new class also can do that work because that is implementing Observer. BOOM.
Very simple.
Now I am going to show you whole code. Which is only for concept I am not saying that is a MATURE code.

```
class ObservableObserver extends Observable<String> implements Observer<String> {

    private Observer<? super String> observer;

    @Override
    protected void subscribeActual(Observer<? super String> observer) { // Observable abstract method
        this.observer = observer;
    }

    @Override
    public void onSubscribe(Disposable disposable) { //Observer API
        if (observer != null) {
            observer.onSubscribe(disposable);
        }
    }

    @Override
    public void onNext(String s) {//Observer API
        if (observer != null) {
            observer.onNext(s);
        }
    }

    @Override
    public void onError(Throwable throwable) {//Observer API
        if (observer != null) {
            observer.onError(throwable);
        }
    }

    @Override
    public void onComplete() {//Observer API
        if (observer != null) {
            observer.onComplete();
        }
    }

    public Observable<String> getObservable() {
        return this;
    }
}
```

Again very simple class. We already worked with above all methods. Only here we have a one difference and that is, we are using both Observable and Observer related methods together in a same class.

```
public static void main(String[] args) throws InterruptedException {

    ObservableObserver observableObserver = new ObservableObserver();
    observableObserver.getObservable().subscribe(System.out::println);

    while (true) {
        Thread.sleep(1000);
        observableObserver.onNext("Event");
    }
}
```

Output:
Event
Event
Event

In above code there are two important lines. Which I am going to explain.
**observableObserver.getObservable():
**Here I am getting Observable from my ObservableObserver class and subscribing to observer.
**observableObserver.onNext(“Event”):
**Here I am using observer API call when event is generated.
As a whole I am taking benefit from this class as an Observable plus as an Observer. Now ready for a surprise. You guys already grasp a concept of Subject. If you are amazed please saw below code snippet image

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-10.32.40-AM-1024x453.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-10.32.40-AM.png)

That is a RxJava2 Subject class code. Now may be you can say why people used to say Subject is an Observable plus Observer because that is using both API’s.
Now there are different type of Subjects are available in RxJava. Which we are going to discuss now.

In RxJava you will get 4 types of Subjects.
**1. Publish Subject**
**2. Behaviour Subject**
**3. Replay Subject**
**4. Async Subject**

```
    public static void main(String[] args) throws InterruptedException {

        Subject<String> subject = PublishSubject.create();
//        Subject<String> subject = BehaviorSubject.create();
//        Subject<String> subject = ReplaySubject.create();
//        Subject<String> subject = AsyncSubject.create(); I will explain in the end

        subject.subscribe(System.out::println);

        int eventCounter = 0;
        while (true) {
            Thread.sleep(100);
            subject.onNext("Event "+ (++eventCounter));
        }

    }
```

Output:
Event 1
Event 2
Event 3
Event 4
Event 5
Event 6
Event 7
Event 8
Event 9
Event 10

Basically if you run above code you will get same output for all above Subjects except AsyncSubject. Now it’s time to differentiate between these Subject types.
**1. Publish Subject:
**In this type of Subjects. We will get the real time data. Like one of my Publish Subject emitting data of some sensor. Now if I subscribe to that Subject I will get the latest values only just like as shown below.

```
public static void main(String[] args) throws InterruptedException {

    Subject<String> subject = PublishSubject.create();
    int eventCounter = 0;
    while (true) {
        Thread.sleep(100);
        subject.onNext("Event " + (++eventCounter));

        if (eventCounter == 10)
            subject.subscribe(System.out::println);
    }
}
```

Output:
Event 11
Event 12
Event 13
Event 14
Event 15
Event 16

So here basically publish subject start emitting data from 0 but I am subscribing at the time when that already emitted up to 10\. As you can see in output we are getting values from Event 11.

**2. Behaviour Subject:
**In this type of Subjects. We will get the last emitted value + new values which will be emitted by this Subject. For simplicity please check the below code.

```
public static void main(String[] args) throws InterruptedException {

    Subject<String> subject = BehaviorSubject.create();
    int eventCounter = 0;
    while (true) {
        Thread.sleep(100);
        subject.onNext("Event " + (++eventCounter));

        if (eventCounter == 10)
            subject.subscribe(System.out::println);
    }
}
```

Output:
Event 10
Event 11
Event 12
Event 13
Event 14
Event 15

As you can see in output. I am also getting ‘Event 10’ value. Which is basically already emitted by that Subject before I subscribe. Its mean if I want a last value or may be last change before subscribing. I can use this Subject.

**3. Replay Subject:
**In this type of Subjects. We will get all emitted values without taking tension of when I am subscribing. For simplicity please check below code.

```
public static void main(String[] args) throws InterruptedException {

    Subject<String> subject = ReplaySubject.create();
    int eventCounter = 0;
    while (true) {
        Thread.sleep(100);
        subject.onNext("Event " + (++eventCounter));

        if (eventCounter == 10)
            subject.subscribe(System.out::println);
    }
}
```

Output:
Event 1
Event 2
Event 3
Event 4
Event 5
Event 6
Event 7
Event 8
Event 9
Event 10
Event 11
Event 12

Now again I am subscribing on event 10 but I am getting all history. So that is simple.

**4. Async Subject:
**In this type of Subject. We will get the last emitted value, which is emitted by a Subject before completion or termination. For simplicity check below example.

```
public static void main(String[] args) throws InterruptedException {

    Subject<String> subject = AsyncSubject.create();
    subject.subscribe(System.out::println);
    int eventCounter = 0;
    while (true) {
        Thread.sleep(100);
        subject.onNext("Event " + (++eventCounter));

        if (eventCounter == 10) {
            subject.onComplete();
            break;
        }
    }
}
```

Output:
Event 10
Process finished with exit code 0

Here as you can see I completed my subject at value 10 and after that program is finished but before exiting the program I got output value Event 10. So its mean any time where I want to get last emitted value of a Subject I will use Async Subject.

Again going to repeat.
Publish Subject: I don’t care about the previous history of emissions. Only I care for new or latest values.
Behaviour Subject: I care for the last value which is emitted by this Subject and the new values.
Replay Subject: I care of all the history of emissions with new values.
Async Subject: I care only the last value which will be emitted by the subject before going to complete or terminate.

Conclusion:
Hello Friends. Hope everything is clear up to this point. Only try your best to do a hands on practice of all these concepts. For now I want to say Bye and have a nice weekend.
🙂


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
