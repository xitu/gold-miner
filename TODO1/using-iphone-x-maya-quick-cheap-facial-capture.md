> * 原文地址：[Using iPhone X With Maya For Quick And Cheap Facial Capture](https://uploadvr.com/using-iphone-x-maya-quick-cheap-facial-capture/)
> * 原文作者：[IAN HAMILTON](https://uploadvr.com/author/ian-hamilton/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/using-iphone-x-maya-quick-cheap-facial-capture.md](https://github.com/xitu/gold-miner/blob/master/TODO1/using-iphone-x-maya-quick-cheap-facial-capture.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[luochen1992](https://github.com/luochen1992)、[melon8](https://github.com/melon8)

# 使用 iPhone X 与 Maya 实现快速面部捕捉

![](https://cdn.uploadvr.com/wp-content/uploads/2017/12/iphoneX-to-Maya.jpg)

iPhone X 能否成为一个快速、廉价、简单的面部捕捉系统？大约在一个月前，Kite & Lightning 的科里·斯特拉斯伯格收到了苹果公司的一部 iPhone X。不到一天，他就在用 TrueDepth 相机和 ARKit 来测试软件。他想看看这台手机是否可以用于他们的游戏和电影内容。

Kite & Lightning 是 Oculus VR 开发工具包早期的创新者，还使用一些引人注目的人物捕捉技术构建了像 [Senza Peso](http://kiteandlightning.la/senza-peso/) 那样等突破性的体验。现在，他们正在建造巴比伦皇家战役。游戏围绕着这些有巨大态度的 “beby” 角色展开。他想知道是否可以通过使用 iPhone X 面部捕捉来更快更廉价地完成赋予这些角色一个比较大的个性，他在周末花一些时间在上面。

“我认为目前我得出的一个重大结论是：iPhone X 所捕获数据非常微妙、稳定而且不会过度平滑，”斯特拉斯伯格在一封电子邮件中写道：“它实际上能够捕捉到非常微妙的动作，甚至是微小的抽搐，它已经足够干净(无噪音)，可以在手机上直接使用，当然这取决于你的标准。”

他认为这是一种相对便宜的面部捕捉的可行方法。该系统也是可移动的，可以使它更容易建立和部署。苹果收购了一家名为 Faceshift 的公司，该公司似乎为这项功能提供了很大的动力。虽然斯特拉斯伯格指出 Faceshift 的解决方案还有其他一些很酷的功能，但他已经能够用苹果所发布的 iPhone X 提取出足够的表现力，这可能对虚拟现实的制作仍然是有用的。

* YouTube 视频链接：https://youtu.be/w047Dbo-fGQ

## 捕捉过程

下面是斯特拉斯伯格概述为了获取 iPhone X 的面部捕捉数据，并用它来激活动画角色在 Maya 中的表情全过程：

*   使用苹果 ARKit 和 Unity，我导入了一个正在开发中的 Bebylon 角色，并将其面部表情混合形状和 ARKit 输出的面部捕捉数据挂钩。 这让我可以根据自己的表情来驱动婴儿的脸部动画。
*   我需要捕捉这个表情数据，以便导入到 Maya 中。我添加了一个记录函数，将面部表情数据传入文本文件中。然后保存在本地的 iPhone 上。捕获的每一个表情从起始到停止都会被存成一个单独的文本文件，并且可以在捕获应用程序中命名或重命名。
*   我通过 USB 将文本文件从 iPhone X 复制到桌面。
*   为了导入到 Maya 中，捕捉的数据需要重新格式化，因此我编写了一个简单的桌面应用程序来实现这一点。它能够获取所选的文本文件并将它们转换为 Maya .anim 文件。
*   我将 .anim 文件导入到 Maya 和 voila 中，你的角色会模仿你在捕捉过程中在 iPhone 看到的自己的样子。

据斯特拉斯伯格所说，他看到数据中出现了几个小漏洞，认为可能是他的代码所造成的。此外，尽管捕获发生在 60 帧每秒，但是这个过程目前呈现在 30 帧每秒，所以你可以看到一些质量上的损失。根据斯特拉斯伯格的说法，这一点在“马唇”部分中最为显著。

“这个系统真正的美妙之处在于它非常快和容易捕捉(就在你的手机上)，然后导入到 Maya 或游戏引擎中，”斯特拉斯伯格写道：“在任何时候都没有涉及到真正的处理过程，数据看起来也很干净，并且可以直接通过手机来使用未经修改的数据。”

![](https://cdn.uploadvr.com/wp-content/uploads/2017/12/processOverview.jpg)

## 下一步

斯特拉斯伯格希望能将 iPhone X 安装在头盔上，然后同时用 Xsens 套装进行全身运动，同时还能人脸捕捉。

“我非常有信心，通过调整形状融合变形器的参数雕塑造型，以及添加适当的皱纹贴图，可以在脸部动画时使皮肤变形，从而能够显着改善 beby 这个角色。”斯特拉斯伯格写道：“同样，使用捕捉到的数据来驱动次级混合变形，表情将感觉更有活力和生动。”


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
