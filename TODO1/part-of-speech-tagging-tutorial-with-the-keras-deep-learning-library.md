> * 原文地址：[Part-of-Speech tagging tutorial with the Keras Deep Learning library](https://medium.com/@cdiscountdatascience/part-of-speech-tagging-tutorial-with-the-keras-deep-learning-library-d7f93fa05537)
> * 原文作者：[Cdiscount Data Science](https://medium.com/@cdiscountdatascience?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/part-of-speech-tagging-tutorial-with-the-keras-deep-learning-library.md](https://github.com/xitu/gold-miner/blob/master/TODO1/part-of-speech-tagging-tutorial-with-the-keras-deep-learning-library.md)
> * 译者：
> * 校对者：

# Part-of-Speech tagging tutorial with the Keras Deep Learning library

## In this tutorial, you will see how you can use a simple Keras model to train and evaluate an artificial neural network for multi-class classification problems.

![](https://cdn-images-1.medium.com/max/2000/1*pBYBy6lReldGq1qNTasU2Q.jpeg)

Photo by [Joao Tzanno](https://unsplash.com/photos/G9_Euqxpu4k?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/search/photos/stamp?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)

Part-of-Speech tagging is a well-known task in [Natural Language Processing](https://en.wikipedia.org/wiki/Natural_language_processing). It refers to the process of classifying words into their parts of speech (also known as words classes or lexical categories). This is a supervised learning approach.

[Artificial neural networks](https://en.wikipedia.org/wiki/Artificial_neural_network) have been applied successfully to compute POS tagging with great performance. We will focus on the Multilayer Perceptron Network, which is a very popular network architecture, considered as the state of the art on Part-of-Speech tagging problems.

**Let’s put it into practice!**

In this post you will get a quick tutorial on how to implement a simple Multilayer Perceptron in Keras and train it on an annotated corpus.

### Ensuring reproducibility

In order to be sure that our experiences can be achieved again we need to fix the random seed for reproducibility:

```
import numpy as np

CUSTOM_SEED = 42
np.random.seed(CUSTOM_SEED)
```

### Getting an annotated corpus

The [Penn Treebank](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.9.8216&rep=rep1&type=pdf) is an annotated corpus of POS tags. A sample is available in the `[NLTK](https://github.com/nltk/nltk)` python library which contains a lot of corpora that can be used to train and test some NLP models.

First of all, we download the annotated corpus:

```
import nltk

nltk.download('treebank')
```

Then we load the tagged sentences…

```
from nltk.corpus import treebank

sentences = treebank.tagged_sents(tagset='universal')
```

… and visualize one:

```
import random

print(random.choice(sentences))
```

This yields a list of tuples `(term, tag)`.

```
[('Mr.', 'NOUN'), ('Otero', 'NOUN'), (',', '.'), ('who', 'PRON'), ('apparently', 'ADV'), ('has', 'VERB'), ('an', 'DET'), ('unpublished', 'ADJ'), ('number', 'NOUN'), (',', '.'), ('also', 'ADV'), ('could', 'VERB'), ("n't", 'ADV'), ('be', 'VERB'), ('reached', 'VERB'), ('.', '.')]
```

This is a multi-class classification problem with more than forty different classes.
POS tagging on Treebank corpus is a well-known problem and we can expect to achieve a model accuracy larger than 95%.

```
tags = set([
    tag for sentence in treebank.tagged_sents() 
    for _, tag in sentence
])
print('nb_tags: %sntags: %s' % (len(tags), tags))
```

This yields:

```
46
{'IN', 'VBZ', '.', 'RP', 'DT', 'VB', 'RBR', 'CC', '#', ',', 'VBP', 'WP$', 'PRP', 'JJ', 
'RBS', 'LS', 'PRP$', 'WRB', 'JJS', '``', 'EX', 'POS', 'WP', 'VBN', '-LRB-', '-RRB-', 
'FW', 'MD', 'VBG', 'TO', '$', 'NNS', 'NNPS', "''", 'VBD', 'JJR', ':', 'PDT', 'SYM', 
'NNP', 'CD', 'RB', 'WDT', 'UH', 'NN', '-NONE-'}
```

### Datasets preprocessing for supervised learning

We split our tagged sentences into 3 datasets :

*   a **training dataset** which corresponds to the sample data used to fit the model,
*   a **validation dataset** used to tune the parameters of the classifier, for example to choose the number of units in the neural network,
*   a **test dataset** used _only_ to assess the performance of the classifier.

![](https://cdn-images-1.medium.com/max/800/1*DEDwnWZCWoaCAQQq5RG0xg.png)

We use approximately 60% of the tagged sentences for training, 20% as the validation set and 20% to evaluate our model.

```
train_test_cutoff = int(.80 * len(sentences)) 
training_sentences = sentences[:train_test_cutoff]
testing_sentences = sentences[train_test_cutoff:]

train_val_cutoff = int(.25 * len(training_sentences))
validation_sentences = training_sentences[:train_val_cutoff]
training_sentences = training_sentences[train_val_cutoff:]
```

### Feature engineering

Our set of features is very simple.
For each term we create a dictionnary of features depending on the sentence where the term has been extracted from.
These properties could include informations about previous and next words as well as prefixes and suffixes.

```
def add_basic_features(sentence_terms, index):
    """ Compute some very basic word features.
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

We map our list of sentences to a list of dict features.

```
def untag(tagged_sentence):
    """ 
    Remove the tag for each tagged term.

:param tagged_sentence: a POS tagged sentence
    :type tagged_sentence: list
    :return: a list of tags
    :rtype: list of strings
    """
    return [w for w, _ in tagged_sentence]

def transform_to_dataset(tagged_sentences):
    """
    Split tagged sentences to X and y datasets and append some basic features.

:param tagged_sentences: a list of POS tagged sentences
    :param tagged_sentences: list of list of tuples (term_i, tag_i)
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

For training, validation and testing sentences, we split the attributes into `X` (input variables) and `y` (output variables).

```
X_train, y_train = transform_to_dataset(training_sentences)
X_test, y_test = transform_to_dataset(testing_sentences)
X_val, y_val = transform_to_dataset(validation_sentences)
```

### Features encoding

Our neural network takes vectors as inputs, so we need to convert our dict features to vectors.
`sklearn` builtin function `[DictVectorizer](http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.DictVectorizer.html)` provides a straightforward way to do that.

```
from sklearn.feature_extraction import DictVectorizer

# Fit our DictVectorizer with our set of features
dict_vectorizer = DictVectorizer(sparse=False)
dict_vectorizer.fit(X_train + X_test + X_val)

# Convert dict features to vectors
X_train = dict_vectorizer.transform(X_train)
X_test = dict_vectorizer.transform(X_test)
X_val = dict_vectorizer.transform(X_val)
```

Our `y` vectors must be encoded. The output variable contains 49 different string values that are encoded as integers.

```
from sklearn.preprocessing import LabelEncoder

# Fit LabelEncoder with our list of classes
label_encoder = LabelEncoder()
label_encoder.fit(y_train + y_test + y_val)

# Encode class values as integers
y_train = label_encoder.transform(y_train)
y_test = label_encoder.transform(y_test)
y_val = label_encoder.transform(y_val)
```

And then we need to convert those encoded values to dummy variables (one-hot encoding).

```
# Convert integers to dummy variables (one hot encoded)
from keras.utils import np_utils

y_train = np_utils.to_categorical(y_train)
y_test = np_utils.to_categorical(y_test)
y_val = np_utils.to_categorical(y_val)
```

### Building a Keras model

`[Keras](https://github.com/fchollet/keras/)` is a high-level framework for designing and running neural networks on multiple backends like `[TensorFlow](https://github.com/tensorflow/tensorflow/)`, `[Theano](https://github.com/Theano/Theano)` or `[CNTK](https://github.com/Microsoft/CNTK)`.

![](https://cdn-images-1.medium.com/max/800/1*jv-i8ieZA9AKk5j-avbCWg.png)

We want to create one of the most basic neural networks: the Multilayer Perceptron. This kind of linear stack of layers can easily be made with the `Sequential` model. This model will contain an input layer, an hidden layer, and an output layer.
To overcome overfitting, we use dropout regularization. We set the dropout rate to 20%, meaning that 20% of the randomly selected neurons are ignored during training at each update cycle.

We use [_Rectified Linear Units_](https://en.wikipedia.org/wiki/Rectifier_%28neural_networks%29) (ReLU) activations for the hidden layers as they are the simplest non-linear activation functions available.

For multi-class classification, we may want to convert the units outputs to probabilities, which can be done using the _softmax_ function. We decide to use the _categorical cross-entropy_ loss function.
Finally, we choose [Adam optimizer](https://arxiv.org/abs/1412.6980) as it seems to be well suited to classification tasks.

```
from keras.models import Sequential
from keras.layers import Dense, Dropout, Activation

def build_model(input_dim, hidden_neurons, output_dim):
    """
    Construct, compile and return a Keras model which will be used to fit/predict
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

### Creating a wrapper between Keras API and Scikit-Learn

`[Keras](https://github.com/fchollet/keras/)` provides a wrapper called `[KerasClassifier](https://keras.io/scikit-learn-api/)` which implements the [Scikit-Learn](http://scikit-learn.org/stable/) classifier interface.

All model parameters are defined below. We need to provide a function that returns the structure of a neural network (`build_fn`).
The number of hidden neurons and the batch size are choose quite arbitrarily. We set the number of epochs to 5 because with more iterations the Multilayer Perceptron starts overfitting (even with [Dropout Regularization](https://arxiv.org/abs/1207.0580)).

```
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

### Training our Keras model

Finally, we can train our Multilayer perceptron on train dataset.

```
hist = clf.fit(X_train, y_train)
```

With the callback history provided we can visualize the model _log loss_ and _accuracy_ against time.

```
import matplotlib.pyplot as plt

def plot_model_performance(train_loss, train_acc, train_val_loss, train_val_acc):
    """ Plot model loss and accuracy through epochs. """

    blue= '#34495E'
    green = '#2ECC71'
    orange = '#E23B13'

    # plot model loss
    fig, (ax1, ax2) = plt.subplots(2, figsize=(10, 8))
    ax1.plot(range(1, len(train_loss) + 1), train_loss, blue, linewidth=5, label='training')
    ax1.plot(range(1, len(train_val_loss) + 1), train_val_loss, green, linewidth=5, label='validation')
    ax1.set_xlabel('# epoch')
    ax1.set_ylabel('loss')
    ax1.tick_params('y')
    ax1.legend(loc='upper right', shadow=False)
    ax1.set_title('Model loss through #epochs', color=orange, fontweight='bold')

    # plot model accuracy
    ax2.plot(range(1, len(train_acc) + 1), train_acc, blue, linewidth=5, label='training')
    ax2.plot(range(1, len(train_val_acc) + 1), train_val_acc, green, linewidth=5, label='validation')
    ax2.set_xlabel('# epoch')
    ax2.set_ylabel('accuracy')
    ax2.tick_params('y')
    ax2.legend(loc='lower right', shadow=False)
    ax2.set_title('Model accuracy through #epochs', color=orange, fontweight='bold')
```

Then, display model performance:

```
plot_model_performance(
    train_loss=hist.history.get('loss', []),
    train_acc=hist.history.get('acc', []),
    train_val_loss=hist.history.get('val_loss', []),
    train_val_acc=hist.history.get('val_acc', [])
)
```

![](https://cdn-images-1.medium.com/max/800/1*QplV6zmPAXmFPNMngI8qcQ.png)

Model performance vs. epochs.

After 2 epochs, we see that our model begins to overfit.

### Evaluating our multilayer perceptron

Since our model is trained, we can evaluate it (compute its accuracy):

```
score = clf.score(X_test, y_test)
print(score)

[Out] 0.95816
```

We are pretty close to 96% accuracy on test dataset, that is quite impressive when you look at the basic features we injected in the model.
Keep also in mind that 100% accuracy is not possible even for human annotators. We estimate humans can do Part-of-Speech tagging at about 98% accuracy.

### Visualizing the model

```
from keras.utils import plot_model

plot_model(clf.model, to_file='model.png', show_shapes=True)
```

![](https://cdn-images-1.medium.com/max/800/1*jJLD2eI0saZx_rszhPFrYg.png)

### Save the Keras model

Saving a Keras model is pretty simple as a method is provided natively:

```
clf.model.save('/tmp/keras_mlp.h5')
```

This saves the architecture of the model, the weights as well as the training configuration (loss, optimizer).

#### Ressources

*   `Keras`: The Python Deep Learning library_: [[doc]](https://keras.io/)
*   Adam: A Method for Stochastic Optimization: [[paper]](https://arxiv.org/abs/1412.6980)
*   Improving neural networks by preventing co-adaptation of feature detectors: [[paper]](https://arxiv.org/abs/1207.0580)

In this post, you learn how to define and evaluate accuracy of a neural network for multi-class classification using the Keras library.
The script used to illustrate this post is provided here : [[.py](https://github.com/Cdiscount/IT-Blog/blob/master/scripts/pos_tagging_neural_nets_keras.py)|[.ipynb](https://github.com/Cdiscount/IT-Blog/blob/master/scripts/pos_tagging_neural_nets_keras.ipynb)].


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
