> * 原文地址：[Flutter Getting Started: Tutorial 5 Grid](https://medium.com/@thatsalok/flutter-getting-started-tutorial-5-grid-1b0bbcb7cba8)
> * 原文作者：[Alok Gupta](https://medium.com/@thatsalok?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-getting-started-tutorial-5-grid.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-getting-started-tutorial-5-grid.md)
> * 译者：[YueYong](https://github.com/YueYongDev)
> * 校对者：

# Flutter 入门：教程5 网格

### 介绍

**Flutter** `GridView` 几乎与 `ListView` 相同，只是它提供了与 `ListView` 单向视图的 2D 视图比较。同时它也是移动应用开发中非常受欢迎的小部件。如果你不相信我，那就举个例子，打开你手机中的任何一个电子商务应用，它肯定是依赖于 `ListView` 或 `GridView` 来显示数据的。

**Amazon** 移动应用程序利用网格显示数据

![](https://cdn-images-1.medium.com/max/800/1*mZMDK4IHEUf8sV6ClVEb9g.png)

另一个是 **PayTM**，它是印度流行的在线钱包服务应用之一，它广泛使用网格布局来显示不同的产品

![](https://cdn-images-1.medium.com/max/800/1*DIxbiVggbE4T2vz8JTT73g.png)

### 背景

本文的最终目的是实现类似的界面： -

![](https://cdn-images-1.medium.com/max/800/1*n30ql6oDnzcT7o2ne3Wykg.png)

但是，如果你注意到上面的图像，那是横屏模式下的。所以我将在本文中做以下的事情，当应用程序处于竖屏模式时，移动 APP 将在 `ListView` 中显示项目，当它处于横屏模式时，将会在网格中每行显示3个条目。我还通过在单独的类中移动 gridview 来实现创建自定义窗口小部件。

### 使用代码

我将以我之前的文章为基础 [Flutter Getting Started: Tutorial 4 ListView](https://medium.com/@thatsalok/flutter-getting-started-tutorial-4-listview-8326c9ed5524), 我已经创建了基于 ListView 的应用程序，这里是初始项目结构和初始UI。

这是我们开始构建的初始代码

```
class HomePage extends StatelessWidget {
  final List<City> _allCities = City.allCities();

  HomePage() {}
  final GlobalKey scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text(
            "Cites around world",
            style: new TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        body: new Padding(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: getHomePageBody(context)));
  }

  getHomePageBody(BuildContext context) {
   
      return ListView.builder(
        itemCount: _allCities.length,
        itemBuilder: _getListItemUI,
        padding: EdgeInsets.all(0.0),
      );
   
  }

  Widget _getListItemUI(BuildContext context, int index,
      {double imgwidth: 100.0}) {
    return new Card(
        child: new Column(
      children: <Widget>[
        new ListTile(
          leading: new Image.asset(
            "assets/" + _allCities[index].image,
            fit: BoxFit.fitHeight,
            width: imgwidth,
          ),
          title: new Text(
            _allCities[index].name,
            style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          ),
          subtitle: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_allCities[index].country,
                    style: new TextStyle(
                        fontSize: 13.0, fontWeight: FontWeight.normal)),
                new Text('Population: ${_allCities[index].population}',
                    style: new TextStyle(
                        fontSize: 11.0, fontWeight: FontWeight.normal)),
              ]),
          onTap: () {
            _showSnackBar(context, _allCities[index]);
          },
        )
      ],
    ));
  }

  _showSnackBar(BuildContext context, City item) {
    final SnackBar objSnackbar = new SnackBar(
      content: new Text("${item.name} is a city in ${item.country}"),
      backgroundColor: Colors.amber,
    );

    Scaffold.of(context).showSnackBar(objSnackbar);
  }
}
```

在开始实际任务之前，让我简要介绍一下我上面做过的事情

*   我已经使用 `ListView.builder` 创建了简单的 `ListView`，它可以灵活地创建无限的 listitem 视图，因为它只调用那些可以在屏幕上显示的项目的回调函数。
*   我正在显示城市信息，如城市地标图像，其次是城市名称，城市所属的国家和她的人口。
*   最后点击，它在屏幕底部显示小的会自动消失的消息，称为 `SnackBar`。

现在开始我们的工作，正如我之前提到的，我们将把新的 widget 重构为不同的类，以保持我们的代码模块化并提高代码的可读性。 因此，在 `lib` 文件夹下创建一个新的文件夹，并添加新的 DART 文件 `mygridview.dart`。

添加文件后，首先通过 `'package:flutter/material.dart'` 导入 material 组件，然后添加 `MyGridView` 类来继承我们最喜欢的 `StatelessWidget` 并复写 `Build` 函数，代码如下所示

```
import 'package:flutter/material.dart';
import 'package:flutter5_gridlist/model/city.dart';

class MyGridView extends StatelessWidget {
  final List<City> allCities;
  MyGridView({Key key, this.allCities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
```

我现在添加基本的 GridView 只显示城市名称，所以我将在重写的 Build 函数中添加以下代码

```
@override
Widget build(BuildContext context) {
  return GridView.count(
    crossAxisCount: 3,
    padding: EdgeInsets.all(16.0),
     childAspectRatio: 8.0,
    children: _getGridViewItems(context),
  );
}
_getGridViewItems(BuildContext context){
  List<Widget> allWidgets = new List<Widget>();
  for (int i = 0; i < allCities.length; i++) {
    var widget = new Text(allCities[i].name);
    allWidgets.add(widget);
  };
  return allWidgets;
}
```

对上述代码的解释

*   `GridView.count` 方法将为应用程序提供 GridView 小部件
*   `crossAxisCount` 属性用于让移动应用程序知道我们想要显示每行的项目数
*   `children` 属性将包含您希望在加载页面时显示的所有小部件
*   `childAspectRatio`，它是每个子节点的横轴与主轴范围的比率，因为我显示的是名称，所以我统一设置为8.0，以便减少两个图块之间的边距 

这是UI的样子

![](https://cdn-images-1.medium.com/max/800/1*E9Q1cPyQ0hWJEC1uNvqGtQ.png)

现在我们来改变 UI 让其类似于我们看到的 ListView。在这里我创建了一个新的函数，它将以 Card 的形式发送 City 类

```
// Create individual item
_getGridItemUI(BuildContext context, City item) {
  return new InkWell(
      onTap: () {
        _showSnackBar(context, item);
      },
      child: new Card(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Image.asset(
              "assets/" + item.image,
              fit: BoxFit.fill,
              
            ),
            new Expanded(
                child: new Center(
                    child: new Column(
              children: <Widget>[
                new SizedBox(height: 8.0),
                new Text(
                  item.name,
                  style: new TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Text(item.country),
                new Text('Population: ${item.population}')
              ],
            )))
          ],
        ),
        elevation: 2.0,
        margin: EdgeInsets.all(5.0),
      ));
}
```

**上述代码的解释**

*   我正在使用 `Inkwell` 类，因为 Card 类不直接支持手势，所以我把它包装在 InkWell 类中，利用它的 `onTap` 事件替换 SnackBar
*   其余代码类似于 `ListView` 的卡片，但未指定宽度
*   此外，由于我们正在显示完整的卡片，因此我们不要忘记将 `childAspectRatio` 从 8.0 更改为 8.0 / 9.0，因为我们需要更多的高度。

如果没有忘记的话，在开始做程序时我就说过，我将在纵向方向上显示 `ListView`，在横向方向上显示 `GridView`，为了实现它我们需要 `MediaQuery` 类来识别方向。无论何时更改方向，你都可以决定哪些代码应该被调用，也就是说，即使你倾斜移动窗口都会调用 `Build` 函数，小部件也都会重新绘制。所以在 `homepage.dart` 类中我们将使用以下函数来处理 Orientation 更改的问题

```
getHomePageBody(BuildContext context) {
  if (MediaQuery.of(context).orientation == Orientation.portrait)
    return ListView.builder(
      itemCount: _allCities.length,
      itemBuilder: _getListItemUI,
      padding: EdgeInsets.all(0.0),
    );
  else
    return new MyGridView(allCities: _allCities);
}
```

因此，最终的UI将是这样的

![](https://cdn-images-1.medium.com/max/800/1*IDL_nruBR9S9JW0UlX_zjw.gif)

本教程结束

### 兴趣点

请仔细阅读这些文章。它可能会给你一个你真正需要的指引：

1.  [https://material.io/design/components/cards.html](https://material.io/design/components/cards.html#)
2.  Github : [https://github.com/thatsalok/FlutterExample/tree/master/flutter5_gridlist](https://github.com/thatsalok/FlutterExample/tree/master/flutter5_gridlist)

### Flutter 教程

1.  [Flutter Getting Started: Tutorial 1 Basics](https://medium.com/@thatsalok/flutter-getting-started-tutorial-1-basics-8714e751408f)
2.  [Flutter Getting Started: Tutorial 4 ListView](https://medium.com/@thatsalok/flutter-getting-started-tutorial-4-listview-8326c9ed5524)

### Dart 教程

1.  [DART2 Prima Plus — Tutorial 1](https://www.codeproject.com/Articles/1251136/DART-Prima-Plus-Tutorial)
2.  [DART2 Prima Plus — Tutorial 2 — LIST](https://www.codeproject.com/Articles/1251343/DART2-Prima-Plus-Tutorial-2-LIST)
3.  [DART2 Prima Plus — Tutorial 3 — MAP](https://www.codeproject.com/Articles/1252345/DART2-Prima-Plus-Tutorial-3-MAP)

### 历史

*   22-July-2018: 第一个版本

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
