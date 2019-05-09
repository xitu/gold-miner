> * 原文地址：[Keras Cheat Sheet: Neural Networks in Python](https://www.datacamp.com/community/blog/keras-cheat-sheet)
> * 原文作者：[Karlijn Willems](https://www.datacamp.com/profile/karlijn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/keras-cheat-sheet.md](https://github.com/xitu/gold-miner/blob/master/TODO1/keras-cheat-sheet.md)
> * 译者：[Minghao23](https://github.com/Minghao23)
> * 校对者：[Xuyuey](https://github.com/Xuyuey), [lsvih](https://github.com/lsvih)

# Keras 速查表：使用 Python 构建神经网络

> 使用 Keras 速查表构建你自己的神经网络，便于初学者在 Python 中进行深度学习，附有代码示例

[Keras](http://keras.io/) 是一个基于 Theano 和 TensorFlow 的易于使用且功能强大的库，它提供了一些高层的神经网络接口，用于开发和评估深度学习模型。

我们最近推出了第一个使用 Keras 2.0 开发的在线交互深度学习课程，叫做“[Deep Learning in Python](https://www.datacamp.com/courses/deep-learning-in-python/)”。

现在，DataCamp 为那些已经上过这门课但仍然需要一页参考资料的人，或者那些需要一个额外的推动力才能开始学习的人，创建了 Keras 速查表。

很快，这个速查表就会让你熟悉如何从这个库中加载数据集、如何预处理数据、如何构造一个模型结构以及如何编译、训练和评估它。由于在如何搭建自己的模型上有着相当大的自由度，你会看到这个速查表展示了一些简单的关键 Keras 代码示例，只有了解这些你才能开始用 Python 搭建自己的神经网络。

此外，你还可以看到一些关于如何检查你的模型，如何保存和加载模型的示例。最后，你也会找到一些关于如何对测试数据做预测，以及如何通过调节优化参数和早停的方式来微调模型的示例。

简而言之，你会看到这个速查表并不仅仅是向你展示了使用 Keras 库在 Python 中构建神经网络的六个步骤而已。

[![keras cheat sheet](http://community.datacamp.com.s3.amazonaws.com/community/production/ckeditor_assets/pictures/516/content_button-cheatsheet-keras.png)](https://s3.amazonaws.com/assets.datacamp.com/blog_assets/Keras_Cheat_Sheet_Python.pdf)

总之，这个速查表会加快你的 Python 深度学习旅程：有了这些代码示例的帮助，你很快就可以对你的深度学习模型进行预处理、创建、检验和调优！

**（点击上图下载可打印的版本，或阅读下面的在线版本）**

## Python 数据科学速查表：Keras

Keras 是一个基于 Theano 和 TensorFlow 的易于使用且功能强大的库，它提供了一些高层的神经网络接口，用于开发和评估深度学习模型。

### 一个基础例子

```
>>> import numpy as np
>>> from keras.models import Sequential
>>> from keras.layers import Dense
>>> data = np.random.random((1000,100))
>>> labels = np.random.randint(2,size=(1000,1))
>>> model = Sequential()
>>> model.add(Dense(32, activation='relu', input_dim=100))
>>> model.add(Dense(1, activation='sigmoid'))
>>> model.compile(optimizer='rmsprop', loss='binary_crossentropy', metrics=['accuracy'])
>>> model.fit(data,labels,epochs=10,batch_size=32)
>>> predictions = model.predict(data)
```

### 数据

你的数据需要以 Numpy arrays 或者 Numpy arrays 列表的格式储存。理想情况下，数据会分为训练集和测试集，你可以借助 `sklearn.cross_validation` 下的 `train_test_split` 模块来实现。

#### Keras 数据集

```
>>> from keras.datasets import boston_housing, mnist, cifar10, imdb
>>> (x_train,y_train),(x_test,y_test) = mnist.load_data()
>>> (x_train2,y_train2),(x_test2,y_test2) = boston_housing.load_data()
>>> (x_train3,y_train3),(x_test3,y_test3) = cifar10.load_data()
>>> (x_train4,y_train4),(x_test4,y_test4) = imdb.load_data(num_words=20000)
>>> num_classes = 10
```

#### 其他

```
>>> from urllib.request import urlopen
>>> data = np.loadtxt(urlopen(&quot;http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data&quot;),delimiter=&quot;,&quot;)
>>> X = data[:,0:8]
>>> y = data [:,8]
```

### 预处理

#### 序列填充

```
>>> from keras.preprocessing import sequence
>>> x_train4 = sequence.pad_sequences(x_train4,maxlen=80)
>>> x_test4 = sequence.pad_sequences(x_test4,maxlen=80)
```

#### One-Hot 编码

```
>>> from keras.utils import to_categorical
>>> Y_train = to_categorical(y_train, num_classes)
>>> Y_test = to_categorical(y_test, num_classes)
>>> Y_train3 = to_categorical(y_train3, num_classes)
>>> Y_test3 = to_categorical(y_test3, num_classes)
```

#### 训练和测试集

```
>>> from sklearn.model_selection import train_test_split
>>> X_train5, X_test5, y_train5, y_test5 = train_test_split(X, y, test_size=0.33, random_state=42)
```

### 标准化/归一化

```
>>> from sklearn.preprocessing import StandardScaler
>>> scaler = StandardScaler().fit(x_train2)
>>> standardized_X = scaler.transform(x_train2)
>>> standardized_X_test = scaler.transform(x_test2)
```

### 模型结构

#### 序贯模型

```
>>> from keras.models import Sequential
>>> model = Sequential()
>>> model2 = Sequential()
>>> model3 = Sequential()
```

#### 多层感知机（MLP）

**二分类**

```
>>> from keras.layers import Dense
>>> model.add(Dense(12, input_dim=8, kernel_initializer='uniform', activation='relu'))
>>> model.add(Dense(8, kernel_initializer='uniform', activation='relu'))
>>> model.add(Dense(1, kernel_initializer='uniform', activation='sigmoid'))
```

**多分类**

```
>>> from keras.layers import Dropout
>>> model.add(Dense(512,activation='relu',input_shape=(784,)))
>>> model.add(Dropout(0.2))
>>> model.add(Dense(512,activation='relu'))
>>> model.add(Dropout(0.2))
>>> model.add(Dense(10,activation='softmax'))
```

**回归**

```
>>> model.add(Dense(64, activation='relu', input_dim=train_data.shape[1]))
>>> model.add(Dense(1))
```

#### 卷积神经网路（CNN）

```
>>> from keras.layers import Activation, Conv2D, MaxPooling2D, Flatten
>>> model2.add(Conv2D(32, (3,3), padding='same', input_shape=x_train.shape[1:]))
>>> model2.add(Activation('relu'))
>>> model2.add(Conv2D(32, (3,3)))
>>> model2.add(Activation('relu'))
>>> model2.add(MaxPooling2D(pool_size=(2,2)))
>>> model2.add(Dropout(0.25))
>>> model2.add(Conv2D(64, (3,3), padding='same'))
>>> model2.add(Activation('relu'))
>>> model2.add(Conv2D(64, (3, 3)))
>>> model2.add(Activation('relu'))
>>> model2.add(MaxPooling2D(pool_size=(2,2)))
>>> model2.add(Dropout(0.25))
>>> model2.add(Flatten())
>>> model2.add(Dense(512))
>>> model2.add(Activation('relu'))
>>> model2.add(Dropout(0.5))
>>> model2.add(Dense(num_classes))
>>> model2.add(Activation('softmax'))
```

#### 循环神经网络（RNN）

```
>>> from keras.klayers import Embedding,LSTM
>>> model3.add(Embedding(20000,128))
>>> model3.add(LSTM(128,dropout=0.2,recurrent_dropout=0.2))
>>> model3.add(Dense(1,activation='sigmoid'))
```

### 检查模型

模型输出的 shape

```
>>> model.output_shape
```

模型描述

```
>>> model.summary()
```

模型配置

```
>>> model.get_config()
```

列出模型中所有的权重张量

```
>>> model.get_weights()
```

### 编译模型

#### 多层感知机（MLP）

**多层感知机：二分类**

```
>>> model.compile(optimizer='adam', loss='binary_crossentropy', metrics=['accuracy'])
```

**多层感知机：多分类**

```
>>> model.compile(optimizer='rmsprop', loss='categorical_crossentropy', metrics=['accuracy'])
```

**多层感知机：回归**

```
>>> model.compile(optimizer='rmsprop', loss='mse', metrics=['mae'])
```

#### 循环神经网络（RNN）

```
>>> model3.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
```

### 模型训练

```
>>> model3.fit(x_train4, y_train4, batch_size=32, epochs=15, verbose=1, validation_data=(x_test4, y_test4))
```

### 评估你的模型表现

```
>>> score = model3.evaluate(x_test, y_test, batch_size=32)
```

### 预测

```
>>> model3.predict(x_test4, batch_size=32)
>>> model3.predict_classes(x_test4,batch_size=32)
```

### 保存/加载模型

```
>>> from keras.models import load_model
>>> model3.save('model_file.h5')
>>> my_model = load_model('my_model.h5')
```

### 模型微调

#### 优化参数

```
>>> from keras.optimizers import RMSprop
>>> opt = RMSprop(lr=0.0001, decay=1e-6)
>>> model2.compile(loss='categorical_crossentropy', optimizer=opt, metrics=['accuracy'])
```

#### 早停

```
>>> from keras.callbacks import EarlyStopping
>>> early_stopping_monitor = EarlyStopping(patience=2)
>>> model3.fit(x_train4, y_train4, batch_size=32, epochs=15, validation_data=(x_test4, y_test4), callbacks=[early_stopping_monitor])
```

### 进一步探索

从 [Keras 新手教程](https://www.datacamp.com/community/tutorials/deep-learning-python)开始，您将以一种简单、循序渐进的方式学习如何探索和预处理一个关于葡萄酒质量的数据集，为分类和回归任务构建多层感知机，编译、拟合和评估模型，并对所构建的模型进行微调。

除此之外，不要错过我们的 [Scikit-Learn 速查表](https://www.datacamp.com/community/blog/scikit-learn-cheat-sheet/)，[NumPy 速查表](https://www.datacamp.com/community/blog/python-numpy-cheat-sheet/)和 [Pandas 速查表](https://www.datacamp.com/community/blog/python-pandas-cheat-sheet/)！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
