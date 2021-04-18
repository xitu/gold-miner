> * 原文地址：[Google's Apollo AI for Chip Design Improves Deep Learning Performance by 25%](https://www.infoq.com/news/2021/03/google-ai-chip-design)
> * 原文作者：[Anthony Alford](https://www.infoq.com/profile/Anthony-Alford/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/google-ai-chip-design.md](https://github.com/xitu/gold-miner/blob/master/article/2021/google-ai-chip-design.md)
> * 译者：[PingHGao](https://github.com/PingHGao)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin)，[Chorer](https://github.com/Chorer)

# Google 的 Apollo 芯片设计人工智能框架将深度学习芯片的性能提高了 25％

[Google Research](https://research.google/) 的科学家公布了一种用于优化人工智能加速器芯片设计的新框架 [APOLLO](https://arxiv.org/abs/2102.01723)。APOLLO 使用革命性的算法选择芯片参数，以最小的芯片面积最大程度地减少深度学习推理延迟。在阿波罗的帮助下，研究人员找到了比那些通过基线算法选择的设计快 24.6% 的设计方案。

研究科学家 Amir Yazdanbakhsh 在最近的博客文章中对该系统进行了概述。APOLLO 搜索一组硬件参数，例如内存大小、I/O 带宽和处理器单元，为给定的深度学习模型提供最佳的推理性能。通过使用革命性的算法和迁移学习，APOLLO 可以有效地探索参数空间，从而减少设计的总体时间和成本。Yazdanbakhsh 认为：

> 我们相信，这项研究是一条令人激动的前进道路，可以进一步探索机器学习技术驱动的架构设计和跨计算堆栈的协同优化（如编译器、映射和调度），为未来的应用开发具有新特性的高效加速器。

深度学习模型已经在多个领域得到了应用，从计算机视觉（CV）到自然语言处理（NLP）。但是，这些模型在推理时通常需要大量的计算和内存资源，从而使边缘和移动设备的硬件约束更加紧张。定制硬件加速器，例如 [Edge TPU](https://www.infoq.com/news/2020/12/google-coral-ai-iot/)，可以改善模型推理延迟，但通常需要对模型进行修改，例如参数量化或[模型修剪](https://www.infoq.com/presentations/tensorflow-lite/)。包括 [Google 团队](https://arxiv.org/abs/2003.02838)在内的一些研究人员已经建议使用 AutoML 设计针对特定加速器硬件的高性能模型。

相比之下，APOLLO 团队的策略是定制加速器硬件，以优化给定深度学习模型的性能。加速器基于处理元件（PE）的 2D 阵列，每个处理元件包含多个[单指令多数据](https://www.sciencedirect.com/topics/computer-science/single-instruction-multiple-data)（SIMD）内核。可以通过几个不同的参数的取值来定制此基本模式，这些参数包括 PE 阵列的大小、每个 PE 的内核数以及每个内核的内存量。总体而言，设计空间中有近 500M 个参数组合。由于提出的加速器设计必须在软件中进行仿真，因此在深度学习模型上评估其性能既耗时又需要大量计算。

APOLLO 建立在 Google 内部的 [Vizier](https://research.google/pubs/pub46180/) “黑匣子”优化工具之上，并且 Vizier 的优化贝叶斯方法用作评估 APOLLO 性能的基准。APOLLO 框架支持多种优化策略，包括随机搜索、[基于模型的优化](https://research.google/pubs/pub49138/)、进化搜索以及称为基于种群的黑盒优化（P3BO）的集成方法。该谷歌团队进行了数个实验，为一系列的计算机视觉模型寻找最佳加速器参数集，包括 [MobileNetV2](https://ai.googleblog.com/2018/04/mobilenetv2-next-generation-of-on.html) 和 [MobileNetEdge](https://ai.googleblog.com/2019/11/introducing-next-generation-on-device.html)，用于三个不同的芯片面积约束。他们发现 P3BO 算法产生了最好的设计，并且与 Vizier 相比，随着可用芯片面积的减少，性能差距更加明显。与手动引导的穷举搜索或“蛮力搜索”相比，P3BO 发现了更好的配置，同时执行的搜索评估减少了 36％。

用于改善 AI 推理的加速器硬件设计是一个活跃的研究领域。苹果新的 [M1 处理器](https://www.infoq.com/news/2020/11/apple-tensorflow-acceleration/)就包括了一个神经引擎，旨在加速 AI 计算。斯坦福大学的研究人员最近在《自然》杂志上发表了一篇文章，描述了一个名为 [Illusion](https://ee.stanford.edu/news/research-news/01-19-2021/subhasish-mitra-hs-philip-wong-and-mary-wootters-system-can-run-ai) 的系统，该系统使用较小芯片的网络来模拟单个较大的加速器。在 Google，科学家也发表了有关[优化芯片布局](https://ai.googleblog.com/2020/04/chip-design-with-deep-reinforcement.html)的工作，以寻找集成电路组件在物理芯片上的最佳放置策略。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
