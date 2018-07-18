> * 原文地址：[The Story of CSS Grid, from Its Creators](https://alistapart.com/article/the-story-of-css-grid-from-its-creators)
> * 原文作者：[Aaron Gustafson](https://alistapart.com/author/agustafson)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-story-of-css-grid-from-its-creators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-story-of-css-grid-from-its-creators.md)
> * 译者：[Tivcrmn](https://github.com/Tivcrmn)
> * 校对者：[Zheng7426](https://github.com/Zheng7426)

# 由 CSS 网格系统的创造者们所讲述的故事

![](https://alistapart.com/d/_made/d/story-of-css-grid_960_636_81.jpg)

**一个来自编辑者的小提醒：** 我们想要感谢 Microsoft Edge 团队，因为他们分享了与许多对 CSS 网格系统的发展有杰出贡献的专家的采访手稿。在编辑这份关于 CSS 网格系统历史的文章中，这些手稿十分珍贵。同时，你也可以在 [Channel 9](https://channel9.msdn.com/)上观看他们制作的关于这些采访的短视频 [Creating CSS Grid](https://channel9.msdn.com/Blogs/msedgedev/Creating-CSS-Grid)。

在 2017 年 10 月 17 日，微软的 Edge 浏览器发布了 CSS 网格系统。基于许多原因，这是 CSS 历史上的一个里程碑。首先，它意味着所有的主流浏览器现在都支持这个令人惊叹的布局工具。这个很棒的案例体现了主流浏览器在统一标准上的成功以及跨浏览器之间的合作。但是最后，或许是最有趣的一点，这次事件将一个本来超过20年为周期进行循环制定标准的过程，从此改写。

## 本来就不是一个新想法

现代的网格布局系统自从工业革命以来就已经存在，网格一直是这么多世纪以来使用的一种设计工具。就其本身而言，CSS 基于网格的布局从一开始就不应该是一件令人震惊的事。

从 Bert Bos 博士处得知，他同时也是与 Håkon Wium Lie 一起的 CSS 共同创造者，他对于网格布局已经思考过很久了。

“最初的 CSS 非常简陋”，Bos 回想到，“CSS 本身只是一种在当时的小屏幕下创建文档视图的工具，20 年前，屏幕很小。所以，当我们发现我们或许可以为文档创建样式，我们原以为，__既然有了一套创建样式的系统方式，还能对文档做什么呢？__”

对于这个问题，书籍和杂志中的布局方法给了我们巨大的启发。

“每一页的内容是独立的，但是每一页都有一个确定的布局” Bos 说。“每一页的页码是在固定位置的。并且图片总是靠左，靠右或者居中。我们也想要模仿这样。”

在初期阶段，浏览器的开发者们认为我们这个想法实现起来会太过复杂，然而网格布局的概念逐渐地流行了起来。在 1996 年，Bos, Lie 和 Dave Raggett 共同提出了一个“frame-based（基于边框的）”布局模型。之后，在 2005 年，Bos 发布了 [Advanced Layout Module（高级布局模块）](https://www.w3.org/TR/2007/WD-css3-layout-20070809/)，此文档之后变成了 [Template Layout Module（样式布局模块）](https://drafts.csswg.org/css-template/)。尽管在 web 设计的社区中有关于此的大量关注与热情，但是没有一个提案能够真正在浏览器中实现。

## 再一次动情

随着网格概念正在有条不紊的被 CSS 工作组讨论，大多数人当时都希望其中的一个提案可以最终被采纳。而最终，真正被采纳的提案是由一群在微软的开发者所提出的，他们一直在寻找一个健壮的布局工具是为了更好的开发他们 web 端的产品。

Phil Cupp 当时一直是重新设计 Microsoft Intune（一款计算机管理工具）的 UI 团队的负责人。[Silverlight](https://en.wikipedia.org/wiki/Microsoft_Silverlight) 是一个源于 [Windows Presentation Foundation](https://en.wikipedia.org/wiki/Windows_Presentation_Foundation) 的强大布局工具的浏览器插件，而 Cupp 是 Silverlight 的狂热粉丝，并且甚至当时一开始就打算以这种方式去重新构建新的 Microsoft Intune。然而之后，Microsoft 一直在 Windows 8 的计划准备阶段要使用 web 端的技术打造应用。在得知此之后，Cupp 想要 Intune 这款产品也照着做，但是他很快就意识到 web 现阶段急需一款更出色的布局工具。

于是，他加入了一个新的团队，为了能够专注于将已经存在于 Silverlight —— 一个类似于网格系统的布局方式 —— 引入 web 端。有趣的是，团队中的人已经意识到了这个需求。同时，许多开发者当时正在专注于 iPhones 和 iPads，这两种设备只需要开发者专注于两种不同的并且不变的画面大小（也有可能是 4 种，如果考虑横竖屏）。于是，Windows 不得不支持大量的不同的屏幕大小，分辨率和形状因子。对了，还有可变化大小的屏幕。简而言之，Microsoft 急切需要一个健壮并且灵活的布局工具对于 web 端的设计，尤其假使 web 端 将会成为开发 Windows 原生应用的平台。

在与不同的微软团队之间努力达成第一份草案之后，Cupp 和他的团队发布了一款网格布局工具，即在 2011 年 IE10 发布 `-ms-` 前缀之后。他们紧随其后发布了草案 [draft Grid Layout spec](https://www.w3.org/TR/2011/WD-css3-grid-layout-20110407/)，随后此草案也正式在 2012 年进入 W3C。

当然，这也不是第一次甚至也不是第三次 W3C 收到一份关于网格布局的提案。但这次不同的是，他们还对草案进行了一次可评估的实现。不仅如此，我们，作为开发者，最终也有了可以真正上手的机会。网格布局从此就不仅仅是理论上的可能性了。

少数的几个具有前瞻性的 web 设计者和开发者比如在其中最重要的 W3C 的客邀教授 Rachel Andrew，开始试着对刚出炉的提案进行改进。

“我刚接触到 CSS 网格布局是在法国，一个由 Bert Bos 领导的工作室。并且我不会说法语，但是我看到了演示并且试着去操作” Andrew 回想到。“我看到他在说明……一个布局模板的草案。我认为他真的在就印刷版而讨论并且使用这种工具去创建印刷式的布局，但是当我亲眼看到那个草案时，我感觉，__不，我认为这是 web 所需要的东西。这是我们真正需要并且可用的工具。__ 于是，我开始钻研于此，并且开始逐渐懂得它的意图，并且试着实现了一些简单的例子。”

“之后，当我看到微软对于网格系统的实现，我意识到这是一个真正可以用来开发并且向别人[展示的工具](https://24ways.org/2012/css3-grid-layout/)。我当时想要尝试这个新事物，不仅仅是因为有趣，也是因为我喜欢去在尝试的同时也让更多的人参与进来。事实上，我一直在这样做，因为我知道这种提案总是昙花一现后就没有人真正会继续讨论了，于是就再次消失了。但是，我绝对有信心网格布局这个提案不会消失，这将会是被世人看到并且让人激动的事物。令人欣慰的是，我们最终让它进入了浏览器，使得更多的人可以使用它。”

## 草案的进化

由 Cupp 向 W3C 提案的并且已经在 IE10 上实现的草案，并不是[我们现在的网格系统](https://www.w3.org/TR/css-grid-1/)。它是通向正确方向的一小步，但远没有达到完美。

“Phil Cupp 的提案是一个十分有迹可循的系统，”Elika Etemad 回想到，他是 W3C 的受邀教授，也是 CSS 网格系统布局模型的编辑者。“当时手头只有少数需要处理的系统，并且都没有名称，没有模板，什么都没有。但是有一个布局算法，他们坚信可以有效，因为他们已经进行了实验性的实现。”

“Bert [Bos] 最开始想出的网格模型才是我加入 CSS 工作组的原因，”谷歌的一位 CSS 网格模型的编辑者 Tab Atkins 回想到。“在当时，我一直在学习许多糟糕的布局小技巧并且也看到了使用 CSS 网格模型写页面的可能性。之后，我看到了 Phil Cupp 的关于网格模型的草稿，并且发现，基于它之后的算法，它完美的解决了布局的问题，我意识到这就是应该存在的事物。”

这同样也是一个令人信服的提案，因为不同于之前的过于死板的布局提案，这个提案是为了响应式的网格系统。

“你可以很清楚网格单元的大小，” Etemad 解释到，“但是你也可以说，__网格的大小就是内容所占据的__。”并且这也是我们需要去进一步发展的方向。

然而，这个草案并不是像许多 CSS 工作室认为的那么的拿来即用。所以网格布局的工作室期待引进一些之前的探索想法。

“我们真正喜欢 Bert [Bos] 的提案是因为网格布局的优雅的交互实现，从而使得直观上去布局变得容易。” Etemad 说道。“这就像是 ASCII 艺术格式去创建一个图片模板，你可以输入你的代码，比如图片的列宽和行高。你可以将此嵌入到相同的 ASCII 图表，这也使得别人懂得你在干什么变得容易。”

当时是 CSS 工作组的共同主席的 Peter Linss 也建议将网格的__线__概念包含到提案中（而不仅仅只是讨论__轨迹__）。他相信加入这个熟悉的图像设计概念会使得这个提案对于设计者变得更加易于理解。

“当我们最开始设想 CSS 网格系统时，我们过于在一个以应用为主导的模型中考虑，”微软的 Rossen Atanassov 回想到，之前她也是此提案的编辑者。“但是网格的概念已经不是新概念了，我意思是，网格已经存在很长时间了。并且传统的网格类型一直是基于线段的。我们可能一直有些忽略线段了。当我们意识到可以将对于应用端的实现和对于网格排版印刷一方面的理论进行结合，对于我个人，是真正激励我继续发展网格系统的最__兴奋__的瞬间之一。”

所以 CSS 工作组开始稍微调整微软的建议去包含这些想法。最终的结果使得你可以认为网格系统是轨迹，或者线段，或者模板，甚至是三者的结合。

当然，达成这一目标并不容易。

## 打磨，不断打磨

你可以想象到的是，在微软的提议，Bos 的先进布局，Linss 对于网格线段的添加这三种不同的想法中做折中，不是简单的剪切和复制，这里有许多比较微妙的小方面和边界条件需要去确认。

“我认为一些比较微妙的东西在一开始就已经占据了这三个不同提议的方方面面，我们一直想要去结合这三个提议并且产生出一个新的系统，一个足够优雅接受所有提议的连贯的系统。”Etemad 说到。

一些想法从第一阶段就是不合适于 CSS 网格系统。Bos 的概念，举个例子，允许任意的对于网格布局的继承好像就是该网格的一个孩子一样。这就是经常被引用作为“子网格”的特点，但是并没有进入 CSS 网格布局 1.0。

“子网格一直是最先在众多被指出的提案中被提及的”，Atanassov 说到，“并且一直以来是一个被眷顾的提案但也遇到了一点困难在整个过程中。因为它使得提案的工作很大程度上的犹豫不决。同时也让许多对其的开发人员望而却步。但这也是最令我兴奋的一个事情。并且我知道我们将会成功解决它并且它将会变得伟大。只不过要多花些时间。”

同样，处理映射到网格线的内容有两种选择。一方面，您可以让网格本身具有固定维度轨道，并根据溢出的内容调整溢出内容映射到哪个网格线结束。或者，您可以让轨道增长以包含内容，以便它在预定义的网格线处结束。不能两个兼而有之，因为它可以创建一个循环依赖，所以该小组决定搁置这个问题。

最终，鉴于 CSS 工作组对于提案的三个主要目标，我们做出了一些修改。如下：

1.  **功能强劲：** 他们想要 CSS 网格系统让设计者在表达他们的想法时，感到“以简单的方式制作简单的东西，并且使得设计复杂的事物变得可能”如同 Etemad 的想法一样；
2.  **健壮性：** 他们想要确保不会有任何的缺口使得布局塌陷，滚动禁止，或者内容突然的消失变得可能；
3.  还有**性能卓越：** 如果背后的算法不能足够快的去优雅的处理真实世界的情况，比如浏览器重设事件或是动态内容加载，他们知道，如果这样的事情发生，将会使得用户变得极其沮丧。

“这就是为什么设计一个新的 CSS 布局系统需要很多时间”，Etemad 说到。“这花费了许多时间，付出了许多努力，还有很多为其贡献人的爱心。”

## 真正上场

在一个候选提议（又称最后一版的草稿）能成为一个正式的提议（通俗地讲就是标准），W3C 需要去查看[至少两个独立的，可共同使用的实现](https://medium.com/net-magazine/establishing-web-standards-12f7f4308982)。微软当时已经实现了他们的提议，但是内容已经修改了不少在那之上，他们也希望其他浏览器在他们投入更多的开发人员和精力去更新提议之前，能够接过这个火炬。__为什么？__其实，他们当时有一点担心，因为另一个看起来很有前途的布局提议：[CSS 区域](https://www.w3.org/TR/css-regions-1/)。

CSS 区域提供了一种方式，能够在页面中的一系列预定义的“区域”内流动，从而实现复杂的布局。微软在早前发布了一款 CSS 区域的实现，同时在 IE10 之后加入了一个前缀。一个小改动的支持 CSS 区域的版本也在 WebKit 中加入了。Safari 也跟随着，和 Chrome 一样（在那时仍然运行着 WebKit 内核）。但是之后谷歌在 Chrome 中放弃了，火狐也反对这个提案并且表示永远不会进行开发。于是，这个想法现在被打入冷宫。甚至 [Safari 在下一次版本更新时也会放弃对 CSS 区域的支持](http://caniuse.com/#search=css-regions)。简单得说，微软想要确保，在投入更多的开发人员之前，网格不会遭受之前 CSS 区域的命运。

“我们当时有开发人员立刻就说到，哇哦，这太棒了，我们一定要做。”Atanassov 回忆到。“但是这是一方面...说到，这确实很棒，我们应该做这个。于是下一步就是增加资源然后给开发人员付工资让他们去真正地实现这个想法。”

“也有一些其他开发人员的想法 —— 其中一个是来自谷歌的提案编辑 —— 但是也有一些迟疑去贡献代码，”微软的 Greg Whitworth 回忆到，一个来自 CSS 工作组的成员。“贡献代码才是真正重要的。”

一个有趣的形式变化是，媒体公司 Bloomberg 雇佣了 Igalia，一个开源项目的顾问，去同时帮助 Blink 和 WebKit 进行 CSS 网格系统的开发。

“回到2013年，[Bloomberg] 与我们进行接触...因为他们当时有十分针对性的需求关于定义和使用类网格的结构，”同时是开发者和合作伙伴的 Sergio Villar Senin 回忆到。“他们主要是让我们帮助他们实现 CSS 网格布局系统的一些针对性的需求，并且也是为了 [Blink and WebKit] 去实现。”

“[Igalia 的工作] 的帮助是极大的，因为之后开发者可以发现这个提案是真的有可能帮助他们开发网站的工具，”Whitworth 补充到。

但是尽管有着两个已经对于提案的实现，一些人还是仍然关心这个提案能否真正被使用。毕竟，仅仅是因为一个渲染引擎是开源的并不意味着它的负责人会接受每一次新的版本更新。并且即使他们同意，如同 CSS 区域经历过的一样，也不能保证这些功能继续存在。幸运的是，许多设计者和开发者都对网格系统感兴趣并且开始向浏览器提供商去施压以便于实现这个新的布局系统。

“CSS 网格布局在那时有一个关键性的转变” Whitworth 说到。“随着 Rachel Andrew 的加入，在有关于 CSS 网格的网站 [Grid by Example](http://gridbyexample.com/) 上，他创建了许多样例并且激起了人们的兴趣，从而开始真正去推广它并且向所有的 web 开发者展示网格系统到底能做什么以及它是如何解决问题的。”

“之后，再过不久，Jen Simmons [一个在 Mozilla 的设计布道师]创建了一个叫做 [Labs](http://labs.jensimmons.com/) 的网站，她放了许多她使用 CSS 网格系统做的样例并且将对于 CSS 网格系统的热爱和动力在社区中得以保持。”

![](/d/the-story-of-css-grid/edge-labs.jpg)

网格系统同时促进了传统和非传统的布局方式。这里有[一个网格布局的案例](http://labs.jensimmons.com/2017/01-009L.html)来自于 [Jen Simmons 的实验室](http://labs.jensimmons.com/)，可以再 Edge 16 上浏览。如果你更喜欢在非 Windows 上用 Edge 浏览，你也可以在 [BrowserStack](https://aka.ms/grid-edge-browserstack) 上浏览 (需要账户)。

随着设计思想的领导者比如 Andrews 和 Simmons 不断地陈述 CSS 网格系统功能的强大和多样，web 设计者社区变得越来越活跃。他们开始在类似于 [CodePen](https://codepen.io/search/pens?q=CSS+Grid&limit=all&type=type-pens) 的网站上，分享他们的想法并且开发他们自己的网格技巧。我们并不会经常花功夫在这一方面，但是开发者们的热情能够支持甚至去使得一个提案变成标准。

“我们可以去写一个提案，我们可以去实现它，但是如果没有开发者的实际需求或者具体对于功能的使用，无论我们付出多少的努力都没有意义。” Whitworth 说到。

不幸的是，如同像 CSS 网格系统这样的提案，对于其具体的实现的开销经常会使得浏览器的提供商难以做出承诺。于是，没有浏览器对于提案的具体实现，就没有开发者去踩坑和实验，也就很难激发大家的热情。没有了开发者的热情，浏览器开发商就不情愿投入资金去验证是否这个想法能够获得利润。我相信你能发现这个问题。实际上，这也是至少至今，为什么 CSS 区域提案逐渐暗淡的原因之一（[移动芯片组的性能是另一个被引用的原因](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/kTktlHPJn4Q/JtyfOkPjKN4J)）。

幸运的是，Bloomberg 愿意去扮演捐助者的角色并且为这个 CSS 网格系统进行募捐。所以，靠着它的帮助，谷歌发布了 CSS 网格系统的实现在 Chromium 56 安卓版，时间为 2017 年 1 月。随后在 3 月初，谷歌也在 Chrome 上推出了网格系统，也就是 Mozilla 在 Firefox 上推出的两天后。在当月结束之前，Opera 和 Safari 也支持了。

讽刺的是，最后一个支持的浏览器公司是微软。但是在这周的早些时候他们也在 Edge 上发布了。

“随着在 web 平台上 CSS 网格系统的真正出现，你一直在等一个机遇” Whitworth 说到，就在刚刚 Edge 支持网格系统之前。“你想要一个完美的提案，你也想要提案的开发者有趣，同时你也想要 web 开发者提出的许多需求。2016 年末到 2017 年初就是这样一个甜蜜点。所有的事情都发生了。我们进一步升级了我们的实现并且激动的要再次发布。”

“我从没有想起某一个功能的发布如同 CSS 网格系统一样。每一个主流浏览器都将会在一年内发布他们自己的实现，并且将会是可共同合作的形式，因为我们一直在标识后实现，测试，进一步开发新的功能，并且当这个新版本被认为是稳定的，所有的浏览器都会原生的支持。”

“随着每一个新版本的发布都几乎同时”，Atkins 说到，“[网格系统]从一个想法，一个可以仅仅使用单一布局就进行开发并且不需要担心快速出现缺陷的想法...这已经是我想到的能够达成这一阶段的最快速度。”

## 网格系统对于 CSS 的意义

随着网格系统的支持不再成为问题，我们可以（也应该）开始使用这个令人惊奇的工具。对于我们这种已经使用传统 CSS 快二十年的人，其中一个挑战就是，CSS 网格系统需要我们有一种新的对于布局的思考模式。

“这已经不仅仅是附上你的外边距值和属性对于每一个独立的元素并且摆放他们，” Bos 说到。“你现在可以有一个不同的模型，可以先设计布局，然后将不同的元素拽入布局中。”

“它是我们为 CSS 发明的最强大的布局工具，” Atkins 说。“它使页面布局如此简单易行...人们一直在寻求更好的布局。仅仅是出于作者能力的原因，并且因为我们使用的小技巧并没有像旧的方法那样强大，只是把它放在一个很大的旧表元素中 — 这是一个很受欢迎的原因；它让你做强大的复杂布局。这是维护最糟糕的事情，也是语义最糟糕的事情。而网格可以让你恢复这种力量，这真是太棒了。”

“CSS 网格省略了我们必须做的所有复杂的事情为了实现基本布局并使其看起来完全不必要，” Etemad 说道。“你可以直接与 CSS 引擎交谈，而不需要中间翻译。”

CSS 网格提供了很多功能，我们很多人才刚刚开始掌握。看看我们从哪里开始会很有趣。

“我认为这将是变革性的，” Etemad 说。“它将把 CSS 变得返璞归真，即样式和布局语言，将所有逻辑从标记中解放出来，并允许我们从一开始就一直试图从内容和样式中清晰地分离内容和样式。”

“我对 CSS 布局的未来感到兴奋，” Whitworth 说。“CSS 网格不是终点；它实际上只是一个开始。在 IE 10中...[我们发布了] CSS 区域以及 [CSS Exclusions](https://www.w3.org/TR/css3-exclusions/)。我认为随着网页设计师开始越来越多地使用 CSS 网格，他们会意识到__为什么__我们将所有这三个一起发布。也许我们可以继续我们用 CSS 网格系统做的事情，并继续改进这些规范。让供应商也希望实现这些。让社区对他们感到兴奋，并进一步推动网络布局。”

Andrew 说：“我认为现在我们已经拥有了网格系统，Exclusions 也是绝对有意义的。”“它为我们提供了一种在[网格]中放置内容并在其周围包装文本的方法，而我们没有任何其他方法可以做到这一点...然后这样的东西就如同区域...我希望看到这种进步，因为...一旦我们能够构建一个漂亮的网格结构，我们就可能希望通过它来传播内容。我们没有办法做到这一点。”

“就我而言，这并不止于此；这只是开始。”

## 开始认识网格系统
*   CSS 网格模型教程阶段 1  
    [https://www.w3.org/TR/css-grid-1/](https://www.w3.org/TR/css-grid-1/)
*   CSS 网格布局 – Mozilla Developer Network  
    [https://developer.mozilla.org/en-US/docs/Web/CSS/CSS\_Grid\_Layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)
*   网格布局案例 – Rachel Andrew  
    [https://gridbyexample.com/examples/](https://gridbyexample.com/examples/)
*   走进网格布局 - Rachel Andrew  
    [https://gridbyexample.com/patterns/](https://gridbyexample.com/patterns/)
*   布局案例 - Jen Simmons  
    [http://labs.jensimmons.com/2016/](http://labs.jensimmons.com/2016/)
*   学习 CSS 网格布局 - Jen Simmons  
    [http://jensimmons.com/post/feb-27-2017/learn-css-grid](http://jensimmons.com/post/feb-27-2017/learn-css-grid)
*   在火狐浏览器中的 CSS 网格布局和其开发工具  
    [https://www.mozilla.org/en-US/developer/css-grid/](https://www.mozilla.org/en-US/developer/css-grid/)
*   实用的 CSS 网格布局: 在现存的设计中加入网格 - Eric Meyer  
    [https://alistapart.com/article/practical-grid](https://alistapart.com/article/practical-grid)
*   渐进式加强 CSS 布局: 从 Floats 到 Flexbox 再到 Grid by Manuel Matuzović  
    [https://www.smashingmagazine.com/2017/07/enhancing-css-layout-floats-flexbox-grid/](https://www.smashingmagazine.com/2017/07/enhancing-css-layout-floats-flexbox-grid/)
*   盒模型校准小抄 - Rachel Andrew  
    [https://rachelandrew.co.uk/css/cheatsheets/box-alignment](https://rachelandrew.co.uk/css/cheatsheets/box-alignment)
*   CSS 网格布局 - Rachel Andrew 在 An Event Apart video  
    [https://aneventapart.com/news/post/css-grid-layout-by-rachel-andrewan-event-apart-video](https://aneventapart.com/news/post/css-grid-layout-by-rachel-andrewan-event-apart-video)
*   革新你的页面: web 上的真正艺术方向 - Jen Simmons 在 An Event Apart video  
    [https://aneventapart.com/news/post/real-art-direction-on-the-web-by-jen-simmons-an-event-apart](https://aneventapart.com/news/post/real-art-direction-on-the-web-by-jen-simmons-an-event-apart)
*   “学习网格布局” 系列视频 - Rachel Andrew  
    [https://gridbyexample.com/video/](https://gridbyexample.com/video/)
*   为什么喜欢 CSS 网格布局 – 一个短视频由 Jen Simmons 带来 
    [https://www.youtube.com/watch?v=tY-MHUsG6ls](https://www.youtube.com/watch?v=tY-MHUsG6ls)
*   现代布局: 打破常规 - Jen Simmons 在 An Event Apart video  
    [https://vimeo.com/147950924](https://vimeo.com/147950924)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
