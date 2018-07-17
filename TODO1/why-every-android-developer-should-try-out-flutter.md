> * 原文地址：[Why every Android Developer should try out Flutter](https://proandroiddev.com/why-every-android-developer-should-try-out-flutter-319ae710e97f)
> * 原文作者：[Aaron Oertel](https://proandroiddev.com/@aaronoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-every-android-developer-should-try-out-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-every-android-developer-should-try-out-flutter.md)
> * 译者：
> * 校对者：

# Why every Android Developer should try out Flutter

A few months ago, I wrote an article titled “[Why Flutter Will Change Mobile Development for the Best](https://proandroiddev.com/why-flutter-will-change-mobile-development-for-the-best-c249f71fa63c).” Some time has since passed, but my love for Flutter remains as strong as ever; in fact, as I’ve continued using it, I’ve realized the importance of a unique aspect of Flutter that I’d previously overlooked. Don’t get me wrong — I still believe that one of Flutter’s strongest suits is how it solves a lot of problems of cross platform development, but it’s recently opened my eyes to even more areas of improvement in mobile development, specifically the notion of declarative UIs.

![](https://cdn-images-1.medium.com/max/800/0*pV87QzKfowqgkEkd)

Photo by [Chris Charles](https://unsplash.com/@licole?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

I’m sure you’ve already heard a list of arguments as to why Android Developers should care about Flutter (or if you haven’t, let me humbly suggest you check [this](https://proandroiddev.com/why-flutter-will-change-mobile-development-for-the-best-c249f71fa63c) out), but I want to point out a pretty big pro that I haven’t really seen addressed yet, and that is the way that Flutter can make you think completely differently about App development. This starts with the fact that your app will inherently be architectured in a different way — but even more important than that is the fact that the actual UI development is pushed into the foreground by incorporating it into your dart code (instead of xml), thus making it a “first class citizen.” And once your UI code suddenly lives in a non-markup-language, you’ll realize what possibilities you suddenly have for building your apps. To be honest, I started to hate working on UI code on Android after using Flutter; it’s just so much more tedious in Android, and while you can still build reactive applications with tools like databinding, it really is much more time-consuming than in Flutter.

This argument for Flutter becomes even stronger when you think about incorporating animations and other dynamic data in Android. It can be inconvenient to incorporate animations, and sometimes you may even have to turn down your designer’s request because it’s just too difficult to implement what they’re asking for. Thankfully, Flutter changes that. If you’ve been following Flutter, you may have heard of the **_Flutter Challenges_** from [Fluttery](https://medium.com/fluttery). These challenges show you how fast and intuitive it can be to build complicated UIs with lots of custom widgets and fancy designs, including animations. Implementing such things on Android can get really difficult — especially due to the fact that unlike Flutter, Android’s Views are based on inheritance over composition, which complicates building Views even more.

So let’s cut to the chase: Flutter makes **building UIs declarative**, and that changes everything about UI development. Now maybe you’re thinking, _Aren’t Android layouts build declaratively as well?_ The answer to that is yes, but no. Using XML to define layouts gives us the feeling of defining layouts declaratively, but that only really holds true if your views are fully static and all your data is set up in XML. Unfortunately, that’s almost never the case; Once you add dynamic data and something like lists, you’ll naturally have to use some Java/Kotlin code to bind the data to the views. We then end up having some sort of Viewmodel, which sets the data to the view. Think of this like calling `textView.text = “Hello Medium!”` on Android. On Flutter, this is completely different: you create a widget class which contains some state, and then define your layout declaratively based on that state. Whenever the state changes, we call `setState()` to re-render the parts of our widget-tree that changed. Let’s look at how we could consume an api in Flutter and render a list with the result:

```
@override
Widget build(BuildContext context) {
  return new FutureBuilder<Repositories>(
    future: apiClient.getUserRepositoriesFuture(username),
    builder: (BuildContext context, 
        AsyncSnapshot<Repositories> snapshot) {
      if (snapshot.hasError)
        return new Center(child: new Text("Network error"));
      if (!snapshot.hasData)
        return new Center(
          child: new CircularProgressIndicator(),
        );
      return new ListView.builder(
        itemCount: snapshot.data.nodes.length,
        itemBuilder: (BuildContext context, int index) =>
            new RepoPreviewTile(
              repository: snapshot.data.nodes[index],
            ),
      );
    },
  );
}
```

Here, we’re using a `FutureBuilder` that awaits the completion of our network-call (Future), and once that network call completes with a result or error, the `FutureBuilder` widget internally calls `setState` to re-render using the provided `builder` -method. And as you can see in this example, everything is **declarative**. Doing the same thing on Android usually requires a passive XML-layout and then a bunch of other classes that set the state manually, like adapters and viewmodels. The problem with this approach is that the state can be different from what’s rendered on the screen, and that’s why we want to have declarative layouts like the ones Flutter provides for us. We end up writing far less code, while keeping the state bound to what we want to show on the screen.

With those kind of declarative layouts, we also start thinking differently about architecture. Suddenly the word _reactive_ pops up, and we talk a lot more about state-management than we do about architecture. With Flutter, architectures like MVP and MVVM don’t make that much sense anymore; instead of using them, we think about how the state could flow through our app. State suddenly becomes a big part of the discussion and we devote more and more energy to thinking of new ways to architect our apps. It’s a new journey for all of us and there a lot of things to figure out, and most importantly, it’s an opportunity for us to broaden our horizons.

To be fair, Flutter is not all sunshine and rainbows. I’m currently working on a bigger project with Flutter to understand what its weaknesses are, and the biggest flaw I’ve come across so far is the lack of infrastructure. This really became apparent to me when I was trying to consume a graphql-api; while there certainly are libraries for doing that, they don’t come close to what Android has with Apollo. The good news, however, is that it’s just a matter of time before Flutter catches up, and it’s not that difficult to extend existing libraries or even build your own in the meantime. Just be aware that you might have to invest some time into the infrastructure of your app, while that normally wouldn’t be the case for Android and iOS — after all, there is no free lunch.

In the end, one of my biggest recent takeaways from using Flutter is just how beneficial it can be to experience this declarative way of building UIs, as well as its implications on state management. I think Flutter is fantastic; still, I caution you to not think of it as the silver bullet that is going to solve all of your problems, but as an innovative new tool to build beautiful, custom UIs faster than on Android. More importantly, it will show you the power of declarative layouts and make you think of your app in rendered state instead of non-cohesive activities, views and viewmodels — and for that reason alone, I would highly suggest giving Flutter a try.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
