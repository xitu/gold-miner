> * 原文地址：[Text Classification using Neural Networks](https://machinelearnings.co/text-classification-using-neural-networks-f5cd7b8765c6#.vvfa01t9r)
* 原文作者：[gk_](https://machinelearnings.co/@gk_)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Kulbear](https://github.com/kulbear)
* 校对者：[luoyaqifei](https://github.com/luoyaqifei)，[hikerpig](https://github.com/hikerpig)

# 用神经网络进行文本分类

理解[聊天机器人如何工作](https://medium.com/p/how-chat-bots-work-dfff656a35e2)是很重要的。聊天机器人内部一个基础的组成部分是**文本分类器**。让我们一起来探究一个用于文本分类的人工神经网络的内部结构。

![](https://cdn-images-1.medium.com/max/800/1*DpMaU1p85ZSgamwYDkzL-A.png)

多层人工神经网络

我们将会使用两层神经元（包括一个隐层）和词袋模型来组织（organizing 似乎有更好的选择，求建议）我们的训练数据。[有三种聊天机器人文本分类的方法](https://medium.com/@gk_/how-chat-bots-work-dfff656a35e2#.3zb2b9g2v)：**模式匹配**，**算法**，**神经网络**。尽管[基于算法的方法](https://medium.com/@gk_/text-classification-using-algorithms-e4d50dcba45#.mho4fx7e5)使用的多项式朴素贝叶斯方法效率惊人，但它有三个根本性的缺陷：

- **该算法的输出是一个评分**而非概率。我们想要的是一个概率，它可以直接应用于给定阈值的从而忽略一些预测结果，就像忽略收音机里呲呲啦啦的背景高频噪声。
- 该算法从一类数据中“学习”什么**是**这一类数据，而非什么**不是**这一类数据
。然而对于非某一类数据的模式学习通常也是十分重要的。
- 一些不成比例分布的训练数据类型会使分类结果失真，强制使算法根据类型数据量**调整输出分数**，这并不理想。

打一个简单的比方，这样一个分类器并没有尝试去理解**一句话的意思**，而是试图直接对这句话进行分类。事实上，所谓的“人工智能聊天机器人”并不会真的理解语言，不过那便是[另一个故事](https://medium.com/@gk_/the-ai-label-is-bullshit-559b171867ff#.cqbwy3eb7)了。

#### 如果人工神经网络对你来说很陌生，那你可以先读一读[他们是如何工作的](https://medium.com/@gk_/how-neural-networks-work-ff4c7ad371f7).

#### 想要理解基于上述算法的方法，可以看[这里](https://chatbotslife.com/text-classification-using-algorithms-e4d50dcba45).

让我们分析下我们的文本分类器，一次一部分，我们将采取如下步骤：

1. 我们所需要的**库** 
2. 提供**训练数据**
3. **组织整理**数据 
4. **迭代**: 编写代码 + 测试预测结果 + 调整模型
5. **抽象**

代码可参见[这里](https://github.com/ugik/notebooks/blob/master/Neural_Network_Classifier.ipynb)，我们使用 [iPython notebook](https://ipython.org/notebook.html) 这个在数据科学领域极其高效的工具，编程语言使用的是 Python。

我们首先引入将要使用的自然语言工具库。我们需要可靠地将整句话分词，并对词进行词干化处理。

![](https://ww1.sinaimg.cn/large/006y8lVagy1fcfejony8zj31880do0ua.jpg)

这是我们的训练数据，12 句话，分属于三个不同类别。 (‘intents’).

![](https://ww1.sinaimg.cn/large/006y8lVagy1fcfeo19k6qj316g0p8q89.jpg)

    训练集中的 12 句话

现在我们开始以**文档**，**类别**和**词语**为标准整理我们的数据结构。

![](https://ww3.sinaimg.cn/large/006y8lVagy1fcfeokdewnj316q106n2k.jpg)

    12 文档
    3 个类别 ['greeting', 'goodbye', 'sandwich']
    26 个唯一词干 ['sandwich', 'hav', 'a', 'how', 'for', 'ar', 'good', 'mak', 'me', 'it', 'day', 'soon', 'nic', 'lat', 'going', 'you', 'today', 'can', 'lunch', 'is', "'s", 'see', 'to', 'talk', 'yo', 'what']

这里需要注意的是，每个词语在这里都已经是全小写并且只被词干化处理。保留基本形式可以让机器将 "have" 和 "having" 这类词语同等看待。我们不关心大小写的问题。

![](https://cdn-images-1.medium.com/max/600/1*eUedufAl7_sI_QWSEIstZg.png)

我们将训练数据中的每句话被转换为词袋模型的形式

![](https://ww1.sinaimg.cn/large/006y8lVagy1fcfepqvg50j319013ydlw.jpg)

    ['how', 'ar', 'you', '?']
    [0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    [1, 0, 0]

上述步骤是文字分类任务中典型的一环：将每个训练数据的句子转换为一个对应于完整词袋中单词位置的，由 0 和 1 组成的数组。

    ['how', 'are', 'you', '?']

被处理后：

    ['how', 'ar', 'you', '?']

然后转换到输入数据的格式: **每个 1 代表这个位置的词在我们的词袋中（问号被忽略了）**

    [0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

输出：**第一类**

    [1, 0, 0]

注意，一个句子可能会被分为多类，或者**无分类**。

确保你理解了上面的内容以后，让我们将视线放到代码部分。

#### 机器学习中最重要的一步，是获取干净的数据

![](https://cdn-images-1.medium.com/max/600/1*CcQPggEbLgej32mVF2lalg.png)

接下来我们将学习单隐层网络（译者注：单隐层即原文中的 2-layer NN）中的核心功能部分。

如果人工神经网络对你来说很陌生，那你可以先读一读[他们是如何工作的](https://medium.com/@gk_/how-neural-networks-work-ff4c7ad371f7).

我们使用 [numpy](http://www.numpy.org/)，因为它可以提供快速的矩阵乘法运算。

![](https://cdn-images-1.medium.com/max/600/1*8SJcWjxz8j7YtY6K-DWxKw.png)

我们使用 sigmoid 函数做激活函数，用它的导数进行错误率的衡量。在错误率到达理想的较低水平前，反复迭代并调整权重。

此外，下面我们编写了我们的词袋模型函数，将输入的一句话转为由 0 和 1 组成的数组。这是我们转换训练数据形式的重要一步，完成它非常关键。

![](https://ww4.sinaimg.cn/large/006y8lVagy1fcfetz7xn9j312w1leag3.jpg)

接下来编写神经网络训练函数来获取连接权重，先别激动，这也就是高中数学课级别的矩阵乘法而已。

![](https://ww2.sinaimg.cn/large/006y8lVagy1fcfexdjb5qj312w2ohqg4.jpg)


credit Andrew Trask [https://iamtrask.github.io//2015/07/12/basic-python-network/](https://iamtrask.github.io//2015/07/12/basic-python-network/) （编者注：由于排版的原因导致上图中的代码没有显示完整，如需查看完整代码请访问 [gist.github.com/ugik/70e055894f686bbbe1d052c649799148#file-text_ann_part6](https://gist.github.com/ugik/70e055894f686bbbe1d052c649799148#file-text_ann_part6)）

现在我们准备好建立第一个神经网络**模型**了。我们将把连接权重数据存为单独的 JSON 数据文件。

你应该尝试不同的 alpha (梯度下降参数，译者：通常称为学习率) 并且观察它是如何影响错误率的。这个参数帮助我们调整错误并找到错误率最低的情况：

synapse_0 += **alpha** * synapse\_0\_weight\_update

![](https://cdn-images-1.medium.com/max/800/1*HZ-YQpdBM4hDbh4Q5FcsMA.png)

在隐层中我们使用了 20 个神经元，你可以很简单的调整这个数量。它的数量主要取决于你数据的维度和量级。通过调整你可以达到大约 10^-3 的错误率结果。

![](https://ww3.sinaimg.cn/large/006y8lVagy1fcff04a6v1j31540fs40c.jpg)

    Training with 20 neurons, alpha:0.1, dropout:False
    Input matrix: 12x26    Output matrix: 1x3
    delta after 10000 iterations:0.0062613597435
    delta after 20000 iterations:0.00428296074919
    delta after 30000 iterations:0.00343930779307
    delta after 40000 iterations:0.00294648034566
    delta after 50000 iterations:0.00261467859609
    delta after 60000 iterations:0.00237219554105
    delta after 70000 iterations:0.00218521899378
    delta after 80000 iterations:0.00203547284581
    delta after 90000 iterations:0.00191211022401
    delta after 100000 iterations:0.00180823798397
    saved synapses to: synapses.json
    processing time: 6.501226902008057 seconds

synapse.json 文件中包括了我们需要的所有连接权重数据，**这就是我们的模型**

![](https://cdn-images-1.medium.com/max/800/1*qYkCgPE3DD26VD-qDwsicA.jpeg)

这个 **classify()** 函数是连接权重计算完毕后我们唯一所需要的了：十几行代码而已。

备注：如果训练数据有变化，我们的模型也需要重新计算。对于一个较大的训练数据量来说，这个过程可能会非常耗时。

现在我们可以生成关于一个句子属于某一类（或者分属某几类）的概率了。因为这只是一些我们在 **think()** 函数中定义好的点乘计算，所以速度非常快。

![](https://ww2.sinaimg.cn/large/006y8lVagy1fcff0v3wnqj31640zwn31.jpg)

    **sudo make me a sandwich **
     [['sandwich', 0.99917711814437993]]
    **how are you today? **
     [['greeting', 0.99864563257858363]]
    **talk to you tomorrow **
     [['goodbye', 0.95647479275905511]]
    **who are you? **
     [['greeting', 0.8964283843977312]]
    **make me some lunch**
     [['sandwich', 0.95371924052636048]]
    **how was your lunch today? **
     [['greeting', 0.99120883810944971], ['sandwich', 0.31626066870883057]]

你可以用其它语句、不同概率来试验几次，也可以添加训练数据来改进／扩展当前的模型。多加小心 看这里用很少的训练数据就得出了好的结果。

有一些句子将会有多个预测结果输出（高于阈值）。你需要给你的程序设定一个合适的阈值。并不是每个分类情景都是一样的：**有些类别比其他类别需要更大的置信水平**。 

最后这个分类结果向我们展示了一些内部的细节：

    found in bag: good
    found in bag: day
    sentence: **good day**
     bow: [0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    good day
     [['greeting', 0.99664077655648697]]

从这个句子的词袋中可以看到，有两个单词和我们的词库是匹配的。同时我们的神经网络从这些 0 代表的非匹配词语中学习了。

如果提供一个仅仅有一个常用单词 ‘a’ 被匹配的句子，那我们会得到一个低概率的分类结果A：

    found in bag: a
    sentence: **a burrito! **
     bow: [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    a burrito!
     [['sandwich', 0.61776860634647834]]

现在你已经掌握了一些构建聊天机器人的基础知识结构。当你明白了如何处理大量不同类别的任务，并用有限的数据（模式）去完成对它们的适配之后。给一个目标添加几个相应的预测结果是轻而易举的。

#### 午时已到!

![](https://cdn-images-1.medium.com/max/800/1*qfqiMxeF2coed4oBign6IQ.jpeg)
