> * 原文地址：[Out of Depth with Flutter](https://medium.com/flutter-io/out-of-depth-with-flutter-f683c29305a8)
> * 原文作者：[Mikkel Ravn](https://medium.com/@mravn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/out-of-depth-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/out-of-depth-with-flutter.md)
> * 译者：[DateBro](https://github.com/DateBro)
> * 校对者：

# 深入了解 Flutter

[Flutter](https://flutter.io/) 是一种新的框架，可以在短时间内为 iOS 和 Android 构建高质量原生 App。根据我使用 Flutter（作为 Flutter 团队成员）的经验，开发速度主要通过以下方式体现：

*   **有状态的热重载**。Flutter 开发由 Dart 编译器/VM 技术提供支持，它允许你在保留应用程序状态（包括你导航到的位置）的同时将代码更改加载到正在运行的应用程序中。点击保存，你将在不到一秒的时间内看到设备更改的效果。
*   **响应式编程**。Flutter 在其定义和更新用户界面的方法中遵循其他现代框架：两者都基于接口如何依赖于当前状态的单个描述。
*   **组成**。在 Flutter 中，万物皆组件，而且通过自由组合漂亮的组件和乐高积木风格，你可以实现任何想要的结果。
*   **代码编写 UI**。Flutter 没有单独的布局标记语言。每个组件只在 Dart 中的一个地方编写，缩减了语法切换和文件切换的开销。

有意思的是，上面的最后三个特点形成了对开发速度的挑战：**在你的方式和你的视图逻辑中深入嵌套的 widget 树**。

接下来我会讨论为什么会出现这个问题和我们能做什么。同时，我会尝试说明 Flutter 的工作原理。

* * *

### 响应式编程

Flutter 的响应式编程模型邀请你使用声明性编程来定义您的用户界面，作为当前状态的函数：

```
@override
Widget build(BuildContext context) {
  return // 一些基于当前状态的组件
}
```

组件是用户界面的不可变描述。我们被要求返回由单个表达式定义的单个组件。没有用于配置或更新可变视图的 mutator 命令序列。相反，我们只是调用一些组件构造函数。

### 组成

Widgets are typically simple, each doing one thing well: `Text`, `Icon`, `Padding`, `Center`, `Column`, `Row`, … To achieve any non-trivial outcome, many widgets must be composed. So our single expression easily becomes a deeply nested tree of widget constructor calls:

![](https://cdn-images-1.medium.com/max/800/1*RNOof30wEFXsbUsQ0Jof7Q.png)

组件除子属性还有其他属性，但是你明白的。

### 代码编写 UI

编写和编辑深层嵌套的树需要一个优雅的编辑器和一些练习来提高效率。开发人员似乎在布局标记（XML，HTML）中比在代码中更能容忍深度嵌套，但 Flutter 的 UI-as-code 方法确实意味着深层嵌套 _code_。无论你在组件树中有什么视图逻辑——条件，转换，在读取当前状态时使用的迭代，用于更改它的事件处理程序——也会深深嵌套。

这就是接下来的挑战。

* * *

### 挑战

flutter.io 的 [布局教程](https://flutter.io/tutorials/layout/) 提供了一个说明性的例子——看起来像是——一个湖泊探险家应用程序。

![](https://cdn-images-1.medium.com/max/800/1*-1gqkQbEiJl2PKTlRBmYrg.png)

这是实现此视图的原始组件树：

```
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('Top Lakes')),
        body: ListView(
          children: <Widget>[
            Image.asset(
              'images/lake.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Oeschinen Lake Campground',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          'Kandersteg, Switzerland',
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star, color: Colors.red[500]),
                      Text('41'),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.call, color: Theme.of(context).primaryColor),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'CALL',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.near_me,
                          color: Theme.of(context).primaryColor),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'ROUTE',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.share, color: Theme.of(context).primaryColor),
                      Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'SHARE',
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
                    'Bernese Alps. Situated 1,578 meters above sea level, it '
                    'is one of the larger Alpine Lakes. A gondola ride from '
                    'Kandersteg, followed by a half-hour walk through pastures '
                    'and pine forest, leads you to the lake, which warms to '
                    '20 degrees Celsius in the summer. Activities enjoyed here '
                    'include rowing, and riding the summer toboggan run.',
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

这只是一个静态组件树，没有实现任何行为。但是将视图逻辑直接嵌入到这样的树中估计不会是一次愉快的体验。

接受挑战。

* * *

### 重新审视代码编写 UI

使用 Flutter 的 UI-as-code 方法时，组件树就是代码。因此，我们可以使用所有常用的代码组织工具来改善这种情况。工具箱中最简单的工具之一就是命名子表达式。这会在语法上将组件树翻出来。而不是

```
return A(B(C(D(), E())), F());
```

我们可以命名每个子表达式并得到

```
final Widget d = D();
final Widget e = E();
final Widget c = C(d, e);
final Widget b = B(c);
final Widget f = F();
return A(b, f);
```

我们的湖泊应用可以重写成下面这样：

```
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget imageSection = Image.asset(
      'images/lake.jpg',
      width: 600.0,
      height: 240.0,
      fit: BoxFit.cover,
    );
    final Widget titles = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Oeschinen Lake Campground',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          'Kandersteg, Switzerland',
          style: TextStyle(color: Colors.grey[500]),
        ),
      ],
    );
    final Widget stars = Row(
      children: <Widget>[
        Icon(Icons.star, color: Colors.red[500]),
        Text('41'),
      ],
    );
    final Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: <Widget>[
          Expanded(child: titles),
          stars,
        ],
      ),
    );
    final Widget callAction = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.call, color: Theme.of(context).primaryColor),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            'CALL',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
    final Widget routeAction = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.near_me, color: Theme.of(context).primaryColor),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            'ROUTE',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
    final Widget shareAction = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.share, color: Theme.of(context).primaryColor),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            'SHARE',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
    final Widget actionSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          callAction,
          routeAction,
          shareAction,
        ],
      ),
    );
    final Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
            'Bernese Alps. Situated 1,578 meters above sea level, it '
            'is one of the larger Alpine Lakes. A gondola ride from '
            'Kandersteg, followed by a half-hour walk through pastures '
            'and pine forest, leads you to the lake, which warms to '
            '20 degrees Celsius in the summer. Activities enjoyed here '
            'include rowing, and riding the summer toboggan run.',
        softWrap: true,
      ),
    );
    final Widget scaffold = Scaffold(
      appBar: AppBar(title: Text('Top Lakes')),
      body: ListView(
        children: <Widget>[
          imageSection,
          titleSection,
          actionSection,
          textSection,
        ],
      ),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      home: scaffold,
    );
  }
}
```

缩进级别现在更合理，我们可以通过引入更多名称使子树的缩进级别变得像我们希望的那样浅。更好的是，通过为各个子树提供有意义的名称，我们可以表示每个子树的作用。所以我们现在可以谈谈 `xxxAction` 子树......并观察到我们在这里面有很多重复的代码！另一个基本的代码组织工具——功能抽象——负责这部分内容：

```
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget imageSection = ...
    final Widget titles = ...
    final Widget stars = ...
    final Widget titleSection = ...

    Widget action(String label, IconData icon) {
      final Color color = Theme.of(context).primaryColor;
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      );
    }

    final Widget actionSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          action('CALL', Icons.call),
          action('ROUTE', Icons.near_me),
          action('SHARE', Icons.share),
        ],
      ),
    );
    final Widget textSection = ...
    final Widget scaffold = ...
    return MaterialApp(
      title: 'Flutter Demo',
      home: scaffold,
    );
  }
}
```

我们将看到一个简单功能抽象的替代，它会更具有更 Flutter 风格的。

### 重新审视组成

接下来是什么？好吧，`build` 方法依然很长。也许我们可以提取一些有意义的作品......片断？组件！Flutter 的组件都是关于组合和重用的。我们用框架提供的简单组件组成了一个复杂的组件 但是发现结果过于复杂，我们可以选择把它分解成不太复杂的自定义组件。定制组件是 Flutter 世界中的一等公民，而明确定义的组件具有很大的潜力被重用。让我们将 `action` 函数转换为 `Action` 组件类型并将其放在自己的文件中：

* [main.dart](https://gist.github.com/mravn-google/5962e261ee61c82d8f298fd2fe03fd29#file-main-dart):

```
import 'package:flutter/material.dart';
import 'src/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget imageSection = ...
    final Widget titles = ...
    final Widget titleSection = ...
    final Widget actionSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Action(label: 'CALL', icon: Icons.call),
          Action(label: 'ROUTE', icon: Icons.near_me),
          Action(label: 'SHARE', icon: Icons.share),
        ],
      ),
    );
    final Widget textSection = ...
    final Widget scaffold = ...
    return MaterialApp(
      title: 'Flutter Demo',
      home: scaffold,
    );
  }
}
```

* [widgets.dart](https://gist.github.com/mravn-google/5962e261ee61c82d8f298fd2fe03fd29#file-widgets-dart):

```
import 'package:flutter/material.dart';

