> * 原文地址：[A day without Javascript](https://sonniesedge.co.uk/blog/a-day-without-javascript)
> * 原文作者：[A day without Javascript](https://sonniesedge.co.uk/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# A day without Javascript

As I write this it’s raining outside, and I’m trying to avoid having to go out into the murk and watch the Germans conduct their annual [diversity maneuvers](http://www.karneval-berlin.de/en/). I’ve therefore decided to pass my time by doing the one thing that counts as a religious crime in web dev land: I’m going to turn off javascript in my browser and see what sites work and what sites don’t.

I know, I know, my life is simply too exciting.

Now, I know that because I write a lot about the universal web and progressive enhancement, people assume that I must hate javascript.

This would be an incorrect assumption.

I simply hate people relying on brittle client-side javascript when there are other alternatives. In the same way as I wouldn’t rely on some unknown minicab firm as the sole way of getting me to the airport for a wedding flight, I don’t like relying on a non-guaranteed technology as the sole way of delivering a web app.

For me it’s a matter of elegance and simplicity over unnecessary complexity.

## Too many tabs

So, for my dreary grey day experiment I restricted myself to just the things open in my browser tabs. For normal people this might be two or three sites.

Not for me. I have approximately 17 shitmillion tabs open, because I Have a Problem With Tabs.

No seriously. I can never just close a tab. I’ve tried things like [One Tab](https://www.one-tab.com/) but I just can’t get down to less than 30 in any one window (“I’ll just save that tab for later” I think, each and ever time). Let’s just agree that I need some kind of therapy, and we’ll all be able to move on.

Anyway, there’s nothing fancy to this experiment. It was a case of turning off javascript in the browser and reloading a site, nothing more. To quickly disable the browser’s JS with one click I used Chrome and the [Toggle Javascript](https://chrome.google.com/webstore/detail/toggle-javascript/cidlcjdalomndpeagkjpnefhljffbnlo) extension - available, ironically enough, via the javascript-only Chrome web store.

Oh, and for you, sweet reader, I opened these tabs in new windows, so you don’t have to see the pain of 50 tabs open at once.

## First impressions

So how was it? Well, with just a few minutes of sans-javascript life under my belt, my first impression was “Holy shit, things are *fast* without javascript”. There’s no ads. There’s no video loading at random times. There’s no sudden interrupts by “DO YOU WANT TO FUCKING SUBSCRIBE?” modals.

If this were the only manifestation of turning off javascript, I’d do this for the rest of time. However, a lot of things don’t work. Navigation is the most common failure mode. Hamburger menus fail to internally link to a nav section (come on, that’s an easy one kids). Forms die when javascript is taken away (point the form to an endpoint that accepts GET/POST queries ffs). Above the fold *images* fail to load (you do know they’re streaming by default, yes?).

## The sites

Let’s get to it. I think I’ve got a pretty representative list of sites in my open tabs (perhaps due to the aforementioned Tab Problem). Howl at me on Twitter if you feel I missed anything particularly important.

### Feedly

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/feedly.png)

My very first attempt at sans-JS and I get nothing but a blank white page. Fuck you feedly.

*sighs, runs hands over face, shouts after Feedly*

Wait no, Feedly, I’m sorry. I didn’t mean that. It was the coffee talking. Can we talk this over? I like using you to keep up with blog posts.

But why do you work like this, Feedly? Your devs *could* offer the site in basic HTML and use advanced features such as, er, anchor links, to move to other articles. Then when JS is available, new content can be loaded via JS.

*Verdict:* Relationship counselling.

### Twitter

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/twitter.png)

Twitter shows the normal website (with full content) for a brief moment, then redirects to [mobile.twitter.com](https://mobile.twitter.com) (the old one, not the spanky new React one, of course). This is really frustrating, as the full site would still be great to load without javascript. It could use the same navigation method as the mobile site, where it sets a query parameter to the URL “?max_id=871333359884148737” that dictates what is the latest tweet in your timeline to show. Simple and elegant.

*Verdict:* Could try harder.

### Google Chrome

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/chrome_download.png)

The Google Chrome download page just fails completely, with no notice, only a blank white page.

*Sigh*.

*Verdict:* No Chrome for you, you dirty javascriptophobe!

### Youtube

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/youtube.png)

Youtube really really wants to load. Really, reallllllly, wants to. But then it fucks things up at the last nanosecond and farts out, showing no video, no preview icons, and no comments (that last one is perhaps a positive).

Even if the site is doing some funky blob loading of video media, it wouldn’t be hard to put a basic version on the page initially (with `preload="none"`), and then have it upgrade when JS kicks in.

*Verdict:* Can’t watch My Drunk Kitchen or Superwoman. :( :( :(

### 24 ways

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/24ways.png)

I’ve had this open in my tabs for the last 6 months, meaning to read it. Look, I’M SORRY, okay? But holy fuck, this site works great without javascript. All the animations are there (because they’re CSS) and the slide in navigation works (because it internally links to the static version of the menu at the bottom of the page).

*Verdict:* Class act. Smoooooth. Jazzz.

### Netflix

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/netflix.png)

I’m using netflix to try and indoctrinate my girlfriend into watching Star Trek. So far she’s not convinced, mainly because “Tasha *slept with Mr Data?* But it’d be like fucking your microwave”.

Anyway, Netflix doesn’t work. Well, it loads the header, if you want to count that. I get why they don’t do things with HTML5 - DRMing all yo shit needs javascript. But still :(.

*Verdict:* JavaScript-only is the New Black

### NYtimes

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/nytimes_with_js.png)

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/nytimes_sans_js.png)

Not sure why this was in my tab list, but tbh I’ve found rotting tabs from 2015 in there, so I’m not surprised.

The NY Times site loads in *561ms* and 957kb without javascript. Holy crap, that’s what it should be like normally. For reference it took 12000ms (12seconds) and 4000kb (4mb) to load *with* javascript. Oh, and as a bonus, you get a screenful of adverts.

A lot of images are lazy loaded, and so don’t work, getting replaced with funky loading icons. But hey ho, I can still read the stories.

*Verdict:* Failing… to *not* work. Sad!

### BBC News

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/bbc_news.png)

It’s the day after the latest London terrorism attacks, and so I’ve got this open, just to see how the media intensifies and aids every terrorist action. The BBC is the inventor and poster-child for progressive enhancement via Cutting the Mustard, and it doesn’t disappoint. The non-CTM site works fully and while it doesn’t *look* the same as the full desktop site (it’s mobile-first and so is pretty much the mobile version), it still *works*.

*Verdict:* Colman’s Mustard

### Google search

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/google.png)

