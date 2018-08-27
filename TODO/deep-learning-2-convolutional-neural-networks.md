
> * 原文地址：[Deep Learning 2: Convolutional Neural Networks](https://medium.com/towards-data-science/deep-learning-2-f81ebe632d5c)
> * 原文作者：[Rutger Ruizendaal](https://medium.com/@r.ruizendaal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-2-convolutional-neural-networks.md](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-2-convolutional-neural-networks.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[edvardHua](https://github.com/edvardHua),[lileizhenshuai](https://github.com/lileizhenshuai)

# 深度学习系列2：卷积神经网络

## CNN 是怎么学习的？学习了什么？

**这篇文章是深度学习系列的一部分。你可以在**[**这里**](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-1-setting-up-aws-image-recognition.md)**查看第一部分，以及在**[**这里**](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-3-more-on-cnns-handling-overfitting.md)**查看第三部分。**

![](https://cdn-images-1.medium.com/max/1600/1*z7hd8FZeI_eodazwIapvAw.png)

这一周，我们将探索卷积神经网络（CNN）的内部工作原理。你可能会问：在网络内部究竟发生了什么？它们是怎样学习的？

这门课程遵循自上而下的学习方法与理念。因此一般来说，我们在开始学习的时候就能立即玩到所有的模型，然后我们会逐渐深入其内部的工作原理。因此，本系列也将会逐渐深入探索神经网络的内部工作原理。现在仅仅是第二周，让我们朝着最终的目标迈进吧！

在上周，我在猫狗图像集上训练了 Vgg 16 模型。我想先聊一下为什么说使用预先训练好的模型是一种很好的方法。为了使用这些模型，首先你得要弄清楚这些模型到底学习的是什么。从本质上说，CNN 学习的是过滤器，并将学习到的过滤器应用于图像。当然，这些“过滤器”和你在 Instagram 里用的滤镜（英文也为“filter”）并不是一种东西，但它们其实有一些相同之处。CNN 会使用一个小方块遍历整张图片，通常将这个小方块称为“窗口”。接下来，网络会在图片中查找与过滤器匹配的图片内容。在第一层，网络可能只学习到了一些简单的事物（例如对角线）。在之后的每一层中，网络都将结合前面找到的特征，持续学习更加复杂的概念。单单听这些概念可能会让人比较迷糊，让我们直接来看一些例子。[Zeiler and Fergus (2013)](https://arxiv.org/abs/1311.2901) 为可视化 CNN 学习过程做出了一项很棒的工作。下图是他们在论文中用的 CNN 模型，赢得 Imagenet 竞赛的 Vgg16 模型就是基于这个模型做出来的。

![](https://cdn-images-1.medium.com/max/1600/1*vKyUGyRnJnZ3XOVVlvp80g.png)

CNN，作者：Zeiler & Fergus (2013)

可能你现在会觉得这个图片很难懂，请不要慌！让我们先从我们可以在图中看到的东西说起吧。首先，输入图像是正方形，大小为 224x224 像素。我之前说的过滤器大小是 7x7 像素大小。该模型有一个输入层，7 个隐藏层以及一个输出层。输出层的“C”指的是模型的预测分类数量。现在让我们来了解 CNN 中最有趣的部分：这个神经网络在每一层中都学到了什么！

![](https://cdn-images-1.medium.com/max/1600/1*k57FsdDndnfb4FendDdnAw.png)

上图为 CNN 的第二层。左边的图像代表了 CNN 的这层网络在右边的真实图片中学习到的内容。
在 CNN 的第二层中，你可以发现这个模型已经不仅仅是去提取对角线了，它找到了一些更有意思的形状特征。例如在第二排第二列的方块中，你可以看到模型正在提取圆形；还有，最后一个方块表明模型正在专注于识别图中的一个直角作为特征。

![](https://cdn-images-1.medium.com/max/1600/1*7J5H2D0WSRBnEvI-BXfONg.png)

上图为 CNN 的第三层。
在第三层中，我们可以看到模型已经开始学习一些更具体的东西。第一个方块中的图像表明模型已经能够识别出一些地理特征；第二排第二列的方块表明模型正在识别车轮；倒数第二个方块表明模型正在识别人类。

![](https://cdn-images-1.medium.com/max/2000/1*QKxqFAp83WDU94N0a7AIpg.png)

CNN 的第四层与第五层

在最后，第四层与第五层保持前面模型越来越具体的趋势。第五层找到了对解决我们的猫狗问题非常有帮助的特征。与此同时，它还识别出了独轮车，以及鸟类、爬行动物的眼睛。请注意，这些图像仅仅展示了每一层学习到的东西的极小一部分。

希望上面的文字已经告诉了你为什么使用预先训练好的模型是很有用的。如果你想更多的了解这块领域的研究，你可以搜索“迁移学习”（transfer learning）的相关内容。虽然我们的猫狗问题训练集仅仅只有 25000 张图片，一个新的模型可能还无法从这些图片中学习到所有的特征，但我们的 Vgg16 模型已经相当“了解”怎么去识别猫和狗了。最后，通过“微调”（Finetuning） Vgg16 模型的最后一层，让其不再输出 1000 多种分类的概率，而是直接输出二分类 —— 猫和狗。

如果你对深度学习背后的数学知识感兴趣，[Stanford’s CNN pages](http://cs231n.github.io/) 是很好的参考材料。他们首次以“数学之美”解释了浅层神经网络。

---

#### 微调及线性层（全连接层）

上周，我用这个预先训练好的 Vgg16 模型不能很自然的区分猫和狗这两个分类下的图片，而是提出了 1000 余种分类。此外，这个模型并不会直接输出“猫”和“狗”的分类，而是输出猫和狗的一些特定品种。那我们如何修改这个模型，让它能够有效地对猫和狗进行分类呢？

有种可选方案：手动将这些品种分到猫和狗中去，然后计算其概率之和。但是，这种做法会丢弃一些关键信息。例如，如果图片中只有一根骨头，但它很可能是一张属于狗的照片。如果我们仅查看这些品种分为猫狗的概率，前面提到的这种信息很可能会丢失。因此在模型的最后，我们加入一个线性层（全连接层），它将仅输出两种分类。实际上，Vgg16 模型的最后有 3 层全连接层。我们可以微调这些层，通过反向传播来训练它们。反向传播算法常常被人看成是一种抽象的魔法，但其实它只是简单应用链式求导法则。你可以暂时忽略这些数学上的细节，TensorFlow、Theano 和其它深度学习库已经帮你做好了这些工作。

如果你正在运行 Fast AI 课程 lesson 2 的 notebook，我建议你最好先只使用 notebook 的样例图片。如果你运行 p2 的实例，可能会由于保存、加载 numpy 数组将内存耗尽。

---

#### 激活函数

前面我们讨论了网络最后的线性层（全连接层）。然而，神经网络的所有层都不是线性的。在神经网络计算出每个神经元的参数之后，我们需要将它们的计算结果作为参数输入到激活函数中。人工神经网络基本上由矩阵乘法组成，如果我们只使用线性计算的话，我们只能将它们一个个叠加在一起，并不能做成一个很深的网络。因此，我们会经常在网络的各层使用非线性的激活函数。通过将重重线性与非线性函数叠加在一起，理论上我们可以对任何事物进行建模。下面是三种最受欢迎的非线性激活函数：

- Sigmoid **（将值转换到 0，1 间）**
- TanH **（将值转换到 -1，1 间）**
- ReLu **（如果值为负则输出 0，否则输出原值）**

![](https://cdn-images-1.medium.com/max/1600/1*feheZP3rz5va0QVpi9DVNg.png)

上图为最常用的激活函数：Sigmoid、Tanh 和 ReLu（又名修正线性单元）
目前，ReLu 是使用的最多的非线性激活函数，主要原因是它可以减少梯度消失的可能性，以及保持稀疏特征。稍后会讨论这方面的更多详情。因为我们希望模型最后能够输出确定的内容，因此模型的最后一层通常使用一种另外的激活函数 —— softmax。softmax 函数是一种非常受欢迎的分类器。

在微调完 Vgg16 模型的最后一层之后，它总共有 138357544 个参数。谢天谢地，我们不需要手动计算各种梯度 XD。下一周我们将更深入地了解 CNN 的工作原理，讨论主题为欠拟合和过拟合。

如果你喜欢这篇文章，请将它推荐给其他人吧！你也可以关注此系列文章，跟上 Fast AI 课程的进度。下篇文章再会！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#%E5%89%8D%E7%AB%AF)、[后端](https://github.com/xitu/gold-miner#%E5%90%8E%E7%AB%AF)、[产品](https://github.com/xitu/gold-miner#%E4%BA%A7%E5%93%81)、[设计](https://github.com/xitu/gold-miner#%E8%AE%BE%E8%AE%A1) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
