> * 原文地址：[How Flexbox works — explained with big, colorful, animated gifs](https://medium.freecodecamp.com/an-animated-guide-to-flexbox-d280cf6afc35#.u44ga6k7p)
* 原文作者：[Scott Domes](https://medium.freecodecamp.com/@scottdomes)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[linpu.li](https://github.com/llp0574)
* 校对者：[sqrthree](https://github.com/sqrthree)，[xuzaixian](https://github.com/xuzaixian)

# 几张 GIF 动图让你看懂弹性盒模型（Flexbox）如何工作

![](https://cdn-images-1.medium.com/max/2000/1*zyzR64aw4rDPsoG-ZwZ9rQ.png)

弹性盒模型许诺可以解决纯 CSS 造成的诸多弊端（比如垂直对齐）。

好吧，它的确兑现了诺言。但是掌握这种新的思路可不是一件简单的事情。

所以我们将以动图的形式来看看弹性盒模型是怎么工作的，好在以后的工作中使用它来构建更好的布局。

弹性盒模型的基本原理是让布局变得直观且富有弹性。

要实现这个目标，它会让容器自己决定如何均匀分布它的子元素，包括子元素的大小和相互之间的间隔。

这些从原理上讲都很好理解。但让我们来看看在实践当中它又会是什么样子。

在本文当中，我们将深入弹性盒模型最常用的 5 个属性。探究一下它们做了什么、如何使用它们、以及会产生什么效果。

### 第一个属性：Display: Flex

下面是我们的示例页面：

![](https://cdn-images-1.medium.com/max/2000/1*ifusEqwI87nBKXgK9oZ_7A.gif)

有四个不同大小和颜色的 div，包含在一个灰色的 div 容器里。现在，每个 div 都有一个默认的属性为 `display: block`，因此每个 div 块都占满了整行的宽度。

为了使用弹性盒模型，需要将**容器**变成一个**弹性容器**，更改代码如下，很简单：

    #container {
      display: flex;
    }

![](https://cdn-images-1.medium.com/max/2000/1*L2W-ziqU45a1BNWV79ijDQ.gif)

可以看到并没有改变很多代码，容器里的 div 就展示为行内形式了。但在这个操作背后，其实已经发生了很大的变化，因为**你给每个块赋予了一个叫做弹性上下文的东西**。

现在你就可以开始在这个上下文里改变它们的位置，相比传统的 CSS 简单多了。

### 第二个属性：Flex Direction

弹性盒模型的容器有两个轴：**主轴**和**交叉轴**，它们默认如下所示：

![](https://cdn-images-1.medium.com/max/1600/1*_Ruy6jFG7gUpSf76IUcJTQ.png)

**默认状态下，容器里的每一个元素都会从左至右沿着主轴排列**。这也是为什么一旦 `display: flex` 生效，所有块都会默认排列在一个水平线上。

但是 `Flex-direction` 可以让你旋转主轴。

    #container {
      display: flex;
      flex-direction: column;
    }

![](https://cdn-images-1.medium.com/max/2000/1*4yKnG2-vuPF5XA-BmXADLQ.gif)

这里有一个很重要的区别：`flex-direction: column` 并不是把块从主轴移到交叉轴上排列，**而是让主轴自身从水平变成垂直。**

另外 flex-direction 还有两个选项值：**row-reverse** 和 **column-reverse**。

![](https://cdn-images-1.medium.com/max/2000/1*PBr_ncouIehALaEOWmSbpQ.gif)

### 第三个属性：Justify Content

**justify-content** 控制元素在**主轴**上的对齐方式。

下面，将稍微深入一下主轴和交叉轴的区别。首先，回到 `flex-direction: row` 的状态。

    #container {
      display: flex;
      flex-direction: row;
      justify-content: flex-start;
    }

**justify-content** 有五个可选值：

1. Flex-start
2. Flex-end
3. Center
4. Space-between
5. Space-around

![](https://cdn-images-1.medium.com/max/2000/1*2-6Tw8jqWrMKOfIugKyuDA.gif)

`space-around` 和 `space-between` 是最直观的。**`space-between` 使每个块之间产生相同大小的间隔，但不会在容器和块之间产生。**

`space-around` 则会在每个块的两边产生一个相同大小的间隔，也就是说**最外层块和容器之间的间隔大小刚好是两块之间间隔大小的一半**（每个块产生的间隔不重叠，所以间隔变成两倍）。

最后一个注意点：记住 **`justify-content` 是沿着主轴工作的**，**而 `flex-direction` 则是用来改变主轴的**。当看到下一个属性的时候就会发现这点很重要。

### 第四个属性: Align Items

如果你掌握了 `justify-content`，`align-items` 也会很容易掌握。

前面讲到 `justify-content` 是沿着主轴工作的，而 **`align-items` 则作用于交叉轴。**

![](https://cdn-images-1.medium.com/max/1600/1*_Ruy6jFG7gUpSf76IUcJTQ.png)

首先重置 `flex-direction` 为 row，这样我们的轴就和上图一样了。

然后，来深入一下 `align-items` 这个属性，可选值如下：

1. flex-start
2. flex-end
3. center
4. stretch
5. baseline

前三个值和 `justify-content` 的完全一样，所以这里略过。

但下面两个值有一点不一样。

`stretch` 状态下，每一项都会占满整个交叉轴，而 `baseline` 状态下，将按照段落标签的底部对齐（译者注：图中每个块里的数字均由`p`标签包含，此处就是按照`p`标签的底部对齐）。

![](https://cdn-images-1.medium.com/max/2000/1*htfdNmRIIFu_veRaFOj5qA.gif)

（注意 `align-items: stretch`，必须将每一块的高度设置为 `auto`，否则高度属性（height）就会将 `stretch` 的作用给覆盖掉。）

对于 baseline 来说，要意识到如果去掉段落标签，就将按照每个块的底部对齐（译者注：只要是元素标签内没有文字或者子标签内没有文字，均会按照每个块的底部对齐），像下面这样：

![](https://cdn-images-1.medium.com/max/2000/1*6dd9KnKMUN49lFsbHlJi6A.png)

为了更清楚地阐明主轴和交叉轴的区别，下面我们来把 `justify-content` 和 `align-items` 合在一起，看看在 `flex-direction` 两种值的作用下轴心有什么不一样：

![](https://cdn-images-1.medium.com/max/2000/1*6mq-Uay7t6NhdF2E41Do0g.gif)

**取值为 row 时，每个块会按照一个水平的主轴进行排列，为 column 时，它们就会按照一个垂直的主轴向下排列。**

虽然这些块在两种情况下都可以水平或者垂直居中，但这两者是不可以相互转化的！

### 第五个属性: Align Self

`align-self` 允许你手动设置一个特定元素的对齐方式。

它会针对一个块覆盖掉 `align-items` 属性。容器内元素的所有属性都默认为 `auto`，所以每个块默认会使用容器的 `align-items` 属性。

    #container {
      align-items: flex-start;
    }

    .square#one {
      align-self: center;
    }
    // 只有这个块会居中

下面将给两个块设置 `align-self` 属性，其余的使用 `align-items: center` 和 `flex-direction: row`，来看看会是什么效果：

![](https://cdn-images-1.medium.com/max/2000/1*HIADl1oL6pxXb2dMh_pXSQ.gif)

### 结论

尽管我们只介绍了弹性盒模型的一点皮毛，但对于操作基本的对齐，或者垂直排列你的核心内容来说，这些属性应该足够使用了。

如果你想看到更多的 GIF 弹性盒模型教程，或者如果这个教程对你有帮助，请点击下面的绿色心形或者留下一个评论吧。

感谢阅读！
