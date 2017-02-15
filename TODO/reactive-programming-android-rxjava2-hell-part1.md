> * 原文地址：[Observer Pattern – Reactive Programming [Android RxJava2] ( What the hell is this ) Part1](http://www.uwanttolearn.com/android/reactive-programming-android-rxjava2-hell-part1/)
* 原文作者：[Hafiz Waleed Hussain](http://www.uwanttolearn.com/author/admin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

## Observer Pattern – Reactive Programming [Android RxJava2]\(What the hell is this) Part1 ##

WOW, we got one more day so its time to make this day awesome by learning something new 🙂.

Hello Guys, hope you are doing good. Today I am going to start a new series of Rx Java2 more specific in Android but first 2-3 posts are general related to reactive programming. Hope we will learn something new and clear our all confusions together.

**Motivation:**

Truly saying I faced a lot of issues when I start learning Rx. I tried lot of tutorials, books but in the end I am not able to start working with Rx in my app. Lot of tutorials confused me, like some are saying as we know iterator pattern which is pull based in a same way Rx is push based and giving some example but that is useless for me at that time. I want to learn Rx, I want to know the benefits, I want to know how this will save me from lot of bugs, lines of boiler plate code but every time I will get push vs pull or some times I will get imperative vs reactive but never got the real Rx answers which I want. On some posts authors are saying, this is just like Observer pattern. With the passage of time confusion increased, learning curve is going very difficult. Later I got some more tutorials on FRP then lambda expressions, functional programming. I got lot of examples in which people are using lambda expressions with calling map, filter blah blah blah functions. But I am on a same page What is Rx and why I choose this paradigm. Later I met with some friends who are using Rx. I ask these guys, can you teach me. They teach me like hey as you know we have a EditText. If you want to check user added any new text. How you will know? I gave answer I will use change listener.

Oh you know the API is really difficult you can use Rx and that will be very easy by using debounce and simple Rx observable but I asked the question only to save from 10 lines of code I will go with Rx. They replied me no. You can use map, filter or lot of other functions to make your code in good shape and easy. I am not convinced because I can make one class that will manage all these things for me if that is the only benefit. On the other side I know Netflix and many other big companies are using this paradigm and there stats are good after using Rx. So I am more confused. The day come when I say ok, done. I am not going with Rx but I know myself. I never quit sometimes I take rest but I never quit. So I decided I already learned a lot of things, in lot of tutorials but that is just like a puzzle blocks for me. So Its time to make that puzzle blocks into a proper shape.

Important point. All those tutorials or books which I read I really want to appreciate there authors because they confused me but also they teach me. So everybody really thanks for writing all tutorials and books.

One important point about my post. I am giving you 100% guarantee. In the end of this tutorial series, you will know 80% about Rx Java2 but do not expect I will start directly from Rx Java2. I will go very slow and from very basics but in the end no body will confused.

Very long motivation but that is important for me. Its time to attack 🙂 .

I am using IntelliJ in this tutorial for coding tasks.

**Introduction:**

One suggestion if you are confused just like me then try to forgot all terms which are mentioned below.

Rx

Observable

Observer

Map

Filter

FlatMap

Lymbda

Higher order functions

Iterator or Pull

Imperative

Reactive

Dataflow

Streams

FRP

etc… oh man.

So we are going to write a one component of a real enterprise application system. Which is our first step to reactive paradigm. Basically that will not give you any information about Rx but that will make some base which we will use in later tutorials.

**Requirement:**

Our client has a website. He wants, when he publish a new tutorial, all members who subscribed will get an email.

**Solution:**

I am not going to implement every thing real but I will implement in a way, so the concept which we want we will grasp easily.

Its time to breakdown our requirement.

1. We have users who are subscribing. Its mean we need to save information about users who subscribed.

2. There should be some database where some row will be inserted when user published a new post. In simple words, on some place our data should be changed when tutorial published. Which we need to take care because when that change I need to inform to my subscribe users.

3. Email client, that is not our focus.

First two points are important. I need to implement something which will achieve these two points functionality.

There are lot of approaches which you can use but I am going with the simplest one according to me. Which will convey my message which I want to share with you.

So we have a one class User which contain only Name and Email of a member. Some people may think, we should have a isSubscribed filed. In my opinion that will make our code complex because then we need to use a loop to determine which are the subscribed users like shown below.

```
public static class User {

    private String name;
    private String email;
    private boolean isSubscribed; 

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public boolean isSubscribed() {
        return isSubscribed;
    }

    public void setSubscribed(boolean subscribed) {
        isSubscribed = subscribed;
    }
}
```

So If I am using this class then most probably I have some thing in my main method code where I want to send email code like shown below.

```
public static void sendEmail(List<User> userList){

    for (User user : userList) {
        if(user.isSubscribed){
            // send email to user
        }
    }
}
```

But I am going in a different way. So my user class is given below

```
public static class User {

    private String name;
    private String email;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}
```

So I did not have any isSubscribed filed. Its mean when I will call sendEmail function there is no if like shown below.

```
public static void sendEmail(List<User> userList){
    for (User user : userList) {
            // send email to user
    }
}
```

Good. OK now its time to check how I can manage my subscribed users. Basically in this example I am going to take things in Memory so I am going to initialize one list of users. In which, I only save those users, who click subscribed button. If that is in real app then I have one table in database. Its time to show you some more code.

```
private static List<User> subscribedUsers = new ArrayList<>();
```

Imagine we have four users A, B, C and D. All will subscribe except B. So I am going to show you code how I will do that in our main method.

```
public static void main(String[] args){

    User A = new User("A","a@a.com");
    User B = new User("B","b@a.com");
    User C = new User("C","c@a.com");
    User D = new User("D","d@a.com");

    // Now A,C and D click subscribe button

    subscribedUsers.add(A);
    subscribedUsers.add(C);
    subscribedUsers.add(D);
}
```

Now first point is done. In which we need to save information about those users who wants email.

Its time to take care of second point. When user publish new tutorial I want to inform. Here I have one class, Tutorial like shown below.

```
public static class Tutorial{

    private String authorName;
    private String post;

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getPost() {
        return post;
    }

    public void setPost(String post) {
        this.post = post;
    }
}
```

Here again we need a some place where we will save our tutorials. So in real app I should have a table but in this example I am going to initialize one List of Tutorials. Which will save all my old and new tutorials just like shown below.

```
private static List<Tutorial> publishedTutorials = new ArrayList<>();
```

Here I am going to increase complexity of our code :P. For example I have already 3 tutorials Android 1, Android 2 and Android 3.  All users subscribed, after 3 tutorials already published.  Its mean when I will add Android 4 tutorial then all users will get email. First I am going to show you only first part how I am going to add first 3 tutorials and later user will subscribe for email.

```
public static void main(String[] args){

    Tutorial android1 = new Tutorial("Hafiz", "........");
    Tutorial android2 = new Tutorial("Hafiz", "........");
    Tutorial android3 = new Tutorial("Hafiz", "........");

    publishedTutorials.add(android1);
    publishedTutorials.add(android2);
    publishedTutorials.add(android3);

    // I have already three tutorials and later user subscribed for email

    User A = new User("A","a@a.com");
    User B = new User("B","b@a.com");
    User C = new User("C","c@a.com");
    User D = new User("D","d@a.com");

    // Now A,C and D click subscribe button

    subscribedUsers.add(A);
    subscribedUsers.add(C);
    subscribedUsers.add(D);
}
```

Now the most important point comes. Now I published fourth tutorial as shown below.

```
public static void main(String[] args){
    //Ignore the below code up to bold lines start
    Tutorial android1 = new Tutorial("Hafiz 1", "........");
    Tutorial android2 = new Tutorial("Hafiz 2", "........");
    Tutorial android3 = new Tutorial("Hafiz 3", "........");
    publishedTutorials.add(android1);
    publishedTutorials.add(android2);
    publishedTutorials.add(android3);
    // I have already three tutorials and later user subscribed for email
    User A = new User("A","a@a.com");
    User B = new User("B","b@a.com");
    User C = new User("C","c@a.com");
    User D = new User("D","d@a.com");
    // Now A,C and D click subscribe button
    subscribedUsers.add(A);
    subscribedUsers.add(C);
    subscribedUsers.add(D);

   Tutorial android4 = new Tutorial("Hafiz 4", "........");   publishedTutorials.add(android4);

}
```

How I can determine fourth or any new tutorial published so I can send emails.

Hmmm very critical requirement. I am going to implement polling. Polling means I have timer which will check any thing change in my data after some time interval. Here I am going to take an int object which will work for me as a data changed informer as shown below.

```
private static int lastCountOfPublishedTutorials = 0;

```

```
Tutorial android1 = new Tutorial("Hafiz 1", "........");
Tutorial android2 = new Tutorial("Hafiz 2", "........");
Tutorial android3 = new Tutorial("Hafiz 3", "........");

publishedTutorials.add(android1);
publishedTutorials.add(android2);
publishedTutorials.add(android3);
lastCountOfPublishedTutorials = publishedTutorials.size();
polling();
```

Now I got a focus point. Which I need to take care. If this count change its mean something change. In our case that always new tutorial publish so I need to send email. Its time to see how I implement Polling.

```
private static void polling(){

    Polling polling = new Polling();
    Timer timer = new Timer();
    timer.schedule(polling, 0,1000);

}
```

This method will call when server start or in our case when main method called. This method always active and after one second will check my data as changed or not shown below.

```
public static class Polling extends TimerTask{

    @Override
    public void run() {

        if(lastCountOfPublishedTutorials < publishedTutorials.size()){
            lastCountOfPublishedTutorials = publishedTutorials.size();
            sendEmail(subscribedUsers);
        }
        System.out.println("Polling");
    }
}
```

Very simple. I am only checking if count changed then update count and send email to all subscribed users. Output on IDE shown below

---

Polling

Email send: A

Email send: C

Email send: D

Polling

Polling

Polling


Done. Everything which is given by client is done but its time to review our approach. I think polling is really bad. Any thing else which we can use?

Yes we can. Its time to use second approach to achieve this functionality.

Now I am going to change some code in our classes. Guys I am again going from very basic so currently no interfaces, nothing abstract every thing will be concrete. In the end I will do little bit refactoring so we can see clear picture like how things are working in Profession Software development.

Its time to see what new changes occurred in Tutorial class as shown below.

```
public static class Tutorial{

    private String authorName;
    private String post;
    public Tutorial() {
    }

    public Tutorial(String authorName, String post) {
        this.authorName = authorName;
        this.post = post;
    }
    
    private static List<Tutorial> publishedTutorials = new ArrayList<>();
    private static List<User> subscribedUsers = new ArrayList<>();

    public static void addSubscribedUser(User user){
        subscribedUsers.add(user);
    }

    public static void publish(Tutorial tutorial){
        publishedTutorials.add(tutorial);
        sendEmail(subscribedUsers);
    }
}
```

In new code, Tutorial class will take care of publish tutorials. Tutorial class will take care of subscribed users. Like you can see **addSubscribedUser **method. Now its time to show you main method code. You can easily compare what are the changes between these two approaches.

```
public static void main(String[] args){

    Tutorial android1 = new Tutorial("Hafiz 1", "........");
    Tutorial android2 = new Tutorial("Hafiz 2", "........");
    Tutorial android3 = new Tutorial("Hafiz 3", "........");

    Tutorial.publish(android1);
    Tutorial.publish(android2);
    Tutorial.publish(android3);
    
    // I have already three tutorials and later user subscribed for email

    User A = new User("A","a@a.com");
    User B = new User("B","b@a.com");
    User C = new User("C","c@a.com");
    User D = new User("D","d@a.com");

    // Now A,C and D click subscribe button

    Tutorial.addSubscribedUser(A);
    Tutorial.addSubscribedUser(C);
    Tutorial.addSubscribedUser(D);
    
    Tutorial android4 = new Tutorial("Hafiz 4", "........");
    Tutorial.publish(android4);

}
```

Now tutorial class is responsible for publishing tutorial. Also that class managing subscription of users. So we remove first polling. Which is a really big achievement. Then developer no more responsible to write logic which will inform any thing change in data so we remove Object **lastCountOfPublishedTutorials**.

That is really awesome. Output is shown below.


Email send: A

Email send: C

Email send: D


I know above output not clear because program exit so I am going to implement one logic which only make our program always run in memory, never exit and also published new tutorial after 1 second. So we can see how emails are going.

Email send: A

Email send: C

Email send: D

Email send: A

Email send: C

Email send: D

Email send: A

Email send: C

Email send: D

…… Never exit


Now its time to find some more good and professional approach. We have any approach?

Yes we have but before that I am going to explain some english terms.

Any body can explain Observable?

In my english. Any thing which can be observe. Like I have a really beautiful tree in my garden. I mostly observe that so its mean tree is observable. Now there is a thunderstorm when I am observing tree. I observed some of there leafs are fallen down due to fast wind. So what is happening. Tree is observable and I am observer. The time when I am observer, I can feel the change in tree. Now I am not alone my wife also with me but she is not observing tree. So when first leave fallen down, I can feel something change but my wife not. Later she also start observing tree. This time when second leave fallen down we both can feel the change. Its mean tree as an Observable, telling to its observers something changed.

If I do the same thing by using polling then what will happen. I count the tree leafs and remember the result. After one second I count again and I compare this result with last result so I feel there is a change but I am doing after every one second. hahahaha In reality I am not able to do.

In first scenario Observable is responsible to inform there observers about change that you can say Push (Rx is Push).

In second scenario my Polling is checking any change then need to inform our users that you can say Pull.

So its time to implement Observable, Observer strategy.

In our app what is Observable? Yes, you are right Tutorials. And who is observing? Yes, Users.

Now I am going to introduce the interfaces which we used in professional software development for Observer pattern.

```
public interface Observer{
    // New tutorial published
    void notifyMe();
}
```

```
public interface Observable{

 void register(Observer observer);

 void unregister(Observer observer);

 // New tutorial published to inform all subscribed users
 void notifyAllAboutChange();
}
```

Now we can see abstract or generic interfaces. Observer and Observable.

In our app User is observer so I will implement Observer interface on that class and Tutorial is Observable so I am implementing Observable to Tutorial class as shown below.

```
public static class User implements Observer{

    private String name;
    private String email;
    public User() {    }
    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }
    public String getName() {   return name;    }
    public void setName(String name) {        this.name = name;    }
    public String getEmail() {        return email;    }
    public void setEmail(String email) {        this.email = email;    }

    @Override
    public void notifyMe() {
        sendEmail(this);
    }
}
```

Now here User will be informed by Tutorial, hey I published new post by calling notifyMe() method.

```
public static class Tutorial implements Observable{

    private String authorName;
    private String post;
    private Tutorial() {};
    public static Tutorial REGISTER_FOR_SUBSCRIPTION = new Tutorial();
    
    public Tutorial(String authorName, String post) {
        this.authorName = authorName;
        this.post = post;
    }
    
 private static List<Observer> observers = new ArrayList<>();
    @Override
    public void register(Observer observer) {
        observers.add(observer);
    }

    @Override
    public void unregister(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyAllAboutChange() {
        for (Observer observer : observers) {
            observer.notifyMe();
        }
    }

    public void publish(){
        notifyAllAboutChange();
    }
}
```

So what changes occur in this class. First I changed User to Observer. So any observer want to know any new tutorial published he can register. In our case that is User because User implemented this interface.

Then register and unregister simple methods which manage the subscription or un subscription.

For register and unregister we are using class level object **REGISTER_FOR_SUBSCRIPTION.** Then **notifyAllAboutChange** method. Which will inform to all observers hey some thing changed. The last method is **publish,** which currently instance level method. Any time I call publish method, all register observers will informed by calling there **notifyMe()** method.

```
public static void main(String[] args){

    Tutorial android1 = new Tutorial("Hafiz 1", "........");
    android1.publish();
    Tutorial android2 = new Tutorial("Hafiz 2", "........");
    android2.publish();
    Tutorial android3 = new Tutorial("Hafiz 3", "........");
    android3.publish();

    // I have already three tutorials and later user subscribed for email
    User A = new User("A","a@a.com");
    User B = new User("B","b@a.com");
    User C = new User("C","c@a.com");
    User D = new User("D","d@a.com");

    // Now A,C and D click subscribe button

    Tutorial.REGISTER_FOR_SUBSCRIPTION.register(A);
    Tutorial.REGISTER_FOR_SUBSCRIPTION.register(C);
    Tutorial.REGISTER_FOR_SUBSCRIPTION.register(D);
    
    Tutorial android4 = new Tutorial("Hafiz 4", "........");
    android4.publish();

}
```

That is really simple no need to explain. Ok guys so now I have a feeling every body will know what is Observable and what is observer. These are really important instead these are the only terms which used 99.9% time in Rx. So if you have clear image what is that you can easily grab the Rx paradigm. Also if you saw we get a really big benefit by using this pattern in our app. Now I am going to change this last code again by using Rx lib. Before start I want to discuss some points.

1. This is not awesome example but I want you should know what Observable, Observer, Pull, Push

2. The functionality which I am going to implement by RxJava is a very very small thing in perspective of Rx benefits.

3. I am not going to explain you any thing about methods which I am going to use. Only try to review code and don’t take tension. In later tutorials you will know everything.

4. Again this is not the only real power of Rx Java. Basically I used this example to make basic ground for me and my friends.

Integrate java rx lib in your project. You can download from [here](https://mvnrepository.com/artifact/io.reactivex/rxjava/1.0.2).

Its time to enjoy how many line of code will remove by using this rx library. Also you can imagine if I want to implement this Observer Patteren on 8 places in my project how much code I need to write which is boilerplate but by using Rx that is nothing.

First I removed Observable and Observer interfaces from my classes.

![Markdown](http://p1.bpimg.com/1949/f26cfb93088350ac.png)

![Markdown](http://p1.bpimg.com/1949/e1de180148389eb9.png)

![Markdown](http://p1.bpimg.com/1949/4e3d085c47acfff5.png)

Now I am going to implement Rx Java lib methods.

User (Observer) class after Rx applying shown below.

```
public static class User **implements Action**1{

    private String name;
    private String email;
    public User() {}
    public User(String name, String email) {
        this.name = name;
        this.email = email;
    }
    public String getName() {return name;}
    public void setName(String name) {this.name = name;}
    public String getEmail() {return email;}
    public void setEmail(String email) {this.email = email;}

    @Override
    public void call(Object o) {
        sendEmail(this);
    }
}
```

We can say Action1 is the helper interface from Rx lib which used for Observers.

Tutorial (Observable) class after Rx applying shown below.

```
public static class Tutorial {

    private String authorName;
    private String post;
    private Tutorial() {}

    public static rx.Observable REGISTER_FOR_SUBSCRIPTION = 
                  rx.Observable.just(new Tutorial());

    public Tutorial(String authorName, String post) {
        this.authorName = authorName;
        this.post = post;
    }
    
    public void publish(){
        REGISTER_FOR_SUBSCRIPTION.publish();
    }

}
```

Wow if we compare this class with old one, we removed a lot of code. What I did here. By using Rx I converted my **REGISTER_FOR_SUBSCRIPTION** to Rx Observable. Now we already know what is Observable. So any observer can subscribed to my Observable and when Observable publish method will called automatically all observers will informed.

Its time to show you main method code.

```
public static void main(String[] args){
    
    Tutorial android1 = new Tutorial("Hafiz 1", "........");
    android1.publish();
    Tutorial android2 = new Tutorial("Hafiz 2", "........");
    android2.publish();
    Tutorial android3 = new Tutorial("Hafiz 3", "........");
    android3.publish();

    // I have already three tutorials and later user subscribed for email
    User A = new User("A","a@a.com");
    User B = new User("B","b@a.com");
    User C = new User("C","c@a.com");
    User D = new User("D","d@a.com");

    // Now A,C and D click subscribe button

    Tutorial.REGISTER_FOR_SUBSCRIPTION.subscribe(A);
    Tutorial.REGISTER_FOR_SUBSCRIPTION.subscribe(C);
    Tutorial.REGISTER_FOR_SUBSCRIPTION.subscribe(D);

    Tutorial android4 = new Tutorial("Hafiz 4", "........");
    android4.publish();

}
```

There is no big difference in main method code block. Output of above code.

---

Email send: A

Email send: C

Email send: D

---

Hurray. Everything working same except we make thing simple and easy in implementation perspective.

**Conclusion:**
As a conclusion. We only try to learn Observer Pattern which is a base of Rx. Second if I ask you I have 8 modules which required notification functionality in a same code. So you need to implement eight times Observer and Observable interfaces and lot of boilerplate code. But by using Rx now you know only called rx.Observable.just() method and that object work like observable. Then any observer can subscribe to that Observable. If you guys are confused again you can forgot the Rx part. Only remember what is Observer Pattern. In next post I will introduce Rx in a proper way by using this concept which we learned today.

All codes are written below. You can copy and past on your IDE and play with these.

OK Guys Bye Bye. Next post [Pull vs Push & Imperative vs Reactive – Reactive Programming [Android RxJava2] ( What the hell is this ) Part2](http://www.uwanttolearn.com/android/pull-vs-push-imperative-vs-reactive-reactive-programming-android-rxjava2-hell-part2/).

.

**Polling Approach:**

```
import java.util.ArrayList;
        import java.util.List;
        import java.util.Timer;
        import java.util.TimerTask;

/**
 * Created by waleed on 04/02/2017.
 */
public class Main {

    private static List<User> subscribedUsers = new ArrayList<>();

    private static List<Tutorial> publishedTutorials = new ArrayList<>();
    private static int lastCountOfPublishedTutorials = 0;

    public static void main(String[] args){

        Tutorial android1 = new Tutorial("Hafiz 1", "........");
        Tutorial android2 = new Tutorial("Hafiz 2", "........");
        Tutorial android3 = new Tutorial("Hafiz 3", "........");

        publishedTutorials.add(android1);
        publishedTutorials.add(android2);
        publishedTutorials.add(android3);
        lastCountOfPublishedTutorials = publishedTutorials.size();

        polling();
        // I have already three tutorials and later user subscribed for email

        User A = new User("A","a@a.com");
        User B = new User("B","b@a.com");
        User C = new User("C","c@a.com");
        User D = new User("D","d@a.com");

        // Now A,C and D click subscribe button

        subscribedUsers.add(A);
        subscribedUsers.add(C);
        subscribedUsers.add(D);

        Tutorial android4 = new Tutorial("Hafiz 4", "........");
        publishedTutorials.add(android4);

    }

    public static void sendEmail(List<User> userList){

        for (User user : userList) {
            // send email to user

            System.out.println("Email send: "+user.getName());
        }
    }

    public static class User {

        private String name;
        private String email;

        public User() {
        }

        public User(String name, String email) {
            this.name = name;
            this.email = email;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }
    }

    public static class Tutorial{

        private String authorName;
        private String post;

        public Tutorial() {
        }

        public Tutorial(String authorName, String post) {
            this.authorName = authorName;
            this.post = post;
        }

        public String getAuthorName() {
            return authorName;
        }

        public void setAuthorName(String authorName) {
            this.authorName = authorName;
        }

        public String getPost() {
            return post;
        }

        public void setPost(String post) {
            this.post = post;
        }
    }

    private static void polling(){

        Polling polling = new Polling();
        Timer timer = new Timer();
        timer.schedule(polling, 0,1000);

    }

    public static class Polling extends TimerTask{

        @Override
        public void run() {

            if(lastCountOfPublishedTutorials < publishedTutorials.size()){
                lastCountOfPublishedTutorials = publishedTutorials.size();
                sendEmail(subscribedUsers);
            }
            System.out.println("Polling");
        }
    }

}

```

**First Refactoring Approach:**

```
/**
 * Created by waleed on 04/02/2017.
 */
public class Main {

    public static void main(String[] args){

        polling();

        Tutorial android1 = new Tutorial("Hafiz 1", "........");
        Tutorial android2 = new Tutorial("Hafiz 2", "........");
        Tutorial android3 = new Tutorial("Hafiz 3", "........");

        Tutorial.publish(android1);
        Tutorial.publish(android2);
        Tutorial.publish(android3);

        // I have already three tutorials and later user subscribed for email

        User A = new User("A","a@a.com");
        User B = new User("B","b@a.com");
        User C = new User("C","c@a.com");
        User D = new User("D","d@a.com");

        // Now A,C and D click subscribe button

        Tutorial.addSubscribedUser(A);
        Tutorial.addSubscribedUser(C);
        Tutorial.addSubscribedUser(D);

        Tutorial android4 = new Tutorial("Hafiz 4", "........");
        Tutorial.publish(android4);

    }

        private static void polling(){

        Polling polling = new Polling();
        Timer timer = new Timer();
        timer.schedule(polling, 0,1000);

    }

    public static class Polling extends TimerTask{

        @Override
        public void run() {
            Tutorial android4 = new Tutorial("Hafiz 4", "........");
            Tutorial.publish(android4);
        }
    }

    public static void sendEmail(List<User> userList){

        for (User user : userList) {
                // send email to user

            System.out.println("Email send: "+user.getName());
        }
    }

    public static class User {

        private String name;
        private String email;

        public User() {
        }

        public User(String name, String email) {
            this.name = name;
            this.email = email;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }
    }

    public static class Tutorial{

        private String authorName;
        private String post;
        public Tutorial() {
        }

        public Tutorial(String authorName, String post) {
            this.authorName = authorName;
            this.post = post;
        }

        private static List<Tutorial> publishedTutorials = new ArrayList<>();
        private static List<User> subscribedUsers = new ArrayList<>();

        public static void addSubscribedUser(User user){
            subscribedUsers.add(user);
        }

        public static void publish(Tutorial tutorial){
            publishedTutorials.add(tutorial);
            sendEmail(subscribedUsers);
        }
    }
}
```

**Professional/Observer Pattern Approach:**

```
import java.util.*;
/**
 * Created by waleed on 04/02/2017.
 */
```

```
public class Main {

    public static void main(String[] args){

        Tutorial android1 = new Tutorial("Hafiz 1", "........");
        android1.publish();
        Tutorial android2 = new Tutorial("Hafiz 2", "........");
        android2.publish();
        Tutorial android3 = new Tutorial("Hafiz 3", "........");
        android3.publish();

        // I have already three tutorials and later user subscribed for email
        User A = new User("A","a@a.com");
        User B = new User("B","b@a.com");
        User C = new User("C","c@a.com");
        User D = new User("D","d@a.com");

        // Now A,C and D click subscribe button

        Tutorial.REGISTER_FOR_SUBSCRIPTION.register(A);
        Tutorial.REGISTER_FOR_SUBSCRIPTION.register(C);
        Tutorial.REGISTER_FOR_SUBSCRIPTION.register(D);

        Tutorial android4 = new Tutorial("Hafiz 4", "........");
        android4.publish();

    }

    public static void sendEmail(User user){
            System.out.println("Email send: "+user.getName());
    }

    public static class User implements Observer{

        private String name;
        private String email;

        public User() {
        }

        public User(String name, String email) {
            this.name = name;
            this.email = email;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

        @Override
        public void notifyMe() {
            sendEmail(this);
        }
    }

    public static class Tutorial implements Observable{

        private String authorName;
        private String post;
        private Tutorial() {}

        public static Tutorial REGISTER_FOR_SUBSCRIPTION = new Tutorial();

        public Tutorial(String authorName, String post) {
            this.authorName = authorName;
            this.post = post;
        }

        private static List<Observer> observers = new ArrayList<>();
        @Override
        public void register(Observer observer) {
            observers.add(observer);
        }

        @Override
        public void unregister(Observer observer) {
            observers.remove(observer);
        }

        @Override
        public void notifyAllAboutChange() {
            for (Observer observer : observers) {
                observer.notifyMe();
            }
        }

        public void publish(){
            notifyAllAboutChange();
        }

    }

    public interface Observable{

        void register(Observer observer);

        void unregister(Observer observer);

        // new tutorial published to tell all subscribed users
        void notifyAllAboutChange();

    }

    public interface Observer{

        // New tutorial published
        void notifyMe();
    }
}
```

**Rx Approach: (Note integrate Rx lib in your project)**

```
import rx.*;
import rx.Observable;
import rx.Observer;
import rx.functions.Action;
import rx.functions.Action1;
import rx.observers.Observers;

import java.util.*;
/**
 * Created by waleed on 04/02/2017.
 */
public class Main {

    public static void main(String[] args){

        Tutorial android1 = new Tutorial("Hafiz 1", "........");
        android1.publish();
        Tutorial android2 = new Tutorial("Hafiz 2", "........");
        android2.publish();
        Tutorial android3 = new Tutorial("Hafiz 3", "........");
        android3.publish();

        // I have already three tutorials and later user subscribed for email
        User A = new User("A","a@a.com");
        User B = new User("B","b@a.com");
        User C = new User("C","c@a.com");
        User D = new User("D","d@a.com");

        // Now A,C and D click subscribe button

        Tutorial.REGISTER_FOR_SUBSCRIPTION.subscribe(A);
        Tutorial.REGISTER_FOR_SUBSCRIPTION.subscribe(C);
        Tutorial.REGISTER_FOR_SUBSCRIPTION.subscribe(D);

        Tutorial android4 = new Tutorial("Hafiz 4", "........");
        android4.publish();

    }

    public static void sendEmail(User user){
        System.out.println("Email send: "+user.getName());
    }

    public static class User implements Action1{

        private String name;
        private String email;
        public User() {}
        public User(String name, String email) {
            this.name = name;
            this.email = email;
        }
        public String getName() {return name;}
        public void setName(String name) {this.name = name;}
        public String getEmail() {return email;}
        public void setEmail(String email) {this.email = email;}

        @Override
        public void call(Object o) {
            sendEmail(this);
        }
    }

    public static class Tutorial {

        private String authorName;
        private String post;
        private Tutorial() {}

        public static rx.Observable REGISTER_FOR_SUBSCRIPTION = rx.Observable.just(new Tutorial());

        public Tutorial(String authorName, String post) {
            this.authorName = authorName;
            this.post = post;
        }

        public void publish(){
            REGISTER_FOR_SUBSCRIPTION.publish();
        }

    }

}

```
