> * 原文地址：[A gentle introduction to React Motion](https://medium.com/@nashvail/a-gentle-introduction-to-react-motion-dc50dd9f2459)
> * 原文作者：[Nash Vail](https://medium.com/@nashvail?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-gentle-introduction-to-react-motion.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-gentle-introduction-to-react-motion.md)
> * 译者：[doctype233](https://github.com/doctype233)
> * 校对者：

# 关于 React Motion 的简要介绍

React 很棒，在过去的几周里，我用它玩得很开心，所以我决定尝试一下[React Motion](https://github.com/chenglou/react-motion)。一开始 API 就让我感到有困惑和棘手，但是最终一切开始变得有意义，不过这需要时间。遗憾的是，我在网上找不到合适的 React Motion 教程，所以我决定把这篇文章写出来，不仅是作为一个开发者们的资源，也能给我自己作参考。

React Motion 对外暴露三个主要的组件：Motion, StaggeredMotion 和 TransitionMotion。在本教程中，我们将一起看一看 Motion 组件，之后你会发现将在这一部分花费大量时间。

由于这是一个 React Motion 教程，所以我将假设你有点熟悉 React 以及 ES2015。

我们将在使用 React Motion 重新创建 [一个 Framerjs 的例子](http://framerjs.com/examples/preview/#new-tweet.framer) 时探索 API。你可以在这找到代码的最终版本  [在这](https://github.com/nashvail/ReactPathMenu/)。

![](https://cdn-images-1.medium.com/max/1600/1*kyWa60lJ2P1nGrQOSFwDag.gif)

最终效果

我们首先要研究一点数学问题，但是不要担心，我会尽可能详细地解释每一个步骤。你可以直接跳过这一部分到 React.start(); 部分。

准备好了吗? 那就开始吧...

### Math.start();

我们可以把蓝色的大按钮称为——主按钮, 从蓝色按钮上飞出的按钮称为——子按钮。

![](https://cdn-images-1.medium.com/max/2000/1*qllWMqjzSS-WNxJicsTg7A.png)

Fig. 1

子按钮拥有两种位置状态， 1) 子按钮均隐藏在主按钮后面的位置， 2) 子按钮在主按钮周围排列成一个圆圈的位置。

这里就出现了数学问题，我们必须想出一种方法，在一个完美的圆中均匀地排列主按钮周围的子按钮。你可以通过试错法将这些值通过代码写死，但认真的说，谁会这么做呢？另外，一旦你找到正确的数学方法，只要你愿意你可以摆放任意多的子按钮，而他们都会自动排列自己。

首先让我们了解几个术语。

#### M_X, M_Y

![](https://cdn-images-1.medium.com/max/1200/1*QILlqlCX5YemXpc2L301Ig.png)

Fig. 2

M_X, M_Y 分别表示以主按钮为中心的 X 和 Y 坐标。(M_X, M_Y) 这个点将用作计算每个子按钮的距离和方向的参考。

每个子按钮最初都隐藏在主按钮中心的后面，中心坐标为 M_X, M_Y。

#### 分离角、扇形角、飞出半径

![](https://cdn-images-1.medium.com/max/1600/1*H7S3us4GgfZ2-lVU7gyo2A.png)

Fig. 3

飞出半径为子按钮飞出后距离主按钮的距离，其他两个词语的释义看起来不言自明。

还需要注意一个地方,

> 扇形角 = (子按钮数-1) * 分离角

现在，我们需要设计一个函数，该函数接收子按钮 (0, 1, 2, 3 …) 的索引，并返回子按钮的新位置的 x 和 y 的坐标。

#### 基准角、索引

![](https://cdn-images-1.medium.com/max/1200/1*HM9Pysix_eOJjbPQ_YNPxQ.png)

Fig. 4

由于通常来说三角学中的角度是从 x 轴的正方向测量的，我们将从相反的方向（右到左）开始给我们的子按钮编号。这样，以后我们就不必在每次需要子按钮的最后位置时乘以负一。

当我们看到它时，请注意 (参见 Fig. 3)

> 基准角 = (180 — 扇形角)/2

(一定程度上).

#### 角

![](https://cdn-images-1.medium.com/max/1200/1*HV4NgkZc3HRsvSLVyPf_iA.png)

Fig. 5

每个子按钮都有它自己的角度，我称之为角。这个角是计算子按钮最终位置所需的最后一条信息。

请注意, (参见 Fig. 3, Fig. 4)

> 索引为 i 的子按钮的角度 = 基准角 + ( i * 分离角)

现在，一旦我们有了每个子按钮的角，

![](https://cdn-images-1.medium.com/max/1600/1*4WLefRuCXNDKa4Zb2g6A7A.png)

Fig. 6

我们就能够为每个子按钮计算 _增量X_ and _增量Y_。

请注意 (参见 Fig. 2),

> 子按钮的最终 X 轴坐标 = M_X + 增量X

> 子按钮的最终 Y 轴坐标 = M_Y - 增量Y

(我们从 M_Y 中减去增量X，因为不同于原点在左下角的一般坐标系，浏览器的原点在左上角，所以为了方便移动，你可以降低他们 y 轴坐标的值。)

所以，这些就是我们所需要的数学方法，现在我们有两样东西：每个子按钮的初始位置 (M\_X, M\_Y) 和子按钮的最终位置，剩下的魔发就交由 React 来完成吧！

### React.start();

在下面的关键代码中，你将会看到发生什么，点击主按钮，我们将 isOpen 的状态变量设置为 true （第85行）。一旦 isOpen 为 true，就会传递不同的子按钮的样式（第97行，第66行，第75行）。

结果：

![](https://cdn-images-1.medium.com/max/1600/1*feVyc2Uue0mq4h0jVGW1uw.gif)

Fig. 7

好的，我们在此处完成了很多操作，我们在按钮上设置子按钮的初始位置和最终位置，现在我们需要做的就是添加 React Motion 来激活在初始位置和最终位置之间的动画。

### React-Motion.start();

<Motion> 获取 [几个参数](https://github.com/chenglou/react-motion#motion-) 每个参数是可选的，但我们不关心这里的可选参数，因为我们没有做任何与这个参数有关的事情。

其中 <Motion> 一个参数是 _style_, _style_ 将作为参数传递到回调函数中，该函数包含内建的 _interpolated values_ ，然后执行它的动画。

(第8行 : 因为正在React中执行迭代，所以需要将一个 key 参数传递给子组件。)

就像这样，

即使在这样做以后，结果也不会与图 Fig. 7 有所不同，为什么这么说？好吧，我们还需要最后一步，_spring._。

正如前面提到的, 回调函数包含内建的值，也就是说， _spring_ 帮助函数内建的值插入样式值。

我们需要修改 initialChildButtonStyles 和 the finalChildButtonStyles 并注意 _top_ 和 _left_ 被  _spring_ 覆盖的值。这些是仅有的改变，现在，

![](https://cdn-images-1.medium.com/max/1600/1*vJVGoGiTF0_WWOjF4nX5yw.gif)

Fig. 8

spring 可选地接收第二个参数，这是一个包含两个数字的数组 [Stiffness, damping]，默认值为[170,26],这导致了上图 Fig. 8 中呈现的结果。

将 Stiffness 视为动画发生的速度，这不是一个非常精确的假设，只是速度越大的值越大。Dampness 是一个晃动效果参数，不过相反的，值越小，晃动效果越明显。

可以看看这个

![](https://cdn-images-1.medium.com/max/1600/1*fmPrwf2E-gy8FJ9t-c0TvQ.gif)

[320, 8] — Fig. 9

![](https://cdn-images-1.medium.com/max/1600/1*cyNkSaIKitdbfkWQ5BjZkA.gif)

[320, 17] — Fig. 10

我们离最终完成很近了，但是还没有。如果我们在每次下一个子按钮开始动画前添加延迟会怎样？为了达到最终效果，这正是我们需要做的，但这样做并不那么简单，我不得不把每个运动组件以数组的形式存储到状态变量中，然后一个一个地为每个子按钮改变状态以达到期望的效果，代码就像这样

> this.state = {  
> isOpen: false,  
> childButtons: []  
> };

然后在 componentDidMount 方法中添加 _childButtons_

> componentDidMount() {  
> let childButtons = [];  
> range(NUM_CHILDREN).forEach(index => {  
> childButtons.push(this.renderChildButton(index));  
> });

> this.setState({childButtons: childButtons.slice(0)});  
> }

最终打开菜单功能得以实现：

![](https://cdn-images-1.medium.com/max/1600/1*OAwTtEZ77MFmYc5J93UWIA.gif)

我们在这里做了一些美学的调整，如添加图标和一些旋转效果，我们得到最终效果如下。

![](https://cdn-images-1.medium.com/max/1600/1*kyWa60lJ2P1nGrQOSFwDag.gif)

方法已覆盖，你可以设置任何数量的子按钮

![](https://cdn-images-1.medium.com/max/1600/1*CZs6nzP2gA4wYo7-7W14RQ.gif)

NUM_CHILDREN = 1

![](https://cdn-images-1.medium.com/max/1600/1*ZYBIda9cB4qswqsiARS9-g.gif)

NUM_CHILDREN = 3

![](https://cdn-images-1.medium.com/max/1600/1*LAGfzXC-DrjFOYJDmWAyGg.gif)

NUM_CHILDREN = 8

相当酷对吗? 再说一遍，你可以在 [在这](https://github.com/nashvail/ReactPathMenu/blob/staggered-motion/Components/APP.js)找到相应代码。如果你觉得这篇文章有帮助，请点击下面的推荐按钮。

如果有一些问题、评论、建议或仅仅是想聊个天？可以在 Twitter 上找到我 [@NashVail](http://twitter.com/NashVail) 或者给我发电子邮件 [hello@nashvail.me](mailto:hello@nashvail.me).

* * *

你可能还会喜欢

1.  [Let’s settle ‘this’ — Part One](https://medium.com/p/lets-settle-this-part-one-ef36471c7d97)
2.  [Let’s settle ‘this’ — Part Two](https://medium.com/p/lets-settle-this-part-two-2d68e6cb7dba)
3.  [Designing the perfect wallpaper app](https://medium.com/@nashvail/designing-the-perfect-wallpaper-app-36b8c9c226bb)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
