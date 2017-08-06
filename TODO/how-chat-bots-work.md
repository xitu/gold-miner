
  > * 原文地址：[Soul of the Machine: How Chatbots Work](https://medium.com/@gk_/how-chat-bots-work-dfff656a35e2)
  > * 原文作者：[George Kassabgi](https://medium.com/@gk_)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/how-chat-bots-work.md](https://github.com/xitu/gold-miner/blob/master/TODO/how-chat-bots-work.md)
  > * 译者：
  > * 校对者：

  # Soul of the Machine: How Chatbots Work

  ![](https://cdn-images-1.medium.com/max/2000/1*HRgcOpW8vSPqM-GxkoHhWw.jpeg)

Since the early industrial age, we’ve been fascinated by self-operating devices. They represent the humanization of technology.

Today, it is software that that’s becoming more human — most obviously “chatbots.”

But how do these machines work? First, wind back time and explore an earlier — yet similar — technology.

### How a music box works

![](https://cdn-images-1.medium.com/max/1600/1*PveiqDdv2Zsog9ryJTUz-Q.png)

An early example of automation — the mechanical music box.
A set of tuned metallic teeth aligned on a comb-like structure are positioned next to a cylinder with pins. Each pin corresponds to a note at a specific interval.

As the mechanism turns, it creates a tune by striking one or multiple pins at the predefined time. To play a different song, you can swap in a different cylindrical drum (assuming the set of unique notes is equivalent).

In addition to striking a note, the movement of the drum can cause other automation, such as a moving figurine. Either way, the fundamental machinery of the music box remains the same.

### How a chatbot works

Text input is processed by a software function called a “classifier”, this classification associates an input sentence with an “intent” (a conversational intent) which produces a response.

![](https://cdn-images-1.medium.com/max/1600/1*aSGRi9NOM3J5vT2fMlo5ig.png)

[a chatbot example (http://lauragelston.ghost.io/speakeasy/](http://lauragelston.ghost.io/speakeasy/))
Think of a classifier as a way of categorizing a piece of data (a sentence) into one of several categories (an intent). The input “how are you?” is classified as an intent, which is associated with a response such as “I’m good” or (better) “I am well.”

We learned about classification early in elementary science: a chimpanzee is in the class “mammals”, a blue jay is in the class “birds”, the earth is in the class “planets” and so on. Simple.

Generally speaking, there are 3 different kinds of text classifiers. Think of these as software machinery, built for a specific purpose, like the drum of a music box.

### **Chatbot text classification approaches**

- **Pattern matchers**
- **Algorithms**
- **Neural networks**

Regardless of which type of classifier is used, the end-result is a response. Like a music box, there can be additional “movements” associated with the machinery. A response can make use of external information (like weather, a sports score, a web lookup, etc.) but this isn’t specific to chatbots, it’s just additional code. A response may reference specific “parts of speech” in the sentence, for example: a proper noun. Also the response (for an intent) can use conditional logic to provide different responses depending on the “state” of the conversation, this can be a random selection (to insert some ‘natural’ feeling).

### Pattern matchers

Early chatbots used pattern matching to classify text and produce a response. This is often referred to as “brute force” as the author of the system needs to describe every pattern for which there is a response.

A standard structure for these patterns is “AIML” (artificial intelligence markup language). Its use of the term “artificial intelligence” is quite an embellishment, but [that’s another story](https://medium.com/@gk_/the-ai-label-is-bullshit-559b171867ff).

A simple pattern matching definition:

```
<aiml version = "1.0.1" encoding = "UTF-8"?>
   <category>
      <pattern> WHO IS ALBERT EINSTEIN </pattern>
      <template>Albert Einstein was a German physicist.</template>
   </category>

   <category>
      <pattern> WHO IS Isaac NEWTON </pattern>
      <template>Isaac Newton was a English physicist and mathematician.</template>
   </category>

   <category>
      <pattern>DO YOU KNOW WHO * IS</pattern>
      <template>
         <srai>WHO IS <star/></srai>
      </template>
   </category>
</aiml>
```

The machine then produces:

    Human: Do you know who Albert Einstein is
    Robot: Albert Einstein was a German physicist.

It knows who a physicist is only because his or her name has an associated pattern. Likewise it responds to anything solely because of an authored pattern. Given hundreds or thousands of patterns you might see a chatbot “persona” emerge.

In 2000 a chatbot built using this approach was [in the news](http://mashable.com/2014/06/12/eugene-goostman-turing-test/) for passing the “Turing test”, built by John Denning and colleagues. It was built to emulate the replies of a 13 year old boy from Ukraine (broken English and all). I met with John in 2015 and he made no false pretenses about the internal workings of this automaton. It may have been “brute force” but it proved a point: parts of a conversation can be made to appear “natural” using a sufficiently large definition of patterns. It proved Alan Turing’s assertion, that this question of a machine fooling humans was “meaningless”.

An example of this approach used in building chatbots is [PandoraBots,](http://www.pandorabots.com/) they claim over 285k chatbots have been constructed using their framework.

### Algorithms

The brute-force mechanism is daunting: for each unique input a pattern must be available to specify a response. This creates a hierarchical structure of patterns, the inspiration for the idiom “rats nest”.

To reduce the classifier to a more manageable machine, we can approach the work *algorithmically*, that is to say: we can build an equation for it. This is what computer scientists call a “reductionist” approach: the problem is *reduced* so that the solution is simplified.

A classic text classification algorithm is called “Multinomial Naive Bayes”, [taught in courses at Stanford](http://nlp.stanford.edu/IR-book/pdf/13bayes.pdf) and elsewhere. Here is the equation:

![](https://cdn-images-1.medium.com/max/1600/1*sj0TmP9mH6GEE9z3XAJYYA.png)

This is a lot less complicated than it appears. Given a set of sentences, each belonging to a class, and a new input sentence, we can count the occurrence of each word in each class, account for its commonality and assign each class a *score*. Factoring for commonality is important: matching the word “it” is considerably less meaningful than a match for the word “cheese”. The class with the highest score is the one most likely to belong to the input sentence. This is a slight oversimplification as words need to be reduced to their [stems](https://en.wikipedia.org/wiki/Stemming), but you get the basic idea.

A sample training set:

    class: weather
        "is it nice outside?"
        "how is it outside?"
        "is the weather nice?"

    class: greeting
        "how are you?"
        "hello there"
        "how is it going?"

Let’s classify a few sample input sentences:

    input: "Hi there"
     term: "hi" (**no matches)**
     term: "there" **(class: greeting)**
     classification: **greeting **(score=1)

    input: "What’s it like outside?"
     term: "it" **(class: weather (2), greeting)**
     term: "outside **(class: weather (2) )**
     classification: **weather **(score=4)

Notice that the classification for “What’s it like outside” found a term in another class but the term similarities to the desired class produced a higher score. By using an equation we are looking for word matches given some sample sentences for each class, and we avoid having to identify every pattern.

The classification score produced identifies the class with the highest term matches (accounting for commonality of words) but this has limitations. A score is not the same as a probability, a score tells us which intent is most like the sentence but not the likelihood of it being a match. Thus it is difficult to apply a threshold for which classification scores to accept or not. Having the highest score from this type of algorithm only provides a relative basis, it may still be an inherently weak classification. Also the algorithm doesn’t account for what a sentence *is not*, it only counts what it *is* like. You might say this approach doesn’t consider what makes a sentence *not* a given class.

Many chatbot frameworks use [algorithms such as this to classify intent](https://medium.com/@gk_/text-classification-using-algorithms-e4d50dcba45#.ewnhttxa4). Most of what’s taking place is word counting against training datasets, it’s “naive” but surprisingly effective.

### Neural Networks

Artificial neural networks, invented in the 1940’s, are a way of calculating an output from an input (a classification) using weighted connections (“synapses”) that are calculated from repeated iterations through training data. Each pass through the training data alters the weights such that the neural network produces the output with greater “accuracy” (lower error rate).

![](https://cdn-images-1.medium.com/max/1600/1*HULATc7wX7CtzybTIxgBvQ.png)

a neural network structure: nodes (circles) and synapses (lines)
There’s not much new about these structures, except today’s software is using much faster processors and can work with a lot more memory. The combination of working memory and speed is crucial when you’re doing hundreds of thousands of matrix multiplications (the neural network’s essential math operation).

As in the prior method, each class is given with some number of example sentences. Once again each sentence is broken down by word (stemmed) and each word becomes an input for the neural network. The synaptic weights are then calculated by iterating through the training data thousands of times, each time adjusting the weights slightly to greater accuracy. By recalculating back across multiple layers (“back-propagation”) the weights of all synapses are calibrated while the results are compared to the training data output. These weights are like a ‘strength’ measure, in a neuron the synaptic weight is what causes something to be more memorable than not. You remember a thing more because you’ve seen it more times: each time the ‘weight’ increases slightly.

At some point the adjustment reaches a point of diminishing returns, this is called “over-fitting” and going beyond this is counter-productive.

![](https://cdn-images-1.medium.com/max/1600/1*QckgibgJ74BhMaqinqwSDw.png)

The trained neural network is less code than an comparable algorithm but it requires a potentially large matrix of “weights”. In a relatively small sample, where the training sentences have 150 unique words and 30 classes this would be a matrix of 150x30. Imagine multiplying a matrix of this size 100,000 times to establish a sufficiently low error rate. This is where processing speed comes in.

If the neural network sounds magnificently sophisticated, relax, it boils down to [matrix multiplication](https://www.khanacademy.org/math/precalculus/precalc-matrices/multiplying-matrices-by-matrices/v/matrix-multiplication-intro) and a [formula for reducing values](https://en.wikipedia.org/wiki/Sigmoid_function) between -1 and 1 or some other minimal range. A middle-school math student could learn this in a few hours. The hard work is achieving clean training data.

Just as there are variations in pattern matching code and in algorithms, there are variations in neural networks, some more complex than others. The basic machinery is the same. The essential work is that of classification.

![](https://cdn-images-1.medium.com/max/1600/1*_ldEr2WurmqNq6Pgp5J24w.jpeg)

The mechanical music box knows nothing about music theory, likewise **chatbot machinery knows nothing about language**.

Chatbot machinery is looking for patterns in collections of terms, each term is reduced to a token. In this machine* words have no meaning* except for their patterned existence within training data. The label “artificial intelligence” applied to such machinery [is mostly BS](https://medium.com/@gk_/the-ai-label-is-bullshit-559b171867ff#.3tlhftemt).

The chatbot is like the mechanical music box: it’s *a machine that produces output according to patterns*. Rather than using pins and cylindrical drums the chatbot uses software code and mathematics.


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  