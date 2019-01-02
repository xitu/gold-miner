> * 原文地址：[Flutter For Android Developers : How to design LinearLayout in Flutter ?](https://proandroiddev.com/flutter-for-android-developers-how-to-design-linearlayout-in-flutter-5d819c0ddf1a)
> * 原文作者：[Burhanuddin Rashid](https://proandroiddev.com/@burhanrashid52?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-for-android-developers-how-to-design-linearlayout-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-for-android-developers-how-to-design-linearlayout-in-flutter.md)
> * 译者：[androidxiao(https://github.com/androidxiao)
> * 校对者：[Starriers](https://github.com/Starriers)

# Android 开发者的 Flutter 框架：如何在 Flutter 中设计 LinearLayout？

![](https://cdn-images-1.medium.com/max/2000/1*9JzKFil-Xsip742fdxDqZw.jpeg)

[Marvin Ronsdorf](https://unsplash.com/photos/1hGAXyyav64?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 在 [Unsplash](https://unsplash.com/search/photos/row-and-column?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 上​​拍摄的照片。

这个博客是面向 Android 开发人员的，旨在将他们现有的 Android 知识应用于使用 Flutter 构建移动应用程序。在这篇博客中，我们将探索 Flutter 中 LinearLayout 的等效设计部件。

### 系列  

* [如何在 Flutter 中设计 activity 的 UI？](https://blog.usejournal.com/flutter-for-android-developers-how-to-design-activity-ui-in-flutter-4bf7b0de1e48)

* 如何在 Flutter 中设计 LinearLayout？ （就在这里）

### 先决条件

这篇博客已假设您已经在 PC 中配置了 flutter，并且能够运行 Hello World 应用程序。如果您尚未安装 flutter，[请点击这里](https://flutter.io/get-started/)。

Dart 基于面向对象的概念，因此作为 android java 开发人员，您将能够轻松地掌握 dart。

### 让我们开始吧

如果您是 Android 开发人员，那么我假设您在设计布局时大量使用了 LinearLayout。对于那些不熟悉 LinearLayout 的人，我会给出官方定义。

>LinearLayout 是一种布局，可以将其它视图水平排列在单个列中，也可以垂直排列在单个行中。

![](https://cdn-images-1.medium.com/max/800/1*kE-KoY8nR4qT8nYHPrV0Pw.jpeg)

上面的效果展示和定义本身是一样的，您可以确定 Flutter 中的等效小部件是什么。是的，你是对的，它们是行列。

>**注意：**“行/列”小部件不会滚动。如果您有一系列小部件并希望它们能够在没有足够空间的情况下滚动，请考虑使用 [ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html)。

现在我们将介绍 LinearLayout 的一些主要属性，它们可以转换为 Flutter 中的等效小部件属性。

### 1. 方向

在 LinearLayout 中，您可以使用 android:orientation ="horizo​​ntal" 属性定义其子项的方向，该属性将水平/垂直作为与 Flutter 中的行/列小部件类似的值。

在 Android 中，LinearLayout 是 ViewGroup，可以向里面添加子 View。您可以在 <LinearLayout> </ LinearLayout> 标签内设置所有子 View。因此，为了在我们的 Row/Column 小部件中设置子小部件，我们需要使用 Row/Column.children 属性，该属性接受 List<Widget>。请参阅下面的代码片段。

```
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("LinearLayout Example"),
        ),
        body: new Container(
          color: Colors.yellowAccent,
          child: new Row(
            children: [
              new Icon(
                Icons.access_time,
                size: 50.0,
              ),
              new Icon(
                Icons.pie_chart,
                size: 100.0,
              ),
              new Icon(
                Icons.email,
                size: 50.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

在这个例子中，我们使用了 LinearLayout 的 android:orientation ="horizo​​ntal" 属性的 Row 小部件。我们使用 Column 作为垂直值。如果你想知道 Scaffold 在这里做什么，你可以阅读我之前的文章[如何在 Flutter 中使用 Scaffold 设计 activity UI？](https://blog.usejournal.com/flutter-for-android-developers-how-to-design-activity-ui-in-flutter-4bf7b0de1e48)

![](https://cdn-images-1.medium.com/max/800/1*DbZVIPcRxe7Mg8avHmf5Sw.jpeg)

![](https://cdn-images-1.medium.com/max/800/1*j8ikHPpLx46r3bwNveJubA.png)


### 2. "match_parent" vs "wrap_content"

*  MATCH_PARENT: 这意味着视图希望与其父视图一样大，如果您的视图是顶级根视图，那么它将与设备屏幕一样大。

* WRAP_CONTENT: 这意味着该视图要足够大以包含其内容。

为了获得 `match_parent` 和 `wrap_content` 的行为，我们需要在 Row/Column 小部件中使用 `mainAxisSize` 属性，`mainAxisSize` 属性采用 MainAxisSize 枚举，其中有两个值，即 `MainAxisSize.min` 和 `MainAxisSize.max`，的行为对应 `wrap_content` 和 `match_parent`。

在上面的例子中，我们没有为 Row 部件定义任何 mainAxisSize 属性，所以默认情况下它的 mainAxisSize 属性设置为 `MainAxisSize.max`，它是 `match_parent`。容器的黄色背景代表了自由空间的覆盖方式。这就是我们在上面的例子中定义这个属性的方法，并检查具有不同属性值的输出。
```
....
body: new Container(
  color: Colors.yellowAccent,
  child: new Row(
    mainAxisSize: MainAxisSize.min,
    children: [...],
  ),
)
...
```

![](https://cdn-images-1.medium.com/max/1000/1*bUP8rPQbN2w07QaEtz7ENA.png)

这就是我们如何在视觉上区分 Row/Column 小部件中使用的属性。

### 3. 权重

权重指定了在它自身的范围内子 view 如何摆放位置，我们使用具有多个对齐值的 `android:gravity ="center"` 在 LinearLayout 布局中定义默认权重。在使用 `MainAxisAlignment` 和 `CrossAxisAlignment` 属性的 Row/Column 小部件中可以实现相同的功能。

#### 1. [主轴对齐](https://docs.flutter.io/flutter/rendering/MainAxisAlignment-class.html):

这个属性定义了子 view 应该如何沿着主轴（行/列）放置。为了使这个有效，如果将值设置为 `MainAxisSize.min`，则应在 Row/Column 小部件中提供一些空间，即由于没有可用空间，`wrap_content` 设置 MainAxisAlignment 对小部件没有任何影响。
```
....
body: new Container(
  color: Colors.yellowAccent,
  child: new Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [...],
  ),
)
...
```
>一张图片胜过千言万语，我更喜欢视觉展示而不是描述每一个属性。

因此在此输出的情况下将 LinearLayout 属性与 Row Widget 中的 MainAxisAlignment 属性进行比较。

![](https://cdn-images-1.medium.com/max/1000/1*zQD7Hhg5WITKdQF1hqZyiQ.png)

现在，让我们将它与列控件进行比较。

![](https://cdn-images-1.medium.com/max/1000/1*cJFYgsnUl5hE5DLPCkbLMA.png)

>练习：您可以尝试其它枚举值，即 `spaceEvenly `, `spaceAround `，`spaceBetween`，其行为与我们在 ConstraintLayout 中使用的垂直/水平链相同。


#### 2. [交叉轴对齐](https://docs.flutter.io/flutter/rendering/CrossAxisAlignment-class.html) :

这个属性定义了子 view 应该如何沿横轴放置。这意味着如果我们使用 Row 小部件，则子 view 的权重将基于垂直线。如果我们使用 Column 小部件，那么子 view 将以水平线为基准。

这听起来很混乱吧！不要担心，随着阅读的进一步深入，你会理解得更透彻。

为了更好地理解，我们使它成为 `wrap_content`，即 `MainAxisSize.min`。你可以像下面的代码一样定义一个 `CrossAxisAlignment. start` 属性。

```
....
body: new Container(
  color: Colors.yellowAccent,
  child: new Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [...],
  ),
)
...
```

因此，在此下面输出将 LinearLayout 属性与 Row Widget 中的 CrossAxisAlignment 属性进行比较。

![](https://cdn-images-1.medium.com/max/1000/1*10EUefrNcIUIW3GGR5pRQg.png)

现在，让我们将它与列控件进行比较。


![](https://cdn-images-1.medium.com/max/1000/1*GdfFwLT_933GOj-KU9yeag.png)


拉伸行为有点不同，它将小部件伸展到最大可用空间，即与其交叉轴 `match_parent`。

### 3. 布局权重

要创建一个线性布局，其中每个子 view 使用相同的空间或在屏幕上以特定比例划分空间，我们将每个视图的 `android:layout_height` 设置为 `"0dp"`（对于垂直布局）或将每个视图的 `android:layout_width` 设置为 `"0dp"`（对于水平布局）。然后将每个视图的 `android:layout_weight` 设置为 `"1"` 或根据要划分的空间设置其它任何值。

为了在 flutter Row/Column 小部件中实现同样的功能，我们将每个子 view 包装到一个 `Expanded` 小部件中，该小部件的 flex 属性等同于我们的 `android:layout_weight`，因此通过定义 flex 值我们定义该应用特定子元素的空间量。

这就是你如何为每个孩子定义权重/弹性。
```
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("LinearLayout Example"),
        ),
        body: new Container(
          color: Colors.yellowAccent,
          child: new Container(
            child: new Row(
              children: [
                new Expanded(
                  child: new Container(
                    child: new Icon(
                      Icons.access_time,
                      size: 50.0,
                    ),
                    color: Colors.red,
                  ),
                  flex: 2,
                ),
                new Expanded(
                  child: new Container(
                    child: new Icon(
                      Icons.pie_chart,
                      size: 100.0,
                    ),
                    color: Colors.blue,
                  ),
                  flex: 4,
                ),
                new Expanded(
                  child: new Container(
                    child: new Icon(
                      Icons.email,
                      size: 50.0,
                    ),
                    color: Colors.green,
                  ),
                  flex: 6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

为了更好地理解，我们将每个图标包装在具有背景颜色的容器中，以便轻松识别窗口小部件已覆盖的空间。

![](https://cdn-images-1.medium.com/max/800/1*hLp6mC4eMA0RFp5dSFLlVg.png)

### 总结

LinearLayout 在 Android 中大量使用，与 Row/Column 小部件相同。希望在即将到来的博客中涵盖更多主题。我已经创建了一个示例应用程序来演示 Row/Column 属性以及这些属性在组合时如何工作。
![](https://cdn-images-1.medium.com/max/800/1*fbdY7IRyItUIW37WhqWzQQ.gif)

看看这里的 android 例子。

[burhanrashid52 / FlutterForAndroidExample：通过在GitHub上创建一个帐户，为 FlutterForAndroidExample 开发做出贡献。](https://github.com/burhanrashid52/FlutterForAndroidExample)

**谢谢 ！！！**

**如果您觉得这篇文章有帮助。请收藏，分享和拍手，这样其他人会在中看到这一点。如果您有任何问题或建议，请在博客上自由发表评论，或在 Twitter，Github 或 Reddit 上给我点赞。**

**要获取我即将发布的博客的最新更新，请在 Medium，Twitter，Github 或Reddit 上关注我。**

* [**Burhanuddin Rashid (@burhanrashid52) | Twitter**](https://twitter.com/burhanrashid52)

* [**burhanrashid52 (Burhanuddin Rashid) GitHub**](https://github.com/burhanrashid52)

* [**burhanrashid52 (u/burhanrashid52) — Reddit**](https://www.reddit.com/user/burhanrashid52/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
