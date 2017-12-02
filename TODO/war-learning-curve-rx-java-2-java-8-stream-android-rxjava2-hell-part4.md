> * 原文地址：[War against Learning Curve of RxJava2 + Java8 Stream [ Android RxJava2 ] ( What the hell is this ) Part4](http://www.uwanttolearn.com/android/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [Boiler Yao](https://github.com/boileryao)
> * 校对者： [Vivienmm](https://github.com/Vivienmm)、[GitFuture](https://github.com/GitFuture)


## 大战 RxJava2 和 Java8 Stream [ Android RxJava2 ] （这到底是什么） 第四部分 ##



又是新的一天，如果学点新东西，这一天一定会很酷炫。

小伙伴们一切顺利啊，这是我们的 RxJava2 Android 系列的第四部分 [ [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2.md)， [第二部分](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/)， [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3.md) ]。 好消息是我们已经做好准备，可以开始使用 Rx 了。在使用 RxJava2 Android Observable 之前，我会先用 Java8 的 Stream 来做响应式编程。我认为我们应该了解 Java8，而且通过使用 Java8 的 Stream API 让我感觉学习 RxJava2 Android 的过程更简单。
**动机：**

动机跟我在 [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2.md) 和大家分享过的一样。在我开始学习 RxJava2 Android 的时候，我并不知道自己会在什么地方，以何种方式使用到它。

现在我们已经学会了一些预备知识，但当时我什么都不懂。因此我开始学习如何根据数据或对象创建 Observable 。然后知道了当 Observable 的数据发生变化时，应该调用哪些接口（或者可以叫做“回调”）。这在理论上很好，但是当我付诸实践的时候，却 GG 了。我发现很多理论上应该成立的模式在我去用的时候完全不起作用。对我来说最大的问题，是不能用响应或者函数式响应的思维思考问题。我熟悉命令式编程和面向对象编程，由于先入为主，所以对我来说理解响应式会有些难。我一直在问这些问题：我该在哪里实现？我应该怎么实现？如果你能坚持看完这篇文章，我可以 100% 保证你会知道怎样把命令式代码转换成 Rx 代码，虽然写出来的 Rx 代码不是最好的，但至少你知道该从哪里入手了。

**回顾：**

我想回顾之前三篇文章中我们提到过的所有概念 [ [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2.md)、[第二部分](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/)、 [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3.md) ]。因为现在我们要用到这些概念了。在 [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2.md) 我们学习了观察者模式； 在 [第二部分](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/) 学习了拉模式和推模式、命令式和响应式；在 [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3.md) 我们学习了函数式接口（Functional Interfaces）、 接口默认方法（Default Methods）、高阶函数（Higher Order Functions）、函数的副作用（Side Effects in Functions）、纯函数（Pure Functions）、Lambda 表达式和函数式编程。我在下面写了一些定义（很无聊的东西）。如果你清楚这些定义，可以跳到下一部分。
**函数式接口是只有一个抽象方法的接口。**
**在 Java8 我们可以在接口中定义方法，这种方法叫做“默认方法”。**
**至少有一个参数是函数的函数和返回类型为函数的函数称为高阶函数。**
**纯函数的返回值仅仅由参数决定，不会产生可见的副作用（比如修改一些影响程序状态的值。——译注）。**
**Lambda 表达式在计算机编程中又叫做匿名函数，是一种在声明和执行的时候不会跟标识符绑定的函数或者子程序。**

**简介：**

今天我们将向 RxJava 的学习宣战。我确定在最后我们会取得胜利。

作战策略：

1. Java8 Stream（这使得我们快速开始，我们将从 Android 开发者的角度来看）

2. Java8 Stream 向 Rx Observable 转变

3. RxJava2 Android 示例

4. 技巧，怎样把命令式代码转为 RxJava2 Android 代码

是时候根据我们的策略发动进攻了，兄弟们上。

**1. Java8 Stream:**

现在我用 IntelliJ 这个 IDE 来写 Java8 的 Stream。你可能会想为什么我去使用在 Android 不支持的 Java8 的 Stream。对于这样想的同志，我来解释一下。主要有两个原因。首先，我知道几年后 Java8 将成为 Android 开发的一等公民。所以你应该了解关于 Stream 的 API，并且在面试中你可能被问到。而且，Java8 的 Stream 和 Rx Observable 在概念上很像。所以，为什么不一次性把这两个东西一起学了呢？其次，我感觉很多像我一样能力低下、懒惰并且不容易掌握概念的同志也可以在几分钟内了解这个概念。再次强调，我向你们 100% 地保证。通过学习 Java8 的 Stream 可以让你很快地学会 Rx。好，我们开始了。

Stream:

支持在元素形成的流上进行函数式操作（比如在集合上进行的 map-reduce 变换）的类(*docs.oracle*)。

第一个问题：在英语中 Stream 是什么意思？

答案：一条很窄的小河，或者源源不断流动的液体、空气、气体。在编程的时候把数据转化成“流”的形式，比如我有一个字符串，但是我想把它变成“流”来使用的话我需要干些什么，我需要创建一个机制，使这个字符串满足“源源不断流动的液体、空气、气体 {**或者数据**}”的定义。问题是，我们为什么想要自己的数据变成“流”呢，下面是个简单的例子。

就像下面这幅图中画的那样，我有一杯混合着大大小小石子的蓝色的水。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_1-300x253.jpg) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_1.jpg)

