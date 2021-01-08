> * 原文地址：[How to Generate Random Text CAPTCHAs Using Python](https://medium.com/better-programming/how-to-generate-random-text-captchas-using-python-e734dd2d7a51)
> * 原文作者：[Siddhant Sadangi](https://medium.com/@siddhant.sadangi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-generate-random-text-captchas-using-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-generate-random-text-captchas-using-python.md)
> * 译者：[lhd951220](https://github.com/lhd951220)
> * 校对者：[江不知](http://jalan.space/)，[lihanxiang](https://github.com/lihanxiang)

# 如何使用 Python 生成随机文本验证码 

![Photo by [Massimo Virgilio](https://unsplash.com/@massimovirgilio?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10944/0*QNr379hDEZHrJX3q)

你肯定在网站上碰到过用于验证你是用户还是机器人的[验证码](https://en.wikipedia.org/wiki/CAPTCHA)。验证码起源于[书本数字化](https://www.wikiwand.com/en/ReCAPTCHA#/Origin)的协作平台，现在演变成为一个由大众支持的图像标记项目（在某些情况下，还有音频识别），在这个项目中你甚至不知道你是一个服务提供商，而不是一个用户。

在这篇文章中，我们将会使用 Python 的 [OpenCV](https://opencv.org/) 和 [PIL](https://pillow.readthedocs.io/) 库来学习如何生成我们自己的基本的文本验证码。

让我们现在开始！

## 创建画布

首先，我们需要从 PIL 中引入 `ImageFont`，`ImageDraw` 和 `Image` 模块：

```py
from PIL import ImageFont, ImageDraw, Image
```

现在，我们要创建一个空白图像对象。为了达到这个目的，我们首先需要创建一个三维（对应三个颜色通道）numpy zeros 数组：

```py
import numpy as np
img = np.zeros(shape=(25, 60, 3), dtype=np.uint8)
```

这给了我们一个数组，其中每个元素表示图像中的一个像素，图像的大小为 60 x 25 像素：

```Python
array([[[0, 0, 0],
        [0, 0, 0],
        [0, 0, 0],
        ...,
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]]], dtype=uint8)
```

为了使用这个数组创建一个图像，我们调用 `Image` 的 `fromarray()` 方法：

![](https://cdn-images-1.medium.com/max/2522/1*BBJv6KGRzyBfy8ITO3nD-A.png)

因为每一个像素值都是 `(0, 0, 0)`，所以图像是黑色的，其中每一个值都表示红色，绿色，蓝色像素的亮度。亮度的取值范围为 0（最暗）到 255（最亮）。为了得到白色图像，我们在图像数组加上 255 即可：

![](https://cdn-images-1.medium.com/max/2520/1*lt5j7n4jaY5nKecD-cTLxw.png)

由于我们需要使用白色背景，我们将会使用最后一个画布。

## 添加文本

现在，我们需要在我们的画布上绘制文本。为了达到这个目的，我们使用 `ImageDraw` 的 `Draw()` 函数在我们的画布上创建一个绘制界面。

```py
draw = ImageDraw.Draw(img_pil)
```

然后，我们可以使用 `Draw` 的 `text()` 方法在画布上写文字。`draw` 方法需要以下参数：

* `xy`：使用 (`x`, `y`) 元组指定文本的起始坐标。
* `text`：需要绘制的文本。
* `font`：使用的字体。这是 PIL 使用的 `FreeType` 或者 `OpenType` 字体，这也是 `ImageFont` 应用的地方。
* `fill`：文本填充的颜色，表达式为 `(R, G, B)`。

我们需要为这个函数准备字体对象。我们将会使用 `ImageDraw` 的 `truetype()` 函数：

```py
font = ImageFont.truetype(font = ‘arial’, size=12)
```

我们使用字体名称，但是 `truetype` 也可以使用系统上的字体路径。我们将会在稍后使用它。

现在，我们有了字体，让我们添加文本，然后看下验证码长什么样子：

![](https://cdn-images-1.medium.com/max/2522/1*im3MnJMkuE183-Ny8_0Stg.png)

我们也可以为图像添加线条，以此来迷惑任何尝试进入人类系统的机器。

![](https://cdn-images-1.medium.com/max/2520/1*PipwRd3C_oF06fTID9qGzA.png)

元组指定线条的开始和结束的像素。第一条线条从 `(0, 0)` 开始，在 `(60, 25)` 结束。

使用更好的方式来显示根据数组渲染出来的图像是使用 OpenCV 的 `imshow()` 方法：

```py
import cv2
cv2.imshow(‘OpenCV’,np.array(img_pil))
cv2.waitKey() #等待点击按钮再显示图像
cv2.destroyAllWindows()
```

![](https://cdn-images-1.medium.com/max/2000/1*peKZgKeIKeRgFEbyY6yatA.png)

## 添加噪声

我们基本的验证码现在已经准备好了，但是跟你在网上看到的验证码相比，它很清晰，并且可读性高。让我们添加一些噪声。

添加噪声最简单的方式就是在图像上随机地添加白色和黑色的像素。这被称为盐和胡椒粉噪声。

首先，我们必须根据图像创建一个数组：

```py
img = np.array(img_pil)
```

然后，我定义需要被修改的像素的阈值。我们将它维持在 0.05 (5%)。添加噪声的代码就是使用一个简单的嵌套 for 循环，这个 for 循环随机的生成数字（0 - 1 之间）来决定是否将噪声添加到指定的像素。

```Python
import random
thresh = 0.05

for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        rdn = random.random()
        if rdn < thresh:
            img[i][j] = 0
        elif rdn > 1-thresh:
            img[i][j] = 255
```

在这里，如果随机值小于阈值（0.05），我们将它变为白色。如果它大于 0.95，我们将它变为黑色。除此之外，我们使它保持原样。添加了噪声之后的输出像下面这样：

![Adding salt and pepper noise](https://cdn-images-1.medium.com/max/2000/1*VJ_nzR4t4aghKNSgc2r0dA.png)

胡椒粉噪声（黑色像素）非常的明显，但是一些之前文本上是黑色的像素现在也变为了白色（注意行间的中断）。

我们可以通过模糊图像来添加更多的噪声，这会使噪声扩散开来。使用 cv2，这只需要一行代码！

```py
img_blurred = cv2.blur(img,(2,2))
```

在这里，`(2,2)` 是平滑图像所使用的核心大小。阅读 OpenCV 的[文档](https://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_imgproc/py_filtering/py_filtering.html#averaging)来了解更多相关的知识。

![Blurred image](https://cdn-images-1.medium.com/max/2000/1*pYqGijJa9-nMelu28gGboA.png)

## 一切都随机化！

我们基本的代码已经准备好了......但是还缺少“随机文本验证码”中的“随机”。我们随机化大多数的事物，以此让每一个验证码都是唯一的。

所以，什么是可以被随机化的？好的，全都可以随机化，但我们只会专注于图像大小，文本（字符串，字体，字体大小，颜色），线条颜色，噪声阈值和噪声强度。

图像大小依赖于文本的长度和字体大小。所以我们先创建一个字体大小的变量和一个字符串长度的变量：

```py
size = random.randint(10,16)
length = random.randint(4,8)
```

在对字体大小、字符串长度和画布大小之间的关系进行大量实验之后，我得出的画布的大小如下：

```py
img = np.zeros(((size*2)+5, length*size, 3), np.uint8)
```

现在，为了随机化字体，我们可以使用 [glob](https://docs.python.org/2/library/glob.html) 库从系统字体路径中选择一些。我只使用 Arial 字体的变体。

![](https://cdn-images-1.medium.com/max/2524/1*iflloHcYn-69srcyx0nH9g.png)

然后我们可以通过使用 randint 选择一个随机字体：

```py
fonts[random.randint(0, len(fonts)-1)]
```

现在轮到文本了。我们生成一个给定字符串长度的随机的 ASCII 字母数字字符序列：

```py
text = ''.join(
        random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) 
                   for _ in range(length))
```

因为长度已经是随机的了，我们只需要在调用这个函数的时候传递 `length` 参数：

![](https://cdn-images-1.medium.com/max/2520/1*Tv1zX8_YECcHlI2MtxosWQ.png)

对于文本和线条的颜色，之前我们仅仅使用了黑色（`0, 0, 0`）。这里可以使用 (random.randint(0,255), random.randint(0,255), random.randint(0,255)) 来进行随机化：

```Python
draw.text((5, 10), text, font=font, 
          fill=(random.randint(0,255), random.randint(0,255), random.randint(0,255)))
draw.line([(0, 0),(length*size,(size*2)+5)], width=1, 
          fill=(random.randint(0,255), random.randint(0,255), random.randint(0,255)))
```

对于噪声阈值，我们可以设置它为 1% ~ 5% 之间的任意随机值：

```py
thresh = random.randint(1,5)/100
```

最后，对于噪声强度，我们不再对盐和胡椒粉像素使用绝对的白色和黑色，我们可以分别设置它们为随机的明和暗的阴影。

```Python
for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        rdn = random.random()
        if rdn < thresh:
            img[i][j] = random.randint(0,123) #暗像素
        elif rdn > 1-thresh:
            img[i][j] = random.randint(123,255) #亮像素
```

## 整合

```Python
# 配置画布
size = random.randint(10,16)
length = random.randint(4,8)
img = np.zeros(((size*2)+5, length*size, 3), np.uint8)
img_pil = Image.fromarray(img+255)

# 绘制文本和线条
font = ImageFont.truetype(fonts[random.randint(0, len(fonts)-1)], size)
draw = ImageDraw.Draw(img_pil)
text = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) 
               for _ in range(length))
draw.text((5, 10), text, font=font, 
          fill=(random.randint(0,255), random.randint(0,255), random.randint(0,255)))
draw.line([(0, 0),(length*size,(size*2)+5)], width=1, 
          fill=(random.randint(0,255), random.randint(0,255), random.randint(0,255)))

# 添加噪声和模糊
img = np.array(img_pil)
thresh = random.randint(1,5)/100
for i in range(img.shape[0]):
    for j in range(img.shape[1]):
        rdn = random.random()
        if rdn < thresh:
            img[i][j] = random.randint(0,123)
        elif rdn > 1-thresh:
            img[i][j] = random.randint(123,255)
img = cv2.blur(img,(int(size/5),int(size/5)))

#显示图像
cv2.imshow(f"{text}", img)
cv2.waitKey()
cv2.destroyAllWindows()
```

![cZRaOxb](https://cdn-images-1.medium.com/max/2000/1*2uG3N9uCArPw-QHrgwvn_Q.png)

## 应用领域？

这项技术可以被用于生成验证码。你可以将带有文本的图像保存为要匹配的文件名。另一个新颖的应用是可以生成大量的标签图像来训练你的 OCR 模型。将上面的代码放入循环中，你将获得所需数量的图像！

如果你有更多的应用领域，请让我知晓！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
