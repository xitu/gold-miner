> * 原文地址：[How GitHub Actions renders large-scale logs](https://github.blog/2021-03-25-how-github-actions-renders-large-scale-logs/)
> * 原文作者：[Alberto Gimeno](https://github.blog/author/gimenete/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/how-github-actions-renders-large-scale-logs.md](https://github.com/xitu/gold-miner/blob/master/article/2021/how-github-actions-renders-large-scale-logs.md)
> * 译者：[felixliao](https://github.com/felixliao)
> * 校对者：

![](https://github.blog/wp-content/uploads/2019/03/engineering-social.png?fit=1201%2C630)

# Github Actions 是如何渲染超大日志的

在 web 端渲染日志看起来很简单：它们只是一行一行的纯文本。但是它也可以有许多方便用户的附加功能：着色、分类、搜索、永久链接等等。但是最重要的是，不管日志只有十行还是数万行，其界面都应该都能正常运作。这是我们从 GitHub Actions 2019 年向公共开放时就优先关注的。我们那时候还没有使用使用量指标，但我们需要应对超长日志是显而易见的。浏览器可能在初次加载时卡住，处置不当的话也很可能导致其完全无法使用。我们必须应用一个叫虚拟化的技术。

虚拟化是指只渲染列表中的一部分内容，既可以让界面顺畅地运作，又不会让用户发现视窗外的内容并没有被渲染。它需要在用户滚动的时候更新当前可见的内容，甚至在内容还没被渲染时就计算布局的位置，来保证滚动体验顺畅。

![](https://github.blog/wp-content/uploads/2021/03/large-scale-log-rendering-fig-1.png?w=442&resize=442%2C374)





## 初步实现

在我们首次发布 GitHub Actions 时，我们测试了一个基于 React 的和一个原生 JavaScript 的库。有些库因为其实现方式有很大局限性。比如，很多库要求所有被渲染的条目有固定的高度。这个局限另它们的计算简单了很多，因为如果一个用户想滚动到一个特定的条目（可见与否），它们只需要计算 `item_index * items_height` 就可以计算出其位置并滚动过去。而且，在计算整个可滚动区域的高度时，它们同样只需要计算 `items_count * items_height` 即可。当然，很多情况下条目的高度不是固定的，所以这个局限性是不可接受的。在 GitHub Actions 这里，我们想让那些很长的行分行显示，这意味着我们需要支持高度可变的日志条目。

我们最终选择了一个具有大部分我们需要功能的原生 JavaScript 库：支持可变高度，滚动到特定条目等等。但是，我们很快就碰到了瓶颈，

- 它要求可滚动区域需要有一个固定高度，这是个常见的限制，用来让其内部实现变得简单。但在我们的案例中，这令用户体验变得很差，特别是因为在我们的日志中，一个任务有数个步骤，并且每个步骤都有自己的虚拟化列表。这意味着页面中的每个步骤都需要自己的可滚动区域，并且还需要有一个服务整个页面的滚动条。
- 测试结果中，那些从隐藏转为可见的虚拟列表表现的不好。在 GitHub Actions 中，我们允许用户展开和收起步骤，并且可以自动扩展日志。我们发现一个在步骤开始运行时的 bug。当那些自动扩展的日志变得可见，但网页标签并不可见时（译者按：切到了其他标签），用户在切回此页面后有时会看不到那些扩展开的日志。
- 用户不能在滚动的同时选中文本，因为被选中的文字会因为虚拟化而被从 DOM 中移除。
- 有些时候，我们需要在后台渲染日志行来计算它们的高度，这使得体验变得很卡。虚拟化并没有帮到我们太多，并且我们有时实际上在渲染一些行两次，而不是完全不渲染它们。但我们必须这么做，因为错误的高度计算会导致日志行被界面截断。

* **DOM 结构**：另一个挑战是如何组织 DOM 来在只有一个可滚动区域的条件下允许粘性标头。该滚动容器不仅要满足这两个条件，还不能使用到虚拟化技术。

我们很快实现了一版来验证我们的策略。在经过一番生成大型日志的测试后，我们发现，尽管证明了我们可以用自己的实现方式来满足所有目标，但是我们必须非常小心，因为很容易就会犯错并毁掉整个体验。例如，我们很快就发现，改变尽可能少的 DOM 节点固然重要，但是在滚动时尽可能减少 DOM 的变化也是非常重要的。当用户滚动时，我们需要加入变得可见的节点，并移除那些已经不在页面中的。如果用户滚动速度很快，尤其是在移动设备上，很容易就会导致过多的 DOM 变化，并带来不良的体验。

然而我们也有几个办法来解决这个问题。比如，你可以使用节流来分批次缓速更新。但我们发现这种方法会让用户界面变得不流畅。最后我们想的办法是将日志行分块，因此在增加和移除内容时，我们不操作单独的行，而是操作由 N 行组成的块。经过一些测试，我们得出了一个块应该有多少行：50。

# 生产就绪

我们用了大概一周时间来完成初步的实现，该实现已经让我们看到了诸多用户体验上的改良。此时我们已经知道自己在正确的道路上了。接下来的几周里，我们继续完善 [用户界面和体验](https://github.blog/2020-09-23-a-better-logs-experience-with-github-actions/)，并且我们知道我们会有一大堆边缘案例需要处理。

经过大量的内部工作，我们将其交付给了用户，并很高兴可以提供更优质的日志体验：更快、更流畅、更好用，而且更完整和健壮。大部分时间你不需要重新发明轮子，但有些时候最好的解决方案就是自己从头实现的解决方案，这样才能够完全地掌控产品的体验和性能。

However, we can fix this in a few ways. For example, you can throttle your code and do the updates in batches and not very frequently. But we found that this approach made the UI less smooth. We came up with the idea of grouping log lines in clusters, so instead of removing and adding individual lines, we put log lines in clusters of N lines and add or remove clusters instead of individual lines. After some tests, we now have an idea of how many lines a cluster would have: 50 lines per cluster.

## Production ready

In a week or so, we were able to get an initial implementation that allowed us to see all the benefits in terms of UX. At that point we knew we were on the right path. The next few weeks we worked on other [UI/UX improvements](https://github.blog/2020-09-23-a-better-logs-experience-with-github-actions/) and we knew there was a long tail of edge cases we had to deal with.

After a lot of work internally on this, we shipped it to all users and are happy to now offer a superior logs experience: faster, smoother, friendlier, and more cohesive and robust. Most of the time you don’t have to reinvent the wheel, but sometimes the best solution is to implement your own solution from scratch to have the experience and the performance totally under your control.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
