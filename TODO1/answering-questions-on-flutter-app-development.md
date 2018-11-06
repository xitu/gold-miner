> * 原文地址：[Answering Questions on Flutter App Development](https://medium.com/@dev.n/answering-questions-on-flutter-app-development-6d50eb7223f3)
> * 原文作者：[Deven Joshi](https://medium.com/@dev.n?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/answering-questions-on-flutter-app-development.md](https://github.com/xitu/gold-miner/blob/master/TODO1/answering-questions-on-flutter-app-development.md)
> * 译者：
> * 校对者：

# Answering Questions on Flutter App Development

![](https://cdn-images-1.medium.com/max/800/1*lMa5iiFWt33MxXUN7t9k6Q.png)

After interacting with a lot of students and developers personally and through my talks and workshops, I realised a lot of them have common questions and sometimes misconceptions about Flutter and app development in it. So I decided to write an article for clarifying doubts which were rather prevalent. Note that this article is meant to be an explainer rather than a point-perfect description of every aspect. There might be some exceptions I might not have covered for brevity. Note that Flutter itself also has a FAQ page for various backgrounds at [flutter.io](https://www.flutter.io) , I will be focusing more on questions I see asked frequently. Some of them are also included in the Flutter FAQs but I try to give my perspective on it.

#### Where are the layout files? / Why doesn’t Flutter have layout files?

In the Android framework, we separate an activity into layout and code. Because of this, we need to get references to views to work on them in Java. (Of course Kotlin lets you avoid that.) The layout file itself would be written in XML and consist of Views and ViewGroups.

Flutter uses a completely new approach where instead of Views, **you use widgets**. A View in Android was mostly an element of the layout, but in Flutter, a Widget is pretty much everything. Everything from a button to a layout structure is a widget. The advantage here is in **customisability**. Imagine a button in Android. It has attributes like text which lets you add text to the button. But a button in Flutter does not take a title as a string, but another widget. Meaning **inside a button you can have text, an image, an icon and pretty much anything you can imagine** without breaking layout constraints. This also lets you make customised widgets pretty easily whereas in Android making customised views is a rather difficult thing to do.

#### Isn’t drag-and-drop easier than making a layout in code?

In some respect, that is true. But a lot of us in the Flutter community prefer the code way but that does not mean drag-and-drop is impossible to implement. If you completely prefer drag-and-drop, then Flutter Studio is a fantastic resource I’d recommend which helps you generate layouts from drag-and-drop. It’s a tool I’m genuinely impressed by and would love to see how it grows.

Link: [https://flutterstudio.app](https://flutterstudio.app)

#### Does Flutter work like a browser? / How is it different from a WebView based application?

To answer this question simply: **Code you write for a WebView or an app that runs similarly has to go through multiple layers to finally get executed.** In essence, Flutter leapfrogs that by **compiling down to native ARM** code to execute on both platforms. “Hybrid” apps are slow, sluggish and look different from the platform they run on. Flutter apps run much, much faster than their hybrid counterparts. Also, it’s much easier to access native components and sensors using plugins rather than using WebViews which can’t take full use of their platform.

#### Why are there Android and iOS folders in the Flutter project?

There are three main folders in the Flutter project: lib, android and ios. ‘lib’ takes care of your Dart files. The Android and iOS folders exist to actually build an app on those respective platforms with the Dart files running on them. They also help you add permissions and platform-specific functionality to your project. When you run a Flutter project, it builds depending on which emulator or device it is running on, doing a Gradle or XCode build using the folders inside it. **In short, those folders are entire apps which set the stage for the Flutter code to run.**

#### Why is my Flutter app so large?

If you’ve run a Flutter application, you know it’s **fast**. Blazingly fast. How does it do that? When building an application, instead of only taking specific resources, it **essentially takes all of them**. Why does that help? Because if I change an icon from one to the other, it doesn't have to do a complete rebuild of the application. That’s why a Flutter **debug** build is so large. When a release build is created, only the needed resources are taken in and we get sizes we’re much more used to. Flutter apps will still be a tad bit larger than Android apps but it’s rather minuscule and plus the Flutter team is constantly looking for ways to reduce app size.

#### **If I am a novice in programming and I want to start with mobile development, should I start with Flutter?**

This has more of a two part answer.

1.  Flutter is quite nice to code in and has a lot less code than Android or iOS apps for the same pages. So for most applications, I don’t think there will be a major problem.
2.  One thing you need to keep in mind is Flutter also relies on Android and iOS projects and you need to be familiar with at least the project structure in those. If you want to write any native code, you definitely will need experience in either or both platforms.

My personal opinion would be learn Android/iOS for a month or two and then start with Flutter.

#### What are packages and plugins?

Packages allow you to **import new widgets or functionality** into your app. There is a small distinction between packages and plugins. Packages are usually new components or code written purely in Dart whereas plugins work to allow more functionality on the device side using native code. Usually on DartPub, both packages and plugins are referred to as packages and only while creating a new package is the distinction clearly mentioned.

#### What is the pubspec.yaml file and what does it do?

The Pubspec.yaml allows you to define the packages your app relies on, declare your assets like images, audio, video, etc. It also allows you to set constraints for your app. For Android developers, this is roughly similar to a build.gradle file, but the differences between the two are also evident.

#### Why does the first Flutter app build take so long?

When building a Flutter app for the first time, a **device-specific APK or IPA file is built**. Hence, Gradle and XCode are used to build the files, taking time. The next time the app is restarted or hot-reloaded, Flutter essentially patches the changes on top of the existing app giving a blazing fast refresh.

**Note:** The changes made with hot reload or restart **ARE NOT SAVED** on the device APK or IPA file. To ensure your app has all your changes on-device, consider stopping and running the app again.

#### What does State mean? What is setState()?

**In simple terms, “State” is a collection of the variable values of your widget.** Anything that can change like a counter count, text, etc. can be part of State. Imagine a counter app, the main dynamic thing is the counter count. When the count changes, the screen needs to be refreshed to display the new value. **setState() is essentially a way of telling the app to refresh and rebuild the screen with the new values.**

#### What are Stateful and Stateless widgets?

TL;DR: A widget that allows you to refresh the screen is a Stateful widget. A widget that does not is Stateless.

In more detail, a dynamic widget with content that can change should be a Stateful widget. A Stateless widget can only change content when the parameters are changed and hence needs to be done above the point of its location in the widget hierarchy. A screen or widget containing static content should be a stateless widget but to change the content, needs to be stateful.

#### How do you deal with indentation and structure in Flutter code?

Android Studio provides tooling to make structuring Flutter code easier. The two main things are:

1.  **Alt + Enter/ Command + Enter**: This allows you to easily wrap and remove widgets as well as swap widgets in a complex hierarchy. To use this simply point your cursor at the widget declaration and press the keys to give you a few options. This legitimately feels like a godsend at times.
2.  **DartFMT**: dartfmt formats your code to maintain a clean hierarchy and indentation. It makes your code much prettier to work with after you accidentally move a few brackets around.

#### Why do we pass functions to widgets?

We pass a function to a widget essentially saying, “invoke this function when something happens”. Functions are first class objects in Dart and can be passed as parameters to other functions. Callbacks using interfaces like Android (<Java 8) have too much boilerplate code for a simple callback.

**Java callback:**

```
button.setOnClickListener(new View.OnClickListener() {
    @override
    public void onClick(View view) {
      // Do something here
    }
  }
);
```

(Notice that this is only the code for setting up a listener. Defining a button requires separate XML code.)

**Dart equivalent:**

```
FlatButton(
  onPressed: () {
    // Do something here
  }
)
```

(Dart does both declaration as well as setting up the callback.)

This becomes much cleaner and organised and helps us avoid unnecessary complication.

#### What is ScopedModel / BLoC Pattern?

ScopedModel and BLoC(Business Logic Components) are common Flutter app architecture patterns to **help separate business logic from UI code and using fewer Stateful Widgets**. There are [better resources](https://medium.com/flutter-community/let-me-help-you-to-understand-and-choose-a-state-management-solution-for-your-app-9ffeac834ee3) to learn these and I do not believe it to be justified to explain them in a few lines.

I hope this article cleared up a few doubts here and there, and I will try to keep it updated with any common questions I get. Leave a few claps if you enjoyed the article and be sure to comment if you want me to add any other asked questions.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
