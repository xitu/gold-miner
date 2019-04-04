> * 原文地址：[Which Deep Learning Framework is Growing Fastest?](https://towardsdatascience.com/which-deep-learning-framework-is-growing-fastest-3f77f14aa318)
> * 原文作者：[Jeff Hale](https://medium.com/@jeffhale)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/which-deep-learning-framework-is-growing-fastest.md](https://github.com/xitu/gold-miner/blob/master/TODO1/which-deep-learning-framework-is-growing-fastest.md)
> * 译者：
> * 校对者：

# Which Deep Learning Framework is Growing Fastest?

> TensorFlow vs. PyTorch

In September 2018, I compared all the major deep learning frameworks in terms of demand, usage, and popularity in [this article](https://towardsdatascience.com/deep-learning-framework-power-scores-2018-23607ddf297a). TensorFlow was the undisputed heavyweight champion of deep learning frameworks. PyTorch was the young rookie with lots of buzz. 🐝

How has the landscape changed for the leading deep learning frameworks in the past six months?

![](https://cdn-images-1.medium.com/max/2000/1*SVgj_p1tcangWfCm2n0txg.png)

![](https://cdn-images-1.medium.com/max/2000/1*3JpBBGkLNgwRfkrDDFIQiQ.png)

To answer that question, I looked at the number of job listings on [Indeed](http://indeed.com), [Monster](https://www.monster.com/), [LinkedIn](https://linkedin.com), and [SimplyHired](https://www.simplyhired.com/). I also evaluated changes in [Google search volume](https://trends.google.com/trends/explore?cat=1299&q=tensorflow,pytorch,keras,fastai), [GitHub activity](https://github.com/), [Medium articles](https://medium.com), [ArXiv articles](https://arxiv.org/), and [Quora topic followers](https://www.quora.com). Overall, these sources paint a comprehensive picture of growth in demand, usage, and interest.

## Integrations and Updates

We’ve recently seen several important developments in the TensorFlow and PyTorch frameworks.

PyTorch v1.0 was pre-released in October 2018, at the same time fastai v1.0 was released. Both releases marked major milestones in the maturity of the frameworks.

TensorFlow 2.0 alpha was released March 4, 2019. It added new features and an improved user experience. It more tightly integrates Keras as its high-level API, too.

## Methodology

In this article, I include Keras and fastai in the comparisons because of their tight integrations with TensorFlow and PyTorch. They also provide scale for evaluating TensorFlow and PyTorch.

![](https://cdn-images-1.medium.com/max/2000/1*rRq_RWw3SLz64sMRXmtyaQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*UlKBqvcT5UNg3L5BM8ywqg.png)

I won’t be exploring other deep learning frameworks in this article. I expect I will receive feedback that Caffe, Theano, MXNET, CNTK, DeepLearning4J, or Chainer deserve to be discussed. While these frameworks each have their virtues, none appear to be on a growth trajectory likely to put them near TensorFlow or PyTorch. Nor are they tightly coupled with either of those frameworks.

Searches were performed on March 20–21, 2019. Source data is in [this Google Sheet](https://docs.google.com/spreadsheets/d/1Q9rQkfi8ubKM8aX33In0Ki6ldUCfJhGqiH9ir6boexw/edit?usp=sharing).

I used the [plotly](https://plot.ly/) data visualization library to explore popularity. For the interactive plotly charts, see my Kaggle Kernel [here](https://www.kaggle.com/discdiver/2019-deep-learning-framework-growth-scores).

Let’s look at the results in each category.

## Change in Online Job Listings

To determine which deep learning libraries are in demand in today’s job market I searched job listings on Indeed, LinkedIn, Monster, and SimplyHired.

I searched with the term **machine learning,** followed by the library name. So TensorFlow was evaluated with **machine learning TensorFlow.** This method was used for historical comparison reasons. Searching without **machine learning** didn’t yield appreciably different results. The search region was the USA.

I subtracted the number of listings six months ago from the number of listings in March 2019. Here’s what I found:

![](https://cdn-images-1.medium.com/max/2000/1*-8jrJV4tnqGXWzwlCdlYvQ.png)

TensorFlow had a slightly larger increase in listings than PyTorch. Keras also saw listings growth — about half as much as TensorFlow. Fastai still isn’t showing in hardly any job listings.

Note that PyTorch saw a larger number of additional listings than TensorFlow on all job search sites other than LinkedIn. Also note that in absolute terms, TensorFlow appears in nearly three times the number of job listings as PyTorch or Keras.

## Change in Average Google Search Activity

Web searches on the largest search engine are a gauge of popularity. I looked at search history in Google Trends over the past year. I searched for worldwide interest in the **Machine Learning and Artificial Intelligence** category**.** undefinedGoogle doesn’t provide absolute search numbers, but it does provide relative figures.

I took the average interest score of the past six months and the compared it to the average interest score for the prior six months.

![](https://cdn-images-1.medium.com/max/2000/1*-0xgPs1DzZKE3jWy9412Ew.png)

In the past six months, the relative search volume for TensorFlow has decreased, while the relative search volume for PyTorch has grown.

The chart from Google directly below shows search interest over the past year.

![TensorFlow in blue; Keras in yellow, PyTorch in red, fastai in green](https://cdn-images-1.medium.com/max/2000/1*FGdwNXVzEno6N3CYBW6OLA.png)

## New Medium Articles

Medium is a popular location for data science articles and tutorials. I hope you’re enjoying it! 😃

I used Google site search of Medium.com over the past six months and found TensorFlow and Keras had similar numbers of articles published. PyTorch had relatively few.

![](https://cdn-images-1.medium.com/max/2000/1*8cuSvK4Wc5jjJDH8sPCOPw.png)

As high level APIs, Keras and fastai are popular with new deep learning practitioners. Medium has many tutorials showing how to use these frameworks.

## New arXiv Articles

[arXiv](https://arxiv.org/) is the online repository where most scholarly deep learning articles are published. I searched for new articles mentioning each framework on arXiv using Google site search results for the past six months.

![](https://cdn-images-1.medium.com/max/2000/1*HTe-PCY7rvpSAKwsEzF3lg.png)

TensorFlow had the most new article appearances by a good margin.

## New GitHub Activity

Recent activity on GitHub is another indicator of framework popularity. I broke out stars, forks, watchers, and contributors in the charts below.

![](https://cdn-images-1.medium.com/max/2000/1*83KNb93eWuSEt5MxqDow6Q.png)

TensorFlow had the most GitHub activity in each category. However, PyTorch was quite close in terms of growth in watchers and contributors. Also, Fastai saw many new contributors.

Some contributors to Keras are no doubt working on it in the TensorFlow library. It’s worth noting that both TensorFlow and Keras are open source products spearheaded by Googlers.

## New Quora Followers

I added the number of new Quora topic followers to the mix — a new category that I didn’t have the data for previously.

![](https://cdn-images-1.medium.com/max/2000/1*TqZ_cZQkadyrPEhR3tI8qQ.png)

TensorFlow added the most new topic followers over the past six months. PyTorch and Keras each added far fewer.

Once I had all the data, I consolidated it into one metric.

## Growth Score Procedure

Here’s how I created the growth score:

 1. Scaled all features between 0 and 1.

 2. Aggregated the **Online Job Listings** and **GitHub Activity** subcategories.

 3. Weighted categories according to the percentages below.

![](https://cdn-images-1.medium.com/max/2000/1*T5qnFdpwsNsrDGhl_j7ujg.png)

4. Multiplied weighted scores by 100 for comprehensibility.

5. Summed category scores for each framework into a single growth score.

Job listings make up a little over a third of the total score. As the cliche goes, money talks. 💵 This split seemed like an appropriate balance of the various categories. Unlike my [2018 power score analysis](https://towardsdatascience.com/deep-learning-framework-power-scores-2018-23607ddf297a), I didn’t include KDNuggets usage survey (no new data) or books (not many published in six months).

## Results

Here are the changes in tabular form.

![Google Sheet [here](https://docs.google.com/spreadsheets/d/1Q9rQkfi8ubKM8aX33In0Ki6ldUCfJhGqiH9ir6boexw/edit?usp=sharing).](https://cdn-images-1.medium.com/max/2832/1*iiPAyzPl7f_xfh3SnJklKg.png)

Here are the category and final scores.

![](https://cdn-images-1.medium.com/max/3064/1*lXuEdokw-VuxZjxNKft5NA.png)

Here are the final growth scores.

![](https://cdn-images-1.medium.com/max/2000/1*c67KMUJj3waIlxnUJ1enTw.png)

TensorFlow is both the most in demand framework and the fastest growing. It’s not going anywhere anytime soon. 😄PyTorch is growing rapidly, too. Its large increase in job listings is evidence of its increased usage and demand. Keras has grown a good bit in the past six months, also. Finally, fastai has grown from a low baseline. It’s worth remembering that it’s the youngest of the lot.

Both TensorFlow and PyTorch are good frameworks to learn.

## Learning Suggestions

If you’re looking to learn TensorFlow, I suggest you start with Keras. I recommend Chollet’s [**Deep Learning with Python**](https://www.amazon.com/Deep-Learning-Python-Francois-Chollet/dp/1617294438) and Dan Becker’s [DataCamp course on Keras](https://www.datacamp.com/courses/deep-learning-in-python). Tensorflow 2.0 is using Keras as its high-level API through tf.keras. Here’s a quick getting started intro to TensorFlow 2.0 by [Chollet](https://threader.app/thread/1105139360226140160).

If you’re looking to learn PyTorch, I suggest you start with fast.ai’s MOOC [Practical Deep Learning for Coders, v3](https://course.fast.ai/). You’ll learn deep learning fundamentals, fastai, and PyTorch basics.

What’s ahead for TensorFlow and PyTorch?

## Future Directions

I’ve consistently heard that folks enjoy using PyTorch more than TensorFlow. PyTorch is more pythonic and has a more consistent API. It also has native [ONNX](https://onnx.ai/supported-tools) model exports, which can be used to speed up inference. Also, PyTorch shares many commands with [numpy](https://github.com/wkentaro/pytorch-for-numpy-users), which reduces the barrier to learning it.

However, TensorFlow 2.0 is all about improved UX, as Google’s Chief Decision Intelligence Engineer, [Cassie Kozyrkov](undefined), explains [here](https://hackernoon.com/tensorflow-is-dead-long-live-tensorflow-49d3e975cf04?sk=37e6842c552284444f12c71b871d3640). TensorFlow will now have a more straightforward API, a streamlined Keras integration, and an eager execution option. These changes, and TensorFlow’s broad adoption, should help the framework remain popular for years to come.

TensorFlow recently announced another exciting plan: the development of [Swift for TensorFlow](https://www.tensorflow.org/swift). [Swift](https://swift.org/) is a programming language originally built by Apple. Swift has a number of advantages over Python in terms of execution and development speed. Fast.ai will be using [Swift for TensorFlow](https://www.tensorflow.org/swift) in part of its advanced MOOC — see fast.ai cofounder Jeremy Howard’s post on the topic [here](https://www.fast.ai/2019/03/06/fastai-swift/). The language probably won’t be ready for prime time for a year or two, but it could be an improvement over current deep learning frameworks.

Collaboration and cross-pollination among languages and frameworks is definitely happening. 🐝 🌷

Another advancement that will affect deep learning frameworks is [quantum computing](https://en.wikipedia.org/wiki/Quantum_computing). A usable quantum computer is likely a few years off, but [Google](https://ai.google/research/teams/applied-science/quantum-ai/), [IBM](https://www.ibm.com/blogs/research/2019/03/machine-learning-quantum-advantage/), Microsoft, and others are thinking about how to integrate quantum computing with deep learning. Frameworks will need to be adapted to work with this new technology.

## Wrap

You’ve seen that both TensorFlow and PyTorch are growing. Both now have nice high-level APIs — tf.keras and fastai — that have lowered the barriers to getting started with deep learning. You’ve also heard a bit about recent developments and future directions.

To play with the charts in this article interactively or fork the Jupyter Notebook, please head to my [Kaggle Kernel](https://www.kaggle.com/discdiver/2019-deep-learning-framework-growth-scores).

I hope you’ve found this comparison helpful. If you have, please share it on your favorite social media channel so others can find it, too. 😄

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