Without JS, Google search still does what it’s best at: searching.

Okay, there’s no autocomplete, the layout reverts to the early 2000s again, and image search is shockingly bad looking. But, in the best progressive enhancement manner, you can still perform your core tasks.

*Verdict:* Solid.

### Wikipedia

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/wikipedia.png)

Like a good friend, Wikipedia never disappoints. The site is indistinguishable from the JS version. Keep being beautiful, Wikipedia.

*Verdict:* BFFs.

### Amazon

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/amazon.png)

The site looks a little… *off* without JS (the myriad accordions vomit their content over the page when JS isn’t there to keep them under control). But the entire site works! You can still search, you still get recommendations. You can still add items to your basket, and you can still proceed to the checkout.

*Verdict:* Amazonian warrior.

### Google Maps

![](https://sonniesedge.co.uk/images/posts/a-day-without-javascript/google_maps.png)

Discounting Gmail, Google Maps is perhaps one of the most heavily used Single Page Applications out there. As such I expected some kind of fallback, like Gmail provides, even if it wasn’t true progressive enhancement. Maybe some kind of Streetmap style tile-by-tile navigation fallback?

But it failed completely.

*Verdict:* Cartography catastrophe.

## Overall verdict

This has made me appreciate the number of large sites that make the effort to build robust sites that work for everybody. But even on those sites that are progressively enhanced, it’s a sad indictment of things that they can be so slow on the multi-core hyperpowerful Mac that I use every day, but immediately become fast when JavaScript is disabled.

It’s even sadder when using a typical site and you realise how much Javascript it downloads. I now know why my 1GB mobile data allowance keeps burning out at least…

I maintain that it’s perfectly possible to use the web without javascript, especially on those sites that are considerate to the diversity of devices and users out there. And if I want to browse the web without javascript, well fuck, that’s my choice as a user. This is the web, not the Javascript App Store, and we should be making sure that things work on even the most basic device.

I think I’m going to be turning off javascript more, just on principle.

Haters, please tweet at me as you feel fit.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
