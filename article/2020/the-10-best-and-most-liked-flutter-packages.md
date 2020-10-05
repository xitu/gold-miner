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
这款 Flutter 插件能给你的项目添加一个功能丰富的最常在可滚动列表中用到的 slider 组件。Gmail 这款 APP 对 slider 组件的应用就非常广泛，足以说明其对用户操作便利性的帮助之大。

This plugin is packed with features and ready for use, but also highly customizable if needed. Some of the listed features are:
这个插件自带有很多开箱即用的特性，同时这不限制开发者对你进行个性化的定制，列举其重点特性如下：

* Accepts primary (left/top) and secondary (right/bottom) widget lists as slide actions
* 滑动状态可以取消
* 内建有四个操作按钮位
* 内建有两个滑动部件
* 内置滑动动画
* 轻松创建自定义布局与动画
* 点击操作按钮后自动关闭滑动状态（可以被覆写）
* Closes when the nearest `Scrollable` starts to scroll (overridable)
* 可通过配置关闭左右滑动特性

## 3. Shared Preferences

仓库地址: [https://pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences)
支持平台: iOS, Android, Web, Linux

这个库将对个系统平台的持久缓存库进行了包装，一般用来存储想用户设置这样简单的数据，其在各个系统平台的原生实现如下：

* iOS 和 macOS 采用 `NSUserDefaults` 实现
* Android 采用 `SharedPreferences`实现
* Web 环境采用 `LocalStorage` 实现
* Linux 环境下使用一个本地的 JSON 文件来存储

这个库一般情况下会异步将数据做本地持久缓存，但无法保证一定100%缓存成功，因此其一般用于存储那些非关键性的数据，对于 APP 中关键数据请采用下面介绍的 sqflite 来实现。

## 4. sqflite

仓库地址: [https://pub.dev/packages/sqflite](https://pub.dev/packages/sqflite)
支持平台: iOS, Android, MacOS

这是一个 Flutter 版的 SQLite 插件，同时支持 iOS、Android、MacOS 系统。值得注意的是因为 web 端没有基于 SQL 的数据存储实现，这个库是不支持在 web 端使用的。以下是它的一些特性：

* 支持事务和批处理
* 自动进行版本管理
* 提供了 CRUD 工具函数
* 在 Android 和 iOS 环境下数据库操作是在后台独立线程进行避免了 UI 线程阻塞

如果你期望的不仅仅是 `shared_preferences` 库能提供的基本数据存储功能，可以不用深入研究这个库了。

## 5. url_launcher

仓库地址: [https://pub.dev/packages/url_launcher](https://pub.dev/packages/url_launcher)
支持平台: iOS, Android, Web

这个插件可以帮你快速打开一个 URL，URL 地址可以是以下几个类型之一：

* HTTP: 例如 `http://example.org` 和 `https://example.org`
* 邮箱: mailto:\<e-mail 地址>
* 拨打电话: tel:\<phone 手机号>
* SMS短信: sms:\<phone 手机号>
 
基本使用非常简单，如下示例：

```dart
const url = 'https://flutter.dev';

if (await canLaunch(url)) {
  await launch(url);
} else {
  throw 'Could not launch $url';
}
```

## 6. video_player

仓库地址: [https://pub.dev/packages/video_player](https://pub.dev/packages/video_player)
支持平台: iOS, Android, Web

![图片和示例视频来自[pub.dev](https://pub.dev/packages/video_player)](https://cdn-images-1.medium.com/max/2000/1*ZLGqM8PidJjpjdapQFA3Tw.gif)

这个库支持多种视频格式播放，其能否完美支持各种视频格式取决于应用程序最终运行时所在的系统平台。例如，iOS 和 Android 系统背后所依赖的库是不一样，其视频格式支持程度也不相同。同样的，在 web 端这个库所支持的视频格式取决于用户所使用的的浏览器。

虽然这个库叫做 `video_player`，但是它也是支持音频播放的。另外这个库已经相当成熟，其 API 已经足够稳定，因此这个库也可以作为音频播放器的替代者。

这个库同时支持本地文件和远程服务器文件的播放，示例代码可以参考[这个](https://pub.dev/packages/video_player/example)。

## 7. crypto

仓库地址: [https://pub.dev/packages/crypto](https://pub.dev/packages/crypto)
支持平台: 所有平台

这是使用纯 Dart 语言开发的一套实现哈希加密的函数，这也意味着这个库可以独立使用不依赖于额外的第三方库。

这个库支持的加密算法如下：

* SHA-1
* SHA-224
* SHA-256
* SHA-384
* SHA-512
* MD5
* HMAC (例如：HMAC-MD5, HMAC-SHA1, HMAC-SHA256)

由于这是一个单纯的加密算法库并非 GUI 工具库，因此其支持全部平台。

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
