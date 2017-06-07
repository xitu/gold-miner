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

#### 案例 1

```
html

 <ul class="wrapper">
  <div class="sun">
    <div class="star"></div>
  </div>
  <div class="mercury">
    <div class="planet">
      <div class="shadow"></div>
    </div>
  </div>
  <div class="venus">
    <div class="planet">
      <div class="shadow"></div>
    </div>
  </div>
  <div class="earth">
    <div class="planet"><div class="shadow"></div></div>
  </div>
  <div class="mars">
    <div class="planet"><div class="shadow"></div></div>
  </div>
  <div class="jupiter">
    <div class="planet"><div class="shadow"></div></div>
  </div>
</ul>

css

html {
  background-color: #000;
}
body{
  height: 100%;
  top: 0px;
  bottom: 0px;
}
@keyframes spinsun {
  0% { transform: rotate(0); }
  100%   { transform: rotate(-360deg); }
}
@keyframes shadow {
  0% { background-position: 130% 0%; }
  33%{ background-position: 50% 0%; }
  55% { background-position: 0% 0%; }
  80%{ background-position: -50% 0%; }
  100%{ background-position: -50% 0%; }
}
@keyframes orbitmercury {
  0% { z-index:2; transform: rotateY(0); }
  49% { z-index:2; }
  50% { z-index:-2; }
  99% { z-index:-2; }
  100%   { z-index:2; transform: rotateY(360deg); }
}
@keyframes orbitvenus {
  0% { z-index:3; transform: rotateY(0); }
  49% { z-index:3; }
  50% { z-index:-3; }
  99% { z-index:-3; }
  100%   { z-index:3; transform: rotateY(360deg); }
}
@keyframes orbitearth {
  0% { z-index:4; transform: rotateY(0); }
  49% {z-index:4;}
  50% {z-index:-4;}
  99% {z-index:-4;}
  100%   { z-index:4; transform: rotateY(360deg);}
}
@keyframes orbitmars {
  0% { z-index:5; transform: rotateY(0); }
  49% { z-index:5; }
  50% { z-index:-5; }
  99% { z-index:-5; }
  100%   { z-index:5; transform: rotateY(360deg); }
}
@keyframes orbitjupiter {
  0% { z-index:6; transform: rotateY(270); }
  49% { z-index:6; }
  50% { z-index:-6; }
  99% { z-index:-6; }
  100%   { z-index:6; transform: rotateY(360deg); }
}
@keyframes orbitsaturn {
  0% { z-index:7; transform: rotateY(270); }
  49% { z-index:7; }
  50% { z-index:-7; }
  99% { z-index:-7; }
  100%   { z-index:7; transform: rotateY(360deg); }
}
/* Keep planet image flat */
@keyframes anti-spin {
  from { transform: rotateY(0); }
  to   { transform: rotateY(-360deg); }
}
@keyframes anti-spin-rings {
  from { transform: rotateY(0) rotateX(73deg); }
  to   { transform: rotateY(-360deg) rotateX(73deg); }
}

/* scene wrapper */
.wrapper{
  position:relative;
  margin: 0 auto;
  display:block;
  margin-top: 200px;
  perspective: 1000px;
    perspective-origin: 60% 50%;
  transform: rotate(-10deg);

}
.wrapper > div {
  position: relative;
  margin: 0 auto;
  transform-style: preserve-3d;
  height: 0px;
}
.sun {
  width: 250px;
  position: absolute;
  top: 0px;
  z-index: 1;
  height: 125px !important;
}
.sun .star {
  width: 250px;
  height: 250px;
  background: url(http://www.waynedunkley.com/img/solar_system/sun.png) no-repeat;
  background-size: cover;
  border-radius: 250px;
  margin: 0 auto;
  animation: spinsun 40s infinite linear;
}
.planet {
  background-size: cover;
  background-repeat: no-repeat;
  background-color: transparent;
  animation-iteration-count: infinite;
  overflow:hidden;
}
.shadow {
  position: absolute;
  left: 0px;
  right: 0px;
  top: 0px;
  bottom: 0px;
  background: transparent url(http://www.waynedunkley.com/img/solar_system/shadow.png) 0% 0% no-repeat;
  background-size: cover;
  border-radius: 100%;
}
.mercury {
  position: absolute;
  width: 400px;
  z-index:2;
  animation: orbitmercury 12s infinite linear;
  top: -7.5px; /*half of planets height to keep orbits in line*/
}
.mercury .planet {
  width:15px;
  height:15px;
  background-image: url(http://www.waynedunkley.com/img/solar_system/mercury.png);
  animation: anti-spin 12s infinite linear;
}
.mercury .shadow {
  animation: shadow 12s infinite linear;
}
.venus {
  position: absolute;
  width: 506px;
  z-index:3;
  animation: orbitvenus 15s infinite linear;
  top: -19px;
}
.venus .planet {
  width:38px;
  height:38px;
  background-image: url(http://www.waynedunkley.com/img/solar_system/venus.png);
  animation: anti-spin 15s infinite linear;
}
.venus .shadow {
  animation: shadow 15s infinite linear;
}
.earth {
  position: absolute;
  width: 610px;
  z-index:4;
  animation: orbitearth 20s infinite linear;
  top: -20px;
}
.earth .planet {
  width:40px;
  height:40px;
  background-image: url(http://www.waynedunkley.com/img/solar_system/earth.png?v=2);
  animation: anti-spin 20s infinite linear;
}
.earth .shadow {
  animation: shadow 20s infinite linear;
}
.mars {
  position: absolute;
  width: 706px;
  z-index:5;
  animation: orbitmars 30s infinite linear;
  top: -11px;
}
.mars .planet {
  width:22px;
  height:22px;
  background-image: url(http://www.waynedunkley.com/img/solar_system/mars.png);
  animation: anti-spin 30s infinite linear;
}
.mars .shadow {
  animation: shadow 30s infinite linear;
}
.jupiter {
  position: absolute;
  width: 1100px;
  z-index:6;
  animation: orbitjupiter 50s infinite linear;
  top: -64px;
}
.jupiter .planet {
  width:128px;
  height:128px;
  background-image: url(http://www.waynedunkley.com/img/solar_system/jupiter.png);
  animation: anti-spin 50s infinite linear;
}
.jupiter .shadow {
  animation: shadow 50s infinite linear;
}
```

