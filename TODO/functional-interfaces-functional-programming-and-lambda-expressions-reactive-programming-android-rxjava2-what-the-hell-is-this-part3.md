> * 原文地址：[Reactive Programming [ Android RxJava2 ] ( What the hell is this ) Part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

## Functional Interfaces, Default Methods, { Higher Order – Pure – Side Effects in } + Functions, Im + { Mutable } , Lambda Expression & Functional Programming – Reactive Programming [ Android RxJava2 ] ( What the hell is this ) Part3 ##


WOW, we got one more day so its time to make this day awesome by learning something new .

Hello guys, hope you are doing good. This is our third post in series of RxJava2 Android [ [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/), [part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/) ]. In this post we are going to discuss about Functional Interfaces, Functional Programming, Lambda expressions and may be something bonus related to Java 8. Which will be helpful for everyone in near future.

**Motivation:**

Motivation is same which I share with you in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/). Lambda expressions, Functional programming, High Order Functions and blah blah blah always give me tough time specially when I am doing work in Java because every body know’s Java is Object Oriented Programming. So how Java can support Functional Paradigm. Then what is the role of Lambda expressions in Functional Programming. To make every thing clear and easy just like nothing, I will start from Functional Interfaces. One important point, my promise with you guys. I am 100% sure as you follow this part. In the end you will be comfortable with all the terms which we are listening in these days a lot. Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions. I have a feeling lot of people are using Lambda expression in these days but may be after completing this post they know what is really Lambda expressions. Its time to ATTACK.

**Revision:**

In [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/) we discuss the most important, basic and core concept of Rx and that is a Observer Pattern. In [part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/) we discuss about Pull vs Push and Imperative vs Reactive programming.

**Introduction:**

Today we are going to clear all confusions about Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions. So guys I am not going to start from Lambda Expressions instead I am going to start from Functional Interfaces.

**Functional Interface:**

In simple words. *Functional Interface is an interface having one abstract method*. Simple no more confusions. Again, *any interface have only one abstract method is called Functional Interface*. Here I want to share some knowledge, which is not the part of this series but that is good if you know specially for interviews. If you read my definition. I used abstract keyword but we already know interface has always abstract methods. So that is before Java 8. In Java 8 we can define one method in interface and that is called default method like shown below.

```
public interface Account {

   void name();

   default void showTyepOfAccount(){
      System.out.println("Don't know :(" );
   }
}
```

Now I am going to revise the definition. Functional Interface is an interface having one abstract method.

So now if I ask you the above interface is a Functional Interface or not. What will be your answer. According to definition. Answer should be No but that is a valid Functional Interface. Why…

Now if interface use default method or may be try to use any method of **java.lang.Object** into interface. That interface remain Functional Interface because **java.lang.Object** methods will not count. Just like I am showing you one valid Functional Interface below.

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

```
public interface Do {
   
    void why();
   
    void sorry(); 
}
```

I think you grasp the concept of Functional Interface. Guys that is a really core concept of Lambda expression so try to remember this concept.

Some examples of Functional Interfaces which currently we are using in our daily development.

```
public interface **Runnable** {
    public abstract void **run**();
}

public interface **OnClickListener** {
    void **onClick**(View v);
}
```

Now its time to show you Comparator interface in Java 7 and 8  both are valid Functional Interfaces.

In Java 7 Comparator:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.23.27-AM-300x171.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.23.27-AM.png)

In Java 8:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.25.44-AM-1024x773.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.25.44-AM.png)[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.29.23-AM-1024x650.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.29.23-AM.png)

Do not confuse guys. Again both are valid Functional Interfaces. Only remember three things about Functional Interface.

Only one abstract method – May have default methods – May use java.lang.Object methods

If any interface pass these three points that is a valid Functional Interface otherwise no.

In java 8 there is a whole new package **java.util.function.** In this package all interfaces are Functional Interfaces. That package is useful when we are working with Streams API. Which we will learn as a bonus when we will start Rx Android.

