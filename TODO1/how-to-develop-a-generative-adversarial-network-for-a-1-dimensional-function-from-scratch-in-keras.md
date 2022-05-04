> * 原文地址：[How to Develop a 1D Generative Adversarial Network From Scratch in Keras](https://machinelearningmastery.com/how-to-develop-a-generative-adversarial-network-for-a-1-dimensional-function-from-scratch-in-keras/)
> * 原文作者：[Jason Brownlee](https://www.pyimagesearch.com/author/adrian/) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-a-generative-adversarial-network-for-a-1-dimensional-function-from-scratch-in-keras.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-a-generative-adversarial-network-for-a-1-dimensional-function-from-scratch-in-keras.md)
> * 译者：[TokenJan](https://github.com/TokenJan)
> * 校对者：[haiyang-tju](https://github.com/haiyang-tju)、[司徒公子](https://github.com/stuchilde)

# 如何用 Keras 从头搭建一维生成对抗网络

[生成对抗网络，或简称 GANs](https://machinelearningmastery.com/what-are-generative-adversarial-networks-gans/)，是一个深度学习框架，用于训练强大的生成器模型。

生成器模型可以用来生成新的假样本，这很可能来自于现有的样本分布。

GANs 由生成器模型和判别器模型组成。生成器负责从领域中生成新的样本，判别器负责感知这些样本的真伪（生成的）。重要的是，判别器模型的性能被用来更新判别器自己和生成器的模型权重。这意味着生成器无法感知来自领域中的样本，而是基于判别器的表现来作出调整。

这是一个理解和训练都复杂的模型。

一个更好地理解 GAN 模型本质以及如何训练它们的方法是基于简单任务从头开始构建一个模型。

一维函数这个简单的任务为从头搭建一个简单的 GAN 提供了好环境。这是因为真实的和生成的样本均可以被绘制出来，通过可视化来检查到底学习到了什么。一个简单的函数也不需要复杂的神经网络模型，这意味着架构中使用特定的生成器和判别器可以很容易被理解。

在这个教程中，我们将选择一个简单的一维函数，以此为基础，使用 Keras 深度学习库从头搭建和评估一个 GAN。

在完成本教程后，你将学习到：

* 使用一个简单的一维函数从头搭建一个 GAN 的好处。
* 如何搭建独立的判别器和生成器模型，以及一个通过判别器预测行为来训练生成器的复合模型。
* 如何在问题域中的真实数据环境中主观评估生成样本。

[在我新的 GANs 书中](/generative_adversarial_networks/)可以找到如何搭建 DCGANs、conditional GANs、Pix2Pix、CycleGANs 等内容，其中还附有 29 个循序渐进的教程和完整的源代码。

让我们开始吧。

![如何用 Keras 从头搭建一维函数 GAN ](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/06/How-to-Develop-a-Generative-Adversarial-Network-for-a-1-Dimensional-Function-From-Scratch-in-Keras.jpg)

如何用 Keras 从头搭建一维函数 GAN
这张照片由 [Chris Bambrick](https://www.flickr.com/photos/lntervention/16865473804/) 拍摄，并保留权利。

## 教程概述

本教程分为六个部分，分别是：

1. 选择一个一维函数
2. 定义一个判别器模型
3. 定义一个生成器模型
4. 训练生成器模型
5. 评估 GAN 的性能
6. 训练 GAN 的完整示例

## 选择一个一维函数

第一步是选择一维函数建模。

函数形如：

```
y = f(x)
```

其中，_x_ 和 _y_ 是函数的输入值和输出值。

特别的是，我们需要一个易于理解和绘制的函数。这将有助于设定对模型应该生成的期望，并有助于对生成的样本进行可视化检查以了解其质量。

我们将会使用一个简单的函数 _x^2_；这个函数会返回输入值的平方。你可能还记得高中代数学到的这个函数，它是一个 _u_ 型函数。

我们可以在 Python 中这样定义这个函数：

```python
# 简单的函数
def calculate(x):
	return x * x
```
我们可以定义输入域为在 -0.5 到 0.5 之间的实数，并且在线性范围内计算每个输入值对应的输出值，然后绘制结果来了解输入和输出是如何关联的。

完整的例子如下。

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

运行这个例子为每个输入值计算其输出值，并且绘制一张输入值和输出值的关系图。

我们可以看到远离 0 的值能得到较大的输出值，反之接近 0 的值会得到较小的输出值，并且此行为是关于 y 轴对称的。

这就是著名的一维函数 X^2 的 u 型图。

![X^2 函数的输入输出图](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-inputs-vs-outputs-for-X^2-function-1024x768.png)

X^2 函数的输入输出图。

我们可以从这个函数中随机的生成样本或点。

这个可以通过生成在 -0.5 和 0.5 之间的随机值，并且计算其对应的输出值来实现。多次重复这个步骤就能得到该函数的样本点，比如“_真实的样本_”。

用散点图绘制这些样本将会显示同样的 u 型图，尽管这些是由独立的随机样本构成的。

完整的例子如下所述。

首先，我们在 0 和 1 之间均匀地生成随机值，然后将它们偏移到 -0.5 和 0.5 范围内。然后我们为每一个随机生成的输入值计算其对应的输出值，并把这些矩阵组合并成一个 n 行（100）和 2 列的单 Numpy 数组。

```python
# 从 X^2 中生成随机样本的例子
from numpy.random import rand
from numpy import hstack
from matplotlib import pyplot

# 从 x^2 中生成随机样本
def generate_samples(n=100):
	# 在 [-0.5, 0.5] 区间内生成随机输入
	X1 = rand(n) - 0.5
	# 生成 X^2 （二次方）的输出
	X2 = X1 * X1
	# 堆叠数组
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

我们可以将这个函数作为判别器函数生成真实样本的起始点。尤其是一个样本是由两个元素的向量组成的，一个作为输入，一个作为我们的一维函数的输出。

我们也可以想象一个生成器模型是如何生成新样本的，我们可以绘制它们同时与期望的 u 型 X^2 函数比较。特别是一个生成器可以输出一个由两个元素组成的向量：一个作为输入，一个作为一维函数的输出。

## 定义一个判别器模型

下一步是定义判别器模型。

这个模型必须从我们的问题域中抽取一个样本，比如一个由两个元素组成的向量，然后输出一个分类预测来区分这个样本的真假。

这是一个二分类问题。

* **输入**：由两个实数组成的样本。
* **输出**：二分类，样本为真（或假）的可能性。

这个问题非常简单，意味着我们不需要一个复杂的神经网络来建模。

这个判别器模型有一个隐藏层，其中含有 25 个神经元，使用 [ReLU 激活函数](https://machinelearningmastery.com/rectified-linear-activation-function-for-deep-learning-neural-networks/)和合适权值的 He 初始化方法。

输出层包含一个神经元，它用 sigmoid 激活函数来做二分类。

这个模型将会最小化二分类的交叉熵损失函数，以及用 [Adam 版本的随机梯度下降](https://machinelearningmastery.com/adam-optimization-algorithm-for-deep-learning/)，因为它非常有效。

下面的 _define_discriminator()_ 函数定义和返回了判别器模型。这个函数参数化了期望的输入个数，默认值为 2。

```python
# 定义独立的判别器模型
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model
```

我们可以使用这个函数来定义和总结这个判别器模型。完整的例子如下所示。

```python
# 定义判别器模型
from keras.models import Sequential
from keras.layers import Dense
from keras.utils.vis_utils import plot_model

# 定义独立的判别器模型
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model

# 定义判别模型
model = define_discriminator()
# 总结模型
model.summary()
# 绘制模型
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

该模型的图也被生成了，可以看到该模型有两个输入和一个输出。

**注意**：生成这张模型图需要安装 pydot 和 graphviz 库。如果安装遇到了问题，你可以把引入 _plot_model_ 函数的 import 语句和调用 _plot_model_ 方法注释掉。

![GAN 中生成器模型图](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-the-Discriminator-Model-in-the-GAN.png)

GAN 中生成器模型图

现在可以开始训练这个模型了，用到的数据是标记为 1 的真实数据和标记为 0 的随机生成数据。

我们不需要做这件事，但是这些我们开发的元素在之后会变得很有帮助，并且它帮助我们认识到生成器只是一个普通的神经网络模型。

首先，我们可以从预测的部分更新我们的 _generate_samples()_ 方法，命名为 _generate\_real\_samples()_，它会返回真实样本的输出标签，也就是一个由 1 组成的数组，这里 1 表示真实样本。

```python
# 生成 n 个真实样本和分类标签
def generate_real_samples(n):
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

这个方法将作为假数据生成器模型。

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
	# 生成分类标签
	y = zeros((n, 1))
	return X, y
```

下一步，我们需要一个训练和评估生成器模型的方法。

这可以通过手动遍历训练的 epoch（译者注：一个 epoch 是指将所有数据循环训练一遍），在每个 epoch 中，生成一半的真实样本和一半的假样本，然后在一整批样本上更新模型。可以使用 _train()_ 方法来训练，但是在这种情况下，我们将直接用 _train\_on\_batch()_ 方法。

这个模型可以根据生成的样本进行评估，并且我们可以生成真假样本分类准确率的报告。

下面的 _train_discriminator()_ 方法实现了为模型训练 1000 个 batch（译者注：一个 batch 指训练模型的一个批次），每个 batch 包含 128 个样本（64 个假样本和 64 个真样本）。

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

运行上面的代码会生成真实的和假的样本并且更新模型，然后在同样的样本上评估模型并打印出分类的准确率。

结果可能会不同但是模型会快速地学习，以完美的准确率正确地识别真实的样本，并且非常擅长识别假样本，正确率在 80% 和 90% 之间。

```
...
995 1.0 0.875
996 1.0 0.921875
997 1.0 0.859375
998 1.0 0.9375
999 1.0 0.8125
```

训练判别器模型的过程是非常直观的。而我们的目标是训练一个生成器模型，并不是判别器模型，这才是生成 GANs 真正复杂的地方。

## 定义一个生成器模型

下一步是定义生成器模型。

生成器模型从隐空间中选取一个点作为输入并且生成一个新的样本，比如把函数的输入和输出元素作为一个向量，例如 x 和 x^2。

隐变量是一个隐藏的或者未被观察到的变量，隐空间是一个由这些变量组成的多维向量空间。我们可以为问题定义隐空间的维度大小以及它的形状或变量的分布。

隐空间是没有意义的，直到生成器模型开始学习并为空间中的点赋予意义。训练之后，隐空间的点将和输出空间中的点相关联，比如生成样本空间。

我们定义一个小的五维隐空间，并且使用 GAN 文献中标准的方法，即隐空间中每一个变量都使用高斯分布。我们将从一个标准高斯分布中获取随机数来生成输入值，比如均值为 0，标准差为 1。

* **输入**：隐空间中的点，比如由五个高斯随机数组成的向量。
* **输出**：两个元素组成的向量，代表了为我们的函数生成的样本（x 和 x^2）。

生成器模型会和判别器模型一样小。

它只有一个隐藏层，其中有五个神经元，使用 [ReLU 激活函数](https://machinelearningmastery.com/rectified-linear-activation-function-for-deep-learning-neural-networks/)和 He 权重初始化方法。输出层有两个神经元表示生成向量中的两个元素，并且使用线性激活函数。

最后使用线性激活函数是因为想让生成器输出实数向量，第一个元素的范围是 \[-0.5, 0.5\]，第二个元素的范围是 \[0.0, 0.25\]。

这个模型没有被编译。原因是生成器模型不是直接被加载的。

下面的 _define_generator()_ 方法定义并返回了生成器模型。

隐空间的维度大小被参数化以防后面需要改变，模型的输出维度大小也被参数化，这与定义的判别器模型的函数是相匹配的。

```python
# 定义独立的生成器模型
def define_generator(latent_dim, n_outputs=2):
	model = Sequential()
	model.add(Dense(15, activation='relu', kernel_initializer='he_uniform', input_dim=latent_dim))
	model.add(Dense(n_outputs, activation='linear'))
	return model
```

我们可以总结这个模型来帮助更好地理解输入和输出的成形。

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

模型图也被生成了，我们可以看到这个模型期望从隐空间中获取一个由五元向量作为输入，并且预测一个由二元向量作为输出。

**注意**：生成这张模型图需要安装 pydot 和 graphviz 库。如果安装遇到了问题，你可以把引入 _plot_model_ 函数的 import 语句和调用 _plot_model_ 方法注释掉。

![绘制 GAN 中的生成器模型](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-the-Generator-Model-in-the-GAN.png)

绘制 GAN 中的生成器模型

我们可以看到模型从隐空间中获取一个随机的五元向量，然后为一维函数输出一个二元向量。

此模型目前还不能做太多事情。不过，我们可以用来演示如何使用它来生成样本。这不是必须的，但同样，其中的某些元素稍后可能会有用。

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
	# 在隐空间中生成点
	x_input = generate_latent_points(latent_dim, n)
	# 预测输出
	X = generator.predict(x_input)
	# 绘制结果
	pyplot.scatter(X[:, 0], X[:, 1])
	pyplot.show()

# 隐空间的维度大小
latent_dim = 5
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

当判别器很擅于检测假样本时，生成器会更新较大，而当判别器对于检测假样本相对不擅长或者被迷惑时，生成器会更新较小。

这定义了两个模型之间的零和或对抗关系。

有许多使用 Keras API 来实现它的方式，但或许最简单的方法就是创建一个新的模型，这个模型包含或封装生成器和判别器模型。

特别的是，一个新的 GAN 模型可以定义为堆叠生成器和判别器，生成器在隐空间中接收随机点作为输入，生成样本直接被提供给判别器模型的样本，然后分类，最后，这个大模型的输出可以被用来更新生成器模型的权重。

要清楚，我们不是在讨论一个新的第三方模型，只是一个逻辑上第三方的模型，它用了独立生成器和判别器模型中已定义的图层和权重。

在区分真假数据的时候只涉及到判别器；因此，判别器模型可以通过真假数据被单独训练。

生成器模型只和判别器模型在假数据上的表现有关。因此，当判别器是 GAN 模型的一部分的时候，我们会将判别器中的所有层标记为不可训练的，它们在假数据上不会更新参数以防被过度训练。

当通过这个合并的生成对抗网路模型来训练生成器的时候，还有一个重要的地方需要改变。我们想让判别器认为生成器输出的样本是真的，而不是假的。因此，当生成器在作为 GAN 一部分训练的时候，我们将标记生成的样本设置为真（类标签为 1）。

我们可以想像判别器将生成的样本归类为不是真的（类标签为 0）或者为真的可能性较低（0.3 或 0.5）。用来更新模型权重的反向传播过程将其视为一个大的误差，然后将更新模型权重（比如只有在生成器中的权重）来纠正这个误差，反过来使得生成器更好更合理的生成假样本。

让我们具体点。

* **输入**: 隐空间中的点，比如一个由高斯随机数组成的五元向量。
* **输出**: 二分类，样本为真（或假）的可能性。

下面 _define_gan()_ 方法将已经定义好的生成器和判别器作为参数，并且创建了一个逻辑上的第三个包含这两个模型的新模型。判别器中的权重被标记为不可训练，这只会影响 GAN 中的权重，而不会影响独立的判别器模型。

GAN 模型使用同样的二分类交叉熵损失函数作为判别器以及高效的 [Adam 版本的随机梯度下降](https://machinelearningmastery.com/adam-optimization-algorithm-for-deep-learning/)。

```python
# 为更新生成器，定义合并的生成器和判别器模型
def define_gan(generator, discriminator):
	# 标记判别器中的权重为不可训练
	discriminator.trainable = False
	# 把他们连接起来
	model = Sequential()
	# 加入生成器
	model.add(generator)
	# 加入判别器
	model.add(discriminator)
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam')
	return model
```

使得判别器不可训练是 Keras API 中一个聪明的技巧。

当模型被编译的时候，_trainable_ 属性会影响它。判别器模型使用可训练层进行编译，因此调用 _train\_on\_batch()_ 来更新独立模型，也会更新这些层中的权重模型。

判别器模型被标记为不可训练，加入 GAN 模型，然后被编译。在这个模型中，通过调用 _train\_on\_batch()_ 来更新 GAN 模型时，判别器模型中的权重是不可训练且无法更改的。

Keras API 文档中描述了这种行为：

* [我如何能够 “冻结” Keras 层？](https://keras.io/getting-started/faq/#how-can-i-freeze-keras-layers)

下面列出了创建判别器、生成器和组合模型的完整示例。

```python
# 演示创建 GAN 的三种模型
from keras.models import Sequential
from keras.layers import Dense
from keras.utils.vis_utils import plot_model

# 定义独立的判别器模型
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model

# 定义独立的生成器模型
def define_generator(latent_dim, n_outputs=2):
	model = Sequential()
	model.add(Dense(15, activation='relu', kernel_initializer='he_uniform', input_dim=latent_dim))
	model.add(Dense(n_outputs, activation='linear'))
	return model

# 定义合并的生成器和判别器模型，为了更新生成器
def define_gan(generator, discriminator):
	# 标记判别器模型中的权重为不可训练
	discriminator.trainable = False
	# 连接它们
	model = Sequential()
	# 加入生成器
	model.add(generator)
	# 加入判别器
	model.add(discriminator)
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam')
	return model

# 隐空间的维度大小
latent_dim = 5
# 创建判别器
discriminator = define_discriminator()
# 创建生成器
generator = define_generator(latent_dim)
# 创建 GAN
gan_model = define_gan(generator, discriminator)
# 总结 GAN 模型
gan_model.summary()
# 绘制 GAN 模型
plot_model(gan_model, to_file='gan_plot.png', show_shapes=True, show_layer_names=True)
```

运行这个例子首先会创建组合模型的总结。

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

模型图也被创建了，并且我们可以看到模型期望在隐空间中有一个五元点作为输入，以及预测一个输出的分类标签。

**注意**：生成这张模型图需要安装 pydot 和 graphviz 库。如果安装遇到了问题，你可以把引入 _plot_model_ 函数的 import 语句和调用 _plot_model_ 方法注释掉。

![GAN 中生成器和判别器组合模型图](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Plot-of-the-Composite-Generator-and-Discriminator-Model-in-the-GAN.png)

GAN 中生成器和判别器组合模型图

训练组合模型包括通过前一个章节中的 _generate\_latent\_points()_ 方法在隐空间中生成一批点，以及 class=1 的标签，调用 _train\_on\_batch()_ 方法。

下面的 _train_gan()_ 方法演示了这个过程，虽然这个过程不是非常有趣，因为每个 epoch 中只有生成器会被更新，判别器保持默认的模型权重。

```python
# 训练组合模型
def train_gan(gan_model, latent_dim, n_epochs=10000, n_batch=128):
	# 手动遍历 epoch
	for i in range(n_epochs):
		# 为生成器准备隐空间中的点作为输入
		x_gan = generate_latent_points(latent_dim, n_batch)
		# 为假样本创建反标签
		y_gan = ones((n_batch, 1))
		# 通过判别器的误差更新生成器
		gan_model.train_on_batch(x_gan, y_gan)
```

我们首先需要用真假样本来更新判别器模型，然后再用组合模型更新生成器。

这需要合并定义在判别器中的 _train_discriminator()_ 方法以及上面定义的 _train_gan()_ 方法中的元素。也需要  _generate\_fake\_samples()_ 方法使用生成器模型来生成假样本而不是生成随机数。

更新判别器模型和生成器（通过组合模型）的完整训练方法如下所示。

```python
# 训练生成器和判别器
def train(g_model, d_model, gan_model, latent_dim, n_epochs=10000, n_batch=128):
	# 将一半 batch 数量用来更新判别器
	half_batch = int(n_batch / 2)
	# 手动遍历 epoch
	for i in range(n_epochs):
		# 准备真实样本
		x_real, y_real = generate_real_samples(half_batch)
		# 准备假样本
		x_fake, y_fake = generate_fake_samples(g_model, latent_dim, half_batch)
		# 更新判别器
		d_model.train_on_batch(x_real, y_real)
		d_model.train_on_batch(x_fake, y_fake)
		# 准备隐空间中的点作为生成器中的输入
		x_gan = generate_latent_points(latent_dim, n_batch)
		# 为假样本创建反标签
		y_gan = ones((n_batch, 1))
		# 通过判别器的误差更新生成器
		gan_model.train_on_batch(x_gan, y_gan)
```

我们几乎准备好了使用一维函数搭建一个 GAN 所需的一切。

剩下的部分就是模型评估了。

## 评估 GAN 的表现

通常来说，没有客观的方法来评估 GAN 模型的性能。

在这个特殊的例子中，我们可以为生成的样本设计一种客观的衡量指标，因为我们知道潜在真实的输入域和目标函数，并且可以计算一个客观的误差测定。

然而，我们不会在这个教程中计算这个客观的误差值。取而代之的是，我们将使用在大多数 GAN 应用中被使用的主观方法。特别的是，我们将使用生成器来生成新的样本，然后检查它们和领域中真实样本的差距。

首先，我们可以使用之前判别器部分创建的 _generate\_real\_samples()_ 方法来生成新的样本。用这些样本来绘制散点图会生成我们熟悉的 u 形目标函数。

```python
# 生成 n 个真实样本和类标签
def generate_real_samples(n):
	# 生成 [-0.5, 0.5] 范围内的输入值
	X1 = rand(n) - 0.5
	# 生成输出值 X^2
	X2 = X1 * X1
	# 堆叠数组
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	X = hstack((X1, X2))
	# 生成类标签
	y = ones((n, 1))
	return X, y
```

下一步，我们可以用生成器模型来生成同样数量的假样本。

这首先需要通过上面生成器部分创建的 _generate\_latent\_points()_ 方法，在隐空间中生成同样数量的点。这些点可以被传入生成器模型并生成样本，这些样本可以在同样的散点图上被绘制。

```python
# 在隐空间中生成点作为生成器的输入
def generate_latent_points(latent_dim, n):
	# 在隐空间中生成点
	x_input = randn(latent_dim * n)
	# 为网络调整一个 batch 输入的维度大小
	x_input = x_input.reshape(n, latent_dim)
	return x_input
```

下面的 _generate\_fake\_samples()_ 方法生成了这些假样本和相关联的类标签 0，这些之后会有用。

```python
# 用生成器生成 n 个假样本和类标签
def generate_fake_samples(generator, latent_dim, n):
	#在隐空间中生成点
	x_input = generate_latent_points(latent_dim, n)
	# 预测输出
	X = generator.predict(x_input)
	# 创建类标签
	y = zeros((n, 1))
	return X, y
```

两种样本在同一张图上被绘制使得它们可以直接通过主观上查看是否同样的输入和输出域被覆盖了来比较，以及是否目标函数期望的形状被合适地描绘出来。

下面的 _summarize_performance()_ 方法可以在训练的任意时间点被调用，通过它可以绘制真实的和生成的散点图，以此对生成模型当下的能力有一个大致的了解。

```python
# 绘制真假点
def summarize_performance(generator, latent_dim, n=100):
	# 准备真实样本
	x_real, y_real = generate_real_samples(n)
	# 准备假样本
	x_fake, y_fake = generate_fake_samples(generator, latent_dim, n)
	# 绘制真假数据点的散点图
	pyplot.scatter(x_real[:, 0], x_real[:, 1], color='red')
	pyplot.scatter(x_fake[:, 0], x_fake[:, 1], color='blue')
	pyplot.show()
```

另外，我们可能也会对判别器模型的性能感兴趣。

确切的说，我们对于了解判别器模型正确区分真假样本的能力感兴趣。一个好的生成器模型应该能迷惑判别器模型，导致在真假样本上的分类准确率接近 50%。

我们可以更新 _summarize_performance()_ 方法，使它接收判别器和当前的 epoch 数作为参数，并且生成真假样本准确率的报告。

```python
# 评估判别器并且绘制真假点
def summarize_performance(epoch, generator, discriminator, latent_dim, n=100):
	# 准备真实样本
	x_real, y_real = generate_real_samples(n)
	# 在真实样本上评估判别器
	_, acc_real = discriminator.evaluate(x_real, y_real, verbose=0)
	# 准备假样本
	x_fake, y_fake = generate_fake_samples(generator, latent_dim, n)
	# 在假样本上评估判别器
	_, acc_fake = discriminator.evaluate(x_fake, y_fake, verbose=0)
	# 总结判别器性能
	print(epoch, acc_real, acc_fake)
	# 绘制真假数据的散点图
	pyplot.scatter(x_real[:, 0], x_real[:, 1], color='red')
	pyplot.scatter(x_fake[:, 0], x_fake[:, 1], color='blue')
	pyplot.show()
```

这个方法可以在训练时被周期性调用。

比如，如果我们将模型迭代训练 10000 次，每 2000 次迭代检查一下这个模型的性能。

我们可以通过 _n_eval_ 行参来参数化检查的频率，并且在一定数量的迭代之后从 _train()_ 方法中调用 _summarize_performance()_ 方法。

更新后的 _train()_ 方法如下所示。

```python
# 训练生成器和判别器
def train(g_model, d_model, gan_model, latent_dim, n_epochs=10000, n_batch=128, n_eval=2000):
	# 用一半的 batch 数量来更新判别器
	half_batch = int(n_batch / 2)
	# 手动遍历 epoch
	for i in range(n_epochs):
		# 准备真实样本
		x_real, y_real = generate_real_samples(half_batch)
		# 准备假样本
		x_fake, y_fake = generate_fake_samples(g_model, latent_dim, half_batch)
		# 更新判别器
		d_model.train_on_batch(x_real, y_real)
		d_model.train_on_batch(x_fake, y_fake)
		# 准备隐空间中的点作为生成器的输入
		x_gan = generate_latent_points(latent_dim, n_batch)
		# 为假样本创建反标签
		y_gan = ones((n_batch, 1))
		# 通过判别器的误差更新生成器
		gan_model.train_on_batch(x_gan, y_gan)
		# 每 n_eval epoch 评估模型
		if (i+1) % n_eval == 0:
			summarize_performance(i, g_model, d_model, latent_dim)
```

## 训练 GAN 的完整例子

我们现在有了为一维函数来训练和评估 GAN 所需的所有条件。

完整的例子如下所示。

```python
# 在一个一维函数上训练一个 GAN
from numpy import hstack
from numpy import zeros
from numpy import ones
from numpy.random import rand
from numpy.random import randn
from keras.models import Sequential
from keras.layers import Dense
from matplotlib import pyplot

# 定义独立的判别器模型
def define_discriminator(n_inputs=2):
	model = Sequential()
	model.add(Dense(25, activation='relu', kernel_initializer='he_uniform', input_dim=n_inputs))
	model.add(Dense(1, activation='sigmoid'))
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
	return model

# 定义独立的生成器模型
def define_generator(latent_dim, n_outputs=2):
	model = Sequential()
	model.add(Dense(15, activation='relu', kernel_initializer='he_uniform', input_dim=latent_dim))
	model.add(Dense(n_outputs, activation='linear'))
	return model

# 定义合并的生成器和判别器模型，来更新生成器
def define_gan(generator, discriminator):
	# 将判别器的权重设为不可训练
	discriminator.trainable = False
	# 连接它们
	model = Sequential()
	# 加入生成器
	model.add(generator)
	# 加入判别器
	model.add(discriminator)
	# 编译模型
	model.compile(loss='binary_crossentropy', optimizer='adam')
	return model

# 生成 n 个真实样本和类标签
def generate_real_samples(n):
	# 生成 [-0.5, 0.5] 范围内的输入值
	X1 = rand(n) - 0.5
	# 生成输出值 X^2
	X2 = X1 * X1
	# 堆叠数组
	X1 = X1.reshape(n, 1)
	X2 = X2.reshape(n, 1)
	X = hstack((X1, X2))
	# 生成类标签
	y = ones((n, 1))
	return X, y

# 生成隐空间中的点作为生成器的输入
def generate_latent_points(latent_dim, n):
	# 在隐空间中生成点
	x_input = randn(latent_dim * n)
	# 为网络调整一个 batch 输入的维度大小
	x_input = x_input.reshape(n, latent_dim)
	return x_input

# 用生成器生成 n 个假样本和类标签
def generate_fake_samples(generator, latent_dim, n):
	# 在隐空间中生成点
	x_input = generate_latent_points(latent_dim, n)
	# 预测输出值
	X = generator.predict(x_input)
	# 创建类标签
	y = zeros((n, 1))
	return X, y

# 评估判别器并且绘制真假点
def summarize_performance(epoch, generator, discriminator, latent_dim, n=100):
	# 准备真实样本
	x_real, y_real = generate_real_samples(n)
	# 在真实样本上评估判别器
	_, acc_real = discriminator.evaluate(x_real, y_real, verbose=0)
	# 准备假样本
	x_fake, y_fake = generate_fake_samples(generator, latent_dim, n)
	# 在假样本上评估判别器
	_, acc_fake = discriminator.evaluate(x_fake, y_fake, verbose=0)
	# 总结判别器性能
	print(epoch, acc_real, acc_fake)
	# 绘制真假数据的散点图
	pyplot.scatter(x_real[:, 0], x_real[:, 1], color='red')
	pyplot.scatter(x_fake[:, 0], x_fake[:, 1], color='blue')
	pyplot.show()

# 训练生成器和判别器
def train(g_model, d_model, gan_model, latent_dim, n_epochs=10000, n_batch=128, n_eval=2000):
	# 用一半的 batch 数量来训练判别器
	half_batch = int(n_batch / 2)
	# 手动遍历 epoch
	for i in range(n_epochs):
		# 准备真实样本
		x_real, y_real = generate_real_samples(half_batch)
		# 准备假样本
		x_fake, y_fake = generate_fake_samples(g_model, latent_dim, half_batch)
		# 更新判别器
		d_model.train_on_batch(x_real, y_real)
		d_model.train_on_batch(x_fake, y_fake)
		# 在隐空间中准备点作为生成器的输入
		x_gan = generate_latent_points(latent_dim, n_batch)
		# 为假样本创建反标签
		y_gan = ones((n_batch, 1))
		# 通过判别器的误差更新生成器
		gan_model.train_on_batch(x_gan, y_gan)
		# 为每 n_eval epoch 模型做评估
		if (i+1) % n_eval == 0:
			summarize_performance(i, g_model, d_model, latent_dim)

# 隐空间的维度
latent_dim = 5
# 创建判别器
discriminator = define_discriminator()
# 创建生成器
generator = define_generator(latent_dim)
# 创建 GAN
gan_model = define_gan(generator, discriminator)
# 训练模型
train(generator, discriminator, gan_model, latent_dim)
```

运行这个例子将每训练 2000 个 batch 生成模型性能的报告并且绘制一张散点图。

你们自己的结果可能会不同因为训练算法的随机特性以及生成模型自己的特性。

我们可以看到训练的过程是相对不稳定的。第一列是迭代数，第二列是判别器针对真实样本的分类准确率，第三列是判别器针对生成（假）样本的分类准确率。

在这个情况下，我们可以看到判别器对于真实样本还是相当困惑的，对于识别假样本的表现也是差异很大。

```
1999 0.45 1.0
3999 0.45 0.91
5999 0.86 0.16
7999 0.6 0.41
9999 0.15 0.93
```

简单起见，我将省略五个创建的散点图；我们将只看其中两个。

第一张图是在 2000 个迭代之后创建的，显示了真实（红）和虚假（蓝）样本的对比。一开始模型表现得并不好，生成的点只在正的输入域中，虽然函数关系是正确的。

![2000 次迭代后为目标函数绘制的真实以及生成样本的散点图。](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Scatter-Plot-of-Real-and-Generated-Examples-for-the-Target-Function-After-2000-Iterations-1024x768.png)

2000 次迭代后为目标函数绘制的真实以及生成样本的散点图。

第二散点图是在 10000 次迭代之后真实（红）和虚假（蓝）样本的对比。

这里我们可以看到生成模型确实生成了逼真的样本，输入域在 -0.5 和 0.5 之间正确的范围，并且输出值显示了近似 X^2 的函数关系。

![10000 次迭代后为目标函数绘制的真实以及生成样本的散点图。](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/04/Scatter-Plot-of-Real-and-Generated-Examples-for-the-Target-Function-After-10000-Iterations-1024x768.png)

10000 次迭代后为目标函数绘制的真实以及生成样本的散点图。

## 拓展

这个部分列举了一些在教程之外你可能希望探索的一些想法。

* **模型架构**：用其它判别器和生成器的模型架构做实验，比如更多或更少的神经元，层以及代替的激活函数比如 leaky ReLU。
* **数据规模**：用其他的激活函数比如 hyperbolic tangent (tanh) 和任意需要的训练数据规模。
* **其他的目标函数**：用其他的目标函数，比如一个简单的 sine 曲线，高斯分布，一个不同的二次方程或者甚至一个多模态的多项式函数。

如果你探索了这些扩展，我很想了解。
在下方的评论中留下你的发现。

## 拓展阅读

如果你想更深入了解的话，本节提供了关于这个话题更多的资源。

### API

*   [Keras API](https://keras.io/)
*   [我如何可以“冻结” Keras 层？](https://keras.io/getting-started/faq/#how-can-i-freeze-keras-layers)
*   [MatplotLib API](https://matplotlib.org/api/)
*   [numpy.random.rand API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.random.rand.html)
*   [numpy.random.randn API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.random.randn.html)
*   [numpy.zeros API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.zeros.html)
*   [numpy.ones API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.ones.html)
*   [numpy.hstack API](https://docs.scipy.org/doc/numpy/reference/generated/numpy.hstack.html)

## 总结

在这个教程中，你学习了如何使用一个一维函数从头搭建一个 GAN。

具体来说，你学到了：

* 使用一个简单的一维函数从头搭建一个 GAN 的好处。
* 如何搭建独立的判别器和生成器模型，以及一个通过判别器预测行为来训练生成器的组合模型。
* 如何在问题域中真实数据的环境中主观地评估生成的样本。

你有任何问题吗？
在下方的评论中写下你的问题，我会尽我所能来回答。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
