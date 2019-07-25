> * 原文地址：[An Introduction to Recurrent Neural Networks for Beginners](https://victorzhou.com/blog/intro-to-rnns/)
> * 原文作者：[Victor Zhou](https://victorzhou.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/intro-to-rnns.md](https://github.com/xitu/gold-miner/blob/master/TODO1/intro-to-rnns.md)
> * 译者：
> * 校对者：

# An Introduction to Recurrent Neural Networks for Beginners

## A simple walkthrough of what RNNs are, how they work, and how to build one from scratch in Python.

Recurrent Neural Networks (RNNs) are a kind of neural network that specialize in processing **sequences**. They’re often used in [Natural Language Processing](/tag/natural-language-processing) (NLP) tasks because of their effectiveness in handling text. In this post, we’ll **explore what RNNs are, understand how they work, and build a real one from scratch** (using only [numpy](https://www.numpy.org/)) in Python.

**This post assumes a basic knowledge of neural networks**. My [introduction to Neural Networks](/blog/intro-to-neural-networks/) covers everything you’ll need to know, so I’d recommend reading that first.

Let’s get into it!

## 1. The Why

One issue with vanilla neural nets (and also [CNNs](https://victorzhou.com/blog/intro-to-cnns-part-1/)) is that they only work with pre-determined sizes: they take **fixed-size inputs** and produce **fixed-size outputs**. RNNs are useful because they let us have **variable-length sequences** as both inputs and outputs. Here are a few examples of what RNNs can look like:

![rnns](https://victorzhou.com/static/2a37bd4e9b12bcc19e045eaf22fea4e5/67d4f/rnns.jpg "rnns")

Inputs are red, the RNN itself is green, and outputs are blue. Source: [Andrej Karpathy](http://karpathy.github.io/2015/05/21/rnn-effectiveness/)

This ability to process sequences makes RNNs very useful. For example:

* **Machine Translation** (e.g. Google Translate) is done with “many to many” RNNs. The original text sequence is fed into an RNN, which then produces translated text as output.
* **Sentiment Analysis** (e.g. **Is this a positive or negative review?**) is often done with “many to one” RNNs. The text to be analyzed is fed into an RNN, which then produces a single output classification (e.g. **This is a positive review**).

Later in this post, we’ll build a “many to one” RNN from scratch to perform basic Sentiment Analysis.

## [](#2-the-how)2\. The How

Let’s consider a “many to many” RNN with inputs x0,x1,…xnx\_0, x\_1, \\ldots x_nx0​,x1​,…xn​ that wants to produce outputs y0,y1,…yny\_0, y\_1, \\ldots y_ny0​,y1​,…yn​. These xix_ixi​ and yiy_iyi​ are **vectors** and can have arbitrary dimensions.

RNNs work by iteratively updating a hidden state hhh, which is a vector that can also have arbitrary dimension. At any given step ttt,

1. The next hidden state hth_tht is calculated using the previous hidden state ht−1h_{t-1}ht−1​ and the next input xtx_txt​.
2. The next output yty_tyt is calculated using hth_tht​.

![](/media/rnn-post/many-to-many.svg)

A many to many RNN

Here’s what makes a RNN **recurrent**: **it uses the same weights for each step**. More specifically, a typical vanilla RNN uses only 3 sets of weights to perform its calculations:

.red-arrow { color: #c8281eff; } .blue-arrow { color: #2850c8ff; } .green-arrow { color: #466e32ff; }

* WxhW_{xh}Wxh​, used for all xtx_txt​ → hth_tht​ links.
* WhhW_{hh}Whh​, used for all ht−1h_{t-1}ht−1​ → hth_tht​ links.
* WhyW_{hy}Why​, used for all hth_tht​ → yty_tyt​ links.

We’ll also use two biases for our RNN:

* bhb_hbh​, added when calculating hth_tht​.
* byb_yby​, added when calculating yty_tyt​.

We’ll represent the weights as **matrices** and the biases as **vectors**. These 3 weights and 2 biases make up the entire RNN!

**Here are the equations that put everything together:**

ht=tanh⁡(Wxhxt+Whhht−1+bh)h\_t = \\tanh (W\_{xh} x\_t + W\_{hh} h_{t-1} + b_h)ht​=tanh(Wxh​xt​+Whh​ht−1​+bh​) yt=Whyht+byy\_t = W\_{hy} h\_t + b\_yyt​=Why​ht​+by​

Don't skim over these equations. Stop and stare at this for a minute. Also, remember that the weights are **matrices** and the other variables are **vectors**.

All the weights are applied using matrix multiplication, and the biases are added to the resulting products. We then use [tanh](https://en.wikipedia.org/wiki/Hyperbolic_function) as an activation function for the first equation (but other activations like [sigmoid](https://en.wikipedia.org/wiki/Sigmoid_function) can also be used).

> No idea what an activation function is? Read my [introduction to Neural Networks](/blog/intro-to-neural-networks/) like I mentioned. Seriously.

## [](#3-the-problem)3\. The Problem

Let’s get our hands dirty! We’ll implement an RNN from scratch to perform a simple Sentiment Analysis task: **determining whether a given text string is positive or negative.**

Here are a few samples from the small [dataset](https://github.com/vzhou842/rnn-from-scratch/blob/master/data.py) I put together for this post:

Text

Positive?

i am good

✓

i am bad

❌

this is very good

✓

this is not bad

✓

i am bad not good

❌

i am not at all happy

❌

this was good earlier

✓

i am not at all bad or sad right now

✓

## [](#4-the-plan)4\. The Plan

Since this is a classification problem, we’ll use a “many to one” RNN. This is similar to the “many to many” RNN we discussed earlier, but it only uses the final hidden state to produce the one output yyy:

![](/media/rnn-post/many-to-one.svg)

A many to one RNN

Each xix_ixi​ will be a vector representing a word from the text. The output yyy will be a vector containing two numbers, one representing positive and the other negative. We’ll apply [Softmax](/blog/softmax/) to turn those values into probabilities and ultimately decide between positive / negative.

Let’s start building our RNN!

## [](#5-the-pre-processing)5\. The Pre-Processing

The [dataset](https://github.com/vzhou842/rnn-from-scratch/blob/master/data.py) I mentioned earlier consists of two Python dictionaries:

##### data.py

```python
train_data = {
  'good': True,
  'bad': False,
  # ... more data
}

test_data = {
  'this is happy': True,
  'i am good': True,
  # ... more data
}
```

True = Positive, False = Negative

We’ll have to do some pre-processing to get the data into a usable format. To start, we’ll construct a **vocabulary** of all words that exist in our data:

##### main.py

```python
from data import train_data, test_data

# Create the vocabulary.
vocab = list(set([w for text in train_data.keys() for w in text.split(' ')]))
vocab_size = len(vocab)
print('%d unique words found' % vocab_size) # 18 unique words found
```

`vocab` now holds a list of all words that appear in at least one training text. Next, we’ll **assign an integer index** to represent each word in our vocab.

##### main.py

```python
# Assign indices to each word.
word_to_idx = { w: i for i, w in enumerate(vocab) }
idx_to_word = { i: w for i, w in enumerate(vocab) }
print(word_to_idx['good']) # 16 (this may change)
print(idx_to_word[0]) # sad (this may change)
```

We can now represent any given word with its corresponding integer index! This is necessary because RNNs can’t understand words - we have to give them numbers.

Finally, recall that each input xix_ixi​ to our RNN is a **vector**. We’ll use **[one-hot](https://en.wikipedia.org/wiki/One-hot) vectors**, which contain all zeros except for a single one. The “one” in each one-hot vector will be **at the word’s corresponding integer index.**

Since we have 18 unique words in our vocabulary, each xix_ixi​ will be a 18-dimensional one-hot vector.

##### main.py

```python
import numpy as np

def createInputs(text):
  '''
  Returns an array of one-hot vectors representing the words
  in the input text string.
  - text is a string
  - Each one-hot vector has shape (vocab_size, 1)
  '''
  inputs = []
  for w in text.split(' '):
    v = np.zeros((vocab_size, 1))
    v[word_to_idx[w]] = 1
    inputs.append(v)
  return inputs
```

We’ll use `createInputs()` later to create vector inputs to pass in to our RNN.

## [](#6-the-forward-phase)6\. The Forward Phase

It’s time to start implementing our RNN! We’ll start by initializing the 3 weights and 2 biases our RNN needs:

##### rnn.py

```python
import numpy as np
from numpy.random import randn

class RNN:
  # A Vanilla Recurrent Neural Network.

  def __init__(self, input_size, output_size, hidden_size=64):
    # Weights
    self.Whh = randn(hidden_size, hidden_size) / 1000
    self.Wxh = randn(hidden_size, input_size) / 1000
    self.Why = randn(output_size, hidden_size) / 1000

    # Biases
    self.bh = np.zeros((hidden_size, 1))
    self.by = np.zeros((output_size, 1))
```

Note: We're dividing by 1000 to reduce the initial variance of our weights. This is not the best way to initialize weights, but it's simple and works for this post.

We use [np.random.randn()](https://docs.scipy.org/doc/numpy/reference/generated/numpy.random.randn.html) to initialize our weights from the standard normal distribution.

Next, let’s implement our RNN’s forward pass. Remember these two equations we saw earlier?

ht=tanh⁡(Wxhxt+Whhht−1+bh)h\_t = \\tanh (W\_{xh} x\_t + W\_{hh} h_{t-1} + b_h)ht​=tanh(Wxh​xt​+Whh​ht−1​+bh​) yt=Whyht+byy\_t = W\_{hy} h\_t + b\_yyt​=Why​ht​+by​

Here are those same equations put into code:

##### rnn.py

```python
class RNN:
  # ...

  def forward(self, inputs):
    '''
    Perform a forward pass of the RNN using the given inputs.
    Returns the final output and hidden state.
    - inputs is an array of one hot vectors with shape (input_size, 1).
    '''
    h = np.zeros((self.Whh.shape[0], 1))

    # Perform each step of the RNN
    for i, x in enumerate(inputs):
      h = np.tanh(self.Wxh @ x + self.Whh @ h + self.bh)

    # Compute the output
    y = self.Why @ h + self.by

    return y, h
```

Pretty simple, right? Note that we initialized hhh to the zero vector for the first step, since there’s no previous hhh we can use at that point.

Let’s try it out:

##### main.py

```python
# ...

def softmax(xs):
  # Applies the Softmax Function to the input array.
  return np.exp(xs) / sum(np.exp(xs))

# Initialize our RNN!
rnn = RNN(vocab_size, 2)

inputs = createInputs('i am very good')
out, h = rnn.forward(inputs)
probs = softmax(out)
print(out) # [[0.50000095], [0.49999905]]
```

> Need a refresher on Softmax? Read my [quick explanation of Softmax](/blog/softmax/).

Our RNN works, but it’s not very useful yet. Let’s change that…

## [](#7-the-backward-phase)7\. The Backward Phase

In order to train our RNN, we first need a loss function. We’ll use **cross-entropy loss**, which is often paired with Softmax. Here’s how we calculate it:

L=−ln⁡(pc)L = -\\ln (p_c)L=−ln(pc​)

where pcp_cpc​ is our RNN’s predicted probability for the **correct** class (positive or negative). For example, if a positive text is predicted to be 90% positive by our RNN, the loss is:

L=−ln⁡(0.90)=0.105L = -\\ln(0.90) = 0.105L=−ln(0.90)=0.105

> Want a longer explanation? Read the [Cross-Entropy Loss](/blog/intro-to-cnns-part-1/#52-cross-entropy-loss) section of my introduction to Convolutional Neural Networks (CNNs).

Now that we have a loss, we’ll train our RNN using gradient descent to minimize loss. That means it’s time to derive some gradients!

⚠️ **The following section assumes a basic knowledge of multivariable calculus**. You can skip it if you want, but I recommend giving it a skim even if you don’t understand much. **We’ll incrementally write code as we derive results**, and even a surface-level understanding can be helpful.

> If you want some extra background for this section, I recommend first reading the [Training a Neural Network](/blog/intro-to-neural-networks/#3-training-a-neural-network-part-1) section of my introduction to Neural Networks. Also, all of the code for this post is on [Github](https://github.com/vzhou842/rnn-from-scratch), so you can follow along there if you’d like.

Ready? Here we go.

### [](#71-definitions)7.1 Definitions

First, some definitions:

* Let yyy represent the raw outputs from our RNN.
* Let ppp represent the final probabilities: p=softmax(y)p = \\text{softmax}(y)p=softmax(y).
* Let ccc refer to the true label of a certain text sample, a.k.a. the “correct” class.
* Let LLL be the cross-entropy loss: L=−ln⁡(pc)L = -\\ln(p_c)L=−ln(pc​).
* Let WxhW_{xh}Wxh​, WhhW_{hh}Whh​, and WhyW_{hy}Why​ be the 3 weight matrices in our RNN.
* Let bhb_hbh​ and byb_yby​ be the 2 bias vectors in our RNN.

### [](#72-setup)7.2 Setup

Next, we need to edit our forward phase to cache some data for use in the backward phase. While we’re at it, we’ll also setup the skeleton for our backwards phase. Here’s what that looks like:

##### rnn.py

```python
class RNN:
  # ...

  def forward(self, inputs):
    '''
    Perform a forward pass of the RNN using the given inputs.
    Returns the final output and hidden state.
    - inputs is an array of one hot vectors with shape (input_size, 1).
    '''
    h = np.zeros((self.Whh.shape[0], 1))

    self.last_inputs = inputs    self.last_hs = { 0: h }
    # Perform each step of the RNN
    for i, x in enumerate(inputs):
      h = np.tanh(self.Wxh @ x + self.Whh @ h + self.bh)
      self.last_hs[i + 1] = h
    # Compute the output
    y = self.Why @ h + self.by

    return y, h

  def backprop(self, d_y, learn_rate=2e-2):    '''    Perform a backward pass of the RNN.    - d_y (dL/dy) has shape (output_size, 1).    - learn_rate is a float.    '''    pass
```

> Curious about why we’re doing this caching? Read my explanation in the [Training Overview](/blog/intro-to-cnns-part-2/#2-training-overview) of my introduction to CNNs, in which we do the same thing.

### [](#73-gradients)7.3 Gradients

It’s math time! We’ll start by calculating ∂L∂y\\frac{\\partial L}{\\partial y}∂y∂L​. We know:

L=−ln⁡(pc)=−ln⁡(softmax(yc))L = -\\ln(p\_c) = -\\ln(\\text{softmax}(y\_c))L=−ln(pc​)=−ln(softmax(yc​))

I’ll leave the actual derivation of ∂L∂y\\frac{\\partial L}{\\partial y}∂y∂L​ using the Chain Rule as an exercise for you 😉, but the result comes out really nice:

∂L∂yi={piif i≠cpi−1if i=c\\frac{\\partial L}{\\partial y\_i} = \\begin{cases} p\_i & \\text{if $i \\neq c$} \\\ p_i - 1 & \\text{if $i = c$} \\\ \\end{cases}∂yi​∂L​={pi​pi​−1​if i​=cif i=c​

For example, if we have p=\[0.2,0.2,0.6\]p = \[0.2, 0.2, 0.6\]p=\[0.2,0.2,0.6\] and the correct class is c=0c = 0c=0, then we’d get ∂L∂y=\[−0.8,0.2,0.6\]\\frac{\\partial L}{\\partial y} = \[-0.8, 0.2, 0.6\]∂y∂L​=\[−0.8,0.2,0.6\]. This is also quite easy to turn into code:

##### main.py

```python
# Loop over each training example
for x, y in train_data.items():
  inputs = createInputs(x)
  target = int(y)

  # Forward
  out, _ = rnn.forward(inputs)
  probs = softmax(out)

  # Build dL/dy
  d_L_d_y = probs  d_L_d_y[target] -= 1
  # Backward
  rnn.backprop(d_L_d_y)
```

Nice. Next up, let’s take a crack at gradients for WhyW_{hy}Why​ and byb_yby​, which are only used to turn the final hidden state into the RNN’s output. We have:

∂L∂Why=∂L∂y∗∂y∂Why\\frac{\\partial L}{\\partial W_{hy}} = \\frac{\\partial L}{\\partial y} * \\frac{\\partial y}{\\partial W_{hy}}∂Why​∂L​=∂y∂L​∗∂Why​∂y​ y=Whyhn+byy = W_{hy} h\_n + b\_yy=Why​hn​+by​

where hnh_nhn​ is the final hidden state. Thus,

∂y∂Why=hn\\frac{\\partial y}{\\partial W_{hy}} = h_n∂Why​∂y​=hn​ ∂L∂Why=∂L∂yhn\\frac{\\partial L}{\\partial W_{hy}} = \\boxed{\\frac{\\partial L}{\\partial y} h_n}∂Why​∂L​=∂y∂L​hn​​

Similarly,

∂y∂by=1\\frac{\\partial y}{\\partial b_y} = 1∂by​∂y​=1 ∂L∂by=∂L∂y\\frac{\\partial L}{\\partial b_y} = \\boxed{\\frac{\\partial L}{\\partial y}}∂by​∂L​=∂y∂L​​

We can now start implementing `backprop()`!

##### rnn.py

```python
class RNN:
  # ...

  def backprop(self, d_y, learn_rate=2e-2):
    '''
    Perform a backward pass of the RNN.
    - d_y (dL/dy) has shape (output_size, 1).
    - learn_rate is a float.
    '''
    n = len(self.last_inputs)

    # Calculate dL/dWhy and dL/dby.
    d_Why = d_y @ self.last_hs[n].T    d_by = d_y
```

> Reminder: We created `self.last_hs` in `forward()` earlier.

Finally, we need the gradients for WhhW_{hh}Whh​, WxhW_{xh}Wxh​, and bhb_hbh​, which are used **every** step during the RNN. We have:

∂L∂Wxh=∂L∂y∑t∂y∂ht∗∂ht∂Wxh\\frac{\\partial L}{\\partial W_{xh}} = \\frac{\\partial L}{\\partial y} \\sum\_t \\frac{\\partial y}{\\partial h\_t} * \\frac{\\partial h\_t}{\\partial W\_{xh}}∂Wxh​∂L​=∂y∂L​t∑​∂ht​∂y​∗∂Wxh​∂ht​​

because changing WxhW_{xh}Wxh​ affects **every** hth_tht​, which all affect yyy and ultimately LLL. In order to fully calculate the gradient of WxhW_{xh}Wxh​, we’ll need to backpropagate through **all** timesteps, which is known as **Backpropagation Through Time** (BPTT):

![](/media/rnn-post/bptt.svg)

Backpropagation Through Time

WxhW_{xh}Wxh​ is used for all xtx_txt​ → hth_tht​ forward links, so we have to backpropagate back to each of those links.

Once we arrive at a given step ttt, we need to calculate ∂ht∂Wxh\\frac{\\partial h\_t}{\\partial W\_{xh}}∂Wxh​∂ht​​:

ht=tanh⁡(Wxhxt+Whhht−1+bh)h\_t = \\tanh (W\_{xh} x\_t + W\_{hh} h_{t-1} + b_h)ht​=tanh(Wxh​xt​+Whh​ht−1​+bh​)

The derivative of tanh⁡\\tanhtanh is well-known:

dtanh⁡(x)dx=1−tanh⁡2(x)\\frac{d \\tanh(x)}{dx} = 1 - \\tanh^2(x)dxdtanh(x)​=1−tanh2(x)

We use Chain Rule like usual:

∂ht∂Wxh=(1−ht2)xt\\frac{\\partial h\_t}{\\partial W\_{xh}} = \\boxed{(1 - h\_t^2) x\_t}∂Wxh​∂ht​​=(1−ht2​)xt​​

Similarly,

∂ht∂Whh=(1−ht2)ht−1\\frac{\\partial h\_t}{\\partial W\_{hh}} = \\boxed{(1 - h\_t^2) h\_{t-1}}∂Whh​∂ht​​=(1−ht2​)ht−1​​ ∂ht∂bh=(1−ht2)\\frac{\\partial h\_t}{\\partial b\_h} = \\boxed{(1 - h_t^2)}∂bh​∂ht​​=(1−ht2​)​

The last thing we need is ∂y∂ht\\frac{\\partial y}{\\partial h_t}∂ht​∂y​. We can calculate this recursively:

∂y∂ht=∂y∂ht+1∗∂ht+1∂ht=∂y∂ht+1(1−ht2)Whh\\begin{aligned} \\frac{\\partial y}{\\partial h\_t} &= \\frac{\\partial y}{\\partial h\_{t+1}} * \\frac{\\partial h_{t+1}}{\\partial h\_t} \\\ &= \\frac{\\partial y}{\\partial h\_{t+1}} (1 - h\_t^2) W\_{hh} \\\ \\end{aligned}∂ht​∂y​​=∂ht+1​∂y​∗∂ht​∂ht+1​​=∂ht+1​∂y​(1−ht2​)Whh​​

We’ll implement BPTT starting from the last hidden state and working backwards, so we’ll already have ∂y∂ht+1\\frac{\\partial y}{\\partial h_{t+1}}∂ht+1​∂y​ by the time we want to calculate ∂y∂ht\\frac{\\partial y}{\\partial h_t}∂ht​∂y​! The exception is the last hidden state, hnh_nhn​:

∂y∂hn=Why\\frac{\\partial y}{\\partial h\_n} = W\_{hy}∂hn​∂y​=Why​

We now have everything we need to finally implement BPTT and finish `backprop()`:

##### rnn.py

```python
class RNN:
  # ...

  def backprop(self, d_y, learn_rate=2e-2):
    '''
    Perform a backward pass of the RNN.
    - d_y (dL/dy) has shape (output_size, 1).
    - learn_rate is a float.
    '''
    n = len(self.last_inputs)

    # Calculate dL/dWhy and dL/dby.
    d_Why = d_y @ self.last_hs[n].T
    d_by = d_y

    # Initialize dL/dWhh, dL/dWxh, and dL/dbh to zero.
    d_Whh = np.zeros(self.Whh.shape)
    d_Wxh = np.zeros(self.Wxh.shape)
    d_bh = np.zeros(self.bh.shape)

    # Calculate dL/dh for the last h.
    d_h = self.Why.T @ d_y

    # Backpropagate through time.
    for t in reversed(range(n)):
      # An intermediate value: dL/dh * (1 - h^2)
      temp = ((1 - self.last_hs[t + 1] ** 2) * d_h)

      # dL/db = dL/dh * (1 - h^2)
      d_bh += temp
      # dL/dWhh = dL/dh * (1 - h^2) * h_{t-1}
      d_Whh += temp @ self.last_hs[t].T
      # dL/dWxh = dL/dh * (1 - h^2) * x
      d_Wxh += temp @ self.last_inputs[t].T
      # Next dL/dh = dL/dh * (1 - h^2) * Whh
      d_h = self.Whh @ temp

    # Clip to prevent exploding gradients.
    for d in [d_Wxh, d_Whh, d_Why, d_bh, d_by]:
      np.clip(d, -1, 1, out=d)

    # Update weights and biases using gradient descent.
    self.Whh -= learn_rate * d_Whh
    self.Wxh -= learn_rate * d_Wxh
    self.Why -= learn_rate * d_Why
    self.bh -= learn_rate * d_bh
    self.by -= learn_rate * d_by
```

A few things to note:

* We’ve merged ∂L∂y∗∂y∂h\\frac{\\partial L}{\\partial y} * \\frac{\\partial y}{\\partial h}∂y∂L​∗∂h∂y​ into ∂L∂h\\frac{\\partial L}{\\partial h}∂h∂L​ for convenience.
* We’re constantly updating a `d_h` variable that holds the most recent ∂L∂ht+1\\frac{\\partial L}{\\partial h_{t+1}}∂ht+1​∂L​, which we need to calculate ∂L∂ht\\frac{\\partial L}{\\partial h_t}∂ht​∂L​.
* After finishing BPTT, we [np.clip()](https://docs.scipy.org/doc/numpy/reference/generated/numpy.clip.html) gradient values that are below -1 or above 1. This helps mitigate the **exploding gradient** problem, which is when gradients become very large due to having lots of multiplied terms. [Exploding or vanishing gradients](https://en.wikipedia.org/wiki/Vanishing_gradient_problem) are quite problematic for vanilla RNNs - more complex RNNs like [LSTMs](https://en.wikipedia.org/wiki/Long_short-term_memory) are generally better-equipped to handle them.
* Once all gradients are calculated, we update weights and biases using **gradient descent**.

We’ve done it! Our RNN is complete.

## [](#8-the-culmination)8\. The Culmination

It’s finally the moment we been waiting for - let’s test our RNN!

First, we’ll write a helper function to process data with our RNN:

##### main.py

```python
import random

def processData(data, backprop=True):
  '''
  Returns the RNN's loss and accuracy for the given data.
  - data is a dictionary mapping text to True or False.
  - backprop determines if the backward phase should be run.
  '''
  items = list(data.items())
  random.shuffle(items)

  loss = 0
  num_correct = 0

  for x, y in items:
    inputs = createInputs(x)
    target = int(y)

    # Forward
    out, _ = rnn.forward(inputs)
    probs = softmax(out)

    # Calculate loss / accuracy
    loss -= np.log(probs[target])
    num_correct += int(np.argmax(probs) == target)

    if backprop:
      # Build dL/dy
      d_L_d_y = probs
      d_L_d_y[target] -= 1

      # Backward
      rnn.backprop(d_L_d_y)

  return loss / len(data), num_correct / len(data)
```

Now, we can write the training loop:

##### main.py

```python
# Training loop
for epoch in range(1000):
  train_loss, train_acc = processData(train_data)

  if epoch % 100 == 99:
    print('--- Epoch %d' % (epoch + 1))
    print('Train:\tLoss %.3f | Accuracy: %.3f' % (train_loss, train_acc))

    test_loss, test_acc = processData(test_data, backprop=False)
    print('Test:\tLoss %.3f | Accuracy: %.3f' % (test_loss, test_acc))
```

Running `main.py` should output something like this:

```text
--- Epoch 100
Train:  Loss 0.688 | Accuracy: 0.517
Test:   Loss 0.700 | Accuracy: 0.500
--- Epoch 200
Train:  Loss 0.680 | Accuracy: 0.552
Test:   Loss 0.717 | Accuracy: 0.450
--- Epoch 300
Train:  Loss 0.593 | Accuracy: 0.655
Test:   Loss 0.657 | Accuracy: 0.650
--- Epoch 400
Train:  Loss 0.401 | Accuracy: 0.810
Test:   Loss 0.689 | Accuracy: 0.650
--- Epoch 500
Train:  Loss 0.312 | Accuracy: 0.862
Test:   Loss 0.693 | Accuracy: 0.550
--- Epoch 600
Train:  Loss 0.148 | Accuracy: 0.914
Test:   Loss 0.404 | Accuracy: 0.800
--- Epoch 700
Train:  Loss 0.008 | Accuracy: 1.000
Test:   Loss 0.016 | Accuracy: 1.000
--- Epoch 800
Train:  Loss 0.004 | Accuracy: 1.000
Test:   Loss 0.007 | Accuracy: 1.000
--- Epoch 900
Train:  Loss 0.002 | Accuracy: 1.000
Test:   Loss 0.004 | Accuracy: 1.000
--- Epoch 1000
Train:  Loss 0.002 | Accuracy: 1.000
Test:   Loss 0.003 | Accuracy: 1.000
```

Not bad from a RNN we built ourselves. 💯

**Want to try or tinker with this code yourself? [Run this RNN in your browser](https://repl.it/@vzhou842/A-RNN-from-scratch).** It’s also available on [Github](https://github.com/vzhou842/rnn-from-scratch).

## [](#9-the-end)9\. The End

That’s it! In this post, we completed a walkthrough of Recurrent Neural Networks, including what they are, how they work, why they’re useful, how to train them, and how to implement one. There’s still much more you can do, though:

* Learn about [Long short-term memory](https://en.wikipedia.org/wiki/Long_short-term_memory) (LSTM) networks, a more powerful and popular RNN architecture, or about [Gated Recurrent Units](https://en.wikipedia.org/wiki/Gated_recurrent_unit) (GRUs), a well-known variation of the LSTM.
* Experiment with bigger / better RNNs using proper ML libraries like [Tensorflow](https://www.tensorflow.org/), [Keras](https://keras.io/), or [PyTorch](https://pytorch.org/).
* Read about [Bidirectional RNNs](https://en.wikipedia.org/wiki/Bidirectional_recurrent_neural_networks), which process sequences both forwards and backwards so more information is available to the output layer.
* Try out [Word Embeddings](https://en.wikipedia.org/wiki/Word_embedding) like [GloVe](https://nlp.stanford.edu/projects/glove/) or [Word2Vec](https://en.wikipedia.org/wiki/Word2vec), which can be used to turn words into more useful vector representations.
* Check out the [Natural Language Toolkit](https://www.nltk.org/) (NLTK), a popular Python library for working with human language data.

I write a lot about [Machine Learning](/tag/machine-learning/), so [subscribe to my newsletter](/subscribe/?src=intro-to-rnns) if you’re interested in getting future ML content from me.

Thanks for reading!

I write about ML, Web Dev, and more. **Subscribe to get new posts by email!**

  
Send me **only** ML posts  

**This blog is [open-source on Github](https://github.com/vzhou842/victorzhou.com).**

* #### Tags:
    
* [Machine Learning](/tag/machine-learning/)
* [Neural Networks](/tag/neural-networks/)
* [Natural Language Processing](/tag/natural-language-processing/)
* [Python](/tag/python/)
* [For Beginners](/tag/for-beginners/)

#### YOU MIGHT ALSO LIKE

[**CNNs, Part 1: An Introduction to Convolutional Neural Networks**](/blog/intro-to-cnns-part-1/)

**July 22, 2019**

A simple guide to what CNNs are, how they work, and how to build one from scratch in Python.

[**Random Forests for Complete Beginners**](/blog/intro-to-random-forests/)

**April 10, 2019**

The definitive guide to Random Forests and Decision Trees.

[![Victor Zhou](/photo2.png)](/)

#### [Victor Zhou](/) [@victorczhou](https://twitter.com/victorczhou)

SWE @ Facebook. CS '19 @ Princeton. I blog about [web development](/tag/web-development/), [machine learning](/tag/machine-learning/), and [more topics](/tags/).

#### SHARE THIS POST

Facebook

Twitter

LinkedIn

Reddit

#### DISCUSS ON

Twitter

#### At least this isn't a full screen popup

That would be more annoying. Anyways, consider subscribing to my newsletter to **get new posts by email!** I write about ML, Web Dev, and more.

  
Send me **only** ML posts  

✕

/*<!\[CDATA\[*/window.pagePath="/blog/intro-to-rnns/";window.webpackCompilationHash="d003dcebe8cb1a536350";/*\]\]>*//*<!\[CDATA\[*/window.___chunkMapping={"app":\["/app-ac809c2c44710fe0687a.js"\],"component---node-modules-gatsby-plugin-offline-app-shell-js":\["/component---node-modules-gatsby-plugin-offline-app-shell-js-6d9b44900b58f029880b.js"\],"component---src-templates-subscriber-thank-you-template-js":\["/component---src-templates-subscriber-thank-you-template-js-72c3c27651f46b69f9f5.js"\],"component---src-templates-subscribe-template-js":\["/component---src-templates-subscribe-template-js-b51eedd8d17fee51823b.js"\],"component---src-templates-tags-list-template-js":\["/component---src-templates-tags-list-template-js-050eb5833ed2c5c4bb5e.js"\],"component---src-templates-page-template-js":\["/component---src-templates-page-template-js-90a0c3c4e34fa4b6f345.js"\],"component---src-templates-post-template-js":\["/component---src-templates-post-template-js-02181e9aa55168957c9b.js"\],"component---src-templates-math-post-template-js":\["/component---src-templates-math-post-template-js-76ae361875fd0fe82355.js"\],"component---src-templates-tag-template-js":\["/component---src-templates-tag-template-js-dd5805c09cd3b7b3138c.js"\],"component---src-templates-index-template-js":\["/component---src-templates-index-template-js-ff0e3391be0f8218510a.js"\]};/*\]\]>*/

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