效果预览：[codepen.io/waynedunkley/pen/YPJWaz](https://codepen.io/waynedunkley/pen/YPJWaz)


#### 案例 2

```
html

<!-- Please heart it if you like! -->
<div id='book'>
  <div id='top'></div>
  <div id='front'></div>
  <div id='right'></div>
  <div id='bottom'></div>
  <div id='shadow'></div>
  <div id='bookmark'>
    <div>
      <div>
        <div>
          <div></div>
        </div>
      </div>
    </div>
  </div>
  <div id='bookmark-shadow'></div>
</div>
<div id='flip'>
  <div id='front'>
    <div>
      <div>
        <div>
          <div>
            <div>
              <div>
                <div>
                  <div>
                    <div>
                      <div></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div id='back'>
    <div>
      <div>
        <div>
          <div>
            <div>
              <div>
                <div>
                  <div>
                    <div>
                      <div></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<h4>CSS 3D Bending Effect - Page Flip</h4>

CSS:

/* remember to use - transform-style: preserve-3d; */
html,body {
  height:100%;
  overflow: hidden;
}
body {
  background: radial-gradient(#E4CEA6, #9C8763);
  perspective: 900px;
  margin: 0;
}
#flip {
  animation: wrapper 6s ease-in-out infinite;
  height: 350px;
  width: 253px;
  position: absolute;
  left: 50%;
  top: 30%;
  transform: translateZ(-10px) rotateX(60deg) rotateZ(29deg) rotateY(0deg)!important;
  transform-style: preserve-3d;
  transform-origin: 0 0 0;
}
@keyframes wrapper {
  50% {
    transform: translateZ(-10px) rotateX(60deg) rotateZ(29deg) rotateY(-180deg);
  }
}
#flip div {
  height: 350px;
  width: 24px;
  position: absolute;
  left: calc(100% - 1px);
  transform-origin: 0 100%;
  transform-style: preserve-3d;
  background-size: 253px 350px;
}
#flip #front,
#flip #front div {
  background-image: url(http://blogs.slj.com/afuse8production/files/2012/06/Hobbit1.jpg);
  box-shadow: inset rgba(255,255,255,0.3) 0px -1px 0 0,#35582C 0px 1px 0px 0px;
}
#flip #front > div > div > div > div > div > div > div > div > div > div {
  box-shadow: inset rgba(255,255,255,0.3) -1px -1px 0 0, #35582C 1px 1px 0px 0px;
}
#flip #back { transform: rotateY(.4deg); transform-origin: -100% 0; } /* avoid pages overlap */
#flip #back,
#flip #back div {
  background-image: url(https://s3-us-west-2.amazonaws.com/s.cdpn.io/164210/map1_.jpg);
}

#flip > div {  left: 0;  background-position-x: 0; }
#flip div > div { background-position-x: -23px; animation: page 6s ease-in-out infinite; }
#flip div > div > div { background-position-x : -46px; }
#flip div > div > div > div { background-position-x : -69px; }
#flip div > div > div > div > div { background-position-x : -92px; }
#flip div > div > div > div > div > div { background-position-x : -115px; }
#flip div > div > div > div > div > div > div { background-position-x : -138px; }
#flip div > div > div > div > div > div > div > div  { background-position-x : -161px; }
#flip div > div > div > div > div > div > div > div > div { background-position-x : -184px; }
#flip div > div > div > div > div > div > div > div > div > div { background-position-x : -207px; }
#flip div > div > div > div > div > div > div > div > div > div > div { background-position-x : -229px; }
/* the more pieces you have, the smoother the bend is */

@keyframes page {
  15% { transform: rotateY(-10deg); }
  50% { transform: rotateY(-2deg); }
  65% { transform: rotateY(10deg); }
  100% { transform: rotateY(0deg); }
}

#book {
  width: 248px;
  height: 350px;
  position: absolute;
  left:50%;
  top: 30%;
  transform: translate3d(0px,0px,-10px) rotateX(60deg) rotateZ(29deg);
  transform-style: preserve-3d;
  -webkit-transform-origin: 0 0 0;
}
@keyframes book {
  25% {
    box-shadow: inset rgba(0,0,0,.2) 0px 0 50px -140px;
  }
  50% {
    box-shadow: inset rgba(0,0,0,.2) 0px 0 50px -140px;
  }
  100% {
    box-shadow: inset rgba(0,0,0,.2) 510px 0 50px -140px;
  }
}
#book #top {
  animation: book 6s ease-in-out infinite;
  background: url(https://s3-us-west-2.amazonaws.com/s.cdpn.io/164210/map2.jpg);
  background-size: 100% 100%;
  background-position: 100%;
  box-shadow: inset rgba(0,0,0,0.2) 510px 0 50px -140px;
  height: 350px;
  width: 248px;
  position: absolute;
  left: 0;
  top: 0;
}
#book #bottom {
  background: #E7DED1;
  box-shadow: rgba(83, 53, 13, 0.2) 4px 2px 1px,
              #35582C 1px 1px 0px 0px;
  height: 350px;
  width: 253px;
  position: absolute;
  transform: translateZ(-40px);
  left: 0;
  top: 0;
}
#book #shadow {
  animation: shadow 6s ease-in-out infinite;
  box-shadow: inset rgba(83, 53, 13, 0) -200px 0 150px -140px;
  height: 350px;
  width: 248px;
  position: absolute;
  left: -100%;
  top: 0;
  transform: translateZ(-40px);
}
@keyframes shadow {
  20% {
    box-shadow: inset rgba(83, 53, 13, 0) -200px 0 150px -140px;
  }
  50% {
    box-shadow: inset rgba(83, 53, 13, 0.3) -350px 0 150px -140px;
  }
  60% {
    box-shadow: inset rgba(83, 53, 13, 0) -200px 0 150px -140px;
  }
}
#book #front {
  background: -webkit-linear-gradient(top,#FCF6EA, #D8D1C3);
  background-size: 100% 2px;
  box-shadow: inset #C2BBA2 3px 0 0px, #35582C -2px 1px 0px 0px;
  height: 40px;
  width: 251px;
    left: -3px;
  position: absolute;
  bottom: -40px;
  transform: rotateX(-90deg);
  transform-origin: 50% 0;
  border-top-left-radius: 5px;
  border-bottom-left-radius: 5px;
}
#book #right {
  background: -webkit-linear-gradient(left,#DDD2BB, #BDB3A0);
  background-size: 2px 100%;
  box-shadow: inset rgba(0,0,0,0) 0 0 0 20px;
  height: 100%;
  width: 40px;
  position: absolute;
  right: -40px;
  top: 0;
  transform: rotateY(90deg);
  transform-origin: 0 50%;
}

h4 {
  position: absolute;
  bottom: 20px;
  left: 20px;
  margin: 0;
  font-weight: 200;
  opacity: 1;
	font-family: sans-serif;
  color: rgba(0,0,0,0.3);
}

/* bookmark */

#bookmark {
  position: absolute;
  transform: translate3d(20px,350px,-16px);
  transform-style: preserve-3d;
}
#bookmark div {
  background: rgb(151, 88, 88);
  box-shadow: rgb(133,77,77) 1px 0;
  height: 10px;
  width: 20px;
  position: absolute;
  top: 9px;
  transform: rotateX(-14deg);
  transform-origin: 50% 0;
  transform-style: preserve-3d;
}
#bookmark > div > div {
  background: linear-gradient(top, rgb(151, 88, 88), rgb(189, 123, 123), rgb(151, 88, 88));
}
#bookmark > div > div > div {
  background: linear-gradient(top,rgb(151, 88, 88),rgb(133, 77, 77));
}
#bookmark > div > div > div > div {
  background: none;
  border-top: 0px solid transparent;
  border-right: 10px solid rgb(133, 77, 77);
  border-bottom: 10px solid transparent;
  border-left: 10px solid rgb(133, 77, 77);
  height: 0;
  width: 0;
}
#bookmark-shadow {
  background: linear-gradient(top,rgba(83, 53, 13, 0.25),rgba(83, 53, 13, 0.11));
  height: 15px;
  width: 20px;
  position: absolute;
  transform: translate3d(12px,350px,-25px) rotateX(-90deg) skewX(20deg);
  transform-origin: 0 0;
}

JS:

//You may also like Plugin
/*alsolike(
  "iqtlk", "Pure CSS Weather Icons",
  "nKCsI", "Semantic Sandwich",
  "vlrnd", "CSS Only iPhone 6"
);*/
```

效果预览：[https://codepen.io/fbrz/pen/whxbF](https://codepen.io/fbrz/pen/whxbF)

#### 案例3

```
HTML:

<section>
        <div class="at-at">
      <div class="at-at-content">
        <div class="at-at-body">
          <div class="at-at-head">
            <div class="at-at-neck">
              <div class="neck-ribs">
                <div class="neck-cable-first"></div>
                <div class="neck-cable-second"></div>
                <div class="neck-cable-last"></div>
                <i></i><i></i><i></i><i></i>
              </div>
              <div class="neck-bg"></div>
            </div>
            <div class="head-bg">
              <div class="head-snout">
                <div class="in-head-snout"></div>
                <div class="head-snout-gun"></div>
              </div>
              <i class="head-bg-first"></i>
              <i class="head-bg-second"></i>
            </div>
            <div class="head">
              <div class="head-chin">
                <i class="head-chin-bg-first"></i>
                <i class="head-chin-bg-second"></i>
                <i class="head-gun"></i>
                <i class="fire"><i></i><i></i><i></i></i>
              </div>
            </div>
            <i class="head-left-bg"></i>
            <i class="head-top-bg"></i>
          </div>
          <div class="at-at-body-left">
            <i class="at-at-body-left-bg-1"></i>
            <i class="at-at-body-left-bg-2"></i>
            <i class="at-at-body-left-bg-3"></i>
            <i class="at-at-body-left-bg-4"></i>
            <i class="at-at-body-left-bg-5"></i>
            <div class="at-at-body-left-bg"></div>
          </div>
          <div class="at-at-body-right">
            <i class="at-at-body-right-bg-1"></i>
            <i class="at-at-body-right-bg-2"></i>
            <i class="at-at-body-right-bg-3"></i>
            <i class="at-at-body-right-bg-4"></i>
            <i class="at-at-body-right-bg-5"></i>
            <div class="at-at-body-right-bg"></div>
          </div>
          <div class="at-at-body-bottom">
            <div class="at-at-body-bottom-bg"><i></i><i></i><i></i></div>
            <div class="body-bottom-left"></div>
          </div>
          <div class="at-at-body-bg">
            <i></i><i></i><i></i><i></i>
            <div class="i"></div>
          </div>
          <div class="at-at-body-bg-first-block">
            <i class="at-at-body-bg-first-block-item-1"></i>
            <i class="at-at-body-bg-first-block-item-2"></i>
            <i class="at-at-body-bg-first-block-item-3"></i>
          </div>
          <div class="at-at-body-bg-second-block">
            <i class="at-at-body-bg-second-block-item-1"></i>
            <i class="at-at-body-bg-second-block-item-2"></i>
          </div>
          <div class="at-at-body-bg-third-block">
            <i class="at-at-body-bg-third-block-item-1"></i>
            <i class="at-at-body-bg-third-block-item-2"></i>
            <i class="at-at-body-bg-third-block-item-3"></i>
          </div>
        </div>
        <div class="dark-bg">
          <i class="dark-bg-right"></i>
        </div>
      </div>
      <div class="leg-content leg-front">
        <div class="leg-first-joint"><i></i></div>
        <div class="leg-first">
          <i class="leg-first-hr-a"></i>
          <i class="leg-first-hr-b"></i>
          <div class="in-first-leg">
            <div class="leg-second-joint"><i></i></div>
            <div class="leg-second">
              <i class="leg-second-hr"></i>
              <div class="in-second-leg">
                <div class="foot-joint"><i class="foot-ankle"><i class="foot-ankle-bg"></i></i></div>
                <div class="foot-ankle-bottom"></div>
                <div class="foot-ankle-space"></div>
                <div class="foot">
                  <div class="foot-bottom"></div>
                  <div class="foot-land"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="leg-content leg-rear">
        <div class="leg-first-joint"><i></i></div>
        <div class="leg-first">
          <i class="leg-first-hr-a"></i>
          <i class="leg-first-hr-b"></i>
          <div class="in-first-leg">
            <div class="leg-second-joint"><i></i></div>
            <div class="leg-second">
              <i class="leg-second-hr"></i>
              <div class="in-second-leg">
                <div class="foot-joint"><i class="foot-ankle"><i class="foot-ankle-bg"></i></i></div>
                <div class="foot-ankle-bottom"></div>
                <div class="foot-ankle-space"></div>
                <div class="foot">
                  <div class="foot-bottom"></div>
                  <div class="foot-land"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="leg-content leg-front-back">
        <div class="leg-first-joint"><i></i></div>
        <div class="leg-first">
          <i class="leg-first-hr-a"></i>
          <i class="leg-first-hr-b"></i>
          <div class="in-first-leg">
            <div class="leg-second-joint"><i></i></div>
            <div class="leg-second">
              <i class="leg-second-hr"></i>
              <div class="in-second-leg">
                <div class="foot-joint"><i class="foot-ankle"><i class="foot-ankle-bg"></i></i></div>
                <div class="foot-ankle-bottom"></div>
                <div class="foot-ankle-space"></div>
                <div class="foot">
                  <div class="foot-bottom"></div>
                  <div class="foot-land"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="leg-content leg-rear-back">
        <div class="leg-first-joint"><i></i></div>
        <div class="leg-first">
          <i class="leg-first-hr-a"></i>
          <i class="leg-first-hr-b"></i>
          <div class="in-first-leg">
            <div class="leg-second-joint"><i></i></div>
            <div class="leg-second">
              <i class="leg-second-hr"></i>
              <div class="in-second-leg">
                <div class="foot-joint"><i class="foot-ankle"><i class="foot-ankle-bg"></i></i></div>
                <div class="foot-ankle-bottom"></div>
                <div class="foot-ankle-space"></div>
                <div class="foot">
                  <div class="foot-bottom"></div>
                  <div class="foot-land"></div>
                </div>                      
              </div>
            </div>
          </div>
        </div>
      </div>
  </div>

        <div class="bg">
            <i class="star star-1"></i>
            <i class="star star-2"></i>
            <i class="star star-3"></i>
            <i class="star star-4"></i>
            <i class="star star-5"></i>
            <i class="star star-6"></i>
            <i class="star-small star-small-1"></i>
            <i class="star-small star-small-2"></i>
            <i class="star-small star-small-3"></i>
            <i class="star-small star-small-4"></i>
            <i class="star-small star-small-5"></i>
            <i class="star-small star-small-6"></i>
            <i class="star-small star-small-7"></i>
            <i class="star-small star-small-8"></i>
            <i class="star-small star-small-9"></i>
            <i class="star-small star-small-10"></i>
        </div>
        <i class="moon"></i>
        <i class="mountain-first">
            <i class="mountain-shadow"></i>
        </i>
        <i class="mountain-second">
            <i class="mountain-shadow"></i>
            <span class="mountain-top"></span>
        </i>
        <div class="first-bg">
            <div class="first-bg-anim">
                <i class="first"></i>
                <i class="second"></i>
                <i class="third"></i>
                <i class="last"></i>
            </div>
            <div class="second-bg-anim">
                <div class="first-rock-content">
                    <div class="rock-content rock-content-1">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-2">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-3">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-4">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-5">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-6">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                </div>
                <div class="second-rock-content">
                    <div class="rock-content rock-content-1">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-2">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-3">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-4">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-5">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                    <div class="rock-content rock-content-6">
                        <i class="rock rock-big rock-1"></i>
                        <i class="rock rock-big rock-2"></i>
                        <i class="rock rock-big rock-3"></i>    
                        <i class="rock rock-middle rock-7"></i>
                        <i class="rock rock-middle rock-8"></i>
                        <i class="rock rock-middle rock-9"></i>
                        <i class="rock rock-middle rock-10"></i>
                        <i class="rock rock-middle rock-11"></i>
                        <i class="rock rock-middle rock-12"></i>
                        <i class="rock rock-middle rock-13"></i>
                        <i class="rock rock-middle rock-14"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="space-ship space-ship-small">
      <i class="space-ship-wing"></i>
      <i class="space-ship-bg"><i class="space-ship-gun"></i></i>
        </div>
        <div class="space-ship space-ship-big">
      <i class="space-ship-wing"></i>
      <i class="space-ship-bg"><i class="space-ship-gun"></i></i>
        </div>
    </section>

LESS:

// BODY
// ---------
*{
  -webkit-box-sizing: border-box;
   -khtml-box-sizing: border-box;
     -moz-box-sizing: border-box;
      -ms-box-sizing: border-box;
          box-sizing: border-box;
  *behavior: url(js/libs/boxsizing.htc);
}
html, body {
  .square(100%);
}

body {
  margin: 0;
  line-height: 1;
  color:@black;
  background:#0092ff;
}


// LAYOUT
// ---------
section{
  position:relative;
  .square(100%);
  min-height:500px;
  overflow:hidden;
}

.bg{
  position:absolute;
  left:0;
  top:0;
  .size(100%, 70%);
  z-index:1;

  .star{
    position:absolute;
    .square(10px);
    .border-radius(6px);
    background:@white;
    .opacity(50);
  }
  .star-small{
    position:absolute;
    .square(5px);
    .border-radius(3px);
    background:@white;
    .opacity(50);
  }
  .star-1{
    left:5%;
    top:40%;
  }
  .star-2{
    left:20%;
    top:5%;
  }
  .star-3{
    left:40%;
    top:20%;
  }
  .star-4{
    left:60%;
    top:5%;
  }
  .star-5{
    left:80%;
    top:60%;
  }
  .star-6{
    left:95%;
    top:10%;
  }

  .star-small-1{
    left:10%;
    top:15%;
  }
  .star-small-2{
    left:14%;
    top:25%;
  }
  .star-small-3{
    left:8%;
    top:60%;
  }
  .star-small-4{
    left:25%;
    top:40%;
  }
  .star-small-5{
    left:18%;
    top:75%;
  }
  .star-small-6{
    left:50%;
    top:40%;
  }
  .star-small-7{
    left:60%;
    top:20%;
  }
  .star-small-8{
    left:70%;
    top:40%;
  }
  .star-small-9{
    left:90%;
    top:20%;
  }
  .star-small-10{
    left:85%;
    top:40%;
  }
}
.moon{
  position:absolute;
  left:50%;
  top:25%;
  margin:-60px 0 0 -260px;
  .size(180px, 180px);
  .border-radius(90px);
  background: -moz-linear-gradient(-45deg,  rgba(255,255,255,1) 0%, rgba(255,255,255,0.99) 1%, rgba(255,255,255,0) 70%);
  background: -webkit-gradient(linear, left top, right bottom, color-stop(0%,rgba(255,255,255,1)), color-stop(1%,rgba(255,255,255,0.99)), color-stop(70%,rgba(255,255,255,0)));
  background: -webkit-linear-gradient(-45deg,  rgba(255,255,255,1) 0%,rgba(255,255,255,0.99) 1%,rgba(255,255,255,0) 70%);
  background: -o-linear-gradient(-45deg,  rgba(255,255,255,1) 0%,rgba(255,255,255,0.99) 1%,rgba(255,255,255,0) 70%);
  background: -ms-linear-gradient(-45deg,  rgba(255,255,255,1) 0%,rgba(255,255,255,0.99) 1%,rgba(255,255,255,0) 70%);
  background: linear-gradient(135deg,  rgba(255,255,255,1) 0%,rgba(255,255,255,0.99) 1%,rgba(255,255,255,0) 70%);
  .rotate(90deg);
  z-index:5;
}
.mountain-first{
  position:absolute;
  left:0;
  top:50%;
  margin-top:-260px;
  .size(550px, 400px);
  z-index:1;

  &:before{
    content:'';
    position:absolute;
    left:-100px;
    bottom:0;
    .square(0);
    border-style: solid;
    border-width: 0 300px 300px 200px;
    border-color: transparent transparent #4cb3ff transparent;
    z-index:2;
  }
  &:after{
    content:'';
    position:absolute;
    left:0;
    bottom:0;
    .size(100%, 60%);
    background: -moz-linear-gradient(top,  rgba(125,185,232,0) 0%, rgba(0,146,255,1) 65%);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(125,185,232,0)), color-stop(65%,rgba(0,146,255,1)));
    background: -webkit-linear-gradient(top,  rgba(125,185,232,0) 0%,rgba(0,146,255,1) 65%);
    background: -o-linear-gradient(top,  rgba(125,185,232,0) 0%,rgba(0,146,255,1) 65%);
    background: -ms-linear-gradient(top,  rgba(125,185,232,0) 0%,rgba(0,146,255,1) 65%);
    background: linear-gradient(to bottom,  rgba(125,185,232,0) 0%,rgba(0,146,255,1) 65%);
    .opacity(80);
    z-index:4;
  }
  .mountain-shadow{
    position:absolute;
    left:-100px;
    bottom:0;
    .square(0);
    border-style: solid;
    border-width: 0 450px 300px 200px;
    border-color: transparent transparent #7bc7ff transparent;
  }
}
.mountain-second{
  position:absolute;
  right:-10px;
  top:50%;
  margin-top:-240px;
  .size(500px, 400px);
  z-index:1;

  &:before{
    content:'';
    position:absolute;
    left:0;
    bottom:0;
    .square(0);
    border-style: solid;
    border-width: 0 350px 350px 300px;
    border-color: transparent transparent #4cb3ff transparent;
    z-index:2;
  }
  &:after{
    content:'';
    position:absolute;
    left:0;
    bottom:0;
    .size(100%, 100%);
    background: -moz-linear-gradient(top,  rgba(125,185,232,0) 0%, rgba(0,146,255,1) 65%);
    background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(125,185,232,0)), color-stop(65%,rgba(0,146,255,1)));
    background: -webkit-linear-gradient(top,  rgba(125,185,232,0) 0%,rgba(0,146,255,1) 65%);
    background: -o-linear-gradient(top,  rgba(125,185,232,0) 0%,rgba(0,146,255,1) 65%);
    background: -ms-linear-gradient(top,  rgba(125,185,232,0) 0%,rgba(0,146,255,1) 65%);
    background: linear-gradient(to bottom,  rgba(125,185,232,0) 0%,rgba(0,146,255,1) 65%);
    .opacity(80);
    z-index:4;
  }
  .mountain-shadow{
    position:absolute;
    left:0;
    bottom:0;
    .square(0);
    border-style: solid;
    border-width: 0 650px 350px 300px;
    border-color: transparent transparent #7bc7ff transparent;
  }
  .mountain-top{
    position:absolute;
    left:50%;
    top:110px;
    margin:0 0 0 30px;
    .square(50px);
    z-index:8;

    &:after{
      content:'';
      position:absolute;
      left:0;
      top:0;
      border-style: solid;
      border-width: 0 50px 20px 50px;
      border-color: transparent transparent #50b4ff transparent;
      .rotate(-125deg);
    }
    &:before{
      content:'';
      position:absolute;
      left:-5px;
      top:0;
      border-style: solid;
      border-width: 0 50px 20px 50px;
      border-color: transparent transparent #50b4ff transparent;
      .rotate(30deg);
    }
  }
}

.first-bg{
  position:absolute;
  left:-10%;
  top:50%;
  margin-top:120px;
  .size(120%, 10px);
  border-bottom: 580px solid #104166;
  border-left: 8px solid transparent;
  border-right: 14px solid transparent;
  height: 0;
  .rotate(2deg);
  z-index:100;
}
.first-bg-anim{
  position:absolute;
  left:0;
  top:0;
  .size(100%, auto);

  .first{
    position:absolute;
    left:-10%;
    bottom:-5px;
    .square(0);
    border-style: solid;
    border-width: 0 160px 60px 80px;
    border-color: transparent transparent #104166 transparent;
    animation: first-rock 30s infinite;
    animation-fill-mode: forwards;
    animation-timing-function: linear;

    &:before{
      content:'';
      position:absolute;
      left:0px;
      top:30px;
      .square(0);
      border-style: solid;
      border-width: 0 60px 20px 40px;
      border-color: transparent transparent #0c4a78 transparent;
      .rotate(-160deg);
    }
  }
  .second{
    position:absolute;
    left:-10%;
    bottom:-5px;
    .square(0);
    border-style: solid;
    border-width: 0 80px 80px 160px;
    border-color: transparent transparent #104166 transparent;
    animation: first-rock 30s infinite;
    animation-delay: 8s;
    animation-fill-mode: forwards;
    animation-timing-function: linear;

    &:before{
      content:'';
      position:absolute;
      left:-30px;
      top:35px;
      .square(0);
      border-style: solid;
      border-width: 0 20px 40px 60px;
      border-color: transparent transparent #0c4a78 transparent;
      .rotate(-135deg);
    }
  }
  .third{
    position:absolute;
    left:-10%;
    bottom:-5px;
    .square(0);
    border-style: solid;
    border-width: 0 160px 60px 80px;
    border-color: transparent transparent #104166 transparent;
    animation: first-rock 30s infinite;
    animation-delay: 16s;
    animation-fill-mode: forwards;
    animation-timing-function: linear;

    &:before{
      content:'';
      position:absolute;
      left:0px;
      top:30px;
      .square(0);
      border-style: solid;
      border-width: 0 60px 20px 40px;
      border-color: transparent transparent #0c4a78 transparent;
      .rotate(-160deg);
    }
  }
  .last{
    position:absolute;
    left:-10%;
    bottom:-5px;
    .square(0);
    border-style: solid;
    border-width: 0 80px 80px 160px;
    border-color: transparent transparent #104166 transparent;
    animation: first-rock 30s infinite;
    animation-delay:24s;
    animation-fill-mode: forwards;
    animation-timing-function: linear;

    &:before{
      content:'';
      position:absolute;
      left:-30px;
      top:35px;
      .square(0);
      border-style: solid;
      border-width: 0 20px 40px 60px;
      border-color: transparent transparent #0c4a78 transparent;
      .rotate(-135deg);
    }
  }
}

.second-bg-anim{
  position:absolute;
  left:0;
  top:0;
  .size(100%, auto);

  .first-rock-content{
    position:absolute;
    left:0;
    top:0;
    .size(100%, 100%);
    animation: rock 20s infinite;
    animation-fill-mode: forwards;
    animation-timing-function: linear;
  }
  .second-rock-content{
    //display:none;
    position:absolute;
    left:-100%;
    top:0;
    .size(100%, 100%);
    animation: rock 20s infinite;
    animation-fill-mode: forwards;
    animation-timing-function: linear;
  }
  .rock{
    position:absolute;
    overflow:hidden;

    &:before{
      content:'';
      position:absolute;
      left:50%;
      top:0;
      .border-radius(50px);
      background:#0c4a78;
    }
  }
  .rock-middle{
    .size(60px, 10px);

    &:before{
      margin:0 0 0 -50px;
      .square(100px);
    }
  }
  .rock-big{
    .size(76px, 22px);

    &:before{
      margin:0 0 0 -50px;
      .square(100px);
    }
  }
  .rock-content{
    //display:none;
    position:absolute;
    top:0;
    .size(25%, 100%);
  }
  .rock-content-1{
    display:block;
    left:0;
  }
  .rock-content-2{
    display:block;
    left:20%;
    top:-20px;
  }
  .rock-content-3{
    display:none;
    left:40%;
    top:30px;
  }
  .rock-content-4{
    left:60%;
    top:-20px;
  }
  .rock-content-5{
    left:80%;
  }
  .rock-content-6{
    display:none;
    left:90%;
  }
  .rock-1{
    left:70%;
    top:240px;
  }
  .rock-2{
    left:40%;
    top:150px;
  }
  .rock-3{
    display:none;
    left:90%;
    top:70px;
  }

  .rock-7{
    left:32%;
    top:50px;
  }
  .rock-8{
    left:64%;
    top:110px;
    display:none;
  }
  .rock-9{
    left:80%;
    top:130px;
    display:none;
  }
  .rock-10{
    left:74%;
    top:200px;
    display:none;
  }
  .rock-11{
    left:87%;
    top:170px;
  }
  .rock-12{
    left:35%;
    top:240px;
    display:none;
  }
  .rock-13{
    left:45%;
    top:100px;
    display:none;
  }
  .rock-14{
    left:65%;
    top:40px;

  }
}



// SPACE SHIP
.space-ship{
  position:absolute;
  left:-30%;
  top:20%;
  .size(97px, 32px);
  background:#104166;
  z-index:1000;
  -webkit-filter: blur(5px);
  -moz-filter: blur(5px);
  -o-filter: blur(5px);
  -ms-filter: blur(5px);
  filter: blur(5px);

  &:before{
    content:'';
    position:absolute;
    left:-9px;
    top:50%;
    margin:-11px 0 0 0;
    .size(9px, 22px);
    background:#104166;
  }
  &:after{
    content:'';
    position:absolute;
    left:100%;
    top:0;
    .square(0);
    border-style: solid;
    border-width: 32px 0 0 108px;
    border-color: transparent transparent transparent #104166;
  }
}
.space-ship-small{
  animation: ship 4s infinite;
  animation-fill-mode: forwards;
  animation-timing-function: ease-in;
  animation-delay: 4s;
}
.space-ship-big{
  left:-30%;
  top:50%;
  .scale(2.5);
  animation: ship 2s infinite;
  animation-fill-mode: forwards;
  animation-timing-function: ease-in;
  animation-delay: 4s;
}

.space-ship-wing{
  position:absolute;
  left:27px;
  top:-14px;
  .size(50px, 25px);
  background:#22689d;
  z-index:2;

  &:after{
    content:'';
    position:absolute;
    left:100%;
    top:0;
    .square(0);
    border-style: solid;
    border-width: 25px 0 0 37px;
    border-color: transparent transparent transparent #22689d;
  }
}
.space-ship-bg{
  position:absolute;
  left:32px;
  top:100%;
  .size(60px, 18px);
  background:#104166;

  &:before,
  &:after{
    content:'';
    position:absolute;
    top:0;
    .square(0);
    border-style: solid;
  }
  &:before{
    left:-12px;
    border-width: 0 12px 18px 0;
    border-color: transparent #104166 transparent transparent;
  }
  &:after{
    right:-12px;
    border-width: 18px 12px 0 0;
    border-color: #104166 transparent transparent transparent;
  }
}
.space-ship-gun{
  position:absolute;
  left:17px;
  top:1px;
  .size(30px, 10px);
  background:#22689d;
  z-index:2;

  &:after{
    content:'';
    position:absolute;
    left:100%;
    bottom:1px;
    .size(94px, 4px);
    background:#22689d;
  }
}




// AT-AT
.at-at{
  position:absolute;
  left:50%;
  top:50%;
  margin:-135px 0 0 -120px;
  .size(250px, 114px); // height 270px
  z-index:95;
}
.at-at-content{
  position:absolute;
  left:0;
  top:0;
  //margin-top:;
  .square(100%);
  z-index:10;

  .dark-bg{
    position:absolute;
    right:50px;
    bottom:-10px;
    .size(145px, 104px);
    background:#104166;

    &:before,
    &:after{
      content:'';
      position:absolute;
      bottom:-22px;
      .square(60px);
      .border-radius(30px);
      background:#104166;
    }
    &:before{
      left:-43px;
    }
    &:after{
      right:-45px;
    }
  }
  .dark-bg-right{
    position:absolute;
    left:100%;
    bottom:0;
    .size(50px, 50px);
    background:#104166;

    &:after{
      content:'';
      position:absolute;
      right:-14px;
      top:0;
      .square(0);
      border-style: solid;
      border-width: 50px 14px 0 0;
      border-color: #104166 transparent transparent transparent;
    }
    &:before{
      content:'';
      position:absolute;
      right:-14px;
      top:-18px;
      .square(0);
      border-style: solid;
      border-width: 18px 0 0 54px;
      border-color: transparent transparent transparent #104166;
    }
  }
}


.at-at-body{
  position:absolute;
  left:75px;
  top:-16px;
  margin-top:15px;
  .size(100px, 96px);
  background:@white;
  z-index:20;
  animation: at-at-body 2.5s infinite;
  animation-timing-function: ease-out;
}
.at-at-body-bg{
  position:absolute;
  left:7px;
  bottom:7px;
  padding:4px 5px 0 65px;
  .size(86px, 32px);
  .border-radius(6px);
  background:#9fd6ff;
  .c;

  .i{
    position:absolute;
    left:6px;
    top:12px;
    .size(4px, 8px);
    .border-radius(2px);
    background:#104166;
  }
  &> i{
    float:right;
    margin:0 0 2px 0;
    .size(16px, 4px);
    .border-radius(2px);
    background:#104166;
  }
}
.at-at-body-bg-first-block{
  position:absolute;
  left:0;
  top:0;
  .size(35%, 57px);
  border-right:2px solid #9fd6ff;

  i{
    position:absolute;
    .size(4px, 8px);
    .border-radius(2px);
    background:#9fd6ff;
  }
  .at-at-body-bg-first-block-item-1{
    left:9px;
    top:10px;
  }
  .at-at-body-bg-first-block-item-2{
    left:15px;
    top:10px;
  }
  .at-at-body-bg-first-block-item-3{
    left:15px;
    top:34px;
  }
}
.at-at-body-bg-second-block{
  position:absolute;
  left:35%;
  top:0;
  .size(30%, 57px);

  i{
    position:absolute;
    .size(4px, 8px);
    .border-radius(2px);
    background:#9fd6ff;
  }
  .at-at-body-bg-second-block-item-1{
    left:18px;
    top:10px;
  }
  .at-at-body-bg-second-block-item-2{
    left:8px;
    top:34px;
  }
}
.at-at-body-bg-third-block{
  position:absolute;
  right:0;
  top:0;
  .size(35%, 57px);
  border-left:2px solid #9fd6ff;

  i{
    position:absolute;
    .size(4px, 8px);
    .border-radius(2px);
    background:#9fd6ff;
  }
  .at-at-body-bg-third-block-item-1{
    left:10px;
    top:10px;
  }
  .at-at-body-bg-third-block-item-2{
    left:16px;
    top:10px;
  }
  .at-at-body-bg-third-block-item-3{
    left:5px;
    top:34px;
  }
}

.at-at-head{
  position:absolute;
  right:100%;
  bottom:-5px;
  margin:0 88px 0 0;
  .size(64px, 38px);
  background:@white;
}

.at-at-neck{
  position:absolute;
  left:100%;
  bottom:10px;
  .size(34px, 36px);

  .neck-bg{
    position:absolute;
    left:0;
    top:0;
    .square(100%);
    background:#104166;

    &:after{
      content:'';
      position:absolute;
      top:-15px;
      left:0;
      .square(0);
      border-style: solid;
      border-width: 0 0 15px 34px;
      border-color: transparent transparent #104166 transparent;
    }
  }
  .neck-ribs{
    position:absolute;
    left:0;
    top:-2px;
    .size(100%, 40px);
    z-index:2;
    overflow:hidden;
    .c;

    i{
      float:left;
      margin:0 0 0 2px;
      .size(6px, 100%);
      background:#9fd6ff;
    }
    .neck-cable-first{
      position:absolute;
      left:-6px;
      top:0px;
      .size(8px, 200%);
      background:@white;
      .rotate(-20deg);
      .transition-timing(left top);
    }
    .neck-cable-second{
      position:absolute;
      left:16px;
      top:0px;
      .size(8px, 200%);
      background:@white;
      .rotate(-20deg);
      .transition-timing(left top);
    }
    .neck-cable-last{
      position:absolute;
      left:32px;
      top:0px;
      .size(8px, 200%);
      background:@white;
      .rotate(20deg);
      .transition-timing(left top);
    }
  }
}

.head-bg{
  position:absolute;
  left:0;
  top:0;
  .square(100%);
  z-index:10;

  i{
    position:absolute;
    .size(4px, 8px);
    .border-radius(2px);
    background:#9fd6ff;
  }
  .head-bg-first{
    right:6px;
    top:-6px;
  }
  .head-bg-second{
    right:6px;
    bottom:7px;
  }
}
.head-snout{
  position:absolute;
  left:5px;
  top:3px;
  .square(34px);
  .border-radius(18px);
  border:3px solid #9fd6ff;

  .in-head-snout{
    position:absolute;
    right:0;
    top:0;
    .square(14px);
    overflow:hidden;

    &:after{
      content:'';
      position:absolute;
      right:0;
      top:0;
      .border-radius(20px);
      .square(20px);
      border:4px solid #9fd6ff;
    }
  }
  .head-snout-gun{
    position:absolute;
    bottom:2px;
    left:-8px;
    .size(16px, 4px);
    background:#9fd6ff;

    &:before{
      content:'';
      position:absolute;
      left:-8px;
      top:-2px;
      .size(8px, 8px);
      background:#9fd6ff;
    }
    &:after{
      content:'';
      position:absolute;
      right:-12px;
      top:-2px;
      .size(12px, 8px);
      background:#9fd6ff;
    }
  }
}
.head{
  position:absolute;
  left:0;
  top:0;
  .size(100%, 100%);
  z-index:5;

  &:after{
    content:'';
    position:absolute;
    left:0;
    top:-15px;
    .square(0);
    border-style: solid;
    border-width: 0 0 15px 64px;
    border-color: transparent transparent @white transparent;
  }
  &:before{
    content:'';
    position:absolute;
    top:0;
    left:-16px;
    .square(0);
    border-style: solid;
    border-width: 0 0 38px 16px;
    border-color: transparent transparent @white transparent;
  }
}
.head-chin{
  position:absolute;
  left:5px;
  bottom:-9px;
  .size(18px, 9px);
  background:@white;

  &:before{
    content:'';
    position:absolute;
    left:-6px;
    top:0;
    .square(0);
    border-style: solid;
    border-width: 0 6px 9px 0;
    border-color: transparent @white transparent transparent;
    z-index:5;
  }
  &:after{
    content:'';
    position:absolute;
    right:-18px;
    top:0;
    .square(0);
    border-style: solid;
    border-width: 9px 18px 0 0;
    border-color: @white transparent transparent transparent;
  }
  .head-chin-bg-first{
    position:absolute;
    left:5px;
    bottom:0;
    .size(4px, 6px);
    .border-radius(2px 2px 0 0);
    background:#104166;
  }
  .head-chin-bg-second{
    position:absolute;
    left:11px;
    bottom:0;
    .size(4px, 6px);
    .border-radius(2px 2px 0 0);
    background:#104166;
  }
}
.head-gun{
  position:absolute;
  right:20px;
  bottom:0;
  .size(25px, 4px);
  background:#104166;
  z-index:5;
  animation: fire-back 2.5s infinite;
  animation-timing-function: ease-out;

  &:after{
    content:'';
    position:absolute;
    left:-8px;
    top:-2px;
    .size(8px, 8px);
    background:#2d445d;
  }
}
.fire{
  position:absolute;
  left:-34px;
  bottom:1px;
  .size(36px, 2px);
  animation: fire 2.5s infinite;
  animation-timing-function: ease-out;
  .c;

  i{
    float:left;
    margin:0 0 0 4px;
    .size(8px, 2px);
    background:@white;
  }
}
.head-left-bg{
  position:absolute;
  left:-16px;
  top:12px;
  .size(8px, 12px);
  background:#2d445d;
  .rotate(22deg);

  &:after{
    content:'';
    position:absolute;
    left:0;
    top:-8px;
    .square(0);
    border-style: solid;
    border-width: 0 0 8px 8px;
    border-color: transparent transparent #2d445d transparent;
  }
}
.head-top-bg{
  position:absolute;
  left:4px;
  top:-12px;
  display:block;
  .size(32px, 8px);
  overflow:hidden;
  z-index:1;
  .rotate(-14deg);

  &:after{
    content:'';
    position:absolute;
    bottom:0;
    left:0;
    .square(0);
    border-style: solid;
    border-width: 0 16px 50px 16px;
    border-color: transparent transparent #2d445d transparent;
  }
}


.at-at-body-left{
  position:absolute;
  right:100%;
  top:28px;
  margin:0 4px 0 0;
  .size(50px, 68px);
  background:@white;

  &:after{
    content:'';
    position:absolute;
    left:0;
    top:-16px;
    .square(0);
    border-style: solid;
    border-width: 0 0 16px 50px;
    border-color: transparent transparent @white transparent;
  }
}
.at-at-body-left-bg{
  position:absolute;
  left:16px;
  top:16px;
  .size(20px, 24px);
  .border-radius(6px);
  background:#9fd6ff;
}
.at-at-body-left-bg-1,
.at-at-body-left-bg-2,
.at-at-body-left-bg-3,
.at-at-body-left-bg-4,
.at-at-body-left-bg-5{
  position:absolute;
  .size(4px, 8px);
  .border-radius(2px);
  background:#9fd6ff;
}
.at-at-body-left-bg-1{
  left:21px;
  top:6px;
}
.at-at-body-left-bg-2{
  left:27px;
  top:6px;
}
.at-at-body-left-bg-3{
  left:39px;
  top:6px;
}
.at-at-body-left-bg-4{
  left:7px;
  bottom:7px;
}
.at-at-body-left-bg-5{
  left:13px;
  bottom:7px;
}
.at-at-body-right{
  position:absolute;
  left:100%;
  top:31px;
  margin:0 0 0 4px;
  .size(68px, 65px);
  background:@white;

  &:after{
    content:'';
    position:absolute;
    left:0;
    top:-26px;
    .square(0);
    border-style: solid;
    border-width: 26px 0 0 68px;
    border-color: transparent transparent transparent @white;
  }
}
.at-at-body-right-bg-1,
.at-at-body-right-bg-2,
.at-at-body-right-bg-3,
.at-at-body-right-bg-4,
.at-at-body-right-bg-5{
  position:absolute;
  .size(4px, 8px);
  .border-radius(2px);
  background:#9fd6ff;
}
.at-at-body-right-bg-1{
  left:4px;
  top:4px;
}
.at-at-body-right-bg-2{
  left:31px;
  top:4px;
}
.at-at-body-right-bg-3{
  left:37px;
  top:4px;
}
.at-at-body-right-bg-4{
  left:59px;
  top:4px;
}
.at-at-body-right-bg-5{
  left:4px;
  bottom:7px;
}
.at-at-body-right-bg{
  position:absolute;
  right:5px;
  bottom:7px;
  .size(32px, 32px);
  .border-radius(6px);
  background:#9fd6ff;

  &:after{
    content:'';
    position:absolute;
    right:5px;
    top:5px;
    .size(10px, 10px);
    background:#104166;
  }
}
.at-at-body-bottom{
  position:absolute;
  right:0;
  top:100%;
  margin-top:3px;
  .size(60px, 20px);
  background:@white;

  .body-bottom-left{
    position:absolute;
    left:-40px;
    top:0;
    .size(40px, 20px);

    &:before{
      content:'';
      position:absolute;
      left:0;
      top:0;
      .square(0);
      border-style: solid;
      border-width: 0 48px 16px 0;
      border-color: transparent @white transparent transparent;
    }
    &:after{
      content:'';
      position:absolute;
      left:25px;
      bottom:0;
      .square(0);
      border-style: solid;
      border-width: 0 15px 12px 0;
      border-color: transparent @white transparent transparent;
    }
  }
}
.at-at-body-bottom-bg{
  padding:4px 0 4px 15px;
  .size(100%, 100%);
  .c;

  i{
    float:left;
    margin:0 3px 0 0;
    .size(4px, 12px);
    .border-radius(2px);
    background:#104166;
  }
}





.leg-front-back{
  left:30px;
  z-index:5;
  animation: legs 10s infinite;
  animation-delay: 5s;

  .leg-first{
    animation: leg-first 10s infinite;
    animation-delay: 5s;
  }
  .leg-second{
    animation: leg-second 10s infinite;
    animation-delay: 5s;
  }
  .in-second-leg{
    animation: leg-foot 10s infinite;
    animation-delay: 5s;
  }
}
.leg-rear-back{
  left:203px;
  z-index:5;
  animation: legs 10s infinite;
  animation-delay: 7.5s;

  .leg-first{
    animation: leg-first 10s infinite;
    animation-delay: 7.5s;
  }
  .leg-second{
    animation: leg-second 10s infinite;
    animation-delay: 7.5s;
  }
  .in-second-leg{
    animation: leg-foot 10s infinite;
    animation-delay: 7.5s;
  }
}
.leg-front{
  left:30px;
  z-index:15;
  animation: legs 10s infinite;

  .leg-first{
    animation: leg-first 10s infinite;
  }
  .leg-second{
    animation: leg-second 10s infinite;
  }
  .in-second-leg{
    animation: leg-foot 10s infinite;
  }
}
.leg-rear{
  left:203px;
  z-index:15;
  animation: legs 10s infinite;
  animation-delay: 2.5s;

  .leg-first{
    animation: leg-first 10s infinite;
    animation-delay: 2.5s;
  }
  .leg-second{
    animation: leg-second 10s infinite;
    animation-delay: 2.5s;
  }
  .in-second-leg{
    animation: leg-foot 10s infinite;
    animation-delay: 2.5s;
  }
}



.leg-content{
  position:absolute;
  bottom:-15px;
  .square(40px);

  .leg-first-joint{
    position:absolute;
    left:-8px;
    bottom:-8px;
    .border-radius(20px);
    border:4px solid @white;
    .square(40px);
    background:#9fd6ff;
    z-index:2;

    i{
      position:absolute;
      left:0;
      top:50%;
      margin-top:-5px;
      .size(100%, 10px);
      background:@white;

      &:after{
        content:'';
        position:absolute;
        left:50%;
        top:50%;
        margin:-2px 0 0 -4px;
        .size(8px, 4px);
        background:#9fd6ff;
      }
    }
  }
  .leg-first{
    position:absolute;
    left:0;
    top:35px;
    .size(28px, 60px);
    background:#9fd6ff;
    .rotate(-30deg);
    .transition-timing(left top);

    .leg-first-hr-a,
    .leg-first-hr-b{
      position:absolute;
      left:8px;
      top:0;
      .size(2px, 100%);
      background:#104166;
    }
    .leg-first-hr-b{
      left:auto;
      right:8px;
    }
  }
  .in-first-leg{
    position:absolute;
    left:-6px;
    bottom:-6px;
    .square(40px);
  }

  .leg-second-joint{
    position:absolute;
    left:4px;
    top:20px;
    .border-radius(20px);
    border:4px solid @white;
    .square(32px);
    background:#9fd6ff;
    z-index:2;

    i{
      position:absolute;
      left:0;
      top:50%;
      margin-top:-3px;
      .size(100%, 6px);
      background:@white;
    }
  }
  .leg-second{
    position:absolute;
    //left:20px;
    left:6px;
    top:30px;
    .size(28px, 50px);
    background:#9fd6ff;
    .transition-timing(left top);

    .leg-second-hr{
      position:absolute;
      left:50%;
      top:0;
      margin:0 0 0 -3px;
      .size(6px, 60%);
      .border-radius(0 0 4px 4px);
      background:#104166;
    }
  }
  .in-second-leg{
    position:absolute;
    left:0px;
    bottom:-15px;
    .square(40px);
    .rotate(30deg);
    .transition-timing(left top);
  }

  .foot-joint{
    position:absolute;
    left:0px;
    top:2px;
    .size(40px, 18px);
    //.border-radius(26px);
    //border:4px solid @white;
    //background:#9fd6ff;
    overflow:hidden;
    z-index:2;

    .foot-ankle{
      position:relative;
      display:block;
      .square(100%);

      &:before,
      &:after{
        content:'';
        position:absolute;
        bottom:2px;
        .square(8px);
        .border-radius(4px);
        background:#9fd6ff;
        z-index:4;
      }
      &:before{
        left:9px;
      }
      &:after{
        right:9px;
      }
    }
    .foot-ankle-bg{
      position:absolute;
      left:0;
      bottom:0;
      .square(0);
      border-style: solid;
      border-width: 0 20px 100px 20px;
      border-color: transparent transparent @white transparent;
    }
  }
  .foot-ankle-bottom{
    position:absolute;
    top:18px;
    .size(40px, 8px);
    overflow:hidden;
    z-index:2;

    &:after{
      content:'';
      position:absolute;
      left:0;
      top:1px;
      .square(0);
      border-style: solid;
      border-width: 40px 20px 0 20px;
      border-color: @white transparent transparent transparent;
    }
  }
  .foot-ankle-space{
    position:absolute;
    left:-5px;
    top:14px;
    .size(50px, 26px);
    .border-radius(20px 20px 0 0);
    border:8px solid #9fd6ff;
    border-bottom:3px solid #9fd6ff;
  }
  .foot{
    position:absolute;
    left:50%;
    top:30px;
    margin:0 0 0 -12px;
    .size(24px, 37px);
    background:@white;
  }
  .foot-bottom{
    position:absolute;
    left:50%;
    bottom:0;
    margin:0 0 0 -27px;
    .size(54px, 18px);
    overflow:hidden;
    z-index:2;

    &:before{
      content:'';
      position:absolute;
      left:0;
      bottom:0;
      .square(0);
      border-style: solid;
      border-width: 0 27px 100px 27px;
      border-color: transparent transparent @white transparent;
    }
    &:after{
      content:'';
      position:absolute;
      left:50%;
      bottom:0;
      margin:0 0 0 -8px;
      .size(16px, 4px);
      background:#9fd6ff;
    }
  }
  .foot-land{
    position:absolute;
    left:50%;
    bottom:0;
    margin:0 0 0 -40px;
    .size(80px, 10px);
    overflow:hidden;

    &:before{
      content:'';
      position:absolute;
      left:50%;
      bottom:0;
      margin:0 0 0 -60px;
      .square(0);
      border-style: solid;
      border-width: 0 60px 10px 60px;
      border-color: transparent transparent #9fd6ff transparent;
    }
  }
}


.leg-front-back,
.leg-rear-back{
  .leg-first-joint{
    border-color:#104166;
    background:#104166;

    i{
      display:none;
    }
  }
  .leg-first{
    background:#104166;
  }
  .leg-second-joint{
    border-color:#22689d;
    background:#22689d;

    i{
      display:none;
    }
  }
  .leg-second{
    background:#104166;
  }


  .foot-joint{
    .foot-ankle{
      &:before,
      &:after{
        display:none;
      }
    }
    .foot-ankle-bg{
      border-color: transparent transparent #22689d transparent;
    }
  }
  .foot-ankle-bottom{
    &:after{
      border-color: #22689d transparent transparent transparent;
    }
  }
  .foot-ankle-space{
    border:8px solid #104166;
    border-bottom:3px solid #104166;
  }
  .foot{
    background:#22689d;
  }
  .foot-bottom{
    &:before{
      border-color: transparent transparent #22689d transparent;
    }
    &:after{
      background:#104166;
    }
  }
  .foot-land{
    &:before{
      border-color: transparent transparent #104166 transparent;
    }
  }
}


@keyframes ship {
  0% {
    left:-30%;
  }
  100% {
    left:1000%;
  }
}


@keyframes rock {
  0% {
    margin-left:0%;
  }
  100% {
    margin-left:100%;
  }
}

@keyframes first-rock {
  0% {
    left:-10%;
  }
  100% {
    left:110%;
  }
}



@keyframes fire-back {
  0% {
    width:25px;
  }
  40% {
    width:25px;
  }
  45% {
    width:20px;
  }
  50% {
    width:25px;
  }
  100% {
    width:25px;
  }
}

@keyframes fire {
  0% {
    left:-34px;
  }
  50% {
    left:-34px;
  }
  100% {
    left:-1000px;
  }
}


@keyframes at-at-body {
  0% {
    margin-top:15px;
  }
  20% {
    margin-top:10px;
  }
  75% {
    margin-top:10px;
  }
  80% {
    margin-top:15px;
  }
  100% {
    margin-top:15px;
  }
}



@keyframes legs {
  0% {
    bottom:-15px;
  }
  10% {
    bottom:-5px;
  }
  15% {
    bottom:-5px;
  }
  25% {
    bottom:-15px;
  }
}



@keyframes leg-first {
  0% {
    left:0px;
    .rotate(-30deg);
  }
  15% {
    left:0;
    top:20px;
    height:50px;
    .rotate(40deg);
  }
  30% {
    left:0;
    top:20px;
    height:60px;
    .rotate(40deg);
  }
}



@keyframes leg-second {
  0% {
    top:30px;
    left:6px;
    height:50px;
    .rotate(0deg);
  }
  15% {
    top:50px;
    left:10px;
    height:50px;
    .rotate(-60deg);
  }
  25% {
    top:45px;
    left:5px;
    height:50px;
    .rotate(0deg);
  }
  33% {
    top:45px;
    left:5px;
    height:50px;
    .rotate(0deg);
  }
  50% {
    height:30px;
  }

  60% {
    height:35px;
  }
}


@keyframes leg-foot {
  0% {
    left:0px;
    bottom:-15px;
    .rotate(30deg);
  }
  15% {
    left:-5px;
    bottom:-25px;
    .rotate(10deg);
  }
  20% {
    left:-5px;
    bottom:-40px;
    .rotate(-35deg);
    //background:red;
  }
  25% {
    left:-5px;
    bottom:-40px;
    .rotate(-35deg);
  }
  33% {
    left:-5px;
    bottom:-40px;
    .rotate(-30deg);
  }
}




@media screen and (max-width: 1025px) , screen and (max-height: 500px){

  .at-at{
    margin-top:-95px;
    .scale(0.8);
  }

  .mountain-first{
    left:-80px;
    .scale(0.8);
  }
  .mountain-second{
    right:-100px;
    .scale(0.8);
  }

  .first-bg-anim{
    .second{
      display:none;
    }
    .last{
      display:none;
    }
  }

}


@media screen and (max-width: 740px) , screen and (max-height: 500px){

  section{
    min-height:0;
  }

  .at-at{
    margin-top:-35px;
    .scale(0.5);
  }

  .moon{
    position:absolute;
    left:50%;
    top:25%;
    margin:-60px 0 0 -180px;
    .square(100px);
  }

  .mountain-first{
    left:-150px;
    margin-top:-170px;
    .scale(0.5);
  }
  .mountain-second{
    right:-180px;
    margin-top:-160px;
    .scale(0.5);
  }

}



@media screen and (max-width: 500px) , screen and (max-height: 400px){

  .moon{
    margin:-60px 0 0 -100px;
  }

  .first-bg-anim{
    .third{
      display:none;
    }
  }

}


// Sizing shortcuts
// -------------------------
.size(@width: 5px, @height: 5px) {
  width: @width;
  height: @height;
}
.square(@size: 5px) {
  .size(@size, @size);
}

// Border Radius
.border-radius(@radius: 5px) {
  -webkit-border-radius: @radius;
     -moz-border-radius: @radius;
          border-radius: @radius;
}

// Opacity
.opacity(@opacity: 100) {
  opacity: @opacity / 100;
   filter: e(%("alpha(opacity=%d)", @opacity));
}

// Transformations
.rotate(@degrees) {
  -webkit-transform: rotate(@degrees);
     -moz-transform: rotate(@degrees);
      -ms-transform: rotate(@degrees);
       -o-transform: rotate(@degrees);
          transform: rotate(@degrees);
}
.scale(@ratio) {
  -webkit-transform: scale(@ratio);
     -moz-transform: scale(@ratio);
      -ms-transform: scale(@ratio);
       -o-transform: scale(@ratio);
          transform: scale(@ratio);
}
.transition-timing(@origin) {
  -webkit-transform-origin: @origin;
     -moz-transform-origin: @origin;
       -o-transform-origin: @origin;
          transform-origin: @origin;
}



// Clearfix
// --------
// For clearing floats like a boss h5bp.com/q
.c {
 .clearfix();
}
.clearfix() {
  *zoom: 1;
  &:before,
  &:after {
    display: table;
    content: "";
  }
  &:after {
    clear: both;
  }
}


@white:     #fff;
@black:			#000;
```

效果预览：[codepen.io/r4ms3s/pen/gajVBG](https://codepen.io/r4ms3s/pen/gajVBG)


## Conclusion

So does CSS have its quirks? Sure. The box model is a bit weird, flexbox isn’t the easiest thing to learn, and it’d be great if features like CSS variables were available years ago.

Every styling system has its warts, but CSS’s flexibility, simplicity, and pure power have stood the test of time, and have helped make the web the powerful development platform it is today. I’m happy to defend CSS against the CSS haters, and I encourage you to do the same.

*Header image based upon [Valentines by Misha Gardner](https://flic.kr/p/bpWQ7a)*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
