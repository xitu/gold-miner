> * 原文地址：[CSS is magic, its time you try 3D](https://levelup.gitconnected.com/css-is-magic-its-time-you-try-3d-91a2dd49c781)
> * 原文作者：[Ankita Chakraborty](https://medium.com/@ankitachakraborty)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/css-is-magic-its-time-you-try-3d.md](https://github.com/xitu/gold-miner/blob/master/article/2021/css-is-magic-its-time-you-try-3d.md)
> * 译者：[tong-h](https://github.com/Tong-H)
> * 校对者：[Chorer](https://github.com/Chorer) [PassionPenguin](https://github.com/PassionPenguin)

# CSS 是魔法, 是时候试试 3D 了

![小狗插图：[subpng](https://www.subpng.com/)，眼睛插图：[pngegg](https://www.pngegg.com)](https://cdn-images-1.medium.com/max/5440/1*WKVcqB1XHjA5Fbdm-AQU-g.png)

**CSS transform** 是 css 最全能，最神奇的属性之一。它不仅是在你的网站上实现平滑动画的最佳方式，更是你创造奇迹的一种方式。比如这个 🙀 —

![CSS 3D 立方体!](https://cdn-images-1.medium.com/max/2000/1*dFJEMRBc7vlHnLf_MYI0Iw.gif)

> 我先为这几个占了你的网络宽带的动图道歉，但我希望它是值得的！🤜🤛

等下，这个立方体的两个面不见了！！！

我是故意这么做的，这样就会更形象，也更容易理解。我会在文章末尾添加一个链接用于获取上面示例的完整代码！

### 先说最重要的，Translate 是如何工作的？

`translate` 方法主要是将一个 html 元素从它真实的位置上移动，而且不会干扰布局树上的其他兄弟或父级元素。简单来说，`translateX` 方法是将元素左右移动，而 `translateY` 是上下移动元素。

![translate 是如何使元素在 X 轴和 Y 轴中平移的](https://cdn-images-1.medium.com/max/3688/1*cq8Q9DGLScj3v038DnxjhQ.png)

### 但 Z 轴是什么？

为了更形象地了解 `translate` 是如何沿着 Z 轴工作的，想象一下你的 `div` 在你的屏幕中前后移动而不是上下或左右。

![沿着 Z 轴平移](https://cdn-images-1.medium.com/max/4328/1*qXx6HIGzXvPZY4oO_4gEFQ.png)

这怎么可能？一个网站看上去就像是一本书中的一页纸，对吧？怎么可能会有东西从屏幕中跑出来向你靠近（或者远离你）？

你的 `div` 当然不会真的跑出来，但它给你一种感觉好像它会。让我们一起看看沿着不同的轴修改 `translate` 的值会怎样。

![](https://cdn-images-1.medium.com/max/2000/1*lNQdNBsRYNzWduwKFCdR5w.gif)

我不知道你怎么想，但这个绿色的盒子看起来并不像是在靠近或者远离我。👺

如何解决这个问题呢？我们需要改变一下我们的**视角**。😉

### CSS 的 perspective 属性

如果不设置正确的 `perspective` 值，你无法在视觉上检测到 Z 轴的改变。

> `perspective` 属性定义元素与用户的距离。那么，相比于一个较高的值，一个较低的值产生的 3D 效果会更强烈。
>
> 来源 —— [W3 Schools](https://www.w3schools.com/cssref/css3_pr_perspective.asp)

让我们给这三个方块的父元素加上下面的 CSS ——

![](https://cdn-images-1.medium.com/max/2724/1*ijVRelbthN6Ivuf5xDs7Iw.png)

**瞧：**

![](https://cdn-images-1.medium.com/max/2000/1*5Go0arpobwsP4NtVYPRH4A.gif)

### rotate 方法

顾名思义，`rotate` 根据一个给定的角度，沿着某一个轴旋转元素。但我们需要一点视觉效果来展示 `rotate` 是如何沿着不同的轴工作的。

![在没有 perspective 的情况下沿着不同的轴旋转](https://cdn-images-1.medium.com/max/2000/1*L06oWqkChV9deUNUVKrITw.gif)

![有 perspective 的情况下沿着不同的轴旋转](https://cdn-images-1.medium.com/max/2000/1*nu1bM-wUxugvSsDj2H1ZSg.gif)

### 立方体

我们终于可以从立方体的面开始了！我们将有四个面 —— bottom，front，back，left：

![](https://cdn-images-1.medium.com/max/2388/1*q69vRRksjkM4M2xY0Meycg.png)

同样的，我为主要的包裹容器 `box-wrapper` 添加了一些 css。

![](https://cdn-images-1.medium.com/max/2000/1*gSM7KPGdGmzmo5D-Jpr_UA.png)

注意我为容器添加了 `transform-style: preserve-3d`，这是渲染 3D 子元素的一个重要步骤。每一个面的宽高都是 `200px`，我们需要记住这个值，因为我们将依据每一个面的尺寸为每个面添加 `translate` 值。

立方体的每一个面都将是一个绝对的划分，我添加了文字用于代表每一个面。我为每一个面添加了 `opacity: 0.5`，这样就能清楚地看到它们之间的重叠了。

![](https://cdn-images-1.medium.com/max/2236/1*iygD8k6WIHvobgQKUAc9Ww.png)

为了将 front 放到前面，我们为它添加 `translateZ(100px)`。

![](https://cdn-images-1.medium.com/max/2768/1*-URkuoY7VunPTDHgQzSqsA.png)

对，看起来就像这样。🙁

那么我们怎么使它 3D **化**？我们的 `perspective` 知识在这里要派上用场了。

添加这个 css 到包裹容器的父级元素 `box-container`：

![](https://cdn-images-1.medium.com/max/2000/1*pB8EdPyeKJywcoUVkdNszw.png)

同样的，为了将 back 调后，我们将为它添加与 front 相反的 css。

![](https://cdn-images-1.medium.com/max/2000/1*r1-jRUGjUW-8a0-ckLay_Q.png)

**效果 ——**

![](https://cdn-images-1.medium.com/max/2608/1*q6x7s9gLwwVf3WtIMaQYvg.png)

你能够想象 front 向你靠近，back （黄色那个）离你远去吗？如果这仍然不足以描绘，那让我们试着把立方体的包裹容器旋转一下：

![](https://cdn-images-1.medium.com/max/2000/1*jaSlx71f9SunHXIOxGdthg.gif)

很奇妙，对吗？

下一步，我们需要安顿 bottom 💁‍♀️，为了将 bottom 放到适当的位置，我们把他沿着 X 轴旋转 ** 90 度**。

![](https://cdn-images-1.medium.com/max/2000/1*icrwzzydWhtOKhj85QnO1A.gif)

我们还需要移动它的位置使它能正好在立方体的 front 和 back 之间。我们可以做的是移动 bottom 使其与 front 一致，然后旋转它。听起来有点困惑对吗？

**步骤 —— 1: 将 bottom 和 front 对齐**

**CSS:**

![将 bottom 和 front 对齐](https://cdn-images-1.medium.com/max/2000/1*CBL0oCueX-bgBbVRJXC0dA.png)

**效果:**

![将 bottom 和 front 对齐](https://cdn-images-1.medium.com/max/2000/1*xLD_mS8WsK3nzScd6tbwKw.gif)

**步骤 —— 2: 将 bottom 旋转 90 度**

**CSS:**

![将 bottom 的 translate 和 rotate 相结合](https://cdn-images-1.medium.com/max/2152/1*LVmwdMV9BtJEZYP9u37pmw.png)

**Result:**

![将 bottom 的 translate 和 rotate 相结合](https://cdn-images-1.medium.com/max/2000/1*qsGQ7VjZngLZm9SoU8LuxA.gif)

bottom 看起来现在安全的在自己的位置上了。但 left 好像被困在了中间。🙍‍♀️ 首先我们需要将它移动到旁边然后旋转它。让我们把他沿着 X 轴移动 **-100px**，然后在 Y 轴上旋转它。

**CSS:**

![](https://cdn-images-1.medium.com/max/2180/1*5RJvq7AM6mGD5zVVGoXM7w.png)

**效果:**

![](https://cdn-images-1.medium.com/max/2000/1*WnnTtpzcd691KA2qO0b16w.gif)

**看**！我们的**近似立方体**已经快完成了。我建议你在每一个轴上都尝试调整一下 translate 和 rotate 的值，尝试添加顶面和右面去做一个完整的立方体。

现在，最后关键的一步，旋转我们的立方体 😍

**CSS:**

![](https://cdn-images-1.medium.com/max/2000/1*VhF0Ltn-I8vLPhTc6xaj9A.png)

将上面的动画添加到我们的 `box-wrapper` 上 ——

![](https://cdn-images-1.medium.com/max/2336/1*RbHF6_VStIc1nYnx5g_pog.png)

效果 🤜🤛:

![](https://cdn-images-1.medium.com/max/2000/1*OZ9tJyqDlJZ5NZhuRT1-wA.gif)

相同的工作代码，参考[GitHub 仓库]](https://github.com/ankita1010/css-cube)，尝试体验一下 **CSS 3D** 这个魔法之池。💫


> **请注意** —— 我调整了 perspective 的值，以及添加了一些动画来达到侧面的最终位置，以更清楚地展示变化。我稍微旋转了 `box-wrapper`，这样从正确的角度看更明显些。

干杯！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
