> * 原文地址：[Reactive Programming [ Android RxJava2 ] ( What the hell is this ) Part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[XHShirley](https://github.com/XHShirley)
> * 校对者：[stormrabbit](https://github.com/stormrabbit), [phxnirvana](https://github.com/phxnirvana)

# 函数式接口、默认方法、纯函数、函数的副作用、高阶函数、可变的和不可变的、函数式编程和 Lambda 表达式 -  响应式编程 ［Android RxJava 2］（这到底是什么）第三部分


太棒了，我们又来到新的一天。这一次，我们要学一些新的东西让今天变得有意思起来。

大家好，希望你们都过得不错。这是我们的 RxJava2 Android 系列的第三篇文章.

- [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md)
- [第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2.md)

在这篇文章中，我们将讨论函数式的接口，函数式编程，Lambda 表达式以及与 Java 8 的相关的其它内容。这对每个人近期都是有帮助的。

**动机：**

动机和我在分享[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md)时一致。Lambda 表达式、函数式编程、高阶函数等等总是让我在使用 Java 时很痛苦，因为大家都知道，Java 是面向对象编程的。所以，Java 怎么可能支持函数式编程。那么，在函数式编程里，Lambda 表达式的角色是什么呢？为了让所有问题变得简单明了，我会从函数式接口开始。重要的是，我向你们保证，只要你们 100% 看完这部分，你们将会对最近我们听到的所有名字都感觉自在很多。函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的与不可变的，函数式编程与 Lambda 表达式。我觉得很多人最近都在使用 Lambda 表达式，但或许在读完这篇文章后，他们会更了解 Lambda 表达式。攻克难题的时刻到了。

**修改:**

在[第一部分](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md)，我们讨论了 Rx 最重要、最基础也最核心的概念，那就是观察者模式。在[第二部分](https://github.com/xitu/gold-miner/blob/master/TODO/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2.md)，我们讨论了拉模式和推模式，以及命令式和响应式编程。

**介绍:**

今天我们将会弄清楚所有关于函数式接口、默认方法、纯函数、函数的副作用、高阶函数、可变的和不可变的、函数式编程以及 Lambda 表达式的所有困惑。所以为了方便理解 Lambda 表达式的概念，我要先解释什么是函数式接口。

**函数式接口:**

一言以蔽之，**函数式接口是有且只有一个抽象方法的接口**。换言之，**任何拥有唯一抽象方法的接口都可以被称为函数式接口**。这里我想分享一些背景知识，这些知识不属于这个系列，但是对你面试尤其有用。如果你读过我的定义。我用了关键词抽象，众所周知的是接口里的方法都是抽象的，但那是 Java 8 出现之前的情况。在 Java 8 里，我们可以在接口中定义一个包含方法体的方法，这个方法叫默认方法，正如下面所示。

```
public interface Account {

   void name();

   default void showTyepOfAccount(){
      System.out.println("Don't know :(" );
   }
}
```

现在我们要回顾一下定义。函数式接口是个拥有一个抽象方法的接口。

所以现在，如果我问你上面的接口是不是一个函数式接口，你的答案是什么？根据定义，答案应该是：不是。但那却是一个有效的函数式接口，为什么呢……

现在，如果接口定义默认方法或者继承并重写 java.lang.Object 类里的任何方法。那个接口还是函数式接口，这是因为 **java.lang.Object** 方法并不算数。正如我在下面展示给你的真正的函数式接口。

```
public interface Add {
    void add(int a, int b);

    @Override
    String toString();

    @Override
    boolean equals(Object o);
}
```

所以，任何有多于一个抽象方法的接口不能被称为函数式接口，正如下面所示。

```
public interface Do {

    void why();

    void sorry();
}
```

我相信你已经理解了函数式接口的概念。这也是 Lambda 表达式重要的核心概念，一定要好好记住。

一些我们现在日常开发使用的函数式接口的例子：

```
public interface Runnable {
    public abstract void run();
}

public interface OnClickListener {
    void onClick(View v);
}
```

现在是时候向你展示 Java 7 和 8 的 Comparator 接口了。它们都是有效的函数式接口。

Java 7 的比较器：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.23.27-AM-300x171.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.23.27-AM.png)

在 Java 8 里：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.25.44-AM-1024x773.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.25.44-AM.png)[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.29.23-AM-1024x650.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.29.23-AM.png)

可别搞混了。它们都是有效的函数式接口。只要记住函数式接口的三点原则。

只有一个抽象方法 － 可以有默认方法 － 可以使用 java.lang.Object 方法。

如果任何接口满足这三点，那就一定是有效的函数式接口，反之则不是。

在 Java 8 里有一个新的工具包 **java.util.function**。在这个包里，所有的接口都是函数式接口。当我们需要用到流（Stream） API 时，这个工具包很有用。当我们开始学习 Rx Android 的时候，这个包会让我们学到更多。

很重要的一点。当我们要开始使用 Rx Android 时，我们会使用很多这样的函数式接口。基本上，在安卓平台中，我们依赖于 Rx Java 和 Rx Android。现在，我将要给你看一看 Rx Java 1.0 和 2.0 包里的函数式接口。没有必要去记住这个，也没有必要紧张，这只是通用知识。只要试着记得函数式接口的概念就可以了。当你开始使用 Rx，这些你都会在潜移默化中记住的。

RxJava 1:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.27-AM-120x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.27-AM.png)

RxJava2:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.49-AM-182x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.49-AM.png)

