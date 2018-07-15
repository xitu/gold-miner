> * 原文地址：[Making a Todo App with Flutter](https://medium.com/the-web-tub/making-a-todo-app-with-flutter-5c63dab88190)
> * 原文作者：[Gearóid M](https://medium.com/@asialgearoid?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-a-todo-app-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-a-todo-app-with-flutter.md)
> * 译者：DateBro[https://github.com/DateBro]
> * 校对者：

# 用 Flutter 写一个待办事项应用

![](https://cdn-images-1.medium.com/max/1000/1*517hQ_LDC3d4F1wWfRQr5g.png)

[Flutter](https://flutter.io) 是 Google 对 React Native 的回应，它允许开发人员为 Android 和 iOS 创建原生应用。与用 JSX 编写的 React Native 不同，Flutter 应用程序是用 Google 的 [Dart](https://www.dartlang.org/) 语言编写的.

Flutter 仍处于技术测试阶段，但它的工具非常稳定，并提供了流畅的开发体验。

在这篇文章中，我将讲解如何使用 Flutter 创建一个简单的待办事项应用程序。

### 安装相关工具

> 这些说明是为 MacOS 和 Linux 编写的。Windows需要一些额外的准备，因此请按照[Flutter Windows 指南](https://flutter.io/setup-windows/) 进行操作，然后转到下一步，**创建应用程序**。

首先，下载合适平台的 [Flutter SDK](https://flutter.io/sdk-archive/) 。对于这个应用程序，我们将在主目录中创建一个名为 `dev` 的目录，并在那里解压 Flutter SDK。

```
mkdir ~/dev
cd ~/dev
unzip ~/Downloads/flutter_macos_v0.3.2-beta.zip
```

现在我们可以通过 `~/dev/flutter/bin/flutter` 命令在命令行上运行 Flutter。输入的命令有点不优雅，所以让我们将这个目录添加到 `$ PATH` 中来缩短命令。在 `〜/ .bashrc` 文件的末尾添加这一行.

```
export PATH=~/dev/flutter/bin:$PATH
```

然后运行 `source~ / .bashrc` 以确保此更改生效。现在你可以直接从命令行运行 `flutter` 命令了。设置完成后，我们需要检查以确保我们已经安装了应用程序开发所需的所有其他内容，例如 Android Studio ，Xcode（仅限 MacOS ）和其他依赖。幸运的是，Flutter 附带了一个工具，可以很容易地检查这个。只需要运行：

```
flutter doctor
```

这将告诉你需要安装的具体内容，确保 Flutter 正确运行。按照 flutter doctor 的说明，确保所有设置都正确，然后再继续下一步。

### 创建一个应用程序

我们将创建我们的应用程序并在 Android 上进行测试，因为这在所有操作系统上都可以完成，所以这些步骤对于 iOS 都是一样的。

Flutter 为不少 IDE 提供插件，包括 Android Studio 和 Visual Studio Code。但是，对于我们简单的应用程序来说，我们完全可以使用命令行和一个简单的文本编辑器完成所有操作。首先，让我们创建我们的应用程序，我们将其称为 “flutter_todo” 。

```
flutter create flutter_todo
```

Flutter 中这个命令可以创建一个简单的 “Hello World” 风格的应用程序。我们可以在 Android 模拟器中立即测试它。打开 Android Studio，Flutter Doctor 会帮助你进行设置。这里我们要创建一个模拟器，但Android Studio 要求我们先创建一个项目。所以，让我们使用新创建的Flutter项目。选择 `导入项目（Gradle，Eclipse ADT等）`，然后选择文件夹 `〜/ dev / flutter_todo / android`。完成导入项目后，检查控制台中是否有错误。如果有，使用 Android Studio 修复它们。

现在，我们可以通过 `Tools> Android> AVD Manager` 来创建模拟器。单击“创建虚拟设备”，选择 _Pixel_，然后点击所有默认值，直到创建完毕。现在，你可以在列表中看到新设备 —— 双击启动它。模拟器运行后，就可以在上面运行我们的 Flutter 应用程序了。

```
cd flutter_todo
flutter run
```

这个应用程序比普通的 Hello World 应用程序更有趣，并且包含一些交互性。点击右下角的按钮屏幕中间的计数器数值会增大。

![](https://cdn-images-1.medium.com/max/800/1*G9qdgpLvq2o-rriUp0FlXw.png)

Flutter 的 “Hello World” 应用程序

#### 热重载

Flutter 有一个非常有用的热重载功能，就像 React Native 一样。这意味着每次改代码时都不需要重新构建和重新运行应用程序。我们来看看它是如何工作的。

比如我们想要更改 Hello World 应用程序标题栏中的文本。所有代码都位于 `lib / main.dart` 中。在这个文件中，找到下面这行：

```
home: new MyHomePage(title: 'Flutter Demo Home Page'),
```

然后替换为：

```
home: new MyHomePage(title: 'Basic Flutter App'),
```

保存文件，然后返回运行 `flutter run` 的命令行。你需要做的就是输入`r`，这会启动热重载过程。你会注意到在模拟器中，标题已经更改。不仅如此，如果你之前点击过按钮，你会发现到计数器并没有重置成 0。这个 _stateful hot reload_ 是使开发具有了一个有用功能。你可以随时调整代码并进行测试，但不需要在每次进行更改后强制返回应用程序的初始界面。

![](https://cdn-images-1.medium.com/max/800/1*Sq-H7nOab6_dlqOtk9fQmg.png)

你可以看到一个标题已更改的 Flutter 的 “Hello World” 应用程序。

### Flutter 基础

既然我们知道了如何运行 Flutter 应用程序，那么就该开始编写自己的应用程序了。我们选择经典的待办事项应用程序作为例子。如上所述，我们将使用 Dart 。它肯定不是最著名的语言，但如果你之前使用过 Javascript（特别是ES2015 +），C++ 或 Java，那你将会觉得非常熟悉。

#### Material Design

Flutter 附带一个软件包，可以帮助快速制作 [Material](https://material.io/) 风格的 App。它提供了一种创建带标题栏和正文的屏幕的简单方法。让我们首先设置一下待办事项应用程序，使它有一个我们应用程序名称的标题栏。

删除 `lib / main.dart` 中现有的所有代码，并添加以下内容：

```
// 导入 MaterialApp 和其他组件，我们可以使用它们来快速创建 Material 应用程序
import 'package:flutter/material.dart';

// 用 Dart 编写的代码从主函数开始执行，runApp 是 Flutter 的一部分，而且需要组件作为我们 app
// 的容器。在 Flutter 中，
// 万物皆组件。
void main() => runApp(new TodoApp());

// Flutter 中，万物皆组件，甚至是整个 App 本身
class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Todo List')
        )
      ),
    );
  }
}
```

#### 组件

这一小段代码显示了 Flutter 中一个重要的概念 —— 万物皆组件。我们的整个应用程序是一个组件，其中包含 `MaterialApp` 组件。`Scaffold` 是一个组件，它可以帮助我们快速创建合适的 Material 布局，而不用担心手动设置样式。`AppBar` 是一个接受标题的组件，它会在屏幕顶部创建一个栏，这在应用程序中很常见。在 Android 上，它会将文本左侧对齐，而在 iOS 上，它会将文本居中。

由于我们对应用程序进行了比较大的改动，所以这次热重载将无法正常工作。这次我们需要完全重启应用程序。在命令行中，输入 `R` —— 注意它是大写的，与热重载不同。你将看到一个带标题栏的简单应用程序。

![](https://cdn-images-1.medium.com/max/800/1*ebJQyqOKcyHOKFObqTXN8A.png)

Android（Pixel 2）与 iOS（iPhone X）上标题栏样式的区别

### Stateless Widgets 和 Stateful Widgets

为了使我们的应用看起来更像一个待办事项应用程序，我们应当展示一些任务。你可能已经注意到我们上面的简单应用程序是一个 `StatelessWidget`。 这意味着无法动态修改。对于我们的待办事项应用程序来说，这并不好，因为待办事项会一直添加和删除。但是，`StatelessWidget` 可以生成动态的子项，它们是`StatefulWidget`。 让我们从整个 app 容器开始分析我们的有状态功能（待办事项列表容器）。

要创建一个 stateful widget，我们需要两个类 —— 一个用于组件本身，另一个用于创建状态。这个设置允使我们可以轻松保存状态，并能够使用热重载等功能。

> **为什么一个 stateful widget 需要两个类？**
> 想象一下，我们有一个待办事项列表组件，里面有五个待办事项。当我们往列表中添加另一个事项时，Flutter 会以不同的方式更新屏幕。你可能希望它只是将这一项添加到现有组件中。实际上，它创建了一个全新的组件，并把它同旧的组件进行比较，以确定在屏幕上进行哪些更改。

> 由于我们在每次更改时都会创建一个新窗口组件，所以我们无法在窗口组件中存储任何状态，因为它会在下一次更改时丢失。这就是为什么我们需要一个单独的 State 类。

下面的代码显示了我们新的有状态应用。它在功能上与我们之前的代码相同，但现在可以轻松更改待办事项列表的内容了。用下面的代码替换 `lib / main.dart` 的所有内容，并用 `R` 完全重启。

```
// 导入 MaterialApp 和其他组件，我们可以使用它们来快速创建 Material 应用程序
import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new TodoList()
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo List')
      )
    );
  }
}
```

### 修改状态

现在我们的应用已准备好变得有状态化，我们希望能够添加待办事项。首先，我们要添加一个浮动操作按钮（FAB），它可以添加一个自动生成的任务。一会儿我们会允许用户输入自己的任务。我们所有的更改都在 `TodoListState` 中。

```
class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  // 每按一次 + 按钮，都会调用这个方法
  void _addTodoItem() {
    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    setState(() {
      int index = _todoItems.length;
      _todoItems.add('Item ' + index.toString());
    });
  }

  // 构建整个待办事项列表
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder 将被自动调用，因为列表需要多次填充其可用空间
        // 而这很可能超过我们拥有的待办事项数量。
        // 所以，我们需要检查索引是否正确。
        if(index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index]);
        }
      },
    );
  }

  // 构建一个待办事项
  Widget _buildTodoItem(String todoText) {
    return new ListTile(
      title: new Text(todoText)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Todo List')
      ),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addTodoItem,
        tooltip: 'Add task',
        child: new Icon(Icons.add)
      ),
    );
  }
}
```

让我们仔细看看如何添加一个新的待办事项：

*   用户点击 `+` 按钮，回调 `onPressed` 函数，从而触发 `_addTodoItem` 函数
*   `addTodoItem` 向 `_todoItems` 数组中添加一个新的字符串
*   `_addTodoItem` 中的所有内容都会被包含在 `setState` 调用中，这个调用会通知应用程序待办事项列表已更新
*   `TodoList.createState` 会在待办事项列表更新时被触发
*   这会调用 `new TodoListState()`，它的构造函数是 `build`，它会构建一个全新的widget  _with the updated list of todo items_
*   该应用程序获取此新窗口组件，将其与前一个窗口组件进行比较，并添加新项目而不更改其他项目

![](https://cdn-images-1.medium.com/max/800/1*bV3Viw7sWVLDhbaKasHpZA.png)

这个应用程序的第二个界面，可以允许用户添加任务

### 用户交互

如果用户只能添加自动生成的项目，那么这个应用程序就不是很有用。让我们改变我们的 `+` 按钮的工作方式，让用户能够指定他们自己的任务。我们希望它打开第二个界面，里面有一个简单的文本框，用户可以在里面输入自己的任务。

#### 添加待办事项

Flutter 可以非常简单地使用 `MaterialPageRoute` 组件添加第二个界面。这需要一个 `builder` 函数作为参数。这将返回一个“Scaffold”，你可以从我们现有的界面中认出它。因此，创建第二个界面的布局将和第一个界面相同。

创建页面后，我们需要告诉应用程序如何使用它，并且它应该在另一个界面的顶部触发动画。Flutter 为我们提供了 `Navigator` 来完成这项工作，它使用了在移动应用程序中很常见的 _navigation stack_ 概念。要添加新屏幕，我们把他 _push_ 到导航堆栈。要删除它，我们就 _pop_ 它。我们会创建一个名为 `_pushAddTodoScreen` 的新函数，它将处理所有这些任务。然后我们可以修改 `floatingActionButton` 的 `onPressed` 方法来调用这个函数。

用下面的代码替换现有的 `_addTodoItem` 和 `build` 函数，并在它们旁边添加新的 `_pushAddTodoScreen` 函数。按 `R` 触发完全重启，以确保删除上次自动生成的任务。单击 `+` 按钮并添加任务，然后按键盘上的 Enter 键。屏幕将会关闭，任务会出现在列表中。

```
// 添加待办事项现在接受一个字符串，而不是自动生成
void _addTodoItem(String task) {
  // 仅在用户实际输入内容时添加任务
  if(task.length > 0) {
    setState(() => _todoItems.add(task));
  }
}

Widget build(BuildContext context) {
  return new Scaffold(
    appBar: new AppBar(
      title: new Text('Todo List')
    ),
    body: _buildTodoList(),
    floatingActionButton: new FloatingActionButton(
      onPressed: _pushAddTodoScreen, // pressing this button now opens the new screen
      tooltip: 'Add task',
      child: new Icon(Icons.add)
    ),
  );
}

void _pushAddTodoScreen() {
  // 将此页面推入任务栈
  Navigator.of(context).push(
    // MaterialPageRoute 会自动为屏幕条目设置动画
    // 并添加后退按钮以关闭它
    new MaterialPageRoute(
      builder: (context) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Add a new task')
          ),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
              hintText: 'Enter something to do...',
              contentPadding: const EdgeInsets.all(16.0)
            ),
          )
        );
      }
    )
  );
}
```

#### 删除待办事项

用户完成任务后，需要一种方法将其标记为已完成并从列表中删除。为了简单起见，我们要在用户点击任务时显示一个对话框，询问他们是否要将事项标记为完成。

![](https://cdn-images-1.medium.com/max/800/1*rw1otrHN232dzY9wJCe2EA.png)

一个要求用户确认其任务完成与否的对话框

我们将创建两个新函数来实现它，`_removeTodoItem` 和 `_promptRemoveTodoItem`。`_buildTodoItem` 也将被修改来处理用户的点击交互。看看下面的新代码，看看你能否明白它的工作原理。后面我会详细介绍。

```
// 与 _addTodoItem 非常类似，它会修改待办事项的字符串数组，
// 并通过使用 setState 通知应用程序状态已更改
void _removeTodoItem(int index) {
  setState(() => _todoItems.removeAt(index));
}

// 显示警告对话框，询问用户任务是否已完成
void _promptRemoveTodoItem(int index) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text('Mark "${_todoItems[index]}" as done?'),
        actions: <Widget>[
          new FlatButton(
            child: new Text('CANCEL'),
            onPressed: () => Navigator.of(context).pop()
          ),
          new FlatButton(
            child: new Text('MARK AS DONE'),
            onPressed: () {
              _removeTodoItem(index);
              Navigator.of(context).pop();
            }
          )
        ]
      );
    }
  );
}

Widget _buildTodoList() {
  return new ListView.builder(
    itemBuilder: (context, index) {
      if(index < _todoItems.length) {
        return _buildTodoItem(_todoItems[index], index);
      }
    },
  );
}

Widget _buildTodoItem(String todoText, int index) {
  return new ListTile(
    title: new Text(todoText),
    onTap: () => _promptRemoveTodoItem(index)
  );
}
```

首先，我们需要从列表中删除任务的功能，这可以用 `_removeTodoItem` 函数来处理。最佳是通过 `_todoItems` 数组中的索引来引用我们要删除的项目。如果有多个具有相同名称的任务，按名称引用会出现问题。一旦我们得到了项目的索引，使用Dart的 `removeAt` 函数将其从数组中删除就很简单了。请记住，我们需要将它包装在 `setState` 中，以便在删除项后重新呈现列表。

当用户点击它时，不应该立即删除项目，而应该首先以更加 user-friendly 的方式提示他们。`_promptRemoveTodoItem` 函数使用 Flutter 的 `AlertDialog` 组件来执行这个操作。这个构造函数和我们之前看到的类似，比如 `Scaffold`。它只接受文本标题和按钮数组。按钮敲击的处理由 `onPressed` 完成，如果按下正确的按钮，就调用 `_removeTodoItem` 函数处理。

最后，我们在 `_buildTodoItem` 中为每个列表项添加一个 `onTap` 处理程序，它会显示上面的提示。我们需要这个处理程序的 todo 项的索引，所以我们还必须修改 `_buildTodoList` 以在调用 `_buildTodoItem` 时传递项的索引。Flutter 会自动添加 Material 风格的 tap 动画，对用户来说体验不错。

### 结果

就像接下来的视频演示的一样，最终的 App 允许用户添加和删除待办事项。如果你想使用的话，最终生成的 `main.dart` 文件可以在 [GitHub](https://gist.github.com/asialgearoid/227883a08bfd2cc45939758a064dd2ff) 上找到。

![](https://cdn-images-1.medium.com/max/800/1*mqN9VlClBMRDCZ1RPhQLCw.gif)

应用程序最终形态

如果您希望继续使用它，可以在应用程序中改进一些内容。比如，由于 Flutter 的保存方式，用户的待办事项在应用程序启动间隙保存，但这种保持用户数据的方法并不可靠。不过，用户的待办事项可以[使用  shared_preferences](https://flutter.io/cookbook/persistence/key-value/)安全地保存在设备上。

想要进一步改进应用程序，你可以 [更改主题](https://flutter.io/cookbook/design/themes/)，甚至为用户的待办事项添加类别。

### 继续了解 Flutter

在这篇博文中，我的目的是向大家简要介绍一下 Flutter 的潜力。如果你有兴趣了解有关 Flutter 的更多信息，[Flutter 开发者文档](https://flutter.io/docs/) 非常全面、有用，最关键的是上面有很多示例。

尽管 Flutter 仍处于测试阶段（写作时为 v0.3.2），但其生态已非常成熟。你不会发现自己找不到一些重要功能或文档。Google Adwords 等主要应用已在生产中使用 Flutter，因此如果你开始开发新应用，Flutter 值得研究一下。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
