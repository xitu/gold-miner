> * 原文地址：[Python Architecture Stuff: do we need more?](http://www.obeythetestinggoat.com/python-architecture-stuff-do-we-need-more.html)
> * 原文作者：[Harry](http://www.obeythetestinggoat.com/author/harry.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/python-architecture-stuff-do-we-need-more.md](https://github.com/xitu/gold-miner/blob/master/TODO1/python-architecture-stuff-do-we-need-more.md)
> * 译者：
> * 校对者：

# Python Architecture Stuff: do we need more?

I've been learning lots of new stuff about application architecture recently, and I want to get a sense from you, dear reader, of whether these ideas are of interest, and whether we should try and build some more resources (blogs, talks, etc) around it.

## How should we structure an application to get the most out of our tests?

For me it all started with this question. At the [end of my book](https://www.obeythetestinggoat.com/book/chapter_hot_lava.html) I concluded on a chapter discussing how to get the most out of your tests, on the tradeoffs between unit, integration and end-to-end tests, and made some vague, flailing gestures towards topics I didn't really understand: _ports and adapters_, _hexagonal architecture_, _functional core imperative shell_, the _clean architecture_, and so on.

Since then I've managed to fall in with a [tech team](https://io.made.com/) that are actively implementing these sorts of patterns, in Python. And the thing is, these architectural patterns are nothing new, people have been exploring them for years in the world of Java and C#. They were just new to me... and I may be over-reaching from my own experience here (I'm interested in your reaction), but they are perhaps new to the Python community in general?

It does feel like, as we mature, more and more of what were once small projects and plucky startups turn into complex business and (whisper it) enterprise software, so this stuff is likely to get more and more salient.

I came to it initially from the angle of testing, and the right kind of architecture really can help you to get the most out of your tests, by separating out a core of business logic (the "domain model") and freeing it from all infrastructure dependencies, allowing it to be tested entirely through fast, flexible unit tests. At made it finally felt like the [test pyramid](https://martinfowler.com/articles/practical-test-pyramid.html) was an achievable goal rather than an impossible aspiration.

## Classic books on the topic (All Java.)

The classic books ([Evans on DDD](https://domainlanguage.com/ddd/) and [Fowler on Architecture Patterns](https://www.martinfowler.com/books/eaa.html), are classic, and anyone with an interest in this stuff should read them, but if you're anything like me, then wading through all that `public static void main AbstractFactoryManager` gubbins is a bit wearing. Maybe some more lightweight, Pythonic intros would make it all feel a bit more plausible, a bit less enterprise-architecture-astronaut-ey?

## Some existing resources in the Python world:

Made's chief architect, the Venerable Bob, has written a 4-part blog series on the way we do things here, which I really enjoyed when I first started. They're a quick, practical intro to the basic concepts of DDD, ports and adapters / dependency inversion, and to some extent, event-driven architecture. And all in Python. (trigger warning: type hints).

1.  [Ports and Adapters with Command Handler pattern in Python](https://io.made.com/introducing-command-handler/)
2.  [Repository and Unit of Work Pattern in Python](https://io.made.com/repository-and-unit-of-work-pattern-in-python/)
3.  [Commands and Queries, Handlers and Views](https://io.made.com/commands-and-queries-handlers-and-views/)
4.  [Why use Domain Events?](https://io.made.com/why-use-domain-events/)

There's more on io.made.com but those are the main four. We'd love to get some feedback on them, what's covered well, what could do with more explanation, and so on...

And: a very timely release from last Christmas, check out [Clean Architectures in Python](https://leanpub.com/clean-architectures-in-python) by Leonardo Giordani. It's really two books in one, part one being an intro to TDD, but part 2 has four chapters introducing very similar patterns to the ones I'm talking about here.

I also enjoyed a talk from about a year ago by David Seddon [The Rocky River, how to architect your Django monolith](http://seddonym.me/talks/2017-12-12-rocky-river/), showing someone else starting to think about how we go beyond the basic Django models/views/templates architecture.

There's lots more at this [listing of DDD resources](https://github.com/valignatev/ddd-dynamic) by Valentin Ignatev, which I came across recently on twitter. It feels like something is in the air.

## Call to action: is this stuff interesting?

Bob's already had some good feedback to his blog posts, and Leonardo has had some good initial sales, so I'm sensing some interest from the Python community out there, but I'd like to sanity-check it.

*   Does this stuff sound interesting or relevant? Do you want to hear more?
*   Are you doing Python stuff that's getting beyond the bounds of "basic webapp development" or "data pipeline"? Are you finding it difficult to write fast unit tests? Are you starting to want to disentangle your business logic from whichever framework you use?
*   Are you doing DDD or using any of these classic patterns with Python already? Do you maybe have all the answers and want to tell me about it? Or maybe just some answers and things that have worked well for you?
*   Do you think this stuff all sounds hella abstract and pointless? Maybe Made.com is a bit of an outliner in the Python world, in that we're writing logistics/ERP/enterprisey software in Python, and it all feels very different from what you do day-to-day?
*   What do you think the Python / dynamic languages community would most benefit from in terms of new guides to these topics?

I'd love to hear from you. Comments are open, or [hmu on twitter, @hjwp](https://twitter.com/hjwp)

## Did I say read the classics? Read the classics.

*   Patterns of Enterprise Architecture by Martin Fowler [amazon.com](https://amzn.to/2U6HTZN) / [.co.uk](https://amzn.to/2R0WkN3) 
*   Domain-Driven Design by Eric Evans [amazon.com](https://amzn.to/2W9nANe) / [.co.uk](https://amzn.to/2B7vmOP)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
