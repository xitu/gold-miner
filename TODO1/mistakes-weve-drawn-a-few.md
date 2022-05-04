> * 原文地址：[Mistakes, we’ve drawn a few](https://medium.economist.com/mistakes-weve-drawn-a-few-8cdd8a42d368)
> * 原文作者：[Sarah Leo](https://medium.com/@sarahleo_59097)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mistakes-weve-drawn-a-few.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mistakes-weve-drawn-a-few.md)
> * 译者：[ccJia](https://github.com/ccJia)
> * 校对者：[Charlo-O](https://github.com/Charlo-O), [cyz980908](https://github.com/cyz980908)

# 在数据可视化中，我们曾经“画”下的那些败笔

> 从败笔中学习数据可视化

在**经济学人**，我们会很认真的对待数据可视化。我们每周都会通过印刷品、网站或者应用程序发布大概 40 张图表。对于每一个图表，我们都尽可能的让它更精确从而最好的支撑我们所要描述的主题。但有的时候我们也会犯错。如果我们从这些错误中吸取教训，我们在未来可以做的更好，同时其他人也可以从中学到一些东西。

通过深挖我们的档案，我发现了一些有学习价值的例子。我对它们进行了如下三类分组：（1）误导性，（2）混淆性和（3）没能说明问题的图表。对于每一个错误分类，我都提供了一个占用空间类似的改进版本，空间的占用量在印刷版发行时是一个很重要的考量因素。

**（简短的免责声明：大多数“原始”图表是在重新设计图表之前发布的。绘制改进的图表以符合我们的新规范。数据是一样的。）**

***

## 误导性的图表

让我们从数据可视化中最糟糕的罪行开始：以误导的方式展示数据。我们**从来不会**故意的去这么做！但是它确实经常性的在发生。让我们来看以下三个来自我们案例的实例。
> **错误：截断比例**

![A bit left-field](https://cdn-images-1.medium.com/max/2560/1*9QE_yL3boSLqopJkSBfL5A.png)

[这张图表](https://www.economist.com/britain/2016/08/13/the-metamorphosis)为了展示左翼政党帖子在 Facebook 上的平均点赞数。图表的目是为了体现 Corbyn 先生的帖子和其他人的差距。

原始的图表不仅低估了 CorByn 先生帖子的点赞人数，而还且夸大了其他人帖子的点赞人数。在重新设计的版本中，我们在完整的展示 CorByn 先生的直方图的同时其他人的直方图也依旧可见。**（对这个博客有兴趣的粉丝可以看到这个错误的[另一个例子](https://medium.economist.com/the-challenges-of-charting-regional-inequality-a9376718348)。）**

另一个比较奇怪的事情是颜色的选择。为了模仿工党的配色方案，我们使用了三种暗色的橘色/红色色调来区别 Jeremy Corbyn 和其他的国会、政党/团体。我们没有解释这个。这些颜色背后的含义对大多数读者来讲是显而易见的，但是对于那些不熟悉英国政治的读者来讲就没有什么意义了。

[**下载图表数据**](http://infographics.economist.com/databank/Economist_corbyn.csv)

> **错误：通过精选的尺度来强调一组关系**

![**A rare perfect correlation? Not really.**](https://cdn-images-1.medium.com/max/2560/1*H21mduPmvzot3oaMThNfFQ.png)

上面的图表描述的是与[狗体重下降相关案例](https://www.economist.com/britain/2016/08/13/subwoofers)。乍一看，狗的体重和脖子的尺寸是强相关的。但这是事实吗？应该只是在某种程度上相关。

在原始图表中，两个尺度都下降了 3 个单位（左边的从 21 到 18，右边的从 45 到 42）。按百分比计算，左边的尺度下降了 14%，右边的尺度降低了 7%。在重新设计的图表中，我保留了两个尺度，但是我调整了变化的范围，使得结果可以更好反映一个有比较性的比例变化。

考虑到这个娱乐性质的主题，这个错误就没有那么严重。毕竟，两个版本图表所使用的信息是一致的。但是，值得一提的是：如果两组数据紧密相关，那么仔细的考虑一下尺度的选择是个不错的主意。

[**下载图表数据**](http://infographics.economist.com/databank/Economist_dogs.csv)

> **错误：选择了错误的可视化方法**

![**Views on Brexit almost as erratic as its negotiations**](https://cdn-images-1.medium.com/max/2560/1*9GzHVtm4y_LeVmFCjqV3Ww.png)

我们在自己的每日新闻程序 Espresso 上发布了这个投票结果表。它使用折线图的方式来展示人们对欧盟公投结果的态度。通过这组数据，受访者对于公投结果的看法是很不稳定的，随着时间的推移一直在上下浮动。

我们没有使用散点加一条平滑的曲线来展示趋势，而是连接了每一个受访者的结果。这很可能是我们内部的工具没有提供绘制平滑曲线的功能所造成的。直到最近，我们仍然没有习惯使用提供更多复杂可视化工具的统计学软件（比如 R）。其实，现今我们所有人都能够绘制一个投票图，就像上面重新设计的那样。

怎么去截断尺度是这个图表中另一个需要注意的问题。原始图表中数据的显示范围被扩展的超出了数据应有的范围。在重设计的图表中，我在尺度的起始点和最小数据点之间预留了一部分空间。[Francis Gagnon](https://www.chezvoila.com/blog/yaxis) 的博客中对此总结了一个公式：对于不从零点起始的折线图表中，至少预留 33% 的区域。

[**下载图表数据**](http://infographics.economist.com/databank/Economist_brexit.csv)

***

## 混乱的图表

难懂的图表不像误导性的图表那么有危害，但是也代表这个图表是一个很糟糕的可视化工作。
> **错误：思维太过发散**

![… what?](https://cdn-images-1.medium.com/max/2560/1*Ilu1H37M1soUh1GHhDa_IA.png)

在**经济学人**，我们鼓励去制造一些具有发散性思维的新闻。但是，有时我们做的太过了。[上表](https://www.economist.com/briefing/2017/01/21/peter-navarro-is-about-to-become-one-of-the-worlds-most-powerful-economists)展示了美国货物贸易逆差和工厂雇佣员工数量的关系。

这个图表是令人发指的难以理解。它有两个主要问题。首先，贸易逆差的全部数据都是负值，而工厂雇佣人数全部是正值。在没有将两组数据归一化到同一尺度的情况下，将他们组合到一张表中表达是不合适的。这种直白的处理方式导致了第二个问题：两组数据没有共享同一个基线。贸易逆差的基线是图表顶部左半段的红线，而右边尺度的基线又在图表的底部。

其实将两组数据组合在一张表中是没有必要的，在我们重新设计的图表中，贸易逆差和工厂雇佣人数之间的关系更为清晰，仅仅是多占据了很小的一点额外空间。

[**下载图表数据**](http://infographics.economist.com/databank/Economist_us-trade-manufacturing.csv)

> **错误：混乱的使用颜色**

![50 Shades of Blue](https://cdn-images-1.medium.com/max/2560/1*4RND--Bo31DVfiziaa-HBA.png)

[该图表](https://www.economist.com/the-americas/2017/02/25/reducing-brazils-pension-burden)对比了选定国家 65 岁以上人口比例和政府养老金支持的关系，重点关注了巴西。为了使图表更小，图中只标注了选中的国家并且用铁蓝色高亮了这些国家，用淡蓝色高亮了 OECD 的均值。

这个可视化者（我！）忽视了这样一个事实，颜色的变化意味着种类的变化。乍一看，这个图表也是如此，所有的铁蓝色似乎是属于深蓝色的不同分组。但这不是我想要表达的事实，他们唯一的共同点只是他们被标记了。

在重新设计的版本中，所有国家的颜色没有变化。我改变了没有标记国家的透明度从而凸显那些标记了的国家。然后我对字体进行了调整，用粗体字来强调我们关注的巴西，用斜体字来标注 OECD。

[**下载图表数据**](http://infographics.economist.com/databank/Economist_pensions.csv)

***

## 观点模糊的图表

最后的这一类错误不是特别明显。像这样的图表没有误导性也不会令人困惑。它们只是没有很好的证明自己存在的意义 —— 通常是因为不正确的表现或者想在很小的空间里体现很多的信息所导致的。
> **错误：包含太多的细节**

![**“The more colours the better!” — No good data visualiser, ever**](https://cdn-images-1.medium.com/max/2560/1*GB8vGeGzMeueEbkpGTTZVQ.png)

多么的色彩斑斓！我们在德国预算盈余的专栏中公布了这个[图表](https://www.economist.com/finance-and-economics/2016/09/03/more-spend-less-thrift)。它显示了 10 个欧元区国家的预算余额和现金账户余额。图标中使用了很多种颜色，再加上本身数值很小导致大量的数据非常难以区分，想通过这样的图表来传达信息是不可能的。它几乎就是让你在大雾中摸索前进。而且，更重要的是，我们之所以没有绘制全所有欧元区国家的数据，是因为这样的堆叠数据没有任何意义。

 我们重温这个案例是为了看看有没有其他方式来简化这个表格。图表的列提到了德国、希腊、荷兰、西班牙和剩下的几个国家。在重新设计的版本中，我们决定只突出这些。为了解决仅堆叠一些国家的问题，我另外添加了一个包括所有其他欧元区国家类目（“其他”）。**（重新设计的图标中，现金账户余额低于原始图表是因为我们使用了欧盟统计局的修订数据。）**

[**下载图表数据**](http://infographics.economist.com/databank/Economist_eu-balance.csv)

> **错误：大量的数据，狭小的空间**

![**I give up.**](https://cdn-images-1.medium.com/max/2560/1*7GJIxnYsyFSGgQV537Ittg.png)

由于空间的限制，我们经常性的把数据强行塞到一个很小的细条上。虽然节省了空间，但是也会有像这个[图表（来自 2017 年 3 月）](https://www.economist.com/science-and-technology/2017/03/11/science-remains-male-dominated)一样的后果。这个案例展示了科学刊物是由男性主导的现象。所有的数据都同样的意义并且和主题相关。但是这么多的数据（包含了四个研究领域以及发明人）是很难在这里展示出来的。

在深思熟虑之后，我决定还是不要重新设计这个图表了。如果我保存了所有的数据，那么图表会很臃肿从而没法简洁的表达主题。在这种情况下，最好的方式是砍掉一部分数据。比如，我们可以展示一个测量均值，或者使用所有领域的女性出版物的平均值来代替。**（如果你可以在这个狭小的空间上做的更好！那么请告诉我，我很乐意知道你的想法。）**

[**下载图表数据**](http://infographics.economist.com/databank/Economist_women-research.csv)

***

数据可视化的最佳实现方法正在快速发展：那些今天有效的方法，明天不一定有效。每时每刻都有新的技术涌现出来。你有没有犯过一些很容易被修整的错误？快来告诉我们！

**经济学人数据可视化记者 Sarah Leo**.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
