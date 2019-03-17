> * 原文地址：[Time Series of Price Anomaly Detection](https://towardsdatascience.com/time-series-of-price-anomaly-detection-13586cd5ff46)
> * 原文作者：[Susan Li](https://medium.com/@actsusanli)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-of-price-anomaly-detection.md](https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-of-price-anomaly-detection.md)
> * 译者：
> * 校对者：

![Photo credit: Pixabay](https://cdn-images-1.medium.com/max/2560/1*T-SmdkxMgpAebevA2ElyGA.jpeg)

## Time Series of Price Anomaly Detection

### Anomaly detection detects data points in data that does not fit well with the rest of the data.

Also known as outlier detection, anomaly detection is a data mining process used to determine types of anomalies found in a data set and to determine details about their occurrences. Automatic anomaly detection is critical in today’s world where the sheer volume of data makes it impossible to tag outliers manually. Auto anomaly detection has a wide range of applications such as fraud detection, system health monitoring, fault detection, and event detection systems in sensor networks, and so on.

But I would like to apply anomaly detection to hotel room prices. The reason is somewhat selfish.

Have you had experience that, lets say, you travel to a certain destination for business regularly and you always stay at the same hotel. While most of the time, the room rate is almost similar but occasionally for the same hotel, same room type, the rate is unacceptably high, and you’d have to change to another hotel because your travel allowance does not cover that rate. I had been through this several times and this makes me think, what if we could create a model to detect this kind of price anomaly automatically?

Of course there are circumstance that some anomaly happens only once a life time and we have known them in advance and probably it will not happen the same time in the future years, such as the ridiculous hotel prices in Atlanta on February 2 to February 4, 2019.

![Figure 1](https://cdn-images-1.medium.com/max/2218/1*hGWm-K7FMcyXEA2j4i5weg.png)

In this post, I will explore different anomaly detection techniques and our goal is to search for anomalies in the time series of hotel room prices with unsupervised learning. Let’s get started!

## The Data

It is very hard to get the data, I was able to get some but the data is not perfect.

The data we are going to use is a subset of[ Personalize Expedia Hotel Searches](https://www.kaggle.com/c/expedia-personalized-sort/data) data set that can be found [here](https://www.kaggle.com/c/expedia-personalized-sort/data).

We are going to slice a subset of the training.csv set like so:

* Select one single hotel which has the most data point `property_id = 104517` .

* Select visitor_location_country_id = 219 , as we know from the another analysis that country id 219 is the Unites States. The reason we do that is to unify the `price_usd` column. Since different countries have different conventions regarding displaying taxes and fees and the value may be per night or for the whole stay. And we know that price displayed to US visitors is always per night and without taxes.

* Select `search_room_count = 1`.

* Select the features we need: `date_time`, `price_usd`, `srch_booking_window`, `srch_saturday_night_bool`.

```
expedia = pd.read_csv('expedia_train.csv')
df = expedia.loc[expedia['prop_id'] == 104517]
df = df.loc[df['srch_room_count'] == 1]
df = df.loc[df['visitor_location_country_id'] == 219]
df = df[['date_time', 'price_usd', 'srch_booking_window', 'srch_saturday_night_bool']]
```

After slice and dice, this is the data we will be working with:

```
df.info()
```

![Figure 2](https://cdn-images-1.medium.com/max/2000/1*qDPjZZFs375IpJiYXQWBpA.png)

```
df['price_usd'].describe()
```

![](https://cdn-images-1.medium.com/max/2000/1*WbcFNTxZ63e4vpF-52ZuUw.png)

At this point, we have detected one extreme anomaly which was the Max price_usd at 5584.

If an individual data instance can be considered as anomalous with respect to the rest of the data, we call it ****Point Anomalies**** (e.g. purchase with large transaction value). We could go back to check the log to see what was it about. After a little bit investigation, I guess it was either a mistake or user searched a presidential suite by accident and had no intention to book or view. In order to find more anomalies that are not extreme, I decided to remove this one.

```
expedia.loc[(expedia['price_usd'] == 5584) & (expedia['visitor_location_country_id'] == 219)]
```

![Figure 3](https://cdn-images-1.medium.com/max/3002/1*ABbgFa6gLhUvC0WM3DV6VQ.png)

```
df = df.loc[df['price_usd'] < 5584]
```

At this point, I am sure you have found that we are missing something, that is, we do not know what room type a user searched for, the price for a standard room could be very different with the price for a King bed room with Ocean View. Keep this in mind, for the demonstration purpose, we have to continue.

## Time Series Visualizations

```
df.plot(x='date_time', y='price_usd', figsize=(12,6))
plt.xlabel('Date time')
plt.ylabel('Price in USD')
plt.title('Time Series of room price by date time of search');
```

![Figure 4](https://cdn-images-1.medium.com/max/2238/1*ESU3OuX2zT5L01iAlPEK5Q.png)

```
a = df.loc[df['srch_saturday_night_bool'] == 0, 'price_usd']
b = df.loc[df['srch_saturday_night_bool'] == 1, 'price_usd']
plt.figure(figsize=(10, 6))
plt.hist(a, bins = 50, alpha=0.5, label='Search Non-Sat Night')
plt.hist(b, bins = 50, alpha=0.5, label='Search Sat Night')
plt.legend(loc='upper right')
plt.xlabel('Price')
plt.ylabel('Count')
plt.show();
```

![Figure 5](https://cdn-images-1.medium.com/max/2000/1*kN38184_RxkgANP4uiov1w.png)

In general, the price is more stable and lower when searching Non-Saturday night. And the price goes up when searching Saturday night. Seems this property gets popular during the weekend.

## **Clustering-Based Anomaly Detection**

### **k-means algorithm**

k-means is a widely used clustering algorithm. It creates ‘k’ similar clusters of data points. Data instances that fall outside of these groups could potentially be marked as anomalies. Before we start k-means clustering, we use elbow method to determine the optimal number of clusters.


![Figure 6](https://cdn-images-1.medium.com/max/2000/1*sbYunUvghD_r721IR5E2RA.png)

From the above elbow curve, we see that the graph levels off after 10 clusters, implying that addition of more clusters do not explain much more of the variance in our relevant variable; in this case `price_usd`.

we set `n_clusters=10`, and upon generating the k-means output use the data to plot the 3D clusters.


![Figure 7](https://cdn-images-1.medium.com/max/2000/1*HoU7DGQx8UgHBJSXLuq1bQ.png)

Now we need to find out the number of components (features) to keep.


![Figure 8](https://cdn-images-1.medium.com/max/2000/1*_ncv1D_uD2wWmigdRvZbsA.png)

We see that the first component explains almost 50% of the variance. The second component explains over 30%. However, we’ve got to notice that almost none of the components are really negligible. The first 2 components contain over 80% of the information. So, we will set `n_components=2`.

The underline assumption in the clustering based anomaly detection is that if we cluster the data, normal data will belong to clusters while anomalies will not belong to any clusters or belong to small clusters. We use the following steps to find and visualize anomalies.

* Calculate the distance between each point and its nearest centroid. The biggest distances are considered as anomaly.

* We use `outliers_fraction` to provide information to the algorithm about the proportion of the outliers present in our data set. Situations may vary from data set to data set. However, as a starting figure, I estimate `outliers_fraction=0.01`, since it is the percentage of observations that should fall over the absolute value 3 in the Z score distance from the mean in a standardized normal distribution.

* Calculate `number_of_outliers` using `outliers_fraction`.

* Set `threshold` as the minimum distance of these outliers.

* The anomaly result of `anomaly1` contains the above method Cluster (0:normal, 1:anomaly).

* Visualize anomalies with cluster view.

* Visualize anomalies with Time Series view.


![Figure 9](https://cdn-images-1.medium.com/max/2000/1*JG_xuw8E14iEkxLBuBF4fg.png)


![Figure 10](https://cdn-images-1.medium.com/max/2000/1*B85xLfKeg4n4NqFx4H1Cow.png)

It seems that the anomalies detected by k-means clustering were either some of very high rates or some of very low rates.

## **Isolation Forests** For A**nomaly Detection**

[Isolation Forest](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.IsolationForest.html) detects anomalies purely based on the fact that anomalies are data points that are few and different. The anomalies isolation is implemented without employing any distance or density measure. This method is fundamentally different from clustering based or distance based algorithms.

* When applying an[ IsolationForest](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.IsolationForest.html) model, we set contamination = outliers_fraction, that is telling the model that the proportion of outliers in the data set is 0.01.

* `fit` and `predict(data)` performs outlier detection on data, and returns 1 for normal, -1 for anomaly.

* Finally, we visualize anomalies with Time Series view.


![Figure 11](https://cdn-images-1.medium.com/max/2000/1*qddrIOLJSd2-iMpj7qbjiQ.png)

## **Support Vector Machine-Based Anomaly Detection**

A[ SVM](https://en.wikipedia.org/wiki/Support-vector_machine) is typically associated with supervised learning, but [OneClassSVM](https://en.wikipedia.org/wiki/Support-vector_machine) can be used to identify anomalies as an unsupervised problems that learns a decision function for anomaly detection: classifying new data as similar or different to the training set.

### OneClassSVM

According to the paper:[ Support Vector Method for Novelty Detection](http://users.cecs.anu.edu.au/~williams/papers/P126.pdf). SVMs are max-margin methods, i.e. they do not model a probability distribution. The idea of SVM for anomaly detection is to find a function that is positive for regions with high density of points, and negative for small densities.

* When fitting[ OneClassSVM](https://scikit-learn.org/stable/modules/generated/sklearn.svm.OneClassSVM.html#sklearn.svm.OneClassSVM) model, we set `nu=outliers_fraction`, which is an upper bound on the fraction of training errors and a lower bound of the fraction of support vectors, and must be between 0 and 1. Basically this means the proportion of outliers we expect in our data.

* Specifies the kernel type to be used in the algorithm: `rbf`. This will enable SVM to use a non-linear function to project the hyperspace to higher dimension.

* `gamma` is a parameter of the RBF kernel type and controls the influence of individual training samples - this effects the "smoothness" of the model. Through experimentation, I did not find any significant difference.

* `predict(data)` perform classification on data, and because our model is an one-class model, +1 or -1 is returned, and -1 is anomaly, 1 is normal.


![Figure 12](https://cdn-images-1.medium.com/max/2000/1*4CBpGg6xTabEf_K1yWbteQ.png)

## Anomaly Detection using Gaussian Distribution

Gaussian distribution is also called normal distribution. We will be using the Gaussian distribution to develop an anomaly detection algorithm, that is, we’ll assume that our data are normally distributed. This’s an assumption that cannot hold true for all data sets, yet when it does, it proves an effective method for spotting outliers.

Scikit-Learn’s `[**covariance.EllipticEnvelope**](https://scikit-learn.org/stable/modules/generated/sklearn.covariance.EllipticEnvelope.html)` is a function that tries to figure out the key parameters of our data’s general distribution by assuming that our entire data is an expression of an underlying multivariate Gaussian distribution. The process like so:

* Create two different data sets based on categories defined earlier, — search_Sat_night, Search_Non_Sat_night.

* Apply `EllipticEnvelope`(gaussian distribution) at each categories.

* We set `contamination` parameter which is the proportion of the outliers present in our data set.

* We use `decision_function` to compute the decision function of the given observations. It is equal to the shifted Mahalanobis distances. The threshold for being an outlier is 0, which ensures a compatibility with other outlier detection algorithms.

* The `predict(X_train)` predict the labels (1 normal, -1 anomaly) of X_train according to the fitted model.


![Figure 13](https://cdn-images-1.medium.com/max/2000/1*YMF_eAI6ofVzwKc0Ncsz8g.png)

It is interesting to see that anomalies detected in this way have only observed abnormal high prices but not abnormal low prices.

So far, we have done price anomaly detection with four different methods. Because our anomaly detection is unsupervised learning. After building the models, we have no idea how well it is doing as we have nothing to test it against. Hence, the results of those methods need to be tested in the field before placing them in the critical path.

[Jupyter notebook](https://github.com/susanli2016/Machine-Learning-with-Python/blob/master/Time%20Series%20of%20Price%20Anomaly%20Detection%20Expedia.ipynb) can be found on [Github](https://github.com/susanli2016/Machine-Learning-with-Python/blob/master/Time%20Series%20of%20Price%20Anomaly%20Detection%20Expedia.ipynb). Enjoy the rest of the week!

References:
[**Introduction to Anomaly Detection**
**Experience with the specific topic: Novice Professional experience: No industry experience This overview is intended…**www.datascience.com](https://www.datascience.com/blog/python-anomaly-detection)
[**sklearn.ensemble.IsolationForest - scikit-learn 0.20.2 documentation**
**Behaviour of the decision_function which can be either 'old' or 'new'. Passing behaviour='new' makes the…**scikit-learn.org](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.IsolationForest.html)
[**sklearn.svm.OneClassSVM - scikit-learn 0.20.2 documentation**
**Specifies the kernel type to be used in the algorithm. It must be one of 'linear', 'poly', 'rbf', 'sigmoid'…**scikit-learn.org](https://scikit-learn.org/stable/modules/generated/sklearn.svm.OneClassSVM.html)
[**sklearn.covariance.EllipticEnvelope - scikit-learn 0.20.2 documentation**
**If True, the support of robust location and covariance estimates is computed, and a covariance estimate is recomputed…**scikit-learn.org](https://scikit-learn.org/stable/modules/generated/sklearn.covariance.EllipticEnvelope.html)
[**Unsupervised Anomaly Detection | Kaggle**
**Edit description**www.kaggle.com](https://www.kaggle.com/victorambonati/unsupervised-anomaly-detection)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
