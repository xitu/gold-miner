> * 原文地址：[Flutter For Android Developers : How to design LinearLayout in Flutter ?](https://proandroiddev.com/flutter-for-android-developers-how-to-design-linearlayout-in-flutter-5d819c0ddf1a)
> * 原文作者：[Burhanuddin Rashid](https://proandroiddev.com/@burhanrashid52?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-for-android-developers-how-to-design-linearlayout-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-for-android-developers-how-to-design-linearlayout-in-flutter.md)
> * 译者：
> * 校对者：

# Flutter For Android Developers : How to design LinearLayout in Flutter ?

![](https://cdn-images-1.medium.com/max/2000/1*9JzKFil-Xsip742fdxDqZw.jpeg)

Photo by [Marvin Ronsdorf](https://unsplash.com/photos/1hGAXyyav64?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/search/photos/row-and-column?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).

This blog is meant for Android developers looking to apply their existing Android knowledge to build mobile apps with Flutter. In this blog, we are going to explore what is equivalent design widget for LinearLayout in Flutter.

### Series

*   [How to design activity UI in Flutter ?](https://blog.usejournal.com/flutter-for-android-developers-how-to-design-activity-ui-in-flutter-4bf7b0de1e48)
*   How to design LinearLayout in Flutter ? (You are here)

### Prerequisites

This blog already assumes that you have already setup the flutter in your PC and able to run a Hello World app. If you have not install flutter yet, gets started from [here](https://flutter.io/get-started/).

Dart is based on the object-oriented concept so as android java developer you will be able to catch up dart very easily.

### Let’s get started

If you are an Android Developer then I assumes that you have heavily used LinearLayout while designing the layout. Those who are still not familiar with LinearLayout let me start with an official definition.

> LinearLayout is a layout that arranges other views either horizontally in a single **_Column_** or vertically in a single **_Row_**.

![](https://cdn-images-1.medium.com/max/800/1*kE-KoY8nR4qT8nYHPrV0Pw.jpeg)

As above visual representation and the definition itself, you can make out what is the equivalent widget in Flutter. Yes, you are right they are Row and Column. This two widget have almost same behavior as the LinearLayout in native Android. Row and columns are heavily used in flutter too.

> **Note:** The Row/Column widget does not scroll . If you have a line of widgets and want them to be able to scroll if there is insufficient room, consider using a [ListView](https://docs.flutter.io/flutter/widgets/ListView-class.html).

Now we will cover some main attributes of LinearLayout which can be converted into the equivalent widget properties in Flutter.

### 1. Orientation

In LinearLayout you can define the orientation of its child by using `android:orientation=”horizontal”` attributes which take `horizontal/vertical` as values which are similar to Row/Column widget in Flutter.

In Android, LinearLayout is `ViewGroup` which can have views as a child.You can set all the child views inside the `<LinearLayout> </LinearLayout>` tags.So in order set child widget in our Row/Column widget, we need to use Row/Column.children property which accepts the `List<Widget>`. Refer below code snippet.

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

In this example, we have used Row widget which is `android:orientation=”horizontal”` attribute of `LinearLayout`. We use Column for vertical value. If you are wondering what is Scaffold doing here than you can read my previous article [How to design activity UI using Scaffold in Flutter ?](https://blog.usejournal.com/flutter-for-android-developers-how-to-design-activity-ui-in-flutter-4bf7b0de1e48). Below is the output from above code for using Row and Column widget.

![](https://cdn-images-1.medium.com/max/800/1*DbZVIPcRxe7Mg8avHmf5Sw.jpeg)

![](https://cdn-images-1.medium.com/max/800/1*j8ikHPpLx46r3bwNveJubA.png)

### 2. “match_parent” vs “wrap_content”

*   MATCH_PARENT: which means that the view wants to be as big as its parent and if your view is top level root view than it will as big as the device screen.
*   WRAP_CONTENT: which means that the view wants to be just big enough to enclose its content.

In order to get behavior for `match_parent` and `wrap_content` we need to use `mainAxisSize` property in Row/Column widget, the mainAxisSize property takes MainAxisSize enum having two values which is `MainAxisSize.min` which behaves as `wrap_content` and `MainAxisSize.max` which behaves as `match_parent`.

In the above example, we did not define any mainAxisSize property to the Row widget so by default its set mainAxisSize property to `MainAxisSize.max` which is `match_parent`. The yellow background of the container represents how the free space is covered. This is how we define this property in the above example and check the output with different attribute values.

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

This is how we can visually differentiate the attributes we used in Row/Column widget.

### 3. Gravity

Gravity specifies how a child views should position its content, within its own bounds. We define gravity in LinearLayout layout using `android:gravity=”center”` with multiple alignment values. The same can be achieved in Row/Column widget using `MainAxisAlignment` and `CrossAxisAlignment` properties.

#### 1. [MainAxisAlignment](https://docs.flutter.io/flutter/rendering/MainAxisAlignment-class.html):

This property defines how the children should be placed along the main axis(Row/Column).In order to make this work, there should be some space available in the Row/Column widget if you set the value to `MainAxisSize.min` i.e `wrap_content` than setting MainAxisAlignment won’t have any effect on the widget because of no available space. We can define MainAxisAlignment property like this.

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

> A picture is worth a thousand words, instead describing each and every attribute I rather prefer visual representation.

So below this output comparing LinearLayout attributes to MainAxisAlignment property in Row Widget.

![](https://cdn-images-1.medium.com/max/1000/1*zQD7Hhg5WITKdQF1hqZyiQ.png)

Now, let’s compare it with the Column Widget.

![](https://cdn-images-1.medium.com/max/1000/1*cJFYgsnUl5hE5DLPCkbLMA.png)

> **Exercise:** You can try other enums `spaceEvenly`,`spaceAround`,`spaceBetween` which behaves as a vertical/horizontal chain which we use in ConstraintLayout.

#### 2. [CrossAxisAlignment](https://docs.flutter.io/flutter/rendering/CrossAxisAlignment-class.html) :

This property defines how the children should be placed along the cross axis. It means if we use Row widget the individual’s children gravity will be on the basis of the vertical line. And if we use Column widget the individual’s children gravity will be on the basis of horizontal line.

This sound pretty confusion right! Don’t worry you will understand better as you read further.

For better understanding, we are making it `wrap_content` i.e `MainAxisSize.min`. You define a CrossAxisAlignment property like below code. If no property is set then it will take `CrossAxisAlignment. start` by default.

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

So below this output comparing LinearLayout attributes to CrossAxisAlignment property in Row Widget.

![](https://cdn-images-1.medium.com/max/1000/1*10EUefrNcIUIW3GGR5pRQg.png)

Now, let’s compare it with the Column Widget.

![](https://cdn-images-1.medium.com/max/1000/1*GdfFwLT_933GOj-KU9yeag.png)

Stretch behave little different, its stretch the widget to max available space i.e `match_parent` to its cross axis.

### 3. Layout Weight

To create a linear layout in which each child uses the same amount of space or to divide space in specific ratio on the screen,we set the `android:layout_height` of each view to `“0dp”` (for a vertical layout) or the `android:layout_width` of each view to `“0dp”` (for a horizontal layout). Then set the `android:layout_weight` of each view to `“1”` or any other value as per space you want to divide.

To achieve the same thing in flutter Row/Column widget we wrap each child into an `Expanded` widget which will have flex property equivalent to our `android:layout_weight` so by defining flex value we define the amount of space should be applied to that specific child.

This is how you define the weight/flex to each child.

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

For the sake of better understanding, we have wrap each icon inside a container with a background color to easily identify how much space has been covered by the widget.

![](https://cdn-images-1.medium.com/max/800/1*hLp6mC4eMA0RFp5dSFLlVg.png)

### Conclusion

LinearLayout is heavily used in Android same goes with flutter Row/Column widget. Hope to cover more topics in the upcoming blogs. I have created a sample app to play around with Row/Column attributes and how this attributes works when they are combined.

![](https://cdn-images-1.medium.com/max/800/1*fbdY7IRyItUIW37WhqWzQQ.gif)

Check out flutter for android example here.

[**burhanrashid52/FlutterForAndroidExample**: Contribute to FlutterForAndroidExample development by creating an account on GitHub.](https://github.com/burhanrashid52/FlutterForAndroidExample)

**Thank you !!!**

**If you find this article helpful. Please like,share and clap so other people will see this here on Medium. If you have any quires or suggestions, feel free comment on the blog or hit me on Twitter, Github or Reddit.**

**To get latest updates for my upcoming blog please follow me on Medium, Twitter, Github or Reddit.**

* [**Burhanuddin Rashid (@burhanrashid52) | Twitter**](https://twitter.com/burhanrashid52)

* [**burhanrashid52 (Burhanuddin Rashid) GitHub**](https://github.com/burhanrashid52)

* [**burhanrashid52 (u/burhanrashid52) — Reddit**](https://www.reddit.com/user/burhanrashid52/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