class Action extends StatelessWidget {
  Action({Key key, this.label, this.icon}) : super(key: key);

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: color),
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
```

现在我们可以在应用程序的任何位置重用 `Action` 组件，就像它是由 Flutter 框架定义的一样。

但是，嘿，顶级的 `action` 功能不能满足同样的需求吗？

一般来说，不能。

*   许多组件是由其他组件构造的；它们的构造函数有 `Widget` 与 `List<Widget>` 类型的 `child` 和 `children` 参数。所以 `action` 函数不能传递给任何一个函数。当然，**调用** `action` 的结果可以。但是，你将通过在当前构建环境中预先构造的组件树，而不是 `StatelessWidget`，它只在必要时才构建子树，并且是最后在整个树中定义的上下文中定义的。注意到表达式中在 `Action.build` 开头的 `Theme.of(context).primaryColor` 了吗？它从父链上最近的 `Theme` 组件中检索主颜色——在调用 `action` 时，它很可能与最近的 `Theme` 不同。
*   `Action` is defined as a `StatelessWidget` which is little more than a build function turned into an instance method. But there are other kinds of widget with more elaborate behavior. Clients of `Action` shouldn’t care what kind of widget `Action` is. As an example, if we wanted to endow `Action` with an intrinsic animation, we might have to turn it into a `StatefulWidget` to manage the animation state. The rest of the app should be unaffected by such a change.

### 重新审视响应式编程

状态管理是开始利用 Flutter 响应式编程模型，并让我们的静态视图生动起来的暗示。让我们定义应用程序的状态。我们将尽量保持简单，先假设一个 `Lake` 业务逻辑类，其唯一可变状态是用户是否已加星标：

```
abstract class Lake {
  String get imageAsset;
  String get name;
  String get locationName;
  String get description;

