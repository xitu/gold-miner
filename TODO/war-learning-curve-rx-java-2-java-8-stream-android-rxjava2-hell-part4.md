> * 原文地址：[War against Learning Curve of Rx Java 2 + Java 8 Stream [ Android RxJava2 ] ( What the hell is this ) Part4](http://www.uwanttolearn.com/android/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：


## War against Learning Curve of Rx Java 2 + Java 8 Stream [ Android RxJava2 ] ( What the hell is this ) Part4 ##



WOW, we got one more day so its time to make this day awesome by learning something new .

Hello guys, hope you are doing good. This is our fourth post in series of RxJava2 Android [ [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/), [part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/), [part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/) ]. Good news is at last we are ready to start work with Rx. We already completed our prerequisites. I will use Java 8 streams for reactiveness before using Rx Java 2 Android Observables. I think we should know Java 8 and I have a feeling by using Java 8 stream API’s, learning curve of Rx Java 2 Android will be more easy.

**Motivation:**

Motivation is same which I share with you in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/). When I started Rx Java 2 Android at that time I don’t know how and where I will use Rx Java Android.

Now we know prerequisites but at that time I don’t know anything. So at that time first I started, how to create a Observable from any data or object. Then I learned about which interfaces or may be I can say callbacks called when some thing happen in Observable data. That is going good theoretically but the day when I start working with Rx practically. I am gone. I saw lot of marble diagrams which make sense theoretically but when I try to use, nothing make sense for me :). Biggest issue for me, I am not able to make my thinking as Reactive or Functional Reactive. My background is working with Imperative and OOP languages so that it is difficult for me. I am always asking these questions. Where I will implement and how I will implement. In this post if you follow I can give you 100% guarantee. You will know. How convert imperative code into Rx not optimised but you will know where to start.

**Revision:**

I want to revise all those concepts which we already learn in first three posts[ [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/), [part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/), [part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/) ] . Because today we will use all these concepts. In [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/) we learned Observer Pattern. In [part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/) we learned Pull vs Push & Imperative vs Reactive. In [part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/) we learned Functional Interfaces, Default Methods, Higher Order Functions, Side Effects in Functions, Pure Functions, Lambda Expression and Functional Programming. I am going to write (boring material) there definitions. If you already remembered you can skip next part.
*Functional Interface is an interface having one abstract method*.
*In Java 8 we can define methods in interface these are called Default Methods.*
*A function with at least one parameter of type function or a function that returns function is called a Higher Order Function*.
*Pure Function is a function, where the return value is only determined by its input values, without observable side effects.*
*Lambda expression in computer programming, also called anonymous function, a function (or a subroutine) defined, and possibly called, without being bound to an identifier.*

**Introduction:**

Today we are going to declare a war against Rx Java learning curve. In the end I am 100% sure we will won.

War Strategy:

1. Java 8 Stream ( That give us a very fast start + we know Java 8 as Android Developer )

2. Java 8 Stream to Rx Observable

3. Rx Java 2 Android Example

4. Tips, how convert imperative code to Rx Java 2 Android code

Its time to do a ATTACK according to our strategy. Solders ATTACK.

**1. Java 8 Stream:**

Currently I am using IntelliJ IDE for Java 8 stream. May be you are thinking why I am going to use Java 8 stream which we are not able to use in Android. All those solders who are thinking like this. I am using Java 8 stream due to two reasons. First I know after some years Java 8 is a first class citizen for Android development. So you should know this stream API’s also any body can ask you in interview. Then Java 8 stream is same like Rx Observable in  perspective of concept. So why not we learn both things in a one go. Second I have a feeling lot of solders who are like me dump or lazy or not able to grasp concept very easily they will get that concept in minutes. Again I am giving you 100% guarantee. By learning Java 8 stream you will learn Rx in minutes. Its time to start.

Stream:

Classes to support functional-style operations on streams of elements, such as map-reduce transformations on collections (*docs.oracle*).

First question. What is a stream in english language?

Answer: a small, narrow river. Or a continuous flow of liquid, air, or gas.

In programming I want to convert my data in the form of stream. Its mean if I have a string but I want to do a work with that as a stream what I need to do. I need to create a mechanism in which I will get my data according to definition “a continuous flow of liquid, air, or gas {**or data**}”. Now question is why I want my data as a stream. Hmm I am giving you one dump example.

I have a blue colour water in a glass with mixup of small and big stones as shown below. (Sorry for drawing skills  )

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_1-300x253.jpg) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_1.jpg)

Now according to our stream definition. I am going to convert that water into stream as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_2-237x300.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_2.jpg)

