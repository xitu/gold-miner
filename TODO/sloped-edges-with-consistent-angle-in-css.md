> * 原文地址：[Sloped edges with consistent angle in CSS](https://kilianvalkhof.com/2017/design/sloped-edges-with-consistent-angle-in-css/)
* 原文作者：[Kilian Valkhof](https://kilianvalkhof.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[Lei Guo](https://github.com/futureshine)、[John Chong](https://github.com/Goshin)

# 在 CSS 中保持斜边的角度不变

如果你看到上面的文字，你能看到博客的头部有一个斜边（如果想查看斜边效果，请点击原文地址，译者注），这是整个网站中我最喜欢的新设计。我用到了一个技巧，让斜边的角度不变，且不随着屏幕尺寸的变化而变化，它可以显示背景图并且不用伪元素，只需一个 HTML 元素就可以实现。以下是我实现的思路：

### 需求

简言之，这是一些我在实现过程中比较关心的需求：

- 不随着屏幕尺寸的变化而变化

- 支持（并且可以适当裁剪）背景图和前景文字

- 能够跨设备工作（不用为 IE 浏览器考虑太多）

如果我能尽可能保持 HTML 和 CSS 的简洁，那将是额外收获，但并不是刚性需求

### 最初的想法

我第一个用来实现斜边的想法就是在整个元素上使用旋转变换，但很快看出这是一条不断增加复杂性的不归路。


    header {
      width:100%;
      transform:rotate(2deg);
    }
    
![Markdown](http://i1.piimg.com/1949/1d093c8548f75a19.png)

旋转元素使得我们可以在左上角和右上角都可以看到背景。那样也没关系，我们可以通过加大内部元素的宽度并且添加一些负偏移来解决，那样它就能恰到好处地覆盖左上角和右上角的内容了。

    header {
      width:110%;
      top:-5%;
      left:-5%;
      transform:rotate(2deg);
    }

![Markdown](http://p1.bpimg.com/1949/66ff9fc9c670e1ae.png)

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

看起来很棒哈，但是如果你添加文本会怎样呢？

![Markdown](http://p1.bpimg.com/1949/5da407e3b90930fb.png)

现在我们的文本不光有了角度，还有点超出视窗了。为了让内容正确地适应视窗，我们需要再次往相反的方向旋转文本并设置偏移。

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

目前为止效果很好，但你从一个固定宽度的尺寸变到响应式的尺寸的时候会出现问题。这是同一个元素，只不过更宽了一点：

![Markdown](http://p1.bpimg.com/1949/8aedc93d0b8ecbd0.png)

右上角又能看到一点页面背景了。唯一的办法就是增大网站的头部至超出视窗，每次屏幕尺寸增加的时候都要这样做使得它越来越复杂也变得不友好。

另外，使用转换属性时会产生相当一部分的锯齿现象（边缘周围像素化），这无可置疑地会随着新浏览器版本的发布而性能得到提高，但是现在为止还没那么好。

### ::after 伪元素

还有一个常用的方法就是给 ::after 伪元素添加与元素自身相反的变换属性，相比上面的代码有以下优点：

- 无需担心页面背景会在左上角或者右上角露出来

- 无需将内容旋转回来

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

**（为了方便你能看到元素的位置重叠部分显示为透明）**效果不错，但是你仍需要给 ::after 元素设置偏移让它能够完全盖住底边。如上例所示，你要给它设置得稍微宽一点那样你就不会看到左右部分的边缘了。我取消了超出部分隐藏的属性，你能看到 ::after 延伸到的位置。

你需要给头部元素和 ::after 伪元素设置相同的背景填充颜色来使效果更加逼真。

#### 带边框的 ::after 伪元素

在 CSS 中，你可以组合使用可见和透明的边框来得到可见的三角形，这样就可以替代斜边了。我们来试一下带有角度的边框的 ::after 元素：


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

这种方式看起来很棒，也有更好的抗锯齿效果，并且即使你把宽度加大它也生效（假如你为边框宽度使用了相对尺寸的话）：

![Markdown](http://p1.bpimg.com/1949/76a5ed38dd1203f3.png)

除了使用边框，我还见过另一种方式那就是使用 SVG 作为 ::after 元素 100% 宽度和 100% 高度的背景图片，这也能达到相同的效果。

直到现在，使用边框的方式毫无疑问看起来是最好的，并且不会有**太多**代码，但是这仍然不是最理想的，原因如下：

- 你需要时刻记得 ::after 元素是绝对定位的

- 很难控制你想要的角度并保持不变

- 你仅限于使用填充式的背景颜色

到这里，我没有一个例子使用了背景图片（单单看来那是很复杂的）但是我又实在是想在头部和尾部位置使用背景图片。::after 伪元素根本不支持这种效果，而元素旋转的方式又会在定位背景的时候造成额外的问题。

所以，以上所有的选项都显得不太好，因为在不同屏幕尺寸下获得相同外观时它们将会造成代码复杂而且不灵活。

### 使用 Clip-Path

当转换属性和 ::after 都出局之后，我就只剩下 `clip-path` 了。

Clip-path 并没有[特别好的支持性](http://caniuse.com/#feat=css-clip-path)，考虑到只有 Webkit、Blink 和 Gecko 浏览器支持并且后者还需要一个 SVG 元素。幸运的是，我可以在个人博客中避开这种不利因素，那么就 Clip Path 了！

直接添加一个 clip-path，你可以使用多边形函数来描绘一个梯形<sup>[\[1\]](#note1)</sup>（带斜边的长方形），像这样：

    header {
      clip-path: polygon(
        0 0, /* left top */
        100% 0, /* right top */ 
        100% 100%, /* right bottom */
        0 90% /* left bottom */
      );
    }

![Markdown](http://p1.bpimg.com/1949/4c7bbf165dd54283.png)

这棒极了！它用一种转换属性和边框方法都没有的方式做到了！你可以添加背景图，并且也不会再有滑稽的超出部分属性了，边缘很**整齐**，只需一个`<header>` 元素就够了。

唯一的一点忠告就是，因为我们描绘的多边形和元素本身有关系，所以如果元素的宽随着高度变化了，斜边的角度也就变化了。有时候看起来就像在手机上是一个比较大的角度而在视网膜屏上看起来就不像是个斜边了。这是在更宽的元素下的相同的 clip-path：

![Markdown](http://p1.bpimg.com/1949/3c22c81581343388.png)

在这里，斜边没那么尖锐了效果也减弱了。我想要的是无论元素在任何宽度下都能相同的斜边，所以我使用了**视窗宽度单元（viewport-width units）**来实现。

### 基于宽度的计算

在多边形的标记上使用百分制会使得图形依赖于元素的高度，如果我们想在宽度变化时保持斜边不变，我们需要允许改变其高度值。如果我们使用相同的比例改变宽高，斜边的角度就能保持不变。

实现方法就是利用视窗宽度单元决定元素的底边和左下角定点所在的位置。在 CSS 中我们可以使用 calc 函数来实现：

    header {
      clip-path: polygon(
        0 0,
        100% 0,
        100% 100%,
        0 **calc(100% - 6vw)**
      );
    }

现在改变宽度将会**降低左下角的顶点的位置**，创造出斜边保持不变的效果。

如果你想让斜边在元素的上部，那将会更简单：第一条线设置为“6vw 0”，你根本都不需要使用 calc()。

这下你可以自由地滚屏到头部（或者尾部）并且拉伸你的浏览器来查看响应式的效果了。

### 火狐浏览器的支持性

不幸的是，火狐浏览器只支持 SVG 的多边形来描绘一个 clip path，因此在火狐浏览器添加支持之前，人们都只会看到一个不同的角度。

在火狐浏览器中创造一个 clip-path 需要一些 SVG 的知识。SVG 的 clipPath 是用真实的像素值或者 0 到 1 的百分数来描绘的。SVG 有一个叫做 `clipPathUnits="objectBoundingBox"`  的属性，你可以用它来告诉浏览器获取到元素的尺寸，并应用于 clip-path。没有它，你将只能使用 SVG 的尺寸。如果你既实用了百分数的值也使用了对象盒子边框，你基本可以得到和上文中相同的多边形了：


    <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
      <defs>
        <clipPath id="header" clipPathUnits="objectBoundingBox">
          <polygon points="0 0, 1 0, 1 1, 0 0.87" />
        </clipPath>
      </defs>
    </svg>

如果你看到了这些定义形式，你就能明白它和我们在 CSS clip-path 中的例子中定义的方式很相似。你可以在 CSS 文件中这样引用这些文件：

    @-moz-document url-prefix() {
      header {
        clip-path: url(path/to/yoursvgfile.svg#header)
      }
    }

@moz-document 是用来防止这些规则被应用于其他浏览器的一种手段。正如 [Sven Wolfermann](https://twitter.com/maddesigns/status/816673011369701381) 所言，当你在制定 polygon() 的 clip-path 之前指定了你的 url() 的 clip-path，火狐浏览器会自动退回到 url()。当给火狐浏览器添加了支持的时候，[slated for mid-april of 2017](http://jensimmons.com/post/jan-4-2017/slicing-your-page)，它也会自动开始使用 polygon()。

除了不能实现不同屏幕尺寸下恒定角度之外，它具备所有 CSS 定义的 clip-path 有具备的优点，比如元素会在正常的文本流中，良好的抗锯齿边缘和随心所欲的背景设置方式。

### 在 CSS 中使用恒定角度的斜边

这就是如何在 CSS 中创造一个恒定角度的斜边，不用使用 `overflow:hidden`，让你能够使用多种背景样式并且只需使用一个元素就能实现。

如果你想发表评论或者有任何技巧方式的改进，欢迎给我发[推特](https://twitter.com/kilianvalkhof)或者邮件（邮件地址请参阅原文连接，译者注）！

**1. <a name="note1"></a>感谢我的数学老师女朋友告诉我这个形状的正确名字。**（作者写技术文章也不忘撒狗粮，感觉受到了一万点伤害，译者注）