现在按照我们关于“流”的定义，我用下图中的方法将水转化成“流”。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_2-237x300.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_2.jpg)

为了让水变成水流，我把水从一个杯子倒进另一个杯子 里。现在我想去掉水中的大石子，所以我造了一个可以帮我滤掉大石子的过滤器。“大石子过滤器”如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_3-300x252.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_3.jpg)

现在，将这个过滤器作用在水流上，这会得到不包含大石子的水。如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_4-204x300.jpeg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_4.jpeg)

哈哈哈。 接下来，我想从水中清除掉所有石子。已经有一个过滤大石子的过滤器了，我们需要造一个新的来过滤小石子。“小石子过滤器”如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_5-300x229.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_5.jpg)

像下图这样，将两个过滤器同时作用于水流上。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_6-228x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_6.png)

哇哦~ 我已经感觉到你们领悟了我说的在编程中使用流所带来的好处是什么了。接下来，我想把水的颜色从蓝色变成黑色。为了达到这个目的，我需要造一个像下图这样的“水颜色转换器（mapper）”。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_7-300x171.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_7.jpg)

像下图这样使用这个转换器。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_8-214x300.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_8.jpg)

把水转换成水流后，我们做了很多事情。我先用一个过滤器去掉了大石子，然后用另一个过滤器去掉了小石子， 最后用一个转换器（map）把水的颜色从蓝色变成黑色。

当我将数据转换成流时，我将在编程中得到同样的好处。现在，我将把这个例子转换成代码。我要显示的代码是真正的代码。可能示例代码不能工作，但我将要使用的操作符和 API 是真实的，我们将在后面的实例中使用。所以，同志们不要把关注点放在编译上。通过这个例子，我有一种感觉，我们将很容易地把握这些概念。在这个例子中，重要的一点是，我使用 Java8 的 Stream API 而不是 Rx API。我不想让事情变困难，但稍后我也会使用 Rx。

图像中的水 & 代码中的水：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_1-300x253.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_1.jpg)

```
public static void main(String [] args){
    Water water = new Water("water",10, "big stone", 1 , "small stone", 3);
    // 含有一个大石子和三个小石子的十升水
    for (String s : water) {
        System.out.println(s);
    }
}
```

输出:
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

图像中的水流 & 代码中的水流：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_2-237x300.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_2.jpg)

```
public static void main(String[] args) {
    Water water = new Water("water", 10, "big stone", 1, "small stone", 3);
    // 10 litre water with 1 big and 3 small stones.
    water.stream();
}

//输出和上面那个一样
```

图像中的“大石子过滤器” & 代码中的“大石子过滤器”：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_3-300x252.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_3.jpg)

同志们这里需要注意下！

在 Java8 Stream 中有个叫做 Predicate（谓词，可以判断真假，详情见离散数学中的相关定义——译注）的函数式接口。所以，如果我想进行过滤的话，可以用这个函数式接口实现流的过滤功能。现在，我给大家展示在我们的代码中如何创建“大石子过滤器”。

```
private static Predicate<String> BigStoneFilter  = new Predicate<String>() {
    @Override
    public boolean test(String s) {
        return !s.equals("big stone");
    }
};
```

