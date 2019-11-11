> * 原文地址：[The Trick to Animating the Dot on the Letter “i”](https://css-tricks.com/the-trick-to-animating-the-dot-on-the-letter-i/)
> * 原文作者：[Ali Churcher](https://css-tricks.com/author/alichurcher/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-trick-to-animating-the-dot-on-the-letter-i.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-trick-to-animating-the-dot-on-the-letter-i.md)
> * 译者：
> * 校对者：

# The Trick to Animating the Dot on the Letter “i”

![](https://res.cloudinary.com/css-tricks/image/fetch/w_1200,q_auto,f_auto/https://css-tricks.com/wp-content/uploads/2019/10/letter-i-collage.png)

Here’s the trick: by combining the Turkish letter "ı" and the period "." we can create something that looks like the letter "i," but is made from two separate elements. This opens us up to some fun options to style or animate the dot of the letter independently from the stalk. Worried about accessibility? Don’t worry, we’ll cover that the best way we know how.

Let’s look at how to create and style these separate "letters," and find out when they can be used, and when to avoid them.

### Check out some examples

Here are some different styles and animations we can do with this idea:

See the Pen [Styles and animations](https://codepen.io/alichur/pen/vYYLdej) by Ali C ([@alichur](https://codepen.io/alichur)) on [CodePen](https://codepen.io).

Because both parts of the letter are regular Unicode characters, they will respect font changes and page zoom the same as any other text. Here’s some examples of different fonts, styles, and zoom levels:

See the Pen [Different fonts and zoom](https://codepen.io/alichur/pen/YzzwYEG) by Ali C ([@alichur](https://codepen.io/alichur)) on [CodePen](https://codepen.io).

### Step-by-step through the technique

Let’s break down how this technique works.

#### Choose the Unicode characters to combine

We are using the dotless "i" character (ı) and a full stop. And, yes, we could use other characters as well, such as the dotless "j" character (ȷ) or even the accents on characters such as "ñ" (~) or "è" (`).

Stack the characters on top of each other by wrapping them in a span and setting the `display` property to `block`.

```html
<span class="character">.</span>
<span class="character">ı</span>
```

```css
.character {
  display: block;
}
```

#### Align the characters

They need to be close to each other. We can do that by adjusting the line heights and removing the margins from them.

```css
.character {
  display: block;
  line-height: 0.5;
  margin-top: 0;
  margin-bottom: 0;
}
```

#### Add a CSS animation to the dot element

Something like this bouncing animation:

```css
@keyframes bounce {
  from {
    transform: translate3d(0, 0, 0);
  }

  to {
    transform: translate3d(0, -10px, 0);
  }
}

.bounce {
  animation: bounce 0.4s infinite alternate;
}
```

There’s [more on CSS animations](https://css-tricks.com/almanac/properties/a/animation/) in the CSS-Tricks Almanac.

Checking in, here’s where we are so far:

See the Pen [Creating the letter](https://codepen.io/alichur/pen/OJJNZYO) by Ali C ([@alichur](https://codepen.io/alichur)) on [CodePen](https://codepen.io).

#### Add any remaining letters of the word

It’s fine to animate the "i" on its own, but perhaps it’s merely one letter in a word, like "Ping." We’ll wrap the animated characters in a span to make sure everything stays on a single line.

```html
<p>
  P
  <span>
    <span class="character">.</span>
    <span class="character>ı</span> 
  </span>
  ng
</p>
```

There’s an [automatic gap between inline-block elements](https://css-tricks.com/fighting-the-space-between-inline-block-elements/), so be sure to remove that if the spacing looks off.

The final stages:

See the Pen [Adding the letter inside a word](https://codepen.io/alichur/pen/WNNwzov) by Ali C ([@alichur](https://codepen.io/alichur)) on [CodePen](https://codepen.io).

### What about SVG?

The same effect can be achieved by creating a letter from two or more SVG elements. Here's an example where the circle element is animated independently from the rectangle element.

See the Pen [SVG animated i](https://codepen.io/alichur/pen/eYYgyEB) by Ali C ([@alichur](https://codepen.io/alichur)) on [CodePen](https://codepen.io).

Although an SVG letter won’t respond to font changes, it opens up more possibilities for animating sections of letters that aren’t represented by Unicode characters and letter styles that don't exist in any font.

### Where would you use this?

Where would you want to use something like this? I mean, it’s not a great use case for body content or any sort of long-form content. Not only would that affect legibility (can you imagine if every "i" in this post was animated?) but it would have a negative impact on assistive technology, like screen readers, which we will touch on next.

Instead, it’s probably best to use this technique where the content is intended for decoration. A logo is a good example of that. [Or perhaps in an icon](https://css-tricks.com/tips-aligning-icons-text/) that’s intended to be described, but not interpreted as text by assistive technology.

### Let’s talk accessibility

Going back to our "Ping" example, a screen reader will read that as `P . ı ng`. Not exactly the pronunciation we’re looking for and definitely confusing to anyone listening to it.

Depending on the usage, different ARIA attributes can be added so that text is read differently. For example, we can describe the entire element as an image and add the text as its label:

```html
<div role=img aria-label="Ping">
  <p>P<span>.</span><span>ı</span>ng</p>
</div>
```

This way, the outer div element describes the meaning of the text which gets read by screen readers. However, we also want assistive technology to skip the inner elements. We can add `aria-hidden="true"` or `role="presentation"` to them so that they are also not interpreted as text:

```html
<div role=img aria-label="Ping">
  <p role="presentation">P
    <span>.</span>
    <span>ı</span>
  ng</p>
</div>
```

This was only tested on a Mac with VoiceOver in Safari. If there are issues in other assistive technology, please let us know in the comments.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
