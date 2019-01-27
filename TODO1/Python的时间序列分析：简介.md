> * 原文地址：[Time Series Analysis in Python: An Introduction](https://towardsdatascience.com/time-series-analysis-in-python-an-introduction-70d5a5b1d52a)
> * 原文作者：[Will Koehrsen](https://towardsdatascience.com/@williamkoehrsen)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-analysis-in-python-an-introduction.md](https://github.com/xitu/gold-miner/blob/master/TODO1/time-series-analysis-in-python-an-introduction.md)
> * 译者：[ppp-man](https://github.com/ppp-man)
> * 校对者：

# Python的时间序列分析：简介
![](https://cdn-images-1.medium.com/max/800/1*5nQ2sdmFTo9hfpDkcqAYnw.jpeg)

**时间序列建模的加和模型**

时间序列是日常生活中其中一种最常见的数据类型。金融市场的价格、天气、家庭耗能、甚至体重都是可以定期收集数据的例子。几乎每个数据科学家都会在日常工作中碰到时间序列，而学习如何为时间序列建模是数据科学中重要的技能。用以分析和预测[周期数据](https://en.wikipedia.org/wiki/Additive_model)的加和模型便是一种简单但强大的模型。背后直观的概念是：把时间序列分成不同时间间隔和整体趋势的组合，间隔可以是每天、每周、每季度、每年。你的家也许在夏天比懂冬天耗能，但整体上因为更有效率的能源使用呈递减趋势。加和模型能够展现出规律/趋势并根据这些观察作出预测。

以下的图展示一个时间序列分解成整体趋势、年趋势还有周趋势。
![](https://cdn-images-1.medium.com/max/800/1*p5l_eKG4we5d8GDzC6o_gg.png)

加和模型分解的例子

这篇文章会细讲一个利用Python和Facebook研发的[Prophet预测拓展包](https://research.fb.com/prophet-forecasting-at-scale/)来为金融的时间序列数据建模的入门例子。我们同时会讲到如何用pandas处理数据，用[Quandl库访问金融数据](https://www.quandl.com/tools/python)，还有[用matplotlib画图](https://matplotlib.org/)。我加入了引导性的代码而且我鼓励大家看看在GitHub上看[Jupyter Notebook](https://github.com/WillKoehrsen/Data-Analysis/tree/master/additive_models)完整的分析。这个入门介绍会为你展示所有你为时间序列建模时必须的步骤。

免责声明：不得不说来打击你的是金融数据的[过往表现并不是未来表现的指标](https://seekingalpha.com/article/2453345-past-performance-is-not-an-indicator-of-future-results)而且这个方法是不会让你发财的。我选用股票是因为这些的日数据比较容易得到，运用起来也得心应手。

#### 提取金融数据

一般来说一个数据科学项目中将近80%的时间是获取和整理数据。多亏了quandl金融数据库，这个项目所需的获取和整理的时间减少至5%左右。Quandl可以用命令行的pip安装，让你只用一行Python代码访问成千上万的金融指标，没注册的状况下能发出不超于50个请求。注册免费账户后你可以取得一个API密钥并发出无限的请求。
First, we import the required libraries and get some data. Quandl automatically puts our data into a pandas dataframe, the data structure of choice for data science. (For other companies, just replace the ‘TSLA’ or ‘GM’ with the stock ticker. You can also specify a date range).
首先我们导入必要的库并获取一些数据。Quandl自动把我们的数据整合到pandas的数据框，也就是数据科学的一种数据结构（把“TSLA”或“GM”换成别的股票代号便可以取得其他公司的数据，你还可以指定某个时间区间）。
```
# 用quandl取金融数据
import quandl

# 用pandad作数据处理
import pandas as pd

quandl.ApiConfig.api_key = 'getyourownkey!'

# 从Quandl提取TSLA数据
tesla = quandl.get('WIKI/TSLA')

# 从Quandl提取GM数据
gm = quandl.get('WIKI/GM')
gm.head(5)
```

![](https://cdn-images-1.medium.com/max/800/1*ixT_RnaZVNXh-ZKxKb2fmg.png)

从quandl的到的GM数据截图

quandl上的数据量几乎是无限的，但我想着重看两个在同一个产业的公司，特斯拉和通用汽车。特斯拉的魅力不仅在于它是[美国111年以来首家成功的汽车创业公司](http://www.businessinsider.com/tesla-the-origin-story-2014-10)，它还不时成为[2017年美国最具价值的汽车公司](https://www.recode.net/2017/8/2/16085822/tesla-ford-gm-worth-car-manufacturer-elon-musk-earnings)。
![](https://cdn-images-1.medium.com/max/800/1*fqcIBhw_xHHgdGe1s74ciA.jpeg)，尽管它只卖四款车型。同样争夺最具价值汽车公司头衔的对手通用汽车近年来有支持未来汽车的迹象，它也制造了一些新颖（但不好看）的全电动汽车。

答案显而易见

我们可以花费大量时间寻找这些数据并下载成csv文档，不过幸好有quandl，我们几秒就可以得到我们所需要的。

### 数据挖掘

我们建模之前最好画几幅图以得到一些其结构的概念。这也让我们检查是否有异常值和遗漏数据的状况。

matplotlib可以轻易地画出Pandas的数据框。如果这些作图代码吓到你了，不必担心，我同样是觉得matplotlib的代码不直观所以常常复制粘贴Stack Overflow的例子或者是别的说明文档。编程的一个规则是不要重新编写一个已经有的答案。
```
# 股票分割调整收市价，这是我们应该画的数据
plt.plot(gm.index, gm['Adj. Close'])
plt.title('GM Stock Price')
plt.ylabel('Price ($)');
plt.show()

plt.plot(tesla.index, tesla['Adj. Close'], 'r')
plt.title('Tesla Stock Price')
plt.ylabel('Price ($)');
plt.show();
```

![](https://cdn-images-1.medium.com/max/800/1*0O-F4teSoUK_hs95LdNw4w.png)

原始股票价格
单单对比两家公司的股票价格不会说明谁更有价值，因为一家公司的价值（市值）同样取决于股票的数量（市值=股票价格 * 股票的数量）。Quandl没有股票数量的数据，但我能找到从谷歌简单搜到两家公司的年平均股票数量。虽然不精准，但足以应付我们的分析，有时就要将就一下！

我们用一些pandas的小技巧在数据框里创建两列数据，像是把索引一个列（reset_index)同时用 [ix](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.ix.html) 索引数据框里间隔的数据。
```
# 特斯拉和通用汽车年平均股票数量
tesla_shares = {2018: 168e6, 2017: 162e6, 2016: 144e6, 2015: 128e6, 2014: 125e6, 2013: 119e6, 2012: 107e6, 2011: 100e6, 2010: 51e6}

gm_shares = {2018: 1.42e9, 2017: 1.50e9, 2016: 1.54e9, 2015: 1.59e9, 2014: 1.61e9, 2013: 1.39e9, 2012: 1.57e9, 2011: 1.54e9, 2010:1.50e9}

# 创建一个年的列
tesla['Year'] = tesla.index.year

# 把索引的日期转移到日期列
tesla.reset_index(level=0, inplace = True)
tesla['cap'] = 0

# 计算所有年份的市值
for i, year in enumerate(tesla['Year']):
    # 提取那一年的股票数量
    shares = tesla_shares.get(year)
    
    # 市值列等于数量乘以价格
    tesla.ix[i, 'cap'] = shares * tesla.ix[i, 'Adj. Close']
```

特斯拉的市值列就这样生成。我们用同样的方式生成 GM 的数据并合并两组数据。[合并](https://pandas.pydata.org/pandas-docs/stable/generated/pandas.DataFrame.merge.html)是数据科学里面一种必要的元素，因为它让我们把共用一个列的数据连接起来。这个例子中我们想把两个不同的公司的数据根据日期并在一起，用“inner”合并保留有在两个公司数据框都有出现的日期。接着我们重新命名合并好的列便能知道哪组数据是哪个汽车公司的。
```
# 合并两组数据并重命名列
cars = gm.merge(tesla, how='inner', on='Date')

cars.rename(columns={'cap_x': 'gm_cap', 'cap_y': 'tesla_cap'}, inplace=True)

# 只选择相关的列
cars = cars.ix[:, ['Date', 'gm_cap', 'tesla_cap']]

# 做除法得到10亿美元为单位的市值
cars['gm_cap'] = cars['gm_cap'] / 1e9
cars['tesla_cap'] = cars['tesla_cap'] / 1e9

cars.head()
```

![](https://cdn-images-1.medium.com/max/800/1*kynRnPfMkB8i4VKWdVmWnQ.png)

合并后的市值数据框
市值以十亿美元为单位。我们看到通用汽车的市值在初期是特斯拉的 30 倍！随时间推移发生了变化吗？
```
plt.figure(figsize=(10, 8))
plt.plot(cars['Date'], cars['gm_cap'], 'b-', label = 'GM')
plt.plot(cars['Date'], cars['tesla_cap'], 'r-', label = 'TESLA')
plt.xlabel('Date'); plt.ylabel('Market Cap (Billions $)'); plt.title('Market Cap of GM and Tesla')
plt.legend();
```

![](https://cdn-images-1.medium.com/max/800/1*JA-_jUVv1B6b2TgRWnFEIg.png)

市值历史数据
我们看到在数据相关的时期中特斯拉迅速的增长和通用汽车的微弱增长。特斯拉身子在2017年超越了通用汽车！
```
import numpy as np

# 找到特斯拉市值高于通用的第一次和最后一次
first_date = cars.ix[np.min(list(np.where(cars['tesla_cap'] > cars['gm_cap'])[0])), 'Date']
last_date = cars.ix[np.max(list(np.where(cars['tesla_cap'] > cars['gm_cap'])[0])), 'Date']

print("Tesla was valued higher than GM from {} to {}.".format(first_date.date(), last_date.date()))

Tesla was valued higher than GM from 2017-04-10 to 2017-09-21.
```

在那段时期，特斯拉卖了大约[48,000 辆车](https://en.wikipedia.org/wiki/Tesla,_Inc.#Production_and_sales)而[通用卖了1,500,000](http://gmauthority.com/blog/gm/general-motors-sales-numbers/)。在数量比特斯拉多卖30倍的情况下通用竟然比特斯拉低！这绝对展现出有说服力的总裁和超高质量（如此低数量）的产品的威力。虽然现在特斯拉的市值比通用低，但我们可以预期特斯拉的再次超越吗？什么时候会发生？解答这个问题我们求助于用于预测未来的加和模型。
### 预言家的建模
[Facebook预言家拓展包](https://facebook.github.io/prophet/docs/quick_start.html)2017年首发用于Python和R，全世界的数据科学家都为之鼓舞。预言家的设计初衷是用作分析时间序列的日观察值，而这些观察值在不同时间区间会呈现不同的规律。它还具备分析节日在时间序列中的影响和应用自定节点的强大功能，我们暂且只看能让模型正常运作的基本功能。预言家就像quandl一样，可以用命令行的pip进行安装。
我们首先导入预言家并把数据中的列更名为正确的格式。日期列必须更名为“ds”还有想预测的数值列叫“y”。我们接着创建预言家模型处理数据，跟Scikit-Learn非常相像：
```
import fbprophet

# 预言家要求列 ds 和 y
gm = gm.rename(columns={'Date': 'ds', 'cap': 'y'})

# 化单位为10亿美元
gm['y'] = gm['y'] / 1e9

# 创建预言家模型用于数据
gm_prophet = fbprophet.Prophet(changepoint_prior_scale=0.15)
gm_prophet.fit(gm)
```

创建预言家模型时我把 changepoint prior 设定在0.15，高于默认的0.05。这个超参数用于控制[趋势变化的敏感度](https://facebook.github.io/prophet/docs/trend_changepoints.html)，值越高表示越敏感，越低越不敏感。此值的价值在于对抗机器学习最本质的权衡问题：[偏见vs.偏差](https://en.wikipedia.org/wiki/Bias%E2%80%93variance_tradeoff)。
如果我们的模型太贴近训练数据，也就是所谓的[过于拟合](https://elitedatascience.com/overfitting-in-machine-learning)，我们的偏差会过大，模型也难以泛化到其他新的数据。另一方面如果模型不能抓取训练数据的趋势，太多的偏见使得它不合适。当一个模型拟合程度低，加大 changepoint prior 值的让模型更贴近数据；相反如果模型过于拟合，减少prior限制模型的敏感度。changepoint prior的影响可以通过描绘一系列值的预测图展现出来：
![](https://cdn-images-1.medium.com/max/800/1*jEFOLncknBJ8cPQSBQDktA.png)

changepoint prior 的程度越高，模型越灵活，越能拟合训练数据。这似乎恰恰是我们想要的，但太贴近训练数据会导致过于拟合，减弱模型利用新数据做预测的能力。因此我们需要找到一个既符合训练数据又能泛化到其他数据的平衡点。利用我们的模型去抓取每天变动的股票价格，在尝试一些数据后我增加了模型的灵活度。
决定用预言家模型后，我们可以在时间序列从增加到减少或者是慢速增加到快速增加的时候指定changepoints（位置处在[时间序列变化最快的地方](https://facebook.github.io/prophet/docs/trend_changepoints.html)）。Changepoints可以对应像是新产品发布或是宏观经济动荡这些重大事件。在没有指定的情况下，预言家会帮我们计算出来。
做预测需要用到未来数据框。我们指定要预测的时间区间的数量（两年）和做预测的频率（每天），然后用预言家模型和未来数据框做预测。
```
# 生成一个2年的数据框
gm_forecast = gm_prophet.make_future_dataframe(periods=365 * 2, freq='D')

# 做预测
gm_forecast = gm_prophet.predict(gm_forecast)
```

我们的未来数据框包含了估算的特斯拉和通用汽车未来两年的市值，用预言家的画图功能将其图像化。
```
gm_prophet.plot(gm_forecast, xlabel = 'Date', ylabel = 'Market Cap (billions $)')
plt.title('Market Cap of GM');
```

![](https://cdn-images-1.medium.com/max/800/1*OSW5XSzx-EmefhkXjhICuw.png)

黑点代表实际数据（注意他们只到2018年初），蓝色线表示预测值，浅蓝色的区域是不确定性（通常是[预测中至关重要的部分](https://medium.com/@williamkoehrsen/a-theory-of-prediction-10cb335cc3f2)）。不确定区域随着预测时间推移会逐渐扩大，因为起始的不确定性会随着时间增加，如同[天气预报会因预告的时间越长准确率降低](http://www.nytimes.com/2012/09/09/magazine/the-weatherman-is-not-a-moron.html)。
我们也可以检查模型检测出的changepoints。重申一点，changepoints代表的是当时间序列的增速有明显变化的时候（例如从增到减）。
```
tesla_prophet.changepoints[:10]

61    2010-09-24
122   2010-12-21
182   2011-03-18
243   2011-06-15
304   2011-09-12
365   2011-12-07
425   2012-03-06
486   2012-06-01
547   2012-08-28
608   2012-11-27
```

我们可以对比一下这个时间段从[谷歌搜索到的特斯拉趋势](https://trends.google.com/trends/explore?date=2010-09-01%202013-01-01&q=Tesla%20Motors)看看结果是否一致。changepoints（垂直线）和搜索结果放在同一个图中：
```
# 加载数据
tesla_search = pd.read_csv('data/tesla_search_terms.csv')

# 把月份转换为datetime
tesla_search['Month'] = pd.to_datetime(tesla_search['Month'])
tesla_changepoints = [str(date) for date in tesla_prophet.changepoints]
# 画出搜索频率
plt.plot(tesla_search['Month'], tesla_search['Search'], label = 'Searches')

# 画changepoints
plt.vlines(tesla_changepoints, ymin = 0, ymax= 100, colors = 'r', linewidth=0.6, linestyles = 'dashed', label = 'Changepoints')

# 整理绘图
plt.grid('off'); plt.ylabel('Relative Search Freq'); plt.legend()
plt.title('Tesla Search Terms and Changepoints');
```

![](https://cdn-images-1.medium.com/max/800/1*rSuNyepHa9lvQeDClGL5XA.png)

特斯拉搜索频率和股票changepoints
特斯拉市值的一些changepoints跟特斯拉搜索频率的变化一致，但不是全部。我认为谷歌搜索频率不能称为股票变动的好指标。
我们依然需要知道特斯拉的市值什么时候会超越通用汽车。既然有了接下来两年的预测，我们可以合并两个数据框后在同一幅图中画出两个公司的市值。合并之前，列需要更名方便追踪。
```
gm_names = ['gm_%s' % column for column in gm_forecast.columns]
tesla_names = ['tesla_%s' % column for column in tesla_forecast.columns]

# 合并的数据框
merge_gm_forecast = gm_forecast.copy()
merge_tesla_forecast = tesla_forecast.copy()

# 更名列
merge_gm_forecast.columns = gm_names
merge_tesla_forecast.columns = tesla_names

# 合并两组数据
forecast = pd.merge(merge_gm_forecast, merge_tesla_forecast, how = 'inner', left_on = 'gm_ds', right_on = 'tesla_ds')

# 日期列更名
forecast = forecast.rename(columns={'gm_ds': 'Date'}).drop('tesla_ds', axis=1)
```

首先我们会只画估算值。估算值（预言家包的“yhat”）除去一些数据中的噪音因而看着跟原始数据图不太一样。除杂的程度取决于changepoint prior的程度 - 高的 prior 值表示更多的模型灵活度和更多的高低起伏。
![](https://cdn-images-1.medium.com/max/800/1*wtXXjTJK2J9MQFFkyGyhwA.png)

通用和特斯拉的预测市值
我们的模型认为特斯拉2017年超越通用汽车是噪音，而且知道2018年特斯拉才真正的在预测中打败通用。确切日期是2018年的1月27日，如果那真的发生了，我很乐意接受能预测未来的嘉许！
当生成以上的图像，我们遗漏了预测中最重要的一点：不确定性！我们可以用matplotlib（参考[notebook](https://github.com/WillKoehrsen/Data-Analysis/blob/master/additive_models/Additive%20Models%20for%20Prediction.ipynb))查看有不确定的区域：
![](https://cdn-images-1.medium.com/max/800/1*0rt_W8NzoFG_WQ0I9mncyg.png)

这更好代表预测的结果。图中显示两个公司预期会增长，特斯拉的增长速度会比通用更快。再强调一下，不确定性会随着时间的推移而增加，而2020年特斯拉的下限比通用的上限高意味着通用可能会一直保持领先地位。
#### 趋势和规律
市值分析的最后一步是看整体趋势和规律。预言家让我们轻易地达到这个目的。
```
# 描绘趋势和规律
gm_prophet.plot_components(gm_forecast)
```

![](https://cdn-images-1.medium.com/max/800/1*TUWWhcVj8tHLEptgegyYRQ.png)

通用汽车时间序列的分解
其趋势很明显：通用的股票价格正在并持续上涨。但年间有趣的现象是股价自年末上涨后夏天前都在缓慢地跌。我们可以检验一下年度市值和平均月销量是否有相关性。我先从谷歌收集每月的销售销售量然后用groupby平均这些月份，这是由其重要的步骤因为我们常常想比较两个范畴的数据，例如一个年龄层的用户或者是一个厂商的不同汽车。我们的例子中要计算每月的平均销售便要把月份加总后平均销售。
```
gm_sales_grouped = gm_sales.groupby('Month').mean()
```

![](https://cdn-images-1.medium.com/max/800/1*8SXNjfI4XBaINxGVQIUndg.png)

月销售似乎跟市值没什么关系。八月月销售最高但市值却是最低！
从周趋势看并不能发现有用的信号（周末没有股价信息因此我们只能看工作日），这是可以预计的因为[经济中的随机漫步](https://www.investopedia.com/terms/r/randomwalktheory.asp)说到单看每日的股价并不能告诉我们什么规律。我们的分析也证明股票长期来看是增长的，但如果每天看，即使是用最好的模型我们也几乎利用不了任何规律。
简单看看[道琼斯工业平均指数](https://en.wikipedia.org/wiki/Dow_Jones_Industrial_Average)（一支包含30家最大的公司股票的指数）很好地说明这点：
![](https://cdn-images-1.medium.com/max/800/1*5OHpAvp_w5g7jccqJ8OYaA.png)

道琼斯工业平均指数（[来源](http://www.cityam.com/257792/dow-jones-industrial-average-breaks-20000-first-time))
很明显这要告诉你的信息是回到1900年投资！或者是现实生活中股市跌的时候不要抽身因为历史告诉我们它会涨回来。整体来说，每日的变动太小看不到，如果要每天都看股票那么笨的话还不如投资整个市场然后长期拿着。
预言家也可以用在大规模的数据测量，像是国内生产总值（GDP），一个测量国家经济规模的指标。我基于美国和中国历史GDP数据用预言家模型做了以下预测。
![](https://cdn-images-1.medium.com/max/800/1*1I9G9ek3oXmuS2Fa9KVf9g.png)

中国回超越美国GDP的确切日子是2036！这个模型的不足在于观察值太少（GDP是每季测量但预言家的强项在于用每日数据），但能在宏观经济知识匮乏的情况下有个基本的预测。
为时间序列建模的方法很多，从[简单的线性回归](https://onlinecourses.science.psu.edu/stat501/node/250)到[用LSTM建的循环神经网络](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)。加和模型有用的地方在于它容易生成和训练并通过可读的规律产出带不确定性的预测。预言家功能强大而我们只是看到它表面。我鼓励大家利用这篇文章和你们的笔记本去探索[Quandl提供的一些数据](https://www.quandl.com/search?query=)，或是你自己的时间序列。留意我在日常生活中的应用和用这些技能去[分析预测体重变化的文章](https://towardsdatascience.com/data-science-a-practical-application-7056ec22d004)。加和模型是开始探索时间序列的不二之选！
我的邮箱是 wjk68@case.edu，欢迎指正和建设性批评。
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
