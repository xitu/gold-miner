> * 原文地址：[Confusion between Subject and Observable + Observer [ Android RxJava2 ] ( What the hell is this ) Part8](http://www.uwanttolearn.com/android/confusion-subject-observable-observer-android-rxjava2-hell-part8/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md](https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md)
> * 译者：[RockZhai](https://github.com/rockzhai)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5)

# Subject 和 Observable + Observer 的混淆指北[ Android RxJava2 ] ( 这什么鬼系列 ) 第八话

哇哦, 我们又多了一天时间，所以让我们来学点新东西好让这一天过得很棒吧 🙂。

各位好, 希望你现在已经做的很好了。 这是我们关于 RxJava2 Android  系列文章的第八篇 [ [第一话](https://juejin.im/entry/58ada9738fd9c5006704f5a1)，[第二篇](https://juejin.im/entry/58d78547a22b9d006465ca57)，[第三话](https://juejin.im/entry/591298eea0bb9f0058b35c7f)，[第四话](https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md)，[第五话](https://juejin.im/post/590ab4f7128fe10058f35119)，[第六话](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md)，[第七话](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md)，[第八话](https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md) ] 。在这一篇文章中将讨论 Rx 中的 Subjects（主题）。

**研究动机 :**
本文研究动机和系列文章 [第一话](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/) 中分享给大家的相同。

**引言 :** 当我开始与 Rx 的这段旅程时， Subjects 就是我最困惑的一个部分。在大多数我开始去读任意博客的时候，我总是得到这样一个定义: “ Subjects 就像一个 Observable 和 Observer 同时存在一样。” 因为我不是一个聪明的人，所以这一点一直让我很困惑，因此在用 Rx 做了很多练习之后，有一天我得到了关于 Subjects 的概念，我惊讶于这个概念的强大，所以在这篇文章中我将和你一起讨论这个概念以及这个概念有多强大，或许在一些地方我不正确的使用了这个概念，但是这次让你学到这个概念，在本文最后，你将会和 Subjects 成为很好的朋友。🙂

如果你和我一样，认为 Subjects 就像是 Observer 和 Observable 的组合，那么请尽量忘掉这个概念。现在我将要修改一下 Observable 和 Observer 的概念. 
对于 Observable 我会建议你阅读 [ Rx Observable 和 开发者 ( 我 ) 之间的对话 [ Android RxJava2 ] （这什么鬼系列 ）第五话](http://www.uwanttolearn.com/android/dialogue-rx-observable-developer-android-rxjava2-hell-part5/) 并且 Observer 我会建议你阅读 [继续 Rx Observable 和 开发者 ( 我 ) 之间的对话 (Observable 求婚 Observer) [ Android RxJava2 ]（这什么鬼系列）第七话](http://www.uwanttolearn.com/android/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7/) 。然后你就可以很轻易的理解本篇文章，现在我会在下面和你分享一下 Obsevable 和 Observer API‘s .

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-8.55.46-AM-1024x329.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-8.55.46-AM.png)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-8.56.00-AM-1024x281.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-8.56.00-AM.png)

这是 Observable 的代码，如图所示代码总行数为 3000 多行.  正如我们所知，Observable 通常使用其不同的方法将数据转换为流，下面我给出一个简单的例子。

```
public static void main(String[] args) {
    List<String> list = Arrays.asList("Hafiz", "Waleed", "Hussain");
    Observable<String> stringObservable = Observable.fromIterable(list);
}
```

接下来我们需要 Observer 从 Observable 中得到数据。现在我将第一次向你展示 Obsever 的一些 API。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-9.04.40-AM-1024x421.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-9.04.40-AM.png)

就像我们看到的 Observer 非常简单，只有 4 个方法，那现在是时候在示例中使用一下这个 Observer 了。

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

它的输出很简单. 现在我们成功修订了 Observable 和 Observer API’s ,  当做订阅时，Observable 基本是调用我们的 Observer API’s。
任何时候 Observable 想要提供数据，总是要调用 Observaer 的 onNext ( data ) 方法。
任何时候发生错误 Observable 会调用 Observer 的 onError(e) 方法。  
任何时候流操作完成 Observable 会调用 Observer 的 onComplete() 方法.
这是这两个 API 之间的一个简单关系.

现在我将要开始我们今天的主题，如果再次对 Observable 和 Observer 有任何疑惑，请尝试阅读我上文中提到的文章，或者在评论中提问。
我认为 Rx 中关于 Subjects 的定义放到最后讨论，现在我将向你解释一个更简单的例子，它将使我们可以更直接的掌握 Rx 中 Subjects 的概念。

```
Observable<String> stringObservable = Observable.create(observableEmitter -> {
    observableEmitter.onNext("Event");
});
```

这是可以发射一个字符串的 Observable。

```
Consumer<String> consumer = new Consumer<String>() {
    @Override
    public void accept(String s) {
        System.out.println(s);
    }
};
```

这是一个将会订阅 Observable 的消费者。

```
while (true) {
    Thread.sleep(1000);
    stringObservable.subscribe(consumer);
}
```

这段代码会在每一秒后产生一个事件。
为了方便阅读我把完整的代码代码贴出。

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

这是一个简单的例子，我认为没有必要过多的解释，现在有趣的部分是，我会用不同的技术来写出会有一样输出的新的例子。 
在深入之前，尝试阅读下面的代码。

```
class ObservableObserver extends Observable<String> implements Observer<String>.
```

这很简单，我创建了一个名为 ObservableObserver 的新类， 它继承自 Observable 并且实现了 Observer 接口。 所以这意味这它可以作为 Observable 加强版 和 Observer. 我不认为这会有任何疑问，所以我们已经知道 Observable 总是会生成流，所以这个类也有这个能力，因为它继承自 Observable。然后我们可知 Observer 可以通过 订阅 Observable 来观察 Observable 中的任何流，那么我们的新类也可以完成这些工作，因为它实现了 Observer 接口，BOOM。
很简单。
现在我要给你看全部代码，代码只是为了解释这个概念并不意味着它是一个 成熟 的代码。

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

又一个很简单的类，我们已经使用过上面的所有方法了，只是在这里有一个区别，就是我们在同一个类中使用了 Observable 和 Observer 的相关方法。

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

在上面的代码中有两行很重要，我将要给大家解释一下：
**observableObserver.getObservable():
**这里，我从 ObservableObserver 类获取 Observable 并订阅 Observer .
**observableObserver.onNext(“Event”):
**这里，当事件发生时调用 Observer API 方法.
因为作为一个自我闭环的类，所以我能够从这个既是 Observabel 又是 Observer 的类中获得好处。现在有一个惊喜，你已经掌握了 Subjects 的概念，如果你不信的话来看下面图中的代码：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-10.32.40-AM-1024x453.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/07/Screen-Shot-2017-07-09-at-10.32.40-AM.png)

这是 RxJava2 Subject 类的代码，现在你可以明白为什么人们会说 Subjiects 既是 Observable 又是 Observer，因为它使用了两个的 API 方法。
现在的 RxJava 中可以使用不同类型的 Subjects,  这是我们下面要讨论的内容。

在 RxJava 中你可以获取到 4 种类型的 Subjiects。
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

一般来说如果你运行上面的代码，你将会看到输出中除了 AsyncSubject 的其他 Subjects 输出都是相同的，现在是时候来区别一下这些 Subjects 的类型了。
**1. Publish Subject:
**在该类型 Subject 中，我们可以获取实时的数据，例如我的一个 Publish Subject 是获取传感器数据，那么现在我订阅了该 Subject, 我将之获取最新的值，示例如下：

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

所以，在这里 publish subject 发布数据是从 0 开始，而在订阅的时候已经发布到了 10，正如你所见，输出的数据为 Event 11。

**2. Behaviour Subject:
**在这种类型的 Subjects 中，我们将获取这个 Subject 最后发布出的值和新的将要发出的值，为了简单起见，请阅读下面的代码。

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

正如输出中你所看到的那样，我也获得了 “ Event 10” 这个值，并且这个值在我订阅之前就已经发布了。这意味着如果我想要订阅之前的最后一个值的话，我可以使用这个类型的 Subject。

**3. Replay Subject:
**在这个类型的 Subject 中，当我订阅时可以没有顾及的获得所有发布的数据值，简单起见还是直接上代码吧。

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

现在我再次在 event 10 的时候订阅，但是我可以获得所有的历史数据，所以这很简单嘛。

**4. Async Subject:
**在这个类型的 Subject 中，我们将获得最后发布的数据值，这个数据值是 Subject 在完成和终止前发射的，为了简单起见，依旧是直接上代码吧。 

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

在这里，你可以看到在值为 10 的时候以完成标识结束了 Subject 并且在程序完成后和程序退出之前，我得到了输出的 Event 10 ，所以这意味着它的意思是任何时候我想要通过 Subject 获得最后一次发布的的数据值可以使用 Async Subject。

再次重复一下：
Publish Subject: 我不关心之前的发布历史，我只关心新的或者最新的值。
Behaviour Subject: 我关心该 Subject 发布的最后一个值和新值。 
Replay Subject: 我关心所有发布了新值的历史数据。
Async Subject: 我只关心在完成或终止之前由主题发出的最后一个值。

总结：
你好呀朋友，希望你对这个知识点已经很清晰了，另外尽你最大的努力去动手实践这些概念，现在，我想要和各位说再见了，还有祝大家有个愉快的周末。
🙂

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
