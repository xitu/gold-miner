> * 原文地址：[Chars2vec: character-based language model for handling real world texts with spelling errors and…](https://hackernoon.com/chars2vec-character-based-language-model-for-handling-real-world-texts-with-spelling-errors-and-a3e4053a147d)
> * 原文作者：[Intuition Engineering](https://medium.com/@intuition.engin)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/chars2vec-character-based-language-model-for-handling-real-world-texts-with-spelling-errors-and.md](https://github.com/xitu/gold-miner/blob/master/TODO1/chars2vec-character-based-language-model-for-handling-real-world-texts-with-spelling-errors-and.md)
> * 译者：
> * 校对者：

# Chars2vec: character-based language model for handling real world texts with spelling errors and…

![](https://cdn-images-1.medium.com/max/9094/1*kAvyOmNO4q1PAa-qEyrc5g.jpeg)

## Chars2vec: character-based language model for handling real world texts with spelling errors and human slang

This paper describes our open source character-based language model [**chars2vec**](https://github.com/IntuitionEngineeringTeam/chars2vec). This model was developed with Keras library (TensorFlow backend) and now is available for Python 2.7 and 3.0+.

## Introduction

Creating and using word embeddings is the mainstream approach for handling most of the NLP tasks. Each word is matched with a numeric vector which is then used in some way if the word appears in text. Some **simple models use one-hot word embeddings or initialise words with random vectors or with integer numbers**. The drawback of such models is obvious – such word vectorisation methods do not represent any semantic connections between words.

There are **other language models, called semantic, collating words related by sense with the affine embedding vectors**. In fact these models represent contextual proximity of various words: such models are trained on a large corpora of existing texts such as encyclopedias, news texts or literature. The result is that the words appearing in similar contexts in these texts are represented by proximal vectors. The classic examples of semantic language models are [Word2Vec](https://www.tensorflow.org/tutorials/representation/word2vec) and [GloVe](https://nlp.stanford.edu/projects/glove/). Some of the more modern semantic language models ([ULMFiT](https://arxiv.org/abs/1801.06146), [ELMo](https://allennlp.org/elmo)) are based on the recurrent neural networks (RNNs) and on other neural network architectures.

Semantic models contain some information about the sense of words extracted while training on large texts corpora but they operate with a fixed vocabulary (usually lacking some rarely used words). This is a significant drawback for solving some of NLP problems. **If a number of important words in a text does not belong to the vocabulary of a semantic language model then it is non-efficient in solving some kinds of NLP tasks — the model won’t be able to interpret these words**. Such a case could arise if we try to process texts written by humans (these could be replies, comments, applications, documents or posts in web). These texts could contain slang, some rare words from specific areas, or given names which are not presented in language vocabulary and, accordingly, in semantic models. Typos also produce “new” words without any collated embedding.

A good example is the task of processing user’s comments to movies while building a movie recommender system based on [MovieLens](https://grouplens.org/datasets/movielens/) dataset. Words “like Tarantino” could often be found among peoples comments; errors or typos in director’s surname “Tarantino” produce a number of “new” words like “Taratino”, “Torantino”, “Tarrantino”, “Torontino”, etc. The ability to extract this “Tarantino” feature from users comments would obviously improve movies relevance metric and recommendations quality as well as extraction of various other features represented by non-vocabulary words, either very specific like surnames, or produced by typos and erroneous spelling.
> # To solve the problem we have described it would be appropriate to use a language model that would create word embeddings based only on their spelling and would collate similar vectors to similarly spelled words.

## About chars2vec model

We have developed the chars2vec language model based on symbolic embeddings of words. **The model represents each sequence of symbols of arbitrary length with a fixed length vector, the similarity in words spelling is represented by the distance metric between vectors.** This model is not dictionary based (it does not store a fixed dictionary of words with corresponding vector representations), that is why it’s initialisation and usage procedures do not require significant computational resources. Chars2vec library could be installed via pip:

```
>>> pip install chars2vec
```

The following code snippet creates chars2vec embeddings (with dimension 50) and projects these embedding vectors on a plane with the help of PCA, outputting an image depicting the geometrical meaning of the described model:


Execution of this code produces the following image:

![](https://cdn-images-1.medium.com/max/3200/1*gjqy3VkVQK51BXsI7qOv4A.png)

We can see that the similarly spelled words are represented by the neighbouring vectors. Yet the model is based on a recurrent neural network accepting a sequence of symbols of a word, not on analysis of the facts of letters or patterns presence in a word. The more changes such as additions, deletions or replacements we make in a word the further its embedding would stand from the original.

## Application of character-based models

The idea of text analysis on character level is not new — there are models creating embeddings for each symbol and then creating symbolic word embedding with the help of an averaging procedure. The averaging procedure is the bottleneck — such models provide some sort of solutions of the problems stated above, unfortunately, not the optimal ones, because the search of the proper form of each word’s embedding creation from the symbols embedding vectors requires additional training if we want to encode some information about the symbols relative positioning and symbolic patterns besides the mere fact of symbols presence in a word.

One of the pioneering NLP models processing texts on the character level is [karpathy/char-rnn](https://github.com/karpathy/char-rnn). This model takes some text as an input and trains a recurrent neural network (RNN) to predict the next symbol of a given sequence of characters. There are other RNN based character-level language models such as [Character-Level Deep Learning in Sentiment Analysis](https://offbit.github.io/how-to-read/). In some cases the convolutional neural networks (CNNs) are used to process a sequence of characters, check out [Character-Aware Neural Language Models](https://arxiv.org/pdf/1508.06615v4.pdf), an example of CNNs usage for texts classification could be found in the paper [Character-level Convolutional Networks for Text Classification](https://arxiv.org/pdf/1509.01626.pdf).

A prime example of a character-based language model is the model implemented in the [fastText](https://github.com/facebookresearch/fastText) library by Facebook. The fastText model creates symbolic word embeddings and solves texts classification problem based on their symbolic representation. This technology is based on the analysis of multiple n-grams forming words instead of RNNs which makes this model very sensitive to typos and spelling errors as far as they can significantly change the range of n-grams forming a word. Yet this model provides embeddings of words missing from the language vocabulary.

## Model architecture

Each chars2vec model has a fixed list of characters used for words vectorisation: the characters from this list are represented by various one-hot vectors which are fed to the model when the character appears in the text; the characters absent in the list are ignored in the vectorisation procedure. We trained models designed to process English texts; these models use a list of the most popular of ASCII characters — all English letters, digits and the most popular punctuation:


The model is not case sensitive, it converts any symbol’s case to the lower one.

Chars2vec is implemented with the help of Keras library based on TensorFlow. The neural network creating words embeddings has the following architecture:

![](https://cdn-images-1.medium.com/max/2000/1*YpwI_8WVXJ329bUyqmC6eQ.jpeg)

A sequence of one-hot vectors of an arbitrary length representing the sequence of characters in a word, passes through two LSTM layers, the output is the embedding vector of the word.

To train a model we have used an extended neural network including chars2vec model as a part. To be more specific, we are dealing with a neural network taking two sequences of one-hot vectors representing two different words as an input, creating their embeddings with one chars2vec model, calculating the norm of the difference between these embedding vectors and feeding it into the last layer of the network with the sigmoid activation function. The output of this neural network is a number ranging from 0 to 1.

![](https://cdn-images-1.medium.com/max/2000/1*0aX4CoKeFrOcVjlC88Tc3w.jpeg)

The extended neural network is trained on pairs of words, in training data a pair of “similar” words is labeled with 0 value, and a pair of “not similar” with 1. In fact we define the “similarity” metric as a number of substitutions, additions and removals of characters that have to be performed to make one word from the other. This brings us to the way of obtaining such training data — it can be generated by taking a multitude of words and then performing various changes upon them to obtain a new set of words. A subset of new words produced by changes in one original word would naturally be similar to this original word and such pairs of words would have label 0. Words from different subsets would obviously have more differences and should be labeled with 1.

The size of the initial words set, the number of words in each subset, the maximum number of changing operations upon a word within one subset define the result of model training and model’s vectorisation rigidity. The optimal values of these parameters should be chosen regarding the language specifics and the particular task. The other important point is keeping the whole training set balanced (none of the two classes should prevail).

The second part of the extended neural network has only one edge which weight could be adjusted during training process; this part of the network applies monotonous function to the embedding vectors difference norm. The training dataset dictates that this second part should output 0 for “similar” word pairs and 1 for “not similar”, so while training the extended model the inner chars2vec model learns to form neighbouring embedding vectors for the “similar” word pairs and distant ones for the “not similar” pairs.

We have trained chars2vec models for English language with embedding dimensions of 50, 100, 150, 200 and 300. The project source code is available in the [repo](https://github.com/IntuitionEngineeringTeam/chars2vec) along with the model training and usage examples (we’ve trained the model on our dataset for a new language).

## Train your own chars2vec model

The following code snippet shows the way to train your own chars2vec model instance.


A list of characters `model_chars` that the model would use for words vectorisation should be defined as well as the model’s dimension `dim` and path to the model storage folder `path_to_model`. Training set (`X_train`, `y_train`) consists of pairs of “similar” and “not similar” words. `X_train` is a list of word pairs, and `y_train` is a list of their binary similarity metric scores (0 or 1).

It is important that all the characters from the `model_chars` list should be present in the set of words of the training dataset — if a character is absent or appears very seldom then unstable model behaviour could be observed once this character is met in the test dataset. The reason is that the corresponding one-hot vector has been rarely fed into the model’s input layer and some weights of the model’s first layer have always been multiplied by zero meaning their tuning has never been performed.

Another advantage of chars2vec model is the ability to solve various NLP problems for an arbitrary language lacking open pertained language models. This model could provide better solutions of some texts classification or clustering problems than classic models if you are processing texts with specific vocabularies.

## Benchmarks

We have performed benchmarking on the IMDb dataset for the reviews classification task using various words embeddings. IMDb is an open dataset of movie reviews which could be positive or negative so it is a binary text classification task with 50k reviews as the training set and 50k set for tests.

Along with chars2vec embeddings we have tested several prominent embedding models like [GloVe](https://nlp.stanford.edu/projects/glove/), [word2vec](https://code.google.com/archive/p/word2vec/) by Google (“pre-trained vectors trained on part of Google News dataset (about 100 billion words). The model contains 300-dimensional vectors for 3 million words and phrases”), [fastText](https://fasttext.cc/docs/en/english-vectors.html) (wiki-news model with dimension 300, “1 million word vectors trained on Wikipedia 2017, UMBC webbase corpus and statmt.org news dataset (16B tokens)”).

The classifier model looks the following way: each review is vectorised by averaging the embedding vectors of all the words comprising it. If a word is out of the model dictionary, a zero vector is assigned to it. We have used a standart tokenisation procedure along with stop words by NLTK library. The classifier we chose was the linearSVM. The table below shows test accuracies for the most popular models we have benchmarked this way. We should point out that our chars2vec model is about 3 oders lighter than the semantic models relying on large vocabularies and still demonstrates quite reasonable results.


We see some space for chars2vec model improvements needed to compete with the results of the semantic models.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
