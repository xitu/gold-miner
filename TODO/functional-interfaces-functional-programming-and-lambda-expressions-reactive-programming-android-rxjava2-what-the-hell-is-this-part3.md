> * 原文地址：[Reactive Programming [ Android RxJava2 ] ( What the hell is this ) Part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

## Functional Interfaces, Default Methods, { Higher Order – Pure – Side Effects in } + Functions, Im + { Mutable } , Lambda Expression & Functional Programming – Reactive Programming [ Android RxJava2 ] ( What the hell is this ) Part3 ##

##函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程和 Lambda 表达式 -  响应式编程 ［Android RxJava 2］（这到底是什么）第三部分##


WOW, we got one more day so its time to make this day awesome by learning something new .

Hello guys, hope you are doing good. This is our third post in series of RxJava2 Android [ [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/), [part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/) ]. In this post we are going to discuss about Functional Interfaces, Functional Programming, Lambda expressions and may be something bonus related to Java 8. Which will be helpful for everyone in near future.

大家好，希望你们都过得不错。这是我们的 RxJava2 Android 系列的第三篇文章[[第一部分](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/), [第二部分](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/)]。在这篇文章中，我们将讨论函数式的接口，函数式编程，Lambda 表达式以及与 Java 8 的相关的其它内容。这对每个人近期都是有帮助的。

**Motivation:**
**动机：**

Motivation is same which I share with you in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/). Lambda expressions, Functional programming, High Order Functions and blah blah blah always give me tough time specially when I am doing work in Java because every body know’s Java is Object Oriented Programming. So how Java can support Functional Paradigm. Then what is the role of Lambda expressions in Functional Programming. To make every thing clear and easy just like nothing, I will start from Functional Interfaces. One important point, my promise with you guys. I am 100% sure as you follow this part. In the end you will be comfortable with all the terms which we are listening in these days a lot. Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions. I have a feeling lot of people are using Lambda expression in these days but may be after completing this post they know what is really Lambda expressions. Its time to ATTACK.

动机和我在分享［第一部分］(http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/)时一致。Lambda 表达式，函数式编程，高阶函数等等总是让我在使用 Java 时很痛苦，因为大家都知道，Java 是面向对象编程的。所以，Java 怎么可能支持函数式编程。那么，在函数式编程里，Lambda 表达式的角色是什么呢？为了让所有问题变得简单明了，我会从函数式接口开始。重要的是，我向你们保证，只要你们 100% 看完这部分，你们将会对最近我们听到的所有名字都感觉自在很多。函数式接口，默认方法，完全的函数，函数的副作用，高阶函数，可变的与不可变的，函数式编程与 Lambda 表达式。我觉得很多人最近都在使用 Lambda 表达式，但或许在读完这篇文章后，他们会更了解 Lambda 表达式。攻克难题的时刻到了。

**Revision:**
**修改:**

In [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/) we discuss the most important, basic and core concept of Rx and that is a Observer Pattern. In [part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/) we discuss about Pull vs Push and Imperative vs Reactive programming.

在［第一部分］(http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/)，我们讨论的 Rx 最重要，最基础也最核心的概念，那就是观察者模式。在［第二部分］(http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/)，我们讨论了拉模式和推模式，以及命令式和响应式编程。

**Introduction:**
**介绍:**

Today we are going to clear all confusions about Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions. So guys I am not going to start from Lambda Expressions instead I am going to start from Functional Interfaces.

今天我们将会弄清楚所有关于函数式接口，默认方法，完全函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程以及 Lambda 表达式的所有困惑。所以，我不准备从 Lambda 表达式开始，反而我要从函数式接口开始。

**Functional Interface:**
**函数式接口:**

In simple words. *Functional Interface is an interface having one abstract method*. Simple no more confusions. Again, *any interface have only one abstract method is called Functional Interface*. Here I want to share some knowledge, which is not the part of this series but that is good if you know specially for interviews. If you read my definition. I used abstract keyword but we already know interface has always abstract methods. So that is before Java 8. In Java 8 we can define one method in interface and that is called default method like shown below.

