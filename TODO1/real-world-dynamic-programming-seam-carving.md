> * 原文地址：[Real-world dynamic programming: seam carving](https://medium.com/swlh/real-world-dynamic-programming-seam-carving-9d11c5b0bfca)
> * 原文作者：[Avik Das](https://medium.com/@avik.das)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/real-world-dynamic-programming-seam-carving.md](https://github.com/xitu/gold-miner/blob/master/TODO1/real-world-dynamic-programming-seam-carving.md)
> * 译者：[nettee](https://github.com/nettee)
> * 校对者：[JalanJiang](https://github.com/JalanJiang)，[TokenJan](https://github.com/TokenJan)

# 动态规划算法的实际应用：接缝裁剪

我们一直认为动态规划（dynamic programming）是一个在学校里学习的技术，并且只是用来通过软件公司的面试。实际上，这是因为大多数的开发者不会经常处理需要用到动态规划的问题。本质上，**动态规划可以高效求解那些可以分解为高度重复子问题的问题**，因此在很多场景下是很有用的。

在这篇文章中，我将会仔细分析动态规划的一个有趣的实际应用：接缝裁剪（seam carving）。[Avidan 和 Shamir 的这篇文章 **Seam Carving for Content-Aware Image Resizing**](https://dl.acm.org/citation.cfm?id=1276390) 中详细讨论了这个问题以及提出的技术（搜索文章的标题可以免费获取）。

这篇文章是动态规划的系列文章中的一篇。如果你还不了解动态规划技术，请参阅我写的[动态规划的图形化介绍](https://medium.com/future-vision/a-graphical-introduction-to-dynamic-programming-2e981fa7ca2?source=friends_link&sk=37cd14642cf1a83eb0bb33d231442837)。

**（由于 Medium 不支持数学公式渲染，我是用图片来显示复杂的公式的。如果访问图片有困难，可以看[我个人网站上的文章](https://avikdas.com/2019/05/14/real-world-dynamic-programming-seam-carving.html)。）**

## 环境敏感的图片大小调整

为了用动态规划解决实际问题，我们需要将问题建模为可以应用动态规划的形式。本节介绍了这个问题的必要的准备工作。

论文的原作者介绍了一种在智能考虑图片内容的情况下改变图片的宽度或高度的方法，叫做环境敏感的图片大小调整（content-aware image resizing）。后面会介绍论文的细节，但这里先做一个概述。假设你想调整下面这个冲浪者图片的大小。

![一个冲浪者在平静的海面中间清晰可见的俯视图，右边是身后汹涌的海浪。图片来自 [Pixabay](https://pixabay.com/photos/blue-beach-surf-travel-surfer-4145659/) 上的 [Kiril Dobrev](https://pixabay.com/users/kirildobrev-12266114/)。](https://cdn-images-1.medium.com/max/3840/1*l5kxItyahSyLKZl0_GQ6qA.jpeg)
（一个冲浪者在平静的海面中间清晰可见的俯视图，右边是身后汹涌的海浪。图片来自 [Pixabay](https://pixabay.com/photos/blue-beach-surf-travel-surfer-4145659/) 上的 [Kiril Dobrev](https://pixabay.com/users/kirildobrev-12266114/)。）

论文中详细讨论了，有多种方法可以减少图片的宽度。我们最先想到的是裁剪和缩放，以及它们相关的缺点。删除图片中部的几列像素也是一种方法，但你也可以想象得到，这样会在图片中留下一条可见的分割线，左右的内容无法对齐。而且即使是这些方法全用上了，也只能删掉这么点图片：

![尝试通过裁掉图片的左侧和中间部分来减少图片宽度。裁掉中间会在图片中留下一条可见的分割线。](https://cdn-images-1.medium.com/max/2192/1*4u6De8aVDdUjSeMBD3ycMg.jpeg)
（尝试通过裁掉图片的左侧和中间部分来减少图片宽度。裁掉中间会在图片中留下一条可见的分割线。）

Avidan 和 Shamir 在他们的论文中展示的是一个叫做**接缝裁剪**的技术。它首先会识别出图片中不太有意义的“低能量”区域，然后找到穿过图片的能量最低的“接缝”。对于减少图片宽度的情况，接缝裁剪会找到一个竖向的、从图片顶部延伸到底部、下一行最多向左或向右移动一个像素的接缝。

在冲浪者的图片中，能量最低的接缝穿过图片中部水面最平静的位置。这和我们的直觉相符。

![冲浪者图片中发现的最低能量接缝。接缝通过一条五个像素宽的红线来可视化，实际上接缝只有一个像素宽。](https://cdn-images-1.medium.com/max/3840/1*QbiqbZ1Yfh7ePAKi5RXVoA.jpeg)
（冲浪者图片中发现的最低能量接缝。接缝通过一条五个像素宽的红线来可视化，实际上接缝只有一个像素宽。）

通过识别出能量最低的接缝并删除它，我们可以把图片的宽度减少一个像素。不断重复这个过程可以充分减少图片的宽度。

![宽度减少了 1024 像素后的冲浪者图片。](https://cdn-images-1.medium.com/max/2000/1*ALzlMevVbjNyjxLQ0xA9qQ.jpeg)
（宽度减少了 1024 像素后的冲浪者图片。）

这个算法删除了图片中间的静止水面，以及图片左侧的水面，这仍然符合我们的直觉。和直接剪裁图片不同的是，左侧水面的质地得以保留，也没有突兀的过渡。图片的中间确实有一些不是很完美的过渡，但大部分的结果看起来很自然。

#### 定义图片的能量

这个算法的关键在于找到能量最低的接缝。要做到这一点，我们首先定义图片中每个像素的能量，然后应用动态规划算法来寻找穿过图片的能量最低的路径。下一节中会详细讨论这个算法。让我们先看看如何为图片中的像素定义能量。

论文中讨论了一些不同的能量函数，以及它们在调整图片大小时的效果。简单起见，我们使用一个简单的能量函数，表达图片中的颜色在每个像素周围的变化强烈程度。为了完整起见，我会将能量函数介绍得详细一点，以备你想自己实现它，但这部分的计算仅仅是为后续动态规划作准备。

![左半边表示，当相邻像素的颜色非常不同时这个像素的能量大。右半边表示，当相邻像素的颜色比较相似时像素的能量小。](https://cdn-images-1.medium.com/max/3200/1*vuWMmjn1fU1UiwIK5-BG4A.png)
（左半边表示，当相邻像素的颜色非常不同时这个像素的能量大。右半边表示，当相邻像素的颜色比较相似时像素的能量小。）

为了计算单个像素的能量，我们检查这个像素左右的像素。我们计算逐个分量之间的平方距离，也就是分别计算红色、绿色、蓝色分量之间的平方距离，然后相加。我们对中心像素上下的像素进行同样的计算。最终，我们将水平和垂直距离相加。

![](https://cdn-images-1.medium.com/max/3830/1*nY7Mr6ORKxaA8bRDvJnuEg.png)

唯一的特殊情况是当像素位于边缘，例如左侧边缘时，它的左边没有像素。对于这种情况，我们只需比较将其和右边的像素比较。对于上边缘、右边缘、下边缘的像素，会进行类似的调整。

当周围像素的颜色非常不同时，能量函数较大；而当颜色相似时，能量函数较小。

![冲浪者图片中每个像素的能量，用白色显示高能量像素、黑色显示低能量像素来可视化。不出所料，中间的冲浪者和右侧的湍流的能量最高。](https://cdn-images-1.medium.com/max/3840/1*YqJww3Sv6YyZUUSUlqdQQQ.jpeg)
（冲浪者图片中每个像素的能量，用白色显示高能量像素、黑色显示低能量像素来可视化。不出所料，中间的冲浪者和右侧的湍流的能量最高。）

这个能量函数在冲浪者图片上效果很好。然而，能量函数的值域很广，当对能量进行可视化时，图片中的大部分像素看起来能量为零。实际上，这些区域的能量只是相对于能量最高的区域比较低，但并不是零。为了让能量函数更容易可视化，我放大了冲浪者，并调亮了该区域。

## 使用动态规划搜索低能量接缝

为每个像素计算出了能量之后，我们现在可以搜索从图片顶部延伸到底部的低能量接缝了。同样的分析方法也适用于从左侧延伸至右侧的水平接缝，可以让我们减少原始图片的高度。不过，我们现在只关注垂直的接缝。

我们先定义最低能量接缝的概念：

* 接缝是像素的序列，其中每行有且仅有一个像素。要求对于连续的两行，**x** 坐标的变化最多为 1，这保证了这是一条相连的接缝。
* 最低能量接缝是指接缝中所有像素的能量总和最小的一条接缝。

注意，最低能量接缝不一定会经过图片中的最低能量像素。是让接缝的能量总和最小，而不是让单个像素的能量最小。

![贪心的方法行不通。过早选择了低能量像素后，我们陷入了图片的高能量区域，如图中红色路径所示。](https://cdn-images-1.medium.com/max/3200/1*Pr-dzYvgZ6x_Wtq_sb6o6A.png)
（贪心的方法行不通。过早选择了低能量像素后，我们陷入了图片的高能量区域，如图中红色路径所示。）

从上图中可以看到，“从最顶行开始，依次选择下一行中的最低能量像素”的贪心方法是行不通的。在选择了能量为 2 的像素之后，我们被迫走入了图片中的一个高能量区域。而如果我们在中间一行选择一个能量相对高一点的像素，我们还有可能进入左下的低能量区域。

#### 将问题分解为子问题

上述的贪心方法的问题在于，当决定如何延伸接缝时，我们没有考虑到未来的接缝剩余部分。我们无法预知未来，但我们可以记录下目前所有已知的信息，从而可以观察过去。

让我们反过来进行选择。**我们不再从多个像素中选择一个来延伸单个接缝，而是从多个接缝中选择一个来连接单个像素。** 我们要做的是，对于每个像素，在上一行可以连接的像素中进行选择。如果上一行中的每个像素都编码了到那个像素为止的路径，我们本质上就观察了那个像素之前的所有历史。

![对每个像素，我们查看上一行中的三个像素。本质的问题是，我们应当延伸哪个接缝？](https://cdn-images-1.medium.com/max/3200/1*7-OeyDR3oqQQ57QhS--Tdw.png)
（对每个像素，我们查看上一行中的三个像素。本质的问题是，我们应当延伸哪个接缝？）

这表明了可以对图片中的每个像素划分子问题。因为子问题需要记录到那个像素的最优路径，比较好的方法是将每个像素的子问题定义为**以那个像素结尾**的最低能量接缝的能量。

和贪心的方法不同，上述方法本质上尝试了图片中的所有路径。只不过，当尝试所有可能的路径时，在一遍又一遍地解决相同的子问题，让动态规划成为这个方法的一个完美的选择。

#### 定义递归关系

与往常一样，我们现在需要将上述的思路形式化为一个递归关系。子问题是关于原图片中的每一个像素的，因此递归关系的输入可以简单的是那个像素的 **x** 和 **y** 坐标。这可以使输入是简单的整数、使子问题的排序变得容易，也使我们可以用一个二维数组存储计算过的值。

我们定义函数 **M**(**x**,**y**) 表示从图片顶部开始、到像素 (**x**,**y**) 结束的最低能量的垂直接缝。使用字母 **M** 是因为论文里就是这么定义的。

首先，我们定义基本情况（base case）。在图片的最顶行，所有以这些像素结尾的接缝都只有一个像素长，因为再往上没有其他像素了。因此，以这些像素结尾的最低能量接缝就是这些像素的能量：

![](https://cdn-images-1.medium.com/max/3830/1*FPze0RcNtZXJsljKvnSlMw.png)

对于其他的所有像素，我们需要查看上一行的像素。由于接缝需要是相连的，我们的候选只有左上方、上方、右上方三个最近的像素。我们要选取以这些像素结尾的接缝中能量最低的那个，然后加上当前像素的能量：

![](https://cdn-images-1.medium.com/max/3830/1*28R18yXrO6dHzXK67vHfsQ.png)

我们需要考虑所查看的像素位于图片的左边缘或右边缘时的边界情况。对于左、右边缘处的像素，我们分别忽略 **M**(**x**−1,**y**−1) 或者 **M**(**x**+1,**y**−1)。

最终，我们需要取得竖向延伸了整个图片的最低能量接缝的能量。这意味着查看图片的最底行，选择以这些像素中的一个结尾的最低能量接缝。设图片宽 **W** 个像素，高 **H** 个像素，我们要的是：

![](https://cdn-images-1.medium.com/max/3830/1*k54P1LyRS0A3_PKS64-VYA.png)

有了这个定义，我们就得到了一个递归关系，包括我们所需的所有性质：

* 递归关系的输入为整数。
* 我们所需的最终结果易于从递归关系中提取。
* 这个关系只依赖于自身。

#### 检查子问题的 DAG（有向无环图）

由于每个子问题 **M**(**x**,**y**) 对应于原图片中的单个像素，子问题的依赖图非常容易可视化，只需将子问题放在二维网格中，就像在原图片中的排列一样！

![子问题放置在二维网格中，就像在原图片中的排列一样。](https://cdn-images-1.medium.com/max/3840/1*JPKnnP-n1cbx-EvE_3nVvA.png)
（子问题放置在二维网格中，就像在原图片中的排列一样。）

如递归关系的基本情况（base case）所示，最顶行的子问题对应于图片的最顶行，可以简单地用单个像素的能量值初始化。

![子问题的第一行不依赖于任何其他子问题。注意最顶行的单元没有出来的箭头。](https://cdn-images-1.medium.com/max/3840/1*Mj3d7iUr122uwTki_S3kPg.png)
（子问题的第一行不依赖于任何其他子问题。注意最顶行的单元没有出来的箭头。）

从第二行开始，依赖关系开始出现。首先，在第二行的最左单元，我们遇到了一个边界情况。由于左侧没有其他单元，标记为 (0,1) 的单元只依赖于上方和右上方最近的单元。对于第三行最左侧的单元来说也是同样的情况。

![左边缘处的子问题只依赖于上方的两个子问题。](https://cdn-images-1.medium.com/max/3840/1*lGH6Ic4lCVsdlg86TozL9g.png)
（左边缘处的子问题只依赖于上方的两个子问题。）

再看第二行的第二个单元，标记为 (1,1) 的单元。这是递归关系的一个最典型的展示。这个单元依赖于左上、上方、右上最近的三个单元。这种依赖结构适用于第二行及以后的所有“中间”的单元。

![左右边缘之间的子问题依赖于上方的三个子问题。](https://cdn-images-1.medium.com/max/3840/1*ZIH4y9rwjDBKq0V-pCtSDQ.png)
（左右边缘之间的子问题依赖于上方的三个子问题。）

第二行的最后，右边缘处表示了第二个边界情况。因为右侧没有其他单元，这个单元只依赖于上方和左上最近的单元。

![右边缘处的子问题只依赖于上方的两个子问题。](https://cdn-images-1.medium.com/max/3840/1*SoOOVR2-OFmXTm_VwTIE0A.png)
（右边缘处的子问题只依赖于上方的两个子问题。）

最后，对所有后续行重复这个过程。

![因为依赖于包含了太多的箭头，这里的动画逐个显示了每个子问题的依赖。](https://cdn-images-1.medium.com/max/3840/1*_iQtNQiZlOGZwQKPs4VU8A.gif)
（因为依赖于包含了太多的箭头，这里的动画逐个显示了每个子问题的依赖。）

由于完整的依赖图箭头数量极多，令人生畏，逐个地观察每个子问题能让我们建立直观的依赖模式。

#### 自底向上的实现

从上述分析中，我们可以得到子问题的顺序：

* 从图片的顶部到底部。
* 对于每一行，可以以任意顺序。自然的顺序是从左至右。

因为每一行只依赖于前一行，所以我们只需要维护两行的数据：前一行和当前行。实际上，如果从左至右计算，我们实际上可以丢弃前一行使用过的一些元素。不过，这会让算法更复杂，因为我们需要弄清楚前一行的哪部分可以丢弃，以及如何丢弃。

在下面的 Python 代码中，输入是行的列表，其中每行是数字的列表，表示这一行中每个像素的能量。输入命名为  `pixel_energies`，而 `pixel_energies[y][x]` 表示位于坐标 (**x**,**y**) 处像素的能量。

首先计算最顶行的接缝的能量，只需拷贝最顶行的单个像素的能量：

```Python
previous_seam_energies_row = list(pixel_energies[0])
```

接着，循环遍历输入的其余行，计算每行的接缝能量。最棘手的部分是确定引用前一行中的哪些元素，因为左边缘像素的左侧和右边缘像素的右侧是没有像素的。

在每次循环中，会为当前行创建一个新的接缝能量的列表。每次循环结束时，将前一行的数据替换为当前行的数据，供下一轮循环使用。这样我们就丢弃了前一行。

```Python
# 在循环中跳过第一行
for y in range(1, len(pixel_energies)):
    pixel_energies_row = pixel_energies[y]

    seam_energies_row = []
    for x, pixel_energy in enumerate(pixel_energies_row):
        # 判断要在前一行中遍历的 x 值的范围。这个范围取决于当前像素是在图片
        # 的中间还是边缘。
        x_left = max(x - 1, 0)
        x_right = min(x + 1, len(pixel_energies_row) - 1)
        x_range = range(x_left, x_right + 1)

        min_seam_energy = pixel_energy + \
            min(previous_seam_energies_row[x_i] for x_i in x_range)
        seam_energies_row.append(min_seam_energy)

    previous_seam_energies_row = seam_energies_row
```

最终， `previous_seam_energies_row` 包含了最底行的接缝能量。取出这个列表中的最小值，这就是答案！

```Python
min(seam_energy for seam_energy in previous_seam_energies_row)
```

你可以测试这个实现：把它包装在一个函数中，然后创建一个二维数组作为输入调用这个函数。下面的输入数据会让贪心算法失败，但同时也有明显可见的最低能量接缝：

```Python
ENERGIES = [
    [9, 9, 0, 9, 9],
    [9, 1, 9, 8, 9],
    [9, 9, 9, 9, 0],
    [9, 9, 9, 0, 9],
]

print(min_seam_energy(ENERGIES))
```

#### 时间和空间复杂度

对于原图片中的每一个像素，都有一个对应的子问题。每个子问题最多有 3 个依赖，所以解决每个子问题的工作量是常数。最后，我们需要再遍历最后一行一遍。那么，如果图片宽 **W** 像素，高 **H** 像素，时间复杂度是 **O**(**W**×**H**+**W**)。

在任意时刻，我们持有两个列表，分别存储前一行和当前行。前一行的列表共有 **W** 个元素，而当前行的列表不断增长，最多有 **W** 个元素。那么，空间复杂度是 **O**(2**W**)，也就是 **O**(**W**)。

注意到，如果我们真的从前一行的数据中丢弃一部分元素，我们可以在当前行的列表增长的同时缩减前一行的列表。不过，空间复杂度仍旧是 **O**(**W**)。取决于图片的宽度，常量系数可能会有一点影响，但通常不会有什么大的影响。

## 用于寻找最低能量接缝的后向指针

现在我们找到了最低能量垂直接缝的能量，那么如何利用这个信息呢？事实上我们并不关心接缝的能量，而是接缝本身！问题是，从接缝的最后一个像素，我们无法回溯到接缝的其余部分。

这是我在文章前面的内容中跳过的部分，但很多动态规划的问题也有相似的考虑。例如，如果你还记得[盗贼问题](https://medium.com/future-vision/a-graphical-introduction-to-dynamic-programming-2e981fa7ca2?source=friends_link&sk=37cd14642cf1a83eb0bb33d231442837#25bc)，我们可以知道盗窃的数值并提取出最大值，但我们不知道哪些房子产出了那个总和的值。

#### 表示后向指针

解决方法是通用的：存储**后向指针**。在接缝裁剪的问题中，我们不仅需要每个像素处的接缝能量值，还想要知道前一行的哪个像素得到了这个能量。通过存储这个信息，我们可以沿着这些指针一路到达图片的顶部，得到组成了最低能量接缝的像素。

首先，我们创建一个类来存储一个像素的能量和后向指针。能量值会用来计算子问题。因为后向指针只是记录了前一行的哪个像素产生了当前的能量，我们可以只用 x 坐标来表示这个指针。

```Python
class SeamEnergyWithBackPointer():
    def __init__(self, energy, x_coordinate_in_previous_row=None):
        self.energy = energy
        self.x_coordinate_in_previous_row = \
            x_coordinate_in_previous_row
```

每个子问题将会是这个类的一个实例，而不再只是一个数字。

#### 存储后向指针

在最后，我们需要回溯整个图片的高度，沿着后向指针重建最低能量的接缝。不幸的是，这意味着我们需要存储图片中**所有的**像素，而不仅是前一行。

为了实现这一点，我们将保留所有子问题的全部结果，即使可以丢弃前面行的接缝能量数值。我们可以用像输入的数组一样的二维数组来存储这些结果。

让我们从第一行开始，这一行只包含单个像素的能量。由于没有前一行，所有的后向指针都是 `None`。但是为了一致性，我们还是会存储 `SeamEnergyWithBackPointer` 的实例：

```Python
seam_energies = []

# 拷贝最顶行的像素能量来初始化最顶行的接缝能量。最顶行没有后向指针。
seam_energies.append([
    SeamEnergyWithBackPointer(pixel_energy)
    for pixel_energy in pixel_energies[0]
])
```

主循环的工作方式几乎和先前的实现相同，除了以下几点区别：

* 前一行的数据包含的是 `SeamEnergyWithBackPointer` 的实例，所以当计算递归关系的值时，我们需要在这些对象内部查找接缝能量。
* 当为当前像素存储数据时，我们需要创建一个新的 `SeamEnergyWithBackPointer` 实例。在这个实例中我们既存储当前像素的接缝能量，又存储用于计算当前接缝能量的前一行的 x 坐标。
* 在每一行计算结束后，不会丢弃前一行的数据，而是简单地将当前行的数据追加到 `seam_energies` 中。

```Python
# 在循环中跳过第一行
for y in range(1, len(pixel_energies)):
    pixel_energies_row = pixel_energies[y]

    seam_energies_row = []
    for x, pixel_energy in enumerate(pixel_energies_row):
        # 判断要在前一行中遍历的 x 值的范围。这个范围取决于当前像素是在图片
        # 的中间还是边缘。
        x_left = max(x - 1, 0)
        x_right = min(x + 1, len(pixel_energies_row) - 1)
        x_range = range(x_left, x_right + 1)

        min_parent_x = min(
            x_range,
            key=lambda x_i: seam_energies[y - 1][x_i].energy
        )

        min_seam_energy = SeamEnergyWithBackPointer(
            pixel_energy + seam_energies[y - 1][min_parent_x].energy,
            min_parent_x
        )

        seam_energies_row.append(min_seam_energy)

    seam_energies.append(seam_energies_row)
```

#### 沿着后向指针前进

当全部的子问题表格都填满后，我们就可以重建最低能量的接缝。首先找到最底行对应于最低能量接缝的 x 坐标：

```Python
# 找到最底行接缝能量最低的 x 坐标
min_seam_end_x = min(
    range(len(seam_energies[-1])),
    key=lambda x: seam_energies[-1][x].energy
)
```

然后，从图片的底部走向顶部，**y** 坐标从 `len(seam_energies) - 1` 降到 `0`。 在每轮循环中，将当前的 (**x**,**y**) 坐标对添加到表示接缝的列表中，然后将 **x**  的值设为当前行的 `SeamEnergyWithBackPointer` 对象所指向的位置。

```Python
# 沿着后向指针前进，得到一个构成最低能量接缝的坐标列表
seam = []
seam_point_x = min_seam_end_x
for y in range(len(seam_energies) - 1, -1, -1):
    seam.append((seam_point_x, y))

    seam_point_x = \
        seam_energies[y][seam_point_x].x_coordinate_in_previous_row

seam.reverse()
```

这样就自底向上地构建出了接缝，将列表反转就得到了自顶向下的接缝坐标。

## 时间与空间复杂度

时间复杂度和之前相似，因为我们仍然需要将每个像素处理一次。在最后还需要从最后一行中找出最低的接缝能量，然后向上走一个图片的高度来重建接缝。那么，对于 **W**×**H** 的图片，时间复杂度是 **O**(**W**×**H**+**W**+**H**)。

至于空间复杂度，我们仍然为每个子问题存储常量级的数据，但是现在我们不再丢弃任何数据。那么，我们使用了 **O**(**W**×**H**) 的空间。

## 删除低能量的接缝

找到了最低能量的垂直接缝后，我们可以简单地将原图片中的像素复制到新图片中。新图片中的每一行都是原图片中对应行除去最低能量接缝的像素后的剩余像素。因为我们在每一行都删去了一个像素，那么我们可以从一个 **W**×**H** 的图片得到 (**W**−1)×**H** 的图片。

我们可以重复这个过程，在新图片上重新计算能量函数，然后找到新图片上的最低能量接缝。你可能很想在原图片上找到不止一个低能量的接缝，然后一次性把它们都删除。但问题是两个接缝可能相关交叉，在中间共享同一个像素。在第一个接缝删掉之后，第二个接缝就会由于缺少了一个像素而不再有效。

上述视频展示了应用于冲浪者图片上的接缝删除过程（视频链接[在此](https://youtu.be/B9HPREBePI4)——译者注）。我是通过获取每次迭代的图片，然后在上面添加最低能量接缝的可视化线条来制作的这个视频。

## 另一个例子

已经有很多深入的讲解了，那让我们以一些漂亮的照片结束吧！请看下面的在拱门国家公园的岩层的照片：

![拱门国家公园中间的一个有孔的岩层。图片来自 [Flickr](https://flic.kr/p/4hxxz5) 上的 [Mike Goad](https://www.flickr.com/photos/exit78/)。](https://cdn-images-1.medium.com/max/3840/1*fulHRJumsSBLajwXuERliw.jpeg)
（拱门国家公园中间的一个有孔的岩层。图片来自 [Flickr](https://flic.kr/p/4hxxz5) 上的 [Mike Goad](https://www.flickr.com/photos/exit78/)。）

这个图片的能量函数：

![拱门图片中每个像素的能量，用白色显示高能量像素、黑色显示低能量像素来可视化。注意岩层孔洞边缘旁的高能量。](https://cdn-images-1.medium.com/max/3840/1*myqk6PT0xzYnahsMUO6Umw.jpeg)
（拱门图片中每个像素的能量，用白色显示高能量像素、黑色显示低能量像素来可视化。注意岩层孔洞边缘旁的高能量。）

这产生了下面的最低能量接缝。注意到这个接缝穿过了右侧的岩石，正好从岩石顶部被照亮与天空颜色一致的部分进入。或许我们需要选择一个更好的能量函数！

![拱门图片中的最低能量接缝。接缝通过一条五个像素宽的红线来可视化，实际上接缝只有一个像素宽。](https://cdn-images-1.medium.com/max/3840/1*o7kKlDVqEARKy0WVCvfY3g.jpeg)
（拱门图片中的最低能量接缝。接缝通过一条五个像素宽的红线来可视化，实际上接缝只有一个像素宽。）

最终，调整拱门图片的大小之后：

![宽度减少了 1024 像素后的拱门图片。](https://cdn-images-1.medium.com/max/2000/1*gzFmeWjjbgv8gNLSFHcjeQ.jpeg)
（宽度减少了 1024 像素后的拱门图片。）

这个结果肯定不太完美，原图片中的很多边缘在调整大小后的图片中都有些变形。一种可能的改进是实现另一个论文中讨论的能量函数。

---

动态规划虽然常常只在教学中遇到，但它还是解决实际的复杂问题的有用技术。在本文中，我们讨论了动态规划的一个应用：使用接缝裁剪实现环境敏感的图片大小调整。

我们应用了相同的原理，将问题分解为子问题，分析子问题之间的依赖关系，然后以时间、空间复杂度最小的顺序求解。另外，我们还探索了通过后向指针，除了计算最小的数值，还能找到产生这个数值的特定选择。然后将这部分内容应用到实际的问题上，对问题进行预处理和后处理，让动态规划算法真正有用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
