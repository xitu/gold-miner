> * 原文地址：[Typography as Base: From the Content Out](https://medium.com/subvisual/typography-as-base-from-the-content-out-c59fe7bfb633)
> * 原文作者：[Francisco Baila](https://medium.com/@fcBaila)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

---

![](https://cdn-images-1.medium.com/max/2000/1*1Km4fqgsA1Qod5grVqAECQ.png)

Photo by [Raphael Schaller](https://unsplash.com/@raphaelphotoch)

# Typography as Base: From the Content Out

*First published on *[*Subvisual’s blog*](https://subvisual.co/blog/posts/138-typography-as-base-from-the-content-out)*. *This blog post was born out of my necessity to find a structure in which I could rely on when designing any kind of web project.

### 0. Random

Before I started this research, my structure was very naive. When I came across a new project, my first move was to start drawing boxes and text blocks with randomly selected typefaces and margins. Not completely random of course, but with no serious thought behind it. If I needed a margin, I would start with 20px, and whenever I needed a bigger one I would double that value, so I ended up almost every time with margins like 20px, 40px, 80px and so on. The same with the typefaces chosen and their sizes. Selecting sizes always started at 16px or 18px adding 4px to get new ones. Once again the sizes would always end up being 16px, 20px, 24px and so on.

I started my journey on design through graphic design. In college, I spent a lot of time creating posters, books, and magazines. To do these kinds of pieces, I always went through very thorough processes of selecting fonts, sizes, margins, grids, etc. and I had excellent teachers that showed me how to do it. I liked doing graphic design, and I still do, but the web called me, and here I am, giving my first big steps after some big web projects. I also find myself asking why it is that I am not using processes like the ones I used before, on books and magazines, to do websites and products.

I am happy with the projects I’ve done so far, but I always get that feeling that something is missing. Some craftsmanship I would say. At Subvisual we care about our processes, and we are always searching for ways to improve them. The thing is that most of those processes are focused on User Experience, a subject that we care about. However, there is no good UX with a bad User Interface. I’m not saying that our UIs are bad. In fact, I think they are pretty cool but they lack craftsmanship. And you know, we strive for it. Curious and stubborn as I am, I went looking for solutions to this problem.

I started by googling and reading everything that could be interesting. I found some excellent articles, especially [this one from Zac Halbert](https://medium.com/tradecraft-traction/harmonious-typography-and-grids-10da490a17d) that ended up being an inspiration for this post and a formula that I used in my work ever since. I asked some friends that are working on graphic design how they are doing their stuff nowadays and found some books that helped me a lot in my quest.

### Our Project — [TurnGram](https://www.turngram.com/)

I’m going to take you through the process of bootstrapping a project using typography as base. We will start by the art direction and finish on the typography scale. Our project is TurnGram, a service that delivers your photos to your loved ones on a regular basis, hassle free. The design sprint has ended, our prototype is done and tested, and the first version will be born.

![](https://cdn-images-1.medium.com/max/800/1*_9cuEOL2vOdCBeNQ4JwYag@2x.png)

### 1. Art Direction

Let’s start with the Art Direction or goals, of the project. This is where we think about the mood of the project, the feel that we want users to have when looking to our website. Take the time to read the project’s copy carefully and to look at its images, if possible. We want to understand our project’s personality through its content. As you do it, write it down: **cozy, familiar and nostalgic**.

### 2. Hierarchy

Every structure needs hierarchy. You should take advantage of the time you are spending reading the content to set the rules of your project’s hierarchy. Set what is a text block, what is a heading, what is a secondary heading, and so on. Mark them, find examples for every type of content.

1. **H1** — Some of our favorite TurnGrams;
2. **H2** — Recipient Name & TurnGram Instructions;
3. **H3** — Do you ship overseas and to P.O. boxes?;
4. **Text block** — I would like to send my mother (Maria Eastman) photos of my family on a monthly basis. She loves to display photos around her home and show her guests recent pictures of the grandkids. So please make sure to include the kids in your photo selections as much as possible.;
5. **Buttons** — Start Now;

### 3. Typefaces selection

Once there are no more examples to cover, it’s time to make the most important style decision. Let’s select the typefaces we are going to use.

From now on, every decision that we make has to take into account **readability** and **legibility**. As described on Wikipedia, readability is the ease with which a reader can understand a written text. Legibility is the ease with which a reader can recognize individual characters in the text. I will be addressing them through the post.

Picking a typeface early on a project’s life will change the way you will make decisions later. There is one book that helped me a lot on how to choose and combine typefaces. [“The Elements of Typographic Style” by Robert Bringhurst](https://www.goodreads.com/book/show/44735.The_Elements_of_Typographic_Style) is considered by many a typography bible.

![](https://cdn-images-1.medium.com/max/800/1*Zxuu_UecxZmRbf3t-dGoMw@2x.png)

The first two advices that Robert Bringhurst gives us are **“Consider the medium for which the typeface was originally designed”** and **“When using digital adaptations of letterpress faces, choose fonts that are faithful to the spirit as well as the letter of the old designs.”** Be sure that the typeface you want was designed to be displayed on a screen or, if it is an adaptation, check if the font weights and proportions are well adapted.

**“Choose fonts that will survive, and if possible prosper, under the final printing conditions.”** From this, we must bear in mind what sizes our typefaces will be rendered in, a question of legibility. Before choosing the typeface, go for its specimen and check what sizes it is best rendered in. Our example has some long text blocks so we should aim for a base font size of 20px. If you are designing a blog post, for instance, you will want to be using a base font size between 20px and 24px with a good x-height(the height of the lowercase). This is a rule that I regularly apply in my work, but like all rules, it can be broken when we feel it can work differently.

**“Choose faces that suit the task as well as the subject.”** This project’s personality is cozy, familiar and nostalgic, so we should pick a typeface that reflects this.

**“Choose faces that can furnish whatever special effects you require.”** If your content has a lot of numbers in the text, for example, you want to choose a typeface that contemplates [text figures](https://en.wikipedia.org/wiki/Text_figures). The same goes to texts that need some emphasis where you could use italic, bold or even [small caps](https://en.wikipedia.org/wiki/Small_caps).

**“Start with a single typographic family.”** A lot of the projects that we see using two families could be set in only one. We should take advantage of the resources that our typeface gives us before we appeal to a new typeface.

Summing up, these are the guidelines to keep in mind when choosing typefaces:

1. Be sure that it was designed to be displayed on a screen;
2. Look for a font that looks good on 20px;
3. A typeface that looks good on long texts, cosy, familiar and nostalgic;
4. Be aware if your content needs “special effects”;
5. Take advantage of the typeface resources.

Make sure you do a lot of tests with multiple examples from your content before you make a decision. The best way to know if your typeface is the right one is to read the content with it. I will choose [Tisa Pro](https://www.fontfont.com/fonts/tisa), a serif font with multiple weights. It looks good on 20px; it looks good on long texts; it’s cosy and familiar due to its humanistic stroke. I don’t think that Tisa Pro can be considered to be nostalgic but not every requirement as to be achieved with type. You can rely on images, illustration, color, etc. I’ve checked that Tisa looks good in every kind of content that we have so we are ready to go.

![](https://cdn-images-1.medium.com/max/800/1*kmKqR2X5EWPXm1_uZbdtfg.png)

Almost ready. One thing that we can try here is the branding typeface. If you are doing a website for a project that already as branding work done, you should try to use its typeface or, at least, use one that looks good with it. However, in some cases, you will not like the branding typeface and that is ok. That is what happened to us here so we went in a different direction. Although it is good to stick with one typeface, we felt the need to use a different one because we were needing an extra layer of contrast.

We are going to use [Effra](https://www.daltonmaag.com/library/effra).

![](https://cdn-images-1.medium.com/max/800/1*5OUVDBgQb9yxp-gLB4Q0kA.png)

### 3.1. Pairing Typefaces

When pairing two typefaces we want to have contrast between them with linking details at the same time. First, Tisa is a serif and Effra is a sans-serif which is a great contrast point. They have similar x-heights which prevent us from creating two different scales — we will address this later. Effra mixes a geometric basis with some humanistic details, great to both create contrast and linking details with Tisa.

### 4 . Sizes

In the previous stages, we have already talked about some points that will come in handy here. As I said earlier, to choose a typeface you have to know the job it will perform. We already saw that our website has some long text blocks and that 20px is a good size, this is our base font size.

With a base font size comes a base line-height. Line-height is your font size plus the leading you want to give it. Leading is the space between one text line and the next. If you want your user to read faster or if you need to save space you can reduce the leading, like in books or newspapers. You can do the opposite if you want your user to have a more relaxed and comfortable reading.

Now that we need more numbers we need a scale to be the logic behind them.

> *“By using culturally relevant, historically pleasing ratios to create modular scales and basing the measurements in our compositions on values from those scales, we can achieve a visual harmony not found in layouts that use arbitrary, conventional, or easily divisible numbers.”*

> ***Tim Brown***

So we start with our base font size of 20px, and we want a comfortable reading. There is one tool that I find really useful and that will save our life at this point: [modularscale.com](http://www.modularscale.com/) by Tim Brown. This website lets you enter your base and a ratio and then it does all the math for you. In our example we want a relaxed pace reading so the ratio we will choose will be augmented fourth(1,414) `20 * 1,414 = 28.28`. After rounding, our base line-height is 28px. Some other examples of modular scales:

1. **Minor third(1,2) **`**20 * 1,2 = 24**` - fast reading speed and great space saving;
2. **Perfect fourth(1,333) **`**20 * 1,333 = 26,66**` - good reading speed and good space saving;
3. **Perfect fifth(1,5) **`**20 * 1,5 = 30**` - super relaxed reading speed.
4. **Golden section(1,618) **`**20 * 1,618 = 32,36**` - super duper relaxed reading speed.

![](https://cdn-images-1.medium.com/max/800/1*jsEcmLicghI-G6mHfzp8IA@2x.png)

### 4.1. Modular Scales

These scales are everywhere. They can be seen in molecules, flowers, the human body and that is why they make things so much more harmonious than randomly selected numbers. If we see something made of the same numbers as we are it will look much more harmonious.

> *“Simple, right? And, at its core, the idea is pretty basic. But, oddly enough, it’s quite easy to both under-estimate its implications and over-estimate its complexity (at least once you start to dig into it a bit).”*

> ***Billy Whited***

They started to first appear in musical intervals and have been used through history by architects, painters, musicians, furniture makers, and others. So, why shouldn’t we use them?

### 4.2. Typographic Scale

Modular scales will give us a visual harmony, a rhythm. Like in music, our websites and products need a flow that makes sense.

We have already chosen our scale so now you are going to apply it, creating our typographic scale. Remember when we set the hierarchy at phase 2? Let’s translate it now into numbers.

1. **H1** — `28,28 * 1,414 = 39,988` ~ 40px
2. **H2** — `20 * 1,414 = 28,28` ~ 28px
3. **H3**–20px (bold)
4. **Text block** — 20px (the base)
5. **Captions** — `20 / 1,414 = 14,144` ~ 14px (uppercase, bold)

I started at the base and followed what the modular scale gave me with my hierarchy in mind. For the buttons and labels, we are going to use 14px because we can use them in uppercase, so the legibility will not be damaged. When you are making these decisions make sure that you are testing them, don’t follow the scale blindly. It may happen that you find the scale not suitable for this task. In that case, go back and try another one. I will leave the line-height setting for later; you will see why.

### 5. Horizontal Grid

We can now start giving our first steps into our grid. The grid can be viewed from two perspectives, the horizontal and the vertical ones. Let’s start with the horizontal, the one that you may have seen more often. Grids are a fascinating subject; I recommend that you read [“Grid Systems” a beautiful book by Josef Müller-Brockmann](https://www.goodreads.com/book/show/350962.Grid_Systems_in_Graphic_Design_Raster_Systeme_Fur_Die_Visuele_Gestaltung).

![](https://cdn-images-1.medium.com/max/800/1*jEoCIfJRUuf-sFxYsujLFA@2x.png)

Grids allow us to solve visual organization problems. With these helpers it is easier to organize texts, images and other elements of our content. As Josef tells us in his book, the grid can only be conceived when we have an idea of the texts and images we are going to use. It is the content that is going to tell us our grid sizes.

We have already one size, the gutter (space between columns). The gutter should have the same size as our base line-height, 28px because this will be the most used margin.

![](https://cdn-images-1.medium.com/max/800/1*WV2zckqjC_SzSYi1URrQbA@2x.png)

Text lines should have an average of 10 words, so this will be our column width. We are going to pick some pieces of text from our content, set them at 20px/28px and adapt its width to the numbers of our scale.

![](https://cdn-images-1.medium.com/max/800/1*8VUz_kl9zv6tOh79N4AiYA.png)

452px is a good number for this. You don’t want to have text lines that are either too short or too long. Reading becomes more tiring, and it damages the readability.

![](ttps://cdn-images-1.medium.com/max/800/1*00f1sulKiGpeahauhNpiAA@2x.png)

We will start with 1440px of width because that is the maximum width to where we want to go with this project. In 1440px there could be three columns with 452px of width and between them two gutters with 28px of width. Our grid has a total width of 1412px.

![](https://cdn-images-1.medium.com/max/800/1*phsnJa9NzCW7RRRN6Yd10Q@2x.png)

Now, following Josef’s advice, the more columns we have, the more dynamic and creative we can be. So how about dividing our columns by 2? `452(one column) - 28(one gutter) = 424; 424 / 2 = 212` px(new column size). Our total grid size is still the same, but our number of columns is now 6 and our text block will occupy two columns and one gutter.

![](https://cdn-images-1.medium.com/max/800/1*4puYPozvbj97-Ol32w-dUQ@2x.png)

The number of columns should depend on the dynamism you want to give to your content as well.

![](https://cdn-images-1.medium.com/max/800/1*aIj-zCoeroxWU1ZSVLfXHA@2x.png)

### 5.1. Vertical Grid

The horizontal perspective is set. One more to go.

Baselines are where all our content will rest. With these lines it is much easier to align elements. So, our baselines are going to be half of the line-height, 14px and our scale will do the rest.

![](https://cdn-images-1.medium.com/max/800/1*jH_2M8_kEajFwM1Rnq-zew@2x.png)

On good examples of print projects, all the texts are aligned with the baselines and that gives us an exquisite look that is hard to reach on the web. Go to [modularscale.com](http://www.modularscale.com/) again and pick as much margin sizes as your project needs and list them neatly; have them match your baselines. Your margins will need a role. This role will be to separate different sections, titles from text blocks, elements inside a section, and others.

1. **14,144 ~ 14** — Spacing inside an element;
2. **28,28 ~ 28** — Sub-section and text blocks or other elements;
3. **39,988 ~ 42** — Sub-sections;
4. **113,052 ~ 112** — Different sections.

![](https://cdn-images-1.medium.com/max/800/1*HA7h_TMrcYddV4Ij_jENdA@2x.png)

Now that we have baselines we can go back to our typographic scale. We have lines every 14px, so we want our scale to match them.

### 6. Typographic Scale (with baselines)

We already knew our base line-height, 28px, the number right after our base font size, 20px. Text block — 20px — line-height — 28px — 2 baselines;

1. **H1**–40px; To know the line-height for font-size 40px you have to do a cross multiplication. So, if `20px -> 28px, 40px -> x, x = (40 * 28) / 20, x = 56`. Placing this number in our baseline will give us 56 but but you may need to round it. **H1** - 40px/56px - 4 baselines;
2. **H2**–28px/42px — 3 baselines;
3. **H3**–20px/28px — 2 baselines;
4. **Captions** — 14px; This case is not so simple. Font sizes that have the same size of baselines, or similar, need more space to breathe. So let’s add an extra baseline to this one. This will cause some imbalance when captions and text blocks are side by side. It’s something I’m still trying to sort out. **Captions** — 14px/28px — 2 baselines.

![](https://cdn-images-1.medium.com/max/800/1*kTIkLyNjd5T2UbgzSw-Wzg@2x.png)

### What has changed?

It’s easy to think that there is no real impact for users with this process but I’ll tell you what it has changed for me. Before this journey, I had no strong opinion on this subject. It was that feeling that something was missing that kept pushing me to start learning about it. Now, after some websites and products, I can say that my projects have harmony on them and that the content dictated the appearance of the project. It may be psychological, but I firmly believe it isn’t. People read my projects better because they have a well-thought scale. People will not get bored so easily because my websites are more dynamic now. We designers have to think about the people that use our products every day and they are worth every effort that we can put into them. I strongly believe that this is something that will have an enormous impact on a product’s lifetime.

### What about the 8pt grid, responsiveness, communication with developers, and all that stuff?

As everything we do here at Subvisual, this process is not written in stone. We are always trying to improve ourselves and our way of doing things. This has proven to be a very worthy system to follow but with some flaws that easily solved with other methods like the 8pt grid, which we also use. Plus, the number of variables in this process is very hard to incorporate into our designer-developer communication. These and other reasons led us into creating our own structure combining what is best on all systems we have tried before. We are working and testing it and soon we will be able to share it with the world, it will be worth the wait, I promise.

### References

Books

1. The Elements of Typographic Style — Robert Bringhurst
2. Grid Systems — Josef Müller-Brockmann

Posts

1. [Harmonious Typography and Grids](https://medium.com/tradecraft-traction/harmonious-typography-and-grids-10da490a17d) — Zac Halbert
2. [More Meaningful Typography](https://alistapart.com/article/more-meaningful-typography) — Tim Brown
3. [More Perfect Typography](https://www.youtube.com/watch?v=6s3XwSpY2vc) — Tim Brown
4. [R(a|ela)tional Design](https://8thlight.com/blog/billy-whited/2011/10/28/r-a-ela-tional-design.html) — Billy Whited

### Thank you!

Thank you for reading this, I hope you found it useful. If you have questions or something to share please drop me a line here or at twitter [@fcBaila](https://twitter.com/fcBaila).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
