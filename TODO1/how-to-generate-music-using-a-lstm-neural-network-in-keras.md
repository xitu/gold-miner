> * 原文地址：[How to Generate Music using a LSTM Neural Network in Keras](https://towardsdatascience.com/how-to-generate-music-using-a-lstm-neural-network-in-keras-68786834d4c5)
> * 原文作者：[Sigurður Skúli](https://medium.com/@sigurdurssigurg)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-generate-music-using-a-lstm-neural-network-in-keras.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-generate-music-using-a-lstm-neural-network-in-keras.md)
> * 译者：[HearFishle](https://github.com/HearFishle)
> * 校对者：[xionglong58](https://github.com/xionglong58)、[JackEggie](https://github.com/JackEggie)

# 如何在 Keras 中使用 LSTM 神经网络创作音乐

![](https://cdn-images-1.medium.com/max/3840/1*evQj8gukICFrnBICeJvY0w.jpeg)

## 介绍

神经网络正在被使用去提升我们生活的方方面面。它们为我们提供购物建议，[创作一篇基于某作者风格的文档](http://www.cs.utoronto.ca/~ilya/pubs/2011/LANG-RNN.pdf)甚至可以被使用去[改变图片的艺术风格](https://arxiv.org/pdf/1508.06576.pdf)。近几年来，大量的教程集中于如何使用神经网络去创作文本但却鲜有教程告诉你如何创作音乐。在这篇文章中我们将介绍如何通过循环神经网络，使用 Python 和 Keras 库去创作音乐。

对于那些没耐心的人，在结尾为你们提供了本教程的 Github 仓库的链接。

## 背景

在进入具体的实现之前必须先弄清一些专业术语。

### 循环神经网络（RNN）

循环神经网络是一类让我们使用时序信息的人工神经网络。之所以称之为循环是因为他们对数据序列中的每一个元素都执行相同的函数。每次的结果依赖于之前的运算。传统的神经网络则与之相反，输出不依赖于之前的计算。

在这篇教程中，我们使用一个[**长短期记忆（LSTM）**](http://colah.github.io/posts/2015-08-Understanding-LSTMs/)神经网络。这类循环神经网络可以通过梯度下降法高效的学习。使用闸门机制，LSTM 可以识别和编码长期模式。LSTM 对于解决那些长期记忆信息的案例如创作音乐和文本特别有用。

### Music21

[Music21](http://web.mit.edu/music21/) 是一个被使用在计算机辅助音乐学的 Python 工具包。它使我们可以去教授音乐的基本原理，创作音乐范例并且学音乐。这个工具包提供了一个简单的接口去获得 MIDI 文件中的音乐谱号。除此之外，我们还能使用它去创作音符与和弦来轻松制作属于自己的 MIDI 文件。

在这篇教程中我们将使用 Music21 来提取我们数据集的内容，获取神经网络的输出，再将之转换成音符。

### Keras

[Keras](https://keras.io/) 是一个 high-level 神经网络接口，它简化了和 [Tensorflow](https://www.tensorflow.org/) 的交互。它的开发重点是实现快速实验。

在本教程中我们将使用 Keras 库去创建和训练 LSTM 模型。一旦这个模型被训练出来，我们将使用它去给我们的音乐创作音符。

## 训练

在本节中我们将讲解如何为我们的模型收集数据，如何整理数据使它能够在 LSTM 模型中被使用，以及我们模型的结构是什么。

### 数据

在 [Github 仓库](https://github.com/Skuldur/Classical-Piano-Composer)中，我们使用钢琴曲（展示），音乐主要由《最终幻想》中的音轨组成。选择《最终幻想》系列音乐，是因为它有很多部分，而且大部分的旋律都是清晰而优美的。而任何一组由单个乐器组成的 MIDI 文件都可以为我们服务。

实现神经网络的第一步是检查我们要处理的数据。

下面我们看到的是来自于一个被 Music21 读取后的 midi 文件的摘录：

```
...
<music21.note.Note F>
<music21.chord.Chord A2 E3>
<music21.chord.Chord A2 E3>
<music21.note.Note E>
<music21.chord.Chord B-2 F3>
<music21.note.Note F>
<music21.note.Note G>
<music21.note.Note D>
<music21.chord.Chord B-2 F3>
<music21.note.Note F>
<music21.chord.Chord B-2 F3>
<music21.note.Note E>
<music21.chord.Chord B-2 F3>
<music21.note.Note D>
<music21.chord.Chord B-2 F3>
<music21.note.Note E>
<music21.chord.Chord A2 E3>
...
```

这个数据被拆分成两种类型：[Note](http://web.mit.edu/music21/doc/moduleReference/moduleNote.html#note)（译者注：音符集）和 [Chord](http://web.mit.edu/music21/doc/moduleReference/moduleChord.html)（译者注：和弦集）。音符对象包括**音高**，**音阶**和音符的**偏移量**

*  **音高**是指声音的频率，或者用 [A, B, C, D, E, F, G] 来表示它是高还是低。其中 A 是最高，G 是最低。

*  **[音阶](http://web.mst.edu/~kosbar/test/ff/fourier/notes_pitchnames.html)** 是指你将选择在钢琴上使用哪些音高。 

*  **偏移量**是指音符在作品的位置。

而和弦对象的本质是一个同时播放一组音符的容器。

现在我们可以看到要想精确创作音乐，我们的神经网络将必须有能力去预测哪个音符或和弦将被使用。这意味着我们的预测集将必须包含每一个我们训练集中遇到的音符与和弦对象。在 Github 页面的训练集上，不同的音符与和弦的数量总计达 352 个。这似乎交给了网络许多种可能的预测去输出，但是一个 LSTM 网络可以轻松处理它。

接下来我得考虑把这些音符放到哪里了。正如大部分人听音乐时注意到的，音符的间隔通常不同。你可以听到一连串快速的音符，然后接下来又是一段空白，这时没有任何音符演奏。

接下来我们从另外一个被 Music21 读取过的 midi 文件里找一个摘录，这次我们仅仅在它后面添加了偏移量。这使我们可以看到每个音符与和弦之间的间隔。

```
...
<music21.note.Note B> 72.0
<music21.chord.Chord E3 A3> 72.0
<music21.note.Note A> 72.5
<music21.chord.Chord E3 A3> 72.5
<music21.note.Note E> 73.0
<music21.chord.Chord E3 A3> 73.0
<music21.chord.Chord E3 A3> 73.5
<music21.note.Note E-> 74.0
<music21.chord.Chord F3 A3> 74.0
<music21.chord.Chord F3 A3> 74.5
<music21.chord.Chord F3 A3> 75.0
<music21.chord.Chord F3 A3> 75.5
<music21.chord.Chord E3 A3> 76.0
<music21.chord.Chord E3 A3> 76.5
<music21.chord.Chord E3 A3> 77.0
<music21.chord.Chord E3 A3> 77.5
<music21.chord.Chord F3 A3> 78.0
<music21.chord.Chord F3 A3> 78.5
<music21.chord.Chord F3 A3> 79.0
...
```

如这段摘录里所示，midi 文件里大部分数据集的音符的间隔都是 0.5。因此，我们可以通过忽略不同输出的偏移量来简化数据和模型。这不会太剧烈的影响神经网络创作的音乐旋律。因此我们将忽视教程中的偏移量并且把我们的可能输出列表保持在 352。

### 准备数据

既然我们已经检查了数据并且决定了我们要使用音符与和弦作为网络输出与输出的特征，那么现在就要为网络准备数据了。

首先，我们把数据加载到一个数组中，就像下面的代码这样：

```python
from music21 import converter, instrument, note, chord

notes = []

for file in glob.glob("midi_songs/*.mid"):
    midi = converter.parse(file)
    notes_to_parse = None

    parts = instrument.partitionByInstrument(midi)

    if parts: # 文件包含乐器
        notes_to_parse = parts.parts[0].recurse()
    else: # 文件有扁平结构的音符
        notes_to_parse = midi.flat.notes

    for element in notes_to_parse:
        if isinstance(element, note.Note):
            notes.append(str(element.pitch))
        elif isinstance(element, chord.Chord):
            notes.append('.'.join(str(n) for n in element.normalOrder))
```

使用 `converter.parse(file)` 函数，我们开始把每一个文件加载到一个 Music21 流对象中。使用这个流对象，我们在文件中得到一个包含所有的音符与和弦的列表。把数组符号贴到到每个音符对象的音高上，因为使用数组符号可以重新创造音符中最重要的部分。将每个和弦的 ID 编码成一个单独的字符串，每个音符用一个点分隔。这些代码使我们可以轻松的把由网络生成的输出解码为正确的音符与和弦。

既然我们已经把所有的音符与和弦放入一个序列表中，我们就可以创造一个序列，作为网络的输入。

![图 1: 当一个数据由分类数据转换成数值数据时，此数据被转换成了一个整数索引来表示某一类在一组不同值中的位置。例如，苹果是第一个明确的值，因此它被映射成 0。桔子在第二个因此被映射成 1，菠萝就是 3，等等](https://cdn-images-1.medium.com/max/2000/1*sM3FeKwC-SD66FCKzoExDQ.jpeg)

图 1：当一个数据由分类数据转换成数值数据时，此数据被转换成了一个整数索引来表示某一类在一组不同值中的位置。例如，苹果是第一个明确的值，因此它被映射成 0。桔子在第二个因此被映射成 1，菠萝就是 3，等等。

首先，我们将写一个映射函数去把字符型分类数据映射成整型数值数据。这么做是因为神经网络处理整型数值数据（的性能）远比处理字符型分类数据好的多。图 1 就是一个把分类转换成数值的例子。

接下来，我们必须为网络及其输出分别创建输入序列。每一个输入序列对应的输出序列将是第一个音符或者和弦，它在音符列表的输入序列中，位于音符列表之后。

```python
sequence_length = 100

# 得到所有的音高名称
pitchnames = sorted(set(item for item in notes))

# 创建一个音高到音符的映射字典
note_to_int = dict((note, number) for number, note in enumerate(pitchnames))

network_input = []
network_output = []

# 创建输入序列和与之对应的输出
for i in range(0, len(notes) - sequence_length, 1):
    sequence_in = notes[i:i + sequence_length]
    sequence_out = notes[i + sequence_length]
    network_input.append([note_to_int[char] for char in sequence_in])
    network_output.append(note_to_int[sequence_out])

n_patterns = len(network_input)

# 整理输入格式使之与 LSTM 兼容
network_input = numpy.reshape(network_input, (n_patterns, sequence_length, 1))
# 归一化输入
network_input = network_input / float(n_vocab)

network_output = np_utils.to_categorical(network_output)
```

在这段示例代码汇总，我们把每一个序列的长度都设为 100 个音符或者和弦。这意味着要想去在序列中去预测下一个音符，网络已经有 100 个音符来帮助预测了。我极其推荐使用不同长度的序列去训练网络然后观察这些不同长度的序列对由网络产生的音乐的影响。

为网络准备数据的最后一步是将输入归一化处理并且 [one-hot 编码输出](https://machinelearningmastery.com/why-one-hot-encode-data-in-machine-learning/)。

### 模型

最后我们来设计这个模型的架构。在模型中我们使用到了四种不同类型的层：

**LSTM 层**是一个循环的神经网络层，它把一个序列作为输入然后返回另一个序列（返回序列的值为真）或者一个矩阵。

**Dropout 层**是一个正则化规则，这其中包含了在训练期间每次更新时将输入单位的一小部分置于 0，以防止过拟合。它由和层一起使用的参数决定。

**Dense 层**或 **fully connected 层**是一个完全连接神经网络的层，这里的每一个输入节点都连接着输出节点。

**The Activation 层**决定使用神经网络中的哪个激活函数去计算输出节点。

```python
model = Sequential()
    model.add(LSTM(
        256,
        input_shape=(network_input.shape[1], network_input.shape[2]),
        return_sequences=True
    ))
    model.add(Dropout(0.3))
    model.add(LSTM(512, return_sequences=True))
    model.add(Dropout(0.3))
    model.add(LSTM(256))
    model.add(Dense(256))
    model.add(Dropout(0.3))
    model.add(Dense(n_vocab))
    model.add(Activation('softmax'))
    model.compile(loss='categorical_crossentropy', optimizer='rmsprop')
```

既然我们有关于不同层的一些信息，那就把它们加到神经网络的模型中。

对于每一个 LSTM，Dense 和 Activation 层，第一个参数是层里应该有多少节点。对于 Dropout 层，第一个参数是输入单元中应该在训练中被舍弃的输入单元的片段。

对于第一层我们必须提供一个唯一的，名字是 *input_shape* 的参数。这个参数决定了网络中将要训练的数据的格式。

最后一层应该始终包含和我们输出不同结果数量相同的节点。这确保网络的输出将直接映射到我们的类里。

在这里我们将使用一个简单的，包含三个 LSTM 层、三个 Dropout 层、两个 Dense 层和一个 activation 层的网络。我推荐调整网络的结构，观察你是否可以提高预测的质量。

为了计算每次迭代的损失，我们将使用 [分类交叉熵]，(https://rdipietro.github.io/friendly-intro-to-cross-entropy-loss/)因为我们每次输出属于一个简单类并且我们有不止两个以上的类在为此工作。为了优化网络我们将使用 RMSprop 优化器。通常对于循环神经网络，使用它算是一个好的选择。

```python
filepath = "weights-improvement-{epoch:02d}-{loss:.4f}-bigger.hdf5"    

checkpoint = ModelCheckpoint(
    filepath, monitor='loss', 
    verbose=0,        
    save_best_only=True,        
    mode='min'
)    
callbacks_list = [checkpoint]     

model.fit(network_input, network_output, epochs=200, batch_size=64, callbacks=callbacks_list)
```

一旦我们决定了网络的结构，就应该开始训练了。使用 Kearas 里的 `model.fit()` 函数来训练网络。第一个参数是我们早前准备的输入序列表，而第二个参数是它们各自输出的列表。在本教程中我们将训练网络进行 200 次迭代，每一个批次都是通过包含了 60 个分支的网络增殖的。

为了确保我们可以在任何时间点停止训练而不会将之前的努力付之东流，我们将使用 model checkpionts（模型检查点）。它为我们提供了一种方法，把每次迭代之后的网络节点的权重保存到一个文件中。这使我们一旦对损失值满意了就可以停掉神经网络而不必担心失去权重值。否则我们必须一直等待直到网络完成所有的 200 次迭代次数才能把权重保存到文件中。

## 创作音乐

既然我们已经完成了训练网络，是时候享受一下我们花了几个小时训练的网络了。

为了能用神经网络去创作音乐，你得把它恢复到原来的状态。简言之我们将再次使用训练部分中的代码，用之前的方式去准备数据和建立网络模型。这并不是重新训练网络，而是把之前网络中的权重加载到模型中。

```python
model = Sequential()
model.add(LSTM(
    512,
    input_shape=(network_input.shape[1], network_input.shape[2]),
    return_sequences=True
))
model.add(Dropout(0.3))
model.add(LSTM(512, return_sequences=True))
model.add(Dropout(0.3))
model.add(LSTM(512))
model.add(Dense(256))
model.add(Dropout(0.3))
model.add(Dense(n_vocab))
model.add(Activation('softmax'))
model.compile(loss='categorical_crossentropy', optimizer='rmsprop')

# 给每一个音符赋予权重
model.load_weights('weights.hdf5')
```

现在我们可以使用训练好的模型去开始创作音符了。

因为我们有一个完整的音符序列表，我们将在列表中选择任意一个索引作为起始点，这允许我们不需要做任何修改就能重新运行代码并且每次都能返回不同的结果。但是，如果希望控制起始点，只需用命令行参数替换随机函数即可。

这里我也需要写一个映射函数去编码网络的输出。这个函数将数值数据映射成分类数据（把整数变成音符）。

```python
start = numpy.random.randint(0, len(network_input)-1)

int_to_note = dict((number, note) for number, note in enumerate(pitchnames))

pattern = network_input[start]
prediction_output = []

# 生成 500 个音符
for note_index in range(500):
    prediction_input = numpy.reshape(pattern, (1, len(pattern), 1))
    prediction_input = prediction_input / float(n_vocab)

    prediction = model.predict(prediction_input, verbose=0)

    index = numpy.argmax(prediction)
    result = int_to_note[index]
    prediction_output.append(result)

    pattern.append(index)
    pattern = pattern[1:len(pattern)]
```

我们选择使用网络去创作 500 个音符是因为这大约是两分钟的音乐，而且给了网络充足的空间去创造旋律。想要制作任何一个音符我们都必须给网络提交一个序列。我们提交的第一个序列是开始位置的音符序列。对于我们用作输入的每个后续序列，我们将删除序列的第一个音符，并在序列末尾插入上一个迭代的输出，如图 2 所示。
 
![图 2: 第一个输入列是 ABCDE。把它入网络得到的输出是 F。对于下一次的迭代，我们把 A 从列表里移除，并把 F 追加进去。然后重复这步骤。](https://cdn-images-1.medium.com/max/2000/1*lsMVJ484dEqIVMFyJ1gV2g.jpeg)

图 2：第一个输入列是 ABCDE。我们依靠网络从流里得到的输出是 F。对于下一次的迭代，我们把 A 从列表里移除，并把 F 追加进去。然后重复这步骤。

为了从网络的输出中确定出最准确的预测，我们抽取了值最大的索引。输出汇数组中，索引为 *X* 的列可能对应于下一个音符的 *X*。图三帮助解释这个。

![图 3: 我们看到在一个从网络到类的输出预测的映射。正如我们看到的，下一个值最可能是 D，因此我们选择 D 最为最可能的类。](https://cdn-images-1.medium.com/max/2000/1*YpnnaPA1Sm8rzTR4N2knKQ.jpeg)

图 3：我们看到在一个从网络到类的输出预测的映射。正如我们看到的，下一个值最可能是 D，因此我们选择 D 为最可能的音高集合。

之后我们把网络的所有输出搜集，放到一个单一数组中。

既然我们有了数组中所有的音符与和弦的编码，我们可以开始解码它们并且创造一个音符与和弦对象的数组。

首先必须确定我们解码后的输出是音符还是和弦。

如果模式是**和弦**，我们必须将音符串拆分成一组音符。然后我们循环遍历每个音符的字符串表示，并为每个音符创建一个音符对象。然后我们可以创建一个包含每个音符的和弦对象。

如果输出是一个**音符**，我们使用模式中包含的音高字符串表示创建一个音符对象。

在每次迭代的结尾我们增加 0.5 的偏移时间并且把音符/和弦对象追加到一个列表中。

```python
offset = 0
output_notes = []

# 基于模型生成的值来创建音符与和弦

for pattern in prediction_output:
    # 输出是和弦
    if ('.' in pattern) or pattern.isdigit():
        notes_in_chord = pattern.split('.')
        notes = []
        for current_note in notes_in_chord:
            new_note = note.Note(int(current_note))
            new_note.storedInstrument = instrument.Piano()
            notes.append(new_note)
        new_chord = chord.Chord(notes)
        new_chord.offset = offset
        output_notes.append(new_chord)
    # 输出是音符
    else:
        new_note = note.Note(pattern)
        new_note.offset = offset
        new_note.storedInstrument = instrument.Piano()
        output_notes.append(new_note)

    # 增加每次迭代的偏移量使音符不会堆叠
    offset += 0.5
```

在用网络创造音符与和弦的列表之后，我们可以使用这个列表创造一个 Music21 流对象，它使用此列表作为一个参数。最后，为了创建包含网络生成的音乐的 MIDI 文件，我们使用 Music21 工具包中的 *write* 函数将流写入文件中。

```python
midi_stream = stream.Stream(output_notes)

midi_stream.write('midi', fp='test_output.mid')
```

### 结果

现在是见证奇迹的时刻。图 4 包含了一页通过 LSTM 神经网络创作的音乐乐谱。瞅一眼就能看到它的结构，这在第二页的第三行到最后一行尤为明显。

有音乐常识，能阅读乐谱的人呢可以看到在这一页里有一些奇怪的音符。这就是网络不能创作完美的旋律的结果。在我们目前的成果里将总会有一些错误的音符。如果想获得更好的结果我们得有更大的网络才行。

![图 4:通过 LSTM 网络生成的乐谱](https://cdn-images-1.medium.com/max/2836/1*tzfrAkHCbGjBXA5ZOthjrw.png)

图 4:通过 LSTM 网络生成的乐谱

这个相对较浅的网络的结果仍然令人印象深刻，从示例音乐中可以听到。对于那些感兴趣的人来说，图 4 中的乐谱代表了神经网络创作音乐迈出了一大步。

[https://w.soundcloud.com/player/?referrer=https%3A%2F%2Ftowardsdatascience.com%2Fmedia%2Fd721bab5c62c8061387ced1869dcdf5b%3FpostId%3D68786834d4c5&amp;show_artwork=true&amp;url=http%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F362886486](https://w.soundcloud.com/player/?referrer=https%3A%2F%2Ftowardsdatascience.com%2Fmedia%2Fd721bab5c62c8061387ced1869dcdf5b%3FpostId%3D68786834d4c5&amp;show_artwork=true&amp;url=http%3A%2F%2Fapi.soundcloud.com%2Fplaylists%2F362886486)

## 未来的工作

我们用一个简单的 LSTM 网络和 352 个音高实现了这个非凡的成果。不过，有一些地方还有待提高。

首先，目前实现的结果不支持音符的多种音长和音符间的偏移。我们要为添加为不同音长服务的音高和代表音符停顿时间的音调。

为了通过增加音调来获得满意的结果我们也必须增加 LSTM 网络的深度，这需要性能更高的计算机去完成。我自用的笔记本电脑大约需要两个小时去训练网络。

第二，为乐章增加前奏和结尾。现在网络在两个乐章之间没有间隔，网络不知道一个章节的结尾和另一个的开始在哪里。这允许网络从前奏到结束地创作一个章节而不是像现在这样突然的结束创作。

第三，增加一个方法去处理未知的音符。目前的情况是如果网络遇到一个它不认识的音符，它就会返回状态失败。解决这个方法的可能方案是去寻找一个和未知音符最相似的音符或者和弦。

最后，为数据集增加更多的乐器（的音乐）。现在网络仅仅支持只有一种单一乐器的作品。如果可以扩展到一整个管弦乐队那将会是非常有趣的。

## 结语

在本教程中我们演示了如何创建一个 LSTM 神经网络去创作音乐。也许这个结果不尽如人意，但它们还是让人印象深刻。而且它向我们展示了，神经网络可以创作音乐并且可以被用来帮助人们创作更复杂的音乐作品。

[在 GitHub 仓库查看本教程](https://github.com/Skuldur/Classical-Piano-Composer)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
