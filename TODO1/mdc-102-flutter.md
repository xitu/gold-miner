> * 原文地址：[MDC-102 Flutter: Material Structure and Layout (Flutter)](https://codelabs.developers.google.com/codelabs/mdc-102-flutter)
> * 原文作者：[codelabs.developers.google.com](https://codelabs.developers.google.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mdc-102-flutter.md)
> * 译者：
> * 校对者：

# MDC-102 Flutter: Material Structure and Layout (Flutter)

## 1. Introduction

![](https://lh4.googleusercontent.com/yzZPYGHe5CrFE-84MXhqwb_y7YjCKLWQJHI7W7zqbT9_qdK8qufFjx51kepr3ITvZtF7vD3d72nurt-HPBARmQ6RF74PD1FwGZMNbXphLap4LqIEBCKWP5OxK2Vjeo-YEY3-oeIP)Material Components (MDC) help developers implement Material Design. Created by a team of engineers and UX designers at Google, MDC features dozens of beautiful and functional UI components and is available for Android, iOS, web and Flutter.

material.io/develop

In codelab [MDC-101](https://codelabs.developers.google.com/codelabs/mdc-101-flutter), you used two Material Components to build a login page: text fields and buttons with ink ripples. Now let's expand upon this foundation by adding navigation, structure, and data.

### What you'll build

In this codelab, you'll build a home screen for an app called **Shrine**, an e-commerce app that sells clothing and home goods. It will contain:

*   A top app bar
*   A grid list full of products

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/532fe80b3fa3db74.png)

This is the second of 4 codelabs that will guide you through building an app for a product called Shrine. We recommend that you do all of the codelabs in order as they progress through tasks step-by-step.

The related codelabs can be found at:

> *   [MDC-101: Material Components (MDC) Basics](https://codelabs.developers.google.com/codelabs/mdc-101-flutter)
> *   [MDC-103: Material Design Theming with Color, Shape, Elevation and Type](https://codelabs.developers.google.com/codelabs/mdc-103-flutter)
> *   [MDC-104: Material Design Advanced Components](https://codelabs.developers.google.com/codelabs/mdc-104-flutter).
>
> By the end of MDC-104, you'll build an app that looks like this:
>
> ![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/e23a024b60357e32.png)

### MDC components in this codelab

*   Top app bar
*   Grids
*   Cards

> In this codelab, you'll use the default components provided by MDC-Flutter. You'll learn to customize them in [MDC-103: Material Design Theming with Color, Shape, Elevation and Type](https://codelabs.developers.google.com/codelabs/mdc-103-flutter).

### What you'll need

*   The [Flutter SDK](https://flutter.io/setup/)
*   Android Studio with Flutter plugins, or your favorite code editor
*   The sample code

#### To build and run Flutter apps on iOS:

*   A computer running macOS
*   Xcode 9 or newer
*   iOS Simulator, or a physical iOS device

#### To build and run Flutter apps on Android:

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

### Continuing from MDC-101?

If you completed MDC-101, your code should be prepared for this codelab. Skip to step: _Add a top app bar_.

### Starting from scratch?

### Download the starter codelab app

[Download starter app](https://github.com/material-components/material-components-flutter-codelabs/archive/102-starter_and_101-complete.zip)

The starter app is located in the `material-components-flutter-codelabs-102-starter_and_101-complete/mdc_100_series` directory.

### ...or clone it from GitHub

To clone this codelab from GitHub, run the following commands:

```
git clone https://github.com/material-components/material-components-flutter-codelabs.git
cd material-components-flutter-codelabs
git checkout 102-starter_and_101-complete
```

> For more help: [Cloning a repository from GitHub](https://help.github.com/articles/cloning-a-repository/)

> ### The right branch
>
> Codelabs MDC-101 through 104 consecutively build upon each other. So when you finish the code for 102, it becomes the starter code for 103! The code is divided across different branches, and you can list them all with this command:
>
> `git branch --list`
> 
> To see the completed code, checkout the `103-starter_and_102-complete` branch.

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

*   Look for the Flutter Device Selection dropdown menu at the top of your editor screen, and select the device (for example, iPhone SE or Android SDK built for `<version>`).
*   Press the **Play** icon (![](https://lh6.googleusercontent.com/Zu8-cWRMCfIrBGIjj4kSW-j8KBiIqVe33PX8Mht5lSKq00kRB7Na3X0kC4aaiG-G7hqqqLPpgtbxTz-1DdYbq2RiNvc2ZaJzfiu_vVYAh1oOc4TZu85pa42nFqqxmMQWySzLWeU1)).

![](https://lh4.googleusercontent.com/NLXK-hHFYnHBPeQ6NYrKGnXpj9X2es9her6Y14CotXlR-OdSQBXHyRFv1nvhC1AFCmWx7jIG2Ulb7-OmLV_Pru_-kd-3gArn8OKEGTIOInDJlqIUJ7dxTQUsvLVa0CJwEO5EGjeu)

> If you were unable to run the app successfully, stop and troubleshoot your developer environment. Try navigating to `material-components-flutter-codelabs` or if you downloaded the .zip file `material-components-flutter-codelabs-...`) in the terminal and running `flutter create mdc_100_series`.

Success! You should see the Shrine login page from the MDC-101 codelab in the simulator or emulator.

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/db3def4f18a58eed.png)

Now that the login screen looks good, let's populate the app with some products.

## 4. Add a top app bar

The home screen is revealed when the login page is dismissed, with a screen that says "You did it!". That's great! But now our user has no actions to take, or any sense of where they are in the app. To help with that, it's time to add navigation.

> **Navigation** refers to the components, interactions, visual cues, and information architecture that enable users to move through an app. It helps make content and features discoverable, so that tasks are easy to complete.
>
> Learn more in the [Navigation article](https://material.io/design/navigation/) in the Material Guidelines.

Material Design offers navigation patterns that ensure a high degree of usability. One of the most visible components is a top app bar.

> You may know the top app bar as a "Navigation Bar" in iOS, or as simply an "App Bar" or "Header."

To provide navigation and give users quick access to other actions, let's add a top app bar.

### Add an AppBar widget

In `home.dart`, add an AppBar to the Scaffold:

```
return Scaffold(
  // TODO: Add app bar (102)
  appBar: AppBar(
    // TODO: Add buttons and title (102)
  ),
```

Adding the **AppBar** to the Scaffold's `appBar:` field, gives us perfect layout for free, keeping the AppBar at the top of the page and the body underneath.

> **Scaffold** is an important widget in MaterialApps. It provides convenient APIs for displaying all sorts or common Material Components like drawers, snack bars, and bottom sheets. It can even help layout a Floating Action Button.
>
> Learn more about Scaffold in its [Flutter documentation](https://docs.flutter.io/flutter/material/Scaffold-class.html).

Save the project. When the Shrine app updates, click **Next** to see the home screen.

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/431c9976adc79f2.png)

AppBar looks great but it needs a title.

> If the app doesn't update, click the "Play" button again, or click "Stop" followed by "Play."

### Add a Text widget

In `home.dart`, add a title to the AppBar:

```
// TODO: Add app bar (102)  
  appBar: AppBar(
    // TODO: Add buttons and title (102)

    title: Text('SHRINE'),
        // TODO: Add trailing buttons (102)
```

Save the project.

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/a858ee63d25880f2.png)

> By now, you might have noticed what we call a 'platform variance'. Material knows that each platform, Android, iOS, Web, is different. And that users have different expectations for them. For example, on iOS, titles are almost always centered and that is the default behavior supplied by UIKit. On Android, it's left aligned. So if you're using an Android emulator or device, your title should be aligned to the left. For an iOS simulator or device, it should be centered.
>
> See the Material [article](https://material.io/design/platform-guidance/cross-platform-adaptation.html#cross-platform-guidelines) on Cross-platform Adaptation for more information.

Many app bars have a button next to the title. Let's add a menu icon in our app.

### Add a leading IconButton

While still in `home.dart`, set an IconButton for the AppBar's `leading`: field. (Put it before the `title:` field to mimic the leading-to-trailing order):

```
return Scaffold(
  appBar: AppBar(
    // TODO: Add buttons and title (102)
    leading: IconButton(
      icon: Icon(
        Icons.menu,
        semanticLabel: 'menu',
      ),
      onPressed: () {
        print('Menu button');
      },
    ),
```

Save the project.

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/d03789520253636.png)

The menu icon (also known as the "hamburger") shows up right where you'd expect it.

> The [**IconButton**](https://docs.flutter.io/flutter/material/IconButton-class.html) class is a convenient way to incorporate [Material Icons](http://material.io/icons) in your app. It takes an **Icon** widget. Flutter has a whole collection of icons in the **Icons** class. It automatically imports the icons based on a mapping of const strings.
>
> Learn more about the Icons class in its [Flutter documentation](https://docs.flutter.io/flutter/material/Icons-class.html). And learn more about the Icon widget in its [Flutter documentation](https://docs.flutter.io/flutter/widgets/Icon-class.html).

You can also add buttons to the trailing side of the title. In Flutter, these are called "actions".

> **Leading** and **trailing** are terms that express direction, referring to the beginning and ending of text lines in a language-agnostic way. When working in an LTR (left-to-right) language like English, _leading_ means _left_ and _trailing_ means _right_. In an RTL (right-to-left) language like Arabic, _leading_ means _right_ and _trailing_ means _left_.
>
> For more information on UI Mirroring, see the Material Design guidelines on [Bidirectionality](https://material.io/guidelines/usability/bidirectionality.html).

### Add actions

There's room for two more IconButtons.

Add them to the AppBar instance after the title:

```
// TODO: Add trailing buttons (102)
actions: <Widget>[
  IconButton(
    icon: Icon(
      Icons.search,
      semanticLabel: 'search',
    ),
    onPressed: () {
      print('Search button');
    },
  ),
  IconButton(
    icon: Icon(
      Icons.tune,
      semanticLabel: 'filter',
    ),
    onPressed: () {
      print('Filter button');
    },
  ),
],
```

Save your project. Your home screen should look like this:

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/a7020aee9da061dc.png)

Now the app has a leading button, a title, and two actions on the right side. The app bar also displays **elevation** using a subtle shadow that shows it's on a different layer than the content.

> On an Icon class, the **SemanticLabel** field is a common way to add accessibility information in Flutter. It's a lot like [Android's Content Labels](https://support.google.com/accessibility/android/answer/7158690?hl=en) and [iOS' UIAccessibility `accessibilityLabel`](https://developer.apple.com/documentation/uikit/accessibility/uiaccessibility?language=objc). You'll find it on many classes.
>
> The information in this field better explains what this button does to people who use screen readers
>
> For a Widget that doesn't have a `semanticLabel:` field, you can wrap it in a **Semantics** widget. Learn more about the Semantics widget in its [Flutter documentation](https://docs.flutter.io/flutter/widgets/Semantics-class.html).

## 5. Add a card in a grid

Now that our app has some structure, let's organize the content by placing it into cards.

> **Cards** are independent elements that display content and actions on a single subject. They're a flexible way to present similar content as a collection.
>
> Learn more about cards in the [Cards article](https://material.io/guidelines/components/cards.html) of the Material Guidelines.
>
> Learn more about the Card widget in [Building Layouts in Flutter](https://flutter.io/tutorials/layout/).

### Add a GridView

Let's start by adding one card underneath the top app bar. The **Card** widget alone doesn't have enough information to lay itself out where we could see it, so we'll want to encapsulate it in a **GridView** widget.

Replace the Center in the body of the Scaffold with a GridView:

```
// TODO: Add a grid view (102)
body: GridView.count(
  crossAxisCount: 2,
  padding: EdgeInsets.all(16.0),
  childAspectRatio: 8.0 / 9.0,
  // TODO: Build a grid of cards (102)
  children: <Widget>[Card()],
),
```

Let's unpack that code. The GridView invokes the `count()` constructor since the number of items it displays is countable and not infinite. But it needs some information to define its layout.

The `crossAxisCount:` specifies how many items across. We want 2 columns.

> **Cross axis** in Flutter means the non-scrolling axis. The scrolling direction is called the **main axis**. So, if you have vertical scrolling, like GridView does by default, then the cross axis is horizontal.
>
> Learn more in [Building Layouts](https://flutter.io/tutorials/layout/).

The `padding:` field provides space on all 4 sides of the GridView. Of course you can't see the padding on the trailing or bottom sides because there's no GridView children next to them yet.

The `childAspectRatio:` field identifies the size of the items based on an aspect ratio (width over height).

By default, GridView makes tiles that are all the same size.

Adding that all together, the GridView calculates each child's width as follows: `([width of the entire grid] - [left padding] - [right padding]) / number of columns`. Using the values we have: `([width of the entire grid] - 16 - 16) / 2`.

The height is calculated from the width, by applying the aspect ratio:: `([width of the entire grid] - 16 - 16) / 2 * 9 / 8`. We flipped 8 and 9 because we are starting with the width and calculating the height and not the other way around.

We have one card but it's empty. Let's add child widgets to our card.

### Layout the contents

Cards should have regions for an image, a title, and secondary text.

Update the children of the GridView:

```
// TODO: Build a grid of cards (102)
children: <Widget>[
  Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AspectRatio(
          aspectRatio: 18.0 / 11.0,
          child: Image.asset('assets/diamond.png'),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Title'),
              SizedBox(height: 8.0),
              Text('Secondary Text'),
            ],
          ),
        ),
      ],
    ),
  )
],
```

This code adds a Column widget used to lay out the child widgets vertically.

The `crossAxisAlignment: field` specifies `CrossAxisAlignment.start`, which means "align the text to the leading edge."

The **AspectRatio** widget decides what shape the image takes no matter what kind of image is supplied.

The **Padding** brings the text in from the side a little.

The two **Text** widgets are stacked vertically with 8 points of empty space between them (**SizedBox**). We make another **Column** to house them inside the Padding.

Save your project:

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/781ef3ac46a65be3.png)

In this preview, you can see the card is inset from the edge, with rounded corners, and a shadow (that expresses the card's elevation). The entire shape is called the "container" in Material. (Not to be confused with the actual widget class called [Container](https://docs.flutter.io/flutter/widgets/Container-class.html).)

> Aside from the container, all of the elements within cards are actually optional in Material. You can add header text, a thumbnail or avatar, subhead text, dividers, and even buttons and icons.
>
> To learn more about cards' contents, see the [Cards article](https://material.io/guidelines/components/cards.html) of the Material Guidelines.

Cards are usually shown in a collection with other cards. Let's lay them out as a collection in a grid.

## 6. Make a card collection

Whenever multiple cards are present in a screen, they are grouped together into one or more collections. Cards in a collection are coplanar, meaning cards share the same resting elevation as one another (unless the cards are picked up or dragged, but we won't be doing that here).

### Multiply the card into a collection

Right now our Card is constructed inline of the `children:` field of the GridView. That's a lot of nested code that can be hard to read. Let's extract it into a function that can generate as many empty cards as we want, and returns a list of Cards..

Make a new private function after the `build()` function (remember that functions starting with an underscore are private API):

```
// TODO: Make a collection of cards (102)
List<Card> _buildGridCards(int count) {
  List<Card> cards = List.generate(
    count,
    (int index) => Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18.0 / 11.0,
            child: Image.asset('assets/diamond.png'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Title'),
                SizedBox(height: 8.0),
                Text('Secondary Text'),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  return cards;
}
```

Assign the generated cards to GridView's `children` field. Remember to replace everything contained in the GridView with this new code:

```
// TODO: Add a grid view (102)
body: GridView.count(
  crossAxisCount: 2,
  padding: EdgeInsets.all(16.0),
  childAspectRatio: 8.0 / 9.0,
  children: _buildGridCards(10) // Replace
),
```

Save the project:

The cards are there, but they don't show anything yet. Now's the time to add some product data.

### Add product data

The app has some products with images, names, and prices. Let's add that to the widgets we have in the card already

Then, in `home.dart`, import a new package and some files we supplied for a data model:

```
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/products_repository.dart';
import 'model/product.dart';
```

Finally, change `_buildGridCards()` to fetch the product info, and use that data in the cards:

```
// TODO: Make a collection of cards (102)

// Replace this entire method
List<Card> _buildGridCards(BuildContext context) {
  List<Product> products = ProductsRepository.loadProducts(Category.all);

  if (products == null || products.isEmpty) {
    return const <Card>[];
  }

  final ThemeData theme = Theme.of(context);
  final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString());

  return products.map((product) {
    return Card(
      // TODO: Adjust card heights (103)
      child: Column(
        // TODO: Center items on the card (103)
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 18 / 11,
            child: Image.asset(
              product.assetName,
              package: product.assetPackage,
             // TODO: Adjust the box size (102)
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
              child: Column(
               // TODO: Align labels to the bottom and center (103)
               crossAxisAlignment: CrossAxisAlignment.start,
                // TODO: Change innermost Column (103)
                children: <Widget>[
                 // TODO: Handle overflowing labels (103)
                 Text(
                    product.name,
                    style: theme.textTheme.title,
                    maxLines: 1,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    formatter.format(product.price),
                    style: theme.textTheme.body2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }).toList();
}
```

**NOTE:** Won't compile and run yet. We have one more change.

> To style the Text, we use the **ThemeData** from the current **BuildContext**.
>
> To learn more about text styling, see the [Typography article](https://material.io/design/typography/) of the Material Guidelines. To learn more about Theming, continue after this codelab with [MDC-103: Material Theming with Color, Shape, Elevation and Type](http://go/mdc-103-flutter).

Also, change the `build()` function to pass the **BuildContext** to `_buildGridCards()` before you try to compile:

```
// TODO: Add a grid view (102)
body: GridView.count(
  crossAxisCount: 2,
  padding: EdgeInsets.all(16.0),
  childAspectRatio: 8.0 / 9.0,
  children: _buildGridCards(context) // Changed code
),
```

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/7874b38e020afc1d.png)

You may notice we don't add any vertical space between the cards. That's because they have, by default, 4 points of padding on their top and bottom.

Save your project:

The product data shows up, but the images have extra space around them. The images are drawn with a **BoxFit** of `.scaleDown` by default (in this case.) Let's change that to `.fitWidth` so they zoom in a little and remove the extra whitespace.

Change the image's `fit:` field:

```
  // TODO: Adjust the box size (102)
  fit: BoxFit.fitWidth,
```

![](https://codelabs.developers.google.com/codelabs/mdc-102-flutter/img/532fe80b3fa3db74.png)

Our products are now showing up in the app perfectly!

## 7. Recap

Our app has a basic flow that takes the user from the login screen to a home screen, where products can be viewed. In just a few lines of code, we added a top app bar (with a title and three buttons) and cards (to present our app's content). Our home screen is now simple and functional, with a basic structure and actionable content.

> The completed MDC-102 app is available in the `103-starter_and_102-complete` branch.
>
> You can test your version of the page against the app in that branch.

### Next steps

With the top app bar, card, text field, and button, we've now used four core components from the MDC-Flutter library! You can explore even more components by visiting the [Flutter Widgets Catalog](https://flutter.io/widgets/).

While it's fully functioning, our app doesn't yet express any particular brand or point of view. In [MDC-103: Material Design Theming with Color, Shape, Elevation and Type](https://codelabs.developers.google.com/codelabs/mdc-103-flutter), we'll customize the style of these components to express a vibrant, modern brand.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