哇哦！我们该庆祝一下我们已经知道什么是函数式接口，以及在 Java 8 里什么是默认方法。我在介绍一栏中写到的本章需要探讨的概念，已经解释完两个了。~~函数式接口、默认方法~~、纯函数、函数的副作用、高阶函数、可变的和不可变的、函数式编程和 Lambda 表达式。

**函数式编程:**

说实话，我的大多数工作都是用 Java 和 C++ 完成的，而这两种语言都是命令式的而非纯函数式的。所以我打算尽力解决所有的我面对的困惑。如果我有什么地方弄错了，请不要介意。不过务必在回复里提醒我，这样我就可以修正我的文章了。

在进入无聊的定义之前，我打算回顾我们在学校里学习到的理论。这对接下来阐释剩下模棱两可的名词是很有帮助的。

每个做开发的人都知道函数。但是现在请试着忘记我们学习过的所有编程知识，重回学校。

好孩子。

数学概念上的函数是什么？［现在请忘掉你所知道的 Java 或者 C++ 等任何编程语言关于函数的所有知识。］

什么是函数？一个根据输入决定输出的方程式。挺无聊的，好的，那忘记这个。

有多少人听过下面的句子。

f(x) = x+3

如果 x = 2，答案是什么。

f(x) 等于 y。

y = x+3

x = 2

y = 2+3

y = 5

所以，f(x) = x+3 是一个函数。当你给同一个输入，会给你同样的输出。

再来一个例子。

有多少人记得 Sin(x) [ 三角函数 ]

我们当然记得。在学校的时候，对一个 45° 的角取正弦，我会得到 1/2 的答案，如下所示。

y = Sin(45deg)

y = 1/2

后来我在大学时代里也用过相同意义上的“函数”。对于给定的输入值，会得到唯一的结果。这就叫纯函数。我会在接下来解释。

我们回顾了在大学里常用的一些函数。现在，当我们在编程中用同样的思想，这就叫函数式编程。不要紧张，我马上就会解释。我们从儿时的回忆里回来看看。

首先，我们要讨论一些困惑。比如当我们刚开始写程序的时候，都写过一个计算圆面积的函数。

```
public double areaOfACircle(int radius){
    return radius*radius*3.14;
}
```

很好。随着我变得更专业，我对函数认识也不同了。比如，写一个美元转巴基斯坦卢比的汇率计算器。

```
public float convertUSDIntoPKR(int USD){
    return USD*getTodayPKRValueFromAPI();
}
```

在编程中，上面的是一个函数。但是在数学中，这就有问题了。因为在数学中，我们总是说，同一个输入对应同样的输出。但是编程中的函数给同样的输入可以有不同的输出，因为它依赖于其它数值。所以这里，我们又要介绍一个名词，叫纯函数。在数学概念里，我们知道每个函数都是纯函数，如 Sin()，但是，在我们的编程语言里，我们有很多函数给我们不同的数值。所以，这就是我们要介绍的，编程语言里的纯函数。 **纯函数的返回值由它的输入值决定，而且没有明显可见的副作用。**

下一个名词，副作用。任何不纯的函数叫非纯函数，它可能产生副作用。或者一些函数本身是纯函数（指对于给定的输入值可以得出相同的输出值），但是如果它在产生结果的时候与外界发生了数据交换，那么我们就不能说这是一个纯函数。

第一类非纯函数的典型就是 Random 函数。对于给定的一个输入值，它总是返回不同的结果。

第二类副作用的典型是 println() ，它是一个非纯的函数。因为它将输出值转去了输入输出设备（而不是作为函数返回值输出），所以产生了副作用。任何纯函数一旦用 println() 来注释打印，那它就不再是纯函数了。

一些例子：

纯函数：

