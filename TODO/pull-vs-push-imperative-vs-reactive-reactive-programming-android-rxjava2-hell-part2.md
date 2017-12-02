> * 原文地址：[Pull vs Push & Imperative vs Reactive – Reactive Programming [Android RxJava2]|( What the hell is this ) Part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[XHShirley](https://github.com/XHShirley)
> * 校对者：[yunshuipiao](https://github.com/yunshuipiao)，[zhaochuanxing](https://github.com/zhaochuanxing)


## 拉模式和推模式，命令式和响应式 – 响应式编程 [Android RxJava2]（这到底是什么）：第二部分 ##

太棒了，我们又来到新的一天。这一次，我们要学一些新的东西让今天变得有意思起来。

大家好，希望你们过得不错。这是我们 Rx Java 安卓系列的第二部分。在这篇文章里，我打算解决下一个关于推模式（Push)和拉模式（Pull）或者推模式（Push)与迭代模式，以及命令式和响应式之间的困惑。

**动机：**

动机跟我分享[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md)的是一样的。当我看到有 hasNext()，next()方法的迭代模式（Pull），在 Rx 中反过来也一样时，我经常感到疑惑。同样地，关于命令式编程和响应式编程的很多例子也让我困惑。

**修改：**

在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md)中，我们讨论了 Rx 最重要，最基本也最核心的概念, 观察者模式。在程序里的任何一个地方，如果我想要知道数据变化，我会使用观察者模式。就像我们在上一篇博客中看到的邮件通知的例子那样。我们需要吃透这个概念。这很重要，如果你理解这个概念，那你就能理解其他操作如Rx中的映射，筛选等都是在数据上的函数调用。

**介绍：**

今天，我将针对拉模式（Pull）和推模式（Push),以及命令式和响应式编程的一些容易困惑的地方做出解答。拉模式（Pull）和推模式（Push）本身跟 Rx 没有关系。基本上，那只是两种技术或者策略之间的对比。多数情况下，我们在代码中使用拉模式（Pull）， 但在Rx中我们可以将其转换为推模式（Push），这能带来很多好处。用同样的方式，命令式和响应式都是编程范式。我们在 Android 而我们将试图写成响应式，而我们将试图写成响应式。首先，我准备解释命令式和响应性的经典例子，这些代码我们经常看到，但是之后我将用这个例子作为一个概念。所以，你可以尝试记住我说的例子。

**命令式方法：**

```
int val1 = 10;
int val2 = 20;
int sum = val1 + val2;
System.out.println(sum); // 30
val1 = 5;
System.out.println(sum); // 30
```

在命令式方法里，当我们在 sum 被赋值后使 val1 = 5，sum 变量不会受到影响。Sum 还是 30。

**响应式方法：**

```
int val1 = 10;
int val2 = 20;
int sum = val1 + val2;
System.out.println(sum); // 30
val1 = 5;
System.out.println(sum); // 25
```


在响应式方法里，当我们在 sum 被赋值后使 val1 = 5，sum 变量会变成 25，好像 sum = val1 + val2 在底层又被调用了一次。

所以我想你们应该能记住命令式和响应式的主要概念了。

现在，我们来复习一个拉模式（Pull）和推模式（Push）的传统例子。
正如下面的代码里，我有一些数据。

```
private static ArrayList<String > data = new ArrayList<>();
    data.add("A");
    data.add("B");
    data.add("C");
    data.add("D");

```

现在我准备玩一玩这个数据。我想先在控制台遍历一遍这个数据。

```
private static ArrayList<String > data = new ArrayList<>();

public static void main(String[] args){

    data.add("A");
    data.add("B");
    data.add("C");
    data.add("D");
    Iterator<String > iterator = data.iterator();
    while (iterator.hasNext()){
        System.out.println(iterator.next());
    }
```

```
Output:
```


A

B

C

D

Process finished with exit code 0


