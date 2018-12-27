> * 原文地址：[MDC-103 Flutter: Material Theming with Color, Shape, Elevation, and Type (Flutter)](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/#0)
> * 原文作者：[codelabs.developers.google.com](https://codelabs.developers.google.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-103-flutter.md)
> * 译者：
> * 校对者：

# MDC-103 Flutter: Material Theming with Color, Shape, Elevation, and Type (Flutter)

## 1. Introduction

![](https://lh4.googleusercontent.com/yzZPYGHe5CrFE-84MXhqwb_y7YjCKLWQJHI7W7zqbT9_qdK8qufFjx51kepr3ITvZtF7vD3d72nurt-HPBARmQ6RF74PD1FwGZMNbXphLap4LqIEBCKWP5OxK2Vjeo-YEY3-oeIP)Material Components (MDC) help developers implement Material Design. Created by a team of engineers and UX designers at Google, MDC features dozens of beautiful and functional UI components and is available for Android, iOS, web and Flutter.

material.io/develop

You can now use MDC to customize your apps' unique style more than ever. Material Design's recent expansion gives designers and developers increased flexibility to express their product's brand.

In codelabs MDC-101 and MDC-102, you used Material Components (MDC) to build the basics of an app called **Shrine**, an e-commerce app that sells clothing and home goods. This app contains a user flow that starts with a login screen, then takes the user to a home screen that displays products.

### What you'll build

In this codelab, you'll customize the Shrine app using:

*   Color
*   Typography
*   Elevation
*   Shape
*   Layout

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/7f521db8a762f5ee.png)

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/7ac46e5cb6b1e064.png)

This is the third of four codelabs that will guide you through building Shrine.

The related codelabs can be found at:

*   [MDC-101: Material Components (MDC) Basics](https://codelabs.developers.google.com/codelabs/mdc-101-flutter)
*   [MDC-102: Material Design Structure and Layout](https://codelabs.developers.google.com/codelabs/mdc-102-flutter)
*   [MDC-104: Material Design Advanced Components](https://codelabs.developers.google.com/codelabs/mdc-104-flutter)

By the end of MDC 104, you'll build an app that looks like this:

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/e23a024b60357e32.png)

## MDC-Flutter components and subsystems in this codelab

*   Themes
*   Typography
*   Elevation
*   Image list

### What you'll need

*   The [Flutter SDK](https://flutter.io/setup/)
*   Android Studio with Flutter plugins, or your favorite code editor
*   The sample code

### To build and run Flutter apps on iOS:

*   A computer running macOS
*   Xcode 9 or newer
*   iOS Simulator, or a physical iOS device

### To build and run Flutter apps on Android:

*   A computer running macOS, Windows, or Linux
*   Android Studio
*   Android Emulator (comes with Android Studio), or a physical Android device

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

### Continuing from MDC-102?

If you completed MDC-102, your code should be ready to go for this codelab. Skip to step: _Change the colors_.

### Starting from scratch?

### Download the starter codelab app

[Download starter app](https://github.com/material-components/material-components-flutter-codelabs/archive/103-starter_and_102-complete.zip)

The starter app is located in the `material-components-flutter-codelabs-103-starter_and_102-complete/mdc_100_series` directory.

### ...or clone it from GitHub

To clone this codelab from GitHub, run the following commands:

```
git clone https://github.com/material-components/material-components-flutter-codelabs.git
cd material-components-flutter-codelabs
git checkout 103-starter_and_102-complete
```

> For more help: [Cloning a repository from GitHub](https://help.github.com/articles/cloning-a-repository/)

> The right branch
>
> Codelabs MDC-101 through 104 consecutively build upon each other. So when you finish the code for 102, it becomes the starter code for 103! The code is divided across different branches, and you can list them all with this command:
>
> `git branch --list`
>
> To see the completed code, checkout the `104-starter_and_103-complete` branch.

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

Success! You should see the Shrine login page from the previous codelabs in the simulator or emulator.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/db3def4f18a58eed.png)

> If the app doesn't update, click the "Play" button again, or click "Stop" followed by "Play."

Click "Next" to see the home page from the previous codelab.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/532fe80b3fa3db74.png)

A color scheme has been created that represents the Shrine brand, and the designer would like to you implement that color scheme across the Shrine app

To start, let's import those colors into our project.

## 4. Change the colors

### Create** **`colors.dart`

Create a new dart file in `lib` called `colors.dart`. Import Material Components and add const Color values:

```
import 'package:flutter/material.dart';

const kShrinePink50 = const Color(0xFFFEEAE6);
const kShrinePink100 = const Color(0xFFFEDBD0);
const kShrinePink300 = const Color(0xFFFBB8AC);
const kShrinePink400 = const Color(0xFFEAA4A4);

const kShrineBrown900 = const Color(0xFF442B2D);

const kShrineErrorRed = const Color(0xFFC5032B);

const kShrineSurfaceWhite = const Color(0xFFFFFBFA);
const kShrineBackgroundWhite = Colors.white;
```

### Custom color palette

This color theme has been created by a designer with custom colors (shown in the image below). It contains colors that have been selected from Shrine's brand and applied to the Material Theme Editor, which has expanded them to create a fuller palette. (These colors aren't from the 2014 Material color palettes.)

The Material Theme Editor has organized them into shades labelled numerically, including labels 50, 100, 200, .... to 900 of each color. Shrine only uses shades 50, 100, and 300 from the pink swatch and 900 from the brown swatch.

![](https://lh3.googleusercontent.com/P2WMR2CBjl5H2CfhCWnqrpw4UiLMJgnZ3KRh-n4cA2YLbGPBA_WXq463bUigJDjO_ThANoki4cuFeuS12Wamvn08rmgxPhJMerUytDwlXaS7XiFYjKYvIgaeo9iYAINstV3GwhoD)

![](https://lh5.googleusercontent.com/sfrxmMvcYDu-JrEaTdnRjRRJx2wyf6GfoNRolI1Xodrm0mNIsFMRaAFAO8MbxYPu3-Ust19LPPcfKIEvQhXeDOGHqvupsWatCRFF-eH52cv5B6ksqowA1Z0W4JIPS3medD4FnqVC)

Each colored parameter of a widget is mapped to a color from these schemes. For example, the color for a text field's decorations when it's actively receiving input should be the theme's Primary color. If that color isn't accessible (easy to see against its background), use the PrimaryVariant instead.

> ### Colors
>
> The value for `kShrineBackgroundWhite` is taken from the **Colors** class. This class has values for common colors, such as white. It also contains the 2014 color palettes as MaterialColor class.
>
> ### MaterialColor
>
> The **MaterialColor** class (which subclasses **ColorSwatch**) found in 'material/colors.dart', are groups of 14 or fewer variations on a primary color, such as 14 shades of Red, Green, Light Green, or Lime. These variations resemble the gradient color chips you'd find in a paint store.  
> 
> These variations were created for the 2014 Material Guidelines and are still available both in the current guidelines ([Color System article](https://material.io/design/color/the-color-system.html)) and MDC-Flutter. To access them in code, just call the base color and then the shade (usually a hundreds value). For example, Pink 400 is retrieved by the command: `Colors.pink[400]`.
>
> It's perfectly fine to use these palettes for your designs and your code. If you already have colors specific to your branding, you can generate your own harmonious palettes using either the [palette generation tool](https://material.io/tools/color/) or [Material Theme Editor](https://material.io/tools/theme-editor/).

Now that we have the colors we want to use, we can apply them to the UI. We'll do this by setting the values of a **ThemeData** widget that we apply to the MaterialApp instance at the top of our widget hierarchy.

### Customize ThemeData.light()

Flutter includes a few built-in themes. The light theme is one of them. Rather than making a ThemeData widget from scratch, we'll copy the light theme and change the values to customize them for our app.

### Copying a ThemeData instance

We called `copyWith()` on the default light ThemeData, and then passed in some custom property values (`copyWith()` is a common method you'll find on many classes and widgets in Flutter). This command returns an instance of the widget that matches the instance it's called on, but with the specified values replaced.

Why not just instantiate a ThemeData instance and then set its properties? We could! If we continued to build out our app, it would make sense to do that. As ThemeData has _dozens_ of properties, to save time we'll start with an attractive theme and change the values we can see in the codelab. When we try an alternative theme later, we'll start with a different ThemeData included with MDC-Flutter.

Learn more about ThemeData in its [Flutter documentation](https://docs.flutter.io/flutter/material/ThemeData-class.html).

Let's import `colors.dart`.

```
import 'colors.dart';
```

Then add the following to app.dart _outside_ the scope of the ShrineApp class:

```
// TODO: Build a Shrine Theme (103)
final ThemeData _kShrineTheme = _buildShrineTheme();

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: kShrineBrown900,
    primaryColor: kShrinePink100,
    buttonColor: kShrinePink100,
    scaffoldBackgroundColor: kShrineBackgroundWhite,
    cardColor: kShrineBackgroundWhite,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    // TODO: Add the text themes (103)
    // TODO: Add the icon themes (103)
    // TODO: Decorate the inputs (103)
  );
}
```

Now, set the `theme:` at the end of ShrineApp's `build()` function (in the MaterialApp widget) to be our new theme:

```
// TODO: Add a theme (103)
return MaterialApp(
  title: 'Shrine',
  // TODO: Change home: to a Backdrop with a HomePage frontLayer (104)
  home: HomePage(),
  // TODO: Make currentCategory field take _currentCategory (104)
  // TODO: Pass _currentCategory for frontLayer (104)
  // TODO: Change backLayer field value to CategoryMenuPage (104)
  initialRoute: '/login',
  onGenerateRoute: _getRoute,
  theme: _kShrineTheme, // New code
);
```

Click the Play button. Your login screen should now look like this:

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/6c1a1df9a99150a6.png)

And your home screen should look like this:

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/img/31adaca378656d60.png)

> Notes on color and themes:
> 
> *  You can customize the color in your UI to better express your brand.
> *  Make a color palette starting from two colors (your primary and secondary colors), with light and dark variations of those colors. Or use the Material Design palette tool to generate palettes.
> *  Don't forget the color of your typography!
> *  Make sure text-to-background color contrast is at an accessible ratio (3:1 for large type, 4.5:1 for small).

## 5. Modify typography and label styles

In addition to color changes, the designer has also given us specific typography to use. Flutter's ThemeData includes 3 text themes. Each text theme is a collection of text styles, like "headline" and "title". We'll use a couple of styles for our app and change some of the values.

### Customize the text theme

In order to import fonts into the project, they have to be added to the pubspec.yaml file.

In pubspec.yaml, add the following immediately after the `flutter:` tag:

```
  # TODO: Insert Fonts (103)
  fonts:
    - family: Rubik
      fonts:
        - asset: fonts/Rubik-Regular.ttf
        - asset: fonts/Rubik-Medium.ttf
          weight: 500
```

Now you can access and use the Rubik font.

### Troubleshooting the pubspec file

You may get errors in running **pub get** if you cut and paste the declaration above. If you get errors, start by removing the leading whitespace and replacing it with spaces using 2-space indentation. (Two spaces before

```
fonts:
```

, four spaces before

```
family: Rubik
```

, and so on.)

If you see _Mapping values are not allowed here_, check the indentation of the line that has the problem and the indentation of the lines above it.

In `app.dart`, add the following after `_buildShrineTheme()`:

```
// TODO: Build a Shrine Text Theme (103)
TextTheme _buildShrineTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
        fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: kShrineBrown900,
    bodyColor: kShrineBrown900,
  );
}
```

This takes a **TextTheme** and changes how the headlines, titles, and captions look.

Applying the `fontFamily` in this way applies the changes only to the typography scale values specified in `copyWith()` (headline, title, caption).

For some fonts, we're setting a custom fontWeight. The **FontWeight** widget has convenient values on the 100s. In fonts, w500 (the 500 weight) is usually the medium and w400 is usually the regular.

### Use the new text themes

> ### Text Themes
>
>Text Themes are a useful way to make sure that all the text in your app is consistent and readable. For example, text theme styles can be black or white, depending on the brightness of the theme's primary color. This ensures that the text will have appropriate contrast with the backdrop, so that it is always readable.
>
> Learn more about TextTheme in its [Flutter documentation](https://docs.flutter.io/flutter/material/TextTheme-class.html).

Add the following themes to `_buildShrineTheme` after errorColor:

```
// TODO: Add the text themes (103)

textTheme: _buildShrineTextTheme(base.textTheme),
primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
```

Click the Stop button and then the Play button.

Text in the login and home screens look different—some text uses the Rubik font, and other text renders in brown, instead of black or white.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/2153d8c98cafac14.png)

> Notes on typography:
>
>*  When choosing text fonts, used for small type and body text, choose fonts that are clear, rather than for a certain style.
> *  Display fonts, used for large type and titles, should be used to express or emphasize brand.

Notice that the icons are still white. That's because there's a separate theme for icons.

### Use a customized primary icon theme

Add it to the `_buildShrineTheme()` function:

```
// TODO: Add the icon theme (103)
primaryIconTheme: base.iconTheme.copyWith(
    color: kShrineBrown900
),
```

Click the play button.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/9489cc4b3274b10a.png)

Brown icons in the app bar!

### Shrink the text

The labels are just a little too big.

In `home.dart`, change the `children:` of the innermost Column:

```
// TODO: Change innermost Column (103)
children: <Widget>[
// TODO: Handle overflowing labels (103)

  Text(
    product == null ? '' : product.name,
    style: theme.textTheme.button,
    softWrap: false,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  ),
  SizedBox(height: 4.0),
  Text(
    product == null ? '' : formatter.format(product.price),
    style: theme.textTheme.caption,
  ),
  // End new code
],
```

### Center and drop the text

We want to center the labels, and align the text to the bottom of each card, instead of the bottom of each image.

Move the labels to the end (bottom) of the main axis and change them to be centered::

```
// TODO: Align labels to the bottom and center (103)

  mainAxisAlignment: MainAxisAlignment.end,
  crossAxisAlignment: CrossAxisAlignment.center,
```

Save the project.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/8c639fa1b15fd7a5.png)

It's close, but the text isn't centered to the card.

Change the parent Column's cross-axis alignment:

```
// TODO: Center items on the card (103)

    crossAxisAlignment: CrossAxisAlignment.center,
```

Save the project. Your home screen should now look like this:

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/136b6248cce28ba6.png)

That looks much better.

### Theme the text fields

You can also theme the decoration on text fields with an **InputDecorationTheme**.

In `app.dart`, in the `_buildShrineTheme()` method, specify an `inputDecorationTheme:` value:

```
// TODO: Decorate the inputs (103)

inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(),
),
```

Right now, the text fields have a `filled` decoration. Let's remove that.

In `login.dart`, remove the `filled: true` values:

```
// Remove filled: true values (103)
TextField(
  controller: _usernameController,
  decoration: InputDecoration(
    // Removed filled: true
    labelText: 'Username',
  ),
),
SizedBox(height: 12.0),
TextField(
  controller: _passwordController,
  decoration: InputDecoration(
    // Removed filled: true
    labelText: 'Password',
  ),
  obscureText: true,
),
```

Click the Stop button, and then Play (to restart the app from the beginning). Your login screen should look like this when the Username field is active (when you're typing in it):

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/ea7b1fcf376cbc1.png)

Type into a text field—decorations and floating placeholder renders in the correct Accent color. But we can't see it very easily. It's not accessible to people who have trouble distinguishing pixels that don't have a high enough color contrast. (For more information, see "Accessible colors" in the Material Guidelines [Color article](https://material.io/design/color/).) Let's make a special class to override the Accent color for a widget to be the PrimaryVariant the designer gave us in the color theme above.

In `login.dart`, add the following outside the scope of any other class:

```
// TODO: Add AccentColorOverride (103)
class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(accentColor: color),
    );
  }
}
```

Next, you'll apply `AccentColorOverride` to the text fields.

In `login.dart`, import the colors:

```
import 'colors.dart';
```

Wrap the Username text field with the new widget:

```
// TODO: Wrap Username with AccentColorOverride (103)
// [Name]
AccentColorOverride(
  color: kShrineBrown900,
  child: TextField(
    controller: _usernameController,
    decoration: InputDecoration(
      labelText: 'Username',
    ),
  ),
),
```

Wrap the Password text field also:

```
// TODO: Wrap Password with AccentColorOverride (103)
// [Password]
AccentColorOverride(
  color: kShrineBrown900,
  child: TextField(
    controller: _passwordController,
    decoration: InputDecoration(
      labelText: 'Password',
    ),
  ),
),
```

Click the Play button.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/added42041a83345.png)

Now that you've styled the page with specific color and typography that matches Shrine, let's take a look at the cards that show Shrine's products. Right now, the cards lay on a white surface next to the site's navigation.

## 6. Adjust elevation

### Adjust Card elevation

In `home.dart`, add an `elevation:` value to the Cards:

```
// TODO: Adjust card heights (103)

    elevation: 0.0,
```

Save the project.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/52920c70743adf6e.png)

You've removed the shadow under the cards.

Let's change the elevation of the components on the login screen to complement it.

### Change the elevation of the NEXT button

The default elevation for RaisedButtons is 2. Let's raise them higher.

In `login.dart`, add an `elevation:` value to the **NEXT** RaisedButton:

```
RaisedButton(
  child: Text('NEXT'),
  elevation: 8.0, // New code
```

Click the Stop button, then Play. Your login screen should now look like this:

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/9346cdffc30760da.png)  

> Notes on elevation:
>
> *  All Material Design surfaces, and components, have elevation values.
> *  The division between where one surface ends and another begins is distinguished by surface edges.
> *  Elevation difference between surfaces can be expressed using dimmed backgrounds, brightened backgrounds, or shadows.
> *  Surfaces in front of other surfaces typically contain more important content.

## 7. Add Shape

Shrine has a cool geometric style, defining elements with an octagonal or rectangular shape. Let's implement that shape styling in the cards on the home screen, and the text fields and buttons on the login screen.

### Change the text field shapes on the login screen

In `app.dart`, import a special cut corners border file:

```
import 'supplemental/cut_corners_border.dart';
```

Still in `app.dart`, add a shape with cut corners to the text field decoration theme:

```
// TODO: Decorate the inputs (103)
inputDecorationTheme: InputDecorationTheme(
  border: CutCornersBorder(), // Replace code
),
```

### Change button shapes on the login screen

In `login.dart`, add a beveled rectangular border to the **CANCEL** button:

```
FlatButton(
  child: Text('CANCEL'),

  shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
  ),
```

The FlatButton has no visible shape, so why are we adding a border shape? So the ripple animation is bound to the same shape when touched.

Now add the same shape to the NEXT button:

```
RaisedButton(
  child: Text('NEXT'),
  elevation: 8.0,
  shape: BeveledRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(7.0)),
  ),
```

> Notes on shape:
>
> *  Shapes can contribute to a brand's visual expression.
> *  Shapes have adjustable curves and corner angless, curves and edge angles, and total number of corners.
> *  A component's shape should not interfere with its usability!

Click the Stop button, and then Play:

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/a05e9659fd90b969.png)

