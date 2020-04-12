> * 原文地址：[Bottom Navigation Bar using Provider | Flutter](https://medium.com/flutterdevs/bottom-navigation-bar-using-provider-flutter-8b607beb2e5a)
> * 原文作者：[Ashish Rawat](https://medium.com/@ashishrawat2911)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/bottom-navigation-bar-using-provider-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/bottom-navigation-bar-using-provider-flutter.md)
> * 译者：[Xat_MassacrE](https://github.com/XatMassacrE)

# 在 Flutter 中使用 Provider 构建底部导航栏

![](https://cdn-images-1.medium.com/max/3840/1*kQVKvFSFhWpRPBPVBFNPfg.png)

在这篇文章中，我将向你们展示在 BottomNavigationBar 中如何使用 Flutter Provider 包。

#### 什么是 Provider ？

`Provider` 是 Flutter 团队推荐的一种新的状态管理方案。

> **注意** **`setState`** 在大多数情况下也很好用，但是你不能在什么地方都用它。
尤其是当你的代码比较凌乱的时候，比如在 build 中有一个 `FutureBuilder` 时，使用 `setState` 毫无疑问就会出现问题。

让我们来看看，如何在 BottomNavigationBar 中使用吧。

## 第一步：在 pubspec.yaml 中添加依赖。

```
provider : <latest-version>
```

## 第二步：创建一个 provider 类

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

在这个 provider 中，我保存了 BottomNavigationBar 的当前值，当这个值在 provider 中被设置的时候，BottomNavigationBar 将会接收到当前值改变的通知并更新标签。

## 第三步：使用 ChangeNotifierProvider 作为父组件把它包起来

```
home: ChangeNotifierProvider<BottomNavigationBarProvider>(
  child: BottomNavigationBarExample(),
  builder: (BuildContext context) => BottomNavigationBarProvider(),
),
```

用 `ChangeNotifierProvider` 把组件包了起来，该组件就会接收到值改变的通知了。

## 第四步：为 BottomNavigationBar 创建标签

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

这里的底部导航栏有三个标签。

## 第五步：使用 provider 创建 BottomNavigationBar

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

在这里我为屏幕创建了一个列表，并用 provider 提供的下标来改变屏幕显示的页面，同时通过点击标签来改变 privider 并更新下标。

![](https://cdn-images-1.medium.com/max/2000/1*sdr1LXWBXsCS1xdHUG98jg.gif)

示例如下：

[**使用 Provider 来作底部导航栏的简易 app**](https://github.com/flutter-devs/Flutter-BottomBarProvider)

#### 持久化 BottomNavigationBar

当不使用 `setState` 来改变标签的时候 provider 工作的很好，但是如果你想要保持屏幕对应标签的状态时，就需要使用 `PageStorageBucket` 了，下面是 Tensor Programming 提供的一个示例：

[**Contribute to tensor-programming/flutter_presistance_bottom_nav_tutorial development by creating an account on GitHub.**](https://github.com/tensor-programming/flutter_presistance_bottom_nav_tutorial/blob/master/lib/main.dart)

---

感谢阅读本文 ❤

如果文章中有错误的地方，请留言指出，我们希望得到改进意见。

关注我的 **[LinkedIn](https://www.linkedin.com/in/ashishrawat2911/).**

关注我的 [**GitHub repositories.**](http://github.com/flutter-devs)

关注我的 **[Twitter](https://www.twitter.com/ashishrawat2911/).**

---

![](https://cdn-images-1.medium.com/max/NaN/1*4pFzXhqqLddZhL_FY-LhtA.png)

[FlutterDevs](http://flutterdevs.com/) 已经做 Flutter 相关的工作了有一段时间了。你可以关注我们的 [Facebook](https://facebook.com/flutterdevs)、[GitHub](https://github.com/flutter-devs) 和 [Twitter](https://twitter.com/TheFlutterDevs)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
