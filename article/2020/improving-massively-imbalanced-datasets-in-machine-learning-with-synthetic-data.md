> * 原文地址：[Improving massively imbalanced datasets in machine learning with synthetic data](https://towardsdatascience.com/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data-7dd3d856bbdf)
> * 原文作者：[Alexander Watson](https://medium.com/@zredlined)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data.md](https://github.com/xitu/gold-miner/blob/master/article/2020/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data.md)
> * 译者：
> * 校对者：

# Improving massively imbalanced datasets in machine learning with synthetic data

We will use synthetic data and a few concepts from SMOTE to improve model accuracy for fraud, cyber security, or any classification with an extremely limited minority class

Handling imbalanced datasets in machine learning is a difficult challenge, and can include topics such as payment fraud, diagnosing cancer or disease, and even cyber security attacks. What all of these have in common are that only a very small percentage of the overall transactions are actually fraud, and those are the ones that we really care about detecting. In this post, we will boost accuracy on a [popular Kaggle fraud dataset](https://www.kaggle.com/mlg-ulb/creditcardfraud) by training a generative synthetic data model to create additional fraudulent records. Uniquely, this model will incorporate features from both fraudulent records and their nearest neighbors, which are labeled as non-fraudulent but are close enough to the fraudulent records to be a little “shady”.

![Feature image © Gretel.ai](https://cdn-images-1.medium.com/max/2880/1*ncKq5awHMpuwL6Ckv0QSXA.png)

## Our imbalanced dataset

For this post, we selected the popular “[Credit Card Fraud Detection](https://www.kaggle.com/mlg-ulb/creditcardfraud)” dataset on Kaggle. This dataset contains labeled transactions from European credit card holders in September 2013. To protect user identities, the dataset uses dimensionality reduction of sensitive features into 27 floating point columns (V1–27) and a Time column (the number of seconds elapsed between this transaction and the first in the dataset). For this post, we will work with the first 10k records in the Credit Card fraud dataset- click below to generate the graphs below in Google Colaboratory.

[**Classify-and-visualize-fraud-dataset**](https://colab.research.google.com/github/gretelai/gretel-synthetics/blob/master/examples/research/synthetics_knn_classify_and_visualize.ipynb)

![A massively imbalanced dataset](https://cdn-images-1.medium.com/max/2012/1*6ZeY7mc4B_KxS4lKT3VPOg.png)

## The metric trap

Let’s see what kind of performance we can get detecting fraudulent records with a cutting edge ML classifier. We will start by dividing our dataset into a Train and Test set.

![Results of classifying our default Fraud dataset](https://cdn-images-1.medium.com/max/3960/1*E_C6xE2vKiCayWSgV_E_Xw.png)

Wow, 99.75% detection. That’s awesome, right?! Maybe- looking at overall model accuracy just shows how well the model performed across the entire set, but not how well we did on detecting fraudulent records. To see how well we really performed, print a confusion matrix and accuracy report.

![](https://cdn-images-1.medium.com/max/2604/1*RYVJjEOQ1qieAoI1zyN77w.png)

> Above we can see that despite our 99.75% overall accuracy, we misclassified 43% of fraud examples in our test set!

## Augmenting fraud examples with synthetic data

In this section we will focus on how we can improve model performance and generalization for the Fraud records, by using [gretel-synthetics](https://github.com/gretelai/gretel-synthetics) to generate additional examples of fraudulent records. Let’s start with what we want to accomplish- our goal is to generate additional samples of fraudulent records that will help our classifier generalize and better detect the fraudulent records in our test set.

## Synthetic Minority Oversampling Technique

A popular technique in the data science community to achieve this is called SMOTE (**S**ynthetic **M**inority **O**versampling **Te**chnique), described by Nitesh Chawla et al. in their 2002 [paper](https://arxiv.org/abs/1106.1813). SMOTE works by selecting examples from the minority class, finding their nearest neighbors in the minority class, and effectively interpolating new points between them. SMOTE does not have the ability to incorporate data from records outside of the minority class, which in our examples may include useful information- including fraudulent-like or mislabeled records.

## Gretel synthetics with concepts from SMOTE

Having only 31 examples of fraudulent data in our training set presents a unique challenge for generalization, as [gretel-synthetics](https://github.com/gretelai/gretel-synthetics) utilizes deep learning techniques to learn and generate new samples, which traditionally require a lot of data to converge. Open the notebook below to generate your own synthetic fraud dataset for free with Google Colab.
[**gretel-synthetics-generate-fraud-data**
colab.research.google.com](https://colab.research.google.com/github/gretelai/gretel-synthetics/blob/master/examples/research/synthetics_knn_generate.ipynb)

By borrowing SMOTE’s approach of finding the nearest neighbors to to the fraudulent set and incorporating a few of the nearest neighbors from the majority class, we have the opportunity both to expand our training set examples, and to incorporate in some learnings from our fraudulent-like (**let’s just call them shady**) records. This approach will not require any changes to [Gretel Synthetics](https://github.com/gretelai/gretel-synthetics), we’re just intelligently picking the dataset from the fraudulent + nearest positive neighbor (shady) records. Let’s get started!

```Python
#!pip install s3fs smart_open pandas sklearn

import pandas as pd
from smart_open import open
from sklearn.neighbors import NearestNeighbors

# Set params
NEAREST_NEIGHBOR_COUNT = 5
TRAINING_SET = 's3://gretel-public-website/datasets/creditcard_train.csv'

# Separate out positive (non-fraud) and negative (fraud) sets
df = pd.read_csv(TRAINING_SET, nrows=999999).round(6)
positive = df[df['Class'] == 1]
negative = df[df['Class'] == 0]

# Train a nearest neighbors model on non-fraudulent records
neighbors = NearestNeighbors(n_neighbors=5, algorithm='ball_tree')
neighbors.fit(negative)

# Select the X nearest neighbors to our fraudulent records
nn = neighbors.kneighbors(positive, 5, return_distance=False)
nn_idx = list(set([item for sublist in nn for item in sublist]))
nearest_neighbors = negative.iloc[nn_idx, :]
nearest_neighbors

# Over-sample positive records and add nearest neighbor (shady, non-fraudulent)
# and shuffle the dataset
oversample = pd.concat([positive] * NEAREST_NEIGHBOR_COUNT)
training_set = pd.concat([oversample, nearest_neighbors]).sample(frac=1)
```

To build our synthetic model, will use Gretel’s new [DataFrame training mode](https://gretel-synthetics.readthedocs.io/en/stable/api/batch.html) defaults with a few parameters set below to optimize results:

1. `epochs: 7`. Set epochs to the lowest setting possible to balance creating valid records without overfitting on our limited training set.
2. `dp: False`. No need to take the accuracy hit from running differential privacy in this case.
3. `gen_lines: 1000`. We will generate 1000 records to boost our existing 31 positive examples. Note that not all of the records generated from our model will be positive, as we incorporated in some negative examples- but we should have several hundred new positive examples at least.
4. `batch_size=32`. Fit all 30 rows into a single neural network model to retain all field-field correlations, at cost of more records failing validation.
5. Train the model, generate lines, and only keep the “fraudulent” records created by the synthetic data model

```Python
#!pip install gretel-synthetics --upgrade

from gretel_synthetics.batch import DataFrameBatch
from pathlib import Path

config_template = {
    "max_lines": 0,
    "max_line_len": 2048,
    "epochs": 7,
    "vocab_size": 20000,
    "gen_lines": 1000,
    "dp": False,
    "field_delimiter": ",",
    "overwrite": True,
    "checkpoint_dir": str(Path.cwd() / "checkpoints")
}

# train synthetic model
batcher = DataFrameBatch(df=training_set, batch_size=32, config=config_template)
batcher.create_training_data()
batcher.train_all_batches()

# generate synthetic dataset
status = batcher.generate_all_batch_lines(max_invalid=5000)
df_synthetic = batcher.batches_to_df()

# only keep fraudulent records created by our model
df_synthetic = df_synthetic[df_synthetic['Class'] == 1]
```

## Examining our synthetic dataset

Now let’s take a look at our synthetic data and see if we can visually confirm that our synthetic records are representative of the fraudulent records that they were trained on. Our dataset has 30 dimensions, so we will use a dimensionality reduction technique from data science called Principal Component Analysis (PCA) to visualize the data in 2D and 3D.

Below we can see our training, synthetic, and test datasets compressed down to two dimensions. Visually, it looks like the 883 new fraudulent synthetic records may be very helpful to the classifier, in addition to the 31 original training examples. We added the 7 test-set positive examples (where our default model mis-classifies 3/7, and we’re hoping that the augmented synthetic data will help boost detection.

![](https://cdn-images-1.medium.com/max/2278/1*Bg5JgUkFIbdTYzNWLzbVkA.png)

From what we can see in our graph, it appears our synthetically generated fraudulent examples may be really useful! Note what appear to be a false positive examples near the Training Negative set. If you see a lot of these examples, try reducing the `NEAREST_NEIGHBOR_COUNT` from 5 to 3 for better results. Let’s visualize the same PCA visualization 3 dimensions.

![](https://cdn-images-1.medium.com/max/2000/1*_LARl50aGYFjTMaVVxrsKg.png)

Looking at the datasets above, it appears that boosting our minority set of fraudulent records with synthetic data may help significantly with model performance. Let’s try it!

## Boosting our training dataset with synthetic data

Now we reload the train and test datasets, but this time augment our existing training data with the newly generated synthetic records.

![Adding 852 synthetic examples reduces our negative/positive ratio from 257 to 9x!](https://cdn-images-1.medium.com/max/3908/1*_65jW8aRrX1ZvSo9zBrvmw.png)

Train XGBoost on the augmented dataset, run the model against the test dataset and examine the confusion matrix.

![14% boost in fraud detection with the additional fraud example detection!](https://cdn-images-1.medium.com/max/2094/1*3AkwQxkfC9tck5kVrxfYDg.png)

As we have seen, it is a hard challenge to train machine learning models to accurately detect extreme minority classes. But, synthetic data creates a way to boost accuracy and potentially improve models ability to generalize to new datasets- and can uniquely incorporate features and correlations from the entire dataset into synthetic fraud examples.

For next steps, try running the notebooks above on your own data. Want to learn more about synthetic data? Check out Towards Data Science articles mentioning Gretel-Synthetics [here](https://towardsdatascience.com/reducing-ai-bias-with-synthetic-data-7bddc39f290d) and [here](https://towardsdatascience.com/dont-stop-at-ensembles-unconventional-deep-learning-techniques-for-tabular-data-8d4e154f1053).

## Final remarks

At [Gretel.ai](https://gretel.ai/) we are super excited about the possibility of using synthetic data to augment training sets to create ML and AI models that generalize better against unknown data and with reduced algorithmic biases. We’d love to hear about your use cases- feel free to reach out to us for a more in-depth discussion in the comments, [twitter](https://twitter.com/gretel_ai), or [hi@gretel.ai](mailto:hi@gretel.ai). Follow us to keep up on the latest trends with synthetic data!

Interested in training on your own dataset? [Gretel-synthetics](https://github.com/gretelai/gretel-synthetics) is free and open source, and you can start experimenting in seconds via [Colaboratory](https://camo.githubusercontent.com/52feade06f2fecbf006889a904d221e6a730c194/68747470733a2f2f636f6c61622e72657365617263682e676f6f676c652e636f6d2f6173736574732f636f6c61622d62616467652e737667). If you like gretel-synthetics give us a ⭐ on [GitHub](https://github.com/gretelai/gretel-synthetics)!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
