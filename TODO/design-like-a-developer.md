> * 原文地址：[Design like a Developer](https://medium.com/going-your-way-anyway/design-like-a-developer-b92f7a8f4520#.ohgf4aagn)
* 原文作者：[Chris Basha](https://medium.com/@BashaChris)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

---

![](https://cdn-images-1.medium.com/max/1600/1*cUlwzVshahSl9DM4DZApYQ.jpeg)

Westworld, HBO

# Design like a Developer

Longer title: Design in Sketch as if you were building UI in a development environment

---

First of all, this is the only time Photoshop is going to be mentioned in this article. It’s 2017 — do yourself a favor and download Sketch (or Figma — I don’t care as long as it’s not Photoshop).

UI design has come a long way, and so have image manipulation programs (if you can even call them that nowadays). We remember creating our first UIs in GIMP, and now that we’ve got MacBooks we’re using Sketch for almost everything UI related.

Here’s the thing, though; Sketch has been created with designers in mind. It’s been built with the purpose of helping designers create user interfaces — and you can create pretty amazing things with it. But don’t forget that when you’re building a product, your duty ends when your design is shipped, not when you “finalize” that Sketch file.

Your design has to go through a developer and be built in a development environment. This is where the problem lies; if you look at Sketch and a UI builder in a development environment (or *IDEs*, e.g. Xcode and Android Studio) side by side, you will not see many similarities.

The way a developer builds your design is fundamentally different from the way you, as a designer, create it in Sketch. It sounds kind of stupid when you put it into perspective, doesn’t it?

![](https://cdn-images-1.medium.com/max/1600/1*SILxrapOSVGmc4sLIaM3CA.png)

Xcode, Sketch, and Android Studio (and some lightning bolts)
That’s okay, though! This article is going to describe a design approach which comes a little bit closer to what a developer goes through when they build your design (it’s a struggle…).

---

### **Think in “Views”**

You know *Symbols* in Sketch, right? We were really excited to use this feature when we switched to Sketch because it comes so close to how developers build UIs. Most of the time when you see things such as list items or action bars, they have one single source **view** that gets reused again and again.

![](https://cdn-images-1.medium.com/max/800/1*nhQf6v6HBbnhR7lWbq7Ehw.png)

![](https://cdn-images-1.medium.com/max/800/1*z12CHMxb0YJxT7vppoCciQ.png)

![](https://cdn-images-1.medium.com/max/800/1*cJqbNsqX7jQ0vCynbSpYMA.png)

The most important guideline of designing like a developer is to think of your design in terms of *Views*. Think of a View as an independent group of elements which has defined borders and is sorted in hierarchical order.

As an example, the Search Results screen of our Nimber app on Android is divided into two main views; the Top View which contains the Action Bar as well as a Card with the user-entered locations and filters, and a List View with the returned search results.

In the Blueprint or Skeleton above, you can see how the view bounds are clearly defined in the design. **These are layers that are invisible in the Sketch file (0% opacity)**, but they’re extremely useful when handing over the design to your developers.

See below how the Action Bar is broken down into smaller Views.

![](https://cdn-images-1.medium.com/max/1600/1*gcQLtwSi9its2BBZ5zpGtg.png)

Top Level of View Hierarchy

![](https://cdn-images-1.medium.com/max/1600/1*eAXV4sx5uwqlPbllrhWmFw.png)

ActionBar View

![](https://cdn-images-1.medium.com/max/1600/1*g4gsq4tDW707agveiSOzNg.png)

Action Items with View Bounds at 100% opacity
Make sure to not just group your layers randomly. Define their sizes and spacing in a clear way (avoid odd numbers) and sort everything in hierarchical order.

The same applies for layer styles, for cases where you need to use consistent strokes, rounded corners, drop shadows, you name it.

This app called [Zeplin](https://zeplin.io) helps a lot here. Long story short: you import your design in there, and the app extracts all view sizes, text sizes, colors, etc. in a developer oriented way. It’s a great tool that bridges the gap between designers and developers, and I can’t wait to see what it holds for the future.

When you hand over your design, the developer can look at Zeplin and extract the sizes, margins, paddings from one single item, and create the view in their IDE accordingly.

### Design in 1x

Why is this even up here…

By designing in **1x**, first you help yourself by not having to calculate sizes in other screen densities, but most importantly, both you and the developer end up using the same numbers. This way you prevent any miscalculations when handing over your design, and keep a consistent set of values.

This applies to view sizes, text sizes, line heights, most numbers really…

### Consistent Color Palette

Create once, always reuse. Try to have as few colors as possible.

![](https://cdn-images-1.medium.com/max/1200/1*MwWQuonkMOBlroqzqD9l2Q.png)

You’ll see developers mostly use names such as *Primary, Secondary, Accent, Enabled, Disabled* etc. You can do the same thing. *Primary* and *Secondary* can be your text colors, *Accent* can be your brand’s color, you get the point.

In Sketch, you can save these colors in the Color Picker, but as far as I know, there’s no way to share them outside of the Sketch file. What you can do instead is create an artboard with the colors from your palette, along with their names and hex codes. This way, developers can quickly extract them when they access your design through Zeplin, and insert them in the app’s code.

![](https://cdn-images-1.medium.com/max/1600/1*UnGAceC6fZfRUcc63u4-2A.png)

These are the colors we use on the Nimber apps
### **Design for all cases**

Keep in mind that developers don’t build the ideal UI, but rather something that adapts into the ideal UI. They have to take care of cases where there’s no connectivity, or there’s a server error, or when there’s no content to display and much more.

So make sure to design for every scenario. Specifically, make sure to design every screen in its Empty state, Loading state, Error state, and the Ideal state. 99% of the time, these will be enough. [This article](http://scotthurff.com/posts/why-your-user-interface-is-awkward-youre-ignoring-the-ui-stack) by [Scott Hurff](https://medium.com/@scotthurff) goes into more depth about states, recommended read.

### **Screen sizes**

We live in an era of multiple screen sizes, so we have to design accordingly. This is a big deal when designing for Android because of its plethora of devices which come in multiple screen sizes.

The “lazy” way to deal with this is to use a plugin such as [Sketch Constraints](https://github.com/bouchenoiremarc/Sketch-Constraints) when creating your design in Sketch. When you use something like that, you can duplicate your artboards, resize them, and refresh the artboard. Magically, the UI will adapt accordingly to fit that screen size.

The “correct” way to do this is to design your UI for phone screens (under 7 inches), 7 inch tablets, and 10 inch tablets. It’s especially awesome when you use Master-Detail Flows, which is a fancy term for combining List and Detail panels into one layout, such as the one below.

![](https://cdn-images-1.medium.com/max/1600/1*x5oYpU9S0lUJ9vQbwcNNEw.png)

Oh, you wanna know what this is? [Well you’re in luck!](https://medium.com/@BashaChris/overhauling-the-twitter-experience-on-android-80f5b09e7c67#.1c8wpz368)

---

### **Things to keep in mind**

1. Not all of your users will use the app in English. Keep in mind that text might get longer (or shorter) in other languages, and you have to take this into account when designing your layouts.
2. You can’t cherry pick — you don’t have control over every pixel. Some parts of the app will inevitably end up looking less than ideal because of unpredictable data.
3. Try to use interactions, gestures, transitions, and animations built into the platform. Your developers will thank you.

#### **Last but not least**

Communicate with your developers! Let them educate you. While tools such as Zeplin and Flinto are a great way to share your design with developers, they don’t have the ability to explain the behavior of every part of the app. Share knowledge and strive to achieve the result that is best for the product!

---

That’s it for this article! Hopefully, you learned something and give these methods a go.

**Happy shipping! ✌️**

---

![](https://cdn-images-1.medium.com/max/1600/1*0zBg56i9RC8DSpsK6pvEJA.png)

*This article was created by Nimber’s design team, *[*Chris*](https://twitter.com/BashaChris)* and *[*Andrew*](https://twitter.com/ckor)*. Make sure to follow us on Twitter!*

*And don’t forget to check out *[*Nimber*](http://nimber.com)* itself! *[*Facebook*](http://facebook.com/easybring)* - *[*Twitter*](http://twitter.com/nimber)

*Click ♥️ to spread the word!*
