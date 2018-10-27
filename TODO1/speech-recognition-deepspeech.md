> * 原文地址：[Streaming RNNs in TensorFlow](https://hacks.mozilla.org/2018/09/speech-recognition-deepspeech/)
> * 原文作者：[Reuben Morais](https://hacks.mozilla.org/author/rmoraismozilla-com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/speech-recognition-deepspeech.md](https://github.com/xitu/gold-miner/blob/master/TODO1/speech-recognition-deepspeech.md)
> * 译者：[sisibeloved](https://github.com/sisibeloved)
> * 校对者：[lsvih](https://github.com/lsvih)

# TensorFlow 中的 RNN 串流

[谋智（Mozilla）研究所](http://research.mozilla.org/)的机器学习团队正在开发一个自动语音识别引擎，它将作为[深度语音（DeepSpeech）项目](https://github.com/mozilla/DeepSpeech)的一部分，致力于向开发人员开放语音识别技术和预训练模型。我们正在努力提高我们开源的语音转文本引擎的性能和易用性。即将发布的 0.2 版本将包括一个大家期待已久的特性：在录制音频时实时进行语音识别的能力。这篇博客文章描述了我们是怎样修改 STT（即 speech-to-text，语音转文字）引擎的架构，来达到实现实时转录的性能要求。不久之后，等到正式版本发布，你就可以体验这一音频转换的功能。

当将神经网络应用到诸如音频或文本的顺序数据时，捕获数据随着时间推移而出现的模式是很重要的。循环神经网络（RNN）是具有『记忆』的神经网络 —— 它们不仅将数据中的下一个元素作为输入，而且还将随时间演进的状态作为输入，并使用这个状态来捕获与时间相关的模式。有时，你可能希望捕获依赖未来数据的模式。解决这个问题的方法之一是使用两个 RNN，一个在时序上向前，而另一个按向后的时序（即从数据中的最后一个元素开始，到第一个元素）。你可以在 [Chris Olah 的这篇文章](https://colah.github.io/posts/2015-08-Understanding-LSTMs/)中了解更多关于 RNN（以及关于 DeepSpeech 中使用的特定类型的 RNN）的知识。

## 使用双向 RNN

DeepSpeech 的当前版本（[之前在 Hacks 上讨论过](https://hacks.mozilla.org/2017/11/a-journey-to-10-word-error-rate/)）使用了用 [TensorFlow](https://www.tensorflow.org/) 实现的双向 RNN，这意味着它需要在开始工作之前具有整个可用的输入。一种改善这种情况的方法是通过实现流式模型：在数据到达时以块为单位进行工作，这样当输入结束时，模型已经在处理它，并且可以更快地给出结果。你也可以尝试在输入中途查看部分结果。

![This animation shows how the data flows through the network. Data flows from the audio input to feature computation, through three fully connected layers. Then it goes through a bidirectional RNN layer, and finally through a final fully connected layer, where a prediction is made for a single time step.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/09/bidirectional.gif)

> 这个动画展示了数据如何在网络间流动。数据通过三个全连接层，从音频输入转变成特征计算。然后通过了一个双向 RNN 层，最后通过对单个时间步长进行预测的全连接层。

为了做到这一点，你需要有一个可以分块处理数据的模型。这是当前模型的图表，显示数据如何流过它。

可以看到，在双向 RNN 中，倒数第二步的计算需要最后一步的数据，倒数第三步的计算需要倒数第二步的数据……如此循环往复。这些是图中从右到左的红色箭头。

通过在数据被馈入时进行到第三层的计算，我们可以实现部分流式处理。这种方法的问题是它在延迟方面不会给我们带来太多好处：第四层和第五层占用了整个模型几乎一半的计算成本。

## 使用单向 RNN 处理串流

因此，我们可以用单向层替换双向层，单向层不依赖于将来的时间步。只要我们有足够的音频输入，就能一直计算到最后一层。

使用单向模型，你可以分段地提供输入，而不是在同一时间输入整个输入并获得整个输出。也就是说，你可以一次输入 100ms 的音频，立即获得这段时间的输出，并保存最终状态，这样可以将其用作下一个 100ms 的音频的初始状态。

![An alternative architecture that uses a unidirectional RNN in which each time step only depends on the input at that time and the state from the previous step.](https://2r4s9p1yi1fa2jd7j43zph8r-wpengine.netdna-ssl.com/files/2018/09/unidirectional.png)

> 一种使用单向 RNN 的备选架构，其中每个时间步长仅取决于即时的输入和来自前一步的状态。

下面是创建一个推理图的代码，它可以跟踪每个输入窗口之间的状态：

```python
import tensorflow as tf

def create_inference_graph(batch_size=1, n_steps=16, n_features=26, width=64):
    input_ph = tf.placeholder(dtype=tf.float32,
                              shape=[batch_size, n_steps, n_features],
                              name='input')
    sequence_lengths = tf.placeholder(dtype=tf.int32,
                                      shape=[batch_size],
                                      name='input_lengths')
    previous_state_c = tf.get_variable(dtype=tf.float32,
                                       shape=[batch_size, width],
                                       name='previous_state_c')
    previous_state_h = tf.get_variable(dtype=tf.float32,
                                       shape=[batch_size, width],
                                       name='previous_state_h')
    previous_state = tf.contrib.rnn.LSTMStateTuple(previous_state_c, previous_state_h)

    # 从以批次为主转置成以时间为主
    input_ = tf.transpose(input_ph, [1, 0, 2])

    # 展开以契合前馈层的维度
    input_ = tf.reshape(input_, [batch_size*n_steps, n_features])

    # 三个隐含的 ReLU 层
    layer1 = tf.contrib.layers.fully_connected(input_, width)
    layer2 = tf.contrib.layers.fully_connected(layer1, width)
    layer3 = tf.contrib.layers.fully_connected(layer2, width)

    # 单向 LSTM
    rnn_cell = tf.contrib.rnn.LSTMBlockFusedCell(width)
    rnn, new_state = rnn_cell(layer3, initial_state=previous_state)
    new_state_c, new_state_h = new_state

    # 最终的隐含层
    layer5 = tf.contrib.layers.fully_connected(rnn, width)

    # 输出层
    output = tf.contrib.layers.fully_connected(layer5, ALPHABET_SIZE+1, activation_fn=None)

    # 用新的状态自动更新原先的状态
    state_update_ops = [
        tf.assign(previous_state_c, new_state_c),
        tf.assign(previous_state_h, new_state_h)
    ]
    with tf.control_dependencies(state_update_ops):
        logits = tf.identity(logits, name='logits')

    # 创建初始化状态
    zero_state = tf.zeros([batch_size, n_cell_dim], tf.float32)
    initialize_c = tf.assign(previous_state_c, zero_state)
    initialize_h = tf.assign(previous_state_h, zero_state)
    initialize_state = tf.group(initialize_c, initialize_h, name='initialize_state')

    return {
        'inputs': {
            'input': input_ph,
            'input_lengths': sequence_lengths,
        },
        'outputs': {
            'output': logits,
            'initialize_state': initialize_state,
        }
    }
```

上述代码创建的图有两个输入和两个输出。输入是序列及其长度。输出是 `logit` 和一个需要在一个新序列开始运行的特殊节点 `initialize_state`。当固化图像时，请确保不固化状态变量 `previous_state_h` 和 `previous_state_c`。

下面是固化图的代码:

```python
from tensorflow.python.tools import freeze_graph

freeze_graph.freeze_graph_with_def_protos(
        input_graph_def=session.graph_def,
        input_saver_def=saver.as_saver_def(),
        input_checkpoint=checkpoint_path,
        output_node_names='logits,initialize_state',
        restore_op_name=None,
        filename_tensor_name=None,
        output_graph=output_graph_path,
        initializer_nodes='',
        variable_names_blacklist='previous_state_c,previous_state_h')
```

通过以上对模型的更改，我们可以在客户端采取以下步骤：

1.  运行 `initialize_state` 节点。
2.  积累音频样本，直到数据足以供给模型（我们使用的是 16 个时间步长，或 320ms）
3.  将数据供给模型，在某个地方积累输出。
4.  重复第二步和第三步直到数据结束。

把几百行的客户端代码扔给读者是没有意义的，但是如果你感兴趣的话，可以查阅 [GitHub 中的代码](https://github.com/mozilla/DeepSpeech)，这些代码均遵循 MPL 2.0 协议。事实上，我们有两种不同语言的实现，一个用 [Python](https://github.com/mozilla/DeepSpeech/blob/bb299dc26554b2fbf864b7f0115b4baece15bda5/evaluate.py#L233)，用来生成测试报告；另一个用 [C++](https://github.com/mozilla/DeepSpeech/blob/6f27928841c2595c8dd9d08f482c95ca9e42f4b5/native_client/deepspeech.cc)，这是我们官方的客户端 API。

## 性能提升

这些架构上的改动对我们的 STT 引擎能造成怎样的影响？下面有一些与当前稳定版本相比较的数字：

*   模型大小从 468MB 减小至 180MB
*   转录时间：一个时长 3s 的文件，运行在笔记本 CPU上，所需时间从 9s 降至 1.5s
*   堆内存的峰值占用量从 4GB 降至 20MB（模型现在是内存映射的）
*   总的堆内存分配从 12GB 降至 264MB

我觉得最重要的一点，我们现在能在不使用 GPU 的情况下满足实时的速率，这与流式推理一起，开辟了许多新的使用可能性，如无线电节目、Twitch 流和 keynote 演示的实况字幕；家庭自动化；基于语音的 UI；等等等等。如果你想在下一个项目中整合语音识别，考虑使用我们的引擎！

下面是一个小型 Python 程序，演示了如何使用 libSoX 库调用麦克风进行录音，并在录制音频时将其输入引擎。

```python
import argparse
import deepspeech as ds
import numpy as np
import shlex
import subprocess
import sys

parser = argparse.ArgumentParser(description='DeepSpeech speech-to-text from microphone')
parser.add_argument('--model', required=True,
                    help='Path to the model (protocol buffer binary file)')
parser.add_argument('--alphabet', required=True,
                    help='Path to the configuration file specifying the alphabet used by the network')
parser.add_argument('--lm', nargs='?',
                    help='Path to the language model binary file')
parser.add_argument('--trie', nargs='?',
                    help='Path to the language model trie file created with native_client/generate_trie')
args = parser.parse_args()

LM_WEIGHT = 1.50
VALID_WORD_COUNT_WEIGHT = 2.25
N_FEATURES = 26
N_CONTEXT = 9
BEAM_WIDTH = 512

print('Initializing model...')

model = ds.Model(args.model, N_FEATURES, N_CONTEXT, args.alphabet, BEAM_WIDTH)
if args.lm and args.trie:
    model.enableDecoderWithLM(args.alphabet,
                              args.lm,
                              args.trie,
                              LM_WEIGHT,
                              VALID_WORD_COUNT_WEIGHT)
sctx = model.setupStream()

subproc = subprocess.Popen(shlex.split('rec -q -V0 -e signed -L -c 1 -b 16 -r 16k -t raw - gain -2'),
                           stdout=subprocess.PIPE,
                           bufsize=0)
print('You can start speaking now. Press Control-C to stop recording.')

try:
    while True:
        data = subproc.stdout.read(512)
        model.feedAudioContent(sctx, np.frombuffer(data, np.int16))
except KeyboardInterrupt:
    print('Transcription:', model.finishStream(sctx))
    subproc.terminate()
    subproc.wait()
```

最后，如果你想为深度语音项目做出贡献，我们有很多机会。代码库是用 Python 和 C++ 编写的，并且我们将添加对 iOS 和 Windows 的支持。通过我们的 [IRC 频道](irc://irc.mozilla.org/#machinelearning)或我们的 [Discourse 论坛](https://discourse.mozilla.org/c/deep-speech)来联系我们。

## 关于 Reuben Morais

Reuben 是谋智研究所机器学习小组的一名工程师。

[Reuben Morais 的更多文章…](https://hacks.mozilla.org/author/rmoraismozilla-com/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
