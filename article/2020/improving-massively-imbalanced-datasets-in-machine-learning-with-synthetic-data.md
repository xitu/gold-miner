> * 原文地址：[Improving massively imbalanced datasets in machine learning with synthetic data](https://towardsdatascience.com/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data-7dd3d856bbdf)
> * 原文作者：[Alexander Watson](https://medium.com/@zredlined)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data.md](https://github.com/xitu/gold-miner/blob/master/article/2020/improving-massively-imbalanced-datasets-in-machine-learning-with-synthetic-data.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：[司徒公子](https://github.com/stuchilde), [lsvih](https://github.com/lsvih)

# 使用合成数据改善机器学习中的极度不平衡数据集

我们将使用合成数据和一些来自 SMOTE 的一些概念来提高欺诈、网络安全或任何极少类别分类模型的准确性。

在机器学习中处理不平衡的数据集是一项艰巨的挑战，并且可能涉及诸如支付欺诈，诊断癌症或疾病甚至网络安全等主题。所有这些的共同之处在于，在整个交易过程中只有很小一部分是欺诈行为，而这些才是我们真正关心的。在这篇文章中，我们将通过训练一个生成额外欺诈记录的模型来大大提高算法在[ Kaggle 欺诈数据集](https://www.kaggle.com/mlg-ulb/creditcardfraud)上的准确率。独特的是，该模型将会合并来自欺诈记录以及与其相邻的足够相似的非欺诈记录的特征，显得更加难以分别。

![Feature image © Gretel.ai](https://cdn-images-1.medium.com/max/2880/1*ncKq5awHMpuwL6Ckv0QSXA.png)

## 我们的不平衡数据集

在本文中，我们选择了 Kaggle 上较多使用的“[信用卡欺诈检测](https://www.kaggle.com/mlg-ulb/creditcardfraud)”数据集。此数据集包含 2013 年 9 月来自欧洲信用卡持有人的标注好的交易记录。为了保护用户隐私，数据集使用降维方法将敏感的数据转化为 27 个浮点列（V1-27）以及一个时间列（本条记录与首条记录的时间差，单位为秒）。对于本文，我们将使用信用卡欺诈数据集中的前 1 万条记录 - 单击下面的内容以在 Google Colaboratory 中生成以下图形。

[**欺诈数据的分类和可视化**](https://colab.research.google.com/github/gretelai/gretel-synthetics/blob/master/examples/research/synthetics_knn_classify_and_visualize.ipynb)

![一个极度不平衡的数据集](https://cdn-images-1.medium.com/max/2012/1*6ZeY7mc4B_KxS4lKT3VPOg.png)

## 评价标准的陷阱

让我们看看使用最先进的 ML 分类器来检测欺诈记录可以达到的性能。首先，我们将数据集分为训练集和测试集。

![默认欺诈数据集的分类结果](https://cdn-images-1.medium.com/max/3960/1*E_C6xE2vKiCayWSgV_E_Xw.png)

哇，准确率为 99.75％。太好了吧？也许模型整体的准确率仅反映了该模型在整个集合中的表现，而并没有反映我们在检测欺诈性记录方面的表现。要查看我们的实际效果如何，需要打印混淆矩阵和准确性报告。

![](https://cdn-images-1.medium.com/max/2604/1*RYVJjEOQ1qieAoI1zyN77w.png)

> 从上面我们可以看到，尽管总体准确率为 99.75％，但我们在测试集中错误的分类了 43% 的欺诈案例！

## 使用合成数据对欺诈示例进行增广

在本节中，我们将重点介绍如何通过使用 [gretel-synthetics](https://github.com/gretelai/gretel-synthetics) 产生额外的欺诈记录样本以提高模型性能以及对欺诈记录的泛化能力。让我们从我们想要完成的事情开始 —— 我们的目标是生成额外的欺诈记录样本以提高我们分类器的泛化能力，更好地检测测试集中的欺诈记录。

## 合成少数类过采样技术

数据科学界中一种实现此目标的流行技术称为 SMOTE(**S**ynthetic **M**inority **O**versampling **Te**chnique)，由 Nitesh Chawla 等人在他们 2002 年的[论文](https://arxiv.org/abs/1106.1813)中提出。SMOTE 的原理是从少样本类别中选择样本，找到它们在少样本类别中的最近邻居，并在它们之间有效地插值新点。虽然 SMOTE 不能插入少样本类别之外的数据记录，但在我们的情景中却可能包含有用的信息 —— 它可以将疑似欺诈或者标注错误的记录引入数据集中。

## 借鉴 SMOTE 的 Gretel synthetics

我们的训练集中只有31个欺诈数据示例，这对网络泛化能力提出了特别的挑战，因为 [gretel-synthetics](https://github.com/gretelai/gretel-synthetics) 利用深度学习技术来学习和生成新样本，传统上需要大量数据才能收敛。打开下面的笔记本，使用 Google Colab 免费生成您自己的合成欺诈数据集。

[**gretel-synthetics-generate-fraud-data**
colab.research.google.com](https://colab.research.google.com/github/gretelai/gretel-synthetics/blob/master/examples/research/synthetics_knn_generate.ipynb)

通过借鉴 SMOTE 的方法找到欺诈集合中最接近的记录，同时从主要类别中吸纳一些高度相似的记录，我们既有机会扩展我们的训练集，又可以将一些类似欺诈（**让我们称它们为阴险**）的记录纳入到学习中。这一方法不会对 [Gretel Synthetics](https://github.com/gretelai/gretel-synthetics) 进行修改，我们只是智能地从欺诈记录 + 疑似欺诈（阴险）的记录中选择数据。让我们开始吧！

```Python
#!pip install s3fs smart_open pandas sklearn

import pandas as pd
from smart_open import open
from sklearn.neighbors import NearestNeighbors

# 设置参数
NEAREST_NEIGHBOR_COUNT = 5
TRAINING_SET = 's3://gretel-public-website/datasets/creditcard_train.csv'

# 将正样本（非欺诈记录）和负样本（欺诈记录）分开
df = pd.read_csv(TRAINING_SET, nrows=999999).round(6)
positive = df[df['Class'] == 1]
negative = df[df['Class'] == 0]

# 在非欺诈数据集上训练一个相似样本生成模型
neighbors = NearestNeighbors(n_neighbors=5, algorithm='ball_tree')
neighbors.fit(negative)

# 选取离我们欺诈记录最近的 X 个样本
nn = neighbors.kneighbors(positive, 5, return_distance=False)
nn_idx = list(set([item for sublist in nn for item in sublist]))
nearest_neighbors = negative.iloc[nn_idx, :]
nearest_neighbors

# 对正样本进行过采样同时添加相似（阴险，非欺诈）样本
# 并对此数据集随机打乱
oversample = pd.concat([positive] * NEAREST_NEIGHBOR_COUNT)
training_set = pd.concat([oversample, nearest_neighbors]).sample(frac=1)
```

为了构造合成模型，我们将使用 Gretel 新的[数据帧训练模式](https://gretel-synthetics.readthedocs.io/en/stable/api/batch.html)，同时设置一些参数的默认值为如下所示来优化结果。

1. `epochs: 7`. 将 epoch 次数设置地尽可能的低以在生成可用的记录和不在我们有限的训练集上过拟合之间平衡。
2. `dp: False`. 没必要使用差分隐私技术使得准确率受损。
3. `gen_lines: 1000`. 我们会产生 1000 条记录来极大地扩充现有的 31 个正样本。注意并不是所有由模型生成的记录都是正样本，因为我们融合了一些负样本 —— 但是我们应该至少能得到数百条新的正样本。
4. `batch_size=32`. 将所有 30 行放入单个神经网络模型中，以保持所有的字段-字段相关性，代价是更多的记录无法通过验证。
5. 训练模型，产生多行数据，只保留数据合成模型产生的欺诈记录。

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

# 训练数据合成模型
batcher = DataFrameBatch(df=training_set, batch_size=32, config=config_template)
batcher.create_training_data()
batcher.train_all_batches()

# 生成合成数据
status = batcher.generate_all_batch_lines(max_invalid=5000)
df_synthetic = batcher.batches_to_df()

# 只保留我们模型生成的欺诈记录
df_synthetic = df_synthetic[df_synthetic['Class'] == 1]
```

## 检验我们的合成数据集

现在，让我们看一下我们的合成数据，看看我们是否可以从视觉上确认我们的合成记录能否代表训练它们用的欺诈记录。我们的数据集有 30 个维度，因此我们将使用数据科学中的降维技术（称为主成分分析（PCA））以 2D 和 3D 的形式显示数据。

如下所示，我们可以看到压缩到二维的训练，合成和测试数据集。从直观上看，作为 31 个原始的训练示例的补充，883 个新的合成欺诈性记录可能对分类器很有帮助。我们添加了 7 个测试集的正样本（默认模型对其有 3/7 的分类错误)，我们希望增强后的合成数据将有助于提高检测率。

![](https://cdn-images-1.medium.com/max/2278/1*Bg5JgUkFIbdTYzNWLzbVkA.png)

从我们的图表中可以看出，看来我合成的欺诈示例可能确实有用！请注意，在负样本训练集附近的似乎是假阳性的例子。如果您看到很多此类示例，请尝试将 “NEAREST_NEIGHBOR_COUNT” 从 5 减少到 3，以获得更好的结果。让我们直观地观察利用 PCA 技术降维到 3 维的情况。

![](https://cdn-images-1.medium.com/max/2000/1*_LARl50aGYFjTMaVVxrsKg.png)

查看上面的数据集，似乎可以使用合成数据来增强我们的数量稀少的欺诈记录集合，可能会大大有助于提高模型性能。让我们试试吧！

## 利用合成数据增强我们的训练数据集

现在，我们重新加载训练和测试数据集，但是这次使用新生成的合成记录来扩充我们现有的训练数据。

![Adding 852 synthetic examples reduces our negative/positive ratio from 257 to 9x!](https://cdn-images-1.medium.com/max/3908/1*_65jW8aRrX1ZvSo9zBrvmw.png)

在增强后的数据集上训练 XGBoost，在测试数据集上运行模型并查看混淆矩阵。

![14% boost in fraud detection with the additional fraud example detection!](https://cdn-images-1.medium.com/max/2094/1*3AkwQxkfC9tck5kVrxfYDg.png)

如我们所见，训练机器学习模型以准确检测极端少数群体是一个艰巨的挑战。但是，合成数据创建了一种提高准确性并潜在地提高模型泛化到新数据集的能力的方法，并且可以将整个数据集中的特征和相关性独特地合并到合成欺诈示例中。

对于下一步，请尝试在自己的数据集上运行上面的 notebook。想更多地了解合成数据？点[此处](https://towardsdatascience.com/reducing-ai-bias-with-synthetic-data-7bddc39f290d)和[此处](https://towardsdatascience.com/dont-stop-at-ensembles-unconventional-deep-learning-techniques-for-tabular-data-8d4e154f1053)查阅提及到了 Gretel-Synthetics 的关于数据科学的一些文章。

## 结束语

在 [Gretel.ai](https://gretel.ai/)，我们对使用合成数据扩充训练集来创建 ML 和 AI 模型，使得模型能够更好地泛化到未知的数据上同时减少算法的偏差的可能性感到非常兴奋。我们很想听听您的经历-请随时通过评论，[twitter](https://twitter.com/gretel_ai) 和 [hi@gretel.ai](mailto:hi@gretel.ai) 与我们联系，以进行更深入的讨论。关注我们以掌握合成数据最新的发展方向。

对使用自己的数据训练感兴趣？[Gretel-synthetics](https://github.com/gretelai/gretel-synthetics) 是开源且免费的，并且通过 [Colaboratory](https://camo.githubusercontent.com/52feade06f2fecbf006889a904d221e6a730c194/68747470733a2f2f636f6c61622e72657365617263682e676f6f676c652e636f6d2f6173736574732f636f6c61622d62616467652e737667) 你能够马上开始实验. 如果你喜欢 gretel-synthetics 请在 [GitHub](https://github.com/gretelai/gretel-synthetics) 给我们一个⭐!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
