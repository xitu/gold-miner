> * 原文地址：[Transition Effect with CSS Masks](http://tympanus.net/codrops/2016/09/29/transition-effect-with-css-masks/)
* 原文作者：[Robin Delaporte](http://tympanus.net/codrops/author/robin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[luoyaqifei](http://www.zengmingxia.com)
* 校对者：[Graning](https://github.com/Graning), [hyuni](http://hyuni.cn/)

# CSS 遮罩的过渡效果

一份关于如何使用 CSS 遮罩来创建一些有趣的视觉滑动过渡的教程。这份教程具有高度试验性！

![](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/CSSMaskTransition_800x600.jpg)


[查看演示](http://tympanus.net/Tutorials/CSSMaskTransition/) [下载源码](http://tympanus.net/Tutorials/CSSMaskTransition/CSSMaskTransition.zip)

今天我们想向你展示怎样创建一个有趣简单并且吸引眼球的过渡效果，采用的是 [CSS 遮罩](http://tympanus.net/codrops/css_reference/mask/) 。 与剪裁一样，遮罩是另一种定义可见性和与一个元素组合的方式。在接下来的教程中我们将展示给你的是：如何将一种现代过渡效果的新属性应用在简单的幻灯片上。我们使用 steps() 时间函数来应用动画，并将一张遮罩 PNG 移动到一张图片上方，来达到有趣的过渡效果。

**注意：**请记住，这种效果是**具有高度试验性**的，只能被某些现代浏览器支持。

![](http://7xl8me.com1.z0.glb.clouddn.com/CSS%20Masks.png)

记住 Firefox 只部分支持（它只支持行内 SVG 遮罩元素），因此我们现在需要有一个回退机制，很快我们就可以迎接所有现有浏览器的支持。注意我们加入 [Modernizr](https://modernizr.com/download?cssmask-setclasses&q=css%20mask) 来检查是否支持。

**所以让我们开始吧！**


## 创建遮罩图

_ 我们将走进本教程的第一个例子（演示1）。_

为了让遮罩过渡效果可行，我们需要一张用来隐藏／显示底层图片某些部分的图片。该遮罩图会是一张带有透明部分的 PNG 。该 PNG 自身是一张雪碧图，看上去像下图这样：

![CSS 遮罩过渡](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/sprite-example.jpg)

黑色部分显示的是当前图，同时，白色部分（其实是透明的）就是图片中被遮住的部分，它露出了第二张图。

为了创建雪碧图，我们需要用到这个 [视频](https://youtu.be/Tb7-pCetjG8) 。我们将它导入 Adobe After Effects 内来减短视频时间，移除白色部分并作为 PNG 序列导出。

为了将时长减短至 1.4 秒（即我们想要过渡发生的时间），我们将采用 **[Time stretch](https://helpx.adobe.com/after-effects/using/time-stretching-time-remapping.html)** 效果。

![CSS 遮罩过渡](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/time-300x230.jpg)

为了移除白色部分，我们将采用 **Keying -> extract** 并将白点设为 0。在以下的截图里，蓝色部分是我们的组合背景，视频的透明部分。

![CSS 遮罩过渡](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/key.jpg)

最终，我们可以将我们的组合用 PNG 序列保存，然后使用 Photoshop 或者类似于 [CSS 雪碧图生成器](http://spritegen.website-performance.org/) 这样的工具来生成单张图片。

![CSS 遮罩过渡](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/sprite-example.jpg)

这是一张为了达到有机外观（译者注：指一种贴近大自然的外观）揭露效果生成的雪碧图。我们将创建另一个『翻转的』雪碧图，用来达到相反的效果。你可以在 _img_  这个存放演示文件的文件夹下找到所有不同的雪碧图。

既然我们已经创建好了遮罩图，现在让我们挖掘一下我们简单的幻灯片例子中的 HTML 结构。

## 标记

为了我们的演示，我们将创建一个简单的幻灯片来展示遮罩效果。我们的幻灯片将会充斥整个屏幕，并且我们会添加几个能够触发幻灯页过渡的箭头。这个想法是用来将幻灯片重叠，然后在动画结束的时候，改变接下来的幻灯页的 z-index 。我们的幻灯片结构如下所示：

```
<div class="page-view">
	<div class="project">
		<div class="text">
			<h1>“All good things are <br> wild & free”</h1>
			<p>Photo by Andreas Rønningen</p>
		</div>
	</div>
	<div class="project">
		<div class="text">
			<h1>“Into the wild”</h1>
			<p>Photo by John Price</p>
		</div>
	</div>
	<div class="project">
		<div class="text">
			<h1>“Is spring coming?”</h1>
			<p>Photo by Thomas Lefebvre</p>
		</div>
	</div>
	<div class="project">
		<div class="text">
			<h1>“Stay curious”</h1>
			<p>Photo by Maria</p>
		</div>
	</div>
	<nav class="arrows">
		<div class="arrow previous">
			<svg viewBox="208.3 352 4.2 6.4">
				<polygon class="st0" points="212.1,357.3 211.5,358 208.7,355.1 211.5,352.3 212.1,353 209.9,355.1"/>
			</svg>
		</div>
		<div class="arrow next">
			<svg viewBox="208.3 352 4.2 6.4">
				<polygon class="st0" points="212.1,357.3 211.5,358 208.7,355.1 211.5,352.3 212.1,353 209.9,355.1"/>
			</svg>
		</div>
	</nav>
</div>
```

这个 div 页面视图是我们的主容器，它将包含我们所有的幻灯页。这个项目内部的 div 是我们幻灯片中的幻灯页，每一张包含了一个标题和一个题注。并且，我们将为每张幻灯页设置一个单独的背景图。

箭头用来触发后一个或前一个动画，以及在幻灯页里跳转。

让我们看看这种风格。



![](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/themes/codropstheme03/images/advertisement.jpg)



## CSS

在这部分，我们将为我们的效果设定 CSS 。

我们将创建一个典型的全屏幻灯片布局，里面包括一些居中标题和页面左下角的跳转链接。并且，我们会定义一些媒体查询来使移动设备兼容这种风格。

除此之外，我们还会将我们的雪碧图设置成在我们的全局容器上不可见的背景，只有这样才能让它们在页面刚被打开的时候就能加载。

    .demo-1 {
    	background: url(../img/nature-sprite.png) no-repeat -9999px -9999px;
    	background-size: 0;
    }

    .demo-1 .page-view {
    	background: url(../img/nature-sprite-2.png) no-repeat -9999px -9999px;
    	background-size: 0;
    }

每张幻灯页将会有一个不同的背景图：

    .demo-1 .page-view .project:nth-child(1) {
    	background-image: url(../img/nature-1.jpg);
    }

    .demo-1 .page-view .project:nth-child(2) {
    	background-image: url(../img/nature-2.jpg);
    }

    .demo-1 .page-view .project:nth-child(3) {
    	background-image: url(../img/nature-3.jpg);
    }

    .demo-1 .page-view .project:nth-child(4) {
    	background-image: url(../img/nature-4.jpg);
    }

这不同的背景图当然会是你们动态实现的，但是在本教程中，我们的兴趣点在于效果，所以就让它简单一点。

我们定义了一个叫做 **hide** 的类，无论何时我们想隐藏一张幻灯页，我们就将这个类加在幻灯页上。这个类的定义中包括了我们用作遮罩的雪碧图。

已知一帧占据了屏幕的 100% 且我们的动画包含 23 张图，我们需要将宽度设置成 23 * 100% = 2300%。

现在我们要使用 **steps** 来添加我们的 CSS 动画。我们想要我们的雪碧图在最后一帧的开头停住。因此，为了达到这个目的，我们需要数到 22 步，比总数少了一步。

    .demo-1 .page-view .project:nth-child(even).hide {
    	-webkit-mask: url(../img/nature-sprite.png);
    	mask: url(../img/nature-sprite.png);
    	-webkit-mask-size: 2300% 100%;
    	mask-size: 2300% 100%;
    	-webkit-animation: mask-play 1.4s steps(22) forwards;
    	animation: mask-play 1.4s steps(22) forwards;
    }

    .demo-1 .page-view .project:nth-child(odd).hide {
    	-webkit-mask: url(../img/nature-sprite-2.png);
    	mask: url(../img/nature-sprite-2.png);
    	-webkit-mask-size: 7100% 100%;
    	mask-size: 7100% 100%;
    	-webkit-animation: mask-play 1.4s steps(70) forwards;
    	animation: mask-play 1.4s steps(70) forwards;
    }

最后，我们定义动画的关键帧：

    @-webkit-keyframes mask-play {
      from {
    	-webkit-mask-position: 0% 0;
    	mask-position: 0% 0;
      }
      to {
    	-webkit-mask-position: 100% 0;
    	mask-position: 100% 0;
      }
    }

    @keyframes mask-play {
      from {
    	-webkit-mask-position: 0% 0;
    	mask-position: 0% 0;
      }
      to {
    	-webkit-mask-position: 100% 0;
    	mask-position: 100% 0;
      }
    }

现在我们已经走到这儿啦，我们有了一个结构化、风格化的幻灯片。让我们往上面添加功能！

![CSS 遮罩过渡](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/main.jpg)

## JavaScript

我们将使用 [zepto.js](http://zeptojs.com/) 来进行演示，这是一个类似于 jQuery 的轻量级 JavaScript 框架。

我们从声明所有的变量、设置长度和元素开始。

然后我们初始化事件，得到当前和后一张幻灯页，设置正确的 z-index。

    function Slider() {
    	// 长度
    	this.durations = {
    		auto: 5000,
    		slide: 1400
    	};
    	// DOM
    	this.dom = {
    		wrapper: null,
    		container: null,
    		project: null,
    		current: null,
    		next: null,
    		arrow: null
    	};
    	// 杂七杂八的代码
    	this.length = 0;
    	this.current = 0;
    	this.next = 0;
    	this.isAuto = true;
    	this.working = false;
    	this.dom.wrapper = $('.page-view');
    	this.dom.project = this.dom.wrapper.find('.project');
    	this.dom.arrow = this.dom.wrapper.find('.arrow');
    	this.length = this.dom.project.length;
    	this.init();
    	this.events();
    	this.auto = setInterval(this.updateNext.bind(this), this.durations.auto);
    }
    /**
     * 设置初始的 z-indexes & 得到当前项目
     */
    Slider.prototype.init = function () {
    	this.dom.project.css('z-index', 10);
    	this.dom.current = $(this.dom.project[this.current]);
    	this.dom.next = $(this.dom.project[this.current + 1]);
    	this.dom.current.css('z-index', 30);
    	this.dom.next.css('z-index', 20);
    };

我们监听箭头上的点击事件，如果幻灯片目前没有动画的话，我们检查点击是否发生在后一个或者前一个箭头上。像这样，我们接受 next 这个变量的值，处理它并更换幻灯页。

    /**
     * 初始化事件
     */
    Slider.prototype.events = function () {
    	var self = this;
    	this.dom.arrow.on('click', function () {
    		if (self.working)
    			return;
    		self.processBtn($(this));
    	});
    };
    Slider.prototype.processBtn = function (btn) {
    	if (this.isAuto) {
    		this.isAuto = false;
    		clearInterval(this.auto);
    	}
    	if (btn.hasClass('next'))
    		this.updateNext();
    	if (btn.hasClass('previous'))
    		this.updatePrevious();
    };
    /**
     * 更新后一个全局 index
     */
    Slider.prototype.updateNext = function () {
    	this.next = (this.current + 1) % this.length;
    	this.process();
    };
    /**
     * 更新前一个全局 index
     */
    Slider.prototype.updatePrevious = function () {
    	this.next--;
    	if (this.next < 0)
    		this.next = this.length - 1;
    	this.process();
    };

这个函数是我们幻灯片的心脏所在：我们对当前幻灯页设置 **“hide”** 类，一旦动画结束，我们减小前一页的 z-index ，增加当前页的 z-index ，然后移除前一页的 **“hide”** 类。

    /**
     * 处理，计算并在幻灯页之间切换
     */
    Slider.prototype.process = function () {
    	var self = this;
    	this.working = true;
    	this.dom.next = $(this.dom.project[this.next]);
    	this.dom.current.css('z-index', 30);
    	self.dom.next.css('z-index', 20);
    	// Hide current
    	this.dom.current.addClass('hide');
    	setTimeout(function () {
    		self.dom.current.css('z-index', 10);
    		self.dom.next.css('z-index', 30);
    		self.dom.current.removeClass('hide');
    		self.dom.current = self.dom.next;
    		self.current = self.next;
    		self.working = false;
    	}, this.durations.slide);
    };

加入相应的类会触发我们的动画，这些动画轮流将遮罩图片应用到我们的幻灯页上。主要的思想是用步伐动画函数来移动遮罩，从而创建过渡流。

**这就是本文所有内容了！我希望你们能够觉得本教程有用，并且在你们自己创建很酷的遮罩效果时享受它！不要犹豫，分享你们的创造，我会很高兴看到的！**

**浏览器支持：**

*   Chrome 支持
*   Firefox 不支持
*   Internet Explorer 不支持
*   Safari 支持
*   Opera 支持

## 参考和信用

[查看演示](http://tympanus.net/Tutorials/CSSMaskTransition/) [下载源码](http://tympanus.net/Tutorials/CSSMaskTransition/CSSMaskTransition.zip)
