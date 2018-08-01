> * 原文地址：[Flutter Getting Started: Tutorial 5 Grid](https://medium.com/@thatsalok/flutter-getting-started-tutorial-5-grid-1b0bbcb7cba8)
> * 原文作者：[Alok Gupta](https://medium.com/@thatsalok?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-getting-started-tutorial-5-grid.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter-getting-started-tutorial-5-grid.md)
> * 译者：
> * 校对者：

# Flutter Getting Started: Tutorial 5 Grid

### Introduction

**Flutter** `GridView` almost same as `ListView` except it provide 2D view comparison to `ListView` single direction view. It also quite popular widget across mobile app development, if you don't believe me open any ecommerce app in your mobile it definitely dependent either on `ListView` or `GridView` to display data, for e.g.

Here **Amazon** mobile app display data in grid

![](https://cdn-images-1.medium.com/max/800/1*mZMDK4IHEUf8sV6ClVEb9g.png)

Another one, **PayTM**, one of popular online wallet service app in India, widely use grid layout to display different products

![](https://cdn-images-1.medium.com/max/800/1*DIxbiVggbE4T2vz8JTT73g.png)

### Background

The ultimate aim of this article to achieve view similar to this :-

![](https://cdn-images-1.medium.com/max/800/1*n30ql6oDnzcT7o2ne3Wykg.png)

However if you have notice the above image, that is in landscape mode. So here, I am going to do in this article. When the application is in portrait mode, MobileApp would display item in `ListView` and when it’s in landscape mode, show items in 3 items per row grid. I also explore creating custom widget, by moving gridview implementation in separate class.

### Using the code

I am going to build on my previous article [Flutter Getting Started: Tutorial 4 ListView](https://medium.com/@thatsalok/flutter-getting-started-tutorial-4-listview-8326c9ed5524), there I have already created ListView based application, here the initial project structure and initial UI.

Here is the initial code from which we start building on

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

Before I start on actual quest , let me give you brief what I have done above

*   I have created simple `ListView` using `ListView.builder`, which give flexibility of creating infinite listitem view, as it call callback function only for those item, which could be displayed in the screen.
*   I am displaying City information like City Landmark image, followed by CityName, Country the city belongs and her population.
*   Lastly on clicking, its show small self disappearing message at bottom of screen, known as `SnackBar`

Now from here our work starts, as I mentioned earlier we would be refactoring new widget into different class, to keep our code modular and increase clarity of code. So create a new folder `widget` under `lib` folder and add new DART file `mygridview.dart`

Once you add the file, first import material widget, by importing `'package:flutter/material.dart'` and then add `MyGridView` class which extends our favourite `StatelessWidget` and override `Build` function, so bare bone code looks like this

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

I would now add basic GridView just displaying the City name, so I will add following code in overridden Build function

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

Explanation of above code

*   `GridView.count` method would provide GridView widget for application
*   `crossAxisCount` property is used to let mobile application know how much item we want to show each row
*   `children` property will contain all the widget you wish to show when page is loaded
*   `childAspectRatio`, which is the ratio of the cross-axis to the main-axis extent of each child, since I am displaying the name, I will keep same at 8.0 so that margin between two tile is reduced

Here is what UI looks like

![](https://cdn-images-1.medium.com/max/800/1*E9Q1cPyQ0hWJEC1uNvqGtQ.png)

Now let make UI similar to what we seeing the ListView. here I created new function which will send City class in form of Card

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

**Explanation of above code**

*   I am using `Inkwell` class, since Card class doesn't support gesture directly, So I wrapped it inside InkWell class, to utilize its `onTap` event for displaing SnackBar
*   Rest of code is similar to `ListView` card except no width is specified
*   Also, since we are displaying complete card, don’t forget to change `childAspectRatio` from 8.0 to 8.0/9.0, as we require more height .

Before I forget, I told at start of application, I will show `ListView` in _portrait_ orientation and `GridView` in _landscape_ orientation, so for achieve it `MediaQuery` class to identify the orientation. Whenever the orientation is changed, i.e. you tilt you mobile the widget are redrawn, so `Build` function is called, there you could take decision what code should be called. So in `homepage.dart` class we will use following function to handle Orientation changes

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

So out final UI would be like this

![](https://cdn-images-1.medium.com/max/800/1*IDL_nruBR9S9JW0UlX_zjw.gif)

End of tutorial

### Points of Interest

Please go through these articles. It might give you a headway, where the wind is actually flowing:

1.  [https://material.io/design/components/cards.html](https://material.io/design/components/cards.html#)
2.  Github : [https://github.com/thatsalok/FlutterExample/tree/master/flutter5_gridlist](https://github.com/thatsalok/FlutterExample/tree/master/flutter5_gridlist)

### Flutter Tutorial

1.  [Flutter Getting Started: Tutorial 1 Basics](https://medium.com/@thatsalok/flutter-getting-started-tutorial-1-basics-8714e751408f)
2.  [Flutter Getting Started: Tutorial 4 ListView](https://medium.com/@thatsalok/flutter-getting-started-tutorial-4-listview-8326c9ed5524)

### Dart Tutorial

1.  [DART2 Prima Plus — Tutorial 1](https://www.codeproject.com/Articles/1251136/DART-Prima-Plus-Tutorial)
2.  [DART2 Prima Plus — Tutorial 2 — LIST](https://www.codeproject.com/Articles/1251343/DART2-Prima-Plus-Tutorial-2-LIST)
3.  [DART2 Prima Plus — Tutorial 3 — MAP](https://www.codeproject.com/Articles/1252345/DART2-Prima-Plus-Tutorial-3-MAP)

### History

*   22-July-2018: First version

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