One very important point. Guys as we are going to start working with Rx Android. We will play a lot with these Functional Interfaces. Basically in Android we are dependent on Rx Java and Rx Android. Now I am going to show you package of Rx Java 1.0 and 2.0 Functional Interfaces. No need to remember this thing and no need to take tension that is only general knowledge. Only try to remember the concept of Functional Interface. These will automatically remember to you when we start working together on Rx.

RxJava 1:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.27-AM-120x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.27-AM.png)RxJava2:

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.49-AM-182x300.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-04-at-9.56.49-AM.png)

WOW. Its time to celebrate now we know what is a Functional Interfaces, what are default methods in Java 8. As I write in introduction about the terms, which we are going to discuss in this post, two are gone .
Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions.

**Functional Programming:**

Truly saying I mostly work with Java and C++ and both are imperative not pure functional. So I am going to try my best to clear all confusions which I faced but if I am wrong some where please forgive me and update me in comments. So I will update my post.

Guys before going into boring definitions. I am going to revise some of our college or school days concepts. Which is really helpful here to clear all the ambiguities about the remaining terms.

Every body who is doing development know functions. But currently try to forget everything about programming and go back to college or school days. ——————- School Days, Present Madam.

Good boy.

Now what is a function in math class. [Guys for the time being forget all knowledge which you have related to functions in Java or C++ or in any language.]

What is a function? A function related an input to output. Boring ok forget.

How many people know about the below sentence.

f(x) = x+3

if x = 2 what will be the answer.

f(x) equal to y.

y = x+3

x = 2

y = 2+3

y = 5

So basically f(x) = x+3 is a function. Which always give you same output for same input.

One more example.

How many people remember.

Sin(x) [ Trigonometry ]

We remember. Every time in school life when I gave theta value 45 degree. I get answer 1/2 like shown       below.

y = Sin(45deg)

y = 1/2

Later I used this same function in college and university. Every time when I have same input I got same result. That is called pure functions. I will explain more later.

Here we revise some functions which we use a lot in our school or college life. Now when we use the same concept in programming. That is called Functional Programming. Do not take tension I am going to explain now. We are back from childhood memories.

First need to discuss some confusion. Like when we start programming we start like. Write a function which will calculate area of a circle.

```
public double areaOfACircle(int radius){
    return radius*radius*3.14;
}
```

Good. Now as I am going more professional my definition of function is changed. Like write a currency converter of USD into PKR.

```
public float convertUSDIntoPKR(int USD){
    return USD*getTodayPKRValueFromAPI();
}
```

In Programming that is a function but in math. There is some issue because in math we always say. Same input always give you same output. But our function may give your different output on same input because that is dependent upon the external value. So here I am going to introduce a one more term. That is called a Pure function. In Math we always know every function is a pure function just like Sin() but in our programming languages we have a lot of functions which always give us a different value. So for that we introduce a new term called a Pure function in programming.
*A pure function is a function where the return value is only determined by its input values, without observable side effects.*

One more term side effect. Any function which is not pure is called a impure function which may have a side effect. Or may be there is some function which is pure but if we can see any side effect in that then we are not able to say that is a Pure function.

First impure function like Random. This always give you different value for same seed.

Side effect like println() is an impure because it causes output to an I/O device as a side effect. In any function which is pure but I used println() note that function is not remain pure function due to side effect.

Some examples:

Pure:

```
public int squre(int x){
    return x*x;
}
```

Impure due to Side Effect:

```
public int squre(int x){
    System.out.println(x*x);
    return x*x;
}
```

Impure:

```
public void login(String username, String password, Callback c){
    API.login(username, password, callback); 
}
```

Now we grasp two more terms. Pure functions and Side effect.
Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions.

Next we are going to discuss Mutable and Immutable. In mathematics as we remember every time when I gave my value to some function. I always get the new value and my original value remain same. But in programming that concept has changed so that’s why we have two different definitions. Mutable and Immutable. In OO we mostly use to break immutability. Which may cause a lot of issue but in Functional Programming that always used immutability. Like every body know in Java String is Immutable.

```
String s = "Hello";
s = "World";
```

