> * 原文地址：[Transition Effect with CSS Masks](http://tympanus.net/codrops/2016/09/29/transition-effect-with-css-masks/)
* 原文作者：[Robin Delaporte](http://tympanus.net/codrops/author/robin/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Transition Effect with CSS Masks

A tutorial on how to use CSS Masks to create some interesting looking slide transitions. Highly experimental!

![](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/CSSMaskTransition_800x600.jpg)


[View demo](http://tympanus.net/Tutorials/CSSMaskTransition/) [Download source](http://tympanus.net/Tutorials/CSSMaskTransition/CSSMaskTransition.zip)

Today we’d like to show you how to create an intriguingly simple, yet eye-catching transition effect using [CSS Masks](http://tympanus.net/codrops/css_reference/mask/). Together with clipping, masking is another way of defining visibility and composite with an element. In the following tutorial we’ll show you how to apply the new properties for a modern transition effect on a simple slideshow. We’ll be applying animations utilizing the steps() timing function and move a mask PNG over an image to achieve an interesting transition effect.

**Attention:** Please keep in mind that this effect is **highly experimental** and only supported by some modern browsers (Chrome, Safari and Opera for now).

![](http://7xl8me.com1.z0.glb.clouddn.com/CSS%20Masks.png)

Keep in mind that Firefox has only partial support (it only supports inline SVG mask elements) so we’ll have a fallback for now. Hopefully, we can welcome support in all modern browsers very soon. Note that we’re adding [Modernizr](https://modernizr.com/download?cssmask-setclasses&q=css%20mask) to check for support.

**So let’s get started!**

## Creating the Mask Image

_In this tutorial we’ll be going through the first example (demo 1)._

For the mask transition effect to work, we will need an image that we’ll use to hide/show certain parts of our underlying image. That mask image will be a PNG with transparent parts on it. The PNG itself will be a sprite image and it looks as follows:

![CSS Mask transition](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/sprite-example.jpg)

While the black parts will show the current image, the white part (which is actually transparent) will be the masked part of our image that will reveal the second image.

In order to create the sprite image we will use this [video](https://youtu.be/Tb7-pCetjG8). We import it into Adobe After Effects to reduce the timing of the video, remove the white part and export it as a PNG sequence.

To reduce the duration to 1.4 seconds (the time we want our transition to take) we’ll use the **[Time stretch](https://helpx.adobe.com/after-effects/using/time-stretching-time-remapping.html)** effect.

![CSS Mask transition](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/time-300x230.jpg)

To remove the white part we will use **Keying -> extract** and set the white point to 0\. In the screenshot below, the blue portion is the background of our composition, the transparent parts of the video.

![CSS Mask transition](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/key.jpg)

Finally, we can save our composition as a PNG sequence and then use Photoshop or a tool like this [CSS sprite generator](http://spritegen.website-performance.org/) to generate a single image:

![CSS Mask transition](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/sprite-example.jpg)

This is one sprite image for a very organic looking reveal effect. We’ll create another, “inversed” sprite for the opposite kind of effect. You’ll find all the different sprites in the _img_ folder of the demo files.

Now, that we’ve created the mask image, let’s dive into the HTML structure for our simple example slideshow.

## The Markup

For our demo, we’ll create a simple slideshow to show the mask effect. Our slideshow will fill the entire screen and we’ll add some arrows that will trigger the slide transitions. The idea is to superpose the slides and then change the z-index of the incoming slide when the animation is over. The structure for our slideshow looks as follows:

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

The division page-view is our global container, it will contain all our slides. The project divisions are the slides of our slideshow; each one contains a title and a legend. Additionally, we’ll set an individual background image for each slide.

The arrows will serve as our trigger for the next or previous animation, and to navigate through the slides.

Let’s have a look at the style.



![](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/themes/codropstheme03/images/advertisement.jpg)



## The CSS

In this part we’ll define the CSS for our effect.

We’ll set up the layout for a classic fullscreen slider, with some centered titles and the navigation at the bottom left of the page. Moreover, we’ll define some media queries to adapt the style for mobile devices.

Furthermore, we’ll set our sprite images as invisible backgrounds on our global container just so that we have them start loading when we open the page.

    .demo-1 {
    	background: url(../img/nature-sprite.png) no-repeat -9999px -9999px;
    	background-size: 0;
    }

    .demo-1 .page-view {
    	background: url(../img/nature-sprite-2.png) no-repeat -9999px -9999px;
    	background-size: 0;
    }

Each slide will have a different background-image:

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

This would of course be something that you’ll dynamically implement but we are interested in the effect, so let’s keep it simple.

We define a class named **hide** that we will add to the slide whenever we want to hide it. The class definition contains our sprite applied as a mask.

Knowing that a frame is 100% of the screen and our animation contains 23 images, we will need to set the width to 23 * 100% = 2300%.

Now we add our CSS animation utilizing **steps**. We want our sprite to stop at the beginning of our last frame. Hence, to achieve this, we need to count one less step than the total, which is 22 steps:

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

Finally, we define the animation keyframes:

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

And here we go; we now have a structured and styled slideshow. Let’s turn it into something functional!

![CSS Mask transition](http://codropspz.tympanus.netdna-cdn.com/codrops/wp-content/uploads/2016/09/main.jpg)

## The JavaScript

We will be using [zepto.js](http://zeptojs.com/) for this demo which is a very lightweight JavaScript framework similar to jQuery.

We start by declaring all our variables, setting the durations and the elements.

Then we initialize the events, get the current and the next slide, set the correct z-index.

    function Slider() {
    	// Durations
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
    	// Misc stuff
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
     * Set initial z-indexes & get current project
     */
    Slider.prototype.init = function () {
    	this.dom.project.css('z-index', 10);
    	this.dom.current = $(this.dom.project[this.current]);
    	this.dom.next = $(this.dom.project[this.current + 1]);
    	this.dom.current.css('z-index', 30);
    	this.dom.next.css('z-index', 20);
    };

We listen for the click event on the arrows, and if the slideshow is not currently involved in an animation, we check if the click was on the next or previous arrow. Like that we adapt the value of the “next” variable and we proceed to change the slide.

    /**
     * Initialize events
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
     * Update next global index
     */
    Slider.prototype.updateNext = function () {
    	this.next = (this.current + 1) % this.length;
    	this.process();
    };
    /**
     * Update next global index
     */
    Slider.prototype.updatePrevious = function () {
    	this.next--;
    	if (this.next < 0)
    		this.next = this.length - 1;
    	this.process();
    };

This function is the heart of our slideshow: we set the class **“hide”** to the current slide and once the animation is over, we reduce the z-index of the previous slide, increase the one of the current slide and then remove the **hide** class of the previous slide.

    /**
     * Process, calculate and switch between slides
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

Adding the respective classes will trigger our animations which in turn apply the mask image to our slides. The main idea is to move the mask in a step animation function in order to create transition flow.

**And that’s it! I hope you find this tutorial useful and have fun creating your own cool mask effects! Don’t hesitate to share your creations, I would love to see them!**

**Browser Support:**

*   ChromeSupported
*   FirefoxNot supported
*   Internet ExplorerNot supported
*   SafariSupported
*   OperaSupported

## References and Credits

[View demo](http://tympanus.net/Tutorials/CSSMaskTransition/) [Download source](http://tympanus.net/Tutorials/CSSMaskTransition/CSSMaskTransition.zip)