基本上，那就是拉模式（Pull）方法。现在，我分享一下我因为缺少了解而产生的困惑。解释一下拉模式是怎样的，想象一下，遍历数据之后，我添加两个新的数据对象，但我不打算再一次遍历我的数据。这代表着，在我的程序里，我将永远不知道有新的数据（被添加进来），正如下面代码所示。

```
private static ArrayList<String > data = new ArrayList<>();

public static void main(String[] args){
    data.add("A");
    data.add("B");
    data.add("C");
    data.add("D");
    Iterator<String > iterator = data.iterator();
    while (iterator.hasNext()){
        System.out.println(iterator.next());
    }
  	data.add("E");
   data.add("F");
}
Output:
```

---

A

B

C

D

Process finished with exit code 0

---

所以，拉模式（Pull）简单地来说，作为一个开发者，检查到数据是否被改变并根据改动做下一步的决定，是我的职责所在。如上所示，我想稍后重新遍历数据来看看是否有数据改变。这也是一种命令式的方法。

现在我将使用拉（Pull）方法重新实现我们本来的需求，但在那之前，我要写一些帮助方法在下面。所以，如果我在主程序中调用了这些方法，请不要感到困惑。

```
private static void currentDateTime() {
    System.out.println(new Date(System.currentTimeMillis()).toString());
}
```

上面的方法只是用于在控制台中显示当前的日期和时间。

```
private static void iterateOnData(List data) {
    Iterator iterator = data.iterator();
    while (iterator.hasNext()) {
        System.out.println(iterator.next());
    }
}
```

Above method only printout a whole list on console.

上面的方法只是用于在控制台中打印出一整个列表。

```
private static final TimerTask dataTimerTask = new TimerTask() {
    private int **lastCount** = 0;

    @Override
    public void run() {
        currentDateTime();
        if (**lastCount != data.size()**) {
            iterateOnData(data);
            **lastCount = data.size();**
        } else {
            System.out.println("No change in data");
        }
    }
};
```

上面的方法挺重要的。作为一个开发者，我用轮询来实现拉（Pull）方法。所以我现在做的是什么呢？这个方法会在每 1 秒或每 1000 毫秒调用一次。在第一次运行的时候，我会检查数据中是否有任何改变。如果有，则将数据在控制台显示出来，如果没有，则显示没有改变。

是时候来检查我们的主方法了。

```
public static void main(String[] args) throws InterruptedException {

    currentDateTime();
    data.add("A");
    data.add("B");
    data.add("C");
    data.add("D");

    Timer timer = new Timer();
    timer.schedule(dataTimerTask, 0, 1000);

    Thread.sleep(4000);
    currentDateTime();
    data.add("E");
    data.add("F");
}
```

Output:

---

Sat Feb 11 10:17:**09** MYT 2017

Sat Feb 11 10:17:**09** MYT 2017

A

B

C

D

Sat Feb 11 10:17:**10** MYT 2017

No change in data

Sat Feb 11 10:17:**11** MYT 2017

No change in data

Sat Feb 11 10:17:**12** MYT 2017

No change in data

Sat Feb 11 10:17:**13** MYT 2017

Sat Feb 11 10:17:**13** MYT 2017

A

B

C

D

E

F

Sat Feb 11 10:17:**14** MYT 2017

No change in data

Sat Feb 11 10:17:**15** MYT 2017

No change in data

---


这就是这段代码产生的效果。我准备一起解释一下输出和代码。当 app 跑起来的时候，轮询会让我在控制台得到时间和数据，因为轮询方法会马上执行第一次，然后每隔 1 秒执行一次。所以当它立刻运行的时候，我可以看到我的数据从 A 到 D。之后，我在主方法里让主线程休眠 4 秒，但你依然可以看到我们的输出，因为我使用了轮询。每1秒过后，我都可以看到“no change in data”的输出。4 秒后我们的主线程将重新开始工作。现在我将两个新数据对象添加进去，1 秒后，当轮询方法调用后，我可以在屏幕上看到新的输出，从 A 到 F。这也是命令式的方法。

这里是所有的代码，你可以在你自己的 IDE 中跑一遍。



