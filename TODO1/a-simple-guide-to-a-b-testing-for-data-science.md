> * 原文地址：[A Simple Guide to A/B Testing for Data Science](https://towardsdatascience.com/a-simple-guide-to-a-b-testing-for-data-science-73d08bdd0076)
> * 原文作者：[Terence Shin](https://medium.com/@terenceshin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-a-b-testing-for-data-science.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-a-b-testing-for-data-science.md)
> * 译者：
> * 校对者：

# A Simple Guide to A/B Testing for Data Science

> One of the most important statistical methods for data scientists

![Picture created by myself, Terence Shin, and Freepik](https://cdn-images-1.medium.com/max/2000/0*KS_jfZBdZ9DxAvEz.png)

A/B testing is one of the most important concepts in data science and in the tech world in general because it is one of the most effective methods in making conclusions about any hypothesis one may have. It’s important that you understand what A/B testing is and how it generally works.

## Table of Content

1. [What is A/B testing?](#64ca)
2. [Why is it important to know?](#bd65)
3. [How to conduct a standard A/B test](#7264)

## What is A/B testing?

A/B testing in its simplest sense is an experiment on two variants to see which performs better based on a given metric. Typically, two consumer groups are exposed to two different versions of the same thing to see if there is a significant difference in metrics like sessions, click-through rate, and/or conversions.

Using the visual above as an example, we could randomly split our customer base into two groups, a control group and a variant group. Then, we can expose our variant group with a red website banner and see if we get a significant increase in conversions. It’s important to note that all other variables need to be held constant when performing an A/B test.

Getting more technical, A/B testing is a form of statistical and two-sample hypothesis testing. **Statistical hypothesis testing** is a method in which a sample dataset is compared against the population data. **Two-sample hypothesis testing** is a method in determining whether the differences between the two samples are statistically significant or not.

## Why is it important to know?

It’s important to know what A/B testing is and how it works because it’s the best method in quantifying changes in a product or changes in a marketing strategy. And this is becoming increasingly important in a data-driven world where business decisions need to be back by facts and numbers.

## How to conduct a standard A/B test

#### 1. Formulate your hypothesis

Before conducting an A/B testing, you want to state your null hypothesis and alternative hypothesis:

The **null hypothesis** is one that states that sample observations result purely from chance. From an A/B test perspective, the null hypothesis states that there is **no** difference between the control and variant group.
The **alternative hypothesis** is one that states that sample observations are influenced by some non-random cause. From an A/B test perspective, the alternative hypothesis states that there **is** a difference between the control and variant group.

When developing your null and alternative hypotheses, it’s recommended that you follow a PICOT format. Picot stands for:

* **P**opulation: the group of people that participate in the experiment
* **I**ntervention: refers to the new variant in the study
* **C**omparison: refers to what you plan on using as a reference group to compare against your intervention
* **O**utcome: represents what result you plan on measuring
* **T**ime: refers to the duration of the experience (when and how long the data is collected)

Example: “Intervention A will improve anxiety (as measured by the mean change from baseline in the HADS anxiety subscale) in cancer patients with clinical levels of anxiety at 3 months compared to the control intervention.”

Does it follow the PICOT criteria?

* Population: Cancer patients with clinical levels of anxiety
* Intervention: Intervention A
* Comparison: the control intervention
* Outcome: improve anxiety as measured by the mean change from baseline in the HADS anxiety subscale
* Time: at 3 months compared to the control intervention.

Yes it does — therefore, this is an example of a strong hypothesis test.

#### 2. Create your control group and test group

Once you determine your null and alternative hypothesis, the next step is to create your control and test (variant) group. There are two important concepts to consider in this step, random samplings and sample size.

**Random Sampling**
Random sampling is a technique where each sample in a population has an equal chance of being chosen. Random sampling is important in hypothesis testing because it eliminates sampling bias, and **it’s important to eliminate bias because you want the results of your A/B test to be representative of the entire population rather than the sample itself.**

**Sample Size**
It’s essential that you determine the minimum sample size for your A/B test prior to conducting it so that you can eliminate **under coverage bias**, bias from sampling too few observations. There are plenty of [online calculators](https://www.optimizely.com/sample-size-calculator/) that you can use to calculate the sample size given these three inputs, but check out [this link](https://online.stat.psu.edu/stat414/node/306/) if you would like to understand the math behind it!

#### 3. Conduct the test, compare the results, and reject or do not reject the null hypothesis

![](https://cdn-images-1.medium.com/max/2000/0*KIie8p4lPGVXfCgZ.png)

Once you conduct your experiment and collect your data, you want to determine if the difference between your control group and variant group is statistically significant. There are a few steps in determining this:

* First, you want to set your **alpha**, the probability of making a type 1 error. Typically the alpha is set at 5% or 0.05
* Next, you want to determine the probability value (p-value) by first calculating the t-statistic using the formula above.
* Lastly, compare the p-value to the alpha. If the p-value is greater than the alpha, do not reject the null!

**If this doesn’t make sense to you, I would take the time to learn more about hypothesis testing [here](https://www.khanacademy.org/math/statistics-probability/significance-tests-one-sample/idea-of-significance-tests/v/simple-hypothesis-testing)!**

## Thanks for reading!

If you like my work and want to support me, sign up on my email list [here](https://terenceshin.typeform.com/to/fe0gYe)!

## References
[**A/B testing**
**A/B testing (also known as bucket tests or split-run testing) is a randomized experiment with two variants, A and B. It…**en.wikipedia.org](https://en.wikipedia.org/wiki/A/B_testing)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
