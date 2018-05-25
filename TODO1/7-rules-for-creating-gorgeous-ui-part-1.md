> * 原文地址：[7 Rules for Creating Gorgeous UI (Part 1)](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-1-559d4e805cda)
> * 原文作者：[Erik D. Kennedy](https://medium.com/@erikdkennedy?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/7-rules-for-creating-gorgeous-ui-part-1.md)
> * 译者：
> * 校对者：

# 7 Rules for Creating Gorgeous UI (Part 1)

## A non-artsy primer in digital aesthetics

### Introduction

OK, first things first. This guide is not for everyone. Who is this guide for?

*   **Developers** who want to be able to design their own good-looking UI in a pinch.
*   **UX designers** who want their portfolio to look better than a Pentagon PowerPoint. Or UX designers who know they can sell an awesome UX better in a pretty UI package.

If you went to art school or consider yourself a UI designer already, you will likely find this guide some combination of a.) boring, b.) wrong, and c.) irritating. That’s fine. All your criticisms are right. Close the tab, move along.

Let me tell you what you’ll find in this guide.

First, I was a UX designer with no UI skills. I _love_ designing UX, but I wasn’t doing it for long before I realized there were a bunch of good reasons to learn how to make an interface look nice:

*   My portfolio looked like crap, reflecting poorly on my work and thought process
*   My UX consulting clients would rather buy someone’s skills if their expertise extended to more than just sketching boxes and arrows
*   Did I want to work for an early-stage startup at some point? Best to be a sweeper

I had my excuses. _I don’t know crap about aesthetics. I majored in engineering– it’s almost a badge of pride to build something that looks awful._

> _“I majored in engineering — it’s almost a badge of
> pride to build something that looks awful.”_

In the end, I learned the aesthetics of apps the same way I’ve learned any creative endeavor: _cold, hard analysis_. And shameless copying of what works. I’ve worked 10 hours on a UI project and billed for 1. The other 9 were the wild flailing of learning. Desperately searching Google and Pinterest and Dribbble for something to copy from.

These “rules” are the lessons from those hours.

**So word to the nerds: if I’m any good at designing UI now, it’s because I’ve _analyzed_ stuff — not because I came out the chute with an intuitive understanding of beauty and balance.**

