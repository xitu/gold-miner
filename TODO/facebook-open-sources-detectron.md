> * 原文地址：[Facebook open sources Detectron](https://research.fb.com/facebook-open-sources-detectron/)
> * 原文作者：[Ross Girshick](https://research.fb.com/people/girshick-ross/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/facebook-open-sources-detectron.md](https://github.com/xitu/gold-miner/blob/master/TODO/facebook-open-sources-detectron.md)
> * 译者：[SeanW20](https://github.com/SeanW20)
> * 校对者：[noahziheng](https://github.com/noahziheng)、[dazhi1011](https://github.com/dazhi1011)

# Facebook开源Detectron

![](https://i.loli.net/2018/01/24/5a682bb6c9193.png)

今天（译者注：2018 年 1 月 24 日），Facebook AI Research(FAIR) 研究机构开源了 [Detectron](https://research.fb.com/downloads/detectron/) —— 我们最先进的目标检测研究平台。

Detectron 项目在 2016 年 7 月启动，目的是建立一个基于 Caffe2 上的快速灵活的物体检测系统。当时还在进行 Alpha 阶段的开发。在过去的一年半里，代码库已经成熟并且支持了我们的大量项目，包括 [Mask R-CNN](https://arxiv.org/abs/1703.06870) 和 [Focal Loss for Dense Object Detection](https://arxiv.org/abs/1708.02002)，在 2017 年的 ICCV 上这两个项目分别获得了 Marr 奖和最佳学生论文奖。由 Detectron 提供支持的这些算法为一些重要的计算机视觉任务，例如实现实例分割，提供了直观的模型，并且近年来在由我们社区完成的视觉感知系统中发挥了重要作用，这套系统已经取得空前成就。

除了研究，许多 Facebook 团队使用这个平台来训练各种应用的定制模型，包括增强现实和社区完整性。一旦开始训练，这些模型可以部署在云端和移动设备上，由高效的 Caffe2 运行时提供支持。

我们开源 Detectron 的目标是使我们的研究尽更加开放，并加速在全球实验室的研究。随着其发布，科研界同仁将能够重现我们的结果，并能够使用 FAIR 的相同软件平台。

Detectron 可以在 Apache2.0 许可证下获得 [https://github.com/facebookresearch/Detectron](https://github.com/facebookresearch/Detectron). 我们还发布了 70 多种预训练模型的广泛性能基准，可以从我们的模型库中下载。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