简单地说，**函数式接口是个有一个抽象方法的接口。**同样简单地说，**任何拥有一个抽象方法的叫函数式接口。**这里我想分享一些背景知识，这些知识不属于这个系列，但是对你面试尤其有用。如果你读过我的定义。我用抽象的关键词，但是我们已经知道接口总是有抽象方法，所以那就是 Java 8 之前的。在 Java 8 里我们可以在接口里定义一个方法，这个方法叫默认方法，正如下面所示。

```
public interface Account {

   void name();

   default void showTyepOfAccount(){
      System.out.println("Don't know :(" );
   }
}
```

Now I am going to revise the definition. Functional Interface is an interface having one abstract method.

现在我们要修改一下定义。函数式接口是个拥有一个抽象方法的接口。

So now if I ask you the above interface is a Functional Interface or not. What will be your answer. According to definition. Answer should be No but that is a valid Functional Interface. Why…

所以现在，如果我问你上面的接口是不是一个函数式接口，你的答案是什么？根据定义，答案应该是不是，但那却是一个有效的函数式接口，为什么呢……

Now if interface use default method or may be try to use any method of **java.lang.Object** into interface. That interface remain Functional Interface because **java.lang.Object** methods will not count. Just like I am showing you one valid Functional Interface below.

现在，如果接口使用默认方法或者可能尝试使用 **java.lang.Object** 的任何方法。那个接口还是函数式接口，这是因为 **java.lang.Object** 方法并不算数。正如我在下面展示给你的真正的函数式接口。

```
public interface Add {
    void add(int a, int b);

    @Override
    String toString();

    @Override
    boolean equals(Object o);
}
```

So any interface which has more then one method is not called a Functional Interface just like shown below.

所以，任何有多于一个方法的接口不叫函数式接口，正如下面所示。

```
public interface Do {
   
    void why();
   
    void sorry(); 
}
```

I think you grasp the concept of Functional Interface. Guys that is a really core concept of Lambda expression so try to remember this concept.

我相信你已经理解了函数式接口的概念。这可真的是 Lambda 表达式的核心概念，所以试着记住这个概念吧。

Some examples of Functional Interfaces which currently we are using in our daily development.

一些我们现在每天开发使用的函数式接口的例子：

```
public interface **Runnable** {
    public abstract void **run**();
}

public interface **OnClickListener** {
    void **onClick**(View v);
}
```

Now its time to show you Comparator interface in Java 7 and 8  both are valid Functional Interfaces.

现在是时候向你展示 Java 7 和 8 的比较器接口了。它们都是有效的函数式接口。

In Java 7 Comparator:

Java 7 的比较器：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.23.27-AM-300x171.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.23.27-AM.png)

In Java 8:

在 Java 8 里：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.25.44-AM-1024x773.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.25.44-AM.png)[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.29.23-AM-1024x650.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.29.23-AM.png)

Do not confuse guys. Again both are valid Functional Interfaces. Only remember three things about Functional Interface.

可别搞混了。它们都是有效的函数式接口。只要记住函数式接口的三件事情。

Only one abstract method – May have default methods – May use java.lang.Object methods

只有一个抽象方法 － 可以有默认方法 － 可以使用 java.lang.Object 方法。

If any interface pass these three points that is a valid Functional Interface otherwise no.

如果任何接口满足这三点，那就一定是有效的函数式接口，反之则不是。

In java 8 there is a whole new package **java.util.function.** In this package all interfaces are Functional Interfaces. That package is useful when we are working with Streams API. Which we will learn as a bonus when we will start Rx Android.

在 Java 8 里有一个新的工具包 **java.util.function**。在这个包里，所有的接口都是函数式接口。当我们需要用到流 API 时，这个工具包很有用。当我们开始学习 Rx Android 的时候，这个包会让我们学到更多。

One very important point. Guys as we are going to start working with Rx Android. We will play a lot with these Functional Interfaces. Basically in Android we are dependent on Rx Java and Rx Android. Now I am going to show you package of Rx Java 1.0 and 2.0 Functional Interfaces. No need to remember this thing and no need to take tension that is only general knowledge. Only try to remember the concept of Functional Interface. These will automatically remember to you when we start working together on Rx.

很重要的一点。当我们要开始使用 Rx Android 时，我们会使用很多这样的函数式接口。基本上，在安卓平台中，我们依赖于 Rx Java 和 Rx Android。现在，我将要给你看一看 Rx Java 1.0 和 2.0 包里的函数式接口。没有必要去记住这个，也没有必要紧张，这只是通用知识。只要试着记得函数式接口的概念久可以了。当你开始使用 Rx，这些你都会不自觉地想起来。

