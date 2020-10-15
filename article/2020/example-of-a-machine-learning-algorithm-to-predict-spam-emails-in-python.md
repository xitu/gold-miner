> * 原文地址：[Email Spam Detector in Python](https://medium.com/python-in-plain-english/example-of-a-machine-learning-algorithm-to-predict-spam-emails-in-python-76addb1514d1)
> * 原文作者：[George Pipis](https://medium.com/@jorgepit-14189)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/example-of-a-machine-learning-algorithm-to-predict-spam-emails-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/example-of-a-machine-learning-algorithm-to-predict-spam-emails-in-python.md)
> * 译者：
> * 校对者：

# Email Spam Detector in Python

![Image by Unsplash](https://cdn-images-1.medium.com/max/2000/0*cNPIeopNeCpoyXUk.jpg)

## Ham or Spam

One of the most common projects, especially for teaching purposes, is to build models to predict if a message is spam or not. Our dataset called [Spam](https://github.com/lsvih/spam_email/blob/main/spam.csv.zip) contains the subject lines and the target which takes values `0` and `1` for ham and spam respectively.

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

Output:

![](https://cdn-images-1.medium.com/max/2000/1*40wu5WtjaDcWKRJtTMX3_g.png)

## Split the Data into Train and Test Dataset

```py
X_train, X_test, y_train, y_test = train_test_split(spam_data['text'], 
                 spam_data['target'], 
                 random_state=0)
```

## Build the tf-idf on N-grams

Fit and transform the training data `X_train` using a Tfidf Vectorizer ignoring terms that have a document frequency strictly lower than **5** and using **word n-grams from n=1 to n=3** (unigrams, bigrams, and trigrams)

```py
vect = TfidfVectorizer(min_df=5, ngram_range=(1,3)).fit(X_train) X_train_vectorized = vect.transform(X_train)
```

## Add Features

We apart from the tokens, we can add features such as the **number of digits**, the **dollar sign** , the **length** of the subject line and the **number of characters** (anything other than a letter, digit or underscore) . Let’s create a function for that.

```py
def add_feature(X, feature_to_add):
    """
    Returns sparse feature matrix with added feature.
    feature_to_add can also be a list of features.
    """
    from scipy.sparse import csr_matrix, hstack
    return hstack([X, csr_matrix(feature_to_add).T], 'csr')

# Train Data
add_length=X_train.str.len()
add_digits=X_train.str.count(r'\d')
add_dollars=X_train.str.count(r'\$')
add_characters=X_train.str.count(r'\W')

X_train_transformed = add_feature(X_train_vectorized , [add_length, add_digits,  add_dollars, add_characters])

# Test Data
add_length_t=X_test.str.len()
add_digits_t=X_test.str.count(r'\d')
add_dollars_t=X_test.str.count(r'\$')
add_characters_t=X_test.str.count(r'\W')

X_test_transformed = add_feature(vect.transform(X_test), [add_length_t, add_digits_t,  add_dollars_t, add_characters_t])
```

## Train the Logistic Regression Model

We will build the Logistic Regression Model and we will report the `AUC` score on the test dataset:

```py
clf = LogisticRegression(C=100, solver='lbfgs', max_iter=1000)

clf.fit(X_train_transformed, y_train)

y_predicted = clf.predict(X_test_transformed)

auc = roc_auc_score(y_test, y_predicted)
auc
```

Output:

```
0.9674528462047772
```

## Get the Most Important Features

We will show the **50** most important features which lead to either **Ham** of **Spam** respectively.

```py
feature_names = np.array(vect.get_feature_names() + ['lengthc', 'digit', 'dollars', 'n_char'])
sorted_coef_index = clf.coef_[0].argsort()
smallest = feature_names[sorted_coef_index[:50]]
largest = feature_names[sorted_coef_index[:-51:-1]]
```

**Features which lead to Spam:**

```
largest
```

Output:

```py
array(['text', 'sale', 'free', 'uk', 'content', 'tones', 'sms', 'reply', 'order', 'won', 'ltd', 'girls', 'ringtone', 'to', 'comes', 'darling', 'this message', 'what you', 'new', 'www', 'co uk', 'std', 'co', 'about the', 'strong', 'txt', 'your', 'user', 'all of', 'choose', 'service', 'wap', 'mobile', 'the new', 'with', 'sexy', 'sunshine', 'xxx', 'this', 'hot', 'freemsg', 'ta', 'waiting for your', 'asap', 'stop', 'll have', 'hello', 'http', 'vodafone', 'of the'], dtype='<U31')
```

**Features which lead to Ham:**

```
smallest
```

Output:

```py
array(['ì_ wan', 'for 1st', 'park', '1st', 'ah', 'wan', 'got', 'say', 'tomorrow', 'if', 'my', 'ì_', 'call', 'opinion', 'days', 'gt', 'its', 'lt', 'lovable', 'sorry', 'all', 'when', 'can', 'hope', 'face', 'she', 'pls', 'lt gt', 'hav', 'he', 'smile', 'wife', 'for my', 'trouble', 'me', 'went', 'about me', 'hey', '30', 'sir', 'lovely', 'small', 'sun', 'silent', 'me if', 'happy', 'only', 'them', 'my dad', 'dad'], dtype='<U31')
```

## Discussion

We provided a practical and reproducible example of how you can build a decent Ham or Spam algorithm. This is one of the main tasks in the field of NLP. Our model achieved an **AUC score of 97%** on the test dataset which is really good. We were also able to add features and also to identify the features which are more likely to appear in a Spam email and vice versa.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
