> * 原文地址：[Improving massively imbalanced datasets in machine learning with synthetic data](https://towardsdatascience.com/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data-7dd3d856bbdf)
> * 原文作者：[Alexander Watson](https://medium.com/@zredlined)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data.md](https://github.com/xitu/gold-miner/blob/master/article/2020/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：

# 使用合成数据改善机器学习中的极度不平衡数据集

我们将使用合成数据和SMOTE的一些概念来提高模型的准确性，防止欺诈，提高网络安全或改善任何只有非常有限样本的分类任务。

在机器学习中处理不平衡的数据集是一项艰巨的挑战，并且可能涉及诸如支付欺诈，诊断癌症或疾病甚至网络安全等主题。所有这些的问题的共同点在于，实际上只有很小一部分实例是消极的，而这却正是我们真正在意并试图检测的。在这篇文章中，我们将通过训练一个生成额外欺诈记录的模型来大大提高算法在[ Kaggle 欺诈数据集](https://www.kaggle.com/mlg-ulb/creditcardfraud)上的准确率。独特的是，该模型将会合并来自欺诈记录以及与其相邻的足够相似的非欺诈记录的特征，显得更加难以分别。

![Feature image © Gretel.ai](https://cdn-images-1.medium.com/max/2880/1*ncKq5awHMpuwL6Ckv0QSXA.png)

## 我们的不平衡数据集

在本文中，我们选择了 Kaggle 上较多使用的“[信用卡欺诈检测](https://www.kaggle.com/mlg-ulb/creditcardfraud)” 数据集。 此数据集包含2013年9月来自欧洲信用卡持有人的已标记交易记录。为了保护用户隐私，数据集使用降维方法将敏感的数据转化为27个浮点列（V1-27）以及一个时间列（本条记录与首条记录的时间差，秒为单位）。对于本文，我们将使用信用卡欺诈数据集中的前 1 万条记录-单击下面的内容以在 Google 合作实验室中生成以下图形。

[**欺诈数据的分类和可视化**](https://colab.research.google.com/github/gretelai/gretel-synthetics/blob/master/examples/research/synthetics_knn_classify_and_visualize.ipynb)

![一个极度不平衡的数据集](https://cdn-images-1.medium.com/max/2012/1*6ZeY7mc4B_KxS4lKT3VPOg.png)

## 评价标准的陷阱

让我们看看使用最先进的 ML 分类器来检测欺诈记录可以达到的性能。首先，我们将数据集分为训练集和测试集。

![默认欺诈数据集的分类结果](https://cdn-images-1.medium.com/max/3960/1*E_C6xE2vKiCayWSgV_E_Xw.png)

哇，检出率为 99.75％。太好了吧？ 也许模型整体的准确率仅反映了该模型在整个集合中的表现，而并没有反映我们在检测欺诈性记录方面的表现。要查看我们的实际效果如何，需要打印混淆矩阵和准确性报告。

![](https://cdn-images-1.medium.com/max/2604/1*RYVJjEOQ1qieAoI1zyN77w.png)

> 从上面我们可以看到，尽管总体准确率为99.75％，但我们错过了测试集中43％的欺诈示例！

## 使用合成数据对欺诈示例进行增广


在本节中，我们将重点介绍如何通过使用 [gretel-synthetics](https://github.com/gretelai/gretel-synthetics) 产生额外的欺诈记录样本以提高模型性能以及对欺诈记录的泛化能力。让我们从我们想要完成的事情开始 —— 我们的目标是生成额外的欺诈记录样本以提高我们分类器的泛化能力，更好地检测测试集中的欺诈记录。

## 合成少数类过采样技术

数据科学界中一种实现此目标的流行技术称为 SMOTE(**S**ynthetic **M**inority **O**versampling **Te**chnique)，由 Nitesh Chawla 等人在他们 2002 年的[文章](https://arxiv.org/abs/1106.1813)中提出。 SMOTE 的原理是从少数群体中选择示例，找到它们在少数群体中的最近邻居，并在它们之间有效地插值新点。SMOTE无法合并少数群体类别之外的数据记录，而这在我们的示例中却可能包含有用的信息 —— 将类似欺诈或者错误标记的记录包含进去。

## Gretel synthetics with concepts from SMOTE

我们的训练集中只有31个欺诈数据示例，这对网络泛化能力提出了独特的挑战，因为 [gretel-synthetics](https://github.com/gretelai/gretel-synthetics) 利用深度学习技术来学习和生成新样本，传统上需要大量数据才能收敛。打开下面的笔记本，使用 Google Colab 免费生成您自己的合成欺诈数据集。
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