RxJava 1:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.27-AM-120x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.27-AM.png)RxJava2:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.49-AM-182x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.49-AM.png)

WOW. Its time to celebrate now we know what is a Functional Interfaces, what are default methods in Java 8. As I write in introduction about the terms, which we are going to discuss in this post, two are gone .
Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions.

哇哦！我们该庆祝一下我们已经知道什么是函数式接口，以及在 Java 8 里什么是默认方法。当我在介绍里写到这些名词时，当然，我们将要这篇文章中讨论它们，两个新名词就解释完了。函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程和 Lambda 表达式。

**Functional Programming:**
**函数式编程:**

Truly saying I mostly work with Java and C++ and both are imperative not pure functional. So I am going to try my best to clear all confusions which I faced but if I am wrong some where please forgive me and update me in comments. So I will update my post.

我真的大部分使用 Java 和 C++，而且它们都是命令式的而且不是纯函数式的。所以我打算尽力解决所有的我面对的困惑。请原谅我，可以在回复里提醒我来更新我的文章。

Guys before going into boring definitions. I am going to revise some of our college or school days concepts. Which is really helpful here to clear all the ambiguities about the remaining terms.

在进入无聊的定义之前，我打算修改我们在学校学习到的概念。这对接下来阐释剩下模棱两可的名词是很有帮助的。

Every body who is doing development know functions. But currently try to forget everything about programming and go back to college or school days. ——————- School Days, Present Madam.

每个做开发的人都知道函数。但是现在请试着忘记我们学习过的所有编程知识，重回学校。

Good boy.

好孩子。

Now what is a function in math class. [Guys for the time being forget all knowledge which you have related to functions in Java or C++ or in any language.]

在数学课上，什么是函数。［现在请忘掉你所知道的在 Java 或者 C++ 等任何编程语言关于函数的所有知识。］

What is a function? A function related an input to output. Boring ok forget.

How many people know about the below sentence.

什么是函数？一个根据输入决定输出的方程式。挺无聊的，好的，那忘记这个。

有多少人听过下面的句子。

f(x) = x+3

if x = 2 what will be the answer.

如果 x = 2，答案是什么。

f(x) equal to y.

f(x) 等于 y。

y = x+3

x = 2

y = 2+3

y = 5

So basically f(x) = x+3 is a function. Which always give you same output for same input.

One more example.

How many people remember.

Sin(x) [ Trigonometry ]

We remember. Every time in school life when I gave theta value 45 degree. I get answer 1/2 like shown       below.

所以，f(x) = x+3 是一个函数。当你给同一个输入，会给你同样的输出。

再来一个例子。

有多少人记得。

Sin(x) [ 三角函数 ]

我们当然记得。在学校的时候，每当我们得到一个 45 度的 theta 角，我会得到 1/2 的答案，如下所示。

y = Sin(45deg)

y = 1/2

Later I used this same function in college and university. Every time when I have same input I got same result. That is called pure functions. I will explain more later.

接下来，我要用到这个在大学里常见的同样的函数。每次我给一样的输入，我会得到一样的记过。这就叫纯函数。我会在接下来解释。

Here we revise some functions which we use a lot in our school or college life. Now when we use the same concept in programming. That is called Functional Programming. Do not take tension I am going to explain now. We are back from childhood memories.

这里我们要修改一些我们在学校里常用的函数。现在，当我们在编程中用同样的概念，这就叫函数式编程。不要紧张，我马上就会解释。我们从儿时的回忆里回来看看。

First need to discuss some confusion. Like when we start programming we start like. Write a function which will calculate area of a circle.

首先，我们要讨论一些困惑。正如，当我们开始编程，我们开始写一个可以计算圆的面积的函数。

```
public double areaOfACircle(int radius){
    return radius*radius*3.14;
}
```

Good. Now as I am going more professional my definition of function is changed. Like write a currency converter of USD into PKR.

很好。现在我要给函数一个更专业的定义，正如写一个 USD 和 PKR 的货币转换器。

```
public float convertUSDIntoPKR(int USD){
    return USD*getTodayPKRValueFromAPI();
}
```

