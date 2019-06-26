> * 原文地址：[Why One-Hot Encode Data in Machine Learning](https://machinelearningmastery.com/why-one-hot-encode-data-in-machine-learning/)
> * 原文作者：[Jason Brownlee](https://machinelearningmastery.com/author/jasonb/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-one-hot-encode-data-in-machine-learning.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-one-hot-encode-data-in-machine-learning.md)
> * 译者：
> * 校对者：

# Why One-Hot Encode Data in Machine Learning?

Getting started in applied machine learning can be difficult, especially when working with real-world data.

Often, machine learning tutorials will recommend or require that you prepare your data in specific ways before fitting a machine learning model.

One good example is to use a one-hot encoding on categorical data.

*   Why is a one-hot encoding required?
*   Why can’t you fit a model on your data directly?

In this post, you will discover the answer to these important questions and better understand data preparation in general in applied machine learning.

Let’s get started.

![Why One-Hot Encode Data in Machine Learning?](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2017/07/Why-One-Hot-Encode-Data-in-Machine-Learning.jpg)

Why One-Hot Encode Data in Machine Learning?
Photo by [Karan Jain](https://www.flickr.com/photos/jiangkeren/8263176332/), some rights reserved.

## What is Categorical Data?

Categorical data are variables that contain label values rather than numeric values.

The number of possible values is often limited to a fixed set.

Categorical variables are often called [nominal](https://en.wikipedia.org/wiki/Nominal_category).

Some examples include:

*   A “_pet_” variable with the values: “_dog_” and “_cat_”.
*   A “_color_” variable with the values: “_red_”, “_green_” and “_blue_”.
*   A “_place_” variable with the values: “first”, “_second_” _and_ “_third_”.

Each value represents a different category.

Some categories may have a natural relationship to each other, such as a natural ordering.

The “_place_” variable above does have a natural ordering of values. This type of categorical variable is called an ordinal variable.

## What is the Problem with Categorical Data?

Some algorithms can work with categorical data directly.

For example, a decision tree can be learned directly from categorical data with no data transform required (this depends on the specific implementation).

Many machine learning algorithms cannot operate on label data directly. They require all input variables and output variables to be numeric.

In general, this is mostly a constraint of the efficient implementation of machine learning algorithms rather than hard limitations on the algorithms themselves.

This means that categorical data must be converted to a numerical form. If the categorical variable is an output variable, you may also want to convert predictions by the model back into a categorical form in order to present them or use them in some application.

## How to Convert Categorical Data to Numerical Data?

This involves two steps:

1.  Integer Encoding
2.  One-Hot Encoding

### 1. Integer Encoding

As a first step, each unique category value is assigned an integer value.

For example, “_red_” is 1, “_green_” is 2, and “_blue_” is 3.

This is called a label encoding or an integer encoding and is easily reversible.

For some variables, this may be enough.

The integer values have a natural ordered relationship between each other and machine learning algorithms may be able to understand and harness this relationship.

For example, ordinal variables like the “place” example above would be a good example where a label encoding would be sufficient.

### 2. One-Hot Encoding

For categorical variables where no such ordinal relationship exists, the integer encoding is not enough.

In fact, using this encoding and allowing the model to assume a natural ordering between categories may result in poor performance or unexpected results (predictions halfway between categories).

In this case, a one-hot encoding can be applied to the integer representation. This is where the integer encoded variable is removed and a new binary variable is added for each unique integer value.

In the “_color_” variable example, there are 3 categories and therefore 3 binary variables are needed. A “1” value is placed in the binary variable for the color and “0” values for the other colors.

For example:

```
red, green, blue
1, 0, 0
0, 1, 0
0, 0, 1
```
The binary variables are often called “dummy variables” in other fields, such as statistics.

## One Hot Encoding Tutorials


Looking for some tutorials on how to one hot encode your data in Python, see:

*   [Data Preparation for Gradient Boosting with XGBoost in Python](https://machinelearningmastery.com/data-preparation-gradient-boosting-xgboost-python/)
*   [How to One Hot Encode Sequence Data in Python](https://machinelearningmastery.com/how-to-one-hot-encode-sequence-data-in-python/)

## Further Reading

*   [Categorical variable](https://en.wikipedia.org/wiki/Categorical_variable) on Wikipedia
*   [Nominal category](https://en.wikipedia.org/wiki/Nominal_category) on Wikipedia
*   [Dummy variable](https://en.wikipedia.org/wiki/Dummy_variable_(statistics)) on Wikipedia

## Summary

In this post, you discovered why categorical data often must be encoded when working with machine learning algorithms.

Specifically:

*   That categorical data is defined as variables with a finite set of label values.
*   That most machine learning algorithms require numerical input and output variables.
*   That an integer and one hot encoding is used to convert categorical data to integer data.

Do you have any questions?

Post your questions to comments below and I will do my best to answer.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
