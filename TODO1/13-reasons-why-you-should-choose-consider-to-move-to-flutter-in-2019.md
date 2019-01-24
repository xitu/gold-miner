> * 原文地址：[13 Reasons Why you should choose/ consider to move to Flutter](https://medium.com/flutter-community/13-reasons-why-you-should-choose-consider-to-move-to-flutter-in-2019-24323ee259c1)
> * 原文作者：[Ganesh .s.p](https://medium.com/@ganesh.s.p006)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/13-reasons-why-you-should-choose-consider-to-move-to-flutter-in-2019.md](https://github.com/xitu/gold-miner/blob/master/TODO1/13-reasons-why-you-should-choose-consider-to-move-to-flutter-in-2019.md)
> * 译者：
> * 校对者：

# 13 Reasons Why you should choose/ consider to move to Flutter

![](https://cdn-images-1.medium.com/max/800/1*28u1IZzOkTeQMso-2eZZWw.png)

> _13 reasons why you should “C_[**ome to the Dart Side**](https://twitter.com/scottstoll2017)**”** _& choose Flutter for development of your next app or to learn Flutter to develop app._

Businesses these days need to make critical choices on their selection of mobile technologies. They’re constantly testing and evaluating technologies so as to form powerful digital experiences, regardless of the user’s mobile device or operating system. Organizations that fail to produce products and services that are simple to use, regardless of channel or device, risk falling behind the competition.

![](https://cdn-images-1.medium.com/max/800/1*ECNAUzNJCkkl7EJKk2Esrw.gif)

The challenge is that cross-platform development can be problematic. In several cases, despite a developer’s best efforts, the user experience lags behind that of actual native apps. In recent years we’ve seen the emergence of various mobile frameworks like React Native, Xamarin and AngularJS that help make it easier to produce these digital experiences. Recently we’ve seen a new player enter the game — Google’s Flutter.

![](https://cdn-images-1.medium.com/max/800/1*ymhzy0pX-tFncyB-jD8Opw.gif)

At its heart, Flutter might look like a hodgepodge of various Google technologies and concepts, however this results in an improbably powerful mobile framework. It’s based on Dart, Google’s in-house programming language, which gives Flutter access to the Skia graphics library — which is what Chrome uses. Additionally, Flutter works closely with Google’s Material Design specifications; most famous for the “card motifs” that Android users have come to know.

* * *

Let’s see 13 reasons to choose Flutter as your development environment or even to start off your career in flutter.

**1. Flutter overcomes the traditional limitations of cross-platform approaches.**

Creating a truly cross-platform approach has long been the bane of tech consultants tired of having to make multiple versions of identical product. However, in reality, the user experience typically lags behind that of native applications, because you often end up building the UI experience in JavaScript that has to be Just In Time compiled.

![](https://cdn-images-1.medium.com/max/800/1*QVvruYyZj4d7xPnO5HLWvA.jpeg)

With Flutter, you not only have the advantage of a “write once” approach, you create a high performance, “native” experience because a Flutter App is an Ahead Of Time compiled, machine binary executable. It overcomes several of the normal challenges that go with cross-platform approaches.  
  
**2. Developers increase productivity ten-fold.**

This increase in productivity comes from Flutter’s “hot reload” (A.K.A “Stateful Hot Reload” and “Hot Restart”. Together, these allow developers to see changes they make to the state of an app in less than one second; and changes to the app structure in less than ten.

![](https://cdn-images-1.medium.com/max/800/1*52k_IC8lfsVnHzwLOcF55w.gif)

There’s no need to run another Gradle build— you see your modifications as soon as you save. For developers, this is often very easy to master — there’s little or no learning curve concerned in using the “hot reload” because by default it happens every time you save. However, the advantages are vital. Development time is often reduced by 30–40% because the Gradle rebuild times that slow Android developers down typically take longer with every modification being applied.

**3. Frontend & Backend with a single code**

Unlike in Android coding, where there are separate files for fronted (Views) which are referenced by backend (Java), flutter uses a single language (Dart) which does both the job and uses a reactive framework.

Dart has been built on a lot of the most popular features of other languages without losing the familiarity of Java or similar languages.Dart was built with the developer’s ease in mind and thus makes a lot of common tasks much more easier. You can learn more about Dart here : [Dart Language Tour](https://www.dartlang.org/guides/language/language-tour).

**4. It’s a powerful design experience out of the box.**

Due to the Flutter team’s careful implementation of the Material design specification, it’s easy to create powerful UI experiences right out of the box. It helps produce the smooth, crisp experience you typically only see with native applications because Flutter’s release build _is_ a native application.

Flutter has widgets that implement the Human Interface Design specifications for iOS, allowing you get that native “feel” on iPhone and iPad as well.

![](https://cdn-images-1.medium.com/max/800/1*AwlIaO9hQAMAYQ9oQjHtKw.png)

**5. There is an extensive catalog of open source packages.**

The large set of open source packages available helps you create apps faster, with ease, and there are a lot of packages current available which make many complicated tasks much easier. Although still relatively young, the package library is growing by leaps and bounds every day thanks to an ever growing population of developers actively contributing to Flutter.  
  
**6. Straightforward integration with Firebase.**

Firebase provides out of the box support for a collection of services such as cloud storage, cloud functions, real time databases, hosting, authentication and a whole lot more. Your infrastructure is instantly serverless, redundant and scalable. This means you don’t have to spend a lot of time and resources building the backend. It’s also straightforward to combine it with a tool for automating your development and release process like Fastlane; facilitating Continuous Delivery. Therefore you don’t have to have dedicated DevOps support in your team.

**7. Flutter has support for a variety of IDEs.**

When coding with Flutter you can choose from a number of Integrated Development Environments. At first I started off with Android Studio, but then I saw Flutter Live where they were using VS Code. That got me wondering, and I found that a lot of Flutter developers use Visual Code. When I tried it I could see why so many prefer it. VS Code is light weight and much faster, and has most the features available in Android Studio and IntelliJ. Personally, I’ve made the move to VS Code but you can use a number of other IDEs as well, You don’t need to switch in order to start working in Flutter.

**8. UI Compliance — Everything is a Widget.**

In flutter everything is a widget, the Appbar, Drawer, Snackbar, Scaffold, etc. It’s easy to wrap one Widget inside another to give this to do things like center something, by wrapping it in a Center Widget. This is all part of helping make sure your users have a n experience no matter what platform they’re running on.You should read the following documentation from flutter as well : [Everything’s a widget](https://flutter.io/docs/resources/technical-overview#everythings-a-widget).

**9. Different themes for Android/iOS**

Assigning the proper theme for a user’s platform is as easy as using a ternary if to check which platform the user is running on; allowing your UI to make run time decisions about which UI components to use.

Here’s a sample code to do the same, it check’s the current platform and if it’s iOS, it returns a theme of purple primary colour.

```
return new MaterialApp(
  // default theme here
  theme: new ThemeData(),
  builder: (context, child) {
    final defaultTheme = Theme.of(context);
    if (defaultTheme.platform == TargetPlatform.iOS) {
      return new Theme(
        data: defaultTheme.copyWith(
          primaryColor: Colors.purple
        ),
        child: child,
      );
    }
    return child;
  }
);
```

**10. Continuous integration using Code Magic.**

Code magic is an open-source tool featured in Flutter Live on December 4th, 2018. Code magic is easy to learn and completely free! It’s a highly sophisticated CI tool, optimized specifically for Flutter. Code magic makes build processes seamless.

![](https://cdn-images-1.medium.com/max/800/1*gdnx0Dcqm6_uEWaoghtvIA.png)

Code Magic in action

**11. Animations are even easier using** [**2Dimensions**](https://www.2dimensions.com/) **Flare.**

![](https://cdn-images-1.medium.com/max/600/1*b3Z0cow_co15WpjLYELqSQ.gif)

My first try with Flutter +Flare — Bouncy

Also introduced during Flutter live 2018, this amazing online tool can be used to create extraordinary UI or animations with ease. It bridges the gap between the UI designer and the developer, reducing the time required to apply UI or animation related changes.

I have have used Flare and I was amazed at the simplicity of creating animations; with very shallow learning curve! You can see the app working here, I even added a refection to the ball, giving it a more realistic look.

**12. Flutter on desktop and the web.**

Everyone was stunned by the revelation that the Flutter team now has prototype Flutter apps working in a web browser. The previously Top Secret project, “Hummingbird” was unveiled to the world during Flutter Live. Soon, you’ll be able to use the same code to create apps for mobile, desktop and the web with ease.

![](https://cdn-images-1.medium.com/max/800/1*OlrI9IphckWpiNEzS9ielg.png)

**13.Continuous Support from the Flutter team & Flutter Community.**

I’ve been working with Flutter over the past 3 weeks and have noticed a lot of support and encouragement from the Flutter team & Flutter Community; especially [Scott Stoll](https://twitter.com/scottstoll2017), [Nilay Yener](https://twitter.com/nlycskn) and [Simon Lightfoot](https://twitter.com/devangelslondon), just to name a few. Every Wednesday many of the better known names in the Flutter community are available on Zoom at #HumpDayQandA, where you can get live help with Flutter from real human beings. It’s a great place to be even if you don’t have any questions of your own, because you learn a lot just from listening to them answer the questions of others.

![](https://cdn-images-1.medium.com/max/800/1*6fuFPHO1w15e3kPk8qp7GA.jpeg)

That’s me attending #HumpDayQandA. Tweet by Flutter GDE Amed Abu Eldahab, creator of Flutter Egypt

The value of using Flutter is easily apparent and highly attractive, because it alleviates many of the pain points faced by startups trying to release to multiple platforms; especially when dealing with limited time and budget to get the software product to market.

* * *

_Hi, I am Ganesh S P. An experienced Java developer, extensive creative thinker and an entrepreneur and a speaker, now venturing into the world of Flutter. You can find me on_ [_LinkedIn_](https://www.linkedin.com/in/ganesh-sp-a5981a7a) _or in_ [_github_](https://github.com/ganeshsp1) _or follow me in_ [_twitter_](http://Check%20out%20Ganesh%20S%20P%20%28@ganeshsp007%29:%20https://twitter.com/ganeshsp007?s=09)_. In my free time I am a content creator at_ [_GadgetKada_](https://www.youtube.com/gadgetkada)_. You could also mail me at ganesh.sp006@gmail.com to talk anything about tech._

Thanks to [Nash](https://medium.com/@Nash0x7E2?source=post_page) and [Scott Stoll](https://medium.com/@scottstoll2017?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
