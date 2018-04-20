> * 原文地址：[Why Flutter Will Change Mobile Development for the Best](https://android.jlelse.eu/why-flutter-will-change-mobile-development-for-the-best-c249f71fa63c)
> * 原文作者：[Aaron Oertel](https://android.jlelse.eu/@aaronoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-flutter-will-change-mobile-development-for-the-best.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-flutter-will-change-mobile-development-for-the-best.md)
> * 译者：
> * 校对者：

# Why Flutter Will Change Mobile Development for the Best

If you’re an Android developer, you may have heard of Flutter. It’s a relatively new, supposedly simple framework designed for making cross-platform native apps. It’s not the first of its kind, but it’s being used by Google, giving its claims some credence. Despite my initial reservations upon hearing about it, I decided on a whim to give it a chance — and it dramatically changed my outlook on mobile development within a weekend. Here is what I learned.

![](https://cdn-images-1.medium.com/max/1000/0*sKxcvPKWwr0G3FYg.)

“Hummingbird with a long beak flies through the air” by [Randall Ruiz](https://unsplash.com/@ruizra?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).

Before we get started, let me add a short disclaimer. The app I wrote and will be referencing in this article is relatively basic and **does not** contain a lot of business logic. It’s nothing fancy, but I wanted to share my experience and learnings from porting an existing native Android App to Flutter, and this is the best example I can use to do so. Neither app makes any efforts in terms of architecture; it’s purely about development experience and using the frameworks as they are.

* * *

Exactly one year ago, I published my first Android App in the [Play Store](https://play.google.com/store/apps/details?id=de.aaronoe.cinematic&hl=en). The app ([Github](https://github.com/aaronoe/Cinematic)) is pretty basic in terms of architecture and coding conventions; it was my first big open source project, which shows, and I’ve since come a long way with Android. I work at an agency, and spend time on quite a few projects with different technologies and architectures, including Kotlin, Dagger, RxJava, MVP, MVVM, VIPER and others, which has really helped my Android development.

That being said, over the past few months, I’ve been getting frustrated with the Android framework, especially regarding incompatibility and how counter intuitive it is to build apps in general. Don’t even get me started on build times… (I’d recommend [this article](https://medium.com/@steve.yegge/who-will-steal-android-from-google-af3622b6252e), which digs into more details) and while things have gotten a lot better with Kotlin and tools like Databinding, the whole situation still just feels like putting a band-aid on a wound that’s too big to be healed. Enter Flutter.

* * *

I began using Flutter a few weeks ago when it entered beta. I looked at the official documentation (which is great, by the way) and started going through the code labs and how-to guides. Quickly, I began to understand the basic ideas behind Flutter, and decided to try it out myself and see if I could put it into use. I started thinking about what kind of project I should work on first, and I decided to recreate my first Android app. This seemed like an appropriate choice as it would allow me to compare both “first-efforts” with the two respective frameworks, while not paying too much attention to app architecture, etc. It was purely about getting to know the SDKs by building a defined set of features.

I started by creating the network requests, parsing the JSON and getting used to Dart’s single-threaded concurrency model (which could be the topic of a whole other post on its own). I got up and running with some movie data in my app, and then started creating the layouts for the list and the list items. Creating layouts in Flutter is as easy as extending the Stateless or Stateful Widget classes and overriding a few methods. I’ll compare the differences in building those features between Flutter and Android. Let’s start with the steps required to build this list in Android:

1.  Create list-item layout files in XML
2.  Create an adapter to inflate the item-views and set the data
3.  Create the layout for the list (probably in an Activity or Fragment)
4.  Inflate that list layout in the Fragment/Activity
5.  Create instances of the adapter, layout-manager etc. in the Fragment/Activity
6.  Download the movie data from the network on a background thread
7.  Back on the main-thread set the items in the adapter
8.  Now we need to think about details like saving and restoring list-state…
9.  … the list goes on and on and on

This is, of course, tedious. And if you think about the fact that building these features is a fairly common task — seriously, it’s not some particularly rare use case that you’re unlikely to ever run into — you might find yourself wondering: is there really no better way to do it? A less error-prone way, maybe one that involves less boilerplate code, and increases development velocity? This is where Flutter comes in.

* * *

You can think of Flutter as the result of years of lessons that have been learned on mobile app development, state management, app architecture, and so on, which is why it’s so similar to React.js. Doing things the Flutter way just makes sense once you get started. Let’s look at how we can implement the above example in Flutter:

1.  Create a stateless widget (stateless, because we just have static properties) for the movie item, which takes as it’s constructor parameter a movie (as a Dart class for example) and describes the layout in a declarative way while binding the movie’s values (name, release date etc.) to the widgets
2.  Create a widget for the list like so. (I kept this example simple for the sake of this article. Obviously we would want to add error states etc and this is just one of the many things of doing this kind of work).

```
@override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: widget.provider.loadMedia(widget.category),
        builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
          return !snapshot.hasData
              ? new Container(
                  child: new CircularProgressIndicator(),
                )
              : new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      new MovieListItem(snapshot.data[index]),
                );
        }
    );
  }
```

Part of the Movie-List-Screen layout.

To break this down, let’s look at what’s happening here. Most importantly, we’re using a _FutureBuilder_ (part of the Flutter SDK), which requires us to specify a [_Future_](https://www.dartlang.org/tutorials/language/futures)(in our case the Api Call) and a builder function. The builder function gives us a _BuildContext_ and the _index_ of the item to be returned. Using this, we can retrieve a movie, given the list from the result of the Future, the snapshot, and create a MovieListItem-Widget (created in step 1) with the movie as a constructor argument.

Then, when the build method is first called, we start awaiting the value of the Future. Once it’s there, the builder is called again with the data (snapshot), and we can build our UI with it.

Those two classes, combined with the API call, would give us the following result:

![](https://cdn-images-1.medium.com/max/800/1*dQ3pH7pxROf1O6jsLFrN5Q.png)

The implemented Movie List.

* * *

Well, that was simple. Almost too simple…realizing how easy it was to create a list of items in Flutter piqued my curiosity, and made me even more excited to keep working with it.

The next step was figuring out what I could to with more complicated layouts. The detail screen for movies of the native app had a rather complicated layout, including constraint layouts and an app bar. I think this is something that users would expect and appreciate in an app, and if Flutter really wants to stand a chance against Android, it needs to be able to provide more complex layouts like this. Let’s look at what I managed to build:

![](https://cdn-images-1.medium.com/max/800/1*lBuPSg7dSWvOD0LNd5E-Fw.png)

Movie Detail Screen.

The layout consists of a _SliverAppBar,_ which contains a stacked layout of the movie image, a gradient, the little bubbles, and the text overlay. Being able to express the layout in a modular manner made it super simple to create this rather complicated layout. Here’s what the method of this screen looks like:

```
@override
Widget build(BuildContext context) {
  return new Scaffold(
      backgroundColor: primary,
      body: new CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(widget._mediaItem),
          _buildContentSection(widget._mediaItem),
        ],
      )
  );
}
```

Main build method of the Detail-Screen.

As I was building the layout, I found myself modularizing parts of the layout as variables, methods or just other widgets. For instance, the text bubbles on top of the image are just another widget, which take text and a background color as an argument. Creating a custom view is literally as easy as this:

```
import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  TextBubble(this.text,
      {this.backgroundColor = const Color(0xFF424242),
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(12.0)),
      child: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        child: new Text(
          text,
          style: new TextStyle(color: textColor, fontSize: 12.0),
        ),
      ),
    );
  }
}
```

Widget class for the Textbubble.

Imagine how hard it would be to build a custom view like this in Android. On Flutter, though, it’s just a matter of minutes. Being able to extract parts of your UI into self-contained units like widgets makes it easy to reuse those widgets across your app, or even across different apps. You’ll notice that many parts of the layout are reused across different screens of my app, and let me tell you this: it was a piece of cake to implement. It was _such_ a piece of cake that I decided to expand the app to incorporate TV-shows as well. A few hours later and it was done; the app incorporated both movies and TV-shows, and no headaches were gained in the process. I did it by building generic classes for loading and displaying the data, which let me re-use **every layout** for both movies and shows. But to accomplish the same thing with Android, I had to use separate activities for movies and shows. You can imagine how quickly that became maintainability hell, but I felt that Android just wasn’t flexible enough to share those layouts in a cleaner, easier way.

* * *

At the end of my Flutter experiment, I arrived at a very straight-forward and convincing conclusion:

> I wrote nicer, more maintainable code that runs on both iOS and Android. It also took considerably less time and fewer lines of code to do so.

One of the best parts was not having to deal with things like fragments, the _SupportCompatFragmentManagerCompat_, and preserving and manually managing state in a tedious, error-prone way. It’s just so much less frustrating than Android development…no more waiting 30 seconds for “Instant Reload” to change the font-size of a TextView. No more XML-Layouts. No more findViewById (I know that Butterknife, Databinding, Kotlin-Extensions exist, but you get my point). No more redundant boilerplate code — just results.

Once both apps were more or less on the same page in terms of features, I was curious to see what the difference in lines of code was. How does one repository compare to the other one? (Quick disclaimer: I haven’t integrated persistent storage in the Flutter app yet, and the code base of the original app is quite messy). Let’s compare the code using [Cloc](https://github.com/AlDanial/cloc), and for the sake of simplicity, let’s just look at the Java and XML files on Android, and the Dart files for the Flutter app (this does not include third party libraries, which would probably increase the metrics for Android significantly).

Native Android in Java:

```
Meta-Data for the native Android app

http://cloc.sourceforge.net v 1.60  T=0.42 s (431.4 files/s, 37607.1 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
Java                             83           2405            512           8599
XML                              96            478             28           3577
Bourne Again Shell                1             19             20            121
DOS Batch                         1             24              2             64
IDL                               1              2              0             15
--------------------------------------------------------------------------------
SUM:                            182           2928            562          12376
```

Flutter:

```
Meta-Date for the Flutter app

http://cloc.sourceforge.net v 1.60  T=0.16 s (247.5 files/s, 14905.1 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
Dart                             31            263             39           1735
Bourne Again Shell                1             19             20            121
DOS Batch                         1             24              2             64
XML                               3              3             22             35
YAML                              1              9              9             17
Objective C                       2              4              1             16
C/C++ Header                      1              2              0              4
--------------------------------------------------------------------------------
SUM:                             40            324             93           1992
--------------------------------------------------------------------------------
```

To break this down, let’s compare the file count first:
Android: 179 (.java and .xml)
Flutter: 31 (.dart)
Wow! And concerning lines of code we have:
Android: 12176
Flutter: 1735

That’s crazy! I was expecting the Flutter app to have maybe half the amount of code of the Android app, but _85% less_? That actually blew me away. But when you start thinking about it, it makes a lot of sense: since all the layouts, backgrounds, icons, etc. need to be specified in XML, but then still need to be hooked up to the app using Java/Kotlin code, of course there’s gonna be a ton of code. With Flutter, on the other hand, you can do all of that at once, while also binding the values to the UI. And you can do it all without dealing with the shortcomings of Android’s data-binding, like setting listeners or dealing with generated binding code. I realized then just how cumbersome it is to build such basic things on Android. Why should we write the same code for things like Fragment/Activity arguments, adapters, state management and recovery, over and over again, when it can be so simple?

> With Flutter, you focus on building your product and your product only. The SDK feels like a help and not a burden.

Of course, this is just the beginning of Flutter, as it’s still in Beta and not yet at the level of maturity that Android is at. Still, by comparison, it feels like Android might have reached its limits, and we may soon write our Android apps in Flutter. There are still some things that need to be worked out, but overall, the future is looking bright for Flutter; we already have great tooling with Plugins for Android Studio, VS Code and IntelliJ, profilers and view inspection tools, and more tools will come. This all leads me to believe that Flutter is more than just another cross-platform framework, but the beginning of something bigger — the beginning of a new era of app development.

And Flutter could go far beyond the realms of Android and iOS; if you’ve been following the rumor mill, you may have heard that Google is working on a new operating system named Fuchsia. As it turns out, Fuchsia’s UI is being built using Flutter.

* * *

Naturally, you might be asking yourself: do I have to learn a whole other framework now? We just started learning about Kotlin and using the architecture components, and everything is great now. Why would we want to learn about Flutter? But let me tell you this: after using Flutter, you’ll start to understand the problems with Android development, and it’ll become clear that Flutter’s design is more suitable for modern, reactive applications.

When I first started using Android’s Databinding, I thought it was revolutionary, but it also felt like an incomplete product. Dealing with Boolean expressions, listeners and more complicated layouts was tedious with Databinding, which made me realize that Android just wasn’t designed for a tool like this. Now if you look at Flutter, it uses the same idea as Databinding, which is binding your Views/Widgets to variables without having to manually do it in Java/Kotlin, but it does it all natively without bridging the XML and Java by generating a bindings file. This allows you to condense what would have previously been at least one XML and Java file, into one reusable Dart class.

I could also argue that the layout files on Android don’t do anything on their own. They have to be inflated first, and only then can we start setting values to them. This also introduces the issue of state management, and raises the question: what are we going to do when the underlying values change? Manually grab a reference to the corresponding views and set the new value? That method is really error prone and I don’t think it’s good to manage our View’s state like this; instead we should describe our layout using the state, and whenever the state changes, let the Framework take over by re-rendering the views whose values have changed. This way, our app state can’t get out of sync with what the Views display. And Flutter does exactly this!

And there might be even more questions: have you ever asked yourself why creating a toolbar menu is so complicated on Android? Why would we describe the menu items in XML, where we can’t bind any business logic to it anyways (which is the whole intention of a menu), just to then inflate it in a callback of our Activity/Fragment before binding the actual click listeners in yet _another_ callback? Why don’t we just do it all at once, like Flutter does?

```
class ToolbarDemo extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.star), 
              onPressed: _handleClickFavorite
          ),
          new IconButton(
              icon: new Icon(Icons.add), 
              onPressed: _handleClickAdd
          )
        ],
      ),
      body: new MovieDetailScreen(),
    );
  }

  _handleClickFavorite() {}

  _handleClickAdd() {}
}
```

Adding menu items to a Toolbar in Flutter.

As you can see in this snippet, we add the menu items as _Actions_ to our _AppBar_. That’s all you have to do — no more importing icons as XML files, no more overriding callbacks. It’s literally as easy as adding a few widgets to our widget tree.

* * *

I could go on and on, but I’ll leave you with this: think about all the things that you dislike about Android development, and then think about how you would go about re-designing the Framework while addressing those issues. That’s a heavy task, but doing it will help you understand why Flutter is here and, more importantly, why it’s here to stay. To be fair, there are many apps that (as of this moment) I would still write in native Android with Kotlin; Android may have its downfalls, but it also has its perks. But at the end of the day, I think making a case for native Android is becoming harder and harder when you have Flutter at your disposal.

* * *

By the way, both apps are open source and on the PlayStore. You can find them right here:
Native Android: [Github](https://github.com/aaronoe/Cinematic) and [PlayStore](https://play.google.com/store/apps/details?id=de.aaronoe.cinematic)Flutter: [Github](https://github.com/aaronoe/FlutterCinematic) and [PlayStore](https://play.google.com/store/apps/details?id=de.aaronoe.moviesflutter)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