```
public int squre(int x){
    return x*x;
}
```

因为副作用而非纯的的函数；

```
public int squre(int x){
    System.out.println(x*x);
    return x*x;
}
```

非纯函数：

```
public void login(String username, String password, Callback c){
    API.login(username, password, callback);
}
```

现在我们又理解了两个名词。纯函数和副作用。

~函数式接口、默认方法、纯函数、函数的副作用~、高阶函数、可变的和不可变的、函数式编程和 Lambda 表达式。

接下来，我们准备讨论可变的不可变的。在数学中，我们记得，当我给函数一个值，我总能获得新的值，而我原来的值还是一样的。但是，在编程中，那个概念就变了。这时为什么我们有两种不同的定义。可变的和不可变的。在面向对象中，我们几乎无时不刻不在破坏不可变性。这可能导致很多问题，但是函数式编程总是利用不可变性。正如每个人都知道在 Java 里，String 是不可变的。

```
String s = "Hello";
s = "World";
```

这里，我们本来的字符串从未改变。虽然第二行我们创建了新的字符串并且把它赋给我的 s 对象。

所以，什么是可变的？给你一个例子。

```
int array []= {1,2,3,4,5};
for (int i = 0; i < array.length; i++) {
    array[i] = array[i] * 2;
}
```

在 Java 或者命令式编程中，我认为上面的代码基本上是可变的。它改变了原本的数组值。但是在函数式编程里，如果我做了同样的事情，我总是获得与 2 相乘后的数值组成的新数组，而我原来的数据仍然保持不变。

```
Integer array []= {1,2,3,4,5};
Arrays.stream(array).map(v->v*2).forEach(i-> System.out.print(i+" "));
System.out.println();
for (int i = 0; i < array.length; i++) {
    System.out.print(array[i]+ " ");
}
```

```
Output:
2 4 6 8 10
1 2 3 4 5
```

上面的例子是用 Java 8 写的，但是那跟之后讲 Rx 是一样的。举出这个例子，只是为了帮助你理解可变和不可变的概念。正如你所看到的，所输出的原本的数组值并没有改变。

现在可能你在想这样的好处是什么。我这里用另外一个例子来解释。如果我知道我所有的函数都是纯的并且是不可变的，我可以做很多事情而不用管我数据的状态。例如，我要使用线程。

```
public class FunctionalLambda {

    public static void main(String[] args) {

        Integer array []= {1,2,3,4,5};
        new Thread(new Runnable() {
            @Override
            public void run() {
                for (int i = 0; i < array.length; i++) {
                    array[i] = array[i]+1;
                }
            }
        }).start();
        for (int i = 0; i < array.length; i++) {
            System.out.println(square(array[i]));
        }
    }
    public static int square(int a){
        return a*a;
    }
}
```

在这个例子里，基本上我用到了线程。子线程让数组里的每一个数据 + 1，而主线程或者其他子线程则对数组中的数据做平方运算。作为一个开发者，我期望数值应如下所示。

```
1
4
9
16
25
```

但是，当我执行这段代码时，得到的结果如下。

```
4
9
16
25
36
```

结果和期望并不相同，因为我没有管数据可变性。现在我准备写一个合适的函数式程序，对数据的不可变性进行严格控制。

```
public class FunctionalLambda {

    public static void main(String[] args) {

        Integer array []= {1,2,3,4,5};
        new Thread(new Runnable() {
            @Override
            public void run() {
                Observable.from(array)
                        .map(integer -> integer+1)
                        .subscribe(integer -> {});
            }
        }).start();

        Observable.from(array)
                .map(integer -> square(integer))
                .subscribe(integer -> System.out.println(integer));

    }

    public static int square(int a){
        return a*a;
    }
}
```

