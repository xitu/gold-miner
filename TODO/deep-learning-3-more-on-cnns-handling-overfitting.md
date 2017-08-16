
> * 原文地址：[Deep Learning-3-more-on-cnns-handling-overfitting](https://medium.com/towards-data-science/deep-learning-3-more-on-cnns-handling-overfitting-2bd5d99abe5d)
> * 原文作者：[Rutger Ruizendaal](https://medium.com/@r.ruizendaal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-3-more-on-cnns-handling-overfitting.md](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-3-more-on-cnns-handling-overfitting.md)
> * 译者：[曹真](https://github.com/lj147/)
> * 校对者：[Lilei](https://github.com/lileizhenshuai) && [changkun](https://github.com/changkun)

# 深度学习系列3 - CNNs 以及应对过拟合的详细探讨

## 什么是卷积、最大池化和 Dropout？

> 这篇文章是深度学习系列中一篇文章。请查看[#系列1](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-1-setting-up-aws-image-recognition.md)和[#系列2](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-2-convolutional-neural-networks.md)

![数据增强（Data augmentation）是一种减少过拟合的方式。](https://cdn-images-1.medium.com/max/1600/1*GUvLnDB2Q7lKHDNiwLQBNA.png)


 欢迎来到本系列教程的第三部分的学习！这周我会讲解一些卷积神经网络（Convolutional Neural Network, CNN）的内容并且讨论如何解决`欠拟合`和`过拟合`。

#### **一、卷积（Convolution）**

那么究竟什么是卷积呢？你可能还记得我之前的博客，我们使用了一个小的滤波器（Filter），并在整个图像上滑动这个滤波器。然后，将图像的像素值与滤波器中的像素值相乘。使用深度学习的优雅之处在于我们不必考虑这些滤波器应该是什么样的（神经网络会自动学习并选取最佳的滤波器）。通过随机梯度下降（Stohastic Gradient Descent,SGD），网络能够自主学习从而达到最优滤波器效果。滤波器被随机初始化，并且位置不变。这意味着他们可以在图像中找到任何物体。同时，该模型还能学习到是在这个图像的哪个位置找到这个物体。


零填充（Zero Padding）是应用此滤波器时的有用工具。这些都是在图像周围的零像素的额外边框 —— 这允许我们在将滤镜滑过图像时捕获图像的边缘。你可能想知道滤波器应该多大，研究表明，较小的滤波器通常表现更好。在这个例子当中，我们使用大小为 3x3 的滤波器。

当我们将这些滤波器依次滑过图像时，我们基本上创建了另一个图像。因此，如果我们的原始图像是 30x 30 ，则带有12个滤镜的卷积层的输出将为 30x30x12 。现在我们有一个张量，它基本上是一个超过 2 维的矩阵。现在你也就知道 TensorFlow 的名字从何而来。

在每个卷积层（或多个）之后，我们通常就得到了最大池化（Max pooling）层。这个层会减少图像中的像素数量。例如，我们可以从图像中取出一个正方形然后用这个正方形里面像素的最大值代替这个正方形。
![最大池化](https://cdn-images-1.medium.com/max/1600/1*GksqN5XY8HPpIddm5wzm7A.jpeg)
 
得益于最大池化，我们的滤波器可以探索图像的较大部分。另外，由于像素损失，我们通常会增加使用最大池化后的滤波器数量。
理论上来说，每个模型架构都是可行的并且为你的的问题提供一个很好的解决方案。然而，一些架构比其他架构要快得多。一个很差的架构可能需要超过你剩余生命的时间来得出结果。因此，考虑你的模型的架构以及我们为什么使用最大池并改变所使用的滤波器的数量是有意义的。为了在 CNN 上完成这个部分，[这个](http://yosinski.com/deepvis#toolbox)页面提供了一个很好的视频，可以将发生在 CNN 内部的事情可视化。


#### 二、欠拟合 vs. 过拟合

你如何知道你的模型是否欠拟合？ 如果你的验证集的准确度高于训练集，那就是模型欠拟合。此外，如果整个模型表现得不好，也会被称为欠拟合。例如，使用线性模型进行图像识别通常会出现欠拟合的结果。也有可能是  Dropout（Dropout）的原因导致你在深层神经网络中遇到欠拟合的情况。
Dropout 在模型训练时随机将部分激活函数设置为零（让网络某些隐含层节点的权重不工作），以避免过拟合。这种情况一般不会发生在验证/测试集的预测中，如果发生，你可以移除 `Dropout`来解决。如果模型现在出现大规模的过拟合，你可以开始添加小批量的 `Dropout`。


 

> 通用法则：从过度拟合模型开始，然后采取措施消除过拟合。

当你的模型过度适合训练集时，就会发生过拟合。那么模型将难以泛化从而无法识别不在训练集中的新例子。例如，你的模型只能识别你的训练集中的特定图像，而不是通用模型，同时你在训练集上的准确性会高于验证/测试集。那么我们可以通过哪些方法来减少过拟合呢？

**减少过拟合的步骤**

1. 添加更多数据
2. 使用数据增强
3. 使用泛化性能更佳的模型结构
4. 添加正规化（多数情况下是 Dropout，L1 / L2正则化也有可能）
5. 降低模型复杂性。
 
第一步当然是采集更多的数据。但是，在大多数情况下，你是做不到这一点的。这里我们先假定你采集到了所有的数据。下一步是数据增强：这也是我们一直推荐使用的方法。

数据增强包括随机旋转图像、放大图像、添加颜色滤波器等等。 

数据增加只适用于训练集而不是验证/测试集。检查你是不是使用了过多的数据增强十分有效。例如，如果你那一只猫的图片放大太多，猫的特征就不再可见了，模型也就不会通过这些图像的训练中获得更好的效果。下面让我们来探索一下数据增强！

对于 Fast AI 课程的学习者：请注意教材中使用 “width_zoom_range” 作为数据扩充参数之一。但是，这个选项在 Keras 中不再可用。

![原始图像](https://cdn-images-1.medium.com/max/1600/1*GqYnzBWEC0L8ehpMcwtkhw.png)

现在我们来看看执行数据增强后的图像。所有的“猫”仍然能够被清楚地识别出来。

![数据增强之后的图像](https://cdn-images-1.medium.com/max/1600/1*ozrEhNk2ONPXo4qDQjKPKw.png)

第三步是使用泛化性能更佳的模型结构。然而，更重要的是第四步：增加正则化。三个最受欢迎的选项是：Dropout，L1 正则化和 L2 正则化。我之前提到过，在深入的学习中，大部分情况下你看到的都是 Dropout 。Dropout 在训练中删除随机的激活样本（使其为零）。在 Vgg 模型中，这仅适用于模型末端的完全连接的层。然而，它也可以应用于卷积层。要注意的是，Dropout 会导致信息丢失。如果你在第一层失去了一些信息，那么整个网络就会丢失这些信息。因此，一个好的做法是第一层使用较低的Dropout，然后逐渐增加。第五个也是最后一个选择是降低网络的复杂性。实际上，在大多数情况下，各种形式的正规化足以应付过拟合。

![Dropout可视化](https://cdn-images-1.medium.com/max/1600/1*yIGb-kfxCAK0xiXipo6utA.png)
> 左边是原来的神经网络，右边是采用 Dropout 后的网络



#### **三、批量归一化（Batch Normalization ）**


最后，我们来讨论批量归一化。这是你永远都需要做的事情！批量归一化是一个相对较新的概念，因此在 Vgg 模型中尚未实现。

如果你对机器学习有所了解，你一定听过标准化模型输入。批量归一化加强了这一步。批量归一化在每个卷积层之后添加“归一化层”。这使得模型在训练中收敛得更快，因此也允许你使用更高的学习率。

简单地标准化每个激活层中的权重不起作用。随机梯度下降非常顽固。如果使得其中一个比重非常高，那么下一次训练它就会简单地重复这个过程。通过批量归一化，模型可以在每次训练中调整所有的权重而非仅仅只是一个权重。

#### **四、MNIST 数字识别**

[MNIST](http://yann.lecun.com/exdb/mnist/)手写数字数据集是机器学习中最着名的数据集之一。数据集也是一个检验我们所学 CNN 知识的很好的方式。[Kaggle](https://www.kaggle.com/c/digit-recognizer)也承载了 MNIST 数据集。这段我很快写出的代码，在这个数据集上的准确度为96.8％。
 

    import pandas as pd
    from sklearn.ensemble import RandomForestClassifier

    train = pd.read_csv('train_digits.csv')
    test = pd.read_csv('test_digits.csv')

    X = train.drop('label', axis=1)
    y = train['label']

    rfc = RandomForestClassifier(n_estimators=300)
    pred = rfc.fit(X, y).predict(test)


然而，配备深层 CNN 可以达到 99.7％ 的效果。本周我将尝试将 CNN 应用到这个数据集上，希望我在下周可以报告最新的准确率并且讨论我所遇到的问题。

如果你喜欢这篇文章，欢迎推荐它以便其他人可以看到它。您还可以按照此配置文件跟上我在快速AI课程中的进度。到时候见！

> [译者](https://github.com/lj147/)注： 翻译本文的时候，我事先查阅了一些资料以保证对于原文有更好的理解，但是由于个人水平有限等等原因，有些地方表达的不甚清楚，同时还添加了一定的辅助参考信息以更好的说明问题。若读者在译文中发现问题，欢迎随时与我联系或提 issue。

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


