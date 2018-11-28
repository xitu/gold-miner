> * 原文地址：[Google Colab Free GPU Tutorial](https://medium.com/deep-learning-turkey/google-colab-free-gpu-tutorial-e113627b9f5d)
> * 原文作者：[fuat](https://medium.com/@fu4t?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/google-colab-free-gpu-tutorial.md](https://github.com/xitu/gold-miner/blob/master/TODO1/google-colab-free-gpu-tutorial.md)
> * 译者：
> * 校对者：

# Google Colab Free GPU Tutorial

Now you can develop **deep learning** applications with [Google Colaboratory](https://colab.research.google.com/) -on the **free Tesla K80 GPU**- using [Keras](https://keras.io/), [Tensorflow](https://www.tensorflow.org/) and [PyTorch](http://pytorch.org/).

![](https://cdn-images-1.medium.com/max/800/1*Kbta9F_ZiRQmvETa-JkOSA.png)

Hello! I will show you how to use **Google Colab**, _Google’s free cloud service_ for **AI developers**. With Colab, you can develop deep learning applications on the **GPU for free**.

### Thanks to KDnuggets!

I am happy to announce that this blog post was selected as KDnuggets Silver Blog for February 2018! Read this on [KDnuggets](https://www.kdnuggets.com/2018/02/google-colab-free-gpu-tutorial-tensorflow-keras-pytorch.html).

![](https://cdn-images-1.medium.com/max/800/1*qPFwOR1l8DPwXqAcotrWCA.png)

### What is Google Colab?

Google Colab is a free cloud service and now it supports free GPU!

You can;

*   improve your **Python** programming language coding skills.
*   develop deep learning applications using popular libraries such as **Keras**, **TensorFlow**, **PyTorch,** and **OpenCV**.

The most important feature that distinguishes Colab from other free cloud services is; **Colab** provides GPU and is totally free.

Detailed information about the service can be found on the [faq](https://research.google.com/colaboratory/faq.html) page.

### Getting Google Colab Ready to Use

#### Creating Folder on Google Drive

![](https://cdn-images-1.medium.com/max/600/1*9x6GVBOwbAEsx7h8k5ruBw.jpeg)

Since **Colab** is working on your own **Google Drive**, we first need to specify the folder we’ll work. I created a folder named “**app**” on my **Google Drive**. Of course, you can use a different name or choose the default **Colab Notebooks** folder instead of **app folder**.

![](https://cdn-images-1.medium.com/max/800/1*vtTvpFVdCcsmEXtQA6k2Kw.png)

**I created an empty “app” folder**

#### Creating New Colab Notebook

Create a new notebook via **Right click > More > Colaboratory**

![](https://cdn-images-1.medium.com/max/800/1*7XLisHAnGGnflIYyqQja8Q.jpeg)

**Right click > More > Colaboratory**

**Rename** notebook by means of clicking the file name.

![](https://cdn-images-1.medium.com/max/800/1*emOY5nIyYphREEqo6e86jg.png)

### Setting Free GPU

It is so simple to alter default hardware **(CPU to GPU or vice versa)**; just follow **Edit > Notebook settings** or **Runtime>Change runtime type** and **select GPU** as **Hardware accelerator**.

![](https://cdn-images-1.medium.com/max/800/1*WNovJnpGMOys8Rv7YIsZzA.png)

### Running Basic Python Codes with Google Colab

Now we can start using **Google Colab**.

![](https://cdn-images-1.medium.com/max/800/1*lb2htyPfbC5Y9VF8IZGqdQ.png)

I will run some **Basic Data Types** codes from [Python Numpy Tutorial](http://cs231n.github.io/python-numpy-tutorial/).

![](https://cdn-images-1.medium.com/max/800/1*02ylPr7JIn_qiJkc4iprpw.png)

It works as expected :) If you do not know **Python** which is the **most popular programming language for AI**, I would recommend this simple and clean tutorial.

### Running or Importing .py Files with Google Colab

Run these codes first in order to install the necessary libraries and perform authorization.

```
from google.colab import drive
drive.mount('/content/drive/')
```

When you run the code above, you should see a result like this:

![](https://cdn-images-1.medium.com/max/800/1*4AJ2EEn-xtvGAiwsNlDmNQ.png)

**Click** the link, **copy** verification code and **paste** it to text box.

After completion of the authorization process, you should see this:

![](https://cdn-images-1.medium.com/max/800/1*SwDEbzteA0EeNDcq8m_tdA.png)

Now you can reach you Google Drive with:

```
!ls "/content/drive/My Drive/"
```

install **Keras:**

```
!pip install -q keras
```

upload [mnist_cnn.py](https://github.com/keras-team/keras/blob/master/examples/mnist_cnn.py) file to **app** folder which is located on your **Google Drive**.

![](https://cdn-images-1.medium.com/max/800/1*9y7lbgBmG99ZVkGr5b7arQ.png)

**mnist_cnn.py** file

run the code below to train a simple convnet on the [MNIST dataset](http://yann.lecun.com/exdb/mnist/).

```
!python3 "/content/drive/My Drive/app/mnist_cnn.py"
```

![](https://cdn-images-1.medium.com/max/2000/1*Mw8_NcnS-a0TyDG9TVHqqg.png)

As you can see from the results, each epoch lasts only **11 seconds**.

### Download Titanic Dataset (.csv File) and Display First 5 Rows

If you want to download **.csv file** from **url** to “**app” folder**, simply run:

> !wget [https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/datasets/Titanic.csv](https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/datasets/Titanic.csv) -P "/content/drive/My Drive/app"

You may upload your .csv files **directly** to “app” folder instead of **wget method.**

![](https://cdn-images-1.medium.com/max/800/1*gjyZxq2tUORKLi3Fp_-sEg.png)

Read **.csv file** in “**app**” folder and display **first 5 rows**:

```
import pandas as pd
titanic = pd.read_csv(“/content/drive/My Drive/app/Titanic.csv”)
titanic.head(5)
```

![](https://cdn-images-1.medium.com/max/800/1*Wx-XLmFKjir-jxcVWp2i9g.png)

### Cloning Github Repo to Google Colab

It is easy to clone a Github repo with Git.

#### Step 1: Find the Github Repo and Get “Git” Link

Find any Github repo to use.

For instance: [https://github.com/wxs/keras-mnist-tutorial](https://github.com/wxs/keras-mnist-tutorial)

Clone or download > Copy the link!

![](https://cdn-images-1.medium.com/max/1000/1*zyxag4hs2vCY1DejIJveZg.png)

#### 2. Git Clone

Simply run:

> !git clone [https://github.com/wxs/keras-mnist-tutorial.git](https://github.com/wxs/keras-mnist-tutorial.git)

![](https://cdn-images-1.medium.com/max/800/1*I1TO_CtAolkNTPDK-vp4Hg.png)

#### 3. Open the Folder in Google Drive

Folder has the same with the Github repo of course :)

![](https://cdn-images-1.medium.com/max/1000/1*jE_CBuejVzTT_3ecSjk86w.png)

#### 4. Open The Notebook

Right Click > Open With > Colaboratory

![](https://cdn-images-1.medium.com/max/1000/1*Sm0CLQDJjX0uJMMjLuuhYA.png)

#### 5. Run

Now you are able to run Github repo in Google Colab.

![](https://cdn-images-1.medium.com/max/800/1*Om46o5HRFOC7RgXaWELV-w.png)

### Some Useful Tips

#### 1. How to Install Libraries?

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

or try this:

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

**7zip Reader**

```
!apt-get -qq install -y libarchive-dev && pip install -q -U libarchive
import libarchive
```

**Other Libraries**

`!pip install` or `!apt-get install` to install other libraries.

#### 2. Is GPU Working?

To see if you are currently using the GPU in Colab, you can run the following code in order to cross-check:

```
import tensorflow as tf
tf.test.gpu_device_name()
```

![](https://cdn-images-1.medium.com/max/800/1*rHxgzJWoos7f4AYF90PkzQ.jpeg)

#### 3. Which GPU Am I Using?

```
from tensorflow.python.client import device_lib
device_lib.list_local_devices()
```

Currently, **Colab only provides Tesla K80**.

![](https://cdn-images-1.medium.com/max/800/1*D-xR_CzTP3_MMt_8UqIj4Q.png)

#### 4. What about RAM?

```
!cat /proc/meminfo
```

![](https://cdn-images-1.medium.com/max/800/1*EPbmqr--SxC0crhMxoaS9Q.png)

#### 5. What about CPU?

```
!cat /proc/cpuinfo
```

![](https://cdn-images-1.medium.com/max/1000/1*keRD5wndUyzoxgNUwfWfsQ.png)

#### 6. Changing Working Directory

Normally when you run this code:

```
!ls
```

You probably see **datalab and drive** folders.

Therefore you must add **drive/app** before defining each filename.

To get rid of this problem, you can simply change the working directory. (In this tutorial I changed to **app folder**) with this simple code:

```
import os
os.chdir("drive/app")
```

After running code above, if you run again

```
!ls
```

You would see **app folder content** and don’t need to add **drive/app** all the time anymore.

#### 7. “`No backend with GPU available`“ Error Solution

If you encounter this error:

> Failed to assign a backend
No backend with GPU available. Would you like to use a runtime with no accelerator?

Try again a bit later. A lot of people are kicking the tires on GPUs right now, and this message arises when all GPUs are in use.

[Reference](https://www.kaggle.com/getting-started/47096#post271139)

#### 8. How to Clear Outputs of All Cells

Follow **Tools>>Command Palette>>Clear All Outputs**

#### 9. “apt-key output should not be parsed (stdout is not a terminal)” Warning

If you encounter this warning:

```
Warning: apt-key output should not be parsed (stdout is not a terminal)
```

That means authentication has already done. You only need to mount Google Drive:

```
!mkdir -p drive
!google-drive-ocamlfuse drive
```

#### 10. How to Use Tensorboard with Google Colab?

I recommend this repo:

[https://github.com/mixuala/colab_utils](https://github.com/mixuala/colab_utils)

#### 11. How to Restart Google Colab?

In order to restart (or reset) your virtual machine, simply run:

```
!kill -9 -1
```

#### 12. How to Add Form to Google Colab?

In order not to change hyperparameters every time in your code, you can simply add form to Google Colab.

![](https://cdn-images-1.medium.com/max/800/1*Cy19qeGZzgllJrtAqOH4OQ.png)

For instance, I added form which contain `**learning_rate**` variable and `**optimizer**` string.

![](https://cdn-images-1.medium.com/max/800/1*kGvfrNrRHwfv1jWtguufkg.png)

#### 13. How to See Function Arguments?

To see function arguments in TensorFlow, Keras etc, simply **add question mark (?)** after function name:

![](https://cdn-images-1.medium.com/max/800/1*cIrmYPaA5HHR1yLj2UPgAQ.png)

Now you can see original documentation without clicking TensorFlow website.

![](https://cdn-images-1.medium.com/max/800/1*D324zKvU1Ivu-RvKrOG7Ew.png)

#### 14. How to Send Large Files From Colab To Google Drive?

```
# Which file to send?
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

#### 15. How to Run Tensorboard in Google Colab?

If you want to runt Tensorboard in Google Colab, run the code below.

```
# You can change the directory name
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

You can track your **Tensorboard** logs with created **_ngrok.io_** URL. You will find the URL at the end of output.

Note that your **Tensorboard** logs will be save to **tb_logs** dir. Of course, you can change the directory name.

![](https://cdn-images-1.medium.com/max/800/1*ICwiBXUgxwq7i6f_zyn-Nw.jpeg)

After that, we can see the Tensorboard in action! After running the code below, you can track you Tensorboard logs via ngrok URL.

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

# input image dimensions
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

# convert class vectors to binary class matrices
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

### Conclusion

I think **Colab** will bring a new breath to Deep Learning and AI studies all over the world.

If you found this article helpful, it would mean a lot if you gave it some applause👏 and shared to help others find it! And feel free to leave a comment below.

You can find me on [Twitter](https://twitter.com/fuatbeser) .

#### Last Note

英文原文会持续跟进更新，如有需要请移步[英文原文](https://medium.com/deep-learning-turkey/google-colab-free-gpu-tutorial-e113627b9f5d)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