In Programming that is a function but in math. There is some issue because in math we always say. Same input always give you same output. But our function may give your different output on same input because that is dependent upon the external value. So here I am going to introduce a one more term. That is called a Pure function. In Math we always know every function is a pure function just like Sin() but in our programming languages we have a lot of functions which always give us a different value. So for that we introduce a new term called a Pure function in programming.
*A pure function is a function where the return value is only determined by its input values, without observable side effects.*

在编程中，上面的是一个函数。但是在数学中，这就有问题了。因为在数学中，我们总是说，同一个输入对应同样的输出。但是编程中的函数给同样的输入可以有不同的输出，因为它依赖于其它数值。所以这里，我们又要介绍一个名词，叫纯函数。在函数里，我们知道每个函数都是纯函数，如 Sin()，但是，在我们的编程语言里，我们有很多函数给我们不同的数值。所以，这就是我们要介绍的，编程语言里的纯函数。 **纯函数是返回值值决定于它的输入，而并没有观察者的副作用。**

One more term side effect. Any function which is not pure is called a impure function which may have a side effect. Or may be there is some function which is pure but if we can see any side effect in that then we are not able to say that is a Pure function.

下一个名词，副作用。任何不纯的函数叫非纯函数，它可能产生副作用。或者可以说，一些函数式纯的，但是如果我们看到它有任何负作用，那么我们就不能说这是一个纯函数。

First impure function like Random. This always give you different value for same seed.

Side effect like println() is an impure because it causes output to an I/O device as a side effect. In any function which is pure but I used println() note that function is not remain pure function due to side effect.

第一个非纯函数就是随机函数。它总是用同一个种子给你返回不同的结果。

副作用像 println()，是一个非纯的函数，因为为 I/O 设备提供输出是它的副作用。任何函数式纯的，但是如果我用 println() 来注释打印，那它就不再是纯函数了。

Some examples:

Pure:

一些例子：

纯函数：

```
public int squre(int x){
    return x*x;
}
```

Impure due to Side Effect:

因为副作用而非纯的的函数；

```
public int squre(int x){
    System.out.println(x*x);
    return x*x;
}
```

Impure:

非纯函数：

```
public void login(String username, String password, Callback c){
    API.login(username, password, callback); 
}
```

Now we grasp two more terms. Pure functions and Side effect.
Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions.

现在我们又理解了两个名词。纯函数和副作用。

函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程和 Lambda 表达式。

Next we are going to discuss Mutable and Immutable. In mathematics as we remember every time when I gave my value to some function. I always get the new value and my original value remain same. But in programming that concept has changed so that’s why we have two different definitions. Mutable and Immutable. In OO we mostly use to break immutability. Which may cause a lot of issue but in Functional Programming that always used immutability. Like every body know in Java String is Immutable.

接下来，我们准备讨论可变的不可变的。在数学中，我们记得，当我给函数一个值，我总能获得新的值，而我原来的值还是一样的。但是，在编程中，那个概念就变了。这时为什么我们有两种不同的定义。可变的和不可变的。在 00？ 中我们差一点就打破了不可变性。这可能导致很多问题，但是函数式编程总是利用不可变性。正如每个人都知道在 Java 里，String 是不可变的。

```
String s = "Hello";
s = "World";
```

Here our original String never changed. Yes in second line I created a new String and assign that to my s object.

So what is mutable. One example.

这里，我们本来的字符串从未改变。虽然第二行我们创建了新的字符串并且把它赋给我的 s 对象。

所以，什么是可变的？给你一个例子。

```
int array []= {1,2,3,4,5};
for (int i = 0; i < array.length; i++) {
    array[i] = array[i] * 2;
}
```

In Java or in imperative programming if I call above code that is basically mutable. That changed my original array values. But in Functional Programming if I do the same thing I always get a new array with multiplied values and I have the original data remain unchanged.

在 Java 或者命令式编程中，我认为上面的代码基本上是可变的。它改变了原本的数组值。但是在函数式编程里，如果我做了同样的事情，我总是获得乘好的数值组成的新数组，而我原来的数据仍然保持不变。

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

The above example written in Java 8 but that will be same in Rx later. Only try to grasp the concept of mutable and Immutable. So as you see in output original array value has no change.

