> * 原文地址：[Magic Numbers Are Not That Magic](https://medium.com/better-programming/magic-numbers-are-not-that-magic-132297d435f5)
> * 原文作者：[Steven Popovich](https://medium.com/@steven.popovich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/magic-numbers-are-not-that-magic.md](https://github.com/xitu/gold-miner/blob/master/TODO1/magic-numbers-are-not-that-magic.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[fltenwall](https://github.com/fltenwall)、[HumanBeingXenon](https://github.com/HumanBeingXenon)

# 幻数并没有我们想象中的那么奇幻

> 一个比硬编码数字的更好的解决方案

![图自 [Maail](https://unsplash.com/@maail?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 源 [Unsplash](https://unsplash.com/s/photos/feathers?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9562/1*fzMDTQAsZ8D9O3YXJwLW5A.jpeg)

我真的不喜欢幻数这个词 —— 我看到太多人都理解错了。我见证也参与过几次，看见有人一见着代码中或者注释中有数字就评论：“哦，这是个幻数呢，请你务必给它取个名并放在代码头部”的代码审查。

（我也很不喜欢感到需要把所有的变量都放在文件的头部部分中，但这该是另一天的话题。）

开发者们，你们是可以在代码中使用数字。只是要小心使用的方式。

## 什么是幻数？

你确实可以在 Google 上搜索它，找到一堆无趣的定义。但实际上，幻数其实就是代码中难以理解的数字。

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

这是更易读、更易维护和更好的代码。很好，你已经掌握了怎么去写一段清晰明了的代码的本领了？

嘿嘿，不，这只是冰山一角。这个示例（这是一个非常常见的示例）之中开发者可能可以很容易地从其余的代码中明白 52 究竟是什么 —— 这个幻数其实也没有那么离谱。

那什么时候幻数能够给你当头一棒？当你完全没有念头这个数字到底怎么来的时候。比方说下面这段用于对搜索算法进行调整的代码：

```kotlin
fun search(query: String) {
    find(query, 2.4f, 10.234f, 999, Int.MAX_VALUE, false)
}
```

噢这奇怪的数字到底意味着什么？看来想要弄清楚这些数字的用途和作用并不容易。

## 为什么使用幻数是个问题？

假设你的应用规模不断扩大，需要搜索的内容还很多，并且突然之间，你的搜索结果不能完全满足你的需求了。

我们现在有一个 bug："当我搜索"麦片"时，即使我知道谷物一定是它的成分，谷物也不会出现在结果中。"

在这个搜索算法四年前那最后一次被精调以后，我的朋友你啊，你现在需要更改这些值以解决此错误。你该先去修改些什么呢？

这就是幻数的问题。这些数字最好是被归类在一处，用一些比较长的、很形象的名称去给它们命名，以及写清楚更改它们会如何影响结果的代码间文档。

```kotlin
const val searchWeight = 2.4f // 查询结果的具体程度，增加此数字以获得更多模糊的结果
const val searchSpread = 10.234f // 结果的连续程度。在数据库中连续选择更多单词
const val searchPageSize = 999 // 每个搜索页面所需的结果数
const val searchMaxResults = Int.MAX_VALUE // 我们希望的能从搜索中获得所有可能的结果
const val shouldSearchIndex = false // 我们不想搜索索引

fun search(query: String) {
    find(query, searchWeight, searchSpread, searchPageSize, searchMaxResults, shouldSearchIndex)
}

// 调用我们的加权搜索算法。在 foo.bar.com 上阅读有关此算法的文档
fun find(query: String, weight: Float, spread: Float, pageSize: Int, maxResults: Int, index: Boolean) {}
```

着手于这样的代码应该会让你感到舒服多了吧？你甚至可能对如何进行更改有所了解。优化搜索可能确实会很困难，但是接手的人凭着这份文档，还是能更轻松地解决上面提到的那个问题。

## 什么不能称之为幻数？

实际上，难以推理的数字不会像容易推理的数字那样频繁出现。例如这个数据：

```kotlin
view.height = 42
```

这可不是一个幻数，我再强调一遍：这不是一个幻数！

我知道。我给一些 Java 代码纯粹主义者和洁癖一个暴击。

但是这个数字并不难推论 —— 它的意义是完全独立的 —— 该视图的高度为 42！我们顶多解释到这个程度。像这样数据，即便我们给它取一个名称，又真的会带来什么价值吗？

```kotlin
const val viewHeight = 42

fun buildView() {
    view.height = viewHeight
}
```

这样做法只会导致冗杂代码的产生。这看似是一个很小的例子，但这种不必要地命名数字的想法却会迅速增加 UI 代码的大小，增加代码的行数。

## 所以我们是否可以在代码中使用数字？

这是当然的！世界上有很多不错的代码里面使用了数字。要做到不出现幻数，你只需要记住以下几点：

* 确保你所使用的数字易于理解 —— 就算是小孩也能弄清楚它们从何而来
* 如果你要更改数字，调整某些内容，或在纸上进行一些计算才能得到的硬编码数字，请务必进行解释。在代码中，在数字旁边，或至少在更改的提交中，应当提出并解释硬编码数字发生的变更。
* 额外一招：请确保你使用硬编码数字是遵循 DRY 原则的（一个规则，一次实现）。

相信我，使用注释解释或使用变量名解释数字是很有用的！

祝你好运，感谢你的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
