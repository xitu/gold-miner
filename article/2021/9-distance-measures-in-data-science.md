> * 原文地址：[9 Distance Measures in Data Science](https://towardsdatascience.com/9-distance-measures-in-data-science-918109d069fa)
> * 原文作者：[Maarten Grootendorst](https://medium.com/@maartengrootendorst)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/9-distance-measures-in-data-science.md](https://github.com/xitu/gold-miner/blob/master/article/2021/9-distance-measures-in-data-science.md)
> * 译者：
> * 校对者：

# 数据科学中的 9 种距离度量

![距离度量。图片由本文作者制作。](https://cdn-images-1.medium.com/max/7098/1*2J3iaDnuLhonNGvlTKthiQ.png)

不论是有监督的还是无监督的，很多算法都用到了**距离度量**。诸如欧氏距离或者余弦相似度的距离度量经常出现在 k-NN、UMAP、HDBSCAN 等算法当中。

理解距离度量可能比你想象的更加重要。以常用于监督学习的 k-NN 算法为例，它默认使用欧氏距离作为距离度量。这本身就是一种很棒的距离度量方式。

然而，如果你的数据有很高的维度，那会怎样呢？欧氏距离此时仍然能解决问题吗？或者，如果你的数据包含了地理空间信息呢？可能半正矢距离会是一个更好的选择！

> 知道什么时候用何种距离度量可以帮你把一个差劲的分类器变成一个精准的模型。

在这篇文章中，我们会介绍多种距离度量，并探讨使用它们的最佳方式和最适情景。更重要的是，我会介绍它们的不足，以便你可以认识到什么时候要避免使用某些特定算法。

**注意**：对大多数距离度量，已经有相关的长篇论文详实地介绍了它们的使用情景以及优缺点。我会努力介绍尽可能多的内容但是仍有可能不全面！所以，请把这篇文章当成这些度量方式的一篇全局概览。

## 1. 欧式距离（Euclidean Distance）

![欧式距离。图片由本文作者制作。](https://cdn-images-1.medium.com/max/2000/1*hUrrJWqXysnlF4zMbNrKVg.png)

我们从最常用的距离度量，也就是欧式距离开始。对这种距离最贴切的解释是连接两个点的直线段长度。

欧氏距离的计算公式相当直接，用两点的笛卡尔坐标根据勾股定理即可得出。

![Euclidean distance](https://cdn-images-1.medium.com/max/2000/0*wv6oFAVd0_PQ50mX)

#### 不足

即使作为一种常用的距离度量，欧氏距离也不具备缩放不变性。这就意味着计算出来的距离可能会随着单位的变化而变化。一般地，在使用距离度量前需要对数据进行**归一化**。

而且，随着数据维度的上升，欧氏距离的适用性会下降。这和维度诅咒有关，也就是高维空间的表现并不符合我们直觉上从 2 维或 3 维空间类比得出的推断。相关内容的总结可以参考[这篇问答](https://stats.stackexchange.com/questions/99171/why-is-euclidean-distance-not-a-good-metric-in-high-dimensions)。

#### 适用情景

在数据维度较低，而且向量大小的需要重点测量时，欧氏距离可以很好地工作。当欧氏距离被用于低维度数据时，像 k-NN 和 HDBSCAN 这类方法马上就能得到很好的结果。

即使人们为了弥补它的不足开发了很多种其他的距离度量，欧氏距离仍然有理由成为所有距离度量中最常用的。它完美契合我们的直觉，实现起来十分简单并且在多种使用情景中都得到了很好的结果。

## 2. 余弦相似度（Cosine Similarity）

![Cosine distance. Image by the author.](https://cdn-images-1.medium.com/max/2000/1*C7HsPWATekvZtFyPesB-BA.png)

余弦相似度经常被用作一种弥补欧氏距离在高维空间中的不足的手段。其定义就是两个向量夹角的余弦。它也等于将两个向量归一化为单位向量后的内积。

如果两个向量方向完全相同，其余弦相似度就为 1，而如果两个向量平行但方向相反，其余弦相似度就是 -1。注意，余弦相似度是对方向的度量，所以向量的长度并不重要。

![Cosine Similarity](https://cdn-images-1.medium.com/max/2000/0*WmZ-uk5VzfY7RiBt)

#### 不足

余弦相似度的一个首要缺点是忽略了向量的长度，仅仅考察其方向。实际应用中，这就意味着数值间的区别并没有被利用完全。如果以推荐系统为例，那么余弦相似度就不会考虑不同用户的评分量表。

#### 适用情境

当我们的数据维度较高而且向量的长度并不重要时，我们通常可以使用余弦相似度。在文本分析领域，当我们用单词计数作为数据时，这种度量就使用得非常频繁。例如，当一个单词在一个文档中出现得比其它文档更加频繁，这并不一定意味着这个文档与该单词更加相关。有可能在这个问题中，各个文档的长度不同，并且单词计数向量的长度并不重要。于是，忽略长度的余弦相似度就是我们最优的选择。

## 3. 汉明距离（Hamming Distance）

![Hamming distance. Image by the author.](https://cdn-images-1.medium.com/max/2000/1*J27IH7DmKuf71YP4qKo2kw.png)

汉明距离指两个向量间数值不同的位数。它最具代表性的用法是比较两个同等长度的二值字串。它也可以通过计算两个字符串间不同的字符个数来定义字符串的相似度。

#### 不足

你可能想象到了，汉明距离很难用在两个向量维度不等的情况。你需要比较同等维度的向量来发现哪些位置不同。

而且，汉明距离不考虑实际数值而只关心它们是否相等。因此，当数值大小很重要时，不推荐使用汉明距离。

#### 适用情景

在计算机网络中传输数据时的错误检测和校正是应用汉明距离的一个典型案例。它可以用于表示传输错误的比特位数从而估计误差。

并且，你也可以用汉明距离来衡量分类型变量之间的距离。

## 4. 曼哈顿距离

![Manhattan distance. Image by the author.](https://cdn-images-1.medium.com/max/2000/1*nSBd4Q8nA9zo_8iVUHa69w.png)

曼哈顿距离，通常又称出租车距离或城市街区距离，用于实值向量之间的距离计算。想象一下表示单位网格上点的向量。曼哈顿距离就表示在只能沿垂直的两个方向移动的情况下，两个向量之间的距离。在计算距离时没有任何对角线上的移动。

![Manhattan distance](https://cdn-images-1.medium.com/max/2000/0*m9AgwqgzAZsdcf-z)

#### 不足

虽然曼哈顿距离似乎可以处理[高维数据](https://www.quora.com/What-is-the-difference-between-Manhattan-and-Euclidean-distance-measures)，但这种度量方式相比于欧氏距离就稍微有些不合直觉，尤其是用于高维数据的时候。

况且，它可能给出比欧氏距离更高的数值，毕竟它测量的并不是可能的最短路径。虽然这并不一定会带来问题，但这是你必须考虑的。

#### 适用情景

当你的数据集有离散的或二值化的属性时，曼哈顿距离似乎是很合适的，因为它计量的路径是在这些属性取值范围内可以实现的。相反，欧氏距离会在两个向量间创造一条直线段，而这条直线可能无法存在。

## 5. 切比雪夫距离（Chebyshev）

![Chebyshev distance. Image by the author.](https://cdn-images-1.medium.com/max/2000/1*v7_aLyWp8fFuIZ9H0WWfjQ.png)

切比雪夫距离的定义是两个向量对应维的数据差值中的最大值。换言之，它可以简单理解为沿着坐标轴计算的最大距离。切比雪夫距离经常被称作棋盘距离，因为在国际象棋中，国王要从一格走到另一格所需的最少步数就等于切比雪夫距离。

![Chebyshev distance](https://cdn-images-1.medium.com/max/2000/0*r8SVpQTf2yjTZ0Xi)

#### 不足

切比雪夫距离基本是用于很特殊的情景，这让它很难像欧氏距离或余弦相似度一样作为通用的距离度量。因此，只有当你完全确定它适合你的问题时，才推荐使用切比雪夫距离。

#### 适用情景

前面提到过，切比雪夫距离可以用于表示国王从一格走到另一格所需的最少步数。进一步，它可以在允许八向移动的游戏中作为一个很好的度量手段。

实际中，切比雪夫距离常用于仓储物流，因为它可以很好地描述桥式吊车移动物体所需的时间。

## 6. 闵可夫斯基距离（Minkowski Distance）

![Minkowski distance. Image by the author.](https://cdn-images-1.medium.com/max/2000/1*U3CcVaKC6yJ8uU_k7oBX3g.png)

闵可夫斯基距离比大多数度量都要复杂一些。它用于赋范向量空间（n 维实空间），也就是说如果一个向量空间内的距离被表示成可计算长度的向量，那么闵可夫斯基距离就可以被用于这个空间。

这个度量方式有三点要求：

* **零向量**——零向量的长度是 0 而所有其它向量的长度都是正值。假如我们从一个地点到另一个地点，那么距离始终是正的。然而，假如我们从这个地点到它本身，那么距离就是 0。
* **数乘因子**——当你将向量乘以一个正数的时候，向量的长度变化而方向不变。比如，如果我们在某个特定方向上走了一段距离，然后再加上同样的距离，其方向是不会改变的。
* **三角不等式**——两点之间直线最短。

下面是闵可夫斯基距离的公式：

![Minkowski distance](https://cdn-images-1.medium.com/max/2000/0*UbbyH2MUPb5ZBa64)

关于这种距离度量，最有趣的是参数 $p$ 的使用。我们可以调整这个参数来将闵可夫斯基距离变成其它的距离度量。

常用的 $p$ 取值有：

* $p=1$ ——曼哈顿距离
* $p=2$ ——欧氏距离
* $p=\infin$ ——切比雪夫距离

#### 不足

闵可夫斯基距离和它所代表的距离度量有同样的不足之处，所以需要对诸如曼哈顿距离、欧氏距离和切比雪夫距离的度量方式有深入的理解，这是十分重要的。

而且，参数 $p$ 实际上可能带来一些麻烦。取决于你的使用情景，寻找正确的  $p$ 值可能会造成计算上的低效。

#### 适用情景

参数 $p$ 的优势是它可以被迭代更新从而找到最适合当前问题的距离度量。这给你的距离度量带来了相当大的自由，如果你熟悉 $p$ 和很多距离度量方式，这将是一个很大的优势。

## 7. 雅卡尔指数（Jaccard Index）

![雅卡尔指数。图片由本文作者制作。](https://cdn-images-1.medium.com/max/2000/1*RxAzLf9dRrDSVrB-ElZVEw.png)

雅卡尔系数（或者 IoU）是用于计算采样集合的相似性和差异性的度量方式。它的计算是用交集的大小除以并集的大小。

实际应用中，它代表相似实例的数量除以所有实例的总数。例如，假如两个集合有一个共同的实例，而问题中总共有 5 个不同的实例，那么雅卡尔指数就是 $1/5=0.2$。

要计算雅卡尔距离，我们直接用 1 减去雅卡尔指数即可：

![Jaccard distance](https://cdn-images-1.medium.com/max/2000/0*3fcCoSZUOxa7vzon)

#### 不足

雅卡尔指数的一个主要的缺点是受数据量大小影响严重。大数据集可以对这一指数有很大影响，因为它可以在明显增大并集的同时，保持交集基本不变。

#### 适用情景

雅卡尔指数经常用于数据是二进制或者二值化的情形。当你有一个用于图像分割的深度学习模型（例如分割汽车），利用真实可信的标注，雅卡尔系数就可以被用于计算分割的精度。

类似地，在文档相似性分析中，它可以计量文档之间有多少单词的选择是重合的。因此，它可以用于模式集合的比较。

## 8. 半正矢距离（Haversine）

![半正矢距离。图片由作者制作](https://cdn-images-1.medium.com/max/2000/1*c6YJw_Cv8u3O42CaAOrLRw.png)

半正矢距离指根据球面上两点的经纬度计算出的距离。它计算的是两点的最短路径长度，这一点和欧氏距离很相似。主要的区别是两点在球面上，不可能有直线路径。

![Haversine distance between two points](https://cdn-images-1.medium.com/max/2196/0*ZZCAEu9KsHOfl0Kr)

#### 不足

这种距离度量的其中一个不足是它假设两点都在**球面**上。实际上很少有这种情况，比如地球就不是完美的球体，这就让一些情形下的计算变得十分困难。作为代替，你可以看看 **Vincenty 距离**，它假设的载体是椭球面而不是球面。

#### 适用范围

你可能已经意识到了，半正矢距离经常被用于导航。例如，你可以用它计算两国之间的航班飞行距离。注意，如果两点本身的距离并不远，半正矢距离就不是很合适了。路径的弯曲将不会有很大的影响。

## 9. Sørensen-Dice 指数

![Sørensen–Dice coefficient. Image by the author.](https://cdn-images-1.medium.com/max/2000/1*-pA7yjdXoLepVh3nB-LC4g.png)

Sørensen-Dice 指数和雅卡尔系数很相似，它也可以衡量采样集合之间的相似性和差异性。即使他们的计算方式很相似，Sørensen-Dice 指数也要比雅卡尔系数更符合直觉一些，因为它可以被视为两个集合重合的比率，数值在 0 到 1 之间：

（这句不完整，而且原文没有这一句，所以删掉）

（来自 Jaccard Index 这一部分，应当删去）

（来自 Jaccard Index 这一部分，应当删去）

（来自 Jaccard Index 这一部分，应当删去）

![Sørensen–Dice coefficient](https://cdn-images-1.medium.com/max/2000/0*N5xU3llTz-MKt9E8)

#### 不足

类似于雅卡尔指数，它们都过分强调了那些只包含很少真值或者没有真值的集合的重要性。结果就是这种集合会主导多个集合的平均分数。这种度量方式为集合赋予的权重与集合的大小成反比，而不是将权重均等划分。

#### 适用情景

Sørensen-Dice 指数的适用情景和雅卡尔指数非常类似。它通常用于图像分割任务或者文本相似性分析。

**注意**：距离度量的种类远比上面提到的 9 种要多。如果你想了解更多有趣的度量方式，我建议你在下面这些度量方式中选一个调查一下：马氏距离（Mahalanobis）、堪培拉距离（Canberra）、Bray-Curtis 距离和相对熵（KL-divergence）。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