I shifted my water from one glass to another by converting into stream. Now I want to remove all big stones from my water. So now I am going to make a one filter which will help me to remove these big stones. Big stone filter as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_3-300x252.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_3.jpg)

Now I am going to apply that filter on my water stream. So I will get water without big stones as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_4-204x300.jpeg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_4.jpeg)

Hurray. Next I want to clean my water from both small and big stones. For that I have big stone filter but I need to create a new filter for small stones. Small stone filter as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_5-300x229.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_5.jpg)

Its time to apply both filters on my water stream as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_6-228x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_6.png)

Wow. I have a feeling now you guys are getting my point what type of benefit we can get from stream in programming. Next I want to change my colour from blue to black. For that I need to create a water colour converter (mapper) as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_7-300x171.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_7.jpg)

Its time to implement that converter with my filters as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_8-214x300.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_8.jpg)

Now by converting my water into stream I did a lot of things. I remove big stones using filter, small stone by using filter and in the end I converted my water colour from blue to black using converter (map).

This is the same benefit I will get in our programming when I will convert my data into stream. But now I am going to convert our this example into code. The code now I am going to show you is real code. May be this will not work in example but operator and API’s which I am going to use are real which we will use in later real example. So guys focus on concepts not on compilation. By doing this example I have a feeling we will grasp the concepts very easily. One important point I am using Java 8 stream API in this example not Rx API’s. I don’t want to make things difficult but later I will use Rx also.

Image Water + Water in code:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_1-300x253.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_1.jpg)

```
public static void main(String [] args){
    Water water = new Water("water",10, "big stone", 1 , "small stone", 3);
    // 10 litre water with 1 big and 3 small stones.
    for (String s : water) {
        System.out.println(s);
    }
}
```

Output:

water

water

big stone

water

water

small stone

water

small stone

small stone

water

water

water

water

water

Image Water stream + Water stream in code:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_2-237x300.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_2.jpg)

```
public static void main(String[] args) {
    Water water = new Water("water", 10, "big stone", 1, "small stone", 3);
    // 10 litre water with 1 big and 3 small stones.
    water.stream();
}

Output will be same as above one.
```

Image big stone filter + big stone filter in code:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_3-300x252.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_3.jpg)

Guys need your attention here.

Here in Java 8 Stream we have a one Functional Interface its name is called Predicate. So when I want to do a filter I need to give this Functional Interface to stream filter function. Now I am going to show you how I will create a BigStoneFilter in our code.

```
private static Predicate<String> BigStoneFilter  = new Predicate<String>() {
    @Override
    public boolean test(String s) {
        return !s.equals("big stone");
    }
};
```

As we already know in [part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/) any Functional Interface can be convert into Lambda expression. So going to convert this code into Lambda Expression.

```
private static Predicate<String> BigStoneFilter  = s -> !s.equals("big stone");
```

Image big stone filter on Water stream + in code.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_4-204x300.jpeg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_4.jpeg)

```
public static void main(String[] args) {
    Water water = new Water("water", 10, "big stone", 1, "small stone", 3);
    water.stream().filter(BigStoneFilter)
    .forEach(s-> System.out.println(s));

}

private static Predicate<String> BigStoneFilter  = s -> !s.equals("big stone");
```

Here I am using forEach method. For the time being take this function as a for loop on a stream. I am using here only to show you output. Otherwise without this function we already achieved what we are showing in image. Now its time to show you output.

water

water

water

water

small stone

water

small stone

small stone

water

water

water

water

water

There is no big stone. Its mean we filter our water sucessfully.

Image Small stone filter + small stone filter in code:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_5-300x229.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_5.jpg)

```
private static Predicate<String> SmallStoneFilter  = s -> !s.equals("small stone");
```

Appending small stone filter on Water stream + in code.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_6-228x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_6.png)

```
public static void main(String[] args) {
    Water water = new Water("water", 10, "big stone", 1, "small stone", 3);
    water.stream()
            .filter(BigStoneFilter)
            .filter(SmallStoneFilter)
    .forEach(s-> System.out.println(s));
}

private static Predicate<String> BigStoneFilter  = s -> !s.equals("big stone");
private static Predicate<String> SmallStoneFilter  = s -> !s.equals("small stone");
```

I am not going to explain **SmallStoneFilter**. Implementation is just like **BigStoneFilter**. Only here I am going to show you output.

water

water

water

water

water

water

water

water

water

water

Image Water colour converter + water colour converter in code:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_7-300x171.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_7.jpg)

Guys need your attention here.

