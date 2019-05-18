> * 原文地址：[Using What-If Tool to investigate Machine Learning models.](https://towardsdatascience.com/using-what-if-tool-to-investigate-machine-learning-models-913c7d4118f)
> * 原文作者：[Parul Pandey](https://medium.com/@parulnith)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-what-if-tool-to-investigate-machine-learning-models.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-what-if-tool-to-investigate-machine-learning-models.md)
> * 译者：
> * 校对者：

# Using What-If Tool to investigate Machine Learning models.

An open source tool from Google to easily analyze ML models without the need to code.

![Photo by [Pixabay](https://www.pexels.com/@pixabay?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/ask-blackboard-chalk-board-chalkboard-356079/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/5772/1*NBwHkeXoOu4fwA4dFdpyKw.jpeg)

> Good practitioners act as Detectives, probing to understand their model better¹

In this era of explainable and interpretable Machine Learning, one merely cannot be content with simply training the model and obtaining predictions from it. To be able to really make an impact and obtain good results, we should also be able to probe and investigate our models. Apart from that, algorithmic fairness constraints and bias should also be clearly kept in mind before going ahead with the model.

***

Investigating a model requires asking a lot of questions and one needs to have an acumen of a detective to probe and look for issues and inconsistencies within the models. Also, such a task is usually complex requiring to write a lot of custom code. Fortunately, the **What-If Tool** has been created to address this issue making it easier for a broad set of people to examine, evaluate, and debug ML systems easily and accurately.

## What-If Tool(WIT)

![[Source](https://pair-code.github.io/what-if-tool/index.html)](https://cdn-images-1.medium.com/max/2000/0*RgV_ffd8S28l2xuQ.png)

[**What-If Tool**](https://pair-code.github.io/what-if-tool) is an interactive visual tool that is designed to investigate the Machine Learning models. Abbreviated as WIT, it enables the understanding of a Classification or Regression model by enabling people to examine, evaluate, and compare machine learning models. Due to its user-friendly interface and less dependency on complex coding, everyone from a developer, a product manager, a researcher or a student can use it for their purpose.

**WIT** is an open-source visualisation tool released by Google under the **[PAIR](https://ai.google/research/teams/brain/pair)(People + AI Research)** initiative. PAIR brings together researchers across [Google](https://ai.google/) to study and redesign the ways people interact with AI systems.

***

The tool can be accessed through TensorBoard or as an extension in a Jupyter or [Colab](https://colab.research.google.com/github/tensorflow/tensorboard/blob/master/tensorboard/plugins/interactive_inference/What_If_Tool_Notebook_Usage.ipynb) notebook.

## Advantages

The purpose of the tool is to give people a simple, intuitive, and a powerful way to play with a trained ML model on a set of data through a visual interface only. Here are the major advantages of WIT.

![What can you do with the What-If Tool?](https://cdn-images-1.medium.com/max/2000/1*dFWgN4zuEQz6e-qRuV_p3g.png)

***

We shall cover all the above points during an example walkthrough using the tool.

## Demos

To illustrate the capabilities of the What-If Tool, the PAIR team has released a set of [demos](https://pair-code.github.io/what-if-tool/index.html#demos) using pre-trained models. You can either run the demos in the notebook or directly through the web.

***

![Take the What-If Tool for a spin!](https://cdn-images-1.medium.com/max/2000/1*Al4bw950-mIt4D_CWVIE5Q.png)

## Usage

WIT can be used inside a [Jupyter](https://jupyter.org/) or [Colab](https://colab.research.google.com/) notebook, or inside the [TensorBoard](https://www.tensorflow.org/tensorboard) web application. This has been nicely and clearly explained in the [documentation](https://github.com/tensorflow/tensorboard/tree/master/tensorboard/plugins/interactive_inference#what-if-tool) and I highly encourage you to go through that since explaining the entire process wouldn’t be possible through this short article.

> The whole idea is to first train a model and then visualizes the results of the trained classifier on test data using the What-If Tool.

### Using WIT with Tensorboard

To use WIT within TensorBoard, your model needs to be served through a [TensorFlow Model Server](https://www.tensorflow.org/serving), and the data to be analyzed must be available on disk as a [TFRecords](https://medium.com/mostly-ai/tensorflow-records-what-they-are-and-how-to-use-them-c46bc4bbb564) file. For more details, refer to the [documentation](https://github.com/tensorflow/tensorboard/tree/master/tensorboard/plugins/interactive_inference#what-do-i-need-to-use-it-in-tensorboard) for using WIT in TensorBoard.

### Using WIT with Notebooks

To be able to access WIT within notebooks, you need a WitConfigBuilder object that specifies the data and model to be analyzed. This [documentation](https://github.com/tensorflow/tensorboard/tree/master/tensorboard/plugins/interactive_inference#notebook-mode-details) provides a step-by-step outline for using WIT in a notebook.

![](https://cdn-images-1.medium.com/max/2000/0*bUExfjdJSB0BqCpt.png)

***

You can also use a [demo notebook](https://colab.research.google.com/github/pair-code/what-if-tool/blob/master/WIT_Model_Comparison.ipynb) and edit the code to include your datasets to start working.

## Walkthrough

Let’s now explore the capabilities of the WIT tool with an example. The example has been taken from the demos provided on the website and is called **Income Classification** wherein we need to predict whether a person earns more than $50k a year, based on their census information. The Dataset belongs to the [**UCI Census dataset**](http://archive.ics.uci.edu/ml/datasets/Census+Income) consisting of a number of attributes such as age, marital status and education level.

### Overview

Let’s begin by doing some Exploration of the dataset. Here is a [link](https://pair-code.github.io/what-if-tool/uci.html) to the web Demo for following along.

What-if tool contains two main panels. The **right panel** contains a visualization of the individual data points in the data set you have loaded.

![](https://cdn-images-1.medium.com/max/2210/1*Fpeb_UkmNv53Wo55nQ9O0A.png)

In this case, the **blue dots** are people for whom the model has inferred an income of **less than 50k** and the **red dots** are those that the model inferred earn **more than 50k.** By default, WIT uses a [positive classification threshold](https://developers.google.com/machine-learning/crash-course/classification/thresholding) of 0.5. This means that if the inference score is 0.5 or more, the data point is considered to be in a positive class, i.e. high income.

> What is interesting to note here is that the dataset is visualized in [**Facets Dive**](https://pair-code.github.io/facets/). Facets Dive is a part of the **FACETS**’ tool developed again by the PAIR team and helps us to understand the various features of data and explore them. In case you are not familiar with the tool, you may want to refer to this article on FACETS’ capabilities, which I had written a while ago.

- [**Visualising Machine Learning Datasets with Google’s FACETS.** An open source tool from Google to easily learn patterns from large amounts of data**](https://towardsdatascience.com/visualising-machine-learning-datasets-with-googles-facets-462d923251b3)

One can also organize the data points in tons of different ways including confusion matrices, scatter plots, histograms and small multiples of plots by simply selecting the fields from the drop-down menu. A few examples have been presented below.

![](https://cdn-images-1.medium.com/max/2000/1*34aQWjQZC_Q0gCG4_YNF_g.png)

![](https://cdn-images-1.medium.com/max/2000/1*QlLrTAdwfi1t9rwonhUu9A.png)

The **left panel** contains three tabs called `Datapoint Editor,` `Performance & Fairness` ; and `Features.`

### 1. Datapoint Editor Tab

The Datapoint Editor helps to perform data analysis through:

* **Viewing and Editing details of Datapoints**

It allows diving into a selected data point which gets highlighted in yellow on the right panel. Let’s try changing the age from 53 to 58 and clicking the “Run inference” button to see what effect it has on the model’s performance.

![](https://cdn-images-1.medium.com/max/2000/1*NO4eJz9J0GYn60W0UkpuhA.gif)

By simply changing the age of this person, the model now predicts that the person belongs to high-income category. For this data point, earlier the inference score for the positive (high income) class was 0.473, and the score for negative (low income) class was 0.529. However, by changing the age, the positive class score became 0.503.

* **Finding Nearest Counterfactuals**

Another way to understand the model’s behaviour is to look at what small set of changes can cause the model to flip its decision which is called **counterfactual**s. With one click we can see the most similar counterfactual, which is highlighted in green, to our selected data point. In the data point editor tab we now also see the feature values for the counterfactual next to the feature values for our original data point. The green text represents features where the two data points differ. WIT uses [L1 and L2](https://www.kaggle.com/residentmario/l1-norms-versus-l2-norms) distances to calculate the similarity between the data points.

![](https://cdn-images-1.medium.com/max/2008/1*H7S9oSQgPP7H56NSFXg_hg.png)

In this case, the nearest counterfactual is slightly older and has a different occupation and capital gain, but is otherwise identical.

We can also see the similarity between the selected points and others using the “**show similarity to selected datapoint**” button. WIT measures the distance from the selected point to every other datapoint. Let’s change our X-axis scatter to show the L1 distance to the selected datapoint.

![](https://cdn-images-1.medium.com/max/2000/1*lSHybyMux8FdsWlO7HasgA.png)

* **Analysing partial dependence plots**

The partial dependence plot (short PDP or PD plot) shows the marginal effect one or two features have on the predicted outcome of a machine learning model( [J. H. Friedman 2001](https://statweb.stanford.edu/~jhf/ftp/trebst.pdf)).

The PDPs for age and Education for a data point are as follows:

![](https://cdn-images-1.medium.com/max/2000/1*Go_5BeraltIgPnfaW6xA0g.gif)

The plot above shows that:

* The model has learned a positive correlation between age and income
* More advanced degrees give the model more confidence in higher income.
* High capital gains is a very strong indicator of high income, much more than any other single feature.

### 2. Performance & Fairness Tab

This tab allows us to look at the overall model performance using confusion matrices and ROC curves.

* **Model Performance Analysis**

To measure the model’s performance, we need to tell the tool what is the ground truth feature i.e the feature that the model is trying to predict which in this case is “**Over-50K**”.

![](https://cdn-images-1.medium.com/max/3210/1*131qNOeuhboNCGVTh9y6sw.png)

We can see that at the default threshold level of 0.5, our model is incorrect about 15% of the time, with about 5% of the time being false positives and 10% of the time being false negatives. Change the threshold values to see its impact on the model’s accuracy.

There is also a setting for “**cost ratio**” and an “**optimize threshold**” button which can also be tweaked.

* **ML Fairness**

Fairness in Machine Learning is as important as model building and predicting an outcome. Any bias in the training data will be reflected in the trained model and if such a model is deployed, the resultant outputs will also be biased. The WIT can help investigate fairness concerns in a few different ways. We can set an input feature (or set of features) with which to slice the data. For example, let’s see the effect of gender on model performance.

![Effect of gender on Model’s performance](https://cdn-images-1.medium.com/max/2966/1*BhlfFvlDiLC4FYyi_WTRZA.png)

We can see that the model is more accurate on females than males. Also, the model predicts high income for females much less than it does for males (9.3% of the time for females vs 28.6% of the time for males). One probable reason might be due to the under-representation of females in the dataset which we shall explore in the next section.

Additionally, the tool can optimally set the decision threshold for the two subsets while taking into account any of a number of constraints related to algorithmic fairness such as demographic parity or equal opportunity.

### 3. Features Tab

The features tab gives the summary statistics of each of the features in the dataset including histograms, quantile charts, bar charts etc. The tab also enables to look into the distribution of values for each feature in the dataset. For instance, let us explore the sex, capital gain and race features.

![](https://cdn-images-1.medium.com/max/2000/1*pSN720U3hG54Zrkv5UpNag.png)

We infer that` capital gain` is very non-uniform, with most datapoints having being set to 0.

![](https://cdn-images-1.medium.com/max/2000/1*5FmxAvQhvgNASSwoco5NlA.png)

![Native Country DIstribution || Sex distribution](https://cdn-images-1.medium.com/max/2000/1*_V4de4Q2lJAEnMWKI-maOQ.png)

***

Similarly, most datapoints belong to the United States while females are not well represented in the dataset. Since the data is biased, it is but natural that its predictions are targeted towards one group only. Afterall a model learns from the data it is provided and if the source is skewed so will be the results. Machine learning has proved its mettle in a lot of applications and areas. However, one of the key hurdles for industrial applications of machine learning models is to determine whether the raw input data used to train the model contains discriminatory bias or not.

## Conclusion

***

This was just a quick run-through of some of the what if tools features. WIT is a pretty handy tool which gives the ability to probe the models, into the hands of the people to whom it matters the most. Simply creating and training a model isn’t the purpose of Machine Learning but understanding why and how that model was created is Machine Learning in true sense.

### References:

1. [The What-If Tool: Code-Free Probing of Machine Learning Models](https://ai.googleblog.com/2018/09/the-what-if-tool-code-free-probing-of.html)
2. [https://pair-code.github.io/what-if-tool/walkthrough.html](https://pair-code.github.io/what-if-tool/walkthrough.html)
3. [https://github.com/tensorflow/tensorboard/tree/master/tensorboard/plugins/interactive_inference](https://github.com/tensorflow/tensorboard/tree/master/tensorboard/plugins/interactive_inference)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
