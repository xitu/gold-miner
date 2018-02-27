> * 原文地址：[Continuation (Observable Marriage Proposal to Observer) of Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part7](http://www.uwanttolearn.com/android/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md)
> * 译者：[dieyidezui](http://dieyidezui.com)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5)

# 大话（Observable 向 Observer 求婚）之我与 Rx Observable [Android RxJava2]（这是什么鬼）第七话

哇哦，又是新的一天，是时候学些新知识了。

大家好，希望你们都过得不错。这是我们的 RxJava2 Android 系列第七篇文章了，[ [part1](https://juejin.im/entry/58ada9738fd9c5006704f5a1)，[part2](https://juejin.im/entry/58d78547a22b9d006465ca57)，[part3](https://juejin.im/entry/591298eea0bb9f0058b35c7f)，[part4](https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md)，[part5](https://juejin.im/post/590ab4f7128fe10058f35119)，[part6](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md)，[part7](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md)，[part8](https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md)]。这篇文章里我们将继续和 Rx 聊聊天。

**动机：**

动机和我在[第一部分](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/)介绍给大家的一样。

**前言：**

这篇文章没什么前言，因为这是上篇文章的续集呀。但是开始之前，我想我们还是要先复习一下上篇文章的内容。上篇文章中，Rx Observerable 告诉了我们冷热 Observeable 的含义，随后我向大家分享了一个相关概念的例子。再然后，我问到了 Subject。可是 Observable 觉得我们在了解 Subject API 之前要先熟悉 Observer API。所以我们这次从 Observer API 处继续我们的对话。

**续集:**

我：是的，那你能否告诉我 Subject 的相关概念 和 他的不同实例，如 Publish、Behaviour 等。

Observable：呃...我觉得在了解这些之前，我得先和你聊聊 Observer 的 API 以及他们是如何工作的，并让你知道如何使用 Lambda 或者函数式接口来替代一个完整的 Observer 接口。你觉得如何？

我：没问题，我听你的。

Observable：其实我们已经了解了 Observables。而且在之前的例子中，我们大量使用了多种 Observer。但我觉得在学习新的 API 之前我们还是应该先学习她（Observer）。我们等等她，五六分钟就到了。

Observer：你好啊，Observable。最近怎么样？

Observable：多谢关心，还不错。 Observer，他(即我)是我的新朋友。他正在学习我们，所以我希望你把你自己教给他。

Observer:没问题，你（对我）好啊？

我：你好啊，我挺好的，谢谢。

Observer：在我开始介绍我自己之前，我有一个问题，你知道函数式接口吗?

我：当然。
（注解：如果有人想复习一下这些概念，请参考 [part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/) )

Observer：很棒。所以你已经知道 Observable 是那个观察数据流改变的角色了吧。如果有任何的改变，Observable 会通知他的观察者（们）。因此 Observable 有很多类型，**但是**你要知道没有我（Observer），他（Observable）什么也不是 😛 。

Observable：哈哈哈，完全正确，亲爱的（比心）。

Observer：任何地方只要你能看到 Observable，就百分百可以看到我。你可以认为我就是 Observable 和开发者们（比如我，等等）之间的桥梁。比如你是一个 Rx 的新手，你想要使用一些依赖 Rx 的第三方库。你只有了解我，才能掌握那个库。我觉得这个说法不为过。

我：🙂。

Observer：任何时候你想要知道 Observable 关心的那些数据产生了变化或者有什么事件发生了，你需要使用我来订阅那个 Observable。然后当 Observable 想要通知你那些变化时，他会通过我来转告你。 _所以你可以有很多种方式使用我_ ，但是首先我会从我最基本的 API 讲起。

我：额，我对你的那句“你可以有很多种方式使用我”有些困惑。

Observer：听我说完，我相信最后就没有困惑了。我最基本的 API 有四个方法，如下所示。

```
public interface Observer<T> {
    void onSubscribe(Disposable var1);

    void onNext(T var1);

    void onError(Throwable var1);

    void onComplete();
}
```

这里 T 是 Java 的泛型。我觉得不需要大篇幅讨论 Java 的泛型。简单地说泛型就是如果你在等待 Persion 类型的数据，那么 T 就是 Persion 类。这里不需要强制使用所有的四个基本 API，这完全取决于你的需求。我等会将会给你一些例子，你可以轻易的决定什么时候使用这些基本的 API，什么时候使用更简化的 API。
现在我先一次介绍一个方法。

```
void onSubscribe(Disposable var1);:
```

任何时候当你将 Observer 关联上了 Observable，你将会获得一个 **Disposable** 对象。他有着非常简单的 API，如下所示。

```
public interface Disposable {
    void dispose();

    boolean isDisposed();
}
```

调用 dispose() 意味着你不再关注 Observable 的变化。所以任何时候当我想要离开 Observable 时，我就会调用我的 **Disposable var1;**. **var1.dispose()** 方法。这也意味着我（Observer）和 Observable 分开了。在那之后任何发生在 Observable 上的事件我都不在关心，我也不会再更新或者传达这个变化。我稍后会给你展示这个特性非常适合一些场景，尤其是在 Android 上。
第二个是 isDisposed()，这个方法仅在少数情况有用处，比如我想从 Observable 取得数据，但是我不知道我是否已经被脱离了，所以我可以用它来检测是否我被脱离了。反之亦然，在我主动脱离之前，我不确定我是否已经脱离，我可以调用这个方法来检测。如果我调用这个方法后结果是 false，那么意味着我还没有被脱离，从而我就可以调用 dispose() 方法。

```
void onNext(T var1);:
```

当我订阅 Observable 后，如果 Observable 想要通知我有变化或者新数据时，就会调用这个方法。
我觉得我需要解释得更与众不同一些。当 Observable 想要和我结婚时，他就会暴露他的 API subscribe(Observer) 给我，然后通过调用他的 subscribe() API 我接受了他的求婚，但是重要的是我也得到了 Disposable 对象，这意味着我可以在任何时候和 Observable 离婚。在我们结婚期间，Observable 会在他的数据或者事件流有任何变化时通知我。这个时候，Observable 就会调用我的 onNext([any data]) 方法。所以简单的说当 Observable 的数据有任何变化时就会通过我的 onNext(T data) method 方法通知开发者（我）。

```
void onError(Throwable var1);:
```

这个 API 对我来说更加关键和重要。任何时候当 Observable 发现了致命的问题，他就会使用我的 onError(Throwable var1) API 通知我。Throwable 会告诉我他的崩溃原因或者出现了什么问题。
这也意味着任何时候 onError() 被调用后，Disposable.isDispose() 方法永远会返回 true。所以即使我从不请求离婚，但是当 Observable 面临一些问题后死去，我可以使用 isDispose() 并得到返回值 true 来发觉这个情况。

```
void onComplete();:
```

这个 API 对我同样的关键和重要。任何时候 Observable 准备好死亡或者与我脱离时，他会使用 onComplete() 来通知我。同样 Observable 死亡或者与我脱离时，我的 Disposable 会与在 onError() API 中表现得一致。以上的概念希望我都讲清了。

我：是的，我只有一个问题。onError 和 onComplete 的区别是什么，因为在这两个方法调用后 Observable 都不能再给我发送任何数据的变化。

Observer：你可以认为 Observable 因 onError 而死就像人类因为一些疾病而死。比如 Observable 正在观察服务器的数据但是服务器挂掉了，所以 Observable 是因为某个原因而死亡，而这个原因你将会从 onError 的 Throwable 对象中获得。也许是 500 错误码，服务器没有响应。反之 Observable 因 onComplete() 而死意味着服务器向 Observable 发送了一个完成的消息，在那之后 Observable 不再适合承载更多的数据，因为他的职责是只从服务器获取一次数据。所以在调用 onComplete() 后他将会自然死亡。这就是为什么 Observer，也就是我不能获取到死亡的原因，因为他是自然死亡的。有个值得关注的地方，当 onError 被调用后逻辑上 onComplete 是不能被 Observable 调用的，反之亦然。简单地说 Observable 只能调用这两个方法之一，onError 或 onComplete。Observable 决不允许同时调用 onError 和 onComplete。这下都清楚了吗？

我：喔，清楚了。

Observer：现在我将会给你演示如何在实践中使用我。这个例子中，我将会创建一个每秒都会给我数据的 Observable。我会用不同的方式使用这些数据和 Observable 来让你清楚地明白我所有的 API。

```
private static Observable<Object> getObservable() {
    return Observable.create(observableEmitter -> {
        Observable.interval(1000, TimeUnit.MILLISECONDS)
                .subscribe(aLong -> observableEmitter.onNext(new Object()));
    });
}
```

虽然这确实简单的方法，但是可能还是会让你感到困惑。当我与这个 Observable 结婚后，他会每秒给我一个数据。你看到 Observable<Object> 是这个方法的返回类型。因此任何时候我订阅或者与这个 Observable 结婚我将会得到 Object 类型的数据。下面我将会忽略这些数据并只关注自己方法的调用。

```
Observer<Object> observer = new Observer<Object>() {
    @Override
    public void onSubscribe(Disposable disposable) {
        ObserverLecture.disposable = disposable;
    }

    @Override
    public void onNext(Object o) {
        System.out.println("onNext called");
    }

    @Override
    public void onError(Throwable throwable) {
        System.out.println("onError called. Die due to reason: "+throwable.getMessage());
    }

    @Override
    public void onComplete() {
        System.out.println("onComplete: Die with natural death");
    }
};
```

是的，那就是我，彪悍的人生不需要解释。每当我想要和这个 Observable 结婚或者订阅他时，我会把我传入 Observable.subscribe() 方法。

```
getObservable().subscribe(observer);
```

这里你看到了，我和这位 Observable 先生已经结婚了。🙂 

完整的代码：

```
public class ObserverLecture {

    private static Disposable disposable;

    public static void main(String[] args) {

        Observer<Object> observer = new Observer<Object>() {

            @Override
            public void onSubscribe(Disposable disposable) {
                ObserverLecture.disposable = disposable;
            }
            @Override
            public void onNext(Object o) {
                System.out.println("onNext called");
            }
            @Override
            public void onError(Throwable throwable) {
                System.out.println("onError called. Die due to reason: "+throwable.getMessage());
            }
           @Override
            public void onComplete() {
                System.out.println("onComplete: Die with natural death");
            }
        };
        getObservable().subscribe(observer);
        while (true);
    }
    
    private static Observable<Object> getObservable() {
        return Observable.create(observableEmitter -> {
            Observable.interval(1000, TimeUnit.MILLISECONDS)
                    .subscribe(aLong -> observableEmitter.onNext(new Object()));
        });
    }
}
```

如果我运行这片代码，我会持续地得到下面的输出，也意味着这个程序永远不会退出。

输出：
onNext called
onNext called
onNext called
onNext called
onNext called

现在我决定向你展示 Disposable，看看我们讨论的是不是对的。我会先给你看看 isDisposable() 方法的使用，他会告诉我我是不是被离婚了。

```
/**
 * Created by waleed on 14/05/2017.
 */
public class ObserverLecture {

    private static Disposable disposable;

    public static void main(String[] args) throws InterruptedException {

        Observer<Object> observer = new Observer<Object>() {
            @Override
            public void onSubscribe(Disposable disposable) {
                ObserverLecture.disposable = disposable;
            }

            @Override
            public void onNext(Object o) {
                System.out.println("onNext called");
            }

            @Override
            public void onError(Throwable throwable) {
                System.out.println("onError called. Die due to reason: "+throwable.getMessage());
            }

            @Override
            public void onComplete() {
                System.out.println("onComplete: Die with natural death");
            }
        };

        getObservable().subscribe(observer);


        while (true){
            Thread.sleep(1000);
            System.out.println("disposable.isDisposed(): "+disposable.isDisposed());
        }

    }

    private static Observable<Object> getObservable() {
        return Observable.create(observableEmitter -> {
            Observable.interval(1000, TimeUnit.MILLISECONDS)
                    .subscribe(aLong -> observableEmitter.onNext(new Object()));
        });
    }
}
```

这片代码和上面的很像，只有 while 循环这一处改变了。在 while 循环中，每一秒我都会打印 Disposable 的值来表明 Observer 是否被离婚了。
输出：
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
… infinite

所以你轻易地看到了 false，这意味着我没有被离婚因为我从来没有调用过 Disposable.dispose() 方法。现在是时候向你展示当我调用 dispose() 后会发生什么了。

```
public class ObserverLecture {
    
    private static Disposable disposable;

    public static void main(String[] args) throws InterruptedException {

        Observer<Object> observer = new Observer<Object>() {
            @Override public void onSubscribe(Disposable disposable) {ObserverLecture.disposable = disposable;}
            @Override public void onNext(Object o) {System.out.println("onNext called");}
            @Override public void onError(Throwable throwable) {System.out.println("onError called. Die due to reason: " + throwable.getMessage());}
            @Override public void onComplete() {System.out.println("onComplete: Die with natural death");}
        };

        getObservable().subscribe(observer);
        
        int count = 0;
        while (true) {
            Thread.sleep(1000);
            System.out.println("disposable.isDisposed(): " + disposable.isDisposed());

            count++;
            if (count == 3)
                disposable.dispose();
        }

    }

    private static Observable<Object> getObservable() {
        return Observable.create(observableEmitter -> {
            Observable.interval(1000, TimeUnit.MILLISECONDS)
                    .subscribe(aLong -> {
                        observableEmitter.onNext(new Object());
                    });
        });
    }
}
```

这里的代码和上面的也只有在 while 循环处一个不同。这次我添加了一个 count 变量，所以在我从 Observable 获得三次数据后我就会调用 dispose，从而让我和 Observable 离婚了。
输出：
onNext called
disposable.isDisposed(): false
onNext called
disposable.isDisposed(): false
onNext called
disposable.isDisposed(): false
disposable.isDisposed(): **true**
disposable.isDisposed(): **true**
disposable.isDisposed(): **true**
…

现在你从输出中能看到，三次后我得到了 true，这意味着我离婚了。问题 Observable 身上将会发生什么，他会死去吗？为了解决这个问题，我引入一个概念叫做 冷、热 Observable。如果他是热 Observable 那么他不会死去。但如果他是冷的，他将会停止发送数据。

现在我觉得没有必要去讨论 onNext() 了，因为我们已经在我们的例子中看到了这个方法会在 Observable 数据有任何改变的时候被调用。
所以是时候讨论一下 onError() 和 onComplete() 了，同时包括疾病死亡和自然死亡。

```
public class ObserverLecture {

    private static Disposable disposable;

    public static void main(String[] args) throws InterruptedException {

        Observer<Object> observer = new Observer<Object>() {
            @Override public void onSubscribe(Disposable disposable) {ObserverLecture.disposable = disposable;}
            @Override public void onNext(Object o) {System.out.println("onNext called");
                                                    System.out.println("disposable.isDisposed(): " + disposable.isDisposed());}
            @Override public void onError(Throwable throwable) {System.out.println("onError called. Die due to reason: " + throwable.getMessage());}
            @Override public void onComplete() {System.out.println("onComplete: Die with natural death");}
        };
        getObservable().subscribe(observer);

        while (true) {
            Thread.sleep(1000);
            System.out.println("disposable.isDisposed(): " + disposable.isDisposed());
        }
    }

    private static Observable<Object> getObservable() {
        return Observable.create(observableEmitter -> {
            observableEmitter.onNext(new Object());
            observableEmitter.onNext(new Object());
            observableEmitter.onNext(new Object());
            observableEmitter.onNext(new Object());
            observableEmitter.onError(new RuntimeException("Die due to cancer"));
        });
    }
}
```

这里除了创建 Observable 的方法，我用的代码和上面几乎一样。这个 Observable 会发送四次数据，然后会因为一些原因死去。这里我显示地创造了这个原因，这样我们才好理解 onError() 的概念。
输出：
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): false
**onError called. Die due to reason: Die due to cancer**
disposable.isDisposed(): **true**
disposable.isDisposed(): **true**
…

这里你也能轻松地看到，在我们的 Observable 死去时，他调用了我的 onError 方法。在他死后，我的 isDisposed() 总会返回 true。这说明我离婚了或成为了寡妇。

是时候看一下 onComplete() 了。

```
public class ObserverLecture {

    private static Disposable disposable;

    public static void main(String[] args) throws InterruptedException {

        Observer<Object> observer = new Observer<Object>() {
            @Override public void onSubscribe(Disposable disposable) {ObserverLecture.disposable = disposable;}
            @Override public void onNext(Object o) {System.out.println("onNext called"); System.out.println("disposable.isDisposed(): " + disposable.isDisposed());}
            @Override public void onError(Throwable throwable) {System.out.println("onError called. Die due to reason: " + throwable.getMessage());}
            @Override public void onComplete() {System.out.println("onComplete: Die with natural death");}
        };

        getObservable().subscribe(observer);

        while (true) {
            Thread.sleep(1000);
            System.out.println("disposable.isDisposed(): " + disposable.isDisposed());

        }

    }

    private static Observable<Object> getObservable() {
        return Observable.create(observableEmitter -> {
            observableEmitter.onNext(new Object());
            observableEmitter.onNext(new Object());
            observableEmitter.onNext(new Object());
            observableEmitter.onNext(new Object());
            observableEmitter.onComplete();
        });
    }
}
```

你也看到了，我就改了一处地方。Observable 主动调用了 onComplete 方法。
输出：
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
**onComplete: Die with natural death**
disposable.isDisposed(): **true**
disposable.isDisposed(): **true**
disposable.isDisposed(): **true**

我们很容易就看到，我在调用 Disposable.isDisposed() 时一直是 false，说明我还没有离婚，我还可以从 Observable 获得数据，但是当 onComplete() 调用后 isDispose() 永远返回 true。这意味着因为 Observable 的自然死亡，我离婚了或者是变成了寡妇。

我：喔！谢谢你，Observer。你解释地很棒，帮我解答了很多关于你的疑惑。但是我有些好奇为什么有时候人们使用只有一个方法的 Consumer 来替代 Observer。这是什么方法？

Observer：首先感谢你的夸奖。我可以向你解释更多的 API，但是首先我觉得你应该在 Android 中使用上面的概念并给我一个示例，这样对大家都有帮助。

我：我同意你的想法，但是我觉得当务之急先学习关于你的一切，然后我会给你一个 Android 中使用上述所有 API 的真实的例子。

Observer：好吧，如你所愿。有时候需求并不复杂，尽管你可以使用 Observer 的四个方法但是我觉得使用这四个方法不是必须的，你完全可以用更少的代码来完成需求。因此我把我自己切分成了几个函数式接口，你也可以认为这是对 Observer 的语法糖。例如：

```
public class ObserverLecture {

    public static void main(String[] args) {

        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(new Observer<String>() {
                    @Override
                    public void onSubscribe(Disposable disposable) {
                    
                    }

                    @Override
                    public void onNext(String string) {
                        System.out.println("onNext: "+string);

                    }

                    @Override
                    public void onError(Throwable throwable) {
                        System.out.println("onError");
                    }

                    @Override
                    public void onComplete() {
                        System.out.println("onComplete");
                    }
                });
    }
}
```

输出：
onNext: A
onNext: B
onNext: C
onNext: D
onComplete

这里你能看到我只关注数据，但是我不得不实现 onSubscribe、onError 和 onComplete 方法。看下个例子是如何使用更少的代码来达到相同的目的。

```
public class ObserverLecture {

    public static void main(String[] args) {

        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(s -> System.out.println(s));

    }
}
```

上述这两个例子在功能上是一模一样的，但是这次你看的例子只用了两行代码，而上面的那个代码则非常的长。所以我想和你分享我所有的函数式接口以及你如何在你的应用中使用它们。

```
public interface Consumer<T> {
    void accept(@NonNull T var1) throws Exception;
}
```

```
public interface Action {
    void run() throws Exception;
}
```

我有两个函数式接口，一个最好使的 Consumer<T>，还有一个是 Action。我们先聊一下 Consumer 接口。当我只关注数据且并不在乎任何其他状态的变化时，比如我不想使用 Disposable 了解是否被分离，我也不想知道 Observable 是否死亡以及是否是自然死亡还是疾病死亡。在这种情况下，我就可以使用 Consumer API。因此我很感谢 Observable 提供这个选项让我使用我的函数式接口来订阅他。

Observable：🙂

Observer：是时候让你看看我们使用的示例了。

```
public static void main(String[] args) {

    List<String> strings = Arrays.asList("A", "B", "C", "D");
    Observable.fromIterable(strings)
            .subscribe(new Consumer<String>() {
                @Override
                public void accept(String s) throws Exception {
                    System.out.println(s);
                }
            });
}
```

这里我仅仅订阅了 Observable 的 onNext() 回调，你很容易就能看出来我生成了一个匿名内部类给 Observable 来订阅。下面更神奇的来了，我有和你们说过我有函数式接口，这意味着我能生成一个 Lambda 表达式给 Observable 来订阅而不再需要匿名内部类或者接口对象。

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(s -> System.out.println(s));
    }
}
```

喔，你看到上面的例子了，就一行代码。

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(System.out::println);
    }
}
```

