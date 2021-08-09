> * 原文地址：[I Can’t Believe It’s Not Better — Active Learning Flavor](https://medium.com/data-from-the-trenches/i-cant-believe-it-s-not-better-active-learning-flavor-ded7e367a6ff)
> * 原文作者：[Alexandre Abraham](Alexandre Abraham)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/i-cant-believe-it-s-not-better-active-learning-flavor.md](https://github.com/xitu/gold-miner/blob/master/article/2021/i-cant-believe-it-s-not-better-active-learning-flavor.md)
> * 译者：
> * 校对者：

# I Can’t Believe It’s Not Better — Active Learning Flavor

This is the story of a research project that didn't quite make it. As every research project, it started with what seemed like a good and natural idea. As with most research projects, it didn't end up as groundbreaking work.

It wasn't a catastrophic failure either. We believe that our method improves upon existing works, but too marginally to comply with the expectations of the research community. However, we believe there is value in sharing this universal journey of a research project!

![I can't believe it's not better logo](https://miro.medium.com/max/1400/0*OD_zFOH8gvXgIM_V.jpg)

At the Dataiku AI Lab, we are interested in developing pragmatic research that can benefit all ML practitioners in their journey with data. This journey often starts with data that needs labeling and, as such, a first question naturally arises:

> How can you most efficiently label data?

One way to tackle this very broad question is within the active learning framework, which has been of prime interest to our team lately.

The starting point. In 2019, Amazon [2] proposed a query sampling strategy that combines both uncertainty estimation and diversity using a weighted K-Means algorithm called WKMeans. As French practitioners, we tend to think that the best dishes are cooked in old pots and were very seduced by this method capable of achieving state-of-the-art performance using the tried-and-tested K-Means. We even proposed a reproduction of their paper results in a [previous blog post](https://medium.com/data-from-the-trenches/diverse-mini-batch-active-learning-a-reproduction-exercise-2396cfee61df).

## All Samples Are Not Made Equal

In our [paper studying the properties of query sampling strategies](https://arxiv.org/abs/2012.11365) [1] published at ICDMW last year, WKMeans clearly leads the way in terms of performance. In order to explain why, we first need to explain the concept of sample (un)certainty.

In active learning, the value of a sample is equal to its capacity to change the prediction of other samples (like test samples) toward the right label. We expect this capacity to be correlated to the capacity of the sample to change its own prediction. Therefore, one of the first query strategies consists of selecting the samples with the lowest maximum predicted probability among classes as they have more room for growth.

Mathematically, we can formulate the potential gain of a sample at iteration *i* as the difference between its current predicted probability using classifier *h*, and its ideal predicted probability that we would only reach after an infinite amount of iterations:

$$
\text { potential_gain }(x)=h_{\infty}(x)-h_{i}(x)
$$

If a sample already has a high predicted probability, there is no improvement to expect: those are *easy-to-classify *samples as illustrated in [4]. The bad performance of purely exploratory sampling strategies, such as K-Means, can be explained by their focus on easy samples.

On the other side of the spectrum, there is a category of samples usually disregarded in active learning: the *hard-to-classify* samples for which the maximum probability is very low (say because it is a dog that looks like a muffin). The bad performance of entropy sampling on the CIFAR100 dataset for instance can be explained by its selection of mostly *hard-to-classify* samples. In our study, we observe that WKMeans selects samples in a sweet spot that are not too easy nor too hard to classify.

![Accuracy and easiness to classify measured on CIFAR100. Confidence-based sampling select hard samples while K-Means select easier ones.](https://miro.medium.com/max/2000/1*66_lxMGtpE76kkzR62Q2wQ.png)

Accuracy and easiness to classify measured on CIFAR100. Confidence-based sampling selects hard samples while K-Means selects easier ones.

In fact, WKMeans performs a preselection of β * k samples with highest uncertainty to get rid of the easy-to-classify samples. Note that the selection process for this β parameter is not an easy task and has dramatic consequences: a value of β being too high can introduce *easy-to-classify* samples in the preselection. If this happens, the subsequent K-Means plays against us: instead of promoting diversity it will almost surely select some samples in the *easy-to-classify* region.

## The Hard-to-Classify Honey Pot

In each task, some samples may be wrongly classified or so hard to classify that deriving a general rule for them is complex. Instead of bringing information, these samples can *blur* the boundary between two classes. Query sampling methods focusing on uncertainty estimation are very prone to select those samples because they may show high uncertainty even if similar samples are selected and labeled. Amazon's proposed method is not immune to this problem since nothing prevents one sample from being selected next to an already labeled (and potential hard-to-classify) one.

Experiment. This problem is easy to spot using a synthetic dataset. For this purpose, we make use of the excellent [make_blobs](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.make_blobs.html) method from scikit-learn. We use it to generate blobs of data belonging to different classes, but we also generate *noisy blobs* where points are randomly attributed to two different classes, making them impossible to classify. In this setting, we expect uncertainty-based methods to fail by focusing on the *noisy blobs*. The method that we will introduce, IWKMeans, seems to be less affected by those blobs.

![Accuracy on a synthetic dataset with two features, 10 classes, and 10,000 samples, of which 50% are noisy.](https://miro.medium.com/max/2000/1*5JWfPkv96gHn-gxfsQfqlg.png)

Accuracy on a synthetic dataset with 2 features, 10 classes, and 10,000 samples, of which 50% are noisy.

## Killing 2 Birds With 1 Stone: Incremental WKMeans

How can we prevent our query sampling strategy from selecting samples that are too easy or too hard to classify? The first idea we got was simply to prevent the selection of samples nearby already selected ones, similarly to what Du [3] did by maximizing the distance between the already selected samples and the ones in the batch. Let us detail how to implement this in WKMeans.

At a high level, the goal of batch active strategies is to select a batch of samples 𝔹 where uncertainty is high, but that is also representative of the unlabeled data 𝔹 ∼ 𝕌 and diverse. For a given notion of similarity "sim" between sets of samples, this leads to the following objective:

$$
\underset{\mathbb{B}}{\arg \max } \operatorname{sim}(\mathbb{B}, \mathbb{U})
$$

In Amazon's method, the similarity measure is defined as follows:

$$
-\sum_{u \in U} d(u, \mathbb{B})
$$

A natural proxy for this maximization is given by the K-Means objective. The above objective does not take into account the already labeled data and can lead to suboptimal batches lying in regions with a high-density of labeled samples. A natural refinement is to additionally impose that the selected batch differs from already labeled data 𝕃, *i.e. *to minimize the similarity sim(𝔹, 𝕃):

$$
\arg \max _{\mathbb{B}} \operatorname{sim}(\mathbb{B}, \mathbb{U}) \\
\text { subject to } \arg \min _{\mathbb{B}} \operatorname{sim}(\mathbb{B}, \mathbb{L})
$$

Within Amazon's settings, this can be achieved by simply modifying the similarity in the objective to:

$$
-\sum_{u \in \mathbb{U}} d(u, \mathbb{B} \cup \mathbb{L})
$$

Consequently, we propose to modify the K-Means procedure by adding fixed clusters corresponding to previously labeled samples in its objective. However, we do not select samples in these clusters: they act as *repulsive points* and prevent the procedure from selecting samples nearby already selected ones. We refer to this approach as Incremental WKMeans. Our implementation is available [here](https://github.com/dataiku-research/cardinal/blob/master/cardinal/clustering.py).

Note that the use of this method is not limited to active learning. We use the incremental K-Means over iterations, but it could be used sequentially in order to build a hierarchical K-Means algorithm that allows us to control the number of clusters at each level.

In the synthetic problem presented above, we see that IWKMeans clearly dominates the other methods. It is also the one that selects the least noisy samples. Let us now see if this behavior is well transposed in real life datasets.

## The Complicated Path to Real-Life Improvements

If the results on our synthetic dataset seem idyllic, they suffer from dire limitations. First, 50% of noisy data is a lot of noise and, in contexts with less noise, IWKMeans performs as good as WKMeans. We have also chosen to take two features and, again, the advantage of IWKMeans becomes less important with more dimensions, as shown below with 40 features.

![40 features IWK =Means](https://miro.medium.com/max/700/1*YGqjYV6w4IA2I8BJoRvrEA.png)

Let us now apply it on real-life data! On our reference tabular dataset, LDPA, IWKMeans brings a marginal improvement compared to WKMeans. Unfortunately, IWKMeans is equivalent to WKMeans in the rest of our suite of tasks (see CIFAR10 results on the right).

![Accuracy on LDPA (left) and on CIFAR10 (right).](https://miro.medium.com/max/2000/1*wVNDr2tAa5yAycN8UO6etQ.png)

Accuracy on LDPA (left) and on CIFAR10 (right).

Robustness to β parameter. We observed some positive signals: the procedure seems to be more robust to the β parameter as originally hoped. This is due to the fact that when *easy-to-classify *samples are preselected, IWKMeans manages to discard them. On LDPA, we observe that IWKMeans with β at 10 and 80 perform the same, while WKMeans suffers from a degradation of performances (see figure below). Unfortunately, this effect does not generalize to CIFAR.

![Accuracy for WKMeans and IWKMeans with β=10 and β=80.](https://miro.medium.com/max/1400/1*WZTIXhsrXMh0We2VMiV2yQ.png)

Accuracy for WKMeans and IWKMeans with β=10 and β=80 on LDPA.

Is IWKMeans converging properly? One could ask if the fixed cluster centers could prevent IWKMeans from converging. In particular, it is easy to conceptualize in 2D that some fixed clusters could prevent a moving cluster to *reach* its best position, as presented in the figure below. We checked and stated that if this can happen in 2D, it is not the case in higher dimensions. K-Means++ initialization also prevents it from happening. We have even tried not to fix the clusters but to reposition them on the fixed position from time to time, and it does not change the performance. See [this example](https://dataiku-research.github.io/cardinal/auto_examples/plot_incr_kmeans.html#sphx-glr-auto-examples-plot-incr-kmeans-py) for more details.

![The moving purple center cannot reach its optimal position in the orange cluster because of the fixed red and blue centers.](https://miro.medium.com/max/478/1*7SqoLt6VxNj44YP8TBWE-A.png)

The moving purple center cannot reach its optimal position in the orange cluster because of the fixed red and blue centers.

Is IWKMeans preventing the selection of interesting points? IWKMeans prevents the selection around already labeled samples, whether they are too hard or too easy to classify. This approach is questionable with regards to the active learning intuition that is to explore the classifier's decision boundary. Following this, we may want to prevent exploration nearby well-classified samples, but keep exploring the neighborhood of samples that are not well classified. For this purpose, we have created a variant of IWKMeans where we consider repulsive points the only labeled samples that are correctly classified by the model... The results are indistinguishable from the original version.

## Conclusion

> In the end, the cold hard truth is that IWKMeans performs very similarly to WKMeans.

Despite some promising signals in a restricted number of cases, IWKMeans needs more adjustments to be proven useful. In particular, we have observed that some of our intuitions about this algorithm hold well in low-dimension and simple classification use cases, but become less clear on complex and real-life use cases. In CIFAR 10, for example, blacklisting already labeled samples when exploring the *airplanes *versus *cats *boundary brings value, but doing it for *dogs *versus *cats* leads to suboptimal results. This is why margin sampling, which deeply explores the latter, manages to beat IWKMeans. In a further version of our algorithm, we want to explore the confusion matrix to have a behavior adapted to each problem. This may require going a bit further away from the original Amazon approach.

## References 

- [1] Abraham, Alexandre, and Léo Dreyfus-Schmidt. "Rebuilding Trust in Active Learning with Actionable Metrics." *2020 International Conference on Data Mining Workshops (ICDMW)*. IEEE, 2020.
- [2] Zhdanov, Fedor. "Diverse mini-batch active learning." *arXiv preprint arXiv:1901.05954* (2019).
- [3] Du, Bo, et al. "Exploring representativeness and informativeness for active learning." *IEEE transactions on cybernetics* 47.1 (2015): 14--26.
- [4] Swayamdipta, Swabha, et al. "Dataset cartography: Mapping and diagnosing datasets with training dynamics." *arXiv preprint arXiv:2009.10795* (2020).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
