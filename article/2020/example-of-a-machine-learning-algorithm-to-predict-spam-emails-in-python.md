> * 原文地址：[Email Spam Detector in Python](https://medium.com/python-in-plain-english/example-of-a-machine-learning-algorithm-to-predict-spam-emails-in-python-76addb1514d1)
> * 原文作者：[George Pipis](https://medium.com/@jorgepit-14189)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/example-of-a-machine-learning-algorithm-to-predict-spam-emails-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/example-of-a-machine-learning-algorithm-to-predict-spam-emails-in-python.md)
> * 译者：[JohnieXu](https://github.com/JohnieXu)
> * 校对者：[luochen1992](https://github.com/luochen1992)，[zenblo](https://github.com/zenblo)

# Python 开发垃圾邮件检测应用

![图片来自 Unsplash](https://cdn-images-1.medium.com/max/2000/0*cNPIeopNeCpoyXUk.jpg)

## 垃圾邮件（Spam）与有效邮件（Ham）

对于检测是否为垃圾邮件的模型，最常见的应用是创建一个预测文本的模型。原始数据集来自于这个 —— [Spam](https://github.com/lsvih/spam_email/blob/main/spam.csv.zip)，里面数据包含以后标题行，拥有两列，第一列为 text 表示邮件内容，第二列为 target 值为 spam 或 ham 分别表示垃圾邮件与非垃圾邮件。

```py
import pandas as pd
import numpy as np
from sklearn.metrics import roc_auc_score
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression

spam_data = pd.read_csv('spam.csv')

spam_data['target'] = np.where(spam_data['target']=='spam',1,0)
spam_data.head(10)
```

输出结果：

![](https://cdn-images-1.medium.com/max/2000/1*40wu5WtjaDcWKRJtTMX3_g.png)

## 将数据拆分为训练集和测试集

```py
X_train, X_test, y_train, y_test = train_test_split(spam_data['text'], 
                 spam_data['target'], 
                 random_state=0)
```

## 在 N-gram 上构建 tf-idf

使用 sklearn 库中的 `TfidfVectorizer` 来转换并训练数据 `X_train`，忽略掉数据字典中出现频次小于 **5** 的数据，同时让 **n-grams 从 1 到 3 取值**（单个字、双元组和三元组）。

```py
vect = TfidfVectorizer(min_df=5, ngram_range=(1,3)).fit(X_train) X_train_vectorized = vect.transform(X_train)
```

## 添加特殊字符

除了基本字符之外，需要添加诸如：**数字**、**美元符号**、**长度**等这些除字母、数字及下划线以外字符。下面编写一个函数来实现这个：

```py
def add_feature(X, feature_to_add):
    """
    Returns sparse feature matrix with added feature.
    feature_to_add can also be a list of features.
    """
    from scipy.sparse import csr_matrix, hstack
    return hstack([X, csr_matrix(feature_to_add).T], 'csr')

# 训练数据
add_length=X_train.str.len()
add_digits=X_train.str.count(r'\d')
add_dollars=X_train.str.count(r'\$')
add_characters=X_train.str.count(r'\W')

X_train_transformed = add_feature(X_train_vectorized , [add_length, add_digits,  add_dollars, add_characters])

# 测试数据
add_length_t=X_test.str.len()
add_digits_t=X_test.str.count(r'\d')
add_dollars_t=X_test.str.count(r'\$')
add_characters_t=X_test.str.count(r'\W')

X_test_transformed = add_feature(vect.transform(X_test), [add_length_t, add_digits_t,  add_dollars_t, add_characters_t])
```

## 训练逻辑回归模型

下面将建立逻辑回归模型，并统计测试集的 `AUC` 得分（译者注：[AUC 指的是 ROC 曲线下与坐标轴围成的面积，取值一般在 0.5和 1 之间，越接近 1 表示数据越真实有效](https://baike.baidu.com/item/AUC/19282953)）。

```py
clf = LogisticRegression(C=100, solver='lbfgs', max_iter=1000)

clf.fit(X_train_transformed, y_train)

y_predicted = clf.predict(X_test_transformed)

auc = roc_auc_score(y_test, y_predicted)
auc
```

输出结果：

```
0.9674528462047772
```

## 取得对结果影响最大的特征词

下面将取得对是否垃圾邮件的预测结果影响排名靠前的 **50** 个特征词。

```py
feature_names = np.array(vect.get_feature_names() + ['lengthc', 'digit', 'dollars', 'n_char'])
sorted_coef_index = clf.coef_[0].argsort()
smallest = feature_names[sorted_coef_index[:50]]
largest = feature_names[sorted_coef_index[:-51:-1]]
```

**影响判断为垃圾邮件的特征词排名前 50**

```
largest
```

输出结果：

```py
array(['text', 'sale', 'free', 'uk', 'content', 'tones', 'sms', 'reply', 'order', 'won', 'ltd', 'girls', 'ringtone', 'to', 'comes', 'darling', 'this message', 'what you', 'new', 'www', 'co uk', 'std', 'co', 'about the', 'strong', 'txt', 'your', 'user', 'all of', 'choose', 'service', 'wap', 'mobile', 'the new', 'with', 'sexy', 'sunshine', 'xxx', 'this', 'hot', 'freemsg', 'ta', 'waiting for your', 'asap', 'stop', 'll have', 'hello', 'http', 'vodafone', 'of the'], dtype='<U31')
```

**影响判断为正常邮件的特征词排名前 50**

```
smallest
```

输出结果：

```py
array(['ì_ wan', 'for 1st', 'park', '1st', 'ah', 'wan', 'got', 'say', 'tomorrow', 'if', 'my', 'ì_', 'call', 'opinion', 'days', 'gt', 'its', 'lt', 'lovable', 'sorry', 'all', 'when', 'can', 'hope', 'face', 'she', 'pls', 'lt gt', 'hav', 'he', 'smile', 'wife', 'for my', 'trouble', 'me', 'went', 'about me', 'hey', '30', 'sir', 'lovely', 'small', 'sun', 'silent', 'me if', 'happy', 'only', 'them', 'my dad', 'dad'], dtype='<U31')
```

## 总结

这里提供了一个实用且可复现的检测垃圾邮件的算法示例，类似这样的预测算法正是自然语言处理（NLP）领域的主要任务之一。我们上面开发的这个模型 AUC 得分高达 0.97，这已经相当不错了。这套模型还可以继续添加测试用特征词，以便更准确的识别出垃圾邮件中经常特征词，反之亦然。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
