> * 原文地址：[Creating with a Design System in Sketch: Part Two [Tutorial]](https://medium.com/sketch-app-sources/creating-with-a-design-system-in-sketch-part-two-tutorial-445e0264556a)
> * 原文作者：[Marc Andrew](https://medium.com/@marcandrew?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-two-tutoria.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-two-tutoria.md)
> * 译者：[Zheng7426](https://github.com/Zheng7426)
> * 校对者：[pmwangyang](https://github.com/pmwangyang)

#  在 Sketch 中使用一个设计体系创作: 第二部分 [教程]

## 创建和玩转一个 Sketch 的设计体系 

* * *

### 🎁 想用我这针对 Sketch 的优质设计体系来飞速提升你的工作流程吗？你可以从[这里](https://kissmyui.com/cabana)获取一份 Cabana。

输入这个促销码 **MEDIUM25** 就能得到 **七五折的优惠**。

![](https://cdn-images-1.medium.com/max/800/1*aEcIFESUCKiFVRpssVQTOA.jpeg)

* * *

我在这个全面的系列教程里会给你提供关于如何构建你自己设计体系有价值的干货（以及我如何构建自己的体系），之后在为一个叫 **format** 的 App (风格类似 Medium 网页）构建设计时咱们把这些学过的元素都整合在一起并实践出来。

### 本系列教程目录

*   [第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-one-tutorial.md)
*   **第二讲**
*   [第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-three-tutorial.md)
*   [第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-four-tutorial.md)
*   [第五部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-five-tutorial.md)
*   [第六部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-six-tutorial.md)
*   [第七部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-seven-tutorial.md)
*   [第八部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-eight-tutorial.md)
*   [第九部分](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-with-a-design-system-in-sketch-part-nine-tutorial.md)


* * *

### 文字设计

![](https://cdn-images-1.medium.com/max/800/1*HkYiqCoiWKrqrD_k-FLLQw.jpeg)

嘿嘿。 接下来我们来讲设计体系的文字设计 (文字风格）。为了更好地达到教学目的，在新手包裹（咱们开始设计 iOS App 时会接触到)的文字风格是我在 Cabana 里所使用的文字风格的精简版。

在我逐步构建出 Cabana 设计体系的过程中，最耗时的元素莫过于文字设计了。创建文字的风格是件苦差事，然而当我开始将他们付诸实践时就能看到其优点所在。不过不管怎么说，要把他们都一一整合绝非易事。

![](https://cdn-images-1.medium.com/max/800/1*AJ1Kize1DQ0RLs3cLSiPQA.jpeg)

像我之前提到过的，在本系列教程中我只囊括了文字风格精简之后的4种色彩样式：
- 黑
- 灰
- 白
- 原色

当然啦，我在第一讲中也提到过，如果你打算创建一个十分丰满的设计体系的话，那么你可以创建有着以下几种色彩选择的文字风格：

- 黑
- 灰
- 浅灰
- 白
- 原色
- 红
- 绿
- …或者任何其他颜色用来作为你的底色

以上呢就是我为自己的设计体系所做的选择，其实和我之前所创建的底色的选择差不了多少。

### 为何如此麻烦？

有一天有人问我为啥子我得为两种字体家族（Font Family 1 与 Font Family 2）创建这么多不同的字重和字型大小 —— 这样不是自找麻烦吗？

我见过有些设计体系，能够只为了一个标题专门构建一个字体家族，然后另建一个内容主体的字体家族，再来一个专门为导引的…

我个人觉得这样做的话才是真的麻烦，而且在之后的过程中容易出岔子。

回到我的做法，在整个设计体系的创建阶段确实会更累人（花了不少时间吧？）。不过呢，一旦你手头上有了两种字体家族中所有不同的自重和字型大小，你就能很自在地说 “我在这个项目中全程只用到 Proxima Nova（属于字体家族1号），并且我有H1、H2、Body（内容主体）和 Lead（导引）以及其他所有内容分类，而不是项目做到一半了才发现我第一个字体家族中没有 Body，而且字体家族 2 号里没有 H1，然后得回头重新完善现有的体系，真是令人感受到淡淡的忧伤！”

### 为何我文字设计的选项命名如此奇怪？

还有人提到为啥子我文字设计的选项叫做…

- Font Family #1 （字体家族 1 号）
- Font Family #2 （字体家族 2 号）

同样的，我见过有些设计体系是直接用字体家族原本的名称来标注文字风格的，比如说 — _Lato_, _Open Sans_, _Proxima Nova_ 等等…

然后你会看到以下的画面：

**_H1 > Proxima Nova > Left > Black_**

先声明一下我并不是完全不赞同这样的方案，如果你能适应的话那你很棒棒。然而我个人觉着吧，比如说当你决定地把 _Proxima Nova_ 换成 _Helvetica_ 的时候，这便成了会使整个过程变慢的另一个因素。虽然说当你想要切换成不同的文字风格的时候，有 Sketch的插件可以做到这一点，但既然可以避免淌这趟浑水你又何必多此一举呢，对吧？

如果你习惯于 90% 的情况下在，标题上用字体家族 1 号，而在内容主体、导引段落等地方使用字体家族 2 号。。。那么看起来这就是你的老习惯，所以……当你决定把字体从 Proxima Nova 换成 Comic Sans ，而不得不更改文字样式名称的时候，千万别对插件火冒三丈啊。

### 先看这儿，朋友!!

**如果你对于我如何在自己的设计体系里构建文字设计的元素还想要有更深的了解的话，可以阅读我之前写过的** [**文章**](https://medium.com/sketch-app-sources/how-to-create-a-design-system-in-sketch-part-one-fd450dccab10) **(直接跳到文字设计的部分), 完事之后记得回到这里哈。**

你看完这篇 [**文章**](https://medium.com/sketch-app-sources/how-to-create-a-design-system-in-sketch-part-one-fd450dccab10)了吗？”酷，我们现在在一个节奏上，很稳！

就像在第一讲中我曾经对基准色元素所做的那样，当我完成了两套字体家族的调试之后，给他们加上相对应的标题（比如 字体家族 #1 (黑), 字体家族 #2 (灰)等等。然后把他们放在一块儿并且锁定。 

我对字体家族1号和字体家族 2 号（白色）做了类似的设置，为了有明显的对比色我把背景设置成黑色，然后也给锁定了。
现在我可以简单地选到这个部分，拖拽光标去选择一大块文字了…

![](https://cdn-images-1.medium.com/max/800/1*RTccjxnSeMvzpOFHk0UxwQ.jpeg)

…用 Inspector 来更新字体，不用担心一不小心改变了参照的标题或者把背景层拖到了屏幕里。

![](https://cdn-images-1.medium.com/max/800/1*72TdwduU1t-2nIrLbO9SMQ.jpeg)

**当你重复这么做20次的时候会不会非常头疼？**

希望藉着本篇丰富的干货以及这篇之前提到的[好文](https://medium.com/sketch-app-sources/how-to-create-a-design-system-in-sketch-part-one-fd450dccab10)，你现在对于创建出你自己设计体系最棒的文字设计有了更加专业的想法。

* * *

好了，本系列教程的第二讲到此为止。请继续阅读第三讲，在第三讲中我将会提到设计体系中用到的 Symbols 以及更多的内容，以及一些实用且绝妙的诀窍和提示，还有我如何将其融入到我的设计体系中的想法。
**想前往第三部分就点[这里](https://medium.com/sketch-app-sources/creating-with-a-design-system-in-sketch-part-three-tutorial-105b12a0944a)…**

### 🎁 想用我这针对 Sketch 的优质设计体系来飞速提升你的工作流程吗？你可以从[这里](https://kissmyui.com/cabana)拷贝一份 Cabana。

输入这个促销码 **MEDIUM25** 就能得到**七五折的优惠**哦。

**谢谢阅读本文**

**Marc**

**设计师, 作者, 父亲，以及一两个奇葩渐变色的爱好者**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
