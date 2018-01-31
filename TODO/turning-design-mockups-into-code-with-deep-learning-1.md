> * 原文地址：[Turning Design Mockups Into Code With Deep Learning - Part 1](https://blog.floydhub.com/turning-design-mockups-into-code-with-deep-learning/)
> * 原文作者：[Emil Wallner](https://twitter.com/EmilWallner)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-1.md)
> * 译者：[sakila1012](https://github.com/sakila1012)
> * 校对者：[sunshine940326](https://github.com/sunshine940326)，[wzy816](https://github.com/wzy816)

# 使用深度学习自动生成 HTML 代码 - 第 1 部分

- [使用深度学习自动生成HTML代码 - 第 1 部分](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-1.md)
- [使用深度学习自动生成HTML代码 - 第 2 部分](https://github.com/xitu/gold-miner/blob/master/TODO/turning-design-mockups-into-code-with-deep-learning-2.md)

在未来三年来，深度学习将改变前端的发展。它将会加快原型设计的速度和降低开发软件的门槛。

Tony Beltramelli 去年发布了[pix2code 论文](https://arxiv.org/abs/1705.07962)，Airbnb 也发布了 [sketch2code](https://airbnb.design/sketching-interfaces/)。

目前，自动化前端开发的最大屏障是计算能力。但我们可以使用目前的深度学习算法，以及合成训练数据来探索人工智能前端自动化的方法。

在本文中，作者将教大家神经网络学习如何基于一张图片和一个设计原型来编写一个 HTML 和 CSS 网站。下面是该过程的简要概述：

### 1) 向训练的神经网络输入一个设计图

![](https://blog.floydhub.com/static/image_to_notebookfile-3354b407064e4d95a0217612a5463434-6c1a3.png)

### 2) 神经网络将图片转换为 HTML 标记语言

![](/generate_html_markup-b6ceec69a7c9cfd447d188648049f2a4.gif)

### 3) 渲染输出

![](https://blog.floydhub.com/static/render_example-4c9df7e5e8bb455c71dd7856acca7aae-6c1a3.png)

我们将分三个版本来构建神经网络。

在第 1 个版本，我们构建最简单地版本来掌握移动部分。第 2 个版本，HTML 专注于自动化所有步骤，并简要神经网络层。最后一个 Bootstrap 版本，我们将创建一个模型来思考和探索 LSTM 层。

所有的代码准备在 [Github](https://github.com/emilwallner/Screenshot-to-code-in-Keras/blob/master/README.md) 上和在 Jupyter 笔记本上的 [FloydHub](https://www.floydhub.com/emilwallner/projects/picturetocode)。所有 FloydHub notebook 都在 floydhub 目录中，本地 notebook 在 local 目录中。

本文中的模型构建是基于 Beltramelli 的论文 [pix2code](https://arxiv.org/abs/1705.07962) 和 Jason Brownlee 的[图像描述生成教程](https://machinelearningmastery.com/blog/page/2/)。代码是由 Python 和 Keras 编写，使用 TensorFolw 框架。

如果你是深度学习的新手，我建议你尝试使用下 Python，反向传播和卷积神经网络。可以从我早期个在 FloyHub 博客上发表的文章开始学习 [[1]](https://blog.floydhub.com/my-first-weekend-of-deep-learning/) [[2]](https://blog.floydhub.com/coding-the-history-of-deep-learning/) [[3]](https://blog.floydhub.com/colorizing-b&w-photos-with-neural-networks/)。

## 核心逻辑

让我们回顾一下我们的目标。我们的目标是构建一个神经网络，能够生成与截图对应的 HTML/CSS。

当你训练神经网络时，你先提供几个截图和对应的 HTML 代码。

网络通过逐个预测所有匹配的 HTML 标记语言来学习。预测下一个标记语言的标签时，网络接收到截图和之前所有正确的标记。

这里是一个在 Google Sheet [简单的训练数据示例](https://docs.google.com/spreadsheets/d/1xXwarcQZAHluorveZsACtXRdmNFbwGtN3WMNhcTdEyQ/edit?usp=sharing)。

创建逐词预测的模型是现在最常用的方法。这里也有[其他方法](https://docs.google.com/spreadsheets/d/1xXwarcQZAHluorveZsACtXRdmNFbwGtN3WMNhcTdEyQ/edit?usp=sharing)，但该方法也是本教程使用的方法。

注意：每次预测时，神经网络接收的是同样的截图。如果网络需要预测 20 个单词，它就会得到 20 次同样的设计截图。现在，不用管神经网络的工作原理，只需要专注于神经网络的输入和输出。

![](https://blog.floydhub.com/static/neural_network_overview-82bea09299f242ad5d6e1236b9661ec6-6c1a3.png)

我们先来看前面的标记（markup）。假如我们训练神经网络的目的是预测句子“I can code”。当网络接收“I”时，预测“can”。下一次时，网络接收“I can”，预测“code”。它接收所有前面的单词，但只预测下一个单词。

![](https://blog.floydhub.com/static/input_and_output_data-555f7b04c75a202041f0a4438af5cd51-6c1a3.png)

神经网络根据数据创建特征。神经网络构建特征以连接输入数据和输出数据。它必须创建表征来理解每个截图的内容和它所需要预测的 HTML 语法，这些都是为预测下一个标记构建知识。

把训练好的模型应用到真实世界中和模型训练过程差不多。我们无需输入正确的 HTML 标记，网络会接收它目前生成的标记，然后预测下一个标记。预测从「起始标签」（start tag）开始，到「结束标签」（end tag）终止，或者达到最大限制时终止

![](https://blog.floydhub.com/static/model_prediction-801ad7af1d2205276ba64fdc6d7c7ec8-6c1a3.png)

## **Hello World 版本**

现在让我们构建 Hello World 版实现。我们将发送一张带有「Hello World！」字样的截屏到神经网络中，并训练它生成对应的标记语言。

![](/hello_world_generation-039d78c27eb584fa639b89d564b94772.gif)

首先，神经网络将原型设计转换为一组像素值。且每一个像素点有 RGB 三个通道，每个通道的值都在 0-255 之间。

![](https://blog.floydhub.com/static/website_pixels-6f11057880ea91a87ddc087c27d063a7-6c1a3.png)

为了以神经网络能理解的方式表征这些标记，我使用了 [one-hot 编码](https://machinelearningmastery.com/how-to-one-hot-encode-sequence-data-in-python/)。因此句子「I can code」可以映射为以下形式。

![](https://blog.floydhub.com/static/one_hot_encoding-2a72d2b794b26e6e4c4cc9c5f8bd4649-6c1a3.png)

在上图中，我们的编码包含了开始和结束的标签。这些标签能为神经网络提供开始预测和结束预测的位置信息。

对于输入的数据，我们使用语句，从第一个单词开始，然后依次相加。输出的数据总是一个单词。

语句和单词的逻辑一样。这也需要同样的输入长度。他们没有被词汇限制，而是受句子长度的限制。如果它比最大长度短，你用空的单词填充它，一个只有零的单词。

![](https://blog.floydhub.com/static/one_hot_sentence-6b3c930c8a7808b928639201cac78ebe-6c1a3.png) 

正如你所看到的，单词是从右到左打印的。对于每次训练，强制改变每个单词的位置。这需要模型学习序列而不是记住每个单词的位置。

在下图中有四个预测。每一列是一个预测。左边是颜色呈现的三个颜色通道：红绿蓝和上一个单词。在括号外面，预测是一个接一个，以红色的正方形表示结束。

![](https://blog.floydhub.com/static/model_function-068c180c2ba3efdbb54193f21a5d5d7d-6c1a3.png) 

```
    #Length of longest sentence
    max_caption_len = 3
    #Size of vocabulary 
    vocab_size = 3

    # Load one screenshot for each word and turn them into digits 
    images = []
    for i in range(2):
        images.append(img_to_array(load_img('screenshot.jpg', target_size=(224, 224))))
    images = np.array(images, dtype=float)
    # Preprocess input for the VGG16 model
    images = preprocess_input(images)

    #Turn start tokens into one-hot encoding
    html_input = np.array(
                [[[0., 0., 0.], #start
                 [0., 0., 0.],
                 [1., 0., 0.]],
                 [[0., 0., 0.], #start <HTML>Hello World!</HTML>
                 [1., 0., 0.],
                 [0., 1., 0.]]])

    #Turn next word into one-hot encoding
    next_words = np.array(
                [[0., 1., 0.], # <HTML>Hello World!</HTML>
                 [0., 0., 1.]]) # end

    # Load the VGG16 model trained on imagenet and output the classification feature
    VGG = VGG16(weights='imagenet', include_top=True)
    # Extract the features from the image
    features = VGG.predict(images)

    #Load the feature to the network, apply a dense layer, and repeat the vector
    vgg_feature = Input(shape=(1000,))
    vgg_feature_dense = Dense(5)(vgg_feature)
    vgg_feature_repeat = RepeatVector(max_caption_len)(vgg_feature_dense)
    # Extract information from the input seqence 
    language_input = Input(shape=(vocab_size, vocab_size))
    language_model = LSTM(5, return_sequences=True)(language_input)

    # Concatenate the information from the image and the input
    decoder = concatenate([vgg_feature_repeat, language_model])
    # Extract information from the concatenated output
    decoder = LSTM(5, return_sequences=False)(decoder)
    # Predict which word comes next
    decoder_output = Dense(vocab_size, activation='softmax')(decoder)
    # Compile and run the neural network
    model = Model(inputs=[vgg_feature, language_input], outputs=decoder_output)
    model.compile(loss='categorical_crossentropy', optimizer='rmsprop')

    # Train the neural network
    model.fit([features, html_input], next_words, batch_size=2, shuffle=False, epochs=1000)
```
在 Hello World 版本中，我们使用三个符号「start」、「Hello World」和「end」。字符级的模型要求更小的词汇表和受限的神经网络，而单词级的符号在这里可能有更好的性能。

以下是执行预测的代码：

```
    # Create an empty sentence and insert the start token
    sentence = np.zeros((1, 3, 3)) # [[0,0,0], [0,0,0], [0,0,0]]
    start_token = [1., 0., 0.] # start
    sentence[0][2] = start_token # place start in empty sentence

    # Making the first prediction with the start token
    second_word = model.predict([np.array([features[1]]), sentence])

    # Put the second word in the sentence and make the final prediction
    sentence[0][1] = start_token
    sentence[0][2] = np.round(second_word)
    third_word = model.predict([np.array([features[1]]), sentence])

    # Place the start token and our two predictions in the sentence 
    sentence[0][0] = start_token
    sentence[0][1] = np.round(second_word)
    sentence[0][2] = np.round(third_word)

    # Transform our one-hot predictions into the final tokens
    vocabulary = ["start", "<HTML><center><H1>Hello World!</H1></center></HTML>", "end"]
    for i in sentence[0]:
        print(vocabulary[np.argmax(i)], end=' ')
```

## 输出

* **10 epochs:** `start start start`
* **100 epochs:** `start <HTML><center><H1>Hello World!</H1></center></HTML> <HTML><center><H1>Hello World!</H1></center></HTML>`
* **300 epochs:** `start <HTML><center><H1>Hello World!</H1></center></HTML> end`


* **在收集数据之前构建第一个版本。**在本项目的早期阶段，我设法获得 Geocities 托管网站的旧版存档，它有 3800 万的网站。但我忽略了减少 100K 大小词汇所需要的巨大工作量。

* **处理一个 TB 级的数据需要优秀的硬件或极其有耐心。**在我的 Mac 遇到几个问题后，最终用上了强大的远程服务器。我预计租用 8 个现代 CPU 和 1 GPS 内部链接以运行我的工作流。

* **在理解输入与输出数据之前，其它部分都似懂非懂。**输入 X 是屏幕的截图和以前标记的标签，输出 Y 是下一个标记的标签。当我理解这一点时，其它问题都更加容易弄清了。此外，尝试其它不同的架构也将更加容易。

* **注意兔子洞。**由于这个项目与深度学习有关联的，我在这个过程中被很多兔子洞卡住了。我花了一个星期从无到有的编程RNNs，太着迷于嵌入向量空间，并被一些奇奇怪怪的实现方法所诱惑。

* **图片到代码的网络其实就是自动描述图像的模型。**即使我意识到了这一点，但仍然错过了很多自动图像摘要方面的论文，因为它们看起来不够炫酷。一旦我意识到了这一点，我对问题空间的理解就变得更加深刻了。

## 在 FloyHub 上运行代码

FloydHub 是一个深度学习训练平台，我自从开始学习深度学习时就对它有所了解，我也常用它训练和管理深度学习实验。我们可以安装并在 10 分钟内运行第一个模型，它是在云 GPU 上训练模型最好的选择。

如果读者没用过 FloydHub，你可以用[ 2 分钟安装](https://www.floydhub.com/) 或者观看 [5 分钟视频](https://www.youtube.com/watch?v=byLQ9kgjTdQ&t=21s)。

拷贝仓库

```
git clone https://github.com/emilwallner/Screenshot-to-code-in-Keras.git
```

登录并初始化 FloyHub 命令行工具

```
cd Screenshot-to-code-in-Keras
floyd login
floyd init s2c
```

在 FloydHub 云 GPU 机器上运行 Jupyter notebook：

```
floyd run --gpu --env tensorflow-1.4 --data emilwallner/datasets/imagetocode/2:data --mode jupyter
```

所有的 notebooks 都放在 floydbub 目录下。本地等同于本地目录下。一旦我们开始运行模型，那么在 floydhub/Hello_world/hello_world.ipynb 下可以找到第一个 Notebook。

如果你想了解更多的指南和对 flags 的解释，请查看我[早期的文章](https://blog.floydhub.com/colorizing-b&w-photos-with-neural-networks/)。

## HTML 版本

在这个版本中，我们将从 Hello World 模型自动化很多步骤，并关注与创建一个可扩展的神经网络模型。

该版本并不能直接从随机网页预测 HTML，但它是探索动态问题不可缺少的步骤。
![](/html_generation-2476413d4299a3a8b407ee9cdb6774b6.gif)

### 概览

如果我们将前面的架构扩展为以下图展示的结构。

![](https://blog.floydhub.com/static/model_more_details-68db3bf26f6df205ffe4c541ace33a92-6c1a3.png) 

该架构主要有两个部分。首先，编码器。编码器是我们创建图像特征和前面标记特征（markup features）的地方。特征是网络创建原型设计和标记语言之间联系的构建块。在编码器的末尾，我们将图像特征传递给前面标记的每一个单词。

然后，解码器将结合原型设计特征和标记特征以创建下一个标签的特征，这一个特征可以通过全连接层预测下一个标签。

##### 设计原型的特征

因为我们需要为每个单词插入一个截屏，这将会成为训练神经网络[案例](https://docs.google.com/spreadsheets/d/1xXwarcQZAHluorveZsACtXRdmNFbwGtN3WMNhcTdEyQ/edit#gid=0)的瓶颈。因此我们抽取生成标记语言所需要的信息来替代直接使用图像。

这些抽取的信息将通过预训练的 CNN 编码到图像特征中。这个模型是在 Imagenet 上预先训练好的。

我们将使用分类层之前的层级输出以抽取特征。

![](https://blog.floydhub.com/static/ir2_to_image_features-5455a0516284ac036482417b56a57d49-6c1a3.png) 

我们最终得到 1536 个 8x8 的特征图，虽然我们很难直观地理解它，但神经网络能够从这些特征中抽取元素的对象和位置。

##### 标记特征

在 Hello World 版本中，我们使用 one-hot 编码以表征标记。而在该版本中，我们将使用词嵌入表征输入并使用 one-hot 编码表示输出。

我们构建每个句子的方式保持不变，但我们映射每个符号的方式将会变化。one-hot 编码将每一个词视为独立的单元，而词嵌入会将输入数据表征为一个实数列表，这些实数表示标记标签之间的关系。

![](https://blog.floydhub.com/static/embedding-2146c151fd4dbf5dcce6257444931a79-6c1a3.png) 

上面词嵌入的维度为 8，但一般词嵌入的维度会根据词汇表的大小在 50 到 500 间变动。

以上每个单词的八个数值就类似于神经网络中的权重，它们倾向于刻画单词之间的联系（[Mikolov alt el., 2013](https://arxiv.org/abs/1301.3781)）。

这就是我们开始部署标记特征（markup features）的方式，而这些神经网络训练的特征会将输入数据和输出数据联系起来。现在，不用担心他们是什么，我们将在下一部分进一步深入挖掘。

### 编码器

我们现在将词嵌入馈送到 LSTM 中，并期望能返回一系列的标记特征。这些标记特征随后会馈送到一个 Time Distributed 密集层，该层级可以视为有多个输入和输出的全连接层。

![](https://blog.floydhub.com/static/encoder-78498407f393e83128abed5eec86dd4c-6c1a3.png) 

对于另一个平行的过程，其中图像特征首先会展开成一个向量，然后再馈送到一个全连接层而抽取出高级特征。这些图像特征随后会与标记特征相级联而作为编码器的输出。

这个有点难理解，让我来分步描述一下。

##### 标记特征

如下图所示，现在我们将词嵌入投入到 LSTM 层中，所有的语句都填充上最大的三个记号。

![](https://blog.floydhub.com/static/word_embedding_markup_feature-d4e76483527fefd10742c0ddc1cd3227-6c1a3.png) 

为了混合信号并寻找高级模式，我们运用了一个 TimeDistributed 密集层以抽取标记特征。TimeDistributed 密集层和一般的全连接层非常相似，且它有多个输入与输出。

##### 图像特征

同时，我们需要将图像的所有像素值展开成一个向量，因此信息不会被改变，只是重组了一下。

![](https://blog.floydhub.com/static/image_feature_to_image_feature-77a1cf39ed251d4243b90325e60fbdf5-6c1a3.png) 

如上，我们会通过全连接层混合信号并抽取更高级的概念。因为我们并不只是处理一个输入值，因此使用一般的全连接层就行了。

在这个案例中，它有三个标记特征。因此，我们最终得到的图像特征和标记特征是同等数量的。

##### 级联图像特征和标记特征

所有的语句都被填充以创建三个标记特征。因为我们已经预处理了图像特征，所以我们能为每一个标记特征添加图像特征。

![](https://blog.floydhub.com/static/concatenate-747c07d8c62a2e026212d20860514188-6c1a3.png) 

如上，在复制图像特征到对应的标记特征后，我们得到了三个新的图像-标记特征（image-markup features），这就是我们馈送到解码器的输入值。

### 解码器

现在，我们使用图像-标记特征来预测下一个标签。

![](https://blog.floydhub.com/static/decoder-1592aedab9a95e07a513234aa258d777-6c1a3.png) 

在下面的案例中，我们使用三个图像-标签特征对来输出下一个标签特征。

注意 LSTM 层不应该返回一个长度等于输入序列的向量，而只需要预测预测一个特征。在我们的案例中，这个特征将预测下一个标签，它包含了最后预测的信息。

![](https://blog.floydhub.com/static/image-markup-feature_to_vocab-eb39368b3f466914c9383d532675a622-6c1a3.png) 

##### 最后的预测

全连接层会像传统前馈网络那样工作，它将下一个标签特征中的 512 个值与最后的四个预测连接起来，即我们在词汇表所拥有的四个单词：start、hello、world 和 end。

词汇的预测值可能是 [0.1, 0.1, 0.1, 0.7]。密集层最后采用的 softmax 激活函数会为四个类别产生一个 0-1 概率分布，所有预测值的和等于 1。在这个案例中，例如将预测第四个词为下一个标签。然后，你可以将 one-hot 编码 [0, 0, 0, 1] 转译成映射的值，也就是 “end”。

```
    # Load the images and preprocess them for inception-resnet
    images = []
    all_filenames = listdir('images/')
    all_filenames.sort()
    for filename in all_filenames:
        images.append(img_to_array(load_img('images/'+filename, target_size=(299, 299))))
    images = np.array(images, dtype=float)
    images = preprocess_input(images)

    # Run the images through inception-resnet and extract the features without the classification layer
    IR2 = InceptionResNetV2(weights='imagenet', include_top=False)
    features = IR2.predict(images)

    # We will cap each input sequence to 100 tokens
    max_caption_len = 100
    # Initialize the function that will create our vocabulary 
    tokenizer = Tokenizer(filters='', split=" ", lower=False)

    # Read a document and return a string
    def load_doc(filename):
        file = open(filename, 'r')
        text = file.read()
        file.close()
        return text

    # Load all the HTML files
    X = []
    all_filenames = listdir('html/')
    all_filenames.sort()
    for filename in all_filenames:
        X.append(load_doc('html/'+filename))

    # Create the vocabulary from the html files
    tokenizer.fit_on_texts(X)

    # Add +1 to leave space for empty words
    vocab_size = len(tokenizer.word_index) + 1
    # Translate each word in text file to the matching vocabulary index
    sequences = tokenizer.texts_to_sequences(X)
    # The longest HTML file
    max_length = max(len(s) for s in sequences)

    # Intialize our final input to the model
    X, y, image_data = list(), list(), list()
    for img_no, seq in enumerate(sequences):
        for i in range(1, len(seq)):
            # Add the entire sequence to the input and only keep the next word for the output
            in_seq, out_seq = seq[:i], seq[i]
            # If the sentence is shorter than max_length, fill it up with empty words
            in_seq = pad_sequences([in_seq], maxlen=max_length)[0]
            # Map the output to one-hot encoding
            out_seq = to_categorical([out_seq], num_classes=vocab_size)[0]
            # Add and image corresponding to the HTML file
            image_data.append(features[img_no])
            # Cut the input sentence to 100 tokens, and add it to the input data
            X.append(in_seq[-100:])
            y.append(out_seq)

    X, y, image_data = np.array(X), np.array(y), np.array(image_data)

    # Create the encoder
    image_features = Input(shape=(8, 8, 1536,))
    image_flat = Flatten()(image_features)
    image_flat = Dense(128, activation='relu')(image_flat)
    ir2_out = RepeatVector(max_caption_len)(image_flat)

    language_input = Input(shape=(max_caption_len,))
    language_model = Embedding(vocab_size, 200, input_length=max_caption_len)(language_input)
    language_model = LSTM(256, return_sequences=True)(language_model)
    language_model = LSTM(256, return_sequences=True)(language_model)
    language_model = TimeDistributed(Dense(128, activation='relu'))(language_model)

    # Create the decoder
    decoder = concatenate([ir2_out, language_model])
    decoder = LSTM(512, return_sequences=False)(decoder)
    decoder_output = Dense(vocab_size, activation='softmax')(decoder)

    # Compile the model
    model = Model(inputs=[image_features, language_input], outputs=decoder_output)
    model.compile(loss='categorical_crossentropy', optimizer='rmsprop')

    # Train the neural network
    model.fit([image_data, X], y, batch_size=64, shuffle=False, epochs=2)

    # map an integer to a word
    def word_for_id(integer, tokenizer):
        for word, index in tokenizer.word_index.items():
            if index == integer:
                return word
        return None

    # generate a description for an image
    def generate_desc(model, tokenizer, photo, max_length):
        # seed the generation process
        in_text = 'START'
        # iterate over the whole length of the sequence
        for i in range(900):
            # integer encode input sequence
            sequence = tokenizer.texts_to_sequences([in_text])[0][-100:]
            # pad input
            sequence = pad_sequences([sequence], maxlen=max_length)
            # predict next word
            yhat = model.predict([photo,sequence], verbose=0)
            # convert probability to integer
            yhat = np.argmax(yhat)
            # map integer to word
            word = word_for_id(yhat, tokenizer)
            # stop if we cannot map the word
            if word is None:
                break
            # append as input for generating the next word
            in_text += ' ' + word
            # Print the prediction
            print(' ' + word, end='')
            # stop if we predict the end of the sequence
            if word == 'END':
                break
        return

    # Load and image, preprocess it for IR2, extract features and generate the HTML
    test_image = img_to_array(load_img('images/87.jpg', target_size=(299, 299)))
    test_image = np.array(test_image, dtype=float)
    test_image = preprocess_input(test_image)
    test_features = IR2.predict(np.array([test_image]))
    generate_desc(model, tokenizer, np.array(test_features), 100)
```


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