## 8. Change the layout

Next, let's change the layout to show the cards at different aspect ratios and sizes, so that each card looks unique from the others.

### Replace GridView with AsymmetricView

We've already written the files for an asymmetrical layout.

In `home.dart`, change the whole file to the following:

```
import 'package:flutter/material.dart';

import 'model/products_repository.dart';
import 'model/product.dart';
import 'supplemental/asymmetric_view.dart';

class HomePage extends StatelessWidget {
  // TODO: Add a variable for Category (104)

  @override
  Widget build(BuildContext context) {
  // TODO: Return an AsymmetricView (104)
  // TODO: Pass Category variable to AsymmetricView (104)
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('Menu button');
          },
        ),
        title: Text('SHRINE'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: () {
              print('Filter button');
            },
          ),
        ],
      ),
      body: AsymmetricView(products: ProductsRepository.loadProducts(Category.all)),
    );
  }
}
```

Save the project.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/ed68ec421f46e598.png)

Now the products scroll horizontally in a woven-inspired pattern. Also, the status bar text (time and network at the top) is now black. That's because we changed the AppBar's brightness to light, `brightness: Brightness.light`

## 9. Try another theme

Color is a powerful way to express your brand, and a small change in color can have a large effect on your user experience. To test this out, let's see what Shrine looks like if the color scheme of the brand were completely different.

