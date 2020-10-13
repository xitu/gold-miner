> * 原文地址：[clamp() for Responsive Design](https://calebhearth.com/clamp-for-responsive-design)
> * 原文作者：[Caleb Hearth](https://calebhearth.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/clamp-for-responsive-design.md](https://github.com/xitu/gold-miner/blob/master/article/2020/clamp-for-responsive-design.md)
> * 译者：
> * 校对者：

# clamp() for Responsive Design

CSS `clamp()` provides a method for setting numerical values with a minimum, maximum, and a calculated value between the two. The syntax is `calc([min], [calculated], [max])` and it’s useful for times when you want to scale some value based on the size of the screen by using the `vw` length unit.

This technique is useful when your goal is to have a design that is attractive across many different screen sizes. The usual option is to use media queries to style pages differently depending on the screen width. Doing so means that you define styles either “mobile-first” for small screens and scale up or “desktop-first” for large screens and scale down. By using `clamp()`, we can reduce our reliance on breakpoints, which need to be checked at many different widths for consistency, and replace them with known good largest and smallest values and a scaling range between them.

 [![A time series of a boat moving through a canal, first at a high water mark, then between the locks while the water level is lowered, then leaving the canal at the lower level.](/assets/canal-locks-c50accce1389ea47a5c85c8e9046c6876bf4593aa795a2064db6f53bb58cd260.png "A time series of a boat moving through a canal, first at a high water mark, then between the locks while the water level is lowered, then leaving the canal at the lower level.")](/assets/canal-locks-c50accce1389ea47a5c85c8e9046c6876bf4593aa795a2064db6f53bb58cd260.png) 

Canal locks allow boats to pass between bodies of water at different water levels

To understand how `clamp()` works, I like to use the metaphor of a canal lock. Canal locks use two walls that can be raised and lowered to allow boats to move over them. Once a boat is between the locks, water is either added from the high water side or drained to the low water side to raise or lower the water between the locks, respectively. This allows the boat to gently float with the water level and move between a minimum and maximum water level.

More concretely, `clamp(100%, calc(1em + 1vw), 200%)` would be equivalent to `max(100%, min(calc(1em + 1vw), 200%))`. The magic of course happens in the middle value, `calc(1em + 1vw)` where the width of the browser window (the “viewport width”) is used in the calculation. `1vw` is equal to 1/100th or 1% of the viewport width, so the result of 1em + 1/100th of the browser width allows the size to scale when the browser is resized.

Let’s take a look at how we might scale font-size. The above example is pretty close to what I’m currently using on this site:

```css
body {
  font-size: clamp(100%, calc(1rem + 2vw), 1.375rem);
}
```

Breaking that down, `100%` simply means “the current base size” which for font-size usually means 16px. `calc(1rem + 2vw)` uses root ems (again, 16px) plus 2/100ths of the viewport width as the calculation. `1.375rem` is a hard-coded value for my desired max size of 22px.

The support `clamp()`, as well as its correlated functions `min()` and `max()`, is pretty good at the time of this writing:

![Data on support for the css-math-functions feature across the major browsers from caniuse.com](https://caniuse.bitsofco.de/image/css-math-functions.jpg) 

[According to MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/clamp), `clamp()` should be useable anywhere you’d use a number, percentage, or other length unit. Strangely, when I tried to apply this approach to [`line-height`](https://blog.typekit.com/2016/08/17/flexible-typography-with-css-locks/) I found that Safari 14 seemed to support `line-height: clamp(...)` (I tried `@supports`), but was falling back to the base line-height, which was too cramped. I ended up using `line-height: min(calc(1.1em + 1vw), 32px)` to get responsive line-height locked down to roughly what the line height would be for my max content width. I don’t need to enforce a minimum here because at no width I tested was the value too small, but if I did, I could wrap the whole thing in `max()`: `line-height: max(100%, min(calc(1.1em + 1vw), 32px))`.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
