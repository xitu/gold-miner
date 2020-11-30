> * 原文地址：[Flutter May or May Not Be the Next Big Thing, But Kotlin Multiplatform Is Here to Stay](https://medium.com/better-programming/flutter-may-or-may-not-be-the-next-big-thing-but-kotlin-multiplatform-is-here-to-stay-baf1a44a692d)
> * 原文作者：[Anupam Chugh](https://medium.com/@anupamchugh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/flutter-may-or-may-not-be-the-next-big-thing-but-kotlin-multiplatform-is-here-to-stay.md](https://github.com/xitu/gold-miner/blob/master/article/2020/flutter-may-or-may-not-be-the-next-big-thing-but-kotlin-multiplatform-is-here-to-stay.md)
> * 译者：
> * 校对者：

# Flutter May or May Not Be the Next Big Thing, But Kotlin Multiplatform Is Here to Stay

![Photo by [Marc Reichelt](https://unsplash.com/@mreichelt?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/8064/0*p9BRbpAgNsMKNKJS)

Google’s Flutter framework has gained huge momentum in the past year. It’s become the talk of the town with some touting it as the next big thing, while others are passing it off as just another shiny new technology.

While the rise of Flutter is a good sign for cross-platform app development, it has left native Android developers confused. A lot of them who are starting out find themselves in a dilemma:

* Should they stick with native Android and Kotlin or switch over to Flutter and Dart?
* Will Google kill native Android development in favor of Flutter?

Considering that both the native Android and Flutter frameworks are technologies that come from Google’s own arsenal, deciding between them isn’t an easy task.

Google’s relentless support for Flutter only makes Android developers more worried and scared about Kotlin’s future in the ecosystem.

Before I talk about what the future holds for Android developers, I’d like to discuss two amazing articles that put forth contrasting views on Flutter’s future.

So here’s their brief summary:

* [Michael Long](undefined) stated Flutter “[isn’t the next big thing](https://medium.com/better-programming/why-flutter-isnt-the-next-big-thing-e268488521f4)” and put forth some valid points. It’s true, Flutter will always be a second-class citizen on iOS and Google has a knack for killing products and technologies faster than anyone.
* [Erik van Baaren](undefined) said Flutter “[is in fact the next big thing](https://medium.com/better-programming/why-flutter-is-in-fact-the-next-big-thing-in-app-development-8f514dd3a252)”. He raised a great counterargument in the form of Dart’s compatibility with Fuchsia(perhaps the future of Android OS).

The debate was so interesting that perhaps none of us can decide if Flutter is indeed the next big thing.

The idea behind mentioning these articles isn’t to add more fuel to the fire in the Flutter debate. Instead, I want to shift the focus back towards native Android development.

Flutter’s meteoric rise in popularity has certainly cast a doubt in the minds of Android developers since nobody is talking about Kotlin’s future.

We may or may not know if Flutter is the next big thing in app development. Regardless of that, Kotlin today offers multiplatform support, which means one can run the code regardless of the underlying architecture. This is indeed revolutionary and I’d like to sneak in and call it the next big thing.

Thankfully, Kotlin’s platform-independent support means Android developers needn’t sweat too much. Despite the mobile developer community’s admiration for Flutter, Kotlin is here to stay regardless of the future of Flutter and Fuschia.

Before we dig deep into Kotlin’s promising future, let's take a step back and analyze why Google introduced Flutter (a competing technology to native Android) in the first place.

## Flutter Was Not Introduced to Kill Native Android. Instead, It’s Here to Save It for a Rainy Day

For the uninitiated, Flutter is Google’s cross-platform framework to build apps that run on Android, iOS, the web, and desktop. It uses Google’s Dart language and doesn’t offer any compatibility with Java Virtual Machines (JVM).

Google’s idea behind introducing a separate framework wasn’t really to compete with its own native Android tools. Instead, it was looking to hedge Android due to the nightmare Oracle had bestowed upon them.

For those who are unfamiliar, Oracle and Google have been in a legal tussle for years due to the use of a certain Java API and JVM in Android devices.

The introduction of JetBrains-powered Kotlin and its subsequent announcement as the preferred language for Android development didn’t really absolve Google of its worries, as Kotlin — much like Java — still needed JVM to run (at that time, Kotlin/Native was nascent).

Hence in a bid to get total control over its software ecosystem, Google brought in the Flutter framework and Fuschia OS. Dart is a language that’s compiled to native machine code, thereby eliminating the need to rely on Oracle’s Java Virtual Machine.

At the same time, Fuschia OS is perhaps Google’s effort to move away from Linux-based devices and ensure that the future of Android development is preserved with Flutter.

But that doesn’t mean the current lot of Kotlin developers are left at bay.

## Kotlin Multiplatform Has a Bright Future in Mobile App Development

Kotlin for Android is widely known by developers all over the world, but it’s just one aspect of JetBrains Kotlin Multiplatform projects.

The other subsets include Kotlin/JS (which transpires Kotlin code), the Kotlin standard library, and any compatible dependencies with JavaScript.

But most importantly, there’s Kotlin/Native for compiling Kotlin code to native binaries, which can run without a virtual machine. This effectively means that you can use Kotlin code for iOS Linux, macOS, Windows, and other embedded devices.

The crucial thing to note about Kotlin/Native is that it doesn’t use common UI and only reuses business logic modules. This means if you’re using Kotlin/Native for building the iOS app, you only have to write the specific platform API and/or UI code (SwiftUI/UIKit).

While the sad news is this doesn’t really position Kotlin/Native as a replacement for Flutter at the moment, it does ensure that you can build 100% native apps — something none of the cross-platforms have managed to pull off.

Nevertheless, Kotlin’s ability to support multiple runtime targets — much like Dart — ensures that JetBrains’ language isn’t going away and will continue to be an important cogwheel for Android developers.

In fact, Jetpack Compose (Android’s declarative UI framework) strongly indicates platform-independent support in the future, which makes Kotlin Multiplatforms a contender for cross-platform app development.

Lastly, in case Fuschia OS does replace Android, Kotlin developers would still be around. Android is a much bigger ecosystem than Flutter and one wouldn’t really be surprised if JetBrains added Kotlin-to-Dart transpiler support, thereby ensuring Kotlin targets the future OS.

## Takeaway

Despite Flutter’s growing popularity, native Android developers needn’t worry too much.

Kotlin Multiplatforms not only solves the Android-JVM dilemma but also ensures that native app development is here to stay despite the abundance of cross-platform frameworks.

Netflix recently showcased that Kotlin Multiplatforms is indeed [production-ready](https://netflixtechblog.com/netflix-android-and-ios-studio-apps-kotlin-multiplatform-d6d4d8d25d23).

So:

* If you are a native Android developer, stick with Kotlin.
* If you are an Android developer who knows Kotlin and wants to dabble with the native iOS ecosystem, use Kotlin Multiplatform.
* If you’d like to play with cross-platform frameworks, use Flutter.

Kotlin or native Android development isn’t going anywhere regardless of what the future holds for Flutter.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
