> * 原文地址：[The most famous data visualisation ever and what we can learn from it](https://towardsdatascience.com/the-most-famous-data-visualisation-ever-and-what-we-can-learn-from-it-abcdfa772548)
> * 原文作者：[George Seif](https://towardsdatascience.com/@george.seif94)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-most-famous-data-visualisation-ever-and-what-we-can-learn-from-it.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-most-famous-data-visualisation-ever-and-what-we-can-learn-from-it.md)
> * 译者：[AceLeeWinnie](https://github.com/AceLeeWinnie)
> * 校对者：

# 从著名数据数据可视化中我们可以学到什么

![](https://cdn-images-1.medium.com/max/1600/1*V9sq--wHI1wm1zA3Gng1sg.png)

拿破仑东征图

### 数据可视化的重要性

毋庸置疑，数据可视化是数据科学和机器学习（ML）的重要组成部分。在创建 ML 模型之前，你需要**了解**训练数据。这部分工作通常通过探索性数据分析（EDA）工具完成；对此，Kaggle 有很多很棒的[示例](https://www.kaggle.com/kernels)。

数据可视化是 EDA 的一部分，我们通过创建**视觉图形** —— 数据的一种特定描述，以便更清楚地理解数据的特征和属性。可视化数据使得这一目标更为简单，因为我们寻找的信息能够重点标注出来。可视化时常使用许多不同颜色，形状，大小和图表触发自然的可视化触感，并传递比实际数字更清晰的数据形态。

简单来说，你需要数据可视化。

### 东征图

上面的拿破仑东征图可能是最著名的数据可视化图表了。它几乎被用在你所见过的所有数据可视化课程的导论课上。

法语也许不是你的母语......但这就是这幅可视化作品的奥妙所在：你能**以图片的形式**理解一切。

### 流

可以看到画面从左到右有一个清晰的**流动**。这天然符合绝大多数语言的书写方向习惯，在阅读和理解所描述的内容提供了直观的引导。看起来拿破仑的军队行军起始于**科夫罗**，结束于莫斯科。

**位置**也用作一种视觉通道，显示了军队行进的方向。我们可以看到军队是如何从西边即左边开始向东北方向前进的。但这并不是一条完全直达的道路。

也许军队不得不绕过一些崎岖的地形或障碍，甚至是敌国的边境。不管怎样，我们可以确定他们采取了某种间接道路。

### 大小，形状和颜色

**大小**和**形状**在**量化**重要属性时也发挥着关键作用。图中左侧，一开始线条非常粗，慢慢越来越细。这是可理解的，由于士兵叛逃、战死或恶劣的天气条件（东征后期更是如此）。

在**科夫罗**和**维尔纽斯**段旅程开始的时候，一条细小、近乎垂直的分支连接着大部队。这很可能是后来的增援部队。当继续向右移动时，我们接着看到一些军队停止战斗，向**波拉茨克**进发。

**颜色**和**形状**结合起来，正如黑线一样。相比另一条线条来说，显得太细了。它确实遵循相同的流向并到达终点，但它采取的是不同的路径。也许拿破仑有一个单独的军队用来攻击侧翼。

看起来一些去**波拉茨克**的军队中途加入了这个黑色的组织!

我们也看到黑色的那一组相比另一组在人数上是逐渐增加的，可能是因为他们加入的时间较晚，天气也较好(同样，在后期更多的是这个原因)。

可以说，拿破仑有两个独立的师可供调遣，全军规模随着时间显著缩小。

### 用线条，数字和文字标注细节

在可视化中使用文字很多时候都是非常危险的，因为绘图的主要目的就是要做形象化的展示！但是此图用上文字却是正确的选择。

数字被巧妙地放置在适当的位置，进一步强化了细节，同时又不会造成混淆。如果你需要额外的细节，数字就放在代表军队的图形旁边，以便精确地量化大小。细节便于查看，但不会干扰你的视线。

地图右边的比例尺位置很好，没有造成任何视觉阻碍。河流画得很简略，以免喧宾夺主。作者似乎明白，在描绘军队行军的背景下，画这些河流的主要目的是标记位置。

可以看到最右侧的两条河流，黑色代表的军队数量壮大了！也许是经过城镇时补充了兵力。无论如何，这些河流的流向都符合描绘其地标的正确位置。

底部的线条向下画，看起来像一个垂直图。这张图表描述了整个征途的温度变化。因为它很简单，很直观，所以很容易阅读；图上越高的点意味着温度越高!

我们可以从左到右看到，温度随时间变化越来越暖和。而我们知道拿破仑东征开始于冬季，结束于春季。

### 总结：如何进行有效的可视化

(1) 直观。诉诸于人类自然的视觉理解方式。从左至右，由上至下，从小到大或从大到小。

(2) 使用最基本、最原始的视觉通道：尺寸，形状，颜色，位置。形状和位置适用于形容流动。颜色和形状适用于分组。尺寸适用于定量。这些都是一般规则。

(3) 使用文本，线条和数字强调重要细节。

(4) 标注最重要的部分，弱化无关紧要的部分。

(5) 不要过多地填满整个画面，只展示必要信息。布局尤其重要。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
