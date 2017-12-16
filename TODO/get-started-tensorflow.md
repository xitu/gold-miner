> * 原文地址：[Getting started with TensorFlow —— IBM](https://www.ibm.com/developerworks/opensource/library/cc-get-started-tensorflow/index.html?social_post=1166248547&fst=Learn)
> * 原文作者：[Vinay Rao](https://developer.ibm.com/author/vinay.rao/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/get-started-tensorflow.md](https://github.com/xitu/gold-miner/blob/master/TODO/get-started-tensorflow.md)
> * 译者：
> * 校对者：

# IBM 工程师的 TensorFlow 入门指北

在机器学习的世界中， _tensor_ 是指数学模型中用来描述神经网络的多维数组。换句话说，一个 tensor 通常是一个广义上的高维矩阵或者向量。

通过使用矩阵的秩来显示维数的简单方法，tensor 能够将复杂的 **n** 维向量和超形状表示成 **n** 维数组。Tensor 有两个属性：数据类型和形状。

## 关于 TensorFlow

TensorFlow 是一个开源的深度学习框架，它基于 Apache 2.0 许可发布于 2015年底。从那时起，它就成为世界上最广泛采用的深度学习框架之一（通过 Github 上基于它的项目证明）。

TensorFlow 源自 Google DistBelief，它是由 Google Brain 项目组开发并所有的深度学习系统。Google 从零开始设计它，用于分布式处理，并在 Google产品数据中心中最佳运行在它定制的应用专用集成电路（ASIC）上，这种集成电路通常也被叫做 Tensor Processing Unit（TPU）。这种设计能够开发出有效的深度学习应用。

这个框架能运行在 CPU、 GPU 或者 TPU 上，可以在服务器、台式机或者移动设备上使用。开发者可以在不同的操作系统和平台上部署 TensorFlow，不论是在本地环境还是云上。许多开发者认为 TensorFlow 与相似的深度学习框架（比如 Torch 和 Theano，它们也支持硬件加速技术并被学术界广泛使用）相比，能够更好地支持分布式处理以及拥有更好的服务弹性和运行性能。

深度学习神经网络通常是由多个层组成。它们使用多维数组在层之间传递数据执行操作。一个 tensor 在神经网络的各层之间“流动”（Flow），因此，命名为 TensorFlow。

TensorFlow 使用的主要编程语言是 Python。为 `C`++、 Java® 语言和 Go 提供了可用不可信的的应用程序接口（API），同样也有很多为 `C`#，Haskell， Julia，Rust，Ruby，Scala，R 甚至是 PHP 设计的第三方的绑定。Google 近来发布了一个为移动设备优化的 TensorFlow-Lite 库，以使 TensorFlow 应用程序能在 Android 上运行。

这个教程提供了 TensorFlow 系统的概述，包括框架的优点，支持的平台，安装的注意事项以及支撑的语言和绑定。

## TensorFlow 的好处

TensorFlow 为开发者提供了很多的好处：

*   计算的模型图。TensorFlow使用叫做有向图的数据流图来表示计算模型。这让开发者能够简易直接的使用原生工具查看神经网络层间发生了什么，并能够交互式地调整参数和配置来完善他们的神经网络结构。
*   简单易用的 API。Python 开发者既可以使用 TensorFlow 原生的底层 API 接口或者核心 API 来开发他们自己的模型，也可以使用高级 API 库来构建内置模型。TensorFlow 有很多内建和社区的库，它也可以覆盖更高级的深度学习框架比如 Keras 上充当一个高级 API。
*   灵活的架构。使用 TensorFlow 的一个主要有点是它具有模块化，可扩展和灵活的设计。开发者只需更改很少的一些代码，轻松的在 CPU， GPU 或 TPU 处理器之间转换模型。尽管最初是为了大规模分布式训练和推测而设计的，开发者也可以使用 TensorFlow 来尝试其他机器学习模型和现有模型的系统优化。
*   分布式处理。Google 从零设计了 TensorFlow，目的是让它能在它定制的 ASIC TPU 上分布式运行。另外，TensorFlow 可以在多重 NVIDIA GPU 内核上运行。开发人员能够充分利用基于 Intel Xeon 和 Xeon Phi 的 X64 CPU 架构或者基于 ARM64 的CPU 架构的优势。TensorFlow 可以在多架构和多核心系统上像在分布式进程中一样运行，它能将计算密集型进程当做生产任务移交。开发者能够创建 TensorFlow 集群。并将这些计算图分发到这些集群中进行训练。Tensor 可以同步或异步执行分布式训练，既可以在图形内部也可以跨图形进行，并且可以在网络计算节点间共享内存中的公共数据。
*   运行性能。性能通常是一个有争议的话题，但是大部分开发者都明白，任何深度学习框架都依赖于底层硬件，以达到最优的方式运行，以低能耗实现高性能。通常，任何框架的原生开发平台都应该实现最佳优化。TensorFlow 在 Google TPU 上表现良好，但令人高兴的是，不仅是在服务器和台式机上，还是在嵌入式系统和移动设备上，它在各种平台上都能达到高性能。该框架同样还支持了各种编程语言，数量令人惊讶。尽管另一个框架在原生环境（比如 在 IBM 平台上运行的  IBM Watson®）上运行有时可能会胜过 TensorFlow，但它仍然是开发人员的最爱，因为人工只能项目会跨越平台和编程语言，并以多样的终端应用为设计目标，并且所有这些都需要生成一致的结果。

## TensorFlow 应用

本节将介绍 TensorFlow 擅长的应用程序。显然，由于 Google 使用其专有版本的 TensorFlow 开发文本和语音搜索，语言翻译，和图像搜索的应用程序，因此 TensorFlow 的的主要优势在于分类和推测。例如，Google 在 TensorFlow 中应用 RankBrain（Google 的搜索结果排名引擎）。

TensorFlow can be used to improve speech recognition and speech synthesis in differentiating multiple voices or filtering speech in high-ambient-noise environments, mimicking voice patterns for more natural-sounding text to speech. In addition, it handles sentence structure in different languages to produce better translations. It can also be used for image and video recognition as well as classification of objects, landmarks, people, sentiments, or activities. This has resulted in major improvements in image and video search.

Because of its flexible, extensible, and modular design, TensorFlow doesn't limit developers to specific models or applications. Developers have used TensorFlow to implement not only machine learning and deep learning algorithms but also statistical and general computational models. For more information about applications and contributed models, see [TensorFlow in Use](https://www.tensorflow.org/about/uses).

## Which platforms support TensorFlow?

Various platforms that support Python development environments can support TensorFlow. However, to access a supported GPU, TensorFlow depends on other software such as the NVIDIA CUDA toolkit and cuDNN. Prebuilt Python binaries for TensorFlow version 1.3 (current at the time of publication) are available for the operating systems listed in the following table.

![Operating systems that support TensorFlow](https://www.ibm.com/developerworks/opensource/library/cc-get-started-tensorflow/image1.png)

**Note:** GPU support on Ubuntu or Windows requires CUDA Toolkit 8.0 and cuDNN 6 or later and a GPU card compatible with the toolkit version and CUDA Compute Capability 3.0 or later. GPU support on macOS beyond TensorFlow version 1.2 is no longer available.

For details, refer to [Installing TensorFlow](https://www.tensorflow.org/install).

### Building TensorFlow from source

The official build process uses the Bazel build system to build TensorFlow from source on Ubuntu and macOS. The Windows build using Bazel for Windows or CMake for Windows is highly experimental. For more information, see [Installing TensorFlow from Sources](https://www.tensorflow.org/install/install_sources).

IBM optimized PowerAI for deep learning on the S822LC high-performance computing (HPC) system by using NVIDIA NVLink interconnects between two POWER8 processors and four NVIDIA Tesla P100 GPU cards. Developers can build TensorFlow on IBM Power Systems running OpenPOWER Linux. For more information, see [Deep Learning on OpenPOWER: Building TensorFlow on OpenPOWER Linux Systems](https://www.ibm.com/developerworks/community/blogs/fe313521-2e95-46f2-817d-44a4f27eba32/entry/Building_TensorFlow_on_OpenPOWER_Linux_Systems?lang=en).

Many community- or vendor-supported build procedures are available, as well.

## How does TensorFlow use hardware acceleration?

To support TensorFlow on a wider variety of processor and nonprocessor architectures, Google has introduced a new abstract interface for vendors to implement new hardware back ends for Accelerated Linear Algebra (XLA), a domain-specific compiler for linear algebra that optimizes TensorFlow computations.

### CPU

Currently, because XLA is still experimental, TensorFlow is supported, tested, and built for x64 and ARM64 CPU architectures. On CPU architectures, TensorFlow accelerates linear algebra by using the vector processing extensions.

Intel CPU-centric HPC architectures such as the Intel Xeon and Xeon Phi families accelerate linear algebra by using Intel Math Kernel Library for Deep Neural Networks primitives. Intel also provides prebuilt, optimized distributions of Python with optimized linear algebra libraries.

Other vendors, such as Synopsys and CEVA, use mapping and profiler software to translate a TensorFlow graph and generate optimized code to run on their platforms. Developers need to port, profile, and tune the resulting code when using this approach.

### GPU

TensorFlow supports specific NVIDIA GPUs compatible with the related version of the CUDA toolkit that meets specific performance criteria. OpenCL support is a roadmap item, although some community efforts have run TensorFlow on OpenCL 1.2-compatible GPUs such as AMD.

### TPU

According to Google, TPU-based graphs perform 15 - 30 times better than on CPU or GPU and are extremely energy-efficient. Google designed TPU as an external accelerator that fits into a serial ATA hard disk slot and connects to the host by PCI Express Gen3 x16, which allows high-bandwidth throughput.

Google TPUs are matrix processors rather than vector processors and use the fact that neural networks do not need high-precision math but rather massively parallel, low-precision integer math. Not surprisingly, the matrix processor (MXU) architecture has 65,536, 8-bit integer multipliers and pushes data in waves through a systolic array architecture, much like blood through a heart.

This design is a form of complex instruction set computing (CISC) architecture that, although single-threaded, allows a single high-level instruction to trigger multiple low-level operations on the MXU, which potentially can perform 128,000 instructions per cycle without needing to access memory.

As a result, a TPU sees massive performance gains and energy efficiency compared with GPU arrays or multiple instruction, multiple data CPU HPC clusters. The TPU massively reduces training time for deep learning neural networks over other architectures by evaluating every ready-to-execute node in a TensorFlow graph in each cycle.

## TensorFlow installation considerations

In general, TensorFlow runs on any platform that supports a 64-bit Python development environment. This environment is sufficient to train and test most simple examples and tutorials. However, most experts agree that for research or professional development, an HPC platform is strongly recommended.

### Processor and memory requirements

Because deep learning is quite computationally intensive, a fast, multicore CPU with vector extensions and one or more high-end CUDA-capable GPU cards is the norm for a deep learning environment. Most experts also recommend having significant CPU and GPU RAM because memory-transfer operations are energy expensive and detrimental to performance.

There are two modes to consider in the performance of deep learning networks:

*   Development mode. Typically, in this mode, training time and performance and the sample and dataset sizes drive the processing power and memory requirements. These elements decide the limits of computational performance and the training time of the neural network.
*   Application mode. Typically, real-time performance of classification or inference of the trained neural network drives processing power and memory requirements. Convolutional networks need more low-precision arithmetic power, while fully connected neural networks need more memory.

### Virtual machine options

Virtual machines (VMs) for deep learning are currently best suited to CPU-centric hardware where many cores are available. Because the host operating system controls the physical GPU, GPU acceleration is complex to implement on VMs. Two main methods exist:

*   GPU pass-through:
    *   Only works on Type-1 hypervisors such as Citrix Xen, VMware ESXi, Kernel Virtual Machine, and IBM Power.
    *   Pass-through has overheads that can vary based on specific combinations of CPU, chipset, hypervisor, and operating system. In general, overhead is significantly less for the latest generations of hardware.
    *   A given hypervisor-operating system combination supports specific NVIDIA GPU cards only.
*   GPU virtualization:
    *   Supported by all major GPU vendors-NVIDIA (GRID), AMD (MxGPU), and Intel (GVT-G).
    *   Latest versions support OpenCL on specific newer GPU cards (no official OpenCL on TensorFlow).
    *   The latest version of NVIDIA GRID supports CUDA and OpenCL for specific newer GPU cards.

### Docker installation options

Running TensorFlow in a Docker container or Kubernetes cluster has many advantages. TensorFlow can distribute a graph as execution tasks to clusters of TensorFlow servers that are mapped to container clusters. The added advantage of using Docker is that TensorFlow servers can access physical GPU cores (devices) and assign them specific tasks.

Developers can also deploy TensorFlow in a Kubernetes cluster on PowerAI OpenPOWER servers by installing a community-built Docker image, as described in "[TensorFlow Training with Kubernetes on OpenPower Servers using PowerAI](https://developer.ibm.com/linuxonpower/2017/04/21/tensorflow-training-kubernetes-openpower-servers-using-powerai)."

### Cloud installation options

TensorFlow has several options for cloud-based installation:

*   Google Cloud TPU. For researchers, Google has an Alpha offering of TensorFlow on cloud TPU instances called TensorFlow Research Cloud.
*   Google Cloud. Google offers custom TensorFlow machine instances with access to one, four, or eight NVIDIA GPU devices in specific regions.
*   IBM Cloud data science and data management. IBM offers a Python environment with Jupyter Notebook and Spark. TensorFlow is preinstalled.
*   Amazon Web Services (AWS). Amazon offers AWS Deep Learning Amazon Machine Images (AMIs) with optional NVIDIA GPU support that can run on various Amazon Elastic Compute Cloud instances. TensorFlow, Keras, and other deep learning frameworks are preinstalled. AMIs can support up to 64 CPU cores and up to 8 NVIDIA GPUs (K80).
*   Azure. TensorFlow can be set up on Docker instances using Azure Container Service or on an Ubuntu server. Azure machine instances can support up to 24 CPU cores and up to 4 NVIDIA GPUs (M60 or K80).
*   IBM Cloud Kubernetes cluster. Kubernetes clusters on IBM Cloud can run TensorFlow. A community-built Docker image is available. GPU support is available on PowerAI servers.

## Which programming languages does TensorFlow support?

Although Google implemented the TensorFlow core in `C`++, its main programming language is Python, and that API is the most complete, robust, and easiest to use. For more information, see the [Python API documentation](https://www.tensorflow.org/api_docs/python). The Python API also has the most extensive documentation and extensibility options as well as widespread community support.

Other than Python, TensorFlow supports APIs for the following languages without stability promises:

*   `C`++. The TensorFlow `C`++ API is the next most robust API and is available both for constructing and executing a data flow graph as well as for TensorFlow serving. For more information about the `C`++ API, see the [C++ API](https://www.tensorflow.org/api_guides/cc/guide). For more information about the `C`++ Serving API, see [TensorFlow Servicing API Reference](https://www.tensorflow.org/api_docs/serving).
*   Java language. Although this API is experimental, the recent announcement of Android Oreo support for TensorFlow is likely to make this API more prominent. For more information, see [tensorflow.org](https://www.tensorflow.org/api_docs/java/reference/org/tensorflow/package-summary).
*   Go. This API is a highly experimental binding to the Google Go programming language. For more information, see [package tensorflow](https://godoc.org/github.com/tensorflow/tensorflow/tensorflow/go).

### Third-party bindings

Google has defined a foreign function interface (FFI) to support other language bindings. This interface exposes TensorFlow `C`++ core functions with a `C` API. The FFI is new and might not be in use by existing third-party bindings.

A survey of GitHub reveals that there are community- or vendor-developed third-party TensorFlow bindings for the following languages: `C`#, Haskell, Julia, Node.js, PHP, R, Ruby, Rust, and Scala.

### Android

There is now a new, optimized TensorFlow-Lite Android library to run TensorFlow applications. For more information, see [What's New in Android: O Developer Preview 2 & More](https://android-developers.googleblog.com/2017/05/whats-new-in-android-o-developer.html).

## Simplifying TensorFlow with Keras

Keras layers and models are fully compatible with pure-TensorFlow tensors. As a result, Keras makes a great model definition add-on for TensorFlow. Developers can even use Keras alongside other TensorFlow libraries. For details, see [Keras as a simplified interface to TensorFlow: tutorial](https://blog.keras.io/keras-as-a-simplified-interface-to-tensorflow-tutorial.html).

## Conclusion

TensorFlow is just one of the many open source software libraries for machine learning. But, it has become one of the most widely adopted deep learning frameworks going by the number of GitHub projects based on it. In this tutorial, you got an overview of TensorFlow, learned which platforms support it, and looked at installation considerations.

If you're ready to see some samples using TensorFlow, take a look at the [Accelerate training of machine learning algorithms](https://developer.ibm.com/code/journey/accelerate-training-of-machine-learning-algorithms/) and [Image recognition training with PowerAI notebooks](https://developer.ibm.com/code/journey/image-recognition-training-powerai-notebooks/) developer code patterns.

* * *

#### Downloadable resources

* [PDF of this content](cc-get-started-tensorflow-pdf.pdf)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
