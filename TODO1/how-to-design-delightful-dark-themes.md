> * 原文地址：[How to design delightful dark themes](https://blog.superhuman.com/how-to-design-delightful-dark-themes-7b3da644ff1f)
> * 原文作者：[Teresa Man](https://medium.com/@ifbirdsfly)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-design-delightful-dark-themes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-design-delightful-dark-themes.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[药王](https://github.com/ArcherGrey), [HytonightYX](https://github.com/HytonightYX)

# 如何设计一款讨人喜欢的暗色主题

![](https://cdn-images-1.medium.com/max/4800/1*SNt7SUZucQ3r7aHctIM0xw.png)

**在 [Superhuman](https://superhuman.com/?utm_source=medium&utm_medium=blog&utm_campaign=delightful-dark-themes)，我们正在打造世界上最快的电子邮件体验。您可以体验到以两倍于以前的速度浏览您的收件箱，并且保持收件箱为零！**

暗色主题是应用程序设计的最新趋势。macOS 去年推出了[黑暗模式](https://www.apple.com/newsroom/2018/09/macos-mojave-is-available-today/)。Android 上月也推出了[黑暗主题](https://www.android.com/android-10/)。在过去的两周中，iOS [也紧跟而上](https://www.apple.com/ios/ios-13/)。

曾经很少见的暗色主题已成为人们普遍期望的主题。

如果做得好，暗色主题是有很多好处的。它可以减少眼睛疲劳，在弱光下也更容易阅读。而且，对于 OLED 屏幕来说，暗色主题可以大大降低电量消耗。

然而，创造一个讨人喜欢的暗色主题可不容易。我们不能简单地重用我们的颜色或颠倒我们的色调。如果我们这样做，往往会**适得其反**：我们将增加眼睛的疲劳，使其在弱光下更难阅读。我们甚至有可能打破我们软件的信息层次结构。

在这篇文章中，我们将会分享如何设计通俗易懂、和谐且讨人喜欢的暗色主题

## 1. 越远的区域越暗

大多数深色主题的 UI 设计都遵循这一原则：越远的区域越暗。这模拟了一个光源从上方投射的场景，并传达了熟悉且令人安心的实体感。

当设计一个暗色主题时，我们很容易想当然地将我们的浅色主题直接反转。然而，这样的话，远处的区域会变亮，而近处的区域会变暗。这将破坏真实感，令人感到不自然。

与此相反，您应该只取您的浅色主题的主要表面颜色。反转此颜色以产生暗色主题的主要颜色。对较近的表面调亮这种颜色，对较远的表面调暗这种颜色。

在 Superhuman 中，我们的暗色主题是由五种灰色色调构成的。较近的区域使用较浅的灰色，较远的区域使用较深的灰色。

![较近的区域使用较浅的灰色，较远的区域使用较深的灰色。](https://cdn-images-1.medium.com/max/5352/1*9XSo2QMW141R5hXUHrf8kA.png)

## 2. 重新确定感知对比度

通过原先的浅色主题来设计暗色主题时，很重要的一点是要重新确定感知对比度。注意，是这个元素**看起来的**对比度，而别被所谓的建议或标准所限制。

例如，在我们的浅色主题中，联系人信息是黑色的，不透明度为 60%。但是在我们的暗色主题中，我们将联系方式设置为白色，不透明度为65%。虽然这两种的对比度超过了 [AA 标准](https://accessible-colors.com)，但额外的 5% 可以防止视觉疲劳，特别是在光线不足的情况下。

对于这些颜色的补偿并没有严格的规定。我们可以根据文本大小、字体大小和行宽分别调整每个项目，以确保暗色主题与浅色主题一样清晰、易于阅读。

![](https://cdn-images-1.medium.com/max/5352/1*hM0hLogOLk0DQzVyqBL-6A.png)

## 3. 减少大块明亮的色彩

在浅色主题中，我们经常使用大块明亮的颜色。这一般来说都是对的：我们最重要的元素可能会更亮。但在暗色主题中，这是行不通的：用户会将焦点集中于大块的颜色反而忽视了我们最重要的元素。

例如，这是我们的 Remind me 界面。在我们的浅色主题中，粉红色的遮罩层不会分散在更明亮的对话框上的焦点。但是在我们的暗色主题中，同样的遮罩层将我们的注意力分散。我们完全去掉了遮罩层，这样我们就可以快速、方便地聚焦于重要的内容。

![减少大块明亮的色彩会更容易聚焦于重要的内容](https://cdn-images-1.medium.com/max/5352/1*ixjDo4iN1BgiuNOO_4hadg.png)

## 4. 避免纯黑色或纯白色

在 Superhuman 中，我们没有使用任何纯黑色或纯白色在我们的暗色主题。这样做有四个原因。

#### 4.1. 真实感

在我们的日常环境中并不存在纯黑色（世界上最黑的物体，麻省理工学院开发的一种[尚未命名的材料](http://news.mit.edu/2019/blackest-black-material-cnt-0913)，它离真正的纯黑色还差 0.005%）因此，我们的视觉已经适应了将相对的黑色视为真正的黑色。这就是为什么 `#000000` 会让我们感觉如此不和谐的原因，尤其是在与较亮的元素对比时。因为它不存在于与我们通常看到的任何东西的颜色上。

#### 4.2. 黑色拖影

黑色拖影是一种视觉失真，出现于当较亮的内容被拖动或滚动在纯黑色背景时。

这种效果出现在越来越多人使用的 OLED 屏幕上。在这种屏幕上，纯黑色像素被关闭（这就是暗色主题比浅色主题使用更少电量的原因）。然而，这些像素的开启和关闭的速度比颜色改变的速度要慢。这个不同速度的结果造成了拖影效果。

![在 iOS 时钟中出现的黑色拖影（必须在 OLED 屏中才能看到）。](https://cdn-images-1.medium.com/max/2000/1*eDiI4Yy-K6139EnLaAuSjA.gif)

你可以通过使用深灰色来避免黑色拖影，因为这样像素就不会被关闭。甚至可以使用像 `#010101` 这样的深灰色，并且还会比浅色主题使用更少的电量！

#### 4.3. 层次感

如果您在背景元素中使用了纯黑色，您会失去一些表现层次深度的技巧。

例如，想象您的背景是纯黑色的。在此之上，显示一个通知。通知应该浮在背景之上，所以您用阴影来表达深度。只是这样的阴影难以察觉，因为没有什么比纯黑色更暗。

如果您的背景不是纯黑色的，您可以使用不同不透明度的阴影和模糊来表达深度。例如，考虑 Superhuman 中的通知：

![如果您的背景不是纯黑色的，您可以使用不同不透明度的阴影和模糊来表达深度。](https://cdn-images-1.medium.com/max/5352/1*N4e5iEguoLP4l6vsWGDYmA.png)

#### 4.4. 眩晕

纯白色文本在纯黑色背景下可能产生的最高对比度为：21:1。在 WCAG（Web Content Accessibility Guidelines Web 内容无障碍指南） 中的无障碍说法中，这是理想输出。

然而，在设计暗色主题时，一定要小心过高的对比度。对比度太高会导致眼睛疲劳和**眩晕**。

当将非常明亮的文本放置在非常暗的背景下时，文本会看起来渗透在背景之中。这对于我们这些散光的人来说，影响甚至更强。[感觉感知与互动研究小组](http://www.cs.ubc.ca/labs/spin/)的博士后研究员 Jason Harrison 表示：

> 散光患者（约占总人口的 50% ）在阅读黑底白字内容时比阅读白底黑字内容更困难。这在一定程度上与光线有关：在明亮的显示背景（白色背景）下，虹膜闭合得更紧，减少了角膜（可以理解为可以变形的“镜片”）的影响；在黑色的背景下，虹膜会打开以接收更多的光线，而角膜的变形会使眼睛产生更模糊的焦点。

在 Superhuman 中，由于我们的软件文字很多，所以我们必须特别小心眩晕问题。我们把白色的文字设置为 90% 的不透明度，从而使文字与深色背景融为一体。这就平衡了对比度和亮度，使软件很容易在各种光线条件下阅读。

![](https://cdn-images-1.medium.com/max/5352/1*4D5E9fE--h9OMjYN382O5Q.png)

## 5. 加深颜色

由于我们调低了文本的色彩来避免眼睛疲劳和晕眩，因此我们的彩色强调内容和按钮可能显得太亮。现在，我们必须调整这些颜色以在暗色主题中更好地工作。首先，我们降低亮度，使这些颜色不会压制附近的文本。其次，我们增加饱和度，使它们仍然具有颜色特征。

例如，如果我们直接使用浅色主题中的紫色，对于附近的文本而言，它显得太亮了。所以，在我们实际的暗色主题中，我们加深了紫色，以便用户可以专注于文本内容。

![为暗色的主题创造更深的颜色；保持色调，降低亮度，增加饱和度。](https://cdn-images-1.medium.com/max/5352/1*CC8IvWLlP3uGqMkq4BQmXg.png)

---

## 结论

暗色主题有很多好处，现在正在被广泛期待。然而，做好一个暗色主题可不容易。简单地重用我们的颜色或颠倒我们的色调，将增加眼睛的疲劳，使其在弱光下更难阅读，甚至还有可能打破我们软件的信息层次结构。

我们找到了一种系统的方式来构建通俗易懂的，和谐且讨人喜欢的暗色主题。只需遵循以下步骤：

1. 越远的区域越暗
2. 重新确定感知对比度
3. 减少大块明亮的色彩
4. 避免纯黑色或纯白色
5. 加深颜色

我希望以上这些有助于您设计讨人喜欢的暗色主题。如果您有任何想法或疑问，可以和我聊聊！[@ifbirdsfly](https://twitter.com/ifbirdsfly)，[teresa@superhuman.com](mailto:teresa@superhuman.com) 👩‍🎨

— Teresa Man，Superhuman 的首席设计师

---

**在 Superhuman，我们正在重建针对 web 和移动设备的电子邮件体验。试想一下电子邮箱界的 Vim 或者 Sublime：惊人快速，视觉华丽。**

**如果您崇尚用优雅的方式解决有趣的问题 —— 请加入我们！[了解更多信息](https://superhuman.com/?utm_source=medium&utm_medium=blog&utm_campaign=delightful-dark-themes)或者[给我发电子邮件](mailto:teresa@superhuman.com).**

**非常感谢 [Jared Erondu](https://twitter.com/erondu)，[Dave Klein](https://twitter.com/diklein)，[Jayson Hobby](https://twitter.com/jaysonhobby)，[Tim Boucher](https://twitter.com/_timothee)，[Tamas Sari](https://twitter.com/tamassari) 以及 [Jiho Lim](https://twitter.com/jiholimm) 的付出和审查！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
