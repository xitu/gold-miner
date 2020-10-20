> * 原文地址：[Normalization vs Standardization — Quantitative analysis](https://towardsdatascience.com/normalization-vs-standardization-quantitative-analysis-a91e8a79cebf)
> * 原文作者：[Shay Geller](https://medium.com/@shayzm1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/normalization-vs-standardization-quantitative-analysis.md](https://github.com/xitu/gold-miner/blob/master/TODO1/normalization-vs-standardization-quantitative-analysis.md)
> * 译者：[ccJia](https://github.com/ccJia)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234), [portandbridge](https://github.com/portandbridge)

# 对比归一化和标准化 —— 量化分析

停止使用 Sklearn 提供的 StandardScaler 作为你的特征压缩方法甚至可以让你训练好的模型有 7% 的准确率提升。

![[https://365datascience.com/standardization/](https://365datascience.com/standardization/)](https://cdn-images-1.medium.com/max/2000/1*dZlwWGNhFco5bmpfwYyLCQ.png)

每一个 ML 的从业者都知道特征的压缩是一个重要的议题（[更多](https://medium.com/greyatom/why-how-and-when-to-scale-your-features-4b30ab09db5e)）

两个最热议的方法就是归一化和标准化。**归一化**通常来说是将数值压缩到 [0,1] 范围内。**标准化**指的是重新调整数据，使数据到均值为 0，标准差为 1。

本篇博客希望通过一些实验回答以下的问题：

1. 我们总是需要压缩特征吗？

2. 是否有一个最好的压缩方法？

3. 不同的压缩技术是如何影响不同的分类器？

4. 压缩方法是否也应该被考虑为一个重要的超参？

我将分析多个不同压缩方法作用于不同特征的实验结果。

## 内容总览

* 0. 为何而来？
* 1. 成熟的分类器
* 2. 分类器 + 压缩
* 3. 分类器 + 压缩 + PCA
* 4. 分类器 + 压缩 + PCA + 超参调整
* 5. 用更多数据集重复进行实验
* — 5.1 Rain in Australia 数据集
* — 5.2 Bank Marketing 数据集
* — 5.3 Sloan Digital Sky Survey DR14 数据集
* — 5.4 Income classification 数据集
* 结论

## 0. 为何而来？

首先，我尝试理解归一化与标准化之间的区别。

然后，我发现了这篇由 Sebastian Raschka 写的很不错的 [博客](https://sebastianraschka.com/Articles/2014_about_feature_scaling.html)，这篇文章从数学的角度满足了我的好奇心。**如果你不熟悉归一化与标准化的概念，那么请一定花五分钟读一下这篇博客**。

这里还有篇由 Hinton 大神写的[文章](https://www.youtube.com/watch?v=Xjtu1L7RwVM&list=PLoRl3Ht4JOcdU872GhiYWf6jwrk_SNhz9&index=26)解释了为什么使用梯度下降来训练的分类器（如神经网络）需要使用特征的压缩。

好的，我们已经恶补了一波数学的知识，是吧？远远不够。

我发现 Sklearn 提供了很多不同的压缩方法。我们可以通过 [the effect of different scalers on data with outliers](https://scikit-learn.org/stable/auto_examples/preprocessing/plot_all_scaling.html#sphx-glr-auto-examples-preprocessing-plot-all-scaling-py) 有一个直观的认识。但是他们没有讲清楚这些方法是如何影响不同分类器任务的。

我们阅读了很多 ML 的主线教程，一般都是使用 StandardScaler（通常叫做零均值标准化 ）或者 MinMaxScaler（通常叫做 Min-Max 归一化）来压缩特征。为什么没人用其他的压缩方法来分类呢？难道 StandardScaler 和 MinMaxScaler 已经是最好的压缩方法了？

我在教程中没有发现关于为什么或者什么时候使用这些方法的解释。所以，我觉得应该通过实验来研究这些技术的性能。**这就是这篇文章所要讲的全部东西。**

## 项目细节

和许多数据科学的工程一样，我们会读取一些数据，并使用一些成熟的分类器来做实验。

### 数据集

[Sonar](https://www.kaggle.com/adx891/sonar-data-set) 数据集包含了 208 行和 60 列特征。这个分类任务是为了判断声纳的回传信号是来自金属圆柱还是不规则的圆柱形石头。

![](https://cdn-images-1.medium.com/max/2000/1*1qjuIaF6FRElpMniHloccQ.png)

这是一个平衡的数据集：

```
sonar[60].value_counts() # 60 是标签列的名字

M    111
R     97
```

数据集中所有特征都在 0 和 1 之间，**但是**并不是每一个特征都能保证 1 是最大值或者 0 是最小值。

我选择这个数据集有两个方面的考量，首先是这个数据集足够的小，我可以快速的完成实验。其次，这个问题比较复杂，没有一个分类器可以将准确率做到 100%，我获得的比对数据就更有意义。

在后面的章节，我们也会在其他数据集上做实验。

**代码**

在预处理环节，我已经计算了所有结果（这个花费了不少时间）。所以，我们只读取结果文件并在其上进行分析。

你可以在我的 GitHub 上获取产生结果的代码：
[https://github.com/shaygeller/Normalization_vs_Standardization.git](https://github.com/shaygeller/Normalization_vs_Standardization.git)

我从 Sklearn 中选取了一些最流行的分类器，如下：

![](https://cdn-images-1.medium.com/max/2000/1*G0DvYlXlKH5P5WyOjYs6iw.png)

（MLP 是一种多层级的感知器，一个神经网络）

使用的压缩方法如下：

![](https://cdn-images-1.medium.com/max/2000/1*XU4abA9kv7Fohqk2WtQ2ag.png)

* 不要将上表的最后一个压缩方法 Normalizer 和我们之前提到的极大极小归一化混淆了。极大极小归一化对应的是第二行的 MinMaxScalar。Sklearn 中的 Normalizer 是将样本单独归一化为一个单位范数。**这是一个基于行而非基于列的归一化方法。**

## 实验细节：

* 为了复现实验场景，我们使用相同的随机数种子。

* 训练集和测试集的比例为 8:2，并且是随机划分。

* 所有的结果的准确率都是在 10 个取自**训练集**的随机交叉验证集上得到的。

* 我们不讨论测试集上的结果。通常来讲，测试集都是不可见的，并且我们的结论都是只从分类器在交叉验证集上的得分得到的。

* 在第四部分，我使用嵌套的交叉验证集。一个内部交叉验证集包含 5 个随机的分块，并由超参进行调整。外部是 10 个随机分割的交叉验证集并使用最好的模型参数获得对应得分。这一部分的数据都是源自训练集。图片是最具有说服力的：

![[https://sebastianraschka.com/faq/docs/evaluate-a-model.html](https://sebastianraschka.com/faq/docs/evaluate-a-model.html)](https://cdn-images-1.medium.com/max/2000/1*7-Y--5i-Pc6VTL7EzY0lCA.png)

## 我们来看看结果

```
import os
import pandas as pd

results_file = "sonar_results.csv"
results_df = pd.read_csv(os.path.join("..","data","processed",results_file)).dropna().round(3)
results_df
```

## 1. 成熟的分类器

```
import operator

results_df.loc[operator.and_(results_df["Classifier_Name"].str.startswith("_"), ~results_df["Classifier_Name"].str.endswith("PCA"))].dropna()
```

![](https://cdn-images-1.medium.com/max/2000/1*PY8iPAFpK7RgJpfnqMEyPw.png)

一个不错的结果，通过观察交叉验证集的均值，我们可以发现 MLP 是最棒的，而 SVM 效果最差。

标准差的结果都是基本一致的，所以我们主要是关注均值得分。我们使用 10 个随机分割的交叉验证集的均值作为结果。

那么，让我们来看看不同压缩方法是怎么改变每个分类器得分的。

## 2. 分类器 + 压缩

```
import operator
temp = results_df.loc[~results_df["Classifier_Name"].str.endswith("PCA")].dropna()
temp["model"] = results_df["Classifier_Name"].apply(lambda sen: sen.split("_")[1])
temp["scaler"] = results_df["Classifier_Name"].apply(lambda sen: sen.split("_")[0])

def df_style(val):
    return 'font-weight: 800'

pivot_t = pd.pivot_table(temp, values='CV_mean', index=["scaler"], columns=['model'], aggfunc=np.sum)
pivot_t_bold = pivot_t.style.applymap(df_style,
                      subset=pd.IndexSlice[pivot_t["CART"].idxmax(),"CART"])
for col in list(pivot_t):
    pivot_t_bold = pivot_t_bold.applymap(df_style,
                      subset=pd.IndexSlice[pivot_t[col].idxmax(),col])
pivot_t_bold
```

![](https://cdn-images-1.medium.com/max/2000/1*O7f4vWIUgUvCpwxT24dsmg.png)

第一行，没有索引名称的那一行，是我们没有使用任何压缩方法的原始算法得分。

```
import operator

cols_max_vals = {}
cols_max_row_names = {}
for col in list(pivot_t):
    row_name = pivot_t[col].idxmax()
    cell_val = pivot_t[col].max()
    cols_max_vals[col] = cell_val
    cols_max_row_names[col] = row_name

sorted_cols_max_vals = sorted(cols_max_vals.items(), key=lambda kv: kv[1], reverse=True)

print("Best classifiers sorted:\n")
counter = 1
for model, score in sorted_cols_max_vals:
    print(str(counter) + ". " + model + " + " +cols_max_row_names[model] + " : " +str(score))
    counter +=1
```

最好的组合如下：

1. SVM + StandardScaler : 0.849
2. MLP + PowerTransformer-Yeo-Johnson : 0.839
3. KNN + MinMaxScaler : 0.813
4. LR + QuantileTransformer-Uniform : 0.808
5. NB + PowerTransformer-Yeo-Johnson : 0.752
6. LDA + PowerTransformer-Yeo-Johnson : 0.747
7. CART + QuantileTransformer-Uniform : 0.74
8. RF + Normalizer : 0.723

## 我们来分析一下结果

1. **没有一个压缩方法可以让每一个分类器都获得最好的结果。**

2. 我们发现压缩是会带来增益的。SVM、MLP、KNN 和 NB 又分别从不同的压缩方法上获得了长足的增益。

3. 值得注意到是**一些**压缩方法对 NB、RF、LDA 和 CART 是无效的。这个现象是和每一种分类器的工作原理是相关的。树形分类器不受影响的原因是它们在分割前会先对数值进行排序并且为每一个分组计算熵。一些压缩函数保持了这个顺序，所以不会有什么提高。NB 不受影响的原因是它模型的先验是由每个类中的计数器决定的而不是实际值。线性判别分析（[LDA](https://www.youtube.com/watch?v=azXCzI57Yfc)）是通过类间的变化寻找一个系数，所以它也不受压缩的影响。

4. 一些压缩方法，如：QuantileTransformer-Uniform，并不会保存特征的实际顺序，因此它依然会改变上述的那些与其他压缩方法无关的分类器的得分。

## 3. 分类器 + 压缩 + PCA

我们知道一些众所周知的 ML 方法，比如像 PCA 就可以从压缩中获益（[博客](https://sebastianraschka.com/Articles/2014_about_feature_scaling.html)）。我们试着加上一个 PCA（n_components=4）到实验中并分析结果。

```
import operator
temp = results_df.copy()
temp["model"] = results_df["Classifier_Name"].apply(lambda sen: sen.split("_")[1])
temp["scaler"] = results_df["Classifier_Name"].apply(lambda sen: sen.split("_")[0])

def df_style(val):
    return 'font-weight: 800'

pivot_t = pd.pivot_table(temp, values='CV_mean', index=["scaler"], columns=['model'], aggfunc=np.sum)
pivot_t_bold = pivot_t.style.applymap(df_style,
                      subset=pd.IndexSlice[pivot_t["CART"].idxmax(),"CART"])
for col in list(pivot_t):
    pivot_t_bold = pivot_t_bold.applymap(df_style,
                      subset=pd.IndexSlice[pivot_t[col].idxmax(),col])
pivot_t_bold
```

![](https://cdn-images-1.medium.com/max/2000/1*CUM03Zp2PN5s8DUbkgv-kA.png)

## 结果分析

1. 大多数的情况下，压缩都改进带有 PCA 的模型， **但是，**没有指定特定的压缩方法。我们来观察一下再大多数模型上都有较好效果的 “QuantileTransformer-Uniform”。它将 LDA-PCA 的准确率从 0.704 提升到了 0.783 提高了 8%！但是对于 RF-PCA 它却起到了负增益，模型的准确率从 0.711 降到了 0.668，下降了 4.35%。另一个方面，如果使用 “QuantileTransformer-Normal” ，RF-PCA 的准确率又可以提高到 0.766 有 5% 的提高。

2. 我们可以发现 PCA 只提高了 LDA 和 RF，所以 PCA 也并不是一个完美的解决方案。我们并没有去调整 n_components 这个超参，其实，就算我们调整了，也不会有保证一定可以有提升。

3. 同时我们会发现 StandardScaler 和 MinMaxScaler 只在 16 个实验中的 4 个得到了最好的分数，所以，我们应该考虑一下如何去选取最合适的默认压缩方法了。

**我可以有如下结论，即使 PCA 作为一个众所周知会从压缩中获得增益的单元，也没有一个压缩方法可以保证可以提高所有的实验结果，它们中的一些甚至对 RF-PCA 这种模型使用 StandardScaler 还会产生负面的影响。**

**在上面的实验中，数据集也是一个重要的因素。为了能更好地理解压缩方法对 PCA 的影响，我们将在更多数据集上做实验（其中数据集会包含类别不平衡、特征尺度不同以及同时具有数值型和分类型特征的数据集）。我们会在第五节进行分析。**

## 4. 分类器 + 压缩 + PCA + 超参调整

对于给定的分类器，不同的压缩方法会导致准确率有很大的不同。我们认为超参在调整完毕后，不同的压缩方法对模型的影响会变小，这样我们就可以像很多网上的教程那样使用 StandardScaler 或者 MinMaxScaler 作为分类器的压缩方法。
我们来验证一下。

![](https://cdn-images-1.medium.com/max/2468/1*Cq-0CrKFMurnKqAiXZ03Qw.png)

首先，NB 没有在此章节中，因为它不存在参数调整。

我们与较早阶段的结果做对比可以发现几乎所有的算法都会从超参调整中获益。一个有趣的例外是 MLP，它变得更糟糕了。这个很可能是神经网络会很容易在数据集上过拟合（尤其是当参数量远远大于训练样本），同时我们又没有用提前停止或者正则化的方式来避免过拟合。

然而，即使我们有一组调整好的超参，运用不同的压缩方法所得的结果还是有很大区别的。当我们在其他方法进行实验时会发现，用这些方法和广泛使用的 StandardScaler 在 KNN 算法上做对比，**准确度居然可以获得 7% 的提升。**

**这个章节的主要结论是，即使我们有一组调试好的超参，变换不同的压缩方法仍然会对模型结果有较大的影响。所以我们应该将模型使用的压缩方法也当作一个关键的超参。**

第五部分我们会在更多的数据集上进行深入的分析。如果你不想再深挖这个问题，可以直接去看结论。

## 5. 用更多数据集重复进行实验

为了得到更好理解同时更为普适的结论，我们需要在更多的数据集上做更多的实验。

我们会用到和第三节相似的分类器+压缩+PCA 的形式在几个具有不同特征的数据集上进行实验，并在不同的小节中分析结果。所有的数据集都来自于 Kaggel。

* 为了方便起见，我从各个数据集中选择了只有数值的列。多元化的数据集（数值和分类特征）在如何进行压缩上一直有争议。

* 我没有调整分类器更多的参数。

## 5.1 Rain in Australia 数据集

[链接](https://www.kaggle.com/jsphyg/weather-dataset-rattle-package#weatherAUS.csv)
**分类任务**：预测是否下雨?
**度量方法**：精度
**数据集大小**：(56420, 18)
**各个类别的数量**：
不下雨 43993
下雨 12427

这里我们展示了 5 行数据的部分列，没法在一张图中展示所有列。

![](https://cdn-images-1.medium.com/max/2386/1*NoL1AoPJa4f0qowV_wxatA.png)

```
dataset.describe()
```

![](https://cdn-images-1.medium.com/max/2446/1*ueOG8zIGopArwAKYh5gAYQ.png)

我们推测由于特征的尺度不同，压缩可能会提高分类器的效果（观察上表的最大最小值，剩余数据的尺度差异会比展示的还要大）。

**结果**

![](https://cdn-images-1.medium.com/max/2496/1*cM5pzKhBp1dVSDYshfMV4g.png)

**结果分析**

* 我们会发现 StandardScaler 和 MinMaxScaler 从来没有得到过最高的分数。

* 我们可以发现在 CART-PCA 算法上 StandardScaler 和其他的方法甚至有 **20% 的区别**。

* 我们也可以发现压缩通常是有效果的。在 SVM 上准确率甚至从 **78% 涨到了 99%。**

## 5.2 Bank Marketing 数据集

[链接](https://www.kaggle.com/henriqueyamahata/bank-marketing)
**分类任务**：预测客户是否已经订购了定期存款?
**度量方法**：AUC **（数据集不平衡）**
**数据集大小**：(41188, 11)
**各类别数量**：
没订购 36548
订购 4640

这里我们展示了 5 行数据的部分列，没法在一张图中展示所有列。

![](https://cdn-images-1.medium.com/max/2000/1*fzuln582evzvssUyszvc9g.png)

```
dataset.describe()
```

![](https://cdn-images-1.medium.com/max/2340/1*TkgNo_a2rekFe2BBzSZriQ.png)

再次说明，特征的尺度不同。

**结果**

![](https://cdn-images-1.medium.com/max/2448/1*IXemV_c-mI260WD0Kfa1-Q.png)

**结果分析**

* 我们会发现，在这个数据集上，即使特征是不同尺度的，压缩也不一定会对所有使用了 PCA 的模型带来增益。**尽管如此，** 在所有带 PCA 的模型上，第二高的得分和最高得分都十分接近。这个可能意味着调整 PCA 的最终维度同时使用压缩方法是优于所有不进行压缩的结果的。

* 再次强调，依然没有一个压缩方法表现的非常优秀。

* 另一个有趣的结果，所有压缩方法在大多数的模型上都没有带来非常大的提升（基本都在 1% - 3% 之间）。这是因为数据集本身是不平衡的，我们也没有调整参数。另一个原因是 AUC 的得分已经很高（在 90% 左右），这就很难再有大的提升了。

## 5.3 Sloan Digital Sky Survey DR14 数据集

[链接](https://www.kaggle.com/lucidlenn/sloan-digital-sky-survey)
**分类任务**：预测目标是星系、恒星还是类星体？
**度量方式**：准确度 (多分类)
**数据集大小**：(10000, 18)
**各类别数量**：
星系 4998
行星 4152
类星体 850

这里我们展示了 5 行数据的部分列，没法在一张图中展示所有列。

![](https://cdn-images-1.medium.com/max/2436/1*61rtzzOrRXE6wl4RRCFgnw.png)

```
dataset.describe()
```

![](https://cdn-images-1.medium.com/max/2488/1*dKSKI_87l7MviX_BT25sCw.png)

再次说明，特征的尺度不同。

**结果**

![](https://cdn-images-1.medium.com/max/2470/1*dAsv-KaQieauDnDO-x4C1A.png)

**结果分析**

* 压缩对结果带来了很大的提升。这是我们可以预期的，是因为数据集中的特征尺度是不同的。

* 我们会发现 RobustScaler 基本上在所有使用了 PCA 的模型上都表现的很好。这可能是大量的异常点导致 PCA 的特征向量发生了平移。另一方面，这些异常点在我们不使用 PCA 时，又没有那么大的影响。这个我们需要深挖数据集才能确定。

* StandardScaler 和其他压缩方法的准度差异可以达到 5%。这也说明我们要用多种压缩方法进行实验。

* PCA 总是可以从压缩上获得增益。

## 5.4 Income classification 数据集

[链接](https://www.kaggle.com/lodetomasi1995/income-classification)
**分类任务**：收入是 >50K 还是 <=50K？
**度量**：AUC **（不平衡数据集）**
**数据集大小**：(32561, 7)
**各类别数量**：
<=50K 24720
>50K 7841

这里我们展示了 5 行数据的部分列，没法在一张图中展示所有列。

![](https://cdn-images-1.medium.com/max/2000/1*5BgWgb3D5vsMU5SG6I1SsQ.png)

```
dataset.describe()
```

![](https://cdn-images-1.medium.com/max/2000/1*1iP0766U3-WIGEU-sGIzTg.png)

这又是个特征的尺度不同的数据集。

**结果**

![](https://cdn-images-1.medium.com/max/2444/1*jDGln1ifWDojhIRRZrhM7w.png)

**结果分析**

* 再次说明，数据集是不平衡的，但是我们可以发现压缩是十分有效的可以使结果出现高达 20% 的提升。这个很可能是 AUC 的得分相较于 Bank Marketing 数据集而言比较低（80%），所以很容易获得较大的提高。

* 虽然 StandardScaler 没有被高亮（我只标亮了每列得分最高的一项），但是在很多列它都很接近最好的结果，当然也不总是有这样的结论。在运行时（没有展示），StandardScaler 的速度比大多数的压缩方法都快。如果你比较关注速度，StandardScaler 是个很好的选择。但是如果你关注的是精度，那么你就需要试试其他压缩方法了。

* 再次强调，依然没有一个压缩方法在所有算法上都表现的非常优秀。

* PCA 几乎总是可以从压缩上获得增益。

## 结论

* 实验表明即使在超参调整好的模型上，压缩也可以在结果上带来增益。**所以，压缩方法需要被当作一个重要的超参来考虑。**

* 不同的压缩方法会对不同的分类器产生影响。SVM、KNN 和 MLP（神经网络）等基于距离的分类器都会从压缩上获得较大的收益。但即使是树型（CART 和 RF）这种某些压缩技术不起作用的分类器，也可以从其它的压缩方法上获益。

* 明白模型和预处理方法背后的数学理论是理解这些结果的最好方法。（举个例子，树型分类器是怎么工作的？为什么一些压缩方法对它们无效？）。这会节约你很多的时间，如果你知道在使用随机森林时不能使用 StandardScaler。

* 像 PCA 这样的预处理方法确实是会从压缩上获得增益。**如果没有效果**，可能是因为 PCA 的维度设置的不好，异常点较多或者错误的选择压缩方法。

如果你发现任何的错误、实验覆盖率的改进方法或者改进意见都可以联系我。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
