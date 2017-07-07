
> * 原文地址：[You do not need a CSS Grid based Grid System](https://rachelandrew.co.uk/archives/2017/07/01/you-do-not-need-a-css-grid-based-grid-system)
> * 原文作者：[Rachel Andrew](https://rachelandrew.co.uk/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/you-do-not-need-a-css-grid-based-grid-system.md](https://github.com/xitu/gold-miner/blob/master/TODO/you-do-not-need-a-css-grid-based-grid-system.md)
> * 译者：[LeviDing](https://github.com/leviding)
> * 校对者：

# 你不需要基于 CSS Grid 的栅格布局系统

在过去的几个星期里，我开始看到基于 CSS Grid 的布局框架和栅格系统的出现。实际上令我感到惊讶的是，它已经被使用了那么长时间，但我还没有看到它的进步，而只是使用了 CSS Grid 栅格布局。更糟糕的是，我迄今为止看到的那些都在退步。他们沉醉于自己的过去而不是着眼于未来，这使得发展受到限制。即使一个常见的主题，它们也需要使用 `row wrappers` 进行标记。

## 为什么 Grid 有些不同？

Grid 是一个栅格系统。它允许你在 CSS 中定义列和行，而不需要在标记中定义它们。你不需要其他工具，Grid 就可以帮助你实现栅格效果，实际上它就是栅格！

我们遗留下来的设置布局的方法需要 `row wrappers`，这是因为我们是通过分配宽度的方式来伪造网格的。然后我们通过推拉的方式调节网格间的间隙。在一个基于 Grid 的浮动网格中，你需要将每行的元素包装起来并清除浮动，以使下一行中的内容不浮动。在一个基于 Flex 的网格中，需要你对每行定义新的 flex 容器，或者你需要恰当灵活地使用 `wrapping`，`flex-basis` 和 `margin` 来获得相同的效果。

Grid 不需要这些 `row wrappers`，因为您已经定义了 `row tracks`，和用于对齐的线条。且不会有网格内的内容溢出到其他行的危险。 如果你定义了 `row wrappers`，那么每一行都将成为一个新的一维网格布局。所以如果你将自己限制在一个维度上，那么在使用 Grid 没有比使用 Flexbox 有什么好处。

## 基于 Grid 的布局框架有什么值得借鉴的地方？

框架这个词在这不是太恰当，但是我认为在一个团队中，一套 Sass helper 在规范化使用 Grid 方面是很有帮助的。如果你已经探究了相关的规范，你会发现有对于实现相同的效果来说，会有很多种不同的方法。你可以命名区域，使用行号或行名。或许你希望将所有内容明确放置或自动放置在 `auto-placement` 上。如果团队中的每个人都使用不同的方法，最终将似的编写出来的代码难以阅读和维护。

对于代码向后兼容也是如此。如果你已经决定如何处理不支持 Grid 布局的浏览器，某些工具可以帮助你确保你所做的决定能够在不同的地方以相同的效果展现出来。此外，这种方法在项目开发层面上比直接导入其他公司的方法和需求更有用。

在你的新“Grid Layout 框架”上打破前，请确保你首先了解 Grid Layout 的实际工作原理。知道你为什么要创建一个抽象，它提供什么以及使用它的损失是什么。

## 拥抱新的可能

我刚刚从 Patterns Day 回来，并且 [我的一张幻灯片在 Twitter 上被提及了好几次](https://twitter.com/tomloake/status/880749728782311424)：

> “Flexbox & Grid 有很大区别。如果你先使用了旧的方法来进行开发，那你则体验不到使用 Flexbox 和 Grid 进行创新的可能”。

这里的背景是为了处理老版本的浏览器。我鼓励人们首先考虑新的浏览器。在最开始的时候就使用良好的标记方式，然后查看该浏览器支持的属性，诸如 Grid 和 Flexbox 等，并据此进行相关设计。如果你从旧版本的浏览器开始，会使得他们的性能成为你能力的限制因素。

创建规范的标记，整理那些过时了的没有必要的元素。使用 Grid 和其他新方法来设计你的网站。然后看看你如何通过为不支持这些新功能的浏览器提供一些稍微简单的东西来解决浏览器兼容问题。也许你的 Grid 布局设计使用了跨行等设计方案，这种效果很难在没有额外标记方法的旧版本浏览器中实现精准的布局。你可以使用 flexbox 做向后兼容，创建一个没有跨行的布局方案。虽然这样不那么整洁，但也完全可以使用，而且不需要为数量在逐渐减少的那部分用户来增加额外标记。

你可以 [点击这来看相关示例](https://gridbyexample.com/patterns/header-asmany-span-footer/)。其中一些模式和特点我已经发布在了网站 [Grid by Example](https://gridbyexample.com/) 上。

如果你将自己限制在过时的范围内，只需使用可在旧版浏览器中重新创建的 Grid 部分，或使用那些自身受限的框架，那你就会失去使用 Grid 时产生创意的可能。那这样的话你又烦什么呢？你也可以只使用遗留的代码，但这确实是一种耻辱。

如果你在寻找栅格框架时找到本文，请停在这里。[学习并使用 CSS Grid 布局](https://gridbyexample.com)，可能你你没有必要再找除此之外的材料了。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
