> * 原文地址：[Getting started with TensorFlow —— IBM](https://www.ibm.com/developerworks/opensource/library/cc-get-started-tensorflow/index.html?social_post=1166248547&fst=Learn)
> * 原文作者：[Vinay Rao](https://developer.ibm.com/author/vinay.rao/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/get-started-tensorflow.md](https://github.com/xitu/gold-miner/blob/master/TODO/get-started-tensorflow.md)
> * 译者：
> * 校对者：

# IBM 工程师的 TensorFlow 入门指北

在机器学习的世界中， __tensor__ 是指数学模型中用来描述神经网络的多维数组。换句话说，一个 tensor 通常是一个广义上的高维矩阵或者向量。

通过使用矩阵的秩来显示维数的简单方法，tensor 能够将复杂的 **n** 维向量和超形状表示成 **n** 维数组。Tensor 有两个属性：数据类型和形状。

## 关于 TensorFlow

TensorFlow 是一个开源的深度学习框架，它基于 Apache 2.0 许可发布于 2015年底。从那时起，它就成为世界上最广泛采用的深度学习框架之一（由 Github 上基于它的项目数量得出）。

TensorFlow 源自 Google DistBelief，它是由 Google Brain 项目组开发并所有的深度学习系统。Google 从零开始设计它，用于分布式处理，并在 Google 产品数据中心中以最佳模式运行在定制的应用专用集成电路（ASIC）上，这种集成电路通常也被叫做 Tensor Processing Unit（TPU）。这种设计能够开发出有效的深度学习应用。

这个框架能够运行在 CPU、 GPU 或者 TPU 上，可以在服务器、台式机或者移动设备上使用。开发者可以在不同的操作系统和平台上部署 TensorFlow，而且不论是在本地环境还是云上。许多开发者会认为，相比类似的深度学习框架（比如 Torch 和 Theano，它们也支持硬件加速技术并被学术界广泛使用），TensorFlow 能够更好地支持分布式处理，并且在商业应用中拥有更高灵活性和性能表现。

深度学习神经网络通常是由多个层组成。它们使用多维数组在层之间传递数据或执行操作。一个 tensor 在神经网络的各层之间“流动”（Flow）。因此，命名为 TensorFlow。

TensorFlow 使用的主要编程语言是 Python。为 `C`++、 Java® 语言和 Go 提供了可用但不保证稳定性的的应用程序接口（API），同样也有很多为 `C`#，Haskell， Julia，Rust，Ruby，Scala，R 甚至是 PHP 设计的第三方的绑定。Google 近来发布了一个为移动设备优化的 TensorFlow-Lite 库，以使 TensorFlow 应用程序能在 Android 上运行。

这个教程提供了 TensorFlow 系统的概述，包括框架的优点，支持的平台，安装的注意事项以及支持的语言和绑定。

## TensorFlow 的优势

TensorFlow 为开发者提供了很多的好处：

*   计算流图模型。TensorFlow使用名为有向图的数据流图来表示计算模型。这让开发者能够简易直接的使用原生工具查看神经网络层间发生了什么，并能够交互式地调整参数和配置来完善他们的神经网络结构。
*   简单易用的 API。Python 开发者既可以使用 TensorFlow 原生的底层 API 接口或者核心 API 来开发他们自己的模型，也可以使用高级 API 库来构建内置模型。TensorFlow 有很多内建和社区的库，它也可以覆盖更高级的深度学习框架比如 Keras 上充当一个高级 API。
*   灵活的架构。使用 TensorFlow 的一个主要有点是它具有模块化，可扩展和灵活的设计。开发者只需更改很少的一些代码，就可以轻松地 CPU， GPU 或 TPU 处理器之间转换模型。尽管最初是为了大规模分布式训练和推测而设计的，开发者也可以使用 TensorFlow 来尝试其他机器学习模型和现有模型的系统优化。
*   分布式处理。Google 从零设计了 TensorFlow，目的是让它能在定制的 ASIC TPU 上分布式运行。另外，TensorFlow 可以在多种 NVIDIA GPU 内核上运行。开发人员能够充分利用基于 Intel Xeon 和 Xeon Phi 的 X64 CPU 架构或者基于 ARM64 的CPU 架构的优势。TensorFlow 可以在多架构和多核心系统上像在分布式进程中一样运行，它能将计算密集型进程当做生产任务移交。开发者能够创建 TensorFlow 集群。并将这些计算流图分发到这些集群中进行训练。Tensor 可以同步或异步执行分布式训练，既可以在流图内部，也可以跨流图进行，并且可以在网络计算节点间共享内存中的公共数据。
*   运行性能。性能通常是一个有争议的话题，但是大部分开发者都明白，任何深度学习框架都依赖于底层硬件，才能达到最优化运行，以低能耗实现高性能。通常，任何框架在其原生开发平台都应该实现最佳优化。TensorFlow 在 Google TPU 上表现良好，但更令人高兴的是，不管是在服务器和台式机上，还是在嵌入式系统和移动设备上，它都能在各种平台上达到高性能。该框架同样还支持了各种编程语言，数量令人惊讶。尽管另一个框架在原生环境（比如 在 IBM 平台上运行的  IBM Watson®）上运行有时可能会胜过 TensorFlow，但它仍然是开发人员的最爱，因为人工只能项目会跨越平台和编程语言，并以多样的终端应用为设计目标，并且所有这些都需要生成一致的结果。

## TensorFlow 应用

本节将介绍 TensorFlow 擅长的应用程序。显然，由于 Google 使用其专有版本的 TensorFlow 开发文本和语音搜索，语言翻译，和图像搜索的应用程序，因此 TensorFlow 的的主要优势在于分类和推测。例如，Google 在 TensorFlow 中应用 RankBrain（Google 的搜索结果排名引擎）。

TensorFlow 可用于优化语音识别和语音合成，比如区分多重声音或者在高噪背景下过滤噪声提取语音，在文本生成语音过程中模拟语音模式以获得更自然的语音。另外，它能够处理不同语言中的句型结构以生成更好的翻译效果。它也同样能被用于图像和视频识别以及对象、地标、人物、情绪、或活动的分类。这带来了图像和视频搜索的重大改进。

因为其灵活，可扩展和模块化的设计，TensorFlow 不会限制开发人员使用特定的模型或者应用。开发者使用 TensorFlow 不仅实现了机器学习和深度学习算法，还实现了统计和通用计算模型。有关应用程序和社区模型的更多信息请查看[使用 TensorFlow](https://www.tensorflow.org/about/uses)。

## 哪些平台支持 TensorFlow？

各种只要支持 Python 开发环境的平台就能支持 TensorFlow。但是，要接入一个受支持的 GPU，TensorFlow 需要依赖其他的软件，比如 NVIDIA CUDA 工具包和 cuDNN。为 TensorFlow（1.3 版本）预构建的 Python 二进制文件（当前发布）可用于下表中列出的操作系统。

![支持 TensorFlow 的操作系统](https://www.ibm.com/developerworks/opensource/library/cc-get-started-tensorflow/image1.png)

**注意：** 在 Ubuntu 或 Windows 上获得 GPU 加速支持需要 CUDA 工具包 8.0 和 cuDNN 6 或更高版本，以及一块能够兼容这个版本的工具包和 CUDA Computer Capability 3.0 或更高版本的 GPU 卡。macOS 上 1.2 版本以上的 TensorFlow 不再支持 GPU 加速。

详情请参考[安装 TensorFlow](https://www.tensorflow.org/install)。

### 从源代码构建 TensorFlow

官方使用 Bazel 在 Ubuntu 和 macOS 构建 TensorFlow。在 Windows 系统下使用 Windows 版本 Bazel 或者 Windows 版 CMake 构建现在还在试验过程中，查看[ 从源代码构建 TensorFlow ](https://www.tensorflow.org/install/install_sources)。

IBM 在 S822LC 高性能计算系统上使用 NVIDIA NVLink 连接线连接两块 POWER8 处理器和四块 NVIDIA Tesla P100 GPU 以使 PowerAI 适合进行深度学习。开发者能够在运行 OpenPOWER Linux 的 IBM Power System 上构建 TensorFlow。要了解更多信息可以查看[深度学习在 OpenPOWER 上: 在 OpenPOWER Linux 系统上构建 TensorFlow ](https://www.ibm.com/developerworks/community/blogs/fe313521-2e95-46f2-817d-44a4f27eba32/entry/Building_TensorFlow_on_OpenPOWER_Linux_Systems?lang=en)。

很多社区或供应商支持的构建程序也可用。

## TensorFlow 怎样使用硬件加速？

为了支持在更广泛的处理器和非处理器架构上使用 TensorFlow，Google 为供应商提供了一个新的抽象接口，实现用于加速线性代数（XLA）的新硬件后端，XLA 是一个专为线性代数计算的特定领域编译器，它可以用于优化 TensorFlow 计算过程。

### CPU

当前，由于 XLA 还是实验性的，TensorFlow 还是在 X64 和 ARM64 CPU 架构上受支持，被测试和构建。在 CPU 架构上，TensorFlow 通过使用矢量处理扩展来实现加速线性代数计算。

以 Intel CPU 为中心的 HPC 体系结构（如 Intel Xeon 和 Xeon Phi 系列）通过使用 Intel 数学核心函数库来实现深度神经网络基元，从而获得加速线性代数计算。Intel 也提供了拥有优化线性代数库的预构建的 Python 优化发行版。

其他供应商，例如 Synopsys 和 CEVA，使用映射和分析器程序转换 TensorFlow 流图和生成优化代码在他们的平台上运行。开发者在使用这种途径时需要移植，分析并调整结果代码。

### GPU

TensorFlow 支持特定的 NVIDIA GPU ，这些 GPU 能够兼容相关版本的 CUDA 工具包并符合相关的性能标准。尽管一些社区努力在 OpenCL 1.2 兼容的 GPU （比如 AMD 的）上运行 TensorFlow，OpenCL 支持仍是一个正在计划建设的项目，

### TPU

据 Google 称，基于 TPU 的流图比 CPU 或 GPU 上执行性能好 15-30 倍，并且非常节能。Google 将 TPU 设计成一个外部加速器，可以插入串行 ATA 硬盘插槽，并通过 PCI Express Gen3 x16 接口连接主机，从而实现高带宽吞吐。

Google TPU 是矩阵处理器而不是矢量处理器，并且神经网络不需要高精度的数学运算，而是使用大规模并行的低精度整数运算。毫不奇怪，矩阵处理器（MXU）结构具有 65,536 8-bit 乘法器，并通过脉动阵列结构波动推动数据，就像通过心脏的血液一样。

这种设计是一种复杂的指令集计算（CISC）结构，虽然是单线程的，但允许单个高级指令触发 MXU 上的多个低级操作，每次循环可能会执行 128,000 条指令，而不用访问内存。

因此，与 GPU 阵列或者多指令集、多数据 CPU HPC 集群相比，TPU 可以获得巨大的性能提升和能效比率。通过评估每个周期中 TensorFlow 流图中每个预备执行节点，TPU 相比其他架构，大大减少了深度学习神经网络训练时间，

## TensorFlow 安装注意事项

一般来说，TensorFlow 可以在任何支持 64 位 Python 开发环境的平台上运行。这个环境足以训练和测试大多数简单的例子和教程。然而，大多数专家认为，对于研究或专业开发，强烈推荐使用 HPC 平台。

### 处理器和内存性能要求

由于深度学习计算量非常大，因此具有向量扩展的高速多核 CPU 以及一个或多个具有高端 CUDA 支持的 GPU 是深度学习的普通标准。大多数专家还建议要注意 CPU 和 GPU 缓存，因为内存传输操作的能源消耗大，对性能不利。

深度学习的性能表现有两种模式需要考虑：

*   开发模式。通常情况下，在这种模式下，训练时间、性能表现、样本、数据集大小都会影响处理性能和内存要求。这些元素决定着神经网络计算性能和训练时间的极限。
*   应用模式。通常，在受训过的神经网络处理过程中，处理性能和内存决定了分类或推测的实时性能。卷积神经网络需要更多的低精度计算能力，而全连接神经网络需要更多的内存。

### 虚拟机选项

用于深度学习的虚拟机（VMS）现在最适用于 CPU 为中心多核心可用的硬件体系。因为主机操作系统控制了 CPU， GPU 这些物理设备，所以在虚拟机上实现加速很复杂。有两种已知方法：

*   GPU 挂载:
    *   只能在 Type-1 管理程序上运行，例如  Citrix Xen， VMware ESXi， Kernel Virtual Machine， 和 IBM Power。
    *   挂载的开销会根据 CPU，芯片组，管理程序和操作系统的特定组合而变化。一般来说，最新一代硬件的开销要小得多。
    *   给定的管理程序-操作系统组合支持特定的NVIDIA GPU。
*   GPU 虚拟化:
    *   支持所有的主流 GPU 供应商，比如 NVIDIA（GRID），AMD（MxGPU）和 Intel（GVT-G）。
    *   在特定的新 GPU 上支持最新版本的 OpenCL（TensorFlow 没有官方支持 OpenCL）。
    *   在特定的新 GPU 上最新版本的 NVIDIA GRID 支持 CUDA 和 OpenCL。

### Docker 安装选项

在 Docker 容器或者 Kubernetes 容器集群系统上运行 TensorFlow 有很多优势。TensorFlow 可以将流图作为执行任务分发给 TensorFlow 服务器集群，而这些服务集群其实是映射到容器集群的。使用 Docker 的附加优势是 TensorFlow 服务器可以访问物理 GPU 核心（设备）并为其分配特定的任务。

开发者还可以通过安装社区构建的 Docker 镜像，在 PowerAI OpenPOWER 服务器上的 Kubernetes 容器集群系统中部署 TensorFlow，如“[在 OpenPOWER 服务器上使用 PowerAI 的 Kubernetes 系统进行 TensorFlow 训练 ](https://developer.ibm.com/linuxonpower/2017/04/21/tensorflow-training-kubernetes-openpower-servers-using-powerai)”。

### 云安装选项

TensorFlow 云安装有几种选项：

*   Google Cloud TPU。对于研究人员来说，Google 有一个Alpha 版本的 TensorFlow Research Cloud，可以提供在线的 TPU 实例。
*   Google Cloud。Google 在一些特定的区域提供了自定义的 TensorFlow 机器实例，可以访问一个，四个或者八个 NVIDIA GPU 设备。
*   IBM Cloud 数据科学与管理。IBM 提供了一个附带 Jupyter Notebook 和 Spark 的 Python 环境。TensorFlow 已经预安装了。
*   Amazon Web Services (AWS)。Amazon 提供 AWS Deep Learning Amazon 机器镜像（AMIs)，可选 NVIDIA GPU 支持，可在各种 Amazon Elastic Compute Cloud 实例上运行。TensorFlow， Keras 和其他的深度学习框架都已经预装。AMI 可以支持多达 64 个 CPU 内核和 8 个 NVIDIA GPU（K80）。
*   Azure。可以在使用 Azure 容器服务的 Docker 实例上或者一个 Ubuntu 服务器上设置 TensorFlow。Azure 机器实例可以支持 24 个 CPU内核和多达 4 个 NVIDIA GPU（M60 或 K80）。
*   IBM Cloud Kubernetes 集群。IBM Clound 上的 Kubernetes 集群 可以运行 TensorFlow。一个社区构建的 Docker 镜像可用。POWERAI 服务器提供 GPU 支持。

## TensorFlow 支持那些编程语言？

尽管 Google 在 `C`++ 中实现了 TensorFlow 核心代码，但是它的主要编程语言是 Python，而且这个 API 是最完整的，最强大的，最易用的。更多有关信息，请参阅 [Python API 文档](https://www.tensorflow.org/api_docs/python)。Python API 还具有最广泛的文档和可扩展性选项以及广泛的社区支持。

除了 Python 之外，TensorFlow还支持以下语言的 API，但不保证稳定性：

*   `C`++。TensorFlow `C`++ API 是下一个最强大的 API，可用于构建和执行数据流图以及 TensorFlow 服务。更多有关 `C`++ API 的信息，请参阅[C++ API](https://www.tensorflow.org/api_guides/cc/guide)。有关 `C`++ 服务 API 的更多信息，请参阅 [TensorFlow 服务 API 参考](https://www.tensorflow.org/api_docs/serving)。
*   Java 语言。尽管这个 API 是实验性的，但最新发布的 Android Oreo 支持 TensorFlow 可能会使这个 API 更加突出。更多有关信息，请参考[tensorflow.org](https://www.tensorflow.org/api_docs/java/reference/org/tensorflow/package-summary)。
*   Go。这个 API 是对 Google Go 语言高度实验性的绑定。更多有关信息，请参考 [package tensorflow](https://godoc.org/github.com/tensorflow/tensorflow/tensorflow/go)。

### 第三方绑定

Google 已经定义了一个外部函数接口（FFI）来支持其他语言绑定。该接口使用 `C` API 暴露了 TensorFlow `C`++ 核心函数。FFI 是新的，可能不会被现有的第三方绑定使用。

一项对 GitHub 的调查显示，有以下语言的社区或供应商开发的第三方 TensorFlow 绑定 `C`#，Haskell， Julia，Node.js，PHP，R，Ruby，Rust 和 Scala。

### Android

现在有一个经过优化的新 TensorFlow-Lite Android 库来运行 TensorFlow 应用程序。更多有关信息，请参考 [What's New in Android: O Developer Preview 2 & More](https://android-developers.googleblog.com/2017/05/whats-new-in-android-o-developer.html)。

## 使用 Keras 简化 TensorFlow

Keras 的层和模型完全兼容纯粹的 TensorFlow tensor。因此，Keras 为 TensorFlow 提供了一个很好的模型定义插件。开发者甚至可以将 Keras 与 其他 TensorFlow 库一起使用。有关详细信息，请参考 [使用 Keras 作为 TensorFlow 的简要接口: 教程](https://blog.keras.io/keras-as-a-simplified-interface-to-tensorflow-tutorial.html)。

## 结论

TensorFlow 只是许多用于机器学习的开源软件库之一。但是，根据它的 GitHub 项目数量，它已经成为被最广泛采用的深度学习框架之一。在本教程中，您了解了 TensorFlow 的概述，了解了哪些平台支持它，并查看了安装注意事项。

如果你准备使用 TensorFlow 查看一些示例，请查看 [机器学习算法加快训练过程](https://developer.ibm.com/code/journey/accelerate-training-of-machine-learning-algorithms/) 和 [使用 PowerAI notebooks 进行图像识别训练](https://developer.ibm.com/code/journey/image-recognition-training-powerai-notebooks/)中的开发者代码模式。

* * *

#### 资源下载

* [此篇文章的 PDF 文件](cc-get-started-tensorflow-pdf.pdf)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
