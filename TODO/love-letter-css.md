> * 原文地址：[A Love Letter to CSS](http://developer.telerik.com/topics/web-development/love-letter-css/)
> * 原文作者：[TJ VanToll](http://developer.telerik.com/author/tvantoll/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# A Love Letter to CSS

![http://developer.telerik.com/wp-content/uploads/2017/05/css_love_header.jpg](http://developer.telerik.com/wp-content/uploads/2017/05/css_love_header.jpg)

When I tell coworkers of my unabated love for CSS they look at me like I’ve made an unfortunate life decision.

> “Let’s sit down TJ, and talk about the poor choices you made during childhood that set you up for failure.”

Sometimes I feel that developers, some of the most opinionated human beings on the planet, can only agree on one thing: that CSS is totally the worst.

![](https://ws2.sinaimg.cn/large/006tNc79gy1fgcf54bv9uj30eo062dga.jpg)

One of the best ways to get consistent laughs at tech conferences is to take a jab at CSS, and CSS memes are so common that I’m contractually obligated to include two of them in this article.

![](http://developer.telerik.com/wp-content/uploads/2017/05/css-mug.jpg)
![](http://developer.telerik.com/wp-content/uploads/2017/05/css-blinds.gif)

But today I’m going to blow your mind. Today I’m going to try to convince you that not only is CSS one of the best technologies you use on a day-to-day basis, not only is CSS incredibly well designed, but that you should be thankful—thankful!—each and every time you open a `.css` file.

My argument is relatively simple: creating a comprehensive styling mechanism for building complex user interfaces is startlingly hard, and every alternative to CSS is much worse. Like, it’s not even close.

To prove my point I’m going to compare CSS to a few alternative styling systems, and I’m going start by taking you back in time.

## OMG, remember Java applets?

In college I built a few apps with this powerful, about-to-be-obsolete technology called Java applets. Java applets were basically Java apps that you could haphazardly embed in a browser using an `<applet>` tag. On a good day half of your users would have the correct version of Java installed on their machines, and they’d be able to run your apps successfully.

![](http://developer.telerik.com/wp-content/uploads/2017/05/java-applet.jpg)
*A sample Java applet so you can take yourself back to the late 90s*

Java applets debuted in 1995 and started to get popular a few years later. If you were around in the late 90s, you’ll remember real debates about whether you should build your next great app using web technologies, or whether you should build using Java applets.

Like most technologies that let you create user interfaces, Java applets let you change the appearance of the controls that you place on the user’s screens. And because Java applets were seen as a plausible alternative to web development, the ease of styling controls in applets was sometimes compared to how you accomplish that same task on the web.

Java applets obviously didn’t use CSS, so how exactly do you style UI controls in a Java applet? Not easily. Here’s a code snippet from the [first Google result for “change button color Java applet”](http://www.java-examples.com/change-button-background-color-example).

```
/*
        Change Button Background Color Example
        This java example shows how to change button background color using
        AWT Button class.
*/

import java.applet.Applet;
import java.awt.Button;
import java.awt.Color;

public class ChangeButtonBackgroundExample extends Applet{

    public void init(){

        //create buttons
        Button button1 = new Button("Button 1");
        Button button2 = new Button("Button 2");

        /*
          * To change background color of a button use
          * setBackground(Color c) method.
          */

        button1.setBackground(Color.red);
        button2.setBackground(Color.green);

        //add buttons
        add(button1);
        add(button2);
    }
}
```

The first thing to note is that Java applets offer no real way to separate your logic and styling code, like you might do on the web with HTML and CSS. This will be a theme for the rest of this article.

The second thing to note is that this is a *lot* of code to create two buttons and change their background colors. If you’re thinking something like *“wow, this approach seems like it would get out of control really quickly in a real-world app”*, then you’re starting to get an idea of why the web won and Java Applets didn’t.

That being said I know what you’re thinking.

> “TJ, you’re not exactly winning me over by saying CSS styling is better Java Applet’s approach. Way to set a high bar.”

Yes, because Java applet’s visual APIs aren’t exactly the gold standard of user interface design, let’s shift our attention to something developers actually build nowadays: Android apps.

## Why styling Android apps is hard

In some ways, Android is a modern, way-better version of the Java applets from years ago. Like Java applets, Android uses Java as a development language. (Although you’ll soon be able to use the Kotlin language, per a [recent Google announcement at their Google I/O event](https://techcrunch.com/2017/05/17/google-makes-kotlin-a-first-class-language-for-writing-android-apps/).) But unlike Java applets, Android includes a series of conventions that makes building user interfaces a whole lot easier, and a lot more like building for the web.

On Android you define your user interface controls in XML files, and interact with that markup in a separate Java files. It’s very similar to a web app with markup in HTML files, and logic in separate JavaScript files.

Here’s what the markup of a very simple Android “activity” (basically a page) might look like.

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

This might look a bit arcane if you’re a web developer, but remember that a basic `index.html` file has its share of quirks as well. What you’re seeing here is two UI components, an `<android.support.constraint.ConstraintLayout>` and an `<android.widget.Button>`, each with various attributes used for configuration. Just to give you a visual, here’s what this simple app looks like running on an Android device.

![](http://developer.telerik.com/wp-content/uploads/2017/05/simple-android-app.jpg)

So to bring this discussion back to the topic of this article, how do you style these components? Much like the web’s `style` attribute, there are a variety of attributes you can apply to pretty much every Android UI component to change their appearance.

For example, if you want to change the background color of the previous example’s button, you can apply the `android:background` attribute. In the code below I apply that attribute so that the button appears red.

```
<Button
    android:id="@+id/button"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="Hello World"
    android:background="#ff0000" />
```

![](http://developer.telerik.com/wp-content/uploads/2017/05/android-red-button.jpg)

So far so good. Android Studio, Google’s recommended Android development environment, even provides a robust visual editor that makes configuring some of these common properties really easy. The image below shows Android Studio’s design view for this sample app. Note how you can easily configure properties such as “background” using the pane on the right-hand side of the screen.

![](http://developer.telerik.com/wp-content/uploads/2017/05/android-visual-editor.jpg)

Through things like the design view, Android makes the basics of applying styles to user interface controls very simple. But this is where the pro-Android portion of this article ends.

Real-world development requires you to go well beyond the basics, and, at least in my experience, this is where the verbosity of Android and the simplicity of CSS really starts to show. For example, suppose you want to create a collection of property name/value pairs that you can easily reuse – something kind of like CSS class names. You can kind of do that in Android, but it gets messy very quickly.

Android apps have a `styles.xml` file where you can create XML chunks in that file that build on top of each other. For instance, suppose you wanted to make all your app’s buttons have red backgrounds. On Android you could use the following code to create a “RedTheme” style.

```
<style name="RedTheme" parent="@android:style/Theme.Material.Light">
  <item name="android:buttonStyle">@style/RedButton</item>
</style>

<style name="RedButton" parent="android:Widget.Material.Button">
  <item name="android:background">#ff0000</item>
</style>
```

After that change, you could then apply a `android:theme="@style/RedTheme"` attribute to the top-level UI component you want this theme to apply to. In the code below I apply that attribute to the top-level layout component from our previous example.

```
<android.support.constraint.ConstraintLayout
    ...
    android:theme="@style/RedTheme">
```

This works, and all buttons within that layout will indeed be red, but let’s take a step back. All of that code — the handful of lines of XML, the markup attributes, and such — all of that is replicating what you can accomplish in CSS using `button { background: red; }`. And these same sort of styling tasks don’t get easier as your Android apps get more complex.

In general, non-trivial styling implementations on Android tend to involve either nested XML configuration files, or a bunch of Java code to create extensible components — neither of which fill with me with much joy.

Consider animations. Android has some built-in animations, and those tend to be nice and easy to use, but custom animations must be implemented in Java code. (Here’s [an example](https://developer.android.com/training/animation/crossfade.html).) There’s no equivalent of something like CSS animations that lets you configure and manage your animations along with your app’s styling.

Consider media queries. Android lets you implement some CSS-media-query-like properties to your UI components, but it’s entirely done in markup, which doesn’t lend itself to reusability across pages or views.

Just to give you a sense of what I’m talking about, this is the very first code example from Android’s documentation on [Supporting Multiple Screen Sizes](https://developer.android.com/training/multiscreen/screensizes.html). I’ll offer it below verbatim as some food for thought the next time you complain about CSS media queries.

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

We could keep going through CSS features, but hopefully you’re seeing a pattern: you can do a whole lot to style your apps on Android, but the solutions almost always require a whole lot more code than it does on the Web.

And while it’s easy to gawk at some of Android’s XML verbosity, remember that it’s really, really hard to come up with a mechanism of styling UI components that’s clear, concise, and that works well in large-scale applications. You can definitely find CSS examples that are subjectively as bad as Android’s solutions, but having worked in both I’ll personally take CSS’s approach without a second thought.

To round out my argument let’s look at one other popular platform for rendering UI components: iOS.

## Why styling iOS apps is hard

iOS is a bit unique in the software development world, as it’s one of the only software platforms I know of where the majority of your UI development is done through a visual tool. That tool is called [storyboards](https://developer.apple.com/library/content/documentation/General/Conceptual/Devpedia-CocoaApp/Storyboard.html), and you use them within Xcode to build apps for iOS and macOS.

Just to give you an idea of what I’m talking about, here’s what it looks like to add two buttons to a view in an iOS app.

![](http://developer.telerik.com/wp-content/uploads/2017/05/buttons.gif)

It’s worth noting that you don’t *have* to to build iOS apps using storyboards, but the alternative is generating your most of your user interface in Objective-C or Swift code, and therefore storyboards are the development path that Apple recommends for iOS development.

> **NOTE** A complete discussion of when storyboard development is and isn’t appropriate for iOS apps is out of the scope of this article. If you’re interested, check out this [debate about the topic on Quora](https://www.quora.com/How-many-iOS-developers-dont-use-NIBs-Storyboards-and-Constraints).

So to bring the conversation back to the top of this article, how do you style iOS UI components? Well as you might expect from a visual editor, there are easy ways to configure individual properties of UI controls. For example, if you want to change the background color of a button, you can do so pretty easily from a menu on the right-hand side of the screen.

![](http://developer.telerik.com/wp-content/uploads/2017/05/button-background-ios.jpg)

Much like Android, the task of applying individual properties is very simple. But also like Android, things get much harder when you move beyond the basics. For example, how do you make multiple buttons look the same in an iOS app? Not easily.

iOS has this concept of [outlets](https://developer.apple.com/library/content/documentation/General/Conceptual/Devpedia-CocoaApp/Outlet.html), which are essentially a mechanism for your Objective-C or Swift code to get a reference to user interface components. You can think of outlets sort of like `document.getElementById()` calls on the Web. To style multiple iOS UI components you need to get an explicit reference, or outlet, for each control on your storyboard, loop over them, and then apply your changes. Here’s an example of what a Swift view controller that changes the background color of all buttons looks like.

```
import UIKit

class ViewController: UIViewController {

    // A collection of button outlets that you fill using
    // Xcode’s storyboard editor
    @IBOutlet var buttons: [UIButton]!

    func styleButtons() {
        for button in self.buttons {
            // Apply a red background color by setting the view’s
            // backgroundColor property.
            button.backgroundColor = UIColor.red
        }
    }

    // This is the entry point to your view controller. iOS
    // invokes this function when your view loads.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleButtons()
    }
}
```

The point here is not the specifics, so I’m not going to go over what each and every line of Swift code is doing here. The point is that styling multiple controls inevitably involves Objective-C or Swift code, something you can easily accomplish in CSS by defining a simple class name.

And as you might expect, more complex iOS styling tasks don’t involve less code. For example, creating a simple iOS “theme” involves [a whole bunch of `UIAppearance` APIs](https://www.raywenderlich.com/108766/uiappearance-tutorial), and dealing with multiple device types requires that you learn about the non-trivial topic of [auto layout](https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/AutolayoutPG/).

To be fair, native developers can make somewhat similar arguments about there being some bizarre features in CSS, and to a certain extent they’re right. After all, whether we’re talking about the Web, or a native platform such as iOS or Android, the task of positioning, styling, and animating user interface components, across all sorts of devices, is no easy task. Any comprehensive styling system must inevitably make tradeoffs, but, having worked in a number of software ecosystems, CSS stands out to me for a number of reasons.

## Why CSS is more awesome

### CSS is amazingly flexible.

CSS lets you separate your app’s concerns so that your styling logic is completely separate from your app’s main logic. The [separation of concerns principal](https://en.wikipedia.org/wiki/Separation_of_concerns) has been a bedrock of web development for the last two decades, and CSS’s architecture is one of the main reasons this approach is possible.

That being said, CSS is also flexible enough that you can ignore the separation of concerns principal if you’d like, and handle all your styling through application code. Frameworks like React were able to take this approach without needing to change the CSS language or architecture in any way.

Android and iOS have relatively strict mechanisms when it comes to styling your user interface controls, but on the web you have options, and you can pick the option that best suits your application’s needs.

### CSS is a simple language, and therefore an excellent compiler target.

CSS is a relatively simple language. Think about it, at a high level all you have is a collection of selectors that define a series of name/value pairs. And that simplicity makes a whole lot of things possible.

One of them is transpilers. Because CSS is relatively simple, transpilers such as SASS and LESS were able to innovate on top of the CSS language and experiment with powerful new features. Tools like SASS and LESS have not only improved developer productivity, they’ve also helped influence the CSS specification itself, with features like CSS variables now [being available in most major browsers](http://caniuse.com/#feat=css-variables).

But CSS’s simplicity enables more than just transpilers. Every theme builder or drag & drop building tool you see on the web is possible because of just how easy CSS is to output. The concept of a theme builder isn’t even a thing in the iOS or Android worlds, because the tool’s output would need to be a complete iOS or Android app, which isn’t exactly an easy thing to generate. (Instead of iOS/Android theme builders you tend to see things like app templates or app starters).

Here’s another one: you know how your browser’s developers tools are awesome and let you easily tweak the look and feel of your application? This is again CSS’s simplicity at work. iOS and Android have nothing that comes close to the visual development tools we have on the web.

One final example: on the [NativeScript project](https://docs.nativescript.org/) we were able to allow developers to [style native iOS and Android controls using subset of CSS](https://docs.nativescript.org/ui/styling), for example using `Button { color: blue; }` to style a `UIButton` or `android.widget.Button`. We were only able to do this because CSS is a flexible and easy to parse language.

### CSS lets you do some amazing stuff.

And finally, the single biggest reason CSS is awesome is the sheer range of things developers have been able to build with a language of simple selectors and rules. The internet is full of "10 AMAZING CSS-ONLY EXAMPLES" posts that prove this point, but I’m going to embed a few of my favorites right here because I can.

以下为精彩案例，点击图片可查看源码：

- 案例 1：[![](https://ws3.sinaimg.cn/large/006tNc79gy1fgcfopqewxj30me0fqq3m.jpg)](https://codepen.io/waynedunkley/pen/YPJWaz)
- 案例 2：[![](https://ws2.sinaimg.cn/large/006tNc79gy1fgcfozwrxbj30pn0jkq4i.jpg)](https://codepen.io/fbrz/pen/whxbF)
- 案例 3：[![](https://ws3.sinaimg.cn/large/006tNc79gy1fgcfpbf291j31980ozjtb.jpg)](https://codepen.io/r4ms3s/pen/gajVBG)


## Conclusion

So does CSS have its quirks? Sure. The box model is a bit weird, flexbox isn’t the easiest thing to learn, and it’d be great if features like CSS variables were available years ago.

Every styling system has its warts, but CSS’s flexibility, simplicity, and pure power have stood the test of time, and have helped make the web the powerful development platform it is today. I’m happy to defend CSS against the CSS haters, and I encourage you to do the same.

*Header image based upon [Valentines by Misha Gardner](https://flic.kr/p/bpWQ7a)*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