  int get starCount;
  bool get isStarred;
  void toggleStarring();

  void call();
  void route();
  void share();
}
```

然后，我们可以从 `Lake` 实例动态地构造我们的组件树，并且同时还可以设置事件处理程序以调用其方法。响应式编程模型的优点在于我们只需在代码库中执行一次。只要 `Lake` 实例发生变化，Flutter 框架就会重建我们的组件树——前提是我们告诉框架。这需要使 `MyApp` 成为一个 `StatefulWidget`，这反过来又涉及将组件构建委托给一个相关的 `State` 对象，然后每当我们在 `Lake` 上加星标时调用 `State.setState` 方法。

* [main.dart](https://gist.github.com/mravn-google/5962e261ee61c82d8f298fd2fe03fd29#file-main-dart)：

```
import 'package:flutter/material.dart';
import 'src/lake.dart';
import 'src/widgets.dart';

void main() {
  // 假装我们从业务逻辑中获取 Lake 实例。
  final Lake lake = Lake();
  runApp(MyApp(lake));
}

class MyApp extends StatefulWidget {
  final Lake lake;

  MyApp(this.lake);

  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final Lake lake = widget.lake;
    final Widget imageSection = Image.asset(
      lake.imageAsset,
      width: 600.0,
      height: 240.0,
      fit: BoxFit.cover,
    );
    final Widget titles = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            lake.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          lake.locationName,
          style: TextStyle(color: Colors.grey[500]),
        ),
      ],
    );
    final Widget stars = GestureDetector(
      child: Row(
        children: <Widget>[
          Icon(
            lake.isStarred ? Icons.star : Icons.star_border,
            color: Colors.red[500],
          ),
          Text('${lake.starCount}'),
        ],
      ),
      onTap: () {
        setState(() {
          lake.toggleStarring();
        });
      },
    );
    final Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: <Widget>[
          Expanded(child: titles),
          stars,
        ],
      ),
    );
    final Widget actionSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Action(label: 'CALL', icon: Icons.call, handler: lake.call),
          Action(label: 'ROUTE', icon: Icons.near_me, handler: lake.route),
          Action(label: 'SHARE', icon: Icons.share, handler: lake.share),
        ],
      ),
    );
    final Widget textSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Text(
        lake.description,
        softWrap: true,
      ),
    );
    final Widget scaffold = Scaffold(
      appBar: AppBar(title: Text('Top Lakes')),
      body: ListView(
        children: <Widget>[
          imageSection,
          titleSection,
          actionSection,
          textSection,
        ],
      ),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      home: scaffold,
    );
  }
}
```

* [widgets.dart](https://gist.github.com/mravn-google/5962e261ee61c82d8f298fd2fe03fd29#file-widgets-dart):

```
import 'package:flutter/material.dart';

