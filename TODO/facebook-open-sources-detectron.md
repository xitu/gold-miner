> * 原文地址：[Facebook open sources Detectron](https://research.fb.com/facebook-open-sources-detectron/)
> * 原文作者：[Ross Girshick](https://research.fb.com/people/girshick-ross/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/facebook-open-sources-detectron.md](https://github.com/xitu/gold-miner/blob/master/TODO/facebook-open-sources-detectron.md)
> * 译者：
> * 校对者：

# Facebook open sources Detectron

![](http://i.niupic.com/images/2018/01/24/GhLPV7.png)

Today, Facebook AI Research (FAIR) open sourced Detectron — our state-of-the-art platform for object detection research.

The Detectron project was started in July 2016 with the goal of creating a fast and flexible object detection system built on Caffe2, which was then in early alpha development. Over the last year and a half, the codebase has matured and supported a large number of our projects, including Mask R-CNN and Focal Loss for Dense Object Detection, which won the Marr Prize and Best Student Paper awards, respectively, at ICCV 2017. These algorithms, powered by Detectron, provide intuitive models for important computer vision tasks, such as instance segmentation, and have played a key role in the unprecedented advancement of visual perception systems that our community has achieved in recent years.

Beyond research, a number of Facebook teams use this platform to train custom models for a variety of applications including augmented reality and community integrity. Once trained, these models can be deployed in the cloud and on mobile devices, powered by the highly efficient Caffe2 runtime.

Our goal in open sourcing Detectron is to make our research as open as possible and to accelerate research in labs across the world. With its release, the research community will be able to reproduce our results and have access to the same software platform that FAIR uses every day.

Detectron is available under the Apache 2.0 license at https://github.com/facebookresearch/Detectron. We’re also releasing extensive performance baselines for more than 70 pre-trained models that are available to download from our model zoo.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