This article is not theory. This article is pure application. You won’t see anything about golden ratios. I don’t even mention color theory. Only what I’ve learned from being bad and then [deliberately practicing](http://calnewport.com/blog/2010/01/06/the-grandmaster-in-the-corner-office-what-the-study-of-chess-experts-teaches-us-about-building-a-remarkable-life/).

Think of it this way: Judo was developed based on centuries of Japanese martial and philosophical traditions. You take judo lessons, and in addition to fighting, you’ll hear a lot about energy and flow and harmony. That sort of stuff.

Krav Maga, on the other hand, was invented by some tough Jews who were fighting Nazis in the streets of 1930s Czechoslovakia. There is no _art_ to it. In Krav Maga lessons, you learn how to stab someone’s eye with a pen and book it.

This is the Krav Maga of screens.

#### The Rules

Here they are:

1.  **Light comes from the sky**
2.  **Black and white first**
3.  **Double your whitespace**
4.  **Learn the methods of overlaying text on images** (see [Part](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-2-430de537ba96) 2)
5.  **Make text pop— and un-pop** (see [Part](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-2-430de537ba96) 2)
6.  **Only use good fonts** (see [Part](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-2-430de537ba96) 2)
7.  **Steal like an artist** (see [Part](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-2-430de537ba96) 2)

Let’s get to it.

### Rule 1: Light Comes From the Sky

_Shadows are invaluable cues in telling the human brain what user interface elements we’re looking at._

This is perhaps the **most important non-obvious thing** to learn about UI design: _light comes from the sky._ Light comes from the sky so frequently and consistently that for it to come from below actually looks _freaky._

![](https://cdn-images-1.medium.com/max/400/1*eFJGYuA67SIzu9pB1MZFKQ.jpeg)

WoooOOOooo.

When light comes from the sky, it illuminates the tops of things and casts shadows below them. The tops of stuff are lighter, the bottoms are darker.

You wouldn’t _think_ of people’s lower eyelids as being particularly shaded, but shine some light on those suckers and all of a sudden it’s demon girl at your front door.

Well, the same is true for UI. Just as we have little shadows on all the undersides of all our facial features, there are shadows on the undersides of just about every UI element you can find. **Our screens are flat, but we’ve invested a great amount of art into making just about everything on them appear be 3-D**.

![](https://cdn-images-1.medium.com/max/800/1*DTB4xeMLpg0DW6NLOYBehw.png)

My favorite part of this image is the poker finger in the lower-right.

Take buttons. Even with this relatively “flat” button, there are still a handful of light-related details:

1.  The unpushed button (top) has a **dark bottom edge**. Sun don’t shine there, son.
2.  The unpushed button is **slightly brighter at the top** than at the bottom. This is because it imitates a slightly curved surface. Just as how you’d need to tilt a mirror held in front of you up to see the sun in it, surfaces that are tilted up reflect a _biiiiit_ more of the sun’s light towards you.
3.  The unpushed button casts a **subtle shadow**– perhaps easier to see in the magnified section.
4.  The pushed button, while still darker at the bottom than at the top, is **overall darker**– this is because it’s at the plane of the screen and the sun can’t hit it as easily. One could argue that all the pushed buttons we see in real life are darker too, because our hands are blocking the light.

That was just a button, and yet there are these 4 little light effects present. That’s the lesson here. Now we just apply it to _everything._

![](https://cdn-images-1.medium.com/max/800/1*4FCAIgmJa8BuildjlnsDeA.png)

iOS 6 is a little outdated, but it makes a good case study in light behavior.

Here is a pair of iOS 6 settings— “Do Not Disturb” and “Notifications”. NBD, right? But look how many light effects are going on with them.

*   The top lip of the inset control panel casts a small shadow
*   The “ON” slider track is also immediately set in a bit
*   The “ON” slider track is concave and the bottom reflects more light
*   The icons are set _out_ a bit. See the bright border around the top of them? This represents a surface perpendicular to the light source, hence receiving a lot of light, hence bouncing a lot of light into your eyes.
*   The divider notch is shadowed where angled away from the sun and vice versa

![](https://cdn-images-1.medium.com/max/800/1*gWuSN3QN9dSeVwSP2LZVow.png)

_A close-up of a divider notch. From an old_ [_Hubster_](http://hubster.tv/) _concept of mine._

Elements that are generally **inset**:

*   Text input fields
*   Pressed buttons
*   Slider tracks
*   Radio button (unselected)
*   Checkboxes

Elements that are generally **outset**:

*   Buttons (unpressed)
*   Slider buttons
*   Dropdown controls
*   Cards
*   The _button_ part of a selected radio button
*   Popups

Now that you know, you’ll notice it everywhere. You’re welcome, kid.

#### Wait, what about flat design, Erik?

iOS7 made a stir in the tech community for its “flat design”. This is to say that it is literally _flat._ There are no simulated protrusions or indentations— just lines and shapes of solid color.

![](https://cdn-images-1.medium.com/max/800/1*YAB8zDDxCmvegvxCu7d8kw.png)

I love _clean and simple_ as much as the next guy, but I don’t think this is a long-term trend here. The subtle simulation of 3-D in our interfaces seems far too natural to give up entirely.

**More likely, we’ll see semi-flat UI in the near future** (and this is what I recommend you become proficient in designing). I’m going to go ahead and call it “flatty design”. Still clean, still simple, but you’ll have _some_ shadows and cues for what to tap/slide/click.

![](https://cdn-images-1.medium.com/max/800/1*gWvCSNxqNjyYaq4IF31ZhQ.png)

OS X Yosemite— flatty, not flat.

As I’m writing this, Google is rolling out their “Material Design” language across their products. It’s a unified visual language that– at its core– seeks to imitate the physical world.

An illustration from the Material Design guide shows how to convey different depths using different shadows.

![](https://cdn-images-1.medium.com/max/800/1*TtuBo6cCUTyP8XIYGSrIyg.png)

![](https://cdn-images-1.medium.com/max/400/1*sHg3HCEciqqAk1xE8qMrdg.png)

This is the sort of thing I see sticking around.

It uses subtle real-world cues to convey information. **Key word, _subtle_**_._

You can’t say it doesn’t imitate the real-world, but it’s also not the web of 2006. There are no textures, no gradients, no sheens.

Flatty is the way of the future, I think. Flat? Psh, just a thing of the past.

![](https://cdn-images-1.medium.com/max/800/1*Zqcjyz-oIqZZojyYyWVl2Q.png)

That flat design looks so hot right now!

### Rule 2: Black and White First

_Designing in grayscale before adding color simplifies the most complex element of visual design– and forces you to focus on spacing and laying out elements._

UX designers are really into designing “mobile-first” these days. That means you think about how pages and interactions work on a phone _before_ imagining them on your zillion-pixel Retina monitor.

**That sort of constraint is great. It clarifies thinking**. You start with the harder problem (usable app on a teeny-weeny screen), then adopt the solution to the easier problem (usable app on a large screen).

Well here’s another similar constraint: design _black and white first_. Start with the harder problem of making the app beautiful and usable in every way, but without the aid of color. **Add color last, and even then, only with purpose**.

![](https://cdn-images-1.medium.com/max/800/1*qheNNhQhjjwxMeJ5XGocsA.png)

[Haraldur Thorleifsson](http://ueno.co/)’s grayscale wireframes look as good as lesser designer’s finished sites.

This is a reliable and easy way to keep apps looking “clean” and “simple”. **Having too many colors in too many places is a really easy way to screw up clean/simple**. B&WF forces you to focus on things like spacing, sizes, and layout first. And those are the primary concerns of a clean and simple design.

![](https://cdn-images-1.medium.com/max/600/1*YxV7C-nHHir-PSbJ4-jqhQ.png)

![](https://cdn-images-1.medium.com/max/400/1*RckBhZxKQfveClU7rwGuyg.jpeg)

![](https://cdn-images-1.medium.com/max/400/1*EnbssykGOuXeXMV3AQFyjw.png)

Classy grayscale.

There are some cases where B&WF isn’t as useful. Designs that have a strong specific attitude— “sporty”, “flashy”, “cartoony”, etc. — need a designer who can use color extremely well. But **most apps don’t have a specific attitude except _clean and simple_**. Those that do are admittedly much harder to design.

![](https://cdn-images-1.medium.com/max/600/1*OraO1vxtkxYteZyE4CXrOQ.png)

![](https://cdn-images-1.medium.com/max/600/1*JsbQFaIY6g697PMeEuMwvA.png)

Flashy and vibrant designs by [Julien Renvoye](http://www.julienrenvoye.fr/) (left) and [Cosmin Capitanu](http://radium.ro/) (right). Harder than it looks.

For all the rest, there’s B&WF.

#### Step 2: How to add color

The simplest color to add is one color.

![](https://cdn-images-1.medium.com/max/800/1*YxV7C-nHHir-PSbJ4-jqhQ.png)

Adding one color to a grayscale site draws the eye simply and effectively.

![](https://cdn-images-1.medium.com/max/800/1*pds21170RP-6ZIkuSxgI2Q.png)

You can also take it one step up. Grayscale + _two_ colors, or grayscale + multiple colors of a single hue.

> **Color codes in practice — i.e. wait, what’s a hue?**

> The web by and large talks about color as RGB hex codes. It’s most useful to ignore those. RGB is not a good framework for coloring designs. Much more useful is [HSB](https://learnui.design/blog/the-hsb-color-system-practicioners-primer.html) (which is synonymous with HSV, and similar to HSL).

> HSB is better than RGB because it fits with the way we think about color naturally, and you can predict how changes to the HSB values will affect the color you’re looking at.

> If this is news to you, here’s [a good primer on HSB colors](https://learnui.design/blog/the-hsb-color-system-practicioners-primer.html).

![](https://cdn-images-1.medium.com/max/800/1*tZRxO2DReDduBqOwgqd_yw.jpeg)

Single-hue gold theme from [Smashing Magazine](http://www.smashingmagazine.com/2010/02/08/color-theory-for-designer-part-3-creating-your-own-color-palettes/).

![](https://cdn-images-1.medium.com/max/800/1*-rbrbh20EHL_Ue_IDxl_0A.jpeg)

Single-hue blue theme from [Smashing Magazine](http://www.smashingmagazine.com/2010/02/08/color-theory-for-designer-part-3-creating-your-own-color-palettes/).

By modifying the **saturation** and **brightness** of a single hue, you can generate multiple colors— darks, lights, backgrounds, accents, eye-catchers— but it’s not overwhelming on the eye.

Using multiple colors from one or two base hues is the **most reliable way to accentuate and neutralize elements without making the design messy**.

![](https://cdn-images-1.medium.com/max/800/1*_fM8VVYx7hMgdJ_Wy24AXg.png)

Countdown timer by [Kerem Suer](http://kerem.co/).

#### A few other notes on color

Color is the most complicated area of visual design. And while a lot of stuff on color is obtuse and not practical for finishing the design in front of you, I’ve seen some really good stuff out there.

A small toolbox:

*   [**Learn UI Design**](http://learnui.design/?utm_source=medium&utm_medium=content&utm_campaign=7-rules-part-1). Shameless plug: this is a course I’ve created, and it contains 3 _hours_ of video about designing with color (and 13+ hours on other topics in UI design). Check it out at [_learnui.design_](http://learnui.design/?utm_source=medium&utm_medium=content&utm_campaign=7-rules-part-1).
*   [**Color in UI Design: A (Practical) Framework**](https://medium.com/@erikdkennedy/color-in-ui-design-a-practical-framework-e18cacd97f9e). If you liked this section, but want to hear more about _color_ (as opposed to just black and white), this is your article. And guess who wrote it!
*   [**Never Use Black**](http://ianstormtaylor.com/design-tip-never-use-black/) (Ian Storm Taylor). Talks about how totally flat grays almost never appear in the real-world, and how saturating your shades of gray– especially your darker shades– adds a visual richness to your designs. Plus, saturated grays more closely mimic the real-world, which is its own virtue.
*   [**Adobe Color CC**](https://color.adobe.com). An awesome tool for finding, modifying, and creating color schemes.
*   [**Dribbble search-by-color**](https://dribbble.com/colors/BADA55)**.** Another awesome way to find what works with a particular color. Talk about practical. If you already have one color decided, come look at what the world’s best designers are doing/matching with that color.

### Rule 3: Double your whitespace

_To make UI that looks designed, add a lot of breathing room._

In Rule 2, I said that B&WF forces designers to think about _spacing and layout_ before considering color, and how that’s a good thing. Well, it’s time we talk about spacing and layout.

If you’ve coded HTML from scratch, you’re probably familiar with the way HTML is, by default, laid out on the page.

![](https://cdn-images-1.medium.com/max/800/1*fS6ixQIk88MJlEmph7PeJA.png)

Basically, everything is smashed towards the top of the screen. The fonts are small; there’s absolutely no space between lines. There’s a _biiit_ of space between paragraphs, but it isn’t much. The paragraphs just stretch on to the end of the page, whether that’s 100 px or 10,000 px.

Aesthetically speaking, that’s _awful_. **If you want to make UI that looks _designed_, you need to add in a lot of breathing room**.

Sometimes a ridiculous amount.

> **Whitespace, HTML, and CSS**

> If you, like me, are used to formatting with CSS, where the **default is no whitespace**, it’s time to untrain yourself of those bad habits. Start thinking of whitespace as the default— everything starts as whitespace, until you take it away by adding a page element.

> Sound zen? I think it’s a big reason people still sketch this stuff.

> **Starting with a blank page means starting with nothing but whitespace**. You think of margins and spacing right from the very beginning. Everything you draw is a conscious whitespace-removing decision.

> **Starting with a bunch of unstyled HTML means starting with content**. Spacing is the afterthought. It has to be explicitly stated.

Here’s an illustrative music player concept by [Piotr Kwiatkowski](http://www.piotrkwiatkowski.co.uk/).

![](https://cdn-images-1.medium.com/max/1000/1*qFwXZ_05pRv2OtiaJHIp6Q.jpeg)

Pay particular attention to the menu on the left.

![](https://cdn-images-1.medium.com/max/400/1*jSC64LYfVYlMHaI_B7xfKQ.png)

Left menu.

The vertical space between the menu items is fully _twice_the height of the text itself. You’re looking at 12px font with just as much padding above and below it.

Or take a look at the list titles. **There’s a 15px space between the word “PLAYLISTS” and its own underline. That’s more than the** [**cap height**](http://en.wikipedia.org/wiki/Cap_height) **of the font itself!** And that’s to say nothing of the 25 pixels between the lists.

* * *

![](https://cdn-images-1.medium.com/max/400/1*43qoikq5esyOer2PpETX_Q.png)

More space in the top nav bar. The text “Search all music” is 20% of the height of the bar. The icons are similarly proportioned.

The left sidebar shows generous spacing in between lines of text, and more.

Piotr was conscientious about putting in extra space here, and it paid off. While this is just a concept he put together for the fun of it (as far as I know), as far as aesthetics go, it’s beautiful enough to compete with the best music UIs out there.

* * *

Good, generous whitespace can make some of the messiest interfaces look inviting and simple— like forums.

![](https://cdn-images-1.medium.com/max/800/1*g6m0YZVyMEVMuLXzO512gg.png)

Forum design concept by [Matt Sisto](http://sis.to/).

Or Wikipedia.

![](https://cdn-images-1.medium.com/max/800/1*SVtl39B-dSsHo3HFI0h4FA.png)

Wikipedia design concept by [Aurélien Salomon](https://www.behance.net/aureliensalomon).

You can find plenty of argument that, say, the Wikipedia redesign leaves out key functionality to using the site. But you can’t say it’s not a good way to learn!

Put space between your lines.

Put space between your elements.

Put space between your groups of elements.

**Analyze what works**.

* * *

_OK, that wraps up Part 1. Thanks for sticking around!_

In [Part 2](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-2-430de537ba96), I’ll be talking about the last 4 rules:

> **4. Learn the methods of overlaying text on images**

> **5. Make text pop— and un-pop**

> **6. Only use good fonts**

> **7. Steal like an artist**

If you learned something useful, [read Part 2](https://medium.com/@erikdkennedy/7-rules-for-creating-gorgeous-ui-part-2-430de537ba96).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
