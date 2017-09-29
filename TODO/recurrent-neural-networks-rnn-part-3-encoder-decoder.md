
> * 原文地址：[RECURRENT NEURAL NETWORKS (RNN) – PART 3: ENCODER-DECODER](https://theneuralperspective.com/2016/11/20/recurrent-neural-networks-rnn-part-3-encoder-decoder/)
> * 原文作者：[GokuMohandas](https://twitter.com/GokuMohandas)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-networks-rnn-part-3-encoder-decoder.md](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-networks-rnn-part-3-encoder-decoder.md)
> * 译者：
> * 校对者：

**本系列文章汇总**

1. [RECURRENT NEURAL NETWORKS (RNN) – PART 1: BASIC RNN / CHAR-RNN](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-networks-rnn-part-1-basic-rnn-char-rnn.md)
2. [RECURRENT NEURAL NETWORKS (RNN) – PART 2: TEXT CLASSIFICATION](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-networks-rnn-part-2-text-classification.md)
3. [RECURRENT NEURAL NETWORKS (RNN) – PART 3: ENCODER-DECODER](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-networks-rnn-part-3-encoder-decoder.md)
4. [RECURRENT NEURAL NETWORKS (RNN) – PART 4: ATTENTIONAL INTERFACES](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-network-rnn-part-4-attentional-interfaces.md)
5. [RECURRENT NEURAL NETWORKS (RNN) – PART 5: CUSTOM CELLS](https://github.com/xitu/gold-miner/blob/master/TODO/recurrent-neural-network-rnn-part-5-custom-cells.md)

# RECURRENT NEURAL NETWORKS (RNN) – PART 3: ENCODER-DECODER

In this post, I will cover the basic encoder-decoder which we use to process seq-seq tasks such as machine translation. We will not be covering attention in this post but we will implement it in the next one.

Here we will feed in the input sequence into the encoder which will generate a final hidden state that we will feed into a decoder. The final hidden state from the encoder is the new initial state for the decoder. We will use the decoder outputs with softmax and compare it to the targets to calculate our loss. You can find our more about the paper this model comes from in this **[post](https://theneuralperspective.com/2016/10/02/sequence-to-sequence-learning-with-neural-network/)**. The main difference is that I do not add an EOS token to the encoder inputs and I do not reverse the encoder inputs.

![Screen Shot 2016-11-19 at 4.48.03 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-19-at-4-48-03-pm.png?w=620)

## Data:

I wanted to create a very short dataset to work with (20 sentences in english and spanish). The point of this tutorial is just to see how to build an encoder-decoder system with soft attention for tasks such as machine translation and other seq-to-seq processing. So I wrote several sentences about me and then translate them to spanish and that is our data.

First we separate the sentences into tokens and then convert the tokens into token ids. During this process we collect a vocabulary dict and a reverse vocabulary dict to convert back and forth between tokens and token ids. For our target language (spanish), we will add an extra EOS token. Then we will pad both source and target tokens to the max length (biggest sentence in the respective datasets). This is the data we feed into our model. We use the padded source inputs as is for the encoder, but we will do further additions to the target inputs in order to get our decoder inputs and outputs.

Finally, the inputs will look like this:

![Screen Shot 2016-11-19 at 4.20.54 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-19-at-4-20-54-pm.png?w=620)

This is just one sample from a batch. The 0’s are paddings, 1 is a GO token and 2 is an EOS token. A more general representation of the data transformation is below. Ignore the target weights, we do not use them in our implementation.

![screen-shot-2016-11-16-at-5-09-10-pm](https://theneuralperspective.files.wordpress.com/2016/10/screen-shot-2016-11-16-at-5-09-10-pm.png?w=620)

## Encoder:

The encoder simply taken the encoder inputs and the only thing we care about is the final hidden state. This hidden state holds the information from all of the inputs. We do not reverse the encoder inputs as the paper suggests because we are using seq_len with dynamic_rnn. This automatically returns the last relevant hidden state based on seq_lens.

```
with tf.variable_scope('encoder') as scope:

    # Encoder RNN cell
    self.encoder_stacked_cell = rnn_cell(FLAGS, self.dropout,
        scope=scope)

    # Embed encoder inputs
    W_input = tf.get_variable("W_input",
        [FLAGS.en_vocab_size, FLAGS.num_hidden_units])
    self.embedded_encoder_inputs = rnn_inputs(FLAGS,
        self.encoder_inputs, FLAGS.en_vocab_size, scope=scope)
    #initial_state = encoder_stacked_cell.zero_state(FLAGS.batch_size, tf.float32)

    # Outputs from encoder RNN
    self.all_encoder_outputs, self.encoder_state = tf.nn.dynamic_rnn(
        cell=self.encoder_stacked_cell,
        inputs=self.embedded_encoder_inputs,
        sequence_length=self.en_seq_lens, time_major=False,
        dtype=tf.float32)
```

We will use this final hidden state as the new initial state for our decoder.

## Decoder:

This simple decoder takes in the final hidden state from the encoder as its initial state. We will also embed the decoder inputs and process them with the decoder RNN. The outputs will be normalized with softmax and then compared with the targets. Note that the decoder inputs starts with a GO token which is to predict the first target token. The decoder input’s last relevant token with predict the EOS target token.

```
with tf.variable_scope('decoder') as scope:

    # Initial state is last relevant state from encoder
    self.decoder_initial_state = self.encoder_state

    # Decoder RNN cell
    self.decoder_stacked_cell = rnn_cell(FLAGS, self.dropout,
        scope=scope)

    # Embed decoder RNN inputs
    W_input = tf.get_variable("W_input",
        [FLAGS.sp_vocab_size, FLAGS.num_hidden_units])
    self.embedded_decoder_inputs = rnn_inputs(FLAGS, self.decoder_inputs,
        FLAGS.sp_vocab_size, scope=scope)

    # Outputs from encoder RNN
    self.all_decoder_outputs, self.decoder_state = tf.nn.dynamic_rnn(
        cell=self.decoder_stacked_cell,
        inputs=self.embedded_decoder_inputs,
        sequence_length=self.sp_seq_lens, time_major=False,
        initial_state=self.decoder_initial_state)
```

But what about the paddings, they will also be predicting some output target but we don’t really care about those but they will still impact our loss if we factor them in. Here’s where we will be masking the loss to remove influence from paddings in the targets.

## Loss Masking:

We will use the targets and where ever the target is a PAD, we will mask the loss for that location to 0\. So when we get to the last relevant decoder token, the appropriate target will be an EOS token id. For the next decoder input the target will be a PAD id. This is where the masking starts.

```
# Logits
self.decoder_outputs_flat = tf.reshape(self.all_decoder_outputs,
    [-1, FLAGS.num_hidden_units])
self.logits_flat = rnn_softmax(FLAGS, self.decoder_outputs_flat,
    scope=scope)

# Loss with masking
targets_flat = tf.reshape(self.targets, [-1])
losses_flat = tf.nn.sparse_softmax_cross_entropy_with_logits(
    self.logits_flat, targets_flat)
mask = tf.sign(tf.to_float(targets_flat))
masked_losses = mask * losses_flat
masked_losses = tf.reshape(masked_losses,  tf.shape(self.targets))
self.loss = tf.reduce_mean(
    tf.reduce_sum(masked_losses, reduction_indices=1))
```

We will cleverly use the fact that PAD IDs are 0 to apply the loss mask. Once we apply the mask, we just compute the sum of the losses for each row (sample in the batch) and then take the mean of all the sample’s losses to get the batch’s loss. From here, we can just train on minimizing this loss.

Here are the training results:

![Screen Shot 2016-11-19 at 4.56.18 PM.png](https://theneuralperspective.files.wordpress.com/2016/11/screen-shot-2016-11-19-at-4-56-18-pm.png?w=620)

We won’t be doing any inference here but you can find it the following post with attention. But if you really want to implement inference here, just use the same model as training but you need to feed the predicted target back in as an input for the next decoder rnn cell. You need to embed with the same set of weights used to embed INTO the decoder and have it as another input to the rnn. This means that for the initial GO token, you need to feed in some dummy input token that will be embedded.

## Conclusion:

This encoder-decoder model is quite simple but it is a necessary foundation prior to understanding the seq-seq implementation with attention. In the next RNN tutorial, we will cover attentional interfaces and their advantages over this encoder-decoder architecture.

## Code:

**[GitHub Repo](https://github.com/ajarai/the-neural-perspective/tree/master/recurrent-neural-networks/seq-seq/encoder-decoder) (Updating all repos, will be back up soon!)**


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
