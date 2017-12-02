> * 原文地址：[Getting started with TensorFlow —— IBM](https://www.ibm.com/developerworks/opensource/library/cc-get-started-tensorflow/index.html?social_post=1166248547&fst=Learn)
> * 原文作者：[Vinay Rao](https://developer.ibm.com/author/vinay.rao/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/get-started-tensorflow.md](https://github.com/xitu/gold-miner/blob/master/TODO/get-started-tensorflow.md)
> * 译者：
> * 校对者：

# Getting started with TensorFlow

In the context of machine learning, _tensor_ refers to the multidimensional array used in the mathematical models that describe neural networks. In other words, a tensor is usually a higher-dimension generalization of a matrix or a vector.

Through a simple notation that uses a rank to show the number of dimensions, tensors allow the representation of complex _n_-dimensional vectors and hyper-shapes as _n_-dimensional arrays. Tensors have two properties: a datatype and a shape.

## About TensorFlow

TensorFlow is an open source deep learning framework that was released in late 2015 under the Apache 2.0 license. Since then, it has become one of the most widely adopted deep learning frameworks in the world (going by the number of GitHub projects based on it.).

TensorFlow traces its origins from Google DistBelief, a proprietary production deep learning system developed by the Google Brain project. Google designed TensorFlow from the ground up for distributed processing and to run optimally on Google's custom application-specific integrated circuit (ASIC) called the Tensor Processing Unit (TPU) in its production data centers. This design makes TensorFlow efficient for deep learning applications.

The framework can run on the CPU, GPU, or TPU on servers, desktops, and mobile devices. Developers can deploy TensorFlow on multiple operating systems and platforms either locally or in the cloud. Many developers consider TensorFlow to have better support for distributed processing and greater flexibility and performance for commercial applications than similar deep learning frameworks such as Torch and Theano, which are also capable of hardware acceleration and widely used in academia.

Deep learning neural networks typically consist of many layers. They transfer data or perform operations between layers using multidimensional arrays. A tensor flows between the layers of a neural network—thus, the name TensorFlow.

The main programming language for TensorFlow is Python. `C`++, the Java® language, and the Go application programming interface (API) are also available without stability promises, as are many third-party bindings for `C`#, Haskell, Julia, Rust, Ruby, Scala, R, and even PHP. Google recently announced a mobile-optimized TensorFlow-Lite library to run TensorFlow applications on Android.

This tutorial provides an overview of the TensorFlow system, including the framework's benefits, supported platforms, installation considerations, and supported languages and bindings.

## Benefits of TensorFlow

TensorFlow offers developers many benefits:

*   Computational graph model. TensorFlow uses data flow graphs called directed graphs to express computational models. This makes it intuitive for developers who can easily visualize what's going on within the neural network layers by using built-in tools and perfect their neural network models by adjusting parameters and configurations interactively.
*   Simple-to-use API. Python developers can use either the TensorFlow raw, low-level API, or core API, to develop their own models or use the higher-level API libraries for built-in models. TensorFlow has many built-in and contributed libraries, and it is also possible to overlay a higher-level deep learning framework such as Keras to act as a high-level API.
*   Flexible architecture. A major advantage of using TensorFlow is that it has a modular, extensible, and flexible design. Developers can easily move models across CPU, GPU, or TPU processors with few code changes. Although originally designed for large-scale distributed training and inference, developers also can use TensorFlow to experiment with other machine learning models and system optimization of existing models.
*   Distributed processing. Google Brain designed TensorFlow from the ground up for distributed processing on its custom ASIC TPU. In addition, TensorFlow can run on multiple NVIDIA GPU cores. Developers can take advantage of the Intel Xeon and Xeon Phi-based x64 CPU architectures or ARM64 CPU architectures. TensorFlow can run on multiarchitecture and multicore systems as well as a distributed process that farms out compute-intensive processing as worker tasks. Developers can create clusters of TensorFlow servers and distribute the computational graph across those clusters for training. TensorFlow can perform distributed training either synchronously or asynchronously, both within the graph and between graphs and can share the common data in memory or across networked compute nodes.
*   Performance. Performance is often a contentious topic, but most developers understand that any deep learning framework depends on the underlying hardware to run optimally to achieve high performance with a low energy cost. Typically, the native development platform of any framework would achieve the best optimization. TensorFlow performs best on Google TPUs, but it manages to achieve high performance on various platforms—not just servers and desktops but also embedded systems and mobile devices. The framework supports a surprising number of programming languages, as well. Although another framework running natively, such as IBM Watson® on the IBM platform, might sometimes outperform TensorFlow, it's still a favorite with developers because artificial intelligence projects can span platforms and programming languages targeting multiple end applications, all of which need to produce consistent results.

## TensorFlow applications

This section looks at the applications that TensorFlow is good at. Obviously, because Google was using its proprietary version of TensorFlow for text and voice search, language translation, and image search applications, the major strengths of TensorFlow are in classification and inference. For example, Google implemented RankBrain, the engine that ranks Google search results, in TensorFlow.

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
