> * 原文地址：[Why Is My Data Drifting?](https://medium.com/data-from-the-trenches/why-is-my-data-drifting-a8ecc74920a5)
> * 原文作者：[Simona Maggio](https://medium.com/@maggio.simona)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/why-is-my-data-drifting.md](https://github.com/xitu/gold-miner/blob/master/article/2020/why-is-my-data-drifting.md)
> * 译者：[chzh9311](https://github.com/chzh9311)
> * 校对者：[samyu2000](https://github.com/samyu2000)

# 为什么我的数据会漂移？

应用于实际项目的机器学习（ML）模型通常都配置了检测数据漂移的系统。MLOps 系统就是其中之一，它可以在检测到漂移时发出警报，但是我们还需要知道数据中哪些部分改变了，以及模型发生了什么样的异常，以此来决定后续策略。

这篇文章介绍了如何应用域判别分类器来识别极端异常的特征和样本，并且演示了如何使用 SHAP 来进行数据损坏情况的分析。

![异常的落叶 (由[Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral) 的摄影师 [Jeremy Thomas](https://unsplash.com/@jeremythomasphoto?utm_source=medium&utm_medium=referral 拍摄 )](https://cdn-images-1.medium.com/max/10368/0*NRGXc4k1hPb5d4jw)

## 一个数据损坏的情景

导致得到的数据出现异常的因素有很多：有噪声的数据采集、性能较差的传感器、数据中毒攻击等等。这些数据损坏的例子是协方差漂移的一种，用于分析特征分布的漂移检测器可以有效捕获这种漂移。欲复习数据漂移的相关内容，可以参考[这篇文章](https://medium.com/data-from-the-trenches/a-primer-on-data-drift-18789ef252a6) [1]。

现在，想象自己是一名数据科学家，你正在研究著名的[成年人数据集](https://www.openml.org/d/1590)，尝试通过一个人的年龄、教育、工作等信息来预测他 / 她一年的收入是否超过 50,000 美元。

我们在这个数据集上选了一个随机片段作为我们的训练集，并在这个训练集上为这个二分类任务训练了一个预测器。我们对这个训练的模型很满意，并将它和一个漂移检测系统同时部署在应用程序中。

这个成年人数据集的剩余部分是真实有效的数据。不幸的是，这一目标域数据集的一部分损坏了。

![图 1：用于污染目标域数据集 25% 数据的常量值](https://cdn-images-1.medium.com/max/2000/0*-5yCxLV4zV0SIsNR)

为了演示，我们用常数替换的方式污染了目标域数据集 25% 的数据。这随机损坏了几个特征，即 **race**（种族），**marital_status**（婚姻状态），**fnlwgt**（最终权重），和 **education_num**（受教育指数）。数值型特征通过替换为特征分布的中位数的方式来损坏，而分类型特征则通过替换为一个固定的随机类别来损坏。

在这个例子中，25% 的目标域样本的这四个特征被替换为图 1 所示的常量。用于检测数据改变的漂移检测器正确地发出了警报。然后呢？

## 如何找到漂移最严重的样本？

一个域判别分类器可以帮助我们。这个次级机器学习模型利用一半的源训练集和一半的新目标域数据集进行训练，从而预测一个样本属于**原本的域**还是**新域**。

正如[这篇文章](https://medium.com/data-from-the-trenches/towards-reliable-ml-ops-with-drift-detectors-5da1bdb29c63) [2] 里详细介绍的那样，域分类器实际上是一个很流行的漂移检测器。所以使用它的好处在于不仅能检测数据改变，也能够识别异常样本。如果在你的监控系统中已经有了一个预训练好的分类器，也就同时有了一个异常检测器。

作为第一个假设，我们可以用域分类器给出的属于**新域**的概率分数作为其**漂移分数**，并且标出 k 个异常最显著的样本。但是如果有上百个特征， 弄清提取出来的样本中哪些是异常最显著的就比较困难了。我们需要识别漂移最严重的特征来缩小搜索范围。

为了实现这一点，我们可以做一些假设，比如，我们假设，对域的判别最重要的特征与异常有更紧密的关联。在这种情况下，我们可以使用一个特征重要性衡量准则，此衡量准则应当是适合这个域分类器的，例如，对于随机森林分类器，可以使用平均不纯度减少量（MDI）作为衡量标准。

在机器学习领域有很多种特征重要性衡量准则，这些标准都有自己的局限性。这也是及其学习中通过 SHAP 引入沙普利值的原因之一。如果你想更多地了解沙普利值和 SHAP，你可以看一看这本相当不错的[《Interpretable Machine Learning》](https://christophm.github.io/interpretable-ml-book/shapley.html)[3]。

## 解释漂移

用 [SHAP 工具包](https://github.com/slundberg/shap) [4]，我们可以解释域分类器的输出，特别是对于一个给定的样本，各种特征对其属于**新域**的概率有多少贡献。通过观察异常最严重的样本的沙普利值，我们就能看出哪些因素使域分类器将一个样本归类为异常，由此发现漂移的特征。

![图 2. 特征重要性等级的比较：等级数值越低，对应的特征漂移更严重。SHAP 等级是基于每一个特征在全部测试集内的平均绝对沙普利值计算的。域分类器的等级则是由特征的平均不纯度减少量得到的。](https://cdn-images-1.medium.com/max/2110/0*odM1VlEqPkGFGFMv)

在图 2 中我们比较了成年人数据集的域分类器特征重要性和 SHAP 特征重要性（一个特征的所有沙普利值的绝对值的平均值）。我们发现他们为这些特征赋予了不同的等级，SHAP 正确地捕获了 3 个损坏最严重的特征。重要性衡量准则的选择会影响到漂移特征的识别，因此有必要选择比不纯度更可靠的方法。

但是，并不是随意地选择 3 个漂移最严重的特征，而是将特征的重要性值和在未识别的域中均匀分布的特征重要性值（特征总数的倒数）做对比。之后，我们就可以识别出那些突出的特征。正如下面图 3 所示的那样，**race**，**marital_status**，和 **fnlwgt** 就凸显出来了。

![图 3. 目标域数据集内每个特征的平均绝对沙普利值。重要性值高于平均分布重要性（黑色水平线）的特征很有可能是发生漂移的。](https://cdn-images-1.medium.com/max/3200/0*ss3XMB38A7knxllZ)

如果我们在图 4 中画出全部目标域的数据集样本的沙普利值，并将真正漂移的样本用红色显示，就会发现沙普利值可以很清晰地表现出异常样本和异常特征。在图表中的每一行，使用一系列点来表示同样的目标域样本，而这些点的横坐标就是行左边标示的特征对应的沙普利值。这里，我们可以观察到之前选择的异常特征（**race**，**marital_status**，和 **fnlwgt**），以及最后识别出来的漂移特征 **education_num**，具有双峰分布的特点。

![图 4. 目标域样本特征的 SHAP 总结图表。在每一行，同样的目标域样本被表示成一系列的点，而这些点的横坐标为行左边标示的特征对应的沙普利值。颜色代表样本异常（红色）还是正常（蓝色）](https://cdn-images-1.medium.com/max/2100/0*H3b0e5CYaUpv_ry7)

依赖沙普利值的效率特性，域分类器对一个样本的预测分数就定义为其所有特征的沙普利值的和。于是，从图 4 所示的图表中我们可以推断，未被损坏的特征几乎不影响（但并非完全不影响）对**新域**分类的预测，毕竟它们的沙普利值是以 0 为中心分布的，这一点对那些异常样本尤其显著。

## 直接可视化漂移样本

我们要开始打包并使用这些工具进行实际操作，标记出那些可疑的样本和异常的特征。

首先，让我们来看一看 10 个异常最显著的特征和样本，也许我们碰巧能直观地理解发生了什么。

![图 5. 根据域分类器给出的属于新域的概率分数排列得到的 10 个最显著的样本。列是按照基于 SHAP 的特征重要性排列的。](https://cdn-images-1.medium.com/max/2000/0*sUF74nnxq9_PSXEo)

在这个特别的情形下，我们可能轻易就能识别到（并且发现可疑之处），所有获取到的样本的某些特征值都是常量，但这可能并不是普遍规律。然而，如果漂移出现在分布层级，例如选择性偏差，观察个别样本就不是那么有用了。它们可能只是在源数据集的一个子集内的常规样本，因此技术上讲不能算作异常。但是，毕竟我们无法事先知道我们在面对什么样的漂移，观察一下个别样本依然是个好办法！

图 6 所示的是 SHAP 决定曲线图，其中每条曲线代表一个异常样本。这种图表可以帮助我们发现漂移的情况。我们也可以发现曲线在朝向更高的域分类器漂移评分变化。

![图 6. SHAP 决定曲线图。每条曲线代表 100 个异常最显著的样本之一。最上方的特征是对特征的异常贡献最大的，并且大大增加了域分类器判断样本属于新域的概率](https://cdn-images-1.medium.com/max/2350/0*TMcQpeyCp2sajxxu)

在这种情况下，所有异常都是由同一个损坏的特征造成的，但是对于一组因为不同原因而漂移的样本，SHAP 决定曲线图可以有效地表现出这些趋势。

当然，对特征分布的标准分析还是必不可少的，尤其是在我们可以选择重点关注那些最可疑的特征的时候。在图 8 中，我们将 100 个异常最显著样本的漂移特征的分布用红色标出，并将它们和源训练集的分布进行比较。判别分析更符合人类的直觉，所以这是一种判断新数据集漂移种类的简单手段。在本例中，通过观察特征分布，我们可以马上发现特征取值是常量，这并不符合期望的分布。

![图 8 100 个异常最显著的样本的漂移特征分布（红色）和源数据集相应的分布（蓝色）对比图](https://cdn-images-1.medium.com/max/2052/0*d1xcJT1QnIHlzi7s)

## 总结

当我们将模型应用于意料之外的数据变动，并想监控模型时，我们可以使用域分类器等漂移检测器，在发现漂移时识别异常样本。标出漂移最严重的样本并深入调查，这一系列步骤可以组织成为漂移分析的流水线。而异常能被标记应该归功于域分类器的重要性衡量准则。

然而，要注意特征重要性衡量准则可能存在的不连续性，以及如果你有更多的计算资源，可以考虑使用 SHAP 来实现与漂移相关的更准确的关联性衡量。最后，将实用的 SHAP 可视化工具，和参照未漂移的分布给出的漂移特征分布的判别分析相结合，可以让你的漂移分析更加简单高效。

**参考**

[1] [A Primer on Data Drift](https://medium.com/data-from-the-trenches/a-primer-on-data-drift-18789ef252a6)

[2] [Domain Classifier — Towards reliable MLOps with Drift Detectors](https://medium.com/data-from-the-trenches/towards-reliable-ml-ops-with-drift-detectors-5da1bdb29c63)

[3] [Shapley Values — Interpretable Machine Learning — C. Molnar](https://christophm.github.io/interpretable-ml-book/shapley.html)

[4] [SHapley Additive exPlanations package](https://github.com/slundberg/shap)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
