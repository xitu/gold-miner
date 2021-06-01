> * 原文地址：[Next Gen CSS: @container](https://css-tricks.com/next-gen-css-container/)
> * 原文作者：[Una Kravets](https://css-tricks.com/author/unakravets/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/next-gen-css-containermd](https://github.com/xitu/gold-miner/blob/master/article/2021/next-gen-css-container.md)
> * 译者：
> * 校对者：

# Next Gen CSS: @container

Chrome is experimenting with `@container`, a property within the CSS Working Group [Containment Level 3 spec](https://github.com/w3c/csswg-drafts/issues?q=is%3Aissue+label%3Acss-contain-3+) being championed by [Miriam Suzanne](https://twitter.com/TerribleMia) of [Oddbird](https://css.oddbird.net/rwd/query/), and a group of engineers across the web platform. `@container` brings us the ability to **style elements based on the size of their parent container**.

The `@container` API is not stable, and is subject to syntax changes. If you try it out on your own, you may encounter a few bugs. Please report those bugs to the appropriate browser engine!

**Bugs:** [Chrome](https://bugs.chromium.org/p/chromium/issues/list) | [Firefox](https://bugzilla.mozilla.org/home) | [Safari](https://bugs.webkit.org/query.cgi?format=specific&product=WebKit)

You can think of these like a media query (`@media`), but instead of relying on the **viewport** to adjust styles, the parent container of the element you’re targeting can adjust those styles.

## Container queries will be the single biggest change in web styling since CSS3, altering our perspective of what “responsive design” means.

No longer will the viewport and user agent be the only targets we have to create responsive layout and UI styles. With container queries, elements will be able to target their own parents and apply their own styles accordingly. This means that the same element that lives in the sidebar, body, or hero could look completely different based on its available size and dynamics.

## `@container` in action

In [this example](https://codepen.io/una/pen/LYbvKpK), I’m using two cards within a parent with the following markup:

```html
<div class="card-container">
    <div class="card">
        <figure> ...</figure>
        <div>
            <div class="meta">
                <h2>...</h2>
                <span class="time">...</span>
            </div>
            <div class="notes">
                <p class="desc">...</p>
                <div class="links">...</div>
            </div>
            <button>...</button>
        </div>
    </div>
</div>
```

Then, I’m setting containment (the [`contain` property](https://css-tricks.com/almanac/properties/c/contain/)) on the parent on which I’ll be querying the container styles (`.card-container`). I’m also setting a relative grid layout on the parent of `.card-container`, so its `inline-size` will change based on that grid. This is what I’m querying for with `@container`:

```css
.card-container {
  contain: layout inline-size;
  width: 100%;
}
```

Now, I can query for container styles to adjust styles! This is very similar to how you would set styles using width-based media queries, using `max-width` to set styles when an element is *smaller* than a certain size, and `min-width` when it is *larger*.

```css
/* when the parent container is smaller than 850px, 
remove the .links div and decrease the font size on 
the episode time marker */

@container (max-width: 850px) {
  .links {
    display: none;
  }

  .time {
    font-size: 1.25rem;
  }

  /* ... */
}

/* when the parent container is smaller than 650px, 
decrease the .card element's grid gap to 1rem */

@container (max-width: 650px) {
  .card {
    gap: 1rem;
  }

  /* ... */
}
```

![1](https://user-images.githubusercontent.com/5164225/120361018-f670b380-c33b-11eb-8c42-38fdbb1b5a8a.gif)

## Container Queries + Media Queries

One of the best features of container queries is the ability to separate *micro layouts* from *macro layouts*. You can style individual elements with container queries, creating nuanced micro layouts, and style entire page layouts with media queries, the macro layout. This creates a new level of control that enables even more responsive interfaces.

Here’s [another example](https://codepen.io/una/pen/RwodQZw) that shows the power of using media queries for macro layout (i.e. the calendar going from single-panel to multi-panel), and micro layout (i.e. the date layout/size and event margins/size shifting), to create a beautiful orchestra of queries.

![2](https://user-images.githubusercontent.com/5164225/120361024-f8d30d80-c33b-11eb-8bed-4b367965f7be.gif)

## Container Queries + CSS Grid

One of my personal favorite ways to see the impact of container queries is to see how they work within a grid. Take the following example of a plant commerce UI:

![3](https://user-images.githubusercontent.com/5164225/120361028-fa9cd100-c33b-11eb-8328-148977357c44.gif)

No media queries are used on this website at all. Instead, we are only using container queries along with CSS grid to display the shopping card component in different views.

In the product grid, the layout is created with `grid-template-columns: repeat(auto-fit, minmax(230px, 1fr));`. This creates a layout that tells the cards to take up the available fractional space until they hit `230px` in size, and then to flow to the next row. Check out more grid tricks at [1linelayouts.com](http://1linelayouts.glitch.me).

Then, we have a container query that styles the cards to take on a vertical block layout when they are less than `350px` wide, and shifts to a horizontal inline layout by applying `display: flex` (which has an inline flow by default).

```css
@container (min-width: 350px) {
  .product-container {
    padding: 0.5rem 0 0;
    display: flex;
  }

  /* ... */
}
```

This means that each card *owns its own responsive styling*. This yet another example of where you can create a macro layout with the product grid, and a micro layout with the product cards. Pretty cool!

## Usage

In order to use `@container`, you first need to create a parent element that has [containment](https://developer.mozilla.org/en-US/docs/Web/CSS/contain). In order to do so, you’ll need to set `contain: layout inline-size` on the parent. You can use `inline-size` since we currently can only apply container queries to the inline axis. This prevents your layout from breaking in the block direction.

Setting `contain: layout inline-size` creates a new [containing block](https://developer.mozilla.org/en-US/docs/Web/CSS/Containing_block) and new [block formatting context](https://developer.mozilla.org/en-US/docs/Web/Guide/CSS/Block_formatting_context), letting the browser separate it from the rest of the layout. Now, we can query!

## Limitations

Currently, you cannot use height-based container queries, using only the block axis. In order to make grid children work with `@container`, you’ll need to add a wrapper element. Despite this, adding a wrapper lets you still get the effects you want.

## Try it out

You can experiment with the `@container` property in Chromium today, by navigating to: `chrome://flags` in [Chrome Canary](https://www.google.com/chrome/canary/) and turning on the **#experimental-container-queries** flag.

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/05/chrome-canary-conatiner-query-flag.png?resize=1902%2C1510&ssl=1)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