上面的例子是用 Java 8 写的，但是那跟之后讲 Rx 是一样的。只要试着理解可变的不可变的概念。正如你所看到的，所输出的原本的数组值并没有改变。

Now may be you are thinking what is the benefit of this. So I am going to explain here one example. If I know all my functions are Pure and Immutable I can do lot of things without taking care of my data state. For example I am going in threading.

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

In this example basically I am using threading. One of my thread doing addition of value 1 in each member of array and the main or other thread is taking square of all the values in array. As a developer my expected value should be like shown below.

在这个例子里，基本上我用到了线程。其中一个线程对 1 和数组中的每个数值做加法，而主要的和其它线程则对数组中的数值做平方运算。作为一个开发者，我期望数值应如下所示。

```
        1
        4
        9
        16
        25
```

But when I run I got the below output.

但是，当我跑起程序，我得到的是下面的输出。

```
        4
        9
        16
        25
        36
```

This is wrong or actual output. Because I am not taking care of my mutability. Now I am going to right a proper Functional program. In which I will manage my immutability.

这是错的，但也是实际输出，因为我没有管数据可变性。现在我准备写一个合适的函数式程序，这段程序将管理我数据的不可变性。

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

Note: For running above example you need to [download rxjava jar](https://mvnrepository.com/artifact/io.reactivex/rxjava/1.0.2).

注意：如果要跑上面的例子，你需要［下载 rxjava jar］(https://mvnrepository.com/artifact/io.reactivex/rxjava/1.0.2)。

After running this example my expected and actual both outputs are same because here my program is not doing changes directly in array instead that is creating a copy of my data. So that’s why I can say my array is immutable. I also used Rx so for that sorry but from now I will add little bit Rx in my examples. I will explain you in next post but trust on me. That is a Functional Program in which I have one Pure Function square and my array is not mutated because I am using Functional Paradigm.

跑完这段例子后，我所期望的和实际输出的事一致的，因为我的程序没有对数组做直接改变，而是拷贝了我的数据。这就是为什么我可以说我的数组是不可变的。对不起，我也用 Rx 了。但是从现在开始，我会加一点 Rx 到我的例子里。我会在接下来的文章中解释清楚。但是，请相信我，那时一个函数式程序。在程序里，我有一个纯函数做平方运算，并且我的数组不改变，因为我将使用函数式范式。

Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions.

函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程和 Lambda 表达式。

Now its time to clear our ambiguity about Higher Order Functions (HOF).

是时候解释清楚高阶函数 (HOF) 的含义了。

*A function with at least one parameter of type function or a function that returns function is called a higher order function*.

**拥有至少一个函数类型为参数的函数，或着返回一个函数的函数叫做高阶函数。**

Hmm that is really easy and we use a lot this concept in our Rx programming. Before Java 8 that is little bit difficult to show you HOF but we can use anonymous class as a HOF. We are mostly used this concept in C++. Where I can send function as a parameter. In Android like I am going to add a Click listener with anonymous class. So you can say that is an example of HOF. I will explain more when we are in Rx post.
Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions,Higher Order Functions,Mutable and Immutable, Functional Programming and Lambda expressions.

那简直太简单了，并且我们在 Rx 编程中用了很多这个概念。在 Java 8 之前，展示 HOF 还是有点困难的，但是我们使用匿名类作为 HOF。我们大多在 C++ 中使用这个概念，把函数作为一个参数。在安卓中，这就类似于添加一个匿名类为点击事件监听者。所以你可以说，这是 HOF 的一个例子。我会在介绍 Rx 的文章中更详细地解释这个。

函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程和 Lambda 表达式。

Now if we are using these concepts which we discuss Pure Functions, HOF, Immutable in any language you can say we are following Functional Paradigm. That is a Functional Programming. In OO we mostly manage the states but in Functional we have data and we do computation by taking care of immutability.

现在，如果我们使用这些概念，在任何语言中，我们所讨论的纯函数，HOF，不可变的都是接下来的函数式范式。那就是函数式编程。在 00？我们常要管理状态，但是在函数式程序里，我们有数据，管理好了不可变性，我们可以大胆地做运算。

Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions,Higher Order Functions,Mutable and Immutable,Functional Programming and Lambda expressions.

函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程和 Lambda 表达式。

Hurray we cleared our lot of ambiguities related to Functional Programming. Now its time to finish our this post by learning last thing Lambda Expressions.

加油呀！我们已经弄清楚了很多关于函数式编程模棱两可的概念。现在我们要用学习 Lambda 表达式来结束这篇文章。

Before going to Lambda’s I want to revise what we did till now.

在进入 Lambda 的章节前，我想复习一下前面的内容。

Functional Interface – an interface having one abstract method.

函数式接口 － 一个有一个抽象方法的接口。

Default Method – In Java 8 we can define methods in interface these are called Default Method.

默认方法 － 在 Java 8 里，我们可以在接口中定义方法，这些叫默认方法。

Pure Function –  A function, where the return value is only determined by its input values, without observable side effects.

纯函数 － 一个函数的返回值仅由输入值决定，不需要做观察。

**Lambda Expressions:**
**Lambda 表达式:**

“*lambda expression in computer programming, also called anonymous function, a function (or a subroutine) defined, and possibly called, without being bound to an identifier*” (Wiki)

“**在计算机编程中，lambda 表达式，也叫匿名函数，是指一类无需定义标识符（函数名）的函数或子程序。**”(Wiki)

First and most important thing. RxJava is not dependent on Lambda’s. Instead Functional Programming has no relationship with Lambda’s as you already saw in all of my above examples I never mentioned I used lambda may be on some places IDE converted my code to lambda but we can do everything without lambda. Then questions is why in every blog of Rx or Functional Programming we saw lambda expressions as a core part of the blog. In my opinion, you can think they are simple, improved syntax form of anonymous functions.

首先，RxJava 并不依赖于 Lambda 表达式。实际上，函数式编程与 Lambda 表达式没有关系，正如你在我以上的例子中看到的那样，我从来没有说过我用了 lambda。只是 IDE 在某些地方可能把我的代码转换成了 lambda 表达式，但我可以不用它来写代码。那么，问题是，为什么在每一篇关于 Rx 或者函数式编程的博客里，我们看到 lambda 表达式总是核心内容。在我看来，你可以把它们认为简单的，有效的匿名函数形式。

There is some prerequisite which I am going to explain you before going into more detail about Lambdas. As we already know Java is a static type language. Its mean all java program objects and variables always know about there data type at compile time. For example code as shown below.

在我详细介绍 Lambda 表达式前，有个条件。我们已经知道 Java 是一个静态类型语言。它意味着所有的 java 程序对象和变量总是在编译时间里知道数据类型，如下的例子这样。

```
int i = 1;
float j = 3;
Person person = new Person();
String s = "Hello";
```

In a same way before Java 7 we are going to use Collections we need to write a complete List of initialization like shown below.

同样的，在 Java 7 之前，我们准备用 Collections 来写一个完整的 List 对象初始化，如下所示。

```
List<String > list = new ArrayList<String >();
```

But in Java 7 we got Type Inference concept. By using that one we can write concise code just like shown below.

但在 Java 7，我们有类型引用的概念。使用这个概念，我们可以写出如下简洁的代码。


```
List<String > list = new ArrayList<>();
```

So basically now compiler will determine the type by using the context at compile time. In that way we can save a lot of time.

Guys again, type inference is very very important. So try to focus on this thing. In Lambda expressions, we are using a lot and lot of people confused due to lake of this concept.

所以现在，编译器在编译时根据上下文决定数据类型。这样，我们就节省了很多时间。

再一次，数据类型引用非常重要。所以我们要关注这个。在 Lambda 表达式中，我们要用到很多次，但是大家因为缺少这个概念而感到困惑。

Going again to describe this same concept by taking different example.

I have a one method in which I will send integer as param and that method will return me that same value without changing any thing like as shown below.

我们继续用另外一个例子来描述同一个概念。

我写了一个方法，整数作为参数传入，而这个方法将不改变任何东西，返回同样的数值给我，如下所示。

```
public static void main(String [] args){
    System.out.println(**giveMeBack(1)**);
}

public static int  **giveMeBack**(int a){
    return a;
}
```

This is a simple example. Now I want to give 3.14 to this method. So guys any body tell me what will happen?

这是简单的例子。现在我想传个 3.14 给这个方法，有没有人告诉我，会发生什么呢？

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.23.34-PM-300x227.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.23.34-PM.png)

Yes you are write program is not able to compile as shown above. I already mentioned that method only take Integer. Next my requirement is, I need to write this function for all data types. Now as a developer I am a lazy guy. I don’t want to write a same code again and again. Here I am going to take benefit of Java inference.

是的，你的程序将无法编译。我已经说过了，这个方法只能传入整数。我的下一个要求是，我要使得这个方法适用于所有数据类型。作为一个开发者，我是一个懒人。我不想写重复的代码。这里我想利用 Java 的引用。

```
public static<T> T  giveMeBack(T a){
    return a;
}
```

This is also called generics. Now by using generics I save my lot of time. I can use this method for any data type as shown below.

这也叫泛型。利用泛型，我节省了很多时间。这个方法可以适用于任何数据类型，如下图所示。

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.27.35-PM-300x164.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.27.35-PM.png)