Here in Java 8 Stream we have a one Functional Interface its name is called Function. So when I want to do a conversion I need to give this Functional Interface to a stream map function. Now I am going to show you how I will create a Water colour converter in our code.

```
private static Function<String, String > convertWaterColour = new Function<String, String>() {
    @Override
    public String apply(String s) {
        return s+" black";
    }
};
```

That is a functional interface. So I can convert into lambda.

```
private static Function<String, String > convertWaterColour = s -> s+" black";
```

Basically first String in Function <generic> is the value which I will get from water and second String in Function <generic> means what I am returning. For more clarification I am writing one converter which will convert integer into String.

```
private static Function<Integer, String > convertIntegerIntoString = i -> i+" ";
```

Coming back to our original example.

Image appending water colour converter on Water stream + in code.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_8-214x300.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_8.jpg)

```
public static void main(String[] args) {
    Water water = new Water("water", 10, "big stone", 1, "small stone", 3);
    water.stream()
            .filter(BigStoneFilter)
            .filter(SmallStoneFilter)
            .map(convertWaterColour)
            .forEach(s -> System.out.println(s));
}

private static Predicate<String> BigStoneFilter = s -> !s.equals("big stone");
private static Predicate<String> SmallStoneFilter = s -> !s.equals("small stone");
private static Function<String, String> convertWaterColour = s -> s + " black";
```

Output:

water black

water black

water black

water black

water black

water black

water black

water black

water black

water black

Done. Now I am going to revise some things again.

filter: In stream we have a method. Which always take a Functional Interface is called Predicate. In which we will write our logic, which will be apply on our data.

map: In stream we have a method.Which always take a Functional Interface is called Function. In which we will write our logic to convert our data according to our requirement.

Before going to next topic. I am going to explain you one more thing which confuse me a lot. Like when I say stream() on any data how that work. So for that I am going to take a one example. I have a list of integers. I want to show that on console.

```
public static void main(String [] args){
    List<Integer> list = new ArrayList<>();
    list.add(1);
    list.add(2);
    list.add(3);
    list.add(4);
}
```

Using imperative approach data shown on console:

```
public static void main(String [] args){
    List<Integer> list = new ArrayList<>();
    list.add(1);
    list.add(2);
    list.add(3);
    list.add(4);

    for (Integer integer : list) {        
	    System.out.println(integer);   
	    
	 }
}
```

Using Stream or Rx approach data shown on console:

```
public static void main(String [] args){
    List<Integer> list = new ArrayList<>();
    list.add(1);
    list.add(2);
    list.add(3);
    list.add(4);

    list.stream().forEach(integer -> System.out.println(integer));

}
```

Now if you compare both codes. What is the difference?

In simple words in first code. I am managing for loop on my own.

```
for (Integer integer : list) {
        System.out.println(integer);
    }
```

but in second example stream (or later I will show you Observable in Rx) will taking care of my loop.

```
list.stream().forEach(integer -> System.out.println(integer));
```

I think lot of things are clear its time to go on a real example by using Rx. In this example I will show you stream code and Rx code both together so you can easily grasp the concept in both domains.

**2. Java 8 Stream to Rx Observable:**

I have a list which contain data “Hello World”. In images I am taking as a String but In code example I am going to take as a List which is easy to explain on this point.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_9-300x258.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_9.jpg)

In code Java 8 Streams:

```
public static void main(String [] args){

    List<String> list = new ArrayList<>();
    list.add("H");
    list.add("e");
    list.add("l");
    list.add("l");
    list.add("o");
    list.add(" ");
    list.add("W");
    list.add("o");
    list.add("r");
    list.add("l");
    list.add("d");
    list.stream(); // Java 8
}

```

In Android:

```
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        List<String> list = new ArrayList<>();
        list.add("H");
        list.add("e");
        list.add("l");
        list.add("l");
        list.add("o");
        list.add(" ");
        list.add("W");
        list.add("o");
        list.add("r");
        list.add("l");
        list.add("d");

        Observable.fromIterable(list);
                
    }
}
```

Guys here I am showing you both Java 8 and Android code. From now I will show you only Reactive code from Java 8 and Android not all class code. In the end of the blog post I will share with you code.

Again above example:

```
list.stream(); // Java 8

Observable.fromIterable(list); // Android
```

So both will give you same result. Now I am going to output integer list.

```
list.stream()
       .forEach(s-> System.out.print(s)); // Java 8

Observable.fromIterable(list)
        .forEach(s-> Log.i("Android",s)); // Android

Output in Java 8:
     Hello World
Output In Android:
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: H
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: e
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: l
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: l
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: o
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: 
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: W
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: o
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: r
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: l
03-12 15:55:33.561 6094-6094/async.waleed.rx I/Android: d
```

