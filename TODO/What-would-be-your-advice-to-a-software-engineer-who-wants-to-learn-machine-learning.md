> * 原文地址：[What would be your advice to a software engineer who wants to learn machine learning?](https://www.quora.com/What-would-be-your-advice-to-a-software-engineer-who-wants-to-learn-machine-learning-3/answer/Alex-Smola-1)
> * 原文作者：[Alex Smola](https://www.quora.com/profile/Alex-Smola-1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/What-would-be-your-advice-to-a-software-engineer-who-wants-to-learn-machine-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO/What-would-be-your-advice-to-a-software-engineer-who-wants-to-learn-machine-learning.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[吃土小2叉](https://github.com/xunge0613),[Tina92](https://github.com/Tina92)

# 你会给想学习机器学习的软件工程师提出什么建议？

这很大一部分都取决于这名软件工程师的背景，以及他希望掌握机器学习的哪一部分。为了具体讨论，现在假设这是一名初级工程师，他读了 4 年本科，从业 2 年，现在想从事计算广告学（CA）、自然语言处理（NLP）、图像分析、社交网络分析、搜索、推荐排名相关领域。现在，让我们从机器学习的必要课程开始讨论（声明：下面的清单很不完整，如果您的论文没有被包括在内，提前向您抱歉）。

- 线性代数
  很多的机器学习算法、统计学原理、模型优化都依赖线性代数。这也解释了为何在深度学习领域 GPU 要优于 CPU。在线性代数方面，你至少得熟练掌握以下内容：

  - 标量、向量、矩阵、张量。你可以将它们看成零维、一维、二维、三维与更高维的对象，可以对它们进行各种组合、变换，就像乐高玩具一样。它们为数据变换提供了最基础的处理方法。
  - 特征向量、标准化、矩阵近似、分解。实质上这些方法都是为了方便线性代数的运算。如果你想分析一个矩阵是如何运算的（例如检查神经网络中梯度消失问题，或者检查强化学习算法发散的问题），你得了解矩阵与向量应用了多少种缩放方法。而低阶矩阵近似与 Cholesky 分解可以帮你写出性能更好、稳定性更强的代码。
  - 数值线性代数
    如果你想进一步优化算法的话，这是必修课。它对于理解核方法与深度学习很有帮助，不过对于图模型及采样来说它并不重要。
  - 推荐书籍
    [《Serge Lang, Linear Algebra》](http://www.amazon.com/Linear-Algebra-Undergraduate-Texts-Mathematics/dp/0387964126)
    很基础的线代书籍，很适合在校学生。
    [《Bela Bolobas, Linear Analysis》](http://www.amazon.com/Linear-Analysis-Introductory-Cambridge-Mathematical/dp/0521655773)
    这本书目标人群是那些想做数学分析、泛函分析的人。当然它的内容更加晦涩难懂，但更有意义。如果你攻读 PhD，值得一读。
    [《Lloyd Trefethen and David Bau, Numerical Linear Algebra》](http://www.amazon.com/Numerical-Linear-Algebra-Lloyd-Trefethen/dp/0898713617)
    这本书是同类书籍中较为推荐的一本。[《Numerical Recipes》](http://www.amazon.com/Numerical-Recipes-Scientific-Computing-Second/dp/0521431085/)也是一本不错的书，但是里面的算法略为过时了。另外，推荐 Golub 和 van Loan 合著的书[《Matrix Computations》](http://www.amazon.com/Computations-Hopkins-Studies-Mathematical-Sciences/dp/1421407949/)。

- 优化与基础运算

  大多数时候提出问题是很简单的，而解答问题则是很困难的。例如，你想对一组数据使用线性回归（即线性拟合），那么你应该希望数据点与拟合线的距离平方和最小；又或者，你想做一个良好的点击预测模型，那么你应该希望最大程度地提高用户点击广告概率估计的准确性。也就是说，在一般情况下，我们会得到一个客观问题、一些参数、一堆数据，我们要做的就是找到通过它们解决问题的方法。找到这种方法是很重要的，因为我们一般得不到闭式解。

  - 凸优化

    在大多情况下，优化问题不会存在太多的局部最优解，因此这类问题会比较好解决。这种“局部最优即全局最优”的问题就是凸优化问题。

    （如果你在集合的任意两点间画一条直线，整条线始终在集合范围内，则这个集合是一个凸集合；如果你在一条函数曲线的任意两点间画一条直线，这两点间的函数曲线始终在这条直线之下，则这个函数是一个凸函数）

    Steven Boyd 与 Lieven Vandenberghe [合著的书](http://stanford.edu/~boyd/cvxbook/)可以说是这个领域的规范书籍了，这本书非常棒，而且是免费的，值得一读；此外，你可以在 [Boyd 的课程](http://web.stanford.edu/~boyd/)中找到很多很棒的幻灯片；[Dimitri Bertsekas](http://www.mit.edu/~dimitrib/home.html) 写了一系列关于优化、控制方面的书籍。读通这些书足以让任何一个人在这个领域立足。

  - 随机梯度下降（SGD）

    大多数问题其实最开始都是凸优化问题的特殊情况（至少早期定理如此），但是随着数据的增加，凸优化问题的占比会逐渐减少。因此，假设你现在得到了一些数据，你的算法将会需要在每一个更新步骤前将所有的数据都检查一遍。

    现在，我不怀好意地给了你 10 份相同的数据，你将不得不重复 10 次没有任何帮助的工作。不过在现实中并不会这么糟糕，你可以设置很小的更新迭代步长，每次更新前都将所有的数据检查一遍，这种方法将会帮你解决这类问题。小步长计算在机器学习中已经有了很大的转型，配合上一些相关的算法会使得解决问题更加地简单。

    不过，这样的做法对并行化计算提出了挑战。我们于 2009 年发表的[《Slow Learners are Fast》](http://arxiv.org/abs/0911.0491)论文可能就是这个方向的先导者之一。2013 年牛峰等人发表的[《Hogwild》](https://www.eecs.berkeley.edu/~brecht/papers/hogwildTR.pdf)论文给出了一种相当优雅的无锁版本变体。简而言之，这类各种各样的算法都是通过在单机计算局部梯度，并异步更新共有的参数集实现并行快速迭代运算。

    随机梯度下降的另一个难题就是如何控制过拟合（例如可以通过正则化加以控制）。另外还有一种解决凸优化的惩罚方式叫近端梯度算法（PGD）。最流行的当属 Amir Beck 和 Marc Teboulle 提出的 [FISTA 算法](http://people.rennes.inria.fr/Cedric.Herzet/Cedric.Herzet/Sparse_Seminar/Entrees/2012/11/12_A_Fast_Iterative_Shrinkage-Thresholding_Algorithmfor_Linear_Inverse_Problems_(A._Beck,_M._Teboulle)_files/Breck_2009.pdf)了。相关代码可以参考 Francis Bach 的 [SPAM toolbox](http://spams-devel.gforge.inria.fr/)。

  - 非凸优化方法

    许多的机器学习问题是非凸的。尤其是与深度学习相关的问题几乎都是非凸的，聚类、主题模型（topic model）、潜变量方法（latent variable method）等各种有趣的机器学习方法也是如此。一些最新的加速技术将对此有所帮助。例如我的学生 [Sashank Reddy](http://www.cs.cmu.edu/~sjakkamr/) 最近展示了如何在这种情况下得到良好的[收敛](http://arxiv.org/abs/1603.06160)[速率](http://arxiv.org/abs/1603.06159)。

    也可以用一种叫做谱学习算法（Spectral Method）的技术。[Anima Anandkumar](http://newport.eecs.uci.edu/anandkumar/) 在最近的 [Quora session](/profile/Anima-Anandkumar-1) 中详细地描述了这项技术的细节。请仔细阅读她的文章，因为里面干货满满。简而言之，凸优化问题并不是唯一能够可靠解决的问题。在某些情况中你可以试着找出其问题的数学等价形式，通过这样找到能够真正反映数据中聚类、主题、相关维度、神经元等一切信息的参数。如果你愿意且能够将一切托付给数学解决，那是一件无比伟大的事。

    最近，在深度神经网络训练方面涌现出了各种各样的新技巧。我将会在下面介绍它们，但是在一些情况中，我们的目标不仅仅是优化模型，而是找到一种特定的解决方案（就好像旅途的重点其实是过程一样）。

- （分布式）系统

  机器学习之所以现在成为了人类、测量学、传感器及数据相关领域几乎是最常用的工具，和过去 10 年规模化算法的发展密不可分。[Jeff Dean](http://research.google.com/pubs/jeff.html) 过去的一年发了 6 篇机器学习教程并不是巧合。在此简单介绍一下他：[点击查看](http://www.informatika.bg/jeffdean)，他是 MapReduce、GFS 及 BigTable 等技术背后的创造者，正是这些技术让 Google 成为了伟大的公司。

  言归正传，（分布式）系统研究为我们提供了分布式、异步、容错、规模化、简单（Simplicity）的宝贵工具。最后一条“简单”是机器学习研究者们常常忽视的一件事。简单（Simplicity）不是 bug，而是一种特征。下面这些技术会让你受益良多：

  - 分布式哈希表

    它是 [memcached](https://memcached.org/)、[dynamo](http://www.allthingsdistributed.com/files/amazon-dynamo-sosp2007.pdf)、[pastry](http://research.microsoft.com/en-us/um/people/antr/PAST/pastry.pdf) 以及 [ceph](http://docs.ceph.com/docs/hammer/rados/) 等的技术基础。它们所解决的都是同一件事情 —— 如何将对象分发到多台机器上，从而避免向中央存储区提出请求。为了达到这个目的，你必须将数据位置进行随机但确定的编码（即哈希）。另外，你需要考虑到当有机器出现故障时的处理方式。

    我们自己的参数服务器就是使用这种[数据布局](https://www.cs.cmu.edu/~dga/papers/osdi14-paper-li_mu.pdf)。这个项目的幕后大脑是我的学生 [Mu Li](http://www.cs.cmu.edu/~muli/) 。请参阅 [DMLC](http://dmlc.ml/) 查看相关的工具集。

  - 一致性与通信

    这一切的基础都是 Leslie Lamport 的 [PAXOS](http://research.microsoft.com/en-us/um/people/lamport/pubs/paxos-simple.pdf) 协议。它解决了不同机器（甚至部分机器不可用）的一致性问题。如果你曾经使用过版本控制工具，你应该可以直观地明白它是如何运行的——比如你有很多机器（或者很多开发者）都在进行数据更新（或更新代码），在它们（他们）不随时进行交流的情况下，你会如何将它们（他们）结合起来（不靠反复地求 diff）?

    在（分布式）系统中，解决方案是一个叫做向量时钟的东西（请参考 Google 的 [Chubby](http://blogoscoped.com/archive/2008-07-24-n69.html)）。我们也在参数服务器上使用了这种向量时钟的变体，这个变体与本体的区别就是我们仅使用向量时钟来限制参数的范围（Mu Li 做的），这样可以确保内存不会被无限增长的向量时钟时间戳给撑爆，正如文件系统不需要给每个字节都打上时间戳。

  - 容错机制、规模化与云

    学习这些内容最简单的方法就是在云服务器上运行各种算法，至于云服务可以找 [Amazon AWS](http://aws.amazon.com)、[Google GWC](http://console.google.com)、[Microsoft Azure](http://azure.microsoft.com) 或者 [其它各种各样的服务商](http://serverbear.com/)。一次性启动 1,000 台服务器，意识到自己坐拥如此之大的合法“僵尸网络”是多么的让人兴奋！之前我在 Google 工作，曾在欧洲某处接手 5,000 余台高端主机作为主题模型计算终端，它们是我们通过能源法案获益的核电厂相当可观的一部分资源。我的经理把我带到一旁，偷偷告诉我这个实验是多么的昂贵……

    可能入门这块最简单的方法就是去了解 [docker](http://www.docker.com) 了吧。现在 docker 团队已经开发了大量的规模化工具。特别是他们最近加上的 [Docker Machine](https://docs.docker.com/machine/) 和 [Docker Cloud](https://docs.docker.com/cloud/)，可以让你就像使用打印机驱动一样连接云服务。

  - 硬件

    说道硬件可能会让人迷惑，但是如果你了解你的算法会在什么硬件上运行，对优化算法是很有帮助的。这可以让你知道你的算法是否能在任何条件下保持巅峰性能。我认为每个入门者都应该看看 Jeff Dean 的 [《每个工程师都需要记住的数值》](https://gist.github.com/jboner/2841832)。我在面试时最喜欢的问题（至少现在最喜欢）就是“请问你的笔记本电脑有多快”。了解是什么限制了算法的性能是很有用的：是缓存？是内存带宽？延迟？还是磁盘？或者别的什么？[Anandtech](http://www.anandtech.com) 在微处理器架构与相关方面写了很多很好的文章与评论，在 Intel、ARM、AMD 发布新硬件的时候不妨去看一看他的评论。

- 统计学

  我故意把这块内容放在文章的末尾，因为几乎所有人都认为它是（它的确是）机器学习的关键因而忽视了其它内容。统计学可以帮你问出好的问题，也能帮你理解你的建模与实际数据有多接近。

  大多数图模型、核方法、深度学习等都能从“问一个好的问题”得到改进，或者说能够定义一个合理的可优化的目标函数。

  - 统计学相关资料
    [Larry Wasserman](http://www.stat.cmu.edu/~larry/) 的书[《All of Statistics》](http://www.stat.cmu.edu/~larry/all-of-statistics/)很好地介绍了统计学。或者你也可以看看 David McKay 的 [《Machine Learning》](http://www.inference.phy.cam.ac.uk/itprnn/book.pdf)一书，它是免费的，内容丰富而全面。此外还有很多好书值得一看，例如 [Kevin Murphy](https://mitpress.mit.edu/books/machine-learning-0) 的、[Chris Bishop](http://research.microsoft.com/en-us/um/people/cmbishop/prml/) 的、以及 [Trevor Hastie、Rob Tibshirani 与 Jerome Friedman](http://statweb.stanford.edu/~tibs/ElemStatLearn/) 合著的书。还有，Bernhard Scholkopf 和我也[写了一本](https://mitpress.mit.edu/books/learning-kernels)。

  - 随机算法与概率计算

    统计学算法本质上也是个计算机科学方面的问题。但是统计学的算法与计算机科学的最大区别在于，统计学是将计算机作为一个工具来设计算法，而不是作为一个黑箱进行调参。我很喜欢[这本 Michael Mitzenmacher 与 Eli Upfal 合著的书](http://www.amazon.com/Probability-Computing-Randomized-Algorithms-Probabilistic/dp/0521835402)，它涵盖了很多方面的问题，并且很容易读懂。另外如果你想更深入地了解这个“工具”，请阅读[这本 Rajeev Motwani 和 Prabhakar Raghavan 合著的书籍](http://www.amazon.com/Randomized-Algorithms-Rajeev-Motwani/dp/0521474655)。这本书写的很棒，但是没有统计学背景很难理解它。

这篇文章已经写的够久了，不知道有没有人能读到这里，我要去休息啦。现在网上有很多很棒的视频内容可以帮助你学习，许多教师现在都开通了他们的 Youtube 频道，上传他们的上课内容。这些课程有时可以帮你解决一些复杂的问题。这儿是[我的 Youtube 频道](https://www.youtube.com/user/smolix/playlists)欢迎订阅。顺便推荐 [Nando de Freitas 的 Youtube 频道](https://www.youtube.com/user/ProfNandoDF)，他比我讲得好多了。

最后推荐一个非常好用的工具：[DMLC](http://www.dmlc.ml)。它很适合入门，包含了大量的分布式、规模化的机器学习算法，还包括了通过 MXNET 实现的神经网络。

虽然本文还有很多方面没有提到（例如编程语言、数据来源等），但是这篇文章已经太长了，这些内容请参考其他文章吧~

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
