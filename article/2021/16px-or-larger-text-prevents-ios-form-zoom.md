> * 原文地址：[16px or Larger Text Prevents iOS Form Zoom](https://css-tricks.com/16px-or-larger-text-prevents-ios-form-zoom/)
> * 原文作者：[Chris Coyier ](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/.md](https://github.com/xitu/gold-miner/blob/master/article/2021/.md)
> * 译者：
> * 校对者：

# 16px or Larger Text Prevents iOS Form Zoom

This was a great [“Today I Learned” for me from Josh W. Comeau](https://twitter.com/joshwcomeau/status/1379782931116351490?s=12). If the `font-size` of an `<input>` is 16px or larger, Safari on iOS will focus into the input normally. But as soon as the `font-size` is 15px or less, the viewport will zoom into that input. Presumably, because it considers that type too small and wants you to see what you are doing. So it zooms in to help you. Accessibility. If you don’t want that, make the font big enough.

[Here’s Josh’s exact Pen](https://codepen.io/joshwcomeau/pen/VwPMPZo) if you want to have a play yourself.

In general, I’d say I like this feature. It helps people see what they are doing and discourages super-tiny font sizes. What is a slight bummer — and I really don’t blame anyone here — is that not all typefaces are created equal in terms of readability at different sizes. For example, here’s San Francisco versus Caveat at 16px.

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/04/Screen-Shot-2021-04-30-at-9.11.55-AM.png?resize=558%2C344&ssl=1)

![](https://i2.wp.com/css-tricks.com/wp-content/uploads/2021/04/Screen-Shot-2021-04-30-at-9.11.55-AM.png?resize=558%2C344&ssl=1)

<small>San Francisco on the left, Cavet on the right. Caveat looks visually much smaller even though the `font-size` is the same.</small>

You can view [that example](https://codepen.io/chriscoyier/pen/MWJxXWz) in [Debug Mode](https://cdpn.io/chriscoyier/debug/MWJxXWz) to see for yourself and change the font size to see what does and doesn’t zoom.

---

> Fire Set your form inputs to have a font-size of 1rem (16px) or larger to prevent iOS Safari from automatically zooming in when tapped.
> 
> Makes such a big difference from a UX perspective!
> 
> [comment]: <> (Original Video Link: https://video.twimg.com/tweet_video/EyX2MSaXMAExyQA.mp4)
> 
> ![](https://github.com/PassionPenguin/gold-miner-images/blob/master/16px-or-larger-text-prevents-ios-form-zoom-EyX2MSaXMAExyQA.gif?raw=true)
> 
> —— Josh W. Comeau @JoshWComeau 9:07, Apr 7, 2021
> 
> ---
>
> When Safari zooms in, it seems to aim for an effective 16px font size. In both clips, the user is seeing 16px input text as they type. So we're not actually making the inputs harder to read with this change!
> 
> Plus, folks can always manually zoom in as-needed.
> 
> ![](https://pbs.twimg.com/media/EyX5HAlXEAErIj6?format=png&name=small)
> 
> ![](https://pbs.twimg.com/media/EyX5IBWWUAA8Sis?format=png&name=small)
> 
> —— Josh W. Comeau @JoshWComeau 9:07, Apr 7, 2021

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
