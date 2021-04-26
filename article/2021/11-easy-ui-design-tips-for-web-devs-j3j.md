> * 原文地址：[11 Easy UI Design Tips for Web Devs](https://dev.to/doabledanny/11-easy-ui-design-tips-for-web-devs-j3j)
> * 原文作者：[Danny Adams](https://dev.to/doabledanny)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/11-easy-ui-design-tips-for-web-devs-j3j.md](https://github.com/xitu/gold-miner/blob/master/article/2021/11-easy-ui-design-tips-for-web-devs-j3j.md)
> * 译者：
> * 校对者：

![Cover image](https://res.cloudinary.com/practicaldev/image/fetch/s--xHif6hhs--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/b33yd1o2sxrm8wvfbm1b.jpg)

# 11 Easy UI Design Tips for Web Devs

Whilst learning web development, most of us don’t have much design experience or access to a UI designer. So here are 11 easy to apply UI design fundamentals to make your projects look sleek and modern.

This article was originally posted on my personal blog, [DoableDanny.com](https://www.doabledanny.com/UI-Design-Tips-for-Web-Devs). If you enjoy the article, consider subscribing to my [YouTube channel](https://www.youtube.com/channel/UC0URylW_U4i26wN231yRqvA)!

## 1. Be consistent

[![consistency example](https://res.cloudinary.com/practicaldev/image/fetch/s--JCUuNeJ5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/y94y3colvzfiih57bolk.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--JCUuNeJ5--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/y94y3colvzfiih57bolk.png)

In the top image you can see that the icons have different styles and colours:

* The calendar icon has some green and a grey outline.
* The lock icon has a solid orange circle around it and is white filled with no outline.
* The thumbs up has a thin black outline and smoother lines.

There is no consistent theme - different shapes, colors, sizes and outline thicknesses.

In the bottom image, the icons look to be from the same icon set. They all have a simple dark grey outline and that’s about it. The icons also have the same height and width.

In the bottom image, the text is left aligned, and so are the icons. I also could've centred the text and put each icon over the centre. Both are fine - consistency is key.

Rule of thumb is to left-align any longer form text e.g. a blog post, as it’s easier to read. For shorter amounts of text, you can left-align or centre.

## 2. Use quality images

[![clipart vs quality image](https://res.cloudinary.com/practicaldev/image/fetch/s--h5JqDvUv--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vfdpbqclz1qgfhqin020.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--h5JqDvUv--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/vfdpbqclz1qgfhqin020.png)

Clipart may have been great back when you were 10 years old, but using stuff like that now looks extremely unprofessional.

Professional images can be downloaded and used in your projects completely free from [https://www.unsplash.com](https://www.unsplash.com).

## 3. Contrast

[![text is easily readable on background image](https://res.cloudinary.com/practicaldev/image/fetch/s--4Qo6ujyj--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/heicl1riiwipqchivyw6.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--4Qo6ujyj--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/heicl1riiwipqchivyw6.png)

If your background is light, use dark text. If dark, use light text. Simple enough. A problem I see quite often on websites is when people use colourful images as a background with light and dark spots and then plonk some text on top. It’s often difficult to read.

Solutions:

1. Use an image overlay e.g. if you are using light coloured text, place over the image a dark coloured overlay (a semi-transparent div with background-color using rgba) and reduce the opacity down to darken the appearance of the image and make the light text clearer. Remember to give the text a higher z-index than the overlay so it sits on top!
2. Choose an image like above, where there is a nice consistent coloured section to place your text.

Also, notice how the logo in the nav bar is aligned vertically with the left edge of the text and “start my journey” call to action button… now that’s consistency! It's key to a sleek looking design.

## 4. Whitespace

[![poor vs good whitespace](https://res.cloudinary.com/practicaldev/image/fetch/s--jb9nZWm2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/iwg0sh21rcw44tboskgk.jpg)](https://res.cloudinary.com/practicaldev/image/fetch/s--jb9nZWm2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/iwg0sh21rcw44tboskgk.jpg)

In the top image, the “SomeCompany” logo at the top has less space to its left than the right-most nav link has to its right. In the bottom, we can see the space is roughly equal.

The paragraph of text in the top image is cramped up too close to the heading and call to action button. In the bottom, it has more breathing room.

We can also see that the heading is closer to the paragraph than it is to the logo. Stuff that is closely related should be closer together… but not stupid close.

## 5. Visual hierarchy – size matters

Your eyes are probably drawn to “The Road Less Travelled” in the image from tip 4. Obviously because it is bigger. It is also bolder. Attention can also be demanded by colour e.g. the “start my journey” button.

A common mistake is to make the nav logo too big, or the nav links stand out too much with colour.

We want the users attention directed towards the content, not the logo and nav links.

## 6. One font is fine!

[![bad vs good font](https://res.cloudinary.com/practicaldev/image/fetch/s--SvQoT7fR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/io6mymdjufk8m11zwlr6.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--SvQoT7fR--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/io6mymdjufk8m11zwlr6.png)

It is fine to use just one font. No need to overcomplicate. Just avoid “Times new roman” (it’s overused) and “Comic sans” (it just looks naff!?).

Nunito, Helvetica or sans serif are pretty nice modern looking fonts.

You can still use a second font for headings if your design looks a little too boring (check out the title of this blog post!).

For font sizes, 18px to 21px are common for paragraphs.

## 7. Tints and shades

[![altering contrast of text](https://res.cloudinary.com/practicaldev/image/fetch/s--Kv7iUmyD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ehtbk36cscfa1nqm6yu7.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--Kv7iUmyD--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/ehtbk36cscfa1nqm6yu7.png)

Use few colours. Too many colours can look noisy and unprofessional, especially if you don’t know what you’re doing. Keep it simple.

Pick a base colour and just use tints (add white) and shades (add black) for variation.

Then pick one primary “call to action” colour for areas that should stand out. Check out the “complementary colour scheme”.

I use [coolors](https://coolors.co/330088) to find complimentary colours and to get tints and shades.

## 8. Round vs sharp

[![speech bubble](https://res.cloudinary.com/practicaldev/image/fetch/s--qyVtATCJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/o69k4gosugpsc0xtrhhv.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--qyVtATCJ--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/o69k4gosugpsc0xtrhhv.png)

Sharp corners and edges draw your attention. Think the sharp part of a speech bubble.

What can we do with this knowledge? Round out the corners of your buttons. Why would you want to draw attention to the corners of the button?

## 9. Borders are so last year

[![border vs no border](https://res.cloudinary.com/practicaldev/image/fetch/s--BwZtt2Qa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jtarukxei807yi5cij02.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--BwZtt2Qa--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/jtarukxei807yi5cij02.png)

In the old days of the web, borders were everywhere. Nowadays, it’s better to not use them quite as much – it often looks cleaner. Borders can look a little overkill.

Obviously don’t become completely anti-border, they are still great for separating things. Just don’t make them too thick and attention grabbing.

## 10. Don't underline nav-bar links

[![underline vs none](https://res.cloudinary.com/practicaldev/image/fetch/s--DIBnjFhK--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rv79dgu4btx374uwj412.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--DIBnjFhK--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/rv79dgu4btx374uwj412.png)

It’s pretty old school. It looks cleaner without them.

Underline/change the colour or size on mouse hover and keyboard focus for accessibility.

You should still underline links in a body of text for good accessibility - it makes it obvious they are links. Just avoid underlining text that isn't a link.

## 11. Download a design software

I used to begin coding up a project with little to no plan of how I wanted it to look. It took me ages to code everything with trial and error for colours and positioning of elements.

You can iterate through ideas much quicker using design software. I now use AdobeXD (free) to just drag and drop things in place and quickly get a nice design ready to be coded. Figma is also popular but not free.

## Awesome References

* The psychology of persuasive web design: [https://www.doabledanny.com/persuasive-web-design](https://www.doabledanny.com/persuasive-web-design)
* Turn a bad design into a good one: [https://www.youtube.com/watch?v=0JCUH5daCCE&t=112s](https://www.youtube.com/watch?v=0JCUH5daCCE&t=112s)
* Amazing UI tips: [https://medium.com/refactoring-ui/7-practical-tips-for-cheating-at-design-40c736799886](https://medium.com/refactoring-ui/7-practical-tips-for-cheating-at-design-40c736799886)
* The science of great UI: [https://www.youtube.com/watch?v=nx1tOOc_3fU](https://www.youtube.com/watch?v=nx1tOOc_3fU)

If you enjoyed this article, you can say thanks by subscribing to my [YouTube channel](https://www.youtube.com/channel/UC0URylW_U4i26wN231yRqvA) or signing up to [my blog](https://www.doabledanny.com/blog/) to be notified of new posts 🙏

Also, feel free to connect with me on [Twitter](https://twitter.com/DoableDanny)!

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
