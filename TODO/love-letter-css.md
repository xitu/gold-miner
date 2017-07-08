> * 原文地址：[A Love Letter to CSS](http://developer.telerik.com/topics/web-development/love-letter-css/)
> * 原文作者：[TJ VanToll](http://developer.telerik.com/author/tvantoll/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[reid3290](https://github.com/reid3290)
> * 校对者：[changkun](https://github.com/changkun)，[CACppuccino](https://github.com/CACppuccino)

# 一封写给 CSS 的情书

![http://developer.telerik.com/wp-content/uploads/2017/05/css_love_header.jpg](http://developer.telerik.com/wp-content/uploads/2017/05/css_love_header.jpg)

当我和同事们谈及我对 CSS 的热爱有增无减时，他们一个个盯着我看，好像我做了个不幸的人生决定一样。

> “TJ，来坐这，我们来聊聊你小时候做的那个糟糕的选择是如何注定你一生的失败的。”

有时候我觉得开发者们 —— 这星球上最固执己见的一批人 —— 只有一条共识：CSS 是最垃圾的。

![](https://ws2.sinaimg.cn/large/006tNc79gy1fgcf54bv9uj30eo062dga.jpg)

嘲讽 CSS 是在技术大会上博众人一笑的最佳手段之一，黑 CSS 的表情包也早已泛滥成灾，我觉得不放两个在这都对不起大家。

![](http://developer.telerik.com/wp-content/uploads/2017/05/css-mug.jpg)
![](http://developer.telerik.com/wp-content/uploads/2017/05/css-blinds.gif)

但是今天我要给你们洗洗脑了。我要说服你相信 CSS 是你日常所使用的最好的技术之一，CSS设计精美，每次你打开 `.css` 文件的时候都应该心存感激！

我的论点相当简单明了：为构建复杂的用户界面创建一个全面的样式系统是非常困难的，任何 CSS 的替代方案都只会比 CSS 更糟而已。

为了论证我的观点，我会将 CSS 同其他几种样式系统相比较，首先来看一种比较古老的技术。

## 天哪，还记得 Java applets 吗？

大学期间我曾用 Java applets 技术编写过一些应用，这是一种现在几乎已经被淘汰了的技术。Java appltes 基本上就是一些 Java 应用，你可以使用 `<applet>` 标签随意地将其嵌入浏览器中。运气好的话，可能有一半用户在本地安装了版本正确的 Java，并能成功运行你的应用。 

![](http://developer.telerik.com/wp-content/uploads/2017/05/java-applet.jpg)

**一个简单的 Java applet，带你回到 90 年代末**

Java applets 在 1995 年推出，并在随后的几年里逐渐流行了起来。如果你在 90 年代末就已经在出来浪了的话，那你应该记得那场关于 web 技术和 Java applets 的技术论战。

和大多数用于构建用户界面的技术一样，Java applets 允许你改变用户界面上各种控件的外观。而且由于 Java applets 被视为 web 开发的合理替代技术，有时会将在 applets 中进行控件布局的便捷性和用 web 技术实现相同的功能作比较。

Java applets 显然没有使用 CSS，那它究竟是如何进行 UI 布局的呢？并不容易。
尝试用谷歌搜索“在 Java applet 中改变按钮颜色”，[返回的第一条结果代码如下：](http://www.java-examples.com/change-button-background-color-example).

```
/*
        改变按钮背景颜色的例子
        该 java 示例展示了如何使用 AWT Button 类改变按钮背景颜色
*/

import java.applet.Applet;
import java.awt.Button;
import java.awt.Color;

public class ChangeButtonBackgroundExample extends Applet{

    public void init(){

        //创建按钮
        Button button1 = new Button("Button 1");
        Button button2 = new Button("Button 2");

        /*
          * 为了改变按钮背景颜色，使用
          * setBackground(Color c) 方法。
          */

        button1.setBackground(Color.red);
        button2.setBackground(Color.green);

        //添加按钮
        add(button1);
        add(button2);
    }
}
```
首先应该注意的是，Java applets 没有提供将代码逻辑和样式进行分离的方法，就像你可能在网页上使用 HTML 和 CSS 一样。它将作为本文剩余部分的主题。

其次，创建两个按钮并改变其背景颜色需要编写**大量**代码。此刻你要是在想，“呵呵，这种方法在开发实际应用的时候很快就会变得不可控了”，那么你便开始能理解为什么 web 技术最终战胜了 Java Applets 了。


话虽如此，但我知道你在想什么。

> “TJ，你还没有完全说服我 CSS 的样式系统比 Java Applet 的更好呢。你这标准应该设得更高一点嘛。”

没错，Java applet 的可视化 API 并非界面设计的黄金准则，因此让我们将注意力转到当前的开发中来：Android 应用。

## 为什么说 Android 应用的样式布局很难？

在某些方面，Android 可以说是现代化的高级版 Java applets。同 Java applets 一样，Android 也使用 Java 作为开发语言。 （不过，根据[谷歌最近在 Google I/O 大会上的声明]((https://techcrunch.com/2017/05/17/google-makes-kotlin-a-first-class-language-for-writing-android-apps/))，你很快就能使用 Kotlin 语言了。）但与 Java applets 不同的是，Android 包含一系列约定，使得构建用户界面更加容易，也更像是在构建 web 应用。

在 Android 应用中，界面控件的定义写在 XML 文件中，而与这些控件交互的逻辑则写在单独的 Java 文件中。这点很像 web 应用 —— HTML 文件负责标签结构，独立的 JavaScript 文件负责行为逻辑。

如下代码是一个非常简单的 Android “activity”（基本就是个页面）的标签结构：

```
<?xml version="1.0" encoding="utf-8"?>
<android.support.constraint.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context="com.telerik.tj.testapp.MainActivity">

    <Button
        android:id="@+id/button"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="Hello World" />

</android.support.constraint.ConstraintLayout>
```
这对 web 开发者而言可能会有点晕，但请记住，一个基本的“index.html”文件也有其怪异之处。 你在这里看到的是两个 UI 组件，一个 `<android.support.constraint.ConstraintLayout>` 和一个 `<android.widget.Button>`，每个组件又有各种属性。直观起见，上述应用在 Android 手机上的运行效果如下图所示。

![](http://developer.telerik.com/wp-content/uploads/2017/05/simple-android-app.jpg)

让我们回到本文主旨上来，如何为这些组件赋予样式呢？和 web 中的 `style` 属性类似，基本上 Android 的每个 UI 组件都有各种属性，你可以为这些属性赋值来控制组件的外观。

例如，如果你想改变上例中按钮的背景颜色，你可以使用 `android:background` 属性。在下面的代码中我便应用了该属性使按钮背景变为红色。

```
<Button
    android:id="@+id/button"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Hello World"
    android:background="#ff0000" />
```

![](http://developer.telerik.com/wp-content/uploads/2017/05/android-red-button.jpg)

到现在为止还挺好。 Google 推荐的 Android 开发环境 Android Studio 甚至提供了一个强大的可视化编辑器，可以很容易地配置其中的一些常见属性。 下面的图片显示了这个示例应用程序在 Android Studio 中的设计视图。 请注意，你可以使用屏幕右侧的窗格轻松配置诸如“背景”等属性。

![](http://developer.telerik.com/wp-content/uploads/2017/05/android-visual-editor.jpg)

通过类似设计试图这样的工具，将一些基础样式应用于 Android 界面控件是非常简单的。不过，Android 的优点也就止于此了。

实际应用开发所需要的可远不止基础样式，根据我个人的经验，处理复杂样式是 Android 代码之冗余而 CSS 代码之简洁的分水岭。举例来说，假设你需要创建一个易于复用的键值对的集合——类似于 CSS 中的 class。在 Android 中也可以做类似的事情，不过很快就会变得一团糟。

Android 应用有一个 `styles.xml` 文件，可以在其中创建具有层级结构的 XML 代码块。例如，假设你想要应用中所有的按钮都具有红色的背景，那你可以使用如下代码创建一个 “RedTheme” 样式：

```
<style name="RedTheme" parent="@android:style/Theme.Material.Light">
  <item name="android:buttonStyle">@style/RedButton</item>
</style>

<style name="RedButton" parent="android:Widget.Material.Button">
  <item name="android:background">#ff0000</item>
</style>
```

如此，你便可以将 `android:theme="@style/RedTheme"` 属性应用到对应的顶层 UI 组件中。如下代码所示，我将该属性应用到了上文示例中的顶层布局组件中。

```
<android.support.constraint.ConstraintLayout
    ...
    android:theme="@style/RedTheme">
```

这可以实现所需效果，在此布局组件中的所有按钮确实变成了红色，不过我们可以回过头想一下。在 CSS 中一行 `button { background: red; }` 就可以搞定的事情，竟然要用那么多 XML 代码。而且随着应用越来越大，这种方式也只会变得越来越复杂。

一般来说，Android 中稍微复杂点的样式往往需要涉及到嵌套的 XML 配置文件或是一大堆用于创建可扩展组件的 Java 代码——无论哪种方式都不能令我满意。

再来看看动画。Android 有一些内建的动画效果，这些是很好的，用起来也很方便，但是自定义动画则必须用 Java 代码来实现。（这里有个[例子](https://developer.android.com/training/animation/crossfade.html)。）Android 中没有类似 CSS 动画的东西，不可能将动画的配置管理和应用样式写在一起。

再来看看媒体查询（media queries）。Android 允许你实现类似于 CSS 媒体查询的属性并将其用于 UI 组件中，但这完全是耦合在标签结构中的，根本无法在页面或视图间复用。

为了让你能更好地理解 Android 中的媒体查询，下面是 Android 文档[支持多种屏幕尺寸](https://developer.android.com/training/multiscreen/screensizes.html)中的第一个代码示例。我将其原样摘抄如下，下次你再抱怨 CSS 媒体查询的时候，可以拿来做个对比。

```
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
    <LinearLayout android:layout_width="match_parent"
                  android:id="@+id/linearLayout1"  
                  android:gravity="center"
                  android:layout_height="50dp">
        <ImageView android:id="@+id/imageView1"
                   android:layout_height="wrap_content"
                   android:layout_width="wrap_content"
                   android:src="@drawable/logo"
                   android:paddingRight="30dp"
                   android:layout_gravity="left"
                   android:layout_weight="0" />
        <View android:layout_height="wrap_content"
              android:id="@+id/view1"
              android:layout_width="wrap_content"
              android:layout_weight="1" />
        <Button android:id="@+id/categorybutton"
                android:background="@drawable/button_bg"
                android:layout_height="match_parent"
                android:layout_weight="0"
                android:layout_width="120dp"
                style="@style/CategoryButtonStyle"/>
    </LinearLayout>

    <fragment android:id="@+id/headlines"
              android:layout_height="fill_parent"
              android:name="com.example.android.newsreader.HeadlinesFragment"
              android:layout_width="match_parent" />
</LinearLayout>
```

我们本可以将 CSS 的特性都过一遍，但通过上述几个例子便可得出一个结论：在 Android 中确实可以实现各种样式效果，但其实现方法总是要比在 web 上实现复杂很多。

讨论 Android  XML 的冗余性很简单，但要真地想出一种清晰简洁而且能在大规模应用上运行良好的 UI 组件样式机制却是非常难的。主观上你肯定可以举出和上述 Android 例子一样糟糕的 CSS 的例子，但使用这两种技术工作过后，我会毫不犹豫地选择 CSS。

为保证论述完整性，让我们再来讨论另外一种可以渲染 UI 组件的平台：iOS。

## 为什么说 iOS 应用的样式布局很难？

在软件开发行业，iOS 有点独一无二，因为据我所知，它是惟一一个 UI 开发主要是通过可视化工具来完成的软件平台。那个工具叫做 [Storyboard](https://developer.apple.com/library/content/documentation/General/Conceptual/Devpedia-CocoaApp/Storyboard.html)，使用它并结合 Xcode 来开发 iOS 和 macOS 应用。 

为了你能更好地理解我在说些什么，下图展示了在 iOS 应用中如何为视图添加两个按钮。

![](http://developer.telerik.com/wp-content/uploads/2017/05/buttons.gif)

值得注意的是，开发 iOS 应用并非**一定**要用 Storyboard，但其替代方法需要用 Objective-C 或 Swift 代码开发大部分用户界面，因此苹果官方推荐 iOS 开发使用 storyboards。

> **注意** 关于 Storyboard 适用场景的问题超出了本文的论述范围，如果你对此感兴趣的话，可以参考 [Quora 上关于此话题的讨论](https://www.quora.com/How-many-iOS-developers-dont-use-NIBs-Storyboards-and-Constraints)。

让我们回到本文主旨上来，如何为 iOS 中的 UI 组件赋予样式呢？你可能已经猜到了，在可视化编辑器中配置 UI 控件各自的属性是很容易的一件事情。例如，如果想改变一个按钮的背景颜色，使用屏幕右侧的菜单就可以轻易地实现。

![](http://developer.telerik.com/wp-content/uploads/2017/05/button-background-ios.jpg)

和 Android 很像，为构件配置各种属性是很简单的。但同样和 Android 类似，当需求变得复杂时事情也就更棘手了。例如，在 iOS 应用中如何使多个按钮的看起来完全一样呢？这就不简单了。

iOS 有一个 [outlets](https://developer.apple.com/library/content/documentation/General/Conceptual/Devpedia-CocoaApp/Outlet.html) 的概念，本质上是使得 Objective-C 或 Swift 代码可以获取界面组件的引用的机制。可以将 outlets 看作 iOS 中的 `document.getElementById()`。想要为多个 iOS UI 组件赋予样式，需要获取一个显式的 reference 或者 outlet，遍历 storyboard 中的每个控件，并赋予其相应的变化。下面这个例子展示了 Swift 视图控制器是如何改变所有按钮的背景颜色的。

```
import UIKit

class ViewController: UIViewController {

    // 一个按钮 outlets 的集合，使用 Xcode 的 storyboard 编辑器为其填充数据
    @IBOutlet var buttons: [UIButton]!

    func styleButtons() {
        for button in self.buttons {
            // 通过设置视图的 backgroundColot 属性来赋予其红色的背景
            button.backgroundColor = UIColor.red
        }
    }

    // 视图控制器的入口点，iOS 会在视图加载后调用此函数。
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleButtons()
    }
}
```
此处的关键点不在于具体细节，因此我不会详细说明每一行 Swift 代码的作用。关键在于为多个控件赋予样式不可避免地会涉及到 Objective-C 或 Swift 代码，而这在 CSS 中只需要定义一个简单的类名即可搞定。

不难想象，更复杂的 iOS 样式需求会涉及更多的代码。例如，创建一个简单的 iOS “主题”涉及到[一大堆 `UIAppearance` APIs](https://www.raywenderlich.com/108766/uiappearance-tutorial)，而处理多种设备类型则需要学习高深的 [auto layout](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/)。

公平地说，原生开发者也能指出 CSS 中一些诡异的特性，而且在某种程度上他们也没错。毕竟，无论是 Web 还是诸如 iOS 和 Android 这样的原生平台，界面组件的定位、样式、动画以及处理各种设备的兼容性都不是什么简单的事情。任何全面的样式系统都不可避免地作出一些取舍，但是，在各种软件行业都工作后，我觉得 CSS 凭借诸多优势脱颖而出了。

## 为什么说 CSS 更好

### CSS 非常灵活

CSS 允许你将应用的关注点分离，因此样式逻辑和应用主体逻辑之间是完全独立的。[关注点分离原则](https://en.wikipedia.org/wiki/Separation_of_concerns)是过去几十年里 web 开发的基本原则，CSS 的架构特点则是使得这一原则实际可行的主要因素之一。

话虽如此，如果您愿意的话，CSS 的灵活性也允许你忽略关注点分离原则，而通过应用代码来处理所有样式。 诸如 React 这样的框架便采取了这种方法，而不需要对 CSS 语言或架构作任何改动。

在如何为界面控件赋予样式方面，Android 和 iOS 的机制都比较严格，而 web 则有多种选择，你可以选择最满足你实际需求的那一种。


### CSS 语言简单，且是出色的编译目标

CSS 是一种相对简单的语言。从上层来看，CSS 不过是定义了一系列键值对的选择器的集合。这种简单性使得很多事情都可能实现。

其中一项就是转译器（transpilers）。因为 CSS 相对简单，像 SASS 和 LESS 这样的转译器便能在 CSS 语言的基础之上进行创新，并实验许多功能强大的新特性。SASS 和 LESS 这样的工具不仅提升了开发效率，而且也影响到了 CSS 标准本身，例如像 CSS 变量这样的特性目前[在大多数主流浏览器中都可以使用了](http://caniuse.com/#feat=css-variables)。

CSS 的简单性带来的不仅仅是转译器。你在 web 上看到的每一个主题构建器（theme builder）或拖拽构建工具（drag & drop building tool）都有可能源自 CSS 的简单性。iOS 和 Android 的世界里甚至根本没有主题构建器这一概念，因为该工具的输出必须是一个完整的 iOS 或 Android 应用，而一个完整应用并不是那么容易开发的。（不存在 iOS/Android 主题构建器，更多的是类似应用模版或应用启动器这样的东西）

还有一点：你知道浏览器的开发者工具有多棒吗？你可以很容易地调试应用的外观和体验，这又是 CSS 简单性的一个体现。iOS 和 Android 都没有类似 web 上的可视化开发者工具。

最后一个例子：[NativeScript 项目](https://docs.nativescript.org/)允许开发者[使用 CSS 的子集控制 iOS 和 Android 控件的样式](https://docs.nativescript.org/ui/styling)，例如使用 `Button { color: blue; }` 控制 `UIButton` 或 `android.widget.Button` 的样式。我们能这样做纯粹是因为 CSS 是一门灵活而且易于解析的语言。

### CSS 能让你做一些很棒的事情

最后，说 CSS 很棒还有一个最重要的原因，那就是开发者使用一些简单的选择器和样式规则便能开发出一系列东西。网络上充斥着“10 个仅用 CSS 实现的精彩案例”这样的帖子证明了这一点，在这里也我要放上几个我最喜欢的例子。 

以下为精彩案例，点击图片可查看源码：

- 案例 1：[![](https://ws3.sinaimg.cn/large/006tNc79gy1fgcfopqewxj30me0fqq3m.jpg)](https://codepen.io/waynedunkley/pen/YPJWaz)
- 案例 2：[![](https://ws2.sinaimg.cn/large/006tNc79gy1fgcfozwrxbj30pn0jkq4i.jpg)](https://codepen.io/fbrz/pen/whxbF)
- 案例 3：[![](https://ws3.sinaimg.cn/large/006tNc79gy1fgcfpbf291j31980ozjtb.jpg)](https://codepen.io/r4ms3s/pen/gajVBG)


## 结论

那 CSS 就没有坑吗？当然有。盒模型就有点怪异，而 flexbox 又不是那么容易上手，另外诸如 CSS 变量这样的特性要再早几年出来就更好了。

每种样式系统都有其不足之处，但是 CSS 的灵活、简单和功能强大让它经受住了时间的考验，也帮助 web 成为了目前非常强大的开发平台。面对 CSS 的攻讦者，我很乐意捍卫 CSS，而且我也鼓励你这样做。

**标题图片来自 [Valentines by Misha Gardner](https://flic.kr/p/bpWQ7a)**

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
