> * 原文地址：[Flutter Quotes App](https://medium.com/flutterdevs/flutter-quotes-app-bb30ef27b255)
> * 原文作者：[Anubhav Gupta](https://medium.com/@danubhav)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-quotes-app.md](https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-quotes-app.md)
> * 译者：
> * 校对者：

# Flutter Quotes App

![](https://miro.medium.com/max/3600/1*WGJ7_7_EXkJwzf1mVTyjrA.png)

## Introduction

I have been exploring flutter for the last 8 months, and today I am going to take you all on a journey where you will learn to make your own simple yet beautiful app where you will learn to make API requests too.

## Table Of Content

> * Fetching data from the internet.
> * Designing the UI for the app.
> * Styling the Text.

Let's begin …

## Initial Setup

Before we dive in, don't forget to add these packages to your project.

```yaml
animated_text_kit: ^3.1.0
google_fonts: ^1.1.1
http: ^0.12.2
```

## Create a new Flutter Project

Go on open your favorite IDE (VScode or Android Studio) and create a new flutter app and give a name your choice and save it somewhere in your local disk.

Delete the default generated code for the counter app and Create a main function that will run our Material app.

```dart
// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_quote_app/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Quotes App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen());
  }
}
```

## Fetching the data from API

To get the data we need an API from which we can get our raw data of quotes which will be in JSON format.

API Link to get data is [**here**](https://zenquotes.io/api/quotes). When you will click on the link it will give you raw data, Select all the text, and then in another tab open this link [**quicktype**](https://app.quicktype.io/) to instantly generate our **Dart Model**.

![](https://miro.medium.com/max/3840/1*zp9nqjB8poJ2Lb8gS-Zw3A.png)

Copy the raw data in the left column and give a name to the model Class.

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

Above is the generated dart model class.

### Let's create a function to make an API get requests.

```dart
// home.dart

static Future<List<Quotes>> fetchQuotes() async {
    final response = await http.get('https://zenquotes.io/api/quotes');
    if (response.statusCode == 200) {
      print(quotesFromJson(response.body).length);
      return quotesFromJson(response.body);
    } else {
      throw Exception('Failed to load Quote');
    }
  }
```

In the above code, we have an asynchronous method that will make a GET request, and then it will return the **list** of **Quotes** if the response code is **200**. Otherwise, throw an exception.

## Designing the UI

Now that we have all things ready let's make a Beautiful UI to show our quotes.

So the First thing is to create a stateful widget as **HomeScreen** which will have a **Widget** build method that will further return a Scaffold.

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
// call the API and fetch the response
  static Future<List<Quotes>> fetchQuotes() async {
    final response = await http.get('https://zenquotes.io/api/quotes');
    if (response.statusCode == 200) {
      print(quotesFromJson(response.body).length);
      return quotesFromJson(response.body);
    } else {
      throw Exception('Failed to load Quote');
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
            child: 
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

Here we have passed Column as a body of the Scaffold which has two expanded widgets. One with **flex** = **8** and the other with no flex which has a container as a child.

Also if you see the above code we have a void **initState** which will run as soon we navigate to **HomeScreen, ** It has our **fetchQuotes** method which will be called before the widgets are inserted in the tree.

> As we are working with API so we will use **FutureBuilder.**

> ***If your question is why?***

Since our UI will be built as soon as the app runs, but what about the ***response*** from API we will not receive it as soon as the app runs. So if your UI depends on API response values, then it will throw you a lot of null errors.

### Let’s Move to the Future :

The **FutureBuilder** is also a widget, so you can either have it attached to your **Scaffold** directly or attach it as a child to any widget you like. I’m going to use the **Expanded** widget as the Parent of **futureBuilder**.

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
// call the API and fetch the response
  static Future<List<Quotes>> fetchQuotes() async {
    final response = await http.get('https://zenquotes.io/api/quotes');
    if (response.statusCode == 200) {
      print(quotesFromJson(response.body).length);
      return quotesFromJson(response.body);
    } else {
      throw Exception('Failed to load Quote');
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

**FutureBuilder** has two main properties *future* and *builder*. So the **future** will call the ***fetchQuotes()*** method, it will do its magic “Network call” and return the result to the **snapshot** of the **builder**. Now simply create whatever widget you like with the result given.

Now what I wanted a behavior like this. While I am waiting for the results, I want to show the users a ***CircularProgressIndicator*** and as soon as the result is available, show the Page of quotes.

FutureBuilder makes this easy for you too.

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

Here I have created my *PageView Builder* widget ***buildPageView()*** and passed it to the child.

## Styling the Text

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
                'Quotes App',
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

Here inside the Page view builder, we have used **TyperAnimatedTextKit** for which you need to import the package, Inside the **TyperAnimatedTextKit**, we have a function that will help us to jump to the next page as soon the full string is typed on the screen. Also, we have used **Google Fonts** for that you need to import the package for the same.

![](https://miro.medium.com/max/1200/1*PvXgGVrBtx31_HFm_mcWtg.gif)

Voila !! You have created your first Quote App.

Code: [**flutter-devs/flutter_quote_app**](https://github.com/flutter-devs/flutter_quote_app.git)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
