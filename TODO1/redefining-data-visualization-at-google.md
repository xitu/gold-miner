> * 原文地址：[Six Principles for Designing Any Chart](https://medium.com/google-design/redefining-data-visualization-at-google-9bdcf2e447c6)
> * 原文作者：[Manuel Lima](https://medium.com/@mslima)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/redefining-data-visualization-at-google.md](https://github.com/xitu/gold-miner/blob/master/TODO1/redefining-data-visualization-at-google.md)
> * 译者：[MarchYuanx](https://github.com/MarchYuanx)
> * 校对者：[mymmon](https://github.com/mymmon), [shinichi4849](https://github.com/shinichi4849)

# 设计图表的六项原则

> Google 新数据可视化指南的简介

![](https://cdn-images-1.medium.com/max/2748/1*mXIcH44FAZKCRjX5g_lYmw.png)

---

2017 年 8 月，Google 的一群热情的设计师、研究人员和工程师聚集在一起，创建了一套全面的数据可视化指南 —— 涵盖了所有内容，包括颜色、形状、排版、图标、交互和动作。这个合作的成功促成了谷歌第一个完全专注于数据可视化团队的组建，该团队于 2018 年 5 月成立。

在过去的一年里，我们一直致力于理解需求和要求，来具象化人们如何进行信息的可视化和交互。现在，我们想与世界各地的开发者分享我们的见解。我们针对[创建您自己的数据可视化项目](https://goo.gle/2ITQoTY)推出了详细的公共指南，并提炼出了我们的首要原则和注意事项。以下是用于设计图表的六种策略。

---

## 保持坦诚

#### 数据的准确性和完整性是首要的。不要歪曲或混淆信息以进行掩饰或偏袒。重视数据的清晰度和透明度。

![](https://cdn-images-1.medium.com/max/2760/1*ydrVMlmFanX1LsuN6CzTqA.png)

为用户提供用于理解给定的可视化图表所需的上下文元素。通过使用清晰的标签、准确的轴线和基线，支持工具提示和图例组件，最大限度地提高图形的完整性。图表的运动有助于加强关联度，但不能歪曲数据。把所使用数据集的来源、收集和处理方式等信息一目了然地呈现

---

## 伸出援手

#### 提供上下文并协助用户进行数据的导航。建立优先考虑数据探索和比较的可供性。

![](https://cdn-images-1.medium.com/max/2760/1*60a7CCF8W4EytCv7idmllw.png)

设计时要考虑到用户现有的思维模式 —— 可能是受广泛使用的工具影响而定型的。创造温馨的入手体验，将使用户更容易去学习如何阅读图表以及包含的信息。选择能使核心功更易于被发现的视觉和交互的可供性功能。例如选择，缩放，平移和过滤。运动和交互应通过揭示背景、见解、关联和因果关系来支持分析推理和用户理解。利用空状态作为启示的时刻。

---

## 取悦用户

#### 总是超越预期。考虑性能、优化、惊喜和创新。选择动态、快速、巧妙的体验。

![](https://cdn-images-1.medium.com/max/2760/1*IpHoJvLE_87IDvRG8dQ3MQ.png)

创造出色的可视化体验，然后以意想不到的方式优化它们。在适当的时候，通过使用签名功能和一些小小的轻松时刻来引导用户找到他们所需要的。速度同出色的图形效果一样有价值。考虑状态转换编排中的运动和时间，有助于快速响应系统的感知。

---

## 明确重点

#### 减少感知的负担，专注于重要的事情。每个动作，颜色和视觉元素都应该服务于洞悉、理解数据。

![](https://cdn-images-1.medium.com/max/2760/1*VwVvqEaH-Y3Z_5Ryt481gw.png)

专注于用户的任务，其他一切都应该遵循。尽可能更快地引导用户了解基本信息。最大化数据笔墨的比例，避免出现无关图形元素。把颜色赋予意义，以加强图形理解：标签、分组、高亮或量度。请谨慎使用动作 —— 限制在使用细微的过渡和提示，帮助用户理解层次结构、数据方向和关系。

---

## 接受扩展

#### 允许系统扩展以适应任意语境。尊重不同用户对数据深度、复杂度和形态的需求。

![](https://cdn-images-1.medium.com/max/2760/1*DF5pg4i7OlWo9fAfbi-liQ.png)

每张图表都应该尽可能的便于访问。考虑图表元素（调色板、过滤器配置、轴、面板、交互机制）如何调整以适应用户的各种需求，屏幕大小和数据类型（从单个数据点到大型多变量数据集）。考虑一系列的可能性而不是不变的配置。使用交互式方法来最小化复杂性，例如逐步提供细节（渐进式披露），让用户更改视角，以及链接不同视图以实现更深入的洞察。

---

## 提供结构

#### 使用可视属性来传达信息层次，提供结构并提高一致性。体验应该是直观且易于使用的

![](https://cdn-images-1.medium.com/max/2760/1*XJqqL_vhSWVNRpjbi_zn1g.png)

一致性促进熟悉。在图形处理（形状、颜色、图像、排版）和交互模式（选择、过滤、悬停状态、扩展）中实现一致性。图表的运动应该是受控的，在保持响应的同时为用户提供稳定性和连续性。考虑进入和退出的运动，以帮助用户了解元素的视觉层次，轴的方向和数据的显示。保持足够的上下文提示，因此无论用户在图表中浏览到哪里，他们都知道如何返回。

**关于更多的见解和方案,请阅读我们完整的[数据可视化指南](https://goo.gle/2ITQoTY)。**

---

#### 致谢

如果没有 Google 里无数人的才能和奉献精神，这项工作就无法完成。感谢：Shuo Yang, Kent Eisenhuth, Sharona Oshana, Katherine Meizner, Hael Fisher, Ross Popoff-Walker, Ian Johnson, Joe Nagle, Ryan Vernon, Nick Bearman, Luca Paulina, Gerard Rocha, JT DiMartile, Lorena Zalles, Tom Gebauer, Hilal Koyuncu, Bethany Fong, Ann Chou, Barbara Eldredge, and Anja Laubscher.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
