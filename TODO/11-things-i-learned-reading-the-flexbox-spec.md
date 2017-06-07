> * 原文地址：[11 things I learned reading the flexbox spec](https://hackernoon.com/11-things-i-learned-reading-the-flexbox-spec-5f0c799c776b)
> * 原文作者：[David Gilbertson](https://hackernoon.com/@david.gilbertson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# 11 things I learned reading the flexbox spec #

I’ve always found flexbox pretty easy to work with — a breath of fresh air after years of floating and clearfixing.

Recently though, I found myself fighting against it; something was flexing when I didn’t think it should be flexing. I fixed it, something else got squashed. I fixed that, then something else got pushed right off the screen. What in the George W Bush was going on?

In the end I got it all working, but the sun had set and my process had been the old CSS fiddle-a-roo. Or … what’s that game where you have to whack a mole and then another mole pops up and you have to whack that one too?

Anyhoo, I decided it was about time that I behaved like a grown up developer and learned flexbox properly. But rather than read another 10 blog posts, I decided to go straight to the source and read [The CSS Flexible Box Layout Module Level 1 Spec](https://www.w3.org/TR/css-flexbox-1/).

Here’s the good bits.

### 1. Margins have special powers ###

I used to think that if you wanted, say, a header with a logo and site title on the left, and a sign in button over on the right…

![](https://cdn-images-1.medium.com/max/800/1*Y1xY5s_DFPRaZzTwpfb_WQ.png)

Dotted lines for clarity

…you should give the title a flex of 1 to push the other items to either end of the row.

```
.header {
  display: flex;
}
.header .logo {
  /* nothing needed! */
}
.header .title {
  flex: 1;
}
.header .sign-in {
  /* nothing needed! */
}
```

This is why flexbox is a Very Good Thing. Simple things are so simple.

But maybe, for some reason, you don’t want to stretch an item just to push another item to the right. It might be a box with an underline, an image, or some third reason I can’t think of.

Great news! You can be more direct and instead say “push this item to the right” by defining `margin-left: auto` on that item. Think of it like `float: right`.

For example if the item on the left was an image:

![](https://cdn-images-1.medium.com/max/800/1*hFLefXP4fsgnFDIjPIcrTQ.png)

I don’t need to apply any flex to image, I don’t need to apply `space-between` to the flex container, I just set `margin-left: auto` on the ‘Sign in’ button:

```
.header {
  display: flex;
}
.header .logo {
  /* nothing needed! */
}
.header .sign-in {
  margin-left: auto;
}
```

You might think that seems a bit hacky, but nope, it’s right there in the [overview](https://www.w3.org/TR/css-flexbox-1/#overview) of the spec as *the* method used to push a flex item to the end of a flexbox. It even has its own chapter, “[Aligning with auto margins](https://www.w3.org/TR/css-flexbox-1/#auto-margins)”.

Oh I should add here that I’m assuming `flex-direction: row` everywhere in this post, but it all applies just the same to `row-reverse` or `column` or `column-reverse`.

### 2. min-width matters ###

You might think that it would be straightforward to ensure that all of the flex items within a container shrink to fit. Surely if you have `flex-shrink: 1` on the items, that’s what they do, right?

An example, perhaps.

Let’s say you’ve got a bit of DOM that shows a book for sale and a button to buy it.

![](https://cdn-images-1.medium.com/max/800/1*kx1Xl4o5at3whroR9gB0Dw.png)

(Spoiler: the butterfly dies in the end)

You’ve laid it out with flexbox and all is well.

```
.book {
  display: flex;
}
.book .description {
  font-size: 30px;
}
.book .buy {
  margin-left: auto;
  width: 80px;
  text-align: center;
  align-self: center;
}
```

(You want the ‘Buy now’ button to be on the right — even for really short titles — so you’ve cleverly given it `margin-left: auto`.)

The title is quite long so it uses up as much space as it can, then wraps to the next row. You are happy, life is good. You blissfully ship your code to production with confidence that it will handle anything.

Then you get a nasty surprise. And not the good kind.

Some pretentious muppet has written a book with a long word in the title.

![](https://cdn-images-1.medium.com/max/800/1*skXsBLXnoul3J64xKb1HmA.png)

That’s totes broken!

If that red border represents the width of a phone, and you’re hiding overflow, you’ve just lost your ‘Buy now’ button. Your conversion rates — and the poor author’s ego — are going to suffer.

(Side note: luckily where I work we have a good QA team that have populated our database with all sorts of nasty text like this. It was this issue in particular that prompted me to read the spec.)

As it turns out, this behaviour is because the `min-width` of the description item is initially set to `auto`, which in this case equates to the width of the word *Electroencephalographically.* The flex item is literally not allowed to be any narrower than that word.

The solution? Override this troublesome `min-width: auto` by setting `min-width: 0`, instructing flexbox that it’s OK for this item to be narrower than the content within it.

It’s then up to you to handle the text inside the item. I’d suggest wrapping the word. So your CSS would look like this:

```
.book {
  display: flex;
}
.book .description {
  font-size: 30px;
  min-width: 0;
  word-wrap: break-word;
}
.book .buy {
  margin-left: auto;
  width: 80px;
  text-align: center;
  align-self: center;
}
```

The result will be this:

![](https://cdn-images-1.medium.com/max/800/1*lM96U8XNZJEGPrVwqJk91w.png)

Again, `min-width: 0` is not some hack to work around a quirk, it’s the [suggested behavior right from the spec](https://www.w3.org/TR/css-flexbox-1/#min-size-auto).

In the next section I’ll address that ‘Buy now’ button being not at all 80px wide like I quite clearly told it to be.

### 3. The flexbox authors have crystal balls ###

As you probably know, the `flex` property is shorthand for `flex-grow`, `flex-shrink` and `flex-basis`.

I must admit I’ve spent quite a few minutes guessing-and-checking different values for these three when trying to get things to flex the way I want.

What I didn’t know until now is that I generally only want one of three combinations:

- If I want an item to squish in a bit if there isn’t enough room, but not to stretch any wider than it needs to: `flex: 0 1 auto`
- If my flex item should stretch to fill the available space and squish in a bit if there’s not enough room: `flex: 1 1 auto`
- If my item should not flex at all: `flex: 0 0 auto`

I hope you’re not at maximum amazement yet — it’s about to get more amazing.

You see, the Flexbox Crew (I like to think the flexbox team have leather jackets that say this across the back — available in women’s and men’s sizes). Where was this sentence. Ah yes, the Flexbox Crew knew that these are the three flex property combinations I want most of the time, so they gave them [keywords just for me](https://www.w3.org/TR/css-flexbox-1/#flex-common).

The first scenario is the `initial` value so doesn’t need the keyword. `flex: auto` is what to use for the second scenario, and `flex: none` is the remarkably simple solution to make something not flex at all.

Who woulda thunk it.

It’s kinda like having `box-shadow: garish` and that defaulting to `2px 2px 4px hotpink` because it’s considered a ‘useful default’.

So back to that extremely ugly book example from before. To make that ‘Buy now’ button a consistently fat tap target…

![](https://cdn-images-1.medium.com/max/800/1*oaBk_GjcSHAvSkdhJhwkSA.png)

…I only need to set `flex: none` on it:

```
.book {
  display: flex;
}
.book .description {
  font-size: 30px;
  min-width: 0;
  word-wrap: break-word;
}
.book .buy {
  margin-left: auto;
  flex: none;
  width: 80px;
  text-align: center;
  align-self: center;
}
```

(Yes, I could have done `flex: 0 0 80px;` and saved a line of CSS. But there’s something nice about the way that `flex: none` clearly represents the intention of the code. This is good for poor Future David who will have forgotten how all this works.)

### 4. inline-flex is a thing ###

OK to be honest I learned a few months ago that `display: inline-flex` was a thing. And that it would create a flex container that was inline, instead of a block.

But I estimate that 28% of people did not yet know this, so … now you do, bottom 28%.

### 5. vertical-align has no effect on a flex-item ###

Maybe this is something that I *half* knew, but I’m sure at some point when trying to get something to align just right I may have tried `vertical-align: middle` then shrugged when it didn’t work.

Now I know for sure, straight from the spec, that “[vertical-align has no effect on a flex item](https://www.w3.org/TR/css-flexbox-1/#flex-containers)” (same as `float`, for the record).

### 6. Don’t use % margins or padding ###

This is not just a best practice type situation, it’s advice-from-grandma level stuff, just do what you’re told and don’t ask questions.

“Authors should avoid using percentages in paddings or margins on flex items entirely” — love, the flexbox spec.

This follows my favourite quote from any spec ever:

> Note: This variance sucks, but it accurately captures the current state of the world (no consensus among implementations, and no consensus within the CSSWG)…

Look out! Honesty-bombing in progress.

### 7. The margins of adjacent flex items don’t collapse ###

You may already know that margins collapse onto each other sometimes. You may also know that margins *don’t* collapse onto each other at some other times.

And now we all know that the margins of adjacent flex items do not ever collapse onto each other.

### 8. z-index works even if position: static ###

I’m not sure that I really care about this one. But I feel like one day, maybe, it will come in handy. It’s exactly the same reason I have a bottle of lemon juice in the fridge.

I’ll have another human in my house one day and they’ll be all like “hey, you got any lemon juice?” and I’ll be all like “sure do, in the fridge” and they’ll be like, “thanks, mate. Hey, if I want to set z-index on a flex item, do I need to specify a position?” and I’ll be all “nah bro, not for flex items.”

### 9. Flex-basis is subtle and important ###

Once your requirements go beyond the keywords `initial`, `auto` and `none`, things get a bit more complex, and now that I *get*`flex-basis`, it’s funny, you know, I can’t quite work out how to end this sentence. Feel free to leave a comment if you’ve got any ideas.

If you have three flex items with flex values of 3, 3, and 4. Then they *will* take up 30%, 30% and 40% of the available space, regardless of their content, if their `flex-basis` is `0`. And *only* if it’s zero.

However, if you want flex to behave in a friendlier, but less predictable way, use `flex-basis: auto`. This will take your flex values into consideration, but also take other factors into account, have a bit of a think about it, then come up with some widths it thinks will work for you.

Check out this neato diagram from the spec:

![](https://cdn-images-1.medium.com/max/800/1*eiAn12jGzun4F7U3mfqUtQ.png)

I’m quite sure this is mentioned in at least one of the flex blog posts I’ve read, but for whatever reason, it didn’t really click until I saw this schmick pic in the spec (triple rhyme if you’re from New Zealand).

### 10. align-items: baseline ###

If I wanted my flex items to align vertically, I’ve always used `align-items: center`. But just like `vertical-align`, you also have the option to set the value to `baseline` which might be more appropriate if your items have different font sizes and you want their baselines to align.

`align-self: baseline` also works, perhaps obviously.

### 11. I’m pretty stupid ###

No matter how many times I read the following paragraph, I remain incapable of comprehending it…

> The content size is the min-content size in the main axis, clamped, if it has an aspect ratio, by any definite min and max cross size properties converted through the aspect ratio, and then further clamped by the max main size property if that is definite.

The words make their way into my holes, are converted to electrical impulses that travel up my optic nerve, arriving just in time to see my brain running out the back door in a puff of smoke.

It’s like Minnie Mouse and Mad Max had a child seven years ago and now he’s drunk on peppermint schnapps, verbally abusing anyone within ear-distance using words he learned when Mummy and Daddy were fighting.

Ladies and Gentlemen we have begun our descent into nonsense, which means it’s time to wrap it up (or stop reading if you’re just here for the learnin’).

The most interesting thing I learned reading the spec was exactly how un-thorough my understanding was, despite the half-dozen or so blog posts I’d read, and how relatively simple flexbox is. It turns out that ‘experience’ isn’t just doing the same thing over and over for years on end.

I can report with delight that my time spent reading has paid for itself already. I’ve gone back through old code and set auto margins, flex values to the shorthand auto or none, and defined a min-width of zero wherever it was needed.

I feel better about this code now, knowing that I’m doing it properly.

My other learning was that although the spec is — in places — exactly as dense and vendor-focused as I thought it would be, there is still a lot of friendly words and examples. It even highlights the parts that lowly web developers can skip over.

However this is a moot point because I’ve told you all the good bits so you needn’t bother reading it for yourself.

Now, if you’ll excuse me, I have to go and read all the other CSS specs.

P.S. I highly recommend reading this, a list of all the flexbox bugs by browser: [https://github.com/philipwalton/flexbugs](https://github.com/philipwalton/flexbugs).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
