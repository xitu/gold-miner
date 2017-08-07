
> * 原文地址：[Deep Learning #1: Setting up AWS & Image Recognition](https://medium.com/towards-data-science/deep-learning-1-1a7e7d9e3c07)
> * 原文作者：[Rutger Ruizendaal](https://medium.com/@r.ruizendaal)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-1-setting-up-aws-image-recognition.md](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-1-setting-up-aws-image-recognition.md)
> * 译者：[lileizhenshuai](https://github.com/lileizhenshuai)
> * 校对者：[Tina92](https://github.com/Tina92) [sqrthree](https://github.com/sqrthree)

# 深度学习系列1：设置 AWS & 图像识别

**这篇文章是深度学习系列的第一部分。你可以在[这里](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-2-convolutional-neural-networks.md)查看第二部分，以及[这里](https://github.com/xitu/gold-miner/blob/master/TODO/deep-learning-3-more-on-cnns-handling-overfitting.md)查看第三部分。**

![](https://cdn-images-1.medium.com/max/1600/1*y3guCmNkYLF2uR09Fslh5g.png)

本周的任务：对猫和狗的图像进行分类

欢迎阅读本系列第一篇关于实战深度学习的文章。在本文中，我将创建 Amazon Web Services（AWS）实例，并使用预先训练的模型对猫和狗的图像进行分类。

在这个完整的系列里，我会记录下我在 Fast AI 深度学习课程的第一部分内容的进度。这门课程最初是由旧金山大学数据研究所提供的，并且现在能够在 MOOC 上观看。最近，这门课的作者提供了第二部分的内容，并且在接下来的几个月都可以在网上观看。我上这门课的主要是因为我对深度学习有着强烈的兴趣。我在网上发现了许多关于机器学习的课程，但有关深度学习的实战课程还是比较少见的。深度学习似乎因为进入门槛略高一点，而被单独列出。开始深度学习之前我们首先需要一个 GPU，在这门课程里我们会使用 AWS 的 p2 实例。现在让我们一起来准备它。

这门课程第一周，我们会把重点放在准备工作上。正确地准备深度学习需要一点时间，但这对一切能正确运行很重要。这包括了设置 AWS，创建和配置 GPU 实例，设置 ssh 连接服务器以及管理你的目录。

我在实习期用的笔记本电脑上遇到了一些权限问题。我有个建议能够避免这个问题，从而帮你节省大量时间：在尝试操作之前，确保你在你的笔记本电脑上拥有完整的管理员权限。一些热情的工程师提出帮助我设置 GPU 实例，但是他们不能马上帮我搞定，所以我决定自己来。

用来设置 AWS 的脚本是用 bash 写的，如果你用的是 Windows 操作系统，那么你需要一个能够处理它的程序，我用的是 Cygwin。我想分享一些在设置过程中我遇到的问题（以及对应的解决方案）。如果你没有在上 Fast AI 课程，你可以跳过这部分继续阅读。我在设置过程中所遇到的问题有：

- bash 脚本报错

  我看过一些可能的原因，但是没有一个是对我有用的解决方案。Github 上这个课程的设置脚本有两个：setup_p2.sh 和 setup_instance.sh。如果上面那两个脚本不能用，你可以用[这个](https://github.com/ericschwarzkopf/courses/blob/dc06ce745a30850e7937858fb26a67df2aff329d/setup/setup_p2.sh)脚本试试。但如果这个脚本还是不行，请务必再尝试使用原始版本的脚本。

  我在 aws-alias.sh 这个脚本上也遇到了同样的问题，在第七行的末尾加上 `'` 能够解决这个问题。下面是修改前和修改后的第七行：

  > alias aws-state='aws ec2 describe-instances --instance-ids $instanceId --query "Reservations[0].Instances[0].State.Name"
  
  > alias aws-state='aws ec2 describe-instances --instance-ids $instanceId --query "Reservations[0].Instances[0].State.Name"'

  [这里](https://gist.github.com/LeCoupa/122b12050f5fb267e75f)有一个为不熟悉 Bash 的人准备的 Bash 备忘录，因为你需要通过 Bash 来和你的实例进行交互，所以我非常推荐你去看看。

- Anaconda 的安装。视频中提到你需要在安装 Cygwin 之前先安装 Anaconda。你可能感到有些疑惑，因为你需要用“Cygwin python”来运行 pip 命令而不是一个本地的 Anaconda 分发版。

另外，[这个](https://github.com/TomLous/practical-deep-learning)仓库有一个手把手的教程教你如何让你的实例运行起来。

---

#### 开始深度学习

解决了一些问题之后我总算让我的 GPU 实例运行起来了。是时候开始深度学习了！一个简短的免责声明：在这一系列博客中，我不会重复已经在课程笔记中列出的内容，因为没必要。我会强调一些我觉得很有趣的事情，以及我在课程中遇到的问题和一些想法。

让我们从第一个可能已经在你脑海中的问题开始：**什么是深度学习？它现在为什么被炒得这么火？**

深度学习只是一个有着多个隐含层的人造神经网络，隐含层让它变得“深度”。一般的神经网络只有一层或者两层的隐含层，而一个深度神经网络有更多的隐含层。它们也具有与一般神经网络中的“简单”层不同类型的层。

![](https://cdn-images-1.medium.com/max/1600/1*CcQPggEbLgej32mVF2lalg.png)

(浅) 神经网络

目前，深度学习在一些著名的数据集上不断地有着出色的表现，所以深度学习也经历了不少的炒作。深度学习的流行有三个原因：

- 无限灵活的函数
- 通用参数拟合
- 迅速以及可拓展

神经网络是通过模仿人脑而设计的。根据通用近似定理，它理论上能拟合任何函数。神经网络通过反向传播算法来训练，这使得我们能够调整模型的参数来适应不同的函数。最后一个原因，也是深度学习近期取得众多成就的主要原因。因为游戏行业的进步和 GPU 计算能力的强劲发展，现在我们以非常快速和可扩展的方式来训练深层的神经网络。

在第一节课里，我们的目标是使用一个叫做 Vgg16 的预先训练好的模型，来对猫和狗的图片进行分类。Vgg16 是 2014 年赢得 Imagenet 比赛模型的一个轻量级版本。这是一个年度的比赛并且可能是计算机视觉方面最大的一个比赛。我们可以利用这预先训练好的模型，并且把它应用到我们的猫和狗的图片数据集上。我们的数据集已经被课程的作者编辑过了，以确保它的格式正确。原始的数据集可以在 [Kaggle](https://www.kaggle.com/c/dogs-vs-cats) 上找到。这场比赛最初是在 2013 年进行的，那时的准确率是 80％。而我们的简单模型已经能够达到 97％的准确度。大脑现在还清醒吧？下面是一些照片和他们被预测的标记：

![](https://cdn-images-1.medium.com/max/1600/1*y3guCmNkYLF2uR09Fslh5g.png)

狗狗们和猫猫们被预测的标记

我们用叫做独热编码的方法来处理目标标记，这是分类问题中常用的方法。[1. 0.] 说明图片中是一只猫， [0. 1.] 则说明是一只狗。我们没有用一个叫做“目标”的有 0 和 1 两种取值的变量，而是创建了一个包含两个值的数组。你可以把这些变量看成“猫猫”和“狗狗”。如果变量为正，那么它就会被标记为 1，否则就是 0。在一个多分类问题中，这意味着你的输出向量可能长成这样：[0 0 0 0 0 0 0 1 0 0 0]。在这个例子中，Vgg16 模型会输出图片属于“猫”这个类别的可能性以及属于“狗”这个类别的可能性。接下来的一个挑战是调整这个模型，以便我们将其应用于另一个数据集。

---

#### **狗狗还是猫猫 终极版**

本质上这个数据集和先前的是同一个数据集，但是没有被课程作者预处理过。Kaggle 命令行接口（CLI）提供了一个快捷的方法来下载这个数据集，可以通过 pip 来安装。一个美元标志通常用来表示命令运行在终端中。

    $ pip install kaggle-cli

训练数据集中有 25000 张已经被标记为猫或是的狗的图片，测试数据集中则包含 12500 张未被标记的图片。为了调整参数，我们还通过占用训练集的一小部分来创建验证数据集。设置一个完整数据集的“样本”也很有用，可以用来快速检查你的模型在构建过程中是否正常工作。

我们使用 Keras 库来运行我们的模型，这个库是基于 Thenao 和 TensorFlow 的最流行的深度学习库之一。Keras 能够让你更加直观地来编写神经网络，这意味着你能够更多地关注神经网络的架构而不用担心 TensorFlow API。因为Keras 通过查看图片所属的目录来确定它的类别，所以把图片移动到正确的目录非常的重要。这些操作所需的 bash 命令可以直接在 Jupyter Notebook 中运行，也就是我们写代码的地方。[这个](https://www.cyberciti.biz/faq/mv-command-howto-move-folder-in-linux-terminal/)链接包含了额外的一些关于这些命令的信息。

一个 epoch，也就是在数据集完整地跑一遍，在我的 Amazon p2 实例上花费了 10 分钟时间。在这个例子里数据集是包含 23000 张图片的训练数据集，另外的 2000 张图片被保留下来作为验证数据集。在这里我决定使用 3 个 epoch。在验证数据集上的准确度在 98% 左右。训练好模型之后，我们可以看一些被正确分类的图片。在这个例子里，我们用图片中是一只猫的概率作为结果。1.0 表示模型非常自信地认为图片中是一只猫，而 0.0 则表示图片中是一只狗。

![](https://cdn-images-1.medium.com/max/1600/1*fgOX3G_imeRsodKuBBA8Tg.png)

被正确分类的图片

现在让我们来看一些被错误分类的图片。正如我们所见，这些图片大部分是从远处拍摄的，并且图片里有多种动物。原始的 Vgg 模型是用在图片中只有一种清晰可见目标类别中的。只有我觉得第四张图片有点可怕吗？

![](https://cdn-images-1.medium.com/max/1600/1*jD6t1ifVrrGq571eh5lqhA.png)

被错误分类的图片

最后，这些是模型对其类别最不确定的一些图片。这意味着概率非常接近 0.5（1 代表是一只猫而 0 代表是一只狗）。第四张图片中的猫只有一张脸露出来。第一张和第三张图片是长方形的而不是原模型训练集中的正方形。

![](https://cdn-images-1.medium.com/max/1600/1*zlSUpvspBf9zYm175uaY1w.png)

模型最不确定的图片

这就是这周的内容。就我个人而言，我已经迫不及待地想要开始第二周的课程并且学习更多关于这个模型的内部细节。希望我们也能开始利用 Keras 从头构建一个模型。

同时，感谢所有更新 GitHub 脚本的人，这可帮了大忙！另外也要感谢所有参与 Fast AI 论坛的人，你们太棒了。

如果你喜欢这篇文章，请把它推荐给你的朋友们，让更多人的看到它。你也可以按照这篇文章，跟上我在 Fast AI 课程中的进度。到时候那里见！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。

