> * 原文链接 : [6 Things I wish I Knew before I Wrote my first Android App |](http://www.philosophicalhacker.com/2015/07/09/6-things-i-wish-i-knew-before-i-wrote-my-first-android-app/)
* 原文作者 : [K. Matthew Dupree](https://infinum.co/the-capsized-eight/author/ivan-kust)
* 译文出自 : [掘金翻译计划](http://www.philosophicalhacker.com/)
* 译者 : 
* 校对者: 
* 状态 :  待定



我的第一个应用写的非常弱。事实上，它已经弱到让我把它从应用商店直接下架了来抹去在我简历上到污点。 如果在我开发它之前我对开发有Android开发有任何了解就不会做的那么弱了吧。


这里是一些当你在写你的第一个Android应用的时候需要牢牢记住的东西。这些教训都是从我在我的第一个app上犯下的真实的错误。接下来我会谈及他们。在脑海中保持这些东西有助于写一些让你能够小骄傲的应用

当然，如果你按照正确的Android开发者入门方向，你也许不会那么头疼你的应用。 就像大神 @codesstandards 说的那样：

> 如果你一年前写的代码看上去还是不错的话，说明你这一年学的不够。
> 
> — Code Standards (@codestandards) [May 21, 2015](https://twitter.com/codestandards/status/601373392059518976)


如果你是一个有经验的Java开发者， 接下来的第1，2，和5点也许你不会很感兴趣。第3和第4点应该会向你展示一些你也许不知道的却非常酷炫屌炸天的东西在你有Android Studio的情况下能做到的。 即使你从来没有在犯下我接下来会列出的错误感到过愧疚。

## 1\. 不要把静态引用防到Context上

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


这事儿看起来也许是二的不一般的人才会做的事情。 但是事实上－ －我看过好多人犯这个错 并且我和这些不能在第一时间识别出这些错误的人交流过。 绝壁不要这么做－ －这是非常傻叉的行为

如果当这个Activity传递到它的构造函数里，MeTrackerStore持有这个Activity的引用，那这个Activity将仍然不会被回收（除非这个静态变量被重新赋值给另一个Activity）。这是因为mMeTrackerStore是静态的，静态变量的内存是不会被回收的，直到程序里正在运行的进程停止。如果你发现自己尝试这么做，那么你的代码可能有一些严重的错误。寻找帮助的话，可以看看Google’s Udacity里的课程 [“Android Development for Beginners”](https://www.udacity.com/course/android-development-for-beginners--ud837)。

注意：技术上讲，你可以保持一个对Context的静态引用在不会引起内存泄漏的情况下，但我也不会推荐你这么做。

## 2\. 小心引用那些你不能控制生命周期的隐式引用

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


这段代码里面有大量的错误。 这么多错误里面我只讲一点， 那就是在JAVA中，（非静态的）内部类

在这个例子里面，所有GetLatAndLongAndUpdateMapCameraAsyncTask对象都有个对DefineGeofenceFragment对象的引用。匿名类也是这样：它会对包含它的类对象有个隐式的引用。

Android SDK负责适当地创建和销毁Fragment对象，如果GetLatAndLongAndUpdateMapCameraAsyncTask对象正在执行所以不能被回收的话，那它持有对象也无法被回收 因为它仍然存在，DefineGeofenceFagment的隐式引用会让这货不能被回收。

这里有个[Google IO](https://www.youtube.com/watch?v=_CruQY55HOk)的视频能说明这件事儿

## 3\. 让Android Studio 为你做事

    public ViewPager getmViewPager() {
        return mViewPager;
    }


这个片段是我使用”Generate Getter”代码补全时，Android Studio为我生成的，这个getter方法对这个实例变量保持了’m’前缀。这并不理想。

(顺手满足下你的好奇心，你一定想知道为啥实例变量声明的时候要带个’m’前缀：这个’m’常常被约定作为实例变量的前缀。它代表了’member’。)

不论你是否认为’m’作为你实例变量的前缀是一个好主意，这里有一个我学到的教训：Android Studio可以帮你按照你养成的习惯去编写代码。比如说，你可以使用Android Studio中的代码风格框去让Android Studio自动的加上’m’到你的实例变量并且当它生成getters，setters，和构造参数时自动移除’m’。

Android Studio甚至可以做比上面更牛叉的事情[Learning shortcuts](http://www.developerphil.com/android-studio-tips-of-the-day-roundup-1/) 以及 [live templates](https://www.jetbrains.com/idea/help/live-templates.html) 是开始学习的好地方

## 4\. Method应该只做一件事情

我写的这里有个超过100行的Method。这样的方法很难读懂，修改和重用。试着写仅仅做一件事的Method。一般来说，这意味着你应该注意那些你写超过20行的代码。这里你可以利用Android Studio去帮助你指出有问题的方法:
[![Screen Shot 2015-07-09 at 4.25.00 PM](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png?resize=620%2C435)](http://i2.wp.com/www.philosophicalhacker.com/wp-content/uploads/2015/07/Screen-Shot-2015-07-09-at-4.25.00-PM.png)

## 5\. 从那些大神地方学习

这也许听起来非常扯淡，但是这就是当我写我第一个应用到时候犯下的错误。

当你要犯下错误的时候，其实早就有其他人犯下过错误了。尝试向这些人请教吧。 如果你一直重复这种错误就是在浪费你的时间。我浪费了大量的时间在一些我本来可以多花一点时间就避免的错误上

读下[Pragmatic Programmer](http://www.amazon.com/The-Pragmatic-Programmer-Journeyman-Master/dp/020161622X). Then read [Effective Java](http://www.amazon.com/Effective-Java-Edition-Joshua-Bloch/dp/0321356683)这本书吧 然后去读下[Effective Java](http://www.amazon.com/Effective-Java-Edition-Joshua-Bloch/dp/0321356683)这本书。 这两本书可以帮你避免一些新手常犯的错误。即使在你看完这两本书之后，也请保持着新手的姿态向大神们学习。

## 6\. 使用库

当你写一个app，你可能会遇到那堆前人已经解决了的问题。而且，大量的解决办法都是作为资源库开放的。 好好使用这些东西吧。

在我的第一个app中，我写的功能已经被其他库所提供了，它们中的一些库来自于标准的java中的一部分。另一些则是像Retrofit和Picasso这样的库。如果你不确定你要应该用什么库，你能做3件事：

1.听[Google IO Fragmented podcast episode](http://fragmentedpodcast.com/episodes/9/) 在这一节里面讲了第三方的库对于开发者是多么的重要 基本上就是 Dagger, Retrofit, Picasso, 和 Mockito这4个库.
2.订阅[to Android Weekly](http://androidweekly.net/) 在上面看看对你有用的东西
3.寻找解决类似问题的开源应用。你可能发现它们用了第三发的库(third-party library)或者用了你并没有在意的标准的java库。


## 最后说点什么

写一个好的Android应用是非常困难大。不要重复一些我犯下的错误让写程序这件事变得更难。 如果你在我的这篇博客里面发现一些错误的话，请在评论区里告诉我。（误导的评论还不如不评论）如果你觉得这篇博客对其他开发者有帮助的话，请安利它。



