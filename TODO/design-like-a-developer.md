> * 原文地址：[Design like a Developer](https://medium.com/going-your-way-anyway/design-like-a-developer-b92f7a8f4520#.ohgf4aagn)
* 原文作者：[Chris Basha](https://medium.com/@BashaChris)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Airmacho](https://github.com/Airmacho)
* 校对者：

---

![](https://cdn-images-1.medium.com/max/1600/1*cUlwzVshahSl9DM4DZApYQ.jpeg)

Westworld, HBO

# Design like a Developer

## 像开发人员一样做设计

Longer title: Design in Sketch as if you were building UI in a development environment

长标题：像在开发环境中搭建 UI 一样在 Sketch 中设计

---

First of all, this is the only time Photoshop is going to be mentioned in this article. It’s 2017 — do yourself a favor and download Sketch (or Figma — I don’t care as long as it’s not Photoshop).

首先，这将是本文中唯一一次提到 Photoshop。现在是 2017 年了，为自己好，去下载 Sketch（或者 Figma — 只要不是 Photoshop 就行） 用吧。

UI design has come a long way, and so have image manipulation programs (if you can even call them that nowadays). We remember creating our first UIs in GIMP, and now that we’ve got MacBooks we’re using Sketch for almost everything UI related.

UI 设计已经有了长足的发展，图像处理程序也是如此（如果你现在还这么称呼它们的话）。我们仍记得在 GIMP 中创建我的第一套 UI，现在有了 MacBook，几乎可以用 Sketch 完成 UI 相关的所有工作。

Here’s the thing, though; Sketch has been created with designers in mind. It’s been built with the purpose of helping designers create user interfaces — and you can create pretty amazing things with it. But don’t forget that when you’re building a product, your duty ends when your design is shipped, not when you “finalize” that Sketch file.

事情是这样的，尽管，Sketch 是为设计人员打造的。其使命是帮助设计人员创建用户界面 — 你可以用它创建相当惊艳的东西。但不要忘了，你是在打造一个产品，在设计被交付时，你的工作才算完成，而不是当你“定稿” Sketch 文件时。

Your design has to go through a developer and be built in a development environment. This is where the problem lies; if you look at Sketch and a UI builder in a development environment (or *IDEs*, e.g. Xcode and Android Studio) side by side, you will not see many similarities.

你的设计必须经由开发人员在开发环境中构建。这就是问题所在：如果你比较 Sketch 和开发环境中的 UI 构建工具（或者 IDE，比如 Xcode，Android Studio)，两者相似之处非常少。

The way a developer builds your design is fundamentally different from the way you, as a designer, create it in Sketch. It sounds kind of stupid when you put it into perspective, doesn’t it?

开发人员构建你的设计的方式，与你作为一个设计师，在 Sketch 中创建的方式完全不同。如果这么想，听起来有些蠢，不是吗？

![](https://cdn-images-1.medium.com/max/1600/1*SILxrapOSVGmc4sLIaM3CA.png)

Xcode, Sketch, and Android Studio (and some lightning bolts)

Xcode，Sketch 和 Android Studio（和一些闪电符号）

That’s okay, though! This article is going to describe a design approach which comes a little bit closer to what a developer goes through when they build your design (it’s a struggle…).

没关系，这篇文章就是介绍一种设计方法，它更接近开发人员构建你的设计时的方式（好拗口）。

---

### **Think in “Views”**

You know *Symbols* in Sketch, right? We were really excited to use this feature when we switched to Sketch because it comes so close to how developers build UIs. Most of the time when you see things such as list items or action bars, they have one single source **view** that gets reused again and again.

### 以“视图”思考

你知道 Sketch 中的 **Symbol** 功能，是吧？当开始用 Sketch 时，我们对这个功能非常着迷，因为这如此接近开发人员构建 UI 的方式。多数情况下，当你观察例如列表项或者操作栏时，它们都可以看作一个独立的源**视图**不断被复用。

![](https://cdn-images-1.medium.com/max/800/1*nhQf6v6HBbnhR7lWbq7Ehw.png)

![](https://cdn-images-1.medium.com/max/800/1*z12CHMxb0YJxT7vppoCciQ.png)

![](https://cdn-images-1.medium.com/max/800/1*cJqbNsqX7jQ0vCynbSpYMA.png)

The most important guideline of designing like a developer is to think of your design in terms of *Views*. Think of a View as an independent group of elements which has defined borders and is sorted in hierarchical order.

像开发人员一样设计，最重要的指导原则就是根据**视图**来思考你的设计。将 View 视为独立的一组元素，它们已定义了边界，并按照层次排好顺序了。

As an example, the Search Results screen of our Nimber app on Android is divided into two main views; the Top View which contains the Action Bar as well as a Card with the user-entered locations and filters, and a List View with the returned search results.

例如，Android 的 Nimber 应用的搜索结果屏幕可以分成两种主要视图：由操作栏和包含了用户位置输入及筛选卡片组成的顶部视图，返回搜索结果的列表视图。

In the Blueprint or Skeleton above, you can see how the view bounds are clearly defined in the design. **These are layers that are invisible in the Sketch file (0% opacity)**, but they’re extremely useful when handing over the design to your developers.

在上面的线框图和结构图中，你可以看到视图的边界是如何在设计中被清晰定义的。Sketch 中有很多不见的图层（透明度为0%），这在交给开发人员时非常有用。

See below how the Action Bar is broken down into smaller Views.

看下面操作栏是如何被分解成更小的视图的。

![](https://cdn-images-1.medium.com/max/1600/1*gcQLtwSi9its2BBZ5zpGtg.png)

Top Level of View Hierarchy

视图层级的最顶层

![](https://cdn-images-1.medium.com/max/1600/1*eAXV4sx5uwqlPbllrhWmFw.png)

ActionBar View

操作栏视图

![](https://cdn-images-1.medium.com/max/1600/1*g4gsq4tDW707agveiSOzNg.png)

Action Items with View Bounds at 100% opacity
Make sure to not just group your layers randomly. Define their sizes and spacing in a clear way (avoid odd numbers) and sort everything in hierarchical order.

确保不要随机把图层分类。以清晰的方式定义它们的尺寸和间距（避免奇数），并按层级顺序排序。

The same applies for layer styles, for cases where you need to use consistent strokes, rounded corners, drop shadows, you name it.

同样的原则也适用于图层的样式，当你需要统一的笔触，圆角，阴影时，也可以这样做。

This app called [Zeplin](https://zeplin.io) helps a lot here. Long story short: you import your design in there, and the app extracts all view sizes, text sizes, colors, etc. in a developer oriented way. It’s a great tool that bridges the gap between designers and developers, and I can’t wait to see what it holds for the future.

这个叫 [Zeplin](https://zeplin.io) 的应用非常有用。简单说：你可以在应用中引入你的设计，应用会以一个开发人员使用的方式，抽取所有视图的尺寸，文本大小，颜色等。这是一个可以填补设计和开发差异的很棒的工具，我迫不及待地想看到它后续功能。

When you hand over your design, the developer can look at Zeplin and extract the sizes, margins, paddings from one single item, and create the view in their IDE accordingly.

当你交付设计后，开发人员可以在 Zeplin 中提取某个项目的尺寸，边距，留白等信息，再在 IDE 中创建相应的视图。

### Design in 1x

### 按 1x 设计

Why is this even up here…

By designing in **1x**, first you help yourself by not having to calculate sizes in other screen densities, but most importantly, both you and the developer end up using the same numbers. This way you prevent any miscalculations when handing over your design, and keep a consistent set of values.

This applies to view sizes, text sizes, line heights, most numbers really…

为什么会在这里。。。

按 **1x** 设计指的是，最开始你不必计算其他屏幕的比例大小，重要的是，你和开发人员最终都用相同的参数。这样可以防止交付你的设计时出现计算错误，保持一组统一的值。

这是适用于视图尺寸，文本尺寸，行高等绝大部分与数字相关的设计。

### Consistent Color Palette

### 一致的调色板

Create once, always reuse. Try to have as few colors as possible.

一次创建，多次重用。尝试尽可能少的颜色。

![](https://cdn-images-1.medium.com/max/1200/1*MwWQuonkMOBlroqzqD9l2Q.png)

You’ll see developers mostly use names such as *Primary, Secondary, Accent, Enabled, Disabled* etc. You can do the same thing. *Primary* and *Secondary* can be your text colors, *Accent* can be your brand’s color, you get the point.

开发人员最常用的命名是  *Primary, Secondary, Accent, Enabled, Disabled* 等。你可以按同样规则命名。*Primary* 和 *Secondary*  可以是你的文本颜色，*Accent* 可以是你的品牌主色调，你懂的。

In Sketch, you can save these colors in the Color Picker, but as far as I know, there’s no way to share them outside of the Sketch file. What you can do instead is create an artboard with the colors from your palette, along with their names and hex codes. This way, developers can quickly extract them when they access your design through Zeplin, and insert them in the app’s code.

在 Sketch 里，你可以用颜色拾取器来保存这些颜色，但就我所知，没有什么可以在 Sketch 文件之外共享它们的好办法。可以用你调色板的颜色，它们名字和 hex 码创建一个画板。这样当开发人员用 Zeplin 打开你的设计，就能快速提取出这些颜色，在应用的代码中使用它们。

![](https://cdn-images-1.medium.com/max/1600/1*UnGAceC6fZfRUcc63u4-2A.png)

These are the colors we use on the Nimber apps
### **Design for all cases**

Keep in mind that developers don’t build the ideal UI, but rather something that adapts into the ideal UI. They have to take care of cases where there’s no connectivity, or there’s a server error, or when there’s no content to display and much more.

So make sure to design for every scenario. Specifically, make sure to design every screen in its Empty state, Loading state, Error state, and the Ideal state. 99% of the time, these will be enough. [This article](http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack) by [Scott Hurff](https://medium.com/@scotthurff) goes into more depth about states, recommended read.

### 适用于所有情况的设计

牢记开发人员不是在创建完美的 UI，而是在创建接近理想 UI 的东西。他们不得不处理无网络链接，或服务器响应错误，或者没有内容显示的等很多情况。

所以确保你的设计可以适用于每一个场景。具体说就是，确保每一屏都有自己的空白状态，加载状态，错误状态和完美状态。这样做，99% 的时间里，就表现足够好了。[Scott Hurff](https://medium.com/@scotthurff) 的[这篇文章](http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack)，深入谈了状态相关，推荐阅读。

### **Screen sizes**

We live in an era of multiple screen sizes, so we have to design accordingly. This is a big deal when designing for Android because of its plethora of devices which come in multiple screen sizes.

The “lazy” way to deal with this is to use a plugin such as [Sketch Constraints](https://github.com/bouchenoiremarc/Sketch-Constraints) when creating your design in Sketch. When you use something like that, you can duplicate your artboards, resize them, and refresh the artboard. Magically, the UI will adapt accordingly to fit that screen size.

The “correct” way to do this is to design your UI for phone screens (under 7 inches), 7 inch tablets, and 10 inch tablets. It’s especially awesome when you use Master-Detail Flows, which is a fancy term for combining List and Detail panels into one layout, such as the one below.

### 屏幕尺寸

我们生活在一个多屏幕尺寸的时代，所以不得不相应地进行设计。当为 Android 系统设计时，这个尤为重要，因为它的设备有各种各样的尺寸。

“偷懒”的方式就是用 Sketch 插件，比如 [Sketch Constraints](https://github.com/bouchenoiremarc/Sketch-Constraints) 设计。用这个工具，你可以复制画板，重新调整它们的尺寸，然后刷新画板。神奇的事发生了， UI 会根据屏幕尺寸变化而变化。

“正确”的方式是为手机屏幕（7 英寸以下），7 英寸的平板，10 英寸的平板电脑各设计一套 UI。当使用  Master-Detail Flow 时感觉超级棒，一个奇怪的术语，如下图所示，它指的是把列表页和详情面板放一个布局里。

![](https://cdn-images-1.medium.com/max/1600/1*x5oYpU9S0lUJ9vQbwcNNEw.png)

Oh, you wanna know what this is? [Well you’re in luck!](https://medium.com/@BashaChris/overhauling-the-twitter-experience-on-android-80f5b09e7c67#.1c8wpz368)

---

### **Things to keep in mind**

1. Not all of your users will use the app in English. Keep in mind that text might get longer (or shorter) in other languages, and you have to take this into account when designing your layouts.
2. You can’t cherry pick — you don’t have control over every pixel. Some parts of the app will inevitably end up looking less than ideal because of unpredictable data.
3. Try to use interactions, gestures, transitions, and animations built into the platform. Your developers will thank you.

### 需要记住的事情

1. 并非所有应用用户都使用英语。时刻想着，在其他的语言中，文字的长度可能较长（或者较短），在设计布局时，必须要考虑到这个因素。
2. 不要过于挑剔 — 你不可能控制每一个像素。由于不可预知的数据，应用程序的某些部分设计，不可避免地不完美。
3. 尝试使用平台内置的交互方式，手势，过场及动画特效，开发人员会感谢你的。

#### **Last but not least**

Communicate with your developers! Let them educate you. While tools such as Zeplin and Flinto are a great way to share your design with developers, they don’t have the ability to explain the behavior of every part of the app. Share knowledge and strive to achieve the result that is best for the product!

### 最后但并也非常重要

多与开发人员沟通！让他们指导你。虽然 Zeplin 和 Flinto 这类工具是与开发人员共享设计的好方法，但是它们不能解释应用每个部分的行为。分享知识，努力实现最好的产品。



---

That’s it for this article! Hopefully, you learned something and give these methods a go.

**Happy shipping! ✌️**

就这样，希望你可以学习并尝试这些方法。

**交付开心！**✌️

---

![](https://cdn-images-1.medium.com/max/1600/1*0zBg56i9RC8DSpsK6pvEJA.png)

*This article was created by Nimber’s design team, *[*Chris*](https://twitter.com/BashaChris)* and *[*Andrew*](https://twitter.com/ckor)*. Make sure to follow us on Twitter!*

*And don’t forget to check out *[*Nimber*](http://nimber.com)* itself! *[*Facebook*](http://facebook.com/easybring)* - *[*Twitter*](http://twitter.com/nimber)

*Click ♥️ to spread the word!*
