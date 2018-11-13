> * 原文地址：[Data Science and Machine Learning Interview Questions](https://towardsdatascience.com/data-science-and-machine-learning-interview-questions-3f6207cf040b)
> * 原文作者：[George Seif](https://towardsdatascience.com/@george.seif94?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-science-and-machine-learning-interview-questions.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-science-and-machine-learning-interview-questions.md)
> * 译者：[jianboy](https://github.com/jianboy)
> * 校对者：[yqian1991](https://github.com/yqian1991)

# 数据科学和机器学习面试问题

啊，可怕的机器学习面试啊。表面上，你觉得你知道一切......可当你使用它时，你会发现很多你都不会！

在过去的几个月里，我面试了一些涉及数据科学和机器学习的初级职位。为了让你们更了解我的背景，我目前正处于研究生院机器学习和计算机视觉硕士课程的最后几个月里，我以前的大部分经验都是研究/学术的，但是有 8 个月的时间是在初创公司(与 ML 无关)。这些职位包括数据科学、机器学习和自然语言处理或计算机视觉方面的专业工作。我面试了亚马逊、特斯拉、三星、优步、华为等大公司。也面试了许多从早期到成熟和资金充足的初创公司。

今天我将与大家分享我被问到的所有面试问题以及如何处理这些问题。许多问题都是普遍问题和一些基础理论，但其他许多问题都非常具有创造性和新奇。我将简单列出最常见的那些，因为有很多关于这些基础理论知识的在线资源，并且更深入地介绍一些不那么常见和棘手的问题。我希望在阅读这篇文章时，可以帮助你在机器学习面试中取得优异成绩并获得理想的工作！

我们来看看：

*   偏差和方差之间的区别是什么？
*   什么是梯度下降？
*   解释过拟合和欠拟合问题以及如何解决它们？
*   如何解决数据高维度问题以及如何降维？
*   什么是正则化，我们为什么要使用它，并提供一些常用方法的例子？
*   什么是主成分分析（PCA）？
*   为什么 ReLU 在神经网络中比 Sigmoid 更好、更经常使用？
*   **什么是数据规范化以及我们为什么需要它？** 我觉得这一点很重要。数据归一化是非常重要的预处理步骤，用于重新调整值以适应特定范围，以确保在反向传播期间更好的收敛。通常，它归结为减去每个数据点的平均值并除以其标准偏差。如果我们不这样做，那么一些特征（具有高级数的特征）将在成本函数中加权更多（如果更高幅度的特征变化 1％，那么这种变化相当大，但对于较小的特征，它是非常微不足道的）。数据规范化使所有特征均等加权。
*   **解释什么是降维，什么时候使用，以及使用它的好处？** 降维是通过获得数据集重要特征的主要变量来减少所考虑的特征变量数量的过程。特征的重要性取决于特征变量对数据的信息表示的贡献程度，并取决于您决定使用哪种技术。决定使用哪种技术归结为反复试验和偏好。通常从线性技术开始，当结果表明不合适时，转向非线性技术。降维的好处有：(1) 减少所需的存储空间 (2) 加速计算（例如在机器学习算法中），更少的维度意味着更少的计算，更少的维度可以允许使用在高维度不适合的算法 (3) 删除冗余特征，例如以平方米和平方英里存储地形大小没有任何意义（可能数据收集存在缺陷） (4) 将数据维度减少到 2D 或 3D 可能允许我们绘制图像和可视化它，可以观察图像，得出一些结论 (5) 太多的特征或太复杂的模型可能导致过度拟合。
*   **如何处理数据集中丢失或损坏的数据？** 您可以在数据集中找到丢失/损坏的数据，并丢弃这些行或列，或决定用其他值替换它们。在 Pandas 中，有两个非常有用的方法：isnull() 和 dropna()，它们可以帮助您查找丢失或损坏数据的数据列并删除这些值。 如果要使用占位符值（例如：0）填充无效值，可以使用 fillna() 方法。
*   **解释这种聚类算法？** 我写了一篇关于[数据科学家需要知道的 5 种聚类算法](https://towardsdatascience.com/the-5-clustering-algorithms-data-scientists-need-to-know-a36d136ef68) 的热门文章，文章中用一些很棒的可视化操作，解释了什么是聚类算法。
*   **您将如何进行探索性数据分析（EDA）？** EDA 的目标是在应用预测模型之前从数据中收集一些见解，即获得一些信息。基本上，您希望以_粗到细_的方式进行 EDA。我们首先获得一些高级别的全局见解。检查一些不平衡的类。查看每个类的均值和方差。查看前几行，了解它的全部内容。运行 pandas 命令 `df.info()` 以查看哪些特征是连续的，分类的，它们的类型(int，float，string)。接下来，删除在分析和预测中不必要的列。这些可能只是看起来毫无用处的列，其中许多行具有相同的值（即它不会给我们提供太多信息），或者它缺少很多值。我们还可以使用该列中最常见的值或中位数填写缺失值。现在我们可以开始做一些基本的可视化。从高维开始。对少量组进行分类，可以分别做条形图。最终得到一些条形图。看看这些条形图的“一般特征”。创建一些关于这些一般特征的可视化，以尝试获得一些基本见解。现在我们可以开始更具体了。一次创建两个或三个特征之间的可视化。特征如何相互关联？您还可以执行 PCA( 主成分分析) 以查看哪些功能包含最多信息。将一些特征组合在一起以查看它们之间的关系。例如，当 A = 0 且 B = 0 时，类会发生什么？ A = 1 和 B = 0 怎么样？比较不同的特征。例如，如果特征 A 可以是“女性”或“男性”，那么我们可以绘制特征 A 根据他们留在哪个小屋，看看男性和女性是否留在不同的小屋中。除了条形图，散点图和其他基本图之外，我们还可以绘制 PDF/CDF、叠加图等。查看一些统计信息，如分布列，p 值等。最后是构建 ML 模型的时候了。从朴素贝叶斯和线性回归等简单的东西开始。如果您看到那些数据是高度非线性的，请使用多项式回归，决策树或 SVM。可以根据 EDA 的重要性选择功能。如果您有大量数据，可以使用神经网络。检查 ROC 曲线、精确率和召回率。
*   **您如何知道应该使用哪种机器学习模型？** 虽然人们应该始终牢记“无免费午餐定理”，但仍有一些一般性的指导方针。 我写了一篇关于如何选择合适的回归模型的文章[这里](https://towardsdatascience.com/selecting-the-best-machine-learning-algorithm-for-your-regression-problem-20c330bad4ef)。这篇[文章](https://www.google.com/search?tbs=simg:CAESqQIJvnrCwg_15JjManQILEKjU2AQaBAgUCAoMCxCwjKcIGmIKYAgDEijqAvQH8wfpB_1AH_1hL1B_1YH6QKOE6soyT-TJ9A0qCipKKoo0TS0NL0-GjA_15sJ-3A24wpvrDVRc8bM3x0nrW3Ctn6tFeYFLpV7ldtVRVDHO-s-8FnDFrpLKzC8gBAwLEI6u_1ggaCgoICAESBOmAAdwMCxCd7cEJGogBChsKCGRvY3VtZW502qWI9gMLCgkvbS8wMTVidjMKGAoGbnVtYmVy2qWI9gMKCggvbS8wNWZ3YgoXCgVtdXNpY9qliPYDCgoIL20vMDRybGYKGwoIcGFyYWxsZWzapYj2AwsKCS9tLzAzMHpmbgoZCgdwYXR0ZXJu2qWI9gMKCggvbS8waHdreQw&q=choose+ml+algorithm&tbm=isch&sa=X&ved=0ahUKEwi-js_8nNbaAhWB5YMKHUTLCEMQsw4INg&biw=1855&bih=990#imgrc=vnrCwg_5JjNUcM:)也写得很好。
*   **为什么我们使用卷积处理图像而不仅仅是 FC 层？** 这个非常有趣，因为它不是公司通常会问的问题。 正如您所料，我从一家专注于计算机视觉的公司那里得到了这个问题。 这个答案有 2 个部分。 首先，卷积保留并编码了实际使用的图像空间信息。 如果我们只使用 FC 层，我们将没有相关的空间信息。 其次，卷积神经网络 (CNN) 具有部分内置的平移方差，因为每个卷积核都充当它自己的滤波器/特征检测器。
*   **是什么让 CNNs 平移不变？** 如上所述，每个卷积核都充当它自己的滤波器/特征检测器。 因此，假设您正在进行对象检测，对象在图像中的位置并不重要，因为我们将以滑动窗口的方式对整个图像应用卷积。
*   **为什么我们在分类 CNN 中有最大池化?** 再次如您所料，这是计算机视觉中的一个角色。CNN 中的最大池化允许您减少计算，因为池化后的要素图较小。 由于您正在进行最大程度的激活，因此不会丢失过多的语义信息。 还有一种理论认为，最大池化有助于为 CNN 提供更多的方差转换。 看看这个来自 Andrew Ng 的关于[最大池化的好处](https://www.coursera.org/learn/convolutional-neural-networks/lecture/hELHk/pooling-layers)的精彩视频。
*   **为什么分段 CNN 通常具有编码器 —— 解码器样式/结构？** 编码器 CNN 基本上可以被认为是特征提取网络，而解码器使用该信息通过“解码”特征并且放大到原始图像大小来预测图像片段。
*   **残留网络有什么意义？** 剩余连接所做的主要事情是允许从先前层直接访问功能。 这使得整个网络中的信息传播变得更加容易。 一个非常有趣的[论文](https://arxiv.org/abs/1605.06431)介绍了如何使用本地跳过连接为网络提供一种整体多路径结构，为多个路径提供在整个网络中传播的功能。
*   **什么是批处理归一化？为什么它有效？** 训练深度神经网络很复杂，因为每一层的输入分布在训练期间随着前一层的参数改变而改变。然后，我们的想法是将每层的输入标准化，使得它们的平均输出激活函数为零，标准偏差为 1。这是针对每一层上的每个单独的小批量进行的，即单独计算该小批量的平均值和方差，然后进行归一化。这类似于网络输入的标准化。这有什么用？我们知道将网络输入规范化有助于它学习。但网络只是一系列层，其中一层的输出成为下一层的输入。这意味着我们可以将神经网络中的任何层视为较小的后续网络的第一层。考虑到作为一系列相互馈送的神经网络，我们在应用激活函数之前规范化一层的输出，然后将其馈送到下一层（子网络）。
*   **你会如何处理不平衡的数据集？** 我有一篇[文章](https://towardsdatascience.com/7-practical-deep-learning-tips-97a9f514100e) 讲到它! 请查看第 #3 节:)
*   **你为什么要使用许多小的卷积内核，比如 3x3 而不是几个大内核？** 这在 [VGGNet 论文](https://arxiv.org/pdf/1409.1556.pdf)中得到了很好的解释。 有两个原因：首先，您可以使用几个较小的内核而不是几个较大的内核来获取相同的感知字段并捕获更多的空间上下文，但是使用较小的内核则使用较少的参数和计算。 其次，因为对于较小的内核，您将使用更多的过滤器，您将能够使用更多的激活函数，因此您的 CNN 可以学习更具辨别力的映射函数。
*   **你有其他与此相关的项目吗？** 在这里，您将真正了解您的研究与业务之间的联系。您是否有任何您所学到的技能或可能与您的业务或您申请的职位有关的技能？ 它不必 100％ 准确，只是以某种方式相关，以便您可以证明您将能够直接贡献大量的价值。
*   **解释你目前的硕士研究？什么有用？什么没有？未来发展方向？** 和上一个问题一样！

![](https://cdn-images-1.medium.com/max/800/1*9gyga7q3TWYQ1oiZigeTCA.jpeg)

#### 结论

现在你们应该都了解了！我在申请数据科学和机器学习中的角色时遇到的所有面试问题。 我希望你喜欢这篇文章并学到一些新的有用的东西！ 如果本文确实对你有用，请给我点个赞吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
