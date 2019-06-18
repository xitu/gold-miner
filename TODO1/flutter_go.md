> * 原文地址：[Thought Experiment: Flutter in Go](https://divan.dev/posts/flutter_go/)
> * 原文作者：[divan](https://divan.dev/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter_go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter_go.md)
> * 译者：[suhanyujie](https://github.com/suhanyujie)
> * 校对者：

# 思考：用 Go 实现 Flutter

我最近发现了 [Flutter](https://flutter.io) —— 谷歌的一个新的移动开发框架，我甚至有曾经将 Flutter 基础知识教给从未有过编程的人的经历。Flutter 是用 Dart 编写的，这是一种诞生于 Chrome 浏览器的编程语言，后来改用到了控制台。这不禁让我想到“Flutter 也许可以很轻易地用 Go 来实现”！

为什么不用 Go 实现呢？Go 和 Dart 都是诞生于谷歌（并且有很多的大会分享使它们变得更好），它们都是强类型的编译语言 —— 这样做会有一些形势上的不同，因为 Go 绝对可以成为一个像 Flutter 这样热门项目的选择。而那时候 Go 会更容易地向没有编程经验的人解释或传授。 

假如 Flutter 已经是用 Go 开发的。那它的代码会是什么样的？

[![VSCode 中 Go 版的 Flutter](https://divan.dev/images/go_flutter_vscode.png)](https://divan.dev/images/go_flutter_vscode_big.png)

### Dart 的问题

自从 Dart 在 Chrome 中出现以来，我就一直在关注它的开发情况，我也一直认为 Dart 最终会在所有浏览器中取代 JS。2015 年，得知[有关谷歌在 Chrome 中放弃 Dart 支持](https://news.dartlang.org/2015/03/dart-for-entire-web.html)的消息时，我非常沮丧。

Dart 是非常奇妙的！是的，当你从 JS 升级转向到 Dart时，一切都很好，可如果你从 Go 降级转过来，就没那么惊奇了，但是...Dart 拥有非常多的特性 —— 类、泛型、异常、Futures、异步等待、事件循环、JIT、AOT、垃圾回收、重载 —— 你能想到的它都有。它有用于 getter/setter 的特殊语法、有用于构造函数自动初始化的特殊语法、有用于特殊语句的特殊语法等。

虽然它让能让拥有其他语言经验的人更容易熟悉 Dart —— 这很不错，也降低了入门门槛 —— 但我发现很难向没有编程经验的新手讲解它。

* **所有“特殊”的东西都被混淆** —— **“名为构造方法的特殊方法”**，**“用于初始化的特殊语法”**，**“用于覆盖的特殊语法”**等等。
* **所有“隐藏”的东西都令人困惑** —— **“这个类是从哪儿导入的？它是隐藏的，你看不到它的实现代码”**，**“为什么我们在这个类中写一个构造方法而不是其他方法？它在那里，可是它是隐藏的”**等等。
* **所有“有歧义的语法”被混淆** —— **“所以我应该在这里使用命名或者对应位置的参数吗？”**，**“应该使用 final 还是用 const 进行变量声明？”**，**“应该使用普通函数语法还是‘箭头函数语法’”**等等。

这三个标签 —— “特殊”、“隐藏”和“歧义” —— 可能符合人们在编程语言中所说的“魔力”的本质。这些特性旨在帮助我们编写更简单、更干净的代码，但实际上，他们给阅读程序增加了更多的混乱和心智负担。

而这正是 Go 采取了截然不同的方式，并强烈声明自己特色的地方。Go 实际上是一个非魔法的语言 —— 它将特殊、隐藏、歧义之类的东西的数量讲到最低。然而，它也有一些缺点。

### Go 的问题

当我们讨论 Flutter 这种 UI 框架时，我们必须把 Go 看作一个描述/指明 UI 的工具。UI 框架是一个非常复杂的主题，它需要创建一种专门的语言来处理大量的底层复杂性。最流行的方法之一是创建 [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) —— 特定领域的语言 —— 众所周知，Go 在这方面不那么尽如人意。

创建 DSL 意味着创建开发人员可以使用的自定义术语和谓词。生成的代码应该可以捕捉 UI 布局和交互的本质，并且足够灵活，可以应对设计师的想象流，又足够的严格，符合 UI 框架的限制。例如，你应该能够将按钮放入容器中，然后将图标和文本小部件放入按钮中，可如果你视图将按钮放入文本中，编译器应该给你提示一个错误。

特定于 UI 的语言通常也是声明性的 —— 实际上，这意味着你应该能够使用构造代码（包括空格缩进！）来可视化的捕获 UI widget 树的结构，然后让 UI 框架找出要运行的代码。

有些语言更适合这样的使用方式，而 Go 从来没有被设计来完成这类的任务。因此，在 Go 中编写 Flutter 代码应该是一个相当大的挑战！

## Flutter 的优势

如果你不熟悉 Flutter，我强烈建议你花一两个周末的时间来观看教程或阅读文档，因为它无疑会改变移动开发领域的游戏规则。而且，希望不仅仅是移动端 —— 还有[原生桌面应用程序]((https://github.com/google/flutter-desktop-embedding))和 [web 应用程序](https://medium.com/flutter-io/hummingbird-building-flutter-for-the-web-e687c2a023a8)的渲染器（用 Flutter 的术语来说就是嵌入式）。Flutter 容易学习，它是合乎逻辑的，它汇集了大量的 [Material Design](https://material.io) 强大组件库，有活跃的社区和丰富的工具链（如果你喜欢“构建/测试/运行”的工作流，你也能在 Flutter 中找到同样的“构建/测试/运行”的工作方式）还有大量的用于实践的工具盒。

在一年前我需要一个相对简单的移动应用（很明显就是 IOS 或 Android），但我深知精通这两个平台开发的复杂性是非常非常大的（至少对于这个 app 是这样的），所以我不得不将其外包给另一个团队并为此付钱。对于像我这样一个拥有近 20 年的编程经验的开发者来说，开发这样的移动应用几乎是无法忍受的。

使用 Flutter，我用了 3 个晚上的时间就编写了同样的应用程序，与此同时，我是从头开始学习这个框架的！这是一个数量级的提升，也是游戏规则的巨大改变。

我记得上一次看到类似这种开发生产力革命是在 5 年前，当时我发现了 Go。并且它改变了我的生活。

我建议你从这个[很棒的视频教程](https://www.youtube.com/watch?v=GLSG_Wh_YWc)开始。

## Flutter 的 Hello, world

当你用 `flutter create` 创建一个新的 Flutter 项目，你会得到这个“Hello, world”应用程序和代码文本、计数器和一个按钮，点击增加按钮计数器会增加。

![flutter hello world](https://divan.dev/images/flutter_hello.gif)

我认为用我们假想的 Go 版的 Flutter 重写这个例子是非常好的。它与我们的主题有密切的关联。看一下它的代码（它是一个文件）：

lib/main.dart:

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
```

我们先把它分解成几个部分，分析哪些可以映射到 Go 中，哪些不能映射，并探索目前我们拥有的选项。

### 映射到 Go

一开始是相对比较简单的 —— 导入依赖项并启动 `main()` 函数。这里没有什么挑战性也不太有意思，只是语法上的变化：

```go
package hello

import "github.com/flutter/flutter"

func main() {
    app := NewApp()
    flutter.Run(app)
}
```

唯一的不同的是不适用魔法的 `MyApp()` 函数，它是一个构造方法，也是一个特殊的函数，它隐藏在被称为 `MyApp` 的类中，我们只是调用一个显示定义的 `NewApp()` 函数 —— 它做了同样的事情，但它更易于阅读、理解和弄懂。

### Widget 类

在 Flutter 中，一切皆 widget。在 Flutter 的 Dart 版本中，每个小部件都代表一个类，这个类扩展了 Flutter 中特殊的 Widget 类。

Go 中没有类，因此也没有类层次，因为 Go 的世界不是面向对象的，更不必说类层次了。对于只熟悉基于类的 OOP 的人来说，这可能是一个不太好的情况，但也不尽然。这个世界是一个巨大的相互关联的事物和关系图谱。它不是混沌的，可也不是完全的结构化，并且尝试将所有内容都放入类层次结构中可能会导致代码难以维护，到目前为止，世界上的大多数代码库都是这样子的。

![OOP 的真相](https://divan.dev/images/oop_truth.png)

我喜欢 Go 的设计者们努力重新思考这个无处不在的基于 OOP 思维，并提出了与之不同的 OOP 概念，这与 OOP 的发明者  Alan Kay 的[真实意义](https://www.quora.com/What-did-Alan-Kay-mean-by-I-made-up-the-term-object-oriented-and-I-can-tell-you-I-did-not-have-C++-in-mind)更接近，这不是偶然。

在 Go 中，我们用一个具体的类型 —— 一个结构体来表示这种抽象：

```go
type MyApp struct {
    // ...
}
```

在一个 Flutter 的 Dart 版本中，`MyApp`必须继承于 `StatelessWidget` 类并覆盖它的 `build` 方法，这样做有两个作用：

1. 自动地给予 `MyApp` 一些 widget 属性/方法
2. 通过调用 `build`，允许 Flutter 在其构建/渲染管道中使用跟我们的组件

我不知道 Flutter 的内部原理，所以让我们不要怀疑我们是否能用 Go 实现它。为此，我们只有一个选择 —— [类型嵌入](https://golang.org/doc/effective_go.html#embedding)

```go
type MyApp struct {
    flutter.Core
    // ...
}
```

这将增加 `flutter.Core` 中所有导出的属性和方法到我们的 `MyApp` 中。我将它称为 `Core` 而不是 `Widget`，因为嵌入的这种类型还不能使我们的 `MyApp` 称为一个 widget，而且，这是我在 [Vecty](https://github.com/gopherjs/vecty) GopherJS 框架中看到的类似场景的选择。稍后我将简要的探讨 Flutter 和 Vecty 之间的相似之处。

第二部分 —— Flutter 引擎中的 `build` 方法 —— 当然应该简单的通过添加方法来实现，满足在 Go 版本的 Flutter 中定义的一些接口：

flutter.go 文件:

```go
type Widget interface {
    Build(ctx BuildContext) Widget
}
```

我们的 main.go 文件:

```go
type MyApp struct {
    flutter.Core
    // ...
}

// 构建渲染 MyApp 部件。实现 Widget 的接口
func (m *MyApp) Build(ctx flutter.BuildContext) flutter.Widget {
    return flutter.MaterialApp()
}
```

我们可能会注意到这里和 Dart 版的 Flutter 有些不同：

* 代码更加冗长 —— `BuildContext`，`Widget` 和 `MaterialApp` 等方法前都明显地提到了 `flutter`。
* 代码更简洁 —— 没有 `extends Widget` 或者 `@override` 子句。
* Build 方法是大写开头的，因为在 Go 中它的意思是“公共”可见性。在 Dart 中，大写开头小写开头都可以，但是要使属性或方法“私有化”，名称需要使用下划线（_）开头。

为了实现一个 Go 版的 Flutter `Widget`，现在我们需要嵌入 `flutter.Core` 并实现 `flutter.Widget` 接口。好了，非常清楚了，我们继续往下实现。

## 状态

在 Dart 版的 Flutter 中，这是我发现的第一个困惑的地方。Flutter 中有两种部件 —— `StatelessWidget` 和 `StatefulWidget`。嗯，对我来说，无状态部件只是一个没有状态的部件，所以，为什么这里要创建一个新的类呢？好吧，我也能接受。但是你不能仅仅以相同的方式扩展 `StatefulWidget`，你应该执行以下神奇的操作（安装了 Flutter 插件的 IDE 都可以做到，但这不是重点）：

```dart
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold()
  }
}
```

呃，我们不仅仅要理解这里写的是什么，还要理解，为什么这样写？

这里要解决的任务是向部件中添加状态（`counter`）时，并允许 Flutter 在状态更改时重绘部件。这就是复杂性的根源。

其余的都是[偶然的复杂性](https://www.quora.com/What-is-accidental-complexity)。Dart 版的 Flutter 中的办法是引入一个新的 `State` 类，它使用泛型并以小部件作为参数。所以 `_MyAppState` 是一个来源于 `State of a widget MyApp` 的类。好了，有点道理...但是为什么 `build()` 方法是在一个状态而非部件上定义的呢？这个问题在 Flutter 仓库的 FAQ 中有[回答](https://flutter.io/docs/resources/faq#why-is-the-build-method-on-state-not-statefulwidget)，[这里](https://docs.flutter.io/flutter/widgets/State/build.html)也有详细的讨论，概括一下就是：子类 `StatefulWidget` 被实例化时，为了避免 bug 之类的。换句话说，它是基于类的 OOP 设计的一种变通方法。

我们如何用 Go 来设计它呢？

首先，我个人会尽量避免为 `State` 创建一个新概念 —— 我们已经在任意具体类型中隐式地包含了“state” —— 它只是结构体的属性（字段）。可以说，语言已经具备了这种状态的概念。因此，创建一个新状态只会让开发人员赶到困惑 —— 为什么我们不能在这里使用类型的“标准状态”。

当然，挑战在于使 Flutter 引擎跟踪状态发生变化并对其作出反应（毕竟这是响应式编程的要点）。我们不需要为状态的更改创建特殊方法和包装器，我们只需要让开发人员手动告诉 Flutter 何时需要更新小部件。并不是所有的状态更改都需要立即重绘 —— 有很多典型场景能说明这个问题。我们来看看：

```go
type MyHomePage struct {
    flutter.Core
    counter int
}

// Build renders the MyHomePage widget. Implements Widget interface.
func (m *MyHomePage) Build(ctx flutter.BuildContext) flutter.Widget {
    return flutter.Scaffold()
}

// incrementCounter increments widgets's counter by one.
func (m *MyHomePage) incrementCounter() {
    m.counter++
    flutter.Rerender(m)
    // or m.Rerender()
    // or m.NeedsUpdate()
}
```

这里有很多命名和设计选项 —— 我喜欢其中的 `NeedsUpdate()`，因为它很明确，而且是 `flutter.Core`（每个部件都有它）的一个方法，但 `flutter.Rerender()` 也可以正常工作。它给人一种即时重绘的错觉，但是 —— 并不会经常这样 —— 它将在下一帧时重绘，状态更新的频率可能比帧的重绘的频率高的多。

但问题是，我们只是实现了相同的任务，也就是添加一个状态响应到小部件中，下面的还未实现：

* 新的类型
* 泛型
* 读/写状态的特殊规则
* 新的特殊的方法覆盖

另外，API 更简洁也更明确 —— 只需增加计数器并请求 flutter 重新渲染 —— 当你要求调用特殊函数 `setState` 时，有些变化并不明显，该函数返回另一个实际状态更改的函数。同样，隐藏的魔术会有损可读性，我们设法避免了这一点。因此，代码更简单，并且精简了两倍。

### Stateful widgets as a children

继续这个逻辑，让我们仔细看看在 Flutter 中，“有状态的小部件”是如何在另一个部件中使用的：

```dart
@override
Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
}
```

这里的 `MyHomePage` 是一个“有状态的小部件”（它有一个计数器），我们通过在构建过程中调用构造函数 `MyHomePage(title:"...")` 来创建它...等等，构建的是什么？

调用 `build()` 重绘小部件，可能每秒有多次绘制。为什么我们要在每次渲染中创建一个小部件？更别说在每次重绘循环中，重绘有状态的小部件了。

[结论是](https://flutter.io/docs/resources/technical-overview#handling-user-interaction)，Flutter 用小部件和状态之间的这种分离来隐藏这个初始化/状态记录，不让开发者过多关注。它确实每次都会创建一个新的 `MyHomePage` 部件，但它保留了原始状态（以单例的方式），并自动找到这个“唯一”状态，将其附加到新创建的 `MyHomePage` 部件上。

对我来说，这没有多大意义 —— 更多的隐藏，更多的魔法也更模糊（我们仍然可以添加小部件作为类属性，并在创建小部件时实例化它们）。我理解为什么这种方式不错了（不需要跟踪部件的子组件），并且它具有良好的简化重构作用（只有在一个地方删除构造函数的调用才能删除子组件），但任何开发者试图真正搞懂整个工作原理时，都可能会有些困惑。

对于 Go 版的 Flutter，我肯定更倾向于状态显式和清晰的初始化的小部件，虽然这意味着代码会更冗长。Dart 的 Flutter 实现可能也可以实现这种方式，但我喜欢 Go 的非魔法特性，而这种哲学也适用于 Go 框架。因此，我的有状态子部件的代码应该类似这样：

```go
// MyApp 是应用顶层的部件。
type MyApp struct {
    flutter.Core
    homePage *MyHomePage
}

// NewMyApp 实例化一个 MyApp 部件
func NewMyApp() *MyApp {
    app := &MyApp{}
    app.homePage = &MyHomePage{}
    return app
}

// Build 渲染了 MyApp 部件。实现了 Widget 接口
func (m *MyApp) Build(ctx flutter.BuildContext) flutter.Widget {
    return m.homePage
}

// MyHomePage 是一个首页部件
type MyHomePage struct {
    flutter.Core
    counter int
}

// Build 渲染 MyHomePage 部件。实现 Widget 接口
func (m *MyHomePage) Build(ctx flutter.BuildContext) flutter.Widget {
    return flutter.Scaffold()
}

// 增量计数器让 app 的计数器增加一
func (m *MyHomePage) incrementCounter() {
    m.counter++
    flutter.Rerender(m)
}
```

The code is more verbose, and if we had to change/replace MyHomeWidget in MyApp, we would have to touch code in 3 places, but a side effect is that we have a full and clear picture of what going on at each stage of the code execution. There is no hidden stuff happening behind the scene, we can reason about the code, about performance and dependencies of each of our types and functions with 100% confidence. And, for some, that’s the ultimate goal of writing reliable and maintainable code.
代码更加详细清晰了，如果我们必须在 MyApp 中更改/替换 MyHomeWidget，那我们需要在 3 个地方有所改动，还有一点是，我们对代码执行的每个阶段都有一个完整而清晰的了解。没有隐藏的东西在幕后发生，我们可以 100% 自信的推断代码、性能和每个类型以及函数的依赖关系。对于一些人来说，这就是最终目标，即编写可靠且可维护的代码。

顺便说一下，Flutter 有一个名为 [StatefulBuilder](https://medium.com/flutter-community/stateful-widgets-be-gone-stateful-builder-a67f139725a0) 的特殊部件，它为隐藏的状态管理增加了更多的魔力。

## DSL

现在，到了有趣的部分。我们如何在 Go 中构建一个 Flutter 的部件树？我们希望我们的部件树简洁、易读、易重构并且易于更新、描述部件之间的空间关系，增加足够的灵活性来插入自定义代码，比如，按下按钮时的程序处理等等。

我认为 Dart 版的 Flutter 是非常好看的，不言自明：

```dart
return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
```

每个小部件都有一个构造方法，它接收可选的参数，而使这种声明式方法真正好用的技巧是 [函数的命名参数](https://en.wikipedia.org/wiki/Named_parameter)。

### 命名参数

为了防止你不熟悉，详细说明一下，在大多数语言中，参数被称为“位置参数”，因为它们在函数调用中的参数位置很重要：

```dart
Foo(arg1, arg2, arg3)
```

使用命名参数时，还可以在函数调用中写入它们的名称：

```dart
Foo(name: arg1, description: arg2, size: arg3)
```

它虽增加了冗余性，但帮你省略了你点击跳转函数来理解这些参数的意思。

对于 UI 部件树，它们在可读性方面起着至关重要的作用。考虑一下跟上面相同的代码，在没有命名参数的情况下：

```dart
return Scaffold(
      AppBar(
          Text(widget.title),
      ),
      Center(
        Column(
          MainAxisAlignment.center,
          <Widget>[
            Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      FloatingActionButton(
        _incrementCounter,
        'Increment',
        Icon(Icons.add),
      ),
    );
```

咩，是不是？它不仅难以阅读和理解（你需要记住每个参数的含义、类型，这是一个很大的心智负担），而且我们在传递那些参数时没有灵活性。例如，你可能不希望你的 Material 应用有 `FloatingButton`，所以你只是不传递 `floatingActionButton`。如果没有命名参数，你将被迫传递它（例如可能是 `null`/`nil`），或者使用一些带有反射的脏魔法来确定用户通过构造函数传递了哪些参数。

由于 Go 没有函数重载或命名参数，对此将是一个艰巨的任务。

## 用 Go 实现部件树

### Version 1

The temptation here might be just to replicate Dart’s way of expressing widgets tree, but what we really need is to step back and answer the question – which is the best way to represent this type of data within the constraints of the language?
这个版本的例子可能只是拷贝 Dart 表示部件树的方法，但我们真正需要的是后退一步并回答这个问题 —— 在语言的约束下，哪种方法是表示这种类型数据的最佳方法呢？

让我们仔细看看 [Scaffold](https://docs.flutter.io/flutter/material/Scaffold-class.html) 对象，它是构建外观美观的现代 UI 的好帮手。它有这些**属性** —— appBar，drawer，home，bottomNavigationBar，floatingActionButton —— 所有都是 Widget。我们创建类型为 `Scaffold` 的对象的同事初始化这些属性。这样看来，它与任何普通对象实例化没有什么不同，不是吗？

让我们试试原生的方法：

```dart
return flutter.NewScaffold(
    flutter.NewAppBar(
        flutter.Text("Flutter Go app", nil),
    ),
    nil,
    nil,
    flutter.NewCenter(
        flutter.NewColumn(
            flutter.MainAxisCenterAlignment,
            nil,
            []flutter.Widget{
                flutter.Text("You have pushed the button this many times:", nil),
                flutter.Text(fmt.Sprintf("%d", m.counter), ctx.Theme.textTheme.display1),
            },
        ),
    ),
    flutter.FloatingActionButton(
        flutter.NewIcon(icons.Add),
        "Increment",
        m.onPressed,
        nil,
        nil,
    ),
)
```

Well, not the prettiest UI code, for sure. The word `flutter` is so abundant that it begs for hiding (actually, I should have named it `material`, not `flutter`), those nameless parameters are not clear, especially `nil`s.
当然，这不是最漂亮的 UI 代码。`flutter` 这个词是如此的富有意义，以至于它要求隐藏起来（实际上，我应该把它命名为 `material` 而非 `flutter`），这些无名的参数并不清楚，尤其是 `nil`。

### Version 2

由于大多数代码都会使用 `flutter` 导入，所以使用导入点符号（.）的方式将 `flutter` 导入到我们的命名空间中是没问题的：

```dart
import . "github.com/flutter/flutter"
```

现在，我们不用写 `flutter.Text`，而只需要写 `Text`。这种方式通常不是很优雅，但是我们使用的是一个框架，在每一行都可以使用这种导入的内容，所以在这里是一个很好的实践。另一个有效的场景是一个基于 [GoConvey](http://goconvey.co) 框架的 Go 测试。对我来说，框架相当于其他语言之上的语言，所以在框架中使用点符号导入也是可以的。

我们继续往下写我们的代码：

```dart
return NewScaffold(
    NewAppBar(
        Text("Flutter Go app", nil),
    ),
    nil,
    nil,
    NewCenter(
        NewColumn(
            MainAxisCenterAlignment,
            nil,
            []Widget{
                Text("You have pushed the button this many times:", nil),
                Text(fmt.Sprintf("%d", m.counter), ctx.Theme.textTheme.display1),
            },
        ),
    ),
    FloatingActionButton(
        NewIcon(icons.Add),
        "Increment",
        m.onPressed,
        nil,
        nil,
    ),
)
```

比较简洁，但是那些 nil... 我们怎么才能避免那些必须传递的参数？

### Version 3

反射怎么样？一些早期的 Go Http 框架使用了这种方式（例如 [martini](https://github.com/go-martini/martini)）—— 你可以通过参数传递任何你想要传递的内容，运行时将检查这是否是一个已知的类型/参数。从多数角度看，这不是一个好办法 —— 它不安全，速度相对比较慢，还具魔法的特性 —— 但为了探索，我们还是试试：

```dart
return NewScaffold(
    NewAppBar(
        Text("Flutter Go app"),
    ),
    NewCenter(
        NewColumn(
            MainAxisCenterAlignment,
            []Widget{
                Text("You have pushed the button this many times:"),
                Text(fmt.Sprintf("%d", m.counter), ctx.Theme.textTheme.display1),
            },
        ),
    ),
    FloatingActionButton(
        NewIcon(icons.Add),
        "Increment",
        m.onPressed,
    ),
)
```

好吧，这跟 Dart 的原始版本有些类似，但缺少命名参数，确实会妨碍在这种情况下的可选参数的可读性。另外，代码本身就有些不好的迹象。

### Version 4

让我们重新思考一下，在创建新对象和可选的定义他们的属性时，我们究竟想做什么？这只是一个普通的变量实例，所以假如我们用另一种方式来尝试呢：

```dart
scaffold := NewScaffold()
scaffold.AppBar = NewAppBar(Text("Flutter Go app"))

column := NewColumn()
column.MainAxisAlignment = MainAxisCenterAlignment

counterText := Text(fmt.Sprintf("%d", m.counter))
counterText.Style = ctx.Theme.textTheme.display1
column.Children = []Widget{
  Text("You have pushed the button this many times:"),
  counterText,
}

center := NewCenter()
center.Child = column
scaffold.Home = center

icon := NewIcon(icons.Add),
fab := NewFloatingActionButton()
fab.Icon = icon
fab.Text = "Increment"
fab.Handler = m.onPressed

scaffold.FloatingActionButton = fab

return scaffold
```

这种方法是有效的，虽然它解决了“命名参数问题”，但它也确实打乱了对部件树的理解。首先，它颠倒了创建小部件的顺序 —— 小部件越深，越应该早定义它。其次，我们丢失了基于代码缩进的空间布局，好的缩进布局对于快速构建部件树的高级预览非常有用。

顺便说一下，这种方法已经在 UI 框架中使用很长时间，比如 [GTK](https://www.gtk.org) 和 [Qt](https://www.qt.io)。可以到最新的 Qt 5 框架的文档中查看[代码示例](http://doc.qt.io/qt-5/qtwidgets-mainwindows-mainwindow-mainwindow-cpp.html)。

```dart
    QGridLayout *layout = new QGridLayout(this);

    layout->addWidget(new QLabel(tr("Object name:")), 0, 0);
    layout->addWidget(m_objectName, 0, 1);

    layout->addWidget(new QLabel(tr("Location:")), 1, 0);
    m_location->setEditable(false);
    m_location->addItem(tr("Top"));
    m_location->addItem(tr("Left"));
    m_location->addItem(tr("Right"));
    m_location->addItem(tr("Bottom"));
    m_location->addItem(tr("Restore"));
    layout->addWidget(m_location, 1, 1);

    QDialogButtonBox *buttonBox = new QDialogButtonBox(QDialogButtonBox::Ok | QDialogButtonBox::Cancel, this);
    connect(buttonBox, &QDialogButtonBox::rejected, this, &QDialog::reject);
    connect(buttonBox, &QDialogButtonBox::accepted, this, &QDialog::accept);
    layout->addWidget(buttonBox, 2, 0, 1, 2);

```

So for some people, it might be a more natural way to describe UI as a code. But it’s hard to deny that it’s definitely not the best option.

### Version 5

One more option I considered is creating a separate type for constructor parameters. For example:

```dart
func Build() Widget {
    return NewScaffold(ScaffoldParams{
        AppBar: NewAppBar(AppBarParams{
            Title: Text(TextParams{
                Text: "My Home Page",
            }),
        }),
        Body: NewCenter(CenterParams{
            Child: NewColumn(ColumnParams{
                MainAxisAlignment: MainAxisAlignment.center,
                Children: []Widget{
                    Text(TextParams{
                        Text: "You have pushed the button this many times:",
                    }),
                    Text(TextParams{
                        Text:  fmt.Sprintf("%d", m.counter),
                        Style: ctx.textTheme.display1,
                    }),
                },
            }),
        }),
        FloatingActionButton: NewFloatingActionButton(
            FloatingActionButtonParams{
                OnPressed: m.incrementCounter,
                Tooltip:   "Increment",
                Child: NewIcon(IconParams{
                    Icon: Icons.add,
                }),
            },
        ),
    })
}
```

Not bad, actually! Those `..Params` are verbose, but it’s not a deal breaker. In fact, this approach I encounter quite often in Go libs. It works especially fine when you have just a couple of objects need to be instantiated this way.

There is a way to remove `...Params` verbosity, but it’ll require language change. There a Go proposal exists that aims to achieve exactly that - [untyped composite literals](https://github.com/golang/go/issues/12854). Basically, it means we should be able to shorten `FloattingActionButtonParameters{...}` to just `{...}`, so our code could look like that:

```dart
func Build() Widget {
    return NewScaffold({
        AppBar: NewAppBar({
            Title: Text({
                Text: "My Home Page",
            }),
        }),
        Body: NewCenter({
            Child: NewColumn({
                MainAxisAlignment: MainAxisAlignment.center,
                Children: []Widget{
                    Text({
                        Text: "You have pushed the button this many times:",
                    }),
                    Text({
                        Text:  fmt.Sprintf("%d", m.counter),
                        Style: ctx.textTheme.display1,
                    }),
                },
            }),
        }),
        FloatingActionButton: NewFloatingActionButton({
                OnPressed: m.incrementCounter,
                Tooltip:   "Increment",
                Child: NewIcon({
                    Icon: Icons.add,
                }),
            },
        ),
    })
}
```

That’s an almost perfect similarity with Dart’s version! It will, however, require creating those parameters types for each widget.

### Version 6

Another option to explore is to use chaining of widget’s methods. I forgot the name of this pattern, but it’s not important because patterns should emerge from code, not the opposite way.

The basic idea is that upon creating a widget – say `NewButton()` – we immediately call a method like `WithStyle(...)`, which returns the same object so that we can call more and more methods, in a row (or a column):

```dart
button := NewButton().
    WithText("Click me").
    WithStyle(MyButtonStyle1)
```

or

```dart
button := NewButton().
    Text("Click me").
    Style(MyButtonStyle1)
```

Let’s try to rewrite our Scaffold-based widget that way:

```dart
// Build renders the MyHomePage widget. Implements Widget interface.
func (m *MyHomePage) Build(ctx flutter.BuildContext) flutter.Widget {
    return NewScaffold().
        AppBar(NewAppBar().
            Text("Flutter Go app")).
        Child(NewCenter().
            Child(NewColumn().
                MainAxisAlignment(MainAxisCenterAlignment).
                Children([]Widget{
                    Text("You have pushed the button this many times:"),
                    Text(fmt.Sprintf("%d", m.counter)).
                        Style(ctx.Theme.textTheme.display1),
                }))).
        FloatingActionButton(NewFloatingActionButton().
            Icon(NewIcon(icons.Add)).
            Text("Increment").
            Handler(m.onPressed))
}
```

It’s not an alien concept – many Go libraries use a similar approach for the configuration options, for example. It’s a little bit different from original Dart’s one, but holds most of the desired properties:

* explicit building of widget tree
* named “parameters.”
* indentation showing “depth” of a widget in a tree
* ability to specify handlers

I also like conventional Go’s `New...()` naming pattern. It clearly communicates that it’s a function and it creates a new object. So much easier to explain to newcomers than explaining constructors: **“it’s a function with the same name as a class, but you won’t find this function, because it’s special, and you have no way to easily tell constructor from a normal function just by looking at it”**.

Anyway, from all the options I explored, the last two options are probably the most appropriate ones.

### Final version

Now, assembling all pieces together, that’s how I would say Flutter’s “hello, world” app looks like:

main.go

```go
package hello

import "github.com/flutter/flutter"

func main() {
    flutter.Run(NewMyApp())
}
```

app.go:

```go
package hello

import . "github.com/flutter/flutter"

// MyApp is our top application widget.
type MyApp struct {
    Core
    homePage *MyHomePage
}

// NewMyApp instantiates a new MyApp widget
func NewMyApp() *MyApp {
    app := &MyApp{}
    app.homePage = &MyHomePage{}
    return app
}

// Build renders the MyApp widget. Implements Widget interface.
func (m *MyApp) Build(ctx BuildContext) Widget {
    return m.homePage
}
```

home_page.go:

```go
package hello

import (
    "fmt"
    . "github.com/flutter/flutter"
)

// MyHomePage is a home page widget.
type MyHomePage struct {
    Core
    counter int
}

// Build renders the MyHomePage widget. Implements Widget interface.
func (m *MyHomePage) Build(ctx BuildContext) Widget {
    return NewScaffold(ScaffoldParams{
        AppBar: NewAppBar(AppBarParams{
            Title: Text(TextParams{
                Text: "My Home Page",
            }),
        }),
        Body: NewCenter(CenterParams{
            Child: NewColumn(ColumnParams{
                MainAxisAlignment: MainAxisAlignment.center,
                Children: []Widget{
                    Text(TextParams{
                        Text: "You have pushed the button this many times:",
                    }),
                    Text(TextParams{
                        Text:  fmt.Sprintf("%d", m.counter),
                        Style: ctx.textTheme.display1,
                    }),
                },
            }),
        }),
        FloatingActionButton: NewFloatingActionButton(
            FloatingActionButtonParameters{
                OnPressed: m.incrementCounter,
                Tooltip:   "Increment",
                Child: NewIcon(IconParams{
                    Icon: Icons.add,
                }),
            },
        ),
    })
}

// incrementCounter increments app's counter by one.
func (m *MyHomePage) incrementCounter() {
    m.counter++
    flutter.Rerender(m)
}
```

I actually quite like it.

# Conclusions

#### Similarity with Vecty

I could not help but notice how similar my final result to what [Vecty](https://github.com/gopherjs/vecty) framework provides. Basically, the general design is almost the same, it’s just Vecty outputs into DOM/CSS, while Flutter goes deeper into fully-fledged native rendering layers for providing crazy smooth 120fps experience with beautiful widgets (and solves a bunch of other problems). I think Vecty design is exemplary here, and no wonder my result ended up being a “Vecty adaptation for Flutter” :)

#### Understanding Flutter’s design better

This thought experiment has been interesting by itself – not every day you have to write (and explore!) code for the library/framework that has never been written. But it also helped me to dissect Flutter’s design a little bit deeper, read some technical docs, and uncover layers of hidden magic behind Flutter.

#### Go’s shortcomings

My verdict to the question “**Can Flutter be written in Go?”** is definitely **yes**, but I’m biased, not aware of many design constraints and this question has no right answer anyway. What I was more interested in is to explore where Go do or doesn’t fail to provide the same experience as a Dart in Flutter.

This thought experiment demonstrated that the **major issue Go has is purely syntactical**. Inability to call a function and pass either named parameters or untyped literals made it a bit harder and verbose to achieve clean and well-structured DSL-like widget tree creation. There are actually [Go proposals to add named parameters](https://github.com/golang/go/issues/12296) in a future Go versions, and it’s probably a backwards-compatible change. Having named parameters would definitely help for UI frameworks in Go, but it also introduces yet another thing to learn, yet another choice to make on each function definition or invocation, so the cumulative benefit is unclear.

There obviously were no issues with the absence of user-defined generics in Go or lack of exceptions. I would be happy to hear about another way to achieve cleaner and more readable Go implementation of Flutter with generics – I’m genuinely curious how it would help here. Feel free to post your thoughts and code in comments.

#### Thoughts about Flutter future

My final thoughts are that Flutter is unspeakably awesome despite all shortcomings I ranted in this post today. The “awesomeness/meh” ratio is surprisingly high in Flutter and Dart is actually quite easy to learn (if you know other programming languages). Taking into account web pedigree of Dart, I dream about a day, when every browser ships with a fast and optimized Dart VM inside and Flutter can natively serve as a framework for web apps as well (keeping an eye on [HummingBird](https://medium.com/flutter-io/hummingbird-building-flutter-for-the-web-e687c2a023a8) project, but native browser support would be better anyway).

Amount of incredible work done to make Flutter reality is just insane. It’s the project of a quality you dream of and seems to have a great and growing community. At least, the number of extremely well-prepared tutorials is staggering, and I hope to contribute to this awesome project one day.

To me, it’s definitely a game changer, and I’m committed to learn it to its full extent and be able to make great mobile apps every now and then. I encourage you to try Flutter even if you never thought you might be developing a mobile app – it’s really a breath of fresh air.

# Links

* [https://flutter.io](https://flutter.io)
* [Flutter Tutorial for Beginners - Build iOS and Android Apps](https://www.youtube.com/watch?v=GLSG_Wh_YWc)
* [Go proposal: An Improved, Golang-Cohesive Design for Named Arguments](https://github.com/golang/go/issues/12296)
* [Go proposal: spec: untyped composite literals](https://github.com/golang/go/issues/12854)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
