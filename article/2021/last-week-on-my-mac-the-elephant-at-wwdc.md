> * 原文地址：[Last Week on My Mac: The elephant at WWDC](https://eclecticlight.co/2021/06/13/last-week-on-my-mac-the-elephant-at-wwdc/)
> * 原文作者：[hoakley](https://eclecticlight.co/author/hoakley/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/last-week-on-my-mac-the-elephant-at-wwdc.md](https://github.com/xitu/gold-miner/blob/master/article/2021/last-week-on-my-mac-the-elephant-at-wwdc.md)
> * 译者：
> * 校对者：

# Last Week on My Mac: The elephant at WWDC

Just as WWDC was about to start, Michael Tsai posted [a brief note](https://mjtsai.com/blog/2021/06/07/old-apple-conceptual-documentation/) in which he details how to download and access Apple’s old conceptual documentation for macOS, much of which has never been replaced or updated over the last five years or more. By a strange coincidence, this was followed by no less than five videos at WWDC about a new developer documentation system named DocC, which for many commentators seems to have passed unnoticed. Yet both are unmistakable signs of the elephant at WWDC: documentation.

Once upon a time, Apple and its Macintosh computers had exemplary documentation in the form of the *Inside Macintosh* series of printed books, published in collaboration with Addison-Wesley. Those superb volumes were written by technical authors in close collaboration with Apple’s engineers, and still grace many bookshelves.

By the time that Mac OS X came along, printed books no longer seemed the best platform for Apple’s rapidly evolving operating system, and a large series of conceptual guides and manuals were crafted and made freely available. Those are still available if you follow Michael Tsai’s instructions, but most haven’t been updated for so long that, even when read in conjunction with more recent sources, their usefulness is now limited.

Third-party attempts to document Mac OS X have been brave, but none has stood the pace of change. Amit Singh’s *Mac OS X Internals* from 2006 was replaced around 2017 by Jonathan Levin’s outstanding trilogy *\*OS Internals,* which was marred only by its lack of an index. But no sooner had Levin completed his series than he abandoned it in favour of documenting Android.

DocC looks exciting, and demonstrates that Apple recognises its problem, at least in part. But it falls into several well-known traps.

First, it concentrates on documenting calls within an API by individual function. For a developer who already understands how that sub-system in macOS works, that’s essential. But trying to grok major topics like Attributed Text simply isn’t possible by referring to individual functions within the API. You first need to get your head around how sub-systems are designed and function, the conceptual information which Apple was once so good at providing. Good conceptual documentation is structured and written quite differently from that for classes and functions with an API, as Apple well knows.

DocC is the most recent in a long line of schemes to ‘automatically’ create code and documentation together. The first I can remember coming across was Don Knuth’s *Literate Programming,* from 1984, which is discussed in [an excellent article](https://en.wikipedia.org/wiki/Literate_programming) on Wikipedia, which also lists the existing ability to document Swift code using marked-up text, the subject of [a fine book](https://books.apple.com/gb/book/swift-documentation-markup/id1049010423) by Erica Sadun. No system is ‘automatic’ of course: there’s no getting away from the fact that someone has to write the code, and someone the documentation, no matter how they might be entwined.

In common with almost every other initiative of its kind, this approach assumes that the best people to document macOS are its engineers. Those engineers are often selected at interview by posing them a coding challenge, but have you ever heard of candidates for a software engineering post being selected by or for their ability to document their code?

Although many of Apple’s engineers are – when they’re given the time and opportunity – excellent at documenting, many are not. That’s not why they code, nor are the skills of writing good documentation even vaguely similar to those for writing good code. And when it comes to explaining in understandable terms the concepts underlying a sub-system within macOS, I suspect the number of engineers who shine at the task is quite small.

In recent years, in the absence of anything better, most developers have come to rely on presentations, their transcripts and supporting materials for WWDC. In some areas, that is essentially the only documentation we have apart from individual accounts of functions in the API. Their coverage is patchy, and important topics may not be covered for several years. For example, there have only been three half-hour sessions covering APFS since its introduction at WWDC in 2016.

APFS is another example of the failure of enforced documentation. Compare the fluent accounts of security systems in Apple’s [Platform Security Guide](https://support.apple.com/guide/security/welcome/web), one of very few conceptual guides which are maintained to Apple’s previous high standards, and those of the enormously complex APFS in [its reference](https://developer.apple.com/support/downloads/Apple-File-System-Reference.pdf), which hasn’t been updated or extended for a year.

DocC and those previous documentation schemes are overwhelmingly aimed at developers, though, and leave the advanced user to get the gist of the sub-systems which they cover. They omit vast tracts of macOS which aren’t intended to be accessed by third-parties, which Apple usually tries to burrow away in private frameworks and closed-source apps. Take Time Machine, for which the only documentation is that aimed at relative novices. It took the likes of the late James Pond (1943-2013) to explore and compile advanced details of Time Machine.

This is being harsh on DocC, which is thoroughly commendable, and every developer should watch the five videos devoted to it. But this documentation famine only worsens in Apple, and I really can’t see DocC proving a solution. I’ve had many users report that, when they’ve taken macOS problems to Apple Support, they’ve dealt with Apple staff who have even less documentation than do users.

Apple’s own engineers seem in need too. I gather that the world’s biggest customer for third-party books about technical aspects of macOS, including the three volumes of Jonathan Levin’s series, is Apple.

DocC is in reality a plaintive cry for help. Teams are still trying to fill the yawning chasm: ironically, one of the best new man pages I’ve read in a long time is that for `bputil`, a command tool which Apple repeatedly warns shouldn’t be used except experimentally. But those are exceptions, and for every instance like that there are tens of man pages which haven’t been updated for years and now don’t match their usage information.

Two failings still trouble Apple and its amazing products: bugs and documentation. Without squaring up to both and changing course, they can only get worse.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