### Modify colors

In `colors.dart`, add the following:

```
const kShrineAltDarkGrey = const Color(0xFF414149);
const kShrineAltYellow = const Color(0xFFFFCF44);
```

In `app.dart`, change the `_buildShrineTheme()` and `_buildShrineTextTheme` functions to the following:

```
ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    accentColor: kShrineAltDarkGrey,
    primaryColor: kShrineAltDarkGrey,
    buttonColor: kShrineAltYellow,
    scaffoldBackgroundColor: kShrineAltDarkGrey,
    cardColor: kShrineAltDarkGrey,
    textSelectionColor: kShrinePink100,
    errorColor: kShrineErrorRed,
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(
      color: kShrineAltYellow
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: CutCornersBorder(),
    ),
  );
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  return base.copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(
      fontSize: 18.0
    ),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  ).apply(
    fontFamily: 'Rubik',
    displayColor: kShrineSurfaceWhite,
    bodyColor: kShrineSurfaceWhite,
  );
}
```

In `login.dart`, color the logo diamond white:

```
Image.asset(
  'assets/diamond.png',
  color: kShrineBackgroundWhite, // New code
),
```

Still in `login.dart`, change the accent override to yellow for both text fields:

```
AccentColorOverride(
  color: kShrineAltYellow, // Changed code
  child: TextField(
    controller: _usernameController,
    decoration: InputDecoration(
      labelText: 'Username',
    ),
  ),
),
SizedBox(height: 12.0),
AccentColorOverride(
  color: kShrineAltYellow, // Changed code
  child: TextField(
    controller: _passwordController,
    decoration: const InputDecoration(
      labelText: 'Password',
    ),
  ),
),
```

In `home.dart`, change the brightness to dark:

```
brightness: Brightness.dark,
```

Save the project. The new theme should now appear.

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/8916ab5abc89be45.png)

![](https://codelabs.developers.google.com/codelabs/mdc-103-flutter/img/dc23dbb043a99db.png)

The result is very different!. Let's revert this color code before moving on to 104.

[Download MDC-104 starter code](https://github.com/material-components/material-components-flutter-codelabs/archive/104-starter_and_103-complete.zip)

## 10. Recap

By now, you've created an app that resembles the design specifications from your designer.

> The completed MDC-103 app is available in the `104-starter_and_102-complete` branch.
>
> You can test your version of the page against the app in that branch.

### Next steps

You've now used the following MDC components: theme, typography, elevation, and shape. You can explore more components and subsystems in the MDC-Flutter library.

Dig into the files in the `supplemental` directory to learn how we made the horizontally scrolling, asymmetric layout grid.

What if your planned app design contains elements that don't have components in the MDC library? In [MDC-104: Material Design Advanced Components](https://codelabs.developers.google.com/codelabs/mdc-104-flutter) we show how to create custom components using the MDC library to achieve a specific look.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