Now here I get a benefit from Java inference. How? As compiler, compile my program, that easily generate a code for my all these data types. Now compiler can easily determine from my param data type. So there is no magic. Every time when I am not mentioning the data type most probably compiler will take the context and assign the datatype according to the context because Java is a static type language.

现在我从 Java 引用中获得了好处。怎么样获得的呢？我的编译器，编译我的程序，为我的所有数据类型生成了代码。现在，编译器可以很容易地从我的参数的数据类型做决定。这里没有什么神奇的地方。每当我没有提到数据结构，我的编译器就从上下文中提取并且赋予其数据类型，因为 Java 是一个静态类型语言。

Repeat. Java is a static type language. So if you feel in IDE you are writing some code which did not have any type or may be you think you are going as a Dynamic type language. You are wrong, basically you are taking benefit of Java inference.

再重复一遍，Java 是一个静态类型语言。所以如果你觉得你在 IDE 中写的代码没有任何类型。你可能会认为你使用的是一个动态类型语言。你错了，你只是在利用 Java 引用而已。

Now its time to start work on Lambda expressions. Guys important thing currently Lambda expression only support to Java 8. So in Android if we want Lambda expressions we can use one library Retrolambda. Which is good. Now I am going to explain about LambdaExpressions.

In Android I want a one button with Click Listener. So code as shown below.

