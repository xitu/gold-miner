
> * 原文地址：[Deep Learning-3-more-on-cnns-handling-overfitting](https://medium.com/towards-data-science/deep-learning-3-more-on-cnns-handling-overfitting-2bd5d99abe5d)
> * 原文作者：[Rutger Ruizendaal](https://medium.com/@r.ruizendaal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-3-more-on-cnns-handling-overfitting.md](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-3-more-on-cnns-handling-overfitting.md)
> * 译者：[曹真](https://github.com/lj147/)
> * 校对者：

# Deep Learning-3-more-on-cnns-handling-overfitting
# 深度学习系列#3 - CNNs 以及应对过拟合的详细探讨

## What are convolutions, max pooling and dropout?
## 什么是卷积，最大池化（Max pooling）和 dropout？
> 这篇文章是深度学习系列中一篇文章。请查看[系列1](https://medium.com/towards-data-science/deep-learning-1-1a7e7d9e3c07)和[系列2](https://medium.com/towards-data-science/deep-learning-2-f81ebe632d5c)

*This post is part of a series on deep learning. Check-out *[*part 1*](https://medium.com/towards-data-science/deep-learning-1-1a7e7d9e3c07)* and *[*part 2*](https://medium.com/towards-data-science/deep-learning-2-f81ebe632d5c)*.*

![](https://cdn-images-1.medium.com/max/1600/1*GUvLnDB2Q7lKHDNiwLQBNA.png)
 数据增强（Data augmentation）是一种减少过拟合的方式。欢迎来到本系列教程的第三部分的学习！这周我会讲解一些` CNN `的内容并且讨论如何解决`欠拟合`和`过拟合`。
Data augmentation is of the techniques in reducing overfitting
Welcome to the third entry in this series on deep learning! This week I will explore some more parts of the Convolutional Neural Network (CNN) and will also discuss how to deal with underfitting and overfitting.

#### **Convolutions**

#### **卷积（Convolutions）**

那么究竟什么是卷积呢？你可能还记得我之前的博客，我们使用了一个小的滤波器（filter），并在整个图像上平滑移动这个滤波器。然后，将图像的像素值与滤波器中的像素值相乘。使用深度学习的优雅之处在于我们不必考虑这些滤波器应该是什么样的 —— 神经网络会自动学习并选取最佳。通过随机梯度下降（SGD），网络能够自主学习从而达到最优。滤波器被随机初始化，并且位置不变。这意味着他们可以在图像中找到任何物体。同时，该模型还能学习到是在这个图像的哪个位置找到这个物体。

零填充是应用此滤波器时的有用工具。这些都是在图像周围的零像素的额外边框 —— 这允许我们在将滤镜滑过图像时捕获图像的边缘。你可能想知道滤波器应该多大，研究表明，较小的滤波器通常表现更好。在这个例子当中，我们使用大小为3x3的滤波器。

So what exactly is a convolution? As you might remember from my previous blog entries we basically take a small filter and slide this filter over the whole image. Next, the pixel values of the image are multiplied with the pixel values in the filter. The beauty in using deep learning is that we do not have to think about how these filters should look. Through Stochastic Gradient Descent (SGD) the network is able to learn the optimal filters. The filters are initialized at random and are location-invariant. This means that they can find something everywhere in the image. At the same time the model also learns where in the image it has found this thing.

Zero padding is a helpful tool when applying this filters. All this does, is at extra borders of zero pixels around the image. This allows us to also capture the edges of the images when sliding the filter over the image. You might wonder what size the filters should be. Research has shown that smaller filters generally perform better. In this case we use filters of size 3x3.

当我们将这些滤波器依次滑过图像时，我们基本上创建了另一个图像。因此，如果我们的原始图像是30 x 30，则带有12个滤镜的卷积层的输出将为30 x 30 x 12。现在我们有一个张量，它基本上是一个超过2维的矩阵。现在你也就知道TensorFlow的名字从何而来。

在每个卷积层（或多个）之后，我们通常就得到了最大池层。这个层会减少图像中的像素数量。例如，我们可以从图像中取出一个正方形然后用这个这个正方形里面的最大值代替这个正方形。（如下图所示）

When we slide these filters over our image we basically create another image. Therefore, if our original image was 30x30 the output of a convolutional layer with 12 filters will be 30x30x12. Now we have a tensor, which basically is a matrix with over 2 dimensions. Now you also know where the name TensorFlow comes from.

After each convolutional layer (or multiple) we typically have a max pooling layer. This layer simply reduces the amount of pixels in the image. For example, we can take a square of our image and replace this with only the highest value on the square.

![最大池-Max Pooling](https://cdn-images-1.medium.com/max/1600/1*GksqN5XY8HPpIddm5wzm7A.jpeg)
 
得益于 `Max Poling`，我们的滤波器可以探索图像的较大部分。另外，由于像素损失，我们通常会增加使用最大池化后的滤波器数量。
理论上来说，每个模型架构都可以工作并且为你的的问题提供一个很好的解决方案。然而，一些架构比其他架构要快得多。一个很差的架构可能需要超过你剩余生命的时间来得出结果。因此，考虑你的模型的架构以及我们为什么使用最大池并改变所使用的滤波器的数量是有意义的。为了在 CNN 上完成这个部分，[这个](http://yosinski.com/deepvis#toolbox)页面提供了一个很好的视频，可以将发生在 CNN 内部的事情可视化。
Max Pooling
Because of Max Poling our filters can explore bigger parts of the image. Additionally, because of the loss in pixels we typically increase the number of filters after used max pooling.

In theory every model architecture will work and should be able to provide a good solution to your problem. However, some architectures do it much faster than others. A very bad architecture might take longer training than the amount of years you have left … Therefore, it is useful to think about the architecture of your model and why we use things like max pooling and change the amount of filters used. To finish this part on CNNs, [this](http://yosinski.com/deepvis#toolbox) page provides a great video that visualizes what happens inside a CNN.

---

#### 欠拟合 vs. 过拟合

你如何知道你的模型是否欠拟合？ 如果你的验证集的准确度高于训练集，那就是模型欠拟合。此外，如果整个模型表现得不好，也会被称为欠拟合。例如，使用线性模型进行图像识别通常会出现欠拟合的结果009。也有可能是因为`dropout`的原因导致你在深层神经网络中遇到欠拟合的情况。
[dropout](http://www.cnblogs.com/tornadomeet/p/3258122.html)在模型训练时随机将激活设置为零（让网络某些隐含层节点的权重不工作），以避免过拟合。这不会发生在验证/测试集的预测中。如果发生了这种情况，你可以移除 `dropout`。如果模型现在出现大规模的过拟合，你可以开始添加小批量的 `dropout`。

> 通用法则：从过度拟合模型开始，然后采取措施消除过拟合。



#### Underfitting vs. Overfitting

How do you know if your model is underfitting? Your model is underfitting if the accuracy on the validation set is higher than the accuracy on the training set. Additionally, if the whole model performs bad this is also called underfitting. For example, using a linear model for image recognition will generally result in an underfitting model. Alternatively, when experiencing underfitting in your deep neural network this is probably caused by dropout. Dropout randomly sets activations to zero during the training process to avoid overfitting. This does not happen during prediction on the validation/test set. If this is the case you can remove dropout. If the model is now massively overfitting you can start adding dropout in small pieces.

> As a general rule: Start by overfitting the model, then take measures against overfitting.
 
当你的模型过度适合训练集时，就会发生过拟合。那么模型难以泛化从而识别不在训练集中的新例子。例如，你的模型只识别你的训练集中的特定图像，而不是通用模型。你的训练准确性会高于验证/测试集。那么我们可以通过哪些方法来减少过拟合呢？


Overfitting happens when your model fits too well to the training set. It then becomes difficult for the model to generalize to new examples that were not in the training set. For example, your model recognizes specific images in your training set instead of general patterns. Your training accuracy will be higher than the accuracy on the validation/test set. So what can we do to reduce overfitting?

*Steps for reducing overfitting:*

**减少过拟合的步骤**

1. 添加更多数据
2. 使用数据增强
3. 使用泛化性能更佳的模型结构
4. 添加正规化（多数情况下是 dropout，L1 / L2正则化也有可能）
5. 降低模型复杂性。
 

1. Add more data
2. Use data augmentation
3. Use architectures that generalize well
4. Add regularization (mostly dropout, L1/L2 regularization are also possible)
5. Reduce architecture complexity.
第一步当然是采集更多的数据。但是，在大多数情况下，你是做不到这一点的。我们假定你采集到了所有的数据。下一步是数据增强：这也是我们总是推荐使用的方法。
数据增强包括随机旋转图像，放大，添加颜色滤波器等等。 


The first step is of course to collect more data. However, in most cases you will not be able to. Let’s assume you have collected all the data. The next step is data augmentation: something that is always recommended to use.

数据增加只适用于训练集而不是验证/测试集。检查你是不是使用了过多的数据增强十分有效。例如，如果你那一只猫比例放的过大，猫的特征就不再可见了，模型也就不会通过这些图像的训练中获得更好的效果。下面让我们来探索一下数据增强！
Data augmentation includes things like randomly rotating the image, zooming in, adding a color filter etc. Data augmentation only happens to the training set and not on the validation/test set. It can be useful to check if you are using too much data augmentation. For example, if you zoom in so much that features of a cat are not visible anymore, than the model is not going to get better from training on these images. Let’s explore some data augmentation!

对于快速AI课程的追随者：请注意笔记本使用“width_zoom_range”作为数据扩充参数之一。但是，此选项在Keras中不再可用。

*For followers of the Fast AI course: be aware that the notebook uses ‘width_zoom_range’ as one of the data augmentation arguments. However, this option is not available anymore in Keras.*

![](https://cdn-images-1.medium.com/max/1600/1*GqYnzBWEC0L8ehpMcwtkhw.png)


原始图像
现在我们来看看执行数据增强后的图像。所有的“猫”仍然能够被清楚地识别为我的猫。
Original image
Let’s now have a look at the image after performing data augmentation. All of the ‘cats’ are still clearly recognizable as cats to me.

![数据增强之后的猫](https://cdn-images-1.medium.com/max/1600/1*ozrEhNk2ONPXo4qDQjKPKw.png)


第三步是使用泛化性能更佳的模型结构。然而，更重要的是第四步：增加正则化。三个最受欢迎的选项是：dropout，L1正则化和L2正则化。我之前提到过，在深入的学习中，大部分情况下你看到的都是dropout 。dropout在训练中删除随机的激活样本（使其为零）。在 Vgg 模型中，这仅适用于模型末端的完全连接的层。然而，它也可以应用于卷积层。要注意的是，dropout 会导致信息丢失。如果你在第一层失去了一些信息，那么整个网络就会丢失这些信息。因此，一个好的做法是第一层使用较低的dropout，然后逐渐增加。第五个也是最后一个选择是降低网络的复杂性。实际上，在大多数情况下，各种形式的正规化足以应付过拟合。

Augmented cats
The third step is to use an architecture that generalizes well. However, much more important is the fourth step: adding regularization. The three most popular options are: dropout, L1 regularization and L2 regularization. In deep learning you will mostly see dropout, which I discussed earlier. Dropout deletes a random sample of the activations (makes them zero) in training. In the Vgg model this is only applied in the fully connected layers at the end of the model. However, it can also be applied to the convolutional layers. Be aware that dropout causes information to get lost. If you lose something in the first layer, it gets lost for the whole network. Therefore, a good practice is to start with a low dropout in the first layer and then gradually increase it. The fifth and final option is to reduce the network complexity. In reality, various forms of regularization should be enough to deal with overfitting in most cases.

![可视化dropout](https://cdn-images-1.medium.com/max/1600/1*yIGb-kfxCAK0xiXipo6utA.png)


#### **批量归一化（Batch Normalization ）**

#### **Batch Normalization**


最后，我们来讨论批量归一化。这是你永远都需要做的事情！批量归一化是一个相对较新的概念，因此在 Vgg 模型中尚未实现。



Finally, let’s discuss batch normalization. This is something you should always do! Batch normalization is a relatively new concept and therefore was not yet implemented in the Vgg model.

如果你尝试过机器学习，你一定听过标准化模型输入。批量归一化加强了这一步。批量归一化在每个卷积层之后添加“归一化层”。这使得模型在训练中收敛得更快，因此也允许你使用更高的学习率。

Standardizing the inputs of your model is something that you have definitely heard about if you are into machine learning. Batch normalization takes this a step further. Batch normalization adds a ‘normalization layer’ after each convolutional layer. This allows the model to converge much faster in training and therefore also allows you to use higher learning rates.

简单地标准化每个激活层中的权重不起作用。随机梯度下降非常顽固。如果使其中一个比重非常高，那么下一次它就会简单地重复这个过程。通过批量归一化，模型可以学习到它可以每一次都调整所有权重而某一个权重。

Simply standardizing the weights in each activation layer will not work. Stochastic Gradient Descent is very stubborn. If wants to make one of the weights very high it will simply do it the next time. With batch normalization the model learns that it can adjust all the weights instead of one each time.




#### ** MNIST 数字识别**

#### **MNIST Digit Recognition**
 [MNIST]（http://yann.lecun.com/exdb/mnist/）手写数字数据集是机器学习中最着名的数据集之一。数据集也是一个检验我们所学CNN知识的很好的方式。[Kaggle]（https://www.kaggle.com/c/digit-recognizer）也承载了MNIST数据集。这段我很快写出的代码，在这个数据集上具有96.8％的准确性。
 
The [MNIST](http://yann.lecun.com/exdb/mnist/) handwritten digits dataset is one of the most famous datasets in machine learning. The dataset also is a great way to experiment with everything we now know about CNNs. [Kaggle ](https://www.kaggle.com/c/digit-recognizer)also hosts the MNIST dataset. This code I quickly wrote is all that is necessary to score 96.8% accuracy on this dataset.

    import pandas as pd
    from sklearn.ensemble import RandomForestClassifier

    train = pd.read_csv('train_digits.csv')
    test = pd.read_csv('test_digits.csv')

    X = train.drop('label', axis=1)
    y = train['label']

    rfc = RandomForestClassifier(n_estimators=300)
    pred = rfc.fit(X, y).predict(test)


然而，配备深层CNN可以达到99.7％的效果。本周我将尝试将CNN应用到这个数据集上，希望我在下周可以报告最新的精度值并且讨论我所遇到的问题。

如果你喜欢这篇文章，欢迎推荐它以便其他人可以看到它。您还可以按照此配置文件跟上我在快速AI课程中的进度。到时候见！

However, fitting a deep CNN can get this result up to 99.7%. This week I will try to apply a CNN to this dataset and hopefully next week I can report the accuracy I reached and discuss the issues I ran into.

If you liked this posts be sure to recommend it so others can see it. You can also follow this profile to keep up with my process in the Fast AI course. See you there!


> 译者注： 翻译本文的时候，我事先查阅了一些资料以保证对于原文有更好的理解，但是由于[个人](https://github.com/lj147/)水平有限等等原因，有些地方表达的不甚清楚，或者添加了一定的辅助信息以更好的说明问题。若读者在译文中发现问题，欢迎随时与我联系或提issue。

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。