喔，用了更少的代码量。这里我使用了方法引用，但是上面的两块代码功能上是完全一致的。下面的例子还有个技巧。

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer);
    }

    private static Consumer<String > consumer = System.out::print;
    //private static Consumer<String > consumer2 = s->{};
}
```

这里我单独定义了我的 Consumer 函数式接口，并使用这个对象来订阅。
下面是如果我也想知道错误的信息，我将如何被相同的函数式接口通知到。

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, new Consumer<Throwable>() {
                    @Override
                    public void accept(Throwable throwable) throws Exception {
                        System.out.println("Die due to "+throwable.getMessage());
                    }
                });
    }

    private static Consumer<String > consumer = System.out::print;
}
```

这里你可以看到 Observable 的 subscribe 方法的第二个参数是用来通知 onError 的。因此我也生成了一个相同的 Consumer 函数式接口，这个接口的泛型 T 是 Throwable 类。这么用真的是超级简答。
下面是我如何使用 Lambda 表达式获得相同的内容。

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer,
                        throwable -> System.out.println("Die due to "+throwable.getMessage()));
    }

    private static Consumer<String > consumer = System.out::print;
}
```


下面是我如何使用方法引用实现同样的功能。

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, System.out::print);
    }

    private static Consumer<String> consumer = System.out::print;
}
```

