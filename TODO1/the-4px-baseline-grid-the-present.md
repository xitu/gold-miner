> * 原文地址：[The 4px baseline grid — the present](https://uxdesign.cc/the-4px-baseline-grid-89485012dea6)
> * 原文作者：[Ethan Wang](https://medium.com/@SashimiEthan)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-4px-baseline-grid-the-present.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-4px-baseline-grid-the-present.md)
> * 译者：[Mcskiller](https://github.com/Mcskiller)
> * 校对者：[Charlo-O](https://github.com/Charlo-O)，[portandbridge](https://github.com/portandbridge)

# 感受 4px 基线网格带来的便利

![](https://cdn-images-1.medium.com/max/10000/1*JkmDuiUu5QoQRIB3yYolcw@2x.jpeg)

> 我已经使用 4px 基线网格 2 年多了，并且一直在试着让我的团队也使用它。最近我终于克服了我的拖延症并决定在我的第一篇 Medium 文章中讨论它。我正在寻求有关此方法的反馈，所以别管那么多了，请让我知道你们的想法！

---

## 问题

文本框边界总是会在文字上下占用额外的间距，这真的让我很头大。因此，当我使用边界框来测定间距的时候，就会导致最终间距比你预期的间距更大。文字行高越高，带来的问题就越明显。在下面的例子中，我们通过测量边界框间距来进行设计。当所有的间距都被设定到 32px 时（卡片一所示），视觉上的垂直间距实际上会大于 32px（卡片二所示），尽管你将它们全部设为 32px 就是想让它们的大小是一样的。

![图片来自 [Unsplash](https://unsplash.com/search/photos/seattle?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 上的 [Max Delsid](https://unsplash.com/photos/VlVhOro5tf4?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6400/1*MT1pn5ncq6G5Lto1FRspSA@2x.png)

## 解决方法

由于这个问题，我使用 4px 基线网格来获得更好的视觉准确度。这是我的方法：

1. 在背景设定一个 4px 网格
2. 对齐所有 UI 元素和 **文本基线** 到基线网格
3. **使用网格替代文本框边界去测量垂直间距**。具体来说，我测量文本的上方间距时以最接近内容上方高度的网格线为起点，测量下方间距则以文本基线为起点
4. 此外，受到 [Nathan Curtis](https://medium.com/@nathanacurtis) 在 Medium 上的文章 [设计系统中的间距](https://medium.com/eightshapes-llc/space-in-design-systems-188bcbae0d62) 的启发，我为我的团队定义了一组间距值

![](https://cdn-images-1.medium.com/max/4460/1*VkimOwOqN7g4ev0qepnITA@2x.png)

为了让所有基线对齐到网格上，这种方法基本上将文本的可视高度（内容顶部到基线的高度）舍入为 4px 的倍数（如下 GIF 所示）。这也许会带来 1-2px 的误差，但是仍然比使用文本框计算间距更加准确。

![测量文本上方到距离最近的网格的距离](https://cdn-images-1.medium.com/max/2800/1*x-cd9PiJECApKIKYr4Dkmw.gif)

还有一个例外，在将组件或容器中的图标或文本垂直居中排列时，我不会去使用基准网格进行布局，因为在大多数时候开发人员会使用 Flexbox 去居中元素，对于我们双方来说，这比使用固定间距都更加方便 😉。

![每一行的文字都使用 Sketch 中的“居中对齐”命令实现居中，没有基线网格对齐也没关系](https://cdn-images-1.medium.com/max/2800/1*F0XgEwIP-AqqUJiuB4wWRw@2x.png)

---

## 理由

平面设计的传统做法是，用基线网格营造出垂直方向上的节奏感。在我日常的网页设计工作中，明显需要这种节奏感才能让对齐效果更好的案例，我见得不多。

对于我来说，使用 4px 基线网格是一种平衡视觉准确度（用户方面）和设计效率（设计师方面）的方式。在前面的问题部分中，我谈到了使用文本框测量会带来额外间距。并且最后用户并不能看见文本框，使用这种方法并不那么合理，特别是它还可能造成视觉上的不平衡，对用户也没有好处。另一方面，忽略边界框然后使用基线网格测量可以带来更好的视觉准确度。下面是这两种方法之间的比较。我们可以看到，当使用相同的间距值（32px、12px、32px、32px）时，使用基线网格的设计可以带来更准确的效果。

![](https://cdn-images-1.medium.com/max/4056/1*Kj12Nm-rgwHkGXQiypGulw@2x.png)

有人可能会说，如果使用文本框来测量会带来更多间距，就拿第一张卡片来说，将第一个间距值从 32px 减少到 28px 或者 24px 就可以让“Seattle”的上边和左边间距看起来是相等的。但是这样一来，设计就变成了一个猜谜游戏，除非你去数像素点，否则你永远都无法确定。而另一方面，4px 网格提供了更准确并且可预测的方式来设定间距值大约为 32px（考虑到 1-2px 的误差）。

从设计效率层面来说，这样做看起来会更低效，不过由于使用网格，设计工具（诸如 Sketch 或 Figma）可以帮助你让元素和文字基线与网格对齐，因此对齐和调整间距变得更加简单。下面是我使用基线网格布局文本的流程：

![我在工作中使用基线网格布局文字](https://cdn-images-1.medium.com/max/6476/1*IRgCv9BK9HuOW3ggGSLLMg.gif)

或者你可以选择不使用网格然后从 **内容顶部** 开始手动测量（如下 GIF 所示），但这样你就要不断缩放查看 **像素网格**。另外，你的画板大小可能并不是 4px 的倍数。

![以上是一个直接从顶部开始测量的流程](https://cdn-images-1.medium.com/max/6476/1*Idy2n4hhAG5v4t5FxKZgOw.gif)

---

## 已知问题 —— 设计到开发交接

当开发人员使用自动标注工具（InVision、Zeplin、Figma）检查设计时，使用基线网格测量的布局的间距值看起来会很随意。下面就是使用基线网格进行的设计。数字显示了你会在自动标注工具中看见的内容。

![](https://cdn-images-1.medium.com/max/2800/1*p_dxocmqPQ5jzpfdDZDVhA@2x.png)

我在上面简要地提到了 [设计系统中的间距](https://medium.com/eightshapes-llc/space-in-design-systems-188bcbae0d62) 一文。它讨论了如何使用 CSS 类表示间距值，这有助于保持设计师和开发人员的统一。不幸的是，因为使用基线网格产生的不同间距组合带来的随机性，我们很难用一组 CSS 类来表示间距。

我们还研究了许多人提到的减轻随机性问题的流行技术，即使用 ::before 和 ::after CSS 伪元素去“裁剪”边框（本质上就是设置间距，以进行校正）。然而，我的代码小能手男友 [Chris Caruso](https://medium.com/@chriscaruso) 告诉我：

> 使用 ::before 和 ::after CSS 伪元素带来的效果并不理想，因为它在不同字体、浏览器、操作系统甚至不同屏幕分辨率下效果都不同。配置好一套具体使用环境，又可能导致另一套环境下的间距出问题。从开发人员的角度来看，这种编程并不是一种良好的编码习惯，因为它使用了负边距并且给 DOM 添加了额外的元素 —— 这两者都可能会带来一些我们不希望出现的副作用。因此，在生产环境中不值得去冒这个险。😑

## 本地化？

我曾做过本地化研究并查看了我们的产品支持的 8 种文字系统（拉丁字母、中文汉字、西里尔字母、天城体字母、希腊字母、韩文字母、假名，以及泰文）。然后我发现无论我使用哪种测量方法，最终，开发者都是从自动标注工具中获取边框的间距然后放入 CSS 中。根据你使用的其他非拉丁字母，即便行高是相同的，它们的视觉高度也或多或少与拉丁字母有偏差。并且它们的基线也可能有偏移。因此无论你使用哪种测量方法，本地化操作总是会让间距发生细微变化。不过如下图所示，尽管间距发生了微小的变化，但是所有的文本还是保持在了相对居中的位置。

（我对非拉丁字母文字还不是那么了解，不过我是想再多学点的。如果上述的一些结论有不正确或者可以改进的地方请告诉我。我只会英文和中文，所以在这里要感谢帮我把这行文字翻译成其他语言的工作伙伴。）

![针对英文而做的设计方案，然后为其余 7 种文字进行本地化。图片来自 [Unsplash](https://unsplash.com/search/photos/san-francisco?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 上的 [Joshua Sortino](https://unsplash.com/photos/71vAb1FXB6g?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/6720/1*syBC3O5uazoOp4-QP_J0qg@2x.png)

## 提问？

如果文章如果有什么写的不清楚的地方，或者你有任何问题、反馈或者有更好的解决方案，请告诉我！我研究这个内容已经很长时间了，所以我很想听听你的想法！如果你想联系我请直接发送邮件到 <ethanw@microsoft.com>！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
