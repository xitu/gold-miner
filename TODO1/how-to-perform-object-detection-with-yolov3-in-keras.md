> * 原文地址：[How to Perform Object Detection With YOLOv3 in Keras](https://machinelearningmastery.com/how-to-perform-object-detection-with-yolov3-in-keras/)
> * 原文作者：[Jason Brownlee](https://machinelearningmastery.com/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-perform-object-detection-with-yolov3-in-keras.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-perform-object-detection-with-yolov3-in-keras.md)
> * 译者：[Daltan](https://github.com/Daltan)
> * 校对者：[lsvih](https://github.com/lsvih), [zhmhhu](https://github.com/zhmhhu)

# 如何在 Keras 中用 YOLOv3 进行对象检测

对象检测是计算机视觉的一项任务，涉及对给定图像识别一个或多个对象的存在性、位置、类型等属性。

然而，如何找到合适的方法来解决对象识别（它们在哪）、对象定位（其程度如何）、对象分类（它们是什么）的问题，是一项具有挑战性的任务。

多年来，在诸如标准基准数据集和计算机视觉竞赛领域等对象识别方法等方面，深度学习技术取得了先进成果。其中值得关注的是 YOLO（You Only Look Once），这是一种卷积神经网络系列算法，通过单一端到端模型实时进行对象检测，取得了几乎是最先进的结果。

本教程教你如何建立 YOLOv3 模型，并在新图像上进行对象检测。

学完本教程，你会知道：

- 用于对象检测的、基于卷积神经网络系列模型的 YOLO 算法，和其最新变种 YOLOv3。
- 使用 Keras 深度学习库的 YOLOv3 开源库的最佳实现。
- 如何使用预处理过的 YOLOv3，来对新图像进行对象定位和检测。

我们开始吧。

![How to Perform Object Detection With YOLOv3 in Keras](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/05/How-to-Perform-Object-Detection-With-YOLOv3-in-Keras.jpg)

如何在 Keras 中用 YOLOv3 进行对象检测
[David Berkowitz](https://www.flickr.com/photos/davidberkowitz/5699832418/) 图，部分权利保留。

## 教程概览

本教程分为三个部分，分别是：

1. 用于对象检测的 YOLO
2. Experiencor 的 YOLO3 项目
3. 用 YOLOv3 进行对象检测

## 用于对象检测的 YOLO


对象检测是计算机视觉的任务，不仅涉及在单图像中对一个或多个对象定位，还涉及在该图像中对每个对象进行分类。

对象检测这项富有挑战性的计算机视觉任务，不仅需要在图像中成功定位对象、找到每个对象并对其绘制边框，还需要对定位好的对象进行正确的分类。

YOLO（You Only Look Once）是一系列端到端的深度学习系列模型，用于快速对象检测，由 [Joseph Redmon](https://pjreddie.com/) 等人于 2015 年的论文[《You Only Look Once：统一实时对象检测》](https://arxiv.org/abs/1506.02640)中首次阐述。

该方法涉及单个深度卷积神经网络（最初是 GoogLeNet 的一个版本，后来更新了，称为基于 VGG 的 DarkNet），将输入分成单元网格，每个格直接预测边框和对象分类。得到的结果是，大量的候选边界框通过后处理步骤合并到最终预测中。

在写本文时有三种主要变体：YOLOv1、YOLOv2、YOLOv3。第一个版本提出了通用架构，而第二个版本则改进了设计，并使用了预定义的锚定框来改进边界框方案，第三个版本进一步完善模型架构和训练过程。

虽然模型的准确性略逊于基于区域的卷积神经网络（R-CNN），但由于 YOLO 模型的检测速度快，因此在对象检测中很受欢迎，通常可以在视频或摄像机的输入上实时显示检测结果。

> 在一次评估中，单个神经网络直接从完整图像预测边界框和类别概率。由于整个检测管道是一个单一的网络，因此可以直接对检测性能进行端到端优化。

- — [You Only Look Once: Unified, Real-Time Object Detection](https://arxiv.org/abs/1506.02640), 2015.

本教程专注于使用 YOLOv3。

## 在 Keras 项目中实践 YOLO3

每个版本的 YOLO 源代码以及预先训练过的模型都可以下载得到。

官方仓库 [DarkNet GitHub](https://github.com/pjreddie/darknet) 中，包含了论文中提到的 YOLO 版本的源代码，是用 C 语言编写的。该仓库还提供了分步使用教程，来教授如何用代码进行对象检测。

从头开始实现这个模型确实很有挑战性，特别是对新手来说，因为需要开发很多自定义的模型元素，来进行训练和预测。例如，即使是直接使用预先训练过的模型，也需要复杂的代码来提取和解释模型输出的预测边界框。

我们可以使用第三方实现过的代码，而不是从头开始写代码。有许多第三方实现是为了在 Keras 中使用 YOLO 而设计的，但没有一个实现是标准化了并设计为库来使用的。

[YAD2K 项目](https://github.com/allanzelener/YAD2K) 是事实意义上的 YOLOv2 标准，它提供了将预先训练的权重转换为 Keras 格式的脚本，使用预先训练的模型进行预测，并提供提取解释预测边界框所需的代码。许多其他第三方开发人员已将此代码用作起点，并对其进行了更新以支持 YOLOv3。

使用预训练的 YOLO 模型最广泛使用的项目可能就是 “[keras-yolo3：使用 YOLO3 训练和检测物体](https://github.com/experiencor/keras-yolo3)”了，该项目由 [Huynh Ngoc Anh ](https://www.linkedin.com/in/ngoca/) 开发，也可称他为 Experiencor。该项目中的代码已在 MIT 开源许可下提供。与 YAD2K 一样，该项目提供了可用于加载和使用预训练的 YOLO 模型的脚本，也可在新数据集上开发基于 YOLOv3 的迁移学习模型。

Experiencor 还有一个 [keras-yolo2](https://github.com/experiencor/keras-yolo2) 项目，里面的代码和 YOLOv2 很像，也有详细教程教你如何使用这个仓库的代码。[keras-yolo3](https://github.com/experiencor/keras-yolo3) 似乎是这个项目的更新版。

有意思的是，Experiencor 以这个模型为基础做了些实验，在诸如袋鼠数据集、racoon 数据集、红细胞检测等等标准对象检测问题上，训练了 YOOLOv3 的多种版本。他列出了模型表现结果，还给出了模型权重以供下载，甚至还发布了展示模型表现结果的 YouTube 视频。比如：

*   [Raccoon Detection using YOLO 3](https://www.youtube.com/watch?v=lxLyLIL7OsU)

本教程以 Experiencor 的 keras-yolo3 项目为基础，使用 YOLOv3 进行对象检测。

这里是 [创作本文时的代码分支](https://github.com/jbrownlee/keras-yolo3)，以防仓库发生变化或被删除（这在第三方开源项目中可能会发生）。

## 用YOLOv3进行对象检测

keras-yolo3 项目提供了很多使用 YOLOv3 的模型，包括对象检测、迁移学习、从头开始训练模型等。

本节使用预训练模型对未见图像进行对象检测。用一个该仓库的 Python 文件就能实现这个功能，文件名是 [yolo3\_one\_file\_to\_detect\_them\_all.py](https://raw.githubusercontent.com/experiencor/keras-yolo3/master/yolo3_one_file_to_detect_them_all.py)，有 435 行。该脚本其实是用预训练权重准备模型，再用此模型进行对象检测，最后输出一个模型。此外，该脚本依赖 OpenCV。

我们不直接使用该程序，而是用该程序中的元素构建自己的脚本，先准备并保存 Keras YOLOv3 模型，然后加载并对新图像进行预测。

### 创建并保存模型

第一步是下载预训练的模型权重。

下面是基于 MSCOCO 数据集、使用 DarNet 代码训练好的模型。下载模型权重，并置之于当前工作路径，重命名为 **yolov3.weights**。文件很大，下载下来可能需要一会，速度跟你的网络有关。

*   [YOLOv3 Pre-trained Model Weights (yolov3.weights) (237 MB)](https://pjreddie.com/media/files/yolov3.weights)

下一步是定义一个 Keras 模型，确保模型中层的数量和类型与下载的模型权重相匹配。模型构架称为 DarkNet ，最初基本上是基于 VGG-16 模型的。

脚本文件 [yolo3\_one\_file\_to\_detect\_them\_all.py](https://raw.githubusercontent.com/experiencor/keras-yolo3/master/yolo3_one_file_to_detect_them_all.py) 提供了 make\_yolov3\_model() 函数，用来创建模型，还有辅助函数 \_conv\_block()，用来创建层块。两个函数都能从该脚本中复制。

现在定义 YOLOv3 的 Keras 模型。

```
# define the model
model  =  make_yolov3_model()
```

接下来载入模型权重。DarkNet 用的权重存储形式不重要，我们也无需手动解码，用脚本中的 **WeightReader** 类就可以。

要想用 **WeightReader**，先得把权重文件（比如 **yolov3.weights**）的路径实例化。下面的代码将解析文件并将模型权重加载到内存中，这样其格式可以在 Keras 模型中使用了。

```
# load the model weights
weight_reader  =  WeightReader('yolov3.weights')
```

然后调用 **WeightReader** 实例的 **load_weights()** 函数，传递定义的 Keras 模型，将权重设置到图层中。

```
# set the model weights into the model
weight_reader.load_weights(model)
```

代码如上。现在就有 YOLOv3 模型可以用了。

将此模型保存为 Keras 兼容的 .h5 模型文件，以备待用。

```
# save the model to file
model.save('model.h5')
```

将以上这些连在一起。代码都是从 **yolo3\_one\_file\_to\_detect\_them\_all.py** 复制过来的，包括函数的完整代码如下。

```
# create a YOLOv3 Keras model and save it to file
# based on https://github.com/experiencor/keras-yolo3
import struct
import numpy as np
from keras.layers import Conv2D
from keras.layers import Input
from keras.layers import BatchNormalization
from keras.layers import LeakyReLU
from keras.layers import ZeroPadding2D
from keras.layers import UpSampling2D
from keras.layers.merge import add, concatenate
from keras.models import Model

def _conv_block(inp, convs, skip=True):
	x = inp
	count = 0
	for conv in convs:
		if count == (len(convs) - 2) and skip:
			skip_connection = x
		count += 1
		if conv['stride'] > 1: x = ZeroPadding2D(((1,0),(1,0)))(x) # peculiar padding as darknet prefer left and top
		x = Conv2D(conv['filter'],
				   conv['kernel'],
				   strides=conv['stride'],
				   padding='valid' if conv['stride'] > 1 else 'same', # peculiar padding as darknet prefer left and top
				   name='conv_' + str(conv['layer_idx']),
				   use_bias=False if conv['bnorm'] else True)(x)
		if conv['bnorm']: x = BatchNormalization(epsilon=0.001, name='bnorm_' + str(conv['layer_idx']))(x)
		if conv['leaky']: x = LeakyReLU(alpha=0.1, name='leaky_' + str(conv['layer_idx']))(x)
	return add([skip_connection, x]) if skip else x

def make_yolov3_model():
	input_image = Input(shape=(None, None, 3))
	# Layer  0 => 4
	x = _conv_block(input_image, [{'filter': 32, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 0},
								  {'filter': 64, 'kernel': 3, 'stride': 2, 'bnorm': True, 'leaky': True, 'layer_idx': 1},
								  {'filter': 32, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 2},
								  {'filter': 64, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 3}])
	# Layer  5 => 8
	x = _conv_block(x, [{'filter': 128, 'kernel': 3, 'stride': 2, 'bnorm': True, 'leaky': True, 'layer_idx': 5},
						{'filter':  64, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 6},
						{'filter': 128, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 7}])
	# Layer  9 => 11
	x = _conv_block(x, [{'filter':  64, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 9},
						{'filter': 128, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 10}])
	# Layer 12 => 15
	x = _conv_block(x, [{'filter': 256, 'kernel': 3, 'stride': 2, 'bnorm': True, 'leaky': True, 'layer_idx': 12},
						{'filter': 128, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 13},
						{'filter': 256, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 14}])
	# Layer 16 => 36
	for i in range(7):
		x = _conv_block(x, [{'filter': 128, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 16+i*3},
							{'filter': 256, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 17+i*3}])
	skip_36 = x
	# Layer 37 => 40
	x = _conv_block(x, [{'filter': 512, 'kernel': 3, 'stride': 2, 'bnorm': True, 'leaky': True, 'layer_idx': 37},
						{'filter': 256, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 38},
						{'filter': 512, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 39}])
	# Layer 41 => 61
	for i in range(7):
		x = _conv_block(x, [{'filter': 256, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 41+i*3},
							{'filter': 512, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 42+i*3}])
	skip_61 = x
	# Layer 62 => 65
	x = _conv_block(x, [{'filter': 1024, 'kernel': 3, 'stride': 2, 'bnorm': True, 'leaky': True, 'layer_idx': 62},
						{'filter':  512, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 63},
						{'filter': 1024, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 64}])
	# Layer 66 => 74
	for i in range(3):
		x = _conv_block(x, [{'filter':  512, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 66+i*3},
							{'filter': 1024, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 67+i*3}])
	# Layer 75 => 79
	x = _conv_block(x, [{'filter':  512, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 75},
						{'filter': 1024, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 76},
						{'filter':  512, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 77},
						{'filter': 1024, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 78},
						{'filter':  512, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 79}], skip=False)
	# Layer 80 => 82
	yolo_82 = _conv_block(x, [{'filter': 1024, 'kernel': 3, 'stride': 1, 'bnorm': True,  'leaky': True,  'layer_idx': 80},
							  {'filter':  255, 'kernel': 1, 'stride': 1, 'bnorm': False, 'leaky': False, 'layer_idx': 81}], skip=False)
	# Layer 83 => 86
	x = _conv_block(x, [{'filter': 256, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 84}], skip=False)
	x = UpSampling2D(2)(x)
	x = concatenate([x, skip_61])
	# Layer 87 => 91
	x = _conv_block(x, [{'filter': 256, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 87},
						{'filter': 512, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 88},
						{'filter': 256, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 89},
						{'filter': 512, 'kernel': 3, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 90},
						{'filter': 256, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True, 'layer_idx': 91}], skip=False)
	# Layer 92 => 94
	yolo_94 = _conv_block(x, [{'filter': 512, 'kernel': 3, 'stride': 1, 'bnorm': True,  'leaky': True,  'layer_idx': 92},
							  {'filter': 255, 'kernel': 1, 'stride': 1, 'bnorm': False, 'leaky': False, 'layer_idx': 93}], skip=False)
	# Layer 95 => 98
	x = _conv_block(x, [{'filter': 128, 'kernel': 1, 'stride': 1, 'bnorm': True, 'leaky': True,   'layer_idx': 96}], skip=False)
	x = UpSampling2D(2)(x)
	x = concatenate([x, skip_36])
	# Layer 99 => 106
	yolo_106 = _conv_block(x, [{'filter': 128, 'kernel': 1, 'stride': 1, 'bnorm': True,  'leaky': True,  'layer_idx': 99},
							   {'filter': 256, 'kernel': 3, 'stride': 1, 'bnorm': True,  'leaky': True,  'layer_idx': 100},
							   {'filter': 128, 'kernel': 1, 'stride': 1, 'bnorm': True,  'leaky': True,  'layer_idx': 101},
							   {'filter': 256, 'kernel': 3, 'stride': 1, 'bnorm': True,  'leaky': True,  'layer_idx': 102},
							   {'filter': 128, 'kernel': 1, 'stride': 1, 'bnorm': True,  'leaky': True,  'layer_idx': 103},
							   {'filter': 256, 'kernel': 3, 'stride': 1, 'bnorm': True,  'leaky': True,  'layer_idx': 104},
							   {'filter': 255, 'kernel': 1, 'stride': 1, 'bnorm': False, 'leaky': False, 'layer_idx': 105}], skip=False)
	model = Model(input_image, [yolo_82, yolo_94, yolo_106])
	return model

class WeightReader:
	def __init__(self, weight_file):
		with open(weight_file, 'rb') as w_f:
			major,	= struct.unpack('i', w_f.read(4))
			minor,	= struct.unpack('i', w_f.read(4))
			revision, = struct.unpack('i', w_f.read(4))
			if (major*10 + minor) >= 2 and major < 1000 and minor < 1000:
				w_f.read(8)
			else:
				w_f.read(4)
			transpose = (major > 1000) or (minor > 1000)
			binary = w_f.read()
		self.offset = 0
		self.all_weights = np.frombuffer(binary, dtype='float32')

	def read_bytes(self, size):
		self.offset = self.offset + size
		return self.all_weights[self.offset-size:self.offset]

	def load_weights(self, model):
		for i in range(106):
			try:
				conv_layer = model.get_layer('conv_' + str(i))
				print("loading weights of convolution #" + str(i))
				if i not in [81, 93, 105]:
					norm_layer = model.get_layer('bnorm_' + str(i))
					size = np.prod(norm_layer.get_weights()[0].shape)
					beta  = self.read_bytes(size) # bias
					gamma = self.read_bytes(size) # scale
					mean  = self.read_bytes(size) # mean
					var   = self.read_bytes(size) # variance
					weights = norm_layer.set_weights([gamma, beta, mean, var])
				if len(conv_layer.get_weights()) > 1:
					bias   = self.read_bytes(np.prod(conv_layer.get_weights()[1].shape))
					kernel = self.read_bytes(np.prod(conv_layer.get_weights()[0].shape))
					kernel = kernel.reshape(list(reversed(conv_layer.get_weights()[0].shape)))
					kernel = kernel.transpose([2,3,1,0])
					conv_layer.set_weights([kernel, bias])
				else:
					kernel = self.read_bytes(np.prod(conv_layer.get_weights()[0].shape))
					kernel = kernel.reshape(list(reversed(conv_layer.get_weights()[0].shape)))
					kernel = kernel.transpose([2,3,1,0])
					conv_layer.set_weights([kernel])
			except ValueError:
				print("no convolution #" + str(i))

	def reset(self):
		self.offset = 0

# define the model
model = make_yolov3_model()
# load the model weights
weight_reader = WeightReader('yolov3.weights')
# set the model weights into the model
weight_reader.load_weights(model)
# save the model to file
model.save('model.h5')
```
在现代的硬件设备中运行此示例代码，可能只需要不到一分钟的时间。

当权重文件加载后，你可以看到由 **WeightReader** 类输出的调试信息报告。

```
...
loading weights of convolution #99
loading weights of convolution #100
loading weights of convolution #101
loading weights of convolution #102
loading weights of convolution #103
loading weights of convolution #104
loading weights of convolution #105
```

运行结束时，当前工作路径下保存了 **model.h5** 文件，大小接近原始权重文件（237MB），但是可以像 Keras 模型一样可以加载该文件并直接使用。

### 做预测

我们需要一张用于对象检测的新照片，理想情况下图片中的对象是我们知道的模型从 [MSCOCO数据集](http://cocodataset.org/) 可识别的对象。

这里使用一张三匹斑马的图片，是 [Boegh](https://www.flickr.com/photos/boegh/5676993427/) 在旅行时拍摄的，且带有发布许可。

![Photograph of Three Zebras](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/03/zebra.jpg)

三匹斑马图片  
Boegh 摄，部分权利保留。

*   [三匹斑马图片（zebra.jpg）](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/03/zebra.jpg)

下载这张图片，放在当前工作路径，命名为 **zebra.jpg** 。

尽管解释预测结果需要一些工作，但做出预测是直截了当的。

第一步是 [加载 Keras 模型](https://machinelearningmastery.com/save-load-keras-deep-learning-models/)，这可能是做预测过程中最慢的一步了。

```
# load yolov3 model
model  =  load_model('model.h5')
```

接下来要加载新的图像，并将其整理成适合作为模型输入的形式。模型想要的输入形式是 416×416 正方形的彩色图片。

使用 **load_img() Keras** 函数加载图像，target_size 参数的作用是加载图片后调整图像的大小。也可以用 **img\_to\_array()** 函数将加载的 PIL 图像对象转换成 Numpy 数组，然后重新调整像素值，使其从 0-255 调整到 0-1 的 32 位浮点值。

```
# load the image with the required size
image = load_img('zebra.jpg', target_size=(416, 416))
# convert to numpy array
image = img_to_array(image)
# scale pixel values to [0, 1]
image = image.astype('float32')
image /= 255.0
```

我们希望稍后再次显示原始照片，这意味着我们需要将所有检测到的对象的边界框从方形形状缩放回原始形状。 这样，我们就可以加载图片并恢复原始形状了。

```
load the image to get its shape
image  =  load_img('zebra.jpg')
width,  height  =  image.size
```

以上步骤可以都连在一起，写成 **load\_image\_pixels()** 函数，方便使用。该函数的输入是文件名、目标尺寸，返回的是缩放过的像素数据，这些数据可作为 Keras 模型的输入，还返回原始图像的宽度和高度。

```
# load and prepare an image
def load_image_pixels(filename, shape):
    # load the image to get its shape
    image = load_img(filename)
    width, height = image.size
    # load the image with the required size
    image = load_img(filename, target_size=shape)
    # convert to numpy array
    image = img_to_array(image)
    # scale pixel values to [0, 1]
    image = image.astype('float32')
    image /= 255.0
    # add a dimension so that we have one sample
    image = expand_dims(image, 0)
    return image, width, height
```

然后调用该函数，加载斑马图。

```
# define the expected input shape for the model
input_w, input_h = 416, 416
# define our new photo
photo_filename = 'zebra.jpg'
# load and prepare image
image, image_w, image_h = load_image_pixels(photo_filename, (input_w, input_h))
```

将该图片给 Keras 模型做输入，进行预测。

```
# make prediction
yhat = model.predict(image)
# summarize the shape of the list of arrays
print([a.shape for a in yhat])
```

以上就是做预测本身的过程。完整示例如下。

```
# load yolov3 model and perform object detection
# based on https://github.com/experiencor/keras-yolo3
from numpy import expand_dims
from keras.models import load_model
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array

# load and prepare an image
def load_image_pixels(filename, shape):
    # load the image to get its shape
    image = load_img(filename)
    width, height = image.size
    # load the image with the required size
    image = load_img(filename, target_size=shape)
    # convert to numpy array
    image = img_to_array(image)
    # scale pixel values to [0, 1]
    image = image.astype('float32')
    image /= 255.0
    # add a dimension so that we have one sample
    image = expand_dims(image, 0)
    return image, width, height

# load yolov3 model
model = load_model('model.h5')
# define the expected input shape for the model
input_w, input_h = 416, 416
# define our new photo
photo_filename = 'zebra.jpg'
# load and prepare image
image, image_w, image_h = load_image_pixels(photo_filename, (input_w, input_h))
# make prediction
yhat = model.predict(image)
# summarize the shape of the list of arrays
print([a.shape for a in yhat])
```

示例代码返回有三个 Numpy 数组的列表，其形状作为输出展现出来。

这些数据既预测了边框，又预测了标签的种类，但是是编码过的。这些结果需要解释一下才行。

```
[(1, 13, 13, 255), (1, 26, 26, 255), (1, 52, 52, 255)]
```

### 做出预测与解释结果

实际上模型的输出是编码过的候选边框，这些候选边框来源于三种不同大小的网格，框本身是由锚框的情境定义的，由基于在 MSCOCO 数据集中对对象尺寸的分析，仔细选择得来的。

由 experincor 提供的脚本中有一个 **decode_netout()** 函数，可以一次一个取每个 Numpy 数组，将候选边框和预测的分类解码。此外，所有不能有足够把握（比如概率低于某个阈值）描述对象的边框都将被忽略掉。此处使用 60% 或 0.6 的概率阈值。该函数返回 **BoundBox** 的实例列表，这个实例定义了每个边界框的角。这些边界框代表了输入图像的形状和类别概率。

```
# define the anchors
anchors = [[116,90, 156,198, 373,326], [30,61, 62,45, 59,119], [10,13, 16,30, 33,23]]
# define the probability threshold for detected objects
class_threshold = 0.6
boxes = list()
for i in range(len(yhat)):
	# decode the output of the network
	boxes += decode_netout(yhat[i][0], anchors[i], class_threshold, input_h, input_w)
```

接下来要将边框拉伸至原来图像的形状。这一步很有用，因为这意味着稍后我们可以绘制原始图像并绘制边界框，希望能够检测到真实对象。

由 Experiencor 提供的脚本中有 **correct\_yolo\_boxes()** 函数，可以转换边框坐标，把边界框列表、一开始加载的图片的原始形状以及网络中输入的形状作为参数。边界框的坐标直接更新：

```
# correct the sizes of the bounding boxes for the shape of the image
correct _yolo_boxes(boxes,  image_h,  image_w,  input_h,  input_w)
```

模型预测了许多边框，大多数框是同一对象。可筛选边框列表，将那些重叠的、指向统一对象的框都合并。可将重叠数量定义为配置参数，此处是50%或0.5 。这一筛选步骤的条件并不是最严格的，而且需要更多后处理步骤。

该脚本通过 **do_nms()**  实现这一点，该函数的参数是边框列表和阈值。该函数整理的不是重叠的边框，而是重叠类的预测概率。这样如果检测到另外的对象类型，边框仍还可用。

```
# suppress non-maximal boxes
do_nms(boxes,  0.5)
```

这样留下的边框数量就一样了，但只有少数有用。 我们只能检索那些强烈预测对象存在的边框：超过 60% 的置信率。 这可以通过遍历所有框并检查类预测值来实现。 然后，我们可以查找该框的相应类标签并将其添加到列表中。 每个边框需要跟每个类标签一一核对，以防同一个框强烈预测多个对象。

创建一个 **get_boxes()** 函数实现这一步，将边框列表、已知标签、分类阈值作为参数，将对应的边框列表、标签、和评分当做返回值。

```
# get all of the results above a threshold
def get_boxes(boxes, labels, thresh):
	v_boxes, v_labels, v_scores = list(), list(), list()
	# enumerate all boxes
	for box in boxes:
		# enumerate all possible labels
		for i in range(len(labels)):
			# check if the threshold for this label is high enough
			if box.classes[i] > thresh:
				v_boxes.append(box)
				v_labels.append(labels[i])
				v_scores.append(box.classes[i]*100)
				# don't break, many labels may trigger for one box
	return v_boxes, v_labels, v_scores
```

用边框列表当做参数调用该函数。

我们还需要一个字符串列表，其中包含模型中已知的类标签，顺序要和训练模型时候的顺序保持一致，特别是 MSCOCO 数据集中的类标签。 值得庆幸的是，这些在 Experiencor 的脚本中也提供。

```
# define the labels
labels = ["person", "bicycle", "car", "motorbike", "aeroplane", "bus", "train", "truck",
    "boat", "traffic light", "fire hydrant", "stop sign", "parking meter", "bench",
    "bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe",
    "backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard",
    "sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard",
    "tennis racket", "bottle", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana",
    "apple", "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake",
    "chair", "sofa", "pottedplant", "bed", "diningtable", "toilet", "tvmonitor", "laptop", "mouse",
    "remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink", "refrigerator",
    "book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"]
# get the details of the detected objects
v_boxes, v_labels, v_scores = get_boxes(boxes, labels, class_threshold)
```

现在有了预测对象较强的少数边框，可以对它们做个总结。

```
# summarize what we found
for i in range(len(v_boxes)):
    print(v_labels[i], v_scores[i])
```

我们还可以绘制原始照片并在每个检测到的物体周围绘制边界框。 这可以通过从每个边界框检索坐标并创建 Rectangle 对象来实现。

```
box = v_boxes[i]
# get coordinates
y1, x1, y2, x2 = box.ymin, box.xmin, box.ymax, box.xmax
# calculate width and height of the box
width, height = x2 - x1, y2 - y1
# create the shape
rect = Rectangle((x1, y1), width, height, fill=False, color='white')
# draw the box
ax.add_patch(rect)
```

也可以用类标签和置信度以字符串形式绘制出来。

```
# draw text and score in top left corner
label = "%s (%.3f)" % (v_labels[i], v_scores[i])
pyplot.text(x1, y1, label, color='white')
```

下面的 **draw_boxes()** 函数实现了这一点，获取原始照片的文件名、对应边框列表、标签、评分，绘制出检测到的所有对象。

```
# draw all results
def draw_boxes(filename, v_boxes, v_labels, v_scores):
	# load the image
	data = pyplot.imread(filename)
	# plot the image
	pyplot.imshow(data)
	# get the context for drawing boxes
	ax = pyplot.gca()
	# plot each box
	for i in range(len(v_boxes)):
		box = v_boxes[i]
		# get coordinates
		y1, x1, y2, x2 = box.ymin, box.xmin, box.ymax, box.xmax
		# calculate width and height of the box
		width, height = x2 - x1, y2 - y1
		# create the shape
		rect = Rectangle((x1, y1), width, height, fill=False, color='white')
		# draw the box
		ax.add_patch(rect)
		# draw text and score in top left corner
		label = "%s (%.3f)" % (v_labels[i], v_scores[i])
		pyplot.text(x1, y1, label, color='white')
	# show the plot
	pyplot.show()
```

然后调用该函数，绘制最终结果。

```
# draw what we found
draw_boxes(photo_filename, v_boxes, v_labels, v_scores)
```

使用 YOLOv3 模型做预测所要的所有元素，现在都有了。解释结果，并绘制出来以供审查。

下面列出了完整代码清单，包括原始和修改过的 xperiencor 脚本。

```
# load yolov3 model and perform object detection
# based on https://github.com/experiencor/keras-yolo3
import numpy as np
from numpy import expand_dims
from keras.models import load_model
from keras.preprocessing.image import load_img
from keras.preprocessing.image import img_to_array
from matplotlib import pyplot
from matplotlib.patches import Rectangle

class BoundBox:
	def __init__(self, xmin, ymin, xmax, ymax, objness = None, classes = None):
		self.xmin = xmin
		self.ymin = ymin
		self.xmax = xmax
		self.ymax = ymax
		self.objness = objness
		self.classes = classes
		self.label = -1
		self.score = -1

	def get_label(self):
		if self.label == -1:
			self.label = np.argmax(self.classes)

		return self.label

	def get_score(self):
		if self.score == -1:
			self.score = self.classes[self.get_label()]

		return self.score

def _sigmoid(x):
	return 1. / (1. + np.exp(-x))

def decode_netout(netout, anchors, obj_thresh, net_h, net_w):
	grid_h, grid_w = netout.shape[:2]
	nb_box = 3
	netout = netout.reshape((grid_h, grid_w, nb_box, -1))
	nb_class = netout.shape[-1] - 5
	boxes = []
	netout[..., :2]  = _sigmoid(netout[..., :2])
	netout[..., 4:]  = _sigmoid(netout[..., 4:])
	netout[..., 5:]  = netout[..., 4][..., np.newaxis] * netout[..., 5:]
	netout[..., 5:] *= netout[..., 5:] > obj_thresh

	for i in range(grid_h*grid_w):
		row = i / grid_w
		col = i % grid_w
		for b in range(nb_box):
			# 4th element is objectness score
			objectness = netout[int(row)][int(col)][b][4]
			if(objectness.all() <= obj_thresh): continue
			# first 4 elements are x, y, w, and h
			x, y, w, h = netout[int(row)][int(col)][b][:4]
			x = (col + x) / grid_w # center position, unit: image width
			y = (row + y) / grid_h # center position, unit: image height
			w = anchors[2 * b + 0] * np.exp(w) / net_w # unit: image width
			h = anchors[2 * b + 1] * np.exp(h) / net_h # unit: image height
			# last elements are class probabilities
			classes = netout[int(row)][col][b][5:]
			box = BoundBox(x-w/2, y-h/2, x+w/2, y+h/2, objectness, classes)
			boxes.append(box)
	return boxes

def correct_yolo_boxes(boxes, image_h, image_w, net_h, net_w):
	new_w, new_h = net_w, net_h
	for i in range(len(boxes)):
		x_offset, x_scale = (net_w - new_w)/2./net_w, float(new_w)/net_w
		y_offset, y_scale = (net_h - new_h)/2./net_h, float(new_h)/net_h
		boxes[i].xmin = int((boxes[i].xmin - x_offset) / x_scale * image_w)
		boxes[i].xmax = int((boxes[i].xmax - x_offset) / x_scale * image_w)
		boxes[i].ymin = int((boxes[i].ymin - y_offset) / y_scale * image_h)
		boxes[i].ymax = int((boxes[i].ymax - y_offset) / y_scale * image_h)

def _interval_overlap(interval_a, interval_b):
	x1, x2 = interval_a
	x3, x4 = interval_b
	if x3 < x1:
		if x4 < x1:
			return 0
		else:
			return min(x2,x4) - x1
	else:
		if x2 < x3:
			 return 0
		else:
			return min(x2,x4) - x3

def bbox_iou(box1, box2):
	intersect_w = _interval_overlap([box1.xmin, box1.xmax], [box2.xmin, box2.xmax])
	intersect_h = _interval_overlap([box1.ymin, box1.ymax], [box2.ymin, box2.ymax])
	intersect = intersect_w * intersect_h
	w1, h1 = box1.xmax-box1.xmin, box1.ymax-box1.ymin
	w2, h2 = box2.xmax-box2.xmin, box2.ymax-box2.ymin
	union = w1*h1 + w2*h2 - intersect
	return float(intersect) / union

def do_nms(boxes, nms_thresh):
	if len(boxes) > 0:
		nb_class = len(boxes[0].classes)
	else:
		return
	for c in range(nb_class):
		sorted_indices = np.argsort([-box.classes[c] for box in boxes])
		for i in range(len(sorted_indices)):
			index_i = sorted_indices[i]
			if boxes[index_i].classes[c] == 0: continue
			for j in range(i+1, len(sorted_indices)):
				index_j = sorted_indices[j]
				if bbox_iou(boxes[index_i], boxes[index_j]) >= nms_thresh:
					boxes[index_j].classes[c] = 0

# load and prepare an image
def load_image_pixels(filename, shape):
	# load the image to get its shape
	image = load_img(filename)
	width, height = image.size
	# load the image with the required size
	image = load_img(filename, target_size=shape)
	# convert to numpy array
	image = img_to_array(image)
	# scale pixel values to [0, 1]
	image = image.astype('float32')
	image /= 255.0
	# add a dimension so that we have one sample
	image = expand_dims(image, 0)
	return image, width, height

# get all of the results above a threshold
def get_boxes(boxes, labels, thresh):
	v_boxes, v_labels, v_scores = list(), list(), list()
	# enumerate all boxes
	for box in boxes:
		# enumerate all possible labels
		for i in range(len(labels)):
			# check if the threshold for this label is high enough
			if box.classes[i] > thresh:
				v_boxes.append(box)
				v_labels.append(labels[i])
				v_scores.append(box.classes[i]*100)
				# don't break, many labels may trigger for one box
	return v_boxes, v_labels, v_scores

# draw all results
def draw_boxes(filename, v_boxes, v_labels, v_scores):
	# load the image
	data = pyplot.imread(filename)
	# plot the image
	pyplot.imshow(data)
	# get the context for drawing boxes
	ax = pyplot.gca()
	# plot each box
	for i in range(len(v_boxes)):
		box = v_boxes[i]
		# get coordinates
		y1, x1, y2, x2 = box.ymin, box.xmin, box.ymax, box.xmax
		# calculate width and height of the box
		width, height = x2 - x1, y2 - y1
		# create the shape
		rect = Rectangle((x1, y1), width, height, fill=False, color='white')
		# draw the box
		ax.add_patch(rect)
		# draw text and score in top left corner
		label = "%s (%.3f)" % (v_labels[i], v_scores[i])
		pyplot.text(x1, y1, label, color='white')
	# show the plot
	pyplot.show()

# load yolov3 model
model = load_model('model.h5')
# define the expected input shape for the model
input_w, input_h = 416, 416
# define our new photo
photo_filename = 'zebra.jpg'
# load and prepare image
image, image_w, image_h = load_image_pixels(photo_filename, (input_w, input_h))
# make prediction
yhat = model.predict(image)
# summarize the shape of the list of arrays
print([a.shape for a in yhat])
# define the anchors
anchors = [[116,90, 156,198, 373,326], [30,61, 62,45, 59,119], [10,13, 16,30, 33,23]]
# define the probability threshold for detected objects
class_threshold = 0.6
boxes = list()
for i in range(len(yhat)):
	# decode the output of the network
	boxes += decode_netout(yhat[i][0], anchors[i], class_threshold, input_h, input_w)
# correct the sizes of the bounding boxes for the shape of the image
correct_yolo_boxes(boxes, image_h, image_w, input_h, input_w)
# suppress non-maximal boxes
do_nms(boxes, 0.5)
# define the labels
labels = ["person", "bicycle", "car", "motorbike", "aeroplane", "bus", "train", "truck",
	"boat", "traffic light", "fire hydrant", "stop sign", "parking meter", "bench",
	"bird", "cat", "dog", "horse", "sheep", "cow", "elephant", "bear", "zebra", "giraffe",
	"backpack", "umbrella", "handbag", "tie", "suitcase", "frisbee", "skis", "snowboard",
	"sports ball", "kite", "baseball bat", "baseball glove", "skateboard", "surfboard",
	"tennis racket", "bottle", "wine glass", "cup", "fork", "knife", "spoon", "bowl", "banana",
	"apple", "sandwich", "orange", "broccoli", "carrot", "hot dog", "pizza", "donut", "cake",
	"chair", "sofa", "pottedplant", "bed", "diningtable", "toilet", "tvmonitor", "laptop", "mouse",
	"remote", "keyboard", "cell phone", "microwave", "oven", "toaster", "sink", "refrigerator",
	"book", "clock", "vase", "scissors", "teddy bear", "hair drier", "toothbrush"]
# get the details of the detected objects
v_boxes, v_labels, v_scores = get_boxes(boxes, labels, class_threshold)
# summarize what we found
for i in range(len(v_boxes)):
	print(v_labels[i], v_scores[i])
# draw what we found
draw_boxes(photo_filename, v_boxes, v_labels, v_scores)
```

再次运行示例，打印出模型的原始输出。

接下来就是模型检测到的对象摘要和对应置信度。可以看出，模型检测到三匹斑马，而且相似度高于 90%。

```
[(1, 13, 13, 255), (1, 26, 26, 255), (1, 52, 52, 255)]
zebra 94.91060376167297
zebra 99.86329674720764
zebra 96.8708872795105
```

绘制出的图片有三个边框，可以看出模型确实成功检测出了图片中的三匹斑马。

![Photograph of Three Zebra Each Detected with the YOLOv3 Model and Localized with Bounding Boxes](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/03/Photograph-of-Three-Zebra-Each-Detected-with-the-YOLOv3-Model-and-Localized-with-Bounding-Boxes-1024x768.png)

用 YOLOv3 模型检测、边框定位的斑马图片

## 拓展阅读

如果想深入了解该主题，本节提供更多有关资源。

### 论文

*   [You Only Look Once: Unified, Real-Time Object Detection](https://arxiv.org/abs/1506.02640), 2015.
*   [YOLO9000: Better, Faster, Stronger](https://arxiv.org/abs/1612.08242), 2016.
*   [YOLOv3: An Incremental Improvement](https://arxiv.org/abs/1804.02767), 2018.

### API

*   [matplotlib.patches.Rectangle API](https://matplotlib.org/api/_as_gen/matplotlib.patches.Rectangle.html)

### 资源

*   [YOLO: Real-Time Object Detection, Homepage](https://pjreddie.com/darknet/yolo/).
*   [Official DarkNet and YOLO Source Code, GitHub](https://github.com/pjreddie/darknet).
*   [Official YOLO: Real Time Object Detection](https://github.com/pjreddie/darknet/wiki/YOLO:-Real-Time-Object-Detection).
*   [Huynh Ngoc Anh, Experiencor, Home Page](https://experiencor.github.io/).
*   [experiencor/keras-yolo3, GitHub](https://github.com/experiencor/keras-yolo3).

### Keras 项目的其他 YOLO 实现

*   [allanzelener/YAD2K, GitHub](https://github.com/allanzelener/YAD2K).
*   [qqwweee/keras-yolo3, GitHub](https://github.com/qqwweee/keras-yolo3).
*   [xiaochus/YOLOv3 GitHub](https://github.com/xiaochus/YOLOv3).

## 总结

本教程教你如何开发 YOLOv3 模型，用于对新的图像进行对象检测。

具体来说，你学到了：

- 基于 YOLO 的卷积神经网络系列模型，用于对象检测。最新变体是 YOLOv3。
- 针对 Keras 深度学习库的最佳开源库 YOLOv3 实现。
- 如何使用预先训练的 YOLOv3 对新照片进行定位和检测。

有问题吗？
在评论区提问，我会尽可能回答的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
