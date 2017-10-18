
> * 原文地址：[Build Personal Deep Learning Rig: GTX 1080 + Ubuntu 16.04 + CUDA 8.0RC + CuDnn 7 + Tensorflow/Mxnet/Caffe/Darknet](http://guanghan.info/blog/en/my-works/building-our-personal-deep-learning-rig-gtx-1080-ubuntu-16-04-cuda-8-0rc-cudnn-7-tensorflowmxnetcaffedarknet/)
> * 原文作者：[Guanghan Ning](http://guanghan.info/blog/en/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-our-personal-deep-learning-rig-gtx-1080-ubuntu-16-04-cuda-8-0rc-cudnn-7-tensorflowmxnetcaffedarknet.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-our-personal-deep-learning-rig-gtx-1080-ubuntu-16-04-cuda-8-0rc-cudnn-7-tensorflowmxnetcaffedarknet.md)
> * 译者：[RichardLeeH](https://github.com/RichardLeeH)
> * 校对者：[TobiasLee](https://github.com/TobiasLee)，[fghpdf](https://github.com/fghpdf)

# 搭建个人深度学习平台：GTX 1080 + Ubuntu 16.04 + CUDA 8.0RC + CuDNN 7 + Tensorflow/Mxnet/Caffe/Darknet

我在 TCL 的实习即将结束。在回校参加毕业典礼之前，我决定搭建自己的个人深度学习平台。我想我不能真的依赖于公司或实验室的机器，毕竟那工作站不是我的，而且开发环境可能是一团糟(它已经发生过一次)。有了个人平台，我可以方便地通过 teamViewer 随时登录我的深度学习工作站。我有机会从头开始搭建平台。

在本文中，我将介绍 PC 平台搭建深度学习的整个过程，包括硬件和软件。在此，我分享给大家，希望对具有相同需求的研究人员和工程师有所帮助。由于我使用 **GTX 1080、Ubuntu 16.04、CUDA 8.0RC、CuDNN 7** 搭建平台，这些都是最新版本。以下是这篇文章的概述：

**硬件**

1. 配件选择
2. 搭建工作站

**软件**

3. 操作系统安装

- 准备可引导安装的 USB 驱动器
- 安装系统

4. 深度学习环境安装

- 远程控制：teamViewer
- 开发包管理：Anaconda
- 开发环境：python IDE
- GPU 优化环境：CUDA 和 CuDNN
- 深度学习框架：Tensorflow & Mxnet & Caffe & Darknet

5. 开箱即用的深度学习环境：Docker

- 安装 Docker
- 安装 NVIDIA-Docker
- 下载深度学习 Docker 镜像
- 主机和容器之间共享数据
- 了解简单的 Docker 命令

## 硬件：

### 配件选择

我推荐使用 **PcPartPicker** 来挑选配件。它可以帮助你以最低价购买到配件，并为你检查所选配件的兼容性。他们还上线了一个 **youtube 频道**，在这个频道里他们提供了用于展示构建过程的视频。

在我的搭建案例中，我使用他们的搭建文章作为参考，并创建了一个搭建清单，可以在 [这里](https://pcpartpicker.com/user/quietning/saved/#view=YP6v6h) 找到。以下是我搭建工作站使用的配件。
![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/IMG_20160707_191958-Copy.jpg)

由于我们正在进行深度学习研究，一个好的 GPU 是非常有必要的。因此，我选择了新近发布的 GTX 1080。它虽然很难买到，但如果你注意到 newegg (新蛋网，美国新蛋网是电子数码产品销售网站) 上的捆绑销售，一些人已经囤到货并组合 [GPU + 主板] 或 [GPU + 电源] 进行捆绑销售。你懂得，这就是市场。购买捆绑产品会比买一个价格高的要好。不管怎样，一个好的 GPU 将加快训练或者后期调参过程。以下是一些 GTX 1080 同其他品牌 GPU 的优势，在性能，价格和耗电量（节约日常用电量和用于购买合适 PC 电源的开支）。

![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/gtx_1.png)

![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/gtx_2.png)

注意：相比于 12GB 内存的 TITAN X，GTX 1080 仅有 8GB，你可能手头宽裕或更慷慨，因此会选择使用堆叠式 GPU。然后记得选择一个带有更多 PCI 的主板。

### 配件组装

平台搭建从配件组装开始，我参考了 [这段视频(youtube 网站，需要翻墙)](https://www.youtube.com/watch?v=bHF2eEnXP6I) 教程。虽然各个部分略有不同，但搭建过程非常相似。我没有一点组装经验，但是有了这个教程，我就能在 3 小时内完成组装。（你可能花费更少的时间，但你知道，我非常谨慎）
![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/IMG_20160708_020941-Copy.jpg)

## 软件：

### 操作系统安装

通常采用 Ubuntu 进行深度学习研究。但是有时你需要使用另一操作系统协同工作。例如，如果你使用 GTX 1080，同时又是一位 VR 开发者，你可能需要使用 Win10 进行基于 Unity 或其他框架的 VR 开发。以下我将介绍 Win10 和 Ubuntu 的安装。如果你仅对 Ubuntu 的安装感兴趣，你可以跳过 windows 安装。

#### 准备可引导安装的 USB 驱动器

使用 USB 盘安装操作系统非常方便，因为我们少不了它。由于 USB 盘将被格式化，所以您不希望在移动硬盘上发生这种情况。或者如果你有可写的 DVD，你可以用它们来安装操作系统，并保存它们以备将来使用，如果你能在那时再找到它们的话。

由于在官方网站上已经很好的说明了，你可以访问 [Windows 10 页面](https://www.microsoft.com/en-us/software-download/windows10/) 学习如何制作 USB 驱动。对于 Ubuntu，你可以同样下载 ISO 并构建 USB 安装媒体或者刻录到 DVD 上。如果你正在使用 Ubuntu 系统，参考 Ubuntu 官方网站的 [教程](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-ubuntu)。 如果你在使用 Windows，参考 [本教程](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-windows)。

#### 系统安装

强烈建议安装 Windows 为主系统的双系统。我将会跳过 Win10 的安装，因为详细的安装指南可以从 [Windows 10 主页](https://www.microsoft.com/en-us/software-download/windows10/) 找到。需要注意的一点是，你需要使用激活码。如果在你的笔记本电脑上安装了 Windows 7 或 我 Windows 10，你可以在你的笔记本电脑底部找到激活码的标签。

安装 Ubuntu16.04 时遇到点小麻烦，这有些出乎意料。这主要是因为一开始我就没有安装 GTX 1080 驱动。我将把这些分享给大家，以防你遇到同样的问题。

#### 安装 Ubuntu：

首先，插入用于安装系统的引导 USB。在我的 LG 显示屏上并没有出现任何东西，除了显示频率太高。但是显示屏是正常的，因为在另一台笔记本上测试过了。我试着将 PC 连接到 电视上，可以在电视上正常显示，但仅有桌面没有工具面板。我发现这是 NVIDIA 驱动的问题。因此我打开 BIOS，并设置集成显卡作为默认显卡并重启。记得要把 HDMI 从 GTX1080 端口上的接口切换到主板上。现在这个显示器工作得很好。我按照提示指南成功地安装了 Ubuntu。
![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/installing_ubuntu.png)

为了使用 GTX1080，请访问 [本页面](http://www.nvidia.com/download/driverResults.aspx/104284/en-us) 获取 基于 Ubuntu 的 NVIDIA 显卡驱动。安装好驱动后，确保 GTX1080 在主板上。
现在屏幕上显示 “You appear to be running an X server..”。 我参考了 [本链接](http://askubuntu.com/questions/149206/how-to-install-nvidia-ru) 来解决这个问题并安装驱动。我在这里引用下：

- 确保登出系统。
- 同时按住 CTRL+ALT+F1 并用你的授权进行登录。
- 通过运行 sudo service lightdm stop 或 sudo stop lightdm 杀死当前的 X 服务会话。
- 通过运行 sudo init 3 进入到第三等级 并安装 *.run 文件。
- 当安装结束，你需要重启系统。如果没有重启，运行 sudo service lightdm start 或 sudo start lightdm 重新启动 X 服务。

驱动器安装完后，我们需要重启并在 BIOS 中 将 GTX1080 设置为默认。此时，我们已经准备好了。

我遇到的其他一些小问题，以备将来使用：
- 问题: 当我重启时，我不能找到选项来选择 windows。
- 解决方案: 在 ubuntu 下，**sudo gedit /boot/grub/grub.cfg**, 增加如下行：

```
menuentry ‘Windows 10′{
    set root=’hd0,msdos1′
    chainloader +1
}
```

- 问题: Ubuntu 不支持 百思买经常出售的这款 Belkin N300 无线适配器，
- 解决方案: 参考 [本链接](https://ubuntuforums.org/showthread.php?t=1515747) 的指南, 问题将会被解决。
- 问题: 安装好 teamViewer 后，提示 “dependencies not met”
- 解决方案: 参考 [本链接](http://askubuntu.com/questions/362951/installed-teamviewer-using-a-64-bits-system-but-i-get-a-dependency-error/363083)。

### 深度学习环境 

#### 远程控制软件安装 (TeamViewer)：

dpkg -i teamviewer_11.0.xxxxx_i386.deb

#### 包管理工具安装 (Anaconda)：

Anaconda 是一个易于安装的免费包管理、环境管理和 Python 分发工具包。其中收集了多达 720 个 开源包并提供免费的支持社区。它可以创建虚拟环境，这些虚拟环境并不会相互影响。当同时使用不同的深度学习框架，这非常有用，尽管它们配置不同。使用它来安装包页非常方便。极易安装，[参考这里](https://docs.continuum.io/anaconda/install#linux-install)。

使用虚拟环境的一些命令：
- source activate virtualenv
- source deactivate

### 开发环境安装 (Python IDE)：

#### Spyder vs Pycharm?

Spyder:

- 优点：类 matlab，易于查看中间结果。

Pycharm：

- 优点：模块化编码、更完整的 web 开发框架和跨平台的 IDE。

在我的个人哲学中，我认为它们只是工具。当使用时每个工具就会派上用场。我将使用 IDE 来构建主项目。例如，使用 pycharm 构建框架。然后，我仅用 vim 修改代码。这并不是说 VIM 有多么的强大和花哨。之后，我将使用 Vim 修改代码。而是因为它是我想真正掌握的文本编辑器。对于文本编辑器，我们不需要掌握两个。在特殊情况下，我们需要频繁地检查IO、目录等，我们可能希望使用 spyder。

#### 安装：

1. spyder：

- 你不需要安装 spyder，因为 Anaconda 中已经自带了 spyder

2. Pycharm

- 从 [官方网站](https://www.jetbrains.com/pycharm/) 下载。只需解压。
- 设置 Pycharm 的 项目解释器为 Anaconda，并进行包管理。关注 [这里](https://docs.continuum.io/anaconda/ide_integration#pycharm)。

3. vim

- sudo apt-get install vim
- 我使用的配置：[Github](https://github.com/Guanghan/VimIDE)

4. Git

- sudo apt install git
- git config –global user.name “Guanghan Ning”
- git config –global user.email “guanghan.ning@gmail.com”
- git config –global core.editor vim
- git config –list

### GPU 优化计算环境安装 (CUDA 和 CuDNN)

#### CUDA

##### [安装 CUDA 8.0 RC](https://developer.nvidia.com/cuda-release-candidate-download): 选择 7.5 以上版本的 8.0 版本有两个原因：

- 相比于 CUDA 7.5，CUDA 8.0 将会提高 GTX1080 (Pascal) 的性能。
- ubuntu 16.04 似乎不支持 CUDA 7.5，因为你在官网上找不到它。因此 CUDA 8.0 是唯一的选择。

##### [CUDA 入门指南](http://developer.download.nvidia.com/compute/cuda/8.0/secure/rc1/docs/sidebar/CUDA_Quick_Start_Guide.pdf?autho=1468531210_b9ce6047a5b7cb575fde7a6ffd6ad729&file=CUDA_Quick_Start_Guide.pdf)

##### [CUDA 安装指南](http://developer.download.nvidia.com/compute/cuda/8.0/secure/rc1/docs/sidebar/CUDA_Installation_Guide_Linux.pdf?autho=1468531209_7b8d97cef95dffcb18e2fecb656b8a85&file=CUDA_Installation_Guide_Linux.pdf)

1. sudo sh cuda_8.0.27_linux.run
2. 按照命令提示
3. 作为 CUDA 环境一部分，你需要在你主目录的 ~/**.bashrc** 文件中添加以下内容。

- export CUDA_HOME=/usr/local/cuda-8.0
- export LD_LIBRARY_PATH=${CUDA_HOME}/lib64
- PATH=${CUDA_HOME}/bin:${PATH}
- export PATH

4. 验证是否安装 CUDA（记住需要重启 terminal）：

- nvcc –version

#### CuDNN（CUDA 深度学习库）

##### [安装 CuDNN](https://developer.nvidia.com/cudnn)

- 版本：CuDNN v5.0 for CUDA 8.0RC

##### [用户指南](http://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v5/prod/cudnn_library.pdf?autho=1468531134_f12a2097cf581a5659608091857f7326&file=cudnn_library.pdf)

##### [安装指南](http://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v5/prod/cudnn_library.pdf?autho=1468531134_f12a2097cf581a5659608091857f7326&file=cudnn_library.pdf)

1. 方式一：(环境变量中添加 CuDNN 路径)

- Extract folder “cuda”
- cd <installpath>
- export LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH

2. 方式二:  (将 CuDNN 的文件 拷贝到 CUDA 文件夹下。如果 CUDA 运行正常，它会通过相对路径自动找到 CUDNN)

- tar xvzf cudnn-8.0.tgz
- cd cudnn
- sudo cp include/cudnn.h /usr/local/cuda/include
- sudo cp lib64/libcudnn* /usr/local/cuda/lib64
- sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

### 安装深度学习框架：

#### Tensorflow / keras

##### 首先安装 tensorflow

1. [使用 Anaconda 安装](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/g3doc/get_started/os_setup.md#anaconda-installation)

- conda create -n tensorflow python=3.5

2. [在环境中使用 Pip 安装 Tensorflow](https://www.tensorflow.org/versions/r0.9/get_started/os_setup.html#anaconda-installation) (目前不支持 cuda 8.0。当 CUDA 8.0 的二进制文件发布后我将会进行更新)

- source activate tensorflow
- sudo apt install python3-pip
- export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow-0.9.0-cp35-cp35m-linux_x86_64.whl
- pip3 install –upgrade $TF_BINARY_URL

3. [直接使用源码安装 Tensorflow](https://www.tensorflow.org/versions/r0.9/get_started/os_setup.html#installing-from-sources)

- install bazel: install jdk 8, uninstall jdk 9.
- sudo apt-get install python-numpy swig python-dev
- ./configure
- build with bazel: bazel build -c opt –config=cuda //tensorflow/cc:tutorials_example_trainer, 
bazel-bin/tensorflow/cc/tutorials_example_trainer –use_gpu.

##### 安装 keras

1. 下载: [https://github.com/fchollet/keras/tree/master/keras](https://github.com/fchollet/keras/tree/master/keras)
2. 定位到 Keras 目录中并运行安装命令：

- sudo python setup.py install

3. [改变默认后端](http://keras.io/backend/) 从 theano 到 tensorflow

##### 使用 conda 在虚拟环境间进行切换

1. source activate tensorflow
2. source deactivate

#### Mxnet

##### 为 Mxnet 创建一个虚拟环境

1. conda create -n mxnet python=2.7
2. source activate mxnet

##### 参考 [官方网站](http://mxnet-mli.readthedocs.io/en/latest/how_to/build.html#building-on-ubuntu-debian) 安装 mxnet

1. sudo apt-get update
2. sudo apt-get install -y build-essential git libatlas-base-dev libopencv-dev
3. git clone –recursive https://github.com/dmlc/mxnet
4. edit make/config.mk
5. set cuda= 1, set cudnn= 1, add cuda path
6. cd mxnet
7. make clean_all
8. make -j4

- 我遇到的一个问题是，“高于 5.3 版本的 gcc 是不支持的！”, 而我的 gcc 为 5.4，因此我不得不删除它。

> - apt-get remove gcc g++
> - conda install -c anaconda gcc=4.8.5
> - gcc –version

##### 用于 mxnet 的[Python 包安装](http://mxnet-mli.readthedocs.io/en/latest/how_to/build.html#python-package-installation)

1. conda install -c anaconda numpy=1.11.1
2. 方法 1：

- cd python; sudo python setup.py install
- sudo apt-get install python-setuptools

3. 方法 2：

- cd mxnet
- cp -r ../mxnet/python/mxnet .
- cp ../mxnet/lib/libmxnet.so mxnet/

4. 快速测试：

- python example/image-classification/train_mnist.py

5. GPU 测试：

- python example/image-classification/train_mnist.py –network lenet –gpus 0

#### Caffe

1. 参考详细指南：[Caffe Ubuntu 16.04 或 15.10 安装指南](https://github.com/BVLC/caffe/wiki/Ubuntu-16.04-or-15.10-Installation-Guide)
2. 需要安装 OpenCV。Opencv 3.1 的安装，参考以下链接：[Ubuntu 16.04 或 15.10 OpenCV 3.1 安装指南](https://github.com/BVLC/caffe/wiki/Ubuntu-16.04-or-15.10-OpenCV-3.1-Installation-Guide)

#### Darknet

- 这是所有需要安装工具中最易安装的。仅需运行 “make” 命令，就是这么简单。

### 开箱即用的深度学习环境：Docker

我已经在 Ubuntu 14.04 和 TITAN-X (cuda7.5) 上正确的安装过 caffe、darknet、mxnet 和 tensorflow 等。我已经完成了这些框架的项目，一切都很顺利。因此，如果你想专注于深度学习的研究，而不是被你可能遇到的外围问题所困扰，那么使用这些预先构建的环境比使用最新版本更安全。然后，您应该考虑使用 docker 将每个框架与它自己的环境隔离开来。这些 docker 镜像可以在 [DockerHub](https://hub.docker.com/) 中找到。

#### 安装 Docker 

与虚拟器不同，docker 镜像由层构建。同一个组件可以在不同的镜像间共享。当我们下载一个新镜像，已经存在的组件是不需要重新下载的。相比于完全替换虚拟机镜像，这是非常高效和方便的。docker 容器是 docker 镜像的运行时。这些镜像可以被提交和更新，就如同 Git.

要在 Ubuntu 16.04 上安装 docker，我们可以参考 [官方网站](https://docs.docker.com/engine/installation/linux/ubuntulinux/) 的指南。

#### 安装 NVIDIA-Docker

docker 容器是硬件和平台无关的，但是 docker 并没有通过容器来支持 NVIDIA GPU。（硬件是专门的，需要驱动程序。）为了解决这个问题，在特定的机器上启动容器的时候，我们需要 nvidia-docker 挂载到设备和驱动文件上。在这种情况下，镜像对于 Nvidia 驱动是不可知的。 

NVIDIA-Docker 的安装从 [这里](https://github.com/NVIDIA/nvidia-docker) 可以找到。

#### 下载深度学习 Docker 镜像 

我从 docker Hub 收集了一些预购建镜像。这些镜像列表如下：
- cuda-caffe
- cuda-mxnet
- cuda-keras-tensorflow-jupyter

#### 可以在 docker hub 上找到更多镜像。

在主机和容器间共享数据
对于计算机视觉研究人员来说，没有看到结果会很尴尬。例如，给一个图像添加毕加索风格，我们希望从不同的 epoch 输出结果。参考 [本页面](https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine) 快速在主机和容器间共享数据。在一个共享目录中，我们可以创建项目。在主机上，我们可以使用文本编辑器或者我们喜欢的 IDE 来编写代码。接着，我们可以在容器中运行程序。共享容器中的数据可以在基于 Ubuntu 机器的主机上通过 GUI 看到并处理。 

#### 了解简单的 命令

如果你是一个 docker 新手，不要不知所措。如果你将来不需要用到它的话，你是不需要系统的学习这方面的知识的。以下是一些在 docker 上 使用的简单命令。如果你认为 docker 是一个工具，这些命令足够了，并且仅仅是为了深度学习而使用它。

##### 如何检查 docker 镜像？

- docker images： 查询所有安装的 docker 镜像。

##### 如何检查 docker 容器？

- docker ps -a：查询所有安装的容器。
- docker ps: 查询当前运行的容器

##### 如何退出 docker 容器？

1. (方法 1) 在对应于当前容器的终端输入：

- exit

2. (方法 2) 使用 [Ctrl + Alt + T] 打开一个新终端，或者使用 [Ctrl + Shift + T] 打开一个新终端：

- docker ps -a：查询安装的镜像。
- docker ps: 查询运行的容器。
- docker stop [container’s ID]: 停止退出容器。

3. 如何删除一个 docker 镜像？

- docker rmi [docker_image_name]

4. 如何删除一个 docker 容器？

- docker rm [docker_container_name]

5. 基于已经存在的镜像如何制作我们自己的 docker 镜像？（从一个已经创建的镜像更新容器并且将结果提交到镜像。）

- 加载镜像，打开一个容器
- 在容器中做一些修改
-提交镜像：docker commit -m “Message: Added changes” -a “Author: Guanghan”  0b2616b0e5a8 ning/cuda-mxnet

6. 在主机和 docker 容器之间拷贝数据：

- docker cp foo.txt mycontainer:/foo.txt
- docker cp mycontainer:/foo.txt foo.txt

7. 从 docker 镜像中打开一个容器：

- 是否需要保存这个容器，因为它是可以被提交的：docker run -it [image_name]
- 如果容器只是暂时使用：docker run –rm -it [image_name]

欢迎发表评论


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
