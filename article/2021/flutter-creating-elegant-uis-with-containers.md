> * 原文地址：[Flutter — Creating Elegant UIs with Containers](https://maneesha-erandi.medium.com/flutter-creating-elegant-uis-with-containers-1d05ca90fccf)
> * 原文作者：[Maneesha Erandi](https://medium.com/@maneesha-erandi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-creating-elegant-uis-with-containers.md](https://github.com/xitu/gold-miner/blob/master/article/2021/flutter-creating-elegant-uis-with-containers.md)
> * 译者：
> * 校对者：

# Flutter — Creating Elegant UIs with Containers

When creating amazing UI screens with flutter, Container Widget plays a major role. I really like to add the Container widget in many places as it really helps me to create the desired UI easily and quickly.

I hope this article will be really helpful for the beginners.

Let’s see what we can do with Containers to make our UI more attractive.

To create a simple square or a rectangle we can create a Container for a given width and a height (you can see that this example has also avoid the use of an additional child widget).

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

The following example shows the use of rounded corners for Containers. The first two are rounded using BoxDecoration borderRadius. We can also draw a full circle using the BoxDecoration shape like the third Container.

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

If we wrap a Container with a widget that has the onTap feature (this example uses the InkWell widget), we can even create a custom button.

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

We can decorate our Containers with borders using Border.all(). BoxShadow will add a shadow to our Container for the given values as shown in the second Container.

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

Inside a Container we can place images as a Decoration image or a child. But, see the difference of the two image Containers to get an idea on how the decorations can be applied.

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

We can add colourful headers with shapes to make our UI more attractive. I have given three examples for the headers that we can create with Container widget.

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

You can find the full code here.

https://github.com/manee92/FlutterDemo/blob/master/lib/screens/UIDemo/ContainerDemo.dart

Thank you for reading !

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
