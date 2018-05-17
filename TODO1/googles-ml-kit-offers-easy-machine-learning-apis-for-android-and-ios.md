> * 原文地址：[Google’s ML Kit offers easy machine learning APIs for Android and iOS](https://arstechnica.com/gadgets/2018/05/googles-ml-kit-offers-easy-machine-learning-apis-for-android-and-ios/)
> * 原文作者：[RON AMADEO](https://arstechnica.com/author/ronamadeo/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/googles-ml-kit-offers-easy-machine-learning-apis-for-android-and-ios.md](https://github.com/xitu/gold-miner/blob/master/TODO1/googles-ml-kit-offers-easy-machine-learning-apis-for-android-and-ios.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[kezhenxu94](https://github.com/kezhenxu94/)

# Google 的 ML Kit 为 Android 和 iOS 提供了简单的机器学习 API

普通人也可以通过简单的 API 调用将机器学习功能添加到他们的应用程序中。

![](https://cdn.arstechnica.net/wp-content/uploads/2018/05/social-1-800x400.png)

加州山景城 —— 谷歌正在为其 Firebase 开发平台推出一款新的机器学习 SDK，名为“ML Kit”。新的 SDK 为一些最常见的计算机视觉用例提供了现成的 API，允许那些不是机器学习专家的开发人员给他们的应用程序添加一些机器学习的魔法。这不仅仅是一个Android SDK；它同样也适用于 iOS 的应用。

通常来说，建立一个机器学习环境是一项艰巨的工作。你必须学习如何使用像 TensorFlow 这样的机器学习库，获取大量的训练数据来教你的神经网络做一些事情，并且最终，你需要它输出一个足够轻量的模型在移动设备上运行。ML Kit 简化了这一切流程，只需在 Google 的 Firebase 平台上调用某些机器学习特性即可。

![](https://cdn.arstechnica.net/wp-content/uploads/2018/05/Introducing_ML_Kit_Embarg-001-980x628.jpg)

新的 API 支持文本识别、人脸检测、条形码扫描、图像标记和地标识别功能。每个 API 都有两个版本：一个是基于云的版本，它通过使用某些数据作为代价来提供更高的准确性，而本地设备上的版本即使在离线的情况下也可以正常运作。对于照片，本地版本的 API 可以识别图片中的狗，而更精确的基于云的 API 可以确定狗的具体品种。本地 API 是免费的，而基于云的 API 使用通常的 Firebase cloud API 来定价。

如果开发人员确实使用基于云的 API，那么所有数据都不会保留在 Google 的云上。一旦处理完成，数据就会被删除。

今后，谷歌将为智能回复添加一个 API。这一机器学习功能将在谷歌收件箱中首次出现，它将扫描电子邮件，对你的邮件生成几个简短回复，你只需轻轻点击即可发送出去。此功能将在初步预览中首次推出，并且计算始终在设备上本地完成。还有一个“高密度的面部轮廓”功能即将出现在人脸检测 API，这对于那些在你的脸上粘贴虚拟物品的增强现实应用来说是个完美的选择。

* YouTube 视频链接：https://youtu.be/ejrn_JHksws

ML Kit 还提供了一个选项，可以将机器学习模型与应用程序解耦，并将模型存储在云中。根据 Google 的说法，由于这些模型可以达到“数十兆字节的大小”，将其卸载到云端应该提高应用程序安装速度。模型首先在运行时下载，因此它们在第一次运行后就能够脱机工作，并且应用程序将下载任何以后的模型更新。

这些机器学习模型的规模庞大是个问题，Google 正试图用未来基于云计算的机器学习压缩方案来解决这个问题。谷歌的计划是最终采用完整的 TensorFlow 模型，并以相似的精度推出压缩的 TensorFlow Lite 模型。

ML Kit 与 Firebase 的其他功能也能很好的进行协作，比如 RemoteConfig，它允许在用户基础上对机器学习模型进行 A/B 测试。Firebase 还可以动态切换或更新模型，而无需更新应用程序。

希望尝试使用 ML Kit 的开发者可以在 [Firebase console](https://console.firebase.google.com/u/0/project/_/ml?pli=1) 中找到它。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
