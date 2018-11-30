> * 原文地址：[Google Colab Free GPU Tutorial](https://medium.com/deep-learning-turkey/google-colab-free-gpu-tutorial-e113627b9f5d)
> * 原文作者：[fuat](https://medium.com/@fu4t?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/google-colab-free-gpu-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/google-colab-free-gpu-tutorial.md)
> * 译者：[haiyang-tju](https://github.com/haiyang-tju)
> * 校对者：

# Google Colab 免费 GPU 使用教程

现在你可以使用 [Google Colaboratory](https://colab.research.google.com/) （带有**免费的 Tesla K80 GPU**）使用 [Keras](https://keras.io/)、[Tensorflow](https://www.tensorflow.org/) 和 [PyTorch](http://pytorch.org/) 来开发**深度学习**的程序了。

![](https://cdn-images-1.medium.com/max/800/1*Kbta9F_ZiRQmvETa-JkOSA.png)

Hello! I will show you how to use **Google Colab**, _Google’s free cloud service_ for **AI developers**. With Colab, you can develop deep learning applications on the **GPU for free**.大家好！我将向大家展示如何使用 **Google 面向 AI 开发者的免费云服务 —— Google Colab**。在 Colab 上，你可以使用**免费的 GPU** 来开发深度学习应用程序。

### 感谢 KDnuggets！

我很高兴地宣布，这篇博文在 2018 年 2 月被选为 KDnuggets 的银质博文！文章内容可以在 [KDnuggets](https://www.kdnuggets.com/2018/02/google-colab-free-gpu-tutorial-tensorflow-keras-pytorch.html) 看到。

![](https://cdn-images-1.medium.com/max/800/1*qPFwOR1l8DPwXqAcotrWCA.png)

### Google Colab 是什么？

Google Colab 是一个免费的云服务，现在它还支持免费的 GPU！

你可以：

*   提高你的 **Python** 语言的编码技能。
*   使用 **Keras**、**TensorFlow**、**PyTorch** 和 **OpenCV** 等流行库开发深度学习应用程序。

Colab 与其它免费的云服务最重要的区别在于：**Colab** 提供完全免费的 GPU。

关于这项服务的详细信息可以在 [faq](https://research.google.com/colaboratory/faq.html) 页面上找到。

### 准备好使用 Google Colab

#### 在 Google Drive 上创建文件夹

![](https://cdn-images-1.medium.com/max/600/1*9x6GVBOwbAEsx7h8k5ruBw.jpeg)

由于 **Colab** 是在 **Google Drive** 上工作的，所以我们需要首先指定工作文件夹。我在 **Google Drive** 上创建了一个名为 “**app**” 的文件夹。当然，你可以使用不同的名称或选择默认的 **Colab notebook** 文件夹，而不是 **app 文件夹**。

![](https://cdn-images-1.medium.com/max/800/1*vtTvpFVdCcsmEXtQA6k2Kw.png)

**我创建了一个空的 “app” 文件夹**

#### 创建新的 Colab 笔记（Notebook）

通过 **右键点击 > More > Colaboratory** 步骤创建一个新的笔记。

![](https://cdn-images-1.medium.com/max/800/1*7XLisHAnGGnflIYyqQja8Q.jpeg)

**右键点击 > More > Colaboratory**

通过点击文件名来**重命名**笔记

![](https://cdn-images-1.medium.com/max/800/1*emOY5nIyYphREEqo6e86jg.png)

### 设置免费的 GPU

通过很简单的步骤就可以将默认硬件**从 CPU 更改为 GPU，或者反过来**。依照下面的步骤 **Edit > Notebook settings** 或者进入 **Runtime > Change runtime type**，然后选择 **GPU** 作为 **Hardware accelerator（硬件加速器）**。

![](https://cdn-images-1.medium.com/max/800/1*WNovJnpGMOys8Rv7YIsZzA.png)

### 使用 Google Colab 运行基本的 Python 代码

现在我们可以开始使用 **Google Colab** 了。

![](https://cdn-images-1.medium.com/max/800/1*lb2htyPfbC5Y9VF8IZGqdQ.png)

我会运行一些来自于 [Python Numpy 教程](http://cs231n.github.io/python-numpy-tutorial/)中的一些**关于基本数据类型**的代码。

![](https://cdn-images-1.medium.com/max/800/1*02ylPr7JIn_qiJkc4iprpw.png)

可以正常运行！:) 如果你对**在 AI 中最流行的编程语言 Python** 还不是很了解，我推荐你去学习这个简明教程。

### 在 Google Colab 中运行或导入 .py 文件

首先运行这些代码，以便安装一些必要的库并执行授权。

```
from google.colab import drive
drive.mount('/content/drive/')
```

运行上面的代码，会得到如下的结果：

![](https://cdn-images-1.medium.com/max/800/1*4AJ2EEn-xtvGAiwsNlDmNQ.png)

**点击** 这个链接，**复制**验证代码并**粘贴**到下面的文本框中。

完成授权流程后，应该可以看到：

![](https://cdn-images-1.medium.com/max/800/1*SwDEbzteA0EeNDcq8m_tdA.png)

现在可以通过下面的命令访问你的 Google Drive 了：

```
!ls "/content/drive/My Drive/"
```

安装 **Keras**：

```
!pip install -q keras
```

上传文件 [mnist_cnn.py](https://github.com/keras-team/keras/blob/master/examples/mnist_cnn.py) 到你的 **Google Drive** 的 **app** 文件夹中。

![](https://cdn-images-1.medium.com/max/800/1*9y7lbgBmG99ZVkGr5b7arQ.png)

**mnist_cnn.py** 文件内容

运行下面的代码在 [MNIST 数据集](http://yann.lecun.com/exdb/mnist/)上训练一个简单的卷积网络（convnet）。

```
!python3 "/content/drive/My Drive/app/mnist_cnn.py"
```

![](https://cdn-images-1.medium.com/max/2000/1*Mw8_NcnS-a0TyDG9TVHqqg.png)

从结果可以看到，每轮次（epoch）运行只用了 **11 秒**。

### 下载 Titanic 数据集（.csv 文件）并显示文件的前 5 行内容

如果你想从一个 **url** 中下载 **.csv 文件**到 “**app” 文件夹**，只需运行下面的命令：

> !wget [https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/datasets/Titanic.csv](https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/datasets/Titanic.csv) -P "/content/drive/My Drive/app"

不使用 **wget** 方法，你可以直接将自己的 .csv 文件上传到 “app” 文件夹中。

![](https://cdn-images-1.medium.com/max/800/1*gjyZxq2tUORKLi3Fp_-sEg.png)

读取 “**app**” 文件夹中的 **.csv 文件**并显示**前 5 行的内容**：

```
import pandas as pd
titanic = pd.read_csv(“/content/drive/My Drive/app/Titanic.csv”)
titanic.head(5)
```

![](https://cdn-images-1.medium.com/max/800/1*Wx-XLmFKjir-jxcVWp2i9g.png)

### 克隆 GitHub 仓库到 Google Colab

使用 Git 可以很轻松克隆 GitHub 仓库。

#### 步骤 1: 找到 GitHub 仓库并获取 “Git” 链接

找到所需的 GitHub 仓库。

比如： [https://github.com/wxs/keras-mnist-tutorial](https://github.com/wxs/keras-mnist-tutorial)

点击 Clone or download（克隆或下载） > Copy the link（复制链接）！

![](https://cdn-images-1.medium.com/max/1000/1*zyxag4hs2vCY1DejIJveZg.png)

#### 2. 使用 Git 克隆

运行以下命令即可：

> !git clone [https://github.com/wxs/keras-mnist-tutorial.git](https://github.com/wxs/keras-mnist-tutorial.git)

![](https://cdn-images-1.medium.com/max/800/1*I1TO_CtAolkNTPDK-vp4Hg.png)

#### 3. 打开 Google Drive 中对应的文件夹

当然，Google Drive 中对应的文件夹与 GitHub 仓库名是相同的。

![](https://cdn-images-1.medium.com/max/1000/1*jE_CBuejVzTT_3ecSjk86w.png)

#### 4. 打开笔记

右键点击 > Open With > Colaboratory

![](https://cdn-images-1.medium.com/max/1000/1*Sm0CLQDJjX0uJMMjLuuhYA.png)

#### 5. 运行

现在你可以在 Google Colab 中运行 GitHub 仓库代码了。

![](https://cdn-images-1.medium.com/max/800/1*Om46o5HRFOC7RgXaWELV-w.png)

### 一些有用的提示

#### 1. 如何安装第三方库？

**Keras**

```
!pip install -q keras
import keras
```

**PyTorch**

```
from os import path
from wheel.pep425tags import get_abbr_impl, get_impl_ver, get_abi_tag
platform = '{}{}-{}'.format(get_abbr_impl(), get_impl_ver(), get_abi_tag())
accelerator = 'cu80' if path.exists('/opt/bin/nvidia-smi') else 'cpu'
```

> !pip install -q [http://download.pytorch.org/whl/{accelerator}/torch-0.3.0.post4-{platform}-linux_x86_64.whl](http://download.pytorch.org/whl/%7Baccelerator%7D/torch-0.3.0.post4-%7Bplatform%7D-linux_x86_64.whl) torchvision  
import torch

或者试试这个：

`!pip3 install torch torchvision`

**MxNet**

```
!apt install libnvrtc8.0
!pip install mxnet-cu80
import mxnet as mx
```

**OpenCV**

```
!apt-get -qq install -y libsm6 libxext6 && pip install -q -U opencv-python
import cv2
```

**XGBoost**

```
!pip install -q xgboost==0.4a30
import xgboost
```

**GraphViz**

```
!apt-get -qq install -y graphviz && pip install -q pydot
import pydot
```

**7zip 阅读器**

```
!apt-get -qq install -y libarchive-dev && pip install -q -U libarchive
import libarchive
```

**其它库**

`!pip install` or `!apt-get install` to install other libraries.

#### 2. GPU 是否正常工作？

要查看是否在 Colab 中正确使用了 GPU，可以运行下面的代码进行交叉验证：

```
import tensorflow as tf
tf.test.gpu_device_name()
```

![](https://cdn-images-1.medium.com/max/800/1*rHxgzJWoos7f4AYF90PkzQ.jpeg)

#### 3. 我使用的是哪一个 GPU？

```
from tensorflow.python.client import device_lib
device_lib.list_local_devices()
```

目前， **Colab 只提供了 Tesla K80**。

![](https://cdn-images-1.medium.com/max/800/1*D-xR_CzTP3_MMt_8UqIj4Q.png)

#### 4. 输出 RAM 信息？

```
!cat /proc/meminfo
```

![](https://cdn-images-1.medium.com/max/800/1*EPbmqr--SxC0crhMxoaS9Q.png)

#### 5. 输出 CPU 信息？

```
!cat /proc/cpuinfo
```

![](https://cdn-images-1.medium.com/max/1000/1*keRD5wndUyzoxgNUwfWfsQ.png)

#### 6. 改变工作文件夹

一般，当你运行下面的命令：

```
!ls
```

你会看到 **datalab 和 drive** 文件夹。

因此，在定义每一个文件名时，需要在前面添加 **drive/app**。

要解决这个问题，更改工作目录即可。（在本教程中，我将其更改为 **app** 文件夹）可以使用下面的代码：

```
import os
os.chdir("drive/app") 
# 译者注：挂载网盘目录后，前面没有切换过目录，这里应该输入
# os.chdir("drive/My Drive/app")
```

运行上述代码后，如果你再次运行

```
!ls
```

你会看到 **app** 文件夹的内容，不需要再一直添加 **drive/app** 了。

#### 7. “`No backend with GPU available`” 错误解决方案

如果你遇到这个错误：

> Failed to assign a backend
No backend with GPU available. Would you like to use a runtime with no accelerator? #指定后端失败。没有可用的 GPU 后端。需要使用没有加速器的运行时吗？

可以稍后再试一次。有许多人现在都在使用 GPU，当所有 GPU 都在使用时，就会出现这种错误信息。

[参考这里](https://www.kaggle.com/getting-started/47096#post271139)

#### 8. 如何清空所有单元行的运行输出？

可以依次点击 **Tools>>Command Palette>>Clear All Outputs**

#### 9. “apt-key output should not be parsed (stdout is not a terminal)” 警告

如果你遇到这个警告：

```
Warning: apt-key output should not be parsed (stdout is not a terminal) #警告：apt-key 输出无法被解析（当前 stdout 不是终端）
```

这意味着你已经完成了授权。只需要挂载 Google Drive 即可：

```
!mkdir -p drive
!google-drive-ocamlfuse drive
```

#### 10. 如何在 Google Colab 中使用 Tensorboard？

我推荐参考这个仓库代码：

[https://github.com/mixuala/colab_utils](https://github.com/mixuala/colab_utils)

#### 11. 如何重启 Google Colab？

要重启（或重置）你打开的虚拟机器，运行下面的命令即可：

```
!kill -9 -1
```

#### 12. 如何向 Google Colab 中添加表单（Form）？

为了避免每次在代码中更改超参数，你可以简单地向 Google Colab 中添加表单。

![](https://cdn-images-1.medium.com/max/800/1*Cy19qeGZzgllJrtAqOH4OQ.png)

例如，我添加了一个包含有 `**learning_rate（学习率）**` 变量和 `**optimizer（优化器）**` 字符串的表单。

![](https://cdn-images-1.medium.com/max/800/1*kGvfrNrRHwfv1jWtguufkg.png)

#### 13. 如何查看方法的参数？

在 TensorFlow、Keras 等框架中查看方法的参数，可以在方法名称后面**添加问号标识符（?）**即可:

![](https://cdn-images-1.medium.com/max/800/1*cIrmYPaA5HHR1yLj2UPgAQ.png)

这样不需要点击 TensorFlow 的网站就可以看到原始文档。

![](https://cdn-images-1.medium.com/max/800/1*D324zKvU1Ivu-RvKrOG7Ew.png)

#### 14. 如何将大文件从 Colab 发送到 Google Drive？

```
# 需要发送哪个文件？
file_name = "REPO.tar"

from googleapiclient.http import MediaFileUpload
from googleapiclient.discovery import build

auth.authenticate_user()
drive_service = build('drive', 'v3')

def save_file_to_drive(name, path):
  file_metadata = {'name': name, 'mimeType': 'application/octet-stream'}
  media = MediaFileUpload(path, mimetype='application/octet-stream', resumable=True)
  created = drive_service.files().create(body=file_metadata, media_body=media, fields='id').execute()
  
  return created

save_file_to_drive(file_name, file_name)
```

#### 15. 如何在 Google Colab 中运行 Tensorboard？

如果你想在 Google Colab 中运行 Tensorboard，运行下面的代码。

```
# 你可以更改目录名
LOG_DIR = 'tb_logs'

!wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
!unzip ngrok-stable-linux-amd64.zip

import os
if not os.path.exists(LOG_DIR):
  os.makedirs(LOG_DIR)
  
get_ipython().system_raw(
    'tensorboard --logdir {} --host 0.0.0.0 --port 6006 &'
    .format(LOG_DIR))

get_ipython().system_raw('./ngrok http 6006 &')

!curl -s http://localhost:4040/api/tunnels | python3 -c \
    "import sys, json; print(json.load(sys.stdin)['tunnels'][0]['public_url'])"
```

你可以通过创建 **_ngrok.io_** 链接来追踪 **Tensorboard** 日志。你可以在输出的最后找到这个 URL 链接。

注意，你的 **Tensorboard** 日志将保存到 **tb_logs** 目录。当然，你可以更改这个目录名。

![](https://cdn-images-1.medium.com/max/800/1*ICwiBXUgxwq7i6f_zyn-Nw.jpeg)

之后，我们就可以看到 Tensorboard 了！运行下面的代码，可以通过 ngrok URL 链接来追踪 Tensorboard 日志。

```
from __future__ import print_function
import keras
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Conv2D, MaxPooling2D
from keras import backend as K
from keras.callbacks import TensorBoard

batch_size = 128
num_classes = 10
epochs = 12

# 输入图像维度
img_rows, img_cols = 28, 28

# the data, shuffled and split between train and test sets
(x_train, y_train), (x_test, y_test) = mnist.load_data()

if K.image_data_format() == 'channels_first':
    x_train = x_train.reshape(x_train.shape[0], 1, img_rows, img_cols)
    x_test = x_test.reshape(x_test.shape[0], 1, img_rows, img_cols)
    input_shape = (1, img_rows, img_cols)
else:
    x_train = x_train.reshape(x_train.shape[0], img_rows, img_cols, 1)
    x_test = x_test.reshape(x_test.shape[0], img_rows, img_cols, 1)
    input_shape = (img_rows, img_cols, 1)

x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_train /= 255
x_test /= 255
print('x_train shape:', x_train.shape)
print(x_train.shape[0], 'train samples')
print(x_test.shape[0], 'test samples')

# 将类别向量转换成二分类矩阵
y_train = keras.utils.to_categorical(y_train, num_classes)
y_test = keras.utils.to_categorical(y_test, num_classes)

model = Sequential()
model.add(Conv2D(32, kernel_size=(3, 3),
                 activation='relu',
                 input_shape=input_shape))
model.add(Conv2D(64, (3, 3), activation='relu'))
model.add(MaxPooling2D(pool_size=(2, 2)))
model.add(Dropout(0.25))
model.add(Flatten())
model.add(Dense(128, activation='relu'))
model.add(Dropout(0.5))
model.add(Dense(num_classes, activation='softmax'))

model.compile(loss=keras.losses.categorical_crossentropy,
              optimizer=keras.optimizers.Adadelta(),
              metrics=['accuracy'])


tbCallBack = TensorBoard(log_dir=LOG_DIR, 
                         histogram_freq=1,
                         write_graph=True,
                         write_grads=True,
                         batch_size=batch_size,
                         write_images=True)

model.fit(x_train, y_train,
          batch_size=batch_size,
          epochs=epochs,
          verbose=1,
          validation_data=(x_test, y_test),
          callbacks=[tbCallBack])
score = model.evaluate(x_test, y_test, verbose=0)
print('Test loss:', score[0])
print('Test accuracy:', score[1])
```

Tensorboard :)

![](https://cdn-images-1.medium.com/max/800/1*E2UfDvleKBbhydHxMZtQ2g.png)

### 总结

我认为 **Colab** 会给全世界的深度学习和 AI 研究带来新的气息。

如果你发现了这篇文章很有用，如果你能给它一些掌声👏，并与他人分享，这将会非常有意义。欢迎在下面留言。

你可以在 [Twitter](https://twitter.com/fuatbeser) 上找到我。

#### 最后请注意

英文原文会持续跟进更新，如有需要请移步[英文原文](https://medium.com/deep-learning-turkey/google-colab-free-gpu-tutorial-e113627b9f5d)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
