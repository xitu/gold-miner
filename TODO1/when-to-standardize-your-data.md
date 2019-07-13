> * 原文地址：[When and why to standardize your data ?](https://towardsdatascience.com/when-to-standardize-your-data-in-4-minutes-f9282190707e)
> * 原文作者：[Zakaria Jaadi](https://medium.com/@zakaria.jaadi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/when-to-standardize-your-data-in-4-minutes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/when-to-standardize-your-data-in-4-minutes.md)
> * 译者：
> * 校对者：

# When and why to standardize your data?

> A simple guide on when to standardize your data and when not to.

![Credits : 365datascience.com](https://cdn-images-1.medium.com/max/NaN/1*dZlwWGNhFco5bmpfwYyLCQ.png)

Standardization is an important technique that is generally performed as a pre-processing step before many Machine Learning models, to standardize the range of features of input data set.

Some ML developers tend to standardize their data blindly before “every” Machine Learning model without taking the effort to understand why it must be used, or even if it’s needed or not. So the goal of this post is to explain how, why and when to standardize data.

## Standardization

Standardization comes into picture when features of input data set have large differences between their ranges, or simply when they are measured in different measurement units (e.g., Pounds, Meters, Miles … etc).

These differences in the ranges of initial features causes trouble to many machine learning models. For example, for the models that are based on distance computation, if one of the features has a broad range of values, the distance will be governed by this particular feature.

To illustrate this with an example: say we have a 2-dimensional data set with two features, Height in Meters and Weight in Pounds, that range respectively from [1 to 2] Meters and [10 to 200] Pounds. No matter what distance based model you perform on this data set, the Weight feature will dominate over the Height feature and will have more contribution to the distance computation, just because it has bigger values compared to the Height. So, to prevent this problem, transforming features to comparable scales using standardization is the solution.

## How to standardize data?

### Z-score

Z-score is one of the most popular methods to standardize data, and can be done by subtracting the mean and dividing by the standard deviation for each value of each feature.

![](https://cdn-images-1.medium.com/max/NaN/0*AgmY9auxftS9BI73.png)

Once the standardization is done, all the features will have a mean of zero, a standard deviation of one, and thus, the same scale.

> There exist other standardization methods but for the sake of simplicity, in this story i settle for Z-score method.

## When to standardize data and why?

As seen above, for distance based models, standardization is performed to prevent features with wider ranges from dominating the distance metric. But the reason we standardize data is not the same for all machine learning models, and differs from one model to another.

So before which ML models and methods you have to standardize your data and why?

**1- Before PCA:**

In Principal Component Analysis, features with high variances/wide ranges, get more weight than those with low variance, and consequently, they end up illegitimately dominating the First Principal Components (Components with maximum variance). I used the word “Illegitimately” here, because the reason these features have high variances compared to the other ones is just because they were measured in different scales.

Standardization can prevent this, by giving same wheightage to all features.

**2- Before Clustering:**

Clustering models are distance based algorithms, in order to measure similarities between observations and form clusters they use a distance metric. So, features with high ranges will have a bigger influence on the clustering. Therefore, standardization is required before building a clustering model.

**3- Before KNN:**

k-nearest neighbors is a distance based classifier that classifies new observations based on similarity measures (e.g., distance metrics) with labeled observations of the training set. Standardization makes all variables to contribute equally to the similarity measures .

**4- Before SVM**

Support Vector Machine tries to maximize the distance between the separating plane and the support vectors. If one feature has very large values, it will dominate over other features when calculating the distance. So Standardization gives all features the same influence on the distance metric.

![Credits : Arun Manglick ([arun-aiml.blogspot.com](http://arun-aiml.blogspot.com/))](https://cdn-images-1.medium.com/max/2000/0*_taflmQxrsa0vguT.PNG)

**5- Before measuring variable importance in regression models**

You can measure variable importance in regression analysis, by fitting a regression model using the **standardized** independent variables and comparing the absolute value of their standardized coefficients. But, if the independent variables are not standardized, comparing their coefficients becomes meaningless.

**6- Before Lasso and Ridge Regression**

LASSO and Ridge regressions place a penalty on the magnitude of the coefficients associated to each variable. And the scale of variables will affect how much penalty will be applied on their coefficients. Because coefficients of variables with large variance are small and thus less penalized. Therefore, standardization is required before fitting both regressions.

## Cases when standardization is not needed?

**Logistic Regression and Tree based models**

Logistic Regression and Tree based algorithms such as Decision Tree, Random forest and gradient boosting, are not sensitive to the magnitude of variables. So standardization is not needed before fitting this kind of models.

## Conclusion

As we saw in this post, when to standardize and when not to, depends on which model you want to use and what you want to do with it. So, it’s very important for a ML developer to understand the internal functioning of machine learning algorithms, to be able to know when to standardize data and to build a successful machine learning model.

> N.B: The list of models and methods when standardization is required, presented in this post is not exhaustive.

### References:

* [**365DataScience.com**]: Explaining Standardization Step-By-Step
* [**Listendata.com** ]: when and why to standardize a variable

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
