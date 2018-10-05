> * 原文地址：[Everything You Need To Know About Alignment In Flexbox](https://www.smashingmagazine.com/2018/08/flexbox-alignment/)
> * 原文作者：[Rachel Andrew](https://www.smashingmagazine.com/author/rachel-andrew)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-alignment.md](https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-alignment.md)
> * 译者：
> * 校对者：

# Everything You Need To Know About Alignment In Flexbox

**Quick summary:** In this article, we take a look at the alignment properties in Flexbox while discovering some basic rules to help remember how alignment on both the main and cross axis works.

[In the first article of this series](https://github.com/xitu/gold-miner/blob/master/TODO1/flexbox-display-flex-container.md), I explained what happens when you declare `display: flex` on an element. This time we will take a look at the alignment properties, and how these work with Flexbox. If you have ever been confused about when to align and when to justify, I hope this article will make things clearer!

### History Of Flexbox Alignment

For the entire history of CSS Layout, being able to properly align things on both axes seemed like it might truly be the hardest problem in web design. So the ability to properly align items and groups of items was for many of us the most exciting thing about Flexbox when it first started to show up in browsers. Alignment became as simple as two lines of CSS:

HTML:

```html
<div class="container">
  <div class="item">Item</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  height: 300px;
  width: 300px;
  justify-content: center;
  align-items: center;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}
```

See the Pen [Smashing Flexbox Series 2: center an item](https://codepen.io/rachelandrew/pen/WKLYEX) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

The alignment properties that you might think of as the flexbox alignment properties are now fully defined in the [Box Alignment Specification](https://www.w3.org/TR/css-align-3/). This specification details how alignment works across the various layout contexts. This means that we can use the same alignment properties in CSS Grid as we use in Flexbox — and in future in other layout contexts, too. Therefore, any new alignment capability for flexbox will be detailed in the Box Alignment specification and not in a future level of Flexbox.

### The Properties

Many people tell me that they struggle to remember whether to use properties which start with `align-` or those which start with `justify-` in flexbox. The thing to remember is that:

*   `justify-` performs main axis alignment. Alignment in the same direction as your `flex-direction`
*   `align-` performs cross-axis alignment. Alignment across the direction defined by `flex-direction`.

Thinking in terms of main axis and cross axis, rather than horizontal and vertical really helps here. It doesn’t matter which way the axis is physically.

#### Main Axis Alignment With `justify-content`

We will start with the main axis alignment. On the main axis, we align using the `justify-content` property. This property deals with all of our flex items as a group, and controls how space is distributed between them.

The initial value of `justify-content` is `flex-start`. This is why, when you declare `display: flex` all your flex items line up against the start of the flex line. If you have a `flex-direction` of `row` and are in a left to right language such as English, then the items will start on the left.

[![The items are all lined up in a row starting on the left](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/67648629-b445-429f-9fd4-0fb47b7875ef/justify-content-flex-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/67648629-b445-429f-9fd4-0fb47b7875ef/justify-content-flex-start.png) 

The items line up to the start ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/67648629-b445-429f-9fd4-0fb47b7875ef/justify-content-flex-start.png))

Note that the `justify-content` property can only do something **if there is spare space to distribute**. Therefore if you have a set of flex items which take up all of the space on the main axis, using `justify-content` will not change anything.

[![The container is filled with the items](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/064418da-c45c-4fbf-9b4e-65c481c05c00/justify-content-no-space.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/064418da-c45c-4fbf-9b4e-65c481c05c00/justify-content-no-space.png) 

There is no space to distribute ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/064418da-c45c-4fbf-9b4e-65c481c05c00/justify-content-no-space.png))

If we give `justify-content` a value of `flex-end` then all of the items will move to the end of the line. The spare space is now placed at the beginning.

[![The items are displayed in a row starting at the end of the container — on the right](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/262c2132-a9bf-4c6c-90cd-4ec445c9f3e1/justify-content-flex-end.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/262c2132-a9bf-4c6c-90cd-4ec445c9f3e1/justify-content-flex-end.png) 

The items line up at the end ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/262c2132-a9bf-4c6c-90cd-4ec445c9f3e1/justify-content-flex-end.png))

We can do other things with that space. We could ask for it to be distributed _between_ our flex items, by using `justify-content: space-between`. In this case, the first and last item will be flush with the ends of the container and all of the space shared equally between the items.

[![Items lined up left and right with equal space between them](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e0df6bac-5250-47d2-82ed-da66306e7c95/justify-content-space-between.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e0df6bac-5250-47d2-82ed-da66306e7c95/justify-content-space-between.png) 

The spare space is shared out between the items ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/e0df6bac-5250-47d2-82ed-da66306e7c95/justify-content-space-between.png))

We can ask that the space to be distributed around our flex items, using `justify-content: space-around`. In this case, the available space is shared out and placed on each side of the item.

[![Items spaced out with even amounts of space on each side](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/acab1663-6d66-4d98-9d1c-2f2b98911bbe/justify-content-space-around.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/acab1663-6d66-4d98-9d1c-2f2b98911bbe/justify-content-space-around.png) 

The items have space either side of them ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/acab1663-6d66-4d98-9d1c-2f2b98911bbe/justify-content-space-around.png))