现在，我们可以开始写 Lambda 表达式了。目前，Lambda 表达式只支持 Java 8。在安卓中，如果我们想用它，我们可以用 Retrolambda 库。现在们来解释一下 lambda 表达式。

```
Button button = new Button(this);
button.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View v) {
        // Click
    }
});
```

Here I am setting one anonymous object of OnClickLisetener. So when user click, onClick method will be called. Now I am going to change this anonymous, shitty, complex code with Lambda expression.

这里我们翻入了一个 OnClickLisetener 的匿名对象。当用户点击，onClick 方法就会被调用。现在我们要用 Lambda 表达式改变这个匿名的，恶心的，复杂的代码。

```
Button button = new Button(this);
button.setOnClickListener((View v)->{
    // Click
});
```

Now by using Lambda expressions I made my code concise and easy to read. I am going to make more refactoring to the above example.

通过使用 Lambda 表达式，我的代码可读性更强了。我准备再重构一下上面的例子。

```
button.setOnClickListener(v -> /* Click */);
```

I really like to write code as shown above but in start I really confused how compiler know what I am doing here. First thing here we are using the benefit of Java inference. Like on compile time Java automatically know ‘v’ is a View because we have a **functional interface** which contain one method who has one argument and that is a view as shown below.

我真的很喜欢写类似上面的代码，但是在开始的时候，我真的很困惑，编译器是如何知道我这里在做什么。首先，我利用了 Java 引用。就像编译时，Java 自动知道‘v'是一个 View，因为我们用的是**函数式接口**。这个接口包含一个方法，它的参数是一个 view，如下所示。

```
/**
 * Interface definition for a callback to be invoked when a view is clicked.
 */
public interface **OnClickListener** {
    /**
     * Called when a view has been clicked.
     *
     * @param v The view that was clicked.
     */
    void **onClick**(View v);
}
```

