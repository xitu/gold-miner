> * 原文地址：[10 principles for smooth web animations](https://blog.gyrosco.pe/smooth-css-animations-7d8ffc2c1d29#.oqnbskp19)
* 原文作者：[Anand Sharma](https://blog.gyrosco.pe/@aprilzero)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# 10 principles for smooth web animations

# 10 个原则让你的动画平稳起飞




Since we launched [_Gyroscope_](https://gyrosco.pe/) last year, many people have asked about the JavaScript library we use for our animations. We thought about releasing it to the public, but that’s actually not where the magic happens.

去年我们发布了 [**Gyroscope**](https://gyrosco.pe/) 以来，许多人问过我们做动画用的什么 JavaScript 库，我们也曾想过将它公布于众，但实际上那并不是给动画施加魔法的地方。

We don’t want people to feel like they’re dependent on some special JavaScript plugin that magically solves these problems. For the most part, we’re just taking advantage of the recent improvements in browser performance, GPU’s and the CSS3 spec.

我们不想让大伙儿觉得自己需要依赖特定的 JavaScript 插件才能魔法般地解决问题。大部分时候，我们都是在谈论最新的浏览器和 GPU 的性能的提升和 CSS3。

There is no silver bullet for great animations, besides spending a lot of time testing and optimizing them. However, after years of experimentation and hitting the limits of browser performance, we’ve come up with a series of design & code principles that seem to reliably result in nice animations. These techniques should get you pages that feel smooth, work in modern desktop and mobile browsers, and—most importantly—are easy to maintain.

其实并没有什么绚丽动画的武功秘籍，唯一的办法就是花大量时间测试和优化。但是，在经过多年的试验和浏览器性能的极限考验，我们发现了一些设计和编码的原则可以有效地做出很棒的动画效果。这些技巧能够使你的页面流畅，并且能够运行在流行的台式和移动设备的浏览器上，最重要的一点，它们还非常易于维护。









![](https://cdn-images-1.medium.com/max/800/1*MkkJ55Tz5Qgnl8xMzP5I4Q.gif)





The technology and implementation will be slightly different for everyone, but the general principles should be helpful in almost any situation.

技术手段和实现方式可能因人而异，但是通用性的原则几乎能无所不包。

### What is an animation?

### 什么是动画？

Animations have been around since before the internet, and making them great is something you could spend a lifetime learning. However, there are some unique constraints and challenges in doing them for the internet.

For smooth 60fps performance, each frame needs to be rendered in less than 16ms! That’s not very much time, so we need to find very efficient ways to render each frame for smooth performance.

在互联网发明之前，动画就已经所处可见了，可能你需要穷尽毕生之力才能学会如何将动画做得绚丽辉煌。然而，在互联网中实现动画效果自有其独特的限制和挑战。

为了实现流畅的 60 帧的动画效果，每一帧都需要在 16 毫秒内完成渲染！时间很短，所以我们需要找到最高效的方法去渲染每一帧内容，从而实现流畅的表现。













![](https://cdn-images-1.medium.com/max/400/1*jOzKe6AFCM1ReUdqzhAabA.gif)













![](https://cdn-images-1.medium.com/max/400/1*FgDvnrIo_NLY_mWWOevcpQ.gif)













![](https://cdn-images-1.medium.com/max/400/1*s3-q-j6Qt60mWW4Ut-731A.gif)



[Some classical animation principles](http://the12principles.tumblr.com/)

[一些经典的动画设计原则](http://the12principles.tumblr.com/)







There are dozens of ways to achieve animations on the web. For example, the filmstrip is an approach has been around since before the internet, with slightly different hand-drawn frame being swapped out many times a second to create the illusion of motion.

Twitter recently used this simple approach for their new heart animation, flipping through a sprite of frames.

在网站上实现动画效果的方式多种多样。比如，在互联网出现之前随处可见的电影胶片，它利用手绘的渐变的胶片，每秒钟播放多帧来实现动画的错觉。

Twitter 在最近的心形动画中就利用了这种方法，通过胶片绘出一个转动的精灵。









![](https://cdn-images-1.medium.com/max/800/1*FuG1AF-xgf0Ie6EIuab-FA.png)





This effect could’ve been done with a ton of tiny elements individually animating, or perhaps as an SVG, but that would be unnecessarily complex and probably not be as smooth.

这个效果也可以通过许多独立的小元素动画来实现，或者用 SVG 实现，但是那样会过于复杂，并且可能不会这么流畅。









![](https://cdn-images-1.medium.com/max/800/1*6BGvScGs5cxxqPJn9qQLCA.gif)





In many cases, you’ll want to use the CSS transition property to automatically animate an element as it changes. This technique is also known as “tweening”—as in transitioning be_tween_ two different values. It has the benefit of being easily cancellable or reversible without needing to build all that logic. This is ideal for “set and forget” style animations, like intro sequences, etc. or simple interactions like hovers.

许多时候，你会想要使用 CSS 切换属性来自动实现元素改变的动画效果，这种技术被称作 “tweening” ——因其是在两个不同的属性值之间切换（译者注：tweening 来自 transitioning be _tween_ two different values）。它的好处是可以非常简单地取消或者替换掉而不用重新构造逻辑内容，这是完美的一劳永逸式的动画，像介绍序言等，或者如鼠标悬停等简单的交互。
 
Further reading: [All you need to know about CSS Transitions](https://blog.alexmaccaw.com/css-transitions)

更多资料: [All you need to know about CSS Transitions](https://blog.alexmaccaw.com/css-transitions)









![](https://cdn-images-1.medium.com/max/800/1*dKga2QEWB_ZI0nnj0m2XPA.gif)





In other cases, the keyframe-based CSS animation property may be ideal for continuously running background details. For example, the rings in the Gyroscope logo are scheduled to constantly spin. Other types of things that would benefit from the CSS animation syntax are gear ratios.

其他时候，基于关键帧的 CSS 动画属性会非常适合持续运行的后台数据。举个例子，陀螺仪中的圆环按会照预设持续转动，还有其他能够利用 CSS 动画的类型比如齿轮。

So without further ado, here are some tips that will hopefully greatly improve your animation performance…

为了免于后顾之忧，希望以下这些建议能极大地提高你的动画效果：

> #1

### Don’t change any properties besides opacity or transform!

_Even if you think it might be ok, don’t!_

### 除了透明度（opacity）和切换（transform），不要改变任何属性！

**即便你觉得可行，那也别冲动！**

Just this one basic principle should get you 80% of the way there, even on mobile. You’ve probably heard this one before—it’s not an original idea but it is seldom followed. It is the web equivalent of “eat healthy and exercise” that sounds like good advice but you probably ignore.

仅仅这项基本的原则就应该存在你 80% 的工作中，即使是在移动端也一样。你或许以前听过这个原则，这不是我提出来的，但是很少有人去遵守。这跟“管住嘴迈开腿”一样，建议很好却也最容易被忽略。

It is quite straightforward once you get used to thinking that way, but may be a big jump for those used to animating traditional CSS properties.

对已经习惯了这种思路的人来说这非常简单，但是对那些习惯用传统的 CSS 属性去做动画的人来说，这会是一次质的飞跃。

For example, if you wanted to make something smaller, you could use_transform: scale()_ instead of changing the width. If you wanted to move it around, instead of messing with margins or paddings — which would need to rebuild the whole page layout for every frame — you could just use a simple_transform: translateX_ or _transform: translateY_.

比如，你想让某个元素变小，你可以使用 **transform：scale()**，而不是改变宽度；如果你想移动它，你可以使用简单的 **transform：translateX** 或者 **transform：translateY**，从而替代乱糟糟的外补白（margin）或者内补白（padding） — 那些需要重建每一帧的页面布局。

#### Why does this work?

#### 为什么要这么做呢？

To a human, changing width, margin or other properties may not seem like a big deal — or preferable since it is simpler — but in terms of what the computer has to do they are worlds apart and one is much, much worse.

对人类来说，改变宽度、外补白或者其他属性不是什么大事 — 甚至因为简单会更让人喜欢这么做 — 但是对电脑来说，这事儿就像天塌了一样，甚至比这更糟糕。

The browser teams have put a lot of great work into optimizing these operations. Transforms are really easy to do efficiently, and can often take advantage of your graphics card without re-rendering the elements.

浏览器投入了九牛二虎之力来优化这些操作，切换属性（transform）真的非常容易且高效，并且能够充分利用显卡，并且不用重新渲染元素。

You can go crazy when first loading the page — round all the corners, use images, put shadows on everything, if you’re feeling especially reckless you could even do a dynamic blur. If it just happens once, a few extra milliseconds of calculation time doesn’t matter. But once the content is rendered, you don’t want to keep recalculating everything.

第一次加载页面的时候，你可能会觉得抓狂 — 处理所有圆角、引入图像、给一切添加阴影，如果你毫不在乎那么甚至可以再做一个动态羽化。如果这种情况只会发生一次，多一些计算时间也没关系。但是一旦内容渲染完成了，你绝对不会再想要重新加载！

Further reading: [Moving elements with translate (Paul Irish)](https://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/)

更多内容，请戳: [Moving elements with translate (Paul Irish)](https://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/)

> #2

### _Hide content in plain sight._

### **用非常清楚的方式隐藏内容**

_Use pointer-events: none along with no opacity to hide elements_

**使用 pointer-events 属性：仅仅利用透明度隐藏元素**

This one may have some cross-browser caveats, but if you’re just building for webkit and other modern browsers, it will make your life much easier.

或许会有跨浏览器的警示，但是如果你只是面向 webkit 和其他流行的浏览器，它将会让你如虎添翼。

A long time ago, when animations had to be handled via jQuery’s animate(), much of the complexity of fading things in and out came from switching between display: none to block at the right time. Too early and the animation wouldn’t finish, but too late and you’d have invisible zero-opacity content covering up your page. Everything needed callbacks to do cleanup after the animation was finished.

很久以前，动画效果必须由 jQuery 的 animate() 方法来处理，许多复杂的淡入淡出效果的处理是通过 display 的属性值切换实现的。太早显示，那么动画还没完成，但是太晚的话就会在页面上显示一片空白，总是需要回调函数去给执行完的动画擦屁股。

The CSS pointer-events property (which has been around for quite a long time now, but is not often used) basically makes things not respond to clicks or interactions, as if they were just not there. It can be switched on and off easily via CSS without interrupting animations or affecting the rendering/visibility in any way.

CSS 中的 pointer-events 属性（尽管已经存在很长时间，但是不经常使用）只是让元素失去了点击和交互的响应，就好像它们不存在一样。它能通过 CSS 控制显示或隐藏，不会打断动画也不会影响页面的渲染或可见性。

Combined with an opacity of zero, it basically has the same effect as display none, but without the performance impact of triggering new renders. When hiding things, I can usually just set the opacity to 0 and turn off pointer-events, and then forget about the element knowing it will take care of itself.

除了将 opacity 设置为零，它和将 display 设置为 none 具有相同的效果，但是不会触发新的渲染机制。需要隐藏元素的时候，我会将它的 opacity 设置为 0 并将 pointer-events 设置为 off，然后就任由其自生自灭啦。

This works especially well with absolutely positioned elements, because you can be confident that they are having absolutely no impact on anything else on the page.

这样做尤其适用于绝对定位的元素，因为你能够自信满满地说他们绝对不会影响到页面中的其他元素。

It also gives you a bit more leeway, as the timing doesn’t have to be perfect — it isn’t the end of the world if an element is clickable or covering other things for a second longer than it was visible, or if it only become clickable once it fully faded in.

它有时也会剑走偏锋，因为时机并不会总是那么完美 — 但是这并没有到不可挽救的地步，比如一个元素仍然可以点击或者在不可见状态下覆盖了其他内容，或者只有当元素淡入显示完全的时候才可以点击。

> #3

### Don’t animate everything at the same time.

### 不要一次给所有内容都设置动画

_Rather, use choreography._

**用动作编排加以替代**

A single animation may be smooth on its own, but at the same time as a many others will probably mess it up. It is very easy to create a basic demo of almost anything running smoothly — but an order of magnitude harder to maintain that performance with a full site. Therefore, it is important to schedule them properly.

单一的动画会很流畅，但是和其他许多动画一起也许就完全乱套了。写一个全员动画的例子很简单 — 但是这样的数量级下很难保持一个完整的网站的性能。因此，合理安排好每个元素非常重要。

You will want to spread the timings out so everything isn’t starting or running at the exact same time. Typically, 2 or 3 things can be moving at the same time without slowing down, especially if they were kicked off at slightly different times. More than that and you risk lag spikes.

你需要将所有的时间节点安排好，来避免所有的动画内容同时开始或进行。典型的例子，2 或 3 个动画同时进行可能不会出现卡慢的现象，尤其是在它们开始的时间略有不同的情况下。但是超过这个数量，动画就可能发生滞缓。

Unless there is literally only one thing on your pages, it is important to understand the concept of _choreography_. It might seem like a dance term, but it is equally important for animating interfaces. Things need to come in from the right direction and at the right time. Even though they are all separate, they should feel like part of one well-designed unit.

理解**动作编排**这个概念非常重要，除非你的页面真的只有一个元素。它貌似是舞蹈领域的东西，但是在动画界它同样的重要。每个内容都要在合适的方向和时机出现，即使它们相互分离，但是它们要给人一种按部就班的感觉。

Google’s material design has some interesting suggestions on this subject. It is not the only right way to do things, but something you should be thinking about and testing.

谷歌的 material design 有几点关于动作编排的有趣建议，这并不是实现目标的不二法门，但总会有一些你应该考虑和测试的内容。









![](https://cdn-images-1.medium.com/max/800/1*l3nlHJxVEvs6mwSzCt34Fg.png)





Further reading: [Google Material Design · Motion](https://material.google.com/motion/material-motion.html)

更多内容： [Google Material Design · Motion](https://material.google.com/motion/material-motion.html)

> #4

### Slightly increasing transition delays makes it easy to choreograph motion.

### 适当增加切换延时能够更简单地编排动作

Choreographing animations is really important and will take a lot of experimentation and testing to get feeling right. However, the code for it doesn’t have to be very complicated.

动画的编排非常重要，同时也会做大量的试验和测试才能恰如其分。然而，动画编排的代码并不会非常复杂。

I typically change a single class on a parent element (often on body) to trigger a bunch of transitions, and each one has its own own varying transition-delay to come in at the right time. From a code perspective you just have to worry about one state change, and not maintain dozens of timings in your JavaScript.

我通常会改变一个父元素（通常是 body）的 class 值来触发一系列的改变，这些改变有着各不相同的切换延时以便能够适时展现。单从代码来看，你只需要关心状态的变化，而不用担心一堆时间节点的维持。









![](https://cdn-images-1.medium.com/max/800/1*1-oJmR242qUrcNke-RLFgQ.gif)



Animations in the [Gyroscope Chrome Extension](https://gyrosco.pe/chrome/)

[Gyroscope Chrome Extension](https://gyrosco.pe/chrome/) 的动画



Staggering a series of elements is an easy and simple way to choreograph your elements. It’s powerful because it simultaneously looks good while also buying you precious performance—remember you want to have only a few things happening at the same time. You’ll want to spread them out enough that each one feels smooth, but not so much that the whole thing feels too slow. Enough should be overlapping that it feels like a continuous flow rather than a chain of individual things.

交错安排一系列的元素是动画编排的一种简单易行的方法，这种方法很有效，因为它在性能良好的同时还好看—但请记住你本想让几个动画同时发生的。你想把这些动画分布开来，让每个都表现地流畅，而不是一下子太多动画从而显得特别慢。适当部分的重叠会看起来连续流畅而不是链式的单独动画。

#### Code Sample

#### 代码示例

There are a couple simple techniques to stagger your elements—especially if it is a long list of things. If there are less than 10 items, or a very predictable amount (like in a static page), then I usually specify the values in CSS. This is the simplest and easiest to maintain.

有一些很简单的技巧来错开你的元素—尤其是其中有非常多的内容。如果页面中有小于 10 项内容，或者元素数量可预估（比如静态页面），我通常会在 CSS 中指定特定的值。这是最简单易行的方法了。









![](https://cdn-images-1.medium.com/max/800/1*NyyitMSOXlxOPrk7xNQJgA.png)



A simple SASS loop

一个简单的 SASS 循环



For longer lists or very dynamic content, the timings can be set dynamically by looping through each item.

对更多的内容或者动态内容来说，可以在循环中动态地给每项内容添加时间节点。









![](https://cdn-images-1.medium.com/max/800/1*T5S3EyM3rw-zrM8dmRFRqw.png)



A simple javascript loop

一个简单的 JavaScript 循环



There are typically two variables: your base delay and then the time delay between each item. It is a tricky balance to find, but when you hit the right set of numbers it will feel just perfect.

有两个典型的变量：基本延时和各个项目的延时。它很难协调，但你一旦找到正确的值，效果将会非常完美。

> #5

### Use a global multiplier to design in slow motion

### 在慢动作中使用增量设计

_And then speed everything up later._

**过后再加快动画的速度**

With animation design, timing is everything. 20% of the work will be implementing something, and the other 80% will be finding the right parameters & durations to get everything in sync and feeling smooth.

动画设计中，时间节点就是一切。20% 的工作是用来实现效果，剩下的 80% 使用来寻找合适的参数和持续时间来让一切在同时发生时显得流畅。

Especially when working on choreography of multiple things, and trying to squeeze performance and concurrency out of the page, seeing the whole thing go in slow motion will make it a lot easier.

尤其是在编排多个动画的时候，为了达到高性能和高共同性，观察动画的慢动作会让一切工作变得非常容易。

Whether you’re using Javascript, or some sort of CSS preprocessor like SASS (which we love), it should be fairly straightforward to do a little extra math and build using variables.

无论你用的是 JavaScript 还是 CSS 预处理器比如 SASS（我们非常喜欢它），都需要简单地做一些额外的计算并且需要声明一些有用的变量。

You should make sure it is convenient to try different speeds or timings. For example, if an animation stutters even at 1/10 speed, there might be something fundamentally wrong. If it goes smoothly when stretched out 50x, then it is just a matter of finding the fastest speed it will run at. It may be hard to notice 5-millisecond issues at full speed, but if you slow the whole thing down they will become extremely obvious.

你必须确保它能够非常容易地尝试不同的速度或时间节点。举个例子，如果一个动画效果在 1/10 的速度下还表现地结结巴巴，那么可能会有一些非常基础的错误。

Especially for very complex animations, or solving tricky performance bottle necks, the ability to see things in slow motion can be really useful.

尤其是做非常复杂的动画分析，或者解决非常棘手的性能瓶颈，慢动作查看元素会非常的有用。

The main idea is you want to pack a lot of perfect details while it is going slow, and then speed the whole thing up so it feels perfect. It will be very subtle but the user will notice the smoothness and details.

重要的一点就是，在慢动作下你会将非常多的细节优化地完美，当动画加速之后它将会给人完美无瑕的感觉。尽管这些都显得微不足道，但是用户会注意到动画效果的流畅和细节的。

This feature is actually part of OS X—if you shift-click the minimize button or an app icon, you’ll see it animate in slow motion. At one point, we even implemented this slow-motion feature on Gyroscope to activate when you press shift.

只有 OS X 才有的功能—如果你 shift + 点击最小化按钮或者一个应用图标，你将会看见它在缓慢移动。基于这一点，我们甚至在陀螺仪上实现了这个功能，当你按下 shift 键的时候将会激活慢动作模式。

















> #6

### Take videos of your UI and replay them to get a valuable third-person perspective.

### 给你的用户界面录个像，并且在重复播放中得到一个有价值的第三人视角的看法。

Sometimes a different perspective helps you see things more clearly, and video is a great way to do this.

Some people build a video in after effects and then try to implement that on a site. I often end up going the other way around, and try to make a good video from the UI of a site.

有时候不同的视角能够帮助你对事物有更加清楚的认识，而录像则是一种很好的方法。

有的人会用 AE 做视频然后放到网站上，而我经常是用其他方式，尝试从网站用户界面做一个很棒的视频。

















Being able to post a Vine* or video of something is a fairly high bar. One day I was excited about something I built, and tried to make a recording to share with some friends.

发布视频其实门槛很高的。有一天我对做出来的东西感到非常激动，想记录下来和朋友们分享。

However, when I watched it again I noticed a bunch of things that were not great. There was a big lag spike and all the timings were slightly wrong. It made me cringe a bit and instead of sending it I realized there was a lot more work to do.

然而，当看第二遍的时候，我发现了一些瑕疵，时间节点设置得不那么恰当，并且出现了一个延迟尖峰。这让我有点打退堂鼓了，我发现还有很多的内容需要优化，所以我不能就这么把视频发送给朋友。

It is easy to gloss over these while you’re using it in realtime, but watching animations on video — over and over again or in slow motion — makes any issues extremely obvious.

在使用过程中这些瑕疵都很容易被掩盖，但是在视频中一次次地观看慢动作的动画能够让一切问题都暴露地非常明显。

















They say the camera adds 10 pounds. Perhaps it also adds 10 frames.

有人会说拍摄出来的效果和现实并不完全相同，也许它变更加精确了呢。















It has now become an important part of my workflow to watch slow-motion videos of my pages and make changes if any of the frames don’t feel right. It’s easy to just blame it on slow browsers, but with some more optimization and testing it’s possible to work through all of those problems.

这已经成为我工作中很重要的一部分，我会观看慢动作的视频并且修改任何我举得不妥的地方。其实也可以很容易地将这类问题归咎于浏览器性慢，但是再多优化一点多测试一点，这些问题就能够得到解决。

Once you’re not embarrassed by catching lag spikes on video, and feel like the video is good enough to share, then the page is probably ready to release.

等到你在视频中不会发现非常尴尬的延迟尖峰，并且感觉视频挺好的可以晒出来了，这个时候你的页面就可以发布了。

> #7

### Network activity can cause lag.

### 网络活动可能会造成延迟。

_You should preload or delay big HTTP requests_

**你应该预加载或者延迟处理非常大的 HTTP 请求**

Images are a big culprit for this one, whether a few big ones (a big background perhaps) or tons of little ones (imagine 50 avatars loading), or just a lot of content (a long page with images going down to the footer).

图片便是其中一个元凶，无论是几个大图片（大的背景图）或者非常多的小图（五十个头像），或者非常多的内容（一个从头到尾有很多图片的长页面）。

When the page is first loading, tons of things are being initialized and downloaded. Having analytics, ads, and other 3rd party scripts makes that even worse. Sometimes, delaying all the animations by just a few hundred milliseconds after load will do wonders for performance.

页面首次加载的时候，许多的东西会被初始化并下载。其中内容解析、广告和其他第三方脚本会使性能变得更糟糕。有时候，将动画效果在页面加载后延迟零点几秒将会对性能有很大的提升。

Don’t over-optimize for this one until it becomes necessary, but a complicated page might require very precise delays and timings of content to run smoothly. In general, you’ll want to load as little data as possible at the beginning, and then continue loading the rest of the page once the heavy lifting and intro animations are done.

如果没有必要的话，不要过度优化动画延迟，一个复杂的页面要求非常精确的延迟和时间节点才能运行流畅。通常你会想要在开始的时候加载尽可能少的数据，当主要内容和介绍动画完成之后再继续加载其他的内容。

On pages with a lot of data, the work to get everything loaded can be considerable. An animation that works well with static content may fall apart once you start loading it with real data at the same time. If something seems like it should work, or sometimes works smoothly and other times doesn’t, I would suggest checking the network activity to make sure you aren’t doing other stuff at the same time.

一个有很多数据的页面，需要深思熟虑地加载所有内容。一个在静态页面中表现良好的动画效果也许就会在实时数据的加载中变得缓慢。如果有些内容仿佛应该生效但却没有，或者不能一如既往地流畅表现，我建议检查一下网络活动，确认一下你是否也在同时处理其他的内容。

> #8

### Don’t bind directly to scroll.

### 不要直接绑定滚动事件。

_Seems like a cool idea, but it really isn’t great._

**貌似是个好主意，其实不然**

Scrolling-based animations sometimes have gained a lot of popularity over the last few years, especially ones involving parallax or some other special effects. Whether or not they are good design is up for debate, but there are better and worse ways to technically implement them.

基于滚动的动画在前些年一段时间非常火爆，尤其是涉及视差或者其他特效的内容里。它们的设计模式是好是坏仍有待考证，但是在技术上有着良莠不齐的实现方法。

A moderately performant way to do things in this category is to treat reaching a certain scroll distance as an event — and just fire things once. Unless you really know what you’re doing, I would suggest avoiding this category since it is so easily to go wrong and really hard to maintain.

基于滚动的动画中有一种非常流行的处理方式，即将滚动一定距离作为事件处理同时触发动画内容。除非你对自己的行为了如指掌，否则我会建议不要使用这种方式，因为它真的很容易出错并且很难维护。

Even worse is building your own scroll bar functionality instead of using the default one—aka _scrolljacking_. Please don’t do this.

更糟糕的情况是自定义滚动条功能，而不用默认的功能—又名  _scrolljacking_ 。请不要这么想不开。

This is one of those rules that is especially useful for mobile, but also probably good practice for the ideal user experience.

所有规则中，这项对移动开发尤其有用，另外可能也是理想用户体验的好的实践。

If you do have a specific type of experience you want that is focused on scrolling or some special events, I would suggest building a quick prototype of it to make sure that it can perform well before spending much time designing it.

如果你确实要求独特的体验并且你希望它基于滚动或者其他的特殊事件，我建议创建一个快速原型来实现，而不是费力不讨好地去设计事件形式。

> #9

### Test on mobile early & often.

### 尽早并且经常地在移动设备上的测试。

Most websites are built on a computer, and likely tested most often on the same machine they’re built on. Thus the mobile experience & animation performance will often be an afterthought. Some technologies (like canvas) or animation techniques may not perform as well on mobile.

大多数的网站都是在电脑上搭建的，并且最常用本机做测试。因此，移动端体验和动画性能就被次要考虑了。一些技术（比如 canvas）或者动画技术可能在移动端表现地并不好。

However, if coded & optimized properly (see rule #1), a mobile experience can be even smoother than on a computer. Mobile optimization was once a very tricky subject, but new iPhones are now faster than most laptops! If you’ve been following the previous tips, you may very well end up with great mobile performance out of the box.

然而，如果代码写得好优化也到位（参考规则 #1），移动端的体验甚至比电脑更加流畅。移动端的优化是一项非常棘手的事情，但是新的 iPhones 比手提电脑更快！如果你采用了前几项建议，你将会得到一个非常棒的移动端表现。









![](https://cdn-images-1.medium.com/max/600/1*VTK6jzkOcCd-MMqspmrbfw.jpeg)





Mobile usage will be a large and very important part of almost any site. It may seem extreme, but I would suggest viewing it exclusively from your phone for a whole week. It shouldn’t feel like a punishment to be forced to use the mobile version, but often it will.

移动端使用方法是绝大多数网站中一个非常大而且非常重要的部分。或许会有些极端，但是我建议你专门拿出一个星期的时间用手机好好地查看你的网站。这不应该像接受惩罚那样被迫使用移动端版本，尽管你经常会有这种感觉。

Keep making design improvements & performance enhancements until it feels just as polished and convenient as the big version of the site.

不断优化设计和提高性能，直到网站在移动端的表现和在电脑上一样优美和方便。

If you force yourself to only use your mobile site for a week, you will probably end up optimizing it to be an even better experience than the big one. Being annoyed by using it regularly is worth it though, if it means that the issues get fixed before your users experience them!

如果你迫使自己在使用移动端版本一个星期，你将会得到一个比电脑上更优化体验更好的网站。即使在使用过程中遇到非常恼人的事情也是值得的，那意味着这些问题将在你的用户体验到之前就被解决掉了！

> #10

### Test frequently on multiple devices

### 经常在不同的设备上测试

_Screen size, density, or device can all have big implications_

**不同屏幕尺寸、分辨率，或者有着各种样式的设备**

There are many factors besides mobile vs desktop that can drastically affect performance, like whether a screen is “retina” or not, the total pixel count of the window, how old the hardware is, etc.

除了移动端和电脑之外还有很多因素能够对性能产生极大的影响，比如是否是 "retina" 屏幕、窗口的分辨率、硬件的老旧程度等等。

Even though Chrome and Safari are both Webkit based browsers with similar syntax, they also both have their own quirks. Each Chrome update can fix things and introduce new bugs, so you need to constantly be on your toes.

即使 Chorme 和 Safari 都是基于 Webkit 的浏览器并且有着相似的语法，但是他们也有各自的特点。每一次 Chrome 升级都会修复一些问题同时也会引入新的 bug，所以你必须时刻保持警惕。

Of course, you don’t only want to build for the lowest common denominator, so finding clever ways to progressively add or remove the enhancements can be really useful.

当然，你不会只想着搭建一个对于所有浏览器放之四海而皆准的网站，所以寻找一个灵活的方法以便于你能够增加或者移除一些功能是非常有用的。

I regularly switch between my tiny MacBook Air and huge iMac, and each cycle reveals small issues and improvements to be made — especially in terms of animation performance but also for overall design, information density, readability, etc.

我通常会交替在较小的 MacBook Air 和大屏的 iMac 中使用网站，每次都会暴露出新的问题然后再修复 — 尤其是动画性能方面的问题，有时候也会有全局设计的题、信息密度、可读性的问题等等。

Media queries can be really powerful tools to address these different segments—styling differently by height or width is a typical use of media queries, but they can can also be used to add targeting by pixel density or other properties. Figuring out the OS and type of device can also be useful, as mobile performance characteristics can be very different than computers.

Media queries 是一款非常强大的工具，它典型的用处是定位由于高度或者宽度造成的样式差异，但是它同样能够用来根据分辨率添加目标内容或者其他属性。另外，识别系统和设备类型的功能也是非常有用的，因为移动设备的性能特征和电脑还是有很大区别的。