Here our original String never changed. Yes in second line I created a new String and assign that to my s object.

So what is mutable. One example.

```
int array []= {1,2,3,4,5};
for (int i = 0; i < array.length; i++) {
    array[i] = array[i] * 2;
}
```

In Java or in imperative programming if I call above code that is basically mutable. That changed my original array values. But in Functional Programming if I do the same thing I always get a new array with multiplied values and I have the original data remain unchanged.

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

Now may be you are thinking what is the benefit of this. So I am going to explain here one example. If I know all my functions are Pure and Immutable I can do lot of things without taking care of my data state. For example I am going in threading.

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

```
        1
        4
        9
        16
        25
```

But when I run I got the below output.

```
        4
        9
        16
        25
        36
```

This is wrong or actual output. Because I am not taking care of my mutability. Now I am going to right a proper Functional program. In which I will manage my immutability.

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

After running this example my expected and actual both outputs are same because here my program is not doing changes directly in array instead that is creating a copy of my data. So that’s why I can say my array is immutable. I also used Rx so for that sorry but from now I will add little bit Rx in my examples. I will explain you in next post but trust on me. That is a Functional Program in which I have one Pure Function square and my array is not mutated because I am using Functional Paradigm.

Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions, Higher Order Functions, Mutable and Immutable, Functional Programming and Lambda expressions.

Now its time to clear our ambiguity about Higher Order Functions (HOF).

*A function with at least one parameter of type function or a function that returns function is called a higher order function*.

Hmm that is really easy and we use a lot this concept in our Rx programming. Before Java 8 that is little bit difficult to show you HOF but we can use anonymous class as a HOF. We are mostly used this concept in C++. Where I can send function as a parameter. In Android like I am going to add a Click listener with anonymous class. So you can say that is an example of HOF. I will explain more when we are in Rx post.
Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions,Higher Order Functions,Mutable and Immutable, Functional Programming and Lambda expressions.

Now if we are using these concepts which we discuss Pure Functions, HOF, Immutable in any language you can say we are following Functional Paradigm. That is a Functional Programming. In OO we mostly manage the states but in Functional we have data and we do computation by taking care of immutability.

Functional Interfaces, Default Method, Pure Functions, Side Effects in Functions,Higher Order Functions,Mutable and Immutable,Functional Programming and Lambda expressions.

Hurray we cleared our lot of ambiguities related to Functional Programming. Now its time to finish our this post by learning last thing Lambda Expressions.

Before going to Lambda’s I want to revise what we did till now.

Functional Interface – an interface having one abstract method.

Default Method – In Java 8 we can define methods in interface these are called Default Method.

Pure Function –  A function, where the return value is only determined by its input values, without observable side effects.

**Lambda Expressions:**

“*lambda expression in computer programming, also called anonymous function, a function (or a subroutine) defined, and possibly called, without being bound to an identifier*” (Wiki)

First and most important thing. RxJava is not dependent on Lambda’s. Instead Functional Programming has no relationship with Lambda’s as you already saw in all of my above examples I never mentioned I used lambda may be on some places IDE converted my code to lambda but we can do everything without lambda. Then questions is why in every blog of Rx or Functional Programming we saw lambda expressions as a core part of the blog. In my opinion, you can think they are simple, improved syntax form of anonymous functions.

There is some prerequisite which I am going to explain you before going into more detail about Lambdas. As we already know Java is a static type language. Its mean all java program objects and variables always know about there data type at compile time. For example code as shown below.

```
int i = 1;
float j = 3;
Person person = new Person();
String s = "Hello";
```

In a same way before Java 7 we are going to use Collections we need to write a complete List of initialization like shown below.

```
List<String > list = new ArrayList<String >();
```

But in Java 7 we got Type Inference concept. By using that one we can write concise code just like shown below.

```
List<String > list = new ArrayList<>();
```

So basically now compiler will determine the type by using the context at compile time. In that way we can save a lot of time.

Guys again, type inference is very very important. So try to focus on this thing. In Lambda expressions, we are using a lot and lot of people confused due to lake of this concept.

Going again to describe this same concept by taking different example.

