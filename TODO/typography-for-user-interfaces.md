>* 原文链接 : [Typography for User Interfaces](https://viljamis.com/2016/typography-for-user-interfaces/)
* 原文作者 : [Viljami Salminen](https://viljamis.com/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Back in 2004, when I had just started my career, [sIFR](http://mikeindustries.com/blog/archive/2004/08/sifr) was the hottest thing out there. It was developed by [Shaun Inman](http://shauninman.com/pendium/) and it embedded custom fonts in a small Flash movie, which could be utilized with a little bit of JavaScript and CSS. At the time, it was basically the only way to use custom fonts in browsers like [Firefox](https://www.mozilla.org/en-US/firefox/new/) or [Safari](http://www.apple.com/safari/). The fact that this technique relied on Flash soon made it obsolete, with the release of the iPhone (without flash) in 2007.

> Our interfaces are written, text being the interface, and typography being our main discipline.

In 2008, browsers started eventually supporting the new CSS3 [@font-face rule](https://www.w3.org/TR/css-fonts-3/). It had already been a part of the CSS spec in 1998, but later got pulled out of it. I remember the excitement when I managed to convince one of our clients to utilize the new @font-face and rely on [progressive enhancement](https://en.wikipedia.org/wiki/Progressive_enhancement) to deliver an enhanced experience for browsers which already supported this feature.

Since my early days in the industry, I’ve grown to love type and all the little nuances that go into setting it. In this article, I want to share some of the fundamentals that I’ve learned, and hopefully help you get better at setting type for user interfaces.

## The first GUIs[#](https://viljamis.com/2016/typography-for-user-interfaces/#the-first-guis "Right click to copy a link to #the-first-guis")[#](https://viljamis.com/2016/typography-for-user-interfaces/#the-first-guis "Right click to copy a link to #the-first-guis")

While the history of typography dates back about [five thousand years](https://viljamis.com/2013/prototyping-responsive-typography/), we’ve had graphical user interfaces for mere four decades. One of the key turning points was in 1973, when [Xerox](https://en.wikipedia.org/wiki/Xerox) introduced [Alto](https://en.wikipedia.org/wiki/Xerox_Alto), which in essence created the foundation for today’s graphical UIs. _Alto_ was born a decade before any other GUI hit the mass market, and was seen as the future of computing.

![](http://ac-Myg6wSTV.clouddn.com/f8a8eab03c083c011ef2.png)

This early development for _Alto_ evolved to [Xerox Star](https://en.wikipedia.org/wiki/Xerox_Star) in the 80s and became the first commercial operating system with GUI.

![](http://ac-Myg6wSTV.clouddn.com/05e7c24bffd97ab16471.png)

Although neither _Alto_ nor _Star_ never really took off the ground, they greatly influenced the future development at [Apple](http://www.apple.com/) and [Microsoft](https://www.microsoft.com/en-us/) with their revolutionary mouse-driven GUI. A couple years later, in 1984, [Steve Jobs](https://en.wikipedia.org/wiki/Steve_Jobs) introduced the first [Mac OS](https://www.youtube.com/watch?v=VtvjbmoDx-I).

![](http://ac-Myg6wSTV.clouddn.com/9172afe82db3c54f6e84.gif)

The release of the Macintosh meant custom typography suddenly becoming available to the masses for the first time ever. The [original Mac](https://en.wikipedia.org/wiki/Macintosh_128K) came pre-installed with many [iconic typefaces](https://en.wikipedia.org/wiki/Fonts_on_Macintosh), and over the next few years, multiple type foundries started releasing more and more digital versions of their popular typefaces.

![](http://ac-Myg6wSTV.clouddn.com/7f17f13d792c5b467d6a.gif)

When inspecting these early graphical user interfaces closer, we realize that most of their elements are written language. These GUIs are essentially pure text — collections of singular words displayed in isolation from one another.

We can make a similar observation by inspecting almost any modern interface too. Our interfaces are written, text being the interface, and typography being our main discipline.

## Text is interface[#](https://viljamis.com/2016/typography-for-user-interfaces/#text-is-interface "Right click to copy a link to #text-is-interface")[#](https://viljamis.com/2016/typography-for-user-interfaces/#text-is-interface "Right click to copy a link to #text-is-interface")

Every word and letter in an interface matters. Good writing is good design. Text is ultimately [interface](http://thomasbyttebier.be/blog/the-best-ui-typeface-goes-unnoticed), and it’s us, the designers, who are the copywriters shaping this information.

Take a look at the example below and imagine the elements taken apart and put down on a table in front of you. Observe what’s left. A collection of singular words, two images and few icons.

![](http://ac-Myg6wSTV.clouddn.com/304f7794e6e2220121f3.jpg)

Our work is not about putting random things on screen and making them look pretty, but instead starting from the most important parts, [the copy and the content](https://viljamis.com/2013/prototyping-responsive-typography/), and figuring other details up from there. That’s where the core of our craft lies.

The clarity of letterforms plays a key role too. It might not seem to matter much at first, especially if our brain needs to pause only for a fraction of a second to decipher a word shape. But when we multiply this across numerous instances and letter combinations, our typographic choices become much more apparent.

Of course, there are more nuances to interface design; things like balance, positioning, hierarchy and structure, but good copywriting and typography [takes us 95% there](https://ia.net/know-how/the-web-is-all-about-typography-period).

> A great designer knows how to work with text not just as content, he treats text as a user interface.”
> 
> – Oliver Reichenstein

## How we read[#](https://viljamis.com/2016/typography-for-user-interfaces/#how-we-read "Right click to copy a link to #how-we-read")[#](https://viljamis.com/2016/typography-for-user-interfaces/#how-we-read "Right click to copy a link to #how-we-read")

If the letters that we put on screens are so important, then we should spend some time studying how we read and how that affects our design decisions.

> An isolated word that has fewer than 20 characters will be read more slowly than a word that forms a part of a longer sentence.

One of the key findings that I had back when I was reading _Billy Whited’s_ article on [Setting Type for User Interfaces](http://blog.typekit.com/2013/03/28/setting-type-for-user-interfaces/), is that the efficiency with which we read is a function of the amount of text available to us as we do so. This means that an isolated word that has fewer than 20 characters will be read more slowly than a word that forms a part of a longer sentence.

This results from the fact that our eyes don’t move smoothly across the text when we read longer sentences. Instead, they make discrete jumps between words, which are called [saccades](https://en.wikipedia.org/wiki/Saccade).

![](https://viljamis.com/type-for-ui/img/saccades.svg)

Saccades improve our reading capabilities and make it possible for us to skip shorter functional words completely. This is a key factor to keep in mind since our interfaces tend to have mostly isolated words. In essence, it means that we cannot rely on the effects of saccades at all.

Eventually, [knowing](http://researchonline.rca.ac.uk/957/1/Sofie_Beier_Typeface_Legibility_2009.pdf) that the identification of individual letters plays the most critical part in the reading process, it’s becoming apparent why our choice of typeface is extremely important.

![](https://viljamis.com/type-for-ui/img/bouma.svg)

In the past, many thought we recognize words by their so called [Bouma shape](https://en.wikipedia.org/wiki/Bouma), or the outline that a word creates. [In](http://blog.typekit.com/2013/03/28/setting-type-for-user-interfaces/) [later](http://www.microsoft.com/typography/ctfonts/wordrecognition.aspx) [studies](https://typography.guru/journal/how-do-we-read-words-and-how-should-we-set-them-r19/) [this](http://researchonline.rca.ac.uk/957/1/Sofie_Beier_Typeface_Legibility_2009.pdf) was proven to be somewhat wrong, and the readability and legibility of a given typeface should not be anymore evaluated only by its ability to generate a good bouma shape. Instead, we need to pay more attention to the letterforms themselves.

## What makes letters legible?[#](https://viljamis.com/2016/typography-for-user-interfaces/#what-makes-letters-legible "Right click to copy a link to #what-makes-letters-legible")[#](https://viljamis.com/2016/typography-for-user-interfaces/#what-makes-letters-legible "Right click to copy a link to #what-makes-letters-legible")

At first, it might seem hard or just plain impossible to answer this question. Since reading is a matter of habit, we read best, what we read most. How could we possibly determine what features make letters legible? To start gaining an understanding, we need to first break sentences into words, words into letters, and letters into smaller parts and start looking the finer details.

In 2008, Department of Psychology at the [University of Victoria](http://www.uvic.ca/) did [empirical tests](https://typekit.files.wordpress.com/2013/03/fiset_psychscience_2008.pdf) to reveal which areas of lowercase and uppercase Latin letters are most efficient for reading.

![](http://ac-Myg6wSTV.clouddn.com/11c589fd7d99f3b411e5.jpg)

The study revealed ​a few interesting things. First of all, it revealed that line terminations are the most important features for letter identification.

![](http://ac-Myg6wSTV.clouddn.com/38e3c405a7cc17950e30.jpg)

The image above shows which areas we pay most attention to when recognizing letters. These areas of a typeface should be designed both in a generic and familiar way and also in a way that stresses letter differentiation.

In 2010, there was also [another study](http://www.ingentaconnect.com/content/jbp/idj/2010/00000018/00000002/art00004), by [Sofie Beier](https://www.researchgate.net/profile/Sofie_Beier/publications) and [Kevin Larson](http://www.typecon.com/speakers/kevin-larson), that focused testing letter variations of frequently misrecognized letters.

![](http://ac-Myg6wSTV.clouddn.com/3f1d105d8753dc2a3b46.jpg)

This study found that some variations were more legible than others, despite the letters within a font having similar size, weight and personality. The results showed that narrow letters benefit from being widened, and that [x-height characters](https://en.wikipedia.org/wiki/X-height) benefit from using more of the [ascending](https://en.wikipedia.org/wiki/Ascender_%28typography%29) and [descending area](http://www.typographydeconstructed.com/descender/).

![](http://ac-Myg6wSTV.clouddn.com/d8a68ba28736039ee717.jpg)](http://legibilityapp.com/)

We can gain more understanding about the legibility of a given typeface by using [a tool I built](http://legibilityapp.com/) for a recent project. [Legibility App](http://legibilityapp.com/) allows you to simulate different _(often harsh)_ viewing conditions by applying a level of filters on top of the text — like blur, overglow and pixelation. The app is in beta, and for the time being, works in [Chrome](https://www.google.com/chrome/browser/desktop/), [Opera](http://www.opera.com/) and [Safari](http://www.apple.com/safari/).

## What to look for in a UI typeface?[#](https://viljamis.com/2016/typography-for-user-interfaces/#what-to-look-for-in-a-nbsp-ui-typeface "Right click to copy a link to #what-to-look-for-in-a-nbsp-ui-typeface")

Understanding how we read and what features make letters legible gives us a better overall view on what we should look for when choosing a UI typeface. I’ve gathered 10 key things below.

### 1\. Legibility[#](https://viljamis.com/2016/typography-for-user-interfaces/#1-legibility "Right click to copy a link to #1-legibility")

Legibility is the number one factor to consider. Letterforms need to be clear and recognizable. Letters with clear distinction in their forms perform better as user interface elements.<sup>[[5](https://prowebtype.com/picking-ui-type/)]</sup> Many [sans serif](https://en.wikipedia.org/wiki/Sans-serif) typefaces, including [Helvetica](https://en.wikipedia.org/wiki/Helvetica), have indistinguishable capital I and lowercase l, making these particular fonts bad choices for interfaces.

![](https://viljamis.com/type-for-ui/img/legibility.svg)

[Source Sans Pro](https://github.com/adobe-fonts/source-sans-pro) on the left compared to Helvetica on the right. It’s almost impossible to differentiate the first 3 letters on Helvetica. Source Sans Pro on the other hand performs much better. Some people would also agree that Helvetica sucks for any type of UI work since it wasn’t really developed for use on screen displays.

> Helvetica sucks. It really wasn’t designed for small sizes on screens. Words like ‘milliliter’ can be very difficult to decipher.”
> 
> – Erik Spiekermann

When Apple “momentarily” switched to using Helvetica as their main interface typeface, it caused real usability and readability issues for certain users. Eventually, this was one of the reasons that led Apple to design the typeface we now know as [San Francisco](https://developer.apple.com/fonts/). This new typeface is designed specifically for screens and it has higher x-height than Helvetica, looser spacing, and its letters are easier to distinguish from one another.

![](http://ac-Myg6wSTV.clouddn.com/50141b85472e3156ca89.png) <span class="desc">Image credit: [Thomas Byttebier](http://thomasbyttebier.be/blog/the-best-ui-typeface-goes-unnoticed)</span>

### 2\. Modesty[#](https://viljamis.com/2016/typography-for-user-interfaces/#2-modesty "Right click to copy a link to #2-modesty")

An ideal UI typeface doesn’t scream for attention, but rather goes unnoticed. The typeface you choose should stay out of the users’ way when they try to complete their task, by honoring the content in a way that doesn’t add to the users’ cognitive load.

![](https://viljamis.com/type-for-ui/img/modesty.svg)

### 3\. Flexibility[#](https://viljamis.com/2016/typography-for-user-interfaces/#3-flexibility "Right click to copy a link to #3-flexibility")

A UI typeface needs to be flexible. We are designing experiences for medium(s), where it’s not possible to control our user’s abilities, context, browser, screen size, connection speed, or even the input method used.

The typeface we choose should support these vast contexts and work well in different sizes, devices, and on a small screen in particular. Sans serifs that are made to work at small sizes on low resolution are preferred.<sup>[[5](https://prowebtype.com/picking-ui-type/)]</sup>

![](https://viljamis.com/type-for-ui/img/flexibility3.svg)

### 4\. Large x-height[#](https://viljamis.com/2016/typography-for-user-interfaces/#4-large-x-height "Right click to copy a link to #4-large-x-height")

X-height means the height of a lowercase “x”. You want to look out for a typeface with large [x-height](https://en.wikipedia.org/wiki/X-height) since it’s in general easier to read and renders better in small sizes. Don’t go too far though, since too large x-height makes the letters _n_ and _h_ difficult to distinguish.

![](https://viljamis.com/type-for-ui/img/x-height.svg)

### 5\. Wide proportions[#](https://viljamis.com/2016/typography-for-user-interfaces/#5-wide-proportions "Right click to copy a link to #5-wide-proportions")

Proportions refer to the width of a character in relation to its height. You want to look out for a typeface with wide proportions since it helps with legibility and is easier to read in small sizes on a screen.

![](https://viljamis.com/type-for-ui/img/proportions.svg)<span class="desc">Image credit: [Adobe Acumin](http://acumin.typekit.com/design/)</span>

### 6\. Loose letter spacing[#](https://viljamis.com/2016/typography-for-user-interfaces/#6-loose-letter-spacing "Right click to copy a link to #6-loose-letter-spacing")

> A good rule of thumb is that letter space should be slightly smaller than the counter space inside the letterforms.

The space around the letters is as important as the space within them. Letters that are too close to each other can be hard to read. A good UI typeface should have enough breathing room in-between letters, and even spacing to establish a steady rhythm.

On the other hand, if there’s too much spacing, the integrity of the word breaks. A good rule of thumb is that letter space should be slightly smaller than the counter space inside the letterforms.

![](https://viljamis.com/type-for-ui/img/spacing.svg)

### 7\. Low stroke contrast[#](https://viljamis.com/2016/typography-for-user-interfaces/#7-low-stroke-contrast "Right click to copy a link to #7-low-stroke-contrast")

Good UI typefaces have low stroke contrast. Typefaces with high-contrast might look good at larger sizes, but at small sizes on a screen thin strokes easily disappear. On the other end of the spectrum, we have typefaces like [Arial](https://en.wikipedia.org/wiki/Arial) and [Helvetica](https://en.wikipedia.org/wiki/Helvetica), that can have too little contrast between letter shapes, making the letters indistinguishable from each other.

It’s all about finding a balance between the two. Imagine the example below as a horizontal scale. You want to aim for something that is more towards the example on the right side.

![](https://viljamis.com/type-for-ui/img/contrast.svg)

### 8\. OpenType features[#](https://viljamis.com/2016/typography-for-user-interfaces/#8-opentype-features "Right click to copy a link to #8-opentype-features")

Making sure that the typeface you choose supports [OpenType features](https://typofonderie.com/font-support/opentype-features/) is important, since it provides much more flexibility for us. It’s often also an indicator that there’s a good support for different languages and [special characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters).

For me, one of the most useful OpenType Features has been [tabular figures](https://www.fonts.com/content/learning/fontology/level-3/numbers/proportional-vs-tabular-figures), which are numerals that share a common width. You might want to use them for example when working with timers or counters, or when you have a table displaying information like IP numbers.

![](http://ac-Myg6wSTV.clouddn.com/4d4aaafae8af043b335e.png) <span class="desc">Image credit: [Fontblog](http://www.fontblog.de/das-ende-der-postscript-type-1-schriften/)</span>

### 9\. Fallback fonts[#](https://viljamis.com/2016/typography-for-user-interfaces/#9-fallback-fonts "Right click to copy a link to #9-fallback-fonts")

Below is an experience that you’re all probably familiar with. What’s happening here is that the [web fonts](https://en.wikipedia.org/wiki/Web_typography) are blocking the actual content from showing up before they’re all fully loaded.

![](http://ac-Myg6wSTV.clouddn.com/c78ea12592cc07fdc519.png) <span class="desc">Image credit: [Filament Group](https://www.filamentgroup.com/lab/weight-wait.html)</span>

This can be [easily fixed](https://www.filamentgroup.com/lab/weight-wait.html) by loading the fonts in a non-blocking manner, which drastically cuts the loading time for the content. The drawback is that we need to define fallback fonts from the [default system fonts](http://www.granneman.com/webdev/coding/css/fonts-and-formatting/default-fonts/), which show while our custom fonts are loading.

![](http://ac-Myg6wSTV.clouddn.com/7351c4f5beff01c1bb7a.png) <span class="desc">Image credit: [Filament Group](https://www.filamentgroup.com/lab/weight-wait.html)</span>

### 10\. Hinting[#](https://viljamis.com/2016/typography-for-user-interfaces/#10-hinting "Right click to copy a link to #10-hinting")

Hinting is a process where fonts are adjusted for maximum readability on computer monitors. [Hinting](https://en.wikipedia.org/wiki/Font_hinting) tries to make vector curves render nicely to a grid of pixels by providing a set of guidelines for different sizes. At low screen resolutions hinting is usually critical for producing clear, legible text.

Hinting was originally invented by Apple, but since [TrueType font format](https://en.wikipedia.org/wiki/TrueType), and thus the instructions we’ve called “hinting,” are disap­pearing, I’d nowadays only consider this if you need to support [IE8](https://en.wikipedia.org/wiki/Internet_Explorer_8) or older browsers needing [TTF](https://viljamis.com/2016/typography-for-user-interfaces/%28https://en.wikipedia.org/wiki/TrueType%29) or [EOT format](https://en.wikipedia.org/wiki/Embedded_OpenType).

![](http://ac-Myg6wSTV.clouddn.com/88f0ad59f7eab23c41fc.jpg) <span class="desc">Image credit: [Typotheque](https://www.typotheque.com/articles/hinting)</span>

## The Future(s)[#](https://viljamis.com/2016/typography-for-user-interfaces/# "Right click to copy a link to #")

It’s been a relatively short ride for us, and I expect to see a lot of progress in terms of how type behaves on the web, how our [typographic tools](https://typecast.com/) mature, how [font formats](https://en.wikipedia.org/wiki/Category:Font_formats) keep evolving, and how we’ll be utilizing type in the (near) future.

> Ultimately, good typography enables productivity for everyone. It could even [save your life](https://www.propublica.org/article/how-typography-can-save-your-life).

I imagine we’ll start seeing much more [progressively enhanced](https://en.wikipedia.org/wiki/Progressive_enhancement) expe­riences where the text itself is fundamen­tally more important than our suggestions about how it should be typeset.<sup>[[6](http://nicewebtype.com/)]</sup> It’s really how things have always worked on the web, but we’re only now starting to take this issue seriously.

For ideal typography, we also have to know as much as possible about each user’s reading environment. This may seem obvious, but it really isn’t.<sup>[[7](http://alistapart.com/column/responsive-typography-is-a-physical-discipline)]</sup> In the future though, I imagine typefaces becoming more aware of their surroundings and starting to respond to a number of factors like [viewport](https://en.wikipedia.org/wiki/Viewport), [resolution](https://en.wikipedia.org/wiki/Display_resolution), [type rendering engine](http://typerendering.com/) used, [ambient light](https://developer.mozilla.org/en-US/docs/Web/API/Ambient_Light_Events), [screen brightness](https://en.wikipedia.org/wiki/Lumen_%28unit%29) and even the [viewing distance](http://webdesign.maratz.com/lab/responsivetypography/).

I also predict that fonts’ legibility adjustments will be eventually linked to [OS’s accessibility options](http://www.apple.com/accessibility/ios/) so that typefaces can automatically start adapting to different user needs.

Overall, I see the future for UI typography being all about sensors and font formats that can respond to data acquired from these sensors, and eventually also [new typographic tools](http://www.jon.gold/2016/05/robot-design-school/) that have contextual awareness which integrates more intelligent algorithms to our workflows.

All this is needed so that we, and the typefaces that we work with, can better respond to all these contexts we have to deal with.

![](http://ac-Myg6wSTV.clouddn.com/80d9d0e3f6fc41bfbe05.jpg) <span class="desc">Image credit: [Luke Wroblewski](https://www.flickr.com/photos/lukew/10430507184/in/photostream/)</span>

To ease our work…

![](http://ac-Myg6wSTV.clouddn.com/22b56fb16d9a52e6a0fb.jpg) <span class="desc">Image credit: [Samsung GearVR](http://www.samsung.com/us/explore/gear-vr/)</span>

…make our interfaces faster…

![](http://ac-Myg6wSTV.clouddn.com/0dc8c285f6f0f0a33bf9.jpg) <span class="desc">Image credit: [MozVR](https://mozvr.com/)</span>

…more accessible…

![](http://ac-Myg6wSTV.clouddn.com/163c2a0f3290257250e5.jpg)<span class="desc">Image credit: [Callan & Co](http://kallan.co/)</span>

…and eventually more legible and productive too…

![](http://ac-Myg6wSTV.clouddn.com/452d1e7bcde24b7e1cc8.jpg)<span class="desc">Image credit: [Microsoft Hololens](https://www.microsoft.com/microsoft-hololens/en-us)</span>

…because ultimately, good typography enables productivity for everyone. It could even [save your life](https://www.propublica.org/article/how-typography-can-save-your-life).<span title="Made with love by @viljamis" class="fleuron"> ❦</span>

**This article is loosely based on a talk that I did in one of our internal design workshops at [Idean](http://www.idean.com/) in Palo Alto, CA. [See the slide deck](https://viljamis.com/type-for-ui/).**

[](https://twitter.com/intent/tweet?text=Typography+for+User%C2%A0Interfaces&url=http://viljamis.com/2016/typography-for-user-interfaces/&via=viljamis)

