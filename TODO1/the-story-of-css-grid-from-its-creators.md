> * 原文地址：[The Story of CSS Grid, from Its Creators](https://alistapart.com/article/the-story-of-css-grid-from-its-creators)
> * 原文作者：[Aaron Gustafson](https://alistapart.com/author/agustafson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-story-of-css-grid-from-its-creators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-story-of-css-grid-from-its-creators.md)
> * 译者：
> * 校对者：

# The Story of CSS Grid, from Its Creators
# 由 CSS 网格系统的创造者们所讲述的故事
![](https://alistapart.com/d/_made/d/story-of-css-grid_960_636_81.jpg)

**A note from the editors:** We want to thank the Microsoft Edge team for sharing transcripts of the interviews they conducted with many of the brilliant people who have contributed to the development of CSS Grid. Those transcripts proved invaluable in compiling this history. You can watch the short video they produced from those interviews, [Creating CSS Grid](https://channel9.msdn.com/Blogs/msedgedev/Creating-CSS-Grid), on [Channel 9](https://channel9.msdn.com/).
**一个来自编辑者的小提醒:** 我们想要感谢 Microsoft Edge 团队，因为他们分享了与许多对 CSS 网格系统的发展有杰出贡献的专家的采访手稿。在编辑这份关于 CSS 网格系统历史的文章中，这些手稿十分珍贵。同时，你也可以观看他们制作的关于这些采访的短视频, [Creating CSS Grid](https://channel9.msdn.com/Blogs/msedgedev/Creating-CSS-Grid), 在 [Channel 9](https://channel9.msdn.com/).

On October 17th, Microsoft’s Edge browser shipped its implementation of CSS Grid. This is a milestone for a number of reasons. First, it means that all major browsers now support this incredible layout tool. Second, it means that all major browsers rolled out their implementations in a single year(!), a terrific example of standards success and cross-browser collaboration. But third, and perhaps most interestingly, it closes the loop on a process that has been more than 20 years in the making.
在 2017 年 10 月 17 日， Microsoft’s Edge 浏览器发布了 CSS 网格系统。基于许多原因，这这是 CSS 历史上的一个里程碑。首先，它意味着所有的主流浏览器现在都支持这个令人惊叹的布局工具。其次，它也意味着所有的主流浏览器在同一年中大规模的实现了基于自身浏览器的 CSS 网格布局， 这是一个标准的成功，一次跨浏览器的合作，更是一次令人吃惊的例子。但是最后一点，或许是最有趣的一点，这次事件将一个本来超过20年为周期进行循环制定标准的过程，从此改写。

## Not a new idea
## 本来就不是一个新想法
While the modern concept of a “grid layout” has been with us since the Industrial Revolution, grids have been a design tool for centuries. As such, it shouldn’t come as a shock that grid-based layouts have been a goal of CSS since the beginning.
现代的网格布局系统自从工业革命以来就已经存在，网格一直是这么多世纪以来使用的一种设计工具。就其本身而言，CSS 基于网格的布局从一开始就不应该是一件令人震惊的事。

According to Dr. Bert Bos, who co-created CSS with Håkon Wium Lie, grid-based layouts have actually been on his mind for quite some time.
根据 Bert Bos 博士，他同时也是 CSS 的共同创造者与 Håkon Wium Lie，基于网格的布局对于他早已经思考过很久了。

“CSS started as something very simple,” Bos recalled. “It was just a way to create a view of a document on a very simple small screen at the time. Twenty years ago, screens were very small. So, when we saw that we could make a style sheet for documents, we thought, _Well, what else can we do now that we have a system for making style sheets?_”
“CSS 的开始是十分简单”，Bos 回想到，“CSS 本身只是一种在当时的小屏幕下创建文档视图的工具，20年前，屏幕很小。所以，当我们发现我们或许可以为文档创建样式，我们原以为，_既然有了一套创建样式的系统方式，还能对文档做什么呢？_”
Looking at what books and magazines were doing with layout was a great inspiration for them.
真正给我们启发的，是看到了那些在书籍和杂志中的布局用法。
“Independent of the content on every page, it has a certain layout,” Bos said. “Page numbers are in certain places. And images are always aligned to the certain sides—left or right or in the middle. We wanted to capture that.”
“每一页的内容是独立的，但是每一页都有一个确定的布局” Bos 说。“每一页的页码是在固定位置的。并且图片总是靠左，靠右或者居中。我们也想要模仿这样”
Early on, browser makers wrote off the idea as “too complex” to implement, but grid layout concepts kept cropping up. In 1996, Bos, Lie, and Dave Raggett came up with a “frame-based” layout model. Then, in 2005, Bos released the [Advanced Layout Module](https://www.w3.org/TR/2007/WD-css3-layout-20070809/), which later turned into the [Template Layout Module](https://drafts.csswg.org/css-template/). Despite enthusiasm for these concepts from the web design community, none of them ever shipped in a browser.
在初期阶段，浏览器的开发者试着提出了一些“过于复杂”的想法想要实现，但是网格布局这个概念始终会出现在这写文档中。在 1996 年，Bos, Lie 和 Dave Raggett共同提出了一个“frame-based”布局模型。之后，在2005年，Bos发布了[Advanced Layout Module](https://www.w3.org/TR/2007/WD-css3-layout-20070809/)，此文档之后变成了[Template Layout Module](https://drafts.csswg.org/css-template/)。尽管在web设计的社区中有关于此的大量关注与热情，但是没有一个提案能够真正在浏览器中实现。

## Once more, with feeling
## 再一次动情
With grid concepts being thrown at the wall of the CSS Working Group with some regularity, folks were hopeful one of them would stick eventually. And the idea that did was a proposal from a couple of folks at Microsoft who had been looking for a more robust layout tool for one of their web-based products.
随着网格概念正在有条不紊的被 CSS 工作组讨论，大多数人当时都希望其中的一个提案可以最终被采纳。而最终，真正被采纳的提案是由一群在微软的开发者所提出的，他们一直在寻找一个健壮的布局工具为了更好的开发他们 web 端的产品。

Phil Cupp had been put in charge of the UI team tasked with reimagining Microsoft Intune, a computer management utility. Cupp was a big fan of [Silverlight](https://en.wikipedia.org/wiki/Microsoft_Silverlight), a browser plug-in that sported robust layout tools from [Windows Presentation Foundation](https://en.wikipedia.org/wiki/Windows_Presentation_Foundation), and initially had planned to go that route for building the new Intune. As it happened, however, Microsoft was in the planning stages of Windows 8 and were going to enable building apps with web technologies. Upon learning this, Cupp wanted to follow suit with Intune, but he quickly realized that the web was in desperate need of better layout options.
Phil Cupp 当时一直是重新设计 Microsoft Intune（一款计算机管理工具） 的 UI 团队的负责人。Cupp 是 ，一个源于[Windows Presentation Foundation](https://en.wikipedia.org/wiki/Windows_Presentation_Foundation)的强大布局工具的浏览器插件[Silverlight](https://en.wikipedia.org/wiki/Microsoft_Silverlight)的狂热粉丝，并且甚至当时一开就打算以这种方式去重新构建新的 Microsoft Intune。然而之后， Microsoft 一直在 Windows 8 的计划准备阶段并且将要使用 web 端的技术打造应用。在得知此之后，Cupp 想要 Intune 这款产品也照着做，但是他很快就意识到 web 现阶段急需一款更出色的布局工具。

He joined a new team so he could focus on bringing some of the rich layout options that existed in Silverlight—like grid layout—to the web. Interestingly, folks on this new team were already noticing the need. At the time, many app developers were focusing on iPhones and iPads, which only required designers to consider two different fixed canvas sizes (four, if you consider portrait and landscape). Windows had to support a ton of different screen sizes, screen resolutions, and form factors. Oh, and resizable windows. In short, Microsoft needed a robust and flexible layout tool for the web desperately if the web was going to be an option for native app development on Windows.
于是，他加入了一个新的团队，为了能够专注于将已经存在于 Silverlight —— 一个类似于网格系统的布局方式 —— 引入 web 端。有趣的是，团队中的人已经意识到了这个需求。同时，许多开发者当时正在专注于 iPhones 和 iPads，这两种设备只需要开发者专注于两种不同的并且不变的画面大小（也有可能是4种，如果你考虑到肖像和风景）。于是，Windows 不得不支持大量的不同的屏幕大小，分辨率和形状因子。对了，还有可变化大小的屏幕。简而言之，Microsoft 急切需要一个健壮并且灵活的布局工具对于 web 端的设计，尤其假使 web端 将会成为开发 Windows 原生应用的平台。

After working extensively with various teams within Microsoft to assemble a draft specification, Cupp and his team shipped a grid layout implementation behind the `-ms-` vendor prefix in Internet Explorer 10 in 2011. They followed that up with a [draft Grid Layout spec](https://www.w3.org/TR/2011/WD-css3-grid-layout-20110407/), which they presented to the W3C in 2012.
在与不同的微软团队之间努力达成第一份草案之后，Cupp 和他的团队发布了一款网格布局工具，在 2011 年 IE10 发布`-ms-`前缀之后。他们紧随其后发布了草案[draft Grid Layout spec](https://www.w3.org/TR/2011/WD-css3-grid-layout-20110407/)，随后此草案也正式在 2012 年进入 W3C。

Of course, this was not the first—or even the third—time the W3C had received a grid layout spec to consider. What was different this time, however, was that they also had an actual implementation to evaluate and critique. Also, we, as developers, finally had something we could noodle around with. Grid layout was no longer just a theoretical possibility.
当然，这也不是第一次甚至也不是第三次 W3C 收到一份关于网格布局的提案。但这次不同的是，他们还对草案进行了一次可评估的实现。不仅如此，我们，作为开发则，最终也有了可以真正上手的机会。网格布局从此就不仅仅是理论上的可能性了。

A handful of forward-thinking web designers and developers—Rachel Andrew, an Invited Expert to the W3C, chiefly among them—began to tinker.
少数的几个具有前瞻性的 web 设计者和开发者比如在其中最重要的 W3C 的客邀教授 Rachel Andrew，开始试着对刚出炉的提案进行改进。

“I came across CSS Grid initially at a workshop that Bert Bos was leading in French. And I don’t really speak French, but I was watching the slides and trying to follow along,” Andrew recalled. “I saw him demonstrate … the Template Layout spec. I think he was really talking about it in terms of print and using this stuff to create print layouts, but as soon as I saw that, I was like, _No, we want this for the web. This is something that we really need and its feasibility to properly lay things out._ And so I started digging into it, and finding out what he was doing, and building some examples.”
“我刚接触到 CSS 网格布局是在法国，一个由 Bert Bos 领导的工作室。并且我不会说法语，但是我看到了演示并且试着去操作” Andrew 回想到。“我看到他在说明。。。一个布局模板的草案。我认为他真的在就印刷版而讨论并且使用这种工具去创建印刷式的布局，但是当我亲眼看到那个草案时，我感觉， _不，我认为这是 web 所需要的东西。这是我们真正需要并且可用的工具。_ 于是，我开始钻研于此，并且开始逐渐懂得它的意图，并且试着实现了一些简单的例子。”

“Then I saw the Microsoft implementation [of the draft Grid Layout spec], which gave me a real implementation that [I could build examples to show other people](https://24ways.org/2012/css3-grid-layout/). And I wanted to do that—not just because it was interesting, and I like interesting things to play with—it was because I wanted to get it out there and get other people to have a look at it. Because I’ve been doing this for a long time and I know that specs often show up, and then no one really talks about them, and they kinda disappear again. And I was absolutely determined that Grid Layout wasn’t gonna disappear, it was gonna be something that other people found out about and got excited about it. And hopefully we’d actually get it into browsers and be able to use it.”
“之后，当我看到微软对于网格系统的实现，我意识到这是一个真正可以用来开发并且向别人的展示的工具。我当时想要尝试这个新事物，不仅仅是因为有趣，也是因为我喜欢去在尝试的同时也让更多的人参与进来。事实上，我一直在这样做，因为我知道这种提案总是昙花一现后就没有人真正会继续讨论了，于是就再次消失了。但是，我绝对有信心网格布局这个提案不会消失，这将会是被世人看到并且让人激动的东西。令人欣慰的是，我们最终让它进入了浏览器，使得更多的人可以使用它。”

## The spec evolves
## 草案的进化
The draft spec that Cupp presented to the W3C, and that his team shipped in IE10, is not the [Grid Layout spec we have today](https://www.w3.org/TR/css-grid-1/). It was a step in the right direction, but it was far from perfect.

由 Cupp 向 W3C 提案的并且已经在 IE10 实现的草案，并不是 [我们现在的网格系统](https://www.w3.org/TR/css-grid-1/)。它是通向正确方向的一小步，但远没有达到完美。

“The one [Phil Cupp submitted] was a very track-based system,” recalled Elika Etemad, an Invited Expert to the W3C and an Editor of the CSS Grid Layout Module. “There was only a numeric addressing system, there were no line names, there [were] no templates, none of that stuff. But it had a layout algorithm that they … were confident would work because they had been doing experimental implementations of it.”

“Phil Cupp 的提案是一个十分有迹可循的系统，” Elika Etemad ，一个 W3C 的受邀教授并且也是 CSS 网格系统布局模型的编辑者回忆到。“当时手头只有少数需要处理系统，并且都没有名称，没有模板，什么都没有。但是有一个布局算法，他们坚信可以有效因为他们已经进行了实验性的实现。”

“The original grid that Bert [Bos] came up with … was really the reason I joined the CSS Working Group,” recalled Google’s Tab Atkins, another Editor of the CSS Grid Layout Module. “At the time, I was learning all the terrible layout hacks and seeing the possibility to just write my page layout in CSS and just have it all, kinda, work was astonishing. And then seeing the draft from Phil Cupp … and seeing it all laid out properly and with a good algorithm behind it, I knew that it was something that could actually exist now.”
“Bert [Bos] 最开始想出的网格模型才是我加入 CSS 工作组的原因”，谷歌的一位 CSS 网格模型的编辑者 Tab Atkins 回想到。“在当时，我一直在学习许多糟糕的布局小技巧并且也看到了使用 CSS 网格模型写页面的可能性。之后，我看到了 Phil Cupp 的关于网格模型的草稿，并且发现它完美的解决了布局的问题基于它之后的算法，我意识到这就是应该存在的事物。”

It was also a compelling option because, unlike previous proposals, which specified rigid layouts, this proposal was for a responsive grid system.
这同样也是一个令人信服的提案，因为不同于之前的过于死板的布局提案，这个提案是为了响应式的网格系统。

“You can [be] explicit about the size of a grid item,” Etemad explained. “But you can also say, _Be the size that your content takes up_. And that was what we needed to move forward.”
“你可以很清楚网格单元的大小，” Etemad 解释到，“但是你也可以说， _网格的大小就是内容所占据的_”。并且这也使我们需要去进一步发展的方向。

However, the draft spec wasn’t as approachable as many on the CSS Working Group wanted it to be. So the group looked to bring in ideas from some of its earlier explorations.
然而，这个草案并不是像许多 CSS 工作室认为的那么的拿来即用。所以网格布局的工作室期待引进一些之前的探索想法。

“What we really liked about Bert [Bos]’s proposal was that it had this very elegant interface to it that made it easy to express layouts in a way that you can intuitively see,” Etemad said. “It’s like an ASCII art format to create a template, and you could put [it] in your code, like the width of the columns and the heights of the rows. You could embed those into the same kind of like ASCII diagram, which made it a lot easier to see what you were doing.”
“我们真正喜欢 Bert [Bos] 的提案是因为网格布局的优雅的交互实现，从而使得直观上去布局变得容易。” Etemad 说道。“这就像是 ASCII 艺术格式去创建一个图片模板，你可以输入你的代码，比如图片的列宽和行高。你可以将此嵌入到相同的 ASCII 图表，这也使得别人懂得你在干什么变得容易。”

Peter Linss, then Co-Chair of the CSS Working Group, also suggested that they incorporate the concept of grid _lines_ in the spec (instead of only talking about _tracks_). He believed including this familiar graphic design concept would make the spec more accessible to designers.
当时是 CSS 工作组的共同主席的 Peter Linss 也建议将网格的 _线_ 概念包含到提案中（而不仅仅只是讨论 _track_）。他相信加入这个熟悉的图像设计概念会使得这个提案对于设计者变得更加易于理解。

“When we were thinking initially about CSS Grid, we were thinking about it in a very app-centric model,” recalled Microsoft’s Rossen Atanassov, who is also an Editor on the spec. “But grid is nothing new. I mean, grid’s been here for a very long time. And that traditional type of grid has always been based on lines. And we’d been kind of ignoring the lines. When we realized that we could marry the two implementations—the app side and the typography side of the Grid—this for me, personally, was one of those _aha_ moments that really inspired me to continue working on Grid.”
“当我们最开始设想 CSS 网格系统时，我们过于在一个应用为主导的模型中考虑，” 微软的 Rossen Atanassov 回想到，之前她也是此提案的编辑者。“但是网格的概念已经不是新概念了，我意思是，网格已经存在很长时间了。并且传统的网格类型一直是基于线段的。我们可能一直有些忽略线段了。当我们意识到可以将对于应用端的实现和对于网格排版印刷一方面的理论进行结合，对于我个人，是真正激励我继续发展网格系统的最 _兴奋_ 瞬间之一”

So the CSS Working Group began tweaking Microsoft’s proposal to incorporate these ideas. The final result allows you to think about Grid systems in terms of tracks or lines or templates or even all three at once.
所以 CSS 工作组开始稍微调整微软的建议去包含这些想法。最终的结果使得你可以认为网格系统是track，或者线段,或者模板，甚至是三者的结合。

Of course, getting there wasn’t easy.
当然，达成这一目标并不容易。

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
