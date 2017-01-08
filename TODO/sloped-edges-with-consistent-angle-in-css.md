> * 原文地址：[Sloped edges with consistent angle in CSS](https://kilianvalkhof.com/2017/design/sloped-edges-with-consistent-angle-in-css/)
* 原文作者：[Kilian Valkhof](https://kilianvalkhof.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# Sloped edges with consistent angle in CSS

# 在 CSS 中使用恒定角度的斜边

If you look above this text, you can see that the header of this blog has a sloped edge. It’s one of my favorite things about this site’s new design. The technique I used has a consistent angle regardless of screen size, can show background images and only needs one HTML element and no pseudo elements. Here’s how I did that.

如果你看到上面的文字，你能看到博客的头部有一个斜边（如果想查看斜边效果，请点击原文地址，译者注），这是整个网站中我最喜欢的新设计。我用到了一个恒定角度且不随着屏幕尺寸的变化而变化，它可以显示背景图并且不用伪元素，只需一个 HTML 元素就可以实现。以下是我实现的思路：

### Requirements

### 需求

In short, there were a couple of requirements I had with regards to the implementation.

- Look consistent regardless of screen sizes

- Support (and properly clip) background images and foreground text

- Work across devices (don’t care too much about IE)

If I could also keep the HTML and CSS as simple as possible, then that would be a bonus, but not a requirement.

简言之，这是一些我在实现过程中比较关心的需求：

- 不随着屏幕尺寸的变化而变化

- 支持（并且可以适当裁剪）背景图和前景文字

- 能够跨设备工作（不用为 IE 浏览器考虑太多）

如果我能尽可能保持 HTML 和 CSS 的简洁，那将是额外收获，但并不是刚性需求

### Initial Idea

### 最初的想法

My first idea for the sloped edges was to use rotation transforms on the entire element. That quickly leads down a path of increasing complexity.

我第一个用来实现斜边的想法就是在整个元素上使用旋转变换，这很快就导致了复杂性不断增加。


    header {
      width:100%;
      transform:rotate(2deg);
    }
    
![Markdown](http://i1.piimg.com/1949/1d093c8548f75a19.png)

Rotating the element means that we see some of the background in the top left and top right corners. That’s fine, we can deal with that by making the inner element wider, and add some negative offset so it correctly covers the top left and top right corners:

旋转元素使得我们可以在左上角和右上角都可以看到背景。那样也没关系，我们可以通过加大内部元素的宽度并且添加一些负边距来解决，那样它就能恰到好处地覆盖左上角和右上角的内容了。

    header {
      width:110%;
      top:-5%;
      left:-5%;
      transform:rotate(2deg);
    }

![Markdown](http://p1.bpimg.com/1949/66ff9fc9c670e1ae.png)

And then add an overflow:hidden; to the page or extra element so you don’t get weird horizontal scroll bars:

接下来给页面或者多余的元素添加一个超出部分隐藏的属性，这样你就不会看到奇奇怪怪的水平滚动条了；

    body {
      overflow:hidden;
    }
    
    header {
      width:110%;
      top:-5%;
      left:-5%;
      transform:rotate(2deg);
    }

![Markdown](http://p1.bpimg.com/1949/700c21ecaaea3afb.png)

This actually looks great, but what if you add text in there?

看起来很棒哈，但是如果你添加文本会怎样呢？

![Markdown](http://p1.bpimg.com/1949/5da407e3b90930fb.png)

We now have text not only at an angle, but also slightly outside of the viewport. To make it fit properly inside the viewport again, we need to rotate the text in the opposite direction and then and offset it.

现在我们的文本不光有了角度，还有点超出可视窗口了。为了让内容正确地适应可视窗口，我们需要再次往相反的方向旋转文本并设置边距。

    body {
      overflow:hidden;
    }
    
    header {
      width:110%;
      top:-5%;
      left:-5%;
      transform:rotate(2deg);
    }
    
    header p {
      margin-left:5%;
      transform:rotate(-2deg);
    }
    
![Markdown](http://p1.bpimg.com/1949/6df39c8be4aca467.png)

Up until now, This works fine. The problem starts when you go from a fixed-width scale to a responsive scale. Here’s the same element, just wider:

目前为止效果很好，但你从一个固定宽度的尺寸变到响应式的尺寸的时候会出现问题。这是同一个元素，只不过更宽了一点：

![Markdown](http://p1.bpimg.com/1949/8aedc93d0b8ecbd0.png)

The top right has a little page peeking out again. The only way to deal with that, is to increase the area of the header outside of the viewport. This happens with every screen size increase and makes it increasingly complex, and thus, brittle. 

右上角又能看到一点页面背景了。唯一的办法就是增大网站的头部至超出可视窗口，每次屏幕尺寸增加的时候都要这样做使得它越来越复杂也变得不友好。

Additionally, There is quite a bit of aliasing (pixellation around the edge) going on when using transforms. This will undoubtedly improve with new browser releases, but for now it just doesn’t look that nice. 

另外，使用转换属性时会产生相当一部分的混淆现象（边缘周围像素化），这无可置疑地会随着新浏览器版本的发布而性能得到提高，但是现在为止还没那么好。

### ::after pseudo-element

### ::after 伪元素

Another technique often used is to add the transform to an ::after pseudo-element as opposed to the element itself. This has a few benefits compared to the code above: 

- No need to worry about the page peeking out from the top left or top right

- No need to rotate the contents back

还有一个常用的方法就是给 ::after 伪元素添加与元素自身相反的变换属性，相比上面的代码有以下优点：

- 无需担心页面背景会在左上角或者右上角露出来

- 无需将内容旋转回来

So let’s try it:

来吧，我们试一下：

    header::after {
      position:absolute;
      content: " ";
      display:block;
      left:-5%;
      bottom:-10px;
      transform:rotate(2deg);
      width:110%;
    }

![Markdown](http://p1.bpimg.com/1949/e535b8233927267d.png)

*(opacity overlapping so you can see where the elements are)* That works, but you need to offset the after element such that it’s overlapping the bottom edge fully, and like in the examples above, you also need to make it slightly wider just so you don’t get the visible edges on the left or right. I disabled the overflow:hidden;  here so you can see where the ::after element extends to.

*（为了方便你能看到元素的位置重叠部分显示为透明）*效果不错，但是你仍需要给 ::after 元素设置边距让它能够完全盖住底边。如上例所示，你要给它设置得稍微宽一点那样你就不会看到左右不分的边缘了。我取消了超出部分隐藏的属性，你能看到 ::after 延伸到的位置。

You will need to have the same solid background color for both the header and the ::after elements to make this effect convincing.

你需要给头部元素和 ::after 伪元素设置相同的背景填充颜色来使效果更加逼真。

#### ::after pseudo element with a border

#### 带边界的 ::after 伪元素

In CSS, you can use a combination of visible and transparent borders to get visible triangles, which can stand in for a sloped edge. Let’s try the ::after with an angled border:

在 CSS 中，你可以使用可见并且明显的边界来得到可见的三角形，这样就可以替代斜边了。我们来试一下带有角度的边界的 ::after 元素：


    header::after {
      position:absolute;
      content: " ";
      display:block;
      left:0;
      bottom:-20px;
      width:100%;
      border-style: solid;
      border-width: 0 100vw 20px 0;
      border-color: transparent rgba(0,0,0,0.4) transparent transparent;
    }

![Markdown](http://p1.bpimg.com/1949/c75f78837f853d67.png)

This looks good, has much better anti-aliasing and it mostly works if you make the width larger too (provided you use a relative size for your border width):

这种方式看起来很棒，也有更好的抗混淆效果，并且即使你把宽度加大它也生效（假如你为边界宽度使用了相对尺寸的话）：

![Markdown](http://p1.bpimg.com/1949/76a5ed38dd1203f3.png)

Instead of a border, another technique I’ve seen is to use an SVG as a 100% width and 100% height background image for your ::after element, thought this amounts to the same result. 

除了使用边界，我还见过另一种方式那就是使用 SVG 作为 ::after 元素 100% 宽度和 100% 高度的背景图片，尽管这也达到了相同的效果。

Up until now, the border definitely looks the best, and it’s not *too* much code, but it’s still not ideal for a couple of reasons:

- Another element that’s absolutely positioned that you need to keep in mind

- It’s hard to control the angle you want and keep it consistent

- You are limited to using solid background colors

直到现在，便捷的方式毫无疑问看起来是最好的，并且不会有**太多**代码，但是这仍然不是最理想的，原因如下：

- 你需要时刻记得 ::after 元素是绝对定位的

- 很难控制你想要的角度并保持不变

- 你仅限于使用填充式的背景颜色

Up until this point none of my examples used background images (it’s complex enough on its own) but the background image was something I really wanted in my header and footer. ::after pseudo-elements would not support the effect at all. The itself-transformed header would also pose additional problems when positioning the background.

到这里，我没有一个例子使用了背景图片（单单看来那是很复杂的）但是我又实在是想在头部和尾部位置使用背景图片。::after 伪元素根本不支持这种效果，而旋转的头部元素又会在定位背景的时候造成额外的问题。

So all the above options have downsides in the complexity they bring in terms of code, or the inflexibility when it comes to getting a consistent look across screen sizes. 

所以，以上所有的选项都显得不太好，因为在不同屏幕尺寸下获得相同外观时它们将会造成代码复杂而且不灵活。

### Using Clip-Path

### 使用 Clip-Path

With both transforms and ::after borders out, that left me with `clip-path`. 

当转换属性和 ;;after 都出局之后，我就只剩下 `clip-path` 了。

Clip-path is not [especially well supported](http://caniuse.com/#feat=css-clip-path), with just Webkit, Blink and Gecko browsers supporting it and the latter one needing an SVG element. Luckily for me, I can get away with that on my personal blog. Clip Path it is!

Clip-path 并没有[特别好的支持性](http://caniuse.com/#feat=css-clip-path)，只有 Webkit、Blink 和 Gecko 浏览器支持并且新版中需要一个 SVG 元素。幸运的是，我可以在个人博客中避开这种不利因素，那么就 Clip Path 了！

Adding a clip-path is straightforward, you can use the polygon function to describe a trapezium[[1]](#footnote-1) (a rectangle with a sloped edge) like this:

直接添加一个 clip-path，你可以使用多边形函数来描绘一个梯形[[1]](#脚注 1)（带斜边的长方形），像这样：

    header {
      clip-path: polygon(
        0 0, /* left top */
        100% 0, /* right top */ 
        100% 100%, /* right bottom */
        0 90% /* left bottom */
      );
    }

![Markdown](http://p1.bpimg.com/1949/4c7bbf165dd54283.png)

And this works great! It works in all the ways the transform and border methods did not. You can add a background image, there is nothing funny going on with overflows, the edge is *sharp* and I just need that single `<header>` element.

这棒极了！它用一种转换属性和边界方法都没有的方式做到了！你可以添加背景图，并且也不会再有滑稽的超出部分属性了，边缘很**整齐**，只需一个`<header>` 元素就够了。

The only caveat is that, because we describe the polygon in relation to its element, if the width of the element changes in relation to its height the angle of the slope changes. Something that looks like a massive angle on a cellphone would hardly look like a slope at all on a retina screen. Here’s the same exact same clip-path on a wider element:

唯一的一点忠告就是，因为我们描绘的多边形和元素本身有关系，所以如果元素的宽随着高度变化了，斜边的角度也就变化了。有时候看起来就像在手机上是一个比较大的角度而在视网膜屏上看起来就不像是个斜边了。这是在更宽的元素下的相同的 clip-path：

![Markdown](http://p1.bpimg.com/1949/3c22c81581343388.png)

Here the slope is much less acute and the effect is lessened. What we want is the slope to be consistent regardless of the width of the element. The way I achieved that is by **using viewport-width (vw) units**. 

在这里，斜边没那么尖锐了效果也减弱了。我想要的是无论元素在任何宽度下都能相同的斜边，所以我使用了**视窗宽度单元（viewport-width units）**来实现。

### Calculating based on width

### 基于宽度的计算

By using percentages in the polygon notation, you are making the points dependent on the height of an element. If we want to keep the slope consistent when the width changes, we need to allow that to change the height values too. If we change them in an equal measure, then the slope will stay consistent. 

在多边形的标记上使用百分制会使得图形依赖于元素的高度，如果我们想在宽度变化时保持斜边不变，我们需要允许改变其高度值。如果我们使用相同的衡量标准，斜边就能保持不变。

The way to do this is by using viewport width units to determine how far from the bottom of the element the left bottom point should be. In CSS we can do this using the calc function: 

实现方法就是利用视窗宽度单元决定元素的底边和左下角定点所在的位置。在 CSS 中我们可以使用 calc 函数来实现：

    header {
      clip-path: polygon(
        0 0,
        100% 0,
        100% 100%,
        0 **calc(100% - 6vw)**
      );
    }

Changing the width will now *lower the position of the lower left point*, creating an effect where the slope remains the same. 

现在改变宽度将会**降低左下角的顶点的位置**，创造出斜边保持不变的效果。

If you want the slope to be at the top of your element, it would actually be simpler: the first line would become “6vw 0”, and you would not even need a calc().


如果你想让斜边在元素的上不，那将会更简单：第一条线设置为“6vw 0”，你根本都不需要使用 calc()。

At this point, feel free to scroll up to the header (or down to the footer) and resize your browser to see the effect in action.

这下你可以自由地滚屏到头部（或者尾部）并且拉伸你的浏览器来查看响应式的效果了。

### Firefox support

### 火狐浏览器的支持

Unfortunately, Firefox only supports SVG polygons for describing a clip path, so until support lands in Firefox, people will see different angles in it.

不幸的是，火狐浏览器只支持 SVG 的多边形来描绘一个 clip path，因此在火狐浏览器添加支持之前，人们都只会看到一个不同的角度。

Creating a clip-path for Firefox requires some knowledge of SVG. SVG clipPaths are described in either real values such as pixels, or fractions between 0 and 1 for percentages. SVG has an attribute called `clipPathUnits="objectBoundingBox"` which you can use to tell your browser to take the dimensions of your element, and apply the clip-path to that. Without it, it would use the SVG’s dimensions. If you combine using fractional values and using the object bounding box, you basically get the polygon I described above:

在火狐浏览器中创造一个 clip-path 需要一些 SVG 的指示。SVG 的 clipPath 是用真实的像素值或者 0 到 1 的百分数来描绘的。SVG 有一个叫做 `clipPathUnits="objectBoundingBox"`  的属性，你可以用它来告诉浏览器获取到元素的尺寸，并应用于 clip-path。没有它，你将只能使用 SVG 的尺寸。如果你既实用了百分数的值也使用了对象盒子边界，你基本可以得到和上文中相同的多边形了：


    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
      <defs>
        <clipPath id="header" clipPathUnits="objectBoundingBox">
          <polygon points="0 0, 1 0, 1 1, 0 0.87" />
        </clipPath>
      </defs>
    </svg>

If you look at the definition of the points, then you can see that it’s very similar to how we define them in the CSS clip-path example. Referencing this file in your CSS looks like this:

如果你看到了这些定义形式，你就能明白它和我们在 CSS clip-path 中的例子中定义的方式很相似。你可以在 CSS 文件中这样引用这些文件：

    @-moz-document url-prefix() {
      header {
        clip-path: url(path/to/yoursvgfile.svg#header)
      }
    }

The @moz-document is a cheat to prevent the rule from being applied in other browsers. Alternatively, as [Sven Wolfermann](https://twitter.com/maddesigns/status/816673011369701381) pointed out, just specify your url() clip-path *before* your polygon() clip-path and Firefox will fall back to it automatically. When Firefox adds support, [slated for mid-april of 2017](http://jensimmons.com/post/jan-4-2017/slicing-your-page), it will automatically start using polygon() too. 

@moz-document 是用来防止这些规则被应用于其他浏览器的一种手段。正如 [Sven Wolfermann](https://twitter.com/maddesigns/status/816673011369701381) 所言，当你在制定 polygon() 的 clip-path 之前指定了你的 url() 的 clip-path，火狐浏览器会自动退回到 url()。当给火狐浏览器添加了支持的时候，[slated for mid-april of 2017](http://jensimmons.com/post/jan-4-2017/slicing-your-page)，它也会自动开始使用 polygon()。

Apart from not having a consistent angle across screen sizes, it has all the benefits that a css-defined clip-path has, such as the element being in normal flow, a nicely anti-aliased edge and backgrounds applying like you’d expect them to. 

除了不能实现不同屏幕尺寸下恒定角度之外，它具备所有 CSS 定义的 clip-path 有具备的优点，比如元素会在正常的文本流中，良好的抗混淆边缘和随心所欲的背景设置方式。

### Sloped edges with consistent angle in CSS

### 在 CSS 中使用恒定角度的斜边

So that’s how you create sloped edges with a consistent angle in CSS, that doesn’t need `overflow:hidden`, allow you to use backgrounds and can be done with just a single element. 

这就是如何在 CSS 中创造一个恒定角度的斜边，不用使用 `overflow:hidden`，让你能够使用多种背景样式并且只需使用一个元素就能实现。

If you have comments or improvements on this technique, please let me know on [Twitter](https://twitter.com/kilianvalkhof) or [email me](/contact)!

如果你想发表评论或者有任何技巧方式的改进，欢迎给我发[推特](https://twitter.com/kilianvalkhof)或者邮件（邮件地址请参阅原文连接，译者注）！

*[[1]](#footnote-ref-1) Thanks to my math teacher girlfriend for telling me the proper name for this shape.*

*[[1]](#脚注 1) 感谢我的数学老师女朋友告诉我这个形状的正确名字。*（作者写技术文章也不忘撒狗粮，感觉受到了一万点伤害，译者注）
