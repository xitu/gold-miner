> * 原文地址：[Pull vs Push & Imperative vs Reactive – Reactive Programming [Android RxJava2] ( What the hell is this ) Part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

## Pull vs Push & Imperative vs Reactive – Reactive Programming [Android RxJava2] ( What the hell is this ) Part2 ##

WOW, we got one more day so its time to make this day awesome by learning something new 🙂.

Hello Guys, hope you are doing good. This is our second part of Rx Java Android series. In this I am going to discuss about next biggest confusion about Push vs Pull or Push vs Iterative pattern and Imperative vs Reactive.

**Motivation:** 

Motivation is same which I share with you in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/).  Lot of time I confused, when I got examples like we have a Iterative pattern (Pull) which have hasNext(), next() just like same but vice versa we have in Rx. In a same way I got lot of examples which confuse me about imperative and Reactive.

**Revision:**

In [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/) we discuss the most important, basic and core concept of Rx and that is a Observer Pattern. Any where in program, I want to know about data change. I always use Observer Pattern. Like we saw in our last post, Email notification example. We need to grasp this concept. This is really important, if you know this one, all other things are function calls on data like map, filter, etc in Rx.

**Introduction:**

Today I am going to remove the confusions about what is Pull vs Push in Rx and What is Imperative vs Reactive. So Pull vs Push have nothing with Rx. Basically that is a comparison between two techniques or strategies. Mostly we use Pull strategy in our code but we can convert that Pull to Push using Rx. Which gave us a lot of benefits. In a same way Imperative vs Reactive both are programming paradigm. Mostly the code we right in Java Android that is imperative and where we are going that is Reactive. First I am going to explain Imperative vs Reactive traditional example which we will get every where but later I will use this example as a concept. So try to remember this example.

**Imperative Approach:**

```
int val1 = 10;
int val2 = 20;
int sum = val1 + val2;
System.out.println(sum); // 30
val1 = 5;
System.out.println(sum); // 30
```

In imperative approach. As I changed val1 = 5 after sum. There is no impact on sum. Sum is same 30.

**Reactive Approach:**

```
int val1 = 10;
int val2 = 20;
int sum = val1 + val2;
System.out.println(sum); // 30
val1 = 5;
System.out.println(sum); // 25
```

In reactive approach. As I changed val1 = 5 after sum. Sum will be changed to 25 like that call again sum=val1 + val2 under the hood.

So I want you guys should remember the main concept of Imperative vs Reactive.

Now Its time to review a one traditional example for Pull vs Push.

I have a some data as shown below.

```
private static ArrayList<String > data = new ArrayList<>();
    data.add("A");
    data.add("B");
    data.add("C");
    data.add("D");

```

Now I am going to playing with this data. First I want to traverse this data on console.

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


Basically that is a Pull approach. Now sharing my personal confusion which mostly I got due to lack of knowledge. How this is Pull approach. So imagine after traverse I added two new data objects but I am not going to traverse my data again. Its mean in my program I never know there is any new data just like as shown below.

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

So Pull In simple words, as a developer that is my duty to check, is data changed and if yes I will take next decision according to that change. Just like above, I want to do a traverse again if there is any data change later. Guys that is also an Imperative approach.

Now I am going to implement our original requirement by using Pull approach but before that I am writing some code below which are some helper methods. So do not confuse If I call these method in our main program.

```
private static void currentDateTime() {
    System.out.println(new Date(System.currentTimeMillis()).toString());
}
```

Above method only show current date and time on console.

```
private static void iterateOnData(List data) {
    Iterator iterator = data.iterator();
    while (iterator.hasNext()) {
        System.out.println(iterator.next());
    }
}
```

Above method only printout a whole list on console.

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

Above method is important. Now as a developer I implemented my Pull approach by using polling. So What I am doing now. This method call after every 1s or 1000ms. Now when this will run first time. I will check is there any change in data. If yes then show data on console other wise show no change in data.

Its time to check our main method.

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

Now what is happening. I am going to explain output and code both together. When app runs. On console I got time and our data as traverse due to polling because polling method run first time immediate and after that it always run periodically after 1s. So when that immediate run I can see my data from A to D. After that in main method I apply sleep on my main thread for 4s but you can see easily in our output due to polling method, every after 1s I can see “no change in data” as output. After 4 seconds our main thread again start working. Now I added two new data objects and after 1s when polling call. I can see new output on my screen from A to F. Again that is imperative approach.

