> * 原文地址：[Developers are users too — part 1: 5 Guidelines for a better UI and API usability](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-1.md)
> * 译者：
> * 校对者：

# Developers are users too — part 1: 5 Guidelines for a better UI and API usability

![](https://cdn-images-1.medium.com/max/2000/1*OUzDeiHZ1Dfe2grlecdC1g.png)

In the previous article we looked at the importance of UI and API usability and that guidelines for UI usability can also be applied to API. Check it out here.

[**Developers are users too — Introduction**
_Usability — learning from the UI, applying in API_medium.com](https://medium.com/google-developers/developers-are-users-too-introduction-fefdb42f05a)

In this article we’ll discuss the first 5 usability guidelines:

1. [Visibility of system status](#a062)
2. [Match between system and the real world](#fd9a)
3. [User control and freedom](#52bc)
4. [Consistency and standards](#7d0b)
5. [Error prevention](#6f9b)

### 1. Visibility of system status

> The system should keep the users informed about what’s going on, through appropriate feedback, within reasonable time.

**UI:** When the user initiates an action that takes a longer time, inform them about the progress. Prefer a progress bar to an image that is loading, an upload or download notification with percentages, if possible. The user should know what are they waiting for and how long it might take.

![](https://cdn-images-1.medium.com/max/800/1*uyWN73Fvr91jvuw9AfrUTQ.gif)

Keep the user informed of progress. [Source](https://material.io/guidelines/components/progress-activity.html#progress-activity-types-of-indicators)

**API:** The API should provide ways of querying the current state. For example, the `[AnimatedVectorDrawable](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable.html)` class provides a way of checking whether the animation is running or not:

```
boolean isAnimationRunning = avd.isRunning();
```

The API can give feedback in form of callback mechanisms, allowing the API users to know when objects change state — like a notification for when the animation starts and ends. `[AnimatedVectorDrawable](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable.html)` objects allow [registering](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable.html#registerAnimationCallback%28android.graphics.drawable.Animatable2.AnimationCallback%29) an `[AnimationCallback](https://developer.android.com/reference/android/graphics/drawable/Animatable2.html#registerAnimationCallback%28android.graphics.drawable.Animatable2.AnimationCallback%29)` for this purpose.

### 2. Match between system and the real world

> The application should speak the user’s language, with phrases and concepts familiar to the user, rather than system oriented terms.

![](https://cdn-images-1.medium.com/max/800/0*wSpL4tOdQ80XTC-B.)

Use concepts familiar to the user. [Source](https://material.io/guidelines/style/writing.html#writing-language)

#### Class and method naming should match the users’ expectations

**API:** When searching for a class in a new API, the user doesn’t have a definite starting point and relies on either previous experience with similar APIs, or on general concepts related to the API domain. For example, when using Glide or Picasso to download and display an image, the user may look for a method called “load” or “download”.

### 3. User control and freedom

> Offer users the possibility of reverting their actions.

**UI:** For actions initiated by the user where there might be ambiguity that something has happened, like deleting or archiving an email, display a message that acknowledges it and allows the user to undo the action.

![](https://cdn-images-1.medium.com/max/800/1*6ZgbBYTkeyh-LrA96T8Nuw.png)

Allow the user to undo certain actions. [Source](http://Elements%20like%20“Help”%20and%20“Send%20feedback”%20are%20usually%20placed%20at%20the%20bottom%20of%20the%20navigation%20drawer.)

#### APIs should allow abort or reset operations and easily get the API back to a normal state

**API:** For example, Retrofit exposes a [Call#cancel](https://square.github.io/retrofit/2.x/retrofit/retrofit2/Call.html#cancel--) method that attempts to cancel in-flight network call or, if the call hasn’t been executed yet, ensures it will never be. If you work with the NotificationManager API you’ll see that you can both create but also [cancel](https://developer.android.com/reference/android/app/NotificationManager.html#cancel%28int%29) notifications.

### 4. Consistency and standards

> The users of your application should not have to wonder whether different words, situations or actions mean the same thing.

**UI:** The users interacting with your app have been trained through the interaction with other apps and they expect common interaction elements to look and behave in a certain way. Deviating from those conventions opens the door to error-prone conditions.

Be consistent with the platform and use UI controls that are well known to the users, so they can quickly recognize them and act on them. Also, be consistent throughout your own application. Use the same words and icons to represent the same things when used on multiple screens in your app. For example, always use the same editing icon when users can edit multiple elements in your app.

![](https://cdn-images-1.medium.com/max/800/0*ioWpCsAMsI7gRHxo.)

Dialogs should be consistent with the platform. [Source](https://material.io/guidelines/usability/accessibility.html#accessibility-implementation)

**API:** All parts of the API design should be consistent

#### Use consistent naming across methods

Consider the following example where we have an interface that exposes two ways of setting two different types of observers:

```
public interface MyInterface {
    
    void registerContentObserver(ContentObserver observer);
    void addDataSetObserver(DataSetObserver observer);
}
```

Users of this interface will ask themselves what is the difference between `register…Observer` and `add…Observer`. Would one method allow just one Observer at a time, whereas the other allows multiple? Developers would either need to carefully read the documentation or look for the implementation of the interface to see that both methods behave in the same way.

```
private List<ContentObserver> contentObservers;
private List<DataSetObserver> dataSetObservers;
public void registerContentObserver(ContentObserver observer) {
    contentObservers.add(observer);
}
public void addDataSetObserver(DataSetObserver observer){
    dataSetObservers.add(observer);
}
```

Use the **same name** for methods that do the same thing.

Consider using pairs of **antonyms**: get — set, add — remove, subscribe — unsubscribe, show — dismiss.

#### Use consistent param ordering across methods

When overloading methods, make sure you keep the same order for the parameters that are present in all methods. Otherwise, your API users will spend time more time understanding the differences between the overloaded methods.

```
void setNotificationUri( ContentResolver cr,
                         Uri notifyUri);
void setNotificationUri( Uri notifyUri,
                         ContentResolver cr,
                         int userHandle);
```

#### Avoid functions with multiple consecutive params of the same type

Although Android Studio makes it easier to work with methods with multiple consecutive parameters of the same type, ordering mistakes are easy to make and harder to find. The parameter order should match the logical order of the parameters, where possible.

![](https://cdn-images-1.medium.com/max/800/0*2oT4UN19rU1q_aJI.)

It’s easy to make mistakes when parameters have the same type. Here county and country are interchanged.

As a solution for this, you could use the builder pattern or, for Kotlin’s [named parameters](https://kotlinlang.org/docs/reference/functions.html).

#### Methods should have maximum 4 parameters

The more parameters, the more complex the method is. For every parameter, the user needs to understand the meaning for the method but also the relation to other parameters. So this means that every additional parameter leads to an exponential increase in complexity. When a method has more than 4 parameters consider encapsulating some of them in other classes or using builders.

#### The return value influences the complexity of a method

When a method returns a value, developers need to know what that value represents, how to store it, etc. When the return value is not used, it doesn’t have an effect on the complexity of the method.

For example, when inserting an object in the database, Room can return both a `Long` or `void`. When the API user wants to use the return value, it first needs to understand what it means and then where to store it. When the value is not needed, the void method can be used.

```
@Insert
Long insertData(Data data);
@Insert
void insertData(Data data);
```

Therefore, you should prefer returning a value, allowing the API user to decide where they need it or not. If you’re creating a library based on code generation, allow methods that return both options.

### 5. Error prevention

> Create a design that prevents a problem occurring in the first place.

**UI:** Often, users are distracted from the task at hand so you should prevent unconscious errors by guiding the users so they stay on the right path, and have fewer chances of slips. For example, you can ask them to confirm before destructive actions or suggest good defaults.

For example, Google Photos makes sure you’re not deleting albums by mistake by adding a confirmation dialog. Inbox allows you to snooze an email and provides one-click defaults.

![](https://cdn-images-1.medium.com/max/800/1*qLkM_Zm1bR15IgbFZiKMRQ.png)

Google Photo uses confirmation before destructive actions. Inbox provides one-click defaults when snoozing an email

#### The API should guide the user into using the API correctly. Use default values where possible.

APIs should be easy to use and hard to misuse. Help your users by providing default values. For example, when creating a Room database, one of the default values ensures that the data in the database is kept even when increasing the database version. This results in a better usability for the users of the app that incorporates Room since their data is kept and database versions are transparent.

Room also provides a method that can change this behavior: `[fallbackToDestructiveMigration](https://developer.android.com/reference/android/arch/persistence/room/RoomDatabase.Builder.html#fallbackToDestructiveMigration%28%29)` that destroys and then re-creates the database when the version changes, if no migration was provided.

* * *

We have 5 more guidelines left to dive into:

* [Recognition rather than recall](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#b705)
* [Flexibility and efficiency of use](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#0709)
* [Aesthetic and minimalist design](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#3033)
* [Help users recognize, diagnose and recover from errors](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#d40e)
* [Help and documentation](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#e86b)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
