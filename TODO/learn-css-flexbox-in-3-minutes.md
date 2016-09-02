> * 原文地址：[Learn CSS Flexbox in 3 Minutes]()(https://medium.com/learning-new-stuff/learn-css-flexbox-in-3-minutes-c616c7070672)
* 原文作者：[Per Harald Borgen]()(https://medium.com/@perborgen)
* 译文出自：[掘金翻译计划]()(https://github.com/xitu/gold-miner)
* 译者：[Gran](https://github.com/Graning)
* 校对者：

![]()(https://cdn-images-1.medium.com/max/800/1\*baslR\_nGORHYX4STOjhhpg.png)

在这篇文章中你将学到关于 CSS 中 flexbox 布局 **最重要** 的概念。如果你发现你经常在 CSS 布局上纠结，这篇文章将帮你解脱出来。

我们将只专注那些核心要素，暂时抛弃那些你现在 **不应该注意** 东西直到你掌握基础之后。

**1\. 容器和 item**

Flexbox 布局中两个主要的组件是 **容器** （蓝色）和 **item** （红色）。我们将在本教程的在这个示例中看到，无论是 **容器** 还是 **item** 都是  **div’s**。查看 [示例代码](https://github.com/perborgen/FlexboxTutorial)。

#### 横向布局

要创建一个弹性布局，只需要给 **容器** 设置以下的 CSS 属性。

.container {
display: flex;
}

布局的结果如下：

![](https://cdn-images-1.medium.com/max/800/1\*3zzvOetr1fjDrZKEEmo9dA.png)

注意你目前不需要对 **item** 做任何事，他们将沿水平轴自动定位。

#### 垂直布局

在上述布局中，**主轴线** 是水平的，**横轴** 是垂直的。**轴** 的概念对理解弹性布局有帮助。

当你添加 **flex-direction**: **column** 时可以交换这两个轴。

.container {
display: flex;
flex-direction: column;
}



![](https://cdn-images-1.medium.com/max/800/1\*yPT-82-JPYk8b2Rh\_3K6sQ.png)


则现在 **主轴线** 是垂直的，而 **横轴** 是水平的，导致 **items** 被垂直堆叠。

### 2\. 两端对齐内容和 item 对准

为了使列表再次水平，我们可以从 **列** 到 **行** 交换 **弹性方向** 因为这将再次翻转弹性布局的轴。

轴的概念必须理解是因为 **justify-content** 和 **align-items** 的属性控制如何使 item 沿 **主轴线** 和 **横轴** 分别定位。

让我们沿着中央 **主轴线** 的所有 item 使用 **justify-content:**

.container {
display: flex;
flex-direction: row;
justify-content: center;
}

![](https://cdn-images-1.medium.com/max/800/1\*KAFfHDFWCd12qI3TqSS8DQ.png)

使用 **align-items** 沿着 **横轴** 进行调整。

.container {
display: flex;
flex-direction: row;
justify-content: center;
align-items: center;
}



![](https://cdn-images-1.medium.com/max/800/1\*S666Y69uJUWgQ0rz8tzjOQ.png)



以下是你可以为 **justify-content** 和 **align-items** 设置的其他值：

**justify-content:**

*   flex-start (**default**)
*   flex-end
*   center
*   space-between
*   space-around

**align-items:**

*   flex-start **(default)**
*   flex-end
*   center
*   baseline
*   stretch

我建议你将 **justify-content** 和 **align-items** 的属性组合使用，还有 **flex-direction** 是同时属于行和列的。这将让你更好的理解这个概念。

### 3\. The items

我们将了解的最后一件事就是 **items** 本身，以及如何将具体的样式单独设置。

比方说，我们想调整第一个 item 的位置，我们给它一个 **align-self** 以及同时接受相同值的 **align-items**  CSS 属性，这样做：

.item1 {
  align-self: flex-end;
}

将形成以下的布局：

![](https://cdn-images-1.medium.com/max/800/1\*-NBG56jX-QKYaga6qiF0eg.png)

就是这样！

当然还有更多可以了解 flexbox 相关知识的课程，但是上面的概念是我最常用的，最重要的还是正确理解基础概念。

