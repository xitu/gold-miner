> * 原文地址：[Why Flutter Will Change Mobile Development for the Best](https://android.jlelse.eu/why-flutter-will-change-mobile-development-for-the-best-c249f71fa63c)
> * 原文作者：[Aaron Oertel](https://android.jlelse.eu/@aaronoe?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-flutter-will-change-mobile-development-for-the-best.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-flutter-will-change-mobile-development-for-the-best.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[Starrier](https://github.com/Starriers)、[jellycsc](https://github.com/jellycsc)

# 为什么 Flutter 能最好地改变移动开发

如果你是一个 Android 开发者，那么你应该听说过 Flutter。这是一个相对来说比较新的，用于制作跨平台原生应用的简单框架。这不是同类产品中的第一款，但它正被谷歌使用，这让它有了一定的可信度。尽管我一开始听到这个框架的时候对此有所保留，但我还是心血来潮地决定给它一个机会 —— 这在一周内极大地改变了我对移动开发的看法。以下是我学到的。

![](https://cdn-images-1.medium.com/max/1000/0*sKxcvPKWwr0G3FYg.)

“长喙蜂鸟在空中飞翔”，摄影者：来自 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 的 [Randall Ruiz](https://unsplash.com/@ruizra?utm_source=medium&utm_medium=referral)。

在我们开始之前，让我增加一个简短的免责声明。我在这篇文章中编写的和将要引用的应用程序是相对基础的，并且**不会**包含大量的商业逻辑。这虽然没什么特别的，但是我想把我从原生 Android 应用移植到 Flutter 中学到的知识和经验分享给大家，这也是我最好的例子。该应用没有在优化架构方面作出任何努力，这纯粹是为了体验开发和使用框架本身。

* * *

整整一年前，我在 [Play Store](https://play.google.com/store/apps/details?id=de.aaronoe.cinematic&hl=en) 上发布了我的第一个 Android 应用。这个应用 ([Github](https://github.com/aaronoe/Cinematic)) 在架构和编码规范方面都非常基础。这是我的第一个大型开源项目，这表明，我从事 Android 应用开发已经很久了。我在一家代理公司工作，平时会花时间在一些有着不同技术和架构的项目上，包括 Kotlin、Dagger、RxJava、MVP、MVVM、VIPER 等等，这些都很大程度上提高了我的 Android 开发能力。

话虽这么说，在过去的几个月里，我一直对 Android 框架非常失望，尤其是其兼容性差，在开发应用时经常会发现它违反直觉的地方。更别提编译构建的时间了……（我推荐你读一下[这篇文章](https://medium.com/@steve.yegge/who-will-steal-android-from-google-af3622b6252e)，其中有更深入的细节分析），尽管 Kotlin 和类似 Databinding 这样的工具能让问题有所改善，但整个情况还是感觉在一个太大而无法愈合的伤口上贴创可贴。下面开始了解 Flutter。

* * *

几个星期前，当 Flutter 进入 beta 测试版的时候，我就开始使用它了。我看了一下官方文档（顺便一提，写的很棒），然后开始浏览代码实验室和指南。我开始逐渐理解 Flutter 背后的基本理念，并决定自己试一试，看能不能把它付诸于实践。我开始思考我应该先做一个什么样的项目，我决定重写我的第一个 Andriod 项目。这似乎是一个恰当的选择，因为这能让我将同样的“第一次的努力”在两个对应的框架下进行比较，而同时对应用架构等等的方面不作太多关注。它纯粹是通过开发一组定义好的功能特性来了解 SDK。

我首先创建了网络请求，解析 JSON 数据，并逐渐习惯 Dart 的单线程并发模型（单单这个就可以作为另一整文章的主题）。我开始在我的应用中运行一些电影数据，然后开始为列表和列表项创建布局。在 Flutter 中创建布局和扩展无状态或有状态的小控件类加上一些方法的重写一样简单。我将比较 Flutter 和 Andriod 之间在实现这些功能方面的差异。让我们从在 Andriod 中构建这个列表的步骤开始：

1.  在 XML 文件中创建列表项布局文件
2.  创建 adapter 来扩充 item-views 和设置数据
3.  创建 list 的布局（在 Activity 或 Fragment 中）
4.  在 Fragment 或 Activity 中调用 inflate 方法来创建 list 布局
5.  在 Fragment 或 Activity 中创建 adapter 实例，layout-manager 等等
6.  在后台线程上，下载来自网络上的电影数据
7.  回到主线程上，将 item 设置在 adapter 上
8.  现在我们需要考虑一些细节，比如保存和恢复 list-state 等
9.  …… 列表一直这样继续下去

当然，这很乏味。如果你想到这样一件事，开发这些功能是一个相当常见的任务 —— 说真的，这不是一些你不可能碰到的特别罕见的用例 —— 你可能会想：真的没有更好的方法来实现吗？一种不那么容易出错的方法也许是能够涉及更少的模板代码，并且可以提高开发速度。 这时候 Flutter 诞生了。

* * *

你可以把 Flutter 看作是人们多年来在移动应用开发、状态管理、应用架构等方面所学到经验的结果，这就是为什么它和 React.js 如此相似的原因。一旦你开始编写代码，Flutter 就会变得有意义。让我们看看如何运用 Flutter 来实现上面的例子：

1.  为电影 item 创建一个无状态的控件（无状态，因为我们只有静态属性），该控件的构造函数参数是 movie（例如Dart类），并以一种声明的方式描述该布局，同时将 movie 的值（电影名称，上映日期等）绑定到控件中。
2.  同样地为 list 也创建一个控件。（为了这篇文章，我尽量把例子保持地简单些。显然，我们需要添加错误状态等等，这只是开发过程的其中一件事情而已。）

```
@override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: widget.provider.loadMedia(widget.category),
        builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
          return !snapshot.hasData
              ? new Container(
                  child: new CircularProgressIndicator(),
                )
              : new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      new MovieListItem(snapshot.data[index]),
                );
        }
    );
  }
```

Movie-List-Screen 布局部分。

为了解决这个问题，让我们来看看这里发生了什么。最重要的是，我们使用了 **FutureBuilder** （Flutter SDK 的一部分），它要求我们指定一个 [**Future**](https://www.dartlang.org/tutorials/language/futures) (我们例子中的 API 调用) 和 builder 函数。builder 函数给了我们一个 **BuildContext** 和要返回 item 的**索引值**。 利用这个，我们可以检索一部电影，根据 Future 和快照结果的 list，并且创建一个 MovieListItem-Widget（在步骤 1 中创建）作为构造函数的参数。

然后，当 build 方法第一次被调用时，我们就开始等待 Future 的值。一旦有值之后，builder 会再次被数据（快照）调用，我们就可以用它来构建我们的 UI 界面。

这两个类，加上 API 的调用，将会有以下这样的效果：

![](https://cdn-images-1.medium.com/max/800/1*dQ3pH7pxROf1O6jsLFrN5Q.png)

已完成的电影列表功能。

* * *

嗯，这很简单。几乎是太简单了…… 意识到用 Flutter 来创建一个 list 是多么容易，这就激起了我的好奇心，让我更加兴奋地用它来继续开发。

下一步来弄清楚如何使用更加复杂的布局。原生应用程序的电影细节页面有一个相当复杂的布局，包括约束布局和一个应用程序栏。我认为这是用户所期望和欣赏的功能，如果 Flutter 真的想有机会与 Andriod 对抗，它需要能够提供更复杂的布局，就像这样。让我们看看我创建了什么：

![](https://cdn-images-1.medium.com/max/800/1*lBuPSg7dSWvOD0LNd5E-Fw.png)

电影细节的页面。

这个布局由一个 **SliverAppBar** 组成，里面包含了电影图片的层叠布局、渐变、小气泡和文本覆盖。能够以模块化的方式表达布局使得创建这个相当复杂的布局变得非常简单。这个页面的实现方法如下所示：

```
@override
Widget build(BuildContext context) {
  return new Scaffold(
      backgroundColor: primary,
      body: new CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(widget._mediaItem),
          _buildContentSection(widget._mediaItem),
        ],
      )
  );
}
```

详细页面的主要构建方法。

在构建布局的时候，我发现自己把布局的一部分模块化为变量、方法或者其他小部件。例如，图片顶部的文本气泡只是另一个小部件，它以文本和背景颜色作为参数。创建一个自定义视图简直就像这样简单：

```
import 'package:flutter/material.dart';

class TextBubble extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  TextBubble(this.text,
      {this.backgroundColor = const Color(0xFF424242),
      this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(12.0)),
      child: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        child: new Text(
          text,
          style: new TextStyle(color: textColor, fontSize: 12.0),
        ),
      ),
    );
  }
}
```

TextBubble 部件类。

想象一下在安卓系统中建立这样的自定义视图会有多难。然而，在 Flutter 上，这只是一件几分钟就能完成的事情。能够将 UI 界面的一部分提取到像小部件这样的独立单元中，可以很容易地在应用程序中重用这些小部件，甚至跨越不同的应用。你会注意到，这个布局的很多部分都是我们在应用的不同视图上重复使用的，让我告诉你：这实施起来小菜一碟，所以我决定将应用扩展到包含电视节目。几个小时之后，这件事情就完成了。这款应用集电影和电视节目于一体，在这个过程中并没有让人很头疼。我通过构建用于加载和显示数据的泛型类来做到这一点，这让我可以重用**每个布局**用于电影和节目。但是，为了在 Android 上完成同样的事情，我不得不在电影和节目中使用不同的 Activity。你可以想象这维护起来的速度有多快，但是我觉得 Andriod 不够灵活，无法以一种更干净、更简单的方式去共享这些布局。

* * *

在 Flutter 实验的最后，我得出了非常直接和更有说服力的结论：

> 我编写出了同时运行在 iOS 和 Andriod 上的更好、更容易维护的代码，并且只需要相当少的时间和更少的代码数量。

其中最好的部分是不用处理像 fragments 和 **SupportCompatFragmentManagerCompat** 这样的事情，并且以一种单调、容易出错的方式保存和手动管理状态。它没有像 Andriod 开发那样令人沮丧…… 不用再等待 30 秒的“即时重载”来更改 TextView 的字体大小。不再使用 XML 来布局。不再使用 findViewById（我知道有 Butterknife, Databinding, Kotlin-Extensions 这样的工具，但你应该明白我的意思）。不再有冗杂的样板代码 —— 只有结果。

一旦这两个应用在功能上或多或少都写在同一页面上时，我很想知道代码行数之间有没有什么区别。一个 repository 仓库和另一个之间相比如何？（快速免责声明：我还没有在 Flutter 应用中集成持久存储，而且原始应用的代码库相当混乱）。让我们用 [Cloc](https://github.com/AlDanial/cloc) 来比较下代码，为了简单起见，让我们看看 Android 上的 Java 和 XML 文件，Flutter 应用上的 Dart 文件数量（不包括第三方库，这可能会大大增加 Android 的度量）。

用 Java 编写原生 Android 应用：

```
Meta-Data for the native Android app

http://cloc.sourceforge.net v 1.60  T=0.42 s (431.4 files/s, 37607.1 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
Java                             83           2405            512           8599
XML                              96            478             28           3577
Bourne Again Shell                1             19             20            121
DOS Batch                         1             24              2             64
IDL                               1              2              0             15
--------------------------------------------------------------------------------
SUM:                            182           2928            562          12376
```

Flutter:

```
Meta-Date for the Flutter app

http://cloc.sourceforge.net v 1.60  T=0.16 s (247.5 files/s, 14905.1 lines/s)
--------------------------------------------------------------------------------
Language                      files          blank        comment           code
--------------------------------------------------------------------------------
Dart                             31            263             39           1735
Bourne Again Shell                1             19             20            121
DOS Batch                         1             24              2             64
XML                               3              3             22             35
YAML                              1              9              9             17
Objective C                       2              4              1             16
C/C++ Header                      1              2              0              4
--------------------------------------------------------------------------------
SUM:                             40            324             93           1992
--------------------------------------------------------------------------------
```

为了解决这个问题，让我们先比较一下文件数量：
Android： 179 (.java 和 .xml)
Flutter： 31 (.dart)
哇！还有文件中的代码行数：
Android：12176
Flutter： 1735

这让人难以置信！我原以为 Flutter 应用的代码量可能只有原生 Andriod 应用的一半，结果竟然**减少了 85%**？这真的让我始料未及。但是当你开始思考这个问题的时候，你会发现很有意义：因为所有的布局、背景、图标等都需要在 XML 中指定，但是仍然需要使用 Java 或 Kotlin 代码链接到应用中，当然会存在大量的代码。另一方面，Flutter 可以同时完成所有这些操作，同时将这些值绑定到 UI 界面中。你可以做到这一切，而不需要处理 Andriod 数据绑定的缺陷，比如设置监听器或处理生成的绑定代码。我开始意识到在 Android 上开发这些基本的功能是多么的麻烦。为什么我们要为 Fragment/Activity 参数、adapter、状态管理和恢复写一堆同样的代码呢？

> 通过 Flutter，你只会关注你的产品和如何开发产品。SDK 给人的感觉更多的是帮助，而不是一种负担。

当然，这仅仅是 Flutter 的开始，因为它仍然处于测试阶段，尚未达到像 Android 的成熟程度。然而，相比之下，Android 似乎已经达到了极限，我们可能很快就会用 Flutter 去编写我们的Andriod 应用。现在还有一些问题有待解决，但总的来说， Flutter 的未来一片光明。我们已经为 Android Studio、VS Code 和 IntelliJ 、分析器和视图检查工具提供了很好的插件，而且还会有更多的工具。这一切都让我相信 Flutter 不仅会是另一个跨平台的框架，更是一个更大的开端 —— 应用开发新纪元的开始。

并且 Flutter 可以远远超越 Android 和 iOS 领域。如果你一直在关注小道消息，你可能已经听说谷歌正在开发一款名为 Fuchsia 的新操作系统。事实证明，Fuchsia 的 UI 界面是用 Flutter 所构建的。

* * *

当然，你可能会问自己：我现在是不是必须学习一个全新的框架吗？我们刚刚开始学习关于 Kotlin 和使用一些架构组件，现在一切都很好。为什么我们要去了解 Flutter 呢？但是让我告诉你：在使用 Flutter 之后，你将开始了解 Android 开发的问题，并且可以清楚地看到，Flutter 的设计更适合现代的、响应式的应用。

当我第一使用 Android 的 数据绑定框架 Databinding 时候，我认为它是革命性的，但它也感觉像一个不完整的产品。在处理布尔表达式的时候，监听器和更复杂的布局对 Databinding 来说是冗长乏味的一个步骤，这让我意识到 Andriod 不应是为这样的工具设计的。现在如果你看一下 Flutter，它使用了与 Databinding 相同的理念，它将你的视图或控件绑定到变量中，而无需手动在 Java 或 Kotlin 中实现，同时它不需要通过生成绑定文件来连接 XML 和 Java。这让你可以将之前至少一个 XML 和 Java 文件压缩成一个可重用的 Dart 类。

我还认为，Android 上的布局文件不能单独地做任何事情。它们首先必须调用 inflate 方法，只有这样我们才能设值。同时引入了状态管理的问题，并提出一个问题：当基础值改变的时候，我们怎么办？手动抓取对应视图的引用并重新赋值？这种解决方法非常容易出错，我不认为像这样管理视图的方法是好的。相反，我们应该使用状态来描述我们的布局，并且每当状态发生变化时，让框架通过重新呈现其值发生变化的视图来接管。这样，我们的应用程序状态就不会与视图显示的内容不同步了。Flutter 就是这么做的！

可能还有更多的问题：你有没有曾经问过自己为什么在 Android 上创建一个工具栏菜单是如此复杂？为什么我们要用 XML 来描述菜单项，而且在这里我们不能将任何业务逻辑绑定它上面（这就是菜单的全部目的），我们只能在  Activity/Fragment 的回调中编写，然后再在**另一个**回调中绑定点击监听器。为什么我们不能像 Flutter 一样一次性完成这些事情？

```
class ToolbarDemo extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.star), 
              onPressed: _handleClickFavorite
          ),
          new IconButton(
              icon: new Icon(Icons.add), 
              onPressed: _handleClickAdd
          )
        ],
      ),
      body: new MovieDetailScreen(),
    );
  }

  _handleClickFavorite() {}

  _handleClickAdd() {}
}
```

用 Flutter 将菜单 items 添加至 Toolbar。

正如在代码段所见，我们将菜单 items 作为 **Action** 添加在 **AppBar**。这就是你接下来要做的 —— 不再将图标导入到 XML 文件中，不需要再重写回调了。这就像在控件树上添加一些控件一样简单。

* * *

虽然我可以一直往下说，但是你要知道：想想你不喜欢 Andriod 开发的所有事情，然后考虑如何解决这些问题的同时，重新设计框架。这是一项艰巨的任务，但是这样做可以帮你理解为什么 Flutter 会出现，更重要的是，它为什么可以留下来。公平地说，有很多应用（从现在开始）我仍然会用原生的 Andriod 和 Kotilin 一起编写，原生 Android 也许有它的缺点，但它也有它的好处。但是说到底，我认为用了 Flutter 之后，仍使用原生 Andriod 来开发一个应用会变得越来越难。

* * *

顺带一提，这两个应用都是开源的，而且都在 PlayStore 上。你可以在这找到：
原生 Android：[Github](https://github.com/aaronoe/Cinematic) 和 [PlayStore](https://play.google.com/store/apps/details?id=de.aaronoe.cinematic) Flutter：[Github](https://github.com/aaronoe/FlutterCinematic) 和 [PlayStore](https://play.google.com/store/apps/details?id=de.aaronoe.moviesflutter)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
