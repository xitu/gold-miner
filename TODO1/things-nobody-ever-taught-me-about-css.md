> * 原文地址：[Things nobody ever taught me about CSS.](https://medium.com/@devdevcharlie/things-nobody-ever-taught-me-about-css-5d16be8d5d0e)
> * 原文作者：[Charlie Gerard](https://medium.com/@devdevcharlie)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/things-nobody-ever-taught-me-about-css.md](https://github.com/xitu/gold-miner/blob/master/TODO1/things-nobody-ever-taught-me-about-css.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：[Fengziyin1234](https://github.com/Fengziyin1234), [xionglong58](https://github.com/xionglong58)

# 从没有人告诉过我的 CSS 小知识

![由 [Jantine Doornbos](https://unsplash.com/photos/xt9tb6oa42o?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 发布于 [Unsplash](https://unsplash.com/search/photos/css?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/10396/1*fyXNSvbsWjSDxBxJp6sXIA.jpeg)

**这篇文章绝对不是对任何一个曾经和我共事过的人的批判，仅仅是我最近在做一些个人研究的时候学到的关于 CSS 的一些要点。**

***

有很多开发者并不怎么关注 CSS，我想这已经不是什么新鲜事了。通过网上的各种对话，或者与朋友和同事聊天的时候你都可以观察到这个现象。

***

然而，在社区中，我们学到的很多知识都是来自于同伴的分享，有时我会意识到很多关于 CSS 的基础知识在社区中从来没有被分享过，因为其他人从来不愿意花时间在 CSS 上深究。

为了解决这个问题，我决定对 CSS 做一些研究并整理出一部分概念，我认为这些概念对于更好地理解和编写 CSS 代码很有帮助。

**这份清单肯定没有那么全面，它只包含了过去几天我学到的新知识，分享出来希望能够帮助到大家。**

## 术语

***

在所有的编程语言中都有一些用来描述概念的特定术语。CSS 作为一门编程语言也是一样的，了解这些术语对于沟通交流甚至只是为了提高自己的知识储备都是很有帮助的。

### 后代选择器

你知道样式选择器中间的小空格吗？它实际上还有一个名字，它的名字是**后代选择器**。

![后代选择器](https://cdn-images-1.medium.com/max/3052/1*CsbGMDvUjClyCkDviUF_Aw.png)

### 布局，绘制和渲染层合并

这些术语更多地和浏览器渲染有关，但它仍然很重要，因为一些 CSS 属性会影响渲染进程的不同步骤。

**1. 布局**

布局步骤负责计算元素在屏幕上占用的空间大小。修改 CSS 中的“布局”属性（例如：宽度、高度）意味着浏览器需要检查其他所有的元素并“重排”页面，也就是说重新绘制受影响的区域并将他们合并在一起。

**2. 绘制**

此过程是为元素的可视化部分（颜色、边框等）填充像素的过程。绘制元素通常在多个图层上完成。

改变“绘制”属性不会影响页面的布局，所以浏览器会跳过布局步骤但仍然会执行绘制。

绘制经常是整个渲染进程中代价最昂贵的部分。

**3. 渲染成合并**

在渲染层合并这个步骤中，浏览器需要按照正确的顺序绘制图层。因为有一些元素会发生重叠，所以这个步骤对于确保元素按照预期顺序显示非常重要。

如果你改变了一个既不需要布局也不需要绘制的 CSS 属性，那么浏览器只需要做渲染层合并操作。

有关不同 CSS 属性触发的详细信息，你可以在 [CSS Triggers](https://csstriggers.com/) 上查看。

## CSS 性能

***

### 后代选择器或许会非常耗能

取决于程序的大小，仅仅使用没有什么特殊性的后代选择器代价会非常昂贵。浏览器会检查每个后代元素是否匹配，因为后代这种关系不仅限于父子之间。

例如：

![后代选择器示例](https://cdn-images-1.medium.com/max/2784/1*mr2okDdgwXotLVR9ig86_w.png)

浏览器会评估页面上的所有链接，最终定位到那个实际位于 `#nav` 元素内的链接。

一种更高效的方法是在 `#nav` 元素中的每个 `<a>` 元素上添加一个特定的 `.navigation-link` 选择器。

### 浏览器从右到左读取选择器

我觉得我应该知道这个，因为这个听起来很重要，但我并不知道……

解析 CSS 时，浏览器会从右到左解析 CSS 选择器。

让我们看看下面的例子：

![浏览器从右向左进行读取](https://cdn-images-1.medium.com/max/2512/1*Pi_wGtDAnY-u9cuaXwt7hA.png)

采取的步骤如下：

* 匹配页面上的每个 `<a>` 元素。

* 找到被 `<li>` 元素包裹的 `<a>` 元素。

* 使用之前的匹配结果并将范围缩小到那些被 `<ul>` 元素包裹的结果。

* 最终，在上面的选项中筛选出那些被类名为 `.container` 的元素包裹的结果。

从上面的步骤我们可以看出，靠右的选择器越具体，浏览器过滤和解析 CSS 属性的效率就越高。

为了提高上面例子的性能，我们可以在 `<a>` 标签上面添加类似 `.container-link-style` 的类名来替换 `.container ul li a`。

### 尽可能避免修改布局

更改某些 CSS 属性可能会需要更新整个页面的布局。

例如，`width`、`height`、`top`、`left`（也称为“几何属性”）等属性就需要重新计算布局和更新渲染树。

如果在大量的元素上更改这些属性，那么计算和更新他们的位置/大小需要花费很长的时间。

### 小心绘制的复杂性

在绘制方面，一些 CSS 属性（例如：blur）会比其他属性花费更高的代价。可以考虑使用其他更有效的方法来实现相同的效果。

### 代价高昂的 CSS 属性

一些 CSS 属性会比其他属性花费更高的代价，这意味着他们需要更长的时间来绘制。

其中一些属性如下：

* `border-radius`

* `box-shadow`

* `filter`

* `:nth-child`

* `position: fixed`

这并不意味着你根本不应该使用他们，但你应该明白，如果一个元素使用其中某些属性并将渲染数百次，会影响到渲染性能。

## 顺序

***

### 顺序在 CSS 文件中很重要

让我们看下面的 CSS 代码：

![](https://cdn-images-1.medium.com/max/2752/1*0uiYubMeRz5QRppeAM6x7A.png)

然后再来看看这段 HTML 代码：

![](https://cdn-images-1.medium.com/max/2952/1*-H7JKSQP_WRcwy3Z2GFmzQ.png)

我们会发现影响渲染效果的不是选择器在 HTML 代码中出现的顺序，而是选择器在 CSS 文件中出现的顺序。

评估 CSS 性能的一个好方法是使用浏览器的开发者工具。

***

如果你使用的是 Chrome 或者 Firefox，可以打开开发者工具，转到 Performance 标签，并记录当你加载页面或与页面互动时发生的情况。

![Chrome 的 Performance 标签可以给你的性能评估截图.](https://cdn-images-1.medium.com/max/6296/1*Quo30quEmkhn2BarZBsCQA.png)

## 资源

***

在为这篇文章做研究时，我遇到了一些非常有意思的工具，如下所示：

[CSS Triggers](https://csstriggers.com/) —— 该网站列出了一些 CSS 属性，以及在应用程序中使用和修改这些属性对性能的影响。

[Uncss](https://github.com/uncss/uncss) —— 一种可以从 CSS 文件中删除未使用的样式的工具。

[Css-explain](https://github.com/josh/css-explain) —— 一种可以解释 CSS 选择器的小工具。

[Fastdom](https://github.com/wilsonpage/fastdom) —— 批处理 DOM 读/写操作的工具，可以加快布局性能。

差不多就是这样啦！希望它有意义！

***

感谢阅读！ 🙏

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