A newer value of `justify-content` can be found in the Box Alignment specification; it doesn’t appear in the Flexbox spec. This value is `space-evenly`. In this case, the items will be evenly distributed in the container, and the extra space will be shared out between and either side of the items.

[![Items with equal amounts of space between and on each end](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8960c00-dd71-4147-bd7a-7a32bc98f08a/justify-content-space-evenly.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8960c00-dd71-4147-bd7a-7a32bc98f08a/justify-content-space-evenly.png) 

The items are spaced evenly ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/b8960c00-dd71-4147-bd7a-7a32bc98f08a/justify-content-space-evenly.png))

You can play with all of the values in the demo:

HTML:

```html
<div class="controls">
<select id="justifyMe">
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="space-around">space-around</option>
  <option value="space-between">space-between</option>
  <option value="space-evenly">space-evenly</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
  
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JavaScript:

```js
var justify = document.getElementById("justifyMe");
justifyMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.justifyContent = evt.target.value;
});
```

See the Pen [Smashing Flexbox Series 2: justify-content with flex-direction: row](https://codepen.io/rachelandrew/pen/Owraaj) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

These values work in the same way if your `flex-direction` is `column`. You may not have extra space to distribute in a column however unless you add a height or block-size to the flex container as in this next demo.

HTML:

```html
<div class="controls">
<select id="justifyMe">
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="space-around">space-around</option>
  <option value="space-between">space-between</option>
  <option value="space-evenly">space-evenly</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  flex-direction: column;
  height: 60vh;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JavaScript:

```js
var justify = document.getElementById("justifyMe");
justifyMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.justifyContent = evt.target.value;
});
```

See the Pen [Smashing Flexbox Series 2: justify-content with flex-direction: column](https://codepen.io/rachelandrew/pen/zLyMyV) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

#### Cross Axis Alignment with `align-content`

If you have added `flex-wrap: wrap` to your flex container, and have multiple flex lines then you can use `align-content` to align your flex lines on the cross axis. However, this will require that you have additional space on the cross axis. In the below demo, my cross axis is running in the block direction as a column, and I have set the height of the flex container to `60vh`. As this is more than is needed to display my flex items I have spare space vertically in the container.

I can then use `align-content` with any of the values:

HTML:

```html
<div class="controls">
<select id="alignMe">
  <option value="stretch">stretch</option>
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="space-around">space-around</option>
  <option value="space-between">space-between</option>
  <option value="space-evenly">space-evenly</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
  <div class="item">Four Four Four Four</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  max-width: 400px;
  height: 60vh;
  display: flex;
  flex-wrap: wrap;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JavaScript:

```js
var align = document.getElementById("alignMe");
alignMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.alignContent = evt.target.value;
});
```

See the Pen [Smashing Flexbox Series 2: align-content with flex-direction: row](https://codepen.io/rachelandrew/pen/pZqqMJ) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

If my `flex-direction` were `column` then `align-content` would work as in the following example.

HTML:

```html
<div class="controls">
<select id="alignMe">
  <option value="stretch">stretch</option>
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="space-around">space-around</option>
  <option value="space-between">space-between</option>
  <option value="space-evenly">space-evenly</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
  <div class="item">Four Four Four Four</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  max-width: 400px;
  height: 60vh;
  display: flex;
  flex-wrap: wrap;
  flex-direction: column;
}

