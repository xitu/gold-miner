> * 原文地址：[Responsive CSS Grid: The Ultimate Layout Freedom](https://medium.muz.li/understanding-css-grid-ce92b7aa67cb)
> * 原文作者：[Christine Vallaure](https://medium.com/@christinevallaure)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/understanding-css-grid.md](https://github.com/xitu/gold-miner/blob/master/article/2021/understanding-css-grid.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[zenblo](https://github.com/zenblo)、[Chorer](https://github.com/Chorer)、[lsvih](https://github.com/lsvih)

# 自适应 CSS 栅格：自由布局的最终版本

![](https://cdn-images-1.medium.com/max/2800/0*MJfiLHUiFLi5M2sm.png)

CSS 栅格布局（Grid）是一种全新的在 Web 上创建二维布局的方法。我们仅需几行 CSS，就可以创建一个之前不用 JavaScript 根本不可能实现的栅格布局。我们不需要任何插件或复杂的安装步骤，不需要繁琐的附加文件，同时也不需要局限于 12 列的栅格布局（译者注：指 Bootstrap 提供的 12 栅格系统）。

## 我们可以使用什么栅格？

简而言之：我们实际上可以使用**几乎所有能够想到的栅格布局**，并且还不限于此。我们可以自由地选择不同栅格的尺寸、大小和位置。你可以在[栅格示例](https://gridbyexample.com/examples/)中找到最常见的带有标记的栅格的概述。

### 让我们从构建示例的 HTML 标记开始吧！

一个类名为 `container` 的 `div` 元素容纳了 5 个子 `div` 元素，或称之为项目（当然，可以比 5 个更多或者更少）。如果你愿意，我们可以直接从 [CodePen 中的 HTML 和 CSS 标记](https://codepen.io/chrisvall/pen/YJJdxQ)代码入手。

```html
<div class="container">
    <div class="item color-1">item-1</div>
    <div class="item color-2">item-2</div>
    <div class="item color-3">item-3</div>
    <div class="item color-4">item-4</div>
    <div class="item color-5">item-5</div>
</div>
```

![我额外添加了一些 CSS 代码让大家更好理解，与 Grid 实现毫无关系](https://cdn-images-1.medium.com/max/2800/0*lCX1UQBdGhuXCuJl.jpeg)

### 基础：在 CSS 中设置栅格和行列

在 CSS 中，我们可以通过 `display: grid` 定义将 `.container` 类的元素变为栅格布局。通过使用 `grid-template-columns`，我们划分了所需的列（本例中将划分 5 列，每列设置为 250px）。通过使用 `grid-template-rows`，我们可以设置行的高度（如果需要的话），本例中是 150px。完成以上步骤之后，我们就实现了第一个栅格布局！

```css
.container {
    display: grid;
    grid-template-columns: 250px 250px 250px 250px 250px;
    grid-template-rows: 150px;
}

/* 缩写：
 grid-template-columns: repeat(5, 250px); */ 
```

![](https://cdn-images-1.medium.com/max/2800/0*yYYJTjLzTLzogzyu.jpeg)

### 设置间隔

我们可以使用 `grip-gap` 来设置每一项之间的间隔，也可以使用 `column-gap` 和 `row-gap` 分别设置水平和垂直的间隔。顺便提一句，我们可以使用所有通用单位，例如使用 `px` 用于设置固定的间隔，或使用 `％` 来设置自适应的间隔。

```css
.container {
    display: grid;
    grid-template-columns: repeat(5, 250px);
    grid-template-rows: 150px;
    grid-gap: 30px;
}
```

![需要注意的是容器的左边会将间隔减半，因此在本例中他们的间隔是 15px（对大多数其它的栅格同理）](https://cdn-images-1.medium.com/max/2800/0*CR0ENpYQu_-fNCuD.png)

<small>译者注：在 Chrome 91，Safari 14.0.2，Firefox 86.0a1 均未有此现象，估摸为原文笔误或版本不同</small>

### 使用 `fr` 自动填充剩余空间

这可是每一个设计师的梦想！我们可以使用 **分数单位**（Fractional Units）或简写 `fr`，根据我们自己的想法分配可用空间！例如，在这里，我们将屏幕空间划分为 6 个部分。 第一列占用空间的 1/6 = 1fr，第二列 3/6 = 3fr，第三列 2/6 = 2fr。当然，我们也可以根据需要添加 `grid-gap`。

```css
.container {
    display: grid;
    grid-template-columns: 1fr 3fr 2fr;
}
```

![](https://cdn-images-1.medium.com/max/2980/0*yh7hFOcFs43LM9q8.gif)

现在所有的行都是自适应的！

### 混合使用 `px` 和 `fr` 构建自适应而又固定的列

`px` 和 `fr` 的按需同时使用可以让栅格适应可用的空间，这非常好用！

```css
.container {
    display: grid;
    grid-template-columns: 300px 3fr 2fr;
}
```

![第一列用了 `px` 去固定尺寸，而剩余的布局是自适应的](https://cdn-images-1.medium.com/max/2000/0*9buHg29Y9pG0bJir.gif)

### 排序上的绝对自由

私以为，最棒的是在栅格中，我们可以自由设置每一项所占用的尺寸！我们可以用 `grid-column-start` 设置起点，并用 `grid-column-end` 设置终点，或采用缩写方式 `grid-column: startpoint / endpoint;`：

```css
.container {
    display: grid;
    grid-template-columns: 1fr 3fr 2fr;
}

.item-1 {
    grid-column: 1 / 4;
}

.item-5 {
    grid-column: 3 / 4;
}
```

![](https://cdn-images-1.medium.com/max/2800/0*fGVZP5_NMbf9UJs3.png)

别被栅格线所迷惑，它们总是在第一项的开始！

### 同样适用于垂直或全区域的分布！

在这方面 CSS Grid 耀眼十足，表现出了对比 Bootstrap 和 Co 的优越性 —— 借助 `grid-row`，每一项都可以定义任意的位置及宽度。正如我们将在下一个示例中看到的那样，这对于适应不同屏幕尺寸和设备具有绝对优势：

```css
.container {
    display: grid;
    grid-template-columns: 1fr 3fr 2fr;
}

.item-2 {
    grid-row: 1 / 3;
}

.item-1 {
    grid-column: 1 / 4;
    grid-row: 3 / 4;
}
```

![任何垂直方向上的宽度和位置 ](https://cdn-images-1.medium.com/max/2800/0*a3fS5-GjETjWhArV.png)

### 想要适应不同的屏幕尺寸和设备？当然没问题！

CSS Grid 与常规栅格相比也具有明显的优势，根据屏幕大小，我们不仅可以通过媒体查询从自适应值切换到固定值，还可以调整整个项目的位置！

```css
.container {
    display: grid;
    grid-template-columns: 250px 3fr 2fr;
}

.item-1 {
    grid-column: 1 / 4;
}

.item-2 {
    grid-row: 2 / 4;
}

@media only screen and (max-width: 720px) {
    .container {
        grid-template-columns: 1fr 1fr;
    }

    .item-1 {
        grid-column: 1 / 3;
        grid-row: 2 / 3;
    }

    .item-2 {
        grid-row: 1 / 1;
    }
}
```

![](https://cdn-images-1.medium.com/max/2856/0*zF54G2_cLwYLyNh-.gif)

## 浏览器支持

现在，所有现代浏览器（Safari、Chrome、Firefox、Edge）都原生地支持 CSS Grid。凭借 87.85% 的全球支持率（译者注：截止至译文发布时，支持率已达到 95.47％），CSS Grid 已经成为 Boostrap 和 Co 的替代品。

![2021 年 3 月的状态，数据来自 [caniuse.com](https://caniuse.com/#search=CSS%20Grid)](https://github.com/PassionPenguin/gold-miner-images/blob/master/understanding-css-grid-caniuse.com__search=CSS%2520Grid.png?raw=true)

## CSS 栅格的实践案例

- [christinevallaure.com,](http://www.christinevallaure.com)，UX/UI 设计
- [moonlearning.io](https://moonlearning.io/)，UX/UI 在线课程
- [Slack](https://slack.com/intl/de-de/)，企业网站
- [Medium](https://medium.com/)，原文发布的地方
- [Skyler Hughes](https://photo.skylerhughes.com/)，摄影网站
- [Max Böck](https://mxb.at/)，前端开发者网站
- [Design+Code](https://designcode.io/)，Web 设计师站点
- [Hi Agency, Deck](http://www.hi.agency/deck/)，模版页面

## 在你开始使用 Grid 之前

我想你可能还会喜欢我在 [moonlearning.io](https://moonlearning.io/) 或[完整的设计移交到开发课程](https://www.udemy.com/course/design-handoff/?referralCode=1296BF141742FFA166C2) 上发布的其它文章和课程（有关如何使用 Grid 的更多信息！）。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