正如我们在 [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3.md) 所学到的，任何函数式接口都可以转换成 Lambda 表达式。把上面的代码转换成 Lambda 表达式：

```
private static Predicate<String> BigStoneFilter  = s -> !s.equals("big stone");
```

图像和代码中的作用在水流上的“大石子过滤器”：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_4-204x300.jpeg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_4.jpeg)

```
public static void main(String[] args) {
    Water water = new Water("water", 10, "big stone", 1, "small stone", 3);
    water.stream().filter(BigStoneFilter)
    .forEach(s-> System.out.println(s));

}

private static Predicate<String> BigStoneFilter  = s -> !s.equals("big stone");
```

这里我使用了 forEach 方法，暂时把这当作流上的 for 循环。用在这里仅仅是为了输出。除去没有这个方法，我们也已经实现了我们在图像中表示的内容。是时候看看输出了：
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

没有大石子了，这意味着我们成功过滤了水。

图像中的“小石子过滤器” & 代码中的“小石子过滤器”：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_5-300x229.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_5.jpg)

```
private static Predicate<String> SmallStoneFilter  = s -> !s.equals("small stone");
```

在图像和代码中使用“小石子过滤器”：

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

我不打算解释 **SmallStoneFilter**，它的实现和 **BigStoneFilter** 是一样一样的。这里我只展示输出。

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

图像中的“水颜色转换器” 和 代码中的“水颜色转换器”

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_7-300x171.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_7.jpg)

同志们这里需要注意！

在 Java8 Stream 中有个叫做 Function 的函数式接口。所以，当我想进行转换的时候，需要把这个函数式接口送到流的转换（map）函数里面。现在，我给大家展示在我们的代码中如何创建“水颜色转换器”。

```
private static Function<String, String > convertWaterColour = new Function<String, String>() {
    @Override
    public String apply(String s) {
        return s+" black";
    }
};
```

这是一个函数式接口，所以我可以把它转换为 Lambda ：

```
private static Function<String, String > convertWaterColour = s -> s+" black";
```

简单来说，泛型中的第一个 String 代表我从水中得到什么，第二个 String 表示我会返回什么。 为了更好地掰扯清楚，我写了个把 Integer 转化成 String 的转换器。

```
private static Function<Integer, String > convertIntegerIntoString = i -> i+" ";
```

回到我们原来的例子。

为水流添加颜色转换器的图像和代码：

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

输出:
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

完活！现在我们再次回顾一些内容。

filter（过滤器）： Stream 有一个只接受 Predicate 这个函数式接口的方法。我们可以在 Predicate 里写作用在数据上的逻辑代码。

map（映射）：Stream 有一个只接受 Function 这个函数式接口的方法。我们可以在 Function 里写按照我们的要求转换数据的逻辑代码。

在进入下个环节之前，我想解释一个曾经困惑我很久的东西。当我们在任意数据上使用 stream() 的时候，背后是怎样工作的。所以我要举一个例子。我有一个整数列表。我想在控制台上显示它们。

```
public static void main(String [] args){
    List<Integer> list = new ArrayList<>();
    list.add(1);
    list.add(2);
    list.add(3);
    list.add(4);
}
```

使用命令式编程来打印数据：

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

使用 Stream 或 Rx 的方式来打印数据：

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

对于以上两段代码，它们的不同点在哪呢？

简单来说，在第一段代码中我自己管理 for 循环：

```
for (Integer integer : list) {
        System.out.println(integer);
}
```

但是在第二段代码中，流（或者稍后后要展示的 Rx 中的 Observable）进行循环：

```
list.stream().forEach(integer -> System.out.println(integer));
```

我认为很多事情都说清楚了，是时候用 Rx 来写个真实的例子了。在这个例子中，我会同时使用流式编码（stream code）和响应式编码（Rx code），这样大家可以更容易地掌握这俩的概念。

**2. Java8 Stream to Rx Observable:**

有一个存有 “Hello World” 的列表。 在图片中，把它视作字符串。在代码中把它看作列表，这样比较好解释。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_9-300x258.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_9.jpg)

Java8 的 Stream 代码：

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
    list.stream(); // Java8
}

