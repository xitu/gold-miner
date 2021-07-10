> * 原文地址：[Can We Create a “Resize Hack” With Container Queries?](https://css-tricks.com/can-we-create-a-resize-hack-with-container-queries/)
> * 原文作者：[Jhey Tompkins](https://css-tricks.com/author/jheytompkins/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/can-we-create-a-resize-hack-with-container-queries.md](https://github.com/xitu/gold-miner/blob/master/article/2021/can-we-create-a-resize-hack-with-container-queries.md)
> * 译者：
> * 校对者：

# Can We Create a “Resize Hack” With Container Queries?

If you follow new developments in CSS, you’ve likely heard of the impending arrival of **container queries**. We’re going to look at the basics here, but if you’d like another look, check out Una’s [“Next Gen CSS: @container”](https://css-tricks.com/next-gen-css-container/) article. After we have a poke at the basics ourselves, we’re going to build something super fun with them: a fresh take on the classic CSS meme featuring Peter Griffin fussing with window blinds. ;)

So, what *is* a container query? It’s… exactly that. Much like we have media queries for querying things such as the viewport size, a container query allows us to query the size of a container. Based on that, we can then apply different styles to the children of said container.

What does it look like? Well, the exact standards are being worked out. Currently, though, it’s something like this:

```css
.container {
  contain: layout size;
  /* Or... */
  contain: layout inline-size;
}

@container (min-width: 768px) {
  .child { background: hotpink; }
}
```

The `layout` keyword turns on `layout-containment` for an element. `inline-size` allows users to be more specific about containment. This currently means we can only query the container’s `width`. With `size`, we are able to query the container’s `height`.

Again, we things *could* still change. At the time of writing, the only way to use container queries (without a [polyfill](https://github.com/jsxtools/cqfill)) is behind a flag in Chrome Canary (`chrome://flags`). I would definitely recommend having a quick read through the drafts over on [csswg.org](https://drafts.csswg.org/css-contain/#valdef-contain-layout).

The easiest way to start playing would be to whip up a couple quick demos that sport a resizable container element.

[CodePen jh3y/poeyxba](https://codepen.io/jh3y/pen/poeyxba)

[CodePen jh3y/zYZKEyM](https://codepen.io/jh3y/pen/zYZKEyM)

Try changing the `contain` values (in Chrome Canary) and see how the demos respond. These demo uses `contain: layout size` which doesn’t restrict the axis. When both the `height` and `width` of the containers meet certain thresholds, the shirt sizing adjusts in the first demo. The second demo shows how the axes can work individually instead, where the beard changes color, but only when adjusting the horizontal axis.

```css
@container (min-width: 400px) and (min-height: 400px) {
  .t-shirt__container {
    --size: "L";
    --scale: 2;
  }
}
```

That’s what you need to know to about container queries for now. It’s really just a few new lines of CSS.

The only thing is: most demos for container queries I’ve seen so far use a pretty standard “card” example to demonstrate the concept. Don’t get me wrong, because cards are a great use case for container queries. A card component is practically the poster child of container queries. Consider a generic card design and how it could get affected when used in different layouts. This is a common problem. Many of us have worked on projects where we wind up making various card variations, all catering to the different layouts that use them.

But cards don‘t inspire much to start playing with container queries. I want to see them *pushed* to greater limits to do interesting things. I‘ve played with them a little in that t-shirt sizing demo. And I was going to wait until there was better browser support until I started digging in further (I’m a [Brave](https://brave.com/) user currently). But then [Bramus](https://twitter.com/bramus) shared there was a container query polyfill!

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/can-we-create-a-resize-hack-with-container-queries-twiter-1.png)

And this got me thinking about ways to “hack” container queries.

⚠️ **Spoiler alert:** My hack didn’t work. It did momentarily, or at least I thought it did. But, this was actually a blessing because it prompted more conversation around container queries.

What was my idea? I wanted to create something sort of like the [“Checkbox Hack”](https://css-tricks.com/the-checkbox-hack/) but for container queries.

```html
<div class="container">
  <div class="container__resizer"></div>
  <div class="container__fixed-content"></div>
</div>
```

The idea is that you could have a container with a resizable element inside it, and then another element that gets fixed positioning outside of the container. Resizing containers could trigger container queries and restyle the fixed elements.

```css
.container {
  contain: layout size;
}

.container__resize {
  resize: vertical;
  overflow: hidden;
  width: 200px;
  min-height: 100px;
  max-height: 500px;
}

.container__fixed-content {
  position: fixed;
  left: 200%;
  top: 0;
  background: red;
}

@container(min-height: 300px) {
  .container__fixed-content {
    background: blue;
  }
}
```

Try resizing the red box in this demo. It will change the color of the purple box.

[CodePen jh3y/mdWylBW](https://codepen.io/jh3y/pen/mdWyLBW)

### Can we debunk a classic CSS meme with container queries?

Seeing this work excited me a bunch. Finally, an opportunity to create a version of the Peter Griffin CSS meme with CSS and debunk it!

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/05/giphy-downsized.gif?resize=640%2C480&ssl=1)

You’ve probably seen the meme. It’s a knock on the Cascade and how difficult it is to manage it. I created the demo using `cqfill@0.5.0`… with my own little touches, of course. 😅

[CodePen jh3y/LYxKjKX](https://codepen.io/jh3y/pen/LYxKjKX)

Moving the cord handle, resizes an element which in turn affects the container size. Different container breakpoints would update a CSS variable, `--open`, from `0` to `1`, where `1` is equal to an “open” and `0` is equal to a “closed” state.

```css
@container (min-height: 54px) {
  .blinds__blinds {
    --open: 0.1;
  }
}
@media --css-container and (min-height: 54px) {
  .blinds__blinds {
    --open: 0.1;
  }
}
@container (min-height: 58px) {
  .blinds__blinds {
    --open: 0.2;
  }
}
@media --css-container and (min-height: 58px) {
  .blinds__blinds {
    --open: 0.2;
  }
}
@container (min-height: 62px) {
  .blinds__blinds {
    --open: 0.3;
  }
}
@media --css-container and (min-height: 62px) {
  .blinds__blinds {
    --open: 0.3;
  }
}
```

But…. as I mentioned, this hack isn’t possible.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/can-we-create-a-resize-hack-with-container-queries-twiter-2.png)

What’s great here is that it prompted conversation around how container queries work. It also highlighted a bug with the container query polyfill which is now fixed. I would love to see this “hack” work though.

Miriam Suzanne has been creating some fantastic content around container queries. The capabilities have been changing a bunch. That’s the risk of living on the bleeding edge. One of [her latest articles](https://www.miriamsuzanne.com/2021/05/02/container-queries/) sums up the current status.

![](https://github.com/PassionPenguin/gold-miner-images/blob/master/can-we-create-a-resize-hack-with-container-queries-twiter-3.png)

Although my original demo/hack didn’t work, we can still kinda use a “resize” hack to create those blinds. Again, we can query `height` if we use `contain: layout size`. Side note: it’s interesting how we’re currently unable to use `contain` to query a container’s height based on resizing its child elements.

Anyway. Consider this demo:

[CodePen jh3y/jOBEKZO](https://codepen.io/jh3y/pen/jOBEKZO)

The arrow rotates as the container is resized. The trick here is to use a container query to update a scoped CSS custom property.

```css
.container {
  contain: layout size;
}

.arrow {
  transform: rotate(var(--rotate, 0deg));
}

@container(min-height: 200px) {
  .arrow {
    --rotate: 90deg;
  }
}
```

We‘ve kinda got a container query trick here then. The drawback with not being able to use the first hack concept is that we can’t go completely 3D. Overflow `hidden` will stop that. We also need the cord to go beneath the window which means the windowsill would get in the way.

But, we can almost get there.

[CodePen jh3y/qBrEMEe](https://codepen.io/jh3y/pen/qBrEMEe)

This demo uses a preprocessor to generate the container query steps. At each step, a scoped custom property gets updated. This reveals Peter and opens the blinds.

The trick here is to scale up the container to make the resize handle bigger. Then I scale down the content to fit back where it’s meant to.

---

This fun demo “debunking the meme” isn’t 100% there yet, but, we’re getting closer. Container queries are an exciting prospect. And it’ll be interesting to see how they change as browser support evolves. It’ll also be exciting to see how people push the limits with them or use them in different ways.

Who know? The “Resize Hack” might fit in nicely alongside the infamous “Checkbox Hack” one day.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
