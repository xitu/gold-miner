> * 原文地址：[Slide an Image to Reveal Text with CSS Animations](https://css-tricks.com/slide-an-image-to-reveal-text-with-css-animations/)
> * 原文作者：[Jesper Ekstrom](https://css-tricks.com/author/legshaker/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/slide-an-image-to-reveal-text-with-css-animations.md](https://github.com/xitu/gold-miner/blob/master/TODO1/slide-an-image-to-reveal-text-with-css-animations.md)
> * 译者：
> * 校对者：

# Slide an Image to Reveal Text with CSS Animations

I want to take a closer look at the [CSS animation property](https://css-tricks.com/almanac/properties/a/animation/) and walk through an effect that I used on my own [portfolio website](https://jesperekstrom.com/portfolio/malteser/): making text appear from behind a moving object. Here’s an [isolated example](https://codepen.io/jesper-ekstrom/pen/GPjGzy) if you’d like to see the final product.

Here’s what we're going to work with:

See the Pen [Revealing Text Animation Part 4 - Responsive](https://codepen.io/jesper-ekstrom/pen/GPjGzy/) by Jesper Ekstrom ([@jesper-ekstrom](https://codepen.io/jesper-ekstrom)) on [CodePen](https://codepen.io).

Even if you’re not all that interested in the effect itself, this will be an excellent exercise to expand your CSS knowledge and begin creating unique animations of your own. In my case, digging deep into animation helped me grow more confident in my CSS abilities and increased my creativity, which got me more interested in front-end development as a whole.

Ready? Set. Let’s go!

### Step 1: Markup the main elements

Before we start with the animations, let's create a parent container that covers the full viewport. Inside it, we're adding the text and the image, each in a separate div so it’s easier to customize them later on. The HMTL markup will look like this:

```
<!-- The parent container -->
<div class="container"> 
  <!-- The div containing the image -->
  <div class="image-container">
  <img src="https://jesperekstrom.com/wp-content/uploads/2018/11/Wordpress-folder-purple.png" alt="wordpress-folder-icon">
  </div>
  <!-- The div containing the text that's revealed -->
  <div class="text-container">
    <h1>Animation</h1>
  </div>
</div>
```

We are going to use this trusty [transform trick](https://css-tricks.com/centering-percentage-widthheight-elements/) to make the divs center both vertically and horizontally with a `position: absolute;` inside our parent container, and since we want the image to display in front of the text, we're adding a higher `z-index` value to it.

```
/* The parent container taking up the full viewport */
.container {
  width: 100%;
  height: 100vh;
  display: block;
  position: relative;
  overflow: hidden;
}

/* The div that contains the image  */
/* Centering trick: https://css-tricks.com/centering-percentage-widthheight-elements/ */
.image-container {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  z-index: 2; /* Makes sure this is on top */
}

/* The image inside the first div */
.image-container img {
  -webkit-filter: drop-shadow(-4px 5px 5px rgba(0,0,0,0.6));
  filter: drop-shadow(-4px 5px 5px rgba(0,0,0,0.6));
  height: 200px;
}

/* The div that holds the text that will be revealed */
/* Same centering trick */
.text-container {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%,-50%);
  z-index: 1; /* Places this below the image container */
  margin-left: -100px;
}
```

> We're leaving vendor prefixes out the code examples throughout this post, but they should definitely be considered if using this in production environment.

Here’s what that gives us so far, which is basically our two elements stacked one on top of the other.

See the Pen [Revealing Text Animation Part 1 - Mail Elements](https://codepen.io/jesper-ekstrom/pen/zMgjwj/) by Jesper Ekstrom ([@jesper-ekstrom](https://codepen.io/jesper-ekstrom)) on [CodePen](https://codepen.io).

### Step 2: Hide the text behind a block

To make our text start displaying from left to right, we need to add another div inside our `.text-container`:

```
<!-- ... -->

  <!-- The div containing the text that's revealed -->
  <div class="text-container">
    <h1>Animation</h1>
    <div class="fading-effect"></div>
  </div>
  
<!-- ... -->
```

...and add these CSS properties and values to it:

```
.fading-effect {
  position: absolute;
  top: 0;
  bottom: 0;
  right: 0;
  width: 100%;
  background: white;
}
```

As you can see, the text is hiding behind this block now, which has a white background color to blend in with our parent container.

If we try changing the width of the block, the text starts to appear. Go ahead and try playing with it in the Pen:

See the Pen [Revealing Text Animation Part 2 - Hiding Block](https://codepen.io/jesper-ekstrom/pen/JwRZaG/) by Jesper Ekstrom ([@jesper-ekstrom](https://codepen.io/jesper-ekstrom)) on [CodePen](https://codepen.io).

> There is another way of making this effect without adding an extra block with a background over it. I will cover that method later in the article. 🙂

### Step 3: Define the animation keyframes

We are now ready for the fun stuff! To start animating our objects, we're going to make use of the [animation property](https://css-tricks.com/almanac/properties/a/animation/) and its `@keyframes` function. Let’s start by creating two different `@keyframes`, one for the image and one for the text, which will end up looking like this:

```
/* Slides the image from left (-250px) to right (150px) */
@keyframes image-slide {
  0% { transform: translateX(-250px) scale(0); }
  60% { transform: translateX(-250px) scale(1); }
  90% { transform: translateX(150px) scale(1); }
  100% { transform: translateX(150px) scale(1); }  
}

/* Slides the text by shrinking the width of the object from full (100%) to nada (0%) */
@keyframes text-slide {
  0% { width: 100%; }
  60% { width: 100%; }
  75%{ width: 0; }
  100% { width: 0; }
}
```

> I prefer to add all `@keyframes` on the top of my CSS file for a better file structure, but it’s just a preference.

The reason why the `@keyframes` only use a small portion of their percent value (mostly from 60-100%) is that I have chosen to animate both objects over the same duration instead of adding an [`animation-delay`](https://developer.mozilla.org/en-US/docs/Web/CSS/animation-delay) to the class it’s applied to. That’s just my preference. If you choose to do the same, keep in mind to always have a value set for 0% and 100%; otherwise the animation can start looping backward or other weird interactions will pop up.

To enable the `@keyframes` to our classes, we’ll call the animation name on the CSS property `animation`. So, for example, adding the `image-slide` animation to the image element, we’d do this:

```
.image-container img {
  /* [animation name] [animation duration] [animation transition function] */
  animation: image-slide 4s cubic-bezier(.5,.5,0,1);
}
```

> The name of the `@keyframes` works the same as creating a class. In other words the name doesn’t really matter as long as it’s called the same on the element where it’s applied.

If that `cubic-bezier` part causes head scratching, then check out [this post by Michelle Barker](https://css-tricks.com/reversing-an-easing-curve/). She covers the topic in depth. For the purposes of this demo, though, it’s suffice to say that it is a way to create a custom animation curve for how the object moves from start to finish. The site [cubic-bezier.com](http://cubic-bezier.com/#.5,.5,0,1) is a great place to generate those values without all the guesswork.

We talked a bit about wanting to avoid a looping animation. We can force the object to stay put once the animation reaches 100% with the `animation-fill-mode` sub-property:

```
.image-container img {
  animation: image-slide 4s cubic-bezier(.5,.5,0,1);
  animation-fill-mode: forwards;
}
```

So far, so good!

See the Pen [Revealing Text Animation Part 3 - @keyframes](https://codepen.io/jesper-ekstrom/pen/WYqRLx/) by Jesper Ekstrom ([@jesper-ekstrom](https://codepen.io/jesper-ekstrom)) on [CodePen](https://codepen.io).

### Step 4: Code for responsiveness

Since the animations are based on fixed (pixels) sizing, playing the viewport width will cause the elements to shift out of place, which is a bad thing when we’re trying to hide and reveal elements based on their location. We could create multiple animations on different media queries to handle it (that’s what I did at first), but it’s no fun managing several animations at once. Instead, we can use the same animation and change its properties at specific breakpoints.

For example:

```
@keyframes image-slide {
  0% { transform: translatex(-250px) scale(0); }
  60% { transform: translatex(-250px) scale(1); }
  90% { transform: translatex(150px) scale(1); }
  100% { transform: translatex(150px) scale(1); }
}

/* Changes animation values for viewports up to 1000px wide */
@media screen and (max-width: 1000px) {
  @keyframes image-slide {
    0% { transform: translatex(-150px) scale(0); }
    60% { transform: translatex(-150px) scale(1); }
    90% { transform: translatex(120px) scale(1); }
    100% { transform: translatex(120px) scale(1); }
  }
}
```

Here we are, all responsive!

See the Pen [Revealing Text Animation Part 4 - Responsive](https://codepen.io/jesper-ekstrom/pen/GPjGzy/) by Jesper Ekstrom ([@jesper-ekstrom](https://codepen.io/jesper-ekstrom)) on [CodePen](https://codepen.io).

### Alternative method: Text animation without colored background

I promised earlier that I’d show a different method for the fade effect, so let’s touch on that.

Instead of using creating a whole new div — `<div class="fading-effect">` — we can use a little color trickery to clip the text and blend it into the background:

```
.text-container {
  background: black;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
```

This makes the text transparent which allows the background color behind it to bleed in and effectively hide it. And, since this is a background, we can change the background width and see how the text gets cut by the width it’s given. This also makes it possible to add linear gradient colors to the text or even a background image display inside it.

The reason I didn't go this route in the demo is because it isn't compatible with Internet Explorer (note those `-webkit` vendor prefixes). The method we covered in the actual demo makes it possible to switch out the text for another image or any other object.

* * *

Pretty neat little animation, right? It’s relatively subtle and acts as a nice enhancement to UI elements. For example, I could see it used to reveal explanatory text or even photo captions. Or, a little JavaScript could be used to fire the animation on click or scroll position to make things a little more interactive.

Have questions about how any of it works? See something that could make it better? Let me know in the comments!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
