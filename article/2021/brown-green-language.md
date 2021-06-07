> * 原文地址：[Green Vs. Brown Programming Languages](https://earthly.dev/blog/brown-green-language/)
> * 原文作者：Adam Gordon Bell
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/brown-green-language.md](https://github.com/xitu/gold-miner/blob/master/article/2021/brown-green-language.md)
> * 译者：[chzh9311](https://github.com/chzh9311)
> * 校对者：[Kimhooo](https://github.com/Kimhooo)、[PingHGao](https://github.com/PingHGao)、[PassionPenguin](https://github.com/PassionPenguin)、[Chorer](https://github.com/Chorer)

# “绿色” 和 “棕色” 的编程语言

## 数据

Stack Overflow 的开发者调查 <sup>1</sup> 结果是了解开发者工作情况的重要信息来源。最近我分析了 2020 年的调查结果，希望以此确定我们应该在集成发行版的[文档](https://docs.earthly.dev/basics/part-1-a-simple-earthfile)里添加什么语言。我发现了一些关于人们喜爱哪种编程语言的有趣结论，而这些结论似乎在很多关于编程语言偏好的讨论中都没有出现。

调查结果包含了**最令人畏惧的编程语言**和**最受欢迎的编程语言**这两组排名。它们来自同一个问题：

> 在过去的一年里，你主要的开发工作是用哪一种编程、脚本和标记语言完成的？在接下来的一年里，你又想用哪一种语言工作呢？（如果你已经在用这种语言工作而且希望能继续使用，请在那一行把两个框都勾上。）

令人畏惧的语言指的是你今年主要在用但不想再继续用下去的语言，而受欢迎的语言则指的是你主要在用而且希望继续使用的语言。这些结果很有趣，因为它们反映的观点来自主要使用这种语言的开发者们，应该不会受到 “我听说很棒” 这种心理的影响，也就是说，人们不会仅仅因为语言热门就给他们并不使用的语言打很高的分数。反之亦然：把语言放在**令人畏惧**列表上的也是正在使用它们的人。他们害怕这种语言不是因为听说它很复杂，而是确实在使用它的过程中感到痛苦。

**最令人畏惧的语言榜单 TOP 15：**

VBA、Objective-C、Perl、Assembly、C、PHP、Ruby、C++、Java、R、Haskell、Scala、HTML、Shell 和 SQL。

**最受欢迎的语言榜单 TOP 15：**

Rust、TypeScript、Python、Kotlin、Go、Julia、Dart、C#、Swift、JavaScript、SQL、Shell、HTML、Scala 和 Haskell。

这个列表蕴含了某种规律，你能发现吗？

## 在我参与之前写的代码是最糟糕的

旧的代码是最糟的。如果让你从一个已经开发了三年以上的代码库里给我找一个文件，你会发现很难追踪。最初只是一个很直接的文件获取层，却在开发过程中逐渐加入了特殊案例、性能优化以及各种由设置选项控制的分支。真实世界中的代码需要根据市场需求进行迭代，而在迭代的过程中，它就变得更加复杂且难以理解。这种现象背后的原因很简单，我最初是从 Joel Spolsky 口中听到的。

> [开发者们]认为旧代码一团糟的原因可以追溯到一个最基本的编程法则：**阅读代码比写代码要难**。—— Joel Spolsky，[Things You Should Never Do, Part I](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/)

我们可以把它称为 Joel 定律。很多事情都遵从这个前提。为什么大多数开发者认为他们接手的代码是一团糟，还想要把它们删掉重写？这是因为从认知层面来说，写新的程序要比阅读写好的代码库轻松很多，至少在最开始是这样。为什么很多重写工作都难逃失败的厄运？因为大部分让代码看上去乱七八糟的语句实际上是至关重要的细微提升，这些提升是随着时间推移慢慢累积的。如果毫无规划地精简这些代码，你最后就不得不回到起点。

![我接手的项目代码很糟糕。我需要从头开始重新写一遍。/ 难道就没有一名工程师会说：“上一位伙计做的很棒。让我们把他的工作保留下来”？ / 我希望你招过来取代我的白痴会这么说。](https://earthly.dev/blog/assets/images/brown-green-language/dt140812.gif)

Scott Adams 的理解

理解你正在写的代码是件很容易的事。你在不断地执行和改进这些代码。但是仅靠阅读去理解已经写完的代码就比较困难了。如果你回看自己写过的旧代码并发现它很难理解，这可能是因为你作为一名开发者已经有所成长，能够把它写得更好。但是也有可能代码本身就很复杂，可你却把理解这种复杂性的痛苦归咎于代码本身的质量问题。这会是 PR 持续积压问题的诱因吗？PR 检查是一项只读的工作，如果你脑中没有一个当前代码的运转模型，你就很难把它做好。

## 这就是你害怕它的原因

如果很多现实世界的代码会被冤枉成一团乱麻，编程语言也会被冤枉吗？如果你用 Go 写新的程序，却不得不维护一个有 20 年历史、十分庞杂的 C++ 代码库，你能把这两种语言公正地排名吗？我认为这就是调查问卷实际上在评估的：令人畏惧的语言通常被用于已存在的棕地项目<sup>5</sup>，而受欢迎的语言则更多被用于崭新的绿地项目<sup>6</sup>。让我们验证这一点。<sup>2</sup>

## 衡量棕色和绿色的语言

TIOBE 指数宣称可以通过“全世界范围内熟练的工程师、课程和岗位的数量”衡量编程语言。他们度量的方式可能会有些问题，但其准确度对我们的目标而言已经足够了。我们用了 2016 年 7 月份的 TIOBE [指数](https://web.archive.org/web/20160801213334/https://www.tiobe.com/tiobe-index/)（这是在 Wayback Machine 中能获得的最早的数据）作为已有大量需要维护的代码的编程语言的代表。如果说 2016 年有什么很大的数据，比起对应的语言在 2016 年并不流行的假设，更有可能是人们在维护用这种语言编写的程序。

他们给出的 2016 年 7 月份编程语言排行榜的前 20 名是：Java，C，C++，Python，C#，PHP，JavaScript，VB.NET，Perl，Assembly，Ruby，Pascal，Swift，Objective-C，MATLAB，R，SQL，COBOL 和 Groovy。我们可以把这个排行作为更多被用于维护工作的语言清单。并把这些语言称为“棕色语言”。在 2016 年并未跻身 top 20 的语言则更多地被用于新的项目。我们把这些语言称为“绿色语言”。

![https://earthly.dev/blog/assets/images/brown-green-language/graph1.svg](https://earthly.dev/blog/assets/images/brown-green-language/graph1.svg)

<p align='center'>在令人畏惧和受欢迎这两个列表中出现的 22 种语言里，63% 是棕色语言。</p>

**棕色语言**：在维护已有软件（即棕地项目）时更常用的语言。 

Java、C、C++、C#、Python、PHP、JavaScript、Swift、Perl、Ruby、Assembly、R、Objective-C 和 SQL

**绿色语言**：在新项目（即绿地项目）中更常用的语言。

Go、Rust、TypeScript、Kotlin、Julia、Dart、Scala 和 Haskell

TIOBE 和 Stack Overflow 在什么是编程语言这一问题上有分歧。为了解决这个问题，我们需要把 HTML/CSS，Shell 脚本和 VBA 从两个榜单上移除来实现标准化。<sup>3</sup>

**移除的语言**：TIOBE 和 Stack Overflow 在这些语言上存在分歧。

VBA, Shell, HTML/CSS

这种简单的绿色 / 棕色一刀切的分割方式会丢失很多细节，比如我预计用 Swift 写的绿地项目比用 Objective-C 写的更多，但它看上去确实能有效反映我们所需的信息。表单上棕色语言比绿色语言多得多，但考虑到编程语言每年的排名变化相对较小，这也不出我所料。

现在我们可以回答这个问题了：人们是真的像他们说的那样喜爱和害怕编程语言本身还是仅仅在害怕经年累月的代码？或者换一种说法：如果 Java 和 Ruby 出现在今天，没有那么多旧框架的 app 和旧的企业级 Java 应用要维护，它们是否仍然面目可憎？或者，它们是否更有可能出现在受欢迎的列表当中？

## 令人畏惧的棕色编程语言

![https://earthly.dev/blog/assets/images/brown-green-language/graph2.svg](https://earthly.dev/blog/assets/images/brown-green-language/graph2.svg)

<p align='center'>令人畏惧的语言：83% 是棕色的</p>

最令人畏惧的语言几乎都是棕色的。在我们统计的全部语言中，有 68% 是棕色的，然而在令人畏惧的语言中这一比例达到了 83%，这比随机分配的比例要高。

## 受欢迎的绿色编程语言

![https://earthly.dev/blog/assets/images/brown-green-language/graph3.svg](https://earthly.dev/blog/assets/images/brown-green-language/graph3.svg)

<p align='center'>受欢迎的编程语言：54% 是绿色的</p>

在最受欢迎的语言中，54% 是绿色的。在我们统计的语言中只有 36% 是绿色，而且每一种绿色的编程语言都在受欢迎榜单中占有一席之地。

> 人性的另一个缺点便是，人人都想新建而没人愿意维护。—— Kurt Vonnegut

这可能不足以说明人们的恐惧来源是必须用这种语言来维护项目，但它看上去确实是一个诱因。很多人们喜爱的编程语言都太年轻或没有长时间流行，因而没有那么多臃肿的项目要维护。

换句话说，Rust，Kotlin，还有其他绿色编程语言可能仍处于蜜月期。人们对用这些语言工作的好感可能与不必维护有 20 年历史的代码库有极大的关系，不像某些特定的语言必须维护历史悠久的代码库。

## 战胜偏见

![https://earthly.dev/blog/generated/assets/images/brown-green-language/angel-devil-wide-600-402d4be31.png](https://earthly.dev/blog/generated/assets/images/brown-green-language/angel-devil-wide-600-402d4be31.png)

一些新兴的或以前并不流行的语言有可能比老旧或更加主流的语言要好，但是我们的判断似乎被偏见左右了。实际上，开发者们为新兴的或者过去不常用的语言戴上光环，把它们看做天使，而为已经使用过更长时间的语言插上角，把它们视为恶魔。我认为这是因为没人想维护其他人的工作。况且，正如 Joel 定律所描述的那样：阅读实际存在的代码很困难。建立新事物很有趣，而新兴语言则更多地被用于这种有趣的工作。

## 编程语言风评的生命周期

我最开始深挖这些数据，是为了发布一个编程语言常用性和在开发者中的受欢迎度的排行榜。我本来打算用这些结论作为指导，给我们的[文档](https://docs.earthly.dev)和[构建样例](https://github.com/earthly/earthly/tree/main/examples)添加示例。然而我却在中途产生了一些关于编程语言生命周期的想法：受欢迎的编程语言经常被使用，这就带来了代码维护工作，而维护工作会让人们讨厌这门语言，于是人们就开始寻找更更加崭新的项目、尝试更新颖的语言。流行的框架大概也符合这一生命周期。

![https://earthly.dev/blog/generated/assets/images/brown-green-language/hype-wide-800-83ae14a13.png](https://earthly.dev/blog/generated/assets/images/brown-green-language/hype-wide-800-83ae14a13.png)

<p align='center'>编程语言风评的生命周期</p>

对于这张图表，我并没有数据，但是我清楚地记得 Ruby 在 2007 年是最热门的语言，即便现在它有了更多的竞争对手，Ruby 也比之前要好得多。然而，它现在却变得遭人嫌弃了。对我而言，其中一点区别似乎是现在人们有了这 14 年产出的诸多应用要维护。这让 Ruby 的趣味性大减，与全是新项目的时期不可同日而语。所以请警惕 Rust、Kotlin、Julia 和 Go：你最终也将亲手取下你为它们戴上的光环。<sup>4</sup>


---

1. 2020 年的[图形化](https://insights.stackoverflow.com/survey/2020)和[原始](https://drive.google.com/file/d/1dfGerWeWkcyQ9GX9x20rdSGj7WtEpzBB/view)结果。

2. 我最先提出这个标准。我并没有为支撑我的观点寻找数据。

	我确实考虑过用语言的诞生日来区分绿色和棕色语言，但有些语言已经存在一段时间了却只在最近才开始投入使用。

	TIOBE 度量用的是[这种方法](https://www.tiobe.com/tiobe-index/programming-languages-definition/)，而且他们的历史数据是需要付费获取的，所以我就使用了 Wayback Machine。

3. TIOBE 并未计量 HTML/CSS，因为它认为这些语言并没有向完备发展所以不是编程语言。据我所知，Shell 脚本被 TIOBE 单独归类，而 VBA 则完全不在他们计量的语言列表上。

4. 然而并不是所有的棕色语言都令人畏惧：Python、C#、Swift、JavaScript 和 SQL 依然受欢迎，如果有人能解释为什么的话，我洗耳恭听。另外，Scala 和 Haskell 这两种我喜欢的语言是令人畏惧的名单上仅有的绿色语言。这是单纯的噪声还是有其他的原因呢？

5. 译者注：**棕地项目**指需要在已有软件系统的基础上开发的项目。这就意味着开发的新软件系统必须考虑与已有软件的兼容问题。（来源：[Brownfield (software development) - Wikipedia](https://en.wikipedia.org/wiki/Brownfield_(software_development))）

6. 译者注：**绿地项目**指没有先前工作束缚的项目。在软件工程中，它可以是为一个全新的环境开发系统，不需要考虑与其他系统的兼容问题。（来源：[Greenfield project - Wikipedia](https://en.wikipedia.org/wiki/Greenfield_project)）

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

