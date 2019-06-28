> * 原文地址：[Building a Dynamic Tree Diagram with SVG and Vue.Js](https://medium.com/@krutie/building-a-dynamic-tree-diagram-with-svg-and-vue-js-a5df28e300cd)
> * 原文作者：[Krutie Patel](https://medium.com/@krutie)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-dynamic-tree-diagram-with-svg-and-vue-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-dynamic-tree-diagram-with-svg-and-vue-js.md)
> * 译者：
> * 校对者：

# Building a Dynamic Tree Diagram with SVG and Vue.Js

This article will take you through my learning journey into how I created a dynamic tree diagram that uses SVG (Scalable Vector Graphics) for drawing Cubic Bezier curve paths and Vue.js for data reactivity.

Before we start, [take a look at the demo](http://svg-tree-diagram.surge.sh).

![](https://cdn-images-1.medium.com/max/2242/1*i9yyyuT1hxMj1K7ZGP4vDg.png)

Combining the power of SVG and Vue.js framework allows creating diagrams and infographics that are data-driven, interactive and configurable.

This diagram is a collection of Cubic Bezier curves that start from a single point, but end on different points — at equal distance — based on user-provided data. So, the diagram is reactive to user input.

We’ll start by learning how the Cubic Bezier curve is formed and then try to find `x` and `y` points in the coordinate system that’s available within `<svg>` element followed by clipping mask.

I’ve used plenty of visuals on a way to keep things interesting. The key idea of this article is to help you come up with your own diagram concepts for similar projects.

## SVG

#### How the Cubic Bezier curve is formed?

The type of curve you saw in the demo above, is called a Cubic Bezier curve. I have highlighted each part of this curve structure below.

![](https://cdn-images-1.medium.com/max/3960/1*GPp1gpDRFC-Xx9z7Tg85iQ.png)

It has total 4 pairs of coordinates. First pair — `(x0, y0)`— is the starting anchor point, and last pair — `(x3, y3)` — is ending anchor points that indicates where to finish the path.

Two pairs in the middle are,

* Bezier control point #1 `(x1, y1)` and
* Bezier control point #2 `(x2, y2)`

And they’re responsible to achieve that smooth curve you see in a path. Without these control points, this path would just be a straight diagonal path!

Let’s put these four coordinates into SVG `<path>` syntax.

```
// Cubic Bezier path syntax

<path D="M x0,y0  C x1,y1  x2,y2  x3,y3" />
```

The letter `c` seen in the syntax, stands for Cubic Bezier curve. Small `c` indicates relative values, while the capital `C` indicates absolute value. I have used absolute value — `C` — to create this diagram.

**Achieving Symmetry**

Symmetry is the key aspect of this diagram. And to achieve that, I have used just one variable to derive values like height, width and mid-point.

Let’s call this variable, a `size`. Since the orientation of this tree-diagram is horizontal, this `size` variable can be viewed as an entire **horizontal** space that’s available for the diagram.

Let’s assign most realistic value to this variable. So that, you can also calculate the coordinates along the way.

```
size = 1000
```

## Finding Coordinates

Before we can find coordinates, we need a coordinate system in place!

#### Coordinate system & viewBox

`viewBox` attribute of an \<svg> element is an important, because it defines a user coordinate system of an SVG. In simplified terms, `viewBox` defines the position and dimension of the user-space to draw an SVG.

`viewBox` is made up of four numbers in this exact same order — `min-x, min-y, width, height`.

```
<svg viewBox="min-x min-y width height">...</svg>
```

The `size` variable we defined earlier will control the `width` and `height` of this coordinate system.

Later in Vue.js section, `viewBox` will be bound to computed property to populate the `width` and `height`, while `min-x` and `min-y` will always be zero in this instance.

Notice that, we’re not using `height` and `width` attributes of **SVG element** itself. Because, we’ll set `width: 100%` and `height: 100%` of an `<svg>` via CSS to make the viewport fluid.

Now that the user-space/coordinate system is ready for the diagram, let’s see how `size` helps calculating coordinates just by using different `%` values.

#### Constant & Dynamic Coordinates

![Diagram Concept](https://cdn-images-1.medium.com/max/5184/1*2CRePTNtiym2q7eJKxEUWQ.png)

Circle is part of the diagram. That’s why, it’s important to include it in the calculations from the beginning. As portrayed in the diagram above, let’s start deriving coordinate values for a **circle** and **one sample path.**

**The vertical height is divided into two parts, `topHeight` (20% of `size`) and `bottomHeight` (remaining 80% of `size`). And the horizontal width is divided into two parts — 50% of `size`.**

This makes the circle coordinates pretty self-explanatory, `(halfSize, topHeight)`. Circle `radius` is set to half of `topHeight`, so that it fits nicely in available space.

Now, let’s look at the path coordinates…

* **`x0, y0`**— First pair of anchor points that **stays constant** at all the times. Here, `x0` is the centre of the diagram `size` and `y0` is vertical point where the circle stops **(…hence the** addition **of a radius)** and path begins.  
= `(50% of size, 20% of size + radius)`
* **`x1, y1`**— Bezier control point one, which **also stays constant** for all paths. Keeping symmetry in mind, `x1` and `y1` are always half of the diagram `size`.   
= `(50% of size, 50% of size)`
* **`x2, y2`**— Bezier control point two, where **`x2`** directs which side to form the curve and **is calculated dynamically** for each paths. And again, `y2` will be half the diagram `size`.  
= `(x2, 50% of size)`
* **`x3, y3`**- Final pair of anchor points that indicates where to stop drawing the path. Here, `x3` imitates the value of `x2`, which is to be calculated dynamically. And `y3` takes 80% of the `size`.   
= `(x3, 80% of size)`

See the generic path syntax below after punching in these calculations. To represent `%`, I’ve simply divided the `%` value by 100.

```
<path d="M size*0.5, (size*0.2) + radius  
         C size*0.5,  size*0.5
           x2,        size*0.5
           x3,        size*0.8"
>
```

**Note: This whole `%` business may seem opinionated at first, but it’s for achieving symmetry and right proportion. Once you understand its purpose in building this diagram, you may try out your own `%` value & examine different results.**

Next part focuses on finding the values of remaining coordinates, `x2` and `x3` — which enables forming multiple curved paths dynamically based on their array `index`.

Depending on a number of items in an array, available horizontal space should be distributed into equal parts, so that each path gets same amount of space on `x-axis`.

Formula should work for any number of items eventually, but for the purpose of this article, I’ve gone with 5 array items — `[0,1,2,3,4]`. Meaning, I’ll draw 5 Bezier curves.

#### Finding Dynamic Coordinates (x2 and x3)

First, I have divided the `size` by the number of items, i.e. array length, and called this variable `distance` — for being the distance between the two items.

```
distance = size/arrayLength
// distance = 1000/5 = 200
```

Then, I’ve looped through each item in array and multiplied their `index` value with `distance`. For simplicity in writing, I’ve referred to both `x2` and `x3` — just `x`.

```
// value of x2 and x3
x = index * distance
```

The diagram looks bit odd when I used the value of `x` as it is for both `x2` and `x3`.

![](https://cdn-images-1.medium.com/max/6068/1*0whAEEtgKwVpeNf1uZY5ug.png)

As you can see, the placement of coordinates is correct, but not quite symmetrical. It looks as if left-side is getting more items than the right-side.

At this point, somehow I needed to place `x3` coordinate in the centre of the `distance`, rather than at the start.

To fix this, let’s revisit `distance` variable — which is 200 for the given scenario. I’ve simply added **half-a-distance** back into `x`.

```
x = index * distance + (distance * 0.5)
```

Meaning, I’ve found a mid-point of `distance` and placed the final `x3` coordinate there and also adjusted `x2` of the Bezier curve #2.

![](https://cdn-images-1.medium.com/max/6334/1*i2-TArj3Jol77m5f2fxgZA.png)

Addition of **half-a-distance** into — `x2` &`x3` — coordinate works for both odd and even number of array items.

#### Image Masking

To make the mask that’s shaped as a circle, I’ve **defined** a **mask** with **circle** in it.

```
<defs>
  <mask id="svg-mask">
     <circle :r="radius" 
             :cx="halfSize" 
             :cy="topHeight" 
             fill="white"/>
  </mask>
</defs>
```

Then, using `<image>` tag of `<svg>` element as a content, I have bound image with a `<mask>` (created above), using `mask` attribute.

```
<image mask="url(#svg-mask)" 
      :x="(halfSize-radius)" 
      :y="(topHeight-radius)"
...
> 
</image>
```

Since we’re trying to fit square image into a circle, I’ve adjusted the image position by reducing the `radius` of a circle to achieve full visibility of an image through the circular mask.

Let’s put together all the values visually in a diagram to help us see the bigger picture.

![](https://cdn-images-1.medium.com/max/3752/1*kWPi7xIsu6PF9drIwOKo4Q.png)

## Dynamic SVG using Vue.js

So far we have understood how Bezier curve works and surrounding nitty gritty. As a result, we have a static SVG diagram concept. Using Vue.js with SVG, we’ll now make this diagram data-driven and transform it from static to dynamic.

In this section we will break down SVG diagram into Vue components and bind SVG attributes to computed properties and make it respond to data changes.

Finally, we will also look at a config panel component which is used to provide data to the dynamic SVG diagram.

We’ll learn about the following key topics in this section.

* Binding SVG viewBox
* Calculating SVG Path Coordinates
* Two options for Bezier curve path implementation
* Config Panel
* Homework ❤

**Binding SVG viewBox**

First and foremost, we need a coordinate system in place to be able to draw inside SVG. And computed property `viewbox` will do just that using `size` variable. It contains four values separated by a whitespace — which is fed into **`viewBox`** attribute of an `<svg>` element.

```
viewbox() 
{
   return "0 0 " + this.size + " " + this.size;
}
```

In SVG, `viewBox` attribute is written in camelCase **already**.

```
<svg viewBox="0 0 1000 1000">
</svg>
```

Therefore, to correctly bind it to a computed property, I’ve used kebab-case version of attribute (below), followed by `.camel` modifier. This way HTML is tricked into binding this attribute correctly.

```
<svg :view-box.camel="viewbox">
   ...
</svg>
```

Now, every time we change the `size`, the diagram will adjust itself without us having to change the markup manually.

**Calculating SVG Path Coordinates**

Since most values are derived from a single variable, `size`, I’ve used computed properties for all of the constant coordinates. Don’t be confused by the term constant here. These values are derived from the `size`, but after **that**, they remain constant — no matter how many curved paths are created.

And if you change the size of an SVG, these values are computed again. With that in mind, here’s the list of five values required to draw Bezier curves.

* topHeight— `size * 0.2`
* bottomHeight — `size * 0.8`
* width — `size`
* halfSize — `size * 0.5`
* distance— `size/arrayLength`

At this point, we are left with two unknown values, `x2` and `x3` — and we do have a formula to find their values.

```
x = index * distance + (distance * 0.5)
```

To find `x` above, we need to feed `index` into the formula for each path at once. So…

Is computed property an appropriate option here? The short answer is no.

We cannot pass a parameter to a computed property — because it’s a property, and not a function. Also, needing a parameter to calculate something means — there’s no clear caching benefit of using the computed property anyways.

****Note:** There’s an exception to above. Vuex. If we’re using Vuex Getters, then yes, we can pass parameter to getters by returning a function.**

We’re not using Vuex in this instance. Even then, we’re left with couple of options.

#### Option 1

We can define a function, where we pass an array `index` as an argument and return the result. Bit cleaner option, if we’re to use this value at multiple places in the template.

```
<g v-for="(item, i) in itemArray">
  <path :d="'M' + halfSize + ','         + (topHeight+r) +' '+
            'C' + halfSize + ','         + halfSize +' '+    
                  calculateXPos(i) + ',' + halfSize +' '+ 
                  calculateXPos(i) + ',' + bottomHeight" 
  />
</g>
```

**`calculateXPos()`** method will evaluate every time it’s called. And this method accepts index — `i` — as an argument. (Below)

```
<script>
  methods: {
    calculateXPos (i)
    {
      return distance * i + (distance * 0.5)
    }
  }
</script>
```

Here’s the CodePen that uses **Option 1**.

#### Option 2

Better yet, we can extract this small SVG path markup into its own little child component and pass `index` as a prop into it — along with other required props, of course.

In this instance, we can even use computed property to find `x2` and `x3`.

```
<g v-for="(item, i) in items"> 
    <cubic-bezier  :index="i" 
                   :half-size="halfSize" 
                   :top-height="topHeight" 
                   :bottom-height="bottomHeight" 
                   :r="radius"
                   :d="distance"
     >
     </cubic-bezier>
</g>
```

This option gives us an opportunity to be more organised with the code. For example, we can create one more child component for the clipping-mask of a circle as below.

```
<clip-mask :title="title"
           :half-size="halfSize" 
           :top-height="topHeight"                     
           :r="radius"> 
</clip-mask>
```

#### Config Panel

![Config Panel](https://cdn-images-1.medium.com/max/2000/1*zI1UlqRzNrxoGQdgl9nCSA.png)

As you may have already seen the **Config Panel** on top-left corner in CodePen above, it facilitates adding and removing of items from array. Following Option 2, I have created a child component to accommodate the Config Panel as well, which leaves top-level Vue component clean and readable. As a result, sweet little Vue component tree will look something like below.

![](https://cdn-images-1.medium.com/max/2942/1*ztoHw3dN6o_0VvwI1UOpxw.png)

Wondering how the code would look like now? Here’s the CodePen using **Option 2**.

## GitHub Repo

Finally, here’s the [GitHub Repo](https://github.com/Krutie/svg-tree-diagram) for you to review the project (with Option 2) before you move onto the next section.

## Homework

Try creating the same diagram in vertical mode based on a logic presented in this article.

If you think, it could be as easy as swapping the x and y coordinates, then you’re correct! Because the hard-work is done already, after swapping the coordinates **where required**, update the code with appropriate variables and method names.

With the help of Vue.js, this diagram can be extended further with more features, such as,

* Create a switch to toggle between horizontal and vertical mode
* Maybe use GSAP to animate the path
* Control path attributes (such as colour & stroke width) from config panel
* Use external library to save and download the diagram as an image/PDF

Now give it a try and if needed, there’s the answer-link to the Homework below.

Good Luck!

## Conclusion

`<path>` is one of the many powerful elements in SVG, as it allows you to create graphics and diagrams with precision. In this article, we understood how Bezier curve works and its application to create custom diagram.

It’s always daunting to adjust with data-driven approach used by modern JavaScript frameworks, but Vue.js makes it really easy, and also takes care of mundane tasks such as DOM manipulation. So that you — as a developer — can think in terms of data even while working with projects that are significantly visual in nature.

I’ve realised that it took some of the simple concepts of both Vue.js and SVG to create this diagram that seems complex by the look of it. I encourage you to read about [Building an Interactive Infographic with Vue.js](https://www.smashingmagazine.com/2018/11/interactive-infographic-vue-js/), if you haven’t read already. It’d be good read after this one. ❤ And here’s an [answer](https://codepen.io/krutie/pen/QRrNKz) to the homework.

I hope you have learned something from this article and had as much fun reading it as I had while creating it.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
