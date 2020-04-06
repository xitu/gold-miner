> * 原文地址：[Active Learning in Machine Learning](https://towardsdatascience.com/active-learning-in-machine-learning-525e61be16e5)
> * 原文作者：[Ana Solaguren-Beascoa, PhD](https://medium.com/@ana.solagurenbeascoa)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/active-learning-in-machine-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO1/active-learning-in-machine-learning.md)
> * 译者：
> * 校对者：

# Active Learning in Machine Learning

> A brief introduction to the implementation of active learning

![Photo by [Markus Spiske](https://unsplash.com/@markusspiske?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11520/0*wvT88RaaNLyiCLt8)

Most supervised machine learning models require large amounts of data to be trained with good results. And even if this statement sounds naive, most companies struggle to provide their data scientists this data, in particular **labelled** data. The latter is key to train any supervised model and can become the main bottleneck for any data team.

In most cases, data scientists are provided with a big, unlabelled data sets and are asked to train well-performing models with them. Generally, the amount of data is too large to manually label it, and it becomes quite challenging for data teams to train good supervised models with that data.

## Active learning: Motivation

Active learning is the name used for the process of prioritising the data which needs to be labelled in order to have the highest impact to training a supervised model. Active learning can be used in situations where the amount of data is too large to be labelled and some priority needs to be made to label the data in a smart way.

**But, why don’t we just chose a random subset of data to manually label them?**

Let’s look at a very simple example to motivate the discussion. Assume we have millions of data points which need to be classified based on two features. The actual solution is shown in the following plot:

![Model prediction if all data points were labelled](https://cdn-images-1.medium.com/max/2000/1*Z_5GyCdFfcz_oVFnUuYczg.png)

As one can see, both classes (red and purple) can quite nicely be separated by a vertical blue line crossing at 0. The problem is that none of the data points are labelled, so the data is given to us as in the following plot:

![Unlabelled data](https://cdn-images-1.medium.com/max/2000/1*fmnhkOPVsXNIUiroRg2CfQ.png)

Unfortunately, we don’t have enough time to label all of the data and we randomly chose a subset of the data to label and train a binary classification model on it. The result is not great, as the model prediction deviates quite a lot from the optimal boundary.

![Model trained on a random subset of labelled data points](https://cdn-images-1.medium.com/max/2000/1*2bpj99Fppl2mqLb7Jb98XA.png)

This is where active learning can be used to optimise the data points chosen for labelling and training a model based on them. The following plot shows an example of training a binary classification model after choosing the training of the model based on data points labelled after implementing active learning.

![Model trained on a subset of data points chosen ho to be labelled using active learning](https://cdn-images-1.medium.com/max/2000/1*8eOKeWFNg29ruakj9b1Nzg.png)

Making a smart choice of which data points to prioritise when labelling can save data science teams large amounts of time, computation and headaches!

## Active learning strategy

#### Steps for active learning

There are multiple approaches studied in the literature on how to prioritise data points when labelling and how to iterate over the approach. We will nevertheless only present the most common and straightforward methods.

The steps to use active learning on an unlabelled data set are:

1. The first thing which needs to happen is that a very small subsample of this data needs to be manually labelled.
2. Once there is a small amount of labelled data, the model needs to be trained on it. The model is of course not going to be great but will help us get some insight on which areas of the parameter space need to be labelled first to improve it.
3. After the model is trained, the model is used to predict the class of each remaining unlabelled data point.
4. A score is chosen on each unlabelled data point based on the prediction of the model. In the next subsection we will present some of the possible scores most commonly used.
5. Once the best approach has been chosen to prioritise the labelling, this process can be iteratively repeated: a new model can be trained on a new labelled data set, which has been labelled based on the priority score. Once the new model has been trained on the subset of data, the unlabelled data points can be ran through the model to update the prioritisation scores to continue labelling. In this way, one can keep optimising the labelling strategy as the models become better and better.

#### Prioritisation scores

There are several approaches to assign a priority score to each data point. Below we describe the three basic ones.

**Least confidence:**

This is probably the most simple method. It takes the highest probability for each data point’s prediction, and sorts them from smaller to larger. The actual expression to prioritise using least confidence would be:

![](https://cdn-images-1.medium.com/max/2000/1*RJ0wYr0LXxpxezaUc_z75A.png)

![](https://cdn-images-1.medium.com/max/2000/1*7taQkELyPNhYFH6-JgMsGA.png)

Let’s use an example to see how this would work. Assume we have the following data with three possible classes:

![Table 1: Example of probability predictions of a model on three different classes for four different data points.](https://cdn-images-1.medium.com/max/6676/1*dUxgoL1aVNSyO1cP7C9riQ.png)

In this case, the algorithm would first chose the maximum probability for each data point, hence:

* X1: 0.9
* X2: 0.87
* X3:0.5
* X4:0.99.

The second step is to sort the data based on this maximum probability (from smaller to bigger), hence X3, X2, X1 and X4.

**Margin sampling:**

This method takes into account the difference between the highest probability and the second highest probability. Formally, the expression to prioritise would look like:

![](https://cdn-images-1.medium.com/max/2000/1*c-Qqr2TEzaaA-zGH01JalA.png)

The data points with the lower margin sampling score would be the ones labelled the first; these are the data points the model is least certain about between the most probably and the next-to-most probable class.

Following the example of Table 1, the corresponding scores for each data point are:

* X1: 0.9–0.07 = 0.83
* X2: 0.87–0.1 = 0.86
* X3: 0.5–0.3 = 0.2
* X4: 0.99–0.01 = 0.98

Hence the data points would be shown to label as follows: X3, X1, X2 and X4. As one can see the priority in this case is slightly different to the least confident one.

**Entropy:**

Finally, the last scoring function that we are gonna present here is the entropy score. Entropy is a concept that comes from thermodynamics; in a simple way, it can be understood as a measure of disorder in a system, for instance a gas in a closed box. The higher the entropy the more disorder there is, whereas if the entropy is low, it means that the gas might be mainly in one particular area such as a corner of the box (maybe when the experiment started, before expanding across the box).

This concept can be reused to measure the certainty of a model. If a model is highly certain about a class for a given data point, it will probably have a high certainty for a particular class, whereas all the other classes will have low probability. Isn’t this very similar to having a gas in the corner of a box? In this case we have most of the probability assigned to a particular class. In the case of high entropy it would mean that the model distributes equally the probability for all classes as it is not certain at all which class that data point belongs to, similarly to having the gas distributed equally in all parts of the box. It is therefore straightforward to prioritise data points with higher entropy to the ones with lower entropy.

Formally, we can define the entropy score prioritisation as follows:

![](https://cdn-images-1.medium.com/max/2000/1*sUuF5qqrW0CpArzejhNTNA.png)

If we apply the entropy score to the example in Table 1:

* X1: **-0.9*log(0.9)-0.07*log(0.07)-0.03*log(0.03)** = 0.386
* X2: **-0.87*log(0.87)-0.03*log(0.03)-0.1*log(0.1)** = 0.457
* X3: **-0.2*log(0.2)-0.5*log(0.5)-0.3*log(0.3)** =1.03
* X4: **-0*log(0)-0.01*log(0.01)-0.99*log(0.99)** = 0.056

**Note that for X4, 0 should be changed for a small epsilon (e.g. 0.00001) for numerical stability.**

In this case the data points should be shown in the following order: X3, X2, X1 and X4, which coincides with the order of the least confident scoring method!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