.item {
  height: 20vh;
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JacaScript:

```js
var align = document.getElementById("alignMe");
alignMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.alignContent = evt.target.value;
});
```

See the Pen [Smashing Flexbox Series 2: align-content with flex-direction: column](https://codepen.io/rachelandrew/pen/MBZZNy) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

As with `justify-content`, we are working with the lines as a group and distributing the spare space.

### The `place-content` Shorthand

In the Box Alignment, we find the shorthand `place-content`; using this property means you can set `justify-content` and `align-content` at once. The first value is for `align-content`, the second for `justify-content`. If you only set one value then both values are set to that value, therefore:

```
.container {
    place-content: space-between stretch;
}
```

Is the same as:

```
.container {
    align-content: space-between; 
    justify-content: stretch;
}
```

If we used:

```
.container {
    place-content: space-between;
}
```

This would be the same as:

```
.container {
    align-content: space-between; 
    justify-content: space-between;
}
```

#### Cross Axis Alignment With `align-items`

We now know that we can align our set of flex items or our flex lines as a group. However, there is another way we might wish to align our items and that is to align items in relationship to each other on the cross axis. Your flex container has a height. That height might be defined by the height of the tallest item as in this image.

[![The container height is tall enough to contain the items, the third item has more content](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dabd13bf-bf9c-411f-86c0-d43cdfb935fe/container-height-of-item.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dabd13bf-bf9c-411f-86c0-d43cdfb935fe/container-height-of-item.png) 

The container height is defined by the third item ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/dabd13bf-bf9c-411f-86c0-d43cdfb935fe/container-height-of-item.png))

It might instead be defined by adding a height to the flex container:

[![The container height is taller than needed to display the items](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c477a442-ea29-48cf-bed9-94b75593a1b2/container-added-height.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c477a442-ea29-48cf-bed9-94b75593a1b2/container-added-height.png) 

The height is defined by a size on the flex container ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/c477a442-ea29-48cf-bed9-94b75593a1b2/container-added-height.png))

The reason that flex items appear to stretch to the size of the tallest item is that the initial value of `align-items` is `stretch`. The items stretch on the cross axis to become the size of the flex container in that direction.

Note that where `align-items` is concerned, if you have a multi-line flex container, each line acts like a new flex container. The tallest item in that line would define the size of all items in that line.

In addition to the initial value of stretch, you can give `align-items` a value of `flex-start`, in which case they align to the start of the container and no longer stretch to the height.

[![The items are aligned to the start](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7da24e8b-8d18-4ada-9f0e-e417e0293607/align-items-flex-start.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7da24e8b-8d18-4ada-9f0e-e417e0293607/align-items-flex-start.png) 

The items aligned to the start of the cross axis ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7da24e8b-8d18-4ada-9f0e-e417e0293607/align-items-flex-start.png))

The value `flex-end` moves them to the end of the container on the cross axis.

[![Items aligned to the end of the cross axis](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52d4c377-8c60-4336-be64-f01cb9a20833/align-items-flex-end.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52d4c377-8c60-4336-be64-f01cb9a20833/align-items-flex-end.png) 

The items aligned to the end of the cross axis ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/52d4c377-8c60-4336-be64-f01cb9a20833/align-items-flex-end.png))

If you use a value of `center` the items all centre against each other:

[![The items are centered](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8ccb2aba-b692-4ba5-8827-1043674fc1d4/align-items-center.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8ccb2aba-b692-4ba5-8827-1043674fc1d4/align-items-center.png) 

Centering the items on the cross axis ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8ccb2aba-b692-4ba5-8827-1043674fc1d4/align-items-center.png))

We can also do baseline alignment. This ensures that the baselines of text line up, as opposed to aligning the boxes around the content.

