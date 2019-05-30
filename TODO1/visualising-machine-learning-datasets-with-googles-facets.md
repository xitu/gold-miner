> * 原文地址：[Visualising Machine Learning Datasets with Google’s FACETS.](https://towardsdatascience.com/visualising-machine-learning-datasets-with-googles-facets-462d923251b3)
> * 原文作者：[Parul Pandey](https://medium.com/@parulnith)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/visualising-machine-learning-datasets-with-googles-facets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/visualising-machine-learning-datasets-with-googles-facets.md)
> * 译者：
> * 校对者：

# Visualising Machine Learning Datasets with Google’s FACETS.

> An open source tool from Google to easily learn patterns from large amounts of data

![Photo by [Franki Chamaki](https://unsplash.com/@franki?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8064/0*AAAs7V238jAuaZp_)

> More data beats clever algorithms, but better data beats more data : Peter Norvig

There has been a lot of uproar as to how a large quantity of training data can have a tremendous impact on the results of a machine learning model. However, along with data quantity, it is also the quality which is critical to building a powerful and robust ML system. After all ‘GARBAGE IN: GARBAGE OUT’ i.e what you get from the system will be a representation of what you feed into the system.

A Machine Learning dataset sometimes consists of data points ranging from thousands to millions which in turn may contain hundreds or thousands of features. Additionally, real-world data is messy comprising of missing values, unbalanced data, outliers etc. Therefore it becomes imperative that we clean the data before proceeding with model building. Visualising the data can help in locating these irregularities and pointing out the locations where the data actually needs cleaning. Data Visualisation gives an overview of the entire data irrespective of its quantity and helps to perform EDA in a fast and accurate manner.

---

## FACETS

![](https://cdn-images-1.medium.com/max/2168/1*3tUB6KRfE-FapwbH4Lz0Vg.png)

The dictionary meaning of facets boils down to a particular aspect or feature of something. In the same way, the [**FACETS**](https://ai.googleblog.com/2017/07/facets-open-source-visualization-tool.html) tool helps us to understand the various features of data and explore them without having to explicitly code.

Facets is an open-source visualisation tool released by Google under the **[PAIR](https://ai.google/research/teams/brain/pair)(People + AI Research)** initiative. This tool helps us to understand and analyse the Machine Learning datasets. Facets consist of two visualisations, both of which help to drill down the data and provide great insights without much of work at user’s end.

* **Facets Overview**

As the name suggests, this visualisation gives an overview of the entire dataset and gives a sense of the shape of each feature of the data. Facets Overview summarizes statistics for each feature and compares the training and test datasets.

* **Facets Dive**

This feature helps the user to dive deep into the individual feature/observation of the data to get more information. It helps in interactively exploring large numbers of data points at once.

> These visualizations are implemented as [Polymer](https://www.polymer-project.org/) web components, backed by [Typescript](https://www.typescriptlang.org/) code and can be easily embedded into Jupyter notebooks or web pages.

---

## Usage & Installation

There are two ways in which FACETS can be used with data:

#### Web App

It can be used directly from its demo page whose link is embedded below.
[**Facets - Visualizations for ML datasets**
**Dive provides an interactive interface for exploring the relationship between data points across all of the different…**pair-code.github.io](https://pair-code.github.io/facets/)

This website allows anyone to visualize their own datasets directly in the browser without the need for any software installation or setup, without the data ever leaving your computer.

#### Within Jupyter Notebooks/Colaboratory

It is also possible to use FACETS within Jupyter Notebook/Colaboratoty. This gives more flexibility since the entire EDA and modelling can be done in a single notebook. Please refer their [Github Repository](https://github.com/pair-code/facets#setup) for complete details on installation. However later in the article, we will see how to get going with FACETS in colab.

---

## Data

Although you can work with data provided on the demo page, I shall be working with another set of data. I will be doing EDA with FACETS on the **Loan Prediction Dataset**. The problem statement is to predict whether an applicant who has been granted a loan by a company, will repay it back or not. It is a fairly known example in the ML community.

The **dataset** which has already been divided into Training and Testing set can be accessed from [**here**](https://github.com/parulnith/Data-Visualisation-Tools/tree/master/Data%20Visualisation%20with%20Facets%20). Let’s load in our data into the Colab.

```
import pandas as pd
train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')
```

Now lets us understand how we can use Facets Overview with this data.

#### FACETS Overview

The Overview automatically gives a quick understanding of the distribution of values across the various features of the data. The distribution can also be compared across the training and testing datasets instantly. If some anomaly exists in the data, it just pops out from the data there and then.

Some of the information that can be easily accessed through this feature are:

* Statistics like mean, median and Standard Deviation
* Min and Max values of a column
* Missing data
* Values that have zero values
* Since it is possible to view the distributions across test dataset also, we can easily confirm if the training and testing data follow the same distributions.

> One would argue that we can achieve these tasks easily with Pandas and why should we invest into another tool. This is true and maybe not required when we have few data points with minimum features. However, the scenario changes when we are talking about a large dataset where it becomes kind of difficult to analyse each and every data point in multiple columns.

Google Colaboaratory makes it very easy to work since we do not need to install additional things. By writing a few lines of code our work gets done.

```
# Clone the facets github repo to get access to the python feature stats generation code
!git clone https://github.com/pair-code/facets.git
```

To calculate the feature statistics, we need to use the function GenericFeatureStatisticsGenerator() which lies in a Python Script.

```
# Add the path to the feature stats generation code.
import sys
sys.path.insert(0, '/content/facets/facets_overview/python/')

# Create the feature stats for the datasets and stringify it.
import base64
from generic_feature_statistics_generator import GenericFeatureStatisticsGenerator

gfsg = GenericFeatureStatisticsGenerator()
proto = gfsg.ProtoFromDataFrames([{'name': 'train', 'table': train},
                                  {'name': 'test', 'table': test}])
protostr = base64.b64encode(proto.SerializeToString()).decode("utf-8")
```

Now with the following lines of code, we can easily display the visualisation right in our notebook.

```
# Display the facets overview visualization for this data
from IPython.core.display import display, HTML

HTML_TEMPLATE = """<link rel="import" href="https://raw.githubusercontent.com/PAIR-code/facets/master/facets-dist/facets-jupyter.html" >
        <facets-overview id="elem"></facets-overview>
        <script>
          document.querySelector("#elem").protoInput = "{protostr}";
        </script>"""
html = HTML_TEMPLATE.format(protostr=protostr)
display(HTML(html))
```

As soon as you type `Shift+Enter`, you are welcomed by this nice interactive visualisation:

![](https://cdn-images-1.medium.com/max/2000/1*ZXS2t1A8JZDtxGsfUP3GFQ.png)

Here, we see the Facets Overview visualization of the five numeric features of the Loan Prediction dataset. The features are sorted by non-uniformity, with the feature with the most non-uniform distribution at the top. Numbers in red indicate possible trouble spots, in this case, numeric features with a high percentage of values set to 0. The histograms at right allow you to compare the distributions between the training data (blue) and test data (orange).

![](https://cdn-images-1.medium.com/max/2000/1*0yYTqIN5Vimf_0SxxB-35w.png)

The above visualisation shows one of the eight categorical features of the dataset. The features are sorted by distribution distance, with the feature with the biggest skew between the training (blue) and test (orange) datasets at the top.

#### FACETS Dive

[Facets Dive](https://ai.googleblog.com/2017/07/facets-open-source-visualization-tool.html) provides an easy-to-customize, intuitive interface for exploring the relationship between the data points across the different features of a dataset. With Facets Dive, you control the position, colour and visual representation of each data point based on its feature values. If the data points have images associated with them, the images can be used as the visual representations.

To use the Dive visualisation, the data has to be transformed into JSON format.

```
# Display the Dive visualization for the training data.
from IPython.core.display import display, HTML

jsonstr = train.to_json(orient='records')
HTML_TEMPLATE = """<link rel="import" href="https://raw.githubusercontent.com/PAIR-code/facets/master/facets-dist/facets-jupyter.html">
        <facets-dive id="elem" height="600"></facets-dive>
        <script>
          var data = {jsonstr};
          document.querySelector("#elem").data = data;
        </script>"""
html = HTML_TEMPLATE.format(jsonstr=jsonstr)
display(HTML(html))
```

After you run the code, you should be able to see this:

![Facets Dive Visualisation](https://cdn-images-1.medium.com/max/2000/1*X3BYI7oGEvlZv_CejS1wZA.png)

Now we can easily perform Univariate and Bivariate Analysis and let us see some of the results obtained:

#### Univariate Analysis

Here we will look at the target variable, i.e., Loan_Status and other categorical features like gender, Marital Status, Employment status and Credit history, independently. Likewise, you can play around with other features also.

![](https://cdn-images-1.medium.com/max/2000/1*bCJ-ofkzPvhO5TuMgQ7VOw.gif)

#### Inferences:

* Most of the applicants in the dataset are male.
* Again a majority of the applicants in the dataset are married and have repaid their debts.
* Also, most of the applicants have no dependents and are graduates from semi-urban areas.

Now let’s visualize the ordinal variables i.e Dependents, Education and Property Area.

![](https://cdn-images-1.medium.com/max/2000/1*ufgW6M-AanfNCjWBjQ6Aig.gif)

Following inferences can be made from the above bar plots:

* Most of the applicants don’t have any dependents.
* Most of the applicants are Graduate.
* Most of the applicants are from Semiurban area.

Now you can continue your analysis with the numerical data.

#### Bivariate Analysis

We will find the relationship between the target variable and categorical independent variables.

![](https://cdn-images-1.medium.com/max/2000/1*D2Tio24GXTKIdP84duZIIQ.gif)

It can be inferred from the above bar plots that:

* The proportion of married applicants is higher for the approved loans.
* Distribution of applicants with 1 or 3+ dependents is similar across both the categories of Loan_Status.
* It seems people with credit history as 1 are more likely to get their loans approved.
* The proportion of loans getting approved in the semiurban area is higher as compared to that in rural or urban areas.

---

## Conclusion

FACETS provides an easy and intuitive environment to perform EDA for datasets and helps us derive meaningful results. The only catch is that currently it only works with **Chrome**.

Before ending this article, let us also see a **fun fact** highlighting how a small human labelling error in CIFAR-10 dataset was caught using the FACETS Dive. While analysing the dataset it came to notice that an image of a frog had been incorrectly labelled as a cat. Well, this is indeed some achievement since it would be an impossible task for a human eye.

![[Source](https://ai.googleblog.com/2017/07/facets-open-source-visualization-tool.html)](https://cdn-images-1.medium.com/max/2000/1*VfkUBpXdGNIsK_RKT-ct1Q.gif)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
