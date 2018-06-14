> * 原文地址：[7 Rules for Creating Gorgeous UI (Part 2)](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-2-430de537ba96)
> * 原文作者：[Erik D. Kennedy](https://medium.com/@erikdkennedy?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-2.md)
> * 译者：
> * 校对者：

# 7 Rules for Creating Gorgeous UI (Part 2)

## A guide to visual aesthetics, written by a nerd

This is the second part in a two-part series. You should read the [first part first](https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-1.md).

We’re talking about rules for designing **clean and simple UI** without needing to attend art school in order to do so.

Here are the rules:

1.  Light comes from the sky (see [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-1.md))
2.  Black and white first (see [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-1.md))
3.  Double your whitespace (see [Part 1](https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-1.md))
4.  **Learn the methods of overlaying text on images**
5.  **Make text pop— and un-pop**
6.  **Only use good fonts**
7.  **Steal like an artist**

* * *

### Rule 4: Learn the methods of overlaying text on images

There are only a few ways of reliably and beautifully overlaying text on images. Here are five— and a bonus method.

If you want to be a good UI designer, you’ll have to learn how to put text over images in an appealing way. This is something that **every good UI designer does well and something every bad UI designer does piss-poorly—** or just _doesn’t_ do, in which case you’ll have a huge leg up after reading this section!

#### Method 0: Apply text directly to image

I hesitate to even include this, but it is _technically possible_ to put text directly on an image and have it look _OK_.

![](https://cdn-images-1.medium.com/max/800/1*cZFET5UcuL6rjVWkwqoK_A.png)

[Otter Surfboards](http://www.ottersurfboards.co.uk/). Hip and Instagrammy, but a bit difficult to read.

There are all sorts of problems and caveats with this method:

1.  The **image should be dark**, and not have a lot of contrast-y edges
2.  The **text has to be white**— I dare you to find a counter-example that’s clean and simple. _Seriously_. Just one.
3.  **Test it at every screen/window size** to make sure it’s legible

Got all those? Great. Now never change the text or the image, and you should be good to go.

I don’t think I’ve ever used text directly on top of an image for any professional project, and it’s really mentioned here as a sort of “control” method. That being said, it’s possible to do to _really_ cool effect— but be careful.

![](https://cdn-images-1.medium.com/max/800/1*aGKzy_8di06W8u1kmKcS4Q.png)

The Aquatilis website– definitely worth a visit.

#### Method 1: Overlay the whole image

Perhaps the easiest method to put text on an image is to overlay the image. If the original image isn’t dark enough, you can overlay the whole thing with translucent black.

Here’s a trendy splash image with a dark overlay.

![](https://cdn-images-1.medium.com/max/800/1*-9qT-d3DcjmXV4vZkyBE8g.png)

[Upstart website](https://www.upstart.com/) has a 35% opacity black filter.

If you hop into Firebug and remove the overlay, you’ll see that the original image was too bright and had too much contrast for the text to be legible. But with a dark overlay, _no problem_!

This method also works great for thumbnails or small images.

![](https://cdn-images-1.medium.com/max/800/1*xvsvxW00oE9NuhbRUAUK2Q.png)

Thumbnails from [charity:water](http://www.charitywater.org/) site.

And while a black overlay is simplest and most versatile, you can certainly find colored overlays as well.

![](https://cdn-images-1.medium.com/max/800/1*0LUET8aQnpFvVB4yNhQj1Q.png)

#### Method 2: Text-in-a-box

This is dead simple and very reliable. Whip up a mildly-transparent black rectangle and lather on some white text. If the overlay is opaque enough, you can have just about any image underneath and the text will still be totally legible.

![](https://cdn-images-1.medium.com/max/800/1*J_7pHmSn6NvTuC3xFNIlqA.png)

Modern Honolulu iPhone Concept by [Miguel Oliva Márquez](http://miguelolivamarquez.com/).

You can also throw in some color — but, as always, be judicious.

![](https://cdn-images-1.medium.com/max/800/1*6218qUE-AoaikksiQziL7Q.png)

Now in pink. By [Mark Conlan](http://markconlan.com/).

#### Method 3: Blur the image

A surprisingly good way for making overlaid text legible is to blur part of the underlying image.

![](https://cdn-images-1.medium.com/max/800/1*mC1oHWTKlRqOZ-ra3sLh-Q.png)

Copious blur overlays in Snapguide. Note the blurred areas are also darkened.

iOS 7 has really made background blurring a thing recently, though Vista used it to great effect too.

![](https://cdn-images-1.medium.com/max/600/1*FkH2ZkCQ0wmT5FxmaAMzaA.jpeg)

![](https://cdn-images-1.medium.com/max/600/1*FyZBDM_gMoJ8bCK3zVr_Fg.png)

You can also use the out-of-focus area of a photo as the blur. But beware— this method is not as dynamic. If your image ever changes, make sure the text is always over the blurry bits.

![](https://cdn-images-1.medium.com/max/800/1*mZ22i_UB57qdFBZwOqUFFA.png)

[Teehan + Lax](http://www.teehanlax.com/)

I mean, just _try_ to read the subheader below.

![](https://cdn-images-1.medium.com/max/1000/1*pMpduiy5C4LGu7abzj_a6g.png)

For the love of everything good in this world, how did [this](https://www.google.com/wallet/send-money/) get approved?

#### Method 4: Floor fade

The floor fade is when you have an image that **subtly fades towards black at the bottom, and then there’s white text written over it**. This is an ingenious method, and I have no idea who did it before Medium, but that’s where I first noticed it.

![](https://cdn-images-1.medium.com/max/1000/1*_uPTqFCygpKPJoC5q0y1mg.png)

To the casual observer, it appears that these Medium collections are displayed by plastering some white text over an image— but in response to that, I say **false**! There’s ever-so-subtle a gradient from the middle (black at 0% opacity) to the bottom (black at, ehhhhh maybe ‘bout 20% opacity).

Difficult to see, but definitely there, and definitely improving legibility.

> Also notice that the Medium collection thumbnails use a slight text shadow to further increase legibility. Those guys are _good_!

> The net effect is Medium can layer just about any text on any image and have a readable result.

Oh, and another thing— why does the image fade black at the _bottom_? For the answer to that, see [Rule 1](https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-1.md)— light always comes from the top. To look most natural to our eye, the image has to be slightly darker at the bottom, just like everything else we ever see.

Advanced move: mix the blur with the floor flade… introducing The Floor Blur.

![](https://cdn-images-1.medium.com/max/800/1*vjezz0sSxlioqbEHbov_uw.png)

The “floor blur” on SnapGuide. Look mom, no overlay!

#### Bonus Method: Scrim

How does the [Elastica blog](http://www.elastica.net/category/blog/) have a readable headline on top of a dynamic image every single time? The images are:

*   Not particularly dark
*   Kind of contrast-y

Yet it’s difficult to describe why the text is so legible. Take a look:

![](https://cdn-images-1.medium.com/max/600/1*UFnAScSM_SyiqI7g8e8Ajw.png)

![](https://cdn-images-1.medium.com/max/600/1*i1T-LV5JQMk95st51J8zDA.png)

Answer: the _scrim_.

A scrim is a piece of photography equipment that makes light softer. Now it’s also a visual design technique for softening an image so overlaid text is more legible.

If we browser zoom out on the Elastica blog, we can more clearly see what’s going on.

![](https://cdn-images-1.medium.com/max/800/1*BwU3s9dGxeUSpA-cIFuaHg.png)

There is a gradiated-opacity box around the “145,000 Salesforce Users Come out to Celebrate…” headline. It’s easier to notice against the solid blue background than against the contrast-y photos above it.

This is probably the most _subtle_ way of reliably overlaying text on images out there, and I haven’t seen it anywhere else (but it _is_ pretty sneaky). Mark it down, though. You never know when you’ll need it.

* * *

### Rule 5: Make text pop— and un-pop

Styling text to look beautiful and appropriate is often a matter of styling it in contrasting ways— for instance, larger but lighter.

In my opinion, one of the hardest parts of creating a beautiful UI is styling text— and it’s certainly not for unfamiliarity with the options. If you’ve made it through grade school, you’ve probably used every method of calling attention to or away from text that we see:

*   **Size** (bigger or smaller)
*   **Color** (greater contrast or lesser; bright colors draw the eye)
*   **Font weight** (bolder or thinner)
*   **Capitalization** (lowercase, UPPERCASE, and Title Case)
*   **Italicization**
*   **Letter spacing** (or— fancy term alert— _tracking!_)
*   **Margins** (technically not a property _of_ the text itself, but can be used to draw attention, so it makes the list)

![](https://cdn-images-1.medium.com/max/800/1*D7QBHz4TqdxzXphdioU_gg.png)

Solid use of color, capitalization, and spacing. By [@workjon](http://twitter.com/workjon)’s kid. Also, follow [@workjon](http://twitter.com/workjon)— his design writing is AMAZING.

There are a few other options that are possible for drawing your attention, but not particularly used or recommended:

*   **Underline.** Underline means links nowadays, and it’s not worth trying to force it to mean anything else, if you ask me
*   **Text background color.** Not as common, but the 37signals website had this as link styling for a while
*   **Strikethrough.** Back off, you 90s CSS wizard, you!

In my personal experience, when I find a text element that I can’t seem to find the “right” styling for, it’s not because I forgot to try caps or a darker color— _it’s because the best solution is often getting right a combo of “competing” properties._

#### Up-pop and down-pop

You can divide all the ways of styling text into two groups:

*   **Styles that _increase_ visibility of the text**. Big, bold, capitalized, etc.
*   **Styles that _decrease_ visibility of the text**. Small, less contrast, less margin, etc.

We’ll call those “up-pop” and “down-pop” styles, in honor of designers’ [favorite adjective](http://theoatmeal.com/comics/design_hell). We won’t call it “visual weight”, because that is boring.

![](https://cdn-images-1.medium.com/max/800/1*cT-Y5jcbdrUdO2JiBf8fZg.png)

Case study title from [hugeinc.com](http://hugeinc.com/case-study/material-design)

Lots of up-pop going on with the “Material Design” title. It’s **big**; it’s **high-contrast**; it’s **very** **bold**.

![](https://cdn-images-1.medium.com/max/800/1*yVbtuu-qvhFRXNwWKBvL-A.png)

The items in this footer, on the other hand, are down-popped. They’re **small**, **lower-contrast**, and a **less bold** font-weight.

Now the important part.

> _Page titles are the only element to style all-out_ **_up-pop_**_.
> For everything else, you need_ **_up-_ and _down-pop_**_._

If a site element needs emphasis, apply both up-pop and down-pop styles. This will prevent things from being overwhelming, but allow different elements the visual weight they should have.

![](https://cdn-images-1.medium.com/max/800/1*8YceqPbM08OB2kjJPEWzow.png)

A balance of visual styles.

The impeccably-designed Blu Homes website has some big titles, but **the emphasized word is lowercase**— too much emphasis would look overpowering.

![](https://cdn-images-1.medium.com/max/800/1*C0snGn4IAUg_KEjwwPQN3w.png)

These numbers on the Blu Homes site draw your eye with their size, color, and alignment— but notice that they’re **simultaneously downplayed with a very light font-weight, and lower-contrast color** than the dark gray.

The **small labels below the numbers**, however, while gray and small, are also _uppercase_ and _very bold_.

It’s all about the balance.

![](https://cdn-images-1.medium.com/max/800/1*phgw7PCxtkr78p0Td9yHcA.png)

contentsmagazine.com

Contents Magazine is a good case study in up/down-pop.

*   The **article titles** are basically the _only_ _non-italicized_ _page elements_. In this case, _lack_ of italicization more effectively draws the eye (particularly in combination with the bold font-weight)
*   The **author’s name** is bolded in the byline— making it stand out from the normal-weight “by”
*   The small, low-contrast “**ALREADY OUT**” text stays out of the way— but with its uppercase type, generous letter-spacing, and large margins, you can see it the _moment_ you look for it

#### Selected and hovered styles

Styling selected elements and hover effects are another round in the same game— but more difficult.

Usually, changing font-size, case, or font-weight will **change how large of an area the text takes up**, which can lead to seizing hover effects.

What does that leave you with?

*   Text color
*   Background color
*   Shadows
*   Underlining
*   Slight animations— raising, lowering, etc.

One solid option: try turning white elements colored, or turning colored elements white, but darkening the background behind them.

![](https://cdn-images-1.medium.com/max/800/1*_9M8qJFXvB7cEabkV-8qrw.png)

The selected icon goes from colored to white, but stays high-contrast against its background.

I’ll leave you with this: _styling text is hard_.

But every time I’ve thought “Maybe this text just _can’t_ look right”, I’ve been wrong. I just needed to get better. And to get better, I just had to keep trying.

So I offer you this bit of consolation: if it doesn’t look good, don’t worry– it _could_ if you were better. But hey, let’s keep on trying and _make ourselves better._

_Hey, PS: if you want to learn a ton more about styling text, check out_ [_Learn UI Design_](http://learnui.design/?utm_source=medium&utm_medium=content&utm_campaign=7-rules-part-2)_. I cover it in detail there._

* * *

### Rule 6: Use Good Fonts

_Some fonts are good. Use them._

_Note: There are no strategies or things to study in this section. I’m just going to list some nice free fonts for you to go download and use._

_Note #2: Based on broadening font options over the past couple years,_ and _some of these fonts getting overused, I’d recommend a different set of fonts today. For more on that, see_ [_Learn UI Design_](http://learnui.design/?utm_source=medium&utm_medium=content&utm_campaign=7-rules-part-2)_, which contains the full list in an interactive table._

Sites with a very **distinct personality** can use very **distinct fonts**. But for most UI design, you just want something **clean and simple**. That’s right, buddy, put down the [Wisdom Script](http://www.losttype.com/font/?name=wisdom_script).

Also, I’m **only recommending free fonts**. Why? This is a guide for folks who are _learning_. There’s more than enough out there at the zero-dollar price point. Let’s use it.

I recommend you download them all right now, and then go through your downloaded fonts as you start the visual design for your project.

![](https://cdn-images-1.medium.com/max/800/1*5Uv1DnYGFp5vG4RvW4QdXA.png)

The Font Book application “User” category is good for remembering what you downloaded.

![](https://cdn-images-1.medium.com/max/800/1*J_5zAxGLGQxma9wq5mZAYw.png)

Ubuntu

**Ubuntu** (above). Plenty of weights. A bit more distinctive than necessary for some apps— perfect for others. Available on [Google Fonts](http://www.google.com/fonts/specimen/Ubuntu).

![](https://cdn-images-1.medium.com/max/800/1*qeIEbAW5ylrBL7SYjGfq5Q.png)

Open Sans

**Open Sans** (above). An easy-to-read, popular font. Good for body copy. Available from [Google Fonts](http://www.google.com/fonts/specimen/Open+Sans).

![](https://cdn-images-1.medium.com/max/800/1*YWlIwiUEZU184CBTxhS3sw.png)

Bebas Neue.

**Bebas Neue** (above). Great for titles. All-caps. Available from [Fontfabric](http://fontfabric.com/bebas-neue/)— which has an awesome “Bebas Neue in use” gallery.

![](https://cdn-images-1.medium.com/max/800/1*lXoXBsreAzsDUNakvTTcQg.png)

Montserrat

**Montserrat** (above). Only two weights, but good enough to make the cut. Definitely the best free alternative to Gotham and Proxima Nova, but nowhere near as good as those two. Available on [Google Fonts](http://www.google.com/fonts/specimen/Montserrat).

![](https://cdn-images-1.medium.com/max/800/1*ffj71mDykTq41o2P2Y7XUA.png)

Raleway

**Raleway** (above). Good for headlines; perhaps a _bit_ much for body copy (those w’s!). Has a really sweet ultralight weight (not pictured). Available on [Google Fonts](http://www.google.com/fonts/specimen/Raleway).

![](https://cdn-images-1.medium.com/max/800/1*1ZvAfIv56PYBxJe0cvWzqw.png)

Cabin

**Cabin** (above). Available on [Google Fonts](http://www.google.com/fonts/specimen/Cabin).

![](https://cdn-images-1.medium.com/max/800/1*u0LHdpKxw076R1MGNWemiQ.png)

Lato

**Lato** (above). Available on [Google Fonts](http://www.google.com/fonts/specimen/Lato).

![](https://cdn-images-1.medium.com/max/800/1*st1Z0NEH4ORQKnUyBojmqQ.png)

PT Sans

**PT Sans** (above). Available on [Google Fonts](http://www.google.com/fonts/specimen/PT+Sans).

![](https://cdn-images-1.medium.com/max/800/1*MntHOFiV1tpNPoPp76Wovw.png)

Entypo Social

**Entypo Social** (above). This is an icon font, and yes, once you use Entypo, you will see it _everywhere_, but the social icons are pure gold. Don’t feel like recreating a zillion social media logos in little colored circles? Sweet, me neither. Available at [Entypo.com](http://www.entypo.com/).

I’ll leave you with a few resources:

*   [**Beautiful Google web fonts**](http://hellohappy.org/beautiful-web-type/). This is an _awesome_ showcase of how good Google Fonts can look. I’ve returned to this simple page for inspiration at least a dozen times.
*   [**FontSquirrel**](http://www.fontsquirrel.com/). A collection of the best fonts available for commercial use, and totally free.
*   [**Typekit**](https://typekit.com/). If you are on Adobe Creative Cloud (i.e. subscription Photoshop or Illustrator, etc.), then you have free access to a [_ton_](https://typekit.com/lists/favorite-fonts) of amazing fonts. And yes, [Proxima Nova](https://typekit.com/fonts/proxima-nova) is included.

* * *

### Rule 7: Steal like an artist

The first time I sat down to try and design some app element— _a button, a table, a chart, a popup, whatever_— was the first time I realized how little I knew about how to make that element look good.

But as luck would have it, I haven’t had to invent any new UI elements yet. That means I can always see how others have done it and cherry-pick from the best.

But where should one cherry pick? Here are the resources I have found absolutely _the most useful_ while designing for clients. Listed in descending order:

#### [1\. Dribbble](http://dribbble.com)

This invite-only “show and tell for designers” site has **bar-none the highest quality of UI work online**. You can find great examples of almost anything here.

In fact, **you should** **follow my work on dribbble** [**here**](https://dribbble.com/erikdkennedy). Here are a few more people for you to follow as well:

*   [Victor Erixon](https://dribbble.com/victorerixon). Has a very distinct personal style– and it’s _great._ Beautiful, clean, flat designs. Dude’s been a designer for like 3 years and is already top of the game.
*   [Focus Lab](https://dribbble.com/focuslab). These guys are “Dribbble celebrities”, and their work lives up to the reputation. Really diverse; always top-notch.
*   [Cosmin Capitanu](https://dribbble.com/Radium). An awesome wildcard. He makes things that look crazy-futuristic without being garish. _Really_ good with colors. He doesn’t really focus on UX though— which is also a criticism of dribbble at large.

![](https://cdn-images-1.medium.com/max/400/1*RBeNdi_ihQcqPkhDDB9Iig.png)

![](https://cdn-images-1.medium.com/max/400/1*Ak6v-B69tzGoLQL9pjh1Yg.png)

![](https://cdn-images-1.medium.com/max/400/1*FO0Qaq9QDSF4R7p-ZFzpLg.jpeg)

Work by [Victor Erixon](https://dribbble.com/victorerixon), [Focus Lab](https://dribbble.com/focuslab), and [Cosmin Capitanu](https://dribbble.com/Radium), respectively

#### [2. Flat UI Pinboard](https://www.pinterest.com/warmarc/flat-ui-design/)

I haven’t the slightest idea who “warmarc” is, but his pinboard of phone UI had been _ridiculously_ useful to me trying to find disparate examples of beautiful UI.

![](https://cdn-images-1.medium.com/max/800/1*eDgNkeU45KBKvw1Tb35WJw.png)

#### [3. Pttrns](http://pttrns.com/)

A directory of mobile app screenshots. The nice thing about Pttrns is the whole site is organized by— _wait for it—_ UX patterns. This makes it very nice to quickly research whatever piece of interface you’re currently working on, be it a login page, a user profile, search results, etc.

![](https://cdn-images-1.medium.com/max/1000/1*Cacg0SgS2Mm7n-qaZyj6TQ.png)

* * *

I’m a firm believer that **every artist should be a parrot until they’re good at mimicking the best**. Then go find your own style; invent the new trends.

In the meanwhile, let’s make like thieves.

And, in the spirit of this section, the title “Steal Like an Artist” was lifted from an [eponymous book](http://www.amazon.com/gp/product/0761169253/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=0761169253&linkCode=as2&tag=e03fd7-20&linkId=EOZRG5UP4D6JMFIR) that I have not read, mostly because the title seems to sum up anything that the pages might contain.

* * *

### Conclusion

I wrote this because I would’ve loved to see this a short time ago. I hope it helps you. If you’re a **UX designer**, do a nice mockup after you’ve sketched the wireframes. If you’re a **dev**, take your next side project and make it look _good._ I don’t want UI to seem like it takes magical art school skills to do decently. Just _observation_, _imitation_, and _telling your friends what works_.

Anyhow, this is just what I’ve learned so far, and I am always a beginner.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
