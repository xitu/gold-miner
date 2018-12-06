> * 原文地址：[MDC-101 Flutter: Material Components (MDC) Basics (Flutter)](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/#0)
> * 原文作者：[codelabs.developers.google.com](https://codelabs.developers.google.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-101-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-101-flutter.md)
> * 译者：
> * 校对者：

# MDC-101 Flutter: Material Components (MDC) Basics (Flutter)

> - [MDC-101 Flutter: Material Components (MDC) Basics (Flutter)](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-101-flutter.md)
> - [MDC 102 Flutter：Material 结构和布局](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md)
> - [MDC 103 Flutter：Material Theming 的颜色、形状、高度和类型](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)
> - [MDC 104 Flutter：Material 高级组件](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-104-flutter.md)

## 1. Introduction

### What are Material Design and Material Components for Flutter?

**Material Design** is a system for building bold and beautiful digital products. By uniting style, branding, interaction, and motion under a consistent set of principles and components, product teams can realize their greatest design potential.

**Material Components for Flutter** (**MDC-Flutter**) unite design and engineering with a library of components that create a consistent user experience across apps and platforms. As the Material Design system evolves, these components are updated to ensure consistent pixel-perfect implementation, adhering to Google's front-end development standards. MDC is also available for Android, iOS, and the web.

In this codelab, you'll build a login page using several of MDC Flutter's components.

### What you'll build

This codelab is the first of four codelabs that will guide you through building an app called **Shrine**, an e-commerce app that sells clothing and home goods. It will demonstrate how you can customize components to reflect any brand or style using MDC-Flutter.

In this codelab, you'll build a login page for Shrine that contains:

*   An image of Shrine's logo
*   The name of the app (Shrine)
*   Two text fields, one for entering a username and the other for a password
*   Two buttons, one for "Cancel" and one for "Next"

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/db3def4f18a58eed.png)

The related codelabs can be found at:

> - [MDC 102 Flutter：Material 结构和布局](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md)
> - [MDC 103 Flutter：Material Theming 的颜色、形状、高度和类型](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)
> - [MDC 104 Flutter：Material 高级组件](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-104-flutter.md)

By the end of MDC-104, you'll build an app that looks like this:

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/e23a024b60357e32.png

### MDC components in this codelab

*   Text field
*   Button
*   Ripple

> In this codelab you'll use the default components provided by MDC-Flutter. You'll learn to customize them in [MDC-103: Material Design Theming with Color, Shape, Elevation and Type](https://codelabs.developers.google.com/codelabs/mdc-103-flutter).

## 2. Set up your Flutter environment

### Prerequisites

To start developing mobile apps with Flutter you need:

*   the [Flutter SDK](https://flutter.io/setup/)
*   an IntelliJ IDE with Flutter plugins, or your favorite code editor

Flutter's IDE tools are available for [Android Studio](https://developer.android.com/studio/index.html), [IntelliJ IDEA Community (free), and IntelliJ IDEA Ultimate](https://www.jetbrains.com/idea/download/).

![](https://lh6.googleusercontent.com/ol-teJ4O7B69JJRkTfRVQ0a2afiPmL60r-KxNGD26R0KreGtbem_U05Js7HNw3FQu7rIaDVDBQozSFWUB7QVgyfoYpPCPVjKh1knJQGvtbAvLtDbdBmB7XaVbBvth3WOwBAIFDS7)To build and run Flutter apps on iOS:

*   a computer running macOS
*   Xcode 9 or newer
*   iOS Simulator, or a physical iOS device

![](https://lh3.googleusercontent.com/Si2NN00ySyOEkNilzmWrhGLWwaCfGZME_01PwA1sSWu66Prw15UijYovXa-y3csDBg4NP_nhxBc_oqjparZ5Cme0zKuf0RRK1KiaN_n0Kn3AQ0zdkACXUhJJHAXdWK2WFshbxQLt)To build and run Flutter apps on Android:

*   a computer running macOS, Windows, or Linux
*   Android Studio
*   Android Emulator (comes with Android Studio), or a physical Android device

[Get detailed Flutter setup information](https://flutter.io/setup/)

> **Important:** If an Allow USB debugging dialog appears on the Android phone connected to the codelab machine, enable the **Always allow from this computer** option and click **OK**.

Before proceeding with this codelab, make sure that your SDK is in the right state. If the flutter SDK was installed previously, then use `flutter upgrade` to ensure that the SDK is at the latest state.

```
flutter upgrade
```

Running `flutter upgrade` will automatically run `flutter doctor.` If this a fresh flutter install and no upgrade was necessary, then run `flutter doctor` manually. See that all the check marks are showing; this will download any missing SDK files you need and ensure that your codelab machine is set up correctly for Flutter development.

```
flutter doctor
```

## 3. Download the codelab starter app

[Download starter project](https://github.com/material-components/material-components-flutter-codelabs/archive/101-starter.zip)

The starter project is located in the `material-components-flutter-codelabs-101-starter/mdc_100_series` directory.

### ...or clone it from GitHub

To clone this codelab from GitHub, run the following commands:

```
git clone https://github.com/material-components/material-components-flutter-codelabs.git
cd material-components-flutter-codelabs
git checkout 101-starter
```

> For more help: [Cloning a repository from GitHub](https://help.github.com/articles/cloning-a-repository/)

### The right branch

Codelabs MDC-101 through 104 consecutively build upon each other. So when you finish the code for 101, it becomes the starter code for 102! The code is divided across different branches, and you can list them all with this command:

`git branch --list`

To see the completed code, checkout the `102-starter_and_101-complete` branch.

Set up your project

The following instructions assume you're using Android Studio (IntelliJ).

### Create the project

1. In Terminal, navigate to `material-components-flutter-codelabs`

2. Run `flutter create mdc_100_series`

![](https://lh5.googleusercontent.com/J9CQ2xQy4PCirtParnKTrQbjo5tdy0LEh__NVXEjkSYdwSl96QWiwyX2fAdQcW5jTCUzVSzpAqF9-f5mfvyg9BE299XA5nNawKXkAKAO9KIJWawpJtEucLXwqi9buzCX3D7UJixV)

### Open the project

1. Open Android Studio.

2. If you see the welcome screen, click **Open an existing Android Studio project**.

![](https://lh5.googleusercontent.com/q3QrMqM5NUKXvHdNL4f-OPx1WQJCiXZuq0XJzExqbMK6NrSEigfggRFuJ9C9zpqOCsl0uWfywG1_6W1B45xrafR2EGTP68B0Yr0QtGAu3NWCdnylzYHWEp-as7AkYj8S5oNwFzr-)

3. Navigate to the `material-components-flutter-codelabs/mdc_100_series` directory and click Open. The project should open.

**You can ignore any errors you see in analysis until you've built the project once.**

![](https://lh4.googleusercontent.com/eohV4ysnGI7n1WXZEpvDocqGoj2yBijhLPxkGovkL85mil0HSvbQxgJ4VlduNj1ypfOdVd1fyTxR5QnS31iu0HFaqjWcOY2GqWs2hHFNO4-zqQzj-S8rGGH0VqrOEtAFEbzUuCxB)

4. In the project panel on the left, delete the testing file `../test/widget_test.dart`

![](https://lh4.googleusercontent.com/tbOkXg3PBYapj_J0CpdwQTt-sqnf7s3bqi7E3Dd__z_aC5XANKphvuoMvmiOFfBR6oDeZixE0Ww2jTzskt1sDNgEXjAJjwHr7m242tkZ7VvXGaFMObmSIZ06oC7UQusGgCL7DpHr)

5. If prompted, install any platform and plugin updates or FlutterRunConfigurationType, then restart Android Studio.

![](https://lh5.googleusercontent.com/MVD7YGuMneCprDEam1Vy8NusO9BPmOZTyrH4jvO8RmsfTeu8q-t0AfHU3kzXk1F8EUgHaFbqeORdXc7iOcz5ZLM4qbXsv_tMiVnAi0i68p0t957RThrZ56Udf-F292JgRV3iKs7T)

> **Tip:** Make sure you have the [plugins installed for Flutter and Dart](https://flutter.io/get-started/editor/#androidstudio).

### Run the starter app

The following instructions assume you're testing on an Android emulator or device but you can also test on an iOS Simulator or device if you have Xcode installed.

1. Select the device or emulator.

If the Android emulator is not already running, select **Tools -> Android -> AVD Manager** to [create a virtual device and start the emulator](https://developer.android.com/studio/run/managing-avds.html). If an AVD already exists, you can start the emulator directly from the device selector in IntelliJ, as shown in the next step.

(For the iOS Simulator, if it is not already running, launch the simulator on your development machine by selecting **Flutter Device Selection -> Open iOS Simulator**.)

![](https://lh5.googleusercontent.com/mmcO6QRlA96Sc1AZhL8NqvaTE9DZL5q3QQJsrx-2U4ptShFUcrmYoEuVLB6uyAxL4F80dFaxiotLmWjtTYUYYJu-Rf9TtoKDcJLlzuyWezQIz0BiIIBsgy7mPNS8bO5VbqcMb1Qt)

2. Start your Flutter app:

*   Look for the Flutter Device Selection dropdown menu at the top of your editor screen, and select the device (for example, iPhone SE or Android SDK built for <version>).
*   Press the **Play** icon (![](https://lh6.googleusercontent.com/Zu8-cWRMCfIrBGIjj4kSW-j8KBiIqVe33PX8Mht5lSKq00kRB7Na3X0kC4aaiG-G7hqqqLPpgtbxTz-1DdYbq2RiNvc2ZaJzfiu_vVYAh1oOc4TZu85pa42nFqqxmMQWySzLWeU1)).

![](https://lh4.googleusercontent.com/NLXK-hHFYnHBPeQ6NYrKGnXpj9X2es9her6Y14CotXlR-OdSQBXHyRFv1nvhC1AFCmWx7jIG2Ulb7-OmLV_Pru_-kd-3gArn8OKEGTIOInDJlqIUJ7dxTQUsvLVa0CJwEO5EGjeu)

> If you were unable to run the app successfully, stop and troubleshoot your developer environment. Try navigating to `material-components-flutter-codelabs` or if you downloaded the .zip file `material-components-flutter-codelabs-...`) in the terminal and running `flutter create mdc_100_series`.

Success! The starter code for Shrine's login page should be running in your simulator. You should see the Shrine logo and the name "Shrine" just below it.

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/e8f2476968468376.png)

If you see any warnings about the `pubspec` having been edited (with prompts to get dependencies), just leave them alone. When you press the play button, it runs `flutter packages get` for you!

`flutter packages get` installs dependencies you have listed in your `pubspec.yaml` file. You can write your own packages to be published on [Pub](https://pub.dartlang.org/). This codelab series uses a custom package `shrine_images` for the product images you'll see in [MDC-102](http://go/mdc-102-flutter).

`flutter packages get` invokes the underlying Dart pub package manager to install all the dependencies for your Flutter app. In this codelab series we use a custom package shrine_images for the product images.

For more information on packages, see [Using Packages](https://flutter.io/using-packages/).

Let's look at the code.

### Widgets in `login.dart`

Open up `login.dart`. It should contain this:

```
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO: Add text editing controllers (101)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                SizedBox(height: 16.0),
                Text('SHRINE'),
              ],
            ),
            SizedBox(height: 120.0),
            // TODO: Wrap Username with AccentColorOverride (103)
            // TODO: Remove filled: true values (103)
            // TODO: Wrap Password with AccentColorOverride (103)
            // TODO: Add TextField widgets (101)
            // TODO: Add button bar (101)
          ],
        ),
      ),
    );
  }
}

// TODO: Add AccentColorOverride (103)
```

Notice that it contains an `import` statement and two new classes:

*   The `import` statement brings Material Components into this file.
*   The `LoginPage` class represents the entire page displayed in the simulator.
*   The `_LoginPageState` class's `build()` function controls how all the widgets in our UI are created.

> For more of the basics of the Flutter UI and what widgets are, you can take a [Tour of the Flutter Widget Framework](https://flutter.io/widgets-intro/) or do the codelab [Write Your First Flutter App, part 1](https://codelabs.developers.google.com/codelabs/first-flutter-app-pt1).

## 4. Add TextField widgets

To begin, we'll add two text fields to our login page, where users enter their username and password. We'll use the TextField widget, which displays a floating label and activates a touch ripple.

> Material's text fields have been greatly enhanced to improve brand flexibility, with improvements backed by extensive user experience (UX) research for better usability and visual design.
>
> Learn more about the new text fields in their [article](https://material.io/design/components/text-fields.html) of the Material Guidelines.

This page is structured primarily with a **ListView**, which arranges its children in a scrollable column. Let's place text fields at the bottom.

### Add the TextField widgets

Add two new text fields and a spacer after `SizedBox(height: 120.0)`.

```
// TODO: Add TextField widgets (101)
// [Name]
TextField(
  decoration: InputDecoration(
    filled: true,
    labelText: 'Username',
  ),
),
// spacer
SizedBox(height: 12.0),
// [Password]
TextField(
  decoration: InputDecoration(
    filled: true,
    labelText: 'Password',
  ),
  obscureText: true,
),
```

The text fields each have a `decoration:` field that takes an **InputDecoration** widget. The `filled:` field means the background of the text field is lightly filled in to help people recognize the tap or touch target area of the text field. The second text field's `obscureText: true` value automatically replaces the input that the user types with bullets, which is appropriate for passwords.

Save your project (with the keystroke: command + s) which performs a hot reload.

You should now see a page with two text fields for Username and Password! Check out the floating label and ink ripple animations:

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/19af1564bbdffe0a.png)

> If the app doesn't update, click the "Play" button again, or click "Stop" followed by "Play."

TextField features include:

*   The TextField widget's look can be easily changed. For the decoration field, specify an InputDecoration value.
*   The MDC text field displays touch feedback (called the MDC ripple or "ink") by default.
*   The FormField is a similar widget that has special features for embedding fields in Forms.
*   [TextField class documentation](https://docs.flutter.io/flutter/material/TextField-class.html)

## 5. Add buttons

Next, we'll add two buttons to our login page: "Cancel" and "Next." We'll use two kinds of MDC button widgets: the **FlatButton** (called the "Text Button" in the Material Guidelines) and the **RaisedButton** (referred to as the "Contained Button").

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/fb1bc435bbb0a662.png)

### Choosing between text and Contained buttons

Why not simply display two contained buttons? Each button type indicates which actions are more important than others.

A layout should contain a single prominent button. This makes it clear that other buttons have less importance. This prominent button represents the action we most want our users to take in order to advance through our app.

The action we'd least like them to take is cancelling the login. Because a contained button draws the eye with its raised appearance, it should be used for the more important action. By comparison, the plain text button to the left of it looks less emphasized.

Learn more about button hierarchy in the [Buttons](https://material.io/design/components/buttons.html) article of the Material Guidelines.

### Add the ButtonBar

After the text fields, add the `ButtonBar` to the `ListView`'s children:

```
// TODO: Add button bar (101)
ButtonBar(
  // TODO: Add a beveled rectangular border to CANCEL (103)
  children: <Widget>[
    // TODO: Add buttons (101)
  ],
),
```

The **ButtonBar** arranges its children in a row.

### Add the buttons

Then add two buttons to the ButtonBar's list of `children`:

```
// TODO: Add buttons (101)
FlatButton(
    child: Text('CANCEL'),
    onPressed: () {
    // TODO: Clear the text fields (101)
    },
),
// TODO: Add an elevation to NEXT (103)
// TODO: Add a beveled rectangular border to NEXT (103)
RaisedButton(
    child: Text('NEXT'),
    onPressed: () {
// TODO: Show the next page (101) 
    },
),
```

### Why do we have empty blocks for the onPressed: fields?

If we passed null, or didn't include the field (which then defaults to null), the buttons would become disabled. There would be no feedback on touch and we couldn't get a good idea of their enabled behavior. Using empty blocks prevents them from being disabled.

For more information on buttons and their interactions, see [Adding Interactivity to Your App](https://flutter.io/tutorials/interactive/).

Save your project. Under the last text field, you should see two buttons appear:

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/fb1bc435bbb0a662.png)

The ButtonBar handles the layout work for you. It positions the buttons horizontally, so they appear next to one another, according to the padding in the current **ButtonTheme**. (You'll learn more about that in codelab [MDC-103](http://go/mdc-103-flutter).)

Touching a button initiates an ink ripple animation, without causing anything else to happen. Let's add functionality into the anonymous `onPressed:` functions, so that the cancel button clears the text fields, and the next button dismisses the screen:

### Add TextEditingControllers

To make it possible to clear the text fields' values, we'll add **TextEditingControllers** to control their text.

Right under the `_LoginPageState` class's declaration, add the controllers as `final` variables.

```
// TODO: Add text editing controllers (101)
final _usernameController = TextEditingController();
final _passwordController = TextEditingController();
```

On the first text field's `controller:` field, set the `_usernameController`:

```
// [Name]
TextField(
  controller: _usernameController,
```

On the second text field's `controller:` field, now set the `_passwordController`:

```
// [Password]
TextField(
  controller: _passwordController,
```

### Edit onPressed

Add a command to clear each controller in the FlatButton's `onPressed:` function:

```
// TODO: Clear the text fields (101)
_usernameController.clear();
_passwordController.clear();
```

Save your project. Now when you type something into the text fields, hitting cancel clears each field again.

This login form is in good shape! Let's advance our users to the rest of the Shrine app.

### Pop

To dismiss this view, we want to **pop** (or remove) this page (which Flutter calls a **route**) off the navigation stack.

**Navigator** maintains a stack of routes just like UINavigationController on iOS. _Pushing_ a route places it at the top of the stack. _Popping_ the stack removes the most recently added route. In `app.dart` of our app, calling `initialRoute: '/login',` adds the login screen to the Navigator, on top of what is passed in `home:`.

Learn more about routes and navigation in [Navigation Basics](https://flutter.io/cookbook/navigation/navigation-basics/).

In the RaisedButton's `onPressed:` function, pop the most recent route from the Navigator:

```
// TODO: Show the next page (101) 
            RaisedButton(
                child: Text('NEXT'),
                onPressed: () {
                Navigator.pop(context);
                },
            ),
```

That's it! Save the project. Go ahead and click "Next."

You did it!

![](https://codelabs.developers.google.com/codelabs/mdc-101-flutter/img/82ea25c31b367255.png)

This screen is the starting point for our next codelab, which you'll work on in MDC-102.

About Buttons:

*   In addition to FlatButton and RaisedButton, there's OutlineButton, FloatingActionButton IconButton, and more.
*   Browse buttons and their documentation in the [MDC Widgets catalog](https://flutter.io/widgets/material).

## 6. All done

We added text fields and buttons and hardly had to consider layout code. Material Components for Flutter come with a lot of style and can be laid out almost effortlessly.

The completed MDC-101 app is available in the `102-starter_and_101-complete` branch.

You can test your version of the app against the app in that branch.

### Next steps

Text fields and buttons are two core components in the Material System, but there are many more! You can also explore the rest of the [widgets in Flutter's Material Components library](https://flutter.io/widgets/material/).

Alternatively, head over to [MDC-102: Material Design Structure and Layout](https://codelabs.developers.google.com/codelabs/mdc-102-flutter) to learn about the components covered in MDC-102 for Flutter.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
