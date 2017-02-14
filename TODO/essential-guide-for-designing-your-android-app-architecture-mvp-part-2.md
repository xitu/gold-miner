> * 原文地址：[Essential Guide For Designing Your Android App Architecture: MVP: Part 2](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-2-b2ac6f3f9637#.k8ic3b2b3)
* 原文作者：[Janishar Ali](https://blog.mindorks.com/@janishar.ali?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Essential Guide For Designing Your Android App Architecture: MVP: Part 2 #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*eHluapKk6_AaHNd2gkLi3A.png">

This is the second part of the article series. In the first part, we developed the concept of MVP and worked out a blueprint for the android application architecture. If you haven’t read the first part then most of the following article will not make much sense. So, go through the first part before proceeding forward.

[Here is the link to the first part](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-1-74efaf1cda40):

[**Essential Guide For Designing Your Android App Architecture: MVP: Part 1**
If you make your foundations strong, then you can rise high and touch the sky.](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-1-74efaf1cda40) 

We will implement the MVP architecture by developing a full-fledged android application based on the blueprint sketched in the first part of this article series.

The GitHub repo of the MVP project:

[**MindorksOpenSource/android-mvp-architecture**
android-mvp-architecture - This repository contains a detailed sample app that implements MVP architecture using…](https://github.com/MindorksOpenSource/android-mvp-architecture)

This project is developed to provide a proper way of structuring an android app. It contains all the code pieces required for most part of the android app.

The project will appear very complex at first but as you will spend time exploring, it will become most obvious to you. This project is built using Dagger2, Rxjava, FastAndroidNetworking and PlaceHolderView.

> Take this project as a case study. Study each and every code of it. If there is some bug or you can come up with a better logical implementation then create a pull request. We are writing tests gradually, so feel free to contribute in it and create pull request for them too.

The screens of the developed app are provided below:

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*qJTkiwJEUD8nW3VE5qr-9Q.png">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*DO5gQCd9qJ7_WMaIof2eBQ.png">

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/400/1*d4WOBPrzv7N19tfkeY636Q.gif">

This app has a login screen and a main screen. Login screen implements google, facebook and server login. The google and facebook login is implemented through a dummy api. The login is based on access token retrieval and subsequent api calls are protected with this token. The main screen creates flashcards with questions relevant to MVP. This repo contains codes that demonstrate most of the possible application components in terms of skeleton for any app.

Let’s take a look at the project structuring:

The entire app is packaged into five parts:

1. **data**: It contains all the data accessing and manipulating components.
2. **di**: Dependency providing classes using Dagger2.
3. **ui**: View classes along with their corresponding Presenters.
4. **service**: Services for the application.
5. **utils**: Utility classes.

Classes have been designed in such a way that it could be inherited and could maximize the code reuse.

#### project structure diagram: ####

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/1000/1*SnfdPTpsXXSvojWE-joSJw.png">

> Simplest ideas are most complex in their conception.

There are a lot of interesting parts. But if I try explaining all of them at once then it will become too much information at a time. So, I think best approach will be to explain the core philosophies and then the reader can make sense of the code through navigating the project repo. I advise you to take this project study spanned over at least a week. Study the main classes in reverse chronological order.

1. Study build.gradle and look for all the dependencies used.
2. Explore data package and the implementations of helper classes.
3. ui base package creates the base implementations of Activity, Fragment, SubView and Presenter. All other related components should be derived from these classes.
4. di package is the dependency providing classes for the application. To understand dependency injection, go through the two-part article published by me, [**Dagger2 part 1**](https://blog.mindorks.com/introduction-to-dagger-2-using-dependency-injection-in-android-part-1-223289c2a01b#.bse4rt4mz) and[**Dagger2 part 2**](https://blog.mindorks.com/introduction-to-dagger-2-using-dependency-injection-in-android-part-2-b55857911bcd#.lahv7yh36) 
5. Resources: Styles, fonts, drawable.

For any query connect with me on Twitter:

[**janishar ali (@janisharali) | Twitter**
The latest Tweets from janishar ali (@janisharali): "Check out the new release of Android-Debug-Database with complete…](https://twitter.com/janisharali)

### Reference resources: ###

- **RxJava2**: [https://github.com/amitshekhariitbhu/RxJava2-Android-Samples](https://github.com/amitshekhariitbhu/RxJava2-Android-Samples) 
- **Dagger2**: [https://github.com/MindorksOpenSource/android-dagger2-example](https://github.com/MindorksOpenSource/android-dagger2-example)
- **FastAndroidNetworking**: [https://github.com/amitshekhariitbhu/Fast-Android-Networking](https://github.com/amitshekhariitbhu/Fast-Android-Networking)
- **PlaceHolderView**: [https://github.com/janishar/PlaceHolderView](https://github.com/janishar/PlaceHolderView)
- **AndroidDebugDatabase**: [https://github.com/amitshekhariitbhu/Android-Debug-Database](https://github.com/amitshekhariitbhu/Android-Debug-Database)
- **Calligraphy**: [https://github.com/chrisjenx/Calligraphy](https://github.com/chrisjenx/Calligraphy)
- **GreenDao**: [http://greenrobot.org/greendao/](http://greenrobot.org/greendao/)
- **ButterKnife**: [http://jakewharton.github.io/butterknife/](http://jakewharton.github.io/butterknife/) 

**Thanks for reading this article. Be sure to click ❤ below to recommend this article if you found it helpful. It would let others get this article in feed and spread the knowledge.**

For more about programming, follow [**me**](https://medium.com/@janishar.ali) and [**Mindorks**](https://blog.mindorks.com/) , so you’ll get notified when we write new posts.

[Check out all the Mindorks best articles here.](https://mindorks.com/blogs) 

Coder’s Rock :)
