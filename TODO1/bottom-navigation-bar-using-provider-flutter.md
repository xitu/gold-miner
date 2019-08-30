> * 原文地址：[Bottom Navigation Bar using Provider | Flutter](https://medium.com/flutterdevs/bottom-navigation-bar-using-provider-flutter-8b607beb2e5a)
> * 原文作者：[Ashish Rawat](https://medium.com/@ashishrawat2911)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/bottom-navigation-bar-using-provider-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/bottom-navigation-bar-using-provider-flutter.md)
> * 译者：
> * 校对者：

# Bottom Navigation Bar using Provider | Flutter

![](https://cdn-images-1.medium.com/max/3840/1*kQVKvFSFhWpRPBPVBFNPfg.png)

In this article, I'll be showing you how you can use Flutter Provider package in the BottomNavigationBar.

#### What is Provider?

`Provider` is a new state management approach recommended by the Flutter team.

> **Note**
`**setState**` also works fine for many case , you should not use it every where .
But in case you have a messy code like you have a `FutureBuilder` in the build then `setState` will definately cause problem.

Let's see how we can use it in BottomNavigationBar.

## Step 1: Add the dependency in your pubspec.yaml.

```
provider : <latest-version>
```

## Step 2: Create a provider class

```
class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
```

In this provider, I am storing the current value of the BottomNavigationBar and when the current value is set into to provider, the BottomNavigationBar will be notified with the current value and update the tab.

## Step 3: Wrap parent Widget with ChangeNotifierProvider

```
home: ChangeNotifierProvider<BottomNavigationBarProvider>(
  child: BottomNavigationBarExample(),
  builder: (BuildContext context) => BottomNavigationBarProvider(),
),
```

I have wrapped my widget with `ChangeNotifierProvider` so my widget will be notified when the value changes.

## Step 4: Create tabs for BottomNavigationBar

```Dart
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        alignment: Alignment.center,
        height: 300,
        width: 300,
        child: Text(
          "Home",
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        color: Colors.amber,
      )),
    );
  }
}
```

I have three widgets tabs which I’ll attach with my bottom navigation bar.

## Step 4: Create BottomNavigationBar with provider

```Dart
var currentTab = [
  Home(),
  Profile(),
  Setting(),
  ];
///
var provider = Provider.of<BottomNavigationBarProvider>(context);
return Scaffold(
  body: currentTab[provider.currentIndex],
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: provider.currentIndex,
    onTap: (index) {
      provider.currentIndex = index;
    },
    items: [
      BottomNavigationBarItem(
        icon: new Icon(Icons.home),
        title: new Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.person),
        title: new Text('Profile'),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.settings), title: Text('Settings'))
    ],
  ),
);
```

So I have created a list for the screens and change the screens with an index which is provided by the provider and the tab changes the provider updates the index.

![](https://cdn-images-1.medium.com/max/2000/1*sdr1LXWBXsCS1xdHUG98jg.gif)

Here is the code for the above example :

[**A sample application for bottom bar using Provider**](https://github.com/flutter-devs/Flutter-BottomBarProvider)

#### Persistent BottomNavigationBar

Provider works great when changing the tabs without using `setState` but if you want to keep your state of the screens attached with the tabs, try using `PageStorageBucket`, I have attached an example by Tensor Programming below:

[**Contribute to tensor-programming/flutter_presistance_bottom_nav_tutorial development by creating an account on GitHub.**](https://github.com/tensor-programming/flutter_presistance_bottom_nav_tutorial/blob/master/lib/main.dart)

---

Thanks for reading this article ❤

If I got something wrong, Let me know in the comments. We would love to improve.

Connect with me on **[LinkedIn](https://www.linkedin.com/in/ashishrawat2911/).**

Check my [**GitHub repositories.**](http://github.com/flutter-devs)

Follow me on **[Twitter](https://www.twitter.com/ashishrawat2911/).**

---

![](https://cdn-images-1.medium.com/max/NaN/1*4pFzXhqqLddZhL_FY-LhtA.png)

[FlutterDevs ](http://flutterdevs.com/)has been working on Flutter from quite some time now. You can connect with us on [Facebook](https://facebook.com/flutterdevs),[GitHub](https://github.com/flutter-devs) and [Twitter](https://twitter.com/TheFlutterDevs) for any flutter related queries.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
