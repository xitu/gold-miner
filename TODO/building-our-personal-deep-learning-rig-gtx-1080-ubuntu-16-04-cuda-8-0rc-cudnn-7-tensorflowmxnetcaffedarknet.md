
> * 原文地址：[Build Personal Deep Learning Rig: GTX 1080 + Ubuntu 16.04 + CUDA 8.0RC + CuDnn 7 + Tensorflow/Mxnet/Caffe/Darknet](http://guanghan.info/blog/en/my-works/building-our-personal-deep-learning-rig-gtx-1080-ubuntu-16-04-cuda-8-0rc-cudnn-7-tensorflowmxnetcaffedarknet/)
> * 原文作者：[Guanghan Ning](http://guanghan.info/blog/en/author/admin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-our-personal-deep-learning-rig-gtx-1080-ubuntu-16-04-cuda-8-0rc-cudnn-7-tensorflowmxnetcaffedarknet.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-our-personal-deep-learning-rig-gtx-1080-ubuntu-16-04-cuda-8-0rc-cudnn-7-tensorflowmxnetcaffedarknet.md)
> * 译者：[RichardLeeH](https://github.com/RichardLeeH)
> * 校对者：

# 搭建个人深度学习平台：GTX 1080 + Ubuntu 16.04 + CUDA 8.0RC + CuDnn 7 + Tensorflow/Mxnet/Caffe/Darknet

我在 TCL 的实习即将结束。在回校园参加毕业典礼之前，我决定搭建自己的个人深度学习平台。我想我不能真的依赖于公司或实验室的机器，因为最终工作站不是我的，而且开发环境可能是一团糟(它已经发生过一次)。有了个人平台，我可以方便地使用 teamviewer 随时登陆我的深度学习工作站。我有机会从头开始搭建平台。

在本文中，我将介绍搭建深度学习 PC 的挣个过程。包括硬件和软件。在此，我分享给大家，希望对具有相同需求的研究人员和工程师有所帮助。由于我使用 **GTX 1080, Ubuntu 16.04, CUDA 8.0RC, CuDnn 7** 搭建平台，这些都是最新版本。以下是这篇文章的概述：

**硬件**

1. 选择部分
2. 搭建工作站

**软件**

3. 操作系统安装

- 准备可引导安装的 USB 驱动器
- 安装系统

4. 深度学习环境安装

- 远程控制：teamviewer
- 开发包管理：anaconda
- 开发环境：python IDE
- GPU 优化环境：CUDA 和 CuDnn
- 深度学习框架：Tensorflow & Mxnet & Caffe & Darknet

5. 开箱即用的深度学习环境：Docker

- 安装 Docker
- 安装 NVIDIA-Docker
- 下载深度学习 Docker 镜像
- 主机和容器之间共享数据
- 了解简单的 Docker 命令

## 硬件：

### 选择部分

I recommend using **PcPartPicker** to pick your parts. It helps you find the source where you can buy your part with the lowest price available, and it checks the compatibility of the selected parts for you. They also have a **youtube channel** where they offer videos that demonstrate the building process.
我推荐使用 **PcPartPicker** 来挑选配件。它可以帮助你以最低价购买到配件，并检查所选配件的兼容性。他们还上线了一个 **youtube 频道**，你可以找到他们提供的搭建过程的视频。

在我的搭建案例中，我使用他们的搭建文章作为参考，并创建了一个搭建清单，可以在[这里](https://pcpartpicker.com/user/quietning/saved/#view=YP6v6h)找到。以下是我搭建工作站使用的配件。
![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/IMG_20160707_191958-Copy.jpg)

Since we are doing deep learning research, a good GPU is necessary. Therefore, I choose the recently released GTX 1080. It was quite hard to buy, but if you notice the bundles in newegg, some people are gathering this to sell in [GPU + motherboard] or [GPU + Power] bundles. Market, you know. It is better buying the bundle than buying it at a raised price, though. Anyway, a good GPU will make the training or finetuning process much faster. Here are some figures to show the advantage of GTX 1080 over some other GPUs, with respect to performance, price, and power efficiency (saves you electricity daily and the money to buy the appropriate PC power supply).
由于我们正在进行深度学习研究，一个好的 GPU 是非常有必要的。因此，我选择了最新发布的 GTX 1080。但很难买到，

![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/gtx_1.png)

![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/gtx_2.png)

Note that GTX 1080 has only 8GB memory, compared to 12GB of TITAN X. You may be richer or more generous to yourself, therefore considering using stacked GPUs. Then remember to choose another motherboard that has more PCIs.

### Build from Parts

As of building from the parts, I followed the tutorial of [this video]. Although the parts are slightly different, the building process is quite similar. I have no previous experience building by my own, but with this tutorial I was able to make it work within 3 hours. (It should take you less time, but I was extremely cautious, you know.)

![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/IMG_20160708_020941-Copy.jpg)

## 软件：

### 操作系统安装

通常采用 Ubuntu 进行深度学习研究。但是有时你需要使用另一操作系统协同工作。例如，如果 if you are also a VR developer, having a GTX 1080, you may want a Win10 for VR development with Unity or whatsoever. Here I introduce the installation of both Win10 and Ubuntu. If you are only interested in the Ubuntu installation, you can skip installing windows.

#### 准备可引导安装的 USB 驱动器

It is very convenient to install operating systems with USB disks, as we all have them. Because the USB disks will be formatted, you won’t want that happen to your portable hard disk. Or if you have writable DVDs, you can use them to install operating systems and save them for future use, if you can find them again by then.

Since it is well illustrated in the official website, you can go to [Windows 10 page](https://www.microsoft.com/en-us/software-download/windows10/) to learn how to make the USB drive.As of Ubuntu, you can similarly download the ISO and create USB installation media or burn it to a DVD. If you are now using Ubuntu system, follow [this tutorial](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-ubuntu) from Ubuntu official website. If you are current using Windows, follow [this tutorial](http://www.ubuntu.com/download/desktop/create-a-usb-stick-on-windows) istead.

#### 系统安装

It is highly recommended that you install windows first for a dual-system installation. I will skip win10 installation as detailed guide can be found here: [Windows 10 page](https://www.microsoft.com/en-us/software-download/windows10/) . One thing to note is that you will need the activation key. You can find the tag on the bottom of your laptop, if it has been installed windows 7 or windows 10 upon purchasing.

Installing Ubuntu16.04 was a little tricky for me, which was kind of a surprise. It was mainly because I did not have the GTX 1080 driver pre-installed at the very beginning. I will share my story with you, in case you encounter the same problems.

#### 安装 Ubuntu：

First things first, insert the boot USB for installation. Nothing is showing on my LG screen, except that it says frequency is too high. But the screen is okay, as is tested on another laptop. I tried to connect the PC with a TV, which was showing, but only the desktop with no tool panel. I figured out it was the problem of the NVIDIA driver. So I went to BIOS and set the integrated graphics as default and restart. Remember to switch the HDMI from the port on GTX1080 to that on the motherboard. Now the display works well. I successfully installed Ubuntu following its prompt guides.

![](http://guanghan.info/blog/en/wp-content/uploads/2016/07/installing_ubuntu.png)

In order to use GTX1080, go to [this page](http://www.nvidia.com/download/driverResults.aspx/104284/en-us) to get the NVIDIA display driver for Ubuntu. Upon installing this driver, make sure that GTX1080 is on the motherboard.
Now it shows “You appear to be running an X server.. “.  I followed [this link](http://askubuntu.com/questions/149206/how-to-install-nvidia-ru) to solve this problem and installed the driver. I quote it here:

- Make sure you are logged out.
- Hit CTRL+ALT+F1and login using your credentials.
- kill your current X server session by typing sudo service lightdm stopor sudo stop lightdm
- Enter runlevel 3 by typing sudo init 3and install your *.run file.
- You might be required to reboot when the installation finishes. If not, run sudo service lightdm startor sudo start lightdm to start your X server again.

After installing the driver, we can now restart and set the GTX1080 as default in BIOS. We are good to go.

Some other small problems I encountered are listed here, in case they are helpful:

- Problem: When I restart, I couldn’t find the option to choose windows.
- Solver: In ubuntu, **sudo gedit /boot/grub/grub.cfg**, add following lines:

```
menuentry ‘Windows 10′{
    set root=’hd0,msdos1′
    chainloader +1
}
```

- Problem: Ubuntu does not support wireless adapter Belkin N300, which is commonly sold in Bestbuy.
- Solver: Follow instructions in [this link](https://ubuntuforums.org/showthread.php?t=1515747), the problem will be solved.
- Problem: Upon installing teamviewer, it says “dependencies not met”
- Solver: Refer to [this link](http://askubuntu.com/questions/362951/installed-teamviewer-using-a-64-bits-system-but-i-get-a-dependency-error/363083).

### 深度学习环境 

#### 远程控制软件安装 (TeamViewer)：

dpkg -i teamviewer_11.0.xxxxx_i386.deb

#### 包管理工具安装 (Anaconda)：

Anaconda is an easy-to-install free package manager, environment manager, Python distribution, and collection of over 720 open source packages offering free community support.It can be used to create virtual environments, where each environment will not mess up with each other. It is helpful when we use different deep learning frameworks at the same time, and the configurations are different.Using it to install packages is convenient as well.It can be easily installed, [follow this](https://docs.continuum.io/anaconda/install#linux-install).

Some commands to start using virtual environment:

- source activate virtualenv
- source deactivate

### 开发环境安装 (Python IDE)：

#### Spyder vs Pycharm?

Spyder:

- 优点：matlab-like，easy to review intermediate results.

Pycharm：

- Advantage：modular coding，more complete IDE for web development frameworks and cross-platform.

In my personal philosophy, I regard them to be merely tools. Each tool will be used when it comes in handy. I will use IDEs for the construction of the backbone for the project. For example, use pycharm for the framework construction. After that, I will just modify code with VIM. It is not that VIM is so powerful and showy, but because it is the single text editor that I want to really master. As of text editors, there is no need we should master two. For special occasions, where we need to frequently check IO, directories, etc, we might want to use spyder instead.

#### 安装：

1. spyder：

- 你不需要安装 spyder，因为 anaconda 中已经自带了 spyder

2. pycharm

- 从 [官方网站](https://www.jetbrains.com/pycharm/) 下载。只需解压。
- 设置 pycharm 的 项目解释器为 anaconda，并进行包管理。 关注 [这里](https://docs.continuum.io/anaconda/ide_integration#pycharm)。

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

- CUDA 8.0 will give a performance gain for GTX1080 (Pascal), compared to CUDA 7.5.
- It seems that ubuntu 16.04 does not support CUDA 7.5 because you cannot find it to download on the official website. Therefore CUDA 8.0 is the only choice.

##### [CUDA 入门指南](http://developer.download.nvidia.com/compute/cuda/8.0/secure/rc1/docs/sidebar/CUDA_Quick_Start_Guide.pdf?autho=1468531210_b9ce6047a5b7cb575fde7a6ffd6ad729&file=CUDA_Quick_Start_Guide.pdf)

##### [CUDA 安装指南](http://developer.download.nvidia.com/compute/cuda/8.0/secure/rc1/docs/sidebar/CUDA_Installation_Guide_Linux.pdf?autho=1468531209_7b8d97cef95dffcb18e2fecb656b8a85&file=CUDA_Installation_Guide_Linux.pdf)

1. sudo sh cuda_8.0.27_linux.run
2. Follow the command-line prompts
3. As part of the CUDA environment, you should add the following in the ~/**.bashrc**  file of your home folder.

- export CUDA_HOME=/usr/local/cuda-8.0
- export LD_LIBRARY_PATH=${CUDA_HOME}/lib64
- PATH=${CUDA_HOME}/bin:${PATH}
- export PATH

4. 验证是否 CUDA 安装（记住需要重启 terminal）：

- nvcc –version

#### Cudnn（CUDA 深度学习库）

##### [安装 cudnn](https://developer.nvidia.com/cudnn)

- Version：Cudnn v5.0 for CUDA 8.0RC

##### [用户指南](http://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v5/prod/cudnn_library.pdf?autho=1468531134_f12a2097cf581a5659608091857f7326&file=cudnn_library.pdf)

##### [安装指南](http://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/v5/prod/cudnn_library.pdf?autho=1468531134_f12a2097cf581a5659608091857f7326&file=cudnn_library.pdf)

1. 方式一：(环境变量中添加 CuDNN 路径)

- Extract folder “cuda”
- cd <installpath>
- export LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH

2. 方式二:  (将 CuDNN 的文件 拷贝到 CUDA 文件夹下。If CUDA is working alright, it will automatically find CUDNN by relative path)

- tar xvzf cudnn-8.0.tgz
- cd cudnn
- sudo cp include/cudnn.h /usr/local/cuda/include
- sudo cp lib64/libcudnn* /usr/local/cuda/lib64
- sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

### 安装深度学习框架：

#### Tensorflow / keras

##### 首先安装 tensorflow

1. [使用 anaconda 安装](https://github.com/tensorflow/tensorflow/blob/master/tensorflow/g3doc/get_started/os_setup.md#anaconda-installation)

- conda create -n tensorflow python=3.5

2. [在环境中使用 Pip 安装 Tensorflow](https://www.tensorflow.org/versions/r0.9/get_started/os_setup.html#anaconda-installation) (It does NOT supports cuda 8.0 at the moment. I will update this when binaries for CUDA 8.0 come out)

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

3. [Change the default backend](http://keras.io/backend/) from theano to tensorflow

##### Use conda to activate/deactivate the virtual environment

1. source activate tensorflow
2. source deactivate

#### Mxnet

##### 为 Mxnet 创建一个虚拟环境

1. conda create -n mxnet python=2.7
2. source activate mxnet

##### Follow the [official website](http://mxnet-mli.readthedocs.io/en/latest/how_to/build.html#building-on-ubuntu-debian) to install mxnet

1. sudo apt-get update
2. sudo apt-get install -y build-essential git libatlas-base-dev libopencv-dev
3. git clone –recursive https://github.com/dmlc/mxnet
4. edit make/config.mk
5. set cuda= 1, set cudnn= 1, add cuda path
6. cd mxnet
7. make clean_all
8. make -j4

- One problem I encountered was，”gcc version later than 5.3 not supported!” My gcc version was 5.4, and I had to remove it.

> - apt-get remove gcc g++
> - conda install -c anaconda gcc=4.8.5
> - gcc –version

##### [Python package install](http://mxnet-mli.readthedocs.io/en/latest/how_to/build.html#python-package-installation) for mxnet

1. conda install -c anaconda numpy=1.11.1
2. Method 1:

- cd python; sudo python setup.py install
- sudo apt-get install python-setuptools

3. Method 2:

- cd mxnet
- cp -r ../mxnet/python/mxnet .
- cp ../mxnet/lib/libmxnet.so mxnet/

4. Quick test：

- python example/image-classification/train_mnist.py

5. GPU test:

- python example/image-classification/train_mnist.py –network lenet –gpus 0

#### Caffe

1. Follow this detailed guide:  [Caffe Ubuntu 16.04 or 15.10 Installation Guide](https://github.com/BVLC/caffe/wiki/Ubuntu-16.04-or-15.10-Installation-Guide)
2. OpenCV is needed. For Installation of Opencv 3.1, refer to this link: [Ubuntu 16.04 or 15.10 OpenCV 3.1 Installation Guide](https://github.com/BVLC/caffe/wiki/Ubuntu-16.04-or-15.10-OpenCV-3.1-Installation-Guide)

#### Darknet

- This is the easiest of all to install. Just type “make”, and that’s it.

### 开箱即用的深度学习环境：Docker

I used to have caffe, darknet, mxnet, tensorflow all installed correctly in Ubuntu 14.04 and TITAN-X (cuda7.5). And I have done projects with these frameworks, all turning out working well. It is therefore safer to use these pre-built environments than adventuring with latest versions, if you want to focus on the deep learning research instead of being potentially bothered by peripheral problems you may encounter. Then you should consider isolate each framework with its own environment using docker. These docker images can be found in [DockerHub](https://hub.docker.com/). 

#### 安装 Docker 

Unlike virtual machines, a docker image is built with layers. Same ingredients are shared among different images. When we download a new image, existing components won’t be re-downloaded. It is more efficient and convenient compared to the replacement of the whole virtual machine image. Docker containers are like the run-time of docker images. They can be committed and used to update docker images, just like Git.

To install docker on Ubuntu 16.04, we follow instructions on [the official website](https://docs.docker.com/engine/installation/linux/ubuntulinux/).

#### 安装 NVIDIA-Docker

Docker containers are both hardware-agnostic and platform agnostic, but docker does not natively support NVIDIA GPUs with containers. (The hardware is specialized, and driver is needed.) To solve this problem, we need the nvidia-docker to mount the devices and driver files when starting the container on the target machine. In this way, the image is agnostic of the Nvidia driver.

The installation of NVIDIA-Docker can be found [here](https://github.com/NVIDIA/nvidia-docker).

#### 下载深度学习 Docker 镜像 

I have collected some pre-built docker images from the Docker Hub. They are listed here:

- cuda-caffe
- cuda-mxnet
- cuda-keras-tensorflow-jupyter

#### More can be easily found on docker hub.

Share Data between Host and Container
For computer vision researchers, it will be awkward not to see results.For instance, after adding some Picasso style to an image, we would definitely want to the output images from different epoches.Check out [this page](https://github.com/rocker-org/rocker/wiki/Sharing-files-with-host-machine) quickly to share data between the host and the container.In a shared directory, we can create projects. On the host, we can start coding with text editors or whatever IDEs we prefer. And then we can run the program in the container.The data in the shared container can be viewed and processed with the GUI of the host Ubuntu machine.

#### 了解简单的 命令

Don’t be overwhelmed  if you are new to docker. It does not need to be systematically studied unless you want to in the future.Here are some simple commands for you to use to start dealing with docker. Usually they are sufficient if you consider Docker a tool, and want to use it solely for a deep learning environment.

##### 如何检查 docker 镜像？

- docker images： Check all the docker images that you have.

##### 如何检查 docker 容器？

- docker ps -a：Check all the containers that you have.
- docker ps: Check containers that are running

##### 如何退出 docker 容器？

1. (Method 1) In the terminal corresponding the current container:

- exit

2. (Method 2) Use [Ctrl + Alt + T] to open a new terminal, or use [Ctrl + Shift + T] to open a new terminal tab：

- docker ps -a：Check the containers you have.
- docker ps: Check the running container(s).
- docker stop [container’s ID]: Stop this container.

3. How to remove a docker image？

- docker rmi [docker_image_name]

4. How to remove a docker container？

- docker rm [docker_container_name]

5. How to create our own docker image, based on one that is from someone else？（Update a container created from an image and commit the results to an image.）

- load image，open a container
- do some changes in the container
-commit to the image: docker commit -m “Message: Added changes” -a “Author: Guanghan”  0b2616b0e5a8 ning/cuda-mxnet

6. Copy data between host and the docker container：

- docker cp foo.txt mycontainer:/foo.txt
- docker cp mycontainer:/foo.txt foo.txt

7. Open a container from a docker image：

- If the container is to be saved because it is probably to be committed: docker run -it [image_name]
- If the container is only for temporary use: docker run –rm -it [image_name]

欢迎发表评论


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
