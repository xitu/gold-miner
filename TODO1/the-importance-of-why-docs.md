> * 原文地址：[The Importance of “Why” Docs](https://medium.com/better-programming/the-importance-of-why-docs-c8ffba0ea520)
> * 原文作者：[Bytebase](https://medium.com/@bytebase)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-importance-of-why-docs.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-importance-of-why-docs.md)
> * 译者：
> * 校对者：

# The Importance of “Why” Docs

> Giving future engineers context on why decisions were made

![Photo by [Emily Morter](https://unsplash.com/@emilymorter?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/why?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10368/1*2KhDOt8Dgcq17b-8rlMsig.jpeg)

Many of us have, at one time or another, blindly followed a pattern we noticed, thinking that must be the way to do it. We do so without questioning if that pattern is the best fit for our particular situation or if that pattern was ever a good idea to begin with.

In doing this, we rob ourselves of the opportunity to learn and deepen our understanding, to be intentional with our work, and, ultimately, to get better at our craft. Even more, we set yet another precedent for colleagues to do the same, instead of encouraging them to dig deeper.

## The Girl and the Fish

![](https://cdn-images-1.medium.com/max/10944/1*mvAQ0v229MXNdrTWSglD1w.jpeg)

I recently learned about the fable of a young girl watching her mother cook fish:

> A little girl was watching her mother prepare a fish for dinner. Her mother cut the head and tail off the fish and then placed it into a baking pan.
>
> The little girl asked her mother why she cut the head and tail off the fish.
>
> Her mother thought for a while and then said, “I’ve always done it that way. That’s how grandma always did it.”
>
> Not satisfied with the answer, the little girl went to visit her grandma to find out why she cut the head and tail off the fish before baking it. Grandma thought for a while and replied, “I don’t know. My mother always did it that way.”
>
> So the little girl and the grandma went to visit great-grandma to find ask if she knew the answer. Great-grandma thought for a while and said, “Because my baking pan was too small to fit in the whole fish!”

**— [via Ptex Group](https://ptexgroup.com/learned-story-fish/)**

The girl’s mother took off the head and tail of the fish because she was unaware of the great grandmother’s constraint of a small pan. She didn’t ask “why” when she adopted the recipe, and the great grandmother didn’t realize she should tell her. As a result, the girl’s mother was still able to cook fish, but she was cooking suboptimally. She was cooking uninformed.

By asking “why,” the little girl can change the recipe with confidence because she knows the original constraint of a small pan no longer holds.

---

## Asking “Why” in Docs

Like the little girl, we want to break the cycle of doing without understanding. We can break this cycle by asking “why,” and by documenting why as we build.

Code tells you **how** a software system works. Docs tell you **why** a system works this way.

> Code tells what, docs tell you why.” — **Steve Konves at [Hacker Noon](https://hackernoon.com/write-good-documentation-6caffb9082b4)**

Writing down “why” as we build will:

* Reduce the number of outages caused by changing code without understanding it
* Reduce the time spent hunting down why software was written a certain way
* Build a culture of craft and critical thinking in our teams
* Empower our teams to build better

#### When to write “why”

As you code, throughout the day, ask yourself:

> Are there certain constraints that are impacting my work?
>
> Is there anything I’m doing that requires explanation to understand fully?

These constraints can be related to:

* Tight deadlines
* Lacking resources on a project
* Known bugs we’d like to mitigate
* User-traffic patterns

Some building that requires explanation can be:

* Why we decided to duplicate code instead of reuse code
* Why we’re committing code in this order
* Why we have this unusual-looking edge case handling

Write those constraints and explanations down.

#### Example constraints

* This feature needs to be released immediately, so we’re accepting poorer code quality
* We need to support backward compatibility of our iOS app to v1.1, so we have to pass this extra field
* We’re expecting a 100x burst load tomorrow, so we’re increasing our base instance size
* Team size is three engineers, so we only want to support one programming stack
* Our project requirements aren’t clear enough, so we’re holding off on updating this feature for now

#### Example explanations

* We’re duplicating our blog model because we want to move to a backward-incompatible model
* We’re avoiding our usual API for this because that API has been known to cause performance issues in use cases like ours
* The special account balance value of -$200 indicates this is an employee account

## How to Make “Why” Easy to Find

Part 2 of this post will cover how you can use Git to capture the “why” related to your code as part of your daily routine.

We’ll also go over how Bytebase makes sharing and finding the “why” behind your team’s work easy.

## References

[**Write Good Documentation**](https://hackernoon.com/write-good-documentation-6caffb9082b4)

* [“Etsy’s experiment with immutable documentation”](https://codeascraft.com/2018/10/10/etsys-experiment-with-immutable-documentation/) via Code as Craft
* [“What I Learned from the Story of the Fish”](https://ptexgroup.com/learned-story-fish/) via Ptex Group

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
