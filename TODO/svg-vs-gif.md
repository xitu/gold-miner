> * 原文链接 : [Animated SVG vs GIF [CAGEMATCH]](https://sarasoueidan.com/blog/svg-vs-gif/)
* 原文作者 : [Sara Soueidan](https://twitter.com/SaraSoueidan)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Yusheng](https://github.com/rainyear)
* 校对者: [ychow](https://github.com/ychow)
* 状态 :  完成

# Animated SVG vs GIF

SVG不仅可用于展示静态图像，与其它图片格式相比，呈现动画的能力只是其强大的特性之一。这也是SVG优于包括GIF在内的其它位图格式的众多原因之一。当然，这种优势仅适用于适合SVG的应用场景，例如：

* Logo图，
* 不复杂的矢量图，
* UI组件，
* 信息化图表，
* 图标。

当然，如果你的图片更适合用位图格式——例如照片或非常复杂的矢量图形（通常会导致 SVG 格式的文件非常大），那么你还是应该用位图。不仅图片可以考虑用SVG格式，也要考虑SVG是否适用于当前图片。例如，如果用PNG格式时图片的文件更小，那么你就应该使用PNG格式，针对不同的版本、分辨率可以通过`srcset`属性来控制，或者根据工作目标寻找其它合理的解决方案。

> 不仅图片可以考虑用SVG格式，也要考虑SVG是否适用于当前图片。

通常来说，上面列出的图片都非常适合用SVG格式。如果你想给它们添加动画效果，通过修改SVG代码来生成动画效果也是非常合理的选择。

然而，上星期有一个展示了一些GIF格式的动态图标链接出现在我的Twitter时间轴上。

我看到这些图标的第一个想法就是这些图标非常适合用SVG呈现，而且也应该用SVG而非GIF。

SVG格式的确可以在很多地方取代GIF格式，就像上面提到的那些应用场景中可以取代其它位图格式一样。SVG的动画能力给它这样的优势和能力，而且绝不仅仅是体现在制作动画图标上。

下面是我总结出我认为你应该尽可能的使用SVG而不是GIF的原因。

## 图像质量

毫无意外地，SVG相对于GIF（或其他图片格式）的第一个优势同时也是SVG的首要特征：分辨率独立性。SVG图片在任何分辨率的屏幕上，无论你如何放大，看起来都非常清晰。而像GIF这样的位图格式则不然。试着放大一个有GIF图像的页面你可以看到GIF会变得像素化，内容也会变模糊。

例如，下面这张通过录制SVG动画得到的GIF图片在较小尺寸时看起来还没有问题：

![](https://sarasoueidan.com/images/svg-vs-gif--animation-example.gif)

A GIF recording of the [SVG Motion Trails demo](http://codepen.io/chrisgannon/pen/myZzJv) by Chris Gannon.

把这个页面放大几次会导致图片像素化，内部元素的边缘和曲线会出现锯齿，就像下面这张图片这样：

![](https://sarasoueidan.com/images/svg-vs-gif--animation-example-zoomed-in.png)

然而当你查看[SVG demo](http://codepen.io/chrisgannon/pen/myZzJv)并且放大页面时，无论放大多少次，SVG图片内容依然保持清晰不变。

想要在高分辨率显示器上呈现清晰的位图格式的图像，如GIF，你需根据上下文用`srcset`属性将图像进行放大。

当然，图像的分辨率越高，图像文件也就越大。如果用GIF格式，文件尺寸将会变得出奇的大，这一点我们后面马上就会看到。除此之外，在手机中用高分辨率的GIF来呈现较小的尺寸会损害页面性能。**不要这样做。**

在你创建GIF动画图标或图片时，它们的尺寸是固定的，页面的缩放或尺寸的改变会导致像素化。SVG的尺寸是自由的，而且清晰度则是固定的。你可以创建一个小尺寸的SVG并任意放大而不损失清晰度。

**结论**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>GIF和其他图片格式一样，不能适配各种分辨率，在放大或高分辨率显示器上时会出现像素化。</td>
<td>SVG可缩放和自适配，在任意分辨率的屏幕上都可以清晰地呈现。</td>
</tr>
</tbody>
</table>

## 颜色和透明度

对透明度的处理方法有可能是破坏GIF市场的首要因素，尤其是当图片成现在有颜色的背景上时。

这是使用GIF图标时（无论是否有动画）最有可能出现的问题，因为通常情况下图标背景是透明的。

以下面透明背景上带有描边的圆圈为例，左边是SVG格式，右边是GIF格式。看到下面的图片你马上可以发现问题：GIF中的圆圈在描边外面有灰色的毛边。

<figure style="background-color: #003366;">![](https://sarasoueidan.com/images/svg-vs-gif--circle-on-transparent-background.svg) ![](https://sarasoueidan.com/images/svg-vs-gif--circle-on-transparent-background.gif)

如过不是在浏览器里阅读这篇文章你可能看不到上面的效果，下面是截屏图片（右边是有问题的GIF格式）：

![](https://sarasoueidan.com/images/svg-vs-gif--artefact.png)

这是因为GIF图像中的透明度是通过二值化实现的。也就是说每个像素只有 _开_ 和 _关_ 两种状态：要么是完全透明的要么是完全不透明。这就意味着图片中前景与背景颜色之间无法平滑过度，从而因为不充足地抽样频率导致这样的边缘伪迹，通常称为 _锯齿_。

当一条线不是绝对笔直时，会导致（靠近边缘的）一些像素部分是透明的，部分是不透明的，呈现图片的软件必须知道这些像素需要用什么颜色呈现。光环效应（Halo effect）“是指所有透明度大于50%的像素变成完全不透明并且携带将要被栅格化的背景颜色”([Chris Lilley](http://twitter.com/svgeesus/))。这一效应通常由于图像编辑软件新建/保存时像素颜色与背景色相混合所导致的。

通常我们通过 _抗锯齿处理_ 来抵消锯齿化现象，但如果透明度是二值化的就没那么简单了。

> **抗锯齿化和二值化透明度之间存在严重的相互干扰作用**。由于图像的被背景颜色是与前景颜色混合在一起的，单纯地将一个背景颜色换成另外一个颜色并不能很好地模拟透明度。这将会产生一堆由背景色和前景色混合而成的阴影[...]。如果对白色背景的原始图片进行抗锯齿化处理，就会产生围绕在物体周围的白色光圈。
> <cite>— [Chris Lilley](http://twitter.com/svgeesus/) ([Source](http://www.w3.org/Conferences/WWW4/Papers/53/gq-trans.html))</cite>

这一问题的解决方案就是采用量化透明度，也就是我们通常所说的alpha通道。alpha通道可以允许不同程度的透明度，使前景色和背景色之间的过度更加平滑，这在GIF中是无法做到的；带有光环效果的图像只有用在白色背景上看起来效果最好，任意其它对比度高的背景色都会使边缘的伪迹清晰可见。

我不是很确定（针对GIF的）这一问题是否有解决方案，但我还从没见过透明背景的GIF中曲线边缘没有这一问题，我甚至还看过矩形边缘也存在这样的问题。

如果你想要将你的图片/图标用在非白色背景上，例如黑色的页脚背景上，单单这一个问题就可以让你否决掉 GIF。然而还有其他原因证明SVG比GIF更好，我们将会在后面的小节中看到。

**注意：** 如果你用浏览器阅读这篇文章仍然没办法看到第一张图片里面的锯齿效果，试着放大页面再来看。

为什么图片在较小尺寸时看不到锯齿？这是因为：浏览器在调整图像尺寸的过程中将边缘的锯齿抚平了。这是否意味着你可以借此摆脱锯齿问题继续使用GIF？是的，你可以。但是要这样做你必须使用比你想要的尺寸大得多的GIF，然后进行缩小。这也意味着你的用户需要从你的服务器下载更大的图片文件，进而占据他们手机更多的带宽，同时也会影响整个页面的大小和性能。请不要这样做。

**总结**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>GIF只能二值化地表示透明度。这导致图像或图标用于非白色背景上时会产生伪迹，也就是 _光环效果_。背景色与图像的对比度越高，光环效果越明显，导致图标几乎无法使用。</td>
<td>SVG包含alpha通道，因此在任何颜色的背景上都不存在这些问题。</td>
</tr>
</tbody>
</table>

## 动画技术和动画性能

**你可以用CSS、JavaScript或者是SMIL制作SVG动画**，而且它们都可以让你通过不同层面上的控制，使SVG里面的元素产生各种不同的动画效果。

GIF图片则不存在“动画技术”这一说。它们的动画效果是通过一种固定的方式和步调，连续呈现一系列图片（每一帧一张图片）。诚然，你可以通过“录制”动画并转换成 GIF 格式的方式来创建图标，但这种方法做出来的图标能有多好看？而且对于动画的时机在录制完成后你又有多大的控制权？完全没有。

除非你能肯定你创建的GIF至少有60帧（_每秒钟_ 60张图片），否则它的动画效果很难看起来比较流畅。而SVG利用浏览器的优化，想要获得流畅的动画效果则简单地多。

GIF文件的尺寸比PNG或JPEG大得多，而且动画的时间越长，文件越大。想象一下，如果你的动画需要持续5到6秒钟会怎样？如果持续时间更长呢？

结果可想而知。

让我们来看一个具体的小例子。下面是两张图片：左边的是SVG动画，右边是GIF。图中的矩形都是在6秒钟时间内变换其颜色。

<svg width="300" height="150" viewBox="0 0 300 150" xmlns="http://www.w3.org/2000/svg"><style>svg{width:48%;}path{animation:loop 6s linear infinite;}@keyframes loop{to{fill:#009966;}}</style></svg> ![](https://sarasoueidan.com/images/svg-vs-gif--rectangle-animation.gif)

需要注意的有以下几点：

* GIF动画看起来好像更流畅，但如果看仔细一些你会发现SVG中矩形颜色变化的范围更广，因为它是从颜色的起始值到终止值连续变化而来的。**GIF中颜色变化数量的上限是其帧数**。上图中的GIF包含60帧，也就是60种颜色，而SVG则遍历了整个颜色图谱中粉色到绿色之间的所有颜色。
* 对于这种循环播放的动画效果，通常来说最好避免颜色的剧烈跳转。在制作动画时，颜色变化的最后最好可以平滑地过度到初始的粉色，这样第二轮动画继续开始时就不会看到明显的颜色跳转。通过CSS，你可以利用`alternate`属性设定SVG动画的变化方向。但是对于GIF，你需要在帧数上面下功夫，并且很有可能需要在现有的帧数基础上加倍，当然，这同样会导致图片文件大小的增加。

上面两张图片的大小比较：

* GIF图片：**21.23KB**
* SVG图片：**0.355KB**

这可不是什么微不足道的差别。当然我们都知道可以对图片进行优化，让我们来试试看。

SVGO可以将SVG文件优化至 **0.249KB**。

优化GIF有很多线上工具可以选择。我用[ezgif.com](http://ezgif.com/)对上图进行优化，（其它工具包括： [gifsicle](http://www.lcdf.org/gifsicle/)）文件可以压缩至**19.91KB**。

优化GIF时有很多选项可以选择。我在优化上图时保持帧数不变，使用了有损压缩，这样可以将文件大小压缩30%-50%，作为代价会产生一些抖动/噪音。

你也可以通过每n帧里面移除一帧的抽样方法进行优化；这样可以进一步降低文件大小，但是将导致动画效果不再那么流畅。以当前的动画效果为例，去除某些帧将导致颜色变化更加“跳跃”且更容易被察觉。

其它优化选项包括减少颜色数量（这一方法不适用于我们这个依赖颜色的动画效果）和降低透明度等。你可以通过[ezgif.com](http://ezgif.com/)的优化页面了解更多关于这些选项的知识。

简要概括：如果你希望你的GIF动画更流畅，你就需要更高的帧率，而这将导致文件大小的增加。而对于SVG，你所需要维护的文件相对来说小得多。上面只是一个简单的小例子，我敢肯定还有更多更好的例子，但是我在这里只是希望突出两种格式的差异。

即使你用JavaScript甚至是JavaScript框架（因为IE浏览器不支持SVG动画）来产生上面的动画效果，将框架文件包含在内总的SVG文件大小仍然比GIF小或者最多一样大。以[GreenSock](http://greensock.com)的TweenLite为例，包含库文件在内SVG文件小于13KB（仍然比GIF小得多），而TweenLite本身压缩完就有12KB。即使最终文件大小跟GIF一样，SVG的其它优势仍然足以超越GIF，而且后文中还会看到更多。

其它一些JavaScript库只关注某些特定的动画效果，因此文件更小（<5KB），例如用于创建直线绘制效果的[Segment](https://github.com/lmgonzalves/segment/blob/gh-pages/dist/segment.min.js) 。Segment压缩后只有2.72KB。还不算太坏，是吧？

当然可能会有例外存在，因而你需要经过测试再做决定。但是考虑到GIF的本质和其工作原理，你会发现在大部分情况下SVG都是一个更好的选择。

注意：SVG的性能在今天来看还没有达到最优化水平，并且在将来很有希望得到改善。IE/MS Edge在当下所有浏览器中渲染 SVG的性能最好。除此之外，SVG动画看起来仍然比GIF动画要好，尤其是在应对较长时间的动画时。因为假设是60fps的GIF动画，文件的大小将会降低整个页面的性能。像GreenSock之类的库也（为SVG）提供了很好的性能支持。

**总结**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>
1. 一般来说GIF比SVG图片要大。动画越复杂时间越长，所需要的帧数越多，会导致文件越大，对性能的影响也越大。
2. 除非GIF的帧率达到60fps，否则动画效果看起来可能会不够流畅。然而帧率越高，尤其是长时间的动画，又会导致文件越大。
**结果：** 需要对性能做出妥协。要么是为了保持GIF动画的流畅性而增加总体页面大小影响其性能，要么是采用较少的帧数影响动画性能。 总会有一种形式的性能受到影响。
</td>
<td>
SVG利用浏览器优化和自身动画元素的优势，即便当前浏览器的性能尚未达到最优化水平的条件下，在保持更好动画效果的同时不需要牺牲页面性能做出妥协。

如果不是在非常小的情况下，与GIF相比，即使是包含一些跨浏览器支持的动画库的情况下，SVG文件的大小也是很合理的。
</td>
</tr>
</tbody>
</table>

### 维护和修改动画

……对于GIF来说是非常痛苦的。你需要用到Photoshop、Illustrator或After Effects之类的图像编辑器，如果你对这些编辑器本身并不熟练，你一定会觉得直接修改代码比使用图像编辑器更舒适一些。

![](https://sarasoueidan.com/images/svg-vs-gif--photoshop-frames.png)

上图是用Photoshop创建GIF动画时间轴的截屏。图中底部显示的是动画中的每一帧，越复杂的动画需要的帧数越多，同时也不要忘了还有复杂的图层面板。
small>感谢我的设计师朋友[Stephanie Walter](http://twitter.com/WalterStephanie)对PS动画的建议</small>

想象一下如果你想改变动画的时间要怎么办？如果你想同时改变图像中一个或多个元素随时间变化的函数怎么办？或者想要改变元素移动的方向呢？如果想要改变整体效果让图片中的元素做出完全不同的动作呢？

你需要从头重新绘制图像或图标。任何改动都需要你重新打开图像编辑器针对每一帧进行修改。这对于开发者来说是一种折磨，而对于那些对编辑器不够熟悉的人来说简直就是“不可能完成的任务”。

对于SVG，任何动画的改动都只是几行代码的事而已。

**总结（开发者的角度）**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>维护和修改GIF动画需要重新创建图像或通过图像编辑器对原有的每一帧进行重新整理，对那些不熟悉设计的开发者来说这是很大的问题。</td>

<td>SVG动画可以直接在SVG代码中进行控制和修改，通常只需要几行代码就可以搞定。</td>
</tr>
</tbody>
</table>

## 文件大小，页面加载时间和性能

前面的小节中我们关注了动画性能本身，在这一小节中，我希望关注页面整体性能以及你所选择的图片格式对其产生的影响。

事实：文件越大，对页面加载时间和性能的负面影响越大。基于这种情况，让我们通过一个更加实际、现实生活中的例子，来观察用SVG替换GIF是怎样优化整体页面的加载时间的。

18个月前，在我的第一个关于SVG的演讲中，我提到过如何使用SVG替换GIF并且得到整个页面性能的提升。在那个演讲中，我用真实世界中的网页作为例子来展示如何利用SVG的优势：[Sprout网站](http://sprout.is/)首页。

Sprout网站首页的两个动画图像最初是使用GIF展示的。两年前[Mike Fortress](https://twitter.com/mfortress)[在Oak上写了一篇博文](http://oak.is/thinking/animated-svgs/)，文中解释了如何用SVG动画重新实现了原来的GIF动画，特别是下图所示的图表动画：

![](https://sarasoueidan.com/images/svg-vs-gif--sprout-chart.svg)

The SVG version of the chart used on the Sprout homepage and written about on the Oak article. <small>(All rights reserved by their owners.)</small>

注意这一动画是用SMIL创建的，如果你正在用IE浏览器是看不到的。

在他的文章中，Mike分享了一些关于他们切换成SVG后的新页面性能的有趣结果：

> 这一图表和Sprout页面上的另外一个动画，最初是GIF格式的。替换成SVG后我们的页面从 **1.6 mb缩减到389 kb**，页面加载时间 **从8.75 s缩减到412 ms**。这是一个巨大的差异。
> <cite>—Mike Fortress, [“Animated SVGs: Custom Easing and Timing”](http://oak.is/thinking/animated-svgs/)</cite>

的确是非常巨大的差异。

Sprout首页上的图表非常适合用SVG。如果SVG有这么多优势完全没有理由录制成GIF。

[Jake Archibald](https://jakearchibald.com/)也意识到SVG动画的威力，并将其用于他文章中交互插图的部分。他的[Offline Cookbook](https://jakearchibald.com/2014/offline-cookbook/)就是很好的例子（同时也是一篇很好的文章）。他可以用GIF来做吗？当然可以。然而考虑到他用到的图片数量，GIF会轻松地将其整个页面的大小增加至几M，因为每张GIF至少需要几百K；然而 **_所有_SVG内嵌的条件下整个页面总体大小只有128KB**，因为[你可以重复利用SVG中的元素](https://sarasoueidan.com/blog/structuring-grouping-referencing-in-svg)，任何重复元素不仅会让整个页面的[gzip效果更好](http://calendar.perfplanet.com/2014/tips-for-optimising-svg-delivery-for-the-web/)，对于每个页面，所有SVG总体大小也变得更小。

_这_ 够牛逼了吧。

关于页面加载和性能的讨论暂时就到这里。但是需要注意的是仍然 _可能_ 存在例外，虽然大多数情况下你都会发现SVG比GIF更好，但最好还是测试一下。

**总结**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>GIF动画图片通常比SVG大，这将会导致对整体页面、加载时间和性能的负面影响。</td>
<td>SVG可以重复利用，gzip压缩效果更好，也使得其整体体积比GIF更小，因而可以优化页面加载时间和性能。</td>
</tr>
</tbody>
</table>

## 浏览器支持

GIF相比SVG唯一的绝对优势可能就是浏览器支持。GIF在任何地方都能很好展现，而SVG的支持相对来说不够全面。虽然我们有很多[针对不支持SVG浏览器的后备方案](https://css-tricks.com/a-complete-guide-to-svg-fallbacks/)，而且以当下的浏览器来说不应该成为阻碍任何人使用SVG的理由，但是备选图片如果采用PNG或JPG格式，就会变成静态、无动画的。

当然，你也可以将GIF作为SVG的后备方案，但还是不得不考虑上文中提到的所有顾虑和缺点。

**总结**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>GIF在任何地方都可以使用。</td>
<td>SVG浏览器支持不够完全，但是对于不支持的浏览器也有很多后备方案。</td>
</tr>
</tbody>
</table>

## 可控性考虑

在页面上或任何地方移动什么东西，就此而言，会立即产生一个分心物-肯定能够在开始移动时立即吸引用户的注意。人类大脑就是这样运行的。这也是广告条如此致力于制作动画效果的原因之一，也是动画广告条 **极度烦人** 的原因。它们会在你需要集中注意执行某项任务（例如阅读一篇文章）时分散你的注意。

想象一个页面汇集了一堆动画图标（或图片），无论你做什么它们都不停地动来动去。我说的不是首页或文章中的一两个动画图片，而是UI中的元素和控制键以及会在许多不同地方重复出现的小图标。除非你的图标 _原本_ 就是设计成无限循环动画的，比如说用户交互等待过程中的spinner，否则将会变得非常恼人，而不再是什么“好事”。

事实上，对于某些人来说可能不只是恼人，持续的动画可能会让有些人感到难受。

在Val Head的文章[“Designing Safer Web Animation For Motion Sensitivity”](http://alistapart.com/article/designing-safer-web-animation-for-motion-sensitivity)中，这位设计师及网页动画顾问讨论了网页中过度使用动画对视觉诱发前庭障碍人群的影响：

> 人们认为scrolljacking和视差效果烦人和被过度使用已经不是什么秘密。但你有没有想过这些动画不只是惹恼你还可能会让你生病？
> 对于视觉诱发前庭障碍患者来说这已经是事实。因为动画交互变得越来越常见，越来越多的人注意到 **屏幕上大规模的动画可能导致他们头昏，恶心，头疼甚至更糟。对有些人来说这些症状甚至会在动画结束之后持续很久。** Yikes.

现在想象一下如果这些动画 _永不_ 停止…… Yikes+1。

Val的文章更详细地解释了这一问题，因为她收集了两个真实病人在看到不同动画时体验的反馈。

避免这些问题的解决方案之一是[提供给用户控制这些动画的方法](http://alistapart.com/article/designing-safer-web-animation-for-motion-sensitivity#section10)，这样当他们觉得被干扰时就可以停止这些动画。

对于SVG来说，你可以完全控制这些动画。如果你真的需要用户进入页面后马上播放，你可以在页面加载后播放一次或两次。然后你可以仅用几行CSS或JavaScript就可以让用户通过hover动作来再次触发它们。**你不需要几百上千行CSS或JavaScript 行代码让图标产生动画**，除非你的图标是一个非常复杂的场景，里面包含很多动画成分。如果真是这样，我觉得已经不能算是“图标”而是常规的图片。

你甚至可以控制回放、每个Tween动画的速度，当然，如果你用JavaScript控制的话你可以做到更多。

或者你可以添加切换按钮让用户可以随时停止循环播放的动画。但是你没办法对GIF这样做……除非你的切换动作是用静态图片替换原来的GIF。

可能有人认为可以通过展示动画图片的静态画面，例如PNG，然后在用户的hover动作时替换成GIF。但是这样做会带来一些问题：

* 如果图片是内嵌的，你需要通过JavaScript来替换这些图片。而这一动作在SVG中不需要用到任何JavaScript。
* 如果图片是前景图片（嵌入HTML中），而你需要替换它们，那么每张图片需要双倍的HTTP请求。如果图片作为样式表中内嵌的背景图片（不推荐这样做），图片（尤其是GIF）大小将会累加到样式文件中，从而阻塞整个页面的渲染时间。
* 如果你在用户hover时替换图片地址，网速较慢时将会在前后两张图片之间产生一个明显的闪烁。我的网络连接比较慢，有时候用3G网络，在hover或是viewport改变之类的随便其它什么情况下看到两张图片的切换，还没有记得哪次没有出现闪烁。这种情况在第二张图片（hover时加载GIF图片）较大的时候，闪烁之后会紧跟着一段加载缓慢而劣质的动画。这样真的毫无吸引力可言。

所以说，你当然可以通过切换图片来控制动画的播放，但是你会因为无法精确控制GIF而影响用户对UI的使用体验。

你也可以控制GIF动画的播放次数（很酷的办法），但是这意味着动画只能播放 **_n_** 次。如果你需要根据用户的行为来重新播放，你还是需要将上面总结的技术应用到多张图片上去实现。

（如果用GIF你需要）维护多张图片，多次HTTP请求，采用一些非最优化的hacky方案来解决这些本来在SVG中非常容易解决的问题：

* 在页面中内嵌 **一个** SVG 图片。
* 在任何你需要的地方创建动画（或者在嵌入图片之前创建动画）
* 对动画的播放，暂停等控制；让用户也可以控制。

不需要额外的HTTP请求去加载，不需要在图像编辑器中维护复杂的动画时间轴，不需要顾虑可控性问题，用几行代码就能避免各种顾虑。

**结论**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>GIF不通过额外的HTTP请求加载图片无法实现用户停止播放动画的功能。即便通过这种方式也无法实现对动画的完全控制。</td>
<td>SVG可以完全定制化，可以通过常规的方法让用户完成启用、停用等控制。</td>
</tr>
</tbody>
</table>

### 内容可控性

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>GIF只能像PNG和JPEG等格式一样通过`alt`属性进行描述。图像的内容无法被识别或通过超出图像整体描述之外的方法直接操作。
</td>
<td>SVG内容及语义结构都是直接可控的。SVG中用于产生动画的内容也能够通过SVG内置的可操作元素以及ARIA规则和属性被渲染的屏幕操作。（可以从[这里](http://www.sitepoint.com/tips-accessible-svg/)了解更多关于SVG可控性的知识）。</td>
</tr>
</tbody>
</table>

## 交互性

SVG内部的元素在动画期间、之前和之后都是可以交互的，除此之外在没有别的什么可说的，然而这些在GIF中都是不可能的。因此，如果你用GIF，你将失去任何超出触发和停止动画之外的控制，即使这些也不是真正在GIF（此处可能是作者笔误为SVG）内部实现的，就像我们刚刚看到的，是通过将GIF替换成静态图片实现的。即使是改变GIF内部元素的颜色也需要借助额外的图片来完成。这也是SVG相比于GIF的另一优势。

**总结**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>GIF中定义的动画无法进行交互。你无法与GIF内的个别元素进行交互，也不能针对个别元素创建链接。</td>

<td>SVG的内容是完全可交互的。你可以让内部个别元素响应用户的hover和点击等相关动作。</td>
</tr>
</tbody>
</table>

## 响应式和自适应动画

可以直接通过代码控制SVG动画及其多种多样的属性，使得SVG比GIF又多了一个优势：不需要额外的HTTP请求，只需要几行代码和很小的文件就能创建响应式、自适应以及高性能的动画。

Sarah Drasner曾在[Smashing Magazine上写过一篇文章](http://www.smashingmagazine.com/2015/03/different-ways-to-use-svg-sprites-in-animation/)，展示了由SVG精灵产生动画的不同方法。其中一种是在SVG内部创建多个“场景”，通过CSS来产生动画，然后通过改变[`viewBox`属性]((https://sarasoueidan.com/blog/svg-coordinate-systems)的值来改变SVG的“视图”，根据当前的窗口大小和可用屏幕区域每次呈现一个场景。

如果你希望创建相同的GIF动画，你将失去对动画的控制，同时需要多张图片来实现，多张图片的大小可比一张SVG图片要大得多。

如果你不想跟SVG动画代码打交道，你可以创建SVG精灵并像其他格式的图片一样去产生动画，用`steps()`方法和几行CSS就可以实现。Sarah也在她的文章中讨论了这一技术。SVG动画并不需要很复杂的方法就能做到高性能。

**结论**：

<table>
<tbody>
<tr>
<td>GIF</td>
<td>Animated SVG</td>
</tr>
<tr>
<td>由于GIF的内容无法通过代码控制，因而要想让动画自动响应窗口或上下文的变化，需要对多张图片分别进行整理操作。</td>

<td>由于SVG直接通过代码产生动画，其内容和动画可以根据视窗大小的和上下文的变化自动响应或适应，不需要对其它资源进行操作。</td>
</tr>
</tbody>
</table>

## 结束语

GIF拥有非常好的浏览器支持，但是SVG在其它各个方面都远胜GIF。当然有可能存在例外的情况，你还是可以用GIF或其它任何图片格式来弥补SVG的不足，你甚至可以用视频或HTML5 Canvas或随便别的什么东西。

SVG相比其它图片格式可以带来性能上的优势，相比GIF尤其如此。

因此，基于以上所有内容，我推荐在任何可以使用SVG动画的地方都要尽量避免使用GIF。你当然也可以忽略我的建议，但同时你也放弃了SVG提供的诸多优势。

除非GIF在IE 8一下版本浏览器支持方面体现出比SVG更多的优势，否则我认为SVG应该是正确的选择。

下面的链接可以帮助你开始使用SVG动画：

*   [The State of SVG Animation](http://blogs.adobe.com/dreamweaver/2015/06/the-state-of-svg-animation.html)
*   [A Few Different Ways to Use SVG Sprites in Animation](http://www.smashingmagazine.com/2015/03/different-ways-to-use-svg-sprites-in-animation/)
*   [Creating Cel Animations with SVG](http://www.smashingmagazine.com/2015/09/creating-cel-animations-with-svg/)
*   [GreenSock](http://greensock.com) has a bunch of very useful articles on animating SVGs
*   [Snap.svg](http://snapsvg.io/start/), also known as “The jQuery of SVG”
*   [SVG Animations Using CSS and Snap.SVG](https://davidwalsh.name/svg-animations-snap)
*   [Styling and Animating SVGs with CSS](http://www.smashingmagazine.com/2014/11/styling-and-animating-svgs-with-css/)
*   [Animated Line Drawing in SVG](https://jakearchibald.com/2013/animated-line-drawing-svg/)

---

希望这篇文章对你有所帮助。

感谢您的阅读。

非常感谢Jake Archibald对本篇文章的审阅和反馈，感谢Chris Lilley对GIF图片的透明度部分的反馈。没有他们的反馈帮助，这篇文章就没办法如此简要而又全面^^
