> * 原文链接 : [6 Things I wish I Knew before I Wrote my first Android App](http://www.philosophicalhacker.com/2015/07/09/6-things-i-wish-i-knew-before-i-wrote-my-first-android-app/)
* 原文作者 : [K. Matthew Dupree](https://infinum.co/the-capsized-eight/author/ivan-kust)
* 译文出自 : [掘金翻译计划](http://www.philosophicalhacker.com/)
* 译者 : [404neko](https://github.com/404neko)
* 校对者: [Glowin](https://github.com/Glowin)、[achilleo](https://github.com/achilleo)
* 状态 :  完成

# 我希望在我写第一个安卓 APP 前知道的 6 件事情

我的第一个 APP 是极其糟糕的. 实际上, 它已经糟糕到了让我把它从商店下架, 我甚至不愿费事儿再把它写进简历. 如果在我写它之前知道一些关于安卓开发的事情, 这个 APP 本来不会这样糟糕.

这有一个你在开发你的第一个安卓 APP 时需要牢记的事情的列表. 我下面要说的这些经验教训都是从我的第一个安卓 APP 的源码里的真实的错误中得来的. 将这些(经验)铭记在心将会帮助你写一个你可以为之骄傲的 APP.

当然, 如果你像一个学生一样进行你的开发工作, 无论如何你都有可能在不久之后讨厌你的 APP. 就像 @codestandards 说的,

> 如果你一年前写的代码现在看起来还挺不错的, 你可能获得没有足够的长进(在这一年之间).
> 
> — Code Standards (@codestandards) [2015年5月21日](https://twitter.com/codestandards/status/601373392059518976)

如果你是一名经验丰富的 Java 开发者, 你可能不会对第 1, 2, 5 条感兴趣. 另一方面, 即便你绝对不会为因为犯了我在下面的条目里展示的错误而内疚, 第 3, 4 也会给你展示一些你可以在 Android Studio 中做的很酷而你之前不知道的事情, 

## 1\.不要对 Contexts 做静态引用

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

这可能看起来是一个谁也不可能犯的错误. 然而并不是. 我就犯过这样的错误. 我也看到过别人出这样的错误, 我也遇到过不能一下子指出为什么这(对 Contexts 的静态引用)是一个错误的的人. 不要这么做. 这是一个极其愚蠢的行为.

如果 MeTrackerStore 类一直持有 Activity 传递进它的构造函数的引用. 这个 Activity 将永远不会被垃圾回收. (除非这个静态的变量被分配给一个不同的 Activity.) 这是因为 mMeTrackerStore 是静态的, 在第一次运行应用的时候内存就会被分配给这个静态变量, 并且直到应用的进程退出这些资源才会被回收.

如果你发现你愿意这么做, 那么你的代码可能存在一些严重的错误. 寻求帮助. 可以去看看在 Google 在 Udacity 的课程 ["Android Development for Beginners"](https://www.udacity.com/course/android-development-for-beginners--ud837).

注意: 从技术的角度讲, 你可以持有一个 Application Context 的静态引用而不会引起内存泄漏, 但是我根本不会提倡你这样做的.

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

这段代码存在很多问题. 我将把重点放在其中的一个上.  在 Java 中, (非静态的) 内部类对包含它的类对象有一个隐式的引用.

在这个例子中, 任何 GetLatAndLongAndUpdateMapCameraAsyncTask 对象都将有个DefineGeofenceFragment 对象的引用. 匿名类也是如此: 它会对包含它的类对象有个隐式的引用.

这个 GetLatAndLongAndUpdateMapCameraAsyncTask 对象对 Fragment 对象有个隐式的的引用, 一个我们无法控制它生命周期的对象. Android SDK 负责适当地创建和销毁 Fragment 对象, 如果因为 GetLatAndLongAndUpdateMapCameraAsyncTask 对象正在执行所以不能被回收的话, 那它隐式引用的对象也无法被回收.

这有一个非常棒的Google IO 视频  [that explains why this sort of thing happens]
(https://www.youtube.com/watch?v=_CruQY55HOk).

## 3\. 让 Android Studio 为你服务

    public ViewPager getmViewPager() {
        return mViewPager;
    }

这个片段是我在 Android Studio 用 "Generate Getter" 代码补全时生成的片段. 这个 "getter" 方法对这个实例变量保持了 "m" 前缀. 这不是理想的情况.

(另外, 你一定想知道为什么实例变量声明的时候要带个 "m" 前缀: "m" 经常作为实例变量的前缀的约定. 它代表了成员(member).)

不论你是否认为 "m" 前缀是不是一个好主意, 这有一点人生的经验: Android Studio 可以帮助你把代码转换成任何你想要的样子. 例如, 你可以在 Android Studio 的代码样式对话框设定里设定给你的实例变量自动加上 "m" 前缀并在生成 getters, setters 和构造函数参数的时候自动移除 "m".

[![Screen Shot 2015-07-09 at 4.16.13 PM](http://i1.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.16.13-PM.png?resize=620%2C432)](http://i1.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.16.13-PM.png)

Android Studio可以做很多事情. [学习快捷键](http://www.developerphil.com/android-studio-tips-of-the-day-roundup-1/)和[活动模版](https://www.jetbrains.com/idea/help/live-templates.html)是很好的入门.

## 4\. 每个方法应该只做一件事

这有一个我写了超过100行的类方法. 这样的方法是难以阅读和修改甚至再利用的. 试着写只做一件事的方法. 通常来说, 这意味着超过 20 行的类都应该被怀疑. 说到这你可以用你的 Android Studio 帮助你定位有问题的方法:

[![Screen Shot 2015-07-09 at 4.25.00 PM](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png?resize=620%2C435)](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png)

## 5\. 见贤思齐

这个听起来是不重要的, 但是这是我写第一个 APP 时犯下的错误.

 当你写一个 APP 的时候你也同时在犯错误. 其他人已经犯过这些错误了.  向这些人学习. 如果你反复犯这些他人犯过的本来可以避免的错误那就是在浪费时间. 我写第一个 APP 的时候我浪费了成吨的时间在那些如果我向其他开发者学习本可以避免的错误上.

读读[Pragmatic Programmer](http://www.amazon.com/The-Pragmatic-Programmer-Journeyman-Master/dp/020161622X). 然后再读[Effective Java](http://www.amazon.com/Effective-Java-Edition-Joshua-Bloch/dp/0321356683). 这两本书会帮助你避免犯一些常见的错误. 当你读完这两本书后, 继续向聪明的人学习.

## 6\. 使用库

当你写一个 APP 的时候. 你可能会遇到一些更智慧或者更有经验的人已经解决的问题. 此外, 大量的解决方案以开源库的方式存在. 好好利用他们.

在我的第一个 APP 中, 我写的功能已经被其他库所提供了, 它们中的一些库来自于标准的 Java 中的一部分. 另一些则是像 Retrofit 和 Picasso 这样的库. 如果你不确定你要应该用什么库, 你应该做 3 件事:

1. 收听 [Google IO Fragmented podcast episode](http://fragmentedpodcast.com/episodes/9/). 在这集中, 有一些要求开发了解的第三方 Android 库. 
剧透: 大部分都是 Dagger, Retrofit, Picasso, and Mockito.
2. 订阅[to Android Weekly](http://androidweekly.net/). 这里有一个板块包含最新的 Android 库. 留心那些对你有用的库.
3. 寻找解决类似问题的开源应用. 你可能发现它们用了第三方的库或者用了你并没有在意的标准Java库

##总结

写一个好的 Android APP 是非常难的. 不要因为重复我的错误让它变的更加艰难. 如果你发现我的文章中的错误, 请在评论中告诉我. (不过垃圾评论不如不评论)如果你认为这个对萌新开发者是有用的, 分享这篇文章. 把他们(萌新开发者)从头痛中拯救出来.
