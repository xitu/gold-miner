> * 原文地址：[Continuation (Observable Marriage Proposal to Observer) of Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part7](http://www.uwanttolearn.com/android/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md)
> * 译者：
> * 校对者：

# Continuation (Observable Marriage Proposal to Observer) of Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part7

WOW, we got one more day so its time to make this day awesome by learning something new 🙂.

Hello guys, hope you are doing good. This is our seventh post in series of RxJava2 Android [ [part1](https://juejin.im/entry/58ada9738fd9c5006704f5a1), [part2](https://juejin.im/entry/58d78547a22b9d006465ca57), [part3](https://juejin.im/entry/591298eea0bb9f0058b35c7f), [part4](https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md), [part5](https://juejin.im/post/590ab4f7128fe10058f35119), [part6,](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-summer-vs-winter-observable-dialogue-rx-observable-developer-android-rxjava2-hell-part6.md) [part7](https://github.com/xitu/gold-miner/blob/master/TODO/continuation-observable-marriage-proposal-observer-dialogue-rx-observable-developer-android-rxjava2-hell-part7.md) and [part8](https://github.com/xitu/gold-miner/blob/master/TODO/confusion-subject-observable-observer-android-rxjava2-hell-part8.md) ]. In this part we are going to continue our dialogue with Rx.

**Motivation:**
Motivation is same which I share with you in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/).

**Introduction:
**There is no intro for this post because that is a continuation of our last post but before going to start I think we will do revise about our last post. In last part Rx Observable told us about Hot Vs Cold Observable and later [Me] share with us a one concrete example of these concepts. After that [Me] asked about Subjects but Rx Observable feel we should know Observer API’s before Subject API’s. So we are going to continue our Dialogue from Observer API’s where we stop.

**Continuation:**

Me: Yes, can you tell me about the concept of a Subject and different type’s of subjects like Publish, Behaviour etc.

Observable: Hmmm. I have a feeling before going to that concept. I should tell you about Observer API’s and how they work and how you can use Lambda or Functional interfaces without using a Complete Observer interface. What you think?

Me: Yes sure. I am with you.

Observable: So as we know about Observables. There is a one more concept Observer which we already using a lot in our examples but I have a feeling we should learn about her before going to next API’s. We need to wait for 5-6 minutes she is coming.

Observer: Hello Observable. How are you? How is going?

Observable: I am good. Thank you. Observer he is [Me]. My new friend. He is learning about us. So I want you should teach him/her about yourself.

Observer: Sure. Hi [Me]. How are you?

Me: Hi, I am good. Thank you.

Observer: So before I am going to start about my self. I have one question. You know about Functional interfaces?

Me: Yes.
(Note: If any body want to refresh there concepts related to Functional interfaces please refer to [part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/) )

Observer: Good ok. As you already know Observable is the one who will observe about the changes on Data stream. If is there any change Observable will inform to its observer(s). Then there are different type of Observables **BUT** you know, without me (Observer) Observable is nothing 😛 .

Observable: hahaha 100% true. My love (heart).

Observer: Any where you will see Observable. I am giving you 100% guarantee I will be there. Instead you can say I am a bridge between Observable and [Me, Developers, etc..]. Like if you are new in Rx and you want to use some third party library which is using Rx. So only if you know about me you will be a master of that library. I think that is more then enough theory.

Me: 🙂

Observer: Any time you want to know any where data is changed or any other event occur where Observable is taking care of that data or event. You need to subscribe to that Observable by using me. And later when Observable wants to inform you about any change he will inform me and I will inform to you. _So basically you can use me about many ways_ but first I will start from my most basic API’s.

Me: Opps I am confused about your sentence “So basically you can use me about many ways”.

Observer: Wait and listen me. In the end there is no confusion. In my basic form of API I have four methods just like shown below.

```
public interface Observer<T> {
    void onSubscribe(Disposable var1);

    void onNext(T var1);

    void onError(Throwable var1);

    void onComplete();
}
```

Here T is a generics in Java. I don’t think I need to discuss about generics in Java. In simple words if you are waiting for data of Type Person then that T should be a Person object.
Now here this is not compulsory to use always basic four method Observer API. That is totally depend upon your requirement. I will give you some examples in which you can easily determine when you will use this Basic API or when you can use very simple API’s which I will share with you later.
Now I am going to take one method at a time.

```
void onSubscribe(Disposable var1);:
```

Any time when you attached Observer with Observable you will get **Disposable** object. That has a very simple API as shown below.

```
public interface Disposable {
    void dispose();

    boolean isDisposed();
}
```

So dispose() it is just like you are no more interested in this Observable changes. So any time when I want to leave Observable I always call my **Disposable var1;**. **var1.dispose()** method. That is just like a divorce between me(Observer) and Observable. After that any event occur in Observable I don’t care. I will not be update or conveyed by that change. That is very useful on some places specially in Android I will show you later.
Second is isDisposed(), that method only useful if I am confused like I want a data from Observable but I have a feeling may be I already divorced, so I can check am I divorced or not. Vice versa also like I am not sure, am I already divorced. For that I can check by using this method, and if I got false in a method call result its mean I am not divorced so I need to call dispose() method.

```
void onNext(T var1);:
```

This method is used when I am subscribed to Observable, and Observable want’s to inform me there is a change or new data.
I think I will explain differently. When Observable want’s to marry with me. He exposed me one API onSubscribe(Observer). Then I accepted his proposal of marry by going inside of his onSubscribe() API but important point I also got the Disposable which means I have an option to gave a divorce to Observable at any time. Now as we marry Observable always inform me about any change which will occur in his data or event stream. Now at that time Observable used my onNext([any data]) method. So in simple words when Observable have any change in his data he always inform to [Me, Developers] by using my onNext(T data) method of mine.

```
void onError(Throwable var1);:
```

This API is really critical and emotional for me. Any time when Observable faced any issue he will die and inform me by using my onError(Throwable var1) API. In Throwable he always informed me why or what type of issue he faced before died. Its mean any time when onError() called after that disposable isDispose() method always give me true. So its mean sometimes when I never ask for divorce but Observable faced some issue and he died, so I can check by using isDispose() which will return me true.

```
void onComplete();:
```

This API is again critical and emotional for me. Any time when Observable is ready to die or want to give me a divorce. He always inform me by using onComplete(). As Observable die or give me divorce my Disposable again work in a same way as we already discuss in onError() API. I hope currently everything is clear.

Me: Yes only one question. What is the difference between onError and onComplete because after both method calls Observable is not able to send me any new change in data.

Observer: ok you can think like Observable die due to onError is just like in humans people die due to some disease. Like Observable is observing for data to Server and server is not up. So observable will die due to a reason which you will get in onError throwable object. May be that is 500 error code, server not responding. On the other hand die due to Observable onComplete() its mean server send a complete message to Observable and after that Observable is not eligible for more data because that has only duty to take one time data from Server. So this time he will be die natural death by calling onComplete(). That is why as an Observer, I am not getting any reason why he died because he die as a natural death. One important point if onError called so logically there is no reason onComplete will called and vice versa also true. In simple words only one method will be called by Observable, may be onError or may be onComplete. There is no possibility Observable will called onError and onComplete at a same time.
Hope everything is clear now.

Me: Wow yes.

Observer: Now I am going to give you example. How you can use me in practical.
In this example I am going to create a Observable which will give me data after every one second. So I will use that data and Observable in different ways to give you clear picture about all my API’s.

```
private static Observable<Object> getObservable() {
    return Observable.create(observableEmitter -> {
        Observable.interval(1000, TimeUnit.MILLISECONDS)
                .subscribe(aLong -> observableEmitter.onNext(new Object()));
    });
}
```

May be that will confused you but that is really simple method. That always give me data after one second as I marry with this Observable. You can saw Observable<Object> its return type. So any time when I will do subscribe or marry with this Observable I will get Object type data. I am going to ignore data I only focus on my method calls.

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

Yes that is me. No need to explain any thing. Any time when I want to marry or subscribe to Observable I will send me into Observable subscribe() method.

```
getObservable().subscribe(observer);
```

Here you can see I am married with Observable. 🙂

Complete code:

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

If I run this code. I will get below output for infinite time, means this program never exit.

Output:
onNext called
onNext called
onNext called
onNext called
onNext called

Now I am going to show you first about Disposable, what we discuss is it true or not. I will show you first use of isDisposable() method. That inform me, Am I divorced or not.

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

This is a same code like above only one change in while loop. In while loop after every one second I am showing the value of Disposable is Observer is divorced or not.
Output:
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
disposable.isDisposed(): **false**
onNext called
… infinite

So you can easily see false, mean I am not divorced because I never called Disposable dispose() method. Now its time to show you what will happen when I will call dispose().

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

here again code is same only difference in while loop. This time I added a one count variable. So as I got data from Observable three time’s I will call dispose. Its mean I want divorce from Observable.
Output:
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

Now you can see easily in output, after 3 times I am getting true. Its mean I am divorced. Now question is what will happen with Observable. He also died or not. So for that I only want to use one concept Hot vs Cold Observable. If that is Hot Observable then he is not died but if he is Cold then again he is not died but will stop sending data.

Now I think there is no Need to discuss onNext() because we already check in all our examples that is the method which will be called from Observable when there is any change.
So its time to discuss about onError() and onComplete() or Death due to disease or natural death.

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

Now here again I am using same code except the method from which we are getting Observable. This Observable will send data 4 time and after that will die due to some reason but here I am creating that reason forcefully. So we can get the concept of onError().
Output:
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

Now you can see easily. As our Observable died. He called my onError method and also after death my isDisposed() is giving me true. So its mean I am divorced or widow.
Now its time to check onComplete().

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

Here you can see I have only one change. Observable called onComplete on his own.
Output:
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

Now here we can easily see. I got false when disposable.isDisposed() called its mean I am not divorced and I will get data from Observable but as onComplete() called I got true in isDispose(). Its mean this time I am divorced by Observable or may be I am widow due to natural death.

Me: Wow. Thank you Observer. That is a really good explanation. You clear a lot of confusions, which I have about you but now I am curious some times people used only one method in subscriber as a Consumer. What is that method?

Observer: First thanks for appreciation. I can explain you about more API’s but first I have a feeling you should use the above same concept in Android and gave a one example, that will be really helpful for everybody.

Me: I agree with you but I think first we will learn everything about you then I will gave one real world example in Android in which I will use all your above API’s.

Observer: Ok as you wish. Some times, scenarios are not really complex and you can use Observer 4 method API but I have a feeling that four methods are not required you can use less code to achieve that scenario. For that I divided my self into functional interfaces or may be you can say that is a syntactic sugar for Observer. For example

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

Output:
onNext: A
onNext: B
onNext: C
onNext: D
onComplete

Now here you can see I am only interested in data but I need to implement onSubscribe, onError and onComplete. Which is a boilerplate so in next example how we can achieve with very less code.

```
public class ObserverLecture {

    public static void main(String[] args) {

        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(s -> System.out.println(s));

    }
}
```

In functionality both above examples are same but you can see this time I only use two lines of code, and before that its a very long code. So now I am going to share with you all my Functional Interfaces and how you can use in your applications.

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

So I have two functional interfaces. One is Consumer<T> that is really useful and the second one is Action. Now first we will discuss about Consumer Interface. When I know, I am only interested in data only and I don’t care about any other state like I don’t want to know about isDivorced by using Disposable or I don’t want to know is Observable died by natural death or by some disease. On these type of situations I can use this Consumer API and also i want to say thanks to Observable who gave me this option to subscribe by using my Functional Interfaces.

Observable: 🙂

Observer: Its time to show you some code which we already used.

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

Here I am only subscribing for onNext() Callback from Observable. You can easily see I am sending one anonymous class to Observable to subscribe. Now there is one more magic. As I already told you guys I have Functional Interfaces so its mean I can send Lambda Expression to Observable for subscription rather then anonymous class or Interface Object.

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(s -> System.out.println(s));
    }
}
```

Wow. You can see in above example, only one line.

```
public class ObserverLecture {