喔，只有一件事要注意的是，这里的方法引用仅仅是调用了 Throwable.toString()，并不能展现我们自定义的消息。就像上面例子的那样**(System.out.println(“Die due to “+throwable.getMessage())**。
现在是时候向你展示使用定义我自己的 Error Consumer API 并生成一个那样的对象来订阅。

```
public class ObserverLecture {
    
    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, error);
    }

    private static Consumer<String> consumer = System.out::print;
    private static Consumer<Throwable> error = System.out::print;
}
```

我知道你现在一定很好奇如何知道 Observable 的 onComplete() 是否被调用。对于那种情况，我可以使用 Action 接口。我需要生成一个 Action 接口来作为 Observable 的 subscribe 的第三个参数，从而我能从 Action 接口的回调了解到 Observable 是否完成。

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, error, new Action() {
                    @Override
                    public void run() throws Exception {
                        System.out.println("OnComplete");
                    }
                });
    }

    private static Consumer<String> consumer = System.out::print;
    private static Consumer<Throwable> error = System.out::print;
}
```

这儿你能看到我的 Action 匿名内部类作为订阅的第三个接口。下面我要给你看下我们如何使用 Lambda 表达式和使用方法引用以及使用第一个单独定义的对象替代它。

Lambda 表达式：

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, error, 
                        () -> System.out.println("OnComplete"));
    }

    private static Consumer<String> consumer = System.out::print;
    private static Consumer<Throwable> error = System.out::print;
}
```

