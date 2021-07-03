> * 原文地址：[Swipey image grids.](https://www.cassie.codes/posts/swipey-image-grids/)
> * 原文作者：[cassie](https://www.cassie.codes/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/swipey-image-grids.md](https://github.com/xitu/gold-miner/blob/master/article/2021/swipey-image-grids.md)
> * 译者：
> * 校对者：

When someone says 'SVG animation', what do you picture?

From conversations at my workshops I've noticed that most people think of illustrative animation. But SVG can come in handy for so much more than jazzy graphics. When you stop looking at SVG purely as a format for illustrations and icons, it's like a lightbulb goes on and a whole **world** of UI styling opens up.

One of my favourite use-cases recently is to use SVG to make responsive animated image grids.

The one below is a grid that I added to the [Clearleft services](https://clearleft.com/what-we-do) page. There's a few scattered about on the [UXFest site too](https://2021.uxlondon.com/)

Oooh, swooshy!

So what made me reach for SVG to achieve this? We've made huge steps forward with CSS layout recently, so if you need to make a grid... CSS Grid seems like the obvious choice.

But we have another grid at our disposal. SVG has it's own internal coordinate system and it's responsive by design. It's basically an infinite bit of digital graph paper that we can plot elements onto.

The `viewBox` attribute defines the position and dimension, in user space, of an SVG viewport. The values in the attribute are `x y width height`

So by creating this markup we're basically saying - Oi SVG, make us a grid 100 units wide by 100 units high starting at the coordinate 0,0

```svg
<svg viewBox="0 0 100 100"></svg>
```

We can then plot things on this grid, pretty much anywhere we please. I usually get a pen and paper out at this point and doodle it out.

Let's break down a layout together. The `rect` element takes x and y coordinates to position the top left hand corner and then a width and height - just like the SVG viewBox coordinates. `x y width height` is a really common pattern in SVG.

```svg
<svg viewBox="0 0 100 100">
    <rect x="30" y="0" width="70" height="50" fill="blue"/>
    <rect x="60" y="60" width="40" height="40" fill="green"/>
    <rect x="0" y="30" width="50" height="70" fill="pink"/>
</svg>
```

See, it's as simple as counting out some grid blocks.

> 💡 We want the pink rectangle to be on top so you'll notice it's last in the DOM. This is because SVG has an implicit drawing order and `z-index` doesn't work, no matter how many 9999's you put in.

Cool, so here's our lovely responsive SVG grid.

## Adding images [permalink](#heading-adding-images)

SVG is like an alternate universe version of HTML for graphics instead of content. So a lot of things are similar, but *not quite* the same. For example - we have `<image>` tags instead of `<img>` tags, and we reference the image URL using `href` instead of `src`

`<image>` elements are positioned using `x y width height` - just like our viewBox. Lets add some images in the same position as our `<rect>` elements.

```svg
<svg viewBox="0 0 100 100">
    <rect x="30" y="0" width="70" height="50" fill="blue"/>
    <rect x="60" y="60" width="40" height="40" fill="green"/>
    <rect x="0" y="30" width="50" height="70" fill="pink"/>
    <image x="30" y="0" width="70" height="50" href="https://place-puppy.com/300x300"/>
    <image x="60" y="60" width="40" height="40" href="https://place-puppy.com/700x300"/>
    <image x="0" y="30" width="50" height="70" href="https://place-puppy.com/800x500"/>
</svg>
```

Sweet, we've got some images in there. But what about positioning? At the moment our images are a different aspect ratio to the boxes we've defined. If we were in HTML-land we'd be reaching for `background-size:cover` now, but although SVG has a lot of shared properies with CSS, this isn't one of them.

Instead we have `preserveAspectRatio`. [This is a great article](https://css-tricks.com/scale-svg/) from Amelia Bellamy-Royds if you want to dig into it a bit more.

This is the value we need.

```svg
<svg viewBox="0 0 100 100">
    <image preserveAspectRatio="xMidYMid slice" x="30" y="0" width="70" height="50" href="https://place-puppy.com/300x300"/>
</svg>
```

`xMidYMid` will position the image in the center of the x and y axis, and `slice` says 'scale this up until it fills the container, slicing off any excess'

The default value is `xMidYMid meet` which is like `background-size:contain`. Here's a little demo so you can see what's going on.

## Clipping and animation [permalink](#heading-clipping-and-animation)

To 'swipe' our images in we're going to use a `clipPath` - another awesome thing which SVG has at our disposal.

I like thinking of clipping as a bit like cutting out, the clip path uses the geometry of any child element to clip the element (or elements) it's applied to. Everything outside of the clip path will be clipped and therefore invisible.

Here's an example using a circle clip path.

```svg
<svg viewBox="0 0 100 100">
    <clipPath id="circleClipz">
        <circle cx="50" cy="50" r="40"/>
    </clipPath>
    <image clip-path="url(#circleClipz)" x="10" y="10" width="80" height="80" href="https://place-puppy.com/300x300"/>
</svg>
```

In this case the clip path is a rectangle of the same dimensions as the image - so the whole image will be visible... until we animate it.

```svg
<svg viewBox="0 0 100 100"><clipPath id="blueClip"">    <!-- everything outside this rectangle will be clipped -->
    <rect x="10" y="10" width="80" height="80"/>
</clipPath>  <image clip-path="url(#blueClip)" x="10" y="10" width="80" height="80" href="https://place-puppy.com/300x300"/></svg>
```

When we change the position of the `<rect>` within the clip path our image 'swipes' in and out. You can adjust this range input to see the animated clip in effect.

## The final animation [permalink](#heading-the-final-animation)

I use [Greensock](https://greensock.com/) for most of my animation because it makes sequencing animations a breeze and when working with SVG, I know I can rely on the transforms working consistently cross browser. But this is a nice short animation, so if you wanted you could certainly do this with CSS instead.

Here's the final codepen if you want to dig into it!

[Codepen cassie-codes/mdRbGzO](https://codepen.io/cassie-codes/pen/mdRbGzO)

Got any questions about this article? [Just pop me a message!](https://twitter.com/cassiecodes)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
