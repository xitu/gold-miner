> * 原文地址：[Real-time Human Pose Estimation in the Browser with TensorFlow.js](https://medium.com/tensorflow/real-time-human-pose-estimation-in-the-browser-with-tensorflow-js-7dd0bc881cd5)
> * 原文作者：[Dan Oved](http://www.danioved.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/real-time-human-pose-estimation-in-the-browser-with-tensorflow-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/real-time-human-pose-estimation-in-the-browser-with-tensorflow-js.md)
> * 译者：[NoName4Me](https://github.com/NoName4Me)
> * 校对者：

# 在浏览器里使用 TenserFlow.js 实时估计人体姿态

发布者：[Dan Oved](http://www.danioved.com/)，谷歌创意实验室自由创意技术专家，纽约大学 ITP 研究生。
编辑和插图：创意技术专家 [Irene Alvarado](https://twitter.com/irealva) 和谷歌创意实验室自由平面设计师 [Alexis Gallo](http://alexisgallo.com/)。

在与谷歌创意实验室的合作中，我很高兴地宣布 [TensorFlow.js](https://js.tensorflow.org/) 版 [PoseNet](https://github.com/tensorflow/tfjs-models/tree/master/posenet)[¹](https://arxiv.org/abs/1701.01779) 的发行，[²](https://arxiv.org/abs/1803.08225) 它是一个能够**在浏览器里对人体姿态进行实时估计**的机器学习模型。[点击这里](https://storage.googleapis.com/tfjs-models/demos/posenet/camera.html)在线体验。

![](https://cdn-images-1.medium.com/max/600/1*BKZqEPtvM-6xwarhABZQnA.gif)

![](https://cdn-images-1.medium.com/max/600/1*Gsx7MLBj2LKiaDsab0iNjg.gif)

PoseNet 使用单姿态或多姿态算法可以检测图像和视频中的人物形象 —— 全部在浏览器中完成。

**那么，姿态估计究竟是什么呢？**姿态估计是指在图像和视频中检测人物的计算机视觉技术，比如，可以确定某个人的肘部在图像中的位置。需要澄清一点，这项技术并不是识别图像中是**谁** —— 姿态估计不涉及任何个人身份信息。该算法仅仅是估计身体关键关节的位置。

**好吧，为什么这是令人兴奋的开始？**姿态估计有很多用途，从[互动]((https://vimeo.com/128375543)[装置](https://www.youtube.com/watch?v=I5__9hq-yas)[反馈](https://vimeo.com/34824490)给[身体](https://vimeo.com/2892576)，到[增强现实](https://www.instagram.com/p/BbkKLiegrTR/)，[动画](https://www.instagram.com/p/Bg1EgOihgyh/?taken-by=millchannel)，[健身用途](https://www.runnersneed.com/expert-advice/gear-guides/gait-analysis.html)等等。我们希望借助此模型激励更多的开发人员和制造商尝试将姿态检测应用到他们自己的独特项目中。虽然许多同类姿态检测系统也已经[开源](https://github.com/CMU-Perceptual-Computing-Lab/openpose)，但它们都需要专门的硬件和/或相机，以及相当多的系统安装。**在 [**TensorFlow.js**](https://js.tensorflow.org/) 上运行 PoseNet，任何有合适摄像头的桌面或手机的人都可以在浏览器中体验这项技术**。而且由于我们已经开源了这个模型，JavaScript 开发人员可以用几行代码来修改和使用这个技术。更重要的是，这实际上可以帮助保护用户隐私。因为 基于 TensorFlow.js 的 PoseNet 运行在浏览器中，任何姿态数据都不会离开用户的计算机。

在我们深入探讨如何使用这个模型的细节之前，先向所有让这个项目成为可能的人们致意：论文[**对户外多姿态的精确估计**](https://arxiv.org/abs/1701.01779) 和 [**PersonLab: 自下而上的局部几何嵌入模型的人体姿态估计和实例分割**](https://arxiv.org/abs/1803.08225)的作者 [George Papandreou](https://research.google.com/pubs/GeorgePapandreou.html) 和 [Tyler Zhu](https://research.google.com/pubs/TylerZhu.html)，以及 [TensorFlow.js](https://js.tensorflow.org/) 库背后的 Google Brain 小组的工程师 [Nikhil Thorat](https://twitter.com/nsthorat) 和 [Daniel Smilkov](https://twitter.com/dsmilkov?lang=en)。

* * *

### PoseNet 入门

[PoseNet](https://github.com/tensorflow/tfjs-models/tree/master/posenet) 可以被用来估计**单姿态**或**多姿态**，这意味着算法有一个检测图像/视频中只有一个人的版本，和检测多人的版本。为什么会有两个版本？因为单姿态检测更快，更简单，但要求图像中只能有一个主体（后面会详细说明）。我们先说单体姿态，因为它更简单易懂。

姿态估计整体来看主要有两个阶段：

1. 一个通过卷积神经网络反馈的 **RGB 图像**。
2. 使用单姿态或多姿态解码算法从模型输出中解码**姿态，姿态置信得分**，**关键点位置**，以及**关键点置信得分**。

等一下，所有这些关键词指的是什么？我们看看一下最重要的几个：

* **姿态** - 从最上层来看，PoseNet 将返回一个姿态对象，其中包含每个检测到的人物的关键点列表和实例级别的置信度分数。

![](https://cdn-images-1.medium.com/max/800/1*3bg3CO1b4yxqgrjsGaSwBw.png)

PoseNet 返回检测到的每个人的置信度值以及检测到的每个姿态关键点。图片来源：「Microsoft Coco：上下文数据集中的通用对象」，[https://cocodataset.org](http://cocodataset.org/#home)。

* **姿态置信度分数** - 决定了对姿态估计的整体置信度。它介于 0.0 和 1.0 之间。它可以用来隐藏分数不够高的姿态。
* **关键点** —— 估计的人体姿态的一部分，例如鼻子，右耳，左膝，右脚等。 它包含位置和关键点置信度分数。PoseNet 目前检测到下图所示的 17 个关键点：

![](https://cdn-images-1.medium.com/max/800/1*7qDyLpIT-3s4ylULsrnz8A.png)

PosNet 检测到17个姿态关键点。

* **关键点置信度得分** - 决定了估计关键点位置准确的置信度。它介于 0.0 和 1.0 之间。它可以用来隐藏分数不够高的关键点。
* **关键点位置** —— 检测到关键点的原始输入图像中的二维 x 和 y 坐标。

#### 第 1 部分：导入 TensorFlow.js 和 PoseNet 库

很多工作都是将模型的复杂性抽象化并将功能封装为易于使用的方法。我们看一下构建 PoseNet 项目的基础知识。

该库可以通过 npm 安装：

```shell
npm install @[tensorflow-models/posenet](https://www.npmjs.com/package/@tensorflow-models/posenet)
```

然后使用 es6 模块导入：

```js
import * as posenet from '@[tensorflow-models/posenet](https://www.npmjs.com/package/@tensorflow-models/posenet)';

const net = await posenet.load();
```

或通过页面中的一个包：

```html
<html>
  <body>
    <!-- Load TensorFlow.js -->
    <script src="[https://unpkg.com/@tensorflow/tfjs](https://unpkg.com/@tensorflow/tfjs)"></script>
    <!-- Load Posenet -->
    <script src="[https://unpkg.com/@tensorflow-models/posenet](https://unpkg.com/@tensorflow-models/posenet)">
    </script>
    <script type="text/javascript">
      posenet.load().then(function(net) {
        // posenet 模块加载成功
      });
    </script>
  </body>
</html>
```

#### 第 2a 部分：单人姿态估计

![](https://cdn-images-1.medium.com/max/800/1*SpWPwprVuNYhXs44iTSODg.png)

单姿态估计算法用于图像的示例。图片来源：「Microsoft Coco：上下文数据集中的通用对象」，[https://cocodataset.org](http://cocodataset.org/#home)。

如前所述，单姿态估计算法更简单，速度更快。它的理想使用场景是当输入图像或视频中心只有一个人。缺点是，如果图像中有多个人，那么来自两个人的关键点可能会被估计成同一个人的姿态的一部分 —— 举个例子，路人甲的左臂和路人乙的右膝可能会由该算法确定为属于相同姿态而被合并。如果输入图像可能包含多人，则应该使用多姿态估计算法。

我们来看看单姿态估计算法的**输入**：

* **输入图像元素** —— 包含要预测图像的 html 元素，例如视频或图像标记。重要的是，输入的图像或视频元素应该是**正方形**的。
* **图像比例因子** —— 在 0.2 和 1 之间的数字。默认为 0.50。在送入神经网络之前如何缩放图像。将此数字设置得较低以缩小图像，并以精度为代价增加通过网络的速度。
* **水平翻转** —— 默认为 false。表示是否姿态应该水平/垂直镜像。对于视频默认水平翻转（比如网络摄像头）的视频，应该设置为 true，因为你希望姿态能以正确的方向返回。
* **输出步幅** —— 必须为 32，16 或 8。默认 16。在内部，此参数会影响神经网络中图层的高度和宽度。在上层看来，它会影响姿态估计的**精度**和**速度**。值**越小**精度越高，但速度更慢，值**越大**速度越快，但精度更低。查看输出步幅对输出质量的影响的最好方法是体验这个[单姿态估计演示](https://storage.googleapis.com/tfjs-models/demos/posenet/camera.html)。

下面让我们看一下单姿态估计算法的**输出**：

1. 一个包含姿态置信度得分和 17 个关键点数组的姿态。
2. 每个关键点都包含关键点位置和关键点置信度得分。同样，所有关键点位置在输入图像的坐标空间中都有 x 和 y 坐标，并且可以直接映射到图像上。

这个段代码块显示了如何使用单姿态估计算法：

```js
const imageScaleFactor = 0.50;
const flipHorizontal = false;
const outputStride = 16;

const imageElement = document.getElementById('cat');

// 加载 posenet 模型
const net = await posenet.load();

const pose = await net.estimateSinglePose(imageElement, scaleFactor, flipHorizontal, outputStride);
```

输出姿态示例如下：

```js
{
  "score": 0.32371445304906,
  "keypoints": [
    { // 鼻子
      "position": {
        "x": 301.42237830162,
        "y": 177.69162777066
      },
      "score": 0.99799561500549
    },
    { // 左眼
      "position": {
        "x": 326.05302262306,
        "y": 122.9596464932
      },
      "score": 0.99766051769257
    },
    { // 右眼
      "position": {
        "x": 258.72196650505,
        "y": 127.51624706388
      },
      "score": 0.99926537275314
    },
    ...
  ]
}
```

#### 第 2b 部分：多人姿态估计

![](https://cdn-images-1.medium.com/max/800/1*EZOqbMLkIwBgyxrKLuQTHA.png)

多人姿态估计算法应用于图像的例子。图片来源：「Microsoft Coco：上下文数据集中的通用对象」，[https://cocodataset.org](http://cocodataset.org/#home)。

多人姿态估计算法可以估计图像中的多个姿态/人物。它比单姿态算法更复杂并且稍慢，但它的优点是，如果图片中出现多个人，他们检测到的关键点不太可能与错误的姿态相关联。出于这个原因，即使用例是用来检测单人的姿态，该算法也可能更合乎需要。

此外，该算法吸引人的特性是性能不受输入图像中人数的影响。无论是 15 人还是 5 人，计算时间都是一样的。

让我们看一下它的**输入**：

* **输入图像元素** —— 与单姿态估计相同
* **图像比例因子** —— 与单姿态估计相同
* **水平翻转** —— 与单姿态估计相同
* **输出步幅** —— 与单姿态估计相同
* **最大检测姿态** —— 一个整数。默认为 5，表示要检测的姿态的最大数量。
* **姿态置信分数阈值** —— 0.0 至 1.0。默认为 0.5。在更深层次上，这将控制返回姿态的最低置信度分数。
* **非最大抑制（NMS，Non-maximum suppression）半径** —— 以像素为单位的数字。在更深层次上，这控制了返回姿态之间的最小距离。这个值默认为 20，这在大多数情况下可能是好的。可以通过增加/减少，以滤除不太准确的姿态，但只有在调整姿态置信度分数无法满足时才调整它。

查看这些参数有什么影响的最好方法是体验这个[多人姿态估计演示](https://storage.googleapis.com/tfjs-models/demos/posenet/camera.html)。

让我们看一下它的**输出**：

* 以一系列姿态为 `resolve` 的 `promise`。
* 每个姿态包含与单姿态估计算法中相同的信息。

这段代码块显示了如何使用多姿态估计算法：

```js
const imageScaleFactor = 0.50;
const flipHorizontal = false;
const outputStride = 16;
// 最多 5 个姿态
const maxPoseDetections = 5;
// 姿态的最小置信度
const scoreThreshold = 0.5;
// 两个姿态之间的最小像素距离
const nmsRadius = 20;

const imageElement = document.getElementById('cat');

// 加载 posenet
const net = await posenet.load();

const poses = await net.estimateMultiplePoses(
  imageElement, imageScaleFactor, flipHorizontal, outputStride,    
  maxPoseDetections, scoreThreshold, nmsRadius);
```

输出数组的示例如下所示：

```js
// 姿态/人的数组
[ 
  { // pose #1
    "score": 0.42985695206067,
    "keypoints": [
      { // nose
        "position": {
          "x": 126.09371757507,
          "y": 97.861720561981
         },
        "score": 0.99710708856583
      },
      ... 
    ]
  },
  { // pose #2
    "score": 0.13461434583673,
    "keypositions": [
      { // nose
        "position": {
          "x": 116.58444058895,
          "y": 99.772533416748
        },
      "score": 0.9978438615799
      },
      ...
    ]
  },
  ... 
]
```

**如果你已经读到了这里，你应该了解的足够多，可以开始 [PoseNet]((https://github.com/tensorflow/tfjs-models/tree/master/posenet/demos)) 演示了**。**这可能是一个很好的停止点**。如果你想了解更多关于该模型和实现的技术细节，我们邀请你继续阅读下文。

* * *

### 写给好奇的人：技术深探

在本节中，我们将介绍关于单姿态估计算法的更多技术细节。在上层来看，这个过程如下所示：

![](https://cdn-images-1.medium.com/max/800/1*ey139jykjnBzUqcknAjHGQ.png)

使用 PoseNet 的单人姿态检测器流程。

需要注意的一个重要细节是研究人员训练了 PoseNet 的 [ResNet](https://arxiv.org/abs/1512.03385) 模型和 [MobileNet](https://arxiv.org/abs/1704.04861) 模型。虽然 ResNet 模型具有更高的准确性，但其大尺寸和多层的特点会使页面加载时间和推导时间对于任何实时应用程序都不理想。我们使用 MobileNet 模型，因为它是为移动设备而设计的。

#### 重新审视单姿态估计算法

**处理模型输入：输出步幅的解释**

首先，我们将说明如何通过讨论**输出步幅**来获得 PoseNet 模型输出（主要是热图和偏移矢量）。

比较方便地是，PoseNet 模型是图像大小不变的，这意味着它能以与原始图像相同的比例预测姿态位置，而不管图像是否缩小。这意味着 PoseNet 可以通过设置上面我们在运行时提到的**输出步幅**，**以牺牲性能获得更高的精度**。

输出步幅决定了我们相对于输入图像大小缩小输出的程度。它会影响图层和模型输出的大小。输出步幅**越大**，网络中的层和输出的分辨率越小，准确性也越低。在此实现中，输出步幅可以为 8，16 或 32。换句话说，输出步幅为 32 将输出最快但是精度最低，而 8 的精度最高但是最慢。我们建议从 16 开始。

![](https://cdn-images-1.medium.com/max/800/1*zXXwR16kprAWLPIOKCrXLw.png)

输出步幅决定了输出相对于输入图像的缩小程度。较高的输出步幅会更快，但会导致精度较低。

本质是，当输出步幅设置为 8 或 16 时，层中的输入量减少使得可以创建更大的输出分辨率。然后使用[Atrous 卷积](https://www.tensorflow.org/api_docs/python/tf/nn/atrous_conv2d)来使后续图层中的卷积滤波器具有更宽的视野（当输出步幅为 32 时，不会应用 atrous 卷积）。虽然Tensorflow 支持 atrous 卷积，但 TensorFlow.js 不支持，所以我们添加了一个 [PR](https://github.com/tensorflow/tfjs-core/pull/794) 来包含这个。

**模型输出：热图和偏移矢量**

当 PoseNet 处理图像时，事实上返回的是热图以及偏移矢量，可以解码以找到图像中与姿态关键点对应的高置信度区域。我们将在一分钟内讨论它们各自的含义，但现在下面的插图以高级方式捕获每个姿态关键点与一个热图张量和一个偏移矢量张量的关联。

![](https://cdn-images-1.medium.com/max/800/1*mcaovEoLBt_Aj0lwv1-xtA.png)

PoseNet 返回的 17 个姿态关键点中的每一个都与一个热图张量和一个偏移矢量张量相关联，用于确定关键点的确切位置。

这两个输出都是具有高度和宽度的 3D 张量，我们将其称为**分辨率**。分辨率由输入图像大小和输出步幅根据以下公式确定：

```js
Resolution = ((InputImageSize - 1) / OutputStride) + 1

// 示例：宽度为 225 像素且输出步幅为 16 的输入图像产生输出分辨率为 15
// 15 = ((225 - 1) / 16) + 1
```

**热图**

每个热图是尺寸 **resolution x resolution x 17** 的 3D 张量，因为 17 是 PoseNet 检测到的关键点的数量。例如，图像大小为 225，输出步幅为 16，那么就是 15 x 15 x 17。第三维（17）中的每个切片对应于特定关键点的热图。该热图中的每个位置都有一个置信度分数，这是该类型关键点的一部分在该位置的概率。它可以被认为是原始图像被分解成 15 x 15 网格，其中热图分数提供了每个网格中每个关键点存在概率的等级。

**偏移矢量**

每个偏移矢量都是尺寸 **resolution x resolution x 17** 的 3D 张量，其中 34 是关键点数* 2。图像大小为 225，输出步幅为 16 时，它是 15 x 15 x 34。由于热图是关键点位置的近似值，所以偏移矢量在位置上对应于热图中的点，并且用于通过沿相应热图点的矢量行进来预测关键点的确切位置。偏移矢量的前 17 个切片包含矢量的 x 坐标和后 17 个包含 y 坐标。偏移矢量大小**与原始图像具有相同的比例**。

**根据模型的输出估计姿态**

图像通过模型馈送后，我们执行一些计算来从输出中估计姿态。例如，单姿态估计算法返回姿态置信度分数，其自身包含关键点阵列（通过零件 ID 索引），每个关键点具有置信度分数和 x，y 位置。

为了获得姿态的关键点：

1. 调用热图的 **sigmoid** 方法，以获得分数。
    `scores = heatmap.sigmoid()`
2. **argmax2d** 是根据关键点置信度得分来获得热图中 x 和 y 索引，取每个部分的得分最高者，一般也是该部分最有可能存在的地方。这会产生一个尺寸为 17 x 2 的张量，每一行都是热图中的 y 和 x 索引，每个部分的得分最高。
    `heatmapPositions = scores.argmax(y, x)`
3. 每部分的**偏移矢量**通过从该部分的热图中对应 x 和 y 索引的偏移量中获取 x 和 y。这会产生 17 x 2 的张量，每行都是相应关键点的偏移向量。例如，对于索引为 k 的部分，当热图位置为 y 和 d 时，偏移矢量为：
    `offsetVector = [offsets.get(y, x, k), offsets.get(y, x, 17 + k)]`
4. 为了获得**关键点**，将每部分的热图 x 和 y 乘以输出步幅，然后将其添加到它们对应的偏移向量中，该向量与原始图像具有相同的比例。
    `keypointPositions = heatmapPositions * outputStride + offsetVectors`
5. 最后，每个**关键点置信度分数**是其热图**位置的置信度分数**。该姿态的置信度得分是关键点的评分的平均值。

#### 多人姿态估计

多姿态估计算法的细节超出了本文的范围。该算法的主要不同之处在于它使用**贪婪**过程通过沿着基于部分图的位移矢量将关键点分组为姿态。具体来说，它使用研究论文 [**PersonLab: 自下而上的局部几何嵌入模型的人体姿态估计和实例分割**](https://arxiv.org/pdf/1803.08225.pdf)中的**快速贪婪解码**算法。有关多姿态算法的更多信息，请阅读完整的研究论文或查看[代码](https://github.com/tensorflow/tfjs-models/tree/master/posenet/src)。

* * *

我们希望随着越来越多的模型被移植到 TensorFlow.js，机器学习的世界变得对更容易被新的开发者和制造者接受，更受欢迎和更有趣。基于 TensorFlow.js 的 PoseNet 是实现这一目标的一个小小尝试。我们很乐意看到你做出了什么 —— 不要忘记使用 #tensorflowjs 和 #posenet 分享您的精彩项目！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