class Action extends StatelessWidget {
  Action({Key key, this.label, this.icon, this.handler}) : super(key: key);

  final String label;
  final IconData icon;
  final VoidCallback handler;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: handler,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}
```

这有用，但效率不高。最初的挑战是深度嵌套的组件树。那个树仍然在那里，如果不在我们的代码中，那么就在运行时。重建所有这些只是为了切换切换星标完全是一种浪费。当然，Dart 的实现可以非常有效地处理短寿命对象，但如果你反复重建，Dart 也会耗尽你的电池——特别是涉及动画的地方。一般来说，我们应该将重建限制在实际改变的子树上。

你有没有抓住这个矛盾？组件树是用户界面的不可变描述。如何在不从根重构的情况下重建其中的一部分？实际上，组件树不是具有从父组件到子组件，从根到叶的引用的物化树结构。特别是 `StatelessWidget` 和 `StatefulWidget`，它们没有子引用。他们提供的是 `build` 方法（在有状态的情况下，通过相关的 `State` 实例）。Flutter 框架递归地调用那些 `build` 方法，同时生成或更新实际的运行时树结构，不是组件，而是引用组件的 `Element` 实例。元素树是可变的，并由 Flutter 框架管理。

那么当你在 `State` 实例 _s_ 上调用 `setState` 时会发生什么？Flutter 框架标记了以 _s_ 对应元素为根的子树，用于重建。当下一帧到期时，该子树将根据 _s_ 的 `build` 方法返回的组件树进行更新，而后者依赖于当前的应用程序状态。

我们对代码的最终尝试提取了一个有状态的 `LakeStars` 组件，将重建限制在一个非常小的子树中。而 `MyApp`又变回无状态。

* [main.dart](https://gist.github.com/mravn-google/5962e261ee61c82d8f298fd2fe03fd29#file-main-dart)：

```
import 'package:flutter/material.dart';
import 'src/lake.dart';
import 'src/widgets.dart';

void main() {
  // 假装我们从业务逻辑中获取 Lake 实例。
  final Lake lake = Lake();
  runApp(MyApp(lake));
}

class MyApp extends StatelessWidget {
  const MyApp(this.lake);

  final Lake lake;

  @override
  Widget build(BuildContext context) {
    final Widget imageSection = ...
    final Widget titles = ...
    final Widget titleSection = Container(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        children: <Widget>[
          Expanded(child: titles),
          LakeStars(lake: lake),
        ],
      ),
    );
    final Widget actionSection = ...
    final Widget textSection = ...
    final Widget scaffold = ...
    return MaterialApp(
      title: 'Flutter Demo',
      home: scaffold,
    );
  }
}
```

* [widgets.dart](https://gist.github.com/mravn-google/5962e261ee61c82d8f298fd2fe03fd29#file-widgets-dart):

```
import 'package:flutter/material.dart';
import 'lake.dart';

class LakeStars extends StatefulWidget {
  LakeStars({Key key, this.lake}) : super(key: key);

  final Lake lake;

  @override
  State createState() => LakeStarsState();
}

class LakeStarsState extends State<LakeStars> {
  @override
  Widget build(BuildContext context) {
    final Lake lake = widget.lake;
    return GestureDetector(
      child: Row(
        children: <Widget>[
          Icon(
            lake.isStarred ? Icons.star : Icons.star_border,
            color: Colors.red[500],
          ),
          Text('${lake.starCount}'),
        ],
      ),
      onTap: () {
        setState(() {
          lake.toggleStarring();
        });
      },
    );
  }
}

class Action extends StatelessWidget { ... }
```

将一个普遍适用的 `Stars` 组件与 `Lake` 概念分离开似乎是正确的，但我把它作为给读者的练习。

在成功将视图逻辑添加到代码中之后，嵌套深度仍然是便于管理的，我认为我们已经对深度嵌套的挑战做出了合理的解决。

* * *

我们可以设想几个有趣的技术解决方案，来解决在嵌套的组件树中 Flutter 视图逻辑丢失的问题。其中一些可能需要修改 Flutter 框架、IDE 和其他工具，甚至可能需要修改 Dart 的语法。

不过，你现在已经可以做一些很强大的事情了，只需将问题的原因——代码编写 UI、组件的组合和响应式编程——转变为你的优势。摆脱深度嵌套的语法只是迈向可读、可维护和高效的移动应用代码之旅的开始。

开心地使用 Flutter 吧！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
