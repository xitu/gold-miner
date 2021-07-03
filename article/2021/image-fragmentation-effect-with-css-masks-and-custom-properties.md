> * 原文地址：[Image Fragmentation Effect With CSS Masks and Custom Properties](https://css-tricks.com/image-fragmentation-effect-with-css-masks-and-custom-properties/)
> * 原文作者：[Temani Afif](https://css-tricks.com/author/afiftemani/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/image-fragmentation-effect-with-css-masks-and-custom-properties.md](https://github.com/xitu/gold-miner/blob/master/article/2021/image-fragmentation-effect-with-css-masks-and-custom-properties.md)
> * 译者：
> * 校对者：

# Image Fragmentation Effect With CSS Masks and Custom Properties

Geoff shared this idea of a [checkerboard where the tiles disappear](https://css-tricks.com/checkerboard-reveal/) one-by-one to reveal an image. In it, an element has a background image, then a CSS Grid layout holds the “tiles” that go from a filled background color to transparent, revealing the image. A light touch of SCSS staggers the animation.

I have a similar idea, but with a different approach. Instead of revealing the image, let’s start with it fully revealed, then let it disappear one tile at a time, as if it’s floating away in tiny fragments.

Here’s a working demo of the result. No JavaScript handling, no SVG trickery. Only a single `<img>` and some SCSS magic.

[Codepen t_afif/WNoWBmp](https://codepen.io/t_afif/pen/WNoWBmp)

Cool, right? Sure, but here’s the rub. You’re going to have to view this in Chrome, Edge or Opera because those are the only browsers with support for `@property` at the moment and that’s a key component to this idea. We won’t let that stop us because this is a great opportunity to get our hands wet with cool CSS features, like masks and animating linear gradients with the help of `@property`.

## Masking things

Masking is sometimes hard to conceptualize and often gets confused with clipping. The bottom line: **masks are images.** When an image is applied as mask to an element, any transparent parts of the image allow us see right through the element. Any opaque parts will make the element fully visible.

Masks work the same way as opacity, but on different portions of the same element. That’s different from clipping, which is a path where everything outside the path is simply hidden. The advantages of masking is that we can have as many mask layers as we want on the same element — similar to how we can chain multiple images on `background-image`.

And since masks are images, we get to use CSS gradients to make them. Let’s take an easy example to better understand the trick.

```css
img {
  mask:
    linear-gradient(rgba(0,0,0,0.8) 0 0) left,  /* 1 */
    linear-gradient(rgba(0,0,0,0.5) 0 0) right; /* 2 */
  mask-size: 50% 100%;
  mask-repeat: no-repeat;
}
```

Here, we’re defining two mask layers on an image. They are both a solid color but the alpha transparency values are different. The above syntax may look strange but it’s a simplified way of writing `linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.8))`.

It’s worth noting that the color we use is irrelevant since the default `mask-mode` is `alpha`. The alpha value is the only relevant thing. Our gradient can be `linear-gradient(rgba(X,Y,Z,0.8) 0 0)` where `X`, `Y` and `Z` are random values.

Each mask layer is equal to `50% 100%` (or half width and full height of the image). One mask covers the left and the other covers the right. At the end, we have two **non-overlapping** masks covering the whole area of the image and, as we discussed earlier, each one has a differently defined alpha transparency value.

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/03/gjlgtv44jz5m7nta8s17.png?resize=417%2C471&ssl=1)

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/03/gjlgtv44jz5m7nta8s17.png?resize=417%2C471&ssl=1)

<small>We’re looking at two mask layers created with two linear gradients. The first gradient, left, has an alpha value of `0.8`. The second gradient, right, has an alpha value of `0.5`. The first gradient is more opaque meaning more of the image shows through. The second gradient is more transparent meaning more of the of background shows through.</small>

## Animating linear gradients

What we want to do is apply an animation to the linear gradient alpha values of our mask to create a transparency animation. Later on, we’ll make these into asynchronous animations that will create the fragmentation effect.

Animating gradients is something we’ve been unable to do in CSS. That is, until we got limited support for `@property`. Jhey Tompkins did a deep dive into [the awesome animating powers of `@property`](https://css-tricks.com/exploring-property-and-its-animating-powers/), demonstrating how it can be used to transition gradients. Again, you’ll want to view this in Chrome or another Blink-powered browser:

[Codepen jh3y/YzpKKoN](https://codepen.io/jh3y/pen/YzpKKoN)

In short, `@property` lets us create custom CSS properties where we’re able to define the syntax by specifying a type. Let’s create two properties, `--c-0` and`--c-1` , that take a number with an initial value of `1`.

```css
@property --c-0 {
   syntax: "<number>";
   initial-value: 1;
   inherits: false;
}
@property --c-1 {
   syntax: "<number>";
   initial-value: 1;
   inherits: false;
}
```

Those properties are going to represent the alpha values in our CSS mask. And since they both default to fully opaque (i.e. `1` ), the entire image shows through the mask. Here’s how we can rewrite the mask using the custom properties:

```css
/* Omitting the @property blocks above for brevity */

img {
  mask:
    linear-gradient(rgba(0,0,0,var(--c-0)) 0 0) left,  /* 1 */
    linear-gradient(rgba(0,0,0,var(--c-1)) 0 0) right; /* 2 */
  mask-size: 50% 100%;
  mask-repeat: no-repeat;
  transition: --c-0 0.5s, --c-1 0.3s 0.4s;
}

img:hover {
  --c-0:0;
  --c-1:0;
}
```

All we’re doing here is applying a different transition duration and delay for each custom variable. Go ahead and hover the image. The first gradient of the mask will fade out to an alpha value of `0` to make the image totally see through, followed but the second gradient.

[CodePen t_afif/YzpMoPz](https://codepen.io/t_afif/pen/YzpMoPz)

## More masking!

So far, we’ve only been working with two linear gradients on our mask and two custom properties. To create a tiling or fragmentation effect, we’ll need lots more tiles, and that means lots more gradients and a lot of custom properties!

SCSS makes this a fairly trivial task, so that’s what we’re turning to for writing styles from here on out. As we saw in the first example, we have a kind of matrix of tiles. We can think of those as rows and columns, so let’s define two SCSS variables, `$x` and `$y` to represent them.

### Custom properties

We’re going to need `@property` definitions for each one. No one wants to write all those out by hand, though, so let’s allow SCSS do the heavy lifting for us by running our properties through a loop:

```scss
@for $i from 0 through ($x - 1) {
  @for $j from 0 through ($y - 1) {
    @property --c-#{$i}-#{$j} {
      syntax: "<number>";
      initial-value: 1;
      inherits: false;
    }
  }
}
```

Then we make all of them go to `0` on hover:

```scss
img:hover {
  @for $i from 0 through ($x - 1) {
    @for $j from 0 through ($y - 1) {
      --c-#{$i}-#{$j}: 0;
    }
  }
}
```

### Gradients

We’re going to write a `@mixin` that generates them for us:

```scss
@mixin image() {
  $all_t: (); // Transition
  $all_m: (); // Mask
  @for $i from 0 through ($x - 1) {
    @for $j from 0 through ($y - 1) {
      $all_t: append($all_t, --c-#{$i}-#{$j} transition($i,$j), comma);
      $all_m: append($all_m, linear-gradient(rgba(0,0,0,var(--c-#{$i}-#{$j})) 0 0) calc(#{$i}*100%/(#{$x} - 1)) calc(#{$j}*100%/(#{$y} - 1)), comma);
    }
  }
  transition: $all_t;
  mask: $all_m;
}
```

All our mask layers equally-sized, so we only need one property for this, relying on the `$x` and `$y` variables and `calc()`:

```scss
mask-size: calc(100%/#{$x}) calc(100%/#{$y})
```

You may have noticed this line as well:

```scss
$all_t: append($all_t, --c-#{$i}-#{$j} transition($i,$j), comma);
```

Within the same mixing, we’re also generating the `transition` property that contains all the previously defined custom properties.

Finally, we generate a different duration/delay for each property, thanks to the `random()` function in SCSS.

```scss
@function transition($i,$j) {
  @return $s*random()+s $s*random()+s;
}
```

Now all we have to do is to adjust the `$x` and `$y` variables to control the granularity of our fragmentation.

## Playing with the animations

We can also change the random configuration to consider different kind of animations.

[CodePen t_afif/vYyMwqY](https://codepen.io/t_afif/pen/vYyMwqY)

In the code above, I defined the `transition()` function like below:

```scss
// Uncomment one to use it
@function transition($i,$j) {
  // @return (($s*($i+$j))/($x+$y))+s (($s*($i+$j))/($x+$y))+s; /* diagonal */
  // @return (($s*$i)/$x)+s (($s*$j)/$y)+s; /* left to right */
  // @return (($s*$j)/$y)+s (($s*$i)/$x)+s; /* top to bottom */
  // @return  ($s*random())+s (($s*$j)/$y)+s; /* top to bottom random */
  @return  ($s*random())+s (($s*$i)/$y)+s; /* left to right random */
  // @return  ($s*random())+s (($s*($i+$j))/($x+$y))+s; /* diagonal random */
  // @return ($s*random())+s ($s*random())+s; /* full random*/
}
```

By adjusting the formula, we can get different kinds of animation. Simply uncomment the one you want to use. This list is non-exhaustive — we can have any combination by considering more forumlas. (I’ll let you imagine what’s possible if we add advanced math functions, like `sin()`, `sqrt()`, etc.)

## Playing with the gradients

We can still play around with our code by adjusting the gradient so that, instead of animating the alpha value, we animate the color stops. Our gradient will look like this:

```scss
linear-gradient(white var(--c-#{$i}-#{$j}),transparent 0)
```

Then we animate the variable from `100%` to `0%`. And, hey, we don’t have to stick with linear gradients. Why not radial?

[CodePen t_afif/ZEBZNgo](https://codepen.io/t_afif/pen/ZEBZNgo)

Like the transition, we can define any kind of gradient we want — the combinations are infinite!

## Playing with the overlap

Let’s introduce another variable to control the overlap between our gradient masks. This variable will set the `mask-size` like this:

```scss
calc(#{$o}*100%/#{$x}) calc(#{$o}*100%/#{$y})
```

There is no overlap if it’s equal to `1`. If it’s bigger, then we do get an overlap. This allows us to make even more kinds of animations:

[CodePen t_afif/rNWbEBr](https://codepen.io/t_afif/pen/rNWbEBr)

## That’s it!

All we have to do is to find the perfect combination between variables and formulas to create astonishing and crazy image fragmentation effects.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
