> * 原文地址：[The 10 Best and Most Liked Flutter Packages](https://medium.com/better-programming/the-10-best-and-most-liked-flutter-packages-f5813822e118)
> * 原文作者：[Erik van Baaren](https://medium.com/@eriky)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-10-best-and-most-liked-flutter-packages.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-10-best-and-most-liked-flutter-packages.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)
> * 校对者：[juu574](https://github.com/juu574)

# The 10 Best and Most Liked Flutter Packages
# 10 款质量最佳最受欢迎的 Flutter 工具库

![由作者供图](https://cdn-images-1.medium.com/max/2000/1*MI0cApYdiUIa0ZcmvhIAdQ.png)

[Flutter](https://flutter.dev/) 是谷歌为实现一套代码编译至移动端、web 端及桌面端应用而推出的一套 UI 开发框架。

Flutter 是基于 Dart 编程语言来做开发的，同时 Flutter 的开放社区——[Dart.dev](https://pub.dev/)也非常活跃，官方也在社区上提供技术支持，并且已经有大量的第三方工具包可供使用，这一切使得 Flutter 开发框架具有非常高的生产力。

这篇文章将列举最热门口碑最佳的 10 个 Flutter 工具库，以此来展示 Flutter 作为一种新型的软件开发平台的成熟程度。

如果你还没有使用过 Flutter，不妨先读一读我发布在 medium 上的[这篇文章](https://medium.com/tech-explained/your-first-steps-with-flutter-dffa77378bd0)，可以学会如何最快速地使用你自己喜欢的 Flutter 工具库。

## 1. HTTP

仓库地址：[https://pub.dev/packages/http](https://pub.dev/packages/http)

支持平台：iOS、Android、Web

如今，所有的内容都基于网络，因此一款功能强大的 HTTP 请求库必不可少。这个工具库由 Dart 团队开发并还在积极维护着，其包含一系列的操作 HTTP 请求的高级函数和类。这个工具库始于 2012 年，绝对是非常靠谱的。

此工具库提供的用于操作 HTTP 请求的高级函数用法实例:

```dart
import 'package:http/http.dart' as http;

# POST请求
var url = 'https://example.com/whatsit/create';
var data = {'name': 'Jack', 'age': 38};

var response = await http.post(url, body: data);

print('Response status: ${response.statusCode}');
print('Response body: ${response.body}');

# GET请求
print(await http.read('https://example.com/foobar.txt'));
```

## 2. flutter_slidable

仓库地址：[https://pub.dev/packages/flutter_slidable](https://pub.dev/packages/flutter_slidable)

支持平台：iOS、Android、Web

![flutter_slidable 用法示例 ([查看源码](https://pub.dev/packages/flutter_slidable))](https://cdn-images-1.medium.com/max/2000/1*-lxI0VkO5MCC3PW74VaLWA.gif)

用就非常广泛，足以说明其对用户操作便利性的帮助之大。

这个插件自带有很多开箱即用的特性，同时这不限制开发者对其进行个性化的定制，以下是其主要特性：

* 接受primary（左/上）和secondary（右/下）窗口小部件列表作为操作列表
* 滑动状态可以取消
* 内建有四个操作按钮位
* 内建有两个滑动部件
* 内置滑动动画
* 轻松创建自定义布局与动画
* 点击操作按钮后自动关闭滑动状态（可被重写）
* 最近的“Scrollable”开始滚动时关闭（可被重写）
* 可通过配置关闭左右滑动特性

## 3. Shared Preferences

仓库地址: [https://pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences)
支持平台: iOS, Android, Web, Linux

这个库将对个系统平台的持久缓存库进行了包装，一般用来存储像用户设置这样的简单数据，其在各个系统平台的原生实现如下：

* iOS 和 macOS 采用 `NSUserDefaults` 实现
* Android 采用 `SharedPreferences`实现
* Web 环境采用 `LocalStorage` 实现
* Linux 环境下使用一个本地的 JSON 文件来存储

这个库一般情况下会异步将数据做本地持久缓存，但无法保证一定100%缓存成功，因此其一般用于存储那些非关键性的数据，对于 APP 中关键数据请采用下面介绍的 sqflite 来实现。

## 4. sqflite

仓库地址：[https://pub.dev/packages/sqflite](https://pub.dev/packages/sqflite)
支持平台：iOS、Android、MacOS

这是一个 Flutter 版的 SQLite 插件，同时支持 iOS、Android、MacOS 系统。值得注意的是因为 web 端没有基于 SQL 的数据存储实现，这个库是不支持在 web 端使用的。以下是它的一些特性：

* 支持事务和批处理
* 自动进行版本管理
* 提供了 CRUD 工具函数
* 在 Android 和 iOS 环境下数据库操作是在后台独立线程进行避免了 UI 线程阻塞

如果你期望的不仅仅是 `shared_preferences` 库能提供的基本数据存储功能，可以不用深入研究这个库了。

## 5. url_launcher

仓库地址：[https://pub.dev/packages/url_launcher](https://pub.dev/packages/url_launcher)
支持平台：iOS、Android、Web

这个插件可以帮你快速打开一个 URL，URL 地址可以是以下几个类型之一：

* HTTP：例如 `http://example.org` 和 `https://example.org`
* 邮箱：mailto:\<e-mail 地址>
* 拨打电话：tel:\<phone 手机号>
* SMS 短信：sms:\<phone 手机号>
 
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

仓库地址：[https://pub.dev/packages/video_player](https://pub.dev/packages/video_player)
支持平台：iOS、Android、Web

![图片和示例视频来自[pub.dev](https://pub.dev/packages/video_player)](https://cdn-images-1.medium.com/max/2000/1*ZLGqM8PidJjpjdapQFA3Tw.gif)

这个库支持多种视频格式播放，其能否完美支持各种视频格式取决于应用程序最终运行时所在的系统平台。例如，iOS 和 Android 系统背后所依赖的库是不一样，其视频格式支持程度也不相同。同样的，在 web 端这个库所支持的视频格式取决于用户所使用的浏览器。

虽然这个库叫做 `video_player`，但是它也是支持音频播放的。另外这个库已经相当成熟，其 API 已经足够稳定，因此这个库也可以作为音频播放器的替代者。

这个库同时支持本地文件和远程服务器文件的播放，示例代码可以参考[这个](https://pub.dev/packages/video_player/example)。

## 7. crypto

仓库地址：[https://pub.dev/packages/crypto](https://pub.dev/packages/crypto)
支持平台：所有平台

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

仓库地址：[https://pub.dev/packages/carousel_slider](https://pub.dev/packages/carousel_slider)
支持平台：iOS、Android、Web

![轮播示例图来自 [pub.dev](https://pub.dev/packages/carousel_slider)](https://cdn-images-1.medium.com/max/2000/1*lcQGQt_SoyfnQOLqWWlCKA.gif)

轮播图在各个 APP 和网站中非常常见，这个轮播图插件库提供了出色的可定制的轮播插件，同时支持了多个平台。

这个插件接受 widget 部件作为轮播的内容项，因此一切可以作为 widget 部件模块都可以作为轮播插件的轮播项。

[这个网站](https://serenader2014.github.io/flutter_carousel_slider/#/)是使用 Flutter 开发的 web 端网站，使用了此插件实现了一些轮播效果的 demo，可以点击查看。

以下是在 APP 开发中使用此插件的示例：

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

此插件有非常多的可配置参数，例如：

* 高度和宽高比
* 支持无限滚动
* 反转滚动方向
* 支持自动开始滚动，支持配置滚动间隔，支持滚动动画持续时间
* 支持配置滚动方向为：水平或垂直

## 9. path

仓库地址：[https://pub.dev/packages/path](https://pub.dev/packages/path)
支持平台：iOS、Android、Web

路径处理既简单又异常复杂，因为在不同系统平台处理方式有所不同。要保证不引入 bug 和安全漏洞，通常需要使用路径解析库来专门处理路径。使用这个库可以非常方便的拼接路径、文件名及当前系统对应的分隔符，示例如下：

```dart
import 'package:path/path.dart' as p;
p.join('directory', 'file.txt');
```

## 10. location

仓库地址：[https://pub.dev/packages/location](https://pub.dev/packages/location)
支持平台：iOS、Android、Web、MacOS

手机的一大优点是它的便携性与精确定位能力相结合，这一能力已经为我们创造了非常多的应用。这款location定位插件使得定位用户当前位置变得更新简单轻松。它既支持监听用户定位改变的回调，又提供了 API 接口以便在适当时机向系统申请用户地址访问权限。

![ Flutter 应用中使用 location 插件示例图片 ([访问源码](https://pub.dev/packages/location))](https://cdn-images-1.medium.com/max/2000/1*8QvqbmxMjOoj9aOsbjRbiw.gif)

---

以上是我推荐的 10 款最受欢迎的 Flutter 工具库，如果你有更好的 Flutter 工具库推荐，欢迎在底下评论区留言！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
