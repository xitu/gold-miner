> * 原文地址：[3 Levels of Deep Learning Competence](https://machinelearningmastery.com/deep-learning-competence/)
> * 原文作者：[Jason Brownlee](https://machinelearningmastery.com/author/jasonb) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/deep-learning-competence.md](https://github.com/xitu/gold-miner/blob/master/TODO1/deep-learning-competence.md)
> * 译者：
> * 校对者：         

# 3 Levels of Deep Learning Competence

[Deep learning](https://machinelearningmastery.com/what-is-deep-learning/) is not a magic bullet, but the techniques have shown to be highly effective in a large number of very challenging problem domains.

This means that there is a ton of demand by businesses for effective deep learning practitioners.

The problem is, how can the average business differentiate between good and bad practitioners?

As a deep learning practitioner, how can you best demonstrate that you can deliver skillful deep learning models?

In this post, you will discover the three levels of deep learning competence, and as a practitioner, what you must demonstrate at each level.

After reading this post, you will know:

*   The problem of evaluating deep learning competence can best be addressed through project portfolios.
*   A hierarchy of three competency levels can be used to sort practitioners and provide a framework for identifying the expected skills.
*   The most common mistake that beginners make is starting at level 3, meaning they are trying to learn all levels at once, leading to confusion and frustration.

Let’s get started.

![The Three Levels of Deep Learning Competence](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/03/The-Three-Levels-of-Deep-Learning-Competence.jpg)

The Three Levels of Deep Learning Competence  
Photo by [Bernd Thaller](https://www.flickr.com/photos/bernd_thaller/45309108974/), some rights reserved.

## Overview

This post is divided into three parts; they are:

1.  The Problem of Assessing Competence
2.  Develop a Deep Learning Portfolio
3.  Levels of Deep Learning Competence

## The Problem of Assessing Competence

How do you know if a practitioner is competent with deep learning?

It is a hard problem.

*   An academic may be able to describe techniques well mathematically and provide a list of papers.
*   A developer may also be able to describe techniques well using intuitive explanations and a list of APIs.

Both are good signs of understanding.

But, on real business projects, we don’t need explanations.

We need working models that make skillful predictions. We need results.

Results trump almost everything.

Certainly results trump classical signals of competence such as education pedigree, work history, and experience level.

Most developers and developer hiring managers know this already.

Some don’t.

## Develop a Deep Learning Portfolio

The best way to answer the question of whether a practitioner is competent or not is to show, not tell.

The practitioner must provide evidence to demonstrate that they understand how to apply deep learning techniques and use them to develop skillful models.

This means developing a [public portfolio of projects](https://machinelearningmastery.com/build-a-machine-learning-portfolio/) using open source libraries and publicly available datasets.

This has benefits for a number of reasons:

*   Skillful models can be presented.
*   Code can be reviewed.
*   Design decisions can be defended.

An honest discussion of real projects will quickly shed light on whether the practitioner knows what they are doing, or not.

*   Employers must require and then focus on a portfolio of completed work in order to assess competence.
*   Deep learning practitioners must develop and maintain a portfolio of completed projects in order to demonstrate competence.

As a practitioner, the question becomes: what are the levels of competence and what are the expectations at each level?

## Levels of Deep Learning Competence

Projects can be carefully chosen in order to both develop and, in turn, demonstrate specific skills.

In this section, we’ll outline the levels of deep learning competence and the types of projects that you, as a practitioner, can develop and implement in order to learn, acquire and demonstrate each level of competence.

There are three levels of deep learning competence; they are:

*   **Level 1**: Modeling
*   **Level 2**: Tuning
*   **Level 3**: Applications

This may not be complete, but provides a good starting point for practitioners in a business setting.

Some notes about this hierarchy:

*   The levels assume you are already a machine learning practitioner, probably not starting from scratch.
*   Not all businesses require or could make best use of a Level 3 practitioner.
*   Many practitioners dive in at Level 3, and try to figure out levels 1 and 2 on the fly.
*   Level 2 is often neglected, but I think is critical in order to demonstrate a deeper understanding.

Other levels might capture topics not discussed such as coding algorithms from scratch, handling big data or streaming data, GPU programming, developing novel methods, etc.

If you have more ideas of levels of competence or projects, please let me know in the comments below.

Now, let’s take a closer look at each level in turn.

## Level 1: Modeling

This level of competence with deep learning assumes that you are already a machine learning practitioner.

It is the lowest level and shows that you can use the tools and methods effectively on a classical machine learning type project.

It does not mean that you are expected to have advanced degrees or that you are a master practitioner. Instead, it means that you are familiar with the basics of applied machine learning and the process of working through a predictive modeling project end-to-end.

This is not a strict prerequisite as these elements can quickly be learned at this level if needed.

Competence at this level demonstrates the following:

*   **Library Competence**: That you know how to use an open source deep learning library to develop a model.
*   **Modeling Competence**: That you know how to apply the applied machine learning process with neural network models.

### Library Competence

Library competence means that you know how to set up the development environment and use the most common aspects of the API in order to define, fit, and use neural network models to make predictions.

It also means that you know the basic differences between each type of neural network model and when it might be appropriate to use it.

It does not mean that you know every function call and every parameter. It also does not mean that you know the mathematical description for specific techniques.

### Modeling Competence

Modeling competence means that you know how to work through a machine learning project end-to-end using neural network models.

Specifically, it means that you are able to complete tasks such as:

*   Defining the supervised learning problem and gathering the relevant data.
*   Preparing data, including feature selection, imputing missing values, scaling, and other transforms.
*   Evaluating a suite of models and model configurations using an objective test harness.
*   Selecting and preparing a final model and using it to make predictions on new data.

It means that you can effectively harness neural networks on new projects in developing and using a skillful model.

It does not mean that you’re an expert at using all or even some neural network techniques or that you can achieve the best possible result. It also does not mean that you are familiar with all data types.

### Projects

Projects to demonstrate this level of competence should use an open source deep learning library (such as Keras) and show each step of the applied machine learning process on public tabular machine learning datasets.

This does not mean achieving the best possible result for a dataset or even that using a neural network is the best possible model for the dataset. Instead, the goal is to demonstrate the capability of using neural networks, most likely simpler model types such as Multilayer Perceptrons.

A good source of datasets are the small in-memory datasets used widely in the 1990s and 2000s to demonstrate machine learning and even neural network performance, such as those listed on the [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/index.php).

The fact that the datasets are small and easily fit in memory means that the scope of the projects is also small, permits the use of robust model evaluation schemes such as k-fold cross-validation, and may require careful model design in order to avoid overfitting.

I would expect a range of projects handling the normal concerns of standard predictive modeling projects, such as:

Varied input data in order to demonstrate data preparation suitable for neural networks:

*   Input variables with the same scale.
*   Input variables with differing scales.
*   Mixture of numerical and categorical variables.
*   Variables with missing values.
*   Data with redundant input features.

Varied target variables in order to demonstrate a suitable model configuration:

*   Binary classification tasks.
*   Multiclass classification tasks.
*   Regression tasks.

## Level 2: Tuning

This level of competence assumes Level 1 competence and shows that you can use classical as well as modern techniques in order to get the most from deep learning neural network models.

It demonstrates the following:

*   **Learning Competence**. That you can improve the training process of neural network models.
*   **Generalization Competence**. That you can reduce overfitting of the training data and reduce the generalization error on out of sample data.
*   **Prediction Competence**. That you can reduce the variance in the prediction of final models and lift model skill.

### Learning Competence

Learning competence means that you know how to configure and tune the hyperparameters of the learning algorithm in order to get good or better performance.

This means skill in tuning hyperparameters of stochastic gradient descent, such as:

*   Batch size.
*   Learning rate.
*   Learning rate schedules
*   Adaptive learning rates.

This means skill in tuning aspects that influence model capability, such as:

*   Model choice.
*   Choice of activation functions.
*   Number of nodes.
*   Number of layers.

This means skill in defusing problems with learning, such as:

*   Vanishing gradients.
*   Exploding gradients.

It also means skill with techniques to accelerate learning, such as:

*   Batch normalization.
*   Layer-wise training.
*   Transfer learning.

### Generalization Competence

Generalization competence means that you know how to configure and tune a model in order to reduce overfitting and improve model performance on out of sample data.

This includes classical techniques such as:

*   Weight regularization.
*   Adding noise.
*   Early Stopping.

This also includes modern techniques such as:

*   Weight constraints.
*   Activity regularization.
*   Dropout.

### Prediction Competence

Predictive competence means that you know how to use techniques to reduce the variance of a chosen model when making predictions and combine models in order to lift performance.

This means use of ensemble techniques, such as:

*   Model averaging.
*   Stacking ensembles.
*   Weight averaging.

### Projects

Projects that demonstrate this level of competence may be less focused on all of the steps in the process of applied machine learning and instead may focus on a specific problem and technique or range of techniques designed to alleviate it.

For the three areas of competence, these could be:

*   A problem of poor or slow learning by a model.
*   A problem of overfitting a training dataset.
*   A problem of high variance predictions.

Again, this does not mean achieving the best possible performance on a specific problem, only demonstrating the correct use of a technique and its ability to address the identified issue.

Choice of datasets and even problem type may matter less than the clear manifestation of the issue that is being investigated.

Some datasets naturally introduce problems; for example, small training datasets and imbalanced datasets can result in overfitting.

Standard machine learning datasets could be used. Alternately, problems can be contrived to demonstrate the issue or dataset generators could be used.

## Level 3: Applications

This level of competence assumes Level 1 and 2 competence and shows that you can use deep learning neural network techniques in specialized problem domains.

This is the demonstration of deep learning techniques beyond simple tabular datasets.

This is also the demonstration of deep learning on the types of problem domains and specific problem instances where the techniques may perform well or even be state-of-the-art.

It demonstrates the following:

*   **Data Handling Competence**. That you can load and prepare domain-specific data ready for modeling with neural networks.
*   **Technique Competence**. That you can compare and select appropriate domain-specific neural network models.

### Data Handling Competence

Data handling competence means that you can acquire, load, use, and prepare the data for modeling.

This will very likely demonstrate competence with standard libraries for handling the data and standard techniques for preparing the data.

Some examples of domains and data handling might include:

*   **Time Series Forecasting**. Code for framing time series problems as supervised learning problems.
*   **Computer Vision**. APIs for loading images and transforms to resize, perhaps standardize, pixels.
*   **Natural Language Processing**. APIs for loading text data and transforms for encoding characters or words.

### Technique Competence

Technique competence means that you can correctly identify the techniques, models, and model architectures that are appropriate for a given domain-specific modeling problem.

This will very likely require a familiarity with common methods used in the academic literature and/or industry for general classes of problems in the domain.

Some examples of domains and domain-specific methods might include:

*   **Time Series Forecasting**. Use of sequence prediction models such as convolutional and recurrent neural network models.
*   **Computer Vision**. Use of deep convolutional neural network models and use of specific architectures.
*   **Natural Language Processing**. Use of deep recurrent neural network models and use of specific architectures.

### Projects

Projects that demonstrate this level of competence must cover the applied machine learning process, include careful model tuning (aspects of competence Levels 1 and 2), and must focus on domain-specific datasets.

Datasets may be sourced from:

*   Standard datasets used in academia to demonstrate methods.
*   Datasets used on competitive machine learning websites.
*   Original datasets defined and collected by you.

There may be a large range of problems that belong to a given problem domain, although there will be a subset that is perhaps more common or prominent and these can be the focus of demonstration projects.

Some example of domains and prominent sub-problems might include:

*   **Time Series Forecasting**. Univariate, multivariate, multi-step, and classification.
*   **Computer Vision**. Object classification, object localization, and object description.
*   **Natural Language Processing**. Text classification, text translation, and text summarization.

It may be desirable to demonstrate competence at a high level across multiple domains, and the data handling, modeling techniques, and skills will translate well.

It may also be desirable to specialize in a domain and to narrow down to demonstration projects on subtle sub-problems after the most prominent problems and techniques have been addressed.

Because projects of this type may demonstrate the broader appeal of deep learning (e.g. the ability to outperform classical methods), there is a danger in jumping straight to this level.

It may be possible for experienced practitioners, with ether deeper knowledge and experience with other machine learning methods or with deeper knowledge and experience with the domain.

Nevertheless, it is significantly harder as you may have to learn and you must harness and demonstrate all three levels of competence at once.

This is by far the biggest mistake of beginners who dive into domain-specific projects and crash into roadblock after roadblock given they are not yet competent with the library, the process of working through a project, and the process of improving model performance, let alone the specific data handling and modeling techniques used in the domain.

Again, it is possible to start at this level; it just triples the workload and may result in frustration.

Did this competence framework resonate? Do you think there are any holes?  
Let me know in the comments.

## Further Reading

This section provides more resources on the topic if you are looking to go deeper.

### Posts

*   [Build a Machine Learning Portfolio](https://machinelearningmastery.com/build-a-machine-learning-portfolio/)
*   [What is Deep Learning?](https://machinelearningmastery.com/what-is-deep-learning/)
*   [8 Inspirational Applications of Deep Learning](https://machinelearningmastery.com/inspirational-applications-deep-learning/)
*   [7 Applications of Deep Learning for Natural Language Processing](https://machinelearningmastery.com/applications-of-deep-learning-for-natural-language-processing/)

### Articles

*   [UC Irvine Machine Learning Repository](https://archive.ics.uci.edu/ml/index.php)
*   [List of datasets for machine learning research, Wikipedia](https://en.wikipedia.org/wiki/List_of_datasets_for_machine_learning_research).
*   [Deep Learning Datasets](http://deeplearning.net/datasets/)
*   [25 Open Datasets for Deep Learning Every Data Scientist Must Work With, Analytics Vidhya](https://www.analyticsvidhya.com/blog/2018/03/comprehensive-collection-deep-learning-datasets/).

## Summary

In this post, you discovered the three levels of deep learning competence and as a practitioner, what you must demonstrate at each level.

Specifically, you learned:

*   The problem of evaluating deep learning competence can best be addressed through project portfolios.
*   A hierarchy of three competency levels can be used to sort practitioners and provide a framework for identifying the expected skills
*   The most common mistake that beginners make is starting at level 3, meaning they are trying to learn all levels at once, leading to confusion and frustration.

Do you have any questions?  
Ask your questions in the comments below and I will do my best to answer.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。 
