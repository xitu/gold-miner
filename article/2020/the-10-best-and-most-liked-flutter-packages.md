> * 原文地址：[The 10 Best and Most Liked Flutter Packages](https://medium.com/better-programming/the-10-best-and-most-liked-flutter-packages-f5813822e118)
> * 原文作者：[Erik van Baaren](https://medium.com/@eriky)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-10-best-and-most-liked-flutter-packages.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-10-best-and-most-liked-flutter-packages.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)
> * 校对者：

# The 10 Best and Most Liked Flutter Packages
# 10 个质量最佳且最受欢迎的 Flutter 工具库

![Illustration by author](https://cdn-images-1.medium.com/max/2000/1*MI0cApYdiUIa0ZcmvhIAdQ.png)

[Flutter](https://flutter.dev/) is “Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.”
[Flutter](https://flutter.dev/) 是谷歌为实现一套代码编译至移动端、web 端及桌面端应用而推出的一套 UI 开发框架。

Flutter is based on the Dart programming language. It has a large and lively community on [Dart.dev](https://pub.dev/), offering both officially supported and third-party packages to make Flutter development even more productive.
Flutter 是基于 Dart 编程语言来做开发，同时 Flutter 的开放社区——[Dart.dev](https://pub.dev/)也非常活跃，官方也在社区上提供技术支持，并且已经有大量的第三方工具包可供使用，这一切使得采用 Flutter 具有非常高的生产力。

This article lists the most promising and most popular packages to give you an idea of Flutter’s maturity as a platform.
这篇文章将列举最热门口碑最佳的 10 个 Flutter 工具库，以此来展示 Flutter 作为一种新型的软件开发平台的成熟程度。

If you haven’t done so already, [read my introductory article](https://medium.com/tech-explained/your-first-steps-with-flutter-dffa77378bd0) first. It will get you set up and running with a basic Flutter project in no time. This allows you to try out the packages you like most quickly!
如果你还没有使用过 Flutter，不妨先读一读我发布在 medium 上的[这篇文章](https://medium.com/tech-explained/your-first-steps-with-flutter-dffa77378bd0)，可以学会如何最快速地试用你自己喜欢的 Flutter 工具库。

## 1. HTTP

仓库地址: [https://pub.dev/packages/http](https://pub.dev/packages/http)

支持平台: iOS, Android, Web

Everything is web-based these days, so a robust HTTP library is a must-have. This Dart package contains a set of high-level functions and classes that make it easy to consume HTTP resources. It’s well developed and actively maintained by the Dart team. It has been around since 2012, so it should be rock-solid!
如今，所有的内容都基于网络，因此一款功能强大的 HTTP 请求库必不可少。这个工具库有 Dart 团队开发并还在积极维护者，其包含一系列的操作 HTTP 请求的高级函数和类。这个工具库始于 2012 年，绝对是非常靠谱的。

The library offers top-level functions that make it easy to work with HTTP:
此工具库提供的用于操作 HTTP 请求的高级函数用法实例:

```dart
import 'package:http/http.dart' as http;

# Posting data
var url = 'https://example.com/whatsit/create';
var data = {'name': 'Jack', 'age': 38};

var response = await http.post(url, body: data);

print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');

# A simple GET request
print(await http.read('https://example.com/foobar.txt'));
```

## 2. flutter_slidable

仓库地址: [https://pub.dev/packages/flutter_slidable](https://pub.dev/packages/flutter_slidable)

支持平台: iOS, Android, Web

![flutter_slidable 用法示例 ([source](https://pub.dev/packages/flutter_slidable))](https://cdn-images-1.medium.com/max/2000/1*-lxI0VkO5MCC3PW74VaLWA.gif)

The flutter_slidable plugin adds a feature-rich slider widget to your project. Sliders like this are often seen in scrollable lists. The Gmail app is a notable example, in which sliding list items offer a significant productivity enhancement.

This plugin is packed with features and ready for use, but also highly customizable if needed. Some of the listed features are:

* Accepts primary (left/top) and secondary (right/bottom) widget lists as slide actions
* Can be dismissed
* Four built-in action panes
* Two built-in slide action widgets
* Built-in dismiss animation
* Easily create custom layouts and animations
* Closes when a slide action has been tapped (overridable)
* Closes when the nearest `Scrollable` starts to scroll (overridable)
* Option to disable the slide effect easily

## 3. Shared Preferences

URL: [https://pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences)
支持平台: iOS, Android, Web, Linux

This package wraps platform-specific persistent storage libraries. It’s indented for simple data, like user preferences, and it uses:

* `NSUserDefaults` on iOS and macOS
* `SharedPreferences` on Android
* `LocalStorage` on websites
* A JSON file on the local filesystem for Linux

Data may be persisted to disk asynchronously, and there is no guarantee that writes will be persisted to disk after returning, so this plugin is not meant for storing critical data. For that look into sqflite (see below).

## 4. sqflite

URL: [https://pub.dev/packages/sqflite](https://pub.dev/packages/sqflite)
支持平台: iOS, Android, MacOS

This is the SQLite plugin for Flutter. It supports iOS, Android, and MacOS. The web is not supported since there is no SQL-based persistence system in web browsers. Some of its features are:

* Support for transactions and batches
* Automatic version management
* Helpers for insert/query/update/delete queries
* Operations are executed in a background thread on iOS and Android to prevent the UI from locking up

If you need more than basic (`shared_preferences`) data storage, look no further.

## 5. url_launcher

URL: [https://pub.dev/packages/url_launcher](https://pub.dev/packages/url_launcher)
支持平台: iOS, Android, Web

This plugin helps you launch a URL. URLs can be of the following types:

* HTTP: [http://example.org](http://example.org) and [https://example.org](https://example.org)
* E-mail: mailto:\<e-mail address>
* Phone numbers: tel:\<phone number>
* SMS text message: sms:\<phone number>

Basic usage is very straightforward:

```dart
const url = 'https://flutter.dev';

if (await canLaunch(url)) {
  await launch(url);
} else {
  throw 'Could not launch $url';
}
```

## 6. video_player

URL: [https://pub.dev/packages/video_player](https://pub.dev/packages/video_player)
支持平台: iOS, Android, Web

![Image and sample video from [pub.dev](https://pub.dev/packages/video_player)](https://cdn-images-1.medium.com/max/2000/1*ZLGqM8PidJjpjdapQFA3Tw.gif)

Many formats are supported, but it all depends on the platform you’re running. For example, the backing libraries differ for iOS and Android. Also, on the web, the supported formats depend on the browser you’re using.

Note that even though it’s called video_player, this plugin can also play audio. Since the plugin is pretty mature and has reached API stability, it’s not a bad idea to use this for audio over some of the alternatives.

This plugin can play video from a local file (assets) and a remote server (e.g., a website). For some example code, head over to [this page](https://pub.dev/packages/video_player/example).

## 7. crypto

支持平台: All platforms

Comping from the Dart team itself, this is a set of cryptographic hashing functions implemented in pure Dart. This means you don’t need external libraries to make this work.

The following hashing algorithms are supported:

* SHA-1
* SHA-224
* SHA-256
* SHA-384
* SHA-512
* MD5
* HMAC (i.e. HMAC-MD5, HMAC-SHA1, HMAC-SHA256)

Since this is not a GUI tool but simply a crypto library, it 支持平台 all supported platforms.

## 8. carousel_slider

URL: [https://pub.dev/packages/carousel_slider](https://pub.dev/packages/carousel_slider)
支持平台: iOS, Android, Web

![Sample carousel from [pub.dev](https://pub.dev/packages/carousel_slider)](https://cdn-images-1.medium.com/max/2000/1*lcQGQt_SoyfnQOLqWWlCKA.gif)

A carousel slider is part of many apps and websites. The carousel_slider plugin offers an excellent and customizable carousel that 支持平台 multiple platforms.

Because the carousel accepts widgets as content, you can slide anything that can be a widget.

For live examples, you can visit [this website](https://serenader2014.github.io/flutter_carousel_slider/#/), which uses Flutter web to demo the plugin.

Here’s an example of how to create a carousel in your app:

```dart
CarouselSlider(
  options: CarouselOptions(height: 400.0),
  items: [1,2,3,4,5].map((i) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.amber
          ),
          child: Text('text $i', style: TextStyle(fontSize: 16.0),)
        );
      },
    );
  }).toList(),
)
```

The carousel has several configurable options, like:

* the height and aspect ratio
* enabling infinite scrolling
* reversing the carousel
* enabling autoplay with a configurable interval, animation duration
* defining the scroll direction (vertical, horizontal)

## 9. path

URL: [https://pub.dev/packages/path](https://pub.dev/packages/path)
支持平台: iOS, Android, Web

Paths are both easy and incredibly complex because they differ from platform to platform. To make sure you don’t introduce bugs or security vulnerabilities in your code, always use the path library when dealing with paths. To join a directory and a file with the file separator for the current OS, use:

```dart
import 'package:path/path.dart' as p;
p.join('directory', 'file.txt');
```

## 10. location

URL: [https://pub.dev/packages/location](https://pub.dev/packages/location)
支持平台: iOS, Android, Web, MacOS

One of the great things about phones is their mobility combined with the ability to accurately track location. This has already given us many useful applications. The location plugin for Flutter makes it easy to get access to the current location. It provides callbacks when the location has changed. It also offers API endpoints to properly request access to a user’s location.

![Example Flutter app using location plugin ([source](https://pub.dev/packages/location))](https://cdn-images-1.medium.com/max/2000/1*8QvqbmxMjOoj9aOsbjRbiw.gif)

---

This is my top ten. What are your favorite Flutter packages? Let me know in the comments!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
