> * 原文地址：[Thought Experiment: Flutter in Go](https://divan.dev/posts/flutter_go/)
> * 原文作者：[divan](https://divan.dev/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flutter_go.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flutter_go.md)
> * 译者：
> * 校对者：

# Thought Experiment: Flutter in Go

我最近发现了 [Flutter](https://flutter.io) —— 谷歌的一个新的移动开发框架，我甚至有曾经将 Flutter 基础知识教给从未有过编程的人的经历。Flutter 是用 Dart 编写的，这是一种诞生于 Chrome 浏览器的编程语言，后来改用到了控制台。这不禁让我想到“Flutter 也许可以很轻易地用 Go 来实现”！

Why not? Both Go and Dart were born inside Google (and share some approaches that make them great), both strongly-typed, compiled languages – in a slightly different turn of events, Go could definitely have been a choice for such an ambitious project as Flutter. And Go is much easier to explain to the person who has never been programming before.
为什么不用 Go 实现呢？Go 和 Dart 都是在谷歌中诞生的（并且有很多的大会分享使他们变得更好），它们都是强类型的编译语言 —— 在一些不同的情况下

So let’s pretend Flutter is written in Go already. How would the code look like?

[![Go Flutter in VSCode](https://divan.dev/images/go_flutter_vscode.png)](https://divan.dev/images/go_flutter_vscode_big.png)

### The problem with Dart

I’ve been following Dart development since the very beginning of its existence in Chrome, and my assumption has always been that Dart will replace JS eventually in every browser. It was extremely disappointing to read the [news about Google ditching Dart support in Chrome](https://news.dartlang.org/2015/03/dart-for-entire-web.html) back then in 2015.

Dart is fantastic! Well, everything is fantastic when you upgrade from JS, but if you downgrade from, say, Go, it’s not that exciting, but… it’s ok. Dart has every feature possible – classes/generics/exceptions/Futures/async-await/event-loop/JIT/AOT/GC/overloads - you name it. It has special syntax for getters/setters, special syntax for auto-initialization in constructors, special syntax for special syntax and many more.

While it makes Dart more familiar to people with a background in pretty much any other language – which is great and lowers entry barrier – I found it hard to explain to the newcomer with no background.

* **Everything “special” was confusing** – **“special method named constructor”**, **“special syntax for initialization”**, **“special syntax for overriding methods”** etc.
* **Everything “hidden” was confusing** – **“from which import this class comes from? it’s hidden, and you can’t see it by reading a code”**, **“why we write a constructor in this class but don’t write in another? it’s there, but it’s hidden”** and so on
* **Everything “ambiguous” was confusing** – **“so should I use named or position parameter here?”**, **“should it be final or const variable?”**, **“should I use normal function syntax or ‘this short syntax’?”** etc.

This triplet - “special”, “hidden” and “ambiguous” - probably captures the essence of what people call “magic” in programming languages. Those are features designed to help us write simpler and cleaner code, but, in fact, they add more confusion and more cognitive load to reading programs.

And that’s exactly where Go took a vastly different stance and guards its positions fiercely. Go is virtually non-magical language – it minimizes amount of special/hidden/ambiguous constructs to the lowest possible amount. It comes with its own list of shortages, however.

### The problem with Go

As we’re talking about Flutter, which is a UI framework, we have to look at Go as a tool for describing/specifying UI. UI framework is a massively complicated subject to deal with – it literally requires creating a specialized language to handle the amount of essential complexity. One of the most popular ways to do so is to create [DSL](https://en.wikipedia.org/wiki/Domain-specific_language) \- Domain-specific Language – and the common knowledge is that Go is really bad at it.

Creating DSL means creating custom terms and verbs developer can use. The resulting code should capture the essence of UI layout and interactions, and be flexible enough to allow designers’ fantasy flow, but rigid enough to conform UI framework limitations. For example, you should be able to put buttons inside a container, then put icons and text widget inside buttons, and yet compiler should give you an error if you try to put the button into text.

UI specific language is also often declarative – which, in fact, means that you should be able to use code constructs (including things like space indentation!) to visually capture the structure of the UI widgets tree and then let UI framework figure out the code to run. Uff.

Some languages are more suitable for such a feat and Go never been designed to accomplish this kind of tasks. So, writing Flutter code in Go should be quite a challenge!

## Ode to Flutter

If you are unfamiliar with Flutter, I highly recommend you to spend a weekend or two watching tutorials or reading docs, because it’s undoubtedly a game changer in a mobile development world. And, hopefully, not only mobile – there are renderers (embedders, in Flutter terms) for [native desktop apps](https://github.com/google/flutter-desktop-embedding), and [web apps](https://medium.com/flutter-io/hummingbird-building-flutter-for-the-web-e687c2a023a8). It’s easy to learn, it’s logical, has a massive collection of [Material Design](https://material.io) powered widgets, has great community and great tooling (if you like `go build/test/run` out of the box, you get the same experience with `flutter build/test/run`) and a bunch of decent practices out of the box.

A year ago I needed a relatively simple mobile app (for iOS and Android, obviously), but I realized that the complexity of becoming proficient in both platforms development is above any possible limits (the app was kinda side-project), so I had to outsource development to another team and pay money for that. Developing the mobile app was virtually unaffordable for someone like me – a developer with almost two decades of programming experience.

With Flutter, I wrote the same app in 3 nights, while learning this framework from scratch! It’s an order of magnitude improvement and a game changer.

Last time I remember seeing such a revolution in development productivity was 5 years ago when I discovered Go. And it changed my life.

I recommend you to start with this [great video tutorial](https://www.youtube.com/watch?v=GLSG_Wh_YWc).

## Flutter’s Hello, world

When you create a fresh Flutter project with `flutter create`, you’ll get this “Hello, world” app with text, counter and a button that increases the counter on click.

![flutter hello world](https://divan.dev/images/flutter_hello.gif)

I think it’s a good example to rewrite in our imaginary Flutter in Go. It has everything relevant to our subject. Take a look at the code (it’s one file):

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

Let’s break down it to pieces, analyze what does and does not map well into Go, and explore the options we have.

### Mapping to Go

The start is relatively straightforward – importing the dependency and starting `main()` function. Nothing challenging or interesting here, purely syntactical change:

```go
package hello

import "github.com/flutter/flutter"

func main() {
    app := NewApp()
    flutter.Run(app)
}
```

The only change to note is that instead of using magical `MyApp()` function, which is constructor, which is a special function, which is hidden inside class called `MyApp`, we just call an explicitly defined function `NewApp()` – it does the same, but it’s so much easier to read, understand and make sense of.

### Widget classes

In Flutter, everything is a widget. In Dart-version of a Flutter, every widget is represented with a class extending Flutter’s special Widget classes.

Go doesn’t have classes and thus classes hierarchy, because the world is not object-oriented, let alone hierarchical. It may come as a hard truth to people familiar only with class-based OOP, but it’s really not. The world is a huge interconnected graph of things and relationships. It’s not chaotic, but neither perfectly structured and trying to fit everything into class hierarchies is a guaranteed way to make code unmaintainable, which is a most of world’s codebases as of today.

![OOP Truth](https://divan.dev/images/oop_truth.png)

I love that Go designers put an effort to rethink this omnipresent concept of class-based OOP and came up with different OOP concept, which is, not accidentally, more closer to what OOP inventor, Alan Kay, [actually meant](https://www.quora.com/What-did-Alan-Kay-mean-by-I-made-up-the-term-object-oriented-and-I-can-tell-you-I-did-not-have-C++-in-mind).

In Go, we represent any abstraction with a concrete type – a structure:

```go
type MyApp struct {
    // ...
}
```

In Dart-version of a Flutter, `MyApp` has to extend `StatelessWidget` class and override its `build` method, which serves two purposes:

1. give our `MyApp` some widget properties/methods automagically
2. allow Flutter to use our widget in its build/render pipeline by calling `build`

I don’t know Flutter internals, so let’s not question if we really need 1) and implement it in Go. For that, we have only one option – [embedding](https://golang.org/doc/effective_go.html#embedding):

```go
type MyApp struct {
    flutter.Core
    // ...
}
```

This will add all the `flutter.Core`’s exported properties and methods to our type `MyApp`. I named it `Core` instead of `Widget`, because embedding this type doesn’t make our `MyApp` a widget yet, and, plus, that’s the choice of name I’ve seen in a [Vecty](https://github.com/gopherjs/vecty) GopherJS framework for the similar concept. I will briefly discuss similarities between Flutter and Vecty later.

The second part – `build` method for Flutter’s engine use – surely should be implemented simply by adding method, satisfying some interface defined somewhere in Go-version of a Flutter:

flutter.go:

```go
type Widget interface {
    Build(ctx BuildContext) Widget
}
```

Our main.go:

```go
type MyApp struct {
    flutter.Core
    // ...
}

// Build renders the MyApp widget. Implements Widget interface.
func (m *MyApp) Build(ctx flutter.BuildContext) flutter.Widget {
    return flutter.MaterialApp()
}
```

We might notice a few differences with Dart’s Flutter here:

* code is more verbose – `BuildContext`, `Widget` and `MaterialApp` all have `flutter` explicitly mentioned in front of them.
* code is less verbose – no `extends Widget` or `@override` clauses
* Build method is uppercased because in Go it means “public” visibility. In Dart, any case will do, but to make property or method “private” you start the name with an underscore (_).

In order to make a Go’s Flutter `Widget` now we should embed `flutter.Core` and implement `flutter.Widget` interface. Okay, that’s clear, let’s go further.

## The State

That was the first thing I found baffling with Dart’s Flutter. There are two kinds of widgets in Flutter – `StatelessWidget` and `StatefulWidget`. Uhm, to me, the stateful widget is just a widget without a state, so why invent a new class here? Well, okay, I can live with it. But you can’t just extend `StatefulWidget` in the same way, you should do the following magic (IDEs with Flutter plugin do it for you, but that’s not the point):

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

Uff, let’s try to understand not only what is written here, but why?

The task to solve here is to add state (`counter`) to the widget and allow Flutter to redraw widget when the state has changed. That’s the essential complexity part.

[Accidental complexity](https://www.quora.com/What-is-accidental-complexity) is all the rest. Dart’s Flutter approach is to introduce a new class `State` which uses generics and takes a Widget as its parameter. So `_MyAppState` is a class that extends `State of a widget MyApp`. Okay, kinda makes sense… But why `build()` method is defined on a State instead of a Widget? This question [is answered](https://flutter.io/docs/resources/faq#why-is-the-build-method-on-state-not-statefulwidget) in the Flutter’s FAQ and discussed in detailed [here](https://docs.flutter.io/flutter/widgets/State/build.html) and the short answer is: to avoid category of bugs when subclassing `StatefulWidget`. In other words, it’s a workaround of the class-based OOP design.

How would we design it in Go?

First of all, I personally would try to avoid creating a new concept for `State` – we already implicitly have “state” in any concrete type – it’s just the properties (fields) of the struct. Language already possesses this concept of a state, so to speak. So creating a new one will just puzzle developers – why can’t we use a “normal state” of a type here.

The challenge, of course, is to make Flutter engine track state changes and react on it (that’s the gist of reactive programming, after all). And instead of creating “special” methods and wrappers around state changes, we can just ask the developer to manually tell Flutter when we want to update the widget. Not all state changes require immediate redrawing – there are plenty of valid cases to that. Let’s see:

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

There is a number of options with naming and design here – I like `NeedsUpdate()` for explicitness and being a method of `flutter.Core` (so each widget has it), but `flutter.Rerender()` also works fine. It gives a false sense of immediate redraw, though – which is not always a case – it will be redrawn on the next frame redraw, and the frequency of state update might be much higher than frame redraw frequency.

But the point is we just implemented the same task of adding a reactive state to the widget, without adding:

* new type
* generics
* special rules for reading/writing state
* new special overridden methods

Plus, API is cleaner and more explicit – just increase the counter and ask flutter to re-render – something not really obvious when you asked to call special function `setState` that return another function with the actual state change. Again, hidden magic hurts readability, and we managed to avoid just that. As a result, the code is simpler and twice as short.

### Stateful widgets as a children

As a logical continuation, let’s take a closer look at how “stateful widget” is used within another widget in Flutter:

```dart
@override
Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
}
```

`MyHomePage` here is a “stateful widget” (it has a counter), and we’re creating it by calling constructor `MyHomePage(title:"...")` during the build… Wait, what?

`build()` is called to redraw the widget, perhaps many times per second. Why would we create a widget, let alone stateful, during each render cycle?

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
