# Hidden Markov Model and Naive Bayes relationship

This is the first post, of a series of posts, about sequential supervised learning applied to Natural Language Processing. In this first post I will write about the classical algorithm for sequence learning, the Hidden Markov Model (HMM), explain how it's related with the Naive Bayes Model and it's limitations.

You can find the second and third posts here:

-   [Maximum Entropy Markov Models and Logistic Regression](http://www.davidsbatista.net/blog/2017/11/12/Maximum_Entropy_Markov_Model/)

-   [Conditional Random Fields for Sequence Prediction](http://www.davidsbatista.net/blog/2017/11/13/Conditional_Random_Fields/)

## Introduction

The classical problem in Machine Learning is to learn a classifier that can distinguish between two or more classes, i.e., that can accurately predict a class for a new object given training examples of objects already classified.

NLP typical examples are, for instance: classifying an email as spam or not spam, classifying a movie into genres, classifying a news article into topics, etc., however, there is another type of prediction problems which involve structure.

A classical example in NLP is part-of-speech tagging, in this scenario, each xixi describes a word and each yiyi the associated part-of-speech of the word $x_i$ (e.g.: *noun*, *verb*, *adjective*, etc.).

Another example, is named-entity recognition, in which, again, each xixi describes a word and yiyi is a semantic label associated to that word (e.g.: *person*, *location*, *organization*, *event*, etc.).

In both examples the data consist of sequences of $(x,y)$ pairs, and we want to model our learning problem based on that sequence:

$$ p \left( y _ { 1 } , y _ { 2 } , \ldots , y _ { m } | x _ { 1 } , x _ { 2 } , \ldots , x _ { m } \right) $$

in most problems these sequences can have a sequential correlation. That is, nearby xx and yy values are likely to be related to each other. For instance, in English, it's common after the word *to* the have a word whose part-of-speech tag is a *verb*.

Note that there are other machine learning problems which also involve sequences but are clearly different. For instance, in time-series, there is also a sequence, but we want to predict a value yy at point t+1t+1, and we can use all the previous true observed yy to predict. In sequential supervised learning we must predict all yy values in the sequence.

The Hidden Markov Model (HMM) was one the first proposed algorithms to classify sequences. There are other sequence models, but I will start by explaining the HMMM as a sequential extension to the Naive Bayes model.

## Naive Bayes classifier

The Naive Bayes (NB) classifier is a *generative model*, which builds a model of each possible class based on the training examples for each class. Then, in prediction, given an observation, it computes the predictions for all classes and returns the class most likely to have generated the observation. That is, it tries to predict which class generated the new observed example.

In contrast *discriminative models*, like logistic regression, tries to learn which features from the training examples are most useful to discriminate between the different possible classes.

The Naive Bayes classifier returns the class that as the maximum posterior probability given the features:

$$ \hat { y } = \underset { y } { \arg \max } p ( y | \vec { x } ) $$

where $y$ it's a class and $\vec { x }$ is a feature vector associated to an observation.

![](http://www.davidsbatista.net/assets/images/2017-11-11-1024px-Bayes_Theorem_MMB_01.jpg)

Bayes theorem in blue neon.\
(taken from Wikipedia)

The NB classifier is based on the Bayes' theorem. Applying the theorem to the equation above, we get:

$$ p ( y | \vec { x } ) = \frac { p ( y ) \cdot p ( \vec { x } | y ) } { p ( \vec { x } ) } $$

In training, when iterating over all classes, for a given observation, and calculating the probabilities above, the probability of the observation, i.e., the denominator, is always the same, it has no influence, so we can then simplify the formula:

$$ p ( y | \vec { x } ) = p ( y ) \cdot p ( \vec { x } | y ) $$

which, if we decompose the vector of features, is the same as:

$$ p ( y | \vec { x } ) = p ( y ) \cdot p \left( x _ { 1 } , x _ { 2 } , x _ { 3 } , \ldots , x _ { 1 } | y \right) $$

this is hard to compute, because it involves estimating every possible combination of features. We can relaxed this computation by applying the Naives Bayes assumption, which states that:

"each feature is conditional independent of every other feature, given the class"

formerly, p(xi∣y,xj)=p(xi∣y)p(xi∣y,xj)=p(xi∣y) with i≠ji≠j. The probabilities p(xi∣y)p(xi∣y) are independent given the class yyand hence can be 'naively' multiplied:

p(x1,x2,...,x1∣y)=p(x1∣y)⋅p(x2∣y),⋯,p(xm∣y)p(x1,x2,...,x1∣y)=p(x1∣y)⋅p(x2∣y),⋯,p(xm∣y)

plugging this into our equation:

$$ p \left( x _ { 1 } , x _ { 2 } , \ldots , x _ { 1 } | y \right) = p \left( x _ { 1 } | y \right) \cdot p \left( x _ { 2 } | y \right) , \cdots , p \left( x _ { m } | y \right) $$

we get the final Naive Bayes model, which as consequence of the assumption above, doesn't capture dependencies between each input variables in $\vec { x }$.

### Trainning

Training in Naive Bayes is mainly done by counting features and classes. Note that the procedure described below needs to be done for every class yiyi.

To calculate the prior, we simple count how many samples in the training data fall into each class yiyi divided by the total number of samples:

$$ p \left( y _ { i } \right) = \frac { N _ { y _ { i } } } { N } $$

To calculate the likelihood estimate, we count the number of times feature wiwi appears among all features in all samples of class yiyi:

$$ p \left( x _ { i } | y _ { i } \right) = \frac { \operatorname { count } \left( x _ { i } , y _ { i } \right) } { \sum _ { x _ { i } \in X } \operatorname { count } \left( x _ { i } , y _ { i } \right) } $$

This will result in a big table of occurrences of features for all classes in the training data.

### Classification

When given a new sample to classify, and assuming that it contains features x1,x3,x5x1,x3,x5, we need to compute, for each class yiyi:

$$ p \left( y _ { i } | x _ { 1 } , x _ { 3 } , x _ { 5 } \right) $$

This is decomposed into:

$$ p \left( y _ { i } | x _ { 1 } , x _ { 3 } , x _ { 5 } \right) = p \left( y _ { i } \right) \cdot p \left( y _ { i } | x _ { 1 } \right) \cdot p \left( y _ { i } | x _ { 3 } \right) \cdot p \left( y _ { i } | x _ { 5 } \right) $$

Again, this is calculated for each class yiyi, and we assign to the new observed sample the class that has the highest score.

* * * * *

## From Naive Bayes to Hidden Markov Models

The model presented before predicts a class for a set of features associated to an observation. To predict a class sequence y=(y1,...,yn)y=(y1,...,yn) for sequence of observation x=(x1,...,yn)x=(x1,...,yn), a simple sequence model can be formulated as a product over single Naïve Bayes models:

$$ p ( \vec { y } | \vec { x } ) = \prod _ { i = 1 } ^ { n } p \left( y _ { i } \right) \cdot p \left( x _ { i } | y _ { i } \right) $$

Two aspects about this model:

-   there is only one feature at each sequence position, namely the identity of the respective observation due the assumption that each feature is generated independently, conditioned on the class yiyi.

-   it doesn't capture interactions between the observable variables xixi.

It is however reasonable to assume that there are dependencies at consecutive sequence positions yiyi, remember the example above about the part-of-speech tags ?

This is where the First-order Hidden Markov Model appears, introducing the Markov Assumption:

"the probability of a particular state is dependent only on the previous state"

$$ p ( \vec { y } | \vec { x } ) = \prod _ { i = 1 } ^ { n } p \left( y _ { i } | y _ { i - 1 } \right) \cdot p \left( x _ { i } | y _ { i } \right) $$

which written in it's more general form:

$$ p ( \vec { x } ) = \sum _ { y \in Y } \prod _ { i = 1 } ^ { n } p \left( y _ { i } | y _ { i - 1 } \right) \cdot p \left( x _ { i } | y _ { i } \right) $$

where Y represents the set of all possible label sequences y⃗ y→.

* * * * *

## Hidden Markov Model

A Hidden Markov Model (HMM) is a sequence classifier. As other machine learning algorithms it can be trained, i.e.: given labeled sequences of observations, and then using the learned parameters to assign a sequence of labels given a sequence of observations. Let's define an HMM framework containing the following components:

-   states (e.g., labels): $ T = t _ { 1 } , t _ { 2 } , \ldots , t _ { N } $
-   observations (e.g., words) : $ W = w _ { 1 } , w _ { 2 } , \ldots , w _ { N } $
-   two special states: $t _ { \text {start} }$ and $t _ { \text {end} }$ which are not associated with the observation

and probabilities relating states and observations:

-   initial probability: an initial probability distribution over states
-   final probability: a final probability distribution over states
-   transition probability: a matrix AA with the probabilities from going from one state to another
-   emission probability: a matrix BB with the probabilities of an observation being generated from a state

A First-order Hidden Markov Model has the following assumptions:

-   Markov Assumption: the probability of a particular state is dependent only on the previous state. Formally: $P \left( t _ { i } | t _ { 1 } , \ldots , t _ { i - 1 } \right) = P \left( t _ { i } | t _ { i - 1 } \right)$

-   Output Independence: the probability of an output observation wiwi depends only on the state that produced the observation titi and not on any other states or any other observations. Formally: $P \left( w _ { i } | t _ { 1 } \ldots q _ { i } , \ldots , q _ { T } , o _ { 1 } , \ldots , o _ { i } , \ldots , o _ { T } \right) = P \left( o _ { i } | q _ { i } \right)$

Notice how the output assumption is closely related with the Naive Bayes classifier presented before. The figure below makes it easier to understand the dependencies and the relationship with the Naive Bayes classifier:

![](http://www.davidsbatista.net/assets/images/2017-11-11-HMM.png)

Transitions and Emissions probabilities in the HMM.\
(image adapted from CS6501 of the University of Virginia)

We can now define two problems which can be solved by an HMM, the first is learning the parameters associated to a given observation sequence, that is training. For instance given words of a sentence and the associated part-of-speech tags, one can learn the latent structure.

The other one is applying a trained HMM to an observation sequence, for instance, having a sentence, predicting each word's part-of-speech tag, using the latent structure from the training data learned by the HMM.

* * * * *

#### Learning: estimating transition and emission matrices

Given an observation sequence WW and the associated states TT how can we learn the HMM parameters, that is, the matrices AA and BB ?

In a HHM supervised scenario this is done by applying the Maximum Likelihood Estimation principle, which will compute the matrices.

This is achieved by counting how many times each event occurs in the corpus and normalizing the counts to form proper probability distributions. We need to count 4 quantities which represent the counts of each event in the corpus:

Initial counts: $C _ { \mathrm { init } } \left( t _ { k } \right) = \sum _ { m = 1 } ^ { M } 1 \left( t _ { 1 } ^ { m } = t _ { k } \right)$
(how often does state $t _ { k }$ is the initial state)

Transition counts: $C _ { \text { trans } } \left( t _ { k } , t _ { l } \right) = \sum _ { m = 1 } ^ { M } \sum _ { m = 2 } ^ { N } 1 \left( t _ { i } ^ { m } = t _ { k } \wedge t _ { i - 1 } ^ { m } = t _ { l } \right)$
(how often does state $t _ { k }$ transits to another state tltl)

Final Counts: $C _ { \text { final } } \left( t _ { k } \right) = \sum _ { m = 1 } ^ { M } 1 \left( t _ { N } ^ { m } = t _ { k } \right)$
(how often does state $t _ { k }$ is the final state)

Emissions counts: $C _ { \mathrm { emiss } } \left( w _ { j } , t _ { k } \right) = \sum _ { m = 1 } ^ { M } \sum _ { i = 1 } ^ { N } 1 \left( x _ { i } ^ { m } = w _ { j } \wedge t _ { i } ^ { m } = t _ { k } \right)$
(how often does state $t _ { k }$ is associated with the observation/word wjwj)

where, MM is the number of training examples and NN the length of the sequence, 1 is an indicator function that has the value 1 when the particular event happens, and 0 otherwise. The equations scan the training corpus and count how often each event occurs.

All these 4 counts are then normalised in order to have proper probability distributions:

$$
P _ { \mathrm { init } \left( c _ { t } | \mathrm { start } \right) } = \frac { C _ { \mathrm { init } \left( t _ { k } \right) } } { \sum _ { l = 1 } ^ { K } C _ { \mathrm { init } \left( t _ { l } \right) } }
$$

$$
P _ { \text { final}( \text{stop}| c_l )}  = \frac { C _ { \text { final } \left( c _ { l } \right) } } { \sum _ { k = 1 } ^ { K } C _ { \text { trans } \left( C _ { k } , C _ { l } \right) } + C _ { \text { final } ( C _ { l } ) } }
$$

$$
P _ { \mathrm { trans } \left( c _ { k } | c _ { l } \right) } = \frac { C _ { \mathrm { trans } \left( c _ { k } , c _ { l } \right) } } { \sum _ { p = 1 } ^ { K } C _ { \mathrm { trans } \left( C _ { p } , C _ { l } \right) } + C _ { \mathrm { final } \left( C _ { l } \right) } }
$$

Pemiss(wj|ck)=Cemiss(wj,ck)∑q=1JCemiss(wq,Ck)Pemiss(wj|ck)=Cemiss(wj,ck)∑q=1JCemiss(wq,Ck)

These equations will produce the transition probability matrix AA, with the probabilities from going from one label to another and the emission probability matrix BB with the probabilities of an observation being generated from a state.

##### Laplace smoothing

How will the model handle words not seen during training ?

In the presence of an unseen word/observation, P(Wi∣Ti)=0P(Wi∣Ti)=0 and has a consequence incorrect decisions will be made during the predicting process.

There is a technique to handle this situations called *Laplace smoothing* or *additive smoothing*. The idea is that every state will always have a small emission probability of producing an unseen word, for instance, denoted by UNK. Every time the HMM encounters an unknown word it will use the value P(UNK∣Ti)P(UNK∣Ti) as the emission probability.

* * * * *

#### Decoding: finding the hidden state sequence for an observation

Given a trained HMM i.e., the transition matrixes AA and BB, and a new observation sequence W=w1,w2,...,wNW=w1,w2,...,wN we want to find the sequence of states T=t1,t2,...,tNT=t1,t2,...,tN that best explains it.

This is can be achieved by using the Viterbi algorithm, that finds the best state assignment to the sequence T1...TNT1...TN as a whole. There is another algorithm, Posterior Decoding which consists in picking the highest state posterior for each position ii in the sequence independently.

#### Viterbi

It's a dynamic programming algorithm for computing:

δi(T)=maxt0,...,ti-1,t  P(t0,...,ti-1,t,w1,...,wi-1)δi(T)=maxt0,...,ti-1,tP(t0,...,ti-1,t,w1,...,wi-1)

the score of a best path up to position ii ending in state tt. The Viterbi algorithm tackles the equation above by using the Markov assumption and defining two functions:

δi(t)=maxti-1  P(t∣ti-1)⋅P(wi-1∣ti-1)⋅δi(ti-1)δi(t)=maxti-1P(t∣ti-1)⋅P(wi-1∣ti-1)⋅δi(ti-1)

the most likely previous state for each state (store a back-trace):

Ψi(t)=argmaxti-1  P(t∣ti-1)⋅P(w∣ti-1)⋅δi(ti-1)Ψi(t)=arg⁡maxti-1P(t∣ti-1)⋅P(w∣ti-1)⋅δi(ti-1)

The Viterbi algorithm uses a representation of the HMM called a trellis, which unfolds all possible states for each position and it makes explicit the independence assumption: each position only depends on the previous position.

![](http://www.davidsbatista.net/assets/images/2017-11-11-Viterbi_I.png)

An unfilled trellis representation of an HMM.

![](http://www.davidsbatista.net/assets/images/2017-11-11-Viterbi_Emission.png) ![](http://www.davidsbatista.net/assets/images/2017-11-11-Viterbi_State_Transitions.png)

Word Emission and State Transitions probabilities matrices.

Using the Viterbi algorithm and the emission and transition probabilities matrices, one can fill in the trellis scores and effectively find the Viterby path.

![](http://www.davidsbatista.net/assets/images/2017-11-11-Viterbi_II.png)

An filled trellis representation of an HMM.

The figures above were taken from a Viterbi algorithm example by [Roger Levy](http://idiom.ucsd.edu/~rlevy/) for the [Linguistics/CSE 256 class](http://idiom.ucsd.edu/~rlevy/teaching/winter2009/ligncse256/). You can find the full example [here](http://www.davidsbatista.net/assets/documents/posts/2017-11-11-hmm_viterbi_mini_example.pdf).

* * * * *

### HMM Important Observations

-   The main idea of this post was to see the connection between the Naive Bayes classifier and the HMM as a sequence classifier

-   If we make the hidden state of HMM fixed, we will have a Naive Bayes model.

-   There is only one feature at each word/observation in the sequence, namely the identity i.e., the value of the respective observation.

-   Each state depends only on its immediate predecessor, that is, each state titi is independent of all its ancestors t1,t2,...,ti-2t1,t2,...,ti-2 given its previous state ti-1ti-1.

-   Each observation variable wiwi depends only on the current state titi.

## Software Packages

-   [seqlearn](https://github.com/larsmans/seqlearn): a sequence classification library for Python which includes an implementation of Hidden Markov Models, it follows the sklearn API.

-   [NLTK HMM](http://www.nltk.org/_modules/nltk/tag/hmm.html): NLTK also contains a module which implements a Hidden Markov Models framework.

-   [lxmls-toolkit](https://github.com/LxMLS/lxmls-toolkit): the Natural Language Processing Toolkit used in the Lisbon Machine Learning Summer School also contains an implementation of Hidden Markov Models.

## References

-   [Machine Learning for Sequential Data: A Review by Thomas G. Dietterich](http://web.engr.oregonstate.edu/~tgd/publications/mlsd-ssspr.pdf)

-   [Chapter 6: "Naive Bayes and Sentiment Classification" in Speech and Language Processing. Daniel Jurafsky & James H. Martin. Draft of August 7, 2017.](https://web.stanford.edu/~jurafsky/slp3/6.pdf)

-   [A Tutorial on Hidden Markov Models and Selected Applications in Speech Recognition](http://www.ece.ucsb.edu/Faculty/Rabiner/ece259/Reprints/tutorial%20on%20hmm%20and%20applications.pdf)

-   [LxMLS - Lab Guide July 16, 2017 - Day 2 "Sequence Models"](http://lxmls.it.pt/2017/LxMLS2017.pdf)

-   [Chapter 9: "Hidden Markov Models" in Speech and Language Processing. Daniel Jurafsky & James H. Martin. Draft of August 7, 2017.](https://web.stanford.edu/~jurafsky/slp3/9.pdf)

-   [Hidden Markov Model inference with the Viterbi algorithm: a mini-example](http://www.davidsbatista.net/assets/documents/posts/2017-11-11-hmm_viterbi_mini_example.pdf)

## Extra

There is also a very good lecture, given by [Noah Smith](https://homes.cs.washington.edu/~nasmith/) at [LxMLS2016](http://lxmls.it.pt/2016/) about Sequence Models, mainly focusing on Hidden Markov Models and it's applications from sequence learning to language modeling.

[Click here to watch video!](https://www.youtube.com/watch?v=8vGSAwR716k)