Now its time to compare both.

```
list.stream().forEach(s-> System.out.print(s)); // Java 8

Observable.fromIterable(list).forEach(s-> Log.i("Android",s)); // Android
```

So in Java 8 any thing I want as a stream. I will use a stream API but in Android I will convert that data into Observable and will get data as stream.

Next we need to do a filter Hello World data by ‘l’ like as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_10-300x263.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_10.jpg)[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_11-300x282.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_11.jpg)In code:

```
list.stream()
        .filter(s -> !s.equals("l"))
        .forEach(s-> System.out.print(s)); //Java 8

Observable.fromIterable(list)
        .filter(s->!s.equals("l"))
        .forEach(s-> Log.i("Android",s)); // Android

Output in Java 8: 
     Heo Word

Output In Android:
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: H
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: e
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: o
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: 
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: W
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: o
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: r
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: d
```

Good. Now its time to say bye to Java 8 Stream API.


**3. Rx Java 2 Android Example:**

I have a one array of Integers. I want to take a square of all members of this array.

In image form as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_12-288x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_12.png)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_13-300x275.jpeg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_13.jpeg)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_14-300x296.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_14.jpg)

In Android:

```
@Override
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);

    Integer[] data = {1,2,3,4};

    Observable.fromArray(data)
            .map(value->value*value)
            .forEach(value-> Log.i("Android",value+""));
}

```

Output:

03-12 16:13:32.432 14918-14918/async.waleed.rx I/Android: 1

03-12 16:13:32.432 14918-14918/async.waleed.rx I/Android: 4

03-12 16:13:32.432 14918-14918/async.waleed.rx I/Android: 9

03-12 16:13:32.432 14918-14918/async.waleed.rx I/Android: 16

```
.map(value->value*value)
```

That is really simple. Same concept which we already used. I gave a one Functional Interface into map. Which basically doing square of the given value and return that square value.

```
.forEach(value-> Log.i("Android",value+""));
```

As we know we only can show String in logs. So I converted value integer into String by appending +”” as shown above.

Wow. I can see one more use of map in my example. Guys as you know I am converting my integer into String for showing into Logcat. But now I am going to write a one more Functional Interface for map. Which will convert my integer into String. So its mean no need to append +”” as shown below.

```
Observable.fromArray(data)
        .map(value->value*value)
        .map(value-> Integer.toString(value))
        .forEach(string-> Log.i("Android",string));
```

**4. How convert imperative code to Rx Java 2 Android code:**

Here I am going to use a one real world app imperative code block which I will convert into Reactive using Rx Observable. So you can easily know how you can start with Rx in your project. Important point that may be not good approach but you should start so you feel comfortable. I also know I am using some functions like fromArray, fromIterable which I never explained. So for that please try to use as how I am using in examples. I will explain in detail when I will publish my  next post of Rx Android. Try to do a hands on practice a lot.

Example:

