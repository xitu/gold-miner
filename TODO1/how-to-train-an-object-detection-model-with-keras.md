> * 原文地址：[How to Train an Object Detection Model with Keras](https://machinelearningmastery.com/how-to-train-an-object-detection-model-with-keras/)
> * 原文作者：[Jason Brownlee](https://machinelearningmastery.com/about/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-train-an-object-detection-model-with-keras.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-train-an-object-detection-model-with-keras.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[Ultrasteve](https://github.com/Ultrasteve)，[zhmhhu](https://github.com/zhmhhu)

# 如何使用 Keras 训练目标检测模型

目标检测是一项很有挑战性的计算机视觉类课题，它包括预测目标在图像中的位置以及确认检测到的目标是何种类型的物体。

基于掩膜区域的卷积神经网络模型，或者我们简称为 Mask R-CNN，是目标检测中最先进的方法之一。Matterport Mask R-CNN 项目为我们提供了可用于开发与测试 Mask R-CNN 的 Keras 模型的库，我们可用其来完成我们自己的目标检测任务。尽管它利用了那些在非常具有挑战性的目标检测任务中训练出来的最佳模型，如 MS COCO，来供我们进行迁移学习，但是对于初学者来说，使用这个库可能有些困难，并且它还需要开发者仔细准备好数据集。

在这篇教程中，你将学习如何训练可以在照片中识别袋鼠的 Mask R-CNN 模型。

在学完教程后，你将会知道：

*   如何为训练 R-CNN 模型准备好目标检测数据集。
*   如何使用迁移学习在新的数据集上训练目标检测模型。
*   如何在测试数据集上评估 Mask R-CNN，以及如何在新的照片上作出预测。

如果你还想知道如何建立图像分类、目标检测、人脸识别的模型等等，可以看看[我的关于计算机视觉的新书](https://machinelearningmastery.com/deep-learning-for-computer-vision/)，书中包括了 30 篇讲解细致的教程和所有源代码。

现在我们开始吧。

![How to Train an Object Detection Model to Find Kangaroos in Photographs (R-CNN with Keras)](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/05/How-to-Train-an-Object-Detection-Model-to-Find-Kangaroos-in-Photographs-R-CNN-with-Keras.jpg)

如何使用 R-CNN 模型以及 Keras 训练可以在照片中识别袋鼠的目标检测模型
照片来自 [Ronnie Robertson](https://www.flickr.com/photos/16633132@N04/16146584567/)，作者保留图像权利。

## 教程目录

本片教程可以分为五个部分，分别是：

1.  如何为 Keras 安装 Mask R-CNN
2.  如何为目标检测准备数据集
3.  如何训练检测袋鼠的 Mask R-CNN 模型
4.  如何评估 Mask R-CNN 模型
5.  如何在新照片中检测袋鼠

## 如何为 Keras 安装 Mask R-CNN

目标检测是计算机视觉中的一个课题，它包括在给定图像中识别特定内容是否存在，位置信息，以及一个或多个对象所属的类别。

这是一个很有挑战性的问题，涵盖了目标识别（例如，找到目标在哪里），目标定位（例如，目标所处位置的范围），以及目标分类（例如，目标是哪一类物体）这三个问题的模型构建方法。

基于区域的卷积神经网络，即 R-CNN，是卷积神经网络模型家族中专为目标检测而设计的，它的开发者是 [Ross Girshick](http://www.rossgirshick.info/) 等人。这种方法大约有四个主要的升级变动，结果就是形成了目前最优的 Mask R-CNN。2018 年的文章“[Mask R-CNN](https://arxiv.org/abs/1703.06870)”提出的 Mask R-CNN 是基于区域的卷积神经网络的模型家族中最新的版本，能够同时支持目标检测与目标分割。目标分割不仅包括了目标在图像中的定位，并且包括指定图像的掩膜，以及准确指示出图像中的哪些像素属于该对象。

与简单模型，甚至最先进的深度卷积神经网络模型相比，Mask R-CNN 是一个应用复杂的模型。与其要从头开始开发 R-CNN 或者 Mask R-CNN 模型应用，不如使用一个可靠的基于 Keras 深度学习框架的第三方应用。

目前最好的 Mask R-CNN 的第三方应用是 [Mask R-CNN Project](https://github.com/matterport/Mask_RCNN)，其研发者为 [Matterport](https://matterport.com/)。该项目是拥有许可证的开源项目（例如 MIT license），它的代码已经被广泛的应用于各种不同的项目以及 Kaggle 竞赛中。

第一步是安装该库。

到本篇文章写就为止，该库并没有发行版，所以我们需要手动安装。但是好消息是安装非常简单。

安装步骤包括拷贝 GitHub 仓库然后在工作区下运行安装脚本，如果你在该过程中遇到了困难，可以参见仓库 readme 文件中的[安装说明](https://github.com/matterport/Mask_RCNN#installation)。

### 第一步，克隆 GitHub 上的 Mask R-CNN 仓库

这一步非常简单，只需要在命令行运行下面的命令：

```bash
git clone https://github.com/matterport/Mask_RCNN.git
```

这段代码将会在本地创建一个新的名为 _Mask_RCNN_ 的目录，目录结构如下：

```
Mask_RCNN
├── assets
├── build
│   ├── bdist.macosx-10.13-x86_64
│   └── lib
│       └── mrcnn
├── dist
├── images
├── mask_rcnn.egg-info
├── mrcnn
└── samples
    ├── balloon
    ├── coco
    ├── nucleus
    └── shapes
```

### 第二步，安装 Mask R-CNN 库

仓库可以通过 pip 命令安装。

将路径切换至 _Mask_RCNN_ 然后运行安装脚本。

在命令行中输入：

```bash
cd Mask_RCNN
python setup.py install
```

在 Linux 或者 MacOS 系统上，你也许需要使用 sudo 来允许软件安装；你也许会看到如下的报错：

```
error: can't create or remove files in install directory
```

这种情况下，使用 sudo 安装软件：

```bash
sudo python setup.py install
```

如果你在使用 Python 的虚拟环境（[virtualenv](https://virtualenv.pypa.io/en/latest/)），例如 [EC2 深度学习的 AMI 实例](https://aws.amazon.com/marketplace/pp/B077GF11NF)（推荐用于本教程），你可以使用如下命令将 Mask_RCNN 安装到你的环境中：

```bash
sudo ~/anaconda3/envs/tensorflow_p36/bin/python setup.py install
```

这样，该库就会直接开始安装，你将会看到安装成功的消息，并以下面这条结束：

```
...
Finished processing dependencies for mask-rcnn==2.1
```

这条消息表示你已经成功安装了该库的最新 2.1 版本。

### 第三步，确认库已经安装完成

确认库已经正确安装永远是一个良好的习惯。

你可以通过 pip 命令来请求库来确认它是否已经正确安装；例如：

```bash
pip show mask-rcnn
```

你应该可以看到告知你版本号和安装地址的输出信息；例如：

```
Name: mask-rcnn
Version: 2.1
Summary: Mask R-CNN for object detection and instance segmentation
Home-page: https://github.com/matterport/Mask_RCNN
Author: Matterport
Author-email: waleed.abdulla@gmail.com
License: MIT
Location: ...
Requires:
Required-by:
```
我们现在已经准备好，可以开始使用这个库了。

## 如何为目标检测准备数据集

接下来，我们需要为模型准备数据集。

在本篇教程中，我们将会使用[袋鼠数据集](https://github.com/experiencor/kangaroo)，仓库的作者是 experiencor 即 [Huynh Ngoc Anh](https://www.linkedin.com/in/ngoca)。数据集包括了 183 张包含袋鼠的图像，以及一些 XML 注解文件，用来提供每张照片中袋鼠所处的边框信息。

人们设计出的 Mask R-CNN 可以学习并同时预测出目标的边界以及检测目标的掩膜，然而袋鼠数据集并不提供掩膜信息。因此我们使用这个数据集来完成学习袋鼠目标检测的任务，同时忽略掉掩膜，我们不关心模型的图像分割能力。

在准备训练模型的数据集之前，还需要几个步骤，这些步骤我们将会在这一章中逐个完成，包括下载数据集，解析注解文件，建立可用于 _Mask_RCNN_ 库的袋鼠数据集对象，然后还要测试数据集对象，以确保我们能够正确的加载图像和注解文件。

### 安装数据集

第一步是将数据集下载到当前的工作目录中。

通过将 GitHub 仓库直接拷贝下来即可完成这一步，运行如下命令：

```bash
git clone https://github.com/experiencor/kangaroo.git
```

此时会创建一个名为 “_kangaroo_” 的新目录，其包含一个名为 ‘_images/_’ 的子目录，子目录中包含了所有的袋鼠 JPEG 图像，以及一个名为 ‘_annotes/_’ 的子目录，其中的 XML 文件描述了每张照片中袋鼠的位置信息。

```
kangaroo
├── annots
└── images
```

让我们查看一下每个子目录，可以看到图像和注解文件都遵循了一致的命名约定，即五位零填充编号系统（5-digit zero-padded numbering system）；例如：

```
images/00001.jpg
images/00002.jpg
images/00003.jpg
...
annots/00001.xml
annots/00002.xml
annots/00003.xml
...
```

这种命名方式让图像和其注解文件能够非常容易的匹配在一起。

我们也能看到，编号系统的数字并不连续，一些照片没有出现，例如，没有名为 ‘_00007_’ 的 JPG 或者 XML 文件。

这意味着，我们应该直接加载目录下的实际文件列表，而不是利用编号系统加载文件。

### 解析注解文件

下一步是要搞清楚如何加载注解文件。

首先，我们打开并查看第一个注解文件（_annots/00001.xml_）；你会看到：

```xml
<annotation>
	<folder>Kangaroo</folder>
	<filename>00001.jpg</filename>
	<path>...</path>
	<source>
		<database>Unknown</database>
	</source>
	<size>
		<width>450</width>
		<height>319</height>
		<depth>3</depth>
	</size>
	<segmented>0</segmented>
	<object>
		<name>kangaroo</name>
		<pose>Unspecified</pose>
		<truncated>0</truncated>
		<difficult>0</difficult>
		<bndbox>
			<xmin>233</xmin>
			<ymin>89</ymin>
			<xmax>386</xmax>
			<ymax>262</ymax>
		</bndbox>
	</object>
	<object>
		<name>kangaroo</name>
		<pose>Unspecified</pose>
		<truncated>0</truncated>
		<difficult>0</difficult>
		<bndbox>
			<xmin>134</xmin>
			<ymin>105</ymin>
			<xmax>341</xmax>
			<ymax>253</ymax>
		</bndbox>
	</object>
</annotation>
```

我们可以看到，注解文件包含一个用于描述图像大小的“_size_”元素，以及一个或多个用于描述袋鼠对象在图像中位置的边框的“_object_”元素。

大小和边框是每个注解文件中所需的最小信息。我们可以仔细一点、写一些 XML 解析代码来处理这些注解文件，这对于生产环境的系统是很有帮助的。而在开发过程中，我们将会缩减步骤，直接使用 XPath 从每个文件中提取出我们需要的数据，例如，_//size_ 请求可以从文件中提取出 size 元素，而 _//object_ 或者 _//bndbox_ 请求可以提取出 bounding box 元素。

Python 为开发者提供了 [元素树 API](https://docs.python.org/3/library/xml.etree.elementtree.html)，可用于加载和解析 XML 文件，我们可以使用 [find()](https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.Element.find) 和 [findall()](https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.Element.findall) 函数对已加载的文件发起 XPath 请求。

首先，注解文件必须要被加载并解析为 _ElementTree_ 对象。

```python
# load and parse the file
tree  =  ElementTree.parse(filename)
```

加载成功后，我们可以取到文档的根元素，并可以对根元素发起 XPath 请求。

```python
# 获取文档根元素
root  =  tree.getroot()
```

我们可以使用带‘_.//bndbox_’参数的 findall() 函数来获取所有‘_bndbox_’元素，然后遍历每个元素来提取出用于定义每个边框的 _x_、_y,_、_min_ 和 _max_ 的值。

元素内的文字也可以被解析为整数值。

```python
# 提取出每个 bounding box 元素
for  box in  root.findall('.//bndbox'):
	xmin  =  int(box.find('xmin').text)
	ymin  =  int(box.find('ymin').text)
	xmax  =  int(box.find('xmax').text)
	ymax  =  int(box.find('ymax').text)
	coors  =  [xmin,  ymin,  xmax,  ymax]
```
接下来我们就可以将所有边框的定义值整理为一个列表。

图像的尺寸也同样很有用，它可以通过直接请求取得。

```python
# 提取出图像尺寸
width  =  int(root.find('.//size/width').text)
height  =  int(root.find('.//size/height').text)
```

我们可以将上面这些代码合成一个函数，它以注解文件作为入参，提取出边框和图像尺寸等细节信息，并将这些值返回给我们使用。

如下的 _extract_boxes()_ 函数就是上述功能的实现。

```python
# 从注解文件中提取边框值的函数
def extract_boxes(filename):
	# 加载并解析文件
	tree = ElementTree.parse(filename)
	# 获取文档根元素
	root = tree.getroot()
	# 提取出每个 bounding box 元素
	boxes = list()
	for box in root.findall('.//bndbox'):
		xmin = int(box.find('xmin').text)
		ymin = int(box.find('ymin').text)
		xmax = int(box.find('xmax').text)
		ymax = int(box.find('ymax').text)
		coors = [xmin, ymin, xmax, ymax]
		boxes.append(coors)
	# 提取出图像尺寸
	width = int(root.find('.//size/width').text)
	height = int(root.find('.//size/height').text)
	return boxes, width, height
```

现在可以测试这个方法了，我们可以将目录中第一个注解文件作为函数参数进行测试。

完整的示例如下。

```python
# 从注解文件中提取边框值的函数
def extract_boxes(filename):
	# 加载并解析文件
	tree = ElementTree.parse(filename)
	# 获取文档根元素
	root = tree.getroot()
	# 提取出每个 bounding box 元素
	boxes = list()
	for box in root.findall('.//bndbox'):
		xmin = int(box.find('xmin').text)
		ymin = int(box.find('ymin').text)
		xmax = int(box.find('xmax').text)
		ymax = int(box.find('ymax').text)
		coors = [xmin, ymin, xmax, ymax]
		boxes.append(coors)
	# 提取出图像尺寸
	width = int(root.find('.//size/width').text)
	height = int(root.find('.//size/height').text)
	return boxes, width, height
```

运行上述示例代码，函数将会返回一个包含了注解文件中每个边框元素信息，以及每张图像的宽度和高度的列表。

```python
[[233, 89, 386, 262], [134, 105, 341, 253]] 450 319
```

现在我们学会了如何加载注解文件，下面我们将学习如何使用这个功能，来创建一个数据集对象。

### 创建袋鼠数据集对象

mask-rcnn 需要 [mrcnn.utils.Dataset 对象](https://github.com/matterport/Mask_RCNN/blob/master/mrcnn/utils.py)来管理训练、校验以及测试数据集的过程。

这就意味着，新建的类必须要继承 _mrcnn.utils.Dataset_ 类，并定义一个加载数据集的函数，这个函数可以任意命名，例如可以是 _load_dataset()_，它会重载用于加载掩膜的函数 _load_mask()_ 以及用于加载图像引用（路径或者 URL）的函数 _image_reference()_。

```python
# 用于定义和加载袋鼠数据集的类
class KangarooDataset(Dataset):
	# 加载数据集定义
	def load_dataset(self, dataset_dir, is_train=True):
		# ...

	# 加载图像掩膜
	def load_mask(self, image_id):
		# ...

	# 加载图像引用
	def image_reference(self, image_id):
		# ...
```

为了能够使用类 _Dataset_ 的对象，它必须要先进行实例化，然后必须调用你的自定义加载函数，最后内建的 _prepare()_ 函数才会被调用。

例如，我们将要创建一个名为 _KangarooDataset_ 的类，它将会以如下这样的方式使用：

```python
# 准备数据集
train_set  =  KangarooDataset()
train_set.load_dataset(...)
train_set.prepare()
```

自定义的加载函数，即 _load_dataset()_，同时负责定义类以及定义数据集中的图像。

通过调用内建的函数 _add_class()_ 可以定义类，通过函数的参数可以指定数据集名称‘_source_’，类的整型编号‘_class_id_’（例如，1 代指第一个类，不要使用 0，因为 0 已经保留用于背景类），以及‘_class_name_’（例如‘_kangaroo_’）。

```python
# 定义一个类
self.add_class("dataset",  1,  "kangaroo")
```

通过调用内建的 _add_image()_ 函数可以定义图像对象，通过函数的参数可以指定数据集名称‘_source_’，唯一的‘_image_id_’（例如，形如‘_00001_’这样没有扩展的文件名），以及图像加载的位置（例如‘_kangaroo/images/00001.jpg_’）。

这样，我们就为图像定义了一个“_image info_”字典结构，于是图像就可以通过它加入数据集的索引或者序号被检索到。你也可以定义其他的参数，它们也同样会被加入到字典中去，例如用于定义注解文件的‘_annotation_’参数。

```python
# 添加到数据集
self.add_image('dataset',  image_id='00001',  path='kangaroo/images/00001.jpg',  annotation='kangaroo/annots/00001.xml')
```

例如，我们可以运行 _load_dataset()_ 函数，并将数据集字典的地址作为参数传入，那么它将会加载所有数据集中的图像。

注意，测试表明，编号‘_00090_’的图像存在一些问题，所以我们将它从数据集中移除。

```python
# 加载数据集定义
def load_dataset(self, dataset_dir):
	# 定义一个类
	self.add_class("dataset", 1, "kangaroo")
	# 定义数据所在位置
	images_dir = dataset_dir + '/images/'
	annotations_dir = dataset_dir + '/annots/'
	# 定位到所有图像
	for filename in listdir(images_dir):
		# 提取图像 id
		image_id = filename[:-4]
		# 略过不合格的图像
		if image_id in ['00090']:
			continue
		img_path = images_dir + filename
		ann_path = annotations_dir + image_id + '.xml'
		# 添加到数据集
		self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)
```

我们可以更进一步，为函数增加一个参数，这个参数用于定义 _Dataset_ 的实例是用于训练、测试还是验证。我们有大约 160 张图像，所以我们可以使用其中的大约 20%，或者说最后的 32 张图像作为测试集或验证集，将开头的 131 张，或者说 80% 的图像作为训练集。

可以使用文件名中的数字编号来完成图像的分类，图像编号在 150 之前的图像将会被用于训练，等于或者大于 150 的将用于测试。更新后的 _load_dataset()_ 函数可以支持训练和测试数据集，其代码如下：

```python
# 加载数据集定义
def load_dataset(self, dataset_dir, is_train=True):
	# 定义一个类
	self.add_class("dataset", 1, "kangaroo")
	# 定义数据所在位置
	images_dir = dataset_dir + '/images/'
	annotations_dir = dataset_dir + '/annots/'
	# 定位到所有图像
	for filename in listdir(images_dir):
		# 提取图像 id
		image_id = filename[:-4]
		# 略过不合格的图像
		if image_id in ['00090']:
			continue
		# 如果我们正在建立的是训练集，略过 150 序号之后的所有图像
		if is_train and int(image_id) >= 150:
			continue
		# 如果我们正在建立的是测试/验证集，略过 150 序号之前的所有图像
		if not is_train and int(image_id) < 150:
			continue
		img_path = images_dir + filename
		ann_path = annotations_dir + image_id + '.xml'
		# 添加到数据集
		self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)
```

接下来，我们需要定义函数 _load_mask()_，用于为给定的‘_image_id_’加载掩膜。

这时‘_image_id_’是数据集中图像的整数索引，该索引基于加载数据集时，图像通过调用函数 _add_image()_ 加入数据集的顺序。函数必须返回一个包含一个或者多个与 _image_id_ 关联的图像掩膜的数组，以及每个掩膜的类。

我们目前还没有 mask，但是我们有边框，我们可以加载给定图像的边框然后将其作为 mask 返回。接下来库将会从“掩膜”推断出边框信息，因为它们的大小是相同的。

我们必须首先加载注解文件，获取到 _image_id_。获取的步骤包括，首先获取包含 _image_id_ 的‘_image info_’字典，然后通过我们之前对 _add_image()_ 的调用获取图像的加载路径。接下来我们就可以在调用 _extract_boxes()_ 的时候使用该路径，这个函数是在前一章节中定义的，用于获取边框列表和图像尺寸。

```python
# 获取图像详细信息
info = self.image_info[image_id]
# 定义盒文件位置
path = info['annotation']
# 加载 XML
boxes, w, h = self.extract_boxes(path)
```

现在我们可以为每个边框定义一个掩膜，以及一个相关联的类。

掩膜是一个和图像维度一样的二维数组，数组中不属于对象的位置值为 0，反之则值为 1。

通过为每个未知大小的图像创建一个全 0 的 NumPy 数组，并为每个边框创建一个通道，我们可以完成上述的目标：

```python
# 为所有掩膜创建一个数组，每个数组都位于不同的通道
masks  =  zeros([h,  w,  len(boxes)],  dtype='uint8')
```

每个边框都可以用图像框的 _min_、_max_、_x_ 和 _y_ 坐标定义。

这些值可以直接用于定义数组中值为 1 的行和列的范围。

```python
# 创建掩膜
for i in range(len(boxes)):
	box = boxes[i]
	row_s, row_e = box[1], box[3]
	col_s, col_e = box[0], box[2]
	masks[row_s:row_e, col_s:col_e, i] = 1
```

在这个数据集中，所有的对象都有相同的类。我们可以通过‘_class_names_’字典获取类的索引，然后将索引和掩膜一并添加到需要返回的列表中。

```python
self.class_names.index('kangaroo')
```

将这几步放在一起进行测试，最终完成的 _load_mask()_ 函数如下。

```python
# 加载图像掩膜
def load_mask(self, image_id):
	# 获取图像详细信息
	info = self.image_info[image_id]
	# 定义盒文件位置
	path = info['annotation']
	# 加载 XML
	boxes, w, h = self.extract_boxes(path)
	# 为所有掩膜创建一个数组，每个数组都位于不同的通道
	masks = zeros([h, w, len(boxes)], dtype='uint8')
	# 创建掩膜
	class_ids = list()
	for i in range(len(boxes)):
		box = boxes[i]
		row_s, row_e = box[1], box[3]
		col_s, col_e = box[0], box[2]
		masks[row_s:row_e, col_s:col_e, i] = 1
		class_ids.append(self.class_names.index('kangaroo'))
	return masks, asarray(class_ids, dtype='int32')
```

最后，我们还必须实现 _image_reference()_ 函数，

这个函数负责返回给定‘_image_id_’的路径或者 URL，也就是‘_image info_’字典的‘_path_’属性。

```python
# 加载图像引用
def image_reference(self, image_id):
	info = self.image_info[image_id]
	return info['path']
```

好了，这样就完成了。我们已经为袋鼠数据集的 _mask-rcnn_ 库成功的定义了 _Dataset_ 对象。

包含类与创建训练数据集和测试数据集的完整列表如下。

```python
# 将数据分为训练和测试集
from os import listdir
from xml.etree import ElementTree
from numpy import zeros
from numpy import asarray
from mrcnn.utils import Dataset

# 用于定义和加载袋鼠数据集的类
class KangarooDataset(Dataset):
	# 加载数据集定义
	def load_dataset(self, dataset_dir, is_train=True):
		# 定义一个类
		self.add_class("dataset", 1, "kangaroo")
		# 定义数据所在位置
		images_dir = dataset_dir + '/images/'
		annotations_dir = dataset_dir + '/annots/'
		# 定位到所有图像
		for filename in listdir(images_dir):
			# 提取图像 id
			image_id = filename[:-4]
			# 略过不合格的图像
			if image_id in ['00090']:
				continue
			# 如果我们正在建立的是训练集，略过 150 序号之后的所有图像
			if is_train and int(image_id) >= 150:
				continue
			# 如果我们正在建立的是测试/验证集，略过 150 序号之前的所有图像
			if not is_train and int(image_id) < 150:
				continue
			img_path = images_dir + filename
			ann_path = annotations_dir + image_id + '.xml'
			# 添加到数据集
			self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)

	# 从注解文件中提取边框值
	def extract_boxes(self, filename):
		# 加载并解析文件
		tree = ElementTree.parse(filename)
		# 获取文档根元素
		root = tree.getroot()
		# 提取出每个 bounding box 元素
		boxes = list()
		for box in root.findall('.//bndbox'):
			xmin = int(box.find('xmin').text)
			ymin = int(box.find('ymin').text)
			xmax = int(box.find('xmax').text)
			ymax = int(box.find('ymax').text)
			coors = [xmin, ymin, xmax, ymax]
			boxes.append(coors)
		# 提取出图像尺寸
		width = int(root.find('.//size/width').text)
		height = int(root.find('.//size/height').text)
		return boxes, width, height

	# 加载图像掩膜
	def load_mask(self, image_id):
		# 获取图像详细信息
		info = self.image_info[image_id]
		# 定义盒文件位置
		path = info['annotation']
		# 加载 XML
		boxes, w, h = self.extract_boxes(path)
		# 为所有掩膜创建一个数组，每个数组都位于不同的通道
		masks = zeros([h, w, len(boxes)], dtype='uint8')
		# 创建掩膜
		class_ids = list()
		for i in range(len(boxes)):
			box = boxes[i]
			row_s, row_e = box[1], box[3]
			col_s, col_e = box[0], box[2]
			masks[row_s:row_e, col_s:col_e, i] = 1
			class_ids.append(self.class_names.index('kangaroo'))
		return masks, asarray(class_ids, dtype='int32')

	# 加载图像引用
	def image_reference(self, image_id):
		info = self.image_info[image_id]
		return info['path']

# 训练集
train_set = KangarooDataset()
train_set.load_dataset('kangaroo', is_train=True)
train_set.prepare()
print('Train: %d' % len(train_set.image_ids))

# 测试/验证集
test_set = KangarooDataset()
test_set.load_dataset('kangaroo', is_train=False)
test_set.prepare()
print('Test: %d' % len(test_set.image_ids))
```

正确的运行示例代码将会加载并准备好训练和测试集，并打印出每个集合中图像的数量。

```
Train: 131
Test: 32
```

现在，我们已经定义好了数据集，我们还需要确认一下是否对图像、掩膜以及边框进行了正确的处理。

### 测试袋鼠数据集对象

第一个有用的测试是，确认图像和掩膜是否能够正确的加载。

创建一个数据集，以 _image_id_ 为参数调用 _load_image()_ 函数加载图像，然后以同一个 _image_id_ 为参数调用 _load_mask()_ 函数加载掩膜，通过这样的步骤，我们可以完成测试。

```python
# 加载图像
image_id = 0
image = train_set.load_image(image_id)
print(image.shape)
# 加载图像掩膜
mask, class_ids = train_set.load_mask(image_id)
print(mask.shape)
```

接下来，我们可以使用 Matplotlib 提供的 API 绘制出图像，然后使用 alpha 值绘制出顶部的第一个掩膜，这样下面的图像依旧可以看到。

```python
# 绘制图像
pyplot.imshow(image)
# 绘制掩膜
pyplot.imshow(mask[:, :, 0], cmap='gray', alpha=0.5)
pyplot.show()
```

完整的代码示例如下。

```python
# 绘制一幅图像及掩膜
from os import listdir
from xml.etree import ElementTree
from numpy import zeros
from numpy import asarray
from mrcnn.utils import Dataset
from matplotlib import pyplot

# 定义并加载袋鼠数据集的类
class KangarooDataset(Dataset):
	# 加载数据集定义
	def load_dataset(self, dataset_dir, is_train=True):
		# 定义一个类
		self.add_class("dataset", 1, "kangaroo")
		# 定义数据所在位置
		images_dir = dataset_dir + '/images/'
		annotations_dir = dataset_dir + '/annots/'
		# 定位到所有图像
		for filename in listdir(images_dir):
			# 提取图像 id
			image_id = filename[:-4]
			# 略过不合格的图像
			if image_id in ['00090']:
				continue
			# 如果我们正在建立的是训练集，略过 150 序号之后的所有图像
			if is_train and int(image_id) >= 150:
				continue
			# 如果我们正在建立的是测试/验证集，略过 150 序号之前的所有图像
			if not is_train and int(image_id) < 150:
				continue
			img_path = images_dir + filename
			ann_path = annotations_dir + image_id + '.xml'
			# 添加到数据集
			self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)

	# 从注解文件中提取边框值
	def extract_boxes(self, filename):
		# 加载并解析文件
		tree = ElementTree.parse(filename)
		# 获取文档根元素
		root = tree.getroot()
		# 提取出每个 bounding box 元素
		boxes = list()
		for box in root.findall('.//bndbox'):
			xmin = int(box.find('xmin').text)
			ymin = int(box.find('ymin').text)
			xmax = int(box.find('xmax').text)
			ymax = int(box.find('ymax').text)
			coors = [xmin, ymin, xmax, ymax]
			boxes.append(coors)
		# 提取出图像尺寸
		width = int(root.find('.//size/width').text)
		height = int(root.find('.//size/height').text)
		return boxes, width, height

	# 加载图像掩膜
	def load_mask(self, image_id):
		# 获取图像详细信息
		info = self.image_info[image_id]
		# 定义盒文件位置
		path = info['annotation']
		# 加载 XML
		boxes, w, h = self.extract_boxes(path)
		# 为所有掩膜创建一个数组，每个数组都位于不同的通道
		masks = zeros([h, w, len(boxes)], dtype='uint8')
		# 创建掩膜
		class_ids = list()
		for i in range(len(boxes)):
			box = boxes[i]
			row_s, row_e = box[1], box[3]
			col_s, col_e = box[0], box[2]
			masks[row_s:row_e, col_s:col_e, i] = 1
			class_ids.append(self.class_names.index('kangaroo'))
		return masks, asarray(class_ids, dtype='int32')

	# 加载图像引用
	def image_reference(self, image_id):
		info = self.image_info[image_id]
		return info['path']

# 训练集
train_set = KangarooDataset()
train_set.load_dataset('kangaroo', is_train=True)
train_set.prepare()
# 加载图像
image_id = 0
image = train_set.load_image(image_id)
print(image.shape)
# 加载图像掩膜
mask, class_ids = train_set.load_mask(image_id)
print(mask.shape)
# 绘制图像
pyplot.imshow(image)
# 绘制掩膜
pyplot.imshow(mask[:, :, 0], cmap='gray', alpha=0.5)
pyplot.show()
```

运行示例代码，首先将会打印出图像尺寸以及掩膜的 NumPy 数组。

我们可以确定这两个具有同样的长度和宽度，仅在通道的数量上不同。我们也可以看到在此场景下，第一张图像（也就是 _image_id = 0_ 的图像）仅有一个掩膜。

```python
(626, 899, 3)
(626, 899, 1)
```

图像的绘制图会在第一个掩膜重叠的情况下一起被创建出来。

这时，我们就可以看到图像中出现了一只带有掩膜覆盖其边界的袋鼠。

![Photograph of Kangaroo With Object Detection Mask Overlaid](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/03/Photograph-of-Kangaroo-with-Object-Detection-Mask-Overlaid-1024x768.png)

带有目标检测掩膜覆盖的袋鼠图像

我们可以对数据集中的前 9 张图像做相同的操作，将每一张图像作为整体图的子图绘制出来，然后绘制出每一张图像的所有掩膜。

```python
# 绘制最开始的几张图像
for i in range(9):
	# 定义子图
	pyplot.subplot(330 + 1 + i)
	# 绘制原始像素数据
	image = train_set.load_image(i)
	pyplot.imshow(image)
	# 绘制所有掩膜
	mask, _ = train_set.load_mask(i)
	for j in range(mask.shape[2]):
		pyplot.imshow(mask[:, :, j], cmap='gray', alpha=0.3)
# 展示绘制结果
pyplot.show()
```

运行示例代码我们可以看到，图像被正确的加载了，同时这些包含多个目标的图像也被正确定义了各自的掩膜。

![Plot of First Nine Photos of Kangaroos in the Training Dataset With Object Detection Masks](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/03/Plot-of-First-Nine-Photos-of-Kangaroos-in-the-Training-Dataset-with-Object-Detection-Masks-1024x768.png)

绘制训练集中的前 9 幅带有目标检测掩膜的袋鼠图像

另一个很有用的调试步骤是加载数据集中所有的‘_image info_’对象，并将它们在控制台输出。

这可以帮助我们确认，所有在 _load_dataset()_ 函数中对 _add_image()_ 函数的调用都按照预期运作。

```python
# 枚举出数据集中所有的图像
for image_id in train_set.image_ids:
	# 加载图像信息
	info = train_set.image_info[image_id]
	# 在控制台展示
	print(info)
```

在加载的训练集上运行此代码将会展示出所有的‘_image info_’字典，字典中包含数据集中每张图像的路径和 id。

```python
{'id': '00132', 'source': 'dataset', 'path': 'kangaroo/images/00132.jpg', 'annotation': 'kangaroo/annots/00132.xml'}
{'id': '00046', 'source': 'dataset', 'path': 'kangaroo/images/00046.jpg', 'annotation': 'kangaroo/annots/00046.xml'}
{'id': '00052', 'source': 'dataset', 'path': 'kangaroo/images/00052.jpg', 'annotation': 'kangaroo/annots/00052.xml'}
...
```

最后，_mask-rcnn_ 库提供了显示图像和掩膜的工具。我们可以使用一些内建的方法来确认数据集运作正常。

例如，_mask-rcnn_ 提供的 _mrcnn.visualize.display_instances()_ 函数，可以用于显示包含边框、掩膜以及类标签的图像。但是需要边框已经通过 _extract_bboxes()_ 方法从掩膜中提取出来。

```python
# 定义图像 id
image_id = 1
# 加载图像
image = train_set.load_image(image_id)
# 加载掩膜和类 id
mask, class_ids = train_set.load_mask(image_id)
# 从掩膜中提取边框
bbox = extract_bboxes(mask)
# 显示带有掩膜和边框的图像
display_instances(image, bbox, mask, class_ids, train_set.class_names)
```

为了让你对整个流程有完成的认识，所有代码都在下面列出。

```python
# 显示带有掩膜和边框的图像
from os import listdir
from xml.etree import ElementTree
from numpy import zeros
from numpy import asarray
from mrcnn.utils import Dataset
from mrcnn.visualize import display_instances
from mrcnn.utils import extract_bboxes

# 定义并加载袋鼠数据集的类
class KangarooDataset(Dataset):
	# 加载数据集定义
	def load_dataset(self, dataset_dir, is_train=True):
		# 定义一个类
		self.add_class("dataset", 1, "kangaroo")
		# 定义数据所在位置
		images_dir = dataset_dir + '/images/'
		annotations_dir = dataset_dir + '/annots/'
		# 定位到所有图像
		for filename in listdir(images_dir):
			# 提取图像 id
			image_id = filename[:-4]
			# 略过不合格的图像
			if image_id in ['00090']:
				continue
			# 如果我们正在建立的是训练集，略过 150 序号之后的所有图像
			if is_train and int(image_id) >= 150:
				continue
			# 如果我们正在建立的是测试/验证集，略过 150 序号之前的所有图像
			if not is_train and int(image_id) < 150:
				continue
			img_path = images_dir + filename
			ann_path = annotations_dir + image_id + '.xml'
			# 添加到数据集
			self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)

	# 从注解文件中提取边框值
	def extract_boxes(self, filename):
		# 加载并解析文件
		tree = ElementTree.parse(filename)
		# 获取文档根元素
		root = tree.getroot()
		# 提取出每个 bounding box 元素
		boxes = list()
		for box in root.findall('.//bndbox'):
			xmin = int(box.find('xmin').text)
			ymin = int(box.find('ymin').text)
			xmax = int(box.find('xmax').text)
			ymax = int(box.find('ymax').text)
			coors = [xmin, ymin, xmax, ymax]
			boxes.append(coors)
		# 提取出图像尺寸
		width = int(root.find('.//size/width').text)
		height = int(root.find('.//size/height').text)
		return boxes, width, height

	# 加载图像掩膜
	def load_mask(self, image_id):
		# 获取图像详细信息
		info = self.image_info[image_id]
		# 定义盒文件位置
		path = info['annotation']
		# 加载 XML
		boxes, w, h = self.extract_boxes(path)
		# 为所有掩膜创建一个数组，每个数组都位于不同的通道
		masks = zeros([h, w, len(boxes)], dtype='uint8')
		# 创建掩膜
		class_ids = list()
		for i in range(len(boxes)):
			box = boxes[i]
			row_s, row_e = box[1], box[3]
			col_s, col_e = box[0], box[2]
			masks[row_s:row_e, col_s:col_e, i] = 1
			class_ids.append(self.class_names.index('kangaroo'))
		return masks, asarray(class_ids, dtype='int32')

	# 加载图像引用
	def image_reference(self, image_id):
		info = self.image_info[image_id]
		return info['path']

# 训练集
train_set = KangarooDataset()
train_set.load_dataset('kangaroo', is_train=True)
train_set.prepare()
# 定义图像 id
image_id = 1
# 加载图像
image = train_set.load_image(image_id)
# 加载掩膜和类 id
mask, class_ids = train_set.load_mask(image_id)
# 从掩膜中提取边框
bbox = extract_bboxes(mask)
# 显示带有掩膜和边框的图像
display_instances(image, bbox, mask, class_ids, train_set.class_names)
```

运行这段示例代码，将会创建出用不同的颜色标记每个目标掩膜的图像。

从程序设计开始，边框和掩膜就是可以相互精确匹配的，在图像中它们用虚线外边框标记出来。最后，每个对象也会被类标签标记，在这个例子中就是‘_kangaroo_’类。

![Photograph Showing Object Detection Masks, Bounding Boxes, and Class Labels](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/03/Photograph-Showing-Object-Detection-Masks-Bounding-Boxes-and-Class-Labels-1024x576.png)

展示目标检测掩膜、边框和类标签的图像

现在，我们非常确认数据集能够被正确加载，我们可以使用它来拟合 Mask R-CNN 模型了。

## 如何训练检测袋鼠的 Mask R-CNN 模型

Mask R-CNN 模型可以从零开始拟合，但是和其他计算机视觉应用一样，通过使用迁移学习的方法可以节省时间并提升性能。

Mask R-CNN model 在 MS COCO 目标检测的预先拟合可以用作初始模型，然后对于特定的数据集再做适配，在本例中也就是袋鼠数据集。

第一步需要先为预先拟合的 Mask R-CNN 模型下载模型文件（包括结构和权重信息）。权重信息可以在 Github 项目中下载，文件大约 250 MB。

将模型权重加载到工作目录内的文件‘_mask\_rcnn\_coco.h5_’中。

*   [下载权重信息文件 (mask\_rcnn\_coco.h5) 246M](https://github.com/matterport/Mask_RCNN/releases/download/v2.0/mask_rcnn_coco.h5)

接下来，必须要为模型定义一个配置对象。

这个新的类继承了 _mrcnn.config.Config_ 类，定义了需要预测的内容（例如类的名字和数量）和训练模型的算法（例如学习速率）。

配置对象必须通过‘_NAME_’属性定义配置名，例如‘_kangaroo_cfg_’，在项目运行时，它将用于保存详细信息和模型到文件中。配置对象也必须通过‘_NUM_CLASSES_’属性定义预测问题中类的数量。在这个例子中，尽管背景中有很多其他的类，但我们只有一个识别目标，那就是袋鼠。

最后我们还要定义每轮训练中使用的样本（图像）数量。这也就是训练集中图像的数量，即 131。

将这些内容组合在一起，我们自定义的 _KangarooConfig_ 类的定义如下。

```python
# 定义模型配置
class KangarooConfig(Config):
	# 给配置对象命名
	NAME = "kangaroo_cfg"
	# 类的数量（背景中的 + 袋鼠）
	NUM_CLASSES = 1 + 1
	# 每轮训练的迭代数量
	STEPS_PER_EPOCH = 131

# 准备好配置信息
config = KangarooConfig()
```

下面，我们可以定义模型了。

通过创建类 _mrcnn.model.MaskRCNN_ 的实例我们可以创建模型，通过将‘_mode_’属性设置为‘_training_’，特定的模型将可以用于训练。

必须将‘config_’参数赋值为我们的 _KangarooConfig_ 类。

最后，需要一个目录来存储配置文件以及每轮训练结束后的模型检查点。我们就使用当前的工作目录吧。

```python
# 定义模型
model  =  MaskRCNN(mode='training',  model_dir='./',  config=config)
```

接下来，需要加载预定义模型的结构和权重。通过在模型上调用 _load_weights()_ 函数即可，同时要记得指定保存了下载数据的‘_mask\_rcnn\_coco.h5_’文件的地址。

模型将按照原样使用，但是指定了类的输出层将会被移除，这样新的输出层才可以被定义和训练。这要通过指定‘_exclude_’参数，并在模型加载后列出所有需要从模型移除的输出层来完成。这包括分类标签、边框和掩膜的输出层。

```python
# 加载 mscoco 权重信息
model.load_weights('mask_rcnn_coco.h5', by_name=True, exclude=["mrcnn_class_logits", "mrcnn_bbox_fc",  "mrcnn_bbox", "mrcnn_mask"])
```

下面，通过调用 _train()_ 函数并将训练集和验证集作为参数传递进去，模型将开始在训练集上进行拟合。我们也可以指定学习速率，配置默认的学习速率是 0.001。

我们还可以指定训练哪个层。在本文的例子中，我们只训练头部，也就是模型的输出层。

```python
# 训练权重（输出层，或者说‘头部’）
model.train(train_set, test_set, learning_rate=config.LEARNING_RATE, epochs=5, layers='heads')
```

我们可以在后续的训练中重复这样的训练步骤，微调模型中的权重。通过使用更小的学习速率并将‘layer’参数从‘heads’修改为‘all’即可实现。

完整的在袋鼠数据集训练 Mask R-CNN 模型的代码如下。

就算将代码在性能不错的硬件上运行，也可能需要花费一些时间。所以我建议在 GPU 上运行它，例如 [Amazon EC2](https://machinelearningmastery.com/develop-evaluate-large-deep-learning-models-keras-amazon-web-services/)，在 P3 类型的硬件上，代码在五分钟内即可运行完成。

```python
# 在袋鼠数据集上拟合 mask rcnn 模型
from os import listdir
from xml.etree import ElementTree
from numpy import zeros
from numpy import asarray
from mrcnn.utils import Dataset
from mrcnn.config import Config
from mrcnn.model import MaskRCNN

# 定义并加载袋鼠数据集的类
class KangarooDataset(Dataset):
	# 加载数据集定义
	def load_dataset(self, dataset_dir, is_train=True):
		# 定义一个类
		self.add_class("dataset", 1, "kangaroo")
		# 定义数据所在位置
		images_dir = dataset_dir + '/images/'
		annotations_dir = dataset_dir + '/annots/'
		# 定位到所有图像
		for filename in listdir(images_dir):
			# 提取图像 id
			image_id = filename[:-4]
			# 略过不合格的图像
			if image_id in ['00090']:
				continue
			# 如果我们正在建立的是训练集，略过 150 序号之后的所有图像
			if is_train and int(image_id) >= 150:
				continue
			# 如果我们正在建立的是测试/验证集，略过 150 序号之前的所有图像
			if not is_train and int(image_id) < 150:
				continue
			img_path = images_dir + filename
			ann_path = annotations_dir + image_id + '.xml'
			# 添加到数据集
			self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)

	# 从注解文件中提取边框值
	def extract_boxes(self, filename):
		# 加载并解析文件
		tree = ElementTree.parse(filename)
		# 获取文档根元素
		root = tree.getroot()
		# 提取出每个 bounding box 元素
		boxes = list()
		for box in root.findall('.//bndbox'):
			xmin = int(box.find('xmin').text)
			ymin = int(box.find('ymin').text)
			xmax = int(box.find('xmax').text)
			ymax = int(box.find('ymax').text)
			coors = [xmin, ymin, xmax, ymax]
			boxes.append(coors)
		# 提取出图像尺寸
		width = int(root.find('.//size/width').text)
		height = int(root.find('.//size/height').text)
		return boxes, width, height

	# 加载图像掩膜
	def load_mask(self, image_id):
		# 获取图像详细信息
		info = self.image_info[image_id]
		# 定义盒文件位置
		path = info['annotation']
		# 加载 XML
		boxes, w, h = self.extract_boxes(path)
		# 为所有掩膜创建一个数组，每个数组都位于不同的通道
		masks = zeros([h, w, len(boxes)], dtype='uint8')
		# 创建掩膜
		class_ids = list()
		for i in range(len(boxes)):
			box = boxes[i]
			row_s, row_e = box[1], box[3]
			col_s, col_e = box[0], box[2]
			masks[row_s:row_e, col_s:col_e, i] = 1
			class_ids.append(self.class_names.index('kangaroo'))
		return masks, asarray(class_ids, dtype='int32')

	# 加载图像引用
	def image_reference(self, image_id):
		info = self.image_info[image_id]
		return info['path']

# 定义模型配置
class KangarooConfig(Config):
	# 定义配置名
	NAME = "kangaroo_cfg"
	# 类的数量（背景中的 + 袋鼠）
	NUM_CLASSES = 1 + 1
	# 每轮训练的迭代数量
	STEPS_PER_EPOCH = 131

# 准备训练集
train_set = KangarooDataset()
train_set.load_dataset('kangaroo', is_train=True)
train_set.prepare()
print('Train: %d' % len(train_set.image_ids))
# 准备测试/验证集
test_set = KangarooDataset()
test_set.load_dataset('kangaroo', is_train=False)
test_set.prepare()
print('Test: %d' % len(test_set.image_ids))
# 准备配置信息
config = KangarooConfig()
config.display()
# 定义模型
model = MaskRCNN(mode='training', model_dir='./', config=config)
# 加载 mscoco 权重信息，排除输出层
model.load_weights('mask_rcnn_coco.h5', by_name=True, exclude=["mrcnn_class_logits", "mrcnn_bbox_fc",  "mrcnn_bbox", "mrcnn_mask"])
# 训练权重（输出层，或者说‘头部’）
model.train(train_set, test_set, learning_rate=config.LEARNING_RATE, epochs=5, layers='heads')
```

运行示例代码将会使用标准 Keras 进度条报告运行进度。

我们可以发现，每个网络的输出头部，都报告了不同的训练和测试的损失分数。注意到这些损失分数，会让人觉得很困惑。

在本文的例子中，我们感兴趣的是目标识别而不是目标分割，所以我建议应该注意训练集和验证集分类输出的损失（例如 _mrcnn\_class\_loss_ 和 _val\_mrcnn\_class_loss_），还有训练和验证集的边框输出（_mrcnn\_bbox\_loss_ 和 _val\_mrcnn\_bbox_loss_）。

```
Epoch 1/5
131/131 [==============================] - 106s 811ms/step - loss: 0.8491 - rpn_class_loss: 0.0044 - rpn_bbox_loss: 0.1452 - mrcnn_class_loss: 0.0420 - mrcnn_bbox_loss: 0.2874 - mrcnn_mask_loss: 0.3701 - val_loss: 1.3402 - val_rpn_class_loss: 0.0160 - val_rpn_bbox_loss: 0.7913 - val_mrcnn_class_loss: 0.0092 - val_mrcnn_bbox_loss: 0.2263 - val_mrcnn_mask_loss: 0.2975
Epoch 2/5
131/131 [==============================] - 69s 526ms/step - loss: 0.4774 - rpn_class_loss: 0.0025 - rpn_bbox_loss: 0.1159 - mrcnn_class_loss: 0.0170 - mrcnn_bbox_loss: 0.1134 - mrcnn_mask_loss: 0.2285 - val_loss: 0.6261 - val_rpn_class_loss: 8.9502e-04 - val_rpn_bbox_loss: 0.1624 - val_mrcnn_class_loss: 0.0197 - val_mrcnn_bbox_loss: 0.2148 - val_mrcnn_mask_loss: 0.2282
Epoch 3/5
131/131 [==============================] - 67s 515ms/step - loss: 0.4471 - rpn_class_loss: 0.0029 - rpn_bbox_loss: 0.1153 - mrcnn_class_loss: 0.0234 - mrcnn_bbox_loss: 0.0958 - mrcnn_mask_loss: 0.2097 - val_loss: 1.2998 - val_rpn_class_loss: 0.0144 - val_rpn_bbox_loss: 0.6712 - val_mrcnn_class_loss: 0.0372 - val_mrcnn_bbox_loss: 0.2645 - val_mrcnn_mask_loss: 0.3125
Epoch 4/5
131/131 [==============================] - 66s 502ms/step - loss: 0.3934 - rpn_class_loss: 0.0026 - rpn_bbox_loss: 0.1003 - mrcnn_class_loss: 0.0171 - mrcnn_bbox_loss: 0.0806 - mrcnn_mask_loss: 0.1928 - val_loss: 0.6709 - val_rpn_class_loss: 0.0016 - val_rpn_bbox_loss: 0.2012 - val_mrcnn_class_loss: 0.0244 - val_mrcnn_bbox_loss: 0.1942 - val_mrcnn_mask_loss: 0.2495
Epoch 5/5
131/131 [==============================] - 65s 493ms/step - loss: 0.3357 - rpn_class_loss: 0.0024 - rpn_bbox_loss: 0.0804 - mrcnn_class_loss: 0.0193 - mrcnn_bbox_loss: 0.0616 - mrcnn_mask_loss: 0.1721 - val_loss: 0.8878 - val_rpn_class_loss: 0.0030 - val_rpn_bbox_loss: 0.4409 - val_mrcnn_class_loss: 0.0174 - val_mrcnn_bbox_loss: 0.1752 - val_mrcnn_mask_loss: 0.2513
```

每轮训练结束后会创建并保存一个模型文件于子目录中，文件名以‘_kangaroo_cfg_’开始，后面是随机的字符。

使用的时候，我们必须要选择一个模型；在本文的例子中，每轮训练都会让边框选择的损失递减，所以我们将使用最终的模型，它是在运行‘_mask\_rcnn\_kangaroo\_cfg\_0005.h5_’后生成的。

将模型文件从配置目录拷贝到当前的工作目录。我们将会在接下来的章节中使用它进行模型的评估，并对未知图片作出预测。

结果显示，也许更多的训练次数能够让模型性能更好，或许可以微调模型中所有层的参数；这个思路也许可以是本文一个有趣的扩展。

下面让我们一起来看看这个模型的性能评估。

## 如何评估 Mask R-CNN 模型

目标识别目标的模型的性能通常使用平均绝对精度来衡量，即 mAP。

我们要预测的是边框位置，所以我们可以用预测边框与实际边框的重叠程度来决定预测是否准确。通过将边框重叠的区域除以两个边框的总面积可以用来计算准确度，或者说是交叉面积除以总面积，又称为“_intersection over union_,” 或者 IoU。最完美的边框预测的 IoU 值应该为 1。

通常情况下，如果 IoU 的值大于 0.5，我们就可以认为边框预测的结果良好，也就是，重叠部分占总面积的 50% 以上。

准确率指的是正确预测的边框（即 IoU > 0.5 的边框）占总边框的百分比。召回率指的是正确预测的边框（即 IoU > 0.5 的边框）占所有图片中对象的百分比。

随着我们作出更多次的预测，召回率将会升高，但是准确率可能会由于我们开始过拟合而下降或者波动。可以根据准确率（_y_）绘制召回率（_x_），每个精确度的值都可以绘制出一条曲线或直线。我们可以最大化曲线上的每个点的值，并计算准确率的平均值，或者每个召回率的 AP。

**注意**：AP 如何计算有很多种方法，例如，广泛使用的 PASCAL VOC 数据集和 MS COCO 数据集计算的方法就是不同的。

数据集中所有图片的平均准确度的平均值（AP）被称为平均绝对精度，即 mAP。

mask-rcnn 库提供了函数 _mrcnn.utils.compute_ap_，用于计算 AP 以及给定图片的其他指标。数据集中所有的 AP 值可以被集合在一起，并且计算均值可以让我们了解模型在数据集中检测目标的准确度如何。

首先我们必须定义一个 _Config_ 对象，它将用于作出预测，而不是用于训练。我们可以扩展之前定义的 _KangarooConfig_ 来复用一些参数。我们将定义一个新的属性值都相等的对象来让代码保持简洁。配置必须修改一些使用 GPU 进行预测时的默认值，这和在训练模型的时候的配置是不同的（那时候不用管你是在 GPU 或者 CPU 上运行代码的）。

```python
# 定义预测配置
class PredictionConfig(Config):
	# 定义配置名
	NAME = "kangaroo_cfg"
	# 类的数量（背景中的 + 袋鼠）
	NUM_CLASSES = 1 + 1
	# 简化 GPU 配置
	GPU_COUNT = 1
	IMAGES_PER_GPU = 1
```

接下来我们就可以使用配置定义模型了，并且要将参数‘_mode_’从‘_training_’改为‘_inference_’。

```python
# 创建配置
cfg = PredictionConfig()
# 定义模型
model = MaskRCNN(mode='inference', model_dir='./', config=cfg)
```

下面，我们可以从保存的模型中加载权重。

通过指定模型文件的路径即可完成这一步。在本文的例子中，模型文件就是当前工作目录下的‘_mask\_rcnn\_kangaroo\_cfg\_0005.h5_’。

```python
# 加载模型权重
model.load_weights('mask_rcnn_kangaroo_cfg_0005.h5',  by_name=True)
```

接下来，我们可以评估模型了。这包括列举出数据集中的图片，作出预测，然后在预测所有图片的平均 AP 之前计算用于预测的 AP 值。

第一步，根据指定的 _image_id_ 从数据集中加载出图像和真实掩膜。通过使用 _load\_image\_gt()_ 这个便捷的函数即可完成这一步。

```python
# 加载指定 image id 的图像、边框和掩膜
image, image_meta, gt_class_id, gt_bbox, gt_mask = load_image_gt(dataset, cfg, image_id, use_mini_mask=False)
```

接下来，必须按照与训练数据相同的方式缩放已加载图像的像素值，例如居中。通过使用 _mold_image()_ 便捷函即可完成这一步。

```python
# 转换像素值（例如居中）
scaled_image  =  mold_image(image,  cfg)
```

然后，图像的维度需要在数据集中扩展为一个样本，它将作为模型预测的输入。

```python
sample = expand_dims(scaled_image, 0)
# 作出预测
yhat = model.detect(sample, verbose=0)
# 为第一个样本提取结果
r = yhat[0]
```

接下来，预测值可以和真实值作出比对，并使用 _compute_ap()_ 函数计算指标。

```python
# 统计计算，包括计算 AP
AP, _, _, _ = compute_ap(gt_bbox, gt_class_id, gt_mask, r["rois"], r["class_ids"], r["scores"], r['masks'])
```

AP 值将会被加入到一个列表中去，然后计算平均值。

将上面这些组合在一起，下面的 _evaluate_model()_ 函数就是整个过程的实现，并在给定数据集、模型和配置的前提下计算出了 mAP。

```python
# 计算给定数据集中模型的 mAP
def evaluate_model(dataset, model, cfg):
	APs = list()
	for image_id in dataset.image_ids:
		# 加载指定 image id 的图像、边框和掩膜
		image, image_meta, gt_class_id, gt_bbox, gt_mask = load_image_gt(dataset, cfg, image_id, use_mini_mask=False)
		# 转换像素值（例如居中）
		scaled_image = mold_image(image, cfg)
		# 将图像转换为样本
		sample = expand_dims(scaled_image, 0)
		# 作出预测
		yhat = model.detect(sample, verbose=0)
		# 为第一个样本提取结果
		r = yhat[0]
		# 统计计算，包括计算 AP
		AP, _, _, _ = compute_ap(gt_bbox, gt_class_id, gt_mask, r["rois"], r["class_ids"], r["scores"], r['masks'])
		# 保存
		APs.append(AP)
	# 计算所有图片的平均 AP
	mAP = mean(APs)
	return mAP
```

现在我们可以计算训练集和数据集上模型的 mAP。

```python
# 评估训练集上的模型
train_mAP = evaluate_model(train_set, model, cfg)
print("Train mAP: %.3f" % train_mAP)
# 评估测试集上的模型
test_mAP = evaluate_model(test_set, model, cfg)
print("Test mAP: %.3f" % test_mAP)
```

完整的代码如下。

```python
# 评估袋鼠数据集上的 mask rcnn 模型
from os import listdir
from xml.etree import ElementTree
from numpy import zeros
from numpy import asarray
from numpy import expand_dims
from numpy import mean
from mrcnn.config import Config
from mrcnn.model import MaskRCNN
from mrcnn.utils import Dataset
from mrcnn.utils import compute_ap
from mrcnn.model import load_image_gt
from mrcnn.model import mold_image

# 定义并加载袋鼠数据集的类
class KangarooDataset(Dataset):
	# 加载数据集定义
	def load_dataset(self, dataset_dir, is_train=True):
		# 定义一个类
		self.add_class("dataset", 1, "kangaroo")
		# 定义数据所在位置
		images_dir = dataset_dir + '/images/'
		annotations_dir = dataset_dir + '/annots/'
		# 定位到所有图像
		for filename in listdir(images_dir):
			# 提取图像 id
			image_id = filename[:-4]
			# 略过不合格的图像
			if image_id in ['00090']:
				continue
			# 如果我们正在建立的是训练集，略过 150 序号之后的所有图像
			if is_train and int(image_id) >= 150:
				continue
			# 如果我们正在建立的是测试/验证集，略过 150 序号之前的所有图像
			if not is_train and int(image_id) < 150:
				continue
			img_path = images_dir + filename
			ann_path = annotations_dir + image_id + '.xml'
			# 添加到数据集
			self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)

	# 从注解文件中提取边框值
	def extract_boxes(self, filename):
		# 加载并解析文件
		tree = ElementTree.parse(filename)
		# 获取文档根元素
		root = tree.getroot()
		# 提取出每个 bounding box 元素
		boxes = list()
		for box in root.findall('.//bndbox'):
			xmin = int(box.find('xmin').text)
			ymin = int(box.find('ymin').text)
			xmax = int(box.find('xmax').text)
			ymax = int(box.find('ymax').text)
			coors = [xmin, ymin, xmax, ymax]
			boxes.append(coors)
		# 提取出图像尺寸
		width = int(root.find('.//size/width').text)
		height = int(root.find('.//size/height').text)
		return boxes, width, height

	# 加载图像掩膜
	def load_mask(self, image_id):
		# 获取图像详细信息
		info = self.image_info[image_id]
		# 定义盒文件位置
		path = info['annotation']
		# 加载 XML
		boxes, w, h = self.extract_boxes(path)
		# 为所有掩膜创建一个数组，每个数组都位于不同的通道
		masks = zeros([h, w, len(boxes)], dtype='uint8')
		# 创建掩膜
		class_ids = list()
		for i in range(len(boxes)):
			box = boxes[i]
			row_s, row_e = box[1], box[3]
			col_s, col_e = box[0], box[2]
			masks[row_s:row_e, col_s:col_e, i] = 1
			class_ids.append(self.class_names.index('kangaroo'))
		return masks, asarray(class_ids, dtype='int32')

	# 加载图像引用
	def image_reference(self, image_id):
		info = self.image_info[image_id]
		return info['path']

# 定义预测配置
class PredictionConfig(Config):
	# 定义配置名
	NAME = "kangaroo_cfg"
	# 类的数量（背景中的 + 袋鼠）
	NUM_CLASSES = 1 + 1
	# 简化 GPU 配置
	GPU_COUNT = 1
	IMAGES_PER_GPU = 1

# 计算给定数据集中模型的 mAP
def evaluate_model(dataset, model, cfg):
	APs = list()
	for image_id in dataset.image_ids:
		# 加载指定 image id 的图像、边框和掩膜
		image, image_meta, gt_class_id, gt_bbox, gt_mask = load_image_gt(dataset, cfg, image_id, use_mini_mask=False)
		# 转换像素值（例如居中）
		scaled_image = mold_image(image, cfg)
		# 将图像转换为样本
		sample = expand_dims(scaled_image, 0)
		# 作出预测
		yhat = model.detect(sample, verbose=0)
		# 为第一个样本提取结果
		r = yhat[0]
		# 统计计算，包括计算 AP
		AP, _, _, _ = compute_ap(gt_bbox, gt_class_id, gt_mask, r["rois"], r["class_ids"], r["scores"], r['masks'])
		# 保存
		APs.append(AP)
	# 计算所有图片的平均 AP
	mAP = mean(APs)
	return mAP

# 加载训练集
train_set = KangarooDataset()
train_set.load_dataset('kangaroo', is_train=True)
train_set.prepare()
print('Train: %d' % len(train_set.image_ids))
# 加载测试集
test_set = KangarooDataset()
test_set.load_dataset('kangaroo', is_train=False)
test_set.prepare()
print('Test: %d' % len(test_set.image_ids))
# 创建配置
cfg = PredictionConfig()
# 定义模型
model = MaskRCNN(mode='inference', model_dir='./', config=cfg)
# 加载模型权重
model.load_weights('mask_rcnn_kangaroo_cfg_0005.h5', by_name=True)
# 评估训练集上的模型
train_mAP = evaluate_model(train_set, model, cfg)
print("Train mAP: %.3f" % train_mAP)
# 评估测试集上的模型
test_mAP = evaluate_model(test_set, model, cfg)
print("Test mAP: %.3f" % test_mAP)
```

运行示例代码将会为训练集和测试集中的每张图片作出预测，并计算每次预测的 mAP。

90% 或者 95% 以上的 mAP 就是一个不错的分数了。我们可以看到，在两个数据集上 mAP 分数都不错，并且在测试集而不是训练集上可能还要更好一些。

这可能是因为测试集比较小，或者是因为模型在进一步训练中变得更加准确了。

```
Train mAP: 0.929
Test mAP: 0.958
```

现在我们确信模型是合理的，我们可以使用它作出预测了。

## 如何在新照片中检测袋鼠

我们可以在新的图像，特别是那些期望有袋鼠的图像中使用训练过的模型来检测袋鼠。

首先，我们需要一张新的袋鼠图像

我们可以到 Flickr 上随机的选取一张有袋鼠的图像。或者也可以使用测试集中没有用来训练模型的图像。

在前几个章节中，我们已经知道如何对图像作出预测。具体来说，需要缩放图像的像素值，然后调用 _model.detect()_ 函数。例如：

```python
# 做预测的例子
...
# 加载图像
image = ...
# 转换像素值（例如居中）
scaled_image = mold_image(image, cfg)
# 将图像转换为样本
sample = expand_dims(scaled_image, 0)
# 作出预测
yhat = model.detect(sample, verbose=0)
...
```

我们来更进一步，对数据集中多张图像作出预测，然后将带有实际边框和预测边框的图像依次绘制出来。这样我们就能直接看出模型预测的准确性如何。

第一步，从数据集中加载图像和掩膜。

```python
# 加载图像和掩膜
image = dataset.load_image(image_id)
mask, _ = dataset.load_mask(image_id)
```

下一步，我们就可以对图像作出预测了。

```python
# 转换像素值（例如居中）
scaled_image = mold_image(image, cfg)
# 将图像转换为样本
sample = expand_dims(scaled_image, 0)
# 作出预测
yhat = model.detect(sample, verbose=0)[0]
```

接下来，我们可以为包含真实边框位置的图像创建一个子图，并将其绘制出来。

```python
# 定义子图
pyplot.subplot(n_images, 2, i*2+1)
# 绘制原始像素数据
pyplot.imshow(image)
pyplot.title('Actual')
# 绘制掩膜
for j in range(mask.shape[2]):
	pyplot.imshow(mask[:, :, j], cmap='gray', alpha=0.3)
```

接下来我们可以在第一个子图旁边创建第二个子图，并绘制第一幅图，这一次要将带有预测边框位置的图像绘制出来。

```python
# 获取绘图框的上下文
pyplot.subplot(n_images, 2, i*2+2)
# 绘制原始像素数据
pyplot.imshow(image)
pyplot.title('Predicted')
ax = pyplot.gca()
# 绘制每个图框
for box in yhat['rois']:
	# 获取坐标
	y1, x1, y2, x2 = box
	# 计算绘图框的宽度和高度
	width, height = x2 - x1, y2 - y1
	# 创建形状对象
	rect = Rectangle((x1, y1), width, height, fill=False, color='red')
	# 绘制绘图框
	ax.add_patch(rect)
```

我们可以将制作数据集，模型，配置信息，以及绘制数据集中前五张带有真实和预测边框的图像，这些内容全都整合放在一个函数里面。

```python
# 绘制多张带有真实和预测边框的图像
def plot_actual_vs_predicted(dataset, model, cfg, n_images=5):
	# 加载图像和掩膜
	for i in range(n_images):
		# 加载图像和掩膜
		image = dataset.load_image(i)
		mask, _ = dataset.load_mask(i)
		# 转换像素值（例如居中）
		scaled_image = mold_image(image, cfg)
		# 将图像转换为样本
		sample = expand_dims(scaled_image, 0)
		# 作出预测
		yhat = model.detect(sample, verbose=0)[0]
		# 定义子图
		pyplot.subplot(n_images, 2, i*2+1)
		# 绘制原始像素数据
		pyplot.imshow(image)
		pyplot.title('Actual')
		# 绘制掩膜
		for j in range(mask.shape[2]):
			pyplot.imshow(mask[:, :, j], cmap='gray', alpha=0.3)
		# 获取绘图框的上下文
		pyplot.subplot(n_images, 2, i*2+2)
		# 绘制原始像素数据
		pyplot.imshow(image)
		pyplot.title('Predicted')
		ax = pyplot.gca()
		# 绘制每个绘图框
		for box in yhat['rois']:
			# 获取坐标
			y1, x1, y2, x2 = box
			# 计算绘图框的宽度和高度
			width, height = x2 - x1, y2 - y1
			# 创建形状对象
			rect = Rectangle((x1, y1), width, height, fill=False, color='red')
			# 绘制绘图框
			ax.add_patch(rect)
	# 显示绘制结果
	pyplot.show()
```

完整的加载训练好的模型，并对训练集和测试集中前几张图像作出预测的代码如下。

```python
# 使用 mask rcnn 模型在图像中检测袋鼠
from os import listdir
from xml.etree import ElementTree
from numpy import zeros
from numpy import asarray
from numpy import expand_dims
from matplotlib import pyplot
from matplotlib.patches import Rectangle
from mrcnn.config import Config
from mrcnn.model import MaskRCNN
from mrcnn.model import mold_image
from mrcnn.utils import Dataset

# 定义并加载袋鼠数据集的类
class KangarooDataset(Dataset):
	# 加载数据集定义
	def load_dataset(self, dataset_dir, is_train=True):
		# 定义一个类
		self.add_class("dataset", 1, "kangaroo")
		# 定义数据所在位置
		images_dir = dataset_dir + '/images/'
		annotations_dir = dataset_dir + '/annots/'
		# 定位到所有图像
		for filename in listdir(images_dir):
			# 提取图像 id
			image_id = filename[:-4]
			# 略过不合格的图像
			if image_id in ['00090']:
				continue
			# 如果我们正在建立的是训练集，略过 150 序号之后的所有图像
			if is_train and int(image_id) >= 150:
				continue
			# 如果我们正在建立的是测试/验证集，略过 150 序号之前的所有图像
			if not is_train and int(image_id) < 150:
				continue
			img_path = images_dir + filename
			ann_path = annotations_dir + image_id + '.xml'
			# 添加到数据集
			self.add_image('dataset', image_id=image_id, path=img_path, annotation=ann_path)

	# 从图片中加载所有边框信息
	def extract_boxes(self, filename):
		# 加载并解析文件
		root = ElementTree.parse(filename)
		boxes = list()
		# 提取边框信息
		for box in root.findall('.//bndbox'):
			xmin = int(box.find('xmin').text)
			ymin = int(box.find('ymin').text)
			xmax = int(box.find('xmax').text)
			ymax = int(box.find('ymax').text)
			coors = [xmin, ymin, xmax, ymax]
			boxes.append(coors)
		# 提取出图像尺寸
		width = int(root.find('.//size/width').text)
		height = int(root.find('.//size/height').text)
		return boxes, width, height

	# 加载图像掩膜
	def load_mask(self, image_id):
		# 获取图像详细信息
		info = self.image_info[image_id]
		# 定义盒文件位置
		path = info['annotation']
		# 加载 XML
		boxes, w, h = self.extract_boxes(path)
		# 为所有掩膜创建一个数组，每个数组都位于不同的通道
		masks = zeros([h, w, len(boxes)], dtype='uint8')
		# 创建掩膜
		class_ids = list()
		for i in range(len(boxes)):
			box = boxes[i]
			row_s, row_e = box[1], box[3]
			col_s, col_e = box[0], box[2]
			masks[row_s:row_e, col_s:col_e, i] = 1
			class_ids.append(self.class_names.index('kangaroo'))
		return masks, asarray(class_ids, dtype='int32')

	# 加载图像引用
	def image_reference(self, image_id):
		info = self.image_info[image_id]
		return info['path']

# 定义预测配置
class PredictionConfig(Config):
	# 定义配置名
	NAME = "kangaroo_cfg"
	# 类的数量（背景中的 + 袋鼠）
	NUM_CLASSES = 1 + 1
	# 简化 GPU 配置
	GPU_COUNT = 1
	IMAGES_PER_GPU = 1

# 绘制多张带有真实和预测边框的图像
def plot_actual_vs_predicted(dataset, model, cfg, n_images=5):
	# 加载图像和掩膜
	for i in range(n_images):
		# 加载图像和掩膜
		image = dataset.load_image(i)
		mask, _ = dataset.load_mask(i)
		# 转换像素值（例如居中）
		scaled_image = mold_image(image, cfg)
		# 将图像转换为样本
		sample = expand_dims(scaled_image, 0)
		# 作出预测
		yhat = model.detect(sample, verbose=0)[0]
		# 定义子图
		pyplot.subplot(n_images, 2, i*2+1)
		# 绘制原始像素数据
		pyplot.imshow(image)
		pyplot.title('Actual')
		# 绘制掩膜
		for j in range(mask.shape[2]):
			pyplot.imshow(mask[:, :, j], cmap='gray', alpha=0.3)
		# 获取绘图框的上下文
		pyplot.subplot(n_images, 2, i*2+2)
		# 绘制原始像素数据
		pyplot.imshow(image)
		pyplot.title('Predicted')
		ax = pyplot.gca()
		# 绘制每个绘图框
		for box in yhat['rois']:
			# 获取坐标
			y1, x1, y2, x2 = box
			# 计算绘图框的宽度和高度
			width, height = x2 - x1, y2 - y1
			# 创建形状对象
			rect = Rectangle((x1, y1), width, height, fill=False, color='red')
			# 绘制绘图框
			ax.add_patch(rect)
	# 显示绘制结果
	pyplot.show()

# 加载训练集
train_set = KangarooDataset()
train_set.load_dataset('kangaroo', is_train=True)
train_set.prepare()
print('Train: %d' % len(train_set.image_ids))
# 加载测试集
test_set = KangarooDataset()
test_set.load_dataset('kangaroo', is_train=False)
test_set.prepare()
print('Test: %d' % len(test_set.image_ids))
# 创建配置
cfg = PredictionConfig()
# 定义模型
model = MaskRCNN(mode='inference', model_dir='./', config=cfg)
# 加载模型权重
model_path = 'mask_rcnn_kangaroo_cfg_0005.h5'
model.load_weights(model_path, by_name=True)
# 绘制训练集预测结果
plot_actual_vs_predicted(train_set, model, cfg)
# 绘制测试集训练结果
plot_actual_vs_predicted(test_set, model, cfg)
```

运行示例代码，将会创建一个显示训练集中前五张图像的绘图，并列的两张图像中分别包含了真实和预测的边框。

我们可以看到，在这些示例中，模型的性能良好，它能够找出所有的袋鼠，甚至在包含两个或三个袋鼠的单张图像中也是如此。右侧一列第二张图出现了一个小错误，模型在同一个袋鼠上预测出了两个边框。

![Plot of Photos of Kangaroos From the Training Dataset With Ground Truth and Predicted Bounding Boxes](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/03/Plot-of-Photos-of-Kangaroos-From-the-Training-Dataset-with-Ground-Truth-and-Predicted-Bounding-Boxes-1024x768.png)

绘制训练集中带有真实和预测边框的袋鼠图像

创建的第二张图显示了测试集中带有真实和预测边框的五张图像。

这些图像在训练的过程中没有出现果，同样的，模型在每一张图像中都检测到了袋鼠。我们可以发现，在最后两张照片中有两个小错误。具体来说，同一个袋鼠被检测到了两次。

毫无疑问，这些差异在多次训练后可以被忽略，也许使用更大的数据集以及数据扩充，可以让模型将检测到的人物作为背景，并且不会重复检测出袋鼠。

![Plot of Photos of Kangaroos From the Training Dataset With Ground Truth and Predicted Bounding Boxes](https://3qeqpr26caki16dnhd19sv6by6v-wpengine.netdna-ssl.com/wp-content/uploads/2019/05/Plot-of-Photos-of-Kangaroos-From-the-Test-Dataset-with-Ground-Truth-and-Predicted-Bounding-Boxes-1024x768.png)

绘制测试集中带有真实和预测边框的袋鼠图像

## 扩展阅读

这一章提供了与目标检测相关的更多资源，如果你想要更深入的学习，可以阅读它们。

### 论文

*   [Mask R-CNN, 2017](https://arxiv.org/abs/1703.06870).

### 项目

*   [Kangaroo Dataset, GitHub](https://github.com/experiencor/kangaroo).
*   [Mask RCNN Project, GitHub](https://github.com/matterport/Mask_RCNN).

### API

*   [xml.etree.ElementTree API](https://docs.python.org/3/library/xml.etree.elementtree.html)
*   [matplotlib.patches.Rectangle API](https://matplotlib.org/api/_as_gen/matplotlib.patches.Rectangle.html)
*   [matplotlib.pyplot.subplot API](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.subplot.html)
*   [matplotlib.pyplot.imshow API](https://matplotlib.org/api/_as_gen/matplotlib.pyplot.imshow.html)

### 文章

*   [Splash of Color: Instance Segmentation with Mask R-CNN and TensorFlow, 2018](https://engineering.matterport.com/splash-of-color-instance-segmentation-with-mask-r-cnn-and-tensorflow-7c761e238b46).
*   [Mask R-CNN – Inspect Ballon Trained Model, Notebook](https://github.com/matterport/Mask_RCNN/blob/master/samples/balloon/inspect_balloon_model.ipynb).
*   [Mask R-CNN – Train on Shapes Dataset, Notebook](https://github.com/matterport/Mask_RCNN/blob/master/samples/shapes/train_shapes.ipynb).
*   [mAP (mean Average Precision) for Object Detection, 2018](https://medium.com/@jonathan_hui/map-mean-average-precision-for-object-detection-45c121a31173).

## 总结

在这篇教程中，我们共同探索了如何研发用于在图像中检测袋鼠目标的 Mask R-CNN 模型。

具体来讲，你的学习内容包括：

*   如何为训练 R-CNN 模型准备好目标检测数据集。
*   如何使用迁移学习在新的数据集上训练目标检测模型。
*   如何在测试数据集上评估 Mask R-CNN，以及如何在新的照片上作出预测。

你还有其他任何的疑问吗？
在下面的评论区写下你的问题，我将会尽可能给你最好的解答。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
