> * 原文地址：[Should You Really be Coding in Dark Mode?](https://dev.to/codesphere/should-you-really-be-coding-in-dark-mode-4ng8)
> * 原文作者：[Saji Wang](https://dev.to/sewangco)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/should-you-really-be-coding-in-dark-mode.md](https://github.com/xitu/gold-miner/blob/master/article/2021/should-you-really-be-coding-in-dark-mode.md)
> * 译者：[kamly](https://github.com/kamly)
> * 校对者：[Zz招锦](https://github.com/zenblo), [Kim Yang](https://github.com/KimYangOfCat)

# 你真的应该在黑暗模式下进行编码吗?

![](https://res.cloudinary.com/practicaldev/image/fetch/s--a0VqOvf_--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/4a6t7pmm323uaz9rv1rf.png)

在关于用户体验的开发中，很少有像色彩模式这样有争议的争论。然而，在开发人员中，似乎有一个很明显的倾向，那就是在黑暗模式下进行编码。([这项调查](https://css-tricks.com/poll-results-light-on-dark-is-preferred/) 发现被调查的开发人员中，有 2/3 人更喜欢在他们的代码编辑器中使用黑暗模式)。

![](https://res.cloudinary.com/practicaldev/image/fetch/s--UJZ5SGo2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/7wlt8u1cv5hd8ts4nvj5.png)

黑暗模式的倡导者列举了许多好处，包括减少眼睛疲劳、改善睡眠和降低功耗。虽然许多关于黑暗模式的论点无疑是有道理的，但对它的许多好处还远未达成科学共识。

## 历史的小插曲

虽然我们可能认为黑暗模式是一个相对较新的趋势，但它实际上是最初用于计算机的颜色方案。大多数早期的计算机在黑暗背景上使用浅色文本，以节省电力。然而，随着计算机变得更加适合消费者，开发人员开始在白色背景上使用黑色文本，以模仿大多数人习惯的白纸上的黑色墨水。

最近，无数的设备、网站和应用程序出于光学和美学的原因，都增加了对黑暗模式的支持。软件开发人员，他们大部分工作时间都盯着电脑屏幕，一直是黑暗模式的最狂热的倡导者之一。

## 1. 眼睛的疲劳和可读性

黑暗模式的第一个论点是值得一看的，即黑暗模式对你的眼睛更好。虽然毫无疑问，在黑暗的房间里使用灯光模式会让人眼花缭乱，但似乎也有证据表明，我们的大脑更擅长阅读和理解白色屏幕上的黑色文字。

例如，心理学家 Cosima Piepenbrock 博士[在 2013 年的一项研究](https://www.researchgate.net/publication/264903980_Smaller_pupil_size_and_better_proofreading_performance_with_positive_than_with_negative_polarity_displays)中考察了视力正常的成年人在深色和浅色方案中的视力和校对文字的表现。该研究发现:

> "瞳孔大小较小，正极性（暗对亮）比负极性（亮对暗）的校对表现更好。"

换句话说，对于专注于阅读文本的实质性数字任务（如编码）， **在浅色背景上有深色文本（例如：浅色模式）可以帮助你更好地集中注意力和理解。**

这项实践意味着，如果你的 IDE 处于黑暗模式，你的眼睛和大脑可能不得不更加努力地阅读和编写代码。

## 2. 蓝光与睡眠

另一个经常被引用的说法是，在黑暗模式下使用你的 IDE 可以减少蓝光伤害，因此可以帮助你睡眠。虽然黑暗模式肯定会减少蓝光，但蓝光可能并不是真正扰乱你睡眠时间表的主要罪魁祸首。

曼彻斯特大学[在 2019 年的一项研究](https://www.sciencedaily.com/releases/2019/12/191216173654.htm)发现，阻挡蓝光只能稍微改善人们的睡眠模式。相反，真正的罪魁祸首是在晚上使用较温暖的颜色（如红色和黄色），这会误导我们的大脑，使其认为现在是白天。

如果你想获得更好的睡眠，黑暗模式客观上可能会有帮助，但真正的解决方案是在睡觉前完全不使用屏幕。

## 3. 消耗电量

在你的 IDE 中使用黑暗模式的另一个论点是，它可以为你节省电费。如果你使用的是 OLED 显示器，而大多数现代显示器都是 OLED ，那确实可以。

然而，可能需要注意的是，如果你正在开发计算量大的软件，如渲染 3D 图形或训练和使用机器学习模型，黑暗模式减少的功耗可能不会对你的电费产生任何明显的影响。

## 4. 无障碍性

无论你个人在编码时喜欢什么，你都应该在你构建的软件中添加对黑暗和光明模式的支持。许多有某些色盲或眼疾的人都会发现其中一个主题非常难用，甚至无法使用。因此，给你的用户提供灵活性是非常重要的。

## 总结

总而言之，黑暗模式是否真的对编码更有利，目前还没有定论。虽然它可能为你节省少量的电力，而且如果你在晚上使用，对你的睡眠时间略有帮助，但这些好处似乎并不是那么实质性。此外，白底黑字可能有助于你更有效地阅读和编写代码。

因此，你的主题应该归结为什么是最适合你的，因为并没有一个科学的共识，即一种颜色方案会比另一种更好。如果你认为黑暗模式看起来更时尚，而且你在晚上或黑暗中做大量的编码工作，那么就继续使用黑暗模式。如果你喜欢浅色背景上的深色文本的可读性，那么就继续使用浅色模式。

那么，你喜欢哪种模式，为什么？就个人而言，我认为黑暗模式更有美感，但我肯定注意到它可能更难阅读。

请在评论中告诉我们你的想法！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
