> * 原文地址：[The Story of CSS Grid, from Its Creators](https://alistapart.com/article/the-story-of-css-grid-from-its-creators)
> * 原文作者：[Aaron Gustafson](https://alistapart.com/author/agustafson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-story-of-css-grid-from-its-creators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-story-of-css-grid-from-its-creators.md)
> * 译者：
> * 校对者：

# The Story of CSS Grid, from Its Creators

![](https://alistapart.com/d/_made/d/story-of-css-grid_960_636_81.jpg)

**A note from the editors:** We want to thank the Microsoft Edge team for sharing transcripts of the interviews they conducted with many of the brilliant people who have contributed to the development of CSS Grid. Those transcripts proved invaluable in compiling this history. You can watch the short video they produced from those interviews, [Creating CSS Grid](https://channel9.msdn.com/Blogs/msedgedev/Creating-CSS-Grid), on [Channel 9](https://channel9.msdn.com/).

On October 17th, Microsoft’s Edge browser shipped its implementation of CSS Grid. This is a milestone for a number of reasons. First, it means that all major browsers now support this incredible layout tool. Second, it means that all major browsers rolled out their implementations in a single year(!), a terrific example of standards success and cross-browser collaboration. But third, and perhaps most interestingly, it closes the loop on a process that has been more than 20 years in the making.

## Not a new idea

While the modern concept of a “grid layout” has been with us since the Industrial Revolution, grids have been a design tool for centuries. As such, it shouldn’t come as a shock that grid-based layouts have been a goal of CSS since the beginning.

According to Dr. Bert Bos, who co-created CSS with Håkon Wium Lie, grid-based layouts have actually been on his mind for quite some time.

“CSS started as something very simple,” Bos recalled. “It was just a way to create a view of a document on a very simple small screen at the time. Twenty years ago, screens were very small. So, when we saw that we could make a style sheet for documents, we thought, _Well, what else can we do now that we have a system for making style sheets?_”

Looking at what books and magazines were doing with layout was a great inspiration for them.

“Independent of the content on every page, it has a certain layout,” Bos said. “Page numbers are in certain places. And images are always aligned to the certain sides—left or right or in the middle. We wanted to capture that.”

Early on, browser makers wrote off the idea as “too complex” to implement, but grid layout concepts kept cropping up. In 1996, Bos, Lie, and Dave Raggett came up with a “frame-based” layout model. Then, in 2005, Bos released the [Advanced Layout Module](https://www.w3.org/TR/2007/WD-css3-layout-20070809/), which later turned into the [Template Layout Module](https://drafts.csswg.org/css-template/). Despite enthusiasm for these concepts from the web design community, none of them ever shipped in a browser.

## Once more, with feeling

With grid concepts being thrown at the wall of the CSS Working Group with some regularity, folks were hopeful one of them would stick eventually. And the idea that did was a proposal from a couple of folks at Microsoft who had been looking for a more robust layout tool for one of their web-based products.

Phil Cupp had been put in charge of the UI team tasked with reimagining Microsoft Intune, a computer management utility. Cupp was a big fan of [Silverlight](https://en.wikipedia.org/wiki/Microsoft_Silverlight), a browser plug-in that sported robust layout tools from [Windows Presentation Foundation](https://en.wikipedia.org/wiki/Windows_Presentation_Foundation), and initially had planned to go that route for building the new Intune. As it happened, however, Microsoft was in the planning stages of Windows 8 and were going to enable building apps with web technologies. Upon learning this, Cupp wanted to follow suit with Intune, but he quickly realized that the web was in desperate need of better layout options.

He joined a new team so he could focus on bringing some of the rich layout options that existed in Silverlight—like grid layout—to the web. Interestingly, folks on this new team were already noticing the need. At the time, many app developers were focusing on iPhones and iPads, which only required designers to consider two different fixed canvas sizes (four, if you consider portrait and landscape). Windows had to support a ton of different screen sizes, screen resolutions, and form factors. Oh, and resizable windows. In short, Microsoft needed a robust and flexible layout tool for the web desperately if the web was going to be an option for native app development on Windows.

After working extensively with various teams within Microsoft to assemble a draft specification, Cupp and his team shipped a grid layout implementation behind the `-ms-` vendor prefix in Internet Explorer 10 in 2011. They followed that up with a [draft Grid Layout spec](https://www.w3.org/TR/2011/WD-css3-grid-layout-20110407/), which they presented to the W3C in 2012.

Of course, this was not the first—or even the third—time the W3C had received a grid layout spec to consider. What was different this time, however, was that they also had an actual implementation to evaluate and critique. Also, we, as developers, finally had something we could noodle around with. Grid layout was no longer just a theoretical possibility.

A handful of forward-thinking web designers and developers—Rachel Andrew, an Invited Expert to the W3C, chiefly among them—began to tinker.

“I came across CSS Grid initially at a workshop that Bert Bos was leading in French. And I don’t really speak French, but I was watching the slides and trying to follow along,” Andrew recalled. “I saw him demonstrate … the Template Layout spec. I think he was really talking about it in terms of print and using this stuff to create print layouts, but as soon as I saw that, I was like, _No, we want this for the web. This is something that we really need and its feasibility to properly lay things out._ And so I started digging into it, and finding out what he was doing, and building some examples.”

“Then I saw the Microsoft implementation [of the draft Grid Layout spec], which gave me a real implementation that [I could build examples to show other people](https://24ways.org/2012/css3-grid-layout/). And I wanted to do that—not just because it was interesting, and I like interesting things to play with—it was because I wanted to get it out there and get other people to have a look at it. Because I’ve been doing this for a long time and I know that specs often show up, and then no one really talks about them, and they kinda disappear again. And I was absolutely determined that Grid Layout wasn’t gonna disappear, it was gonna be something that other people found out about and got excited about it. And hopefully we’d actually get it into browsers and be able to use it.”

## The spec evolves

The draft spec that Cupp presented to the W3C, and that his team shipped in IE10, is not the [Grid Layout spec we have today](https://www.w3.org/TR/css-grid-1/). It was a step in the right direction, but it was far from perfect.

“The one [Phil Cupp submitted] was a very track-based system,” recalled Elika Etemad, an Invited Expert to the W3C and an Editor of the CSS Grid Layout Module. “There was only a numeric addressing system, there were no line names, there [were] no templates, none of that stuff. But it had a layout algorithm that they … were confident would work because they had been doing experimental implementations of it.”

“The original grid that Bert [Bos] came up with … was really the reason I joined the CSS Working Group,” recalled Google’s Tab Atkins, another Editor of the CSS Grid Layout Module. “At the time, I was learning all the terrible layout hacks and seeing the possibility to just write my page layout in CSS and just have it all, kinda, work was astonishing. And then seeing the draft from Phil Cupp … and seeing it all laid out properly and with a good algorithm behind it, I knew that it was something that could actually exist now.”

It was also a compelling option because, unlike previous proposals, which specified rigid layouts, this proposal was for a responsive grid system.

“You can [be] explicit about the size of a grid item,” Etemad explained. “But you can also say, _Be the size that your content takes up_. And that was what we needed to move forward.”

However, the draft spec wasn’t as approachable as many on the CSS Working Group wanted it to be. So the group looked to bring in ideas from some of its earlier explorations.

“What we really liked about Bert [Bos]’s proposal was that it had this very elegant interface to it that made it easy to express layouts in a way that you can intuitively see,” Etemad said. “It’s like an ASCII art format to create a template, and you could put [it] in your code, like the width of the columns and the heights of the rows. You could embed those into the same kind of like ASCII diagram, which made it a lot easier to see what you were doing.”

Peter Linss, then Co-Chair of the CSS Working Group, also suggested that they incorporate the concept of grid _lines_ in the spec (instead of only talking about _tracks_). He believed including this familiar graphic design concept would make the spec more accessible to designers.

“When we were thinking initially about CSS Grid, we were thinking about it in a very app-centric model,” recalled Microsoft’s Rossen Atanassov, who is also an Editor on the spec. “But grid is nothing new. I mean, grid’s been here for a very long time. And that traditional type of grid has always been based on lines. And we’d been kind of ignoring the lines. When we realized that we could marry the two implementations—the app side and the typography side of the Grid—this for me, personally, was one of those _aha_ moments that really inspired me to continue working on Grid.”

So the CSS Working Group began tweaking Microsoft’s proposal to incorporate these ideas. The final result allows you to think about Grid systems in terms of tracks or lines or templates or even all three at once.

Of course, getting there wasn’t easy.

## Refine, repeat

As you can probably imagine, reconciling three different ideas—Microsoft’s proposal, Bos’ Advanced Layout, and Linss’ addition of grid lines—wasn’t a simple cut and paste; there were a lot of tricky aspects and edge cases that needed to be worked out.

“I think some of the tricky things at the beginning [were] taking all the different aspects of … the three proposals that we were trying to combine and coming up with a system that was coherent enough to gracefully accept all of that input,” Etemad said.

Some ideas just weren’t feasible for phase one of a CSS grid. Bos’ concept, for instance, allowed for any arbitrary descendent of the grid to lay out as though it were a child element of the grid. That is a feature often referred to as “subgrid” and it didn’t make the cut for CSS Grid Layout 1.0.

“Subgrid has been one of those things that was pointed out immediately,” Atanassov said. “And that has been a blessing and kind of a hurdle along the way. It was … one that held back the spec work for quite a bit. And it was also one that was scaring away some of the implementers. … But it’s also one of the features that I’m … most excited about going forward. And I know that we’re gonna solve it and it’s gonna be great. It’s just gonna take a little while longer.”

Similarly, there were two options for handling content mapped to grid lines. On the one hand, you could let the grid itself have fixed-dimension tracks and adjust which ending grid line the overflowing content mapped to, based on how much it overflowed. Alternately, you could let the track grow to contain the content so it ended at the predefined grid line. Having both was not an option as it could create a circular dependency, so the group decided to put the grid-snapping idea on hold.

Ultimately, many of these edits and punts were made in light of the CSS Working Group’s three primary goals for this spec. It needed to be:

1.  **Powerful:** They wanted CSS Grid to enable designers to express their desires in a way that “made simple things easy and complex things possible,” as Etemad put it;
2.  **Robust:** They wanted to ensure there would not be gaps that could cause your layout to fall apart, inhibit scrolling, or cause content to disappear accidentally;
3.  and **Performant:** If the algorithm wasn’t fast enough to elegantly handle real-world situations like browser resize events and dynamic content loading, they knew it would create a frustrating experience for end users.

“[T]his is why designing a new layout system for CSS takes a lot of time,” Etemad said. “It takes a lot of time, a lot of effort, and a lot of love from the people who are working on it.”

## Where the rubber meets the road

Before a Candidate Recommendation (aka, a final draft) can become a Proposed Recommendation (what we colloquially refer to as a “standard”), the W3C needs to see [at least two independent, interoperable implementations](https://medium.com/net-magazine/establishing-web-standards-12f7f4308982). Microsoft had implemented their draft proposal, but the spec had changed a lot since then. On top of that, they wanted to see other browsers take up the torch before they committed more engineering effort to update it. _Why?_ Well, they were a little gun-shy after what happened with another promising layout proposal: [CSS Regions](https://www.w3.org/TR/css-regions-1/).

CSS Regions offered a way to flow content through a series of predefined “regions” on a page, enabling really complex layouts. Microsoft released an implementation of CSS Regions early on, behind a prefix in IE 10. A patch landed support for Regions in WebKit as well. Safari shipped it, as did Chrome (which was still running WebKit under the hood at the time). But then Google backed it out of Chrome. Firefox opposed the spec and never implemented it. So the idea is currently in limbo. Even [Safari will drop its experimental support for CSS Regions in its next release](http://caniuse.com/#search=css-regions). Suffice it to say, Microsoft wanted to be sure Grid wouldn’t suffer the same fate as Regions before committing more engineering resources to it.

“We had implementers that immediately said, ‘Wow, this is great, we should definitely do it,’” recalled Atanassov of Grid. “But [it’s] one thing … saying, ‘Yeah this is great, we should do it,’ and then there’s the next step where it’s adding resources and paying developers to go and actually implement it.”

“There was desire from other implementers—one of the spec editors is from Google—but there was still hesitancy to actually push code,” recalled Microsoft’s Greg Whitworth, a member of the CSS Working Group. “And … shipping code is what matters.”

In an interesting turn of events, the media company Bloomberg hired Igalia, an open source consultancy, to implement CSS Grid for both Blink and WebKit.

“Back in 2013 … [we] were contacted by [Bloomberg] … because they had very specific needs regarding defining and using grid-like structures,” recalled Sergio Villar Senin, both a software engineer at and partner in Igalia. “[T]hey basically asked us to help in the development of the CSS Grid layout specification, and also [to] implement it for [Blink and WebKit].”

“[Igalia’s work] helped tremendously because then developers [could] see it as possibly something that they can actually use when developing their sites,” Whitworth added.  
But even with two ready-made implementations, some folks were still concerned the feature wouldn’t find its footing. After all, just because a rendering engine is open source doesn’t mean its stewards accept every patch. And even if they do, as happened with CSS Regions, there’s no guarantee the feature will stick around. Thankfully, a good number of designers and developers were starting to get excited about Grid and began to put pressure on browser vendors to implement it.

“There was a pivotal shift with CSS Grid,” Whitworth said. “Starting with Rachel Andrew coming in and creating a ton of demos and excitement around CSS Grid with [Grid by Example](http://gridbyexample.com/) and starting to really champion it and show it to web developers and what it was capable of and the problems that it solves.”

“Then, a little bit later, Jen Simmons [a Designer Advocate at Mozilla] created something called [Labs](http://labs.jensimmons.com/) where she put a lot of demos that she created for CSS Grid up on the web and, again, continued that momentum and that wave of enthusiasm for CSS Grid with web developers in the community.”

 ![](/d/the-story-of-css-grid/edge-labs.jpg) 

Grid facilitates both traditional and (as shown here) non-traditional layouts. This is [a Grid Layout example](http://labs.jensimmons.com/2017/01-009L.html) from [Jen Simmons’ Labs](http://labs.jensimmons.com/), as seen in Edge 16. If you’d like to see it working in Edge but don’t run Windows, you can also [view it in BrowserStack](https://aka.ms/grid-edge-browserstack) (account required).

With thought leaders like Andrews and Simmons actively demonstrating the power and versatility of CSS Grid, the web design community grew more excited. They began to experiment on sites like [CodePen](https://codepen.io/search/pens?q=CSS+Grid&limit=all&type=type-pens), sharing their ideas and developing their Grid layout skills. We don’t often think about it, but developer enthusiasm has the power to bolster or bury a spec.

“We can write a spec, we can go implement things, but if there isn’t developer demand or usage of the features, it doesn’t really matter how much we do with that,” Whitworth said.

Unfortunately, with ambitious specs like Grid, the implementation cost can often deter a browser vendor from making the commitment. Without a browser implementation enabling developers to tinker and experiment, it’s hard to build enthusiasm. Without developer enthusiasm, browser vendors are reluctant to spend the money to see if the idea gains traction. I’m sure you can see the problem here. In fact, this is partly what has doomed Regions—[performance on mobile chipsets was another cited reason](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/kTktlHPJn4Q/JtyfOkPjKN4J)—at least for now.

Thankfully, Bloomberg willingly played the role of benefactor and got the ball rolling for this new incarnation of CSS Grid. So, with its help, Google landed an implementation of CSS Grid in Chromium 56 for Android in January of 2017. It landed its Chrome implementation in early March, just two days after Mozilla shipped its own implementation in Firefox. Before the month was over, Opera and Safari had also shipped support for CSS Grid.

Ironically, the last company to ship CSS Grid was Microsoft. But it released its implementation in Edge earlier this week.

“With features on the web platform … you’re waiting for a sweet spot,” Whitworth said, just prior to Grid’s release in Edge. “You want a solid spec, you want implementer interest, and you want tons of demand from web developers. Late 2016/early 2017 was that sweet spot. All of that happened. We upgraded our implementation and are stoked to ship it.”

“I don’t recall a feature ever shipping like CSS Grid has shipped. Every major browser will have shipped it within a matter of a single year, and it will be interoperable because we’ve been… implementing [it] behind flags, testing it, making future changes behind flags, and then when it was deemed stable, all the browsers are now shipping it natively.”

“With everybody shipping at approximately the same time,” Atkins said, “[Grid] goes from an interesting idea you can play with to something that you just use as your only layout method without having to worry about fallbacks incredibly quickly. … [It’s been] faster than I expected any of this to work out.”

## What Grid means for CSS

With Grid support no longer in question, we can (and should) begin to make use of this amazing tool. One of the challenges for many of us old timers who have been working with CSS for the better part of two decades, is that CSS Grid requires a whole new way of thinking about layout.

“It’s not just attaching your margins and properties to each individual element and placing them,” Bos said. “[Y]ou can now have a different model, a model where you start with your layout first and then pull in the different elements into that layout.”

“It is the most powerful layout tool that we have invented yet for CSS,” Atkins said. “It makes page layouts so ridiculously easy. … [P]eople have always been asking for better layouts. Just for author-ability reasons and because the hacks that we were employing weren’t as powerful as the old methods of just put[ting] it all in a big old table element—that was popular for a reason; it let you do powerful complex layouts. It was just the worst thing to maintain and the worst thing for semantics. And Grid gives you back that power and a lot more, which is kind of amazing.”

“CSS Grid takes all of that complicated stuff that we had to do to [achieve] basic layouts and makes it completely unnecessary,” Etemad said. “You can talk to the CSS engine directly[—]you, yourself, without an intermediary translator.”

CSS Grid offers a lot of power that many of us are only just starting to come to grips with. It will be interesting to see where we go from here.

“I think it’s going to be transformative,” Etemad said. “It’s going to take CSS back to what it was meant to be, which is styling and layout language that lifts all of that logic away from the markup and allows that clean separation of content and style that we’ve been trying to get from the beginning.”

“I’m excited about the future of CSS layout,” Whitworth said. “CSS Grid is not the end; it’s actually just the beginning. In IE 10 … [we shipped] CSS Regions as well as [CSS Exclusions](https://www.w3.org/TR/css3-exclusions/). I think as web designers begin to utilize CSS Grid more and more, they’ll realize _why_ we shipped all three together. And maybe we can continue what we did with CSS Grid and continue to improve upon those specifications. Get vendor desire to implement those as well. Get the community excited about them and push layout on the web even further.”

“I think that now we have Grid, Exclusions makes absolute sense to have,” Andrew said. “It gives us a way to place something in [a grid] and wrap text around it, and we don’t have any other way to do that. … And then things like Regions … I would love to see that progress because … once we can build a nice grid structure, we might want to flow content through it. We don’t have a way of doing that.”

“[A]s far as I’m concerned, this doesn’t stop here; this is just the start.”

## Getting into Grid

*   CSS Grid Layout Module Level 1  
    [https://www.w3.org/TR/css-grid-1/](https://www.w3.org/TR/css-grid-1/)
*   CSS Grid Layout – Mozilla Developer Network  
    [https://developer.mozilla.org/en-US/docs/Web/CSS/CSS\_Grid\_Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)
*   Grid by Example – Rachel Andrew  
    [https://gridbyexample.com/examples/](https://gridbyexample.com/examples/)
*   Grab & Go Grid Layout Patterns by Rachel Andrew  
    [https://gridbyexample.com/patterns/](https://gridbyexample.com/patterns/)
*   Layout Demos by Jen Simmons  
    [http://labs.jensimmons.com/2016/](http://labs.jensimmons.com/2016/)
*   Learn CSS Grid by Jen Simmons  
    [http://jensimmons.com/post/feb-27-2017/learn-css-grid](http://jensimmons.com/post/feb-27-2017/learn-css-grid)
*   CSS Grid and Grid Inspector in Firefox  
    [https://www.mozilla.org/en-US/developer/css-grid/](https://www.mozilla.org/en-US/developer/css-grid/)
*   Practical CSS Grid: Adding Grid to an Existing Design by Eric Meyer  
    [https://alistapart.com/article/practical-grid](https://alistapart.com/article/practical-grid)
*   Progressively Enhancing CSS Layout: From Floats To Flexbox To Grid by Manuel Matuzović  
    [https://www.smashingmagazine.com/2017/07/enhancing-css-layout-floats-flexbox-grid/](https://www.smashingmagazine.com/2017/07/enhancing-css-layout-floats-flexbox-grid/)
*   Box Alignment Cheatsheet by Rachel Andrew  
    [https://rachelandrew.co.uk/css/cheatsheets/box-alignment](https://rachelandrew.co.uk/css/cheatsheets/box-alignment)
*   CSS Grid Layout by Rachel Andrew – An Event Apart video  
    [https://aneventapart.com/news/post/css-grid-layout-by-rachel-andrewan-event-apart-video](https://aneventapart.com/news/post/css-grid-layout-by-rachel-andrewan-event-apart-video)
*   Revolutionize Your Page: Real Art Direction on the Web by Jen Simmons – An Event Apart video  
    [https://aneventapart.com/news/post/real-art-direction-on-the-web-by-jen-simmons-an-event-apart](https://aneventapart.com/news/post/real-art-direction-on-the-web-by-jen-simmons-an-event-apart)
*   “Learn Grid Layout” video series by Rachel Andrew  
    [https://gridbyexample.com/video/](https://gridbyexample.com/video/)
*   Why I love CSS Grid – a short video by Jen Simmons  
    [https://www.youtube.com/watch?v=tY-MHUsG6ls](https://www.youtube.com/watch?v=tY-MHUsG6ls)
*   Modern Layouts: Getting Out of Our Ruts by Jen Simmons – An Event Apart video  
    [https://vimeo.com/147950924](https://vimeo.com/147950924)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