```

Android 中的代码：

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

在这里展示了 Java8 代码和 Android 代码。从现在开始，我只给出代码中的响应式（Reactive）部分而不给出完整的一个类。完整代码分享在文章的最后了。上面的代码将变成这样：

Again above example:

```
list.stream(); // Java8

Observable.fromIterable(list); // Android
```

这两者会有相同的结果，这样来输出整个列表：

```
list.stream()
       .forEach(s-> System.out.print(s)); // Java8

Observable.fromIterable(list)
        .forEach(s-> Log.i("Android",s)); // Android

Java8 的输出:
     Hello World
Android 的输出:
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

是时候来比较下这俩了。

```
list.stream().forEach(s-> System.out.print(s)); // Java8

Observable.fromIterable(list).forEach(s-> Log.i("Android",s)); // Android
```

在 Java8 中我想要一个东西变成流的形式，我会用 Stream 的 API，但是在 Android 里，我先把那个东西转换成 Observable 然后获取到数据流。

接下来，我们将用 ’l‘ 作为过滤器来处理 Hello World，就像下面这样：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_10-300x263.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_10.jpg)[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_11-300x282.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_11.jpg)In code:

```
list.stream()
        .filter(s -> !s.equals("l"))
        .forEach(s-> System.out.print(s)); //Java8

Observable.fromIterable(list)
        .filter(s->!s.equals("l"))
        .forEach(s-> Log.i("Android",s)); // Android

输出 in Java8: 
     Heo Word

输出 In Android:
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: H
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: e
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: o
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: 
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: W
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: o
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: r
03-12 16:05:58.558 10236-10236/async.waleed.rx I/Android: d
```

好。是时候对 Java8 的 Stream API 说再见了。


**3. RxJava2 的 Android 示例：**

有一个整数数组，我想让数组中的每个成员变成自身的平方。

如图所示：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_12-288x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_12.png)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_13-300x275.jpeg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_13.jpeg)

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_14-300x296.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_14.jpg)

Android 代码：

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

输出:
03-12 16:13:32.432 14918-14918/async.waleed.rx I/Android: 1
03-12 16:13:32.432 14918-14918/async.waleed.rx I/Android: 4
03-12 16:13:32.432 14918-14918/async.waleed.rx I/Android: 9
03-12 16:13:32.432 14918-14918/async.waleed.rx I/Android: 16

```
.map(value->value*value)
```

这波很稳，我们之前已经用到过相同的概念了。把一个函数式接口传进 map，这个函数简单地将输入的数平方后返回。

```
.forEach(value-> Log.i("Android",value+""));
```

稍有常识的人都知道，我们只能在 log 中打印字符串。在上面的代码中，我在整数值的后面添加 ``+""`` 来把他们转换成字符串。

哇哦！我们可以在这个例子中再用一次 map。你们都知道我需要把整数转换成字符串以便打印到 Logcat，但是我现在打算为 map 再写一个函数式接口来完成转换。这意味着我们不需要在数据后面添加 ``+""``了，如下所示：

```
Observable.fromArray(data)
        .map(value->value*value)
        .map(value-> Integer.toString(value))
        .forEach(string-> Log.i("Android",string));
```

**4. 如何把命令式代码转化成 RxJava2 Android 代码：**

这里我打算使用一段现实存在于某 APP 的代码，我将使用 Rx Observable 把它转化成响应式（Reactive）代码。这样你很容易就知道怎样开始在自己的项目中使用 Rx 了。重要的东西可能不是很容易理解，但你应该开始动手，这样才会感觉良好。所以，像我在示例代码中提到的那样去使用它们，我会在下一篇文章中详细解释。尝试多去练练手。

示例：