All code together so you can also run on your IDE.

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

Now I have a feeling some confusion will be removed what is Pull approach. The biggest issue in this approach, developer needs to write a lot of code to manage every thing. So what I can do to manage this requirement, without going into polling or pull approach. We can use Observer pattern to manage that thing just like we did in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/). But that is a lot of boiler plate code which developers need to write again and again. Here we can get a benefit from Rx library without writing a lot of Observer pattern boilerplate code but currently I am not going to start Rx. First we will grasp the other concepts without Rx. So I am going to make my code Push based without using Rx. So concept will be clear what is Pull vs Push.

Before start I think we discuss what is the difference between Pull and Push in simple language. Pull means as a developer I am responsible for everything. Like I want to know any change in data I want to ask. Hey any new change. Which is difficult to maintain because lot of threading start in program and due to little lazy ness of a developer our program start memory leaks.

In Push approach developer only write simple code and give orders to data. Hey if any change in you inform me. That is a push approach. I am going to take same example to explain this approach. First I will use Observer pattern to achieve this approach and later I will show you by using Callback.

**By using Observer Pattern:**

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

These are the interfaces which help us to implement Observer Pattern. If you want to learn more about this please refer to [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/).

I created my own class to manage data like shown below.

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

In start I have some boilerplate code for Observer Pattern. In the second half I have code related to data. I have an array which I initialise with some data (A to D) and print on console. After that I have a one method which adds a new data in our array. Also that will inform to every one about data change. Its time to show you main method.

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

Now what is happening. I am going to explain output and code both together. When app runs. I created an object of my data class. Also I subscribe one observer to that data class. If any new change in data, that will inform me. Here as a developer I gave that duty to observer. So now I am free I am not managing any thing. Any change will happen observer will inform me and I will take decision at that time. Its really easy to save our side. As a developer I am lazy I want to take maximum work from code, which I am doing here :). On console as I run I will see output with data from A to D. Later my main thread sleep for 4 seconds, as main thread start work again first he adds a new data so my observer inform me hey there is some change and later again he adds new data so observer inform me again. That is awesome. You can say that is reactive because any time when data change reaction occurs.

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

This is push approach. You can easily see any time data change, observer will inform you. I am not writing any code to know about any new change. I am saying data when you change then push me that change but before that in my last Pull approach, I am always asking to data. Is there any change data? Is there any change data? I think Pull vs Push concepts are clear but I am going to implement same thing by using Callback. Mostly we use this approach in our API’s when we want some data from Server. So I am going to achieve this same Push concept by using Callback.

**By using Callback Approach:**

In Callback approach I only created a new Interface with name Callback. Which will inform me if any data is changed in my Data class.

```
private interface Callback {
    void dataChanged(List data);
}
```

Really simple. Its time to see our Data class.

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

You can see easily. How we are using this Callback interface in above code. Its time to show you main method code.

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

Same output which I got from Observer Pattern. Its mean I can apply Push approach by using different implementation. You can run below code for practice on your IDE.

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

There is one difference between Observer Pattern and Callback approach. In Observer Pattern every body who subscribe will inform but in Callback only one Callback will be informed, which subscribed in last. In our software development when we are using API’s mostly we use Callback interfaces to get result or data. That is Push approach because data will be pushed to you. You are not responsible to check any change in data.

One tip, sometimes I saw people do things in a very complex way. Like I have a User object in my app. So when I do a login I will get a User object in response. Mostly people use Callback for that but they want to share that User data to many classes or screens. What they do, they take that data in Callback and later they share by using EventBuses, Broadcast Receivers or save in static objects. Which is a wrong use of Callback. If you want data from API’s which will be shared with more then one screens or classes on same time, always use Observer Pattern if you are not using Rx :). Your code will be very simple and stable.

**Conclusion:**

So guys now we know the core concept of Rx that is Observer Pattern. Later we discuss Pull vs Push and Imperative vs Reactive confusion, after that we discuss two strategies to achieve Push approach using Observer Pattern and Callback. Its time to achieve same behaviour by using Rx. So we know how easily we can get by using Rx without boilerplate code + new power which we get from Rx. For today I think that is enough. Try to write code on your own for practice. That will help you out to grasp these concepts. From next post most probably we will start about Lambda expressions and Functional Programming. These are really important things to make Rx learning curve simple.

Thanks guys for reading. Have a nice WEEKEND BYE BYE :).

