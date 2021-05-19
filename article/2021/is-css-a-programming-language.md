> * 原文地址：[Is CSS a Programming Language?](https://css-tricks.com/is-css-a-programming-language/)
> * 原文作者：[Chris Coyier](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/is-css-a-programming-language.md](https://github.com/xitu/gold-miner/blob/master/article/2021/is-css-a-programming-language.md)
> * 译者：
> * 校对者：

# Is CSS a Programming Language?

I have a real distaste for this question. It might seem like a fun question to dig into on the surface, but the way it enters public discourse rarely seems to be in good faith. There are ulterior motives at play involving respect, protective emotions, and desires to *break* or *maintain* the status quo.

If someone can somehow prove that CSS isn’t a programming language (this is such a gray area that if that was your goal, it wouldn’t be terribly hard to do) then they get to keep on feeling superior in their “real” programming skills and rationalize the fact that they are (likely) paid more than a front-of-the-front-ender specializing in CSS. This is maintaining the status quo.

The reverse can also be true. If you can prove that CSS *is* a programming language, perhaps you can shift your own company or the industry at large toward equal respect and pay toward front-of-the-front-end developers. This is breaking the status quo.

Let’s say we could all agree on a boolean `true` or `false` on if CSS is a programming language. What now? If `true`, is pay normalized among all web workers? If `false`, do CSS specialists deserve pay cuts? If `true`, does everyone start respecting each other in a way they don’t now? If `false`, do CSS people have to eat lunch in the boiler room? I have doubts that anything will change; hence my distaste for the discussion at all.

Whatever the facts, it’s unlikely most people are going to accept even the possibility that CSS is a programming language. I mean, programs *execute*, don’t they? Nobody doubts that JavaScript is a programming language, because it executes. You write code and then execute that code. Perhaps you open a terminal window and write:

```none
> node my-program.js
```

Sure as eggs is eggs, that program will execute. You can make “Hello, World!” print to the terminal with `console.log("Hello, World!");`.

CSS can’t do that! Um, well, unless you write `body::after { content: "Hello, World!"; }` in `style.css` file and open a web page that loads that CSS file. So CSS does execute, in its own special way. It’s a domain-specific language (DSL) rather than a general-purpose language (GPL). In that browser context, the way CSS is told to run (`<link>`, usually) isn’t even that different from how JavaScript is told to run (`<script>`, usually).

If you’re looking for comparisons for CSS syntax to programming concepts, I think you’ll find them. What is a selector if not a type of `if` statement that runs a loop over matches? What is `[calc()](https://css-tricks.com/a-complete-guide-to-calc-in-css/)` if not a direct implementation of math? What is a group of [media queries](https://css-tricks.com/a-complete-guide-to-css-media-queries/) if not a `switch`? What is a [custom property](https://css-tricks.com/a-complete-guide-to-custom-properties/) if not a place to store state? What is `[:checked](https://css-tricks.com/almanac/selectors/c/checked/)` if not boolean? Eric recently made the point that [CSS is typed](https://css-tricks.com/css-is-a-strongly-typed-language/), and earlier, that CSS is chock full of [functions](https://css-tricks.com/complete-guide-to-css-functions/).

For better or worse, having an answer to whether or not CSS is a programming language affects people. One college professor had made a point of telling students that CSS is not Turing complete, [but is now re-considering that position](https://lemire.me/blog/2011/03/08/breaking-news-htmlcss-is-turing-complete/) upon learning that it is. Whatever the intention there, I think the industry is affected by what computer science professors tell computer science students year after year.

Lara Schenck [has dug into the Turing-complete angle](https://notlaura.com/is-css-turing-complete/). If you’re trying to settle this, Turing completeness is a good proxy. It turns out that CSS basically *is* Turing complete (by settling the cellular automaton angle of Rule 110), just not entirely by itself. It involves a somewhat complex use of selectors and `:checked` (surprise, surprise). Lara makes an astute point:

> Alone, CSS is *not* Turing complete. CSS plus HTML plus user input is Turing complete!

Still, say you don’t buy it. You *get* it and even concede, OK fine, CSS is essentially Turing complete, but it just doesn’t *feel* like CSS (or HTML for that matter) is a programming language to you. It’s too declarative. Too application-specific. Whatever it is, I honestly don’t blame you. What I hope is that whatever conclusion you come to, the answer doesn’t affect things that really matter<sup>[1]</sup>, like pay and respect.

Respect is in order, no matter what any of us come to for an answer. I don’t consider CSS a programming language, but it doesn’t mean I think it’s trivial or that my specialist co-workers are any less valuable than my Python specialist co-workers. Wouldn’t that be nice? I think there is an interesting distinction between declarative markup languages and other types of languages, but they are all code. Oh stop it, you know how thoughtful answers make me blush.

I’d like to see a lot more nuanced, respectful, and agenda-less comments like that when these discussions happen.

- - -

1. Just like “website” vs “web app.” Whether or not you think there is a distinction, I would hope people aren’t making decisions that affect users based on what taxonomical bucket you think your thing goes in.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