注意：如果要运行上面的例子，你需要[下载 rxjava 的 jar 包](https://mvnrepository.com/artifact/io.reactivex/rxjava/1.0.2)。

运行完这段例子后，我所期望的和实际输出的是一致的，因为我的程序没有对数组做直接改变，而是拷贝了我的数据。这就是为什么我可以说我的数组是不可变的。对不起，我也用 Rx 了。但是从现在开始，我会加一点 Rx 到我的例子里。我会在接下来的文章中解释清楚。但是，请相信我，那是一个函数式程序。在程序里，我有一个纯函数做平方运算，并且我的数组不改变，因为我将使用函数式范式。

~函数式接口、默认方法、纯函数、函数的副作用~、高阶函数、~可变的和不可变的~、函数式编程和 Lambda 表达式。

是时候解释清楚高阶函数 (HOF) 的含义了。

**拥有至少一个函数类型为参数的函数，或着返回一个函数的函数叫做高阶函数。**

那简直太简单了，并且我们在 Rx 编程中用了很多这个概念。在 Java 8 之前，展示 HOF 还是有点困难的，但是我们使用匿名类作为 HOF。我们大多在 C++ 中使用这个概念，把函数作为一个参数。在安卓中，这就类似于添加一个匿名类为点击事件监听者。所以你可以说，这是 HOF 的一个例子。我会在介绍 Rx 的文章中更详细地解释这个。

~函数式接口、默认方法、纯函数、函数的副作用、高阶函数、可变的和不可变的~、函数式编程和 Lambda 表达式。

现在，如果我们使用这些概念，在任何语言中，我们所讨论的纯函数，HOF，不可变的都是接下来的函数式范式。那就是函数式编程。在面向对象编程时我们经常要管理对象的状态，但是在函数式程序里，我们有数据，管理好了不可变性，我们可以大胆地做运算。

~~函数式接口、默认方法、纯函数、函数的副作用、高阶函数、可变的和不可变的、函数式编程~~和 Lambda 表达式。

加油呀！我们已经弄清楚了很多关于函数式编程模棱两可的概念。现在我们要用学习 Lambda 表达式来结束这篇文章。

在进入 Lambda 的章节前，我想复习一下前面的内容。

函数式接口 － 有且仅有一个抽象方法的接口。

默认方法 － 在 Java 8 里，我们可以在接口中定义有方法体的方法，这些叫默认方法。

纯函数 － 一个函数的返回值仅由输入值决定，没有明显可见的副作用。

**Lambda 表达式:**

“**在计算机编程中，lambda 表达式，也叫匿名函数，是指一类无需定义标识符（函数名）的函数或子程序。**”(Wiki)

首先，RxJava 并不依赖于 Lambda 表达式。实际上，函数式编程与 Lambda 表达式没有关系，正如你在我以上的例子中看到的那样，我从来没有说过我用了 lambda。只是 IDE 在某些地方可能把我的代码转换成了 lambda 表达式，但我可以不用它来写代码。那么，问题是，为什么在每一篇关于 Rx 或者函数式编程的博客里，我们看到 lambda 表达式总是核心内容。在我看来，你可以把它们理解为简洁高效的匿名函数语法。

在我详细介绍 Lambda 表达式前，有个先决条件。我们已经知道 Java 是一个静态类型语言。它意味着所有的 java 程序对象和变量总是在编译时间里知道数据类型，如下面的例子所示。

```
int i = 1;
float j = 3;
Person person = new Person();
String s = "Hello";
```

同样的，在 Java 7 之前，我们准备用 Collections 来写一个完整的 List 对象初始化，如下所示。

```
List<String > list = new ArrayList<String >();
```

但在 Java 7，我们有类型引用的概念。使用这个概念，我们可以写出如下简洁的代码。


```
List<String > list = new ArrayList<>();
```

所以现在，编译器在编译时根据上下文决定数据类型。这样，我们就节省了很多时间。

再一次，数据类型引用非常重要。所以我们要关注这个。在 Lambda 表达式中，我们要用到很多次，但是大家因为缺少这个概念而感到困惑。

我们继续用另外一个例子来描述同一个概念。

我写了一个方法，整数作为参数传入，而这个方法将不改变任何东西，返回同样的数值给我，如下所示。

```
public static void main(String [] args){
    System.out.println(giveMeBack(1));
}

public static int  giveMeBack(int a){
    return a;
}
```

这是简单的例子。现在我想传个 3.14 给这个方法，有没有人告诉我，会发生什么呢？

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.23.34-PM-300x227.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.23.34-PM.png)

是的，你的程序将无法编译。我已经说过了，这个方法只能传入整数。我的下一个要求是，我要使得这个方法适用于所有数据类型。作为一个开发者，我是一个懒人。我不想写重复的代码。这里我想利用 Java 的引用。

```
public static<T> T  giveMeBack(T a){
    return a;
}
```

这也叫泛型。利用泛型，我节省了很多时间。这个方法可以适用于任何数据类型，如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.27.35-PM-300x164.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.27.35-PM.png)

现在我从 Java 引用中获得了好处。怎么样获得的呢？我的编译器，编译我的程序，为我的所有数据类型生成了代码。现在，编译器可以很容易地从我的参数的数据类型做决定。这里没有什么神奇的地方。每当我没有提到数据结构，我的编译器就从上下文中提取并且赋予其数据类型，因为 Java 是一个静态类型语言。

