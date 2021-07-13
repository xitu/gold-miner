> * 原文地址：[5 Reasons Why Flutter Is Better Than React Native](https://betterprogramming.pub/5-reasons-why-flutter-is-better-than-react-native-cf2e9b077f66)
> * 原文作者：[Shalitha Suranga](https://medium.com/@shalithasuranga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-reasons-why-flutter-is-better-than-react-native.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-reasons-why-flutter-is-better-than-react-native.md)
> * 译者：
> * 校对者：

# 5 Reasons Why Flutter Is Better Than React Native

![Photo by [Sandy Millar](https://unsplash.com/@sandym10?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/flutter?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10368/1*CuHCh8SBH_AY43P5kb2VYg.jpeg)

Nowadays, programmers have two competitive cross-platform application development choices: [Flutter](https://flutter.dev/) and [React Native](https://reactnative.dev/). We can use both frameworks to build cross-platform mobile apps and desktop apps. Both frameworks indeed look similar from the outside and in the available features. Hopefully, you have already read many comparisons and reviews about Flutter and React Native. Many developers think that Flutter won’t be widely used because it uses an unfamiliar programming language, [Dart](https://dart.dev/). A programming language is just an interface for developers to interact with the framework.

How a particular framework solves the cross-platform development problem is more important than the popularity of a specific framework’s programming language. I did some quick research on the internal architecture of both Flutter and React Native. Also, I created several applications on various platforms using both frameworks. Finally, I found the following benefits if you develop your next awesome app with Flutter.

## Flutter Has a Near-Native Performance

Nowadays, performance is so underrated because of powerful devices. However, users have devices with various sorts of specifications. Some users may try to run your application while running many other applications. Your application should work fine in all these conditions. Therefore, performance is still a crucial factor in modern cross-platform applications. Undoubtedly, an application written without any framework performs better than Flutter and React Native apps. But we often have to choose a cross-platform application framework for rapid feature delivery.

A typical React Native app has two separate modules: native UI and JavaScript engine. React Native renders native platform-specific UI elements based on React state changes. On the other hand, it uses a JavaScript engine (it’s [Hermes](https://github.com/facebook/hermes) in most scenarios) to run the application’s JavaScript. Every JavaScript-to-native and native-to-JavaScript call goes through a JavaScript bridge, similar to Apache Cordova’s design. React Native silently bundles your application with a JavaScript engine at the end.

Flutter apps don’t have any JavaScript runtimes, and Flutter uses binary messaging channels to build a bidirectional communication stream between Dart and native code. Flutter offers near-native performance for calling native code from Dart because of this binary messaging protocol and Dart’s ahead-of-time (AOT) compilation process. React Native apps may perform poorly when there are above-average native calls.

## Flutter Apps Have a Consistent UI

React Native renders platform-specific UI elements. For example, your application renders native iOS UI elements if you run your application on an Apple mobile device. Each platform defines unique design concepts for its UI elements. Some platforms have UI elements that other platforms don’t have. Therefore, even a simple UI change requires testing on multiple platforms if you use React Native. Also, you cannot overcome the limitations of platform-specific UI elements.

Flutter SDK defines its own UI toolkit. Therefore, your Flutter app looks the same on every operating system. Unlike React Native’s platform-specific UI elements, the Flutter team can introduce new features to each UI element. Thanks to flutter-theming, you can change your app’s theme based on the user’s settings on a particular operating system.

Almost all modern apps show their brand from the app’s design concepts. Flutter motivates to build consistent user experience across all supported operating systems with a consistent GUI layer.

---

## Flutter Offers a Productive Layout System

React Native has a FlexBox concept-based layout system created with the [Yoga](https://yogalayout.com/) layout engine. All web developers and UI designers are familiar with CSS FlexBox styling. React Native’s layout syntax is similar to CSS FlexBox syntaxes. Many developers often struggle with advanced CSS styles, and they often let the team’s UI developers fix CSS. Therefore, if you use React Native to make your next app, you need to hire a UI developer or ask mobile developers to become familiar with CSS FlexBox syntax.

Flutter has a widget tree-based layout system. In other words, Flutter developers typically define widgets in a render-tree-like data structure by overriding the [`build`](https://api.flutter.dev/flutter/widgets/StatelessWidget/build.html) method. They can imagine how each widget will render on the screen. Additional UI developers or FlexBox experience for existing developers is not required if you chose Flutter. Even a backend engineer can be familiar with this widget-tree concept quickly rather than the FlexBox concept.

You can increase the feature development speed of your cross-platform app thanks to Flutter’s tree-based layout system. When the application layout becomes complex, programmers can group widgets into different sections by assigning them to different Dart variables.

## Flutter Officially Supports All Popular Platforms

React Native officially supports only Android and iOS platforms. However, there are several forks of React Native that support desktop platforms. For example, Proton Native generates Qt and wxWidgets-based cross-platform desktop applications from React Native codebases. But Proton Native is not actively maintained now, and there is an active fork of it: Valence Native.

Also, Microsoft maintains two React Native forks: [`react-native-windows`](https://github.com/microsoft/react-native-windows) and [`react-native-macos`](https://github.com/microsoft/react-native-macos). If you wish to build a desktop application for your existing React Native app, there are several choices. Every popular React Native library doesn’t support all these forks. Also, there is no full-featured React Native fork for Linux yet.

Flutter officially supports Android, iOS, Linux, Windows, macOS, Fuchsia, and Web. All supported operating systems use the same rendering backend, [Skia](https://skia.org/). Flutter motivates all plugin developers to add implementations for all platforms by providing a high-performance Dart-to-Native binary communication mechanism and compromised documentation. Therefore, almost all popular Flutter plugins will work on all supported platforms.

## Your Flutter App Will Natively Run on Fuchsia

Probably you already know that Google is developing a new operating system from scratch, Fuchsia. The microkernel-architecture-based Zircon kernel powers Fuchsia. According to [Wikipedia](https://en.wikipedia.org/wiki/Google_Fuchsia), Google’s idea is to make Fuchsia a universal operating system that supports almost all devices (including embedded devices such as digital watches and traffic light systems). Google is building Fuchsia from many learnings from all existing platforms. Therefore, there is a higher probability for Fuchsia to become successful in the operating systems market.

Fuchsia is implementing the Starnix module to run Linux binaries inside Fuchsia. The Starnix module is still a very experimental module, according to its design [documentation](https://github.com/vsrinivas/fuchsia/tree/master/src/proc/bin/starnix#starnix). Apparently, they are trying to run Linux binaries by running the Linux kernel in a Docker-like container. Therefore, your React Native app won’t work on Fuchsia as a truly native app. If someone wishes to add a Fuchsia backend for React Native, someone needs to make another fork like `react-native-windows`.

Flutter SDK may become the default GUI application development kit on Fuchsia. Therefore, your Flutter app will work natively on Fuchsia.

## Conclusion

The React Native project is two years older than the Flutter project, and the entire React community backs it. Flutter’s community still is new and growing because Flutter doesn’t use Angular, and Dart wasn’t a popular general-purpose programming language earlier, like JavaScript. We still cannot [compare Flutter’s features](https://betterprogramming.pub/stop-comparing-flutters-current-stage-with-other-matured-frameworks-fcdbcf1e204b) with other mature cross-platform frameworks. But Flutter has solved the cross-platform problem via the most effective approach.

Both frameworks run on top of a native host application. React Native cannot improve its performance the same as Flutter because of its JavaScript runtime-based architecture. Try building apps with Flutter, and don’t be afraid by thinking that Dart is an unfamiliar language.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
