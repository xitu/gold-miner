> * 原文地址：[Implementing Seam Carving with Python](https://karthikkaranth.me/blog/implementing-seam-carving-with-python?utm_source=mybridge&utm_medium=blog&utm_campaign=read_more)
> * 原文作者：[Karthik Karanth](https://karthikkaranth.me)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/implementing-seam-carving-with-python.md](https://github.com/xitu/gold-miner/blob/master/TODO1/implementing-seam-carving-with-python.md)
> * 译者：[caoyi0905](https://github.com/caoyi0905)
> * 校对者：

# 使用 Python 实现接缝裁剪算法

接缝裁剪是一种新型的裁剪图像的方式，它不会丢失图像中的重要内容。这通常被称之为“内容感知”裁剪或图像重定向。你可以从这张照片中感受一下这个算法：

![](https://karthikkaranth.me/img/pietro-de-grandi-329892-unsplash.jpg)

[照片由 Unsplash 用户 Pietro De Grandi 提供](https://unsplash.com/photos/T7K4aEPoGGk)

变成下面这张:

![](https://karthikkaranth.me/img/pietro_carved.jpg)

正如你所看到的，图像中的非常重要内容 —— 船只，都保留下来了。该算法去除了一些岩层和水（让船看起来更靠近）。核心算法可以参考 Shai Avidan 和 Ariel Shamir 的原始论文 [Seam Carving for Content-Aware Image Resizing](http://graphics.cs.cmu.edu/courses/15-463/2007_fall/hw/proj2/imret.pdf) 。在这篇文章中，我将展示如何在 Python 中基本实现该算法。

## 概要

该算法的工作原理如下：

1.  为每个像素分派一个能量值（energy）
2.  找到能量最低的像素的 8 联通区域
3.  删除该区域内所有的像素
4.  重复 1-3，直到删除所需要保留的行/列数

接下来，假设我们只是尝试裁剪图像的宽度，即删除列。对于删除行来说也是类似的，至于原因最后会说明。

以下是 Python 代码需要引入的包：

```
import sys

import numpy as np
from imageio import imread, imwrite
from scipy.ndimage.filters import convolve

# tqdm 并不是必需的，但它可以向我们展示一个漂亮的进度条
from tqdm import trange
```

### 能量图

第一步是计算每个像素的能量值，论文中定义了许多不同的可以使用的能量函数。我们来使用最基础的那个：

![](https://karthikkaranth.me/img/energy_function.png)

这意味着什么呢？`I` 代表图像，所以这个式子告诉我们，对于图像中的每个像素和每个通道，我们执行以下几个步骤：

*   找到 x 轴的偏导数
*   找到 y 轴的偏导数
*   将他们的绝对值求和

这就是该像素的能量值。那么问题就来了，“你怎么计算图像的导数？”，维基百科上的 [Image derivations（图像导数）](https://en.wikipedia.org/wiki/Image_derivatives) 给我们展示了许多不同的计算图像导数的方法。我们将使用 Sobel 滤波器。这是一个在图像上的每个通道上的计算的[convolutional kernel（卷积核）](http://aishack.in/tutorials/image-convolution-examples/)。以下是图像的两个不同方向的过滤器：

![](https://karthikkaranth.me/img/sobel.png)

直观地说，我们可以认为第一个滤波器是将每个像素替换为它上边的值和下边的值之差。第二个过滤器将每个像素替换为它右边的值和左边的值之差。这种滤波器捕捉到的是每个像素相邻所构成的 3x3 区域中像素的总体趋势。事实上，这种方法与边缘检测算法也有关系。计算能量图的方式非常简单：

```
def calc_energy(img):
    filter_du = np.array([
        [1.0, 2.0, 1.0],
        [0.0, 0.0, 0.0],
        [-1.0, -2.0, -1.0],
    ])
    # 将一个2D的滤波器转为3D的滤波器，为每个通道设置相同的滤波器： R，G，B
    filter_du = np.stack([filter_du] * 3, axis=2)

    filter_dv = np.array([
        [1.0, 0.0, -1.0],
        [2.0, 0.0, -2.0],
        [1.0, 0.0, -1.0],
    ])
    # 将一个2D的滤波器转为3D的滤波器，为每个通道设置相同的滤波器： R，G，B
    filter_dv = np.stack([filter_dv] * 3, axis=2)

    img = img.astype('float32')
    convolved = np.absolute(convolve(img, filter_du)) + np.absolute(convolve(img, filter_dv))

    # 我们将红绿色蓝三通道中的能量相加
    energy_map = convolved.sum(axis=2)

    return energy_map
```

可视化能量图后，我们可以看到：

![](https://karthikkaranth.me/img/pietro_energy.jpg)

显然，像天空和水的静止部分这样变化最小的区域，具有非常低的能量（暗的部分）。当我们运行接缝裁剪算法的时候，被移除的线条一般都与图像的这些部分紧密相关，同时试图保留高能量部分（亮的部分）。

###　找到最小能量的接缝（seam）

我们下一个目标就是找到一条从图像顶部到图像底部的能量最小的路径。这条线必须是 8 联通的：这意味着线中的每个像素都可以他通过边或叫角碰到线中的下一个像素。举个例子，这就是下图中的红色线条：

![](https://karthikkaranth.me/img/pietro_first_seam.jpg)

所以我们怎么找到这条线呢？事实证明，这个问题可以很好地使用动态规划来解决！

![](https://karthikkaranth.me/img/minimize_energy.png)

让我们创建一个名为 `M` 的 2D 数组 来存储每个像素的最小能量值。如果您不熟悉动态规划，这简单来说就是，从图像顶部到该点的所有可能接缝（seam）中的最小能量即为 `M[i,j]` 。因此，M 的最后一行中就将包含从图像顶部到底部的最小能量。我们需要从此回溯以查找此接缝中存在的像素，所以我们将保留这些值，存储在名为`backtrack` 的 2D 数组中。

```
def minimum_seam(img):
    r, c, _ = img.shape
    energy_map = calc_energy(img)

    M = energy_map.copy()
    backtrack = np.zeros_like(M, dtype=np.int)

    for i in range(1, r):
        for j in range(0, c):
            # 处理图像的左边缘，防止索引到 -1
            if j == 0:
                idx = np.argmin(M[i - 1, j:j + 2])
                backtrack[i, j] = idx + j
                min_energy = M[i - 1, idx + j]
            else:
                idx = np.argmin(M[i - 1, j - 1:j + 2])
                backtrack[i, j] = idx + j - 1
                min_energy = M[i - 1, idx + j - 1]

            M[i, j] += min_energy

    return M, backtrack
```

### 删除最小能量的接缝中的像素

然后我们就可以删除有着最低能量的接缝中的像素，返回新的图片：

```
def carve_column(img):
    r, c, _ = img.shape

    M, backtrack = minimum_seam(img)

    # 创建一个（r，c）矩阵，所有值都为 True
    # 我们将删除图像中矩阵里所有为 False 的对应的像素
    mask = np.ones((r, c), dtype=np.bool)

    # 找到 M 最后一行中最小元素的那一列的索引
    j = np.argmin(M[-1])

    for i in reversed(range(r)):
        # 标记这个像素之后需要删除
        mask[i, j] = False
        j = backtrack[i, j]

    # 因为图像是三通道的，我们将 mask 转为 3D 的
    mask = np.stack([mask] * 3, axis=2)

    # 删除 mask 中所有为 False 的位置所对应的像素，并将
    # 他们重新调整为新图像的尺寸
    img = img[mask].reshape((r, c - 1, 3))

    return img
```

### 对每列重复操作

所有的基础工作都已做完了！现在，我们只要一次次地运行 `carve_column ` 函数，直到我们删除到了所需的列数。我们再创建一个 `crop_c` 函数，图像和缩放因子作为输入。如果图像的尺寸为（300,600），并且我们想要将其减小到（150,600），`scale_c` 设置为 0.5 即可。

```
def crop_c(img, scale_c):
    r, c, _ = img.shape
    new_c = int(scale_c * c)

    for i in trange(c - new_c): # 如果你不想用tqdm，这里将 trange 改为 range
        img = carve_column(img)

    return img
```

## 将它们合在一起

我们可以添加一个 main 函数，让代码可以通过命令行调用：

```
def main():
    scale = float(sys.argv[1])
    in_filename = sys.argv[2]
    out_filename = sys.argv[3]

    img = imread(in_filename)
    out = crop_c(img, scale)
    imwrite(out_filename, out)

if __name__ == '__main__':
    main()
```

然后运行这段代码:

```
python carver.py 0.5 image.jpg cropped.jpg
```

cropped.jpg 现在应该显示以下这样的图像:

![]https://karthikkaranth.me/img/pietro_carved.jpg)

## 行应该怎么处理呢?

然后，我们可以开始研究怎么修改我们的循环来换个方向处理数据。或者......只需旋转图像就可以运行 `crop_c` ！

```
def crop_r(img, scale_r):
    img = np.rot90(img, 1, (0, 1))
    img = crop_c(img, scale_r)
    img = np.rot90(img, 3, (0, 1))
    return img
```

将这段代码添加到 main 函数中，现在我们也可以裁剪行！

```
def main():
    if len(sys.argv) != 5:
        print('usage: carver.py <r/c> <scale> <image_in> <image_out>', file=sys.stderr)
        sys.exit(1)

    which_axis = sys.argv[1]
    scale = float(sys.argv[2])
    in_filename = sys.argv[3]
    out_filename = sys.argv[4]

    img = imread(in_filename)

    if which_axis == 'r':
        out = crop_r(img, scale)
    elif which_axis == 'c':
        out = crop_c(img, scale)
    else:
        print('usage: carver.py <r/c> <scale> <image_in> <image_out>', file=sys.stderr)
        sys.exit(1)
    
    imwrite(out_filename, out)
```

运行代码:

```
python carver.py r 0.5 image2.jpg cropped.jpg
```

然后我们就可以把这张图:

![](https://karthikkaranth.me/img/brent-cox-455716-unsplash.jpg)

[Photo by Brent Cox on Unsplash](https://unsplash.com/photos/ydGRmobx5jA)

变成这样:

![](https://karthikkaranth.me/img/brent_carved.jpg)

## 总结

我希望你是愉快而又收获地读到这里的。我很享受实现这篇论文的过程，并打算构建一个这个算法更快的版本。比如说，使用相同的计算过的图像接缝去除多个接缝。在我的实验中，这可以使算法更快，每次迭代可以几乎线性地移除接缝，但质量明显下降。另一个优化是计算 GPU 上的能量图，[在这里探讨的](http://www.contrib.andrew.cmu.edu/~abist/seamcarving.html)。

这是完整的程序：

```
#!/usr/bin/env python

"""
Usage: python carver.py <r/c> <scale> <image_in> <image_out>
Copyright 2018 Karthik Karanth, MIT License
"""

import sys

from tqdm import trange
import numpy as np
from imageio import imread, imwrite
from scipy.ndimage.filters import convolve

def calc_energy(img):
    filter_du = np.array([
        [1.0, 2.0, 1.0],
        [0.0, 0.0, 0.0],
        [-1.0, -2.0, -1.0],
    ])
    # 将一个2D的滤波器转为3D的滤波器，为每个通道设置相同的滤波器： R，G，B
    filter_du = np.stack([filter_du] * 3, axis=2)

    filter_dv = np.array([
        [1.0, 0.0, -1.0],
        [2.0, 0.0, -2.0],
        [1.0, 0.0, -1.0],
    ])
    # 将一个2D的滤波器转为3D的滤波器，为每个通道设置相同的滤波器： R，G，B
    filter_dv = np.stack([filter_dv] * 3, axis=2)

    img = img.astype('float32')
    convolved = np.absolute(convolve(img, filter_du)) + np.absolute(convolve(img, filter_dv))

    # 我们将红绿色蓝三通道中的能量相加
    energy_map = convolved.sum(axis=2)

    return energy_map

def crop_c(img, scale_c):
    r, c, _ = img.shape
    new_c = int(scale_c * c)

    for i in trange(c - new_c):
        img = carve_column(img)

    return img

def crop_r(img, scale_r):
    img = np.rot90(img, 1, (0, 1))
    img = crop_c(img, scale_r)
    img = np.rot90(img, 3, (0, 1))
    return img

def carve_column(img):
    r, c, _ = img.shape

    M, backtrack = minimum_seam(img)
    mask = np.ones((r, c), dtype=np.bool)

    j = np.argmin(M[-1])
    for i in reversed(range(r)):
        mask[i, j] = False
        j = backtrack[i, j]

    mask = np.stack([mask] * 3, axis=2)
    img = img[mask].reshape((r, c - 1, 3))
    return img

def minimum_seam(img):
    r, c, _ = img.shape
    energy_map = calc_energy(img)

    M = energy_map.copy()
    backtrack = np.zeros_like(M, dtype=np.int)

    for i in range(1, r):
        for j in range(0, c):
            # 处理图像的左边缘，防止索引到 -1
            if j == 0:
                idx = np.argmin(M[i-1, j:j + 2])
                backtrack[i, j] = idx + j
                min_energy = M[i-1, idx + j]
            else:
                idx = np.argmin(M[i - 1, j - 1:j + 2])
                backtrack[i, j] = idx + j - 1
                min_energy = M[i - 1, idx + j - 1]

            M[i, j] += min_energy

    return M, backtrack

def main():
    if len(sys.argv) != 5:
        print('usage: carver.py <r/c> <scale> <image_in> <image_out>', file=sys.stderr)
        sys.exit(1)

    which_axis = sys.argv[1]
    scale = float(sys.argv[2])
    in_filename = sys.argv[3]
    out_filename = sys.argv[4]

    img = imread(in_filename)

    if which_axis == 'r':
        out = crop_r(img, scale)
    elif which_axis == 'c':
        out = crop_c(img, scale)
    else:
        print('usage: carver.py <r/c> <scale> <image_in> <image_out>', file=sys.stderr)
        sys.exit(1)
    
    imwrite(out_filename, out)

if __name__ == '__main__':
    main()
```

* * *

**修改于(2018年5月5日):** 正如一个[热心的 reddit 用户](https://www.reddit.com/r/Python/comments/8mpjw4/implementing_seam_carving_with_python/dzpouv4/) 所说，通过使用 [numba](https://numba.pydata.org/) 来加速计算繁重的功能，可以很容易的得到几十倍的性能提升。要想体验 numba，只要在函数 `carve_column` 和 `minimum_seam` 之前加上 `@numba.jit`。就像下面这样：

```
@numba.jit
def carve_column(img):

@numba.jit
def minimum_seam(img):
```

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
