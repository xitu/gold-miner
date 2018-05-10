> * 原文地址：[How to Build a Delightful Loading Screen in 5 Minutes](https://medium.freecodecamp.org/how-to-build-a-delightful-loading-screen-in-5-minutes-847991da509f)
> * 原文作者：[Ohans Emmanuel](https://medium.freecodecamp.org/@ohansemmanuel?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-delightful-loading-screen-in-5-minutes.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-build-a-delightful-loading-screen-in-5-minutes.md)
> * 译者：[whuzxq](https://github.com/whuzxq)
> * 校对者：[luochen1992](https://github.com/luochen1992)、[ALVINYEH](https://github.com/ALVINYEH)

# 如何在 5 分钟之内写出一个不错的 loading 界面

首先，让我们先看一下效果图。

![](https://cdn-images-1.medium.com/max/800/1*AF1rXY_iumutiVOMSXf_LQ.gif)

这就是我们将要实现的 [DEMO](https://codepen.io/ohansemmanuel/pen/ZxOjGx)。

是不是觉得看起来很眼熟？

如果眼熟的话，那你可能在 [Slack](https://slack.com) 上见过它！

让我们只使用 css 和 html，来实现一下这个 loading 页面吧！

如果你想小试身手，可以在 [Codepen](http://codepen.io) 上创建一个 pen，编写教程代码。

现在，让我们开始吧！

#### 1. 添加 class 作为标记

html 部分很简单，如下面代码所示：

```
<section class="loading">

For new sidebar colors, click your workspace name, then     Preferences > Sidebar > Theme

<span class="loading__author"> - Your friends at Slack</span>
    <span class="loading__anim"></span>

</section>
```

是不是很简单？

如果你不清楚为什么类名中出现了破折号，我在 [这篇文章](https://medium.freecodecamp.org/css-naming-conventions-that-will-save-you-hours-of-debugging-35cea737d849) 中解释了背后的原因。

现在我们有一些文本，以及一个类名为 `loading_anim` 的 span 标签。

效果图如下：

![](https://cdn-images-1.medium.com/max/800/1*RpS6k11QbgHRIuAvy1Hw5Q.png)

还不赖，对吧？

#### 2. 将内容居中

现在的效果并不理想，下一步我们将 class 为 `loading` 的 session 标签在页面上居中。
```
body {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}
```

![](https://cdn-images-1.medium.com/max/800/1*MPjfL4fwZlLkoja4cNg-Zg.png)

现在居中了！

有没有看起来好一点？

#### 3. 设置加载文本的样式

现在，让我们设置 class 为 `.loading` 的文本样式，使其看上去更棒。

```
.loading {
  max-width: 50%;
  line-height: 1.4;
  font-size: 1.2rem;
  font-weight: bold;
  text-align: center;
}
```

![](https://cdn-images-1.medium.com/max/800/1*wmMG_h5lJURLsYEZLv8ltw.png)

#### 4. 设置下方 loading_author 的样式

```
.loading__author {
  font-weight: normal;
  font-size: 0.9rem;
  color: rgba(189,189,189 ,1);
  margin: 0.6rem 0 2rem 0;
  display: block;
}
```

看看效果！

![](https://cdn-images-1.medium.com/max/800/1*uok3Fg7Kqd8ASbONmK1RSA.png)

#### 5. 创建 loading 动画

终于到了备受期待的一步。这是最长的一个步骤，在此之前我会花一些时间确保你了解它的工作原理。

如果您遇到困难，请发表评论，我很乐意提供帮助。

再回顾一遍 loading 的效果。

![](https://cdn-images-1.medium.com/max/800/1*AF1rXY_iumutiVOMSXf_LQ.gif)

我们可以看到 loading 圆环一半是蓝色，另一半是灰色的。 默认情况下，`HTML` 元素不会被切分。所有HTML元素可以看作*盒子*。第一个真正的挑战是如何使 class 为 `.loading__anim` 的元素包含两种边框颜色。

如果你现在还没有太明白，不要担心。后面会继续进行讲解。

首先，让我们先定义 loading 的大小。

```
.loading__anim {
  width: 35px;
  height: 35px;
 }
```

现在，loading 组件与文本位于同一行，这是因为 `span` 标签是 html 中的内联元素。 

我们现在修改样式，使其在另一行展示。

```
.loading__anim {
   width: 35px;
   height: 35px;
   display: inline-block;
  }
```

最后，让我们为其设置 border 属性。

```
.loading__anim {
   width: 35px;
   height: 35px;
   display: inline-block;
   border: 5px solid rgba(189,189,189 ,0.25);
  }
```

在元素周围会形成宽度为 5 px的灰色边框。

下方为效果图。

![](https://cdn-images-1.medium.com/max/800/1*6IaPRnPBuODTJT6mm9dNFw.png)

显示出一个灰色的边框。

让我们继续完善它。

一个元素有四条边, `top` , `bottom` , `left` , 和 `right`。

我们之前设置的 `border` 对四个边都实现了相同的渲染。

我们现在需要对 loading 组件的边框设置不同的颜色。

无论你选择哪条边都可以，在下方代码中以 `top` 和 `left` 举例演示。

```
.loading__anim {
  width: 35px;
  height: 35px;
  display: inline-block;
  border: 5px solid rgba(189,189,189 ,0.25);
  border-left-color: rgba(3,155,229 ,1);
  border-top-color: rgba(3,155,229 ,1);
  }
```

现在，`left` 和 `top` 边界将呈现蓝色。 效果图如下：

![](https://cdn-images-1.medium.com/max/800/1*bq8bUGVNglafbnDDj_beFw.png)

看起来还可以。

我们马上要成功了！

这个 loading 组件是圆的，而不是方的。让我们通过给 `.loader__anim` 组件设置 `border-radius` 属性为 `50%`，来改变它的形状。

效果图如下：

![](https://cdn-images-1.medium.com/max/800/1*Krr3W7AwgW3ZThim62VZtg.png)

不是很差，是吧？

最后一步是制作动画。

```
@keyframes rotate {
 to {
  transform: rotate(1turn)
 }
}
```

希望您对 [CSS 动画](https://www.w3schools.com/css/css3_animations.asp) 有所了解。 `1 turn` 等于 `360 deg`，表示完整的转了一个 360 度的圈。

并按如下方式使用：

```
animation: rotate 600ms infinite linear;
```

哟！我们做到了！

请看最终效果图。

![](https://cdn-images-1.medium.com/max/800/1*DQFXH8zH4RpOFOqOb4DbMg.gif)

lo hicimos! (西班牙语)

是不是很酷？

如果有任何步骤使您困惑，请发表评论，我很乐意提供帮助。

### 想要进阶学习？

我已经创建了一个免费的 CSS 指南，以便您能立刻掌握 CSS 技能。 [获取电子书。](http://eepurl.com/dgDVRb)

![](https://cdn-images-1.medium.com/max/800/1*fJabzNuhWcJVUXa3O5OlSQ.png)

你不知道的七个 css 秘密。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
