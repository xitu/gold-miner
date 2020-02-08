> * 原文地址：[Edge Detection in Python](https://towardsdatascience.com/edge-detection-in-python-a3c263a13e03)
> * 原文作者：[Ritvik Kharkar](https://medium.com/@ritvikmathematics)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/edge-detection-in-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/edge-detection-in-python.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[PingHGao](https://github.com/PingHGao), [Amberlin1970](https://github.com/Amberlin1970)

# 使用 Python 进行边缘检测

![](https://cdn-images-1.medium.com/max/2298/1*I_GeYmEhSEBWTbf_kgzrgQ.png)

上季度，我在学校辅助一门 Python 课程的教学，在此过程中学到了很多图像处理的知识。我希望通过本文分享一些关于边缘检测的知识，包括边缘检测的**理论**以及如何使用 Python **实现**边缘检测。

---

### 为何检测边缘？

我们首先应该了解的问题是：**“为什么要费尽心思去做边缘检测？”**除了它的效果很酷外，为什么边缘检测还是一种实用的技术？为了更好地解答这个问题，请仔细思考并对比下面的风车图片和它的“仅含边缘的图”：

![Image of pinwheel (left) and its edges (right)](https://cdn-images-1.medium.com/max/2298/1*I_GeYmEhSEBWTbf_kgzrgQ.png)

可以看到，左边的原始图像有着各种各样的色彩、阴影，而右边的“仅含边缘的图”是黑白的。如果有人问，哪一张图片需要更多的存储空间，你肯定会告诉他原始图像会占用更多空间。这就是边缘检测的意义：通过对图片进行边缘检测，丢弃大多数的细节，从而得到“更轻量化”的图片。

因此，在无须保存图像的所有复杂细节，而**“只关心图像的整体形状”**的情况下，边缘检测会非常有用。

---

### 如何进行边缘检测 —— 数学

在讨论代码实现前，让我们先快速浏览一下边缘检测背后的数学原理。作为人类，我们非常擅长识别图像中的“边”，那如何让计算机做到同样的事呢？

首先，假设有一张很简单的图片，在白色背景上有一个黑色的正方形：

![Our working image](https://cdn-images-1.medium.com/max/2000/1*jVZqFGP3peOrhZ6rnhz0og.png)

在这个例子中，由于处理的是黑白图片，因此我们可以考虑将图中的每个像素的值都用 **0（黑色）** 或 **1（白色）**来表示。除了黑白图片，同样的理论也完全适用于彩色图像。

现在，我们需要判断上图中绿色高亮的像素是不是这个图像边缘的一部分。作为人类，我们当然可以认出它**是**图像的边缘；但如何让计算机利用相邻的像素来得到同样的结果呢？

我们以绿色高亮的像素为中心，设定一个 3 x 3 像素大小的小框，在图中以红色示意。接着，对这个小方框“应用”一个过滤器（filter）：

![对局部像素框应用纵向过滤器](https://cdn-images-1.medium.com/max/3124/1*61U9atgGnhaPinVUHKe1rA.png)

上图展示了我们将要“应用”的过滤器。乍一看上去很神秘，让我们仔细研究它做的事情：当我们说**“将过滤器应用于一小块局部像素块”**时，具体是指红色框中的每个像素与过滤器中与之位置对应的像素进行相乘。因此，红色框中左上角像素值为 1，而过滤器中左上角像素值为 -1，它们相乘得到 -1，这也就是结果图中左上角像素显示的值。结果图中的每个像素都是用这种方式得到的。

下一步是对过滤结果中的所有像素值求和，得到 -4。请注意，-4 其实是我们应用这个过滤器可获得的“最小”值（因为原始图片中的像素值只能在 0 到 1 之间）。因此，当获得 -4 这个最小值的时候，我们就能知道，对应的像素点是图像中正方形**顶部竖直方向边缘**的一部分。

为了更好地掌握这种变换，我们可以看看将此过滤器应用于图中正方形底边上的一个像素会发生什么：

![](https://cdn-images-1.medium.com/max/3106/1*wIm2uGrxSjYfscQ8ACap9Q.png)

可以看到，我们得到了与前文相似的结果，相加之后得到的结果是 4，这是应用此过滤器能得到的**最大值**。因此，由于我们得到了 4 这一最大值，可以知道这个像素是图像中正方形**底部竖直方向边缘**的一部分。

为了把这些值映射到 0-1 的范围内，我们可以简单地给其加上 4 再除以 8，这样就能把 -4 映射成 0（**黑色**），把 4 映射成 1（**白色**）。因此，我们将这种过滤器称为**纵向 Sobel 过滤器**，可以用它轻松检测图像中垂直方向的边缘。

那如何检测水平方向的边缘呢？只需简单地将**纵向过滤器**进行转置（按照其数值矩阵的对角线进行翻转）就能得到一个新的过滤器，可以用于检测水平方向的边缘。

如果需要同时检测水平方向、垂直方向以及介于两者之间的边缘，我们可以把**纵向过滤器得分和横向过滤器得分进行结合**，这个步骤在后面的代码中将有所体现。

希望上文已经讲清楚了这些理论！下面看一看代码是如何实现的。

---

### 如何进行边缘检测 —— 代码

首先进行一些设置：

```python
%matplotlib inline

import numpy as np
import matplotlib.pyplot as plt

# 定义纵向过滤器
vertical_filter = [[-1,-2,-1], [0,0,0], [1,2,1]]

# 定义横向过滤器
horizontal_filter = [[-1,0,1], [-2,0,2], [-1,0,1]]

# 读取纸风车的示例图片“pinwheel.jpg”
img = plt.imread('pinwheel.jpg')

# 得到图片的维数
n,m,d = img.shape

# 初始化边缘图像
edges_img = img.copy()
```

* 你可以把代码中的“pinwheel.jpg”替换成其它你想要找出边缘的图片文件！需要确保此文件和代码在同一工作目录中。

接着编写边缘检测代码本身：

```python
%matplotlib inline

import numpy as np
import matplotlib.pyplot as plt

# 定义纵向过滤器
vertical_filter = [[-1,-2,-1], [0,0,0], [1,2,1]]

# 定义横向过滤器
horizontal_filter = [[-1,0,1], [-2,0,2], [-1,0,1]]

# 读取纸风车的示例图片“pinwheel.jpg”
img = plt.imread('pinwheel.jpg')

# 得到图片的维数
n,m,d = img.shape

# 初始化边缘图像
edges_img = img.copy()

# 循环遍历图片的全部像素
for row in range(3, n-2):
    for col in range(3, m-2):
        
        # 在当前位置创建一个 3x3 的小方框
        local_pixels = img[row-1:row+2, col-1:col+2, 0]
        
        # 应用纵向过滤器
        vertical_transformed_pixels = vertical_filter*local_pixels
        # 计算纵向边缘得分
        vertical_score = vertical_transformed_pixels.sum()/4
        
        # 应用横向过滤器
        horizontal_transformed_pixels = horizontal_filter*local_pixels
        # 计算横向边缘得分
        horizontal_score = horizontal_transformed_pixels.sum()/4
        
        # 将纵向得分与横向得分结合，得到此像素总的边缘得分
        edge_score = (vertical_score**2 + horizontal_score**2)**.5
        
        # 将边缘得分插入边缘图像中
        edges_img[row, col] = [edge_score]*3

# 对边缘图像中的得分值归一化，防止得分超出 0-1 的范围
edges_img = edges_img/edges_img.max()
```

有几点需要注意：

* 在图片的边界像素上，我们无法创建完整的 3 x 3 小方框，因此在图片的四周会有一个细边框。
* 既然是同时检测水平方向和垂直方向的边缘，我们可以直接将原始的纵向得分与横向得分分别除以 4（而不像前文描述的分别加 4 再除以 8）。这个改动无伤大雅，反而可以更好地突出图像的边缘。
* 将纵向得分与横向得分结合起来时，有可能会导致最终的边缘得分超出 0-1 的范围，因此最后还需要重新对最终得分进行标准化。

在更复杂的图片上运行上述代码：

![](https://cdn-images-1.medium.com/max/3032/1*QnVu-wTPcpcHJ1Gixu-k2g.png)

得到边缘检测的结果：

![](https://cdn-images-1.medium.com/max/3032/1*v4JxLC5XMqlO9kEgjwsV9Q.jpeg)

---

以上就是本文的全部内容了！希望你了解到了一点新知识，并继续关注更多数据科学方面的文章〜

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
