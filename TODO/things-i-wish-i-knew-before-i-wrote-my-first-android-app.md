> * 原文链接 : [6 Things I wish I Knew before I Wrote my first Android App |](http://www.philosophicalhacker.com/2015/07/09/6-things-i-wish-i-knew-before-i-wrote-my-first-android-app/)
* 原文作者 : [K. Matthew Dupree](https://infinum.co/the-capsized-eight/author/ivan-kust)
* 译文出自 : [掘金翻译计划](http://www.philosophicalhacker.com/)
* 译者 : 
* 校对者: 
* 状态 :  待定





My first app was terrible. It was so terrible, in fact, that I removed it from the store and I don’t even bother listing it on my resume’ anymore. That app wouldn’t have been so terrible if I knew a few things about Android development before I wrote it.

我的第一个APP是极其糟糕的. 实际上, 它甚至已经糟糕到了让我把它从商店下架, 这样我就不会因为它在我的简历里面而烦恼了. 这个APP本来不会这样糟糕, 如果在我写它之前知道一些关于安卓开发的事情.

Here’s a list of things to keep in mind as you’re writing your first Android apps. These lessons are derived from actual mistakes that I made in the source code of my first app, mistakes that I’ll be showing below. Keeping these things in mind will help you write an app that you can be a little prouder of.

这有一个你在开发你的第一个安卓APP需要牢记的事情的列表. 这些经验教训都是从我在我的第一个安卓APP的源码里的真实的错误中得来的.

Of course, if you’re doing your job right as a student of Android development, you’ll probably hate your app later regardless. As @codestandards says,

当然, 如果你像一个学生一样进行你的开发工作, 无论如何你都有可能在不久之后讨厌你的APP. 就像@codestandards 说的,

> If the code you wrote a year ago doesn’t seem bad to you, you’re probably not learning enough.
> 
> — Code Standards (@codestandards) [May 21, 2015](https://twitter.com/codestandards/status/601373392059518976)

> 如果你一年前写的代码现在看起来还挺不错的, 你可能获得没有什么足够的长进(在这一年之间).
> 
> — Code Standards (@codestandards) [2015年5月21日](https://twitter.com/codestandards/status/601373392059518976)

If you’re an experienced Java developer, items 1, 2, and 5 probably won’t be interesting to you. Items 3 and 4, on the other hand, might show you some cool stuff you can do with Android Studio that you might not have known about, even if you’ve never been guilty of making the mistakes I demo in those items.

如果你是一名经验丰富的Java 开发者, 你可能不会对第1, 2, 5 条感兴趣. 另一方面, 即便你绝对不会为因为犯了我在下面的条目里展示的错误而内疚, 第3, 4 也会给你展示一些你可以在Android Studio 中做的很酷而你之前不知道的事情, 

## 1\. Don’t have static references to Contexts


## 1\.不要对Contexts做静态引用

    public class MainActivity extends LocationManagingActivity implements ActionBar.OnNavigationListener,
            GooglePlayServicesClient.ConnectionCallbacks,
            GooglePlayServicesClient.OnConnectionFailedListener {

        //...

        private static MeTrackerStore mMeTrackerStore; 

        //...

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            //...

            mMeTrackerStore = new MeTrackerStore(this);
        }
    }

This might seem like an impossible mistake for anyone to make. Its not. I made this mistake. I’ve seen others make this mistake, and I’ve interviewed people who weren’t very quick at figuring out why this is a mistake in the first place. Don’t do this. Its a n00b move.

这可能看起来是一个谁也不可能犯的错误. 然而并不是. 我就犯过这样的错误. 我也看到过别人出这样的错误, 我也遇到过不能一下子指出为什么这(对Contexts的静态引用)是一个错误的的人. 不要这么做. 这是一个及其愚蠢的行为.

If MeTrackerStore keeps a reference to the Activity passed into its constructor, the Activity will never be garbage collected. (Unless the static variable is reassigned to a different Activity.) This is because mMeTrackerStore is static, and the memory for static variables is allocated when the application first starts and isn’t collected until the process in which the application is running quits.

如果MeTrackerStore类一直持有Activity传递进它的构造函数的引用. 这个Activity 将永远不会被垃圾回收. (除非这个静态的变量被分配给一个不同的Activity.) 这是因为mMeTrackerStore 是静态的, 在第一次运行应用的时候内存就会被分配给这个静态变量, 并且直到应用的进程退出这些资源才会被回收.

If you find yourself tempted to do this, there’s probably something seriously wrong with your code. Find help. Maybe looking at Google’s Udacity course on [“Android Development for Beginners”](https://www.udacity.com/course/android-development-for-beginners--ud837) will help you out.

如果你发现你愿意这么做, 那么你的代码可能存在一些严重的错误. 寻求帮助. 可以去看看在Google在Udacity的课程 ["Android Development for Beginners"](https://www.udacity.com/course/android-development-for-beginners--ud837).

Note: Technically, you can hold a static reference to an application Context without causing a memory leak, but I wouldn’t recommend that you do that either. 

注意: 从技术的角度讲, 你可以持有一个应用Context 的静态引用而不会引起内存泄漏, 但是我根本不会提倡你这样做的.

## 2\. Beware of “implicit references” to objects whose lifecycle you do not control

## 2\. 小心对你不能控制生命周期的对象的隐式引用

    public class DefineGeofenceFragment extends Fragment {
        public class GetLatAndLongAndUpdateMapCameraAsyncTask extends AsyncTask {

            @Override
            protected LatLng doInBackground(String... params) {
                //...
                try {
                    //Here we make the http request for the place search suggestions
                    httpResponse = httpClient.execute(httpPost);
                    HttpEntity entity = httpResponse.getEntity();
                    inputStream = entity.getContent();
                    //..
                }
            }
        }

    }

There’s multiple problems with this code. I’m only going to focus on one of those problems. In Java, (non-static) inner classes have an implicit reference to the instances of the class that encloses them.

这段代码存在很多问题. 我将把重点放在其中的一个上.  在Java 中, (非静态的) 内部类对包含它的类对象有一个隐式的引用.

In this example, any GetLatAndLongAndUpdateMapCameraAsyncTask would have a reference to the DefineGeofenceFragment that contains it. The same thing is true for anonymous classes: they have an implicit reference to instances of the class that contains the anonymous class.

在这个例子中, 任何GetLatAndLongAndUpdateMapCameraAsyncTask对象都将有个DefineGeofenceFragment对象的引用. 匿名类也是如此: 它会对包含它的类对象有个隐式的引用.

The GetLatAndLongAndUpdateMapCameraAsyncTask has an implicit reference to a Fragment, an object whose lifecycle we don’t control. The Android SDK is responsible for creating and destroying Fragments appropriately and if GetLatAndLongAndUpdateCameraAsyncTask can’t be garbage collected because its still executing, the DefineGeofenceFragment that it implicitly refers to will also be kept from being garbage collected.

这个GetLatAndLongAndUpdateMapCameraAsyncTask对象对Fragment对象有个隐式的的引用, 一个我们无法控制它生命周期的对象. Android SDK负责适当的创建和销毁Fragment对象, 如果因为GetLatAndLongAndUpdateMapCameraAsyncTask对象正在执行所以不能被回收的话, 那它持有对象也无法被回收.

There’s a great Google IO video [that explains why this sort of thing happens](https://www.youtube.com/watch?v=_CruQY55HOk).

这有一个非常棒的Google IO 视频  [that explains why this sort of thing happens]
(https://www.youtube.com/watch?v=_CruQY55HOk).

## 3\. Make Android Studio work for You

## 3\. 让Android Studio为你服务

    public ViewPager getmViewPager() {
        return mViewPager;
    }

This snippet is what Android Studio generated when I used the “Generate Getter” code completion in Android Studio. The getter keeps the ‘m’ prefixed to the instance variable and uses it when generating a getter method name. This is not ideal.

这个片段是我在Android Studio用"Generate Getter"代码补全时生成的片段. 这个"getter" 方法对这个实例变量保持了"m"前缀. 这不是理想的情况.

(In case you’re wondering why ‘m’ is prefixed to the instance variable name in the first place: the ‘m’ is often prefixed to instance variables by convention. It stands for ‘member.’)

(另外, 你一定想知道为什么实例变量声明的时候要带个"m" 前缀: "m" 经常作为实例变量的前缀的约定. 它代表了成员(member).)

Regardless of whether you think prefixing ‘m’ to your instance variables is a good idea, there’s a lesson here: Android studio can help you code to whatever convention you adopt. For example, you can use the code style dialog in Android Studio to make Android Studio automatically prepend ‘m’ to your instance variable and automatically remove the ‘m’ when its generating getters, setters, and constructor params for the instance variables.

不论你是否认为"m" 前缀是不是一个好主意, 这有一点人生的经验: Android studio可以帮助你把代码转换成任何你想要的样子. 例如, 你可以在Android Studio的代码样式对话框设定里设定给你的实例变量自动加上"m" 前缀并在生成getters, setters和构造函数参数的时候自动移除"m".

[![Screen Shot 2015-07-09 at 4.16.13 PM](http://i1.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.16.13-PM.png?resize=620%2C432)](http://i1.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.16.13-PM.png)

[![Screen Shot 2015-07-09 at 4.16.13 PM](http://i1.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.16.13-PM.png?resize=620%2C432)](http://i1.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.16.13-PM.png)

Android Studio can do a lot more than that too. [Learning shortcuts](http://www.developerphil.com/android-studio-tips-of-the-day-roundup-1/) and learning about [live templates](https://www.jetbrains.com/idea/help/live-templates.html) are good places to start.

Android Studio可以做很多事情. [学习快捷键](http://www.developerphil.com/android-studio-tips-of-the-day-roundup-1/)和[活动模版](https://www.jetbrains.com/idea/help/live-templates.html)是很好的入门.

## 4\. Methods should do one thing

## 4\. 每个方法应该只做一件事

There’s a method in one of the classes that I wrote that’s over 100 lines long. Such methods are hard to read, modify, and reuse. Try to write methods that only do one thing. Typically, this means that you should be suspicious of methods that are over 20 lines long. Here you can recruit Android Studio to help you spot problematic methods:

这有一个我写了超过100行的类方法. 这样的方法是难以阅读和修改甚至再利用的. 试着写只做一件事的方法. 有代表行的说, 这意味着超过20 行的类都应该被怀疑. 说到这你可以用你的Android Studio 帮助你定位有问题的方法:

[![Screen Shot 2015-07-09 at 4.25.00 PM](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png?resize=620%2C435)](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png)


[![Screen Shot 2015-07-09 at 4.25.00 PM](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png?resize=620%2C435)](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png)

## 5\. Learn from other people who are smarter and more experienced than you.

## 5\. 见贤思齐

This might sound trivial, but its a mistake that I made when I wrote my first app.

这个听起来是不重要的, 但是这是我写第一个app时犯下的错误.

When you’re writing an app you’re going to make mistakes. Other people have already made those mistakes. Learn from those people. You’re wasting your time if you repeat the avoidable mistakes of others. I wasted a ton of time on my first app making mistakes that I could have avoided if I just spent a little more time learning from experienced software developers.

 当你写一个APP的时候你也同时在犯错误. 其他人已经犯过这些错误了.  向这些人学习. 如果你反复犯这些他人犯过的本来可以避免的错误那就是在浪费时间. 我写第一个APP的时候我浪费了成吨的时间在那些如果我向其他开发者学习本可以避免的错误上.

Read [Pragmatic Programmer](http://www.amazon.com/The-Pragmatic-Programmer-Journeyman-Master/dp/020161622X). Then read [Effective Java](http://www.amazon.com/Effective-Java-Edition-Joshua-Bloch/dp/0321356683). These two books will help you avoid making common mistakes that we make as novice developers. After you done with those books, keep looking for smart people to learn from.

读读Pragmatic Programmer(http://www.amazon.com/The-Pragmatic-Programmer-Journeyman-Master/dp/020161622X). 然后再读Effective Java(http://www.amazon.com/Effective-Java-Edition-Joshua-Bloch/dp/0321356683). 这两本书会帮助你避免犯一些常见的错误. 当你读完这两本书后, 继续向聪明的人学习.

## 6\. Use Libraries

## 6\. 使用库

When you’re writing an app, you’re probably going to encounter problems that smarter and more experienced people have already solved. Moreover, a lot of these solutions are available as open source libraries. Take advantage of them.

当你写一个APP 的时候. 你可能会遇到一些更智慧或者更有经验的人已经解决的问题. 此外, 大量的解决方案以开源库的方式存在. 好好利用他们.

In my first app, I wrote code that provided functionality that’s already provided by libraries. Some of those libraries are standard java ones. Others are third-party libraries like Retrofit and Picasso. If you’re not sure what libraries you should be using you can do three things:

在我的第一个APP中, 我写的功能已经被其他库所提供了, 它们中的一些库来自于标准的Java 中的一部分. 另一些则是像Retrofit和Picasso这样的库. 如果你不确定你要应该用什么库, 你应该做3件事:

1.  Listen to the [Google IO Fragmented podcast episode](http://fragmentedpodcast.com/episodes/9/). In this episode the ask developers what 3rd party libraries they see as essential for Android development. Spoiler: its mostly Dagger, Retrofit, Picasso, and Mockito.
2.  Subscribe [to Android Weekly](http://androidweekly.net/). They’ve got a section that contains the latest libraries that are coming out. Keep an eye out for what seems useful to you.
3.  Look for open source applications that solve problems similar to the ones that you are solving with your app. You might find one that uses a third-party library that you want to use or you might find that they’ve used a standard java library that you were unaware of. 

1. 收听 [Google IO Fragmented podcast episode](http://fragmentedpodcast.com/episodes/9/). 在这集中, 有一些要求开发了解的第三方Android 库. 
剧透: 大部分都是Dagger, Retrofit, Picasso, and Mockito.
2. 订阅[to Android Weekly](http://androidweekly.net/). 这里有一个板块包含最新的安卓库. 留心那些对你有用的库.
3. 寻找解决类似问题的开源应用. 你可能发现它们用了第三方的库或者用了你并没有在意的标准Java库

## Conclusion

##总结

Writing good Android apps can be very difficult. Don’t make it harder on yourself by repeating the mistakes I made. If you found a mistake in what I’ve written, please let me know in the comments. (Misleading comments are worse than no comments at all.) If you think this’ll be useful for a new developer, share it. Save them some headache.

写一个好的Android APP是非常难的. 不要因为重复我的错误让它变的更加艰难. 如果你发现我的文章中的错误, 请在评论中告诉我. (不过垃圾评论不如不评论)如果你认为这个对萌新开发者是有用的, 分享这篇文章. 把他们(萌新开发者)从头痛中拯救出来.