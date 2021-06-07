> * 原文地址：[Flutter Quotes App](https://medium.com/flutterdevs/flutter-quotes-app-bb30ef27b255)
> * 原文作者：[Anubhav Gupta](https://medium.com/@danubhav)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-quote-app.md](https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-quote-app.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[5Reasons](https://github.com/5Reasons)、[greycodee](https://github.com/greycodee)

# 使用 Flutter 构建一个名言名句应用程序

![](https://miro.medium.com/max/3600/1*WGJ7_7_EXkJwzf1mVTyjrA.png)

## 引言

在过去的 8 个月里，我一直在探索 Flutter。今天我将带着大家开始一段旅程，制作一个属于自己的简单而又漂亮的应用，并同时学会进行 API 请求。

## 目录 TOC

> 从互联网上获取数据。
> 设计应用程序的用户界面。
> 为文本设计样式。

让我们开始……

## 初步设置

在我们深入研究之前，不要忘记将这些包添加到你的项目中：

```yaml
animated_text_kit: ^3.1.0
google_fonts: ^1.1.1
http: ^0.12.2
```

## 创建一个新的 Flutter 项目

打开你最喜欢的 IDE（VScode 或 Android Studio），创建一个新的 Flutter 应用，并给它取一个你喜欢的名字，保存在本地磁盘的某个地方。

首先我们删除掉默认生成的计数器应用代码，并创建一个主函数来运行我们的 Material 应用程序。

```dart
// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_quote_app/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // 你的应用程序 Widget 树的根 Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '名言名句应用程序',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen());
  }
}
```

## 通过 API 获取数据

为了获得数据，我们需要一个 API 以获得名言名句的 JSON 格式的原始数据。

获取数据的 API 是 [**https://zenquotes.io/api/quotes**](https://zenquotes.io/api/quotes)。当你打开这个链接时，它会向你显示名言名句的原始数据。选择所有的文本复制一下，然后在另一个标签页中打开 [**quicktype**](https://app.quicktype.io/) 并粘贴进去，我们就可以立即生成我们的**Dart Model**。

![](https://miro.medium.com/max/3840/1*zp9nqjB8poJ2Lb8gS-Zw3A.png)

将原始数据复制到左侧栏中，并给模型类命名：

```dart
// quotesmodel.dart

import 'dart:convert';

List<Quotes> quotesFromJson(String str) =>
  List<Quotes>.from(json.decode(str).map((x) => Quotes.fromJson(x)));

String quotesToJson(List<Quotes> data) =>
  json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Quotes {
  Quotes({
    this.q,
    this.a,
    this.h,
  });

  String q;
  String a;
  String h;

  factory Quotes.fromJson(Map<String, dynamic> json) => Quotes(
      q: json["q"],
      a: json["a"],
      h: json["h"],
    );

  Map<String, dynamic> toJson() => {
      "q": q,
      "a": a,
      "h": h,
    };
}
```

以上是生成的 Dart 模型类。

### 让我们创建一个函数来请求 API 获取数据

```dart
// home.dart

static Future<List<Quotes>> fetchQuotes() async {
  final response = await http.get('https://zenquotes.io/api/quotes');
  if (response.statusCode == 200) {
    print(quotesFromJson(response.body).length);
    return quotesFromJson(response.body);
  } else {
    throw Exception('失败加载名言名句');
  }
}
```

在上面的代码中，我们有一个异步方法，作出一个 GET 请求。如果响应的状态码是 `200`，它就会返回**名言名句**的列表，否则就抛出一个异常。

## 设计 UI

现在我们已经准备好了所有的东西，让我们做一个漂亮的 UI 来显示我们的名言名句。

所以，首先要创建一个有状态的 Widget 作为 **HomeScreen** 界面。它将有一个 **Widget** 构建方法（返回一个 `Scaffold`）。

```dart
// home.dart

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quote_app/models/qoutemodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

PageController pageController = PageController(keepPage: true);

class _HomeScreenState extends State<HomeScreen> {
  // 调用 API 并获取数据
  static Future<List<Quotes>> fetchQuotes() async {
    final response = await http.get('https://zenquotes.io/api/quotes');
    if (response.statusCode == 200) {
      print(quotesFromJson(response.body).length);
      return quotesFromJson(response.body);
    } else {
      throw Exception('获取名言名句失败');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: /* TODO */
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
}
```

在这里，我们使用 `Column` 作为 `Scaffold` 的 `body` 属性值，包含两个 `Expanded` 子 Widget，一个有 `flex: 8`，另一个没有 `flex` 不过有一个 `Container` 作为子 Widget。

另外，如果你看到上面的代码，我们有一个 `void` 返回值的 `initState`。它将在我们导航到 `HomeScreen` 时运行。它有我们的 `fetchQuotes` 方法，在 Widget 被插入到树中之前被调用。

> 由于我们使用的是API，所以我们将使用 `FutureBuilder`。

> 为什么要用这个东西呢？

由于我们的 UI 会在应用运行后立即构建，但我们却无法立刻获取到来自 API 的***响应***，因此如果你的 UI 依赖于 API 响应值，那么它将会抛出很多的 `null` 错误。

### 让我们投奔 Future

`FutureBuilder` 也是一个 Widget，因此我们可以直接在我们的 `Scaffold` 上使用它，或者也可以把它作为一个子 Widget 连接到任何你喜欢的 Widget 上。在这里我将使用 `Expanded` Widget 作为 `FutureBuilder` 的父 Widget。

```dart
// home.dart

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quote_app/models/qoutemodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

PageController pageController = PageController(keepPage: true);

class _HomeScreenState extends State<HomeScreen> {
  // 调用 API 并获取数据
  static Future<List<Quotes>> fetchQuotes() async {
    final response = await http.get('https://zenquotes.io/api/quotes');
    if (response.statusCode == 200) {
      print(quotesFromJson(response.body).length);
      return quotesFromJson(response.body);
    } else {
      throw Exception('失败加载名言名句');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: FutureBuilder<List<Quotes>>(
              future: fetchQuotes(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Quotes>> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return buildPageView(snapshot);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }
```

`FutureBuilder` 有两个主要属性：`future` 和 `builder`。这里我们将 `future` 赋值为 `fetchQuotes()` 方法以运行获取数据的函数并将结果返回给 `builder` 的 `snapshot`。现在只要用给出的结果创建任何你喜欢的 Widget 即可。

现在我想要的是这样的行为：当我在等待结果的时候，我想向用户显示一个 `CircularProgressIndicator`。而一旦有了返回的数据就立即显示名言名句页面。

`FutureBuilder` 能帮助我们轻松实现：

```dart
future: fetchQuotes(),          
builder: (BuildContext context, AsyncSnapshot<List<Quotes>> snapshot) {
    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
       return buildPageView(snapshot);
    } else {
       return Center(child: CircularProgressIndicator());
    }
}
```

在这里，我们已经创建了我的 `PageView` Widget 构造器 `buildPageView()`，并将其传递给子 Widget。

## 样式化文本

```dart
// home.dart

PageView buildPageView(AsyncSnapshot<List<Quotes>> snapshot) {
    return PageView.builder(
      controller: pageController,
      itemCount: snapshot.data.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          // height: MediaQuery.of(context).size.height * 0.87,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.amberAccent[700],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(60),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          margin: EdgeInsets.only(bottom: 10),

          child: Stack(
            children: [
              Text(
                '名言名句应用程序',
                style: GoogleFonts.lobster(fontSize: 45, color: Colors.white),
              ),
              Align(
                alignment: Alignment.center,
                child: TyperAnimatedTextKit(
                  isRepeatingAnimation: false,
                  repeatForever: false,
                  displayFullTextOnTap: true,
                  speed: const Duration(milliseconds: 150),
                  onFinished: () {
                    pageController.nextPage(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOutCirc,
                    );
                  },
                  text: ['"' + snapshot.data[index].q + '"'],
                  textStyle: GoogleFonts.montserratAlternates(
                      fontSize: 30.0, color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  snapshot.data[index].a,
                  style: GoogleFonts.lora(fontSize: 14),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

在 PageView 构造器中，我们使用了 `TyperAnimatedTextKit`，而你也需要导入这个包。在 `TyperAnimatedTextKit` 里面有一个函数，可以帮助我们在屏幕上输入完整的字符串时跳到下一页。另外，我们使用了 **Google Fonts**，你也需要导入同样的包。

![](https://miro.medium.com/max/1200/1*PvXgGVrBtx31_HFm_mcWtg.gif)

瞧! 您已经创建了第一个名言名句应用程序。

本文代码：[**flutter-devs/flutter_quote_app**](https://github.com/flutter-devs/flutter_quote_app.git)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
