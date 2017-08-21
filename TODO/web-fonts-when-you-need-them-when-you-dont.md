
  > * 原文地址：[Web fonts: when you need them, when you don’t](https://hackernoon.com/web-fonts-when-you-need-them-when-you-dont-a3b4b39fe0ae)
  > * 原文作者：[David Gilbertson](https://hackernoon.com/@david.gilbertson)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/web-fonts-when-you-need-them-when-you-dont.md](https://github.com/xitu/gold-miner/blob/master/TODO/web-fonts-when-you-need-them-when-you-dont.md)
  > * 译者：[undead25](https://github.com/undead25)
  > * 校对者：

  # 网络字体：什么时候需要，什么时候不需要

  ![](https://cdn-images-1.medium.com/max/2000/1*Y4_EhogCnZQyALLuvQLDKQ.jpeg)

图片来源于 [Unsplash](https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText) 上的 [Marcus dePaula](https://unsplash.com/photos/tk7OAxsXNL0?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText)

我并不热衷笼统的陈述你“应该”或“不应该”使用网络字体，但我认为应该有**一些**指导方针来帮助我们决定是否使用它们。

接下来的篇幅会很长，但是它的主旨是：如果你正在制作一个网站，而你即将去寻找完美的网络字体，请至少**考虑**使用系统字体。

也许你会这样考虑：

![](https://cdn-images-1.medium.com/max/2000/1*MpuDht99XGlRIFlhjFb2yQ.png)

我怀疑对于某些人来说，决策过程更像是这样：

![](https://cdn-images-1.medium.com/max/2000/1*UuhYbCYMjgFk18srTw6rIQ.png)

如果你一直在使用网络字体，那么认为“系统字体”很丑也不足为怪，因为“系统”这个词本身就会让人觉得很丑，所以你才会这么想。

为了让大家觉得是在看同一个页面，至少是在看同一本书，我想给大家展示一个使用系统字体的网页。这可能不是最好的方式，但我希望能以此改变那些负面的观念。

![](https://cdn-images-1.medium.com/max/2000/1*fp9yphAAvXxSD3WbYKXhMA.png)

并不丑啊。

---

你可能希望打开你自己的网站并尝试以下字体系列，看看感觉如何：

    -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;

---

或者你可以使用扩展测试驱动器，并使用类似于 [Stylebot](https://chrome.google.com/webstore/detail/stylebot/oiaejidbmkiecgbjeifoejpgmdaleoha) 的 Chrome 扩展程序来设置特定 CSS 选择器或站点的字体系列。这样，当你访问你的站点时，更改会保持一致。

有了这个令人惊讶的简短介绍，下面让我们在那个流程图中的每个问题上花点时间。

### 字体对你的品牌至关重要吗？

这是最简单的方法。如果答案是肯定的，请停止阅读 —— 下面没有什么可看的了。我真的不介意你直接跳到评论，告诉我我太天真了。

![](https://cdn-images-1.medium.com/max/2000/1*olLYhG5bwvR-YvWwIomuDg.png)

只看这种字体，人就算了。

显然，我不会建议 **The New Yorker** 不使用 Irvin 字体，或者 Apple.com 不使用 San Francisco 字体。即使像耐克这样的网站，我也不会建议他们不要这样做（“One Nike Currency” 字体是十分平常的），因为那是**他们**的字体。

**结论**：如果你的字体是你品牌的一部分，那么显然要使用该字体。否则，请看下面的内容！

### 字体是否使你的网站更容易阅读？

看看这张图片中的文字，只看字体，内容是不相关的。

![](https://cdn-images-1.medium.com/max/1600/1*wSyM5c15HIlxioEOpl2cPw.png)

我想如果你是一个煤矿工人，那这是相关的，只是这篇文章和它不相关。
让自己形成一个意见，稍后再回来。

---

如果在你的网站上，连续阅读的平均字数是 4 个，那么眼疲劳不是那么的大。也许这就是为什么 Facebook、Twitter、Gmail 和 eBay 都使用系统字体（在大多数地方）。

但是，如果用户到你的网站上阅读 10 分钟，你希望你的文本能够很容易地吸引注意力。

（关于衬线的注意事项：到目前为止，我所使用的术语“系统字体”指的是将 font-family 设置为 `-apple-system, BlinkMacSystemFont` 等，它们是无衬线字体。同样的想法也适用于衬线字体。**The New York Times**, **The Boston Globe**, **The Australian** 这些网站都给 body 定义了像 `georgia, "times new roman", times, serif` 的字体。）

Medium.com 是一个很好的例子，我确定你很熟悉它。显然他们在排版上花了很多心思。从那些可爱的短划线到你甚至都没有注意到的不同宽度的空格，Medium 的字体与系统字体是不一样的。

但这不应该让你认为一个网站有使用网络字体**才**容易阅读。

如果你是开发人员，可能已经花了很多时间盯着 GitHub 上的文字。你知道这些文字是没有加载任何一个网络字体实现的吗？太不可思议了。

我想如果明天 GitHub 从系统字体转换为 `Source Sans Pro`，没有人会注意到。同样，我敢打赌，如果 NPM 放弃了 `Source Sans Pro` 并使用系统字体，也没有人会注意到。

这就是它的关键，你的用户（不是你）会注意到网络字体和系统字体在可读性上的差异吗？

先不要回答，因为……

#### 维基百科的奇特案例

维基百科已经[对他们的排版做了大量的思考](https://www.mediawiki.org/wiki/Typography_refresh)。他们得出结论是，系统字体才是他们需要的。

这对他们来说挺好的。

但令我感到困惑的是，在桌面版的尺寸上，他们没有执行过一个度量标准（行宽度），并且使用的是 14px 的字体（在 2014 年更新之前，它是 13px）。

我认为这样做肯定是有充分的理由的，但此生我都不清楚是什么理由。也许与垂直扫描文章有关，我不知道。

我一直在使用 18px 文字和 700px 行宽度的维基百科，现在已经没有任何抱怨了。

![](https://cdn-images-1.medium.com/max/2000/1*CGgCTocnhmQLpaWYeRh6-A.png)

感谢 [Skinny 拓展程序](https://chrome.google.com/webstore/detail/skinny/lfohknefidgmanghfabkohkmlgbhmeho)（无耻的插件）。

当我经常被迫返回到默认视图时，它就会进入我的脑海。

![](https://cdn-images-1.medium.com/max/2000/1*-psbviYTpIj2VOo4r8yiGg.png)

维基百科：自 2001 年以来锻炼颈部肌肉，就像在月球上看一场羽毛球比赛。

（我对维基百科的建议：明天将桌面版正文文本改为 15px，然后在未来五年每年增加 1px —— 仍然会比现在阅读的文字小。）

这个小问题的关键是：如果你的文本在一开始就难以阅读，那么网络字体只能提供小的改进。因此，在考虑字体之前，应该先要了解可读文字排版的基础。

---

如果你不了解排版，但关心可读性，请尝试以此为起点：

- 至少 18px 的字体大小
- 1.6 的行距
- #333 或其周围的字体颜色
- 限制行宽度为 700px

但不要相信我的话，你可以从 Medium、The New Yorker、Smashing Magazine、longform.org，甚至 Node 和 NPM 文档中获得灵感。他们都清楚地考虑到可读性，你会发现他们之间有一些明显的相似之处。

将基本原理整理后，你就可以比较系统字体和网络字体了。

（我有一个预感，人们会争论这一点。提供宽泛的建议是我的错 —— 所以我会在这里说明：用常识来解释你在互联网上读到的内容，调整自己的品味，不要做你不想做的事情。也不要吃洗碗机，如果疼痛持续，就去看医生。）

---

现在，我希望你答应我，你不会往上翻。

因为……

这就是上面出现过的文本块。

![](https://cdn-images-1.medium.com/max/1600/1*Q-h43aVyuDsrHRVXqx7QbQ.png)

比第一个更容易阅读吗？更难读？还是一样？

很容易，当给出的两大块文本并排放在一起时，让你的眼睛在它们之间移动，最终说服自己其中一个比另一个更容易阅读。但如果没有直接的比较导致差异不明显，那么你可能有两个完全可以接受的字体。

为了满足需求，这里将它们并排放置，你可以很清楚地看到它们是不同的。一个是网络字体，而另一个是系统字体。

![](https://cdn-images-1.medium.com/max/2000/1*eS3Yg49ckvxMdo9dv-OPQA.png)

资料来源：[New Republic](https://newrepublic.com/minutes/143094/eliminating-coal-save-lives-per-year-entire-coal-industry-employs)（另外，我在图片中处理了 3 个不同的地方）。

我不会告诉你哪张图使用的是网络字体，哪张图使用的是系统字体。

那么，回到流程图的问题上：“网络字体让你的网站更容易阅读吗？”。我想，在寒冷的光线下，任何一个理性的人都会看着上面的比较，然后说**不**，他们中没有一个比另外一个更容易阅读。

（现在我想一想，这实际上是一个很好的测试，看看你是否是一个理性的人。）

**结论**：如果你的网站没有太多的文字，那么网络字体对可读性几乎没有任何影响。但如果你的网站都是关于阅读的，这可能不是那么容易。**我**认为 Medium 网站的字体肯定会让文字更加愉快地被阅读。**我**认为这和 New Republic 网站的字体没有任何区别。你需要为你网站的读者找到客观回答这个问题的方法。

如果你认为网络字体对可读性没有什么意义，那么你将更接近最终目标 —— 不必担心网络字体。

### Can you load the font without a FOUT?

If you’ve got this far down the flow chart, the web font in question isn’t tied to your brand, and it doesn’t improve readability. But that of course doesn’t mean you shouldn’t use it.

Unless you get a **F**lash **O**f **U**nstyled **T**ext. Because that’s U-G-L-Y.

I’m sorry, *New Republic*, but to dive deeper I’m going to pick on you some more. It’s not because I’m mean, it’s because you’re sending 542 KB of fonts to my browser.

Here’s the article from the screenshots above loading.

![](https://cdn-images-1.medium.com/max/1600/1*6GoQ3zcV8mA-lufM3iMd1A.png)

Loading a New Republic article. Chrome DevTools network panel, throttled to “Fast 3G”, filtered for fonts only.
The body copy of the article is visible in 1.45 seconds. That’s a really solid effort.

Seriously, 1.45 seconds over 3G beats the pants off the vast majority of the internet [placatory shoulder pat].

Then at 1.65 seconds the image loads. But from this point on it’s all downhill like a cheese rolling festival.

**Nine seconds later**, at 10.85, the web font is ready and the text flickers as the system font is swapped out for the web font. Yuck.

But it’s not done yet. Oh no. At 12.58 seconds it flickers again as the 700-weight font is loaded (which is used in the opening sentence of every article — so this shifts the rest of the copy), then the text flickers again at 12.7 when the 400 italics arrives.

All this on top of the fact that most humans couldn’t tell the difference between the two fonts anyway.

Oh and from what I can tell, the ‘Balto’ and ‘Lava’ fonts used here are not only 542 KB, they’re also about $2,000/year. Sheish.

That certainly clenches my purse strings.

It’s funny, I think a lot of people will look at the title of this blog post and assume it’s a rant from some developer that doesn’t see the value in fine typography. But it’s quite the opposite. The behaviour described above is an assault on the visual experience, and it could be *avoided* by using a system font that would look damn-near identical.

---

But let’s take a step back here. Clearly, the designers of this site don’t *want* it to be annoying as it loads. And it’s obviously not just *New Republic* that suffers from this. So how does a site get to this point?

And more importantly, how can you avoid *your site* getting to this point?

I imagine that the design decisions probably happened sitting in front of Sketch, or viewing the website with the font installed locally, so it was assumed that there is *no downside to using a web font*.

This is not true, as anyone that has ever used the internet can tell you.

Perhaps if there was a plugin for Sketch or Photoshop that showed a system font for 10 seconds every time you opened a file, the world would have less superfluous web fonts.

My suggestion: understand how web fonts will look to your users, not on a static design with no annoying flash of unstyled text.

**Conclusion:** if you can’t avoid the FOUT, avoid the font.

(If you’ve been knocked out in this round you can scroll ahead and see some tips for avoiding FOUT.)

### Do you want the same font on all devices?

I only have this step in here because I’ve heard it several times and wanted to address it. But frankly I don’t get it.

Why would I want the same font on all devices? On the surface that probably sounds like a stupid question, but I’ve tried to apply the ‘5 Whys’ and I get stuck at number two.

From what I understand, the idea is that if I’m browsing for some socks in Safari on my Mac, then leave home, get in a train and go to that same site on my Android, it’s a *bad* thing if I now see a different font.

I understand the general idea that “consistency is important”. But … is it really? At this point in the flow chart?

I can only speak for myself, but if I’ve gone from sitting on the couch looking at your desktop site on a 15 inch LCD with 220 PPI to a dirty room on wheels, looking at your mobile site on a 5.5 inch OLED with 534 PPI, I couldn’t care less what font I’m looking at and would almost certainly not notice the change from San Francisco to Roboto.

I’m just lookin’ at socks on my phone.

![](https://cdn-images-1.medium.com/max/2000/1*KCk6znjIEeYIT9Xirnh2EQ.png)

Thanks, [readymag](https://readymag.com/arzamas/132908/9/)

But like I said, I can only speak for myself. Maybe I’m alone in this thinking and everyone else would be comprehensively discombobulated by the Roboto/San Francisco switcheroo.

I am but a lonely data point.

---

I’ve also heard the argument that having the same font on all devices means you can rely on text having a consistent weight and always taking up the same amount of space.

Nope.

![](https://cdn-images-1.medium.com/max/1600/1*5-yDFIJgMvqyr-ugdYUMOA.jpeg)

Safari on macOS

![](https://cdn-images-1.medium.com/max/1600/1*8cXq51gj6yp2kZfD_ePdIQ.png)

Chrome on Windows

I use macOS/Windows about half/half (I’m a bit of a tramp like that), and text generally looks lighter on Windows. But to complicate things, Windows has this whole ClearType thing that means you don’t actually know how fonts will show to different users.

So you need to accept that even with a web font, your text will show differently on Mac and Windows and will almost certainly wrap at different points (note the first line of the main paragraph).

**Conclusion**: if you understand that your text will never (ever) look the same on all devices, but still want to use the same font across all devices, then the choice is clear: you’re gonna need a web font. Otherwise…

### Will you be happier if you use a web font?

So, you’ve got a font that *isn’t *tied to your brand, *doesn’t *increase readability, you *can *get it loading without an unsightly flash of unstyled text, and you have accepted the inevitable inconsistency across devices.

What now?

You may have noticed that missing from my flow chart is the question “does it look better?” I assure you this isn’t because I think looks don’t matter. Aesthetics are very important. It’s why I brush my hair in the morning.

The reason I left “does it look better?” out of the flow chart is because of the misconception that web fonts are inherently better looking than system fonts.

It’s probably about time we took a closer look at these “system” fonts…

If you use a system font today, your users are getting ‘San Francisco’ on macOS and iOS, ‘Roboto’ on Android, and ‘Segoe UI’ on Windows.

These are what Apple, Google and Microsoft have chosen to be the faces of their interfaces. A great deal of care has gone into crafting these fonts, so they certainly shouldn’t be considered the poor second cousins to the likes of ‘Open Sans’, ‘Proxima Nova’ and ‘Lato’.

(I’m tempted to suggest that these system fonts are superior to the majority of web fonts, but typography enthusiasts are a violent bunch so I will say no such thing.)

System fonts can be every bit as pretty as web fonts, and if you’re interested in how nice a font looks, then you should make the effort to see how your site looks with system fonts. Maybe it looks better — and wouldn’t that be a pleasant surprise?

---

So, you’ve checked out the system fonts and they don’t do it for you. Now you quite simply want to select the font for your site, just like you want to select the color palette and the layout.

As luck would have it, we’re at the end of the flow chart, so if you want to use a web font, then you should use a web font.

I thank you for taking the time to consider system fonts and I wish you and your web font many years of happiness.

**Conclusion**: use a web font if you want to. *But *if you come to the conclusion after all of this that actually, it might be nice to have one less thing to worry about, and system are actually pretty great, then use a system font.

Everyone’s a winner.

### My opinion

The above was a rather boring ending, wasn’t it. “Do whatever makes you happy” — bleugh.

Now on to the important stuff. What *I* think.

*I* think web fonts are used as the default mode of operation rather than as the result of a considered decision making process.

I think, um, exactly half the sites that use web fonts could get rid of them and be better off.

I think the worst ones will actually be losing traffic because of their slow-to-load web fonts.

Things like the below are particularly outrageous. Users are given a blank page to stare at for three unnecessary seconds while this site loads a pretty font.

![](https://cdn-images-1.medium.com/max/2000/1*dlpNsFiPLVf7L8XTSZjsVA.png)

This really grinds my gears.

It’s like if you came over to my house to visit and I made you stand in the corner staring at a blank wall for three minutes while I brushed my hair.

If your site loads like this, you’re effectively saying “my font is more important than my content, and your time”.

I won’t give away the site (because I like the content and don’t think they deserve a public shaming), but you’re probably keen to see the unique, beautiful web font that causes this egregious delay.

So here is one paragraph in the system font you could have been reading straight away, and one in the wunderfont that users are kept waiting three seconds to see.

![](https://cdn-images-1.medium.com/max/1600/1*SvPa6OyravMecd045jf16Q.png)

It’s magnificent, isn’t it? Majestic, even. I wish that *all* sites kept me waiting an extra three seconds so that I could feast my eyes on the beauty that is this truly exhilarating typeface.

OK that’s enough of my opinions. I’m running out of breath and I just remembered I’m trying to be less sarcastic.

So let’s move on from me berating others for their choices and finish with something more practical.

### How to do web fonts right

Contrary to the vibe you may have gotten from the above, I don’t think the web should do away entirely with web fonts. But if you’re going to use them, there’s a right way and a wrong way. Below, you will find both.

---

The reason web fonts can be slow is that the browser doesn’t find out about them until quite late in the loading process. The browser must load a bunch of HTML and CSS *before* learning that it needs your fancy font that you totally need. (Dammit, some sarcasm slipped through. Apologies.)

Only then will the browser begin downloading the font. Here’s the assets loading for a page with nothing more than some HTML, CSS, and a single web font:

![](https://cdn-images-1.medium.com/max/1600/1*gfeEGIGmAgZ10PtxM53vSA.png)

The blue bar is HTML, purple is CSS and grey is the font file.

You can see that as the browser is parsing the HTML, it discovers a reference to the CSS file and starts downloading it. Once you’ve finished noticing that, notice that only once the CSS is completely downloaded does the browser realise you’re going to need a font. So the page is actually ready to go before the font even *begins* to download.

It’s a bit hard to see, but across the top are screenshots of the page as it’s loading. If you squint (although if you ask me, squinting makes it even harder to see things), you can see that the text is rendered only once the font is ready (at about 2400ms).

Your other option is to load the font via CSS — the sort of snippet you’re encouraged to use by Google Fonts. This basically loads a CSS file that defines some font-face rules that point to font files on Google’s servers. So the load pattern looks like this:

![](https://cdn-images-1.medium.com/max/1600/1*Gdclz9iXlIXiZdP629I4AA.png)

The green is the font file. The end result is much the same. We’re waiting for ages before we event start downloading the font.

---

But what if you could add one line of code and start the font downloading sooner? Like…

![](https://cdn-images-1.medium.com/max/1600/1*a1AvziD3XHE_dt4u4tUW3g.png)

Wouldn’t that be frikken awesome?

Well… drop this in your HTML before you define your CSS file and Bob’s your uncle.

```
<link
  rel="preload"
  href="./fonts/sedgwick-ave-v1-latin-regular.woff2"
  as="font"
  type="font/woff2"
  crossorigin
>
<link rel="stylesheet" href="main.css" />
```

Yes yes, technically not one line.

`rel=preload` only covers about 50% of users right now [August 2017], but it’s [just about to land in Firefox and Safari](http://caniuse.com/#feat=link-rel-preload) so things are quickly getting better.

Your alternative, the `FontFace` API, [covers a lot more ground](http://caniuse.com/#feat=font-loading) — closer to 80% of users. You can use it right before you point to your CSS to start the browser downloading immediately.

```
<script>
  if ('FontFace' in window) {
    var sedgwickAveFont = new FontFace(
      'Sedgwick Ave',
      'url(./fonts/sedgwick-ave-v1-latin-regular.woff2)',
      {
        style: 'normal',
        weight: '400',
      }
    );
    sedgwickAveFont.load().then(function() {
      document.fonts.add(sedgwickAveFont);
    });
  }
</script>

<link rel="stylesheet" href="main.css" />
```

I highly recommend reading [Web Font Optimization](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/webfont-optimization) if this floats your boat

The result is just as wonderful:

![](https://cdn-images-1.medium.com/max/1600/1*1Igz81o2h0lfGld6ukAfrA.png)

And in a neat stroke of luck, `.woff2` support is more or less a superset of `FontFace` support, so you only need to bother specifying the one font format when you use `FontFace`.

You can then have fallbacks for `.woff` and `.ttf` and whatever else you like in your usual `@font-face` rules.

```
@font-face {
  font-family: 'Sedgwick Ave';
  font-style: normal;
  font-weight: 400;
  src:  url('./fonts/sedgwick-ave-v1-latin-regular.woff2') format('woff2'),
  url('./fonts/sedgwick-ave-v1-latin-regular.woff') format('woff');
  font-display: block;
}
```

One last thing… so your font is now starting to download a lot sooner, you can hopefully avoid the dreaded FOUT entirely. But maybe there will be a few hundred milliseconds between the CSS arriving and the font arriving.

In this period, the browser knows what font to use, but doesn’t have it yet. What’s cool is that you can control what it does during this time by defining the `font-display` property in the `@font-face` rule.

In the above example, I can be pretty sure the font is going to arrive within a few hundred milliseconds of the CSS, since they’re about the same size, coming from the same server, starting at the same time.

In this case, I want to block the text from showing until the font arrives to save myself from the dreaded FOUT. I do this by setting `font-display` to `block`.

On the flip-side, if you think the font might not arrive for several seconds after your CSS, you might want to set it to `swap` so the browser shows the unstyled text immediately, thus letting your reader read.

[The spec](https://tabatkins.github.io/specs/css-font-display/#font-display-desc) explains the details in fairly simple language (I only read the green boxes). All this is Chrome-only as of August 2017.

---

Here’s a codepen that will list a bunch of fonts and show you which ones are supported on your current device.

I’m not sure that it’s actually useful but it was a bit of fun trying to work out how to do it. Lemme know if you’d like some fonts added to the list.

[![](https://s3-us-west-2.amazonaws.com/i.cdpn.io/326282.PKJvow.2cabcc11-62f6-4e7f-abfc-1c756aa59002.png)](https://hackernoon.com/media/39b5620b39b011d96f5a261b318ff3b7?postId=a3b4b39fe0ae)

That’s about it.

Bye.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  