```
import java.util.*;

/**
 * Created by waleed on 11/02/2017.
 */
public class EntryPoint {

    private static ArrayList<String> data = new ArrayList<>();

    public static void main(String[] args) throws InterruptedException {

        currentDateTime();
        data.add("A");
        data.add("B");
        data.add("C");
        data.add("D");

        Timer timer = new Timer();
        timer.schedule(dataTimerTask, 0, 1000);

        Thread.sleep(4000);
        currentDateTime();
        data.add("E");
        data.add("F");

    }

    private static final TimerTask dataTimerTask = new TimerTask() {
        private int lastCount = 0;

        @Override
        public void run() {
            currentDateTime();
            if (lastCount != data.size()) {
                iterateOnData(data);
                lastCount = data.size();
            } else {
                System.out.println("No change in data");
            }
        }
    };

    private static void iterateOnData(List data) {
        Iterator iterator = data.iterator();
        while (iterator.hasNext()) {
            System.out.println(iterator.next());
        }
    }

    private static void currentDateTime() {
        System.out.println(new Date(System.currentTimeMillis()).toString());
    }
}

```

我感觉现在对于什么是拉(Pull)模式，已经少了很多困惑。这种方法最大的问题在于，开发者需要写很多程序来管理所有的事情。所以对于管理这样的需求，如果不用轮询或拉(Pull)模式，我可以怎么做呢？我们可以利用观察者模式，正如我们在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md)所做的。但那是一堆样板文件代码，开发者需要写很多次。我们可以利用 Rx 的库获得便利，这样我们就不需要写一大堆观察者模式的样板代码，但是现在我们还不准备开始用 Rx。首先我们抛开 Rx 理解另外一些概念。那么现在我将把我的代码转换成 推（Push）模式，而不是用 Rx。这样，拉(Pull)和推（Push）分别是什么就非常清晰了。

在开始前，我们先简单地来讨论一下拉（Pull）和推（Push）的不同之处。拉（Pull）意味着，作为一个开发者，我对所有事情负责。正如我想知道数据是否有任何变化，我想去询问：“嘿，有什么新的变动吗？”。这是很难维护的，因为程序里多个线程启动，如果开发者有一点偷懒，就会造成内存泄漏。

在推（Push）中，开发者只需要写简单的代码，并且给予数据一定的顺序：“如果（数据）有任何变动，你就通知我吧。”这个就是推（Push）方法。我准备用同样的例子来解释这个方法。首先我将使用观察者模式来达到这个目的，之后我会向你展示使用回调（Callback）的方式。

**使用观察者模式:**

```
private interface Observable {
    void subscribe(Observer observer);
    void unSubscribe(Observer observer);
    void notifyToEveryOne();
}

private interface Observer {
    void heyDataIsChanged(List data);
}
```


这些事帮助我们实现观察者模式的接口。如果你想了解更多，可以参考[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md)。

如下所示，我创建了一个类来管理数据。

```
private static class Data implements Observable {

    private List<Observer> observers = new ArrayList<>();

    @Override
    public void subscribe(Observer observer) {
        observers.add(observer);
    }

    @Override
    public void unSubscribe(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyToEveryOne() {
        for (Observer observer : observers) {
            observer.heyDataIsChanged(data);
        }
    }

private ArrayList<String> data = new ArrayList<>();

    public Data() {
        data.add("A");
        data.add("B");
        data.add("C");
        data.add("D");
        iterateOnData(data);
    }

    void add(String object) {
        data.add(object);
        notifyToEveryOne();
    }
}
```

代码前半部分，使用了观察者模式的模版。后半部分，代码与数据相关。用数据 （A 到 D）初始化一个数据组打印到控制台。之后往数组里添加数据，就会收到数据变化的通知。 接下来看一下 main 方法。

```
public static void main(String[] args) throws InterruptedException {

    currentDateTime();
    Data data = new Data();
    data.subscribe(observer);

    Thread.sleep(4000);
    currentDateTime();
    data.add("E");
    currentDateTime();
    data.add("F");

    data.unSubscribe(observer);
}
```

