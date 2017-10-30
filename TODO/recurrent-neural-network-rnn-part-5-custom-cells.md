
> * 原文地址：[RECURRENT NEURAL NETWORK (RNN) – PART 5: CUSTOM CELLS](https://theneuralperspective.com/2016/11/17/recurrent-neural-network-rnn-part-4-custom-cells/)
> * 原文作者：[GokuMohandas](https://twitter.com/GokuMohandas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-network-rnn-part-5-custom-cells.md](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-network-rnn-part-5-custom-cells.md)
> * 译者：
> * 校对者：

**本系列文章汇总**

1. [RECURRENT NEURAL NETWORKS (RNN) – PART 1: BASIC RNN / CHAR-RNN](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-networks-rnn-part-1-basic-rnn-char-rnn.md)
2. [RECURRENT NEURAL NETWORKS (RNN) – PART 2: TEXT CLASSIFICATION](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-networks-rnn-part-2-text-classification.md)
3. [RECURRENT NEURAL NETWORKS (RNN) – PART 3: ENCODER-DECODER](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-networks-rnn-part-3-encoder-decoder.md)
4. [RECURRENT NEURAL NETWORKS (RNN) – PART 4: ATTENTIONAL INTERFACES](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-network-rnn-part-4-attentional-interfaces.md)
5. [RECURRENT NEURAL NETWORKS (RNN) – PART 5: CUSTOM CELLS](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-network-rnn-part-5-custom-cells.md)

# RECURRENT NEURAL NETWORK (RNN) – PART 5: CUSTOM CELLS

In this post, we will explore the idea of creating our own custom RNN cells. But first, we will take a closer look at the simple RNN and then more complicated units such as LSTM and GRU. We will also analyze the tensorflow code for these units and draw from them to eventually create our own custom cells. In this post, I will be using images from one of the best posts out there on RNNs/LSTMS by Chris Olah. I highly urge you to read the **[post](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)** and in my post I will be reiterating a lot of material but I will move rather quickly and focus more on the tf code. I will be referring back to this code in a future post on applying layer normalization to these RNN architectures, which can be found **[here](https://theneuralperspective.com/2016/10/27/gradient-topics/)**.

## Basic RNNs:

With traditional RNNs, the main issue is that we cannot adequately learn long term dependencies because the operations that we repeat at each cell unit for each input are static. If you think back to the basic RNN cell, the operations all involve the single tanh operation.

![screen-shot-2016-10-04-at-5-54-13-am](https://theneuralperspective.files.wordpress.com/2016/10/screen-shot-2016-10-04-at-5-54-13-am.png?w=620)

This architecture is suitable inputs where the solutions are based on short term dependencies but if we wish to utilize long term memory efficiently to predict the right targets, we will need a rnn cell unit that is more robust. Cue the LSTM.

## Long Short Term Memory Networks (LSTMs):

The architecture of the LSTMs allows us to have long term information control at the expensive of more operations. Our traditional RNNs had one output which served as both the hidden state representation and the output from the cell.

![Screen Shot 2016-11-16 at 6.25.04 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-16-at-6-25-04-pm.png?w=620)

There is an absence of information control with this basic architecture that prevents us from holding on to useful information for many steps down the line. The LSTM, instead, has two different types of outputs. We still the traditional state output which acts as the hidden state representation and the cell’s output but the cell also outputs a cell state C. Here is the LSTM in all its glory, time to break it down into pieces.

![Screen Shot 2016-11-16 at 6.28.06 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-16-at-6-28-06-pm.png?w=620)

### Forget gate:

The very first gate is the forget gate. This gate allows us to selectively pass information to determination of the cell state. I will break down the notation below once and you can reapply for all the other gates as well.

![Screen Shot 2016-11-16 at 6.30.38 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-16-at-6-30-38-pm.png?w=620)

![Screen Shot 2016-11-16 at 6.39.17 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-16-at-6-39-17-pm.png?w=620)

And of course to implement this, you could follow something like tf’s [_linear](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/python/ops/rnn_cell.py#867) function. But the main idea is that we are applying this sigmoid operation to both the input and the previous hidden state. But what exactly is applying this sigmoid operation doing? Recall that sigmoid outputs in the range [0, 1] and here we are applying it to a matrix of shape [N X H], which means we will produce NXH values with sigmoid applied to them. If the sigmoid operation results in 0, then that hidden value is nullified and it it is 1, we completely let that value be used. Anything in between allows parts of the information to go through. This is an nice way to control the information that is flowing through by effectively blocking and selectively passing parts of the inputs to the cell.

This forget gate, however, is only the first operation that we do to ultimately calculate our cell state. The next operation involves the input gate.

### Input gate:

The input gate takes in our input X and the previous hidden state and computes two operations. First it selectively allows parts of the inputs to pass through with a sigmoid gate and then we multiply it by the tanh of the inputs.

![Screen Shot 2016-11-16 at 6.48.07 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-16-at-6-48-07-pm.png?w=620)

What the tanh is doing here is a bit different from the sigmoid operation. Recall that tanh changes our inputs into the range [-1, 1]. This essentially changes the underlying representation of our inputs with this nonlinearity. This is the exact same step as what we were doing with the basic RNN cell. But now we take the product of these two values and add it to the value from the forget gate to calculate our cell state.

These operations with the forget and input gate can be translated to the fact that we keep parts of the old cell state (C_{t-1}) and keep parts of the new transformed (tanh) cell state C~_t. These weights are trained with our data to learn exactly how much information to keep and how to perform the correct transformation.

### Output gate:

The last gate is the output gate and it uses the input, previous hidden state and the new cell state to determine the new hidden state representation.

![Screen Shot 2016-11-16 at 6.54.29 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-16-at-6-54-29-pm.png?w=620)

This operation again involves the selective information barrier sigmoid which is multiplied with tanh of the cell state. Note that this tanh operation is not a neural network as with the tanh operation in the input gate. This is simply applying the tangent to the cell state without any modifications with weights. We are merely forcing the cell states [NXH] values to be in the range [-1, 1].

### Variations:

There are literally hundreds of variations for RNN cells so I suggest checking our Chris Olah’s **[blog](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)** again for more information. A few note worthy one’s he discussed were the peephole model (allow all gates to see the cell state available at that point in time (C_{t-1} or C_t is already calculated) and coupled cell states (only update when we forget and forget when we update). But the current rival to the LSTM, which is heavily based off of the LSTM and it rapidly growing in use is the Gated Recurrent Unit (GRU).

## Gated Recurrent Unit (GRU):

The main idea behind the GRU is that is combines the forget and input gate into one update gate. ![Screen Shot 2016-11-16 at 7.01.15 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-16-at-7-01-15-pm.png?w=620)

Empirically, the GRU’s performance on most tasks is on par with the LSTM and also computationally less expensive. These tradeoffs are the reason behind it’s surging popularity.

## Tensorflow Native Implementations:

Now we will take a look at the official Tensorflow code the GRU unit and we will mostly focus on the function calls, inputs and outputs. From here, we will replicate the structure to create our own unique cells. If you’re interested in the other cells available, you can find them all at this **[link](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/python/ops/rnn_cell.py)**. We will just focus on the GRU because it’s performance is as good as the LSTM in more cases and significantly less complex.

```
class GRUCell(RNNCell):
  """Gated Recurrent Unit cell (cf. http://arxiv.org/abs/1406.1078)."""

  def __init__(self, num_units, input_size=None, activation=tanh):
    if input_size is not None:
      logging.warn("%s: The input_size parameter is deprecated.", self)
    self._num_units = num_units
    self._activation = activation

  @property
  def state_size(self):
    return self._num_units

  @property
  def output_size(self):
    return self._num_units

  def __call__(self, inputs, state, scope=None):
    """Gated recurrent unit (GRU) with nunits cells."""
    with vs.variable_scope(scope or type(self).__name__):  # "GRUCell"
      with vs.variable_scope("Gates"):  # Reset gate and update gate.
        # We start with bias of 1.0 to not reset and not update.
        r, u = array_ops.split(1, 2, _linear([inputs, state],
                                             2 * self._num_units, True, 1.0))
        r, u = sigmoid(r), sigmoid(u)
      with vs.variable_scope("Candidate"):
        c = self._activation(_linear([inputs, r * state],
                                     self._num_units, True))
      new_h = u * state + (1 - u) * c
    return new_h, new_h
```

The GRUCell class start with the __init__ function which defines the number of units and the activation function it will use. This is the activation function that is usually tanh but the sigmoid activations are fixed since the [0,1] range allows us to control the information flow. Then we have two properties that both return self._num_units when invoked. And finally, we have out __call__ function which is what processes the input and churns out the new hidden state. Recall that GRU does not have a cell state like the LSTM.

First, we compute r and u (u = z in colah’s notation above). Instead of separately doing them, we just merge the weights and do it with 2*num_units and then we split it by two. **split(dim, num_splits, value)**. Then we apply our sigmoid activate on the values to selectively control the information flow. Then we calculate the candidate c and use it to calculate out new hidden state representation. You may see that the order for calculating new_h is switched, either way works fine, because the weights will train accordingly.

All of the other cells’ codes look very similar to this, so you will easily be able to interpret them.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
