> * 原文地址：[Things nobody ever taught me about CSS.](https://medium.com/@devdevcharlie/things-nobody-ever-taught-me-about-css-5d16be8d5d0e)
> * 原文作者：[Charlie Gerard](https://medium.com/@devdevcharlie)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/things-nobody-ever-taught-me-about-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/things-nobody-ever-taught-me-about-css.md)
> * 译者：
> * 校对者：

# Things nobody ever taught me about CSS.

![Photo by [Jantine Doornbos](https://unsplash.com/photos/xt9tb6oa42o?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/search/photos/css?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10396/1*fyXNSvbsWjSDxBxJp6sXIA.jpeg)

**This post is in no way a criticism of anybody I’ve ever worked with, it is only a quick list of important things I’ve learnt about CSS recently while doing some personal research.**

***

The fact that a lot of developers don’t seem to care that much about CSS is nothing new. You can observe it either by following conversations online or by talking to some friends and colleagues.

***

However, in the community, a lot of what we learn comes from knowledge sharing with peers and, as a result, I sometimes realise that there are essential things about CSS I’ve never been told before because other people never spent time trying to learn more.

To try to fix this, I decided to do some personal research and put together a small list of concepts I think are interesting and useful to better understand and write CSS.

**This list is definitely not exhaustive, it only contains new things I’ve learnt in the past few days and want to share in case it can help anybody else.**

## Terminology

***

As with every programming language, there are specific terms used to describe concepts. CSS being a programming language, it is no different and learning some terminology is important to help with communication or even just for your own personal knowledge.

### Descendant combinator

You know that little white space between selectors in your style? It actually has a name and its name is the **descendant combinator**.

![Descendant combinator](https://cdn-images-1.medium.com/max/3052/1*CsbGMDvUjClyCkDviUF_Aw.png)

### Layout, paint and composite

These terms have more to do with how the browser renders things but it is still important as some CSS properties will impact different steps of the rendering pipeline.

**1. Layout**

The layout step is the calculation of how much space an element takes when it is on the screen. Modifying a “layout” property in CSS (e.g: width, height) means that the browser is going to have to check all other elements and “reflow” the page, meaning repainting the affected areas and composite them back together.

**2. Paint**

This process is the one to fill pixels for every visual part of the elements (colors, borders, etc…). Drawing elements is usually done on multiple layers.

Changing a “paint” property does not affect the layout of the page so the browser skips the layout step but still does the paint.

Paint is often the most expensive part of the pipeline.

**3. Composite**

Compositing is the step where the browser needs to draw layers in the correct order. As some elements can overlap each other, this step is important to make sure elements appear in the order intended.

If you change a CSS property that requires neither layout or paint, then the browser only needs to do compositing.

For details on what different CSS properties trigger, you can have a look at [CSS Triggers](https://csstriggers.com/).

## CSS performance

***

### The descendant selector can be expensive

Depending on how large your application is, only using the descendant selector without more specificity can be really expensive. The browser is going to check every descendant element for a match because the relationship isn’t restricted to parent and child.

For example:

![Example of descendant selector](https://cdn-images-1.medium.com/max/2784/1*mr2okDdgwXotLVR9ig86_w.png)

The browser is going to assess all the links on the page before settling to the ones actually inside our `#nav` section.

A more performant way to do this would be to add a specific selector of `.navigation-link` on each `<a>` inside our `#nav` element.

### The browser reads selectors from right to left

I feel like I should have known this one because it sounds essential, but I didn’t…

When parsing CSS, the browser resolves CSS selectors from right to left.

If we look at the following example:

![The browser reads from right-to-left](https://cdn-images-1.medium.com/max/2512/1*Pi_wGtDAnY-u9cuaXwt7hA.png)

The steps taken are:

* match every `<a>` on the page.

* find every `<a>` contained in a `<li>`.

* use the previous matches and narrow down to the ones contained in a `<ul>`.

* Finally, filter down the above selection to the ones contained in an element with the class `.container`

Looking at these steps, we can see that the more specific the right selector is, the more efficient it will be for the browser to filter through and resolve CSS properties.

To improve the performance of the example above, we could replace `.container ul li a` with adding something like `.container-link-style` on the `<a>` tag itself.

### Avoid modifying layout wherever possible

Changes to some CSS properties will require the whole layout to be updated.

For example, properties like `width` , `height` , `top` , `left` (also referred to as “geometric properties”), require the layout to be calculated and the render tree to be updated.

If you change these properties on a lot of elements, it’s going to take a long time to calculate and update their position/dimension.

### Be careful of paint complexity

Some CSS properties (e.g: blur) are more expensive than others when it comes to painting. Think about potential other more effective ways to achieve the same result.

### Expensive CSS properties

Some CSS properties are more expensive than others. What this means is that they take longer to paint.

Some of these expensive properties include:

* `border-radius`

* `box-shadow`

* `filter`

* `:nth-child`

* `position: fixed`

It doesn’t mean you shouldn’t use them at all but it’s a matter of understanding that if an element uses some of these properties and will render hundreds of times, it will impact the rendering performance.

## Ordering

***

### Order in CSS files matters

If we look at the CSS below:

![](https://cdn-images-1.medium.com/max/2752/1*0uiYubMeRz5QRppeAM6x7A.png)

And then look at this HTML code:

![](https://cdn-images-1.medium.com/max/2952/1*-H7JKSQP_WRcwy3Z2GFmzQ.png)

The order of the selectors in HTML does not matter, the order of the selectors in the CSS file does.

A good way to assess the performance of your CSS is to use your browser’s developer tools.

***

If you’re using Chrome or Firefox, you can open the developer tools, go to the Performance tab and record what is going on when you load or interact with your page.

![Snapshot of what the Performance tab can give you on Chrome.](https://cdn-images-1.medium.com/max/6296/1*Quo30quEmkhn2BarZBsCQA.png)

## Resources

***

While doing some research for this post, I came across some really interesting tools listed below:

[CSS Triggers](https://csstriggers.com/) — a website listing some CSS properties and the performance impact of using and modifying these properties in your application.

[Uncss](https://github.com/uncss/uncss) — a tool to remove unused styles from CSS.

[Css-explain](https://github.com/josh/css-explain) — a small tool explaining CSS selectors.

[Fastdom](https://github.com/wilsonpage/fastdom) — a tool to batch DOM read/write operations to speed up layout performance.

That’s it for now! Hope it makes sense!

***

Thanks for reading! 🙏

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
