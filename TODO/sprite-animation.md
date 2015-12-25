> * 原文链接 : [Top 5 Android libraries every Android developer should know about - v. 2015](https://infinum.co/the-capsized-eight/articles/top-five-android-libraries-every-android-developer-should-know-about-v2015)
* 原文作者 : [ eighthday](http://codepen.io/eighthday/pen/dYNJyR)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

#### We always strive to add an element of movement to our websites. Carefully considered fluid animation can elevate a site above the humdrum landscape of templated website design.

The technique for sprite animation is not new, the Victorians taught us how to do it with their zoetrope's, and 8-bit video game designers showed us how to do it in the digital age. At its heart, all we are doing is moving sequentially through a series of images.

![Sprite walk cycle animation ](http://eighthdaydesign.com/resources/images/1-10-2015/80-299.Paul_walk_2560_2.gif) ![Sprite walk cycle animation ](http://eighthdaydesign.com/resources/work/1-10-2015/2-2-299.Paul_walk_mob_2.gif)

## The making of a spritesheet

It does not matter how you get there, what you need is a one image made up of a number of equally sized frames (sprites). Spritesheets can be made in any application that is capable of outputting to PNG or SVG.

SVGs have the advantage of looking pin sharp on high-resolution screens, but struggle with textures, gradients and complex illustrations. We can often achieve surprisingly small file sizes aided by apps like [SVGCleaner](http://sourceforge.net/projects/svgcleaner/) and [SVGOMG](https://jakearchibald.github.io/svgomg/). PNG is a native export option of heavyweight animation apps: Flash & After Effects, allowing us to create fluid animation in environments built to do just that.

The goal is always to create retina ready animations. We have had limited success exporting from After Effects as a series of PSDs and then batch live tracing in Illustrator (via Bridge) to convert to SVG. You can also double size PNGs and scale with JavaScript, both workflows are far from perfect.

#### Bringing it to life

To achieve a basic looping animation, we assign a background image to a html element and then use JavaScript to adjust its background position over time. You can do something similar with CSS3 steps() but for complete control and better cross compatibility, JavaScript libraries like Greensocks GSAP are hard to beat.

<iframe height="268" scrolling="no" src="//codepen.io/eighthday/embed/dYNJyR/?height=268&amp;theme-id=0&amp;default-tab=result" frameborder="no" allowtransparency="true" allowfullscreen="true" style="width: 100%;">See the Pen <a href="http://codepen.io/eighthday/pen/dYNJyR/">Responsive SVG walk cycle with GSAP</a> by eighthday (<a href="http://codepen.io/eighthday">@eighthday</a>) on <a href="http://codepen.io">CodePen</a>.</iframe>

## Bringing it to life

To achieve a basic looping animation, we assign a background image to a html element and then use JavaScript to adjust its background position over time.

You can do something similar with CSS3 steps() but for complete control and better cross compatibility, JavaScript libraries like [GSAP](http://greensock.com/gsap) coupled with [Jquery](https://jquery.com/) are hard to beat.


See the Pen [dYNJyR](http://codepen.io/eighthday/pen/dYNJyR/) by eighthday ([@eighthday](http://codepen.io/eighthday)) on [CodePen](http://codepen.io).

## HTML & CSS

All we are doing here is assigning a background to an HTML element and fixing the height & width so we only see one sprite at a time.

If you are using more than one animation you can combine spritesheets to reduce HTTP requests.



    #mySpritesheet {
      background: url('my.svg');
      width: 100px;
      height: 100px;
    }


## JavaScript

TimelineMax provides a succinct way of defining how we update the background position and gives us excellent control over our animation. This becomes very valuable as complexity increases.

You can control multiple animations within one Timeline, making it possible to sync a series of spritesheets.

First we define the parameters of the animation

    var svg = $("#mySpritesheet")
    var totalFrames = 22;
    var frameWidth = 162
    var speed = 0.9;

And work out how far we want to scroll the background

    var finalPosition = '-' + (frameWidth * totalFrames) + 'px 0px';

Then create new TimelineMax & SteppedEase instances to define how many steps our timeline will take

    var svgTL = new TimelineMax() 
    var svgEase = new SteppedEase(totalFrames)

Finally we put it all together in a tween

    svgTL.to(svg, speed, {
        backgroundPosition: finalPosition,
        ease: svgEase,
        repeat: -1,
    })

## Taking control

At this stage you might be thinking the end result is not too dissimilar to an animated GIF (and the world does need more animated GIFs). The difference is we can take complete control of our animation; we can pause, reverse, loop sections, even temporarily swap it out with another sprite to create complex movements tied to user interactions.