    public static void main(String[] args) {
        List<String> strings = Arrays.asList("A", "B", "C", "D");
        Observable.fromIterable(strings)
                .subscribe(System.out::println);
    }
}
```

Wow . More less words. Here I am using method referencing but in the end all above code blocks are given me same functionality. One more technique is remaining in a same example as shown below.

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

Here I am separately defining my Consumer functional interface and I am using that object for subscription.
Next we also want to know if any error occur. How I will be informed by using same Functional Interfaces.

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

Here you can easily see the second argument in subscribe method of Observable is onError informer. Also I am sending same Consumer Functional Interface with T = throwable. That is really simple.
Next how I can achieve same thing by using Lambda Expression.

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

Next how I can achieve by using Method Referencing.

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

Wow. Only one thing to mention. Here method reference call throwable.toString() not able to show our custom message. Like how we are showing in one above example (**System.out.println(“Die due to “+throwable.getMessage())**.
Now its time to show you by defining my Error Consumer API and sending that object to subscribe.

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

Now I know you are curious how to know is Observable onComplete() called or not. For that I have an Action interface. Which I need to send as a Third argument in subscribe of Observable. So as Observable complete I will get signal in action interface.

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

Here you can see my new Action anonymous interface is subscribing as a third argument. Next I am going to show you. How we can use as Lambda expression then as a Method reference and in last as a separate defined object.
As Lambda:

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

As Method Reference:

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

Here I only want to mention one thing. Here method reference is only used to show you a concept otherwise this type of use is useless, because this only show a one extra line on a console.

As a defied object:

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

So you can see third argument is Action not a Consumer. That is important to remember.
Last thing is Disposable. How I can get disposable if I want divorce. For that we have a fourth argument and that is Consumer with T = Disposable.

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

Here I can get Disposable.
Also [Me] you can see here. I can implement my self as an Observer or may be I can achieve same thing by using Functional Interfaces. Its mean
Observer subscription = Four Functional Interfaces subscription (Consumer<T>, Consumer<Throwable>, Action, Consumer<Disposable>)
Now its time to show you how we can use Lambda Expression for Disposable.

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

As a separate defined object:

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

Hope everything is clear. In the end I only want to say, that is totally depend upon a developer or a team how they want to use my API’s. They can use Observer interface or they can use Functional Interfaces. Any other question.

Observable: One minute. First I really want to say thanks to Observer, specially for her time. Now [Me] I think you should gave a one more proper or real time example for all above concepts. That will be really helpful for reader.

Me: First I also want to say Thanks to Observer. You are awesome. Now Observable I will gave a one example in Android and then I want to learn more about Subjects in Observable.

Observable: haha sure. I am here I am not going any where but we need to say bye to Observer.

Me: Yes. Thanks Observer for your precious time. I already used you a lot in my daily programming tasks but from now I know why I am using you and how you are working under the hood. Again thanks.

Conclusion:
Hello Friends. Hope everything is clear up to this point. Only try your best to do a hands on practice of all these concepts. For now I want to say Bye and have a nice weekend.
🙂


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