[![The items are aligned so their baselines match](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6607e8bc-9f6b-43a6-9b13-24bff76068f1/align-items-baseline.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6607e8bc-9f6b-43a6-9b13-24bff76068f1/align-items-baseline.png) 

Aligning the baselines ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/6607e8bc-9f6b-43a6-9b13-24bff76068f1/align-items-baseline.png))

You can try these values out in the demo:

HTML:

```html
<div class="controls">
<select id="alignMe">
  <option value="stretch">stretch</option>
  <option value="flex-start">flex-start</option>
  <option value="flex-end">flex-end</option>
  <option value="center">center</option>
  <option value="baseline">baseline</option>
</select>

</div>

<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item large">Three Three Three</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  height: 40vh;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.large {
  font-size: 150%;
}

.controls {
  background-color: rgba(0,0,0,.1);
  padding: 10px;
  border-radius: .5em;
  border: 1px solid rgba(0,0,0,.2);
  margin: 0 0 2em 0
}

.controls select {
  font-size: .9em;
}
```

JacaScript:

```js
var align = document.getElementById("alignMe");
alignMe.addEventListener("change", function (evt) {
  document.getElementById("container").style.alignItems = evt.target.value;
});
```

See the Pen [Smashing Flexbox Series 2: align-items](https://codepen.io/rachelandrew/pen/WKLBpv) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

#### Individual Alignment With `align-self`

The `align-items` property means that you can set the alignment of all of the items at once. What this really does is set all of the `align-self` values on the individual flex items as a group. You can also use the `align-self` property on any individual flex item to align it inside the flex line and against the other flex items.

In the following example, I have used `align-items` on the container to set the alignment for the group to `center`, but also used `align-self` on the first and last items to change their alignment value.

HTML:

```html
<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  height: 40vh;
  align-items: center;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.item:first-child {
  align-self: flex-end;
}

.item:last-child {
  align-self: stretch;
}
```

See the Pen [Smashing Flexbox Series 2: align-self](https://codepen.io/rachelandrew/pen/KBbLmz) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

### Why Is There No `justify-self`?

A common question is why it is not possible to align one item or a group of the items on the main axis. Why is there no `-self` property for main axis alignment in Flexbox? If you think about `justify-content` and `align-content` as being about space distribution, the reason for their being no self-alignment becomes more obvious. We are dealing with the flex items as a group, and distributing available space in some way — either at the start or end of the group or between the items.

If might be also helpful to think about how `justify-content` and `align-content` work in CSS Grid Layout. In Grid, these properties are used to distribute spare space in the grid container _between grid tracks_. Once again, we take the tracks as a group, and these properties give us a way to distribute any extra space between them. As we are acting on a group in both Grid and Flexbox, we can’t target an item on its own and do something different with it. However, there is a way to achieve the kind of layout that you are asking for when you ask for a `self` property on the main axis, and that is to use auto margins.

#### Using Auto Margins On The Main Axis

If you have ever centered a block in CSS (such as the wrapper for your main page content by setting a margin left and right of `auto`), then you already have some experience of how auto margins behave. A margin set to auto will try to become as big as it can in the direction it has been set in. In the case of using margins to center a block, we set the left and right both to auto; they each try and take up as much space as possible and so push our block into the center.

Auto margins work very nicely in Flexbox to align single items or groups of items on the main axis. In the next example, I am achieving a common design pattern. I have a navigation bar using Flexbox, the items are displayed as a row and are using the initial value of `justify-content: start`. I would like the final item to be displayed separated from the others at the end of the flex line — assuming there is enough space on the line to do so.

I target that item and give it a margin-left of auto. This then means that the margin tries to get as much space as possible to the left of the item, which means the item gets pushed all the way over to the right.

HTML:

```html
<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item push">Three Three Three</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}


.push {
  margin-left: auto;
}
```

See the Pen [Smashing Flexbox Series 2: alignment with auto margins](https://codepen.io/rachelandrew/pen/oMJROm) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

If you use auto margins on the main axis then `justify-content` will cease to have any effect, as the auto margins will have taken up all of the space that would otherwise be assigned using `justify-content`.

### Fallback Alignment

Each alignment method details a fallback alignment, this is what will happen if the alignment you have requested can’t be achieved. For example, if you only have one item in a flex container and ask for `justify-content: space-between`, what should happen? The answer is that the fallback alignment of `flex-start` is used and your single item will align to the start of the flex container. In the case of `justify-content: space-around`, a fallback alignment of `center` is used.

In the current specification you can’t change what the fallback alignment is, so if you would prefer that the fallback for `space-between` was `center` rather than `flex-start`, there isn’t a way to do that. There is [a note in the spec](https://www.w3.org/TR/css-align-3/#distribution-values) which says that future levels may enable this.

### Safe And Unsafe Alignment

A more recent addition to the Box Alignment specification is the concept of safe and unsafe alignment using the _safe_ and _unsafe_ keywords.

With the following code, the final item is too wide for the container and with unsafe alignment and the flex container on the left-hand side of the page, the item becomes cut off as the overflow is outside the page boundary.

```
.container {  
    display: flex;
    flex-direction: column;
    width: 100px;
    align-items: unsafe center;
}

.item:last-child {
    width: 200px;
}
```

[![The overflowing item is centered and partly cut off](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/54359e1a-e4e4-445a-8fcc-e4ef59591bad/unsafe-alignment.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/54359e1a-e4e4-445a-8fcc-e4ef59591bad/unsafe-alignment.png) 

Unsafe alignment will give you the alignment you asked for but may cause data loss ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/54359e1a-e4e4-445a-8fcc-e4ef59591bad/unsafe-alignment.png))

A safe alignment would prevent the data loss occurring, by relocating the overflow to the other side.

```
.container {  
    display: flex;
    flex-direction: column;
    width: 100px;
    align-items: safe center;
}

.item:last-child {
    width: 200px;
}
```

[![The overflowing item overflows to the right](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7e31128f-cc18-430d-aa06-9a5307021d0c/safe-alignment.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7e31128f-cc18-430d-aa06-9a5307021d0c/safe-alignment.png) 

Safe alignment tries to prevent data loss ([Large preview](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7e31128f-cc18-430d-aa06-9a5307021d0c/safe-alignment.png))

These keywords have limited browser support right now, however, they demonstrate the additional control being brought to Flexbox via the Box Alignment specification.

HTML:

```html
<div class="container" id="container">
  <div class="item">One</div>
  <div class="item">Two Two</div>
  <div class="item">Three Three Three</div>
</div>
```

CSS:

```css
body {
  padding: 20px;
  font: 1em Helvetica Neue, Helvetica, Arial, sans-serif;
}

* {box-sizing: border-box;}

p {
  margin: 0 0 1em 0;
}

.container {  
  border: 5px solid rgb(111,41,97);
  border-radius: .5em;
  padding: 10px;
  display: flex;
  flex-direction: column;
  width: 100px;
  align-items: safe center;
}

.item {
  padding: 10px;
  background-color: rgba(111,41,97,.3);
  border: 2px solid rgba(111,41,97,.5);
}

.item:last-child {
  width: 200px;
}
```

See the Pen [Smashing Flexbox Series 2: safe or unsafe alignment](https://codepen.io/rachelandrew/pen/zLyVmQ) by Rachel Andrew ([@rachelandrew](https://codepen.io/rachelandrew)) on [CodePen](https://codepen.io).

### In Summary

The alignment properties started as a list in Flexbox, but are now in their own specification and apply to other layout contexts. A few key facts will help you to remember how to use them in Flexbox:

*   `justify-` the main axis and `align-` the cross axis;
*   To use `align-content` and `justify-content` you need spare space to play with;
*   The `align-content` and `justify-content` properties deal with the items as a group, sharing out space. Therefore, you can’t target an individual item and so there is no `-self` alignment for these properties;
*   If you do want to align one item, or split a group on the main axis, use auto margins to do so;
*   The `align-items` property sets all of the `align-self` values as a group. Use `align-self` on the flex child to set the value for an individual item.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
