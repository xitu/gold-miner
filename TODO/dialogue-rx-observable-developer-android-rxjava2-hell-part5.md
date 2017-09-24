> * 原文地址：[Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part5](http://www.uwanttolearn.com/android/dialogue-rx-observable-developer-android-rxjava2-hell-part5/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[龙骑将杨影枫](https://github.com/stormrabbit)
> * 校对者：[Phoenix](https://github.com/wbinarytree)、J[erryMissTom](https://github.com/JerryMissTom)


## 开发者（也就是我）与Rx Observable 类的对话 [ Android RxJava2 ] ( 这到底是什么？) 第五部分 ##

又是新的一天，是时候学点新东来西来让今天变得酷炫了🙂。

大家好，希望你们都过的不错。这是我们 RxJava2 Android 系列的第五篇文章 [ [part1](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md), [part2](https://github.com/xitu/gold-miner/blob/master/TODO/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2.md), [part3](https://github.com/xitu/gold-miner/blob/master/TODO/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3.md), [part4](https://github.com/xitu/gold-miner/blob/master/TODO/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4.md) ] 。在这篇文章中，我们会继续研究 Rx Java Android 。

**动机**：

动机和我在第一部分 [part1](https://github.com/xitu/gold-miner/blob/master/TODO/reactive-programming-android-rxjava2-hell-part1.md) 中分享给大家的一样。现在我们把之前 4 篇学到的东西融会贯通起来。

**介绍：**

当我在学习 Rx java Android 的某一天，我有幸与一位 Rx Java 的 Observable 类进行了亲切友好的交谈。好消息是 Observable 类很厚道，令我惊叹不已。我一直以为 Rx Java 是个大坑逼。他/她不想和开发者做朋友，总给他们穿小鞋。
但是在和 Observable 类谈话以后，我惊喜的发现我的观点是错的。

我：你好，Observable 类，吃了嘛您？

Observable 类：你好 Hafiz Waleed Hussain ，我吃过啦。


我：为啥你的学习曲线这么陡峭？为啥你故意刁难开发者？你这么搞要没朋友了。

Observable 类：哈哈，你说的是。我真想交很多朋友，不过我现在也有一些好哥们儿。他们在不同的论坛上讨论我，介绍我和我的能力。而且这些家伙真的很棒，他们花了很久的时间和我呆在一起。只有精诚所至，才会金石为开。但问题是，很多想撩我的人只走肾不走心。他们关注我了一小会就去刷推特脸书，把我给忘了。所以说，对我不真诚的人又如何指望我和他们交朋友呢？

我：好吧，如果想和你交朋友的话，我该怎么做？

Observable 类：把注意力集中在我身上，并且坚持足够长的时间，然后你就知道我有多真诚了。

我：嗯，实话实说我不擅长集中精神，但是我擅长无视周围。这样可以嘛？

Observable 类：当然，只要你和我在一起的时候可以心无旁骛，我会是你的好朋友的。

我：哇哦，我有种预感，我会和你交上朋友的。

Observable 类：当然，任何人都可以把我当好朋友。

我：现在我有些问题，可以问了嘛？

Observable 类：当然，你可以问成千上万个问题。我会给你答案，但是重要的是需要你自己花时间去思考和吸收。

我：我会的。如果我想把数据转化为 Observable 对象，在 Rx Java 2 Android 里怎么实现？

Observable 类：这个问题的答案很长很长。如果你来看我（Rx Java 2 Observable 类）的源码，你就会发现我一共有12904行代码。**（校对 wbinarytree 注：在 RxJava 2.0.9 版本。Observable 类已经成功增肥到 13728 行。）**

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-8.54.00-AM-1024x527.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-8.54.00-AM.png)


我的团队里也有好几个朋友，可以根据开发者的需求返回 Observable 对象，比如 map ，filter。不过现在我会告诉你几个可以帮助你把任何东西转化为 Observable 对象的方法。抱歉我的回答可能会很长，但是也不会很无聊。我不仅仅会演示这些方法如何创建 Observable 类，同时也会向你展示如何对手头边代码进行重构。

1. just():

通过这个方法，你可以把任意（多个）对象转化成以此对象为泛型的 Observable 对象（ Observable<T> ）。

```
String data= "Hello World";
    Observable.just(data).subscribe(s -> System.out.println(s));
Output:
    Hello World
```


如果你的数据不止一个，可以像下面那样调用 just 方法 ：

```
String data= "Hello World";
Integer i= 4500;
Boolean b= true;
    Observable.just(data,i,b).subscribe(s -> System.out.println(s));
Output:
    Hello World
    4500
    true
```

此 API 最多可接收 10 个数据做参数。

```
    Observable.just(1,2,3,4,5,6,7,8,9,10).subscribe(s -> System.out.print(s+" "));
Output:
    1 2 3 4 5 6 7 8 9 10

```

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-9.34.10-AM-1024x180.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-9.34.10-AM.png)


样例代码：（不是个好例子，只是给点提示，提示你如何在自己的代码中使用）

```
    public static void main(String[] args) {
String username= "username";
String password= "password";
        System.out.println(validate(username, password));
    }

    private static boolean validate(String username, String password) {
boolean isUsernameValid= username!=null && !username.isEmpty() && username.length() > 3;
boolean isPassword= password!=null && !password.isEmpty() && password.length() > 3;
    return isUsernameValid && isPassword;
}

```


使用 Observable 类进行重构：

```
private static boolean isValid= true;
private static boolean validate(String username, String password) {
    Observable.just(username, password).subscribe(s -> {
if (!(s != null && !s.isEmpty() && s.length() > 3))
           throw new RuntimeException();
}, throwable -> isValid= false);
    return isValid;
}
```


2. from…:


我有一大堆的 API 可以把复杂的数据结构转化为 Observable  对象，比如下面那些以关键字 from 开头的方法：

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-10.02.40-AM-1024x187.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-10.02.40-AM.png)


我想这些 API 从名字就可以看懂它们的意思，所以也不需要更多解释了。不过我会给你一些例子，这样你可以在自己的代码里用的更舒服。

**（校对 wbinarytree 注:
虽然 fromCallable, fromPublisher, fromFuture 也是 from 开头的方法。但是他们互相之间区别很大。尤其是 fromCallable 和 fromPublisher。）**

```
public static void main(String[] args) {

List<Tasks> tasks= Arrays.asList(new Tasks(1,"description"),
            new Tasks(2,"description"),new Tasks(4,"description"),
            new Tasks(3,"description"),new Tasks(5,"description"));
    Observable.fromIterable(tasks)
            .forEach(task -> System.out.println(task.toString()));
}

private static class Tasks {
    int id;String description;
public Tasks(int id, String description) {this.id= id;this.description = description;}
    @Override
public String toString() {return "Tasks{" + "id=" + id + ", description='" + description + '\'' + '}';}
}
}
```


从数组转化为 Observable 对象

```
    public static void main(String[] args) {
Integer[] values= {1,2,3,4,5};
        Observable.fromArray(values)
                .subscribe(v-> System.out.print(v+" "));
    }

```


两个例子就够啦，回头你可以亲自试试其他的。

3. create():


你可以把任何东西强行转为 Observable 对象。这个 API 过于强大，所以个人建议使用这个API之前，应该先找找有没有其他的解决方式。大约99%的情况下，你可以用其他的 API 来解决问题。但如果实在找不到，那么就用它也可以。

**(校对 wbinarytree 注：这里可能作者对 RxJava 2 的 create 还停留在 RxJava 1 的阶段。 RxJava 1.x 确实不推荐 create 方法。而 RxJava 2 的 create 方法是推荐方法。并不是 99% 的情况都可以被取代。 RxJava 1.x 的 create 方法现已经成为 RxJava 2.x 的 unsafeCreate ，RxJava 1.2.9 版本也加入了新的安全的 create 重载方法。)**

```
    public static void main(String[] args) {
final int a= 3, b = 5, c = 9;
Observable me= Observable.create(new ObservableOnSubscribe<Integer>() {
            @Override
            public void subscribe(ObservableEmitter<Integer> observableEmitter) throws Exception {
                observableEmitter.onNext(a);
                observableEmitter.onNext(b);
                observableEmitter.onNext(c);
                observableEmitter.onComplete();
            }
        });
        me.subscribe(i-> System.out.println(i));
    }

```
4. range():


这就像是一个 for 循环，就像下面的代码显示的那样。

```
    public static void main(String[] args) {
        Observable.range(1,10)
                .subscribe(i-> System.out.print(i+" "));
    }
Output:
    1 2 3 4 5 6 7 8 9 10
```


再来一个例子：

```
public static void main(String[] args) {

List<String> names= Arrays.asList("Hafiz", "Waleed", "Hussain", "Steve");
for (int i= 0; i < names.size(); i++) {
if(i%2== 0)continue;
        System.out.println(names.get(i));
    }

    Observable.range(0, names.size())
.filter(index->index%2==1)
            .subscribe(index -> System.out.println(names.get(index)));
}
```


5. interval():


这个 API 碉堡了。我用两种方法实现同一种需求，你可以比较一下。第一种我用 Java 的线程来实现，另一种我用 interval() 这个 API ，两种方法会得到同一个结果。

**（校对 wbinarytree 注：interval() 会默认在 Scheduler.computation() 进行操作。）**

```
public static void main(String[] args) {
    new Thread(() -> {
        try {
            sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        greeting();
    }).start();

    Observable.interval(0,1000, TimeUnit.MILLISECONDS)
            .subscribe(aLong -> greeting());
}

public static void greeting(){
    System.out.println("Hello");
}
```

6. timer():

又是一个好的 API。在程序中如果我想一秒钟后调用什么方法，可以用 timer ，就像下面展示的那样：

```
public static void main(String[] args) throws InterruptedException {
    Observable.timer(1, TimeUnit.SECONDS)
            .subscribe(aLong -> greeting());
    Thread.sleep(2000);
}

public static void greeting(){
    System.out.println("Hello");
}
```


7. empty():

这个 API 很有用，尤其是在有假数据的时候。这个 API 创建的 Observable 对象中，注册的 Observer 对象只调用 complete 方法。比如这个例子，如果在测试运行时发送给我假数据，在生产环境下就调用真的数据。

```
public static void main(String[] args) throws InterruptedException {
    hey(false).subscribe(o -> System.out.println(o));
}

private static Observable hey(boolean isMock) {
return isMock ? Observable.empty(): Observable.just(1, 2, 3, 4);
}
```

8. defer():

这个 API 在很多情况下都会很有用。我来用下面的例子解释一下：

```
public static void main(String[] args) throws InterruptedException {
Employee employee= new Employee();
employee.name= "Hafiz";
employee.age= 27;
Observable observable= employee.getObservable();
employee.age= 28;
    observable.subscribe(s-> System.out.println(s));
}

private static class Employee{
    String name;
    int age;
    Observable getObservable(){
        return Observable.just(name, age);
    }
}

```

上面的代码会输出什么呢？如果你的答案是 age = 28 那就大错特错了。基本上所有创建 Observable 对象的方法在创建时就记录了可用的值。就像刚才的数据实际上输出的是 age = 27 ， 因为在我创建 Observable 的时候 age 值是 27 ，当我把 age 的值变成 28 的时候 Observable 类已经创建过了。所以怎么解决这个问题呢？是的，这个时候就轮到 defer 这个 API 出场了。太有用了！当你使用 defer 以后，只有注册（subscribe）的时候才创建 Observable 类。用这个 API ，我就可以获得想要的值。

```
Observable getObservable(){
  //return Observable.just(name, age);
  return Observable.defer(()-> Observable.just(name, age));
}
```


这样我们的 age 的输出值就是 28 了。

**（校对 wbinarytree 注：Observable 的创建方法中，并不是像原文中写到的，“基本上所有创建 Observable 的方法在创建时就记录了可用的值”。而是只有 just, from 方法。 create , fromCallable 等等方法都是在 subscribe 后才会调用。文中的例子可以使用 fromCallable 代替 defer。）**

9. error():


一个可以弹出错误提示的方法。当我们讨论 Observer 类和他的方法的时候，我再和你分享吧。

10. never():


这个 API 创建出的 Observable 对象没有包含泛型。

**（译者注：Observable.never 虽然可以得到一个 Observable 对象，但是注册的对应 Observer 既不会调用 onNext 方法也不会 onCompleted 方法，甚至不会调用 onError 方法）**

我：哇哦。谢谢你，Observable 类。谢谢你耐心又详细的回答，我会把你的回答记在我的秘籍手册上的。话说，你可以把函数也转化成 Observable 对象吗？

Observable 类：当然，注意下面的代码。

 ```
 public static void main(String[] args) throws InterruptedException {
    System.out.println(scale(10,4));
    Observable.just(scale(10,4))
            .subscribe(value-> System.out.println(value));
}

private static float scale(int width, int height){
    return width/height*.3f;
}
 ```

我：哇哦，你真的好强大。现在我想问你有关操作符，比如 map ，filter 方面的问题。但是有关 Observable 对象创建，如果还有什么我因为缺乏知识没问到的地方，再多告诉我一点呗。

Observable 类：其实还有很多。我在这里介绍两类 Observable 对象。一种叫做 Cold Observable，第二个是 Hot Observable。在...

总结：

大家好。这篇对话已经非常非常的长，我需要就此搁笔了。不然这篇文章就会像大部头的书，可能看上去不错，但是主要目的就跑偏了。我希望，我们可以循序渐进的学习。所以我要暂停我的对话，然后在下一篇继续。读者可以试试亲自实现这些方法，如果可能的话在实际的项目中去运用、重构。最后我想说，谢谢 Observable 类给我了这么多他/她的时间。

周末愉快，再见~🙂

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。

