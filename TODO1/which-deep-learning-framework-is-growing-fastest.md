> * 原文地址：[Which Deep Learning Framework is Growing Fastest?](https://towardsdatascience.com/which-deep-learning-framework-is-growing-fastest-3f77f14aa318)
> * 原文作者：[Jeff Hale](https://medium.com/@jeffhale)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/which-deep-learning-framework-is-growing-fastest.md](https://github.com/xitu/gold-miner/blob/master/TODO1/which-deep-learning-framework-is-growing-fastest.md)
> * 译者：[ccJia](https://github.com/ccJia)
> * 校对者：[luochen1992](https://github.com/luochen1992), [zhmhhu](https://github.com/zhmhhu)

# 哪一个深度学习框架增长最迅猛？TensorFlow 还是 PyTorch？

在 2018 年的 9 月，我在一篇[文章](https://towardsdatascience.com/deep-learning-framework-power-scores-2018-23607ddf297a)中，从需求量，工程使用量以及流行程度等方面对比了所有的主流深度学习框架。TensorFlow 处于绝对的王者地位，而 Pytorch 则是一位跃跃欲试的年轻挑战者。

半年过去了，这种形势是否有所改变呢？

![](https://cdn-images-1.medium.com/max/2000/1*SVgj_p1tcangWfCm2n0txg.png)

![](https://cdn-images-1.medium.com/max/2000/1*3JpBBGkLNgwRfkrDDFIQiQ.png)

为了回答这个问题，我从在线招聘网站（如：[Indeed](http://indeed.com)、[Monster](https://www.monster.com/)、[LinkedIn](https://linkedin.com) 和 [SimplyHired](https://www.simplyhired.com/)) 的职位需求、[谷歌的搜索量](https://trends.google.com/trends/explore?cat=1299&q=tensorflow,pytorch,keras,fastai)、[GitHub 活跃度](https://github.com/)、[媒体的文章数](https://medium.com)、[ArXiv 的文章数](https://arxiv.org/)以及[Quora 的粉丝数](https://www.quora.com)等几个方面的数据变化去做评估。最终，以这些数据为依据，绘制了需求量，使用率和流行程度的增长图便于读者理解。

## 集成和更新

我们发现，TensorFlow 和 PyTorch 都有一些重要的版本发布。

PyTorch 1.0 版本在 2018 年 10 月预先发布，同一时间 fastai 1.0 版本也进行了发布。这两个版本的发布是深度学习框架走向成熟的重要里程碑。

2019 年 4 月，TensorFlow 2.0 alpha 版也进行了发布。在新增了许多新特性的同时，改进了用户的体验。并且更加紧密地集成了 Keras 作为它的高级 API。

## 方法

在本文中，由于 Keras 和 fastai 与 TesnsorFlow 和 PyTorch 的依存关系，它们也可以作为一个尺度来评估 TensorFlow 和 PyTorch，所以我们将它们也囊括到了对比之中。

![](https://cdn-images-1.medium.com/max/2000/1*rRq_RWw3SLz64sMRXmtyaQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*UlKBqvcT5UNg3L5BM8ywqg.png)

至于其他的深度学习框架，我将不予讨论。很多读者肯定会觉得像 Caffe、Theano、MXNET、CNTK、DeepLearning4J 和 Chainer 这些框架是很有价值的。然而它们虽然有诸多的优点，但确实无法与 TensorFlow 和 Pytorch 相提并论，同时又和这两个框架没有什么交集。

我们的分析工作是在 2019 年 3 月 20 号到 21 号间执行的，数据源在 [谷歌的表格中](https://docs.google.com/spreadsheets/d/1Q9rQkfi8ubKM8aX33In0Ki6ldUCfJhGqiH9ir6boexw/edit?usp=sharing)。

我使用 [plotly](https://plot.ly/) 作为可视化库，更多的细节可以参考我的 [Kaggle Kernel](https://www.kaggle.com/discdiver/2019-deep-learning-framework-growth-scores)。

好，现在我们就来看看各个分类的结果如何。

## 在线职位需求的变化

我通过搜索几个主要的在线招聘网站，如，Indeed、LinkedIn、Monster 和 SimplyHired 的相关数据来判断哪一个框架是目前需求量最大的。

我使用的搜索关键字是这样的，**machine learning** ，后面跟随对应的库名。举个例子，评估 TensorFlow 我们使用的关键字就是 **machine learning TensorFlow** 。由于历史的比较原因，使用了这种关键字进行搜索。如果不加 **machine learning** 结果也不会有明显的不同。我们的搜索范围设定的是美国。

我用2019年3月的数据减去6个月之前的数据，有如下的发现：

![](https://cdn-images-1.medium.com/max/2000/1*-8jrJV4tnqGXWzwlCdlYvQ.png)

在职位列表中，TensorFlow 的增长略微高于 PyTorch。Keras 也有增长，大致是 TensorFlow 的一半。Fastai 仍然是没有什么需求量。

值得注意的是除了 LinkedIn 以外，在其他的求职网站上 PyTorch 相较于 TensorFlow 都有明显的增长。但是在绝对的数量上，TensorFlow 的职位数量接近PyTorch 或者 Keras 的 3 倍。

## 谷歌平均搜索活跃度的变化

在最大搜索引擎上的搜索次数可以作为衡量流行程度的一个指标。我在 Google Trends 上搜集了过去一年全世界范围内关于 **Machine Learning and Artificial Intelligence** 分类的搜索。不幸的是谷歌不提供绝对的数值，只能获得一组相对值。

我得到了过去 6 个月兴趣分数的均值并与半年以前的兴趣均值做比较。

![](https://cdn-images-1.medium.com/max/2000/1*-0xgPs1DzZKE3jWy9412Ew.png)

在过去 6 个月中，TensorFlow 的相关搜索量在下降，而 PyTorch 的相关搜索量在上升。

下面的图表直观的反映了过去 1 年人们的兴趣趋势。

![TensorFlow in blue; Keras in yellow, PyTorch in red, fastai in green](https://cdn-images-1.medium.com/max/2000/1*FGdwNXVzEno6N3CYBW6OLA.png)

## 媒体新增文章

新媒体是数据科学文章和教程的主要传播场所，我希望你会喜欢它。我利用 Medium.com 作为筛选项在谷歌上进行搜索，在过去的 6 个月中，TensorFlow 和 Keras 的文章发表数基本相似，而 PyTorch 的要稍微少一些。

![](https://cdn-images-1.medium.com/max/2000/1*8cuSvK4Wc5jjJDH8sPCOPw.png)

作为高级 API 的 Keras 和 fastai 在新框架的实践者中十分流行，有很多教程都是在向人们展示如何很好的使用这些新框架。

## arXiv新增文章

[arXiv](https://arxiv.org/) 是当前大多数深度学习学术论文选择发表的在线仓储。我使用谷歌搜索了过去 6 个月新发表的新论文中提到的框架，结果是  TensorFlow 遥遥领先。

![](https://cdn-images-1.medium.com/max/2000/1*HTe-PCY7rvpSAKwsEzF3lg.png)

## GitHub新增活跃度

Git 的近期活跃度是框架流行度的另一个指标。下面的图表展示了点赞、克隆、粉丝以及贡献者的数量。

![](https://cdn-images-1.medium.com/max/2000/1*83KNb93eWuSEt5MxqDow6Q.png)

TensorFlow 在各个选项上都是领先的。尽管如此，PyTorch 在关注者和贡献者方面已经十分接近 TensorFlow 了，同时 fastai 也出现了很多新的贡献者。

毫无疑问，一些 Keras 的贡献者还在努力的挖掘 TensorFlow 库。同时值得注意的是，这两个开源项目都是由谷歌的员工发起的。

## Quora的新增粉丝数

我将之前遗漏的一个参考指标 —— Quora 新话题的粉丝数量也加入进来。

![](https://cdn-images-1.medium.com/max/2000/1*TqZ_cZQkadyrPEhR3tI8qQ.png)

过去 6 个月中，绝大多数新增话题的粉丝都是围绕着 TensorFlow，而 PyTorch 和 Keras 则远远落后。

一旦我有了所有的数据，我将把它们整理成一个新的指标。

## 增长分数的计算

下面是我如何创建增长分数的:
 
 1. 将所有指标的分数缩放到 0 和 1 之间。

 2. 汇总 **在线职位** 和 **GitHub 活跃度** 等子类。

 3. 根据下面的百分比对各个分类加权。
 
![](https://cdn-images-1.medium.com/max/2000/1*T5qnFdpwsNsrDGhl_j7ujg.png)

 4. 为了方便理解，我们再将所有得分乘以 100。

 5. 将每个框架的对应分类的得分进行累加，得到最后的增长分数。

在线工作一项的权重占据了整体的三分之一，原因很简单，直接的经济利益才是最实际的。这种划分也是为了更好的平衡各个选项。区别于我的另一篇 [2018 power score analysis](https://towardsdatascience.com/deep-learning-framework-power-scores-2018-23607ddf297a) ，我没有包含 KDNuggets 的使用情况调查（没有新的数据）和出版物（过去 6 个月没有太多的新书）。

## 结果

下面是表格的形式：

![Google Sheet [here](https://docs.google.com/spreadsheets/d/1Q9rQkfi8ubKM8aX33In0Ki6ldUCfJhGqiH9ir6boexw/edit?usp=sharing).](https://cdn-images-1.medium.com/max/2832/1*iiPAyzPl7f_xfh3SnJklKg.png)

这里是各个分类的得分：

![](https://cdn-images-1.medium.com/max/3064/1*lXuEdokw-VuxZjxNKft5NA.png)

这里是最终的得分：

![](https://cdn-images-1.medium.com/max/2000/1*c67KMUJj3waIlxnUJ1enTw.png)

TensorFlow 是目前需求量最大且增长速度最快的框架，短时间内，这个局面不会发生变化。PyTorch 的增长也十分迅猛，大量的职位需求就是它需求量和使用量增长的最好证明。当然，Keras在过去的6个月也有长足的进步。最后，fastai 的增长就不那么的理想了，但是需要说明的是，它是这几个框架中最年轻的一个。
所以，TensorFlow 和 PyTorch 都是十分值得学习的框架。

## 学习建议

如果你准备学习 TensorFlow ，那么我建议你可以先从 Keras 开始。Chollet 的 [**Deep Learning with Python**](https://www.amazon.com/Deep-Learning-Python-Francois-Chollet/dp/1617294438) 和 Dan Becker 的 [DataCamp course on Keras](https://www.datacamp.com/courses/deep-learning-in-python) 是两本很好的入门教材。在 TensorFlow 2.0 中使用 Keras 作为高级 API 只需要通过 tf.keras 就可以调用。这里有一个 Chollet 写的 TensorFlow 2.0 快速入门 [教程](https://threader.app/thread/1105139360226140160)。

如果你准备学习 PyTorch，我建议可以从 fast.ai 的 MOOC 文章 [Practical Deep Learning for Coders, v3](https://course.fast.ai/) 开始。你可以学习到深度学习的原理以及 fastai、PyTorch 的基础。

那么，TensorFlow 和 PyTorch 的未来是什么呢？

## 未来的方向

我常听人说，PyTorch 比 TensorFlow 更好用。这是因为 PyTorch 有更稳定的 API 并且更贴近 Python 的用法。同时还有原生的模型转换工具 [ONNX](https://onnx.ai/supported-tools)，可以用来提高推理的速度。并且，Pytorch 共用了许多 [numpy](https://github.com/wkentaro/pytorch-for-numpy-users) 的命令，可以降低学习的门槛。

对于 TensorFlow 2.0 的所有改进都是针对于用户体验这点，谷歌的首席人工智能决策官 [Cassie Kozyrkov](undefined) 有如下的 [解释](https://hackernoon.com/tensorflow-is-dead-long-live-tensorflow-49d3e975cf04?sk=37e6842c552284444f12c71b871d3640)。TensorFlow 现在有更直观的API,更合理的 Keras 集成，以及更直接的执行选项。这些改变以及 TensorFlow 的广泛使用，都将帮助它在未来几年继续流行。

此外，TensorFlow 最近公布了一项令人激动的计划：开发针对于 [Swift的TensorFlow版本](https://www.tensorflow.org/swift)。[Swift](https://swift.org/) 最初是由苹果公司构建的编程语言。相较于 Python，Swift 在执行和开发速度上有很多的优势。fast.ai 的联合创始人 Jeremy Howard 发布的 [消息](https://www.fast.ai/2019/03/06/fastai-swift/)，fast.ai 将在部分的进阶 MOOC 中使用 [TensorFLow的Swift版本](https://www.tensorflow.org/swift)。这个语言可能在最近的一两年不会完成，但是它一定会改进现存的深度学习框架。可以看到，语言和框架之间的合作和交叉学习正在进行着。

[量子计算](https://en.wikipedia.org/wiki/Quantum_computing) 的进步也将影响深度学习框架。虽然可用的量子计算机还需要几年才能出现，但是 [Google](https://ai.google/research/teams/applied-science/quantum-ai/)、[IBM](https://www.ibm.com/blogs/research/2019/03/machine-learning-quantum-advantage/)、Microsoft 和其他的公司已经在思考如何将量子计算和深度学习结合起来了。框架需要去慢慢适应这种新的技术。

## 结语

你已经看到了 TensorFLow 和 PyTorch 的增长。它们都有很好的高级 API：tf.keras 和 fastai，它们可以降低初学者的学习门槛。你也已经看到了框架的新特性和未来方向。

如果需要使用文中的图表，可以到我的 [Kaggle Kernel](https://www.kaggle.com/discdiver/2019-deep-learning-framework-growth-scores) 中去获取相关内容。

我希望你可以从这个对比中获取帮助。如果确实有帮助，就请你把它分享到你喜欢的社交频道，这样就可以使更多的人获益。

谢谢大家浏览！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
