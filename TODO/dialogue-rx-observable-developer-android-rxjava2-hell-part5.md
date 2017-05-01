> * 原文地址：[Dialogue between Rx Observable and a Developer (Me) [ Android RxJava2 ] ( What the hell is this ) Part5](http://www.uwanttolearn.com/android/dialogue-rx-observable-developer-android-rxjava2-hell-part5/)
> * 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

## Dialogue between Rx Observable and a Developer (Me)  [ Android RxJava2 ] ( What the hell is this ) Part5 ##


WOW, we got one more day so its time to make this day awesome by learning something new 🙂.

Hello guys, hope you are doing good. This is our fifth post in series of RxJava2 Android [ [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/), [part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/), [part3](http://www.uwanttolearn.com/android/functional-interfaces-functional-programming-and-lambda-expressions-reactive-programming-android-rxjava2-what-the-hell-is-this-part3/), [part4](http://www.uwanttolearn.com/android/war-learning-curve-rx-java-2-java-8-stream-android-rxjava2-hell-part4/) ]. In this part we are going to work with Rx Java Android. Our prerequisites are done. So we can start now.

**Motivation:**

Motivation is same which I share with you in [part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/). This time we will see, a lot of things in action which we already learned in last four posts.

**Introduction:**

When I am learning Rx Java Android. One day I met with a Rx Java Observable. So I asked a lot of questions and good news is Observable is really good and down to earth which amazed me. I have a opinion this Rx Java is really bad and full of pride. He/She don’t want to make friendship with lot of developers instead that play with developers and bluff them but after I start my dialogue with him/her I am amazed my opinion is wrong.

Me: Hello Observable. How are you?

Observable: Hi Hafiz Waleed Hussain, I am good. Thank you.

Me: Why your learning curve is really tough? Why you are not easy for developers? You don’t want to make friendship with Developers.

Observable: Haha. Truly saying. I really want to make lot of friends instead I have some very good friends. Which discuss about me on different forums and they are talking about me and my powers. These guys are really good in lot of things, they are spending a lot of hours with me. So for a good friend ship you need to give your time with sincerity. But there is one issue, some developers wants  to make friendship with me but they are not sincere. They start working on me but after some minutes they open social websites and forgot me about hours. So how you can expect from me, I will be a good friend of a developer who is not sincere with me.

Me: Okay If I want to make a friendship with you. What I will do?

Observable: Do a proper focus on me. Give me proper time then you will see how frankly I am.

Me: Hmm. Honestly I am not good in focus but I am good in ignoring. Can I use my ignoring power.

Observable: Yes, if you ignore everything except me when you are working on me. I will be a your good friend.

Me: Wow. I have a feeling then I can make you my friend.

Observable: Yes any body can make me his best friend.

Me: Now I have some questions. Can I ask?

Observable: Yes you can ask thousands of questions. I will give you answer but one important thing I need your time with sincerity.

Me: Sure. If I have a some data and I want to convert that into Observable. How I can achieve that in Rx Java 2 Android.

Observable: This question which you asked me has a very long answer. If you go inside of me (Rx Java 2 Observable class). You will know I have total **12904** lines of code.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-8.54.00-AM-1024x527.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-8.54.00-AM.png)

Every method will return you Observable. Yes I have a lot of friends in my community which I use to make my self according to Developer requirement like map, filter and more but I am here going to share with you some methods which will help you to make any thing as Observable. Sorry because I have a feeling answer will be long but that will not be boring. I will not only show you methods to create Observable instead I will share with you how you refactor your current data objects to Observable with suitable method.

1. just():

By using this method you can convert any object(s) into Observable that emit that object(s).

```
    String data = "Hello World";
    Observable.just(data).subscribe(s -> System.out.println(s));
    Output:
    Hello World
```

If you have more then one data objects you can use same API like shown below.

```
    String data = "Hello World";
    Integer i = 4500;
    Boolean b = true;
    Observable.just(data,i,b).subscribe(s -> System.out.println(s));
    Output:
    Hello World
    4500
    true
```
Maximum you can use 10 data objects in this API.

```
    Observable.just(1,2,3,4,5,6,7,8,9,10).subscribe(s -> System.out.print(s+" "));
    Output:
    1 2 3 4 5 6 7 8 9 10

```

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-9.34.10-AM-1024x180.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-9.34.10-AM.png)

Example in code: ( Not good one but may be you will get some direction, how to use in your code)

```
    public static void main(String[] args) {
        String username = "username";
        String password = "password";
        System.out.println(validate(username, password));
    }
    
    private static boolean validate(String username, String password) {
    boolean isUsernameValid = username!=null && !username.isEmpty() && username.length() > 3;
    boolean isPassword = password!=null && !password.isEmpty() && password.length() > 3;
    return isUsernameValid && isPassword;
}

```    
 

Using Observable:

```
private static boolean isValid = true;
private static boolean validate(String username, String password) {
    Observable.just(username, password).subscribe(s -> {
        if (!(s != null && !s.isEmpty() && s.length() > 3)) 
           throw new RuntimeException();
    }, throwable -> isValid = false);
    return isValid;
}
```  


2. from… :

I have a lot more API to convert your complex data structure into Observable which starting keyword is from as shown below.

[![](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-10.02.40-AM-1024x187.png)](http://www.uwanttolearn.com/wp-content/uploads/2017/03/Screen-Shot-2017-03-18-at-10.02.40-AM.png)

I think API name are really meaning full so no need for more explanation. Yes I will give some examples so you are comfortable when you are using in code.

```
public static void main(String[] args) {

    List<Tasks> tasks = Arrays.asList(new Tasks(1,"description"),
            new Tasks(2,"description"),new Tasks(4,"description"),
            new Tasks(3,"description"),new Tasks(5,"description"));
    Observable.fromIterable(tasks)
            .forEach(task -> System.out.println(task.toString()));
}

private static class Tasks {
    int id;String description;
    public Tasks(int id, String description) {this.id = id;this.description = description;}
    @Override
    public String toString() {return "Tasks{" + "id=" + id + ", description='" + description + '\'' + '}';}
}
}
```

    
From array:

```
    public static void main(String[] args) {
        Integer[] values = {1,2,3,4,5};
        Observable.fromArray(values)
                .subscribe(v-> System.out.print(v+" "));
    }

```

Here two examples are enough. You can try others on your own.

3. create():

You can define any thing you want as an Observable. This API will give you a lot of power but in my opinion before going to use this API try to search some other solution because I have a feeling 99% times you can get solution from my other API’s. If you are not able to get any solution of something then you can use.

```
    public static void main(String[] args) {
        final int a = 3, b = 5, c = 9;
        Observable me = Observable.create(new ObservableOnSubscribe<Integer>() {
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

That is just like a for loop as shown below in code.

```
    public static void main(String[] args) {
        Observable.range(1,10)
                .subscribe(i-> System.out.print(i+" "));
    }
    Output:
    1 2 3 4 5 6 7 8 9 10
```

One more real example:

```
public static void main(String[] args) {

    List<String> names = Arrays.asList("Hafiz", "Waleed", "Hussain", "Steve");
    for (int i = 0; i < names.size(); i++) {
        if(i%2 == 0)continue;
        System.out.println(names.get(i));
    }

    Observable.range(0, names.size())
            .filter(index->index%2==1)
            .subscribe(index -> System.out.println(names.get(index)));
}
```
    

5. interval():

This one is awesome. I am showing you one example in which you can compare two approaches. For first one I used a Java thread and for a second one I used my own interval() API and both have same result.

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

One more good API. In program if I want some thing will called after one second I can use timer Observable as shown below.

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

This is useful specially in mocking. This create Observable that emit nothing and complete. I am showing you one example in which if tests are running then send me mock data else the real one.

```
public static void main(String[] args) throws InterruptedException {
    hey(false).subscribe(o -> System.out.println(o));
}

private static Observable hey(boolean isMock) {
    return isMock ? Observable.empty() : Observable.just(1, 2, 3, 4);
}
```

7. defer():

This is very use full in many cases. I am going to explain this one by using one example as shown below.

```
public static void main(String[] args) throws InterruptedException {
    Employee employee = new Employee();
    employee.name = "Hafiz";
    employee.age = 27;
    Observable observable = employee.getObservable();
    employee.age = 28;
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
    

What will be the output of the above code. If your answer is age should be 28 then you are wrong. Basically all creation methods of Observable will take the value which is available at the time of creation. Like if I do output I will get 27 because I create an Observable at that time when I have age 27 and later I change to 28 but observable already created. So what will be the solution? Yes you can use defer API. That is really helpful. When you use defer basically what happen Observable only created when you will subscribe so its mean by using this I will get my expected result.

```
Observable getObservable(){
  //return Observable.just(name, age);
  return Observable.defer(()-> Observable.just(name, age));
}
```

Now this time my age on output is 28.

8. error():

Again useful to generate error signal. I will share with you when we will discuss about the Observer and there methods.

9. never():

This API emit nothing.

Me: Wow. Thank you Observable. For a long and robust answer. I will use that as a cheat sheet for me. Observable can you convert any function as a Observable.

Observable: Yes. Check below code.

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
 
Me: Wow you are really powerful. Currently I want to ask you about operators like map, filter and more. But if you want to share with me about Observable creation. Which I am not able to ask you due to lack of knowledge please share with me.

Observable: There is a lot. But I think I can explain here about two types of Observables. One is called Cold Observable and the second one is called Hot Observable. In Cold …

Conclusion:

Hello Friends. This dialogue is very very long but I need to stop some where. Otherwise this post will be like a giant book which may be ok but the main purpose will be die and that is, I want we should learn and know everything practically. So I am going to pause my dialogue here I will do resume in next part. Only try your best to play with all these methods and if possible try to take your real world projects and refactor these for practice. In the end I want to say thanks to Rx Observable who give me a lot of his/her time.

Happy Weekend Friends Bye. 🙂
---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