Output:

---

Sat Feb 11 10:52:**30** MYT 2017

A

B

C

D

Sat Feb 11 10:52:**34** MYT 2017

A

B

C

D

E

Sat Feb 11 10:52:**34** MYT 2017

A

B

C

D

E

F

Process finished with exit code 0

---

这就是这段代码产生的效果。我准备一起解释一下输出和代码。当 app 跑起来，我创建了一个数据类的对象。我也为数据类增加了一个订阅者。如果数据有更新，它就会通知我。作为一个开发者，我把这个责任交给了观察着。于是我现在自由了，我不再管理所有事情。任何改动，观察者都会告诉我并且我可以立刻采取行动。这对我们非常方便。作为一个开发者，我也会想偷懒的时候，我希望我的代码能发挥最大的效用，这也是我在这里正在做的 :)。在控制台，当代码跑起来，我可以看到数据从 A 到 D 的输出。我的线程休眠 4 秒后，当主线程重新开始工作，它首先添加了一个新数据，所以我的观察者通知我了：“嘿，这里有变动”。之后再一次的数据变动，观察者又通知了我一次。这真是太棒了。你可以说这是响应式的代码，因为只要数据发生改变，响应就会发生。


```
import java.util.*;

/**
 * Created by waleed on 11/02/2017.
 */
public class EntryPoint {

    public static void main(String[] args) throws InterruptedException {

        currentDateTime();
        Data data = new Data();
        data.subscribe(observer);

        Thread.sleep(4000);
        currentDateTime();
        data.add("E");
        currentDateTime();
        data.add("F");

        data.unSubscribe(observer);
    }

    private interface Observable {
        void subscribe(Observer observer);
        void unSubscribe(Observer observer);
        void notifyToEveryOne();
    }

    private interface Observer {
        void heyDataIsChanged(List data);
    }

    private static class Data implements Observable {

        private List<Observer> observers = new ArrayList<>();

        @Override
        public void subscribe(Observer observer) {
            observers.add(observer);
        }

        @Override
        public void unSubscribe(Observer observer) {
            observers.remove(observer);
        }

        @Override
        public void notifyToEveryOne() {
            for (Observer observer : observers) {
                observer.heyDataIsChanged(data);
            }
        }

        private ArrayList<String> data = new ArrayList<>();

        public Data() {
            data.add("A");
            data.add("B");
            data.add("C");
            data.add("D");
            iterateOnData(data);
        }

        void add(String object) {
            data.add(object);
            notifyToEveryOne();
        }

    }

    private static Observer observer = new Observer() {
        @Override
        public void heyDataIsChanged(List data) {
            iterateOnData(data);
        }
    };

    private static void iterateOnData(List data) {
        Iterator iterator = data.iterator();
        while (iterator.hasNext()) {
            System.out.println(iterator.next());
        }
    }

    private static void currentDateTime() {
        System.out.println(new Date(System.currentTimeMillis()).toString());
    }
}
```

这就是推（Push）方法。你很容易就看到数据变动，观察者会通知你。我并没有写任何代码去获取新的改变。我说的是，当你（数据）变了，把改变推送给我。但在我上一个拉（Pull）方法（的代码）里，我总是去询问数据：数据是否有任何变动？数据是否有任何变动？我想拉（Pull）和推（Push）已经清晰了。但是，我准备用回调实现一样的事情。大多数情况下，当我们想从服务器获取数据，会在 API 里使用这种方式。所以我想用回调来实现推（Push）的概念。

**使用回调的方式:**

在回调的方式里，我只创建了一个名叫 Callback 的接口。如果数据类里有任何变动，它会通知我。

```
private interface Callback {
    void dataChanged(List data);
}
```

真的很简单。现在来看看我们的 Data 类。

```
private static class Data {

    private interface Callback {
        void dataChanged(List data);
    }

    private ArrayList<String> data = new ArrayList<>();
    private Callback callback;

    public Data(Callback callback) {
        this.callback = callback;
        data.add("A");
        data.add("B");
        data.add("C");
        data.add("D");
        iterateOnData(data);
    }

    void add(String object) {
        data.add(object);
        callback.dataChanged(data);
    }
}
```