In one of my project. I am using [OnBoarding](https://www.google.com/search?q=onboarding+ui&amp;rlz=1C5CHFA_enMY704MY704&amp;espv=2&amp;tbm=isch&amp;tbo=u&amp;source=univ&amp;sa=X&amp;ved=0ahUKEwjqtsPv0tDSAhWLybwKHdLMDhcQsAQINg&amp;biw=1280&amp;bih=682) screen. According to UI I need to show dots on my all OnBoarding screens like shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_15-300x287.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_15.jpg)If you saw carefully in image. In ViewPager I need to give black solid dot to the selected screen.

In Imperative code:

```
private void setDots(int position) {
    for (int i = 0; i < mCircleImageViews.length; i++) {
        if (i == position)
            mCircleImageViews[i].setImageResource(R.drawable.white_circle_solid_on_boarding);
        else
            mCircleImageViews[i].setImageResource(R.drawable.white_circle_outline_on_boarding);
    }
}
```

In Rx:

```
public void setDots(int position) {

    Observable.fromIterable(circleImageViews)
            .subscribe(imageView ->
                    imageView.setImageResource(R.drawable.white_circle_outline_on_boarding));
    circleImageViews.get(position)
            .setImageResource(R.drawable.white_circle_solid_on_boarding);

}
```

In this setDots function. Basically I am going through from every Image and setting a white empty circle and after that I am setting again solid circle on the selected ImageView.

OR

```
public void setDots(int position) {

        Observable.range(0, circleImageViews.size())
                .filter(i->i!=position)
                .subscribe(i->circleImageViews.get(i).setImageResource(R.drawable.white_circle_outline_on_boarding)));
        circleImageViews.get(position)
                .setImageResource(R.drawable.white_circle_solid_on_boarding);
}
```

In this setDots function. I set to all Imageviews white empty circle except the one which is a selected one.

Later I set the solid circle for the selected Imageview.

**4. Tips how convert imperative code to Rx code:**

I am going to write some tips. So you can start work with Rx easily in your current code.

1. If we have any loop in code convert that loop into Observable.

```
for (int i = 0; i < 10; i++) {

}

to

Observable.range(0,10);
```

2. If we have any if condition in imperative code replaced with filter in Rx.

```
for (int i = 0; i < 10; i++) {
    if(i%2==0){
        Log.i("Android", "Even");
    }
}

to

Observable.range(0,10)
        .filter(i->i%2==0)
        .subscribe(value->Log.i("Android","Event :"+value));
```

3. If we need to transformed some data form into another data form. I can do that by using map.

```
public class User {
    String username;
    boolean status;

    public User(String username, boolean status) {
        this.username = username;
        this.status = status;
    }
}

List<User> users = new ArrayList<>();
users.add(new User("A",false));
users.add(new User("B",true));
users.add(new User("C",true));
users.add(new User("D",false));
users.add(new User("E",false));

for (User user : users) {
    if(user.status){
        user.username = user.username+ "Online";
    }else {
        user.username = user.username+ "Offline";
    }
}
```

In Rx there are lot of ways to achieve above code.

By using two streams.

```
Observable.fromIterable(users)
        .filter(user -> user.status)
        .map(user -> user.username + " Online")
        .subscribe(user -> Log.i("Android", user.toString()));
Observable.fromIterable(users)
        .filter(user -> !user.status)
        .map(user -> user.username + " Offline")
        .subscribe(user -> Log.i("Android", user.toString()));
```

By using If else in map:

```
Observable.fromIterable(users)
        .map(user -> {
            if (user.status) {
                user.username = user.username + " Online";
            } else {
                user.username = user.username + " Offline";
            }
            return user;
        })
        .subscribe(user -> Log.i("Android", user.toString()));
```

4. If we have some nested loops in our code.

```
for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        System.out.print("j ");
    }
    System.out.println("i");
}

to

Observable.range(0, 10)
        .doAfterNext(i-> System.out.println("i"))
        .flatMap(integer -> Observable.range(0, 10))
        .doOnNext(i -> System.out.print("j "))
        .subscribe();
```

Here I used one new operator flatMap. Only try to use in a same way how I used in my example. I will explain that in next post.

**Conclusion:**

Good work solders. Today we try to make our self comfortable with Rx Android. We started from diagrams, then we used Java 8 stream API’s. Later we converted Java 8 stream to Rx Java 2 Android Observable. Then we try to saw some real world examples where I show you, how you can start work with Rx in your existing project. In the end I gave you some tips how to convert loop into Rx, if into filter, data transformation using map, nested loop converted by using flatMap. Next post [Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part5](http://www.uwanttolearn.com/android/dialogue-rx-observable-developer-android-rxjava2-hell-part5/).

Hope you enjoy. OK guys BYE BYE.

Codes:

1. [Water Stream Example
](https://gist.github.com/Hafiz-Waleed-Hussain/c4d17174af9881c57f0e1ce676fede2d)
2. [HelloWorldStream using Java 8 sStream API
](https://gist.github.com/Hafiz-Waleed-Hussain/9f55be929eb0f5e1956e75ac41876a3b)
3. [HelloWorldStream using Rx Java2 Android](https://gist.github.com/Hafiz-Waleed-Hussain/509a32acad909ac1e90b2f83fb4dde5a) | [project level gradle](https://gist.github.com/Hafiz-Waleed-Hussain/57d2708607da67867d9bed7ba9882f5c) | [app level gradle
](https://gist.github.com/Hafiz-Waleed-Hussain/2afd1e597fdc0c204a4adb1b43c165eb)
4. [ArrayOfIntegers using Rx Java2 Android](https://gist.github.com/Hafiz-Waleed-Hussain/a3acd794e4942f296531018bdcad2a23) | [project level gradle](https://gist.github.com/Hafiz-Waleed-Hussain/57d2708607da67867d9bed7ba9882f5c) | [app level gradle](https://gist.github.com/Hafiz-Waleed-Hussain/2afd1e597fdc0c204a4adb1b43c165eb)

For all other examples you can use the same snippets from post.

 
