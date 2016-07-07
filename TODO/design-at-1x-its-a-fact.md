>* 原文链接 : [Design at 1x—It’s a Fact](https://medium.com/shyp-design/design-at-1x-its-a-fact-249c5b896536)
* 原文作者 : [Kurt Varner](https://medium.com/@kurtvarner)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


#### The tangible benefits of designing at 1x pixel density

Let me start by saying, I’m sure this is already apparent for a good bunch of you. But through anecdotal observation and conversation, it appears there is still not consensus on the pixel density at which mobile screens should be designed. Mainly, designing at 1x or 2x.

#### Some quick context

When I first joined [Shyp](http://shyp.com), we were designing iOS screens at 2x and Android screens at 3x (xxhdpi). It was a huge pain in the ass. Why were we doing this?

1.  It’s counterintuitive to design at a low, non-retina screen resolution. I mean, I haven’t seen an iPhone 3GS in ages.
2.  At the time, it was easier to preview designs when mockups were 1:1 with the device you were previewing on. We were using an iPhone 5 and Nexus 5 as our test devices. Anything lower than 2x and 3x respectively, would appear blurry on the device.
3.  Resistance to change — since we were already designing at 2x, it’d be a lot of work to recreate all our designs at any other resolution (we’ve since redesigned everything at 1x).

These reasons are all pretty sad and can’t hold a stick to the benefits of designing at 1x.

### 7 reasons to design at 1x

There should be no further debate about designing at 1x or 2x. I haven’t seen a simple list of 1x benefits, so here it is.

### 1\. No math

If you’re designing at anything but 1x, you’ve decided to embark on a never ending journey of tediously converting your pixels for other device resolutions.

Give this a try—from 2x resolution, convert these pixels to points: font size 36px with padding of 40px left/right and 20px top/bottom. Now, what about from 3x pixel density?

Is that fun for you?

Me neither. And it’s even less fun when shit starts coming out to non-even points. “Yo engineer, can you please add 16.66pt padding to the top of this?”

### 2\. One-to-one between iOS and Android

Oh my god. What a time saver this has become. Everything translates perfectly between iOS and Android, allowing you to reuse text sizes, icons, and spacing. You know, all that good stuff in your style guide. It’s now a super simple translation.

### 3\. Straightforward exporting

Ok, so say you’re designing at 2x and want to export some assets. For iOS, you’ll need to export at .5x (1x actual), 1x (2x actual), and 1.5x (3x actual). Does that make any sense at all? And for Android, there are five sizes. You’d export at .5x (1x/mdpi actual), .75x (1.5x/hdpi actual), 1x (2x/xhdpi actual) 1.5x (3x/xxhdpi actual), and 2x (4x/xxxhdpi actual).

When designing at 1x, all this becomes clean. Exporting at 1x is actually 1x, and so forth. Simple.

Here’s a comparison between exporting from 1x and 2x in Sketch…

![](http://ww2.sinaimg.cn/large/a490147fgw1f5l6ixmm78j20m80own0l.jpg)

### 4\. Same as engineering measurements

<span class="markup--quote markup--p-quote is-other" data-creator-ids="anon">Shouldn’t your designs be speaking the same language as the code that’s implementing them? Yes, yes they should. And engineers use points, not pixels.</span>

Here’s how [Jiashu Wang](https://twitter.com/jiashuw), one of Shyp’s iOS engineers, responded to this topic:

> Engineers use points (instead of pixels) in the code. So 1x Sketch file is super nice for us because we can directly use the values we find from Sketch without doing any math using scale factors.

> For example, back when we were using 2x in the Sketch file, here’s what iOS engineers would do:  
> - Inspect a UI component in Sketch, see `50`  
> - Do the math: `50 (value from Sketch) / 2 (scale factor from 2x) = 25`  
> - Then use `25` in the code

> These days with `1x`, we see `25`, we use `25`

_(side note: our engineers work directly from Sketch. yeah, pretty baller.)_

Not only will your engineers love this, but it actually results in fewer mistakes when implementing the UI. Everyone wants to avoid unnecessary pixel tweaking during QA.

### 5\. Device previewing still works

Remember when mirroring from Sketch at 1x would result in a blurry screen? Well, those days are gone. Everything now seamlessly scales up during mirroring.

For Android devices and previewing from Photoshop, Skala Preview works in a similar way. All scales up nicely. Boom.

### 6\. Smaller file size, better performance

Your design files are going to be smaller, especially if they contain bitmap images. And if you’ve ever had many artboards on a single page in Sketch, lag can start to become an issue. Smaller artboards results in better performance from Sketch.

### 7\. Future proof

Designing at 1x defends you against Apple or Google introducing a new screen density in which you’d have to do yet another conversion. Recall when Apple released the iPhone 6 Plus and all the ensuing chatter around how to design for this screen type. This confusion led to a bunch of resources [explaining the conversion](http://www.paintcodeapp.com/news/iphone-6-screens-demystified).

Designing at anything other than 1x begins to feel arbitrary as more device screen densities are introduced. 1x is timeless.

**Update 1**: [Dave Bedingfield](https://twitter.com/dbedingfield), Sr. Staff Designer at Twitter, noted another great supporting point for 1x.

**Reason 8 — The placebo space effect**

Designing at 2x or 3x often gives a skewed sense of perception, as in “I have more space.” This is particularly true for newer designers who can tend to position too much into higher resolution areas, causing small tap targets and poor legibility. Designing at 1x helps prevent this effect.

> Designing for 2x can also cause designers to experience a placebo effect: designing at 2x is quite appealing, visually, and can mask. However, a baseline of 1x is still the optimal “starting point” in and I actually think our designs benefit from this constraint (a design that “works” at 1x will also “work” 2x; we avoid fooling ourselves into thinking that 2x provides more space to “cram” elements). The temptation to design for higher resolutions can cause tap targets to shrink, type sizes to decrease, legibility to suffer, etc.. Designing at 1x can help protect from that.

Dave is the most knowledgeable person I know on the topic of platform design, and leads these initiatives at Twitter. Check out this [longer excerpt](https://medium.com/@kurtvarner/heres-an-excerpt-from-dave-bedingfield-s-email-to-the-twitter-design-team-articulating-the-103b82055b70#.t09g4p9ne) from an email he sent years ago to the Twitter design team articulating the importance of designing at 1x.

There it is folks. Use and abuse this list as you’d like. Did I miss anything? I’m happy to append and edit this post as needed.

Special thanks to [Jeremy Goldberg](https://twitter.com/jeremygoldbrg) who originally convinced me that 1x was the righteous path.

[_Hit me on Twitter_](https://twitter.com/kurtvarner) _or follow the_ [_Shyp Design publication_](https://medium.com/shyp-design) _for more thoughts from our design team._
