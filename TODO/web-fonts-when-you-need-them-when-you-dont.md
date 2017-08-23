
  > * 原文地址：[Web fonts: when you need them, when you don’t](https://hackernoon.com/web-fonts-when-you-need-them-when-you-dont-a3b4b39fe0ae)
  > * 原文作者：[David Gilbertson](https://hackernoon.com/@david.gilbertson)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/web-fonts-when-you-need-them-when-you-dont.md](https://github.com/xitu/gold-miner/blob/master/TODO/web-fonts-when-you-need-them-when-you-dont.md)
  > * 译者：
  > * 校对者：

  # Web fonts: when you need them, when you don’t

  ![](https://cdn-images-1.medium.com/max/2000/1*Y4_EhogCnZQyALLuvQLDKQ.jpeg)

Photo by [Marcus dePaula](https://unsplash.com/photos/tk7OAxsXNL0?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText)

I’m not a fan of sweeping statements like you “should” or “shouldn’t” use web fonts, but I think there should be *some *sort of guidelines to help people decide whether or not to use them.

I’m going to type lots of words soon, but the gist of it is this: if you’re making a site, and you’re just about to go searching for that perfect web font, please, at least *consider* using system fonts instead.

Perhaps that consideration may take the following form:

![](https://cdn-images-1.medium.com/max/2000/1*MpuDht99XGlRIFlhjFb2yQ.png)

I suspect that for some, the decision process is more like this:

![](https://cdn-images-1.medium.com/max/2000/1*UuhYbCYMjgFk18srTw6rIQ.png)

If you’ve always used web fonts, you’d be forgiven for thinking “system fonts” are ugly. Just the word “system” is ugly, so that’s a reasonable thing to think.

To get everyone on the same page — or at least looking at the same book — I’d like to show one example of a site that uses system fonts. It might not be the prettiest thing in the world, but hopefully levels any negative preconceptions.

![](https://cdn-images-1.medium.com/max/2000/1*fp9yphAAvXxSD3WbYKXhMA.png)

Not ugly.

---

You might like to open your own site and try the following font-family, see how it feels:

    -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;

---

Or you could take an extended test drive and use something like the [Stylebot Chrome extension](https://chrome.google.com/webstore/detail/stylebot/oiaejidbmkiecgbjeifoejpgmdaleoha) to set a font-family for a particular CSS selector/site. That way the changes stick as you navigate around you site.

With that surprisingly short intro out of the way, let’s spend a little time with each of the questions in that flow chart.

### Is the font crucial to your brand?

This is the easiest one to get out of the way. If the answer is yes, stop reading — there’s nothing to see here. Maybe skip straight to the comments to tell me I’m naive, I really don’t mind.

![](https://cdn-images-1.medium.com/max/2000/1*olLYhG5bwvR-YvWwIomuDg.png)

Just look at that font, people. Rowl.

Obviously, I’m not going to suggest *The New Yorker* kicks Irvin to the kerb, or that Apple.com ditches San Francisco. Even for sites like Nike I wouldn’t suggest they don’t do it (“One Nike Currency” is thoroughly uninspiring), because it’s *their* font.

**Conclusion**: if your font is part of your brand, use that font, obviously. Otherwise, onward!

### Does the font make your site easier to read?

Take a look at the text in this picture. The content isn’t relevant, just the font.

![](https://cdn-images-1.medium.com/max/1600/1*wSyM5c15HIlxioEOpl2cPw.png)

I guess if you’re a coal miner it’s relevant, just not to my article
Allow yourself to form an opinion, I’ll come back to it later.

---

If the average number of words read in succession on your site is four, eye strain is not such a big deal. Perhaps this is why Facebook, Twitter, Gmail, and eBay all use system fonts (in most places).

But if a user is coming to your site to read for 10 minutes, you want your text to be easy on the eye.

(A note on serifs: so far I’ve been used the term ‘system fonts’ to refer to setting the font-family as `-apple-system, BlinkMacSystemFont`, etc., which are sans-serif fonts. The same idea applies to serif fonts as well. *The New York Times*, *The Boston Globe*, *The Australian*, all define the font-family for body text as something like `georgia, "times new roman", times, serif`.)

Medium.com is a great example, and I’m pretty sure you’re familiar with it. They have clearly put a lot of thought into their typography. From those lovely em dashes to the different width spaces you didn’t even notice, Medium would not be the same with a system font.

But that shouldn’t leave you thinking that a site is *only* easy to read if it has a web font.

If you’re a developer you’ve probably spent quite a bit of time staring at words on GitHub. Did you know that not a single font file was loaded over the network in the making of those words? Amazing.

I think if tomorrow, GitHub switched from system fonts to ‘Source Sans Pro’, no one would even notice. Likewise, I’d bet that if NPM ditched the Source Sans Pro and went to system fonts, no one would notice either.

And that’s the crux of it, would your users (not you) notice a difference in readability between a web font and system fonts?

Don’t answer that yet, because…

#### The curious case of Wikipedia

Wikipedia has [put a great deal of thought into their typography](https://www.mediawiki.org/wiki/Typography_refresh). And they have come to the conclusion that system fonts are the way to go.

Good on ‘em.

But what baffles me is that at desktop sizes, they haven’t enforced a measure (line length) and have 14px font (for memory it was 13px before being bumped up in 2014).

I would like to think there’s a solid reason for this, but I can’t for the life of me work out what it is. Maybe it’s something to do with being able to vertically scan the article, I don’t know.

I’ve been consuming Wikipedia with 18px text and 700px line length for years now and I’ve got no complaints.

![](https://cdn-images-1.medium.com/max/2000/1*CGgCTocnhmQLpaWYeRh6-A.png)

Courtesy of [the Skinny extension](https://chrome.google.com/webstore/detail/skinny/lfohknefidgmanghfabkohkmlgbhmeho) (shameless plug).

When I am forced to return to the default view every so often, it does my head in.

![](https://cdn-images-1.medium.com/max/2000/1*-psbviYTpIj2VOo4r8yiGg.png)

Wikipedia: exercising neck muscles since 2001. It’s like watching a shuttlecock match on the moon.

(My humble suggestion to Wikipedia: bump your desktop body text to 15px tomorrow, then increase it by 1px every year for the next five years — it will still be smaller than the text you’re reading now.)

The point to this little aside is: if your text is difficult to read to start with, a web font can only offer a small improvement at best. So get the foundations of readable typography right before even thinking about font faces.

---

If you don’t know anything about typography, but care about readability, try this as a starting point:

- A minimum of 18px font size
- Line spacing of 1.6
- #333 for color or thereabouts
- Limit your lines to a width of 700px

But don’t take my word for it, you can take your inspiration from Medium, The New Yorker, Smashing Magazine, longform.org, even the Node and NPM documentation. They have all clearly given consideration to readability and you’ll find some obvious similarities between them.

Once you have the fundamentals sorted, you can compare system fonts and web fonts.

(I have a premonition that people will argue with this — it’s my own fault for offering advice with any level of specificity — so I’ll get out in front of it here: apply common sense to what you read on the internet, adjust to taste, don’t do things you don’t want to do. Also don’t eat dishwasher tablets and if pain persists, see a doctor.)

---

Now, I want you to promise me that you’re not going to scroll up.

Because…

Here’s that block of text again.

![](https://cdn-images-1.medium.com/max/1600/1*Q-h43aVyuDsrHRVXqx7QbQ.png)

Is it easier to read than the first one? Harder to read? The same?

It’s easy, when given two chunks of text side by side, to flick your eyes between them and convince yourself eventually that one is easier to read than the other. But if that difference isn’t apparent without the direct comparison, then you probably have two typefaces that are both perfectly acceptable.

For the sake of satisfaction, here they are side by side, where you can quite clearly see that they’re different. One’s a web font, the other a system font.

![](https://cdn-images-1.medium.com/max/2000/1*eS3Yg49ckvxMdo9dv-OPQA.png)

Source: [New Republic](https://newrepublic.com/minutes/143094/eliminating-coal-save-lives-per-year-entire-coal-industry-employs) (Also, I Photoshopped three differences into the pictures)

I’m not going to tell you which font is which.

So back to the question from the flow chart: “Does the web font make your site easier to read?”. I would like to think, that in the cold light of day, any reasonable person would look at the above comparison and say *no*, neither of these is easier to read than the other.

(Now I think about it, this is actually a great test to see if you’re a reasonable person.)

**Conclusion**: if your site doesn’t have much text, a web font will make little difference to readability. But if your site is all about reading, this one’s probably not so easy. *I* think Medium’s font definitely makes the text more pleasant to read. And *I* think New Republic’s font makes no difference whatsoever. You need to find a way to objectively answer this question for your site — for your readers.

And if you decide that a web font makes no meaningful difference to readability then you’re a step closer to the ultimate goal — not having to faff about with web fonts.

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
  