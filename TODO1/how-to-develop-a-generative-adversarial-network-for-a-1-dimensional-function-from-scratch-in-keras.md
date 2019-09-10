> * 原文地址：[How to Develop a 1D Generative Adversarial Network From Scratch in Keras](https://machinelearningmastery.com/how-to-develop-a-generative-adversarial-network-for-a-1-dimensional-function-from-scratch-in-keras/)
> * 原文作者：[Jason Brownlee](https://www.pyimagesearch.com/author/adrian/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-a-generative-adversarial-network-for-a-1-dimensional-function-from-scratch-in-keras.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-a-generative-adversarial-network-for-a-1-dimensional-function-from-scratch-in-keras.md)
> * 译者：
> * 校对者：

# 如何从头用 Keras 搭建一维生成对抗网络

[生成对抗网络或简称 GAN](https://machinelearningmastery.com/what-are-generative-adversarial-networks-gans/)，是训练强大的生成器模型的深度学习框架。

一个生成器模型可以生成新的人造样本，这些样本可以来自于已经存在的样本分布。

生成对抗网络由生成器模型和判别器模型组成。生成器负责从领域中生成新的样本，判别器负责区分这些样本是真的还是假的（生成的）。重要的是，判别器模型的性能被用来更新判别器自己和生成器的模型权重参数。这意味着生成器从来不会真的看到来自领域中的样本并且是基于判别器表现的好坏来作出调整。

这是一个理解和训练都复杂的模型。

一个更好地理解生成对抗网络模型本质以及它们是如何被训练的方法是针对一个非常简单的任务从头搭建一个模型。

一维函数这个简单的任务为从头搭建一个简单的生成对抗网络提供了好环境。这是因为真实和生成的样本可以被绘制出来，并且视觉上进行检查，大致了解学习到了什么。一个简单的函数也不需要复杂的神经网络模型，意味着这个架构中的生成器和判别器可以很容易被理解。

在这个教程中，我们将选择一个简单的一维函数并且以它作为基础，用 Keras 深度学习库从头搭建和评估一个生成对抗网络。

在完成了这个教程之后，你将知道：

* 使用一个简单的一维函数从头搭建一个生成对抗网络的好处。
* 如何搭建独立的判别器和生成器模型，以及一个通过判别器预测行为来训练生成器的组合模型。
* 如何在问题域中真实数据的环境中主观地评估生成的样本。

[在我新的生成对抗网络书中](/generative_adversarial_networks/)可以找到如何搭建 DCGANs、条件 GANs、Pix2Pix、CycleGANs 等内容，其中还附有 29 个循序渐进的教程和完整的源代码。

让我们开始吧。

![如何从头用 Keras 搭建一维生成对抗网络](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/How-to-Develop-a-Generative-Adversarial-Network-for-a-1-Dimensional-Function-From-Scratch-in-Keras.jpg)

How to Develop a Generative Adversarial Network for a 1-Dimensional Function From Scratch in Keras  
Photo by [Chris Bambrick](https://www.flickr.com/photos/lntervention/16865473804/), some rights reserved.
如何从头用 Keras 搭建一维生成对抗网络
这张照片由 [Chris Bambrick](https://www.flickr.com/photos/lntervention/16865473804/) 拍摄，并保留权利。

## 教程概述

这项教程会被分为六个部分，它们是：

1. 选择一个一维函数
2. 定义一个判别器模型
3. 定义一个生成器模型
4. 训练生成器模型
5. 评估生成对抗网络的性能
6. 训练生成对抗网络完整的例子

## 选择一个一维函数

第一步是为模型选择一个一维函数。

函数形如：
```
y = f(x)
```

其中，_x_ 和 _y_ 是函数的输入值和输出值。

特别的是，我们想要一个可以轻易理解和绘制的函数。这会对于为这个模型生成的值设定一个期望值以及视觉上检查这些生成的样本以对它们质量有一个大致的了解都很有帮助。

我们将会使用一个简单的函数 _x^2_；这个函数会返回输入值的平方。你可能还记得高中代数学到的这个函数，它是一个 _u_ 型函数。

我们可以用 Python 来定义这个函数如下：

```python
# 简单的函数
def calculate(x):
	return x * x
```

我们可以定义输入域为在 -0.5 到 0.5 之间的实数，并且为每个输入值在这个线性范围内计算其输出值，然后绘制结果来了解输入值是如何关联到输出值的。

The complete example is listed below.
完整的例子如下所示：

```python
# 演示简单的 x^2 函数
from matplotlib import pyplot

# 简单的函数
def calculate(x):
	return x * x

# 定义输入值
inputs = [-0.5, -0.4, -0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 0.4, 0.5]
# 计算输出值
outputs = [calculate(x) for x in inputs]
# 绘制结果
pyplot.plot(inputs, outputs)
pyplot.show()
```

运行这个例子为每个输入值计算其输出值，并且绘制一张输入和输出值的图。

我们可以看到远离 0.0 的输入值能得到更大的输出值，反之接近于 0 的输入值会得到更小的输出值，同时这种性质是关于零点对称的。

这是众所周知的 X^2 一维函数的 u 型图。

![X^2 函数的输入输出图](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-inputs-vs-outputs-for-X^2-function-1024x768.png)

X^2 函数的输入输出图。

我们可以从这个函数中生成随机的样本或点。

这个可以通过生成在 -0.5 和 0.5 之间的随机值，并且计算其对应的输出值来实现。多次重复这个步骤就能得到该函数的样本点，比如“_真实的样本_”。

用三点图绘制这些样本将会显示同样的 u 型图，虽然是由独立的随机样本构成的。

完整的例子如下所述。

首先，我们在 0 和 1 之间均匀地生成随机值，然后将它们偏移到 -0.5 和 0.5 范围内。然后我们为每一个随机生成的输入值计算输出值，并且把这些数组合并成一个 n 行（100）和 2 列的 Numpy 数组。

```python
# 从 X^2 中生成随机样本的例子
from numpy.random import rand
from numpy import hstack
from matplotlib import pyplot

# 从 x^2 中生成随机样本
def generate_samples(n=100):
	# generate random inputs in [-0.5, 0.5]
	X1 = rand(n) - 0.5
	# generate outputs X^2 (quadratic)
	X2 = X1 * X1
	# stack arrays
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	return hstack((X1, X2))

# 生成样本
data = generate_samples()
# 绘制样本
pyplot.scatter(data[:, 0], data[:, 1])
pyplot.show()
```

运行这个例子将产生 100 个随机输入，计算所得的输出以及绘制样本的散点图，这是一张熟悉的 u 型图。

![为 X^2 函数绘制随机生成的输入样本和计算的输出值。](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-randomly-generated-sample-of-inputs-vs-calculated-outputs-for-X^2-function-1024x768.png)

为 X^2 函数绘制随机生成的输入样本和计算的输出值。

我们可以将这个函数作为为判别器函数生成真实样本的起始点。尤其是一个样本是由两个元素的向量组成的，一个作为输入，一个作为我们的一维函数的输出。

我们也可以想象一个生成器模型是如何生成新样本的，我们可以绘制它们同时与期望的 u 型 X^2 函数比较。特别是一个生成器可以输出一个由两个元素组成的向量：一个作为输入，一个作为一维函数的输出。

## 定义一个判别器模型

下一步是定义判别器模型。

这个模型必须从我们的问题域中获取一个样本，比如一个由两个元素组成的向量，然后输出一个分类预测来区分这个样本的真假。

这是一个二分类问题。

* **输入**：由两个实数组成的样本。
* **输出**：二分类，样本为真（或假）的可能性。

这个问题非常简单，意味着我们不需要一个复杂的神经网络来建模。

这个分类器模型有一个隐藏层，其中包含 25 个神经元，并且我们将使用 [ReLU 激活函数](https://machinelearningmastery.com/rectified-linear-activation-function-for-deep-learning-neural-networks/)以及一个被称为 He 的权重初始化方法。

输出层包含一个神经元，它用 sigmoid 激活函数来做二分类。

这个模型将会最小化二分类的交叉熵损失函数，以及使用 [Adam 版本的随机梯度下降](https://machinelearningmastery.com/adam-optimization-algorithm-for-deep-learning/)，因为它非常有效。

下面的 _define_discriminator()_ 函数定义和返回了判别器模型。这个函数参数化了期望的输入个数，默认值为 2。

```python
# 定义了独立的判别器模型
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model
```

我们可以使用这个函数来定义和总结这个判别器模型。完整的例子如下所示。

```
# 定义判别器模型
from keras.models import Sequential
from keras.layers import Dense
from keras.utils.vis_utils import plot_model

# 定义独立的判别器模型
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# compile model
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model

# 定义判别模型
model = define_discriminator()
# 总结模型
model.summary()
# plot the model
plot_model(model, to_file='discriminator_plot.png', show_shapes=True, show_layer_names=True)
```

运行这个例子，它定义并总结了判别器模型。

```
_________________________________________________________________
Layer (type)                 Output Shape              Param #
=================================================================
dense_1 (Dense)              (None, 25)                75
_________________________________________________________________
dense_2 (Dense)              (None, 1)                 26
=================================================================
Total params: 101
Trainable params: 101
Non-trainable params: 0
_________________________________________________________________
```

这个模型的图也被生成了，我们可以看到这个模型期望有两个输入并且预测一个输出。

**注意**：生成这张模型图是以假设安装了 pydot 和 graphviz 库为前提的。如果安装遇到了问题，你可以把引入 _plot_model_ 函数的 import 语句和调用 _plot_model_ 方法注释掉。

![生成对抗网络中生成器模型图](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-the-Discriminator-Model-in-the-GAN.png)

生成对抗网络中生成器模型图

我们现在可以开始训练这个模型了，它需要用到被标记为 1 的真实数据和被标记为 0 的随机生成的样本。

我们不需要做这件事，但是这些我们开发的元素在之后会变得很有帮助，并且它帮助我们认识到生成器只是一个普通的神经网络模型。

首先，我们可以从预测的部分更新我们的 _generate_samples()_ 方法，我们称它为 _generate\_real\_samples()_，它也会返回真实样本的输出标签，也就是一个由 1 组成的数组，这里 1 表示真实样本。

```python
# 生成 n 个真实样本和分类标签
def generate_real_samples(n):
	# generate inputs in [-0.5, 0.5]
	# 生成 [-0.5, 0.5] 范围内的输入值
	X1 = rand(n) - 0.5
	# 生成输出值 X^2
	X2 = X1 * X1
	# 堆叠数组
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	X = hstack((X1, X2))
	# 生成分类标签
	y = ones((n, 1))
	return X, y
```

下一步，我们可以创建一个该方法的副本来生成假样本。

在这种情况下，我们会为样本的两个元素生成范围在 -1 和 1 之间的随机值。所有这些样本的输出分类标签都是 0。

这个方法将作为我们假的生成器模型。

```python
# 生成 n 个加样本和分类标签
def generate_fake_samples(n):
	# 生成 [-1, 1] 范围内的输入值
	X1 = -1 + rand(n) * 2
	# 生成 [-1, 1] 范围内的输出值
	X2 = -1 + rand(n) * 2
	# 堆叠数组
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	X = hstack((X1, X2))
	# generate class labels
	# 生成分类标签
	y = zeros((n, 1))
	return X, y
```

下一步，我们需要一个训练和评估生成器模型的方法。

这可以通过手动列举训练的 epoch，并且为每个 epoch 生成一半的真实样本和一半的加样本，然后更新模型，比如：在一整批样本上。可以使用 The _train()_ 方法来训练，但是在这种情况下，我们将直接用 _train\_on\_batch()_ 方法。

这个模型可以根据生成的样本进行评估，并且我们可以生成真假样本分类准确率的报告。

下面的 _train_discriminator()_ 方法实现了为模型训练 1000 个 batch，每个 batch 包含 128 个样本（64 个假样本 64 个真样本）。

```python
# 训练判别器模型
def train_discriminator(model, n_epochs=1000, n_batch=128):
	half_batch = int(n_batch / 2)
	# 手动运行 epoch
	for i in range(n_epochs):
		# 生成真实样本
		X_real, y_real = generate_real_samples(half_batch)
		# 更新模型
		model.train_on_batch(X_real, y_real)
		# 生成假样本
		X_fake, y_fake = generate_fake_samples(half_batch)
		# 更新模型
		model.train_on_batch(X_fake, y_fake)
		# 评估模型
		_, acc_real = model.evaluate(X_real, y_real, verbose=0)
		_, acc_fake = model.evaluate(X_fake, y_fake, verbose=0)
		print(i, acc_real, acc_fake)
```

我们可以把这些联系在一起，然后在真实和虚假样本上训练判别器模型。

完整的例子如下所示。

```python
# 定义并且加载一个判别器模型
from numpy import zeros
from numpy import ones
from numpy import hstack
from numpy.random import rand
from numpy.random import randn
from keras.models import Sequential
from keras.layers import Dense

# 定义独立的判别器模型
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model

# 生成 n 个真实的样本和分类标签
def generate_real_samples(n):
	# 生成 [-0.5, 0.5] 范围内的输入值
	X1 = rand(n) - 0.5
	# 生成输出 X^2
	X2 = X1 * X1
	# 堆叠数组
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	X = hstack((X1, X2))
	# 生成分类标签
	y = ones((n, 1))
	return X, y

# 生成 n 个假样本和分类标签
def generate_fake_samples(n):
	# 生成 [-1, 1] 范围内的输入值
	X1 = -1 + rand(n) * 2
	# 生成 [-1, 1] 范围内的输出值
	X2 = -1 + rand(n) * 2
	# 堆叠数组
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	X = hstack((X1, X2))
	# 生成分类标签
	y = zeros((n, 1))
	return X, y

# 训练判别器模型
def train_discriminator(model, n_epochs=1000, n_batch=128):
	half_batch = int(n_batch / 2)
	# 手动运行 epoch
	for i in range(n_epochs):
		# 生成真实的样本
		X_real, y_real = generate_real_samples(half_batch)
		# 更新模型
		model.train_on_batch(X_real, y_real)
		# 生成假样本
		X_fake, y_fake = generate_fake_samples(half_batch)
		# 更新模型
		model.train_on_batch(X_fake, y_fake)
		# 评估模型
		_, acc_real = model.evaluate(X_real, y_real, verbose=0)
		_, acc_fake = model.evaluate(X_fake, y_fake, verbose=0)
		print(i, acc_real, acc_fake)

# 定义判别器模型
model = define_discriminator()
# 加载模型
train_discriminator(model)
```

运行上面的代码会生成真实的和虚假的样本并且更新模型，然后在同样的样本上评估模型并打印出分类的准确率。

你们的结果可能会不同但是模型会快速地学习，以完美的准确率正确地识别真实的样本，并且非常擅长识别加样本，正确率在 80% 和 90% 之间。

```
...
995 1.0 0.875
996 1.0 0.921875
997 1.0 0.859375
998 1.0 0.9375
999 1.0 0.8125
```

训练判别器模型是非常直观的。我们的目标是训练一个生成器模型，并不是判别器模型，这才是生成对抗网络真正的复杂的地方。

## 定义一个生成器模型

下一步是定义生成器模型。

生成器模型从隐空间中选取一个点作为输入并且生成一个新的样本，比如函数的输入和输出元素作为一个向量，例如 x 和 x^2。

隐变量是一个隐藏的或者未被观察到的变量，隐空间是一个由这些变量组成的多维向量空间。我们可以为我们的问题定义隐空间的维度大小以及隐空间的形式或变量的分布。

这是因为隐空间是没有意义的直到生成器模型开始学习并为空间中的点赋予意义。训练之后，隐空间的点将和输出空间中的点关联起来，比如和生成样本的空间。

We will define a small latent space of five dimensions and use the standard approach in the GAN literature of using a Gaussian distribution for each variable in the latent space. We will generate new inputs by drawing random numbers from a standard Gaussian distribution, i.e. mean of zero and a standard deviation of one.
我们定义一个小的五维隐空间，并且使用生成对抗网络文献中标准的方法，即隐空间中每一个变量都使用高斯分布。我们将从一个标准高斯分布中获取随机数来生成输入值，比如均值为 0，标准差为 1。

* **输入**：隐空间中的点，比如由五个高斯随机数组成的向量。
* **输出**：两个元素组成的向量，代表了为我们的函数生成的样本（x 和 x^2）。

生成器模型会和判别器模型一样小。

它有一个隐藏层，其中包含 5 个神经元，并且将使用 [ReLU 激活函数](https://machinelearningmastery.com/rectified-linear-activation-function-for-deep-learning-neural-networks/)和 He 权重初始化方法。输出层有两个神经元表示生成向量中的两个元素并且使用一个线性激活函数。

最后用了线性激活函数是因为我们直到我们想让生成器输出实数向量，第一个元素的范围是 \[-0.5, 0.5\]，第二个元素范围大约是 \[0.0, 0.25\]。

这个模型没有被编译。原因是生成器模型不是直接被加载的。

下面的 _define_generator()_ 方法定义并返回了生成器模型。

隐空间的维度大小是可以被参数化的以防我们以后想改变它，模型的输出维度大小也是参数化的，与定义的判别器模型的函数相匹配。

```python
# 定义独立的生成器模型
def define_generator(latent_dim, n_outputs=2):
	model = Sequential()
	model.add(Dense(15, activation='relu', kernel_initializer='he_uniform', input_dim=latent_dim))
	model.add(Dense(n_outputs, activation='linear'))
	return model
```

我们可以总结这个模型来帮助更好地理解输入和输出的维度大小。

完整的例子如下所示。

```python
# 定义生成器模型
from keras.models import Sequential
from keras.layers import Dense
from keras.utils.vis_utils import plot_model

# 定义独立的生成器模型
def define_generator(latent_dim, n_outputs=2):
	model = Sequential()
	model.add(Dense(15, activation='relu', kernel_initializer='he_uniform', input_dim=latent_dim))
	model.add(Dense(n_outputs, activation='linear'))
	return model

# 定义生成器模型
model = define_generator(5)
# 总结模型
model.summary()
# 绘制模型
plot_model(model, to_file='generator_plot.png', show_shapes=True, show_layer_names=True)
```

运行这个例子，它定义并且总结了生成器模型。

```
_________________________________________________________________
Layer (type)                 Output Shape              Param #
=================================================================
dense_1 (Dense)              (None, 15)                90
_________________________________________________________________
dense_2 (Dense)              (None, 2)                 32
=================================================================
Total params: 122
Trainable params: 122
Non-trainable params: 0
_________________________________________________________________
```

模型图也被生成了，我们可以看到这个模型期望从隐空间中获取一个由 5 元向量作为输入，并且预测一个由二元向量作为输出。

**注意**：生成这张模型图是以假设安装了 pydot 和 graphviz 库为前提的。如果安装遇到了问题，你可以把引入 _plot_model_ 函数的 import 语句和调用 _plot_model_ 方法注释掉。


![绘制生成对抗网络中的生成模型](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-the-Generator-Model-in-the-GAN.png)


绘制生成对抗网络中的生成模型

我们可以看到模型从隐空间中获取一个随机的五元向量，然后输出为我们的一维函数输出一个二元向量。

这个模型现在还没有太多作用。然而，我们可以演示如何使用它来生成样本。这也不是需要做的，但是这里有些东西之后可能是有用的。

第一步是在隐空间中生成新的点。我们可以通过调用 [randn() NumPy 方法](https://docs.scipy.org/doc/numpy/reference/generated/numpy.random.randn.html)来生成来自标准高斯分布的[随机数](https://machinelearningmastery.com/how-to-generate-random-numbers-in-python/)数组。

随机数数组之后可以被调整到样本维度的大小：那就是 n 行，每行有 5 个元素。下面的 _generate\_latent\_points()_ 方法实现了它并且在隐空间中生成了一定数量的点，这些点可以用来作为生成模型的输入。

```python
# 在隐空间中生成点作为生成器的输入
def generate_latent_points(latent_dim, n):
	# 在隐空间中生成点
	x_input = randn(latent_dim * n)
	# 为网络重新调整批输入样本的维度大小
	x_input = x_input.reshape(n, latent_dim)
	return x_input
```

下一步，我们可以用这些生成的点作为生成器模型的输入来生成新的样本，然后绘制这些样本。

下面的 _generate\_fake\_samples()_ 方法实现了它，将定义好的生成器和隐空间的维度大小以及模型生成点的个数作为参数被传入。

```python
# 用生成器来生成 n 个假样本然后绘制结果
def generate_fake_samples(generator, latent_dim, n):
	# 在隐空间中生成点
	x_input = generate_latent_points(latent_dim, n)
	# 预测输出
	X = generator.predict(x_input)
	# 绘制结果
	pyplot.scatter(X[:, 0], X[:, 1])
	pyplot.show()
```

把它们放在一起，完整的例子如下所示。

```python
# 定义和使用生成器模型
from numpy.random import randn
from keras.models import Sequential
from keras.layers import Dense
from matplotlib import pyplot

# 定义独立的生成器模型
def define_generator(latent_dim, n_outputs=2):
	model = Sequential()
	model.add(Dense(15, activation='relu', kernel_initializer='he_uniform', input_dim=latent_dim))
	model.add(Dense(n_outputs, activation='linear'))
	return model

# 生成隐空间中的点作为生成器的输入
def generate_latent_points(latent_dim, n):
	# 在隐空间中生成点
	x_input = randn(latent_dim * n)
	# 调整网络批输入的维度大小
	x_input = x_input.reshape(n, latent_dim)
	return x_input

# 用生成器生成 n 个假样本来绘制结果
def generate_fake_samples(generator, latent_dim, n):
	# generate points in latent space
	# 在隐空间中生成点
	x_input = generate_latent_points(latent_dim, n)
	# 预测输出
	X = generator.predict(x_input)
	# 绘制结果
	pyplot.scatter(X[:, 0], X[:, 1])
	pyplot.show()

# 隐空间的维度大小
latent_dim = 5
# define the discriminator model
# 定义判别器模型
model = define_generator(latent_dim)
# 生成并绘制生成的样本
generate_fake_samples(model, latent_dim, 100)
```

运行这个例子将从隐空间中生成 100 个随机点，将它们作为生成器的输入并从我们的一维函数域中生成 100 个假样本。

由于生成器还没有被训练过，因此生成的点和我们想的一样，全都是“垃圾”，但是我们可以想象当这个模型被训练之后，这些点会慢慢的开始向目标函数和它的 u 型靠近。

![由生成器模型预测的假样本的散点图](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Scatter-plot-of-Fake-Samples-Predicted-by-the-Generator-Model-1024x768.png)


由生成器模型预测的假样本的散点图。

我们已经看过了如何定义和使用生成器模型。我们需要以这种方式使用生成器模型来为判别器生成用以分类的样本。

我们还没有看到生成器模型是如何被训练的；这是下一步。

## 训练生成器模型

生成器模型中的权重是基于判别器模型的表现而更新的。

当判别器很擅于检测假样本时，生成器会更新得更多，而当判别器对于检测假样本相对不擅长或者被迷惑时，生成器会更新得更少。

这定义了两个模型之间的零和或对抗关系。

有许多使用 Keras API 来实现它的方式，但是可能最简单的方法就是创建一个新的模型包含或封装生成器和判别器模型。


特别的是，一个新的生成对抗模型可以被定义为堆叠生成器和判别器，生成器在隐空间中接收随机点作为输入，生成直接被提供给判别器模型的样本，然后分类，这个大模型的输出可以被用来更新生成器模型的权重。

要清楚，我们不是在讨论一个新的第三方模型，只是一个逻辑上第三方的模型，它用了已经定义好的来自生成器和判别器模型的层和权重。

在区分真假数据的时候只涉及到判别器；因此，判别器模型可以通过真假数据被单独训练。

生成器模型只和判别器模型在假数据上的表现有关。因此，当判别器是生成对抗网络模型的一部分的时候，我们会将判别器中的所有层标记为无法训练为的是它们在假数据上不会更新和过度训练。

当通过这个合并的生成对抗网路模型来训练生成器的时候，还有一个重要的改变。我们想让判别器认为生成器输出的样本是真的，不是假的。因此，当生成器在作为生成对抗网络一部分训练的时候，我们将标记生成的样本为真（类标签为 1）。

我们可以想像判别器将生成的样本归类为不是真的（类标签为 0）或者为真的可能性较低（0.3 或 0.5）。用来更新模型权重的传播过程将其视为一个大的误差，然后将更新模型权重（比如只有在生成器中的权重）来更正这个误差，以此来使得生成器更好地生成逼真的假样本。



Let’s make this concrete.
让我们来证实这个过程。

* **Inputs**: Point in latent space, e.g. a five-element vector of Gaussian random numbers.
* **Outputs**: Binary classification, likelihood the sample is real (or fake).

The _define_gan()_ function below takes as arguments the already-defined generator and discriminator models and creates the new logical third model subsuming these two models. The weights in the discriminator are marked as not trainable, which only affects the weights as seen by the GAN model and not the standalone discriminator model.

The GAN model then uses the same binary cross entropy loss function as the discriminator and the efficient [Adam version of stochastic gradient descent](https://machinelearningmastery.com/adam-optimization-algorithm-for-deep-learning/).

```python
# define the combined generator and discriminator model, for updating the generator
def define_gan(generator, discriminator):
	# make weights in the discriminator not trainable
	discriminator.trainable = False
	# connect them
	model = Sequential()
	# add generator
	model.add(generator)
	# add the discriminator
	model.add(discriminator)
	# compile model
	model.compile(loss='binary_crossentropy', optimizer='adam')
	return model
```

Making the discriminator not trainable is a clever trick in the Keras API.

The _trainable_ property impacts the model when it is compiled. The discriminator model was compiled with trainable layers, therefore the model weights in those layers will be updated when the standalone model is updated via calls to _train\_on\_batch()_.

The discriminator model was marked as not trainable, added to the GAN model, and compiled. In this model, the model weights of the discriminator model are not trainable and cannot be changed when the GAN model is updated via calls to _train\_on\_batch()_.

This behavior is described in the Keras API documentation here:

* [How can I “freeze” Keras layers?](https://keras.io/getting-started/faq/#how-can-i-freeze-keras-layers)

The complete example of creating the discriminator, generator, and composite model is listed below.

```python
# demonstrate creating the three models in the gan
from keras.models import Sequential
from keras.layers import Dense
from keras.utils.vis_utils import plot_model

# define the standalone discriminator model
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# compile model
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model

# define the standalone generator model
def define_generator(latent_dim, n_outputs=2):
	model = Sequential()
	model.add(Dense(15, activation='relu', kernel_initializer='he_uniform', input_dim=latent_dim))
	model.add(Dense(n_outputs, activation='linear'))
	return model

# define the combined generator and discriminator model, for updating the generator
def define_gan(generator, discriminator):
	# make weights in the discriminator not trainable
	discriminator.trainable = False
	# connect them
	model = Sequential()
	# add generator
	model.add(generator)
	# add the discriminator
	model.add(discriminator)
	# compile model
	model.compile(loss='binary_crossentropy', optimizer='adam')
	return model

# size of the latent space
latent_dim = 5
# create the discriminator
discriminator = define_discriminator()
# create the generator
generator = define_generator(latent_dim)
# create the gan
gan_model = define_gan(generator, discriminator)
# summarize gan model
gan_model.summary()
# plot gan model
plot_model(gan_model, to_file='gan_plot.png', show_shapes=True, show_layer_names=True)
```

Running the example first creates a summary of the composite model.

```
_________________________________________________________________
Layer (type)                 Output Shape              Param #
=================================================================
sequential_2 (Sequential)    (None, 2)                 122
_________________________________________________________________
sequential_1 (Sequential)    (None, 1)                 101
=================================================================
Total params: 223
Trainable params: 122
Non-trainable params: 101
_________________________________________________________________
```

A plot of the model is also created and we can see that the model expects a five-element point in latent space as input and will predict a single output classification label.

**Note**, creating this plot assumes that the pydot and graphviz libraries are installed. If this is a problem, you can comment out the import statement for the _plot_model_ function and the call to the _plot_model()_ function.

![Plot of the Composite Generator and Discriminator Model in the GAN](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-the-Composite-Generator-and-Discriminator-Model-in-the-GAN.png)

Plot of the Composite Generator and Discriminator Model in the GAN

Training the composite model involves generating a batch-worth of points in the latent space via the _generate\_latent\_points()_ function in the previous section, and class=1 labels and calling the _train\_on\_batch()_ function.

The _train_gan()_ function below demonstrates this, although it is pretty uninteresting as only the generator will be updated each epoch, leaving the discriminator with default model weights.

```python
# train the composite model
def train_gan(gan_model, latent_dim, n_epochs=10000, n_batch=128):
	# manually enumerate epochs
	for i in range(n_epochs):
		# prepare points in latent space as input for the generator
		x_gan = generate_latent_points(latent_dim, n_batch)
		# create inverted labels for the fake samples
		y_gan = ones((n_batch, 1))
		# update the generator via the discriminator's error
		gan_model.train_on_batch(x_gan, y_gan)
```

Instead, what is required is that we first update the discriminator model with real and fake samples, then update the generator via the composite model.

This requires combining elements from the _train_discriminator()_ function defined in the discriminator section and the _train_gan()_ function defined above. It also requires that the _generate\_fake\_samples()_ function use the generator model to generate fake samples instead of generating random numbers.

The complete train function for updating the discriminator model and the generator (via the composite model) is listed below.

```python
# train the generator and discriminator
def train(g_model, d_model, gan_model, latent_dim, n_epochs=10000, n_batch=128):
	# determine half the size of one batch, for updating the discriminator
	half_batch = int(n_batch / 2)
	# manually enumerate epochs
	for i in range(n_epochs):
		# prepare real samples
		x_real, y_real = generate_real_samples(half_batch)
		# prepare fake examples
		x_fake, y_fake = generate_fake_samples(g_model, latent_dim, half_batch)
		# update discriminator
		d_model.train_on_batch(x_real, y_real)
		d_model.train_on_batch(x_fake, y_fake)
		# prepare points in latent space as input for the generator
		x_gan = generate_latent_points(latent_dim, n_batch)
		# create inverted labels for the fake samples
		y_gan = ones((n_batch, 1))
		# update the generator via the discriminator's error
		gan_model.train_on_batch(x_gan, y_gan)
```

We almost have everything we need to develop a GAN for our one-dimensional function.

One remaining aspect is the evaluation of the model.

## Evaluating the Performance of the GAN

Generally, there are no objective ways to evaluate the performance of a GAN model.

In this specific case, we can devise an objective measure for the generated samples as we know the true underlying input domain and target function and can calculate an objective error measure.

Nevertheless, we will not calculate this objective error score in this tutorial. Instead, we will use the subjective approach used in most GAN applications. Specifically, we will use the generator to generate new samples and inspect them relative to real samples from the domain.

First, we can use the _generate\_real\_samples()_ function developed in the discriminator part above to generate real examples. Creating a scatter plot of these examples will create the familiar u-shape of our target function.

```python
# generate n real samples with class labels
def generate_real_samples(n):
	# generate inputs in [-0.5, 0.5]
	X1 = rand(n) - 0.5
	# generate outputs X^2
	X2 = X1 * X1
	# stack arrays
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	X = hstack((X1, X2))
	# generate class labels
	y = ones((n, 1))
	return X, y
```

Next, we can use the generator model to generate the same number of fake samples.

This requires first generating the same number of points in the latent space via the _generate\_latent\_points()_ function developed in the generator section above. These can then be passed to the generator model and used to generate samples that can also be plotted on the same scatter plot.

```python
# generate points in latent space as input for the generator
def generate_latent_points(latent_dim, n):
	# generate points in the latent space
	x_input = randn(latent_dim * n)
	# reshape into a batch of inputs for the network
	x_input = x_input.reshape(n, latent_dim)
	return x_input
```

The _generate\_fake\_samples()_ function below generates these fake samples and the associated class label of 0 which will be useful later.

```python
# use the generator to generate n fake examples, with class labels
def generate_fake_samples(generator, latent_dim, n):
	# generate points in latent space
	x_input = generate_latent_points(latent_dim, n)
	# predict outputs
	X = generator.predict(x_input)
	# create class labels
	y = zeros((n, 1))
	return X, y
```

Having both samples plotted on the same graph allows them to be directly compared to see if the same input and output domain are covered and whether the expected shape of the target function has been appropriately captured, at least subjectively.

The _summarize_performance()_ function below can be called any time during training to create a scatter plot of real and generated points to get an idea of the current capability of the generator model.

```python
# plot real and fake points
def summarize_performance(generator, latent_dim, n=100):
	# prepare real samples
	x_real, y_real = generate_real_samples(n)
	# prepare fake examples
	x_fake, y_fake = generate_fake_samples(generator, latent_dim, n)
	# scatter plot real and fake data points
	pyplot.scatter(x_real[:, 0], x_real[:, 1], color='red')
	pyplot.scatter(x_fake[:, 0], x_fake[:, 1], color='blue')
	pyplot.show()
```

We may also be interested in the performance of the discriminator model at the same time.

Specifically, we are interested to know how well the discriminator model can correctly identify real and fake samples. A good generator model should make the discriminator model confused, resulting in a classification accuracy closer to 50% on real and fake examples.

We can update the _summarize_performance()_ function to also take the discriminator and current epoch number as arguments and report the accuracy on the sample of real and fake examples.

```python
# evaluate the discriminator and plot real and fake points
def summarize_performance(epoch, generator, discriminator, latent_dim, n=100):
	# prepare real samples
	x_real, y_real = generate_real_samples(n)
	# evaluate discriminator on real examples
	_, acc_real = discriminator.evaluate(x_real, y_real, verbose=0)
	# prepare fake examples
	x_fake, y_fake = generate_fake_samples(generator, latent_dim, n)
	# evaluate discriminator on fake examples
	_, acc_fake = discriminator.evaluate(x_fake, y_fake, verbose=0)
	# summarize discriminator performance
	print(epoch, acc_real, acc_fake)
	# scatter plot real and fake data points
	pyplot.scatter(x_real[:, 0], x_real[:, 1], color='red')
	pyplot.scatter(x_fake[:, 0], x_fake[:, 1], color='blue')
	pyplot.show()
```

This function can then be called periodically during training.

For example, if we choose to train the models for 10,000 iterations, it may be interesting to check-in on the performance of the model every 2,000 iterations.

We can achieve this by parameterizing the frequency of the check-in via _n_eval_ argument, and calling the _summarize_performance()_ function from the _train()_ function after the appropriate number of iterations.

The updated version of the _train()_ function with this change is listed below.

```python
# train the generator and discriminator
def train(g_model, d_model, gan_model, latent_dim, n_epochs=10000, n_batch=128, n_eval=2000):
	# determine half the size of one batch, for updating the discriminator
	half_batch = int(n_batch / 2)
	# manually enumerate epochs
	for i in range(n_epochs):
		# prepare real samples
		x_real, y_real = generate_real_samples(half_batch)
		# prepare fake examples
		x_fake, y_fake = generate_fake_samples(g_model, latent_dim, half_batch)
		# update discriminator
		d_model.train_on_batch(x_real, y_real)
		d_model.train_on_batch(x_fake, y_fake)
		# prepare points in latent space as input for the generator
		x_gan = generate_latent_points(latent_dim, n_batch)
		# create inverted labels for the fake samples
		y_gan = ones((n_batch, 1))
		# update the generator via the discriminator's error
		gan_model.train_on_batch(x_gan, y_gan)
		# evaluate the model every n_eval epochs
		if (i+1) % n_eval == 0:
			summarize_performance(i, g_model, d_model, latent_dim)
```

## Complete Example of Training the GAN

We now have everything we need to train and evaluate a GAN on our chosen one-dimensional function.

The complete example is listed below.

```python
# train a generative adversarial network on a one-dimensional function
from numpy import hstack
from numpy import zeros
from numpy import ones
from numpy.random import rand
from numpy.random import randn
from keras.models import Sequential
from keras.layers import Dense
from matplotlib import pyplot

# define the standalone discriminator model
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# compile model
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model

# define the standalone generator model
def define_generator(latent_dim, n_outputs=2):
	model = Sequential()
	model.add(Dense(15, activation='relu', kernel_initializer='he_uniform', input_dim=latent_dim))
	model.add(Dense(n_outputs, activation='linear'))
	return model

# define the combined generator and discriminator model, for updating the generator
def define_gan(generator, discriminator):
	# make weights in the discriminator not trainable
	discriminator.trainable = False
	# connect them
	model = Sequential()
	# add generator
	model.add(generator)
	# add the discriminator
	model.add(discriminator)
	# compile model
	model.compile(loss='binary_crossentropy', optimizer='adam')
	return model

# generate n real samples with class labels
def generate_real_samples(n):
	# generate inputs in [-0.5, 0.5]
	X1 = rand(n) - 0.5
	# generate outputs X^2
	X2 = X1 * X1
	# stack arrays
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	X = hstack((X1, X2))
	# generate class labels
	y = ones((n, 1))
	return X, y

# generate points in latent space as input for the generator
def generate_latent_points(latent_dim, n):
	# generate points in the latent space
	x_input = randn(latent_dim * n)
	# reshape into a batch of inputs for the network
	x_input = x_input.reshape(n, latent_dim)
	return x_input

# use the generator to generate n fake examples, with class labels
def generate_fake_samples(generator, latent_dim, n):
	# generate points in latent space
	x_input = generate_latent_points(latent_dim, n)
	# predict outputs
	X = generator.predict(x_input)
	# create class labels
	y = zeros((n, 1))
	return X, y

# evaluate the discriminator and plot real and fake points
def summarize_performance(epoch, generator, discriminator, latent_dim, n=100):
	# prepare real samples
	x_real, y_real = generate_real_samples(n)
	# evaluate discriminator on real examples
	_, acc_real = discriminator.evaluate(x_real, y_real, verbose=0)
	# prepare fake examples
	x_fake, y_fake = generate_fake_samples(generator, latent_dim, n)
	# evaluate discriminator on fake examples
	_, acc_fake = discriminator.evaluate(x_fake, y_fake, verbose=0)
	# summarize discriminator performance
	print(epoch, acc_real, acc_fake)
	# scatter plot real and fake data points
	pyplot.scatter(x_real[:, 0], x_real[:, 1], color='red')
	pyplot.scatter(x_fake[:, 0], x_fake[:, 1], color='blue')
	pyplot.show()

# train the generator and discriminator
def train(g_model, d_model, gan_model, latent_dim, n_epochs=10000, n_batch=128, n_eval=2000):
	# determine half the size of one batch, for updating the discriminator
	half_batch = int(n_batch / 2)
	# manually enumerate epochs
	for i in range(n_epochs):
		# prepare real samples
		x_real, y_real = generate_real_samples(half_batch)
		# prepare fake examples
		x_fake, y_fake = generate_fake_samples(g_model, latent_dim, half_batch)
		# update discriminator
		d_model.train_on_batch(x_real, y_real)
		d_model.train_on_batch(x_fake, y_fake)
		# prepare points in latent space as input for the generator
		x_gan = generate_latent_points(latent_dim, n_batch)
		# create inverted labels for the fake samples
		y_gan = ones((n_batch, 1))
		# update the generator via the discriminator's error
		gan_model.train_on_batch(x_gan, y_gan)
		# evaluate the model every n_eval epochs
		if (i+1) % n_eval == 0:
			summarize_performance(i, g_model, d_model, latent_dim)

# size of the latent space
latent_dim = 5
# create the discriminator
discriminator = define_discriminator()
# create the generator
generator = define_generator(latent_dim)
# create the gan
gan_model = define_gan(generator, discriminator)
# train model
train(generator, discriminator, gan_model, latent_dim)
```

Running the example reports model performance every 2,000 training iterations (batches) and creates a plot.

Your specific results may vary given the stochastic nature of the training algorithm, and the generative model itself.

We can see that the training process is relatively unstable. The first column reports the iteration number, the second the classification accuracy of the discriminator for real examples, and the third column the classification accuracy of the discriminator for generated (fake) examples.

In this case, we can see that the discriminator remains relatively confused about real examples, and performance on identifying fake examples varies.

```
1999 0.45 1.0
3999 0.45 0.91
5999 0.86 0.16
7999 0.6 0.41
9999 0.15 0.93
```

I will omit providing the five created plots here for brevity; instead we will look at only two.

The first plot is created after 2,000 iterations and shows real (red) vs. fake (blue) samples. The model performs poorly initially with a cluster of generated points only in the positive input domain, although with the right functional relationship.

![Scatter Plot of Real and Generated Examples for the Target Function After 2,000 Iterations.](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Scatter-Plot-of-Real-and-Generated-Examples-for-the-Target-Function-After-2000-Iterations-1024x768.png)

Scatter Plot of Real and Generated Examples for the Target Function After 2,000 Iterations.

The second plot shows real (red) vs. fake (blue) after 10,000 iterations.

Here we can see that the generator model does a reasonable job of generating plausible samples, with the input values in the right domain between \[-0.5 and 0.5\] and the output values showing the X^2 relationship, or close to it.

![Scatter Plot of Real and Generated Examples for the Target Function After 10,000 Iterations.](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Scatter-Plot-of-Real-and-Generated-Examples-for-the-Target-Function-After-10000-Iterations-1024x768.png)

Scatter Plot of Real and Generated Examples for the Target Function After 10,000 Iterations.

## Extensions

This section lists some ideas for extending the tutorial that you may wish to explore.

* **Model Architecture**. Experiment with alternate model architectures for the discriminator and generator, such as more or fewer nodes, layers, and alternate activation functions such as leaky ReLU.
* **Data Scaling**. Experiment with alternate activation functions such as the hyperbolic tangent (tanh) and any required scaling of training data.
* **Alternate Target Function**. Experiment with an alternate target function, such a simple sine wave, Gaussian distribution, a different quadratic, or even a multi-modal polynomial function.

If you explore any of these extensions, I’d love to know.  
Post your findings in the comments below.

## 拓展阅读

如果你想更深入了解的话，这部分提供了关于这个话题更多的资源。

### API

*   [Keras API](https://keras.io/)
*   [How can I “freeze” Keras layers?](https://keras.io/getting-started/faq/#how-can-i-freeze-keras-layers)
*   [MatplotLib API](https://matplotlib.org/api/)
*   [numpy.random.rand API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.random.rand.html)
*   [numpy.random.randn API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.random.randn.html)
*   [numpy.zeros API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.zeros.html)
*   [numpy.ones API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.ones.html)
*   [numpy.hstack API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.hstack.html)

## Summary

在这个教程中，你发现了如何为一个一维函数从头搭建一个生成对抗网络。

特别是，你学到了：

* 使用一个简单的一维函数从头搭建一个生成对抗网络的好处。
* 如何搭建独立的判别器和生成器模型，以及一个通过判别器预测行为来训练生成器的组合模型。
* 如何在问题域中真实数据的环境中主观地评估生成的样本。

你有任何问题吗？
在下方的评论中写下你的问题，我会尽我所能来回答。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
