> * 原文地址：[Practical SVG](http://alistapart.com/article/practical-svg)
* 原文作者：[Chris Coyier](http://alistapart.com/author/chriscoyier)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： [MAYDAY1993](https://github.com/MAYDAY1993)
* 校对者： [zhouzihanntu](https://github.com/zhouzihanntu)   [hpoenixf](https://github.com/hpoenixf)

# 嘿，Logo，你应该是这个尺寸的！

可能你想控制任何你放在网上的图片的尺寸，_嗨！就是你！ Logo !你应该是这个大小：_

```
<img src="logo.png" class="logo" />
```

```
.logo {
  width: 220px;
  height: 80px;
}
```

**下面继续**

并且图片也应该能任意控制大小。

但是如果你正在缩放的元素恰好是 `svg`，结果可能并不是你期待的。定义 `svg` 的尺寸比定义 `img` 复杂一点。说这句不是吓你喔。复杂不是坏事，因为它给你更多的控制并且多了一些有趣的可能性。

当你涉及 SVG 图片的尺寸，记住下面两个概念：

* viewport 就是元素的高度和宽度：即 SVG 图片可见区域的大小。经常直接在 SVG 上或者通过 CSS 设置<var>width</var> 和 <var>height</var>属性。
* `viewBox` 是 `svg` 的一个属性，来确定坐标系和纵横比。四个值是<var>x</var>, <var>y</var>, <var>width</var>, 和 <var>height</var>。

我们一般这样做：
```
<svg width="100" height="100" viewBox="0 0 100 100">

<!-- alternatively: viewBox="0, 0 100, 100" -->
```

在这种情况下，视图大小和 `viewBox` 完全一致(**Fig 6.1**)。 SVG 将会在它视觉上占据的那个地方展现出来。
[CodePen Embed](//codepen.io/chriscoyier/embed/adqEmQ?height=265&amp;theme-id=0&amp;slug-hash=adqEmQ&amp;default-tab=html%2Cresult&amp;user=chriscoyier&amp;embed-version=2")

Fig 6.1: viewport 和 `viewBox` 完全一致。这发生在没有设置`svg`的长度或宽度（属性或 CSS 都没有），或者如果你设置了长度和宽度，它们和`viewBox`的纵横比保持一致。

现在我们将宽度和高度翻倍，像这样：

```
<svg width="200" height="200" viewBox="0 0 100 100">
```

`svg` 会在 200 * 200 的元素的左上角占据 100 * 100 的区域么？不会， `svg` 内的每个都会在新的更大的空间扩大(**Fig 6.2**)。
[CodePen Embed](//codepen.io/chriscoyier/embed/VeQyQY?height=265&amp;theme-id=0&amp;slug-hash=VeQyQY&amp;default-tab=html%2Cresult&amp;user=chriscoyier&amp;embed-version=2")

Fig 6.2: viewport 变大而 `viewBox` 保持不变，图片放大来适应 viewport。

正方形的纵横比依然很匹配。这就是为什么将 SVG 内任何地方的数值认为是像素是没用的，因为他们不是像素；他们只是在一个任意的坐标系里的数值。

那么，如果纵横比不匹配怎么办？

```
<svg width="300" height="75" viewBox="0 0 100 100">
```

默认情况下，SVG将尽可能大的展现自己，沿着最长的尺寸居中(**Fig 6.3**)。
[CodePen Embed](//codepen.io/chriscoyier/embed/vLdpdN?height=265&amp;theme-id=0&amp;slug-hash=vLdpdN&amp;default-tab=html%2Cresult&amp;user=chriscoyier&amp;embed-version=2")

Fig 6.3: viewport 变大了，但不再匹配 `viewBox` 的纵横比。所以默认情况下，图片在没被裁剪的情况下尽可能大的展现出来，并在比例大的方向居中。

如果你想重新控制这个行为， `svg` 元素有个属性会起作用！
## `preserveAspectRatio`

像这样：

```
<svg preserveAspectRatio="xMaxYMax">
```

这个值的 `x` 和 `Y` 部分后面是 `Min`, `Mid`, 或 `Max`。 SVG 通常在视图中居中的原因是有个默认的 `xMidYMid` 值。如果你把值改成 `xMaxYMax`，这就告诉了 SVG：确保在水平方向上尽可能靠右，竖直方向上尽可能靠底部。然后在没有裁剪的情况下尽可能的大。

“没有裁剪”部分是 `preserveAspectRatio` 的另一个方面。默认值是 `xMidYMid meet` －注意下 “meet” 。你可以用 `slice` 来代替 `meet` 意思是：完整地填充区域；裁剪也可以。

和 `meet` 组合会有九种可能的对齐的值(**Fig 6.4**)。

![Several images representing rectangle pairs, demonstrating placement variations for smiley face graphics found in each rectangle.](http://alistapart.com/d/practical-svg/Fig6.4preserveAspectRatio.jpg)

Fig 6.4: 带 `meet` 值的 `preserveAspectRatio` 的例子。

和 `slice` 组合也有九种可能的对齐的值(**Fig 6.5**)。


![Several images representing rectangle pairs, demonstrating placement variations for smiley face graphics found in each rectangle. Each also exceeds the height and width of the rectangle's frame.](http://alistapart.com/d/practical-svg/Fig6.5preserveAspectRatio-slice.jpg)

Fig 6.5: 带 `slice` 值的 `preserveAspectRatio` 的例子。


为了证实这个想法我做了一个[测试工具](http://bkaprt.com/psvg/06-01/)。关于这个主题 Sara Soueidan 也写了一篇有深度的文章，她很好的研究了[把这个想法关联到 CSS](http://bkaprt.com/psvg/06-02/)。 `background-size` 属性有两个值：`contain` 和 `cover`。`contain` 值的作用是“确保整个图片在屏幕缩小的情况下仍然可见”，就像 `meet`。`cover` 值的作用是“确保图片覆盖整个背景区域，即使图像的某些部分可能被裁减，”，就像 `slice`。


就算是对齐部分也有一个对应的 CSS 属性： `background-position`。默认的 `background-position`值是`0 0`，意思是 “top left”。就像 `xMinYMin` 一样。如果你把它改成 `50% 100%`，那就像 `xMidYMax`！

**Fig 6.6** 这些例子让联系更清晰。

`preserveAspectRatio` 值 和 CSS 属性


| | |
| :-: | :-: |
| `preserveAspectRatio= "xMinYmax meet"` | `background-position: 0 100%; background-size: contain;` |
| `preserveAspectRatio= "xMidYMid meet"` | `background-position: 50% 50%; background-size: contain;` |
| `preserveAspectRatio= "xMinYmax slice"` | `background-position: 100% 0; background-size: cover;` |
| `preserveAspectRatio= "xMidYMid slice"` | `background-position: 50% 100%; background-size: cover;` |

Fig 6.6: `preserveAspectRatio` 的值和与之相似的 CSS 属性

记住：他们在代码不是通用的；只是概念上相关。

如果你不想考虑纵横比，让 SVG 随视图大小缩放，就像光栅图像那样呢？把 `preserveAspectRatio` 属性设置为 ‘none’ 吧(**Fig 6.7**)!

```
<svg preserveAspectRatio="none" viewBox="0 0 100 100">
```

[CodePen Embed](//codepen.io/chriscoyier/embed/yevpvj?height=265&amp;theme-id=0&amp;slug-hash=yevpvj&amp;default-tab=html%2Cresult&amp;user=chriscoyier&amp;embed-version=2")

Fig 6.7: `preserveAspectRatio="none"` 的例子。

Amelia Bellamy-Royds 写了篇[关于缩放 SVG 的全面的文章](http://bkaprt.com/psvg/06-03/)，在文章中她叙述了 `svg`  实际上可以包含其他的有不同纵横比和行为的 `svg`，所以你可以让一张图部分缩放，其余部分正常显示；这对于 `svg` 来说又酷又独特。

### 画板尺寸缩放的方法

当你在编辑软件中画 SVG，软件可能提供给你某种画板来在上面画。这不是个技术的 SVG 术语；它实际上是 `viewBox` 的一个视觉上的比喻。

假设你在为一个网站设计一整套图标。一种方法是让所有的画板接触图标的每个边(**Fig 6.8**)。
![Adobe Illustrator graphics cropped to their edges](http://alistapart.com/d/practical-svg/Fig6.8cropped.jpg)

Fig 6.8: 在 Adobe Illustrator 中图片接触到边缘的例子。

这儿有个快捷的小技巧来在 Illustrator 里裁剪画板：选择画板工具，然后在 Presets 菜单选 “Fit to Artwork Bounds”(**Fig 6.9**).

![Cropped view of Adobe Illustrator menu option for resizing an artboard to the edges of a graphic](http://alistapart.com/d/practical-svg/Fig6.9fit-to-bounds.jpg)

Fig 6.9: 在 Adobe Illustrator 里菜单选项可以根据图片的边缘重新定义画板大小。

这个技巧的优点是对齐(**Fig 6.10**)。如果你想把这些图标的任一边和任何其他的东西对齐，实现起来很简单。并不存在你需要应对的魔幻之处或需要不断调整的定位样式。

```
.icon.nudge {
  position: relative;
  right: -2px; /* UGHCKKADKDKJ */
}
```

![Icons aligned to corners of graphics](http://alistapart.com/d/practical-svg/Fig6.10corner-positioning.jpg)

Fig 6.10: 图标无间隙地和边缘对齐。

这个裁剪技术的缺点是相对的尺寸。想象下你采取一般的方法来定义图标的宽度和高度，像这样：
```
.icon {
  width: 1em;
  height: 1em;
}
```

一个又高又细长的图标将会缩小来适应那个区域，并且可能显得很小。或是你可能在尝试有意把一个小的星星形状作为一个图标，期待着星星有一个正方形的纵横比，因此会放大来填充区域，然而结果比你想要的还大。

这有个例子关于两个图标的尺寸都设置成正方形(**Fig 6.11**)。“expand” 图标看上去很正常，因为它有一个正方形的纵横比来调整。但是 “zap it” 图标有一个高高窄窄的纵横比，所以它看上去很小，像在同样的正方形区域上浮动。
![Two button samples; one example has a nicely-balanced scale of icon to text, the other has an icon that is too small for the space and size of text](http://alistapart.com/d/practical-svg/Fig6.11AwkwardIconSizes.jpg)

Fig 6.11: 两个图标在一个按钮中尺寸是同样的正方形区域。上面的一个响应的很好，但是底部的那个很奇怪的在区域中浮动。

另一个方法是制作尺寸一致的画板(**Fig 6.12**)：
![Several similarly-sized graphics](http://alistapart.com/d/practical-svg/Fig6.12same-size.jpg)

Fig 6.12: Illustrator 里的画板大小相同的图形的例子。

优点和缺点恰恰是可逆的。你可能遇到对齐的问题，因为并不是所有图标的边会碰到 `viewBox` 的边，这是沮丧的并且有时候可能需要调整(**Fig 6.13**)。

![Graphics with icons sized to be comparable to one another](http://alistapart.com/d/practical-svg/6.13RelativeSizing.jpg)

Fig 6.13: 你可以调整图标的相对大小，但那样会让对齐更困难。

但是你不会有相对的尺寸问题，因为对于所有的画板来说 `viewBox` 是一样的。如果任何一个图标看上去太大或太小，你可以调整画板来使其符合这一系列。

既然我们在了解尺寸，现在是时候来研究 SVG 是如何适配响应式设计的弹性世界的。

## 响应式的 SVG

响应式设计的一个特点是流式布局。内容－包括图片－被设计来适应它的容器和屏幕。如果响应式设计对你来说是陌生的，关于这个主题 [Ethan Marcotte 在 2010 年的重要的文章](http://alistapart.com/article/responsive-web-design)是一个很好的选择来开始了解响应式设计。SVG 与响应式设计很适合。

* 响应式设计是弹性的。SVG 也是！它在每个尺寸都呈现的很好。
*响应式设计是一门关注一个网站在任一浏览器中如何呈现和如何表现的哲学。相对小的 SVG 文件和像一个 SVG 图标系统的性能优先的策略就是响应式设计的一部分。

但可能 SVG 与响应式设计最显著的联系是对 CSS 媒体查询的可能性。媒体查询基于浏览器窗口的高度或宽度等因素用 CSS 来移动，隐藏或显示元素。这些元素能是任何东西：侧边栏，导航栏，广告和你有的任何东西。也可能是 SVG 元素。

想象一下，有一个图标能基于可用空间的大小展现不同层次的细节。这就是当 Joe Harrison 设计一个真正简洁的[用著名图标设计的 demo](http://bkaprt.com/psvg/06-05/)时想到的东西, (**Fig 6.14**).
![Modified versions of the Disney logo, progressing to greater and greater simplification](http://alistapart.com/d/practical-svg/Fig6.14responsive-logos.jpg)

Fig 6.14: Joe Harrison 的不同尺寸迪斯尼图标的 demo。

在网站上，我们经常能用其他的图片来替换图片。这里吸引我们的是我们并没有_替换_图片；它们都是_同一张_图片。或至少它们能是同一张。签名 “D” 和在最复杂的图表版本中使用的就是同样的 “D”。

在 CSS 中通俗的写法。

我们像这样组织 SVG：
```
<svg class="disney-logo">
 <g class="magic-castle">
    <!-- paths, etc -->
  </g>
  <g class="walt">
    <!-- paths, etc -->
  </g>
  <g class="disney">
    <path class="d" />
    <!-- paths, etc -->
  </g>
</svg>
```

顺便说一下，在 Illustrator 中这很容易实现(**Fig 6.15**)。在这里你写的组件和名称在以 SVG 输出时变成 ID，你能使用这些 ID 来定义样式。然而，我个人更喜欢使用类因为它们不是唯一的（所以你不会突然遇到在页面上有多个同样的 ID）并且类有一个更低更好管理的 CSS specificity 特性权重。在一个代码编辑器里非常简单地就能用查找替换操作把 ID 变成类。
![Adobe Illustrator interface showing vector paths and layers for Walt Disney logo](http://alistapart.com/d/practical-svg/Fig6.15NamedLayers.jpg)

Fig 6.15: 在 Adobe Illustrator 中命名的层和形状。

对应的CSS像这样：
```
@media (max-width: 1000px) {
  .magic-castle {
    display: none;
  }
}
@media (max-width: 800px) {
  .walt {
    display: none;
  }
}
@media (max-width: 600px) {
  .disney > *:not(.d) {
    display: none;
  }
}
```

注意，有一个人为的例子在不同的断点隐藏部分图片，但是这就是你将要做的，同时可能有一些尺寸调整。你能用 CSS 做的任何事情都列在这儿了。可能某些动画在某些断点是合适的，但是在其他并不合适。可能（译者注：求助攻）。可能你改变一些填充颜色来简化相邻的外形。

事情会更有趣！取决于 SVG 的使用方式，这些媒体查询实际上可能是不同的。作为 `img`, `iframe`, 或 `object` 使用的 SVG 有它自己的视图。这就意味着_嵌入在内的_ CSS 以此为基础来响应媒体查询，而不是整个的浏览器窗口视图。这就意味着你是基于图片的宽度来声明以图片为基础的媒体查询，而不是整个页面的宽度。

这是个非常吸引人的想法：一个元素基于它自己的属性安排自己，而不是页面。我是这么宽么？对。我是这么高么？也是。_那样， SVG 响应它所在的情景而不是它所在的任意文档。

正如我写的，这在 CSS 中称作“元素查询”，但是实际上在正常的 HTML/CSS 中并不存在。又一次地，SVG 具有超前意识。

## 来看看动画

谈到 SVG 擅长的事情，让我们接下来看看动画。至今为止我们一直依赖的一切已经为我们准备好了。紧紧抓住吧！

## [唯一的常量变了：与 Ethan Marcotte 的一场问答](http://alistapart.com/blog/post/responsive-web-design-second-ed)

## [框架](http://alistapart.com/article/frameworks)

在这个摘录中，Ethan Marcotte 检查框架来思考响应式设计的规则并把它们应用在我们的工作中。

