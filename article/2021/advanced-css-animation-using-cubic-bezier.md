> * 原文地址：[Advanced CSS Animation Using cubic-bezier()](https://dev.to/afif/advanced-css-animation-using-cubic-bezier-nho)
> * 原文作者：[Temani Afif](https://dev.to/afif)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/advanced-css-animation-using-cubic-bezier.md](https://github.com/xitu/gold-miner/blob/master/article/2021/advanced-css-animation-using-cubic-bezier.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 使用 cubic-bezier() 构建高级 CSS 动画

![](https://res.cloudinary.com/practicaldev/image/fetch/s--dYUYOuUc--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gtknacqxif7977upw8hy.png)

在处理复杂的 CSS 动画时，我们总是会倾向于使用大量声明创建扩展的 `@keyframes`。虽然我想谈谈一些技巧可能有助于使构建复杂动画变得更容易，同时还能保持使用原生 CSS 完成这一切：

1. 多种动画；
2. 计时功能；

第一个更广泛使用和熟悉，但第二个不太常见。这可能是有充分理由的 —— 用逗号链接动画比了解我们可用的各种计时函数及其作用相对容易。有一个特别简洁的计时功能，让我们可以完全控制创建自定义计时功能。那将是 `cubic-bezier()`，在这篇文章中，我将向您展示它的强大功能以及如何使用它不会太复杂地创建精美的动画。

让我们从一个基本示例开始，展示我们如何沿有趣的方向移动这个红色小球，例如无穷大（∞）形状：

[Codepen t_aifi/eYvmOxR](https://codepen.io/t_afif/pen/eYvmOxR)

如您所见，没有复杂的代码 —— 只有两个关键帧和一个**“奇怪的”** `cubic-bezier()` 函数。然而，我们却创建一个看起来非常复杂的无限形状动画。

这个动画说起来还真挺酷，对吧？让我们深入研究一下！

## cubic-bezier() 函数

先从[官方定义](https://www.w3.org/TR/css-easing-1/#cubic-bezier-easing-functions)说起：

> 三次 Bézier 缓动函数是一种缓动函数，由四个实数决定函数。这些实数指定三次 Bézier 曲线的两个控制点 $P_1$ 和 $P_2$，端点 $P_0$ 和 $P_3$ 分别固定在 $(0, 0)$ 和 $(1, 1)$。$P_1$ 和 $P_2$ 的 $x$ 坐标限制在 $[0, 1]$ 范围内。

[![三次 Bézier 函数](https://res.cloudinary.com/practicaldev/image/fetch/s--swZvbeY2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1xr5l3ky4bwjdj17sqwv.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--swZvbeY2--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/1xr5l3ky4bwjdj17sqwv.png)

上面的曲线定义了输出（$y$ 轴）将如何根据时间（$x$ 轴）表现。每个轴的范围为 $[0, 1]$ （或 $[0\%, 100\%]$ ）。如果我们有一个持续两秒（$2s$）的动画，那么：

$$
0(0\%) = 0s
\\
1(100\%) = 2s
$$

如果我们想从从左侧的 `5px` 动画到 `20px`，那么：

$$
0(0\%) = 5px
\\
1(100\%) = 20px
$$

$X$，时间，总是限制在 $[0, 1]$；但是，输出的 Y 可以超过 $[0,1]$。

我的目标是调整 $P_1$ 和 $P_2$ 以创建以下曲线：

[![CSS 三次 Bézier 函数](https://res.cloudinary.com/practicaldev/image/fetch/s--kPt0M5jS--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gzvyiub3yhvariwjs165.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--kPt0M5jS--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/gzvyiub3yhvariwjs165.png)

或许你可能认为这是不可能实现的，因为正如定义中所述，$P_0$ 和 $P_3$ 固定在 $(0, 0)$ 和 $(1, 1)$ 意味着它们不能在同一轴上。确实如此，但我们将使用一些数学技巧来“近似”实现它们。

---

## 抛物线

让我们从以下定义开始：`cubic-bezier(0,1.5,1,1.5)`，构造如下曲线：

[![cubic-bezier(0,1.5,1,1.5)](https://res.cloudinary.com/practicaldev/image/fetch/s--4s0YMOKb--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/jf8tjkqa6t5zqcybcv08.png%3Fw%3D648%26ssl%3D1)](https://res.cloudinary.com/practicaldev/image/fetch/s--4s0YMOKb--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/jf8tjkqa6t5zqcybcv08.png%3Fw%3D648%26ssl%3D1)

我们的目标是移动 $(1, 1)$ 并使其达到 $(0, 1)$，这在技术上是不可能的,所以我们会尝试仿造它。

我们之前说过我们的范围是 $[0, 1]$（或 $[0\%, 100\%]$），所以让我们想象一下 $0\%$ 非常接近 $100\%$ 的情况。例如，如果我们想将顶部从 $20px$ ($0\%$) 动画到 $20.1px$ ($100\%$)，那么我们可以说初始状态和最终状态是相等的。

嗯，但是我们的元素根本不会移动，对吧？

[codepen t_afif/abJzoMq](https://codepen.io/t_afif/pen/abJzoMq)

好吧，它会移动一点，因为 Y 值超过 $20.1px$ ($100\%$)，但这个细小的变化不足以，或者说，难以被我们所感知：

让我们更新曲线并使用 `cubic-bezier(0,4,1,4)` 代替，可以注意我们的曲线比以前高得多：

<table>
    <tr>
        <td>
            <img src="https://res.cloudinary.com/practicaldev/image/fetch/s--UHt-htyb--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/ws9k5wiplk5xu00iaj13.png%3Fw%3D385%26ssl%3D1" alt="Curve Bezier">
        </td>
        <td>
            <a href="https://codepen.io/t_afif/pen/eYvmOoR">Codepen t_afif/eYvmOoR</a>
        </td>
    </tr>
</table>

但是，仍然没有变动 —— 即使最大值超过 $3$（或 $300\%$）。不放让我们试试 `cubic-bezier(0,20,1,20)`：

<table>
    <tr>
        <td>
            <img src="https://res.cloudinary.com/practicaldev/image/fetch/s--LKjZf13L--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/r3ytyx91ra931q6iitop.png%3Fw%3D358%26ssl%3D1" alt="Curve Bezier">
        </td>
        <td>
            <a href="https://codepen.io/t_afif/pen/VwpYZNV">Codepen t_afif/VwpYZNV</a>
        </td>
    </tr>
</table>

是的！它开始移动了一点。不知道你是否注意到每次我们增加值时曲线的变化？当我们缩小以查看完整曲线时，它使我们的点 $(1,1)$ 在“视觉上”更接近于 $(0,1)$，这就是诀窍。

通过使用 `cubic-bezier(0,V,1,V)`，其中 $V$ 是一个非常大的值，并且初始状态和最终状态非常接近（或几乎相等），我们现在可以模拟一条抛物线。

一个例子胜过千言万语：

[Codepen t_aifi/ZEeYzNy](https://codepen.io/t_afif/pen/ZEeYzNy)

我将其中的“魔法般的”三次贝塞尔函数应用于最上面的动画部分，并在左侧应用了线性函数，这就为我们提供了我们想要的曲线。

## 深入研究数学

对于那些有数学头脑的人，我们可以进一步分解这种解释。我们其实可以使用以下公式定义三次贝塞尔曲线：

$$
P = (1-t)^3P_0 + 3(1-t)^2tP_1 + 3(1-t)t^2P_2 + t^3P_3
$$

每个点的定义如下：

$$
P_0 = (0, 0), P_1 = (0, V)
\\
P_2 = (1, V), P_3 = (1, 1)
$$

这为我们提供了 $x$ 和 $y$ 坐标的两个函数：

$$
\X(t) = 3(1-t)t^2 + t^3=3t^2 - 2t^3
\\
\Y(t) = 3(1-t)^2tV + 3(1-t)t^2V + t^3 = t^3 - 3Vt^2 + 3Vt
$$

$V$ 是我们的大值，$t$ 在 $[0, 1]$ 范围内。如果我们考虑前面的示例，$Y(t)$ 将为我们提供 `top` 的值，而 $X(t)$ 是时间进度。所以现在，点 $(X(t), Y(t))$ 将定义我们的曲线。

让我们找出 $Y(t)$ 的最大值，为此，我们需要找到 $t$ 的取值，满足 $Y′(t)=0$（满足 $Y$ 函数的导数等于 $0$ 时）：

$$
Y′(t) = 3t^2 − 6Vt + 3V
$$

$Y′(t)=0$ 是一个二次方程。我会跳过无聊的部分，给你算数的结果，那就是：

$$
t = V − \sqrt{V^2 - V}
$$

当 $V$ 是一个大值时，$t$ 将等于 $0.5$。因此，$Y(0.5)=Max$，$X(0.5)$ 将等于 $0.5$。这意味着我们在动画的中间点达到最大值，这符合我们想要的抛物线。

此外，$Y(0.5)$ 将给我们 $\frac{1+6V}{8}$，这将使我们能够找到基于 $V$ 的最大值。由于我们总是使用较大的 $V$ 值，我们可以简化为 $\frac{6V}{8}=0.75V$。

我们在最后一个例子中使用了 $V=500$，所以那里的最大值会达到 $365$（或 $37500\%$），我们得到以下结果：

* 初始状态（$0$）：`top: 200px`
* 最终状态（$1$）：`top: 199.5px`

$0$ 和 $1$ 之间存在 $−0.5px$ 的差异。我们称之为**增量**。对于 $375$（或 $37500\%$），我们有一个方程 $375∗−0.5px=−187.5px$。我们的动画元素达到了 `top: 12.5px` ($200px−187.5px$) 并为我们提供了以下动画：

```text
top: 200px（0% 的时间）→ top: 12.5px（50% 的时间）→ top: 199.5px（100% 的时间）
```

或者，用另一种方式表达：

```text
top: 200px（0%）→ top: 12.5px（50%）→ top: 200px（100%）
```

让我们做相反的逻辑。我们应该使用 $V$ 的什么值来使我们的元素达到 `top: 0px`？动画将是`200px → 0px → 199.5px`，所以我们需要 $−200px$ 来达到 $0px$。我们的增量总是等于 $−0.5px$。最大值将等于 $\frac{2000}{0.5}=400$，因此 $0.75V=400$，这意味着 $V=533.33$。

我们的元素碰到了容器的顶部啦！

这是一个总结我们刚刚做的数学的插图：

[![CSS Parobic 曲线](https://res.cloudinary.com/practicaldev/image/fetch/s--uSjOLuTx--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/sum-up-parabolic.png%3Fresize%3D1000%252C560%26ssl%3D1)](https://res.cloudinary.com/practicaldev/image/fetch/s--uSjOLuTx--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i1.wp.com/css-tricks.com/wp-content/uploads/2021/05/sum-up-parabolic.png%3Fresize%3D1000%252C560%26ssl%3D1)

---

## 正弦曲线

我们将使用几乎完全相同的技巧来创建正弦曲线，但使用不同的公式。这次我们将使用 `cubic-bezier(0.5,V,0.5,-V)`。

就像我们之前所做的那样，让我们​​看看当我们增加值时曲线将如何演变：

[![CSS 正弦曲线](https://res.cloudinary.com/practicaldev/image/fetch/s--qF3iaSrl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5k1bc2cq87wfthl6c6au.png)](https://res.cloudinary.com/practicaldev/image/fetch/s--qF3iaSrl--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://dev-to-uploads.s3.amazonaws.com/uploads/articles/5k1bc2cq87wfthl6c6au.png)

我想你现在可能明白了，使用较大的 $V$ 值可以让我们接近正弦曲线。

这是另一个具有连续动画的动画 —— 真正的正弦动画！

### 数学

让我们来计算一下这个！遵循与之前相同的公式，我们将得到以下函数：

$$
X(t)=\frac{3}{2}(1-t)^2t + \frac{3}{2}(1-t)t^2 + t^3 = \frac{3}{2} t - \frac{3}{2}t^3 + t^3
\\
Y(t) = 3(1-t)^2tV - 3(1-t)t^2V + t^3 = (6V+1)t^3 - 9Vt^2 + 3Vt
$$

这次我们需要找到 $Y(t)$ 的最小值和最大值。$Y′(t)=0$ 会给我们两个解。解下面这个关于 $Y$ 的方程：

$$
Y'(t)=3(6V+1)t^2-18Vt+3V=0
$$

……我们得到：

$$
t' = \frac{3V+\sqrt{3V^2-V}}{6V+1}, t'' = \frac{3V-\sqrt{3V^2-V}}{6V+1},
$$

对于 $V$ 的大值，我们有 $t′=0.211$ 和 $t′′=0.789$。这意味着 $Y(0.211)=Max$ 和 $Y(0.789)=Min$。这也意味着 $X(0.211)=0.26$ 和 $X(0.789)=0.74$。换句话说，我们在 $26\%$ 的时间达到最大值，在 $74\%$ 的时间达到最小值。

$Y(0.211)$ 等于 $0.289V$，$Y(0.789)$ 等于 $−0.289V$。考虑到 $V$ 非常大，我们得到了一些四舍五入的值。

我们的正弦曲线也应该在一半的时间（或 $X(t)=0.5$）穿过 $x$ 轴（或 $Y(t)=0$）。为了证明这一点，我们使用 $Y(t)$ 的第二个导数 —— 它应该等于 $0$ —— 所以 $Y′′(t)=0$。

$$
Y′′(t)=6(6V+1)t−18V=0
$$

解决方案是 $\frac{3V}{6V + 1}$，对于大 $V$ 值，解决方案是 $0.5$。这给了我们 $Y(0.5)=$ 和 $X(0.5)=0.5$，这证实了我们的曲线穿过了 $(0.5, 0)$ 点。

现在让我们考虑前面的例子，并尝试找到让我们回到 `top: 0%` 的 VVV 值。我们有：

* 初始状态 ($0$)：`top: 50%`
* 最终状态（$1$）：`top: 49.9%`
* 增量：$−0.1%$

我们需要 $−50%$ 才能达到 `top: 0%`，所以 $0.289V∗−0.1\%=−50\%$ 让我们可以得出 $V=1730.10$。

[codepen t_afif/KKWwKpa](https://codepen.io/t_afif/pen/KKWwKpa)

如你所见，我们的元素接触到容器的顶部并在容器的底部消失一段时间，以此往复，因为我们有以下动画：

``
top: 50% → top: 0% → top: 50% → top: 100% → top:50% → 等等……
``

一张图来总结计算：

[![CSS sinusoidal curve](https://res.cloudinary.com/practicaldev/image/fetch/s--snmrmnD4--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/sum-up-sinusoidal-1.png%3Fresize%3D1000%252C583%26ssl%3D1)](https://res.cloudinary.com/practicaldev/image/fetch/s--snmrmnD4--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/sum-up-sinusoidal-1.png%3Fresize%3D1000%252C583%26ssl%3D1)

以及一起说明所有曲线的示例：

[codepen t_afif/RwpNwWz](https://codepen.io/t_afif/pen/RwpNwWz)

是的，你看到了四个曲线！如果你仔细观察，你会注意到我使用了两种不同的动画，一个是 $49.9%$（$−0.01%$ 的增量），另一个是 $50.1%$（$+0.01%$ 的增量）。通过改变增量的符号，我们可以控制曲线的方向。我们还可以控制三次贝塞尔曲线的其他参数（不是应该保持大值的 $V$ 参数）以从相同的曲线创建更多变化。

[Codepen t_afif/qBrEBbJ](https://codepen.io/t_afif/pen/qBrEBbJ)

下面是一个交互式演示：

[Codepen t_afif/OJpPJNV](https://codepen.io/t_afif/pen/OJpPJNV)

---

## 回到我们的例子

让我们回到最初的示例，球以无穷大符号的形状四处移动。我简单地结合了两个正弦动画来使其工作。

如果我们将之前所做的与多个动画的概念结合起来，我们可以得到惊人的结果。这里再次是初始示例，这次是交互式演示。更改下面 Codepen 中的值并静候魔法～

[Codepen t_afif/rNyaNMJ](https://codepen.io/t_afif/pen/rNyaNMJ)

让我们更进一步，在混合中添加一些 CSS Houdini。由于 `@property` 的帮助，我们可以为复杂的转换声明设置动画（但目前 CSS Houdini 仅被 Chrome 和 Edge 支持）。

[Codepen t_afif/MWpYWbO](https://codepen.io/t_afif/pen/MWpYWbO)

你可以用它画什么样的形状？以下是我能够制作的一些：

[![CSS 外星人绘图](https://res.cloudinary.com/practicaldev/image/fetch/s--Xi6-3LDI--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i0.wp .com/css-tricks.com/wp-content/uploads/2021/05/cubic-bezier-spirographs.jpg%3Fresize%3D1000%252C550%26ssl%3D1)](https://res.cloudinary.com/practicaldev/image/fetch/s--Xi6-3LDI--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://i0.wp.com/css-tricks.com/wp-content/uploads/2021/05/cubic-bezier-spirographs.jpg%3Fresize%3D1000%252C550%26ssl%3D1)

这是一个螺旋图动画：

[Codepen t_afif/RwpNwKb](https://codepen.io/t_afif/pen/RwpNwKb)

还有一个没有 CSS Houdini 的版本：

[Codepen t_afif/GRWgRWg](https://codepen.io/t_afif/pen/GRWgRWg)

从这些例子中可以看出一些事情：

* 每个关键帧仅使用一个包含增量的声明来定义。
* 元素的位置和动画是独立的。我们可以轻松地将元素放置在任何地方，而无需调整动画。
* 我们没有进行任何计算。没有大量的角度或像素值。我们只需要关键帧中的一个小值和 `cubic-bezier()` 函数中的一个大值。
* 只需调整持续时间值即可控制整个动画。

---

## 过渡呢？

同样的技术也可以用于 CSS transition 属性，因为它在计时功能方面遵循相同的逻辑。这很棒，因为我们能够在创建一些复杂的悬停效果时避免关键帧。

这是我在没有关键帧的情况下所做的。如果你关注我，你会记得它们是[我的下划线/覆盖动画集合](https://dev.to/afif/series/12016) 😉

[Codepen t_afif/mdWydmd](https://codepen.io/t_afif/pen/mdWydmd)

由于抛物线，马里奥正在跳跃。我们根本不需要关键帧来创建悬停时的抖动动画。正弦曲线完全能够完成所有工作。

这是马里奥的另一个版本，这次使用的是 CSS Houdini。而且，是的，由于抛物线，他仍在跳跃：

[Codepen t_afif/abJzbWR](https://codepen.io/t_afif/pen/abJzbWR)

为了更好地衡量，这里有更多没有关键帧的花哨悬停效果（同样，仅限 Chrome 和 Edge）。我下一个系列的剧透😜

[Codepen t_afif/poevowW](https://codepen.io/t_afif/pen/poevowW)

---

## 就是这样！

现在你有了一些神奇的 `cubic-bezier()` 曲线，也了解到了它们背后的数学。当然，好处是像这样的自定义计时功能让我们可以在没有我们通常需要的复杂关键帧的情况下制作精美的动画。

我知道不是每个人都有数学头脑，这没关系。有一些工具可以提供帮助，例如 Matthew Lein 的 [Ceaser](https://matthewlein.com/tools/ceaser)，它可以让我们拖动曲线点来获得所需的内容。而且，如果我们还没有为它添加书签，[cubic-bezier.com](https://cubic-bezier.com/) 是另一个选择。如果你想在 CSS 世界之外玩三次贝塞尔曲线，我推荐使用一下 [desmos](https://www.desmos.com/calculator/ebdtbxgbq0?lang=fr)，你可以在那里看到一些数学公式。

不管你如何获得你的 `cubic-bezier()` 函数，希望现在你已经了解了它们的力量，以及了解了它们使如何在这个过程中帮助编写更好的代码。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
