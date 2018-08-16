> * 原文地址：[Naive Bayes Classification With Sklearn](https://blog.sicara.com/naive-bayes-classifier-sklearn-python-example-tips-42d100429e44)
> * 原文作者：[Martin Müller](https://blog.sicara.com/@martinmller_55863?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/naive-bayes-classifier-sklearn-python-example-tips.md](https://github.com/xitu/gold-miner/blob/master/TODO1/naive-bayes-classifier-sklearn-python-example-tips.md)
> * 译者：
> * 校对者：

# Naive Bayes Classification With Sklearn

![](https://cdn-images-1.medium.com/max/1000/1*CGLYSpJGxg8g0EDeOeOe3w.png)

Gaussian Distribution With Bean Machine

This **tutorial** details **Naive Bayes classifier** algorithm, its **principle**, **pros & cons**, and provides an example using the **Sklearn** **python** **Library.**

### Context

Let’s take the famous [**Titanic Disaster dataset**](https://www.kaggle.com/c/titanic/download/train.csv). It gathers Titanic passenger personal information and whether or not they survived to the shipwreck. Let’s try to make a prediction of survival using passenger ticket fare information.

![](https://cdn-images-1.medium.com/max/800/1*L1BTmw1Zb5iwhl1PtyL6qw.png)

_500 passengers onboard Titanic_

Imagine you take a random sample of 500 passengers. In this sample, **30% of people survived**. Among passenger who survived, the **fare ticket mean is 100$**. It falls to **50$** in the subset of people who **did not survive**. Now, let’s say you have a new passenger. You do not know if he survived or not but you know he bought a **30$ ticket** to cross the Atlantic. What is your prediction of survival for this passenger?

### Principle

Ok, you probably answered that this passenger **did not survive**. Why? Because according to the information contained in the random subset of passengers, you assumed that **chances of survival were low** and that **being poor reduced chances of survival**. You put this passenger in the **closest group of likelihood** (the low fare ticket group). This is what the Naive Bayes classifier does.

### How does it work?

The Naive Bayes classifier aggregates information using conditional probability with an **assumption of independence among features**. What does it mean? For example, it means we have to assume that the comfort of the room on the Titanic is independent of the fare ticket. **This assumption is absolutely wrong** and it is why it is called **Naive**. It allows to simplify the calculation, even on very large datasets. Let’s find why.

The Naive Bayes classifier is based on **finding functions describing the probability of belonging to a class given features**. We write it P(_Survival | f1,…, fn)._ We apply the [Bayes law](https://en.wikipedia.org/wiki/Bayes%27_theorem) to simplify the calculation:

![](https://cdn-images-1.medium.com/max/800/1*UWkbRkbDVnd8ZOlEspuXOQ.png)

Formula 1: Bayes Law

P(_Survival)_ is easy to compute and we do not need P( _f1,…, fn)_ to build a classifier. It remains P(_f1,…, fn | Survival)_ calculation. If we apply the [conditional probability formula](https://en.wikipedia.org/wiki/Conditional_probability) to simplify calculation again:

![](https://cdn-images-1.medium.com/max/800/1*bxBF8kYy8QWnFR_CcwUU_g.png)

Formula 2: First development

Each calculation of terms of the last line above requires a dataset where all conditions are available. To calculate the probability of obtaining f_n given the Survival, f_1, …, f_n-1 information, we need to have enough data with different values of f_n where condition {Survival, f_1, …, f_n-1} is verified. **It requires a lot of data**. We face the [curse of dimensionality](https://en.wikipedia.org/wiki/Curse_of_dimensionality). Here is where the _Naive Assumption_ will help. **As feature are assumed independent, we can simplify calculation** by considering that the condition {Survival, f_1, …, f_n-1} is equal to {Survival}:

![](https://cdn-images-1.medium.com/max/800/1*1kJUTxyMEn80NkA0O7rJXg.png)

Formula 3: Applying Naive Assumption

Finally to classify a new vector of features, we just have to choose the _Survival_ value (1 or 0) for which P(f_1, …, f_n|_Survival_) is the highest:

![](https://cdn-images-1.medium.com/max/800/1*0tKBMhq0I1P22I61h_wpOw.png)

Formula 4: argmax classifier

**NB**: One **common mistake is to consider the probability outputs of the classifier as true**. In fact, Naive Bayes is known as a **bad estimator**, so do not take those probability outputs too seriously.

### Find the correct distribution function

One last step remains to begin to implement a classifier. How to model the probability functions P(f_i| Survival)? There are three available models in the Sklearn python library:

*   [**Gaussian:**](http://scikit-learn.org/stable/modules/naive_bayes.html)  It assumes that continuous features follow a [normal distribution](https://en.wikipedia.org/wiki/Normal_distribution).

![](https://cdn-images-1.medium.com/max/800/1*bnciZ5w3Uw3YZ2ziRJ7-gw.png)

Normal Distribution

*   [**Multinomial**](http://scikit-learn.org/stable/modules/naive_bayes.html)**:** It is useful if your features are discrete.
*   [**Bernoulli**](http://scikit-learn.org/stable/modules/naive_bayes.html)**:** The binomial model is useful if your features are binary.

![](https://cdn-images-1.medium.com/max/800/1*4abK9yj9FTjpaIEDlM4vAw.png)

Binomial Distribution

### Python Code

Here we implement a classic **Gaussian Naive Bayes** on the Titanic Disaster dataset. We will use Class of the room, Sex, Age, number of siblings/spouses, number of parents/children, passenger fare and port of embarkation information.

```
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import time
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import GaussianNB, BernoulliNB, MultinomialNB

# Importing dataset
data = pd.read_csv("data/train.csv")

# Convert categorical variable to numeric
data["Sex_cleaned"]=np.where(data["Sex"]=="male",0,1)
data["Embarked_cleaned"]=np.where(data["Embarked"]=="S",0,
                                  np.where(data["Embarked"]=="C",1,
                                           np.where(data["Embarked"]=="Q",2,3)
                                          )
                                 )
# Cleaning dataset of NaN
data=data[[
    "Survived",
    "Pclass",
    "Sex_cleaned",
    "Age",
    "SibSp",
    "Parch",
    "Fare",
    "Embarked_cleaned"
]].dropna(axis=0, how='any')

# Split dataset in training and test datasets
X_train, X_test = train_test_split(data, test_size=0.5, random_state=int(time.time()))
```

```
# Instantiate the classifier
gnb = GaussianNB()
used_features =[
    "Pclass",
    "Sex_cleaned",
    "Age",
    "SibSp",
    "Parch",
    "Fare",
    "Embarked_cleaned"
]

# Train classifier
gnb.fit(
    X_train[used_features].values,
    X_train["Survived"]
)
y_pred = gnb.predict(X_test[used_features])

# Print results
print("Number of mislabeled points out of a total {} points : {}, performance {:05.2f}%"
      .format(
          X_test.shape[0],
          (X_test["Survived"] != y_pred).sum(),
          100*(1-(X_test["Survived"] != y_pred).sum()/X_test.shape[0])
))
```

> Number of mislabeled points out of a total 357 points: 68, performance 80.95%

The performance of our classifier is **80.95%**.

### Illustration with 1 feature

Let’s **restrain the classification** using the _Fare_ information only. Here we compute the P(S_urvival_ = 1) and P(S_urvival_ = 0) probabilities:

```
mean_survival=np.mean(X_train["Survived"])
mean_not_survival=1-mean_survival
print("Survival prob = {:03.2f}%, Not survival prob = {:03.2f}%"
      .format(100*mean_survival,100*mean_not_survival))
```

> Survival prob = 39.50%, Not survival prob = 60.50%

Then, according to the _formula 3_, we just need to find the **probability distribution function** P(fare| Survival = 0) and P(fare| Survival = 1). We choose the Gaussian Naive Bayes classifier. Thus we have to make the assumption that those distributions are Gaussian.

![](https://cdn-images-1.medium.com/max/800/1*e0ctDeOBlR2-Vhp1MoCmfA.png)

Formula 5: Gaussian formula (σ: standard deviation / μ: mean)

Then we have to find the mean and the standard deviation of the Fare datasets for different _Survival_ values. We obtain the following results:

```
mean_fare_survived = np.mean(X_train[X_train["Survived"]==1]["Fare"])
std_fare_survived = np.std(X_train[X_train["Survived"]==1]["Fare"])
mean_fare_not_survived = np.mean(X_train[X_train["Survived"]==0]["Fare"])
std_fare_not_survived = np.std(X_train[X_train["Survived"]==0]["Fare"])

print("mean_fare_survived = {:03.2f}".format(mean_fare_survived))
print("std_fare_survived = {:03.2f}".format(std_fare_survived))
print("mean_fare_not_survived = {:03.2f}".format(mean_fare_not_survived))
print("std_fare_not_survived = {:03.2f}".format(std_fare_not_survived))
```

```
mean_fare_survived = 54.75
std_fare_survived = 66.91
mean_fare_not_survived = 24.61
std_fare_not_survived = 36.29
```

Let’s see the resulting distributions regarding _survived_ and _not_survived_ histograms:

![](https://cdn-images-1.medium.com/max/800/1*43SvhJOLnPZihcEAPzMcoA.png)

Figure 1: Fare Histograms and Gaussian distributions for each survival values (Scales are not accurate)

We notice that distributions are **not nicely fitted** to the dataset. Before implementing a model, it is better to verify if the distribution of features follows one of the three models detailed above. If continuous features do not have a normal distribution, we should use **transformations** or different methods to **convert it in a normal distribution**. Here we will consider that distributions are normal to simplify this illustration. We apply the _Formula 1_ Bayes law and obtain this classifier:

![](https://cdn-images-1.medium.com/max/800/1*z0W-9WcG-pmX9L29fCW02A.png)

Figure 2: Gaussian Classifier

If _classifier(Fare) ≥ ~78_ then P(fare| Survival = 1) _≥_ P(fare| Survival = 0) and we classify this person as _Survival._ Else we classify as _Not Survival._ We obtain a **64.15%** performance classifier.

If we train the **Sklearn Gaussian Naive Bayes classifier** on the same dataset. We obtain exactly the same results:

```
from sklearn.naive_bayes import GaussianNB
gnb = GaussianNB()
used_features =["Fare"]
y_pred = gnb.fit(X_train[used_features].values, X_train["Survived"]).predict(X_test[used_features])
print("Number of mislabeled points out of a total {} points : {}, performance {:05.2f}%"
      .format(
          X_test.shape[0],
          (X_test["Survived"] != y_pred).sum(),
          100*(1-(X_test["Survived"] != y_pred).sum()/X_test.shape[0])
))
print("Std Fare not_survived {:05.2f}".format(np.sqrt(gnb.sigma_)[0][0]))
print("Std Fare survived: {:05.2f}".format(np.sqrt(gnb.sigma_)[1][0]))
print("Mean Fare not_survived {:05.2f}".format(gnb.theta_[0][0]))
print("Mean Fare survived: {:05.2f}".format(gnb.theta_[1][0]))
```

```
Number of mislabeled points out of a total 357 points: 128, performance 64.15%
Std Fare not_survived 36.29
Std Fare survived: 66.91
Mean Fare not_survived 24.61
Mean Fare survived: 54.75
```

### Pro and cons of Naive Bayes Classifiers

**_Pros:_**

*   Computationally fast
*   Simple to implement
*   Works well with small datasets
*   Works well with high dimensions
*   Perform well even if the _Naive Assumption_ is not perfectly met. In many cases, the approximation is enough to build a good classifier.

**_Cons:_**

*   Require to **remove correlated features** because they are voted twice in the model and it can lead to **over inflating importance**.
*   If a categorical variable has a category in test data set **which was not observed in training data set**, then the model will assign a **zero probability**. It will not be able to make a prediction. This is often known as **“Zero Frequency”**. To solve this, we can use the **smoothing technique**. One of the simplest smoothing techniques is called [Laplace estimation](https://stats.stackexchange.com/questions/108797/in-naive-bayes-why-bother-with-laplacian-smoothing-when-we-have-unknown-words-i). **Sklearn** applies Laplace smoothing by default when you train a Naive Bayes classifier.

### Conclusion

**Thank you** for reading this article. I hope it helped you to understand what is **Naive Bayes classification** and why it is a **good idea** to use it.

Thanks to [Antoine Toubhans](https://medium.com/@AntoineToubhans?source=post_page), [Flavian Hautbois](https://medium.com/@FlavianHautbois?source=post_page), [Adil Baaj](https://medium.com/@AdilBaaj?source=post_page), and [Raphaël Meudec](https://medium.com/@raphaelmeudec?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