Hay, what I used, Functional Interface term. I think dots are connecting. We already discuss about Functional Interface. Its mean any method who will take a Functional Interface as an argument I can write as a Lambda Expression. Its mean Lambda Expression is a syntactic sugar.  Guys I have a feeling now you are getting everything about Lambda Expressions. Why I focused on Functional Interfaces and other terms.

我用了函数接口的名字。我觉得点点点是连接中。我们已经讨论了函数式接口。它意味着任何以函数式接口为参数的方法，我就可以写成 Lambda 表达式。这意味着，Lambda 表达式是一个语法糖。我觉得你们现在已经知道 Lambda 表达式是个什么东西了。这就是为什么我要关注函数式接口和其它名词了。

One more example.

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

With Lambda:

使用 Lambda 表达式：

```
Thread thread = new Thread(()->{});
thread.start();
```

In Java 8 or Rx Java we have a lot of Functional Interfaces because we want to write concise code which is really easy to read and very few words of code achieve big functionalities. Now I think all confusions are clear. Some more important points about Lambda.

If I only want to write a single line of code on Button press I can write my code as shown below.

在 Java 8 或者 Rx Java 中，我们会使用很多函数式接口，因为我们想写出简单明了的代码，并且寥寥数语就可以完成一个大功能。现在我觉得所有的困惑都已经清晰了。这里有一些关于 Lambda 表达式更重要的点。

如果当按钮被按下时，我想写一行代码，我可以写成下面这样。

```
button.setOnClickListener(v -> System.out.println());
```

But If I want to write more then one line of code. Then I need to write in curly braces as shown below.

但如果我想写不只一行，那么我需要把它们写进花括号里，如下所示。

```
button.setOnClickListener(v -> {
    System.out.println();
    doSomething();
});
```

I can mention data type of my params explicitly as shown below.

我可以明确提及数据类型，如下所示。

```
button.setOnClickListener(**(View v)** -> System.out.println());
```

Now what about return type in Lambda. One more example.

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

Now I am going to use that same example with Lambda.

现在我使用 Lambda 表达式来表现同一个例子。

```
public interface Add{
    int add(int a, int b);
}

private Add add = (a, b) -> a+b;

int sum = add.add(1,2);
```

Now you can saw how much concise code I wrote. In functionality both are same. I am not mentioning any return type, due to type inference Java automatically determine that has int data type. Now If I have more then one line code in add implentation then I need to metion as shown below.

现在可以看到我写的代码有多简洁了。它们的功能是一样的。我没有提及任何返回的数据类型，因为 Java 的类型引用自动帮我决定了这是一个整型。现在，如果我想添加更多的代码到 add 方法的实现中，我需要提及如下所示。

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

Now we know Functional Interfaces, Default Methods in Interface, Higher Oder Functions, Side Effects in Functions, Pure Functions, Lambda Expression and Functional Programming.

现在我们知道函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程和 Lambda 表达式。

Conclusion:

结论：

Good work guys. Today we achieve a very big milestone in Rx. Next post [War against Learning Curve of Rx Java 2 + Java 8 Stream [ Android RxJava2 ] ( What the hell is this ) Part4](http://www.uwanttolearn.com/android/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4/). Till now we know Observer Pattern, Pull vs Push, Reactive vs Imperative, Functional Interfaces, Default Methods, Higher Order Functions, Side Effects in Functions, Pure Functions, Lambda Expression and Functional Programming. In my opinion if you know all these terms then Rx learning curve is very very easy. Now I have a feeling we know all these terms so Rx learning curve is very easy for all of us.

Guys have a nice weekend. We will met in next week with more good stuff. BYE BYE.

大家都太棒了。今天我们在 Rx 学习中有了非常大的里程碑。下一篇文章是 [War against Learning Curve of Rx Java 2 + Java 8 Stream [ Android RxJava2 ] ( What the hell is this ) Part4](http://www.uwanttolearn.com/android/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4/)。到现在为止，我们了解了观察者模式，拉模式与推模式，响应式与命令式，函数式接口，默认方法，纯函数，函数的副作用，高阶函数，可变的和不可变的，函数式编程和 Lambda 表达式。我认为，如果你都了解了上述名词，Rx 的学习将会越来越简单。现在我感觉你们都已经了解了，所以接下来 Rx 的学习对于我们都会更简单。

祝你们有个愉快的周末。让我们下周再见吧。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