我在一个项目中使用了 [OnBoarding](https://www.google.com/search?q=onboarding+ui&amp) 界面，根据 UI 设计需要在每个 OnBoarding 界面上显示点点，如下图所示：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_15-300x287.jpg)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/war_against_learning_curve_of_rx_java_2_java_8_stream_15.jpg)
如果你观察得很仔细的话，可以看到我需要将选定的界面对应的点设置成黑色。

命令式编程的代码：

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

响应式代码（Rx）的代码：

```
public void setDots(int position) {

    Observable.fromIterable(circleImageViews)
            .subscribe(imageView ->
                    imageView.setImageResource(R.drawable.white_circle_outline_on_boarding));
    circleImageViews.get(position)
            .setImageResource(R.drawable.white_circle_solid_on_boarding);

}
```

在 setDots 函数中，我简单地遍历每个 ImageView 并且把它们设置成白色的空心圈，之后将选定的 ImageView 重新设定为实心圈。

或者，

```
public void setDots(int position) {

        Observable.range(0, circleImageViews.size())
                .filter(i->i!=position)
                .subscribe(i->circleImageViews.get(i).setImageResource(R.drawable.white_circle_outline_on_boarding)));
        circleImageViews.get(position)
                .setImageResource(R.drawable.white_circle_solid_on_boarding);
}
```

在这个 setDots 函数中，我把除选定的 ImageView 之外的所有 ImageView 设置为白色空心圈。

之后，将选中的 ImageView 设置为实心圈。

**4. 几个关于把命令式代码转换成响应式代码的技巧：**

为了让大家可以在现有的代码上轻松开始使用 Rx，我写了几个小技巧。

1. 如果代码中有循环的话，用 Observable 替换

```
for (int i = 0; i < 10; i++) {

}

==>

Observable.range(0,10);
```

2. 如果代码中有 if 语句的话，用 Rx 中的 filter 替换

```
for (int i = 0; i < 10; i++) {
    if(i%2==0){
        Log.i("Android", "Even");
    }
}

==>

Observable.range(0,10)
        .filter(i->i%2==0)
        .subscribe(value->Log.i("Android","Event :"+value));
```

3. 如果需要把一些数据转换为另一种格式，可以用 map 实现

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

在 Rx 中，有很多方法实现上述代码。

使用两个流：

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

在 map 中使用 if else ：

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

4. 如果代码中有嵌套的循环：

```
for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
        System.out.print("j ");
    }
    System.out.println("i");
}

==>

Observable.range(0, 10)
        .doAfterNext(i-> System.out.println("i"))
        .flatMap(integer -> Observable.range(0, 10))
        .doOnNext(i -> System.out.print("j "))
        .subscribe();
```

这里用到了 flatmap 这个新的操作符。先仅仅尝试像示例代码中那样使用，我会在下篇文章中解释。

**总结：**

同志们干得好！今天我们学 Rx Android 学得很开心。我们从图画开始，然后使用了 Java8 的流（Stream）。之后将 Java8 的流转换到 RxJava 2 Android 的 Observable。再之后，我们看到了实际项目中的示例并且展示了在现有的项目中如何开始使用 Rx。最后，我展示了一些转换到 Rx 的技巧：把循环用 forEach 替换，把 if 换成 filter，用 map 进行数据转化，用 flatmap 代替嵌套的循环。下篇文章： [Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part5](http://www.uwanttolearn.com/android/dialogue-rx-observable-developer-android-rxjava2-hell-part5/).

希望你们开心，同志们再见！

代码：

1. [Water Stream Example（示例：水流）
   ](https://gist.github.com/Hafiz-Waleed-Hussain/c4d17174af9881c57f0e1ce676fede2d)
2. [HelloWorldStream using Java8 Stream API（示例：Java8 Stream 初体验）
   ](https://gist.github.com/Hafiz-Waleed-Hussain/9f55be929eb0f5e1956e75ac41876a3b)
3. [HelloWorldStream using Rx Java2 Android（示例：RxJava2 Android 初体验）](https://gist.github.com/Hafiz-Waleed-Hussain/509a32acad909ac1e90b2f83fb4dde5a) | [project level gradle](https://gist.github.com/Hafiz-Waleed-Hussain/57d2708607da67867d9bed7ba9882f5c) | [app level gradle
   ](https://gist.github.com/Hafiz-Waleed-Hussain/2afd1e597fdc0c204a4adb1b43c165eb)
4. [ArrayOfIntegers using Rx Java2 Android（示例：用 RxJava2 Android 操作整数数组）](https://gist.github.com/Hafiz-Waleed-Hussain/a3acd794e4942f296531018bdcad2a23) | [project level gradle](https://gist.github.com/Hafiz-Waleed-Hussain/57d2708607da67867d9bed7ba9882f5c) | [app level gradle](https://gist.github.com/Hafiz-Waleed-Hussain/2afd1e597fdc0c204a4adb1b43c165eb)

对于其他所有示例，您可以使用文章中的片段。

 