I have a one method in which I will send integer as param and that method will return me that same value without changing any thing like as shown below.

```
public static void main(String [] args){
    System.out.println(**giveMeBack(1)**);
}

public static int  **giveMeBack**(int a){
    return a;
}
```

This is a simple example. Now I want to give 3.14 to this method. So guys any body tell me what will happen?

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.23.34-PM-300x227.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.23.34-PM.png)

Yes you are write program is not able to compile as shown above. I already mentioned that method only take Integer. Next my requirement is, I need to write this function for all data types. Now as a developer I am a lazy guy. I don’t want to write a same code again and again. Here I am going to take benefit of Java inference.

```
public static<T> T  giveMeBack(T a){
    return a;
}
```

This is also called generics. Now by using generics I save my lot of time. I can use this method for any data type as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.27.35-PM-300x164.png) ](http://www.uwanttolearn.com/wp-content/uploads/2017/02/Screen-Shot-2017-02-19-at-3.27.35-PM.png)

Now here I get a benefit from Java inference. How? As compiler, compile my program, that easily generate a code for my all these data types. Now compiler can easily determine from my param data type. So there is no magic. Every time when I am not mentioning the data type most probably compiler will take the context and assign the datatype according to the context because Java is a static type language.

Repeat. Java is a static type language. So if you feel in IDE you are writing some code which did not have any type or may be you think you are going as a Dynamic type language. You are wrong, basically you are taking benefit of Java inference.

Now its time to start work on Lambda expressions. Guys important thing currently Lambda expression only support to Java 8. So in Android if we want Lambda expressions we can use one library Retrolambda. Which is good. Now I am going to explain about LambdaExpressions.

In Android I want a one button with Click Listener. So code as shown below.

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

```
Button button = new Button(this);
button.setOnClickListener((View v)->{
    // Click
});
```

Now by using Lambda expressions I made my code concise and easy to read. I am going to make more refactoring to the above example.

```
button.setOnClickListener(v -> /* Click */);
```

I really like to write code as shown above but in start I really confused how compiler know what I am doing here. First thing here we are using the benefit of Java inference. Like on compile time Java automatically know ‘v’ is a View because we have a **functional interface** which contain one method who has one argument and that is a view as shown below.

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

One more example.

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


```
Thread thread = new Thread(()->{});
thread.start();
```

In Java 8 or Rx Java we have a lot of Functional Interfaces because we want to write concise code which is really easy to read and very few words of code achieve big functionalities. Now I think all confusions are clear. Some more important points about Lambda.

If I only want to write a single line of code on Button press I can write my code as shown below.

```
button.setOnClickListener(v -> System.out.println());
```

But If I want to write more then one line of code. Then I need to write in curly braces as shown below.

```
button.setOnClickListener(v -> {
    System.out.println();
    doSomething();
});
```

I can mention data type of my params explicitly as shown below.

```
button.setOnClickListener(**(View v)** -> System.out.println());
```

Now what about return type in Lambda. One more example.

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

```
public interface Add{
    int add(int a, int b);
}

private Add add = (a, b) -> a+b;

int sum = add.add(1,2);
```

Now you can saw how much concise code I wrote. In functionality both are same. I am not mentioning any return type, due to type inference Java automatically determine that has int data type. Now If I have more then one line code in add implentation then I need to metion as shown below.

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

Conclusion:

Good work guys. Today we achieve a very big milestone in Rx. Next post [War against Learning Curve of Rx Java 2 + Java 8 Stream [ Android RxJava2 ] ( What the hell is this ) Part4](http://www.uwanttolearn.com/android/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4/). Till now we know Observer Pattern, Pull vs Push, Reactive vs Imperative, Functional Interfaces, Default Methods, Higher Order Functions, Side Effects in Functions, Pure Functions, Lambda Expression and Functional Programming. In my opinion if you know all these terms then Rx learning curve is very very easy. Now I have a feeling we know all these terms so Rx learning curve is very easy for all of us.

Guys have a nice weekend. We will met in next week with more good stuff. BYE BYE.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
