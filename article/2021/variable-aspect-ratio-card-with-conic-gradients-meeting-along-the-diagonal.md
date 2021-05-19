> * 原文地址：[Variable Aspect Ratio Card With Conic Gradients Meeting Along the Diagonal](https://css-tricks.com/variable-aspect-ratio-card-with-conic-gradients-meeting-along-the-diagonal/)
> * 原文作者：[Ana Tudor](https://css-tricks.com/author/thebabydino/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/variable-aspect-ratio-card-with-conic-gradients-meeting-along-the-diagonal.md](https://github.com/xitu/gold-miner/blob/master/article/2021/variable-aspect-ratio-card-with-conic-gradients-meeting-along-the-diagonal.md)
> * 译者：
> * 校对者：

# Variable Aspect Ratio Card With Conic Gradients Meeting Along the Diagonal

I recently came across an interesting problem. I had to implement a grid of cards with a variable (user-set) aspect ratio that was stored in a `--ratio` custom property. Boxes with a certain aspect ratio are a classic problem in CSS and one that got easier to solve in recent years, especially since we got `[aspect-ratio](https://css-tricks.com/almanac/properties/a/aspect-ratio/)`, but the tricky part here was that each of the cards needed to have two conic gradients at opposite corners meeting along the diagonal. Something like this:

![A 3 by 3 grid of square cards with color backgrounds made from conic gradients. The gradients appear like stripes that extend from opposite corners of the card. Each card reads Hello Gorgeous in a fancy script font.](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/var_cards.png?resize=799%2C571&ssl=1)

<small>User set aspect ratio cards.</small>

The challenge here is that, while it’s easy to make an abrupt change in a `linear-gradient()` along the diagonal of a variable aspect ratio box using for example a direction like `to top left` which changes with the aspect ratio, a `conic-gradient()` needs either an angle or a percentage representing how far it has gone around a full circle.

> Check out [this guide](https://css-tricks.com/a-complete-guide-to-css-gradients/#h-conic-gradients) for a refresher on how conic gradients work.

### The simple solution

The spec now includes [trigonometric and inverse trigonometric functions](https://drafts.csswg.org/css-values-4/#trig-funcs), which *could* help us here — the angle of the diagonal with the vertical is the arctangent of the aspect ratio `atan(var(--ratio))` (the left and top edges of the rectangle and the diagonal form a right triangle where the tangent of the angle formed by the diagonal with the vertical is the width over the height — precisely our aspect ratio).

![Illustration. Shows a rectangle of width w and height h with a diagonal drawn from the bottom left corner to the top right one. This diagonal is the hypotenuse of the right triangle whose catheti are the left and top edges of the rectangle. In this right triangle, the tangent of the angle between the hypotenuse (diagonal of original rectangle) with the vertical (left edge of original rectangle) is the top edge (w) over the left edge (h).](https://css-tricks.com/wp-content/uploads/2021/04/ang_diag.svg)

<small>The angle of the diagonal with the vertical (edge).</small>

Putting it into code, we have:

```scss
--ratio: 3/ 2;
aspect-ratio: var(--ratio);
--angle: atan(var(--ratio));
background:
    /* below the diagonal */
    conic-gradient(from var(--angle) at 0 100%,
        #319197, #ff7a18, #af002d  calc(90deg - var(--angle)), transparent 0%),
    /* above the diagonal */
    conic-gradient(from calc(.5turn + var(--angle)) at 100% 0,
        #ff7a18, #af002d, #319197 calc(90deg - var(--angle)));
```

However, no browser currently implements trigonometric and inverse trigonometric functions, so the simple solution is just a future one and not one that would actually work anywhere today.

### The JavaScript solution

We can of course compute the `--angle` in the JavaScript from the `--ratio` value.

```javascript
let angle = Math.atan(1 / ratio.split('/').map(c => +c.trim()).reduce((a, c) => c / a, 1));
document.body.style.setProperty('--angle', `${+(180 * angle / Math.PI).toFixed(2)}deg`)
```

But what if using JavaScript won’t do? What if we really need a pure CSS solution? Well, it’s a bit hacky, but it can be done!

### The hacky CSS solution

This is an idea I got from a peculiarity of SVG gradients that I honestly found very frustrating when I [first encountered](https://css-tricks.com/state-css-reflections/#the-svg-gradient-problem).

Let’s say we have a gradient with a sharp transition at `50%` going from bottom to top since in CSS, that’s a gradient at a `0°` angle. Now let’s say we have the same gradient in SVG and we change the angle of both gradients to the same value.

In CSS, that’s:

```css
linear-gradient(45deg, var(--stop-list));
```

In SVG, we have:

```html

<linearGradient id='g' y1='100%' x2='0%' y2='0%'
                gradientTransform='rotate(45 .5 .5)'>
    <!-- the gradient stops -->
</linearGradient>
```

As it can be seen below, these two don’t give us the same result. While the CSS gradient really is at `45°`, the SVG gradient rotated by the same `45°` has that sharp transition between orange and red along the diagonal, even though our box isn’t square, so the diagonal isn’t at `45°`!

![Screenshot. Shows a rectangle with a CSS gradient at 45° (left) vs. a rectangle with a bottom to top SVG gradient rotated by 45° (right). This angle is adjustable via the slider at the bottom. The CSS gradient is really at 45°, but the line of the SVG gradient is perpendicular onto the rectangle's diagonal.](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/04/css_vs_svg_grad.png?resize=999%2C556&ssl=1)

<small>`45°` CSS vs. SVG gradient ([DEMO](https://codepen.io/thebabydino/full/pbVdPx)).</small>

This is because our SVG gradient gets drawn within a `1x1` square box, rotated by `45°`, which puts the abrupt change from orange to red along the square diagonal. Then this square is stretched to fit the rectangle, which basically changes the diagonal angle.

> Note that this SVG gradient distortion happens only if we don’t change the `gradientUnits` attribute of the `linearGradient` from its default value of `objectBoundingBox` to `userSpaceOnUse`.

#### Basic idea

We cannot use SVG here since it only has linear and radial gradients, but not conic ones. However, we can put our CSS conic gradients in a square box and use the `45°` angle to make them meet along the diagonal:

```css
aspect-ratio: 1/ 1;
width: 19em;
background: 
  /* below the diagonal */
  conic-gradient(from 45deg at 0 100%, 
      #319197, #ff7a18, #af002d 45deg, transparent 0%), 
  /* above the diagonal */
  conic-gradient(from calc(.5turn + 45deg) at 100% 0, 
      #ff7a18, #af002d, #319197 45deg);

```

Then we can stretch this square box using a scaling `transform` – the trick is that the ‘/’ in the `3/ 2` is a separator when used as an `aspect-ratio` value, but gets parsed as division inside a `calc()`:

```css
--ratio: 3/ 2;
transform: scaley(calc(1/(var(--ratio))));
```

You can play with changing the value of `--ratio` in the editable code embed below to see that, this way, the two conic gradients always meet along the diagonal: [CodePen](https://codepen.io/thebabydino/pen/QWdzOVg)

> Note that this demo will only work in a browser that [supports](https://caniuse.com/mdn-css_properties_aspect-ratio) `aspect-ratio`. This property is supported out of the box in Chrome 88+ (current version is 90), but Firefox still needs the `layout.css.aspect-ratio.enabled` flag to be set to `true` in about:config. And if you’re using Safari… well, I’m sorry!

![Screenshot showing how to enable the Firefox flag. Go to about:config (type that in the address bar - you may be asked if you're sure you want to mess with that stuff before you're allowed to enter). Use the search bar to look for 'aspect' - this should be enough to bring up the flag. Set its value to true.](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/04/flag_enable_firefox.png?resize=999%2C206&ssl=1)

<small>Enabling the flag in Firefox.</small>

#### Issues with this approach and how to get around them

Scaling the actual `.card` element would rarely be a good idea though. For my use case, the cards are on a grid and setting a directional scale on them messes up the layout (the grid cells are still square, even though we’ve scaled the `.card` elements in them). They also have text content which gets weirdly stretched by the `scaley()` function.

![Screenshot. Shows how the card elements are scaled down vertically, yet the grid cells they're occupying have remained square, just like the cards before the directional scaling.](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/04/issues_scaling_card_hlight_firefox.png?resize=999%2C367&ssl=1)

<small>The problem with scaling the actual cards ([DEMO](https://codepen.io/thebabydino/pen/BapvOvr))</small>

The solution is to give the actual cards the desired `aspect-ratio` and use an absolutely positioned `::before` placed behind the text content (using `z-index: -1`) in order to create our `background`. This pseudo-element gets the `width` of its `.card` parent and is initially square. We also set the directional scaling and conic gradients from earlier on it. Note that since our absolutely positioned `::before` is top-aligned with the top edge of its `.card` parent, we should also scale it relative to this edge as well (the `transform-origin` needs to have a value of `0` along the y axis, while the x axis value doesn’t matter and can be anything).

```scss
body {
    --ratio: 3/ 2;
    /* other layout and prettifying styles */
}

.card {
    position: relative;
    aspect-ratio: var(--ratio);

    &::before {
        position: absolute;
        z-index: -1; /* place it behind text content */

        aspect-ratio: 1/ 1; /* make card square */
        width: 100%;

        /* make it scale relative to the top edge it's aligned to */
        transform-origin: 0 0;
        /* give it desired aspect ratio with transforms */
        transform: scaley(calc(1 / (var(--ratio))));
        /* set background */
        background: /* below the diagonal */
                conic-gradient(from 45deg at 0 100%,
                        #319197, #af002d, #ff7a18 45deg, transparent 0%),
                    /* above the diagonal */
                conic-gradient(from calc(.5turn + 45deg) at 100% 0,
                        #ff7a18, #af002d, #319197 45deg);
        content: '';
    }
}
```

> Note that we’ve moved from CSS to SCSS in this example.

This is much better, as it can be seen in the embed below, which is also editable so you can play with the `--ratio` and see how everything adapts nicely as you change its value.

[CodePen](https://codepen.io/thebabydino/pen/MWJZPLe) for code and preview.

#### Padding problems

Since we haven’t set a `padding` on the card, the text may go all the way to the edge and even slightly out of bounds given it’s a bit slanted.

![Screenshot. Shows a case where the text goes all the way to the edge of the card and even goes out a tiny little bit creating an ugly result.](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/04/need_for_padding.png?resize=799%2C117&ssl=1)

<small>Lack of `padding` causing problems.</small>

That shouldn’t be too difficult to fix, right? We just add a `padding`, right? Well, when we do that, we discover the layout breaks!

![Animated gif. Shows the dev tools grid overlay t highlight that, while the background (created with the scaled pseudo) still has the desired aspect ratio, the grid cell and the actual card in it are taller.](https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/04/padding_issue.gif?resize=800%2C324&ssl=1)

<small>Adding a `padding` breaks the layout. ([DEMO](https://codepen.io/thebabydino/pen/MWJZxdV))</small>

This is because the `aspect-ratio` we’ve set on our `.card` elements is that of the `.card` box specified by `box-sizing`. Since we haven’t explicitly set any `box-sizing` value, its current value is the default one, `content-box`. Adding a `padding` of the same value around this box gives us a `padding-box` of a different aspect ratio that doesn’t coincide with that of its `::before` pseudo-element anymore.

In order to better understand this, let’s say our `aspect-ratio` is `4/ 1` and the width of the `content-box` is `16rem` (`256px`). This means the height of the `content-box` is a quarter of this width, which computes to `4rem` (`64px`). So the `content-box` is a `16rem×4rem` (`256px×64px`) rectangle.

Now let’s say we add a `padding` of `1rem` (`16px`) along every edge. The width of the `padding-box` is therefore `18rem` (`288px`, as it can be seen in the animated GIF above) — computed as the width of the `content-box`, which is `16rem` (`256px`) plus `1rem` (`16px`) on the left and `1rem` on the right from the `padding`. Similarly, the height of the `padding-box` is `6rem` (`96px`) — computed as the height of the `content-box`, which is `4rem` (`64px`), plus `1rem` (`16px`) at the top and `1rem` at the bottom from the `padding`).

This means the `padding-box` is a `18rem×6rem` (`288px×96px`) rectangle and, since `18 = 3⋅6`, it has a `3/ 1` aspect ratio which is different from the `4/ 1` value we’ve set for the `aspect-ratio` property! At the same time, the `::before` pseudo-element has a width equal to that of its parent’s `padding-box` (which we’ve computed to be `18rem` or `288px`) and its aspect ratio (set by scaling) is still `4/ 1`, so its visual height computes to `4.5rem` (`72px`). This explains why the `background` created with this pseudo — scaled down vertically to a `18rem×4.5rem` (`288px×72px`) rectangle — is now shorter than the actual card — a `18rem×6rem` (`288px×96px`) rectangle now with the `padding`.

So, it looks like the solution is pretty straightforward — we need to set `box-sizing` to `border-box` to fix our problem as this applied the `aspect-ratio` on this box (identical to the `padding-box` when we don’t have a `border`).

Sure enough, this fixes things… but only in Firefox!

![Screenshot collage. Shows how the text is not middle aligned in Chromium browsers (top), while Firefox (bottom) gets this right.](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/04/box_sizing_fix_collage.png?resize=799%2C459&ssl=1)

<small>Showing the difference between Chromium (top) and Firefox (bottom).</small>

The text should be middle-aligned vertically as we’ve given our `.card` elements a grid layout and set `place-content: center` on them. However, this doesn’t happen in Chromium browsers and it becomes a bit more obvious why when we take out this last declaration — somehow, the cell in the card’s grid gets the `3/ 1` aspect ratio too and overflows the card’s `content-box`:

![Animated gif. For some reason, the grid cell inside the card gets the set aspect ratio and overflows the card's content-box.](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/04/place_content_hint.gif?resize=800%2C300&ssl=1)

<small>Checking the card’s grid with vs. without `place-content: center` ([DEMO](https://codepen.io/thebabydino/pen/vYgvwBJ)).</small>

Fortunately, this is a [known Chromium bug](https://bugs.chromium.org/p/chromium/issues/detail?id=1166875) that [should probably get fixed in the coming months](https://twitter.com/bfgeek/status/1385704283643932672).

In the meantime, what we can do to get around this is remove the `box-sizing`, `padding` and `place-content` declarations from the `.card` element, move the text in a child element (or in the `::after` pseudo if it’s just a one-liner and we’re lazy, though an actual child is the better idea if we want the text to stay selectable) and make that a `grid` with a `padding`.

```scss
.card {
    /* same as before, 
       minus the box-sizing, place-content and padding declarations 
       the last two of which which we move on the child element */

    &__content {
        place-content: center;
        padding: 1em
    }
}
```

[CodePen](https://codepen.io/thebabydino/pen/gOgqewy) for code and preview.

#### Rounded corners

Let’s say we also want our cards to have rounded corners. Since a directional `transform` like the `scaley` on the `::before` pseudo-element that creates our `background` *also distorts corner rounding*, it results that the simplest way to achieve this is to set a `border-radius` on the actual `.card` element and cut out everything outside that rounding with `overflow: hidden`.

![Screenshot. Shows an element that's not scaled at all on the left. This has a perfectly circular border-radius. In the right, there's a non-uniform scaled element - its border-radius is not perfectly circular anymore, but instead distorted by the scaling.](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/04/scaling_altering_corner_rad.png?resize=799%2C391&ssl=1)

<small>Non-uniform scaling distorts corner rounding. ([DEMO](https://codepen.io/thebabydino/pen/VJQMmJ))</small>

However, this becomes problematic if at some point we want some other descendant of our `.card` to be visible outside of it. So, what we’re going to do is set the `border-radius` directly on the `::before` pseudo that creates the card `background` and reverse the directional scaling `transform` along the y axis on the y component of this `border-radius`:

```scss
$r: .5rem;

.card {
    /* same as before */

    &::before {
        border-radius: #{$r}/ calc(#{$r}*var(--ratio));
        transform: scaley(calc(1 / (var(--ratio))));
        /* same as before */
    }
}
```

[CodePen](https://codepen.io/thebabydino/pen/RwKdKMv) for code and preview.

### Final result

Putting it all together, here’s an interactive demo that allows changing the aspect ratio by dragging a slider – every time the slider value changes, the `--ratio` variable is updated: [CodePen](https://codepen.io/thebabydino/pen/XWpyowX).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
