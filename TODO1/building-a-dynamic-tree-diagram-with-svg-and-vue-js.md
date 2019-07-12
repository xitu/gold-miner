> * 原文地址：[Building a Dynamic Tree Diagram with SVG and Vue.Js](https://medium.com/@krutie/building-a-dynamic-tree-diagram-with-svg-and-vue-js-a5df28e300cd)
> * 原文作者：[Krutie Patel](https://medium.com/@krutie)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-dynamic-tree-diagram-with-svg-and-vue-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/building-a-dynamic-tree-diagram-with-svg-and-vue-js.md)
> * 译者：[YueYong](https://github.com/YueYongDev)
> * 校对者：[Moonliujk](https://github.com/Moonliujk),[shixi-li](https://github.com/shixi-li)

# 使用 SVG 和 Vue.Js 构建动态树图

本文将会带你了解到我是如何创建一个动态树图的，该图使用 SVG（可缩放矢量图形）绘制三次贝塞尔曲线（Cubic Bezier）路径并通过 Vue.js 以实现数据响应。

在开始前，[先让我们来看一个 demo](http://svg-tree-diagram.surge.sh)。

![](https://cdn-images-1.medium.com/max/2242/1*i9yyyuT1hxMj1K7ZGP4vDg.png)

基于 SVG 和 Vue.js 框架的强大功能，我们可以轻松创建基于数据驱动、可交互和可配置的图表与信息图。

该图是一个三次贝塞尔曲线的集合，它基于用户提供的数据，从单点出发，并在不同的点结束，且点和点之间的距离相同。 因此，该图会响应用户输入的内容。

我们将首先学习如何制作三次贝塞尔曲线，然后通过剪切蒙版在坐标系中尝试找到 `<svg>` 元素可用的 `x` 和 `y` 点。

我在这个案例中使用了很多视觉动画以保证趣味性。本文的主要思想是帮助你为类似的项目设计出自己的图表。

## SVG

#### Cubic Bezier 曲线是如何形成的？

你在上面的 demo 中看到的曲线被称为三次贝塞尔曲线。我已在下面高亮显示了此曲线结构的每个部分。

![](https://cdn-images-1.medium.com/max/3960/1*GPp1gpDRFC-Xx9z7Tg85iQ.png)

它总共有 4 对坐标。第一对坐标 —— `(x0, y0)` —— 是起始锚点，最后一对坐标 —— `(x3, y3)` —— 是结束锚点，指示完成路径的位置。

中间的两对坐标是：

* 贝塞尔控制点 #1 `(x1, y1)` 和
* 贝塞尔控制点 #2 `(x2, y2)`

基于这些点实现的路径是一条平滑曲线。如果没有这些控制点，这条路径就是一条笔直的线！

让我们把这四个坐标放入 SVG 语法的 `<path>` 元素中。

```
// 三次贝塞尔曲线的路径语法

<path D="M x0,y0  C x1,y1  x2,y2  x3,y3" />
```

语法中的字母 `c` 代表三次贝塞尔曲线。小 `c` 表示相对值，而大写 `C` 表示绝对值。我用绝对值 `C` 来创建这个图。

**实现对称性**

对称性是实现该图的关键点。为了实现这一点，我只使用一个变量来派生出类似于高度，宽度和中点等值。

就让我们把这个变量命名为 `size` 吧。由于此树形图的方向是水平的，因此可以将变量 `size` 视为整张图的**水平**空间。

让我们为这个变量赋予实际值。这样，你还可以计算路径的坐标。

```
size = 1000
```

## 寻找坐标

在我们寻找坐标前，我们需要新建一个坐标系！

#### 坐标系和 viewBox

`<svg>` 元素的 `viewBox` 属性非常重要，因为它定义了 SVG 的用户坐标系。简而言之，`viewBox` 定义了用户空间的位置和维度以便于绘制 SVG。

`viewBox` 由四个数字组成，顺序需要保持一致 —— `min-x, min-y, width, height`。

```
<svg viewBox="min-x min-y width height">...</svg>
```

我们之前定义的 `size` 变量将控制此坐标系的 `width` 和 `height`。

稍后在 Vue.js 部分，`viewBox` 将绑定到计算属性以填充 `width` 和 `height`，而 `min-x` 和 `min-y` 在此实例中始终为零。

请注意，我们没有使用 **SVG 元素**本身的 `width` 和 `height` 属性。因为，我们稍后会通过 CSS 设置 `<svg>` 的 `width: 100%` 和 `height: 100%`，以便自适应填满整个 viewport。

现在整张图的用户空间 / 坐标系已准备好，让我们看看 `size` 变量如何通过使用不同的 `%` 值来帮助计算坐标。

#### 恒定和动态坐标

![Diagram Concept](https://cdn-images-1.medium.com/max/5184/1*2CRePTNtiym2q7eJKxEUWQ.png)

圆是图的一部分。这就是为什么从一开始就把它包含在计算中是很重要的。如上图所示，让我们开始导出一个**圆**和**一个样本路径**的坐标值。

**垂直高度分为两部分：`topHeight`（`size` 的 20%）和 `bottomHeight`（`size` 剩余的 80%）。水平宽度分为两部分 —— 分别是 `size` 的 50%**。

这样圆坐标（`halfSize, topHeight`）就显而易见了。圆的 `radius` 属性设置为 `topHeight` 的一半，这样的可用空间非常合适。

现在，让我们看一下路径坐标……

* **`x0, y0`** —— 第一对锚点**始终保持不变**。这里，`x0` 是图表 `size` 的中心，`y0` 是圆圈停止的垂直点（**因此增加了一个 radius**）并且是路径的起点。  
=`（50% 的 size, 20% 的 size + radius）`
* **`x1, y1`** —— 贝塞尔控制点 1，对于所有路径**也保持不变**。考虑到对称性，`x1` 和 `y1` 总是图表 `size` 的一半。
= `(50% 的 size, 50% 的 size)`
* **`x2, y2`** —— 贝塞尔控制点 2，其中 `x2` 指示哪一侧形成曲线并且为每条路径**动态计算**。同样，`y2` 是图表 `size` 的一半。  
= `(x2, 50% 的 size)`
* **`x3, y3`** —— 最后一对锚点，指示路径绘制结束的位置。这里，`x3` 模仿 `x2` 的值，这是动态计算的。`y3` 占据了 `size` 的 80%。  
= `(x3, 80% 的 size)`

在合并上述计算结果后，请参阅下面的通用路径语法。为了表示 `%`，我只是简单的将 `%` 值除以 100。

```
<path d="M size*0.5, (size*0.2) + radius  
         C size*0.5,  size*0.5
           x2,        size*0.5
           x3,        size*0.8"
>
```

**注意：整个代码逻辑中 `%` 的选择最初看起来似乎全是主观推断，但它是为了实现对称而选择的正确比例。一旦你了解了构建此图表的目的，你就可以尝试自己的 `%` 值并检查不同的结果。**

下一部分重点是找到剩余坐标 `x2` 和 `x3` 的值 —— 这使得能够根据它们的数组索引动态地形成多个弯曲路径。

根据数组中的多个元素，可用的水平空间应分配到相等的部分，以便每个路径在 `x-axis` 上获得相同的空间量。

公式最终应适用于任意数量的项目，但出于本文的目的，我已经使用了 5 个数组项 —— `[0,1,2,3,4]`。意思是，我将绘制 5 条贝塞尔曲线。

#### 寻找动态坐标（x2 和 x3）

首先，我将 `size` 除以元素数，即数组长度，并命名为 `distance` —— 作为两个元素之间的距离。

```
distance = size/arrayLength
// distance = 1000/5 = 200
```

然后，我循环遍历数组中的每个元素，并将其 `index` 值乘以 `distance`。 为了描述简单，我用 `x` 表示 `x2` 和 `x3`。

```
// value of x2 and x3
x = index * distance
```

当我使用 `x` 的值来表示 `x2` 和 `x3` 时，这张图看起来有点奇怪。

![](https://cdn-images-1.medium.com/max/6068/1*0whAEEtgKwVpeNf1uZY5ug.png)

如你所见，坐标的位置是正确的，但不是很对称。左侧的元素看起来比右侧的元素多。

此时因为一些原因，我需要将 `x3` 坐标放在 `distance` 的中心，而不是在一开始的地方。

为了解决这个问题，让我们重新审视下变量 `distance` —— 对于给定的场景，它的值是 200。我只是给 `x` 又加了 **distance 的一半**。

```
x = index * distance + (distance * 0.5)
```

上式意思是，我找到了 `distance` 的中点并将最终的 `x3` 坐标放在那里，并调整了贝塞尔曲线 #2 的 `x2`。

![](https://cdn-images-1.medium.com/max/6334/1*i2-TArj3Jol77m5f2fxgZA.png)

在 `x2` 和 `x3` 坐标中添加 **distance 的一半**，适用于数组的奇数项和偶数项元素。

#### 图层蒙版

为了使蒙版形状为圆形，我已经在 **mask** 元素中**定义**了一个 **circle**。

```
<defs>
  <mask id="svg-mask">
     <circle :r="radius" 
             :cx="halfSize" 
             :cy="topHeight" 
             fill="white"/>
  </mask>
</defs>
```

接下来，使用 `<svg>` 元素中的 `<image>` 标签作为内容，我使用 `mask` 属性将图像绑定到 `<mask>` 元素里（已在上述代码中创建）。

```
<image mask="url(#svg-mask)" 
      :x="(halfSize-radius)" 
      :y="(topHeight-radius)"
...
> 
</image>
```

由于我们试图将方形图像拟合成圆形，我通过减小圆的 `radius` 来调整图像位置，以通过圆形蒙版实现图像的完全可见性。

让我们将所有的值都放入图表中，以帮助我们看到完整的图像。

![](https://cdn-images-1.medium.com/max/3752/1*kWPi7xIsu6PF9drIwOKo4Q.png)

## 使用 Vue.js 的动态 SVG

到目前为止，我们已经了解了贝塞尔曲线的本质，以及它的工作原理。因此，我们有了静态 SVG 图的概念。使用 Vue.js 和 SVG，我们现在将用数据驱动图表，并将其从静态转换为动态。

在本节中，我们将把 SVG 图分解为 Vue 组件，并将 SVG 属性绑定到计算属性，并使其响应数据更改。

最后，我们还将查看配置面板组件，该组件用于向动态 SVG 图提供数据。

我们将在本节中了解以下关键主题。

- 绑定 SVG viewBox
- 计算 SVG 路径坐标
- 实现贝塞尔曲线路径的两个选项
- 配置面板
- 家庭作业 ❤

**绑定 SVG viewBox**

首先，我们需要一个坐标系统才能在 SVG 内部绘制。 计算属性 `viewbox` 将使用 `size` 变量。它包含由空格分隔的四个值 —— 它被送入 `<svg>` 元素的 **`viewBox`** 属性。

```
viewbox() 
{
   return "0 0 " + this.size + " " + this.size;
}
```

在 SVG 中，`viewBox` 属性**已经**使用驼峰命名法（camelCase）。

```
<svg viewBox="0 0 1000 1000">
</svg>
```

因此为了正确绑定上计算属性，我在 `.camel` 修饰符后对该变量使用了短横线命名（kebab-case）的方式（如下所示）。通过这种方式，HTML 才得以正确绑定此属性。

现在，每次我们更改 `size` 时，图表都会自行调整，而无需手动更改标记。

**计算 SVG 路径坐标**

由于大多数值都是从单个变量 `size` 派生的，所以我已经为所有常量坐标使用了计算属性。不要被这里的常量混淆。这些值是从 `size` 中派生出来的，但在**此**之后，无论创建多少曲线路径，它们都保持不变。

如果你改变 SVG 的大小，这些值会再次被计算出来。考虑到这一点，这里列出了绘制贝塞尔曲线所需的五个值。

* topHeight — `size * 0.2`
* bottomHeight — `size * 0.8`
* width — `size`
* halfSize — `size * 0.5`
* distance — `size/arrayLength`

此时，我们只剩下两个未知值，即 `x2` 和 `x3`，我们有一个公式可以确定它们的值。

```
x = index * distance + (distance * 0.5)
```

为了找到上面的 `x`，我们需要一次将 `index` 输入到每个路径的公式中。所以……

在这使用计算属性合适吗？肯定不合适。

我们不能将参数传递给计算属性 —— 因为它是一个属性，而不是函数。另外，需要一个参数来计算意味着——使用计算属性对缓存也没什么好处。

**注意：上面有一个例外，Vuex。如果我们正在使用 Vuex Getters，那么，我们可以通过返回一个函数将参数传递给 getter。**

在本文所述的情况下，我们不使用 Vuex。可即便如此，我们仍有两个选择。

#### 选择一

我们可以定义一个函数，在这里我们将数组 `index` 作为参数传递并返回结果。如果要在模板中的多个位置使用此值，选择 `Bit cleaner`。

```
<g v-for="(item, i) in itemArray">
  <path :d="'M' + halfSize + ','         + (topHeight+r) +' '+
            'C' + halfSize + ','         + halfSize +' '+    
                  calculateXPos(i) + ',' + halfSize +' '+ 
                  calculateXPos(i) + ',' + bottomHeight" 
  />
</g>
```

calculateXPos() 方法将在每次调用时进行评估。并且此方法接受索引 —— `i` —— 作为参数（代码如下）。

```
<script>
  methods: {
    calculateXPos (i)
    {
      return distance * i + (distance * 0.5)
    }
  }
</script>
```

下面是运行在 CodePen 上 Option 1 的结果。

[Option 1 - Bezier Curve Tree Diagram with Vue Js](https://codepen.io/krutie/pen/eoRXWP)

#### 选择二

更好的是，我们可以将这个小的 SVG 路径标记提取到它自己的子组件中，并将 `index` 作为一个属性传递给它 —— 当然，还有其他必需的属性。

在这个例子中，我们甚至可以使用计算属性来查找 `x2` 和 `x3`。

```
<g v-for="(item, i) in items"> 
    <cubic-bezier  :index="i" 
                   :half-size="halfSize" 
                   :top-height="topHeight" 
                   :bottom-height="bottomHeight" 
                   :r="radius"
                   :d="distance"
     >
     </cubic-bezier>
</g>
```

这种方法可以让我们的代码更具条理，例如，我们可以为一个圆形剪切蒙版创建一个或多个子组件，如下所示。

```
<clip-mask :title="title"
           :half-size="halfSize" 
           :top-height="topHeight"                     
           :r="radius"> 
</clip-mask>
```

#### 配置面板

![Config Panel](https://cdn-images-1.medium.com/max/2000/1*zI1UlqRzNrxoGQdgl9nCSA.png)

您可能已经在 CodePen 左上角看到了 **控制面板**。它可以添加和删除数组中的元素。在 Option 2 中，我创建了一个子组件来容纳 Config Panel，使顶级 Vue 组件清晰可读。我们的 Vue 组件树看起来就像下面这样。

![](https://cdn-images-1.medium.com/max/2942/1*ztoHw3dN6o_0VvwI1UOpxw.png)

想知道 Option 2 的代码是什么样子的？下面的链接是在 CodePen 上使用了 Option 2 的代码。

[Option 2 - Bezier Curve Tree Diagram with Vue Js](https://codepen.io/krutie/pen/Bexoez)

## GitHub 仓库

最后，这里有一个为你准备的 [GitHub Repo](https://github.com/Krutie/svg-tree-diagram)，你可以在进入下一部分之前查看该项目（使用选项 2）。

## 家庭作业

尝试基于本文中介绍的逻辑在垂直模式下创建相同的图表。

如果你认为，它是交换坐标系中的 `x` 值和 `y` 值一样简单的话，那么你是对的！因为最艰难的部分已经完成，在交换了**所需**的坐标后，再用适当的变量和方法更新代码。

在 Vue.js 的帮助下，该图可以通过更多功能进一步扩展，例如，

* 创建一个开关以便于在水平和垂直模式之间切换
* 可以使用 GSAP 为路径设置动画
* 从配置面板控制路径属性（例如颜色和笔触宽度）
* 使用第三方工具库将图表保存并下载为图像/PDF

现在试一试，如果需要的话，下面是家庭作业的答案链接。

祝你好运！

## 总结

`<path>` 是 SVG 中众多强大的元素之一，因为它允许你精确地创建图形和图表。在本文中，我们了解了贝塞尔曲线的工作原理以及如何创建一个自定义图表应用。

利用现代 JavaScript 框架所使用的数据驱动方法进行调整总是令人生畏的，但 Vue.js 使它变得非常简单，并且还可以处理诸如 DOM 操作之类的简单任务。因此，作为一名开发人员，即使在处理具有明显视觉效果的项目时，你也可以用数据的方式进行思考。

我已经意识到创建这个看起来很复杂的图表需要 Vue.js 和 SVG 的一些简单概念。如果你还没有准备好，我建议您阅读有关[使用 Vue.js 构建交互式信息图](https://www.smashingmagazine.com/2018/11/interactive-infographic-vue-js/)的内容。读完那篇文章后再回过头阅读本文就会容易很多。❤这是家庭作业的[答案](https://codepen.io/krutie/pen/QRrNKz)。

我希望你从这篇文章中学到了一些东西，并在阅读本文时能够感受到我当时创作时的乐趣。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