方法引用：

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, error, System.out::println);
    }

    private static Consumer<String> consumer = System.out::print;
    private static Consumer<Throwable> error = System.out::print;
}
```

这儿我想提醒一件事，方法引用用在这里只是帮助你理解概念，实际中没什么作用，因为只是向控制台输出了一个空行。

一个定义好的对象：

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, error, complete);
    }

    private static Consumer<String> consumer = System.out::print;
    private static Consumer<Throwable> error = System.out::print;
    private static Action complete = ()-> System.out.println("onComplete");
}
```

所以你也看到了，第三个参数其实是 Action 而不是Consumer。请牢记。

最后一个是 Disposable。当我想分离时，我如何获得一个 Disposable 呢，这时我们可以用泛型 T 为 Disposable 的 Consumer 作为订阅的第四个参数。

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, error, complete, new Consumer<Disposable>() {
                    @Override
                    public void accept(Disposable disposable) throws Exception {
                        
                    }
                });
    }

    private static Consumer<String> consumer = System.out::print;
    private static Consumer<Throwable> error = System.out::print;
    private static Action complete = ()-> System.out.println("onComplete");
}
```

到这儿我就能获得 Disposable 了。看到这想必你也明白了，我既可以实现一个 Observer 也可以用函数式接口做到同样的事。也就是说 Observer 订阅等于 四个函数式接口订阅的组合（Consumer<T>, Consumer<Throwable>, Action, Consumer<Disposable>）。
好了，下面再给你看下我们如何使用 Lambda 表达式替代 Consumer<Disposable>。

```
public class ObserverLecture {

