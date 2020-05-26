> * 原文地址：[Widget - State - Context - InheritedWidget](https://www.didierboelens.com/2018/06/widget---state---context---inheritedwidget/)
> * 原文作者：[www.didierboelens.com](https://www.didierboelens.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/widget-state-context-inheritedwidget.md](https://github.com/xitu/gold-miner/blob/master/TODO1/widget-state-context-inheritedwidget.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：[Mirosalva](https://github.com/Mirosalva)、[HearFishle](https://github.com/HearFishle)

# Flutter 核心概念详解： Widget、State、Context 及 InheritedWidget

本文涵盖了 Flutter 应用中有关 Widget、State、Context 及 InheritedWidget 的重要概念。因为 InheritedWidget 是最重要且文档缺乏的部件之一，故需特别关注。

难度：**初学者**

## 前言

Flutter 中的 **Widget**、**State** 及 **Context** 是每个 Flutter 开发者都需要充分理解的最重要的概念之一。

虽然存在大量文档，但并没有一个能够清晰地解释它。

我将用自己的语言来解释这些概念，知道这些可能会让一些纯理论者感到不安，但本文的真正目的是试图说清以下主题：

*   Stateful Widget 和 Stateless Widget 的区别
*   Context 是什么
*   State 是什么并且如何使用它
*   context 与其 state 对象之间的关系
*   InheritedWidget 及在 Widgets 树中传播信息的方式
*   重建的概念

本文同时发布于 [Medium - Flutter Community](https://medium.com/flutter-community/widget-state-buildcontext-inheritedwidget-898d671b7956)。

## 第一部分：概念

### Widget 的概念

在 **Flutter** 中，几乎所有的东西都是 **Widget**。

> 将一个 **Widget** 想象为一个可视化组件（或与应用可视化方面交互的组件）。

当你需要构建与布局直接或间接相关的任何内容时，你正在使用 **Widget**。

### Widget 树的概念

**Widget** 以树结构进行组织。

包含其他 Widget 的 Widget 被称为**父 Widget**（或**Widget 容器**）。包含在**父 Widget** 中的 Widget 被称为**子 Widget**。

让我们用 **Flutter** 自动生成的基础应用来说明这一点。以下是简化代码，仅有 **build** 方法：

```dart
@override
Widget build(BuildContext){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
}
```

如果我们现在观察这个基本示例，我们将获得以下 Widget 树结构（**限制代码中存在的 Widget 列表**）：

![state diagram basic](https://www.didierboelens.com/images/state_basic_tree.png)

### Context 的概念

另外一个重要的概念是 **Context**。

**Context** 仅仅是已创建的所有 Widget 树结构中某个 Widget 的位置引用。

> 简而言之，将 **context** 作为 Widget 树的一部分，其中 context 所对应的 Widget 被添加到此树中。

一个 **context** 仅仅从属于**一个** widget。

如果 widget ‘A’ 拥有子 widget，那么 widget ‘A’ 的 **context** 将成为其直接关联**子 context** 的**父 context**。

读到这里会很明显发现 **context 是链接在一起的**，并且会形成一个 context 树（父子关系）。

如果我们现在尝试在上图中说明 **Context** 的概念，我们得到（**依旧是一个非常简化的视图**）每种颜色代表一个 **context**（**除了 MyApp，它是不同的**）：

![state diagram basic context](https://www.didierboelens.com/images/state_basic_context_tree.png)

> **Context 可见性** (**简短描述**)：
>
> **某些东西** 只能在自己的 context 或在其父 context 中可见。

通过上述描述我们可以将其从子 context 中提取出来，它很容易找到一个 **祖先**（= 父）Widget。

> 一个例子，考虑 Scaffold > Center > Column > Text：context.ancestorWidgetOfExactType(Scaffold) => 通过从 Text 的 context 得到树结构来返回第一个 Scaffold。

从父 context 中，也可以找到 **后代**（= 子）Widget，但不建议这样做（**我们将稍后讨论**）。

### Widget 的类型

Widget 拥有 2 种类型：

#### Stateless Widget

这些可视化组件除了它们自身的配置信息外不依赖于任何其他信息，该信息在其直接父节点**构建时**提供。

换句话说，这些 Widget 一旦创建就不关心任何**变化**。

这样的 Widget 称为 **Stateless Widget**。

这种 Widget 的典型示例可以是 Text、Row、Column 和 Container 等。在构建时，我们只需将一些参数传递给它们。

**参数**可以是装饰、尺寸、甚至其他 widget 中的任何内容。需要强调的是，该配置一旦被创建，在下次构建过程之前都不会改变。

> stateless widget 只有在 loaded/built 时才会绘制一次，这意味着任何事件或用户操作都无法对该 Widget 进行重绘。

##### Stateless Widget 生命周期

以下是与 **Stateless Widget** 相关的典型代码结构。

如下所示，我们可以将一些额外的参数传递给它的构造函数。但请记住，这些参数在后续阶段将**不**改变（变化），并且必须按照**已有状态**使用。

```dart
class MyStatelessWidget extends StatelessWidget {

	MyStatelessWidget({
		Key key,
		this.parameter,
	}): super(key:key);

	final parameter;

	@override
	Widget build(BuildContext context){
		return new ...
	}
}
```

即使有另一个方法可以被重写（**createElement**），后者也几乎不会被重写。唯一**需要**被重写的是 **build** 方法。

这种 Stateless Widget 的生命周期是相当简单的：

*   初始化
*   通过 build() 渲染

#### Stateful Widget

其他一些 Widget 将处理一些在 Widget 生命周期内会发生变化的**内部数据**。因此，此类**数据**会变为**动态**。

该 Widget 所持有的**数据**集在其生命周期内可能会发生变化，这样的数据被称为 **State**。

这些 Widget 被称为 **Stateful Widget**。

此类 Widget 的示例可能是用户可选择的复选框列表，也可以是根据条件禁用的 Button 按钮。

### State 的概念

**State** 定义了 **StatefulWidget** 实例的 “**行为**”。

它包含了用于 **交互 / 干预** Widget 信息：

*   行为
*   布局

> 应用于 **State** 的任何更改都会强制 Widget 进行**重建**。

## State 和 Context 的关系

对于 **Stateful Widget**，**State** 与 **Context** 相关联。并且此关联是**永久性**的，**State** 对象将永远不会改变其 **context**。

即使可以在树结构周围移动 Widget Context，**State** 仍将与该 **context** 相关联。

当 **State** 与 **Context** 关联时，**State** 被视为**已挂载**。

> **重点**：
>
> **State 对象** 与 **context** 相关联，就意味着该 **State 对象**是**不**（直接）访问**另一个 context**！（我们将在稍后讨论该问题）。

* * *

## Stateful Widget 生命周期

既然已经介绍了基本概念，现在是时候更加深入一点了……

以下是与 **Stateful Widget** 相关的典型代码结构。

由于本文的主要目的是用“变量”数据来解释 **State** 的概念，我将故意跳过任何与 Stateful Widget 相关的一些**可重写**方法的解释，这些方法与此没有特别的关系。这些可重写的方法是 **didUpdateWidget、deactivate 和 reassemble**。这些内容将在下一篇文章中讨论。

```dart
class MyStatefulWidget extends StatefulWidget {

	MyStatefulWidget({
		Key key,
		this.parameter,
	}): super(key: key);

	final parameter;

	@override
	_MyStatefulWidgetState createState() => new _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {

	@override
	void initState(){
		super.initState();

		// Additional initialization of the State
	}

	@override
	void didChangeDependencies(){
		super.didChangeDependencies();

		// Additional code
	}

	@override
	void dispose(){
		// Additional disposal code

		super.dispose();
	}

	@override
	Widget build(BuildContext context){
		return new ...
	}
}
```

下图展示了与创建 Stateful Widget 相关的操作/调用序列（**简化版本**）。在图的右侧，你将注意到数据流中 **State** 对象的内部状态。你还将看到此时 context 与 state 已经关联，并且 context 因此变为可用状态（**mounted**）。

![state diagram](https://www.didierboelens.com/images/state_diagram.png)

接下来让我们通过一些额外的细节来解释它：

#### initState()

一旦 State 对象被创建，**initState()** 方法是第一个（构造函数之后）被调用的方法。当你需要执行额外的初始化时，该方法将会被重写。常见的初始化与动画、控制器等相关。如果重写该方法，你应该首先调用 **super.initState()**。

该方法可以得到 **context**，但**无法**真正使用它，因为框架还没有完全将其与 state 关联。

一旦 **initState()** 方法执行完成，State 对象就被初始化并且 context 变为可用。

在该 State 对象的生命周期内将不会再次调用此方法。

#### didChangeDependencies()

**didChangeDependencies()** 方法是第二个被调用的方法。

在这一阶段，由于 **context** 是可用的，所以你可以使用它。

如果你的 Widget 链接到了一个 **InheritedWidget** 并且/或者你需要初始化一些 **listeners**（基于 **context**），通常会重写该方法。

请注意，如果你的 widget 链接到了一个 **InheritedWidget**，在每次重建该 Widget 时都会调用该方法。

如果你重写该方法，你应该首先调用 **super.didChangeDependencies()**。

#### build()

**build(BuildContext context)** 方法在 **didChangeDependencies()**（及 **didUpdateWidget**）之后被调用。

这是你构建你的 widget（可能还有任何子树）的地方。

**每次 State 对象更新**（或当 InheritedWidget 需要通知“**已注册**” widget）时都会调用该方法！！

为了强制重建，你可能需要调用 **setState((){…})** 方法。

#### dispose()

**dispose()** 方法在 widget 被废弃时被调用。

如果你需要执行一些清理操作（比如：listeners），则重写该方法，并在此之后立即调用 **super.dispose()**。

## Stateless 或 Stateful Widget？

这是许多开发者都需要问自己的问题：**我是否需要 Widget 为 Stateless 或 Stateful？**

为了回答这个问题，请问问自己：

> 在我的 widget 生命周期中，是否需要考虑一个将要变更，并且在变更后 widget 将强制**重建**的**变量**？

如果问题的答案是 **yes**，那么你需要一个 **Stateful** Widget，否则，你需要一个 **Stateless** Widget。

一些例子：

*   用于显示复选框列表的 widget。要显示复选框，你需要考虑一系列项目。每个项目都是一个包含标题和状态的对象。如果你点击一个复选框，相应的 item.status 将会切换；

    在这种情况下，你需要使用一个 **Stateful** Widget 来记住项目的状态，以便能够重绘复选框。

*   带有表格的屏幕。该屏幕允许用户填写表单的 Widget 并将表单发送到服务器。

    在这种情况下，**除非你要对表单进行验证，或在提交之前做一些其他的事情**，一个 **Stateless** Widget 可能就足够了。

* * *

## Stateful Widget 由 2 部分组成

还记得 **Stateful** widget 的结构吗？有 2 个部分：

### Widget 定义

```dart
class MyStatefulWidget extends StatefulWidget {
    MyStatefulWidget({
		Key key,
		this.color,
	}): super(key: key);

	final Color color;

	@override
	_MyStatefulWidgetState createState() => new _MyStatefulWidgetState();
}
```

第一部分 “**MyStatefulWidget**” 通常是 Widget 的 **public** 部分。当你需要将其添加到 widget 树时，可以实例化它。该部分在 Widget 生命周期内不会发生变化，但可能接受与其相关的 **State** 实例化时使用的参数。

> 请注意，在 Widget 第一部分定义的任何变量**通常**在其生命周期内**不会**发生变化。

### Widget State 定义

```dart
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
    ...
	@override
	Widget build(BuildContext context){
	    ...
	}
}
```

第二部分 “**_MyStatefulWidgetStat**” 管理 Widget 生命周期中的**变化**，并强制每次应用修改时重建该 Widget 实例。名称开头的 ‘**_**’ 字符使得该类对 .dart 文件是**私有的**。

如果你需要在 .dart 文件之外引用此类，请不要使用 ‘**_**’ 前缀。

**`_MyStatefulWidgetState`** 类可以通过使用 **widget.{变量名称}** 来访问被存储在 **MyStatefulWidget** 中的任何变量。在该示例中为：**widget.color**。

* * *

## Widget 唯一标识 - Key

在 Fultter 中，每一个 Widget 都是被唯一标识的。这个唯一标识**在 build/rendering 阶段**由框架定义。

该唯一标识对应于可选的 **Key** 参数。如果省略该参数，Flutter 将会为你生成一个。

在某些情况下，你可能需要强制使用此 **key**，以便可以通过其 key 访问 widget。

为此，你可以使用以下方法中的任何一个：**GlobalKey**、**LocalKey**、**UniqueKey** 或 **ObjectKey**。

**GlobalKey** 确保生成的 key 在整个应用中是唯一的。

强制 Widget 使用唯一标识：

```dart
GlobalKey myKey = new GlobalKey();
...
@override
Widget build(BuildContext context){
    return new MyWidget(
        key: myKey
    );
}
```

* * *

## 第二部分：如何访问 State？

如前所述，**State** 被链接到 **一个 Context**，并且一个 **Context** 被链接到一个 Widget **实例**。

### 1. Widget 自身

从理论上讲，唯一能够访问 **State** 的是 **Widget State 自身**。

在此中情况下不存在任何困难。Widget State 类可以访问任何内部变量。

### 2. 直接子 Widget

有时，父 widget 可能需要访问其直接子节点的 State 才能执行特定任务。

在这种情况下，要访问这些直接子节点的 **State**，你需要**了解**它们。

呼叫某人的最简单方法是通过**名字**。在 Flutter 中，每个 Widget 都有一个唯一的标识，由框架在 **build/rendering 时**确定。如前所示，你可以使用 **key** 参数为 Widget 强制指定一个标识。

```dart
...
GlobalKey<MyStatefulWidgetState> myWidgetStateKey = new GlobalKey<MyStatefulWidgetState>();
...
@override
Widget build(BuildContext context){
    return new MyStatefulWidget(
        key: myWidgetStateKey,
        color: Colors.blue,
    );
}
```

一经确定，**父** Widget 可以通过以下形式访问其子节点的 **State**：

> myWidgetStateKey.currentState

让我们考虑当用户点击按钮时显示 SnackBar 这样一个基本示例。由于 SnackBar 是 Scaffold 的子 Widget，它不能被 Scaffold 内部任何其他子节点直接访问（**还记得 context 的概念以及其层次/树结构吗？**）。因此，访问它的唯一方法是通过 **ScaffoldState**，它暴露出一个公共方法来显示 SnackBar。

```dart
class _MyScreenState extends State<MyScreen> {
    /// the unique identity of the Scaffold
    final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context){
        return new Scaffold(
            key: _scaffoldKey,
            appBar: new AppBar(
                title: new Text('My Screen'),
            ),
            body: new Center(
                new RaiseButton(
                    child: new Text('Hit me'),
                    onPressed: (){
                        _scaffoldKey.currentState.showSnackBar(
                            new SnackBar(
                                content: new Text('This is the Snackbar...'),
                            )
                        );
                    }
                ),
            ),
        );
    }
}
```

### 3. 祖先 Widget

假设你有一个属于另一个 Widget 的子树的 Widget，如下图所示。

![state child get state](https://www.didierboelens.com/images/state_child_get_state.png)

为了实现这一目标，需要满足 3 个条件：

#### 1. 『**带有 State 的 Widget**』（红色）需要暴露其 **State**

为了**暴露** 其 **State**，Widget 需要在创建时记录它，如下所示：

```dart
class MyExposingWidget extends StatefulWidget {

   MyExposingWidgetState myState;

   @override
   MyExposingWidgetState createState(){
      myState = new MyExposingWidgetState();
      return myState;
   }
}
```

#### 2. “**Widget State**” 需要暴露一些 getter/setter 方法

为了让“**其他类**” 设置/获取 State 中的属性，**Widget State** 需要通过以下方式授权访问：

*   公共属性（不推荐）
*   getter / setter

例子：

```dart
class MyExposingWidgetState extends State<MyExposingWidget>{
   Color _color;

   Color get color => _color;
   ...
}
```

#### 3. “**对获取 State 感兴趣的 Widget**”（蓝色）需要得到 **State** 的引用

```dart
class MyChildWidget extends StatelessWidget {
   @override
   Widget build(BuildContext context){
      final MyExposingWidget widget = context.ancestorWidgetOfExactType(MyExposingWidget);
      final MyExposingWidgetState state = widget?.myState;

      return new Container(
         color: state == null ? Colors.blue : state.color,
      );
   }
}
```

这个解决方案很容易实现，但子 widget 如何知道它何时需要重建呢？

通过此方案，它**无能为力**。它必须等到重建发生后才能刷新其内容，此方法不是特别方便。

下一节将讨论 **Inherited Widget** 的概念，它可以解决这个问题。

* * *

## InheritedWidget

简而言之，**InheritedWidget** 允许在 **widget** 树中有效地向下传播（和共享）信息。

**InheritedWidget** 是一个特殊的 Widget，它将作为另一个子树的父节点放置在 Widget 树中。该子树的所有 widget 都必须能够与该 **InheritedWidget** 暴露的数据进行**交互**。

### 基础

为了解释它，让我们思考以下代码片段：

```dart
class MyInheritedWidget extends InheritedWidget {
   MyInheritedWidget({
      Key key,
      @required Widget child,
      this.data,
   }): super(key: key, child: child);

   final data;

   static MyInheritedWidget of(BuildContext context) {
      return context.inheritFromWidgetOfExactType(MyInheritedWidget);
   }

   @override
   bool updateShouldNotify(MyInheritedWidget oldWidget) => data != oldWidget.data;
}
```

以上代码定义了一个名为 “**MyInheritedWidget**” 的 Widget，目的在于为子树中的所有 widget 提供某些『**共享**』数据。

如前所述，为了能够传播/共享某些数据，需要将 **InheritedWidget** 放置在 widget 树的顶部，这解释了传递给 InheritedWidget 基础构造函数的 **@required Widget child** 参数。

**static MyInheritedWidget of(BuildContext context)** 方法允许所有子 widget 通过包含的 context 获得最近的 **MyInheritedWidget** 实例（参见后面的内容）。

最后重写 **updateShouldNotify** 方法用来告诉 **InheritedWidget** 如果对**数据**进行了修改，是否必须将通知传递给所有子 widget（已注册/已订阅）（请参考下文）。

因此，我们需要将它放在树节点级别，如下所示：

```dart
class MyParentWidget... {
   ...
   @override
   Widget build(BuildContext context){
      return new MyInheritedWidget(
         data: counter,
         child: new Row(
            children: <Widget>[
               ...
            ],
         ),
      );
   }
}
```

### 子节点如何访问 InheritedWidget 的数据？

在构建子节点时，后者将获得 InheritedWidget 的引用，如下所示：

```dart
class MyChildWidget... {
   ...

   @override
   Widget build(BuildContext context){
      final MyInheritedWidget inheritedWidget = MyInheritedWidget.of(context);

      ///
      /// 此刻，该 widget 可使用 MyInheritedWidget 暴露的数据
      /// 通过调用：inheritedWidget.data
      ///
      return new Container(
         color: inheritedWidget.data.color,
      );
   }
}
```

### 如何在 Widget 之间进行交互？

请思考下图中所显示的 widget 树结构。

![inheritedwidget tree](https://www.didierboelens.com/images/inherited_widget_tree_1.png)

为了说明交互方式，我们做以下假设：

*   ‘Widget A’ 是一个将项目添加到购物车里的按钮；
*   ‘Widget B’ 是一个显示购物车中商品数量的文本；
*   ‘Widget C’ 位于 Widget B 旁边，是一个内置任意文本的文本；
*   我们希望 ‘Widget A’ 在按下时 ‘Widget B’ 能够自动在购物车中显示正确数量的项目，但我们不希望重建 ‘Widget C’

针对该场景，**InheritedWidget** 是唯一一个合适的 Widget 选项！

#### 示例代码

我们先写下代码然后再进行解释：

```dart
class Item {
   String reference;

   Item(this.reference);
}

class _MyInherited extends InheritedWidget {
  _MyInherited({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final MyInheritedWidgetState data;

  @override
  bool updateShouldNotify(_MyInherited oldWidget) {
    return true;
  }
}

class MyInheritedWidget extends StatefulWidget {
  MyInheritedWidget({
    Key key,
    this.child,
  }): super(key: key);

  final Widget child;

  @override
  MyInheritedWidgetState createState() => new MyInheritedWidgetState();

  static MyInheritedWidgetState of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited).data;
  }
}

class MyInheritedWidgetState extends State<MyInheritedWidget>{
  /// List of Items
  List<Item> _items = <Item>[];

  /// Getter (number of items)
  int get itemsCount => _items.length;

  /// Helper method to add an Item
  void addItem(String reference){
    setState((){
      _items.add(new Item(reference));
    });
  }

  @override
  Widget build(BuildContext context){
    return new _MyInherited(
      data: this,
      child: widget.child,
    );
  }
}

class MyTree extends StatefulWidget {
  @override
  _MyTreeState createState() => new _MyTreeState();
}

class _MyTreeState extends State<MyTree> {
  @override
  Widget build(BuildContext context) {
    return new MyInheritedWidget(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Title'),
        ),
        body: new Column(
          children: <Widget>[
            new WidgetA(),
            new Container(
              child: new Row(
                children: <Widget>[
                  new Icon(Icons.shopping_cart),
                  new WidgetB(),
                  new WidgetC(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    return new Container(
      child: new RaisedButton(
        child: new Text('Add Item'),
        onPressed: () {
          state.addItem('new item');
        },
      ),
    );
  }
}

class WidgetB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context);
    return new Text('${state.itemsCount}');
  }
}

class WidgetC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Text('I am Widget C');
  }
}
```

### 说明

在这个非常基本的例子中：

*   **`_MyInherited`** 是一个 **InheritedWidget**，每次我们通过 ‘Widget A’ 按钮添加一个项目时它都会重新创建
*   **MyInheritedWidget** 是一个 **State** 包含了项目列表的 Widget。可以通过 **static MyInheritedWidgetState of(BuildContext context)** 访问该 **State**
*   **MyInheritedWidgetState** 暴露了一个获取 **itemsCount** 的 getter 方法 和一个 **addItem** 方法，以便它们可以被 widget 使用，这是**子** widget 树的一部分
*   每次我们将项目添加到 State 时，**MyInheritedWidgetState** 都会重建
*   **MyTree** 类仅构建了一个 widget 树，并将 **MyInheritedWidget** 作为树的根节点
*   **WidgetA** 是一个简单的 **RaisedButton**，当按下它时，它将从**最近**的 **MyInheritedWidget** 实例中调用 **addItem** 方法
*   **WidgetB** 是一个简单的 **Text**，用来显示**最近** 级别 **MyInheritedWidget** 的项目数

**这一切是如何运作的呢？**

#### 为后续的通知注册 Widget

当一个子 Widget 调用 **MyInheritedWidget.of(context)** 时，它传递自身的 **context** 并调用 MyInheritedWidget 的以下方法。

```dart
static MyInheritedWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited).data;
}
```

在内部，除了简单地返回 **MyInheritedWidgetState** 实例外，它还订阅**消费者** widget 以便用于通知更改。

在幕后，对这个静态方法的简单调用实际上做了 2 件事：

*   **消费者** widget 被自动添加到**订阅者**列表中，从而当对 **InheritedWidget**（这里是 **`_MyInherited`**）应用修改时，该 widget 能够**重建**
*   **`_MyInherited`** widget（又名 **MyInheritedWidgetState**）中引用的数据将返回给**消费者**

#### 流程

由于 ‘Widget A’ 和 ‘Widget B’ 都使用 **InheritedWidget** 进行了订阅，因此如果对 **`_MyInherited`** 应用了修改，那么当点击 Widget A 的 **RaisedButton** 时，操作流程如下（简化版本）：

1.  调用 **MyInheritedWidgetState** 的 **addItem** 方法
2.  **_MyInheritedWidgetState.addItem** 方法将新项目添加到列表中
3.  调用 **setState()** 以重建 **MyInheritedWidget**
4.  通过列表中的新内容创建 **`_MyInherited`** 新的实例
5.  **`_MyInherited`** 记录通过参数（**data**）传递的新 **State**
6.  作为 **InheritedWidget**，它会检查是否需要**通知消费者**（答案是 true）
7.  遍历整个**消费者**列表（这里是 Widget A 和 Widget B）并请求它们重建
8.  由于 Wiget C 不是**消费者**，因此不会重建。

至此它能够有效工作！

然而，Widget A 和 Widget B 都被重建了，但由于 Wiget A 没有任何改变，因此它没有重建的必要。那么应该如何防止此种情况发生呢？

#### 在继续访问 Inherited Widget 的同时阻止某些 Widget 重建

Widget A 同时被重建的原因是由于它访问 **MyInheritedWidgetState** 的方式。

如前所述，调用 **context.inheritFromWidgetOfExactType()** 方法实际上会自动将 Widget 订阅到**消费者**列表中。

避免自动订阅，同时仍然允许 Widget A 访问 **MyInheritedWidgetState** 的解决方案是通过以下方式改造 **MyInheritedWidget** 的静态方法：

```dart
static MyInheritedWidgetState of([BuildContext context, bool rebuild = true]){
    return (rebuild ? context.inheritFromWidgetOfExactType(_MyInherited) as _MyInherited
                    : context.ancestorWidgetOfExactType(_MyInherited) as _MyInherited).data;
}
```

通过添加一个 boolean 类型的额外参数……

*   如果 **rebuild** 参数为 true（默认值），我们使用普通方法（并且将 Widget 添加到订阅者列表中）
*   如果 **rebuild** 参数为 false，我们仍然可以访问数据，**但**不使用 **InheritedWidget** 的**内部实现**

因此，要完成此方案，我们还需要稍微修改一下 Widget A 的代码，如下所示（我们添加值为 false 的额外参数）：

```dart
class WidgetA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyInheritedWidgetState state = MyInheritedWidget.of(context, false);
    return new Container(
      child: new RaisedButton(
        child: new Text('Add Item'),
        onPressed: () {
          state.addItem('new item');
        },
      ),
    );
  }
}
```

就是这样，当我们按下 Widget A 时，它不会再重建了。

## Routes、Dialogs 的一些特别说明……

> Routes、Dialogs 的 context 与 **Application** 绑定。
>
> 这意味着即使在屏幕 A 内部你要求显示另一个屏幕 B（例如，在当前的屏幕上），也**无法轻松**地从两个屏幕中的任何一个关联它们自己的 context。
>
> 屏幕 B 想要了解屏幕 A 的 context 的唯一方法是通过屏幕 A 得到它并将其作为参数传递给 Navigator.of(context).push(….)

## 有趣的链接

*   [Maksim Ryzhikov](https://medium.com/@maksimrv/reactive-app-state-in-flutter-73f829bcf6a7)
*   [Chema Molins](https://medium.com/@chemamolins/is-flutters-inheritedwidget-a-good-fit-to-hold-app-state-2ec5b33d023e)
*   [官方文档](https://docs.flutter.io/flutter/widgets/InheritedWidget-class.html)
*   [Google I/O 2018 视频](https://www.youtube.com/watch?reload=9&time_continue=7&v=RS36gBEp8OI)
*   [Scoped_Model](https://github.com/brianegan/scoped_model)

## 结论

关于这些主题还有很多话要说……，特别是在 **InheritedWidget** 上。

在下一篇文章中我将介绍 **Notifiers / Listeners** 的概念，它们使用 **State** 和数据传递的方式上同样非常有趣。

所以，请保持关注和快乐编码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