你可以从上面的代码看到，我们是怎样使用回调接口的。让我们来看看主要方法的代码。

```
public static void main(String[] args) throws InterruptedException {

    currentDateTime();
    Data data = new Data(callback);

    Thread.sleep(4000);
    currentDateTime();
    data.add("E");
    currentDateTime();
    data.add("F");
}
```

```
private static Data.Callback callback = new Data.Callback() {
    @Override
    public void dataChanged(List data) {
        iterateOnData(data);
    }
};
```

```
Output:
```

---

Sat Feb 11 11:15:06 MYT 2017

A

B

C

D

Sat Feb 11 11:15:10 MYT 2017

A

B

C

D

E

Sat Feb 11 11:15:10 MYT 2017

A

B

C

D

E

F

Process finished with exit code 0

---

我得到的是跟观察者模式一样的输出。这意味着我可以使用不同的实现方式来应用推（Push）模式。你可以用下面的代码在你们的 IDE 上实践一下。

```
import java.util.*;

/**
 * Created by waleed on 11/02/2017.
 */
public class EntryPoint {

    public static void main(String[] args) throws InterruptedException {

        currentDateTime();
        Data data = new Data(callback);

        Thread.sleep(4000);
        currentDateTime();
        data.add("E");
        currentDateTime();
        data.add("F");

    }

    private static class Data {

        private interface Callback {
            void dataChanged(List data);
        }

        private ArrayList<String> data = new ArrayList<>();
        private Callback callback;

        public Data(Callback callback) {
            this.callback = callback;
            data.add("A");
            data.add("B");
            data.add("C");
            data.add("D");
            iterateOnData(data);
        }

        void add(String object) {
            data.add(object);
            callback.dataChanged(data);
        }

    }

    private static Data.Callback callback = new Data.Callback() {
        @Override
        public void dataChanged(List data) {
            iterateOnData(data);
        }
    };

    private static void iterateOnData(List data) {
        Iterator iterator = data.iterator();
        while (iterator.hasNext()) {
            System.out.println(iterator.next());
        }
    }

    private static void currentDateTime() {
        System.out.println(new Date(System.currentTimeMillis()).toString());
    }
}
```

观察者模式和回调方法有一个区别。在观察者模式中，每个订阅了的人都会通知，而回调方法中，只有一个最后订阅的回调会被通知。在软件开发过程中，我们多用 API 的回调接口来获取结果或者数据。这就是为什么叫做推（Push)模式，因为会把数据变化的状态推送给你。你不负责检查数据的变化。


这里给你一个小贴士，有时我看到人们做得非常复杂。比如，我在我的应用中，有一个 User 对象。当我登录时，我会拿到一个 User 对象。大多数人使用回调，但是他们想在多个类或屏幕中使用那个 User 对象。他们怎么做呢？他们把数据从回调中取出来，扔给 EventBus、广播接收者或者直接保存成静态对象。这是对回调的误用。如果你想同时在其它类或者屏幕中使用从 API 中获取的数据，如果你不用 Rx，那就一定要用观察者模式 :)。你的代码会变得简单和稳定。

**结论:**

现在你们知道了 Rx 的核心概念其实就是观察者模式。在我们讨论了两种策略，观察者模式和回调来达到推（Push）模式之后，我们接下来会讨论拉（Pull）模式和推（Push）模式以及命令式和响应式的困惑。是时候使用 Rx 来达到同样的效果了。我们已经知道我们利用 Rx 来避免样板代码，利用 Rx 的优势有多简单了。我想今天就差不多了。试着自己写代码练习一下。这会帮助你理解这些概念。从下一篇开始，我们很可能开始学习 Lambda 表达式以及函数式编程。这些是非常重要的的东西，会让 Rx 的学习曲线变简单。

谢谢你们的阅读。祝你们有个愉快的周末，再见 :)。
