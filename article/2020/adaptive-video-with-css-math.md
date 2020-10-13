> * 原文地址：[Adaptive video with CSS Math](https://medium.com/@yokselzok/adaptive-video-with-css-math-d71640c6068a)
> * 原文作者：[Йоксель Зок](https://medium.com/@yokselzok)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/adaptive-video-with-css-math.md](https://github.com/xitu/gold-miner/blob/master/article/2020/adaptive-video-with-css-math.md)
> * 译者：
> * 校对者：

# Adaptive video with custom properties and CSS Math

When I was digging into [CSS math functions](https://www.w3.org/TR/css-values-4/#calc-notation), I had thought about responsive iframes. Some solutions already exist, like [this](https://css-tricks.com/fluid-width-video/), but there we need to use an additional wrapper or JS. What if we could achieve the same behaviour without wrapper and with pure CSS?

First we need to get aspect ratio. We can’t get them from attributes (this approach [exists](https://www.w3.org/TR/css-values-3/#attr-notation) in spec, but is not supported by browsers), so need to use custom properties:

```HTML
<iframe
    width="560" height="315"
    style="--width: 560; --height: 315;"
    class="video"
    ...
></iframe>
```

Width and height in custom properties must be used without px, otherwise we can’t calculate aspect ratio from these values.

Second we need to calculate aspect ratio:

```css
.video {
  --aspect-ratio: calc(var(--height) / var(--width));
}
```

And to add units to height:

```css
.video {
  --aspect-ratio: calc(var(--height) / var(--width));
  --height-with-units: calc(var(--height) * 1px);
}
```

On mobile iframe must fit to window, so I added this:

```css
.video {
  --aspect-ratio: calc(var(--height) / var(--width));
  --height-with-units: calc(var(--height) * 1px);
  
  max-width: 100%;
}
```

The last step is a little tricky, but not too much. On mobile devices iframe will be squeezed by width, but how we can get actual width? If iframe is stretched to page width, the page width will be approximately equal to window width, so we can use viewport units to express width of iframe, it will be equal to `100vw`. Using actual iframe width and aspect ratio we can calculate height like this:

```css
calc(100vw * var(--aspect-ratio))
```

But this expression will works only for mobile where width of iframe is equal to window width, what about desktop? Let’s add some CSS math to get appropriate height for iframe depending on screen size. I used `min()` to choose which of heights fits better:

```css
height: min(calc(100vw * var(--aspect-ratio)), var(--height-with-units));
```

If height, calculated from `100vw` is bigger than initial height, `min()` will choose initial height and iframe will not grow more. On the contrary, if height, calculated from `100vw` is less than initial height, `min()` will choose calculated height and iframe will be squeezed by height.

Final CSS:

```CSS
.video {
  /* Get aspect ratio */
  --aspect-ratio: calc(var(--height) / var(--width));
  /* Add units to height */
  --height-with-units: calc(var(--height) * 1px);

  max-width: 100%;

  /* Get minimal of initial height
     or height calculated from window width */
  height: min(calc(100vw * var(--aspect-ratio)), var(--height-with-units));
}
```

Open [**live demo**](https://codepen.io/yoksel/pen/oNxmgYq?editors=0100) and resize the window to see how it works.

**Note:** if you will try to use this code with preprocessors, they could not handle `min()` with different units. To force preprocessors ignore CSS math functions, in SCSS function name must be started with uppercase letter: `Min(…)` and for Less must be wrapped like this:`~”min(…)”`.

I did not use this solution on production, but I hope, it will be useful : )

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
