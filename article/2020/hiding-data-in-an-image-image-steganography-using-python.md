> * 原文地址：[Hiding data in an image : Image Steganography using Python](https://towardsdatascience.com/hiding-data-in-an-image-image-steganography-using-python-e491b68b1372)
> * 原文作者：[Rupali Roy](https://medium.com/@rupali.roy30)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/hiding-data-in-an-image-image-steganography-using-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/hiding-data-in-an-image-image-steganography-using-python.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[江不知](https://github.com/JalanJiang)，[Baddyo](https://github.com/Baddyo)

# 在图像中隐藏数据：用 Python 来实现图像隐写术

![图片来自[马萨诸塞大学安姆斯特分校博客](https://blogs.umass.edu/Techbytes/2018/10/30/hiding-in-plain-sight-with-steganography/)的文章](https://cdn-images-1.medium.com/max/2692/1*XVhiMOhxBKmqHzMslQrwaw.png)

## 用 Python 来实现图像隐写术

> 如今，世界正在经历一场前所未有的数据爆炸。我们每天产生着的令人难以置信的数据量。《福布斯》文章**“我们每天创造了多少数据？”**中指出，按照我们目前的速度，每天大约创造了 [2.5 亿字节的数据](https://www.domo.com/learn/data-never-sleeps-5?aid=ogsm072517_1&sf100871281=1)，但是这种速度会随着物联网（IoT）的增长而加速。仅在过去的两年中，我们就产生了全球 90％ 的数据。这篇文章反应的数据爆炸现象需要引起我们的重视！

数据。本质上，现代计算机世界就是围绕着这个词展开的。但它到底有什么魅力使我们如此着迷呢？在当今世界，很多企业已经开始意识到数据的强大力量，因为它可以潜在地预测客户趋势，增加销售并将公司规模推向更高的高度。随着技术的快速进步和数据使用方式的不断创新，确保数据安全已成为我们的重中之重。数据共享越来越多，因为每天都有成千上万的信息和数据在互联网上从一个地方传送到另一个地方。数据的保护是发送方最关心的问题，以一种只有接收方能够理解的加密方式加密我们的消息是非常重要的。

在本文中，我们将了解什么是最低有效位隐写术以及如何用 Python 来实现它。

## 什么是“隐写术”？

隐写术是将机密信息隐藏在更大的信息中，使别人无法知道隐藏信息的存在以及隐藏信息内容的过程。隐写术的目的是保证双方之间的机密交流。与隐藏机密信息内容的密码学不同，隐写术隐瞒了传达消息的事实。尽管隐写术与密码学有所不同，但是两者之间有许多类似，并且一些作者会将隐写术归类为一种密码学形式，因为隐秘通信也是一种机密消息。

## 使用隐写术比使用密码学加密有什么优势？

迄今为止，密码学一直是作用于保护发送者与接收者之间的保密性。然而，现在除了密码学之外，隐写术也越来越多地用于为需要被隐藏的数据添加更多保护层。使用隐写术比单独使用[密码学](https://zh.wikipedia.org/wiki/密码学)的优势在于，有意加密的消息不会作为被监视的对象而引起注意。明显可见的加密消息，无论其多么难以解破，都会引起人们的注意。并且在[加密](https://zh.wikipedia.org/wiki/加密)是非法行为的国家中，这本身可能就是在犯罪。<sup><a href="#note1">[1]</a></sup>

## 隐写术的分类

隐写术目前已经可以在图像、视频、文本或音频等多种传输媒介上进行。

![图片来自文章作者](https://cdn-images-1.medium.com/max/2000/0*0PvWnJdRtDMkh8JS)

## 基本的隐写术的分类模型

![来自 Edureka [隐写术](https://www.edureka.co/blog/steganography-tutorial)教程截图](https://cdn-images-1.medium.com/max/2000/0*fwfkaK09mCKlWrJc)

如上图所示，原始图像文件（X）和机密消息（M）都作为入参传入到隐写术编码器中。隐写术编码器函数 f(X,M,K) 通过使用最低有效位编码等技术将机密消息写入到封面图像文件中。最后生成的隐写术图像看起来与封面图像文件非常相似，肉眼难辨。这样就完成了编码。若要取出机密消息，将之前生成的隐写术图像输入隐写术解码器即可。<sup><a href="#note1">[3]</a></sup>

本文将使用 Python 来实现图像隐写术。手把手教您使用 Python 语言，通过一种叫“[最低有效位（Least Significant Bit，LSB）]((https://www.sciencedirect.com/topics/computer-science/least-significant-bit))”的技术来隐藏文本消息。

## 最低有效位隐写术

我们可以将**数字图像**描述为一组有限的数字值，称为像素。像素是图像中最小的不可分割单位，其值表示在任何特定点上给定颜色的亮度。因此，我们可以将图像想象为像素的矩阵（或二维数组），其中包含固定数量的行和列。

最低有效位（LSB）是一种将每个像素的最后一位修改并用机密消息的数据位代替的技术。

![图片来自 Edureka [隐写术](https://www.edureka.co/blog/steganography-tutorial) 教程](https://cdn-images-1.medium.com/max/2000/0*yARnljvGACzlItk-)

![图片来自 Edureka [隐写术](https://www.edureka.co/blog/steganography-tutorial)教程](https://cdn-images-1.medium.com/max/2000/0*z2XIiLwo7ZKGsWhw)

从上图可以清楚地看出，如果我们修改最高有效位（MSB），它将对最终值产生更大的影响，但是如果我们修改最低有效位（LSB），则对最终值的影响将是最小的，因此，我们使用最低有效位隐写术。

#### 最低有效位是如何工作的？

每个像素包含三个值，红、绿、蓝，这些值的范围从 0 到 255，换句话说，它们是一个 8 位二进制数<sup><a href="#note1">[4]</a></sup>。让我们举一个例子来说明它是如何工作的，假设您想要将消息 “**hi**” 隐藏到一个 **4x4** 的图像中，该图像具有以下像素值：

**[(225, 12, 99), (155, 2, 50), (99, 51, 15), (15, 55, 22),(155, 61, 87), (63, 30, 17), (1, 55, 19), (99, 81, 66),(219, 77, 91), (69, 39, 50), (18, 200, 33), (25, 54, 190)]**

使用 [ASCII 表](http://www.asciitable.com/)，我们可以先将机密消息转换为十进制值，然后再转换为二进制：**0110100 0110101**。现在，我们对像素值逐一进行迭代，在将它们转换为二进制后，我们将每个最小有效位依次替换为该信息位。（例如 225 是 11100001，我们替换最后一位，最右边的（1）和机密消息的第一位（0），依次类推)。这样的操作只会对像素值进行 +1 或 -1 的修改，因此肉眼根本看不出来。执行最低有效位隐写术后得到的像素值如下所示：

**[(224, 13, 99),(154, 3, 50),(98, 50, 15),(15, 54, 23),(154, 61, 87),(63, 30, 17),(1, 55, 19),(99, 81, 66),(219, 77, 91),(69, 39, 50),(18, 200, 33),(25, 54, 190)]**

## 使用 Python 在图像中隐藏文本

在本节中，我们将使用 Python 代码逐步了解隐藏文本和显示文本的过程。首先，打开 [google collab notebook](https://colab.research.google.com/notebooks/intro.ipynb)，按照下面的步骤操作：

在开始编写代码之前，可以使用左侧菜单栏中的 upload 选项上传要用于隐写的图像（png 文件）。

![图片来自文章作者](https://cdn-images-1.medium.com/max/3200/0*u4pEeA_Tn_DabtLw)

**第一步：** 导入所有必需的 Python 库。

![](https://cdn-images-1.medium.com/max/2164/0*x6ZXcEMtaIVBxVnb)

**第二步：** 定义一个可以将任何类型的数据转换为二进制数据的函数，我们将在编码和解码阶段使用这个函数来将机密消息数据和像素值转换为二进制。

![](https://cdn-images-1.medium.com/max/2000/0*zbUTZXC8YJtG03Xj)

**第三步：** 编写一个函数，通过改变最低有效位将机密消息隐藏到图像中。

![](https://cdn-images-1.medium.com/max/2396/0*q_WPjVi7d8wkUv7q)

![](https://cdn-images-1.medium.com/max/2000/0*A4bFf0fgsbL0rgE7)

**第四步：** 定义一个函数，用于从隐藏后的图像中解码隐藏信息。

![](https://cdn-images-1.medium.com/max/2498/0*qEpT5_0vFVIheamk)

**第五步：** 定义将输入的图像名称和机密消息作为用户的输入的函数。

![](https://cdn-images-1.medium.com/max/2912/0*H7imEfeyiFbx0T7i)

**第六步：** 创建一个函数，要求用户输入需要解码的图像的名称，然后调用 showData() 函数以返回解码后的消息。

![](https://cdn-images-1.medium.com/max/2740/0*DoZEkmVLp_eo4_4c)

**第七步：** 主函数

![](https://cdn-images-1.medium.com/max/2340/0*G6Z_yK4I9tIzCVOt)

**输出/结果：**

加密消息：

![](https://cdn-images-1.medium.com/max/2000/0*_xinlcljWazWX0DE)

解码消息：

![](https://cdn-images-1.medium.com/max/2060/0*hy8TeB8TMmE68gCN)

如果您对代码感兴趣，可以在 [Github](https://github.com/rroy1212/Image_Steganography/blob/master/ImageSteganography.ipynb) 上查看我的 jupyter notebook 代码。

## 参考资料：

1. <a name="note1"></a> [https://towardsdatascience.com/steganography-hiding-an-image-inside-another-77ca66b2acb1](https://towardsdatascience.com/steganography-hiding-an-image-inside-another-77ca66b2acb1)
2. <a name="note2"></a> [https://www.edureka.co/blog/steganography-tutorial](https://www.edureka.co/blog/steganography-tutorial)
3. <a name="note3"></a> [https://www.forbes.com/sites/bernardmarr/2018/05/21/how-much-data-do-we-create-every-day-the-mind-blowing-stats-everyone-should-read/#191d0b0160ba](https://www.forbes.com/sites/bernardmarr/2018/05/21/how-much-data-do-we-create-every-day-the-mind-blowing-stats-everyone-should-read/#191d0b0160ba)
4. <a name="note4"></a> [https://www.ukessays.com/essays/computer-science/steganography-uses-methods-tools-3250.php](https://www.ukessays.com/essays/computer-science/steganography-uses-methods-tools-3250.php)
5. <a name="note5"></a> [https://www.thepythoncode.com/article/hide-secret-data-in-images-using-steganography-python](https://www.thepythoncode.com/article/hide-secret-data-in-images-using-steganography-python)
6. <a name="note6"></a> [https://www.youtube.com/watch?v=xepNoHgNj0w&t=1922s](https://www.youtube.com/watch?v=xepNoHgNj0w&t=1922s)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
