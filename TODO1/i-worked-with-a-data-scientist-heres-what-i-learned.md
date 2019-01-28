> * 原文地址：[I Worked With A Data Scientist As A Software Engineer. Here’s My Experience.](https://towardsdatascience.com/i-worked-with-a-data-scientist-heres-what-i-learned-2e19c5f5204)
> * 原文作者：[Ben Daniel A.](https://towardsdatascience.com/@bendaniel10)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/i-worked-with-a-data-scientist-heres-what-i-learned.md](https://github.com/xitu/gold-miner/blob/master/TODO1/i-worked-with-a-data-scientist-heres-what-i-learned.md)
> * 译者：[寒食君](https://github.com/CasualJi)
> * 校对者：

# 我作为软件工程师与一名数据科学家合作的经历

本文我将谈一谈我作为一名Java/Kotlin工程师与一位数据科学家共事的经历。

![](https://cdn-images-1.medium.com/max/2560/0*V-3j85eeM0dGnd-o)

Photo by [Daniel Cheung](https://unsplash.com/@danielkcheung?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

#### 背景

在2017年，机器学习领域激发了我的兴趣。我曾[谈及过我入门时的经历](https://medium.com/@bendaniel10/hello-machine-learning-cc89b3ccbe4d)。总的来说，它充满了有趣的挑战同时也教给了我大量的知识。我是一名安卓工程师，这是我与一位数据科学家共事一项关于机器学习项目的工作经历。

我记得我曾经试图解决一个出现在我司一款应用中有关图像分类的问题，我们需要根据一组已定义的规则去辨别有效与无效的图像。我立即从Deeplearning4J (dl4j)中改进了这个[案例](https://github.com/deeplearning4j/dl4j-examples/blob/master/dl4j-examples/src/main/java/org/deeplearning4j/examples/convolution/AnimalsClassification.java),并且试图用它去处理这个分类任务。虽然我没有获得预期的结果，但我保持着乐观心态。

![](https://i.loli.net/2019/01/08/5c34b6733de77.png)

由于最终获得的训练模型的大小存在问题，我使用dlf4j中示例代码的方法没有奏效。之所以失败，是因为我们需要一个能够达到压缩文件大小的模型，这对移动设备来说特别重要。

#### 数据科学家的加入

![](https://cdn-images-1.medium.com/max/600/0*zKBeymXEf00uZbZZ)

Photo by [rawpixel](https://unsplash.com/@rawpixel?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

就在这个时候，我们聘请了一位数据科学家，他拥有非常丰富的相关经验，我后来从他那里学到了很多。当发现大部分机器学习的问题可以通过Python解决时，我只好不情愿地学起了这门语言的基础知识。后来我发现很多问题使用Python更容易实现，这是由于Python社区对机器学习提供了巨大的支持。

我们从小型课堂学起，就在这时，我们团队的其他成员也因为兴趣加入了进来。数据科学家向我们介绍了[Jupyter Notebooks](https://jupyter.org/install)和[Cloud Machine Learning Engine](https://cloud.google.com/ml-engine/docs/tensorflow/getting-started-training-prediction)。我们立即行动起来，着手尝试这个使用[花卉的数据集](https://cloud.google.com/ml-engine/docs/tensorflow/flowers-tutorial)来进行图像分类的案例。

当所有团队成员都掌握了训练和部署模型的基础知识后，我们迈向那些等待解决的问题。作为团队成员，我目前专注于两项任务：图像分类和分割问题,它们之后都将通过卷积神经网络（CNNs）来实现。

#### 准备训练数据并不简单

![](https://cdn-images-1.medium.com/max/600/0*GllGs9LmPto_7-_U)

Photo by [Jonny Caspari](https://unsplash.com/@jonnysplsh?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

这两项任务都需要大量的训练数据。好消息是我们已经拥有了很多数据，但坏消息是它们都是未排序或未注释的。我终于明白了机器学习专家所说的：机器学习的大量时间都花费在准备训练数据而不是训练模型本身。

为了图像分类任务，我们需要将数十万的图像分门别类，这是一项单调的工作，我不得不借助我Java Swing的技能来编写一些用户图形界面来使这项工作简单一些。总而言之，这项任务对于任何参与者都是枯燥无聊的。

分割过程更复杂一点儿。幸运的是，我们找到了一些易于分割的模型，但不幸的是，它们太大了。同时，我们还想让模型能够在较低版本的安卓设备上运行。那位数据科学家灵光一闪，他建议我们使用这个大模型来生成训练数据，再使用这些数据来构建我们自己的移动网络。

#### 训练

我们最终转向了[AWS Deep Learning AMI](https://docs.aws.amazon.com/dlami/latest/devguide/launch-config.html)。 AWS使我们感到省心，它提供的这项服务更为方便。训练图像分割模型的过程由我们的数据科学家全权负责，而我就站在他身边，书写笔记:)。

![](https://i.loli.net/2019/01/08/5c34b6d806f4f.png)

这些不是真实的日志, 哈哈.

训练模型是一项计算密集的任务，这让我理解了用于训练的计算机拥有充足的GPU和RAM的重要性。此次训练的时间很短，因为我们使用了这样的计算机集群，如果使用普通计算机，这将花费几周甚至几个月的时间。

我处理了图像分类模型的训练，不必在云服务上训练它，事实上，我使用了我自己的MacBook Pro。这是因为相较于为分割模型所做的全网络训练，我只训练了神经网络的最后一层。

#### 部署生产环境

在经过严格测试后，两项模型都部署在了我们的生产环境。一名团队成员负责构建Java包装类库，这样是为了使这些模型能够以一种抽象的方式被使用，这种方式抽象化了向模型提供图像和从张量中提取有效结果的复杂性。这是一个包含了模型对单个图像所做的预测的结果集。这个阶段中我也参与了一些工作，优化和重构了我曾经写过的一些代码。

#### 挑战无处不在

> 挑战使生活充满趣味，战胜它们使生活更有意义。 ——佚名

我依然记得最大的挑战是三维数组，我需要十分谨慎地处理它们。与我们的数据科学家一同研究机器学习项目鼓舞着我继续机器学习之路。

在为这些项目工作时，我遇到的最大的挑战是试图使用Bazel从源码中构建用于32位系统的Tensorflow Java 类库，遗憾的是，我始终没有成功。

![](https://i.loli.net/2019/01/08/5c34b69bf3c36.png)

我也经历了其他一些挑战，有一项比较常见：将Python的解决方案翻译为Java。由于Python已经内置了对于数据科学任务的诸多支持，所以Python代码更简洁。我依然记得当我试图逐字翻译一条命令时的紧张：scaling a 2D array and adding it as a transparent layer to an image。最终指令生效了，大家兴奋异常。

现在，通常情况下这些模型在生产环境运行稳定，但是一旦它产生了错误结果，将会错得非常离谱。这让我想起了我在一篇[优秀文章](https://www.oreilly.com/ideas/lessons-learned-turning-machine-learning-models-into-real-products-and-services)中读到的关于如何将机器学习模型投入真实生产和服务的引言：

> 如果不持续提供新数据，模型的质量将会很快降低。正如[漂移概念](https://machinelearningmastery.com/gentle-introduction-concept-drift-machine-learning/)所说的，随着时间的推移，静态机器学习模型提供的预测将变得不再那么准确和有效。某些情况下，这甚至可能在几天内发生。 ————David Talby

这意味着我们不得不保持模型优化，且没有终点，这听上去很有趣。

* * *

我不确定我能否被称之为机器学习新手，因为我更关注移动开发。与机器学习团队共同研究训练模型来为公司解决问题的这段经历，让我十分激动。我期待下一次机会。

感谢 TDS Team 和 Alexis McKenzie。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
