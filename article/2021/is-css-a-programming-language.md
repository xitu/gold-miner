> * 原文地址：[Is CSS a Programming Language?](https://css-tricks.com/is-css-a-programming-language/)
> * 原文作者：[Chris Coyier](https://css-tricks.com/author/chriscoyier/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/is-css-a-programming-language.md](https://github.com/xitu/gold-miner/blob/master/article/2021/is-css-a-programming-language.md)
> * 译者：[cncuckoo](https://github.com/cncuckoo)
> * 校对者：[Kimhooo](https://github.com/Kimhooo)，[Chorer](https://github.com/Chorer)

# CSS 是编程语言吗？

我很讨厌这个问题。表面上看，这个问题好像很有意思，可以挖掘一下，但人们在讨论的时候却很少表现出诚意。这里面有着不可告人的动机，涉及尊重、情感保护，以及希望**打破**或**维持**现状的意愿。

如果有人可以证明 CSS 不是编程语言（这是个灰色地带，如果这是你的目标，那要证明它并不难），那他们就可以因为“真正的”编程技能而继续自认为高人一等，同时也可以合理化自己的薪资（可能）高于专注 CSS 的前端开发者的事实。这是维持现状的。

反之也是可以的。如果你可以证明 CSS 是一门编程语言，那或许可以推动你自己的公司或行业一视同仁，给予前端开发者中的 UI 专家同等的尊重和薪资。这是打破现状的。

假设关于 CSS 是不是编程语言，我们都同意用布尔值 `true` 或 `false` 去选择。然后呢？选择 `true`，是否意味着所有 Web 从业者的薪资会趋同？选择 `false`，是否意味着 CSS 专家的薪资应该少一些？`true`，是否意味着所有人告别偏见而相互尊重？`false`，是否意味着写 CSS 的就必须在锅炉房里吃盒饭？我怀疑这一切有什么会发生变化，所以我才讨厌讨论这个话题。

无论事实怎样，让大多数人接受 CSS 可能是编程语言都不现实。我的意思是，程序需要“执行”，不是吗？没人质疑 JavaScript 是不是编程语言，因为它会执行。你写代码，然后执行代码。可能你在终端窗口里会这么写：

```bash
> node my-program.js
```

真的假不了，这个程序会执行。你可以用`console.log("Hello, World!");`把“Hello World!”打印到控制台。

CSS 做不到这件事！嗯，那好，除非你在 style.css 文件中写下 `body::after { content: "Hello, World!"; }`，然后打开加载这个 CSS 文件的网页。看，CSS 也执行。只不过是以它自己的特殊方式执行。可以说它是 DSL（领域特定语言，Domain-Specific Language）而不是 GPL（通用编程语言，General-Purpose Language）。在浏览器环境里，让 CSS 运行的方式（通常是 `<link>`）甚至跟让 JavaScript 运行的方式（通常是 `<script>`）没多大差别。

如果要比较 CSS 语法和编程概念，我想你也可以找到对应的。如果没有某种 `if` 语句运行循环匹配，选择器又是在做什么呢？如果没有实现数学运算，那 [`calc()`](https://css-tricks.com/a-complete-guide-to-calc-in-css/) 是怎么得出结果的？如果没有 `switch` 的概念，那[媒体查询](https://css-tricks.com/a-complete-guide-to-css-media-queries/)怎么起作用？如果没有地方保存状态，那你怎么使用[自定义属性](https://css-tricks.com/a-complete-guide-to-custom-properties/)？如果不存在布尔逻辑，[`:checked`](https://css-tricks.com/almanac/selectors/c/checked/) 什么时候生效？Eric 最近证明了 [CSS 是强类型语言](https://css-tricks.com/css-is-a-strongly-typed-language/)，而他在早前也曾提出，CSS 里到处都是[函数](https://css-tricks.com/complete-guide-to-css-functions/)。

无论如何，CSS 是不是一门编程语言的答案对人们还是有影响的。一位大学教授曾向学生证明 CSS 不是图灵完备的，但在了解到它是图灵完备的以后，[现在又重新反思这个观点](https://lemire.me/blog/2011/03/08/breaking-news-htmlcss-is-turing-complete/)。无论出于什么目的，我认为计算机科学教授像这样年复一年地讲给计算机科学专业的学生听，对行业肯定是有影响的。

Lara Schenck [曾深挖过图灵完备的立场](https://notlaura.com/is-css-turing-complete/)。如果你正尝试解决这个问题，图灵完备性是个不错的方向。最终结论，CSS 基本上是图灵完备的（从细胞自动机 110 号规则的角度来看），只是不完全靠它自己。这涉及到选择器和 `:checked`（有点令人吃惊）的复杂应用。Lara 作了一个机智的论断：

> 单独看，CSS 不是图灵完备的。而 CSS 加 HTML 加上用户输入是图灵完备的！

假设你还是不买账。但你**了解**了，甚至也让步了，那好，CSS 基本上是图灵完备的，只不过你没有觉得 CSS（或者 HTML）是一门编程语言。毕竟它太声明式了，太特定于应用了。无论怎样，我都真心不怪你。我希望的是，无论你得出什么结论，答案都不要影响真正重要的东西<sup>[1]</sup>，比如薪资和尊重。

尊重是必要的，与我们中的什么人寻求这个问题的答案无关。我不认为 CSS 是编程语言，但这不表示我认为它不重要或者我的 CSS 同事不如 Python 同事更有价值。这样不是很好吗？我觉得声明式标记语言跟其他类型语言相比有一个非常有意思的区别，但它们都是代码。好了，可以了，像这么有深度的回答会让我不好意思的。

希望再有类似讨论出现时，可以看到更多言之有物、相互尊重、不那么自我的评论。

- - -
1. 就像“网站”和“Web 应用”一样。无论你是否觉得有区别，我都希望人们不要按照自己主观的分类方式作出影响用户的决定。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
