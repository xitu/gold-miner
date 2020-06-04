> * 原文地址：[Diverse Mini-Batch Active Learning: A Reproduction Exercise](https://medium.com/data-from-the-trenches/diverse-mini-batch-active-learning-a-reproduction-exercise-2396cfee61df)
> * 原文作者：[Alexandre Abraham](https://medium.com/@alexandre.abraham)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/diverse-mini-batch-active-learning-a-reproduction-exercise.md](https://github.com/xitu/gold-miner/blob/master/article/2020/diverse-mini-batch-active-learning-a-reproduction-exercise.md)
> * 译者：
> * 校对者：

# Diverse Mini-Batch Active Learning: A Reproduction Exercise

In our previous blog post, [**A Proactive Look at Active Learning Packages**](https://medium.com/data-from-the-trenches/a-proactive-look-at-active-learning-packages-8845fb6541e9), we gave an overview of the most basic methods of active learning together with the most common Python packages as well as the more advanced methods they implement.

For this second post, we’ll have a look at more recent approaches and seize this opportunity to try to reproduce the results from the 2019 paper [**Diverse Mini-Batch Active Learning**](https://arxiv.org/abs/1901.05954). For a fully detailed description of all the methods, we refer the reader directly to the article.

## The Need for Diversity

Our previous blog post introduced uncertainty-based methods that use class prediction probabilities to select samples on which the model struggles the most. We also introduced density-based methods that leverage data distribution to find representative samples.

Uncertainty and representativeness are two criteria of a triad that active learning methods strive to optimize:

* **Diversity.** Diversity is the pure exploratory criterion. A method that purely optimizes for diversity would probably select samples all across the feature space and is more likely to select outliers.
* **Representativeness.** A sample is said to be representative if many samples are similar to it according to a given similarity measure. Typical representative samples are in the “center” of large sample clusters.
* **Uncertainty.** These are samples that are difficult to classify for the model.

Diversity and representativeness are usually optimized at the same time, given that both leverage the data distribution of unlabeled samples. Clustering methods optimize for both at once. This is the reason why the author has chosen the K-Means approach for his diverse query sampling method. Another strategy such as presented in [[1](https://arxiv.org/abs/1904.06685)] proposes a similarity-matrix-based method that integrates all criteria at once in a single loss function.

Diversity is necessary to compensate for the lack of exploration of uncertainty methods, which mainly focus on regions close to the decision boundaries.

![](https://cdn-images-1.medium.com/max/2620/1*QhL8OivIkEFZRjYTRbgAHg.png)

Figure 1. In this toy example, the colored samples have been labeled, and the current classifier boundary is shown in purple. Uncertainty-based methods are more likely to select samples in the red area, closer to the classifier boundary. Representative methods are more likely to select samples in the green area since the density of samples is higher. Only diversity-based methods are likely to explore the blue area.

Figure 1 shows a toy active learning experiment on a binary classification (square vs. triangle). It shows that uncertainty or representativeness-based functions can miss the entire part of the feature space and fail to build a model with good generalization on unseen data.

As mentioned, a natural way to segment the feature space is to use clustering methods. Since clusters are supposed to be composed of similar samples, a clustering method should both discriminate features and find representative samples within each cluster.

## Diverse mini-batch Active Learning Strategy

The Diverse mini-batch Active Learning method combines uncertainty and diversity by selecting the next **k** samples to be labeled:

* First, pre-selecting **β** * **k** samples using the smallest margin sampler [[2](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.191.61&rep=rep1&type=pdf)], **β** being the only parameter of the method.
* Then selecting **k** samples among this pre-selection by running either a [submodular optimizer](https://en.wikipedia.org/wiki/Submodular_set_function) called Submodular(**β**), a K-Means called Clustered(**β**), or a K-Means weighted by the uncertainty score called WClustered(**β)**. The paper reports experiments with **β=10** and **β=50.**

**Note.** The paper states that the method that solves the diversity problem best is submodular set function optimization and that K-Means is only a proxy to this problem. This subject is too complicated for a simple blog post, so we refer the curious reader to the original paper and the [Wikipedia page](https://en.wikipedia.org/wiki/Submodular_set_function)!

We have decided to compare both by using the submodular optimization from [apricot python package](https://github.com/jmschrei/apricot) and the K-Means optimization from [scikit-learn](https://scikit-learn.org/).

## Why This Paper ?

Given the extensive literature in the domain of active learning, we had plentiful choices. We made our selection based on several criteria.

**A sound validation scheme.** We have noticed that a lot of active learning papers validate their method on small datasets coming from OpenML without enough samples to be considered in an active learning context — most often, 150 samples are enough to reach an accuracy of 0.95. We, therefore, wanted to reproduce papers on larger datasets, and this paper, which uses 20 Newsgroups, MNIST, and CIFAR10, seemed complex enough to be selected while staying reproducible without heavy resources.

**A simple yet elegant method.** Most recent papers focus on active learning for specific deep learning models; some of them are even dependent on the architecture of the model. We wanted to have a method that is simple enough to be understandable and reproducible. The proposed method is based on K-Means, a widely used clustering approach based on an intuitive principle.

**Optimization for both uncertainty and diversity.** Most modern active learning methods optimize for both model uncertainty and feature exploration — also called diversity. The proposed method combines both of these criteria in a very natural way by using uncertainty as a sample pre-selection but also as a sample weight for the K-Means.

**Note.** In the paper, the author compares its methods to a framework called FASS. For the sake of simplicity, we did not reproduce the results of this framework in this blog post. We have also decided to use Keras instead of MXNet out of habit and to see if findings can be reproduced using another framework.

## Erratum: Uncertainty Computation

In the paper, the author defines informativeness as maximizing:

![Classification Margin Uncertainty](https://cdn-images-1.medium.com/max/3452/1*9AcutnVgRTcVVIkk_oDqOQ.png)

With **ŷ**₁ ****being the top label and **ŷ**₂ the second top one, whereas [[2](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.191.61&rep=rep1&type=pdf)] recommends to minimize it. We confirmed by experimenting that maximizing it leads to performance worse than random sampling. We assume instead that the author used the complementary probability, as usually done:

![](https://cdn-images-1.medium.com/max/2796/1*LOhi39IomWOk78wSPw8ZGA.png)

## 20 Newsgroups Experiments

The 20 Newsgroups task consists in identifying which of the 20 discussion groups a series of posts come from. For this experiment, we use the exact same protocol as described in the paper:

* Preprocessing is done with CountVectorizer(ngram_range=(1,2), max_features=250000) and TfidfTransformer(use_idf=True) — equivalent to TfidfVectorizer(ngram_range=(1,2), max_features=250000, use_idf=True, dtype=np.int64) — and classification with a Multinomial logistic regression classifier.
* We start with 100 samples and go up to 1,000 samples by batches of 100.
* One difference: given the high dimensionality of the data, we used a MiniBatchKMeans for Clustered(50) and WClustered(50) to speed up the experiment.

![Figure 2. Results of the original paper (left) and our experiment (right) on the 20 Newsgroups dataset. The performance measure is accuracy, the solid line is the average over 20 runs, and the confidence intervals are 10th and 90th percentiles.](https://cdn-images-1.medium.com/max/3542/1*UbtktbyQ8scMzVe9pZ_3AA.png)

**Conclusion.** In this experiment, we fail to reproduce the findings of the original paper, but we do not contradict them either. In particular, random sampling seems to reach an accuracy of 0.68 on 1,000 samples in the original experiment, where we find it to be around 0.70 as the other methods. In the end, given the large variability of the result, we cannot determine if one method is better than another.

## MNIST Experiments

The paper proposes two experiments on the MNIST data. We reproduce the first one here. This is an active learning experiment on MNIST dataset for digit recognition. The active learning loop starts with 100 samples and adds batches of 100 samples until it reaches 1,000 samples (out of 60,000), with the best accuracy around 0.93. The paper refers to a Python notebook for the configuration of the model, but we failed to reproduce the same results using the same settings:

* We use Keras instead of MXNet for the neural network but the same architecture — layers of size 128, 64, with ReLU activation, and a final layer of 10 neurons with softmax.
* We failed to reproduce an accuracy above 0.90 with the configuration specified in the paper — SGD optimizer with learning rate of 0.10. We use instead an Adam optimizer with a learning rate of 0.01 to achieve similar performance.
* We use 60,000 samples for training and 10,000 for testing as done in the paper, but bootstrapped the experiment 20 times instead of 16.

![Figure 3. Results of the original paper (left) and our experiment (right) on the MNIST dataset. The performance measure is accuracy, the solid line is the average over 20 runs, and the confidence intervals are 10th and 90th percentiles.](https://cdn-images-1.medium.com/max/3538/1*1WmgM07Q6-BBjWXZebWh8A.png)

The most striking result in this experiment is that our confidence intervals are significantly larger than the ones in the original paper, even though we both computed confidence intervals the same way and repeated the experiments more than 16 times.

Yet we observe that random is significantly worse than all the active learning methods. The pure uncertainty-based approach is at some point worse than the clustering-based ones but not by far, and since it is simpler to set up, it may still be an approach to consider. Finally, the original figure exhibits very slight differences between clustering approaches around 400 samples; we fail to reproduce this and observe similar performances for all of them.

Among the 3 experiments, we were particularly concerned by these results since MNIST is the experiment where the difference between query sampling methods is the most significant. Our biggest difference with the original experiment being the model implementation, we decided to reproduce the experiment with yet another one: [scikit-learn’s multi-layer perceptron](https://scikit-learn.org/stable/modules/generated/sklearn.neural_network.MLPClassifier.html). We also wanted to confirm that the chosen uncertainty measure, the smallest margin, was outperforming the lowest confidence one, as claimed in the paper. Here are the results:

![Figure 4. Results of the MNIST experiment using scikit-learn’s MLP. The performance measure is accuracy, the solid line is the average over 20 runs, and the confidence intervals are 10th and 90th percentiles.](https://cdn-images-1.medium.com/max/3076/1*H28DNZ7Y_o4Ge3Cjc0wIIg.png)

Figure 4 shows results that are much more similar to the figure of the paper. Smallest-margin sampling outperforms significantly lowest-confidence sampling. The weighted clustering methods are significantly better than all others when the learning set is between 300 and 800 samples. The confidence intervals are also much smaller, even though they are not as thin as in the paper. An exciting finding on this figure is that the weighted clustering methods seem to perform equally independently of the informativeness method used to pre-select and weight the samples.

**Conclusion.** Both of our experiments confirm the findings of the original paper, although with less significance. We see that diversity-based approaches beat random selection and uncertainty-based sampling. Interestingly, they even seem to achieve an excellent performance independently of the scores of the informativeness methods on which they are based.

## CIFAR 10 Experiments

This experiment is an image classification problem on the CIFAR 10 dataset. Because bootstrapping this task requires a more extensive training set, the active learning loop starts with 1,000 samples, and adds batches of 1,000 samples until it reaches 10,000 samples (out of 50,000), and reaches an accuracy around 0.60. Our setting for this experiment is:

* We use Keras instead of MXNet and a Resnet 50 v2 instead of Resnet 34 v2 as it is not natively available in Keras. Since the paper specifies no optimizer, we choose to use RMSprop and ran 3 epochs.
* We use 50,000 samples for training and 10,000 for testing as in the paper.

![Figure 5. Results of the original paper (left) and our experiment (right) on the MNIST dataset. The performance measure is accuracy, the solid line is the average over 20 runs, and the confidence intervals are 10th and 90th percentiles.](https://cdn-images-1.medium.com/max/3522/1*dP5Ku8S3mfCVgBBc_bZIyQ.png)

**Conclusion.** Figure 5 shows that once again our confidence intervals are a bit larger than the ones in the original paper. The most striking result is that our accuracy is far higher than the one in the original paper, 0.8 instead of 0.6. This difference is probably due to the difference of architecture between the two experiments. Yet, once again we observe that active learning is better than random sampling even though we do not observe that the diversity-based sampling is more performant.

## Diverse mini-batch Active Learning: Takeaways

Reproducing experiments from a research article is always complicated, specially when not all of the parameters of the original experiment are publicly shared.

One thing we were unable to explain is the higher variability in our experiments compared to the original paper. Even though we used different technologies and slightly different settings, we managed to reproduce the main findings and proved that indeed Active Learning is useful on complex problems !

## References

Zhdanov, Fedor. “[Diverse mini-batch Active Learning.](https://arxiv.org/abs/1901.05954)” **arXiv preprint arXiv:1901.05954** (2019).

[1] Du, Bo, et al. “[Exploring representativeness and informativeness for active learning.](https://arxiv.org/abs/1904.06685)” **IEEE transactions on cybernetics** 47.1 (2015): 14–26.

[2] Settles, Burr. [**Active learning literature survey**](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.191.61&rep=rep1&type=pdf). University of Wisconsin-Madison Department of Computer Sciences, 2009.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
