> * 原文地址：[Text Classification using Neural Networks](https://machinelearnings.co/text-classification-using-neural-networks-f5cd7b8765c6#.vvfa01t9r)
* 原文作者：[gk_](https://machinelearnings.co/@gk_)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Text Classification using Neural Networks

Understanding [how chatbots work](https://medium.com/p/how-chat-bots-work-dfff656a35e2) is important. A fundamental piece of machinery inside a chat-bot is the *text classifier*. Let’s look at the inner workings of an artificial neural network (ANN) for text classification.

![](https://cdn-images-1.medium.com/max/800/1*DpMaU1p85ZSgamwYDkzL-A.png)

multi-layer ANN
We’ll use 2 layers of neurons (1 hidden layer) and a “bag of words” approach to organizing our training data. [Text classification comes in 3 flavors](https://medium.com/@gk_/how-chat-bots-work-dfff656a35e2#.3zb2b9g2v): *pattern matching*, *algorithms*, *neural nets*. While the [algorithmic approach](https://medium.com/@gk_/text-classification-using-algorithms-e4d50dcba45#.mho4fx7e5) using Multinomial Naive Bayes is surprisingly effective, it suffers from 3 fundamental flaws:

- **the algorithm produces a *score*** rather than a probability. We want a probability to ignore predictions below some threshold. This is akin to a ‘squelch’ dial on a VHF radio.
- the algorithm ‘learns’ from examples of what *is* in a class, but **not what isn’t**. This learning of patterns of what does *not* belong to a class is often very important.
- classes with disproportionately large training sets can create distorted classification scores, forcing the algorithm to **adjust scores relative to class size**. This is not ideal.

As with its ‘Naive’ counterpart, this classifier isn’t attempting to understand *the meaning of a sentence*, it’s trying to classify it. In fact so called “AI chat-bots” do not understand language, but that’s [another story](https://medium.com/@gk_/the-ai-label-is-bullshit-559b171867ff#.cqbwy3eb7).

#### If you are new to artificial neural networks, here is [how they work](https://medium.com/@gk_/how-neural-networks-work-ff4c7ad371f7).

#### To understand an algorithm approach to classification, see [here](https://chatbotslife.com/text-classification-using-algorithms-e4d50dcba45).

Let’s examine our text classifier one section at a time. We will take the following steps:

1. refer to **libraries** we need
2. provide **training data**
3. **organize** our data
4. **iterate**: code + test the results + tune the model
5. **abstract**

The code is [here,](https://github.com/ugik/notebooks/blob/master/Neural_Network_Classifier.ipynb) we’re using [iPython notebook](https://ipython.org/notebook.html) which is a super productive way of working on data science projects. The code syntax is Python.

We begin by importing our natural language toolkit. We need a way to reliably tokenize sentences into words and a way to stem words.

![](https://ww1.sinaimg.cn/large/006y8lVagy1fcfejony8zj31880do0ua.jpg)

And our training data, 12 sentences belonging to 3 classes (‘intents’).

![](https://ww1.sinaimg.cn/large/006y8lVagy1fcfeo19k6qj316g0p8q89.jpg)

    12 sentences in training data

We can now organize our data structures for *documents*, *classes* and *words*.

![](https://ww3.sinaimg.cn/large/006y8lVagy1fcfeokdewnj316q106n2k.jpg)

    12 documents
    3 classes ['greeting', 'goodbye', 'sandwich']
    26 unique stemmed words ['sandwich', 'hav', 'a', 'how', 'for', 'ar', 'good', 'mak', 'me', 'it', 'day', 'soon', 'nic', 'lat', 'going', 'you', 'today', 'can', 'lunch', 'is', "'s", 'see', 'to', 'talk', 'yo', 'what']

Notice that each word is stemmed and lower-cased. Stemming helps the machine equate words like “have” and “having”. We don’t care about case.

![](https://cdn-images-1.medium.com/max/600/1*eUedufAl7_sI_QWSEIstZg.png)

Our training data is transformed into “bag of words” for each sentence.

![](https://ww1.sinaimg.cn/large/006y8lVagy1fcfepqvg50j319013ydlw.jpg)

    ['how', 'ar', 'you', '?']
    [0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    [1, 0, 0]

The above step is a classic in text classification: each training sentence is reduced to an array of 0’s and 1’s against the array of unique words in the corpus.

    ['how', 'are', 'you', '?']

is stemmed:

    ['how', 'ar', 'you', '?']

then transformed to input: *a 1 for each word in the bag (the ? is ignored)*

    [0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

and output: *the first class*

    [1, 0, 0]

Note that a sentence could be given multiple classes, *or none*.

Make sure the above makes sense and play with the code until you grok it.

#### Your first step in machine learning is to have clean data.

![](https://cdn-images-1.medium.com/max/600/1*CcQPggEbLgej32mVF2lalg.png)

Next we have our core functions for our 2-layer neural network.

If you are new to artificial neural networks, here is [how they work](https://medium.com/@gk_/how-neural-networks-work-ff4c7ad371f7).

We use [numpy](http://www.numpy.org/) because we want our matrix multiplication to be fast.

![](https://cdn-images-1.medium.com/max/600/1*8SJcWjxz8j7YtY6K-DWxKw.png)

We use a sigmoid function to normalize values and its derivative to measure the error rate. Iterating and adjusting until our error rate is acceptably low.

Also below we implement our bag-of-words function, transforming an input sentence into an array of 0’s and 1’s. This matches precisely with our transform for training data, always crucial to get this right.

![](https://ww4.sinaimg.cn/large/006y8lVagy1fcfetz7xn9j312w1leag3.jpg)

And now we code our neural network training function to create synaptic weights. Don’t get too excited, this is mostly matrix multiplication — from middle-school math class.

![](https://ww2.sinaimg.cn/large/006y8lVagy1fcfexdjb5qj312w2ohqg4.jpg)


credit Andrew Trask [https://iamtrask.github.io//2015/07/12/basic-python-network/](https://iamtrask.github.io//2015/07/12/basic-python-network/) （编者注：由于排版的原因导致上图中的代码没有显示完整，如需查看完整代码请访问 [gist.github.com/ugik/70e055894f686bbbe1d052c649799148#file-text_ann_part6](https://gist.github.com/ugik/70e055894f686bbbe1d052c649799148#file-text_ann_part6)）

We are now ready to build our neural network *model*, we will save this as a json structure to represent our synaptic weights.

You should experiment with different ‘alpha’ (gradient descent parameter) and see how it affects the error rate. This parameter helps our error adjustment find the lowest error rate:

synapse_0 += **alpha** * synapse_0_weight_update

![](https://cdn-images-1.medium.com/max/800/1*HZ-YQpdBM4hDbh4Q5FcsMA.png)

We use 20 neurons in our hidden layer, you can adjust this easily. These parameters will vary depending on the dimensions and shape of your training data, tune them down to ~10^-3 as a reasonable error rate.

![](https://ww3.sinaimg.cn/large/006y8lVagy1fcff04a6v1j31540fs40c.jpg)

    Training with 20 neurons, alpha:0.1, dropout:False
    Input matrix: 12x26    Output matrix: 1x3
    delta after 10000 iterations:0.0062613597435
    delta after 20000 iterations:0.00428296074919
    delta after 30000 iterations:0.00343930779307
    delta after 40000 iterations:0.00294648034566
    delta after 50000 iterations:0.00261467859609
    delta after 60000 iterations:0.00237219554105
    delta after 70000 iterations:0.00218521899378
    delta after 80000 iterations:0.00203547284581
    delta after 90000 iterations:0.00191211022401
    delta after 100000 iterations:0.00180823798397
    saved synapses to: synapses.json
    processing time: 6.501226902008057 seconds

The synapse.json file contains all of our synaptic weights, **this is our model.**

![](https://cdn-images-1.medium.com/max/800/1*qYkCgPE3DD26VD-qDwsicA.jpeg)

This **classify()** function is all that’s needed for the classification once synapse weights have been calculated: ~15 lines of code.

The catch: if there’s a change to the training data our model will need to be re-calculated. For a very large dataset this could take a non-insignificant amount of time.

We can now generate the probability of a sentence belonging to one (or more) of our classes. This is super fast because it’s dot-product calculation in our previously defined **think()** function.

![](https://ww2.sinaimg.cn/large/006y8lVagy1fcff0v3wnqj31640zwn31.jpg)

    **sudo make me a sandwich **
     [['sandwich', 0.99917711814437993]]
    **how are you today? **
     [['greeting', 0.99864563257858363]]
    **talk to you tomorrow **
     [['goodbye', 0.95647479275905511]]
    **who are you? **
     [['greeting', 0.8964283843977312]]
    **make me some lunch**
     [['sandwich', 0.95371924052636048]]
    **how was your lunch today? **
     [['greeting', 0.99120883810944971], ['sandwich', 0.31626066870883057]]

Experiment with other sentences and different probabilities, you can then add training data and improve/expand the model. Notice the solid predictions with scant training data.

Some sentences will produce multiple predictions (above a threshold). You will need to establish the right threshold level for your application. Not all text classification scenarios are the same: *some predictive situations require more confidence than others.*

The last classification shows some internal details:

    found in bag: good
    found in bag: day
    sentence: **good day**
     bow: [0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    good day
     [['greeting', 0.99664077655648697]]

Notice the bag-of-words (bow) for the sentence, 2 words matched our corpus. The neural-net also learns from the 0’s, the non-matching words.

A low-probability classification is easily shown by providing a sentence where ‘a’ (common word) is the only match, for example:

    found in bag: a
    sentence: **a burrito! **
     bow: [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    a burrito!
     [['sandwich', 0.61776860634647834]]

Here you have a fundamental piece of machinery for building a chat-bot, capable of handling a large # of classes (‘intents’) and suitable for classes with limited or extensive training data (‘patterns’). Adding one or more responses to an intent is trivial.

#### Enjoy!

![](https://cdn-images-1.medium.com/max/800/1*qfqiMxeF2coed4oBign6IQ.jpeg)
