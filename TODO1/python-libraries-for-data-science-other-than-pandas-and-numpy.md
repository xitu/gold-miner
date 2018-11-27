> * 原文地址：[Lesser Known Python Libraries for Data Science](https://medium.com/analytics-vidhya/python-libraries-for-data-science-other-than-pandas-and-numpy-95da30568fad)
> * 原文作者：[Parul Pandey](https://medium.com/@parulnith?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/python-libraries-for-data-science-other-than-pandas-and-numpy.md](https://github.com/xitu/gold-miner/blob/master/TODO1/python-libraries-for-data-science-other-than-pandas-and-numpy.md)
> * 译者：
> * 校对者：

# Lesser Known Python Libraries for Data Science

![](https://cdn-images-1.medium.com/max/1000/0*YKyKKzZxKeh2iYZi)

PC: [Hitesh Choudhary](https://unsplash.com/@hiteshchoudhary?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

Python is an amazing language. It’s one of the fastest growing programming languages in the world. It has time and again proved its usefulness both in developer job roles and data science positions across industries. The entire ecosystem of Python and its libraries makes it an apt choice for users (beginners and advanced) all over the world. One of the reasons for its success and popularity is the presence of its set of robust libraries that make it so dynamic and fast.

In this article, we will look at some of the Python libraries for data science tasks other than the commonly used ones like **pandas, scikit-learn, matplotlib etc**. Although the libraries like **pandas and scikit-learn** are the default names which come to mind for machine learning tasks, it’s always good to learn about other python offerings in this field.

* * *

### [Wget](https://pypi.org/project/wget/)

Extracting data especially from the web is one of the vital tasks of a data scientist**. Wget** is a free utility for non-interactive download of files from the Web. It supports HTTP, HTTPS, and FTP protocols, as well as retrieval through HTTP proxies. Since it is non-interactive, it can work in the background even if the user isn’t logged in. So the next time you want to download a website or all the images from a page, **wget** is there to assist you.

#### Installation:

```
$ pip install wget
```

#### Example:

```
import wget
url = 'http://www.futurecrew.com/skaven/song_files/mp3/razorback.mp3'

filename = wget.download(url)
100% [................................................] 3841532 / 3841532

filename
'razorback.mp3'
```

### [Pendulum](https://github.com/sdispater/pendulum)

For the ones, who get frustrated when working with date-times in python, Pendulum is here for you. It is a Python package to ease **datetimes** manipulations. It is a drop-in replacement for the Python’s native class. Refer to the [documentation](https://pendulum.eustace.io/docs/#installation) for in-depth working.

#### Installation:

```
$ pip install pendulum
```

#### Example:

```
import pendulum

dt_toronto = pendulum.datetime(2012, 1, 1, tz='America/Toronto')
dt_vancouver = pendulum.datetime(2012, 1, 1, tz='America/Vancouver')

print(dt_vancouver.diff(dt_toronto).in_hours())

3
```

### [imbalanced-learn](https://github.com/scikit-learn-contrib/imbalanced-learn)

It is seen that most classification algorithms work best when the number of samples in each class is almost the same, i.e. balanced. But real life cases are full of imbalanced datasets which can have a bearing upon the learning phase and the subsequent prediction of machine learning algorithms. Fortunately, this library has been created to address this issue. It is compatible with [**scikit-learn**](http://scikit-learn.org/stable/)  and is part of [**scikit-learn-contrib**](https://github.com/scikit-learn-contrib) projects. Try it out the next time when you encounter imbalanced datasets.

#### Installation:

```
pip install -U imbalanced-learn

# or

conda install -c conda-forge imbalanced-learn
```

#### Example:

For usage and examples refer [documentation](http://imbalanced-learn.org/en/stable/api.html).

### [FlashText](https://github.com/vi3k6i5/flashtext)

Cleaning text data during NLP tasks often requires replacing keywords in sentences or extracting keywords from sentences. Usually, such operations can be accomplished with regular expressions, but it could become cumbersome if the number of terms to be searched ran into thousands. Python’s **FlashText** module, which is based upon the [FlashText algorithm](https://arxiv.org/abs/1711.00046) provides an apt alternative for such situations. The best part of FlashText is that the runtime is the same irrespective of the number of search terms. You can read more about it [here](https://flashtext.readthedocs.io/en/latest/#).

#### Installation:

```
$ pip install flashtext
```

#### Example:

**Extract keywords**

```
from flashtext import KeywordProcessor
keyword_processor = KeywordProcessor()

# keyword_processor.add_keyword(<unclean name>, <standardised name>)

keyword_processor.add_keyword('Big Apple', 'New York')
keyword_processor.add_keyword('Bay Area')
keywords_found = keyword_processor.extract_keywords('I love Big Apple and Bay Area.')

keywords_found
['New York', 'Bay Area']
```

**Replace keywords**

```
keyword_processor.add_keyword('New Delhi', 'NCR region')

new_sentence = keyword_processor.replace_keywords('I love Big Apple and new delhi.')

new_sentence
'I love New York and NCR region.'
```

For more usage examples, refer the official documentation.

### [Fuzzywuzzy](https://github.com/seatgeek/fuzzywuzzy)

The name does sound weird, but fuzzywuzzy is a very helpful library when it comes to string matching. One can easily implement operations like string comparison ratios, token ratios etc. It is also handy for matching records which are kept in different databases.

#### Installation:

```
$ pip install fuzzywuzzy
```

#### Example:

```
from fuzzywuzzy import fuzz
from fuzzywuzzy import process

# Simple Ratio

fuzz.ratio("this is a test", "this is a test!")
97

# Partial Ratio
fuzz.partial_ratio("this is a test", "this is a test!")
 100
```

More interesting examples can be found at their [GitHub repo.](https://github.com/seatgeek/fuzzywuzzy)

### [PyFlux](https://github.com/RJT1990/pyflux)

Time series analysis is one of the most frequently encountered problems in Machine learning domain. **PyFlux** is an open source library in Python explicitly built for working with **time series** problems. The library has an excellent array of modern time series models including but not limited to **ARIMA, GARCH** and **VAR** models. In short, PyFlux offers a probabilistic approach to time series modelling. Worth trying out.

#### Installation

```
pip install pyflux
```

#### Example

Please refer the [documentation](https://pyflux.readthedocs.io/en/latest/index.html) for usage and examples.

### [Ipyvolume](https://github.com/maartenbreddels/ipyvolume)

Communicating results is an essential aspect of Data Science. Being able to visualise results comes at a significant advantage. IPyvolume is a Python library to visualise 3d volumes and glyphs (e.g. 3d scatter plots), in the Jupyter notebook, with minimal configuration and effort. However, it is currently in the pre-1.0 stage. A good analogy would be something like this: IPyvolume’s **_volshow_** is to 3d arrays what matplotlib’s **_imshow_** is to 2d arrays. You can read more about it [here](https://ipyvolume.readthedocs.io/en/latest/?badge=latest).

```
Using pip
$ pip install ipyvolume

Conda/Anaconda
$ conda install -c conda-forge ipyvolume
```

#### Example

*   **Animation**

![](https://cdn-images-1.medium.com/max/800/1*LCYKIjWMJNyx_FFh28Kmpg.gif)

*   **Volume Rendering**

![](https://cdn-images-1.medium.com/max/800/1*38byJyFXAPYAilPAZSBZQw.gif)

### [Dash](https://github.com/plotly/dash)

Dash is a productive Python framework for building web applications. It is written on top of Flask, Plotly.js, and React.js and ties modern UI elements like dropdowns, sliders, and graphs to your analytical Python code without the need for javascript. Dash is highly suitable for building data visualisation apps. These apps can then be rendered in the web browser. The user guide can be accessed [here](https://dash.plot.ly/).

#### Installation

```
pip install dash==0.29.0  # The core dash backend
pip install dash-html-components==0.13.2  # HTML components
pip install dash-core-components==0.36.0  # Supercharged components
pip install dash-table==3.1.3  # Interactive DataTable component (new!)
```

#### Example

The example below shows a highly interactive graph with drop down capabilities. As the user selects a value in the Dropdown, the application code dynamically exports data from Google Finance into a Pandas DataFrame. S[ource](https://gist.github.com/chriddyp/3d2454905d8f01886d651f207e2419f0)

![](https://cdn-images-1.medium.com/max/800/1*214uBS-z0Vub0LipfYFoyw.gif)

### [Gym](https://github.com/openai/gym)

Gym from [**OpenAI**](https://openai.com/) is a toolkit for developing and comparing reinforcement learning algorithms. It is compatible with any numerical computation library, such as TensorFlow or Theano. The gym library is necessarily a collection of test problem also called environments — that you can use to work out your reinforcement learning algorithms. These environments have a shared interface, allowing you to write general algorithms.

#### Installation

```
pip install gym
```

**Example**

An example that will run an instance of the environment `[CartPole-v0](https://gym.openai.com/envs/CartPole-v0)` for 1000 timesteps, rendering the environment at each step.

![](https://cdn-images-1.medium.com/max/800/1*Wns4SwUxtmw-O-EfrJ2_Rw.gif)

You can read about other environments [here](https://gym.openai.com/).

* * *

### Conclusion

These were my picks for useful python libraries for data science, other than the common ones like numpy, pandas etc. In case you know about others which can be added to the list, mention in the comments below. Do not forget to try them out.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
