> * 原文地址：[Dark Theme: A Modern UI Design](https://levelup.gitconnected.com/dark-theme-a-modern-ui-design-dec879313194)
> * 原文作者：[Umair Feroze](https://medium.com/@umayir10)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/dark-theme-a-modern-ui-design.md](https://github.com/xitu/gold-miner/blob/master/article/2020/dark-theme-a-modern-ui-design.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[zhuzilin](https://github.com/zhuzilin)、[regon-cao](https://github.com/regon-cao)

# 黑暗主题 — 现代 UI 设计

![Photo by [Mathew Schwartz](https://unsplash.com/@cadop?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6500/0*-6vxFqCRAb7BkbAE)

用户体验和用户界面是任何成功的软件应用的基本考虑因素。因此，开发者们已经决定采用黑暗主题界面（作为可选主题）为用户提供服务，让用户减轻眼睛疲劳（尤其是在弱光或黑暗环境下）。

昏暗的灯光主要是减轻压力和节省能源。黑暗主题是使用较暗的颜色（通常是黑色或灰色阴影）作为其主要背景颜色的低光界面。这是对设计师多年来一直使用的默认白色 UI 的一种颠覆。

夜间模式和黑暗主题已成为现代 UI 设计中的一种新兴形式，许多大公司（如 [WhatsApp](https://faq.whatsapp.com/iphone/account-and-profile/how-to-use-dark-mode/?lang=fb)，[Instagram](https://www.facebook.com/help/instagram/897760233943762?helpref=search&sr=1&query=dark%20mode&search_session_id=b3d02d9c67450e4b3c3ade2ee6125d3a)，[Google](https://support.google.com/chrome/answer/9275525?co=GENIE.Platform%3DAndroid&hl=en#:~:text=Turn%20on%20Dark%20theme,Dark%20theme%20in%20device%20settings.)，[Facebook](https://www.facebook.com/help/community/question/?id=126591948482539) 和 [Apple](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode)）已经采纳了这种新趋势。

## 为什么选择黑暗主题

作为软件工程师，我们的主要目标之一就是要让客户满意，而这又取决于终端用户的体验效果。这意味着应该用简单易用的方式设计和实现 UI。

人们为什么更喜欢黑暗模式：

* 屏幕使用时长增加
* 在弱光或黑暗情况下缓解眼睛疲劳
* 增加弱光环境下照明的可见度
* 更少的眼睛疲劳意味着更少的头痛和更好的工作体验

虽然高色彩对比可以提高可读性，但是纯黑白对比反而让用户读起来更费劲。

## 选择调色板

纯黑色和纯白色都不合适。因为白色相当于 100％，而黑色相当于 0％。因此，这种差异会产生强烈的光线效果，从而过度刺激眼睛。眼睛的这种不适会引起眼睛疲劳，令很多人反感。在填充你的调色板时，有以下几点建议：

#### 避免纯黑色

没有书是用纯黑或纯白的。这是因为黑白对比过于鲜明，让读者只得眯眼阅读。这终将导致读者头痛，体验不好。因此，请避免使用纯黑色作为背景色。

#### 使用适当的对比度

黑暗模式背景必须足够暗，以显示白色文本。否则，对用户来说文本的可读性就不高了。[谷歌材料设计](https://material.io/design/color/dark-theme.html)建议使用至少 `15.8:1` 的文本-背景对比度。因此，最好明智地调整你的调色板的对比度。

#### 使用去饱和的颜色

当在黑暗的表面上观察时，完全饱和的颜色会“**振动**”，妨碍可读性，让人非常不舒服。因此，请避免使用完全饱和的颜色。请用不饱和的颜色比如白色和灰色的柔和色调来替换它。

#### 不要直接反转颜色

获得黑暗主题**不是**简单地反转颜色。UI 中的一些颜色具有一定的心理学意义，直接反转这些颜色可能会变得毫无意义并很荒谬。因此，在为你的调色板选择颜色时，一定要考虑周全。

#### 可视化层次结构

对所有层使用相同的颜色会妨碍良好的 UI 设计实践，并可能导致可读性差。因此，建议对较高层使用较浅的色调，对较低层使用较暗的色调。这将创建一个从你的界面中最常用的元素到最不常用的元素的视觉层次结构。

## 白色文本的背景颜色建议

美国验光师协会（[AOA](https://www.aoa.org/?sso=y)）的一项调查发现，美国 58% 的成年人因使用电脑而眼睛疲劳。对此，参考来自 [UX Bucket](https://uxbucket.com/author/rushabh-kulkarni/) 的 [Rushabh Kulkarni](https://www.instagram.com/rushabhuix/?hl=en) 有一些关于设计黑暗主题的建议：

我建议在中型手机应用程序（测试版）上以黑暗模式查看这些颜色，以获得更好的视觉清晰度。可悲的是，黑暗模式在网页上是不可用的。但是，你可以通过安装一个 [chrome 扩展](https://chrome.google.com/webstore/detail/medium-dark-mode/kofkfocgjmlajkbkecljhbalihcpliih?hl=en)来达成这一功能。

#### \#303030

[HEX color #303030, Color name: Night Rider, RGB(48,48,48), Windows: 3158064](https://www.htmlcsscolor.com/hex/303030)

#### \#2B2B2B

[HEX color #2B2B2B, Color name: Night Rider, RGB(43,43,43), Windows: 2829099](https://www.htmlcsscolor.com/hex/2B2B2B)

#### \#1F1F1F

[HEX color #1F1F1F, Color name: Nero, RGB(31,31,31), Windows: 2039583](https://www.htmlcsscolor.com/hex/1F1F1F)

#### \#1B1C1E

[HEX color #1B1C1E, Color name: Black Russian, RGB(27,28,30), Windows: 1973275](https://www.htmlcsscolor.com/hex/1B1C1E)

正如你所看到的，这些颜色不是纯黑白的，可读性很强。并且从 `#303030` 向下滚动到 `#1B1C1E`，我们可以直观的看到向下滚动时背景颜色越来越深。

## 黑暗模式不等同黑色模式

以上建议主要针对使用纯黑白色的方案。然而，当谈到黑暗模式时，也有使用其他颜色组合的方案。方案中可以以任何深色调的颜色作为背景。

我将过一下我最喜欢和最常用的应用程序，以及它们的黑暗模式功能。让我们快速浏览它们，如下所示：

#### Whatsapp

![Image Source: [https://9to5google.com/wp-content/uploads/sites/4/2020/03/WhatsApp-dark-mode-official.jpg?quality=82&strip=all](https://9to5google.com/wp-content/uploads/sites/4/2020/03/WhatsApp-dark-mode-official.jpg?quality=82&strip=all)](https://cdn-images-1.medium.com/max/4000/1*YYtHVixWlaPSxbbF55IbbQ.jpeg)

Whatsapp 使用**深绿色**主题，与通常的绿色主题完美融合。在上图中，你可以看到它们如何根据组件的重要性和控制级别，在屏幕上对组件进行优先级排序。

#### Twitter

![Image Source: [https://9to5mac.com/wp-content/uploads/sites/6/2019/03/Twitter-black-dark-mode-iOS-iPhone-lead.jpeg?quality=82&strip=all](https://9to5mac.com/wp-content/uploads/sites/6/2019/03/Twitter-black-dark-mode-iOS-iPhone-lead.jpeg?quality=82&strip=all)](https://cdn-images-1.medium.com/max/4824/1*RKfQZYdz6-vdReyFwg5Rqg.jpeg)

Twitter 使用了**深蓝色**和较浅黑色的奇妙混合。此外，请注意组件的优先级已从较浅的阴影分割为较深的阴影。

#### Instagram

![Image Source: [https://miro.medium.com/max/16424/1*d8-4IYqquJ0yGIKZ3bjzWg.png](https://miro.medium.com/max/16424/1*d8-4IYqquJ0yGIKZ3bjzWg.png)](https://cdn-images-1.medium.com/max/8000/1*0Nm6mbqGpnGD8xUmtVVYrg.png)

Instagram 使用的主题比其他应用程序更黑。黑色与较深的灰色阴影妥协，将主控件推向更高的级别，将内容推向更深的层次。

正如我上面提到的，还有其他大公司，比如 Google、Facebook、Apple 等。他们将黑暗模式引入到产品中，并提供了他们推荐的配色方案。

因此，黑暗模式并不总是黑白的。它可以根据业务、组织或客户偏好的颜色组合进行不同的定制。

## 结论

技术呈指数级发展，环顾四周，每个人要么使用计算机，要么使用移动设备。这证实了我们作为软件工程师为最终用户提供最佳用户体验的责任。

黑暗主题时代刚刚兴起，这是黑暗主题和创造性 UI 设计的最佳时机！引入创造力，让结果自己说话。

希望本文带给你在做现代 UI 设计的黑暗主题时要考虑的因素。祝学习愉快，工作顺利！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