再重复一遍，Java 是一个静态类型语言。所以如果你觉得你在 IDE 中写的代码没有任何类型。你可能会认为你使用的是一个动态类型语言。你错了，你只是在利用 Java 类型推断而已。

现在，我们可以开始写 Lambda 表达式了。目前，Lambda 表达式只支持 Java 8。在安卓中，如果我们想用它，我们可以用 Retrolambda 库。现在们来解释一下 lambda 表达式。

在安卓中，我想要一个可监听点击事件的按钮，如下面代码所示。

```
Button button = new Button(this);
button.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        // Click
    }
});
```

这里我们传入了一个 OnClickLisetener 的匿名对象。当用户点击，onClick 方法就会被调用。现在我们要用 Lambda 表达式改变这个匿名的，恶心的，复杂的代码。

```
Button button = new Button(this);
button.setOnClickListener((View v)->{
    // Click
});
```

通过使用 Lambda 表达式，我的代码可读性更强了。我准备再重构一下上面的例子。

```
button.setOnClickListener(v -> /* Click */);
```

我真的很喜欢写类似上面的代码，但是在开始的时候，我真的很困惑，编译器是如何知道我这里在做什么。首先，我利用了 Java 引用。就像编译时，Java 自动知道‘v'是一个 View，因为我们用的是**函数式接口**。这个接口只有一个抽象方法，它的参数是一个 view，如下所示。

```
/**
 * Interface definition for a callback to be invoked when a view is clicked.
 */
public interface OnClickListener {
    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    void **onClick**(View v);
}
```

还记得接口函数的概念吗？现在所有的线索都被串起来了。我们已经讨论了函数式接口。它意味着任何以函数式接口为参数的方法，我就可以写成 Lambda 表达式。这意味着，Lambda 表达式是一个语法糖。我觉得你们现在已经知道 Lambda 表达式是个什么东西了。这就是为什么我要关注函数式接口和其它名词了。

再来一个例子。

```
Without Lambda:

Thread thread = new Thread(new Runnable() {
    @Override
    public void run() {
        // Without Lambda
    }
});
thread.start();
```

使用 Lambda 表达式：

```
Thread thread = new Thread(()->{});
thread.start();
```

在 Java 8 或者 Rx Java 中，我们会使用很多函数式接口，因为我们想写出简单明了的代码，并且寥寥数语就可以完成一个大功能。现在我觉得所有的困惑都已经清晰了。这里有一些关于 Lambda 表达式更重要的点。

如果当按钮被按下时，我想写一行代码，我可以写成下面这样。

```
button.setOnClickListener(v -> System.out.println());
```

但如果我想写不止一行，那么我需要把它们写进花括号里，如下所示。

```
button.setOnClickListener(v -> {
    System.out.println();
    doSomething();
});
```

我可以明确提及数据类型，如下所示。

```
button.setOnClickListener((View v) -> System.out.println());
```

现在，如何返回 Lambda 表达式类型呢？再给你一个例子。

```
public interface Add{
    int add(int a, int b);
}

private Add add= new Add() {
    @Override
    public int add(int a, int b) {
        return a+b;
    }
};

int sum = add.add(1,2);
```

现在我使用 Lambda 表达式来表现同一个例子。

```
public interface Add{
    int add(int a, int b);
}

private Add add = (a, b) -> a+b;

int sum = add.add(1,2);
```

现在可以看到我写的代码有多简洁了。它们的功能是一样的。我没有提及任何返回的数据类型，因为 Java 的类型引用自动帮我决定了这是一个整型。现在，如果我想添加更多的代码到 add 方法的实现中，只需要像下面那样写就行了。

```
public interface Add{
    int add(int a, int b);
}

private Add add = (a, b) -> {
    System.out.println();
    return a+b;
};

int sum = add.add(1,2);

```


现在我们知道函数式接口、默认方法、纯函数、函数的副作用、阶函数、可变的和不可变的、函数式编程和 Lambda 表达式。


结论：

大家都太棒了。今天我们到达了一个 Rx 学习中的里程碑。下一篇文章是 [War against Learning Curve of Rx Java 2 + Java 8 Stream [ Android RxJava2 ] ( What the hell is this ) Part4](https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md)。到现在为止，我们了解了观察者模式、拉模式与推模式、响应式与命令式、函数式接口、默认方法、纯函数、函数的副作用、高阶函数、可变的和不可变的、函数式编程和 Lambda 表达式。我认为，如果你都了解了上述名词，Rx 的学习将会越来越简单。现在我感觉你们都已经了解了，所以接下来 Rx 的学习对于我们都会更简单。

祝你们有个愉快的周末。让我们下周再见吧。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
