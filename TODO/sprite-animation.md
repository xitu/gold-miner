> * 原文链接 : [An Introduction to Sprite Animation](http://eighthdaydesign.com/journal/sprite-animation)
* 原文作者 : [ eighthday](http://codepen.io/eighthday/pen/dYNJyR)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :  [阿树](http://aaaaaashu.me/)
* 校对者: [iThreeKing](https://github.com/iThreeKing)
* 状态 :  完成

# 关于 Sprite 动画简介

#### 我们总是希望添加运动的元素到我们的网站上，并认为流畅的动画可以让乏味的模板化网站设计得到改善。

Sprite 动画并不是一项新技术，在维多利亚时代的人就已经用他们的西洋镜教我们如何实现它，而在数字化时代，8-bit 电子游戏设计师通过 8 bit 像素展示给我们怎么实现它。然而它的核心，其实就是一连串的图片循序的运动。

![Sprite walk cycle animation ](http://eighthdaydesign.com/resources/images/1-10-2015/80-299.Paul_walk_2560_2.gif) ![Sprite walk cycle animation](http://eighthdaydesign.com/resources/work/1-10-2015/2-2-299.Paul_walk_mob_2.gif)

#### Spritesheet 的制作

<table>
   <tbody><tr>
      <td>Ai</td>
      <td>Illustrator</td>
      <td>SVG</td>
   </tr>
   <tr>
<td>Fl</td>
      <td>Flash</td>
      <td>PNG</td>
   </tr>
<tr>
<td>Ps</td>
      <td>Photoshop</td>
      <td>PNG</td>
   </tr>
<tr>
<td>Ae</td>
      <td>After Effects</td>
      <td>PNG</td>
   </tr>
</tbody></table>

不管你如何获得，你需要的就是一张由许多同等大小的帧（sprites）组成的图片。 Sprintesheets 可以被任何输出 PNG 和 SVG 的应用制作。

SVGs 在高分辨率显示器上有着看起来锐利的优势，但在纹理，渐变，和复杂的插图上表现并不如意。我们通常可以在 [SVGCleaner](http://sourceforge.net/projects/svgcleaner/) 和  [SVGOMG](https://jakearchibald.github.io/svgomg/) 这样的应用帮助下，获得超小的文件大小。 PNG 格式是重量级动画应用：Flash & After Effects 原生输出选项，我们也可以通过这样的构建环境去创造流畅的动画。

我们的目标是创造视网膜(retina)级的动画。我们已经成功的从 After Effect 输出一连串的 PSDs，并且在  Illustrator 上通过 Bridge 批处理转换成 SVG。你也可以增大两倍 PNGs 的尺寸和通过 JavaScript 控制比例，但这样的工作流离完美很远。

#### 回到现实

为了实现基本的循环动画，我们给一个 HTML 元素赋予背景图片，并随着时间用 JavaScript  调整背景图片的位置。

你也可以使用 CSS3 steps()  做类似的事情，但为了全面的控制和更好的浏览器兼容，像 Greensocks  [GSAP](http://greensock.com/gsap) 这样的 JavaScript 库更合适解决这样的问题。

<iframe height="268" scrolling="no" src="//codepen.io/eighthday/embed/dYNJyR/?height=268&amp;theme-id=0&amp;default-tab=result" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen <a href="http://codepen.io/eighthday/pen/dYNJyR/">Responsive SVG walk cycle with GSAP</a> by eighthday (<a href="http://codepen.io/eighthday">@eighthday</a>) on <a href="http://codepen.io">CodePen</a>.</iframe>

See the Pen [dYNJyR](http://codepen.io/eighthday/pen/dYNJyR/) by eighthday ([@eighthday](http://codepen.io/eighthday)) on [CodePen](http://codepen.io).

#### HTML & CSS

我们所作的就是给一个 HTML 元素赋予背景，并固定其宽高，这样我们仅能在每一刻看到一个 sprite。

> 如果你使用不少于一个动画，你可以合并 spritesheets 减少 HTTP 请求。

    <div id="mySpritesheet"></div>
	
    #mySpritesheet {
      background: url('my.svg');
      width: 100px;
      height: 100px;
    }

#### JavaScript

TimelineMax 提供一个很方便的方法定义我们如何更新背景位置，以及让我们很好的控制我们的动画。如果复杂程度渐增，这就变得很有价值了。

> 你可以使用一个 Timeline 来控制多个动画，使得一连串 spritesheets 尽可能的同步。

首先我们定义动画的参数

    var svg = $("#mySpritesheet")
    var totalFrames = 22;
    var frameWidth = 162
    var speed = 0.9;

然后算出我们希望背景滚动的距离

    var finalPosition = '-' + (frameWidth * totalFrames) + 'px 0px';

然后创建TimelineMax 和 SteppedEase 的实例，定义我们的时间轴将耗费多少帧

    var svgTL = new TimelineMax() 
    var svgEase = new SteppedEase(totalFrames)

最后我们在一个 tween，将所有内容关联起来
Finally we put it all together in a tween

    svgTL.to(svg, speed, {
        backgroundPosition: finalPosition,
        ease: svgEase,
        repeat: -1,
    })

## 获得控制

在这阶段，你也许在想最后的结果不就是一个会动的 GIF 嘛（这个世界的确需要更多的会动的 GIF），不同的是，我们可以完全的控制我们的动画，我们可以停止、反转、循环、甚至与用户交互时，临时的替换另一个 sprite 去完成复杂的动画。
