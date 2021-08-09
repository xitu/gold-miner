> * 原文地址：[Flutter — Creating Elegant UIs with Containers](https://maneesha-erandi.medium.com/flutter-creating-elegant-uis-with-containers-1d05ca90fccf)
> * 原文作者：[Maneesha Erandi](https://medium.com/@maneesha-erandi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-creating-elegant-uis-with-containers.md](https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-creating-elegant-uis-with-containers.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[zenblo](https://github.com/zenblo)

# 使用 Flutter 的 `Container` 控件构建优美的用户界面

当我们使用 Flutter 构建绝佳的 UI 界面的时候，`Container` 扮演着重要的角色。我真的极度喜欢在任何地方添加 `Container` 控件，而这也是因为它确实能够在快速简单地创建 UI 界面上帮上我大忙。

我真心希望本文内容能对初学者们有所帮助！

让我们一起看看我们能够怎样利用 `Container` 控件让我们的 UI 更加有吸引力吧！

要生成一个简简单单的正方形或矩形，我们可以创造一个 `Container` 控件并给它制定一个宽度和高度（我们可以看到下面的例子就避免了使用子控件去绘制形状）。

![](https://cdn-images-1.medium.com/max/2078/1*mzCSaRJfZi8BiBHYUrUbqg.png)

```Dart
Widget squareContainer() {
  return Container(
    color: Colors.purpleAccent,
    width: 100,
    height: 100,
  );
}

Widget rectContainer() {
  return Container(
    color: Colors.greenAccent,
    width: 200,
    height: 100,
  );
}
```

而下面的例子展示了如何给 `Container` 控件加上圆角。首先操作的两个控件是使用了 `BoxDecoration` 圆角化控件的。我们同样可以通过使用 `BoxDecoration` 绘制一个圆形，就像第三个控件那样：

![](https://cdn-images-1.medium.com/max/2202/1*lK_CjuIIFxIMSrijjme1qg.png)

```Dart
Widget roundedContainer() {
  return Container(
    width: 100,
    height: 50,
    decoration: BoxDecoration(
        color: Colors.tealAccent,
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}

Widget fullyRoundedContainer() {
  return Container(
    width: 100,
    height: 50,
    decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.all(Radius.circular(50))),
  );
}

Widget circleContainer() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
  );
}
```

如果我们用 `Container` 控件包裹一个有 `onTap` 功能（本例中为 `InkWell` 控件）的子控件，我们甚至可以构建一个自定义的按钮：

![](https://cdn-images-1.medium.com/max/2000/1*0CUGG-lyqxr-iP4wb9PRNQ.png)

```Dart
Widget containerButton() {
  return InkWell(
    onTap: () {},
    child: Container(
        decoration: BoxDecoration(
            color: Colors.deepOrange,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
        child: Text(
          "Button",
          style: TextStyle(color: Colors.white),
        )),
  );
}
```

我们还可以通过使用 `Border.all()` 来生成边框装饰我们的 `Container` 控件。`BoxShadow` 则可以给我们的 `Container` 添加所设置的阴影，如控件二：

![](https://cdn-images-1.medium.com/max/2000/1*SAcNvyxyzu-ofhDJ9_qhWg.png)

```Dart
Widget containerWithBorders() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
        color: Colors.yellow,
        border: Border.all(),
        borderRadius: BorderRadius.all(Radius.circular(15))),
  );
}

Widget containerWithShadow() {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 9,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
  );
}
```

在一个 `Container` 控件中，我们可以通过使用 `BoxDecoration` 以及 `DecorationImage` 给它添加装饰图片。这里大家可以试着找找两张图片中 `Container` 的区别，探究添加的装饰是如何被应用到控件上的：

![](https://cdn-images-1.medium.com/max/2224/1*W0xtgxhy3hLNkrcHbZEGhQ.png)

```Dart
Widget containerImgDecoration() {
  return Container(
    width: 150,
    height: 150,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        image: DecorationImage(
            image: AssetImage("assets/images/img.jpg"), fit: BoxFit.cover)),
  );
}

Widget containerImg() {
  return Container(
    width: 150,
    height: 150,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15))),
    child: Image(image: AssetImage("assets/images/img.jpg"), fit: BoxFit.cover),
  );
}
```

我们可以添加多彩的标题背景，让我们的 UI 更有吸引力。下面是三个使用 `Container` 控件构造的标题栏的例子：

![](https://cdn-images-1.medium.com/max/2458/1*I5-WNUcfc8gRxQiiTD59zQ.png)

![](https://cdn-images-1.medium.com/max/2422/1*F3DS06d7jMIPJxwqVQlWKg.png)

![](https://cdn-images-1.medium.com/max/2484/1*0LAhQZtJZx2bgvHFgEvELw.png)

```Dart
Widget containerHeaderOne({width}) {
  return Container(
    width: width,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent,
      borderRadius:  BorderRadius.vertical(
          bottom:  Radius.elliptical(width, 200.0)),
    ),
  );
}

Widget containerHeaderTwo({width}) {
  return Container(
    width: width,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(200)),
    ),
  );
}

Widget containerHeaderThree({width}) {
  return Container(
    width: width,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(200),
          bottomRight: Radius.circular(200)),
    ),
  );
}
```

你可以在 [这里](https://github.com/manee92/FlutterDemo/blob/master/lib/screens/UIDemo/ContainerDemo.dart) 找到完整的代码。

感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
