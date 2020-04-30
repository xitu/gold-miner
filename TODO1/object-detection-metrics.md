原文地址：[Metrics for object detection](https://github.com/rafaelpadilla/Object-Detection-Metrics)  
中文文档地址：[https://github.com/xitu/gold-miner/blob/master/TODO1/object-detection-metrics.md](https://github.com/xitu/gold-miner/blob/master/TODO1/object-detection-metrics.md)  
译者：[PingHGao](https://github.com/PingHGao)  
校对：[xionglong58](https://github.com/xionglong58), [shixi-li](https://github.com/shixi-li)

<p align="left"> 
<img src="https://zenodo.org/badge/DOI/10.5281/zenodo.2554189.svg">
</p>

## 引用
这一工作已被 IWSSIP 2020 所接收并在会上展示。 如果您使用此代码进行研究，请考虑引用:
```
@article{padillaCITE2020,
title = {Survey on Performance Metrics for Object-Detection Algorithms},
author = {Rafael Padilla, Sergio Lima Netto and Eduardo A. B. da Silva},
booktitle  = {International Conference on Systems, Signals and Image Processing (IWSSIP)},
year = {2020}
}
```

# 目标检测评价标准
  
**目标检测**的不同研究和实现中没有统一的**评价标准**，这正是本项目的动机。尽管网上各类竞赛都使用它们自己的标准去评价目标检测任务的效果，但只有部分提供用于计算检测准确率的代码片段。

如果不只考虑单一赛事，研究者需要实现他们自己的一套评价指标，以便在不同的数据集上评价他们的方法。而有时一个错误或者不同的实现方法会导致不同且有偏差的结果。为了获得值得信赖的能够应对不同的方法的标准，更理想的方式是提供一种灵活的实现方式，使得所有人都可以使用，无论使用的是什么数据集。

**本项目提供了易于使用的各类函数，这些函数实现的评价标准与目标检测领域最受欢迎的几大竞赛使用的评价标准相同**。我们的实现不需要将你的检测模型修改为复杂的输入格式，避免了向 XML 文件或者 JSON 文件的转化。我们对输入数据进行了简化（bbox 标签以及检测结果）并且将学术界和各类竞赛主流的评价标准集合在了一起。我们将自己的实现与各类官方实现进行了仔细的对比，得到了完全一致的结果。

在接下来的章节你将会了解到在不同的竞赛和工作中最受欢迎的评价标准以及我们的代码的使用例程。

## 目录

- [动机](#metrics-for-object-detection)
- [不同的竞赛，不同的标准](#different-competitions-different-metrics)
- [重要的定义](#important-definitions)
- [评价标准](#metrics)
  - [精度×召回率曲线](#precision-x-recall-curve)
  - [平均精度](#average-precision)
    - [11 点插值法](#11-point-interpolation)
    - [完全插值法](#interpolating-all-points)
- [**如何使用本项目**](#how-to-use-this-project)
- [参考](#references)

<a name="different-competitions-different-metrics"></a> 
## 不同的竞赛，不同的标准 

* **[PASCAL VOC Challenge](http://host.robots.ox.ac.uk/pascal/VOC/)** 提供了一个 MATLAB 脚本以评估检测结果的质量。在提交结果之前，参赛者可以使用该 MATLAB 脚本来评估他们的检测结果。关于该标准的官方解释可以在[这里](http://host.robots.ox.ac.uk/pascal/VOC/voc2012/htmldoc/devkit_doc.html#SECTION00050000000000000000)查看。 PASCAL VOC 目标检测挑战目前使用的评价标准是**精度×召回率曲线**以及 **平均精度**。
PASCAL VOC 的 MATLAB 版本评价代码从 XML 文件读取标签。当你需要应用到其它的数据集或者自定义的数据集时，就需要做出修改。尽管诸如 [Faster-RCNN](https://github.com/rbgirshick/py-faster-rcnn) 等工作实现了 PASCAL VOC 的评价标准，也需要把检测结果转化为特定的格式。 [Tensorflow](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/evaluation_protocols.md) 框架也实现了相应版本的 PASCAL VOC 评价标准。

* **[COCO Detection Challenge](https://competitions.codalab.org/competitions/5181)** 使用不同的标准来衡量不同的目标检测方法的准确率。[这里](http://cocodataset.org/#detection-eval)你可以找到解释 12 种用于确定一个目标检测器在 COCO 上的性能的标准的文档。该竞赛提供了 Python 和 MATLAB 版本的代码，以便参赛者在提交结果前检验他们的得分。同样，将输出转化为特定的[格式](http://cocodataset.org/#format-results) 也是必要的。

* **[Google Open Images Dataset V4 Competition](https://storage.googleapis.com/openimages/web/challenge.html)** 同样使用在 500 类别数据上的 mean Average Precision（mAP）来评估目标检测任务。

* **[ImageNet Object Localization Challenge](https://www.kaggle.com/c/imagenet-object-detection-challenge)** 定义了一种考虑类别和 bbox 检测结果与标签的重叠区域的错误计算方式，为每张图片计算误差。最后总的误差是测试集所有图像最小的误差的均值。[这里](https://www.kaggle.com/c/imagenet-object-localization-challenge#evaluation) 是该方法的详细解释。  

## 重要的定义  

### 交并比 (IOU)

交并比 (IOU) 是基于杰卡德系数的一种评估两个矩形框的重叠程度的测量方法。它需要有一个代表真实值的矩形框 ![](http://latex.codecogs.com/gif.latex?B_%7Bgt%7D) 以及预测值 ![](http://latex.codecogs.com/gif.latex?B_p)。通过计算 IOU 我们可以判断一个检测结果是有效的（True Positive）还是无效的（False Positive）。  
IOU 是预测的矩形框和标签矩形框的重叠部分面积与两者并集的比值： 

<p align="center"> 
<img src="http://latex.codecogs.com/gif.latex?%5Ctext%7BIOU%7D%20%3D%20%5Cfrac%7B%5Ctext%7Barea%7D%20%5Cleft%28B_p%20%5Ccap%20B_%7Bgt%7D%5Cright%29%7D%7B%5Ctext%7Barea%7D%20%5Cleft%28B_p%20%5Ccup%20B_%7Bgt%7D%5Cright%29%7D">
</p>

下图阐述了标签矩形框（绿色）和预测矩形框（红色）之间的IOU。

<!--- IOU --->
<p align="center">
<img src="https://github.com/rafaelpadilla/Object-Detection-Metrics/blob/master/aux_images/iou.png" align="center"/></p>

### True Positive, False Positive, False Negative 和 True Negative  

评价标准涉及到的一些基本的概念：  

* **True Positive (TP)**: 一个正确的检测结果，其 IOU ≥ 阈值  
* **False Positive (FP)**: 一个错误的检测结果，其 IOU ＜ 阈值  
* **False Negative (FN)**: 漏检一个目标  
* **True Negative (TN)**: 未使用，代表一个正确的漏检。在目标检测任务中，一幅图像中可能包含许多不应该被检测出来的标注框。因此 TN 应该指所有不应该被检测的矩形框（一幅图像中有太多的此类方框了）。所以评价方法中没有采用这一指标。

阈值：根据标准的不同而变化，通常取 50%，75% 或者 95%。

### 精度

精度反应的是模型只检测正确物体的能力。它是模型预测结果中正确结果所占的比例，由下式计算：

<p align="center"> 
<img src="http://latex.codecogs.com/gif.latex?Precision%20%3D%20%5Cfrac%7BTP%7D%7BTP&plus;FP%7D%3D%5Cfrac%7BTP%7D%7B%5Ctext%7Ball%20detections%7D%7D">
</p>

### 召回率 

召回率反应的是模型检测出所有存在的物体的能力（所有有标注的物体）。它是模型正确的检测结果占所有标注物体的比例，由下式计算：

<p align="center"> 
<img src="http://latex.codecogs.com/gif.latex?Recall%20%3D%20%5Cfrac%7BTP%7D%7BTP&plus;FN%7D%3D%5Cfrac%7BTP%7D%7B%5Ctext%7Ball%20ground%20truths%7D%7D">
</p>

## 评价标准

接下来的内容将会包含对目标检测领域当前最为广泛使用的一些评价标准的介绍。

### 精度×召回率曲线

精度×召回率曲线是评价目标检测算法一个很好的方式，因为在为每一类目标绘制该曲线的过程中置信度阈值是不断变化的。如果目标检测器对特定类别的精度随着召回率的增加而保持较高的水平，就意味着检测器有较好的性能。因为这意味着无论你怎么改变置信度阈值，精度和召回率都很高。另一个判断检测器好的方法是该检测器只会检测正确的物体（高精度）同时能够找到所有的物体（高召回率）。  

一个坏的检测器需要增加预测数量（降低精度）以便能够找到所有的物体（高召回率）。这就是为什么精度×召回率曲线通常以高精度开始，然后随着召回率增加逐渐降低。你可以在下一章节（Average Precision）看到精度×召回率曲线的例子。此类曲线被 PASCAL VOC 2012 挑战所使用并且被我们实现了。  

### 平均精度

另一种比较不同检测器性能的方法是计算精度×召回率曲线下的面积。由于 AP 曲线通常是上下波动的曲线，在同一幅图像中比较不同的曲线通常是很难的，因为这些曲线通常是频繁的相互交叉穿越的。这就是为什么平均精度（AP），一个数字标准，也能够帮助我们比较不同的检测器的好坏。在工程实际中，AP 是召回率在 0~1 范围内精度的平均值。  

自 2010 年开始，PASCAL VOC 计算 AP 的方法已经改变。目前， **PASCAl VOC 使用的插值方法使用了所有的数据点，而不是他们[文章](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.157.5766&rep=rep1&type=pdf)所说的 11 个等间隔的点**。由于我们需要复现他们默认的标准，我们默认的代码遵循了他们最新的标准（使用所有的数据点）。然而，我们也提供了 11 个插值点的方法。 

#### 11 点插值法

11 插值点方法试图通过计算召回率分别为 [0, 0.1, 0.2, ... , 1] 等 11 个值时精度的平均值来概括 PR 曲线的形状：

<p align="center"> 
<img src="http://latex.codecogs.com/gif.latex?AP%20%3D%20%5Cfrac%7B1%7D%7B11%7D%5Csum_%7Br%5Cin%5C%7B0%2C0.1%2C...%2C1%5C%7D%7D%5Crho_%7B%5Ctext%7Binterp%7D%5Cleft%20%28r%5Cright%20%29%7D">
</p>

其中

<p align="center"> 
<img src="http://latex.codecogs.com/gif.latex?%5Crho_%7B%5Ctext%7Binterp%7D%5Cleft%20%28r%5Cright%20%29%7D%3D%5Cmax_%7B%5Cwidetilde%7Br%7D%3A%5Cwidetilde%7Br%7D%5Cgeqslant%7Br%7D%7D%20%5Crho%20%5Cleft%20%28%5Cwidetilde%7Br%7D%20%5Cright%29">
</p>

其中 ![](http://latex.codecogs.com/gif.latex?%5Crho%5Cleft%20%28%20%5Ctilde%7Br%7D%20%5Cright%20%29) 代表召回率为 ![](http://latex.codecogs.com/gif.latex?%5Ctilde%7Br%7D) 时的精度。

AP 是通过计算 11 个点处的精度的平均值得到的。每个点的精度不是召回率为该点值时的精度，而是召回率大于该点值时精度所能达到的最大值。

#### 完全插值法

除了只使用 11 个均匀分布的点的数据，你还可以使用所有的点进行计算：

<p align="center"> 
<img src="http://latex.codecogs.com/gif.latex?%5Csum_%7Br%3D0%7D%5E%7B1%7D%20%5Cleft%20%28%20r_%7Bn&plus;1%7D%20-%20r_n%5Cright%20%29%20%5Crho_%7Binterp%7D%5Cleft%20%28%20r_%7Bn&plus;1%7D%20%5Cright%20%29">
</p>

 
其中

<p align="center"> 
<img src="http://latex.codecogs.com/gif.latex?%5Crho_%7Binterp%7D%5Cleft%20%28%20r_%7Bn&plus;1%7D%20%5Cright%20%29%20%3D%20%5Cmax_%7B%5Ctilde%7Br%7D%3A%5Ctilde%7Br%7D%5Cgeq%20r_%7Bn&plus;1%7D%7D%5Crho%5Cleft%20%28%20%5Ctilde%7Br%7D%20%5Cright%20%29">
</p>


其中 ![](http://latex.codecogs.com/gif.latex?%5Crho%5Cleft%20%28%20%5Ctilde%7Br%7D%20%5Cright%20%29) 代表召回率为 ![](http://latex.codecogs.com/gif.latex?%5Ctilde%7Br%7D) 时的精度。

在此种情况下，AP 现在是由**各个大小召回率**下的精度获取的，不是仅仅几个点。r 处的精度取**召回率大于等于 r+1 范围类的最大精度值**。由此我们可以估算曲线下的面积。

为了更好地进行说明，我们提供了一个例子用来对两种方法进行比较。


#### 一个图文并茂的例子

一个例子能够帮助我们更好地理解如何通过插值计算平均精度。考虑如下的检测结果：
  
<!--- Image samples 1 --->
<p align="center">
<img src="https://github.com/rafaelpadilla/Object-Detection-Metrics/blob/master/aux_images/samples_1_v2.png" align="center"/></p>
  
总共有7张图片，包含了 15 个绿色方框标示的真实标签以及 24 个红色方框标示的检测结果。每个检测结果都对应一个置信度水平，分别用一个字母表示（A,B,...,Y）。 

下表展示了各个矩形框以及对应的置信度。最后一列表明了这一检测结果是 TP 还是 FP。在本例中，如果 IOU ≥ 30%，则归为 TP；否则被归为 FP。通过粗略的观察上面的图片，我们能够大概判断检测结果是 TP 还是 FP。

<!--- Table 1 --->
<p align="center">
<img src="https://github.com/rafaelpadilla/Object-Detection-Metrics/blob/master/aux_images/table_1_v2.png" align="center"/></p>

<!---
| Images | Detections | Confidences | TP or FP |
|:------:|:----------:|:-----------:|:--------:|
| Image 1 | A | 88% | FP |
| Image 1 | B | 70% | TP |
| Image 1 |	C	| 80% | FP |
| Image 2 |	D	| 71% | FP |
| Image 2 |	E	| 54% | TP |
| Image 2 |	F	| 74% | FP |
| Image 3 |	G	| 18% | TP |
| Image 3 |	H	| 67% | FP |
| Image 3 |	I	| 38% | FP |
| Image 3 |	J	| 91% | TP |
| Image 3 |	K	| 44% | FP |
| Image 4 |	L	| 35% | FP |
| Image 4 |	M	| 78% | FP |
| Image 4 |	N	| 45% | FP |
| Image 4 |	O	| 14% | FP |
| Image 5 |	P	| 62% | TP |
| Image 5 |	Q	| 44% | FP |
| Image 5 |	R	| 95% | TP |
| Image 5 |	S	| 23% | FP |
| Image 6 |	T	| 45% | FP |
| Image 6 |	U	| 84% | FP |
| Image 6 |	V	| 43% | FP |
| Image 7 |	X	| 48% | TP |
| Image 7 |	Y	| 95% | FP |
--->

在某些图片中，一个真实的矩形框拥有了多个相重叠的检测结果（图像 2,3,4,5,6,7）。这对这些情况，拥有最大 IOU 的检测结果是 TP 而其他的检测结果为 FP。这一规则被 PASCAL VOC 2012 挑战所采用：“也就是说 5 个（TP）的检测结果被计数为 1 个正确的检测和 4 个错误的检测”。

通过不断的累积 TP 或 FP 的检测结果，PR 曲线就被绘制出来了。为此，我们首先需要根据置信度对检测结果进行排序，然后我们随着检测结果的逐一累加不断地计算精度和召回率，结果如下表： 

<!--- Table 2 --->
<p align="center">
<img src="https://github.com/rafaelpadilla/Object-Detection-Metrics/blob/master/aux_images/table_2_v2.png" align="center"/></p>

<!---
| Images | Detections | Confidences |  TP | FP | Acc TP | Acc FP | Precision | Recall |
|:------:|:----------:|:-----------:|:---:|:--:|:------:|:------:|:---------:|:------:|
| Image 5 |	R	| 95% | 1 | 0 | 1 | 0 | 1       | 0.0666 |
| Image 7 |	Y	| 95% | 0 | 1 | 1 | 1 | 0.5     | 0.6666 |
| Image 3 |	J	| 91% | 1 | 0 | 2 | 1 | 0.6666  | 0.1333 |
| Image 1 | A | 88% | 0 | 1 | 2 | 2 | 0.5     | 0.1333 |
| Image 6 |	U	| 84% | 0 | 1 | 2 | 3 | 0.4     | 0.1333 |
| Image 1 |	C	| 80% | 0 | 1 | 2 | 4 | 0.3333  | 0.1333 |
| Image 4 |	M	| 78% | 0 | 1 | 2 | 5 | 0.2857  | 0.1333 |
| Image 2 |	F	| 74% | 0 | 1 | 2 | 6 | 0.25    | 0.1333 |
| Image 2 |	D	| 71% | 0 | 1 | 2 | 7 | 0.2222  | 0.1333 |
| Image 1 | B | 70% | 1 | 0 | 3 | 7 | 0.3     | 0.2    |
| Image 3 |	H	| 67% | 0 | 1 | 3 | 8 | 0.2727  | 0.2    |
| Image 5 |	P	| 62% | 1 | 0 | 4 | 8 | 0.3333  | 0.2666 |
| Image 2 |	E	| 54% | 1 | 0 | 5 | 8 | 0.3846  | 0.3333 |
| Image 7 |	X	| 48% | 1 | 0 | 6 | 8 | 0.4285  | 0.4    |
| Image 4 |	N	| 45% | 0 | 1 | 6 | 9 | 0.7     | 0.4    |
| Image 6 |	T	| 45% | 0 | 1 | 6 | 10 | 0.375  | 0.4    |
| Image 3 |	K	| 44% | 0 | 1 | 6 | 11 | 0.3529 | 0.4    |
| Image 5 |	Q	| 44% | 0 | 1 | 6 | 12 | 0.3333 | 0.4    |
| Image 6 |	V	| 43% | 0 | 1 | 6 | 13 | 0.3157 | 0.4    |
| Image 3 |	I	| 38% | 0 | 1 | 6 | 14 | 0.3    | 0.4    |
| Image 4 |	L	| 35% | 0 | 1 | 6 | 15 | 0.2857 | 0.4    |
| Image 5 |	S	| 23% | 0 | 1 | 6 | 16 | 0.2727 | 0.4    |
| Image 3 |	G	| 18% | 1 | 0 | 7 | 16 | 0.3043 | 0.4666 |
| Image 4 |	O	| 14% | 0 | 1 | 7 | 17 | 0.2916 | 0.4666 |
--->
 
 通过绘制精度和召回率的值我们将会得到如下的 **PR 曲线**：
 
 <!--- Precision x Recall graph --->
<p align="center">
<img src="https://github.com/rafaelpadilla/Object-Detection-Metrics/blob/master/aux_images/precision_recall_example_1_v2.png" align="center"/>
</p>
 
如上文所说，有两种平均精度的差值计算方法：**11 点差值法**和**完全插值法**。接下来我们将对两种算法进行比较：

#### 计算 11 点插值法

该方法是求 11 个不同召回率（0, 0.1, ..., 1）对应的精度的平均值。各个点的精度插值对应的是召回率大于该处召回率的范围类精度的最大值。具体如下图： 

<!--- interpolated precision curve --->
<p align="center">
<img src="https://github.com/rafaelpadilla/Object-Detection-Metrics/blob/master/aux_images/11-pointInterpolation.png" align="center"/>
</p>

使用 11 点插值计算方法有：  

![](http://latex.codecogs.com/gif.latex?AP%20%3D%20%5Cfrac%7B1%7D%7B11%7D%5Csum_%7Br%5Cin%5C%7B0%2C0.1%2C...%2C1%5C%7D%7D%5Crho_%7B%5Ctext%7Binterp%7D%5Cleft%20%28r%5Cright%20%29%7D)  
![](http://latex.codecogs.com/gif.latex?AP%20%3D%20%5Cfrac%7B1%7D%7B11%7D%20%5Cleft%20%28%201&plus;0.6666&plus;0.4285&plus;0.4285&plus;0.4285&plus;0&plus;0&plus;0&plus;0&plus;0&plus;0%20%5Cright%20%29)  
![](http://latex.codecogs.com/gif.latex?AP%20%3D%2026.84%5C%25)


#### 计算完全插值法

通过使用所有的点，AP 可以看做是 PR 曲线的 AUC（Area Under Curve）的近似值。这么做的目的是减少曲线的震荡带来的影响。通过之前给出的公式，我们能够如后文所说获取这一面积。我们也能够通过从召回率最大值（0.4666）到 0 来（从右往左）观察确定各个插值处的精度；随着召回率降低，我们逐步确定各个阶段对应的最大精度，结果如下图所示：
    
<!--- interpolated precision AUC --->
<p align="center">
<img src="https://github.com/rafaelpadilla/Object-Detection-Metrics/blob/master/aux_images/interpolated_precision_v2.png" align="center"/>
</p>
  
观察上图，我们可以将 AUC 分为 4 个部分（A1，A2，A3，A4）：
  
<!--- interpolated precision AUC --->
<p align="center">
<img src="https://github.com/rafaelpadilla/Object-Detection-Metrics/blob/master/aux_images/interpolated_precision-AUC_v2.png" align="center"/>
</p>

计算所有的面积，我们将能够得到 AP：  

![](http://latex.codecogs.com/gif.latex?AP%20%3D%20A1%20&plus;%20A2%20&plus;%20A3%20&plus;%20A4)  
  
![](http://latex.codecogs.com/gif.latex?%5Ctext%7Bwith%3A%7D)  
![](http://latex.codecogs.com/gif.latex?A1%20%3D%20%280.0666-0%29%5Ctimes1%20%3D%5Cmathbf%7B0.0666%7D)  
![](http://latex.codecogs.com/gif.latex?A2%20%3D%20%280.1333-0.0666%29%5Ctimes0.6666%3D%5Cmathbf%7B0.04446222%7D)  
![](http://latex.codecogs.com/gif.latex?A3%20%3D%20%280.4-0.1333%29%5Ctimes0.4285%20%3D%5Cmathbf%7B0.11428095%7D)  
![](http://latex.codecogs.com/gif.latex?A4%20%3D%20%280.4666-0.4%29%5Ctimes0.3043%20%3D%5Cmathbf%7B0.02026638%7D)  
   
![](http://latex.codecogs.com/gif.latex?AP%20%3D%200.0666&plus;0.04446222&plus;0.11428095&plus;0.02026638)  
![](http://latex.codecogs.com/gif.latex?AP%20%3D%200.24560955)  
![](http://latex.codecogs.com/gif.latex?AP%20%3D%20%5Cmathbf%7B24.56%5C%25%7D)  

两种方法的 AP 有些许不同：24.56%（完全插值） 和 26.84%（11 点插值）。  

我们默认的实现方式与 VOC PASCAL相同：每个点都进行插值。如果你想使用 11 点插值法，将函数的参数 ```method=MethodAveragePrecision.EveryPointInterpolation``` 改为 ```method=MethodAveragePrecision.ElevenPointInterpolation``` 即可。   

如果你想重现这些结果， 参考 **[例 2](https://github.com/rafaelpadilla/Object-Detection-Metrics/tree/master/samples/sample_2/)**.
<!--为了评估你的检测结果，你只需要一个“检测”对象的简单列表。一个“检测”对象是一个包含类别 id，类别概率和矩形包围框的简单的类。标签值也是同样的格式。-->

## 如何使用本项目

本项目是为了轻松的对你的检测结果进行评估而创造的。如果你想用最为广泛使用的方法对你的算法进行评估，那么你来对地方了。

[例_1](https://github.com/rafaelpadilla/Object-Detection-Metrics/tree/master/samples/sample_1) and [例_2](https://github.com/rafaelpadilla/Object-Detection-Metrics/tree/master/samples/sample_2) 是两个非常实用的例子，阐述了如何直接使用本项目的核心函数，以便灵活的使用这些评价标准。但如果你不想花你的时间来理解我们的代码，看看下面的说明，以方便的评估你的检测结果:  

按照以下步骤开始评估你的检测:

1. [创造标签文件](#create-the-ground-truth-files)
2. [创造检测文件](#create-your-detection-files)
3. 为使用 **Pascal VOC 评价标准**, 运行命令: `python pascalvoc.py`  
   如果你想要复现上述例子, 运行命令: `python pascalvoc.py -t 0.3`
4. (可选) [你能够使用参数来控制 IOU 阈值，Bbox 的格式等等。](#optional-arguments)

### 创造标签文件

- 为文件夹 **groundtruths/** 中的每个图像创建一个单独的标签文本文件。
- 在这些文件中，每一行的格式都应该为: `<class_name> <left> <top> <right> <bottom>`.    
- 例如，图像 "2008_000034.jpg" 的矩形框的标签值记录在文件 "2008_000034.txt" 中：
  ```
  bottle 6 234 45 362
  person 1 156 103 336
  person 36 111 198 416
  person 91 42 338 500
  ```
    
如果你喜欢，矩形框的格式也可以为: `<class_name> <left> <top> <right> <bottom>` (参考此处 [**\***](#asterisk) 以了解如何使用). 此时， 你的 "2008_000034.txt" 内容应如下:
  ```
  bottle 6 234 39 128
  person 1 156 102 180
  person 36 111 162 305
  person 91 42 247 458
  ```

### 创造检测文件

- 为文件夹 **detections/** 中的每个图像创建一个单独的检测文本文件。
- 检测文件的名称必须与其对应的标签文件名称匹配 (e.g. "detections/2008_000182.txt" 对应标签文件 "groundtruths/2008_000182.txt" 的检测结果)。
- 在这些检测文件中，每行的格式应该为: `<class_name> <confidence> <left> <top> <right> <bottom>` (参考此处 [**\***](#asterisk) 了解如何使用)。
- E.g. "2008_000034.txt":
    ```
    bottle 0.14981 80 1 295 500  
    bus 0.12601 36 13 404 316  
    horse 0.12526 430 117 500 307  
    pottedplant 0.14585 212 78 292 118  
    tvmonitor 0.070565 388 89 500 196  
    ```

如果你喜欢，Bbox 的格式可以为: `<class_name> <left> <top> <width> <height>`.

### 可选参数

Optional arguments:

| 参数 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| 描述 | 例子 | 默认 |
|:-------------:|:-----------:|:-----------:|:-----------:|
| `-h`,<br>`--help ` |	显示帮助信息 | `python pascalvoc.py -h` | |  
|  `-v`,<br>`--version` | 检查版本 | `python pascalvoc.py -v` | |  
| `-gt`,<br>`--gtfolder` | 保存标签文件的文件夹 | `python pascalvoc.py -gt /home/whatever/my_groundtruths/` | `/Object-Detection-Metrics/groundtruths`|  
| `-det`,<br>`--detfolder` | 保存检测文件的文件夹 | `python pascalvoc.py -det /home/whatever/my_detections/` | `/Object-Detection-Metrics/detections/`|  
| `-t`,<br>`--threshold` | 决定检测结果为 TP 还是 FP 的阈值 | `python pascalvoc.py -t 0.75` | `0.50` |  
| `-gtformat` | 标签文件中 Bbox 的存储格式 [**\***](#asterisk) | `python pascalvoc.py -gtformat xyrb` | `xywh` |
| `-detformat` | 检测文件中 Bbox 的存储格式 [**\***](#asterisk) | `python pascalvoc.py -detformat xyrb` | `xywh` | |  
| `-gtcoords` | 标签文件的 Bbox 坐标的参考值。<br>如果是通过图像尺寸归一化后的结果 (如 YOLO 一样), 设置为 `rel`。<br>如果未经图像尺寸归一化，是实际值， 设置为 `abs` |  `python pascalvoc.py -gtcoords rel` | `abs` |  
| `-detcoords` | 检测文件的 Bbox 坐标的参考值。<br>如果是通过图像尺寸归一化后的结果 (如 YOLO 一样), 设置为 `rel`.<br>如果未经图像尺寸归一化，是实际值， 设置为 `abs` | `python pascalvoc.py -detcoords rel` | `abs` |  
| `-imgsize ` | 图像尺寸，格式为 `width,height` <int,int>.<br>如果 `-gtcoords` 或者 `-detcoords` 为 `rel` ，则需要提供该参数| `python pascalvoc.py -imgsize 600,400` |  
| `-sp`,<br>`--savepath` | 保存绘图结果的文件夹 | `python pascalvoc.py -sp /home/whatever/my_results/` | `Object-Detection-Metrics/results/` |  
| `-np`,<br>`--noplot` | 如果提供该参数，则执行过程中不会有图像展示 | `python pascalvoc.py -np` | not presented.<br>Therefore, plots are shown |  

<a name="asterisk"> </a>
(**\***) 如果格式为 `<left> <top> <width> <height>`， 设置应为 `-gtformat xywh` and/or `-detformat xywh`。如果格式为`<left> <top> <right> <bottom>`，设置应为 `-gtformat xyrb` and/or `-detformat xyrb`  if format is `<left> <top> <right> <bottom>`.
  
## 参考

* The Relationship Between Precision-Recall and ROC Curves (Jesse Davis and Mark Goadrich)
Department of Computer Sciences and Department of Biostatistics and Medical Informatics, University of
Wisconsin  
http://pages.cs.wisc.edu/~jdavis/davisgoadrichcamera2.pdf

* The PASCAL Visual Object Classes (VOC) Challenge  
http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.157.5766&rep=rep1&type=pdf

* Evaluation of ranked retrieval results (Salton and Mcgill 1986)  
https://www.amazon.com/Introduction-Information-Retrieval-COMPUTER-SCIENCE/dp/0070544840  
https://nlp.stanford.edu/IR-book/html/htmledition/evaluation-of-ranked-retrieval-results-1.html

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR。
