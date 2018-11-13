> * 原文地址：[Introduction to 1D Convolutional Neural Networks in Keras for Time Sequences](https://blog.goodaudience.com/introduction-to-1d-convolutional-neural-networks-in-keras-for-time-sequences-3a7ff801a2cf)
> * 原文作者：[Nils Ackermann](https://blog.goodaudience.com/@nils.ackermann?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-1d-convolutional-neural-networks-in-keras-for-time-sequences.md](https://github.com/xitu/gold-miner/blob/master/TODO1/introduction-to-1d-convolutional-neural-networks-in-keras-for-time-sequences.md)
> * 译者：[haiyang-tju](https://github.com/haiyang-tju)
> * 校对者：[lsvih](https://github.com/lsvih)

# 在 Keras 中使用一维卷积神经网络处理时间序列数据

### 概述

许多技术文章都关注于二维卷积神经网络（2D CNN）的使用，特别是在图像识别中的应用。而一维卷积神经网络（1D CNNs）只在一定程度上有所涉及，比如在自然语言处理（NLP）中的应用。目前很少有文章能够提供关于如何构造一维卷积神经网络来解决你可能正面临的一些机器学习问题。本文试图补上这样一个短板。

![](https://cdn-images-1.medium.com/max/1000/1*lRzUdVtTa0MdbZ3dRP67PA.jpeg)

### 何时应用 1D CNN？

CNN 可以很好地识别出数据中的简单模式，然后使用这些简单模式在更高级的层中生成更复杂的模式。当你希望从整体数据集中较短的（固定长度）片段中获得感兴趣特征，并且该特性在该数据片段中的位置不具有高度相关性时，1D CNN 是非常有效的。

1D CNN 可以很好地应用于传感器数据的时间序列分析（比如陀螺仪或加速度计数据）；同样也可以很好地用于分析具有固定长度周期的信号数据（比如音频信号）。此外，它还能应用于自然语言处理的任务（由于单词的接近性可能并不总是一个可训练模式的好指标，因此 LSTM 网络在 NLP 中的应用更有前途）。

### 1D CNN 和 2D CNN 之间有什么区别？

无论是一维、二维还是三维，卷积神经网络（CNNs）都具有相同的特点和相同的处理方法。关键区别在于输入数据的维数以及特征检测器（或滤波器）如何在数据之间滑动：

![](https://cdn-images-1.medium.com/max/800/1*aBN2Ir7y2E-t2AbekOtEIw.png)

“一维和二维卷积神经网络” 由 Nils Ackermann 根据知识共享 [CC BY-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0/) 许可下授权。

### 问题描述

在本文中，我们将专注于基于时间片的加速度传感器数据的处理，这些数据来自于用户的腰带式智能手机设备。基于 x、y 和 z 轴的加速度计数据，1D CNN 用来预测用户正在进行的活动类型（比如“步行”、“慢跑”或“站立”）。你可以在我的另外两篇文章中找到更多的信息 [这里](https://medium.com/@nils.ackermann/human-activity-recognition-har-tutorial-with-keras-and-core-ml-part-1-8c05e365dfa0) 和 [这里](https://medium.com/@nils.ackermann/human-activity-recognition-har-tutorial-with-keras-and-core-ml-part-2-857104583d94)。对于各种活动，在每个时间间隔上的数据看起来都与此类似。

![](https://cdn-images-1.medium.com/max/800/1*t2nFJAuI_Jfp0ZyxRpwRQg.png)

来自加速度计数据的时间序列样例

### 如何在 Python 中构造一个 1D CNN？

目前已经有许多得标准 CNN 模型可用。我选择了 [Keras 网站](https://keras.io/getting-started/sequential-model-guide/) 上描述的一个模型，并对它进行了微调，以适应前面描述的问题。下面的图片对构建的模型进行一个高级概述。其中每一层都将会进一步加以解释。

![](https://cdn-images-1.medium.com/max/1000/1*Y117iNR_CnBtBh8MWVtUDg.png)

“一维卷积神经网络示例” 由 Nils Ackermann 根据知识共享 [CC BY-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0/) 许可下授权。

让我们先来看一下对应的 Python 代码，以便构建这个模型：

```
model_m = Sequential()
model_m.add(Reshape((TIME_PERIODS, num_sensors), input_shape=(input_shape,)))
model_m.add(Conv1D(100, 10, activation='relu', input_shape=(TIME_PERIODS, num_sensors)))
model_m.add(Conv1D(100, 10, activation='relu'))
model_m.add(MaxPooling1D(3))
model_m.add(Conv1D(160, 10, activation='relu'))
model_m.add(Conv1D(160, 10, activation='relu'))
model_m.add(GlobalAveragePooling1D())
model_m.add(Dropout(0.5))
model_m.add(Dense(num_classes, activation='softmax'))
print(model_m.summary())
```

运行这段代码将得到如下的深层神经网络：

```
_________________________________________________________________
Layer (type)                 Output Shape              Param #   
=================================================================
reshape_45 (Reshape)         (None, 80, 3)             0         
_________________________________________________________________
conv1d_145 (Conv1D)          (None, 71, 100)           3100      
_________________________________________________________________
conv1d_146 (Conv1D)          (None, 62, 100)           100100    
_________________________________________________________________
max_pooling1d_39 (MaxPooling (None, 20, 100)           0         
_________________________________________________________________
conv1d_147 (Conv1D)          (None, 11, 160)           160160    
_________________________________________________________________
conv1d_148 (Conv1D)          (None, 2, 160)            256160    
_________________________________________________________________
global_average_pooling1d_29  (None, 160)               0         
_________________________________________________________________
dropout_29 (Dropout)         (None, 160)               0         
_________________________________________________________________
dense_29 (Dense)             (None, 6)                 966       
=================================================================
Total params: 520,486
Trainable params: 520,486
Non-trainable params: 0
_________________________________________________________________
None
```

让我们深入到每一层中，看看到底发生了什么：

*   **输入数据：** 数据经过预处理后，每条数据记录中包含有 80 个时间片（数据是以 20Hz 的采样频率进行记录的，因此每个时间间隔中就包含有 4 秒的加速度计数据）。在每个时间间隔内，存储加速度计的 x 轴、 y 轴和 z 轴的三个数据。这样就得到了一个 80 x 3 的矩阵。由于我通常是在 iOS 系统中使用神经网络的，所以数据必须平展成长度为 240 的向量后传入神经网络中。网络的第一层必须再将其变形为原始的 80 x 3 的形状。
*   **第一个 1D CNN 层：** 第一层定义了高度为 10（也称为卷积核大小）的滤波器（也称为特征检测器）。只有定义了一个滤波器，神经网络才能够在第一层中学习到一个单一的特征。这可能还不够，因此我们会定义 100 个滤波器。这样我们就在网络的第一层中训练得到 100 个不同的特性。第一个神经网络层的输出是一个 71 x 100 的矩阵。输出矩阵的每一列都包含一个滤波器的权值。在定义内核大小并考虑输入矩阵长度的情况下，每个过滤器将包含 71 个权重值。
*   **第二个 1D CNN 层：** 第一个 CNN 的输出结果将被输入到第二个 CNN 层中。我们将在这个网络层上再次定义 100 个不同的滤波器进行训练。按照与第一层相同的逻辑，输出矩阵的大小为 62 x 100。
*   **最大值池化层：** 为了减少输出的复杂度和防止数据的过拟合，在 CNN 层之后经常会使用池化层。在我们的示例中，我们选择了大小为 3 的池化层。这意味着这个层的输出矩阵的大小只有输入矩阵的三分之一。
*   **第三和第四个 1D CNN 层：** 为了学习更高层次的特征，这里又使用了另外两个 1D CNN 层。这两层之后的输出矩阵是一个 2 x 160 的矩阵。
*   **平均值池化层：** 多添加一个池化层，以进一步避免过拟合的发生。这次的池化不是取最大值，而是取神经网络中两个权重的平均值。输出矩阵的大小为 1 x 160 。每个特征检测器在神经网络的这一层中只剩下一个权重。
*   **Dropout 层：** Dropout 层会随机地为网络中的神经元赋值零权重。由于我们选择了 0.5 的比率，则 50% 的神经元将会是零权重的。通过这种操作，网络对数据的微小变化的响应就不那么敏感了。因此，它能够进一步提高对不可见数据处理的准确性。这个层的输出仍然是一个 1 x 160 的矩阵。
*   **使用 Softmax 激活的全连接层：** 最后一层将会把长度为 160 的向量降为长度为 6 的向量，因为我们有 6 个类别要进行预测（即 “慢跑”、“坐下”、“走路”、“站立”、“上楼”、“下楼”）。这里的维度下降是通过另一个矩阵乘法来完成的。Softmax 被用作激活函数。它强制神经网络的所有六个输出值的加和为一。因此，输出值将表示这六个类别中的每个类别出现的概率。

### 训练和测试该神经网络

下面是一段用以训练模型的 Python 代码，批大小为 400，其中训练集和验证集的分割比例是 80 比 20。

```
callbacks_list = [
    keras.callbacks.ModelCheckpoint(
        filepath='best_model.{epoch:02d}-{val_loss:.2f}.h5',
        monitor='val_loss', save_best_only=True),
    keras.callbacks.EarlyStopping(monitor='acc', patience=1)
]

model_m.compile(loss='categorical_crossentropy',
                optimizer='adam', metrics=['accuracy'])

BATCH_SIZE = 400
EPOCHS = 50

history = model_m.fit(x_train,
                      y_train,
                      batch_size=BATCH_SIZE,
                      epochs=EPOCHS,
                      callbacks=callbacks_list,
                      validation_split=0.2,
                      verbose=1)
```

该模型在训练数据上的准确率可达 97%。

```
...
Epoch 9/50
16694/16694 [==============================] - 16s 973us/step - loss: 0.0975 - acc: 0.9683 - val_loss: 0.7468 - val_acc: 0.8031
Epoch 10/50
16694/16694 [==============================] - 17s 989us/step - loss: 0.0917 - acc: 0.9715 - val_loss: 0.7215 - val_acc: 0.8064
Epoch 11/50
16694/16694 [==============================] - 17s 1ms/step - loss: 0.0877 - acc: 0.9716 - val_loss: 0.7233 - val_acc: 0.8040
Epoch 12/50
16694/16694 [==============================] - 17s 1ms/step - loss: 0.0659 - acc: 0.9802 - val_loss: 0.7064 - val_acc: 0.8347
Epoch 13/50
16694/16694 [==============================] - 17s 1ms/step - loss: 0.0626 - acc: 0.9799 - val_loss: 0.7219 - val_acc: 0.8107
```

根据测试集数据进行测试，其准确率为 92%。

```
Accuracy on test data: 0.92

Loss on test data: 0.39
```

考虑到我们使用的是标准的 1D CNN 模型，得到这样的结果已经很好了。我们的模型在精度（precision）、召回率（recall）和 f1 值（f1-score）上的得分也很高。

```
              precision    recall  f1-score   support

0                 0.76      0.78      0.77       650
1                 0.98      0.96      0.97      1990
2                 0.91      0.94      0.92       452
3                 0.99      0.84      0.91       370
4                 0.82      0.77      0.79       725
5                 0.93      0.98      0.95      2397

avg / total       0.92      0.92      0.92      6584
```

下面对这些分数的含义做一个简要回顾：

![](https://cdn-images-1.medium.com/max/800/1*wTGN860kbMvnZUNQbCBYVg.png)

“预测和结果矩阵”由 Nils Ackermann 根据知识共享 [CC BY-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0/) 许可下授权。

*   **精确度（Accuracy）：** 正确预测的结果与所有预测的结果总和之比。即 ((TP + TN) / (TP + TN + FP + FN))
*   **精度（Precision）：** 当模型预测为正样本时，它是对的吗？所有的正确预测的正样本除以所有的正样本预测。即 (TP / (TP + FP))
*   **召回率（Recall）：** 为模型识别出的所有正样本中有多少是正确预测的正样本？正确预测的正样本除以所有的正样本预测。即 (TP / (TP + FN))
*   **F1值（F1-score）：** 是精度和召回率的加权平均值。即 (2 x recall x precision / (recall + precision))

测试数据上对应的混淆矩阵如下所示。

![](https://cdn-images-1.medium.com/max/800/1*aUZdBNo8ppvPpOI39a-v_g.png)

### 总结

本文通过以智能手机的加速度计数据来预测用户的行为为例，绍了如何使用 1D CNN 来训练网络。完整的 Python 代码可以在 [github](https://github.com/ni79ls/har-keras-cnn) 上找到。

### 链接与引用

*   Keras [文档](https://keras.io/layers/convolutional/#conv1d) 关于一维卷积神经网络部分
*   Keras [用例](https://keras.io/getting-started/sequential-model-guide/) 关于一维卷积神经网络部分
*   一篇关于使用一维卷积神经网络进行自然语言处理的好 [文章](http://www.wildml.com/2015/11/understanding-convolutional-neural-networks-for-nlp/)

### 免责声明

_网站帖文属于自己，不代表雇佣者的文章、策略或意见。_

**联系 Raven 团队** [**Telegram**](https://t.me/ravenprotocol)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
