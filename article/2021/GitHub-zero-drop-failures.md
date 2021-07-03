> * 原文地址：[How Project Cyclop Enabled GitHub to Reduce Push Failures to Nearly Zero](https://www.infoq.com/news/2021/03/GitHub-zero-drop-failures/)
> * 原文作者：[Sergio De Simone](https://www.infoq.com/profile/Sergio-De-Simone/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/GitHub-zero-drop-failures.md](https://github.com/xitu/gold-miner/blob/master/article/2021/GitHub-zero-drop-failures.md)
> * 译者：
> * 校对者：

# How Project Cyclop Enabled GitHub to Reduce Push Failures to Nearly Zero

GitHub spawned [Project Cyclop several months ago to identify what caused occasional push failures and find a fix](https://github.blog/2021-03-16-improving-large-monorepo-performance-on-github/). It turns out there was no single culprit, and a careful analysis led to identify a number of changes improved push traffic by at least an order of magnitude, according to GitHub.

While GitHub is generally known to be pretty reliable in its operation, every system has some limitations or under-optimal performance under certain conditions, writes GitHub engineer Scott Arbeit. For GitHub, this manifested in occasional failures while pushing a repo, specifically with large monorepos where literally thousands of developers could update the same repo every day.

The first area identified for improvement by GitHub engineers was repository maintenance. This is a bunch of scripts run periodically on a repository to update packfiles and improve clone operations, and to remove de-duplicates data. For large monorepos, maintenance operations are both frequent and lengthy, resulting in a higher failure rate.

> When a repo fails maintenance, performance for both push and reference updates suffers, which can lead to manual toil for our engineers to sort out those repositories again.

GitHub succeeded in reducing that failure rate to almost zero by improving [`git repack`, which combines all objects that do not reside in a pack into one](https://git-scm.com/docs/git-repack). Since packs only store object deltas, as opposed to full objects, they can be computationally expensive, due both to the number of objects to compare and to the time it takes to determine whether two objects are related. That was causing a number of maintenance tasks to fail due to execution time limits.

> We’ve implemented a parameter to limit the number of expensive comparisons we’re willing to make. By tuning this value, we’ve reduced the CPU time we spend during git repack, while only marginally increasing the resulting packfile size.

An additional improvement was made possible by changing the retry policy for failed maintenance tasks. In particular, for monorepos the default policy of not scheduling maintenance for seven days after a failure was proving problematic, due to monorepos being updated quickly.

> We introduced a new spurious-failure state for specific repository maintenance failures—the ones that generally come from lots of push traffic happening during maintenance—that allows us to retry maintenance every four hours, up to three times.

Retrying every four hours had the additional benefit of having a better chance of catching a customer's off-hours, with lower traffic on the repo, says Arbeit.

GitHub engineers also discovered they were artificially capping their servers' performance by slowing down the rate of processed pushes on each server for nothing but historical reasons.

> After an investigation where we slowly raised the value of this parameter to allow 100% of push operations to run immediately, we found that performance with our current architecture was more than good enough.

A final improvement removed a performance limitation in the three-phase-commit protocol used to update git references across the five different replicas of a repo GitHub maintains for safety. Simply stated, instead of computing a checksum on each replica *inside* the protocol lock window, this is now done before taking the lock. For repair operations on monorepos, which could lock replica servers for up to 20-30 seconds, this allowed to reduce the overall lock window to under 1 second.

Thanks to these changes, Arbeit remarks, GitHub has made life significantly easier for large monorepos users but also improved general push performance for everyone.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
