> * 原文地址：[Part-of-Speech tagging tutorial with the Keras Deep Learning library](https://medium.com/@cdiscountdatascience/part-of-speech-tagging-tutorial-with-the-keras-deep-learning-library-d7f93fa05537)
> * 原文作者：[Cdiscount Data Science](https://medium.com/@cdiscountdatascience?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/part-of-speech-tagging-tutorial-with-the-keras-deep-learning-library.md](https://github.com/xitu/gold-miner/blob/master/TODO1/part-of-speech-tagging-tutorial-with-the-keras-deep-learning-library.md)
> * 译者：[luochen](https://github.com/luochen1992)
> * 校对者：[stormluke](https://github.com/stormluke) [mingxing47](https://github.com/mingxing47)

# 利用 Keras 深度学习库进行词性标注教程

## 在本教程中，你将明白怎样使用一个简单的 Keras 模型来训练和评估用于多分类问题的人工神经网络。

![](https://cdn-images-1.medium.com/max/2000/1*pBYBy6lReldGq1qNTasU2Q.jpeg)

由 [Unsplash](https://unsplash.com/search/photos/stamp?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 的 [Joao Tzanno](https://unsplash.com/photos/G9_Euqxpu4k?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 拍摄

在 [自然语言处理](https://en.wikipedia.org/wiki/Natural_language_processing) 中，词性标注是一件众所周知的任务。它指的是将单词按词性分类（也称为词类或词性类别）。这是一种有监督的学习方法。

[人工神经网络](https://en.wikipedia.org/wiki/Artificial_neural_network) 已成功应用于词性标注，并且表现卓越。我们将重点关注多层感知器网络，这是一种非常流行的网络结构，被视为解决词性标注问题的最新技术。（译者注：对于词性标注问题，RNN 有更好的效果）

**让我们把它付诸实践！**

在本文中，你将获得一个关于如何在 Keras 中实现简单的多层感知器的快速教程，并在已标注的语料库上进行训练。

### 确保可重复性

为了保证我们的实验能够复现，我们需要设置一个随机种子：

```python
import numpy as np

CUSTOM_SEED = 42
np.random.seed(CUSTOM_SEED)
```

### 获取已标注的语料库

[Penn Treebank](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.8216&rep=rep1&type=pdf) 是一个词性标注语料库。Python 库中有个示例 `[NLTK](https://github.com/nltk/nltk)` 包含能够用于训练和测试某些自然语言处理模型（NLP models）的语料库。

首先，我们下载已标注的语料库：

```python
import nltk

nltk.download('treebank')
```

然后我们载入标记好的句子。

```python
from nltk.corpus import treebank

sentences = treebank.tagged_sents(tagset='universal')
```

然后我们随便挑个句子看看：

```python
import random

print(random.choice(sentences))
```

这是一个元组列表 `(term, tag)`.

```python
[('Mr.', 'NOUN'), ('Otero', 'NOUN'), (',', '.'), ('who', 'PRON'), ('apparently', 'ADV'), ('has', 'VERB'), ('an', 'DET'), ('unpublished', 'ADJ'), ('number', 'NOUN'), (',', '.'), ('also', 'ADV'), ('could', 'VERB'), ("n't", 'ADV'), ('be', 'VERB'), ('reached', 'VERB'), ('.', '.')]
```

这是一个包含四十多个不同类别的多分类问题。 
Treebank 语料库上的词性标注是一个众所周知的问题，我们期望模型精度能超过 95%。 

```python
tags = set([
    tag for sentence in treebank.tagged_sents() 
    for _, tag in sentence
])
print('nb_tags: %sntags: %s' % (len(tags), tags))
```

产生了一个：

```python
46
{'IN', 'VBZ', '.', 'RP', 'DT', 'VB', 'RBR', 'CC', '#', ',', 'VBP', 'WP$', 'PRP', 'JJ', 
'RBS', 'LS', 'PRP$', 'WRB', 'JJS', '``', 'EX', 'POS', 'WP', 'VBN', '-LRB-', '-RRB-', 
'FW', 'MD', 'VBG', 'TO', '$', 'NNS', 'NNPS', "''", 'VBD', 'JJR', ':', 'PDT', 'SYM', 
'NNP', 'CD', 'RB', 'WDT', 'UH', 'NN', '-NONE-'}
```

### 监督式学习的数据集预处理

我们将标记的句子划分成 3 个数据集：

*   **训练集** 相当于拟合模型的样本数据，
*   **验证集** 用于调整分类器的参数，例如选择网络中神经元的个数，
*   **测试集** **仅**用于评估分类器的性能。

![](https://cdn-images-1.medium.com/max/800/1*DEDwnWZCWoaCAQQq5RG0xg.png)

我们使用大约 60% 的标记句子进行训练，20% 作为验证集，20% 用于评估我们的模型。

```python
train_test_cutoff = int(.80 * len(sentences)) 
training_sentences = sentences[:train_test_cutoff]
testing_sentences = sentences[train_test_cutoff:]

train_val_cutoff = int(.25 * len(training_sentences))
validation_sentences = training_sentences[:train_val_cutoff]
training_sentences = training_sentences[train_val_cutoff:]
```

### 特征工程

我们的特征集非常简单。
对于每一个单词而言，我们根据提取单词的句子创建一个特征字典。
这些属性包含该单词的前后单词以及它的前缀和后缀。

```python
def add_basic_features(sentence_terms, index):
    """ 计算基本的单词特征
        :param sentence_terms: [w1, w2, ...] 
        :type sentence_terms: list
        :param index: the index of the word 
        :type index: int
        :return: dict containing features
        :rtype: dict
    """
    term = sentence_terms[index]
    return {
        'nb_terms': len(sentence_terms),
        'term': term,
        'is_first': index == 0,
        'is_last': index == len(sentence_terms) - 1,
        'is_capitalized': term[0].upper() == term[0],
        'is_all_caps': term.upper() == term,
        'is_all_lower': term.lower() == term,
        'prefix-1': term[0],
        'prefix-2': term[:2],
        'prefix-3': term[:3],
        'suffix-1': term[-1],
        'suffix-2': term[-2:],
        'suffix-3': term[-3:],
        'prev_word': '' if index == 0 else sentence_terms[index - 1],
        'next_word': '' if index == len(sentence_terms) - 1 else sentence_terms[index + 1]
    }
```

我们将句子列表映射到特征字典列表。

```python
def untag(tagged_sentence):
    """ 
    删除每个标记词语的标签。

:param tagged_sentence: 已标注的句子
    :type tagged_sentence: list
    :return: a list of tags
    :rtype: list of strings
    """
    return [w for w, _ in tagged_sentence]

def transform_to_dataset(tagged_sentences):
    """
    将标注的句子切分为 X 和 y 以及添加一些基本特征

:param tagged_sentences: 已标注的句子列表
    :param tagged_sentences: 元组列表之列表 (term_i, tag_i)
    :return: 
    """
    X, y = [], []

for pos_tags in tagged_sentences:
        for index, (term, class_) in enumerate(pos_tags):
            # Add basic NLP features for each sentence term
            X.append(add_basic_features(untag(pos_tags), index))
            y.append(class_)
    return X, y
```

对于训练、验证和测试句子，我们将属性分为 X（输入变量）和 y（输出变量）。

```python
X_train, y_train = transform_to_dataset(training_sentences)
X_test, y_test = transform_to_dataset(testing_sentences)
X_val, y_val = transform_to_dataset(validation_sentences)
```

### 特征编码

我们的神经网络将向量作为输入，所以我们需要将我们的字典特征转换为向量。
`sklearn` 的内建函数 `[DictVectorizer](http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.DictVectorizer.html)` 提供一种非常直接的方法进行向量转换。

```python
from sklearn.feature_extraction import DictVectorizer

# 用我们的特征集拟合字典向量生成器
dict_vectorizer = DictVectorizer(sparse=False)
dict_vectorizer.fit(X_train + X_test + X_val)

# 将字典特征转换为向量
X_train = dict_vectorizer.transform(X_train)
X_test = dict_vectorizer.transform(X_test)
X_val = dict_vectorizer.transform(X_val)
```

我们的 y 向量必须被编码。输出变量包含 49 个不同的字符串值，它们被编码为整数。

```python
from sklearn.preprocessing import LabelEncoder

# 用类别列表训练标签编码器
label_encoder = LabelEncoder()
label_encoder.fit(y_train + y_test + y_val)

# 将类别值编码成整数
y_train = label_encoder.transform(y_train)
y_test = label_encoder.transform(y_test)
y_val = label_encoder.transform(y_val)
```

然后我们需要将这些编码值转换为虚拟变量（独热编码）。

```python
# 将整数转换为虚拟变量（独热编码）
from keras.utils import np_utils

y_train = np_utils.to_categorical(y_train)
y_test = np_utils.to_categorical(y_test)
y_val = np_utils.to_categorical(y_val)
```

### 建立 Keras 模型

`[Keras](https://github.com/fchollet/keras/)` 是一个高级框架，用于设计和运行神经网络，它拥有多个后端像是 `[TensorFlow](https://github.com/tensorflow/tensorflow/)`, `[Theano](https://github.com/Theano/Theano)` 以及 `[CNTK](https://github.com/Microsoft/CNTK)`。

![](https://cdn-images-1.medium.com/max/800/1*jv-i8ieZA9AKk5j-avbCWg.png)

我们想创建一个最基本的神经网络：多层感知器。这种线性叠层可以通过序贯（`Sequential`）模型轻松完成。该模型将包含输入层，隐藏层和输出层。
为了克服过拟合，我们使用 dropout 正则化。我们设置断开率为 20%，这意味着在训练过程中每次更新参数时按 20% 的概率随机断开输入神经元。

我们对隐藏层使用 [_Rectified Linear Units_](https://en.wikipedia.org/wiki/Rectifier_%28neural_networks%29) (ReLU) 激活函数，因为它们是可用的最简单的非线性激活函数。

对于多分类问题，我们想让神经元输出转换为概率，这可以使用 _softmax_ 函数完成。我们决定使用多分类交叉熵（_categorical cross-entropy_）损失函数。
最后我们选择 [Adam optimizer](https://arxiv.org/abs/1412.6980) 因为似乎它非常适合分类任务.

```python
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation

def build_model(input_dim, hidden_neurons, output_dim):
    """
    构建、编译以及返回一个用于拟合/预测的 Keras 模型。
    """
    model = Sequential([
        Dense(hidden_neurons, input_dim=input_dim),
        Activation('relu'),
        Dropout(0.2),
        Dense(hidden_neurons),
        Activation('relu'),
        Dropout(0.2),
        Dense(output_dim, activation='softmax')
    ])

model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    return model
```

### 在 Keras API 和 Scikit-Learn 之间创建一个包装器

`[Keras](https://github.com/fchollet/keras/)` 提供了一个名为 `[KerasClassifier](https://keras.io/scikit-learn-api/)` 的包装器。它实现了 [Scikit-Learn](http://scikit-learn.org/stable/) 分类器接口。

所有的模型参数定义如下。我们需要提供一个返回神经网络结构的函数 (`build_fn`)。
隐藏的神经元的数量和批量大小的选择非常随意。我们将迭代次数设置为 5，因为随着迭代次数增多，多层感知器就会开始过拟合(即使用了 [Dropout Regularization](https://arxiv.org/abs/1207.0580))。

```python
from keras.wrappers.scikit_learn import KerasClassifier

model_params = {
    'build_fn': build_model,
    'input_dim': X_train.shape[1],
    'hidden_neurons': 512,
    'output_dim': y_train.shape[1],
    'epochs': 5,
    'batch_size': 256,
    'verbose': 1,
    'validation_data': (X_val, y_val),
    'shuffle': True
}

clf = KerasClassifier(**model_params)
```

### 训练 Keras 模型

最后，我们在训练集上训练多层感知器。

```python
hist = clf.fit(X_train, y_train)
```

通过回调历史（callback history），我们能够可视化模型的 _log loss_ 和 _accuracy_ 随时间的变化。

```python
import matplotlib.pyplot as plt

def plot_model_performance(train_loss, train_acc, train_val_loss, train_val_acc):
    """  绘制模型损失和准确度随时间变化的曲线  """

    blue= '#34495E'
    green = '#2ECC71'
    orange = '#E23B13'

    # 绘制模型损失曲线
    fig, (ax1, ax2) = plt.subplots(2, figsize=(10, 8))
    ax1.plot(range(1, len(train_loss) + 1), train_loss, blue, linewidth=5, label='training')
    ax1.plot(range(1, len(train_val_loss) + 1), train_val_loss, green, linewidth=5, label='validation')
    ax1.set_xlabel('# epoch')
    ax1.set_ylabel('loss')
    ax1.tick_params('y')
    ax1.legend(loc='upper right', shadow=False)
    ax1.set_title('Model loss through #epochs', color=orange, fontweight='bold')

    # 绘制模型准确度曲线
    ax2.plot(range(1, len(train_acc) + 1), train_acc, blue, linewidth=5, label='training')
    ax2.plot(range(1, len(train_val_acc) + 1), train_val_acc, green, linewidth=5, label='validation')
    ax2.set_xlabel('# epoch')
    ax2.set_ylabel('accuracy')
    ax2.tick_params('y')
    ax2.legend(loc='lower right', shadow=False)
    ax2.set_title('Model accuracy through #epochs', color=orange, fontweight='bold')
```

然后，看看模型的性能:

```python
plot_model_performance(
    train_loss=hist.history.get('loss', []),
    train_acc=hist.history.get('acc', []),
    train_val_loss=hist.history.get('val_loss', []),
    train_val_acc=hist.history.get('val_acc', [])
)
```

![](https://cdn-images-1.medium.com/max/800/1*QplV6zmPAXmFPNMngI8qcQ.png)

模型性能随迭代次数的变化。

两次迭代之后，我们发现模型过拟合。

### 评估多层感知器

由于我们模型已经训练好了，所以我们可以直接评估它：

```python
score = clf.score(X_test, y_test)
print(score)

[Out] 0.95816
```

我们在测试集上的准确率接近 96%，当你查看我们在模型中输入的基本特征时，这一点令人印象非常深刻。
请记住，即使对于人类标注者来说，100% 的准确性也是不可能的。我们估计人类词性标注的准确度大概在 98%。

### 模型的可视化

```python
from keras.utils import plot_model

plot_model(clf.model, to_file='model.png', show_shapes=True)
```

![](https://cdn-images-1.medium.com/max/800/1*jJLD2eI0saZx_rszhPFrYg.png)

### 保存 Keras 模型

保存 Keras 模型非常简单，因为 Keras 库提供了一种本地化的方法：

```python
clf.model.save('/tmp/keras_mlp.h5')
```

保存了模型的结构，权重以及训练配置（损失函数，优化器）。

#### 资源

*   Keras: Python 深度学习库：[[doc]](https://keras.io/)
*   Adam: 一种随机优化方法：[[paper]](https://arxiv.org/abs/1412.6980)
*   Improving neural networks by preventing co-adaptation of feature detectors: [[paper]](https://arxiv.org/abs/1207.0580)

在本文中，您学习如何使用 Keras 库定义和评估用于多分类的神经网络的准确性。
代码在这里：[[.py](https://github.com/Cdiscount/IT-Blog/blob/master/scripts/pos_tagging_neural_nets_keras.py)|[.ipynb](https://github.com/Cdiscount/IT-Blog/blob/master/scripts/pos_tagging_neural_nets_keras.ipynb)].


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
