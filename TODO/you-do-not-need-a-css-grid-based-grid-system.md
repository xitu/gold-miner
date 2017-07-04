
> * 原文地址：[You do not need a CSS Grid based Grid System](https://rachelandrew.co.uk/archives/2017/07/01/you-do-not-need-a-css-grid-based-grid-system)
> * 原文作者：[Rachel Andrew](https://rachelandrew.co.uk/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/you-do-not-need-a-css-grid-based-grid-system.md](https://github.com/xitu/gold-miner/blob/master/TODO/you-do-not-need-a-css-grid-based-grid-system.md)
> * 译者：
> * 校对者：

# You do not need a CSS Grid based Grid System

In the last couple of weeks I have started to see CSS Grid layout based frameworks and grid systems appearing. I’m actually surprised as to how long it has taken, but I am yet to see one that adds any value at all over just using CSS Grid Layout. Worse, the ones I have seen so far go backwards. They limit themselves by replicating the past rather than looking to the future. A common theme being that they require row wrappers in markup.

## Why is grid different?

Grid is a grid system. It allows you to define columns and rows in your CSS, without needing to define them in markup. You don’t need a tool that helps you make it *look* like you have a grid, you actually have a grid!

The reason that our legacy methods need row wrappers is because we are faking a grid by assigning widths to items. We then pull and push the items around to make gaps between them. In a float based grid, you need to wrap the elements that make up each row, and clear the row in order that things in the next row don’t float up. In a flex based grid you need your row to define a new flex container, or you need to get very clever with wrapping, flex-basis and margins to get the same effect without.

Grid doesn’t need these row wrappers because you have defined row tracks, and lines to position items against. There is no danger of grid items hopping up into the row above. If you define row wrappers then each row becomes a new one-dimensional grid layout, and there is little benefit to using Grid over Flexbox if you limit yourself to a single dimension.

## What might be useful in a Grid-based ‘framework’?

The word framework is somewhat laden at this point, however I think that in a team, a set of Sass helpers may well be useful to enforce a certain way of using Grid. If you have dug into the spec, you will realise there are different methods of creating the same end result. You can name areas, use line numbers or line names. You might prefer to place everything explicitly or rely a lot on auto-placement. If everyone on the team uses a different method, the end result will be harder to read and maintain.

The same could be true for fallback code. If you have decided how to deal with non-grid supporting browsers, some tooling could help you to ensure that the decisions you have made are implemented in the same way everywhere. However this approach would be far more useful when developed on a project level, rather than importing another company’s requirements and methodologies wholesale.

Before breaking ground on your new “Grid Layout framework” make sure you have first understood how Grid Layout actually works. Know why you are creating an abstraction, what it offers and also what it takes away.

## Embrace the new possibilities

I have just come back from Patterns Day, and [one of my slides was mentioned a few times on Twitter](https://twitter.com/tomloake/status/880749728782311424). That slide read:

> “Flexbox & Grid are so different. If you build using old methods first you won’t take advantage of their creative possibilities.”

The context here was in terms of dealing with old browsers. I was encouraging people to think about new browsers first. To start with good markup, to then look at creating the design for the browsers that do support methods such as Grid and Flexbox. As if you start with old browsers, you limit yourself to their capabilities.

Create solid markup, uncluttered by additional elements that the past tells you that you need. Design your site using what Grid and other new methods have to offer. *Then* look at how you deal with the browsers without support, by serving them something slightly simpler. Perhaps your Grid design relies on being able to span rows, something that is hard to achieve without extra markup and precise layout in older browsers. Your fallback could use flexbox, and create a layout without the row spans. Not as neat, but completely usable and without needing to jam in extra markup for a diminishing number of visitors.

You can [see an example here](https://gridbyexample.com/patterns/header-asmany-span-footer/), one of a number of patterns with fallbacks that I’ve been posting over at Grid by Example.

If you limit yourself to what has gone before, by only using the parts of Grid that you can recreate in older browsers, or by using some framework that is limiting itself, you miss out on the creative possibilities of using Grid. In that case why bother? You may as well use the legacy code only, and that would indeed be a shame.

If you have found this post while looking for a grid framework, stop right here. [Learn and use CSS Grid Layout](https://gridbyexample.com). You probably don’t need anything else.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
