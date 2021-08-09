> * 原文地址：[Magic Numbers Are Not That Magic](https://medium.com/better-programming/magic-numbers-are-not-that-magic-132297d435f5)
> * 原文作者：[Steven Popovich](https://medium.com/@steven.popovich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/magic-numbers-are-not-that-magic.md](https://github.com/xitu/gold-miner/blob/master/TODO1/magic-numbers-are-not-that-magic.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[fltenwall](https://github.com/fltenwall)、[HumanBeingXenon](https://github.com/HumanBeingXenon)

# 幻数并没有我们想象中的那么奇幻

> A better solution for hardcoded numbers

![图自 [Maail](https://unsplash.com/@maail?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 源 [Unsplash](https://unsplash.com/s/photos/feathers?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9562/1*fzMDTQAsZ8D9O3YXJwLW5A.jpeg)

我真的不喜欢幻数这个词 —— 我看到太多人都理解错了。我见过这么一种代码审查，一看见代码中或者注释中有数字就评论：“哦，这是个幻数呢，请您务必给它取个名并放在代码头部”，我好多的代码里也会有这样的评论。

（我也很不喜欢有的时候我们会有应该要把所有的变量放在一个文件的顶部的想法，但这是另一个故事。）

亲爱的开发人员们啊，您可以在代码中大量使用纯数字，只是请务必注意自己在干什么啊。

## 什么是幻数？

我的意思是，您可以在 Google 上搜索它，并获得一堆如金银绸缎但却又站不住脚的定义。但实际上，幻数其实就是代码中难以理解的数字。

```kotlin
fun generate() {
    for (i in 0 until 52) {
        deck[i] = uniqueCard()
    }
}
```

这个 52 从哪来的？

好吧，事实证明这是生成纸牌组的代码，而 52 恰好是纸牌组中的纸牌总数。不妨让我们给数字起个名字。

```kotlin
const val numberOfCardsInADeck = 52

fun generate() {
    for (i in 0 until numberOfCardsInADeck) {
        deck[i] = uniqueCard()
    }
}
```

这样，代码就会更具可读性、可维护性。太好了，您已经掌握了如何编写干净的代码的不二法门。

嘿嘿，不，这只是冰山一角。这个示例（这是一个非常常见的示例）告诉我们一个非常深奥的道理 —— 开发人员可能很容易地从其余的代码中明白 52 究竟是什么 —— 这是一只非常温顺的幻数怪。

当幻数怪突然冒出来的时候，那才是它们展示真实面孔的时间嗷。例如使用以下代码调整搜索算法：

```kotlin
fun search(query: String) {
    find(query, 2.4f, 10.234f, 999, Int.MAX_VALUE, false)
}
```

噢这奇怪的数字到底意味着什么？看来想要弄清楚这些数字的用途和作用并不容易。

## 为什么使用幻数是个问题？

假设您的应用规模不断扩大，需要搜索的内容还很多，突然之间，您的搜索结果并没有完全满足您的需求。

我们有一个错误："当我搜索"麦片"时，即使我知道谷物一定是它的成分，谷物也不会出现在结果中。"

在本算法四年前那最后一次被修改以后，我的 Joe Schmo 啊，您现在需要更改这些值以解决此错误，而您首先需要改变什么？

—— 幻数。如果您将这些幻数怪与一个描述性名称或者注释文档组合在一起，那么就可以杀害幻数怪。当然，幻数怪那么可爱，杀害它们会让我们更容易理解这个算法！让我们一起来解决这个问题：

```kotlin
const val searchWeight = 2.4f // 查询结果的具体程度，增加此数字以获得更多模糊的结果
const val searchSpread = 10.234f // 结果的连续程度。在数据库中连续选择更多单词
const val searchPageSize = 999 // 每个搜索页面所需的结果数
const val searchMaxResults = Int.MAX_VALUE // 我们希望的能从搜索中获得所有可能的结果
const val shouldSearchIndex = false // 我们不想搜索索引

fun search(query: String) {
    find(query, searchWeight, searchSpread, searchPageSize, searchMaxResults, shouldSearchIndex)
}

// 调用我们的加权搜索算法。在foo.bar.com上阅读有关此算法的文档
fun find(query: String, weight: Float, spread: Float, pageSize: Int, maxResults: Int, index: Boolean) {}
```

处理这样的代码，您会不会感觉舒服多了？您甚至可能对如何进行更改有所了解。优化搜索可能很困难，但是接手的人凭着这份文档，就能更好地解决这个漏洞

## 什么不能称之为幻数？

实际上，难以推理的数字不会像容易推理的数字那样频繁出现。例如这个数据：

```kotlin
view.height = 42
```

这可不是一个幻数，我再强调一遍：这不是一个幻数！

我知道。我给一些 Java 代码纯粹主义者和洁癖一个暴击。

但是这个数字并不难推论 —— 它的意义是完全独立的 —— 该视图的高度为 42！最多的翻译就是这样，但是像这样数据，即使我们给它取一个名称，又会增加什么价值？

```kotlin
const val viewHeight = 42

fun buildView() {
    view.height = viewHeight
}
```

以上做法只会导致冗杂代码。而这似乎是一个很小的例子，但是这种不必要地命名数字的想法会迅速增加 UI 代码的大小 —— 增加代码行数，完成绩效。

## 所以我们是否可以在代码中使用数字？

这是当然的！世界上有很多不错的代码里面使用了数字。要做到不出现幻数，您只需要记住以下几点：

* 确保您的数字易于理解 —— 就算是孩子也能指出数字是哪里来的
* 如果您要更改数字，调整某些内容，或在纸上进行一些计算才能得到的硬编码数字，请务必进行解释。在代码中，在数字旁边，或至少在更改的提交中，应当提出并解释硬编码数字发生的变更。
* 额外一招：请确保您的硬编码数字是干净的

相信我，使用注释解释或使用变量名解释数字是很有用的！

祝你好运，感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
