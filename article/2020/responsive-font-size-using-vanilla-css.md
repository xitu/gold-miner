> * 原文地址：[“Responsive” Font-Size Using Vanilla CSS](https://levelup.gitconnected.com/responsive-font-size-using-vanilla-css-51f81fe999db)
> * 原文作者：[Jason Knight](https://medium.com/@deathshadow)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/responsive-font-size-using-vanilla-css.md](https://github.com/xitu/gold-miner/blob/master/article/2020/responsive-font-size-using-vanilla-css.md)
> * 译者：
> * 校对者：

# “Responsive” Font-Size Using Vanilla CSS

There are times where it’s desirable to have the font size scale between two extremes based on the screen width. The strange part is the hoops I’ve seen people jump through to accomplish this, such as the use of “RFS” as outlined in [Ahmed Sakr](undefined)’s article [here on Medium.](https://medium.com/javascript-in-plain-english/automatically-scale-font-sizes-with-rfs-ca22549cc802) Whilst his article well written in outlining how it works, [RFS itself is a bloated wreck](https://github.com/twbs/rfs) of how NOT to do this in the age of CSS3 calculations and comparisons.

Though sadly, such issues are common amongst those who use nonsensical trash like CSS pre-processors, where — **much like frameworks** — it becomes painfully apparent those who created such systems —**and those who use them** — are clearly unqualified to write a single blasted line of HTML, much less apply CSS to it and then have the unmitigated gall to tell others how to do so.

## The Math

The laugh is this is actually quite simple to implement. Let’s say you want 1em font-size as the minimum, 4em as the largest, and the scale to the largest size to be based on 75rem. 75rem being 1200px for 16px/normal users, 1500px for 20px/large font users like myself, and 2400px on a lot of 4k devices.

```css
font-size:max(1em, min(4em, calc(100vw * 4 / 75)));
```

You could also just “do the math yourself”

```css
font-size:max(1em, min(4em, 5.333vw));
```

That 4 in the math simply needing to match your 4em in the min calculation.

You don’t need some giant derpy framework or garbage pre-processor, or any of that junk anymore. This is simple math that CSS is more than capable of on its own.

CSS variables can then be leveraged to store the various values to make them easier to apply in your layout.

## Major Differences From Other Implementations

Rather than use media queries to have to manually state the maximum size somewhere else, we are able with min/max to hardcode both our minimum and maximum sizes into the formula. One simple call handles it all. Rather than have to think (or write code) to say (max-width:1200px) or some such as a separate media query with the maximum value in it, we just put it all in one declaration.

It also allows things to **actually reach the minimum.** Most such attempts at this just add a base size to a fraction of the body width, meaning the minimum size you say isn’t the minimum size you get or the layout could ever reach.

Likewise this is 100% EM based, so you aren’t pissing on usability and accessibility by sleazing things out in pixels. Again, as I’ve said thousands of times the past decade and a half, if you use EM/% font-sizes, your padding, margins, and media queries should ALL be EM based as well. Don’t mix and match, it WILL end up broken for non-standard font-size users… Like myself who has 20px == 1REM on my laptop and workstation, and 32px == 1EM on my media center.

> # It would seem the universe does not like its **peas** mixed with its porridge. — R. Lutece

## So Let’s Do It!

Take a simple page section:

```html
<section>
  <h2>Sample Section</h2>
  <p>
   This card uses a relatively simple CSS calculation to rescale <code>margin</code>, <code>padding</code>, <code>font-size</code>, and <code>border-radius</code> between a minimum and maximum size based on screen width.
  </p><p>
   No LESS/SASS/SCSS rubbish, no NPM package trash, just flipping do it with <code>calc</code>, <code>min</code>, <code>max</code> and some native CSS variables. 
  </p>
 </section>
```

First we make some variables to handle our various desired minimum and maximum sizes:

```css
:root {
 --base-scale:calc(100vw / 75);
 --h2-font-size:max(1em, min(4em, calc(var(--base-scale) * 4)));
 --padding-size:max(1em, min(2em, calc(var(--base-scale) * 2)));
 --margin-size:max(0.5em, min(2em, calc(var(--base-scale) * 2)));
 --border-radius:max(1em, min(3em, calc(var(--base-scale) * 3)));
}
```

You want a different width for the maximum size base, just change that 75 to whatever it is you want (in em). We just apply our calculations as desired.

Again, the “max(value” is actually your minimum size, your “min(value” is your maximum size, and the multiplication value at the end should match your “min(value”

To apply them is as simple as:

```css
main section {
 max-width:40em;
 padding:var(--padding-size);
 margin:var(--margin-size);
 border-radius:var(--border-radius);
 background:#FFF;
 border:1px solid #0484;
}

h2 {
 font-size:var(--h2-font-size);
}
```

The result? When the page is really big:

![](https://cdn-images-1.medium.com/max/2000/1*NdMmS0zWfYXuARtPoY6gMg.png)

Whilst when small:

![](https://cdn-images-1.medium.com/max/2000/1*qC9Zj2yrRKpKGuBvl-Nnhg.png)

…the padding, border-radius, heading size, and so forth all shrink.

## Live Demo

[**Rescale Sections with Vanilla CSS**](https://cutcodedown.com/for_others/medium_articles/responsiveRescale/responsiveRescale.html)

As with all my examples, the directory:

[https://cutcodedown.com/for_others/medium_articles/responsiveRescale/](https://cutcodedown.com/for_others/medium_articles/responsiveRescale/)

Is wide open for easy access to the gooey bits and pieces, and contains a .rar of the whole shebang for easy download, testing, and play.

There you go.

## Drawbacks

There’s really only one. Legacy browsers choke on it. You know what? **OH FREAKING WELL!!!**

But if you’re worried about that, as always check with “caniuse”

[https://caniuse.com/css-math-functions](https://caniuse.com/css-math-functions)

Apart from that, I had a few people say that it’s “too hard to remember”. Seriously? ^C^V people!

## Conclusion

I’m often amazed at the amount of code people will throw at things to “make it simpler”, in the process oft removing the amount of control you have over the result. Even if one were to do this sort of thing with pre-processor or scripting assistance, it should be as easy as plugging the values into the above formula. Honestly though, if you think throwing 9k of SCSS at trying to do this is worth your time… well, might be time to back away from the keyboard and take up something a bit less detail oriented like macramé.

But to be fair, “min” and “max” are **REALLY new** CSS features — at least as of 2020 — despite being strongly supported by all current/recent browser engines. A lot of what that pre-processor time-wasting junk was designed to do is fill in gaps in the specifications. Gaps that often no longer exist.

**Just look at how superior native CSS variables are to pre-compiled ones, since you can change them on the fly and it will impact everything calling it. With pre-processors they’re compiled out. With LESS/SASS/SCSS I labeled them as useless junk for people too lazy to figure out how to search/replace. The native implementation is actually useful!**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
