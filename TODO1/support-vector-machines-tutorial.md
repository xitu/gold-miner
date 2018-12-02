> * 原文地址：[Support Vector Machine (SVM) Tutorial](https://blog.statsbot.co/support-vector-machines-tutorial-c1618e635e93)
> * 原文作者：[Abhishek Ghose](https://blog.statsbot.co/@AbhishekGhose?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/support-vector-machines-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/support-vector-machines-tutorial.md)
> * 译者：[zhmhhu](https://github.com/zhmhhu)
> * 校对者：

# 支持向量机（SVM） 教程

## 从例子中学习 SVM

![](https://cdn-images-1.medium.com/max/2000/1*Z3Ymb1e3sjDJr-6h0s4TwQ.jpeg)

在 [Statsbot](http://statsbot.co?utm_source=blog&utm_medium=article&utm_campaign=svm) 团队发布关于[时间序列异常检测](https://blog.statsbot.co/time-series-anomaly-detection-algorithms-1cef5519aef2)的帖子之后，许多读者要求我们告诉他们有关支持向量机的方法。 现在是时候在不涉及复杂数学知识的情况下向您介绍SVM，并分享有用的库和资源以帮助您入门了。

* * *

如果您已经使用机器学习来执行分类，您可能听说过**支持向量机（SVM）**。 50多年前被引入，它们随着时间的推移而发展，并且已经适应了各种其他问题，如**回归分析、异常值分析**和**排名**。

SVM 是许多机器学习从业者的最佳工具。 在[ [24]7](https://www.247-inc.com/)，我们也使用它们来解决各种问题。

在这篇文章中，我们将尝试深入了解 SVM 的工作原理。我会专注于建立直觉而并不追求严谨。这基本上意味着我们将尽可能多地跳过数学并建立起出对工作原理的强烈直觉。

### 分类问题

假设您的大学提供机器学习（ML）课程。课程导师观察到，如果学生擅长数学或统计学，他们将获得最大的收益。随着时间的推移，他们记录了这些科目的入学学生的分数。此外，对于其中的每一个学生，他们都有一个描述他们在 ML 课程中表现“好”或“坏”的标签。

现在，他们想要确定数学和统计学分数与 ML 课程中的表现之间的关系。也许，根据他们发现的内容，他们希望指定入学课程的先决条件。

情况会怎么样呢？ 让我们从表示他们拥有的数据开始。我们可以绘制一个二维图，其中一个轴代表数学分数，而另一个代表统计分数。 具有特定分数的学生在图表上显示为一个点。

点的颜色——绿色或红色——代表他在 ML 课程中的表现：分别为“好”或“坏”。

绘出来的图有可能是这样的：

![](https://cdn-images-1.medium.com/max/800/0*Jd9M5GLoD2qHsCEz.)

当学生要求报名时，我们的教师会要求她提供她的数学和统计学分数。根据他们已有的数据，他们会对 ML 课程中的表现做出明智的猜测。

我们本质上想要的是某种“算法”，你可以在其中输入表格的“得分元组” **（math_score，stats_score）**。它会告诉你某个学生是图形上的红点还是绿点（红色/绿色也可称为**类**或**标签**）。当然，该算法以某种方式体现了我们已经拥有的数据中存在的模式，也称为**训练数据**。

在这种情况下，找到穿过红点即和绿点集之间的直线，然后确定得分元组落在该线的哪一侧，是一个很好的算法。 我们采取一方——绿色方面或红色方面——作为她在课程中最有可能表现的一个指标。

![](https://cdn-images-1.medium.com/max/1000/1*Z7Pb5_KhQkqoQkoqjLC-Rg.jpeg)

这里的直线就是我们的**分离边界(separating boundary）**（因为它分隔了标签）或**分类器**（我们用它来对点进行分类）。该图显示了问题的两种可能的分类器。

### 好的 vs 坏的分类器

这是一个有趣的问题：上面的两条线将红色和绿色的数据集分开。我们是否有充分的理由选择其中一个而不是另一个？

请记住，分类器的价值不在于它如何区分训练数据。我们最终希望它对尚未看到的数据点进行分类（称为**测试数据**）。鉴于此，我们希望选择一条线来捕获训练数据中的**基本模式**，因此很有可能它在测试数据上表现良好。

上面的第一条直线看起来有点“倾斜”。在它的下半部分附近，它似乎太靠近红点色数据集了，而在它的上半部分它太靠近绿色数据集了。当然，它可以完美地分离训练数据，但是如果测试点离数据集稍远一点，那么它很可能会得到一个错误的标签。

第二条直线没有这个问题。例如，看看下图中已正方形显示的测试点以及分类器指定的标签。

![](https://cdn-images-1.medium.com/max/1000/1*gYZ1orikXka5H9zOko8Iwg.jpeg)

第二条直线尽可能远离两个数据集，同时使训练数据正确分离。它通过两个数据集的中间，它不那么“冒险”，可以为每个类提供一些空间来布置数据分布，从而很好地概括了测试数据。

SVM 试图找到这第二种线。我们通过视觉选择了更好的分类器，但我们需要更精确地定义基础原理以便在一般情况下应用它。这是 SVM 的简化版本：

1.找到能够正确分类训练数据的直线
2.在所有这些直线中，选择与它最近的点距离最远的直线。

距离这条直线的最近那些点称为**支持向量（support vectors）**。他们围绕这条线定义的区域称为**边距（margin）** 。

下面显示的是第二天直线的支持向量：带有黑色边缘的点（有两个）和边距（阴影区域）。

![](https://cdn-images-1.medium.com/max/800/1*csqbt5-K4GVi4i4Lrcx_eA.png)

支持向量机为您提供了一种在许多可能的分类器之间进行选择的方法，以确保以更高的正确率标记测试数据。这种说法很简洁吧？

虽然上图显示了在二维空间中的直线和数据，但必须注意 SVM 在任意数量的维度上都可以运行; 在这些维度中，他们找到了二维直线的类比。

例如，在三维空间中，他们寻找**平面（plane）**（我们将很快看到这个例子），并且在更高的维度中，他们寻找**超平面（hyperplane）** ——二维直线和三维平面到任意数量的维度的推广。

可由直线（或通常为超平面）分隔的数据称为 **线性可分（linearly separaterable）** 数据。 超平面充当**线性分类器（linear classifier）**。

### 容错

我们在最后一节中查看了完全线性可分离数据的简单情况。 然而，真实世界的数据通常是混乱的。你几乎总会遇到一些线性分类器无法正确分隔的实例。

以下是此类数据的示例：

![](https://cdn-images-1.medium.com/max/800/0*LOhi9HK-AzwZlh1q.)

显然，如果我们使用线性分类器，我们永远无法完全分离标签。我们也不想完全抛弃线性分类器，因为除了一些错误的点之外，它看起来似乎很适合这个问题。

SVM 如何处理这个问题？ 它们允许您指定您愿意接受的错误数量。

您可以为 SVM 提供一个名为“C”的参数; 这允许你决定以下两者之间的权衡：

1.有很大的边距。
2.正确分类**训练**数据。较高的C值意味着您希望训练数据上的错误较少。

值得重申的是，这是一个**折中（tradeoff）** 办法。 您可以在**代价（expense）范围内为训练数据选择更好地分类器。

下面的图显示了当我们增加 C 的值时，分类器和边距是如何变化的（支持向量未显示）：

![](https://cdn-images-1.medium.com/max/800/0*-_oXIrD3FQUA4YpW.)

注意当我们增加 C 的值时，直线如何“倾斜”。在高值时，它会尝试容纳图表右下方存在的大多数红点。 这可能不是我们想要的测试数据。 C = 0.01的第一个图似乎更好地捕捉了总体趋势，尽管与 较高 C 值的结果相比，训练数据的准确度较低。

> **由于这是一个折中办法，请注意当我们增加 C 的值时，边距的宽度会缩小**

在前面的例子中，边距是数据点的“无人之地”。在这里，我们看到不可能有这一一种状况，既有一个良好的分离边界，又在边距中不存在任何点。一些点进入到了边距里面。

一个重要的实际问题是为 C 确定一个好的值。由于现实世界的数据几乎从不可分离，因此这种需求经常出现。 我们通常使用像**交叉验证（cross-validation）这样的技术为 C 选择一个好的值。

### 非线性可分离数据

我们已经看到支持向量机如何系统地处理完美/几乎线性可分离的数据。它如何处理绝对不可线性分离的数据的情况呢？毕竟，很多现实世界的数据属于这一类。当然，寻找超平面已不再适用。鉴于 SVM 在这项任务上表现出色，这似乎很不幸。

以下是非线性可分数据的示例（这是着名的 [XOR 数据集](http://www.ece.utep.edu/research/webfuzzy/docs/kk-thesis/kk-thesis-html/node19.html)的变体），与线性分类器 SVM 一起显示：

![](https://cdn-images-1.medium.com/max/800/0*P0ZmbVFYDZZIZ0cg.)

你一定会认为这看起来不太好。我们对训练数据的准确率只有75％ ——这是用一条直线分隔的最好结果。更重要的是，这条直线非常靠近一些数据。最好的准确度也并不是很好，而且为了达到平衡，这条线几乎跨越了几个点。

我们需要做得更好

这是我最喜欢的关于 SVM 的内容。这是我们到目前为止所拥有的：我们有一种非常擅长寻找超平面的技术。但是，我们也有不可线性分离的数据。那么我们该怎么办？将数据投影到一个**可以**线性分离的空间，并在这个空间中找到一个超平面！

我将一步一步地讲解这个想法。

我们从上图中的数据集开始，并将其投影到三维空间中，其中新坐标为：

![](https://cdn-images-1.medium.com/max/800/0*PvZxA_odLsawXG1u.)

这就是投影数据的样子。你看到我们可以在平面上滑动的平面吗？

![](https://cdn-images-1.medium.com/max/800/0*_8gKP1fgfOa7JLxO.)

让我们运行SVM吧：

![](https://cdn-images-1.medium.com/max/800/0*Ojchw_Exefs4qiok.)

好啦！我们完美地将标签分离！让我们将平面投射回原始的二维空间，看看分离边界是什么样的：

![](https://cdn-images-1.medium.com/max/800/1*PO7m4cZeP7p96gOJK3WDTQ.png)

训练数据有100％的准确度**和**一个不太靠近数据的分离边界！好极了！

原始空间中分离边界的形状取决于投影。 在投影空间中，这**往往**是一个超平面。

> **请记住，投影数据的主要目的是使用 SVM 的超平面查找超大规模数据**。

将其映射回原始空间时，分离边界不再是直线。对于边距和支持向量也是如此。 就我们的视觉直觉而言，它们在投射空间中是有意义的。

看看它们在投影空间中的样子，然后是原始空间。 3D 边距是分离超平面上方和下方的平面之间的区域（没有阴影以避免视觉混乱）。

![](https://cdn-images-1.medium.com/max/800/1*qYg3y4_Qaj00U7sMU_XlaQ.gif)

在投影空间中有 4 个支持向量，这似乎是合理的。它们位于定义边距的两个平面上。在原始空间中，它们仍然处在边距上，但到这一步似乎还不够。

让我们退一步分析发生的事情：

#### 1.我怎么知道将数据投射到哪个空间？

看起来我是完全具体的 - 那里有一个2的平方根！

在这种情况下，我想展示更高维度的投影是如何工作的，所以我选择了一个非常具体的投影。一般来说，这一点是很难知道的。然而，我们所知道的是，由于[Cover定理](https://en.wikipedia.org/wiki/Cover%27s_theorem)，当投影到更高维度时，数据更**可能**是线性可分的。

在实践中，我们尝试一些高维投影，看看哪些有效。实际上，我们可以将数据投影到**无限**维度，并且通常效果还不错。这值得详细讨论，也就是下一节的内容。

#### 2. 我应该首先投影数据，然后运行 SVM 吗？

不。为了使上面的例子易于掌握，我的做法看起来好像我们需要首先投影数据。 事实上，你要求 SVM 为你进行投影。 这有一些好处。 首先，SVM 使用一些名为**核函数（kernel）** 的东西进行这些投影，这些投影非常快（我们很快就会看到）。

另外，还记得我在前一节提到的投射到无限维度吗？ 如果你自己投影数据，你如何表示或存储无限维度？事实证明，SVM 对此非常聪明，再次提到了核函数。

现在是时候来看看核函数了。

### 核函数

最后，让 SVM 有效工作是有秘诀的。这也是我们需要学习数学知识的地方。

让我们来看看到目前为止我们所看到的情况：

1. 对于线性可分的数据，SVM 表现得非常好。
2. 对于几乎可线性分离的数据，通过使用正确的 C 值，SVM 仍然可以很好地运行。
3. 对于不能线性分离的数据，我们可以将数据投影到完全/几乎可线性分离的空间，从而将问题降至第1步或第2步，我们又重新开始处理数据。

看起来，将 SVM 普遍适用与各种情况的一件重要操作是是将它投射到更高的维度。这就是核函数的用处。

首先，略有离题。

SVM 的一个非常令人惊讶的方面是，在它使用的所有数学运算中，精确投影，甚至维数的数量都没有显示出来。你可以根据各种数据点之间的**点积（dot products）**（表示为向量）来表达所有内容。对于**p**维向量的**i**和**j**，其中维度上的第一个下标标识点，第二个下标表示维度编号：

![](https://cdn-images-1.medium.com/max/800/0*Tt3zlDQhIpCro8Wa.)

点积是这样定义的:

![](https://cdn-images-1.medium.com/max/800/0*CKlEmrYPIEHqlq_G.)

如果我们的数据集中有**n**个点，则 SVM **仅仅**需要每对点的点积来找到分类器。仅此而已。当我们想要将数据投影到更高维度时，也是如此。我们不需要为 SVM 提供精确的投影; 我们需要在投影空间中的所有点对之间给出点积。

这是相关的，因为这正是核函数所做的。 核函数（**kernel function**的缩写）在原始空间中将两个点作为输入，并直接在投影空间中给出点积。

让我们重新审视之前做过的投影，看看我们是否可以提出相应的核函数。我们还将跟踪我们需要为投影执行的计算次数，然后找到点积——看看如何使用核函数进行比较。

对于点**i**：

![](https://cdn-images-1.medium.com/max/800/0*tDDv9tNvHFA9pFt9.)

我们相应的投影点是：

![](https://cdn-images-1.medium.com/max/800/0*hJHzdWhxKIJIUYcG.)

要计算此投影，我们需要执行以下操作：

*  获得新的第一维数据：1 次乘积
*  第二维数据：1 次乘积
*  第三维数据：2 次乘积

总共，1+1+2 = **4 次乘积**。

新维度中的点积是：

![](https://cdn-images-1.medium.com/max/800/0*J14DWk3PnCax_3DH.)

要计算两个点**i**和**j**的点积，我们需要先计算它们的投影。因此，4 + 4 = 8 次乘积，然后点积本身需要3次乘法和2次加法。

总之，就是：

*   乘积: 8 (投影) + 3 (点积) = 11 次乘积
*   加法: 2 (点积)

总工室 11 + 2 = **13 次运算**.

我声明这个核函数的结果是一样的：

![](https://cdn-images-1.medium.com/max/800/0*w0ZM62E9CCizAKZw.)

我们在原始**第一**空间中取矢量的点积，然后对结果进行平方运算。

Let expand it out and check whether my claim is indeed true:

![](https://cdn-images-1.medium.com/max/800/0*YfCqANgzKT_4vOYW.)

It is. How many operations does this need? Look at step (2) above. To compute the dot product in two dimensions I need 2 multiplications and 1 addition. Squaring it is another multiplication.

So, in all:

*   Multiplications: 2 (for the dot product in the original space) + 1 (for squaring the result) = 3 multiplications
*   Additions: 1 (for the dot product in the original space)

A total of 3 + 1 = **4 operations.** This is only **31% of the operations** we needed before.

It looks like it is faster to use a kernel function to compute the dot products we need. It might not seem like a big deal here: we’re looking at 4 vs 13 operations, but with input points with a lot more dimensions, and with the projected space having an even higher number of dimensions, the computational savings for a large dataset add up incredibly fast. So that’s one huge advantage of using kernels.

Most SVM libraries already come pre-packaged with some popular kernels like _Polynomial, Radial Basis Function (RBF)_, and _Sigmoid_. When we don’t use a projection (as in our first example in this article), we compute the dot products in the original space — this we refer to as using the _linear kernel_.

Many of these kernels give you additional levers to further tune it for your data. For example, the polynomial kernel:

![](https://cdn-images-1.medium.com/max/800/0*oec3aJvor3nt1h3i.)

allows you to pick the value of _c_ and _d_ (the degree of the polynomial). For the 3D projection above, I had used a polynomial kernel with _c=0_ and _d=2_.

But we are not done with the awesomeness of kernels yet!

Remember I mentioned projecting to infinite dimensions a while back? If you haven’t already guessed, the way to make it work is to have the right kernel function. That way, we really don’t have to project the input data, or worry about storing infinite dimensions.

> _A kernel function computes what the dot product would be if you had actually projected the data._

The RBF kernel is commonly used for a _specific_ infinite-dimensional projection. We won’t go into the math of it here, but look at the references at the end of this article.

How can we have infinite dimensions, but can still compute the dot product? If you find this question confusing, think about how we compute sums of infinite series. This is similar. There are infinite terms in the dot product, but there happens to exist a formula to calculate their sum.

This answers the questions we had asked in the previous section. Let’s summarize:

1.  We typically don’t define a specific projection for our data. Instead, we pick from available kernels, tweaking them in some cases, to find one best suited to the data.
2.  Of course, nothing stops us from defining our own kernels, or performing the projection ourselves, but in many cases we don’t need to. Or we at least start by trying out what’s already available.
3.  If there is a kernel available for the projection we want, we prefer to use the kernel, because that’s often faster.
4.  RBF kernels can project points to infinite dimensions.

### SVM libraries to get started

There are quite a few SVM libraries you could start practicing with:  
• [libSVM  
](https://www.csie.ntu.edu.tw/~cjlin/libsvm/)• [SVM-Light](http://svmlight.joachims.org/)  
• [SVMTorch](http://bengio.abracadoudou.com/SVMTorch.html)

Many general ML libraries like [scikit-learn](http://scikit-learn.org/stable/) also offer SVM modules, which are often wrappers around dedicated SVM libraries. My recommendation is to start out with the tried and tested [_libSVM_](https://www.csie.ntu.edu.tw/~cjlin/libsvm/).

libSVM is available as a commandline tool, but the download also bundles Python, Java, and Matlab wrappers. As long as you have a file with your data in a format libSVM understands (the README that’s part of the download explains this, along with other available options) you are good to go.

In fact, if you need a _really quick_ feel of how different kernels, the value of C, etc., influence finding the separating boundary, try out the “Graphical Interface” on their [home page](https://www.csie.ntu.edu.tw/~cjlin/libsvm/). Mark your points for different classes, pick the SVM parameters, and hit Run!

I couldn’t resist and quickly marked a few points:

![](https://cdn-images-1.medium.com/max/800/0*DsXxpsNZE_1_iPlp.)

Yep, I’m not making it easy for the SVM.

Then I tried out a couple of kernels:

![](https://cdn-images-1.medium.com/max/800/1*xwoC4Nrk_nqScuJKoDN1Ug.jpeg)

The interface doesn’t show you the separating boundary, but shows you the regions that the SVM learns as belonging to a specific label. As you can see, the linear kernel completely ignores the red points. It thinks of the whole space as yellow (-ish green). But the RBF kernel neatly carves out a ring for the red label!

### Helpful resources

We have been primarily relying on visual intuitions here. While that’s a great way to gain an initial understanding, I’d strongly encourage you to dig deeper. An example of where visual intuition might prove to be insufficient is in understanding margin width and support vectors for non-linearly separable cases.

> _Remember that these quantities are decided by optimizing a trade-off_. _Unless you look at the math, some of the results may seem counter-intuitive._

Another area where getting to know the math helps is in understanding kernel functions. Consider the RBF kernel, which I’ve barely introduced in this short article. I hope the “mystique” surrounding it — its relation to an infinite-dimensional projection coupled with the fantastic results on the last dataset (the “ring”) — has convinced you to take a closer look at it.

**Resources I would recommend:**

1.  [Video Lectures: Learning from Data](https://www.youtube.com/watch?v=MEG35RDD7RA&list=PLCA2C1469EA777F9A) by Yaser Abu-Mostafa. Lectures from 14 to 16 talk about SVMs and kernels. I’d also highly recommend the whole series if you’re looking for an introduction to ML, it maintains an excellent balance between math and intuition.
2.  [Book: The Elements of Statistical Learning](http://web.stanford.edu/~hastie/ElemStatLearn/printings/ESLII_print12.pdf) — Trevor Hastie, Robert Tibshirani, Jerome Friedman.Chapter 4 introduces the basic idea behind SVMs, while Chapter 12 deals with it comprehensively.

Happy (Machine) Learning!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