    private static Disposable d;

    public static void main(String[] args) {

        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, error, complete, disposable -> d = disposable);
    }

    private static Consumer<String> consumer = System.out::print;
    private static Consumer<Throwable> error = System.out::print;
    private static Action complete = ()-> System.out.println("onComplete");
}
```

作为一个独立定义的对象：

```
public class ObserverLecture {

    private static Disposable d;

    public static void main(String[] args) {

        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(consumer, error, complete, disposable);
        
    }
    
    private static Consumer<String> consumer = System.out::print;
    private static Consumer<Throwable> error = System.out::print;
    private static Action complete = ()-> System.out.println("onComplete");
    private static Consumer<Disposable> disposable = disposable -> d = disposable;
}
```

希望我都把一切都讲清楚了。最后我还想说下，用 Observer 接口或者使用函数式接口完全取决于开发者们自身的选择。还有问题吗？

Observable：等一下。我还想再次感谢一下 Observer，耽误了她不少时间。我觉得你应该借此给出一个更加合适的、实际中用到的、包含上面全部概念的例子，这应该帮助到读者。

我：首先我也要先谢谢 Observer，你真棒！那 Observable，我等会给出一个 Android 中的例子吧，然后我就想学习 Observable 中的 Subject 了。

Observable：哈哈，好的。我就在这儿哪都不去，但是在那之前我们要先和 Observer 说再见了。

我：是的，谢谢 Observer 用你宝贵的时间给我们分享。其实我在日常编程任务中已经大量使用你了，但是直到现在我才知道为什么我需要使用你以及你是如何工作的。再次感谢！

结语：
朋友们，大家好。希望上面的知识点都讲清楚了，不过要在日常实践中多多使用上面的知识点哦。现在我想应该和大家说再见了，周末愉快。
🙂


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

