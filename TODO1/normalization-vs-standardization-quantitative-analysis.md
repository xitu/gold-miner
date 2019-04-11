> * 原文地址：[Normalization vs Standardization — Quantitative analysis](https://towardsdatascience.com/normalization-vs-standardization-quantitative-analysis-a91e8a79cebf)
> * 原文作者：[Shay Geller](https://medium.com/@shayzm1)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/normalization-vs-standardization-quantitative-analysis.md](https://github.com/xitu/gold-miner/blob/master/TODO1/normalization-vs-standardization-quantitative-analysis.md)
> * 译者：
> * 校对者：

# Normalization vs Standardization — Quantitative analysis

Stop using StandardScaler from Sklearn as a default feature scaling method can get you a boost of 7% in accuracy, even when you hyperparameters are tuned!

![[https://365datascience.com/standardization/](https://365datascience.com/standardization/)](https://cdn-images-1.medium.com/max/2000/1*dZlwWGNhFco5bmpfwYyLCQ.png)

Every ML practitioner knows that feature scaling is an important issue (read more [here](https://medium.com/greyatom/why-how-and-when-to-scale-your-features-4b30ab09db5e)).

The two most discussed scaling methods are Normalization and Standardization. **Normalization** typically means rescales the values into a range of [0,1]. **Standardization** undefinedtypically means rescales data to have a mean of 0 and a standard deviation of 1 (unit variance).

In this blog, I conducted a few experiments and hope to answer questions like:

 1. Should we always scale our features?

 2. Is there a single best scaling technique?

 3. How different scaling techniques affect different classifiers?

 4. Should we consider scaling technique as an important hyperparameter of our model?

I’ll analyze the empirical results of applying different scaling methods on features in multiple experiments settings.

## Table of Contests

* 0. Why are we here?
* 1. Out-of-the-box classifiers
* 2. Classifier + Scaling
* 3. Classifier + Scaling + PCA
* 4. Classifier + Scaling + PCA + Hyperparameter Tuning
* 5. All again on more datasets:
* — 5.1 Rain in Australia dataset
* — 5.2 Bank Marketing dataset
* — 5.3 Income classification dataset
* — 5.4 Income classification dataset
* Conclusions

## 0. Why are we here?

First, I was trying to understand what is the difference between Normalization and Standardization.

So, I encountered this excellent [blog](https://sebastianraschka.com/Articles/2014_about_feature_scaling.html) by Sebastian Raschka that supplies a mathematical background that satisfied my curiosity. **Please take 5 minutes to read this blog if you are not familiar with Normalization or Standardization concepts.**

There is also a great explanation of the need for scaling features when dealing with classifiers that trained using gradient descendent methods( like neural networks) by famous Hinton [here](https://www.youtube.com/watch?v=Xjtu1L7RwVM&list=PLoRl3Ht4JOcdU872GhiYWf6jwrk_SNhz9&index=26).

Ok, we grabbed some math, that’s it? Not quite.

When I checked the popular ML library Sklearn, I saw that there are lots of different scaling methods. There is a great visualization of [the effect of different scalers on data with outliers](https://scikit-learn.org/stable/auto_examples/preprocessing/plot_all_scaling.html#sphx-glr-auto-examples-preprocessing-plot-all-scaling-py). But they didn’t show how it affects classification tasks with different classifiers.

I saw a lot of ML pipelines tutorials that use StandardScaler (usually called Z-score Standardization) or MinMaxScaler (usually called min-max Normalization) to scale features. Why does no one use other scaling techniques for classification? Is it possible that StandardScaler or MinMaxScaler are the best scaling methods?

I didn’t see any explanation in the tutorials about why or when to use each one of them, so I thought I’d investigate the performance of these techniques by running some experiments. **This is what this notebook is all about**

## Project details

Like many Data Science projects, lets read some data and experiment with several out-of-the-box classifiers.

### Dataset

[Sonar](https://www.kaggle.com/adx891/sonar-data-set) dataset. It contains 208 rows and 60 feature columns. It’s a classification task to discriminate between sonar signals bounced off a metal cylinder and those bounced off a roughly cylindrical rock.

![](https://cdn-images-1.medium.com/max/2000/1*1qjuIaF6FRElpMniHloccQ.png)

It’s a balanced dataset:

```
sonar[60].value_counts() # 60 is the label column name

M    111
R     97
```

All the features in this dataset are between 0 to 1, **but** it’s not ensured that 1 is the max value or 0 is the min value in each feature.

I chose this dataset because, from one hand, it is small, so I can experiment pretty fast. On the other hand, it’s a hard problem and none of the classifiers achieve anything close to 100% accuracy, so we can compare meaningful results.

We will experiment with more datasets in the last section.

**Code**

As a preprocessing step, I already calculated all the results (it takes some time). So we only load the results file and work with it.

The code that produces the results can be found in my GitHub:
[https://github.com/shaygeller/Normalization_vs_Standardization.git](https://github.com/shaygeller/Normalization_vs_Standardization.git)

I pick some of the most popular classification models from Sklearn, denoted as:

![](https://cdn-images-1.medium.com/max/2000/1*G0DvYlXlKH5P5WyOjYs6iw.png)

(MLP is Multi-Layer Perceptron, a neural network)

The scalers I used are denoted as:

![](https://cdn-images-1.medium.com/max/2000/1*XU4abA9kv7Fohqk2WtQ2ag.png)

* Do not confuse Normalizer, the last scaler in the list above with the min-max normalization technique I discussed before. The min-max normalization is the second in the list and named MinMaxScaler. The Normalizer class from Sklearn normalizes samples individually to unit norm. **It is not column based but a row based normalization technique.**

## Experiment details:

* The same seed was used when needed for reproducibility.

* I randomly split the data to train-test sets of 80%-20% respectively.

* All results are accuracy scores on 10-fold random cross-validation splits from the **train set**.

* I do not discuss the results on the test set here. Usually, the test set should be kept hidden, and all of our conclusions about our classifiers should be taken only from the cross-validation scores.

* In part 4, I performed nested cross-validation. One inner cross-validation with 5 random splits for hyperparameter tuning, and another outer CV with 10 random splits to get the model’s score using the best parameters. Also in this part, all data taken only from the train set. A picture is worth a thousand words:

![[https://sebastianraschka.com/faq/docs/evaluate-a-model.html](https://sebastianraschka.com/faq/docs/evaluate-a-model.html)](https://cdn-images-1.medium.com/max/2000/1*7-Y--5i-Pc6VTL7EzY0lCA.png)

## Let’s read the results file

```
import os
import pandas as pd

results_file = "sonar_results.csv"
results_df = pd.read_csv(os.path.join("..","data","processed",results_file)).dropna().round(3)
results_df
```

## 1. Out-of-the-box classifiers

```
import operator

results_df.loc[operator.and_(results_df["Classifier_Name"].str.startswith("_"), ~results_df["Classifier_Name"].str.endswith("PCA"))].dropna()
```

![](https://cdn-images-1.medium.com/max/2000/1*PY8iPAFpK7RgJpfnqMEyPw.png)

Nice results. By looking at the CV_mean column, we can see that at the moment, MLP is leading. SVM has the worst performance.

Standard deviation is pretty much the same, so we can judge mainly by the mean score. All the results below will be the mean score of 10-fold cross-validation random splits.

Now, let’s see how different scaling methods change the scores for each classifier

## 2. Classifiers+Scaling

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

The first row, the one without index name, is the algorithm without applying any scaling method.

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

Best classifier from each model:

1. SVM + StandardScaler : 0.849
2. MLP + PowerTransformer-Yeo-Johnson : 0.839
3. KNN + MinMaxScaler : 0.813
4. LR + QuantileTransformer-Uniform : 0.808
5. NB + PowerTransformer-Yeo-Johnson : 0.752
6. LDA + PowerTransformer-Yeo-Johnson : 0.747
7. CART + QuantileTransformer-Uniform : 0.74
8. RF + Normalizer : 0.723

## Let’s analyze the results

1. **There is no single scaling method to rule them all.**

2. We can see that scaling improved the results. SVM, MLP, KNN, and NB got a significant boost from different scaling methods.

3. Notice that NB, RF, LDA, CART are unaffected **by some** of the scaling methods. This is, of course, related to how each of the classifiers works. Trees are not affected by scaling because the splitting criterion first orders the values of each feature and then calculate the gini\entropy of the split. Some scaling methods keep this order, so no change to the accuracy score. 
NB is not affected because the model’s priors determined by the count in each class and not by the actual value. Linear Discriminant Analysis (LDA) finds it’s coefficients using the variation between the classes (check [this](https://www.youtube.com/watch?v=azXCzI57Yfc)), so the scaling doesn’t matter either.

4. Some of the scaling methods, like QuantileTransformer-Uniform, doesn’t preserve the exact order of the values in each feature, hence the change in score even in the above classifiers that were agnostic to other scaling methods.

## 3. Classifier+Scaling+PCA

We know that some well-known ML methods like PCA can benefit from scaling ([blog](https://sebastianraschka.com/Articles/2014_about_feature_scaling.html)). Let’s try adding PCA(n_components=4) to the pipeline and analyze the results.

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

## Let’s analyze the results

1. Most of the time scaling methods improve models with PCA, **but** undefinedno specific scaling method is in charge. 
Let’s look at “QuantileTransformer-Uniform”, the method with most of the high scores. 
In LDA-PCA it improved the results from 0.704 to 0.783 (8% jump in accuracy!), but in RF-PCA it makes things worse, from 0.711 to 0.668 (4.35% drop in accuracy!) 
On the other hand, using RF-PCA with “QuantileTransformer-Normal”, improved the accuracy to 0.766 (5% jump in accuracy!)

2. We can see that PCA only improve LDA and RF, so PCA is not a magic solution.
It’s fine. We didn’t hypertune the n_components parameter, and even if we did, PCA doesn’t guarantee to improve predictions.

3. We can see that StandardScaler and MinMaxScaler achieve best scores only in 4 out of 16 cases. So we should think carefully what scaling method to choose, even as a default one.

**We can conclude that even though PCA is a known component that benefits from scaling, no single scaling method always improved our results, and some of them even cause harm(RF-PCA with StandardScaler).**

**The dataset is also a great factor here. To better understand the consequences of scaling methods on PCA, we should experiment with more diverse datasets (class imbalanced, different scales of features and datasets with numerical and categorical features). I’m doing this analysis in section 5.**

## 4. Classifiers+Scaling+PCA+Hyperparameter tuning

There are big differences in the accuracy score between different scaling methods for a given classifier. One can assume that when the hyperparameters are tuned, the difference between the scaling techniques will be minor and we can use StandardScaler or MinMaxScaler as used in many classification pipelines tutorials in the web. 
Let’s check that!

![](https://cdn-images-1.medium.com/max/2468/1*Cq-0CrKFMurnKqAiXZ03Qw.png)

First, NB is not here, that’s because NB has no parameters to tune.

We can see that almost all the algorithms benefit from hyperparameter tuning compare to results from o previous step. An interesting exception is MLP that got worse results. It’s probably because neural networks can easily overfit the data (especially when the number of parameters is much bigger than the number of training samples), and we didn’t perform a careful early stopping to avoid it, nor applied any regularizations.

Yet, even when the hyperparameters are tuned, there are still big differences between the results using different scaling methods. If we would compare different scaling techniques to the broadly used StandardScaler technique, we can **gain up to 7% improvement in accuracy** (KNN column) when experiencing with other techniques.

**The main conclusion from this step is that even though the hyperparameters are tuned, changing the scaling method can dramatically affect the results. So, we should consider the scaling method as a crucial hyperparameter of our model.**

Part 5 contains a more in-depth analysis of more diverse datasets. If you don’t want to deep dive into it, feel free to jump to the conclusion section.

## 5. All again on more datasets

To get a better understanding and to derive more generalized conclusions, we should experiment with more datasets.

We will apply Classifier+Scaling+PCA like section 3 on several datasets with different characteristics and analyze the results. All datasets were taken from Kaggel.

* For the sake of convenience, I selected only the numerical columns out of each dataset. In multivariate datasets (numeric and categorical features), there is an ongoing debate about how to scale the features.

* I didn’t hypertune any parameters of the classifiers.

## 5.1 Rain in Australia dataset

[Link](https://www.kaggle.com/jsphyg/weather-dataset-rattle-package#weatherAUS.csv)
**Classification task**: Predict is it’s going to rain?
**Metric**: Accuracy
**Dataset shape**: (56420, 18)
**Counts for each class**:
No 43993
Yes 12427

Here is a sample of 5 rows, we can’t show all the columns in one picture.

![](https://cdn-images-1.medium.com/max/2386/1*NoL1AoPJa4f0qowV_wxatA.png)

```
dataset.describe()
```

![](https://cdn-images-1.medium.com/max/2446/1*ueOG8zIGopArwAKYh5gAYQ.png)

We will suspect that scaling will improve classification results due to the different scales of the features (check min max values in the above table, it even get worse on some of the rest of the features).

**Results**

![](https://cdn-images-1.medium.com/max/2496/1*cM5pzKhBp1dVSDYshfMV4g.png)

**Results analysis**

* We can see the StandardScaler never got the highest score, nor MinMaxScaler.

* We can see **differences of up to 20%** undefinedbetween StandardScaler and other methods. (CART-PCA column)

* We can see that scaling usually improved the results. Take for example SVM that **jumped from 78% to 99%.**

## 5.2 Bank Marketing dataset

[Link](https://www.kaggle.com/henriqueyamahata/bank-marketing)
**Classification task**: Predict has the client subscribed a term deposit?
**Metric**: AUC **( The data is imbalanced)**
**Dataset shape**: (41188, 11)
**Counts for each class**:
no 36548
yes 4640

Here is a sample of 5 rows, we can’t show all the columns in one picture.

![](https://cdn-images-1.medium.com/max/2000/1*fzuln582evzvssUyszvc9g.png)

```
dataset.describe()
```

![](https://cdn-images-1.medium.com/max/2340/1*TkgNo_a2rekFe2BBzSZriQ.png)

Again, features in different scales.

**Results**

![](https://cdn-images-1.medium.com/max/2448/1*IXemV_c-mI260WD0Kfa1-Q.png)

**Results analysis**

* We can see that in this dataset, even though the features are on different scales, scaling when using PCA doesn’t always improve the results. **However,** the second-best score in each PCA column is pretty close to the best score. It might indicate that hypertune the number of components of the PCA and using scaling will improve the results over not scaling at all.

* Again, there is no one single scaling method that stood out.

* Another interesting result is that in most models, all the scaling methods didn’t affect that much (usually 1%–3% improvement). Let’s remember that this is an unbalanced dataset and we didn’t hypertune the parameters. Another reason is that the AUC score is already high (~90%), so it’s harder to see major improvements.

## 5.3 Sloan Digital Sky Survey DR14 dataset

[Link](https://www.kaggle.com/lucidlenn/sloan-digital-sky-survey)
**Classification task**: Predict if an object to be either a galaxy, star or quasar.
**Metric**: Accuracy (multiclass)
**Dataset shape**: (10000, 18)
**Counts for each class**:
GALAXY 4998
STAR 4152
QSO 850

Here is a sample of 5 rows, we can’t show all the columns in one picture.

![](https://cdn-images-1.medium.com/max/2436/1*61rtzzOrRXE6wl4RRCFgnw.png)

```
dataset.describe()
```

![](https://cdn-images-1.medium.com/max/2488/1*dKSKI_87l7MviX_BT25sCw.png)

Again, features in different scales.

**Results**

![](https://cdn-images-1.medium.com/max/2470/1*dAsv-KaQieauDnDO-x4C1A.png)

**Results analysis**

* We can see that scaling highly improved the results. We could expect it because it contains features on different scales.

* We can see that RobustScaler almost always wins when we use PCA. It might be due to the many outliers in this dataset that shift the PCA eigenvectors. On the other hand, those outliers don’t make such an effect when we do not use PCA. We should do some data exploration to check that.

* There is up to 5% difference in accuracy if we will compare StandardScaler to the other scaling method. So it’s another indicator to the need for experiment with multiple scaling techniques.

* PCA almost always benefit from scaling.

## 5.4 Income classification dataset

[Link](https://www.kaggle.com/lodetomasi1995/income-classification)
**Classification task**: Predict if income is >50K, \<=50K.
**Metric**: AUC **(imbalanced dataset)**
**Dataset shape**: (32561, 7)
**Counts for each class**:
 <=50K 24720
 >50K 7841

Here is a sample of 5 rows, we can’t show all the columns in one picture.

![](https://cdn-images-1.medium.com/max/2000/1*5BgWgb3D5vsMU5SG6I1SsQ.png)

```
dataset.describe()
```

![](https://cdn-images-1.medium.com/max/2000/1*1iP0766U3-WIGEU-sGIzTg.png)

Again, features in different scales.

**Results**

![](https://cdn-images-1.medium.com/max/2444/1*jDGln1ifWDojhIRRZrhM7w.png)

**Results analysis**

* Here again, we have an imbalanced dataset, but we can see that scaling do a good job in improving the results (up to 20%!). This is probably because the AUC score is lower (~80%) compared to the Bank Marketing dataset, so it’s easier to see major improvements.

* Even though StandardScaler is not highlighted (I highlighted only the first best score in each column), in many columns, it achieves the same results as the best, but not always. From the running time results(no appeared here), I can tell you that running StandatdScaler is much faster than many of the other scalers. So if you are in a rush to get some results, it can be a good starting point. But if you want to squeeze every percent from your model, you might want to experience with multiple scaling methods.

* Again, no single best scale method.

* PCA almost always benefited from scaling

## Conclusions

* Experiment with multiple scaling methods can dramatically increase your score on classification tasks, even when you hyperparameters are tuned. **So, you should consider the scaling method as an important hyperparameter of your model.**

* Scaling methods affect differently on different classifiers. Distance-based classifiers like SVM, KNN, and MLP(neural network) dramatically benefit from scaling. But even trees (CART, RF), that are agnostic to some of the scaling methods, can benefit from other methods.

* Knowing the underlying math behind models\preprocessing methods is the best way to understand the results. (For example, how trees work and why some of the scaling methods didn’t affect them). It can also save you a lot of time if you know no to apply StandardScaler when your model is Random Forest.

* Preprocessing methods like PCA that known to be benefited from scaling, do benefit from scaling. **When it doesn’t**, it might be due to a bad setup of the number of components parameter of PCA, outliers in the data or a bad choice of a scaling method.

If you find some mistakes or have proposals to improve the coverage or the validity of the experiments, please notify me.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
