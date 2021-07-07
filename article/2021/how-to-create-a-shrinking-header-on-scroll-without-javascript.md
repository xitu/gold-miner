> * 原文地址：[How to Create a Shrinking Header on Scroll Without JavaScript](https://css-tricks.com/how-to-create-a-shrinking-header-on-scroll-without-javascript/)
> * 原文作者：[Håvard Brynjulfsen](https://css-tricks.com/author/havardbrynjulfsen/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-create-a-shrinking-header-on-scroll-without-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-to-create-a-shrinking-header-on-scroll-without-javascript.md)
> * 译者：
> * 校对者：

# How to Create a Shrinking Header on Scroll Without JavaScript

Imagine a header of a website that is nice and thick, with plenty of padding on top and bottom of the content. As you scroll down, it shrinks up on itself, reducing some of that padding, making more screen real estate for other content.

Normally you would have to use some JavaScript to add a shrinking effect like that, but there’s a way to do this using only CSS since the introduction of `position: sticky`.

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/02/1s0Ea8DEbYPwwbzrt3C1g4g.gif?resize=1000%2C646&ssl=1)

![](https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/02/1s0Ea8DEbYPwwbzrt3C1g4g.gif?resize=1000%2C646&ssl=1)

Let me just get this out there: I’m generally not a fan of sticky headers. I think they take up too much of the screen’s real estate. Whether or not *you* should use sticky headers on your own site, however, is a different question. It really depends on your content and whether an ever-present navigation adds value to it. If you do use it, take extra care to avoid inadvertently covering or obscuring content or functionality with the sticky areas — that amounts to [data loss](https://css-tricks.com/overflow-and-data-loss-in-css/).

Either way, here’s how to do it *without* JavaScript, starting with the markup. Nothing complicated here — a `<header>` with one descendant `<div>` which, in turn, contains the logo and navigation.

```html
<header class="header-outer">
    <div class="header-inner">
        <div class="header-logo">...</div>
        <nav class="header-navigation">...</nav>
    </div>
</header>
```

As far as styling, we’ll declare a height for the parent `<header>` (120px) and set it up as a flexible container that aligns its descendant in the center. Then, we’ll make it sticky.

```css
.header-outer {
    display: flex;
    align-items: center;
    position: sticky;
    height: 120px;
}
```

The inner container contains all the header elements, such as the logo and the navigation. The inner container is in a way the *actual header*, while the only function of the parent `<header>` element is to make the header taller so there’s something to shrink from.

We’ll give that inner container, `.header-inner`, a height of 70px and make it sticky as well.

```css
.header-inner {
    height: 70px;
    position: sticky;
    top: 0;
}
```

That `top: 0`? It’s there to make sure that the container mounts itself at the very top when it becomes sticky.

Now for the trick! For the inner container to actually stick to the “ceiling” of the page we need to give the parent `<header>` a *negative* `top` value equal to the height difference between the two containers, making it stick “above” the viewport. That’s 70px minus 120px, leaving with with — drumroll, please — -50px. Let’s add that.

```css
.header-outer {
    display: flex;
    align-items: center;
    position: sticky;
    top: -50px; /* Equal to the height difference between header-outer and header-inner */
    height: 120px;
} 
```

Let’s bring it all together now. The `<header>` slides out of frame, while the inner container places itself neatly at the top of the viewport. [Please check this Codepen](https://codepen.io/havardob/pen/KKgEJep).

We can extend this to other elements! How about a persistent alert? [Please check this Codepen](https://codepen.io/havardob/pen/KKgYjZN).

While it’s pretty awesome we can do this in CSS, it does have limitations. For example, the inner and outer containers use fixed heights. This makes them vulnerable to change, like if the navigation elements wrap because the number of menu items exceeds the amount of space.

Another limitation? The logo can’t shrink. This is perhaps the biggest drawback, since logos are often the biggest culprit of eating up space. Perhaps one day we’ll be able to apply styles based on the stickiness of an element…

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
