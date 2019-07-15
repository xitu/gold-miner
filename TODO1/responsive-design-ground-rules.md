> * 原文地址：[Responsive design ground rules](https://polypane.rocks/blog/responsive-design-ground-rules/)
> * 原文作者：[Polypane](https://polypane.rocks/blog/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/responsive-design-ground-rules.md](https://github.com/xitu/gold-miner/blob/master/TODO1/responsive-design-ground-rules.md)
> * 译者：
> * 校对者：

# Responsive design ground rules

Creating a responsive design can be intimidating. There are many moving parts, things might lay out in ways you didn't expect and keeping all various viewports in mind when laying out a design can be daunting. With these ground rules, your responsive designs will be more robust and predictable.

## Rule #1: Keep your viewport simple

Back when the viewport meta tag was first introduced, common knowledge was you had to add in all sorts of values to prevent users from resizing and to have a minimum and maximum screen size. It turns out that doing that is actually hostile to your users.

You really only want two things: set the width to the device your site is shown on, and make sure the initial scale is 1, which means that 1 pixel in your CSS equals one device-independent pixel, like this:

```
<meta name="viewport" content="width=device-width, initial-scale=1">
```

## Rule #2: Mobile first

You develop websites on a large laptop or desktop screen, and usually your client is most interested in the desktop design of a website, so it might feel natural to just start with the design for the desktop site and then work your way down. But starting mobile first is actually easier and will result in less code.

If you build mobile first, you're building up your CSS in complexity. What I mean with that is that your mobile views are usually much simpler and thus require less CSS. They almost always have just a single column, and lack many of the additional flourishes you have space for on larger screens. If you build mobile-first, this means that, as you add styling for larger and larger media queries, you're **adding** to the design.

If you start desktop first, you already have all this styling that you then need to write **more** CSS for just to undo your more advanced desktop styling. So you're writing more CSS and if you're not carefully undoing all CSS, you end up with things like horizontal overflowing or text not fitting.

With mobile first, you save a large chunk of CSS you simply **don't have to write**, making it smaller and your website faster.

## Rule #3: Design from content out

To determine where your breakpoint will be, you can opt to use values like 320px, 375px, 768px and 1024px, which all map to various real device widths. Basically, design for specific devices. But when new devices become more popular **(#375IsTheNew320)** your design might not look so good on those devices.

[Stephen Hay](http://the-haystack.com/), who wrote the book on [responsive design workflows](http://www.peachpit.com/store/responsive-design-workflow-9780321887863), advices you to start with your small screen, then "expand until it looks like shit. Time for a breakpoint!"

This focus on the content will force you to think of websites as inherently fluid. You can't design only your pixel perfect widths, because **they don't exist**.

Quick rule of thumb: you want your line lengths to be around 70 characters long. That translates (depending on the font!) to about 36 to 40 em.

## Rule #4: Use ems in your media queries

With specific device widths no longer mattering, you should also switch out those breakpoint widths in pixels, to **widths in ems**. Your media queries are based on the content so this will let your site look great even for people that have made their browsers base font-size larger or smaller or have zoomed in their browser.

The rest of your design will properly adjust to this and make your site more robust.

## Rule #5: Min-width or max-width, pick one

Responsive design makes for an incredibly complex system. When your media queries use both min-width and max-width, or even combinations of them, you're massively increasing that complexity and reasoning about it becomes even harder.

If all your media queries work "up" or "down", you always know where to look when your site doesn't look as you expect it to at a certain size. CSS in new media queries you write will then never influence your earlier sizes. Just find out from which media query down (or up) you need to update your CSS.

## Rule #6: Avoid fixed dimensions

It can be very tempting to use fixed dimensions for elements. After all, your favorite hand-off tool probably lets you copy them with ease. Elements with fixed widths (or margins) could easily break your layout if you're not careful.

Try to style element sizes in relation to their surroundings. Use percentages or viewport units. Prevent setting `width` and `height` and try to use their `min-` and `max-` counterparts. And if you do end up with a `width` breaking something somewhere, a `max-width:100%`can work wonders.

## Rule #7: Use modern layout techniques

To expand on the previous rule, modern layout methods like Flexbox and CSS Grid are built to be inherently flexible and size according to their surroundings. If you make use of these layout methods, you'll end up needing less media queries to achieve the same design. Less media queries means less to reason about, and your code's shorter to boot.

A great way to (re-)learn how to build common layouts with Flexbox and CSS Grid is [Every-layout.dev](https://every-layout.dev/). It lists comon layouts and explains how to build them using modern techniques.

## Rule #8: Leave room for text rendering differences

It's tempting to create breakpoints right at the place where an unfavorable line-break occurs. To get that "pixel perfect". Of course we know the web isn't pixel perfect, and it never was.

If your breakpoints are too close to readable line breaks, then it might work in **your** browser, but different browsers and different operating systems have different ways of rendering text, which means that the line of text might be a couple of pixel wider or smaller,, and your design could break.

Instead, try to be a little bit loose with your media queries, leave a little space for things to be off by a few pixels before big changes in your design.

## Rule #9: Decide in the browser

To follow these rules, it doesn't make sense to create all your breakpoints in a design tool. On the other hand, designing the entire site in a browser is difficult too. So what's the happy medium?

Create your designs in a design tool, with some rough responsive variants, but keep the choice of **when** to switch over to another design for when you're actually working in the browser. The Sketch artboard might be 750px wide, but if you're in the browser and the layout already makes more sense at 44em (that's 704 pixels), then use `44em` in your css.

## Rule #10: Give Polypane a try

With Polypane, creating sites and apps in a mobile-first, content-out way comes naturally. Start with a single pane and design your smallest screen. Then add a new pane, and widen it until, to quote Stephen, it "looks like shit". Then check the width of the pane and use that `em` value as your new breakpoint. Style it and repeat.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
