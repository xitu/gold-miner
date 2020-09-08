> * 原文地址：[How to build a recommendation system in a graph database using a latent factor model](https://towardsdatascience.com/how-to-build-a-recommendation-system-in-a-graph-database-using-a-latent-factor-model-fa2d142f874)
> * 原文作者：[Changran Liu](https://medium.com/@liuchangran6106)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-build-a-recommendation-system-in-a-graph-database-using-a-latent-factor-model.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-build-a-recommendation-system-in-a-graph-database-using-a-latent-factor-model.md)
> * 译者：
> * 校对者：

# How to build a recommendation system in a graph database using a latent factor model

## What is a recommendation system?

A recommendation system is any rating system which predicts an individual’s preferred choices, based on available data. Recommendation systems are utilized in a variety of services, such as video streaming, online shopping, and social media. Typically, the system provides the recommendation to the users based on its prediction of the rating a user would give to an item. Recommendation systems can be categorized by two aspects, the utilized information and the prediction models.

![Figure. 1 (Image by Author). This example data set includes two users, Alice and Bob, two movies, **Toy Story** and **Iron Man**, as well as three rating records (solid lines). Each user and movie are tagged with their attributes.](https://cdn-images-1.medium.com/max/2000/0*nphS5bpdyX4gq3oS)

#### Content filtering vs. collaborative filtering

The two major recommendation approaches, content filtering and collaborative filtering, mainly differ according to the information utilized for rating prediction. Figure 1 shows a set of movie rating data together with some tags for users and movies. Note that the ratings from users to movies from a graph structure: users and movies are the vertices, and ratings are the edges of the graph. In this example, a content filtering approach leverages the tag attributes on the movies and users. By querying the tags, we know Alice is a big fan of Marvel movies, and **Iron Man** is a Marvel movie, thus the **Iron Man** series will be a good recommendation for her. A specific example of a content filtering scoring system is TF-IDF, used for ranking document searches.

The tags on the users and movies may not always be available. When the tag data is sparse, the content filtering method can be unreliable. On the other hand, collaborative filtering approaches mainly rely on the user behavior data (e.g. rating record or movie watching history). In the example above, both Alice and Bob love the movie **Toy Story** which was rated 5 and 4.5 by them, respectively. Based on these rating records, it can be inferred that these two users may share similar preferences. Now considering that Bob loves **Iron Man**, we can expect similar behavior from Alice, and recommend **Iron Man** to Alice. K-nearest neighbors ([KNN](https://docs.tigergraph.com/v/2.6/dev/gsql-examples/common-applications#example-1-collaborative-filtering)) is a typical collaborative filtering approach. The collaborative filtering, however, has the so-called Cold Start problem — it cannot produce a recommendation for new users that have no rating records.

**Memory-based vs. model-based**

Recommendation systems can also be categorized into memory-based and model-based approaches depending on the implicity of the utilized features. In the examples above, all the user and movie features are given explicitly, which allows us to directly match movies and users based on their tags. However sometimes a deep learning model is needed to extract the latent features from the information of users and movies (e.g. an NLP model to categorize the movies based on its outline). A model-based recommendation system utilizes machine learning models for prediction. While a memory-based recommendation system mainly leverages the explicit features.

Some typical examples of different types of recommendation systems are shown below.

![(Image by Author)](https://cdn-images-1.medium.com/max/2456/1*_nrZdonnDXVTtOltRCaebg.png)

## How graph factorization works for recommendation systems

As discussed above, a collaborative filtering method, such as KNN, can predict the movie rating without knowing the attributes of the movies and users. However, such an approach may not generate accurate predictions when the rating data is sparse, i.e., the typical user has rated only a few movies. In Fig. 1, KNN cannot predict Alice’s rating of **Iron Man** if Bob has not rated **Toy Story**, since there would be no path between Alice and Bob, and there would be no “neighbor” per se for Alice. To address this challenge, the graph factorization approach [1] combines the model-based method with the collaborative filtering method to improve prediction accuracy when the rating record is sparse.

Fig. 2 illustrates the intuition of the graph factorization method. Graph factorization is also known as a latent factor or matrix factorization method. The objective is to obtain a vector for each user and movie, which represents their latent features. In this example (Fig. 2), the dimension of the vectors is specified as 2. The two elements of the vector for a movie **x(i)** represent the degrees of romance and action content of this movie, and the two elements of the vector for a user **θ(j)** represent the user’s degree of preference for romance and action content, respectively. The prediction of the rating that user **j** would give to movie **i** is the dot product of **x(i)** and **θ(j)**, as we expect a better alignment of these two vectors indicates a higher degree of preference from the user to the movie.

![Figure. 2 (Image by Author). The table shows the rating records of 6 movies given by 4 users. The ratings are in the range of 0 to 5. The missing ratings are represented by question marks. **θ(j)** and x(i) represent the latent factor vectors. The rating predictions for Alice are computed from the latent factors and shown in orange next to the real values.](https://cdn-images-1.medium.com/max/2796/0*T2BPqSnRLLUpGHMa)

The example in Fig.2 is only meant to illustrate the intuition of the graph factorization approach. In practice, the meaning of each vector element is usually unknown. The vectors are actually randomly initialized and get “trained” by minimizing the loss function below [1].

![](https://cdn-images-1.medium.com/max/2000/0*Mhilgi_E_Xo1XymH)

where **M** is the number of rating records, **n** is the dimension of the latent factor vector, **y**(i, j) is the rating that user **j** gave to movie **i**, and 𝝀 is the regularization factor. The first term is essentially the square error of the prediction (sum of **θ(j)\_k** and **x(i)\_k** over k), and the second term is a regularization term to avoid overfitting. The first term of the loss function can also be expressed in the form of matrices,

![](https://cdn-images-1.medium.com/max/2000/1*_A0x9iQr48JjpMuT9SCqtw.png)

where **R** is the rating matrix with **y(i, j)** as its elements, and **U** and **V** are matrices formed of the latent factor vectors for users and movies, respectively. To minimize the square error of the prediction is equivalent to minimizing the Frobenius norm of **R-UV^T**. Thus this method is also called a matrix factorization method.

You may wonder why we also refer to this method as a graph factorization approach. As discussed earlier, the rating matrix **R** is most likely to be a sparse matrix, since not all the users will give ratings to all the movies. Based on the consideration of the storage efficiency, this sparse matrix is often stored as a graph where each vertex represents a user or a movie, and each edge represents a rating record with its weight as the rating. As will be shown below, the gradient descent algorithm that will be used to optimize the loss function and thus obtain the latent factors can also be expressed as a graph algorithm.

The partial derivatives of **θ(j)\_k** and **x(i)\_k** can be expressed as follows:

![](https://cdn-images-1.medium.com/max/2000/0*TvDNRImZS2IxFHGe)

The equations above show that the partial derivative of a latent vector on a vertex only depends on its edges and neighbors. For our example, the partial derivative of a user vector is only determined by the ratings and the latent vectors of the movies the user has rated before. This property allows us to store our rating data as a graph (Fig. 5) and use a graph algorithm to obtain the latent factors of the movies and users. The user and movie features can be obtained by the following steps:

![(Image by Author)](https://cdn-images-1.medium.com/max/2616/1*cKGDWSOgTxd9gJCp6nVOBQ.png)

It is worth mentioning that computing the derivatives and updating the latent factors can be done in a Map-Reduce framework, where step 2 can be done in parallel for each **edge\_(i, j)** (i.e. rating) and step 3 can also be done in parallel for each **verte\_i** (i.e. user or movie).

## Why you need a graph database for recommendation

For industrial applications, the database can hold hundreds of millions of users and movies, and billions of rating records, which means the rating matrix A, feature matrices U and V, plus other intermediate variables can consume terabytes of memory during model training. Such a challenge can be resolved by training the latent features in a graph database where the rating graph can be distributed among a multi-node cluster and partially stored on disk. Moreover, graph-structured user data (i.e. rating records) is stored in the database management system in the first place. In-database model training also avoids exporting the graph data from the DBMS to other machine learning platforms and thus better support continuous model update over evolving training data.

#### How to build a recommendation system in TigerGraph

In this section, we will provision a graph database on TigerGraph Cloud (for free), load a movie rating graph, and train a recommendation model in the database. By following the steps below, you will have a movie recommendation system in 15 minutes.

Follow the [Creating You First TigerGraph Instance](https://www.tigergraph.com/2020/01/20/taking-your-first-steps-in-learning-tigergraph-cloud/) (first 3 steps) to **provision a free instance on TigerGraph Cloud**. In step 1, choose **In-Database Machine Learning Recommendation** as the starter kit. In step 3, choose TG.Free.

Follow the [Getting Started with TigerGraph Cloud Portal](https://www.tigergraph.com/2020/01/20/taking-your-first-steps-in-learning-tigergraph-cloud/) and **log into GraphStudio**. In the **Map Data To Graph** page, you will see how the data files are mapped to the graph. In this starter kit, the [MovieLens-100K](https://grouplens.org/datasets/movielens/) files have already been uploaded into the instance. The [MovieLens-100K](https://grouplens.org/datasets/movielens/) data set has two files:

* The movieList.csv has two columns showing the id and the movie_name (movie_year) of each movie.
* The rating.csv is a list of ratings that a user gave to a movie. The three columns contain the user id, the movie id, and the rating.

![Figure 3 (Image by Author). **Map Data To Graph** page](https://cdn-images-1.medium.com/max/3200/0*CFbnvuOr4sP66zYM)

**Go to the Load Data page and click Start/Resume loading**. After loading finishes, you can see the graph statistics on the right. The MovieLens-100K data set has 100,011 rating records given by 944 users to 1682 movies.

![Figure.4 (Image by Author). **Load Data** page.](https://cdn-images-1.medium.com/max/3200/0*T2DVnK3W7AJxIqR5)

After loading finishes, you can see the graph statistics on the right. In the **Explore Graph** page, you can see we just created a bipartite graph where the information of each movie and user is stored in the vertex, and the rating records are stored in the edges.

![Figure.5 (Image by Author). **Explore Graph** page.](https://cdn-images-1.medium.com/max/3200/0*NKkeM3kRFAWDXNm1)

In the **Write Queries** page, you will find the queries needed for our recommendation system have already been added to the database. The queries are written in GSQL, the query language of TigerGraph. **Click Install all queries** to compile all the GSQL query into C++ code. You can also see a README query on this page. Follow the steps below to build a recommendation with the movie rating records.

![Figure.6 (Image by Author). **Write Queries** page](https://cdn-images-1.medium.com/max/3200/0*r_8aCoSYb4VwJAfR)

**Run the splitData query**

This query split rating data into the validation set and training set. The fraction of testing data is set to be 30% by default. (i.e. 30% of the rating data will be used for model validation and the rest 70% will be used for model training). This query also outputs the size of the total data set, the validation data set and the training data set.

**Run the normalization query**

This query normalizes the ratings by subtracting each rating by the average rating of the movie. The average rating of each movie is computed from the training data.

**Run the Initialization query**

This query initializes the latent factor vectors for the users and the movies. The elements in the latent factor vectors are initialized by a normal distributed random number generator. The query inputs are the standard deviation and the mean of the normal distribution.

**Run the training query**

This query trains the recommender model using gradient descent algorithm. The number of features is set as 19 by default. This number has to be the same as the num_latent_factors in the initialization query. The query inputs are the learning rate, regularization_factor and the number of training iterations. The query output the root mean square error (RMSE) for each iteration

After the latent factors are computed, we can test and use the model for recommendation.

**Run the test query**

This query outputs the real ratings provided by a user together with the predicted rating by the model. The query input is a user id. The query output is all the ratings given by the user and the rating prediction

**Run the recommend query**

This query output the top-10 movies recommended to a user. The movies are recommended based on the rating prediction.

## Conclusion

Training machine learning model in a graph database has the potential to achieve real-time updates of the recommendation model. In this article, we introduce the mechanism of the graph factorization method and show a step-by-step example of building your own movie recommendation system using TigerGraph cloud service. Once you are familiar of this example, you should be confident with customizing this recommendation system based on your use cases.

## Reference

[1] Ahmed, Amr, et al. “Distributed large-scale natural graph factorization” **Proceedings of the 22nd international conference on World Wide Web** (2013)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
