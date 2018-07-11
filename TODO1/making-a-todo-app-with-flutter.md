> * 原文地址：[Making a Todo App with Flutter](https://medium.com/the-web-tub/making-a-todo-app-with-flutter-5c63dab88190)
> * 原文作者：[Gearóid M](https://medium.com/@asialgearoid?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/making-a-todo-app-with-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/making-a-todo-app-with-flutter.md)
> * 译者：
> * 校对者：

# Making a Todo App with Flutter

![](https://cdn-images-1.medium.com/max/1000/1*517hQ_LDC3d4F1wWfRQr5g.png)

[Flutter](https://flutter.io) is Google’s answer to React Native, allowing developers to create native apps for both Android and iOS. Unlike React Native, which is written in JSX, Flutter apps are written in Google’s [Dart language](https://www.dartlang.org/).

Flutter is still in technically in beta, but its tools are quite stable, and provide a smooth development experience.

In this post I’ll explain how to create a simple todo app using Flutter.

### Install the tools

> These instructions are written for MacOS and Linux. Windows requires some extra prerequisites, so follow the [Flutter Windows guide](https://flutter.io/setup-windows/), and then move on to the next section, **Create an app**.

First, download the [Flutter SDK](https://flutter.io/sdk-archive/) for your platform. For this app, we will create a directory called `dev` in our home directory, and unzip the Flutter SDK there.

```
mkdir ~/dev
cd ~/dev
unzip ~/Downloads/flutter_macos_v0.3.2-beta.zip
```

Now we can run Flutter on the command line by running `~/dev/flutter/bin/flutter`. That's a bit awkward to type, so let's add this directory to our `$PATH` to make the command shorter. Add this line at the end of your `~/.bashrc` file.

```
export PATH=~/dev/flutter/bin:$PATH
```

Then run `source ~/.bashrc` to ensure that this change takes effect. Now you can run `flutter` straight from the command line. Once this is set up, we need to check to ensure that we have installed everything else we need for app development, such as Android Studio, Xcode (only on MacOS), and other dependencies. Luckily, Flutter comes with a tool that makes it really easy to check this. Just run:

```
flutter doctor
```

This will tell you exactly what needs to be installed so that Flutter will run correctly. Follow the doctor’s instructions, and make sure that everything is set up correctly before moving on to the next step.

### Create an app

We will create our app and test it on Android since this can be done on all operating systems, but all these steps will work just the same for iOS.

Flutter offers plugins for several IDEs, including Android Studio and Visual Studio Code. However, for our basic app, we can do everything using the command line and a simple text editor. First, let’s create our app, which we will call `flutter_todo`.

```
flutter create flutter_todo
```

Flutter creates a basic “Hello World”-style app with this command. We can test this right away in an Android emulator. Open up Android Studio, which Flutter Doctor will have helped you set up. Here we want to create an emulator, but Android Studio requires us to have a project first. So, let’s use our newly created Flutter project. Choose `Import project (Gradle, Eclipse ADT, etc.)`, and then choose the folder `~/dev/flutter_todo/android`. Once it finishes importing your project, check if there are any errors in the console. If there are, let Android Studio fix them.

Now, we can create our emulator by opening `Tools > Android > AVD Manager`. Click `Create Virtual Device`, select _Pixel_, and click through all the defaults until it is created. Now you will see the new device in your list - double-click to start it. Once the emulator is running, it’s time to run our Flutter app.

```
cd flutter_todo
flutter run
```

This app is a bit more interesting than a normal Hello World app, and includes some interactivity. Tap the button in the bottom-right to increase the counter in the middle of the screen.

![](https://cdn-images-1.medium.com/max/800/1*G9qdgpLvq2o-rriUp0FlXw.png)

Flutter’s “Hello World” app

#### Hot reload

Flutter has a very useful hot reload feature, just like React Native. It means you don’t need to rebuild and re-run your app every time you make a code change. Let’s see how it works.

Say that we want to change the text in the title bar of the Hello World app. All of the code is located in `lib/main.dart`. In this file, find this line:

```
home: new MyHomePage(title: 'Flutter Demo Home Page'),
```

and replace it with:

```
home: new MyHomePage(title: 'Basic Flutter App'),
```

Save the file, and go back to the command line where you ran `flutter run`. All you need to do is type `r`, and this will start the hot reload process. You will notice that in the emulator, the title has changed. Not only that, but if you have tapped the button before, you will notice that the count hasn't reset back to 0. This _stateful hot reload_ is what makes this such a useful feature for development. You can adjust your code and test without being forced back to your app's opening screen every time you make a change.

![](https://cdn-images-1.medium.com/max/800/1*Sq-H7nOab6_dlqOtk9fQmg.png)

Flutter’s “Hello World” app with a changed title, and maintained state

### Flutter Basics

Now that we know how to run a Flutter app, it’s time to start writing our own. We will go for the classic todo app. As mentioned above, we will be writing in Dart. It is certainly not the best known language, but will feel very familiar if you have used Javascript (especially ES2015+), C++ or Java before.

#### Material Design

Flutter comes with a package which makes it very quick to start making a [Material](https://material.io/)-style app. It provides a simple way of creating a screen which has a title bar and body. Let’s start by setting up our Todo app to have a title bar with our app’s name in it.

Remove all the existing code in `lib/main.dart`, and add the following:

```
// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';

// Code written in Dart starts exectuting from the main function. runApp is part of
// Flutter, and requires the component which will be our app's container. In Flutter,
// every component is known as a "widget".
void main() => runApp(new TodoApp());

// Every component in Flutter is a widget, even the whole app itself
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

#### Widgets

This small bit of code shows an important concept in Flutter — everything is a widget. Our whole app is a widget, which contains the `MaterialApp` widget. `Scaffold` is a widget which helps us quickly create a proper Material layout without needing to worry about manual styling. `AppBar` is a widget which accepts a title, and creates a bar at the top of the screen, which is commonly seen in apps. On Android it will align the text to the left, and on iOS it will align it to the centre.

Since we have made big changes to the app, this time a hot reload will not work. Instead we need to do a full restart of the app. On the command line, type `R` -- note it is uppercase, unlike for a hot reload. You will see a simple app with a title bar.

![](https://cdn-images-1.medium.com/max/800/1*ebJQyqOKcyHOKFObqTXN8A.png)

The difference in title bar styling on Android (Pixel 2) vs iOS (iPhone X)

### Stateless and Stateful Widgets

To make our app look more like a todo app, let’s show some tasks. You may have noticed that our simple app above is a `StatelessWidget`. This means that is cannot be changed dynamically. For our todo app, this is no good, because todo items get added and removed all the time. However, a `StatelessWidget` can have children which are dynamic, which are `StatefulWidget`s. Let's break out our stateful functionality (the todo list container) from the overall app container.

To make a stateful widget, we need two classes — one for the widget itself, and a second which creates the state. This setup allows the state to be easily saved, and enables the use of features such as hot reloading.

> **Why does a stateful widget need two classes?**  
> Imagine that we have a todo list widget which contains five todo items. When we add another one to the list, Flutter updates the screen differently to how you might imagine. You may expect that it simply adds this item to the existing widget. In fact, it creates a whole new widget, and compares it to the old one to determine which changes to make on screen.

> Since we create a new widget with every change, we cannot store any state in the widget itself, as it will be lost with the next change. This is why we need a separate State class.

The code below shows our newly stateful app. It is functionally the same as our previous code, but it will now be possible to easily change the contents of the todo list. Replace all the contents of `lib/main.dart` with the code below, and do a full restart with `R`.

```
// Import MaterialApp and other widgets which we can use to quickly create a material app
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

### Modifying State

Now that our app is ready to be stateful, we want to be able to add todo items. To get started, we’ll add a floating action button (FAB), which will add an automatically generated task. Later we will allow the user to enter their own tasks. All of our changes will be inside `TodoListState`.

```
class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  // This will be called each time the + button is pressed
  void _addTodoItem() {
    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    setState(() {
      int index = _todoItems.length;
      _todoItems.add('Item ' + index.toString());
    });
  }

  // Build the whole list of todo items
  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if(index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index]);
        }
      },
    );
  }

  // Build a single todo item
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

Let’s take a closer look at how exactly a new todo item gets added:

*   The user taps the `+` button, calling the `onPressed` callback, which triggers our function `_addTodoItem`
*   `addTodoItem` adds a new string to the `_todoItems` array
*   Everything inside `_addTodoItem` is wrapped in a `setState` call, which tells the app that the todo list has updated
*   `TodoList.createState` is triggered because the todo list has updated
*   This calls `new TodoListState()`, whose constructor is `build`, which builds a whole new widget _with the updated list of todo items_
*   The app takes this new widget, compares it to the previous one, and adds the new item without changing the other items

![](https://cdn-images-1.medium.com/max/800/1*bV3Viw7sWVLDhbaKasHpZA.png)

The app’s second screen, allowing the user to add a task

### User Interaction

A todo app isn’t very useful if the user can only add autogenerated items. Let’s change how our `+` button works, giving the user the ability to specify their task. We want it to open a second screen which has a simple text box where the user types in their task.

#### Adding a todo item

Flutter makes adding a second screen quite simple with the `MaterialPageRoute` widget. This takes a `builder` function as an argument. This returns a `Scaffold`, which you may recognise from our existing screen. So, creating the layout of our second screen will be just the same as the first.

Once the page is created, we need to tell the app how to use it, and that it should animate in on top of the other screen. Flutter provides a `Navigator` for us to do this, which uses the concept of a _navigation stack_, which is common in mobile apps. To add the new screen we _push_ it on to the navigation stack. To remove it, we _pop_ it. We will create a new function called `_pushAddTodoScreen` which will handle all of this. Then we can change our `floatingActionButton`'s `onPressed` to call this function.

Replace the existing `_addTodoItem` and `build` functions with the code below, and add the new `_pushAddTodoScreen` function alongside them. Trigger a full restart by pressing `R` to ensure the autogenerated tasks from last time are removed. Click the `+` button and add a task, and press the enter key on your keyboard. The screen will close and the task will now be on the list.

```
// Instead of autogenerating a todo item, _addTodoItem now accepts a string
void _addTodoItem(String task) {
  // Only add the task if the user actually entered something
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
  // Push this page onto the stack
  Navigator.of(context).push(
    // MaterialPageRoute will automatically animate the screen entry, as well
    // as adding a back button to close it
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

#### Removing todo items

Once the user has completed their task, they need a way to mark it as done and remove it from their list. To keep it simple, let’s show a dialog box when the user taps a task, and ask if they want to mark it as complete.

![](https://cdn-images-1.medium.com/max/800/1*rw1otrHN232dzY9wJCe2EA.png)

A dialog box asking the user to confirm completion of their task

We will create two new functions to achieve this, `_removeTodoItem` and `_promptRemoveTodoItem`. `_buildTodoItem` will also be modified to handle the user's tap interactions. Take a look at the new code below and see if you can follow how it works. I'll go into detail afterwards.

```
// Much like _addTodoItem, this modifies the array of todo strings and
// notifies the app that the state has changed by using setState
void _removeTodoItem(int index) {
  setState(() => _todoItems.removeAt(index));
}

// Show an alert dialog asking the user to confirm that the task is done
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

First, we need functionality to remove a task from our list, which is handled by `_removeTodoItem`. The best way to reference which item we want to remove is by its index in the `_todoItems` array. Referencing it by its name would cause problems if there were multiple tasks with the same name. Once we have the item's index, removing it from the array is simple, using Dart's `removeAt` function. Remember that we need to wrap this in `setState` so that the list will be re-rendered after the item is removed.

Rather than removing the item immediately when a user taps it, it is much more user-friendly to prompt them first. `_promptRemoveTodoItem` uses Flutter's `AlertDialog` component to do this. The constructor for this is similar to the previous ones we have seen, such as `Scaffold`. It simply accepts a text title, and an array of buttons. The handling of button tapping is handled by `onPressed`, where we call `_removeTodoItem` if the correct button is pressed.

Finally, we add an `onTap` handler to each list item in `_buildTodoItem` which will show the above prompt. We need the index of the todo item for this handler, so we must also modify `_buildTodoList` to pass the item's index when it calls `_buildTodoItem`. Flutter will automatically add Material-style tap animations, which are a nice effect for the user.

### Result

The final app allows a user to add and remove todo items, as shown in the video below. The resulting `main.dart` file is available [on GitHub](https://gist.github.com/asialgearoid/227883a08bfd2cc45939758a064dd2ff) if you wish to use it.

![](https://cdn-images-1.medium.com/max/800/1*mqN9VlClBMRDCZ1RPhQLCw.gif)

The final app

There are several things that could be improved in the app if you wish to continue working with it. For example, the user’s todo items are saved between app launches due to Flutter maintaining state, but this is not a reliable way of keeping user data. Instead the user’s todos could be saved safely on the device [using shared_preferences](https://flutter.io/cookbook/persistence/key-value/).

To further improve the app you could [change the theme](https://flutter.io/cookbook/design/themes/), or even add categories for the user’s todos.

### Continuing with Flutter

In this blog post, I’ve aimed to give you a brief overview of what is possible which Flutter. If you are interested in learning more about Flutter in general, the [Flutter documentation](https://flutter.io/docs/) is very thorough and helpful, with plenty of examples.

Though Flutter is still in beta (v0.3.2 as of writing), its ecosystem is very mature. You will not find yourself missing any big features or lacking documentation. Major apps such as Google Adwords are already using Flutter in production, so it is worth investigating if you are starting to develop a new app.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
