> * 原文地址：[How to Configure Image Data Augmentation When Training Deep Learning Neural Networks](https://machinelearningmastery.com/how-to-configure-image-data-augmentation-when-training-deep-learning-neural-networks/)
> * 原文作者：[Jason Brownlee](https://machinelearningmastery.com/author/jasonb/ "Posts by Jason Brownlee") 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-configure-image-data-augmentation-when-training-deep-learning-neural-networks.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-configure-image-data-augmentation-when-training-deep-learning-neural-networks.md)
> * 译者：[ccJia](https://github.com/ccJia)
> * 校对者：[lsvih](https://github.com/lsvih), [Minghao23](https://github.com/Minghao23)

# 在深度学习训练过程中如何设置数据增强？

图像数据增强是人工增加训练集的一种方式，主要是通过修改数据集中的图片达成。

更多的训练数据带来的是更有效的深度学习模型，同时，数据增强技术会产生更多的图片变体，这些变体会提高模型对新图片的泛化能力。

在 Keras 框架中，_ImageDataGenerator_ 类提供了数据增强的相关功能。

在本教程中，你将学会如何在训练模型时使用图像数据增强技术。

在完成本教程后，你将明白下面几点：

*   图像数据增强是为了扩展训练数据集从而提高模型的精度和泛化能力。
*   在 Keras 框架中，你可以通过 _ImageDataGenerator_ 类使用图像数据增强方法。
*   如何使用平移、翻转、亮度以及缩放的数据增强方法。

让我们开始吧。

## 教程总览

本教程被分为以下八个部分，他们分别是：

1.  图像数据增强
2.  样本图片
3.  使用 ImageDataGenerator 进行数据增强
4.  水平和垂直方向的平移增强
5.  水平和垂直方向的翻转增强
6.  随机旋转增强
7.  随机亮度增强
8.  随机缩放增强

## 数据增强

深度学习网络的表现总是和数据量成正比的。

数据增强是一种人工的在原有数据基础上增加新训练数据的方法，是利用特定领域的技术将训练集的数据转变成一个新的数据达成的。

图像数据增强大概是最众所周知的一种数据增强方法，主要是涉及创建一个和原始图片属于同一类别的变形后的图片。

从图像处理领域我们可以获得很多的变形方法，比如：平移、翻转、缩放等等。

这么做的主要意图是用合理的新数据去扩展训练数据。换句话说，我们可以让模型看到更多样性的训练数据。举个例子，如果我们对一只猫进行水平的翻转，这个是有意义的，因为摄像头的拍摄角度可能是左边也可能是右边。但是做垂直翻转就没什么意义并且不太适合，因为模型不太会接收到一个头上脚下的猫。

所以，我们应该明白，我们一定要根据训练数据和问题领域的具体场景来慎重的选择应用于训练集的数据增强方法。此外，有一种比较有效的方法，就是在小的原型数据集上做一些独立的实验来度量增强后的模型是否在性能上有所提升。

现代的深度学习方法，像卷积神经网络（CNN），都可以学习到图片中的位置无关性特征。数据增强可以帮助模型去学习这种性质并且可以使得模型对一些变化也不敏感，比如左到右和上到下的顺序、照片的光照变化等等。

这些图片数据的增强一般是应用于训练集而不是验证集和测试集。这些数据增强方法不同于那些需要在各个与模型交互的数据集上都保持一致的预处理方法，比如调整图片大小与缩放像素值等。

### 想要计算机视觉方向的结果？

现在就参加我的7天电子邮件速成课（包含示例代码）。

点击注册还有可以获得课程的免费 PDF 版本。

[下载你的免费迷你课程](https://machinelearningmastery.lpages.co/leadbox/1458ca1e0972a2%3A164f8be4f346dc/4715926590455808/)

## 样本图片

我们需要一个样本图片来展示标准的数据增强技术。

本教程中，我们会用到一个已经获得使用许可，由 AndYaDontStop 拍摄，名为 [Feathered Friend](https://www.flickr.com/photos/thenovys/3854468621/) 的鸟类照片。

下载这张照片，并保存在你的工作目录命名为 ‘_bird.jpg_‘。

![Feathered Friend，作者 AndYaDontStop。](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/bird.jpg)

Feathered Friend，作者 AndYaDontStop。  
保留部分权力.

*   [图片下载链接 (bird.jpg)](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/bird.jpg)

## 使用 ImageDataGenerator 进行图像数据增强

Keras 框架可以在训练模型时，自动使用数据增强。

可以利用 [ImageDataGenerator 类](https://keras.io/preprocessing/image/) 达到这一目的。

首先，可以在类实例化时传入特定的参数到构造函数来配置对应的增强方法。

该类支持一系列的增强方法，包括像素值的缩放，但是我们只关注以下五种主要的图像数据增强方法：

*   通过 _`width_shift_range`_ 和 _`height_shift_range`_ 参数设置图像平移。
*   通过 _rotation_range_ 参数设置图像翻转。
*   通过 _brightness_range_ 参数设置图像亮度。
*   通过 _zoom_range_ 参数设置图像缩放。

一个通过构造函数实例化 ImageDataGenerator 的例子。

```python
# 创建数据生成器
datagen = ImageDataGenerator()
```

一旦构造完成，这个数据集的迭代器就被创建了。

这个迭代器每次迭代会返回一个批次的增强数据。

利用 _flow()_ 函数可以将读入了内存的数据集创建为一个迭代器，示例代码如下：

```python
# 读取图片数据集
X, y = ...
# 创建迭代器
it = dataset.flow(X, y)
```

或者，可以对指定的文件路径的数据集创建一个迭代器，在这个文件夹中，不同子类的数据需要存放到不同的子文件夹中。

```python
...
# 创建迭代器
it = dataset.flow_from_directory(X, y, ...)
```

迭代器创建完成后，可以通过调用 _fit_generator()_ 函数来训练神经网络。

_`steps_per_epoch`_ 参数需要设定为能包含整个数据集的批次数。举个例子，如果你的原始数据是 10000 张图片，同时你的 batch_size 设置为 32，那么当你训练一个基于增强数据的模型时，一个合理的 _`steps_per_epoch`_ 应该设置为 _ceil(10,000/32)_，或者说 313 个批次。

```python
# 定义模型
model = ...
# 在增强数据集上拟合模型
model.fit_generator(it, steps_per_epoch=313, ...)
```

数据集中的图片并没有被直接使用，而是将增强后的图片提供给模型。由于增强的图片表现是随机的，容许修改后的图片以及接近原图（例如，几乎没有增强的图片）的数据被生成并在训练中使用。

数据的生成器也可以使用在验证集和测试集上。通常来说，用于验证集和测试集的 _ImageDataGenerator_ 会和训练集的 _ImageDataGenerator_ 有相同的像素值缩放配置（本教程未涉及），但是不会涉及到数据增强。这是因为数据增强的目的是为了可以人工的扩充训练数据集的数量，进而去提高模型在未做增强的数据集上的表现。

现在我们已经熟悉了 _ImageDataGenerator_ 的用法，那么我去看几个具体的针对于图像数据的增强方法。

我们会单独的展示每一种方法增强后的图片效果图。这是一种很好的事件方式，建议在在配置你们自己的数据增强时也这么做。在训练过程中，同时采用好几种增强方法也是很常见的。这里为了达到展示的效果，我们分章节单独的讨论每一个增强方法。

## 水平和垂直平移增强

平移意味着将图片上的所有像素沿着某一个方向移动，可以是水平或者垂直，同时要保证大小没有变化。

这也意味着一些原有的像素点会被移出图片，那么就会有一块区域的像素值需要重新指定。

_`width_shift_range`_ 和 _`height_shift_range`_ 两个参数分别用来控制水平和垂直方向平移的大小，它们是在 _ImageDataGenerator_ 类被构造的时候传入的。

这两个参数可以被指定为一个 0 到 1 之间的小数，代表着平移距离相对于宽度或者高度的百分比。或者，也可以被指定为一个确切的像素值。

具体来说，实际的平移值会在没有平移和百分比（或者具体的像素值）之间选取一个，用该值来处理图片，距离来说，就是在 [0, value] 之间选择。或者，你可以传入一组指定的元组或数组，确定具体的最大和最小值来进行采样，举个例子：[-100, 100] 或者 [-0.5, 0.5]。

下面展示的就是一个将平移参数 _`width_shift_range`_ 设置为 [-200, 200] 像素，并画出对应结果的代码。

```Python
# 水平平移增强的例子
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# 读入图片
img = load_img('bird.jpg')
# 转换为 numpy 数组
data = img_to_array(img)
# 扩展维度
samples = expand_dims(data, 0)
# 生成数据增强迭工厂
datagen = ImageDataGenerator(width_shift_range=[-200,200])
# 准备迭代器
it = datagen.flow(samples, batch_size=1)
# 生成数据并画图
for i in range(9):
	# 定义子图
	pyplot.subplot(330 + 1 + i)
	# 生成一个批次图片
	batch = it.next()
	# 转换为无符号整型方便显示
	image = batch[0].astype('uint32')
	# 画图
	pyplot.imshow(image)
# 展示图片
pyplot.show()
```

执行这段代码，通过配置 _ImageDataGenerator_ 会生成一个图片增强实例，并创建一个迭代器。这个迭代器会在一个循环中被执行 9 次并画出每一次经过增强后的图片。

我通过观察画出的结果可以发现，图片会进行随机的正向或者负向的平移，同时平移带来的空白区域会使用边缘区域的像素来填充。

![平移数据增强的结果](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Horizontal-Shift.png)

随机平移数据增强结果图

下面是类似的例子，通过调整 _`height_shift_range`_ 参数实现垂直平移，其中该参数被设置为 0.5。

```Python
# 垂直平移增强的例子
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# 读图
img = load_img('bird.jpg')
# convert to numpy array
data = img_to_array(img)
# 扩展维度
samples = expand_dims(data, 0)
# 创建一个生成器
datagen = ImageDataGenerator(height_shift_range=0.5)
# 准备迭代器
it = datagen.flow(samples, batch_size=1)
# 生成样本和画图
for i in range(9):
	# 定义子图
	pyplot.subplot(330 + 1 + i)
	# 生成一个批次的图片
	batch = it.next()
	# 转换为整形显示
	image = batch[0].astype('uint32')
	# 画图
	pyplot.imshow(image)
# 显示
pyplot.show()
```

运行这段代码，就可以随机的产生通过正向或者负向平移的增强图片。

可以发现水平位移或者垂直位移，不论是正向平或者负向都可以有效的增强对应的图片，但是那些被重新填充的部分对模型就没什么意义了。

值得一提的是，其他的填充方式是可以通过 “_fill_mode_” 参数来指定的。

![Plot of Augmented Images With a Random Vertical Shift](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Vertical-Shift.png)

垂直随机平移的效果图

## 水平和垂直翻转增强

图片的翻转就是在垂直翻转时颠倒所有行的像素值，在水平翻转时颠倒所有列的像素值。

翻转的参数是构造 _ImageDataGenerator_ 类时，分别通过 boolean 型的参数 _horizontal_flip_ 或者 _vertical_flip_ 来指定的。针对于之前提到的鸟的图片，水平翻转是有意义的，而垂直翻转是没什么意义的。

而对于航拍图片、天文图片和显微图片而言，垂直翻转很大可能是有效的。

下面的例子就是通过控制 _horizontal_flip_ 参数来实现图片翻转增强的例子。

```Python
# 水平翻转示例
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# 读图
img = load_img('bird.jpg')
# 转为 numpy 数组
data = img_to_array(img)
# 扩展维度
samples = expand_dims(data, 0)
# 创建生成器
datagen = ImageDataGenerator(horizontal_flip=True)
# 准备迭代器
it = datagen.flow(samples, batch_size=1)
# 生成图片并画图
for i in range(9):
	# 定义子图
	pyplot.subplot(330 + 1 + i)
	# 生成一个批次图片
	batch = it.next()
	# 转化为整型方便显示
	image = batch[0].astype('uint32')
	# 画图
	pyplot.imshow(image)
# 显示
pyplot.show()
```

执行这段程序会产生 9 张增强后的图片。

我们会发现水平的翻转只是在一部分的图片上被使用了。

![Plot of Augmented Images With a Random Horizontal Flip](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Horizontal-Flip.png)

随机水平翻转的增强结果

## 随机旋转增强

旋转增强是随机的对图片进行 0 到 360 度的顺时针旋转。

旋转也会导致部分的数据被移出图片框，会产生一些没有像素值的区域，这些区域也需要被填充


下面的例子通过控制 _rotation_range_ 参数在 0 到 90 度之间去旋转图片，来展示随机旋转增强的效果。

```Python
# 旋转增强示例
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# 读图
img = load_img('bird.jpg')
# 转为 numpy 数组
data = img_to_array(img)
# 扩展维度
samples = expand_dims(data, 0)
# 创建生成器
datagen = ImageDataGenerator(rotation_range=90)
# 准备迭代器
it = datagen.flow(samples, batch_size=1)
# 生成图片并画图
for i in range(9):
	# 定义子图
	pyplot.subplot(330 + 1 + i)
	# 生成一个批次图片
	batch = it.next()
	# 转化为整型方便显示
	image = batch[0].astype('uint32')
	# 画图
	pyplot.imshow(image)
# 显示
pyplot.show()
```

执行这个例子，会产生旋转图片的示例，其中空白区域是通过最邻近法进行填充的。

![Plot of Images Generated With a Random Rotation Augmentation](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Images-Generated-with-a-Rotation-Augmentation.png)

随机旋转增强的结果图

## 随机亮度增强

图片的亮度增强可以是使图片变亮、使图片变暗或者兼顾两者。

这样是为了使模型在训练过程中覆盖不同的亮度水平。

我可以在 _ImageDataGenerator()_ 的构造函数中传入 _brightness_range_ 参数来指定一个最大值和最小值范围来选择一个亮度数值。

值小于 1.0 的时候，会变暗图片，如 [0.5 , 1.0]，相反的，值大于 1.0 时，会使图片变亮，如 [1.0,1.5]，当值为 1.0 时，亮度不会变化。

下面的例子展示了亮度在 0.2（20%） 到 1 之间变化的随机亮度增强的效果。

```python
# 亮度增强示例
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# 读图
img = load_img('bird.jpg')
# 转为 numpy 数组
data = img_to_array(img)
# 扩展维度
samples = expand_dims(data, 0)
# 创建生成器
datagen = ImageDataGenerator(brightness_range=[0.2,1.0])
# 准备迭代器
it = datagen.flow(samples, batch_size=1)
# 生成图片并画图
for i in range(9):
	# 定义子图
	pyplot.subplot(330 + 1 + i)
	# 生成一个批次图片
	batch = it.next()
	# 转化为整型方便显示
	image = batch[0].astype('uint32')
	# 画图
	pyplot.imshow(image)
# 显示
pyplot.show()
```

运行示例你会看到不同数值调暗图片的效果。

![Plot of Images Generated With a Random Brightness Augmentation](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Brightness-Augmentation.png)

随机亮度增强生成的图片

## 随机缩放增强

缩放增强就是随机的缩放图片，利用在图片周围新增像素或者插值来实现。

在 _ImageDataGenerator_ 类的构造函数内传入 _zoom_range_ 来配置缩放的尺度。该参数可以是一个浮点数也可以是数组或者元组。

如果指定为一个浮点数，那么缩放的范围是 [1 - value , 1 + value] 之间。举个例子，如果你设置的参数为 0.3，那么你的缩放范围就是 [0.7, 1.3] 之间，换言之就是 70% （放大）到 130%（缩小）之间。

缩放量是从缩放区域中对每个维度（宽，高）分别均匀随机抽样得到的。

缩放参数有点不直观。需要明白一点，当数值小于 1.0 时图片会放大，如 [ 0.5 , 0.5] 会使图片中的目标变大或者拉近 50%，同样的，如果数值大于 1.0 时，图拼啊会被缩小 50%，如 [ 1.5 , 1.5 ] 目标会被缩小到或者拉远。当系数为 1.0 时，图片不会有什么变化。

下面的例子展示了让图片中目标变大的例子。

```python
# 尺度缩放增强示例
from numpy import expand_dims
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from keras.preprocessing.image import ImageDataGenerator
from matplotlib import pyplot
# 读图
img = load_img('bird.jpg')
# 转为 numpy 数组
data = img_to_array(img)
# 扩展维度
samples = expand_dims(data, 0)
# 创建生成器
datagen = ImageDataGenerator(zoom_range=[0.5,1.0])
# 准备迭代器
it = datagen.flow(samples, batch_size=1)
# 生成图片并画图
for i in range(9):
	# 定义子图
	pyplot.subplot(330 + 1 + i)
	# 生成一个批次图片
	batch = it.next()
	# 转化为整型方便显示
	image = batch[0].astype('uint32')
	# 画图
	pyplot.imshow(image)
# 显示
pyplot.show()
```

运行示例就可以得到缩放图片，该图片展示了一个在宽和高尺度变化不同的例子，由于宽高的缩放尺度不同，图像的纵横比也会发生变化。

![Plot of Images Generated With a Random Zoom Augmentation](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/01/Plot-of-Augmented-Images-with-a-Zoom-Augmentation.png)

随机缩放增强的效果图

## 扩展阅读

该部分会提供更多的资源供你进一步的学习。

### 出版物
*   [Image Augmentation for Deep Learning With Keras](https://machinelearningmastery.com/image-augmentation-deep-learning-keras/)

### API

*   [Image Preprocessing Keras API](https://keras.io/preprocessing/image/)
*   [Keras Image Preprocessing Code](https://github.com/keras-team/keras-preprocessing/blob/master/keras_preprocessing/image/affine_transformations.py)
*   [Sequential Model API](https://keras.io/models/sequential/)

### 文章

*   [Building powerful image classification models using very little data, Keras Blog](https://blog.keras.io/building-powerful-image-classification-models-using-very-little-data.html).

## 总结

本教程带你探索了图像数据增强在模型训练时的应用。

你应该有以下收获：

*   图像数据增强是为了扩展训练数据集，从而提高模型的性能和泛化能力。
*   通过使用 ImageDataGenerator 类，你可以在 Keras 上获得图像数据增强的支持。
*   如何使用平移、翻转、亮度和缩放增强方法。

还有别的问题？
请在下方留言，我会尽我所能回答你的问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。 
