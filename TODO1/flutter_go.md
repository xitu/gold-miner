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

That was the first thing I found baffling with Dart’s Flutter. There are two kinds of widgets in Flutter – `StatelessWidget` and `StatefulWidget`. Uhm, to me, the stateful widget is just a widget without a state, so why invent a new class here? Well, okay, I can live with it. But you can’t just extend `StatefulWidget` in the same way, you should do the following magic (IDEs with Flutter plugin do it for you, but that’s not the point):
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

But the point is we just implemented the same task of adding a reactive state to the widget, without adding:
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

[It turns out](https://flutter.io/docs/resources/technical-overview#handling-user-interaction), Flutter uses this separation between Widget and State to hide this initialization/state-bookkeeping flow from the developer. It does create a new `MyHomePage` widget every time, but it preserves the original state (in a singleton way) and automatically find “orphaned” state to attach to the newly created `MyHomePage` widget.

To me it doesn’t make much sense – more hidden stuff, more magic and more ambiguity (we still can add Widgets as class properties and instantiate them once upon widget creation). I understand why it feels nice (no need to keep track of widget’s children) and it has the nice effect of simplifying refactoring (you have to delete constructor call in one place only to delete the child), but any developer attempting to really understand how does the whole thing works will be puzzled here.

For Go version, I definitely would prefer explicit and clear initialization of widgets with the state, even if it means more verbose code. Dart’s Flutter approach probably could be done as well, but I like Go for being non-magical, and that philosophy applies to Go frameworks as well. So, my code for stateful children widgets would look like this:

```go
// MyApp is our top application widget.
type MyApp struct {
    flutter.Core
    homePage *MyHomePage
}

// NewMyApp instantiates a new MyApp widget
func NewMyApp() *MyApp {
    app := &MyApp{}
    app.homePage = &MyHomePage{}
    return app
}

// Build renders the MyApp widget. Implements Widget interface.
func (m *MyApp) Build(ctx flutter.BuildContext) flutter.Widget {
    return m.homePage
}

// MyHomePage is a home page widget.
type MyHomePage struct {
    flutter.Core
    counter int
}

// Build renders the MyHomePage widget. Implements Widget interface.
func (m *MyHomePage) Build(ctx flutter.BuildContext) flutter.Widget {
    return flutter.Scaffold()
}

// incrementCounter increments app's counter by one.
func (m *MyHomePage) incrementCounter() {
    m.counter++
    flutter.Rerender(m)
}
```

The code is more verbose, and if we had to change/replace MyHomeWidget in MyApp, we would have to touch code in 3 places, but a side effect is that we have a full and clear picture of what going on at each stage of the code execution. There is no hidden stuff happening behind the scene, we can reason about the code, about performance and dependencies of each of our types and functions with 100% confidence. And, for some, that’s the ultimate goal of writing reliable and maintainable code.

By the way, Flutter has a special widget called [StatefulBuilder](https://medium.com/flutter-community/stateful-widgets-be-gone-stateful-builder-a67f139725a0), which adds even more magic for hiding state management.

## DSL

Now, the fun part. How do we build a Flutter’s widget tree in Go? We want to have our widgets tree concise, readable, easy to refactor and update, describe spatial relationship between widgets and add enough flexibility to plug in custom code like button press handlers and so on.

I think Dart’s Flutter version is quite beautiful and self-explanatory:

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

Every widget has a constructor function, which accepts optional parameters, and the real trick that makes this declarative way really nice is [named function parameters](https://en.wikipedia.org/wiki/Named_parameter).

### Named parameters

Just in case you’re unfamiliar, in most languages parameters are called “positional parameters” because it’s their position in the function call matters:

```dart
Foo(arg1, arg2, arg3)
```

while with named parameters, you also write their name in the function call:

```dart
Foo(name: arg1, description: arg2, size: arg3)
```

It adds verbosity, but it saves you clicks and jumps over the code to understand what are those parameters all about.

In the case of UI widget tree, they play a crucial role in the readability. Consider the same code as above, without named parameters:

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

Meh, right? It’s not only harder to read and understand (you need to keep in your memory what each parameter mean, what’s its type and it’s a huge cognitive burden), but also leaves us with no flexibility in what parameters we really want to pass. For example, you may not want to have `FloatingButton` for you Material App, so you simply don’t pass the `floatingActionButton`. Without named parameters, you’re forced to pass it (as `null`/`nil`, perhaps), or resort to some dirty magic with reflection to figure out what parameters user passed via the constructor.

As Go doesn’t have function overloading or named parameters, that’s going to be a tough task.

## Widgets Tree in Go

### Version 1

The temptation here might be just to replicate Dart’s way of expressing widgets tree, but what we really need is to step back and answer the question – which is the best way to represent this type of data within the constraints of the language?

Let’s take a closer look at the [Scaffold](https://docs.flutter.io/flutter/material/Scaffold-class.html) object, which is a nice helper for building a decently looking modern UI. It has **properties** – appBar, drawer, home, bottomNavigationBar, floatingActionButton – all Widgets, by the way. And we’re creating the object of the type `Scaffold` initializing some of those properties along the way. Well, it’s not that different from any normal object instantiation, is it?

Let’s try the naïve approach:

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

### Version 2

As most of the code will use `flutter` import anyway, it’s fine to import `flutter` into our namespace using the import dot notation:

```dart
import . "github.com/flutter/flutter"
```

Now, instead of writing `flutter.Text` it’ll be just `Text`. It’s usually a bad practice, but we’re working with a framework, and use this import literally on every single line, so that’s a perfect case where it’s a good practice. Another valid use case is a Go tests with [GoConvey](http://goconvey.co) framework, for example. To me, frameworks are the languages on top of other languages, so it’s ok to use dot import with frameworks.

Let’s rewrite our code:

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

A bit cleaner, but those nils… How can we avoid requiring concrete parameters?

### Version 3

Maybe reflection? Some early Go HTTP frameworks used this approach ([martini](https://github.com/go-martini/martini) for example) – you pass whatever you want via parameters, and runtime will figure out if this a known type/parameter. It’s a bad practice from many points of view - it’s unsafe, relatively slow, adds magic – but for the sake of exploration let’s try it:

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

Okay, a bit cleaner and similar to Dart’s original version, but lack of named parameters really hinder readability in such a case with “optional” parameters. Plus, it’s the code that really smells with bad approaches.

### Version 4

Let’s rethink what’s exactly we’re doing when creating new objects and optionally defining their properties? It’s just a normal variable instantiation, so what if we try it in a different way:

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

This approach will work, and while it solves the “named parameters issue”, it really messes up the understanding of widgets tree. First of all, it reversed the order of creating widgets – the deeper the widget, the earlier it should be defined. Second, we lost our indentation-based spatial layout of code, which is a great helper of quickly building a high-level overview of the widgets tree.

By the way, this approach has been used for ages with UI frameworks such as [GTK](https://www.gtk.org) and [Qt](https://www.qt.io). Take a look at the [code example from the documentation](http://doc.qt.io/qt-5/qtwidgets-mainwindows-mainwindow-mainwindow-cpp.html) to the latest Qt 5 framework.

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
