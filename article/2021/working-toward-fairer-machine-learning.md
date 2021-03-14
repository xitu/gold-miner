> * 原文地址：[Working toward fairer machine learning](https://www.amazon.science/research-awards/success-stories/algorithmic-bias-and-fairness-in-machine-learning)
> * 原文作者：[Michele Donini](https://www.amazon.science/author/michele-donini), Luca Oneto
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/working-toward-fairer-machine-learning.md](https://github.com/xitu/gold-miner/blob/master/article/2021/working-toward-fairer-machine-learning.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：

# 让机器学习更加公平

编者注：[Michele Donini](https://www.linkedin.com/in/michele-donini-2484734a/) 是 Amazon Web Services（AWS）的一名高级应用科学家。他和他的合著者热那亚大学计算机工程学副教授 [Luca Oneto](https://www.lucaoneto.com/)，已经论述了关于不同方法如何使数据驱动型预测对代表性不足的群体更公平的文章。Oneto 也因自己在算法公平性方面的工作而获得了[ 2019 机器学习研究奖](https://www.amazon.science/research-awards/recipients/luca-oneto)。在本文中，Donini 和 Oneto 讨论了他们和其他合作者发表的、关于从以人为中心的角度去设计机器学习（ML）模型以及构建负责任的人工智能的研究。

## 什么是公平？

可以用许多不同的方式来定义公平，并且存在许多不同的概念形式，例如人口统计学均等，机会均等和机率均等。

>![https://assets.amazon.science/dims4/default/17fefc0/2147483647/strip/true/crop/1011x482+483+231/resize/1200x572!/quality/90/?url=http%3A%2F%2Famazon-topics-brightspot.s3.amazonaws.com%2Fscience%2Fc6%2F43%2F2f4c0fe14b0ab3a96733fd3ccfe2%2Funfair-fair-test.png](https://assets.amazon.science/dims4/default/17fefc0/2147483647/strip/true/crop/1011x482+483+231/resize/1200x572!/quality/90/?url=http%3A%2F%2Famazon-topics-brightspot.s3.amazonaws.com%2Fscience%2Fc6%2F43%2F2f4c0fe14b0ab3a96733fd3ccfe2%2Funfair-fair-test.png)
>
>算法的公平性是一个非常重要的主题，对许多应用都有影响。这个问题需要进一步研究。对于机器学习模型而言，“公平”的定义仍然是一个开放的研究问题。

然而，关于公平普遍接受的想法是，学习到的机器学习模型无论是应用于人口的哪一个子群体（例如男性群体或女性群体），其表现都应相同或至少类似。

以人口统计学均等这一最常见的公平概念为例（有争议），它表示机器学习模型的某个输出（例如，决定贷款）的概率不应该取决于人口特定的属性值（例如性别，种族或年龄）。

## 让模型更公平

从广义上讲，我们可以将现有关于算法公平性的文献归纳为三类：

- 第一种方法是先对数据进行预处理以消除历史偏差，然后再将数据提供给经典的机器学习模型。
- 第二种方法是对已有的机器学习模型进行后处理。当需要使用复杂的机器学习模型而又不能改变其内部结构，或者重新训练它们不可行（由于计算成本或时间要求）时，此类方法很有用。
- 第三种方法，称为在线处理，是通过在模型的学习阶段施加特定的统计约束来实现公平性。这是最自然的方法，但是到目前为止，它需要针对特定的任务和数据集来量身定制临时解决方案。

>![https://assets.amazon.science/dims4/default/aa34f7f/2147483647/strip/true/crop/200x350+0+0/resize/1200x2100!/quality/90/?url=http%3A%2F%2Famazon-topics-brightspot.s3.amazonaws.com%2Fscience%2Fb4%2F95%2Fd15206d54c978c00acc956a066bb%2Flearn-fair-models-copy.png](https://assets.amazon.science/dims4/default/aa34f7f/2147483647/strip/true/crop/200x350+0+0/resize/1200x2100!/quality/90/?url=http%3A%2F%2Famazon-topics-brightspot.s3.amazonaws.com%2Fscience%2Fb4%2F95%2Fd15206d54c978c00acc956a066bb%2Flearn-fair-models-copy.png)
>
>Broadly speaking, current literature on algorithmic fairness falls into three main approaches: pre-processing data; post-processing an already learned ML model; and in-processing, which consists of enforcing fairness notions by imposing specific statistical constraints during the learning phase of the model.

We decided to explore and analyze possible techniques to make ML algorithms capable of learning fairer models.

We started from the base concepts of statistical learning theory — a mathematical framework for describing machine learning — and, in particular, from empirical risk minimization theory. The core concept of empirical risk minimization is that a model’s performance on test data may not accurately predict its performance on real-world data, as the real-world data may have a different probability distribution.

Empirical-risk-minimization theory provides a way to estimate the “true risk” of a model from its “empirical risk”, which can be computed from the available data. We extended this concept to the true and empirical fairness risk of ML models.

Below is a summary of three papers we’ve published related to these topics.

**“[Empirical risk minimization under fairness constraints](https://arxiv.org/pdf/1802.08626.pdf)”**

This paper presents a new in-processing method, meaning that we incorporate a fairness constraint into the learning problem. We derive theoretical guarantees on both the accuracy and fairness of the resulting models, and we show how to apply our method to a large family of machine learning algorithms, including linear models and [support vector machines for classification](https://scikit-learn.org/stable/modules/svm.html#svm-classification) (a widely used supervised-learning method).

We observe that, in practice, we can meet our fairness constraint simply by requiring that a scalar product between two vectors remains small (an orthogonality constraint between the vector of the weights describing our model and the vector describing the discrimination between the different subgroups). We further observe that, for linear models, this requirement translates into a simple pre-processing method. Experiments indicate that our approach is empirically effective and performs favorably against state-of-the-art approaches.

**“[Fair regression with Wasserstein barycenters](https://arxiv.org/pdf/2006.07286.pdf)”**

In this paper, we consider the case in which the ML model learns a regression function (as opposed to a classification task). We propose a post-processing method for transforming a real-valued regression function — the ML model — into one that satisfies the demographic-parity constraint (i.e., the probability of getting a positive outcome should be virtually the same for different subgroups). In particular, the new regression function is as good an approximation of the original as is possible while still satisfying the constraint, making it an optimal fair predictor.

>![](https://assets.amazon.science/dims4/default/193689d/2147483647/strip/true/crop/250x310+0+0/resize/1200x1488!/quality/90/?url=http%3A%2F%2Famazon-topics-brightspot.s3.amazonaws.com%2Fscience%2F30%2F64%2F814dbdbf42e8b57c5454be7be982%2Ffair-representation-copy.png)
>
>In “Fair regression with Wasserstein barycenters”, we consider the case in which the ML model learns a regression function and propose a post-processing method for transforming a real-valued regression function — the ML model — into one that satisfies the demographic-parity constraint.

We assume that the sensitive attribute — the demographic attribute that should not bias outcome — is available to the ML model at inference time and not only during training. We establish a connection between learning a fair model for regression and optimal transport theory, which describes how to measure distances among probability distributions. On that basis, we derive a closed-form expression for the optimal fair predictor.

Specifically, under the unfair regression function, different populations have different probability distributions; the function skews the probabilities for the population with the sensitive attribute. The difference between subgroups’ distributions can be calculated using the Wasserstein distance. We show that the mean of the distribution of the optimal fair predictor is the mean of the different subgroups’ distributions, as calculated using Wasserstein distance. This mean is known as the Wasserstein barycenter.

This result offers an intuitive interpretation of optimal fair prediction and suggests a simple post-processing algorithm to achieve fairness. We establish fairness-risk guarantees for this procedure. Numerical experiments indicate that our method is very effective in learning fair models, with a relative increase in error rate that is smaller than the relative gain in fairness.

**"[Exploiting MMD and Sinkhorn divergences for fair and transferable representation learning](https://www.amazon.science/publications/exploiting-mmd-and-sinkhorn-divergences-for-fair-and-transferable-representation-learning)”**

Where the first paper described a general learning method, and the second a regression method, this paper concerns deep learning. We show how to improve demographic parity in the multitask-learning setting, in which a deep-learning model learns a single representation of the input data that is useful for multiple tasks. We derive theoretical guarantees on the learned model, establishing that the representation will still reduce bias even when transferred to novel tasks.

We propose a learning algorithm that imposes constraints based on two different ways of measuring distances between probability distributions, maximum mean discrepancy and Sinkhorn divergence. Keeping this distance small ensures that we represent similar inputs in a similar way when they differ only on the sensitive attribute. We present experiments on three real-world datasets, showing that the proposed method outperforms state-of-the-art approaches by a significant margin.

Algorithmic fairness is a topic of great importance, with impact on many applications. In our work, we have attempted to take a small step forward, but the issue requires much further research; even the definition of what “being fair” means for an ML model is still an open research question.

It’s also becoming clearer that we need to keep humans in the loop during the lifecycle of ML models, to evaluate whether the models are acting as we would like them to. In this sense, it is important to note that many other research subjects – such as the explainability, interpretability, and privacy of ML models – are deeply connected to algorithmic fairness. They can work in synergy, with the common goal of increasing the trustworthiness of ML models.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---


> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
