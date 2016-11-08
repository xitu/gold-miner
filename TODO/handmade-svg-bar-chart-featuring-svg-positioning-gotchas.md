> * 原文地址：[A Handmade SVG Bar Chart (featuring some SVG positioning gotchas)](https://css-tricks.com/handmade-svg-bar-chart-featuring-svg-positioning-gotchas/)
* 原文作者：[Robin Rendle](https://css-tricks.com/forums/users/robinrendle/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# A Handmade SVG Bar Chart (featuring some SVG positioning gotchas)
Let's take a look at some things I learned about positioning elements within SVG that I discovered whilst making a (seemingly) simple bar chart earlier this week.

You don't have much choice but to position things in SVG. SVG is a declarative graphics format, and what are graphics but positioned drawing instructions? There are plenty of gotchas and potentially frustrating situations though, so let's get down to it.



This is the bar chart we're wanting to build:

![](https://cdn.css-tricks.com/wp-content/uploads/2016/10/Screenshot-2016-10-20-21.57.49.png)

We could make this in our graphics editor of choice and dump it into our markup as an `<img>` tag (even as an `.svg`), but where would the fun in that be? I also wanted to make this SVG chart by hand because I knew I would learn more about the syntax than if I were to just export a Sketch or Illustrator file.

To get things moving, let’s make an `<svg>` that will house our child elements:

```
<svg width='100%' height='65px'>

</svg>
```

Now let’s make the two bars. The first will sit in the background and the second will sit on top of it and it’ll represent the data of our graph:

```
<svg width='100%' height='65px'>
  <g class='bars'>
    <rect fill='#3d5599' width='100%' height='25'></rect>;
    <rect fill='#cb4d3e' width='45%' height='25'></rect>
  </g>
</svg>
```

(Without providing a `x` and `y` attribute for the `<rect>`s, they are assumed to be 0.)

In the demo below, I’ve made them animate so you can see the second rect is placed on top of the first (this would be like drawing two rectangles in Sketch, one is layered on top of the other):

See the Pen [Chart stuff: 1](http://codepen.io/robinrendle/pen/43430fd382ab20ff426022d5c8ad4a89/) by Robin Rendle ([@robinrendle](http://codepen.io/robinrendle)) on [CodePen](http://codepen.io).

Next we can add the lines that act as markers to more easily read the data at 0, 25, 50, 75, and 100%. All we need to do is make a new group and add a rect for each marker, right? Sure, but you'll see we run into a little problem in a second.

Inside the SVG, and beneath the `<g>` where we styled our chart’s data we can write the following:

```
<g class='markers'>
    <rect fill='red' x='50%' y='0' width='2' height='35'></rect>
</g>
```

That ought to look like this:

See the Pen [Chart stuff: 2](http://codepen.io/robinrendle/pen/e1a7d1e99ada07657cc0a98ff3652fec/) by Robin Rendle ([@robinrendle](http://codepen.io/robinrendle)) on [CodePen](http://codepen.io).

Neat! Let’s add all the other markers and fix the colors whilst we’re at it:

```
<g class='markers'>
    <rect fill='#001f3f' x='0%' y='0' width='2' height='35'></rect>
    <rect fill='#001f3f' x='25%' y='0' width='2' height='35'></rect>
    <rect fill='#001f3f' x='50%' y='0' width='2' height='35'></rect>
    <rect fill='#001f3f' x='75%' y='0' width='2' height='35'></rect>
    <rect fill='#001f3f' x='100%' y='0' width='2' height='35'></rect>
</g>
```

We’ve added a `rect` for each marker, added a fill to set the color and positioned them with the `x` attribute. Let’s see what that renders in the browser:

See the Pen [Chart stuff: 3](http://codepen.io/robinrendle/pen/fb6b57b1a2572d312112b425bd8762fa/) by Robin Rendle ([@robinrendle](http://codepen.io/robinrendle)) on [CodePen](http://codepen.io).

Where the heck did that last one go? Well, we _did_ tell it to be positioned at 100%, so it's actually positioned off the screen to the right. We need to take its width into consideration and move it to the left by 2\. There are a number of ways we can fix this.

1) We could apply an inline transform to nudge it back over

```
<rect fill='#001f3f' x='100%' y='0' width='2' height='35' transform="translate(-2, 0)"></rect>
```

2) We could apply that same transform through CSS:

    rect:last-of-type {
      transform: translateX(-2px); /* Remember this isn't really "pixels", it's a length of 2 in the SVG coordinate system */
    }

3) Or we could not use a percentage and place it along the X axis at a precise place. We know what the exact coordinate system of SVG is thanks to the `viewBox` attribute. In Chapter 6 of [Practical SVG](https://abookapart.com/products/practical-svg), Chris explains:

> The `viewBox` is an attribute of `svg` that determines the coordinate system and aspect ratio. The four values are x, y, width and height.

Say our `viewBox` is...

```
<svg viewBox='0 0 1000 65'>
  <!-- the rest of our svg code goes here -->
</svg>
```

So it is 1000 units wide. Our marker is 2 units wide. So to place the final marker along the right edge, we'd place it at 998! (1000 - 2). That becomes our x attribute:

```
<svg viewBox='0 0 1000 65'>
  ...
  <rect fill='#001f3f' x='998' y='0' width='2' height='35'></rect>
  ...
</svg>
```

Which will lead to our marker being positioned on the far right edge of the SVG, even if we resize it:

See the Pen [Chart stuff: 4](http://codepen.io/robinrendle/pen/595f1f122c4489567ecc1dd696870ad2/) by Robin Rendle ([@robinrendle](http://codepen.io/robinrendle)) on [CodePen](http://codepen.io).

Yay! We don’t have to add a % or a pixel value here because it’s using the coordinate system set up by the `viewBox`.

With all that finally sorted we can move onto the next issue: adding the % label text beneath each marker to denote 25, 50%, etc. To do that we’ll make a new `` inside the `` and add our `` elements:

```
<g>
    <text fill='#0074d9' x='0' y='60'>0%</text>
    <text fill='#0074d9' x='25%' y='60'>25%</text>
    <text fill='#0074d9' x='50%' y='60'>50%</text>
    <text fill='#0074d9' x='75%' y='60'>75%</text>
    <text fill='#0074d9' x='100%' y='60'>100%</text>
</g>
```

Because we’re doing this by hand I want to use % for the x value, but unfortunately that will end up looking like this:

See the Pen [Chart stuff: 5](http://codepen.io/robinrendle/pen/f10b2c6e1ddfcf491a84b457da8c7bee/) by Robin Rendle ([@robinrendle](http://codepen.io/robinrendle)) on [CodePen](http://codepen.io).

Again, we have a problem with the final element not aligning as we might expect it to. The middle labels are misplaced as well; ideally they would be centered underneath their marks. I thought I might have to nudge each element into place with the correct x value before Chris pointed me to the [`text-anchor`](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/text-anchor) attribute which I had never heard about.

With this attribute we can manipulate the text sort of like the `text-align` property in CSS. This property is naturally inherited, so we can set it once on the `g` and then target the first and last elements:

```
<g text-anchor='middle'>
  <text text-anchor='start' fill='#0074d9' x='0' y='60'>0%</text>
  <text fill='#0074d9' x='25%' y='60'>25%</text>
  <text fill='#0074d9' x='50%' y='60'>50%</text>
  <text fill='#0074d9' x='75%' y='60'>75%</text>
  <text text-anchor='end' fill='#0074d9' x='100%' y='60'>100%</text>
</g>
```

That will look like:

See the Pen [Chart stuff: 6](http://codepen.io/robinrendle/pen/338cf7c726d85c58c16f9b07a0dd4de3/) by Robin Rendle ([@robinrendle](http://codepen.io/robinrendle)) on [CodePen](http://codepen.io).

That’s it! With a little bit of knowledge about how `viewBox` works, along with `x`, `y` coordinates and attributes like `text-anchor` we can do pretty much anything with the elements inside an SVG.

By making these charts by hand, it feels like we have a lot of control. It's not hard to imagine how we might exert even more design control or pipe in data with JavaScript.

With a tiny extra bit of work, we can animate these charts to really make them stand out. Try hovering over this version of our chart for instance:

See the Pen [Chart stuff: 7](http://codepen.io/robinrendle/pen/9197c221b3032a8b78c472f9a9a799b5/) by Robin Rendle ([@robinrendle](http://codepen.io/robinrendle)) on [CodePen](http://codepen.io).

Pretty neat, huh? And that’s all possible with just SVG and CSS. If you’re interested in learning more then I wrote about [how to make charts with SVG](https://css-tricks.com/how-to-make-charts-with-svg/) a while back which explains this stuff in more depth.

Now let’s go make some cool charts!
