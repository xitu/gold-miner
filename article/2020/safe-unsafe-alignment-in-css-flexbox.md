> * 原文地址：[Safe/unsafe alignment in CSS flexbox](https://www.stefanjudis.com/today-i-learned/safe-unsafe-alignment-in-css-flexbox/)
> * 原文作者：[Stefan](https://www.stefanjudis.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/safe-unsafe-alignment-in-css-flexbox.md](https://github.com/xitu/gold-miner/blob/master/article/2020/safe-unsafe-alignment-in-css-flexbox.md)
> * 译者：
> * 校对者：

# Safe/unsafe alignment in CSS flexbox

I recently watched the talk [Making Things Better: Redefining the Technical Possibilities of CSS](https://aneventapart.com/news/post/making-things-better-aea-video) by [Rachel Andrews](https://twitter.com/rachelandrew). Rachel's talks are always full of useful information presented clearly and compactly. The talk included one line of CSS that I haven't seen before.

```css
.something {
  display: flex;
  // 👇 what is that? 😲 
  align-items: safe center;
}
```

## The CSS goal of data loss prevention

Rachel explains that when the CSS specs are written, one of the key priorities is to prevent data loss. I heard this phrase for the first time. How often do we face data loss in CSS and what is done to prevent it?

The goal of CSS is to keep content and elements visible to the visitor. CSS does that by design. Containers expand automatically to the right or the bottom depending on their content. They become scrollable when contents are overflowing. Unless you disable this behavior with an `overflow: hidden;` on an element, the user will be able to access the content.

I learned that when you use Flexbox there are situations in which the prevention of data loss is not guaranteed.

## Data loss in the context of CSS Flexbox

Let's say you have the following HTML:

```html
<div class="container">
  <span>CSS</span>
  <span>is</span>
  <span>awesome!</span>
</div>
```

paired with the following CSS:

```css
.container {
  display: flex;
  flex-direction: column;
  align-items: center;
}
```

The [align-items property](https://developer.mozilla.org/en-US/docs/Web/CSS/align-items) aligns child element centered along the cross axis. This is all great, but in case of a small container/viewport size we end up with a situation of data loss.

 [![Example of CSS align-items usage leading to data loss](//images.ctfassets.net/f20lfrunubsq/tX5IzlfIse4rtopH41xJY/2efc8dc4ca4d3e41da194292257fc02a/Screenshot_2020-05-17_19.54.42.png&fm=jpg)](//images.ctfassets.net/f20lfrunubsq/tX5IzlfIse4rtopH41xJY/2efc8dc4ca4d3e41da194292257fc02a/Screenshot_2020-05-17_19.54.42.png) 

Due to the flexbox alignment, the elements are centered no matter what. The child element overflow on the right and left side. The problem is that the overflowing area on the left side is past the viewport’s start edge. You can not scroll to this area – say hello to data loss.

This situation is where the `safe` keyword of the `align-items` property can help. [The CSS Box Alignment Module Level 3](https://drafts.csswg.org/css-align-3/#overflow-values) (still in draft state) defines safe alignment as follows:

> "Safe" alignment changes the alignment mode in overflow situations in an attempt to avoid data loss.

If you define `safe` alignment, the aligning elements will switch to `start` alignment in case of an overflowing situation.

```css
.container {
  display: flex;
  flex-direction: column;
  align-items: safe center;
}
```

 [![Safe alignment in CSS where an element switches to start alignment](//images.ctfassets.net/f20lfrunubsq/1Qx8RgAxrHdCzMHHLo8CBl/8a7e5b30e1a90ef8452d83c8668b65c8/Screenshot_2020-05-17_20.04.33.png&fm=jpg)](//images.ctfassets.net/f20lfrunubsq/1Qx8RgAxrHdCzMHHLo8CBl/8a7e5b30e1a90ef8452d83c8668b65c8/Screenshot_2020-05-17_20.04.33.png) 

`safe` alignment leads the browser to always place elements accessible to the user.

## Browser support of `safe` alignment

With only Firefox supporting the `safe` keyword [cross-browser support](https://developer.mozilla.org/en-US/docs/Web/CSS/align-items#Support_in_Flex_layout) is not given. **I wouldn't recommend using it today** because it is not falling back nicely. One could argue that the safe way should be the `align-items` default, but what can I say, CSS is hard. Writing CSS specs is even more complicated. 🤷🏻‍♂️

How can you prevent data loss today, though?

[Bramus Van Damme pointed out](https://twitter.com/bramus/status/1259776833589051392) that a `margin: auto;` on the flex children does the job even without the `safe` keyword. 🎉

### Problems that I didn't know I had

It never appeared to me that centered alignment could cause data loss. The described example shows how complex CSS specs and layout are. The people working on specs have my most profound respect!

And that's it for today, let's see when safe alignment makes it into cross-browser support. 👋🏻

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
