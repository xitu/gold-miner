> * 原文地址：[Introducing: Flutter Widget-Maker, a Flutter App-Builder written in Flutter](https://medium.com/flutter-community/introducing-flutter-widget-maker-a-flutter-app-builder-written-in-flutter-231e8d959348)
> * 原文作者：[Norbert](https://medium.com/@norbertkozsir)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-flutter-widget-maker-a-flutter-app-builder-written-in-flutter.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introducing-flutter-widget-maker-a-flutter-app-builder-written-in-flutter.md)
> * 译者：
> * 校对者：

# Introducing: Flutter Widget-Maker, a Flutter App-Builder written in Flutter

Much more than just a layout builder

![](https://cdn-images-1.medium.com/max/1600/1*bZoLu2GwC2seNXdAJ0i7Ow.gif)

This is a widget builder for Flutter. At first, it might look like just another layout builder, but this is going to be so much more.

_Check out the landing page I made for this:_ [_https://norbert515.github.io/widget_maker/website/_](https://norbert515.github.io/widget_maker/website/)

* * *

### Core features

These are the features I feel are the core of the whole project.

_Keep in mind, most of these features are not implemented yet._

#### Code — Visual seamless transition

There is not going to be any copy paste. You can work with the drag and drop interface while simultaneously modifying the code.

![](https://cdn-images-1.medium.com/max/1600/1*9CAO5kdRqpZ3KKyQtjY4UA.gif)

Adjust with minimal effort

#### Stateful editing

Interacting with widgets while also editing its source code.

![](https://cdn-images-1.medium.com/max/1600/1*H3F9CwctvzaFkfcSDiXKHQ.gif)

The App being edited is fully running

#### Editing complex properties easily

Editing BoxDecorations, CustomPaints, and CustomMultiChildLayouts with ease.

* * *

### The core philosophy of this project

**Improve rather than replace**

Unlike some HTML editors — which try to hide the actual HTML and CSS code as good as possible (I get why - CSS is horrible), this editor embraces the power of the underlying code.

Instead of hiding the code under some GUI it generates clear, readable and correct code which happens to be visualized and editable through a GUI.

**No platform restricting**

The widget maker will run on all desktop platforms. In addition to that, it will be able to run on the web thanks to project Hummingbird.

Besides being able to run the editor on mobile, I’ll be looking into actually compiling apps on the phone, I’ve done some research and I’m pretty sure it is possible.

![](https://cdn-images-1.medium.com/max/1600/1*tZoNGhSjm0GUk-vmTGQI0Q.gif)

App running on a tablet

**Does not require any fancy setup**

When opening a dart file containing a widget, widget maker will analyze and automatically pick up on that and suggest showing the visual editor.

**Made for everyone**

Doesn’t matter if you are new to Flutter or have been coding since the alpha. Widget maker will bring value to everyone.

* * *

### Fast feedback-loop

A fast feedback loop is, in my opinion, the biggest productivity boosts you can get. And Flutter does a hell of a good job with its hot-reloads. But there are scenarios which can be improved.

I want to talk about one example: Developing a responsive layout.

What you would do is write the code and check how it looks on a small device, then you’d get your tablet and take a look at how it looks there.

You might also be fortunate enough to have an emulator/ embedder which supports resizes. This is already a huge improvement compared to having multiple physical devices/ emulators open at the same time. But you’d still have to change code — resize the window to a bunch of different sizes and repeat.

The workflow with Widget-Maker might look like the following:

Have differently sized flutter apps open in one GUI which update in real time as you slide a slider which, for example, controls the flex value of one of the Expanded’s.

* * *

### A few teasers for future possibilities

I don’t want to talk about every single idea I have right now, simply because I first want to make it solid before expanding (and I have way too many ideas), but here are some ideas I thought about, which might make it into the application someday:

#### Animations through keyframes

Possible workflow:

Select a property and set a keyframe, press a button or trigger any other action, select the same property and add another keyframe.

The animation code is generated and used on the fly.

#### Writing tests on the fly (without actually writing tests)

Widget tests: automatically generated golden files (images of the widget to compare to) and basics assertions (the color you set is actually used etc.)

Integration tests: Click through your App and assert things (like Robolectric for Android) and then generate widget tests (which can be run headless) and actual on-device tests.

#### Share and download widgets

Similar to pub (the Dart package manager) but focused on widgets.

Key differences being:

1.  No need to add anything to pubspec.yaml
2.  Browse widgets with preview and source code
3.  Drag&Drop in widgets from the web
4.  Share and browse widgets

### Downloading the program

Head over to [https://github.com/Norbert515/flutter_ide/releases/tag/v0.1-alpha](https://github.com/Norbert515/flutter_ide/releases/tag/v0.1-alpha)

Just unzip the folder and run “run.bat”.

If it’s not working try installing the C++ runtime files ([https://aka.ms/vs/15/release/vc_redist.x64.exe](https://aka.ms/vs/15/release/vc_redist.x64.exe))

* * *

### What can you do to make this happen?

I believe this could be a huge thing — but I need feedback.

Before diving in heads deep into this project (what some argue I already have) I need to find out whether people are actually interested in this.

For that purpose, I made the current demo available to download and play around with. But please keep in my, it’s just a demo. There are a few bugs in it and it’s nowhere near finished.

If you do like this project or have feedback please let me know on Twitter, through an e-mail or other communication channels. The more feedback I get the better I can make an informed decision about the future of this project.

_PS. Thanks to_ [_Simon Lightfoot_](https://twitter.com/devangelslondon?lang=en) _for the last minute panic help :)_

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
