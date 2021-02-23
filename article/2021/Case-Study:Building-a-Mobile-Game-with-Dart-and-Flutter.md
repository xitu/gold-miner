> * 原文地址：[Case Study: Building a Mobile Game with Dart and Flutter](https://blog.risingstack.com/case-study-dart-flutter-mobile-game/)
> * 原文作者：[Daniel Gergely](https://blog.risingstack.com/author/danielg/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Case-Study:Building-a-Mobile-Game-with-Dart-and-Flutter.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Case-Study:Building-a-Mobile-Game-with-Dart-and-Flutter.md)
> * 译者：
> * 校对者：
# Case Study: Building a Mobile Game with Dart and Flutter

> Master the Hero animation, state management, importing 3rd party dependencies, multiple screens, navigation, storing persistent data, vibration & more..

Hello, and welcome to the last episode of this Flutter series! 👋

In the previous episodes, we looked at some basic **[Dart](https://blog.risingstack.com/learn-dart-language-beginner-tutorial/)** and **[Flutter](https://blog.risingstack.com/flutter-crash-course-javascript/)** concepts ranging from data structures and types, OOP and asynchrony to widgets, layouts, states, and props.

Alongside this course, I promised you (several times) that we’d build a fun mini-game in the last episode of this series - and the time has come.

![https://media.giphy.com/media/l4FGnDqTrkewTIuRy/giphy.gif](https://media.giphy.com/media/l4FGnDqTrkewTIuRy/giphy.gif)

## **The game we’ll build: ShapeBlinder**

The name of the project is **shapeblinder**.

Just a little fun fact: I’ve already built this project in PowerPoint and Unity a few years ago. 😎 If you’ve read my previous, **[React-Native focused series](https://blog.risingstack.com/a-definitive-react-native-guide-for-react-developers/)**, you may have noticed that the name is a bit alike to the name of the project in that one (colorblinder), and that’s no coincidence: this project is a somewhat similar minigame, and it’s the next episode of that casual game series.

We always talk about how some people just have a natural affinity for coding, or how some people *feel* the code after some time. While a series can’t help you getting to this level, we could write some code that we can physically feel when it’s working, so we’ll be aiming for that.

**The concept of this game is that there is a shape hidden on the screen. Tapping the hidden shape will trigger a gentle haptic feedback on iPhones and a basic vibration on Android devices. Based on where you feel the shape, you’ll be able to guess which one of the three possible shapes is hidden on the screen.**

Before getting to code, I created a basic design for the project. I kept the feature set, the distractions on the UI, and the overall feeling of the app as simple and chic as possible. This means no colorful stuff, no flashy stuff, some gentle animations, no in-app purchases, no ads, and no tracking.

![https://blog.risingstack.com/content/images/2020/11/shapeblinder-dart-flutter-game-design.png](https://blog.risingstack.com/content/images/2020/11/shapeblinder-dart-flutter-game-design.png)

We’ll have a home screen, a game screen and a “you lost” screen. A title-subtitle group will be animated across these screens. Tapping anywhere on the home screen will start, and on the lost screen will restart the game. We’ll also have some data persistency for storing the high scores of the user.

The full source code is available on **[GitHub here](https://github.com/RisingStack/shapeblinder)**. You can download the built application from both **[Google Play](https://play.google.com/store/apps/details?id=hu.danielgrgly.shapeblinder)** and **[App Store](https://apps.apple.com/hu/app/shapeblinder/id1523640121)**.

Now go play around with the game, and after that, we’ll get started! ✨

## **Initializing the project**

First, and foremost, I used the already discussed `flutter create shapeblinder` CLI command. Then, I deleted most of the code and created my usual go-to project structure for Flutter:

```
├── README.md
├── android
├── assets
├── build
├── ios
├── lib
│   ├── core
│   │   └── ...
│   ├── main.dart
│   └── ui
│       ├── screens
│       │   └── ...
│       └── widgets
│           └── ...
├── pubspec.lock
└── pubspec.yaml

```

Inside the `lib`, I usually create a `core` and a `ui` directory to separate the business logic from the UI code. Inside the `ui` dir, I also add a `screens` and `widgets` directory. I like keeping these well-separated - however, these are just my own preferences!

Feel free to experiment with other project structures on your own and see which one is the one you naturally click with. (The most popular project structures you may want to consider are MVC, MVVM, or BLoC, but the possibilities are basically endless!)

After setting up the folder structure, I usually set up the routing with some very basic empty screens. To achieve this, I created a few dummy screens inside the `lib/ui/screens/...`. A simple centered text widget with the name of the screen will do it for now:

```
// lib/ui/screens/Home.dart
 
import 'package:flutter/material.dart';
 
class Home extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: Center(
       child: Text("home"),
     ),
   );
 }
}

```

Notice that I only used classes, methods, and widgets that we previously discussed. Just a basic `StatelessWidget` with a `Scaffold` so that our app has a body, and a `Text` wrapped with a `Center`. Nothing heavy there. I copied and pasted this code into the `Game.dart` and `Lost.dart` files too, so that I can set up the routing in the `main.dart`:

```
// lib/main.dart
 
import 'package:flutter/material.dart';
 
// import the screens we created in the previous stepimport './ui/screens/Home.dart';
import './ui/screens/Game.dart';
import './ui/screens/Lost.dart';
 
// the entry point to our appvoid main() {
 runApp(Shapeblinder());
}
 
class Shapeblinder extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'ShapeBlinder',
     // define the theme data// i only added the fontFamily to the default theme
     theme: ThemeData(
       primarySwatch: Colors.grey,
       visualDensity: VisualDensity.adaptivePlatformDensity,
       fontFamily: "Muli",
     ),
     home: Home(),
     // add in the routes// we'll be able to use them later in the Navigator.pushNamed method
     routes: <String, WidgetBuilder>{
       '/home': (BuildContext context) => Home(),
       '/game': (BuildContext context) => Game(),
       '/lost': (BuildContext context) => Lost(),
     },
   );
 }
}

```

**Make sure that you read the code comments for some short inline explanation!** Since we already discussed these topics, I don’t really want to take that much time into explaining these concepts from the ground up - we’re just putting them into practice to see how they work before you get your hands dirty with real-life projects.

## **Adding assets, setting up the font**

You may have noticed that I threw in a `fontFamily: “Muli”` in the theme data. How do we add this font to our project? There are several ways: you could, for example, use the **[Google Fonts package](https://pub.dev/packages/google_fonts)**, or manually add the font file to the project. While using the package may be handy for some, I prefer bundling the fonts together with the app, so we’ll add them manually.

The first step is to acquire the font files: in Flutter, `.ttf` is the preferred format. You can grab the Muli font this project uses from **[Google Fonts here](https://fonts.google.com/specimen/Muli)**.

*(Update: the font has been removed from Google Fonts. You’ll be able to download it soon bundled together with other assets such as the app icon and the `svg`s, or you could also use a new, almost identical font by the very same author, **[Mulish](https://fonts.google.com/specimen/Mulish)**)*.

Then, move the files somewhere inside your project. The `assets/fonts` directory is a perfect place for your font files - create it, move the files there and register the fonts in the `pubspec.yaml`:

```
flutter:
 fonts:
   - family: Muli
     fonts:
       - asset: assets/fonts/Muli.ttf
       - asset: assets/fonts/Muli-Italic.ttf
         style: italic

```

You can see that we were able to add the normal and italic versions in a single family: because of this, we won’t need to use altered font names (like “Muli-Italic”). After this - boom! You’re done. 💥 Since we previously specified the font in the app-level theme, we won’t need to refer to it anywhere else - every rendered text will use Muli from now on.

Now, let’s add some additional assets and the app icon. We’ll have some basic shapes as SVGs that we’ll display on the bottom bar of the Game screen. You can grab every asset (including the app icon, font files, and svgs) **[from here](https://risingstack-blog.s3-eu-west-1.amazonaws.com/2020/flutter/assets.zip)**. You can just unzip this and move it into the root of your project and expect everything to be fine.

Before being able to use your svgs in the app, you need to register them in the `pubspec.yaml`, just like you had to register the fonts:

```
flutter:
 uses-material-design: true
 
 assets:
   - assets/svg/tap.svg
 
   - assets/svg/circle.svg
   - assets/svg/cross.svg
   - assets/svg/donut.svg
   - assets/svg/line.svg
   - assets/svg/oval.svg
   - assets/svg/square.svg
 
 fonts:
   - family: Muli
     fonts:
       - asset: assets/fonts/Muli.ttf
       - asset: assets/fonts/Muli-Italic.ttf
         style: italic

```

And finally, to set up the launcher icon (the icon that shows up in the system UI), we’ll use a handy third-party package **`[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)`**. Just add this package into the `dev_dependencies` below the normal deps in the `pubspec.yaml`:

```
dev_dependencies:
 flutter_launcher_icons: "^0.7.3"

```

...and then configure it, either in the `pubspec.yaml` or by creating a `flutter_launcher_icons.yaml` config file. A very basic configuration is going to be just enough for now:

```
flutter_icons:
 android: "launcher_icon"
 ios: true
 image_path: "assets/logo.png"

```

And then, you can just run the following commands, and the script will set up the launcher icons for both Android and iOS:

```
flutter pub get
flutter pub run flutter_launcher_icons:main

```

After installing the app either on a simulator, emulator, or a connected real-world device with `flutter run`, you’ll see that the app icon and the font family is set.

You can use a small `r` in the CLI to reload the app and keep its state, and use a capital `R` to restart the application and drop its state. (This is needed when big changes are made in the structure. For example, a `StatelessWidget` gets converted into a stateful one; or when adding new dependencies and assets into your project.)

## **Building the home screen**

Before jumping right into coding, I always like to take my time and plan out how I’ll build that specific screen based on the screen designs. Let’s have another, closer look at the designs I made before writing them codez:

![https://blog.risingstack.com/content/images/2020/11/shapeblinder-dart-flutter-game-design.png](https://blog.risingstack.com/content/images/2020/11/shapeblinder-dart-flutter-game-design.png)

We can notice several things that will affect the project structure:

- The `Home` and the `Lost` screen look very identical to each other
- All three screens have a shared `Logo` component with a title (shapeblinder / you lost) and a custom subtitle

So, let’s break down the `Home` and `Lost` screens a bit:

![https://blog.risingstack.com/content/images/2020/11/sb-design-home-breakdown.png](https://blog.risingstack.com/content/images/2020/11/sb-design-home-breakdown.png)

The first thing we’ll notice is that we’ll need to use a **Column** for the layout. (We may also think about the main and cross axis alignments - they are `center` and `start`, respectively. If you wouldn’t have known it by yourself, don’t worry - you’ll slowly develop a feeling for it. Until then, you can always experiment with all the options you have until you find the one that fits.)

After that, we can notice the shared `Logo` or `Title` component and the shared `Tap` component. Also, the `Tap` component says “tap anywhere [on the screen] to start (again)”. To achieve this, we’ll wrap our layout in a `GestureDetector` so that the whole screen can respond to taps.

Let’s hit up `Home.dart` and start implementing our findings. First, we set the background color in the Scaffold to black:

```
return Scaffold(
     backgroundColor: Colors.black,

```

And then, we can just go on and create the layout in the `body`. As I already mentioned, I’ll first wrap the whole body in a `GestureDetector`. It is a very important step because later on, we’ll just be able to add an `onTap` property, and we’ll be just fine navigating the user to the next screen.

Inside the `GestureDetector`, however, I still won’t be adding the `Column` widget. First, I’ll wrap it in a `SafeArea` widget. `SafeArea` is a handy widget that adds additional padding to the UI if needed because of the hardware (for example, because of a notch, a swipeable bottom bar, or a camera cut-out). Then, inside that, I’ll also add in a `Padding` so that the UI can breathe, and inside that, will live our Column. The widget structure looks like this so far:

```
Home
├── Scaffold
│   └── GestureDetector
│   │   └── SafeArea
│   │   │   └── Column

```

Oh, and by the way, just to flex with the awesome tooling of Flutter - you can always have a peek at how your widget structure looks like in the VS Code sidebar:

![https://blog.risingstack.com/content/images/2020/11/VS-Code-sidebar-widget-structure-helper.png](https://blog.risingstack.com/content/images/2020/11/VS-Code-sidebar-widget-structure-helper.png)

And this is how our code looks right now:

```
import 'package:flutter/material.dart';
 
class Home extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.black,
     body: GestureDetector(
       // tapping on empty spaces would not trigger the onTap without this
       behavior: HitTestBehavior.opaque,
       onTap: () {
         // navigate to the game screen
       },
       // SafeArea adds padding for device-specific reasons// (e.g. bottom draggable bar on some iPhones, etc.)
       child: SafeArea(
         child: Padding(
           padding: const EdgeInsets.all(40.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
 
             ],
           ),
         ),
       ),
     ),
   );
 }
}

```

### **Creating `Layout` template**

And now, we have a nice frame or template for our screen. We’ll use the same template on all three screens of the app (excluding the `Game` screen where we won’t include a `GestureDetector`), and in cases like this, I always like to create a nice template widget for my screens. I’ll call this widget `Layout` now:

```
 // lib/ui/widgets/Layout.dartimport 'package:flutter/material.dart';
 
class Layout extends StatelessWidget {
 // passing named parameters with the ({}) syntax// the type is automatically inferred from the type of the variable// (in this case, the children prop will have a type of List<Widget>)
 Layout({this.children});
 
 final List<Widget> children;
 
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.black,
     // SafeArea adds padding for device-specific reasons// (e.g. bottom draggable bar on some iPhones, etc.)
     body: SafeArea(
       child: Padding(
         padding: const EdgeInsets.all(40.0),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: children,
         ),
       ),
     ),
   );
 }
}

```

Now, in the `Home.dart`, we can just import this layout and wrap it in a GestureDetector, and we’ll have the very same result that we had previously, but we saved tons of lines of code because we can reuse this template on all other screens:

```
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
import "../widgets/Layout.dart";
 
class Home extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return GestureDetector(
     // tapping on empty spaces would not trigger the onTap without this
     behavior: HitTestBehavior.opaque,
     onTap: () {
       // navigate to the game screen
     },
     child: Layout(
       children: <Widget>[
 
       ],
     ),
   );
 }
}

```

Oh, and remember this because it’s a nice rule of thumb: **whenever you find yourself copying and pasting code from one widget to another, it’s time to extract that snippet into a separate widget.** It really helps to keep spaghetti code away from your projects. 🍝

Now that the overall wrapper and the GestureDetector is done, there are only a few things left on this screen:

- Implementing the navigation in the `onTap` prop
- Building the `Logo` widget (with the title and subtitle)
- Building the `Tap` widget (with that circle-ey svg, title, and subtitle)

### **Implementing navigation**

Inside the `GestureDetector`, we already have an `onTap` property set up, but the method itself is empty as of now. To get started with it, we should just throw in a `console.log`, or, as we say in Dart, a `print` statement to see if it responds to our taps.

```
onTap: () {
 // navigate to the game screenprint("hi!");
},

```

Now, if you run this code with `flutter run`, anytime you’ll tap the screen, you’ll see “hi!” being printed out into the console. (You’ll see it in the CLI.)

That’s amazing! Now, let’s move forward to throwing in the navigation-related code. We already looked at navigation in the previous episode, and we already configured named routes in a previous step inside the `main.dart`, so we’ll have a relatively easy job now:

```
onTap: () {
 // navigate to the game screen
 Navigator.pushNamed(context, "/game");
},

```

And boom, that’s it! Tapping anywhere on the screen will navigate the user to the game screen. However, because both screens are empty, you won’t really notice anything - so let’s build the two missing widgets!

### **Building the Logo widget, Hero animation with text in Flutter**

Let’s have another look at the `Logo` and the `Tap` widgets before we implement them:

![https://blog.risingstack.com/content/images/2020/11/sb-widgets-breakdown.png](https://blog.risingstack.com/content/images/2020/11/sb-widgets-breakdown.png)

We’ll start with the `Logo` widget because it’s easier to implement. First, we create an empty `StatelessWidget`:

```
// lib/ui/widgets/Logo.dartimport "package:flutter/material.dart";
 
class Logo extends StatelessWidget {
 
}

```

Then we define two properties, `title` and `subtitle`, with the method we already looked at in the `Layout` widget:

```
import "package:flutter/material.dart";
 
class Logo extends StatelessWidget {
 Logo({this.title, this.subtitle});
 
 final String title;
 final String subtitle;
 
 @override
 Widget build(BuildContext context) {
  
 }
}

```

And now, we can just return a `Column` from the `build` because we are looking forward to rendering two text widgets **underneath each other**.

```
@override
Widget build(BuildContext context) {
 return Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: <Widget>[
     Text(
       title,
     ),
     Text(
       subtitle,
     ),
   ],
 );
}

```

And notice how we were able to just use `title` and `subtitle` even though they are properties of the widget. We’ll also add in some text styling, and we’ll be done for now - with the main body.

```
return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: <Widget>[
    Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 34.0,
        color: Colors.white,
      ),
    ),
    Text(
      subtitle,
      style: TextStyle(
        fontSize: 24.0,
        // The Color.xy[n] gets a specific shade of the color
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    ),
  ],
)

```

Now this is cool and good, and it matches what we wanted to accomplish - however, this widget could really use a nice finishing touch. Since this widget is shared between all of the screens, we could add a really cool `Hero` animation. The Hero animation is somewhat like the Magic Move in Keynote. Go ahead and watch this short Widget of The Week episode to know what a `Hero` animation is and how it works:

[https://www.youtube.com/embed/Be9UH1kXFDw](https://www.youtube.com/embed/Be9UH1kXFDw)

This is very cool, isn’t it? We’d imagine that just wrapping our Logo component in a `Hero` and passing a key would be enough, and we’d be right, but the `Text` widget’s styling is a bit odd in this case. First, we should wrap the `Column` in a `Hero` and pass in a key like the video said:

```
return Hero(
 tag: "title",
 transitionOnUserGestures: true,
 child: Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: <Widget>[
     Text(
       title,
       style: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 34.0,
         color: Colors.white,
       ),
     ),
     Text(
       subtitle,
       style: TextStyle(
         fontSize: 24.0,
         // The Color.xy[n] gets a specific shade of the color
         color: Colors.grey[600],
         fontStyle: FontStyle.italic,
       ),
     ),
   ],
 ),
);

```

But when the animation is happening, and the widgets are moving around, you’ll see that Flutter drops the font family and the `Text` overflows its container. So we’ll need to hack around Flutter with some additional components and theming data to make things work:

```
import "package:flutter/material.dart";
 
class Logo extends StatelessWidget {
 Logo({this.title, this.subtitle});
 
 final String title;
 final String subtitle;
 
 @override
 Widget build(BuildContext context) {
   return Hero(
     tag: "title",
     transitionOnUserGestures: true,
     child: Material(
       type: MaterialType.transparency,
       child: Container(
         width: MediaQuery.of(context).size.width,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Text(
               title,
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 34.0,
                 color: Colors.white,
               ),
             ),
             Text(
               subtitle,
               style: TextStyle(
                 fontSize: 24.0,
                 // The Color.xy[n] gets a specific shade of the color
                 color: Colors.grey[600],
                 fontStyle: FontStyle.italic,
               ),
             ),
           ],
         ),
       ),
     ),
   );
 }
}

```

This code will ensure that the text has enough space even if the content changes between screens (which will of course happen), and that the font style doesn’t randomly change while in-flight (or while the animation is happening).

Now, we’re finished with the Logo component, and it will work and animate perfectly and seamlessly between screens.

### **Building the Tap widget, rendering SVGs in Flutter**

The `Tap` widget will render an SVG, a text from the props, and the high score from the stored state underneath each other. We could start by creating a new widget in the `lib/ui/widgets` directory. However, we’ll come to a dead-end after writing a few lines of code as Flutter doesn’t have native SVG rendering capabilities. Since we want to stick with SVGs instead of rendering them into PNGs, we’ll have to use a 3rd party package, **`[flutter_svg](https://pub.dev/packages/flutter_svg)`**.

To install it, we just simply add it to the `pubspec.yaml` into the `dependencies`:

```
dependencies:
 flutter:
   sdk: flutter
 
 cupertino_icons: ^0.1.3
 flutter_svg: any

```

And after saving the file, VS Code will automatically run `flutter pub get` and thus install the dependencies for you. Another great example of the powerful Flutter developer tooling! 🧙

Now, we can just create a file under `lib/ui/widgets/Tap.dart`, import this dependency, and expect things to be going fine. If you were already running an instance of `flutter run`, you’ll need to restart the CLI when adding new packages (by hitting `Ctrl-C` to stop the current instance and running `flutter run` again):

```
// lib/ui/widgets/Tap.dart
 
import "package:flutter/material.dart";
// import the dependencyimport "package:flutter_svg/flutter_svg.dart";

```

We’ll just start out with a simple `StatelessWidget` now, but we’ll refactor this widget later after we implemented storing the high scores! Until then, we only need to think about the layout: it’s a `Column` because children are **underneath** each other, but we wrap it into a `Center` so that it’s centered on the screen:

```
import "package:flutter/material.dart";
// import the dependencyimport "package:flutter_svg/flutter_svg.dart";
 
class Tap extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Center(
     child: Column(
       children: <Widget>[
        
       ],
     ),
   );
 }
}

```

Now you may be wondering that setting the `crossAxisAlignment: CrossAxisAlignment.center` in the `Column` would center the children of the column, so why the `Center` widget?

The `crossAxisAlignment` only aligns children **inside its parent’s bounds**, but the `Column` doesn’t fill up the screen width. (You could, however, achieve this by using the **`[Flexible](https://youtu.be/CI7x0mAZiY0)`** widget, but that would have some unexpected side effects.).

On the other hand, `Center` aligns its children to the center of the screen. To understand why we need the `Center` widget and why setting `crossAxisAlignment` to center isn’t just enough, I made a little illustration:

![https://blog.risingstack.com/content/images/2020/11/sb-alignment-breakdown.png](https://blog.risingstack.com/content/images/2020/11/sb-alignment-breakdown.png)

Now that this is settled, we can define the properties of this widget:

```
 Tap({this.title});
 final String title;

```

And move on to building the layout. First comes the SVG - the `flutter_svg` package exposes an `SvgPicture.asset` method that will return a Widget and hence can be used in the widget tree, but that widget will always try to fill up its ancestor, so we need to restrict the size of it. We can use either a `SizedBox` or a `Container` for this purpose. It’s up to you:

```
Container(
 height: 75,
 child: SvgPicture.asset(
   "assets/svg/tap.svg",
   semanticsLabel: 'tap icon',
 ),
),

```

And we’ll just render the two other texts (the one that comes from the props and the best score) underneath each other, leaving us to this code:

```
import "package:flutter/material.dart";
// import the dependencyimport "package:flutter_svg/flutter_svg.dart";
 
class Tap extends StatelessWidget {
 Tap({this.title});
 final String title;
 
 @override
 Widget build(BuildContext context) {
   return Center(
     child: Column(
       children: <Widget>[
         Container(
           height: 75,
           child: SvgPicture.asset(
             "assets/svg/tap.svg",
             semanticsLabel: 'tap icon',
           ),
         ),
         // give some space between the illustration and the text:
         Container(
           height: 14,
         ),
         Text(
           title,
           style: TextStyle(
             fontSize: 18.0,
             color: Colors.grey[600],
           ),
         ),
         Text(
           "best score: 0",
           style: TextStyle(
             fontSize: 18.0,
             color: Colors.grey[600],
             fontStyle: FontStyle.italic,
           ),
         ),
       ],
     ),
   );
 }
}

```

**Always take your time examining the code examples provided**, as you’ll soon start writing code just like this.

### **Putting it all together into the final Home screen**

Now that all two widgets are ready to be used on our `Home` and `Lost` screens, we should get back to the `Home.dart` and start putting them together into a cool screen.

First, we should import these classes we just made:

```
// lib/ui/screens/Home.dart
 
import "../widgets/Layout.dart";
// ADD THIS:import "../widgets/Logo.dart";
import "../widgets/Tap.dart";

```

And inside the `Layout`, we already have a blank space as children, we should just fill it up with our new, shiny components:

```
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
import "../widgets/Layout.dart";
import "../widgets/Logo.dart";
import "../widgets/Tap.dart";
 
class Home extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return GestureDetector(
     // tapping on empty spaces would not trigger the onTap without this
     behavior: HitTestBehavior.opaque,
     onTap: () {
       // navigate to the game screen
       HapticFeedback.lightImpact();
       Navigator.pushNamed(context, "/game");
     },
     child: Layout(
       children: <Widget>[
         Logo(
           title: "shapeblinder",
           subtitle: "a game with the lights off",
         ),
         Tap(
           title: "tap anywhere to start",
         ),
       ],
     ),
   );
 }
}

```

And boom! After reloading the app, you’ll see that the new widgets are on-screen. There’s only one more thing left: the alignment is a bit off on this screen, and it doesn’t really match the design. Because of that, we’ll add in some `Spacer`s.

In Flutter, a `Spacer` is your `<div style={{ flex: 1 }}/>`, except that they are not considered to be a weird practice here. Their sole purpose is to fill up every pixel of empty space on a screen, and we can also provide them a `flex` value if we want one `Spacer` to be larger than another.

In our case, this is exactly what we need: we’ll need one large spacer before the logo and a smaller one after the logo:

```
Spacer(
 flex: 2,
),
// add hero cross-screen animation for title
Logo(
 title: "shapeblinder",
 subtitle: "a game with the lights off",
),
Spacer(),
Tap(
 title: "tap anywhere to start",
),

```

And this will push everything into place.

## **Building the `Lost` screen, passing properties to screens in Flutter with Navigator**

Because the layout of the `Lost` screen is an exact copy of the `Home` screen except some differences here and there, we’ll just copy and paste the `Home.dart` into the `Lost.dart` and modify it like this:

```
class Lost extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return GestureDetector(
     behavior: HitTestBehavior.opaque,
     onTap: () {
       // navigate to the game screen
       Navigator.pop(context);
     },
     child: Layout(
       children: <Widget>[
         Spacer(
           flex: 2,
         ),
         Logo(
           title: "you lost",
           subtitle: "score: 0",
         ),
         Spacer(),
         Tap(
           title: "tap anywhere to start again",
         ),
       ],
     ),
   );
 }
}

```

However, this just won’t be enough for us now. As you can see, there is a hard-coded “score: 0” on the screen. We want to pass the score as a prop to this screen, and display that value here.

To pass properties to a named route in Flutter, you should create an arguments class. In this case, we’ll name it `LostScreenArguments`. Because we only want to pass an integer (the points of the user), this class will be relatively simple:

```
// passing props to this screen with arguments// you'll need to construct this class in the sender screen, to// (in our case, the Game.dart)class LostScreenArguments {
 final int points;
 
 LostScreenArguments(this.points);
}

```

And we can extract the arguments inside the `build` method:

```
@override
Widget build(BuildContext context) {
 // extract the arguments from the previously discussed classfinal LostScreenArguments args = ModalRoute.of(context).settings.arguments;
 // you'll be able to access it by: args.points
```

And just use the `${...}`string interpolation method in the `Text` widget to display the score from the arguments:

```
Logo(
 title: "you lost",
 // string interpolation with the ${} syntax
 subtitle: "score: ${args.points}",
),

```

And boom, that’s all the code needed for **receiving** arguments on a screen! We’ll look into passing them later on when we are building the Game screen…

## **Building the underlying Game logic**

...which we’ll start right now. So far, this is what we’ve built and what we didn’t implement yet:

- *✅ Logo widget*
    - *✅ Hero animation*
- *✅ Tap widget*
    - *✅ Rendering SVGs*
- *✅ Home screen*
- *✅ Lost screen*
    - *✅ Passing props*
- Underlying game logic
- Game screen
- Drawing shapes
- Using haptic feedback
- Storing high scores - persistent data

So there’s still a lot to learn! 🎓First, we’ll build the underlying game logic and classes. Then, we’ll build the layout for the Game screen. After that, we’ll draw shapes on the screen that will be tappable. We’ll hook them into our logic, add in haptic feedback, and after that, we’ll just store and retrieve the high scores, test the game on a real device, and our game is going to be ready for production!

The underlying game logic will pick three random shapes for the user to show, and it will also pick one correct solution. To pass around this generated data, first, we’ll create a class named `RoundData` inside the `lib/core/RoundUtilities.dart`:

```
class RoundData {
 List<String> options;
 int correct;
 
 RoundData({this.options, this.correct});
}

```

Inside the `assets/svg` directory, we have some shapes lying around. We’ll store the names of the files in an array of strings so that we can pick random strings from this list:

```
// import these!!import 'dart:core';
import 'dart:math';
 
class RoundData {
 List<String> options;
 int correct;
 
 RoundData({this.options, this.correct});
}
 
// watch out - new code below!
Random random = new Random();
 
// the names represent all the shapes in the assets/svg directoryfinal List<String> possible = [
 "circle",
 "cross",
 "donut",
 "line",
 "oval",
 "square"
];

```

And notice that I also created a new instance of the `Random` class and imported a few native Dart libraries. We can use this `random` variable to get new random numbers between two values:

```
// this will generate a new random int between 0 and 5
random.nextInt(5);

```

*The `nextInt`’s upper bound is exclusive, meaning that the code above can result in 0, 1, 2, 3, and 4, but not 5.*

To get a random item from an array, we can combine the `.length` property with this random number generator method:

```
int randomItemIndex = random.nextInt(array.length);

```

Then, I’ll write a method that will return a `RoundData` instance:

```
RoundData generateRound() {
 // new temporary possibility array// we can remove possibilities from it// so that the same possibility doesn't come up twiceList<String> temp = possible.map((item) => item).toList();
 
 // we'll store possibilities in this arrayList<String> res = new List<String>();
 
 // add three random shapes from the temp possibles to the optionsfor (int i = 0; i < 3; i++) {
   // get random index from the temporary arrayint randomItemIndex = random.nextInt(temp.length);
 
   // add the randomth item of the temp array to the results
   res.add(temp[randomItemIndex]);
 
   // remove possibility from the temp array so that it doesn't come up twice
   temp.removeAt(randomItemIndex);
 }
 
 // create new RoundData instance that we'll be able to return
 RoundData data = RoundData(
   options: res,
   correct: random.nextInt(3),
 );
 
 return data;
}

```

Take your time reading the code with the comments and make sure that you understand the hows and whys.

## **Game screen**

Now that we have the underlying game logic in the `lib/core/RoundUtilities.dart`, let’s navigate back into the `lib/ui/screens/Game.dart` and import the utilities we just created:

```
import 'package:flutter/material.dart';
 
// import this:import '../../core/RoundUtilities.dart';
import "../widgets/Layout.dart";
import "../widgets/Logo.dart";

```

And since we’d like to update this screen regularly (whenever a new round is generated), we should convert the `Game` class into a `StatefulWidget`. We can achieve this with a VS Code shortcut (right-click on class definition > Refactor… > Convert to StatefulWidget):

```
class Game extends StatefulWidget {
 @override
 _GameState createState() => _GameState();
}
 
class _GameState extends State<Game> {
 @override
 Widget build(BuildContext context) {
   return Layout(
     children: <Widget>[
       Logo(
         title: "shapeblinder",
         subtitle: "current score: 0 | high: 0",
       ),
     ],
   );
 }
}

```

And now, we’ll build the layout. Let’s take a look at the mock for this screen:

![https://blog.risingstack.com/content/images/2020/11/sb-game-design-breakdown.png](https://blog.risingstack.com/content/images/2020/11/sb-game-design-breakdown.png)

Our screen already contains the shared Logo widget, and we’ll work with drawing shapes a bit later, so we’ll only have to cover

- Proper spacing with `Spacer`s
- Creating a container for our shape
- Drawing the three possible shapes on the bottom of the screen
- Hooking them up to a tap handler
- If the guess is correct, show a `SnackBar` and create a new round
- If the guess in incorrect, end the session and navigate the user to the lost screen

### **Initializing data flow**

So let’s get started! First, I’ll define the variables inside the state. Since this is a `StatefulWidget`, we can just define some variables inside the `State` and expect them to be hooked up to Flutter’s inner state management engine.

I’d also like to give them some values., so I’ll create a `reset` method. It will set the points to zero and create a new round with the generator we created previously. We’ll run this method when the `initState` method runs so that the screen is initialized with game data:

```
class _GameState extends State<Game> {
 RoundData data;
 int points = 0;
 int high = 0;
 final GlobalKey scaffoldKey = GlobalKey();
 
// the initState method is ran by Flutter when the element is first time painted// it's like componentDidMount in React@override
 void initState() {
   reset();
   super.initState();
 }
 
 void reset() {
   setState(() {
     points = 0;
     data = generateRound();
   });
 }
 
 ...

```

And now, we can move on to defining our layout:

### **Initializing the UI**

Now that we have some data we can play around with, we can create the overall layout of this screen. First, I’ll create a runtime constant (or a `final`) I’ll call `width`. It will contain the available screen width:

```
@override
Widget build(BuildContext context) {
 final width = MediaQuery.of(context).size.width;

```

I can use this to create a perfect square container for the shape that we’ll render later:

```
Container(
 height: width / 1.25,
 width: width / 1.25,
),

```

After this comes a simple centered text:

```
Center(
 child: Text(
   "select the shape that you feel",
   style: TextStyle(
     fontSize: 18.0,
     color: Colors.grey[600],
     fontStyle: FontStyle.italic,
   ),
 ),
),

```

And we’ll draw out the three possible shapes in a `Row` because they are positioned next to each other. First, I’ll just define the container:

```
Row(
 mainAxisAlignment: MainAxisAlignment.spaceBetween,
 children: <Widget>[   
  
 ],
),

```

And we can use the state’s `RoundData` instance, `data`, to know which three possible shapes we need to render out. We can just simply map over it and use the spread operator to pass the results into the Row:

```
...data.options.map(
 (e) => Container(
   height: width / 5,
   width: width / 5,
   child: GestureDetector(
     onTap: () => guess(context, e),
     child: SvgPicture.asset(
       "assets/svg/$e.svg",
       semanticsLabel: '$e icon',
     ),
   ),
 ),
),

```

This will map over the three possibilities in the state, render their corresponding icons in a sized container, and add a `GestureDetector` to it so that we can know when the user taps on the shape (or when the user makes a guess). For the `guess` method, we’ll pass the current `BuildContext` and the name of the shape the user had just tapped on. We’ll look into why the context is needed in a bit, but first, let’s just define a boilerplate void and print out the name of the shape the user tapped:

```
void guess(BuildContext context, String name) {
 print(name);
}

```

Now, we can determine if the guess is correct or not by comparing this string to the one under `data.options[data.correct]`:

```
void guess(BuildContext context, String name) {
 if (data.options[data.correct] == name) {
   // correct guess!
   correctGuess(context);
 } else {
   // wrong guess
   lost();
 }
}

```

And we should also create a `correctGuess` and a `lost` handler:

```
void correctGuess(BuildContext context) {
 // show snackbar
 Scaffold.of(context).showSnackBar(
   SnackBar(
     backgroundColor: Colors.green,
     duration: Duration(seconds: 1),
     content: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: <Widget>[
         Icon(
           Icons.check,
           size: 80,
         ),
         Container(width: 10),
         Text(
           "Correct!",
           style: TextStyle(
             fontSize: 24,
             fontWeight: FontWeight.bold,
           ),
         ),
       ],
     ),
   ),
 );
 
 // add one point, generate new round
 setState(() {
   points++;
   data = generateRound();
 });
}
 
void lost() {
 // navigate the user to the lost screen
 Navigator.pushNamed(
   context,
   "/lost",
   // pass arguments with this constructor:
   arguments: LostScreenArguments(points),
 );
 
 // reset the game so that when the user comes back from the "lost" screen,// a new, fresh round is ready
 reset();
}

```

There’s something special about the `correctGuess` block: the `Scaffold.of(context)` will look up the `Scaffold` widget in the context. However, the `context` we are currently passing comes from the `build(BuildContext context)` line, and that context doesn’t contain a Scaffold yet. We can create a new `BuildContext` by either extracting the widget into another widget (which we won’t be doing now), or by wrapping the widget in a `Builder`.

So I’ll wrap the `Row` with the icons in a `Builder` and I’ll also throw in an `Opacity` so that the icons have a nice gray color instead of being plain white:

```
Builder(
 builder: (context) => Opacity(
   opacity: 0.2,
   child: Row(
     mainAxisAlignment: MainAxisAlignment.spaceBetween,
     children: <Widget>[
       ...data.options.map(

```

And now, when tapping on the shapes on the bottom, the user will either see a full-screen green snackbar with a check icon and the text “Correct!”, or find themselves on the “Lost” screen. Great! Now, there’s only one thing left before we can call our app a game - drawing the tappable shape on the screen.

## **Drawing touchable shapes in Flutter**

Now that we have the core game logic set up and we have a nice Game screen we can draw on, it’s time to get dirty with drawing on a canvas. Whilst we could use Flutter’s native drawing capabilities, we’d lack a very important feature - interactivity.

Lucky for us, there’s a package that despite having a bit limited drawing capabilities, has support for interactivity - and it’s called **[touchable](https://pub.dev/packages/touchable)**. Let’s just add it into our dependencies in the `pubspec.yaml`:

```
touchable: any

```

And now, a few words about how we’re going to achieve drawing shapes. I’ll create some custom painters inside `lib/core/shapepainters`. They will extend the `CustomPainter` class that comes from the `touchable` library. Each of these painters will be responsible for drawing a single shape (e.g. a circle, a line, or a square). I won’t be inserting the code required for all of them inside the article. Instead, you can check it out **[inside the repository here](https://github.com/RisingStack/shapeblinder/tree/master/lib/core/shapepainters)**.

Then, inside the `RoundUtilities.dart`, we’ll have a method that will return the corresponding painter for the string name of it - e.g. if we pass “circle”, we’ll get the `Circle CustomPainter`.

We’ll be able to use this method in the `Game` screen, and we’ll pass the result of this method to the `CustomPaint` widget coming from the `touchable` package. This widget will paint the shape on a canvas and add the required interactivity.

### **Creating a CustomPainter**

Let’s get started! First, let’s look at one of the `CustomPainter`s (the other ones only differ in the type of shape they draw on the canvas, so we won’t look into them). First, we’ll initialize an empty `CustomPainter` with the default methods and two properties, `context` and `onTap`:

```
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';
 
class Square extends CustomPainter {
 final BuildContext context;
 final Function onTap;
 
 Square(this.context, this.onTap);
 
 @override
 void paint(Canvas canvas, Size size) {
 }
 
 @override
 bool shouldRepaint(CustomPainter oldDelegate) {
   return false;
 }
}

```

We’ll use the `context` later when creating the canvas, and the `onTap` will be the tap handler for our shape. Now, inside the `paint` overridden method, we can create a `TouchyCanvas` coming from the package:

```
var myCanvas = TouchyCanvas(context, canvas);

```

And draw on it with the built-in methods:

```
myCanvas.drawRect(
 Rect.fromLTRB(
   0,
   0,
   MediaQuery.of(context).size.width / 1.25,
   MediaQuery.of(context).size.width / 1.25,
 ),
 Paint()..color = Colors.transparent,
 onTapDown: (tapdetail) {
   onTap();
 },
);

```

This will create a simple rectangle. The arguments in the `Rect.fromLTRB` define the coordinates of the two points between which the rect will be drawn. It’s `0, 0` and `width / 1.25, width / 1.25` for our shape - this will fill in the container we created on the Game screen.

We also pass a transparent color (so that the shape is hidden) and an `onTapDown`, which will just run the `onTap` property which we pass. Noice!

![https://media.giphy.com/media/KxiRwO7tqXCTDVKobo/giphy.gif](https://media.giphy.com/media/KxiRwO7tqXCTDVKobo/giphy.gif)

This is it for drawing our square shape. I created the other `CustomPainter` classes that we’ll need for drawing a circle, cross, donut, line, oval, and square shapes. You could either try to implement them yourself, or just copy and paste them from **[the repository here](https://github.com/RisingStack/shapeblinder/tree/master/lib/core/shapepainters)**.

### **Drawing the painter on the screen**

Now that our painters are ready, we can move on to the second step: the `getPainterForName` method. First, I’ll import all the painters into the `RoundUtilities.dart`:

```
import 'shapepainters/Circle.dart';
import 'shapepainters/Cross.dart';
import 'shapepainters/Donut.dart';
import 'shapepainters/Line.dart';
import 'shapepainters/Oval.dart';
import 'shapepainters/Square.dart';

```

And then just write a very simple switch statement that will return the corresponding painter for the input string:

```
dynamic getPainterForName(BuildContext context, Function onTap, String name) {
 switch (name) {
   case "circle":
     return Circle(context, onTap);
   case "cross":
     return Cross(context, onTap);
   case "donut":
     return Donut(context, onTap);
   case "line":
     return Line(context, onTap);
   case "oval":
     return Oval(context, onTap);
   case "square":
     return Square(context, onTap);
 }
}

```

And that’s it for the utilities! Now, we can move back into the Game screen and use this `getPainterForName` utility and the canvas to draw the shapes on the screen:

```
Container(
 height: width / 1.25,
 width: width / 1.25,
 child: CanvasTouchDetector(
   builder: (context) {
     return CustomPaint(
       painter: getPainterForName(
         context,
         onShapeTap,
         data.options[data.correct],
       ),
     );
   },
 ),
),

```

And that’s it! We only need to create an `onShapeTap` handler to get all these things working - for now, it’s okay to just throw in a `print` statement, and we’ll add the haptic feedbacks and the vibrations later on:

```
void onShapeTap() {
 print(
   "the user has tapped inside the shape. we should make a gentle haptic feedback!",
 );
}

```

And now, when you tap on the shape inside the blank space, the Flutter CLI will pop up this message in the console. Awesome! We only need to add the haptic feedback, store the high scores, and wrap things up from now on.

## **Adding haptic feedback and vibration in Flutter**

When making mobile applications, you should always aim for designing native experiences on both platforms. That means using different designs for Android and iOS, and using the platform’s native capabilities like Google Pay / Apple Pay or 3D Touch. To be able to think about which designs and experiences feel native on different platforms, you should use both platforms while developing, or at least be able to try out them sometimes.

One of the places where Android and iOS devices differ is how they handle vibrations. While Android has a basic vibration capability, iOS comes with a very extensive haptic feedback engine that enables creating gentle hit-like feedback, with custom intensities, curves, mimicking the 3D Touch effect, tapback and more. It helps the user *feel* their actions, taps, and gestures, and as a developer, it’s a very nice finishing touch for your app to add some gentle haptic feedback to your app. It will help the user feel your app native and make the overall experience better.

Some places where you can try out this advanced haptic engine on an iPhone (6s or later) are the home screen when 3D Touching an app, the Camera app when taking a photo, the Clock app when picking out an alarm time (or any other carousel picker), some iMessage effects, or on notched iPhones, when opening the app switcher from the bottom bar. Other third party apps also feature gentle physical feedback: for example, the Telegram app makes a nice and gentle haptic feedback when sliding for a reply.

Before moving on with this tutorial, you may want to try out this effect to get a feeling of what we are trying to achieve on iOS - and make sure that you are holding the device in your whole palm so that you can feel the gentle tapbacks.

In our app, we’d like to add these gentle haptic feedbacks in a lot of places: when navigating, making a guess, or, obviously, when tapping inside the shape. On Android, we’ll only leverage the vibration engine when the user taps inside a shape or loses.

And since we’d like to execute different code based on which platform the app is currently running on, we need a way to check the current platform in the runtime. Lucky for us, the `dart:io` provides us with a `Platform` API that we can ask if the current platform is iOS or Android. We can use the `HapticFeedback` API from the `flutter/services.dart` to call the native haptic feedback and vibration APIs:

```
// lib/core/HapticUtilities.dart
 
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
 
void lightHaptic() {
 if (Platform.isIOS) {
   HapticFeedback.lightImpact();
 }
}
 
void vibrateHaptic() {
 if (Platform.isIOS) {
   HapticFeedback.heavyImpact();
 } else {
   // this will work on most Android devices
   HapticFeedback.vibrate();
 }
}

```

And we can now import this file on other screens and use the `lightHaptic` and `vibrateHaptic` methods to make haptic feedback for the user that works on both platforms that we’re targeting:

```
// lib/ui/screens/Game.dartimport '../../core/HapticUtilities.dart'; // ADD THIS LINE
 
...
 
void guess(BuildContext context, String name) {
   lightHaptic(); // ADD THIS LINE
 
...
 
void lost() {
   vibrateHaptic(); // ADD THIS LINE
 
...
 
Container(
 height: width / 1.25,
 width: width / 1.25,
 child: CanvasTouchDetector(
   builder: (context) {
     return CustomPaint(
       painter: getPainterForName(
         context,
         vibrateHaptic, // CHANGE THIS LINE
 

```

And on the `Home` and `Lost` screens:

```
// Home.dart// Home.dartreturn GestureDetector(
 // tapping on empty spaces would not trigger the onTap without this
 behavior: HitTestBehavior.opaque,
 onTap: () {
   // navigate to the game screen
   lightHaptic(); // ADD THIS LINE
   Navigator.pushNamed(context, "/game");
 },
 
...
 
// Lost.dartreturn GestureDetector(
 behavior: HitTestBehavior.opaque,
 onTap: () {
   // navigate to the game screen
   lightHaptic(); // ADD THIS LINE
   Navigator.pop(context);
 },

```

...aaaaand you’re done for iOS! On Android, there’s still a small thing required - you need permission for using the vibration engine, and you can ask for permission from the system in the `shapeblinder/android/app/src/main/AndroidManifest.xml`:

```
<manifest ...>
 <uses-permission android:name="android.permission.VIBRATE"/>
 ...

```

Now when running the app on a physical device, you’ll feel either the haptic feedback or the vibration, depending on what kind of device you’re using. Isn’t it amazing? You can literally feel your code!

![https://media.giphy.com/media/tUMbQNPT9SbHG/giphy.gif](https://media.giphy.com/media/tUMbQNPT9SbHG/giphy.gif)

## **Storing high scores - data persistency in Flutter**

There’s just one new feature left before we finish the MVP of this awesome game. The users are now happy - they can feel a sense of accomplishment when they guess right, and they get points, but they can’t really flex with their highest score for their friends as we don’t store them. We should fix this by storing persistent data in Flutter! 💪

To achieve this, we’ll use the **`[shared_preferences](https://pub.dev/packages/shared_preferences)`** package. It can store simple key/value pairs on the device. You should already know what to do with this dependency: go into `pubspec.yaml`, add it into the deps, wait until VS Code runs the `flutter pub get` command automatically or run it by yourself, and then restart the current Flutter session by hitting `Ctrl + C` and running `flutter run` again.

Now that the `shared_preferences` package is injected, we can start using it. The package has two methods that we’ll take use of now: `.getInt()` and `.setInt()`. This is how we’ll implement them:

- We’ll store the high score when the user loses the game
- We’ll retrieve it in the `Tap` widget, and on the `Game` screen

Let’s get started by storing the high score! Inside the `lib/ui/screens/Game.dart`, we’ll create two methods: `loadHigh` and `setHigh`:

```
void loadHigh() async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
 
 setState(() {
   high = prefs.getInt('high') ?? 0;
 });
}
 
void setHigh(int pts) async {
 SharedPreferences prefs = await SharedPreferences.getInstance();
 prefs.setInt('high', pts);
 
 setState(() {
   high = pts;
 });
}

```

And because we’re displaying the high score in the Logo widget, we’ll want to call `setState` when the score is updated - so that the widget gets re-rendered with our new data. We’ll also want to call the `loadHigh` when the screen gets rendered the first time - so that we’re displaying the actual stored high score for the user:

```
// the initState method is ran by Flutter when the element is first time painted// it's like componentDidMount in React@override
void initState() {
 reset();
 loadHigh(); // ADD THISsuper.initState();
}

```

And when the user loses, we’ll store the high score:

```
 void lost() {
   vibrateHaptic();
 
   // if the score is higher than the current high score,// update the high scoreif (points > high) {
     setHigh(points);
   }
 
   ...

```

And that’s it for the game screen! We’ll also want to load the high score on the `Tap` widget, which - currently - is a `StatelessWidget`. First, let’s refactor the `Tap` widget into a `StatefulWidget` by right-clicking on the name of the class, hitting “Refactor…”, and then “Convert to StatefulWidget”.

Then, define the state variables and use the very same methodology we already looked at to load the high score and update the state:

```
class _TapState extends State<Tap> {
 int high = 0;
 
 void loadHigh() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
 
   setState(() {
     high = prefs.getInt('high') ?? 0;
   });
 }

```

Then, call this `loadHigh` method inside the `build` so that the widget is always caught up on the latest new high score:

```
@override
Widget build(BuildContext context) {
 loadHigh();
 
 return Center(
   ...

```

Oh, and we should also replace the hard-coded `“high score: 0”`s with the actual variable that represents the high score:

```
Text(
 "best score: $high",

```

Make sure that you update your code **both in the Game and the Tap widgets**. We’re all set now with storing and displaying the high score now, so there’s only one thing left:

## **Summing our Dart and Flutter series up**

Congratulations! 🎉 I can’t really explain with words how far we’ve come into the whole Dart and Flutter ecosystem in these three episodes together:

- **[First, we looked at Dart and OOP](https://blog.risingstack.com/learn-dart-language-beginner-tutorial/):** We looked at variables, constants, functions, arrays, objects, object-oriented programming, and asynchrony, and compared these concepts to what we’ve seen in JavaScript.
- **[Then, we started with some Flutter theory](https://blog.risingstack.com/flutter-crash-course-javascript/):** We took a peek at the Flutter CLI, project structuring, state management, props, widgets, layouts, rendering lists, theming, and proper networking.
- **Then we created a pretty amazing game together:** We built a cross-platform game from scratch. We mastered the Hero animation, basic concepts about state management, importing third-party dependencies, building multiple screens, navigating, storing persistent data, adding vibration, and more…

I really hope you enjoyed this course! If you have any questions, feel free to reach out in the comments section. It was a lot to take in, but there’s still even more to learn! If you want to stay tuned, subscribe to our newsletter - and make sure that you check out these awesome official Dart and Flutter related resources later on your development journey:

- **[Flutter widget of the week - introducing awesome Flutter widgets in bite-sized videos, weekly](https://www.youtube.com/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)**
- **[Flutter in focus - advanced Flutter topics broken down into smaller pieces by the Flutter team](https://www.youtube.com/playlist?list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2)**
- **[Effective Dart - a complex style, documentation, usage and design series](https://dart.dev/guides/language/effective-dart)**
- **[Flutter Boring Show - building real-world applications from scratch together, with all the rising issues, bad pathways, and best solutions occurring while creating an app](https://www.youtube.com/playlist?list=PLOU2XLYxmsIK0r_D-zWcmJ1plIcDNnRkK)**
- **[Flutter Community Medium - the official community blogging platform for Flutter](https://medium.com/flutter-community)**

I’m excited to see what you all will build with this awesome tool. Happy Fluttering!

All the bests, ❤️Daniel from RisingStack


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
