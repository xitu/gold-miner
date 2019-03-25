> * 原文地址：[Chars2vec: character-based language model for handling real world texts with spelling errors and…](https://hackernoon.com/chars2vec-character-based-language-model-for-handling-real-world-texts-with-spelling-errors-and-a3e4053a147d)
> * 原文作者：[Intuition Engineering](https://medium.com/@intuition.engin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/chars2vec-character-based-language-model-for-handling-real-world-texts-with-spelling-errors-and.md](https://github.com/xitu/gold-miner/blob/master/TODO1/chars2vec-character-based-language-model-for-handling-real-world-texts-with-spelling-errors-and.md)
> * 译者：[kasheemlew](https://github.com/kasheemlew)
> * 校对者：[xionglong58](https://github.com/xionglong58), [lsvih](https://github.com/lsvih)

# Chars2vec：基于字符实现的可用于处理现实世界中包含拼写错误和俚语的语言模型

![](https://cdn-images-1.medium.com/max/9094/1*kAvyOmNO4q1PAa-qEyrc5g.jpeg)

这篇论文介绍了我们开源的基于字符的语言模型 [**chars2vec**](https://github.com/IntuitionEngineeringTeam/chars2vec)。这个模型使用 Keras 库（TensorFlow 后端）开发，现在已经可以在 Python 2.7 和 3.0+ 中使用。

## 引言

创建并使用词嵌入是完成大多数 NLP 任务的主流方法。每个词都对应着一个数值向量，当文本中出现这个词的时候就会用上它的数值向量。有些**简单的模型会使用 one-hot 词嵌入，也可能使用随机向量或整数来对词进行初始化**。这类模型的缺点很明显——这种将对词进行向量化的方式不能表示词之间任何的语义联系。

还有**另外一种称为语义化的语言模型，它们根据仿射嵌入向量对有词义关联的词进行排序**。事实上，这些模型表示了不同单词的上下文邻近性：这些模型使用诸如百科全书、新闻、文学作品之类的拥有大量文本的语料库进行训练。这样训练使得出现在相似上下文中的词都得以用临近的向量表示。经典的语义化语言模型包括 [Word2Vec](https://www.tensorflow.org/tutorials/representation/word2vec) 和 [GloVe](https://nlp.stanford.edu/projects/glove/)。更加前沿的语义化语言模型（[ULMFiT](https://arxiv.org/abs/1801.06146)，[ELMo](https://allennlp.org/elmo)）基于循环神经网络（RNNs）和其他神经网络体系结构。

语义化的模型包含从大量语料上学得的词义相关的信息，但是它们需要与固定的词汇搭配（通常会遗漏一些生僻词）。这对于 NLP 问题来说是个严重的缺陷。**如果语义化语言模型的词汇表里缺少一段文本中很多的单词，那么它在处理某些 NLP 任务时效率就不会高——这个模型将不能够解释那些缺少的单词**。这种情况可能出现在处理人类编写的文本（例如回复、评论、申请书、文档或者网上的帖子）的时候。这些文本可能包含一些俚语、特殊领域的生僻词或者是词汇表中没有的人名，所以语义化的模型中也不会出现这些词。排印错误也会创造出一些不存在于任何词嵌入中的“新”词。

比如使用 [MovieLens](https://grouplens.org/datasets/movielens/) 的数据搭建电影推荐系统时，在处理用户评论的过程中这个问题就很明显。用户的评论中经常会出现 “like Tarantino” 这个短语；他们有时会把导演的姓 “Tarantino” 弄错，从而创造出 “Taratino”、“Torantino”、“Tarrantino” 等“新”词。如果能从用户的评论中提取出 “Tarantino” 这个特征的话，就能够显著改善电影的相关性度量和推荐质量，提取出具体姓氏或者拼写错误等词汇表中没有的词所表示的特征也能达到同样的效果。

> 为了解决这个问题，前文提到过，我们需要使用一个能够创建出词嵌入的语言模型，创建过程完全根据拼写，并且将向量根据其表示的词之间的相似性排序。

## 关于 chars2vec 模型

我们根据单词的符号嵌入开发了 chars2vec 这个语言模型。**这个模型将一段任意长度的符号序列用一个固定长度的向量表示出来，单词之间拼写的相似性则通过向量间的距离度量表示。**这个模型不基于某个词典（它没有储存单词与对应向量表示所组成的固定词典），因此它在创建和使用的过程中并不需要大量的计算资源。使用 pip 就可以安装 Chars2vec 库：

```
>>> pip install chars2vec
```

下面的代码创建了 chars2vec 词嵌入（50 维) 并使用 PCA 将这些词嵌入向量映射到了一个平面上，最后我们会得到一张可以描述这个模型的几何意义图片：

```python
import chars2vec
import sklearn.decomposition
import matplotlib.pyplot as plt

# 加载 Inutition Engineering 预训练的模型
# 模型的名字：'eng_50', 'eng_100', 'eng_150' 'eng_200', 'eng_300'
c2v_model = chars2vec.load_model('eng_50')

words = ['Natural', 'Language', 'Understanding',
         'Naturael', 'Longuge', 'Updderctundjing',
         'Motural', 'Lamnguoge', 'Understaating',
         'Naturrow', 'Laguage', 'Unddertandink',
         'Nattural', 'Languagge', 'Umderstoneding']

# 创建词嵌入
word_embeddings = c2v_model.vectorize_words(words)

# 使用 PCA 将词嵌入映射到平面上
projection_2d = sklearn.decomposition.PCA(n_components=2).fit_transform(word_embeddings)

# 在平面上写字
f = plt.figure(figsize=(8, 6))

for j in range(len(projection_2d)):
    plt.scatter(projection_2d[j, 0], projection_2d[j, 1],
                marker=('$' + words[j] + '$'),
                s=500 * len(words[j]), label=j,
                facecolors='green' if words[j] 
                           in ['Natural', 'Language', 'Understanding'] else 'black')

plt.show()
```

执行这段代码将会生成下面这张图片：

![](https://cdn-images-1.medium.com/max/3200/1*gjqy3VkVQK51BXsI7qOv4A.png)

我们可以看到，尽管这个模型基于一个接受单词的符号序列的循环神经网络，而不是去分析一个单词中某些字母或者某种模式的出现情况，拼写相似的词的表示向量仍是临近的。单词拼写中出现的增添、删减或者替换越多，它的词嵌入就会离原始词越远。

## 基于字符模型的应用

在字符层面上分析文本的想法并不新鲜——已经有一些模型对符号创建词嵌入，然后通过平均过程创建符号词嵌入。平均过程是这种方法的瓶颈——这种模型一定程度上解决了上面提到的问题，但不幸的是，它们还不够完美。如果想要编码一些除了事实之外的关于符号相对位置和符号模式的信息，我们还需要进行更多的训练，这样才能从符号嵌入向量中找出每个词嵌入的正确形式。

[karpathy/char-rnn](https://github.com/karpathy/char-rnn) 是最早在字符级处理文本的 NLP 模型之一。它通过输入文本训练了一个循环神经网络（RNN），给定一段字符序列就能够预测下一个符号。[Character-Level Deep Learning in Sentiment Analysis](https://offbit.github.io/how-to-read/) 也是基于 RNN 的字符级语言模型。有时，我们会用卷积神经网络（CNNs）处理字符序列，请查阅 [Character-Aware Neural Language Models](https://arxiv.org/pdf/1508.06615v4.pdf)；[Character-level Convolutional Networks for Text Classification](https://arxiv.org/pdf/1509.01626.pdf) 这篇论文也是一个使用 CNN 进行文本分类的例子。

Facebook 的 [fastText](https://github.com/facebookresearch/fastText) 库中实现的模型是基于字符的语言模型的典范。fastText 模型会创建符号词嵌入，然后基于符号表示来解决文本分类的问题。这种技术基于对多种 n 元语法生成词的分析，而不依赖于 RNN，避免了模型对于排印错误和拼写错误过于敏感的问题，也就不会对 n 元语法生成词的范围造成太大的影响。不过这个模型提供了语言词汇表中缺失的单词对应的的词嵌入。

## 模型结构

每个 chars2vec 模型都有一个固定的字符表，用于单词的向量化：每当列表中的一个字符出现在文本中的时候，表示这个字符的 one-hot 向量就会被反馈给模型；向量化的过程中会忽略掉列表中没有的字符。我们训练的模型主要用来处理英文文本；这些模型使用的列表包括了常用的 ASCII 字符——所有的英文字母、数字和常用的标点符号：

```python
['!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.',
 '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<',
 '=', '>', '?', '@', '_', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
 'x', 'y', 'z']
```

该模型对大小写不敏感，所有的符号都统一转换成小写形式。

Chars2vec 通过基于 TensorFlow 的 Keras 库实现。创建词嵌入的神经网络结构如下：

![](https://cdn-images-1.medium.com/max/2000/1*YpwI_8WVXJ329bUyqmC6eQ.jpeg)

一个任意长度的 one-hot 向量序列表示一个词中的字符序列，经过两个 LSTM 层处理之后，会输出这个词的嵌入向量。

为了训练好模型，我们要使用一个包含 chars2vec 的扩展神经网络。更准确地说，我们的神经网络需要将两个 one-hot 向量序列作为输入，它们分别代表着不同的词，其次这个神经网络会使用一个 chars2vec 创建出它们所对应的词嵌入，然后计算出这些嵌入向量差值的范数，最后将这个结果反馈给网络最后一层的 sigmoid 激活函数。这个神经网络的输出范围是 0 到 1。

![](https://cdn-images-1.medium.com/max/2000/1*0aX4CoKeFrOcVjlC88Tc3w.jpeg)

这个扩展神经网络使用一对词进行训练，在训练样本中，一对“相似”的词被标记为 0 值，而“不相似”的值则被标记为 1。事实上，我们所定义的“相似性”这个标准是将一个词变形为另一个词所需要替换、增加、删减的字符的数量。这也造就了我们获取数据的方式——我们对大量的词进行多种修改，创建出一个新的词集。通过修改原词得到的词集的子集本质上和原词是相似的，这样的单词对会被标记为 0。从不同子集中选出的单词显然有更多不同点，所以会被标记为 1。

初始词集的大小、子集中词的数量、对词进行变形最大次数决定了模型的训练结果和模型向量化的稳定性。最优的参数应该根据给定的语言和任务进行选择。另一个重点是保持整个训练集的均衡（我们应该协调好这两个方面）。

扩展神经网络的第二个部分只有一条边，训练过程中可以调整它的权重；这部分网络将单调函数应用到对嵌入向量差范数。训练集限制了这第二个部分只能对“相似的”词对输出 0，对“不相似的”词对输出 1，所以在训练这个扩展模型的时候，内层的 chars2vec 模型将学会为“相似的”词对构建临近的嵌入向量，为“不相似的”词对构建远离的嵌入向量。

我们在词嵌入维度分别为 50、100、150、200 和 300 情况下的英语中训练了 chars2vec 模型。[仓库](https://github.com/IntuitionEngineeringTeam/chars2vec)中已经上传了项目源码以及训练和使用模型的例子（我们还在数据集上训练了一个适用于另一种语言的模型）。

## 训练你自己的 chars2vec 模型

下面的代码段展示了如何训练一个自己的 chars2vec 模型实例。

```python
import chars2vec

dim = 50

path_to_model = 'path/to/model/directory'

X_train = [('mecbanizing', 'mechanizing'), # 相似词，目标为 0
           ('dicovery', 'dis7overy'), # 相似词，目标为 0
           ('prot$oplasmatic', 'prtoplasmatic'), # 相似词，目标为 0
           ('copulateng', 'lzateful'), # 非相似词，目标为 1
           ('estry', 'evadin6'), # 非相似词，目标为 1
           ('cirrfosis', 'afear') # 非相似词，目标为 1
          ]

y_train = [0, 0, 0, 1, 1, 1]

model_chars = ['!', '"', '#', '$', '%', '&', "'", '(', ')', '*', '+', ',', '-', '.',
               '/', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<',
               '=', '>', '?', '@', '_', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
               'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w',
               'x', 'y', 'z']

# 创建 chars2vec 模型，并使用前面的训练数据进行训练
my_c2v_model = chars2vec.train_model(dim, X_train, y_train, model_chars)

# 保存预训练的模型
chars2vec.save_model(my_c2v_model, path_to_model)

words = ['list', 'of', 'words']

# 保存预训练的模型，创建词嵌入
c2v_model = chars2vec.load_model(path_to_model)
word_embeddings = c2v_model.vectorize_words(words)
```

模型在单词向量化是要用到的字符列表 `model_chars`、模型的维度 `dim` 和用来存储模型的目录的路径 `path_to_model`。训练集 (`X_train`, `y_train`) 由“相似”词对和“非相似”词对组成。`X_train` 是一个词对列表，`y_train` 是它们相似度分数（0 或 1）的列表。

有一点很重要，`model_chars` 列表中所有的字符都应该包含在训练数据集的词集中——如果某一个字符不在其中，或者出现的频率很低，那么每当测试数据集中出现这个字符都会引起不稳定的模型行为。由于这类字符相关的 one-hot 向量很少被传入模型的输入层，模型第一层的权重总是乘 0，也就是说这些权重参数一直都没有被调整到。

chars2vec 模型的另一个优势是解决任意缺少预训练模型的语言相关的 NLP 难题的能力。相比于使用具体词汇处理文本的经典模型，这个模型为一些文本分类和聚类问题提供了更好的办法。

## 基准测试

我们在 IMDb 数据集上对多种词嵌入进行了评论分类任务的基准测试。IMDb 是一个开放的影评数据集，一个评论可以是正面或负面的，所以这是文本二分类任务，我们使用了 5 万条评论作为训练集，另外 5 万条用于测试。

除了 chars2vec 词嵌入，我们还测试了一些有名的词嵌入模型，例如 [GloVe](https://nlp.stanford.edu/projects/glove/)、Google 的 [word2vec](https://code.google.com/archive/p/word2vec/)（“预训练向量使用一部分 Google 新闻数据集（大概 1 亿个词）进行训练。这个模型包含了 3 百万个词和短语所对应的 300 维向量”）、[fastText](https://fasttext.cc/docs/en/english-vectors.html) （维基新闻模型包含 300 个维度，“在维基百科 2017、UMBC webbase 语料库和 statmt.org 新闻数据集（160 亿个标识）上训练的 1 百万个词向量”）。

分类模型工作步骤如下：计算每个每个评论包含的单词的嵌入向量的平均值，以此将其向量化。如果模型词典中没有某个词，就会使用零向量表示这个词。我们使用了 NLTK 库提供的一个包括停止词的标准标识化过程，使用 linearSVM 作为分类器。下面的表格展示了我们对大多数流行的模型进行这样的基准测试得到的正确率。需要指出的是，我们的 chars2vec 模型比依赖大规模词汇表简化了 300 倍，并且仍然能够得到相当不错的结果。

|  词嵌入  | 正确率 | 模型大小 |
|----------------- |----------------------- |-----------------------|
| GLoVe 50 | 0.7536 | 171.5 MB | 
| GLoVe 300 | 0.83336 | 1.04 GB | 
| word2vec GoogleNews-vectors-negative300 | 0.85604 | 3.64 GB | 
| fastText wiki-news-300d-1M | 0.85568 | 2.26 GB | 
| chars2vec 50 | 0.63036 | 188 KB | 
| chars2vec 100 | 0.6788 | 598 KB | 
| chars2vec 150 | 0.69592 | 1.2 MB | 
| chars2vec 200 | 0.70188 | 2.1 MB | 
| chars2vec 300 | 0.74012 | 4.6 MB | 

我们发现，与语义模型相比，chars2vec 模型还有一些进步空间。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
